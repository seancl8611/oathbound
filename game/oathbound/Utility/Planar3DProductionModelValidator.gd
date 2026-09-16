extends RefCounted

## Read-only inspection for canonical production-model slots.
##
## Runtime presenters already reject non-renderable external scenes. This validator gives
## CI/diagnostics the same early warning before final art silently falls back to a curated
## or authored placeholder. It intentionally avoids role-specific scale/material/rig rules
## until real production assets exist, but it does enforce the animation aliases and real
## pose-bearing tracks that the current shared production-model adapter can actually drive.

const IDLE_CLIP_NAMES: Array[String] = ["Idle", "idle"]
const LOCOMOTION_CLIP_NAMES: Array[String] = ["Jog", "Run", "Walk", "walk"]
const ATTACK_CLIP_NAMES: Array[String] = ["Sword_Attack", "SwordAttack", "Attack", "attack"]
const HURT_CLIP_NAMES: Array[String] = ["Hurt", "hurt", "Hit", "hit", "Stagger", "stagger"]
const DEATH_CLIP_NAMES: Array[String] = ["Death", "death", "Dying"]


static func inspect_scene(model_path: String) -> Dictionary:
	var clean_path := model_path.strip_edges()
	var result: Dictionary = {
		"path": clean_path,
		"exists": false,
		"packed_scene": false,
		"node3d_root": false,
		"renderable": false,
		"mesh_count": 0,
		"skeleton_count": 0,
		"animation_player_count": 0,
		"animation_clip_count": 0,
		"animation_nonempty_clip_count": 0,
		"animation_pose_clip_count": 0,
		"animation_pose_track_count": 0,
		"animation_root_transform_track_count": 0,
		# Compatibility name retained for diagnostics created before pose-track validation.
		# A usable clip now specifically means a clip with real non-root 3D pose/blend-shape
		# tracks that the runtime can play without moving the presentation proxy itself.
		"animation_usable_clip_count": 0,
		"animation_names": [],
		"semantic_animation_clips": {},
		"animation_contract_player_count": 0,
		"animation_contract_player_path": "",
		"animation_contract_ready": false,
		"activation_ready": false,
		"state": "absent",
	}
	if clean_path.is_empty() or not ResourceLoader.exists(clean_path):
		return result

	result["exists"] = true
	var resource := load(clean_path)
	if not (resource is PackedScene):
		result["state"] = "not_packed_scene"
		return result
	result["packed_scene"] = true

	var instance := (resource as PackedScene).instantiate()
	if not (instance is Node3D):
		result["state"] = "non_node3d_root"
		if instance != null:
			instance.free()
		return result

	var root := instance as Node3D
	result["node3d_root"] = true
	_scan_node(root, result, root)
	result["renderable"] = int(result.get("mesh_count", 0)) > 0
	# Any scene-root transform animation is root motion from the bridge's perspective,
	# including an autoplay/helper player that the semantic driver would otherwise ignore.
	# Reject the direct-GLB handoff until that motion is removed or retargeted deliberately.
	result["animation_contract_ready"] = (
		int(result.get("animation_contract_player_count", 0)) > 0
		and int(result.get("animation_root_transform_track_count", 0)) == 0
	)
	# Keep incomplete-model diagnostics useful by reporting the union of pose-bearing names
	# only when no single runtime-compatible scene contract has passed.
	if not bool(result["animation_contract_ready"]):
		result["semantic_animation_clips"] = _semantic_animation_clips(result.get("animation_names", []))
	result["activation_ready"] = bool(result["renderable"]) and bool(result["animation_contract_ready"])
	if not bool(result["renderable"]):
		result["state"] = "non_renderable"
	elif not bool(result["animation_contract_ready"]):
		result["state"] = "animation_contract_incomplete"
	else:
		result["state"] = "activation_ready"
	root.free()
	return result


## Inspects one AnimationPlayer using the same semantic/pose rules as final-model intake.
## Runtime selection calls this too so CI cannot approve clips distributed across multiple
## players while the game accidentally drives some unrelated first AnimationPlayer.
static func inspect_animation_player(animation_player: AnimationPlayer, scene_root: Node = null) -> Dictionary:
	var result: Dictionary = {
		"pose_names": [],
		"semantic_animation_clips": {},
		"contract_ready": false,
		"nonempty_clip_count": 0,
		"pose_clip_count": 0,
		"pose_track_count": 0,
		"root_transform_track_count": 0,
	}
	if animation_player == null:
		return result

	var pose_names: Array = []
	for animation_name: StringName in animation_player.get_animation_list():
		var animation := animation_player.get_animation(animation_name)
		if animation == null or animation.get_track_count() <= 0:
			continue
		result["nonempty_clip_count"] = int(result["nonempty_clip_count"]) + 1
		var summary := _pose_track_summary(animation, animation_player, scene_root)
		result["root_transform_track_count"] = int(result["root_transform_track_count"]) + int(summary.get("root_transform_track_count", 0))
		var pose_track_count := int(summary.get("pose_track_count", 0))
		if pose_track_count <= 0:
			continue
		result["pose_clip_count"] = int(result["pose_clip_count"]) + 1
		result["pose_track_count"] = int(result["pose_track_count"]) + pose_track_count
		var clip_name := str(animation_name)
		if not pose_names.has(clip_name):
			pose_names.append(clip_name)

	result["pose_names"] = pose_names
	var semantics := _semantic_animation_clips(pose_names)
	result["semantic_animation_clips"] = semantics
	# Scene-root transform animation is root motion from the bridge's perspective. Even if
	# the same player also animates bones/meshes, do not let that player become the direct
	# production authority because the imported scene could visibly drift off its planar
	# gameplay proxy. Root-bone policy remains asset-specific and is intentionally not
	# guessed here before real final rigs land.
	result["contract_ready"] = _semantic_contract_ready(semantics) and int(result["root_transform_track_count"]) == 0
	return result


