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
# Swordsmen must close into real hitbox reach before starting ordinary swings.
# The older 68-unit orbit left them visibly attacking outside blade contact.
const PREFERRED_PRESSURE_DISTANCE: float = 48.0
const TOO_CLOSE_DISTANCE: float = 24.0

@export var use_hades_melee_policy: bool = true
const HADES_MELEE_REACH: float = 51.0
const HADES_HOLD_DISTANCE: float = 13.0
const HADES_POST_ATTACK_HOLD: float = 0.35

var _hades_state: String = "approach"
var _hades_recovery_until: float = 0.0
var _hades_room_coordinator: Node = null
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

	# Encounter aggression is latched once acquired. Distance may change the
	# APPROACH destination, but never resets combat to patrol mid-wave.

	# Room crowd spacing owns close-body occupancy in Combat V2. A backed-off Swordsman
	# must not start a fresh attack/counter or immediately reacquire a sticky V1
	# `advance_move` role; it repositions until the room-authored backoff expires.
	if now < _backoff_until:
		if ai_state != AIState.ENGAGE:
			_switch_state(AIState.ENGAGE)
		if _v2_enemy_brain != null:
			_v2_enemy_brain.set_intent(&"reposition", now, "crowd_backoff")
		_v2_move_retreat(delta, direction)
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

	if use_hades_melee_policy:
		_hades_style_tick(delta, now, direction, distance)
		return

	var scores: Dictionary = _v2_build_intent_scores(now, distance)
	var intent: StringName = &"approach"
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		intent = _v2_enemy_brain.choose_intent(now, scores)

	_v2_execute_intent(intent, delta, now, direction, distance)


# Authored, Hades-inspired behavior replaces the tactical scorer for opted-in
# Swordsmen only. It does NOT replace the V2 attack/pressure implementation.
func uses_hades_melee_policy() -> bool:
	return use_hades_melee_policy


func get_hades_melee_state() -> String:
	return _hades_state if use_hades_melee_policy else "legacy_v2_scoring"


func _hades_style_tick(delta: float, now: float, direction: Vector2, distance: float) -> void:
	# Existing ATTACK/STUNNED/DEAD states are handled by _hfsm_tick first.
	# Guard is deliberately held until its authored window expires.
	if ai_state == AIState.DEFEND and now < _defend_until:
		_hades_hold(delta, "guard")
		return
	if ai_state != AIState.ENGAGE:
		_switch_state(AIState.ENGAGE)

	if now < _hades_recovery_until:
		_hades_hold(delta, "recover")
		return

	var plan: Dictionary = _hades_melee_plan()
	var role: String = str(plan.get("role", "engage"))
	var destination: Vector2 = plan.get("position", global_position)

	if role == "support":
		_hades_move_to(delta, destination, "support")
		return

	# Occasional defensive punctuation, not a random guard/strafe roll every
	# 0.18 seconds. Guard, posture and the existing counter system are retained.
	if now >= _hades_next_guard_at and distance <= HADES_MELEE_REACH:
		if get_hp_ratio() < 0.55 and _v2_guard_ready(now) and not _v2_attack_temporally_ready(now):
			_hades_next_guard_at = now + 4.0
			_switch_state(AIState.DEFEND)
			_hades_hold(delta, "guard")
			return

	# All three authored attacks require real melee reach. An enemy outside
	# that envelope RUNS toward its engagement destination, without starting
	# an attack or consuming a pressure reservation.
	if _v2_attack_start_eligible(distance) and _can_attack_now(now):
		_try_attack()
		if ai_state == AIState.ATTACK or telegraphing or swinging or _in_running_approach:
			_hades_set_state("attack")
			return

	if distance < attack_start_min_range:
		var away: Vector2 = -direction
		if away.length_squared() < 0.001:
			away = Vector2.RIGHT
		_hades_move_to(delta, global_position + away * 30.0, "step_out")
	elif distance <= HADES_MELEE_REACH:
		_hades_hold(delta, "ready")
	else:
		_hades_move_to(delta, destination, "approach")


var _hades_next_guard_at: float = 0.0


