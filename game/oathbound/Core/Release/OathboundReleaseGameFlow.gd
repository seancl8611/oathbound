extends "res://autoload/OathboundRegionGameFlow.gd"

## Release-shell integration around the reconciled three-region GameFlow.
## Safe resume intentionally serializes only chamber-boundary state. Resuming recreates
## the canonical room and Player through existing authorities instead of restoring a
## frozen scene tree.

const CHECKPOINT_VERSION := 1
const EXPECTED_RELEASE_RELIC_RUNTIME_SCRIPT := "res://Core/Release/OathboundSlotRelicRuntime.gd"

var _resume_checkpoint_pending: Dictionary = {}
var _resume_in_progress := false
var _resume_player_state: Dictionary = {}


# OathboundGameFlow's ready chain calls this virtual assertion. The release adapter is
# now the persistence owner while inheriting the exact same Relic combat rules.
func _assert_current_relic_runtime() -> void:
	_assert_autoload_script("RelicRuntime", EXPECTED_RELEASE_RELIC_RUNTIME_SCRIPT, false)


func prepare_resume_checkpoint(checkpoint: Dictionary) -> bool:
	# Preparation is a replacement operation. Never let a previously selected slot's
	# pending snapshot survive a rejected checkpoint from a later Continue attempt.
	_resume_checkpoint_pending.clear()
	if not _is_resume_checkpoint_structurally_valid(checkpoint):
		return false
	_resume_checkpoint_pending = checkpoint.duplicate(true)
	return true


func _is_resume_checkpoint_structurally_valid(checkpoint: Dictionary) -> bool:
	if checkpoint.is_empty() or int(checkpoint.get("version", 0)) != CHECKPOINT_VERSION:
		return false
	var run_state_value: Variant = checkpoint.get("run_data", {})
	var flow_value: Variant = checkpoint.get("gameflow", {})
	if not (run_state_value is Dictionary) or not (flow_value is Dictionary):
		return false
	var run_state: Dictionary = run_state_value as Dictionary
	var flow: Dictionary = flow_value as Dictionary
	if run_state.is_empty() or flow.is_empty():
		return false
	var route_value: Variant = flow.get("route", [])
	if not (route_value is Array) or (route_value as Array).is_empty():
		return false
	var run_area := clampi(int(run_state.get("current_area_id", 1)), 1, max_area)
	var flow_area := clampi(int(flow.get("current_area", run_area)), 1, max_area)
	# Production snapshots write these from two authorities at the same boundary. A
	# disagreement indicates a corrupt/stale checkpoint and must not partially restore.
	if run_area != flow_area:
		return false
	return true


func has_prepared_resume_checkpoint() -> bool:
	return not _resume_checkpoint_pending.is_empty()


func start_run() -> void:
	if has_prepared_resume_checkpoint():
		push_warning("[ReleaseGameFlow] Prepared resume exists; use resume_prepared_run() instead of start_run().")
		return
	if typeof(SaveSlots) == TYPE_OBJECT:
		SaveSlots.clear_safe_checkpoint()
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("on_run_started"):
		RecordsRuntime.on_run_started(false)
	super.start_run()


