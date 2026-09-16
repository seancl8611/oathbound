extends Node

const PROFILE_SCRIPT = preload("res://Presentation/DirectionalSpriteProfile.gd")
const PRESENTER_SCRIPT = preload("res://Utility/DirectionalActorPresentation.gd")
const ACTION_RUNNER_SCRIPT = preload("res://Core/Combat/CombatActionRunner.gd")
const ACTION_DEFINITION_SCRIPT = preload("res://Core/Combat/CombatActionDefinition.gd")
const AKIO_PROFILE = preload("res://Presentation/Profiles/AkioRigRendered2DProfile.tres")
const SWORDSMAN_PROFILE = preload("res://Presentation/Profiles/CorruptedSwordsmanRigRendered2DProfile.tres")

const DIRECTION_VECTORS := {
	"e": Vector2(1.0, 0.0),
	"se": Vector2(1.0, 1.0),
	"s": Vector2(0.0, 1.0),
	"sw": Vector2(-1.0, 1.0),
	"w": Vector2(-1.0, 0.0),
	"nw": Vector2(-1.0, -1.0),
	"n": Vector2(0.0, -1.0),
	"ne": Vector2(1.0, -1.0),
}

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_validate_profile_contracts()
	_validate_alias_contracts()
	await _validate_eight_direction_quantization()
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
			continue

		# Prove the production-ready branch of the contract too, not only the current
		# asset_ready=false placeholders. A complete synthetic atlas must validate exactly
		# as the future rig-rendered atlas will.
		var complete_profile_value: Variant = profile.duplicate(true)
		_expect(complete_profile_value is Resource, "could not duplicate rig-render profile")
		if complete_profile_value is Resource:
			var complete_profile := complete_profile_value as Resource
			complete_profile.set("sprite_frames", _build_complete_test_atlas(complete_profile, 1))
			complete_profile.set("asset_ready", true)
			var complete_validation: Variant = complete_profile.call("validate_contract", true)
			if complete_validation is PackedStringArray:
				var complete_errors: PackedStringArray = complete_validation
				_expect(complete_errors.is_empty(), "complete synthetic atlas failed contract: %s" % " | ".join(complete_errors))
			else:
				_fail("complete profile validation returned invalid type")

	var akio_expected: PackedStringArray = AKIO_PROFILE.call("expected_animation_names")
	_expect(akio_expected.has("attack_quick_slash_ne"), "Akio proof contract is missing attack_quick_slash_ne")
	_expect(akio_expected.has("attack_heavy_cleave_sw"), "Akio proof contract is missing attack_heavy_cleave_sw")
	var soldier_expected: PackedStringArray = SWORDSMAN_PROFILE.call("expected_animation_names")
	_expect(soldier_expected.has("attack_basic_swing_sw"), "Swordsman proof contract is missing attack_basic_swing_sw")
	_expect(soldier_expected.has("attack_quick_thrust_n"), "Swordsman proof contract is missing attack_quick_thrust_n")


func _validate_alias_contracts() -> void:
	var akio_candidates_value: Variant = AKIO_PROFILE.call("animation_candidates", "attack", "hold_thrust", "ne")
	if akio_candidates_value is PackedStringArray:
		var akio_candidates: PackedStringArray = akio_candidates_value
		_expect(not akio_candidates.is_empty(), "Akio hold-thrust alias returned no candidates")
		if not akio_candidates.is_empty():
			_expect(akio_candidates[0] == "attack_quick_slash_ne", "Akio hold-thrust proof alias did not resolve to quick-slash art")
	else:
		_fail("Akio animation_candidates returned invalid type")

	var soldier_candidates_value: Variant = SWORDSMAN_PROFILE.call("animation_candidates", "attack", "thrust_followup_1", "sw")
	if soldier_candidates_value is PackedStringArray:
		var soldier_candidates: PackedStringArray = soldier_candidates_value
		_expect(not soldier_candidates.is_empty(), "Swordsman follow-up alias returned no candidates")
		if not soldier_candidates.is_empty():
			_expect(soldier_candidates[0] == "attack_cross_swing_sw", "Swordsman follow-up proof alias did not resolve to cross-swing art")
	else:
		_fail("Swordsman animation_candidates returned invalid type")


