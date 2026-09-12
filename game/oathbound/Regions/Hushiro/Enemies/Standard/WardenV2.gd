extends "res://Regions/Hushiro/Enemies/Standard/WardenRules.gd"

## Combat V2 Phase 6 migration for the Hushiro Warden.
##
## WardenRules/WardenController remain authoritative for chain restraint, the timed
## pre-yank parry escape, attack hitboxes, damage, rewards, animation, and death flow.
## This layer moves tactical cadence, action commitment, locomotion composition, Poise,
## short reactive guard behavior, and room-pressure admission onto the shared V2 seams.
## The Warden is a control/support priority target: its heaviness comes from deliberate
## commitment and restraint pressure, not permanent blocking or a second Health bar.

const RESPONSE_RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")
const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ENEMY_MOTOR_SCRIPT = preload("res://Core/Combat/EnemyMotor.gd")
const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")

const WARDEN_BRAIN_INTERVAL: float = 0.22
const WARDEN_BRAIN_MIN_HOLD: float = 0.16
const WARDEN_BRAIN_STICKINESS: float = 0.08
const WARDEN_PRESSURE_RETRY_FLOOR: float = 0.10
const CHAIN_COMMITTED_POISE_REQUIRED: int = 3

var _v2_response: EnemyCombatResponseRuntime = null
var _v2_action_runner: CombatActionRunner = null
var _v2_enemy_motor: EnemyMotor = null
var _v2_enemy_brain: EnemyBrain = null

var _v2_pressure_reservation_id: String = ""
var _v2_pressure_retry_until: float = -1.0


func _ready() -> void:
	super._ready()
	_install_v2_warden_runtime()
	print("[Warden] v2.0 - Combat V2 restraint-pressure migration")


func _install_v2_warden_runtime() -> void:
	var response_value: Variant = RESPONSE_RUNTIME_SCRIPT.new()
	if response_value is EnemyCombatResponseRuntime:
		_v2_response = response_value as EnemyCombatResponseRuntime
		_v2_response.name = "EnemyCombatResponseRuntime"
		add_child(_v2_response)
		_v2_response.configure(self, EnemyCombatResponseProfile.warden_v2())
	else:
		push_error("[WardenV2] Could not create EnemyCombatResponseRuntime")

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	if runner_value is CombatActionRunner:
		_v2_action_runner = runner_value as CombatActionRunner
		_v2_action_runner.name = "CombatActionRunner"
		add_child(_v2_action_runner)
		_v2_action_runner.configure(self)
	else:
		push_error("[WardenV2] Could not create CombatActionRunner")

	var motor_value: Variant = ENEMY_MOTOR_SCRIPT.new()
	if motor_value is EnemyMotor:
		_v2_enemy_motor = motor_value as EnemyMotor
		_v2_enemy_motor.name = "EnemyMotor"
		add_child(_v2_enemy_motor)
		_v2_enemy_motor.configure(self, 460.0, 720.0, maxf(300.0, running_lunge_speed * 1.08))
	else:
		push_error("[WardenV2] Could not create EnemyMotor")

	var brain_value: Variant = ENEMY_BRAIN_SCRIPT.new()
	if brain_value is EnemyBrain:
		_v2_enemy_brain = brain_value as EnemyBrain
		_v2_enemy_brain.name = "EnemyBrain"
		add_child(_v2_enemy_brain)
		_v2_enemy_brain.configure(self, WARDEN_BRAIN_INTERVAL, WARDEN_BRAIN_MIN_HOLD, WARDEN_BRAIN_STICKINESS)
	else:
		push_error("[WardenV2] Could not create EnemyBrain")

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("warden_v2_runtime_attached", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"response": _v2_response != null,
			"action_runner": _v2_action_runner != null,
			"motor": _v2_enemy_motor != null,
			"brain": _v2_enemy_brain != null,
			"pressure": has_v2_warden_pressure_runtime(),
		})


func _physics_process(delta: float) -> void:
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.tick(delta)
	super._physics_process(delta)


# =============================================================================
# CONTROLLED-CADENCE TACTICAL INTENT
# =============================================================================

