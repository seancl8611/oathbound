extends Node

## Proves that a final Hushiro GLB mirrors authoritative attack progress instead of
## free-running independently from the planar hitbox/damage timeline.

const PRESENTER_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroStandardEnemyActorVisualV2.gd")
const TEST_ACTOR_SCRIPT = preload("res://Regions/Hushiro/Validation/Planar3DExternalAnimationTestActor.gd")
const MODEL_PATH := "user://planar3d_external_animation_sync_model.tscn"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_cleanup()
	_expect(_save_model(), "failed to build production-animation fixture")
	if not _failures.is_empty():
		_cleanup()
		_finish()
		return

	var actor_value: Variant = TEST_ACTOR_SCRIPT.new()
	if not (actor_value is CharacterBody2D):
		_fail("test planar actor failed to instantiate")
		_cleanup()
		_finish()
		return
	var actor := actor_value as CharacterBody2D
	actor.name = "AuthoritativePlanarActor"
	add_child(actor)

	var visual_value: Variant = PRESENTER_SCRIPT.new()
	if not (visual_value is Node3D):
		_fail("V2 production presenter failed to instantiate")
		actor.queue_free()
		_cleanup()
		_finish()
		return
	var visual := visual_value as Node3D
	visual.name = "ProductionVisual"
	visual.call("set_external_model_path", MODEL_PATH)
	visual.call("configure", "hollow", actor)
	add_child(visual)
	await get_tree().process_frame

	_expect(bool(visual.get("_external_model_active")), "generated production fixture did not become the active external model")
	if visual.has_method("get_visual_tier"):
		_expect(str(visual.call("get_visual_tier")) == "role_specific_glb", "generated fixture did not report role-specific GLB tier")

	# Authoritative elapsed/profile path: the imported 2-second Attack should sample to
	# 0.5s at 25% and 1.5s at 75%, then stay paused between authoritative updates.
	actor.set("_attack_profile", {"id": "slash", "duration": 1.0})
	actor.set("_attack_elapsed", 0.25)
	visual.call("sync_from_source", 0.016)
	var state := _animation_state(visual)
	_expect(str(state.get("mode", "")) == "source_progress", "attack did not enter source-progress mode")
	_expect(str(state.get("source", "")) == "attack_elapsed", "attack did not use authoritative elapsed/profile timing")
	_expect(str(state.get("clip", "")) == "Attack", "attack semantic clip was not selected")
	_expect(absf(float(state.get("progress", -1.0)) - 0.25) < 0.01, "25% attack progress was not mirrored")
	_expect(absf(float(state.get("sample_seconds", -1.0)) - 0.50) < 0.02, "25% attack sample did not seek the 2-second clip to 0.5s")
	var imported_player := _first_animation_player(visual)
	if imported_player == null:
		_fail("active production fixture lost its AnimationPlayer")
	else:
		_expect(not imported_player.is_playing(), "source-progress attack clip should be paused after deterministic seek")
		_expect(absf(imported_player.current_animation_position - 0.50) < 0.02, "AnimationPlayer position drifted from 25% authoritative progress")

	actor.set("_attack_elapsed", 0.75)
	visual.call("sync_from_source", 0.016)
	state = _animation_state(visual)
	_expect(absf(float(state.get("progress", -1.0)) - 0.75) < 0.01, "75% attack progress was not mirrored")
	_expect(absf(float(state.get("sample_seconds", -1.0)) - 1.50) < 0.02, "75% attack sample did not seek the 2-second clip to 1.5s")
	if imported_player != null:
		_expect(absf(imported_player.current_animation_position - 1.50) < 0.02, "AnimationPlayer position drifted from 75% authoritative progress")

	# Outside attack authority, locomotion and idle are allowed to play continuously.
	actor.set("_attack_profile", {})
	actor.velocity = Vector2(100.0, 0.0)
	visual.call("sync_from_source", 0.016)
	state = _animation_state(visual)
	_expect(str(state.get("mode", "")) == "clip_playback", "locomotion should use ordinary clip playback")
	_expect(str(state.get("clip", "")) == "Run", "locomotion semantic clip was not selected")
	if imported_player != null:
		_expect(imported_player.is_playing(), "locomotion clip remained paused after attack sampling")

	actor.velocity = Vector2.ZERO
	visual.call("sync_from_source", 0.016)
	state = _animation_state(visual)
	_expect(str(state.get("clip", "")) == "Idle", "idle semantic clip was not restored")

	# Legacy enemies that lack _attack_elapsed can still expose their existing 2D attack
	# timeline through an AnimationPlayer. The production clip mirrors that position rather
	# than inventing an unrelated loop.
	var source_player := AnimationPlayer.new()
	source_player.name = "LegacySourceAnimationPlayer"
	actor.add_child(source_player)
	var source_library := AnimationLibrary.new()
	var source_attack := Animation.new()
	source_attack.length = 1.0
	_expect(source_library.add_animation(&"attack_cue", source_attack) == OK, "failed to add legacy source attack animation")
	_expect(source_player.add_animation_library(&"", source_library) == OK, "failed to add legacy source animation library")
	source_player.play(&"attack_cue")
	source_player.seek(0.40, true)
	visual.call("sync_from_source", 0.016)
	state = _animation_state(visual)
	_expect(str(state.get("mode", "")) == "source_progress", "legacy source AnimationPlayer did not enter source-progress mode")
	_expect(str(state.get("source", "")) == "source_animation", "legacy attack did not report source-animation timing")
	_expect(absf(float(state.get("progress", -1.0)) - 0.40) < 0.01, "legacy source animation progress was not mirrored")
	_expect(absf(float(state.get("sample_seconds", -1.0)) - 0.80) < 0.02, "legacy 40% progress did not seek the 2-second production attack to 0.8s")

	visual.queue_free()
	actor.queue_free()
	await get_tree().process_frame
	_cleanup()
	_finish()


