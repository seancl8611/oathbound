extends RoomBase

## Current Shrine room surface for the approved Corruption / Blood Aspect loop.
## Distinct from Technique reward cards: this room offers fixed support below full
## Corruption, Resist/Embrace at full, or Stabilize at Tier IV.
## Presentation is localization-, accessibility-, and binding-aware; CorruptionRuntime
## remains the sole Shrine-resolution authority.

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")

@export var interact_action: String = "interact"

@onready var pedestal: Area2D = $InteractShrine
@onready var prompt: Label = $InteractShrine/Prompt

var _player_inside: bool = false
var _resolved: bool = false
var _ui_layer: CanvasLayer
var _ui_root: Control
var _backdrop: ColorRect
var _panel: PanelContainer
var _title: Label
var _state_label: Label
var _current_label: Label
var _next_label: Label
var _detail_label: Label
var _support_button: Button
var _resist_button: Button
var _embrace_button: Button
var _stabilize_button: Button
var _cancel_button: Button
var _input_family: String = INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE


func _ready() -> void:
	INPUT_GLYPHS.ensure_controller_defaults()
	lock_all_gates()
	pedestal.body_entered.connect(_on_pedestal_entered)
	pedestal.body_exited.connect(_on_pedestal_exited)
	_build_ui()
	_connect_input_settings()
	_refresh_prompt()
	call_deferred("_apply_readability")
	print("[OathboundShrine] v1.0 - Corruption support / Resist / Embrace / Stabilize")


func _input(event: InputEvent) -> void:
	if not INPUT_GLYPHS.is_meaningful_family_switch_event(event):
		return
	var family: String = INPUT_GLYPHS.event_family(event)
	if family not in [INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE, INPUT_GLYPHS.FAMILY_CONTROLLER] or family == _input_family:
		return
	_input_family = family
	_refresh_prompt()


func _physics_process(_delta: float) -> void:
	if _resolved:
		return
	if _player_inside and not _panel.visible and Input.is_action_just_pressed(interact_action):
		_open_menu()


func _unhandled_input(event: InputEvent) -> void:
	if _panel == null or not _panel.visible:
		return
	if event.is_action_pressed("ui_cancel"):
		_close_menu()
		get_viewport().set_input_as_handled()


# =============================================================================
# UI
# =============================================================================

func _build_ui() -> void:
	_ui_layer = CanvasLayer.new()
	_ui_layer.layer = 110
	_ui_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(_ui_layer)

	_ui_root = Control.new()
	_ui_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_ui_layer.add_child(_ui_root)

	_backdrop = ColorRect.new()
	_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	_backdrop.color = Color(0.015, 0.01, 0.025, 0.78)
	_backdrop.visible = false
	_ui_root.add_child(_backdrop)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	_ui_root.add_child(center)

	_panel = PanelContainer.new()
	_panel.custom_minimum_size = Vector2(560, 0)
	_panel.visible = false
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.065, 0.05, 0.09, 0.98)
	panel_style.border_color = Color(0.55, 0.24, 0.34, 0.9)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(8)
	panel_style.shadow_color = Color(0, 0, 0, 0.7)
	panel_style.shadow_size = 12
	_panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	_panel.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 10)
	margin.add_child(vbox)

	_title = Label.new()
	_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title.add_theme_font_size_override("font_size", 22)
	vbox.add_child(_title)

	var separator := HSeparator.new()
	vbox.add_child(separator)

	_state_label = _info_label(15)
	_state_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(_state_label)

	_current_label = _info_label(14)
	vbox.add_child(_current_label)

	_next_label = _info_label(14)
	vbox.add_child(_next_label)

	_detail_label = _info_label(13)
	_detail_label.modulate = Color(0.78, 0.77, 0.84)
	vbox.add_child(_detail_label)

	_support_button = _action_button(LOCALIZATION.ui("shrine.action.support", "Receive Shrine Support"))
	_support_button.pressed.connect(_resolve_action.bind("support"))
	vbox.add_child(_support_button)

	_resist_button = _action_button(LOCALIZATION.ui("shrine.action.resist", "Resist"))
	_resist_button.pressed.connect(_resolve_action.bind("resist"))
	vbox.add_child(_resist_button)

	_embrace_button = _action_button(LOCALIZATION.ui("shrine.action.embrace", "Embrace"))
	_embrace_button.pressed.connect(_resolve_action.bind("embrace"))
	vbox.add_child(_embrace_button)

	_stabilize_button = _action_button(LOCALIZATION.ui("shrine.action.stabilize", "Stabilize"))
	_stabilize_button.pressed.connect(_resolve_action.bind("stabilize"))
	vbox.add_child(_stabilize_button)

	_cancel_button = Button.new()
	_cancel_button.text = LOCALIZATION.ui("shrine.action.leave", "Leave Shrine")
	_cancel_button.pressed.connect(_close_menu)
	vbox.add_child(_cancel_button)


