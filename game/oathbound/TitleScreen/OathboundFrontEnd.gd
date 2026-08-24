extends "res://TitleScreen/menu.gd"

## Accessibility presentation layer for the launch front end. The base menu remains the
## save/settings/navigation authority; this layer only applies the shared readability
## treatment and guarantees the documented default controller action family is present.

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
	var column: VBoxContainer = super._begin_screen(title_text, subtitle_text)
	call_deferred("_apply_readability")
	return column


func _on_toggle_changed(enabled: bool, key: String) -> void:
	super._on_toggle_changed(enabled, key)
	if key == "high_contrast":
		# Rebuild from the base authored colors before applying/removing contrast so
		# toggling off does not leave stale theme overrides on the current screen.
		call_deferred("_build_settings_menu")


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
