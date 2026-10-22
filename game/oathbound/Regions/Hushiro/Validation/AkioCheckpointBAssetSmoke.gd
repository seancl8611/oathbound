extends Node

const CHECKPOINT_PROFILE = preload("res://Presentation/Profiles/AkioCheckpointBProfile.tres")
const HUSHIRO_PRESENTATION_SCRIPT = preload("res://Regions/Hushiro/Presentation/HushiroIsometric2DPresentation.gd")

var _failures: Array[String] = []

func _ready() -> void:
	var presentation_value: Variant = HUSHIRO_PRESENTATION_SCRIPT.new()
	_expect(presentation_value is Node, "could not instantiate Hushiro presentation")
	if presentation_value is Node:
		var presentation := presentation_value as Node
		presentation.call("_prepare_checkpoint_b_profile")
		_expect(
			presentation.call("_profile_for_role", "player") == CHECKPOINT_PROFILE,
			"Hushiro must resolve the real Checkpoint B Akio profile without a prebuilt atlas"
		)
		presentation.free()

	_expect(bool(CHECKPOINT_PROFILE.get("asset_ready")), "Checkpoint B profile was not prepared")
	_expect(CHECKPOINT_PROFILE.get("frame_canvas_size") == Vector2i(512, 512), "Checkpoint B canvas must be 512x512")
	_expect(CHECKPOINT_PROFILE.get("foot_anchor_px") == Vector2(256, 256), "Checkpoint B anchor must remain at render center")
	_expect(is_equal_approx(float(CHECKPOINT_PROFILE.get("visual_scale_multiplier")), 0.5), "Checkpoint B visual scale must start at 0.50")
	_expect(is_equal_approx(float(CHECKPOINT_PROFILE.get("default_fps")), 30.0), "Checkpoint B loops must preserve 30 fps")
	_expect(not bool(CHECKPOINT_PROFILE.get("pixel_art")), "Checkpoint B must use clean linear prerender filtering")

	var atlas_value: Variant = CHECKPOINT_PROFILE.get("sprite_frames")
	_expect(atlas_value is SpriteFrames, "Checkpoint B SpriteFrames are missing")
	if atlas_value is SpriteFrames:
		var atlas := atlas_value as SpriteFrames
		var total := 0
		var expected_value: Variant = CHECKPOINT_PROFILE.call("expected_animation_names")
		if expected_value is PackedStringArray:
			for animation_text: String in expected_value as PackedStringArray:
				var animation_name := StringName(animation_text)
				_expect(atlas.has_animation(animation_name), "missing animation %s" % animation_text)
				if atlas.has_animation(animation_name):
					var frame_count := atlas.get_frame_count(animation_name)
					total += frame_count
					var expected_count := 41
					if animation_text.begins_with("idle_"):
						expected_count = 40
					elif animation_text.begins_with("move_"):
						expected_count = 16
					_expect(
						frame_count == expected_count,
						"%s must contain %d frames, got %d" % [animation_text, expected_count, frame_count]
					)
					var should_loop := animation_text.begins_with("idle_") or animation_text.begins_with("move_")
					_expect(
						atlas.get_animation_loop(animation_name) == should_loop,
						"%s loop flag did not match Checkpoint B contract" % animation_text
					)
		_expect(total == 776, "Checkpoint B atlas must contain 776 frames, got %d" % total)

	if _failures.is_empty():
		print("[AkioCheckpointBAssetSmoke] PASS - real Akio Checkpoint B art is ready for Hushiro playtest")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[AkioCheckpointBAssetSmoke] %s" % failure)
	get_tree().quit(1)

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
