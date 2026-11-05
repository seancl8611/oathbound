extends Node

const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")
const SWORDSMAN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn")
const SURROUND_SCRIPT = preload("res://Regions/Hushiro/Combat/HushiroMeleeSurroundCoordinator.gd")

class MockSwordsman:
	extends CharacterBody2D

	func uses_hades_melee_policy() -> bool:
		return true

	func is_dead() -> bool:
		return false

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	_test_shared_brain_cadence()
	_test_hades_action_clock()
	_test_hades_surround_coordinator()
	await _test_swordsman_integration()
	_finish()


func _test_shared_brain_cadence() -> void:
	var actor := Node2D.new()
	actor.name = "BrainActor"
	add_child(actor)
	var brain_value: Variant = ENEMY_BRAIN_SCRIPT.new()
	if not (brain_value is EnemyBrain):
		_fail("could not instantiate EnemyBrain")
		actor.queue_free()
		return
	var brain: EnemyBrain = brain_value as EnemyBrain
	actor.add_child(brain)
	brain.configure(actor, 0.20, 0.10, 0.05)

	var first: StringName = brain.choose_intent(10.0, {
		&"attack": 0.90,
		&"approach": 0.30,
		&"retreat": 0.10,
	})
	_expect(first == &"attack", "highest-scored initial intent was not selected")

	# A radically different score set inside the cadence window must not churn the
	# tactical decision. This protects against the legacy per-physics-frame behavior.
	var held: StringName = brain.choose_intent(10.05, {
		&"attack": 0.05,
		&"retreat": 2.00,
	})
	_expect(held == &"attack", "intent changed inside decision cadence window")

	var reconsidered: StringName = brain.choose_intent(10.25, {
		&"attack": 0.05,
		&"retreat": 2.00,
	})
	_expect(reconsidered == &"retreat", "brain did not reconsider after cadence elapsed")
	_expect(int(brain.last_scores().size()) == 2, "brain did not retain latest score snapshot")

	# The first invalidation is a real state transition. Once idle with no scheduled
	# decision, repeated deaggro-style invalidations must be no-ops so they do not churn
	# timestamps or emit duplicate invalidation telemetry every physics frame.
	var first_invalidated: bool = brain.invalidate_intent("smoke")
	_expect(first_invalidated, "first invalidation did not report a state transition")
	_expect(brain.current_intent() == &"idle", "invalidating brain intent did not return to idle")
	_expect(brain.next_decision_at() < 0.0, "invalidating brain intent did not clear decision scheduling")
	var first_invalidated_at: float = float(brain.get("_intent_started_at"))
	var repeated_invalidated: bool = brain.invalidate_intent("smoke_repeat")
	_expect(not repeated_invalidated, "repeated invalidation was not treated as a no-op")
	_expect(is_equal_approx(float(brain.get("_intent_started_at")), first_invalidated_at), "no-op invalidation rewrote intent timestamp")
	_expect(brain.next_decision_at() < 0.0, "no-op invalidation reintroduced decision scheduling")

	actor.queue_free()


func _test_hades_action_clock() -> void:
	var runner := CombatActionRunner.new()
	add_child(runner)
	var definition := CombatActionDefinition.new()
	definition.action_id = &"running_swing"
	definition.startup_duration = 0.5
	definition.active_duration = 0.18
	definition.recovery_duration = 0.24
	runner.begin(definition)
	runner.begin_approach()
	runner.tick(1.25)
	_expect(runner.phase_name() == "APPROACH", "running approach lost explicit phase")
	_expect(is_zero_approx(runner.action_progress()), "approach is consuming visual attack frames before windup")

	runner.begin_windup(0.52)
	runner.tick(0.16)
	_expect(runner.phase_name() == "STARTUP", "actual windup did not begin after approach")
	_expect(runner.action_progress() < 0.25, "real windup incorrectly retained elapsed approach time")
	runner.mark_active()
	_expect(runner.phase_name() == "ACTIVE", "active hitbox phase not reflected by runner")
	_expect(is_zero_approx(runner.phase_progress()), "active strike begins mid-animation")
	runner.tick(0.06)
	_expect(runner.phase_progress() > 0.2, "active strike progress must advance from real impact")
	runner.mark_recovery()
	_expect(runner.phase_name() == "RECOVERY", "real recovery phase missing")
	runner.complete()
	runner.queue_free()


