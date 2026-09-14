extends Node2D

## Region-aware three-quarter placeholder scenery for Areas 2 and 3.
##
## Presentation only: no collision, navigation, combat geometry or room lifecycle
## authority lives here. Native combat/boss scenes and inherited service-room wrappers
## use the same renderer so later production art can replace these shapes without
## changing gameplay code.

@export_enum("auto", "yomori", "kagutsuchi") var region_profile := "auto"
@export_enum("combat", "rest", "shrine", "merchant", "miniboss", "boss", "treasure") var room_profile := "combat"
@export var show_floor_guides := true

const ACTOR_DEPTH_BIAS := 1000
const FLOOR_Z := -920
const FLOOR_DETAIL_Z := -910
const SHADOW := Color(0.018, 0.018, 0.022, 0.30)

var _region := "yomori"


func _ready() -> void:
	_region = _resolve_region()
	_build_floor()
	if _region == "yomori":
		_build_yomori_backdrop()
		_build_yomori_foreground()
	else:
		_build_kagutsuchi_backdrop()
		_build_kagutsuchi_foreground()
	_build_room_identity()


func _resolve_region() -> String:
	if region_profile != "auto":
		return region_profile
	if typeof(SceneRegistry) == TYPE_OBJECT:
		return "kagutsuchi" if int(SceneRegistry.get("active_area_id")) == 3 else "yomori"
	return "yomori"


func _ground_color() -> Color:
	return Color(0.075, 0.105, 0.100, 1.0) if _region == "yomori" else Color(0.115, 0.075, 0.075, 1.0)


func _ground_edge_color() -> Color:
	return Color(0.040, 0.060, 0.058, 1.0) if _region == "yomori" else Color(0.055, 0.032, 0.034, 1.0)


func _stone_color() -> Color:
	return Color(0.175, 0.205, 0.195, 1.0) if _region == "yomori" else Color(0.245, 0.205, 0.195, 1.0)


func _stone_dark() -> Color:
	return Color(0.080, 0.105, 0.100, 1.0) if _region == "yomori" else Color(0.105, 0.070, 0.070, 1.0)


func _accent() -> Color:
	return Color(0.28, 0.55, 0.48, 0.90) if _region == "yomori" else Color(0.62, 0.075, 0.060, 0.95)


func _secondary() -> Color:
	return Color(0.62, 0.52, 0.24, 0.90) if _region == "yomori" else Color(0.64, 0.45, 0.16, 0.95)


func _build_floor() -> void:
	var floor := Polygon2D.new()
	floor.name = "ProjectedRegionFloor"
	floor.polygon = PackedVector2Array([
		Vector2(-440.0, -238.0), Vector2(440.0, -238.0),
		Vector2(485.0, 238.0), Vector2(-485.0, 238.0),
	])
	floor.color = _ground_color()
	floor.z_index = FLOOR_Z
	add_child(floor)

	var rim := Line2D.new()
	rim.name = "ProjectedRegionFloorRim"
	rim.points = PackedVector2Array([
		Vector2(-440.0, -238.0), Vector2(440.0, -238.0), Vector2(485.0, 238.0),
		Vector2(-485.0, 238.0), Vector2(-440.0, -238.0),
	])
	rim.width = 8.0
	rim.default_color = _ground_edge_color()
	rim.z_index = FLOOR_DETAIL_Z
	add_child(rim)

	if show_floor_guides:
		for x: float in [-300.0, -150.0, 0.0, 150.0, 300.0]:
			var line := Line2D.new()
			line.points = PackedVector2Array([
				Vector2(x - 95.0, -225.0), Vector2(x + 115.0, 225.0),
			])
			line.width = 1.0
			line.default_color = Color(_stone_color().r, _stone_color().g, _stone_color().b, 0.08)
			line.z_index = FLOOR_DETAIL_Z
			add_child(line)

	_add_ground_ellipse(Vector2.ZERO, Vector2(122.0, 68.0), Color(_accent().r, _accent().g, _accent().b, 0.055), FLOOR_DETAIL_Z + 1)


