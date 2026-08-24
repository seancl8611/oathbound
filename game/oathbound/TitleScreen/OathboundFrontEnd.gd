extends "res://TitleScreen/menu.gd"

## Accessibility/localization presentation layer for the launch front end. The base menu
## remains the save/settings/navigation authority; this layer only applies shared release
## presentation and guarantees the documented default controller action family is present.

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")


func _ready() -> void:
	INPUT_GLYPHS.ensure_controller_defaults()
	super._ready()
	call_deferred("_apply_readability")


func _build_main_menu() -> void:
	super._build_main_menu()
	for node: Node in find_children("*", "Label", true, false):
		if node is Label and (node as Label).text == "Release-shell implementation build":
			(node as Label).text = LOCALIZATION.ui("front_end.build_label", "Release-shell implementation build")
	_apply_readability()


func _open_slot_menu(new_game: bool) -> void:
	super._open_slot_menu(new_game)
	_localize_current_buttons()
	_apply_readability()


func _build_settings_menu() -> void:
	super._build_settings_menu()
	var fallback_tooltip := "Hold keeps block active while the input is held. Toggle keeps block active until the input is pressed again."
	for node: Node in find_children("*", "Button", true, false):
		if not (node is Button):
			continue
		var button := node as Button
		button.text = _localized_button(button.text)
		if button.tooltip_text == fallback_tooltip:
			button.tooltip_text = LOCALIZATION.ui("settings.block_mode.help", fallback_tooltip)
	_apply_readability()


func _build_controls_menu() -> void:
	super._build_controls_menu()
	if typeof(SettingsManager) == TYPE_OBJECT:
		for action: String in SettingsManager.get_bindable_actions():
			var fallback := action.replace("_", " ").capitalize()
			var localized := LOCALIZATION.ui("controls.action.%s" % action, fallback)
			for node: Node in find_children("*", "Label", true, false):
				if node is Label and (node as Label).text == fallback:
					(node as Label).text = localized
	_apply_readability()


func _build_credits_menu() -> void:
	super._build_credits_menu()
	var fallback_body := "OATHBOUND\n\nBuilt with Godot Engine 4.7.2.\n\nContributor, contractor, music, sound, asset, font, localization, and third-party license entries are not guessed. Final release credits will list only identities and notices verified from project records and applicable licenses."
	for node: Node in find_children("*", "Label", true, false):
		if node is Label and (node as Label).text == fallback_body:
			(node as Label).text = LOCALIZATION.ui("front_end.credits.body", fallback_body)
	_apply_readability()


func _begin_screen(title_text: String, subtitle_text: String) -> VBoxContainer:
	# Settings reset restores project.godot keyboard defaults; re-seed controller
	# defaults before rebuilding any controls/rebinding screen.
	INPUT_GLYPHS.ensure_controller_defaults()
	var column: VBoxContainer = super._begin_screen(_localized_title(title_text), _localized_subtitle(subtitle_text))
	call_deferred("_apply_readability")
	return column


func _menu_button(text_value: String) -> Button:
	return super._menu_button(_localized_button(text_value))


func _add_section_label(column: VBoxContainer, text_value: String) -> void:
	var key_suffix := text_value.to_lower().replace(" / ", "_").replace(" ", "_")
	super._add_section_label(column, LOCALIZATION.ui("settings.section.%s" % key_suffix, text_value))


func _add_slider(column: VBoxContainer, label_text: String, key: String, min_value: float, max_value: float, step: float) -> void:
	super._add_slider(column, LOCALIZATION.ui("settings.%s" % key, label_text), key, min_value, max_value, step)


func _add_toggle(column: VBoxContainer, label_text: String, key: String) -> void:
	super._add_toggle(column, LOCALIZATION.ui("settings.%s" % key, label_text), key)


func _begin_rebind(action: String, button: Button) -> void:
	super._begin_rebind(action, button)
	button.text = LOCALIZATION.ui("controls.press_input", "Press input…")


func _refresh_binding_button(button: Button, action: String) -> void:
	super._refresh_binding_button(button, action)
	if button.text == "Unavailable":
		button.text = LOCALIZATION.ui("controls.unavailable", "Unavailable")
	elif button.text == "Unbound":
		button.text = LOCALIZATION.ui("controls.unbound", "Unbound")


func _slot_card_text(slot: int, metadata: Dictionary) -> String:
	var slot_template := LOCALIZATION.ui("front_end.slot", "Slot %d")
	var slot_label := slot_template % slot
	if not bool(metadata.get("exists", false)):
		return "%s\n%s" % [slot_label, LOCALIZATION.ui("front_end.slot.empty", "Empty")]
	var playtime := _format_playtime(float(metadata.get("playtime_seconds", 0.0)))
	var state := _localized_slot_state(str(metadata.get("state_label", "In Progress")))
	var line := "%s   •   %s\n%s" % [slot_label, playtime, state]
	var completion := int(metadata.get("completion_percent", 0))
	if bool(metadata.get("story_complete", false)) or completion > 0:
		line += "   •   " + (LOCALIZATION.ui("front_end.slot.completion", "%d%% Completion") % completion)
	if bool(metadata.get("has_active_run", false)):
		line += "   •   " + LOCALIZATION.ui("front_end.slot.safe_checkpoint", "Safe Run Checkpoint")
	return line


