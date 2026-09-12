extends Node

## Combat V2 Phase 7 structural smoke for Hushiro standard-encounter retuning.
##
## This protects four independent contracts:
## 1. the authored encounter catalog retains its approved progression/body-count identity,
## 2. Hound-heavy waves can create pack movement/frontline pressure without reopening
##    legacy whole-turn melee concurrency,
## 3. mixed-role waves distinguish actual close-pressure bodies from ranged/spatial roles
##    when autoscaling frontline occupancy,
## 4. PressureDirectorV2 still spaces actual damaging impact windows even when several
##    enemies are allowed to hunt/reposition at once.

const HUSHIRO_CATALOG = preload("res://Utility/HushiroEncounterCatalog.gd")
const HUSHIRO_CHAMBER_SCRIPT = preload("res://Regions/Hushiro/Chambers/CombatChamber.gd")
const PRESSURE_DIRECTOR_SCRIPT = preload("res://Core/Combat/PressureDirectorV2.gd")

const EXPECTED_TOTALS: Dictionary = {
	"H01_broken_patrol": 10,
	"H02_firing_line": 14,
	"H03_kennel_break": 13,
	"H04_barricade_mob": 17,
	"H05_crossfire_retreat": 14,
	"H06_spoiled_storehouse": 14,
	"H07_chain_detail": 13,
	"H08_hounds_in_the_mud": 19,
	"H09_choked_courtyard": 14,
	"H10_last_checkpoint": 17,
}

const FRONTLINE_PRESSURE_TYPES: Array[String] = [
	"swordsman",
	"hollow",
	"hound",
	"warden",
]

class PressureDummy:
	extends Node
	var has_died: bool = false

var _failures: Array[String] = []
var _max_wave_population: int = 0


