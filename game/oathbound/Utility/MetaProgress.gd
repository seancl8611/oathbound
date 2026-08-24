extends Node

## Persistent campaign state and banked progression resources.
## ITEMS_AND_REWARDS.md, PROGRESSION.md, RUN_STRUCTURE.md, and the approved endgame
## package own this state model. Persistent resources and campaign milestones are
## committed immediately when they change; Heart Bindings are state, not currency.

signal persistent_resources_changed
signal progression_changed
signal campaign_changed
signal returning_blood_awakened_changed(awakened: bool)

const SAVE_PATH := "user://oathbound_meta_progress.cfg"
const SAVE_SECTION := "progress"

const BOSS_MATERIAL_KEEPER := "keeper"
const BOSS_MATERIAL_TWIN_MAWS := "twin_maws"
const BOSS_MATERIAL_ECLIPSE_SHOGUN := "eclipse_shogun"

const TOTAL_HEART_BINDINGS: int = 6

var areas_unlocked: Array[int] = [1]
var boss_clears := {1: false, 2: false, 3: false}
var boss_defeat_counts := {1: 0, 2: 0, 3: 0}
var trainer_key_owned: bool = false
var returning_blood_awakened: bool = false

# Canonical campaign/postgame progression. The Court destroyed the original outer
# Binding before play begins, so the tracked launch campaign contains exactly six
# remaining Bindings. Destroyed Bindings cannot be spent, lost, or repeated.
var heart_bindings_destroyed: int = 0
var story_complete: bool = false
var standard_expedition_clears: int = 0
var heart_suppression_clears: int = 0

var mist: int = 0
var scrolls: int = 0
var boss_materials: Dictionary = {
	BOSS_MATERIAL_KEEPER: 0,
	BOSS_MATERIAL_TWIN_MAWS: 0,
	BOSS_MATERIAL_ECLIPSE_SHOGUN: 0,
}

# Canonical persistent Strand state. Values are intentionally generic identifiers so
# station-specific runtimes remain the authority for what a node/claim actually does.
var purchased_progression_nodes: Dictionary = {}
var progression_flags: Dictionary = {}
var blood_cavern_trial_completions: Dictionary = {}


func _ready() -> void:
	_load_progress()


func unlock_area(id: int) -> void:
	if not areas_unlocked.has(id):
		areas_unlocked.append(id)
		_commit_progression_change()


func mark_boss_clear(id: int) -> void:
	if bool(boss_clears.get(id, false)):
		return
	boss_clears[id] = true
	_commit_progression_change()


func record_boss_defeat(id: int) -> void:
	if id not in [1, 2, 3]:
		return
	boss_defeat_counts[id] = maxi(0, int(boss_defeat_counts.get(id, 0))) + 1
	boss_clears[id] = true
	_commit_progression_change()


func has_cleared_boss(id: int) -> bool:
	return bool(boss_clears.get(id, false))


func get_boss_defeat_count(id: int) -> int:
	return maxi(0, int(boss_defeat_counts.get(id, 0)))


func awaken_returning_blood() -> bool:
	if returning_blood_awakened:
		return false
	returning_blood_awakened = true
	_save_progress()
	returning_blood_awakened_changed.emit(true)
	progression_changed.emit()
	campaign_changed.emit()
	return true


func is_returning_blood_awakened() -> bool:
	return returning_blood_awakened


# =============================================================================
# HEART BINDING / STORY / POSTGAME CAMPAIGN STATE
# =============================================================================

func get_heart_bindings_destroyed() -> int:
	return clampi(heart_bindings_destroyed, 0, TOTAL_HEART_BINDINGS)


func get_heart_bindings_remaining() -> int:
	return maxi(0, TOTAL_HEART_BINDINGS - get_heart_bindings_destroyed())


func can_destroy_heart_binding() -> bool:
	return returning_blood_awakened and not story_complete and get_heart_bindings_destroyed() < TOTAL_HEART_BINDINGS


