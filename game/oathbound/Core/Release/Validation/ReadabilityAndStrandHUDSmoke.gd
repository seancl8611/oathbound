extends Node

const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")
const HUB_HUD_SCRIPT = preload("res://GUI/HubHUD.gd")
const RUN_HUD_SCRIPT = preload("res://Core/Prosthetics/OathboundRunHUD.gd")
const TITLE_SCENE = preload("res://TitleScreen/menu.tscn")
const SHRINE_SCENE = preload("res://Core/Chambers/Types/ShrineChamber.tscn")

var _failed: bool = false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		push_error("[ReadabilityAndStrandHUDSmoke] FAIL - SettingsManager unavailable")
		get_tree().quit(1)
		return

	var previous_high_contrast: bool = bool(SettingsManager.get_value("high_contrast", false))
	SettingsManager.set_value("high_contrast", true)

	_validate_shared_styler()
	await _validate_front_end()
	await _validate_strand_hud()
	await _validate_run_hud_release_presentation()
	await _validate_shrine_release_presentation()

	SettingsManager.set_value("high_contrast", previous_high_contrast)
	if _failed:
		get_tree().quit(1)
		return

	print("[ReadabilityAndStrandHUDSmoke] PASS - high contrast active | front end styled | Strand wallet Mist+Scrolls only | Run HUD localization+glyphs | Shrine localization+glyphs")
	get_tree().quit(0)


func _validate_shared_styler() -> void:
	var root := Control.new()
	var panel := PanelContainer.new()
	var label := Label.new()
	var button := Button.new()
	label.text = "Readable"
	button.text = "Action"
	root.add_child(panel)
	panel.add_child(label)
	root.add_child(button)
	add_child(root)

	READABILITY_STYLER.apply(root)
	_expect(label.get_theme_color("font_color") == Color.WHITE, "High Contrast did not force readable label text")
	_expect(panel.has_theme_stylebox_override("panel"), "High Contrast did not add a panel contrast frame")
	_expect(button.has_theme_stylebox_override("normal"), "High Contrast did not add a button contrast frame")
	_expect(button.get_theme_color("font_color") == Color.WHITE, "High Contrast did not style button text")
	root.queue_free()


func _validate_front_end() -> void:
	var front_end: Node = TITLE_SCENE.instantiate()
	add_child(front_end)
	await get_tree().process_frame
	await get_tree().process_frame

	var script_value: Variant = front_end.get_script()
	var script_path: String = (script_value as Script).resource_path if script_value is Script else ""
	_expect(script_path == "res://TitleScreen/OathboundFrontEnd.gd", "front end is not using the accessibility presentation layer")

	var continue_button: Button = null
	for node: Node in front_end.find_children("*", "Button", true, false):
		if node is Button and (node as Button).text == "Continue":
			continue_button = node as Button
			break
	_expect(continue_button != null, "front end Continue button missing")
	if continue_button != null:
		_expect(continue_button.has_theme_stylebox_override("normal"), "front end did not receive High Contrast styling")

	front_end.queue_free()
	await get_tree().process_frame


func _validate_strand_hud() -> void:
	var hud_value: Variant = HUB_HUD_SCRIPT.new()
	_expect(hud_value is CanvasLayer, "Strand HUD did not instantiate as CanvasLayer")
	if not (hud_value is CanvasLayer):
		return
	var hud: CanvasLayer = hud_value as CanvasLayer
	add_child(hud)
	await get_tree().process_frame
	await get_tree().process_frame

	var labels: Array[String] = []
	var mist_label: Label = null
	for node: Node in hud.find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var text: String = (node as Label).text
		labels.append(text)
		if text == "Mist":
			mist_label = node as Label

	_expect("Mist" in labels, "Strand HUD is missing Mist")
	_expect("Scrolls" in labels, "Strand HUD is missing Scrolls")
	_expect("Keeper Material" not in labels, "Strand HUD incorrectly exposes Keeper material as a permanent counter")
	_expect("Twin Maws Material" not in labels, "Strand HUD incorrectly exposes Twin Maws material as a permanent counter")
	_expect("Shogun Material" not in labels, "Strand HUD incorrectly exposes Shogun material as a permanent counter")
	if mist_label != null:
		_expect(mist_label.get_theme_color("font_color") == Color.WHITE, "Strand HUD did not receive High Contrast styling")

	hud.queue_free()
	await get_tree().process_frame


