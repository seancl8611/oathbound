extends Control

## Launch-facing Oathbound front end.
## ENDGAME_POSTGAME_RELEASE.md owns Continue/New Game, three slots, Settings, Credits,
## deletion confirmation, and completed-save metadata requirements.

const HUB_SCENE := "res://World/HubScene.tscn"
const RUN_SCENE := "res://Utility/RunScene.tscn"

var _screen_root: Control = null
var _rebind_action: String = ""
var _rebind_button: Button = null
var _rebind_started_frame: int = -1


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_main_menu()


func _unhandled_input(event: InputEvent) -> void:
	if _rebind_action.is_empty():
		return
	if Engine.get_process_frames() == _rebind_started_frame:
		return
	if event is InputEventKey and (event as InputEventKey).pressed and (event as InputEventKey).keycode == KEY_ESCAPE:
		_cancel_rebind()
		get_viewport().set_input_as_handled()
		return
	if event is InputEventKey and not (event as InputEventKey).pressed:
		return
	if event is InputEventMouseButton and not (event as InputEventMouseButton).pressed:
		return
	if event is InputEventJoypadButton and not (event as InputEventJoypadButton).pressed:
		return
	if event is InputEventJoypadMotion and absf((event as InputEventJoypadMotion).axis_value) < 0.5:
		return
	if not (event is InputEventKey or event is InputEventMouseButton or event is InputEventJoypadButton or event is InputEventJoypadMotion):
		return
	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.bind_event(_rebind_action, event):
		var completed_action := _rebind_action
		_rebind_action = ""
		if _rebind_button != null and is_instance_valid(_rebind_button):
			_refresh_binding_button(_rebind_button, completed_action)
		_rebind_button = null
		get_viewport().set_input_as_handled()


func _build_main_menu() -> void:
	var column := _begin_screen("OATHBOUND", "A disciplined action roguelite of steel, blood, and returning.")
	var continue_button := _menu_button("Continue")
	continue_button.disabled = not _any_existing_slot()
	continue_button.pressed.connect(_open_slot_menu.bind(false))
	column.add_child(continue_button)

	var new_game := _menu_button("New Game")
	new_game.pressed.connect(_open_slot_menu.bind(true))
	column.add_child(new_game)

	var settings := _menu_button("Settings")
	settings.pressed.connect(_build_settings_menu)
	column.add_child(settings)

	var credits := _menu_button("Credits")
	credits.pressed.connect(_build_credits_menu)
	column.add_child(credits)

	var quit := _menu_button("Quit")
	quit.pressed.connect(_quit_game)
	column.add_child(quit)

	var version := Label.new()
	version.text = "Release-shell implementation build"
	version.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	version.modulate = Color(0.7, 0.7, 0.72)
	column.add_child(version)


func _open_slot_menu(new_game: bool) -> void:
	var title := "New Game" if new_game else "Continue"
	var subtitle := "Choose one of three save slots. Permanent progress is isolated per slot."
	var column := _begin_screen(title, subtitle)

	for slot in range(1, 4):
		var metadata: Dictionary = SaveSlots.get_slot_metadata(slot) if typeof(SaveSlots) == TYPE_OBJECT else {}
		var row := HBoxContainer.new()
		row.add_theme_constant_override("separation", 8)
		column.add_child(row)

		var slot_button := Button.new()
		slot_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot_button.custom_minimum_size = Vector2(430, 64)
		slot_button.text = _slot_card_text(slot, metadata)
		if new_game:
			slot_button.pressed.connect(_on_new_game_slot_pressed.bind(slot))
		else:
			slot_button.disabled = not bool(metadata.get("exists", false))
			slot_button.pressed.connect(_continue_slot.bind(slot))
		row.add_child(slot_button)

		if bool(metadata.get("exists", false)):
			var delete_button := Button.new()
			delete_button.text = "Delete"
			delete_button.custom_minimum_size = Vector2(84, 64)
			delete_button.pressed.connect(_confirm_delete.bind(slot, false))
			row.add_child(delete_button)

	var back := _menu_button("Back")
	back.pressed.connect(_build_main_menu)
	column.add_child(back)