func resume_prepared_run() -> bool:
	if _resume_checkpoint_pending.is_empty():
		return false
	var checkpoint := _resume_checkpoint_pending.duplicate(true)
	_resume_checkpoint_pending.clear()
	_resume_in_progress = true

	var run_state_value: Variant = checkpoint.get("run_data", {})
	if not (run_state_value is Dictionary) or not RunData.has_method("restore_checkpoint_state"):
		_resume_in_progress = false
		return false
	if not bool(RunData.restore_checkpoint_state(run_state_value as Dictionary)):
		_resume_in_progress = false
		return false

	var flow_value: Variant = checkpoint.get("gameflow", {})
	var flow: Dictionary = flow_value if flow_value is Dictionary else {}
	current_area = clampi(int(flow.get("current_area", RunData.current_area_id)), 1, max_area)
	current_index = maxi(0, int(flow.get("current_index", 0)))
	route.clear()
	var route_value: Variant = flow.get("route", [])
	if route_value is Array:
		for token_value: Variant in route_value:
			route.append(str(token_value))
	if route.is_empty():
		_resume_in_progress = false
		return false
	current_index = clampi(current_index, 0, route.size() - 1)
	_awaiting_choice = false
	_choice_slot = -1

	var pending_choices_value: Variant = flow.get("pending_choices", {})
	if pending_choices_value is Dictionary:
		RouteGenerator.pending_choices = (pending_choices_value as Dictionary).duplicate(true)
	RouteGenerator.current_route = route.duplicate()
	RouteGenerator.current_area = current_area

	_restore_aspect_state(checkpoint.get("aspect", {}))
	_restore_corruption_state(checkpoint.get("corruption", {}))
	_resume_player_state = (checkpoint.get("player", {}) as Dictionary).duplicate(true) if checkpoint.get("player", {}) is Dictionary else {}

	var record_state_value: Variant = checkpoint.get("records", {})
	var record_state: Dictionary = record_state_value if record_state_value is Dictionary else {}
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("on_run_started"):
		RecordsRuntime.on_run_started(
			true,
			float(record_state.get("elapsed_seconds", 0.0)),
			(record_state.get("resource_start", {}) as Dictionary).duplicate(true) if record_state.get("resource_start", {}) is Dictionary else {}
		)

	await _load_current_room()
	_resume_in_progress = false
	if _awaiting_choice:
		print("[ReleaseGameFlow] Safe run resumed - Region %d route choice %d/%d" % [current_area, current_index + 1, route.size()])
	else:
		print("[ReleaseGameFlow] Safe run resumed - Region %d chamber %d/%d" % [current_area, current_index + 1, route.size()])
	return true


func _load_current_room() -> void:
	await super._load_current_room()
	# Choice-first regional routes can resume before a concrete chamber exists. Keep
	# the saved Player snapshot pending until the choice resolves and the canonical
	# Player is actually parented into a room; otherwise Continue would silently reset
	# Health/Posture/Spirit at the first Yomori or Kagutsuchi choice.
	_apply_pending_resume_player_state_if_ready()
	await get_tree().process_frame
	_save_safe_checkpoint()


func _apply_pending_resume_player_state_if_ready() -> bool:
	if _resume_player_state.is_empty():
		return false
	if player == null or not is_instance_valid(player) or player.get_parent() == null:
		return false
	_apply_resume_player_state(_resume_player_state)
	_resume_player_state.clear()
	return true


func _return_to_strand(successful: bool) -> void:
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("on_run_finished") and RecordsRuntime.is_run_active():
		var completion_kind := str(RunData.run_completion_kind) if typeof(RunData) == TYPE_OBJECT else ""
		if completion_kind.is_empty():
			completion_kind = "failed" if not successful else "completed"
		RecordsRuntime.on_run_finished(successful, completion_kind)
	super._return_to_strand(successful)


func _build_safe_checkpoint() -> Dictionary:
	if typeof(RunData) != TYPE_OBJECT or not RunData.has_method("get_checkpoint_state"):
		return {}
	return {
		"version": CHECKPOINT_VERSION,
		"gameflow": {
			"current_area": current_area,
			"current_index": current_index,
			"route": route.duplicate(),
			"pending_choices": RouteGenerator.pending_choices.duplicate(true),
		},
		"run_data": RunData.get_checkpoint_state(),
		"aspect": _capture_aspect_state(),
		"corruption": _capture_corruption_state(),
		"player": _capture_player_state(),
		"records": RecordsRuntime.get_run_resume_record_state() if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("get_run_resume_record_state") else {},
	}


func _save_safe_checkpoint() -> void:
	if typeof(SaveSlots) != TYPE_OBJECT or not SaveSlots.has_method("save_safe_checkpoint"):
		return
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("is_run_active") and not RecordsRuntime.is_run_active():
		return
	var checkpoint := _build_safe_checkpoint()
	if checkpoint.is_empty():
		return
	SaveSlots.save_safe_checkpoint(checkpoint)


