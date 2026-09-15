extends "res://Utility/Planar3DActorVisual.gd"

## Hushiro-only middle visual tier between final Oathbound character GLBs and the
## procedural blockout geometry. It uses a pinned/verified CC0 Quaternius humanoid for
## human actors and the matching Universal Animation Library when Godot imports it.
##
## Priority remains:
##   final role-specific GLB -> curated CC0 humanoid -> procedural fallback.
## The authoritative CharacterBody2D still owns every gameplay decision. Imported attack
## animation is sampled from the existing 2D action progress; dash/locomotion only mirror
## source state and never own movement, invulnerability, hit timing, or root motion.

const CURATED_HUMANOID_PATH := "res://Art3D/ThirdParty/Quaternius/UniversalBaseCharacters/superhero_male_reference.glb"
const CURATED_ANIMATION_LIBRARY_PATH := "res://Art3D/ThirdParty/Quaternius/UniversalAnimationLibrary/universal_animation_library.glb"
const MIN_CURATED_BONES := 50
const MIN_CURATED_ANIMATIONS := 5
const PLAYER_HEIGHT_METERS := 1.90
const SWORDSMAN_HEIGHT_METERS := 1.84

var _curated_model_active := false
var _curated_model: Node3D = null
var _curated_skeleton: Skeleton3D = null
var _curated_base_pose_rotations: Dictionary = {}
var _curated_base_position := Vector3.ZERO
var _curated_base_rotation := Vector3.ZERO

var _curated_animation_player: AnimationPlayer = null
var _curated_animation_library_active := false
var _curated_animation_clip_count := 0
var _curated_animation_remapped_tracks := 0
var _curated_animation_discarded_tracks := 0
var _curated_idle_clip := StringName()
var _curated_locomotion_clip := StringName()
var _curated_dash_clip := StringName()
var _curated_attack_clip := StringName()
var _curated_hurt_clip := StringName()
var _curated_death_clip := StringName()
var _curated_last_clip := StringName()


func _rebuild_visual() -> void:
	_curated_model_active = false
	_curated_model = null
	_curated_skeleton = null
	_curated_base_pose_rotations.clear()
	_reset_animation_runtime()

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


func is_curated_placeholder_active() -> bool:
	return _curated_model_active


func get_visual_tier() -> String:
	if _curated_model_active:
		return "curated_cc0_humanoid"
	if _external_model_active:
		return "role_specific_glb"
	return "procedural_fallback"


func get_animation_tier() -> String:
	if _curated_model_active and _curated_animation_library_active:
		return "curated_animation_library"
	if _curated_model_active:
		return "manual_pose_adapter"
	return "role_specific_or_procedural"


func get_curated_animation_state_for_test() -> Dictionary:
	return {
		"active": _curated_animation_library_active,
		"clip_count": _curated_animation_clip_count,
		"remapped_tracks": _curated_animation_remapped_tracks,
		"discarded_tracks": _curated_animation_discarded_tracks,
		"idle_clip": str(_curated_idle_clip),
		"locomotion_clip": str(_curated_locomotion_clip),
		"dash_clip": str(_curated_dash_clip),
		"attack_clip": str(_curated_attack_clip),
		"hurt_clip": str(_curated_hurt_clip),
		"death_clip": str(_curated_death_clip),
		"dash_mode": "authored_clip" if _curated_dash_clip != StringName() else "locomotion_lean_fallback",
		"attack_mode": "authored_source_progress" if _curated_attack_clip != StringName() else "manual_source_progress",
	}


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
	_external_model_active = true
	model.set_meta("oathbound_curated_placeholder", true)
	model.set_meta("oathbound_source_license", "CC0-1.0")

	_curated_animation_library_active = _setup_curated_animation_library()
	model.set_meta(
		"oathbound_animation_state",
		"curated_animation_library" if _curated_animation_library_active else "manual_pose_adapter"
	)
	if not _curated_animation_library_active:
		_sync_curated_pose()

	print(
		"[HushiroCuratedActorVisual] %s using verified CC0 humanoid tier (%d bones) animation=%s clips=%d dash=%s attack=%s"
		% [
			actor_role,
			skeleton.get_bone_count(),
			get_animation_tier(),
			_curated_animation_clip_count,
			str(get_curated_animation_state_for_test().get("dash_mode", "")),
			str(get_curated_animation_state_for_test().get("attack_mode", "")),
		]
	)
	return true


func _reset_animation_runtime() -> void:
	_curated_animation_player = null
	_curated_animation_library_active = false
	_curated_animation_clip_count = 0
	_curated_animation_remapped_tracks = 0
	_curated_animation_discarded_tracks = 0
	_curated_idle_clip = StringName()
	_curated_locomotion_clip = StringName()
	_curated_dash_clip = StringName()
	_curated_attack_clip = StringName()
	_curated_hurt_clip = StringName()
	_curated_death_clip = StringName()
	_curated_last_clip = StringName()