func _build_yomori_backdrop() -> void:
	for spec: Dictionary in [
		{"p": Vector2(-320, -218), "w": 150.0, "h": 40.0},
		{"p": Vector2(-145, -222), "w": 105.0, "h": 31.0},
		{"p": Vector2(155, -222), "w": 120.0, "h": 35.0},
		{"p": Vector2(325, -217), "w": 155.0, "h": 44.0},
	]:
		_build_wall(spec.p, float(spec.w), float(spec.h))

	_build_crooked_tree(Vector2(-255, -188), -1.0, 1.05)
	_build_crooked_tree(Vector2(278, -190), 1.0, 0.92)
	_build_lantern(Vector2(-110, -203), 0.95)
	_build_lantern(Vector2(118, -205), 0.90)


func _build_yomori_foreground() -> void:
	_build_root_cluster(Vector2(-360, 215), -1.0, 1.15)
	_build_root_cluster(Vector2(350, 218), 1.0, 1.0)
	_build_reeds(Vector2(-292, 224), 1.2)
	_build_reeds(Vector2(300, 222), 1.0)


func _build_kagutsuchi_backdrop() -> void:
	# Court wall and elevated red/gold architecture establish the stricter Area 3 space.
	for x: float in [-330.0, -165.0, 0.0, 165.0, 330.0]:
		_build_court_wall(Vector2(x, -218.0), 150.0)
	_build_court_pillar(Vector2(-250, -190), 1.08)
	_build_court_pillar(Vector2(250, -190), 1.08)
	_build_banner(Vector2(-160, -205), -1.0)
	_build_banner(Vector2(160, -205), 1.0)
	_build_brazier(Vector2(-78, -195), 0.9)
	_build_brazier(Vector2(78, -195), 0.9)


func _build_kagutsuchi_foreground() -> void:
	_build_court_rail(Vector2(-300, 220), 1.0)
	_build_court_rail(Vector2(285, 220), 0.95)
	_build_brazier(Vector2(-365, 205), 1.05)
	_build_brazier(Vector2(365, 205), 1.05)


func _build_room_identity() -> void:
	match room_profile:
		"rest":
			_build_rest_identity()
		"shrine":
			_build_shrine_identity()
		"merchant":
			_build_merchant_identity()
		"miniboss":
			_build_miniboss_identity()
		"boss":
			_build_boss_identity()
		"treasure":
			_build_treasure_identity()
		_:
			pass


func _build_rest_identity() -> void:
	var center := Vector2(0, -34)
	_add_ground_ellipse(center, Vector2(38, 14), SHADOW, FLOOR_DETAIL_Z + 2)
	if _region == "yomori":
		_build_lantern(center, 1.25)
		_add_ground_ellipse(center, Vector2(74, 31), Color(0.26, 0.55, 0.48, 0.07), FLOOR_DETAIL_Z + 1)
	else:
		_build_brazier(center, 1.15)
		_add_ground_ellipse(center, Vector2(74, 31), Color(0.68, 0.18, 0.08, 0.07), FLOOR_DETAIL_Z + 1)


func _build_shrine_identity() -> void:
	var altar := _depth_node("RegionShrine", Vector2(0, -65))
	_add_poly(altar, PackedVector2Array([
		Vector2(-42, 0), Vector2(42, 0), Vector2(34, -36), Vector2(-34, -36),
	]), _stone_dark(), 0)
	_add_poly(altar, PackedVector2Array([
		Vector2(-35, -36), Vector2(35, -36), Vector2(27, -48), Vector2(-28, -48),
	]), _stone_color(), 1)
	_add_poly(altar, PackedVector2Array([
		Vector2(-8, -48), Vector2(8, -48), Vector2(5, -79), Vector2(-5, -79),
	]), _accent(), 2)
	_add_ground_ellipse(Vector2(0, -33), Vector2(72, 40), Color(_accent().r, _accent().g, _accent().b, 0.08), FLOOR_DETAIL_Z + 1)


