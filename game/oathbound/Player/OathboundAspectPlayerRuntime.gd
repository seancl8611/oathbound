extends "res://Player/OathboundAspectPlayer.gd"

## Final integration layer used by the inherited Aspect player scene.
## Owns compatibility adaptations that the imported controller cannot express cleanly:
## Wolf's fourth Basic, Aspect metadata publication, run-start state, real hit
## interruption, and the current Health-first player defense contract.
##
## Combat V2 keeps the imported `stagger` fields only as inert compatibility plumbing.
## Player-facing Posture, Posture break, and Posture UI are retired. Ordinary frontal
## guard now trades Health for safety; Ronin's stability identity is expressed through
## lower guard-chip Health damage rather than a larger second durability meter.

const PLAYER_POSTURE_COMPATIBILITY_MAX: float = 100.0
const BASE_BLOCK_HEALTH_RATIO: float = 0.35
const RONIN_BLOCK_HEALTH_RATIO_T0: float = 0.30
const RONIN_BLOCK_HEALTH_TIER_STEP: float = 0.025
const RONIN_BLOCK_HEALTH_RATIO_MIN: float = 0.20


func _ready() -> void:
	if typeof(AspectRuntime) == TYPE_OBJECT:
		AspectRuntime.reset_for_new_run()
	super._ready()
	_retire_player_posture_state()


# =============================================================================
# PLAYER POSTURE RETIREMENT / HEALTH-FIRST GUARD
# =============================================================================

func apply_aspect_configuration() -> void:
	# Parent configuration only varies the retired player-Posture capacity/recovery.
	_retire_player_posture_state()


func _setup_stagger_ui() -> void:
	_stagger_ui = null
	_stagger_bg = null
	_stagger_fill = null
	_stagger_border = null


func _update_stagger_ui() -> void:
	stagger = 0.0
	if _stagger_ui != null and is_instance_valid(_stagger_ui):
		_stagger_ui.visible = false


func _tick_stagger(_delta: float) -> void:
	if not is_zero_approx(float(stagger)):
		stagger = 0.0


func _posture_break() -> void:
	stagger = 0.0
	_stun_until = 0.0
	_stun_started_at = 0.0
	if _state == State.STUNNED and hp > 0:
		_change_state(State.IDLE)
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("retired_player_posture_break_ignored", {
			"player": CombatTelemetry.snapshot_actor(self),
		})


func _retire_player_posture_state() -> void:
	stagger = 0.0
	# Keep a non-zero compatibility maximum for inherited comparisons/divisions. It is
	# never exposed as gameplay and never allowed to accumulate.
	stagger_max = PLAYER_POSTURE_COMPATIBILITY_MAX
	stagger_regen_rate = 0.0
	stagger_regen_blocked = 0.0
	_stagger_suppress_until = 0.0
	_stun_until = 0.0
	_stun_started_at = 0.0
	_update_stagger_ui()


func is_player_posture_retired() -> bool:
	return true


func _block_health_ratio() -> float:
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN:
		var tier: int = clampi(int(AspectRuntime.tier), 0, 4)
		return maxf(
			RONIN_BLOCK_HEALTH_RATIO_MIN,
			RONIN_BLOCK_HEALTH_RATIO_T0 - RONIN_BLOCK_HEALTH_TIER_STEP * float(tier)
		)
	return BASE_BLOCK_HEALTH_RATIO


func get_player_block_health_ratio_for_test() -> float:
	return _block_health_ratio()


