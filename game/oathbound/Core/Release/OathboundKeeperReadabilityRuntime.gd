extends Node

## Runtime compatibility layer for the current Keeper scene. It exists because Keeper's
## large imported controller still creates two perilous shapes as filled circles even
## though their floor tells describe annular/sector geometry. Keeping this adapter
## separate avoids rewriting the authored scene or duplicating the two-life boss rules.

const SECTOR_SEGMENTS := 18


func _ready() -> void:
	if not get_tree().node_added.is_connected(_on_tree_node_added):
		get_tree().node_added.connect(_on_tree_node_added)
	for node: Node in get_tree().get_nodes_in_group("boss"):
		_patch_keeper(node)


func _exit_tree() -> void:
	if get_tree() != null and get_tree().node_added.is_connected(_on_tree_node_added):
		get_tree().node_added.disconnect(_on_tree_node_added)


func _on_tree_node_added(node: Node) -> void:
	if node == null:
		return
	if node is Area2D and node.name == "BossHitbox":
		_patch_keeper_hitbox(node as Area2D)
	elif node.name == "Keeper" or node.is_in_group("boss"):
		_patch_keeper(node)


func _patch_keeper(node: Node) -> void:
	if not _is_keeper(node) or bool(node.get_meta("_oathbound_readability_timing_applied", false)):
		return
	node.set_meta("_oathbound_readability_timing_applied", true)
	_set_minimum(node, "discipline_windup", 0.38)
	_set_minimum(node, "blade_dance_hit1_anticipation", 0.32)
	_set_minimum(node, "blade_dance_hit2_anticipation", 0.32)
	_set_minimum(node, "blade_dance_hit4_anticipation", 0.34)
	_set_minimum(node, "sweep_telegraph_time", 0.60)
	_set_minimum(node, "feral_windup", 0.42)
	_set_minimum(node, "feral_hit1_anticipation", 0.30)
	_set_minimum(node, "feral_hit2_anticipation", 0.28)
	_set_minimum(node, "feral_hit3_anticipation", 0.30)
	_set_minimum(node, "feral_hit4_anticipation", 0.28)
	_set_minimum(node, "feral_hit5_anticipation", 0.26)
	_set_minimum(node, "feral_inter_hit_recovery", 0.15)
	_set_minimum(node, "savage_telegraph_time", 0.68)
	_set_minimum(node, "phase2_min_cooldown", 0.65)
	_set_minimum(node, "phase2_max_cooldown", 1.10)
	print("[Keeper] playtest readability timing active")


func _patch_keeper_hitbox(area: Area2D) -> void:
	if bool(area.get_meta("_oathbound_keeper_geometry_patched", false)):
		return
	var attacker_value: Variant = area.get_meta("attacker", null)
	if not (attacker_value is Node) or not is_instance_valid(attacker_value):
		return
	var keeper := attacker_value as Node
	if not _is_keeper(keeper):
		return

	var damage_type := str(area.get_meta("damage_type", ""))
	if damage_type == "keeper_shockwave":
		var outer := _circle_radius(area)
		var inner := maxf(0.0, float(area.get_meta("inner_radius", 0.0)))
		if outer > inner + 0.5:
			_replace_filled_circle(area, inner, outer, 0.0, 360.0, "annular_ring")
	elif damage_type == "keeper_sweep":
		var inner := maxf(0.0, _read_float(keeper, "sweep_inner_radius", 30.0))
		var outer := maxf(inner + 1.0, _read_float(keeper, "sweep_outer_radius", 100.0))
		var arc_deg := clampf(_read_float(keeper, "sweep_arc_degrees", 270.0), 1.0, 360.0)
		var facing := Vector2.RIGHT
		if keeper.has_method("_get_facing_direction"):
			facing = Vector2(keeper.call("_get_facing_direction"))
		var facing_angle := facing.angle() if facing.length_squared() > 0.001 else 0.0
		area.set_meta("inner_radius", inner)
		area.set_meta("outer_radius", outer)
		area.set_meta("arc_degrees", arc_deg)
		_replace_filled_circle(area, inner, outer, facing_angle, arc_deg, "annular_sector")


func _replace_filled_circle(area: Area2D, inner: float, outer: float, center_angle: float, arc_deg: float, kind: String) -> void:
	area.set_meta("_oathbound_keeper_geometry_patched", true)
	area.set_meta("collision_kind", kind)
	area.set_meta("outer_radius", outer)
	area.monitoring = false

	for child: Node in area.get_children():
		if child is CollisionShape2D:
			(child as CollisionShape2D).disabled = true
			child.queue_free()

	_add_annular_sector_shapes(area, inner, outer, center_angle, arc_deg)
	area.call_deferred("set", "monitoring", true)


func _add_annular_sector_shapes(area: Area2D, inner: float, outer: float, center_angle: float, arc_deg: float) -> void:
	var safe_outer := maxf(1.0, outer)
	var safe_inner := clampf(inner, 0.0, safe_outer - 0.5)
	var arc_radians := deg_to_rad(clampf(arc_deg, 1.0, 360.0))
	var start_angle := center_angle - arc_radians * 0.5
	for index: int in range(SECTOR_SEGMENTS):
		var t0 := float(index) / float(SECTOR_SEGMENTS)
		var t1 := float(index + 1) / float(SECTOR_SEGMENTS)
		var angle0 := start_angle + arc_radians * t0
		var angle1 := start_angle + arc_radians * t1
		var outer0 := Vector2.from_angle(angle0) * safe_outer
		var outer1 := Vector2.from_angle(angle1) * safe_outer
		var polygon := CollisionPolygon2D.new()
		if safe_inner <= 0.1:
			polygon.polygon = PackedVector2Array([Vector2.ZERO, outer0, outer1])
		else:
			var inner0 := Vector2.from_angle(angle0) * safe_inner
			var inner1 := Vector2.from_angle(angle1) * safe_inner
			polygon.polygon = PackedVector2Array([inner0, outer0, outer1, inner1])
		area.add_child(polygon)


func _circle_radius(area: Area2D) -> float:
	for child: Node in area.get_children():
		if child is CollisionShape2D:
			var shape: Shape2D = (child as CollisionShape2D).shape
			if shape is CircleShape2D:
				return float((shape as CircleShape2D).radius)
	return 0.0


func _is_keeper(node: Node) -> bool:
	if node == null or not is_instance_valid(node):
		return false
	if node.name != "Keeper":
		return false
	return node.get("discipline_windup") != null and node.get("phase2_min_cooldown") != null


func _set_minimum(node: Node, property_name: String, floor_value: float) -> void:
	var current: Variant = node.get(property_name)
	if current == null:
		return
	node.set(property_name, maxf(float(current), floor_value))


func _read_float(node: Node, property_name: String, fallback: float) -> float:
	var value: Variant = node.get(property_name)
	return float(value) if value != null else fallback