func _build_merchant_identity() -> void:
	var stall := _depth_node("RegionMerchantStall", Vector2(0, -75))
	var wood := Color(0.105, 0.085, 0.072, 1.0) if _region == "yomori" else Color(0.19, 0.075, 0.050, 1.0)
	_add_poly(stall, PackedVector2Array([
		Vector2(-70, 0), Vector2(70, 0), Vector2(60, -60), Vector2(-60, -60),
	]), wood, 0)
	_add_poly(stall, PackedVector2Array([
		Vector2(-82, -61), Vector2(82, -61), Vector2(62, -82), Vector2(-62, -82),
	]), _accent(), 1)
	_build_lantern(Vector2(-92, -52), 0.82)
	_build_lantern(Vector2(92, -52), 0.82)


func _build_miniboss_identity() -> void:
	_add_ground_ring(Vector2.ZERO, 132.0, Color(_accent().r, _accent().g, _accent().b, 0.24), 2.5)
	for p: Vector2 in [Vector2(-270, -122), Vector2(270, -122), Vector2(-305, 130), Vector2(305, 130)]:
		if _region == "yomori":
			_build_crooked_tree(p, signf(p.x), 0.65)
		else:
			_build_court_pillar(p, 0.72)


func _build_boss_identity() -> void:
	_add_ground_ring(Vector2.ZERO, 165.0, Color(_accent().r, _accent().g, _accent().b, 0.30), 3.0)
	_add_ground_ring(Vector2.ZERO, 118.0, Color(_secondary().r, _secondary().g, _secondary().b, 0.15), 1.5)
	if _region == "yomori":
		_build_root_arch(Vector2(0, -185))
	else:
		_build_eclipse_gate(Vector2(0, -185))


func _build_treasure_identity() -> void:
	var chest := _depth_node("RegionTreasure", Vector2(0, -24))
	_add_poly(chest, PackedVector2Array([
		Vector2(-36, 0), Vector2(36, 0), Vector2(31, -28), Vector2(-31, -28),
	]), Color(0.20, 0.13, 0.06, 1.0), 0)
	_add_poly(chest, PackedVector2Array([
		Vector2(-32, -28), Vector2(32, -28), Vector2(25, -43), Vector2(-25, -43),
	]), _secondary(), 1)
	_add_ground_ellipse(Vector2(0, -16), Vector2(65, 33), Color(_secondary().r, _secondary().g, _secondary().b, 0.07), FLOOR_DETAIL_Z + 1)


func _build_wall(base: Vector2, width: float, height: float) -> void:
	var node := _depth_node("YomoriWall", base)
	_add_poly(node, PackedVector2Array([
		Vector2(-width * 0.5, 0), Vector2(width * 0.5, 0),
		Vector2(width * 0.46, -height), Vector2(-width * 0.46, -height * 0.92),
	]), _stone_dark(), 0)
	_add_poly(node, PackedVector2Array([
		Vector2(-width * 0.46, -height * 0.92), Vector2(width * 0.46, -height),
		Vector2(width * 0.39, -height - 8), Vector2(-width * 0.40, -height - 7),
	]), _stone_color(), 1)


func _build_crooked_tree(base: Vector2, side: float, scale_factor: float) -> void:
	var node := _depth_node("CrookedTree", base)
	node.scale = Vector2.ONE * scale_factor
	var wood := Color(0.075, 0.060, 0.055, 1.0)
	_add_poly(node, PackedVector2Array([
		Vector2(-8, 0), Vector2(8, 0), Vector2(10 + side * 10, -58),
		Vector2(3 + side * 18, -96), Vector2(-8 + side * 8, -60),
	]), wood, 0)
	var branch := Line2D.new()
	branch.points = PackedVector2Array([Vector2(side * 8, -58), Vector2(side * 38, -78), Vector2(side * 55, -70)])
	branch.width = 5.0
	branch.default_color = wood
	branch.z_index = 1
	node.add_child(branch)


