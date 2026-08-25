extends Node

const HUB_SCENE = preload("res://World/HubScene.tscn")
const TRAINING_TARGET = preload("res://World/BloodCavernTrainingTarget.tscn")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")

const EXPECTED_REFRESHERS: Array[String] = [
	"execution",
	"parry",
	"dodge_red",
	"posture_guard",
	"targeting",
	"prosthetic_spirit",
	"blood_aspects",
]

var _failed: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	var gold_before: int = int(RunData.gold) if typeof(RunData) == TYPE_OBJECT else 0
	var mist_before: int = int(MetaProgress.mist) if typeof(MetaProgress) == TYPE_OBJECT else 0
	var scrolls_before: int = int(MetaProgress.scrolls) if typeof(MetaProgress) == TYPE_OBJECT else 0

	await _validate_standalone_training_target()
	_expect(int(RunData.gold) == gold_before if typeof(RunData) == TYPE_OBJECT else true, "training target defeat changed run Gold")
	_expect(int(MetaProgress.mist) == mist_before if typeof(MetaProgress) == TYPE_OBJECT else true, "training target defeat changed persistent Mist")
	_expect(int(MetaProgress.scrolls) == scrolls_before if typeof(MetaProgress) == TYPE_OBJECT else true, "training target defeat changed persistent Scrolls")

	var hub: Node = HUB_SCENE.instantiate()
	add_child(hub)
	await get_tree().process_frame
	await get_tree().process_frame
	var cavern: Node = hub.get_node_or_null("BloodCavern")
	var prompt: Label = hub.get_node_or_null("BloodCavern/InteractPopup") as Label
	_expect(cavern != null, "canonical Blood Cavern node is missing from the live Strand")
	_expect(hub.get_node_or_null("PracticeGrounds") == null, "legacy Practice Grounds node is still authored into the live Strand")
	_expect(hub.get_node_or_null("BloodMirror") == null, "Blood Mirror is still authored as a standalone Strand root station")
	_expect(prompt != null and prompt.text == "Blood Cavern [E]", "Blood Cavern live prompt is not canonical")
	if cavern != null:
		var script_value: Variant = cavern.get_script()
		var script_path: String = (script_value as Script).resource_path if script_value is Script else ""
		_expect(script_path == "res://World/BloodCavern.gd", "live Strand Blood Cavern is not owned by BloodCavern.gd")
		_expect(cavern.has_method("_menu_snapshot_for_playtest"), "Blood Cavern training/menu contract is missing")
		var mirror: Node = cavern.get_node_or_null("BloodMirror")
		_expect(mirror != null, "deeper Blood Mirror is not nested inside Blood Cavern")
		if mirror != null:
			var mirror_script_value: Variant = mirror.get_script()
			var mirror_script_path: String = (mirror_script_value as Script).resource_path if mirror_script_value is Script else ""
			_expect(mirror_script_path == "res://World/BloodMirror.gd", "nested Blood Mirror lost canonical progression ownership")
		var snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
		_expect(str(snapshot.get("title", "")) == "BLOOD CAVERN", "Blood Cavern title fallback is not stable")
		_expect(str(snapshot.get("training_target", "")) == "Start Passive Combat Target", "Blood Cavern training action fallback is not stable")
		_expect(str(snapshot.get("refreshers", "")) == "TUTORIAL REFRESHERS", "Blood Cavern refresher heading fallback is not stable")
		_expect(_same_string_set(snapshot.get("refresher_topics", []), EXPECTED_REFRESHERS), "Blood Cavern must expose exactly the seven approved refresher topics")
		_expect(str(snapshot.get("blood_mirror", "")) == "Enter Blood Mirror", "Blood Cavern does not expose the deeper Blood Mirror route")
		_validate_localized_snapshot(cavern)
		_validate_refresher_contract(cavern)
		await _validate_actual_training_lifecycle(cavern, gold_before, mist_before, scrolls_before)
		await _validate_actual_menu_transition(cavern)
	hub.queue_free()
	await get_tree().process_frame
	get_tree().paused = false

	if _failed:
		get_tree().quit(1)
		return
	print("[BloodCavernSurfaceSmoke] PASS - live Blood Cavern | passive production-combat target | no enemy rewards | tutorial refreshers | nested Blood Mirror | localized surface")
	get_tree().quit(0)


