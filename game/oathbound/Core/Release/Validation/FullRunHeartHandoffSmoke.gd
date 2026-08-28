extends Node

## Final player-route integration boundary.
##
## Regional traversal tests own individual chamber composition. RunRegionHandoffSmoke
## owns Region 1 -> 2 -> 3 release-runtime continuity. KagutsuchiFullRunSmoke owns the
## physical Shogun -> Heart handoff in Region 3. This smoke closes the remaining seam:
## one release GameFlow instance must preserve the same run/build while advancing
## Region 1 -> 2 -> 3 and then invoking production next_room() at the final Kagutsuchi
## boss to construct the real Heart Approach. It deliberately stops there; Heart combat
## remains unauthored and is not simulated.

const HARNESS: Script = preload("res://Core/Release/Validation/OathboundFullRunHandoffHarness.gd")
const EXPECTED_HANDOFF_SCRIPT := "res://Core/Endgame/HeartHandoffChamber.gd"
const EXPECTED_OUTCOME := "pre_awakened_heart_contact"
const EXPECTED_TOTAL_COUNTED_DEPTH := 33
const FIXTURE_GOLD := 241
const FIXTURE_REROLLS := 3
const FIXTURE_TECHNIQUES: Array[String] = [
	"full_run_echo_technique",
	"full_run_crimson_technique",
	"full_run_rift_technique",
]

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	var original_run_state: Dictionary = RunData.get_checkpoint_state() if typeof(RunData) == TYPE_OBJECT and RunData.has_method("get_checkpoint_state") else {}
	var original_meta := {
		"returning_blood_awakened": bool(MetaProgress.returning_blood_awakened),
		"story_complete": bool(MetaProgress.story_complete),
		"heart_bindings_destroyed": int(MetaProgress.heart_bindings_destroyed),
	}

	await _run_full_handoff_contract()

	if typeof(MetaProgress) == TYPE_OBJECT:
		MetaProgress.returning_blood_awakened = bool(original_meta.get("returning_blood_awakened", false))
		MetaProgress.story_complete = bool(original_meta.get("story_complete", false))
		MetaProgress.heart_bindings_destroyed = int(original_meta.get("heart_bindings_destroyed", 0))
	if not original_run_state.is_empty() and typeof(RunData) == TYPE_OBJECT and RunData.has_method("restore_checkpoint_state"):
		RunData.restore_checkpoint_state(original_run_state)

	if _failures.is_empty():
		print("[FullRunHeartHandoffSmoke] PASS - release GameFlow Region 1->2->3->Heart Approach | 33 counted chambers | build continuity | single final handoff | no Heart combat simulation")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[FullRunHeartHandoffSmoke] FAIL: %s" % failure)
	get_tree().quit(1)


