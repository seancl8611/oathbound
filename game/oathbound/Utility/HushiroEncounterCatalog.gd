extends RefCounted
class_name HushiroEncounterCatalog

## Approved Hushiro standard-encounter catalog.
## Composition and minimum-chamber eligibility mirror the Area 1 content baseline;
## arrival metadata follows HUSHIRO_COMBAT_PLAYTEST_TARGET.md.
##
## A wave is an authored arrival script, not necessarily a simultaneous packet. The
## optional `arrival` field is interpreted by the Hushiro EncounterSpawner:
## - burst: near-simultaneous entry,
## - staggered: rolling short-interval entry,
## - sequence: clearly perceptible one-after-another reinforcement entry.
## `unit_interval` / `group_interval` may override the mode defaults for one wave.
##
## Imported EncounterDB remains available for unreconciled Area 2/3 content. Area 1
## uses this catalog directly and RunData owns the per-run seen list.

const ENCOUNTERS: Array[Dictionary] = [
	{
		"id": "H01_broken_patrol",
		"name": "Broken Patrol",
		"min_chamber": 1,
		"opening_only": true,
		"waves": [
			{"arrival": "burst", "groups": [{"type": "swordsman", "count": 1}, {"type": "hollow", "count": 3}]},
			# Rolling reinforcements make the larger second beat feel continuous rather
			# than simply dropping all six bodies on the same frame.
			{"arrival": "staggered", "unit_interval": 0.22, "groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 4}]},
		],
	},
	{
		"id": "H02_firing_line",
		"name": "Firing Line",
		"min_chamber": 2,
		"waves": [
			{"arrival": "burst", "groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}]},
			{"arrival": "staggered", "groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}, {"type": "hollow", "count": 2}]},
			# Final spike arrives together so target priority is immediately legible.
			{"arrival": "burst", "groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H03_kennel_break",
		"name": "Kennel Break",
		"min_chamber": 2,
		"waves": [
			{"arrival": "burst", "groups": [{"type": "hound", "count": 4}]},
			{"arrival": "staggered", "unit_interval": 0.16, "groups": [{"type": "hound", "count": 3}, {"type": "swordsman", "count": 1}]},
			{"arrival": "burst", "groups": [{"type": "hound", "count": 4}, {"type": "swordsman", "count": 1}]},
		],
	},
	{
		"id": "H04_barricade_mob",
		"name": "Barricade Mob",
		"min_chamber": 2,
		"waves": [
			# Feed fragile fodder into Akio one after another so an experienced player
			# can maintain forward momentum instead of waiting on a static cluster.
			{"arrival": "sequence", "unit_interval": 0.40, "groups": [{"type": "hollow", "count": 5}]},
			{"arrival": "staggered", "unit_interval": 0.18, "groups": [{"type": "swordsman", "count": 1}, {"type": "hollow", "count": 5}]},
			{"arrival": "burst", "groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 4}]},
		],
	},
	{
		"id": "H05_crossfire_retreat",
		"name": "Crossfire Retreat",
		"min_chamber": 3,
		"waves": [
			# Archer establishes the ranged problem before its Hollow screen arrives.
			{"arrival": "sequence", "unit_interval": 0.38, "groups": [{"type": "archer", "count": 1}, {"type": "hollow", "count": 3}]},
			{"arrival": "staggered", "groups": [{"type": "archer", "count": 2}, {"type": "hollow", "count": 2}]},
			{"arrival": "burst", "groups": [{"type": "archer", "count": 2}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H06_spoiled_storehouse",
		"name": "Spoiled Storehouse",
		"min_chamber": 4,
		"waves": [
			# Let the hazard establish first, then feed the direct-pressure bodies into it.
			{"arrival": "sequence", "unit_interval": 0.40, "groups": [{"type": "bilemass", "count": 1}, {"type": "hollow", "count": 3}]},
			{"arrival": "staggered", "unit_interval": 0.30, "groups": [{"type": "bilemass", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"arrival": "burst", "groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
	{
		"id": "H07_chain_detail",
		"name": "Chain Detail",
		"min_chamber": 5,
		"waves": [
			{"arrival": "burst", "groups": [{"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
			# Warden appears first so the restraint threat is readable before support arrives.
			{"arrival": "sequence", "unit_interval": 0.42, "groups": [{"type": "warden", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"arrival": "staggered", "unit_interval": 0.26, "groups": [{"type": "warden", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
		],
	},
	{
		"id": "H08_hounds_in_the_mud",
		"name": "Hounds in the Mud",
		"min_chamber": 4,
		"waves": [
			# This is Hushiro's highest-tempo standard room; preserve pack bursts rather
			# than using sequence mode simply because sequence support exists.
			{"arrival": "burst", "groups": [{"type": "hound", "count": 4}]},
			{"arrival": "burst", "groups": [{"type": "hound", "count": 3}, {"type": "archer", "count": 1}]},
			{"arrival": "staggered", "unit_interval": 0.14, "groups": [{"type": "hound", "count": 4}, {"type": "swordsman", "count": 1}]},
			{"arrival": "burst", "groups": [{"type": "hound", "count": 4}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 1}]},
		],
	},
	{
		"id": "H09_choked_courtyard",
		"name": "Choked Courtyard",
		"min_chamber": 6,
		"waves": [
			{"arrival": "sequence", "unit_interval": 0.38, "groups": [{"type": "bilemass", "count": 1}, {"type": "hollow", "count": 3}]},
			{"arrival": "staggered", "groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}]},
			{"arrival": "burst", "groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "hollow", "count": 2}, {"type": "swordsman", "count": 2}]},
		],
	},
	{
		"id": "H10_last_checkpoint",
		"name": "Last Checkpoint",
		"min_chamber": 7,
		"waves": [
			{"arrival": "burst", "groups": [{"type": "swordsman", "count": 2}, {"type": "archer", "count": 1}]},
			{"arrival": "sequence", "unit_interval": 0.36, "groups": [{"type": "warden", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 1}]},
			{"arrival": "staggered", "unit_interval": 0.26, "groups": [{"type": "bilemass", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}]},
			{"arrival": "burst", "groups": [{"type": "warden", "count": 1}, {"type": "archer", "count": 1}, {"type": "swordsman", "count": 2}, {"type": "hollow", "count": 2}]},
		],
	},
]


static func get_by_id(encounter_id: String) -> Dictionary:
	for encounter: Dictionary in ENCOUNTERS:
		if str(encounter.get("id", "")) == encounter_id:
			return encounter.duplicate(true)
	return {}


static func pick_for_chamber(chamber_number: int, seen_ids: Array[String]) -> Dictionary:
	var first_standard_combat: bool = seen_ids.is_empty()
	if first_standard_combat:
		return get_by_id("H01_broken_patrol")

	var eligible: Array[Dictionary] = []
	for encounter: Dictionary in ENCOUNTERS:
		var encounter_id: String = str(encounter.get("id", ""))
		if seen_ids.has(encounter_id):
			continue
		if bool(encounter.get("opening_only", false)):
			continue
		if chamber_number < int(encounter.get("min_chamber", 1)):
			continue
		eligible.append(encounter)

	if eligible.is_empty():
		push_warning("[HushiroEncounterCatalog] No unseen eligible encounter for chamber %d." % chamber_number)
		return {}

	var picked: Dictionary = eligible.pick_random()
	return picked.duplicate(true)


static func get_enemy_count(encounter: Dictionary) -> int:
	var total: int = 0
	var waves: Array = encounter.get("waves", [])
	for wave_value: Variant in waves:
		if typeof(wave_value) != TYPE_DICTIONARY:
			continue
		var wave: Dictionary = wave_value as Dictionary
		var groups: Array = wave.get("groups", [])
		for group_value: Variant in groups:
			if typeof(group_value) == TYPE_DICTIONARY:
				total += int((group_value as Dictionary).get("count", 0))
	return total
