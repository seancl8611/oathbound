extends "res://Player/LegacyPlayerController.gd"

## =============================================================================
## OATHBOUND PLAYER - CURRENT COMBAT CONTROLLER
## =============================================================================
## This is the current player-facing rules layer. It intentionally inherits the
## imported legacy controller while we replace that implementation in smaller,
## testable pieces. The dependency is explicit: LegacyPlayerController.gd is active
## runtime plumbing, not an alternate/stale Player implementation.
## =============================================================================

const CURRENT_MAX_SPIRIT := 100
const CURRENT_MOVE_SPEED := 200.0
const CURRENT_DASH_DISTANCE := 96.0
const CURRENT_DASH_DURATION := 0.18
const CURRENT_DASH_REPEAT_INTERVAL := 0.30
const CURRENT_DASH_IFRAMES := 0.12
const CURRENT_DASH_SPEED := CURRENT_DASH_DISTANCE / CURRENT_DASH_DURATION
const CURRENT_INPUT_BUFFER := 0.10
const CURRENT_PARRY_WINDOW := 0.12
const CURRENT_COUNTER_WINDOW := 0.24
const CURRENT_BLOCK_ARC_DEGREES := 150.0
const CURRENT_POSTURE_RECOVER_DELAY := 0.75
const CURRENT_POSTURE_RECOVER_RATE := 25.0
const CURRENT_POSTURE_BREAK_DURATION := 0.75
const CURRENT_POSTURE_BREAK_RESET_RATIO := 0.40

var _playtest_invulnerable: bool = false


func _ready() -> void:
	maxhp = 100
	hp = 100
	stagger_max = 100.0
	stagger = 0.0
	stagger_regen_rate = CURRENT_POSTURE_RECOVER_RATE
	stagger_regen_blocked = 0.0

	super._ready()

	if combat:
		combat.config = CombatConfig.create_player_config()

	if prosthetic_executor:
		prosthetic_executor.max_spirit = CURRENT_MAX_SPIRIT
		prosthetic_executor.current_spirit = CURRENT_MAX_SPIRIT
		if prosthetic_executor.has_signal("spirit_changed"):
			prosthetic_executor.emit_signal("spirit_changed", CURRENT_MAX_SPIRIT, CURRENT_MAX_SPIRIT)

	_update_health_bar()
	_update_stagger_ui()


# =============================================================================
# MOVEMENT
# =============================================================================

func _state_idle(delta: float):
	if _move_input.length() > 0.1:
		_change_state(State.MOVING)
		return

	_current_speed = move_toward(_current_speed, 0.0, CURRENT_MOVE_SPEED / DECEL_TIME * delta)
	if _current_speed < STOP_THRESHOLD:
		_current_speed = 0.0
	_move_velocity = _facing_dir * _current_speed
	_play_anim("idle")


func _state_moving(delta: float):
	if _move_input.length() < 0.1:
		_change_state(State.IDLE)
		return

	_facing_dir = _move_input.normalized()
	_current_speed = move_toward(_current_speed, CURRENT_MOVE_SPEED, CURRENT_MOVE_SPEED / ACCEL_TIME * delta)
	_move_velocity = _facing_dir * _current_speed

	_update_sprite_facing(_facing_dir)
	_play_anim("walk")


func _calculate_velocity(delta: float):
	var final_vel: Vector2 = Vector2.ZERO

	if knockback.length() > 1.0:
		final_vel = knockback
		knockback = knockback.move_toward(Vector2.ZERO, knockback_decay * 100.0 * delta)
	else:
		knockback = Vector2.ZERO

	match _state:
		State.IDLE, State.MOVING:
			final_vel += _move_velocity

		State.DODGING:
			final_vel = _dodge_dir * CURRENT_DASH_SPEED

		State.ATTACKING:
			if _is_attack_lunge_active():
				var lunge_speed: float = float(_attack_profile.get("lunge_speed", 0.0))
				final_vel += _attack_aim_dir * lunge_speed

		State.ATTACK_RECOVERY:
			final_vel += _move_velocity * 0.12

		State.USING_PROSTHETIC:
			pass

	if has_meta("puddle_slow_amount"):
		var slow_amount: float = float(get_meta("puddle_slow_amount"))
		if slow_amount > 0.0:
			final_vel *= (1.0 - slow_amount)

	if has_meta("_mist_raven_boost_until"):
		var boost_until: float = float(get_meta("_mist_raven_boost_until"))
		var now_mr: float = Time.get_ticks_msec() * 0.001
		if now_mr < boost_until:
			var boost_amt: float = float(get_meta("_mist_raven_boost", 0.0))
			var remaining: float = boost_until - now_mr
			var decay: float = remaining / 1.2
			final_vel *= (1.0 + boost_amt * decay)
		else:
			remove_meta("_mist_raven_boost")
			remove_meta("_mist_raven_boost_until")

	velocity = final_vel