func _state_engage(delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(WardenState.PATROL)
		_v2_apply_desired_motion(delta, Vector2.ZERO)
		return

	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()
	var dir: Vector2 = to_player.normalized() if dist > 0.001 else Vector2.RIGHT

	if dist > deaggro_radius:
		_saw_player_once = false
		if _v2_enemy_brain != null:
			_v2_enemy_brain.invalidate_intent("deaggro")
		_goto(WardenState.PATROL)
		_v2_apply_desired_motion(delta, Vector2.ZERO)
		return

	if now < _backoff_until:
		if _v2_enemy_brain != null:
			_v2_enemy_brain.set_intent(&"orbit", now, "backoff")
		_v2_apply_desired_motion(delta, _v2_orbit_velocity(dir, 1.0))
		return

	var scores: Dictionary = _v2_warden_intent_scores(now, dist)
	var intent: StringName = &"approach"
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		intent = _v2_enemy_brain.choose_intent(now, scores)

	match intent:
		&"attack":
			if now >= _next_attack_ready and now >= _v2_pressure_retry_until and _can_start_warden_attack(dist):
				_try_start_warden_attack(dist)
				if state == WardenState.WINDUP:
					_v2_apply_desired_motion(delta, Vector2.ZERO)
					return
			_v2_apply_desired_motion(delta, _v2_approach_velocity(dir, dist))
		&"guard":
			_v2_apply_desired_motion(delta, _v2_orbit_velocity(dir, 0.28))
		&"orbit":
			_v2_apply_desired_motion(delta, _v2_orbit_velocity(dir, 1.0))
		&"reposition":
			var desired: Vector2 = -dir * movement_speed * 0.55 + _v2_orbit_velocity(dir, 0.35)
			_v2_apply_desired_motion(delta, desired)
		_:
			_v2_apply_desired_motion(delta, _v2_approach_velocity(dir, dist))


func _v2_warden_intent_scores(now: float, dist: float) -> Dictionary:
	var attack_ready: bool = (
		now >= _next_attack_ready
		and now >= _v2_pressure_retry_until
		and not _restraining
		and _can_start_warden_attack(dist)
	)

	var attack_score: float = -INF
	if attack_ready:
		attack_score = 1.02
		if dist >= 32.0 and dist <= chain_range * 1.05:
			attack_score += 0.14
		if dist > close_combat_range:
			attack_score += 0.08

	var approach_score: float = 0.34
	if dist > hold_distance:
		approach_score += clampf((dist - hold_distance) / 110.0, 0.0, 0.62)
	if dist > attack_start_max_range:
		approach_score += 0.26

	var orbit_score: float = 0.42
	if not attack_ready:
		orbit_score += 0.12
	if dist >= attack_start_min_range and dist <= attack_start_max_range:
		orbit_score += 0.10

	var guard_score: float = -INF
	if _v2_guard_ready(now, dist) and not attack_ready:
		# Guard only fills a short gap between control attempts. It should never outrank a
		# ready restraint/offense decision, preserving the Warden's jailer identity.
		guard_score = 0.68

	var reposition_score: float = 0.12
	if dist < attack_start_min_range:
		reposition_score = 0.88
	elif now < _v2_pressure_retry_until:
		reposition_score = 0.58

	return {
		&"attack": attack_score,
		&"approach": approach_score,
		&"orbit": orbit_score,
		&"guard": guard_score,
		&"reposition": reposition_score,
	}


func _v2_approach_velocity(dir: Vector2, dist: float) -> Vector2:
	if dist > hold_distance:
		return dir * approach_speed
	if dist < attack_start_min_range:
		return -dir * movement_speed * 0.45
	return _v2_orbit_velocity(dir, 0.45)


func _v2_orbit_velocity(dir: Vector2, scale: float) -> Vector2:
	var side_sign: float = -1.0 if (get_instance_id() & 1) == 0 else 1.0
	return Vector2(-dir.y, dir.x) * side_sign * orbit_speed * scale


# =============================================================================
# ENEMY MOTOR COMPOSITION
# =============================================================================

func _state_patrol(delta: float, now: float) -> void:
	super._state_patrol(delta, now)
	_v2_apply_desired_motion(delta, velocity)


func _state_windup(delta: float, _now: float) -> void:
	var desired: Vector2 = Vector2.ZERO
	if is_instance_valid(player) and _v2_action_runner != null and _v2_action_runner.allows_target_tracking():
		var to_player: Vector2 = player.global_position - global_position
		if to_player.length_squared() > 0.001:
			_attack_dir = to_player.normalized()
			if _current_attack == WardenAttack.CHAIN_SWING:
				_chain_target_pos = player.global_position

	if _state_timer <= 0.0:
		_begin_active_attack()
	_v2_apply_desired_motion(delta, desired)


func _state_attack(delta: float, now: float) -> void:
	super._state_attack(delta, now)
	# Authored forward motion is supplied by EnemyMotor action motion. Locomotion stays
	# zero during the strike, so the action runner controls exactly how much body motion
	# survives instead of the legacy state writing velocity directly.
	_v2_apply_desired_motion(delta, Vector2.ZERO)


func _state_recover(delta: float, now: float) -> void:
	var was_recovering: bool = state == WardenState.RECOVER
	super._state_recover(delta, now)
	_v2_apply_desired_motion(delta, Vector2.ZERO)
	if was_recovering and state != WardenState.RECOVER:
		if _v2_action_runner != null and _v2_action_runner.is_running():
			_v2_action_runner.complete()
		if _v2_enemy_brain != null:
			_v2_enemy_brain.request_immediate_reconsideration()


func _v2_apply_desired_motion(delta: float, desired: Vector2) -> void:
	if _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor):
		# WardenController adds shared knockback immediately before move_and_slide(). Keep
		# external impulse out of this call to avoid applying the same knockback twice.
		velocity = _v2_enemy_motor.resolve_velocity(delta, desired, Vector2.ZERO, _v2_action_runner)
	else:
		velocity = desired


