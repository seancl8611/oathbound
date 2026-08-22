extends "res://Core/Encounters/EncounterSpawner.gd"

## Hushiro-specific spawn geometry and standard-enemy contract reconciliation.
##
## Hushiro uses a room-aware safe-spawn allocator instead of trusting the inherited
## group-local ring indices. Each wave gets randomized candidates, minimum separation,
## player clearance, wall/obstacle physics checks, and a deterministic grid fallback.
## This prevents different enemy groups from sharing the same spawn point and keeps
## bodies away from the room walls before their _ready() methods cache home positions.

const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

const SPAWN_WALL_MARGIN: float = 72.0
const SPAWN_PLAYER_CLEARANCE: float = 145.0
const SPAWN_ENEMY_CLEARANCE: float = 82.0
const SPAWN_CLEARANCE_RADIUS: float = 26.0
const SPAWN_BLOCKING_MASK: int = 1
const SPAWN_RANDOM_ATTEMPTS: int = 32
const EDGE_INSET: float = 18.0

var _wave_spawn_positions: Array[Vector2] = []
var _wave_ring_phase: float = 0.0
var _current_wave_index: int = -1


func _ready() -> void:
	super._ready()
	if not enemy_spawned.is_connected(_on_hushiro_enemy_spawned):
		enemy_spawned.connect(_on_hushiro_enemy_spawned)


func _spawn_wave(wave: Dictionary, auto_aggro_on_spawn: bool, wave_index: int) -> void:
	_wave_spawn_positions.clear()
	_wave_ring_phase = randf_range(0.0, TAU)
	_current_wave_index = wave_index
	await super._spawn_wave(wave, auto_aggro_on_spawn, wave_index)


func _ring_spawn_pos(index: int, count: int) -> Vector2:
	var safe_rect: Rect2 = _safe_spawn_rect()
	if safe_rect.size.x <= 0.0 or safe_rect.size.y <= 0.0:
		return _spawn_rect.get_center() if _use_spawn_rect else global_position

	# Use an ellipse fitted to the actual Chamber rather than the inherited 420 px
	# circle, which is taller than Hushiro's current 450 px room and therefore clamps
	# multiple groups onto identical edge coordinates.
	var center: Vector2 = safe_rect.get_center()
	var angle: float = _wave_ring_phase + TAU * (float(index) / float(maxi(1, count)))
	angle += randf_range(-0.18, 0.18)
	var radii := Vector2(safe_rect.size.x * 0.42, safe_rect.size.y * 0.42)
	var candidate := center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y)
	return _allocate_safe_spawn(candidate, "ring")


func _edge_spawn_pos() -> Vector2:
	var safe_rect: Rect2 = _safe_spawn_rect()
	if safe_rect.size.x <= 0.0 or safe_rect.size.y <= 0.0:
		return _spawn_rect.get_center() if _use_spawn_rect else global_position
	return _allocate_safe_spawn(_random_edge_candidate(safe_rect), "edge")


func _allocate_safe_spawn(primary: Vector2, pattern: String) -> Vector2:
	var safe_rect: Rect2 = _safe_spawn_rect()
	if safe_rect.size.x <= 0.0 or safe_rect.size.y <= 0.0:
		return primary

	var candidate: Vector2 = _clamp_to_rect(primary, safe_rect)
	if _spawn_candidate_is_safe(candidate):
		return _register_spawn(candidate, pattern, 0)

	for attempt: int in range(1, SPAWN_RANDOM_ATTEMPTS + 1):
		candidate = _random_edge_candidate(safe_rect) if pattern == "edge" else _random_interior_candidate(safe_rect)
		if _spawn_candidate_is_safe(candidate):
			return _register_spawn(candidate, pattern, attempt)

	candidate = _best_grid_fallback(safe_rect)
	if _physics_clear(candidate):
		push_warning("[HushiroEncounterSpawner] Used grid fallback for wave %d spawn." % _current_wave_index)
		return _register_spawn(candidate, pattern, SPAWN_RANDOM_ATTEMPTS + 1)

	push_warning("[HushiroEncounterSpawner] No fully clear Hushiro spawn candidate; using safest clamped point.")
	return _register_spawn(_clamp_to_rect(primary, safe_rect), pattern, SPAWN_RANDOM_ATTEMPTS + 2)


func _safe_spawn_rect() -> Rect2:
	if not _use_spawn_rect or _spawn_rect.size == Vector2.ZERO:
		return Rect2(global_position - Vector2(320.0, 170.0), Vector2(640.0, 340.0))

	var min_point: Vector2 = _spawn_rect.position + Vector2.ONE * SPAWN_WALL_MARGIN
	var max_point: Vector2 = _spawn_rect.end - Vector2.ONE * SPAWN_WALL_MARGIN
	if max_point.x <= min_point.x or max_point.y <= min_point.y:
		return Rect2(_spawn_rect.get_center(), Vector2.ZERO)
	return Rect2(min_point, max_point - min_point)


