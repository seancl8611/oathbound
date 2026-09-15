extends "res://Utility/Planar3DActorVisual.gd"

## Hushiro-only middle visual tier between final Oathbound character GLBs and the
## procedural blockout geometry. It uses a pinned/verified CC0 Quaternius humanoid for
## human actors while the dedicated animation-library retarget remains under validation.
##
## Priority remains:
##   final role-specific GLB -> curated CC0 humanoid -> procedural fallback.
## The authoritative CharacterBody2D still owns every gameplay decision.

const CURATED_HUMANOID_PATH := "res://Art3D/ThirdParty/Quaternius/UniversalBaseCharacters/superhero_male_reference.glb"
const MIN_CURATED_BONES := 50
const PLAYER_HEIGHT_METERS := 1.90
const SWORDSMAN_HEIGHT_METERS := 1.84

var _curated_model_active := false
var _curated_model: Node3D = null
var _curated_skeleton: Skeleton3D = null
var _curated_base_pose_rotations: Dictionary = {}
var _curated_base_position := Vector3.ZERO
var _curated_base_rotation := Vector3.ZERO


func _rebuild_visual() -> void:
	_curated_model_active = false
	_curated_model = null
	_curated_skeleton = null
	_curated_base_pose_rotations.clear()

	if actor_role not in ["player", "swordsman"]:
		super._rebuild_visual()
		return

	# Let the base presenter create/reset VisualRoot and try the true production slot,
	# but temporarily prevent it from immediately falling through to blockout geometry.
	var procedural_requested := use_procedural_fallback
	use_procedural_fallback = false
	super._rebuild_visual()
	use_procedural_fallback = procedural_requested

	if _external_model_active:
		return
	if _try_curated_humanoid():
		return
	if procedural_requested:
		_build_humanoid(actor_role == "player")


func sync_from_source(delta: float) -> void:
	super.sync_from_source(delta)
	if _curated_model_active:
		_sync_curated_pose()


func is_curated_placeholder_active() -> bool:
	return _curated_model_active


func get_visual_tier() -> String:
	if _curated_model_active:
		return "curated_cc0_humanoid"
	if _external_model_active:
		return "role_specific_glb"
	return "procedural_fallback"


func _try_curated_humanoid() -> bool:
	if _visual_root == null or not ResourceLoader.exists(CURATED_HUMANOID_PATH):
		return false
	var packed := load(CURATED_HUMANOID_PATH) as PackedScene
	if packed == null:
		return false
	var instance := packed.instantiate()
	if not (instance is Node3D):
		if instance != null:
			instance.queue_free()
		return false

	var model := instance as Node3D
	model.name = "CuratedQuaterniusHumanoid"
	_visual_root.add_child(model)
	var skeleton := _find_skeleton(model)
	if skeleton == null or skeleton.get_bone_count() < MIN_CURATED_BONES:
		model.queue_free()
		return false

	_curated_model = model
	_curated_skeleton = skeleton
	_normalize_curated_model(model, PLAYER_HEIGHT_METERS if actor_role == "player" else SWORDSMAN_HEIGHT_METERS)
	_apply_illustrated_material_treatment(model)
	_capture_curated_pose()
	_add_role_silhouette_dressing()
	_add_contact_shadow(_visual_root, 0.48 if actor_role == "player" else 0.45, 0.30)

	_curated_base_position = model.position
	_curated_base_rotation = model.rotation
	_curated_model_active = true
	# Mark as external so the base presenter does not try to drive nonexistent imported
	# clips. Hushiro applies a small skeleton pose adapter below until retargeting is ready.
	_external_model_active = true
	model.set_meta("oathbound_curated_placeholder", true)
	model.set_meta("oathbound_source_license", "CC0-1.0")
	model.set_meta("oathbound_animation_state", "retarget_pending")
	_sync_curated_pose()
	print("[HushiroCuratedActorVisual] %s using verified CC0 humanoid tier (%d bones)" % [actor_role, skeleton.get_bone_count()])
	return true


func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node as Skeleton3D
	for child: Node in node.get_children():
		var found := _find_skeleton(child)
		if found != null:
			return found
	return null


