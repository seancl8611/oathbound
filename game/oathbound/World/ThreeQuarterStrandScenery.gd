extends Node2D

## Three-quarter placeholder presentation for the Strand/Hub.
##
## Every visual anchor matches the existing HubScene interaction coordinates. This node
## owns no Area2D/collision/menu/progression behavior; station and NPC gameplay remain in
## the original Hub children while final production art can replace these shapes later.

const ACTOR_DEPTH_BIAS := 1000
const FLOOR_Z := -930
const FLOOR_DETAIL_Z := -920

const GROUND := Color(0.070, 0.060, 0.065, 1.0)
const GROUND_EDGE := Color(0.030, 0.026, 0.032, 1.0)
const STONE := Color(0.20, 0.19, 0.20, 1.0)
const STONE_DARK := Color(0.085, 0.077, 0.085, 1.0)
const WOOD := Color(0.16, 0.085, 0.060, 1.0)
const BLOOD := Color(0.48, 0.045, 0.055, 0.90)
const FIRE := Color(0.93, 0.34, 0.10, 0.82)
const PAPER := Color(0.70, 0.65, 0.53, 0.90)
const MIST := Color(0.40, 0.44, 0.50, 0.11)
const GOLD := Color(0.62, 0.43, 0.16, 1.0)
const SHADOW := Color(0.015, 0.012, 0.018, 0.32)


func _ready() -> void:
	_build_floor()
	_build_cavern_wall()
	_build_boat(Vector2(76, 0))
	_build_forge(Vector2(73, -80))
	_build_discovery_board(Vector2(-90, 0))
	_build_bloodwell(Vector2(-46, 80))
	_build_merchant(Vector2(-7, -95))
	_build_blood_cavern(Vector2(1, -216))
	_build_blood_mirror(Vector2(1, -144))
	_build_npc(Vector2(-176, -54), "keeper")
	_build_npc(Vector2(-180, 20), "scribe")
	_build_npc(Vector2(154, -142), "raven")
	_build_npc(Vector2(118, -238), "undead_samurai")
	_build_npc(Vector2(146, -56), "smith")
	_build_npc(Vector2(-136, -126), "peddler")
	_build_foreground()


func _build_floor() -> void:
	var floor := Polygon2D.new()
	floor.name = "StrandProjectedFloor"
	floor.polygon = PackedVector2Array([
		Vector2(-285, -285), Vector2(285, -285), Vector2(335, 145), Vector2(-335, 145),
	])
	floor.color = GROUND
	floor.z_index = FLOOR_Z
	add_child(floor)

	var rim := Line2D.new()
	rim.points = PackedVector2Array([
		Vector2(-285, -285), Vector2(285, -285), Vector2(335, 145), Vector2(-335, 145), Vector2(-285, -285),
	])
	rim.width = 8.0
	rim.default_color = GROUND_EDGE
	rim.z_index = FLOOR_DETAIL_Z
	add_child(rim)

	for x: float in [-220.0, -110.0, 0.0, 110.0, 220.0]:
		var seam := Line2D.new()
		seam.points = PackedVector2Array([Vector2(x - 65, -272), Vector2(x + 78, 132)])
		seam.width = 1.0
		seam.default_color = Color(0.30, 0.27, 0.29, 0.07)
		seam.z_index = FLOOR_DETAIL_Z
		add_child(seam)

	_add_ground_ellipse(Vector2(-65, 55), Vector2(105, 52), Color(0.18, 0.08, 0.09, 0.10), FLOOR_DETAIL_Z + 1)
	_add_ground_ellipse(Vector2(115, -80), Vector2(92, 45), Color(0.16, 0.13, 0.11, 0.08), FLOOR_DETAIL_Z + 1)


func _build_cavern_wall() -> void:
	# The Strand is a refuge carved into stone rather than an open flat courtyard.
	for spec: Dictionary in [
		{"p": Vector2(-220, -267), "w": 130.0, "h": 62.0},
		{"p": Vector2(-82, -273), "w": 110.0, "h": 48.0},
		{"p": Vector2(95, -272), "w": 120.0, "h": 55.0},
		{"p": Vector2(225, -265), "w": 125.0, "h": 65.0},
	]:
		var node := _depth_node("StrandCavernWall", spec.p)
		var width := float(spec.w)
		var height := float(spec.h)
		_add_poly(node, PackedVector2Array([
			Vector2(-width * 0.5, 0), Vector2(width * 0.5, 0), Vector2(width * 0.42, -height), Vector2(-width * 0.45, -height * 0.88),
		]), STONE_DARK, 0)
		_add_poly(node, PackedVector2Array([
			Vector2(-width * 0.45, -height * 0.88), Vector2(width * 0.42, -height), Vector2(width * 0.34, -height - 12), Vector2(-width * 0.36, -height - 8),
		]), STONE, 1)


