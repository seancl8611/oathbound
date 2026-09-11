extends "res://Regions/Hushiro/Enemies/Standard/CellarBilemass.gd"

## Combat V2 Phase 6 migration for Cellar Bilemass.
##
## The existing Bilemass remains authoritative for puddle construction, DoT/slow,
## landing indicators, hazard caps, rewards, room geometry, and skitter goal authoring.
## This layer moves spit choice, action commitment, locomotion composition, Poise, and
## room admission onto shared Combat V2 seams. A spit reservation represents the future
## puddle landing, not an enemy turn or an immediate projectile hit.

const RESPONSE_RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")
const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ENEMY_MOTOR_SCRIPT = preload("res://Core/Combat/EnemyMotor.gd")
const ENEMY_BRAIN_SCRIPT = preload("res://Core/Combat/EnemyBrain.gd")

const BILEMASS_BRAIN_INTERVAL: float = 0.20
const BILEMASS_BRAIN_MIN_HOLD: float = 0.14
const BILEMASS_BRAIN_STICKINESS: float = 0.06
const BILEMASS_PRESSURE_RETRY_FLOOR: float = 0.10

var _v2_response: EnemyCombatResponseRuntime = null
var _v2_action_runner: CombatActionRunner = null
var _v2_enemy_motor: EnemyMotor = null
var _v2_enemy_brain: EnemyBrain = null

var _v2_pressure_reservation_id: String = ""
var _v2_pressure_retry_until: float = -1.0
var _v2_spit_target: Vector2 = Vector2.ZERO
var _v2_spit_offset: Vector2 = Vector2.ZERO
var _v2_hazard_launched: bool = false


func _ready() -> void:
	super._ready()
	_install_v2_bilemass_runtime()
	print("[CellarBilemass] v2.0 - Combat V2 hazard-pressure migration")


func _install_v2_bilemass_runtime() -> void:
	var response_value: Variant = RESPONSE_RUNTIME_SCRIPT.new()
	if response_value is EnemyCombatResponseRuntime:
		_v2_response = response_value as EnemyCombatResponseRuntime
		_v2_response.name = "EnemyCombatResponseRuntime"
		add_child(_v2_response)
		_v2_response.configure(self, EnemyCombatResponseProfile.cellar_bilemass_v2())
	else:
		push_error("[CellarBilemassV2] Could not create EnemyCombatResponseRuntime")

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	if runner_value is CombatActionRunner:
		_v2_action_runner = runner_value as CombatActionRunner
		_v2_action_runner.name = "CombatActionRunner"
		add_child(_v2_action_runner)
		_v2_action_runner.configure(self)
	else:
		push_error("[CellarBilemassV2] Could not create CombatActionRunner")

	var motor_value: Variant = ENEMY_MOTOR_SCRIPT.new()
	if motor_value is EnemyMotor:
		_v2_enemy_motor = motor_value as EnemyMotor
		_v2_enemy_motor.name = "EnemyMotor"
		add_child(_v2_enemy_motor)
		_v2_enemy_motor.configure(self, 520.0, 760.0, maxf(120.0, movement_speed * skitter_speed_multiplier * 1.25))
	else:
		push_error("[CellarBilemassV2] Could not create EnemyMotor")

	var brain_value: Variant = ENEMY_BRAIN_SCRIPT.new()
	if brain_value is EnemyBrain:
		_v2_enemy_brain = brain_value as EnemyBrain
		_v2_enemy_brain.name = "EnemyBrain"
		add_child(_v2_enemy_brain)
		_v2_enemy_brain.configure(self, BILEMASS_BRAIN_INTERVAL, BILEMASS_BRAIN_MIN_HOLD, BILEMASS_BRAIN_STICKINESS)
	else:
		push_error("[CellarBilemassV2] Could not create EnemyBrain")

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("bilemass_v2_runtime_attached", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"response": _v2_response != null,
			"action_runner": _v2_action_runner != null,
			"motor": _v2_enemy_motor != null,
			"brain": _v2_enemy_brain != null,
			"pressure": has_v2_bilemass_pressure_runtime(),
		})


func _physics_process(delta: float) -> void:
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.tick(delta)
		if beast_is_attacking and not _v2_hazard_launched and _v2_action_runner.allows_target_tracking():
			_v2_update_spit_target()
	super._physics_process(delta)


# =============================================================================
# SKITTER MOTION THROUGH ENEMY MOTOR
# =============================================================================

