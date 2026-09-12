extends Node

const ARCHER_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcher.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var archer: Node = ARCHER_SCENE.instantiate()
	archer.name = "ArcherV2MigrationSmokeEnemy"
	add_child(archer)
	await get_tree().process_frame
	archer.set_physics_process(false)

	_expect(archer.has_method("has_v2_archer_runtime"), "canonical Archer is not routed through CorruptedArcherV2")
	if archer.has_method("has_v2_archer_runtime"):
		_expect(bool(archer.call("has_v2_archer_runtime")), "canonical Archer failed to attach shared V2 components")
	_expect(archer.get_node_or_null("EnemyCombatResponseRuntime") != null, "Archer missing EnemyCombatResponseRuntime")
	_expect(archer.get_node_or_null("CombatActionRunner") != null, "Archer missing CombatActionRunner")
	_expect(archer.get_node_or_null("EnemyMotor") != null, "Archer missing EnemyMotor")
	_expect(archer.get_node_or_null("EnemyBrain") != null, "Archer missing EnemyBrain")
	_expect(archer.get_node_or_null("HushiroPostureBreakRuntime") != null, "Archer lost shared Posture/Deathblow runtime")
	_expect(archer.get_node_or_null("PostureBar") != null, "Archer lost canonical PostureBar")

	_expect(int(archer.get("hp")) == 60, "Archer Hushiro Health baseline is not the Area 1 five-hit target")
	var combat: Node = archer.get_node_or_null("Combat")
	if combat != null:
		var cfg: CombatConfig = combat.get("config") as CombatConfig
		_expect(cfg != null and is_equal_approx(float(cfg.posture_max), 65.0), "Archer canonical Posture max is not 65")
	else:
		_fail("Archer missing CombatController")

	if archer.has_method("uses_legacy_archer_ranged_role"):
		_expect(not bool(archer.call("uses_legacy_archer_ranged_role")), "Archer still declares legacy ranged-role ownership")
	else:
		_fail("Archer missing V2 legacy-role declaration")

	# At preferred firing distance with cooldown ready, spatial pressure should beat
	# passive hold/reposition. The brain decision cadence may hold it afterwards, but
	# this score contract keeps Archer's identity focused on ranged threat.
	archer.set("next_swipe_time", -1.0)
	archer.set("_v2_pressure_retry_until", -1.0)
	var score_value: Variant = archer.call("_v2_archer_intent_scores", 10.0, 140.0)
	if score_value is Dictionary:
		var scores: Dictionary = score_value as Dictionary
		_expect(float(scores.get(&"shoot", -INF)) > float(scores.get(&"reposition", -INF)), "Archer preferred-range brain does not prioritize a ready shot")
		_expect(float(scores.get(&"shoot", -INF)) > float(scores.get(&"hold", -INF)), "Archer preferred-range brain over-holds instead of applying ranged pressure")
	else:
		_fail("Archer V2 intent scores unavailable")

	var request_value: Variant = archer.call("get_v2_archer_pressure_request_for_test", 20.0)
	if request_value is Dictionary:
		var request: Dictionary = request_value as Dictionary
		_expect(str(request.get("attack_id", "")) == "archer_arrow", "Archer pressure request lost arrow identity")
		_expect(str(request.get("pressure_channel", "")) == "ranged", "Archer pressure request is not authored as ranged/spatial pressure")
		_expect(str(request.get("severity", "")) == "normal", "Archer base arrow should be normal pressure")
		_expect(float(request.get("threat_cost", 99.0)) < 1.0, "Archer arrow consumes melee-heavy pressure budget")
		_expect(float(request.get("impact_delay", 0.0)) > float(archer.get("aim_duration")), "Archer pressure window ends at bow release instead of predicted arrow arrival")
	else:
		_fail("Archer V2 pressure request unavailable")

	# Bow action has a real commitment boundary. Before commitment the aim may track;
	# after commitment the target is frozen so late lateral movement can make it miss.
	archer.call("_begin_v2_archer_action")
	_expect(str(archer.call("get_v2_archer_action_phase")) == "STARTUP", "Archer bow action did not enter CombatActionRunner STARTUP")
	var runner: Node = archer.get_node_or_null("CombatActionRunner")
	if runner != null:
		_expect(bool(runner.call("allows_target_tracking")), "Archer aim cannot track during early startup")
		runner.call("tick", float(archer.get("aim_duration")) * 0.70)
		_expect(str(archer.call("get_v2_archer_action_phase")) == "COMMITTED", "Archer bow action did not cross explicit commitment")
		_expect(not bool(runner.call("allows_target_tracking")), "Archer aim still tracks after commitment")

	# Ranged enemy is deliberately fragile under close pressure: a normal canonical hit
	# interrupts even committed bow preparation. Projectile pressure already launched is
	# handled separately by its reservation/projectile lifecycle.
	var response: Node = archer.get_node_or_null("EnemyCombatResponseRuntime")
	if response != null:
		var profile_value: Variant = response.get("profile")
		if profile_value is EnemyCombatResponseProfile:
			var profile: EnemyCombatResponseProfile = profile_value as EnemyCombatResponseProfile
			_expect(profile.committed_poise_required == 1, "Archer committed aim gained heavy-enemy Poise")
		_expect(bool(response.call("should_interrupt", null, {}, true)), "ordinary hit cannot interrupt committed Archer aim")
	else:
		_fail("Archer response runtime unavailable for Poise assertion")

	if archer.has_method("has_v2_archer_pressure_runtime"):
		_expect(bool(archer.call("has_v2_archer_pressure_runtime")), "Archer cannot reach PressureDirectorV2")

	archer.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[ArcherV2MigrationSmoke] PASS - ranged brain | arrival pressure | aim commitment | low poise | Posture preserved")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[ArcherV2MigrationSmoke] %s" % failure)
	print("[ArcherV2MigrationSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