# =============================================================================
# PRESSURE ADMISSION + ACTION COMMITMENT
# =============================================================================

func _try_start_warden_attack(dist: float) -> void:
	if not _can_start_warden_attack(dist):
		return
	var chosen: int = _select_warden_attack(dist)
	var now: float = Time.get_ticks_msec() * 0.001
	var admission: Dictionary = _request_v2_warden_pressure(chosen, now)
	if not bool(admission.get("admitted", false)):
		_v2_pressure_retry_until = maxf(
			now + WARDEN_PRESSURE_RETRY_FLOOR,
			float(admission.get("retry_at", now + WARDEN_PRESSURE_RETRY_FLOOR))
		)
		if _v2_enemy_brain != null:
			_v2_enemy_brain.request_immediate_reconsideration()
		return

	_v2_pressure_reservation_id = str(admission.get("reservation_id", ""))
	_v2_pressure_retry_until = -1.0
	_start_warden_attack(chosen)


func _enter_windup(windup_time: float) -> void:
	_begin_v2_warden_action(_current_attack, windup_time)
	super._enter_windup(windup_time)


func _begin_active_attack() -> void:
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.mark_active()
	if _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor):
		var motion_speed: float = running_lunge_speed if _current_attack == WardenAttack.RUNNING_SWING else 70.0
		var motion_time: float = running_lunge_time if _current_attack == WardenAttack.RUNNING_SWING else _get_current_active_time()
		_v2_enemy_motor.set_action_motion(_attack_dir, motion_speed, maxf(0.01, motion_time))
	super._begin_active_attack()


func _finish_warden_attack() -> void:
	_release_v2_warden_pressure("attack_finished")
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.mark_recovery()
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	super._finish_warden_attack()


func _cancel_warden_attack(backoff_time: float = 0.45) -> void:
	_release_v2_warden_pressure("attack_cancelled")
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("attack_cancelled")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	super._cancel_warden_attack(backoff_time)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()


func _begin_v2_warden_action(attack_type: int, windup_time: float) -> void:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (definition_value is CombatActionDefinition):
		return
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	definition.action_id = StringName(_v2_attack_id(attack_type))
	definition.startup_duration = maxf(0.01, windup_time)
	definition.active_duration = maxf(0.01, _v2_active_duration_for(attack_type))
	definition.recovery_duration = maxf(0.0, recover_time)
	definition.commit_fraction = 0.60 if attack_type == WardenAttack.CHAIN_SWING else 0.56
	definition.startup_locomotion_weight = 0.32
	definition.committed_locomotion_weight = 0.10
	definition.active_locomotion_weight = 0.0
	definition.recovery_locomotion_weight = 0.42
	_v2_action_runner.begin(definition)


func _request_v2_warden_pressure(attack_type: int, now: float) -> Dictionary:
	var request: Dictionary = _v2_warden_pressure_request(attack_type, now)
	var director: Node = get_attack_director()
	if director != null and director.has_method("request_pressure_threat"):
		var value: Variant = director.call("request_pressure_threat", self, request)
		if value is Dictionary:
			return value as Dictionary

	# Compatibility only for rooms that have not yet installed PressureDirectorV2.
	if _request_role("melee_attack"):
		has_attack_token = true
		return {
			"admitted": true,
			"reservation_id": "legacy_melee",
			"impact_at": request.get("impact_at", now),
		}
	return {"admitted": false, "retry_at": now + 0.12, "reason": "legacy_melee_denied"}


