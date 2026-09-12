extends "res://Regions/Hushiro/Enemies/Standard/HollowStability.gd"

## Combat V2 Phase 6 migration for Hushiro's Hollow fodder enemy.
##
## HollowStability remains authoritative for canonical bite contact, shared Hushiro
## Posture ticking/readability, parry posture, stagger-first Deathblow, rewards, and
## death. This layer keeps that one-move identity intentionally simple while moving
## tactical cadence, action commitment, motion composition, Poise response, and room
## pressure admission onto the shared Combat V2 seams.

const RESPONSE_RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")
const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ENEMY_MOTOR_SCRIPT = preload("res://Core/Combat/EnemyMotor.gd")
const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")

const HOLLOW_BRAIN_INTERVAL: float = 0.16
const HOLLOW_BRAIN_MIN_HOLD: float = 0.10
const HOLLOW_BRAIN_STICKINESS: float = 0.04
const HOLLOW_PRESSURE_RETRY_FLOOR: float = 0.07
const HOLLOW_TOO_CLOSE_DISTANCE: float = 15.0

var _v2_response: EnemyCombatResponseRuntime = null
var _v2_action_runner: CombatActionRunner = null
var _v2_enemy_motor: EnemyMotor = null
var _v2_enemy_brain: EnemyBrain = null

var _v2_pressure_reservation_id: String = ""
var _v2_pressure_retry_until: float = -1.0


func _ready() -> void:
	super._ready()
	_install_v2_hollow_runtime()
	print("[Hollow] v3.0 - Combat V2 swarm/fodder migration")


func _install_v2_hollow_runtime() -> void:
	var response_value: Variant = RESPONSE_RUNTIME_SCRIPT.new()
	if response_value is EnemyCombatResponseRuntime:
		_v2_response = response_value as EnemyCombatResponseRuntime
		_v2_response.name = "EnemyCombatResponseRuntime"
		add_child(_v2_response)
		_v2_response.configure(self, EnemyCombatResponseProfile.hollow_v2())
	else:
		push_error("[HollowV2] Could not create EnemyCombatResponseRuntime")

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	if runner_value is CombatActionRunner:
		_v2_action_runner = runner_value as CombatActionRunner
		_v2_action_runner.name = "CombatActionRunner"
		add_child(_v2_action_runner)
		_v2_action_runner.configure(self)
	else:
		push_error("[HollowV2] Could not create CombatActionRunner")

	var motor_value: Variant = ENEMY_MOTOR_SCRIPT.new()
	if motor_value is EnemyMotor:
		_v2_enemy_motor = motor_value as EnemyMotor
		_v2_enemy_motor.name = "EnemyMotor"
		add_child(_v2_enemy_motor)
		_v2_enemy_motor.configure(self, 760.0, 1050.0, maxf(95.0, movement_speed * 1.55))
	else:
		push_error("[HollowV2] Could not create EnemyMotor")

	var brain_value: Variant = ENEMY_BRAIN_SCRIPT.new()
	if brain_value is EnemyBrain:
		_v2_enemy_brain = brain_value as EnemyBrain
		_v2_enemy_brain.name = "EnemyBrain"
		add_child(_v2_enemy_brain)
		_v2_enemy_brain.configure(self, HOLLOW_BRAIN_INTERVAL, HOLLOW_BRAIN_MIN_HOLD, HOLLOW_BRAIN_STICKINESS)
	else:
		push_error("[HollowV2] Could not create EnemyBrain")

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hollow_v2_runtime_attached", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"response": _v2_response != null,
			"action_runner": _v2_action_runner != null,
			"motor": _v2_enemy_motor != null,
			"brain": _v2_enemy_brain != null,
			"pressure": has_v2_hollow_pressure_runtime(),
		})


# =============================================================================
# SIMPLE SWARM BRAIN
# =============================================================================