func _slot_card_text(slot: int, metadata: Dictionary) -> String:
	if not bool(metadata.get("exists", false)):
		return "Slot %d\nEmpty" % slot
	var playtime := _format_playtime(float(metadata.get("playtime_seconds", 0.0)))
	var state := str(metadata.get("state_label", "In Progress"))
	var completion := int(metadata.get("completion_percent", 0))
	var line := "Slot %d   •   %s\n%s" % [slot, playtime, state]
	if bool(metadata.get("story_complete", false)) or completion > 0:
		line += "   •   %d%% Completion" % completion
	if bool(metadata.get("has_active_run", false)):
		line += "   •   Safe Run Checkpoint"
	return line


func _on_new_game_slot_pressed(slot: int) -> void:
	if typeof(SaveSlots) != TYPE_OBJECT:
		return
	if SaveSlots.slot_exists(slot):
		_confirm_delete(slot, true)
	else:
		_start_new_game(slot)


func _confirm_delete(slot: int, start_after: bool) -> void:
	var column := _begin_screen("Replace Save Slot?" if start_after else "Delete Save Slot?", "Slot %d contains persistent progress. This action cannot be undone." % slot)
	var confirm := _menu_button("Delete and Start New Game" if start_after else "Delete Slot")
	confirm.pressed.connect(_delete_slot_confirmed.bind(slot, start_after))
	column.add_child(confirm)
	var cancel := _menu_button("Cancel")
	cancel.pressed.connect(_open_slot_menu.bind(start_after))
	column.add_child(cancel)


func _delete_slot_confirmed(slot: int, start_after: bool) -> void:
	if typeof(SaveSlots) != TYPE_OBJECT:
		return
	SaveSlots.delete_slot(slot)
	if start_after:
		_start_new_game(slot)
	else:
		_open_slot_menu(false)


func get_new_game_destination_path() -> String:
	# FIRST_ATTEMPT.md: a fresh save begins directly in the normal Hushiro route,
	# without a Strand preparation lap before Returning Blood awakens.
	return RUN_SCENE


func _start_new_game(slot: int) -> void:
	if typeof(SaveSlots) != TYPE_OBJECT or not SaveSlots.create_new_slot(slot):
		return
	SaveSlots.begin_gameplay_session()
	get_tree().change_scene_to_file(get_new_game_destination_path())


func _prepare_continue_checkpoint(checkpoint: Dictionary) -> bool:
	if checkpoint.is_empty():
		return false
	if typeof(GameFlow) != TYPE_OBJECT or not GameFlow.has_method("prepare_resume_checkpoint"):
		return false
	return bool(GameFlow.call("prepare_resume_checkpoint", checkpoint))


func _continue_slot(slot: int) -> void:
	if typeof(SaveSlots) != TYPE_OBJECT or not SaveSlots.select_slot(slot, true):
		return
	SaveSlots.begin_gameplay_session()
	var checkpoint: Dictionary = SaveSlots.load_safe_checkpoint(slot)
	if not checkpoint.is_empty():
		if _prepare_continue_checkpoint(checkpoint):
			get_tree().change_scene_to_file(RUN_SCENE)
			return
		# A slot's permanent progression is still valid when only its safe-run snapshot
		# is stale/corrupt. Retire that checkpoint and continue from the Strand rather
		# than launching RunScene with no prepared resume or deleting the save slot.
		push_warning("[OathboundFrontEnd] Safe run checkpoint was rejected; continuing from The Strand")
		SaveSlots.clear_safe_checkpoint()
	get_tree().change_scene_to_file(HUB_SCENE)


