extends "res://Regions/Hushiro/Enemies/Standard/BlightedHound.gd"

## Combat V2 Phase 6 migration for the Blighted Hound.
##
## The imported Hound still owns its canonical bite/lunge hitboxes, parry indicator,
## shared Hushiro Posture bridge, Deathblow presentation, rewards, and pack identity.
## This layer replaces the responsibilities that made the beast behave like another
## serialized duel opponent: tactical choice, motion composition, action commitment,
## Poise interruption, and whole-turn AttackDirector admission.

const RESPONSE_RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")
const RESPONSE_PROFILE_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseProfile.gd")
const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ENEMY_MOTOR_SCRIPT = preload("res://Core/Combat/EnemyMotor.gd")
const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")

const HOUND_BRAIN_INTERVAL: float = 0.14
const HOUND_BRAIN_MIN_HOLD: float = 0.10
const HOUND_BRAIN_STICKINESS: float = 0.06
const HOUND_PRESSURE_RETRY_FLOOR: float = 0.08
const HOUND_TOO_CLOSE_DISTANCE: float = 18.0

var _v2_response: EnemyCombatResponseRuntime = null
var _v2_action_runner: CombatActionRunner = null
var _v2_enemy_motor: EnemyMotor = null
var _v2_enemy_brain: EnemyBrain = null

var _v2_pressure_reservation_id: String = ""
var _v2_pressure_retry_until: float = -1.0
var _v2_pressure_kind: StringName = &""


func _ready() -> void:
	super._ready()
	_install_v2_hound_runtime()
	print("[BlightedHound] v6.0 - Combat V2 predator migration")


func _install_v2_hound_runtime() -> void:
	var response_value: Variant = RESPONSE_RUNTIME_SCRIPT.new()
	if response_value is EnemyCombatResponseRuntime:
		_v2_response = response_value as EnemyCombatResponseRuntime
		_v2_response.name = "EnemyCombatResponseRuntime"
		add_child(_v2_response)
		_v2_response.configure(self, EnemyCombatResponseProfile.blighted_hound_v2())
	else:
		push_error("[BlightedHoundV2] Could not create EnemyCombatResponseRuntime")

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	if runner_value is CombatActionRunner:
		_v2_action_runner = runner_value as CombatActionRunner
		_v2_action_runner.name = "CombatActionRunner"
		add_child(_v2_action_runner)
		_v2_action_runner.configure(self)
	else:
		push_error("[BlightedHoundV2] Could not create CombatActionRunner")

	var motor_value: Variant = ENEMY_MOTOR_SCRIPT.new()
	if motor_value is EnemyMotor:
		_v2_enemy_motor = motor_value as EnemyMotor
		_v2_enemy_motor.name = "EnemyMotor"
		add_child(_v2_enemy_motor)
		_v2_enemy_motor.configure(self, 900.0, 1200.0, maxf(120.0, movement_speed * 1.45))
	else:
		push_error("[BlightedHoundV2] Could not create EnemyMotor")

	var brain_value: Variant = ENEMY_BRAIN_SCRIPT.new()
	if brain_value is EnemyBrain:
		_v2_enemy_brain = brain_value as EnemyBrain
		_v2_enemy_brain.name = "EnemyBrain"
		add_child(_v2_enemy_brain)
		_v2_enemy_brain.configure(self, HOUND_BRAIN_INTERVAL, HOUND_BRAIN_MIN_HOLD, HOUND_BRAIN_STICKINESS)
	else:
		push_error("[BlightedHoundV2] Could not create EnemyBrain")

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hound_v2_runtime_attached", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"response": _v2_response != null,
			"action_runner": _v2_action_runner != null,
			"motor": _v2_enemy_motor != null,
			"brain": _v2_enemy_brain != null,
			"pressure": has_v2_hound_pressure_runtime(),
		})


# =============================================================================
# CONTROLLED-CADENCE PREDATOR BRAIN
# =============================================================================

func _state_chase(delta: float, now: float) -> void:
	_v2_predator_tick(delta, now)


func _state_orbit(delta: float, now: float) -> void:
	_v2_predator_tick(delta, now)