func _validate_standalone_training_target() -> void:
	var target_value: Variant = TRAINING_TARGET.instantiate()
	_expect(target_value is Node2D, "Blood Cavern training target did not instantiate")
	if not (target_value is Node2D):
		return
	var target := target_value as Node2D
	add_child(target)
	await get_tree().process_frame
	_expect(target.has_method("is_training_target") and bool(target.call("is_training_target")), "training target did not expose its sandbox contract")
	_expect(not target.is_physics_processing(), "passive training target still has autonomous enemy physics enabled")
	_expect(int(target.get("experience")) == 0, "training target retained normal enemy experience reward")
	target.call("death")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(is_instance_valid(target), "training target used the normal enemy free-on-death path")
	if is_instance_valid(target):
		_expect(int(target.get("hp")) > 0 and not bool(target.get("has_died")), "training target did not reset after defeat")
		target.queue_free()
	await get_tree().process_frame


func _validate_localized_snapshot(cavern: Node) -> void:
	var previous_locale: String = TranslationServer.get_locale()
	var translation := Translation.new()
	translation.locale = "fr"
	translation.add_message(&"ui.blood_cavern.title", &"CAVERNE TEST")
	translation.add_message(&"ui.blood_cavern.training_target", &"CIBLE TEST")
	translation.add_message(&"ui.blood_cavern.refreshers.title", &"RAPPELS TEST")
	translation.add_message(&"ui.blood_cavern.refresher.parry.title", &"PARADE TEST")
	translation.add_message(&"ui.blood_cavern.blood_mirror", &"MIROIR TEST")
	TranslationServer.add_translation(translation)
	TranslationServer.set_locale("fr")
	var localized: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	_expect(str(localized.get("title", "")) == "CAVERNE TEST", "Blood Cavern title did not resolve stable localization key")
	_expect(str(localized.get("training_target", "")) == "CIBLE TEST", "Blood Cavern training action did not resolve stable localization key")
	_expect(str(localized.get("refreshers", "")) == "RAPPELS TEST", "Blood Cavern refresher heading did not resolve stable localization key")
	_expect(str(localized.get("blood_mirror", "")) == "MIROIR TEST", "Blood Cavern Blood Mirror action did not resolve stable localization key")
	var parry_copy: Dictionary = cavern.call("_refresher_copy_for_playtest", "parry", INPUT_GLYPHS.FAMILY_CONTROLLER)
	_expect(str(parry_copy.get("title", "")) == "PARADE TEST", "Blood Cavern refresher topic did not resolve stable localization key")
	TranslationServer.set_locale(previous_locale)
	TranslationServer.remove_translation(translation)


