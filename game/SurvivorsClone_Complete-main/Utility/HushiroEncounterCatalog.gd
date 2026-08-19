extends RefCounted
class_name HushiroEncounterCatalog

## Approved Area 1 authored encounter catalog.
## Source of truth: docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md
##
## Imported EncounterDB remains available for unreconciled Area 2/3 content. Current
## Hushiro Combat rooms use this catalog directly so Area 1 no longer selects the
## old debug/prototype encounter compositions.

const USED_META_KEY: StringName = &"hushiro_encounters_used"

const ENCOUNTERS: Array[Dictionary] = [
	{
		"id": "H01_broken_patrol", "name": "Broken Patrol", "min_chamber": 1, "fixed_first_combat": true,
		"waves": [
			{"groups": [{"type": "swordsman", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 4}]},
		],
	},
	{
		"id": "H02_firing_line", "name": "Firing Line", "min_chamber": 2,
		"waves": [
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}, {"type": "hollow", "count": 2}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H03_kennel_break", "name": "Kennel Break", "min_chamber": 2,
		"waves": [
			{"groups": [{"type": "hound", "count": 4}]},
			{"groups": [{"type": "hound", "count": 3}, {"type": "swordsman", "count": 1}]},
			{"groups": [{"type": "hound", "count": 4}, {"type": "swordsman", "count": 1}]},
		],
	},
	{
		"id": "H04_barricade_mob", "name": "Barricade Mob", "min_chamber": 2,
		"waves": [
			{"groups": [{"type": "hollow", "count": 5}]},
			{"groups": [{"type": "swordsman", "count": 1}, {"type": "hollow", "count": 5}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 4}]},
		],
	},
	{
		"id": "H05_crossfire_retreat", "name": "Crossfire Retreat", "min_chamber": 3,
		"waves": [
			{"groups": [{"type": "archer", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "archer", "count": 2}, {"type": "hollow", "count": 2}]},
			{"groups": [{"type": "archer", "count": 2}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H06_spoiled_storehouse", "name": "Spoiled Storehouse", "min_chamber": 4,
		"waves": [
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H07_chain_detail", "name": "Chain Detail", "min_chamber": 5,
		"waves": [
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
			{"groups": [{"type": "warden", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"groups": [{"type": "warden", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
		],
	},
	{
		"id": "H08_hounds_in_the_mud", "name": "Hounds in the Mud", "min_chamber": 4,
		"waves": [
			{"groups": [{"type": "hound", "count": 4}]},
			{"groups": [{"type": "hound", "count": 3}, {"type": "archer", "count": 1}]},
			{"groups": [{"type": "hound", "count": 4}, {"type": "swordsman", "count": 1}]},
			{"groups": [{"type": "hound", "count": 4}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 1}]},
		],
	},
	{
		"id": "H09_choked_courtyard", "name": "Choked Courtyard", "min_chamber": 6,
		"waves": [
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "hollow", "count": 2}, {"type": "swordsman", "count": 2}]},
		],
	},
	{
		"id": "H10_last_checkpoint", "name": "Last Checkpoint", "min_chamber": 7,
		"waves": [
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}]},
			{"groups": [{"type": "warden", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}]},
			{"groups": [{"type": "warden", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
]


static func get_by_id(encounter_id: String) -> Dictionary:
	for encounter: Dictionary in ENCOUNTERS:
		if str(encounter.get("id", "")) == encounter_id:
			return encounter.duplicate(true)
	return {}


static func pick_for_current_run() -> Dictionary:
	var first_combat: bool = int(RunData.combat_rooms_cleared) == 0
	if first_combat:
		RunData.set_meta(USED_META_KEY, PackedStringArray())
		return _mark_used(get_by_id("H01_broken_patrol"))

	var chamber_number: int = maxi(2, int(RunData.depth) + 1)
	var used: PackedStringArray = _used_ids()
	var eligible: Array[Dictionary] = []

	for encounter: Dictionary in ENCOUNTERS:
		if bool(encounter.get("fixed_first_combat", false)):
			continue
		if int(encounter.get("min_chamber", 1)) > chamber_number:
			continue
		if used.has(str(encounter.get("id", ""))):
			continue
		eligible.append(encounter)

	if eligible.is_empty():
		# A normal Hushiro route should not exhaust this pool. Keep playtest continuity
		# if a debug warp sequence does, while making the repeat explicit in Output.
		push_warning("[HushiroEncounterCatalog] Unique eligible pool exhausted; allowing a debug repeat.")
		for encounter: Dictionary in ENCOUNTERS:
			if bool(encounter.get("fixed_first_combat", false)):
				continue
			if int(encounter.get("min_chamber", 1)) <= chamber_number:
				eligible.append(encounter)

	if eligible.is_empty():
		return get_by_id("H02_firing_line")

	return _mark_used(eligible.pick_random().duplicate(true))


static func _used_ids() -> PackedStringArray:
	var raw: Variant = RunData.get_meta(USED_META_KEY, PackedStringArray())
	if raw is PackedStringArray:
		return raw
	var converted := PackedStringArray()
	if raw is Array:
		for value: Variant in raw:
			converted.append(str(value))
	return converted


static func _mark_used(encounter: Dictionary) -> Dictionary:
	if encounter.is_empty():
		return encounter
	var encounter_id: String = str(encounter.get("id", ""))
	var used: PackedStringArray = _used_ids()
	if not encounter_id.is_empty() and not used.has(encounter_id):
		used.append(encounter_id)
		RunData.set_meta(USED_META_KEY, used)
	print("[HushiroEncounterCatalog] Picked %s | chamber=%d | enemies=%d" % [
		encounter_id,
		int(RunData.depth) + 1,
		get_enemy_count(encounter),
	])
	return encounter


static func get_enemy_count(encounter: Dictionary) -> int:
	var total: int = 0
	var waves: Array = encounter.get("waves", []) as Array
	for wave_value: Variant in waves:
		if typeof(wave_value) != TYPE_DICTIONARY:
			continue
		var wave: Dictionary = wave_value as Dictionary
		var groups: Array = wave.get("groups", []) as Array
		for group_value: Variant in groups:
			if typeof(group_value) == TYPE_DICTIONARY:
				total += int((group_value as Dictionary).get("count", 0))
	return total