func _normalize_curated_model(model: Node3D, target_height: float) -> void:
	var points: Array[Vector3] = []
	_collect_mesh_points(model, model, points)
	if points.is_empty():
		return
	var min_point := points[0]
	var max_point := points[0]
	for point: Vector3 in points:
		min_point = min_point.min(point)
		max_point = max_point.max(point)
	var source_height := maxf(0.01, max_point.y - min_point.y)
	var uniform_scale := clampf(target_height / source_height, 0.001, 100.0)
	var center_xz := Vector3((min_point.x + max_point.x) * 0.5, 0.0, (min_point.z + max_point.z) * 0.5)
	model.scale = Vector3.ONE * uniform_scale
	model.position = Vector3(-center_xz.x * uniform_scale, -min_point.y * uniform_scale, -center_xz.z * uniform_scale)


func _collect_mesh_points(root: Node3D, node: Node, points: Array[Vector3]) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh != null:
			var relative := root.global_transform.affine_inverse() * mesh_instance.global_transform
			var aabb := mesh_instance.get_aabb()
			for x_index: int in range(2):
				for y_index: int in range(2):
					for z_index: int in range(2):
						var corner := aabb.position + Vector3(
							aabb.size.x * float(x_index),
							aabb.size.y * float(y_index),
							aabb.size.z * float(z_index)
						)
						points.append(relative * corner)
	for child: Node in node.get_children():
		_collect_mesh_points(root, child, points)


