extends "res://Utility/UpgradeChoiceUI.gd"

## Current Technique reward presentation with Scribe's Lens support.
## The canonical parent remains a three-card screen by default. This overlay only adds
## a fourth card when the Relic-aware UpgradeService actually returns four options.

func _open(list: Array) -> void:
	_ensure_card_count(list.size())
	super._open(list)


func _ensure_card_count(required_count: int) -> void:
	if _cards_container == null:
		return
	while _cards.size() < required_count:
		var index: int = _cards.size()
		var card := Button.new()
		card.custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
		card.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		card.alignment = HORIZONTAL_ALIGNMENT_CENTER
		card.pressed.connect(_select_choice.bind(index))
		card.focus_entered.connect(_set_focus.bind(index))
		_cards_container.add_child(card)
		_cards.append(card)


func _input(event: InputEvent) -> void:
	if not visible or not event.is_pressed():
		return
	if event.is_action_pressed("left"):
		_focused_index = maxi(0, _focused_index - 1)
		if _focused_index < _cards.size():
			_cards[_focused_index].grab_focus()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("right"):
		var max_index: int = mini(options.size(), _cards.size()) - 1
		_focused_index = mini(maxi(0, max_index), _focused_index + 1)
		if _focused_index < _cards.size():
			_cards[_focused_index].grab_focus()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact"):
		_select_choice(_focused_index)
		get_viewport().set_input_as_handled()
