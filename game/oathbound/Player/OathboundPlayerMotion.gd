extends "res://Player/OathboundPlayer.gd"

## Combat V2 Phase 5 Player motion adapter.
##
## The imported Player controller still owns input, combo selection, canonical sword
## hitboxes/AttackEvent delivery, defense, Techniques, Prosthetics and state timing.
## This layer replaces only motion ownership around attacks: desired locomotion is
## composed with phase-authored action motion through PlayerMotor + CombatActionRunner
## instead of ATTACKING globally discarding movement.

const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const PLAYER_MOTOR_SCRIPT = preload("res://Core/Combat/PlayerMotor.gd")

const ATTACK_HOLD_LOCOMOTION_WEIGHT: float = 0.60
const DEFAULT_STARTUP_TURN_RATE_DEG: float = 900.0

var _v2_player_action_runner: CombatActionRunner = null
var _v2_player_motor: PlayerMotor = null


func _ready() -> void:
	super._ready()
	_install_v2_player_motion_runtime()
	print("[OathboundPlayer] v2.1 - PlayerMotor + CombatActionRunner motion slice")


func _install_v2_player_motion_runtime() -> void:
	if _v2_player_action_runner == null or not is_instance_valid(_v2_player_action_runner):
		var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
		if runner_value is CombatActionRunner:
			_v2_player_action_runner = runner_value as CombatActionRunner
			_v2_player_action_runner.name = "CombatActionRunner"
			add_child(_v2_player_action_runner)
			_v2_player_action_runner.configure(self)
		else:
			push_error("[OathboundPlayerMotion] Could not create CombatActionRunner")

	if _v2_player_motor == null or not is_instance_valid(_v2_player_motor):
		var motor_value: Variant = PLAYER_MOTOR_SCRIPT.new()
		if motor_value is PlayerMotor:
			_v2_player_motor = motor_value as PlayerMotor
			_v2_player_motor.name = "PlayerMotor"
			add_child(_v2_player_motor)
			_v2_player_motor.configure(
				self,
				CURRENT_MOVE_SPEED / maxf(0.001, ACCEL_TIME),
				CURRENT_MOVE_SPEED / maxf(0.001, DECEL_TIME),
				CURRENT_MOVE_SPEED
			)
		else:
			push_error("[OathboundPlayerMotion] Could not create PlayerMotor")

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_v2_action_motor_attached", {
			"player": CombatTelemetry.snapshot_actor(self),
			"action_runner": _v2_player_action_runner != null,
			"player_motor": _v2_player_motor != null,
		})


# =============================================================================
# ACTION LIFECYCLE ADAPTER
# =============================================================================

func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	super._start_profile_attack(profile, combo_idx)
	if _state != State.ATTACKING or _attack_profile.is_empty():
		return
	_begin_v2_player_action(_attack_profile)


func _begin_v2_player_action(profile: Dictionary) -> void:
	if _v2_player_action_runner == null or not is_instance_valid(_v2_player_action_runner):
		return
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (definition_value is CombatActionDefinition):
		return
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition

	var action_id: String = str(profile.get("id", "player_attack"))
	var startup: float = maxf(0.01, float(profile.get("startup", 0.06)))
	var active: float = maxf(0.01, float(profile.get("active", 0.08)))
	var recovery: float = maxf(0.0, float(profile.get("recovery", 0.18)))
	var trigger: String = str(profile.get("action_trigger", "basic"))
	var stagger_level: int = int(profile.get("stagger_level", 0))
	var heavy: bool = stagger_level >= 1 or str(profile.get("hitbox_shape", "")) == "cleave_heavy"

	var commit_fraction: float = 0.70
	var startup_weight: float = 0.86
	var committed_weight: float = 0.50
	var active_weight: float = 0.38
	var recovery_weight: float = 0.76

	# Fast movement-context attacks keep more locomotion. Heavy attacks remain
	# intentionally more planted, preserving physicality without imposing that rule on
	# every sword action.
	if trigger == "dash":
		commit_fraction = 0.78
		startup_weight = 0.96
		committed_weight = 0.72
		active_weight = 0.58
		recovery_weight = 0.84
	elif heavy:
		commit_fraction = 0.62
		startup_weight = 0.68
		committed_weight = 0.28
		active_weight = 0.18
		recovery_weight = 0.58

	# Pale Barrage is explicitly authored as a stationary repeated-jab sequence in the
	# current Aspect layer. Keep that identity until motion permissions move directly
	# into every Aspect profile.
	if action_id == "wraith_pale_barrage":
		startup_weight = 0.0
		committed_weight = 0.0
		active_weight = 0.0
		recovery_weight = 0.0

	definition.action_id = StringName(action_id)
	definition.startup_duration = startup
	definition.active_duration = active
	definition.recovery_duration = recovery
	definition.commit_fraction = clampf(float(profile.get("v2_commit_fraction", commit_fraction)), 0.05, 0.95)
	definition.startup_locomotion_weight = clampf(float(profile.get("v2_startup_locomotion_weight", startup_weight)), 0.0, 1.0)
	definition.committed_locomotion_weight = clampf(float(profile.get("v2_committed_locomotion_weight", committed_weight)), 0.0, 1.0)
	definition.active_locomotion_weight = clampf(float(profile.get("v2_active_locomotion_weight", active_weight)), 0.0, 1.0)
	definition.recovery_locomotion_weight = clampf(float(profile.get("v2_recovery_locomotion_weight", recovery_weight)), 0.0, 1.0)
	_v2_player_action_runner.begin(definition)

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_v2_motion_profile", {
			"player": CombatTelemetry.snapshot_actor(self),
			"action_id": action_id,
			"trigger": trigger,
			"heavy": heavy,
			"commit_fraction": definition.commit_fraction,
			"startup_weight": definition.startup_locomotion_weight,
			"committed_weight": definition.committed_locomotion_weight,
			"active_weight": definition.active_locomotion_weight,
			"recovery_weight": definition.recovery_locomotion_weight,
		})


