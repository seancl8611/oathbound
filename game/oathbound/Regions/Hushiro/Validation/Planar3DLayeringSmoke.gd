extends Node

## Regression proof for the live-3D real-player presentation contract: opaque legacy 2D
## room art must not cover the SubViewport, planar CombatFX must remain visible, mirrored
## actors must sit above temporary floor geometry, the verified curated humanoid tier and
## authored Hound silhouette must replace generic blockouts, and Hushiro must retain the
## flatter illustrated camera plus Rupture-specific room/lighting language.

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

	# Explicitly include a Hound so the representative Hushiro vertical-slice actor set is
	# protected by automation rather than relying on whichever encounter happens to spawn.
	var hound := CharacterBody2D.new()
	hound.name = "LayeringSmokeBlightedHound"
	hound.position = Vector2(128.0, -64.0)
	hound.set_meta("hushiro_enemy_type", "hound")
	hound.add_to_group("enemy")
	room.add_child(hound)

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
		_expect(int(state.get("actor_visual_count", 0)) >= 2, "representative player + Hound 3D actors were not created")
		_expect(int(state.get("curated_actor_count", 0)) >= 1, "Hushiro player silently fell back instead of using the verified curated humanoid")
		_expect(int(state.get("hound_actor_count", 0)) >= 1, "Blighted Hound silently fell back instead of using the authored Hushiro silhouette")
		_expect(float(state.get("min_actor_y", 0.0)) >= 0.09, "3D actor root still intersects the temporary floor plane")

		var compression := float(state.get("illustrated_ground_compression", 1.0))
		var elevation := float(state.get("illustrated_camera_elevation_degrees", 90.0))
		var zoom := float(state.get("illustrated_presentation_zoom", 1.0))
		_expect(compression >= 0.58 and compression <= 0.66, "Hushiro projection drifted away from illustrated three-quarter target")
		_expect(elevation >= 35.0 and elevation <= 42.0, "Hushiro Camera3D elevation drifted too top-down or too low")
		_expect(zoom >= 0.68 and zoom <= 0.78, "Hushiro framing drifted away from pulled-back target")

		var environment_value: Variant = state.get("environment_state", {})
		if environment_value is Dictionary:
			var environment_state := environment_value as Dictionary
			_expect(bool(environment_state.get("has_ground", false)), "Hushiro 3D ground volume missing")
			_expect(bool(environment_state.get("has_ruined_torii", false)), "Hushiro ruined torii landmark missing")
			_expect(bool(environment_state.get("has_shrine_landmark", false)), "Hushiro shrine-remnant landmark missing")
			_expect(bool(environment_state.get("has_moon_key", false)), "Hushiro moon key light missing")
			_expect(int(environment_state.get("ritual_accent_count", 0)) >= 4, "Hushiro ritual accent language regressed")
			_expect(int(environment_state.get("warm_light_count", 0)) >= 3, "Hushiro warm/cold lighting contrast regressed")
			_expect(int(environment_state.get("foreground_occluder_count", 0)) >= 2, "Hushiro controlled foreground depth regressed")
			_expect(int(environment_state.get("landmark_count", 0)) >= 3, "Hushiro authored landmark silhouette count regressed")
		else:
			_fail("Hushiro environment introspection unavailable")
	else:
		_fail("bridge layering introspection unavailable")

	room.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DLayeringSmoke] PASS - layering + curated humanoid + authored Hound + Rupture room + illustrated camera")
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
