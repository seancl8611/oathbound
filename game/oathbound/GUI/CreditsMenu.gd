extends Control

signal menu_closed

var _previous_paused := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_previous_paused = get_tree().paused
	get_tree().paused = true
	_build_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var dim := ColorRect.new(); dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); dim.color = Color(0.01, 0.01, 0.015, 0.95); add_child(dim)
	var center := CenterContainer.new(); center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); add_child(center)
	var panel := PanelContainer.new(); panel.custom_minimum_size = Vector2(500, 300); center.add_child(panel)
	var margin := MarginContainer.new();
	for key in ["margin_left", "margin_right", "margin_top", "margin_bottom"]: margin.add_theme_constant_override(key, 18)
	panel.add_child(margin)
	var box := VBoxContainer.new(); box.add_theme_constant_override("separation", 10); margin.add_child(box)
	var title := Label.new(); title.text = "OATHBOUND"; title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; title.add_theme_font_size_override("font_size", 28); box.add_child(title)
	var body := RichTextLabel.new(); body.bbcode_enabled = true; body.fit_content = false; body.size_flags_vertical = Control.SIZE_EXPAND_FILL; body.text = "[center][font_size=18]Credits & Notices[/font_size][/center]\n\nOathbound game project\n\nBuilt with Godot Engine 4.7.2.\n\nThird-party art, audio, font, code, and dependency notices must be populated from the verified release asset manifest before distribution. This screen intentionally does not invent licenses or contributor attributions that are not present in the repository's verified release data."; box.add_child(body)
	var back := Button.new(); back.text = "Back"; back.pressed.connect(_close); box.add_child(back)


func _close() -> void:
	get_tree().paused = _previous_paused
	menu_closed.emit()
	queue_free()