func destroy_next_heart_binding() -> bool:
	if not can_destroy_heart_binding():
		return false
	heart_bindings_destroyed = mini(TOTAL_HEART_BINDINGS, heart_bindings_destroyed + 1)
	_commit_campaign_change()
	return true


func is_true_final_story_run_due() -> bool:
	return returning_blood_awakened and not story_complete and get_heart_bindings_destroyed() >= TOTAL_HEART_BINDINGS


func is_story_complete() -> bool:
	return story_complete


func mark_story_complete() -> bool:
	# Story Complete is only valid after the six Binding campaign has already been
	# exhausted. The Heart encounter runtime, not the Shogun, owns calling this.
	if story_complete or get_heart_bindings_destroyed() < TOTAL_HEART_BINDINGS:
		return false
	story_complete = true
	_commit_campaign_change()
	return true


func record_standard_expedition_clear() -> bool:
	if not story_complete:
		return false
	standard_expedition_clears += 1
	_commit_campaign_change()
	return true


func record_heart_suppression_clear() -> bool:
	if not story_complete:
		return false
	heart_suppression_clears += 1
	_commit_campaign_change()
	return true


func get_campaign_snapshot() -> Dictionary:
	return {
		"returning_blood_awakened": returning_blood_awakened,
		"heart_bindings_destroyed": get_heart_bindings_destroyed(),
		"heart_bindings_remaining": get_heart_bindings_remaining(),
		"story_complete": story_complete,
		"standard_expedition_clears": maxi(0, standard_expedition_clears),
		"heart_suppression_clears": maxi(0, heart_suppression_clears),
		"boss_defeat_counts": boss_defeat_counts.duplicate(true),
	}


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


# =============================================================================
# STRAND / CAMPAIGN PERSISTENCE
# =============================================================================

func is_progression_node_owned(node_id: String) -> bool:
	return bool(purchased_progression_nodes.get(node_id, false))


func mark_progression_node_owned(node_id: String) -> bool:
	if node_id.is_empty() or is_progression_node_owned(node_id):
		return false
	purchased_progression_nodes[node_id] = true
	_commit_progression_change()
	return true


func get_progression_flag(flag_id: String, default_value: Variant = false) -> Variant:
	return progression_flags.get(flag_id, default_value)


func set_progression_flag(flag_id: String, value: Variant = true) -> void:
	if flag_id.is_empty() or progression_flags.get(flag_id, null) == value:
		return
	progression_flags[flag_id] = value
	_commit_progression_change()


func has_completed_blood_cavern_trial(trial_id: String) -> bool:
	return bool(blood_cavern_trial_completions.get(trial_id, false))


func mark_blood_cavern_trial_complete(trial_id: String) -> bool:
	if trial_id.is_empty() or has_completed_blood_cavern_trial(trial_id):
		return false
	blood_cavern_trial_completions[trial_id] = true
	_commit_progression_change()
	return true


func get_resource_snapshot() -> Dictionary:
	return {
		"mist": mist,
		"scrolls": scrolls,
		"boss_materials": boss_materials.duplicate(true),
		"returning_blood_awakened": returning_blood_awakened,
		"heart_bindings_destroyed": get_heart_bindings_destroyed(),
		"story_complete": story_complete,
		"standard_expedition_clears": maxi(0, standard_expedition_clears),
		"heart_suppression_clears": maxi(0, heart_suppression_clears),
		"boss_defeat_counts": boss_defeat_counts.duplicate(true),
		"purchased_progression_nodes": purchased_progression_nodes.duplicate(true),
		"progression_flags": progression_flags.duplicate(true),
		"blood_cavern_trial_completions": blood_cavern_trial_completions.duplicate(true),
	}


func _commit_persistent_change() -> void:
	_save_progress()
	persistent_resources_changed.emit()


func _commit_progression_change() -> void:
	_save_progress()
	progression_changed.emit()


func _commit_campaign_change() -> void:
	_save_progress()
	campaign_changed.emit()
	progression_changed.emit()


