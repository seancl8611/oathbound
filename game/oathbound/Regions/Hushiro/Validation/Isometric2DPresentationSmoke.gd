extends Node

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation/HushiroIsometric2DPresentation.gd")
const CAMERA_SCRIPT = preload("res://Utility/CameraFollow.gd")
const DIRECTIONAL_PRESENTER_SCRIPT = preload("res://Utility/DirectionalActorPresentation.gd")

class MockLiveMovementPlayer:
	extends CharacterBody2D
	var _move_input: Vector2 = Vector2.RIGHT
	var _facing_dir: Vector2 = Vector2.RIGHT
	var _attack_aim_dir: Vector2 = Vector2.RIGHT
	var _dodge_dir: Vector2 = Vector2.RIGHT
	var _dodge_timer: float = 0.0
	var gameplay_state: String = "move"

	func get_directional_presentation_state() -> String:
		return gameplay_state

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var room := Node2D.new()
	room.name = "SmokeRoom"
	add_child(room)

	var player := CharacterBody2D.new()
	player.name = "SmokePlayer"
	player.add_to_group(&"player")
	player.velocity = Vector2(120.0, 0.0)
	room.add_child(player)

	var body := Sprite2D.new()
	body.name = "Sprite2D"
	player.add_child(body)

	var camera := Camera2D.new()
	camera.name = "Camera2D"
	camera.set_script(CAMERA_SCRIPT)
	camera.set("use_procedural_actor_proxies", false)
	camera.set("add_contact_shadows", false)
	player.add_child(camera)

	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("could not instantiate Hushiro isometric 2D bridge")
		_finish()
		return
	var bridge := bridge_value as Node
	room.add_child(bridge)

	await get_tree().process_frame
	await get_tree().process_frame

	var state_value: Variant = bridge.call("get_presentation_state_for_test")
	if not (state_value is Dictionary):
		_fail("presentation state was not a Dictionary")
		_finish()
		return
	var state := state_value as Dictionary
	_expect(str(state.get("runtime", "")) == "2d", "live Hushiro presentation did not report 2D runtime")
	_expect(int(state.get("revision", 0)) == 2, "rig-ready presentation revision is not active")
	_expect(int(state.get("direction_count", 0)) == 8, "directional actor contract is not eight-way")
	_expect(is_equal_approx(float(state.get("presentation_zoom", 0.0)), 0.50), "unexpected combat framing zoom")
	_expect(is_equal_approx(float(state.get("ground_vertical_compression", 0.0)), 0.72), "unexpected isometric ground compression")
	_expect(int(state.get("presenter_count", 0)) == 1, "player did not receive exactly one directional presenter")
	_expect(int(state.get("profiled_presenter_count", 0)) == 1, "player did not receive its rig-rendered 2D profile slot")
	_expect(bool(state.get("camera_configured", false)), "Camera2D was not configured by isometric presentation bridge")
	_expect(not body.visible, "legacy body sprite remained visible underneath directional replacement")

	var actor_states_value: Variant = state.get("actor_states", [])
	if actor_states_value is Array and not (actor_states_value as Array).is_empty():
		var actor_state_value: Variant = (actor_states_value as Array)[0]
		if actor_state_value is Dictionary:
			var actor_state := actor_state_value as Dictionary
			_expect(str(actor_state.get("role", "")) == "player", "directional presenter did not resolve player role")
			_expect(str(actor_state.get("direction", "")) == "e", "eastward movement did not quantize to e")
			_expect(str(actor_state.get("state", "")) == "move", "moving player did not resolve move semantic state")
			var checkpoint_source := DirAccess.open("res://Art2D/RigRendered/Akio/CheckpointB/Frames")
			var checkpoint_available := checkpoint_source != null and not checkpoint_source.get_files().is_empty()
			if checkpoint_available:
				_expect(str(actor_state.get("profile_id", "")) == "akio_checkpoint_b", "real Akio Checkpoint B bootstrap profile was not assigned")
				_expect(bool(actor_state.get("asset_ready", false)), "real Akio Checkpoint B bootstrap was not marked usable")
				_expect(not bool(actor_state.get("pixel_art", true)), "real Akio Checkpoint B bootstrap should use clean prerender filtering")
				_expect(not bool(actor_state.get("placeholder_active", true)), "real Akio Checkpoint B bootstrap incorrectly fell back to placeholder")
			else:
				_expect(str(actor_state.get("profile_id", "")) == "akio_rig_rendered_2d", "Akio rig profile was not assigned")
				_expect(not bool(actor_state.get("asset_ready", true)), "Akio profile incorrectly claims production frames already exist")
				_expect(bool(actor_state.get("pixel_art", false)), "Akio rig profile is not configured for nearest-filter pixel proof")
				_expect(bool(actor_state.get("placeholder_active", false)), "placeholder presenter was not active before rig atlas import")
		else:
			_fail("actor state entry was not a Dictionary")
	else:
		_fail("directional presenter diagnostics were empty")

	_test_player_direction_stale_facing(room)
	_finish()


func _test_player_direction_stale_facing(room: Node2D) -> void:
	# The real problem: gameplay movement changes but a previous attack-facing
	# vector remains valid. This must NEVER pin the player's Run direction.
	var actor := MockLiveMovementPlayer.new()
	actor.name = "VisualDirectionTestPlayer"
	room.add_child(actor)
	var visual: Node2D = DIRECTIONAL_PRESENTER_SCRIPT.new()
	room.add_child(visual)
	visual.call("configure", actor, "player", 1.0, 0.72)

	actor._attack_aim_dir = Vector2.RIGHT
	actor._facing_dir = Vector2.RIGHT
	for step: Dictionary in [
		{"input": Vector2.LEFT, "direction": "w"},
		{"input": Vector2.UP, "direction": "n"},
		{"input": Vector2.DOWN, "direction": "s"},
		{"input": Vector2.RIGHT, "direction": "e"},
	]:
		actor._move_input = step["input"]
		visual.call("sync_from_source", 0.016)
		var result: Dictionary = visual.call("get_presentation_state_for_test")
		_expect(str(result.get("state", "")) == "move", "live MOVING state was obscured by stale animation")
		_expect(str(result.get("direction", "")) == str(step["direction"]),
			"player Run direction stuck despite changed input: %s" % str(step["direction"]))

	actor.gameplay_state = "dash"
	actor._dodge_dir = Vector2.UP
	actor._dodge_timer = 0.10
	visual.call("sync_from_source", 0.016)
	var dash_state: Dictionary = visual.call("get_presentation_state_for_test")
	_expect(str(dash_state.get("direction", "")) == "n", "dash should use its own committed heading")

	actor.gameplay_state = "move"
	actor._dodge_timer = 0.0
	actor._move_input = Vector2.LEFT
	visual.call("sync_from_source", 0.016)
	var resumed: Dictionary = visual.call("get_presentation_state_for_test")
	_expect(str(resumed.get("direction", "")) == "w", "dash exit left stale heading in Run animation")
	visual.queue_free()
	actor.queue_free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("[Isometric2DPresentationSmoke] PASS - 2D runtime, wide framing, eight-direction presenter, rig profile slot, and exclusive body replacement are active")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Isometric2DPresentationSmoke] %s" % failure)
	get_tree().quit(1)
