extends Node

const PRESSURE_DIRECTOR_SCRIPT = preload("res://Core/Combat/PressureDirectorV2.gd")
const SWORDSMAN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	_test_window_scheduler()
	await _test_attackdir_compatibility()
	await _test_swordsman_integration()
	_finish()


func _test_window_scheduler() -> void:
	var value: Variant = PRESSURE_DIRECTOR_SCRIPT.new()
	if not (value is PressureDirectorV2):
		_fail("could not instantiate PressureDirectorV2")
		return
	var director: PressureDirectorV2 = value as PressureDirectorV2
	add_child(director)
	var a := Node2D.new()
	var b := Node2D.new()
	var c := Node2D.new()
	var d := Node2D.new()
	add_child(a)
	add_child(b)
	add_child(c)
	add_child(d)
	var now: float = Time.get_ticks_msec() * 0.001

	var first: Dictionary = director.request_threat(a, {
		"attack_id": "a",
		"impact_at": now + 1.00,
		"impact_delay": 1.00,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(bool(first.get("admitted", false)), "first normal threat was not admitted")

	# Windups may overlap. The second attack is admitted because its dangerous impact
	# lands outside the first normal spacing window.
	var separated: Dictionary = director.request_threat(b, {
		"attack_id": "b",
		"impact_at": now + 1.35,
		"impact_delay": 1.35,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(bool(separated.get("admitted", false)), "separated future impact was incorrectly serialized")
	_expect(director.reservation_count() == 2, "director did not retain concurrent separated threats")

	var overlap: Dictionary = director.request_threat(c, {
		"attack_id": "c",
		"impact_at": now + 1.05,
		"impact_delay": 1.05,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(not bool(overlap.get("admitted", true)), "near-simultaneous normal impact was admitted")
	_expect(str(overlap.get("reason", "")) in ["impact_spacing", "pressure_budget"], "overlap denial did not report a pressure reason")

	director.release_threat(a, str(first.get("reservation_id", "")), "test_release")
	var after_release: Dictionary = director.request_threat(c, {
		"attack_id": "c",
		"impact_at": now + 1.05,
		"impact_delay": 1.05,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(bool(after_release.get("admitted", false)), "released impact window did not become available")

	var perilous: Dictionary = director.request_threat(d, {
		"attack_id": "d_perilous",
		"impact_at": now + 1.28,
		"impact_delay": 1.28,
		"active_duration": 0.18,
		"severity": "perilous",
		"threat_cost": 1.5,
	})
	_expect(not bool(perilous.get("admitted", true)), "perilous threat ignored its larger spacing requirement")

	director.queue_free()
	a.queue_free()
	b.queue_free()
	c.queue_free()
	d.queue_free()


func _test_attackdir_compatibility() -> void:
	var attack_dir: Node = get_node_or_null("/root/AttackDir")
	_expect(attack_dir != null, "AttackDir autoload missing")
	if attack_dir == null:
		return
	_expect(attack_dir.has_method("request_pressure_threat"), "AttackDir missing V2 pressure facade")
	_expect(attack_dir.get_node_or_null("PressureDirectorV2") != null, "AttackDir did not install shared PressureDirectorV2")
	if not attack_dir.has_method("request_pressure_threat"):
		return

	var legacy := Node2D.new()
	legacy.name = "LegacyPressureBlocker"
	add_child(legacy)
	var migrated := Node2D.new()
	migrated.name = "MigratedPressureRequester"
	add_child(migrated)
	var role_granted: bool = bool(attack_dir.call("request_role", legacy, "melee_attack"))
	_expect(role_granted, "legacy melee role was not available in clean test state")
	if role_granted:
		var now: float = Time.get_ticks_msec() * 0.001
		var result_value: Variant = attack_dir.call("request_pressure_threat", migrated, {
			"attack_id": "migration_guard",
			"impact_at": now + 0.70,
			"impact_delay": 0.70,
			"severity": "normal",
			"active_duration": 0.12,
		})
		_expect(result_value is Dictionary, "AttackDir pressure facade returned invalid response")
		if result_value is Dictionary:
			var result: Dictionary = result_value as Dictionary
			_expect(not bool(result.get("admitted", true)), "V2 pressure bypassed active legacy melee holder")
			_expect(str(result.get("reason", "")) == "legacy_melee_active", "legacy compatibility denial used wrong reason")
		attack_dir.call("release_role", legacy, "melee_attack")

	legacy.queue_free()
	migrated.queue_free()


func _test_swordsman_integration() -> void:
	var target := CharacterBody2D.new()
	target.name = "PressureTarget"
	target.add_to_group("player")
	target.global_position = Vector2(70.0, 0.0)
	add_child(target)
	var enemy: Node = SWORDSMAN_SCENE.instantiate()
	if enemy == null:
		_fail("could not instantiate canonical Corrupted Swordsman")
		target.queue_free()
		return
	enemy.name = "PressureSwordsman"
	add_child(enemy)
	await get_tree().process_frame
	if enemy.has_method("set_physics_process"):
		enemy.set_physics_process(false)

	_expect(enemy.has_method("has_v2_pressure_runtime"), "canonical Swordsman is not routed through pressure adapter")
	if enemy.has_method("has_v2_pressure_runtime"):
		_expect(bool(enemy.call("has_v2_pressure_runtime")), "canonical Swordsman cannot reach shared pressure runtime")
	_expect(enemy.has_method("has_v2_enemy_brain_runtime") and bool(enemy.call("has_v2_enemy_brain_runtime")), "Swordsman lost EnemyBrain")
	_expect(enemy.has_method("has_v2_action_motor_runtime") and bool(enemy.call("has_v2_action_motor_runtime")), "Swordsman lost ActionRunner/EnemyMotor")
	_expect(enemy.get_node_or_null("PostureBar") != null, "Swordsman lost canonical PostureBar")

	if enemy.has_method("_v2_pressure_request_for_attack"):
		var normal_value: Variant = enemy.call("_v2_pressure_request_for_attack", 0, Time.get_ticks_msec() * 0.001, false)
		_expect(normal_value is Dictionary, "Swordsman could not author a pressure request")
		if normal_value is Dictionary:
			_expect(str((normal_value as Dictionary).get("severity", "")) == "normal", "basic Swordsman attack did not author normal severity")
	else:
		_fail("Swordsman missing pressure request authoring surface")

	if is_instance_valid(enemy):
		enemy.queue_free()
	if is_instance_valid(target):
		target.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("[PressureDirectorSmoke] PASS - overlapping windups | spaced impacts | perilous safety | legacy compatibility | Swordsman integration")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[PressureDirectorSmoke] %s" % failure)
	print("[PressureDirectorSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