func _save_progress() -> void:
	var file := ConfigFile.new()
	file.set_value(SAVE_SECTION, "areas_unlocked", areas_unlocked)
	file.set_value(SAVE_SECTION, "boss_clears", boss_clears)
	file.set_value(SAVE_SECTION, "boss_defeat_counts", boss_defeat_counts)
	file.set_value(SAVE_SECTION, "trainer_key_owned", trainer_key_owned)
	file.set_value(SAVE_SECTION, "returning_blood_awakened", returning_blood_awakened)
	file.set_value(SAVE_SECTION, "heart_bindings_destroyed", get_heart_bindings_destroyed())
	file.set_value(SAVE_SECTION, "story_complete", story_complete)
	file.set_value(SAVE_SECTION, "standard_expedition_clears", maxi(0, standard_expedition_clears))
	file.set_value(SAVE_SECTION, "heart_suppression_clears", maxi(0, heart_suppression_clears))
	file.set_value(SAVE_SECTION, "mist", mist)
	file.set_value(SAVE_SECTION, "scrolls", scrolls)
	file.set_value(SAVE_SECTION, "boss_materials", boss_materials)
	file.set_value(SAVE_SECTION, "purchased_progression_nodes", purchased_progression_nodes)
	file.set_value(SAVE_SECTION, "progression_flags", progression_flags)
	file.set_value(SAVE_SECTION, "blood_cavern_trial_completions", blood_cavern_trial_completions)
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
		for area_id: int in [1, 2, 3]:
			boss_clears[area_id] = bool(loaded_clears.get(area_id, loaded_clears.get(str(area_id), false)))

	var loaded_defeat_counts = file.get_value(SAVE_SECTION, "boss_defeat_counts", boss_defeat_counts)
	if loaded_defeat_counts is Dictionary:
		for area_id: int in [1, 2, 3]:
			boss_defeat_counts[area_id] = maxi(0, int(loaded_defeat_counts.get(area_id, loaded_defeat_counts.get(str(area_id), 0))))

	trainer_key_owned = bool(file.get_value(SAVE_SECTION, "trainer_key_owned", trainer_key_owned))
	returning_blood_awakened = bool(file.get_value(SAVE_SECTION, "returning_blood_awakened", returning_blood_awakened))
	heart_bindings_destroyed = clampi(int(file.get_value(SAVE_SECTION, "heart_bindings_destroyed", 0)), 0, TOTAL_HEART_BINDINGS)
	story_complete = bool(file.get_value(SAVE_SECTION, "story_complete", false))
	# Defensive migration: a Story Complete save necessarily exhausted all six Bindings.
	if story_complete:
		heart_bindings_destroyed = TOTAL_HEART_BINDINGS
	standard_expedition_clears = maxi(0, int(file.get_value(SAVE_SECTION, "standard_expedition_clears", 0)))
	heart_suppression_clears = maxi(0, int(file.get_value(SAVE_SECTION, "heart_suppression_clears", 0)))
	mist = maxi(0, int(file.get_value(SAVE_SECTION, "mist", 0)))
	scrolls = maxi(0, int(file.get_value(SAVE_SECTION, "scrolls", 0)))

	var loaded_materials = file.get_value(SAVE_SECTION, "boss_materials", boss_materials)
	if loaded_materials is Dictionary:
		for key in boss_materials.keys():
			boss_materials[key] = maxi(0, int(loaded_materials.get(key, 0)))

	var loaded_nodes = file.get_value(SAVE_SECTION, "purchased_progression_nodes", {})
	if loaded_nodes is Dictionary:
		purchased_progression_nodes = loaded_nodes
	var loaded_flags = file.get_value(SAVE_SECTION, "progression_flags", {})
	if loaded_flags is Dictionary:
		progression_flags = loaded_flags
	var loaded_trials = file.get_value(SAVE_SECTION, "blood_cavern_trial_completions", {})
	if loaded_trials is Dictionary:
		blood_cavern_trial_completions = loaded_trials
