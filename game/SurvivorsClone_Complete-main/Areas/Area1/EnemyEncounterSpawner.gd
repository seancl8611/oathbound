extends Node2D

signal encounter_started
signal encounter_cleared
signal enemy_spawned(enemy: Node)

# Hushiro first-playtest encounter pacing.
@export var opener_delay: float = 0.3
@export var wave_clear_delay: float = 0.9
@export var group_spacing: float = 0.25
@export var unit_stagger: float = 0.04
@export var active_cap: int = 6

# Spawn geometry.
@export var ring_radius: float = 420.0
@export var edge_multiplier_min: float = 1.1
@export var edge_multiplier_max: float = 1.4

var _player: Node2D = null
var _running: bool = false
var _alive: int = 0
var _waves: Array = []
var _encounter_hint: Dictionary = {}

var _spawn_rect: Rect2 = Rect2()
var _use_spawn_rect: bool = false


func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player") as Node2D


func is_running() -> bool:
	return _running


func start_template(template: Dictionary, area_id: int = 1) -> void:
	if _running:
		return
	_running = true
	_encounter_hint = template.duplicate(true)
	_alive = 0
	_waves = _resolve_template(template, area_id)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("encounter_start", {
			"area_id": area_id,
			"encounter_id": str(template.get("id", "")),
			"wave_count": _waves.size(),
		})

	emit_signal("encounter_started")
	await _run_authored_waves()

	_running = false
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("encounter_clear", {
			"area_id": area_id,
			"encounter_id": str(template.get("id", "")),
		})
	emit_signal("encounter_cleared")


func _resolve_template(template: Dictionary, area_id: int) -> Array:
	var type_map: Dictionary = {}
	var registry: Node = get_node_or_null("/root/SceneRegistry")
	if registry != null:
		var enemy_maps_value: Variant = registry.get("enemies_by_area")
		if typeof(enemy_maps_value) == TYPE_DICTIONARY:
			var enemy_maps: Dictionary = enemy_maps_value as Dictionary
			var area_map_value: Variant = enemy_maps.get(area_id, {})
			if typeof(area_map_value) == TYPE_DICTIONARY:
				type_map = area_map_value as Dictionary

	var resolved: Array = []
	var waves_value: Variant = template.get("waves", [])
	if typeof(waves_value) != TYPE_ARRAY:
		return resolved
	var waves: Array = waves_value as Array

	for wave_value: Variant in waves:
		if typeof(wave_value) != TYPE_DICTIONARY:
			continue
		var wave: Dictionary = wave_value as Dictionary
		var groups_value: Variant = wave.get("groups", [])
		if typeof(groups_value) != TYPE_ARRAY:
			continue
		var groups_in: Array = groups_value as Array
		var groups_out: Array = []

		for group_value: Variant in groups_in:
			if typeof(group_value) != TYPE_DICTIONARY:
				continue
			var group: Dictionary = group_value as Dictionary
			var type_name: String = str(group.get("type", ""))
			var count: int = int(group.get("count", 1))
			if type_name.is_empty() or count <= 0:
				continue
			var scene_value: Variant = type_map.get(type_name, null)
			var scene: PackedScene = scene_value as PackedScene
			if scene == null:
				push_warning("Unknown enemy type for area %d: %s" % [area_id, type_name])
				continue
			groups_out.append({
				"scene": scene,
				"count": count,
				"pattern": _pattern_for_type(type_name),
				"type": type_name,
			})

		if not groups_out.is_empty():
			resolved.append({"groups": groups_out})

	return resolved


func _pattern_for_type(type_name: String) -> String:
	match type_name:
		"soldier", "swordsman", "grub", "ashen_soldier", "brute", "shade", "hollow", "lost_shade", "warden", "wardens":
			return "ring"
		"archer", "dog", "hound", "wild_dog", "akaname", "bilemass":
			return "edge"
		_:
			return "edge"


