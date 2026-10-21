extends Node

## Debug-only frame-time probe for real playtests.
##
## The goal is to identify expensive room transitions or sustained runtime regressions
## without using per-frame scene-tree scans or disk flushes that would distort the sample.
## Results are written through the existing batched CombatTelemetry stream.

const WINDOW_SECONDS: float = 1.0
const HITCH_MS: float = 33.34
const BAD_HITCH_MS: float = 50.0
const SEVERE_HITCH_MS: float = 100.0
const HITCH_EVENT_COOLDOWN_MS: int = 250

var _window_elapsed: float = 0.0
var _frame_count: int = 0
var _frame_ms_sum: float = 0.0
var _worst_frame_ms: float = 0.0
var _over_33: int = 0
var _over_50: int = 0
var _over_100: int = 0
var _last_hitch_event_ms: int = -100000


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not OS.is_debug_build():
		set_process(false)
		return
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("performance_probe_started", {
			"window_seconds": WINDOW_SECONDS,
			"hitch_ms": HITCH_MS,
		})


func _process(delta: float) -> void:
	var frame_ms := maxf(0.0, delta * 1000.0)
	_window_elapsed += delta
	_frame_count += 1
	_frame_ms_sum += frame_ms
	_worst_frame_ms = maxf(_worst_frame_ms, frame_ms)
	if frame_ms >= HITCH_MS:
		_over_33 += 1
	if frame_ms >= BAD_HITCH_MS:
		_over_50 += 1
	if frame_ms >= SEVERE_HITCH_MS:
		_over_100 += 1
	_record_hitch_if_needed(frame_ms)

	if _window_elapsed >= WINDOW_SECONDS:
		_record_window()
		_reset_window()


func _record_hitch_if_needed(frame_ms: float) -> void:
	if frame_ms < BAD_HITCH_MS:
		return
	var now_ms := Time.get_ticks_msec()
	if now_ms - _last_hitch_event_ms < HITCH_EVENT_COOLDOWN_MS:
		return
	_last_hitch_event_ms = now_ms
	if CombatTelemetry == null or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event("performance_hitch", {
		"frame_ms": snappedf(frame_ms, 0.01),
		"fps": Engine.get_frames_per_second(),
		"room": _current_room_name(),
		"players": get_tree().get_nodes_in_group("player").size(),
		"enemies": get_tree().get_nodes_in_group("enemy").size(),
	})


func _record_window() -> void:
	if _frame_count <= 0 or CombatTelemetry == null or not CombatTelemetry.is_capturing():
		return
	var avg_ms := _frame_ms_sum / float(_frame_count)
	CombatTelemetry.record_event("performance_window", {
		"fps": Engine.get_frames_per_second(),
		"avg_frame_ms": snappedf(avg_ms, 0.01),
		"worst_frame_ms": snappedf(_worst_frame_ms, 0.01),
		"frames": _frame_count,
		"over_33ms": _over_33,
		"over_50ms": _over_50,
		"over_100ms": _over_100,
		"room": _current_room_name(),
		"players": get_tree().get_nodes_in_group("player").size(),
		"enemies": get_tree().get_nodes_in_group("enemy").size(),
		"object_count": int(Performance.get_monitor(Performance.OBJECT_COUNT)),
		"node_count": int(Performance.get_monitor(Performance.OBJECT_NODE_COUNT)),
		"static_memory_mb": snappedf(float(Performance.get_monitor(Performance.MEMORY_STATIC)) / 1048576.0, 0.01),
	})


func _reset_window() -> void:
	_window_elapsed = 0.0
	_frame_count = 0
	_frame_ms_sum = 0.0
	_worst_frame_ms = 0.0
	_over_33 = 0
	_over_50 = 0
	_over_100 = 0


func _current_room_name() -> String:
	var run_scene := get_parent()
	if run_scene == null:
		return ""
	var container := run_scene.get_node_or_null("RoomContainer")
	if container == null or container.get_child_count() == 0:
		return ""
	var room := container.get_child(0)
	return str(room.name) if room != null else ""
