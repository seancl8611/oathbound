extends Node

## Regression proof for Planar3D failure/lifecycle safety.
##
## A validation-only bridge deliberately fails actor replacement while providing a valid
## 3D environment. The authoritative 2D body must remain visible, room art must restore
## when presentation is disabled, and re-enabling presentation must remain safe.

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Validation/Planar3DFailSafeBridge.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var room := Node2D.new()
	room.name = "Planar3DFailSafeRoom"

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

	var player := CharacterBody2D.new()
	player.name = "FailSafePlayer"
	player.add_to_group("player")
	room.add_child(player)

	var legacy_body := Sprite2D.new()
	legacy_body.name = "LegacyPlayerBody"
	legacy_body.visible = true
	player.add_child(legacy_body)

	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("failure-injection bridge failed to instantiate")
		_finish()
		return
	var bridge := bridge_value as Node
	bridge.name = "Planar3DPresentationBridge"
	room.add_child(bridge)

	add_child(room)
	for _i: int in range(5):
		await get_tree().process_frame

	_expect(bool(bridge.call("is_presentation_enabled")), "failure-injection bridge did not activate")
	_expect(not background.visible, "valid replacement environment did not suppress legacy Background")
	_expect(not scenery.visible, "valid replacement environment did not suppress legacy Scenery")
	_expect(legacy_body.visible, "failed actor replacement incorrectly hid authoritative legacy body")

	bridge.call("set_presentation_enabled", false)
	for _i: int in range(2):
		await get_tree().process_frame

	_expect(not bool(bridge.call("is_presentation_enabled")), "bridge did not deactivate")
	_expect(background.visible, "legacy Background was not restored after disabling live 3D")
	_expect(scenery.visible, "legacy Scenery was not restored after disabling live 3D")
	_expect(legacy_body.visible, "legacy actor body changed visibility during presentation shutdown")

	bridge.call("set_presentation_enabled", true)
	for _i: int in range(5):
		await get_tree().process_frame

	_expect(bool(bridge.call("is_presentation_enabled")), "bridge did not re-enable after shutdown")
	_expect(not background.visible, "legacy Background was not re-suppressed after re-enable")
	_expect(not scenery.visible, "legacy Scenery was not re-suppressed after re-enable")
	_expect(legacy_body.visible, "failed replacement hid authoritative body after re-enable")

	room.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DFailSafeSmoke] PASS - failed actor replacement preserves legacy body and bridge lifecycle restores safely")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DFailSafeSmoke] %s" % failure)
	print("[Planar3DFailSafeSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
