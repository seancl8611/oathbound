extends Node

const BILEMASS_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CellarBilemass.tscn")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var bilemass: Node = BILEMASS_SCENE.instantiate()
	bilemass.name = "BilemassV2MigrationSmokeEnemy"
	add_child(bilemass)
	await get_tree().process_frame
	bilemass.set_physics_process(false)

	HUSHIRO_ENEMY_CONTRACT.apply(bilemass, "bilemass")
	await get_tree().physics_frame

	_expect(bilemass.has_method("has_v2_bilemass_runtime"), "canonical Bilemass is not routed through CellarBilemassV2")
	if bilemass.has_method("has_v2_bilemass_runtime"):
		_expect(bool(bilemass.call("has_v2_bilemass_runtime")), "canonical Bilemass failed to attach shared V2 components")
	_expect(bilemass.get_node_or_null("EnemyCombatResponseRuntime") != null, "Bilemass missing EnemyCombatResponseRuntime")
	_expect(bilemass.get_node_or_null("CombatActionRunner") != null, "Bilemass missing CombatActionRunner")
	_expect(bilemass.get_node_or_null("EnemyMotor") != null, "Bilemass missing EnemyMotor")
	_expect(bilemass.get_node_or_null("EnemyBrain") != null, "Bilemass missing EnemyBrain")
	_expect(bilemass.get_node_or_null("HushiroPostureBreakRuntime") != null, "Bilemass lost shared Posture/Deathblow runtime")
	_expect(bilemass.get_node_or_null("PostureBar") != null, "Bilemass lost canonical PostureBar")

	_expect(int(bilemass.get("hp")) == 60, "Bilemass Hushiro hack-and-slash Health target is not 60")
	var combat: Node = bilemass.get_node_or_null("Combat")
	if combat != null:
		var cfg: CombatConfig = combat.get("config") as CombatConfig
		_expect(cfg != null and is_equal_approx(float(cfg.posture_max), 70.0), "Bilemass canonical Posture max is not 70")
	else:
		_fail("Bilemass missing CombatController")

	_expect(int(bilemass.get("max_puddles_per_enemy")) == 2, "Bilemass per-enemy puddle cap changed")
	_expect(int(bilemass.get("room_puddle_cap")) == 8, "Bilemass room puddle cap changed")
	_expect(is_equal_approx(float(bilemass.get("puddle_slow_pct")), 0.50), "Bilemass puddle slow changed")
	_expect(is_equal_approx(float(bilemass.get("puddle_lifetime")), 3.5), "Bilemass puddle lifetime changed")

	if bilemass.has_method("uses_legacy_bilemass_ranged_role"):
		_expect(not bool(bilemass.call("uses_legacy_bilemass_ranged_role")), "Bilemass still declares legacy ranged-role ownership")
	else:
		_fail("Bilemass missing V2 legacy-role declaration")

	bilemass.set("player_in_range2", true)
	bilemass.set("beast_next_attack_time", -1.0)
	bilemass.set("_v2_pressure_retry_until", -1.0)
	var scores_value: Variant = bilemass.call("get_v2_bilemass_intent_scores_for_test", 10.0)
	if scores_value is Dictionary:
		var scores: Dictionary = scores_value as Dictionary
		_expect(float(scores.get(&"spit", -INF)) > float(scores.get(&"skitter", -INF)), "Bilemass ready hazard brain does not prioritize spit pressure")
	else:
		_fail("Bilemass V2 intent scores unavailable")

	var request_value: Variant = bilemass.call("get_v2_bilemass_pressure_request_for_test", 20.0)
	if request_value is Dictionary:
		var request: Dictionary = request_value as Dictionary
		var expected_delay: float = float(bilemass.get("spit_windup_duration")) + float(bilemass.get("spit_vomit_duration")) + float(bilemass.get("spit_travel_time"))
		_expect(str(request.get("attack_id", "")) == "bilemass_puddle", "Bilemass pressure request lost puddle identity")
		_expect(str(request.get("pressure_channel", "")) == "hazard", "Bilemass pressure is not authored as future ground hazard")
		_expect(str(request.get("severity", "")) == "heavy", "Bilemass area denial should reserve heavy pressure")
		_expect(float(request.get("threat_cost", 0.0)) > 1.0, "Bilemass hazard is under-costed like a fodder bite")
		_expect(is_equal_approx(float(request.get("impact_delay", 0.0)), expected_delay), "Bilemass reservation does not target future puddle landing")
	else:
		_fail("Bilemass V2 pressure request unavailable")

	bilemass.call("_begin_v2_spit_action")
	_expect(str(bilemass.call("get_v2_bilemass_action_phase")) == "STARTUP", "Bilemass spit did not enter CombatActionRunner STARTUP")
	var runner: Node = bilemass.get_node_or_null("CombatActionRunner")
	if runner != null:
		runner.call("tick", float(bilemass.get("spit_windup_duration")) * 0.70)
		_expect(str(bilemass.call("get_v2_bilemass_action_phase")) == "COMMITTED", "Bilemass spit did not cross explicit commitment")

	var response: Node = bilemass.get_node_or_null("EnemyCombatResponseRuntime")
	if response != null:
		var profile_value: Variant = response.get("profile")
		if profile_value is EnemyCombatResponseProfile:
			var profile: EnemyCombatResponseProfile = profile_value as EnemyCombatResponseProfile
			_expect(profile.neutral_poise_required == 1, "Bilemass neutral skitter gained unintended Poise")
			_expect(profile.committed_poise_required == 2, "Bilemass committed spit did not gain authored Poise")
		_expect(not bool(response.call("should_interrupt", null, {}, true)), "ordinary hit incorrectly interrupts committed Bilemass spit")
		_expect(bool(response.call("should_interrupt", null, {"heavy": true}, true)), "heavy impact cannot interrupt committed Bilemass spit")
	else:
		_fail("Bilemass response runtime unavailable for Poise assertion")

	if bilemass.has_method("has_v2_bilemass_pressure_runtime"):
		_expect(bool(bilemass.call("has_v2_bilemass_pressure_runtime")), "Bilemass cannot reach PressureDirectorV2")

	bilemass.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[BilemassV2MigrationSmoke] PASS - hazard brain | landing pressure | spit commitment | Poise | puddle contract | Posture preserved")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[BilemassV2MigrationSmoke] %s" % failure)
	print("[BilemassV2MigrationSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
