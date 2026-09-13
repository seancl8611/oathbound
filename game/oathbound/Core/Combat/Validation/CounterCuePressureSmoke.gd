extends Node

const INDICATOR_SCRIPT = preload("res://Combat/parry_indicator.gd")
const META_FRONTLINE_PRESSURE_BODY: StringName = &"oathbound_frontline_pressure_body"
const PASS_LINE: String = "[CounterCuePressureSmoke] PASS - ordinary cue suppressed | special PressureDirector timing | 0.20 warning | 0.12 parry beat | special-only fallback"

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var director: Node = get_node_or_null("/root/AttackDir")
	if director == null:
		_fail("AttackDir autoload unavailable")
		_finish()
		return
	if not director.has_method("request_pressure_threat") or not director.has_method("get_pressure_director_v2"):
		_fail("AttackDir lost PressureDirectorV2 facade")
		_finish()
		return

	var pressure_value: Variant = director.call("get_pressure_director_v2")
	if not (pressure_value is PressureDirectorV2):
		_fail("PressureDirectorV2 runtime unavailable")
		_finish()
		return
	var pressure: PressureDirectorV2 = pressure_value as PressureDirectorV2
	pressure.reset_for_test()

	await _test_frontline_special_only(director, pressure)
	await _test_non_frontline_special_only(director, pressure)
	pressure.reset_for_test()
	_finish()


func _test_frontline_special_only(director: Node, pressure: PressureDirectorV2) -> void:
	pressure.reset_for_test()
	var enemy := Node2D.new()
	enemy.name = "CounterCueFrontlineEnemy"
	enemy.set_meta(META_FRONTLINE_PRESSURE_BODY, true)
	add_child(enemy)

	var indicator := Node2D.new()
	indicator.name = "ParryIndicator"
	indicator.set_script(INDICATOR_SCRIPT)
	enemy.add_child(indicator)
	await get_tree().process_frame

	var now: float = Time.get_ticks_msec() * 0.001
	var request: Dictionary = {
		"attack_id": "counter_cue_smoke_melee",
		"impact_at": now + 0.18,
		"impact_delay": 0.18,
		"active_duration": 0.12,
		"severity": "normal",
		"threat_cost": 0.5,
	}
	var admission_value: Variant = director.call("request_pressure_threat", enemy, request)
	var admission: Dictionary = admission_value as Dictionary if admission_value is Dictionary else {}
	_expect(bool(admission.get("admitted", false)), "frontline test threat was not admitted")

	# Ordinary attacks no longer advertise a universal parry skill check.
	indicator.call("warn_attack", 0.80, false)
	_expect(not bool(indicator.call("is_special_parry_armed_for_test")), "ordinary frontline attack armed special counter cue")
	_expect(not indicator.visible, "ordinary frontline attack rendered special counter cue")
	_expect(not bool(indicator.call("uses_v2_pressure_timing_for_test")), "ordinary frontline attack consumed counter-cue timing")

	# The same scheduled threat may explicitly opt into the smaller special-counter cue.
	indicator.call("warn_attack", 0.80, true)
	_expect(bool(indicator.call("is_special_parry_armed_for_test")), "special frontline attack did not arm counter cue")
	_expect(bool(indicator.call("uses_v2_pressure_timing_for_test")), "special frontline cue ignored admitted V2 impact timing")
	_expect(indicator.visible, "0.18 s special pre-contact warning is not visible")
	_expect(indicator.scale.is_equal_approx(Vector2.ONE), "V2 special cue changed size instead of staying fixed")

	var early_value: Variant = indicator.call("counter_cue_state_for_remaining_for_test", 0.25)
	var warning_value: Variant = indicator.call("counter_cue_state_for_remaining_for_test", 0.18)
	var parry_value: Variant = indicator.call("counter_cue_state_for_remaining_for_test", 0.10)
	var contact_value: Variant = indicator.call("counter_cue_state_for_remaining_for_test", 0.0)
	_expect(early_value is Dictionary and not bool((early_value as Dictionary).get("warning", true)), "special cue appears earlier than 0.20 s warning lead")
	_expect(warning_value is Dictionary and bool((warning_value as Dictionary).get("warning", false)) and not bool((warning_value as Dictionary).get("parry_beat", true)), "0.18 s special state is not warning-only")
	_expect(parry_value is Dictionary and bool((parry_value as Dictionary).get("warning", false)) and bool((parry_value as Dictionary).get("parry_beat", false)), "0.10 s special state did not expose inner parry beat")
	_expect(contact_value is Dictionary and bool((contact_value as Dictionary).get("expired", false)), "special cue does not expire at predicted contact")

	var reservation_id: String = str(admission.get("reservation_id", ""))
	director.call("release_pressure_threat", enemy, reservation_id, "counter_cue_smoke")
	enemy.queue_free()
	await get_tree().process_frame


func _test_non_frontline_special_only(director: Node, pressure: PressureDirectorV2) -> void:
	pressure.reset_for_test()
	var enemy := Node2D.new()
	enemy.name = "CounterCueSpatialEnemy"
	enemy.set_meta(META_FRONTLINE_PRESSURE_BODY, false)
	add_child(enemy)

	var indicator := Node2D.new()
	indicator.name = "ParryIndicator"
	indicator.set_script(INDICATOR_SCRIPT)
	enemy.add_child(indicator)
	await get_tree().process_frame

	var now: float = Time.get_ticks_msec() * 0.001
	var request: Dictionary = {
		"attack_id": "counter_cue_smoke_spatial",
		"impact_at": now + 0.18,
		"impact_delay": 0.18,
		"active_duration": 0.12,
		"severity": "normal",
		"threat_cost": 0.5,
	}
	var admission_value: Variant = director.call("request_pressure_threat", enemy, request)
	var admission: Dictionary = admission_value as Dictionary if admission_value is Dictionary else {}
	_expect(bool(admission.get("admitted", false)), "non-frontline test threat was not admitted")

	indicator.call("warn_attack", 0.80, false)
	_expect(not bool(indicator.call("is_special_parry_armed_for_test")), "ordinary non-frontline attack armed special cue")
	_expect(not indicator.visible, "ordinary non-frontline attack rendered compatibility cue")

	indicator.call("warn_attack", 0.80, true)
	_expect(bool(indicator.call("is_special_parry_armed_for_test")), "explicit non-frontline special failed to arm fallback cue")
	_expect(not bool(indicator.call("uses_v2_pressure_timing_for_test")), "non-frontline special was incorrectly forced onto frontline timing")
	_expect(indicator.visible, "explicit non-frontline special fallback cue failed to render")

	var reservation_id: String = str(admission.get("reservation_id", ""))
	director.call("release_pressure_threat", enemy, reservation_id, "counter_cue_smoke")
	enemy.queue_free()
	await get_tree().process_frame


func _finish() -> void:
	if _failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[CounterCuePressureSmoke] %s" % failure)
	print("[CounterCuePressureSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