func _run_authored_waves() -> void:
	if _waves.is_empty():
		return

	if opener_delay > 0.0:
		await get_tree().create_timer(opener_delay).timeout

	# Opening wave enters unalerted. Once any member spots Akio, the whole authored
	# wave engages. Later waves enter already engaged.
	await _spawn_wave(_waves[0] as Dictionary, false, 0)
	await _wait_for_player_spotted()
	_force_all_enemies_engage()
	await _wait_until_current_wave_cleared()

	for wave_index: int in range(1, _waves.size()):
		if wave_clear_delay > 0.0:
			await get_tree().create_timer(wave_clear_delay).timeout
		await _spawn_wave(_waves[wave_index] as Dictionary, true, wave_index)
		await _wait_until_current_wave_cleared()


func _spawn_wave(wave: Dictionary, auto_aggro_on_spawn: bool, wave_index: int) -> void:
	var groups_value: Variant = wave.get("groups", [])
	if typeof(groups_value) != TYPE_ARRAY:
		return
	var groups: Array = groups_value as Array

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		var composition: Array = []
		for group_value: Variant in groups:
			if typeof(group_value) == TYPE_DICTIONARY:
				var group: Dictionary = group_value as Dictionary
				composition.append({
					"type": str(group.get("type", "")),
					"count": int(group.get("count", 0)),
				})
		CombatTelemetry.record_event("encounter_wave_spawn", {
			"wave_index": wave_index,
			"composition": composition,
		})

	for group_value: Variant in groups:
		if typeof(group_value) != TYPE_DICTIONARY:
			continue
		await _spawn_group(group_value as Dictionary, auto_aggro_on_spawn)
		if group_spacing > 0.0:
			await get_tree().create_timer(group_spacing).timeout


func _spawn_group(group: Dictionary, auto_aggro_on_spawn: bool) -> void:
	var scene_value: Variant = group.get("scene", null)
	var scene: PackedScene = scene_value as PackedScene
	var count: int = int(group.get("count", 1))
	var pattern: String = str(group.get("pattern", "edge"))
	if scene == null or count <= 0:
		return

	for unit_index: int in range(count):
		while _alive >= active_cap:
			await get_tree().process_frame

		var spawn_pos: Vector2 = _ring_spawn_pos(unit_index, count) if pattern == "ring" else _edge_spawn_pos()
		var enemy: Node = scene.instantiate()

		# Configure spawn state and position before _ready() executes. Several enemy
		# controllers cache their home/patrol origin in _ready(), so adding at (0,0)
		# and moving afterward creates incorrect AI geometry.
		if enemy.has_method("set_auto_aggro_on_spawn"):
			enemy.call("set_auto_aggro_on_spawn", auto_aggro_on_spawn)
		elif _prop_exists(enemy, "auto_aggro_on_spawn"):
			enemy.set("auto_aggro_on_spawn", auto_aggro_on_spawn)

		if enemy is Node2D:
			var enemy_2d: Node2D = enemy as Node2D
			enemy_2d.position = to_local(spawn_pos)
			if _player != null and _prop_exists(enemy, "spawn_forward"):
				var forward: Vector2 = (_player.global_position - spawn_pos).normalized()
				enemy.set("spawn_forward", forward)

		add_child(enemy)
		_alive += 1

		if enemy.has_signal("enemy_died"):
			enemy.connect("enemy_died", Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)
		elif enemy.has_signal("remove_from_array"):
			enemy.connect("remove_from_array", Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)
		elif enemy.has_signal("died"):
			enemy.connect("died", Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)
		else:
			enemy.tree_exited.connect(Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)

		emit_signal("enemy_spawned", enemy)

		if auto_aggro_on_spawn and enemy.has_method("engage"):
			enemy.call_deferred("engage")

		if unit_stagger > 0.0:
			await get_tree().create_timer(unit_stagger).timeout


func _on_enemy_died(_enemy: Variant = null) -> void:
	_alive = maxi(0, _alive - 1)


func _wait_until_current_wave_cleared() -> void:
	while _alive > 0:
		await get_tree().process_frame


