extends Node

## Headless compatibility probe for curated third-party 3D sources used by the Hushiro
## vertical slice. The asset manifest verifies provenance/exact bytes and GLTFImportProbe
## validates the raw source skeleton/animation contract. This smoke protects the runtime
## resources Oathbound actually consumes after Godot import.

const CHARACTER_PATH := "res://Art3D/ThirdParty/Quaternius/UniversalBaseCharacters/superhero_male_reference.glb"
const ANIMATION_PATH := "res://Art3D/ThirdParty/Quaternius/UniversalAnimationLibrary/universal_animation_library.glb"
const MIN_HUMANOID_BONES := 50
const MIN_IMPORTED_ANIMATIONS := 5

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var character := _instantiate_character()
	var animation_library := _load_animation_library()
	if character == null or animation_library == null:
		_finish()
		return

	add_child(character)
	await get_tree().process_frame

	var character_stats := _inspect_character(character)
	var character_bones: Array = character_stats.get("bone_names", []) as Array
	_expect(int(character_stats.get("mesh_count", 0)) > 0, "humanoid reference contains no MeshInstance3D")
	_expect(int(character_stats.get("skeleton_count", 0)) > 0, "humanoid reference contains no Skeleton3D")
	_expect(character_bones.size() >= MIN_HUMANOID_BONES, "humanoid imported skeleton exposes fewer than %d bones" % MIN_HUMANOID_BONES)

	var animation_names := animation_library.get_animation_list()
	_expect(animation_names.size() >= MIN_IMPORTED_ANIMATIONS, "AnimationLibrary exposes fewer than %d clips" % MIN_IMPORTED_ANIMATIONS)
	var clips_with_tracks := 0
	var total_tracks := 0
	var semantic_tokens: Dictionary = {
		"idle": false,
		"locomotion": false,
		"attack": false,
	}
	for animation_name: StringName in animation_names:
		var animation := animation_library.get_animation(animation_name)
		if animation == null:
			continue
		var track_count := animation.get_track_count()
		total_tracks += track_count
		if track_count > 0:
			clips_with_tracks += 1
		var lower := str(animation_name).to_lower()
		if lower.contains("idle"):
			semantic_tokens["idle"] = true
		if lower.contains("walk") or lower.contains("run") or lower.contains("jog") or lower.contains("move"):
			semantic_tokens["locomotion"] = true
		if lower.contains("attack") or lower.contains("slash") or lower.contains("sword") or lower.contains("melee"):
			semantic_tokens["attack"] = true

	_expect(clips_with_tracks >= MIN_IMPORTED_ANIMATIONS, "imported AnimationLibrary clips contain no usable tracks")
	_expect(total_tracks > 0, "imported AnimationLibrary contains zero animation tracks")
	_expect(bool(semantic_tokens.get("idle", false)), "AnimationLibrary exposes no identifiable idle clip")
	_expect(bool(semantic_tokens.get("locomotion", false)), "AnimationLibrary exposes no identifiable locomotion clip")

	var preview_count := mini(16, animation_names.size())
	print(
		"[ThirdParty3DAssetSmoke] humanoid meshes=%d skeletons=%d bones=%d | imported clips=%d tracked=%d tracks=%d | semantic=%s | preview=%s"
		% [
			int(character_stats.get("mesh_count", 0)),
			int(character_stats.get("skeleton_count", 0)),
			character_bones.size(),
			animation_names.size(),
			clips_with_tracks,
			total_tracks,
			str(semantic_tokens),
			str(animation_names.slice(0, preview_count)),
		]
	)
	if not bool(semantic_tokens.get("attack", false)):
		print("[ThirdParty3DAssetSmoke] ATTACK_CLIP_OPTIONAL - combat-synced manual upper-body attack pose remains available")

	character.queue_free()
	await get_tree().process_frame
	_finish()


func _instantiate_character() -> Node3D:
	if not ResourceLoader.exists(CHARACTER_PATH):
		_fail("humanoid reference missing at %s" % CHARACTER_PATH)
		return null
	var packed := load(CHARACTER_PATH) as PackedScene
	if packed == null:
		_fail("humanoid reference did not import as PackedScene")
		return null
	var instance := packed.instantiate()
	if not (instance is Node3D):
		if instance != null:
			instance.queue_free()
		_fail("humanoid reference root is not Node3D")
		return null
	(instance as Node3D).name = "HumanoidReference"
	return instance as Node3D


func _load_animation_library() -> AnimationLibrary:
	if not ResourceLoader.exists(ANIMATION_PATH):
		_fail("animation library missing at %s" % ANIMATION_PATH)
		return null
	var resource := load(ANIMATION_PATH)
	if not (resource is AnimationLibrary):
		_fail("animation source did not import as AnimationLibrary (got %s)" % resource.get_class() if resource != null else "animation source failed to load")
		return null
	return resource as AnimationLibrary


func _inspect_character(root: Node) -> Dictionary:
	var stats := {
		"mesh_count": 0,
		"skeleton_count": 0,
		"bone_names": [],
	}
	_collect_character_stats(root, stats)
	return stats


func _collect_character_stats(node: Node, stats: Dictionary) -> void:
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
	for child: Node in node.get_children():
		_collect_character_stats(child, stats)


func _finish() -> void:
	if _failures.is_empty():
		print("[ThirdParty3DAssetSmoke] PASS - curated humanoid + imported AnimationLibrary are runtime-ready")
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
