extends "res://Enemy/Area 2/Boss/rootfang.gd"

## Runtime hardening for the live Twin Maws Rootfang scene.
##
## Rootfang's empowered beam lifetime remains self-owned. The September 9 telemetry
## also captured 450 px/s roll passes crossing from one side of Akio to the other.
## Attack motion now tests the next committed step before ordinary move_and_slide()
## can convert a blocked charge into a sideways skate.


func _runtime_attack_step_blocked(dir: Vector2, speed: float) -> bool:
	if dir.length_squared() <= 0.001 or speed <= 0.0:
		return false
	var dt: float = maxf(get_physics_process_delta_time(), 1.0 / 120.0)
	return test_move(global_transform, dir.normalized() * speed * dt)


func _lunge_phase(dir: Vector2, distance: float, speed: float, duration: float, seq_id: int) -> bool:
	if dir == Vector2.ZERO or speed <= 0.0:
		return not _should_abort_attack(seq_id)

	var current_dist: float = _get_current_distance_to_player()
	var adjusted_distance: float = distance
	if current_dist >= 0.0:
		if current_dist < lunge_min_distance:
			return not _should_abort_attack(seq_id)
		var distance_ratio: float = clampf(
			(current_dist - lunge_min_distance) / (ideal_combat_distance - lunge_min_distance),
			0.0,
			1.0
		)
		adjusted_distance = distance * distance_ratio

	if adjusted_distance < 5.0:
		return not _should_abort_attack(seq_id)

	var start_pos: Vector2 = global_position
	var elapsed: float = 0.0
	var adjusted_duration: float = adjusted_distance / speed if speed > 0.0 else duration
	while elapsed < adjusted_duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return false
		if _combo_is_frozen:
			velocity = Vector2.ZERO
			while _combo_is_frozen:
				if _should_abort_attack(seq_id):
					return false
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return false
			continue

		var traveled: float = global_position.distance_to(start_pos)
		if traveled >= adjusted_distance or _runtime_attack_step_blocked(dir, speed):
			velocity = Vector2.ZERO
			return true
		velocity = dir.normalized() * speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false
		elapsed += get_physics_process_delta_time()

	velocity = Vector2.ZERO
	return not _should_abort_attack(seq_id)


func _do_rootfang_roll_sequence() -> void:
	var roll_count: int = rootfang_roll_count
	for i in range(roll_count):
		if _phase == Phase.DEAD or _dbroken_active:
			break

		var player := _get_player()
		var dir := Vector2.RIGHT
		if player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

		var windup: float = rootfang_roll_first_windup if i == 0 else rootfang_roll_windup
		_set_combat_phase(CombatPhase.WINDUP)
		_show_parry_indicator(windup, true)
		if anim and anim.has_animation("roll_antic"):
			anim.play("roll_antic")
		elif anim and anim.has_animation("claw_antic"):
			anim.play("claw_antic")

		var wu_elapsed: float = 0.0
		while wu_elapsed < windup:
			if _phase == Phase.DEAD or _dbroken_active:
				_cleanup_hitbox()
				velocity = Vector2.ZERO
				_set_combat_phase(CombatPhase.NONE)
				_exit_rootfang()
				return
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			wu_elapsed += get_physics_process_delta_time()
			if player and is_instance_valid(player) and wu_elapsed < windup * 0.8:
				dir = (player.global_position - global_position).normalized()
				if dir == Vector2.ZERO:
					dir = Vector2.RIGHT
				_face_direction(dir)

		if player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT
			_face_direction(dir)

		_set_combat_phase(CombatPhase.ACTIVE)
		_rootfang_rolling = true
		_current_hitbox = _spawn_roll_hitbox()
		if anim and anim.has_animation("roll"):
			anim.play("roll")

		var roll_elapsed: float = 0.0
		var roll_duration: float = rootfang_roll_distance / rootfang_roll_speed
		while roll_elapsed < roll_duration:
			if _phase == Phase.DEAD or _dbroken_active:
				_rootfang_rolling = false
				_cleanup_hitbox()
				velocity = Vector2.ZERO
				_set_combat_phase(CombatPhase.NONE)
				_exit_rootfang()
				return
			if _runtime_attack_step_blocked(dir, rootfang_roll_speed):
				velocity = Vector2.ZERO
				break
			velocity = dir * rootfang_roll_speed
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			roll_elapsed += get_physics_process_delta_time()

		velocity = Vector2.ZERO
		_rootfang_rolling = false
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.RECOVERY)

		if i < roll_count - 1:
			if anim and anim.has_animation("roll_recover"):
				anim.play("roll_recover")
			elif anim and anim.has_animation("idle"):
				anim.play("idle")
			var pause_elapsed: float = 0.0
			while pause_elapsed < rootfang_roll_pause:
				if _phase == Phase.DEAD or _dbroken_active:
					_set_combat_phase(CombatPhase.NONE)
					_exit_rootfang()
					return
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
				pause_elapsed += get_physics_process_delta_time()

	_set_combat_phase(CombatPhase.NONE)
	_exit_rootfang()


func _spawn_emp_beam_hitbox(dir: Vector2) -> void:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", emp_beam_damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(emp_beam_length, emp_beam_width)
	col.shape = rect
	area.add_child(col)

	area.global_position = global_position + dir * (emp_beam_length * 0.5)
	area.rotation = dir.angle()
	get_parent().add_child(area)
	_current_hitbox = area
	_is_current_hitbox_melee = false

	var vis := ColorRect.new()
	vis.size = Vector2(emp_beam_length, emp_beam_width)
	vis.position = Vector2(-emp_beam_length * 0.5, -emp_beam_width * 0.5)
	vis.color = Color(0.95, 0.5, 0.15, 0.7)
	area.add_child(vis)

	area.set_deferred("monitoring", true)
	var probe := Timer.new()
	probe.name = "RuntimeOverlapProbe"
	probe.one_shot = true
	probe.wait_time = 0.05
	area.add_child(probe)
	probe.timeout.connect(Callable(self, "_on_rootfang_runtime_overlap_probe").bind(area.get_instance_id()))
	probe.start()


func _on_rootfang_runtime_overlap_probe(area_id: int) -> void:
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
