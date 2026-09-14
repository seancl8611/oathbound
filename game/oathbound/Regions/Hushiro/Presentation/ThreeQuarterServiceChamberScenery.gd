extends Node2D

## Reusable Area 1 placeholder scenery for non-combat chambers.
##
## Hushiro wrappers inherit the existing shared chamber scenes, then add this purely
## visual layer. Existing interaction nodes, gates, rewards, boss/miniboss controllers
## and collision remain untouched.

@export_enum("rest", "shrine", "merchant", "miniboss", "boss", "treasure") var profile := "rest"

const FLOOR_Z := -920
const FLOOR_DETAIL_Z := -910
const ACTOR_DEPTH_BIAS := 1000

const GROUND := Color(0.105, 0.087, 0.080, 1.0)
const GROUND_EDGE := Color(0.055, 0.047, 0.046, 1.0)
const STONE := Color(0.205, 0.205, 0.195, 1.0)
const STONE_DARK := Color(0.105, 0.108, 0.105, 1.0)
const WOOD := Color(0.19, 0.105, 0.076, 1.0)
const RED := Color(0.43, 0.065, 0.055, 1.0)
const PAPER := Color(0.72, 0.67, 0.53, 0.85)
const FIRE := Color(0.92, 0.40, 0.12, 0.78)
const MIST := Color(0.58, 0.64, 0.63, 0.13)
const GOLD := Color(0.65, 0.47, 0.17, 1.0)
const SHADOW := Color(0.02, 0.018, 0.02, 0.30)


func _ready() -> void:
	_build_common_room()
	match profile:
		"rest":
			_build_rest()
		"shrine":
			_build_shrine()
		"merchant":
			_build_merchant()
		"miniboss":
			_build_miniboss()
		"boss":
			_build_boss()
		"treasure":
			_build_treasure()


func _build_common_room() -> void:
	var floor := Polygon2D.new()
	floor.name = "ServiceFloor"
	floor.polygon = PackedVector2Array([
		Vector2(-390.0, -215.0), Vector2(390.0, -215.0),
		Vector2(435.0, 215.0), Vector2(-435.0, 215.0),
	])
	floor.color = GROUND
	floor.z_index = FLOOR_Z
	add_child(floor)

	var rim := Line2D.new()
	rim.name = "ServiceFloorRim"
	rim.points = PackedVector2Array([
		Vector2(-390.0, -215.0), Vector2(390.0, -215.0), Vector2(435.0, 215.0),
		Vector2(-435.0, 215.0), Vector2(-390.0, -215.0),
	])
	rim.width = 7.0
	rim.default_color = GROUND_EDGE
	rim.z_index = FLOOR_DETAIL_Z
	add_child(rim)

	for x: float in [-255.0, -85.0, 85.0, 255.0]:
		var seam := Line2D.new()
		seam.points = PackedVector2Array([Vector2(x - 65.0, -205.0), Vector2(x + 75.0, 205.0)])
		seam.default_color = Color(0.30, 0.28, 0.24, 0.065)
		seam.width = 1.0
		seam.z_index = FLOOR_DETAIL_Z
		add_child(seam)

	# Haze is represented by explicit negative-z ground polygons instead of `_draw()` on
	# this root. That guarantees it can never paint over Akio, enemies or interaction UI.
	_add_floor_ellipse(Vector2(-155.0, 145.0), Vector2(88.0, 18.0), MIST, FLOOR_DETAIL_Z + 1)
	_add_floor_ellipse(Vector2(185.0, -120.0), Vector2(70.0, 14.0), Color(MIST.r, MIST.g, MIST.b, 0.08), FLOOR_DETAIL_Z + 1)

	# Far wall shapes give every service room a stable visual horizon.
	for spec: Dictionary in [
		{"p": Vector2(-285.0, -205.0), "w": 145.0, "h": 38.0},
		{"p": Vector2(-110.0, -209.0), "w": 120.0, "h": 31.0},
		{"p": Vector2(125.0, -208.0), "w": 135.0, "h": 34.0},
		{"p": Vector2(302.0, -204.0), "w": 135.0, "h": 42.0},
	]:
		_build_wall(spec.p, float(spec.w), float(spec.h))

	_build_foreground_post(Vector2(-350.0, 205.0), -1.0)
	_build_foreground_post(Vector2(350.0, 205.0), 1.0)