func _skitter_combat_move(delta: float, now: float) -> void:
	var ms: float = _ms()
	var to_p: Vector2 = player.global_position - global_position
	var dist: float = to_p.length()
	var dir: Vector2 = to_p / maxf(dist, 0.0001)

	var dist_to_goal: float = global_position.distance_to(_patrol_goal)
	var goal_expired: bool = now >= _next_patrol_repick
	if _last_goal_dist <= 0.001:
		_last_goal_dist = dist_to_goal
	elif dist_to_goal < _last_goal_dist - 2.0:
		_no_progress_time = 0.0
		_last_goal_dist = dist_to_goal
	else:
		_no_progress_time += delta

	if (goal_expired or _no_progress_time > 0.5) and now >= _escape_until:
		_patrol_goal = _choose_skitter_goal(dir, dist)
		_next_patrol_repick = now + randf_range(0.9, 1.3)
		_last_goal_dist = global_position.distance_to(_patrol_goal)
		_no_progress_time = 0.0

	var desired: Vector2 = Vector2.ZERO
	if now < _escape_until:
		desired = _escape_dir * ms
	else:
		desired = (_patrol_goal - global_position).normalized() * ms

	if _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor):
		velocity = _v2_enemy_motor.resolve_velocity(delta, desired, knockback, _v2_action_runner)
	else:
		velocity = velocity.lerp(desired, 0.12) + knockback

	var before: Vector2 = global_position
	move_and_slide()
	var moved: Vector2 = global_position - before
	_last_move_speed = moved.length() / maxf(0.0001, delta)
	_last_move_dir = moved

	var room: Rect2 = _get_room_rect()
	if room.size != Vector2.ZERO and now >= _escape_until:
		var edges: Dictionary = _near_edges(room, 8.0)
		var near_h: bool = bool(edges.get("L", false)) or bool(edges.get("R", false))
		var near_v: bool = bool(edges.get("T", false)) or bool(edges.get("B", false))
		if near_h and near_v:
			_start_corner_escape_by_edges(edges)
		elif get_slide_collision_count() > 0:
			var col: KinematicCollision2D = get_slide_collision(0)
			if col != null:
				_start_escape(col.get_normal(), dir)
				_no_progress_time = 0.0
				_last_goal_dist = global_position.distance_to(_patrol_goal)

	if _no_progress_time > 0.35 and now >= _escape_until:
		_patrol_goal = _choose_skitter_goal(dir, dist)
		_next_patrol_repick = now + randf_range(0.9, 1.3)
		_last_goal_dist = global_position.distance_to(_patrol_goal)
		_no_progress_time = 0.0

	_update_motion_facing(now, moved)
	_ensure_move_anim()


# =============================================================================
# CONTROLLED-CADENCE HAZARD INTENT
# =============================================================================

func _try_spit_from_commit_window(now: float) -> void:
	if beast_is_attacking:
		return
	var scores: Dictionary = _v2_bilemass_intent_scores(now)
	var intent: StringName = &"skitter"
	if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
		intent = _v2_enemy_brain.choose_intent(now, scores)
	if intent == &"spit":
		_perform_spit_tokened()


func _v2_bilemass_intent_scores(now: float) -> Dictionary:
	var can_spit: bool = (
		now >= beast_next_attack_time
		and now >= _v2_pressure_retry_until
		and player_in_range2
		and _active_puddles < int(max_puddles_per_enemy)
		and _room_puddle_count() < int(room_puddle_cap)
		and not _player_hidden_in_smoke()
	)
	var spit_score: float = 1.02 if can_spit else -INF
	if can_spit and _active_puddles == 0:
		spit_score += 0.12
	var skitter_score: float = 0.42
	if not can_spit:
		skitter_score += 0.32
	if now < _v2_pressure_retry_until:
		skitter_score += 0.24
	return {
		&"spit": spit_score,
		&"skitter": skitter_score,
	}


# =============================================================================
# HAZARD PRESSURE + ACTION COMMITMENT
# =============================================================================

