extends Node

const PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const SWORDSMAN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var player: Node = await _spawn_player()
	if player == null:
		_finish()
		return

	await _verify_player_ordinary_block(player)
	await _verify_player_perilous_thrust_bypasses_block(player)
	await _verify_enemy_guard_is_hp_exclusive(player)
	await _verify_perilous_thrust_warning(player)

	player.queue_free()
	await get_tree().process_frame
	_finish()


func _spawn_player() -> Node:
	var player: Node = PLAYER_SCENE.instantiate()
	if player == null:
		_fail("could not instantiate canonical Player")
		return null
	player.name = "DefenseContractPlayer"
	add_child(player)
	await get_tree().process_frame
	player.set_physics_process(false)
	player.set_process_input(false)
	player.set_process_unhandled_input(false)
	player.global_position = Vector2.ZERO
	player.set("hp", 100)
	player.set("stagger", 0.0)
	player.set("_facing_dir", Vector2.RIGHT)
	return player


func _make_attack_origin(player: Node, damage_type: String, blockable: bool, perilous: bool) -> Node2D:
	var origin := Node2D.new()
	origin.name = "DefenseAttackOrigin"
	origin.global_position = Vector2(40.0, 0.0)
	origin.add_to_group("enemy")
	add_child(origin)

	var hitbox := Area2D.new()
	hitbox.name = "DefenseAttackHitbox"
	hitbox.add_to_group("attack")
	hitbox.set_meta("attacker", origin)
	hitbox.set_meta("health_damage", 10)
	hitbox.set_meta("posture_damage", 0.0)
	hitbox.set_meta("block_posture_damage", 12.0)
	hitbox.set_meta("damage_type", damage_type)
	hitbox.set_meta("parryable", true)
	hitbox.set_meta("blockable", blockable)
	hitbox.set_meta("perilous", perilous)
	origin.add_child(hitbox)
	return origin


func _verify_player_ordinary_block(player: Node) -> void:
	player.set("hp", 100)
	player.set("stagger", 0.0)
	player.set("_facing_dir", Vector2.RIGHT)
	player.set("_state", 6) # LegacyPlayerController.State.BLOCKING
	var combat: Node = player.get_node_or_null("Combat")
	if combat != null and combat.has_method("start_block"):
		combat.call("start_block")

	var origin := _make_attack_origin(player, "melee", true, false)
	var hitbox: Area2D = origin.get_node("DefenseAttackHitbox") as Area2D
	player.call("_on_hurt", 10, "melee", hitbox)

	_expect(int(player.get("hp")) == 100, "ordinary frontal block leaked HP damage")
	_expect(is_equal_approx(float(player.get("stagger")), 12.0), "ordinary frontal block did not apply authored 12 Posture")

	origin.queue_free()
	await get_tree().process_frame


func _verify_player_perilous_thrust_bypasses_block(player: Node) -> void:
	player.set("hp", 100)
	player.set("stagger", 0.0)
	player.set("_facing_dir", Vector2.RIGHT)
	player.set("_state", 6) # LegacyPlayerController.State.BLOCKING

	var origin := _make_attack_origin(player, "perilous", false, true)
	var hitbox: Area2D = origin.get_node("DefenseAttackHitbox") as Area2D
	player.call("_on_hurt", 8, "perilous", hitbox)

	_expect(int(player.get("hp")) == 92, "perilous thrust was incorrectly absorbed by ordinary block")
	_expect(is_equal_approx(float(player.get("stagger")), 0.0), "perilous thrust incorrectly applied ordinary block Posture")

	origin.queue_free()
	await get_tree().process_frame


func _verify_enemy_guard_is_hp_exclusive(player: Node) -> void:
	var enemy: Node = SWORDSMAN_SCENE.instantiate()
	if enemy == null:
		_fail("could not instantiate current Corrupted Swordsman")
		return
	enemy.name = "DefenseContractSwordsman"
	enemy.global_position = Vector2(50.0, 0.0)
	add_child(enemy)
	await get_tree().process_frame
	enemy.set_physics_process(false)
	enemy.set("hp", 90)

	var combat: Node = enemy.get_node_or_null("Combat")
	if combat == null:
		_fail("Corrupted Swordsman missing CombatController")
		enemy.queue_free()
		return
	if combat.has_method("reset_posture"):
		combat.call("reset_posture")

	enemy.call("_set_blocking", true)
	_expect(bool(enemy.call("is_blocking")), "Corrupted Swordsman could not enter active guard")

	var sword_origin := Node2D.new()
	sword_origin.name = "PlayerSwordOrigin"
	sword_origin.global_position = player.global_position
	add_child(sword_origin)
	var sword_hitbox := Area2D.new()
	sword_hitbox.name = "PlayerSwordHitbox"
	sword_hitbox.add_to_group("attack")
	sword_hitbox.set_meta("attacker", player)
	sword_hitbox.set_meta("health_damage", 12)
	sword_hitbox.set_meta("posture_damage", 10.0)
	sword_hitbox.set_meta("block_posture_damage", 14.0)
	sword_hitbox.set_meta("attack_id", "wolf_fang_slash")
	sword_hitbox.set_meta("damage_type", "sword_light")
	sword_origin.add_child(sword_hitbox)

	enemy.call("_on_hurt_box_hurt", 12, "sword_light", sword_hitbox)

	_expect(int(enemy.get("hp")) == 90, "active enemy guard leaked HP damage")
	_expect(float(combat.call("get_posture")) > 0.0, "active enemy guard did not take Posture pressure")

	sword_origin.queue_free()
	enemy.queue_free()
	await get_tree().process_frame


func _verify_perilous_thrust_warning(player: Node) -> void:
	var enemy: Node = SWORDSMAN_SCENE.instantiate()
	if enemy == null:
		_fail("could not instantiate Swordsman for perilous warning contract")
		return
	enemy.name = "PerilousWarningSwordsman"
	enemy.global_position = Vector2(50.0, 0.0)
	add_child(enemy)
	await get_tree().process_frame
	enemy.set_physics_process(false)

	# Current Hushiro layer stamps the live thrust hitbox before the warning is shown.
	enemy.call("_spawn_thrust_hitbox", 8, 70.0, true)
	var hitbox_value: Variant = enemy.get("_current_swipe_area")
	_expect(hitbox_value != null and is_instance_valid(hitbox_value), "Swordsman thrust telegraph did not create its authored hitbox")
	if hitbox_value != null and is_instance_valid(hitbox_value):
		var hitbox: Area2D = hitbox_value as Area2D
		_expect(bool(hitbox.get_meta("perilous", false)), "Quick Thrust is not stamped perilous")
		_expect(not bool(hitbox.get_meta("blockable", true)), "Quick Thrust is incorrectly marked blockable")
		_expect(bool(hitbox.get_meta("parryable", false)), "Quick Thrust must remain parryable")
		_expect(bool(enemy.call("_current_attack_requires_perilous_warning", false)), "perilous Quick Thrust does not request the perilous warning")

	enemy.queue_free()
	await get_tree().process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("[HushiroDefenseContractSmoke] PASS - ordinary player block HP-exclusive | enemy guard HP-exclusive | perilous thrust bypass + warning")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[HushiroDefenseContractSmoke] %s" % failure)
	print("[HushiroDefenseContractSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
