extends Node

const PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const SWORDSMAN_SCENE: PackedScene = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsman.tscn")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await get_tree().process_frame
	var player: Node = PLAYER_SCENE.instantiate()
	var enemy: Node = SWORDSMAN_SCENE.instantiate()
	if player == null or enemy == null:
		_fail("could not instantiate canonical Player/Swordsman")
		_finish()
		return

	player.name = "GuardReadabilityPlayer"
	player.global_position = Vector2.ZERO
	add_child(player)
	enemy.name = "GuardReadabilitySwordsman"
	enemy.global_position = Vector2(48.0, 0.0)
	add_child(enemy)
	await get_tree().process_frame

	# Match the live Hushiro spawner order: enemy _ready() first, then regional
	# normalization. Standard-enemy Posture presentation must remain retired while the
	# authored guard pose/cue still communicates the Health-reduction state.
	HUSHIRO_ENEMY_CONTRACT.apply(enemy, "swordsman")
	await get_tree().process_frame

	player.set_physics_process(false)
	player.set_process_input(false)
	player.set_process_unhandled_input(false)
	enemy.set_physics_process(false)
	enemy.set("hp", 90)

	var combat: Node = enemy.get_node_or_null("Combat")
	var hurtbox: Node = enemy.get_node_or_null("HurtBox")
	var no_posture: Node = enemy.get_node_or_null("HushiroStandardNoPostureRuntime")
	if combat == null or hurtbox == null:
		_fail("Swordsman missing Combat or HurtBox")
		_cleanup(player, enemy)
		_finish()
		return
	_expect(no_posture != null, "live Hushiro contract did not attach standard no-Posture runtime")
	_expect(enemy.get_node_or_null("HushiroPostureReadabilityRuntime") == null, "standard Swordsman retained retired Posture readability runtime")
	_expect(enemy.get_node_or_null("HushiroPostureBreakRuntime") == null, "standard Swordsman retained retired posture-break runtime")
	if combat.has_method("reset_posture"):
		combat.call("reset_posture")

	# Guard must be legible before the sword lands, not inferred afterward from HP.
	enemy.call("_set_blocking", true)
	_expect(bool(enemy.call("is_blocking")), "Swordsman did not enter mechanical guard")
	_expect(bool(enemy.call("is_guard_cue_visible")), "mechanical guard has no player-facing guard cue")

	var attack: Area2D = Area2D.new()
	attack.name = "CanonicalGuardedSwordContact"
	attack.add_to_group("attack")
	attack.monitoring = true
	attack.monitorable = true
	attack.set_meta("attacker", player)
	attack.set_meta("health_damage", 12)
	attack.set_meta("posture_damage", 10.0)
	attack.set_meta("block_posture_damage", 14.0)
	attack.set_meta("stagger_level", 0)
	attack.set_meta("proc_coefficient", 1.0)
	attack.set_meta("attack_id", "wolf_fang_slash")
	attack.set_meta("damage_type", "sword_light")
	add_child(attack)

	var hp_before: int = int(enemy.get("hp"))
	var numbers_before: int = _count_damage_number_nodes()
	hurtbox.call("_on_area_entered", attack)
	await get_tree().process_frame

	var hp_after: int = int(enemy.get("hp"))
	var posture_after: float = float(combat.call("get_posture")) if combat.has_method("get_posture") else 0.0
	var guarded_hp_lost: int = hp_before - hp_after
	_expect(guarded_hp_lost == 4, "V2 Swordsman guard should pass 35% Health damage (12 -> 4)")
	_expect(is_zero_approx(posture_after), "guarded canonical sword contact accumulated retired standard Posture")
	_expect(_count_damage_number_nodes() == numbers_before + 1, "guarded Health loss did not create exactly one damage number")
	_expect(_latest_damage_number_text() == "4", "guarded damage number did not equal actual Health lost")
	_expect(bool(enemy.call("is_guard_cue_visible")), "light guarded contact incorrectly collapsed the guard cue")

	# Guard readability now comes from the authored body/guard cue. The old standard
	# Posture bar may remain as an imported scene node, but it must stay hidden.
	var posture_bar: Node2D = enemy.get_node_or_null("PostureBar") as Node2D
	if posture_bar != null:
		_expect(not posture_bar.visible, "retired standard PostureBar became visible after guarded contact")
	var posture_fill_value: Variant = enemy.get("_posture_fill")
	if posture_fill_value is ColorRect:
		var posture_fill: ColorRect = posture_fill_value as ColorRect
		_expect(posture_fill.size.x <= 0.001 or not posture_bar.visible, "retired Posture fill became player-facing")

	enemy.call("_set_blocking", false)
	_expect(not bool(enemy.call("is_guard_cue_visible")), "guard cue remained visible after guard ended")

	_cleanup(player, enemy)
	_finish()


func _count_damage_number_nodes() -> int:
	var scene: Node = get_tree().current_scene
	if scene == null:
		return 0
	var count: int = 0
	for child: Node in scene.get_children():
		if child.get_node_or_null("NumberLabel") != null:
			count += 1
	return count


func _latest_damage_number_text() -> String:
	var scene: Node = get_tree().current_scene
	if scene == null:
		return ""
	var latest: String = ""
	for child: Node in scene.get_children():
		var label: Node = child.get_node_or_null("NumberLabel")
		if label != null and "text" in label:
			latest = str(label.get("text"))
	return latest


func _cleanup(player: Node, enemy: Node) -> void:
	if is_instance_valid(player):
		player.queue_free()
	if is_instance_valid(enemy):
		enemy.queue_free()


func _finish() -> void:
	if _failures.is_empty():
		print("[HushiroGuardReadabilitySmoke] PASS - visible guard | canonical partial 4 HP | standard Posture hidden | exact HP number")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[HushiroGuardReadabilitySmoke] %s" % failure)
	print("[HushiroGuardReadabilitySmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)