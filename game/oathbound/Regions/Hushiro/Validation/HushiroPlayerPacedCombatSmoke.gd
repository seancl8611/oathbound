extends Node

## Deterministic contract for the Area 1 manual-playtest target.
## Protects kill-time calibration, guard significance, wave-advance timing, arrival-mode
## variety, and encounter-level wave-count/population variability.

const ASPECT_CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")
const HUSHIRO_CATALOG = preload("res://Utility/HushiroEncounterCatalog.gd")
const HUSHIRO_SPAWNER = preload("res://Regions/Hushiro/Encounters/EncounterSpawner.gd")
const RESPONSE_PROFILE = preload("res://Core/Combat/EnemyCombatResponseProfile.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_validate_base_katana_kill_time_contract()
	_validate_guard_survival_contract()
	_validate_wave_advance_contract()
	_validate_arrival_script_variety()
	_validate_encounter_variability()
	_finish()


func _validate_base_katana_kill_time_contract() -> void:
	var profiles: Array = ASPECT_CATALOG.get_basic_profiles(ASPECT_CATALOG.NO_ASPECT, 0)
	_expect(profiles.size() == 3, "Base katana must retain the three-hit basic chain used for Area 1 calibration")
	if profiles.size() < 3:
		return

	var expected: Array[int] = [9, 12, 21]
	for index: int in range(3):
		var profile_value: Variant = profiles[index]
		_expect(profile_value is Dictionary, "Base katana profile %d is not a Dictionary" % index)
		if profile_value is Dictionary:
			_expect(int((profile_value as Dictionary).get("health_damage", -1)) == expected[index], "Base katana hit %d damage changed from readiness anchor %d" % [index + 1, expected[index]])

	var damage_4: int = _basic_damage_after_hits(profiles, 4)
	var damage_5: int = _basic_damage_after_hits(profiles, 5)
	var damage_6: int = _basic_damage_after_hits(profiles, 6)
	var damage_10: int = _basic_damage_after_hits(profiles, 10)
	var damage_11: int = _basic_damage_after_hits(profiles, 11)
	_expect(damage_5 == 63 and damage_6 == 84, "Base katana 5/6-hit cumulative damage must remain 63/84")
	_expect(damage_10 == 135 and damage_11 == 147, "Base katana 10/11-hit cumulative damage must remain 135/147")

	var baselines: Dictionary = HUSHIRO_ENEMY_CONTRACT.BASELINES
	var swordsman_hp: int = _health_for(baselines, "swordsman")
	var archer_hp: int = _health_for(baselines, "archer")
	var warden_hp: int = _health_for(baselines, "warden")
	var hollow_hp: int = _health_for(baselines, "hollow")
	var hound_hp: int = _health_for(baselines, "hound")

	_expect(swordsman_hp > damage_5 and swordsman_hp <= damage_6, "Standard Swordsman must survive five clean base hits and die by hit six")
	_expect(archer_hp > damage_4 and archer_hp <= damage_5, "Archer must be squishier: survive four clean base hits and die by hit five")
	_expect(warden_hp > damage_10 and warden_hp <= damage_11, "Warden must land in the 10-11-hit durable target")
	_expect(hollow_hp < swordsman_hp and hound_hp < swordsman_hp, "Hollow/Hound must remain lighter than the standard Swordsman")


func _validate_guard_survival_contract() -> void:
	var profiles: Array = ASPECT_CATALOG.get_basic_profiles(ASPECT_CATALOG.NO_ASPECT, 0)
	if profiles.size() < 3:
		return
	var six_hit_damage: float = float(_basic_damage_after_hits(profiles, 6))
	var first_hit: float = float((profiles[0] as Dictionary).get("health_damage", 0))
	var swordsman_profile: EnemyCombatResponseProfile = RESPONSE_PROFILE.corrupted_swordsman_v2()
	var guarded_six_hit_damage: float = six_hit_damage - first_hit + first_hit * swordsman_profile.guard_health_multiplier
	var swordsman_hp: float = float(_health_for(HUSHIRO_ENEMY_CONTRACT.BASELINES, "swordsman"))

	_expect(six_hit_damage >= swordsman_hp, "Six clean base hits must kill the Area 1 Swordsman")
	_expect(guarded_six_hit_damage < swordsman_hp, "One meaningful Swordsman guard must normally save it from the otherwise lethal six-hit line")
	_expect(is_equal_approx(swordsman_profile.guard_health_multiplier, 0.35), "Swordsman guard Health multiplier changed from the 35% readiness contract")


func _validate_wave_advance_contract() -> void:
	_expect(is_equal_approx(HUSHIRO_SPAWNER.AREA1_ANTI_STALL_SECONDS, 120.0), "Area 1 anti-stall timeout must start at 120 seconds")
	_expect(HUSHIRO_SPAWNER.AREA1_NORMAL_ACTIVE_CAP == 6, "Normal Area 1 active cap must remain six for this playtest target")
	_expect(HUSHIRO_SPAWNER.AREA1_ANTI_STALL_OVERFLOW_SLOTS >= 1, "Anti-stall timeout must have at least one visible overflow slot")

	_expect(HUSHIRO_SPAWNER.area1_wave_advance_reason(0, 2.0, 120.0) == "cleared", "Full clear must be the primary wave-advance trigger")
	_expect(HUSHIRO_SPAWNER.area1_wave_advance_reason(3, 119.99, 120.0).is_empty(), "Anti-stall must not fire before 120 seconds")
	_expect(HUSHIRO_SPAWNER.area1_wave_advance_reason(3, 120.0, 120.0) == "anti_stall_timeout", "Anti-stall must trigger the next authored wave at 120 seconds")


func _validate_arrival_script_variety() -> void:
	var burst: Dictionary = HUSHIRO_SPAWNER.area1_arrival_timing({"arrival": "burst"})
	var staggered: Dictionary = HUSHIRO_SPAWNER.area1_arrival_timing({"arrival": "staggered"})
	var sequence: Dictionary = HUSHIRO_SPAWNER.area1_arrival_timing({"arrival": "sequence"})
	_expect(float(burst.get("unit_interval", 99.0)) < float(staggered.get("unit_interval", 0.0)), "Staggered arrivals must be perceptibly slower than burst arrivals")
	_expect(float(staggered.get("unit_interval", 99.0)) < float(sequence.get("unit_interval", 0.0)), "Sequence arrivals must be perceptibly slower than staggered arrivals")

	var mode_counts: Dictionary = {"burst": 0, "staggered": 0, "sequence": 0}
	for encounter: Dictionary in HUSHIRO_CATALOG.ENCOUNTERS:
		var waves: Array = encounter.get("waves", [])
		for wave_value: Variant in waves:
			if not (wave_value is Dictionary):
				continue
			var mode: String = str((wave_value as Dictionary).get("arrival", "burst"))
			_expect(mode_counts.has(mode), "Unknown Area 1 arrival mode '%s'" % mode)
			if mode_counts.has(mode):
				mode_counts[mode] = int(mode_counts[mode]) + 1

	_expect(int(mode_counts.get("burst", 0)) > 0, "Encounter catalog must retain burst waves")
	_expect(int(mode_counts.get("staggered", 0)) > 0, "Encounter catalog must include staggered waves")
	_expect(int(mode_counts.get("sequence", 0)) > 0, "Encounter catalog must include sequence waves")


func _validate_encounter_variability() -> void:
	var wave_counts: Dictionary = {}
	var min_total: int = 999
	var max_total: int = 0
	for encounter: Dictionary in HUSHIRO_CATALOG.ENCOUNTERS:
		var waves: Array = encounter.get("waves", [])
		wave_counts[waves.size()] = true
		var total: int = HUSHIRO_CATALOG.get_enemy_count(encounter)
		min_total = mini(min_total, total)
		max_total = maxi(max_total, total)
		for wave_value: Variant in waves:
			if not (wave_value is Dictionary):
				continue
			var population: int = _wave_population(wave_value as Dictionary)
			_expect(population >= 3 and population <= 6, "Normal authored wave population must remain in the current 3-6 readability envelope")

	_expect(wave_counts.has(2), "Area 1 must retain at least one two-wave encounter")
	_expect(wave_counts.has(3), "Area 1 must retain three-wave encounters")
	_expect(wave_counts.has(4), "Area 1 must retain at least one four-wave encounter")
	_expect(max_total > min_total, "Whole encounters must retain different total enemy counts instead of being flattened to one budget")


func _basic_damage_after_hits(profiles: Array, hits: int) -> int:
	var total: int = 0
	for hit_index: int in range(maxi(0, hits)):
		var profile_value: Variant = profiles[hit_index % profiles.size()]
		if profile_value is Dictionary:
			total += int((profile_value as Dictionary).get("health_damage", 0))
	return total


func _health_for(baselines: Dictionary, enemy_type: String) -> int:
	var value: Variant = baselines.get(enemy_type, {})
	if value is Dictionary:
		return int((value as Dictionary).get("health", 0))
	return 0


func _wave_population(wave: Dictionary) -> int:
	var total: int = 0
	var groups_value: Variant = wave.get("groups", [])
	if not (groups_value is Array):
		return 0
	for group_value: Variant in groups_value as Array:
		if group_value is Dictionary:
			total += int((group_value as Dictionary).get("count", 0))
	return total


func _finish() -> void:
	if _failures.is_empty():
		print("[HushiroPlayerPacedCombatSmoke] PASS - 6-hit Swordsman | 5-hit Archer | 11-hit Warden | guard survival | immediate clear advance | 120s anti-stall | varied arrivals")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[HushiroPlayerPacedCombatSmoke] %s" % failure)
	print("[HushiroPlayerPacedCombatSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
