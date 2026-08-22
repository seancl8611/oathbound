extends Node

## Persistent campaign state and banked progression resources.
## ITEMS_AND_REWARDS.md owns the resource model: Mist and Scrolls are saved when
## earned, and each regional boss has its own material instead of a generic emblem.

signal persistent_resources_changed
signal returning_blood_awakened_changed(awakened: bool)

const SAVE_PATH := "user://oathbound_meta_progress.cfg"
const SAVE_SECTION := "progress"

const BOSS_MATERIAL_KEEPER := "keeper"
const BOSS_MATERIAL_TWIN_MAWS := "twin_maws"
const BOSS_MATERIAL_ECLIPSE_SHOGUN := "eclipse_shogun"

var areas_unlocked: Array[int] = [1]
var boss_clears := {1: false, 2: false, 3: false}
var trainer_key_owned: bool = false
var returning_blood_awakened: bool = false

var mist: int = 0
var scrolls: int = 0
var boss_materials: Dictionary = {
	BOSS_MATERIAL_KEEPER: 0,
	BOSS_MATERIAL_TWIN_MAWS: 0,
	BOSS_MATERIAL_ECLIPSE_SHOGUN: 0,
}


func _ready() -> void:
	_load_progress()


func unlock_area(id: int) -> void:
	if not areas_unlocked.has(id):
		areas_unlocked.append(id)
		_save_progress()


func mark_boss_clear(id: int) -> void:
	boss_clears[id] = true
	_save_progress()


func has_cleared_boss(id: int) -> bool:
	return bool(boss_clears.get(id, false))


func awaken_returning_blood() -> bool:
	if returning_blood_awakened:
		return false
	returning_blood_awakened = true
	_save_progress()
	returning_blood_awakened_changed.emit(true)
	return true


func is_returning_blood_awakened() -> bool:
	return returning_blood_awakened


func add_mist(amount: int) -> void:
	if amount <= 0:
		return
	mist += amount
	_commit_persistent_change()


func spend_mist(amount: int) -> bool:
	if amount <= 0:
		return true
	if mist < amount:
		return false
	mist -= amount
	_commit_persistent_change()
	return true


func add_scrolls(amount: int) -> void:
	if amount <= 0:
		return
	scrolls += amount
	_commit_persistent_change()


func spend_scrolls(amount: int) -> bool:
	if amount <= 0:
		return true
	if scrolls < amount:
		return false
	scrolls -= amount
	_commit_persistent_change()
	return true


func add_boss_material(material_key: String, amount: int = 1) -> void:
	if amount <= 0 or not boss_materials.has(material_key):
		return
	boss_materials[material_key] = int(boss_materials.get(material_key, 0)) + amount
	_commit_persistent_change()


func get_boss_material(material_key: String) -> int:
	return int(boss_materials.get(material_key, 0))


func has_boss_material(material_key: String, amount: int = 1) -> bool:
	if amount <= 0:
		return true
	return get_boss_material(material_key) >= amount


func spend_boss_material(material_key: String, amount: int = 1) -> bool:
	if amount <= 0:
		return true
	if not boss_materials.has(material_key) or not has_boss_material(material_key, amount):
		return false
	boss_materials[material_key] = get_boss_material(material_key) - amount
	_commit_persistent_change()
	return true


func get_resource_snapshot() -> Dictionary:
	return {
		"mist": mist,
		"scrolls": scrolls,
		"boss_materials": boss_materials.duplicate(true),
		"returning_blood_awakened": returning_blood_awakened,
	}


func _commit_persistent_change() -> void:
	_save_progress()
	persistent_resources_changed.emit()


func _save_progress() -> void:
	var file := ConfigFile.new()
	file.set_value(SAVE_SECTION, "areas_unlocked", areas_unlocked)
	file.set_value(SAVE_SECTION, "boss_clears", boss_clears)
	file.set_value(SAVE_SECTION, "trainer_key_owned", trainer_key_owned)
	file.set_value(SAVE_SECTION, "returning_blood_awakened", returning_blood_awakened)
	file.set_value(SAVE_SECTION, "mist", mist)
	file.set_value(SAVE_SECTION, "scrolls", scrolls)
	file.set_value(SAVE_SECTION, "boss_materials", boss_materials)
	var err := file.save(SAVE_PATH)
	if err != OK:
		push_warning("[MetaProgress] Could not save persistent progress: %s" % error_string(err))


func _load_progress() -> void:
	var file := ConfigFile.new()
	if file.load(SAVE_PATH) != OK:
		return

	var loaded_areas = file.get_value(SAVE_SECTION, "areas_unlocked", areas_unlocked)
	if loaded_areas is Array:
		areas_unlocked.assign(loaded_areas)

	var loaded_clears = file.get_value(SAVE_SECTION, "boss_clears", boss_clears)
	if loaded_clears is Dictionary:
		boss_clears = loaded_clears

	trainer_key_owned = bool(file.get_value(SAVE_SECTION, "trainer_key_owned", trainer_key_owned))
	returning_blood_awakened = bool(file.get_value(SAVE_SECTION, "returning_blood_awakened", returning_blood_awakened))
	mist = maxi(0, int(file.get_value(SAVE_SECTION, "mist", 0)))
	scrolls = maxi(0, int(file.get_value(SAVE_SECTION, "scrolls", 0)))

	var loaded_materials = file.get_value(SAVE_SECTION, "boss_materials", boss_materials)
	if loaded_materials is Dictionary:
		for key in boss_materials.keys():
			boss_materials[key] = maxi(0, int(loaded_materials.get(key, 0)))
