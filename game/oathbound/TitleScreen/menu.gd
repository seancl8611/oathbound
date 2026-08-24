extends Control

const HUB_SCENE := "res://World/HubScene.tscn"
const SETTINGS_MENU := preload("res://GUI/SettingsMenu.tscn")
const CREDITS_MENU := preload("res://GUI/CreditsMenu.tscn")

var _menu_box: VBoxContainer
var _overlay: Control = null


func _ready() -> void:
	_build_front_end()


func _build_front_end() -> void:
	var shade := ColorRect.new()
	shade.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	shade.color = Color(0.0, 0.0, 0.0, 0.28)
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(shade)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(330, 0)
	center.add_child(panel)
	var margin := MarginContainer.new()
	for key in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(key, 18)
	panel.add_child(margin)
	_menu_box = VBoxContainer.new()
	_menu_box.add_theme_constant_override("separation", 8)
	margin.add_child(_menu_box)
	_show_main_menu()


func _show_main_menu() -> void:
	_clear_menu()
	var title := Label.new(); title.text = "OATHBOUND"; title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; title.add_theme_font_size_override("font_size", 34); _menu_box.add_child(title)
	var subtitle := Label.new(); subtitle.text = "Contain the Blood. Keep the oath."; subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; _menu_box.add_child(subtitle)
	_menu_box.add_child(HSeparator.new())
	var continue_button := _button("Continue", _show_continue_slots)
	continue_button.disabled = not _any_slot_exists()
	_menu_box.add_child(continue_button)
	_menu_box.add_child(_button("New Game", _show_new_game_slots))
	_menu_box.add_child(_button("Settings", _open_settings))
	_menu_box.add_child(_button("Credits", _open_credits))
	_menu_box.add_child(_button("Quit", _quit_game))


func _show_continue_slots() -> void:
	_show_slots(false)


func _show_new_game_slots() -> void:
	_show_slots(true)


func _show_slots(new_game: bool) -> void:
	_clear_menu()
	var title := Label.new(); title.text = "NEW GAME — CHOOSE SLOT" if new_game else "CONTINUE — CHOOSE SLOT"; title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; title.add_theme_font_size_override("font_size", 20); _menu_box.add_child(title)
	for slot in range(1, SaveSlots.SLOT_COUNT + 1):
		var card := SaveSlots.get_slot_card(slot)
		var exists := bool(card.get("exists", false))
		var button := Button.new()
		button.custom_minimum_size = Vector2(0, 62)
		button.text = _slot_label(slot, card)
		if new_game:
			button.pressed.connect(_new_game_slot_selected.bind(slot, exists))
		else:
			button.disabled = not exists
			button.pressed.connect(_continue_slot.bind(slot))
		_menu_box.add_child(button)
	_menu_box.add_child(_button("Back", _show_main_menu))


func _slot_label(slot: int, card: Dictionary) -> String:
	if not bool(card.get("exists", false)):
		return "Slot %d\nEmpty" % slot
	var marker := "STORY COMPLETE" if bool(card.get("story_complete", false)) else "Bindings %d / 6" % int(card.get("bindings_destroyed", 0))
	return "Slot %d  •  %s  •  %d%%\nPlaytime %s  •  Mist %d  •  Scrolls %d" % [slot, marker, int(card.get("completion_percent", 0)), SaveSlots.format_playtime(float(card.get("playtime_seconds", 0.0))), int(card.get("mist", 0)), int(card.get("scrolls", 0))]


func _continue_slot(slot: int) -> void:
	if SaveSlots.select_slot(slot, false):
		get_tree().change_scene_to_file(HUB_SCENE)


func _new_game_slot_selected(slot: int, occupied: bool) -> void:
	if not occupied:
		_start_new_game(slot)
		return
	_show_replace_confirmation(slot)


func _show_replace_confirmation(slot: int) -> void:
	_clear_menu()
	var title := Label.new(); title.text = "Replace Slot %d?" % slot; title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; title.add_theme_font_size_override("font_size", 22); _menu_box.add_child(title)
	var warning := Label.new(); warning.text = "This permanently deletes the campaign stored in this slot."; warning.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; warning.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER; _menu_box.add_child(warning)
	_menu_box.add_child(_button("Delete and Start", _start_new_game.bind(slot)))
	_menu_box.add_child(_button("Cancel", _show_new_game_slots))


func _start_new_game(slot: int) -> void:
	if SaveSlots.create_new_slot(slot):
		get_tree().change_scene_to_file(HUB_SCENE)


func _open_settings() -> void:
	_open_overlay(SETTINGS_MENU)


func _open_credits() -> void:
	_open_overlay(CREDITS_MENU)


func _open_overlay(scene: PackedScene) -> void:
	if _overlay != null and is_instance_valid(_overlay):
		return
	_overlay = scene.instantiate()
	add_child(_overlay)
	if _overlay.has_signal("menu_closed"):
		_overlay.menu_closed.connect(_on_overlay_closed)
	_overlay.tree_exited.connect(_on_overlay_closed)


func _on_overlay_closed() -> void:
	_overlay = null


func _button(text: String, callable: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 38)
	button.pressed.connect(callable)
	return button


func _clear_menu() -> void:
	for child in _menu_box.get_children():
		child.queue_free()


func _any_slot_exists() -> bool:
	for slot in range(1, SaveSlots.SLOT_COUNT + 1):
		if SaveSlots.has_slot(slot):
			return true
	return false


func _quit_game() -> void:
	get_tree().quit()
