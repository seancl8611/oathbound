extends Node

const DuoBossManagerScript = preload("res://Utility/duo_boss_manager.gd")
const EnemyBaseScript = preload("res://Enemy/Base/EnemyBase.gd")

const PASS_LINE := "[EnemyLifetimeHardeningSmoke] PASS - freed Twin Maws partner | stale reward owner | shared body clearance"


class DummyTwin:
	extends Node
	var dead: bool = false
	var partner_death_notices: int = 0

	func is_dead() -> bool:
		return dead

	func on_partner_died() -> void:
		partner_death_notices += 1


func _ready() -> void:
	var failures: Array[String] = []
	_check_freed_twin_boundaries(failures)
	_check_stale_reward_parent(failures)
	_check_shared_body_clearance(failures)

	if failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return

	for failure in failures:
		push_error("[EnemyLifetimeHardeningSmoke] " + failure)
	get_tree().quit(1)


func _check_freed_twin_boundaries(failures: Array[String]) -> void:
	var manager = DuoBossManagerScript.new()
	var rootfang := DummyTwin.new()
	var briarthorn := DummyTwin.new()

	manager._twin_a = rootfang
	manager._twin_b = briarthorn
	manager._twins_dead = 1

	# Seed both cached-reference classes while Rootfang is still a valid Node, then
	# free it. This reproduces how the real manager acquired valid Node references in
	# _ready() and only encountered a previously-freed Object on a later frame.
	manager._active_special_twin = briarthorn
	manager._pending_special_twin = rootfang
	var stale_rootfang: Variant = rootfang
	rootfang.free()
	if is_instance_valid(stale_rootfang):
		failures.append("test setup could not produce a freed Twin Maws reference")
		briarthorn.free()
		manager.free()
		return

	# Deferred special-mode ownership must discard the now-freed pending twin without
	# crossing a Node-typed helper boundary.
	manager.notify_special_mode_ended(briarthorn)
	if manager._pending_special_twin != null:
		failures.append("Twin Maws manager retained a freed deferred special-mode owner")
	if manager._active_special_twin != null:
		failures.append("Twin Maws manager retained an ended active special-mode owner")

	# This is the exact September 4 crash shape: Briarthorn dies after Rootfang has
	# already been freed, so get_partner() returns a previously-freed Object. The
	# manager must reject it inside a Variant-safe boundary rather than passing it
	# through a Node-typed helper first.
	manager.notify_died(briarthorn)
	if manager._twins_dead != 2:
		failures.append("Twin Maws manager did not complete the second-death transition")
	if manager._twin_b != null:
		failures.append("Twin Maws manager retained the live twin after its death notification")

	briarthorn.free()
	manager.free()


func _check_stale_reward_parent(failures: Array[String]) -> void:
	var chamber := Node2D.new()
	chamber.name = "LifetimeRewardChamber"
	add_child(chamber)

	var enemy = EnemyBaseScript.new()
	chamber.add_child(enemy)

	var old_loot := Node2D.new()
	old_loot.name = "OldLoot"
	old_loot.add_to_group("loot")
	chamber.add_child(old_loot)
	var stale_loot: Variant = old_loot
	old_loot.free()

	var live_loot := Node2D.new()
	live_loot.name = "Loot"
	live_loot.add_to_group("loot")
	chamber.add_child(live_loot)

	# Keeper/Eclipse Shogun previously passed a cached chamber loot node here after
	# room replacement. The shared helper must ignore the freed preferred value and
	# resolve the current chamber's live Loot owner instead.
	var resolved: Node = enemy._resolve_live_loot_parent(stale_loot)
	if resolved != live_loot:
		failures.append("shared enemy reward routing did not replace a freed cached Loot owner")

	chamber.free()


func _check_shared_body_clearance(failures: Array[String]) -> void:
	var player := CharacterBody2D.new()
	player.name = "SmokePlayer"
	player.add_to_group("player")
	player.global_position = Vector2.ZERO
	var player_collision := CollisionShape2D.new()
	player_collision.name = "CollisionShape2D"
	var player_shape := CircleShape2D.new()
	player_shape.radius = 8.0
	player_collision.shape = player_shape
	player.add_child(player_collision)
	add_child(player)

	var enemy := CharacterBody2D.new()
	enemy.name = "SmokeEnemy"
	enemy.add_to_group("enemy")
	enemy.global_position = Vector2(10.0, 0.0)
	enemy.velocity = Vector2(-100.0, 0.0)
	var enemy_collision := CollisionShape2D.new()
	enemy_collision.name = "CollisionShape2D"
	var enemy_shape := CircleShape2D.new()
	enemy_shape.radius = 10.0
	enemy_collision.shape = enemy_shape
	enemy.add_child(enemy_collision)
	add_child(enemy)

	var runtime := get_node_or_null("/root/EnemyBodyClearanceRuntime")
	if runtime == null:
		failures.append("EnemyBodyClearanceRuntime autoload is missing")
		player.free()
		enemy.free()
		return

	var before := enemy.global_position.distance_to(player.global_position)
	runtime.call("_physics_process", 1.0 / 60.0)
	var after := enemy.global_position.distance_to(player.global_position)
	if after <= before:
		failures.append("shared enemy body clearance did not depenetrate inward enemy movement")

	var toward_player := (player.global_position - enemy.global_position).normalized()
	if enemy.velocity.dot(toward_player) > 0.01:
		failures.append("shared enemy body clearance left inward body velocity active")

	player.free()
	enemy.free()