func _build_rest() -> void:
	# Rest rooms center around a low ember basin rather than another menu-like marker.
	_add_depth_ellipse(Vector2(0.0, -38.0), Vector2(34.0, 13.0), SHADOW, -2)
	for angle: float in [0.0, 0.9, 1.8, 2.7, 3.6, 4.5, 5.4]:
		var p := Vector2(cos(angle) * 20.0, -38.0 + sin(angle) * 8.0)
		_add_depth_ellipse(p, Vector2(7.0, 4.0), STONE_DARK, 0)
	var fire := _node_at_depth("RestEmber", Vector2(0.0, -42.0))
	_add_local_polygon(fire, PackedVector2Array([
		Vector2(-8, 0), Vector2(-4, -22), Vector2(1, -11), Vector2(6, -28), Vector2(10, 0)
	]), FIRE, 1)
	_add_local_polygon(fire, PackedVector2Array([
		Vector2(-4, 0), Vector2(0, -15), Vector2(4, 0)
	]), Color(1.0, 0.70, 0.25, 0.80), 2)
	_add_depth_rect(Vector2(-80.0, 28.0), Vector2(62.0, 22.0), Color(0.18, 0.12, 0.09, 1.0), 0)
	_add_depth_rect(Vector2(82.0, 42.0), Vector2(48.0, 18.0), Color(0.14, 0.105, 0.085, 1.0), 0)


func _build_shrine() -> void:
	var altar := _node_at_depth("BloodShrine", Vector2(0.0, -72.0))
	_add_local_polygon(altar, PackedVector2Array([
		Vector2(-40, 0), Vector2(40, 0), Vector2(31, -35), Vector2(-31, -35)
	]), STONE_DARK, 0)
	_add_local_polygon(altar, PackedVector2Array([
		Vector2(-34, -35), Vector2(34, -35), Vector2(25, -46), Vector2(-25, -46)
	]), STONE, 1)
	_add_local_polygon(altar, PackedVector2Array([
		Vector2(-8, -47), Vector2(8, -47), Vector2(5, -76), Vector2(-6, -76)
	]), RED, 2)
	_add_local_polygon(altar, PackedVector2Array([
		Vector2(-5, -76), Vector2(5, -76), Vector2(0, -90)
	]), Color(0.68, 0.07, 0.055, 0.85), 3)
	for x: float in [-52.0, 52.0]:
		_build_talisman_post(Vector2(x, -61.0))
	_draw_ground_circle_decal(Vector2(0.0, -36.0), 64.0, Color(0.44, 0.055, 0.05, 0.18))


func _build_merchant() -> void:
	var stall := _node_at_depth("MerchantStall", Vector2(0.0, -78.0))
	_add_local_polygon(stall, PackedVector2Array([
		Vector2(-66, 0), Vector2(66, 0), Vector2(58, -62), Vector2(-58, -62)
	]), WOOD, 0)
	_add_local_polygon(stall, PackedVector2Array([
		Vector2(-78, -62), Vector2(77, -62), Vector2(58, -82), Vector2(-60, -82)
	]), Color(0.24, 0.055, 0.05, 1.0), 1)
	for x: float in [-42.0, 0.0, 42.0]:
		_add_local_polygon(stall, PackedVector2Array([
			Vector2(x - 12, -61), Vector2(x + 12, -61), Vector2(x + 8, -80), Vector2(x - 8, -80)
		]), RED if int(x) % 84 == 0 else Color(0.32, 0.24, 0.16, 1.0), 2)
	_add_depth_rect(Vector2(-105.0, -18.0), Vector2(36.0, 30.0), Color(0.15, 0.10, 0.07, 1.0), 0)
	_add_depth_rect(Vector2(110.0, -8.0), Vector2(42.0, 26.0), Color(0.17, 0.11, 0.07, 1.0), 0)
	_build_lantern(Vector2(-78.0, -54.0))
	_build_lantern(Vector2(78.0, -54.0))