func _setup_curated_animation_library() -> bool:
	if _curated_model == null or _curated_skeleton == null:
		return false
	if not ResourceLoader.exists(CURATED_ANIMATION_LIBRARY_PATH):
		return false
	var source_resource := load(CURATED_ANIMATION_LIBRARY_PATH)
	if not (source_resource is AnimationLibrary):
		return false
	var source_library := source_resource as AnimationLibrary
	if source_library.get_animation_list().size() < MIN_CURATED_ANIMATIONS:
		return false

	var runtime_library := _build_runtime_animation_library(source_library)
	if runtime_library == null or runtime_library.get_animation_list().size() < MIN_CURATED_ANIMATIONS:
		return false

	var player := AnimationPlayer.new()
	player.name = "CuratedAnimationPlayer"
	# Imported AnimationLibrary track paths are rewritten relative to the curated model,
	# so the AnimationPlayer can use its parent as the animation root.
	player.root_node = NodePath("..")
	_curated_model.add_child(player)
	if player.add_animation_library(&"", runtime_library) != OK:
		player.queue_free()
		return false

	_curated_animation_player = player
	_curated_animation_clip_count = runtime_library.get_animation_list().size()
	_curated_idle_clip = _select_semantic_clip(runtime_library, ["idle", "stand", "breath"])
	_curated_locomotion_clip = _select_semantic_clip(runtime_library, ["run", "jog", "walk", "locomotion", "move"])
	_curated_dash_clip = _select_semantic_clip(runtime_library, ["dash", "dodge", "roll", "evade"])
	_curated_attack_clip = _select_semantic_clip(runtime_library, ["sword", "attack", "slash", "melee", "strike"])
	_curated_hurt_clip = _select_semantic_clip(runtime_library, ["hurt", "hit", "impact", "stagger"])
	_curated_death_clip = _select_semantic_clip(runtime_library, ["death", "die", "dead"])

	# Idle and locomotion are required for the authored library to become authoritative.
	# Action-specific clips remain optional because deterministic source-state fallbacks are
	# safer than allowing decorative animation to invent dash or attack timing.
	if _curated_idle_clip == StringName() or _curated_locomotion_clip == StringName():
		player.queue_free()
		_curated_animation_player = null
		return false
	return true


func _build_runtime_animation_library(source_library: AnimationLibrary) -> AnimationLibrary:
	if _curated_model == null or _curated_skeleton == null:
		return null
	var runtime_library := AnimationLibrary.new()
	var skeleton_path := _curated_model.get_path_to(_curated_skeleton)
	for animation_name: StringName in source_library.get_animation_list():
		var source_animation := source_library.get_animation(animation_name)
		if source_animation == null:
			continue
		var animation := source_animation.duplicate(true) as Animation
		if animation == null:
			continue

		# Quaternius' base character and animation packs share one skeleton. Remap every
		# recognized bone track directly to the live character skeleton and discard scene/
		# root transforms so imported animation can never move the gameplay proxy.
		for track_index: int in range(animation.get_track_count() - 1, -1, -1):
			var source_path := animation.track_get_path(track_index)
			var bone_name := _bone_name_from_track_path(source_path)
			if bone_name.is_empty() or _curated_skeleton.find_bone(bone_name) < 0:
				animation.remove_track(track_index)
				_curated_animation_discarded_tracks += 1
				continue
			animation.track_set_path(track_index, NodePath("%s:%s" % [str(skeleton_path), bone_name]))
			_curated_animation_remapped_tracks += 1
		if animation.get_track_count() == 0:
			continue
		runtime_library.add_animation(animation_name, animation)
	return runtime_library


func _bone_name_from_track_path(path: NodePath) -> String:
	if path.get_subname_count() <= 0:
		return ""
	# Skeleton bone animation paths use the bone as the first subname. Keep this strict;
	# mesh blend-shapes and arbitrary node-property tracks are intentionally excluded.
	return str(path.get_subname(0))


func _select_semantic_clip(library: AnimationLibrary, tokens: Array[String]) -> StringName:
	var best := StringName()
	var best_score := -1
	for animation_name: StringName in library.get_animation_list():
		var lower := str(animation_name).to_lower()
		var score := 0
		for token: String in tokens:
			if lower.contains(token):
				score += 10
		# Prefer ordinary gameplay clips over obviously specialized variants.
		if lower.contains("loop"):
			score += 1
		if lower.contains("weapon") or lower.contains("sword"):
			score += 2
		if lower.contains("jump") or lower.contains("swim") or lower.contains("dance"):
			score -= 8
		if score > best_score and score > 0:
			best_score = score
			best = animation_name
	return best


func _sync_external_animation(speed: float) -> void:
	if not _curated_model_active:
		super._sync_external_animation(speed)
		return
	_reset_curated_model_transform()
	if _curated_animation_library_active and _sync_curated_library_animation(speed):
		return
	_sync_curated_pose()


