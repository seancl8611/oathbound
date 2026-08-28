extends "res://Core/Prosthetics/OathboundProstheticManager.gd"

## Persistent Forge ownership layer for the current eight-Prosthetic roster.
## The underlying manager remains combat/upgrade authority; this layer owns campaign
## unlock cadence and durable unlock/equip/upgrade state.

const LEGACY_SAVE_PATH := "user://oathbound_prosthetic_progress.cfg"
const SLOT_FILE := "prosthetic_progress.cfg"
const SAVE_SECTION := "prosthetics"

const FIRST_RETURN_UNLOCKS: Array[String] = ["thunder_rod"]
const KEEPER_UNLOCKS: Array[String] = ["smoke_gourd", "fang_harpoon"]
const TWIN_UNLOCKS: Array[String] = ["mirror_umbrella", "flame_vent"]
const SHOGUN_UNLOCKS: Array[String] = ["mist_raven", "bloodletting_gourd"]

var _loading_progress := false
var _temporary_loadout_sandbox_depth: int = 0
var _campaign_sync_deferred_for_sandbox: bool = false


func _ready() -> void:
	super._ready()
	_load_current_progress()
	_ensure_starting_loadout()
	_synchronize_campaign_unlocks()
	if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_signal("progression_changed"):
		var cb := Callable(self, "_on_campaign_progression_changed")
		if not MetaProgress.is_connected("progression_changed", cb):
			MetaProgress.connect("progression_changed", cb)
	if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_signal("returning_blood_awakened_changed"):
		var awaken_cb := Callable(self, "_on_returning_blood_changed")
		if not MetaProgress.is_connected("returning_blood_awakened_changed", awaken_cb):
			MetaProgress.connect("returning_blood_awakened_changed", awaken_cb)
	print("[OathboundPersistentProstheticManager] durable Forge progression | unlocked=%d" % unlocked_prosthetics.size())


func _save_path() -> String:
	if typeof(SaveSlots) == TYPE_OBJECT and SaveSlots.has_method("get_slot_file"):
		return str(SaveSlots.call("get_slot_file", SLOT_FILE))
	return LEGACY_SAVE_PATH


func reload_from_active_slot() -> void:
	_loading_progress = true
	unlocked_prosthetics.clear()
	equipped_prosthetic_id = ""
	purchased_upgrades.clear()
	socketed_relics.clear()
	unlocked_relics.clear()
	_loading_progress = false
	_load_current_progress()
	_ensure_starting_loadout()
	_synchronize_campaign_unlocks()
	prosthetic_equipped.emit(equipped_prosthetic_id)


func flush_save() -> void:
	_save_current_progress()


func begin_temporary_loadout_sandbox() -> void:
	_temporary_loadout_sandbox_depth += 1


func end_temporary_loadout_sandbox() -> void:
	_temporary_loadout_sandbox_depth = maxi(0, _temporary_loadout_sandbox_depth - 1)
	if _temporary_loadout_sandbox_depth == 0 and _campaign_sync_deferred_for_sandbox:
		# BloodCavernTrialLoadoutSandbox restores its exact pre-trial Prosthetic snapshot
		# before releasing this suppression depth. Replaying the campaign sync here means
		# legitimate progression earned during the temporary lifetime is applied after the
		# restore boundary instead of being mutated early and then erased by restoration.
		_campaign_sync_deferred_for_sandbox = false
		_synchronize_campaign_unlocks()


func is_temporary_loadout_sandbox_active() -> bool:
	return _temporary_loadout_sandbox_depth > 0


func set_temporary_equipped_prosthetic(prosthetic_id: String) -> bool:
	if not is_temporary_loadout_sandbox_active():
		return false
	if not prosthetic_id.is_empty() and not _registry.has(prosthetic_id):
		return false
	equipped_prosthetic_id = prosthetic_id
	prosthetic_equipped.emit(prosthetic_id)
	return true


func _on_campaign_progression_changed() -> void:
	_synchronize_campaign_unlocks()


func _on_returning_blood_changed(_awakened: bool) -> void:
	_synchronize_campaign_unlocks()


