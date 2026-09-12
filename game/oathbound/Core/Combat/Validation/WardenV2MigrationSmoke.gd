extends Node

const WARDEN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/Warden.tscn")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

const CHAIN_SWING: int = 0
const QUICK_THRUST: int = 1

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var warden: Node = WARDEN_SCENE.instantiate()
	warden.name = "WardenV2MigrationSmokeEnemy"
	add_child(warden)
	await get_tree().process_frame
	warden.set_physics_process(false)

	HUSHIRO_ENEMY_CONTRACT.apply(warden, "warden")
	await get_tree().physics_frame

	_expect(warden.has_method("has_v2_warden_runtime"), "canonical Warden is not routed through WardenV2")
	if warden.has_method("has_v2_warden_runtime"):
		_expect(bool(warden.call("has_v2_warden_runtime")), "canonical Warden failed to attach shared V2 components")
	_expect(warden.get_node_or_null("EnemyCombatResponseRuntime") != null, "Warden missing EnemyCombatResponseRuntime")
	_expect(warden.get_node_or_null("CombatActionRunner") != null, "Warden missing CombatActionRunner")
	_expect(warden.get_node_or_null("EnemyMotor") != null, "Warden missing EnemyMotor")
	_expect(warden.get_node_or_null("EnemyBrain") != null, "Warden missing EnemyBrain")
	_expect(warden.get_node_or_null("HushiroPostureBreakRuntime") != null, "Warden lost shared Posture/Deathblow runtime")
	_expect(warden.get_node_or_null("PostureBar") != null, "Warden lost canonical PostureBar")

	_expect(int(warden.get("hp")) == 140, "Warden Hushiro Health baseline changed during V2 migration")
	var combat: Node = warden.get_node_or_null("Combat")
	if combat != null:
		var cfg: CombatConfig = combat.get("config") as CombatConfig
		_expect(cfg != null and is_equal_approx(float(cfg.posture_max), 150.0), "Warden canonical Posture max is not 150")
	else:
		_fail("Warden missing CombatController")

	if warden.has_method("uses_legacy_warden_melee_role"):
		_expect(not bool(warden.call("uses_legacy_warden_melee_role")), "Warden still declares legacy melee-role ownership")
	else:
		_fail("Warden missing V2 legacy-role declaration")

	var restraint_value: Variant = warden.call("get_v2_warden_restraint_contract_for_test")
	if restraint_value is Dictionary:
		var restraint: Dictionary = restraint_value as Dictionary
		_expect(str(restraint.get("chain_break_action", "")) == "parry", "Warden restraint no longer uses timed parry escape")
		_expect(int(restraint.get("chain_break_presses", 0)) == 999, "obsolete mash escape became reachable again")
		_expect(is_equal_approx(float(restraint.get("chain_duration", 0.0)), 1.0), "Warden restraint duration changed")
		_expect(is_equal_approx(float(restraint.get("restraint_failure_posture", 0.0)), 25.0), "Warden restraint failure Posture changed")
		_expect(is_equal_approx(float(restraint.get("restraint_parry_stagger", 0.0)), 1.20), "Warden successful restraint parry stagger changed")
	else:
		_fail("Warden restraint validation contract unavailable")

	warden.set("_next_attack_ready", -1.0)
	warden.set("_v2_pressure_retry_until", -1.0)
	warden.set("_restraining", false)
	var scores_value: Variant = warden.call("get_v2_warden_intent_scores_for_test", 10.0, 60.0)
	if scores_value is Dictionary:
		var scores: Dictionary = scores_value as Dictionary
		var attack_score: float = float(scores.get(&"attack", -INF))
		_expect(attack_score > float(scores.get(&"orbit", -INF)), "ready Warden brain does not prioritize offense over orbit")
		_expect(attack_score > float(scores.get(&"guard", -INF)), "ready Warden brain incorrectly prefers guard over control pressure")
	else:
		_fail("Warden V2 intent scores unavailable")

	var request_value: Variant = warden.call("get_v2_warden_pressure_request_for_test", CHAIN_SWING, 20.0)
	if request_value is Dictionary:
		var request: Dictionary = request_value as Dictionary
		_expect(str(request.get("attack_id", "")) == "warden_chain_restrain", "Warden control pressure lost restraint identity")
		_expect(str(request.get("pressure_channel", "")) == "control", "Warden chain is not authored as control pressure")
		_expect(str(request.get("severity", "")) == "perilous", "Warden restraint should reserve perilous pressure")
		_expect(float(request.get("threat_cost", 0.0)) >= 1.50, "Warden restraint pressure is under-costed")
		_expect(is_equal_approx(float(request.get("impact_delay", 0.0)), float(warden.get("chain_windup"))), "Warden restraint impact timing no longer matches chain windup")
		_expect(float(request.get("active_duration", 0.0)) >= float(warden.get("chain_duration")), "Warden control reservation does not survive the restraint window")
	else:
		_fail("Warden V2 pressure request unavailable")

	warden.call("begin_v2_warden_action_for_test", CHAIN_SWING)
	_expect(str(warden.call("get_v2_warden_action_phase")) == "STARTUP", "Warden chain did not enter CombatActionRunner STARTUP")
	var runner: Node = warden.get_node_or_null("CombatActionRunner")
	if runner != null:
		runner.call("tick", float(warden.get("chain_windup")) * 0.70)
		_expect(str(warden.call("get_v2_warden_action_phase")) == "COMMITTED", "Warden chain did not cross explicit commitment")
		_expect(not bool(runner.call("allows_target_tracking")), "committed Warden chain can still track the target")

	var response: Node = warden.get_node_or_null("EnemyCombatResponseRuntime")
	if response != null:
		var profile_value: Variant = response.get("profile")
		if profile_value is EnemyCombatResponseProfile:
			var profile: EnemyCombatResponseProfile = profile_value as EnemyCombatResponseProfile
			_expect(profile.profile_id == "warden_v2", "Warden attached the wrong response profile")
			_expect(profile.guard_duration <= 0.25, "Warden guard became a long defensive stall")
			_expect(profile.guard_cooldown >= 1.50, "Warden guard cooldown is too short for a support/control enemy")
			_expect(profile.neutral_poise_required == 1, "neutral Warden gained hidden armor")
			_expect(profile.committed_poise_required == 2, "committed Warden melee lost authored Poise")
		else:
			_fail("Warden response runtime has no authored profile")
	else:
		_fail("Warden response runtime unavailable for profile assertion")

	_expect(bool(warden.call("should_v2_warden_interrupt_for_test", CHAIN_SWING, 1, false)), "light clean hit cannot interrupt neutral/early Warden")
	_expect(not bool(warden.call("should_v2_warden_interrupt_for_test", CHAIN_SWING, 1, true)), "light hit incorrectly interrupts committed Warden chain")
	_expect(not bool(warden.call("should_v2_warden_interrupt_for_test", CHAIN_SWING, 2, true)), "medium Poise hit incorrectly interrupts identity-defining committed chain")
	_expect(bool(warden.call("should_v2_warden_interrupt_for_test", CHAIN_SWING, 3, true)), "strong Poise hit cannot interrupt committed Warden chain")
	_expect(bool(warden.call("should_v2_warden_interrupt_for_test", QUICK_THRUST, 2, true)), "ordinary committed Warden melee requires chain-level Poise")

	if warden.has_method("has_v2_warden_pressure_runtime"):
		_expect(bool(warden.call("has_v2_warden_pressure_runtime")), "Warden cannot reach PressureDirectorV2")

	warden.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[WardenV2MigrationSmoke] PASS - control brain | perilous restraint pressure | explicit commitment | stateful Poise | short guard | restraint/Posture preserved")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[WardenV2MigrationSmoke] %s" % failure)
	print("[WardenV2MigrationSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