func _info_label(font_size: int) -> Label:
	var label := Label.new()
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", font_size)
	return label


func _action_button(text_value: String) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(0, 44)
	button.add_theme_font_size_override("font_size", 15)
	return button


func _open_menu() -> void:
	if _resolved:
		return
	var player: Node = _get_player()
	if player == null:
		return
	_refresh_ui()
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	_backdrop.visible = true
	_panel.visible = true
	_focus_first_visible_action()
	_apply_readability()


func _close_menu() -> void:
	if _panel != null:
		_panel.visible = false
	if _backdrop != null:
		_backdrop.visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_INHERIT


func _refresh_ui() -> void:
	var runtime: Node = _corruption_runtime()
	if runtime == null:
		_title.text = LOCALIZATION.ui("shrine.unavailable.title", "Shrine unavailable")
		_state_label.text = LOCALIZATION.ui("shrine.unavailable.runtime", "CorruptionRuntime is not available.")
		_set_action_visibility(false, false, false, false)
		return

	var shrine_state: String = str(runtime.call("get_shrine_state"))
	var awakened: bool = bool(runtime.call("is_awakened"))
	var corruption: int = int(runtime.call("get_corruption"))
	var tier: int = int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0
	var aspect_id: String = str(AspectRuntime.selected_aspect) if typeof(AspectRuntime) == TYPE_OBJECT else ""
	var aspect_name: String = LOCALIZATION.resolve("aspect.%s.name" % aspect_id, aspect_id.replace("_", " ").capitalize()) if not aspect_id.is_empty() else LOCALIZATION.ui("shrine.aspect", "Aspect")

	_title.text = LOCALIZATION.ui("shrine.title.returning_blood", "Shrine of Returning Blood") if awakened else LOCALIZATION.ui("shrine.title.silent", "Silent Shrine")
	_current_label.visible = awakened
	_next_label.visible = awakened

	if awakened:
		_state_label.text = LOCALIZATION.ui("shrine.state.summary", "%s — Tier %d    |    Corruption %d / 100") % [aspect_name, tier, corruption]
		var current_headline: String = str(runtime.call("get_current_tier_headline"))
		var next_headline: String = str(runtime.call("get_next_tier_headline"))
		_current_label.text = LOCALIZATION.ui("shrine.current", "Current: %s") % _localized_tier_headline(aspect_id, tier, current_headline)
		_next_label.text = LOCALIZATION.ui("shrine.next", "Next: %s") % _localized_next_tier_headline(aspect_id, tier, next_headline)

	match shrine_state:
		"pre-awakening-support":
			_state_label.text = LOCALIZATION.ui("shrine.state.pre_awakening", "The Shrine answers quietly. Something deeper has not yet awakened.")
			_detail_label.text = LOCALIZATION.ui("shrine.detail.pre_awakening", "Restore 20% maximum Health and 25% maximum Spirit. Each resource restores independently.")
			_set_action_visibility(true, false, false, false)
			_support_button.text = LOCALIZATION.ui("shrine.action.support_values", "Receive Support — +20% Health / +25% Spirit")
		"support":
			_detail_label.text = LOCALIZATION.ui("shrine.detail.support", "Corruption is not full. This Shrine provides fixed support without changing Corruption.")
			_set_action_visibility(true, false, false, false)
			_support_button.text = LOCALIZATION.ui("shrine.action.support_values", "Receive Support — +20% Health / +25% Spirit")
		"full-choice":
			_detail_label.text = LOCALIZATION.ui("shrine.detail.full_choice", "Corruption is full. Resist keeps this Tier and recovers resources; Embrace advances exactly one Aspect Tier.")
			_set_action_visibility(false, true, true, false)
			_resist_button.text = LOCALIZATION.ui("shrine.action.resist_values", "Resist — Corruption 75 / 100, +25% Health, +35% Spirit")
			_embrace_button.text = LOCALIZATION.ui("shrine.action.embrace_values", "Embrace — Advance to Tier %d, Corruption 0 / 100") % mini(4, tier + 1)
		"stabilize":
			_detail_label.text = LOCALIZATION.ui("shrine.detail.stabilize", "Tier IV is maximum. Stabilize releases excess pressure without granting additional Aspect power.")
			_set_action_visibility(false, false, false, true)
			_stabilize_button.text = LOCALIZATION.ui("shrine.action.stabilize_values", "Stabilize — Corruption 50 / 100, +30% Health, +40% Spirit")
		_:
			_detail_label.text = LOCALIZATION.ui("shrine.detail.unavailable", "Shrine state unavailable.")
			_set_action_visibility(false, false, false, false)
	_apply_readability()