func _hades_melee_plan() -> Dictionary:
	if not is_instance_valid(player):
		return {}
	if not is_instance_valid(_hades_room_coordinator):
		for node: Node in get_tree().get_nodes_in_group("hushiro_melee_surround"):
			if node.get_parent() != null and node.get_parent().is_ancestor_of(self):
				_hades_room_coordinator = node
				break
	if is_instance_valid(_hades_room_coordinator):
		var value: Variant = _hades_room_coordinator.call("plan_for", self, player)
		if value is Dictionary:
			return value as Dictionary
	var radial: Vector2 = global_position - player.global_position
	if radial.length_squared() < 1.0:
		radial = Vector2.RIGHT
	return {"role": "engage", "position": player.global_position + radial.normalized() * 44.0}


func _hades_move_to(delta: float, destination: Vector2, intent_name: String) -> void:
	var offset: Vector2 = destination - global_position
	if offset.length() < HADES_HOLD_DISTANCE:
		_hades_hold(delta, intent_name + "_hold")
		return
	_hades_set_state(intent_name)
	# ONE positional authority: no legacy radial orbit or per-actor
	# _compute_separation force. Physical overlap safety remains room-owned.
	var avoidance: Vector2 = _compute_wall_avoidance()
	velocity = _smooth_velocity(offset.normalized() * approach_speed + avoidance * 0.40 + knockback, delta)


func _hades_hold(delta: float, intent_name: String) -> void:
	_hades_set_state(intent_name)
	velocity = _smooth_velocity(knockback, delta)


func _hades_set_state(next_state: String) -> void:
	if _hades_state == next_state:
		return
	var previous: String = _hades_state
	_hades_state = next_state
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("swordsman_hades_state", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"previous": previous,
			"current": next_state,
			"position": global_position,
		})


func _v2_build_intent_scores(now: float, distance: float) -> Dictionary:
	var posture_ratio: float = _get_humanoid_posture_ratio_safe()
	var another_enemy_active: bool = _is_another_enemy_mid_swing()
	var attack_ready: bool = _v2_attack_temporally_ready(now)
	var guard_ready: bool = _v2_guard_ready(now)
	var time_since_attack: float = maxf(0.0, now - _last_attack_ended_at)
	var pressure_urgency: float = clampf(time_since_attack / maxf(0.25, max_passive_time), 0.0, 1.0)
	pressure_urgency = maxf(pressure_urgency, clampf(_passive_timer / maxf(0.25, max_passive_time), 0.0, 1.0))

	var attack_score: float = -INF
	if attack_ready and _v2_attack_start_eligible(distance):
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
	# The old orbit score won at 60-80 units, preventing the final approach
	# even when NO normal swing could actually reach the player.
	if distance > _v2_reliable_melee_range() and distance < running_min_distance:
		approach_score = maxf(approach_score, strafe_score + 0.18)

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
	# Migrated V2 movement no longer acquires the sticky legacy `advance_move` role.
	# Role-aware room backoff limits close-body occupancy; PressureDirectorV2 separately
	# limits dangerous impact timing. This lets free locomotion remain free locomotion.
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

# The Swordsman now APPROACHES normally and attacks only from authored sword
# reach. Running Swing is retired from automatic engagement/attack selection.
func _v2_reliable_melee_range() -> float:
	return maxf(attack_start_min_range, minf(attack_start_max_range, minf(swipe_range, minf(cross_range, thrust_range))) - 4.0)


func _v2_attack_start_eligible(distance: float) -> bool:
	if distance < attack_start_min_range:
		return false
	return distance <= _v2_reliable_melee_range()


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
	if use_hades_melee_policy:
		_hades_recovery_until = Time.get_ticks_msec() * 0.001 + HADES_POST_ATTACK_HOLD
		_hades_set_state("recover")
		if is_instance_valid(_hades_room_coordinator):
			_hades_room_coordinator.call("attack_completed", self)
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		_v2_enemy_brain.request_immediate_reconsideration()


# =============================================================================
# VALIDATION / TELEMETRY SURFACE
# =============================================================================

func has_v2_enemy_brain_runtime() -> bool:
	return _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain)


func uses_legacy_advance_move_gate() -> bool:
	return false


func get_v2_brain_intent() -> String:
	if _v2_enemy_brain == null or not is_instance_valid(_v2_enemy_brain):
		return "UNAVAILABLE"
	return str(_v2_enemy_brain.current_intent())


func get_v2_brain_scores() -> Dictionary:
	if _v2_enemy_brain == null or not is_instance_valid(_v2_enemy_brain):
		return {}
	return _v2_enemy_brain.last_scores()
