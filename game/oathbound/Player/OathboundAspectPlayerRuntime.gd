extends "res://Player/OathboundAspectPlayer.gd"

## Final integration layer used by the inherited Aspect player scene.
## Owns compatibility adaptations that the imported controller cannot express cleanly:
## Wolf's fourth Basic, Aspect metadata publication, run-start state, real hit
## interruption, and Ronin's authoritative guard-efficiency calculation.

func _ready() -> void:
	# A new Player instance marks a new run. Keep the player's selected Aspect, but
	# start the run at Tier 0 with an empty/locked Blood meter as documented.
	if typeof(AspectRuntime) == TYPE_OBJECT:
		AspectRuntime.reset_for_new_run()
	super._ready()

func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	var authored_index: int = int(profile.get("aspect_combo_index", combo_idx))
	super._start_profile_attack(profile, authored_index)
	# LegacyPlayerController clamps to its imported MAX_COMBO_HITS=3. Restore the
	# authored Wolf index after legacy initialization so the fourth Basic remains real.
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

# =============================================================================
# VARIABLE-LENGTH BASIC CHAINS
# =============================================================================

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
		# The imported recovery resolver rejects queued combo indices >=3. Queue the
		# fourth Wolf attack as an authored profile instead and carry its true index.
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

	# Posture break/death/overriding attacks may transition state inside the inherited
	# damage resolver. Blood Arts must leave resolving state even if the interruption
	# happened before this layer could explicitly cancel the attack.
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

# =============================================================================
# RONIN GUARD PROFILE
# =============================================================================

func _handle_block(area: Area2D, dmg: int, dmg_type: String, attacker: Node, atk_pos: Vector2) -> void:
	if AspectRuntime.selected_aspect != ASPECT_CATALOG.RONIN:
		super._handle_block(area, dmg, dmg_type, attacker, atk_pos)
		return

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
			})
		take_damage(dmg)
		knockback += (global_position - attack_origin).normalized() * 120.0
		if combat:
			combat.notify_got_hit({"damage": dmg, "type": dmg_type})
		return

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

	var posture_before: float = float(stagger)
	var effective_posture: float = maxf(0.0, block_posture) * ASPECT_CATALOG.block_posture_multiplier(ASPECT_CATALOG.RONIN)
	stagger = clampf(stagger + effective_posture, 0.0, stagger_max)
	_stagger_suppress_until = Time.get_ticks_msec() * 0.001 + ASPECT_CATALOG.posture_recovery_delay(ASPECT_CATALOG.RONIN)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_resolution("block_success", self, resolved_attacker, area, {
			"damage_type": dmg_type,
			"health_damage_received": 0,
			"posture_before": posture_before,
			"raw_block_posture": block_posture,
			"posture_damage": effective_posture,
			"posture_after": stagger,
			"aspect": "ronin",
			"relative_angle_deg": relative_angle,
		})

	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)
	knockback += (global_position - attack_origin).normalized() * 50.0

	if resolved_attacker != null and is_instance_valid(resolved_attacker):
		if resolved_attacker.has_method("on_blocked"):
			resolved_attacker.on_blocked()
		elif resolved_attacker.is_in_group("enemy_projectile") or resolved_attacker.is_in_group("deflectable"):
			resolved_attacker.queue_free()

	if stagger >= stagger_max - 0.001:
		_posture_break()
	elif AspectRuntime.tier >= 1:
		_aspect_reprisal_until = Time.get_ticks_msec() * 0.001 + 0.85
