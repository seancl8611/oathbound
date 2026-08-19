extends "res://Enemy/Area 1/Encounter/corrupted_swordsman.gd"

## Current Hushiro rules layer for the Corrupted Swordsman.
## The imported controller still owns active HFSM/animation plumbing until that
## implementation is replaced; this layer owns approved current combat rules.

const HUSHIRO_DEATHBLOW_WINDOW: float = 2.5
const HUSHIRO_NORMAL_PARRY_POSTURE: float = 25.0
const HUSHIRO_PERILOUS_THRUST_PARRY_MULT: float = 1.5
const HUSHIRO_BLOCK_POSTURE_DAMAGE: float = 12.0

@export_group("Hushiro Guard")
@export var hushiro_guard_range: float = 95.0

var _hushiro_attack_id_override: String = ""


func _update_blocking(_delta: float, now: float) -> void:
	if not can_block or _dbroken_active:
		_set_blocking(false)
		return
	if telegraphing or (is_attacking and not _attack_recovery):
		_set_blocking(false)
		return
	if ProstheticEffects.is_confused(self):
		_set_blocking(false)
		return
	if now < _block_stagger_until:
		_set_blocking(false)
		return
	if not is_instance_valid(player):
		_set_blocking(false)
		return
	if ai_state != AIState.DEFEND:
		_set_blocking(false)
		return
	var distance_to_player: float = global_position.distance_to(player.global_position)
	_set_blocking(distance_to_player <= minf(hushiro_guard_range, deaggro_radius))


func _is_frontal_attack(attacker: Variant) -> bool:
	if not _block_active:
		return false
	return super._is_frontal_attack(attacker)


func _on_base_posture_meter_filled() -> void:
	if not _dbroken_active:
		_trigger_posture_break(HUSHIRO_DEATHBLOW_WINDOW)


func receive_deathblow(attacker: Node) -> void:
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_deathblow_executed", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"attacker": CombatTelemetry.snapshot_actor(attacker) if attacker != null else {},
		})
	super.receive_deathblow(attacker)


func on_parried(player_pos: Vector2) -> void:
	var was_perilous_thrust: bool = _current_attack_type == AttackType.QUICK_THRUST
	# Parent applies the shared normal parry response before its recoil await. Preserve
	# that async flow and add only the 0.5x perilous-thrust bonus here.
	super.on_parried(player_pos)
	if was_perilous_thrust:
		var bonus_posture: float = HUSHIRO_NORMAL_PARRY_POSTURE * (HUSHIRO_PERILOUS_THRUST_PARRY_MULT - 1.0)
		add_posture_damage(bonus_posture)
		if CombatTelemetry != null and CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("perilous_thrust_parry_bonus", {
				"enemy": CombatTelemetry.snapshot_actor(self),
				"bonus_posture": bonus_posture,
				"target_total_pressure": HUSHIRO_NORMAL_PARRY_POSTURE * HUSHIRO_PERILOUS_THRUST_PARRY_MULT,
			})


# =============================================================================
# MULTI-HIT AIMING
# =============================================================================
# Each committed follow-up snapshots Akio at the BEGINNING of that follow-up's
# windup. The inherited prototype reused the original thrust/cross-swing snapshot,
# so later hitboxes could be aimed at a position Akio occupied ~1-2 seconds ago.
# Direction remains locked after the snapshot so dodging during the windup can
# still make the attack whiff.

func _snapshot_followup_target(attack_id: String, hit_index: int) -> void:
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
	_hushiro_attack_id_override = attack_id
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_combo_windup", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"attack_id": attack_id,
			"hit_index": hit_index,
			"target_snapshot": [_windup_player_pos0.x, _windup_player_pos0.y],
		})


func _perform_thrust_followup() -> void:
	_combo_hits_remaining = 2
	_parry_gen += 1
	var my_parry_gen: int = _parry_gen

	_snapshot_followup_target("thrust_followup_1", 1)
	await _execute_combo_swing(cross_damage_per_hit, cross_range, active_window)

	if my_parry_gen != _parry_gen:
		_hushiro_attack_id_override = ""
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	await get_tree().create_timer(0.2).timeout
	if my_parry_gen != _parry_gen:
		_hushiro_attack_id_override = ""
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	if _combo_hits_remaining > 0:
		_snapshot_followup_target("thrust_followup_2", 2)
		await _execute_combo_swing(cross_damage_per_hit, cross_range, active_window)

	_hushiro_attack_id_override = ""
	_finish_attack()