func _v2_predator_tick(delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(State.PATROL)
		return

	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()
	if distance > deaggro_radius:
		_saw_player_once = false
		if _v2_enemy_brain != null:
			_v2_enemy_brain.invalidate_intent("deaggro")
		_goto(State.PATROL)
		return

	var direction: Vector2 = to_player / maxf(0.001, distance)
	_charge_dir = direction if direction.length_squared() > 0.001 else _charge_dir

	var scores: Dictionary = _v2_hound_intent_scores(now, distance)
	var intent: StringName = &"approach"
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		intent = _v2_enemy_brain.choose_intent(now, scores)

	match intent:
		&"lunge":
			if _v2_try_start_attack(&"lunge", now, distance):
				return
			_v2_move_orbit(delta, direction, distance, 1.05)
		&"bite":
			if _v2_try_start_attack(&"bite", now, distance):
				return
			_v2_move_orbit(delta, direction, distance, 0.90)
		&"retreat":
			_v2_move_retreat(delta, direction)
		&"orbit", &"reposition":
			_v2_move_orbit(delta, direction, distance)
		_:
			_v2_move_approach(delta, direction, distance)


func _v2_hound_intent_scores(now: float, distance: float) -> Dictionary:
	var can_attack: bool = now >= _next_attack_ready and now >= _v2_pressure_retry_until and now >= _backoff_until
	var lunge_ready: bool = can_attack and now >= _next_lunge_ready and distance >= lunge_min_range and distance <= lunge_range
	var bite_ready: bool = can_attack and now >= _next_bite_ready and distance >= bite_min_range and distance <= bite_range

	var lunge_score: float = -INF
	if lunge_ready:
		var center: float = (lunge_min_range + lunge_range) * 0.5
		var range_quality: float = 1.0 - clampf(absf(distance - center) / maxf(1.0, lunge_range - lunge_min_range), 0.0, 1.0)
		lunge_score = 0.86 + range_quality * 0.30

	var bite_score: float = -INF
	if bite_ready:
		bite_score = 1.00 + clampf((bite_range - distance) / maxf(1.0, bite_range), 0.0, 0.20)

	var approach_score: float = 0.22
	if distance > hold_distance:
		approach_score += clampf((distance - hold_distance) / 100.0, 0.0, 0.78)
	if distance > lunge_range:
		approach_score += 0.20
	if now < _backoff_until:
		approach_score -= 0.45

	var orbit_score: float = 0.34
	if distance >= bite_range * 0.75 and distance <= lunge_range + 35.0:
		orbit_score += 0.26
	if not can_attack:
		orbit_score += 0.30
	if now < _v2_pressure_retry_until:
		orbit_score += 0.22
	if now < _backoff_until:
		orbit_score += 0.32

	var retreat_score: float = 0.08
	if distance < HOUND_TOO_CLOSE_DISTANCE:
		retreat_score = 1.08
	elif distance < bite_min_range:
		retreat_score = 0.78

	return {
		&"lunge": lunge_score,
		&"bite": bite_score,
		&"approach": approach_score,
		&"orbit": orbit_score,
		&"retreat": retreat_score,
	}


func _v2_move_approach(delta: float, direction: Vector2, distance: float) -> void:
	if not _approach_gate_ok():
		_v2_move_orbit(delta, direction, distance, 1.05)
		return
	var speed_scale: float = 1.08 if distance > lunge_range else 0.90
	_v2_set_motion(delta, direction * movement_speed * speed_scale)


func _v2_move_orbit(delta: float, direction: Vector2, distance: float, speed_scale: float = 1.0) -> void:
	var tangent: Vector2 = direction.rotated(PI * 0.5 * _orbit_dir)
	var radial: Vector2 = Vector2.ZERO
	var target_distance: float = maxf(hold_distance, 74.0)
	if distance > target_distance + 28.0:
		radial = direction * movement_speed * 0.32
	elif distance < target_distance - 16.0:
		radial = -direction * movement_speed * 0.38
	var desired: Vector2 = tangent * orbit_speed * speed_scale + radial
	_v2_set_motion(delta, desired)


func _v2_move_retreat(delta: float, direction: Vector2) -> void:
	var tangent: Vector2 = direction.rotated(PI * 0.5 * _orbit_dir)
	_v2_set_motion(delta, -direction * movement_speed * 0.58 + tangent * orbit_speed * 0.35)


func _v2_set_motion(delta: float, desired: Vector2) -> void:
	if _v2_enemy_motor == null or not is_instance_valid(_v2_enemy_motor):
		velocity = desired
		return
	velocity = _v2_enemy_motor.resolve_velocity(delta, desired, Vector2.ZERO, _v2_action_runner)


# =============================================================================
# PRESSURE-WINDOW ATTACK ADMISSION
# =============================================================================

func _v2_try_start_attack(kind: StringName, now: float, distance: float) -> bool:
	var admission: Dictionary = _request_v2_hound_pressure(kind, now, distance)
	if not bool(admission.get("admitted", false)):
		_v2_pressure_retry_until = maxf(now + HOUND_PRESSURE_RETRY_FLOOR, float(admission.get("retry_at", now + HOUND_PRESSURE_RETRY_FLOOR)))
		if _v2_enemy_brain != null:
			_v2_enemy_brain.request_immediate_reconsideration()
		return false

	_v2_pressure_reservation_id = str(admission.get("reservation_id", ""))
	_v2_pressure_kind = kind
	_v2_pressure_retry_until = -1.0
	if kind == &"lunge":
		_start_lunge_windup()
	else:
		_start_bite_windup()
	if _v2_enemy_brain != null:
		_v2_enemy_brain.set_intent(kind, now, "attack_admitted")
	return true


func _request_v2_hound_pressure(kind: StringName, now: float, distance: float) -> Dictionary:
	var request: Dictionary = _v2_hound_pressure_request(kind, now, distance)
	if AttackDir != null and AttackDir.has_method("request_pressure_threat"):
		var value: Variant = AttackDir.call("request_pressure_threat", self, request)
		if value is Dictionary:
			return value as Dictionary

	# Compatibility fallback for isolated scenes. Production uses PressureDirectorV2;
	# never silently make the Hound inert when the autoload is absent.
	if _request_attack_token():
		return {"admitted": true, "reservation_id": "legacy_token", "impact_at": request.get("impact_at", now)}
	return {"admitted": false, "retry_at": now + 0.12, "reason": "legacy_fallback_denied"}


func _v2_hound_pressure_request(kind: StringName, now: float, distance: float) -> Dictionary:
	if kind == &"lunge":
		var reach: float = (lunge_hitbox_size.x * 0.5 + 8.0) + lunge_reach_fudge
		var travel: float = minf(maxf(0.0, distance - reach) / maxf(1.0, lunge_speed), lunge_max_total_time)
		var impact_delay: float = lunge_windup + travel
		return {
			"attack_id": "hound_lunge",
			"requested_at": now,
			"impact_at": now + impact_delay,
			"impact_delay": impact_delay,
			"active_duration": lunge_active_time,
			"severity": "heavy",
			"threat_cost": 1.20,
		}

	return {
		"attack_id": "hound_bite",
		"requested_at": now,
		"impact_at": now + bite_windup,
		"impact_delay": bite_windup,
		"active_duration": bite_active_time,
		"severity": "normal",
		"threat_cost": 0.90,
	}


func _release_v2_hound_pressure(reason: String) -> void:
	var reservation_id: String = _v2_pressure_reservation_id
	_v2_pressure_reservation_id = ""
	_v2_pressure_kind = &""
	if reservation_id.is_empty():
		return
	if reservation_id == "legacy_token":
		_release_attack_token()
		return
	if AttackDir != null and AttackDir.has_method("release_pressure_threat"):
		AttackDir.call("release_pressure_threat", self, reservation_id, reason)


# =============================================================================
# ACTION LIFECYCLE + MOTION
# =============================================================================

func _start_lunge_windup() -> void:
	super._start_lunge_windup()
	_begin_v2_hound_action(&"hound_lunge", lunge_windup, lunge_active_time, recover_time, 0.58, 0.34, 0.08, 0.00, 0.58)


func _start_bite_windup() -> void:
	super._start_bite_windup()
	_begin_v2_hound_action(&"hound_bite", bite_windup, bite_active_time, recover_time, 0.52, 0.28, 0.06, 0.00, 0.62)


func _begin_v2_hound_action(
	action_id: StringName,
	startup: float,
	active: float,
	recovery: float,
	commit_fraction: float,
	startup_weight: float,
	committed_weight: float,
	active_weight: float,
	recovery_weight: float
) -> void:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (definition_value is CombatActionDefinition):
		return
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	definition.action_id = action_id
	definition.startup_duration = maxf(0.01, startup)
	definition.active_duration = maxf(0.01, active)
	definition.recovery_duration = maxf(0.0, recovery)
	definition.commit_fraction = clampf(commit_fraction, 0.05, 0.95)
	definition.startup_locomotion_weight = clampf(startup_weight, 0.0, 1.0)
	definition.committed_locomotion_weight = clampf(committed_weight, 0.0, 1.0)
	definition.active_locomotion_weight = clampf(active_weight, 0.0, 1.0)
	definition.recovery_locomotion_weight = clampf(recovery_weight, 0.0, 1.0)
	_v2_action_runner.begin(definition)


func _state_lunge_windup(delta: float, now: float) -> void:
	_v2_tick_windup(delta, 0.26)
	if _state_timer <= 0.0:
		_execute_lunge(now)


func _state_bite_windup(delta: float, now: float) -> void:
	_v2_tick_windup(delta, 0.20)
	if _state_timer <= 0.0:
		_execute_bite(now)


func _v2_tick_windup(delta: float, creep_scale: float) -> void:
	if _v2_action_runner != null and _v2_action_runner.is_running():
		if _v2_action_runner.allows_target_tracking() and is_instance_valid(player):
			var to_player: Vector2 = player.global_position - global_position
			if to_player.length_squared() > 0.001:
				_charge_dir = to_player.normalized()
		_v2_action_runner.tick(delta)
	var tangent: Vector2 = _charge_dir.rotated(PI * 0.5 * _orbit_dir)
	_v2_set_motion(delta, _charge_dir * movement_speed * creep_scale + tangent * orbit_speed * 0.12)


func _execute_lunge(now: float) -> void:
	super._execute_lunge(now)
	if _v2_action_runner != null:
		_v2_action_runner.mark_active()
	if _v2_enemy_motor != null:
		_v2_enemy_motor.set_action_motion(_charge_dir, lunge_speed, maxf(0.01, _state_timer))


func _execute_bite(now: float) -> void:
	super._execute_bite(now)
	if _v2_action_runner != null:
		_v2_action_runner.mark_active()
	if _v2_enemy_motor != null:
		_v2_enemy_motor.set_action_motion(_charge_dir, bite_speed, maxf(0.01, bite_active_time))


func _state_lunge(delta: float, now: float) -> void:
	if _v2_action_runner != null:
		_v2_action_runner.tick(delta)
	_v2_set_motion(delta, Vector2.ZERO)
	if _state_timer > 0.0:
		return
	_hide_parry_indicator()
	_disarm_hitbox()
	_next_lunge_ready = now + lunge_cd
	_next_attack_ready = now + attack_cd
	_release_v2_hound_pressure("lunge_completed")
	_begin_v2_recovery()


func _state_bite(delta: float, now: float) -> void:
	if _v2_action_runner != null:
		_v2_action_runner.tick(delta)
	_v2_set_motion(delta, Vector2.ZERO)
	if _state_timer > 0.0:
		return
	_hide_parry_indicator()
	_disarm_hitbox()
	_next_bite_ready = now + bite_cd
	_next_attack_ready = now + attack_cd
	_release_v2_hound_pressure("bite_completed")
	_begin_v2_recovery()


func _begin_v2_recovery() -> void:
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.mark_recovery()
	_goto(State.RECOVER, recover_time)


func _state_recover(delta: float, now: float) -> void:
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.tick(delta)
	var desired: Vector2 = Vector2.ZERO
	if is_instance_valid(player):
		var away: Vector2 = global_position - player.global_position
		if away.length_squared() > 0.001:
			away = away.normalized()
			var tangent: Vector2 = away.rotated(PI * 0.5 * _orbit_dir)
			desired = away * movement_speed * 0.28 + tangent * orbit_speed * 0.24
	_v2_set_motion(delta, desired)
	if _state_timer > 0.0:
		return
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.complete()
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()
	_goto(State.CHASE)


# =============================================================================
# HEALTH / POISE RESPONSE
# =============================================================================

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if state == State.DEAD or has_died:
		return
	if damage <= 0 and damage_type != "knockback":
		return
	if damage_type == "knockback":
		if attacker is Node2D:
			apply_knockback((attacker as Node2D).global_position.direction_to(global_position) * damage)
		return

	var hp_damage: int = apply_hp_damage(damage)
	if hp_damage > 0 and is_instance_valid(player):
		ProstheticEffects.check_lifesteal(player, hp_damage)
	if hp_damage > 0:
		show_enemy_damage_number(hp_damage, damage_type, -20.0)

	notify_combat_got_hit({
		"damage": damage,
		"blocked": false,
		"damage_type": damage_type,
	})
	if hp <= 0:
		death()
		return

	var response: Dictionary = _v2_current_attack_response()
	var committed: bool = _v2_hound_attack_committed()
	var should_interrupt: bool = true
	if _v2_response != null:
		should_interrupt = _v2_response.should_interrupt(attacker, response, committed)

	var now: float = Time.get_ticks_msec() * 0.001
	if should_interrupt:
		stunned_until = now + 0.12
		if state in [State.LUNGE_WINDUP, State.LUNGE, State.BITE_WINDUP, State.BITE]:
			_v2_interrupt_hound_action(now, "poise_interrupt")
	elif typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_v2_hit_absorbed_by_poise", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"profile": "blighted_hound_v2",
			"state": state,
		})

	ProstheticEffects.apply(attacker, self, false)
	if snd_hit:
		snd_hit.play()


