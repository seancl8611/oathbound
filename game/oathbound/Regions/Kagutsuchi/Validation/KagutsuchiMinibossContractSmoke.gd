extends Node

const MINIBOSS_CHAMBER: PackedScene = preload("res://Core/Chambers/Types/MinibossChamber.tscn")
const BLOOD_LOTUS_PATH := "res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotus.tscn"
const ETERNAL_SWORDSMAN_PATH := "res://Regions/Kagutsuchi/Enemies/Minibosses/EternalSwordsman.tscn"
const COURT_GUARD_PATH := "res://Regions/Kagutsuchi/Enemies/Standard/CourtGuard.tscn"
const STALK_PATH := "res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotusStalk.tscn"

var _failures: Array[String] = []


func _ready() -> void:
	_validate_chamber_pool()
	_validate_blood_lotus()
	_validate_eternal_swordsman()
	if _failures.is_empty():
		print("[KagutsuchiMinibossContractSmoke] PASS - Blood Lotus objective + Eternal Swordsman placed/engaged duel valid")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[KagutsuchiMinibossContractSmoke] %s" % failure)
		get_tree().quit(1)


func _validate_chamber_pool() -> void:
	var chamber := MINIBOSS_CHAMBER.instantiate()
	if chamber == null:
		_fail("could not instantiate current MinibossChamber")
		return
	chamber.set_meta("area_id", 3)
	var pool_value: Variant = chamber.get("area_3_minibosses")
	if not (pool_value is Array):
		_fail("Area 3 miniboss pool missing")
		chamber.free()
		return
	var paths: Array[String] = []
	for scene_value: Variant in pool_value:
		if scene_value is PackedScene:
			paths.append((scene_value as PackedScene).resource_path)
	paths.sort()
	var expected: Array[String] = [BLOOD_LOTUS_PATH, ETERNAL_SWORDSMAN_PATH]
	expected.sort()
	_expect(paths == expected, "Area 3 miniboss pool must be exactly Blood Lotus + Eternal Swordsman: %s" % str(paths))
	_expect(bool(chamber.call("_uses_current_miniboss_reward")), "Area 3 does not use current premium Technique reward contract")
	chamber.free()


func _validate_blood_lotus() -> void:
	var scene := load(BLOOD_LOTUS_PATH) as PackedScene
	if scene == null:
		_fail("Blood Lotus scene missing")
		return
	var lotus := scene.instantiate()
	_expect(lotus != null, "Blood Lotus failed to instantiate")
	if lotus == null:
		return
	_expect(lotus.has_signal("defeated"), "Blood Lotus must expose defeated signal")
	_expect(lotus.has_signal("enemy_died"), "Blood Lotus must expose EnemyBase death signal")
	_expect(int(lotus.get("total_hp")) == 3, "Blood Lotus must retain three deathblow chunks/cycles")
	_expect(int(lotus.get("stalks_per_cycle")) == 3, "Blood Lotus must spawn three stalks per cycle")
	var stalk_scene_value: Variant = lotus.get("stalk_scene")
	_expect(stalk_scene_value is PackedScene and (stalk_scene_value as PackedScene).resource_path == STALK_PATH, "Blood Lotus stalk scene is not current Kagutsuchi stalk")
	if stalk_scene_value is PackedScene:
		var stalk := (stalk_scene_value as PackedScene).instantiate()
		_expect(stalk != null and stalk.has_signal("enemy_died"), "Blood Lotus stalk must be a killable EnemyBase target")
		if stalk != null:
			stalk.free()
	lotus.free()


func _validate_eternal_swordsman() -> void:
	var scene := load(ETERNAL_SWORDSMAN_PATH) as PackedScene
	if scene == null:
		_fail("Eternal Swordsman scene missing")
		return
	var duel := scene.instantiate()
	_expect(duel != null, "Eternal Swordsman failed to instantiate")
	if duel == null:
		return
	_expect(duel.has_signal("defeated"), "Eternal Swordsman wrapper must expose defeated signal")
	var sword_runtime := duel.get_node_or_null("Swordsman")
	_expect(sword_runtime != null, "Eternal Swordsman missing mature Court sword child")
	if sword_runtime != null:
		_expect(sword_runtime is CourtGuard, "Eternal Swordsman must reuse canonical Court Guard runtime")
		_expect(String(sword_runtime.scene_file_path) == COURT_GUARD_PATH, "Eternal Swordsman Court Guard child must originate from canonical Kagutsuchi scene")

	# Reproduce MinibossChamber sequencing: adding the wrapper runs child _ready() at
	# the pre-spawn transform, then the chamber assigns the final global position.
	add_child(duel)
	var placed_position := Vector2(173.0, 91.0)
	if duel is Node2D:
		(duel as Node2D).global_position = placed_position
	duel.call("_activate_duel_runtime")

	_expect(bool(duel.get("_duel_activated")), "Eternal Swordsman deferred duel activation did not arm")
	if sword_runtime != null:
		_expect(bool(sword_runtime.get("_saw_player_once")), "Eternal Swordsman Court runtime was not explicitly engaged")
		_expect(bool(sword_runtime.get("auto_aggro_on_spawn")), "Eternal Swordsman Court runtime did not remain engaged after placement")
		var home_value: Variant = sword_runtime.get("_home_pos")
		_expect(home_value is Vector2 and (home_value as Vector2).distance_to((sword_runtime as Node2D).global_position) <= 0.01, "Eternal Swordsman Court runtime kept its pre-spawn home position")
	duel.free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)