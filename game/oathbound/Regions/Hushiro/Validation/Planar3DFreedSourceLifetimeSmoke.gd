extends Node

## Reproduces the manual-playtest failure where a defeated authoritative Node2D is freed
## before the next presentation reconciliation. The V3 bridge must retire the orphaned
## visual without evaluating a type check against the freed instance.

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridgeV3.gd")
const ACTOR_VISUAL_SCRIPT = preload("res://Utility/Planar3DActorVisual.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("could not instantiate V3 bridge")
		_finish()
		return
	var bridge := bridge_value as Node
	bridge.set("enabled", false)
	add_child(bridge)

	var source := Node2D.new()
	source.name = "DisposableSourceActor"
	add_child(source)
	var actor_id := source.get_instance_id()

	var visual_value: Variant = ACTOR_VISUAL_SCRIPT.new()
	if not (visual_value is Node3D):
		_fail("could not instantiate actor visual")
		_finish()
		return
	var visual := visual_value as Node3D
	visual.call("configure", "player", source)
	add_child(visual)

	bridge.set("_actor_visuals", {actor_id: visual})
	source.free()
	bridge.call("_sync_actor_visuals", 0.016)

	var remaining_value: Variant = bridge.get("_actor_visuals")
	if not (remaining_value is Dictionary):
		_fail("bridge actor-visual registry was not a Dictionary")
	else:
		var remaining := remaining_value as Dictionary
		_expect(not remaining.has(actor_id), "freed source left an orphaned presentation visual registered")

	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DFreedSourceLifetimeSmoke] PASS - freed authoritative actors retire presentation visuals without invalid-instance type checks")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DFreedSourceLifetimeSmoke] %s" % failure)
	get_tree().quit(1)
