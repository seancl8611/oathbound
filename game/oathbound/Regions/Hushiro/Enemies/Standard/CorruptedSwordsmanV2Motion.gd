extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanStability.gd"

## Combat V2 Phase 2 reference motion layer.
##
## The existing Swordsman attack coroutines still own hitbox spawning, animation,
## AttackDirector tokens, Health/Posture delivery, parry and Deathblow. This layer
## moves commitment/motion permissions into CombatActionRunner and final velocity
## composition into EnemyMotor so attacks no longer rely on a hard stop + constant
## lunge as their only movement language.

const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ENEMY_MOTOR_SCRIPT = preload("res://Core/Combat/EnemyMotor.gd")

const MOTOR_ACCELERATION: float = 820.0
const MOTOR_DECELERATION: float = 1080.0
const MOTOR_SPEED_CAP: float = 380.0

var _v2_action_runner: CombatActionRunner = null
var _v2_enemy_motor: EnemyMotor = null
var _v2_last_motion_physics_frame: int = -1


func _ready() -> void:
	super._ready()
	_install_v2_action_motion_runtime()
	print("[CorruptedSwordsman] v2.4 - CombatActionRunner + EnemyMotor reference slice")


func _install_v2_action_motion_runtime() -> void:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
		if runner_value is CombatActionRunner:
			_v2_action_runner = runner_value as CombatActionRunner
			_v2_action_runner.name = "CombatActionRunner"
			add_child(_v2_action_runner)
			_v2_action_runner.configure(self)
		else:
			push_error("[CorruptedSwordsman] Could not create CombatActionRunner")

	if _v2_enemy_motor == null or not is_instance_valid(_v2_enemy_motor):
		var motor_value: Variant = ENEMY_MOTOR_SCRIPT.new()
		if motor_value is EnemyMotor:
			_v2_enemy_motor = motor_value as EnemyMotor
			_v2_enemy_motor.name = "EnemyMotor"
			add_child(_v2_enemy_motor)
			_v2_enemy_motor.configure(self, MOTOR_ACCELERATION, MOTOR_DECELERATION, MOTOR_SPEED_CAP)
		else:
			push_error("[CorruptedSwordsman] Could not create EnemyMotor")

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("swordsman_v2_action_motor_attached", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"action_runner": _v2_action_runner != null,
			"enemy_motor": _v2_enemy_motor != null,
		})


# =============================================================================
# ACTION LIFECYCLE ADAPTER
# =============================================================================
# The current attack implementations remain intact. Their entry points announce the
# lifecycle to CombatActionRunner so commitment and movement policy stop depending on
# broad booleans such as `telegraphing` and `is_attacking`.

func _start_basic_swing() -> void:
	if not telegraphing and not is_attacking and not _dbroken_active:
		_begin_v2_action(&"basic_swing", telegraph_time, active_window, 0.18, 0.62)
	super._start_basic_swing()


func _perform_basic_swing() -> void:
	_mark_v2_action_active()
	super._perform_basic_swing()


func _start_quick_thrust() -> void:
	if not telegraphing and not is_attacking and not _dbroken_active:
		_begin_v2_action(&"quick_thrust", thrust_telegraph_time, maxf(thrust_lunge_time + 0.08, active_window), 0.22, 0.64)
	super._start_quick_thrust()


func _perform_quick_thrust() -> void:
	_mark_v2_action_active()
	super._perform_quick_thrust()


func _start_cross_swing() -> void:
	if not telegraphing and not is_attacking and not _dbroken_active:
		_begin_v2_action(&"cross_swing", cross_telegraph_time, active_window, 0.26, 0.60)
	super._start_cross_swing()


func _perform_cross_swing_hit(hit_num: int, gen: int) -> void:
	_mark_v2_action_active()
	super._perform_cross_swing_hit(hit_num, gen)


func _start_running_swing() -> void:
	if not telegraphing and not is_attacking and not _dbroken_active:
		var startup: float = maxf(running_telegraph_time, _calculate_approach_time() + running_telegraph_time)
		_begin_v2_action(&"running_swing", startup, active_window, 0.24, 0.78)
	super._start_running_swing()


func _perform_running_swing() -> void:
	_mark_v2_action_active()
	super._perform_running_swing()


func _begin_v2_action(
	action_id: StringName,
	startup_duration: float,
	active_duration: float,
	recovery_duration: float,
	commit_fraction: float
) -> void:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return
	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	if not (definition_value is CombatActionDefinition):
		return
	var definition: CombatActionDefinition = definition_value as CombatActionDefinition
	definition.action_id = action_id
	definition.startup_duration = maxf(0.05, startup_duration)
	definition.active_duration = maxf(0.01, active_duration)
	definition.recovery_duration = maxf(0.0, recovery_duration)
	definition.commit_fraction = clampf(commit_fraction, 0.05, 0.95)

	# Preserve momentum into windup instead of snapping to zero. Commitment and active
	# frames progressively remove free locomotion so late dodges can still create whiffs.
	definition.startup_locomotion_weight = 0.66
	definition.committed_locomotion_weight = 0.18
	definition.active_locomotion_weight = 0.06
	definition.recovery_locomotion_weight = 0.42
	_v2_action_runner.begin(definition)


