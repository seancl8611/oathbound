extends Node

## Exercises production-model validation with generated PackedScenes so CI proves both
## sides of the activation gate even before any final Hushiro GLB has landed.

const VALIDATOR = preload("res://Utility/Planar3DProductionModelValidator.gd")

const STATIC_PATH := "user://planar3d_validator_static.tscn"
const DECORATIVE_PATH := "user://planar3d_validator_decorative.tscn"
const ANIMATED_PATH := "user://planar3d_validator_animated.tscn"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_cleanup()
	_expect(_save_model(STATIC_PATH, "none"), "failed to build static validator fixture")
	_expect(_save_model(DECORATIVE_PATH, "decorative"), "failed to build decorative validator fixture")
	_expect(_save_model(ANIMATED_PATH, "pose"), "failed to build animated validator fixture")

	var absent := VALIDATOR.inspect_scene("user://planar3d_validator_absent.tscn")
	_expect(not bool(absent.get("exists", true)), "absent fixture reported as existing")
	_expect(str(absent.get("state", "")) == "absent", "absent fixture state drifted")

	var static_result := VALIDATOR.inspect_scene(STATIC_PATH)
	_expect(bool(static_result.get("exists", false)), "static fixture was not discovered")
	_expect(bool(static_result.get("renderable", false)), "static fixture should be renderable")
	_expect(not bool(static_result.get("animation_contract_ready", true)), "static fixture incorrectly satisfied animation contract")
	_expect(not bool(static_result.get("activation_ready", true)), "static fixture incorrectly became activation-ready")
	_expect(str(static_result.get("state", "")) == "animation_contract_incomplete", "static fixture did not report animation-contract failure")

	# Semantic clip names alone are not enough. Visibility/event/marker tracks can make a
	# PackedScene look animated structurally while leaving its actor frozen in combat.
	var decorative := VALIDATOR.inspect_scene(DECORATIVE_PATH)
	_expect(bool(decorative.get("exists", false)), "decorative fixture was not discovered")
	_expect(bool(decorative.get("renderable", false)), "decorative fixture should be renderable")
	_expect(int(decorative.get("animation_nonempty_clip_count", 0)) == 3, "decorative fixture nonempty clip count drifted")
	_expect(int(decorative.get("animation_pose_clip_count", -1)) == 0, "decorative fixture incorrectly reported pose animation")
	_expect(int(decorative.get("animation_usable_clip_count", -1)) == 0, "decorative fixture incorrectly became adapter-usable")
	_expect(not bool(decorative.get("animation_contract_ready", true)), "decorative fixture incorrectly satisfied animation contract")
	_expect(not bool(decorative.get("activation_ready", true)), "decorative fixture incorrectly became activation-ready")
	_expect(str(decorative.get("state", "")) == "animation_contract_incomplete", "decorative fixture did not report animation-contract failure")

	var animated := VALIDATOR.inspect_scene(ANIMATED_PATH)
	_expect(bool(animated.get("exists", false)), "animated fixture was not discovered")
	_expect(bool(animated.get("renderable", false)), "animated fixture should be renderable")
	_expect(int(animated.get("animation_nonempty_clip_count", 0)) == 3, "animated fixture nonempty clip count drifted")
	_expect(int(animated.get("animation_pose_clip_count", 0)) == 3, "animated fixture pose clip count drifted")
	_expect(int(animated.get("animation_pose_track_count", 0)) == 3, "animated fixture pose track count drifted")
	_expect(int(animated.get("animation_usable_clip_count", 0)) == 3, "animated fixture usable clip count drifted")
	_expect(bool(animated.get("animation_contract_ready", false)), "animated fixture did not satisfy semantic animation contract")
	_expect(bool(animated.get("activation_ready", false)), "animated fixture did not become activation-ready")
	_expect(str(animated.get("state", "")) == "activation_ready", "animated fixture activation state drifted")
	var semantics_value: Variant = animated.get("semantic_animation_clips", {})
	if semantics_value is Dictionary:
		var semantics := semantics_value as Dictionary
		_expect(str(semantics.get("idle", "")) == "Idle", "Idle semantic alias was not resolved")
		_expect(str(semantics.get("locomotion", "")) == "Run", "Run semantic alias was not resolved")
		_expect(str(semantics.get("attack", "")) == "Attack", "Attack semantic alias was not resolved")
	else:
		_fail("animated fixture semantic clip diagnostics missing")

	_cleanup()
	_finish()


func _save_model(path: String, animation_mode: String) -> bool:
	var root := Node3D.new()
	root.name = "ValidatorFixture"
	var body := MeshInstance3D.new()
	body.name = "Body"
	body.mesh = BoxMesh.new()
	root.add_child(body)
	body.owner = root

	if animation_mode != "none":
		var animation_player := AnimationPlayer.new()
		animation_player.name = "AnimationPlayer"
		root.add_child(animation_player)
		animation_player.owner = root
		var library := AnimationLibrary.new()
		for clip_name: String in ["Idle", "Run", "Attack"]:
			var animation := Animation.new()
			animation.length = 0.5
			if animation_mode == "pose":
				var pose_track := animation.add_track(Animation.TYPE_POSITION_3D)
				animation.track_set_path(pose_track, NodePath("Body"))
				animation.track_insert_key(pose_track, 0.0, Vector3.ZERO)
				animation.track_insert_key(pose_track, 0.5, Vector3(0.0, 0.05, 0.0))
			else:
				var decorative_track := animation.add_track(Animation.TYPE_VALUE)
				animation.track_set_path(decorative_track, NodePath("Body:visible"))
				animation.track_insert_key(decorative_track, 0.0, true)
				animation.track_insert_key(decorative_track, 0.5, true)
			if library.add_animation(StringName(clip_name), animation) != OK:
				root.free()
				return false
		if animation_player.add_animation_library(&"", library) != OK:
			root.free()
			return false

	var packed := PackedScene.new()
	if packed.pack(root) != OK:
		root.free()
		return false
	var save_error := ResourceSaver.save(packed, path)
	root.free()
	return save_error == OK


func _cleanup() -> void:
	for path: String in [STATIC_PATH, DECORATIVE_PATH, ANIMATED_PATH]:
		var absolute_path := ProjectSettings.globalize_path(path)
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(absolute_path)


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DProductionModelValidatorSmoke] PASS - renderability, semantic aliases, and real pose animation independently gate final-model activation")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DProductionModelValidatorSmoke] %s" % failure)
	print("[Planar3DProductionModelValidatorSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
