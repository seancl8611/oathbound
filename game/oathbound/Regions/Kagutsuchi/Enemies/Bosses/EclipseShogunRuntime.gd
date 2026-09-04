extends "res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogun.gd"

## Runtime lifetime hardening for Eclipse Shogun temporary hazards.
## Prior live playtests produced freed-lambda errors in this fight. The remaining
## imported Blood Halo, Blade Dance, and Black Wing helpers still captured temporary
## Area2Ds in delayed lambdas. Keep every authored timing/damage path intact while
## binding cleanup to the temporary node itself.


func _spawn_blade_dance_projectile(dir: Vector2) -> void:
	var proj := Area2D.new()
	proj.add_to_group("attack")
	proj.collision_layer = 2
	proj.collision_mask = 4
	proj.set_meta("damage", bd_projectile_damage)
	proj.set_meta("attacker", self)
	proj.set_meta("telegraphed", true)
	proj.set_meta("damage_type", "unblockable")
	proj.set_meta("parryable", false)
	proj.set_meta("unblockable", true)

	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = bd_projectile_radius
	cs.shape = shape
	proj.add_child(cs)

	var visual := Polygon2D.new()
	var pts := PackedVector2Array()
	for s in range(6):
		var angle := float(s) / 6.0 * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * bd_projectile_radius)
	visual.polygon = pts
	visual.color = Color(0.8, 0.15, 0.1, 0.7)
	proj.add_child(visual)

	proj.global_position = global_position + dir * 20.0
	get_parent().add_child(proj)

	var start_pos := proj.global_position
	var end_pos: Vector2 = start_pos + dir * float(bd_projectile_range)
	var out_time: float = float(bd_projectile_range) / float(bd_projectile_speed)
	var tween := proj.create_tween()
	tween.tween_property(proj, "global_position", end_pos, out_time)
	tween.tween_property(proj, "global_position", start_pos, out_time)
	tween.tween_callback(Callable(proj, "queue_free"))
	_active_hazards.append(proj)


func _do_blood_halo() -> void:
	var my_seq: int = int(_attack_sequence_id)
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	velocity = Vector2.ZERO

	if sprite:
		sprite.modulate = Color(1.0, 0.4, 0.3)

	var halo := Node2D.new()
	halo.name = "BloodHalo"
	add_child(halo)
	_blood_halo_node = halo

	var visual := Polygon2D.new()
	var pts := PackedVector2Array()
	var seg := 24
	for s in range(seg):
		var angle := float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * bh_radius)
	visual.polygon = pts
	visual.color = Color(0.7, 0.1, 0.05, 0.25)
	visual.z_index = -1
	halo.add_child(visual)

	var ticks := int(bh_duration / bh_tick_interval)
	for _tick in range(ticks):
		if _should_abort_attack(my_seq) or not is_instance_valid(halo):
			break
		var player := _get_player()
		if player and is_instance_valid(player):
			var dist: float = float(player.global_position.distance_to(global_position))
			if dist >= bh_radius * 0.7 and dist <= bh_radius * 1.1:
				var tick_hit := _spawn_radial_burst(player.global_position, 15.0, bh_damage, true)
				_arm_shogun_self_free(tick_hit, 0.15, "RuntimeHaloHitLifetime")

		await get_tree().create_timer(bh_tick_interval).timeout
		if not is_instance_valid(self):
			return

	if is_instance_valid(halo):
		halo.queue_free()
	_blood_halo_node = null

	if sprite:
		sprite.modulate = Color.WHITE

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(0.3).timeout
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


func _spawn_shock_lane(origin: Vector2, dir: Vector2) -> void:
	var lane := Area2D.new()
	lane.add_to_group("attack")
	lane.collision_layer = 2
	lane.collision_mask = 4
	lane.set_meta("damage", bwa_lane_damage)
	lane.set_meta("attacker", self)
	lane.set_meta("telegraphed", true)
	lane.set_meta("damage_type", "unblockable")
	lane.set_meta("parryable", false)
	lane.set_meta("unblockable", true)

	var cs := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(bwa_lane_width * 2.0, bwa_lane_width)
	cs.shape = rect
	cs.rotation = dir.angle()
	lane.add_child(cs)

	var visual := ColorRect.new()
	visual.size = Vector2(bwa_lane_width * 2.0, bwa_lane_width * 0.6)
	visual.position = Vector2(-bwa_lane_width, -bwa_lane_width * 0.3)
	visual.color = Color(0.6, 0.1, 0.05, 0.6)
	visual.rotation = dir.angle()
	lane.add_child(visual)

	lane.global_position = origin + dir * 20.0
	get_parent().add_child(lane)
	_active_hazards.append(lane)

	var travel_time: float = 200.0 / float(bwa_lane_speed)
	var tween := lane.create_tween()
	tween.tween_property(lane, "global_position", origin + dir * 200.0, travel_time)
	tween.tween_callback(Callable(lane, "queue_free"))


func _arm_shogun_self_free(node: Node, delay: float, timer_name: String) -> void:
	if node == null or not is_instance_valid(node):
		return
	var lifetime := Timer.new()
	lifetime.name = timer_name
	lifetime.one_shot = true
	lifetime.wait_time = maxf(0.001, delay)
	node.add_child(lifetime)
	lifetime.timeout.connect(Callable(node, "queue_free"))
	lifetime.start()
