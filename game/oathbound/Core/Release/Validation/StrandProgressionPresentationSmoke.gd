extends Node

const BLOODWELL_SCENE = preload("res://GUI/BloodwellMenu.tscn")
const BLOOD_MIRROR_SCENE = preload("res://GUI/BloodMirrorMenu.tscn")

var _failed: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	var previous_locale: String = TranslationServer.get_locale()
	var previous_contrast: bool = bool(SettingsManager.get_value("high_contrast", false)) if typeof(SettingsManager) == TYPE_OBJECT else false
	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"ui.bloodwell.title", &"PUITS TEST")
	translation.add_message(&"ui.bloodwell.tab.akio", &"AKIO TEST")
	translation.add_message(&"catalog.progression.vitality.name", &"VITALITE TEST")
	translation.add_message(&"ui.blood_mirror.title", &"MIROIR TEST")
	translation.add_message(&"aspect.wolf.name", &"LOUP TEST")
	translation.add_message(&"catalog.progression.wolf_tier0_handling.name", &"MANIEMENT LOUP TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("high_contrast", true)

	await _validate_bloodwell()
	await _validate_blood_mirror()

	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("high_contrast", previous_contrast)
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)
	get_tree().paused = false

	if _failed:
		get_tree().quit(1)
		return
	print("[StrandProgressionPresentationSmoke] PASS - Bloodwell localization | Blood Mirror localization | stable progression IDs | High Contrast")
	get_tree().quit(0)


func _validate_bloodwell() -> void:
	var menu: Node = BLOODWELL_SCENE.instantiate()
	add_child(menu)
	await get_tree().process_frame
	await get_tree().process_frame

	var texts := _all_control_texts(menu)
	_expect(_contains_text(texts, "PUITS TEST"), "Bloodwell title did not resolve stable localization key")
	_expect(_contains_text(texts, "AKIO TEST"), "Bloodwell Akio tab did not resolve stable localization key")
	_expect(_contains_text(texts, "VITALITE TEST"), "Bloodwell node did not resolve stable progression ID")

	var akio_button: Button = _find_button(menu, "AKIO TEST")
	_expect(akio_button != null, "localized Bloodwell Akio button was not present")
	if akio_button != null:
		_expect(akio_button.get_theme_color("font_color").is_equal_approx(Color.WHITE), "High Contrast did not style Bloodwell tab")

	if menu.has_method("_close"):
		menu.call("_close")
	await get_tree().process_frame
	get_tree().paused = false


func _validate_blood_mirror() -> void:
	var menu: Node = BLOOD_MIRROR_SCENE.instantiate()
	add_child(menu)
	await get_tree().process_frame
	await get_tree().process_frame

	var texts := _all_control_texts(menu)
	_expect(_contains_text(texts, "MIROIR TEST"), "Blood Mirror title did not resolve stable localization key")
	_expect(_contains_text(texts, "LOUP TEST"), "Blood Mirror Aspect tab did not resolve stable Aspect ID")
	_expect(_contains_text(texts, "MANIEMENT LOUP TEST"), "Blood Mirror node did not resolve stable progression ID")

	var wolf_button: Button = _find_button(menu, "LOUP TEST")
	_expect(wolf_button != null, "localized Blood Mirror Wolf button was not present")
	if wolf_button != null:
		_expect(wolf_button.get_theme_color("font_color").is_equal_approx(Color.WHITE), "High Contrast did not style Blood Mirror tab")

	if menu.has_method("_close"):
		menu.call("_close")
	await get_tree().process_frame
	get_tree().paused = false


func _all_control_texts(root: Node) -> Array[String]:
	var texts: Array[String] = []
	for node: Node in root.find_children("*", "Control", true, false):
		if node is Label:
			texts.append((node as Label).text)
		elif node is Button:
			texts.append((node as Button).text)
		elif node is RichTextLabel:
			texts.append((node as RichTextLabel).text)
	return texts


func _contains_text(texts: Array[String], needle: String) -> bool:
	for text: String in texts:
		if text.contains(needle):
			return true
	return false


func _find_button(root: Node, text: String) -> Button:
	for node: Node in root.find_children("*", "Button", true, false):
		if node is Button and (node as Button).text == text:
			return node as Button
	return null


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[StrandProgressionPresentationSmoke] FAIL - %s" % message)