func _localized_tier_headline(aspect_id: String, tier: int, fallback: String) -> String:
	if aspect_id.is_empty():
		return fallback
	return LOCALIZATION.resolve("shrine.tier_headline.%s.%d" % [aspect_id, tier], fallback)


func _localized_next_tier_headline(aspect_id: String, tier: int, fallback: String) -> String:
	if tier >= 4:
		return LOCALIZATION.ui("shrine.tier_headline.maximum", fallback)
	return _localized_tier_headline(aspect_id, tier + 1, fallback)


func _set_action_visibility(support: bool, resist: bool, embrace: bool, stabilize: bool) -> void:
	_support_button.visible = support
	_resist_button.visible = resist
	_embrace_button.visible = embrace
	_stabilize_button.visible = stabilize


func _focus_first_visible_action() -> void:
	for button: Button in [_support_button, _resist_button, _embrace_button, _stabilize_button, _cancel_button]:
		if button != null and button.visible and not button.disabled:
			button.grab_focus()
			return


# =============================================================================
# BINDING / PRESENTATION
# =============================================================================

func _connect_input_settings() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	var binding_cb := Callable(self, "_on_binding_changed")
	if SettingsManager.has_signal("binding_changed") and not SettingsManager.is_connected("binding_changed", binding_cb):
		SettingsManager.connect("binding_changed", binding_cb)
	var settings_cb := Callable(self, "_on_settings_changed")
	if SettingsManager.has_signal("settings_changed") and not SettingsManager.is_connected("settings_changed", settings_cb):
		SettingsManager.connect("settings_changed", settings_cb)


func _on_binding_changed(action: String) -> void:
	if action == interact_action:
		_refresh_prompt()


func _on_settings_changed() -> void:
	_refresh_prompt()
	call_deferred("_apply_readability")


func _refresh_prompt() -> void:
	if prompt == null:
		return
	INPUT_GLYPHS.ensure_controller_defaults()
	var glyph: String = INPUT_GLYPHS.preferred_label(interact_action, _input_family)
	prompt.text = LOCALIZATION.ui("shrine.prompt", "Approach Shrine %s") % glyph
	READABILITY_STYLER.apply(prompt)


func _set_input_family_for_playtest(family: String) -> void:
	if family not in [INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE, INPUT_GLYPHS.FAMILY_CONTROLLER]:
		return
	_input_family = family
	_refresh_prompt()


func _prompt_text_for_playtest() -> String:
	return prompt.text if prompt != null else ""


func _presentation_snapshot_for_playtest() -> Dictionary:
	_refresh_ui()
	return {
		"title": _title.text,
		"state": _state_label.text,
		"current": _current_label.text,
		"next": _next_label.text,
		"detail": _detail_label.text,
		"support": _support_button.text,
		"resist": _resist_button.text,
		"embrace": _embrace_button.text,
		"stabilize": _stabilize_button.text,
		"leave": _cancel_button.text,
		"support_visible": _support_button.visible,
		"resist_visible": _resist_button.visible,
		"embrace_visible": _embrace_button.visible,
		"stabilize_visible": _stabilize_button.visible,
	}


func _apply_readability() -> void:
	if _ui_root != null:
		READABILITY_STYLER.apply(_ui_root)
	if prompt != null:
		READABILITY_STYLER.apply(prompt)


# =============================================================================
# RESOLUTION
# =============================================================================

func _resolve_action(action: String) -> void:
	if _resolved:
		return
	var runtime: Node = _corruption_runtime()
	var player: Node = _get_player()
	if runtime == null or player == null:
		return
	var result_value: Variant = runtime.call("resolve_shrine", action, player)
	if not (result_value is Dictionary):
		return
	var result: Dictionary = result_value as Dictionary
	if not bool(result.get("success", false)):
		_refresh_ui()
		return
	print("[OathboundShrine] resolved=%s corruption=%s->%s tier=%s->%s hp_restore=%s spirit_restore=%s" % [
		action,
		str(result.get("corruption_before", 0)),
		str(result.get("corruption_after", 0)),
		str(result.get("tier_before", 0)),
		str(result.get("tier_after", 0)),
		str(result.get("health_restored", 0)),
		str(result.get("spirit_restored", 0)),
	])
	_resolve_room()


func _resolve_room() -> void:
	_resolved = true
	_close_menu()
	prompt.visible = false
	var collision := pedestal.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision != null:
		collision.set_deferred("disabled", true)
	unlock_all_gates()


# =============================================================================
# INTERACTION
# =============================================================================

func _on_pedestal_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = true
		if not _resolved:
			prompt.visible = true


func _on_pedestal_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = false
		prompt.visible = false


func _get_player() -> Node:
	return get_tree().get_first_node_in_group("player")


func _corruption_runtime() -> Node:
	return get_node_or_null("/root/CorruptionRuntime")
