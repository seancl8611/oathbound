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
const BOAT_SCRIPT = preload("res://World/Boat.gd")

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
	translation.add_message(&"ui.boat.aspect.title", &"Aspect Test Traduit")
	translation.add_message(&"aspect.wolf.name", &"Loup Test")
	translation.add_message(&"ui.boat.goal.title", &"Objectif Test Traduit")
	translation.add_message(&"ui.boat.goal.standard.name", &"Expedition Standard Test")
	translation.add_message(&"ui.boat.confirm.title", &"Bateau Test Pret")
	translation.add_message(&"ui.boat.confirm.start", &"Demarrer Course Test")
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
	translation.add_message(&"ui.front_end.build_label", &"BUILD FRONT TEST")
	translation.add_message(&"ui.front_end.slot", &"EMPLACEMENT %d")
	translation.add_message(&"ui.front_end.slot.empty", &"VIDE TEST")
	translation.add_message(&"ui.front_end.slot.state.returning_blood", &"SANG RETOUR TEST")
	translation.add_message(&"ui.front_end.slot.completion", &"%d%% COMPLETION TEST")
	translation.add_message(&"ui.front_end.slot.safe_checkpoint", &"CHECKPOINT TEST")
	translation.add_message(&"ui.front_end.delete_warning", &"EMPLACEMENT %d AVERTISSEMENT TEST")
	translation.add_message(&"ui.front_end.credits.body", &"CREDITS BODY TEST")
	translation.add_message(&"ui.settings.section.audio", &"AUDIO SECTION TEST")
	translation.add_message(&"ui.settings.master_volume", &"MASTER TEST")
	translation.add_message(&"ui.settings.high_contrast", &"CONTRASTE TEST")
	translation.add_message(&"ui.settings.block_mode", &"BLOCAGE TEST: %s")
	translation.add_message(&"ui.settings.block_mode.hold", &"TENIR TEST")
	translation.add_message(&"ui.controls.action.attack", &"ATTAQUE TEST")
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
	await _validate_boat_surface()
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
	print("[LocalizationReadinessSmoke] PASS - dialogue | Technique rewards | Boat departure | Discovery Board | English fallback | Forge Scroll costs | Strand wallet | front end | Pause overview | Run Results | complete front-end shell")
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


func _validate_boat_surface() -> void:
	var boat_value: Variant = BOAT_SCRIPT.new()
	_expect(boat_value is Node, "Boat localization test could not instantiate runtime")
	if not (boat_value is Node):
		return
	var boat: Node = boat_value as Node
	var interact_popup := Label.new()
	interact_popup.name = "InteractPopup"
	boat.add_child(interact_popup)
	add_child(boat)
	await get_tree().process_frame

	boat.call("_open_aspect_menu")
	await get_tree().process_frame
	var aspect_menu: Node = get_tree().root.get_node_or_null("BoatAspectRunSetup")
	_expect(aspect_menu != null, "Boat did not open canonical Aspect setup")
	if aspect_menu != null:
		var texts := _all_control_texts(aspect_menu)
		_expect(_contains_text(texts, "Aspect Test Traduit"), "Boat Aspect title did not resolve localization key")
		_expect(_contains_text(texts, "Loup Test"), "Boat Aspect choice did not resolve stable Aspect key")
	boat.call("_close_aspect_menu")
	await get_tree().process_frame

	boat.call("_open_run_goal_menu")
	await get_tree().process_frame
	var goal_menu: Node = get_tree().root.get_node_or_null("BoatPostgameRunGoalSetup")
	_expect(goal_menu != null, "Boat did not open canonical postgame goal setup")
	if goal_menu != null:
		var goal_texts := _all_control_texts(goal_menu)
		_expect(_contains_text(goal_texts, "Objectif Test Traduit"), "Boat goal title did not resolve localization key")
		_expect(_contains_text(goal_texts, "Expedition Standard Test"), "Boat Standard Expedition label did not resolve localization key")
	boat.call("_close_goal_menu")
	await get_tree().process_frame

	boat.call("_open_confirmation_menu")
	await get_tree().process_frame
	var confirmation: Node = get_tree().root.get_node_or_null("BoatRunConfirmation")
	_expect(confirmation != null, "Boat did not open canonical final run confirmation")
	if confirmation != null:
		var confirmation_texts := _all_control_texts(confirmation)
		_expect(_contains_text(confirmation_texts, "Bateau Test Pret"), "Boat confirmation title did not resolve localization key")
		_expect(_contains_text(confirmation_texts, "Demarrer Course Test"), "Boat Start Run action did not resolve localization key")
	var snapshot: Dictionary = boat.call("_confirmation_snapshot_for_playtest")
	_expect(str(snapshot.get("start", "")) == "Demarrer Course Test", "Boat confirmation snapshot did not use localized Start Run copy")
	var technique_copy: String = str(snapshot.get("techniques", ""))
	_expect(technique_copy == "Techniques begin empty and are acquired during the run.", "Boat confirmation no longer communicates the canonical empty-run Technique collection")
	_expect(not technique_copy.to_lower().contains("slot"), "Boat confirmation reintroduced deprecated Technique-slot language")
	boat.call("_cancel_departure_menu")
	boat.queue_free()
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
	var main_texts := _all_control_texts(front_end)
	_expect(_contains_text(main_texts, "CONTINUER FRONT TEST"), "front-end Continue action did not resolve localization key")
	_expect(_contains_text(main_texts, "NOUVELLE PARTIE TEST"), "front-end New Game action did not resolve localization key")
	_expect(_contains_text(main_texts, "PARAMETRES TEST"), "front-end Settings action did not resolve localization key")
	_expect(_contains_text(main_texts, "CREDITS TEST"), "front-end Credits action did not resolve localization key")
	_expect(_contains_text(main_texts, "QUITTER TEST"), "front-end Quit action did not resolve localization key")
	_expect(_contains_text(main_texts, "BUILD FRONT TEST"), "front-end build label did not resolve localization key")
	front_end.call("_build_settings_menu")
	await get_tree().process_frame
	var settings_texts := _all_control_texts(front_end)
	_expect(_contains_text(settings_texts, "AUDIO SECTION TEST"), "Settings Audio section did not resolve localization key")
	_expect(_contains_text(settings_texts, "MASTER TEST"), "Settings Master label did not resolve localization key")
	_expect(_contains_text(settings_texts, "CONTRASTE TEST"), "Settings High Contrast label did not resolve localization key")
	front_end.call("_build_controls_menu")
	await get_tree().process_frame
	var controls_texts := _all_control_texts(front_end)
	_expect(_contains_text(controls_texts, "ATTAQUE TEST"), "Controls Attack action did not resolve localization key")
	front_end.call("_build_credits_menu")
	await get_tree().process_frame
	var credits_texts := _all_control_texts(front_end)
	_expect(_contains_text(credits_texts, "CREDITS BODY TEST"), "Credits body did not resolve localization key")
	front_end.queue_free()
	await get_tree().process_frame


