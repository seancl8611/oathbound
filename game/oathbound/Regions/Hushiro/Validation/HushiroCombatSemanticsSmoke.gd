extends Node

## Regression smoke for the combat issues reproduced from live playtests:
## - canonical sword Posture must affect Blighted Hounds;
## - a full Posture meter enters stagger before Deathblow readiness;
## - dead standard enemies cannot remain Deathblow-ready;
## - Hound-heavy authored encounters never put more than two Hounds in one wave;
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
	_validate_hound_encounter_caps()
	await _validate_hound_shared_posture_and_stagger()
	await _validate_keeper_stale_loot_reward_parent()

	if _failures.is_empty():
		print("[HushiroCombatSemanticsSmoke] PASS - shared Hound posture stagger-first deathblow pack cap")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[HushiroCombatSemanticsSmoke] %s" % failure)
		print("[HushiroCombatSemanticsSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_current_burst_baseline() -> void:
	var baselines: Dictionary = HUSHIRO_ENEMY_CONTRACT.BASELINES
	_expect(int((baselines.get("hollow", {}) as Dictionary).get("health", 0)) == 45, "Hollow Health must be 45")
	_expect(float((baselines.get("hollow", {}) as Dictionary).get("posture", 0.0)) == 40.0, "Hollow Posture must be 40")
	_expect(int((baselines.get("hound", {}) as Dictionary).get("health", 0)) == 50, "Hound Health must be 50")
	_expect(float((baselines.get("hound", {}) as Dictionary).get("posture", 0.0)) == 45.0, "Hound Posture must be 45")
	_expect(int((baselines.get("swordsman", {}) as Dictionary).get("health", 0)) == 90, "Swordsman Health must be 90")
	_expect(float((baselines.get("swordsman", {}) as Dictionary).get("posture", 0.0)) == 90.0, "Swordsman Posture must be 90")


func _validate_hound_encounter_caps() -> void:
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
			var groups: Array = (wave_value as Dictionary).get("groups", [])
			for group_value: Variant in groups:
				if group_value is Dictionary and str((group_value as Dictionary).get("type", "")) == "hound":
					hound_count += int((group_value as Dictionary).get("count", 0))
			_expect(hound_count <= 2, "%s wave %d exceeds two-Hound cap (%d)" % [encounter_id, wave_index + 1, hound_count])


func _validate_hound_shared_posture_and_stagger() -> void:
	var hound: Node = HOUND_SCENE.instantiate()
	hound.name = "CombatSemanticsHound"
	add_child(hound)
	await get_tree().process_frame

	HUSHIRO_ENEMY_CONTRACT.apply(hound, "hound")
	await get_tree().physics_frame

	var combat: Node = hound.get_node_or_null("Combat")
	var hound_runtime: Node = hound.get_node_or_null("HushiroHoundCombatRuntime")
	var break_runtime: Node = hound.get_node_or_null("HushiroPostureBreakRuntime")
	_expect(combat != null, "Hound missing shared CombatController")
	_expect(hound_runtime != null, "Hound shared posture adapter was not attached")
	_expect(break_runtime != null, "Hound posture-break runtime was not attached")
	if combat == null or hound_runtime == null or break_runtime == null:
		hound.queue_free()
		return

	var cfg: CombatConfig = combat.get("config") as CombatConfig
	_expect(cfg != null, "Hound CombatController missing config")
	if cfg != null:
		_expect(is_equal_approx(float(cfg.posture_max), 45.0), "Hound shared Posture max must be 45, got %.2f" % float(cfg.posture_max))

	# Reproduce a normal Wraith/basic sword event. The playtest log showed authored 12
	# Posture reaching Hounds as 0; this transaction must now move the shared meter.
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
	_expect(is_equal_approx(float(combat.call("get_posture")), 12.0), "Hound canonical sword event did not add 12 shared Posture")

	# Reproduce the Hound's existing +35 parry response. The adapter absorbs the local
	# imported value into the same shared meter, yielding 47 total and therefore a 45/45
	# break. Crucially, the break frame itself must still be stagger-only.
	hound.set("posture", 47.0)
	await get_tree().physics_frame
	_expect(is_equal_approx(float(combat.call("get_posture")), 45.0), "Hound parry bridge did not fill shared Posture to 45")
	_expect(bool(break_runtime.call("is_break_active")), "Full Hound Posture did not enter stagger state")
	_expect(not bool(break_runtime.call("is_deathblow_armed")), "Deathblow armed on the same frame as Hound Posture break")
	_expect(not bool(hound.call("is_deathblow_ready")), "Legacy Hound readiness bypassed stagger-only beat")

	await get_tree().create_timer(0.24).timeout
	await get_tree().physics_frame
	_expect(bool(break_runtime.call("is_deathblow_armed")), "Hound Deathblow did not arm after stagger readability beat")
	_expect(bool(hound.call("is_deathblow_ready")), "Hound legacy readiness did not mirror shared armed state")

	# Dead standards cannot stay in the player's execution candidate set.
	hound.set("hp", 0)
	await get_tree().physics_frame
	await get_tree().physics_frame
	_expect(not bool(break_runtime.call("is_deathblow_armed")), "Dead Hound remained shared Deathblow-ready")
	_expect(not bool(hound.call("is_deathblow_ready")), "Dead Hound remained legacy Deathblow-ready")

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
