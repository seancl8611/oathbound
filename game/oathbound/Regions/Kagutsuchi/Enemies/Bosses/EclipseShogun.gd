extends "res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogunCore.gd"

## September 3 final-boss playtest repair layer.
##
## The authored Eclipse Shogun implementation remains in EclipseShogunCore.gd. This
## wrapper contains only evidence-backed runtime repairs from build b920e137:
## - resolve a live chamber Loot owner at death instead of reusing HumanoidEnemyBase's
##   stale first-group-member cache;
## - keep short-lived boss hazards owned by the temporary node so room/phase cleanup
##   cannot leave lambdas capturing freed Objects;
## - prevent high-speed attack motion from continuing to drive the boss into the
##   player's body once the existing authored too_close_threshold has been crossed.


func _run_humanoid_death_rewards() -> void:
	notify_stance_effects_enemy_death()
	_hide_parry_indicator()
	_release_all_attack_director_state()

	if death_anim:
		spawn_death_vfx(death_anim)

	if exp_gem:
		var reward_parent: Node = _resolve_live_reward_parent()
		if reward_parent != null:
			spawn_experience_gem(exp_gem, reward_parent)
		else:
			push_warning("[EclipseShogun] No live reward parent; skipping experience gem instead of using stale loot ownership")

	award_area_gold_drop()
	_soft_reset_humanoid_attack_runtime()


func _resolve_live_reward_parent() -> Node:
	var ancestor: Node = get_parent()
	while ancestor != null:
		var direct_loot: Node = ancestor.get_node_or_null("Loot")
		if direct_loot != null and is_instance_valid(direct_loot) and direct_loot.is_inside_tree():
			return direct_loot
		ancestor = ancestor.get_parent()

	for candidate: Node in get_tree().get_nodes_in_group("loot"):
		if candidate == null or not is_instance_valid(candidate) or not candidate.is_inside_tree():
			continue
		if candidate.name == &"Loot":
			return candidate

	var fallback: Node = get_parent()
	return fallback if fallback != null and is_instance_valid(fallback) and fallback.is_inside_tree() else null


func _apply_soft_separation() -> void:
	# Preserve the authored non-active spacing logic first.
	super._apply_soft_separation()

	if _phase == Phase.DEAD or _dbroken_active:
		return

	var current_player: Node = _get_player()
	if current_player == null or not (current_player is Node2D):
		return

	var to_player: Vector2 = (current_player as Node2D).global_position - global_position
	var dist: float = to_player.length()
	var clearance: float = maxf(float(min_separation), float(too_close_threshold))
	if dist <= 0.1 or dist >= clearance:
		return

	# The original soft separation was disabled during ACTIVE attacks, allowing
	# 500-550 px/s dash/pounce motion to pin against or cross the tiny Player body.
	# Remove only the inward component once the already-authored too-close distance is
	# crossed, then add the same style of soft outward correction used by the core AI.
	var toward_player: Vector2 = to_player.normalized()
	var inward_speed: float = velocity.dot(toward_player)
	if inward_speed > 0.0:
		velocity -= toward_player * inward_speed
	velocity -= toward_player * ((clearance - dist) * 4.0)


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
	var end_pos := start_pos + dir * bd_projectile_range
	var out_time := bd_projectile_range / bd_projectile_speed

	# Node-owned tween dies with the projectile if phase/death cleanup frees it early.
	var tw := proj.create_tween()
	tw.tween_property(proj, "global_position", end_pos, out_time)
	tw.tween_property(proj, "global_position", start_pos, out_time)
	tw.tween_callback(Callable(proj, "queue_free"))
	_active_hazards.append(proj)


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

	var travel_time := 200.0 / bwa_lane_speed
	var tw := lane.create_tween()
	tw.tween_property(lane, "global_position", origin + dir * 200.0, travel_time)
	tw.tween_callback(Callable(lane, "queue_free"))


func _do_blood_halo() -> void:
	var my_seq := _attack_sequence_id
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
		var current_player: Node = _get_player()
		if current_player != null and is_instance_valid(current_player) and current_player is Node2D:
			var dist := (current_player as Node2D).global_position.distance_to(global_position)
			if dist >= bh_radius * 0.7 and dist <= bh_radius * 1.1:
				var tick_hit := _spawn_radial_burst((current_player as Node2D).global_position, 15.0, bh_damage, true)
				_arm_node_lifetime(tick_hit, 0.15)

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
	if not is_instance_valid(self):
		return
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


func _arm_node_lifetime(node: Node, seconds: float) -> void:
	if node == null or not is_instance_valid(node):
		return
	var timer := Timer.new()
	timer.one_shot = true
	timer.wait_time = maxf(0.001, seconds)
	node.add_child(timer)
	timer.timeout.connect(Callable(node, "queue_free"))
	timer.start()
