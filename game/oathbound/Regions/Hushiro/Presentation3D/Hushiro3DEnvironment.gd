extends Node3D

## Runtime-built Hushiro environment kit for the live 2D-simulation -> 3D-presentation
## bridge. This is intentionally modular/procedural placeholder geometry: it establishes
## room volume, occlusion, lighting and a production asset contract while we evaluate
## AI-generated and CC0 environment models.

var _mat_ground: StandardMaterial3D
var _mat_stone: StandardMaterial3D
var _mat_stone_dark: StandardMaterial3D
var _mat_wood: StandardMaterial3D
var _mat_torii: StandardMaterial3D
var _mat_roof: StandardMaterial3D
var _mat_ember: StandardMaterial3D


func _ready() -> void:
	_build_materials()
	_build_floor()
	_build_far_threshold()
	_build_side_ruins()
	_build_foreground_occluders()
	_build_scatter()
	_build_lighting()


func _build_materials() -> void:
	_mat_ground = _material(Color(0.095, 0.070, 0.060, 1.0), 0.96)
	_mat_stone = _material(Color(0.25, 0.235, 0.205, 1.0), 0.90)
	_mat_stone_dark = _material(Color(0.105, 0.105, 0.098, 1.0), 0.95)
	_mat_wood = _material(Color(0.125, 0.055, 0.038, 1.0), 0.88)
	_mat_torii = _material(Color(0.30, 0.042, 0.032, 1.0), 0.76)
	_mat_roof = _material(Color(0.080, 0.083, 0.078, 1.0), 0.94)
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

	_add_box(self, "ForegroundStone", Vector3(1.25, 0.70, 0.95), Vector3(5.25, 0.35, 5.7), _mat_stone_dark).rotation.y = 0.42


func _build_scatter() -> void:
	for entry: Dictionary in [
		{"p": Vector3(-4.5, 0.26, 1.8), "s": Vector3(0.85, 0.52, 0.72), "r": 0.38},
		{"p": Vector3(4.9, 0.22, -1.9), "s": Vector3(0.72, 0.44, 0.78), "r": -0.48},
		{"p": Vector3(-6.0, 0.18, -3.6), "s": Vector3(0.55, 0.36, 0.64), "r": 0.16},
	]:
		var rock := _add_box(self, "Rubble", entry["s"], entry["p"], _mat_stone)
		rock.rotation = Vector3(0.10, float(entry["r"]), -0.07)

	for ember_pos: Vector3 in [Vector3(-2.25, 0.10, -4.9), Vector3(2.05, 0.10, -5.15), Vector3(6.1, 0.10, 2.6)]:
		var mesh := SphereMesh.new()
		mesh.radius = 0.13
		mesh.height = 0.26
		mesh.radial_segments = 10
		mesh.rings = 5
		_add_mesh(self, "Ember", mesh, ember_pos, _mat_ember)


func _build_lighting() -> void:
	var moon := DirectionalLight3D.new()
	moon.name = "MoonKey"
	moon.rotation_degrees = Vector3(-58.0, -32.0, 0.0)
	moon.light_color = Color(0.64, 0.70, 0.84, 1.0)
	moon.light_energy = 1.05
	moon.shadow_enabled = true
	add_child(moon)

	var ember := OmniLight3D.new()
	ember.name = "ToriiEmberLight"
	ember.position = Vector3(0.0, 1.25, -5.55)
	ember.omni_range = 6.5
	ember.light_color = Color(0.95, 0.23, 0.07, 1.0)
	ember.light_energy = 2.0
	ember.shadow_enabled = true
	add_child(ember)


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