func _validate_pause_surface() -> void:
	var pause_value: Variant = PAUSE_OVERVIEW_SCRIPT.new()
	_expect(pause_value is CanvasLayer, "Pause overview localization test could not instantiate canonical CanvasLayer runtime")
	if not (pause_value is CanvasLayer):
		return
	var pause := pause_value as CanvasLayer
	add_child(pause)
	# The accessibility wrapper localizes RichText content from a deferred presentation
	# pass after the base CanvasLayer has built its authored UI. Settle both stages before
	# asserting translated section copy.
	await get_tree().process_frame
	await get_tree().process_frame
	var texts := _all_control_texts(pause)
	_expect(_contains_text(texts, "PAUSE TEST"), "Pause title did not resolve localization key")
	_expect(_contains_text(texts, "REPRENDRE TEST"), "Pause Resume action did not resolve localization key")
	_expect(_contains_text(texts, "COURSE ACTUELLE TEST"), "Pause current-run section did not resolve localization key")
	_expect(_contains_text(texts, "RESSOURCES COURSE TEST"), "Pause resources section did not resolve localization key")
	pause.queue_free()
	await get_tree().process_frame


func _validate_run_results_surface() -> void:
	var overlay_value: Variant = RUN_RESULTS_SCRIPT.new()
	_expect(overlay_value is CanvasLayer, "Run Results localization test could not instantiate canonical CanvasLayer runtime")
	if not (overlay_value is CanvasLayer):
		return
	var overlay := overlay_value as CanvasLayer
	add_child(overlay)
	await get_tree().process_frame
	overlay.call("present", {
		"outcome": "failed",
		"completion_kind": "failed",
		"time_seconds": 95.0,
		"permanent_progress": ["Mist retained"],
		"final_build": ["Echo Technique"],
	})
	await get_tree().process_frame
	var texts := _all_control_texts(overlay)
	_expect(_contains_text(texts, "FIN DE COURSE TEST"), "Run Results failure title did not resolve localization key")
	_expect(_contains_text(texts, "PROGRES PERMANENT TEST"), "Run Results permanent-progress heading did not resolve localization key")
	_expect(_contains_text(texts, "BUILD FINAL TEST"), "Run Results final-build heading did not resolve localization key")
	_expect(_contains_text(texts, "TEMPS TEST"), "Run Results time label did not resolve localization key")
	_expect(_contains_text(texts, "RETOUR STRAND TEST"), "Run Results return action did not resolve localization key")
	overlay.queue_free()
	await get_tree().process_frame


func _label_texts(root: Node) -> Array[String]:
	var out: Array[String] = []
	for node: Node in root.find_children("*", "Label", true, false):
		if node is Label:
			out.append((node as Label).text)
	return out


func _all_control_texts(root: Node) -> Array[String]:
	var out: Array[String] = []
	for node: Node in root.find_children("*", "Label", true, false):
		if node is Label:
			out.append((node as Label).text)
	for node: Node in root.find_children("*", "Button", true, false):
		if node is Button:
			out.append((node as Button).text)
	for node: Node in root.find_children("*", "RichTextLabel", true, false):
		if node is RichTextLabel:
			out.append((node as RichTextLabel).text)
	return out


func _contains_text(values: Array[String], needle: String) -> bool:
	for value: String in values:
		if value.contains(needle):
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[LocalizationReadinessSmoke] FAIL - %s" % message)
