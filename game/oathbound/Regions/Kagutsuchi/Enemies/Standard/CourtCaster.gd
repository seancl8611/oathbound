extends HumanoidEnemyBase

## =============================================================================
## COURT CASTER — Area 3 Shade Splitter
## =============================================================================
## Replaces old Archer V3 inheritance chain:
##   OLD: Court Caster / Archer V3 -> archer_v2.gd -> older archer stack
##   NEW: Court Caster -> HumanoidEnemyBase -> EnemyBase
##
## Preserved functionality:
## - Ranged caster enemy
## - Channels fan volleys
## - Escalates if ignored: more projectiles + wider arc
## - Projectiles are parryable/deflectable
## - Taking damage cancels channel and resets volley escalation
## - First death triggers corruption reform
## - Reform phase 1: invulnerable channel
## - Reform phase 2: vulnerable body HP pool
## - If not destroyed, revives once
## - Deathblow kills permanently
## =============================================================================

# =============================================================================
# COURT CASTER CORE
# =============================================================================

@export_group("Court Caster Core")
@export var court_caster_debug_name: String = "Court Caster"
@export var debug_logs: bool = false

# =============================================================================
# AI / ENGAGEMENT
# =============================================================================

@export_group("AI / Engagement")
@export var preferred_range: float = 190.0
@export var cast_range: float = 320.0
@export var too_close_range: float = 85.0
@export var reposition_range: float = 130.0
@export var cast_cooldown: float = 3.4
@export var first_cast_delay_min: float = 0.85
@export var first_cast_delay_max: float = 1.45
@export var retreat_speed_fraction: float = 0.85
@export var strafe_speed_fraction: float = 0.45
@export var strafe_flip_chance: float = 0.025

var _strafe_dir: float = 1.0

# =============================================================================
# PROJECTILE / WAVE TUNING
# =============================================================================

@export_group("Projectile")
@export var projectile_damage: int = 8
@export var max_range: float = 520.0
@export var orb_radius: float = 8.0
@export var orb_speed_override: float = 120.0
@export var reflected_orb_speed_mult: float = 1.25
@export var reflected_damage_mult: float = 1.5

@export_group("Projectile Collision")
@export var projectile_collision_layer: int = 2
@export var projectile_collision_mask: int = 2

var _active_waves: Array[Area2D] = []

# =============================================================================
# CHANNEL VOLLEY TUNING
# =============================================================================

@export_group("Channel Volley")
@export var fan_base_count: int = 3
@export var fan_base_arc_deg: float = 60.0
@export var fan_escalate_count: int = 5
@export var fan_escalate_arc_deg: float = 100.0
@export var channel_duration: float = 3.0
@export var volley_interval: float = 0.5
@export var volley_reset_timeout: float = 8.0
@export var fan_aim_jitter_deg: float = 10.0
@export var fan_min_spacing_ratio: float = 0.5
@export var prediction_strength: float = 0.55

var _volley_count: int = 0
var _last_volley_time: float = -99.0
var _channel_active: bool = false
var _channel_until: float = 0.0
var _next_volley_time: float = 0.0
var _shots_fired: int = 0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================

@export_group("Posture Break")
@export var posture_break_duration: float = 3.0

var _dbroken_active: bool = false
var _dbreak_until: float = 0.0

@export_group("Caster Guard")
@export var caster_guard_radius: float = 175.0

# =============================================================================
# CORRUPTION REVIVE
# =============================================================================

@export_group("Corruption Revive")
@export var channel_time: float = 3.0
@export var vulnerable_time: float = 4.0
@export var reform_hp: int = 25
@export var revive_hp_ratio: float = 0.40

var _reforming: bool = false
var _reform_phase: int = 0 # 0 = none, 1 = channeling, 2 = vulnerable
var _reform_until: float = 0.0
var _reform_hp_current: int = 0
var _has_revived: bool = false
var _reform_tween: Tween = null

# =============================================================================
# READY / PHYSICS
# =============================================================================

