extends Node2D

## Procedural placeholder art for the Hushiro three-quarter presentation prototype.
##
## This node is intentionally presentation-only. It adds no collision, navigation or
## gameplay authority. The goal is to give the projected Camera2D a scene that was
## authored for a high-angle action view instead of merely squashing the legacy dirt
## texture. Production art can replace these shapes without changing combat logic.

@export var enabled := true
@export var show_floor_guides := true

const ACTOR_DEPTH_BIAS := 1000
const FLOOR_Z := -920
const FLOOR_DETAIL_Z := -910
const BACKDROP_Z := -900

const C_GROUND := Color(0.115, 0.095, 0.088, 1.0)
const C_GROUND_EDGE := Color(0.075, 0.062, 0.060, 1.0)
const C_STONE := Color(0.205, 0.205, 0.195, 1.0)
const C_STONE_DARK := Color(0.125, 0.128, 0.125, 1.0)
const C_WOOD := Color(0.185, 0.105, 0.080, 1.0)
const C_WOOD_DARK := Color(0.080, 0.052, 0.048, 1.0)
const C_TORII := Color(0.285, 0.075, 0.060, 1.0)
const C_TORII_DARK := Color(0.120, 0.035, 0.035, 1.0)
const C_MOSS := Color(0.125, 0.155, 0.105, 1.0)
const C_ASH := Color(0.360, 0.335, 0.300, 0.55)
const C_SHADOW := Color(0.020, 0.018, 0.020, 0.30)


func _ready() -> void:
	if not enabled:
		visible = false
		return

	name = "ThreeQuarterHushiroPrototype"
	_build_floor()
	_build_back_wall_and_torii()
	_build_side_ruins()
	_build_foreground_occluders()
	_build_floor_debris()


func _build_floor() -> void:
	var floor := Polygon2D.new()
	floor.name = "ProjectedCombatFloor"
	floor.polygon = PackedVector2Array([
		Vector2(-430.0, -238.0),
		Vector2(430.0, -238.0),
		Vector2(475.0, 238.0),
		Vector2(-475.0, 238.0),
	])
	floor.color = C_GROUND
	floor.z_index = FLOOR_Z
	add_child(floor)

	# A darker trapezoid just outside the playable plane makes the room read like a
	# bounded physical space rather than an infinite stretched texture.
	var rim := Line2D.new()
	rim.name = "CombatFloorRim"
	rim.points = PackedVector2Array([
		Vector2(-430.0, -238.0),
		Vector2(430.0, -238.0),
		Vector2(475.0, 238.0),
		Vector2(-475.0, 238.0),
		Vector2(-430.0, -238.0),
	])
	rim.width = 8.0
	rim.default_color = C_GROUND_EDGE
	rim.z_index = FLOOR_DETAIL_Z
	add_child(rim)

	if not show_floor_guides:
		return

	# Sparse diagonals establish the new ground perspective without turning Hushiro into
	# a literal isometric tile grid. These are placeholder composition guides only.
	for x: float in [-300.0, -150.0, 0.0, 150.0, 300.0]:
		_add_ground_line(
			PackedVector2Array([Vector2(x - 110.0, -225.0), Vector2(x + 125.0, 225.0)]),
			Color(0.25, 0.23, 0.20, 0.11),
			1.0
		)
	for x: float in [-300.0, -150.0, 0.0, 150.0, 300.0]:
		_add_ground_line(
			PackedVector2Array([Vector2(x + 110.0, -225.0), Vector2(x - 125.0, 225.0)]),
			Color(0.25, 0.23, 0.20, 0.075),
			1.0
		)

	# A worn central combat patch gives attacks and enemy spacing a readable arena center.
	_add_ellipse(Vector2(0.0, 5.0), Vector2(115.0, 67.0), Color(0.19, 0.16, 0.135, 0.24), FLOOR_DETAIL_Z)
	_add_ellipse(Vector2(0.0, 5.0), Vector2(72.0, 42.0), Color(0.07, 0.06, 0.055, 0.18), FLOOR_DETAIL_Z + 1)


