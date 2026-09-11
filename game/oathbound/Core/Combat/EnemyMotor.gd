extends Node
class_name EnemyMotor

## Shared Combat V2 enemy motion resolver.
##
## The brain/HFSM supplies desired locomotion. CombatActionRunner supplies how much of
## that locomotion survives the current action phase. Authored attack motion and
## external impulses are then composed instead of one state repeatedly overwriting
## CharacterBody2D.velocity.

var actor: CharacterBody2D = null
var acceleration: float = 820.0
var deceleration: float = 1080.0
var locomotion_speed_cap: float = 360.0

var _locomotion_velocity: Vector2 = Vector2.ZERO
var _action_direction: Vector2 = Vector2.ZERO
var _action_speed: float = 0.0
var _action_duration: float = 0.0
var _action_elapsed: float = 0.0


func configure(
	owner_actor: CharacterBody2D,
	acceleration_value: float = 820.0,
	deceleration_value: float = 1080.0,
	speed_cap: float = 360.0
) -> void:
	actor = owner_actor
	acceleration = maxf(1.0, acceleration_value)
	deceleration = maxf(1.0, deceleration_value)
	locomotion_speed_cap = maxf(1.0, speed_cap)
	if actor != null:
		_locomotion_velocity = actor.velocity.limit_length(locomotion_speed_cap)


func resolve_velocity(
	delta: float,
	desired_locomotion: Vector2,
	external_impulse: Vector2,
	action_runner: CombatActionRunner = null
) -> Vector2:
	var step: float = maxf(0.0, delta)
	var target: Vector2 = desired_locomotion.limit_length(locomotion_speed_cap)
	var rate: float = acceleration if target.length() > _locomotion_velocity.length() else deceleration
	_locomotion_velocity = _locomotion_velocity.move_toward(target, rate * step)

	var locomotion_weight: float = 1.0
	if action_runner != null and is_instance_valid(action_runner):
		locomotion_weight = action_runner.locomotion_weight()

	var action_velocity: Vector2 = _sample_action_velocity(step)
	return (_locomotion_velocity * locomotion_weight) + action_velocity + external_impulse


func set_action_motion(direction: Vector2, speed: float, duration: float) -> void:
	if direction.length_squared() <= 0.0001 or speed <= 0.0 or duration <= 0.0:
		clear_action_motion()
		return
	_action_direction = direction.normalized()
	_action_speed = speed
	_action_duration = duration
	_action_elapsed = 0.0
	_record("combat_v2_enemy_action_motion", {
		"speed": speed,
		"duration": duration,
		"direction": [_action_direction.x, _action_direction.y],
	})


func clear_action_motion() -> void:
	_action_direction = Vector2.ZERO
	_action_speed = 0.0
	_action_duration = 0.0
	_action_elapsed = 0.0


func reset_locomotion(value: Vector2 = Vector2.ZERO) -> void:
	_locomotion_velocity = value.limit_length(locomotion_speed_cap)


func locomotion_velocity() -> Vector2:
	return _locomotion_velocity


func has_action_motion() -> bool:
	return _action_duration > 0.0 and _action_elapsed < _action_duration and _action_speed > 0.0


func _sample_action_velocity(delta: float) -> Vector2:
	if not has_action_motion():
		clear_action_motion()
		return Vector2.ZERO

	var progress: float = clampf(_action_elapsed / maxf(0.001, _action_duration), 0.0, 1.0)
	# Preserve approximately the legacy lunge distance while replacing the robotic
	# constant-speed burst with a readable front-loaded step that eases out.
	var eased: float = smoothstep(0.0, 1.0, progress)
	var speed_scale: float = lerpf(1.20, 0.80, eased)
	var result: Vector2 = _action_direction * _action_speed * speed_scale

	_action_elapsed += maxf(0.0, delta)
	if _action_elapsed >= _action_duration:
		# Return this frame's final contribution, then clear for the next frame.
		_action_duration = 0.0
		_action_speed = 0.0
		_action_direction = Vector2.ZERO
		_action_elapsed = 0.0
	return result


func _record(event_name: String, extra: Dictionary) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = extra.duplicate(true)
	if actor != null and is_instance_valid(actor):
		payload["actor"] = CombatTelemetry.snapshot_actor(actor)
	CombatTelemetry.record_event(event_name, payload)