func _ready() -> void:
	await get_tree().process_frame
	_validate_catalog_contract()
	_validate_hound_pack_compositions()
	_validate_phase7_room_pressure_policy()
	_validate_mixed_role_frontline_policy()
	_validate_v2_impact_spacing()

	if _failures.is_empty():
		print("[HushiroEncounterRetuningSmoke] PASS - 10 authored encounters | H03=13 | H08=19 | max wave=6 | Hound pack movement=3/4 | mixed frontline=4 | impact scheduling preserved")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[HushiroEncounterRetuningSmoke] %s" % failure)
		print("[HushiroEncounterRetuningSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_catalog_contract() -> void:
	_expect(HUSHIRO_CATALOG.ENCOUNTERS.size() == 10, "Expected 10 authored standard encounters")

	for encounter: Dictionary in HUSHIRO_CATALOG.ENCOUNTERS:
		var encounter_id: String = str(encounter.get("id", ""))
		_expect(EXPECTED_TOTALS.has(encounter_id), "Unexpected encounter id '%s'" % encounter_id)
		if not EXPECTED_TOTALS.has(encounter_id):
			continue

		var total: int = HUSHIRO_CATALOG.get_enemy_count(encounter)
		_expect(total == int(EXPECTED_TOTALS[encounter_id]), "%s total=%d expected=%d" % [encounter_id, total, int(EXPECTED_TOTALS[encounter_id])])

		var waves_value: Variant = encounter.get("waves", [])
		_expect(waves_value is Array and not (waves_value as Array).is_empty(), "%s has no authored waves" % encounter_id)
		if not (waves_value is Array):
			continue
		for wave_index: int in range((waves_value as Array).size()):
			var wave_value: Variant = (waves_value as Array)[wave_index]
			if not (wave_value is Dictionary):
				_fail("%s wave %d is not a Dictionary" % [encounter_id, wave_index + 1])
				continue
			var population: int = _wave_population(wave_value as Dictionary)
			_max_wave_population = maxi(_max_wave_population, population)
			_expect(population >= 3, "%s wave %d population=%d below standard Hushiro floor" % [encounter_id, wave_index + 1, population])
			_expect(population <= 6, "%s wave %d population=%d exceeds approved six-active cap" % [encounter_id, wave_index + 1, population])

	_expect(_max_wave_population == 6, "Expected authored catalog to exercise the six-active cap")


func _validate_hound_pack_compositions() -> void:
	var kennel: Dictionary = HUSHIRO_CATALOG.get_by_id("H03_kennel_break")
	var kennel_waves: Array = kennel.get("waves", [])
	_expect(kennel_waves.size() == 3, "Kennel Break must have 3 waves")
	if kennel_waves.size() == 3:
		_expect(_group_count(kennel_waves[0], "hound") == 4 and _wave_population(kennel_waves[0]) == 4, "Kennel Break wave 1 must be 4 Hounds")
		_expect(_group_count(kennel_waves[1], "hound") == 3 and _group_count(kennel_waves[1], "swordsman") == 1 and _wave_population(kennel_waves[1]) == 4, "Kennel Break wave 2 must be 3 Hounds + 1 Swordsman")
		_expect(_group_count(kennel_waves[2], "hound") == 4 and _group_count(kennel_waves[2], "swordsman") == 1 and _wave_population(kennel_waves[2]) == 5, "Kennel Break wave 3 must be 4 Hounds + 1 Swordsman")
		for wave_value: Variant in kennel_waves:
			if wave_value is Dictionary:
				_expect(_group_count(wave_value as Dictionary, "hollow") == 0, "Kennel Break must not replace authored Hounds with Hollows")

	var mud: Dictionary = HUSHIRO_CATALOG.get_by_id("H08_hounds_in_the_mud")
	var mud_waves: Array = mud.get("waves", [])
	_expect(mud_waves.size() == 4, "Hounds in the Mud must have 4 waves")
	if mud_waves.size() == 4:
		_expect(_group_count(mud_waves[0], "hound") == 4 and _wave_population(mud_waves[0]) == 4, "Hounds in the Mud wave 1 must be 4 Hounds")
		_expect(_group_count(mud_waves[1], "hound") == 3 and _group_count(mud_waves[1], "archer") == 1 and _wave_population(mud_waves[1]) == 4, "Hounds in the Mud wave 2 must be 3 Hounds + 1 Archer")
		_expect(_group_count(mud_waves[2], "hound") == 4 and _group_count(mud_waves[2], "swordsman") == 1 and _wave_population(mud_waves[2]) == 5, "Hounds in the Mud wave 3 must be 4 Hounds + 1 Swordsman")
		_expect(_group_count(mud_waves[3], "hound") == 4 and _group_count(mud_waves[3], "archer") == 1 and _group_count(mud_waves[3], "swordsman") == 1 and _wave_population(mud_waves[3]) == 6, "Hounds in the Mud wave 4 must be 4 Hounds + 1 Archer + 1 Swordsman")
		for wave_value: Variant in mud_waves:
			if wave_value is Dictionary:
				_expect(_group_count(wave_value as Dictionary, "hollow") == 0, "Hounds in the Mud must not replace authored Hounds with Hollows")


func _validate_phase7_room_pressure_policy() -> void:
	var four_hounds: Dictionary = HUSHIRO_CHAMBER_SCRIPT.phase7_pressure_limits(4, 4, 4)
	_expect(int(four_hounds.get("advance_limit", 0)) == 3, "4-Hound wave should allow three simultaneous advance slots")
	_expect(int(four_hounds.get("frontline_limit", 0)) == 4, "4-Hound wave should allow four frontline bodies")
	_expect(int(four_hounds.get("melee_limit", 0)) == 1, "Phase 7 must not raise legacy melee-turn cap")
	_expect(int(four_hounds.get("ranged_limit", 0)) == 1, "Phase 7 must not raise legacy ranged-turn cap")

	var mixed_six: Dictionary = HUSHIRO_CHAMBER_SCRIPT.phase7_pressure_limits(6, 4, 5)
	_expect(int(mixed_six.get("advance_limit", 0)) == 3, "Mixed six-body Hound wave should retain three advance slots")
	_expect(int(mixed_six.get("frontline_limit", 0)) == 4, "Mixed six-body Hound wave should retain four frontline bodies")

	var ranged_spatial_six: Dictionary = HUSHIRO_CHAMBER_SCRIPT.phase7_pressure_limits(6, 0, 2)
	_expect(int(ranged_spatial_six.get("advance_limit", 0)) == 2, "Ranged/spatial-heavy six-body wave should retain conservative two-advance envelope")
	_expect(int(ranged_spatial_six.get("frontline_limit", 0)) == 3, "Ranged/spatial-heavy six-body wave should retain three-body frontline envelope")

	var close_pressure_six: Dictionary = HUSHIRO_CHAMBER_SCRIPT.phase7_pressure_limits(6, 0, 4)
	_expect(int(close_pressure_six.get("advance_limit", 0)) == 2, "Mixed close-pressure retune must not globally raise advance slots")
	_expect(int(close_pressure_six.get("frontline_limit", 0)) == 4, "Four close-pressure bodies should allow four-body frontline occupancy")
	_expect(int(close_pressure_six.get("melee_limit", 0)) == 1, "Mixed close-pressure retune must not raise legacy melee-turn cap")
	_expect(int(close_pressure_six.get("ranged_limit", 0)) == 1, "Mixed close-pressure retune must not raise legacy ranged-turn cap")


func _validate_mixed_role_frontline_policy() -> void:
	# Broken Patrol's second wave is six pure close-pressure bodies: two Swordsmen and
	# four Hollows. Hollows deliberately bypass the old approach gate, so the chamber
	# must not reserialize that authored swarm with a three-body crowd-backoff ceiling.
	_validate_wave_frontline("H01_broken_patrol", 1, 6, 4)

	# Firing Line wave 3 reaches six total bodies but only four are close pressure;
	# its two Archers stay on the ranged/spatial layer and must not count toward the
	# room's close-pressure budget.
	_validate_wave_frontline("H02_firing_line", 2, 4, 4)

	# Crossfire Retreat wave 2 is deliberately ranged-heavy: two Archers + two Hollows.
	# Population alone must not unlock the wider close-pressure frontline.
	_validate_wave_frontline("H05_crossfire_retreat", 1, 2, 3)

	# Late mixed rooms exercise the same role-aware rule with hazard/control support.
	_validate_wave_frontline("H06_spoiled_storehouse", 2, 4, 4)
	_validate_wave_frontline("H07_chain_detail", 1, 4, 4)
	_validate_wave_frontline("H09_choked_courtyard", 2, 4, 4)
	_validate_wave_frontline("H10_last_checkpoint", 3, 5, 4)


func _validate_wave_frontline(encounter_id: String, wave_index: int, expected_close_pressure: int, expected_frontline_limit: int) -> void:
	var encounter: Dictionary = HUSHIRO_CATALOG.get_by_id(encounter_id)
	var waves: Array = encounter.get("waves", [])
	_expect(wave_index >= 0 and wave_index < waves.size(), "%s missing wave index %d" % [encounter_id, wave_index])
	if wave_index < 0 or wave_index >= waves.size():
		return
	var wave_value: Variant = waves[wave_index]
	_expect(wave_value is Dictionary, "%s wave %d is not a Dictionary" % [encounter_id, wave_index + 1])
	if not (wave_value is Dictionary):
		return
	var wave: Dictionary = wave_value as Dictionary
	var population: int = _wave_population(wave)
	var hounds: int = _group_count(wave, "hound")
	var close_pressure: int = _frontline_pressure_count(wave)
	_expect(close_pressure == expected_close_pressure, "%s wave %d close-pressure count=%d expected=%d" % [encounter_id, wave_index + 1, close_pressure, expected_close_pressure])
	var limits: Dictionary = HUSHIRO_CHAMBER_SCRIPT.phase7_pressure_limits(population, hounds, close_pressure)
	_expect(int(limits.get("frontline_limit", 0)) == expected_frontline_limit, "%s wave %d frontline limit=%d expected=%d" % [encounter_id, wave_index + 1, int(limits.get("frontline_limit", 0)), expected_frontline_limit])
	_expect(int(limits.get("advance_limit", 0)) <= 3, "%s wave %d unexpectedly exceeded three advance slots" % [encounter_id, wave_index + 1])
	_expect(int(limits.get("melee_limit", 0)) == 1, "%s wave %d raised legacy melee-turn cap" % [encounter_id, wave_index + 1])


func _validate_v2_impact_spacing() -> void:
	var director_value: Variant = PRESSURE_DIRECTOR_SCRIPT.new()
	if not (director_value is PressureDirectorV2):
		_fail("Could not instantiate PressureDirectorV2")
		return
	var director: PressureDirectorV2 = director_value as PressureDirectorV2
	add_child(director)

	var hounds: Array[PressureDummy] = []
	for index: int in range(4):
		var hound := PressureDummy.new()
		hound.name = "PressureHound%d" % index
		add_child(hound)
		hounds.append(hound)

	var now: float = Time.get_ticks_msec() * 0.001
	var first: Dictionary = director.request_threat(hounds[0], _hound_lunge_request(now + 0.45))
	var stacked: Dictionary = director.request_threat(hounds[1], _hound_lunge_request(now + 0.45))
	var staggered: Dictionary = director.request_threat(hounds[2], _hound_lunge_request(now + 0.82))
	var near_staggered: Dictionary = director.request_threat(hounds[3], _hound_lunge_request(now + 0.86))

	_expect(bool(first.get("admitted", false)), "First Hound impact should be admitted")
	_expect(not bool(stacked.get("admitted", false)), "Simultaneous second heavy Hound impact must be delayed")
	_expect(bool(staggered.get("admitted", false)), "Later Hound impact should be admitted once spacing is readable")
	_expect(not bool(near_staggered.get("admitted", false)), "Another heavy impact too close to the staggered impact must be delayed")
	_expect(director.reservation_count() == 2, "Expected exactly two spaced Hound impact reservations")

	director.queue_free()
	for hound: PressureDummy in hounds:
		hound.queue_free()


func _hound_lunge_request(impact_at: float) -> Dictionary:
	var now: float = Time.get_ticks_msec() * 0.001
	return {
		"attack_id": "phase7_hound_lunge",
		"requested_at": now,
		"impact_at": impact_at,
		"impact_delay": maxf(0.01, impact_at - now),
		"active_duration": 0.26,
		"severity": "heavy",
		"threat_cost": 1.20,
	}


func _wave_population(wave: Dictionary) -> int:
	var total: int = 0
	var groups_value: Variant = wave.get("groups", [])
	if not (groups_value is Array):
		return 0
	for group_value: Variant in groups_value as Array:
		if group_value is Dictionary:
			total += int((group_value as Dictionary).get("count", 0))
	return total


func _frontline_pressure_count(wave: Dictionary) -> int:
	var total: int = 0
	var groups_value: Variant = wave.get("groups", [])
	if not (groups_value is Array):
		return 0
	for group_value: Variant in groups_value as Array:
		if not (group_value is Dictionary):
			continue
		var group: Dictionary = group_value as Dictionary
		var enemy_type: String = str(group.get("type", ""))
		if FRONTLINE_PRESSURE_TYPES.has(enemy_type):
			total += int(group.get("count", 0))
	return total


func _group_count(wave_value: Variant, enemy_type: String) -> int:
	if not (wave_value is Dictionary):
		return 0
	var groups_value: Variant = (wave_value as Dictionary).get("groups", [])
	if not (groups_value is Array):
		return 0
	for group_value: Variant in groups_value as Array:
		if not (group_value is Dictionary):
			continue
		var group: Dictionary = group_value as Dictionary
		if str(group.get("type", "")) == enemy_type:
			return int(group.get("count", 0))
	return 0


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)