func _format_playtime(seconds: float) -> String:
	var total_minutes := maxi(0, int(seconds) / 60)
	var hours := total_minutes / 60
	var minutes := total_minutes % 60
	return LOCALIZATION.ui("front_end.playtime", "%dh %02dm") % [hours, minutes]


func _on_toggle_changed(enabled: bool, key: String) -> void:
	super._on_toggle_changed(enabled, key)
	if key == "high_contrast":
		# Rebuild from the base authored colors before applying/removing contrast so
		# toggling off does not leave stale theme overrides on the current screen.
		call_deferred("_build_settings_menu")


func _localized_title(fallback: String) -> String:
	match fallback:
		"Continue": return LOCALIZATION.ui("front_end.continue", fallback)
		"New Game": return LOCALIZATION.ui("front_end.new_game", fallback)
		"Settings": return LOCALIZATION.ui("front_end.settings", fallback)
		"Controls": return LOCALIZATION.ui("front_end.controls", fallback)
		"Credits": return LOCALIZATION.ui("front_end.credits", fallback)
		"Replace Save Slot?": return LOCALIZATION.ui("front_end.replace_slot.title", fallback)
		"Delete Save Slot?": return LOCALIZATION.ui("front_end.delete_slot.title", fallback)
		_: return fallback


func _localized_subtitle(fallback: String) -> String:
	match fallback:
		"A disciplined action roguelite of steel, blood, and returning.":
			return LOCALIZATION.ui("front_end.subtitle", fallback)
		"Choose one of three save slots. Permanent progress is isolated per slot.":
			return LOCALIZATION.ui("front_end.slot_select.subtitle", fallback)
		"Launch accessibility, audio, readability, and input settings.":
			return LOCALIZATION.ui("front_end.settings.subtitle", fallback)
		"Select an action, then press a keyboard, mouse, or controller input. Escape cancels capture.":
			return LOCALIZATION.ui("front_end.controls.subtitle", fallback)
		"Verified release-credit surface":
			return LOCALIZATION.ui("front_end.credits.subtitle", fallback)
	if fallback.begins_with("Slot ") and fallback.contains(" contains persistent progress. This action cannot be undone."):
		var parts: PackedStringArray = fallback.split(" ")
		var slot := int(parts[1]) if parts.size() > 1 else 0
		return LOCALIZATION.ui("front_end.delete_warning", "Slot %d contains persistent progress. This action cannot be undone.") % slot
	return fallback


func _localized_button(fallback: String) -> String:
	match fallback:
		"Continue": return LOCALIZATION.ui("front_end.continue", fallback)
		"New Game": return LOCALIZATION.ui("front_end.new_game", fallback)
		"Settings": return LOCALIZATION.ui("front_end.settings", fallback)
		"Credits": return LOCALIZATION.ui("front_end.credits", fallback)
		"Quit": return LOCALIZATION.ui("front_end.quit", fallback)
		"Back": return LOCALIZATION.ui("front_end.back", fallback)
		"Cancel": return LOCALIZATION.ui("front_end.cancel", fallback)
		"Delete": return LOCALIZATION.ui("front_end.delete", fallback)
		"Controls / Rebinding": return LOCALIZATION.ui("front_end.controls_rebinding", fallback)
		"Reset Settings and Bindings": return LOCALIZATION.ui("front_end.reset_settings_bindings", fallback)
		"Delete and Start New Game": return LOCALIZATION.ui("front_end.delete_and_start", fallback)
		"Delete Slot": return LOCALIZATION.ui("front_end.delete_slot", fallback)
	if fallback.begins_with("Block Input: "):
		var mode := fallback.trim_prefix("Block Input: ").to_lower()
		var mode_label := LOCALIZATION.ui("settings.block_mode.%s" % mode, mode.capitalize())
		return LOCALIZATION.ui("settings.block_mode", "Block Input: %s") % mode_label
	return fallback


func _localized_slot_state(fallback: String) -> String:
	match fallback:
		"Empty Slot": return LOCALIZATION.ui("front_end.slot.state.empty", fallback)
		"Story Complete": return LOCALIZATION.ui("front_end.slot.state.story_complete", fallback)
		"Returning Blood Awakened": return LOCALIZATION.ui("front_end.slot.state.returning_blood", fallback)
		"First Attempt": return LOCALIZATION.ui("front_end.slot.state.first_attempt", fallback)
		"New Game": return LOCALIZATION.ui("front_end.slot.state.new_game", fallback)
		"In Progress": return LOCALIZATION.ui("front_end.slot.state.in_progress", fallback)
	if fallback.ends_with(" / 6 Heart Bindings"):
		var destroyed := int(fallback.split(" ")[0])
		return LOCALIZATION.ui("front_end.slot.state.heart_bindings", "%d / 6 Heart Bindings") % destroyed
	return fallback


func _localize_current_buttons() -> void:
	for node: Node in find_children("*", "Button", true, false):
		if node is Button:
			(node as Button).text = _localized_button((node as Button).text)


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
