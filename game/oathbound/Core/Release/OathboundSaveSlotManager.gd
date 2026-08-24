extends Node

## Three-slot release save shell around the already-proven MetaProgress persistence file.
## MetaProgress remains the campaign authority. This manager swaps/mirrors that working
## file per selected slot and owns only slot metadata such as playtime/last played.

signal active_slot_changed(slot: int)
signal slot_metadata_changed(slot: int)

const SLOT_COUNT := 3
const ACTIVE_PROGRESS_PATH := "user://oathbound_meta_progress.cfg"
const SAVE_DIR := "user://save_slots"
const SHELL_PATH := "user://oathbound_shell.cfg"

var active_slot := 0
var _session_playtime := 0.0
var _session_flush := 0.0
var _session_active := false


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(SAVE_DIR))
	_connect_progress_signals()
	set_process(true)


func _process(delta: float) -> void:
	if not _session_active or active_slot < 1:
		return
	_session_playtime += delta
	_session_flush += delta
	if _session_flush >= 15.0:
		_flush_metadata()
		_session_flush = 0.0


func _exit_tree() -> void:
	if _session_active:
		_mirror_active_progress()
		_flush_metadata()


func has_slot(slot: int) -> bool:
	return _valid_slot(slot) and FileAccess.file_exists(_slot_progress_path(slot))


func select_slot(slot: int, create_if_missing: bool = false) -> bool:
	if not _valid_slot(slot):
		return false
	if not has_slot(slot) and not create_if_missing:
		return false
	if _session_active and active_slot != slot:
		_mirror_active_progress()
		_flush_metadata()
	active_slot = slot
	_write_last_active_slot(slot)
	if has_slot(slot):
		if not _copy_file(_slot_progress_path(slot), ACTIVE_PROGRESS_PATH):
			return false
		_reset_meta_defaults()
		MetaProgress.call("_load_progress")
	else:
		_reset_meta_defaults()
		MetaProgress.call("_save_progress")
		_mirror_active_progress()
	_reload_run_mirrors()
	_session_playtime = float(_read_slot_meta(slot).get("playtime_seconds", 0.0))
	_session_flush = 0.0
	_session_active = true
	_emit_meta_refresh()
	active_slot_changed.emit(slot)
	return true


func create_new_slot(slot: int) -> bool:
	if not _valid_slot(slot):
		return false
	if has_slot(slot):
		delete_slot(slot)
	return select_slot(slot, true)


func delete_slot(slot: int) -> bool:
	if not _valid_slot(slot):
		return false
	var removed_any := false
	for path in [_slot_progress_path(slot), _slot_meta_path(slot)]:
		if FileAccess.file_exists(path):
			var err := DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
			removed_any = removed_any or err == OK
	if active_slot == slot:
		_session_active = false
		active_slot = 0
		_session_playtime = 0.0
	slot_metadata_changed.emit(slot)
	return removed_any


func get_slot_card(slot: int) -> Dictionary:
	if not _valid_slot(slot):
		return {}
	if not has_slot(slot):
		return {"slot": slot, "exists": false}
	var progress := ConfigFile.new()
	progress.load(_slot_progress_path(slot))
	var meta := _read_slot_meta(slot)
	var bindings := clampi(int(progress.get_value("progress", "heart_bindings_destroyed", 0)), 0, 6)
	var story := bool(progress.get_value("progress", "story_complete", false))
	var flags: Variant = progress.get_value("progress", "progression_flags", {})
	var completion := 0
	if flags is Dictionary:
		completion = clampi(int((flags as Dictionary).get("achievement_metric/completion_percent", 0)), 0, 100)
	return {
		"slot": slot,
		"exists": true,
		"playtime_seconds": float(meta.get("playtime_seconds", 0.0)),
		"last_played_unix": int(meta.get("last_played_unix", 0)),
		"returning_blood_awakened": bool(progress.get_value("progress", "returning_blood_awakened", false)),
		"bindings_destroyed": bindings,
		"bindings_remaining": maxi(0, 6 - bindings),
		"story_complete": story,
		"completion_percent": completion,
		"mist": maxi(0, int(progress.get_value("progress", "mist", 0))),
		"scrolls": maxi(0, int(progress.get_value("progress", "scrolls", 0))),
	}


func get_last_active_slot() -> int:
	var file := ConfigFile.new()
	if file.load(SHELL_PATH) != OK:
		return 0
	var slot := int(file.get_value("shell", "last_active_slot", 0))
	return slot if _valid_slot(slot) else 0


