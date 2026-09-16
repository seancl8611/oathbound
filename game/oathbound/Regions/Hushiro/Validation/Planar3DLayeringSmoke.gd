extends Node

## Regression proof for the representative Hushiro live-3D presentation contract.
##
## This smoke intentionally exercises Akio, Swordsman and Blighted Hound together while
## keeping their authoritative simulation as CharacterBody2D. It protects exclusive 3D
## actor replacement, imported human animation, source-driven dash/katana presentation,
## contact shadows, attack presentation VFX, legacy ground telegraphs, fixed Camera3D
## framing, target viewport sizing, bridge disable/re-enable restoration, and the Rupture
## room/lighting language without changing any combat semantics.

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
	var player_legacy_body := Sprite2D.new()
	player_legacy_body.name = "LegacyPlayerBody"
	player_legacy_body.visible = true
	player.add_child(player_legacy_body)
	room.add_child(player)

	var swordsman := CharacterBody2D.new()
	swordsman.name = "LayeringSmokeSwordsman"
	swordsman.position = Vector2(-96.0, -44.0)
	swordsman.set_meta("hushiro_enemy_type", "swordsman")
	swordsman.add_to_group("enemy")
	var swordsman_legacy_body := AnimatedSprite2D.new()
	swordsman_legacy_body.name = "LegacySwordsmanBody"
	swordsman_legacy_body.visible = true
	swordsman.add_child(swordsman_legacy_body)
	room.add_child(swordsman)

	var hound := CharacterBody2D.new()
	hound.name = "LayeringSmokeBlightedHound"
	hound.position = Vector2(128.0, -64.0)
	hound.set_meta("hushiro_enemy_type", "hound")
	hound.add_to_group("enemy")
	var hound_legacy_body := Polygon2D.new()
	hound_legacy_body.name = "LegacyHoundBody"
	hound_legacy_body.visible = true
	hound.add_child(hound_legacy_body)
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
	for _i: int in range(6):
		await get_tree().process_frame

	_expect(bool(bridge.call("is_presentation_enabled")), "live 3D bridge did not activate")
	_expect(not background.visible, "legacy Background remained visible above live 3D")
	_expect(not scenery.visible, "legacy Scenery remained visible above live 3D")
	_expect(combat_fx.visible, "planar CombatFX was incorrectly hidden with legacy scenery")
	_expect(not player_legacy_body.visible, "legacy player body remained visible beside replacement 3D Akio")
	_expect(not swordsman_legacy_body.visible, "legacy Swordsman body remained visible beside replacement 3D actor")
	_expect(not hound_legacy_body.visible, "legacy Hound body remained visible beside replacement 3D actor")

	# Reproduce the initialization/order failure directly. Compatibility presentation code
	# may set room art visible after the bridge's first hide pass. The Hushiro wrapper must
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

		_expect(int(state.get("actor_visual_count", 0)) >= 3, "representative Akio + Swordsman + Hound 3D actors were not created")
		_expect(int(state.get("player_actor_count", 0)) >= 1, "Akio replacement visual missing")
		_expect(int(state.get("swordsman_actor_count", 0)) >= 1, "Swordsman replacement visual missing")
		_expect(int(state.get("curated_actor_count", 0)) >= 2, "Akio or Swordsman silently fell back instead of using verified curated humanoids")
		_expect(int(state.get("animated_curated_actor_count", 0)) >= 2, "Akio or Swordsman did not activate the imported runtime AnimationLibrary")
		_expect(int(state.get("hound_actor_count", 0)) >= 1, "Blighted Hound silently fell back instead of using the authored Hushiro silhouette")
		_expect(int(state.get("procedural_actor_count", 0)) == 0, "representative vertical-slice actors still use generic procedural fallback geometry")
		_expect(int(state.get("contact_shadow_count", 0)) >= 3, "3D contact-shadow contract missing from representative actors")
		_expect(int(state.get("attack_vfx_count", 0)) >= 2, "Akio/Swordsman combat-synced 3D attack VFX contract missing")
		_expect(float(state.get("min_actor_y", 0.0)) >= 0.09, "3D actor root still intersects the temporary floor plane")

		var animation_states_value: Variant = state.get("curated_animation_states_by_role", {})
		if animation_states_value is Dictionary:
			var animation_states := animation_states_value as Dictionary
			_validate_curated_animation_role(animation_states, "player", "Akio")
			_validate_curated_animation_role(animation_states, "swordsman", "Swordsman")
		else:
			_fail("per-role curated animation introspection unavailable")

		var compression := float(state.get("illustrated_ground_compression", 1.0))
		var elevation := float(state.get("illustrated_camera_elevation_degrees", 90.0))
		var zoom := float(state.get("illustrated_presentation_zoom", 1.0))
		_expect(compression >= 0.58 and compression <= 0.66, "Hushiro projection drifted away from illustrated three-quarter target")
		_expect(elevation >= 35.0 and elevation <= 42.0, "Hushiro Camera3D elevation drifted too top-down or too low")
		_expect(zoom >= 0.68 and zoom <= 0.78, "Hushiro framing drifted away from pulled-back target")
		_expect(bool(state.get("camera3d_orthogonal", false)), "Hushiro Camera3D is no longer fixed orthographic presentation")
		_expect(bool(state.get("camera3d_current", false)), "Hushiro Camera3D is not the active SubViewport camera")

		var viewport_size_value: Variant = state.get("viewport_size", Vector2i.ZERO)
		var viewport_size := viewport_size_value as Vector2i if viewport_size_value is Vector2i else Vector2i.ZERO
		_expect(viewport_size == Vector2i(640, 360), "live 3D SubViewport drifted from 640x360 internal target (got %s)" % str(viewport_size))
		_expect(int(ProjectSettings.get_setting("display/window/size/viewport_width", 0)) == 640, "project viewport width is no longer 640")
		_expect(int(ProjectSettings.get_setting("display/window/size/viewport_height", 0)) == 360, "project viewport height is no longer 360")
		_expect(int(ProjectSettings.get_setting("display/window/size/window_width_override", 0)) == 1280, "window presentation width is no longer 1280")
		_expect(int(ProjectSettings.get_setting("display/window/size/window_height_override", 0)) == 720, "window presentation height is no longer 720")
		_expect(int(state.get("presentation_canvas_layer", 0)) < 0, "3D presentation layer no longer sits behind HUD/reward CanvasLayers")
		_expect(bool(state.get("texture_mouse_passthrough", false)), "3D presentation texture unexpectedly captures UI input")

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

	# Exercise the actual Hushiro bridge lifecycle rather than only the failure-injection
	# bridge. Disabling live 3D must restore every compatibility body/room item, and a later
	# re-enable must rebuild the representative 3D set without losing planar CombatFX.
	bridge.call("set_presentation_enabled", false)
	for _i: int in range(3):
		await get_tree().process_frame
	_expect(not bool(bridge.call("is_presentation_enabled")), "Hushiro live 3D bridge did not deactivate")
	_expect(background.visible, "legacy Background was not restored when Hushiro live 3D disabled")
	_expect(scenery.visible, "legacy Scenery was not restored when Hushiro live 3D disabled")
	_expect(combat_fx.visible, "CombatFX visibility changed when Hushiro live 3D disabled")
	_expect(player_legacy_body.visible, "legacy player body was not restored when Hushiro live 3D disabled")
	_expect(swordsman_legacy_body.visible, "legacy Swordsman body was not restored when Hushiro live 3D disabled")
	_expect(hound_legacy_body.visible, "legacy Hound body was not restored when Hushiro live 3D disabled")

	bridge.call("set_presentation_enabled", true)
	for _i: int in range(6):
		await get_tree().process_frame
	_expect(bool(bridge.call("is_presentation_enabled")), "Hushiro live 3D bridge did not reactivate")
	_expect(not background.visible, "legacy Background was not suppressed after Hushiro live 3D re-enable")
	_expect(not scenery.visible, "legacy Scenery was not suppressed after Hushiro live 3D re-enable")
	_expect(combat_fx.visible, "CombatFX visibility was lost after Hushiro live 3D re-enable")
	_expect(not player_legacy_body.visible, "legacy player body was not re-suppressed after live 3D re-enable")
	_expect(not swordsman_legacy_body.visible, "legacy Swordsman body was not re-suppressed after live 3D re-enable")
	_expect(not hound_legacy_body.visible, "legacy Hound body was not re-suppressed after live 3D re-enable")
	var reenabled_state_value: Variant = bridge.call("get_layering_state_for_test")
	if reenabled_state_value is Dictionary:
		var reenabled_state := reenabled_state_value as Dictionary
		_expect(int(reenabled_state.get("actor_visual_count", 0)) >= 3, "Hushiro re-enable did not rebuild Akio + Swordsman + Hound presentation actors")
		_expect(int(reenabled_state.get("animated_curated_actor_count", 0)) >= 2, "Hushiro re-enable did not restore curated humanoid animation")
		_expect(int(reenabled_state.get("hound_actor_count", 0)) >= 1, "Hushiro re-enable did not restore authored Hound presentation")
	else:
		_fail("Hushiro layering introspection unavailable after re-enable")

	room.queue_free()
	await get_tree().process_frame
	_finish()


