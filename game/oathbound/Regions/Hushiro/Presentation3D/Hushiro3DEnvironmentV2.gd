extends Node3D

## Second-pass Hushiro combat courtyard built from one coherent composition rather than a
## scatter of equally weighted blocks. The authoritative room is still planar 2D; every
## mesh here is presentation-only and intentionally has no collision.
##
## Composition rules:
## - one broad, quiet combat floor matching the gameplay rectangle
## - strong far-edge torii/village silhouette so the lower camera actually reads depth
## - side ruins frame the arena instead of occupying its center
## - small low foreground anchors live only in the corners
## - floor detail is thin/low-contrast and cannot compete with actors or telegraphs

var _ground_material: StandardMaterial3D
var _courtyard_material: StandardMaterial3D
var _seam_material: StandardMaterial3D
var _stone_material: StandardMaterial3D
var _stone_dark_material: StandardMaterial3D
var _wood_material: StandardMaterial3D
var _wood_dark_material: StandardMaterial3D
var _torii_material: StandardMaterial3D
var _roof_material: StandardMaterial3D
var _moss_material: StandardMaterial3D
var _blood_material: StandardMaterial3D
var _ember_material: StandardMaterial3D
var _paper_material: StandardMaterial3D

var _ritual_accent_count := 0
var _warm_light_count := 0
var _foreground_occluder_count := 0
var _landmark_count := 0


func _ready() -> void:
	_build_materials()
	_build_combat_floor()
	_build_far_village_frame()
	_build_ruined_torii()
	_build_left_shrine_frame()
	_build_right_house_frame()
	_build_corner_foreground()
	_build_perimeter_debris()
	_build_ritual_details()
	_build_lighting()


func _build_materials() -> void:
	# Raise the midtones compared with the rejected first slice. Silhouettes should read
	# under moonlight without flattening the dark-fantasy palette into daylight.
	_ground_material = _material(Color(0.075, 0.068, 0.072, 1.0), 0.98)
	_courtyard_material = _material(Color(0.145, 0.135, 0.132, 1.0), 0.96)
	_seam_material = _material(Color(0.075, 0.071, 0.073, 1.0), 0.99)
	_stone_material = _material(Color(0.27, 0.255, 0.235, 1.0), 0.92)
	_stone_dark_material = _material(Color(0.11, 0.105, 0.105, 1.0), 0.97)
	_wood_material = _material(Color(0.19, 0.095, 0.065, 1.0), 0.91)
	_wood_dark_material = _material(Color(0.070, 0.045, 0.042, 1.0), 0.97)
	_torii_material = _material(Color(0.36, 0.045, 0.035, 1.0), 0.82)
	_roof_material = _material(Color(0.060, 0.064, 0.068, 1.0), 0.98)
	_moss_material = _material(Color(0.080, 0.115, 0.078, 1.0), 0.99)
	_blood_material = _material(Color(0.31, 0.018, 0.022, 1.0), 0.84)
	_paper_material = _material(Color(0.60, 0.55, 0.43, 1.0), 0.94)
	_ember_material = _material(Color(0.72, 0.12, 0.025, 1.0), 0.62)
	_ember_material.emission_enabled = true
	_ember_material.emission = Color(0.90, 0.10, 0.025, 1.0)
	_ember_material.emission_energy_multiplier = 2.8


func _build_combat_floor() -> void:
	# Earth apron gives the courtyard a readable boundary while the playable surface itself
	# is a single near-flush slab. No checkerboard of meter-wide blocks remains.
	var earth := PlaneMesh.new()
	earth.size = Vector2(22.0, 14.0)
	_add_mesh(self, "Ground", earth, Vector3.ZERO, _ground_material)

	_add_box(self, "CombatCourtyard", Vector3(13.2, 0.045, 7.7), Vector3(0.0, 0.015, 0.0), _courtyard_material)

	# Thin seams imply weathered stone courses without becoming dominant geometric tiles.
	for z: float in [-2.55, -1.28, 0.0, 1.28, 2.55]:
		_add_box(self, "CourtyardSeamZ", Vector3(12.4, 0.012, 0.035), Vector3(0.0, 0.045, z), _seam_material)
	for x: float in [-4.8, -2.4, 0.0, 2.4, 4.8]:
		var seam := _add_box(self, "CourtyardSeamX", Vector3(0.035, 0.012, 7.0), Vector3(x, 0.046, 0.0), _seam_material)
		seam.rotation.y = 0.025 * x

	# A subtle worn center keeps the eye on combat and is deliberately lower contrast than
	# actors/telegraphs. The shape is one continuous patch, not a visual obstacle.
	_add_box(self, "WornCombatPatch", Vector3(4.4, 0.010, 2.7), Vector3(0.0, 0.052, 0.20), _stone_dark_material)

	# Perimeter curb sits outside the actual pressure space and helps the courtyard read as
	# a place rather than an infinite plane.
	_add_box(self, "NorthCurb", Vector3(13.7, 0.20, 0.26), Vector3(0.0, 0.11, -4.05), _stone_dark_material)
	_add_box(self, "WestCurb", Vector3(0.26, 0.18, 7.5), Vector3(-6.85, 0.10, 0.0), _stone_dark_material)
	_add_box(self, "EastCurb", Vector3(0.26, 0.18, 7.5), Vector3(6.85, 0.10, 0.0), _stone_dark_material)