static func _scan_node(node: Node, result: Dictionary, scene_root: Node) -> void:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		result["mesh_count"] = int(result.get("mesh_count", 0)) + 1
	if node is Skeleton3D:
		result["skeleton_count"] = int(result.get("skeleton_count", 0)) + 1
	if node is AnimationPlayer:
		var animation_player := node as AnimationPlayer
		result["animation_player_count"] = int(result.get("animation_player_count", 0)) + 1
		result["animation_clip_count"] = int(result.get("animation_clip_count", 0)) + animation_player.get_animation_list().size()
		var player_result := inspect_animation_player(animation_player, scene_root)
		result["animation_nonempty_clip_count"] = int(result.get("animation_nonempty_clip_count", 0)) + int(player_result.get("nonempty_clip_count", 0))
		result["animation_pose_clip_count"] = int(result.get("animation_pose_clip_count", 0)) + int(player_result.get("pose_clip_count", 0))
		result["animation_pose_track_count"] = int(result.get("animation_pose_track_count", 0)) + int(player_result.get("pose_track_count", 0))
		result["animation_root_transform_track_count"] = int(result.get("animation_root_transform_track_count", 0)) + int(player_result.get("root_transform_track_count", 0))
		result["animation_usable_clip_count"] = int(result.get("animation_usable_clip_count", 0)) + int(player_result.get("pose_clip_count", 0))

		var names_value: Variant = result.get("animation_names", [])
		var names: Array = names_value if names_value is Array else []
		var player_names_value: Variant = player_result.get("pose_names", [])
		var player_names: Array = player_names_value if player_names_value is Array else []
		for clip_name_value: Variant in player_names:
			var clip_name := str(clip_name_value)
			if not names.has(clip_name):
				names.append(clip_name)
		result["animation_names"] = names

		if bool(player_result.get("contract_ready", false)):
			result["animation_contract_player_count"] = int(result.get("animation_contract_player_count", 0)) + 1
			if str(result.get("animation_contract_player_path", "")).is_empty():
				result["animation_contract_player_path"] = str(scene_root.get_path_to(animation_player)) if scene_root != null else str(animation_player.get_path())
				var semantic_value: Variant = player_result.get("semantic_animation_clips", {})
				result["semantic_animation_clips"] = (semantic_value as Dictionary).duplicate(true) if semantic_value is Dictionary else {}
	for child: Node in node.get_children():
		_scan_node(child, result, scene_root)


static func _pose_track_summary(animation: Animation, animation_player: AnimationPlayer, scene_root: Node) -> Dictionary:
	var pose_tracks := 0
	var root_transform_tracks := 0
	for track_index: int in range(animation.get_track_count()):
		var track_type := animation.track_get_type(track_index)
		if track_type not in [
			Animation.TYPE_POSITION_3D,
			Animation.TYPE_ROTATION_3D,
			Animation.TYPE_SCALE_3D,
			Animation.TYPE_BLEND_SHAPE,
		]:
			continue
		# A single-key transform is a pose declaration, not evidence that the semantic clip
		# actually animates. Requiring at least two samples prevents static/marker-only final
		# scenes from displacing a proven animated fallback while remaining compatible with
		# normal imported glTF skeletal and blend-shape animation tracks.
		if animation.track_get_key_count(track_index) < 2:
			continue
		if track_type != Animation.TYPE_BLEND_SHAPE and scene_root != null and _track_targets_scene_root(animation_player, animation.track_get_path(track_index), scene_root):
			root_transform_tracks += 1
			continue
		pose_tracks += 1
	return {
		"pose_track_count": pose_tracks,
		"root_transform_track_count": root_transform_tracks,
	}


static func _track_targets_scene_root(animation_player: AnimationPlayer, track_path: NodePath, scene_root: Node) -> bool:
	if animation_player == null or scene_root == null:
		return false
	var animation_root := animation_player.get_node_or_null(animation_player.root_node)
	if animation_root == null:
		return false
	var node_names := str(track_path.get_concatenated_names())
	if node_names.is_empty():
		return false
	var target := animation_root.get_node_or_null(NodePath(node_names))
	return target == scene_root


static func _semantic_animation_clips(names_value: Variant) -> Dictionary:
	var names: Array = names_value if names_value is Array else []
	return {
		"idle": _first_exact_clip(names, IDLE_CLIP_NAMES),
		"locomotion": _first_exact_clip(names, LOCOMOTION_CLIP_NAMES),
		"attack": _first_exact_clip(names, ATTACK_CLIP_NAMES),
		"hurt": _first_exact_clip(names, HURT_CLIP_NAMES),
		"death": _first_exact_clip(names, DEATH_CLIP_NAMES),
	}


static func _semantic_contract_ready(semantic_clips: Dictionary) -> bool:
	return (
		not str(semantic_clips.get("idle", "")).is_empty()
		and not str(semantic_clips.get("locomotion", "")).is_empty()
		and not str(semantic_clips.get("attack", "")).is_empty()
	)


static func _first_exact_clip(names: Array, candidates: Array[String]) -> String:
	for candidate: String in candidates:
		if names.has(candidate):
			return candidate
	return ""