func _blocked_health_damage(incoming_damage: int) -> int:
	if incoming_damage <= 0:
		return 0
	return maxi(1, int(round(float(incoming_damage) * _block_health_ratio())))


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
				"resolved_attack_origin": [attack_origin.x, attack_origin.y],
				"relative_angle_deg": relative_angle,
				"player_posture_retired": true,
			})
		take_damage(dmg)
		knockback += (global_position - attack_origin).normalized() * 120.0
		if combat:
			combat.notify_got_hit({"damage": dmg, "type": dmg_type})
		return

	var hp_before: int = int(hp)
	var guard_damage: int = _blocked_health_damage(dmg)
	if guard_damage > 0:
		take_damage(guard_damage, false)
	var actual_health_lost: int = maxi(0, hp_before - int(hp))
	stagger = 0.0

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_resolution("block_success", self, resolved_attacker, area, {
			"damage_type": dmg_type,
			"incoming_health_damage": dmg,
			"health_damage_received": actual_health_lost,
			"block_health_ratio": _block_health_ratio(),
			"player_posture_retired": true,
			"aspect": AspectRuntime.selected_aspect if typeof(AspectRuntime) == TYPE_OBJECT else "",
			"aspect_tier": int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0,
			"relative_angle_deg": relative_angle,
		})

	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)
	knockback += (global_position - attack_origin).normalized() * 50.0

	var block_source: Node = attacker if attacker != null and is_instance_valid(attacker) else resolved_attacker
	if block_source != null and is_instance_valid(block_source):
		if block_source.has_method("on_blocked"):
			block_source.call("on_blocked")
		elif block_source.is_in_group("enemy_projectile") or block_source.is_in_group("deflectable"):
			block_source.queue_free()

	if hp > 0 and typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN and AspectRuntime.tier >= 1:
		_aspect_reprisal_until = Time.get_ticks_msec() * 0.001 + 0.85


func _try_fanged_guard(dmg: int, dmg_type: String, attacker: Node) -> bool:
	if not _aspect_fanged_guard_available or _state != State.ATTACKING:
		return false
	if dmg_type in ["grab", "mass", "unblockable", "perilous"]:
		return false
	var source: Node = _resolve_attacker(attacker if attacker is Area2D else null, attacker)
	if not (source is Node2D):
		return false
	var to_attacker: Vector2 = (source as Node2D).global_position - global_position
	if to_attacker.length_squared() > 0.001:
		var attack_facing: Vector2 = _attack_aim_dir.normalized()
		if attack_facing.dot(to_attacker.normalized()) < cos(deg_to_rad(CURRENT_BLOCK_ARC_DEGREES * 0.5)):
			return false

	var hp_before: int = int(hp)
	var guard_damage: int = _blocked_health_damage(dmg)
	if guard_damage > 0:
		take_damage(guard_damage, false)
	_aspect_fanged_guard_available = false
	stagger = 0.0
	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("wolf_fanged_guard", {
			"player": CombatTelemetry.snapshot_actor(self),
			"incoming_health_damage": dmg,
			"health_damage_received": maxi(0, hp_before - int(hp)),
			"block_health_ratio": _block_health_ratio(),
			"player_posture_retired": true,
		})
	return true


# =============================================================================
# VARIABLE-LENGTH BASIC CHAINS
# =============================================================================

func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	var authored_index: int = int(profile.get("aspect_combo_index", combo_idx))
	super._start_profile_attack(profile, authored_index)
	_combo_index = authored_index


func _activate_current_attack_hitbox() -> void:
	super._activate_current_attack_hitbox()
	if sword_hitbox == null or _attack_profile.is_empty():
		return
	sword_hitbox.set_meta("action_trigger", str(_attack_profile.get("action_trigger", "")))
	sword_hitbox.set_meta("aspect_id", str(_attack_profile.get("aspect_id", AspectRuntime.selected_aspect)))
	sword_hitbox.set_meta("aspect_tier", int(_attack_profile.get("aspect_tier", AspectRuntime.tier)))
	sword_hitbox.set_meta("blood_generation", bool(_attack_profile.get("blood_generation", true)))
	sword_hitbox.set_meta("spectral_min_range", float(_attack_profile.get("spectral_min_range", 0.0)))
	sword_hitbox.set_meta("spectral_edge", bool(_attack_profile.get("spectral_edge", false)))
	sword_hitbox.set_meta("aspect_passage", bool(_attack_profile.get("aspect_passage", false)))
	sword_hitbox.set_meta("perfect_weight", bool(_attack_profile.get("perfect_weight", false)))
	sword_hitbox.set_meta("blood_tempo_continuation", bool(_attack_profile.get("blood_tempo_continuation", false)))


func _aspect_basic_count() -> int:
	return ASPECT_CATALOG.get_basic_profiles(AspectRuntime.selected_aspect, AspectRuntime.tier).size()