func _apply_illustrated_material_treatment(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh != null:
			for surface_index: int in range(mesh_instance.mesh.get_surface_count()):
				var source_material := mesh_instance.get_active_material(surface_index)
				if source_material is StandardMaterial3D:
					var styled := (source_material as StandardMaterial3D).duplicate() as StandardMaterial3D
					if styled != null:
						# Preserve authored textures while suppressing glossy/PBR-heavy response. A
						# muted multiplier helps disparate placeholder assets share one visual world.
						var multiplier := Color(0.55, 0.54, 0.58, 1.0) if actor_role == "player" else Color(0.64, 0.50, 0.42, 1.0)
						styled.albedo_color *= multiplier
						styled.roughness = maxf(styled.roughness, 0.82)
						styled.metallic = minf(styled.metallic, 0.08)
						mesh_instance.set_surface_override_material(surface_index, styled)
		mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	for child: Node in node.get_children():
		_apply_illustrated_material_treatment(child)


func _capture_curated_pose() -> void:
	if _curated_skeleton == null:
		return
	for bone_name: String in [
		"pelvis", "spine_01", "spine_02", "spine_03",
		"clavicle_l", "upperarm_l", "lowerarm_l", "hand_l",
		"clavicle_r", "upperarm_r", "lowerarm_r", "hand_r",
		"thigh_l", "calf_l", "foot_l", "thigh_r", "calf_r", "foot_r"
	]:
		var bone_index := _curated_skeleton.find_bone(bone_name)
		if bone_index >= 0:
			_curated_base_pose_rotations[bone_name] = _curated_skeleton.get_bone_pose_rotation(bone_index)


func _reset_curated_pose() -> void:
	if _curated_skeleton == null or _curated_model == null:
		return
	_curated_model.position = _curated_base_position
	_curated_model.rotation = _curated_base_rotation
	for bone_name: Variant in _curated_base_pose_rotations.keys():
		var bone_index := _curated_skeleton.find_bone(str(bone_name))
		if bone_index >= 0:
			_curated_skeleton.set_bone_pose_rotation(bone_index, _curated_base_pose_rotations[bone_name] as Quaternion)


func _apply_bone_rotation(bone_name: String, axis: Vector3, angle: float) -> void:
	if _curated_skeleton == null:
		return
	var bone_index := _curated_skeleton.find_bone(bone_name)
	if bone_index < 0:
		return
	var current := _curated_skeleton.get_bone_pose_rotation(bone_index)
	_curated_skeleton.set_bone_pose_rotation(bone_index, current * Quaternion(axis.normalized(), angle))


func _sync_curated_pose() -> void:
	if _curated_skeleton == null or _curated_model == null or source_actor == null:
		return
	_reset_curated_pose()

	# Bring the source T-pose into a compact gameplay silhouette first. Motion below is
	# deliberately restrained because the final library retarget remains a separate task.
	_apply_bone_rotation("upperarm_l", Vector3.FORWARD, 1.12)
	_apply_bone_rotation("upperarm_r", Vector3.FORWARD, -1.12)
	_apply_bone_rotation("lowerarm_l", Vector3.RIGHT, -0.12)
	_apply_bone_rotation("lowerarm_r", Vector3.RIGHT, -0.12)

	var source_animation := _source_animation_name()
	var dead := _source_dead() or source_animation.contains("death")
	var hurt := _contains_any(source_animation, ["hurt", "stagger", "parried"])
	var attacking := _source_attack_active() or _contains_any(source_animation, ["attack", "slash", "cleave", "thrust", "counter"])
	var speed := _source_velocity().length()

	if dead:
		_curated_model.rotation.z += 1.20
		_curated_model.position.y -= 0.38
		return
	if hurt:
		_apply_bone_rotation("spine_03", Vector3.RIGHT, -0.22)
		_apply_bone_rotation("pelvis", Vector3.FORWARD, sin(_motion_phase * 1.4) * 0.08)
		return
	if attacking:
		var progress := clampf(_source_action_progress(), 0.0, 1.0)
		var swing := sin(progress * PI)
		_apply_bone_rotation("spine_03", Vector3.UP, lerpf(-0.25, 0.38, progress))
		_apply_bone_rotation("upperarm_r", Vector3.RIGHT, -0.92 * swing)
		_apply_bone_rotation("upperarm_r", Vector3.UP, lerpf(-0.55, 0.72, progress))
		_apply_bone_rotation("upperarm_l", Vector3.RIGHT, -0.28 * swing)
		_apply_bone_rotation("thigh_l", Vector3.RIGHT, 0.12 * swing)
		_apply_bone_rotation("thigh_r", Vector3.RIGHT, -0.10 * swing)
		return

	if speed > 12.0:
		var stride := sin(_motion_phase)
		_curated_model.position.y += absf(sin(_motion_phase * 2.0)) * 0.025
		_apply_bone_rotation("thigh_l", Vector3.RIGHT, stride * 0.42)
		_apply_bone_rotation("thigh_r", Vector3.RIGHT, -stride * 0.42)
		_apply_bone_rotation("calf_l", Vector3.RIGHT, maxf(0.0, -stride) * 0.28)
		_apply_bone_rotation("calf_r", Vector3.RIGHT, maxf(0.0, stride) * 0.28)
		_apply_bone_rotation("upperarm_l", Vector3.RIGHT, -stride * 0.24)
		_apply_bone_rotation("upperarm_r", Vector3.RIGHT, stride * 0.24)
	else:
		_curated_model.position.y += sin(_motion_phase * 0.7) * 0.008
		_apply_bone_rotation("spine_03", Vector3.UP, sin(_motion_phase * 0.31) * 0.018)


func _add_role_silhouette_dressing() -> void:
	if _visual_root == null:
		return
	var dark_cloth := _material(Color(0.055, 0.052, 0.062, 1.0), 0.94)
	var enemy_cloth := _material(Color(0.18, 0.105, 0.075, 1.0), 0.91)
	var iron := _material(Color(0.16, 0.13, 0.11, 1.0), 0.72, 0.08)
	var steel := _material(Color(0.40, 0.41, 0.40, 1.0), 0.55, 0.22)
	var blood := _material(Color(0.28, 0.035, 0.032, 1.0), 0.88)
	var cloth := dark_cloth if actor_role == "player" else enemy_cloth

	# Simple kitbash pieces are intentionally broad shapes at gameplay distance. They
	# distinguish roles while a future outfit pack / Akio-specific model replaces them.
	_add_box(_visual_root, "CuratedSash", Vector3(0.62, 0.10, 0.34), Vector3(0.0, 0.93, 0.0), blood if actor_role == "player" else cloth)
	var sheath := _add_box(_visual_root, "CuratedSheath", Vector3(0.07, 0.07, 0.92), Vector3(-0.31, 0.77, 0.05), cloth)
	sheath.rotation = Vector3(0.0, -0.38, -0.22)
	_add_box(_visual_root, "CuratedBladeHint", Vector3(0.045, 0.045, 0.98), Vector3(0.34, 0.92, -0.28), steel)
	if actor_role == "player":
		_add_box(_visual_root, "AkioScarf", Vector3(0.50, 0.18, 0.34), Vector3(0.0, 1.58, -0.01), dark_cloth)
		var shoulder := _add_box(_visual_root, "AkioShoulderArmor", Vector3(0.30, 0.15, 0.30), Vector3(-0.31, 1.43, 0.0), iron)
		shoulder.rotation.z = -0.10
	else:
		_add_box(_visual_root, "SwordsmanShoulderArmor", Vector3(0.60, 0.13, 0.28), Vector3(0.0, 1.40, 0.0), iron)
