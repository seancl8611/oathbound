extends Node3D

## Runtime-built Hushiro environment kit for the live 2D-simulation -> 3D-presentation
## bridge. This remains production-replaceable geometry, but it now carries the approved
## Hushiro Rupture language strongly enough to judge the vertical slice: weathered stone,
## collapsed village/shrine forms, broken torii, ritual blood accents, cold moonlight,
## warm ember pools, and controlled foreground depth.

var _mat_ground: StandardMaterial3D
var _mat_stone: StandardMaterial3D
var _mat_stone_dark: StandardMaterial3D
var _mat_wood: StandardMaterial3D
var _mat_torii: StandardMaterial3D
var _mat_roof: StandardMaterial3D
var _mat_ember: StandardMaterial3D
var _mat_blood: StandardMaterial3D
var _mat_moss: StandardMaterial3D
var _mat_bone: StandardMaterial3D

var _ritual_accent_count := 0
var _warm_light_count := 0
var _foreground_occluder_count := 0
var _landmark_count := 0


func _ready() -> void:
	_build_materials()
	_build_floor()
	_build_far_threshold()
	_build_side_ruins()
	_build_vertical_landmarks()
	_build_foreground_occluders()
	_build_scatter()
	_build_ritual_accents()
	_build_lighting()


func _build_materials() -> void:
	_mat_ground = _material(Color(0.078, 0.058, 0.052, 1.0), 0.97)
	_mat_stone = _material(Color(0.245, 0.228, 0.198, 1.0), 0.91)
	_mat_stone_dark = _material(Color(0.090, 0.091, 0.086, 1.0), 0.96)
	_mat_wood = _material(Color(0.115, 0.050, 0.036, 1.0), 0.90)
	_mat_torii = _material(Color(0.285, 0.034, 0.028, 1.0), 0.80)
	_mat_roof = _material(Color(0.064, 0.068, 0.066, 1.0), 0.96)
	_mat_moss = _material(Color(0.075, 0.095, 0.070, 1.0), 0.98)
	_mat_bone = _material(Color(0.42, 0.37, 0.29, 1.0), 0.88)
	_mat_blood = _material(Color(0.24, 0.012, 0.015, 1.0), 0.78)
	_mat_ember = _material(Color(0.62, 0.095, 0.025, 1.0), 0.55)
	_mat_ember.emission_enabled = true
	_mat_ember.emission = Color(0.72, 0.09, 0.018, 1.0)
	_mat_ember.emission_energy_multiplier = 2.4


func _build_floor() -> void:
	var floor_mesh := PlaneMesh.new()
	floor_mesh.size = Vector2(28.0, 18.0)
	_add_mesh(self, "Ground", floor_mesh, Vector3.ZERO, _mat_ground)

	# Slightly raised stone lane makes the planar combat surface legible without
	# introducing gameplay elevation.
	_add_box(self, "StoneLane", Vector3(5.8, 0.035, 11.4), Vector3(0.0, 0.015, -0.15), _mat_stone_dark)
	for z: float in [-4.0, -2.0, 0.0, 2.0, 4.0]:
		for x: float in [-1.55, 0.0, 1.55]:
			var slab := _add_box(self, "WetStone", Vector3(1.25, 0.055, 1.25), Vector3(x, 0.045, z), _mat_stone)
			slab.rotation.y = (x * 0.13 + z * 0.07)

	# Broken edge stones keep the playable lane visually authored without becoming
	# collision. They sit outside the central threat-reading corridor.
	for entry: Dictionary in [
		{"p": Vector3(-3.55, 0.12, -3.1), "s": Vector3(1.1, 0.24, 0.62), "r": 0.25},
		{"p": Vector3(3.60, 0.10, -0.9), "s": Vector3(0.95, 0.20, 0.72), "r": -0.30},
		{"p": Vector3(-3.70, 0.11, 3.15), "s": Vector3(1.05, 0.22, 0.66), "r": -0.18},
	]:
		var edge_stone := _add_box(self, "LaneEdgeStone", entry["s"], entry["p"], _mat_stone_dark)
		edge_stone.rotation.y = float(entry["r"])