func _build_far_village_frame() -> void:
	# The far wall is intentionally discontinuous around the torii opening. At the flatter
	# camera angle these vertical masses establish foreground/midground/background layers.
	_add_box(self, "FarWallLeft", Vector3(5.2, 1.25, 0.42), Vector3(-4.30, 0.62, -5.40), _stone_dark_material)
	_add_box(self, "FarWallRight", Vector3(5.0, 1.10, 0.42), Vector3(4.40, 0.55, -5.42), _stone_dark_material)
	_add_box(self, "FarWallTopLeft", Vector3(2.2, 0.45, 0.38), Vector3(-5.45, 1.48, -5.39), _stone_material)
	_add_box(self, "FarWallTopRight", Vector3(1.8, 0.38, 0.38), Vector3(5.55, 1.31, -5.41), _stone_material)

	# Roof silhouettes behind the wall create a village horizon instead of isolated cubes.
	var far_house_l := Node3D.new()
	far_house_l.name = "FarHouseLeft"
	far_house_l.position = Vector3(-5.15, 0.0, -6.35)
	add_child(far_house_l)
	_add_box(far_house_l, "Wall", Vector3(2.8, 2.2, 1.7), Vector3(0.0, 1.10, 0.0), _wood_dark_material)
	var roof_l := _add_box(far_house_l, "Roof", Vector3(3.5, 0.20, 2.3), Vector3(0.0, 2.30, 0.0), _roof_material)
	roof_l.rotation.z = -0.055

	var far_house_r := Node3D.new()
	far_house_r.name = "FarHouseRight"
	far_house_r.position = Vector3(5.20, 0.0, -6.25)
	add_child(far_house_r)
	_add_box(far_house_r, "Wall", Vector3(2.6, 1.85, 1.8), Vector3(0.0, 0.92, 0.0), _wood_dark_material)
	var roof_r := _add_box(far_house_r, "Roof", Vector3(3.3, 0.20, 2.35), Vector3(0.0, 1.98, 0.0), _roof_material)
	roof_r.rotation.z = 0.07


func _build_ruined_torii() -> void:
	var torii := Node3D.new()
	torii.name = "RuinedTorii"
	torii.position = Vector3(0.0, 0.0, -5.05)
	add_child(torii)

	_add_box(torii, "LeftPillar", Vector3(0.30, 3.65, 0.34), Vector3(-1.42, 1.82, 0.0), _torii_material)
	_add_box(torii, "RightPillar", Vector3(0.30, 3.35, 0.34), Vector3(1.42, 1.67, 0.0), _torii_material).rotation.z = 0.035
	_add_box(torii, "CrossBeam", Vector3(3.75, 0.30, 0.40), Vector3(0.0, 3.08, 0.0), _torii_material)
	var top := _add_box(torii, "UpperBeam", Vector3(4.55, 0.20, 0.34), Vector3(-0.18, 3.52, 0.0), _wood_dark_material)
	top.rotation.z = -0.045
	var cap := _add_box(torii, "BrokenCap", Vector3(1.15, 0.17, 0.30), Vector3(1.78, 3.77, 0.02), _wood_material)
	cap.rotation.z = 0.17

	# Hanging paper and rope make the torii readable as a shrine threshold at gameplay size.
	_add_box(torii, "TalismanL", Vector3(0.20, 0.48, 0.025), Vector3(-0.52, 2.74, -0.18), _paper_material).rotation.z = -0.06
	_add_box(torii, "TalismanR", Vector3(0.18, 0.40, 0.025), Vector3(0.58, 2.78, -0.18), _paper_material).rotation.z = 0.08
	_landmark_count += 1