func _ready() -> void:
	super._ready()
	
	# Court Caster can guard like other disciplined Area 3 humanoids.
	can_block = true
	block_by_default = true
	
	if auto_aggro_on_spawn:
		_saw_player_once = true
	
	next_swipe_time = Time.get_ticks_msec() * 0.001 + randf_range(first_cast_delay_min, first_cast_delay_max)


func _physics_process(delta: float) -> void:
	if _reforming:
		_tick_reform()
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _humanoid_shared_tick(delta):
		_move_waves(delta)
		_update_basic_movement_anim()
		return
	
	var now := Time.get_ticks_msec() * 0.001

	_move_waves(delta)
	_update_posture_break(now)
	_update_sprite_facing()
	_update_blocking(delta, now)
	_update_volley_timeout(now)
	
	if _dbroken_active:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if _channel_active:
		_tick_channel()
		velocity = velocity.lerp(Vector2.ZERO, 8.0 * delta)
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if now < stunned_until:
		velocity = knockback
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if not is_instance_valid(player):
		_patrol_step(delta)
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if not _saw_player_once and not auto_aggro_on_spawn:
		_try_proximity_aggro()
		_patrol_step(delta)
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	_run_court_caster_ai(now)
	move_and_slide()
	_update_basic_movement_anim()


func engage() -> void:
	_saw_player_once = true
	auto_aggro_on_spawn = true


# =============================================================================
# AI
# =============================================================================

func _run_court_caster_ai(now: float) -> void:
	if not is_instance_valid(player):
		velocity = Vector2.ZERO
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.ZERO
	
	if randf() < strafe_flip_chance:
		_strafe_dir *= -1.0
	
	if now >= next_swipe_time and dist <= cast_range and not _dbroken_active:
		if _try_start_channel():
			velocity = Vector2.ZERO
			return
	
	if dist < too_close_range:
		velocity = -dir * movement_speed * retreat_speed_fraction + knockback
		return
	
	if dist > preferred_range:
		if _approach_gate_ok():
			velocity = dir * movement_speed * 0.65 + knockback
		else:
			velocity = knockback
		return
	
	_release_role("advance_move")
	
	var side := Vector2(-dir.y, dir.x) * _strafe_dir
	velocity = side * movement_speed * strafe_speed_fraction + knockback


func _try_start_channel() -> bool:
	if _channel_active or _dbroken_active or _reforming or has_died:
		return false
	
	if not _request_attack_token():
		return false
	
	_start_channel()
	return true


# =============================================================================
# CHANNEL VOLLEY
# =============================================================================

func _start_channel() -> void:
	_channel_active = true
	telegraphing = false
	is_attacking = true
	
	var now := Time.get_ticks_msec() * 0.001
	_channel_until = now + channel_duration
	_next_volley_time = now
	
	_release_role("advance_move")
	
	if is_instance_valid(player) and is_instance_valid(sprite):
		sprite.flip_h = player.global_position.x < global_position.x
	
	_show_parry_indicator(0.45, false)
	
	if anim:
		if anim.has_animation("shoot"):
			anim.play("shoot")
			anim.speed_scale = 0.5
		elif anim.has_animation("cast"):
			anim.play("cast")
			anim.speed_scale = 0.5
		elif anim.has_animation("attack"):
			anim.play("attack")
			anim.speed_scale = 0.5


func _tick_channel() -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if now >= _channel_until:
		_end_channel(false)
		return
	
	if now >= _next_volley_time:
		_fire_fan_volley()
		_next_volley_time = now + volley_interval


func _end_channel(interrupted: bool = false) -> void:
	_channel_active = false
	is_attacking = false
	telegraphing = false
	
	_hide_parry_indicator()
	
	if anim:
		anim.speed_scale = 1.0
	
	if not interrupted:
		_volley_count += 1
		_last_volley_time = Time.get_ticks_msec() * 0.001
	
	_release_attack_token()
	
	var now := Time.get_ticks_msec() * 0.001
	next_swipe_time = now + cast_cooldown + randf_range(-0.35, 0.35)
	
	if anim:
		if anim.has_animation("idle"):
			anim.play("idle")
		elif anim.has_animation("walk"):
			anim.play("walk")


