extends Node

const CODEX_SCENE = preload("res://GUI/CodexMenu.tscn")

var _failed: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	var previous_locale: String = TranslationServer.get_locale()
	var previous_contrast: bool = bool(SettingsManager.get_value("high_contrast", false)) if typeof(SettingsManager) == TYPE_OBJECT else false
	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"ui.codex.title", &"CODEX TEST TRADUIT")
	translation.add_message(&"ui.codex.tab.bestiary", &"BESTIAIRE TEST")
	translation.add_message(&"ui.codex.tab.prosthetics", &"PROSTHETIQUES TEST")
	translation.add_message(&"ui.codex.tab.relics", &"RELIQUES TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("high_contrast", true)

	var codex: Node = CODEX_SCENE.instantiate()
	add_child(codex)
	await get_tree().process_frame
	await get_tree().process_frame

	var texts: Array[String] = []
	var bestiary_button: Button = null
	for node: Node in codex.find_children("*", "Control", true, false):
		if node is Label:
			texts.append((node as Label).text)
		elif node is Button:
			var button := node as Button
			texts.append(button.text)
			if button.text == "BESTIAIRE TEST":
				bestiary_button = button

	_expect("CODEX TEST TRADUIT" in texts, "active Codex title did not resolve stable localization key")
	_expect("BESTIAIRE TEST" in texts, "Bestiary tab did not resolve stable localization key")
	_expect("PROSTHETIQUES TEST" in texts, "Prosthetics tab did not resolve stable localization key")
	_expect("RELIQUES TEST" in texts, "Relics tab did not resolve stable localization key")
	_expect(bestiary_button != null, "localized Bestiary button was not present")
	if bestiary_button != null:
		_expect(bestiary_button.get_theme_color("font_color").is_equal_approx(Color.WHITE), "High Contrast did not style active Codex button")

	if codex.has_method("_close"):
		codex.call("_close")
	await get_tree().process_frame
	get_tree().paused = false

	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("high_contrast", previous_contrast)
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)

	if _failed:
		get_tree().quit(1)
		return
	print("[CodexReleasePresentationSmoke] PASS - localized Codex tabs | stable release wrapper | High Contrast")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[CodexReleasePresentationSmoke] FAIL - %s" % message)
