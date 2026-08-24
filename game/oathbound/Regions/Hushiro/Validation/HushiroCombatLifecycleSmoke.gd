extends Node

const ENCOUNTER_SPAWNER_SCRIPT: Script = preload("res://Core/Encounters/EncounterSpawner.gd")
const SWORD_HITBOX_SCRIPT: Script = preload("res://Player/SwordHitBox.gd")

var _sword: Area2D = null
var _physics_contact_count: int = 0
var _failed: bool = false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	await _verify_detached_spawner_cancels_wait()
	if _failed:
		return
	await _verify_hitbox_deactivation_from_physics_signal()
	if _failed:
		return
	await _verify_damage_number_scene_teardown()
	if _failed:
		return
	await _verify_blood_stack_target_teardown()
	if _failed:
		return

	print("[HushiroCombatLifecycleSmoke] PASS - mid-wave detach cancels await | physics-signal hitbox shutdown deferred | transient damage-number tween dies with scene node | freed blood-stack target pruned")
	get_tree().quit(0)


func _verify_detached_spawner_cancels_wait() -> void:
	var spawner: Node2D = ENCOUNTER_SPAWNER_SCRIPT.new() as Node2D
	if spawner == null:
		_fail("could not instantiate EncounterSpawner")
		return
	add_child(spawner)
	await get_tree().process_frame

	# Reproduce the playtest condition directly: an authored wave is still alive and
	# the spawner is suspended waiting for the next process frame when the room is
	# removed because the player died.
	spawner.set("_alive", 4)
	spawner.call("_wait_until_current_wave_cleared")
	await get_tree().process_frame
	remove_child(spawner)
	await get_tree().process_frame
	await get_tree().process_frame

	if bool(spawner.get("_running")):
		_fail("detached EncounterSpawner remained running")
		spawner.free()
		return
	if spawner.is_inside_tree() or spawner.get_tree() != null:
		_fail("detached EncounterSpawner still reports a SceneTree")
		spawner.free()
		return

	spawner.free()


func _verify_hitbox_deactivation_from_physics_signal() -> void:
	_sword = SWORD_HITBOX_SCRIPT.new() as Area2D
	if _sword == null:
		_fail("could not instantiate SwordHitBox")
		return
	_sword.name = "SwordHitBox"

	var sword_shape := CollisionShape2D.new()
	sword_shape.name = "CollisionShape2D"
	var sword_rect := RectangleShape2D.new()
	sword_rect.size = Vector2(32.0, 32.0)
	sword_shape.shape = sword_rect
	_sword.add_child(sword_shape)
	add_child(_sword)
	await get_tree().process_frame

	var probe := Area2D.new()
	probe.name = "PhysicsSignalProbe"
	probe.collision_layer = 4
	probe.collision_mask = 2
	probe.monitoring = true
	probe.monitorable = true
	var probe_shape := CollisionShape2D.new()
	var probe_rect := RectangleShape2D.new()
	probe_rect.size = Vector2(32.0, 32.0)
	probe_shape.shape = probe_rect
	probe.add_child(probe_shape)
	probe.area_entered.connect(_on_probe_area_entered)
	add_child(probe)

	_sword.call("activate_hitbox")
	await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await get_tree().process_frame

	if _physics_contact_count < 1:
		_fail("physics probe never entered the active SwordHitBox")
		return
	if bool(_sword.call("is_active")):
		_fail("SwordHitBox remained logically active after physics-signal deactivation")
		return

	probe.queue_free()
	_sword.queue_free()
	_sword = null
	await get_tree().process_frame


func _verify_damage_number_scene_teardown() -> void:
	if typeof(DamageNumberManager) != TYPE_OBJECT:
		_fail("DamageNumberManager autoload unavailable")
		return

	# DamageNumberManager survives scene changes. The animated number does not. The
	# tween therefore has to be owned by this transient Control so freeing it also
	# kills every delayed property/callback step. The old manager-owned tween would
	# reach its anonymous completion lambda after this node had already been freed.
	var transient := Control.new()
	transient.name = "TransientDamageNumberLifetimeProbe"
	add_child(transient)
	await get_tree().process_frame

	DamageNumberManager.call("_animate_damage_number", transient)
	transient.queue_free()
	await get_tree().process_frame
	if is_instance_valid(transient):
		_fail("transient damage number did not leave the tree")
		return

	# The old animation completed at 0.6 s. Wait beyond that boundary so CI captures
	# any delayed freed-lambda diagnostic emitted by Godot.
	await get_tree().create_timer(0.75).timeout


func _verify_blood_stack_target_teardown() -> void:
	if typeof(BloodStackManager) != TYPE_OBJECT:
		_fail("BloodStackManager autoload unavailable")
		return

	# This singleton also survives scene changes. Reproduce an enemy registering with
	# it and disappearing with the outgoing room without an explicit unregister call.
	var target := Node.new()
	target.name = "BloodStackLifetimeProbe"
	add_child(target)
	BloodStackManager.call("register_enemy", target)
	await get_tree().process_frame

	target.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame

	var targets_value: Variant = BloodStackManager.get("blood_targets")
	if not (targets_value is Array):
		_fail("BloodStackManager target registry is not an Array")
		return
	for registered: Variant in targets_value as Array:
		if registered == null or not is_instance_valid(registered):
			_fail("BloodStackManager retained a freed scene target")
			return


func _on_probe_area_entered(area: Area2D) -> void:
	if _sword == null or area != _sword:
		return
	_physics_contact_count += 1
	# This callback runs while Godot is flushing Area2D enter queries, matching the
	# Hollow/Swordsman hurt path from the manual playtest.
	_sword.call("deactivate_hitbox")


func _fail(message: String) -> void:
	_failed = true
	push_error("[HushiroCombatLifecycleSmoke] FAIL - %s" % message)
	get_tree().quit(1)