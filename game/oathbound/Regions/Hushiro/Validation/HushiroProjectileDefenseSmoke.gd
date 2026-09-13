extends Node

const PROJECTILE_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcherProjectile.tscn")
const PARRY_POLICY = preload("res://Core/Combat/OathboundParryPolicy.gd")

class DefensePlayer:
	extends Node2D
	var _state: int = 6
	var _parry_active: bool = false
	var _parry_grace_until: float = 0.0
	var blocking: bool = true
	var parrying: bool = false

	func is_blocking() -> bool:
		return blocking

	func is_parrying() -> bool:
		return parrying

	func can_parry_incoming_attack(source: Node, damage_type: String = "") -> bool:
		return PARRY_POLICY.is_special_parry_attack(source, damage_type)

class DefenseHurtbox:
	extends Area2D
	signal hurt(damage: int, damage_type: String, attacker: Node)

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var player := DefensePlayer.new()
	player.name = "ProjectileDefensePlayer"
	player.add_to_group("player")
	add_child(player)
	var hurtbox := DefenseHurtbox.new()
	hurtbox.name = "HurtBox"
	hurtbox.add_to_group("player_hurtbox")
	player.add_child(hurtbox)
	await get_tree().process_frame

	await _verify_block_absorbs(player, hurtbox)
	await _verify_ordinary_parry_does_not_reflect(player, hurtbox)
	await _verify_special_parry_reflects(player, hurtbox)

	if is_instance_valid(player):
		player.queue_free()
	await get_tree().process_frame
	_finish()


func _verify_block_absorbs(player: DefensePlayer, hurtbox: DefenseHurtbox) -> void:
	player._state = 6
	player._parry_active = false
	player._parry_grace_until = 0.0
	player.blocking = true
	player.parrying = false
	var arrow: Node = _spawn_arrow()
	if arrow == null:
		return

	# Canonical block remains a forgiving ordinary defense. State 6 must not be
	# misread as a parry and ordinary arrows remain blockable.
	_expect(not bool(arrow.call("_check_player_parrying", player)), "blocking state 6 was misclassified as parry")
	_expect(bool(arrow.call("_check_player_blocking", player)), "blocking state 6 was not recognized as block")
	arrow.call("_handle_player_collision", hurtbox)
	_expect(bool(arrow.get("_is_blocked")), "normal arrow block did not enter blocked/despawn response")
	_expect(not bool(arrow.get("_is_deflected")), "normal arrow block reflected the projectile")
	_expect(not bool(arrow.get_meta("reflected", false)), "normal arrow block stamped reflected metadata")
	await get_tree().create_timer(0.12).timeout


func _verify_ordinary_parry_does_not_reflect(player: DefensePlayer, hurtbox: DefenseHurtbox) -> void:
	player._state = 7
	player._parry_active = true
	player._parry_grace_until = 0.0
	player.blocking = false
	player.parrying = true
	var arrow: Node = _spawn_arrow()
	if arrow == null:
		return

	_expect(not bool(arrow.call("_check_player_parrying", player)), "ordinary arrow became a parry opportunity")
	arrow.call("_handle_player_collision", hurtbox)
	_expect(not bool(arrow.get("_is_deflected")), "ordinary arrow reflected from generic parry input")
	_expect(not bool(arrow.get_meta("reflected", false)), "ordinary arrow stamped reflected metadata from generic parry input")
	await get_tree().process_frame


func _verify_special_parry_reflects(player: DefensePlayer, hurtbox: DefenseHurtbox) -> void:
	player._state = 7
	player._parry_active = true
	player._parry_grace_until = 0.0
	player.blocking = false
	player.parrying = true
	var arrow: Node = _spawn_arrow()
	if arrow == null:
		return
	arrow.set_meta("special_parry", true)
	arrow.set_meta("parryable", true)
	var velocity_before: Vector2 = Vector2(arrow.get("velocity"))
	_expect(bool(arrow.call("_check_player_parrying", player)), "explicit special projectile was not recognized as parryable")
	arrow.call("_handle_player_collision", hurtbox)
	_expect(bool(arrow.get("_is_deflected")), "special-parried arrow did not enter reflected response")
	_expect(not bool(arrow.get("_is_blocked")), "special-parried arrow was consumed as a normal block")
	_expect(bool(arrow.get_meta("reflected", false)), "special-parried arrow did not stamp reflected metadata")
	var velocity_after: Vector2 = Vector2(arrow.get("velocity"))
	_expect(velocity_after.length() > 0.0 and velocity_after != velocity_before, "special-parried arrow did not reverse/retarget velocity")
	arrow.queue_free()
	await get_tree().process_frame


func _spawn_arrow() -> Node:
	var arrow: Node = PROJECTILE_SCENE.instantiate()
	if arrow == null:
		_failures.append("could not instantiate canonical Archer projectile")
		return null
	add_child(arrow)
	arrow.set_physics_process(false)
	arrow.call("launch", Vector2.RIGHT, 140.0, 2)
	return arrow


func _finish() -> void:
	if _failures.is_empty():
		print("[HushiroProjectileDefenseSmoke] PASS - block absorbs ordinary arrow | ordinary parry does not reflect | explicit special parry reflects | canonical state 6 is not parry")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[HushiroProjectileDefenseSmoke] %s" % failure)
	print("[HushiroProjectileDefenseSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