func _test_hades_surround_coordinator() -> void:
	var room := Node2D.new()
	room.name = "HadesSurroundSmokeRoom"
	add_child(room)
	var player := Node2D.new()
	player.global_position = Vector2.ZERO
	room.add_child(player)
	var coordinator: Node = SURROUND_SCRIPT.new()
	room.add_child(coordinator)

	var first := MockSwordsman.new()
	first.global_position = Vector2(72.0, 0.0)
	room.add_child(first)
	first.add_to_group("enemy")
	var second := MockSwordsman.new()
	second.global_position = Vector2(-82.0, 0.0)
	room.add_child(second)
	second.add_to_group("enemy")

	var first_plan: Dictionary = coordinator.call("plan_for", first, player)
	var second_plan: Dictionary = coordinator.call("plan_for", second, player)
	_expect(first_plan.get("role") == "engage", "nearest Swordsman should claim first engagement")
	_expect(second_plan.get("role") == "support", "second Swordsman should hold support, not rush Akio")
	var support_point: Vector2 = second_plan.get("position", Vector2.ZERO)
	_expect(support_point.distance_to(player.global_position) >= 90.0, "support position is inside melee pile")
	for test_index: int in range(8):
		_expect(coordinator.call("role_for_test", first, player) == "engage", "first Swordsman engagement churned")
		_expect(coordinator.call("role_for_test", second, player) == "support", "second Swordsman orbit role churned")

	coordinator.set("_engager_lease_until", 0.0)
	coordinator.call("attack_completed", first)
	_expect(coordinator.call("role_for_test", second, player) == "engage",
		"attack completion should rotate engagement to waiting Swordsman")
	_expect(coordinator.call("role_for_test", first, player) == "support",
		"completed attacker should recover outside immediate engagement")

	# Retaliation rule: a player who pursues a support Swordsman at close range
	# should not make that enemy flee indefinitely while the lead is far away.
	coordinator.set("_engager_lease_until", 0.0)
	player.global_position = Vector2(70.0, 0.0)
	_expect(coordinator.call("role_for_test", first, player) == "engage",
		"close-pressured support unit failed to become the active attacker")
	room.queue_free()


