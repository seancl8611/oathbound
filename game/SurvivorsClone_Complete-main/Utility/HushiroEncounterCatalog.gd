extends RefCounted
class_name HushiroEncounterCatalog

## Approved Area 1 authored encounter catalog.
## Source of truth: docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md
##
## The imported EncounterDB still serves unreconciled Area 2/3 content. Current
## Hushiro Combat rooms call this catalog directly so Area 1 no longer selects the
## old debug/prototype `full_assault`, `shade`, `dog`, or `akaname` compositions.

const USED_META_KEY: StringName = &"hushiro_encounters_used"

const ENCOUNTERS: Array = [
	{
		"id": "H01_broken_patrol",
		"label": "Broken Patrol",
		"min_chamber": 1,
		"fixed_first_combat": true,
		"waves": [
			{"groups": [
				{"type": "swordsman", "count": 1},
				{"type": "hollow", "count": 3},
			]},
			{"groups": [
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 4},
			]},
		],
	},
	{
		"id": "H02_firing_line",
		"label": "Firing Line",
		"min_chamber": 2,
		"waves": [
			{"groups": [
				{"type": "swordsman", "count": 2},
				{"type": "archer", "count": 1},
			]},
			{"groups": [
				{"type": "swordsman", "count": 2},
				{"type": "archer", "count": 1},
				{"type": "hollow", "count": 2},
			]},
			{"groups": [
				{"type": "swordsman", "count": 2},
				{"type": "archer", "count": 2},
				{"type": "hollow", "count": 2},
			]},
		],
	},
	{
		"id": "H03_kennel_break",
		"label": "Kennel Break",
		"min_chamber": 2,
		"waves": [
			{"groups": [{"type": "hound", "count": 4}]},
			{"groups": [
				{"type": "hound", "count": 3},
				{"type": "swordsman", "count": 1},
			]},
			{"groups": [
				{"type": "hound", "count": 4},
				{"type": "swordsman", "count": 1},
			]},
		],
	},
	{
		"id": "H04_barricade_mob",
		"label": "Barricade Mob",
		"min_chamber": 2,
		"waves": [
			{"groups": [{"type": "hollow", "count": 5}]},
			{"groups": [
				{"type": "swordsman", "count": 1},
				{"type": "hollow", "count": 5},
			]},
			{"groups": [
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 4},
			]},
		],
	},
	{
		"id": "H05_crossfire_retreat",
		"label": "Crossfire Retreat",
		"min_chamber": 3,
		"waves": [
			{"groups": [
				{"type": "archer", "count": 1},
				{"type": "hollow", "count": 3},
			]},
			{"groups": [
				{"type": "archer", "count": 2},
				{"type": "hollow", "count": 2},
			]},
			{"groups": [
				{"type": "archer", "count": 2},
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 2},
			]},
		],
	},
	{
		"id": "H06_spoiled_storehouse",
		"label": "Spoiled Storehouse",
		"min_chamber": 4,
		"waves": [
			{"groups": [
				{"type": "bilemass", "count": 1},
				{"type": "hollow", "count": 3},
			]},
			{"groups": [
				{"type": "bilemass", "count": 1},
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 1},
			]},
			{"groups": [
				{"type": "bilemass", "count": 1},
				{"type": "archer", "count": 1},
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 2},
			]},
		],
	},
	{
		"id": "H07_chain_detail",
		"label": "Chain Detail",
		"min_chamber": 5,
		"waves": [
			{"groups": [
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 2},
			]},
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 1},
			]},
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "archer", "count": 1},
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 1},
			]},
		],
	},
	{
		"id": "H08_hounds_in_the_mud",
		"label": "Hounds in the Mud",
		"min_chamber": 4,
		"waves": [
			{"groups": [{"type": "hound", "count": 4}]},
			{"groups": [
				{"type": "hound", "count": 3},
				{"type": "archer", "count": 1},
			]},
			{"groups": [
				{"type": "hound", "count": 4},
				{"type": "swordsman", "count": 1},
			]},
			{"groups": [
				{"type": "hound", "count": 4},
				{"type": "archer", "count": 1},
				{"type": "swordsman", "count": 1},
			]},
		],
	},
	{
		"id": "H09_choked_courtyard",
		"label": "Choked Courtyard",
		"min_chamber": 6,
		"waves": [
			{"groups": [
				{"type": "bilemass", "count": 1},
				{"type": "hollow", "count": 3},
			]},
			{"groups": [
				{"type": "bilemass", "count": 1},
				{"type": "archer", "count": 1},
				{"type": "swordsman", "count": 2},
			]},
			{"groups": [
				{"type": "bilemass", "count": 1},
				{"type": "archer", "count": 1},
				{"type": "hollow", "count": 2},
				{"type": "swordsman", "count": 2},
			]},
		],
	},
	{
		"id": "H10_last_checkpoint",
		"label": "Last Checkpoint",
		"min_chamber": 7,
		"waves": [
			{"groups": [
				{"type": "swordsman", "count": 2},
				{"type": "archer", "count": 1},
			]},
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 1},
			]},
			{"groups": [
				{"type": "bilemass", "count": 1},
				{"type": "archer", "count": 1},
				{"type": "swordsman", "count": 2},
			]},
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "archer", "count": 1},
				{"type": "swordsman", "count": 2},
				{"type": "hollow", "count": 2},
			]},
		],
	},
]


static func get_by_id(encounter_id: String) -> Dictionary:
	for value: Variant in ENCOUNTERS:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var encounter: Dictionary = value as Dictionary
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

	for value: Variant in ENCOUNTERS:
		if typeof(value) != TYPE_DICTIONARY:
			continue
		var encounter: Dictionary = value as Dictionary
		if bool(encounter.get("fixed_first_combat", false)):
			continue
		if int(encounter.get("min_chamber", 1)) > chamber_number:
			continue
		if used.has(str(encounter.get("id", ""))):
			continue
		eligible.append(encounter)

	if eligible.is_empty():
		# A normal 12-chamber Hushiro route cannot exhaust this pool. Keep a safe
		# debug fallback rather than returning an invalid/empty encounter.
		push_warning("[HushiroEncounterCatalog] Eligible unique pool exhausted; allowing a repeat for debug continuity.")
		for value: Variant in ENCOUNTERS:
			if typeof(value) != TYPE_DICTIONARY:
				continue
			var encounter: Dictionary = value as Dictionary
			if bool(encounter.get("fixed_first_combat", false)):
				continue
			if int(encounter.get("min_chamber", 1)) <= chamber_number:
				eligible.append(encounter)

	if eligible.is_empty():
		return get_by_id("H02_firing_line")

	var picked: Dictionary = eligible[randi() % eligible.size()].duplicate(true)
	return _mark_used(picked)


static func _used_ids() -> PackedStringArray:
	var raw: Variant = RunData.get_meta(USED_META_KEY, PackedStringArray())
	if raw is PackedStringArray:
		return raw
	if raw is Array:
		var converted := PackedStringArray()
		for value: Variant in raw:
			converted.append(str(value))
		return converted
	return PackedStringArray()


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
	var waves_value: Variant = encounter.get("waves", [])
	if typeof(waves_value) != TYPE_ARRAY:
		return 0
	for wave_value: Variant in waves_value as Array:
		if typeof(wave_value) != TYPE_DICTIONARY:
			continue
		var groups_value: Variant = (wave_value as Dictionary).get("groups", [])
		if typeof(groups_value) != TYPE_ARRAY:
			continue
		for group_value: Variant in groups_value as Array:
			if typeof(group_value) == TYPE_DICTIONARY:
				total += int((group_value as Dictionary).get("count", 0))
	return total