func _mark_v2_action_active() -> void:
	if _v2_action_runner != null and is_instance_valid(_v2_action_runner):
		_v2_action_runner.mark_active()


func _finish_attack() -> void:
	if _v2_action_runner != null and is_instance_valid(_v2_action_runner):
		_v2_action_runner.complete()
	if _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor):
		_v2_enemy_motor.clear_action_motion()
	super._finish_attack()


func _soft_reset_humanoid_attack_runtime() -> void:
	_interrupt_v2_action_motion("soft_reset")
	super._soft_reset_humanoid_attack_runtime()


func _full_reset_humanoid_attack_runtime() -> void:
	_interrupt_v2_action_motion("full_reset")
	super._full_reset_humanoid_attack_runtime()


func _interrupt_v2_action_motion(reason: String) -> void:
	if _v2_action_runner != null and is_instance_valid(_v2_action_runner):
		_v2_action_runner.interrupt(reason)
	if _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor):
		_v2_enemy_motor.clear_action_motion()
		_v2_enemy_motor.reset_locomotion(Vector2.ZERO)


func _v2_attack_was_committed() -> bool:
	if _v2_action_runner != null and is_instance_valid(_v2_action_runner) and _v2_action_runner.is_running():
		return _v2_action_runner.is_committed()
	return super._v2_attack_was_committed()


# =============================================================================
# ENEMY MOTOR ADAPTER
# =============================================================================

func _smooth_velocity(target: Vector2, delta: float) -> Vector2:
	# EnemyMotor is the sole acceleration/deceleration owner once installed. Returning
	# raw tactical intent here prevents the legacy HFSM smoother and the V2 motor from
	# stacking two unrelated filters.
	if _v2_enemy_motor != null and is_instance_valid(_v2_enemy_motor):
		return target
	return super._smooth_velocity(target, delta)


func _apply_humanoid_lunge(lunge_data: Dictionary, now_s: float) -> void:
	if _v2_enemy_motor == null or not is_instance_valid(_v2_enemy_motor):
		super._apply_humanoid_lunge(lunge_data, now_s)
		return

	# Disable the legacy constant-speed lunge fields. EnemyMotor receives the exact
	# authored direction/speed/duration and turns it into the action-motion component.
	_lunge_dir = Vector2.ZERO
	_lunge_speed = 0.0
	_lunge_until = 0.0

	var direction_value: Variant = lunge_data.get("dir", Vector2.ZERO)
	var direction: Vector2 = direction_value as Vector2 if direction_value is Vector2 else Vector2.ZERO
	var speed: float = float(lunge_data.get("speed", 0.0))
	var duration: float = float(lunge_data.get("time", 0.0))
	_v2_enemy_motor.set_action_motion(direction, speed, duration)


func _update_sprite_facing() -> void:
	# Legacy Swordsman physics invokes this virtual immediately before its final frost
	# multiplier and move_and_slide(). Use that existing seam as the Phase 2 adapter so
	# the imported HFSM can keep producing tactical intent while EnemyMotor owns the
	# actual final velocity composition.
	super._update_sprite_facing()
	_tick_v2_action_motion(get_physics_process_delta_time())


func _tick_v2_action_motion(delta: float) -> void:
	if _v2_enemy_motor == null or not is_instance_valid(_v2_enemy_motor):
		return
	var physics_frame: int = Engine.get_physics_frames()
	if physics_frame == _v2_last_motion_physics_frame:
		return
	_v2_last_motion_physics_frame = physics_frame

	if _v2_action_runner != null and is_instance_valid(_v2_action_runner):
		_v2_action_runner.tick(delta)
		if _attack_recovery:
			_v2_action_runner.mark_recovery()
		elif swinging or (is_attacking and not telegraphing):
			_v2_action_runner.mark_active()

		# Early windup tracks Akio; once the runner crosses its explicit commitment
		# point this snapshot stops updating. The active hitbox therefore uses a late
		# but committed target instead of either full homing or an instant-start snapshot.
		if telegraphing and _v2_action_runner.allows_target_tracking() and is_instance_valid(player):
			_windup_player_pos0 = player.global_position

	var desired_locomotion: Vector2 = velocity - knockback
	velocity = _v2_enemy_motor.resolve_velocity(delta, desired_locomotion, knockback, _v2_action_runner)


# =============================================================================
# VALIDATION / TELEMETRY SURFACE
# =============================================================================

func has_v2_action_motor_runtime() -> bool:
	return (
		_v2_action_runner != null
		and is_instance_valid(_v2_action_runner)
		and _v2_enemy_motor != null
		and is_instance_valid(_v2_enemy_motor)
	)


func get_v2_action_phase() -> String:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return "UNAVAILABLE"
	return _v2_action_runner.phase_name()


func get_v2_action_id() -> String:
	if _v2_action_runner == null or not is_instance_valid(_v2_action_runner):
		return ""
	return str(_v2_action_runner.current_action_id())


func get_v2_motor_locomotion_velocity() -> Vector2:
	if _v2_enemy_motor == null or not is_instance_valid(_v2_enemy_motor):
		return Vector2.ZERO
	return _v2_enemy_motor.locomotion_velocity()
