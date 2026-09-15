extends Node

## Regression proof for the first live-3D real-player failure: opaque legacy 2D room art
## must not be able to cover the SubViewport presentation, while planar CombatFX remain
## visible and mirrored 3D actors remain above temporary raised floor geometry.

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridge.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var room := Node2D.new()
	room.name = "LayeringSmokeRoom"

	var background := Sprite2D.new()
	background.name = "Background"
	background.visible = true
	room.add_child(background)

	var presentation := Node2D.new()
	presentation.name = "ThreeQuarterPresentation"
	room.add_child(presentation)

	var scenery := Node2D.new()
	scenery.name = "Scenery"
	scenery.visible = true
	presentation.add_child(scenery)

	var combat_fx := Node2D.new()
	combat_fx.name = "CombatFX"
	combat_fx.visible = true
	presentation.add_child(combat_fx)

	var player := CharacterBody2D.new()
	player.name = "LayeringSmokePlayer"
	player.position = Vector2(24.0, 12.0)
	player.add_to_group("player")
	room.add_child(player)

	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("Hushiro 3D bridge failed to instantiate")
		_finish()
		return
	var bridge := bridge_value as Node
	bridge.name = "Planar3DPresentationBridge"
	room.add_child(bridge)

	add_child(room)
	for _i: int in range(5):
		await get_tree().process_frame

	_expect(bool(bridge.call("is_presentation_enabled")), "live 3D bridge did not activate")
	_expect(not background.visible, "legacy Background remained visible above live 3D")
	_expect(not scenery.visible, "legacy Scenery remained visible above live 3D")
	_expect(combat_fx.visible, "planar CombatFX was incorrectly hidden with legacy scenery")

	# Reproduce the initialization/order failure directly. Compatibility presentation code
	# may set these visible after the bridge's first hide pass. The Hushiro wrapper must
	# reclaim visual authority on the next frame without affecting CombatFX.
	background.visible = true
	scenery.visible = true
	for _i: int in range(2):
		await get_tree().process_frame

	_expect(not background.visible, "legacy Background visibility watchdog failed")
	_expect(not scenery.visible, "legacy Scenery visibility watchdog failed")
	_expect(combat_fx.visible, "CombatFX visibility was lost after the watchdog pass")

	var state_value: Variant = bridge.call("get_layering_state_for_test")
	if state_value is Dictionary:
		var state := state_value as Dictionary
		_expect(bool(state.get("background_hidden", false)), "bridge state reports visible legacy Background")
		_expect(bool(state.get("scenery_hidden", false)), "bridge state reports visible legacy Scenery")
		_expect(bool(state.get("combat_fx_visible", false)), "bridge state reports hidden CombatFX")
		_expect(int(state.get("actor_visual_count", 0)) >= 1, "3D player representation was not created")
		_expect(float(state.get("min_actor_y", 0.0)) >= 0.09, "3D actor root still intersects the temporary floor plane")
	else:
		_fail("bridge layering introspection unavailable")

	room.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DLayeringSmoke] PASS - legacy floor stays hidden | CombatFX preserved | actor ground lift")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DLayeringSmoke] %s" % failure)
	print("[Planar3DLayeringSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
