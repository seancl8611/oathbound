extends Node

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const DIALOGUE_SCENE = preload("res://GUI/OathboundDialogueOverlay.tscn")
const TECHNIQUE_REWARD_SCENE = preload("res://Utility/UpgradeChoiceUI.tscn")

var _failed: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	var previous_locale: String = TranslationServer.get_locale()
	var previous_instant: bool = bool(SettingsManager.get_value("instant_text", false)) if typeof(SettingsManager) == TYPE_OBJECT else false
	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"npc.keeper.name", &"Gardien Test")
	translation.add_message(&"strand.keeper.first_return.line_1", &"Ligne traduite")
	translation.add_message(&"ui.dialogue.continue", &"Continuer Test")
	translation.add_message(&"ui.technique.choose", &"Choisissez Technique Test")
	translation.add_message(&"ui.technique.family.echo", &"ECHO TRADUIT")
	translation.add_message(&"ui.rarity.common", &"Commun Test")
	translation.add_message(&"catalog.technique.echo_lingering_cut.name", &"Coupe Persistante Test")
	translation.add_message(&"catalog.technique.echo_lingering_cut.details", &"Description Technique Traduite")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("instant_text", true)

	_expect(LOCALIZATION.resolve("missing.localization.key", "English fallback") == "English fallback", "missing translation did not preserve English fallback")
	_expect(LOCALIZATION.resolve("npc.keeper.name", "Keeper") == "Gardien Test", "registered translation key did not resolve")
	await _validate_dialogue_surface()
	_validate_technique_reward_surface()

	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("instant_text", previous_instant)
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)

	if _failed:
		get_tree().quit(1)
		return
	print("[LocalizationReadinessSmoke] PASS - stable keys | English fallback | translated speaker/line/advance label")
	get_tree().quit(0)


func _validate_dialogue_surface() -> void:
	var overlay: Node = DIALOGUE_SCENE.instantiate()
	add_child(overlay)
	await get_tree().process_frame
	overlay.call("present", {
		"id": "localization_smoke",
		"npc": "keeper",
		"loc_key": "strand.keeper.first_return",
		"lines": ["English line one", "English line two"],
	})
	await get_tree().process_frame

	var texts: Array[String] = []
	for node: Node in overlay.find_children("*", "Label", true, false):
		if node is Label:
			texts.append((node as Label).text)

	_expect("Gardien Test" in texts, "dialogue speaker did not resolve stable NPC localization key")
	_expect("Ligne traduite" in texts, "dialogue body did not resolve entry line localization key")
	var advance_found: bool = false
	for text: String in texts:
		if text.begins_with("Continuer Test"):
			advance_found = true
			break
	_expect(advance_found, "dialogue advance label did not resolve UI localization key")

	if overlay.has_method("_finish"):
		overlay.call("_finish")
	await get_tree().process_frame


func _validate_technique_reward_surface() -> void:
	var reward: Node = TECHNIQUE_REWARD_SCENE.instantiate()
	add_child(reward)
	var choice: Dictionary = {
		"id": "echo_lingering_cut",
		"family": "echo",
		"kind": "action",
		"action": "basic",
		"rarity": "common",
		"displayname": "Lingering Cut",
		"details": "English Technique description",
	}
	reward.call("open_with_choices", [choice])

	var label_texts: Array[String] = []
	for node: Node in reward.find_children("*", "Label", true, false):
		if node is Label:
			label_texts.append((node as Label).text)
	_expect("Choisissez Technique Test" in label_texts, "Technique reward title did not resolve UI localization key")

	var translated_card_found: bool = false
	for node: Node in reward.find_children("*", "Button", true, false):
		if not (node is Button):
			continue
		var text: String = (node as Button).text
		if text.contains("Coupe Persistante Test") and text.contains("Description Technique Traduite") and text.contains("ECHO TRADUIT") and text.contains("Commun Test"):
			translated_card_found = true
			break
	_expect(translated_card_found, "active Technique reward card did not resolve stable catalog/UI localization keys")

	reward.visible = false
	get_tree().paused = false
	reward.queue_free()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[LocalizationReadinessSmoke] FAIL - %s" % message)
