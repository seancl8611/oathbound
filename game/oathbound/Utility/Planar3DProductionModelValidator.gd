extends RefCounted

## Read-only inspection for canonical production-model slots.
##
## Runtime presenters already reject non-renderable external scenes. This validator gives
## CI/diagnostics the same early warning before final art silently falls back to a curated
## or authored placeholder. It intentionally does not impose role-specific scale, rig,
## material, or animation requirements before the real production assets exist.


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
	result["state"] = "renderable" if bool(result.get("renderable", false)) else "non_renderable"
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
		result["animation_clip_count"] = int(result.get("animation_clip_count", 0)) + animation_player.get_animation_list().size()
	for child: Node in node.get_children():
		_scan_node(child, result)
