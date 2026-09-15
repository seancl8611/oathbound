extends Node

## Diagnostic probe that bypasses ResourceImporterScene and exercises GLTFDocument
## directly. This distinguishes a source glTF problem from editor scene-import
## configuration when third-party humanoids arrive with unexpected Skeleton3D data.

const SOURCES := [
	"res://Art3D/ThirdParty/Quaternius/UniversalBaseCharacters/superhero_male_reference.glb",
	"res://Art3D/ThirdParty/Quaternius/UniversalAnimationLibrary/universal_animation_library.glb",
]

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	for source_path: String in SOURCES:
		_probe(source_path)
	if _failures.is_empty():
		print("[GLTFImportProbe] PASS - direct GLTFDocument parse/generate completed")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[GLTFImportProbe] %s" % failure)
	print("[GLTFImportProbe] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _probe(source_path: String) -> void:
	var document := GLTFDocument.new()
	var state := GLTFState.new()
	var error := document.append_from_file(source_path, state)
	if error != OK:
		_fail("append_from_file failed for %s with Error=%d" % [source_path, error])
		return

	var skeletons: Array = state.get_skeletons()
	var animations: Array = state.get_animations()
	var state_joint_counts: Array[int] = []
	for skeleton_variant: Variant in skeletons:
		var skeleton := skeleton_variant as GLTFSkeleton
		if skeleton != null:
			state_joint_counts.append(skeleton.joints.size())
	var state_animation_names: Array[String] = []
	for animation_variant: Variant in animations:
		var animation := animation_variant as GLTFAnimation
		if animation != null:
			state_animation_names.append(animation.original_name)

	print(
		"[GLTFImportProbe] state source=%s nodes=%d skeletons=%d joints=%s animations=%d names=%s"
		% [
			source_path,
			state.get_nodes().size(),
			skeletons.size(),
			str(state_joint_counts),
			animations.size(),
			str(state_animation_names),
		]
	)

	var generated := document.generate_scene(state, 30.0, false, false)
	if generated == null:
		_fail("generate_scene returned null for %s" % source_path)
		return
	var generated_stats := {
		"skeleton_count": 0,
		"bone_counts": [],
		"animation_player_count": 0,
		"animation_names": [],
	}
	_collect_generated(generated, generated_stats)
	print(
		"[GLTFImportProbe] generated source=%s skeletons=%d bones=%s animation_players=%d names=%s"
		% [
			source_path,
			int(generated_stats.get("skeleton_count", 0)),
			str(generated_stats.get("bone_counts", [])),
			int(generated_stats.get("animation_player_count", 0)),
			str(generated_stats.get("animation_names", [])),
		]
	)
	generated.free()

	if skeletons.is_empty():
		_fail("GLTFState exposed no skeleton for %s" % source_path)
	elif state_joint_counts.max() < 50:
		_fail("GLTFState largest skeleton has fewer than 50 joints for %s" % source_path)
	if animations.is_empty():
		_fail("GLTFState exposed no animations for %s" % source_path)


func _collect_generated(node: Node, stats: Dictionary) -> void:
	if node is Skeleton3D:
		stats["skeleton_count"] = int(stats.get("skeleton_count", 0)) + 1
		var counts: Array = stats.get("bone_counts", []) as Array
		counts.append((node as Skeleton3D).get_bone_count())
	elif node is AnimationPlayer:
		stats["animation_player_count"] = int(stats.get("animation_player_count", 0)) + 1
		var names: Array = stats.get("animation_names", []) as Array
		for animation_name: StringName in (node as AnimationPlayer).get_animation_list():
			if str(animation_name) != "RESET":
				names.append(str(animation_name))
	for child: Node in node.get_children():
		_collect_generated(child, stats)


func _fail(message: String) -> void:
	_failures.append(message)
