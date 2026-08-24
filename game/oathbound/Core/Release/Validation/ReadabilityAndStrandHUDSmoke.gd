extends Node

const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const HUB_HUD_SCRIPT = preload("res://GUI/HubHUD.gd")
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

	SettingsManager.set_value("high_contrast", previous_high_contrast)
	if _failed:
		get_tree().quit(1)
		return

	print("[ReadabilityAndStrandHUDSmoke] PASS - high contrast active | front end styled | Strand wallet Mist+Scrolls only")
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


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[ReadabilityAndStrandHUDSmoke] FAIL - %s" % message)
