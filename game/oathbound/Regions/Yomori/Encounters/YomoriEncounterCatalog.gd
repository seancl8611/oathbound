extends RefCounted

## Authored Yomori standard encounter pool.
## Only the four approved native Region 2 enemies appear here.

const ENCOUNTERS: Array[Dictionary] = [
	{
		"id": "Y01_spirit_patrol",
		"name": "Spirit Patrol",
		"min_chamber": 1,
		"wave_spacing": [4.5, 6.0],
		"waves": [
			{"groups": [{"type": "lingering_wraith", "count": 2}]},
			{"groups": [{"type": "lantern_wraith", "count": 1}, {"type": "lingering_wraith", "count": 1}]},
		],
	},
	{
		"id": "Y02_lantern_crossing",
		"name": "Lantern Crossing",
		"min_chamber": 1,
		"wave_spacing": [4.5, 6.0],
		"waves": [
			{"groups": [{"type": "lantern_wraith", "count": 1}, {"type": "lingering_wraith", "count": 1}]},
			{"groups": [{"type": "lantern_wraith", "count": 2}]},
		],
	},
	{
		"id": "Y03_shepherd_procession",
		"name": "Shepherd's Procession",
		"min_chamber": 2,
		"wave_spacing": [5.0, 6.5],
		"waves": [
			{"groups": [{"type": "mist_shepherd", "count": 1}, {"type": "lingering_wraith", "count": 2}]},
			{"groups": [{"type": "lantern_wraith", "count": 1}, {"type": "lingering_wraith", "count": 1}]},
		],
	},
	{
		"id": "Y04_mist_hunt",
		"name": "Mist Hunt",
		"min_chamber": 3,
		"wave_spacing": [5.0, 6.5],
		"waves": [
			{"groups": [{"type": "stalker_hound", "count": 1}, {"type": "lingering_wraith", "count": 1}]},
			{"groups": [{"type": "lantern_wraith", "count": 1}, {"type": "lingering_wraith", "count": 2}]},
		],
	},
	{
		"id": "Y05_pale_procession",
		"name": "Pale Procession",
		"min_chamber": 3,
		"wave_spacing": [5.5, 7.0],
		"waves": [
			{"groups": [{"type": "mist_shepherd", "count": 1}, {"type": "lingering_wraith", "count": 2}]},
			{"groups": [{"type": "lingering_wraith", "count": 2}, {"type": "lantern_wraith", "count": 1}]},
		],
	},
	{
		"id": "Y06_predators_lantern",
		"name": "Predator's Lantern",
		"min_chamber": 4,
		"wave_spacing": [5.5, 7.0],
		"waves": [
			{"groups": [{"type": "stalker_hound", "count": 1}, {"type": "lantern_wraith", "count": 1}]},
			{"groups": [{"type": "lingering_wraith", "count": 2}, {"type": "lantern_wraith", "count": 1}]},
		],
	},
	{
		"id": "Y07_shepherds_snare",
		"name": "Shepherd's Snare",
		"min_chamber": 5,
		"wave_spacing": [6.0, 7.5],
		"waves": [
			{"groups": [{"type": "mist_shepherd", "count": 1}, {"type": "lantern_wraith", "count": 1}, {"type": "lingering_wraith", "count": 1}]},
			{"groups": [{"type": "stalker_hound", "count": 1}, {"type": "lingering_wraith", "count": 1}]},
		],
	},
	{
		"id": "Y08_deep_grove_hunt",
		"name": "Deep Grove Hunt",
		"min_chamber": 6,
		"wave_spacing": [6.0, 8.0],
		"waves": [
			{"groups": [{"type": "stalker_hound", "count": 1}, {"type": "lingering_wraith", "count": 2}]},
			{"groups": [{"type": "mist_shepherd", "count": 1}, {"type": "lantern_wraith", "count": 1}, {"type": "lingering_wraith", "count": 1}]},
		],
	},
]


static func get_by_id(encounter_id: String) -> Dictionary:
	for encounter: Dictionary in ENCOUNTERS:
		if str(encounter.get("id", "")) == encounter_id:
			return encounter.duplicate(true)
	return {}


static func get_eligible(chamber_number: int, seen: Array[String] = []) -> Array[Dictionary]:
	var eligible: Array[Dictionary] = []
	for encounter: Dictionary in ENCOUNTERS:
		if chamber_number < int(encounter.get("min_chamber", 1)):
			continue
		if seen.has(str(encounter.get("id", ""))):
			continue
		eligible.append(encounter)
	return eligible


static func pick_for_chamber(chamber_number: int, seen: Array[String], rng: RandomNumberGenerator = null) -> Dictionary:
	var eligible := get_eligible(chamber_number, seen)
	if eligible.is_empty():
		eligible = get_eligible(chamber_number, [])
	if eligible.is_empty():
		return {}
	var picker := rng
	if picker == null:
		picker = RandomNumberGenerator.new()
		picker.randomize()
	return eligible[picker.randi_range(0, eligible.size() - 1)].duplicate(true)


static func approved_enemy_types() -> Array[String]:
	return ["lingering_wraith", "lantern_wraith", "mist_shepherd", "stalker_hound"]


static func validate_catalog() -> Array[String]:
	var errors: Array[String] = []
	var approved := approved_enemy_types()
	var ids: Dictionary = {}
	for encounter: Dictionary in ENCOUNTERS:
		var encounter_id := str(encounter.get("id", ""))
		if encounter_id.is_empty() or ids.has(encounter_id):
			errors.append("invalid or duplicate encounter id: %s" % encounter_id)
		ids[encounter_id] = true
		for wave_value: Variant in encounter.get("waves", []):
			if not (wave_value is Dictionary):
				continue
			for group_value: Variant in (wave_value as Dictionary).get("groups", []):
				if not (group_value is Dictionary):
					continue
				var enemy_type := str((group_value as Dictionary).get("type", ""))
				if not approved.has(enemy_type):
					errors.append("%s uses non-Yomori enemy type %s" % [encounter_id, enemy_type])
	return errors
