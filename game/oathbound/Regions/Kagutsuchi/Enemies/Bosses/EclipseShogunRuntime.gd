extends "res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogun.gd"

## Runtime hardening for Eclipse Shogun temporary hazards and player-facing attack
## presentation. The September 9 replay confirmed lifetime safety, but exposed three
## presentation defects: inherited attack-state flags did not mirror this boss's
## private CombatPhase, high-speed charges could slide around blocking bodies, and
## Timeless Zone used world-centered offsets on a CanvasLayer, producing a giant
## screen-space rectangle that appeared to follow Akio.


func _set_combat_phase(phase: CombatPhase) -> void:
	super._set_combat_phase(phase)
	# HumanoidEnemyBase telemetry/guard/readability consumers use these shared fields.
	# Keep them aligned with the Shogun's authoritative private combat phase.
	telegraphing = phase == CombatPhase.WINDUP
	swinging = phase == CombatPhase.ACTIVE
	is_attacking = phase != CombatPhase.NONE
	_attack_recovery = phase == CombatPhase.RECOVERY


func _runtime_attack_step_blocked(dir: Vector2, speed: float) -> bool:
	if dir.length_squared() <= 0.001 or speed <= 0.0:
		return false
	var dt: float = maxf(get_physics_process_delta_time(), 1.0 / 120.0)
	var motion: Vector2 = dir.normalized() * speed * dt
	# Test before move_and_slide() gets a chance to turn a committed charge into a
	# sideways skate. Walls, Akio, and other enemy bodies all terminate forward travel.
	return test_move(global_transform, motion)


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


