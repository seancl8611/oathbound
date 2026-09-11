extends Node

const PROFILE_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseProfile.gd")
const RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")
const PASS_LINE := "[EnemyCombatResponseSmoke] PASS - authored guard window | partial guard Health | state poise"


func _ready() -> void:
	var failures: Array[String] = []
	var runtime_value: Variant = RUNTIME_SCRIPT.new()
	if not (runtime_value is Node):
		failures.append("could not create response runtime")
		_finish(failures)
		return
	var runtime: Node = runtime_value as Node
	add_child(runtime)

	var profile_value: Variant = PROFILE_SCRIPT.corrupted_swordsman_v2()
	if profile_value == null:
		failures.append("could not create swordsman response profile")
		_finish(failures)
		return
	runtime.call("configure", self, profile_value)

	_check_guard(runtime, failures)
	_check_guard_conversion(runtime, failures)
	_check_poise(runtime, failures)
	_finish(failures)


func _check_guard(runtime: Node, failures: Array[String]) -> void:
	if not bool(runtime.call("tick_guard", 1.0, true)):
		failures.append("guard did not start from an authored request")
	if not bool(runtime.call("tick_guard", 1.20, true)):
		failures.append("guard ended before its authored duration")
	if bool(runtime.call("tick_guard", 1.40, true)):
		failures.append("guard did not expire after its authored duration")
	if bool(runtime.call("tick_guard", 2.0, true)):
		failures.append("guard ignored its cooldown")
	if not bool(runtime.call("tick_guard", 2.60, true)):
		failures.append("guard did not become available after cooldown")


func _check_guard_conversion(runtime: Node, failures: Array[String]) -> void:
	var hp_value: Variant = runtime.call("guarded_health_damage", 20)
	if int(hp_value) != 7:
		failures.append("Swordsman guard should pass 35%% Health damage (20 -> 7)")
	var base_response: Dictionary = {"posture_on_block": 10.0, "heavy": false}
	var decorated_value: Variant = runtime.call("decorate_guard_response", base_response)
	if not (decorated_value is Dictionary):
		failures.append("guard response decoration did not return a Dictionary")
		return
	var decorated: Dictionary = decorated_value as Dictionary
	if absf(float(decorated.get("posture_on_block", 0.0)) - 10.0) > 0.001:
		failures.append("Swordsman V2 slice should preserve canonical block-Posture authoring")


func _check_poise(runtime: Node, failures: Array[String]) -> void:
	var light := Area2D.new()
	light.set_meta("stagger_level", 0)
	add_child(light)
	var heavy := Area2D.new()
	heavy.set_meta("stagger_level", 1)
	add_child(heavy)

	var normal_response: Dictionary = {"heavy": false}
	if not bool(runtime.call("should_interrupt", light, normal_response, false)):
		failures.append("light hit should interrupt a neutral Swordsman")
	if bool(runtime.call("should_interrupt", light, normal_response, true)):
		failures.append("light hit should not interrupt a committed Swordsman")
	if not bool(runtime.call("should_interrupt", heavy, {"heavy": true}, true)):
		failures.append("heavy hit should interrupt a committed Swordsman")

	# Restart guard after its current window/cooldown and verify a strong impact breaks it.
	runtime.call("force_guard_off", 3.0, 0.0, "smoke_setup")
	if not bool(runtime.call("tick_guard", 3.01, true)):
		failures.append("guard could not restart for break validation")
	elif not bool(runtime.call("on_guard_contact", 3.02, heavy, {"heavy": true})):
		failures.append("strong poise hit did not break active guard")
	elif bool(runtime.call("is_guard_active")):
		failures.append("guard remained active after break")

	light.queue_free()
	heavy.queue_free()


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return
	for failure: String in failures:
		push_error("[EnemyCombatResponseSmoke] " + failure)
	get_tree().quit(1)
