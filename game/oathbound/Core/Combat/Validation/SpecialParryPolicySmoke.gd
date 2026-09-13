extends Node

const POLICY = preload("res://Core/Combat/OathboundParryPolicy.gd")
const PASS_LINE: String = "[SpecialParryPolicySmoke] PASS - ordinary default off | legacy parryable ignored | explicit special opt-in | perilous compatibility | explicit opt-out"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame

	var ordinary := Area2D.new()
	ordinary.name = "OrdinaryAttack"
	_expect(not POLICY.is_special_parry_attack(ordinary, "melee"), "ordinary melee defaulted to parryable")

	ordinary.set_meta("parryable", true)
	_expect(not POLICY.is_special_parry_attack(ordinary, "melee"), "legacy parryable metadata opted ordinary attack into special parry")

	ordinary.set_meta("special_parry", true)
	_expect(POLICY.is_special_parry_attack(ordinary, "melee"), "explicit special_parry metadata did not opt attack in")

	var perilous := Area2D.new()
	perilous.name = "LegacyPerilousAttack"
	_expect(POLICY.is_special_parry_attack(perilous, "perilous"), "perilous compatibility attack lost special parry")

	perilous.set_meta("special_parry", false)
	_expect(not POLICY.is_special_parry_attack(perilous, "perilous"), "explicit special_parry=false did not override compatibility classification")

	var owner_special := Node2D.new()
	owner_special.set_meta("oathbound_special_parry", true)
	_expect(POLICY.is_special_parry_attack(owner_special, "melee"), "owner-level migration metadata did not opt special in")

	ordinary.free()
	perilous.free()
	owner_special.free()
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[SpecialParryPolicySmoke] %s" % failure)
	print("[SpecialParryPolicySmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