func _build_settings_menu() -> void:
	var column := _begin_screen("Settings", "Launch accessibility, audio, readability, and input settings.")
	_add_section_label(column, "Audio")
	_add_slider(column, "Master", "master_volume", 0.0, 1.0, 0.05)
	_add_slider(column, "Music", "music_volume", 0.0, 1.0, 0.05)
	_add_slider(column, "SFX", "sfx_volume", 0.0, 1.0, 0.05)
	_add_slider(column, "Ambience", "ambience_volume", 0.0, 1.0, 0.05)

	_add_section_label(column, "Accessibility / Readability")
	_add_slider(column, "Screen Shake", "screen_shake", 0.0, 1.0, 0.1)
	_add_toggle(column, "Reduced Flashing", "reduced_flashing")
	_add_toggle(column, "Reduced Intense VFX", "reduced_intense_vfx")
	_add_toggle(column, "High Contrast", "high_contrast")
	_add_toggle(column, "Damage Numbers", "damage_numbers")
	_add_slider(column, "UI Scale", "ui_scale", 0.75, 1.50, 0.05)
	_add_slider(column, "Text Size", "text_scale", 0.75, 1.50, 0.05)

	_add_section_label(column, "Text")
	_add_slider(column, "Dialogue Speed", "dialogue_text_speed", 0.50, 2.0, 0.10)
	_add_toggle(column, "Instant Text", "instant_text")

	_add_section_label(column, "Controller / Input Comfort")
	_add_toggle(column, "Vibration", "vibration_enabled")
	_add_slider(column, "Vibration Strength", "vibration_strength", 0.0, 1.0, 0.1)
	if typeof(SettingsManager) == TYPE_OBJECT:
		var block_mode := _menu_button("Block Input: %s" % SettingsManager.get_block_mode().capitalize())
		block_mode.tooltip_text = "Hold keeps block active while the input is held. Toggle keeps block active until the input is pressed again."
		block_mode.pressed.connect(_toggle_block_mode)
		column.add_child(block_mode)

	var controls := _menu_button("Controls / Rebinding")
	controls.pressed.connect(_build_controls_menu)
	column.add_child(controls)
	var back := _menu_button("Back")
	back.pressed.connect(_build_main_menu)
	column.add_child(back)


func _toggle_block_mode() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	var current := SettingsManager.get_block_mode()
	SettingsManager.set_value("block_mode", "toggle" if current == "hold" else "hold")
	_build_settings_menu()


func _build_controls_menu() -> void:
	var column := _begin_screen("Controls", "Select an action, then press a keyboard, mouse, or controller input. Escape cancels capture.")
	if typeof(SettingsManager) == TYPE_OBJECT:
		for action: String in SettingsManager.get_bindable_actions():
			var row := HBoxContainer.new()
			row.add_theme_constant_override("separation", 8)
			column.add_child(row)
			var name_label := Label.new()
			name_label.text = action.replace("_", " ").capitalize()
			name_label.custom_minimum_size = Vector2(150, 0)
			row.add_child(name_label)
			var bind_button := Button.new()
			bind_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_refresh_binding_button(bind_button, action)
			bind_button.pressed.connect(_begin_rebind.bind(action, bind_button))
			row.add_child(bind_button)

	var reset := _menu_button("Reset Settings and Bindings")
	reset.pressed.connect(_reset_settings)
	column.add_child(reset)
	var back := _menu_button("Back")
	back.pressed.connect(_build_settings_menu)
	column.add_child(back)


func _begin_rebind(action: String, button: Button) -> void:
	_rebind_action = action
	_rebind_button = button
	_rebind_started_frame = Engine.get_process_frames()
	button.text = "Press input…"


func _cancel_rebind() -> void:
	if _rebind_button != null and is_instance_valid(_rebind_button) and not _rebind_action.is_empty():
		_refresh_binding_button(_rebind_button, _rebind_action)
	_rebind_action = ""
	_rebind_button = null


func _refresh_binding_button(button: Button, action: String) -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		button.text = "Unavailable"
		return
	var labels: Array[String] = SettingsManager.get_binding_labels(action)
	button.text = " / ".join(labels) if not labels.is_empty() else "Unbound"


