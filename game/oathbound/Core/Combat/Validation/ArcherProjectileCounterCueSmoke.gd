extends Node

const PROJECTILE_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcherProjectile.tscn")
const PASS_LINE: String = "[ArcherProjectileCounterCueSmoke] PASS - flight-local collision course | 0.20 warning | 0.12 parry beat | dodge suppression | deflect cleanup | scheduler trace"

class DummyEnemy:
	extends Node2D
	var has_died: bool = false

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var director: Node = get_node_or_null("/root/AttackDir")
	if director == null or not director.has_method("get_pressure_director_v2"):
		_fail("AttackDir PressureDirectorV2 facade unavailable")
		_finish()
		return
	var pressure_value: Variant = director.call("get_pressure_director_v2")
	if not (pressure_value is PressureDirectorV2):
		_fail("PressureDirectorV2 runtime unavailable")
		_finish()
		return
	var pressure: PressureDirectorV2 = pressure_value as PressureDirectorV2
	pressure.reset_for_test()

	var shooter := DummyEnemy.new()
	shooter.name = "ArcherProjectileCueShooter"
	add_child(shooter)

	var player := CharacterBody2D.new()
	player.name = "ArcherProjectileCuePlayer"
	player.add_to_group("player")
	player.global_position = Vector2(40.0, 0.0)
	add_child(player)
	_attach_player_hurt_shape(player)

	var now: float = Time.get_ticks_msec() * 0.001
	var admission_value: Variant = director.call("request_pressure_threat", shooter, {
		"attack_id": "archer_arrow_readability_smoke",
		"pressure_channel": "ranged",
		"impact_at": now + 0.18,
		"impact_delay": 0.18,
		"active_duration": 0.14,
		"severity": "normal",
		"threat_cost": 0.65,
	})
	var admission: Dictionary = admission_value as Dictionary if admission_value is Dictionary else {}
	_expect(bool(admission.get("admitted", false)), "scheduler did not admit test Archer arrow")

	var projectile_value: Variant = PROJECTILE_SCENE.instantiate()
	if not (projectile_value is Area2D):
		_fail("could not instantiate canonical Archer projectile")
		_cleanup(director, pressure, shooter, player, null, admission)
		_finish()
		return
	var projectile: Area2D = projectile_value as Area2D
	projectile.name = "ArcherProjectileCueArrow"
	projectile.set_meta("shooter_id", shooter.get_instance_id())
	projectile.set_meta("shooter", shooter)
	projectile.call("launch", Vector2.RIGHT, 220.0, 2)
	add_child(projectile)
	projectile.set_physics_process(false)
	await get_tree().process_frame
	projectile.set("_armed", true)

	var cue: Node = projectile.get_node_or_null("CounterCue")
	if cue == null:
		_fail("canonical Archer projectile is missing CounterCue runtime")
		_cleanup(director, pressure, shooter, player, projectile, admission)
		_finish()
		return
	cue.set_process(false)

	# Head-on 40 px at 220 px/s is ~0.18 s: warning visible but inner beat not yet shown.
	cue.call("force_update_for_test")
	_expect(bool(cue.call("warning_visible_for_test")), "head-on arrow did not show final 0.20 s warning")
	_expect(not bool(cue.call("parry_beat_visible_for_test")), "0.18 s arrow showed parry beat too early")
	_expect(float(cue.call("scheduled_pressure_impact_at_for_test")) > 0.0, "projectile cue cannot trace the shooter's scheduler impact")

	# Move inside the canonical 0.12 s perfect-parry beat.
	player.global_position = Vector2(22.0, 0.0)
	player.velocity = Vector2.ZERO
	cue.call("force_update_for_test")
	_expect(bool(cue.call("warning_visible_for_test")), "near-contact arrow lost warning")
	_expect(bool(cue.call("parry_beat_visible_for_test")), "0.10 s arrow did not expose perfect-parry beat")

	# A geometrically missed arrow must not keep advertising a defensive prompt.
	player.global_position = Vector2(40.0, 50.0)
	cue.call("force_update_for_test")
	_expect(not bool(cue.call("warning_visible_for_test")), "off-line arrow kept a false collision warning")

	# Current Player motion also matters: a fast lateral dodge should suppress the prompt.
	player.global_position = Vector2(40.0, 0.0)
	player.velocity = Vector2(0.0, 400.0)
	cue.call("force_update_for_test")
	_expect(not bool(cue.call("warning_visible_for_test")), "lateral dodge did not clear projected collision warning")

	# Reflection transfers threat ownership away from Akio and must clear the cue immediately.
	player.velocity = Vector2.ZERO
	projectile.set_meta("deflected", true)
	projectile.set("_is_deflected", true)
	cue.call("force_update_for_test")
	_expect(not bool(cue.call("warning_visible_for_test")), "deflected arrow retained player counter warning")
	_expect(not bool(cue.call("parry_beat_visible_for_test")), "deflected arrow retained parry beat")

	# Pure prediction contract: an arrow moving away from the player is never threatening.
	var away_value: Variant = cue.call("predict_collision_course", Vector2(40.0, 0.0), Vector2(220.0, 0.0), 30.0)
	_expect(away_value is Dictionary and not bool((away_value as Dictionary).get("threatening", true)), "receding projectile classified as collision threat")

	_cleanup(director, pressure, shooter, player, projectile, admission)
	_finish()


func _attach_player_hurt_shape(player: CharacterBody2D) -> void:
	var hurt_box := Area2D.new()
	hurt_box.name = "HurtBox"
	player.add_child(hurt_box)
	var collision := CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	var rectangle := RectangleShape2D.new()
	rectangle.size = Vector2(27.5, 43.75)
	collision.shape = rectangle
	hurt_box.add_child(collision)


func _cleanup(director: Node, pressure: PressureDirectorV2, shooter: Node, player: Node, projectile: Node, admission: Dictionary) -> void:
	var reservation_id: String = str(admission.get("reservation_id", ""))
	if not reservation_id.is_empty() and director != null and director.has_method("release_pressure_threat"):
		director.call("release_pressure_threat", shooter, reservation_id, "archer_projectile_cue_smoke")
	pressure.reset_for_test()
	if projectile != null and is_instance_valid(projectile):
		projectile.queue_free()
	if player != null and is_instance_valid(player):
		player.queue_free()
	if shooter != null and is_instance_valid(shooter):
		shooter.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[ArcherProjectileCounterCueSmoke] %s" % failure)
	print("[ArcherProjectileCounterCueSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
