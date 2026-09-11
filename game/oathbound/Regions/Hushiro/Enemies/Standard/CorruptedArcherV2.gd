extends "res://Regions/Hushiro/Enemies/Standard/CorruptedArcherRules.gd"

## Combat V2 Phase 6 migration for the Corrupted Archer.
##
## The current Archer controller remains authoritative for projectile construction,
## predictive-aim math, wall avoidance, animations, rewards, weak reactive guard, and
## Hushiro Posture/Deathblow. This layer replaces frame-by-frame tactical selection and
## legacy ranged-role admission with controlled EnemyBrain intent, explicit bow-action
## commitment, EnemyMotor phase weighting, Poise interruption, and a predicted spatial
## pressure reservation that survives until the arrow's expected impact window.

const RESPONSE_RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")
const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ENEMY_MOTOR_SCRIPT = preload("res://Core/Combat/EnemyMotor.gd")
const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")

const ARCHER_BRAIN_INTERVAL: float = 0.18
const ARCHER_BRAIN_MIN_HOLD: float = 0.14
const ARCHER_BRAIN_STICKINESS: float = 0.08
const ARCHER_PRESSURE_RETRY_FLOOR: float = 0.08

var _v2_response: EnemyCombatResponseRuntime = null
var _v2_action_runner: CombatActionRunner = null
var _v2_enemy_motor: EnemyMotor = null
var _v2_enemy_brain: EnemyBrain = null

var _v2_pressure_reservation_id: String = ""
var _v2_pressure_retry_until: float = -1.0
var _v2_projectile_launched: bool = false
var _v2_locked_target_pos: Vector2 = Vector2.ZERO


func _ready() -> void:
	super._ready()
	_install_v2_archer_runtime()
	print("[CorruptedArcher] v5.0 - Combat V2 ranged/spatial-pressure migration")


func _install_v2_archer_runtime() -> void:
	var response_value: Variant = RESPONSE_RUNTIME_SCRIPT.new()
	if response_value is EnemyCombatResponseRuntime:
		_v2_response = response_value as EnemyCombatResponseRuntime
		_v2_response.name = "EnemyCombatResponseRuntime"
		add_child(_v2_response)
		_v2_response.configure(self, EnemyCombatResponseProfile.corrupted_archer_v2())
	else:
		push_error("[CorruptedArcherV2] Could not create EnemyCombatResponseRuntime")

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	if runner_value is CombatActionRunner:
		_v2_action_runner = runner_value as CombatActionRunner
		_v2_action_runner.name = "CombatActionRunner"
		add_child(_v2_action_runner)
		_v2_action_runner.configure(self)
	else:
		push_error("[CorruptedArcherV2] Could not create CombatActionRunner")

	var motor_value: Variant = ENEMY_MOTOR_SCRIPT.new()
	if motor_value is EnemyMotor:
		_v2_enemy_motor = motor_value as EnemyMotor
		_v2_enemy_motor.name = "EnemyMotor"
		add_child(_v2_enemy_motor)
		_v2_enemy_motor.configure(self, 620.0, 900.0, maxf(90.0, movement_speed * 1.65))
	else:
		push_error("[CorruptedArcherV2] Could not create EnemyMotor")

	var brain_value: Variant = ENEMY_BRAIN_SCRIPT.new()
	if brain_value is EnemyBrain:
		_v2_enemy_brain = brain_value as EnemyBrain
		_v2_enemy_brain.name = "EnemyBrain"
		add_child(_v2_enemy_brain)
		_v2_enemy_brain.configure(self, ARCHER_BRAIN_INTERVAL, ARCHER_BRAIN_MIN_HOLD, ARCHER_BRAIN_STICKINESS)
	else:
		push_error("[CorruptedArcherV2] Could not create EnemyBrain")

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("archer_v2_runtime_attached", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"response": _v2_response != null,
			"action_runner": _v2_action_runner != null,
			"motor": _v2_enemy_motor != null,
			"brain": _v2_enemy_brain != null,
			"pressure": has_v2_archer_pressure_runtime(),
		})


# =============================================================================
# CONTROLLED-CADENCE RANGED INTENT
# =============================================================================

func _process_engage_state(dist: float, dir: Vector2, player_charging: bool, now: float) -> void:
	if player_charging and dist < optimal_range_min:
		_change_state(ArcherState.BACKOFF)
		return
	if dist < min_range - RANGE_HYSTERESIS:
		_change_state(ArcherState.BACKOFF)
		return

	var scores: Dictionary = _v2_archer_intent_scores(now, dist)
	var intent: StringName = &"hold"
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		intent = _v2_enemy_brain.choose_intent(now, scores)

	match intent:
		&"shoot":
			if _can_shoot(dist < optimal_range_min):
				if dist < optimal_range_min:
					set_meta("kite_shot", true)
				elif has_meta("kite_shot"):
					remove_meta("kite_shot")
				_change_state(ArcherState.AIM)
				return
			_v2_set_archer_motion(dir * movement_speed * 0.28)
		&"retreat":
			_v2_set_archer_motion(-dir * movement_speed * 0.72)
		&"reposition":
			_change_state(ArcherState.REPOSITION)
		&"approach":
			_v2_set_archer_motion(dir * movement_speed * (0.72 if dist > max_range else 0.52))
		_:
			_v2_set_archer_motion(Vector2.ZERO)


