extends "res://Enemy/Area 2/Minibosses/embered_pilgrim.gd"

## Runtime lifetime hardening for Embered Pilgrim temporary combat objects.
## Afterimages, ember patches, and homing orbs previously scheduled SceneTreeTimer
## lambdas that captured the temporary Area2D. These variants keep the same timings,
## damage, and visuals while making timers children of the object they govern.


func _spawn_afterimage_from_hitbox(hitbox: Area2D) -> void:
	if not is_instance_valid(hitbox):
		return

	var ghost := Area2D.new()
	ghost.add_to_group("attack")
	ghost.collision_layer = 2
	ghost.collision_mask = 4
	ghost.set_meta("damage", 0)
	ghost.set_meta("damage_type", "unblockable")
	ghost.set_meta("attacker", self)
	ghost.set_meta("parryable", false)
	ghost.set_meta("unblockable", true)
	ghost.set_meta("telegraphed", false)
	ghost.set_meta("posture_damage_override", afterimage_posture_damage)

	for child_value: Variant in hitbox.get_children():
		if child_value is CollisionShape2D and (child_value as CollisionShape2D).shape:
			var col := CollisionShape2D.new()
			col.shape = (child_value as CollisionShape2D).shape.duplicate()
			ghost.add_child(col)
			break

	ghost.global_position = hitbox.global_position
	ghost.global_rotation = hitbox.global_rotation
	get_parent().add_child(ghost)

	var visual := ColorRect.new()
	visual.size = Vector2(20, 20)
	visual.position = Vector2(-10, -10)
	visual.color = Color(1.0, 0.5, 0.2, afterimage_alpha)
	ghost.add_child(visual)

	_arm_pilgrim_self_free(ghost, afterimage_duration, "RuntimeAfterimageLifetime")


func _spawn_ember_patch(pos: Vector2, radius: float, duration: float) -> void:
	var patch := Area2D.new()
	patch.collision_layer = 2
	patch.collision_mask = 4
	patch.global_position = pos

	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = radius
	cs.shape = shape
	patch.add_child(cs)

	var visual := Polygon2D.new()
	var pts := PackedVector2Array()
	var seg := 16
	for s in range(seg):
		var angle := float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * radius)
	visual.polygon = pts
	visual.color = Color(1.0, 0.4, 0.1, 0.25)
	visual.z_index = -1
	patch.add_child(visual)

	get_parent().add_child(patch)
	var patch_id := patch.get_instance_id()

	patch.set_meta("ember_dps", ember_tick_damage)
	patch.set_meta("ember_posture_ps", ember_posture_per_sec)
	patch.set_meta("ember_owner", self)
	patch.set_meta("ember_hit_cooldown", {})
	patch.set_meta("_player_inside", false)

	patch.body_entered.connect(Callable(self, "_on_pilgrim_runtime_patch_body_entered").bind(patch_id))
	patch.body_exited.connect(Callable(self, "_on_pilgrim_runtime_patch_body_exited").bind(patch_id))

	var tick_timer := Timer.new()
	tick_timer.name = "RuntimeEmberTick"
	tick_timer.one_shot = false
	tick_timer.wait_time = 0.3
	patch.add_child(tick_timer)
	tick_timer.timeout.connect(Callable(self, "_on_pilgrim_runtime_patch_tick").bind(patch_id, 0.3))
	tick_timer.start()

	var lifetime := Timer.new()
	lifetime.name = "RuntimeEmberLifetime"
	lifetime.one_shot = true
	lifetime.wait_time = maxf(0.001, duration)
	patch.add_child(lifetime)
	lifetime.timeout.connect(Callable(self, "_on_pilgrim_runtime_patch_fade").bind(patch_id, visual.get_instance_id()))
	lifetime.start()


func _on_pilgrim_runtime_patch_body_entered(body: Node, patch_id: int) -> void:
	if body == null or not is_instance_valid(body) or not body.is_in_group("player"):
		return
	var patch_value: Object = instance_from_id(patch_id)
	if patch_value is Area2D and is_instance_valid(patch_value):
		(patch_value as Area2D).set_meta("_player_inside", true)


