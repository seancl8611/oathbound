extends Control

signal menu_closed

var _previous_paused := false
var _capture_action := ""
var _capture_button: Button = null


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_previous_paused = get_tree().paused
	get_tree().paused = true
	_build_ui()


func _input(event: InputEvent) -> void:
	SettingsRuntime.note_input(event)
	if _capture_action.is_empty() or not (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventJoypadMotion):
		return
	if event is InputEventKey and not (event as InputEventKey).pressed:
		return
	if event is InputEventMouseButton and not (event as InputEventMouseButton).pressed:
		return
	if event is InputEventJoypadButton and not (event as InputEventJoypadButton).pressed:
		return
	if event is InputEventKey and (event as InputEventKey).keycode == KEY_ESCAPE:
		_capture_action = ""
		_refresh_capture_button()
		return
	SettingsRuntime.rebind_action(_capture_action, event)
	_capture_action = ""
	_refresh_capture_button()
	get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if _capture_action.is_empty() and event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.01, 0.01, 0.015, 0.94)
	add_child(dim)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(560, 320)
	center.add_child(panel)
	var margin := MarginContainer.new()
	for key in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(key, 14)
	panel.add_child(margin)
	var root := VBoxContainer.new()
	margin.add_child(root)
	var title := Label.new(); title.text = "SETTINGS"; title.add_theme_font_size_override("font_size", 24); root.add_child(title)
	var scroll := ScrollContainer.new(); scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL; root.add_child(scroll)
	var content := VBoxContainer.new(); content.size_flags_horizontal = Control.SIZE_EXPAND_FILL; content.add_theme_constant_override("separation", 5); scroll.add_child(content)

	_section(content, "Audio")
	_slider(content, "Master", "master_volume", 0.0, 1.0, 0.05)
	_slider(content, "Music", "music_volume", 0.0, 1.0, 0.05)
	_slider(content, "SFX", "sfx_volume", 0.0, 1.0, 0.05)
	_slider(content, "Ambience", "ambience_volume", 0.0, 1.0, 0.05)

	_section(content, "Accessibility & Presentation")
	_toggle(content, "Screen shake", "screen_shake")
	_toggle(content, "Reduced flashing", "reduced_flashing")
	_toggle(content, "Reduced VFX", "reduced_vfx")
	_toggle(content, "High contrast", "high_contrast")
	_toggle(content, "Damage numbers", "damage_numbers")
	_toggle(content, "Instant dialogue text", "instant_text")
	_toggle(content, "Hold / toggle assist", "hold_to_toggle")
	_slider(content, "UI scale", "ui_scale", 0.75, 1.5, 0.05)
	_slider(content, "Text size", "text_scale", 0.8, 1.5, 0.05)
	_slider(content, "Dialogue speed", "dialogue_text_speed", 0.5, 2.0, 0.1)
	_toggle(content, "Controller vibration", "vibration_enabled")
	_slider(content, "Vibration strength", "vibration_strength", 0.0, 1.0, 0.05)

	_section(content, "Controls")
	for action in SettingsRuntime.REBIND_ACTIONS:
		var row := HBoxContainer.new(); content.add_child(row)
		var label := Label.new(); label.text = action.replace("_", " ").capitalize(); label.size_flags_horizontal = Control.SIZE_EXPAND_FILL; row.add_child(label)
		var button := Button.new(); button.text = SettingsRuntime.binding_label(action); button.custom_minimum_size.x = 150; button.set_meta("action", action); button.pressed.connect(_begin_capture.bind(action, button)); row.add_child(button)
	var reset := Button.new(); reset.text = "Reset Controls"; reset.pressed.connect(_reset_controls.bind(content)); content.add_child(reset)

	var close := Button.new(); close.text = "Back"; close.pressed.connect(_close); root.add_child(close)


func _section(parent: VBoxContainer, text: String) -> void:
	var label := Label.new(); label.text = text; label.add_theme_font_size_override("font_size", 18); parent.add_child(label)
	parent.add_child(HSeparator.new())


func _toggle(parent: VBoxContainer, label: String, key: String) -> void:
	var check := CheckBox.new(); check.text = label; check.button_pressed = bool(SettingsRuntime.get_setting(key)); check.toggled.connect(func(value: bool): SettingsRuntime.set_setting(key, value)); parent.add_child(check)


func _slider(parent: VBoxContainer, label: String, key: String, min_value: float, max_value: float, step: float) -> void:
	var row := HBoxContainer.new(); parent.add_child(row)
	var text := Label.new(); text.text = label; text.custom_minimum_size.x = 155; row.add_child(text)
	var slider := HSlider.new(); slider.min_value = min_value; slider.max_value = max_value; slider.step = step; slider.value = float(SettingsRuntime.get_setting(key)); slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL; slider.value_changed.connect(func(value: float): SettingsRuntime.set_setting(key, value)); row.add_child(slider)


func _begin_capture(action: String, button: Button) -> void:
	_capture_action = action
	_capture_button = button
	button.text = "Press any input..."


func _refresh_capture_button() -> void:
	if _capture_button != null and is_instance_valid(_capture_button):
		var action := str(_capture_button.get_meta("action", ""))
		_capture_button.text = SettingsRuntime.binding_label(action) if not action.is_empty() else "Bound"
	_capture_button = null


func _reset_controls(_content: VBoxContainer) -> void:
	SettingsRuntime.reset_all_bindings()
	for button in find_children("*", "Button", true, false):
		if button is Button and (button as Button).has_meta("action"):
			var action := str((button as Button).get_meta("action"))
			(button as Button).text = SettingsRuntime.binding_label(action)


func _close() -> void:
	get_tree().paused = _previous_paused
	menu_closed.emit()
	queue_free()