func _build_miniboss() -> void:
	_draw_ground_circle_decal(Vector2.ZERO, 125.0, Color(0.42, 0.08, 0.06, 0.13))
	_draw_ground_circle_outline(Vector2.ZERO, 125.0, Color(0.52, 0.15, 0.10, 0.26), 2.0)
	for p: Vector2 in [Vector2(-265, -125), Vector2(265, -125), Vector2(-305, 125), Vector2(305, 125)]:
		_build_standing_stone(p, 0.9)


func _build_boss() -> void:
	_draw_ground_circle_decal(Vector2(0.0, 10.0), 155.0, Color(0.36, 0.045, 0.04, 0.14))
	_draw_ground_circle_outline(Vector2(0.0, 10.0), 155.0, Color(0.60, 0.10, 0.075, 0.28), 3.0)
	var gate := _node_at_depth("BossGate", Vector2(0.0, -183.0))
	_add_local_polygon(gate, PackedVector2Array([
		Vector2(-112, 3), Vector2(-90, 3), Vector2(-88, -112), Vector2(-114, -112)
	]), RED, 0)
	_add_local_polygon(gate, PackedVector2Array([
		Vector2(90, 3), Vector2(112, 3), Vector2(114, -112), Vector2(88, -112)
	]), RED, 0)
	_add_local_polygon(gate, PackedVector2Array([
		Vector2(-148, -119), Vector2(148, -119), Vector2(135, -100), Vector2(-135, -100)
	]), Color(0.24, 0.035, 0.035, 1.0), 1)
	for x: float in [-142.0, 142.0]:
		_build_banner(Vector2(x, -145.0))


func _build_treasure() -> void:
	var chest := _node_at_depth("TreasureChestProxy", Vector2(0.0, -25.0))
	_add_local_polygon(chest, PackedVector2Array([
		Vector2(-34, 0), Vector2(34, 0), Vector2(31, -26), Vector2(-31, -26)
	]), Color(0.24, 0.135, 0.055, 1.0), 0)
	_add_local_polygon(chest, PackedVector2Array([
		Vector2(-32, -26), Vector2(32, -26), Vector2(24, -42), Vector2(-24, -42)
	]), Color(0.30, 0.17, 0.065, 1.0), 1)
	_add_local_polygon(chest, PackedVector2Array([
		Vector2(-4, -22), Vector2(5, -22), Vector2(5, -12), Vector2(-4, -12)
	]), GOLD, 2)
	_draw_ground_circle_decal(Vector2(0.0, -18.0), 60.0, Color(GOLD.r, GOLD.g, GOLD.b, 0.08))


func _build_wall(base: Vector2, width: float, height: float) -> void:
	var node := _node_at_depth("ServiceWall", base)
	_add_local_polygon(node, PackedVector2Array([
		Vector2(-width * 0.5, 0), Vector2(width * 0.5, 0),
		Vector2(width * 0.46, -height), Vector2(-width * 0.46, -height * 0.92)
	]), STONE_DARK, 0)
	_add_local_polygon(node, PackedVector2Array([
		Vector2(-width * 0.46, -height * 0.92), Vector2(width * 0.46, -height),
		Vector2(width * 0.39, -height - 8), Vector2(-width * 0.40, -height - 7)
	]), STONE, 1)


func _build_foreground_post(base: Vector2, side: float) -> void:
	var node := _node_at_depth("ForegroundPost", base)
	_add_local_polygon(node, PackedVector2Array([
		Vector2(-7, 0), Vector2(7, 0), Vector2(8, -62), Vector2(-8, -62)
	]), WOOD, 0)
	var grass := Node2D.new()
	grass.position = base + Vector2(side * 15.0, 0)
	grass.z_index = _depth_for_y(base.y) + 2
	add_child(grass)
	for angle: float in [-0.8, -0.35, 0.15, 0.55, 0.9]:
		var end := Vector2(sin(angle) * 16.0, -22.0 - absf(cos(angle)) * 7.0)
		var blade := Line2D.new()
		blade.points = PackedVector2Array([Vector2.ZERO, end])
		blade.default_color = Color(0.20, 0.22, 0.13, 0.78)
		blade.width = 2.0
		grass.add_child(blade)


func _build_talisman_post(base: Vector2) -> void:
	var node := _node_at_depth("TalismanPost", base)
	_add_local_polygon(node, PackedVector2Array([Vector2(-4, 0), Vector2(4, 0), Vector2(4, -52), Vector2(-4, -52)]), WOOD, 0)
	_add_local_polygon(node, PackedVector2Array([Vector2(-7, -47), Vector2(7, -47), Vector2(6, -27), Vector2(-6, -28)]), PAPER, 1)


