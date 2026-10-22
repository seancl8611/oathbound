extends Node

const PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const SOURCE_PROFILE = preload("res://Presentation/Profiles/AkioCheckpointBProfile.tres")
const TIMING = preload("res://Core/Combat/AkioCheckpointBTiming.gd")
const NORMAL := "normal"
const QUICK := "akio_checkpoint_b_quick_slash"
const PROTOTYPE := "prototype"
const HAMMER := "hammer_source_30fps"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	if not OS.is_debug_build():
		_failures.append("focused test harness must be exercised in a debug build")
		_finish()
		return

	_expect(PlaytestLab.has_method("set_focused_test_scenario"), "PlaytestLab focused scenario setter is missing")
	_expect(PlaytestLab.has_method("set_akio_quick_slash_timing_mode"), "PlaytestLab timing setter is missing")
	_expect(PlaytestLab.has_method("set_akio_render_test_preset"), "PlaytestLab visual A/B setter is missing")
	_expect(PlaytestLab.has_method("get_akio_mipmapped_run_frames"), "Run mipmap generator missing")
	_expect(PlaytestLab.has_method("set_akio_run_sync_test_mode"), "Run sync mode setter missing")
	_expect(PlaytestLab.get_akio_run_sync_test_mode() == "baseline", "Run sync baseline must be default")
	_expect(PlaytestLab.has_method("arm_akio_run_trace"), "Run frame/camera trace arming control missing")
	_expect(PlaytestLab.has_method("is_akio_run_trace_active"), "Run frame/camera trace status control missing")
	_expect(PlaytestLab.has_method("export_akio_run_contact_sheets"), "Run indexed contact-sheet generator missing")
	_expect(not PlaytestLab.is_akio_run_trace_active(), "Run frame diagnostics should be disabled by default")
	_expect(PlaytestLab.get_akio_render_test_preset() == "baseline", "Akio render comparison must default to the unmodified baseline")
	_expect(PlaytestLab.get_focused_test_scenario() == NORMAL, "normal combat must be the default")
	_expect(is_equal_approx(float(SOURCE_PROFILE.get("default_fps")), 30.0), "Hammer FPS contract changed")
	_expect(TIMING.SOURCE_FRAME_COUNT == 41, "Hammer Quick Slash must contain 41 frames")
	_expect(is_equal_approx(TIMING.SOURCE_TOTAL_DURATION, 41.0 / 30.0), "Hammer source duration mismatch")
	_expect(TIMING.STARTUP_FRAMES + TIMING.ACTIVE_FRAMES + TIMING.RECOVERY_FRAMES == 41, "source phase counts do not total 41")

	var old_aspect: String = str(AspectRuntime.selected_aspect)
	var old_tier: int = int(AspectRuntime.tier)
	AspectRuntime.selected_aspect = ""
	AspectRuntime.tier = 0

	var player: Node = PLAYER_SCENE.instantiate()
	add_child(player)
	await get_tree().process_frame
	player.set_physics_process(false)

	# Debug-only live sprite A/B. Same actor, same animation/profile and
	# world position: only sprite sampling, snap and display size may differ.
	var comparison_profile: Resource = SOURCE_PROFILE.duplicate(true)
	comparison_profile.set("sprite_frames", SpriteFrames.new())
	var presenter: Node2D = load("res://Utility/DirectionalActorPresentation.gd").new()
	add_child(presenter)
	presenter.call("configure", player, "player", 1.0, 0.72)
	presenter.call("set_profile", comparison_profile)
	player.global_position = Vector2(10.4, 17.6)
	presenter.call("sync_from_source", 0.0)
	var visual_state: Dictionary = presenter.call("get_presentation_state_for_test")
	_expect(str(visual_state.get("render_test_preset", "")) == "baseline", "visual baseline not applied")
	_expect(int(visual_state.get("render_filter", -1)) == CanvasItem.TEXTURE_FILTER_LINEAR, "baseline lost original linear sampling")
	_expect(is_equal_approx(float(visual_state.get("visual_scale", -1.0)), 0.5), "baseline changed Akio scale")
	_expect(presenter.global_position.distance_to(player.global_position) < 0.01, "baseline unexpectedly snaps world position")

	PlaytestLab.set_akio_render_test_preset("nearest")
	presenter.call("sync_from_source", 0.0)
	visual_state = presenter.call("get_presentation_state_for_test")
	_expect(int(visual_state.get("render_filter", -1)) == CanvasItem.TEXTURE_FILTER_NEAREST, "nearest preset did not reach live Sprite2D")
	_expect(is_equal_approx(float(visual_state.get("visual_scale", -1.0)), 0.5), "nearest filter altered actor scale")
	_expect(presenter.global_position.distance_to(player.global_position) < 0.01, "nearest preset unexpectedly enables snap")

	PlaytestLab.set_akio_render_test_preset("linear_snap")
	presenter.call("sync_from_source", 0.0)
	visual_state = presenter.call("get_presentation_state_for_test")
	_expect(int(visual_state.get("render_filter", -1)) == CanvasItem.TEXTURE_FILTER_LINEAR, "linear+snap changed filtering")
	_expect(bool(visual_state.get("render_world_pixel_snap", false)), "linear+snap did not enable snap")
	_expect(presenter.global_position.distance_to(Vector2(10.0, 18.0)) < 0.01, "linear+snap did not round visual world position")

	PlaytestLab.set_akio_render_test_preset("nearest_snap")
	presenter.call("sync_from_source", 0.0)
	visual_state = presenter.call("get_presentation_state_for_test")
	_expect(int(visual_state.get("render_filter", -1)) == CanvasItem.TEXTURE_FILTER_NEAREST, "nearest+snap lost nearest filter")
	_expect(bool(visual_state.get("render_world_pixel_snap", false)), "nearest+snap lost snap")

	PlaytestLab.set_akio_render_test_preset("linear_125")
	presenter.call("sync_from_source", 0.0)
	visual_state = presenter.call("get_presentation_state_for_test")
	_expect(is_equal_approx(float(visual_state.get("visual_scale", -1.0)), 0.625), "125-percent scale preset not applied")
	_expect(int(visual_state.get("render_filter", -1)) == CanvasItem.TEXTURE_FILTER_LINEAR, "125-percent comparison changed filtering")
	_expect(presenter.global_position.distance_to(player.global_position) < 0.01, "125-percent comparison retained unwanted snap")


	# Complete, tiny 8-direction fixture verifies that actual image mipmaps
	# are present and that the source and frame timing remain unchanged.
	var fixture := SpriteFrames.new()
	fixture.remove_animation(&"default")
	for direction: String in ["e", "se", "s", "sw", "w", "nw", "n", "ne"]:
		var animation := StringName("move_%s" % direction)
		fixture.add_animation(animation)
		fixture.set_animation_speed(animation, 30.0)
		fixture.set_animation_loop(animation, true)
		for frame: int in range(16):
			var pixels := Image.create(8, 8, false, Image.FORMAT_RGBA8)
			pixels.fill(Color(0.2, float(frame) / 16.0, 0.8, 1.0))
			fixture.add_frame(animation, ImageTexture.create_from_image(pixels))
	var original_texture: Texture2D = fixture.get_frame_texture(&"move_e", 0)
	var original_pixel: Color = original_texture.get_image().get_pixel(0, 0)
	var mipped: SpriteFrames = PlaytestLab.get_akio_mipmapped_run_frames(fixture)
	_expect(mipped != null, "Run mipmap generation did not produce an atlas")
	if mipped != null:
		_expect(mipped.get_frame_count(&"move_e") == 16, "mipmap mode changed frame count")
		_expect(is_equal_approx(mipped.get_animation_speed(&"move_e"), 30.0), "mipmap mode changed FPS")
		_expect(mipped.get_animation_loop(&"move_e"), "mipmap mode changed loop setting")
		_expect(mipped.get_frame_texture(&"move_e", 0).get_image().has_mipmaps(), "mipmap variant lacks mip levels")
		_expect(fixture.get_frame_texture(&"move_e", 0) == original_texture, "mipmap mode replaced the source texture")
		_expect(fixture.get_frame_texture(&"move_e", 0).get_image().get_pixel(0, 0).is_equal_approx(original_pixel), "mipmap mode changed source pixels")
	comparison_profile.set("sprite_frames", fixture)
	presenter.call("set_profile", comparison_profile)
	PlaytestLab.set_akio_render_test_preset("mipmapped_run")
	presenter.call("sync_from_source", 0.0)
	visual_state = presenter.call("get_presentation_state_for_test")
	_expect(bool(visual_state.get("render_mipmaps_active", false)), "mipmapped Run was not applied")
	_expect(int(visual_state.get("render_filter", -1)) == CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS, "mipmap mode did not change GPU filter")
	_expect(is_equal_approx(float(visual_state.get("visual_scale", -1.0)), 0.5), "mipmap mode changed scale")
	_expect(presenter.global_position.distance_to(player.global_position) < 0.01, "mipmap mode changed position")

	PlaytestLab.set_akio_render_test_preset("not_a_preset")
	presenter.call("sync_from_source", 0.0)
	visual_state = presenter.call("get_presentation_state_for_test")
	_expect(PlaytestLab.get_akio_render_test_preset() == "baseline", "invalid preset should restore baseline")
	_expect(is_equal_approx(float(visual_state.get("visual_scale", -1.0)), 0.5), "reset-to-baseline failed to restore actor scale")
	_expect(int(visual_state.get("render_filter", -1)) == CanvasItem.TEXTURE_FILTER_LINEAR, "reset-to-baseline failed to restore original filtering")
	_expect(not bool(visual_state.get("render_mipmaps_active", false)), "baseline retained generated Run mipmaps")
	_expect(presenter.global_position.distance_to(player.global_position) < 0.01, "reset-to-baseline retained pixel snapping")

	# Owner-confirmed corrective baseline must be PHYSICS+ON. Retain a debug-only
	# exact reproduction of the old IDLE+ON jitter and the IDLE+OFF workaround.
	# Frame lock must change only the displayed pose during locomotion.
	PlaytestLab.set_akio_run_sync_test_mode("pose_lock")
	player.velocity = Vector2(100.0, 0.0)
	presenter.call("sync_from_source", 0.0)
	visual_state = presenter.call("get_presentation_state_for_test")
	_expect(str(visual_state.get("state", "")) == "move", "pose-lock fixture was not moving")
	_expect(int(visual_state.get("sprite_frame", -1)) == 4, "pose-lock did not hold frame 4")
	_expect(not bool(visual_state.get("sprite_playing", true)), "pose-lock leaves sprite internal animation clock running")
	PlaytestLab.set_akio_run_sync_test_mode("baseline")
	var test_camera: Camera2D = player.get_node_or_null("Camera2D") as Camera2D
	_expect(test_camera != null, "camera comparison requires canonical Camera2D")
	if test_camera != null:
		var normal_callback: int = test_camera.process_callback
		var normal_smoothing: bool = test_camera.position_smoothing_enabled
		_expect(normal_callback == Camera2D.CAMERA2D_PROCESS_PHYSICS, "canonical camera must default to physics callback")
		_expect(normal_smoothing, "canonical camera must preserve smoothing under physics callback")
		PlaytestLab.set_akio_run_sync_test_mode("legacy_idle_smoothing")
		test_camera.call("_process", 0.0)
		_expect(test_camera.process_callback == Camera2D.CAMERA2D_PROCESS_IDLE, "legacy IDLE+ON mode not applied")
		_expect(test_camera.position_smoothing_enabled, "legacy IDLE+ON lost original smoothing")
		PlaytestLab.set_akio_run_sync_test_mode("legacy_idle_no_smoothing")
		test_camera.call("_process", 0.0)
		_expect(test_camera.process_callback == Camera2D.CAMERA2D_PROCESS_IDLE, "legacy IDLE+OFF changed its callback")
		_expect(not test_camera.position_smoothing_enabled, "legacy IDLE+OFF did not disable smoothing")
		PlaytestLab.set_akio_run_sync_test_mode("baseline")
		test_camera.call("_process", 0.0)
		_expect(test_camera.process_callback == Camera2D.CAMERA2D_PROCESS_PHYSICS, "baseline did not restore physics camera callback")
		_expect(test_camera.position_smoothing_enabled, "baseline did not restore smoothing")
		_expect(test_camera.process_callback == normal_callback, "camera callback baseline drifted from startup")
		_expect(test_camera.position_smoothing_enabled == normal_smoothing, "camera smoothing baseline drifted from startup")
		PlaytestLab.set_akio_run_sync_test_mode("invalid_camera_mode")
		_expect(PlaytestLab.get_akio_run_sync_test_mode() == "baseline", "invalid camera mode did not restore fixed default")
	player.velocity = Vector2.ZERO
	presenter.queue_free()

	# Regression: Normal combat must honor Hammer's gameplay timing when selected.
	# Previously this silently fell back to the fast prototype unless isolation
	# was also enabled. This is the specific bug fixed for Checkpoint B.
	_expect(PlaytestLab.get_akio_quick_slash_timing_mode() == HAMMER, "Hammer should be the default debug gameplay timing")
	_expect(PlaytestLab.is_akio_source_gameplay_active(), "normal combat ignored Hammer timing selection")
	player.call("_start_attack", 0)
	_expect(bool((player.get("_attack_profile") as Dictionary).get("checkpoint_b_source_timing", false)), "normal combat fell back to fast Quick Slash")
	_expect(is_equal_approx(float((player.get("_attack_profile") as Dictionary).get("duration", -1.0)), TIMING.STARTUP_DURATION + TIMING.ACTIVE_DURATION), "normal combat has the wrong Hammer attack state duration")

	# Switching only the timing dropdown (without isolation) restores the
	# original authored fast values; combo selection stays in Normal mode.
	PlaytestLab.set_akio_quick_slash_timing_mode(PROTOTYPE)
	_expect(not PlaytestLab.is_akio_source_gameplay_active(), "prototype selected but still reporting Hammer source")
	player.call("_start_attack", 0)
	_expect(not bool((player.get("_attack_profile") as Dictionary).get("checkpoint_b_source_timing", false)), "prototype flag leaked into normal combat")
	_expect(is_equal_approx(float((player.get("_attack_profile") as Dictionary).get("duration", -1.0)), 0.36), "normal prototype duration changed")

	# Focused original/prototype comparison must still be available.
	PlaytestLab.set_focused_test_scenario(QUICK)
	PlaytestLab.set_akio_quick_slash_timing_mode(PROTOTYPE)
	_expect(PlaytestLab.is_akio_quick_slash_focus_active(), "focused Quick Slash mode not enabled")
	_expect(not PlaytestLab.is_akio_source_gameplay_active(), "prototype unexpectedly uses Hammer timing")
	player.call("_start_attack", 2)
	var current: Dictionary = player.get("_attack_profile") as Dictionary
	_expect(str(current.get("id", "")) == "quick_slash", "focused mode selected Heavy Cleave")
	_expect(int(player.get("_combo_index")) == 0, "focused attack advanced combo index")
	_expect(not bool(player.call("_can_queue_next_combo_attack")), "focused mode allowed combo queue")
	_expect(not bool(player.call("_can_queue_sword_branch")), "focused mode allowed thrust branch")
	_expect(is_equal_approx(float(current.get("duration", -1.0)), 0.36), "prototype Quick Slash duration changed")
	_expect(is_equal_approx(float(current.get("startup", -1.0)), 0.055), "prototype Quick Slash startup changed")
	_expect(is_equal_approx(float(current.get("active", -1.0)), 0.075), "prototype Quick Slash hitbox timing changed")

	# Focused Hammer timing: use the actual 41-frame/30fps cadence in gameplay.
	PlaytestLab.set_akio_quick_slash_timing_mode(HAMMER)
	_expect(PlaytestLab.is_akio_source_gameplay_active(), "Hammer source gameplay mode not active")
	player.call("_start_attack", 0)
	current = player.get("_attack_profile") as Dictionary
	_expect(bool(current.get("checkpoint_b_source_timing", false)), "Hammer profile marker missing")
	_expect(is_equal_approx(float(current.get("duration", -1.0)), TIMING.STARTUP_DURATION + TIMING.ACTIVE_DURATION), "Hammer attack-state duration mismatch")
	_expect(is_equal_approx(float(current.get("startup", -1.0)), TIMING.STARTUP_DURATION), "Hammer startup mismatch")
	_expect(is_equal_approx(float(current.get("active", -1.0)), TIMING.ACTIVE_DURATION), "Hammer active window mismatch")
	_expect(is_equal_approx(float(current.get("recovery", -1.0)), TIMING.RECOVERY_DURATION), "Hammer recovery mismatch")
	_expect(is_equal_approx(float(current.get("duration", 0.0)) + float(current.get("recovery", 0.0)), TIMING.SOURCE_TOTAL_DURATION), "full gameplay lifecycle must equal 41 source frames")
	_expect(not bool(player.call("_can_start_dodge")), "early committed windup allowed a dash")
	_expect(not bool(player.call("_can_start_parry")), "early committed windup allowed a parry")

	var runner_value: Variant = player.get("_v2_player_action_runner")
	if runner_value is Node and is_instance_valid(runner_value):
		var runner := runner_value as Node
		_expect(is_equal_approx(float(runner.call("action_duration")), TIMING.SOURCE_TOTAL_DURATION), "runner/source durations diverge")
		player.call("_end_attack")
		_expect(bool(runner.call("is_running")), "runner ended before recoverable source frames")
		_expect(not bool(player.get("_attack_hitbox_active")), "hitbox stayed active entering source recovery")
		_expect(bool(player.call("_can_start_dodge")), "dash unavailable in Hammer recovery")
		_expect(bool(player.call("_can_start_parry")), "parry unavailable in Hammer recovery")
		var before := float(runner.get("action_elapsed"))
		player.call("_state_attack_recovery", 0.10)
		_expect(float(runner.get("action_elapsed")) > before + 0.09, "source animation clock froze in recovery")
		_expect(bool(runner.call("is_running")), "runner ended early during source recovery")
		player.call("_start_dodge")
		_expect(not bool(runner.call("is_running")), "dash did not interrupt the source animation")
		_expect(not bool(player.get("_attack_hitbox_active")), "dash left source hitbox active")
	else:
		_failures.append("CombatActionRunner was not attached to focused player")

	# Tap and hold still resolve exclusively to Quick Slash, regardless of cadence.
	player.call("_start_tap_attack_from_hold")
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "quick_slash", "tap escaped Quick Slash isolation")
	player.call("_start_thrust")
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "quick_slash", "hold escaped Quick Slash isolation")

	# Return to the normal three-hit profiles; no global authoring changes.
	PlaytestLab.set_focused_test_scenario(NORMAL)
	_expect(not PlaytestLab.is_akio_quick_slash_focus_active(), "focus mode failed to turn off")
	player.call("_start_attack", 1)
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "cross_cut", "normal Cross Cut missing")
	_expect(int(player.get("_combo_index")) == 1, "normal combo index missing")
	player.call("_start_attack", 2)
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "heavy_cleave", "normal Heavy Cleave missing")
	player.call("_start_attack", 0)
	_expect(bool((player.get("_attack_profile") as Dictionary).get("checkpoint_b_source_timing", false)), "normal Quick Slash did not retain selected Hammer timing")

	player.queue_free()
	AspectRuntime.selected_aspect = old_aspect
	AspectRuntime.tier = old_tier
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	PlaytestLab.set_focused_test_scenario(NORMAL)
	PlaytestLab.set_akio_quick_slash_timing_mode(HAMMER)
	PlaytestLab.set_akio_render_test_preset("baseline")
	PlaytestLab.set_akio_run_sync_test_mode("baseline")
	if _failures.is_empty():
		print("[AkioFocusedPlaytestSmoke] PASS - Hammer 30 FPS gameplay | physics camera default + legacy jitter regression + pose isolation | recovery dash/parry | prototype fallback | normal combo identities")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[AkioFocusedPlaytestSmoke] " + failure)
	get_tree().quit(1)
