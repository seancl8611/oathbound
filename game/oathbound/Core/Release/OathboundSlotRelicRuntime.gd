extends "res://Core/Relics/OathboundRelicRuntime.gd"

## Save-slot persistence adapter for the current Relic runtime. Relic rules/effects stay
## in OathboundRelicRuntime; this layer only redirects durable collection/mastery data.
## Blood Cavern fixed-loadout sandboxes may stage a Relic without changing the slot file,
## accruing permanent mastery, or invoking durable collection/equip mutations.

const LEGACY_RELIC_SAVE_PATH: String = "user://oathbound_relic_progress.cfg"
const RELIC_SLOT_FILE: String = "relic_progress.cfg"

var _temporary_loadout_sandbox_depth: int = 0


func _relic_save_path() -> String:
	if typeof(SaveSlots) == TYPE_OBJECT and SaveSlots.has_method("get_slot_file"):
		return str(SaveSlots.call("get_slot_file", RELIC_SLOT_FILE))
	return LEGACY_RELIC_SAVE_PATH


func reload_from_active_slot() -> void:
	_load_progress()
	collection_changed.emit()
	equipped_changed.emit(equipped_relic_id)


func flush_save() -> void:
	_save_progress()


func begin_temporary_loadout_sandbox() -> void:
	_temporary_loadout_sandbox_depth += 1


func end_temporary_loadout_sandbox() -> void:
	_temporary_loadout_sandbox_depth = maxi(0, _temporary_loadout_sandbox_depth - 1)


func is_temporary_loadout_sandbox_active() -> bool:
	return _temporary_loadout_sandbox_depth > 0


func set_temporary_equipped_relic(relic_id: String) -> bool:
	if not is_temporary_loadout_sandbox_active():
		return false
	if not relic_id.is_empty() and not CATALOG.has(relic_id):
		return false
	equipped_relic_id = relic_id
	equipped_changed.emit(relic_id)
	return true


func discover_relic(relic_id: String, equip_now: bool = false) -> bool:
	# Trial fixed-loadout state must never masquerade as a collection unlock. Block the
	# durable mutation surface itself so collection/discovery signals cannot escape and
	# trigger other permanent-progression consumers before the sandbox restores memory.
	if is_temporary_loadout_sandbox_active():
		return false
	return super.discover_relic(relic_id, equip_now)


func equip_relic(relic_id: String, context: String = EQUIP_CONTEXT_FORGE) -> bool:
	if is_temporary_loadout_sandbox_active():
		return false
	return super.equip_relic(relic_id, context)


func record_eligible_kill(enemy: Node = null) -> void:
	if is_temporary_loadout_sandbox_active():
		return
	super.record_eligible_kill(enemy)


func _save_progress() -> void:
	if is_temporary_loadout_sandbox_active():
		return
	var file := ConfigFile.new()
	file.set_value(SAVE_SECTION, "version", RUNTIME_VERSION)
	file.set_value(SAVE_SECTION, "unlocked_relics", unlocked_relics)
	file.set_value(SAVE_SECTION, "mastery_kills", mastery_kills)
	file.set_value(SAVE_SECTION, "equipped_relic_id", equipped_relic_id)
	var err: Error = file.save(_relic_save_path())
	if err != OK:
		push_warning("[OathboundSlotRelicRuntime] Could not save Relic progress: %s" % error_string(err))


func _load_progress() -> void:
	unlocked_relics.clear()
	mastery_kills.clear()
	equipped_relic_id = ""
	var file := ConfigFile.new()
	if file.load(_relic_save_path()) != OK:
		return
	var unlocked_value: Variant = file.get_value(SAVE_SECTION, "unlocked_relics", {})
	if unlocked_value is Dictionary:
		for relic_id_value: Variant in (unlocked_value as Dictionary).keys():
			var relic_id: String = str(relic_id_value)
			if CATALOG.has(relic_id) and bool((unlocked_value as Dictionary).get(relic_id_value, false)):
				unlocked_relics[relic_id] = true
	var mastery_value: Variant = file.get_value(SAVE_SECTION, "mastery_kills", {})
	if mastery_value is Dictionary:
		for relic_id: String in CATALOG.IDS:
			mastery_kills[relic_id] = maxi(0, int((mastery_value as Dictionary).get(relic_id, 0)))
	var equipped_value: String = str(file.get_value(SAVE_SECTION, "equipped_relic_id", ""))
	if equipped_value.is_empty() or unlocked_relics.has(equipped_value):
		equipped_relic_id = equipped_value
