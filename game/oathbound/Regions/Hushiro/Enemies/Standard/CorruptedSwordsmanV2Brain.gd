extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanV2Motion.gd"

## Combat V2 Phase 3 reference tactical layer.
##
## Replaces the Swordsman's per-frame ENGAGE/DEFEND decision churn with a reusable
## EnemyBrain cadence. Existing authored attack coroutines, CombatActionRunner,
## EnemyMotor, AttackDirector admission, canonical AttackEvent damage, Posture,
## guard/poise response, parry, and Deathblow remain authoritative.

const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")

const BRAIN_DECISION_INTERVAL: float = 0.18
const BRAIN_MIN_INTENT_HOLD: float = 0.14
const BRAIN_STICKINESS: float = 0.10
const PREFERRED_PRESSURE_DISTANCE: float = 68.0
const TOO_CLOSE_DISTANCE: float = 24.0

var _v2_enemy_brain: EnemyBrain = null


func _ready() -> void:
	super._ready()
	_install_v2_enemy_brain()
	print("[CorruptedSwordsman] v2.5 - controlled-cadence EnemyBrain reference slice")


func _install_v2_enemy_brain() -> void:
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		return
	var brain_value: Variant = ENEMY_BRAIN_SCRIPT.new()
	if not (brain_value is EnemyBrain):
		push_error("[CorruptedSwordsman] Could not create EnemyBrain")
		return
	_v2_enemy_brain = brain_value as EnemyBrain
	_v2_enemy_brain.name = "EnemyBrain"
	add_child(_v2_enemy_brain)
	_v2_enemy_brain.configure(self, BRAIN_DECISION_INTERVAL, BRAIN_MIN_INTENT_HOLD, BRAIN_STICKINESS)


# =============================================================================
# CONTROLLED-CADENCE TACTICAL OWNERSHIP
# =============================================================================

func _hfsm_tick(delta: float) -> void:
	_state_t += delta
	match ai_state:
		AIState.IDLE:
			_state_idle_tick(delta)
		AIState.ATTACK:
			_state_attack_tick(delta)
		AIState.STUNNED:
			_state_stunned_tick(delta)
		AIState.DEAD:
			pass
		_:
			_v2_brain_tick(delta)


func _v2_brain_tick(delta: float) -> void:
	if not is_instance_valid(player):
		velocity = knockback
		return

	_engaged = true
	_reposition_cooldown = maxf(0.0, _reposition_cooldown - delta)
	var now: float = Time.get_ticks_msec() * 0.001
	var to_player: Vector2 = player.global_position - global_position
	var distance: float = to_player.length()
	var direction: Vector2 = to_player / maxf(0.001, distance)

	if distance > deaggro_radius:
		_engaged = false
		if _v2_enemy_brain != null:
			_v2_enemy_brain.invalidate_intent("deaggro")
		_switch_state(AIState.IDLE)
		return

	# Smoke and other shared movement overrides remain higher-priority combat effects.
	if player.has_meta("in_smoke_cloud") and bool(player.get_meta("in_smoke_cloud")):
		if _v2_enemy_brain != null:
			_v2_enemy_brain.set_intent(&"reposition", now, "player_in_smoke")
		_v2_move_strafe(delta, direction, distance, 0.55)
		return

	# Preserve the existing reactive counter queue, but only the queue's one-shot
	# decision can start an attack. Normal tactical attack decisions come from Brain.
	var counter_was_queued: bool = _humanoid_counter_queued
	_tick_humanoid_counter_queue(now)
	if counter_was_queued and (telegraphing or swinging or is_attacking or ai_state == AIState.ATTACK):
		if _v2_enemy_brain != null:
			_v2_enemy_brain.set_intent(&"attack", now, "guard_counter")
		return

	_check_combat_stuck(delta)
	_update_player_passivity(delta)

	var scores: Dictionary = _v2_build_intent_scores(now, distance)
	var intent: StringName = &"approach"
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		intent = _v2_enemy_brain.choose_intent(now, scores)

	_v2_execute_intent(intent, delta, now, direction, distance)


