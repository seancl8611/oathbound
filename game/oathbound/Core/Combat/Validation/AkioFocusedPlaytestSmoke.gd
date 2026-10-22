extends Node

const PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const SOURCE_PROFILE = preload("res://Presentation/Profiles/AkioCheckpointBProfile.tres")
const NORMAL := "normal"
const QUICK := "akio_checkpoint_b_quick_slash"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	if not OS.is_debug_build():
		_failures.append("focused test harness must be exercised in a debug build")
		_finish()
		return
	_expect(PlaytestLab.has_method("set_focused_test_scenario"), "PlaytestLab focused scenario setter is missing")
	_expect(PlaytestLab.has_method("is_akio_quick_slash_focus_active"), "PlaytestLab focused scenario query is missing")
	_expect(PlaytestLab.get_focused_test_scenario() == NORMAL, "normal combat is not the default")
	_expect(is_equal_approx(float(SOURCE_PROFILE.get("default_fps")), 30.0), "Hammer source FPS contract changed")

	var previous_aspect: String = str(AspectRuntime.selected_aspect)
	var previous_tier: int = int(AspectRuntime.tier)
	AspectRuntime.selected_aspect = ""
	AspectRuntime.tier = 0

	var player: Node = PLAYER_SCENE.instantiate()
	add_child(player)
	await get_tree().process_frame
	player.set_physics_process(false)

	PlaytestLab.set_focused_test_scenario(QUICK)
	_expect(PlaytestLab.is_akio_quick_slash_focus_active(), "focused Quick Slash mode not enabled")
	player.call("_start_attack", 2)
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "quick_slash", "a heavy attack was selected while focused")
	_expect(int(player.get("_combo_index")) == 0, "focused basic attack advanced combo index")
	_expect(not bool(player.call("_can_queue_next_combo_attack")), "focused attack unexpectedly allows combo queue")
	_expect(not bool(player.call("_can_queue_sword_branch")), "focused attack unexpectedly allows sword branch")

	var current: Dictionary = player.get("_attack_profile") as Dictionary
	_expect(is_equal_approx(float(current.get("duration", -1.0)), 0.36), "focused mode mutated authored Quick Slash duration")
	_expect(is_equal_approx(float(current.get("startup", -1.0)), 0.055), "focused mode mutated authored Quick Slash startup")
	_expect(is_equal_approx(float(current.get("active", -1.0)), 0.075), "focused mode mutated authored Quick Slash active hit window")

	player.call("_start_tap_attack_from_hold")
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "quick_slash", "tap attack was not isolated")
	player.call("_start_thrust")
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "quick_slash", "hold release escaped Quick Slash isolation")

	PlaytestLab.set_focused_test_scenario(NORMAL)
	_expect(not PlaytestLab.is_akio_quick_slash_focus_active(), "focus mode still active after disabling")
	player.call("_start_attack", 1)
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "cross_cut", "normal Cross Cut was not restored")
	_expect(int(player.get("_combo_index")) == 1, "normal combo index did not restore")
	player.call("_start_attack", 2)
	_expect(str((player.get("_attack_profile") as Dictionary).get("id", "")) == "heavy_cleave", "normal Heavy Cleave was not restored")

	player.queue_free()
	AspectRuntime.selected_aspect = previous_aspect
	AspectRuntime.tier = previous_tier
	_finish()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)


func _finish() -> void:
	PlaytestLab.set_focused_test_scenario(NORMAL)
	if _failures.is_empty():
		print("[AkioFocusedPlaytestSmoke] PASS - isolation | normal combo restoration | unchanged combat timings | source 30 FPS")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[AkioFocusedPlaytestSmoke] " + failure)
	get_tree().quit(1)