func _run_full_handoff_contract() -> void:
	if typeof(RunData) != TYPE_OBJECT or not RunData.has_method("reset_for_new_run"):
		_fail("RunData release autoload missing")
		return
	if typeof(MetaProgress) != TYPE_OBJECT:
		_fail("MetaProgress autoload missing")
		return

	# Direct fixture mutation is intentionally non-durable and emits no campaign
	# signals. This establishes a canonical first-attempt Shogun outcome, which reaches
	# Heart Approach but cannot complete a Binding or Heart victory. Exact values are
	# restored before the smoke exits.
	MetaProgress.returning_blood_awakened = false
	MetaProgress.story_complete = false
	MetaProgress.heart_bindings_destroyed = 0

	RunData.reset_for_new_run(1)
	RunData.add_gold(FIXTURE_GOLD)
	RunData.technique_rerolls = FIXTURE_REROLLS
	RunData.acquired_upgrades.assign(FIXTURE_TECHNIQUES)
	RunData.enemies_killed = 17
	RunData.parries_performed = 8
	RunData.perfect_parries = 5

	# The authored route budgets are 12 / 10 / 11 counted chambers. Seed the run at
	# the point immediately before the final Kagutsuchi boss is recorded so production
	# _record_final_kagutsuchi_depth() must produce the 33rd counted chamber exactly once.
	RunData.depth = EXPECTED_TOTAL_COUNTED_DEPTH - 1
	RunData.path_history.clear()
	for i: int in range(EXPECTED_TOTAL_COUNTED_DEPTH - 1):
		RunData.path_history.append("integration_counted_%02d" % (i + 1))

	var continuity_before := _capture_build_continuity()
	RouteGenerator.set_seed(20260828)
	var flow_value: Variant = HARNESS.new()
	if not (flow_value is Node):
		_fail("Could not instantiate full-run release handoff harness")
		return
	var flow: Node = flow_value as Node
	flow.name = "FullRunHeartHandoffFlow"
	add_child(flow)

	flow.set("current_area", 1)
	flow.set("current_index", 0)
	flow.set("route", ["boss"])
	await flow.call("_advance_to_next_area")
	await get_tree().process_frame
	_expect(int(flow.get("current_area")) == 2, "release GameFlow did not advance Region 1 -> 2")
	_expect(int(RunData.current_area_id) == 2, "RunData did not follow Region 1 -> 2 handoff")
	_expect(_capture_build_continuity() == continuity_before, "Region 1 -> 2 changed accumulated run/build state")

	await flow.call("_advance_to_next_area")
	await get_tree().process_frame
	_expect(int(flow.get("current_area")) == 3, "release GameFlow did not advance Region 2 -> 3")
	_expect(int(RunData.current_area_id) == 3, "RunData did not follow Region 2 -> 3 handoff")
	_expect(_capture_build_continuity() == continuity_before, "Region 2 -> 3 changed accumulated run/build state")

	var route_value: Variant = flow.get("route")
	var route: Array = route_value as Array if route_value is Array else []
	_expect(route.size() == 11, "Kagutsuchi handoff route expected 11 counted chambers, got %d" % route.size())
	if route.is_empty():
		flow.queue_free()
		return
	var final_token := str(route[route.size() - 1])
	_expect(RouteGenerator.get_base_room_type(final_token).to_lower() == "boss", "Kagutsuchi final token is not the Eclipse Shogun boss boundary")

	flow.set("current_index", route.size() - 1)
	RunData.current_area_id = 3
	var path_size_before := RunData.path_history.size()
	await flow.call("next_room")
	await get_tree().process_frame

	var specialized_names_value: Variant = flow.get("specialized_scene_names")
	var specialized_scripts_value: Variant = flow.get("specialized_scene_scripts")
	var specialized_outcomes_value: Variant = flow.get("specialized_scene_outcomes")
	var specialized_names: Array = specialized_names_value as Array if specialized_names_value is Array else []
	var specialized_scripts: Array = specialized_scripts_value as Array if specialized_scripts_value is Array else []
	var specialized_outcomes: Array = specialized_outcomes_value as Array if specialized_outcomes_value is Array else []

	_expect(specialized_names == ["HeartHandoffChamber"], "final release seam did not construct exactly one HeartHandoffChamber: %s" % str(specialized_names))
	_expect(specialized_scripts == [EXPECTED_HANDOFF_SCRIPT], "final release seam loaded wrong specialized scene script: %s" % str(specialized_scripts))
	_expect(specialized_outcomes == [EXPECTED_OUTCOME], "pre-awakened campaign state selected wrong Heart handoff outcome: %s" % str(specialized_outcomes))
	_expect(str(flow.get("_endgame_outcome")) == EXPECTED_OUTCOME, "release GameFlow endgame outcome drifted from captured Heart handoff metadata")
	_expect(bool(flow.get("_endgame_handoff_active")), "release GameFlow did not lock the final handoff lifetime")
	_expect(int(flow.get("current_area")) == 3 and int(RunData.current_area_id) == 3, "Heart Approach incorrectly advanced/reset the run area before its outcome resolves")
	_expect(int(RunData.depth) == EXPECTED_TOTAL_COUNTED_DEPTH, "final Shogun boundary must record counted depth 33 exactly once")
	_expect(RunData.path_history.size() == path_size_before + 1, "final Shogun boundary did not append exactly one counted chamber")
	if not RunData.path_history.is_empty():
		_expect(str(RunData.path_history[RunData.path_history.size() - 1]) == final_token.to_lower(), "final counted path entry is not the Kagutsuchi boss token")
	_expect(_capture_build_continuity() == continuity_before, "Shogun -> Heart Approach changed Gold/Techniques/rerolls/combat statistics")

	# Re-entrant next_room calls can happen from duplicate clear/gate signals. Once the
	# endgame handoff owns the lifetime they must not add depth or spawn a second Heart
	# Approach scene.
	flow.call("next_room")
	await get_tree().process_frame
	_expect(int(RunData.depth) == EXPECTED_TOTAL_COUNTED_DEPTH, "duplicate final next_room call counted the Shogun chamber twice")
	_expect((flow.get("specialized_scene_names") as Array).size() == 1, "duplicate final next_room call spawned a second Heart handoff")

	var transitions_value: Variant = flow.get("transition_areas")
	var swaps_value: Variant = flow.get("relic_swap_contexts")
	var loaded_areas_value: Variant = flow.get("loaded_areas")
	var transitions: Array = transitions_value as Array if transitions_value is Array else []
	var swaps: Array = swaps_value as Array if swaps_value is Array else []
	var loaded_areas: Array = loaded_areas_value as Array if loaded_areas_value is Array else []
	_expect(transitions == [2, 3], "full release transition sequence drifted: %s" % str(transitions))
	_expect(swaps == ["keeper_transition", "twin_transition"], "full release safe Relic boundary sequence drifted: %s" % str(swaps))
	_expect(loaded_areas == [2, 3], "regional room-load seam should receive Regions 2 then 3 before specialized Heart handoff: %s" % str(loaded_areas))

	flow.queue_free()
	await get_tree().process_frame


func _capture_build_continuity() -> Dictionary:
	return {
		"gold": int(RunData.gold),
		"technique_rerolls": int(RunData.technique_rerolls),
		"acquired_upgrades": RunData.acquired_upgrades.duplicate(true),
		"enemies_killed": int(RunData.enemies_killed),
		"parries_performed": int(RunData.parries_performed),
		"perfect_parries": int(RunData.perfect_parries),
		"run_goal": str(RunData.run_goal),
	}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
