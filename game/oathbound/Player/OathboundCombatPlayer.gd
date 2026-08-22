extends "res://Player/OathboundAspectPlayerRuntime.gd"

## Final current Player integration layer for the combat-contract stabilization pass.
## Defensive facing follows the same mouse/world aim language as sword attacks instead
## of preserving the last movement vector while Akio stands still and blocks.

const DEFENSIVE_AIM_MIN_DISTANCE: float = 6.0


func _ready() -> void:
	super._ready()
	print("[OathboundCombatPlayer] v1.0 - canonical Aspect Player + defensive aim")


func _start_parry(window_s: float) -> void:
	_update_defensive_facing()
	super._start_parry(window_s)
	_record_guard_aim("parry_open")


func _state_parrying(delta: float) -> void:
	if Input.is_action_pressed("parry"):
		_update_defensive_facing()
	super._state_parrying(delta)


func _state_blocking(delta: float) -> void:
	_update_defensive_facing()
	super._state_blocking(delta)


func _update_defensive_facing() -> void:
	var aim_delta: Vector2 = get_global_mouse_position() - global_position
	if aim_delta.length() < DEFENSIVE_AIM_MIN_DISTANCE:
		return
	var aim_dir: Vector2 = aim_delta.normalized()
	_facing_dir = aim_dir
	_attack_aim_dir = aim_dir
	_update_sprite_facing(aim_dir)


func _record_guard_aim(source: String) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event("player_guard_aim", {
		"source": source,
		"facing": [_facing_dir.x, _facing_dir.y],
		"mouse_world": [get_global_mouse_position().x, get_global_mouse_position().y],
		"player": CombatTelemetry.snapshot_actor(self),
	})