func _build_left_shrine_frame() -> void:
	var shrine := Node3D.new()
	shrine.name = "CollapsedWaysideShrine"
	shrine.position = Vector3(-7.55, 0.0, -1.85)
	shrine.rotation.y = -0.18
	add_child(shrine)

	_add_box(shrine, "Plinth", Vector3(2.35, 0.48, 2.0), Vector3(0.0, 0.24, 0.0), _stone_dark_material)
	_add_box(shrine, "BackWall", Vector3(2.05, 2.25, 0.20), Vector3(0.0, 1.34, 0.72), _wood_material)
	_add_box(shrine, "PostL", Vector3(0.20, 2.55, 0.22), Vector3(-0.72, 1.48, -0.42), _wood_dark_material)
	_add_box(shrine, "PostR", Vector3(0.20, 1.92, 0.22), Vector3(0.72, 1.17, -0.38), _wood_dark_material).rotation.z = 0.15
	var roof := _add_box(shrine, "BrokenRoof", Vector3(2.90, 0.20, 2.25), Vector3(-0.12, 2.47, 0.0), _roof_material)
	roof.rotation.z = -0.10
	_add_box(shrine, "OfferingStone", Vector3(0.70, 0.62, 0.55), Vector3(0.0, 0.52, -0.78), _stone_material)
	_add_box(shrine, "BloodBinding", Vector3(0.72, 0.07, 0.58), Vector3(0.0, 0.84, -0.78), _blood_material)
	_ritual_accent_count += 1
	_landmark_count += 1


func _build_right_house_frame() -> void:
	var ruin := Node3D.new()
	ruin.name = "RightVillageRuin"
	ruin.position = Vector3(7.55, 0.0, 0.55)
	ruin.rotation.y = 0.16
	add_child(ruin)

	_add_box(ruin, "Foundation", Vector3(2.35, 0.50, 2.20), Vector3(0.0, 0.25, 0.0), _stone_dark_material)
	_add_box(ruin, "RearWall", Vector3(2.20, 2.20, 0.18), Vector3(0.0, 1.30, 0.84), _wood_dark_material)
	_add_box(ruin, "OpenPost", Vector3(0.22, 2.70, 0.22), Vector3(-0.80, 1.45, -0.50), _wood_material)
	_add_box(ruin, "BrokenPost", Vector3(0.22, 1.55, 0.22), Vector3(0.80, 0.88, -0.46), _wood_material).rotation.z = -0.16
	var roof := _add_box(ruin, "Roof", Vector3(3.0, 0.20, 2.55), Vector3(0.0, 2.40, 0.05), _roof_material)
	roof.rotation.z = 0.085
	_add_box(ruin, "MossStrip", Vector3(1.45, 0.04, 0.58), Vector3(-0.28, 0.53, -0.10), _moss_material)
	_landmark_count += 1


func _build_corner_foreground() -> void:
	# Two low anchors are enough to prove depth. They stay beyond the combat rectangle and
	# below waist height so they cannot swallow enemies like the rejected foreground pile.
	var left := Node3D.new()
	left.name = "ForegroundLanternLeft"
	left.position = Vector3(-7.75, 0.0, 5.25)
	add_child(left)
	_add_box(left, "StoneBase", Vector3(0.62, 0.32, 0.62), Vector3(0.0, 0.16, 0.0), _stone_dark_material)
	_add_box(left, "LanternBody", Vector3(0.34, 0.58, 0.34), Vector3(0.0, 0.60, 0.0), _stone_material)
	_add_box(left, "LanternCap", Vector3(0.50, 0.10, 0.50), Vector3(0.0, 0.94, 0.0), _stone_dark_material)
	_foreground_occluder_count += 1

	var right := Node3D.new()
	right.name = "ForegroundFenceRight"
	right.position = Vector3(7.55, 0.0, 5.25)
	right.rotation.y = 0.14
	add_child(right)
	_add_box(right, "PostA", Vector3(0.16, 0.92, 0.16), Vector3(-0.72, 0.46, 0.0), _wood_dark_material)
	_add_box(right, "PostB", Vector3(0.16, 0.78, 0.16), Vector3(0.68, 0.39, 0.0), _wood_dark_material).rotation.z = 0.10
	_add_box(right, "Rail", Vector3(1.65, 0.13, 0.15), Vector3(0.0, 0.61, 0.0), _wood_material).rotation.z = -0.05
	_foreground_occluder_count += 1


