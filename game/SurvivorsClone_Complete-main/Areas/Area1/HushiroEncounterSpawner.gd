extends "res://Areas/Area1/EnemyEncounterSpawner.gd"

## Area 1 spawn-geometry reconciliation.
##
## EnemyEncounterSpawner now assigns position before add_child(), but its ring
## fallback can still produce a point outside the authored RoomBounds and the legacy
## CombatRoom would then clamp the enemy only AFTER _ready(). That leaves humanoid
## patrol/home caches pointing at the wrong location. Hushiro clamps the proposed
## spawn first, before the enemy enters the tree.

const SPAWN_MARGIN: float = 24.0


func _ring_spawn_pos(index: int, count: int) -> Vector2:
	return _clamp_hushiro_spawn(super._ring_spawn_pos(index, count))


func _edge_spawn_pos() -> Vector2:
	return _clamp_hushiro_spawn(super._edge_spawn_pos())


func _clamp_hushiro_spawn(candidate: Vector2) -> Vector2:
	if not _use_spawn_rect or _spawn_rect.size == Vector2.ZERO:
		return candidate

	var min_point: Vector2 = _spawn_rect.position + Vector2.ONE * SPAWN_MARGIN
	var max_point: Vector2 = _spawn_rect.end - Vector2.ONE * SPAWN_MARGIN
	if max_point.x < min_point.x or max_point.y < min_point.y:
		return _spawn_rect.get_center()

	return Vector2(
		clampf(candidate.x, min_point.x, max_point.x),
		clampf(candidate.y, min_point.y, max_point.y)
	)
