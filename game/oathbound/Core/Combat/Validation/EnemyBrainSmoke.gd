extends Node

const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")
const SWORDSMAN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	_test_shared_brain_cadence()
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

	brain.invalidate_intent("smoke")
	_expect(brain.current_intent() == &"idle", "invalidating brain intent did not return to idle")
	actor.queue_free()


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

	# Area 1 guard propensity is pressure-responsive, not a random roll on each hit.
	# At full Health while its own attack is cooling down, strafe should still beat guard.
	# After Akio has built meaningful Health/Posture pressure, the finite guard becomes
	# the preferred defensive punctuation so one block can realistically save the six-hit line.
	if enemy.has_method("area1_guard_score_for_test"):
		enemy.set("hp", 80)
		enemy.set("_max_hp", 80)
		enemy.set("next_swipe_time", now + 1.0)
		if enemy.has_method("set_posture_value"):
			enemy.call("set_posture_value", 0.0)
		var full_scores_value: Variant = enemy.call("_v2_build_intent_scores", now, 55.0)
		if full_scores_value is Dictionary:
			var full_scores: Dictionary = full_scores_value as Dictionary
			_expect(float(full_scores.get(&"guard", -INF)) < float(full_scores.get(&"strafe", -INF)), "full-Health Swordsman over-prioritizes guard during attack cooldown")

		enemy.set("hp", 55)
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