func _do_deathly_dash() -> void:
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

	var telegraph: float = dd_telegraph * _get_attack_speed_mult()
	_show_parry_indicator(telegraph + 0.3, true)
	if anim and anim.has_animation("dash_windup"):
		anim.play("dash_windup")
	elif anim and anim.has_animation("swing_antic"):
		anim.play("swing_antic")
	if not await _wait_duration_interruptible(telegraph, my_seq):
		return
	if _should_abort_attack(my_seq):
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	if player and is_instance_valid(player):
		var new_dir: Vector2 = (player.global_position - global_position).normalized()
		if new_dir != Vector2.ZERO:
			dir = new_dir
			_face_direction(dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	var start_pos: Vector2 = global_position
	var dash_time: float = dd_dash_distance / dd_dash_speed
	var elapsed: float = 0.0
	while elapsed < dash_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		if _runtime_attack_step_blocked(dir, dd_dash_speed):
			velocity = Vector2.ZERO
			break
		velocity = dir * dd_dash_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	var end_pos: Vector2 = global_position
	_spawn_deathly_trail(start_pos, end_pos)
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(dd_recovery * _get_attack_speed_mult()).timeout
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


func _do_predators_feint() -> void:
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
	_show_parry_indicator(pf_fake_telegraph + 0.5, true)

	if anim and anim.has_animation("dash_windup"):
		anim.play("dash_windup")
	elif anim and anim.has_animation("swing_antic"):
		anim.play("swing_antic")
	if not await _wait_duration_interruptible(pf_fake_telegraph * _get_attack_speed_mult(), my_seq):
		return

	var fake_speed: float = dd_dash_speed * 0.6
	var fake_time: float = pf_fake_dash_distance / dd_dash_speed
	var elapsed: float = 0.0
	while elapsed < fake_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_finish_attack()
			return
		if _runtime_attack_step_blocked(dir, fake_speed):
			velocity = Vector2.ZERO
			break
		velocity = dir * fake_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)
	if not await _wait_duration_interruptible(pf_pounce_telegraph * _get_attack_speed_mult(), my_seq):
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_swing_hitbox(dir, pf_damage, false, false)
	_is_current_hitbox_melee = true
	_show_parry_indicator(parry_early_window + fm_active + parry_linger_window, false)

	var pounce_time: float = pf_pounce_distance / pf_pounce_speed
	elapsed = 0.0
	while elapsed < pounce_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_finish_attack()
			return
		if _runtime_attack_step_blocked(dir, pf_pounce_speed):
			velocity = Vector2.ZERO
			break
		velocity = dir * pf_pounce_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if not await _wait_duration_interruptible(fm_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return
	_cleanup_hitbox()
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(pf_recovery * _get_attack_speed_mult()).timeout
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


func _do_eclipse_measure() -> void:
	var my_seq: int = int(_attack_sequence_id)
	if _should_abort_attack(my_seq):
		return

	_combo_interrupted = false
	_combo_hit_index = 0
	_combo_is_frozen = false
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	var player := _get_player()
	var base_dir := Vector2.RIGHT
	if player:
		base_dir = (player.global_position - global_position).normalized()
	if base_dir == Vector2.ZERO:
		base_dir = Vector2.RIGHT
	_face_direction(base_dir)

	if anim and anim.has_animation("combo_start"):
		anim.play("combo_start")
	if not await _wait_duration_interruptible(fm_initial_windup * _get_attack_speed_mult(), my_seq):
		return

	_combo_hit_index = 1
	if not await _execute_combo_hit(my_seq, fm_telegraph * _get_attack_speed_mult(), fm_active, 0.15, fm_lunge_distance, fm_lunge_speed, em_damage, false, false, true):
		return
	if not await _wait_duration_interruptible(fm_inter_hit_gap, my_seq):
		return

	_combo_hit_index = 2
	if not await _execute_combo_hit(my_seq, fm_telegraph * _get_attack_speed_mult(), fm_active, 0.12, fm_lunge_distance, fm_lunge_speed, em_damage, false, false, true):
		return
	if _should_abort_attack(my_seq):
		_finish_attack()
		return

	_combo_hit_index = 3
	if sprite:
		sprite.modulate = Color(1.0, 0.4, 0.3)
	var beast_telegraph: float = em_beast_telegraph * _get_attack_speed_mult()
	_show_parry_indicator(beast_telegraph + 0.3, true)
	if not await _wait_duration_interruptible(beast_telegraph, my_seq):
		if sprite:
			sprite.modulate = Color.WHITE
		return

	if player and is_instance_valid(player):
		base_dir = (player.global_position - global_position).normalized()
		if base_dir == Vector2.ZERO:
			base_dir = Vector2.RIGHT
		_face_direction(base_dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_swing_hitbox(base_dir, em_beast_lunge_damage, false, true)
	_is_current_hitbox_melee = true
	var lunge_time: float = em_beast_lunge_distance / em_beast_lunge_speed
	var elapsed: float = 0.0
	while elapsed < lunge_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			if sprite:
				sprite.modulate = Color.WHITE
			_finish_attack()
			return
		if _runtime_attack_step_blocked(base_dir, em_beast_lunge_speed):
			velocity = Vector2.ZERO
			break
		velocity = base_dir * em_beast_lunge_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	await get_tree().create_timer(fm_active).timeout
	_cleanup_hitbox()
	if sprite:
		sprite.modulate = Color.WHITE

	_combo_hit_index = 4
	if not await _execute_combo_hit(
		my_seq,
		fm_telegraph * fm_heavy_telegraph_mult * _get_attack_speed_mult(),
		fm_active,
		fm_recovery,
		fm_lunge_distance,
		fm_lunge_speed,
		em_damage,
		false,
		false,
		true
	):
		return
	_set_combat_phase(CombatPhase.NONE)
	_combo_hit_index = 0
	_finish_attack()


func _do_timeless_zone() -> void:
	var my_seq: int = int(_attack_sequence_id)
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	_timeless_zone_active = true
	velocity = Vector2.ZERO
	var player := _get_player()
	if not player:
		_timeless_zone_active = false
		_finish_attack()
		return

	var safe_pos: Vector2 = player.global_position
	var safe_zone := Node2D.new()
	safe_zone.global_position = safe_pos
	get_parent().add_child(safe_zone)
	_active_hazards.append(safe_zone)

	var safe_visual := Polygon2D.new()
	var pts := PackedVector2Array()
	for s in range(24):
		var angle := float(s) / 24.0 * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * tz_safe_radius)
	safe_visual.polygon = pts
	safe_visual.color = Color(0.9, 0.8, 0.5, 0.15)
	safe_visual.z_index = -1
	safe_zone.add_child(safe_visual)

	# CanvasLayer coordinates are viewport coordinates. The legacy implementation used
	# `-viewport_size * 0.5`, which visibly offset a giant rectangle and made it appear
	# to follow the camera/player. A root Control anchored to the viewport has no world-
	# space offset and remains a deliberate full-screen darkness effect.
	var dark_layer := CanvasLayer.new()
	dark_layer.name = "TimelessZoneCanvas"
	dark_layer.layer = 10
	var darkness := ColorRect.new()
	darkness.name = "TimelessDarkness"
	darkness.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	darkness.mouse_filter = Control.MOUSE_FILTER_IGNORE
	darkness.color = Color(0.015, 0.01, 0.035, 0.58)
	dark_layer.add_child(darkness)
	get_parent().add_child(dark_layer)
	_active_hazards.append(dark_layer)

	var elapsed: float = 0.0
	var attacks_done: int = 0
	var next_attack_time: float = tz_duration / float(tz_attack_count + 1)
	var attack_timer: float = next_attack_time
	while elapsed < tz_duration:
		if _should_abort_attack(my_seq):
			break
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		var dt: float = get_physics_process_delta_time()
		elapsed += dt
		attack_timer -= dt

		if player and is_instance_valid(player):
			var dist_to_safe: float = player.global_position.distance_to(safe_pos)
			if dist_to_safe > tz_safe_radius and "hp" in player:
				var tick_dmg: float = tz_darkness_dps * dt
				var accum: float = float(get_meta("_tz_dmg_accum", 0.0)) + tick_dmg
				if accum >= 1.0:
					var whole: int = int(accum)
					accum -= whole
					player.hp = max(0, player.hp - whole)
					if player.has_method("_update_health_bar"):
						player.call("_update_health_bar")
				set_meta("_tz_dmg_accum", accum)

		if attacks_done < tz_attack_count and attack_timer <= 0.0:
			attacks_done += 1
			attack_timer = next_attack_time
			var attack_dir: Vector2 = (safe_pos - global_position).normalized()
			if attack_dir == Vector2.ZERO:
				attack_dir = Vector2.RIGHT
			global_position = safe_pos - attack_dir * (tz_safe_radius + 30.0)
			_face_direction(attack_dir)
			_current_hitbox = _spawn_swing_hitbox(attack_dir, fm_damage, false, false)
			_is_current_hitbox_melee = true
			_show_parry_indicator(parry_early_window + fm_active + parry_linger_window, false)
			await get_tree().create_timer(parry_early_window + fm_active + parry_linger_window).timeout
			if not is_instance_valid(self):
				return
			_cleanup_hitbox()

	remove_meta("_tz_dmg_accum")
	_timeless_zone_active = false
	if is_instance_valid(safe_zone):
		safe_zone.queue_free()
	if is_instance_valid(dark_layer):
		dark_layer.queue_free()
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(0.5).timeout
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


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
