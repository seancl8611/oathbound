extends Node

const MINIBOSS_CHAMBER: PackedScene = preload("res://Core/Chambers/Types/MinibossChamber.tscn")
const BLOOD_LOTUS_PATH := "res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotus.tscn"
const ETERNAL_SWORDSMAN_PATH := "res://Regions/Kagutsuchi/Enemies/Minibosses/EternalSwordsman.tscn"
const STALK_PATH := "res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotusStalk.tscn"

var _failures: Array[String] = []


func _ready() -> void:
	_validate_chamber_pool()
	_validate_blood_lotus()
	_validate_eternal_swordsman()
	if _failures.is_empty():
		print("[KagutsuchiMinibossContractSmoke] PASS - Blood Lotus objective + Eternal Swordsman duel pool valid")
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
		var script_value: Variant = sword_runtime.get_script()
		_expect(script_value is Script and (script_value as Script).resource_path == "res://Enemy/Area 3/Encounter/court_guard.gd", "Eternal Swordsman must reuse mature Court sword runtime")
	duel.free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
