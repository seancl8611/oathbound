extends Node

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation/HushiroIsometric2DPresentation.gd")
const CAMERA_SCRIPT = preload("res://Utility/CameraFollow.gd")

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
	_expect(int(state.get("direction_count", 0)) == 8, "directional actor contract is not eight-way")
	_expect(is_equal_approx(float(state.get("presentation_zoom", 0.0)), 0.50), "unexpected combat framing zoom")
	_expect(is_equal_approx(float(state.get("ground_vertical_compression", 0.0)), 0.72), "unexpected isometric ground compression")
	_expect(int(state.get("presenter_count", 0)) == 1, "player did not receive exactly one directional presenter")
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
			_expect(bool(actor_state.get("placeholder_active", false)), "placeholder presenter was not active without an atlas")
		else:
			_fail("actor state entry was not a Dictionary")
	else:
		_fail("directional presenter diagnostics were empty")

	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("[Isometric2DPresentationSmoke] PASS - 2D runtime, wide framing, eight-direction presenter, and exclusive body replacement are active")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Isometric2DPresentationSmoke] %s" % failure)
	get_tree().quit(1)