func _v2_warden_pressure_request(attack_type: int, now: float) -> Dictionary:
	var windup: float = _v2_windup_for(attack_type)
	var active: float = _v2_active_duration_for(attack_type)
	var severity: String = "normal"
	var threat_cost: float = 1.0
	var pressure_channel: String = "melee"

	match attack_type:
		WardenAttack.CHAIN_SWING:
			severity = "perilous"
			threat_cost = 1.50
			pressure_channel = "control"
			# The cast impact is the dangerous collision. Keep the reservation alive through
			# the potential restraint so cleanup cannot expire before the control state ends.
			active = maxf(active, chain_active_time + chain_duration)
		WardenAttack.CROSS_SWING:
			severity = "heavy"
			threat_cost = 1.25
			active = cross_active_time * 2.0 + cross_second_delay
		WardenAttack.RUNNING_SWING:
			severity = "heavy"
			threat_cost = 1.30
		_:
			pass

	return {
		"attack_id": _v2_attack_id(attack_type),
		"pressure_channel": pressure_channel,
		"requested_at": now,
		"impact_at": now + windup,
		"impact_delay": windup,
		"active_duration": active,
		"severity": severity,
		"threat_cost": threat_cost,
	}


func _release_v2_warden_pressure(reason: String) -> void:
	var reservation_id: String = _v2_pressure_reservation_id
	_v2_pressure_reservation_id = ""
	if reservation_id.is_empty():
		return
	if reservation_id == "legacy_melee":
		_release_role("melee_attack")
		has_attack_token = false
		return
	var director: Node = get_attack_director()
	if director != null and director.has_method("release_pressure_threat"):
		director.call("release_pressure_threat", self, reservation_id, reason)


func _v2_attack_id(attack_type: int) -> String:
	match attack_type:
		WardenAttack.CHAIN_SWING:
			return "warden_chain_restrain"
		WardenAttack.QUICK_THRUST:
			return "warden_quick_thrust"
		WardenAttack.CROSS_SWING:
			return "warden_cross_swing"
		WardenAttack.RUNNING_SWING:
			return "warden_running_swing"
		_:
			return "warden_attack"


func _v2_windup_for(attack_type: int) -> float:
	match attack_type:
		WardenAttack.CHAIN_SWING:
			return chain_windup
		WardenAttack.QUICK_THRUST:
			return thrust_windup
		WardenAttack.CROSS_SWING:
			return cross_windup
		WardenAttack.RUNNING_SWING:
			return running_windup
		_:
			return chain_windup


func _v2_active_duration_for(attack_type: int) -> float:
	match attack_type:
		WardenAttack.CHAIN_SWING:
			return chain_active_time
		WardenAttack.QUICK_THRUST:
			return thrust_active_time
		WardenAttack.CROSS_SWING:
			return cross_active_time
		WardenAttack.RUNNING_SWING:
			return running_active_time
		_:
			return chain_active_time


# =============================================================================
# SHORT REACTIVE GUARD
# =============================================================================

func _update_blocking(_delta: float, now: float) -> void:
	if _v2_response == null or not is_instance_valid(_v2_response):
		super._update_blocking(_delta, now)
		return

	var wants_guard: bool = true
	if not can_block or has_died:
		wants_guard = false
	elif telegraphing or is_attacking or state in [WardenState.WINDUP, WardenState.ATTACK, WardenState.STAGGER, WardenState.DEAD]:
		wants_guard = false
	elif ProstheticEffects.is_confused(self) or now < _block_stagger_until:
		wants_guard = false
	elif not is_instance_valid(player):
		wants_guard = false
	elif _v2_enemy_brain == null or _v2_enemy_brain.current_intent() != &"guard":
		wants_guard = false
	else:
		var profile: EnemyCombatResponseProfile = _v2_response.profile
		var guard_range: float = profile.guard_range if profile != null else 68.0
		wants_guard = global_position.distance_to(player.global_position) <= guard_range

	_set_blocking(_v2_response.tick_guard(now, wants_guard))


func _v2_guard_ready(now: float, dist: float) -> bool:
	if _v2_response == null or not can_block or has_died:
		return false
	if telegraphing or is_attacking or state in [WardenState.WINDUP, WardenState.ATTACK, WardenState.STAGGER, WardenState.DEAD]:
		return false
	if now < _block_stagger_until:
		return false
	var profile: EnemyCombatResponseProfile = _v2_response.profile
	var guard_range: float = profile.guard_range if profile != null else 68.0
	if dist > guard_range:
		return false
	return _v2_response.guard_cooldown_remaining(now) <= 0.0