func _v2_build_intent_scores(now: float, distance: float) -> Dictionary:
	var posture_ratio: float = _get_humanoid_posture_ratio_safe()
	var another_enemy_active: bool = _is_another_enemy_mid_swing()
	var attack_ready: bool = _v2_attack_temporally_ready(now)
	var guard_ready: bool = _v2_guard_ready(now)
	var time_since_attack: float = maxf(0.0, now - _last_attack_ended_at)
	var pressure_urgency: float = clampf(time_since_attack / maxf(0.25, max_passive_time), 0.0, 1.0)
	pressure_urgency = maxf(pressure_urgency, clampf(_passive_timer / maxf(0.25, max_passive_time), 0.0, 1.0))

	var attack_score: float = -INF
	var extended_attack_range: float = maxf(attack_start_max_range, running_min_distance + 45.0)
	if attack_ready and distance >= attack_start_min_range and distance <= extended_attack_range:
		attack_score = 0.80 + pressure_urgency * 0.35
		if distance <= close_combat_range:
			attack_score += 0.20
		elif distance <= attack_start_max_range:
			attack_score += 0.12
		else:
			# Only a running/approach attack should win this far out.
			attack_score -= 0.16
		if another_enemy_active:
			attack_score -= 0.32
		if posture_ratio >= 0.75:
			attack_score -= 0.12

	var approach_score: float = 0.26
	if distance > PREFERRED_PRESSURE_DISTANCE:
		approach_score += clampf((distance - PREFERRED_PRESSURE_DISTANCE) / 120.0, 0.0, 0.72)
	if distance > attack_start_max_range:
		approach_score += 0.20
	if another_enemy_active:
		approach_score -= 0.08

	var strafe_score: float = 0.30
	if distance >= TOO_CLOSE_DISTANCE and distance <= watch_distance + 35.0:
		strafe_score += 0.28
	if another_enemy_active:
		strafe_score += 0.34
	if not attack_ready:
		strafe_score += 0.18

	var guard_score: float = -INF
	if guard_ready and distance <= hushiro_guard_range:
		guard_score = 0.34 + posture_ratio * 0.35
		if not attack_ready:
			guard_score += 0.12
		if another_enemy_active:
			guard_score += 0.08
		# Guard is a tactical punctuation mark, never the default answer to proximity.
		guard_score = minf(guard_score, 0.78)

	var retreat_score: float = 0.10
	if distance < TOO_CLOSE_DISTANCE:
		retreat_score = 1.08 + clampf((TOO_CLOSE_DISTANCE - distance) / TOO_CLOSE_DISTANCE, 0.0, 0.30)
	elif distance < close_dist * 0.65 and posture_ratio >= 0.72:
		retreat_score = 0.72

	return {
		&"attack": attack_score,
		&"approach": approach_score,
		&"strafe": strafe_score,
		&"guard": guard_score,
		&"retreat": retreat_score,
	}


func _v2_execute_intent(
	intent: StringName,
	delta: float,
	now: float,
	direction: Vector2,
	distance: float
) -> void:
	match intent:
		&"attack":
			if ai_state != AIState.ENGAGE:
				_switch_state(AIState.ENGAGE)
			if _can_attack_now(now):
				_try_attack()
				if telegraphing or swinging or is_attacking or _in_running_approach:
					if _v2_enemy_brain != null:
						_v2_enemy_brain.set_intent(&"attack", now, "attack_started")
					return
			_v2_move_approach(delta, direction, distance)
		&"guard":
			if ai_state != AIState.DEFEND:
				_switch_state(AIState.DEFEND)
			_v2_move_guard(delta, direction, distance)
		&"retreat":
			if ai_state != AIState.ENGAGE:
				_switch_state(AIState.ENGAGE)
			_v2_move_retreat(delta, direction)
		&"strafe", &"reposition":
			if ai_state != AIState.ENGAGE:
				_switch_state(AIState.ENGAGE)
			_v2_move_strafe(delta, direction, distance)
		_:
			if ai_state != AIState.ENGAGE:
				_switch_state(AIState.ENGAGE)
			_v2_move_approach(delta, direction, distance)


# =============================================================================
# TACTICAL MOVEMENT INTENTS
# =============================================================================
# These produce desired locomotion only. EnemyMotor still owns acceleration,
# deceleration, action-motion composition, and final velocity.

func _v2_move_approach(delta: float, direction: Vector2, distance: float) -> void:
	if not _approach_gate_ok():
		_v2_move_strafe(delta, direction, distance, 0.80)
		return
	var separation: Vector2 = _compute_separation()
	var avoidance: Vector2 = _compute_wall_avoidance()
	var speed: float = approach_speed
	if distance > watch_distance + 45.0:
		speed *= 1.18
	elif distance < PREFERRED_PRESSURE_DISTANCE:
		speed *= 0.62
	var target: Vector2 = direction * speed + separation + avoidance * 0.45 + knockback
	velocity = _smooth_velocity(target, delta)