func _save_model() -> bool:
	var root := Node3D.new()
	root.name = "ProductionAnimationFixture"
	var body := MeshInstance3D.new()
	body.name = "Body"
	body.mesh = BoxMesh.new()
	root.add_child(body)
	body.owner = root

	var player := AnimationPlayer.new()
	player.name = "AnimationPlayer"
	root.add_child(player)
	player.owner = root
	var library := AnimationLibrary.new()
	for clip_name: String in ["Idle", "Run", "Attack"]:
		var animation := Animation.new()
		animation.length = 2.0 if clip_name == "Attack" else 1.0
		var pose_track := animation.add_track(Animation.TYPE_POSITION_3D)
		animation.track_set_path(pose_track, NodePath("Body"))
		animation.track_insert_key(pose_track, 0.0, Vector3.ZERO)
		animation.track_insert_key(pose_track, animation.length, Vector3(0.0, 1.0 if clip_name == "Attack" else 0.05, 0.0))
		if library.add_animation(StringName(clip_name), animation) != OK:
			root.free()
			return false
	if player.add_animation_library(&"", library) != OK:
		root.free()
		return false

	var packed := PackedScene.new()
	if packed.pack(root) != OK:
		root.free()
		return false
	var save_error := ResourceSaver.save(packed, MODEL_PATH)
	root.free()
	return save_error == OK


func _animation_state(visual: Node3D) -> Dictionary:
	if not visual.has_method("get_production_animation_state_for_test"):
		_fail("production animation diagnostics method missing")
		return {}
	var state_value: Variant = visual.call("get_production_animation_state_for_test")
	if not (state_value is Dictionary):
		_fail("production animation diagnostics did not return a Dictionary")
		return {}
	return (state_value as Dictionary).duplicate(true)


func _first_animation_player(node: Node) -> AnimationPlayer:
	for child: Node in node.get_children():
		if child is AnimationPlayer:
			return child as AnimationPlayer
		var nested := _first_animation_player(child)
		if nested != null:
			return nested
	return null


func _cleanup() -> void:
	if FileAccess.file_exists(MODEL_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(MODEL_PATH))


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DExternalAnimationSyncSmoke] PASS - production attack clips sample authoritative elapsed or source AnimationPlayer progress while locomotion/idle remain free playback")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DExternalAnimationSyncSmoke] %s" % failure)
	print("[Planar3DExternalAnimationSyncSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
