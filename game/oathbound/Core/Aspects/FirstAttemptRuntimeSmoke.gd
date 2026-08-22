extends Node

## Headless contract smoke for FIRST_ATTEMPT.md's combat-loadout boundary.
## The runner uses a disposable user dir, but the project-check workflow intentionally
## runs several independent smoke processes in sequence. This contract therefore
## resets in-memory campaign-owned loadout state before asserting a clean first attempt
## so an earlier smoke that awakens Returning Blood cannot contaminate this process.

const CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const PLAYER_SCENE = preload("res://Player/aspect_player.tscn")
const HUB_SCENE = preload("res://World/HubScene.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	await _run_contract()
	if _failures.is_empty():
		print("[FirstAttemptRuntimeSmoke] PASS - base katana no Aspect awakening handoff")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[FirstAttemptRuntimeSmoke] %s" % failure)
		print("[FirstAttemptRuntimeSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _run_contract() -> void:
	if typeof(MetaProgress) != TYPE_OBJECT or typeof(AspectRuntime) != TYPE_OBJECT or typeof(CorruptionRuntime) != TYPE_OBJECT:
		_fail("required campaign runtimes missing")
		return

	# CorruptionRuntimeSmoke intentionally runs before this contract in CI and can
	# awaken Returning Blood, causing Strand progression to discover its first-return
	# campaign Relic. A genuine first-ever attempt has no Relic collection, so isolate
	# this smoke in memory without deleting the persistent file used by later tests.
	if typeof(RelicRuntime) == TYPE_OBJECT:
		RelicRuntime.unlocked_relics.clear()
		RelicRuntime.mastery_kills.clear()
		RelicRuntime.equipped_relic_id = ""

	MetaProgress.returning_blood_awakened = false
	AspectRuntime.synchronize_campaign_state(false)
	CorruptionRuntime.on_new_run(1)

	_expect(not bool(AspectRuntime.has_active_aspect()), "first attempt must have no active Aspect")
	_expect(str(AspectRuntime.selected_aspect).is_empty(), "pre-awakening selected Aspect id must be empty")
	_expect(int(AspectRuntime.tier) == 0, "pre-awakening Tier must remain 0")
	_expect(float(AspectRuntime.blood) == 0.0, "pre-awakening Blood must remain 0")
	_expect(str(AspectRuntime.blood_state()) == "unavailable", "pre-awakening Blood state must be unavailable")
	_expect(str(CorruptionRuntime.get_corruption_state()) == "hidden", "pre-awakening Corruption must remain hidden")
	_expect(not bool(AspectRuntime.select_aspect(CATALOG.WOLF)), "Aspect selection must be locked before Returning Blood awakens")

	var aspect_hud_value: Variant = AspectRuntime.get("_hud")
	if aspect_hud_value is CanvasLayer:
		_expect(not (aspect_hud_value as CanvasLayer).visible, "pre-awakening Aspect HUD must be hidden")

	# FIRST_ATTEMPT.md also excludes Relics from the first-ever loadout. On the clean
	# campaign used by this contract, the persistent Relic authority must therefore be
	# empty rather than silently supplying a post-awakening item.
	if typeof(RelicRuntime) == TYPE_OBJECT:
		_expect(str(RelicRuntime.equipped_relic_id).is_empty(), "fresh first attempt must have no equipped Relic")
		var unlocked_value: Variant = RelicRuntime.unlocked_relics
		_expect(unlocked_value is Dictionary and (unlocked_value as Dictionary).is_empty(), "fresh first attempt must have no unlocked Relics")

	AspectRuntime.set_tier(4)
	AspectRuntime.set_blood_for_playtest(100.0)
	_expect(int(AspectRuntime.tier) == 0, "pre-awakening Tier mutation must be rejected")
	_expect(float(AspectRuntime.blood) == 0.0, "pre-awakening Blood mutation must be rejected")

	var basics: Array = CATALOG.get_basic_profiles(CATALOG.NO_ASPECT, 0)
	_expect(basics.size() == 3, "base katana must expose three Basic profiles")
	if basics.size() == 3:
		_expect(str((basics[0] as Dictionary).get("id", "")) == "quick_slash", "base Basic 1 must be Quick Slash")
		_expect(str((basics[1] as Dictionary).get("id", "")) == "cross_cut", "base Basic 2 must be Cross Cut")
		_expect(str((basics[2] as Dictionary).get("id", "")) == "heavy_cleave", "base Basic 3 must be Heavy Cleave")
		for profile_value in basics:
			var profile: Dictionary = profile_value as Dictionary
			_expect(str(profile.get("action_trigger", "")) == "basic", "base Basics must keep the universal Basic Technique trigger")
			_expect(not bool(profile.get("blood_generation", true)), "base Basics must not generate Blood")

	var held: Dictionary = CATALOG.get_held_profile(CATALOG.NO_ASPECT, 0)
	var dash: Dictionary = CATALOG.get_dash_profile(CATALOG.NO_ASPECT, 0)
	var counter: Dictionary = CATALOG.get_counter_profile(CATALOG.NO_ASPECT, 0)
	_expect(str(held.get("id", "")) == "hold_thrust" and str(held.get("action_trigger", "")) == "held", "base Held Attack must be Thrust with Held trigger")
	_expect(str(dash.get("id", "")) == "dash_slash" and str(dash.get("action_trigger", "")) == "dash", "base Dash Attack must be Dash Slash with Dash trigger")
	_expect(str(counter.get("id", "")) == "counter_cut" and str(counter.get("action_trigger", "")) == "counter", "base Parry Counter must be Counter Cut with Counter trigger")
	_expect(not bool(held.get("blood_generation", true)) and not bool(dash.get("blood_generation", true)) and not bool(counter.get("blood_generation", true)), "pre-awakening base actions must never generate Blood")

	if typeof(ProstheticManager) == TYPE_OBJECT:
		_expect(str(ProstheticManager.equipped_prosthetic_id) == "beast_whistle", "fresh first attempt must equip Beast-Bane Whistle")

	var player: Node = PLAYER_SCENE.instantiate()
	add_child(player)
	await get_tree().process_frame
	if player.has_method("_get_combo_profile"):
		var live_basic: Dictionary = player.call("_get_combo_profile", 0)
		_expect(str(live_basic.get("id", "")) == "quick_slash", "live pre-awakening Player must resolve Quick Slash, not a Wolf attack")
	else:
		_fail("live Player does not expose combo-profile resolver")
	var player_snapshot: Variant = player.call("get_playtest_snapshot") if player.has_method("get_playtest_snapshot") else null
	if player_snapshot is Dictionary:
		_expect(str((player_snapshot as Dictionary).get("aspect", "")) == "", "live Player snapshot must expose no pre-awakening Aspect")
	player.queue_free()
	await get_tree().process_frame

	# The first genuine death unlocks selection but does not silently choose a kit.
	CorruptionRuntime.on_player_death()
	_expect(bool(MetaProgress.is_returning_blood_awakened()), "first death must awaken Returning Blood")
	_expect(not bool(AspectRuntime.has_active_aspect()), "awakening alone must not auto-select an Aspect")
	_expect(str(AspectRuntime.selected_aspect).is_empty(), "post-death handoff must wait for explicit Aspect selection")
	_expect(int(AspectRuntime.tier) == 0 and float(AspectRuntime.blood) == 0.0, "awakening handoff must start from Tier 0 / Blood 0")

	# The current Strand implementation uses The Well as the run-preparation surface.
	# An awakened player must be able to open the three-Aspect selector without an
	# Aspect already being active, and cancelling must clean up the root-level modal.
	var hub: Node = HUB_SCENE.instantiate()
	add_child(hub)
	await get_tree().process_frame
	var well: Node = hub.get_node_or_null("TheWell")
	if well == null:
		_fail("Hub must expose TheWell run-preparation station")
	else:
		well.call("_open_aspect_menu")
		await get_tree().process_frame
		var selector: Node = get_tree().root.get_node_or_null("AspectRunSetup")
		_expect(selector != null, "awakened The Well must open the Blood Aspect selector")
		if selector != null:
			var aspect_buttons: Array[Node] = selector.find_children("*", "Button", true, false)
			var aspect_labels: Array[String] = []
			for button_node: Node in aspect_buttons:
				var button := button_node as Button
				if button.text in ["Wolf", "Wraith", "Ronin"]:
					aspect_labels.append(button.text)
			_expect(aspect_labels.size() == 3, "awakened selector must offer Wolf, Wraith, and Ronin")
		well.call("_cancel_aspect_menu")
		await get_tree().process_frame
		_expect(get_tree().root.get_node_or_null("AspectRunSetup") == null, "cancelling Aspect selection must clean up the modal")
	hub.queue_free()
	await get_tree().process_frame

	_expect(bool(AspectRuntime.select_aspect(CATALOG.WOLF)), "awakened runtime must allow explicit Wolf selection")
	_expect(bool(AspectRuntime.has_active_aspect()), "explicit post-awakening selection must activate the Aspect runtime")
	_expect(str(AspectRuntime.selected_aspect) == CATALOG.WOLF, "selected Aspect must be Wolf after explicit selection")
	_expect(int(AspectRuntime.tier) == 0, "selected Aspect must begin at Tier 0")
	var wolf_basics: Array = CATALOG.get_basic_profiles(AspectRuntime.selected_aspect, AspectRuntime.tier)
	_expect(not wolf_basics.is_empty() and str((wolf_basics[0] as Dictionary).get("id", "")) == "wolf_fang_slash", "post-awakening selection must restore the authored Wolf weapon kit")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