func _v2_move_strafe(delta: float, direction: Vector2, distance: float, speed_scale: float = 1.0) -> void:
	var separation: Vector2 = _compute_separation()
	var avoidance: Vector2 = _compute_wall_avoidance()
	var perpendicular := Vector2(-direction.y, direction.x) * float(_orbit_direction)
	var radial: Vector2 = Vector2.ZERO
	if distance > PREFERRED_PRESSURE_DISTANCE + 16.0:
		radial = direction * (approach_speed * 0.34)
	elif distance < PREFERRED_PRESSURE_DISTANCE - 18.0:
		radial = -direction * (stepback_speed * 0.80)
	var lateral_speed: float = maxf(34.0, watch_orbit_speed * 1.10) * speed_scale
	var target: Vector2 = perpendicular * lateral_speed + radial + separation + avoidance * 0.55 + knockback
	velocity = _smooth_velocity(target, delta)


func _v2_move_guard(delta: float, direction: Vector2, distance: float) -> void:
	var separation: Vector2 = _compute_separation()
	var avoidance: Vector2 = _compute_wall_avoidance()
	var perpendicular := Vector2(-direction.y, direction.x) * float(_orbit_direction)
	var radial: Vector2 = Vector2.ZERO
	if distance < close_dist:
		radial = -direction * (stepback_speed * 0.55)
	elif distance > PREFERRED_PRESSURE_DISTANCE + 12.0:
		radial = direction * (approach_speed * 0.16)
	var target: Vector2 = perpendicular * 18.0 + radial + separation + avoidance * 0.50 + knockback
	velocity = _smooth_velocity(target, delta)


func _v2_move_retreat(delta: float, direction: Vector2) -> void:
	var separation: Vector2 = _compute_separation()
	var avoidance: Vector2 = _compute_wall_avoidance()
	var perpendicular := Vector2(-direction.y, direction.x) * float(_orbit_direction)
	var retreat_speed: float = maxf(62.0, stepback_speed * 1.85)
	var target: Vector2 = -direction * retreat_speed + perpendicular * 16.0 + separation + avoidance * 0.65 + knockback
	velocity = _smooth_velocity(target, delta)


# =============================================================================
# ATTACK / GUARD READINESS
# =============================================================================

func _v2_attack_temporally_ready(now: float) -> bool:
	if telegraphing or swinging or is_attacking or _dbroken_active:
		return false
	if now < stunned_until or now < _recover_lock_until or now < next_swipe_time:
		return false
	if ProstheticEffects.is_confused(self):
		return false
	return now - _last_attack_ended_at >= attack_gap_minimum


func _v2_guard_ready(now: float) -> bool:
	if not can_block or _dbroken_active or telegraphing or is_attacking:
		return false
	if now < stunned_until or now < _block_stagger_until:
		return false
	if _v2_response != null and is_instance_valid(_v2_response):
		return float(_v2_response.call("guard_cooldown_remaining", now)) <= 0.0
	return true


func _can_attack_now(now: float) -> bool:
	# Phase 3 removes the old per-frame "another enemy mid-swing" courtesy check.
	# Current AttackDirector still owns actual admission, so this does not permit
	# dogpiling; it only prevents two separate legacy gates from serializing combat.
	if not _v2_attack_temporally_ready(now):
		return false
	if not has_attack_token:
		if not _request_attack_token():
			return false
	return true


func _finish_attack() -> void:
	super._finish_attack()
	if has_died or ai_state == AIState.DEAD:
		return
	# Legacy finish randomly chose DEFEND vs ENGAGE. Phase 3 deliberately removes
	# that post-attack coin flip; the brain makes the next tactical decision instead.
	_force_attack_soon = false
	_switch_state(AIState.ENGAGE)
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		_v2_enemy_brain.request_immediate_reconsideration()


# =============================================================================
# VALIDATION / TELEMETRY SURFACE
# =============================================================================

func has_v2_enemy_brain_runtime() -> bool:
	return _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain)


func get_v2_brain_intent() -> String:
	if _v2_enemy_brain == null or not is_instance_valid(_v2_enemy_brain):
		return "UNAVAILABLE"
	return str(_v2_enemy_brain.current_intent())


func get_v2_brain_scores() -> Dictionary:
	if _v2_enemy_brain == null or not is_instance_valid(_v2_enemy_brain):
		return {}
	return _v2_enemy_brain.last_scores()
