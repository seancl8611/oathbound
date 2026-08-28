extends Node

const MERCHANT_SCENE = preload("res://GUI/MerchantMenu.tscn")

var _failed: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	var previous_locale: String = TranslationServer.get_locale()
	var previous_contrast: bool = bool(SettingsManager.get_value("high_contrast", false)) if typeof(SettingsManager) == TYPE_OBJECT else false
	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"ui.merchant.title", &"MARCHE TEST")
	translation.add_message(&"ui.merchant.tab.upgrades", &"AMELIORATIONS TEST")
	translation.add_message(&"ui.merchant.tab.prosthetics", &"PROTHESES TEST")
	translation.add_message(&"catalog.merchant_stat.max_posture.name", &"POSTURE MAX TEST")
	translation.add_message(&"catalog.prosthetic.flame_vent.name", &"VENT FLAMME TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("high_contrast", true)

	var merchant: Node = MERCHANT_SCENE.instantiate()
	add_child(merchant)
	await get_tree().process_frame
	await get_tree().process_frame

	var texts := _all_control_texts(merchant)
	_expect(_contains_text(texts, "MARCHE TEST"), "Merchant title did not resolve stable localization key")
	_expect(_contains_text(texts, "AMELIORATIONS TEST"), "Merchant Upgrades tab did not resolve stable localization key")
	_expect(_contains_text(texts, "POSTURE MAX TEST"), "Merchant stat catalog did not resolve stable stat ID")

	merchant.call("_on_tab_pressed", 1)
	await get_tree().process_frame
	await get_tree().process_frame
	texts = _all_control_texts(merchant)
	_expect(_contains_text(texts, "PROTHESES TEST"), "Merchant Prosthetics tab did not resolve stable localization key")
	_expect(_contains_text(texts, "VENT FLAMME TEST"), "Merchant Prosthetic catalog did not resolve stable Prosthetic ID")

	var localized_tab: Button = null
	for node: Node in merchant.find_children("*", "Button", true, false):
		if node is Button and (node as Button).text == "PROTHESES TEST":
			localized_tab = node as Button
			break
	_expect(localized_tab != null, "localized Merchant Prosthetics button was not present")
	if localized_tab != null:
		_expect(localized_tab.get_theme_color("font_color").is_equal_approx(Color.WHITE), "High Contrast did not style Merchant tab")

	if merchant.has_method("_close"):
		merchant.call("_close")
	await get_tree().process_frame
	get_tree().paused = false

	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("high_contrast", previous_contrast)
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)

	if _failed:
		get_tree().quit(1)
		return
	print("[MerchantReleasePresentationSmoke] PASS - localized Merchant shell | stable catalog IDs | High Contrast")
	get_tree().quit(0)


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


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[MerchantReleasePresentationSmoke] FAIL - %s" % message)