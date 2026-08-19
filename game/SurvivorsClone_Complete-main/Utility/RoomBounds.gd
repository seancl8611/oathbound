extends Node2D

@export var size: Vector2 = Vector2(1600, 900)   # base room size in pixels
@export var standard_scale: float = 0.5          # global default scale for all rooms
@export var wall_thickness: float = 64.0
@export var wall_layer: int = 1
@export var wall_mask: int = 0

var _scaled_applied := false

@export var add_corner_deflectors: bool = true     # rounded inner corners (prevents wedging)
@export var corner_deflector_radius: float = 55.0  # 20–36 px works well
@export var wall_friction: float = 0.05             # 0 = very slidey; try 0.05–0.2 if too slick

func _ready() -> void:
	# Apply standard scale once so all rooms use the same reduced size.
	if not _scaled_applied:
		standard_scale = clamp(standard_scale, 0.01, 4.0)
		size *= standard_scale
		_scaled_applied = true
	_build_walls()

func get_rect_global() -> Rect2:
	var half := size * 0.5
	return Rect2(global_position - half, size)

func apply_camera_limits(camera: Camera2D) -> void:
	if camera == null:
		return
	var r := get_rect_global()
	camera.limit_left = int(r.position.x)
	camera.limit_top = int(r.position.y)
	camera.limit_right = int(r.position.x + r.size.x)
	camera.limit_bottom = int(r.position.y + r.size.y)

func _build_walls() -> void:
	# Clear old walls/deflectors (by name prefix)
	for c in get_children():
		if c is StaticBody2D and (
			c.name.begins_with("NorthWall") or c.name.begins_with("SouthWall") or
			c.name.begins_with("WestWall")  or c.name.begins_with("EastWall")  or
			c.name.begins_with("CornerDeflector")
		):
			c.queue_free()
	await get_tree().process_frame

	# Physics material for all wall pieces
	var mat := PhysicsMaterial.new()
	mat.friction = clampf(wall_friction, 0.0, 1.0)
	mat.bounce = 0.0

	var half := size * 0.5
	var t := wall_thickness

	# 4 rectangle walls whose inner faces lie exactly on the room edges
	var north_pos := Vector2(0, -half.y - t * 0.5)
	var south_pos := Vector2(0,  half.y + t * 0.5)
	var west_pos  := Vector2(-half.x - t * 0.5, 0)
	var east_pos  := Vector2( half.x + t * 0.5, 0)

	var north_sz := Vector2(size.x + t * 2.0, t)
	var south_sz := Vector2(size.x + t * 2.0, t)
	var west_sz  := Vector2(t, size.y + t * 2.0)
	var east_sz  := Vector2(t, size.y + t * 2.0)

	var specs := [
		{name = "NorthWall", offset = north_pos, sz = north_sz},
		{name = "SouthWall", offset = south_pos, sz = south_sz},
		{name = "WestWall",  offset = west_pos,  sz = west_sz},
		{name = "EastWall",  offset = east_pos,  sz = east_sz},
	]

	for s in specs:
		var body := StaticBody2D.new()
		body.name = s.name
		add_child(body)
		body.global_position = global_position + s.offset
		body.collision_layer = wall_layer
		body.collision_mask  = wall_mask
		body.physics_material_override = mat

		var col := CollisionShape2D.new()
		body.add_child(col)
		var shape := RectangleShape2D.new()
		shape.size = s.sz
		col.shape = shape

	# Corner deflectors centered on real inner corners, overlapping the walls
	if add_corner_deflectors and corner_deflector_radius > 2.0:
		var r := corner_deflector_radius
		# Push the circle center slightly OUTSIDE so it overlaps the rectangular walls.
		var center_out = min(t * 0.5, r)  # move by up to half wall thickness
		# Overfill radius a bit so there's zero seam
		var seam = clamp(r * 0.25, 4.0, 10.0)
		var centers := {
			"CornerDeflector_NW": Vector2(-half.x - center_out, -half.y - center_out),
			"CornerDeflector_NE": Vector2( half.x + center_out, -half.y - center_out),
			"CornerDeflector_SW": Vector2(-half.x - center_out,  half.y + center_out),
			"CornerDeflector_SE": Vector2( half.x + center_out,  half.y + center_out),
		}
		for name in centers.keys():
			var body := StaticBody2D.new()
			body.name = name
			add_child(body)
			body.global_position = global_position + centers[name]
			body.collision_layer = wall_layer
			body.collision_mask  = wall_mask
			body.physics_material_override = mat

			var col := CollisionShape2D.new()
			body.add_child(col)
			var cshape := CircleShape2D.new()
			# Radius slightly larger than requested to overlap rectangles
			cshape.radius = r + seam
			col.shape = cshape

func get_scaled_rect(factor: float) -> Rect2:
	factor = clamp(factor, 0.01, 1.0)
	var r := get_rect_global()
	var c := r.get_center()
	var new_size := r.size * factor
	return Rect2(c - new_size * 0.5, new_size)

func resize_to_factor(factor: float) -> void:
	factor = clamp(factor, 0.01, 4.0)
	size *= factor
	_build_walls()
