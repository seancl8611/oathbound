extends Node

const INTEGRATION_TELEMETRY = preload("res://Core/Release/OathboundIntegrationTelemetry.gd")


func _ready() -> void:
	await get_tree().process_frame
	var resource_before: Dictionary = MetaProgress.get_resource_snapshot().duplicate(true) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_resource_snapshot") else {}
	var bindings_before := int(MetaProgress.get_heart_bindings_destroyed()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_heart_bindings_destroyed") else 0
	var story_before := bool(MetaProgress.is_story_complete()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("is_story_complete") else false

	var observer_value: Variant = INTEGRATION_TELEMETRY.new()
	_assert(observer_value is Node, "integration observer must instantiate as Node")
	var observer: Node = observer_value as Node
	add_child(observer)
	await get_tree().process_frame
	await get_tree().process_frame

	observer.call("reset_emitted_stages_for_playtest")
	observer.call("set_area_baseline_for_playtest", 1)
	observer.call("observe_state_for_playtest", 2, false)
	_assert_stages(observer, ["region_1_complete"])

	# Re-observing the same state must not duplicate the checkpoint.
	observer.call("observe_state_for_playtest", 2, false)
	_assert_stages(observer, ["region_1_complete"])

	observer.call("observe_state_for_playtest", 3, false)
	_assert_stages(observer, ["region_1_complete", "region_2_complete"])

	observer.call("observe_state_for_playtest", 3, true)
	_assert_stages(observer, ["heart_approach", "region_1_complete", "region_2_complete"])
	observer.call("observe_state_for_playtest", 3, true)
	_assert_stages(observer, ["heart_approach", "region_1_complete", "region_2_complete"])

	var snapshot_value: Variant = observer.call("capture_snapshot_for_playtest", "heart_approach")
	_assert(snapshot_value is Dictionary, "checkpoint snapshot must be a Dictionary")
	var snapshot: Dictionary = snapshot_value as Dictionary
	_assert(str(snapshot.get("stage", "")) == "heart_approach", "snapshot stage drift")
	for required_key: String in [
		"elapsed_seconds", "run_active", "area", "depth", "run_goal", "gold", "path",
		"technique_count", "techniques", "aspect", "aspect_tier", "blood", "corruption",
		"prosthetic", "relic", "player", "enemies_killed", "parries", "perfect_parries",
		"damage_taken", "combat_rooms_cleared", "blessings_received", "treasures_opened",
		"items_purchased", "resources", "resource_delta", "heart_bindings_destroyed", "story_complete",
	]:
		_assert(snapshot.has(required_key), "snapshot missing key: %s" % required_key)
	_assert(snapshot.get("resources", {}) is Dictionary, "resources snapshot must be structured")
	_assert(snapshot.get("resource_delta", {}) is Dictionary, "resource delta must be structured")

	var resource_after: Dictionary = MetaProgress.get_resource_snapshot().duplicate(true) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_resource_snapshot") else {}
	var bindings_after := int(MetaProgress.get_heart_bindings_destroyed()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_heart_bindings_destroyed") else 0
	var story_after := bool(MetaProgress.is_story_complete()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("is_story_complete") else false
	_assert(resource_after == resource_before, "diagnostic capture mutated persistent resources")
	_assert(bindings_after == bindings_before, "diagnostic capture mutated Heart Binding progress")
	_assert(story_after == story_before, "diagnostic capture mutated Story Complete")

	observer.queue_free()
	print("[OathboundIntegrationTelemetrySmoke] PASS - Region 1 | Region 2 | Heart Approach | once-only checkpoints | structured snapshot | zero progression writes")
	get_tree().quit()


func _assert_stages(observer: Node, expected: Array[String]) -> void:
	var stages_value: Variant = observer.call("get_emitted_stages_for_playtest")
	_assert(stages_value is Array, "emitted stage list must be an Array")
	var actual: Array[String] = []
	for value: Variant in stages_value as Array:
		actual.append(str(value))
	actual.sort()
	var sorted_expected := expected.duplicate()
	sorted_expected.sort()
	_assert(actual == sorted_expected, "checkpoint stages drift: %s != %s" % [str(actual), str(sorted_expected)])


func _assert(condition: bool, message: String) -> void:
	if condition:
		return
	push_error("[OathboundIntegrationTelemetrySmoke] FAIL - %s" % message)
	get_tree().quit(1)
