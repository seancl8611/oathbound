extends Node

## Structural contract for the five approved Kagutsuchi standard roles.
## This deliberately validates mechanics/ownership rather than tuned damage/timing values.

const COURT_GUARD_PATH := "res://Regions/Kagutsuchi/Enemies/Standard/CourtGuard.tscn"
const COURT_CASTER_PATH := "res://Regions/Kagutsuchi/Enemies/Standard/CourtCaster.tscn"
const ELITE_DEFENDER_PATH := "res://Regions/Kagutsuchi/Enemies/Standard/EliteDefender.tscn"
const HOLLOW_VESSEL_PATH := "res://Regions/Kagutsuchi/Enemies/Standard/HollowVessel.tscn"
const COURT_SENTINEL_PATH := "res://Regions/Kagutsuchi/Enemies/Standard/CourtSentinel.tscn"
const SPILLBORN_PATH := "res://Regions/Kagutsuchi/Enemies/Summons/Spillborn.tscn"

const EXPECTED_SCRIPT_PATHS := {
	COURT_GUARD_PATH: "res://Regions/Kagutsuchi/Enemies/Standard/CourtGuard.gd",
	COURT_CASTER_PATH: "res://Regions/Kagutsuchi/Enemies/Standard/CourtCaster.gd",
	ELITE_DEFENDER_PATH: "res://Regions/Kagutsuchi/Enemies/Standard/EliteDefender.gd",
	HOLLOW_VESSEL_PATH: "res://Regions/Kagutsuchi/Enemies/Standard/HollowVessel.gd",
	COURT_SENTINEL_PATH: "res://Regions/Kagutsuchi/Enemies/Standard/CourtSentinel.gd",
	SPILLBORN_PATH: "res://Regions/Kagutsuchi/Enemies/Summons/Spillborn.gd",
}

var _failures: Array[String] = []


func _ready() -> void:
	_validate_guard()
	_validate_caster()
	_validate_defender()
	_validate_vessel()
	_validate_sentinel()

	if _failures.is_empty():
		print("[KagutsuchiEnemyContractSmoke] PASS - Guard/Caster revive | Defender shield | Vessel->Spillborn source pressure | Sentinel frenzy")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[KagutsuchiEnemyContractSmoke] %s" % failure)
		get_tree().quit(1)


func _validate_guard() -> void:
	var guard := _instantiate(COURT_GUARD_PATH, "Court Guard")
	if guard == null:
		return
	_expect(_has_property(guard, "_reforming") and _has_property(guard, "_has_revived"), "Court Guard lost one-time reform/revive state")
	_expect(_positive(guard, "channel_time") and _positive(guard, "vulnerable_time") and _positive(guard, "reform_hp"), "Court Guard revive window is not configured")
	guard.free()


func _validate_caster() -> void:
	var caster := _instantiate(COURT_CASTER_PATH, "Court Caster")
	if caster == null:
		return
	_expect(_has_property(caster, "_reforming") and _has_property(caster, "_has_revived"), "Court Caster lost one-time reform/revive state")
	_expect(int(caster.get("fan_escalate_count")) > int(caster.get("fan_base_count")), "Court Caster fan projectile count must escalate when ignored")
	_expect(float(caster.get("fan_escalate_arc_deg")) > float(caster.get("fan_base_arc_deg")), "Court Caster fan arc must widen when ignored")
	_expect(_positive(caster, "channel_duration") and _positive(caster, "volley_interval"), "Court Caster channel volley is not configured")
	caster.free()


func _validate_defender() -> void:
	var defender := _instantiate(ELITE_DEFENDER_PATH, "Elite Defender")
	if defender == null:
		return
	var half_angle := float(defender.get("shield_front_half_angle"))
	_expect(half_angle > 0.0 and half_angle < 90.0, "Elite Defender must use a directional frontal shield cone")
	_expect(int(defender.get("spear_count")) > 0 and _positive(defender, "thrust_string_range"), "Elite Defender lost spear/thrust pressure")
	_expect(not _has_property(defender, "_reforming") and not _has_property(defender, "reform_hp"), "Elite Defender must not inherit the Court revival rule")
	defender.free()