func _build_root_cluster(base: Vector2, side: float, scale_factor: float) -> void:
	var node := _depth_node("ForegroundRoots", base)
	node.scale = Vector2.ONE * scale_factor
	var root := Color(0.065, 0.050, 0.045, 1.0)
	for offset: float in [-18.0, -7.0, 7.0, 18.0]:
		var line := Line2D.new()
		line.points = PackedVector2Array([
			Vector2(offset, 2), Vector2(offset + side * 12, -18), Vector2(offset + side * 5, -42),
		])
		line.width = 4.0
		line.default_color = root
		node.add_child(line)


func _build_reeds(base: Vector2, scale_factor: float) -> void:
	var node := _depth_node("MistReeds", base)
	node.scale = Vector2.ONE * scale_factor
	for offset: float in [-15, -8, 0, 8, 15]:
		var line := Line2D.new()
		line.points = PackedVector2Array([Vector2(offset, 0), Vector2(offset + sin(offset) * 4, -24 - absf(offset) * 0.25)])
		line.width = 2.0
		line.default_color = Color(0.18, 0.28, 0.22, 0.82)
		node.add_child(line)


func _build_lantern(base: Vector2, scale_factor: float) -> void:
	var node := _depth_node("GhostLantern", base)
	node.scale = Vector2.ONE * scale_factor
	_add_poly(node, PackedVector2Array([Vector2(-3, 0), Vector2(3, 0), Vector2(3, -48), Vector2(-3, -48)]), Color(0.08, 0.065, 0.05, 1.0), 0)
	_add_poly(node, PackedVector2Array([Vector2(-10, -47), Vector2(10, -47), Vector2(8, -66), Vector2(-8, -66)]), Color(0.68, 0.54, 0.22, 0.92), 1)
	_add_ground_ellipse(base + Vector2(0, -3), Vector2(26, 12), Color(0.32, 0.62, 0.50, 0.055), FLOOR_DETAIL_Z + 2)


func _build_court_wall(base: Vector2, width: float) -> void:
	var node := _depth_node("CourtWall", base)
	_add_poly(node, PackedVector2Array([
		Vector2(-width * 0.5, 0), Vector2(width * 0.5, 0), Vector2(width * 0.5, -42), Vector2(-width * 0.5, -42),
	]), _stone_dark(), 0)
	_add_poly(node, PackedVector2Array([
		Vector2(-width * 0.53, -42), Vector2(width * 0.53, -42), Vector2(width * 0.47, -53), Vector2(-width * 0.47, -53),
	]), Color(0.23, 0.06, 0.05, 1.0), 1)


func _build_court_pillar(base: Vector2, scale_factor: float) -> void:
	var node := _depth_node("CourtPillar", base)
	node.scale = Vector2.ONE * scale_factor
	_add_poly(node, PackedVector2Array([Vector2(-10, 0), Vector2(10, 0), Vector2(9, -86), Vector2(-9, -86)]), Color(0.27, 0.055, 0.045, 1.0), 0)
	_add_poly(node, PackedVector2Array([Vector2(-15, -88), Vector2(15, -88), Vector2(12, -98), Vector2(-12, -98)]), _secondary(), 1)


func _build_banner(base: Vector2, side: float) -> void:
	var node := _depth_node("CourtBanner", base)
	_add_poly(node, PackedVector2Array([Vector2(-3, 0), Vector2(3, 0), Vector2(3, -78), Vector2(-3, -78)]), Color(0.12, 0.05, 0.04, 1.0), 0)
	_add_poly(node, PackedVector2Array([
		Vector2(side * 4, -73), Vector2(side * 40, -70), Vector2(side * 35, -27), Vector2(side * 5, -32),
	]), Color(0.52, 0.045, 0.040, 0.94), 1)