func _v2_archer_intent_scores(now: float, distance: float) -> Dictionary:
	var shot_ready: bool = now >= _v2_pressure_retry_until and _can_shoot(distance < optimal_range_min)
	var in_good_range: bool = distance >= optimal_range_min - RANGE_HYSTERESIS and distance <= optimal_range_max + RANGE_HYSTERESIS

	var shoot_score: float = -INF
	if shot_ready and distance >= 18.0 and distance <= max_range:
		shoot_score = 0.82
		if in_good_range:
			shoot_score += 0.32
		elif distance < optimal_range_min:
			shoot_score += 0.12
		else:
			shoot_score -= 0.12

	var retreat_score: float = 0.08
	if distance < min_range:
		retreat_score = 1.18
	elif distance < optimal_range_min:
		retreat_score = 0.62

	var approach_score: float = 0.12
	if distance > optimal_range_max:
		approach_score = 0.58 + clampf((distance - optimal_range_max) / 100.0, 0.0, 0.45)

	var reposition_score: float = 0.24
	if in_good_range and not shot_ready:
		reposition_score += 0.34
	if now < _v2_pressure_retry_until:
		reposition_score += 0.34
	if now - _last_reposition_time > reposition_interval:
		reposition_score += 0.12

	var hold_score: float = 0.18
	if in_good_range:
		hold_score += 0.18

	return {
		&"shoot": shoot_score,
		&"retreat": retreat_score,
		&"approach": approach_score,
		&"reposition": reposition_score,
		&"hold": hold_score,
	}


func _run_state_machine(delta: float) -> void:
	# Advance the action clock before the inherited state transition so commitment can
	# freeze aim on the exact frame the bow becomes committed.
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.tick(delta)
		if _state == ArcherState.AIM and _v2_action_runner.allows_target_tracking():
			_v2_locked_target_pos = _v2_predicted_target_pos()

	super._run_state_machine(delta)

	# Preserve the Archer's authored wall avoidance and movement targets, but route the
	# final desired locomotion through EnemyMotor so action-phase mobility is explicit.
	if _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor):
		_target_velocity = _v2_enemy_motor.resolve_velocity(delta, _target_velocity, Vector2.ZERO, _v2_action_runner)


func _v2_set_archer_motion(desired: Vector2) -> void:
	_target_velocity = desired
	_last_movement_decision = "v2"
	if desired.length() > 5.0:
		_movement_commit_timer = MIN_MOVEMENT_COMMIT_TIME


# =============================================================================
# SPATIAL PRESSURE ADMISSION + BOW ACTION
# =============================================================================

func _start_aim() -> void:
	var now: float = Time.get_ticks_msec() * 0.001
	var admission: Dictionary = _request_v2_archer_pressure(now)
	if not bool(admission.get("admitted", false)):
		_v2_pressure_retry_until = maxf(now + ARCHER_PRESSURE_RETRY_FLOOR, float(admission.get("retry_at", now + ARCHER_PRESSURE_RETRY_FLOOR)))
		telegraphing = false
		is_attacking = false
		_hide_parry_indicator()
		if _v2_enemy_brain != null:
			_v2_enemy_brain.request_immediate_reconsideration()
		_change_state(ArcherState.REPOSITION)
		return

	_v2_pressure_reservation_id = str(admission.get("reservation_id", ""))
	_v2_pressure_retry_until = -1.0
	_v2_projectile_launched = false
	_v2_locked_target_pos = _v2_predicted_target_pos()
	_begin_v2_archer_action()

	telegraphing = true
	if not _is_kite_shot():
		_target_velocity = Vector2.ZERO
	_show_parry_indicator(aim_duration, false)

	if anim and anim.has_animation("attack_windup"):
		anim.play("attack_windup")
		var base_len: float = anim.get_animation("attack_windup").length
		anim.speed_scale = base_len / maxf(0.001, aim_duration)

	if is_instance_valid(player) and is_instance_valid(sprite):
		var to_player: Vector2 = player.global_position - global_position
		sprite.flip_h = to_player.x < 0.0

	if _v2_enemy_brain != null:
		_v2_enemy_brain.set_intent(&"shoot", now, "spatial_pressure_admitted")


