extends "res://GUI/RunHUD.gd"

## Current run HUD overlay.
## - preserves the imported HUD layout
## - presents canonical 0-100 Prosthetic Spirit
## - adds the approved awakened-only Corruption / Shrine-ready state
## - localizes player-facing run HUD copy without changing combat/runtime ownership
## - keeps the Prosthetic input hint synchronized with active input family + rebindings
## - applies the launch High Contrast readability treatment without changing HUD semantics

const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")

var _corruption_root: Control
var _corruption_panel: PanelContainer
var _corruption_bar: ProgressBar
var _corruption_label: Label
var _corruption_detail: Label
var _spirit_title_label: Label
var _prosthetic_binding_label: Label
var _hud_input_family: String = INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE


func _ready() -> void:
	INPUT_GLYPHS.ensure_controller_defaults()
	super._ready()
	_capture_release_labels()
	_refresh_static_release_copy()
	_connect_release_input_settings()
	_refresh_prosthetic_binding_label()
	_build_corruption_hud()
	_connect_corruption_runtime()
	_refresh_corruption_hud()
	call_deferred("_apply_readability")


func _input(event: InputEvent) -> void:
	if not INPUT_GLYPHS.is_meaningful_family_switch_event(event):
		return
	var family: String = INPUT_GLYPHS.event_family(event)
	if family not in [INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE, INPUT_GLYPHS.FAMILY_CONTROLLER] or family == _hud_input_family:
		return
	_hud_input_family = family
	_refresh_prosthetic_binding_label()


func update_spirit(current: int, maximum: int) -> void:
	var old_spirit: int = _spirit
	_spirit = maxi(0, current)
	_spirit_max = maxi(1, maximum)
	var segment_count: int = maxi(1, _spirit_pips.size())

	for index: int in range(_spirit_pips.size()):
		var pip := _spirit_pips[index] as ColorRect
		var threshold: float = float(index + 1) / float(segment_count)
		var filled: bool = float(_spirit) / float(_spirit_max) >= threshold - 0.0001
		pip.color = COL_SPIRIT_FILLED if filled else COL_SPIRIT_EMPTY

	if current > old_spirit:
		_show_spirit_pop(current - old_spirit)


func update_prosthetic_info(prosthetic_id: String, spirit_cost: int, sockets: int, filled: int) -> void:
	super.update_prosthetic_info(prosthetic_id, spirit_cost, sockets, filled)
	if _prosthetic_icon_label == null:
		return
	var fallback_name: String = prosthetic_id.replace("_", " ").capitalize()
	if typeof(ProstheticManager) == TYPE_OBJECT and ProstheticManager.has_method("get_prosthetic"):
		var prosthetic_value: Variant = ProstheticManager.get_prosthetic(prosthetic_id)
		if prosthetic_value != null and prosthetic_value.get("display_name") != null:
			fallback_name = str(prosthetic_value.get("display_name"))
	var localized_name: String = LOCALIZATION.catalog_name("prosthetic", prosthetic_id, fallback_name)
	_prosthetic_icon_label.text = _compact_prosthetic_label(localized_name)


func show_currency_toast(reward_key: String, amount: int) -> void:
	super.show_currency_toast(reward_key, amount)
	if _toast_container == null or _toast_container.get_child_count() <= 0:
		return
	var latest_row: Node = _toast_container.get_child(_toast_container.get_child_count() - 1)
	var labels: Array[Node] = latest_row.find_children("*", "Label", true, false)
	if labels.size() >= 2 and labels[1] is Label:
		(labels[1] as Label).text = _localized_reward_label(reward_key)
	_apply_readability()


func _capture_release_labels() -> void:
	if _root == null:
		return
	for node: Node in _root.find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var label := node as Label
		if label.text == "SPIRIT" and _spirit_title_label == null:
			_spirit_title_label = label
		elif label.text == "Q" and _prosthetic_binding_label == null:
			_prosthetic_binding_label = label


func _refresh_static_release_copy() -> void:
	if _spirit_title_label != null:
		_spirit_title_label.text = LOCALIZATION.ui("run_hud.spirit", "SPIRIT")


