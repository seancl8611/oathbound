extends EnemyBase

## =============================================================================
## HOLLOW VESSEL — Area 3 Spawning Structure
## =============================================================================
## Role:
## - Enemy spawning structure with HP.
## - Periodically spawns Hollow enemies until destroyed.
## - Counts as an enemy for room clear if enabled.
## - Does not block, parry, chase, attack, or use humanoid combat logic.
##
## Inheritance:
## - Extends EnemyBase directly.
## - Does NOT extend HumanoidEnemyBase.
## =============================================================================

signal destroyed(vessel: Node)
signal spawn_blocked()
signal hollow_spawned(hollow: Node)

# =============================================================================
# CORE
# =============================================================================

@export_group("Core")
@export var start_active: bool = true
@export var counts_as_enemy_for_room_clear: bool = true

# =============================================================================
# SPAWNING
# =============================================================================

@export_group("Spawning")
@export var hollow_scene: PackedScene
@export var spawn_interval: float = 2.5
@export var max_active_spawns: int = 4
@export var spawn_radius_min: float = 26.0
@export var spawn_radius_max: float = 54.0
@export var spawn_attempts: int = 8
@export var auto_aggro_spawned_hollows: bool = true
@export var spawn_parent_path: NodePath

# =============================================================================
# REWARDS
# =============================================================================

@export_group("Rewards")
@export var gold_drop_min: int = 0
@export var gold_drop_max: int = 0

# =============================================================================
# FEEDBACK
# =============================================================================

@export_group("Feedback")
@export var hit_flash_color: Color = Color(1.0, 0.65, 0.65, 1.0)
@export var idle_pulse_enabled: bool = true
@export var idle_pulse_speed: float = 1.6
@export var idle_pulse_strength: float = 0.08

# =============================================================================
# RUNTIME
# =============================================================================

var spawned_hollows: Array = []

@onready var spawn_timer: Timer = get_node_or_null("SpawnTimer") as Timer
@onready var placement_body: StaticBody2D = get_node_or_null("PlacementBody") as StaticBody2D
@onready var placement_collision: CollisionShape2D = get_node_or_null("PlacementBody/CollisionShape2D") as CollisionShape2D

var _base_modulate: Color = Color.WHITE
var _pulse_t: float = 0.0

# =============================================================================
# READY / PROCESS
# =============================================================================

func _ready() -> void:
	_base_enemy_ready()
	
	if not counts_as_enemy_for_room_clear and is_in_group("enemy"):
		remove_from_group("enemy")
	
	if not is_in_group("spawner"):
		add_to_group("spawner")
	
	if not is_in_group("hollow_vessel"):
		add_to_group("hollow_vessel")
	
	if sprite:
		_base_modulate = sprite.modulate
	
	# RoomBounds builds walls one frame later, so defer placement until physics exists.
	call_deferred("_finalize_initial_placement")
	
	if spawn_timer:
		spawn_timer.wait_time = max(0.1, spawn_interval)
		
		if not spawn_timer.timeout.is_connected(_on_spawn_timer_timeout):
			spawn_timer.timeout.connect(_on_spawn_timer_timeout)
		
		if start_active:
			spawn_timer.start()
	
	_set_hurtbox_enabled(true)


func _process(delta: float) -> void:
	if has_died:
		return
	
	_prune_spawned_hollows()
	
	if idle_pulse_enabled and sprite:
		_pulse_t += delta * idle_pulse_speed
		var pulse := 1.0 + sin(_pulse_t) * idle_pulse_strength
		var c := _base_modulate
		sprite.modulate = Color(c.r * pulse, c.g * pulse, c.b * pulse, c.a)


# =============================================================================
# DAMAGE / DEATH
# =============================================================================

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if has_died:
		return
	
	if damage <= 0:
		return
	
	var source := _resolve_hurt_source(attacker)
	
	if source and is_instance_valid(source) and source.is_in_group("enemy"):
		return
	
	var hp_damage := apply_hp_damage(damage)
	
	if hp_damage > 0:
		show_enemy_damage_number(hp_damage, damage_type, -20.0)
		_flash_hit()
	
	notify_combat_got_hit({
		"damage": damage,
		"blocked": false,
		"damage_type": damage_type
	})
	
	if hp <= 0:
		death()


func death() -> void:
	if not mark_dead():
		return
	
	if spawn_timer:
		spawn_timer.stop()
	
	_set_hurtbox_enabled(false)
	
	if is_in_group("enemy"):
		remove_from_group("enemy")
	
	if sprite:
		var tw := create_tween()
		tw.tween_property(sprite, "modulate:a", 0.2, 0.20)
	
	_drop_rewards()
	
	emit_signal("destroyed", self)
	emit_signal("enemy_died", self)
	
	queue_free()


# =============================================================================
# SPAWNING
# =============================================================================

func _on_spawn_timer_timeout() -> void:
	if has_died:
		return
	
	_prune_spawned_hollows()
	
	if spawned_hollows.size() >= max_active_spawns:
		emit_signal("spawn_blocked")
		return
	
	_spawn_hollow()