func _build_far_threshold() -> void:
	# Broken village wall behind the combat lane.
	_add_box(self, "FarWallLeft", Vector3(8.0, 1.10, 0.52), Vector3(-5.4, 0.55, -7.1), _mat_stone_dark)
	_add_box(self, "FarWallRight", Vector3(7.2, 1.25, 0.55), Vector3(5.6, 0.62, -7.0), _mat_stone_dark)
	_add_box(self, "FarWallBroken", Vector3(3.6, 0.72, 0.48), Vector3(-1.55, 0.36, -7.18), _mat_stone)

	var torii := Node3D.new()
	torii.name = "RuinedTorii"
	torii.position = Vector3(0.0, 0.0, -6.65)
	add_child(torii)
	_add_box(torii, "LeftPillar", Vector3(0.32, 3.55, 0.38), Vector3(-1.55, 1.77, 0.0), _mat_torii)
	_add_box(torii, "RightPillar", Vector3(0.32, 3.55, 0.38), Vector3(1.55, 1.77, 0.0), _mat_torii)
	_add_box(torii, "CrossBeam", Vector3(4.15, 0.30, 0.46), Vector3(0.0, 3.20, 0.0), _mat_torii)
	var upper := _add_box(torii, "UpperBeam", Vector3(4.90, 0.20, 0.40), Vector3(-0.22, 3.65, 0.02), _mat_wood)
	upper.rotation.z = -0.035
	var broken := _add_box(torii, "BrokenCap", Vector3(1.30, 0.18, 0.34), Vector3(2.05, 3.90, 0.04), _mat_wood)
	broken.rotation.z = 0.16
	_landmark_count += 1


func _build_side_ruins() -> void:
	var left := Node3D.new()
	left.name = "LeftVillageRuin"
	left.position = Vector3(-7.5, 0.0, -0.8)
	left.rotation.y = -0.24
	add_child(left)
	_add_box(left, "Foundation", Vector3(2.55, 0.65, 2.20), Vector3(0.0, 0.32, 0.0), _mat_stone_dark)
	_add_box(left, "BackWall", Vector3(2.35, 2.20, 0.20), Vector3(0.0, 1.35, 0.90), _mat_wood)
	_add_box(left, "Post", Vector3(0.24, 2.85, 0.25), Vector3(-0.86, 1.55, -0.32), _mat_wood)
	var roof_l := _add_box(left, "Roof", Vector3(3.15, 0.18, 2.45), Vector3(0.0, 2.70, 0.04), _mat_roof)
	roof_l.rotation.z = -0.09
	_add_box(left, "MossPatch", Vector3(1.05, 0.035, 0.80), Vector3(-0.35, 0.67, 0.20), _mat_moss)

	var right := Node3D.new()
	right.name = "RightVillageRuin"
	right.position = Vector3(7.30, 0.0, 0.65)
	right.rotation.y = 0.26
	add_child(right)
	_add_box(right, "Foundation", Vector3(2.35, 0.58, 2.05), Vector3(0.0, 0.29, 0.0), _mat_stone_dark)
	_add_box(right, "Wall", Vector3(0.22, 2.35, 1.90), Vector3(-0.85, 1.30, 0.12), _mat_wood)
	_add_box(right, "Post", Vector3(0.25, 2.65, 0.25), Vector3(0.72, 1.42, -0.35), _mat_wood)
	var roof_r := _add_box(right, "Roof", Vector3(2.90, 0.18, 2.30), Vector3(0.05, 2.58, 0.04), _mat_roof)
	roof_r.rotation.z = 0.08