func _capture_aspect_state() -> Dictionary:
	if typeof(AspectRuntime) != TYPE_OBJECT:
		return {}
	return {
		"selected_aspect": str(AspectRuntime.get("selected_aspect")),
		"tier": int(AspectRuntime.get("tier")) if AspectRuntime.get("tier") != null else 0,
		"blood": float(AspectRuntime.get("blood")) if AspectRuntime.get("blood") != null else 0.0,
	}


func _restore_aspect_state(value: Variant) -> void:
	if typeof(AspectRuntime) != TYPE_OBJECT or not (value is Dictionary):
		return
	var state: Dictionary = value as Dictionary
	var aspect := str(state.get("selected_aspect", ""))
	if not aspect.is_empty() and AspectRuntime.has_method("select_aspect"):
		AspectRuntime.select_aspect(aspect)
	if AspectRuntime.has_method("set_tier"):
		AspectRuntime.set_tier(int(state.get("tier", 0)))
	if AspectRuntime.has_method("set_blood_for_playtest"):
		AspectRuntime.set_blood_for_playtest(float(state.get("blood", 0.0)))


func _capture_corruption_state() -> Dictionary:
	if typeof(CorruptionRuntime) != TYPE_OBJECT:
		return {}
	return {"corruption": int(CorruptionRuntime.get_corruption()) if CorruptionRuntime.has_method("get_corruption") else 0}


func _restore_corruption_state(value: Variant) -> void:
	if typeof(CorruptionRuntime) != TYPE_OBJECT or not (value is Dictionary):
		return
	if CorruptionRuntime.has_method("set_corruption_for_playtest"):
		CorruptionRuntime.set_corruption_for_playtest(int((value as Dictionary).get("corruption", 0)))


func _capture_player_state() -> Dictionary:
	if player == null or not is_instance_valid(player):
		# On a resumed unresolved choice there is deliberately no Player yet. Preserve
		# the saved snapshot in any checkpoint written at that boundary so another quit
		# before choosing a chamber cannot erase the Player's persisted combat state.
		if not _resume_player_state.is_empty():
			return _resume_player_state.duplicate(true)
		return {}
	var result := {
		"hp": int(player.get("hp")) if player.get("hp") != null else 1,
		"maxhp": int(player.get("maxhp")) if player.get("maxhp") != null else 1,
		"stagger_max": float(player.get("stagger_max")) if player.get("stagger_max") != null else 0.0,
	}
	var executor_value: Variant = player.get("prosthetic_executor")
	if executor_value is Node and is_instance_valid(executor_value):
		var executor := executor_value as Node
		result["spirit"] = int(executor.call("get_spirit")) if executor.has_method("get_spirit") else int(executor.get("current_spirit"))
		result["max_spirit"] = int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else int(executor.get("max_spirit"))
	return result


func _apply_resume_player_state(state: Dictionary) -> void:
	if player == null or not is_instance_valid(player):
		return
	if player.get("maxhp") != null:
		player.set("maxhp", maxi(1, int(state.get("maxhp", player.get("maxhp")))))
	if player.get("hp") != null:
		player.set("hp", clampi(int(state.get("hp", player.get("hp"))), 1, int(player.get("maxhp"))))
	if player.get("stagger_max") != null and state.has("stagger_max"):
		player.set("stagger_max", maxf(1.0, float(state.get("stagger_max", player.get("stagger_max")))))
	if player.has_method("_update_health_bar"):
		player.call("_update_health_bar")
	if player.get("collected_upgrades") != null and typeof(RunData) == TYPE_OBJECT:
		player.set("collected_upgrades", RunData.acquired_upgrades.duplicate(true))

	var executor_value: Variant = player.get("prosthetic_executor")
	if executor_value is Node and is_instance_valid(executor_value):
		var executor := executor_value as Node
		if state.has("max_spirit"):
			executor.set("max_spirit", maxi(1, int(state.get("max_spirit", executor.get("max_spirit")))))
		if state.has("spirit"):
			executor.set("current_spirit", clampi(int(state.get("spirit", executor.get("current_spirit"))), 0, int(executor.get("max_spirit"))))
		if executor.has_signal("spirit_changed"):
			executor.emit_signal("spirit_changed", int(executor.get("current_spirit")), int(executor.get("max_spirit")))
