extends Node

## Regression proof for Planar3D failure/lifecycle safety.
##
## The validation bridge moves through initial failure, empty/non-renderable replacement,
## successful replacement, lost replacement, rebuild failure, runtime exclusivity toggling,
## group removal and full bridge disable/re-enable. At every point the authoritative 2D
## body must remain safely recoverable rather than becoming permanently invisible.

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
	_expect(legacy_body.visible, "initial failed actor replacement incorrectly hid authoritative legacy body")

	# A Node3D existing is not sufficient proof that an actor has renderable replacement
	# content. Reject an intentionally empty presenter and preserve the authoritative body.
	bridge.call("set_actor_visuals_allowed", true)
	bridge.call("set_return_empty_visual", true)
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(legacy_body.visible, "empty/non-renderable replacement incorrectly hid authoritative legacy body")

	# Prove a valid replacement hides the legacy body.
	bridge.call("set_return_empty_visual", false)
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(not legacy_body.visible, "successful actor replacement did not suppress legacy body")

	# Simulate a replacement disappearing after it already hid the body, then make the
	# rebuild fail. This is the production failure mode that can otherwise create an
	# invisible-but-still-authoritative live actor.
	bridge.call("set_actor_visuals_allowed", false)
	bridge.call("drop_actor_visuals")
	await get_tree().process_frame
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(legacy_body.visible, "lost replacement plus failed rebuild stranded legacy body hidden")

	# Recovery must remain possible after the failure.
	bridge.call("set_actor_visuals_allowed", true)
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(not legacy_body.visible, "replacement did not recover after a failed rebuild")

	# Runtime exclusivity changes must be reversible without restarting the room.
	bridge.set("hide_legacy_actor_art", false)
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(legacy_body.visible, "disabling exclusive replacement did not restore legacy actor art")
	bridge.set("hide_legacy_actor_art", true)
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(not legacy_body.visible, "re-enabling exclusive replacement did not hide legacy actor art")

	# If an actor temporarily leaves the presentation set while remaining alive, removing
	# its replacement must restore its authoritative body before the visual is discarded.
	player.remove_from_group("player")
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(legacy_body.visible, "actor leaving presentation group remained hidden after replacement removal")
	player.add_to_group("player")
	bridge.call("_reconcile_actors")
	await get_tree().process_frame
	_expect(not legacy_body.visible, "actor rejoining presentation group did not regain replacement")

	bridge.call("set_presentation_enabled", false)
	for _i: int in range(2):
		await get_tree().process_frame

	_expect(not bool(bridge.call("is_presentation_enabled")), "bridge did not deactivate")
	_expect(background.visible, "legacy Background was not restored after disabling live 3D")
	_expect(scenery.visible, "legacy Scenery was not restored after disabling live 3D")
	_expect(legacy_body.visible, "legacy actor body was not restored during presentation shutdown")

	# Re-enable with actor creation failing again: room replacement may activate, but actor
	# authority must stay visible until a valid replacement exists.
	bridge.call("set_actor_visuals_allowed", false)
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
		print("[Planar3DFailSafeSmoke] PASS - empty/lost/failed replacements preserve legacy actor art and bridge lifecycle remains reversible")
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
