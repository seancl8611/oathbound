extends Node

## Exercises production-model validation with generated PackedScenes so CI proves both
## sides of the activation gate even before any final Hushiro GLB has landed.

const VALIDATOR = preload("res://Utility/Planar3DProductionModelValidator.gd")

const STATIC_PATH := "user://planar3d_validator_static.tscn"
const DECORATIVE_PATH := "user://planar3d_validator_decorative.tscn"
const ANIMATED_PATH := "user://planar3d_validator_animated.tscn"
const SPLIT_PLAYER_PATH := "user://planar3d_validator_split_players.tscn"
const ROOT_MOTION_PATH := "user://planar3d_validator_root_motion.tscn"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_cleanup()
	_expect(_save_model(STATIC_PATH, "none"), "failed to build static validator fixture")
	_expect(_save_model(DECORATIVE_PATH, "decorative"), "failed to build decorative validator fixture")
	_expect(_save_model(ANIMATED_PATH, "pose"), "failed to build animated validator fixture")
	_expect(_save_split_player_model(), "failed to build split-player validator fixture")
	_expect(_save_model(ROOT_MOTION_PATH, "root_motion"), "failed to build root-motion validator fixture")

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

	# The runtime drives one AnimationPlayer. Spreading Idle/Run/Attack across two players
	# must not be accepted merely because the scene-wide union contains all three names.
	var split := VALIDATOR.inspect_scene(SPLIT_PLAYER_PATH)
	_expect(int(split.get("animation_player_count", 0)) == 2, "split fixture did not expose two AnimationPlayers")
	_expect(int(split.get("animation_pose_clip_count", 0)) == 3, "split fixture pose clips were not discovered")
	_expect(int(split.get("animation_contract_player_count", -1)) == 0, "split fixture incorrectly found a complete runtime AnimationPlayer")
	_expect(not bool(split.get("animation_contract_ready", true)), "split-player semantic union incorrectly satisfied animation contract")
	_expect(not bool(split.get("activation_ready", true)), "split-player fixture incorrectly became activation-ready")

	# Scene-root position/rotation/scale animation is presentation root motion. Direct GLB
	# intake must reject it rather than letting the mesh visually drift away from its planar
	# gameplay proxy. A future asset-specific retarget pipeline may choose a different rule.
	var root_motion := VALIDATOR.inspect_scene(ROOT_MOTION_PATH)
	_expect(bool(root_motion.get("renderable", false)), "root-motion fixture should be renderable")
	_expect(int(root_motion.get("animation_root_transform_track_count", 0)) == 3, "root-motion fixture root tracks were not detected")
	_expect(int(root_motion.get("animation_contract_player_count", -1)) == 0, "root-motion player incorrectly satisfied direct-GLB contract")
	_expect(not bool(root_motion.get("animation_contract_ready", true)), "scene-root motion incorrectly satisfied animation contract")
	_expect(not bool(root_motion.get("activation_ready", true)), "scene-root motion fixture incorrectly became activation-ready")

	var animated := VALIDATOR.inspect_scene(ANIMATED_PATH)
	_expect(bool(animated.get("exists", false)), "animated fixture was not discovered")
	_expect(bool(animated.get("renderable", false)), "animated fixture should be renderable")
	_expect(int(animated.get("animation_nonempty_clip_count", 0)) == 3, "animated fixture nonempty clip count drifted")
	_expect(int(animated.get("animation_pose_clip_count", 0)) == 3, "animated fixture pose clip count drifted")
	_expect(int(animated.get("animation_pose_track_count", 0)) == 3, "animated fixture pose track count drifted")
	_expect(int(animated.get("animation_root_transform_track_count", -1)) == 0, "normal animated fixture incorrectly reported root motion")
	_expect(int(animated.get("animation_usable_clip_count", 0)) == 3, "animated fixture usable clip count drifted")
	_expect(int(animated.get("animation_contract_player_count", 0)) == 1, "animated fixture did not identify exactly one contract AnimationPlayer")
	_expect(not str(animated.get("animation_contract_player_path", "")).is_empty(), "animated fixture contract AnimationPlayer path missing")
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
	var root := _base_model_root()
	if animation_mode != "none":
		if not _add_animation_player(root, "AnimationPlayer", ["Idle", "Run", "Attack"], animation_mode):
			root.free()
			return false
	return _pack_and_save(root, path)


func _save_split_player_model() -> bool:
	var root := _base_model_root()
	if not _add_animation_player(root, "LocomotionAnimationPlayer", ["Idle", "Run"], "pose"):
		root.free()
		return false
	if not _add_animation_player(root, "AttackAnimationPlayer", ["Attack"], "pose"):
		root.free()
		return false
	return _pack_and_save(root, SPLIT_PLAYER_PATH)


func _base_model_root() -> Node3D:
	var root := Node3D.new()
	root.name = "ValidatorFixture"
	var body := MeshInstance3D.new()
	body.name = "Body"
	body.mesh = BoxMesh.new()
	root.add_child(body)
	body.owner = root
	return root


func _add_animation_player(root: Node3D, player_name: String, clip_names: Array[String], animation_mode: String) -> bool:
	var animation_player := AnimationPlayer.new()
	animation_player.name = player_name
	root.add_child(animation_player)
	animation_player.owner = root
	var library := AnimationLibrary.new()
	for clip_name: String in clip_names:
		var animation := Animation.new()
		animation.length = 0.5
		match animation_mode:
			"pose":
				var pose_track := animation.add_track(Animation.TYPE_POSITION_3D)
				animation.track_set_path(pose_track, NodePath("Body"))
				animation.track_insert_key(pose_track, 0.0, Vector3.ZERO)
				animation.track_insert_key(pose_track, 0.5, Vector3(0.0, 0.05, 0.0))
			"root_motion":
				var root_track := animation.add_track(Animation.TYPE_POSITION_3D)
				animation.track_set_path(root_track, NodePath("."))
				animation.track_insert_key(root_track, 0.0, Vector3.ZERO)
				animation.track_insert_key(root_track, 0.5, Vector3(0.0, 0.0, 0.75))
			_:
				var decorative_track := animation.add_track(Animation.TYPE_VALUE)
				animation.track_set_path(decorative_track, NodePath("Body:visible"))
				animation.track_insert_key(decorative_track, 0.0, true)
				animation.track_insert_key(decorative_track, 0.5, true)
		if library.add_animation(StringName(clip_name), animation) != OK:
			return false
	return animation_player.add_animation_library(&"", library) == OK


func _pack_and_save(root: Node3D, path: String) -> bool:
	var packed := PackedScene.new()
	if packed.pack(root) != OK:
		root.free()
		return false
	var save_error := ResourceSaver.save(packed, path)
	root.free()
	return save_error == OK


func _cleanup() -> void:
	for path: String in [STATIC_PATH, DECORATIVE_PATH, ANIMATED_PATH, SPLIT_PLAYER_PATH, ROOT_MOTION_PATH]:
		var absolute_path := ProjectSettings.globalize_path(path)
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(absolute_path)


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DProductionModelValidatorSmoke] PASS - renderability, one-player semantic pose contract, and root-motion rejection gate final-model activation")
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
