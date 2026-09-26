extends Node

## Commission-integration contract for Akio Milestone 1 / Proof A.
##
## Proof A intentionally accepts only Idle, Move / Combat Run, and Quick Slash in all
## eight directions. The full production Akio profile remains strict and is not weakened.
## Unfinished attacks may alias to Quick Slash only while this proof profile is selected.

const PROOF_PROFILE = preload("res://Presentation/Profiles/AkioProofAProfile.tres")
const PRODUCTION_PROFILE = preload("res://Presentation/Profiles/AkioRigRendered2DProfile.tres")
const HUSHIRO_PRESENTATION_SCRIPT = preload("res://Regions/Hushiro/Presentation/HushiroIsometric2DPresentation.gd")

var _failures: Array[String] = []


func _ready() -> void:
	_validate_proof_profile()
	_validate_proof_aliases()
	_validate_hushiro_profile_override()
	_finish()


func _validate_proof_profile() -> void:
	_expect(PROOF_PROFILE != null, "Proof A profile failed to preload")
	if PROOF_PROFILE == null:
		return

	var validation_value: Variant = PROOF_PROFILE.call("validate_contract", false)
	if validation_value is PackedStringArray:
		_expect((validation_value as PackedStringArray).is_empty(), "Proof A placeholder profile contract must be valid")
	else:
		_fail("Proof A profile validation returned an invalid type")

	var expected_value: Variant = PROOF_PROFILE.call("expected_animation_names")
	if not (expected_value is PackedStringArray):
		_fail("Proof A expected_animation_names returned an invalid type")
		return
	var expected := expected_value as PackedStringArray
	_expect(expected.size() == 24, "Proof A must require exactly 3 actions x 8 directions = 24 clips")
	_expect(expected.has("idle_s"), "Proof A is missing idle_s")
	_expect(expected.has("move_ne"), "Proof A is missing move_ne")
	_expect(expected.has("attack_quick_slash_w"), "Proof A is missing attack_quick_slash_w")
	_expect(not expected.has("attack_cross_cut_s"), "Proof A must not require Cross Cut")
	_expect(not expected.has("attack_heavy_cleave_s"), "Proof A must not require Heavy Cleave")

	var complete_value: Variant = PROOF_PROFILE.duplicate(true)
	if not (complete_value is Resource):
		_fail("could not duplicate Proof A profile")
		return
	var complete := complete_value as Resource
	complete.set("sprite_frames", _build_complete_test_atlas(complete))
	complete.set("asset_ready", true)
	var complete_validation: Variant = complete.call("validate_contract", true)
	if complete_validation is PackedStringArray:
		var errors := complete_validation as PackedStringArray
		_expect(errors.is_empty(), "complete synthetic Proof A atlas failed: %s" % " | ".join(errors))
	else:
		_fail("complete Proof A profile validation returned an invalid type")


func _validate_proof_aliases() -> void:
	for action_id: String in ["quick_slash", "cross_cut", "heavy_cleave", "hold_thrust", "dash_slash", "counter_cut"]:
		var candidates_value: Variant = PROOF_PROFILE.call("animation_candidates", "attack", action_id, "ne")
		if not (candidates_value is PackedStringArray):
			_fail("animation_candidates returned an invalid type for %s" % action_id)
			continue
		var candidates := candidates_value as PackedStringArray
		_expect(not candidates.is_empty(), "%s returned no Proof A animation candidates" % action_id)
		if not candidates.is_empty():
			_expect(
				candidates[0] == "attack_quick_slash_ne",
				"%s must temporarily resolve to Quick Slash art in Proof A" % action_id
			)

	var dash_candidates_value: Variant = PROOF_PROFILE.call("animation_candidates", "dash", "", "w")
	if dash_candidates_value is PackedStringArray:
		var dash_candidates := dash_candidates_value as PackedStringArray
		_expect(dash_candidates.has("idle_w"), "uncommissioned Proof A states must retain idle fallback")
	else:
		_fail("dash Proof A candidates returned an invalid type")


func _validate_hushiro_profile_override() -> void:
	var presentation_value: Variant = HUSHIRO_PRESENTATION_SCRIPT.new()
	_expect(presentation_value is Node, "could not instantiate Hushiro presentation bridge")
	if not (presentation_value is Node):
		return
	var presentation := presentation_value as Node

	var default_profile: Variant = presentation.call("_profile_for_role", "player")
	_expect(default_profile == PRODUCTION_PROFILE, "Hushiro must default to the full production Akio profile")

	presentation.set("player_profile_override", PROOF_PROFILE)
	var proof_profile: Variant = presentation.call("_profile_for_role", "player")
	_expect(proof_profile == PROOF_PROFILE, "Hushiro player profile override must accept the Proof A profile")

	presentation.free()


func _build_complete_test_atlas(profile: Resource) -> SpriteFrames:
	var frames := SpriteFrames.new()
	if frames.has_animation(&"default"):
		frames.remove_animation(&"default")

	var expected_value: Variant = profile.call("expected_animation_names")
	if not (expected_value is PackedStringArray):
		return frames
	var canvas_value: Variant = profile.get("frame_canvas_size")
	var canvas := canvas_value as Vector2i if canvas_value is Vector2i else Vector2i(128, 128)
	var fps := maxf(1.0, float(profile.get("default_fps")))

	for animation_text: String in expected_value as PackedStringArray:
		var animation_name := StringName(animation_text)
		frames.add_animation(animation_name)
		frames.set_animation_speed(animation_name, fps)
		var animation_base := str(profile.call("animation_base_from_name", animation_text))
		frames.set_animation_loop(animation_name, bool(profile.call("is_looping_animation_base", animation_base)))
		var image := Image.create(canvas.x, canvas.y, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.31, 0.24, 0.20, 1.0))
		frames.add_frame(animation_name, ImageTexture.create_from_image(image))

	return frames


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)


func _finish() -> void:
	if _failures.is_empty():
		print("[AkioProofAReadinessSmoke] PASS - 24-clip Proof A profile, temporary aliases, and Hushiro override are ready")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[AkioProofAReadinessSmoke] %s" % failure)
	print("[AkioProofAReadinessSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)
