extends Node
class_name PlayerMotor

## Shared Combat V2 player motion resolver.
##
## Input/controller code supplies desired locomotion. CombatActionRunner supplies the
## phase-authored locomotion weight, while the current attack profile may contribute a
## short authored action step. External impulses are composed last. This keeps the
## canonical Player state machine/input/combo path intact while removing the old rule
## that ATTACKING means locomotion is discarded entirely.

var actor: CharacterBody2D = null
var acceleration: float = 5000.0
var deceleration: float = 6600.0
var locomotion_speed_cap: float = 200.0

var _locomotion_velocity: Vector2 = Vector2.ZERO


func configure(
	owner_actor: CharacterBody2D,
	acceleration_value: float,
	deceleration_value: float,
	speed_cap: float
) -> void:
	actor = owner_actor
	acceleration = maxf(1.0, acceleration_value)
	deceleration = maxf(1.0, deceleration_value)
	locomotion_speed_cap = maxf(1.0, speed_cap)
	if actor != null:
		_locomotion_velocity = actor.velocity.limit_length(locomotion_speed_cap)
	_record("combat_v2_player_motor_attached", {
		"acceleration": acceleration,
		"deceleration": deceleration,
		"speed_cap": locomotion_speed_cap,
	})


func resolve_velocity(
	delta: float,
	desired_locomotion: Vector2,
	authored_action_motion: Vector2,
	external_impulse: Vector2,
	action_runner: CombatActionRunner = null,
	locomotion_weight_override: float = -1.0
) -> Vector2:
	var step: float = maxf(0.0, delta)
	var target: Vector2 = desired_locomotion.limit_length(locomotion_speed_cap)
	var accelerating: bool = target.length() > _locomotion_velocity.length()
	if target.length_squared() > 0.001 and _locomotion_velocity.length_squared() > 0.001:
		accelerating = accelerating or target.normalized().dot(_locomotion_velocity.normalized()) > 0.0
	var rate: float = acceleration if accelerating else deceleration
	_locomotion_velocity = _locomotion_velocity.move_toward(target, rate * step)

	var locomotion_weight: float = 1.0
	if action_runner != null and is_instance_valid(action_runner):
		locomotion_weight = action_runner.locomotion_weight()
	if locomotion_weight_override >= 0.0:
		locomotion_weight = clampf(locomotion_weight_override, 0.0, 1.0)

	return (_locomotion_velocity * locomotion_weight) + authored_action_motion + external_impulse


func resolve_dash_velocity(direction: Vector2, speed: float) -> Vector2:
	if direction.length_squared() <= 0.001 or speed <= 0.0:
		return Vector2.ZERO
	return direction.normalized() * speed


func reset_locomotion(value: Vector2 = Vector2.ZERO) -> void:
	_locomotion_velocity = value.limit_length(locomotion_speed_cap)


func locomotion_velocity() -> Vector2:
	return _locomotion_velocity


func _record(event_name: String, extra: Dictionary) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = extra.duplicate(true)
	if actor != null and is_instance_valid(actor):
		payload["actor"] = CombatTelemetry.snapshot_actor(actor)
	CombatTelemetry.record_event(event_name, payload)