func _v2_current_attack_response() -> Dictionary:
	var response: Dictionary = {}
	var combat: Node = get_node_or_null("Combat")
	if combat != null and combat.has_method("has_active_attack_event") and bool(combat.call("has_active_attack_event")) and combat.has_method("get_active_attack_event"):
		var event_value: Variant = combat.call("get_active_attack_event")
		if event_value is Dictionary:
			var event: Dictionary = event_value as Dictionary
			response["heavy"] = int(event.get("stagger_level", 0)) >= 1 or int(event.get("poise_damage", 0)) >= 2
	return response


func _v2_hound_attack_committed() -> bool:
	if _v2_action_runner == null or not _v2_action_runner.is_running():
		return false
	return _v2_action_runner.phase_name() in ["COMMITTED", "ACTIVE"]


func _v2_interrupt_hound_action(now: float, reason: String) -> void:
	_bump_attack_gen()
	_hide_parry_indicator()
	_disarm_hitbox()
	_release_v2_hound_pressure(reason)
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt(reason)
	_backoff_until = maxf(_backoff_until, now + 0.34)
	_next_attack_ready = maxf(_next_attack_ready, now + 0.44)
	_goto(State.RECOVER, 0.32)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.set_intent(&"reposition", now, reason)


# =============================================================================
# LEGACY COMPATIBILITY + CLEANUP
# =============================================================================

