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
	_check_area1_role_poise(runtime, failures)
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


func _check_area1_role_poise(runtime: Node, failures: Array[String]) -> void:
	# Canonical V1 migration powers: stagger 0 -> power 1, stagger 1 -> power 2.
	# Explicit poise_damage is the future-facing seam for power 3+ Techniques/Prosthetics.
	var light := Area2D.new()
	light.set_meta("stagger_level", 0)
	add_child(light)
	var heavy := Area2D.new()
	heavy.set_meta("stagger_level", 1)
	add_child(heavy)
	var overpower := Area2D.new()
	overpower.set_meta("poise_damage", 3)
	add_child(overpower)

	var normal_response: Dictionary = {"heavy": false}
	var heavy_response: Dictionary = {"heavy": true}

	# Light/fodder/ranged bodies: baseline sword pressure remains authoritative even
	# after their attack has committed. This is the hunter-flow baseline.
	for light_profile: Variant in [
		PROFILE_SCRIPT.hollow_v2(),
		PROFILE_SCRIPT.blighted_hound_v2(),
		PROFILE_SCRIPT.corrupted_archer_v2(),
	]:
		runtime.call("configure", self, light_profile)
		if not bool(runtime.call("should_interrupt", light, normal_response, true)):
			var light_profile_id: String = str(light_profile.get("profile_id"))
			failures.append("power 1 should interrupt committed light profile %s" % light_profile_id)

	# Standard committed bodies preserve a stronger commitment layer: light pressure
	# still damages them, while the baseline Heavy (power 2) can force the interruption.
	for standard_profile: Variant in [
		PROFILE_SCRIPT.corrupted_swordsman_v2(),
		PROFILE_SCRIPT.cellar_bilemass_v2(),
	]:
		runtime.call("configure", self, standard_profile)
		var standard_profile_id: String = str(standard_profile.get("profile_id"))
		if bool(runtime.call("should_interrupt", light, normal_response, true)):
			failures.append("power 1 should not interrupt committed standard profile %s" % standard_profile_id)
		if not bool(runtime.call("should_interrupt", heavy, heavy_response, true)):
			failures.append("power 2 should interrupt committed standard profile %s" % standard_profile_id)

	# Warden is the Area 1 brute/control exception. Light basic attacks still deal their
	# normal Health/Posture but cannot flinch it; Heavy can interrupt neutral behavior;
	# committed actions require an explicitly stronger power-3 impact.
	var warden_profile: Variant = PROFILE_SCRIPT.warden_v2()
	runtime.call("configure", self, warden_profile)
	if bool(runtime.call("should_interrupt", light, normal_response, false)):
		failures.append("power 1 should not interrupt a neutral Warden")
	if not bool(runtime.call("should_interrupt", heavy, heavy_response, false)):
		failures.append("power 2 should interrupt a neutral Warden")
	if bool(runtime.call("should_interrupt", heavy, heavy_response, true)):
		failures.append("power 2 should not interrupt a committed Warden")
	if not bool(runtime.call("should_interrupt", overpower, heavy_response, true)):
		failures.append("explicit power 3 should interrupt a committed Warden")

	# Poise retuning must not silently alter the separately authored Warden guard break.
	if int(warden_profile.get("guard_break_poise_required")) != 2:
		failures.append("Warden guard-break threshold changed with flinch Poise tier")

	light.queue_free()
	heavy.queue_free()
	overpower.queue_free()


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return
	for failure: String in failures:
		push_error("[EnemyCombatResponseSmoke] " + failure)
	get_tree().quit(1)
