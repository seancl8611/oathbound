extends Node

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const DIALOGUE_SCENE = preload("res://GUI/OathboundDialogueOverlay.tscn")
const TECHNIQUE_REWARD_SCENE = preload("res://Utility/UpgradeChoiceUI.tscn")
const DISCOVERY_BOARD_SCENE = preload("res://GUI/DiscoveryBoardMenu.tscn")
const THE_WELL_SCRIPT = preload("res://World/TheWell.gd")

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
	translation.add_message(&"ui.well.aspect.title", &"Aspect Test Traduit")
	translation.add_message(&"aspect.wolf.name", &"Loup Test")
	translation.add_message(&"ui.well.goal.title", &"Objectif Test Traduit")
	translation.add_message(&"ui.well.goal.standard.name", &"Expedition Standard Test")
	translation.add_message(&"ui.discovery.title", &"TABLEAU TEST")
	translation.add_message(&"ui.discovery.tab.help", &"Aide Test")
	translation.add_message(&"ui.discovery.tab.achievements", &"Succes Test")
	translation.add_message(&"ui.discovery.records.run_records", &"Records Test")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("instant_text", true)

	_expect(LOCALIZATION.resolve("missing.localization.key", "English fallback") == "English fallback", "missing translation did not preserve English fallback")
	_expect(LOCALIZATION.resolve("npc.keeper.name", "Keeper") == "Gardien Test", "registered translation key did not resolve")
	await _validate_dialogue_surface()
	_validate_technique_reward_surface()
	await _validate_well_surface()
	await _validate_discovery_surface()

	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("instant_text", previous_instant)
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)
	get_tree().paused = false

	if _failed:
		get_tree().quit(1)
		return
	print("[LocalizationReadinessSmoke] PASS - dialogue | Technique rewards | Well departure | Discovery Board | English fallback")
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

	var texts: Array[String] = _label_texts(overlay)
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

	var label_texts: Array[String] = _label_texts(reward)
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


func _validate_well_surface() -> void:
	var well_value: Variant = THE_WELL_SCRIPT.new()
	_expect(well_value is Node, "The Well localization test could not instantiate runtime")
	if not (well_value is Node):
		return
	var well: Node = well_value as Node
	add_child(well)
	await get_tree().process_frame
	well.call("_open_aspect_menu")
	await get_tree().process_frame
	var aspect_menu: Node = get_tree().root.get_node_or_null("AspectRunSetup")
	_expect(aspect_menu != null, "The Well did not open Aspect setup")
	if aspect_menu != null:
		var texts := _all_control_texts(aspect_menu)
		_expect(_contains_text(texts, "Aspect Test Traduit"), "The Well Aspect title did not resolve localization key")
		_expect(_contains_text(texts, "Loup Test"), "The Well Aspect choice did not resolve stable Aspect key")
	well.call("_close_aspect_menu")
	await get_tree().process_frame
	well.call("_open_run_goal_menu")
	await get_tree().process_frame
	var goal_menu: Node = get_tree().root.get_node_or_null("PostgameRunGoalSetup")
	_expect(goal_menu != null, "The Well did not open postgame goal setup")
	if goal_menu != null:
		var goal_texts := _all_control_texts(goal_menu)
		_expect(_contains_text(goal_texts, "Objectif Test Traduit"), "The Well goal title did not resolve localization key")
		_expect(_contains_text(goal_texts, "Expedition Standard Test"), "The Well Standard Expedition label did not resolve localization key")
	well.call("_close_goal_menu")
	well.queue_free()
	await get_tree().process_frame


func _validate_discovery_surface() -> void:
	var board: Node = DISCOVERY_BOARD_SCENE.instantiate()
	add_child(board)
	await get_tree().process_frame
	await get_tree().process_frame
	var texts := _all_control_texts(board)
	_expect(_contains_text(texts, "TABLEAU TEST"), "Discovery Board title did not resolve stable UI key")
	_expect(_contains_text(texts, "Aide Test"), "Discovery Board Help tab did not resolve stable UI key")
	_expect(_contains_text(texts, "Succes Test"), "Discovery Board Achievements tab did not resolve stable UI key")
	_expect(_contains_text(texts, "Records Test"), "Discovery Board records action did not resolve stable UI key")
	if board.has_method("_close"):
		board.call("_close")
	await get_tree().process_frame
	get_tree().paused = false


func _label_texts(root: Node) -> Array[String]:
	var texts: Array[String] = []
	for node: Node in root.find_children("*", "Label", true, false):
		if node is Label:
			texts.append((node as Label).text)
	return texts


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
	push_error("[LocalizationReadinessSmoke] FAIL - %s" % message)
