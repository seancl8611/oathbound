extends Node

const TITLE_SCENE: PackedScene = preload("res://TitleScreen/menu.tscn")
const REST_SCENE: PackedScene = preload("res://Core/Chambers/Types/RestChamber.tscn")
const EXPECTED_FRESH_SAVE_DESTINATION := "res://World/HubScene.tscn"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	_validate_run_result_build()
	await _validate_fresh_save_destination()
	await _validate_rest_gate_ownership()
	_finish()


func _validate_run_result_build() -> void:
	_expect(typeof(RecordsRuntime) == TYPE_OBJECT, "RecordsRuntime autoload is unavailable")
	_expect(typeof(MetaProgress) == TYPE_OBJECT, "MetaProgress autoload is unavailable")
	if typeof(RecordsRuntime) != TYPE_OBJECT or typeof(MetaProgress) != TYPE_OBJECT:
		return
	_expect(MetaProgress.has_method("get_heart_bindings_remaining"), "canonical Heart Binding remaining API is missing")
	if not MetaProgress.has_method("get_heart_bindings_remaining"):
		return
	var result_value: Variant = RecordsRuntime.call("_build_run_result", false, "failed", 241.711)
	_expect(result_value is Dictionary, "failed-run result did not build a Dictionary")
	if not (result_value is Dictionary):
		return
	var result: Dictionary = result_value as Dictionary
	_expect(
		int(result.get("bindings_remaining", -1)) == int(MetaProgress.call("get_heart_bindings_remaining")),
		"failed-run result did not use canonical remaining Heart Binding state"
	)
	_expect(not bool(result.get("successful", true)), "failed-run result changed success state")
	_expect(str(result.get("completion_kind", "")) == "failed", "failed-run result changed completion kind")


func _validate_fresh_save_destination() -> void:
	var front_end: Node = TITLE_SCENE.instantiate()
	_expect(front_end != null, "could not instantiate launch front end")
	if front_end == null:
		return
	add_child(front_end)
	await get_tree().process_frame
	_expect(front_end.has_method("get_new_game_destination_path"), "front end lacks explicit fresh-save destination contract")
	if front_end.has_method("get_new_game_destination_path"):
		_expect(
			str(front_end.call("get_new_game_destination_path")) == EXPECTED_FRESH_SAVE_DESTINATION,
			"New Game / overwrite does not route to The Strand"
		)
	front_end.queue_free()
	await get_tree().process_frame


func _validate_rest_gate_ownership() -> void:
	var rest: Node = REST_SCENE.instantiate()
	_expect(rest != null, "could not instantiate Rest Chamber")
	if rest == null:
		return
	add_child(rest)
	await get_tree().process_frame
	var gate: Node = rest.get_node_or_null("ExitGate")
	_expect(gate != null, "Rest Chamber ExitGate missing")
	if gate != null and gate.has_signal("gate_used"):
		var duplicate_callback := Callable(rest, "_on_gate_used")
		_expect(
			not gate.is_connected("gate_used", duplicate_callback),
			"Rest Chamber still owns the same route gate callback as GameFlow"
		)
	rest.queue_free()
	await get_tree().process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("[PostPlaytestStabilitySmoke] PASS - failed-run result builds | fresh save -> Strand | Rest gate single-owner")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[PostPlaytestStabilitySmoke] %s" % failure)
	print("[PostPlaytestStabilitySmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