func _perform_spit_tokened() -> void:
	if _player_hidden_in_smoke():
		beast_next_attack_time = Time.get_ticks_msec() * 0.001 + 0.25
		return
	if require_melee_pressure and AttackDir != null and AttackDir.has_method("count_role"):
		if int(AttackDir.call("count_role", "melee_attack")) <= 0:
			return

	var now0: float = Time.get_ticks_msec() * 0.001
	if _active_puddles >= int(max_puddles_per_enemy) or _room_puddle_count() >= int(room_puddle_cap):
		beast_next_attack_time = now0 + 0.35
		return

	var admission: Dictionary = _request_v2_bilemass_pressure(now0)
	if not bool(admission.get("admitted", false)):
		_v2_pressure_retry_until = maxf(now0 + BILEMASS_PRESSURE_RETRY_FLOOR, float(admission.get("retry_at", now0 + BILEMASS_PRESSURE_RETRY_FLOOR)))
		if _v2_enemy_brain != null:
			_v2_enemy_brain.request_immediate_reconsideration()
		return

	_v2_pressure_reservation_id = str(admission.get("reservation_id", ""))
	_v2_pressure_retry_until = -1.0
	_v2_hazard_launched = false
	beast_is_attacking = true
	_bump_attack_gen()
	var my_attack_gen: int = _attack_gen
	_begin_v2_spit_action()
	_v2_seed_spit_target()

	_play_anim_exact("attack_windup", spit_windup_duration, true)
	await get_tree().create_timer(spit_windup_duration).timeout
	if not is_inside_tree() or my_attack_gen != _attack_gen:
		return
	if _player_hidden_in_smoke() or not is_instance_valid(player):
		_abort_spit()
		beast_next_attack_time = Time.get_ticks_msec() * 0.001 + 0.35
		return

	var target_pos: Vector2 = _v2_spit_target
	if target_pos == Vector2.ZERO:
		target_pos = _pick_random_target_point(player.global_position)

	if is_instance_valid(_pending_spit_indicator):
		_pending_spit_indicator.queue_free()
	_pending_spit_indicator = _spawn_landing_indicator(target_pos, spit_travel_time)
	_v2_hazard_launched = true
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.mark_active()

	if is_instance_valid(sprite):
		sprite.flip_h = target_pos.x < global_position.x
		_flip_until = Time.get_ticks_msec() * 0.001 + spit_vomit_duration
	_play_anim_exact("shoot", spit_vomit_duration, true)
	await get_tree().create_timer(spit_vomit_duration).timeout
	if not is_inside_tree() or my_attack_gen != _attack_gen:
		return
	_ensure_move_anim()
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.mark_recovery()

	await get_tree().create_timer(spit_travel_time).timeout
	if not is_inside_tree() or my_attack_gen != _attack_gen:
		_abort_spit()
		return

	_spawn_puddle_inline(target_pos)
	var now2: float = Time.get_ticks_msec() * 0.001
	beast_next_attack_time = now2 + randf_range(spit_cd_min, spit_cd_max)
	beast_recovery_until = now2 + beast_recovery_time
	if _v2_action_runner != null and _v2_action_runner.is_running():
		_v2_action_runner.complete()
	_abort_spit()
	if _v2_enemy_brain != null:
		_v2_enemy_brain.request_immediate_reconsideration()


func _begin_v2_spit_action() -> void:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (definition_value is CombatActionDefinition):
		return
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	definition.action_id = &"bilemass_spit"
	definition.startup_duration = maxf(0.01, spit_windup_duration)
	definition.active_duration = maxf(0.01, spit_vomit_duration)
	definition.recovery_duration = maxf(0.0, spit_travel_time)
	definition.commit_fraction = 0.62
	definition.startup_locomotion_weight = 0.58
	definition.committed_locomotion_weight = 0.28
	definition.active_locomotion_weight = 0.18
	definition.recovery_locomotion_weight = 0.92
	_v2_action_runner.begin(definition)


func _v2_seed_spit_target() -> void:
	if not is_instance_valid(player):
		_v2_spit_target = global_position
		_v2_spit_offset = Vector2.ZERO
		return
	_v2_spit_target = _pick_random_target_point(player.global_position)
	_v2_spit_offset = _v2_spit_target - player.global_position


func _v2_update_spit_target() -> void:
	if not is_instance_valid(player):
		return
	var candidate: Vector2 = player.global_position + _v2_spit_offset
	var room: Rect2 = _get_room_rect()
	if room.size != Vector2.ZERO:
		candidate = _clamp_point_to_rect(candidate, room, puddle_radius + 4.0)
	_v2_spit_target = candidate


