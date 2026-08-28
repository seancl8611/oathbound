extends Node

## Debug-only observer for the long player-facing integration run. This node reads
## canonical runtime authorities and emits low-frequency structured diagnostics at the
## two regional transitions and Heart Approach. It never mutates run/save/progression.

const HEART_HANDOFF_NODE := "HeartHandoffChamber"
const EVENT_NAME := "integration_checkpoint"

var _last_area := 0
var _emitted_stages: Dictionary = {}
var _initialized := false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_initialize_observer")


func _initialize_observer() -> void:
	await get_tree().process_frame
	_last_area = _current_area()
	_initialized = true


func _process(_delta: float) -> void:
	if not _initialized or not OS.is_debug_build():
		return
	if typeof(RecordsRuntime) != TYPE_OBJECT or not RecordsRuntime.has_method("is_run_active") or not bool(RecordsRuntime.is_run_active()):
		return
	_observe_runtime_state()


func _observe_runtime_state() -> void:
	var area := _current_area()
	if _last_area <= 0:
		_last_area = area
	elif area > _last_area:
		if _last_area == 1:
			_emit_checkpoint("region_1_complete")
		elif _last_area == 2:
			_emit_checkpoint("region_2_complete")
		_last_area = area
	elif area < _last_area:
		# A debug warp/resume replacement establishes a new baseline; it must not invent
		# completion events for regions that were not traversed in this observer lifetime.
		_last_area = area

	if _has_heart_approach():
		_emit_checkpoint("heart_approach")


func _current_area() -> int:
	if typeof(GameFlow) == TYPE_OBJECT:
		var value: Variant = GameFlow.get("current_area")
		if value != null:
			return clampi(int(value), 1, 3)
	if typeof(RunData) == TYPE_OBJECT:
		return clampi(int(RunData.current_area_id), 1, 3)
	return 1


func _has_heart_approach() -> bool:
	var run_scene := get_parent()
	if run_scene == null:
		return false
	var room_container := run_scene.get_node_or_null("RoomContainer")
	if room_container == null:
		return false
	for child: Node in room_container.get_children():
		if child.name == HEART_HANDOFF_NODE:
			return true
	return false


func _emit_checkpoint(stage: String) -> bool:
	if stage.is_empty() or bool(_emitted_stages.get(stage, false)):
		return false
	_emitted_stages[stage] = true
	var snapshot := _build_snapshot(stage)
	print("[IntegrationCheckpoint] stage=%s data=%s" % [stage, JSON.stringify(snapshot)])
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.has_method("is_capturing") and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event(EVENT_NAME, snapshot)
	return true


