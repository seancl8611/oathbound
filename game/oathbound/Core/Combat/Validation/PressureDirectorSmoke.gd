extends Node

const PRESSURE_DIRECTOR_SCRIPT = preload("res://Core/Combat/PressureDirectorV2.gd")
const SWORDSMAN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	_test_window_scheduler()
	await _test_attackdir_compatibility()
	await _test_swordsman_integration()
	_finish()


func _test_window_scheduler() -> void:
	var value: Variant = PRESSURE_DIRECTOR_SCRIPT.new()
	if not (value is PressureDirectorV2):
		_fail("could not instantiate PressureDirectorV2")
		return
	var director: PressureDirectorV2 = value as PressureDirectorV2
	add_child(director)
	var a := Node2D.new()
	var b := Node2D.new()
	var c := Node2D.new()
	var d := Node2D.new()
	add_child(a)
	add_child(b)
	add_child(c)
	add_child(d)
	var now: float = Time.get_ticks_msec() * 0.001

	var first: Dictionary = director.request_threat(a, {
		"attack_id": "a",
		"impact_at": now + 1.00,
		"impact_delay": 1.00,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(bool(first.get("admitted", false)), "first normal threat was not admitted")

	# Windups may overlap. The second attack is admitted because its dangerous impact
	# lands outside the first normal spacing window.
	var separated: Dictionary = director.request_threat(b, {
		"attack_id": "b",
		"impact_at": now + 1.35,
		"impact_delay": 1.35,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(bool(separated.get("admitted", false)), "separated future impact was incorrectly serialized")
	_expect(director.reservation_count() == 2, "director did not retain concurrent separated threats")

	var overlap: Dictionary = director.request_threat(c, {
		"attack_id": "c",
		"impact_at": now + 1.05,
		"impact_delay": 1.05,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(not bool(overlap.get("admitted", true)), "near-simultaneous normal impact was admitted")
	_expect(str(overlap.get("reason", "")) in ["impact_spacing", "pressure_budget"], "overlap denial did not report a pressure reason")

	director.release_threat(a, str(first.get("reservation_id", "")), "test_release")
	var after_release: Dictionary = director.request_threat(c, {
		"attack_id": "c",
		"impact_at": now + 1.05,
		"impact_delay": 1.05,
		"active_duration": 0.15,
		"severity": "normal",
		"threat_cost": 1.0,
	})
	_expect(bool(after_release.get("admitted", false)), "released impact window did not become available")

	var perilous: Dictionary = director.request_threat(d, {
		"attack_id": "d_perilous",
		"impact_at": now + 1.28,
		"impact_delay": 1.28,
		"active_duration": 0.18,
		"severity": "perilous",
		"threat_cost": 1.5,
	})
	_expect(not bool(perilous.get("admitted", true)), "perilous threat ignored its larger spacing requirement")

	director.queue_free()
	a.queue_free()
	b.queue_free()
	c.queue_free()
	d.queue_free()


func _test_attackdir_compatibility() -> void:
	var attack_dir: Node = get_node_or_null("/root/AttackDir")
	_expect(attack_dir != null, "AttackDir autoload missing")
	if attack_dir == null:
		return
	_expect(attack_dir.has_method("request_pressure_threat"), "AttackDir missing V2 pressure facade")
	_expect(attack_dir.get_node_or_null("PressureDirectorV2") != null, "AttackDir did not install shared PressureDirectorV2")
	if not attack_dir.has_method("request_pressure_threat"):
		return

	var legacy := Node2D.new()
	legacy.name = "LegacyPressureBlocker"
	add_child(legacy)
	var migrated := Node2D.new()
	migrated.name = "MigratedPressureRequester"
	add_child(migrated)
	HUSHIRO_ENEMY_CONTRACT.apply_pressure_metadata(migrated, "swordsman")

	# Compatibility is bidirectional: an existing legacy melee attack blocks a new V2
	# reservation, and once V2 is admitted a different legacy attacker cannot enter an
	# unscheduled damaging role until that reservation is gone.
	var role_granted: bool = bool(attack_dir.call("request_role", legacy, "melee_attack"))
	_expect(role_granted, "legacy melee role was not available in clean test state")
	if role_granted:
		var now: float = Time.get_ticks_msec() * 0.001
		var result_value: Variant = attack_dir.call("request_pressure_threat", migrated, {
			"attack_id": "migration_guard",
			"impact_at": now + 0.70,
			"impact_delay": 0.70,
			"severity": "normal",
			"active_duration": 0.12,
		})
		_expect(result_value is Dictionary, "AttackDir pressure facade returned invalid response")
		if result_value is Dictionary:
			var result: Dictionary = result_value as Dictionary
			_expect(not bool(result.get("admitted", true)), "V2 pressure bypassed active legacy melee holder")
			_expect(str(result.get("reason", "")) == "legacy_melee_active", "legacy compatibility denial used wrong reason")
		attack_dir.call("release_role", legacy, "melee_attack")

	var v2_now: float = Time.get_ticks_msec() * 0.001
	var admitted_value: Variant = attack_dir.call("request_pressure_threat", migrated, {
		"attack_id": "v2_then_legacy_guard",
		"impact_at": v2_now + 0.85,
		"impact_delay": 0.85,
		"severity": "normal",
		"active_duration": 0.12,
		"threat_cost": 1.0,
	})
	_expect(admitted_value is Dictionary, "V2-first compatibility request returned invalid response")
	if admitted_value is Dictionary:
		var admitted: Dictionary = admitted_value as Dictionary
		_expect(bool(admitted.get("admitted", false)), "clean V2 compatibility request was not admitted")
		if bool(admitted.get("admitted", false)):
			var own_compat_role: bool = bool(attack_dir.call("request_role", migrated, "dog_lunge"))
			_expect(own_compat_role, "V2 reservation owner deadlocked against its inherited compatibility role")
			if own_compat_role:
				attack_dir.call("release_role", migrated, "dog_lunge")

			var late_legacy_melee: bool = bool(attack_dir.call("request_role", legacy, "melee_attack"))
			var late_legacy_ranged: bool = bool(attack_dir.call("request_role", legacy, "ranged_attack"))
			_expect(not late_legacy_melee, "legacy melee role entered after V2 pressure was already admitted")
			_expect(not late_legacy_ranged, "legacy ranged role entered after V2 pressure was already admitted")
			if late_legacy_melee:
				attack_dir.call("release_role", legacy, "melee_attack")
			if late_legacy_ranged:
				attack_dir.call("release_role", legacy, "ranged_attack")
			attack_dir.call("release_pressure_threat", migrated, str(admitted.get("reservation_id", "")), "compatibility_smoke")

	# Hushiro's contract supplies generic role metadata. Close-pressure actors count
	# toward crowd frontage; ranged/hazard actors do not. Both are migrated V2 actors
	# and therefore must be invisible to the old single-turn stall nudge.
	var archer := Node2D.new()
	archer.name = "MetadataArcher"
	add_child(archer)
	HUSHIRO_ENEMY_CONTRACT.apply_pressure_metadata(archer, "archer")
	var bilemass := Node2D.new()
	bilemass.name = "MetadataBilemass"
	add_child(bilemass)
	HUSHIRO_ENEMY_CONTRACT.apply_pressure_metadata(bilemass, "bilemass")

	_expect(bool(attack_dir.call("_counts_toward_close_frontline", migrated)), "Swordsman metadata did not count as close-frontline pressure")
	_expect(not bool(attack_dir.call("_counts_toward_close_frontline", archer)), "Archer metadata still consumed close-frontline pressure")
	_expect(not bool(attack_dir.call("_counts_toward_close_frontline", bilemass)), "Bilemass metadata still consumed close-frontline pressure")
	_expect(bool(attack_dir.call("_counts_toward_close_frontline", legacy)), "untagged legacy actor lost default frontline compatibility")
	_expect(bool(attack_dir.call("_uses_v2_pressure_cadence", migrated)), "migrated Swordsman metadata did not disable legacy stall cadence")
	_expect(bool(attack_dir.call("_uses_v2_pressure_cadence", archer)), "migrated Archer metadata did not disable legacy stall cadence")
	_expect(not bool(attack_dir.call("_uses_v2_pressure_cadence", legacy)), "untagged legacy actor was incorrectly classified as V2 cadence")

	# Prove the inherited stall-prevention search can still rescue a true legacy actor
	# in a mixed room without selecting the nearer migrated V2 actor.
	var player := Node2D.new()
	player.name = "CompatibilityPlayer"
	player.add_to_group("player")
	add_child(player)
	var selected_player_value: Variant = attack_dir.call("_get_player")
	var selected_player: Node2D = selected_player_value as Node2D if selected_player_value is Node2D else player
	migrated.global_position = selected_player.global_position + Vector2(8.0, 0.0)
	legacy.global_position = selected_player.global_position + Vector2(18.0, 0.0)
	migrated.add_to_group("enemy")
	legacy.add_to_group("enemy")
	var stall_candidate_value: Variant = attack_dir.call("_closest_engaged_enemy")
	var stall_candidate: Node = stall_candidate_value as Node if stall_candidate_value is Node else null
	_expect(stall_candidate == legacy, "legacy stall-prevention search selected migrated V2 actor instead of legacy candidate")
	migrated.remove_from_group("enemy")
	legacy.remove_from_group("enemy")
	player.remove_from_group("player")

	attack_dir.call("release_all_for", legacy)
	attack_dir.call("release_all_for", migrated)
	legacy.queue_free()
	migrated.queue_free()
	archer.queue_free()
	bilemass.queue_free()
	player.queue_free()


func _test_swordsman_integration() -> void:
	var target := CharacterBody2D.new()
	target.name = "PressureTarget"
	target.add_to_group("player")
	target.global_position = Vector2(70.0, 0.0)
	add_child(target)
	var enemy: Node = SWORDSMAN_SCENE.instantiate()
	if enemy == null:
		_fail("could not instantiate canonical Corrupted Swordsman")
		target.queue_free()
		return
	enemy.name = "PressureSwordsman"
	add_child(enemy)
	await get_tree().process_frame
	if enemy.has_method("set_physics_process"):
		enemy.set_physics_process(false)

	_expect(enemy.has_method("has_v2_pressure_runtime"), "canonical Swordsman is not routed through pressure adapter")
	if enemy.has_method("has_v2_pressure_runtime"):
		_expect(bool(enemy.call("has_v2_pressure_runtime")), "canonical Swordsman cannot reach shared pressure runtime")
	_expect(enemy.has_method("has_v2_enemy_brain_runtime") and bool(enemy.call("has_v2_enemy_brain_runtime")), "Swordsman lost EnemyBrain")
	_expect(enemy.has_method("has_v2_action_motor_runtime") and bool(enemy.call("has_v2_action_motor_runtime")), "Swordsman lost ActionRunner/EnemyMotor")
	_expect(enemy.get_node_or_null("PostureBar") != null, "Swordsman lost canonical PostureBar")

	if enemy.has_method("_v2_pressure_request_for_attack"):
		var normal_value: Variant = enemy.call("_v2_pressure_request_for_attack", 0, Time.get_ticks_msec() * 0.001, false)
		_expect(normal_value is Dictionary, "Swordsman could not author a pressure request")
		if normal_value is Dictionary:
			_expect(str((normal_value as Dictionary).get("severity", "")) == "normal", "basic Swordsman attack did not author normal severity")
	else:
		_fail("Swordsman missing pressure request authoring surface")

	if is_instance_valid(enemy):
		enemy.queue_free()
	if is_instance_valid(target):
		target.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("[PressureDirectorSmoke] PASS - overlapping windups | spaced impacts | perilous safety | legacy compatibility | Swordsman integration | bidirectional V2 compatibility | role-aware crowd filters")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[PressureDirectorSmoke] %s" % failure)
	print("[PressureDirectorSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
