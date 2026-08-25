extends Node2D

## Hub — Central hub scene connecting all player-facing stations.
## Interaction prompts are presentation-owned here so station gameplay scripts never
## hard-code keyboard/controller glyphs or duplicate rebinding logic.

const RUN_RESULTS_OVERLAY = preload("res://Core/Release/OathboundAccessibleRunResultsOverlay.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")
const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")

const INTERACTION_PROMPTS: Dictionary = {
	"Boat": {"key": "ui.strand.station.boat", "fallback": "Boat"},
	"ForgeBench": {"key": "ui.strand.station.forge", "fallback": "Forge"},
	"CodexBoard": {"key": "ui.strand.station.discovery_board", "fallback": "Discovery Board"},
	"Bloodwell": {"key": "ui.strand.station.bloodwell", "fallback": "Bloodwell"},
	"BloodMirror": {"key": "ui.strand.station.blood_mirror", "fallback": "Blood Mirror"},
	"MerchantStall": {"key": "ui.strand.station.merchant", "fallback": "Merchant"},
	"PracticeGrounds": {"key": "ui.strand.station.practice", "fallback": "Practice Grounds"},
	"KeeperNPC": {"key": "npc.keeper.name", "fallback": "Keeper"},
	"ScribeNPC": {"key": "npc.scribe.name", "fallback": "Scribe"},
	"RavenNPC": {"key": "ui.strand.station.raven_notices", "fallback": "Raven / Notices"},
	"UndeadSamuraiNPC": {"key": "npc.undead_samurai.name", "fallback": "Undead Samurai"},
	"SmithNPC": {"key": "npc.smith.name", "fallback": "Smith"},
	"PeddlerNPC": {"key": "npc.peddler.name", "fallback": "Peddler"},
}

@onready var player: Node = null
var _currency_hud: Node
var _prompt_input_family: String = INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE


func _ready() -> void:
	INPUT_GLYPHS.ensure_controller_defaults()
	_find_player()
	_setup_currency_hud()
	_connect_stations()
	_connect_prompt_settings()
	call_deferred("_refresh_interaction_prompts")
	call_deferred("_show_pending_run_result")


func _input(event: InputEvent) -> void:
	if not INPUT_GLYPHS.is_meaningful_family_switch_event(event):
		return
	var family: String = INPUT_GLYPHS.event_family(event)
	if family not in [INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE, INPUT_GLYPHS.FAMILY_CONTROLLER] or family == _prompt_input_family:
		return
	_prompt_input_family = family
	_refresh_interaction_prompts()


func _find_player() -> void:
	player = get_node_or_null("Player")
	if player == null:
		player = get_tree().root.get_node_or_null("Player")
	if player == null:
		var players: Array[Node] = get_tree().get_nodes_in_group("player")
		if not players.is_empty():
			player = players[0]

	if player:
		if not player.is_in_group("player"):
			player.add_to_group("player")
		var run_hud_value: Variant = player.get("run_hud")
		if run_hud_value is Node and (run_hud_value as Node).has_method("set_hub_mode"):
			(run_hud_value as Node).call("set_hub_mode", true)
	else:
		push_warning("[Hub] Player not found in scene tree.")


func _setup_currency_hud() -> void:
	var root: Window = get_tree().root
	var old_layer: Node = root.get_node_or_null("CurrencyHUDLayer")
	if old_layer:
		old_layer.queue_free()
	var old_hub: Node = root.get_node_or_null("HubHUD")
	if old_hub:
		old_hub.queue_free()

	var hub_hud_script: Script = load("res://GUI/HubHUD.gd")
	if hub_hud_script:
		_currency_hud = hub_hud_script.new()
		root.add_child(_currency_hud)


func _show_pending_run_result() -> void:
	if typeof(RecordsRuntime) != TYPE_OBJECT or not RecordsRuntime.has_method("consume_pending_result"):
		return
	var result: Dictionary = RecordsRuntime.consume_pending_result()
	if result.is_empty():
		return
	var overlay_value: Variant = RUN_RESULTS_OVERLAY.new()
	if not (overlay_value is CanvasLayer):
		push_error("[Hub] Could not create run-results overlay")
		return
	var overlay: CanvasLayer = overlay_value as CanvasLayer
	get_tree().root.add_child(overlay)
	overlay.present(result)