func _cancel_channel_from_hit() -> void:
	if not _channel_active:
		return
	
	_end_channel(true)
	next_swipe_time = Time.get_ticks_msec() * 0.001 + cast_cooldown * 0.65


func _get_fan_config() -> Dictionary:
	var t := clampf(float(_volley_count) / 2.0, 0.0, 1.0)
	var count := int(round(lerp(float(fan_base_count), float(fan_escalate_count), t)))
	var arc = lerp(fan_base_arc_deg, fan_escalate_arc_deg, t)
	
	return {
		"count": max(1, count),
		"arc_deg": arc
	}


func _fire_fan_volley() -> void:
	if not is_instance_valid(player):
		return
	
	if is_instance_valid(sprite):
		sprite.flip_h = player.global_position.x < global_position.x
	
	var fan_config := _get_fan_config()
	var wave_count := int(fan_config["count"])
	var arc_rad := deg_to_rad(float(fan_config["arc_deg"]))
	
	var shot_speed = max(orb_speed_override, 120.0)
	var target_pos := _get_predicted_target_pos(global_position, player.global_position, shot_speed)
	var base_dir := (target_pos - global_position).normalized()
	
	if base_dir.length() < 0.001:
		base_dir = Vector2.LEFT if sprite and sprite.flip_h else Vector2.RIGHT
	
	var aim_jitter := randf_range(-deg_to_rad(fan_aim_jitter_deg), deg_to_rad(fan_aim_jitter_deg))
	base_dir = base_dir.rotated(aim_jitter)
	
	if wave_count == 1:
		_spawn_orb_projectile(base_dir, shot_speed)
	else:
		var half_arc := arc_rad * 0.5
		var angle_offsets: Array[float] = []
		
		for i in range(wave_count):
			angle_offsets.append(randf_range(-half_arc, half_arc))
		
		angle_offsets.sort()
		
		var min_gap := (arc_rad / float(max(1, wave_count - 1))) * fan_min_spacing_ratio
		
		for i in range(1, angle_offsets.size()):
			if angle_offsets[i] - angle_offsets[i - 1] < min_gap:
				angle_offsets[i] = angle_offsets[i - 1] + min_gap
		
		var center := (angle_offsets[0] + angle_offsets[angle_offsets.size() - 1]) * 0.5
		
		for i in range(angle_offsets.size()):
			angle_offsets[i] = clampf(angle_offsets[i] - center, -half_arc, half_arc)
		
		for angle_offset in angle_offsets:
			_spawn_orb_projectile(base_dir.rotated(angle_offset), shot_speed)
	
	_shots_fired += 1


func _update_volley_timeout(now: float) -> void:
	if _volley_count <= 0:
		return
	
	if now - _last_volley_time > volley_reset_timeout:
		_volley_count = 0


# =============================================================================
# PROJECTILES
# =============================================================================

func _spawn_orb_projectile(dir: Vector2, speed: float) -> void:
	var orb := Area2D.new()
	orb.name = "CourtCasterOrb"
	orb.collision_layer = projectile_collision_layer
	orb.collision_mask = projectile_collision_mask
	orb.monitoring = true
	orb.monitorable = true
	orb.add_to_group("attack")
	orb.add_to_group("enemy_attack")
	
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = orb_radius
	shape.shape = circle
	orb.add_child(shape)
	
	orb.set_meta("attacker", self)
	orb.set_meta("shooter_id", get_instance_id())
	orb.set_meta("shooter", self)
	orb.set_meta("faction", "enemy")
	orb.set_meta("parryable", true)
	orb.set_meta("damage", projectile_damage)
	orb.set_meta("damage_type", "ranged")
	orb.set_meta("direction", dir.normalized())
	orb.set_meta("speed", speed)
	orb.set_meta("swing_token", Time.get_ticks_msec() + randi_range(0, 9999))
	orb.set_meta("knockback_force", 0)
	orb.set_meta("spawn_position", global_position)
	orb.set_meta("max_travel_distance", max_range)
	orb.set_meta("distance_traveled", 0.0)
	orb.set_meta("last_position", global_position)
	
	_add_orb_visuals(orb)
	
	var parent := get_tree().current_scene
	if parent == null:
		parent = get_parent()
	
	parent.add_child(orb)
	orb.global_position = global_position
	
	orb.area_entered.connect(_on_orb_area_entered.bind(orb))
	
	_active_waves.append(orb)


