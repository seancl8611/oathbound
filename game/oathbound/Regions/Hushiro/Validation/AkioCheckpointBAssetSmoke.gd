extends Node

const CHECKPOINT_PROFILE = preload("res://Presentation/Profiles/AkioCheckpointBProfile.tres")
const ENEMY_PROXY_PROFILE = preload("res://Presentation/Profiles/AkioEnemyVisualProxyProfile.tres")
const HUSHIRO_PRESENTATION_SCRIPT = preload("res://Regions/Hushiro/Presentation/HushiroIsometric2DPresentation.gd")

var _failures: Array[String] = []

func _ready() -> void:
	var presentation_value: Variant = HUSHIRO_PRESENTATION_SCRIPT.new()
	_expect(presentation_value is Node, "could not instantiate Hushiro presentation")
	if presentation_value is Node:
		var presentation := presentation_value as Node
		# The enemy must have a real moving cycle BEFORE full 816-frame
		# background loading, or it will visibly glide across its first seconds.
		presentation.call("_begin_checkpoint_b_prepare")
		var bootstrap_value: Variant = CHECKPOINT_PROFILE.get("sprite_frames")
		_expect(bootstrap_value is SpriteFrames, "Akio preview atlas missing before streaming")
		if bootstrap_value is SpriteFrames:
			var preview_atlas := bootstrap_value as SpriteFrames
			for dir_name: String in ["e", "se", "s", "sw", "w", "nw", "n", "ne"]:
				var move_name := StringName("move_%s" % dir_name)
				_expect(preview_atlas.has_animation(move_name), "move preview missing %s" % dir_name)
				if preview_atlas.has_animation(move_name):
					_expect(preview_atlas.get_frame_count(move_name) == 6,
						"move preview must animate six real Run poses from first frame")
					_expect(is_equal_approx(preview_atlas.get_animation_speed(move_name), 10.0),
						"move preview must preserve full 18/30 second stride cadence")
		var pending_queue: Array = presentation.get("_checkpoint_b_prepare_queue")
		_expect(not pending_queue.is_empty(), "streaming queue missing")
		if not pending_queue.is_empty():
			_expect(str((pending_queue[0] as Dictionary).get("animation_text", "")).begins_with("move_"),
				"complete Run must stream before Idle/Quick Slash")
		presentation.call("_prepare_checkpoint_b_profile")
		_expect(
			presentation.call("_profile_for_role", "swordsman") == ENEMY_PROXY_PROFILE,
			"debug Swordsman should resolve the temporary Akio enemy visual profile"
		)
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

	# Same images are reused, not copied into another folder or atlas.
	_expect(bool(ENEMY_PROXY_PROFILE.get("asset_ready")), "enemy visual proxy must be ready")
	_expect(ENEMY_PROXY_PROFILE.get("sprite_frames") == CHECKPOINT_PROFILE.get("sprite_frames"),
		"enemy visual proxy must share the exact 816-frame Akio SpriteFrames")
	_expect(ENEMY_PROXY_PROFILE.get("frame_canvas_size") == Vector2i(512, 512),
		"enemy proxy must preserve Akio's 512x512 canvas")
	_expect(is_equal_approx(float(ENEMY_PROXY_PROFILE.get("default_fps")), 30.0),
		"enemy proxy must preserve the 30 FPS source cadence")
	var proxy_names: PackedStringArray = ENEMY_PROXY_PROFILE.call("expected_animation_names")
	_expect(proxy_names.size() == 24, "enemy proxy must use 3 base Actions x 8 directions")
	for enemy_action: String in ["basic_swing", "quick_thrust", "cross_swing", "running_swing",
		"thrust_followup_1", "cross_swing_2"]:
		var candidates: PackedStringArray = ENEMY_PROXY_PROFILE.call(
			"animation_candidates", "attack", enemy_action, "ne"
		)
		_expect(not candidates.is_empty() and candidates[0] == "attack_quick_slash_ne",
			"enemy action %s did not map to Akio Quick Slash" % enemy_action)
	for state_name: String in ["defend", "hurt", "death"]:
		var fallback: PackedStringArray = ENEMY_PROXY_PROFILE.call(
			"animation_candidates", state_name, "", "w"
		)
		_expect(not fallback.is_empty() and fallback[0] == "idle_w",
			"missing %s source Action must temporarily fall back to Idle" % state_name)
	# Hades-style per-enemy weapon presentation uses authored phase data rather
	# than a global elapsed animation clock that can finish before hitbox spawn.
	for dir_name: String in ["e", "se", "s", "sw", "w", "nw", "n", "ne"]:
		var windup_frame: int = int(ENEMY_PROXY_PROFILE.call("visual_frame_for_phase", "STARTUP", 0.5, 44))
		var committed_frame: int = int(ENEMY_PROXY_PROFILE.call("visual_frame_for_phase", "COMMITTED", 0.5, 44))
		var strike_start: int = int(ENEMY_PROXY_PROFILE.call("visual_frame_for_phase", "ACTIVE", 0.0, 44))
		var strike_end: int = int(ENEMY_PROXY_PROFILE.call("visual_frame_for_phase", "ACTIVE", 1.0, 44))
		var recovery_end: int = int(ENEMY_PROXY_PROFILE.call("visual_frame_for_phase", "RECOVERY", 1.0, 44))
		_expect(windup_frame < strike_start and committed_frame <= strike_start,
			"%s: Swordsman windup has no earlier distinct animation pose" % dir_name)
		_expect(strike_end > strike_start, "%s: strike never advances through real Quick Slash poses" % dir_name)
		_expect(recovery_end == 43, "%s: recovery skips last authored source frame" % dir_name)

	var proxy_valid: PackedStringArray = ENEMY_PROXY_PROFILE.call("validate_contract", true)
	_expect(proxy_valid.is_empty(), "enemy proxy source atlas must validate: %s" % " | ".join(proxy_valid))

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
					var expected_count := 40
					if animation_text.begins_with("idle_"):
						expected_count = 40
					elif animation_text.begins_with("move_"):
						expected_count = 18
					elif animation_text.begins_with("attack_quick_slash_"):
						expected_count = 44
					_expect(
						frame_count == expected_count,
						"%s must contain %d frames, got %d" % [animation_text, expected_count, frame_count]
					)
					var should_loop := animation_text.begins_with("idle_") or animation_text.begins_with("move_")
					_expect(
						atlas.get_animation_loop(animation_name) == should_loop,
						"%s loop flag did not match Checkpoint B contract" % animation_text
					)
		_expect(total == 816, "Checkpoint B atlas must contain 816 frames, got %d" % total)

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
