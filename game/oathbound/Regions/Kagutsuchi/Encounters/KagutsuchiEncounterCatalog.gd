extends RefCounted

## Authored Kagutsuchi standard encounter pool.
## Only the five approved native Court enemies appear here. Encounter escalation comes
## from authored combinations and mechanics rather than importing earlier regions or
## automatically inflating Health.

const ENCOUNTERS: Array[Dictionary] = [
	{
		"id": "K01_retainer_pair",
		"name": "Retainer Pair",
		"min_chamber": 1,
		"wave_spacing": [4.5, 6.0],
		"waves": [
			{"groups": [{"type": "court_guard", "count": 2}]},
			{"groups": [{"type": "court_caster", "count": 1}, {"type": "court_guard", "count": 1}]},
		],
	},
	{
		"id": "K02_ritual_escort",
		"name": "Ritual Escort",
		"min_chamber": 1,
		"wave_spacing": [4.5, 6.0],
		"waves": [
			{"groups": [{"type": "court_guard", "count": 1}, {"type": "court_caster", "count": 1}]},
			{"groups": [{"type": "court_guard", "count": 2}]},
		],
	},
	{
		"id": "K03_shield_procession",
		"name": "Shield Procession",
		"min_chamber": 2,
		"wave_spacing": [5.0, 6.5],
		"waves": [
			{"groups": [{"type": "elite_defender", "count": 1}, {"type": "court_guard", "count": 1}]},
			{"groups": [{"type": "court_caster", "count": 1}, {"type": "court_guard", "count": 1}]},
		],
	},
	{
		"id": "K04_vessel_watch",
		"name": "Vessel Watch",
		"min_chamber": 3,
		"wave_spacing": [5.0, 6.5],
		"waves": [
			{"groups": [{"type": "hollow_vessel", "count": 1}, {"type": "court_guard", "count": 1}]},
			{"groups": [{"type": "court_guard", "count": 1}, {"type": "court_caster", "count": 1}]},
		],
	},
	{
		"id": "K05_sentinel_escort",
		"name": "Sentinel Escort",
		"min_chamber": 3,
		"wave_spacing": [5.5, 7.0],
		"waves": [
			{"groups": [{"type": "court_sentinel", "count": 1}, {"type": "court_guard", "count": 1}]},
			{"groups": [{"type": "court_caster", "count": 1}, {"type": "court_guard", "count": 1}]},
		],
	},
	{
		"id": "K06_guarded_ritual",
		"name": "Guarded Ritual",
		"min_chamber": 4,
		"wave_spacing": [5.5, 7.0],
		"waves": [
			{"groups": [{"type": "elite_defender", "count": 1}, {"type": "court_caster", "count": 1}]},
			{"groups": [{"type": "court_guard", "count": 2}]},
		],
	},
	{
		"id": "K07_vessel_and_spear",
		"name": "Vessel and Spear",
		"min_chamber": 4,
		"wave_spacing": [5.5, 7.0],
		"waves": [
			{"groups": [{"type": "hollow_vessel", "count": 1}, {"type": "elite_defender", "count": 1}]},
			{"groups": [{"type": "court_guard", "count": 2}]},
		],
	},
	{
		"id": "K08_disciplined_pressure",
		"name": "Disciplined Pressure",
		"min_chamber": 5,
		"wave_spacing": [6.0, 7.5],
		"waves": [
			{"groups": [{"type": "court_sentinel", "count": 1}, {"type": "court_caster", "count": 1}]},
			{"groups": [{"type": "elite_defender", "count": 1}, {"type": "court_guard", "count": 1}]},
		],
	},
	{
		"id": "K09_false_ascendancy",
		"name": "False Ascendancy",
		"min_chamber": 6,
		"wave_spacing": [6.0, 8.0],
		"waves": [
			{"groups": [{"type": "hollow_vessel", "count": 1}, {"type": "court_caster", "count": 1}, {"type": "court_guard", "count": 1}]},
			{"groups": [{"type": "court_sentinel", "count": 1}, {"type": "court_guard", "count": 1}]},
		],
	},
	{
		"id": "K10_final_procession",
		"name": "Final Procession",
		"min_chamber": 7,
		"wave_spacing": [6.0, 8.0],
		"waves": [
			{"groups": [{"type": "elite_defender", "count": 1}, {"type": "court_sentinel", "count": 1}]},
			{"groups": [{"type": "court_caster", "count": 1}, {"type": "court_guard", "count": 2}]},
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
	return ["court_guard", "court_caster", "elite_defender", "hollow_vessel", "court_sentinel"]


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
					errors.append("%s uses non-Kagutsuchi enemy type %s" % [encounter_id, enemy_type])
	return errors
