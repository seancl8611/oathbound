extends Node

## Regression smoke for current Hushiro combat semantics:
## - standard-enemy Health remains the defeat resource;
## - legacy Posture compatibility fields cannot accumulate or arm Deathblow;
## - current Area 1 hack-and-slash Health baselines remain explicit;
## - Hound-heavy authored encounters remain inside the Phase 7 pack envelope;
## - Keeper death rewards must recover from a stale/freed cached loot parent.

const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")
const HUSHIRO_ENCOUNTER_CATALOG = preload("res://Utility/HushiroEncounterCatalog.gd")
const HOUND_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/BlightedHound.tscn")
const KEEPER_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Bosses/Keeper.tscn")
const EXPERIENCE_GEM_SCENE: PackedScene = preload("res://Objects/experience_gem.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	await get_tree().process_frame
	_validate_current_burst_baseline()
	_validate_hound_encounter_pressure_envelope()
	await _validate_hound_standard_posture_retirement()
	await _validate_keeper_stale_loot_reward_parent()

	if _failures.is_empty():
		print("[HushiroCombatSemanticsSmoke] PASS - Health-first standard Hound | Posture retired | bounded pack envelope | Keeper reward recovery")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[HushiroCombatSemanticsSmoke] %s" % failure)
		print("[HushiroCombatSemanticsSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_current_burst_baseline() -> void:
	var baselines: Dictionary = HUSHIRO_ENEMY_CONTRACT.BASELINES
	_expect(int((baselines.get("hollow", {}) as Dictionary).get("health", 0)) == 40, "Hollow Health must be 40 for the Area 1 three-hit fodder target")
	_expect(float((baselines.get("hollow", {}) as Dictionary).get("posture", 0.0)) == 40.0, "Hollow legacy Posture compatibility value must remain 40")
	_expect(int((baselines.get("hound", {}) as Dictionary).get("health", 0)) == 50, "Hound Health must be 50 for the Area 1 four-hit target")
	_expect(float((baselines.get("hound", {}) as Dictionary).get("posture", 0.0)) == 45.0, "Hound legacy Posture compatibility value must remain 45")
	_expect(int((baselines.get("archer", {}) as Dictionary).get("health", 0)) == 45, "Archer Health must be 45 for the Area 1 four-hit target")
	_expect(float((baselines.get("archer", {}) as Dictionary).get("posture", 0.0)) == 65.0, "Archer legacy Posture compatibility value must remain 65")
	_expect(int((baselines.get("swordsman", {}) as Dictionary).get("health", 0)) == 60, "Swordsman Health must be 60 for the Area 1 five-hit target")
	_expect(float((baselines.get("swordsman", {}) as Dictionary).get("posture", 0.0)) == 90.0, "Swordsman legacy Posture compatibility value must remain 90")
	_expect(int((baselines.get("bilemass", {}) as Dictionary).get("health", 0)) == 60, "Bilemass Health must be 60 for the Area 1 five-hit target")
	_expect(float((baselines.get("bilemass", {}) as Dictionary).get("posture", 0.0)) == 70.0, "Bilemass legacy Posture compatibility value must remain 70")
	_expect(int((baselines.get("warden", {}) as Dictionary).get("health", 0)) == 140, "Warden Health must remain 140 for the Area 1 10-11-hit durable target")
	_expect(float((baselines.get("warden", {}) as Dictionary).get("posture", 0.0)) == 150.0, "Warden legacy Posture compatibility value must remain 150")


func _validate_hound_encounter_pressure_envelope() -> void:
	for encounter_id: String in ["H03_kennel_break", "H08_hounds_in_the_mud"]:
		var encounter: Dictionary = HUSHIRO_ENCOUNTER_CATALOG.get_by_id(encounter_id)
		_expect(not encounter.is_empty(), "%s missing from Hushiro encounter catalog" % encounter_id)
		var waves: Array = encounter.get("waves", [])
		for wave_index: int in range(waves.size()):
			var wave_value: Variant = waves[wave_index]
			if not (wave_value is Dictionary):
				_fail("%s wave %d is not a Dictionary" % [encounter_id, wave_index + 1])
				continue
			var hound_count: int = 0
			var total_count: int = 0
			var groups: Array = (wave_value as Dictionary).get("groups", [])
			for group_value: Variant in groups:
				if not (group_value is Dictionary):
					continue
				var group: Dictionary = group_value as Dictionary
				var count: int = int(group.get("count", 0))
				total_count += count
				if str(group.get("type", "")) == "hound":
					hound_count += count
			_expect(hound_count <= 4, "%s wave %d exceeds Phase 7 four-Hound pack envelope (%d)" % [encounter_id, wave_index + 1, hound_count])
			_expect(total_count <= 6, "%s wave %d exceeds approved six-active enemy cap (%d)" % [encounter_id, wave_index + 1, total_count])


func _validate_hound_standard_posture_retirement() -> void:
	var hound: Node = HOUND_SCENE.instantiate()
	hound.name = "CombatSemanticsHound"
	add_child(hound)
	await get_tree().process_frame

	HUSHIRO_ENEMY_CONTRACT.apply(hound, "hound")
	await get_tree().physics_frame

	var combat: Node = hound.get_node_or_null("Combat")
	var hound_runtime: Node = hound.get_node_or_null("HushiroHoundCombatRuntime")
	var no_posture: Node = hound.get_node_or_null("HushiroStandardNoPostureRuntime")
	_expect(combat != null, "Hound missing shared CombatController")
	_expect(hound_runtime != null, "Hound imported combat compatibility adapter was not attached")
	_expect(no_posture != null, "Hound no-Posture compatibility boundary was not attached")
	_expect(hound.get_node_or_null("HushiroPostureBreakRuntime") == null, "Hound retained standard posture-break runtime")
	_expect(hound.get_node_or_null("HushiroPostureReadabilityRuntime") == null, "Hound retained standard Posture readability runtime")
	if combat == null or hound_runtime == null or no_posture == null:
		hound.queue_free()
		return

	if no_posture.has_method("is_posture_retired"):
		_expect(bool(no_posture.call("is_posture_retired")), "Hound no-Posture runtime is not active")

	var cfg: CombatConfig = combat.get("config") as CombatConfig
	_expect(cfg != null, "Hound CombatController missing config")
	if cfg != null:
		_expect(is_equal_approx(float(cfg.posture_max), 45.0), "Hound legacy compatibility posture_max must remain 45, got %.2f" % float(cfg.posture_max))

	# Imported attack events may still carry posture values, but the retirement bridge
	# must synchronously neutralize them before they can become a second kill meter.
	combat.call("begin_attack_event", {
		"health_damage": 13,
		"posture_damage": 12.0,
		"block_posture_damage": 12.0,
		"stagger_level": 0,
		"proc_coefficient": 1.0,
		"attack_id": "wraith_veil_cut",
	})
	hound_runtime.call("_on_hound_hurt", 13, "oathbound_attack", null)
	combat.call("end_attack_event")
	_expect(is_zero_approx(float(combat.call("get_posture"))), "Hound canonical sword event accumulated retired standard Posture")

	# The Hound's imported local meter may still be written by legacy callbacks. It must
	# be folded back to zero without arming any executable state.
	hound.set("posture", 47.0)
	await get_tree().physics_frame
	_expect(is_zero_approx(float(combat.call("get_posture"))), "Hound legacy posture bridge bypassed standard retirement")
	_expect(is_zero_approx(float(hound.get("posture"))), "Hound local compatibility posture remained nonzero")
	if hound.has_method("is_deathblow_ready"):
		_expect(not bool(hound.call("is_deathblow_ready")), "standard Hound became Deathblow-ready after posture retirement")
	var posture_bar: Node = hound.get_node_or_null("PostureBar")
	if posture_bar is CanvasItem:
		_expect(not (posture_bar as CanvasItem).visible, "standard Hound PostureBar remained visible")

	hound.queue_free()
	await get_tree().process_frame


func _validate_keeper_stale_loot_reward_parent() -> void:
	# Reproduce the September 3 crash directly: Keeper's inherited loot_base property
	# points at an Object that has already been freed when the death reward method runs.
	# A live chamber Loot container remains available and must become the new parent.
	var live_loot := Node2D.new()
	live_loot.name = "Loot"
	add_child(live_loot)
	live_loot.add_to_group("loot")

	var keeper: Node = KEEPER_SCENE.instantiate()
	keeper.name = "KeeperRewardRegression"
	add_child(keeper)
	await get_tree().process_frame
	keeper.set("death_anim", null)
	keeper.set("exp_gem", EXPERIENCE_GEM_SCENE)

	var stale_loot := Node2D.new()
	stale_loot.name = "CollectedExperienceGem"
	add_child(stale_loot)
	stale_loot.add_to_group("loot")
	keeper.set("loot_base", stale_loot)
	stale_loot.free()
	_expect(not is_instance_valid(stale_loot), "Keeper stale-loot regression did not create a freed cached parent")

	var child_count_before := live_loot.get_child_count()
	keeper.call("_run_humanoid_death_rewards")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(live_loot.get_child_count() == child_count_before + 1, "Keeper death reward did not recover to the live chamber Loot container")
	if live_loot.get_child_count() > child_count_before:
		var spawned_gem: Node = live_loot.get_child(live_loot.get_child_count() - 1)
		_expect(spawned_gem.scene_file_path == "res://Objects/experience_gem.tscn", "Keeper recovered reward parent but spawned an unexpected reward scene")

	keeper.queue_free()
	live_loot.queue_free()
	await get_tree().process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)