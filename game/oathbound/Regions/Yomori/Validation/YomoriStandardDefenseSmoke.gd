extends Node

## Runtime proof that every authored Yomori standard role uses the Health-first defense
## contract. Standard enemies may keep legacy Posture config data for compatibility, but
## they must never accumulate Posture, expose a visible Posture bar, or participate in
## the Deathblow loop.

const STANDARD_SCENES: Array[String] = [
	"res://Enemy/Area 2/Encounter/lingering_wraith.tscn",
	"res://Enemy/Area 2/Encounter/lantern_wraith.tscn",
	"res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn",
	"res://Enemy/Area 2/Encounter/stalker_hound.tscn",
]

const STANDARD_COMBAT_SCRIPT_PATH := "res://Core/Combat/StandardEnemyCombatController.gd"

var _failures: Array[String] = []
var _validated: int = 0


func _ready() -> void:
	for scene_path: String in STANDARD_SCENES:
		await _validate_standard_scene(scene_path)

	if _failures.is_empty():
		print("[YomoriStandardDefenseSmoke] PASS - roles=%d | Health-only standard defense contract" % _validated)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[YomoriStandardDefenseSmoke] %s" % failure)
		print("[YomoriStandardDefenseSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_standard_scene(scene_path: String) -> void:
	_expect(ResourceLoader.exists(scene_path, "PackedScene"), "Scene is not registered: %s" % scene_path)
	var scene_value: Variant = ResourceLoader.load(scene_path, "PackedScene")
	if not (scene_value is PackedScene):
		_fail("Scene failed runtime load: %s" % scene_path)
		return

	var actor: Node = (scene_value as PackedScene).instantiate()
	if actor == null:
		_fail("Scene failed instantiate: %s" % scene_path)
		return

	add_child(actor)
	await get_tree().process_frame
	await get_tree().process_frame

	_expect(actor.has_meta("standard_enemy_health_only") and bool(actor.get_meta("standard_enemy_health_only")), "%s did not declare Health-only standard status" % scene_path)
	_expect(actor.is_in_group("standard_enemy"), "%s did not join standard_enemy group" % scene_path)
	_expect(actor.get_node_or_null("StandardEnemyDefenseRuntime") != null, "%s is missing StandardEnemyDefenseRuntime" % scene_path)

	var posture_bar := actor.get_node_or_null("PostureBar") as CanvasItem
	_expect(posture_bar == null or not posture_bar.visible, "%s exposes a visible Posture bar" % scene_path)

	var combat := actor.get_node_or_null("Combat")
	if combat != null:
		var combat_script := combat.get_script() as Script
		var combat_path := combat_script.resource_path if combat_script != null else ""
		_expect(combat_path == STANDARD_COMBAT_SCRIPT_PATH, "%s still uses a Posture-enabled Combat controller: %s" % [scene_path, combat_path])
		if combat.has_method("add_posture"):
			combat.call("add_posture", 999.0)
		if combat.has_method("get_posture"):
			_expect(absf(float(combat.call("get_posture"))) <= 0.001, "%s accumulated Posture after forced mutation" % scene_path)

	_validated += 1
	actor.queue_free()
	await get_tree().process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