func _connect_release_input_settings() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	var binding_cb := Callable(self, "_on_release_binding_changed")
	if SettingsManager.has_signal("binding_changed") and not SettingsManager.is_connected("binding_changed", binding_cb):
		SettingsManager.connect("binding_changed", binding_cb)
	var settings_cb := Callable(self, "_on_release_settings_changed")
	if SettingsManager.has_signal("settings_changed") and not SettingsManager.is_connected("settings_changed", settings_cb):
		SettingsManager.connect("settings_changed", settings_cb)


func _on_release_binding_changed(action: String) -> void:
	if action == "prosthetic":
		_refresh_prosthetic_binding_label()


func _on_release_settings_changed() -> void:
	_refresh_prosthetic_binding_label()
	call_deferred("_apply_readability")


func _refresh_prosthetic_binding_label() -> void:
	if _prosthetic_binding_label == null:
		return
	INPUT_GLYPHS.ensure_controller_defaults()
	_prosthetic_binding_label.text = INPUT_GLYPHS.preferred_label("prosthetic", _hud_input_family)


func _set_input_family_for_playtest(family: String) -> void:
	if family not in [INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE, INPUT_GLYPHS.FAMILY_CONTROLLER]:
		return
	_hud_input_family = family
	_refresh_prosthetic_binding_label()


func _prosthetic_binding_text_for_playtest() -> String:
	return _prosthetic_binding_label.text if _prosthetic_binding_label != null else ""


func _prosthetic_icon_text_for_playtest() -> String:
	return _prosthetic_icon_label.text if _prosthetic_icon_label != null else ""


func _localized_reward_label_for_playtest(reward_key: String) -> String:
	return _localized_reward_label(reward_key)


func _format_corruption_copy_for_playtest(current: int, state: String, aspect_id: String, tier: int) -> Dictionary:
	return _format_corruption_copy(current, state, aspect_id, tier)


func _localized_reward_label(reward_key: String) -> String:
	match reward_key:
		"gold": return LOCALIZATION.ui("currency.gold", "Gold")
		"mist": return LOCALIZATION.ui("currency.mist", "Mist")
		"scroll": return LOCALIZATION.ui("currency.scrolls", "Scrolls")
		"maxhp": return LOCALIZATION.ui("run_hud.max_hp", "Max HP")
		"maxposture": return LOCALIZATION.ui("run_hud.max_posture", "Max Posture")
		"emblem": return LOCALIZATION.ui("run_hud.legacy_boss_material", "Boss material")
		_: return LOCALIZATION.ui("run_hud.reward.%s" % reward_key, reward_key.capitalize())


func _compact_prosthetic_label(localized_name: String) -> String:
	var cleaned: String = localized_name.strip_edges()
	if cleaned.is_empty():
		return ""
	var words: PackedStringArray = cleaned.split(" ", false)
	var first_word: String = words[0] if not words.is_empty() else cleaned
	return first_word.substr(0, mini(5, first_word.length())).to_upper()


func _build_corruption_hud() -> void:
	_corruption_root = Control.new()
	_corruption_root.name = "CorruptionHUD"
	_corruption_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_corruption_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_corruption_root)

	_corruption_panel = PanelContainer.new()
	_corruption_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_corruption_panel.offset_left = -254.0
	_corruption_panel.offset_top = 16.0
	_corruption_panel.offset_right = -16.0
	_corruption_panel.offset_bottom = 91.0
	_corruption_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.035, 0.075, 0.90)
	style.border_color = Color(0.52, 0.20, 0.35, 0.75)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.set_content_margin_all(8)
	_corruption_panel.add_theme_stylebox_override("panel", style)
	_corruption_root.add_child(_corruption_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)
	_corruption_panel.add_child(vbox)

	_corruption_label = Label.new()
	_corruption_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(_corruption_label)

	_corruption_bar = ProgressBar.new()
	_corruption_bar.min_value = 0.0
	_corruption_bar.max_value = 100.0
	_corruption_bar.show_percentage = false
	_corruption_bar.custom_minimum_size = Vector2(220, 9)
	vbox.add_child(_corruption_bar)

	_corruption_detail = Label.new()
	_corruption_detail.add_theme_font_size_override("font_size", 11)
	_corruption_detail.modulate = Color(0.78, 0.75, 0.84)
	vbox.add_child(_corruption_detail)