func _spawn_hollow() -> void:
	if hollow_scene == null:
		push_warning("[HollowVessel] hollow_scene is not assigned.")
		return
	
	var hollow := hollow_scene.instantiate()
	if hollow == null:
		return
	
	var parent_node := _get_spawn_parent()
	parent_node.add_child(hollow)
	
	var spawn_pos := _find_spawn_position()
	
	if hollow is Node2D:
		hollow.global_position = spawn_pos
	
	if auto_aggro_spawned_hollows:
		_wake_spawned_hollow(hollow)
	
	hollow.set_meta("spawned_by_hollow_vessel", true)
	hollow.set_meta("hollow_vessel_source", self)
	
	spawned_hollows.append(hollow)
	emit_signal("hollow_spawned", hollow)


func _wake_spawned_hollow(hollow: Node) -> void:
	if hollow == null:
		return
	
	if hollow.has_method("set_auto_aggro_on_spawn"):
		hollow.set_auto_aggro_on_spawn(true)
	elif object_has_property(hollow, "auto_aggro_on_spawn"):
		hollow.set("auto_aggro_on_spawn", true)
	
	if object_has_property(hollow, "_saw_player_once"):
		hollow.set("_saw_player_once", true)
	
	if object_has_property(hollow, "_aggro"):
		hollow.set("_aggro", true)
	
	if hollow.has_method("engage"):
		hollow.call_deferred("engage")


func _prune_spawned_hollows() -> void:
	for i in range(spawned_hollows.size() - 1, -1, -1):
		var hollow = spawned_hollows[i]
		
		if not is_instance_valid(hollow):
			spawned_hollows.remove_at(i)


func _get_spawn_parent() -> Node:
	if spawn_parent_path != NodePath():
		var custom_parent := get_node_or_null(spawn_parent_path)
		if custom_parent:
			return custom_parent
	
	if get_parent() != null:
		return get_parent()
	
	return get_tree().current_scene


# =============================================================================
# SPAWN POSITIONING
# =============================================================================

func _find_spawn_position() -> Vector2:
	var room_rect := _get_spawn_rect_fallback(32.0)
	
	for _i in range(spawn_attempts):
		var ang := randf() * TAU
		var dist := randf_range(spawn_radius_min, spawn_radius_max)
		var candidate := global_position + Vector2(cos(ang), sin(ang)) * dist
		candidate = _clamp_point_to_rect(candidate, room_rect, 12.0)
		
		if _is_spawn_position_clear(candidate):
			return candidate
	
	return _clamp_point_to_rect(global_position + Vector2.RIGHT * spawn_radius_min, room_rect, 12.0)