func _on_pilgrim_runtime_patch_body_exited(body: Node, patch_id: int) -> void:
	if body == null or not is_instance_valid(body) or not body.is_in_group("player"):
		return
	var patch_value: Object = instance_from_id(patch_id)
	if patch_value is Area2D and is_instance_valid(patch_value):
		(patch_value as Area2D).set_meta("_player_inside", false)


func _on_pilgrim_runtime_patch_tick(patch_id: int, tick_interval: float) -> void:
	var patch_value: Object = instance_from_id(patch_id)
	if not (patch_value is Area2D) or not is_instance_valid(patch_value):
		return
	var patch := patch_value as Area2D
	if not bool(patch.get_meta("_player_inside", false)):
		return
	var player := get_tree().get_first_node_in_group("player")
	if player == null or not is_instance_valid(player):
		return
	if "hp" in player:
		player.hp -= int(ember_tick_damage)
		if player.has_method("_update_health_bar"):
			player.call("_update_health_bar")
	var combat_node := player.get_node_or_null("Combat")
	if combat_node != null and combat_node.has_method("add_posture"):
		combat_node.call("add_posture", ember_posture_per_sec * tick_interval)


func _on_pilgrim_runtime_patch_fade(patch_id: int, visual_id: int) -> void:
	var patch_value: Object = instance_from_id(patch_id)
	if not (patch_value is Area2D) or not is_instance_valid(patch_value):
		return
	var patch := patch_value as Area2D
	var tick_timer := patch.get_node_or_null("RuntimeEmberTick") as Timer
	if tick_timer != null:
		tick_timer.stop()
	var visual_value: Object = instance_from_id(visual_id)
	if not (visual_value is Polygon2D) or not is_instance_valid(visual_value):
		patch.queue_free()
		return
	var visual := visual_value as Polygon2D
	var tween := visual.create_tween()
	tween.tween_property(visual, "color:a", 0.0, 0.3)
	tween.tween_callback(Callable(patch, "queue_free"))


func _spawn_dark_orb(origin: Vector2, dir: Vector2, unblockable: bool = false) -> void:
	var orb := Area2D.new()
	orb.add_to_group("attack")
	orb.collision_layer = 2
	orb.collision_mask = 0
	orb.set_meta("damage", orb_damage)
	orb.set_meta("attacker", self)
	orb.set_meta("telegraphed", true)
	orb.set_meta("is_projectile", true)
	orb.set_meta("swing_token", Time.get_ticks_msec())

	if unblockable:
		orb.set_meta("damage_type", "unblockable")
		orb.set_meta("parryable", false)
		orb.set_meta("unblockable", true)
	else:
		orb.set_meta("damage_type", "pilgrim_orb")
		orb.set_meta("parryable", true)
		orb.set_meta("unblockable", false)

	orb.set_meta("direction", dir)
	orb.set_meta("speed", orb_speed)
	orb.set_meta("homing", true)
	orb.set_meta("homing_strength", 1.8)
	orb.set_meta("homing_delay", 0.25)
	orb.set_meta("spawn_time", Time.get_ticks_msec() * 0.001)

	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = 8.0
	cs.shape = shape
	orb.add_child(cs)
	orb.global_position = origin

	var visual := ColorRect.new()
	visual.size = Vector2(12, 12)
	visual.position = Vector2(-6, -6)
	visual.color = Color(0.3, 0.1, 0.5, 0.9)
	orb.add_child(visual)

	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root
	parent.add_child(orb)
	_active_projectiles.append(orb)
	_arm_pilgrim_self_free(orb, 3.5, "RuntimeOrbLifetime")


func _arm_pilgrim_self_free(node: Node, delay: float, timer_name: String) -> void:
	var lifetime := Timer.new()
	lifetime.name = timer_name
	lifetime.one_shot = true
	lifetime.wait_time = maxf(0.001, delay)
	node.add_child(lifetime)
	lifetime.timeout.connect(Callable(node, "queue_free"))
	lifetime.start()