func _build_boat(base: Vector2) -> void:
	var node := _depth_node("StrandBoatProxy", base)
	_add_ground_ellipse(base, Vector2(45, 16), SHADOW, FLOOR_DETAIL_Z + 2)
	_add_poly(node, PackedVector2Array([
		Vector2(-38, 0), Vector2(40, 0), Vector2(29, -17), Vector2(-29, -17),
	]), Color(0.17, 0.09, 0.055, 1.0), 0)
	_add_poly(node, PackedVector2Array([
		Vector2(-27, -17), Vector2(28, -17), Vector2(21, -25), Vector2(-20, -25),
	]), WOOD, 1)
	var mast := Line2D.new()
	mast.points = PackedVector2Array([Vector2(4, -18), Vector2(4, -62)])
	mast.width = 3.0
	mast.default_color = WOOD
	node.add_child(mast)
	_add_poly(node, PackedVector2Array([Vector2(6, -59), Vector2(38, -49), Vector2(7, -31)]), Color(0.25, 0.20, 0.18, 0.86), 1)


func _build_forge(base: Vector2) -> void:
	var node := _depth_node("StrandForgeProxy", base)
	_add_poly(node, PackedVector2Array([
		Vector2(-30, 0), Vector2(30, 0), Vector2(25, -28), Vector2(-25, -28),
	]), Color(0.10, 0.08, 0.075, 1.0), 0)
	_add_poly(node, PackedVector2Array([Vector2(-16, -27), Vector2(0, -48), Vector2(16, -27)]), FIRE, 1)
	var anvil := _depth_node("StrandAnvil", base + Vector2(36, 5))
	_add_poly(anvil, PackedVector2Array([Vector2(-17, 0), Vector2(17, 0), Vector2(11, -9), Vector2(-10, -9)]), Color(0.28, 0.28, 0.29, 1.0), 0)
	_add_poly(anvil, PackedVector2Array([Vector2(-6, -9), Vector2(6, -9), Vector2(4, -23), Vector2(-4, -23)]), STONE_DARK, 0)


func _build_discovery_board(base: Vector2) -> void:
	var node := _depth_node("DiscoveryBoardProxy", base)
	for x: float in [-26.0, 26.0]:
		_add_poly(node, PackedVector2Array([Vector2(x - 3, 0), Vector2(x + 3, 0), Vector2(x + 3, -58), Vector2(x - 3, -58)]), WOOD, 0)
	_add_poly(node, PackedVector2Array([Vector2(-36, -55), Vector2(36, -55), Vector2(34, -91), Vector2(-34, -91)]), Color(0.20, 0.13, 0.09, 1.0), 1)
	for p: Vector2 in [Vector2(-20, -78), Vector2(3, -68), Vector2(19, -82)]:
		var note := Polygon2D.new()
		note.polygon = PackedVector2Array([p + Vector2(-7, -5), p + Vector2(7, -5), p + Vector2(6, 7), p + Vector2(-6, 7)])
		note.color = PAPER
		note.z_index = 2
		node.add_child(note)


func _build_bloodwell(base: Vector2) -> void:
	_add_ground_ellipse(base, Vector2(42, 22), Color(BLOOD.r, BLOOD.g, BLOOD.b, 0.12), FLOOR_DETAIL_Z + 2)
	var node := _depth_node("BloodwellProxy", base)
	for angle: float in [0.0, 0.9, 1.8, 2.7, 3.6, 4.5, 5.4]:
		var p := Vector2(cos(angle) * 27, sin(angle) * 11)
		var stone := Polygon2D.new()
		stone.polygon = PackedVector2Array([p + Vector2(-7, -4), p + Vector2(7, -4), p + Vector2(6, 4), p + Vector2(-6, 4)])
		stone.color = STONE_DARK
		node.add_child(stone)
	_add_ground_ellipse(base, Vector2(23, 9), Color(0.45, 0.025, 0.035, 0.85), FLOOR_DETAIL_Z + 3)


func _build_merchant(base: Vector2) -> void:
	var node := _depth_node("StrandMerchantProxy", base)
	_add_poly(node, PackedVector2Array([Vector2(-48, 0), Vector2(48, 0), Vector2(42, -48), Vector2(-42, -48)]), WOOD, 0)
	_add_poly(node, PackedVector2Array([Vector2(-60, -49), Vector2(60, -49), Vector2(45, -67), Vector2(-46, -67)]), Color(0.31, 0.055, 0.060, 1.0), 1)
	_add_poly(node, PackedVector2Array([Vector2(-32, -48), Vector2(-9, -48), Vector2(-12, -63), Vector2(-29, -63)]), PAPER, 2)
	_add_poly(node, PackedVector2Array([Vector2(6, -48), Vector2(29, -48), Vector2(26, -63), Vector2(9, -63)]), GOLD, 2)


