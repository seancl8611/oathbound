extends Node

const HOLLOW_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/Hollow.tscn")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var hollow: Node = HOLLOW_SCENE.instantiate()
	hollow.name = "HollowV2MigrationSmokeEnemy"
	add_child(hollow)
	await get_tree().process_frame

	HUSHIRO_ENEMY_CONTRACT.apply(hollow, "hollow")
	await get_tree().physics_frame
	if hollow.has_method("set_physics_process"):
		hollow.set_physics_process(false)

	_expect(hollow.has_method("has_v2_hollow_runtime"), "canonical Hollow is not routed through HollowV2")
	if hollow.has_method("has_v2_hollow_runtime"):
		_expect(bool(hollow.call("has_v2_hollow_runtime")), "canonical Hollow failed to attach the shared V2 components")
	_expect(hollow.get_node_or_null("EnemyCombatResponseRuntime") != null, "Hollow missing EnemyCombatResponseRuntime")
	_expect(hollow.get_node_or_null("CombatActionRunner") != null, "Hollow missing CombatActionRunner")
	_expect(hollow.get_node_or_null("EnemyMotor") != null, "Hollow missing EnemyMotor")
	_expect(hollow.get_node_or_null("EnemyBrain") != null, "Hollow missing EnemyBrain")
	_expect(hollow.get_node_or_null("HushiroPostureBreakRuntime") != null, "Hollow lost shared Posture/Deathblow runtime")
	_expect(hollow.get_node_or_null("PostureBar") != null, "Hollow lost canonical PostureBar")

	_expect(int(hollow.get("hp")) == 40, "Hollow Hushiro hack-and-slash Health target is not 40")
	var combat: Node = hollow.get_node_or_null("Combat")
	if combat != null:
		var cfg: CombatConfig = combat.get("config") as CombatConfig
		_expect(cfg != null and is_equal_approx(float(cfg.posture_max), 40.0), "Hollow canonical Posture max is not 40")
	else:
		_fail("Hollow missing CombatController")

	if hollow.has_method("uses_legacy_hollow_turn_token"):
		_expect(not bool(hollow.call("uses_legacy_hollow_turn_token")), "Hollow still declares legacy whole-turn ownership")
	else:
		_fail("Hollow missing V2 legacy-token declaration")
	_expect(hollow.has_method("uses_legacy_advance_move_gate") and not bool(hollow.call("uses_legacy_advance_move_gate")), "Hollow unexpectedly uses legacy advance_move ownership")

	# Fodder policy: at bite distance with cooldown ready, the one authored attack wins.
	hollow.set("_next_attack_ready", -1.0)
	hollow.set("_v2_pressure_retry_until", -1.0)
	var scores_value: Variant = hollow.call("_v2_hollow_intent_scores", 10.0, 34.0)
	if scores_value is Dictionary:
		var scores: Dictionary = scores_value as Dictionary
		_expect(float(scores.get(&"bite", -INF)) > float(scores.get(&"approach", -INF)), "Hollow close-range brain does not prefer its one readable bite")
		_expect(float(scores.get(&"bite", -INF)) > float(scores.get(&"orbit", -INF)), "Hollow close-range brain over-orbits instead of threatening")
	else:
		_fail("Hollow V2 intent scores unavailable")

	# Hollows remain ungated swarm bodies, but room crowd backoff must be authoritative
	# for excess close-frontline bodies. It suppresses a fresh bite and forces a
	# reposition rather than letting the swarm ignore the room occupancy decision.
	var dummy_player := CharacterBody2D.new()
	dummy_player.name = "HollowBackoffDummyPlayer"
	dummy_player.global_position = Vector2(34.0, 0.0)
	add_child(dummy_player)
	hollow.set("player", dummy_player)
	hollow.set("_backoff_until", 11.0)
	var backed_scores_value: Variant = hollow.call("_v2_hollow_intent_scores", 10.0, 34.0)
	if backed_scores_value is Dictionary:
		var backed_scores: Dictionary = backed_scores_value as Dictionary
		var backed_bite: float = float(backed_scores.get(&"bite", -INF))
		_expect(is_inf(backed_bite) and backed_bite < 0.0, "backed-off Hollow still offered bite pressure")
	else:
		_fail("Hollow backoff score surface unavailable")
	hollow.call("_tick_chase", 10.0)
	_expect(str(hollow.call("get_v2_hollow_intent")) == "reposition", "Hollow ignored active crowd backoff")
	hollow.set("_backoff_until", -1.0)

	var request_value: Variant = hollow.call("_v2_hollow_pressure_request", 20.0, 34.0)
	if request_value is Dictionary:
		var request: Dictionary = request_value as Dictionary
		_expect(str(request.get("attack_id", "")) == "hollow_bite", "Hollow pressure request lost bite identity")
		_expect(str(request.get("severity", "")) == "normal", "Hollow bite should be normal pressure, not heavy/perilous")
		_expect(float(request.get("threat_cost", 99.0)) < 1.0, "Hollow fodder bite consumes too much pressure budget")
		_expect(is_equal_approx(float(request.get("impact_delay", 0.0)), float(hollow.get("bite_windup"))), "Hollow pressure impact timing does not match authored windup")
	else:
		_fail("Hollow V2 pressure request unavailable")

	# Begin the real authored bite and verify explicit commitment/action ownership.
	hollow.call("_begin_bite", Vector2.RIGHT)
	_expect(str(hollow.call("get_v2_hollow_action_phase")) == "STARTUP", "Hollow bite did not enter CombatActionRunner STARTUP")
	var runner: Node = hollow.get_node_or_null("CombatActionRunner")
	if runner != null:
		runner.call("tick", float(hollow.get("bite_windup")) * 0.60)
		_expect(str(hollow.call("get_v2_hollow_action_phase")) == "COMMITTED", "Hollow bite did not cross explicit commitment")

	# Fodder identity is deliberate: ordinary poise power interrupts even after commit.
	var response: Node = hollow.get_node_or_null("EnemyCombatResponseRuntime")
	if response != null:
		var profile_value: Variant = response.get("profile")
		if profile_value is EnemyCombatResponseProfile:
			var profile: EnemyCombatResponseProfile = profile_value as EnemyCombatResponseProfile
			_expect(profile.committed_poise_required == 1, "Hollow committed bite gained elite-style Poise")
		_expect(bool(response.call("should_interrupt", null, {}, true)), "ordinary hit cannot interrupt committed Hollow bite")
	else:
		_fail("Hollow response runtime unavailable for Poise assertion")

	if hollow.has_method("has_v2_hollow_pressure_runtime"):
		_expect(bool(hollow.call("has_v2_hollow_pressure_runtime")), "Hollow cannot reach PressureDirectorV2")

	hollow.queue_free()
	dummy_player.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[HollowV2MigrationSmoke] PASS - simple fodder brain | pressure bite | commitment | low poise | Posture preserved | crowd backoff")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[HollowV2MigrationSmoke] %s" % failure)
	print("[HollowV2MigrationSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
