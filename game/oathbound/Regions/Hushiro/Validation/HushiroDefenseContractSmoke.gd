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

	await _verify_damage_number_manager_rejects_non_hp_values()
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


func _make_player_sword_hitbox(player: Node, suffix: String) -> Area2D:
	var hitbox := Area2D.new()
	hitbox.name = "PlayerSwordHitbox%s" % suffix
	hitbox.add_to_group("attack")
	hitbox.set_meta("attacker", player)
	hitbox.set_meta("health_damage", 12)
	hitbox.set_meta("posture_damage", 10.0)
	hitbox.set_meta("block_posture_damage", 14.0)
	hitbox.set_meta("attack_id", "wolf_fang_slash")
	hitbox.set_meta("damage_type", "sword_light")
	return hitbox


func _verify_damage_number_manager_rejects_non_hp_values() -> void:
	var count_before: int = _count_damage_number_nodes()
	DamageNumberManager.show_damage_number(0, Vector2.ZERO, "normal", null)
	DamageNumberManager.show_damage_number(-14, Vector2.ZERO, "normal", null)
	await get_tree().process_frame
	_expect(
		_count_damage_number_nodes() == count_before,
		"DamageNumberManager created floating UI for zero/negative non-HP values"
	)


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
	var guarded_hitbox: Area2D = _make_player_sword_hitbox(player, "Guarded")
	sword_origin.add_child(guarded_hitbox)

	var guarded_number_count_before: int = _count_damage_number_nodes()
	enemy.call("_on_hurt_box_hurt", 12, "sword_light", guarded_hitbox)
	await get_tree().process_frame

	_expect(int(enemy.get("hp")) == 90, "active enemy guard leaked HP damage")
	_expect(float(combat.call("get_posture")) > 0.0, "active enemy guard did not take Posture pressure")
	_expect(
		_count_damage_number_nodes() == guarded_number_count_before,
		"posture-only enemy guard incorrectly created a floating damage number"
	)

	# A real unguarded HP hit must still create one number, and that number must
	# equal the HP actually removed rather than Posture pressure or raw attack power.
	enemy.call("_set_blocking", false)
	enemy.set("can_block", false)
	var unguarded_hitbox: Area2D = _make_player_sword_hitbox(player, "Unguarded")
	sword_origin.add_child(unguarded_hitbox)
	var hp_before: int = int(enemy.get("hp"))
	var real_number_count_before: int = _count_damage_number_nodes()
	enemy.call("_on_hurt_box_hurt", 12, "sword_light", unguarded_hitbox)
	await get_tree().process_frame
	var hp_after: int = int(enemy.get("hp"))
	var hp_lost: int = maxi(0, hp_before - hp_after)

	_expect(hp_lost > 0, "unguarded control hit did not remove enemy HP")
	_expect(
		_count_damage_number_nodes() == real_number_count_before + 1,
		"real enemy HP loss did not create exactly one floating damage number"
	)
	_expect(
		_latest_damage_number_text() == str(hp_lost),
		"floating damage number did not equal actual enemy HP lost"
	)

	# Killing blows are part of the same contract. If only 5 HP remain, a 12-damage
	# attack must show 5 rather than the requested 12.
	enemy.set("hp", 5)
	var overkill_hitbox: Area2D = _make_player_sword_hitbox(player, "Overkill")
	sword_origin.add_child(overkill_hitbox)
	var overkill_number_count_before: int = _count_damage_number_nodes()
	enemy.call("_on_hurt_box_hurt", 12, "sword_light", overkill_hitbox)
	_expect(int(enemy.get("hp")) == 0, "overkill control hit did not clamp enemy HP to zero")
	await get_tree().process_frame
	_expect(
		_count_damage_number_nodes() == overkill_number_count_before + 1,
		"overkill HP loss did not create exactly one floating damage number"
	)
	_expect(
		_latest_damage_number_text() == "5",
		"overkill floating number exceeded the enemy HP actually removed"
	)

	sword_origin.queue_free()
	if is_instance_valid(enemy):
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


func _count_damage_number_nodes() -> int:
	var scene: Node = get_tree().current_scene
	if scene == null:
		return 0
	var count: int = 0
	for child: Node in scene.get_children():
		if child.get_node_or_null("NumberLabel") != null:
			count += 1
	return count


func _latest_damage_number_text() -> String:
	var scene: Node = get_tree().current_scene
	if scene == null:
		return ""
	var latest: String = ""
	for child: Node in scene.get_children():
		var label: Node = child.get_node_or_null("NumberLabel")
		if label != null and "text" in label:
			latest = str(label.get("text"))
	return latest


func _finish() -> void:
	if _failures.is_empty():
		print("[HushiroDefenseContractSmoke] PASS - player block HP-exclusive | enemy guard posture-only/no damage number | real HP hit number exact | perilous thrust bypass + warning")
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