func _state_attacking(delta: float) -> void:
	if _v2_player_action_runner != null and is_instance_valid(_v2_player_action_runner) and _v2_player_action_runner.is_running():
		if _v2_player_action_runner.allows_target_tracking():
			_v2_update_attack_steering(delta)
		_v2_player_action_runner.tick(delta)

	super._state_attacking(delta)

	if (
		_state == State.ATTACKING
		and _attack_hitbox_active
		and _v2_player_action_runner != null
		and is_instance_valid(_v2_player_action_runner)
		and _v2_player_action_runner.is_running()
	):
		_v2_player_action_runner.mark_active()


func _end_attack() -> void:
	super._end_attack()
	if _v2_player_action_runner != null and is_instance_valid(_v2_player_action_runner) and _v2_player_action_runner.is_running():
		_v2_player_action_runner.mark_recovery()


func _state_attack_recovery(delta: float) -> void:
	super._state_attack_recovery(delta)
	if (
		_v2_player_action_runner != null
		and is_instance_valid(_v2_player_action_runner)
		and _v2_player_action_runner.is_running()
		and _v2_player_action_runner.phase_name() == "RECOVERY"
		and _state != State.ATTACK_RECOVERY
	):
		_v2_player_action_runner.complete()


func _v2_update_attack_steering(delta: float) -> void:
	var target_dir: Vector2 = get_global_mouse_position() - global_position
	if target_dir.length_squared() <= 0.01:
		return
	target_dir = target_dir.normalized()
	var current_dir: Vector2 = _attack_aim_dir.normalized()
	if current_dir.length_squared() <= 0.01:
		current_dir = target_dir
	var turn_rate_deg: float = float(_attack_profile.get("v2_startup_turn_rate_deg", DEFAULT_STARTUP_TURN_RATE_DEG))
	var max_step: float = deg_to_rad(maxf(0.0, turn_rate_deg)) * maxf(0.0, delta)
	var angle_delta: float = wrapf(target_dir.angle() - current_dir.angle(), -PI, PI)
	var next_angle: float = current_dir.angle() + clampf(angle_delta, -max_step, max_step)
	_attack_aim_dir = Vector2(cos(next_angle), sin(next_angle)).normalized()
	_update_sprite_facing(_attack_aim_dir)
	_position_sword_hitbox_for_attack()


# =============================================================================
# PLAYER MOTOR ADAPTER
# =============================================================================

func _calculate_velocity(delta: float) -> void:
	if _v2_player_motor == null or not is_instance_valid(_v2_player_motor):
		super._calculate_velocity(delta)
		return

	_sync_v2_player_action_state()

	var external_impulse: Vector2 = Vector2.ZERO
	if knockback.length() > 1.0:
		external_impulse = knockback
		knockback = knockback.move_toward(Vector2.ZERO, knockback_decay * 100.0 * delta)
	else:
		knockback = Vector2.ZERO

	var final_velocity: Vector2 = Vector2.ZERO
	if _state == State.DODGING:
		# Preserve the current dash's exact authored distance/speed and its existing rule
		# that incoming knockback does not bend the dash trajectory.
		final_velocity = _v2_player_motor.resolve_dash_velocity(_dodge_dir, CURRENT_DASH_SPEED)
	else:
		var desired_locomotion: Vector2 = _v2_desired_locomotion()
		var action_motion: Vector2 = _v2_current_action_motion()
		var weight_override: float = -1.0
		var runner: CombatActionRunner = null

		if _state in [State.ATTACKING, State.ATTACK_RECOVERY]:
			runner = _v2_player_action_runner
		elif _state == State.ATTACK_HOLD:
			weight_override = ATTACK_HOLD_LOCOMOTION_WEIGHT
		elif _state in [State.PARRYING, State.BLOCKING, State.USING_PROSTHETIC]:
			weight_override = 0.0

		final_velocity = _v2_player_motor.resolve_velocity(
			delta,
			desired_locomotion,
			action_motion,
			external_impulse,
			runner,
			weight_override
		)

	velocity = _v2_apply_environment_motion(final_velocity)


