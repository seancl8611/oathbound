extends Node

## Runtime proof that the Hushiro playtest diagnostics can observe the live bridge without
## owning or mutating presentation/combat state.

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridge.gd")
const DIAGNOSTICS_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/Hushiro3DPlaytestDiagnostics.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var room := Node2D.new()
	room.name = "Planar3DDiagnosticsRoom"

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
	player.name = "DiagnosticsPlayer"
	player.add_to_group("player")
	var legacy_body := Sprite2D.new()
	legacy_body.name = "LegacyPlayerBody"
	player.add_child(legacy_body)
	room.add_child(player)

	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("Hushiro bridge failed to instantiate")
		_finish()
		return
	var bridge := bridge_value as Node
	bridge.name = "Planar3DPresentationBridge"
	room.add_child(bridge)

	var diagnostics_value: Variant = DIAGNOSTICS_SCRIPT.new()
	if not (diagnostics_value is Node):
		_fail("Hushiro 3D diagnostics failed to instantiate")
		_finish()
		return
	var diagnostics := diagnostics_value as Node
	diagnostics.name = "Planar3DPlaytestDiagnostics"
	room.add_child(diagnostics)

	add_child(room)
	for _i: int in range(8):
		await get_tree().process_frame

	var snapshot_value: Variant = diagnostics.call("get_current_snapshot_for_test")
	if not (snapshot_value is Dictionary):
		_fail("diagnostics returned no snapshot dictionary")
	else:
		var snapshot := snapshot_value as Dictionary
		_expect(bool(snapshot.get("active", false)), "diagnostics did not report active live 3D")
		_expect(int(snapshot.get("actor_visual_count", 0)) >= 1, "diagnostics did not observe player presentation actor")
		_expect(int(snapshot.get("player_actor_count", 0)) >= 1, "diagnostics did not identify Akio/player presentation actor")
		_expect(int(snapshot.get("curated_actor_count", 0)) >= 1, "diagnostics did not report curated humanoid tier")
		_expect(int(snapshot.get("animated_curated_actor_count", 0)) >= 1, "diagnostics did not report imported humanoid animation tier")
		_expect(int(snapshot.get("procedural_actor_count", 0)) == 0, "diagnostics reported generic procedural fallback for representative player")
		_expect(int(snapshot.get("viewport_width", 0)) == 640, "diagnostics viewport width drifted from 640")
		_expect(int(snapshot.get("viewport_height", 0)) == 360, "diagnostics viewport height drifted from 360")
		_expect(bool(snapshot.get("camera3d_orthogonal", false)), "diagnostics did not report orthographic Camera3D")
		_expect(bool(snapshot.get("camera3d_current", false)), "diagnostics did not report current Camera3D")
		_expect(bool(snapshot.get("background_hidden", false)), "diagnostics did not observe hidden legacy Background")
		_expect(bool(snapshot.get("scenery_hidden", false)), "diagnostics did not observe hidden legacy Scenery")
		_expect(bool(snapshot.get("combat_fx_visible", false)), "diagnostics did not observe retained planar CombatFX")
		_expect(bool(snapshot.get("environment_has_ground", false)), "diagnostics did not observe Hushiro 3D ground")
		_expect(bool(snapshot.get("environment_has_ruined_torii", false)), "diagnostics did not observe Hushiro torii landmark")
		_expect(not (snapshot.get("player_animation_mode", {}) as Dictionary).is_empty(), "diagnostics omitted player animation mode")

	room.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DDiagnosticsSmoke] PASS - live Hushiro 3D diagnostics expose actor tier, animation, camera, viewport, layering and environment state")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DDiagnosticsSmoke] %s" % failure)
	print("[Planar3DDiagnosticsSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