func _build_blood_cavern(base: Vector2) -> void:
	var node := _depth_node("BloodCavernEntranceProxy", base)
	_add_ground_ellipse(base + Vector2(0, 2), Vector2(54, 20), SHADOW, FLOOR_DETAIL_Z + 2)
	_add_poly(node, PackedVector2Array([
		Vector2(-50, 0), Vector2(50, 0), Vector2(44, -68), Vector2(28, -91), Vector2(-27, -91), Vector2(-44, -68),
	]), STONE_DARK, 0)
	_add_poly(node, PackedVector2Array([
		Vector2(-28, -2), Vector2(28, -2), Vector2(24, -57), Vector2(13, -73), Vector2(-13, -73), Vector2(-24, -57),
	]), Color(0.015, 0.010, 0.015, 1.0), 1)
	_add_poly(node, PackedVector2Array([Vector2(-10, -76), Vector2(10, -76), Vector2(6, -91), Vector2(-6, -91)]), BLOOD, 2)


func _build_blood_mirror(base: Vector2) -> void:
	var node := _depth_node("BloodMirrorProxy", base)
	_add_poly(node, PackedVector2Array([Vector2(-23, 0), Vector2(23, 0), Vector2(20, -50), Vector2(-20, -50)]), Color(0.10, 0.055, 0.065, 1.0), 0)
	_add_poly(node, PackedVector2Array([Vector2(-16, -8), Vector2(16, -8), Vector2(14, -44), Vector2(-14, -44)]), Color(0.30, 0.035, 0.06, 0.74), 1)
	_add_ground_ellipse(base + Vector2(0, -2), Vector2(34, 14), Color(BLOOD.r, BLOOD.g, BLOOD.b, 0.08), FLOOR_DETAIL_Z + 2)


func _build_npc(base: Vector2, npc_id: String) -> void:
	var node := _depth_node("NPC_%s" % npc_id, base)
	var scale_factor := 1.0
	var body := Color(0.18, 0.16, 0.17, 1.0)
	var accent := Color(0.42, 0.12, 0.12, 1.0)
	match npc_id:
		"keeper":
			scale_factor = 1.13
			body = Color(0.14, 0.12, 0.14, 1.0)
			accent = BLOOD
		"scribe":
			body = Color(0.17, 0.17, 0.20, 1.0)
			accent = PAPER
		"raven":
			body = Color(0.07, 0.075, 0.085, 1.0)
			accent = Color(0.38, 0.38, 0.46, 1.0)
		"undead_samurai":
			scale_factor = 1.12
			body = Color(0.20, 0.16, 0.14, 1.0)
			accent = Color(0.48, 0.08, 0.07, 1.0)
		"smith":
			scale_factor = 1.08
			body = Color(0.22, 0.14, 0.10, 1.0)
			accent = FIRE
		"peddler":
			body = Color(0.15, 0.14, 0.12, 1.0)
			accent = GOLD
	node.scale = Vector2.ONE * scale_factor
	_add_ground_ellipse(base, Vector2(13, 6), SHADOW, FLOOR_DETAIL_Z + 2)
	_add_poly(node, PackedVector2Array([Vector2(-8, 0), Vector2(8, 0), Vector2(7, -30), Vector2(-7, -30)]), body, 0)
	var head := Polygon2D.new()
	var head_points := PackedVector2Array()
	for index: int in range(16):
		var angle := TAU * float(index) / 16.0
		head_points.append(Vector2(cos(angle), sin(angle)) * 5.5 + Vector2(0, -36))
	head.polygon = head_points
	head.color = body.lightened(0.20)
	head.z_index = 1
	node.add_child(head)
	_add_poly(node, PackedVector2Array([Vector2(-9, -23), Vector2(9, -23), Vector2(7, -18), Vector2(-7, -18)]), accent, 2)
	if npc_id == "raven":
		_add_poly(node, PackedVector2Array([Vector2(2, -39), Vector2(15, -36), Vector2(4, -33)]), Color(0.045, 0.045, 0.055, 1.0), 2)
	elif npc_id == "undead_samurai":
		draw_sword(node)
	elif npc_id == "scribe":
		_add_poly(node, PackedVector2Array([Vector2(8, -16), Vector2(19, -20), Vector2(18, -10), Vector2(8, -9)]), PAPER, 2)


func draw_sword(parent: Node2D) -> void:
	var blade := Line2D.new()
	blade.points = PackedVector2Array([Vector2(8, -18), Vector2(23, -39)])
	blade.width = 2.0
	blade.default_color = Color(0.62, 0.62, 0.61, 1.0)
	blade.z_index = 2
	parent.add_child(blade)


func _build_foreground() -> void:
	for base: Vector2 in [Vector2(-290, 135), Vector2(290, 135)]:
		var node := _depth_node("ForegroundCandleCluster", base)
		for x: float in [-14.0, 0.0, 14.0]:
			var stem := Line2D.new()
			stem.points = PackedVector2Array([Vector2(x, 0), Vector2(x, -18)])
			stem.width = 2.0
			stem.default_color = Color(0.28, 0.23, 0.18, 1.0)
			node.add_child(stem)
			var flame := Polygon2D.new()
			flame.polygon = PackedVector2Array([Vector2(x - 3, -18), Vector2(x, -27), Vector2(x + 3, -18)])
			flame.color = FIRE
			flame.z_index = 1
			node.add_child(flame)


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