func _build_back_wall_and_torii() -> void:
	# Broken retaining stones across the far edge. Their base Y establishes draw depth;
	# their visible mass extends upward, mimicking vertical geometry in the 2D renderer.
	for spec: Dictionary in [
		{"p": Vector2(-310.0, -217.0), "w": 145.0, "h": 44.0},
		{"p": Vector2(-150.0, -220.0), "w": 110.0, "h": 34.0},
		{"p": Vector2(165.0, -221.0), "w": 125.0, "h": 40.0},
		{"p": Vector2(320.0, -216.0), "w": 150.0, "h": 49.0},
	]:
		_build_stone_wall_segment(spec.p, float(spec.w), float(spec.h))

	var torii := Node2D.new()
	torii.name = "RuinedTorii"
	torii.position = Vector2(0.0, -186.0)
	torii.z_index = _depth_for_y(torii.position.y)
	add_child(torii)

	# Long rear shadow helps the gate sit on the plane before final lighting exists.
	_add_local_polygon(torii, "ToriiGroundShadow", PackedVector2Array([
		Vector2(-106.0, 5.0), Vector2(106.0, 5.0), Vector2(82.0, 18.0), Vector2(-82.0, 18.0),
	]), C_SHADOW, -2)

	_add_local_polygon(torii, "LeftPillar", PackedVector2Array([
		Vector2(-88.0, 2.0), Vector2(-72.0, 2.0), Vector2(-69.0, -92.0), Vector2(-91.0, -92.0),
	]), C_TORII, 0)
	_add_local_polygon(torii, "RightPillar", PackedVector2Array([
		Vector2(72.0, 2.0), Vector2(88.0, 2.0), Vector2(91.0, -92.0), Vector2(69.0, -92.0),
	]), C_TORII, 0)
	_add_local_polygon(torii, "CrossBeam", PackedVector2Array([
		Vector2(-122.0, -97.0), Vector2(122.0, -97.0), Vector2(112.0, -82.0), Vector2(-112.0, -82.0),
	]), C_TORII, 1)
	_add_local_polygon(torii, "UpperBeam", PackedVector2Array([
		Vector2(-136.0, -114.0), Vector2(136.0, -114.0), Vector2(124.0, -102.0), Vector2(-124.0, -102.0),
	]), C_TORII_DARK, 1)
	_add_local_polygon(torii, "BrokenCap", PackedVector2Array([
		Vector2(35.0, -126.0), Vector2(124.0, -121.0), Vector2(116.0, -111.0), Vector2(45.0, -114.0),
	]), C_WOOD_DARK, 2)

	# Two hanging paper remnants immediately sell height and a feudal/supernatural space.
	_add_local_polygon(torii, "LeftTalisman", PackedVector2Array([
		Vector2(-53.0, -82.0), Vector2(-40.0, -82.0), Vector2(-42.0, -52.0), Vector2(-55.0, -55.0),
	]), Color(0.72, 0.67, 0.52, 0.75), 2)
	_add_local_polygon(torii, "RightTalisman", PackedVector2Array([
		Vector2(46.0, -82.0), Vector2(58.0, -82.0), Vector2(61.0, -60.0), Vector2(48.0, -57.0),
	]), Color(0.63, 0.56, 0.44, 0.62), 2)


func _build_side_ruins() -> void:
	_build_broken_shrine(Vector2(-344.0, -72.0), 0.92)
	_build_broken_shrine(Vector2(352.0, 32.0), 0.78)

	for spec: Dictionary in [
		{"p": Vector2(-375.0, 128.0), "s": 1.05},
		{"p": Vector2(374.0, -105.0), "s": 0.88},
		{"p": Vector2(-286.0, -172.0), "s": 0.68},
		{"p": Vector2(294.0, 170.0), "s": 0.72},
	]:
		_build_rock_cluster(spec.p, float(spec.s))


func _build_foreground_occluders() -> void:
	# These props are deliberately anchored near the south edge so they can pass in front
	# of Akio/enemies. That occlusion is a key piece of the intended dimensional read.
	_build_broken_fence(Vector2(-245.0, 218.0), 1.0)
	_build_broken_fence(Vector2(225.0, 220.0), 0.86)
	_build_grass_clump(Vector2(-370.0, 210.0), 1.2)
	_build_grass_clump(Vector2(350.0, 205.0), 1.05)