func _connect_prompt_settings() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	var binding_cb := Callable(self, "_on_prompt_binding_changed")
	if SettingsManager.has_signal("binding_changed") and not SettingsManager.is_connected("binding_changed", binding_cb):
		SettingsManager.connect("binding_changed", binding_cb)
	var settings_cb := Callable(self, "_on_prompt_settings_changed")
	if SettingsManager.has_signal("settings_changed") and not SettingsManager.is_connected("settings_changed", settings_cb):
		SettingsManager.connect("settings_changed", settings_cb)


func _on_prompt_binding_changed(action: String) -> void:
	if action == "interact":
		_refresh_interaction_prompts()


func _on_prompt_settings_changed() -> void:
	_refresh_interaction_prompts()


func _refresh_interaction_prompts() -> void:
	INPUT_GLYPHS.ensure_controller_defaults()
	var glyph: String = INPUT_GLYPHS.preferred_label("interact", _prompt_input_family)
	for station_value: Variant in INTERACTION_PROMPTS.keys():
		var station_name: String = str(station_value)
		var station: Node = get_node_or_null(station_name)
		if station == null:
			continue
		var label_value: Node = station.get_node_or_null("InteractPopup")
		if not (label_value is Label):
			continue
		var config: Dictionary = INTERACTION_PROMPTS[station_name]
		var prompt_label: Label = label_value as Label
		var station_text: String = LOCALIZATION.resolve(str(config.get("key", "")), str(config.get("fallback", station_name)))
		prompt_label.text = "%s %s" % [station_text, glyph]
		READABILITY_STYLER.apply(prompt_label)


func _set_prompt_input_family_for_playtest(family: String) -> void:
	if family not in [INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE, INPUT_GLYPHS.FAMILY_CONTROLLER]:
		return
	_prompt_input_family = family
	_refresh_interaction_prompts()


func _connect_stations() -> void:
	var boat: Node = get_node_or_null("Boat")
	if boat and boat.has_signal("run_started"):
		boat.connect("run_started", Callable(self, "_on_run_started"))

	var forge: Node = get_node_or_null("ForgeBench")
	if forge and forge.has_signal("prosthetic_equipped"):
		forge.connect("prosthetic_equipped", Callable(self, "_on_prosthetic_equipped"))

	var merchant: Node = get_node_or_null("MerchantStall")
	if merchant and merchant.has_signal("item_purchased"):
		merchant.connect("item_purchased", Callable(self, "_on_merchant_item_purchased"))

	var practice: Node = get_node_or_null("PracticeGrounds")
	if practice:
		if practice.has_signal("practice_started"):
			practice.connect("practice_started", Callable(self, "_on_practice_started"))
		if practice.has_signal("practice_ended"):
			practice.connect("practice_ended", Callable(self, "_on_practice_ended"))


func _on_run_started() -> void:
	print("[Hub] Run started — transitioning to dungeon...")


func _on_prosthetic_equipped(prosthetic_id: String) -> void:
	print("[Hub] Prosthetic equipped: ", prosthetic_id)
	Global.selected_weapon_name = prosthetic_id


func _on_merchant_item_purchased(item_id: String) -> void:
	print("[Hub] Merchant purchase: ", item_id)


func _on_practice_started() -> void:
	print("[Hub] Practice mode entered")


func _on_practice_ended() -> void:
	print("[Hub] Practice mode exited")


func _exit_tree() -> void:
	if _currency_hud and is_instance_valid(_currency_hud):
		_currency_hud.queue_free()
		_currency_hud = null

	if player and is_instance_valid(player):
		var run_hud_value: Variant = player.get("run_hud")
		if run_hud_value is Node and (run_hud_value as Node).has_method("set_hub_mode"):
			(run_hud_value as Node).call("set_hub_mode", false)
