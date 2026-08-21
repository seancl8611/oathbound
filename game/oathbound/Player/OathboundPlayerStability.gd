extends "res://Player/OathboundPlayer.gd"

## First combat-stability layer over the current Player controller.
## Owns hard death-state behavior and authoritative block-origin resolution while the
## larger imported LegacyPlayerController is replaced incrementally.

const DEATH_RETURN_DELAY := 0.45
var _combat_dead: bool = false


func take_damage(amount: int, show_feedback: bool = true) -> void:
	if _combat_dead:
		return
	super.take_damage(amount, show_feedback)


func _die() -> void:
	if _combat_dead:
		return
	_combat_dead = true
	hp = 0

	_parry_active = false
	_block_held = false
	_is_invincible = true
	set_invincibility(true)
	_drop_combo()
	_deactivate_current_attack_hitbox()
	velocity = Vector2.ZERO
	_move_velocity = Vector2.ZERO
	knockback = Vector2.ZERO

	# Stop gameplay immediately. The old controller only emitted playerdeath, allowing
	# Akio to keep attacking at 0 HP if nothing listened to that signal.
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)

	var hurtbox: Area2D = get_node_or_null("HurtBox") as Area2D
	if hurtbox != null:
		hurtbox.set_deferred("monitoring", false)
		hurtbox.set_deferred("monitorable", false)
		for child: Node in hurtbox.get_children():
			if child is CollisionShape2D:
				(child as CollisionShape2D).set_deferred("disabled", true)

	if animation != null and animation.has_animation("hurt"):
		animation.play("hurt")
	_update_health_bar()
	emit_signal("playerdeath")

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_death", {
			"player": CombatTelemetry.snapshot_actor(self),
			"return_delay": DEATH_RETURN_DELAY,
		})

	var timer: SceneTreeTimer = get_tree().create_timer(DEATH_RETURN_DELAY, true, false, true)
	timer.timeout.connect(_return_to_strand_after_death)


func _return_to_strand_after_death() -> void:
	if not is_inside_tree():
		return
	if typeof(GameFlow) == TYPE_OBJECT:
		GameFlow.set_player(null)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://World/HubScene.tscn")


func _handle_block(area: Area2D, dmg: int, dmg_type: String, attacker: Node, atk_pos: Vector2) -> void:
	var resolved_attacker: Node = _resolve_attacker(area, attacker)
	var attack_origin: Vector2 = atk_pos
	if resolved_attacker is Node2D and is_instance_valid(resolved_attacker):
		attack_origin = (resolved_attacker as Node2D).global_position

	var to_attacker: Vector2 = attack_origin - global_position
	var facing: Vector2 = _facing_dir.normalized()
	if facing.length_squared() <= 0.001:
		facing = Vector2.RIGHT
	var relative_angle: float = 0.0
	if to_attacker.length_squared() > 0.001:
		relative_angle = absf(rad_to_deg(facing.angle_to(to_attacker.normalized())))

	var inside_arc: bool = to_attacker.length_squared() <= 0.001 or relative_angle <= CURRENT_BLOCK_ARC_DEGREES * 0.5
	if not inside_arc:
		if CombatTelemetry != null and CombatTelemetry.is_capturing():
			CombatTelemetry.record_resolution("block_failed_outside_arc", self, resolved_attacker, area, {
				"damage": dmg,
				"damage_type": dmg_type,
				"hitbox_position": [atk_pos.x, atk_pos.y],
				"resolved_attack_origin": [attack_origin.x, attack_origin.y],
				"relative_angle_deg": relative_angle,
				"block_half_arc_deg": CURRENT_BLOCK_ARC_DEGREES * 0.5,
			})
		take_damage(dmg)
		var rear_kb: Vector2 = (global_position - attack_origin).normalized()
		knockback += rear_kb * 120.0
		if combat:
			combat.notify_got_hit({"damage": dmg, "type": dmg_type})
		return

	var posture_before: float = float(stagger)
	var block_posture: float = 12.0
	if area != null:
		if area.has_meta("block_posture_damage"):
			block_posture = float(area.get_meta("block_posture_damage"))
		elif area.has_meta("stagger_on_block"):
			block_posture = float(area.get_meta("stagger_on_block"))
	if resolved_attacker != null and block_posture == 12.0:
		if resolved_attacker.has_meta("block_posture_damage"):
			block_posture = float(resolved_attacker.get_meta("block_posture_damage"))
		elif resolved_attacker.has_meta("stagger_on_block"):
			block_posture = float(resolved_attacker.get_meta("stagger_on_block"))

	stagger = clampf(float(stagger) + maxf(0.0, block_posture), 0.0, float(stagger_max))
	_stagger_suppress_until = Time.get_ticks_msec() * 0.001 + CURRENT_POSTURE_RECOVER_DELAY

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_resolution("block_success", self, resolved_attacker, area, {
			"damage_type": dmg_type,
			"health_damage_received": 0,
			"posture_before": posture_before,
			"posture_damage": block_posture,
			"posture_after": stagger,
			"hitbox_position": [atk_pos.x, atk_pos.y],
			"resolved_attack_origin": [attack_origin.x, attack_origin.y],
			"relative_angle_deg": relative_angle,
		})

	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)
	var kb_dir: Vector2 = (global_position - attack_origin).normalized()
	knockback += kb_dir * 50.0

	if resolved_attacker != null and is_instance_valid(resolved_attacker):
		if resolved_attacker.has_method("on_blocked"):
			resolved_attacker.on_blocked()
		elif resolved_attacker.is_in_group("enemy_projectile") or resolved_attacker.is_in_group("deflectable"):
			resolved_attacker.queue_free()

	if float(stagger) >= float(stagger_max) - 0.001:
		_posture_break()


func get_playtest_snapshot() -> Dictionary:
	var snapshot: Dictionary = super.get_playtest_snapshot()
	snapshot["dead"] = _combat_dead
	return snapshot