func _build_floor_debris() -> void:
	for spec: Dictionary in [
		{"p": Vector2(-205.0, -42.0), "r": Vector2(17.0, 7.0)},
		{"p": Vector2(176.0, -112.0), "r": Vector2(12.0, 5.0)},
		{"p": Vector2(255.0, 82.0), "r": Vector2(18.0, 7.0)},
		{"p": Vector2(-126.0, 144.0), "r": Vector2(14.0, 6.0)},
		{"p": Vector2(72.0, 172.0), "r": Vector2(10.0, 4.0)},
	]:
		_add_ellipse(spec.p, spec.r, Color(0.31, 0.29, 0.25, 0.32), FLOOR_DETAIL_Z + 2)

	for spec: Dictionary in [
		{"p": Vector2(-248.0, 77.0), "s": 0.8},
		{"p": Vector2(315.0, 126.0), "s": 0.72},
		{"p": Vector2(122.0, -168.0), "s": 0.6},
	]:
		_build_grass_clump(spec.p, float(spec.s), false)


func _build_stone_wall_segment(base: Vector2, width: float, height: float) -> void:
	var wall := Node2D.new()
	wall.name = "FarStoneWall"
	wall.position = base
	wall.z_index = _depth_for_y(base.y)
	add_child(wall)

	_add_local_polygon(wall, "Shadow", PackedVector2Array([
		Vector2(-width * 0.52, 4.0), Vector2(width * 0.52, 4.0),
		Vector2(width * 0.43, 15.0), Vector2(-width * 0.43, 15.0),
	]), C_SHADOW, -2)
	_add_local_polygon(wall, "Face", PackedVector2Array([
		Vector2(-width * 0.5, 0.0), Vector2(width * 0.5, 0.0),
		Vector2(width * 0.47, -height), Vector2(-width * 0.46, -height * 0.92),
	]), C_STONE_DARK, 0)
	_add_local_polygon(wall, "Top", PackedVector2Array([
		Vector2(-width * 0.46, -height * 0.92), Vector2(width * 0.47, -height),
		Vector2(width * 0.41, -height - 9.0), Vector2(-width * 0.40, -height - 7.0),
	]), C_STONE, 1)
	_add_local_polygon(wall, "Moss", PackedVector2Array([
		Vector2(-width * 0.28, -height * 0.90), Vector2(-width * 0.04, -height * 0.96),
		Vector2(width * 0.03, -height * 0.76), Vector2(-width * 0.22, -height * 0.73),
	]), C_MOSS, 2)


func _build_broken_shrine(base: Vector2, scale_factor: float) -> void:
	var shrine := Node2D.new()
	shrine.name = "BrokenRoadsideShrine"
	shrine.position = base
	shrine.scale = Vector2.ONE * scale_factor
	shrine.z_index = _depth_for_y(base.y)
	add_child(shrine)

	_add_local_polygon(shrine, "Shadow", PackedVector2Array([
		Vector2(-38.0, 5.0), Vector2(38.0, 5.0), Vector2(29.0, 15.0), Vector2(-29.0, 15.0),
	]), C_SHADOW, -2)
	_add_local_polygon(shrine, "Body", PackedVector2Array([
		Vector2(-26.0, 0.0), Vector2(28.0, 0.0), Vector2(22.0, -58.0), Vector2(-23.0, -58.0),
	]), Color(0.14, 0.12, 0.11, 1.0), 0)
	_add_local_polygon(shrine, "Roof", PackedVector2Array([
		Vector2(-42.0, -60.0), Vector2(39.0, -60.0), Vector2(26.0, -75.0), Vector2(-31.0, -75.0),
	]), C_WOOD_DARK, 1)
	_add_local_polygon(shrine, "BrokenRoof", PackedVector2Array([
		Vector2(5.0, -76.0), Vector2(45.0, -68.0), Vector2(32.0, -59.0), Vector2(8.0, -63.0),
	]), C_WOOD, 2)
	_add_local_polygon(shrine, "Opening", PackedVector2Array([
		Vector2(-11.0, -12.0), Vector2(13.0, -12.0), Vector2(12.0, -43.0), Vector2(-10.0, -43.0),
	]), Color(0.025, 0.020, 0.020, 1.0), 1)


