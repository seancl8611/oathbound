extends RefCounted

## Approved Hushiro standard-encounter catalog.
## Composition and minimum-chamber eligibility mirror
## docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md.

const ENCOUNTERS: Array[Dictionary] = [
	{
		"id": "H01_broken_patrol",
		"name": "Broken Patrol",
		"min_chamber": 1,
		"waves": [
			{"groups": [{"type": "swordsman", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 4}]},
		],
	},
	{
		"id": "H02_firing_line",
		"name": "Firing Line",
		"min_chamber": 2,
		"waves": [
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}, {"type": "hollow", "count": 2}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H03_kennel_break",
		"name": "Kennel Break",
		"min_chamber": 2,
		"waves": [
			{"groups": [{"type": "hound", "count": 4}]},
			{"groups": [{"type": "hound", "count": 3}, {"type": "swordsman", "count": 1}]},
			{"groups": [{"type": "hound", "count": 4}, {"type": "swordsman", "count": 1}]},
		],
	},
	{
		"id": "H04_barricade_mob",
		"name": "Barricade Mob",
		"min_chamber": 2,
		"waves": [
			{"groups": [{"type": "hollow", "count": 5}]},
			{"groups": [{"type": "swordsman", "count": 1}, {"type": "hollow", "count": 5}]},
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 4}]},
		],
	},
	{
		"id": "H05_crossfire_retreat",
		"name": "Crossfire Retreat",
		"min_chamber": 3,
		"waves": [
			{"groups": [{"type": "archer", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "archer", "count": 2}, {"type": "hollow", "count": 2}]},
			{"groups": [{"type": "archer", "count": 2}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H06_spoiled_storehouse",
		"name": "Spoiled Storehouse",
		"min_chamber": 4,
		"waves": [
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H07_chain_detail",
		"name": "Chain Detail",
		"min_chamber": 5,
		"waves": [
			{"groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
			{"groups": [{"type": "warden", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"groups": [{"type": "warden", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
		],
	},
	{
		"id": "H08_hounds_in_the_mud",
		"name": "Hounds in the Mud",
		"min_chamber": 4,
		"waves": [
			{"groups": [{"type": "hound", "count": 4}]},
			{"groups": [{"type": "hound", "count": 3}, {"type": "archer", "count": 1}]},
			{"groups": [{"type": "hound", "count": 4}, {"type": "swordsman", "count": 1}]},
			{"groups": [{"type": "hound", "count": 4}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 1}]},
		],
	},
	{
		"id": "H09_choked_courtyard",
		"name": "Choked Courtyard",
		"min_chamber": 6,
		"waves": [
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "hollow", "count": 3}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}]},
			{"groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "hollow", "count": 2}, {"type": "swordsman", "count": 2}]},
		],
	},
	{
		"id": "H10_last_checkpoint",
		"name": "Last Checkpoint",
		"min_chamber": 7,
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


static func pick_for_chamber(chamber_number: int, seen_ids: Array[String]) -> Dictionary:
	# Broken Patrol owns the first Hushiro standard-combat teaching slot. Until the
	# route generator itself is fully reconciled, make the first combat room use it
	# even if an old service-room route token preceded that combat room.
	if seen_ids.is_empty():
		return get_by_id("H01_broken_patrol")

	var eligible: Array[Dictionary] = []
	for encounter: Dictionary in ENCOUNTERS:
		var encounter_id: String = str(encounter.get("id", ""))
		if seen_ids.has(encounter_id):
			continue
		if chamber_number < int(encounter.get("min_chamber", 1)):
			continue
		eligible.append(encounter)

	if eligible.is_empty():
		return {}

	return eligible.pick_random().duplicate(true)