func _begin_v2_archer_action() -> void:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (definition_value is CombatActionDefinition):
		return
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	definition.action_id = &"archer_shot"
	definition.startup_duration = maxf(0.01, aim_duration)
	definition.active_duration = maxf(0.01, shoot_duration)
	definition.recovery_duration = maxf(0.0, recover_duration)
	definition.commit_fraction = 0.62
	definition.startup_locomotion_weight = 0.72 if _is_kite_shot() else 0.18
	definition.committed_locomotion_weight = 0.58 if _is_kite_shot() else 0.06
	definition.active_locomotion_weight = 0.72 if _is_kite_shot() else 0.04
	definition.recovery_locomotion_weight = 0.88
	_v2_action_runner.begin(definition)


func _request_v2_archer_pressure(now: float) -> Dictionary:
	# If the prior projectile window has naturally expired, forget the local handle.
	if not _v2_pressure_reservation_id.is_empty() and _v2_pressure_reservation_id != "legacy_ranged":
		if AttackDir != null and AttackDir.has_method("has_pressure_reservation") and not bool(AttackDir.call("has_pressure_reservation", self)):
			_v2_pressure_reservation_id = ""

	var request: Dictionary = _v2_archer_pressure_request(now)
	if AttackDir != null and AttackDir.has_method("request_pressure_threat"):
		var value: Variant = AttackDir.call("request_pressure_threat", self, request)
		if value is Dictionary:
			return value as Dictionary

	# Isolated-scene compatibility only. Production uses PressureDirectorV2.
	if _request_role("ranged_attack"):
		has_attack_token = true
		return {"admitted": true, "reservation_id": "legacy_ranged", "impact_at": request.get("impact_at", now)}
	return {"admitted": false, "retry_at": now + 0.12, "reason": "legacy_ranged_denied"}


func _v2_archer_pressure_request(now: float) -> Dictionary:
	var distance: float = global_position.distance_to(player.global_position) if is_instance_valid(player) else optimal_range_max
	var shot_speed: float = maxf(projectile_speed, 220.0)
	var flight_time: float = clampf(distance / maxf(1.0, shot_speed), 0.08, 1.15)
	var impact_delay: float = aim_duration + flight_time
	return {
		"attack_id": "archer_arrow",
		"pressure_channel": "ranged",
		"requested_at": now,
		"impact_at": now + impact_delay,
		"impact_delay": impact_delay,
		"active_duration": 0.14,
		"severity": "normal",
		"threat_cost": 0.65,
	}


func _fire_arrow() -> void:
	telegraphing = false
	is_attacking = true
	_v2_projectile_launched = true
	if _v2_action_runner != null:
		_v2_action_runner.mark_active()

	if is_instance_valid(player) and is_instance_valid(sprite):
		var to_player: Vector2 = player.global_position - global_position
		sprite.flip_h = to_player.x < 0.0

	if anim and anim.has_animation("shoot"):
		anim.play("shoot")
		var base_len: float = anim.get_animation("shoot").length
		anim.speed_scale = base_len / maxf(0.001, shoot_duration)
	_hide_parry_indicator()

	if projectile_scene and is_instance_valid(player):
		var shot_speed: float = maxf(projectile_speed, 220.0)
		var target_pos: Vector2 = _v2_locked_target_pos
		if target_pos == Vector2.ZERO:
			target_pos = _v2_predicted_target_pos()
		var dir: Vector2 = (target_pos - global_position).normalized()
		if dir.length_squared() <= 0.001:
			dir = Vector2.RIGHT

		var p: Node = projectile_scene.instantiate()
		if p is Node2D:
			(p as Node2D).rotation = dir.angle()
		p.set_meta("shooter_id", get_instance_id())
		p.set_meta("shooter", self)
		p.set_meta("faction", "enemy")
		p.set_meta("attacker", self)
		p.set_meta("parryable", true)
		p.set_meta("damage", projectile_damage)
		if p is Area2D:
			(p as Area2D).collision_layer = 2
			(p as Area2D).collision_mask = 2
		if p.has_method("launch"):
			p.call("launch", dir, shot_speed, projectile_damage)
		elif p.has_method("initialize"):
			p.call("initialize", dir, shot_speed, projectile_damage)

		var scene_root: Node = get_tree().current_scene
		if scene_root == null:
			scene_root = get_parent()
		if scene_root != null:
			scene_root.add_child(p)
			if p is Node2D:
				(p as Node2D).global_position = global_position
			_active_projectiles.append(p)
			_shots_fired += 1
		else:
			p.queue_free()

	var now: float = Time.get_ticks_msec() * 0.001
	next_swipe_time = now + shot_cooldown + randf_range(-0.5, 0.5)
	get_tree().create_timer(shoot_duration).timeout.connect(_release_archer_token)


func _v2_predicted_target_pos() -> Vector2:
	if not is_instance_valid(player):
		return global_position + Vector2.RIGHT * optimal_range_min
	var shot_speed: float = maxf(projectile_speed, 220.0)
	return _get_predicted_target_pos(global_position, player.global_position, shot_speed)