func _tick_chase(now: float) -> void:
	if not is_instance_valid(player):
		_goto(HollowState.PATROL)
		velocity = Vector2.ZERO
		return

	if _player_hidden_in_smoke():
		_v2_release_pressure("player_hidden")
		_v2_set_motion(get_physics_process_delta_time(), Vector2.ZERO)
		return

	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()
	if distance > deaggro_radius:
		_saw_player_once = false
		if _v2_enemy_brain != null:
			_v2_enemy_brain.invalidate_intent("deaggro")
		_goto(HollowState.PATROL)
		return

	var toward: Vector2 = to_player / maxf(0.001, distance)
	var delta: float = get_physics_process_delta_time()

	# Hollows keep their swarm identity and never acquire the V1 `advance_move` gate,
	# but the room's role-aware crowd backoff must still be authoritative. Excess swarm
	# bodies retreat until their selected backoff expires and cannot start a fresh bite.
	if now < _backoff_until:
		if _v2_enemy_brain != null:
			_v2_enemy_brain.set_intent(&"reposition", now, "crowd_backoff")
		_v2_move_retreat(delta, toward)
		return

	var scores: Dictionary = _v2_hollow_intent_scores(now, distance)
	var intent: StringName = &"approach"
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		intent = _v2_enemy_brain.choose_intent(now, scores)

	match intent:
		&"bite":
			if _v2_try_start_bite(now, distance, toward):
				return
			_v2_move_orbit(delta, toward, distance)
		&"retreat":
			_v2_move_retreat(delta, toward)
		&"orbit", &"reposition":
			_v2_move_orbit(delta, toward, distance)
		_:
			_v2_move_approach(delta, toward, distance)


func _v2_hollow_intent_scores(now: float, distance: float) -> Dictionary:
	var bite_ready: bool = (
		now >= _next_attack_ready
		and now >= _v2_pressure_retry_until
		and now >= _backoff_until
		and distance <= attack_range
	)

	var bite_score: float = -INF
	if bite_ready:
		bite_score = 1.05 + clampf((attack_range - distance) / maxf(1.0, attack_range), 0.0, 0.18)

	var approach_score: float = 0.36
	if distance > attack_range:
		approach_score += clampf((distance - attack_range) / 90.0, 0.0, 0.72)
	if now < _v2_pressure_retry_until:
		approach_score -= 0.18

	var orbit_score: float = 0.24
	if distance <= preferred_wait_distance + 18.0:
		orbit_score += 0.20
	if not bite_ready:
		orbit_score += 0.24
	if now < _v2_pressure_retry_until:
		orbit_score += 0.34

	var retreat_score: float = 0.04
	if distance < HOLLOW_TOO_CLOSE_DISTANCE:
		retreat_score = 1.10
	elif distance < chase_stop_distance * 0.55:
		retreat_score = 0.68

	return {
		&"bite": bite_score,
		&"approach": approach_score,
		&"orbit": orbit_score,
		&"retreat": retreat_score,
	}


func _v2_move_approach(delta: float, direction: Vector2, distance: float) -> void:
	# Hollows are swarm bodies: unlike the old frontline gate, several may approach at
	# once. PressureDirectorV2 regulates actual damaging impacts, while this movement
	# keeps spatial pressure alive.
	var speed_scale: float = 1.08 if distance > preferred_wait_distance else 0.90
	_v2_set_motion(delta, direction * movement_speed * speed_scale)


func _v2_move_orbit(delta: float, direction: Vector2, distance: float) -> void:
	var tangent: Vector2 = direction.rotated(PI * 0.5 * _orbit_direction)
	var radial: Vector2 = Vector2.ZERO
	var target_distance: float = maxf(attack_range + 16.0, preferred_wait_distance * 0.82)
	if distance > target_distance + 18.0:
		radial = direction * movement_speed * 0.34
	elif distance < target_distance - 12.0:
		radial = -direction * movement_speed * 0.32
	_v2_set_motion(delta, tangent * orbit_speed + radial)


func _v2_move_retreat(delta: float, direction: Vector2) -> void:
	var tangent: Vector2 = direction.rotated(PI * 0.5 * _orbit_direction)
	_v2_set_motion(delta, -direction * movement_speed * 0.50 + tangent * orbit_speed * 0.35)


func _v2_set_motion(delta: float, desired: Vector2) -> void:
	if _v2_enemy_motor == null or not is_instance_valid(_v2_enemy_motor):
		velocity = desired
		return
	velocity = _v2_enemy_motor.resolve_velocity(delta, desired, Vector2.ZERO, _v2_action_runner)


