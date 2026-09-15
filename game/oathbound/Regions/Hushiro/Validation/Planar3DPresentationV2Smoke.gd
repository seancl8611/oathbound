extends Node

## Acceptance regression for the second-pass Hushiro presentation prompted by the first
## real screenshot/playtest. Unlike the original representative smoke, this covers every
## standard Hushiro role so Hollow/Archer/Bilemass/Warden can never silently collapse back
## into the shared anonymous capsule fallback.

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridgeV2.gd")
const STANDARD_ROLES: Array[String] = ["hollow", "archer", "bilemass", "warden"]

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var room := Node2D.new()
	room.name = "HushiroPresentationV2SmokeRoom"

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

	var legacy_bodies: Array[CanvasItem] = []
	var player := _make_actor(room, "V2SmokePlayer", "player", Vector2(0.0, 70.0), legacy_bodies)
	var swordsman := _make_actor(room, "V2SmokeSwordsman", "swordsman", Vector2(-120.0, -70.0), legacy_bodies)
	var hound := _make_actor(room, "V2SmokeHound", "hound", Vector2(140.0, -35.0), legacy_bodies)
	var hollow := _make_actor(room, "V2SmokeHollow", "hollow", Vector2(-175.0, 35.0), legacy_bodies)
	var archer := _make_actor(room, "V2SmokeArcher", "archer", Vector2(190.0, -120.0), legacy_bodies)
	var bilemass := _make_actor(room, "V2SmokeBilemass", "bilemass", Vector2(195.0, 110.0), legacy_bodies)
	var warden := _make_actor(room, "V2SmokeWarden", "warden", Vector2(-210.0, 115.0), legacy_bodies)
	# Keep strong references so the typed locals cannot be optimized away while the room
	# is being assembled and to make the seven-role intent explicit to readers.
	var representative_actors: Array[CharacterBody2D] = [player, swordsman, hound, hollow, archer, bilemass, warden]
	_expect(representative_actors.size() == 7, "representative Hushiro role set is incomplete")

	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("Hushiro V2 bridge failed to instantiate")
		_finish()
		return
	var bridge := bridge_value as Node
	bridge.name = "Planar3DPresentationBridge"
	room.add_child(bridge)
	add_child(room)

	for _i: int in range(10):
		await get_tree().process_frame

	_expect(bool(bridge.call("is_presentation_enabled")), "V2 live 3D bridge did not activate")
	_expect(not background.visible, "V2 live 3D left legacy Background visible")
	_expect(not scenery.visible, "V2 live 3D left legacy Scenery visible")
	_expect(combat_fx.visible, "V2 live 3D hid planar CombatFX")
	for body: CanvasItem in legacy_bodies:
		_expect(not body.visible, "legacy actor body remained visible beside a V2 replacement")

	# Engineering migration badge must not ship into the manual acceptance view.
	_expect(bridge.get_node_or_null("Planar3DCanvas/Planar3DStatus") == null, "V2 playtest still shows the migration debug badge")

	var state_value: Variant = bridge.call("get_presentation_state")
	if not (state_value is Dictionary):
		_fail("V2 bridge presentation state unavailable")
		room.queue_free()
		await get_tree().process_frame
		_finish()
		return
	var state := state_value as Dictionary

	_expect(int(state.get("presentation_revision", 0)) == 2, "V2 presentation revision marker missing")
	_expect(int(state.get("actor_visual_count", 0)) >= 7, "V2 did not build all seven representative actors")
	_expect(int(state.get("curated_actor_count", 0)) >= 2, "V2 Akio/Swordsman curated humans missing")
	_expect(int(state.get("animated_curated_actor_count", 0)) >= 2, "V2 human authored animation library inactive")
	_expect(int(state.get("hound_actor_count", 0)) >= 1, "V2 authored Hound presentation missing")
	_expect(int(state.get("hushiro_standard_actor_count", 0)) >= 4, "V2 Hollow/Archer/Bilemass/Warden authored silhouettes incomplete")
	_expect(int(state.get("unknown_hushiro_actor_count", 0)) == 0, "V2 representative roster contains an unknown Hushiro role")
	_expect(int(state.get("procedural_actor_count", 0)) == 0, "V2 still contains anonymous shared procedural enemy fallback")

	var role_counts_value: Variant = state.get("actor_role_counts", {})
	if role_counts_value is Dictionary:
		var role_counts := role_counts_value as Dictionary
		for role: String in ["player", "swordsman", "hound", "hollow", "archer", "bilemass", "warden"]:
			_expect(int(role_counts.get(role, 0)) >= 1, "V2 role missing from presentation: %s" % role)
	else:
		_fail("V2 actor-role diagnostics unavailable")

	# Camera must be materially flatter/wider than the rejected 38.3deg / 0.72 pass.
	var compression := float(state.get("illustrated_ground_compression", 1.0))
	var elevation := float(state.get("illustrated_camera_elevation_degrees", 90.0))
	var zoom := float(state.get("illustrated_presentation_zoom", 1.0))
	_expect(compression >= 0.46 and compression <= 0.50, "V2 ground compression drifted from the ~0.48 target")
	_expect(elevation >= 27.0 and elevation <= 30.5, "V2 camera no longer reads as the flatter ~29 degree target")
	_expect(zoom >= 0.50 and zoom <= 0.54, "V2 camera no longer uses the pulled-back ~0.52 framing")
	_expect(bool(state.get("camera3d_orthogonal", false)), "V2 Camera3D is not orthographic")
	_expect(bool(state.get("camera3d_current", false)), "V2 Camera3D is not active")

	# Quaternius local-forward correction is explicit and isolated to the imported human
	# tier; shared facing math remains unchanged for Hound and the authored standard roles.
	var animation_states_value: Variant = state.get("curated_animation_states_by_role", {})
	if animation_states_value is Dictionary:
		var animation_states := animation_states_value as Dictionary
		for role: String in ["player", "swordsman"]:
			var role_state_value: Variant = animation_states.get(role, {})
			if role_state_value is Dictionary:
				var role_state := role_state_value as Dictionary
				_expect(absf(float(role_state.get("forward_correction_degrees", 0.0)) - 180.0) < 0.1, "%s imported mesh forward correction missing" % role)
			else:
				_fail("%s curated animation state missing" % role)
	else:
		_fail("V2 curated animation states unavailable")

	var environment_value: Variant = state.get("environment_state", {})
	if environment_value is Dictionary:
		var environment_state := environment_value as Dictionary
		_expect(int(environment_state.get("composition_revision", 0)) == 2, "V2 environment composition revision missing")
		_expect(bool(environment_state.get("quiet_center", false)), "V2 environment no longer guarantees a quiet combat center")
		_expect(bool(environment_state.get("has_ground", false)), "V2 courtyard ground missing")
		_expect(bool(environment_state.get("has_ruined_torii", false)), "V2 torii landmark missing")
		_expect(bool(environment_state.get("has_shrine_landmark", false)), "V2 shrine landmark missing")
		_expect(bool(environment_state.get("has_moon_key", false)), "V2 moon key missing")
		_expect(int(environment_state.get("foreground_occluder_count", 0)) == 2, "V2 foreground depth anchors changed unexpectedly")
		_expect(int(environment_state.get("landmark_count", 0)) >= 3, "V2 environment lost major framing landmarks")
	else:
		_fail("V2 environment diagnostics unavailable")

	room.queue_free()
	await get_tree().process_frame
	_finish()


func _make_actor(room: Node2D, actor_name: String, role: String, position_value: Vector2, legacy_bodies: Array[CanvasItem]) -> CharacterBody2D:
	var actor := CharacterBody2D.new()
	actor.name = actor_name
	actor.position = position_value
	if role == "player":
		actor.add_to_group("player")
	else:
		actor.add_to_group("enemy")
		actor.set_meta("presentation_role", role)
		actor.set_meta("hushiro_enemy_type", role)
	var body := Sprite2D.new()
	body.name = "LegacyBody"
	body.visible = true
	actor.add_child(body)
	legacy_bodies.append(body)
	room.add_child(actor)
	return actor


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DPresentationV2Smoke] PASS - wider/flatter camera | corrected human forward | all Hushiro standard roles authored | quiet-center courtyard | no debug badge")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DPresentationV2Smoke] %s" % failure)
	print("[Planar3DPresentationV2Smoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
