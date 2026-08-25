extends Node

const HUB_SCENE = preload("res://World/HubScene.tscn")
const TRAINING_TARGET = preload("res://World/BloodCavernTrainingTarget.tscn")

var _failed: bool = false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var gold_before: int = int(RunData.gold) if typeof(RunData) == TYPE_OBJECT else 0
	var mist_before: int = int(MetaProgress.mist) if typeof(MetaProgress) == TYPE_OBJECT else 0
	var scrolls_before: int = int(MetaProgress.scrolls) if typeof(MetaProgress) == TYPE_OBJECT else 0

	var target_value: Variant = TRAINING_TARGET.instantiate()
	_expect(target_value is Node2D, "Blood Cavern training target did not instantiate")
	if target_value is Node2D:
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
	_expect(prompt != null and prompt.text == "Blood Cavern [E]", "Blood Cavern live prompt is not canonical")
	if cavern != null:
		var script_value: Variant = cavern.get_script()
		var script_path: String = (script_value as Script).resource_path if script_value is Script else ""
		_expect(script_path == "res://World/BloodCavern.gd", "live Strand Blood Cavern is not owned by BloodCavern.gd")
		_expect(cavern.has_method("_menu_snapshot_for_playtest"), "Blood Cavern training/menu contract is missing")
		var snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
		_expect(str(snapshot.get("title", "")) == "BLOOD CAVERN", "Blood Cavern title fallback is not stable")
		_expect(str(snapshot.get("training_target", "")) == "Start Passive Combat Target", "Blood Cavern training action fallback is not stable")
		_expect(str(snapshot.get("blood_mirror", "")) == "Enter Blood Mirror", "Blood Cavern does not expose the deeper Blood Mirror route")
	hub.queue_free()
	await get_tree().process_frame

	if _failed:
		get_tree().quit(1)
		return
	print("[BloodCavernSurfaceSmoke] PASS - live Blood Cavern | passive production-combat target | no enemy rewards | Blood Mirror route")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[BloodCavernSurfaceSmoke] FAIL - %s" % message)