func _validate_curated_animation_role(animation_states: Dictionary, role: String, label: String) -> void:
	if not animation_states.has(role):
		_fail("%s curated animation state missing" % label)
		return
	var animation_value: Variant = animation_states.get(role)
	if not (animation_value is Dictionary):
		_fail("%s curated animation state is invalid" % label)
		return
	var animation_state := animation_value as Dictionary
	_expect(bool(animation_state.get("active", false)), "%s curated animation library is inactive" % label)
	_expect(int(animation_state.get("clip_count", 0)) >= 5, "%s runtime library retained fewer than five usable clips" % label)
	_expect(int(animation_state.get("remapped_tracks", 0)) > 0, "%s animation library remapped zero skeleton tracks" % label)
	_expect(not str(animation_state.get("idle_clip", "")).is_empty(), "%s animation library selected no idle clip" % label)
	_expect(not str(animation_state.get("locomotion_clip", "")).is_empty(), "%s animation library selected no locomotion clip" % label)
	var dash_mode := str(animation_state.get("dash_mode", ""))
	var attack_mode := str(animation_state.get("attack_mode", ""))
	_expect(dash_mode in ["authored_clip", "locomotion_lean_fallback"], "%s dash has no deterministic presentation mode" % label)
	_expect(attack_mode in ["authored_source_progress", "manual_source_progress"], "%s attack has no source-progress presentation mode" % label)


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DLayeringSmoke] PASS - Akio + Swordsman per-role animation | Hound | lifecycle restore/rebuild | 3D VFX | Rupture room | fixed 640x360 Camera3D")
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