func _get_effective_move_speed() -> float:
	var base_speed: float = CURRENT_MOVE_SPEED
	var puddle_slow: float = float(get_meta("puddle_slow_amount", 0.0))
	if puddle_slow > 0.0:
		base_speed *= (1.0 - puddle_slow)
	return base_speed


# =============================================================================
# INPUT BUFFER
# =============================================================================

func _buffer_input(action: String):
	_buffered_action = action
	_buffer_timer = CURRENT_INPUT_BUFFER


# =============================================================================
# DASH
# =============================================================================

func _start_dodge():
	_drop_combo()
	_dash_slash_consumed = false
	_clear_dash_slash_window()

	if _move_input.length() > 0.1:
		_dodge_dir = _move_input.normalized()
	else:
		_dodge_dir = _facing_dir

	_dodge_timer = CURRENT_DASH_DURATION
	_dodge_cooldown = CURRENT_DASH_REPEAT_INTERVAL
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	_lunge_timer = 0.0

	_is_invincible = true
	set_invincibility(true)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_dash_start", {
			"player": CombatTelemetry.snapshot_actor(self),
			"direction": [_dodge_dir.x, _dodge_dir.y],
			"duration": CURRENT_DASH_DURATION,
			"iframe_duration": CURRENT_DASH_IFRAMES,
		})

	_update_sprite_facing(_dodge_dir)
	_play_anim("dash")
	_change_state(State.DODGING)
	_setup_dodge_exceptions()


func _state_dodging(delta: float):
	_dodge_timer -= delta
	var elapsed: float = CURRENT_DASH_DURATION - maxf(_dodge_timer, 0.0)

	if elapsed <= CURRENT_DASH_IFRAMES:
		if not _is_invincible:
			_is_invincible = true
			set_invincibility(true)
	elif _is_invincible and not _playtest_invulnerable:
		_is_invincible = false
		set_invincibility(false)

	if _dodge_timer <= 0.0:
		_end_dodge()


# =============================================================================
# PARRY / COUNTER
# =============================================================================

func _get_effective_parry_window() -> float:
	return CURRENT_PARRY_WINDOW


func _start_parry(_window_s: float):
	_drop_combo()
	_clear_counter_cut_window()

	_parry_active = true
	_parry_timer = CURRENT_PARRY_WINDOW
	_perfect_parry_available = false
	_parry_spam_count = 0
	_parry_spam_reset_timer = 0.0

	_current_speed = 0.0
	_move_velocity = Vector2.ZERO

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_parry_open", {
			"player": CombatTelemetry.snapshot_actor(self),
			"window_sec": CURRENT_PARRY_WINDOW,
			"defense_held": Input.is_action_pressed("parry"),
		})

	var now: float = Time.get_ticks_msec() * 0.001
	if now <= _post_dodge_block_priority_until and Input.is_action_pressed("parry"):
		_block_held = true
		_change_state(State.BLOCKING)
		if combat:
			combat.start_block()
		_play_block_animation()
		if CombatTelemetry != null and CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("player_block_start", {
				"player": CombatTelemetry.snapshot_actor(self),
				"source": "post_dash_priority",
			})
		return

	_change_state(State.PARRYING)

	if Input.is_action_pressed("parry"):
		_play_block_animation()
	else:
		_play_anim("parry")


func _state_parrying(delta: float):
	_parry_timer -= delta
	_perfect_parry_available = false

	if _parry_timer <= 0.0:
		_parry_active = false
		if Input.is_action_pressed("parry"):
			_current_speed = 0.0
			_move_velocity = Vector2.ZERO
			_change_state(State.BLOCKING)
			if combat:
				combat.start_block()
			if CombatTelemetry != null and CombatTelemetry.is_capturing():
				CombatTelemetry.record_event("player_block_start", {
					"player": CombatTelemetry.snapshot_actor(self),
					"source": "parry_window_expired_while_held",
				})
		else:
			_change_state(State.IDLE)


func _open_counter_cut_window(target: Node = null) -> void:
	_counter_cut_until = Time.get_ticks_msec() * 0.001 + CURRENT_COUNTER_WINDOW
	_counter_cut_target = target