func _add_orb_visuals(orb: Area2D) -> void:
	var segments := 10
	
	var visual := Polygon2D.new()
	var points := PackedVector2Array()
	
	for s in range(segments):
		var angle := float(s) / float(segments) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * orb_radius)
	
	visual.polygon = points
	visual.color = Color(0.7, 0.4, 0.9, 0.85)
	orb.add_child(visual)
	
	var core := Polygon2D.new()
	var core_points := PackedVector2Array()
	
	for s in range(segments):
		var angle := float(s) / float(segments) * TAU
		core_points.append(Vector2(cos(angle), sin(angle)) * (orb_radius * 0.5))
	
	core.polygon = core_points
	core.color = Color(0.9, 0.7, 1.0, 0.95)
	orb.add_child(core)


func _move_waves(delta: float) -> void:
	for i in range(_active_waves.size() - 1, -1, -1):
		var orb := _active_waves[i]
		
		if not is_instance_valid(orb):
			_active_waves.remove_at(i)
			continue
		
		var dir: Vector2 = orb.get_meta("direction", Vector2.ZERO)
		var speed := float(orb.get_meta("speed", 0.0))
		var prev_pos: Vector2 = orb.get_meta("last_position", orb.global_position)
		
		orb.global_position += dir.normalized() * speed * delta
		
		var traveled_step := orb.global_position.distance_to(prev_pos)
		var total_traveled := float(orb.get_meta("distance_traveled", 0.0)) + traveled_step
		var max_travel := float(orb.get_meta("max_travel_distance", max_range))
		
		orb.set_meta("distance_traveled", total_traveled)
		orb.set_meta("last_position", orb.global_position)
		
		if total_traveled >= max_travel:
			orb.queue_free()
			_active_waves.remove_at(i)


func _on_orb_area_entered(area: Area2D, orb: Area2D) -> void:
	if area == null or not is_instance_valid(orb):
		return
	
	if orb.has_meta("_orb_hit"):
		return
	
	var faction := str(orb.get_meta("faction", "enemy"))
	
	if faction == "player":
		_try_reflected_orb_hit_enemy(area, orb)
		return
	
	_try_enemy_orb_hit_player(area, orb)


func _try_enemy_orb_hit_player(area: Area2D, orb: Area2D) -> void:
	if not area.is_in_group("player_hurtbox"):
		return
	
	var p := area.get_parent()
	
	if p and is_instance_valid(p):
		var is_parrying := false
		
		if p.has_method("is_parrying") and p.is_parrying():
			is_parrying = true
		elif p.get("_parry_active") != null and bool(p.get("_parry_active")):
			is_parrying = true
		elif p.get("_parry_grace_until") != null:
			var now := Time.get_ticks_msec() * 0.001
			if now < float(p.get("_parry_grace_until")):
				is_parrying = true
		
		if is_parrying:
			_deflect_orb(orb, p)
			return
		
		var is_blocking := false
		
		if p.has_method("is_blocking") and p.is_blocking():
			is_blocking = true
		
		if is_blocking:
			orb.set_meta("_orb_hit", true)
			area.emit_signal("hurt", projectile_damage, "ranged", orb)
			_remove_orb(orb)
			return
	
	orb.set_meta("_orb_hit", true)
	area.emit_signal("hurt", projectile_damage, "ranged", orb)
	_remove_orb(orb)


