extends Node

## Headless compatibility probe for curated third-party 3D sources used by the Hushiro
## vertical slice. The asset manifest already verifies provenance and exact bytes; this
## smoke verifies the installed GLBs are useful to Godot before they enter live actor
## slots. Visual/skeleton readiness is a hard gate. Animation playback is tracked as a
## separate retargeting capability so a Godot importer limitation cannot falsely mark a
## sound model as unusable.

const CHARACTER_PATH := "res://Art3D/ThirdParty/Quaternius/UniversalBaseCharacters/superhero_male_reference.glb"
const ANIMATION_PATH := "res://Art3D/ThirdParty/Quaternius/UniversalAnimationLibrary/universal_animation_library.glb"
const MIN_HUMANOID_BONES := 50
const MIN_BONE_OVERLAP := 0.95

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var character := _instantiate_scene(CHARACTER_PATH, "humanoid reference")
	var animation_source := _instantiate_scene(ANIMATION_PATH, "animation library")
	if character == null or animation_source == null:
		_finish()
		return

	add_child(character)
	add_child(animation_source)
	await get_tree().process_frame

	var character_stats := _inspect_scene(character)
	var animation_stats := _inspect_scene(animation_source)
	var character_bones: Array = character_stats.get("bone_names", []) as Array
	var animation_bones: Array = animation_stats.get("bone_names", []) as Array
	var animation_names: Array = animation_stats.get("animation_names", []) as Array

	_expect(int(character_stats.get("mesh_count", 0)) > 0, "humanoid reference contains no MeshInstance3D")
	_expect(int(character_stats.get("skeleton_count", 0)) > 0, "humanoid reference contains no Skeleton3D")
	_expect(character_bones.size() >= MIN_HUMANOID_BONES, "humanoid imported skeleton exposes fewer than %d bones" % MIN_HUMANOID_BONES)
	_expect(int(animation_stats.get("skeleton_count", 0)) > 0, "animation library contains no Skeleton3D")
	_expect(animation_bones.size() >= MIN_HUMANOID_BONES, "animation imported skeleton exposes fewer than %d bones" % MIN_HUMANOID_BONES)
	_expect(int(animation_stats.get("animation_player_count", 0)) > 0, "animation library contains no AnimationPlayer")

	var overlap := _bone_overlap_ratio(character_bones, animation_bones)
	_expect(overlap >= MIN_BONE_OVERLAP, "Quaternius character/animation skeleton overlap fell below %.0f%% (%.1f%%)" % [MIN_BONE_OVERLAP * 100.0, overlap * 100.0])

	print(
		"[ThirdParty3DAssetSmoke] humanoid meshes=%d skeletons=%d bones=%d | animation players=%d clips=%d bones=%d | bone_overlap=%.1f%%"
		% [
			int(character_stats.get("mesh_count", 0)),
			int(character_stats.get("skeleton_count", 0)),
			character_bones.size(),
			int(animation_stats.get("animation_player_count", 0)),
			animation_names.size(),
			animation_bones.size(),
			overlap * 100.0,
		]
	)
	if animation_names.size() >= 4:
		var preview_count := mini(12, animation_names.size())
		print("[ThirdParty3DAssetSmoke] clip preview=%s" % str(animation_names.slice(0, preview_count)))
	else:
		print("[ThirdParty3DAssetSmoke] RETARGET_PENDING - imported scene does not yet expose the verified source clips")

	character.queue_free()
	animation_source.queue_free()
	await get_tree().process_frame
	_finish()


func _instantiate_scene(path: String, label: String) -> Node3D:
	if not ResourceLoader.exists(path):
		_fail("%s missing at %s" % [label, path])
		return null
	var packed := load(path) as PackedScene
	if packed == null:
		_fail("%s did not import as PackedScene" % label)
		return null
	var instance := packed.instantiate()
	if not (instance is Node3D):
		if instance != null:
			instance.queue_free()
		_fail("%s root is not Node3D" % label)
		return null
	(instance as Node3D).name = label.replace(" ", "_").capitalize()
	return instance as Node3D


func _inspect_scene(root: Node) -> Dictionary:
	var stats := {
		"mesh_count": 0,
		"skeleton_count": 0,
		"animation_player_count": 0,
		"animation_names": [],
		"bone_names": [],
	}
	_collect_stats(root, stats)
	return stats


func _collect_stats(node: Node, stats: Dictionary) -> void:
	if node is MeshInstance3D:
		stats["mesh_count"] = int(stats.get("mesh_count", 0)) + 1
	elif node is Skeleton3D:
		stats["skeleton_count"] = int(stats.get("skeleton_count", 0)) + 1
		var skeleton := node as Skeleton3D
		var bones: Array = stats.get("bone_names", []) as Array
		for bone_index: int in range(skeleton.get_bone_count()):
			var bone_name := str(skeleton.get_bone_name(bone_index))
			if not bones.has(bone_name):
				bones.append(bone_name)
	elif node is AnimationPlayer:
		stats["animation_player_count"] = int(stats.get("animation_player_count", 0)) + 1
		var player := node as AnimationPlayer
		var names: Array = stats.get("animation_names", []) as Array
		for clip_name: StringName in player.get_animation_list():
			var clip := str(clip_name)
			if clip != "RESET" and not names.has(clip):
				names.append(clip)

	for child: Node in node.get_children():
		_collect_stats(child, stats)


func _bone_overlap_ratio(character_bones: Array, animation_bones: Array) -> float:
	if character_bones.is_empty() or animation_bones.is_empty():
		return 0.0
	var animation_set: Dictionary = {}
	for bone_name: Variant in animation_bones:
		animation_set[str(bone_name)] = true
	var overlap := 0
	for bone_name: Variant in character_bones:
		if animation_set.has(str(bone_name)):
			overlap += 1
	return float(overlap) / float(maxi(1, mini(character_bones.size(), animation_bones.size())))


func _finish() -> void:
	if _failures.is_empty():
		print("[ThirdParty3DAssetSmoke] PASS - curated GLBs are visual/skeleton compatible; animation retarget readiness reported separately")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[ThirdParty3DAssetSmoke] %s" % failure)
	print("[ThirdParty3DAssetSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
