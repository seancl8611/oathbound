extends Node

## Reproduces both manual-playtest lifetime failures where a defeated authoritative
## Node2D is freed before presentation cleanup. V3 must retire the orphaned visual without
## evaluating any `is` type check against the freed instance during either per-frame sync
## or the periodic reconciliation pass.

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

	_test_sync_cleanup(bridge)
	_test_reconcile_cleanup(bridge)
	_finish()


func _test_sync_cleanup(bridge: Node) -> void:
	var pair := _create_disposable_pair("Sync")
	if pair.is_empty():
		return
	var source := pair["source"] as Node2D
	var visual := pair["visual"] as Node3D
	var actor_id := source.get_instance_id()
	bridge.set("_actor_visuals", {actor_id: visual})
	source.free()
	bridge.call("_sync_actor_visuals", 0.016)
	_expect_registry_missing(bridge, actor_id, "sync")


func _test_reconcile_cleanup(bridge: Node) -> void:
	var pair := _create_disposable_pair("Reconcile")
	if pair.is_empty():
		return
	var source := pair["source"] as Node2D
	var visual := pair["visual"] as Node3D
	var actor_id := source.get_instance_id()
	bridge.set("_actor_visuals", {actor_id: visual})
	source.free()
	bridge.call("_reconcile_actors")
	_expect_registry_missing(bridge, actor_id, "reconcile")


func _create_disposable_pair(label: String) -> Dictionary:
	var source := Node2D.new()
	source.name = "%sDisposableSourceActor" % label
	add_child(source)

	var visual_value: Variant = ACTOR_VISUAL_SCRIPT.new()
	if not (visual_value is Node3D):
		_fail("could not instantiate actor visual for %s path" % label.to_lower())
		source.free()
		return {}
	var visual := visual_value as Node3D
	visual.call("configure", "player", source)
	add_child(visual)
	return {"source": source, "visual": visual}


func _expect_registry_missing(bridge: Node, actor_id: int, path_name: String) -> void:
	var remaining_value: Variant = bridge.get("_actor_visuals")
	if not (remaining_value is Dictionary):
		_fail("bridge actor-visual registry was not a Dictionary after %s" % path_name)
		return
	var remaining := remaining_value as Dictionary
	_expect(not remaining.has(actor_id), "freed source left an orphaned presentation visual registered after %s" % path_name)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DFreedSourceLifetimeSmoke] PASS - sync and reconciliation retire freed authoritative actors without invalid-instance type checks")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DFreedSourceLifetimeSmoke] %s" % failure)
	get_tree().quit(1)