# =============================================================================
# PRESSURE-WINDOW BITE ADMISSION
# =============================================================================

func _v2_try_start_bite(now: float, distance: float, toward: Vector2) -> bool:
	var admission: Dictionary = _request_v2_hollow_pressure(now, distance)
	if not bool(admission.get("admitted", false)):
		_v2_pressure_retry_until = maxf(now + HOLLOW_PRESSURE_RETRY_FLOOR, float(admission.get("retry_at", now + HOLLOW_PRESSURE_RETRY_FLOOR)))
		if _v2_enemy_brain != null:
			_v2_enemy_brain.request_immediate_reconsideration()
		return false

	_v2_pressure_reservation_id = str(admission.get("reservation_id", ""))
	_v2_pressure_retry_until = -1.0
	_begin_bite(toward)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.set_intent(&"bite", now, "attack_admitted")
	return true


func _request_v2_hollow_pressure(now: float, distance: float) -> Dictionary:
	var request: Dictionary = _v2_hollow_pressure_request(now, distance)
	if AttackDir != null and AttackDir.has_method("request_pressure_threat"):
		var value: Variant = AttackDir.call("request_pressure_threat", self, request)
		if value is Dictionary:
			return value as Dictionary

	# Isolated-scene compatibility only. Production Hushiro uses PressureDirectorV2.
	if _request_attack_token():
		return {"admitted": true, "reservation_id": "legacy_token", "impact_at": request.get("impact_at", now)}
	return {"admitted": false, "retry_at": now + 0.10, "reason": "legacy_fallback_denied"}


func _v2_hollow_pressure_request(now: float, _distance: float) -> Dictionary:
	return {
		"attack_id": "hollow_bite",
		"requested_at": now,
		"impact_at": now + bite_windup,
		"impact_delay": bite_windup,
		"active_duration": bite_active_time,
		"severity": "normal",
		"threat_cost": 0.65,
	}


func _v2_release_pressure(reason: String) -> void:
	var reservation_id: String = _v2_pressure_reservation_id
	_v2_pressure_reservation_id = ""
	if reservation_id.is_empty():
		return
	if reservation_id == "legacy_token":
		_release_attack_token()
		return
	if AttackDir != null and AttackDir.has_method("release_pressure_threat"):
		AttackDir.call("release_pressure_threat", self, reservation_id, reason)


# =============================================================================
# ACTION COMMITMENT + MOTOR
# =============================================================================

func _begin_bite(toward: Vector2) -> void:
	super._begin_bite(toward)
	_begin_v2_hollow_bite_action()


func _begin_v2_hollow_bite_action() -> void:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (definition_value is CombatActionDefinition):
		return
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	definition.action_id = &"hollow_bite"
	definition.startup_duration = maxf(0.01, bite_windup)
	definition.active_duration = maxf(0.01, bite_active_time)
	definition.recovery_duration = maxf(0.0, bite_recover_time)
	definition.commit_fraction = 0.48
	definition.startup_locomotion_weight = 0.32
	definition.committed_locomotion_weight = 0.08
	definition.active_locomotion_weight = 0.0
	definition.recovery_locomotion_weight = 0.56
	_v2_action_runner.begin(definition)


func _tick_windup() -> void:
	var delta: float = get_physics_process_delta_time()
	if _v2_action_runner != null and _v2_action_runner.is_running():
		if _v2_action_runner.allows_target_tracking() and is_instance_valid(player):
			var to_player: Vector2 = player.global_position - global_position
			if to_player.length_squared() > 0.001:
				_attack_dir = to_player.normalized()
		_v2_action_runner.tick(delta)
	_v2_set_motion(delta, _attack_dir * movement_speed * 0.18)
	if _state_timer <= 0.0:
		_begin_active_bite()


func _begin_active_bite() -> void:
	super._begin_active_bite()
	if _v2_action_runner != null:
		_v2_action_runner.mark_active()
	if _v2_enemy_motor != null:
		_v2_enemy_motor.set_action_motion(_attack_dir, bite_move_speed, maxf(0.01, bite_active_time))


