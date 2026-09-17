extends Node

const PRESSURE_DIRECTOR_SCRIPT = preload("res://Core/Combat/PressureDirectorV2.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_verify_active_window_spacing()
	_verify_window_aware_budget()

	if not _failures.is_empty():
		for failure: String in _failures:
			push_error("[PressureDirectorWindowFairnessSmoke] %s" % failure)
		get_tree().quit(1)
		return

	print("[PressureDirectorWindowFairnessSmoke] PASS - active-window spacing | window-aware pressure budget | release cleanup")
	get_tree().quit(0)


func _verify_active_window_spacing() -> void:
	var director: PressureDirectorV2 = _new_director()
	var first_enemy := Node.new()
	var second_enemy := Node.new()
	add_child(first_enemy)
	add_child(second_enemy)

	var now: float = Time.get_ticks_msec() * 0.001
	var first: Dictionary = director.request_threat(first_enemy, {
		"attack_id": "long_melee",
		"impact_delay": 0.20,
		"impact_at": now + 0.20,
		"active_duration": 0.30,
		"severity": "normal",
		"threat_cost": 0.50,
	})
	_expect(bool(first.get("admitted", false)), "first spacing fixture threat should be admitted")

	# The second impact begins 0.25 s after the first, which satisfied the old
	# timestamp-only 0.24 s rule. The first hit remains dangerous until +0.50 s,
	# however, so the full-window policy must delay it.
	var second: Dictionary = director.request_threat(second_enemy, {
		"attack_id": "followup_melee",
		"impact_delay": 0.45,
		"impact_at": now + 0.45,
		"active_duration": 0.05,
		"severity": "normal",
		"threat_cost": 0.50,
	})
	_expect(not bool(second.get("admitted", false)), "overlapping active window should be denied")
	_expect(str(second.get("reason", "")) == "impact_spacing", "active-window denial should report impact_spacing")
	_expect(float(second.get("retry_at", 0.0)) > now + 0.25, "active-window denial should return a future retry time")

	var first_id: String = str(first.get("reservation_id", ""))
	director.release_threat(first_enemy, first_id, "smoke_release")
	var after_release_now: float = Time.get_ticks_msec() * 0.001
	var after_release: Dictionary = director.request_threat(second_enemy, {
		"attack_id": "followup_after_release",
		"impact_delay": 0.10,
		"impact_at": after_release_now + 0.10,
		"active_duration": 0.05,
		"severity": "normal",
		"threat_cost": 0.50,
	})
	_expect(bool(after_release.get("admitted", false)), "released reservation should no longer block a threat")

	director.queue_free()
	first_enemy.queue_free()
	second_enemy.queue_free()


func _verify_window_aware_budget() -> void:
	var director: PressureDirectorV2 = _new_director()
	director.normal_spacing = 0.01
	director.heavy_spacing = 0.01
	director.perilous_spacing = 0.01
	director.budget_window = 0.22
	director.max_near_impact_cost = 1.0

	var first_enemy := Node.new()
	var second_enemy := Node.new()
	add_child(first_enemy)
	add_child(second_enemy)

	var now: float = Time.get_ticks_msec() * 0.001
	var first: Dictionary = director.request_threat(first_enemy, {
		"attack_id": "budget_anchor",
		"impact_delay": 0.20,
		"impact_at": now + 0.20,
		"active_duration": 0.25,
		"severity": "normal",
		"threat_cost": 0.60,
	})
	_expect(bool(first.get("admitted", false)), "first budget fixture threat should be admitted")

	# Impact timestamps are 0.27 s apart, outside the old 0.22 s center-point budget
	# check. The first danger window ends at +0.45 s, placing the second +0.47 s impact
	# inside the budget neighborhood of the live contact window.
	var second: Dictionary = director.request_threat(second_enemy, {
		"attack_id": "budget_overlap",
		"impact_delay": 0.47,
		"impact_at": now + 0.47,
		"active_duration": 0.02,
		"severity": "normal",
		"threat_cost": 0.60,
	})
	_expect(not bool(second.get("admitted", false)), "near active-window pressure should respect the shared budget")
	_expect(str(second.get("reason", "")) == "pressure_budget", "budget-only denial should report pressure_budget")

	director.queue_free()
	first_enemy.queue_free()
	second_enemy.queue_free()


func _new_director() -> PressureDirectorV2:
	var value: Variant = PRESSURE_DIRECTOR_SCRIPT.new()
	if not (value is PressureDirectorV2):
		_failures.append("could not instantiate PressureDirectorV2")
		return null
	var director := value as PressureDirectorV2
	add_child(director)
	return director


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
