extends HumanoidEnemyBase
class_name LanternWraith

## =============================================================================
## LANTERN WRAITH - Area 2 Wave Ranged Humanoid
## =============================================================================
## Role:
## - Humanoid ranged enemy
## - Fires wide parryable wave projectiles
## - Uses evasive hop / AOE repulse when pressured
## - Extends HumanoidEnemyBase directly instead of old archer.gd
## =============================================================================

enum LanternState {
	PATROL,
	ENGAGE,
	AIM,
	SHOOT,
	RECOVER,
	BACKOFF,
	HOP,
	AOE,
	STAGGER,
	DEAD
}

# =============================================================================
# CORE TUNING
# =============================================================================

@export_group("Lantern Stats")
@export var lantern_hp: int = 50
@export var lantern_experience: int = 2
@export var lantern_move_speed: float = 70.0

@export_group("Ranged Attack")
@export var projectile_damage: int = 6
@export var projectile_speed: float = 230.0
@export var shot_cooldown: float = 5.0
@export var aim_duration: float = 0.70
@export var shoot_duration: float = 0.25
@export var recover_duration: float = 0.35
@export var max_range: float = 560.0
@export var preferred_range: float = 220.0
@export var min_range: float = 100.0
@export var fire_range: float = 360.0
@export var prediction_strength: float = 0.55

@export_group("Wave Projectile")
@export var wave_width: float = 60.0
@export var wave_height: float = 12.0
@export var wave_lifetime_padding: float = 0.20

@export_group("Movement")
@export var approach_speed: float = 85.0
@export var kite_speed: float = 95.0
@export var orbit_speed: float = 60.0
@export var backoff_speed: float = 105.0
@export var engage_deaggro_radius: float = 420.0

@export_group("AOE Repulse")
@export var aoe_damage: int = 4
@export var aoe_radius: float = 45.0
@export var aoe_trigger_range: float = 55.0
@export var aoe_cooldown: float = 5.0
@export var aoe_jump_speed: float = 260.0
@export var aoe_jump_time: float = 0.38
@export var aoe_windup_time: float = 0.12
@export var aoe_pulse_delay: float = 0.20

@export_group("Evasive Hop")
@export var hop_cooldown: float = 5.0
@export var hop_speed: float = 280.0
@export var hop_time: float = 0.35
@export var hop_windup_time: float = 0.12
@export var hop_trigger_range: float = 80.0
@export var hop_random_interval_min: float = 12.0
@export var hop_random_interval_max: float = 20.0
@export var hop_random_chance: float = 0.25
@export var hop_pressure_threshold: float = 2.5
@export var reposition_global_cooldown: float = 6.0

@export_group("Combat Reaction")
@export var parry_recoil_time: float = 0.60
@export var parry_knockback_force: float = 80.0
@export var hurt_stun_time: float = 0.12

# =============================================================================
# RUNTIME
# =============================================================================

var state: int = LanternState.PATROL
var _state_timer: float = 0.0

var _aggro: bool = false
var _next_shot_ready: float = 0.0
var _stunned_until: float = 0.0

var _active_waves: Array = []

var _aim_dir: Vector2 = Vector2.RIGHT
var _player_last_pos: Vector2 = Vector2.ZERO
var _player_velocity: Vector2 = Vector2.ZERO

var _aoe_cooldown_until: float = 0.0
var _hop_cooldown_until: float = 0.0
var _next_random_hop_time: float = 0.0
var _reposition_cooldown_until: float = 0.0
var _pressure_time: float = 0.0
var _must_attack_next: bool = false

var _action_gen: int = 0
var _action_active_since: float = 0.0
var _aoe_active: bool = false
var _hop_active: bool = false

var _last_pos: Vector2 = Vector2.ZERO
var _last_move_speed: float = 0.0
var _current_anim: String = ""

# =============================================================================
# INITIALIZATION
# =============================================================================

