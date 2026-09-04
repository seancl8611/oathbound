extends Node

## Regression coverage for the September 3 direct boss/miniboss playtest on b920e137:
## - Eclipse Shogun must recover when the Loot node cached by HumanoidEnemyBase has
##   been freed by room lifetime and a current chamber Loot node exists;
## - temporary Shogun projectile cleanup must not leave freed Object lambda captures;
## - Rootfang and Eclipse Shogun body motion must respect their authored too-close
##   boundary even while high-speed attacks are active.

const SHOGUN_SCENE: PackedScene = preload("res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogun.tscn")
const ROOTFANG_SCENE: PackedScene = preload("res://Enemy/Area 2/Boss/rootfang.tscn")
const EXPERIENCE_GEM_SCENE: PackedScene = preload("res://Objects/experience_gem.tscn")

var _failures: Array[String] = []
var _room: Node2D
var _loot: Node2D
var _player: CharacterBody2D


func _ready() -> void:
	await get_tree().process_frame
	_build_test_room()
	await _verify_shogun_stale_reward_parent()
	await _verify_shogun_temporary_hazard_lifetime()
	_verify_close_body_clearance()

	if _failures.is_empty():
		print("[KagutsuchiPlaytestRegressionSmoke] PASS - stale reward ownership, hazard lifetime, Rootfang/Shogun body clearance")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[KagutsuchiPlaytestRegressionSmoke] %s" % failure)
		print("[KagutsuchiPlaytestRegressionSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _build_test_room() -> void:
	_room = Node2D.new()
	_room.name = "BossRegressionRoom"
	_room.add_to_group("room")
	add_child(_room)

	_loot = Node2D.new()
	_loot.name = "Loot"
	_loot.add_to_group("loot")
	_room.add_child(_loot)

	_player = CharacterBody2D.new()
	_player.name = "Player"
	_player.add_to_group("player")
	_room.add_child(_player)
	_player.global_position = Vector2.ZERO


func _verify_shogun_stale_reward_parent() -> void:
	# Instantiate while the first Loot node is live so HumanoidEnemyBase caches it,
	# then free that chamber-owned node and create the replacement that should own the
	# actual death reward. This mirrors the room-transition lifetime bug from the log.
	var shogun: Node = SHOGUN_SCENE.instantiate()
	shogun.process_mode = Node.PROCESS_MODE_DISABLED
	_room.add_child(shogun)
	await get_tree().process_frame

	var cached_loot: Node2D = _loot
	cached_loot.free()
	_loot = Node2D.new()
	_loot.name = "Loot"
	_loot.add_to_group("loot")
	_room.add_child(_loot)
	await get_tree().process_frame

	shogun.set("exp_gem", EXPERIENCE_GEM_SCENE)
	shogun.set("death_anim", null)

	var resolved: Variant = shogun.call("_resolve_live_reward_parent")
	_expect(resolved == _loot, "Eclipse Shogun did not prefer the current chamber Loot node after its cached Loot was freed")

	shogun.call("_run_humanoid_death_rewards")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(_loot.get_child_count() > 0, "Eclipse Shogun reward path did not recover the experience gem into current Loot")
	_expect(shogun.get("loot_base") == _loot, "Eclipse Shogun did not refresh inherited loot_base to current Loot before teardown")

	shogun.queue_free()
	for child: Node in _loot.get_children():
		child.queue_free()
	await get_tree().process_frame


func _verify_shogun_temporary_hazard_lifetime() -> void:
	var shogun: Node = SHOGUN_SCENE.instantiate()
	shogun.process_mode = Node.PROCESS_MODE_DISABLED
	_room.add_child(shogun)
	await get_tree().process_frame

	# Reproduce the old phase-transition case: a Blade Dance projectile disappears
	# before its outbound/return tween reaches cleanup. A node-owned Tween/Callable must
	# disappear with it instead of later materializing a freed lambda capture.
	shogun.call("_spawn_blade_dance_projectile", Vector2.RIGHT)
	shogun.call("_cleanup_all_hazards")
	await get_tree().process_frame
	await get_tree().create_timer(1.6).timeout

	_expect(is_instance_valid(shogun), "Eclipse Shogun was invalidated by early temporary-hazard cleanup")
	shogun.queue_free()
	await get_tree().process_frame


func _verify_close_body_clearance() -> void:
	var shogun: Node = SHOGUN_SCENE.instantiate()
	shogun.process_mode = Node.PROCESS_MODE_DISABLED
	_room.add_child(shogun)
	shogun.global_position = Vector2(14.0, 0.0)
	shogun.set("velocity", Vector2(-550.0, 0.0))
	shogun.call("_apply_soft_separation")
	var shogun_velocity: Vector2 = shogun.get("velocity") as Vector2
	_expect(shogun_velocity.x >= -0.001, "Eclipse Shogun retained inward 550 px/s motion inside too_close_threshold")
	shogun.queue_free()

	var rootfang: Node = ROOTFANG_SCENE.instantiate()
	rootfang.process_mode = Node.PROCESS_MODE_DISABLED
	_room.add_child(rootfang)
	rootfang.global_position = Vector2(14.0, 0.0)
	rootfang.set("velocity", Vector2(-500.0, 0.0))
	rootfang.call("_apply_soft_separation")
	var rootfang_velocity: Vector2 = rootfang.get("velocity") as Vector2
	_expect(rootfang_velocity.x >= -0.001, "Rootfang retained inward 500 px/s motion inside too_close_threshold")
	rootfang.queue_free()


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