func _validate_run_hud_release_presentation() -> void:
	var previous_locale: String = TranslationServer.get_locale()
	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"ui.run_hud.spirit", &"ESPRIT HUD TEST")
	translation.add_message(&"ui.currency.scrolls", &"PARCHEMINS HUD TEST")
	translation.add_message(&"catalog.prosthetic.beast_whistle.name", &"SIFFLET TEST")
	translation.add_message(&"aspect.wolf.name", &"LOUP HUD TEST")
	translation.add_message(&"ui.run_hud.corruption_value", &"CORRUPTION HUD %d / 100")
	translation.add_message(&"ui.run_hud.aspect_tier_shrine_ready", &"%s NIVEAU %d PRET TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	INPUT_GLYPHS.ensure_controller_defaults()

	var hud_value: Variant = RUN_HUD_SCRIPT.new()
	_expect(hud_value is CanvasLayer, "Run HUD release wrapper did not instantiate as CanvasLayer")
	if hud_value is CanvasLayer:
		var hud: CanvasLayer = hud_value as CanvasLayer
		add_child(hud)
		await get_tree().process_frame
		await get_tree().process_frame

		var spirit_label: Label = null
		for node: Node in hud.find_children("*", "Label", true, false):
			if node is Label and (node as Label).text == "ESPRIT HUD TEST":
				spirit_label = node as Label
				break
		_expect(spirit_label != null, "Run HUD Spirit label did not resolve stable localization key")
		if spirit_label != null:
			_expect(spirit_label.get_theme_color("font_color") == Color.WHITE, "Run HUD localized Spirit label did not receive High Contrast styling")

		hud.call("update_prosthetic_info", "beast_whistle", 15, 0, 0)
		_expect(str(hud.call("_prosthetic_icon_text_for_playtest")) == "SIFFL", "Run HUD Prosthetic icon text did not derive from localized stable Prosthetic ID")
		_expect(str(hud.call("_localized_reward_label_for_playtest", "scroll")) == "PARCHEMINS HUD TEST", "Run HUD reward toast label did not resolve stable currency key")

		var corruption_copy: Dictionary = hud.call("_format_corruption_copy_for_playtest", 100, "full", "wolf", 2)
		_expect(str(corruption_copy.get("label", "")) == "CORRUPTION HUD 100 / 100", "Run HUD Corruption value did not resolve stable UI key")
		_expect(str(corruption_copy.get("detail", "")) == "LOUP HUD TEST NIVEAU 2 PRET TEST", "Run HUD Aspect/Tier/Shrine-ready copy did not resolve stable Aspect/UI keys")

		hud.call("_set_input_family_for_playtest", INPUT_GLYPHS.FAMILY_CONTROLLER)
		_expect(str(hud.call("_prosthetic_binding_text_for_playtest")) == "[Y]", "Run HUD Prosthetic hint did not switch to controller glyph")
		hud.call("_set_input_family_for_playtest", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
		_expect(str(hud.call("_prosthetic_binding_text_for_playtest")) == INPUT_GLYPHS.preferred_label("prosthetic", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE), "Run HUD Prosthetic hint did not recover keyboard binding")

		hud.queue_free()
		await get_tree().process_frame

	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)


func _validate_shrine_release_presentation() -> void:
	if typeof(MetaProgress) != TYPE_OBJECT or typeof(AspectRuntime) != TYPE_OBJECT or typeof(CorruptionRuntime) != TYPE_OBJECT:
		_expect(false, "Shrine presentation test requires MetaProgress, AspectRuntime, and CorruptionRuntime")
		return

	var previous_locale: String = TranslationServer.get_locale()
	var previous_awakened: bool = bool(MetaProgress.returning_blood_awakened)
	var previous_aspect: String = str(AspectRuntime.selected_aspect)
	var previous_tier: int = int(AspectRuntime.tier)
	var previous_corruption: int = int(CorruptionRuntime.call("get_corruption"))

	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"ui.shrine.prompt", &"SANCTUAIRE TEST %s")
	translation.add_message(&"ui.shrine.title.returning_blood", &"SANCTUAIRE SANG TEST")
	translation.add_message(&"ui.shrine.state.summary", &"%s NIVEAU %d CORRUPTION %d TEST")
	translation.add_message(&"ui.shrine.current", &"ACTUEL TEST: %s")
	translation.add_message(&"ui.shrine.next", &"SUIVANT TEST: %s")
	translation.add_message(&"ui.shrine.detail.full_choice", &"CHOIX PLEIN TEST")
	translation.add_message(&"ui.shrine.action.resist_values", &"RESISTER TEST")
	translation.add_message(&"ui.shrine.action.embrace_values", &"EMBRASSER TEST %d")
	translation.add_message(&"ui.shrine.action.leave", &"QUITTER SANCTUAIRE TEST")
	translation.add_message(&"aspect.wolf.name", &"LOUP SANCTUAIRE TEST")
	translation.add_message(&"shrine.tier_headline.wolf.1", &"TIER UN TEST")
	translation.add_message(&"shrine.tier_headline.wolf.2", &"TIER DEUX TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")

	MetaProgress.returning_blood_awakened = true
	if AspectRuntime.has_method("synchronize_campaign_state"):
		AspectRuntime.call("synchronize_campaign_state", false)
	_expect(bool(AspectRuntime.call("select_aspect", "wolf")), "Shrine test could not select awakened Wolf Aspect")
	AspectRuntime.call("set_tier", 1)
	CorruptionRuntime.call("set_corruption_for_playtest", 100)

	var shrine: Node = SHRINE_SCENE.instantiate()
	add_child(shrine)
	await get_tree().process_frame
	await get_tree().process_frame

	shrine.call("_set_input_family_for_playtest", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
	_expect(str(shrine.call("_prompt_text_for_playtest")) == "SANCTUAIRE TEST [E]", "Shrine prompt did not resolve localized keyboard binding")
	shrine.call("_set_input_family_for_playtest", INPUT_GLYPHS.FAMILY_CONTROLLER)
	_expect(str(shrine.call("_prompt_text_for_playtest")) == "SANCTUAIRE TEST [A]", "Shrine prompt did not switch to localized controller binding")

	var snapshot: Dictionary = shrine.call("_presentation_snapshot_for_playtest")
	_expect(str(snapshot.get("title", "")) == "SANCTUAIRE SANG TEST", "Shrine title did not resolve stable UI key")
	_expect(str(snapshot.get("state", "")) == "LOUP SANCTUAIRE TEST NIVEAU 1 CORRUPTION 100 TEST", "Shrine state summary did not resolve stable Aspect/UI keys")
	_expect(str(snapshot.get("current", "")) == "ACTUEL TEST: TIER UN TEST", "Shrine current Tier headline did not resolve Aspect+Tier key")
	_expect(str(snapshot.get("next", "")) == "SUIVANT TEST: TIER DEUX TEST", "Shrine next Tier headline did not resolve Aspect+Tier key")
	_expect(str(snapshot.get("detail", "")) == "CHOIX PLEIN TEST", "Shrine full-choice explanation did not resolve state key")
	_expect(str(snapshot.get("resist", "")) == "RESISTER TEST", "Shrine Resist action did not resolve stable UI key")
	_expect(str(snapshot.get("embrace", "")) == "EMBRASSER TEST 2", "Shrine Embrace action did not resolve stable UI key")
	_expect(str(snapshot.get("leave", "")) == "QUITTER SANCTUAIRE TEST", "Shrine Leave action did not resolve stable UI key")
	_expect(bool(snapshot.get("resist_visible", false)) and bool(snapshot.get("embrace_visible", false)), "Shrine full-choice state did not expose Resist + Embrace")

	var prompt: Label = shrine.get_node_or_null("InteractShrine/Prompt") as Label
	if prompt != null:
		_expect(prompt.get_theme_color("font_color") == Color.WHITE, "Shrine prompt did not receive High Contrast styling")

	shrine.queue_free()
	await get_tree().process_frame

	MetaProgress.returning_blood_awakened = previous_awakened
	if AspectRuntime.has_method("synchronize_campaign_state"):
		AspectRuntime.call("synchronize_campaign_state", false)
	if previous_awakened and not previous_aspect.is_empty():
		AspectRuntime.call("select_aspect", previous_aspect)
		AspectRuntime.call("set_tier", previous_tier)
	CorruptionRuntime.call("set_corruption_for_playtest", previous_corruption)
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[ReadabilityAndStrandHUDSmoke] FAIL - %s" % message)