func _request_v2_bilemass_pressure(now: float) -> Dictionary:
	var request: Dictionary = _v2_bilemass_pressure_request(now)
	if AttackDir != null and AttackDir.has_method("request_pressure_threat"):
		var value: Variant = AttackDir.call("request_pressure_threat", self, request)
		if value is Dictionary:
			return value as Dictionary
	if _request_ranged_role():
		return {"admitted": true, "reservation_id": "legacy_ranged", "impact_at": request.get("impact_at", now)}
	return {"admitted": false, "retry_at": now + 0.12, "reason": "legacy_ranged_denied"}


func _v2_bilemass_pressure_request(now: float) -> Dictionary:
	var impact_delay: float = spit_windup_duration + spit_vomit_duration + spit_travel_time
	return {
		"attack_id": "bilemass_puddle",
		"pressure_channel": "hazard",
		"requested_at": now,
		"impact_at": now + impact_delay,
		"impact_delay": impact_delay,
		"active_duration": 0.50,
		"severity": "heavy",
		"threat_cost": 1.15,
	}


# =============================================================================
# POISE / CLEANUP
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, source: Node, response: Dictionary) -> void:
	if has_died or hp_damage <= 0:
		return
	var committed: bool = _v2_bilemass_action_committed()
	var should_interrupt: bool = true
	if _v2_response != null:
		should_interrupt = _v2_response.should_interrupt(source, response, committed)

	# Once the landing indicator exists, the spit has left the creature. Hits can stagger
	# the shooter but do not retroactively erase already-telegraphed ground pressure.
	if not _v2_hazard_launched and should_interrupt:
		_abort_spit()
		_backoff_until = maxf(_backoff_until, Time.get_ticks_msec() * 0.001 + 0.35)
		play_hurt_animation()
	elif not _v2_hazard_launched and not should_interrupt:
		if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("enemy_v2_hit_absorbed_by_poise", {
				"enemy": CombatTelemetry.snapshot_actor(self),
				"profile": "cellar_bilemass_v2",
				"hazard_launched": false,
			})
	elif _v2_hazard_launched:
		_backoff_until = maxf(_backoff_until, Time.get_ticks_msec() * 0.001 + 0.20)


func _v2_bilemass_action_committed() -> bool:
	if _v2_action_runner == null or not _v2_action_runner.is_running():
		return false
	return _v2_action_runner.phase_name() in ["COMMITTED", "ACTIVE"]


func _abort_spit() -> void:
	_release_v2_bilemass_pressure("spit_end")
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("spit_end")
	_v2_hazard_launched = false
	_v2_spit_target = Vector2.ZERO
	_v2_spit_offset = Vector2.ZERO
	super._abort_spit()


func _release_v2_bilemass_pressure(reason: String) -> void:
	var reservation_id: String = _v2_pressure_reservation_id
	_v2_pressure_reservation_id = ""
	if reservation_id.is_empty():
		return
	if reservation_id == "legacy_ranged":
		_release_ranged_role()
		return
	if AttackDir != null and AttackDir.has_method("release_pressure_threat"):
		AttackDir.call("release_pressure_threat", self, reservation_id, reason)


func death() -> void:
	_release_v2_bilemass_pressure("death")
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("death")
	super.death()


func _exit_tree() -> void:
	_release_v2_bilemass_pressure("exit_tree")
	if _v2_action_runner != null:
		_v2_action_runner.interrupt("exit_tree")
	super._exit_tree()


# =============================================================================
# VALIDATION SURFACE
# =============================================================================

func has_v2_bilemass_runtime() -> bool:
	return (
		_v2_response != null and is_instance_valid(_v2_response)
		and _v2_action_runner != null and is_instance_valid(_v2_action_runner)
		and _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor)
		and _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain)
	)


func has_v2_bilemass_pressure_runtime() -> bool:
	return AttackDir != null and AttackDir.has_method("request_pressure_threat") and AttackDir.has_method("release_pressure_threat")


func get_v2_bilemass_action_phase() -> String:
	if _v2_action_runner == null:
		return "UNAVAILABLE"
	return _v2_action_runner.phase_name()


func get_v2_bilemass_pressure_request_for_test(now: float) -> Dictionary:
	return _v2_bilemass_pressure_request(now)


func get_v2_bilemass_intent_scores_for_test(now: float) -> Dictionary:
	return _v2_bilemass_intent_scores(now)


func uses_legacy_bilemass_ranged_role() -> bool:
	return false