func get_active_playtime_seconds() -> float:
	return _session_playtime if _session_active else 0.0


func format_playtime(seconds: float) -> String:
	var total := maxi(0, int(seconds))
	var hours := total / 3600
	var minutes := (total % 3600) / 60
	return "%02d:%02d" % [hours, minutes]


func _connect_progress_signals() -> void:
	for signal_name in ["persistent_resources_changed", "progression_changed", "campaign_changed"]:
		if MetaProgress.has_signal(signal_name):
			var cb := Callable(self, "_on_meta_progress_changed")
			if not MetaProgress.is_connected(signal_name, cb):
				MetaProgress.connect(signal_name, cb)


func _on_meta_progress_changed() -> void:
	if not _session_active or active_slot < 1:
		return
	_mirror_active_progress()
	if typeof(CompletionRuntime) == TYPE_OBJECT and CompletionRuntime.has_method("refresh"):
		CompletionRuntime.call_deferred("refresh")


func _mirror_active_progress() -> void:
	if active_slot < 1 or not FileAccess.file_exists(ACTIVE_PROGRESS_PATH):
		return
	if _copy_file(ACTIVE_PROGRESS_PATH, _slot_progress_path(active_slot)):
		slot_metadata_changed.emit(active_slot)


func _flush_metadata() -> void:
	if active_slot < 1:
		return
	var file := ConfigFile.new()
	file.set_value("slot", "playtime_seconds", _session_playtime)
	file.set_value("slot", "last_played_unix", int(Time.get_unix_time_from_system()))
	file.save(_slot_meta_path(active_slot))
	slot_metadata_changed.emit(active_slot)


func _read_slot_meta(slot: int) -> Dictionary:
	var file := ConfigFile.new()
	if file.load(_slot_meta_path(slot)) != OK:
		return {}
	return {
		"playtime_seconds": float(file.get_value("slot", "playtime_seconds", 0.0)),
		"last_played_unix": int(file.get_value("slot", "last_played_unix", 0)),
	}


func _write_last_active_slot(slot: int) -> void:
	var file := ConfigFile.new()
	if FileAccess.file_exists(SHELL_PATH):
		file.load(SHELL_PATH)
	file.set_value("shell", "last_active_slot", slot)
	file.save(SHELL_PATH)


func _copy_file(source: String, destination: String) -> bool:
	if not FileAccess.file_exists(source):
		return false
	var input := FileAccess.open(source, FileAccess.READ)
	if input == null:
		return false
	var bytes := input.get_buffer(input.get_length())
	input.close()
	var output := FileAccess.open(destination, FileAccess.WRITE)
	if output == null:
		return false
	output.store_buffer(bytes)
	output.close()
	return true


func _reset_meta_defaults() -> void:
	MetaProgress.areas_unlocked.assign([1])
	MetaProgress.boss_clears = {1: false, 2: false, 3: false}
	MetaProgress.boss_defeat_counts = {1: 0, 2: 0, 3: 0}
	MetaProgress.trainer_key_owned = false
	MetaProgress.returning_blood_awakened = false
	MetaProgress.heart_bindings_destroyed = 0
	MetaProgress.story_complete = false
	MetaProgress.standard_expedition_clears = 0
	MetaProgress.heart_suppression_clears = 0
	MetaProgress.mist = 0
	MetaProgress.scrolls = 0
	MetaProgress.boss_materials = {"keeper": 0, "twin_maws": 0, "eclipse_shogun": 0}
	MetaProgress.purchased_progression_nodes = {}
	MetaProgress.progression_flags = {}
	MetaProgress.blood_cavern_trial_completions = {}


func _emit_meta_refresh() -> void:
	MetaProgress.persistent_resources_changed.emit()
	MetaProgress.progression_changed.emit()
	MetaProgress.campaign_changed.emit()
	MetaProgress.returning_blood_awakened_changed.emit(MetaProgress.returning_blood_awakened)


func _reload_run_mirrors() -> void:
	if typeof(RunData) == TYPE_OBJECT and RunData.has_method("sync_persistent_resources"):
		RunData.sync_persistent_resources()


func _slot_progress_path(slot: int) -> String:
	return "%s/slot_%d_progress.cfg" % [SAVE_DIR, slot]


func _slot_meta_path(slot: int) -> String:
	return "%s/slot_%d_meta.cfg" % [SAVE_DIR, slot]


func _valid_slot(slot: int) -> bool:
	return slot >= 1 and slot <= SLOT_COUNT