func _tick_attack() -> void:
	var delta: float = get_physics_process_delta_time()
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.tick(delta)
	_v2_set_motion(delta, Vector2.ZERO)
	if _state_timer > 0.0:
		return
	_cleanup_attack_area()
	_next_attack_ready = Time.get_ticks_msec() * 0.001 + randf_range(attack_cooldown_min, attack_cooldown_max)
	_v2_release_pressure("bite_completed")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.mark_recovery()
	_goto(HollowState.RECOVER, bite_recover_time)


func _tick_recover() -> void:
	var delta: float = get_physics_process_delta_time()
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.tick(delta)
	var desired: Vector2 = Vector2.ZERO
	if is_instance_valid(player):
		var away: Vector2 = global_position - player.global_position
		if away.length_squared() > 0.001:
			desired = away.normalized() * movement_speed * 0.18
	_v2_set_motion(delta, desired)
	if _state_timer > 0.0:
		return
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.complete()
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()
	_goto(HollowState.CHASE)


# =============================================================================
# LOW-POISE FODDER RESPONSE
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, source: Node, response: Dictionary) -> void:
	if hp_damage <= 0 or state == HollowState.DEAD or has_died:
		return

	var committed: bool = _v2_hollow_attack_committed()
	var should_interrupt: bool = true
	if _v2_response != null:
		should_interrupt = _v2_response.should_interrupt(source, response, committed)

	if should_interrupt:
		_cancel_current_action(0.0)
		_goto(HollowState.STAGGER, hurt_stun_time)
		if anim:
			if anim.has_animation("parried"):
				anim.play("parried")
				_last_anim = "parried"
			elif anim.has_animation("hurt"):
				anim.play("hurt")
				_last_anim = "hurt"
	elif typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_v2_hit_absorbed_by_poise", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"profile": "hollow_v2",
			"state": state,
		})


func _v2_hollow_attack_committed() -> bool:
	if _v2_action_runner == null or not _v2_action_runner.is_running():
		return false
	return _v2_action_runner.phase_name() in ["COMMITTED", "ACTIVE"]


# =============================================================================
# CLEANUP / EXISTING COMBAT CONTRACTS
# =============================================================================

func _cancel_current_action(recovery: float = 0.28) -> void:
	_v2_release_pressure("cancelled")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("cancelled")
	super._cancel_current_action(recovery)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()


func on_parried(parrier_pos: Vector2) -> void:
	_v2_release_pressure("parried")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("parried")
	super.on_parried(parrier_pos)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()


func death() -> void:
	_v2_release_pressure("death")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("death")
	super.death()


func _exit_tree() -> void:
	_v2_release_pressure("exit_tree")
	super._exit_tree()


# =============================================================================
# VALIDATION / TELEMETRY SURFACE
# =============================================================================

func has_v2_hollow_runtime() -> bool:
	return (
		_v2_response != null and is_instance_valid(_v2_response)
		and _v2_action_runner != null and is_instance_valid(_v2_action_runner)
		and _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor)
		and _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain)
	)


func has_v2_hollow_pressure_runtime() -> bool:
	return AttackDir != null and AttackDir.has_method("request_pressure_threat") and AttackDir.has_method("release_pressure_threat")


func has_v2_hollow_pressure_reservation() -> bool:
	if _v2_pressure_reservation_id.is_empty():
		return false
	if _v2_pressure_reservation_id == "legacy_token":
		return has_attack_token
	if AttackDir != null and AttackDir.has_method("has_pressure_reservation"):
		return bool(AttackDir.call("has_pressure_reservation", self))
	return false


func get_v2_hollow_action_phase() -> String:
	if _v2_action_runner == null:
		return "UNAVAILABLE"
	return _v2_action_runner.phase_name()


func get_v2_hollow_intent() -> String:
	if _v2_enemy_brain == null:
		return "UNAVAILABLE"
	return str(_v2_enemy_brain.current_intent())


func uses_legacy_hollow_turn_token() -> bool:
	return false


func uses_legacy_advance_move_gate() -> bool:
	return false