func _test_swordsman_integration() -> void:
	var target := CharacterBody2D.new()
	target.name = "BrainTarget"
	target.add_to_group("player")
	target.global_position = Vector2(70.0, 0.0)
	add_child(target)

	var enemy: Node = SWORDSMAN_SCENE.instantiate()
	if enemy == null:
		_fail("could not instantiate canonical Corrupted Swordsman")
		target.queue_free()
		return
	enemy.name = "BrainSwordsman"
	add_child(enemy)
	await get_tree().process_frame
	if enemy.has_method("set_physics_process"):
		enemy.set_physics_process(false)

	_expect(enemy.has_method("has_v2_action_motor_runtime"), "Swordsman lost Phase 2 action/motor runtime")
	if enemy.has_method("has_v2_action_motor_runtime"):
		_expect(bool(enemy.call("has_v2_action_motor_runtime")), "Swordsman Phase 2 action/motor runtime is not active")
	_expect(enemy.has_method("has_v2_enemy_brain_runtime"), "canonical Swordsman is not routed through V2 brain layer")
	if enemy.has_method("has_v2_enemy_brain_runtime"):
		_expect(bool(enemy.call("has_v2_enemy_brain_runtime")), "canonical Swordsman failed to attach EnemyBrain")
	_expect(enemy.get_node_or_null("EnemyBrain") != null, "canonical Swordsman missing EnemyBrain child")
	_expect(enemy.get_node_or_null("CombatActionRunner") != null, "canonical Swordsman lost CombatActionRunner child")
	_expect(enemy.get_node_or_null("EnemyMotor") != null, "canonical Swordsman lost EnemyMotor child")
	_expect(enemy.has_method("uses_legacy_advance_move_gate") and not bool(enemy.call("uses_legacy_advance_move_gate")), "migrated Swordsman still declares legacy advance_move ownership")

	var now: float = Time.get_ticks_msec() * 0.001
	enemy.set("_last_attack_ended_at", now - 10.0)
	enemy.set("next_swipe_time", 0.0)
	enemy.set("stunned_until", 0.0)
	if enemy.has_method("_v2_build_intent_scores"):
		var scores_value: Variant = enemy.call("_v2_build_intent_scores", now, 70.0)
		_expect(scores_value is Dictionary, "Swordsman brain score builder did not return a Dictionary")
		if scores_value is Dictionary:
			var scores: Dictionary = scores_value as Dictionary
			_expect(scores.has(&"attack"), "Swordsman brain scores missing attack intent")
			_expect(scores.has(&"approach"), "Swordsman brain scores missing approach intent")
			_expect(scores.has(&"strafe"), "Swordsman brain scores missing strafe intent")
			_expect(scores.has(&"guard"), "Swordsman brain scores missing guard intent")
			_expect(scores.has(&"retreat"), "Swordsman brain scores missing retreat intent")
	else:
		_fail("Swordsman missing V2 intent scoring surface")

	# November 5 visual-proxy playtest: ordinary slash hitboxes could not reach
	# attacks randomly selected at 80-125 units. This contract must never regress.
	if enemy.has_method("_v2_reliable_melee_range") and enemy.has_method("_v2_attack_start_eligible"):
		var reliable_reach: float = float(enemy.call("_v2_reliable_melee_range"))
		_expect(reliable_reach >= 48.0 and reliable_reach <= 60.0, "Swordsman melee gate is not calibrated to its shortest blade")
		_expect(bool(enemy.call("_v2_attack_start_eligible", 50.0)), "Swordsman lost safe close melee")
		_expect(not bool(enemy.call("_v2_attack_start_eligible", 70.0)), "Swordsman may still launch a stationary slash from 70 units")
		_expect(bool(enemy.call("_v2_attack_start_eligible", 96.0)), "Swordsman lost legitimate long-range running approach")
		_expect(not bool(enemy.call("_v2_attack_start_eligible", 140.0)), "Swordsman can attack beyond approach envelope")
		var gap_scores: Dictionary = enemy.call("_v2_build_intent_scores", now, 70.0)
		_expect(float(gap_scores.get(&"attack", -INF)) == -INF, "Swordsman scores normal attacks inside out-of-reach 55-79 gap")
		_expect(float(gap_scores.get(&"approach", -INF)) > float(gap_scores.get(&"strafe", -INF)), "Swordsman stays orbiting outside sword reach")
		_expect(int(enemy.call("_v2_attack_choice_for_distance", 96.0, 0)) == 3, "distant attack must force running approach, not pending Basic Swing")
	else:
		_fail("Swordsman missing reliable melee and approach contract")

	# Area 1 guard propensity is pressure-responsive, not a random roll on each hit.
	# At full Health while its own attack is cooling down, strafe should still beat guard.
	# After Akio has built meaningful Health/Posture pressure, the finite guard becomes
	# the preferred defensive punctuation so one block can realistically deny the clean
	# five-hit kill without making the Swordsman a durable solo threat.
	if enemy.has_method("area1_guard_score_for_test"):
		enemy.set("hp", 60)
		enemy.set("_max_hp", 60)
		enemy.set("next_swipe_time", now + 1.0)
		if enemy.has_method("set_posture_value"):
			enemy.call("set_posture_value", 0.0)
		var full_scores_value: Variant = enemy.call("_v2_build_intent_scores", now, 55.0)
		if full_scores_value is Dictionary:
			var full_scores: Dictionary = full_scores_value as Dictionary
			_expect(float(full_scores.get(&"guard", -INF)) < float(full_scores.get(&"strafe", -INF)), "full-Health Swordsman over-prioritizes guard during attack cooldown")

		enemy.set("hp", 40)
		if enemy.has_method("set_posture_value"):
			enemy.call("set_posture_value", 18.0)
		var pressured_scores_value: Variant = enemy.call("_v2_build_intent_scores", now, 55.0)
		if pressured_scores_value is Dictionary:
			var pressured_scores: Dictionary = pressured_scores_value as Dictionary
			_expect(float(pressured_scores.get(&"guard", -INF)) > float(pressured_scores.get(&"strafe", -INF)), "damaged/postured Swordsman guard did not become competitive under sustained pressure")
			_expect(float(pressured_scores.get(&"guard", -INF)) <= 0.98 + 0.001, "Area 1 tactical guard exceeded authored score cap")
	else:
		_fail("Swordsman missing Area 1 tactical guard score surface")

	# Free V2 locomotion must not reacquire the sticky legacy movement token.
	if enemy.has_method("_v2_move_approach"):
		enemy.call("_v2_move_approach", 0.016, Vector2.RIGHT, 120.0)
		var held_roles_value: Variant = enemy.get("_held_roles")
		if held_roles_value is Dictionary:
			_expect(not (held_roles_value as Dictionary).has("advance_move"), "Swordsman V2 approach reacquired legacy advance_move")

	# Room crowd backoff is now the authoritative close-body movement brake. It must
	# preempt tactical attack selection and force reposition without acquiring a role.
	enemy.set("_backoff_until", now + 1.0)
	enemy.call("_v2_brain_tick", 0.016)
	_expect(str(enemy.call("get_v2_brain_intent")) == "reposition", "Swordsman ignored active crowd backoff")
	var backed_roles_value: Variant = enemy.get("_held_roles")
	if backed_roles_value is Dictionary:
		_expect(not (backed_roles_value as Dictionary).has("advance_move"), "backed-off Swordsman acquired legacy advance_move")
	enemy.set("_backoff_until", -1.0)
	_expect(bool(enemy.call("uses_hades_melee_policy")), "Hades-inspired Swordsman policy not opted in")
	var actual_request: Dictionary = enemy.call(
		"_v2_pressure_request_for_attack", 3, now, false, 0.52
	)
	_expect(is_equal_approx(float(actual_request.get("impact_delay", -1.0)), 0.52),
		"Running Swing reservation still predicts approach after the enemy reached windup")
	enemy.set("next_swipe_time", now + 9.0)
	enemy.call("_v2_brain_tick", 0.016)
	_expect(str(enemy.call("get_hades_melee_state")) == "approach",
		"Swordsman still uses high-frequency tactical orbiting outside blade reach")

	# Running approach is simultaneously telegraphing=true. Its actual physics
	# velocity must be nonzero; old precedence suppressed it until timeout.
	target.global_position = Vector2(115.0, 0.0)
	(enemy as Node2D).global_position = Vector2.ZERO
	enemy.set("player", target)
	enemy.set("_in_running_approach", true)
	enemy.set("telegraphing", true)
	enemy.set("swinging", false)
	enemy.set("is_attacking", false)
	enemy.set("_backoff_until", -1.0)
	enemy.set("knockback", Vector2.ZERO)
	enemy.set_physics_process(true)
	await get_tree().physics_frame
	await get_tree().physics_frame
	# EnemyMotor accelerates movement across physics frames: the first two
	# ticks travel ~0.68 units while building positive forward velocity.
	_expect((enemy as Node2D).global_position.x > 0.2
		and (enemy as CharacterBody2D).velocity.x > 0.0,
		"Swordsman telegraphed running attack failed to move toward target")
	enemy.set_physics_process(false)
	enemy.set("_in_running_approach", false)
	enemy.set("telegraphing", false)

	if is_instance_valid(enemy):
		enemy.queue_free()
	if is_instance_valid(target):
		target.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("[EnemyBrainSmoke] PASS - controlled cadence | held intent | Swordsman tactical ownership | free V2 approach | crowd backoff")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[EnemyBrainSmoke] %s" % failure)
	print("[EnemyBrainSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
