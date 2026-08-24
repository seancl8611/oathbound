extends Node

## Launch-facing save-slot authority.
##
## ENDGAME_POSTGAME_RELEASE.md owns the three-slot front-end requirement. Existing
## progression managers remain the owners of their data; this singleton only chooses
## which slot directory those managers persist into, tracks slot-card metadata, and
## owns safe run-checkpoint metadata.

signal active_slot_changed(slot: int)
signal slot_metadata_changed(slot: int)

const SLOT_COUNT: int = 3
const SLOT_ROOT: String = "user://oathbound_saves"
const INDEX_PATH: String = "user://oathbound_save_index.cfg"
const INDEX_SECTION: String = "save_slots"
const SLOT_META_FILE: String = "slot_meta.cfg"
const SLOT_META_SECTION: String = "meta"
const CHECKPOINT_SECTION: String = "checkpoint"

const LEGACY_FILES: Dictionary = {
	"user://oathbound_meta_progress.cfg": "meta_progress.cfg",
	"user://oathbound_prosthetic_progress.cfg": "prosthetic_progress.cfg",
	"user://oathbound_relic_progress.cfg": "relic_progress.cfg",
}

const MANAGED_SLOT_FILES: Array[String] = [
	"meta_progress.cfg",
	"prosthetic_progress.cfg",
	"relic_progress.cfg",
	SLOT_META_FILE,
]

var active_slot: int = 1
var _gameplay_session_active: bool = false
var _playtime_seconds: float = 0.0
var _playtime_flush_accum: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_load_index()
	_ensure_slot_dir(active_slot)
	_migrate_legacy_slot_one()
	_playtime_seconds = float(_read_slot_meta(active_slot).get("playtime_seconds", 0.0))


func _process(delta: float) -> void:
	if not _gameplay_session_active:
		return
	_playtime_seconds += delta
	_playtime_flush_accum += delta
	if _playtime_flush_accum >= 15.0:
		_playtime_flush_accum = 0.0
		_flush_slot_meta()


func get_active_slot() -> int:
	return active_slot


func get_slot_file(file_name: String, slot_override: int = 0) -> String:
	var slot := active_slot if slot_override <= 0 else clampi(slot_override, 1, SLOT_COUNT)
	_ensure_slot_dir(slot)
	return "%s/slot_%d/%s" % [SLOT_ROOT, slot, file_name]


func select_slot(slot: int, reload_managers: bool = true) -> bool:
	if slot < 1 or slot > SLOT_COUNT:
		return false
	if slot == active_slot:
		if reload_managers:
			reload_persistent_managers()
		return true
	_flush_slot_meta()
	active_slot = slot
	_ensure_slot_dir(active_slot)
	if active_slot == 1:
		_migrate_legacy_slot_one()
	_playtime_seconds = float(_read_slot_meta(active_slot).get("playtime_seconds", 0.0))
	_playtime_flush_accum = 0.0
	_save_index()
	if reload_managers:
		reload_persistent_managers()
	active_slot_changed.emit(active_slot)
	return true


func create_new_slot(slot: int) -> bool:
	if slot < 1 or slot > SLOT_COUNT:
		return false
	_delete_slot_files(slot)
	_ensure_slot_dir(slot)
	var file := ConfigFile.new()
	file.set_value(SLOT_META_SECTION, "created_unix", int(Time.get_unix_time_from_system()))
	file.set_value(SLOT_META_SECTION, "last_played_unix", int(Time.get_unix_time_from_system()))
	file.set_value(SLOT_META_SECTION, "playtime_seconds", 0.0)
	file.set_value(SLOT_META_SECTION, "has_active_run", false)
	var err := file.save(get_slot_file(SLOT_META_FILE, slot))
	if err != OK:
		push_warning("[SaveSlots] Could not initialize slot %d: %s" % [slot, error_string(err)])
		return false
	select_slot(slot, true)
	_playtime_seconds = 0.0
	slot_metadata_changed.emit(slot)
	return true


