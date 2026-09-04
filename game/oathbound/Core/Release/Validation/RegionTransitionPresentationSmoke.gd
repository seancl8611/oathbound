extends Node

## Regression for the live region-transition/choice deadlock seen after Keeper and Twin Maws.
##
## Regions 2 and 3 begin on authored CHOICE_* slots. RunScene pauses the SceneTree when
## that choice is presented, so the production transition contract must guarantee that
## no AreaTransition overlay remains when _show_area_transition() returns. The second
## case deliberately starts while the SceneTree is paused to prove the transition itself
## cannot be frozen by another modal pause source.

const EXPECTED_GAMEFLOW_SCRIPT := "res://Core/Release/OathboundReleaseGameFlow.gd"

var _failures: Array[String] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	await get_tree().process_frame
	_validate_live_gameflow_owner()

	await _exercise_transition(2, false)
	await _exercise_transition(3, true)
	get_tree().paused = false

	if _failures.is_empty():
		print("[RegionTransitionPresentationSmoke] PASS - Region 1->2 and 2->3 overlays fully retire before choice pause | transition survives paused SceneTree")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[RegionTransitionPresentationSmoke] %s" % failure)
		print("[RegionTransitionPresentationSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_live_gameflow_owner() -> void:
	if typeof(GameFlow) != TYPE_OBJECT:
		_fail("GameFlow autoload missing")
		return
	var script_value: Variant = GameFlow.get_script()
	var installed_path := (script_value as Script).resource_path if script_value is Script else ""
	_expect(installed_path == EXPECTED_GAMEFLOW_SCRIPT, "Live GameFlow is '%s', expected '%s'" % [installed_path, EXPECTED_GAMEFLOW_SCRIPT])
	_expect(GameFlow.has_method("is_area_transition_active"), "Current regional GameFlow does not expose transition lifecycle state")


func _exercise_transition(area_id: int, start_paused: bool) -> void:
	_remove_stray_transition()
	get_tree().paused = start_paused

	await GameFlow.call("_show_area_transition", area_id)

	var overlay := _find_transition_overlay()
	_expect(overlay == null, "Area %d transition returned while AreaTransition overlay was still alive" % area_id)
	if GameFlow.has_method("is_area_transition_active"):
		_expect(not bool(GameFlow.call("is_area_transition_active")), "Area %d transition lifecycle remained active after return" % area_id)

	# This mirrors the next production action for Regions 2/3: choice UI pauses the
	# SceneTree. If an overlay still existed here, it could cover the choice forever.
	get_tree().paused = true
	await get_tree().process_frame
	_expect(_find_transition_overlay() == null, "Area %d transition reappeared/remained during simulated choice pause" % area_id)
	get_tree().paused = false
	await get_tree().process_frame


func _find_transition_overlay() -> Node:
	return get_tree().root.find_child("AreaTransition", true, false)


func _remove_stray_transition() -> void:
	var overlay := _find_transition_overlay()
	while overlay != null and is_instance_valid(overlay):
		overlay.free()
		overlay = _find_transition_overlay()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