func _build_brazier(base: Vector2, scale_factor: float) -> void:
	var node := _depth_node("CourtBrazier", base)
	node.scale = Vector2.ONE * scale_factor
	_add_poly(node, PackedVector2Array([Vector2(-13, 0), Vector2(13, 0), Vector2(9, -16), Vector2(-9, -16)]), Color(0.11, 0.08, 0.07, 1.0), 0)
	_add_poly(node, PackedVector2Array([Vector2(-7, -16), Vector2(0, -38), Vector2(7, -16)]), Color(0.92, 0.30, 0.08, 0.82), 1)


func _build_court_rail(base: Vector2, scale_factor: float) -> void:
	var node := _depth_node("ForegroundCourtRail", base)
	node.scale = Vector2.ONE * scale_factor
	var wood := Color(0.20, 0.055, 0.045, 1.0)
	draw_set_transform(Vector2.ZERO)
	for x: float in [-50, 0, 50]:
		_add_poly(node, PackedVector2Array([Vector2(x - 4, 0), Vector2(x + 4, 0), Vector2(x + 4, -43), Vector2(x - 4, -43)]), wood, 0)
	var rail := Line2D.new()
	rail.points = PackedVector2Array([Vector2(-58, -29), Vector2(58, -29)])
	rail.width = 7.0
	rail.default_color = wood
	rail.z_index = 1
	node.add_child(rail)


func _build_root_arch(base: Vector2) -> void:
	var node := _depth_node("TwinMawsRootArch", base)
	var root := Color(0.06, 0.048, 0.044, 1.0)
	for side: float in [-1.0, 1.0]:
		var line := Line2D.new()
		line.points = PackedVector2Array([
			Vector2(side * 92, 0), Vector2(side * 85, -64), Vector2(side * 55, -110), Vector2(side * 18, -132),
		])
		line.width = 13.0
		line.default_color = root
		node.add_child(line)


func _build_eclipse_gate(base: Vector2) -> void:
	var node := _depth_node("EclipseCourtGate", base)
	_add_poly(node, PackedVector2Array([Vector2(-105, 0), Vector2(-84, 0), Vector2(-82, -112), Vector2(-108, -112)]), Color(0.38, 0.045, 0.038, 1.0), 0)
	_add_poly(node, PackedVector2Array([Vector2(84, 0), Vector2(105, 0), Vector2(108, -112), Vector2(82, -112)]), Color(0.38, 0.045, 0.038, 1.0), 0)
	_add_poly(node, PackedVector2Array([Vector2(-140, -118), Vector2(140, -118), Vector2(128, -99), Vector2(-128, -99)]), _secondary(), 1)
	var eclipse := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in range(32):
		var angle := TAU * float(index) / 32.0
		points.append(Vector2(cos(angle), sin(angle)) * 26.0 + Vector2(0, -82))
	eclipse.polygon = points
	eclipse.color = Color(0.04, 0.025, 0.025, 0.92)
	eclipse.z_index = 2
	node.add_child(eclipse)


func _depth_node(node_name: String, base: Vector2) -> Node2D:
	var node := Node2D.new()
	node.name = node_name
	node.position = base
	node.z_index = clampi(ACTOR_DEPTH_BIAS + int(round(base.y)), -4095, 4095)
	add_child(node)
	return node


func _add_poly(parent: Node2D, points: PackedVector2Array, color: Color, local_z: int) -> void:
	var poly := Polygon2D.new()
	poly.polygon = points
	poly.color = color
	poly.z_index = local_z
	parent.add_child(poly)


func _add_ground_ellipse(center: Vector2, radii: Vector2, color: Color, z_value: int) -> void:
	var poly := Polygon2D.new()
	var points := PackedVector2Array()
	for index: int in range(28):
		var angle := TAU * float(index) / 28.0
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	poly.polygon = points
	poly.color = color
	poly.z_index = z_value
	add_child(poly)


func _add_ground_ring(center: Vector2, radius: float, color: Color, width: float) -> void:
	var line := Line2D.new()
	var points := PackedVector2Array()
	for index: int in range(41):
		var angle := TAU * float(index) / 40.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	line.points = points
	line.default_color = color
	line.width = width
	line.z_index = FLOOR_DETAIL_Z + 2
	add_child(line)