func delete_slot(slot: int) -> bool:
	if slot < 1 or slot > SLOT_COUNT:
		return false
	if slot == active_slot:
		_gameplay_session_active = false
	_delete_slot_files(slot)
	if slot == active_slot:
		_playtime_seconds = 0.0
		reload_persistent_managers()
	slot_metadata_changed.emit(slot)
	return true


func slot_exists(slot: int) -> bool:
	if slot < 1 or slot > SLOT_COUNT:
		return false
	for file_name: String in MANAGED_SLOT_FILES:
		if FileAccess.file_exists(get_slot_file(file_name, slot)):
			return true
	return false


func get_slot_metadata(slot: int) -> Dictionary:
	if slot < 1 or slot > SLOT_COUNT:
		return {}
	var result: Dictionary = {
		"slot": slot,
		"exists": slot_exists(slot),
		"playtime_seconds": 0.0,
		"last_played_unix": 0,
		"returning_blood_awakened": false,
		"heart_bindings_destroyed": 0,
		"story_complete": false,
		"completion_percent": 0,
		"has_active_run": false,
		"state_label": "Empty Slot",
	}
	if not bool(result["exists"]):
		return result

	var slot_meta := _read_slot_meta(slot)
	result["playtime_seconds"] = float(slot_meta.get("playtime_seconds", 0.0))
	result["last_played_unix"] = int(slot_meta.get("last_played_unix", 0))
	result["has_active_run"] = bool(slot_meta.get("has_active_run", false))

	var meta := ConfigFile.new()
	if meta.load(get_slot_file("meta_progress.cfg", slot)) == OK:
		var awakened := bool(meta.get_value("progress", "returning_blood_awakened", false))
		var bindings := clampi(int(meta.get_value("progress", "heart_bindings_destroyed", 0)), 0, 6)
		var story_complete := bool(meta.get_value("progress", "story_complete", false))
		var flags_value: Variant = meta.get_value("progress", "progression_flags", {})
		var flags: Dictionary = flags_value if flags_value is Dictionary else {}
		var completion := clampi(int(flags.get("achievement_metric/completion_percent", 0)), 0, 100)
		result["returning_blood_awakened"] = awakened
		result["heart_bindings_destroyed"] = bindings
		result["story_complete"] = story_complete
		result["completion_percent"] = completion
		if story_complete:
			result["state_label"] = "Story Complete"
		elif bindings > 0:
			result["state_label"] = "%d / 6 Heart Bindings" % bindings
		elif awakened:
			result["state_label"] = "Returning Blood Awakened"
		else:
			result["state_label"] = "First Attempt"
	else:
		result["state_label"] = "New Game"
	return result


func begin_gameplay_session() -> void:
	_gameplay_session_active = true
	var meta := _read_slot_meta(active_slot)
	if not meta.has("created_unix"):
		meta["created_unix"] = int(Time.get_unix_time_from_system())
	_write_slot_meta(active_slot, meta)


func end_gameplay_session() -> void:
	_gameplay_session_active = false
	_flush_slot_meta()


func save_safe_checkpoint(checkpoint: Dictionary) -> bool:
	var file := ConfigFile.new()
	var path := get_slot_file(SLOT_META_FILE)
	file.load(path)
	for key: Variant in checkpoint.keys():
		file.set_value(CHECKPOINT_SECTION, str(key), checkpoint[key])
	file.set_value(SLOT_META_SECTION, "has_active_run", true)
	file.set_value(SLOT_META_SECTION, "playtime_seconds", _playtime_seconds)
	file.set_value(SLOT_META_SECTION, "last_played_unix", int(Time.get_unix_time_from_system()))
	var err := file.save(path)
	if err != OK:
		push_warning("[SaveSlots] Could not save safe checkpoint: %s" % error_string(err))
		return false
	slot_metadata_changed.emit(active_slot)
	return true


func load_safe_checkpoint(slot: int = 0) -> Dictionary:
	var resolved := active_slot if slot <= 0 else clampi(slot, 1, SLOT_COUNT)
	var file := ConfigFile.new()
	if file.load(get_slot_file(SLOT_META_FILE, resolved)) != OK:
		return {}
	if not bool(file.get_value(SLOT_META_SECTION, "has_active_run", false)):
		return {}
	var data: Dictionary = {}
	for key: String in file.get_section_keys(CHECKPOINT_SECTION):
		data[key] = file.get_value(CHECKPOINT_SECTION, key)
	return data


