extends Node

## Proves that a syntactically valid external scene with no renderable mesh cannot displace
## the shared actor fallback. This protects future production-GLB handoffs from making a
## combatant disappear merely because a placeholder/empty scene exists at the slot path.

const ACTOR_VISUAL_SCRIPT = preload("res://Utility/Planar3DActorVisual.gd")
const NON_RENDERABLE_MODEL := "res://Regions/Hushiro/Validation/Planar3DNonRenderableModel.tscn"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var source := CharacterBody2D.new()
	source.name = "ExternalModelFallbackSource"
	add_child(source)

	var visual_value: Variant = ACTOR_VISUAL_SCRIPT.new()
	if not (visual_value is Node3D):
		_fail("shared Planar3D actor visual failed to instantiate")
		_finish()
		return
	var visual := visual_value as Node3D
	visual.name = "ExternalModelFallbackVisual"
	visual.call("set_external_model_path", NON_RENDERABLE_MODEL)
	visual.call("configure", "enemy", source)
	add_child(visual)

	for _i: int in range(2):
		await get_tree().process_frame
	_assert_safe_fallback(visual, "initial invalid external candidate")

	# Exercise the same rejection through a runtime model-path refresh. A queued old rig
	# must not be mistaken for successful imported geometry and the rebuilt visual must
	# finish with a real fallback mesh again.
	visual.call("set_external_model_path", NON_RENDERABLE_MODEL)
	for _i: int in range(2):
		await get_tree().process_frame
	_assert_safe_fallback(visual, "runtime invalid external candidate refresh")

	visual.queue_free()
	source.queue_free()
	await get_tree().process_frame
	_finish()


func _assert_safe_fallback(visual: Node3D, context: String) -> void:
	_expect(not bool(visual.get("_external_model_active")), "%s incorrectly marked empty model active" % context)
	_expect(visual.get_node_or_null("VisualRoot/ImportedModel") == null, "%s retained an ImportedModel node" % context)
	var root := visual.get_node_or_null("VisualRoot")
	if root == null:
		_fail("%s lost VisualRoot" % context)
		return
	var mesh_count := 0
	for candidate: Node in root.find_children("*", "MeshInstance3D", true, false):
		if candidate is MeshInstance3D and (candidate as MeshInstance3D).mesh != null:
			mesh_count += 1
	_expect(mesh_count >= 2, "%s did not rebuild renderable procedural fallback" % context)


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DExternalModelFallbackSmoke] PASS - non-renderable external scenes are rejected and procedural fallback remains renderable")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DExternalModelFallbackSmoke] %s" % failure)
	print("[Planar3DExternalModelFallbackSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