func _build_lantern(base: Vector2) -> void:
	var node := _node_at_depth("Lantern", base)
	_add_local_polygon(node, PackedVector2Array([Vector2(-3, 0), Vector2(3, 0), Vector2(3, -45), Vector2(-3, -45)]), WOOD, 0)
	_add_local_polygon(node, PackedVector2Array([Vector2(-9, -45), Vector2(9, -45), Vector2(7, -62), Vector2(-7, -62)]), Color(0.70, 0.25, 0.10, 0.92), 1)


func _build_standing_stone(base: Vector2, scale_factor: float) -> void:
	var node := _node_at_depth("StandingStone", base)
	node.scale = Vector2.ONE * scale_factor
	_add_local_polygon(node, PackedVector2Array([
		Vector2(-16, 0), Vector2(16, 0), Vector2(13, -57), Vector2(-9, -72), Vector2(-19, -44)
	]), STONE_DARK, 0)
	_add_local_polygon(node, PackedVector2Array([
		Vector2(-9, -72), Vector2(13, -57), Vector2(7, -66), Vector2(-5, -79)
	]), STONE, 1)


func _build_banner(base: Vector2) -> void:
	var node := _node_at_depth("BossBanner", base)
	_add_local_polygon(node, PackedVector2Array([Vector2(-3, 0), Vector2(3, 0), Vector2(3, -82), Vector2(-3, -82)]), WOOD, 0)
	_add_local_polygon(node, PackedVector2Array([
		Vector2(4, -76), Vector2(35, -73), Vector2(31, -29), Vector2(5, -35)
	]), Color(0.38, 0.035, 0.035, 0.90), 1)


func _node_at_depth(node_name: String, base: Vector2) -> Node2D:
	var node := Node2D.new()
	node.name = node_name
	node.position = base
	node.z_index = _depth_for_y(base.y)
	add_child(node)
	return node


func _depth_for_y(y: float) -> int:
	return clampi(ACTOR_DEPTH_BIAS + int(round(y)), -4095, 4095)


func _add_local_polygon(parent: Node2D, points: PackedVector2Array, color: Color, local_z: int) -> void:
	var polygon := Polygon2D.new()
	polygon.polygon = points
	polygon.color = color
	polygon.z_index = local_z
	parent.add_child(polygon)


func _add_floor_ellipse(center: Vector2, radii: Vector2, color: Color, z_value: int) -> void:
	var node := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in range(28):
		var angle := TAU * float(index) / 28.0
		points.append(Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	node.polygon = points
	node.color = color
	node.position = center
	node.z_index = z_value
	add_child(node)


func _add_depth_ellipse(center: Vector2, radii: Vector2, color: Color, local_z: int) -> void:
	var node := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in range(24):
		var angle := TAU * float(index) / 24.0
		points.append(Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	node.polygon = points
	node.color = color
	node.position = center
	node.z_index = _depth_for_y(center.y) + local_z
	add_child(node)


func _add_depth_rect(center: Vector2, size: Vector2, color: Color, local_z: int) -> void:
	var node := Polygon2D.new()
	var half := size * 0.5
	node.polygon = PackedVector2Array([
		Vector2(-half.x, -half.y), Vector2(half.x, -half.y), Vector2(half.x, half.y), Vector2(-half.x, half.y)
	])
	node.color = color
	node.position = center
	node.z_index = _depth_for_y(center.y) + local_z
	add_child(node)


func _draw_ground_circle_decal(center: Vector2, radius: float, color: Color) -> void:
	var node := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in range(40):
		var angle := TAU * float(index) / 40.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	node.polygon = points
	node.color = color
	node.z_index = FLOOR_DETAIL_Z
	add_child(node)


func _draw_ground_circle_outline(center: Vector2, radius: float, color: Color, width: float) -> void:
	var line := Line2D.new()
	var points := PackedVector2Array()
	for index: int in range(41):
		var angle := TAU * float(index) / 40.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	line.points = points
	line.default_color = color
	line.width = width
	line.z_index = FLOOR_DETAIL_Z + 1
	add_child(line)