func _can_queue_next_combo_attack() -> bool:
	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _queued_attack_hold_branch or _combo_attack_queued:
		return false
	if _combo_index >= _aspect_basic_count() - 1:
		return false
	if _attack_profile.is_empty() or not bool(_attack_profile.get("can_combo", true)):
		return false
	var duration: float = float(_attack_profile.get("duration", 0.30))
	var queue_start: float = float(_attack_profile.get("queue_start", 0.40))
	var combo_end: float = float(_attack_profile.get("combo_end", 1.00))
	var progress: float = _attack_elapsed / maxf(duration, 0.001)
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	return false


func _begin_attack_branch_hold() -> void:
	if not bool(_attack_profile.get("can_combo", true)):
		return
	if _combo_index >= _aspect_basic_count() - 1:
		return
	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _combo_attack_queued:
		return
	_attack_branch_hold_active = true
	_attack_branch_hold_timer = 0.0


func _can_queue_sword_branch() -> bool:
	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _queued_attack_hold_branch or _combo_attack_queued:
		return false
	if _attack_profile.is_empty() or not bool(_attack_profile.get("can_combo", true)):
		return false
	var duration: float = float(_attack_profile.get("duration", 0.30))
	var queue_start: float = float(_attack_profile.get("queue_start", 0.40))
	var combo_end: float = float(_attack_profile.get("combo_end", 1.00))
	var progress: float = _attack_elapsed / maxf(duration, 0.001)
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	return false


func _queue_next_combo_attack() -> void:
	if not _can_queue_next_combo_attack():
		return
	var next_index: int = int(_combo_index) + 1
	if next_index >= 3:
		var profile: Dictionary = _get_combo_profile(next_index).duplicate(true)
		profile["aspect_combo_index"] = next_index
		_queued_attack_profile = profile
		_queued_combo_index = -1
	else:
		_queued_combo_index = next_index
	_combo_attack_queued = true
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()


# =============================================================================
# REAL COMMITMENT / INTERRUPTION
# =============================================================================

func _on_hurt(dmg: int, dmg_type: String, attacker: Node = null) -> void:
	var was_attacking: bool = _state == State.ATTACKING
	var attack_id: String = str(_attack_profile.get("id", ""))
	var hp_before: int = int(hp)
	var resolve_allowed: bool = was_attacking and _aspect_resolve_available and _ronin_resolve_hit_eligible(dmg_type, attacker)
	var ordinary_hit: bool = dmg_type not in ["grab", "mass", "unblockable", "perilous"]
	var blood_hunt_allowed: bool = was_attacking and attack_id == "wolf_blood_hunt" and ordinary_hit
	var falling_mountain_allowed: bool = was_attacking and attack_id == "ronin_falling_mountain" and ordinary_hit
	var blood_art_attack: bool = attack_id in ["wolf_blood_hunt", "wraith_reach_corridor", "ronin_falling_mountain"]

	super._on_hurt(dmg, dmg_type, attacker)
	stagger = 0.0

	if was_attacking and blood_art_attack and _state != State.ATTACKING:
		if attack_id == "wolf_blood_hunt":
			_clear_blood_hunt_exceptions()
		AspectRuntime.finish_blood_art()
		return

	if not was_attacking or hp >= hp_before or hp <= 0 or _state != State.ATTACKING:
		return
	if resolve_allowed or blood_hunt_allowed or falling_mountain_allowed:
		return
	_interrupt_current_aspect_attack(attack_id)


func _interrupt_current_aspect_attack(attack_id: String) -> void:
	_deactivate_current_attack_hitbox()
	if attack_id == "wolf_blood_hunt":
		_clear_blood_hunt_exceptions()
	if attack_id in ["wolf_blood_hunt", "wraith_reach_corridor", "ronin_falling_mountain"]:
		AspectRuntime.finish_blood_art()
	_drop_combo()
	_recovery_timer = 0.0
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	if _state != State.STUNNED and hp > 0:
		_change_state(State.IDLE)
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("aspect_attack_interrupted", {
			"aspect": AspectRuntime.selected_aspect,
			"tier": AspectRuntime.tier,
			"attack_id": attack_id,
		})


func get_playtest_snapshot() -> Dictionary:
	var snapshot: Dictionary = super.get_playtest_snapshot()
	snapshot["posture"] = 0.0
	snapshot["max_posture"] = 0.0
	snapshot["posture_retired"] = true
	snapshot["block_health_ratio"] = _block_health_ratio()
	return snapshot