func clear_safe_checkpoint() -> void:
	var file := ConfigFile.new()
	var path := get_slot_file(SLOT_META_FILE)
	file.load(path)
	if file.has_section(CHECKPOINT_SECTION):
		file.erase_section(CHECKPOINT_SECTION)
	file.set_value(SLOT_META_SECTION, "has_active_run", false)
	file.set_value(SLOT_META_SECTION, "playtime_seconds", _playtime_seconds)
	file.set_value(SLOT_META_SECTION, "last_played_unix", int(Time.get_unix_time_from_system()))
	file.save(path)
	slot_metadata_changed.emit(active_slot)


func reload_persistent_managers() -> void:
	for autoload_name: String in ["MetaProgress", "ProstheticManager", "RelicRuntime"]:
		var manager := get_node_or_null("/root/%s" % autoload_name)
		if manager != null and manager.has_method("reload_from_active_slot"):
			manager.call("reload_from_active_slot")
	var run_data := get_node_or_null("/root/RunData")
	if run_data != null and run_data.has_method("sync_persistent_resources"):
		run_data.call("sync_persistent_resources")
	var achievements := get_node_or_null("/root/AchievementRuntime")
	if achievements != null and achievements.has_method("evaluate"):
		achievements.call("evaluate")


func _read_slot_meta(slot: int) -> Dictionary:
	var file := ConfigFile.new()
	if file.load(get_slot_file(SLOT_META_FILE, slot)) != OK:
		return {}
	var result: Dictionary = {}
	for key: String in file.get_section_keys(SLOT_META_SECTION):
		result[key] = file.get_value(SLOT_META_SECTION, key)
	return result


func _write_slot_meta(slot: int, values: Dictionary) -> void:
	var file := ConfigFile.new()
	var path := get_slot_file(SLOT_META_FILE, slot)
	file.load(path)
	for key: Variant in values.keys():
		file.set_value(SLOT_META_SECTION, str(key), values[key])
	file.save(path)


func _flush_slot_meta() -> void:
	if active_slot < 1 or active_slot > SLOT_COUNT:
		return
	var values := _read_slot_meta(active_slot)
	if values.is_empty() and not slot_exists(active_slot):
		return
	values["playtime_seconds"] = _playtime_seconds
	values["last_played_unix"] = int(Time.get_unix_time_from_system())
	_write_slot_meta(active_slot, values)
	slot_metadata_changed.emit(active_slot)


func _load_index() -> void:
	var file := ConfigFile.new()
	if file.load(INDEX_PATH) == OK:
		active_slot = clampi(int(file.get_value(INDEX_SECTION, "active_slot", 1)), 1, SLOT_COUNT)


func _save_index() -> void:
	var file := ConfigFile.new()
	file.set_value(INDEX_SECTION, "active_slot", active_slot)
	file.save(INDEX_PATH)


func _ensure_slot_dir(slot: int) -> void:
	var absolute := ProjectSettings.globalize_path("%s/slot_%d" % [SLOT_ROOT, slot])
	DirAccess.make_dir_recursive_absolute(absolute)


func _delete_slot_files(slot: int) -> void:
	for file_name: String in MANAGED_SLOT_FILES:
		var path := get_slot_file(file_name, slot)
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _migrate_legacy_slot_one() -> void:
	if active_slot != 1:
		return
	for legacy_path: String in LEGACY_FILES.keys():
		var new_name: String = str(LEGACY_FILES[legacy_path])
		var target := get_slot_file(new_name, 1)
		if FileAccess.file_exists(target) or not FileAccess.file_exists(legacy_path):
			continue
		var legacy := ConfigFile.new()
		if legacy.load(legacy_path) != OK:
			continue
		var err := legacy.save(target)
		if err == OK:
			print("[SaveSlots] Migrated legacy progress into slot 1: %s" % new_name)