func _try_reflected_orb_hit_enemy(area: Area2D, orb: Area2D) -> void:
	var parent := area.get_parent()
	var valid_enemy_hit := area.is_in_group("enemy_hurtbox")
	
	if not valid_enemy_hit and parent and parent.is_in_group("enemy"):
		valid_enemy_hit = true
	
	if not valid_enemy_hit:
		return
	
	orb.set_meta("_orb_hit", true)
	var deflect_dmg := int(round(float(projectile_damage) * reflected_damage_mult))
	area.emit_signal("hurt", deflect_dmg, "ranged", orb)
	_remove_orb(orb)


func _deflect_orb(orb: Area2D, parrier: Node) -> void:
	if not is_instance_valid(orb):
		return
	
	var target := _find_reflect_target(parrier)
	var dir := Vector2.ZERO
	
	if target and target is Node2D:
		dir = (target.global_position - orb.global_position).normalized()
	elif parrier is Node2D:
		dir = (orb.global_position - parrier.global_position).normalized()
	
	if dir.length() < 0.001:
		dir = -Vector2(orb.get_meta("direction", Vector2.RIGHT)).normalized()
	
	var traveled_so_far := float(orb.get_meta("distance_traveled", 0.0))
	
	orb.set_meta("faction", "player")
	orb.set_meta("attacker", parrier)
	orb.set_meta("direction", dir)
	orb.set_meta("speed", float(orb.get_meta("speed", orb_speed_override)) * reflected_orb_speed_mult)
	orb.set_meta("distance_traveled", 0.0)
	orb.set_meta("last_position", orb.global_position)
	orb.set_meta("max_travel_distance", max(max_range, traveled_so_far + 64.0))
	
	if orb.has_meta("_orb_hit"):
		orb.remove_meta("_orb_hit")


func _find_reflect_target(parrier: Node) -> Node2D:
	var best: Node2D = self
	var best_dist := INF
	
	if parrier is Node2D:
		for e in get_tree().get_nodes_in_group("enemy"):
			if not is_instance_valid(e):
				continue
			
			if e == parrier:
				continue
			
			if not (e is Node2D):
				continue
			
			var d = parrier.global_position.distance_to(e.global_position)
			if d < best_dist:
				best = e
				best_dist = d
	
	return best


func _remove_orb(orb: Area2D) -> void:
	if _active_waves.has(orb):
		_active_waves.erase(orb)
	
	if is_instance_valid(orb):
		orb.queue_free()


func _cleanup_waves() -> void:
	for w in _active_waves:
		if is_instance_valid(w):
			w.queue_free()
	
	_active_waves.clear()


func _get_predicted_target_pos(origin: Vector2, target_pos: Vector2, shot_speed: float) -> Vector2:
	if not is_instance_valid(player):
		return target_pos
	
	var player_velocity := Vector2.ZERO
	
	if player.get("velocity") != null:
		player_velocity = Vector2(player.get("velocity"))
	
	var distance := origin.distance_to(target_pos)
	var travel_time = distance / max(1.0, shot_speed)
	
	return target_pos + player_velocity * travel_time * prediction_strength


# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================

func _on_base_posture_broken(duration: float) -> void:
	_enter_posture_break(max(duration, posture_break_duration))


func _on_base_posture_meter_filled() -> void:
	_enter_posture_break(posture_break_duration)


func _enter_posture_break(duration: float) -> void:
	if _reforming or has_died:
		return
	
	_dbroken_active = true
	_dbreak_until = Time.get_ticks_msec() * 0.001 + duration
	stunned_until = _dbreak_until
	
	_cancel_channel_from_hit()
	_release_attack_token()
	_set_blocking(false)
	
	if anim and anim.has_animation("stagger"):
		anim.play("stagger")
	elif anim and anim.has_animation("hurt"):
		anim.play("hurt")
	
	_emit_posture_broken(duration)
	_forward_deathblow_available(duration)