func _ring_spawn_pos(index: int, count: int) -> Vector2:
	var center: Vector2 = _player.global_position if _player != null else global_position
	var angle: float = TAU * (float(index) / float(maxi(1, count)))
	return center + Vector2(cos(angle), sin(angle)) * ring_radius


func _edge_spawn_pos() -> Vector2:
	var center: Vector2 = _player.global_position if _player != null else global_position

	if _use_spawn_rect and _spawn_rect.size != Vector2.ZERO:
		var rect: Rect2 = _spawn_rect
		var side: String = str(["up", "down", "right", "left"].pick_random())
		match side:
			"up":
				return Vector2(randf_range(rect.position.x, rect.end.x), rect.position.y)
			"down":
				return Vector2(randf_range(rect.position.x, rect.end.x), rect.end.y)
			"right":
				return Vector2(rect.end.x, randf_range(rect.position.y, rect.end.y))
			"left":
				return Vector2(rect.position.x, randf_range(rect.position.y, rect.end.y))
		return center

	var size: Vector2 = get_viewport_rect().size * randf_range(edge_multiplier_min, edge_multiplier_max)
	var half: Vector2 = size * 0.5
	var top_left: Vector2 = Vector2(center.x - half.x, center.y - half.y)
	var top_right: Vector2 = Vector2(center.x + half.x, center.y - half.y)
	var bottom_left: Vector2 = Vector2(center.x - half.x, center.y + half.y)
	var bottom_right: Vector2 = Vector2(center.x + half.x, center.y + half.y)
	var fallback_side: String = str(["up", "down", "right", "left"].pick_random())
	match fallback_side:
		"up":
			return Vector2(randf_range(top_left.x, top_right.x), top_left.y)
		"down":
			return Vector2(randf_range(bottom_left.x, bottom_right.x), bottom_left.y)
		"right":
			return Vector2(top_right.x, randf_range(top_right.y, bottom_right.y))
		"left":
			return Vector2(top_left.x, randf_range(top_left.y, bottom_left.y))
	return center


func set_spawn_rect(rect: Rect2) -> void:
	_spawn_rect = rect
	_use_spawn_rect = true


func _wait_for_player_spotted() -> void:
	while _alive > 0:
		await get_tree().process_frame
		var enemy_nodes: Array = get_tree().get_nodes_in_group("enemy")
		for enemy_value: Variant in enemy_nodes:
			if not (enemy_value is Node):
				continue
			var enemy: Node = enemy_value as Node
			if not (is_instance_valid(enemy) and is_ancestor_of(enemy)):
				continue

			var seen: bool = false
			if _prop_exists(enemy, "_saw_player_once") and bool(enemy.get("_saw_player_once")):
				seen = true
			elif _prop_exists(enemy, "_aggro") and bool(enemy.get("_aggro")):
				seen = true
			elif _prop_exists(enemy, "ai_state") and int(enemy.get("ai_state")) != 0:
				seen = true
			elif _prop_exists(enemy, "state") and int(enemy.get("state")) >= 2:
				seen = true

			if seen:
				return


func _force_all_enemies_engage() -> void:
	var enemy_nodes: Array = get_tree().get_nodes_in_group("enemy")
	for enemy_value: Variant in enemy_nodes:
		if not (enemy_value is Node):
			continue
		var enemy: Node = enemy_value as Node
		if not (is_instance_valid(enemy) and is_ancestor_of(enemy)):
			continue
		if enemy.has_method("set_auto_aggro_on_spawn"):
			enemy.call("set_auto_aggro_on_spawn", true)
		elif _prop_exists(enemy, "auto_aggro_on_spawn"):
			enemy.set("auto_aggro_on_spawn", true)
		if enemy.has_method("engage"):
			enemy.call_deferred("engage")


func _prop_exists(object: Object, property_name: String) -> bool:
	var property_list: Array[Dictionary] = object.get_property_list()
	for property_data: Dictionary in property_list:
		if str(property_data.get("name", "")) == property_name:
			return true
	return false