func _handle_parry_success(area: Area2D, attacker: Node, dmg_type: String, atk_pos: Vector2, _is_perfect: bool):
	var resolved_attacker: Node = _resolve_attacker(area, attacker)
	super._handle_parry_success(area, attacker, dmg_type, atk_pos, false)
	_perfect_parry_available = false
	_parry_grace_until = -1.0
	if not _playtest_invulnerable:
		set_invincibility(false)
	_open_counter_cut_window(resolved_attacker)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_resolution("parry_success", self, resolved_attacker, area, {
			"damage_type": dmg_type,
			"attack_position": [atk_pos.x, atk_pos.y],
			"counter_window_sec": CURRENT_COUNTER_WINDOW,
		})


# =============================================================================
# BLOCK
# =============================================================================

func _is_attack_inside_block_arc(atk_pos: Vector2) -> bool:
	var to_attacker: Vector2 = atk_pos - global_position
	if to_attacker.length_squared() <= 0.001:
		return true
	var facing: Vector2 = _facing_dir.normalized()
	if facing.length_squared() <= 0.001:
		facing = Vector2.RIGHT
	var angle_deg: float = absf(rad_to_deg(facing.angle_to(to_attacker.normalized())))
	return angle_deg <= CURRENT_BLOCK_ARC_DEGREES * 0.5


func _handle_block(area: Area2D, dmg: int, dmg_type: String, attacker: Node, atk_pos: Vector2):
	var to_attacker: Vector2 = atk_pos - global_position
	var block_angle_deg: float = 0.0
	if to_attacker.length_squared() > 0.001:
		var facing_for_angle: Vector2 = _facing_dir.normalized()
		if facing_for_angle.length_squared() <= 0.001:
			facing_for_angle = Vector2.RIGHT
		block_angle_deg = absf(rad_to_deg(facing_for_angle.angle_to(to_attacker.normalized())))

	if not _is_attack_inside_block_arc(atk_pos):
		if CombatTelemetry != null and CombatTelemetry.is_capturing():
			CombatTelemetry.record_resolution("block_failed_outside_arc", self, attacker, area, {
				"damage": dmg,
				"damage_type": dmg_type,
				"attack_position": [atk_pos.x, atk_pos.y],
				"relative_angle_deg": block_angle_deg,
				"block_half_arc_deg": CURRENT_BLOCK_ARC_DEGREES * 0.5,
			})
		take_damage(dmg)
		var rear_kb_dir: Vector2 = (global_position - atk_pos).normalized()
		knockback += rear_kb_dir * 120.0
		if combat:
			combat.notify_got_hit({"damage": dmg, "type": dmg_type})
		return

	var posture_before: float = stagger
	var block_posture: float = 12.0
	if area:
		if area.has_meta("block_posture_damage"):
			block_posture = float(area.get_meta("block_posture_damage"))
		elif area.has_meta("stagger_on_block"):
			block_posture = float(area.get_meta("stagger_on_block"))
	if attacker and block_posture == 12.0:
		if attacker.has_meta("block_posture_damage"):
			block_posture = float(attacker.get_meta("block_posture_damage"))
		elif attacker.has_meta("stagger_on_block"):
			block_posture = float(attacker.get_meta("stagger_on_block"))

	stagger = clampf(stagger + maxf(0.0, block_posture), 0.0, stagger_max)
	var now: float = Time.get_ticks_msec() * 0.001
	_stagger_suppress_until = now + CURRENT_POSTURE_RECOVER_DELAY

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_resolution("block_success", self, attacker, area, {
			"damage_type": dmg_type,
			"health_damage_received": 0,
			"posture_before": posture_before,
			"posture_damage": block_posture,
			"posture_after": stagger,
			"attack_position": [atk_pos.x, atk_pos.y],
			"relative_angle_deg": block_angle_deg,
		})

	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)

	var kb_dir: Vector2 = (global_position - atk_pos).normalized()
	knockback += kb_dir * 50.0

	if attacker and is_instance_valid(attacker):
		if attacker.has_method("on_blocked"):
			attacker.on_blocked()
		elif attacker.is_in_group("enemy_projectile") or attacker.is_in_group("deflectable"):
			attacker.queue_free()

	if stagger >= stagger_max - 0.001:
		_posture_break()


# =============================================================================
# PLAYER POSTURE
# =============================================================================

func _tick_stagger(delta: float):
	if stagger <= 0.0:
		return
	if _state == State.BLOCKING:
		return

	var now: float = Time.get_ticks_msec() * 0.001
	if now < _stagger_suppress_until:
		return
	if _state == State.STUNNED:
		return

	stagger = maxf(0.0, stagger - CURRENT_POSTURE_RECOVER_RATE * delta)