func _sync_curated_library_animation(speed: float) -> bool:
	if _curated_animation_player == null or source_actor == null:
		return false

	var source_animation := _source_animation_name()
	var dead := _source_dead() or source_animation.contains("death")
	var hurt := _contains_any(source_animation, ["hurt", "stagger", "parried", "hit"])
	var dashing := _contains_any(source_animation, ["dash", "dodge", "roll", "evade"])
	var attacking := _source_attack_active() or _contains_any(source_animation, ["attack", "slash", "cleave", "thrust", "counter"])

	if dead:
		if _curated_death_clip != StringName():
			_play_curated_clip(_curated_death_clip, 1.0, false)
			return true
		return false
	if hurt:
		if _curated_hurt_clip != StringName():
			_play_curated_clip(_curated_hurt_clip, 1.0, false)
			return true
		return false
	if dashing:
		if _curated_dash_clip != StringName():
			_play_curated_clip(_curated_dash_clip, 1.35, false)
		else:
			# The movement controller remains authoritative. This fallback simply gives the
			# 0.3s source dash a lower/faster silhouette when the library has no dash clip.
			_play_curated_clip(_curated_locomotion_clip, 1.85, false)
			_curated_model.rotation.x = _curated_base_rotation.x - 0.20
			_curated_model.position.y = _curated_base_position.y - 0.035
		return true
	if attacking:
		if _curated_attack_clip == StringName():
			return false
		var animation := _animation_for(_curated_attack_clip)
		if animation == null:
			return false
		_play_curated_clip(_curated_attack_clip, 1.0, true)
		var progress := clampf(_source_action_progress(), 0.0, 1.0)
		_curated_animation_player.seek(progress * animation.length, true)
		_curated_animation_player.pause()
		return true

	if speed > 12.0:
		var speed_scale := clampf(speed / 95.0, 0.65, 1.65)
		_play_curated_clip(_curated_locomotion_clip, speed_scale, false)
		return true
	_play_curated_clip(_curated_idle_clip, 1.0, false)
	return true


func _play_curated_clip(clip: StringName, speed_scale: float, force_restart: bool) -> void:
	if _curated_animation_player == null or clip == StringName():
		return
	if force_restart or _curated_last_clip != clip or not _curated_animation_player.is_playing():
		_curated_animation_player.play(clip)
		_curated_last_clip = clip
	_curated_animation_player.speed_scale = speed_scale


func _animation_for(clip: StringName) -> Animation:
	if _curated_animation_player == null or clip == StringName():
		return null
	return _curated_animation_player.get_animation(clip)


func _reset_curated_model_transform() -> void:
	if _curated_model == null:
		return
	_curated_model.position = _curated_base_position
	_curated_model.rotation = _curated_base_rotation


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
	# Capture every imported bone so falling back from an authored clip to the deterministic
	# adapter never leaves stale transforms behind on fingers, neck, or secondary joints.
	for bone_index: int in range(_curated_skeleton.get_bone_count()):
		var bone_name := str(_curated_skeleton.get_bone_name(bone_index))
		_curated_base_pose_rotations[bone_name] = _curated_skeleton.get_bone_pose_rotation(bone_index)


func _reset_curated_pose() -> void:
	if _curated_skeleton == null or _curated_model == null:
		return
	if _curated_animation_player != null:
		_curated_animation_player.stop()
	_curated_last_clip = StringName()
	_reset_curated_model_transform()
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

	# Deterministic fallback used only when a required authored semantic clip is unavailable.
	_apply_bone_rotation("upperarm_l", Vector3.FORWARD, 1.12)
	_apply_bone_rotation("upperarm_r", Vector3.FORWARD, -1.12)
	_apply_bone_rotation("lowerarm_l", Vector3.RIGHT, -0.12)
	_apply_bone_rotation("lowerarm_r", Vector3.RIGHT, -0.12)

	var source_animation := _source_animation_name()
	var dead := _source_dead() or source_animation.contains("death")
	var hurt := _contains_any(source_animation, ["hurt", "stagger", "parried"])
	var dashing := _contains_any(source_animation, ["dash", "dodge", "roll", "evade"])
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
	if dashing:
		# Manual fallback still mirrors source movement; it only changes the rendered pose.
		_curated_model.rotation.x -= 0.20
		_curated_model.position.y -= 0.035
		var dash_stride := sin(_motion_phase * 1.45)
		_apply_bone_rotation("thigh_l", Vector3.RIGHT, dash_stride * 0.52)
		_apply_bone_rotation("thigh_r", Vector3.RIGHT, -dash_stride * 0.52)
		_apply_bone_rotation("spine_03", Vector3.RIGHT, -0.12)
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

	# Broad kitbash pieces remain presentation placeholders for identity/readability. The
	# future Akio/Swordsman production GLBs replace this entire curated tier atomically.
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