func _build_snapshot(stage: String) -> Dictionary:
	var player := _active_player()
	var current_resources := _resource_snapshot()
	var run_start_resources := _run_start_resources()
	var snapshot := {
		"stage": stage,
		"elapsed_seconds": _elapsed_seconds(),
		"run_active": typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("is_run_active") and bool(RecordsRuntime.is_run_active()),
		"area": _current_area(),
		"depth": int(RunData.depth) if typeof(RunData) == TYPE_OBJECT else 0,
		"run_goal": str(RunData.get_run_goal()) if typeof(RunData) == TYPE_OBJECT and RunData.has_method("get_run_goal") else "",
		"gold": int(RunData.gold) if typeof(RunData) == TYPE_OBJECT else 0,
		"path": RunData.path_history.duplicate() if typeof(RunData) == TYPE_OBJECT else [],
		"technique_count": RunData.acquired_upgrades.size() if typeof(RunData) == TYPE_OBJECT else 0,
		"techniques": RunData.acquired_upgrades.duplicate(true) if typeof(RunData) == TYPE_OBJECT else [],
		"aspect": str(AspectRuntime.get("selected_aspect")) if typeof(AspectRuntime) == TYPE_OBJECT else "",
		"aspect_tier": int(AspectRuntime.get("tier")) if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.get("tier") != null else 0,
		"blood": float(AspectRuntime.get("blood")) if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.get("blood") != null else 0.0,
		"corruption": int(CorruptionRuntime.get_corruption()) if typeof(CorruptionRuntime) == TYPE_OBJECT and CorruptionRuntime.has_method("get_corruption") else 0,
		"prosthetic": str(ProstheticManager.get("equipped_prosthetic_id")) if typeof(ProstheticManager) == TYPE_OBJECT else "",
		"relic": str(RelicRuntime.get("equipped_relic_id")) if typeof(RelicRuntime) == TYPE_OBJECT else "",
		"player": _player_snapshot(player),
		"enemies_killed": int(RunData.enemies_killed) if typeof(RunData) == TYPE_OBJECT else 0,
		"parries": int(RunData.parries_performed) if typeof(RunData) == TYPE_OBJECT else 0,
		"perfect_parries": int(RunData.perfect_parries) if typeof(RunData) == TYPE_OBJECT else 0,
		"damage_taken": int(RunData.damage_taken) if typeof(RunData) == TYPE_OBJECT else 0,
		"combat_rooms_cleared": int(RunData.combat_rooms_cleared) if typeof(RunData) == TYPE_OBJECT else 0,
		"blessings_received": int(RunData.blessings_received) if typeof(RunData) == TYPE_OBJECT else 0,
		"treasures_opened": int(RunData.treasures_opened) if typeof(RunData) == TYPE_OBJECT else 0,
		"items_purchased": int(RunData.items_purchased) if typeof(RunData) == TYPE_OBJECT else 0,
		"resources": current_resources,
		"resource_delta": _resource_delta(run_start_resources, current_resources),
		"heart_bindings_destroyed": int(MetaProgress.get_heart_bindings_destroyed()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_heart_bindings_destroyed") else 0,
		"story_complete": bool(MetaProgress.is_story_complete()) if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("is_story_complete") else false,
	}
	return snapshot


func _active_player() -> Node:
	if typeof(GameFlow) != TYPE_OBJECT:
		return null
	var value: Variant = GameFlow.get("player")
	return value as Node if value is Node and is_instance_valid(value) else null


func _player_snapshot(player: Node) -> Dictionary:
	if player == null or not is_instance_valid(player):
		return {}
	var result := {
		"hp": int(player.get("hp")) if player.get("hp") != null else 0,
		"maxhp": int(player.get("maxhp")) if player.get("maxhp") != null else 0,
		"posture": float(player.get("stagger")) if player.get("stagger") != null else 0.0,
		"posture_max": float(player.get("stagger_max")) if player.get("stagger_max") != null else 0.0,
	}
	var executor_value: Variant = player.get("prosthetic_executor")
	if executor_value is Node and is_instance_valid(executor_value):
		var executor := executor_value as Node
		result["spirit"] = int(executor.call("get_spirit")) if executor.has_method("get_spirit") else int(executor.get("current_spirit"))
		result["spirit_max"] = int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else int(executor.get("max_spirit"))
	return result


func _resource_snapshot() -> Dictionary:
	if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("get_resource_snapshot"):
		var value: Variant = MetaProgress.get_resource_snapshot()
		if value is Dictionary:
			return (value as Dictionary).duplicate(true)
	return {}


func _run_start_resources() -> Dictionary:
	if typeof(RecordsRuntime) != TYPE_OBJECT or not RecordsRuntime.has_method("get_run_resume_record_state"):
		return {}
	var state_value: Variant = RecordsRuntime.get_run_resume_record_state()
	if not (state_value is Dictionary):
		return {}
	var value: Variant = (state_value as Dictionary).get("resource_start", {})
	return (value as Dictionary).duplicate(true) if value is Dictionary else {}


func _elapsed_seconds() -> float:
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("get_current_run_elapsed_seconds"):
		return float(RecordsRuntime.get_current_run_elapsed_seconds())
	return 0.0


func _resource_delta(start: Dictionary, current: Dictionary) -> Dictionary:
	var start_materials: Dictionary = start.get("boss_materials", {}) if start.get("boss_materials", {}) is Dictionary else {}
	var current_materials: Dictionary = current.get("boss_materials", {}) if current.get("boss_materials", {}) is Dictionary else {}
	var material_delta: Dictionary = {}
	for key_value: Variant in current_materials.keys():
		var key := str(key_value)
		material_delta[key] = int(current_materials.get(key, 0)) - int(start_materials.get(key, 0))
	return {
		"mist": int(current.get("mist", 0)) - int(start.get("mist", 0)),
		"scrolls": int(current.get("scrolls", 0)) - int(start.get("scrolls", 0)),
		"boss_materials": material_delta,
	}


# Test-only seams. These expose read-only capture/dedup behavior without mutating any
# canonical authority or requiring a synthetic save/progression setup.
func capture_snapshot_for_playtest(stage: String) -> Dictionary:
	return _build_snapshot(stage)


func emit_checkpoint_for_playtest(stage: String) -> bool:
	return _emit_checkpoint(stage)


func reset_emitted_stages_for_playtest() -> void:
	_emitted_stages.clear()


func get_emitted_stages_for_playtest() -> Array[String]:
	var result: Array[String] = []
	for key_value: Variant in _emitted_stages.keys():
		result.append(str(key_value))
	result.sort()
	return result