func _update_posture_break(now: float) -> void:
	if not _dbroken_active:
		return
	
	if now < _dbreak_until:
		return
	
	_dbroken_active = false
	stunned_until = 0.0
	
	if combat and combat.has_method("reset_posture"):
		combat.reset_posture()
	else:
		set_posture_value(0.0)
	
	if anim:
		if anim.has_animation("idle"):
			anim.play("idle")
		elif anim.has_animation("walk"):
			anim.play("walk")


func is_deathblow_ready() -> bool:
	if _reforming:
		return false
	
	return _dbroken_active


func receive_deathblow(_attacker: Node) -> void:
	if _reforming:
		return
	
	_permanent_death()


# =============================================================================
# DAMAGE / REVIVE
# =============================================================================

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _reforming and _reform_phase == 1:
		return
	
	if _reforming and _reform_phase == 2:
		var reform_damage = max(1, damage)
		_reform_hp_current -= reform_damage
		
		show_enemy_damage_number(reform_damage, "default", randf_range(-30.0, -20.0))
		_flash_sprite(Color(1.0, 1.0, 1.0, 1.0), 0.05)
		
		if _reform_hp_current <= 0:
			_permanent_death()
		
		return
	
	if _channel_active:
		_cancel_channel_from_hit()
	
	# Hitting the caster is the intended counterplay: reset escalation.
	_volley_count = 0
	
	super._on_hurt_box_hurt(damage, damage_type, attacker)


func death() -> void:
	if _reforming:
		_permanent_death()
		return
	
	if _has_revived:
		_permanent_death()
		return
	
	_enter_reform_state()


func _enter_reform_state() -> void:
	_reforming = true
	_reform_phase = 1
	_reform_until = Time.get_ticks_msec() * 0.001 + channel_time
	
	# Keep node alive during reform so the encounter does not clear early.
	hp = 1
	
	_channel_active = false
	telegraphing = false
	is_attacking = false
	_hide_parry_indicator()
	_release_attack_token()
	_release_all_attack_director_state()
	
	_cleanup_waves()
	
	_dbroken_active = false
	_dbreak_until = 0.0
	stunned_until = 0.0
	
	velocity = Vector2.ZERO
	knockback = Vector2.ZERO
	
	if anim:
		anim.speed_scale = 1.0
	
	if hurt_box and is_instance_valid(hurt_box):
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
	
	set_collision_mask_value(3, false)
	
	if sprite:
		sprite.scale = Vector2.ONE
	
	if anim:
		if anim.has_animation("stagger"):
			anim.play("stagger")
		elif anim.has_animation("hurt"):
			anim.play("hurt")
	
	if combat and combat.has_method("reset_posture"):
		combat.reset_posture()
	else:
		set_posture_value(0.0)
	
	hide_posture_bar()
	
	_volley_count = 0
	_start_reform_visual()
	
	if debug_logs:
		print("[CourtCaster] Reform Phase 1 — channeling %.1fs" % channel_time)


func _tick_reform() -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if now < _reform_until:
		return
	
	if _reform_phase == 1:
		_enter_reform_vulnerable()
	elif _reform_phase == 2:
		_complete_revive()


func _enter_reform_vulnerable() -> void:
	_reform_phase = 2
	_reform_until = Time.get_ticks_msec() * 0.001 + vulnerable_time
	_reform_hp_current = reform_hp
	
	if hurt_box and is_instance_valid(hurt_box):
		hurt_box.set_deferred("monitoring", true)
		hurt_box.set_deferred("monitorable", true)
	
	if _reform_tween and _reform_tween.is_valid():
		_reform_tween.kill()
	
	if sprite:
		_reform_tween = create_tween()
		_reform_tween.set_loops()
		_reform_tween.tween_property(sprite, "modulate", Color(0.9, 0.5, 1.0, 1.0), 0.4)
		_reform_tween.tween_property(sprite, "modulate", Color(0.5, 0.3, 0.7, 0.7), 0.4)
	
	if debug_logs:
		print("[CourtCaster] Reform Phase 2 — vulnerable %d HP for %.1fs" % [_reform_hp_current, vulnerable_time])


