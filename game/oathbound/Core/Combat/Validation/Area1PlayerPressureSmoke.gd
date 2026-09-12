extends Node

const ASPECT_CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const CANONICAL_PLAYER_SCRIPT = preload("res://Player/OathboundCombatPlayer.gd")
const PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")

var _failures: Array[String] = []
var _old_aspect: String = ""
var _old_tier: int = 0


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	if typeof(AspectRuntime) == TYPE_OBJECT:
		_old_aspect = str(AspectRuntime.selected_aspect)
		_old_tier = int(AspectRuntime.tier)
		AspectRuntime.selected_aspect = ""
		AspectRuntime.tier = 0

	_test_damage_contract()
	await _test_live_pressure_string()
	_restore_aspect()
	_finish()


func _test_damage_contract() -> void:
	var target: Array[int] = CANONICAL_PLAYER_SCRIPT.area1_pressure_damage_target()
	_expect(target == [9, 12, 21, 9, 12, 21], "pressure damage sequence is not 9/12/21 repeated")
	_expect(CANONICAL_PLAYER_SCRIPT.area1_pressure_total_damage_target() == 84, "six-hit pressure target no longer totals 84")

	var profiles: Array = ASPECT_CATALOG.get_basic_profiles(ASPECT_CATALOG.NO_ASPECT, 0)
	_expect(profiles.size() == 3, "base katana profile count changed")
	if profiles.size() >= 3:
		_expect(int((profiles[0] as Dictionary).get("health_damage", -1)) == 9, "Quick Slash damage changed")
		_expect(int((profiles[1] as Dictionary).get("health_damage", -1)) == 12, "Cross Cut damage changed")
		_expect(int((profiles[2] as Dictionary).get("health_damage", -1)) == 21, "Heavy Cleave damage changed")


func _test_live_pressure_string() -> void:
	var player: Node = PLAYER_SCENE.instantiate()
	if player == null:
		_fail("could not instantiate canonical aspect Player")
		return
	player.name = "Area1PlayerPressureSmokePlayer"
	add_child(player)
	await get_tree().process_frame
	if player.has_method("set_physics_process"):
		player.set_physics_process(false)

	_expect(player.get_script() == CANONICAL_PLAYER_SCRIPT, "canonical aspect Player no longer owns OathboundCombatPlayer.gd")
	_expect(player.has_method("get_area1_pressure_snapshot"), "canonical Player is missing Area 1 pressure extension")
	_expect(player.has_method("has_v2_player_action_motor_runtime"), "pressure Player lost V2 PlayerMotor/ActionRunner seam")
	if player.has_method("has_v2_player_action_motor_runtime"):
		_expect(bool(player.call("has_v2_player_action_motor_runtime")), "pressure Player failed to attach V2 motion runtime")

	var profiles: Array = ASPECT_CATALOG.get_basic_profiles(ASPECT_CATALOG.NO_ASPECT, 0)
	if profiles.size() < 3:
		player.queue_free()
		return
	var quick: Dictionary = (profiles[0] as Dictionary).duplicate(true)
	var cross: Dictionary = (profiles[1] as Dictionary).duplicate(true)
	var heavy: Dictionary = (profiles[2] as Dictionary).duplicate(true)

	player.call("_start_profile_attack", quick, 0)
	_expect(_hits_started(player) == 1, "Quick #1 did not open pressure commitment")
	player.call("_start_profile_attack", cross, 1)
	_expect(_hits_started(player) == 2, "Cross #2 did not continue pressure commitment")
	player.call("_start_profile_attack", heavy, 2)
	_expect(_hits_started(player) == 3, "Heavy #3 did not reach pressure midpoint")

	var midpoint_profile: Dictionary = player.get("_attack_profile") as Dictionary
	_expect(bool(midpoint_profile.get("area1_pressure_midpoint", false)), "first Heavy is not marked as midpoint punctuation")
	_expect(bool(midpoint_profile.get("can_combo", false)), "first Heavy cannot continue into second phrase")
	player.set("_attack_elapsed", float(midpoint_profile.get("duration", 0.68)) * 0.80)
	_expect(bool(player.call("_can_queue_next_combo_attack")), "midpoint Heavy cannot accept a late tap queue")
	player.call("_queue_next_combo_attack")
	_expect(int(player.get("_queued_combo_index")) == 0, "midpoint Heavy did not wrap queued continuation to Quick #4")

	player.set("_state", 4) # State.ATTACK_RECOVERY in the imported controller.
	player.call("_start_profile_attack", quick, 0)
	_expect(_hits_started(player) == 4, "Quick #4 incorrectly reset the six-hit commitment")
	player.call("_start_profile_attack", cross, 1)
	_expect(_hits_started(player) == 5, "Cross #5 did not remain inside pressure commitment")
	player.call("_start_profile_attack", heavy, 2)
	_expect(_hits_started(player) == 6, "Heavy #6 did not complete pressure commitment")

	var endpoint_profile: Dictionary = player.get("_attack_profile") as Dictionary
	_expect(not bool(endpoint_profile.get("area1_pressure_midpoint", false)), "second Heavy was incorrectly marked as another midpoint")
	_expect(not bool(endpoint_profile.get("can_combo", true)), "second Heavy lost its natural endpoint semantics")

	if is_instance_valid(player):
		player.queue_free()


func _hits_started(player: Node) -> int:
	var snapshot_value: Variant = player.call("get_area1_pressure_snapshot") if player.has_method("get_area1_pressure_snapshot") else {}
	if snapshot_value is Dictionary:
		return int((snapshot_value as Dictionary).get("hits_started", -1))
	return -1


func _restore_aspect() -> void:
	if typeof(AspectRuntime) == TYPE_OBJECT:
		AspectRuntime.selected_aspect = _old_aspect
		AspectRuntime.tier = _old_tier


func _finish() -> void:
	if _failures.is_empty():
		print("[Area1PlayerPressureSmoke] PASS - canonical Player ownership | six-hit 84-damage pressure string | midpoint Heavy continuation | natural hit-six endpoint | V2 motion ownership")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Area1PlayerPressureSmoke] %s" % failure)
	print("[Area1PlayerPressureSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
