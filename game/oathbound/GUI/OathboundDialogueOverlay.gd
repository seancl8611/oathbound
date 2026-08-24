extends Control

signal sequence_finished(sequence_id: String)

const BASE_DIALOGUE_CHARS_PER_SECOND: float = 42.0

var _entry: Dictionary = {}
var _lines: Array = []
var _line_index: int = 0
var _speaker_label: Label
var _body_label: Label
var _advance_label: Label
var _previous_paused: bool = false
var _full_line: String = ""
var _reveal_progress: float = 0.0
var _revealing: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	_build_ui()


func _process(delta: float) -> void:
	if not _revealing or _body_label == null:
		return
	_reveal_progress += maxf(0.0, delta) * _dialogue_chars_per_second()
	var revealed: int = mini(_full_line.length(), int(floor(_reveal_progress)))
	_body_label.visible_characters = revealed
	if revealed >= _full_line.length():
		_finish_reveal()


func present(entry: Dictionary) -> void:
	_entry = entry.duplicate(true)
	_lines = entry.get("lines", [])
	if _lines.is_empty() and entry.has("text"):
		_lines = [str(entry.get("text", ""))]
	_line_index = 0
	_previous_paused = get_tree().paused
	get_tree().paused = true
	_show_current_line()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact") or event.is_action_pressed("click"):
		_advance()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_cancel"):
		_finish()
		get_viewport().set_input_as_handled()


func _advance() -> void:
	# A first confirm while text is revealing completes the current line. A second
	# confirm advances, preserving the normal readable dialogue cadence at any speed.
	if _revealing:
		_finish_reveal()
		return
	_line_index += 1
	if _line_index >= _lines.size():
		_finish()
		return
	_show_current_line()


func _show_current_line() -> void:
	if _body_label == null or _speaker_label == null:
		return
	var speaker: String = str(_entry.get("speaker", ""))
	if bool(_entry.get("notice", false)):
		speaker = "ORDER NOTICE"
	if speaker.is_empty() and _entry.has("npc"):
		speaker = _npc_display_name(str(_entry.get("npc", "")))
	_speaker_label.text = tr(str(_entry.get("speaker_loc_key", speaker))) if not speaker.is_empty() else ""
	_full_line = str(_lines[_line_index])
	_body_label.text = _full_line
	_begin_reveal()
	_advance_label.text = "Continue  [%d/%d]" % [_line_index + 1, _lines.size()]


func _begin_reveal() -> void:
	_reveal_progress = 0.0
	if _body_label == null:
		_revealing = false
		return
	if _full_line.is_empty() or _uses_instant_text():
		_finish_reveal()
		return
	_revealing = true
	_body_label.visible_characters = 0


func _finish_reveal() -> void:
	_revealing = false
	_reveal_progress = float(_full_line.length())
	if _body_label != null:
		_body_label.visible_characters = -1


func _dialogue_chars_per_second() -> float:
	var speed_scale: float = 1.0
	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("get_dialogue_text_speed"):
		speed_scale = clampf(float(SettingsManager.get_dialogue_text_speed()), 0.50, 2.00)
	return BASE_DIALOGUE_CHARS_PER_SECOND * speed_scale


func _uses_instant_text() -> bool:
	return typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("uses_instant_text") and bool(SettingsManager.uses_instant_text())


func _finish() -> void:
	if not is_inside_tree():
		return
	_revealing = false
	get_tree().paused = _previous_paused
	sequence_finished.emit(str(_entry.get("id", "")))
	queue_free()


func _build_ui() -> void:
	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.0, 0.0, 0.0, 0.38)
	add_child(dim)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.08
	panel.anchor_right = 0.92
	panel.anchor_top = 0.64
	panel.anchor_bottom = 0.94
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 10)
	panel.add_child(margin)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	margin.add_child(box)

	_speaker_label = Label.new()
	_speaker_label.add_theme_font_size_override("font_size", 16)
	box.add_child(_speaker_label)

	_body_label = Label.new()
	_body_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_body_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_body_label.add_theme_font_size_override("font_size", 14)
	box.add_child(_body_label)

	_advance_label = Label.new()
	_advance_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_advance_label.add_theme_font_size_override("font_size", 11)
	box.add_child(_advance_label)


func _npc_display_name(npc_id: String) -> String:
	match npc_id:
		"keeper": return "Keeper"
		"scribe": return "Scribe"
		"raven": return "Raven"
		"undead_samurai": return "Undead Samurai"
		"smith": return "Smith"
		"peddler": return "Peddler"
	return npc_id.replace("_", " ").capitalize()
