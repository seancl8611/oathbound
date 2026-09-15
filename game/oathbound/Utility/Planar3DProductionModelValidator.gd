extends RefCounted

## Read-only inspection for canonical production-model slots.
##
## Runtime presenters already reject non-renderable external scenes. This validator gives
## CI/diagnostics the same early warning before final art silently falls back to a curated
## or authored placeholder. It intentionally avoids role-specific scale/material/rig rules
## until real production assets exist, but it does enforce the animation aliases that the
## current shared production-model adapter can actually drive.

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
		"animation_usable_clip_count": 0,
		"animation_names": [],
		"semantic_animation_clips": {},
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
	_scan_node(root, result)
	result["renderable"] = int(result.get("mesh_count", 0)) > 0
	var semantic_clips := _semantic_animation_clips(result.get("animation_names", []))
	result["semantic_animation_clips"] = semantic_clips
	result["animation_contract_ready"] = (
		not str(semantic_clips.get("idle", "")).is_empty()
		and not str(semantic_clips.get("locomotion", "")).is_empty()
		and not str(semantic_clips.get("attack", "")).is_empty()
	)
	result["activation_ready"] = bool(result["renderable"]) and bool(result["animation_contract_ready"])
	if not bool(result["renderable"]):
		result["state"] = "non_renderable"
	elif not bool(result["animation_contract_ready"]):
		result["state"] = "animation_contract_incomplete"
	else:
		result["state"] = "activation_ready"
	root.free()
	return result


static func _scan_node(node: Node, result: Dictionary) -> void:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		result["mesh_count"] = int(result.get("mesh_count", 0)) + 1
	if node is Skeleton3D:
		result["skeleton_count"] = int(result.get("skeleton_count", 0)) + 1
	if node is AnimationPlayer:
		var animation_player := node as AnimationPlayer
		result["animation_player_count"] = int(result.get("animation_player_count", 0)) + 1
		for animation_name: StringName in animation_player.get_animation_list():
			result["animation_clip_count"] = int(result.get("animation_clip_count", 0)) + 1
			var animation := animation_player.get_animation(animation_name)
			if animation == null or animation.get_track_count() <= 0:
				continue
			result["animation_usable_clip_count"] = int(result.get("animation_usable_clip_count", 0)) + 1
			var names_value: Variant = result.get("animation_names", [])
			var names: Array = names_value if names_value is Array else []
			var clip_name := str(animation_name)
			if not names.has(clip_name):
				names.append(clip_name)
			result["animation_names"] = names
	for child: Node in node.get_children():
		_scan_node(child, result)


static func _semantic_animation_clips(names_value: Variant) -> Dictionary:
	var names: Array = names_value if names_value is Array else []
	return {
		"idle": _first_exact_clip(names, IDLE_CLIP_NAMES),
		"locomotion": _first_exact_clip(names, LOCOMOTION_CLIP_NAMES),
		"attack": _first_exact_clip(names, ATTACK_CLIP_NAMES),
		"hurt": _first_exact_clip(names, HURT_CLIP_NAMES),
		"death": _first_exact_clip(names, DEATH_CLIP_NAMES),
	}


static func _first_exact_clip(names: Array, candidates: Array[String]) -> String:
	for candidate: String in candidates:
		if names.has(candidate):
			return candidate
	return ""
