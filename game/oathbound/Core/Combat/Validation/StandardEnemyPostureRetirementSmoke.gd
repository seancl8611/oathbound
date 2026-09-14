extends Node

const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")
const COMBAT_CONTROLLER = preload("res://Utility/CombatController.gd")
const COMBAT_CONFIG = preload("res://Utility/CombatConfig.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	for enemy_type: String in ["hollow", "hound", "archer", "swordsman", "bilemass", "warden"]:
		await _verify_standard_enemy(enemy_type)
	_finish()


func _verify_standard_enemy(enemy_type: String) -> void:
	var host := Node2D.new()
	host.name = "PostureRetirement_%s" % enemy_type
	add_child(host)

	var combat: Node = COMBAT_CONTROLLER.new()
	combat.name = "Combat"
	combat.set("config", COMBAT_CONFIG.new())
	host.add_child(combat)
	await get_tree().process_frame

	HUSHIRO_ENEMY_CONTRACT.apply(host, enemy_type, true)
	await get_tree().process_frame

	_expect(bool(host.get_meta("oathbound_standard_posture_retired", false)), "%s missing standard-posture retirement metadata" % enemy_type)
	var retirement_runtime: Node = host.get_node_or_null("HushiroStandardNoPostureRuntime")
	_expect(retirement_runtime != null, "%s did not attach no-Posture runtime" % enemy_type)
	if retirement_runtime != null and retirement_runtime.has_method("is_posture_retired"):
		_expect(bool(retirement_runtime.call("is_posture_retired")), "%s no-Posture runtime is not active" % enemy_type)

	_expect(host.get_node_or_null("HushiroPostureBreakRuntime") == null, "%s still owns standard posture-break runtime" % enemy_type)
	_expect(host.get_node_or_null("HushiroPostureReadabilityRuntime") == null, "%s still owns standard posture readability runtime" % enemy_type)

	var break_count: Array[int] = [0]
	combat.posture_broken.connect(func(_duration: float) -> void:
		break_count[0] += 1
	)

	combat.call("add_posture", 100000.0)
	_expect(is_zero_approx(float(combat.call("get_posture"))), "%s accumulated direct standard Posture" % enemy_type)
	_expect(break_count[0] == 0, "%s direct Posture mutation still emitted posture_broken" % enemy_type)

	combat.call("begin_attack_event", {
		"posture_damage": 100000.0,
		"block_posture_damage": 100000.0,
	})
	combat.call("notify_got_hit", {"parried": false})
	combat.call("end_attack_event")
	_expect(is_zero_approx(float(combat.call("get_posture"))), "%s accumulated canonical standard Posture" % enemy_type)
	_expect(break_count[0] == 0, "%s canonical hit still emitted posture_broken" % enemy_type)

	combat.call("notify_got_hit", {"parried": true})
	_expect(is_zero_approx(float(combat.call("get_posture"))), "%s accumulated parry Posture after retirement" % enemy_type)
	_expect(break_count[0] == 0, "%s parry compatibility path still emitted posture_broken" % enemy_type)

	host.queue_free()
	await get_tree().process_frame


func _finish() -> void:
	if _failures.is_empty():
		print("[StandardEnemyPostureRetirementSmoke] PASS - six standard roles | no Posture accumulation | no posture break | no standard Posture UI runtime")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[StandardEnemyPostureRetirementSmoke] %s" % failure)
	print("[StandardEnemyPostureRetirementSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
