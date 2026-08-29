extends Node

const PLAYER_SCENE := preload("res://Player/aspect_player.tscn")
const COLLECTOR_SCENE := preload("res://Regions/Hushiro/Enemies/Minibosses/TheCollector.tscn")
const KEEPER_SCENE := preload("res://Regions/Hushiro/Enemies/Bosses/Keeper.tscn")
const DUO_MANAGER_SCRIPT := preload("res://Utility/duo_boss_manager.gd")

var _failed := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var original_area: int = int(RunData.current_area_id)
	RunData.current_area_id = 1

	var player_value: Variant = PLAYER_SCENE.instantiate()
	_expect(player_value is Node2D, "canonical Player could not instantiate")
	if not (player_value is Node2D):
		_finish(original_area)
		return
	var player := player_value as Node2D
	player.position = Vector2.ZERO
	add_child(player)
	await get_tree().process_frame

	await _verify_collector_parry_posture(player)
	await _verify_keeper_contract(player)
	await _verify_duo_manager_area_scope()

	if is_instance_valid(player):
		player.queue_free()
	await get_tree().process_frame
	_finish(original_area)


func _verify_collector_parry_posture(player: Node2D) -> void:
	var value: Variant = COLLECTOR_SCENE.instantiate()
	_expect(value is Node2D, "Collector could not instantiate")
	if not (value is Node2D):
		return
	var collector := value as Node2D
	collector.position = Vector2(30, 0)
	add_child(collector)
	await get_tree().process_frame

	var combat: Node = collector.get_node_or_null("Combat")
	_expect(combat != null, "Collector CombatController missing")
	if combat != null:
		combat.call("set_posture", 0.0)
		var fake_hitbox := Area2D.new()
		fake_hitbox.set_meta("attacker", collector)
		add_child(fake_hitbox)
		player.call("_handle_parry_success", fake_hitbox, collector, "melee", collector.global_position, false)
		await get_tree().process_frame
		var expected: float = float(collector.get("parry_posture_damage"))
		var actual: float = float(combat.call("get_posture"))
		_expect(is_equal_approx(actual, expected), "Collector parry posture expected %.2f, got %.2f" % [expected, actual])
		fake_hitbox.queue_free()

	collector.queue_free()
	await get_tree().process_frame


func _verify_keeper_contract(player: Node2D) -> void:
	var value: Variant = KEEPER_SCENE.instantiate()
	_expect(value is Node2D, "Keeper could not instantiate")
	if not (value is Node2D):
		return
	var keeper := value as Node2D
	keeper.position = Vector2(30, 0)
	add_child(keeper)
	await get_tree().process_frame

	var combat: Node = keeper.get_node_or_null("Combat")
	_expect(combat != null, "Keeper CombatController missing")
	if combat == null:
		keeper.queue_free()
		return

	# Canonical heavy hit must consume its authored posture exactly once.
	combat.call("set_posture", 0.0)
	combat.call("begin_attack_event", {
		"attack_id": "heavy_cleave",
		"action_trigger": "basic",
		"health_damage": 21,
		"posture_damage": 36.0,
		"block_posture_damage": 36.0,
	})
	var attack_area := Area2D.new()
	attack_area.add_to_group("attack")
	attack_area.set_meta("attacker", player)
	add_child(attack_area)
	keeper.call("_on_hurt_box_hurt", 21, "oathbound_attack", attack_area)
	combat.call("end_attack_event")
	var sword_posture: float = float(combat.call("get_posture"))
	_expect(is_equal_approx(sword_posture, 36.0), "Keeper heavy-cleave posture expected 36, got %.2f" % sword_posture)
	attack_area.queue_free()

	# One parry must add one configured amount, not the old explicit+notification double.
	combat.call("set_posture", 0.0)
	keeper.call("on_parried", player.global_position)
	await get_tree().process_frame
	var parry_expected: float = float(keeper.get("parry_posture_damage"))
	var parry_actual: float = float(combat.call("get_posture"))
	_expect(is_equal_approx(parry_actual, parry_expected), "Keeper parry posture expected %.2f once, got %.2f" % [parry_expected, parry_actual])

	# HP depletion remains a finisher state: first Deathblow transforms, second defeats.
	keeper.set("hp", 1)
	keeper.call("_on_posture_broken", 3.5)
	_expect(bool(keeper.call("is_deathblow_ready")), "Keeper did not advertise Deathblow readiness")
	keeper.call("receive_deathblow", player)
	_expect(int(keeper.get("_boss_phase")) == 1, "Keeper first Deathblow did not enter Phase 2")
	_expect(int(keeper.get("hp")) == 700, "Keeper Phase 2 did not restore 700 Health")

	await get_tree().create_timer(1.6).timeout
	if not is_instance_valid(keeper):
		_expect(false, "Keeper vanished during Phase 1 -> 2 transition")
		return

	var defeated := [false]
	keeper.connect("defeated", func(): defeated[0] = true)
	keeper.call("_on_posture_broken", 3.5)
	_expect(bool(keeper.call("is_deathblow_ready")), "Keeper Phase 2 did not advertise Deathblow readiness")
	keeper.call("receive_deathblow", player)
	await get_tree().process_frame
	_expect(bool(defeated[0]), "Keeper second Deathblow did not emit defeated")

	if is_instance_valid(keeper):
		keeper.queue_free()
	await get_tree().process_frame


func _verify_duo_manager_area_scope() -> void:
	var area_two_container := Node.new()
	area_two_container.set_meta("boss_area", 2)
	add_child(area_two_container)
	var manager_value: Variant = DUO_MANAGER_SCRIPT.new()
	_expect(manager_value is Node, "DuoBossManager could not instantiate")
	if manager_value is Node:
		area_two_container.add_child(manager_value as Node)
		await get_tree().process_frame
		_expect(not (manager_value as Node).is_in_group("boss"), "Area-2 duo manager activated during Area 1")
	area_two_container.queue_free()
	await get_tree().process_frame


func _finish(original_area: int) -> void:
	RunData.current_area_id = original_area
	if _failed:
		get_tree().quit(1)
		return
	print("[HushiroEliteBossProgressionSmoke] PASS - Collector parry posture | Keeper authored posture | single parry posture | Phase 1->2 Deathblow | final defeat | duo manager scoped")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[HushiroEliteBossProgressionSmoke] FAIL - %s" % message)