func _connect_corruption_runtime() -> void:
	var runtime := get_node_or_null("/root/CorruptionRuntime")
	if runtime != null:
		var corruption_cb := Callable(self, "_on_corruption_changed")
		if runtime.has_signal("corruption_changed") and not runtime.is_connected("corruption_changed", corruption_cb):
			runtime.connect("corruption_changed", corruption_cb)
		var awakening_cb := Callable(self, "_on_returning_blood_state_changed")
		if runtime.has_signal("returning_blood_state_changed") and not runtime.is_connected("returning_blood_state_changed", awakening_cb):
			runtime.connect("returning_blood_state_changed", awakening_cb)
	if typeof(AspectRuntime) == TYPE_OBJECT:
		var tier_cb := Callable(self, "_on_aspect_tier_changed")
		if AspectRuntime.has_signal("tier_changed") and not AspectRuntime.is_connected("tier_changed", tier_cb):
			AspectRuntime.connect("tier_changed", tier_cb)
		var aspect_cb := Callable(self, "_on_aspect_changed")
		if AspectRuntime.has_signal("aspect_changed") and not AspectRuntime.is_connected("aspect_changed", aspect_cb):
			AspectRuntime.connect("aspect_changed", aspect_cb)


func _on_corruption_changed(_current: int, _maximum: int, _state: String) -> void:
	_refresh_corruption_hud()


func _on_returning_blood_state_changed(_awakened: bool) -> void:
	_refresh_corruption_hud()


func _on_aspect_tier_changed(_tier: int) -> void:
	_refresh_corruption_hud()


func _on_aspect_changed(_aspect: String) -> void:
	_refresh_corruption_hud()


func _refresh_corruption_hud() -> void:
	if _corruption_panel == null:
		return
	var runtime := get_node_or_null("/root/CorruptionRuntime")
	if runtime == null or not runtime.has_method("is_awakened"):
		_corruption_panel.visible = false
		return
	var awakened: bool = bool(runtime.call("is_awakened"))
	_corruption_panel.visible = awakened
	if not awakened:
		return

	var current: int = int(runtime.call("get_corruption"))
	var state: String = str(runtime.call("get_corruption_state"))
	var aspect_id: String = str(AspectRuntime.selected_aspect) if typeof(AspectRuntime) == TYPE_OBJECT else ""
	var tier: int = int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0
	var copy: Dictionary = _format_corruption_copy(current, state, aspect_id, tier)
	_corruption_bar.value = current
	_corruption_label.text = str(copy.get("label", ""))
	_corruption_detail.text = str(copy.get("detail", ""))


func _format_corruption_copy(current: int, state: String, aspect_id: String, tier: int) -> Dictionary:
	var aspect_name: String
	if aspect_id.is_empty():
		aspect_name = LOCALIZATION.ui("run_hud.aspect", "Aspect")
	else:
		aspect_name = LOCALIZATION.resolve("aspect.%s.name" % aspect_id, aspect_id.replace("_", " ").capitalize())
	var corruption_template: String = LOCALIZATION.ui("run_hud.corruption_value", "Corruption  %d / 100")
	var detail_template: String
	match state:
		"full":
			detail_template = LOCALIZATION.ui("run_hud.aspect_tier_shrine_ready", "%s Tier %d  —  SHRINE READY")
		"near-full":
			detail_template = LOCALIZATION.ui("run_hud.aspect_tier_near_full", "%s Tier %d  —  Near full")
		_:
			detail_template = LOCALIZATION.ui("run_hud.aspect_tier", "%s Tier %d")
	return {
		"label": corruption_template % current,
		"detail": detail_template % [aspect_name, tier],
	}


func _apply_readability() -> void:
	if _root != null:
		READABILITY_STYLER.apply(_root)
	if _corruption_root != null:
		READABILITY_STYLER.apply(_corruption_root)