func _random_interior_candidate(rect: Rect2) -> Vector2:
	return Vector2(
		randf_range(rect.position.x, rect.end.x),
		randf_range(rect.position.y, rect.end.y)
	)


func _random_edge_candidate(rect: Rect2) -> Vector2:
	var side: int = randi_range(0, 3)
	match side:
		0:
			return Vector2(randf_range(rect.position.x, rect.end.x), rect.position.y + EDGE_INSET)
		1:
			return Vector2(randf_range(rect.position.x, rect.end.x), rect.end.y - EDGE_INSET)
		2:
			return Vector2(rect.position.x + EDGE_INSET, randf_range(rect.position.y, rect.end.y))
		_:
			return Vector2(rect.end.x - EDGE_INSET, randf_range(rect.position.y, rect.end.y))


func _spawn_candidate_is_safe(candidate: Vector2) -> bool:
	var safe_rect: Rect2 = _safe_spawn_rect()
	if not safe_rect.has_point(candidate):
		return false

	if _player != null and is_instance_valid(_player):
		if candidate.distance_to(_player.global_position) < SPAWN_PLAYER_CLEARANCE:
			return false

	for used: Vector2 in _wave_spawn_positions:
		if candidate.distance_to(used) < SPAWN_ENEMY_CLEARANCE:
			return false

	for enemy: Node in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or not (enemy is Node2D):
			continue
		if candidate.distance_to((enemy as Node2D).global_position) < SPAWN_ENEMY_CLEARANCE:
			return false

	return _physics_clear(candidate)


func _physics_clear(candidate: Vector2) -> bool:
	if not is_inside_tree() or get_world_2d() == null:
		return true

	var shape := CircleShape2D.new()
	shape.radius = SPAWN_CLEARANCE_RADIUS
	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, candidate)
	query.collision_mask = SPAWN_BLOCKING_MASK
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var hits: Array[Dictionary] = get_world_2d().direct_space_state.intersect_shape(query, 8)
	return hits.is_empty()


func _best_grid_fallback(rect: Rect2) -> Vector2:
	var best: Vector2 = rect.get_center()
	var best_score: float = -INF
	const COLUMNS: int = 7
	const ROWS: int = 5

	for row: int in range(ROWS):
		for column: int in range(COLUMNS):
			var tx: float = float(column + 1) / float(COLUMNS + 1)
			var ty: float = float(row + 1) / float(ROWS + 1)
			var candidate := Vector2(
				lerpf(rect.position.x, rect.end.x, tx),
				lerpf(rect.position.y, rect.end.y, ty)
			)
			if not _physics_clear(candidate):
				continue

			var score: float = 10000.0
			if _player != null and is_instance_valid(_player):
				score = candidate.distance_to(_player.global_position)
			for used: Vector2 in _wave_spawn_positions:
				score = minf(score, candidate.distance_to(used))
			for enemy: Node in get_tree().get_nodes_in_group("enemy"):
				if is_instance_valid(enemy) and enemy is Node2D:
					score = minf(score, candidate.distance_to((enemy as Node2D).global_position))

			if score > best_score:
				best_score = score
				best = candidate

	return best


func _register_spawn(candidate: Vector2, pattern: String, attempt: int) -> Vector2:
	_wave_spawn_positions.append(candidate)
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hushiro_spawn_allocated", {
			"wave_index": _current_wave_index,
			"pattern": pattern,
			"position": [candidate.x, candidate.y],
			"attempt": attempt,
			"allocated_in_wave": _wave_spawn_positions.size(),
		})
	return candidate


func _clamp_to_rect(candidate: Vector2, rect: Rect2) -> Vector2:
	return Vector2(
		clampf(candidate.x, rect.position.x, rect.end.x),
		clampf(candidate.y, rect.position.y, rect.end.y)
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

	var scene_path: String = enemy.scene_file_path.to_lower()
	var script_path: String = ""
	var script_value: Variant = enemy.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path.to_lower()

	var identity: String = scene_path + "|" + script_path

	if identity.contains("corrupted_swordsman") or identity.contains("corruptedswordsman"):
		return "swordsman"
	if identity.contains("corrupted_archer") or identity.contains("corruptedarcher") or identity.contains("hushiroarcher"):
		return "archer"
	if identity.contains("blighted_hound") or identity.contains("blightedhound"):
		return "hound"
	if identity.contains("cellar_bilemass") or identity.contains("cellarbilemass"):
		return "bilemass"
	if identity.contains("/hollow.tscn") or identity.contains("/hollow.gd"):
		return "hollow"
	if identity.contains("/warden.tscn") or identity.contains("wardenrules") or identity.contains("hushirowarden") or identity.contains("/warden.gd"):
		return "warden"

	return ""
