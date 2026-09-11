extends Node

const HOUND_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/BlightedHound.tscn")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	await _test_canonical_hound_v2_runtime()
	_finish()


func _test_canonical_hound_v2_runtime() -> void:
	var dummy_player := CharacterBody2D.new()
	dummy_player.name = "HoundV2DummyPlayer"
	dummy_player.add_to_group("player")
	dummy_player.global_position = Vector2(90.0, 0.0)
	add_child(dummy_player)

	var hound: Node = HOUND_SCENE.instantiate()
	if hound == null:
		_fail("could not instantiate canonical Blighted Hound")
		dummy_player.queue_free()
		return
	hound.name = "HoundV2MigrationSmokeHound"
	add_child(hound)
	await get_tree().process_frame

	HUSHIRO_ENEMY_CONTRACT.apply(hound, "hound")
	await get_tree().physics_frame
	if hound.has_method("set_physics_process"):
		hound.set_physics_process(false)

	_expect(hound.has_method("has_v2_hound_runtime"), "canonical Hound is not routed through V2 migration layer")
	if hound.has_method("has_v2_hound_runtime"):
		_expect(bool(hound.call("has_v2_hound_runtime")), "canonical Hound failed to attach all shared V2 components")
	_expect(hound.get_node_or_null("EnemyCombatResponseRuntime") != null, "Hound missing EnemyCombatResponseRuntime")
	_expect(hound.get_node_or_null("CombatActionRunner") != null, "Hound missing CombatActionRunner")
	_expect(hound.get_node_or_null("EnemyMotor") != null, "Hound missing EnemyMotor")
	_expect(hound.get_node_or_null("EnemyBrain") != null, "Hound missing EnemyBrain")
	_expect(hound.has_method("uses_legacy_hound_turn_token") and not bool(hound.call("uses_legacy_hound_turn_token")), "Hound still declares legacy whole-turn token ownership")

	if hound.has_method("has_v2_hound_pressure_runtime"):
		_expect(bool(hound.call("has_v2_hound_pressure_runtime")), "canonical Hound cannot reach PressureDirectorV2 facade")
	else:
		_fail("Hound missing pressure-runtime introspection")

	# Predator intent should favor a pounce at authored mid-range when attacks are ready.
	var now: float = Time.get_ticks_msec() * 0.001
	var scores_value: Variant = hound.call("_v2_hound_intent_scores", now, 90.0)
	if scores_value is Dictionary:
		var scores: Dictionary = scores_value as Dictionary
		_expect(float(scores.get(&"lunge", -INF)) > float(scores.get(&"approach", -INF)), "mid-range Hound intent does not prefer its authored lunge")
	else:
		_fail("Hound intent score surface unavailable")

	# Pressure scheduling describes dangerous impact timing rather than owning the full
	# windup. A lunge is heavier than a bite and predicts impact after startup/travel.
	var pressure_value: Variant = hound.call("_v2_hound_pressure_request", &"lunge", now, 90.0)
	if pressure_value is Dictionary:
		var pressure: Dictionary = pressure_value as Dictionary
		_expect(str(pressure.get("severity", "")) == "heavy", "Hound lunge pressure was not classified heavy")
		_expect(float(pressure.get("impact_at", now)) > now, "Hound lunge pressure did not predict a future impact")
	else:
		_fail("Hound pressure request surface unavailable")

	# The response model makes the beast easy to stagger while neutral but gives a
	# committed pounce enough Poise to survive a weak hit. Strong impacts still stop it.
	if hound.has_method("_begin_v2_hound_action"):
		hound.call("_begin_v2_hound_action", &"hound_smoke_lunge", 0.40, 0.20, 0.30, 0.50, 0.34, 0.08, 0.0, 0.58)
		_expect(str(hound.call("get_v2_hound_action_phase")) == "STARTUP", "Hound action did not enter STARTUP")
		var runner: Node = hound.get_node_or_null("CombatActionRunner")
		if runner != null:
			runner.call("tick", 0.21)
		_expect(str(hound.call("get_v2_hound_action_phase")) == "COMMITTED", "Hound action did not expose commitment boundary")
		var response: Node = hound.get_node_or_null("EnemyCombatResponseRuntime")
		if response != null:
			_expect(not bool(response.call("should_interrupt", null, {}, true)), "weak hit incorrectly interrupts committed Hound action")
			_expect(bool(response.call("should_interrupt", null, {"heavy": true}, true)), "strong hit failed to interrupt committed Hound action")
		else:
			_fail("Hound response runtime unavailable for Poise validation")
	else:
		_fail("Hound missing V2 action adapter")

	# Existing Hushiro Posture/Deathblow compatibility remains attached; V2 does not
	# replace the canonical buildup/readability contract.
	_expect(hound.get_node_or_null("HushiroHoundCombatRuntime") != null, "Hound lost shared Posture adapter")
	_expect(hound.get_node_or_null("HushiroPostureBreakRuntime") != null, "Hound lost shared Posture-break runtime")
	_expect(hound.get_node_or_null("PostureBar") != null, "Hound lost canonical PostureBar")

	if is_instance_valid(hound):
		hound.queue_free()
	if is_instance_valid(dummy_player):
		dummy_player.queue_free()
	await get_tree().process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("[HoundV2MigrationSmoke] PASS - predator brain | action commitment | motor ownership | Poise | pressure windows | Posture preservation")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[HoundV2MigrationSmoke] %s" % failure)
	print("[HoundV2MigrationSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