func _v2_desired_locomotion() -> Vector2:
	if _state not in [State.IDLE, State.MOVING, State.ATTACK_HOLD, State.ATTACKING, State.ATTACK_RECOVERY, State.DEATHBLOW]:
		return Vector2.ZERO
	if _move_input.length() <= 0.1:
		return Vector2.ZERO
	return _move_input.normalized() * CURRENT_MOVE_SPEED


func _v2_current_action_motion() -> Vector2:
	if _state != State.ATTACKING or not _is_attack_lunge_active():
		return Vector2.ZERO
	var lunge_speed: float = maxf(0.0, float(_attack_profile.get("lunge_speed", 0.0)))
	var lunge_start: float = float(_attack_profile.get("lunge_start", _attack_profile.get("startup", 0.06)))
	var lunge_time: float = maxf(0.001, float(_attack_profile.get("lunge_time", 0.0)))
	var progress: float = clampf((_attack_elapsed - lunge_start) / lunge_time, 0.0, 1.0)
	var eased: float = smoothstep(0.0, 1.0, progress)
	var speed_scale: float = lerpf(1.18, 0.82, eased)
	return _attack_aim_dir.normalized() * lunge_speed * speed_scale


func _v2_apply_environment_motion(input_velocity: Vector2) -> Vector2:
	var result: Vector2 = input_velocity
	if has_meta("puddle_slow_amount"):
		var slow_amount: float = float(get_meta("puddle_slow_amount"))
		if slow_amount > 0.0:
			result *= (1.0 - slow_amount)

	if has_meta("_mist_raven_boost_until"):
		var boost_until: float = float(get_meta("_mist_raven_boost_until"))
		var now_mr: float = Time.get_ticks_msec() * 0.001
		if now_mr < boost_until:
			var boost_amt: float = float(get_meta("_mist_raven_boost", 0.0))
			var remaining: float = boost_until - now_mr
			var decay: float = remaining / 1.2
			result *= (1.0 + boost_amt * decay)
		else:
			remove_meta("_mist_raven_boost")
			remove_meta("_mist_raven_boost_until")
	return result


func _sync_v2_player_action_state() -> void:
	if _v2_player_action_runner == null or not is_instance_valid(_v2_player_action_runner) or not _v2_player_action_runner.is_running():
		return
	if _state in [State.ATTACKING, State.ATTACK_RECOVERY]:
		return
	_v2_player_action_runner.interrupt("player_state_exit")


func _start_dodge() -> void:
	_interrupt_v2_player_action("dash_cancel")
	super._start_dodge()
	if _v2_player_motor != null and is_instance_valid(_v2_player_motor):
		_v2_player_motor.reset_locomotion(Vector2.ZERO)


func _start_parry(window_s: float) -> void:
	_interrupt_v2_player_action("parry_cancel")
	super._start_parry(window_s)


func _posture_break() -> void:
	_interrupt_v2_player_action("posture_break")
	super._posture_break()


func _interrupt_v2_player_action(reason: String) -> void:
	if _v2_player_action_runner != null and is_instance_valid(_v2_player_action_runner):
		_v2_player_action_runner.interrupt(reason)


# =============================================================================
# VALIDATION / TELEMETRY SURFACE
# =============================================================================

func has_v2_player_action_motor_runtime() -> bool:
	return (
		_v2_player_action_runner != null
		and is_instance_valid(_v2_player_action_runner)
		and _v2_player_motor != null
		and is_instance_valid(_v2_player_motor)
	)


func get_v2_player_action_phase() -> String:
	if _v2_player_action_runner == null or not is_instance_valid(_v2_player_action_runner):
		return "UNAVAILABLE"
	return _v2_player_action_runner.phase_name()


func get_v2_player_locomotion_velocity() -> Vector2:
	if _v2_player_motor == null or not is_instance_valid(_v2_player_motor):
		return Vector2.ZERO
	return _v2_player_motor.locomotion_velocity()


func get_playtest_snapshot() -> Dictionary:
	var snapshot: Dictionary = super.get_playtest_snapshot()
	snapshot["v2_player_motion"] = has_v2_player_action_motor_runtime()
	snapshot["v2_action_phase"] = get_v2_player_action_phase()
	var locomotion: Vector2 = get_v2_player_locomotion_velocity()
	snapshot["v2_locomotion_velocity"] = [locomotion.x, locomotion.y]
	return snapshot