func _build_perimeter_debris() -> void:
	# Debris is deliberately sparse, small and outside the central 10x6m reading field.
	for entry: Dictionary in [
		{"p": Vector3(-5.9, 0.13, -3.45), "s": Vector3(0.70, 0.26, 0.55), "r": 0.25},
		{"p": Vector3(5.85, 0.12, -3.25), "s": Vector3(0.62, 0.24, 0.50), "r": -0.31},
		{"p": Vector3(-6.05, 0.12, 3.20), "s": Vector3(0.60, 0.23, 0.48), "r": -0.18},
		{"p": Vector3(5.95, 0.10, 3.35), "s": Vector3(0.55, 0.20, 0.52), "r": 0.19},
	]:
		var stone := _add_box(self, "PerimeterRubble", entry["s"], entry["p"], _stone_material)
		stone.rotation = Vector3(0.05, float(entry["r"]), -0.04)

	for entry: Dictionary in [
		{"p": Vector3(-5.25, 0.09, 2.80), "r": 0.58},
		{"p": Vector3(5.15, 0.09, 2.65), "r": -0.52},
		{"p": Vector3(-5.65, 0.09, -2.70), "r": -0.35},
	]:
		var plank := _add_box(self, "BrokenPlank", Vector3(1.15, 0.09, 0.15), entry["p"], _wood_material)
		plank.rotation.y = float(entry["r"])


func _build_ritual_details() -> void:
	# Narrow channels guide the eye toward the torii without filling the combat floor.
	for entry: Dictionary in [
		{"p": Vector3(-2.9, 0.057, -3.40), "s": Vector3(1.30, 0.014, 0.055), "r": -0.18},
		{"p": Vector3(-1.65, 0.057, -3.72), "s": Vector3(1.10, 0.014, 0.055), "r": 0.12},
		{"p": Vector3(2.20, 0.057, -3.62), "s": Vector3(1.25, 0.014, 0.055), "r": 0.16},
		{"p": Vector3(3.55, 0.057, -3.32), "s": Vector3(1.00, 0.014, 0.055), "r": -0.10},
	]:
		var channel := _add_box(self, "RitualChannel", entry["s"], entry["p"], _blood_material)
		channel.rotation.y = float(entry["r"])
		_ritual_accent_count += 1

	for ember_position: Vector3 in [
		Vector3(-3.65, 0.12, -4.35),
		Vector3(3.55, 0.12, -4.40),
		Vector3(-7.10, 0.12, -1.55),
	]:
		var ember := SphereMesh.new()
		ember.radius = 0.11
		ember.height = 0.22
		ember.radial_segments = 10
		ember.rings = 5
		_add_mesh(self, "Ember", ember, ember_position, _ember_material)


func _build_lighting() -> void:
	var moon := DirectionalLight3D.new()
	moon.name = "MoonKey"
	moon.rotation_degrees = Vector3(-52.0, -28.0, 0.0)
	moon.light_color = Color(0.57, 0.66, 0.82, 1.0)
	moon.light_energy = 1.28
	moon.shadow_enabled = true
	moon.directional_shadow_max_distance = 28.0
	add_child(moon)

	for entry: Dictionary in [
		{"p": Vector3(-3.65, 1.15, -4.25), "e": 2.25, "r": 4.2},
		{"p": Vector3(3.55, 1.10, -4.30), "e": 2.05, "r": 4.0},
		{"p": Vector3(-7.05, 1.25, -1.50), "e": 1.75, "r": 3.4},
	]:
		var light := OmniLight3D.new()
		light.name = "WarmRitualLight"
		light.position = entry["p"]
		light.light_color = Color(0.96, 0.30, 0.12, 1.0)
		light.light_energy = float(entry["e"])
		light.omni_range = float(entry["r"])
		light.shadow_enabled = false
		add_child(light)
		_warm_light_count += 1


func get_presentation_state_for_test() -> Dictionary:
	return {
		"has_ground": get_node_or_null("Ground") != null and get_node_or_null("CombatCourtyard") != null,
		"has_ruined_torii": get_node_or_null("RuinedTorii") != null,
		"has_shrine_landmark": get_node_or_null("CollapsedWaysideShrine") != null,
		"has_moon_key": get_node_or_null("MoonKey") != null,
		"ritual_accent_count": _ritual_accent_count,
		"warm_light_count": _warm_light_count,
		"foreground_occluder_count": _foreground_occluder_count,
		"landmark_count": _landmark_count,
		"composition_revision": 2,
		"quiet_center": true,
	}


func _add_box(parent: Node3D, node_name: String, size: Vector3, position_value: Vector3, material: Material) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	return _add_mesh(parent, node_name, mesh, position_value, material)


func _add_mesh(parent: Node3D, node_name: String, mesh: PrimitiveMesh, position_value: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.position = position_value
	instance.material_override = material
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	parent.add_child(instance)
	return instance


func _material(color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	return material