func _complete_revive() -> void:
	_reforming = false
	_reform_phase = 0
	_has_revived = true
	
	_dbroken_active = false
	_dbreak_until = 0.0
	stunned_until = 0.0
	
	_stop_reform_visual()
	
	hp = max(1, int(float(get_max_hp()) * revive_hp_ratio))
	
	if combat and combat.has_method("reset_posture"):
		combat.reset_posture()
	else:
		set_posture_value(0.0)
	
	if combat and combat.has_method("update_health_ratio"):
		combat.update_health_ratio(float(hp), float(get_max_hp()))
	
	if hurt_box and is_instance_valid(hurt_box):
		hurt_box.set_deferred("monitoring", true)
		hurt_box.set_deferred("monitorable", true)
	
	set_collision_mask_value(3, true)
	
	if _posture_ui:
		_posture_ui.visible = true
	
	if _posture_fill:
		_posture_fill.size.x = 0.0
	
	var now := Time.get_ticks_msec() * 0.001
	next_swipe_time = now + cast_cooldown
	_volley_count = 0
	
	if sprite:
		var tw := create_tween()
		tw.tween_property(sprite, "modulate", Color(1.5, 1.2, 1.5, 1.0), 0.1)
		tw.tween_property(sprite, "modulate", Color.WHITE, 0.3)
	
	if anim:
		if anim.has_animation("idle"):
			anim.play("idle")
		elif anim.has_animation("walk"):
			anim.play("walk")
	
	_saw_player_once = true
	auto_aggro_on_spawn = true
	
	if debug_logs:
		print("[CourtCaster] Corruption revive complete — %d HP" % hp)


# =============================================================================
# REFORM VISUALS
# =============================================================================

func _start_reform_visual() -> void:
	if _reform_tween and _reform_tween.is_valid():
		_reform_tween.kill()
	
	if not sprite:
		return
	
	sprite.modulate = Color(0.5, 0.3, 0.5, 0.8)
	
	_reform_tween = create_tween()
	_reform_tween.set_loops()
	_reform_tween.tween_property(sprite, "modulate", Color(0.7, 0.4, 0.8, 0.9), 0.6)
	_reform_tween.tween_property(sprite, "modulate", Color(0.4, 0.2, 0.5, 0.6), 0.6)


func _stop_reform_visual() -> void:
	if _reform_tween and _reform_tween.is_valid():
		_reform_tween.kill()
	
	_reform_tween = null
	
	if sprite:
		sprite.modulate = Color.WHITE


# =============================================================================
# PERMANENT DEATH
# =============================================================================

func _permanent_death() -> void:
	_reforming = false
	_reform_phase = 0
	_channel_active = false
	
	_stop_reform_visual()
	_cleanup_waves()
	_hide_parry_indicator()
	_release_attack_token()
	
	if anim:
		anim.speed_scale = 1.0
	
	if hurt_box and is_instance_valid(hurt_box):
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
	
	if not mark_dead():
		return
	
	emit_signal("enemy_died", self)
	
	_run_humanoid_death_rewards()
	base_death_cleanup()

func _update_blocking(_delta: float, now: float) -> void:
	if not can_block or _dbroken_active or _reforming:
		_set_blocking(false)
		return
	
	# Court Caster cannot guard while channeling or actively casting.
	if _channel_active or is_attacking or telegraphing:
		_set_blocking(false)
		return
	
	if ProstheticEffects.is_confused(self):
		_set_blocking(false)
		return
	
	if now < _block_stagger_until:
		_set_blocking(false)
		return
	
	if is_instance_valid(player):
		var dist := global_position.distance_to(player.global_position)
		if dist <= caster_guard_radius:
			_set_blocking(true)
			return
	
	_set_blocking(false)