func _build_vertical_landmarks() -> void:
	# Secondary silhouettes prevent the room reading as a flat arena while keeping the
	# center lane unobstructed. The shrine remnant also gives warm ritual light a source.
	var shrine := Node3D.new()
	shrine.name = "CollapsedWaysideShrine"
	shrine.position = Vector3(5.45, 0.0, -4.45)
	shrine.rotation.y = -0.22
	add_child(shrine)
	_add_box(shrine, "Plinth", Vector3(1.65, 0.42, 1.30), Vector3(0.0, 0.21, 0.0), _mat_stone_dark)
	_add_box(shrine, "BackStone", Vector3(1.15, 1.65, 0.28), Vector3(0.0, 1.02, 0.38), _mat_stone)
	_add_box(shrine, "TimberLeft", Vector3(0.16, 1.95, 0.18), Vector3(-0.56, 1.12, -0.08), _mat_wood).rotation.z = -0.08
	_add_box(shrine, "TimberRight", Vector3(0.16, 1.52, 0.18), Vector3(0.54, 0.91, -0.06), _mat_wood).rotation.z = 0.16
	var shrine_roof := _add_box(shrine, "BrokenRoof", Vector3(1.90, 0.16, 1.28), Vector3(-0.12, 1.95, 0.12), _mat_roof)
	shrine_roof.rotation.z = -0.13
	_landmark_count += 1

	var marker := Node3D.new()
	marker.name = "RuptureBoundaryMarker"
	marker.position = Vector3(-5.65, 0.0, -4.65)
	marker.rotation.y = 0.18
	add_child(marker)
	_add_box(marker, "StoneBase", Vector3(0.76, 0.45, 0.62), Vector3(0.0, 0.22, 0.0), _mat_stone_dark)
	_add_box(marker, "StandingStone", Vector3(0.48, 2.05, 0.38), Vector3(0.0, 1.25, 0.0), _mat_stone)
	_add_box(marker, "Binding", Vector3(0.58, 0.12, 0.48), Vector3(0.0, 1.45, 0.0), _mat_blood)
	_landmark_count += 1


func _build_foreground_occluders() -> void:
	# Low near-camera objects intentionally enter the frame so we can judge real depth
	# sorting/occlusion without obscuring combat silhouettes.
	var fence := Node3D.new()
	fence.name = "ForegroundFence"
	fence.position = Vector3(-5.8, 0.0, 6.0)
	fence.rotation.y = -0.12
	add_child(fence)
	_add_box(fence, "PostA", Vector3(0.18, 1.25, 0.18), Vector3(-0.9, 0.62, 0.0), _mat_wood)
	var post_b := _add_box(fence, "PostB", Vector3(0.18, 1.05, 0.18), Vector3(0.85, 0.52, 0.0), _mat_wood)
	post_b.rotation.z = 0.18
	var rail := _add_box(fence, "Rail", Vector3(2.15, 0.15, 0.16), Vector3(0.0, 0.80, 0.0), _mat_wood)
	rail.rotation.z = -0.05
	_foreground_occluder_count += 1

	_add_box(self, "ForegroundStone", Vector3(1.25, 0.70, 0.95), Vector3(5.25, 0.35, 5.7), _mat_stone_dark).rotation.y = 0.42
	_foreground_occluder_count += 1


func _build_scatter() -> void:
	for entry: Dictionary in [
		{"p": Vector3(-4.5, 0.26, 1.8), "s": Vector3(0.85, 0.52, 0.72), "r": 0.38},
		{"p": Vector3(4.9, 0.22, -1.9), "s": Vector3(0.72, 0.44, 0.78), "r": -0.48},
		{"p": Vector3(-6.0, 0.18, -3.6), "s": Vector3(0.55, 0.36, 0.64), "r": 0.16},
	]:
		var rock := _add_box(self, "Rubble", entry["s"], entry["p"], _mat_stone)
		rock.rotation = Vector3(0.10, float(entry["r"]), -0.07)

	for plank_entry: Dictionary in [
		{"p": Vector3(-4.75, 0.15, -1.05), "r": 0.52},
		{"p": Vector3(4.25, 0.13, 3.10), "r": -0.70},
		{"p": Vector3(6.00, 0.12, -2.65), "r": 0.25},
	]:
		var plank := _add_box(self, "BrokenPlank", Vector3(1.55, 0.13, 0.22), plank_entry["p"], _mat_wood)
		plank.rotation.y = float(plank_entry["r"])

	for ember_pos: Vector3 in [Vector3(-2.25, 0.10, -4.9), Vector3(2.05, 0.10, -5.15), Vector3(6.1, 0.10, 2.6)]:
		var mesh := SphereMesh.new()
		mesh.radius = 0.13
		mesh.height = 0.26
		mesh.radial_segments = 10
		mesh.rings = 5
		_add_mesh(self, "Ember", mesh, ember_pos, _mat_ember)