func _validate_eight_direction_quantization() -> void:
	var actor := CharacterBody2D.new()
	actor.name = "Rig2DDirectionActor"
	add_child(actor)

	var presenter_value: Variant = PRESENTER_SCRIPT.new()
	_expect(presenter_value is Node2D, "could not instantiate directional presenter for 8-way validation")
	if not (presenter_value is Node2D):
		actor.queue_free()
		return
	var presenter := presenter_value as Node2D
	presenter.name = "Rig2DDirectionPresenter"
	add_child(presenter)
	presenter.call("configure", actor, "player", 1.0, 0.72)

	for direction_name: String in DIRECTION_VECTORS.keys():
		actor.velocity = (DIRECTION_VECTORS[direction_name] as Vector2).normalized() * 120.0
		presenter.call("sync_from_source", 0.0)
		var state_value: Variant = presenter.call("get_presentation_state_for_test")
		if state_value is Dictionary:
			var state := state_value as Dictionary
			_expect(str(state.get("direction", "")) == direction_name, "direction %s did not quantize correctly" % direction_name)
			_expect(str(state.get("state", "")) == "move", "direction %s did not remain in move semantic state" % direction_name)
		else:
			_fail("8-way presentation state was not a Dictionary")

	presenter.queue_free()
	actor.queue_free()
	await get_tree().process_frame


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

	var profile_value: Variant = AKIO_PROFILE.duplicate(true)
	_expect(profile_value is Resource, "could not duplicate Akio rig-render profile")
	if not (profile_value is Resource):
		actor.queue_free()
		return
	var profile := profile_value as Resource
	profile.set("sprite_frames", _build_complete_test_atlas(profile, 2))
	profile.set("asset_ready", true)
	var profile_validation: Variant = profile.call("validate_contract", true)
	if profile_validation is PackedStringArray:
		_expect((profile_validation as PackedStringArray).is_empty(), "runtime synthetic Akio atlas failed full validation")
	else:
		_fail("runtime synthetic Akio profile validation returned invalid type")

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
		_expect(bool(attack_state.get("asset_ready", false)), "fully validated test atlas was not reported asset-ready")
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


func _build_complete_test_atlas(profile: Resource, frames_per_animation: int) -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation(&"default"):
		frames.remove_animation(&"default")
	var expected_value: Variant = profile.call("expected_animation_names")
	if not (expected_value is PackedStringArray):
		_fail("could not build synthetic atlas: expected_animation_names returned invalid type")
		return frames

	var canvas := Vector2i(128, 128)
	var canvas_value: Variant = profile.get("frame_canvas_size")
	if canvas_value is Vector2i:
		canvas = canvas_value as Vector2i
	var fps := maxf(1.0, float(profile.get("default_fps")))

	for animation_text: String in expected_value as PackedStringArray:
		var animation_name := StringName(animation_text)
		frames.add_animation(animation_name)
		frames.set_animation_speed(animation_name, fps)
		var animation_base := str(profile.call("animation_base_from_name", animation_text))
		frames.set_animation_loop(animation_name, bool(profile.call("is_looping_animation_base", animation_base)))
		for index: int in range(maxi(1, frames_per_animation)):
			var image := Image.create(canvas.x, canvas.y, false, Image.FORMAT_RGBA8)
			image.fill(Color(0.22 + float(index) * 0.12, 0.28, 0.34, 1.0))
			frames.add_frame(animation_name, ImageTexture.create_from_image(image))
	return frames


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("[RigRendered2DPipelineSmoke] PASS - complete 72-animation Akio/Swordsman atlas contracts, 8-way quantization, aliases, and authoritative attack-frame sampling are ready")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[RigRendered2DPipelineSmoke] %s" % failure)
	get_tree().quit(1)