func _is_spawn_position_clear(pos: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	
	if space_state == null:
		return true
	
	var params := PhysicsShapeQueryParameters2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 12.0
	
	params.shape = circle
	params.transform = Transform2D(0.0, pos)
	params.collide_with_areas = true
	params.collide_with_bodies = true
	params.exclude = [self]
	
	var hits := space_state.intersect_shape(params, 8)
	
	if hits.is_empty():
		return true
	
	for hit in hits:
		var collider = hit.get("collider")
		
		if collider == null:
			continue
		
		if collider.is_in_group("player"):
			return false
		
		if collider is StaticBody2D:
			return false
	
	return true


# =============================================================================
# FEEDBACK / REWARDS
# =============================================================================

func _flash_hit() -> void:
	if sprite == null:
		return
	
	var tw := create_tween()
	tw.tween_property(sprite, "modulate", hit_flash_color, 0.05)
	tw.tween_property(sprite, "modulate", _base_modulate, 0.10)


func _drop_rewards() -> void:
	if gold_drop_max <= 0:
		return
	
	var rd := get_node_or_null("/root/RunData")
	
	if rd == null:
		return
	
	var gold_amt := randi_range(gold_drop_min, gold_drop_max)
	
	if gold_amt > 0 and rd.has_method("add_gold"):
		rd.add_gold(gold_amt)


func _set_hurtbox_enabled(enabled: bool) -> void:
	if hurt_box == null:
		return
	
	hurt_box.set_deferred("monitoring", enabled)
	hurt_box.set_deferred("monitorable", enabled)
	
	var collision: CollisionShape2D = hurt_box.get_node_or_null("CollisionShape2D") as CollisionShape2D
	
	if collision:
		collision.set_deferred("disabled", not enabled)


# =============================================================================
# ROOM BOUNDS / PLACEMENT
# =============================================================================

func _get_spawn_rect_fallback(margin: float) -> Rect2:
	var n: Node = self
	
	while n != null:
		var rb := n.get_node_or_null("RoomBounds")
		
		if rb and rb.has_method("get_rect_global"):
			var rect: Rect2 = rb.call("get_rect_global")
			return Rect2(
				rect.position + Vector2(margin, margin),
				rect.size - Vector2(margin * 2.0, margin * 2.0)
			)
		
		n = n.get_parent()
	
	var scene := get_tree().current_scene
	
	if scene:
		var rb2 := scene.find_child("RoomBounds", true, false)
		
		if rb2 and rb2.has_method("get_rect_global"):
			var rect2: Rect2 = rb2.call("get_rect_global")
			return Rect2(
				rect2.position + Vector2(margin, margin),
				rect2.size - Vector2(margin * 2.0, margin * 2.0)
			)
	
	return Rect2(global_position - Vector2(800, 450), Vector2(1600, 900))


func _clamp_point_to_rect(p: Vector2, r: Rect2, margin: float) -> Vector2:
	var left := r.position.x + margin
	var right := r.position.x + r.size.x - margin
	var top := r.position.y + margin
	var bottom := r.position.y + r.size.y - margin
	
	return Vector2(
		clamp(p.x, left, right),
		clamp(p.y, top, bottom)
	)


func _clamp_self_to_room_bounds() -> void:
	var room_rect := _get_spawn_rect_fallback(0.0)
	var footprint_half := _get_vessel_half_extents()
	
	var min_x := room_rect.position.x + footprint_half.x
	var max_x := room_rect.position.x + room_rect.size.x - footprint_half.x
	var min_y := room_rect.position.y + footprint_half.y
	var max_y := room_rect.position.y + room_rect.size.y - footprint_half.y
	
	global_position = Vector2(
		clamp(global_position.x, min_x, max_x),
		clamp(global_position.y, min_y, max_y)
	)
	
	if not _is_vessel_position_clear(global_position):
		var center := room_rect.get_center()
		var dir := (center - global_position).normalized()
		
		if dir.length_squared() < 0.0001:
			dir = Vector2.DOWN
		
		var step = max(8.0, min(footprint_half.x, footprint_half.y) * 0.5)
		
		for i in range(48):
			var candidate = global_position + dir * step * float(i + 1)
			candidate = Vector2(
				clamp(candidate.x, min_x, max_x),
				clamp(candidate.y, min_y, max_y)
			)
			
			if _is_vessel_position_clear(candidate):
				global_position = candidate
				return
		
		global_position = Vector2(
			clamp(center.x, min_x, max_x),
			clamp(center.y, min_y, max_y)
		)


func _get_vessel_half_extents() -> Vector2:
	if placement_collision and placement_collision.shape:
		var shape := placement_collision.shape
		var scale := placement_collision.global_scale.abs()
		
		if shape is RectangleShape2D:
			return (shape.size * 0.5) * scale
		
		if shape is CircleShape2D:
			return Vector2.ONE * shape.radius * max(scale.x, scale.y)
		
		if shape is CapsuleShape2D:
			return Vector2(
				shape.radius * scale.x,
				(shape.height * 0.5 + shape.radius) * scale.y
			)
	
	if hurt_box:
		var collision: CollisionShape2D = hurt_box.get_node_or_null("CollisionShape2D") as CollisionShape2D
		
		if collision and collision.shape:
			var hb_shape := collision.shape
			var hb_scale := collision.global_scale.abs()
			
			if hb_shape is RectangleShape2D:
				return (hb_shape.size * 0.5) * hb_scale + Vector2(12.0, 12.0)
			
			if hb_shape is CircleShape2D:
				return Vector2.ONE * hb_shape.radius * max(hb_scale.x, hb_scale.y) + Vector2(12.0, 12.0)
			
			if hb_shape is CapsuleShape2D:
				return Vector2(
					hb_shape.radius * hb_scale.x + 12.0,
					(hb_shape.height * 0.5 + hb_shape.radius) * hb_scale.y + 12.0
				)
	
	return Vector2(36.0, 36.0)


func _is_vessel_position_clear(pos: Vector2) -> bool:
	var space_state := get_world_2d().direct_space_state
	
	if space_state == null:
		return true
	
	var params := PhysicsShapeQueryParameters2D.new()
	params.collide_with_areas = false
	params.collide_with_bodies = true
	
	if placement_body:
		params.exclude = [placement_body.get_rid()]
	else:
		params.exclude = []
	
	if placement_collision and placement_collision.shape:
		params.shape = placement_collision.shape
		
		var scale := placement_collision.global_scale
		var rot := placement_collision.global_rotation
		
		var xform := Transform2D.IDENTITY
		xform = xform.scaled(scale)
		xform = xform.rotated(rot)
		xform.origin = pos
		
		params.transform = xform
	else:
		var circle := CircleShape2D.new()
		circle.radius = 24.0
		params.shape = circle
		params.transform = Transform2D(0.0, pos)
	
	var hits := space_state.intersect_shape(params, 16)
	
	if hits.is_empty():
		return true
	
	for hit in hits:
		var collider = hit.get("collider")
		
		if collider == null:
			continue
		
		if collider is StaticBody2D:
			return false
	
	return true


func _finalize_initial_placement() -> void:
	await get_tree().process_frame
	await get_tree().physics_frame
	
	_clamp_self_to_room_bounds()
