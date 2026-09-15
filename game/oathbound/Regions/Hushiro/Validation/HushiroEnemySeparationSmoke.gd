extends Node

const SEPARATION_SCRIPT = preload("res://Regions/Hushiro/Combat/HushiroEnemySeparationRuntime.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var arena := Node2D.new()
	arena.name = "SeparationSmokeArena"
	add_child(arena)

	var hollow := _make_enemy(arena, "HollowA", "hollow", Vector2(0.0, 0.0), 10.0)
	var swordsman := _make_enemy(arena, "SwordsmanB", "swordsman", Vector2(10.0, 0.0), 10.0)
	var unrelated := _make_enemy(arena, "UnrelatedEnemy", "foreign_test_role", Vector2(0.0, 80.0), 10.0)
	var unrelated_partner := _make_enemy(arena, "UnrelatedEnemyB", "foreign_test_role", Vector2(8.0, 80.0), 10.0)
	var unrelated_initial_distance := unrelated.global_position.distance_to(unrelated_partner.global_position)

	var runtime_value: Variant = SEPARATION_SCRIPT.new()
	if not (runtime_value is Node):
		_fail("separation runtime failed to instantiate")
		_finish()
		return
	var runtime := runtime_value as Node
	runtime.name = "HushiroEnemySeparationRuntime"
	arena.add_child(runtime)

	for _frame: int in range(8):
		await get_tree().physics_frame

	var resolved_distance := hollow.global_position.distance_to(swordsman.global_position)
	_expect(resolved_distance >= 29.5, "Hushiro pair did not resolve to the 30px minimum clearance: %.2f" % resolved_distance)
	_expect(int(runtime.get("correction_count")) > 0, "separation runtime never corrected an overlapping Hushiro pair")
	_expect(absf(unrelated.global_position.distance_to(unrelated_partner.global_position) - unrelated_initial_distance) < 0.01, "non-Hushiro enemies were unexpectedly moved by Hushiro separation")

	var state_value: Variant = runtime.call("get_state_for_test")
	if state_value is Dictionary:
		var state := state_value as Dictionary
		_expect(absf(float(state.get("minimum_center_clearance", 0.0)) - 30.0) < 0.01, "minimum separation contract drifted")
		_expect(float(state.get("max_correction_per_body_per_tick", 99.0)) <= 4.0, "separation correction became too aggressive")
	else:
		_fail("separation runtime state unavailable")

	arena.queue_free()
	await get_tree().process_frame
	_finish()


func _make_enemy(parent: Node2D, enemy_name: String, role: String, position_value: Vector2, radius: float) -> CharacterBody2D:
	var enemy := CharacterBody2D.new()
	enemy.name = enemy_name
	enemy.position = position_value
	enemy.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	enemy.add_to_group("enemy")
	enemy.set_meta("presentation_role", role)
	enemy.set_meta("hushiro_enemy_type", role)

	var collision := CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	var circle := CircleShape2D.new()
	circle.radius = radius
	collision.shape = circle
	enemy.add_child(collision)
	parent.add_child(enemy)
	return enemy


func _finish() -> void:
	if _failures.is_empty():
		print("[HushiroEnemySeparationSmoke] PASS - overlapping standard enemies resolve without affecting unrelated roles")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[HushiroEnemySeparationSmoke] %s" % failure)
	print("[HushiroEnemySeparationSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