func _on_block_impact(attacker: Variant, is_heavy: bool, response: Dictionary = {}) -> void:
	var decorated: Dictionary = response
	if _v2_response != null:
		decorated = _v2_response.decorate_guard_response(response)
	super._on_block_impact(attacker, is_heavy, decorated)
	if _v2_response != null:
		var broke_guard: bool = _v2_response.on_guard_contact(Time.get_ticks_msec() * 0.001, attacker, decorated)
		if broke_guard:
			_set_blocking(false)


# =============================================================================
# STATEFUL POISE / INTERRUPTION
# =============================================================================

func _on_base_damaged(hp_damage: int, damage_type: String, source: Node, response: Dictionary) -> void:
	if state == WardenState.DEAD or has_died or hp_damage <= 0:
		return

	var committed: bool = _v2_warden_action_committed()
	var should_interrupt: bool = true
	if _v2_response != null:
		should_interrupt = _v2_response.should_interrupt(source, response, committed)
		if committed and _current_attack == WardenAttack.CHAIN_SWING:
			# Once the jailer plants into the identity-defining chain cast, only a truly
			# strong Poise impact cancels it. Health/Posture damage still applies normally.
			var incoming_power: int = _v2_response.incoming_poise_power(source, response)
			should_interrupt = incoming_power >= CHAIN_COMMITTED_POISE_REQUIRED

	if not should_interrupt:
		if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("enemy_v2_hit_absorbed_by_poise", {
				"enemy": CombatTelemetry.snapshot_actor(self),
				"profile": "warden_v2",
				"attack_id": _v2_attack_id(_current_attack),
				"committed": committed,
			})
		return

	_stunned_until = Time.get_ticks_msec() * 0.001 + hurt_stun_time
	if state == WardenState.WINDUP or state == WardenState.ATTACK:
		_cancel_warden_attack(0.25)
	if anim and anim.has_animation("hurt"):
		anim.play("hurt")
		_set_anim_speed_safe(1.0)


func _v2_warden_action_committed() -> bool:
	if _v2_action_runner == null or not _v2_action_runner.is_running():
		return false
	return _v2_action_runner.phase_name() in ["COMMITTED", "ACTIVE"]


# =============================================================================
# CLEANUP
# =============================================================================

func death() -> void:
	_release_v2_warden_pressure("death")
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("death")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	super.death()


func _exit_tree() -> void:
	_release_v2_warden_pressure("exit_tree")
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("exit_tree")
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	super._exit_tree()


# =============================================================================
# VALIDATION SURFACE
# =============================================================================

func has_v2_warden_runtime() -> bool:
	return (
		_v2_response != null and is_instance_valid(_v2_response)
		and _v2_action_runner != null and is_instance_valid(_v2_action_runner)
		and _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor)
		and _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain)
	)


func has_v2_warden_pressure_runtime() -> bool:
	var director: Node = get_attack_director()
	return director != null and director.has_method("request_pressure_threat") and director.has_method("release_pressure_threat")


func get_v2_warden_action_phase() -> String:
	if _v2_action_runner == null:
		return "UNAVAILABLE"
	return _v2_action_runner.phase_name()


func get_v2_warden_intent_scores_for_test(now: float, distance: float) -> Dictionary:
	return _v2_warden_intent_scores(now, distance)


func get_v2_warden_pressure_request_for_test(attack_type: int, now: float) -> Dictionary:
	return _v2_warden_pressure_request(attack_type, now)


func begin_v2_warden_action_for_test(attack_type: int) -> void:
	_current_attack = attack_type
	_begin_v2_warden_action(attack_type, _v2_windup_for(attack_type))


func should_v2_warden_interrupt_for_test(attack_type: int, poise_power: int, committed: bool) -> bool:
	if _v2_response == null:
		return true
	_current_attack = attack_type
	var source := Node.new()
	source.set_meta("poise_damage", maxi(0, poise_power))
	var response: Dictionary = {}
	var result: bool = _v2_response.should_interrupt(source, response, committed)
	if committed and attack_type == WardenAttack.CHAIN_SWING:
		result = _v2_response.incoming_poise_power(source, response) >= CHAIN_COMMITTED_POISE_REQUIRED
	source.free()
	return result


func get_v2_warden_restraint_contract_for_test() -> Dictionary:
	return {
		"chain_break_action": chain_break_action,
		"chain_break_presses": chain_break_presses,
		"chain_duration": chain_duration,
		"restraint_failure_posture": RESTRAINT_FAILURE_POSTURE,
		"restraint_parry_stagger": RESTRAINT_PARRY_STAGGER,
	}


func uses_legacy_warden_melee_role() -> bool:
	return false
