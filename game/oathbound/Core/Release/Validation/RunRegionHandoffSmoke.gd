extends Node

## Cross-region release-runtime contract.
##
## Regional validators already prove each route in isolation. This smoke exercises the
## production OathboundGameFlow._advance_to_next_area() and resume_prepared_run()
## implementations through a presentation/scene-loading harness so Region 1 -> 2 -> 3
## handoffs and safe checkpoint resumes keep GameFlow, RunData, route authority, and
## the accumulated run build synchronized.

const HANDOFF_HARNESS: Script = preload("res://Core/Release/Validation/OathboundRunHandoffHarness.gd")
const SAVE_SLOT_MANAGER_SCRIPT: Script = preload("res://Core/Release/OathboundSaveSlotManager.gd")
const EXPECTED_GAMEFLOW_SCRIPT := "res://Core/Release/OathboundReleaseGameFlow.gd"
const TEMP_CHECKPOINT_PATH := "user://oathbound_validation_run_checkpoint.cfg"
const FIXTURE_GOLD := 137
const FIXTURE_REROLLS := 2
const FIXTURE_DEPTH := 6
const FIXTURE_TECHNIQUES: Array[String] = [
	"integration_echo_technique",
	"integration_crimson_technique",
	"integration_rift_technique",
]

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	_remove_temp_checkpoint()
	_validate_live_gameflow_owner()

	var original_run_state: Dictionary = {}
	if typeof(RunData) == TYPE_OBJECT and RunData.has_method("get_checkpoint_state"):
		original_run_state = RunData.get_checkpoint_state()

	await _run_handoff_contract()

	if not original_run_state.is_empty() and typeof(RunData) == TYPE_OBJECT and RunData.has_method("restore_checkpoint_state"):
		RunData.restore_checkpoint_state(original_run_state)
	_remove_temp_checkpoint()

	if _failures.is_empty():
		print("[RunRegionHandoffSmoke] checkpoint PASS - Yomori/Kagutsuchi temp-file round trip | production resume reconstruction | stale-field replacement | corrupt-region rejection")
		print("[RunRegionHandoffSmoke] PASS - release GameFlow Region 1->2->3 authority | RunData/build continuity | safe Relic boundaries")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[RunRegionHandoffSmoke] %s" % failure)
		print("[RunRegionHandoffSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_live_gameflow_owner() -> void:
	if typeof(GameFlow) != TYPE_OBJECT:
		_fail("GameFlow autoload missing")
		return
	var script_value: Variant = GameFlow.get_script()
	var installed_path := (script_value as Script).resource_path if script_value is Script else ""
	_expect(installed_path == EXPECTED_GAMEFLOW_SCRIPT, "Live GameFlow is '%s', expected '%s'" % [installed_path, EXPECTED_GAMEFLOW_SCRIPT])


func _run_handoff_contract() -> void:
	if typeof(RunData) != TYPE_OBJECT or not RunData.has_method("reset_for_new_run"):
		_fail("RunData release autoload missing")
		return
	if typeof(RouteGenerator) != TYPE_OBJECT:
		_fail("RouteGenerator autoload missing")
		return

	RunData.reset_for_new_run(1)
	RunData.add_gold(FIXTURE_GOLD)
	RunData.technique_rerolls = FIXTURE_REROLLS
	RunData.depth = FIXTURE_DEPTH
	RunData.path_history.assign([
		"combat:technique",
		"combat:gold",
		"shrine",
		"combat:mist",
		"miniboss",
		"rest",
	])
	RunData.acquired_upgrades.assign(FIXTURE_TECHNIQUES)
	RunData.enemies_killed = 9
	RunData.parries_performed = 5
	RunData.perfect_parries = 3
	RunData.combat_rooms_cleared = 4
	var build_before: Dictionary = _capture_run_continuity()

	RouteGenerator.set_seed(20260825)
	var flow: Node = _new_harness("PrimaryHandoffFlow")
	if flow == null:
		return

	var serializer_value: Variant = SAVE_SLOT_MANAGER_SCRIPT.new()
	if not (serializer_value is Node):
		_fail("Could not instantiate isolated checkpoint serializer")
		flow.queue_free()
		return
	var serializer: Node = serializer_value as Node

	flow.set("current_area", 1)
	flow.set("current_index", 0)
	flow.set("route", ["boss"])
	await flow.call("_advance_to_next_area")
	await get_tree().process_frame

	_validate_region_handoff(flow, 2, 10, "keeper_transition", 0)
	_expect(_capture_run_continuity() == build_before, "Region 1 -> 2 handoff reset or mutated accumulated run state")
	await _verify_checkpoint_round_trip(flow, serializer, 2, 3, build_before)

	await flow.call("_advance_to_next_area")
	await get_tree().process_frame

	_validate_region_handoff(flow, 3, 11, "twin_transition", 1)
	_expect(_capture_run_continuity() == build_before, "Region 2 -> 3 handoff reset or mutated accumulated run state")
	await _verify_checkpoint_round_trip(flow, serializer, 3, 5, build_before)

	var transitions: Array = flow.get("transition_areas") as Array
	var swaps: Array = flow.get("relic_swap_contexts") as Array
	var loaded_areas: Array = flow.get("loaded_areas") as Array
	_expect(transitions == [2, 3], "Area transition sequence drifted: %s" % str(transitions))
	_expect(swaps == ["keeper_transition", "twin_transition"], "Safe Relic-swap boundary sequence drifted: %s" % str(swaps))
	_expect(loaded_areas == [2, 3], "Room-load boundary did not receive Regions 2 then 3: %s" % str(loaded_areas))

	serializer.free()
	flow.queue_free()
	await get_tree().process_frame


func _verify_checkpoint_round_trip(flow: Node, serializer: Node, expected_area: int, checkpoint_index: int, build_before: Dictionary) -> void:
	flow.set("current_index", checkpoint_index)
	var route_value: Variant = flow.get("route")
	var expected_route: Array = (route_value as Array).duplicate() if route_value is Array else []
	var checkpoint_value: Variant = flow.call("_build_safe_checkpoint")
	if not (checkpoint_value is Dictionary):
		_fail("Region %d production GameFlow did not build a checkpoint dictionary" % expected_area)
		return
	var checkpoint: Dictionary = (checkpoint_value as Dictionary).duplicate(true)
	_expect(not checkpoint.is_empty(), "Region %d production checkpoint was empty" % expected_area)
	_expect(int((checkpoint.get("gameflow", {}) as Dictionary).get("current_area", 0)) == expected_area, "Region %d checkpoint stored wrong GameFlow area" % expected_area)
	_expect(int((checkpoint.get("run_data", {}) as Dictionary).get("current_area_id", 0)) == expected_area, "Region %d checkpoint stored wrong RunData area" % expected_area)

	# The serializer must replace complete snapshots, not merge them. Seed one obsolete
	# field first, then overwrite with the real checkpoint and prove it disappeared.
	var stale_checkpoint := checkpoint.duplicate(true)
	stale_checkpoint["obsolete_validation_key"] = "must_not_survive"
	_expect(int(serializer.call("_write_safe_checkpoint_file", TEMP_CHECKPOINT_PATH, stale_checkpoint)) == OK, "Region %d could not write stale checkpoint fixture" % expected_area)
	_expect(int(serializer.call("_write_safe_checkpoint_file", TEMP_CHECKPOINT_PATH, checkpoint)) == OK, "Region %d could not write production checkpoint to isolated temp file" % expected_area)
	var loaded_value: Variant = serializer.call("_read_safe_checkpoint_file", TEMP_CHECKPOINT_PATH)
	if not (loaded_value is Dictionary):
		_fail("Region %d isolated checkpoint read did not return a dictionary" % expected_area)
		return
	var loaded: Dictionary = loaded_value as Dictionary
	_expect(not loaded.has("obsolete_validation_key"), "Region %d checkpoint rewrite retained a stale retired field" % expected_area)
	_expect(loaded == checkpoint, "Region %d ConfigFile checkpoint round trip changed production snapshot data" % expected_area)

	# Reject a structurally inconsistent checkpoint before it can partially mutate
	# RunData. This protects corrupted/stale files that disagree about their region.
	var invalid := loaded.duplicate(true)
	var invalid_flow: Dictionary = (invalid.get("gameflow", {}) as Dictionary).duplicate(true)
	invalid_flow["current_area"] = 3 if expected_area != 3 else 2
	invalid["gameflow"] = invalid_flow
	var state_before_rejection: Dictionary = RunData.get_checkpoint_state()
	_expect(not bool(flow.call("prepare_resume_checkpoint", invalid)), "Region %d accepted a checkpoint whose GameFlow/RunData areas disagree" % expected_area)
	_expect(RunData.get_checkpoint_state() == state_before_rejection, "Region %d invalid checkpoint mutated RunData during preparation" % expected_area)

	# Destroy the live run state and route authority before resuming. Success therefore
	# requires the production resume method to reconstruct them from the serialized file.
	RunData.reset_for_new_run(1)
	RunData.add_gold(1)
	RunData.acquired_upgrades.clear()
	RunData.path_history.clear()
	RouteGenerator.current_area = 1
	RouteGenerator.current_route = ["validation_mutation"]
	RouteGenerator.pending_choices = {"validation_mutation": ["combat", "rest"]}

	var resume_flow: Node = _new_harness("ResumeRegion%d" % expected_area)
	if resume_flow == null:
		return
	_expect(bool(resume_flow.call("prepare_resume_checkpoint", loaded)), "Region %d serialized checkpoint was rejected by production resume preparation" % expected_area)
	var resumed_value: Variant = await resume_flow.call("resume_prepared_run")
	_expect(bool(resumed_value), "Region %d production resume_prepared_run() failed" % expected_area)

	var resumed_route_value: Variant = resume_flow.get("route")
	var resumed_route: Array = resumed_route_value as Array if resumed_route_value is Array else []
	_expect(int(resume_flow.get("current_area")) == expected_area, "Region %d resume restored wrong GameFlow area" % expected_area)
	_expect(int(resume_flow.get("current_index")) == checkpoint_index, "Region %d resume restored wrong chamber index" % expected_area)
	_expect(int(RunData.current_area_id) == expected_area, "Region %d resume restored wrong RunData area" % expected_area)
	_expect(int(RouteGenerator.current_area) == expected_area, "Region %d resume restored wrong RouteGenerator area" % expected_area)
	_expect(resumed_route == expected_route, "Region %d resume changed the authored checkpoint route" % expected_area)
	_expect(RouteGenerator.current_route == expected_route, "Region %d resume left RouteGenerator route out of sync" % expected_area)
	_expect(_capture_run_continuity() == build_before, "Region %d checkpoint resume did not restore accumulated run build/state" % expected_area)
	var resume_loaded_areas_value: Variant = resume_flow.get("loaded_areas")
	var resume_loaded_areas: Array = resume_loaded_areas_value as Array if resume_loaded_areas_value is Array else []
	_expect(resume_loaded_areas == [expected_area], "Region %d resume did not reach exactly one room-load seam" % expected_area)

	resume_flow.queue_free()
	await get_tree().process_frame

	# Keep the primary flow authoritative for the next transition while preserving the
	# restored RunData/RouteGenerator state that a real resumed session would have.
	flow.set("current_area", expected_area)
	flow.set("current_index", checkpoint_index)
	flow.set("route", expected_route.duplicate())


func _new_harness(node_name: String) -> Node:
	var flow_value: Variant = HANDOFF_HARNESS.new()
	if not (flow_value is Node):
		_fail("Could not instantiate release handoff harness")
		return null
	var flow: Node = flow_value as Node
	flow.name = node_name
	add_child(flow)
	return flow


func _validate_region_handoff(flow: Node, expected_area: int, expected_chambers: int, expected_swap_context: String, handoff_index: int) -> void:
	var area := int(flow.get("current_area"))
	var current_index := int(flow.get("current_index"))
	var route_value: Variant = flow.get("route")
	var route: Array = route_value as Array if route_value is Array else []
	var swaps_value: Variant = flow.get("relic_swap_contexts")
	var swaps: Array = swaps_value as Array if swaps_value is Array else []
	var loaded_routes_value: Variant = flow.get("loaded_routes")
	var loaded_routes: Array = loaded_routes_value as Array if loaded_routes_value is Array else []

	_expect(area == expected_area, "GameFlow area expected %d, got %d" % [expected_area, area])
	_expect(int(RunData.current_area_id) == expected_area, "RunData area expected %d, got %d" % [expected_area, int(RunData.current_area_id)])
	_expect(int(RouteGenerator.current_area) == expected_area, "RouteGenerator area expected %d, got %d" % [expected_area, int(RouteGenerator.current_area)])
	_expect(current_index == 0, "Region %d should enter at chamber index 0, got %d" % [expected_area, current_index])
	_expect(route.size() == expected_chambers, "Region %d expected %d authored chambers, got %d" % [expected_area, expected_chambers, route.size()])
	if not route.is_empty():
		_expect(str(route[0]).begins_with("CHOICE_"), "Region %d must begin with its authored immediate branch opportunity" % expected_area)
		_expect(str(RouteGenerator.get_base_room_type(str(route[route.size() - 1]))).to_lower() == "boss", "Region %d final route token is not the authored boss chamber" % expected_area)
	_expect(RouteGenerator.current_route == route, "Region %d GameFlow route and RouteGenerator route diverged" % expected_area)
	_expect(swaps.size() > handoff_index and str(swaps[handoff_index]) == expected_swap_context, "Region %d transition did not use safe Relic context '%s'" % [expected_area, expected_swap_context])
	_expect(loaded_routes.size() > handoff_index, "Region %d handoff never reached the room-load seam" % expected_area)
	if loaded_routes.size() > handoff_index and loaded_routes[handoff_index] is Array:
		_expect((loaded_routes[handoff_index] as Array) == route, "Region %d room-load seam received a route different from GameFlow authority" % expected_area)


func _capture_run_continuity() -> Dictionary:
	return {
		"gold": int(RunData.gold),
		"technique_rerolls": int(RunData.technique_rerolls),
		"depth": int(RunData.depth),
		"path_history": RunData.path_history.duplicate(),
		"acquired_upgrades": RunData.acquired_upgrades.duplicate(true),
		"enemies_killed": int(RunData.enemies_killed),
		"parries_performed": int(RunData.parries_performed),
		"perfect_parries": int(RunData.perfect_parries),
		"combat_rooms_cleared": int(RunData.combat_rooms_cleared),
		"run_goal": str(RunData.run_goal),
	}


func _remove_temp_checkpoint() -> void:
	if FileAccess.file_exists(TEMP_CHECKPOINT_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEMP_CHECKPOINT_PATH))


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
