extends Node

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const DIALOGUE_SCENE = preload("res://GUI/OathboundDialogueOverlay.tscn")
const TECHNIQUE_REWARD_SCENE = preload("res://Utility/UpgradeChoiceUI.tscn")
const DISCOVERY_BOARD_SCENE = preload("res://GUI/DiscoveryBoardMenu.tscn")
const FORGE_SCENE = preload("res://GUI/ForgeMenu.tscn")
const FRONT_END_SCENE = preload("res://TitleScreen/menu.tscn")
const HUB_HUD_SCRIPT = preload("res://GUI/HubHUD.gd")
const PAUSE_OVERVIEW_SCRIPT = preload("res://Core/Release/OathboundAccessiblePauseOverview.gd")
const RUN_RESULTS_SCRIPT = preload("res://Core/Release/OathboundAccessibleRunResultsOverlay.gd")
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
	translation.add_message(&"ui.currency.mist", &"Brume Test")
	translation.add_message(&"ui.currency.scrolls", &"Parchemins Test")
	translation.add_message(&"ui.forge.title", &"FORGE TEST")
	translation.add_message(&"ui.forge.prosthetics", &"PROTHESES FORGE TEST")
	translation.add_message(&"catalog.prosthetic.beast_whistle.name", &"SIFFLET TEST")
	translation.add_message(&"catalog.prosthetic_upgrade.beast_whistle.reinforced_resonance.name", &"RESONANCE TEST")
	translation.add_message(&"catalog.prosthetic_upgrade.beast_whistle.reinforced_resonance.details", &"DESCRIPTION FORGE TEST")
	translation.add_message(&"ui.front_end.continue", &"CONTINUER FRONT TEST")
	translation.add_message(&"ui.front_end.new_game", &"NOUVELLE PARTIE TEST")
	translation.add_message(&"ui.front_end.settings", &"PARAMETRES TEST")
	translation.add_message(&"ui.front_end.credits", &"CREDITS TEST")
	translation.add_message(&"ui.front_end.quit", &"QUITTER TEST")
	translation.add_message(&"ui.pause.title", &"PAUSE TEST")
	translation.add_message(&"ui.pause.resume", &"REPRENDRE TEST")
	translation.add_message(&"ui.pause.current_run", &"COURSE ACTUELLE TEST")
	translation.add_message(&"ui.pause.run_resources", &"RESSOURCES COURSE TEST")
	translation.add_message(&"ui.run_results.title.failed", &"FIN DE COURSE TEST")
	translation.add_message(&"ui.run_results.section.permanent_progress", &"PROGRES PERMANENT TEST")
	translation.add_message(&"ui.run_results.section.final_build", &"BUILD FINAL TEST")
	translation.add_message(&"ui.run_results.label.time", &"TEMPS TEST")
	translation.add_message(&"ui.run_results.return_strand", &"RETOUR STRAND TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("instant_text", true)

	_expect(LOCALIZATION.resolve("missing.localization.key", "English fallback") == "English fallback", "missing translation did not preserve English fallback")
	_expect(LOCALIZATION.resolve("npc.keeper.name", "Keeper") == "Gardien Test", "registered translation key did not resolve")
	await _validate_dialogue_surface()
	_validate_technique_reward_surface()
	await _validate_forge_surface()
	await _validate_well_surface()
	await _validate_discovery_surface()
	await _validate_strand_wallet_surface()
	await _validate_front_end_surface()
	await _validate_pause_surface()
	await _validate_run_results_surface()

	if typeof(SettingsManager) == TYPE_OBJECT:
		SettingsManager.set_value("instant_text", previous_instant)
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)
	get_tree().paused = false

	if _failed:
		get_tree().quit(1)
		return
	print("[LocalizationReadinessSmoke] PASS - dialogue | Technique rewards | Well departure | Discovery Board | English fallback | Forge Scroll costs | Strand wallet | front end | Pause overview | Run Results")
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


func _validate_forge_surface() -> void:
	var previous_equipped: String = str(ProstheticManager.equipped_prosthetic_id)
	var previous_unlocked: Dictionary = ProstheticManager.unlocked_prosthetics.duplicate(true)
	var previous_upgrades: Dictionary = ProstheticManager.purchased_upgrades.duplicate(true)
	ProstheticManager.unlocked_prosthetics["beast_whistle"] = true
	ProstheticManager.equipped_prosthetic_id = "beast_whistle"
	ProstheticManager.purchased_upgrades.erase("beast_whistle")

	var forge: Node = FORGE_SCENE.instantiate()
	add_child(forge)
	await get_tree().process_frame
	await get_tree().process_frame
	var texts := _all_control_texts(forge)
	_expect(_contains_text(texts, "FORGE TEST"), "Forge title did not resolve stable UI localization key")
	_expect(_contains_text(texts, "PROTHESES FORGE TEST"), "Forge Prosthetics heading did not resolve stable UI localization key")
	_expect(_contains_text(texts, "SIFFLET TEST"), "Forge Prosthetic name did not resolve stable catalog ID")
	_expect(_contains_text(texts, "RESONANCE TEST"), "Forge upgrade name did not resolve stable Prosthetic-upgrade ID")
	_expect(_contains_text(texts, "DESCRIPTION FORGE TEST"), "Forge upgrade details did not resolve stable Prosthetic-upgrade ID")
	_expect(_contains_text(texts, "2 Parchemins Test"), "Forge current Scroll upgrade cost was not presented/localized")

	if forge.has_method("_close"):
		forge.call("_close")
	await get_tree().process_frame
	get_tree().paused = false

	ProstheticManager.equipped_prosthetic_id = previous_equipped
	ProstheticManager.unlocked_prosthetics = previous_unlocked
	ProstheticManager.purchased_upgrades = previous_upgrades


