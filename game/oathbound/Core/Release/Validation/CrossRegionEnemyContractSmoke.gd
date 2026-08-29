extends Node

## Cross-region regression for the shared enemy CombatController compatibility bridge.
## Region 2's imported elites/bosses and parts of Region 3 still use the older
## notify_got_hit() receiver contract, while newer Kagutsuchi enemies already call
## add_posture() explicitly. Both generations must resolve one canonical Posture pass.

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_test_legacy_canonical_hit_fallback()
	_test_modern_receiver_stays_one_pass()
	_test_canonical_block_fallback()
	_test_explicit_parry_is_not_doubled()
	_test_notify_only_parry_compatibility()
	_test_receiver_contract_inventory()

	if not _failures.is_empty():
		for failure: String in _failures:
			push_error("[CrossRegionEnemyContractSmoke] %s" % failure)
		get_tree().quit(1)
		return

	print("[CrossRegionEnemyContractSmoke] PASS - canonical legacy hit fallback | modern one-pass posture | canonical block posture | explicit parry idempotence | notify-only parry compatibility | Region 2/3 receiver inventory")
	get_tree().quit(0)


func _test_legacy_canonical_hit_fallback() -> void:
	var combat := _new_controller(CombatConfig.create_boss_config())
	combat.begin_attack_event(_attack_event(21, 36.0, 14.0))
	combat.notify_got_hit({"damage": 21, "blocked": false})
	_assert_close(combat.get_posture(), 36.0, "legacy notify-only receiver must consume authored 36 Posture exactly once")
	combat.end_attack_event()
	_destroy_controller(combat)


func _test_modern_receiver_stays_one_pass() -> void:
	var combat := _new_controller(CombatConfig.create_enemy_config())
	combat.begin_attack_event(_attack_event(12, 16.0, 7.0))
	# The fallback argument is deliberately wrong. During a canonical transaction,
	# add_posture() must resolve the authored value and mark the event consumed.
	combat.add_posture(999.0)
	combat.notify_got_hit({"damage": 12, "blocked": false})
	_assert_close(combat.get_posture(), 16.0, "modern add_posture + notify must remain a single authored Posture pass")
	combat.end_attack_event()
	_destroy_controller(combat)


func _test_canonical_block_fallback() -> void:
	var combat := _new_controller(CombatConfig.create_boss_config())
	combat.start_block()
	combat.begin_attack_event(_attack_event(9, 18.0, 6.0))
	combat.notify_got_hit({"damage": 0, "blocked": true})
	_assert_close(combat.get_posture(), 6.0, "legacy blocked receiver must consume authored block Posture rather than hit Posture")
	combat.end_attack_event()
	combat.end_block()
	_destroy_controller(combat)


func _test_explicit_parry_is_not_doubled() -> void:
	var combat := _new_controller(CombatConfig.create_boss_config())
	combat.set_posture(22.0)
	combat.notify_got_hit({"damage": 0, "parried": true})
	_assert_close(combat.get_posture(), 22.0, "manual set_posture parry must not receive a second generic parry spike")

	combat.reset_posture()
	# Synchronize the prior explicit mutation with a normal notification, then exercise
	# the add_posture flavor used by Court Sentinel and other modern receivers.
	combat.notify_got_hit({"damage": 0, "blocked": false})
	combat.add_posture(20.0)
	combat.notify_got_hit({"damage": 0, "parried": true})
	_assert_close(combat.get_posture(), 20.0, "manual add_posture parry must not receive a second generic parry spike")
	_destroy_controller(combat)


func _test_notify_only_parry_compatibility() -> void:
	var combat := _new_controller(CombatConfig.create_miniboss_config())
	combat.notify_got_hit({"damage": 0, "parried": true})
	_assert_close(combat.get_posture(), combat.config.parry_posture_spike, "notify-only legacy parry must retain its configured compatibility spike")
	_destroy_controller(combat)


func _test_receiver_contract_inventory() -> void:
	# These are the higher-risk later-region scripts found by the audit. Preloading them
	# here makes this smoke a compile/load guard while the direct controller assertions
	# above lock the stale-vs-modern posture semantics they depend on.
	var scripts: Array[Script] = [
		preload("res://Enemy/Area 2/Minibosses/embered_pilgrim.gd"),
		preload("res://Enemy/Area 2/Minibosses/rotwood_host.gd"),
		preload("res://Enemy/Area 2/Boss/briarthorn.gd"),
		preload("res://Enemy/Area 2/Boss/rootfang.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Standard/CourtGuard.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Standard/CourtCaster.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Standard/CourtSentinel.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Standard/EliteDefender.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Standard/HollowVessel.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Minibosses/EternalSwordsman.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotusHeart.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotusStalk.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogun.gd"),
		preload("res://Regions/Kagutsuchi/Enemies/Summons/Spillborn.gd"),
	]
	for script: Script in scripts:
		if script == null:
			_failures.append("later-region receiver script failed to preload")


func _new_controller(cfg: CombatConfig) -> CombatController:
	var host := Node.new()
	host.name = "ContractHost"
	add_child(host)
	var combat := CombatController.new()
	combat.config = cfg
	host.add_child(combat)
	return combat


func _destroy_controller(combat: CombatController) -> void:
	if combat == null or not is_instance_valid(combat):
		return
	var host := combat.get_parent()
	if host != null and is_instance_valid(host):
		host.queue_free()


func _attack_event(health_damage: int, posture_damage: float, block_posture_damage: float) -> Dictionary:
	return {
		"health_damage": health_damage,
		"posture_damage": posture_damage,
		"block_posture_damage": block_posture_damage,
		"stagger_level": 0,
		"proc_coefficient": 1.0,
		"attack_id": "cross_region_contract_smoke",
	}


func _assert_close(actual: float, expected: float, message: String) -> void:
	if absf(actual - expected) > 0.001:
		_failures.append("%s (expected %.3f, got %.3f)" % [message, expected, actual])
