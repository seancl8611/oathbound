extends "res://Enemy/Area 2/Boss/briarthorn.gd"

## Runtime hardening for the live Twin Maws Briarthorn scene.
## Temporary AOE/beam attacks keep self-owned lifetimes. Empowered lunge movement now
## tests its next committed physics step so a player, twin, enemy, or wall stops the
## charge rather than allowing move_and_slide() to turn it into a sideways skirt.


func _runtime_attack_step_blocked(dir: Vector2, speed: float) -> bool:
	if dir.length_squared() <= 0.001 or speed <= 0.0:
		return false
	var dt: float = maxf(get_physics_process_delta_time(), 1.0 / 120.0)
	return test_move(global_transform, dir.normalized() * speed * dt)


func _do_empowered_lunge() -> void:
	var my_seq: int = int(_attack_sequence_id)
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	var player := _get_player()
	var dir := Vector2.RIGHT
	if player:
		dir = (player.global_position - global_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	_face_direction(dir)

	_show_parry_indicator(emp_lunge_telegraph + parry_early_window + emp_lunge_active + parry_linger_window, false)
	if anim and anim.has_animation("lunge_antic"):
		anim.play("lunge_antic")
	elif anim and anim.has_animation("swipe_antic"):
		anim.play("swipe_antic")
	if not await _wait_duration_interruptible(emp_lunge_telegraph, my_seq):
		return
	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_finish_attack()
		return

	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_melee_hitbox(dir, emp_lunge_damage, emp_lunge_range, emp_lunge_width, false, false)
	if anim and anim.has_animation("lunge_active"):
		anim.play("lunge_active")
	elif anim and anim.has_animation("swipe_active"):
		anim.play("swipe_active")

	var lunge_elapsed: float = 0.0
	var lunge_time: float = emp_lunge_distance / emp_lunge_speed if emp_lunge_speed > 0.0 else 0.0
	while lunge_elapsed < lunge_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_finish_attack()
			return
		if _runtime_attack_step_blocked(dir, emp_lunge_speed):
			velocity = Vector2.ZERO
			break
		velocity = dir * emp_lunge_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		lunge_elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if not await _wait_duration_interruptible(emp_lunge_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return
	_cleanup_hitbox()
	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(emp_lunge_recovery, my_seq):
		return
	_finish_attack()


func _spawn_aoe_detonation(center: Vector2, radius: float, damage: int) -> void:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = radius
	col.shape = shape
	area.add_child(col)
	area.global_position = center
	get_parent().add_child(area)

	var flash := Polygon2D.new()
	var pts := PackedVector2Array()
	var seg := 24
	for s in range(seg):
		var angle := float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * radius)
	flash.polygon = pts
	flash.color = Color(1.0, 0.5, 0.2, 0.6)
	area.add_child(flash)

	area.set_deferred("monitoring", true)
	_arm_briarthorn_overlap_probe(area)
	_arm_briarthorn_self_free(area, 0.2)


func _spawn_beam_hitbox(dir: Vector2, length: float, width: float, damage: int) -> void:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, width)
	col.shape = rect
	area.add_child(col)

	area.global_position = global_position + dir * (length * 0.5)
	area.rotation = dir.angle()
	get_parent().add_child(area)
	_current_hitbox = area

	var vis := ColorRect.new()
	vis.size = Vector2(length, width)
	vis.position = Vector2(-length * 0.5, -width * 0.5)
	vis.color = Color(0.95, 0.6, 0.2, 0.7)
	area.add_child(vis)

	area.set_deferred("monitoring", true)
	_arm_briarthorn_overlap_probe(area)


func _arm_briarthorn_overlap_probe(area: Area2D) -> void:
	var probe := Timer.new()
	probe.name = "RuntimeOverlapProbe"
	probe.one_shot = true
	probe.wait_time = 0.05
	area.add_child(probe)
	probe.timeout.connect(Callable(self, "_on_briarthorn_runtime_overlap_probe").bind(area.get_instance_id()))
	probe.start()


func _arm_briarthorn_self_free(area: Area2D, delay: float) -> void:
	var lifetime := Timer.new()
	lifetime.name = "RuntimeLifetime"
	lifetime.one_shot = true
	lifetime.wait_time = maxf(0.001, delay)
	area.add_child(lifetime)
	lifetime.timeout.connect(Callable(area, "queue_free"))
	lifetime.start()


func _on_briarthorn_runtime_overlap_probe(area_id: int) -> void:
	var area_value: Object = instance_from_id(area_id)
	if not (area_value is Area2D) or not is_instance_valid(area_value):
		return
	var area := area_value as Area2D
	if not area.is_inside_tree():
		return
	for body_value: Variant in area.get_overlapping_bodies():
		area.body_entered.emit(body_value)
	for overlap_value: Variant in area.get_overlapping_areas():
		area.area_entered.emit(overlap_value)