func _build_ritual_accents() -> void:
	# Thin raised strips read as dried ritual channels from the gameplay camera while
	# avoiding decals/textures that would prematurely lock the environment art pipeline.
	for entry: Dictionary in [
		{"p": Vector3(-1.85, 0.075, -4.25), "s": Vector3(0.12, 0.025, 2.20), "r": -0.32},
		{"p": Vector3(1.60, 0.075, -4.35), "s": Vector3(0.11, 0.025, 1.85), "r": 0.40},
		{"p": Vector3(5.35, 0.075, -3.75), "s": Vector3(0.10, 0.025, 1.20), "r": -0.18},
	]:
		var channel := _add_box(self, "RitualBloodChannel", entry["s"], entry["p"], _mat_blood)
		channel.rotation.y = float(entry["r"])
		_ritual_accent_count += 1

	var offering := Node3D.new()
	offering.name = "RitualOffering"
	offering.position = Vector3(5.35, 0.0, -3.72)
	add_child(offering)
	_add_box(offering, "OfferingStone", Vector3(0.78, 0.26, 0.66), Vector3(0.0, 0.13, 0.0), _mat_stone_dark)
	_add_box(offering, "BindingBone", Vector3(0.08, 0.08, 0.62), Vector3(-0.14, 0.34, 0.0), _mat_bone).rotation.z = -0.22
	_add_box(offering, "BindingBone", Vector3(0.08, 0.08, 0.58), Vector3(0.16, 0.34, 0.0), _mat_bone).rotation.z = 0.25
	_ritual_accent_count += 1


func _build_lighting() -> void:
	var moon := DirectionalLight3D.new()
	moon.name = "MoonKey"
	moon.rotation_degrees = Vector3(-58.0, -32.0, 0.0)
	moon.light_color = Color(0.58, 0.66, 0.82, 1.0)
	moon.light_energy = 1.02
	moon.shadow_enabled = true
	add_child(moon)

	var torii_ember := _add_warm_light("ToriiEmberLight", Vector3(0.0, 1.25, -5.55), 6.5, 1.85)
	torii_ember.light_color = Color(0.95, 0.21, 0.055, 1.0)
	var shrine_ember := _add_warm_light("ShrineEmberLight", Vector3(5.30, 1.05, -4.18), 4.2, 1.45)
	shrine_ember.light_color = Color(0.92, 0.17, 0.045, 1.0)
	var side_ember := _add_warm_light("SideEmberLight", Vector3(-5.30, 0.75, 1.65), 3.3, 0.85)
	side_ember.light_color = Color(0.82, 0.13, 0.035, 1.0)


func _add_warm_light(node_name: String, position_value: Vector3, range_value: float, energy: float) -> OmniLight3D:
	var light := OmniLight3D.new()
	light.name = node_name
	light.position = position_value
	light.omni_range = range_value
	light.light_energy = energy
	light.shadow_enabled = true
	add_child(light)
	_warm_light_count += 1
	return light


func get_presentation_state_for_test() -> Dictionary:
	return {
		"has_ground": get_node_or_null("Ground") != null,
		"has_ruined_torii": get_node_or_null("RuinedTorii") != null,
		"has_shrine_landmark": get_node_or_null("CollapsedWaysideShrine") != null,
		"has_moon_key": get_node_or_null("MoonKey") != null,
		"ritual_accent_count": _ritual_accent_count,
		"warm_light_count": _warm_light_count,
		"foreground_occluder_count": _foreground_occluder_count,
		"landmark_count": _landmark_count,
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
