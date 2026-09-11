extends Node

const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const PLAYER_MOTOR_SCRIPT = preload("res://Core/Combat/PlayerMotor.gd")
const PLAYER_SCENE: PackedScene = preload("res://Player/player.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	_test_shared_player_motor()
	await _test_player_integration()
	_finish()


func _test_shared_player_motor() -> void:
	var actor := CharacterBody2D.new()
	actor.name = "PlayerMotorActor"
	add_child(actor)

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	var motor_value: Variant = PLAYER_MOTOR_SCRIPT.new()
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (runner_value is CombatActionRunner) or not (motor_value is PlayerMotor) or not (definition_value is CombatActionDefinition):
		_fail("could not instantiate PlayerMotor/CombatActionRunner foundation")
		actor.queue_free()
		return

	var runner: CombatActionRunner = runner_value as CombatActionRunner
	var motor: PlayerMotor = motor_value as PlayerMotor
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	actor.add_child(runner)
	actor.add_child(motor)
	runner.configure(actor)
	motor.configure(actor, 5000.0, 6600.0, 200.0)

	definition.action_id = &"player_smoke_slash"
	definition.startup_duration = 0.20
	definition.commit_fraction = 0.50
	definition.active_duration = 0.10
	definition.recovery_duration = 0.20
	definition.startup_locomotion_weight = 0.80
	definition.committed_locomotion_weight = 0.45
	definition.active_locomotion_weight = 0.35
	definition.recovery_locomotion_weight = 0.70

	motor.reset_locomotion(Vector2(170.0, 0.0))
	runner.begin(definition)
	var startup_velocity: Vector2 = motor.resolve_velocity(
		0.016,
		Vector2(200.0, 0.0),
		Vector2.ZERO,
		Vector2.ZERO,
		runner
	)
	_expect(startup_velocity.x > 100.0, "player startup discarded locomotion momentum")
	_expect(startup_velocity.x < 200.0, "player startup ignored authored locomotion weight")

	runner.tick(0.11)
	_expect(runner.phase_name() == "COMMITTED", "player action did not cross explicit commitment point")
	_expect(not runner.allows_target_tracking(), "player steering remained open after commitment")

	runner.mark_active()
	var active_velocity: Vector2 = motor.resolve_velocity(
		0.016,
		Vector2(200.0, 0.0),
		Vector2(80.0, 0.0),
		Vector2.ZERO,
		runner
	)
	_expect(active_velocity.x > 80.0, "authored player action motion did not compose with locomotion")

	runner.mark_recovery()
	var recovery_velocity: Vector2 = motor.resolve_velocity(
		0.016,
		Vector2(200.0, 0.0),
		Vector2.ZERO,
		Vector2.ZERO,
		runner
	)
	_expect(recovery_velocity.x > active_velocity.x - 80.0, "recovery did not restore meaningful locomotion")

	var dash_velocity: Vector2 = motor.resolve_dash_velocity(Vector2.RIGHT, 533.3333)
	_expect(is_equal_approx(dash_velocity.length(), 533.3333), "PlayerMotor changed authored dash speed")
	actor.queue_free()


func _test_player_integration() -> void:
	var player: Node = PLAYER_SCENE.instantiate()
	if player == null:
		_fail("could not instantiate canonical Player scene")
		return
	player.name = "PlayerActionMotorSmokePlayer"
	add_child(player)
	await get_tree().process_frame

	if player.has_method("set_physics_process"):
		player.set_physics_process(false)

	_expect(player.has_method("has_v2_player_action_motor_runtime"), "canonical Player is not routed through V2 motion layer")
	if player.has_method("has_v2_player_action_motor_runtime"):
		_expect(bool(player.call("has_v2_player_action_motor_runtime")), "canonical Player failed to attach PlayerMotor/ActionRunner")
	_expect(player.get_node_or_null("PlayerMotor") != null, "canonical Player missing PlayerMotor child")
	_expect(player.get_node_or_null("CombatActionRunner") != null, "canonical Player missing CombatActionRunner child")

	var profile: Dictionary = {
		"id": "player_integration_smoke_slash",
		"anim": "attack",
		"duration": 0.40,
		"startup": 0.12,
		"active": 0.08,
		"recovery": 0.20,
		"lunge_start": 0.12,
		"lunge_speed": 40.0,
		"lunge_time": 0.05,
		"hitbox_offset": 20.0,
		"hitbox_shape": "slash_small",
		"hitbox_scale": Vector2.ONE,
		"can_combo": false,
		"stagger_level": 0,
	}
	if player.has_method("_start_profile_attack"):
		player.call("_start_profile_attack", profile, 0)
		_expect(str(player.call("get_v2_player_action_phase")) == "STARTUP", "canonical Player attack did not enter V2 STARTUP")
		player.set("_move_input", Vector2.RIGHT)
		var motor: Node = player.get_node_or_null("PlayerMotor")
		if motor != null and motor.has_method("reset_locomotion"):
			motor.call("reset_locomotion", Vector2(160.0, 0.0))
		player.call("_calculate_velocity", 0.016)
		var live_velocity: Vector2 = player.get("velocity") as Vector2
		_expect(live_velocity.x > 80.0, "canonical Player still hard-stops locomotion during attack startup")
	else:
		_fail("canonical Player missing attack profile entry point")

	var snapshot_value: Variant = player.call("get_playtest_snapshot") if player.has_method("get_playtest_snapshot") else {}
	if snapshot_value is Dictionary:
		var snapshot: Dictionary = snapshot_value as Dictionary
		_expect(bool(snapshot.get("v2_player_motion", false)), "playtest snapshot does not expose V2 Player motion ownership")
	else:
		_fail("canonical Player playtest snapshot unavailable")

	if is_instance_valid(player):
		player.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("[PlayerActionMotorSmoke] PASS - attack locomotion | commit steering | action composition | dash preservation | canonical Player integration")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[PlayerActionMotorSmoke] %s" % failure)
	print("[PlayerActionMotorSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