func _cancel_current_attack(now: float, because_revoked: bool = false) -> void:
	_release_v2_hound_pressure("legacy_revoked" if because_revoked else "cancelled")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("legacy_revoked" if because_revoked else "cancelled")
	super._cancel_current_attack(now, because_revoked)


func on_parried(parrier_pos: Vector2) -> void:
	_release_v2_hound_pressure("parried")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("parried")
	super.on_parried(parrier_pos)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()


func _trigger_posture_break() -> void:
	_release_v2_hound_pressure("posture_break")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("posture_break")
	super._trigger_posture_break()


func death() -> void:
	_release_v2_hound_pressure("death")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("death")
	super.death()


func _exit_tree() -> void:
	_release_v2_hound_pressure("exit_tree")
	super._exit_tree()


# =============================================================================
# VALIDATION / TELEMETRY SURFACE
# =============================================================================

func has_v2_hound_runtime() -> bool:
	return (
		_v2_response != null and is_instance_valid(_v2_response)
		and _v2_action_runner != null and is_instance_valid(_v2_action_runner)
		and _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor)
		and _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain)
	)


func has_v2_hound_pressure_runtime() -> bool:
	return AttackDir != null and AttackDir.has_method("request_pressure_threat") and AttackDir.has_method("release_pressure_threat")


func has_v2_hound_pressure_reservation() -> bool:
	if _v2_pressure_reservation_id.is_empty():
		return false
	if _v2_pressure_reservation_id == "legacy_token":
		return has_attack_token
	if AttackDir != null and AttackDir.has_method("has_pressure_reservation"):
		return bool(AttackDir.call("has_pressure_reservation", self))
	return false


func get_v2_hound_action_phase() -> String:
	if _v2_action_runner == null:
		return "UNAVAILABLE"
	return _v2_action_runner.phase_name()


func get_v2_hound_intent() -> String:
	if _v2_enemy_brain == null:
		return "UNAVAILABLE"
	return str(_v2_enemy_brain.current_intent())


func uses_legacy_hound_turn_token() -> bool:
	return false