func _perform_cross_swing_hit(hit_num: int, gen: int) -> void:
	if gen != _parry_gen:
		_hushiro_attack_id_override = ""
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	await _wait_for_hitstop()

	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_attack_gen: int = _attack_gen
	_hushiro_attack_id_override = "cross_swing_%d" % hit_num

	_spawn_attack_hitbox(cross_damage_per_hit, cross_range, false)

	var now_s: float = Time.get_ticks_msec() * 0.001
	_lock_attack_facing_toward_player_or_snapshot()

	var lunge: Dictionary = _compute_humanoid_attack_lunge(
		cross_range,
		120.0,
		0.06,
		180.0,
		0.08
	)
	_apply_humanoid_lunge(lunge, now_s)

	var anim_len: float = _play_attack_anim_and_get_duration(["attack", "attack_slash"], 0.45)

	await get_tree().create_timer(active_window).timeout
	if gen != _parry_gen or my_attack_gen != _attack_gen:
		_hushiro_attack_id_override = ""
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	_cleanup_swipe()
	swinging = false

	var remaining: float = maxf(0.0, anim_len - active_window)
	if remaining > 0.0:
		await get_tree().create_timer(remaining).timeout
		if gen != _parry_gen or my_attack_gen != _attack_gen:
			_hushiro_attack_id_override = ""
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

	if hit_num == 1 and _combo_hits_remaining > 1:
		_combo_hits_remaining -= 1
		var combo_windup: float = maxf(cross_swing_hit_delay, 0.45)

		# Fresh snapshot for slash two; do not inherit slash one's aim point.
		_snapshot_followup_target("cross_swing_2", 2)
		_show_parry_indicator(combo_windup + active_window + 0.15, false)

		if anim and anim.has_animation("attack_windup"):
			var base_len: float = anim.get_animation("attack_windup").length
			anim.speed_scale = base_len / combo_windup
			anim.play("attack_windup")

		telegraphing = true
		await get_tree().create_timer(combo_windup).timeout
		if gen != _parry_gen:
			_hushiro_attack_id_override = ""
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

		telegraphing = false
		_set_anim_speed_safe(1.0)
		_perform_cross_swing_hit(2, gen)
	else:
		_hushiro_attack_id_override = ""
		_finish_attack()


# Stamp attack metadata as soon as an active hitbox is created. This makes misses
# diagnosable too; previously attack_id/type were added only after a collision.
func _spawn_attack_hitbox(dmg: int, range_val: float, is_telegraph: bool) -> void:
	super._spawn_attack_hitbox(dmg, range_val, is_telegraph)
	if not is_telegraph:
		_stamp_current_attack_event(dmg, "melee", true)


func _spawn_thrust_hitbox(dmg: int, range_val: float, is_telegraph: bool) -> void:
	super._spawn_thrust_hitbox(dmg, range_val, is_telegraph)
	if not is_telegraph:
		_stamp_current_attack_event(dmg, "perilous", false)


func _on_swipe_area_entered(player_hurtbox: Area2D) -> void:
	if player_hurtbox == null or not player_hurtbox.is_in_group("player_hurtbox"):
		return
	if not _consume_current_attack_contact():
		return
	var damage: int = swipe_damage
	if is_instance_valid(_current_swipe_area) and _current_swipe_area.has_meta("damage"):
		damage = int(_current_swipe_area.get_meta("damage"))
	_stamp_current_attack_event(damage, "melee", true)
	_emit_player_hurt_and_record(player_hurtbox, damage, "melee")


func _on_thrust_area_entered(player_hurtbox: Area2D) -> void:
	if player_hurtbox == null or not player_hurtbox.is_in_group("player_hurtbox"):
		return
	if not _consume_current_attack_contact():
		return
	_thrust_hit_player = true
	var damage: int = thrust_damage
	if is_instance_valid(_current_swipe_area) and _current_swipe_area.has_meta("damage"):
		damage = int(_current_swipe_area.get_meta("damage"))
	_stamp_current_attack_event(damage, "perilous", false)
	_emit_player_hurt_and_record(player_hurtbox, damage, "perilous")


func _consume_current_attack_contact() -> bool:
	if not is_instance_valid(_current_swipe_area):
		return false
	if _current_swipe_area.has_meta("consumed") and bool(_current_swipe_area.get_meta("consumed")):
		return false
	_current_swipe_area.set_meta("consumed", true)
	return true


func _stamp_current_attack_event(damage: int, damage_type: String, blockable: bool) -> void:
	if not is_instance_valid(_current_swipe_area):
		return
	_current_swipe_area.set_meta("attack_id", _current_hushiro_attack_id())
	_current_swipe_area.set_meta("health_damage", damage)
	_current_swipe_area.set_meta("posture_damage", 0.0)
	_current_swipe_area.set_meta("block_posture_damage", HUSHIRO_BLOCK_POSTURE_DAMAGE)
	_current_swipe_area.set_meta("damage_type", damage_type)
	_current_swipe_area.set_meta("parryable", true)
	_current_swipe_area.set_meta("blockable", blockable)
	_current_swipe_area.set_meta("perilous", damage_type == "perilous")
	_current_swipe_area.set_meta("proc_coefficient", 1.0)


func _current_hushiro_attack_id() -> String:
	if not _hushiro_attack_id_override.is_empty():
		return _hushiro_attack_id_override
	match _current_attack_type:
		AttackType.BASIC_SWING:
			return "basic_swing"
		AttackType.QUICK_THRUST:
			return "quick_thrust"
		AttackType.CROSS_SWING:
			return "cross_swing"
		AttackType.RUNNING_SWING:
			return "running_swing"
		_:
			return "swordsman_attack"


func _emit_player_hurt_and_record(player_hurtbox: Area2D, damage: int, damage_type: String) -> void:
	var receiver: Node = player_hurtbox.get_parent()
	var before: Dictionary = {}
	if CombatTelemetry != null and CombatTelemetry.is_capturing() and receiver != null:
		before = CombatTelemetry.snapshot_actor(receiver)
	player_hurtbox.emit_signal("hurt", damage, damage_type, self)
	if CombatTelemetry != null and CombatTelemetry.is_capturing() and receiver != null and is_instance_valid(_current_swipe_area):
		CombatTelemetry.record_contact(receiver, _current_swipe_area, self, before)
