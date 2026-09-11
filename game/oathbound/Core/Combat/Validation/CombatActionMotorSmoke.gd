extends Node

const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ENEMY_MOTOR_SCRIPT = preload("res://Core/Combat/EnemyMotor.gd")
const SWORDSMAN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	_test_shared_action_motor()
	await _test_swordsman_integration()
	_finish()


func _test_shared_action_motor() -> void:
	var actor := CharacterBody2D.new()
	actor.name = "ActionMotorActor"
	add_child(actor)

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	var motor_value: Variant = ENEMY_MOTOR_SCRIPT.new()
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (runner_value is CombatActionRunner) or not (motor_value is EnemyMotor) or not (definition_value is CombatActionDefinition):
		_fail("could not instantiate Combat V2 action/motor foundation")
		actor.queue_free()
		return

	var runner: CombatActionRunner = runner_value as CombatActionRunner
	var motor: EnemyMotor = motor_value as EnemyMotor
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	actor.add_child(runner)
	actor.add_child(motor)
	runner.configure(actor)
	motor.configure(actor, 820.0, 1080.0, 380.0)

	definition.action_id = &"smoke_slash"
	definition.startup_duration = 0.40
	definition.commit_fraction = 0.50
	definition.active_duration = 0.20
	definition.recovery_duration = 0.20
	definition.startup_locomotion_weight = 0.65
	definition.committed_locomotion_weight = 0.18
	definition.active_locomotion_weight = 0.06
	definition.recovery_locomotion_weight = 0.42

	motor.reset_locomotion(Vector2(120.0, 0.0))
	runner.begin(definition)
	_expect(runner.phase_name() == "STARTUP", "action did not begin in STARTUP")
	_expect(runner.allows_target_tracking(), "early STARTUP should allow target tracking")
	_expect(not runner.is_committed(), "early STARTUP incorrectly reported committed")

	var startup_velocity: Vector2 = motor.resolve_velocity(0.05, Vector2.ZERO, Vector2.ZERO, runner)
	_expect(startup_velocity.x > 1.0, "startup snapped prior locomotion momentum to zero")
	_expect(startup_velocity.x < 120.0, "startup did not attenuate locomotion through action weight")

	runner.tick(0.21)
	_expect(runner.phase_name() == "COMMITTED", "runner did not cross authored commitment point")
	_expect(runner.is_committed(), "COMMITTED phase did not report committed")
	_expect(not runner.allows_target_tracking(), "target tracking survived past commitment")

	runner.mark_active()
	motor.set_action_motion(Vector2.RIGHT, 200.0, 0.20)
	var active_velocity: Vector2 = motor.resolve_velocity(0.05, Vector2.ZERO, Vector2.ZERO, runner)
	_expect(runner.phase_name() == "ACTIVE", "legacy adapter could not announce ACTIVE")
	_expect(active_velocity.x > 150.0, "active authored action motion was not composed by EnemyMotor")

	runner.mark_recovery()
	_expect(runner.phase_name() == "RECOVERY", "legacy adapter could not announce RECOVERY")
	_expect(is_equal_approx(runner.locomotion_weight(), 0.42), "recovery locomotion weight was not preserved")

	runner.interrupt("smoke")
	motor.clear_action_motion()
	_expect(runner.phase_name() == "IDLE", "interrupt did not clear action lifecycle")
	_expect(not motor.has_action_motion(), "interrupt did not clear authored action motion")
	actor.queue_free()


func _test_swordsman_integration() -> void:
	var enemy: Node = SWORDSMAN_SCENE.instantiate()
	if enemy == null:
		_fail("could not instantiate canonical Corrupted Swordsman")
		return
	enemy.name = "ActionMotorSwordsman"
	add_child(enemy)
	await get_tree().process_frame

	if enemy.has_method("set_physics_process"):
		enemy.set_physics_process(false)

	_expect(enemy.has_method("has_v2_action_motor_runtime"), "canonical Swordsman is not routed through V2 motion layer")
	if enemy.has_method("has_v2_action_motor_runtime"):
		_expect(bool(enemy.call("has_v2_action_motor_runtime")), "canonical Swordsman failed to attach ActionRunner/EnemyMotor")
	_expect(enemy.get_node_or_null("CombatActionRunner") != null, "canonical Swordsman missing CombatActionRunner child")
	_expect(enemy.get_node_or_null("EnemyMotor") != null, "canonical Swordsman missing EnemyMotor child")

	# Commitment now has a real phase boundary: early windup remains interruptible,
	# while late windup is committed. This replaces the Phase 1 approximation where
	# every telegraph frame counted as committed.
	if enemy.has_method("_begin_v2_action"):
		enemy.call("_begin_v2_action", &"smoke_slash", 0.40, 0.20, 0.20, 0.50)
		_expect(str(enemy.call("get_v2_action_phase")) == "STARTUP", "Swordsman V2 action did not enter STARTUP")
		_expect(not bool(enemy.call("_v2_attack_was_committed")), "Swordsman early windup incorrectly counted as committed")
		var runner: Node = enemy.get_node_or_null("CombatActionRunner")
		if runner != null and runner.has_method("tick"):
			runner.call("tick", 0.21)
		_expect(str(enemy.call("get_v2_action_phase")) == "COMMITTED", "Swordsman action did not expose COMMITTED phase")
		_expect(bool(enemy.call("_v2_attack_was_committed")), "Swordsman late windup did not count as committed")
	else:
		_fail("Swordsman missing V2 action adapter")

	if is_instance_valid(enemy):
		enemy.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("[CombatActionMotorSmoke] PASS - startup momentum | commit lock | authored action motion | Swordsman integration")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[CombatActionMotorSmoke] %s" % failure)
	print("[CombatActionMotorSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