func _validate_refresher_contract(cavern: Node) -> void:
	INPUT_GLYPHS.ensure_controller_defaults()
	for topic_id: String in EXPECTED_REFRESHERS:
		var copy: Dictionary = cavern.call("_refresher_copy_for_playtest", topic_id, INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
		_expect(not str(copy.get("title", "")).is_empty(), "refresher %s has no title" % topic_id)
		_expect(not str(copy.get("body", "")).is_empty(), "refresher %s has no body" % topic_id)

	var execution_keyboard: Dictionary = cavern.call("_refresher_copy_for_playtest", "execution", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
	var execution_controller: Dictionary = cavern.call("_refresher_copy_for_playtest", "execution", INPUT_GLYPHS.FAMILY_CONTROLLER)
	_expect(str(execution_keyboard.get("body", "")).contains(INPUT_GLYPHS.preferred_label("execute_finisher", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)), "Execution refresher ignored current keyboard binding")
	_expect(str(execution_controller.get("body", "")).contains(INPUT_GLYPHS.preferred_label("execute_finisher", INPUT_GLYPHS.FAMILY_CONTROLLER)), "Execution refresher ignored current controller binding")

	var original_awakened: bool = bool(MetaProgress.returning_blood_awakened) if typeof(MetaProgress) == TYPE_OBJECT else false
	if typeof(MetaProgress) == TYPE_OBJECT:
		MetaProgress.returning_blood_awakened = false
	var locked: Dictionary = cavern.call("_refresher_copy_for_playtest", "blood_aspects", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
	_expect(str(locked.get("body", "")).contains("unlocks after Returning Blood"), "Blood/Aspects refresher was not gated before awakening")
	if typeof(MetaProgress) == TYPE_OBJECT:
		MetaProgress.returning_blood_awakened = true
	var awakened: Dictionary = cavern.call("_refresher_copy_for_playtest", "blood_aspects", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE)
	_expect(str(awakened.get("body", "")).contains("Aspect selection"), "Blood/Aspects refresher did not become available after awakening")
	if typeof(MetaProgress) == TYPE_OBJECT:
		MetaProgress.returning_blood_awakened = original_awakened

	if typeof(SettingsManager) == TYPE_OBJECT:
		var custom_parry := InputEventJoypadButton.new()
		custom_parry.device = -1
		custom_parry.button_index = 3
		_expect(SettingsManager.bind_event("parry", custom_parry), "test controller Parry rebind was rejected")
		var rebound: Dictionary = cavern.call("_refresher_copy_for_playtest", "parry", INPUT_GLYPHS.FAMILY_CONTROLLER)
		_expect(str(rebound.get("body", "")).contains("[Y]"), "Parry refresher did not follow live controller rebind")
		SettingsManager.reset_defaults()
		INPUT_GLYPHS.ensure_controller_defaults()


func _validate_actual_training_lifecycle(cavern: Node, gold_before: int, mist_before: int, scrolls_before: int) -> void:
	cavern.call("_start_passive_target")
	await get_tree().process_frame
	await get_tree().process_frame
	var snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	_expect(bool(snapshot.get("training_active", false)), "Blood Cavern did not enter active training state")
	var targets: Array[Node] = get_tree().get_nodes_in_group("blood_cavern_training_target")
	_expect(targets.size() == 1, "Blood Cavern must own exactly one live passive training target")
	if targets.size() == 1:
		var target: Node = targets[0]
		target.call("death")
		await get_tree().process_frame
		await get_tree().process_frame
		_expect(is_instance_valid(target), "live Cavern target escaped into normal free-on-death behavior")
		if is_instance_valid(target):
			_expect(int(target.get("hp")) > 0 and not bool(target.get("has_died")), "live Cavern target did not reset after defeat")

	_expect(int(RunData.gold) == gold_before if typeof(RunData) == TYPE_OBJECT else true, "live Blood Cavern training changed run Gold")
	_expect(int(MetaProgress.mist) == mist_before if typeof(MetaProgress) == TYPE_OBJECT else true, "live Blood Cavern training changed persistent Mist")
	_expect(int(MetaProgress.scrolls) == scrolls_before if typeof(MetaProgress) == TYPE_OBJECT else true, "live Blood Cavern training changed persistent Scrolls")
	cavern.call("_end_training")
	await get_tree().process_frame
	await get_tree().process_frame
	var ended_snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	_expect(not bool(ended_snapshot.get("training_active", true)), "Blood Cavern did not leave active training state")
	_expect(get_tree().get_nodes_in_group("blood_cavern_training_target").is_empty(), "Blood Cavern target survived End Training")


func _validate_actual_menu_transition(cavern: Node) -> void:
	cavern.call("_open_menu")
	await get_tree().process_frame
	var ui_layer: Node = get_node_or_null("UILayer")
	var cavern_menu: Node = ui_layer.get_node_or_null("BloodCavernMenu") if ui_layer != null else null
	_expect(cavern_menu != null, "Blood Cavern did not build its actual menu surface")
	if cavern_menu != null:
		_expect(cavern_menu.find_child("StartTrainingTarget", true, false) is Button, "Blood Cavern menu is missing the passive training action")
		_expect(cavern_menu.find_child("OpenBloodMirror", true, false) is Button, "Blood Cavern menu is missing the deeper Blood Mirror action")
		var buttons: Node = cavern_menu.find_child("RefresherButtons", true, false)
		_expect(buttons is GridContainer and buttons.get_child_count() == EXPECTED_REFRESHERS.size(), "Blood Cavern menu does not render all seven refresher actions")
		var detail: Node = cavern_menu.find_child("RefresherDetail", true, false)
		_expect(detail is RichTextLabel, "Blood Cavern menu is missing refresher detail presentation")
		cavern.call("_show_refresher", "parry")
		if detail is RichTextLabel:
			var detail_text: String = (detail as RichTextLabel).text
			_expect(detail_text.contains("Parry"), "actual Blood Cavern refresher panel did not switch to Parry")
			_expect(detail_text.contains(INPUT_GLYPHS.preferred_label("parry", INPUT_GLYPHS.FAMILY_CONTROLLER)), "actual Blood Cavern refresher panel omitted current controller binding")

	cavern.call("_open_blood_mirror")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(ui_layer == null or ui_layer.get_node_or_null("BloodCavernMenu") == null, "Blood Cavern menu did not close before entering Blood Mirror")
	var mirror_menu: Node = ui_layer.get_node_or_null("BloodMirrorMenu") if ui_layer != null else null
	_expect(mirror_menu != null, "Blood Cavern route did not open the nested Blood Mirror progression surface")
	if mirror_menu != null and mirror_menu.has_method("_close"):
		mirror_menu.call("_close")
	await get_tree().process_frame
	get_tree().paused = false


func _same_string_set(actual_value: Variant, expected: Array[String]) -> bool:
	if not (actual_value is Array):
		return false
	var actual: Array = actual_value as Array
	if actual.size() != expected.size():
		return false
	var observed: Dictionary = {}
	for value: Variant in actual:
		observed[str(value)] = true
	for value: String in expected:
		if not observed.has(value):
			return false
	return true


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[BloodCavernSurfaceSmoke] FAIL - %s" % message)
