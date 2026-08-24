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


func _begin_screen(title_text: String, subtitle_text: String) -> VBoxContainer:
	# Settings reset restores project.godot keyboard defaults; re-seed controller
	# defaults before rebuilding any controls/rebinding screen.
	INPUT_GLYPHS.ensure_controller_defaults()
	var column: VBoxContainer = super._begin_screen(_localized_title(title_text), _localized_subtitle(subtitle_text))
	call_deferred("_apply_readability")
	return column


func _menu_button(text_value: String) -> Button:
	return super._menu_button(_localized_button(text_value))


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
		_: return fallback


func _localized_button(fallback: String) -> String:
	match fallback:
		"Continue": return LOCALIZATION.ui("front_end.continue", fallback)
		"New Game": return LOCALIZATION.ui("front_end.new_game", fallback)
		"Settings": return LOCALIZATION.ui("front_end.settings", fallback)
		"Credits": return LOCALIZATION.ui("front_end.credits", fallback)
		"Quit": return LOCALIZATION.ui("front_end.quit", fallback)
		"Back": return LOCALIZATION.ui("front_end.back", fallback)
		"Cancel": return LOCALIZATION.ui("front_end.cancel", fallback)
		"Controls / Rebinding": return LOCALIZATION.ui("front_end.controls_rebinding", fallback)
		"Reset Settings and Bindings": return LOCALIZATION.ui("front_end.reset_settings_bindings", fallback)
		"Delete and Start New Game": return LOCALIZATION.ui("front_end.delete_and_start", fallback)
		"Delete Slot": return LOCALIZATION.ui("front_end.delete_slot", fallback)
		_: return fallback


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