func _validate_well_surface() -> void:
	var well_value: Variant = THE_WELL_SCRIPT.new()
	_expect(well_value is Node, "The Well localization test could not instantiate runtime")
	if not (well_value is Node):
		return
	var well: Node = well_value as Node
	# The live Well is authored inline in HubScene and HubInteractable requires this
	# child during _ready(). Mirror that structural contract before entering the tree.
	var interact_popup := Label.new()
	interact_popup.name = "InteractPopup"
	well.add_child(interact_popup)
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


func _validate_strand_wallet_surface() -> void:
	var hud_value: Variant = HUB_HUD_SCRIPT.new()
	_expect(hud_value is Node, "Strand wallet localization test could not instantiate HubHUD")
	if not (hud_value is Node):
		return
	var hud: Node = hud_value as Node
	add_child(hud)
	await get_tree().process_frame
	var texts := _all_control_texts(hud)
	_expect(_contains_text(texts, "Brume Test"), "Strand wallet Mist label did not resolve stable currency key")
	_expect(_contains_text(texts, "Parchemins Test"), "Strand wallet Scrolls label did not resolve stable currency key")
	hud.queue_free()
	await get_tree().process_frame


func _validate_front_end_surface() -> void:
	var front_end: Node = FRONT_END_SCENE.instantiate()
	add_child(front_end)
	await get_tree().process_frame
	await get_tree().process_frame
	var texts := _all_control_texts(front_end)
	_expect(_contains_text(texts, "CONTINUER FRONT TEST"), "front-end Continue action did not resolve stable UI key")
	_expect(_contains_text(texts, "NOUVELLE PARTIE TEST"), "front-end New Game action did not resolve stable UI key")
	_expect(_contains_text(texts, "PARAMETRES TEST"), "front-end Settings action did not resolve stable UI key")
	_expect(_contains_text(texts, "CREDITS TEST"), "front-end Credits action did not resolve stable UI key")
	_expect(_contains_text(texts, "QUITTER TEST"), "front-end Quit action did not resolve stable UI key")
	front_end.queue_free()
	await get_tree().process_frame


func _validate_pause_surface() -> void:
	var pause_value: Variant = PAUSE_OVERVIEW_SCRIPT.new()
	_expect(pause_value is CanvasLayer, "Pause localization test could not instantiate release overlay")
	if not (pause_value is CanvasLayer):
		return
	var pause_overlay: CanvasLayer = pause_value as CanvasLayer
	add_child(pause_overlay)
	await get_tree().process_frame
	await get_tree().process_frame
	var texts := _all_control_texts(pause_overlay)
	_expect(_contains_text(texts, "PAUSE TEST"), "Pause title did not resolve stable UI key")
	_expect(_contains_text(texts, "REPRENDRE TEST"), "Pause Resume action did not resolve stable UI key")
	_expect(_contains_text(texts, "COURSE ACTUELLE TEST"), "Pause run-summary heading did not resolve stable UI key")
	_expect(_contains_text(texts, "RESSOURCES COURSE TEST"), "Pause resources heading did not resolve stable UI key")
	pause_overlay.call("_close")
	await get_tree().process_frame
	get_tree().paused = false


func _validate_run_results_surface() -> void:
	var result_value: Variant = RUN_RESULTS_SCRIPT.new()
	_expect(result_value is CanvasLayer, "Run Results localization test could not instantiate release overlay")
	if not (result_value is CanvasLayer):
		return
	var result_overlay: CanvasLayer = result_value as CanvasLayer
	add_child(result_overlay)
	result_overlay.call("present", {
		"completion_kind": "failed",
		"successful": false,
		"clear_time_seconds": 61.0,
		"area": 1,
		"deepest_chamber_reached": 3,
		"mist_gained": 4,
		"scrolls_gained": 1,
		"boss_materials_gained": {},
		"aspect": "wolf",
		"highest_tier": 1,
		"equipped_prosthetic": "beast_whistle",
		"equipped_relic": "",
		"techniques": [],
		"run_only_lost": ["Gold", "Techniques"],
	})
	await get_tree().process_frame
	var texts := _all_control_texts(result_overlay)
	_expect(_contains_text(texts, "FIN DE COURSE TEST"), "Run Results title did not resolve stable completion-kind key")
	_expect(_contains_text(texts, "PROGRES PERMANENT TEST"), "Run Results permanent-progress section did not resolve stable UI key")
	_expect(_contains_text(texts, "BUILD FINAL TEST"), "Run Results final-build section did not resolve stable UI key")
	_expect(_contains_text(texts, "TEMPS TEST"), "Run Results line label did not resolve stable UI key")
	_expect(_contains_text(texts, "Loup Test"), "Run Results Aspect did not resolve stable Aspect key")
	_expect(_contains_text(texts, "SIFFLET TEST"), "Run Results Prosthetic did not resolve stable catalog ID")
	_expect(_contains_text(texts, "RETOUR STRAND TEST"), "Run Results Strand-return action did not resolve stable UI key")
	result_overlay.call("_dismiss")
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