func _release_archer_token() -> void:
	is_attacking = false
	telegraphing = false
	# An admitted ranged threat remains reserved after release animation so the room
	# scheduler still accounts for the arrow while it is travelling toward Akio.
	if not _v2_projectile_launched:
		_release_v2_archer_pressure("aim_cancelled", true)
	if has_attack_token:
		_release_role("ranged_attack")
		has_attack_token = false
	_set_anim_speed_safe(1.0)


func _change_state(new_state: ArcherState) -> void:
	var previous: ArcherState = _state
	super._change_state(new_state)
	if _state != new_state:
		return
	if new_state == ArcherState.RECOVER and _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.mark_recovery()
	elif previous == ArcherState.RECOVER and new_state != ArcherState.RECOVER:
		if _v2_action_runner != null and _v2_action_runner.is_running():
			_v2_action_runner.complete()
		if _v2_enemy_brain != null:
			_v2_enemy_brain.request_immediate_reconsideration()


# =============================================================================
# LOW-POISE RANGED RESPONSE
# =============================================================================

func _on_archer_hurt(_damage: int, _damage_type: String, attacker: Node = null) -> void:
	if has_died:
		return
	var now: float = Time.get_ticks_msec() * 0.001
	_backoff_until = now + 1.2

	var committed: bool = _v2_archer_action_committed()
	var should_interrupt: bool = true
	if _v2_response != null:
		should_interrupt = _v2_response.should_interrupt(attacker, {}, committed)

	if _state in [ArcherState.AIM, ArcherState.SHOOT] and should_interrupt:
		_interrupt_v2_archer_action(now, "poise_interrupt")
		return
	if _state not in [ArcherState.AIM, ArcherState.SHOOT]:
		_change_state(ArcherState.BACKOFF)


func _v2_archer_action_committed() -> bool:
	if _v2_action_runner == null or not _v2_action_runner.is_running():
		return false
	return _v2_action_runner.phase_name() in ["COMMITTED", "ACTIVE"]


func _interrupt_v2_archer_action(now: float, reason: String) -> void:
	if not _v2_projectile_launched:
		_release_v2_archer_pressure(reason, true)
	_release_archer_token()
	_hide_parry_indicator()
	if _v2_enemy_motor != null:
		_v2_enemy_motor.clear_action_motion()
	if _v2_action_runner != null:
		_v2_action_runner.interrupt(reason)
	_backoff_until = maxf(_backoff_until, now + 0.8)
	_change_state(ArcherState.BACKOFF)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.set_intent(&"retreat", now, reason)


func on_parried(player_pos: Vector2) -> void:
	var was_bow_action: bool = _state in [ArcherState.AIM, ArcherState.SHOOT]
	if was_bow_action and not _v2_projectile_launched:
		_release_v2_archer_pressure("parried", true)
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("parried")
	super.on_parried(player_pos)
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()


# =============================================================================
# PRESSURE CLEANUP / VALIDATION
# =============================================================================

func _release_v2_archer_pressure(reason: String, force_launched: bool = false) -> void:
	if _v2_projectile_launched and not force_launched:
		return
	var reservation_id: String = _v2_pressure_reservation_id
	_v2_pressure_reservation_id = ""
	if reservation_id.is_empty():
		return
	if reservation_id == "legacy_ranged":
		_release_role("ranged_attack")
		has_attack_token = false
		return
	if AttackDir != null and AttackDir.has_method("release_pressure_threat"):
		AttackDir.call("release_pressure_threat", self, reservation_id, reason)


func death() -> void:
	_release_v2_archer_pressure("death", true)
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("death")
	super.death()


func _exit_tree() -> void:
	_release_v2_archer_pressure("exit_tree", true)
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("exit_tree")
	super._exit_tree()


func has_v2_archer_runtime() -> bool:
	return (
		_v2_response != null and is_instance_valid(_v2_response)
		and _v2_action_runner != null and is_instance_valid(_v2_action_runner)
		and _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor)
		and _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain)
	)


func has_v2_archer_pressure_runtime() -> bool:
	return AttackDir != null and AttackDir.has_method("request_pressure_threat") and AttackDir.has_method("release_pressure_threat")


func get_v2_archer_action_phase() -> String:
	if _v2_action_runner == null:
		return "UNAVAILABLE"
	return _v2_action_runner.phase_name()


func get_v2_archer_intent() -> String:
	if _v2_enemy_brain == null:
		return "UNAVAILABLE"
	return str(_v2_enemy_brain.current_intent())


func get_v2_archer_pressure_request_for_test(now: float) -> Dictionary:
	return _v2_archer_pressure_request(now)


func uses_legacy_archer_ranged_role() -> bool:
	return false