func _reset_settings() -> void:
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.reset_defaults()
	_build_controls_menu()


func _build_credits_menu() -> void:
	var column := _begin_screen("Credits", "Verified release-credit surface")
	var body := Label.new()
	body.text = "OATHBOUND\n\nBuilt with Godot Engine 4.7.2.\n\nContributor, contractor, music, sound, asset, font, localization, and third-party license entries are not guessed. Final release credits will list only identities and notices verified from project records and applicable licenses."
	body.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.custom_minimum_size = Vector2(520, 160)
	column.add_child(body)
	var back := _menu_button("Back")
	back.pressed.connect(_build_main_menu)
	column.add_child(back)


func _begin_screen(title_text: String, subtitle_text: String) -> VBoxContainer:
	_cancel_rebind()
	for child: Node in get_children():
		child.queue_free()

	_screen_root = Control.new()
	_screen_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(_screen_root)

	var background := ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.025, 0.02, 0.025, 1.0)
	_screen_root.add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_screen_root.add_child(center)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(580, 330)
	center.add_child(scroll)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	scroll.add_child(margin)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(520, 0)
	column.add_theme_constant_override("separation", 8)
	margin.add_child(column)

	var title := Label.new()
	title.text = title_text
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 34 if title_text == "OATHBOUND" else 24)
	column.add_child(title)

	if not subtitle_text.is_empty():
		var subtitle := Label.new()
		subtitle.text = subtitle_text
		subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		subtitle.modulate = Color(0.78, 0.77, 0.80)
		column.add_child(subtitle)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 6)
	column.add_child(spacer)
	return column


func _menu_button(text_value: String) -> Button:
	var button := Button.new()
	button.text = text_value
	button.custom_minimum_size = Vector2(0, 38)
	return button


func _add_section_label(column: VBoxContainer, text_value: String) -> void:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", 18)
	column.add_child(label)


func _add_slider(column: VBoxContainer, label_text: String, key: String, min_value: float, max_value: float, step: float) -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	var row := HBoxContainer.new()
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(180, 0)
	row.add_child(label)
	var slider := HSlider.new()
	slider.min_value = min_value
	slider.max_value = max_value
	slider.step = step
	slider.value = float(SettingsManager.get_value(key, min_value))
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(_on_slider_changed.bind(key))
	row.add_child(slider)
	var value_label := Label.new()
	value_label.text = "%d%%" % int(round(slider.value * 100.0))
	value_label.custom_minimum_size = Vector2(58, 0)
	slider.value_changed.connect(_on_slider_label_changed.bind(value_label))
	row.add_child(value_label)
	column.add_child(row)


func _on_slider_changed(value: float, key: String) -> void:
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value(key, value)


func _on_slider_label_changed(value: float, label: Label) -> void:
	if is_instance_valid(label):
		label.text = "%d%%" % int(round(value * 100.0))


func _add_toggle(column: VBoxContainer, label_text: String, key: String) -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	var toggle := CheckButton.new()
	toggle.text = label_text
	toggle.button_pressed = bool(SettingsManager.get_value(key, false))
	toggle.toggled.connect(_on_toggle_changed.bind(key))
	column.add_child(toggle)


func _on_toggle_changed(enabled: bool, key: String) -> void:
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value(key, enabled)


func _any_existing_slot() -> bool:
	if typeof(SaveSlots) != TYPE_OBJECT:
		return false
	for slot in range(1, 4):
		if SaveSlots.slot_exists(slot):
			return true
	return false


func _format_playtime(seconds: float) -> String:
	var total_minutes := maxi(0, int(seconds) / 60)
	var hours := total_minutes / 60
	var minutes := total_minutes % 60
	return "%dh %02dm" % [hours, minutes]

func _quit_game() -> void:
	if typeof(SaveSlots) == TYPE_OBJECT:
		SaveSlots.end_gameplay_session()
	get_tree().quit()