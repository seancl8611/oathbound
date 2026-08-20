extends "res://Areas/Area1/EnemyEncounterSpawner.gd"

## Area 1 spawn-geometry and enemy-contract reconciliation.
##
## EnemyEncounterSpawner assigns position before add_child(), but its ring fallback can
## still produce a point outside authored RoomBounds and the legacy CombatRoom would
## then clamp the enemy only AFTER _ready(). Hushiro clamps the proposed spawn first.
##
## The inherited spawner emits enemy_spawned after _ready() has run. We use that exact
## point to normalize Hushiro durability/Posture so stale imported controller defaults
## or Inspector values cannot overwrite the approved first-playtest contract.

const SPAWN_MARGIN: float = 24.0
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")


func _ready() -> void:
	super._ready()
	if not enemy_spawned.is_connected(_on_hushiro_enemy_spawned):
		enemy_spawned.connect(_on_hushiro_enemy_spawned)


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


func _on_hushiro_enemy_spawned(enemy: Node) -> void:
	var enemy_type: String = _infer_hushiro_enemy_type(enemy)
	if enemy_type.is_empty():
		push_warning("[HushiroEncounterSpawner] Could not infer Hushiro contract for %s" % str(enemy))
		return
	HUSHIRO_ENEMY_CONTRACT.apply(enemy, enemy_type)


func _infer_hushiro_enemy_type(enemy: Node) -> String:
	if enemy == null:
		return ""

	var script_value: Variant = enemy.get_script()
	var script_path: String = ""
	if script_value is Script:
		script_path = (script_value as Script).resource_path.to_lower()

	if script_path.contains("corruptedswordsmancontroller") or script_path.contains("corrupted_swordsman"):
		return "swordsman"
	if script_path.contains("corrupted_archer"):
		return "archer"
	if script_path.contains("blighted_hound"):
		return "hound"
	if script_path.contains("cellar_bilemass"):
		return "bilemass"
	if script_path.contains("hollow.gd"):
		return "hollow"
	if script_path.contains("warden.gd"):
		return "warden"

	return ""