func _posture_break():
	var posture_before: float = stagger
	var now: float = Time.get_ticks_msec() * 0.001
	stagger = stagger_max
	_stun_until = now + CURRENT_POSTURE_BREAK_DURATION
	_stun_started_at = now

	_parry_active = false
	_block_held = false
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO

	_change_state(State.STUNNED)
	apply_hitstop(HITSTOP_POSTURE_BREAK)
	_shake_camera(SHAKE_HEAVY, 0.20)
	_play_anim("hurt")
	emit_signal("posture_broken_player")

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_posture_break", {
			"player": CombatTelemetry.snapshot_actor(self),
			"posture_before": posture_before,
			"break_duration_sec": CURRENT_POSTURE_BREAK_DURATION,
			"reset_ratio": CURRENT_POSTURE_BREAK_RESET_RATIO,
		})


func _recover_from_stun():
	if sprite:
		sprite.offset = Vector2.ZERO

	stagger = stagger_max * CURRENT_POSTURE_BREAK_RESET_RATIO
	var now: float = Time.get_ticks_msec() * 0.001
	_stagger_suppress_until = now + CURRENT_POSTURE_RECOVER_DELAY
	_stun_until = 0.0
	_stun_started_at = 0.0
	_drop_combo()
	_change_state(State.IDLE)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_posture_recovered_from_break", {
			"player": CombatTelemetry.snapshot_actor(self),
			"posture_after": stagger,
		})


# =============================================================================
# PLAYTEST LAB API
# =============================================================================

func take_damage(amount: int, show_feedback: bool = true):
	if _playtest_invulnerable:
		return
	super.take_damage(amount, show_feedback)


func set_playtest_invulnerable(enabled: bool) -> void:
	_playtest_invulnerable = enabled
	_is_invincible = enabled
	set_invincibility(enabled)


func is_playtest_invulnerable() -> bool:
	return _playtest_invulnerable


func playtest_restore_full() -> void:
	hp = maxhp
	stagger = 0.0
	_stun_until = 0.0
	_stun_started_at = 0.0
	if prosthetic_executor:
		prosthetic_executor.current_spirit = prosthetic_executor.max_spirit
		if prosthetic_executor.has_signal("spirit_changed"):
			prosthetic_executor.emit_signal("spirit_changed", prosthetic_executor.current_spirit, prosthetic_executor.max_spirit)
	_update_health_bar()
	_update_stagger_ui()


func playtest_set_resources(health: float, posture: float, spirit: float) -> void:
	hp = clampi(int(health), 0, maxhp)
	stagger = clampf(posture, 0.0, stagger_max)
	if prosthetic_executor:
		prosthetic_executor.current_spirit = clampi(int(spirit), 0, prosthetic_executor.max_spirit)
		if prosthetic_executor.has_signal("spirit_changed"):
			prosthetic_executor.emit_signal("spirit_changed", prosthetic_executor.current_spirit, prosthetic_executor.max_spirit)
	_update_health_bar()
	_update_stagger_ui()


func get_playtest_snapshot() -> Dictionary:
	var spirit: int = 0
	var spirit_max: int = CURRENT_MAX_SPIRIT
	if prosthetic_executor:
		spirit = int(prosthetic_executor.current_spirit)
		spirit_max = int(prosthetic_executor.max_spirit)
	return {
		"health": hp,
		"max_health": maxhp,
		"posture": stagger,
		"max_posture": stagger_max,
		"spirit": spirit,
		"max_spirit": spirit_max,
		"state": State.keys()[_state] if _state >= 0 and _state < State.size() else str(_state),
		"invulnerable": _playtest_invulnerable,
	}


# =============================================================================
# CURRENT BASELINE INTROSPECTION
# =============================================================================

func get_core_combat_baseline() -> Dictionary:
	return {
		"max_health": maxhp,
		"max_posture": stagger_max,
		"max_spirit": CURRENT_MAX_SPIRIT,
		"move_speed": CURRENT_MOVE_SPEED,
		"dash_distance": CURRENT_DASH_DISTANCE,
		"dash_duration": CURRENT_DASH_DURATION,
		"dash_iframes": CURRENT_DASH_IFRAMES,
		"dash_repeat_interval": CURRENT_DASH_REPEAT_INTERVAL,
		"input_buffer": CURRENT_INPUT_BUFFER,
		"parry_window": CURRENT_PARRY_WINDOW,
		"counter_window": CURRENT_COUNTER_WINDOW,
		"block_arc_degrees": CURRENT_BLOCK_ARC_DEGREES,
		"posture_recover_delay": CURRENT_POSTURE_RECOVER_DELAY,
		"posture_recover_rate": CURRENT_POSTURE_RECOVER_RATE,
		"posture_break_duration": CURRENT_POSTURE_BREAK_DURATION,
		"posture_break_reset_ratio": CURRENT_POSTURE_BREAK_RESET_RATIO,
	}