func _validate_vessel() -> void:
	var vessel := _instantiate(HOLLOW_VESSEL_PATH, "Hollow Vessel")
	if vessel == null:
		return
	_expect(bool(vessel.get("start_active")), "Hollow Vessel must begin spawning when encountered")
	_expect(bool(vessel.get("counts_as_enemy_for_room_clear")), "Hollow Vessel must remain a source-priority room-clear target")
	_expect(_positive(vessel, "spawn_interval") and int(vessel.get("max_active_spawns")) > 0, "Hollow Vessel spawn pacing is not configured")
	var spawn_scene: Variant = vessel.get("hollow_scene")
	_expect(spawn_scene is PackedScene, "Hollow Vessel has no Spillborn spawn scene")
	if spawn_scene is PackedScene:
		_expect((spawn_scene as PackedScene).resource_path == SPILLBORN_PATH, "Hollow Vessel must own the canonical Spillborn source role")
		var spillborn := (spawn_scene as PackedScene).instantiate()
		_expect(spillborn is EnemyBase, "Spillborn must use the shared EnemyBase combat contract")
		if spillborn != null:
			_validate_script(spillborn, SPILLBORN_PATH, "Spillborn")
			_expect(int(spillborn.get("hp")) > 0 and int(spillborn.get("hp")) < 100, "Spillborn must remain weak expendable pressure rather than an elite")
			_expect(int(spillborn.get("attack_damage")) > 0 and _positive(spillborn, "attack_range"), "Spillborn cannot pressure the player")
			spillborn.free()
	vessel.free()


func _validate_sentinel() -> void:
	var sentinel := _instantiate(COURT_SENTINEL_PATH, "Court Sentinel")
	if sentinel == null:
		return
	var threshold := float(sentinel.get("frenzy_hp_threshold"))
	_expect(threshold > 0.0 and threshold < 1.0, "Court Sentinel must enter frenzy from a low-health threshold")
	_expect(int(sentinel.get("frenzy_slam_count_min")) > 0 and int(sentinel.get("frenzy_slam_count_max")) >= int(sentinel.get("frenzy_slam_count_min")), "Court Sentinel frenzy must contain repeated slams")
	_expect(bool(sentinel.get("deathblow_instant_kill")), "Court Sentinel must remain deathblow-finishable after posture break")
	_expect(not _has_property(sentinel, "_reforming") and not _has_property(sentinel, "reform_hp"), "Court Sentinel must not inherit the Court revival rule")
	sentinel.free()


func _instantiate(path: String, label: String) -> Node:
	var scene := load(path) as PackedScene
	if scene == null:
		_fail("%s scene missing at %s" % [label, path])
		return null
	var instance := scene.instantiate()
	if instance == null:
		_fail("%s failed to instantiate" % label)
		return null
	_validate_script(instance, path, label)
	_expect(instance.has_signal("enemy_died"), "%s must expose shared enemy_died signal" % label)
	return instance


func _validate_script(instance: Node, scene_path: String, label: String) -> void:
	var expected := str(EXPECTED_SCRIPT_PATHS.get(scene_path, ""))
	var script_value: Variant = instance.get_script()
	var actual := (script_value as Script).resource_path if script_value is Script else ""
	_expect(actual == expected, "%s uses %s instead of canonical script %s" % [label, actual, expected])
	_expect(not actual.begins_with("res://Enemy/Area 3/"), "%s still depends on legacy Area 3 script ownership" % label)


func _has_property(instance: Object, property_name: String) -> bool:
	for property: Dictionary in instance.get_property_list():
		if str(property.get("name", "")) == property_name:
			return true
	return false


func _positive(instance: Object, property_name: String) -> bool:
	if not _has_property(instance, property_name):
		return false
	var value: Variant = instance.get(property_name)
	return value != null and float(value) > 0.0


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
