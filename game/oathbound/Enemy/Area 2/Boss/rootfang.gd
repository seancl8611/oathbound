extends "res://Enemy/Area 2/Boss/rootfang_core.gd"

## September 3 boss-spacing repair layer.
##
## Telemetry from build b920e137 sampled Rootfang repeatedly inside the existing
## authored too_close_threshold, down to roughly 14 px center-to-center. Preserve all
## attack selection/timing and only stop inward body motion once that existing spacing
## boundary has already been crossed.

func _apply_soft_separation() -> void:
	super._apply_soft_separation()

	if _phase == Phase.DEAD or _dbroken_active:
		return

	var current_player: Node = _get_player()
	if current_player == null or not (current_player is Node2D):
		return

	var to_player: Vector2 = (current_player as Node2D).global_position - global_position
	var dist: float = to_player.length()
	var clearance: float = maxf(float(min_separation), float(too_close_threshold))
	if dist <= 0.1 or dist >= clearance:
		return

	var toward_player: Vector2 = to_player.normalized()
	var inward_speed: float = velocity.dot(toward_player)
	if inward_speed > 0.0:
		velocity -= toward_player * inward_speed
	velocity -= toward_player * ((clearance - dist) * 4.0)
