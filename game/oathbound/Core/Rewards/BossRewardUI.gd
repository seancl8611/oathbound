extends CanvasLayer

signal choice_made(choice: Dictionary)

const CARD_WIDTH := 190.0
const CARD_HEIGHT := 190.0

var _choices: Array = []
var _overlay: ColorRect
var _row: HBoxContainer
var _focused_index := 0
var _buttons: Array[Button] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	layer = 110
	_build_ui()
	visible = false


func present(choices: Array) -> Dictionary:
	_choices = choices.duplicate(true)
	_focused_index = 0
	_refresh_cards()
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	var picked: Dictionary = await choice_made
	return picked


func _build_ui() -> void:
	_overlay = ColorRect.new()
	_overlay.color = Color(0.0, 0.0, 0.0, 0.72)
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_overlay)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 18)
	center.add_child(column)

	var title := Label.new()
	title.text = "Choose a Boss Reward"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 22)
	column.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Persistent boss rewards have already been banked."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.add_theme_font_size_override("font_size", 11)
	column.add_child(subtitle)

	_row = HBoxContainer.new()
	_row.alignment = BoxContainer.ALIGNMENT_CENTER
	_row.add_theme_constant_override("separation", 14)
	column.add_child(_row)

	for i in range(3):
		var button := Button.new()
		button.custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
		button.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.pressed.connect(_select.bind(i))
		button.focus_entered.connect(_set_focus.bind(i))
		_row.add_child(button)
		_buttons.append(button)


func _refresh_cards() -> void:
	for i in range(_buttons.size()):
		var button := _buttons[i]
		if i >= _choices.size():
			button.visible = false
			continue
		button.visible = true
		var choice: Dictionary = _choices[i]
		button.text = "%s\n\n%s" % [
			str(choice.get("displayname", "Boss Reward")),
			str(choice.get("details", "")),
		]
	if not _buttons.is_empty():
		_buttons[0].grab_focus()


func _input(event: InputEvent) -> void:
	if not visible or not event.is_pressed():
		return
	if event.is_action_pressed("left"):
		_focused_index = maxi(0, _focused_index - 1)
		_buttons[_focused_index].grab_focus()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("right"):
		_focused_index = mini(_buttons.size() - 1, _focused_index + 1)
		_buttons[_focused_index].grab_focus()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact"):
		_select(_focused_index)
		get_viewport().set_input_as_handled()


func _set_focus(index: int) -> void:
	_focused_index = index


func _select(index: int) -> void:
	if index < 0 or index >= _choices.size():
		return
	var choice: Dictionary = _choices[index]
	visible = false
	get_tree().paused = false
	choice_made.emit(choice)