func _ready() -> void:
	_apply_lantern_defaults()
	super._ready()
	
	can_block = false
	block_by_default = false
	block_chance_on_hit = 0.0
	
	_home_pos = global_position
	_patrol_target = global_position
	
	var now := Time.get_ticks_msec() * 0.001
	_next_random_hop_time = now + randf_range(hop_random_interval_min, hop_random_interval_max)
	_reposition_cooldown_until = now + 3.0
	_next_shot_ready = now + randf_range(0.8, 1.4)
	
	print("[LanternWraith] v1.0 - HumanoidEnemyBase migrated")


func _apply_lantern_defaults() -> void:
	hp = lantern_hp
	experience = lantern_experience
	movement_speed = lantern_move_speed
	deaggro_radius = engage_deaggro_radius


# =============================================================================
# MAIN LOOP
# =============================================================================

func _physics_process(delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if state == LanternState.DEAD:
		return
	
	_track_player_velocity(delta)
	_track_movement_speed(delta)
	_move_waves(delta)
	_check_action_timeout(now)
	
	if _humanoid_shared_tick(delta):
		_update_animation()
		return
	
	if now < _stunned_until and state != LanternState.STAGGER:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_sprite_facing()
		_update_animation()
		return
	
	_update_pressure_timer(delta)
	
	if _state_timer > 0.0:
		_state_timer -= delta
	
	match state:
		LanternState.PATROL:
			_state_patrol(delta, now)
		LanternState.ENGAGE:
			_state_engage(delta, now)
		LanternState.AIM:
			_state_aim(delta, now)
		LanternState.SHOOT:
			_state_shoot(delta, now)
		LanternState.RECOVER:
			_state_recover(delta, now)
		LanternState.BACKOFF:
			_state_backoff(delta, now)
		LanternState.HOP:
			velocity = knockback
		LanternState.AOE:
			velocity = knockback
		LanternState.STAGGER:
			_state_stagger(delta, now)
	
	if knockback.length() > 1.0:
		velocity += knockback
		tick_base_knockback(delta)
	
	move_and_slide()
	_update_sprite_facing()
	_update_animation()


func _track_player_velocity(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	var player_pos := player.global_position
	var raw_vel := Vector2.ZERO
	
	if player is CharacterBody2D:
		raw_vel = player.velocity
	else:
		raw_vel = (player_pos - _player_last_pos) / max(delta, 0.001)
	
	_player_last_pos = player_pos
	
	var alpha := 1.0 - exp(-delta * 12.0)
	_player_velocity = _player_velocity.lerp(raw_vel, alpha)


func _track_movement_speed(delta: float) -> void:
	var prev := _last_pos if _last_pos != Vector2.ZERO else global_position
	var moved := global_position - prev
	_last_move_speed = moved.length() / max(0.0001, delta)
	_last_pos = global_position


func _goto(new_state: int, timer: float = 0.0) -> void:
	state = new_state
	_state_timer = timer


# =============================================================================
# STATE MACHINE
# =============================================================================

func _state_patrol(delta: float, _now: float) -> void:
	if _check_aggro():
		_goto(LanternState.ENGAGE)
		return
	
	_patrol_step(delta)


func _state_engage(_delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(LanternState.PATROL)
		return
	
	if _player_hidden_in_smoke():
		velocity = Vector2.ZERO
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.RIGHT
	
	if dist > deaggro_radius:
		_saw_player_once = false
		_goto(LanternState.PATROL)
		return
	
	if not _aoe_active and not _hop_active:
		if _check_melee_pressure(now, dist, dir):
			return
		if _check_evasive_hop(now, dist):
			return
	
	if now >= _next_shot_ready and dist <= fire_range:
		_start_aim()
		return
	
	if dist < min_range:
		velocity = -dir * kite_speed
	elif dist > preferred_range:
		if _approach_gate_ok():
			velocity = dir * approach_speed
		else:
			velocity = dir.rotated(PI * 0.5) * orbit_speed
	else:
		velocity = dir.rotated(PI * 0.5) * orbit_speed * 0.55


func _state_aim(_delta: float, _now: float) -> void:
	velocity = Vector2.ZERO
	
	if is_instance_valid(player):
		var predicted := _get_predicted_target_pos(global_position, player.global_position, projectile_speed)
		var to_target := predicted - global_position
		if to_target.length_squared() > 0.001:
			_aim_dir = to_target.normalized()
	
	if _state_timer <= 0.0:
		_fire_wave()


func _state_shoot(_delta: float, _now: float) -> void:
	velocity = Vector2.ZERO
	
	if _state_timer <= 0.0:
		_finish_shot()


func _state_recover(_delta: float, _now: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 360.0 * _delta)
	
	if _state_timer <= 0.0:
		_goto(LanternState.ENGAGE)


func _state_backoff(_delta: float, _now: float) -> void:
	if not is_instance_valid(player):
		_goto(LanternState.PATROL)
		return
	
	var away := player.global_position.direction_to(global_position)
	if away.length_squared() < 0.001:
		away = Vector2.RIGHT
	
	velocity = away.normalized() * backoff_speed
	
	if _state_timer <= 0.0:
		_goto(LanternState.ENGAGE)


func _state_stagger(_delta: float, _now: float) -> void:
	velocity = knockback
	
	if _state_timer <= 0.0:
		_goto(LanternState.ENGAGE)


# =============================================================================
# RANGED ATTACK
# =============================================================================

func _start_aim() -> void:
	if not _request_role("ranged_attack"):
		_next_shot_ready = Time.get_ticks_msec() * 0.001 + 0.35
		return
	
	has_attack_token = true
	telegraphing = true
	is_attacking = false
	swinging = false
	
	_release_role("advance_move")
	_bump_action_gen()
	
	if is_instance_valid(player):
		var predicted := _get_predicted_target_pos(global_position, player.global_position, projectile_speed)
		var to_target := predicted - global_position
		if to_target.length_squared() > 0.001:
			_aim_dir = to_target.normalized()
	
	_show_parry_indicator(aim_duration, false)
	
	if anim and anim.has_animation("attack_windup"):
		anim.play("attack_windup")
		var base_len := anim.get_animation("attack_windup").length
		_set_anim_speed_safe(base_len / max(0.001, aim_duration))
	
	_goto(LanternState.AIM, aim_duration)


func _fire_wave() -> void:
	_must_attack_next = false
	telegraphing = false
	is_attacking = true
	swinging = false
	
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	if is_instance_valid(player):
		var shot_speed = max(projectile_speed, 220.0)
		var target_pos := _get_predicted_target_pos(global_position, player.global_position, shot_speed)
		var dir := (target_pos - global_position).normalized()
		if dir.length_squared() <= 0.001:
			dir = _aim_dir
		
		_spawn_wave_projectile(dir, shot_speed)
	
	if anim and anim.has_animation("shoot"):
		anim.play("shoot")
		var base_len := anim.get_animation("shoot").length
		_set_anim_speed_safe(base_len / max(0.001, shoot_duration))
	elif anim and anim.has_animation("attack"):
		anim.play("attack")
	
	_goto(LanternState.SHOOT, shoot_duration)


func _finish_shot() -> void:
	_release_role("ranged_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	telegraphing = false
	is_attacking = false
	swinging = false
	
	_set_anim_speed_safe(1.0)
	
	var now := Time.get_ticks_msec() * 0.001
	_next_shot_ready = now + shot_cooldown + randf_range(-0.5, 0.5)
	
	_goto(LanternState.RECOVER, recover_duration)


func _cancel_ranged_action(backoff_time: float = 0.45) -> void:
	_bump_action_gen()
	
	telegraphing = false
	is_attacking = false
	swinging = false
	_aoe_active = false
	_hop_active = false
	_action_active_since = 0.0
	
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	if sprite:
		sprite.scale = Vector2.ONE
	
	_release_role("ranged_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	var now := Time.get_ticks_msec() * 0.001
	_backoff_until = max(_backoff_until, now + backoff_time)
	_next_shot_ready = max(_next_shot_ready, now + backoff_time)
	
	if state != LanternState.DEAD:
		_goto(LanternState.BACKOFF, min(backoff_time, 0.8))


func _bump_action_gen() -> int:
	_action_gen += 1
	if _action_gen > 1000000000:
		_action_gen = 1
	_attack_gen += 1
	_parry_gen += 1
	return _action_gen


func _check_action_timeout(now: float) -> void:
	if not (_hop_active or _aoe_active):
		return
	
	if _action_active_since <= 0.0:
		return
	
	if now - _action_active_since <= 3.0:
		return
	
	_hop_active = false
	_aoe_active = false
	_action_active_since = 0.0
	
	if sprite:
		sprite.scale = Vector2.ONE
	
	_goto(LanternState.ENGAGE)


# =============================================================================
# WAVE PROJECTILE
# =============================================================================

func _spawn_wave_projectile(dir: Vector2, speed: float) -> void:
	var wave := Area2D.new()
	wave.name = "LanternWave"
	wave.collision_layer = 0
	wave.collision_mask = 2
	wave.monitoring = true
	wave.monitorable = true
	wave.add_to_group("attack")
	
	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(wave_height, wave_width)
	shape.shape = rect
	shape.rotation = dir.angle()
	wave.add_child(shape)
	
	wave.set_meta("attacker", self)
	wave.set_meta("shooter_id", get_instance_id())
	wave.set_meta("shooter", self)
	wave.set_meta("faction", "enemy")
	wave.set_meta("parryable", true)
	wave.set_meta("damage", projectile_damage)
	wave.set_meta("damage_type", "ranged")
	wave.set_meta("direction", dir)
	wave.set_meta("speed", speed)
	wave.set_meta("swing_token", Time.get_ticks_msec())
	
	var visual := Polygon2D.new()
	var hw := wave_width * 0.5
	var hh := wave_height * 0.5
	visual.polygon = PackedVector2Array([
		Vector2(-hh, -hw),
		Vector2(hh, -hw),
		Vector2(hh, hw),
		Vector2(-hh, hw)
	])
	visual.color = Color(0.65, 0.5, 0.85, 0.7)
	visual.rotation = dir.angle()
	wave.add_child(visual)
	
	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root
	
	parent.add_child(wave)
	wave.global_position = global_position
	
	wave.area_entered.connect(func(area: Area2D):
		_on_wave_area_entered(wave, area)
	)
	
	_active_waves.append(wave)
	
	var max_time = max_range / max(1.0, speed)
	get_tree().create_timer(max_time + wave_lifetime_padding).timeout.connect(func():
		if is_instance_valid(wave):
			wave.queue_free()
	)


func _move_waves(delta: float) -> void:
	var i := _active_waves.size() - 1
	
	while i >= 0:
		var wave = _active_waves[i]
		
		if not is_instance_valid(wave):
			_active_waves.remove_at(i)
		else:
			var dir := Vector2.RIGHT
			var speed := projectile_speed
			
			if wave.has_meta("direction"):
				dir = wave.get_meta("direction")
			if wave.has_meta("speed"):
				speed = float(wave.get_meta("speed"))
			
			wave.global_position += dir * speed * delta
		
		i -= 1


func _on_wave_area_entered(wave: Area2D, area: Area2D) -> void:
	if not is_instance_valid(wave):
		return
	
	if area == null:
		return
	
	if wave.has_meta("_wave_hit"):
		return
	
	var faction := str(wave.get_meta("faction", "enemy"))
	
	if faction == "player":
		if not area.is_in_group("enemy_hurtbox"):
			var parent := area.get_parent()
			if not (parent and parent.is_in_group("enemy")):
				return
		
		wave.set_meta("_wave_hit", true)
		var deflect_dmg := int(projectile_damage * 1.5)
		
		if area.has_signal("hurt"):
			area.emit_signal("hurt", deflect_dmg, "ranged", wave)
		
		wave.queue_free()
		return
	
	if not area.is_in_group("player_hurtbox"):
		return
	
	var p := area.get_parent()
	if p and is_instance_valid(p):
		if _check_player_parrying(p):
			_deflect_wave(wave, p)
			return
		
		if _check_player_blocking(p):
			wave.set_meta("_wave_hit", true)
			if area.has_signal("hurt"):
				area.emit_signal("hurt", projectile_damage, "ranged", wave)
			wave.queue_free()
			return
	
	wave.set_meta("_wave_hit", true)
	if area.has_signal("hurt"):
		area.emit_signal("hurt", projectile_damage, "ranged", wave)
	wave.queue_free()


func _deflect_wave(wave: Area2D, deflector: Node) -> void:
	if not is_instance_valid(wave):
		return
	
	if wave.has_meta("_wave_hit"):
		return
	
	var new_dir := Vector2.RIGHT
	if is_instance_valid(self):
		new_dir = (global_position - wave.global_position).normalized()
	
	if new_dir.length_squared() <= 0.001:
		new_dir = -Vector2.RIGHT
	
	on_parried(deflector.global_position if deflector is Node2D else wave.global_position)
	
	wave.set_meta("direction", new_dir)
	wave.set_meta("speed", float(wave.get_meta("speed", projectile_speed)) * 1.3)
	wave.set_meta("faction", "player")
	wave.set_meta("attacker", deflector)
	
	wave.collision_layer = 0
	wave.collision_mask = 4
	
	for child in wave.get_children():
		if child is Polygon2D:
			child.rotation = new_dir.angle()
			child.color = Color(0.4, 0.8, 1.0, 0.8)
		elif child is CollisionShape2D:
			child.rotation = new_dir.angle()
	
	var hurtbox = deflector.get_node_or_null("HurtBox") if deflector else null
	if hurtbox and hurtbox.has_signal("hurt"):
		hurtbox.emit_signal("hurt", 0, "ranged", wave)


func _cleanup_waves() -> void:
	for wave in _active_waves:
		if is_instance_valid(wave):
			wave.queue_free()
	
	_active_waves.clear()


# =============================================================================
# MELEE PRESSURE / REPOSITION
# =============================================================================

func _update_pressure_timer(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	var dist := global_position.distance_to(player.global_position)
	
	if dist < hop_trigger_range:
		_pressure_time += delta
	else:
		_pressure_time = max(0.0, _pressure_time - delta * 0.5)


func _check_melee_pressure(now: float, dist: float, dir_to_player: Vector2) -> bool:
	if now < _aoe_cooldown_until:
		return false
	if now < _reposition_cooldown_until:
		return false
	if _aoe_active or _hop_active:
		return false
	if dist > aoe_trigger_range:
		return false
	
	if state == LanternState.AIM or state == LanternState.SHOOT:
		_cancel_ranged_action(0.25)
	
	_fire_aoe_repulse(dir_to_player, now)
	return true


func _check_evasive_hop(now: float, dist: float) -> bool:
	if _aoe_active or _hop_active:
		return false
	
	if telegraphing or is_attacking:
		return false
	
	if now < _hop_cooldown_until:
		return false
	
	if now < _reposition_cooldown_until:
		return false
	
	if _must_attack_next:
		return false
	
	var should_hop := false
	
	if dist < hop_trigger_range and _pressure_time >= hop_pressure_threshold:
		should_hop = true
	
	if not should_hop and now >= _next_random_hop_time:
		if state != LanternState.AIM and state != LanternState.SHOOT:
			if randf() < hop_random_chance:
				should_hop = true
			_next_random_hop_time = now + randf_range(hop_random_interval_min, hop_random_interval_max)
	
	if not should_hop:
		return false
	
	_pressure_time = 0.0
	_do_evasive_hop()
	return true


func _do_evasive_hop() -> void:
	var now := Time.get_ticks_msec() * 0.001
	_hop_cooldown_until = now + hop_cooldown
	_reposition_cooldown_until = now + reposition_global_cooldown
	_next_random_hop_time = now + randf_range(hop_random_interval_min, hop_random_interval_max)
	_hop_active = true
	_action_active_since = now
	_must_attack_next = true
	
	var gen := _bump_action_gen()
	
	if state == LanternState.AIM or state == LanternState.SHOOT:
		_cancel_ranged_action(0.25)
	
	_goto(LanternState.HOP, hop_windup_time + hop_time)
	velocity = Vector2.ZERO
	
	var hop_dir := Vector2.RIGHT
	if is_instance_valid(player):
		var away := player.global_position.direction_to(global_position)
		var lateral := Vector2(-away.y, away.x) * (1.0 if randf() > 0.5 else -1.0)
		hop_dir = (away * 0.7 + lateral * randf_range(0.3, 0.8)).normalized()
	else:
		hop_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	
	hop_dir = _get_wall_avoiding_direction(hop_dir)
	
	if sprite:
		var tw_squash := create_tween()
		tw_squash.tween_property(sprite, "scale", Vector2(1.15, 0.85), hop_windup_time * 0.5)
		tw_squash.tween_property(sprite, "scale", Vector2(0.85, 1.2), hop_windup_time * 0.5)
	
	await get_tree().create_timer(hop_windup_time).timeout
	if not is_inside_tree() or _action_gen != gen:
		return
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + hop_time
	knockback = hop_dir * hop_speed
	
	if anim:
		if anim.has_animation("dodge"):
			anim.play("dodge")
		elif anim.has_animation("walk"):
			anim.speed_scale = 1.5
			anim.play("walk")
	
	if sprite:
		var tw_stretch := create_tween()
		tw_stretch.tween_property(sprite, "scale", Vector2(0.9, 1.15), hop_time * 0.4)
		tw_stretch.tween_property(sprite, "scale", Vector2(1.1, 0.9), hop_time * 0.3)
		tw_stretch.tween_property(sprite, "scale", Vector2(1.0, 1.0), hop_time * 0.3)
	
	await get_tree().create_timer(hop_time).timeout
	if not is_inside_tree() or _action_gen != gen:
		return
	
	_hop_active = false
	_action_active_since = 0.0
	
	if sprite:
		sprite.scale = Vector2.ONE
	
	_goto(LanternState.ENGAGE)


func _fire_aoe_repulse(dir_to_player: Vector2, now: float) -> void:
	_aoe_active = true
	_action_active_since = now
	_must_attack_next = true
	
	var gen := _bump_action_gen()
	
	_goto(LanternState.AOE, aoe_windup_time + aoe_jump_time + aoe_pulse_delay)
	
	var aoe_origin := global_position
	
	if sprite:
		var tw_squash := create_tween()
		tw_squash.tween_property(sprite, "scale", Vector2(1.15, 0.85), aoe_windup_time * 0.5)
		tw_squash.tween_property(sprite, "scale", Vector2(0.85, 1.2), aoe_windup_time * 0.5)
	
	await get_tree().create_timer(aoe_windup_time).timeout
	if not is_inside_tree() or _action_gen != gen:
		_aoe_active = false
		_action_active_since = 0.0
		return
	
	var jump_dir := -dir_to_player
	if jump_dir.length() < 0.1:
		jump_dir = Vector2.LEFT if sprite and sprite.flip_h else Vector2.RIGHT
	
	jump_dir = _get_wall_avoiding_direction(jump_dir.normalized())
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + aoe_jump_time
	knockback = jump_dir * aoe_jump_speed
	
	if sprite:
		var tw_stretch := create_tween()
		tw_stretch.tween_property(sprite, "scale", Vector2(0.9, 1.15), aoe_jump_time * 0.4)
		tw_stretch.tween_property(sprite, "scale", Vector2(1.1, 0.9), aoe_jump_time * 0.3)
		tw_stretch.tween_property(sprite, "scale", Vector2(1.0, 1.0), aoe_jump_time * 0.3)
	
	var telegraph_visual := _spawn_aoe_telegraph(aoe_origin)
	
	await get_tree().create_timer(aoe_jump_time + aoe_pulse_delay).timeout
	if not is_inside_tree() or _action_gen != gen:
		if is_instance_valid(telegraph_visual):
			telegraph_visual.queue_free()
		_aoe_active = false
		_action_active_since = 0.0
		return
	
	if is_instance_valid(telegraph_visual):
		telegraph_visual.queue_free()
	
	_spawn_aoe_pulse(aoe_origin)
	
	_aoe_cooldown_until = Time.get_ticks_msec() * 0.001 + aoe_cooldown
	_reposition_cooldown_until = Time.get_ticks_msec() * 0.001 + reposition_global_cooldown
	
	if sprite:
		sprite.scale = Vector2.ONE
	
	_aoe_active = false
	_action_active_since = 0.0
	_backoff_until = Time.get_ticks_msec() * 0.001 + 0.8
	_goto(LanternState.BACKOFF, 0.8)


func _spawn_aoe_telegraph(pos: Vector2) -> Polygon2D:
	var seg := 20
	var telegraph := Polygon2D.new()
	var points := PackedVector2Array()
	
	for s in range(seg):
		var angle := float(s) / float(seg) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * aoe_radius)
	
	telegraph.polygon = points
	telegraph.color = Color(1.0, 0.5, 0.2, 0.15)
	telegraph.z_index = -1
	telegraph.scale = Vector2(0.3, 0.3)
	telegraph.global_position = pos
	
	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root
	
	parent.add_child(telegraph)
	
	var tw := create_tween()
	tw.tween_property(telegraph, "scale", Vector2(1.0, 1.0), 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(telegraph, "color:a", 0.55, 0.35)
	
	return telegraph


func _spawn_aoe_pulse(pos: Vector2) -> void:
	var pulse := Area2D.new()
	pulse.name = "LanternRepulse"
	pulse.collision_layer = 0
	pulse.collision_mask = 2
	pulse.monitoring = true
	
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = aoe_radius
	shape.shape = circle
	pulse.add_child(shape)
	pulse.global_position = pos
	
	var flash_visual := Polygon2D.new()
	var points := PackedVector2Array()
	
	for s in range(20):
		var angle := float(s) / 20.0 * TAU
		points.append(Vector2(cos(angle), sin(angle)) * aoe_radius)
	
	flash_visual.polygon = points
	flash_visual.color = Color(1.0, 0.4, 0.3, 0.6)
	flash_visual.z_index = -1
	pulse.add_child(flash_visual)
	
	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root
	
	parent.add_child(pulse)
	
	pulse.area_entered.connect(func(area: Area2D):
		if area == null:
			return
		if not area.is_in_group("player_hurtbox"):
			return
		if pulse.has_meta("_aoe_hit"):
			return
		
		pulse.set_meta("_aoe_hit", true)
		
		if area.has_signal("hurt"):
			area.emit_signal("hurt", aoe_damage, "unblockable", self)
	)
	
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(pulse):
			for area in pulse.get_overlapping_areas():
				pulse.area_entered.emit(area)
	)
	
	get_tree().create_timer(0.15).timeout.connect(func():
		if is_instance_valid(pulse):
			pulse.queue_free()
	)


# =============================================================================
# DAMAGE / PARRY / DEATH
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	if state == LanternState.DEAD or has_died:
		return
	
	if hp_damage <= 0:
		return
	
	_cancel_ranged_action(0.35)
	_stunned_until = Time.get_ticks_msec() * 0.001 + hurt_stun_time
	
	if anim and anim.has_animation("hurt"):
		anim.play("hurt")
		_set_anim_speed_safe(1.0)


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()


func on_parried(player_pos: Vector2) -> void:
	if state == LanternState.DEAD or has_died:
		return
	
	_cancel_ranged_action(0.65)
	
	var kb_dir := global_position - player_pos
	if kb_dir.length_squared() < 0.001:
		kb_dir = Vector2.RIGHT
	
	knockback = Vector2.ZERO
	apply_knockback(kb_dir.normalized() * parry_knockback_force)
	hitstop_local(0.08)
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + parry_recoil_time
	_goto(LanternState.STAGGER, parry_recoil_time)


func receive_deathblow(_attacker: Node) -> void:
	force_kill_hp()
	death()


func death() -> void:
	if state == LanternState.DEAD:
		return
	
	if not mark_dead():
		return
	
	_goto(LanternState.DEAD)
	_bump_action_gen()
	_cleanup_waves()
	_hide_parry_indicator()
	
	_release_role("ranged_attack")
	_release_role("advance_move")
	has_attack_token = false
	emit_signal("enemy_died", self)
	
	hide_posture_bar()
	_run_humanoid_death_rewards()
	
	velocity = Vector2.ZERO
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		await get_tree().create_timer(0.45).timeout
	else:
		await get_tree().create_timer(0.25).timeout
	
	queue_free()


func _exit_tree() -> void:
	_bump_action_gen()
	_cleanup_waves()
	_hide_parry_indicator()
	_release_role("ranged_attack")
	_release_role("advance_move")
	_release_all_attack_director_state()


# =============================================================================
# HELPERS
# =============================================================================

func _check_aggro() -> bool:
	if not is_instance_valid(player):
		return false
	
	if auto_aggro_on_spawn or _saw_player_once:
		_saw_player_once = true
		return true
	
	if _aggro:
		_saw_player_once = true
		return true
	
	var dist := global_position.distance_to(player.global_position)
	if dist <= aggro_radius:
		_saw_player_once = true
		return true
	
	return false


func _get_predicted_target_pos(origin: Vector2, target_pos: Vector2, shot_speed: float) -> Vector2:
	if not is_instance_valid(player):
		return target_pos
	
	var dist := origin.distance_to(target_pos)
	var travel_time = dist / max(1.0, shot_speed)
	
	return target_pos + _player_velocity * travel_time * prediction_strength


func _check_player_parrying(p: Node) -> bool:
	if p == null:
		return false
	
	if p.has_method("is_parrying") and p.is_parrying():
		return true
	
	var parry_active = p.get("_parry_active")
	if parry_active != null and bool(parry_active):
		return true
	
	var grace_until = p.get("_parry_grace_until")
	if grace_until != null:
		var now := Time.get_ticks_msec() * 0.001
		if now < float(grace_until):
			return true
	
	return false


func _check_player_blocking(p: Node) -> bool:
	if p == null:
		return false
	
	if p.has_method("is_blocking") and p.is_blocking():
		return true
	
	return false


func _get_wall_avoiding_direction(dir: Vector2) -> Vector2:
	if dir.length_squared() < 0.001:
		return Vector2.RIGHT
	
	var space := get_world_2d().direct_space_state
	if space == null:
		return dir.normalized()
	
	var from := global_position
	var to := from + dir.normalized() * 52.0
	var q := PhysicsRayQueryParameters2D.create(from, to)
	q.exclude = [self]
	
	if is_instance_valid(player):
		q.exclude.append(player)
	
	var hit := space.intersect_ray(q)
	if hit.is_empty():
		return dir.normalized()
	
	var normal := Vector2.ZERO
	if hit.has("normal"):
		normal = hit["normal"]
	
	if normal.length_squared() > 0.001:
		var slide := dir.slide(normal).normalized()
		if slide.length_squared() > 0.001:
			return slide
	
	return dir.rotated(PI * 0.5).normalized()


func _update_sprite_facing() -> void:
	if sprite == null:
		return
	
	if is_instance_valid(player) and state in [LanternState.AIM, LanternState.SHOOT]:
		sprite.flip_h = (player.global_position.x - global_position.x) < 0.0
	elif velocity.length() > 5.0:
		sprite.flip_h = velocity.x < 0.0
	elif is_instance_valid(player):
		sprite.flip_h = (player.global_position.x - global_position.x) < 0.0


func _update_animation() -> void:
	if anim == null:
		return
	
	if state == LanternState.AIM or state == LanternState.SHOOT or state == LanternState.AOE or state == LanternState.HOP:
		return
	
	var anim_name := "idle"
	
	match state:
		LanternState.PATROL, LanternState.ENGAGE, LanternState.BACKOFF:
			anim_name = "walk" if _last_move_speed > 8.0 else "idle"
		LanternState.RECOVER:
			anim_name = "idle"
		LanternState.STAGGER:
			anim_name = "hurt" if anim.has_animation("hurt") else "idle"
		LanternState.DEAD:
			anim_name = "death" if anim.has_animation("death") else "idle"
	
	if anim.has_animation(anim_name) and _current_anim != anim_name:
		anim.play(anim_name)
		_current_anim = anim_name
	
	if anim_name == "walk":
		anim.speed_scale = clamp(_last_move_speed / max(1.0, movement_speed), 0.5, 1.35)
	elif anim_name == "idle":
		anim.speed_scale = 1.0


func _player_hidden_in_smoke() -> bool:
	if not is_instance_valid(player):
		return false
	
	return player.has_meta("in_smoke_cloud") and bool(player.get_meta("in_smoke_cloud"))


func _on_player_trigger_range_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = true


func _on_player_trigger_range_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = false
