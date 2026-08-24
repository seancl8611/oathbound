extends Node

const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")
const HUB_HUD_SCRIPT = preload("res://GUI/HubHUD.gd")
const RUN_HUD_SCRIPT = preload("res://Core/Prosthetics/OathboundRunHUD.gd")
const TITLE_SCENE = preload("res://TitleScreen/menu.tscn")

var _failed: bool = false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		push_error("[ReadabilityAndStrandHUDSmoke] FAIL - SettingsManager unavailable")
		get_tree().quit(1)
		return

	var previous_high_contrast: bool = bool(SettingsManager.get_value("high_contrast", false))
	SettingsManager.set_value("high_contrast", true)

	_validate_shared_styler()
	await _validate_front_end()
	await _validate_strand_hud()
	await _validate_run_hud_release_presentation()

	SettingsManager.set_value("high_contrast", previous_high_contrast)
	if _failed:
		get_tree().quit(1)
		return

	print("[ReadabilityAndStrandHUDSmoke] PASS - high contrast active | front end styled | Strand wallet Mist+Scrolls only | Run HUD localization+glyphs")
	get_tree().quit(0)


func _validate_shared_styler() -> void:
	var root := Control.new()
	var panel := PanelContainer.new()
	var label := Label.new()
	var button := Button.new()
	label.text = "Readable"
	button.text = "Action"
	root.add_child(panel)
	panel.add_child(label)
	root.add_child(button)
	add_child(root)

	READABILITY_STYLER.apply(root)
	_expect(label.get_theme_color("font_color") == Color.WHITE, "High Contrast did not force readable label text")
	_expect(panel.has_theme_stylebox_override("panel"), "High Contrast did not add a panel contrast frame")
	_expect(button.has_theme_stylebox_override("normal"), "High Contrast did not add a button contrast frame")
	_expect(button.get_theme_color("font_color") == Color.WHITE, "High Contrast did not style button text")
	root.queue_free()


func _validate_front_end() -> void:
	var front_end: Node = TITLE_SCENE.instantiate()
	add_child(front_end)
	await get_tree().process_frame
	await get_tree().process_frame

	var script_value: Variant = front_end.get_script()
	var script_path: String = (script_value as Script).resource_path if script_value is Script else ""
	_expect(script_path == "res://TitleScreen/OathboundFrontEnd.gd", "front end is not using the accessibility presentation layer")

	var continue_button: Button = null
	for node: Node in front_end.find_children("*", "Button", true, false):
		if node is Button and (node as Button).text == "Continue":
			continue_button = node as Button
			break
	_expect(continue_button != null, "front end Continue button missing")
	if continue_button != null:
		_expect(continue_button.has_theme_stylebox_override("normal"), "front end did not receive High Contrast styling")

	front_end.queue_free()
	await get_tree().process_frame


func _validate_strand_hud() -> void:
	var hud_value: Variant = HUB_HUD_SCRIPT.new()
	_expect(hud_value is CanvasLayer, "Strand HUD did not instantiate as CanvasLayer")
	if not (hud_value is CanvasLayer):
		return
	var hud: CanvasLayer = hud_value as CanvasLayer
	add_child(hud)
	await get_tree().process_frame
	await get_tree().process_frame

	var labels: Array[String] = []
	var mist_label: Label = null
	for node: Node in hud.find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var text: String = (node as Label).text
		labels.append(text)
		if text == "Mist":
			mist_label = node as Label

	_expect("Mist" in labels, "Strand HUD is missing Mist")
	_expect("Scrolls" in labels, "Strand HUD is missing Scrolls")
	_expect("Keeper Material" not in labels, "Strand HUD incorrectly exposes Keeper material as a permanent counter")
	_expect("Twin Maws Material" not in labels, "Strand HUD incorrectly exposes Twin Maws material as a permanent counter")
	_expect("Shogun Material" not in labels, "Strand HUD incorrectly exposes Shogun material as a permanent counter")
	if mist_label != null:
		_expect(mist_label.get_theme_color("font_color") == Color.WHITE, "Strand HUD did not receive High Contrast styling")

	hud.queue_free()
	await get_tree().process_frame


func _validate_run_hud_release_presentation() -> void:
	var previous_locale: String = TranslationServer.get_locale()
	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"ui.run_hud.spirit", &"ESPRIT HUD TEST")
	translation.add_message(&"ui.currency.scrolls", &"PARCHEMINS HUD TEST")
	translation.add_message(&"catalog.prosthetic.beast_whistle.name", &"SIFFLET TEST")
	translation.add_message(&"aspect.wolf.name", &"LOUP HUD TEST")
	translation.add_message(&"ui.run_hud.corruption_value", &"CORRUPTION HUD %d / 100")
	translation.add_message(&"ui.run_hud.aspect_tier_shrine_ready", &"%s NIVEAU %d PRET TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	INPUT_GLYPHS.ensure_controller_defaults()

	var hud_value: Variant = RUN_HUD_SCRIPT.new()
	_expect(hud_value is CanvasLayer, "Run HUD release wrapper did not instantiate as CanvasLayer")
	if hud_value is CanvasLayer:
		var hud: CanvasLayer = hud_value as CanvasLayer
		add_child(hud)
		await get_tree().process_frame
		await get_tree().process_frame

		var spirit_label: Label = null
		for node: Node in hud.find_children("*", "Label", true, false):
			if node is Label and (node as Label).text == "ESPRIT HUD TEST":
				spirit_label = node as Label
				break
		_expect(spirit_label != null, "Run HUD Spirit label did not resolve stable localization key")
		if spirit_label != null:
			_expect(spirit_label.get_theme_color("font_color") == Color.WHITE, "Run HUD localized Spirit label did not receive High Contrast styling")

		hud.call("update_prosthetic_info", "beast_whistle", 15, 0, 0)
		_expect(str(hud.call("_prosthetic_icon_text_for_playtest")) == "SIFFL", "Run HUD Prosthetic icon text did not derive from localized stable Prosthetic ID")
		_expect(str(hud.call("_localized_reward_label_for_playtest", "scroll")) == "PARCHEMINS HUD TEST", "Run HUD reward toast label did not resolve stable currency key")

		var corruption_copy: Dictionary = hud.call("_format_corruption_copy_for_playtest", 100, "full", "wolf", 2)
		_expect(str(corruption_copy.get("label", "")) == "CORRUPTION HUD 100 / 100", "Run HUD Corruption value did not resolve stable UI key")
		_expect(str(corruption_copy.get("detail", "")) == "LOUP HUD TEST NIVEAU 2 PRET TEST", "Run HUD Aspect/Tier/Shrine-ready copy did not resolve stable Aspect/UI keys")

		hud.call("_set_input_family_for_playtest", INPUT_GLYPHS.FAMILY_CONTROLLER)
		_expect(str(hud.call("_prosthetic_binding_text_for_playtest")) == "[Y]", "Run HUD Prosthetic hint did not switch to controller glyph")
		hud.call("_set_input_family_for_playtest", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
		_expect(str(hud.call("_prosthetic_binding_text_for_playtest")) == INPUT_GLYPHS.preferred_label("prosthetic", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE), "Run HUD Prosthetic hint did not recover keyboard binding")

		hud.queue_free()
		await get_tree().process_frame

	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[ReadabilityAndStrandHUDSmoke] FAIL - %s" % message)