func _ensure_starting_loadout() -> void:
	unlocked_prosthetics[STARTING_PROSTHETIC] = true
	if equipped_prosthetic_id.is_empty() or not unlocked_prosthetics.has(equipped_prosthetic_id):
		equipped_prosthetic_id = STARTING_PROSTHETIC


func _synchronize_campaign_unlocks() -> void:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return
	if is_temporary_loadout_sandbox_active():
		_campaign_sync_deferred_for_sandbox = true
		return
	var changed := false
	if MetaProgress.is_returning_blood_awakened():
		changed = _unlock_set(FIRST_RETURN_UNLOCKS) or changed
	if MetaProgress.has_cleared_boss(1):
		changed = _unlock_set(KEEPER_UNLOCKS) or changed
	if MetaProgress.has_cleared_boss(2):
		changed = _unlock_set(TWIN_UNLOCKS) or changed
	if MetaProgress.has_cleared_boss(3):
		changed = _unlock_set(SHOGUN_UNLOCKS) or changed
	_ensure_starting_loadout()
	if changed:
		_save_current_progress()


func _unlock_set(ids: Array[String]) -> bool:
	var changed := false
	for prosthetic_id in ids:
		if not unlocked_prosthetics.has(prosthetic_id) and _registry.has(prosthetic_id):
			unlocked_prosthetics[prosthetic_id] = true
			prosthetic_unlocked.emit(prosthetic_id)
			changed = true
	return changed


func unlock_prosthetic(prosthetic_id: String) -> bool:
	# A Blood Cavern fixed-loadout lifetime is explicitly non-durable. Block the
	# production Forge mutation surface itself, not only its file write, so accidental
	# calls cannot emit permanent-unlock semantics while the sandbox later restores the
	# in-memory dictionary.
	if is_temporary_loadout_sandbox_active():
		return false
	var changed := super.unlock_prosthetic(prosthetic_id)
	if changed and not _loading_progress:
		_save_current_progress()
	return changed


func equip_prosthetic(prosthetic_id: String) -> bool:
	if is_temporary_loadout_sandbox_active():
		return false
	var changed := super.equip_prosthetic(prosthetic_id)
	if changed and not _loading_progress:
		_save_current_progress()
	return changed


func unequip_prosthetic() -> void:
	if is_temporary_loadout_sandbox_active():
		return
	super.unequip_prosthetic()
	if not _loading_progress:
		_save_current_progress()


func purchase_upgrade(prosthetic_id: String, upgrade_id: String) -> bool:
	# The base purchase path spends permanent Scrolls before this adapter saves its
	# Prosthetic state. Returning before super is therefore required for true trial
	# isolation; save suppression alone would still allow permanent currency loss.
	if is_temporary_loadout_sandbox_active():
		return false
	var changed := super.purchase_upgrade(prosthetic_id, upgrade_id)
	if changed and not _loading_progress:
		_save_current_progress()
	return changed


func _save_current_progress() -> void:
	if is_temporary_loadout_sandbox_active():
		return
	var file := ConfigFile.new()
	file.set_value(SAVE_SECTION, "state", get_save_data())
	var err := file.save(_save_path())
	if err != OK:
		push_warning("[OathboundPersistentProstheticManager] Could not save Forge progression: %s" % error_string(err))


func _load_current_progress() -> void:
	var file := ConfigFile.new()
	if file.load(_save_path()) != OK:
		return
	var state_value: Variant = file.get_value(SAVE_SECTION, "state", {})
	if not (state_value is Dictionary):
		return
	_loading_progress = true
	load_save_data(state_value as Dictionary)
	_loading_progress = false
	socketed_relics.clear()
	unlocked_relics.clear()
	for prosthetic_id in unlocked_prosthetics.keys().duplicate():
		if prosthetic_id not in CURRENT_IDS:
			unlocked_prosthetics.erase(prosthetic_id)
	for prosthetic_id in purchased_upgrades.keys().duplicate():
		if prosthetic_id not in CURRENT_IDS:
			purchased_upgrades.erase(prosthetic_id)
	if equipped_prosthetic_id not in CURRENT_IDS:
		equipped_prosthetic_id = STARTING_PROSTHETIC
