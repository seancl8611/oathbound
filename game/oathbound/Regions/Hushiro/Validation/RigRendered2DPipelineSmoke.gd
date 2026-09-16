extends Node

const PROFILE_SCRIPT = preload("res://Presentation/DirectionalSpriteProfile.gd")
const PRESENTER_SCRIPT = preload("res://Utility/DirectionalActorPresentation.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const AKIO_PROFILE = preload("res://Presentation/Profiles/AkioRigRendered2DProfile.tres")
const SWORDSMAN_PROFILE = preload("res://Presentation/Profiles/CorruptedSwordsmanRigRendered2DProfile.tres")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_validate_profile_contracts()
	await _validate_authoritative_attack_sampling()
	_finish()


func _validate_profile_contracts() -> void:
	for profile: Resource in [AKIO_PROFILE, SWORDSMAN_PROFILE]:
		_expect(profile != null, "rig-render profile failed to preload")
		if profile == null:
			continue
		_expect(profile.get_script() == PROFILE_SCRIPT, "profile is not using DirectionalSpriteProfile.gd")
		var validation_value: Variant = profile.call("validate_contract", false)
		if validation_value is PackedStringArray:
			var errors: PackedStringArray = validation_value
			_expect(errors.is_empty(), "placeholder profile contract errors: %s" % " | ".join(errors))
		else:
			_fail("profile validation returned invalid type")

		var expected_value: Variant = profile.call("expected_animation_names")
		if expected_value is PackedStringArray:
			var expected: PackedStringArray = expected_value
			_expect(expected.size() == 72, "%s should define 72 proof animations, got %d" % [str(profile.get("profile_id")), expected.size()])
		else:
			_fail("expected_animation_names returned invalid type")

	var akio_expected: PackedStringArray = AKIO_PROFILE.call("expected_animation_names")
	_expect(akio_expected.has("attack_quick_slash_ne"), "Akio proof contract is missing attack_quick_slash_ne")
	_expect(akio_expected.has("attack_heavy_cleave_sw"), "Akio proof contract is missing attack_heavy_cleave_sw")
	var soldier_expected: PackedStringArray = SWORDSMAN_PROFILE.call("expected_animation_names")
	_expect(soldier_expected.has("attack_basic_swing_sw"), "Swordsman proof contract is missing attack_basic_swing_sw")
	_expect(soldier_expected.has("attack_quick_thrust_n"), "Swordsman proof contract is missing attack_quick_thrust_n")


func _validate_authoritative_attack_sampling() -> void:
	var actor := CharacterBody2D.new()
	actor.name = "Rig2DSmokeActor"
	actor.velocity = Vector2(100.0, 0.0)
	add_child(actor)

	var legacy := Sprite2D.new()
	legacy.name = "Sprite2D"
	actor.add_child(legacy)

	var runner_value: Variant = ACTION_RUNNER_SCRIPT.new()
	_expect(runner_value is CombatActionRunner, "could not instantiate CombatActionRunner")
	if not (runner_value is CombatActionRunner):
		actor.queue_free()
		return
	var runner := runner_value as CombatActionRunner
	runner.name = "CombatActionRunner"
	actor.add_child(runner)
	runner.configure(actor)

	var definition_value: Variant = ACTION_DEFINITION_SCRIPT.new()
	_expect(definition_value is CombatActionDefinition, "could not instantiate CombatActionDefinition")
	if not (definition_value is CombatActionDefinition):
		actor.queue_free()
		return
	var definition := definition_value as CombatActionDefinition
	definition.action_id = &"quick_slash"
	definition.startup_duration = 0.10
	definition.active_duration = 0.10
	definition.recovery_duration = 0.10
	definition.commit_fraction = 0.50
	runner.begin(definition)
	runner.tick(0.18)
	runner.mark_active()

	var frames := SpriteFrames.new()
	if frames.has_animation(&"default"):
		frames.remove_animation(&"default")
	_add_test_animation(frames, &"idle_e", true, 2)
	_add_test_animation(frames, &"move_e", true, 2)
	_add_test_animation(frames, &"attack_quick_slash_e", false, 2)

	var profile_value: Variant = AKIO_PROFILE.duplicate(true)
	_expect(profile_value is Resource, "could not duplicate Akio rig-render profile")
	if not (profile_value is Resource):
		actor.queue_free()
		return
	var profile := profile_value as Resource
	profile.set("sprite_frames", frames)
	profile.set("asset_ready", false)

	var presenter_value: Variant = PRESENTER_SCRIPT.new()
	_expect(presenter_value is Node2D, "could not instantiate DirectionalActorPresentation")
	if not (presenter_value is Node2D):
		actor.queue_free()
		return
	var presenter := presenter_value as Node2D
	presenter.name = "DirectionalPresenter"
	add_child(presenter)
	presenter.call("configure", actor, "player", 1.0, 0.72)
	presenter.call("set_profile", profile)

	await get_tree().process_frame
	var attack_state_value: Variant = presenter.call("get_presentation_state_for_test")
	if attack_state_value is Dictionary:
		var attack_state := attack_state_value as Dictionary
		_expect(str(attack_state.get("state", "")) == "attack", "CombatActionRunner did not drive presenter attack state")
		_expect(str(attack_state.get("direction", "")) == "e", "attack facing did not remain east")
		_expect(str(attack_state.get("action_id", "")) == "quick_slash", "presenter did not expose action-specific id")
		_expect(str(attack_state.get("resolved_animation", "")) == "attack_quick_slash_e", "action-specific animation did not resolve")
		_expect(bool(attack_state.get("authoritative_sampled", false)), "attack frames were not sampled from authoritative action progress")
		_expect(int(attack_state.get("sampled_frame", -1)) == 1, "expected authoritative progress to sample attack frame 1")
		_expect(bool(attack_state.get("atlas_active", false)), "test atlas was not active")
	else:
		_fail("attack presentation state was not a Dictionary")
	_expect(not legacy.visible, "legacy body was visible under rig-render atlas")

	runner.complete()
	await get_tree().process_frame
	var move_state_value: Variant = presenter.call("get_presentation_state_for_test")
	if move_state_value is Dictionary:
		var move_state := move_state_value as Dictionary
		_expect(str(move_state.get("state", "")) == "move", "presenter did not return to locomotion after authoritative action completed")
		_expect(str(move_state.get("resolved_animation", "")) == "move_e", "east locomotion atlas did not resolve")
		_expect(not bool(move_state.get("authoritative_sampled", true)), "locomotion should free-run instead of authoritative attack sampling")
	else:
		_fail("move presentation state was not a Dictionary")

	presenter.queue_free()
	actor.queue_free()


func _add_test_animation(frames: SpriteFrames, animation_name: StringName, looping: bool, frame_count: int) -> void:
	frames.add_animation(animation_name)
	frames.set_animation_speed(animation_name, 12.0)
	frames.set_animation_loop(animation_name, looping)
	for index: int in range(frame_count):
		var image := Image.create(128, 128, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.25 + float(index) * 0.2, 0.25, 0.25, 1.0))
		frames.add_frame(animation_name, ImageTexture.create_from_image(image))


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("[RigRendered2DPipelineSmoke] PASS - Akio/Swordsman 8-direction profiles and authoritative attack-frame sampling are ready")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[RigRendered2DPipelineSmoke] %s" % failure)
	get_tree().quit(1)