func _build_rock_cluster(base: Vector2, scale_factor: float) -> void:
	var rock := Node2D.new()
	rock.name = "RockCluster"
	rock.position = base
	rock.scale = Vector2.ONE * scale_factor
	rock.z_index = _depth_for_y(base.y)
	add_child(rock)

	_add_local_polygon(rock, "Shadow", PackedVector2Array([
		Vector2(-31.0, 4.0), Vector2(34.0, 4.0), Vector2(25.0, 14.0), Vector2(-24.0, 14.0),
	]), C_SHADOW, -2)
	_add_local_polygon(rock, "RockA", PackedVector2Array([
		Vector2(-29.0, 1.0), Vector2(2.0, 1.0), Vector2(10.0, -23.0), Vector2(-15.0, -37.0), Vector2(-34.0, -18.0),
	]), C_STONE_DARK, 0)
	_add_local_polygon(rock, "RockB", PackedVector2Array([
		Vector2(-1.0, 2.0), Vector2(34.0, 2.0), Vector2(28.0, -24.0), Vector2(9.0, -30.0),
	]), C_STONE, 0)


func _build_broken_fence(base: Vector2, scale_factor: float) -> void:
	var fence := Node2D.new()
	fence.name = "ForegroundBrokenFence"
	fence.position = base
	fence.scale = Vector2.ONE * scale_factor
	fence.z_index = _depth_for_y(base.y)
	add_child(fence)

	_add_local_polygon(fence, "PostA", PackedVector2Array([
		Vector2(-45.0, 2.0), Vector2(-35.0, 2.0), Vector2(-34.0, -60.0), Vector2(-44.0, -66.0),
	]), C_WOOD_DARK, 0)
	_add_local_polygon(fence, "PostB", PackedVector2Array([
		Vector2(42.0, 2.0), Vector2(51.0, 2.0), Vector2(49.0, -48.0), Vector2(40.0, -43.0),
	]), C_WOOD_DARK, 0)
	_add_local_polygon(fence, "Rail", PackedVector2Array([
		Vector2(-49.0, -39.0), Vector2(50.0, -28.0), Vector2(48.0, -19.0), Vector2(-47.0, -29.0),
	]), C_WOOD, 1)


func _build_grass_clump(base: Vector2, scale_factor: float, depth_sorted: bool = true) -> void:
	var grass := Node2D.new()
	grass.name = "DeadGrassClump"
	grass.position = base
	grass.scale = Vector2.ONE * scale_factor
	grass.z_index = _depth_for_y(base.y) if depth_sorted else FLOOR_DETAIL_Z + 3
	add_child(grass)

	for offset: float in [-13.0, -7.0, 0.0, 7.0, 13.0]:
		var lean := offset * 0.45
		_add_local_polygon(grass, "Blade", PackedVector2Array([
			Vector2(offset - 2.0, 1.0),
			Vector2(offset + 2.0, 1.0),
			Vector2(offset + lean * 0.16 + 1.0, -22.0 - absf(offset) * 0.35),
			Vector2(offset + lean * 0.24, -30.0 + absf(offset) * 0.18),
		]), C_ASH, 0)


func _add_ground_line(points: PackedVector2Array, color: Color, width: float) -> void:
	var line := Line2D.new()
	line.points = points
	line.width = width
	line.default_color = color
	line.z_index = FLOOR_DETAIL_Z
	add_child(line)


func _add_ellipse(center: Vector2, radii: Vector2, color: Color, z_value: int) -> void:
	var poly := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	poly.polygon = points
	poly.position = center
	poly.color = color
	poly.z_index = z_value
	add_child(poly)


func _add_local_polygon(parent: Node2D, node_name: String, points: PackedVector2Array, color: Color, z_value: int) -> Polygon2D:
	var poly := Polygon2D.new()
	poly.name = node_name
	poly.polygon = points
	poly.color = color
	poly.z_index = z_value
	parent.add_child(poly)
	return poly


func _depth_for_y(world_y: float) -> int:
	return clampi(ACTOR_DEPTH_BIAS + int(round(world_y)), -4095, 4095)
