extends Node

## Runtime proof for the Kagutsuchi Health-first standard-enemy contract. Court Sentinel
## is intentionally excluded from STANDARD_SCENES because its scene is explicitly tagged
## miniboss and remains an authored exception.

const STANDARD_SCENES: Array[String] = [
	"res://Regions/Kagutsuchi/Enemies/Standard/CourtCaster.tscn",
	"res://Regions/Kagutsuchi/Enemies/Standard/CourtGuard.tscn",
	"res://Regions/Kagutsuchi/Enemies/Standard/EliteDefender.tscn",
	"res://Regions/Kagutsuchi/Enemies/Standard/HollowVessel.tscn",
]
const MINIBOSS_EXCEPTION := "res://Regions/Kagutsuchi/Enemies/Standard/CourtSentinel.tscn"
const STANDARD_COMBAT_SCRIPT_PATH := "res://Core/Combat/StandardEnemyCombatController.gd"
const RETIRED_BAR_NAMES: Array[String] = ["PostureBar", "HealthBar", "HealthBarRoot", "HPBar", "HpBar", "EnemyHealthBar"]

var _failures: Array[String] = []
var _validated: int = 0


func _ready() -> void:
	for scene_path: String in STANDARD_SCENES:
		await _validate_standard_scene(scene_path)
	await _validate_miniboss_exception()

	if _failures.is_empty():
		print("[KagutsuchiStandardDefenseSmoke] PASS - standards=%d + miniboss exception" % _validated)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[KagutsuchiStandardDefenseSmoke] %s" % failure)
		print("[KagutsuchiStandardDefenseSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_standard_scene(scene_path: String) -> void:
	var actor := _instantiate(scene_path)
	if actor == null:
		return
	add_child(actor)
	await get_tree().process_frame
	await get_tree().process_frame

	_expect(bool(actor.get_meta("standard_enemy_health_only", false)), "%s did not declare Health-only standard status" % scene_path)
	_expect(bool(actor.get_meta("standard_enemy_hide_resource_bars", false)), "%s did not retire standard resource bars" % scene_path)
	_expect(actor.is_in_group("standard_enemy"), "%s did not join standard_enemy group" % scene_path)
	_expect(actor.get_node_or_null("StandardEnemyDefenseRuntime") != null, "%s is missing StandardEnemyDefenseRuntime" % scene_path)
	_expect(not _has_visible_retired_bar(actor), "%s exposes a visible Health/Posture bar" % scene_path)

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


func _validate_miniboss_exception() -> void:
	var actor := _instantiate(MINIBOSS_EXCEPTION)
	if actor == null:
		return
	add_child(actor)
	await get_tree().process_frame
	_expect(actor.is_in_group("miniboss"), "Court Sentinel lost explicit miniboss classification")
	_expect(not actor.is_in_group("standard_enemy"), "Court Sentinel was accidentally migrated to standard_enemy")
	_expect(actor.get_node_or_null("StandardEnemyDefenseRuntime") == null, "Court Sentinel should not use standard defense runtime")
	actor.queue_free()
	await get_tree().process_frame


func _instantiate(scene_path: String) -> Node:
	_expect(ResourceLoader.exists(scene_path, "PackedScene"), "Scene is not registered: %s" % scene_path)
	var value := ResourceLoader.load(scene_path, "PackedScene")
	if not (value is PackedScene):
		_fail("Scene failed runtime load: %s" % scene_path)
		return null
	var actor := (value as PackedScene).instantiate()
	if actor == null:
		_fail("Scene failed instantiate: %s" % scene_path)
	return actor


func _has_visible_retired_bar(root: Node) -> bool:
	for child: Node in root.get_children():
		if str(child.name) in RETIRED_BAR_NAMES and child is CanvasItem and (child as CanvasItem).visible:
			return true
		if _has_visible_retired_bar(child):
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
