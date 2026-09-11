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

	if is_instance_valid(enemy):
		enemy.queue_free()
	if is_instance_valid(target):
		target.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("[EnemyBrainSmoke] PASS - controlled cadence | held intent | Swordsman tactical ownership")
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
