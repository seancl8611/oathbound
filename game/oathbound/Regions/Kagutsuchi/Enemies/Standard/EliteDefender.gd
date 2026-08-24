extends HumanoidEnemyBase

## =============================================================================
## ELITE DEFENDER — Area 3 Defensive Skirmisher
## =============================================================================
## OLD:
##   Elite Defender / Shield Enemy -> enemy.gd
##
## NEW:
##   Elite Defender -> HumanoidEnemyBase -> EnemyBase
##
## Identity:
## - Shield-up disciplined Area 3 defender
## - Strong frontal guard with stricter cone than normal humanoids
## - Weak to flanking, posture pressure, parries, and punishing recovery
## - Uses triple spear thrust and sequential spear throws
## - Uses short hoplite-style reposition hops
## =============================================================================

const ELITE_ATTACK_TRIPLE_THRUST := 100
const ELITE_ATTACK_SPEAR_THROW := 101

# =============================================================================
# CORE
# =============================================================================

@export_group("Elite Defender Core")
@export var debug_logs: bool = false
@export var elite_default_hp: int = 130

# =============================================================================
# AI / ENGAGEMENT
# =============================================================================

@export_group("AI / Engagement")
@export var preferred_range: float = 72.0
@export var close_range: float = 42.0
@export var mid_range: float = 135.0
@export var attack_range: float = 150.0
@export var hold_distance: float = 78.0
@export var attack_cooldown_min: float = 0.85
@export var attack_cooldown_max: float = 1.35
@export var post_attack_lockout: float = 0.35
@export var idle_sway_speed_fraction: float = 0.25
@export var approach_speed_fraction: float = 0.85
@export var passive_force_attack_time: float = 2.25

var _last_attack_type: int = ELITE_ATTACK_TRIPLE_THRUST
var _last_attack_ended_at: float = -99.0
var _passive_timer: float = 0.0

# =============================================================================
# SHIELD DEFENSE
# =============================================================================

@export_group("Shield Defense")
@export var shield_front_half_angle: float = 55.0
@export var shield_posture_reduction: float = 0.15
@export var followthrough_protection_time: float = 0.12
@export var frontal_pressure_retaliation_threshold: int = 3
@export var frontal_pressure_reset_delay: float = 2.0
@export var shield_block_posture_base: float = 2.5

var _shield_up: bool = true
var _shield_attack_startup: bool = false
var _shield_startup_until: float = 0.0
var _last_frontal_block_time: float = 0.0
var _frontal_pressure_count: int = 0
var _frontal_pressure_reset_time: float = 0.0

# =============================================================================
# TRIPLE THRUST
# =============================================================================

@export_group("Triple Thrust")
@export var thrust_string_damage: int = 7
@export var thrust_string_range: float = 72.0
@export var thrust_string_telegraph: float = 0.42
@export var thrust_hit_active: float = 0.12
@export var thrust_hit_gap: float = 0.28
@export var thrust_recovery_time: float = 0.45
@export var thrust_lunge_per_hit: float = 6.0
@export var thrust_lunge_hit_speed: float = 80.0
@export var thrust_hitbox_width: float = 22.0
@export var thrust_posture_on_parry: float = 12.0

# =============================================================================
# SPEAR THROW
# =============================================================================

@export_group("Spear Throw")
@export var spear_throw_damage: int = 5
@export var spear_speed: float = 80.0
@export var spear_max_range: float = 140.0
@export var spear_throw_interval: float = 0.45
@export var spear_throw_telegraph: float = 0.28
@export var spear_throw_recovery: float = 0.40
@export var spear_hitbox_radius: float = 8.0
@export var spear_count: int = 3
@export var spear_block_posture_damage: float = 8.0

@export_group("Spear Collision")
@export var spear_collision_layer: int = 0
@export var spear_collision_mask: int = 2

var _spear_uid_counter: int = 0
var _active_spears: Array[Area2D] = []

# =============================================================================
# HOPLITE REPOSITIONING
# =============================================================================

@export_group("Repositioning")
@export var hop_cooldown_min: float = 0.7
@export var hop_cooldown_max: float = 1.5
@export var hop_speed: float = 260.0
@export var hop_duration: float = 0.28
@export var hop_landing_recovery: float = 0.22
@export var hop_after_block_chance: float = 0.5
@export var retreat_hop_chance: float = 0.3
@export var lateral_hop_chance: float = 0.4

var _hop_cooldown_until: float = 0.0
var _hop_active_until: float = 0.0
var _hop_velocity: Vector2 = Vector2.ZERO
var _hop_landing_until: float = 0.0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================

@export_group("Posture Break")
@export var posture_break_duration: float = 3.0
@export var parry_knockback_force: float = 95.0

var _dbroken_active: bool = false
var _dbreak_until: float = 0.0
var _current_attack_type: int = -1

# =============================================================================
# READY / PHYSICS
# =============================================================================

func _ready() -> void:
	super._ready()
	
	if hp == 200:
		hp = elite_default_hp
		_max_hp = elite_default_hp
	
	can_block = true
	block_by_default = true
	movement_speed = 60.0
	
	add_to_group("shield_enemy")
	
	if auto_aggro_on_spawn:
		_saw_player_once = true
	
	next_swipe_time = Time.get_ticks_msec() * 0.001 + randf_range(0.45, 1.0)


func _physics_process(delta: float) -> void:
	if _humanoid_shared_tick(delta):
		_update_basic_movement_anim()
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	_update_posture_break(now)
	_update_sprite_facing()
	_update_blocking(delta, now)
	_update_frontal_pressure_timeout(now)
	
	if _dbroken_active:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if now < stunned_until:
		velocity = knockback
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if _is_hopping():
		velocity = _get_eased_hop_velocity(now) + knockback
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if _is_hop_landing():
		velocity = knockback
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if now < _lunge_until:
		velocity = _lunge_dir * _lunge_speed + knockback
		move_and_slide()
		_update_swipe_hitbox_position()
		_update_basic_movement_anim()
		return
	
	if telegraphing or is_attacking or swinging or _attack_recovery:
		velocity = knockback
		move_and_slide()
		_update_swipe_hitbox_position()
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
	
	_run_elite_defender_ai(delta, now)
	move_and_slide()
	_update_basic_movement_anim()


func engage() -> void:
	_saw_player_once = true
	auto_aggro_on_spawn = true


# =============================================================================
# AI
# =============================================================================

func _run_elite_defender_ai(delta: float, now: float) -> void:
	if not is_instance_valid(player):
		velocity = Vector2.ZERO
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.ZERO
	
	_update_player_pressure_timer(delta, dist)
	
	if now < _recover_lock_until:
		velocity = knockback
		return
	
	if _pick_and_execute_hop(dir, dist, now):
		velocity = _get_eased_hop_velocity(now) + knockback
		return
	
	var force_attack := _passive_timer >= passive_force_attack_time
	
	if now >= next_swipe_time and dist <= attack_range:
		if force_attack or dist <= thrust_string_range + 24.0 or randf() < 0.35:
			if _try_start_attack():
				velocity = Vector2.ZERO
				return
	
	if dist > preferred_range:
		if _approach_gate_ok():
			velocity = dir * movement_speed * approach_speed_fraction + knockback
		else:
			velocity = knockback
		return
	
	_release_role("advance_move")
	
	if dist < close_range:
		velocity = -dir * movement_speed * 0.35 + knockback
		return
	
	var sway := Vector2(-dir.y, dir.x)
	if randf() < 0.5:
		sway = -sway
	
	velocity = sway * movement_speed * idle_sway_speed_fraction + knockback


func _update_player_pressure_timer(delta: float, dist: float) -> void:
	if dist <= attack_range:
		_passive_timer += delta
	else:
		_passive_timer = 0.0


func _update_frontal_pressure_timeout(now: float) -> void:
	if now > _frontal_pressure_reset_time:
		_frontal_pressure_count = 0


# =============================================================================
# BLOCKING / SHIELD LOGIC
# =============================================================================

func _update_blocking(_delta: float, now: float) -> void:
	if _dbroken_active or has_died:
		_shield_up = false
		_set_blocking(false)
		return
	
	if telegraphing or (is_attacking and not _attack_recovery):
		_shield_up = false
		_set_blocking(false)
		return
	
	if ProstheticEffects.is_confused(self):
		_shield_up = false
		_set_blocking(false)
		return
	
	if now < _block_stagger_until:
		_shield_up = false
		_set_blocking(false)
		return
	
	_shield_up = true
	_set_blocking(true)


func _shield_is_active() -> bool:
	if _dbroken_active or has_died:
		return false
	
	if telegraphing or (is_attacking and not _attack_recovery):
		return false
	
	if ProstheticEffects.is_confused(self):
		return false
	
	return _shield_up


func _is_attack_from_shield_front(attacker: Node) -> bool:
	if not is_instance_valid(player):
		return false
	
	var facing := (player.global_position - global_position).normalized()
	if facing.length_squared() < 0.001:
		return true
	
	var to_attacker := facing
	
	if attacker is Node2D:
		to_attacker = (attacker.global_position - global_position).normalized()
	elif attacker and attacker.get_parent() is Node2D:
		to_attacker = (attacker.get_parent().global_position - global_position).normalized()
	
	var angle_to_attacker := facing.angle_to(to_attacker)
	var half_cone := deg_to_rad(shield_front_half_angle)
	
	return abs(angle_to_attacker) <= half_cone


func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if has_died:
		return
	
	var source := _resolve_hurt_source(attacker)
	
	if source and is_instance_valid(source) and source.is_in_group("enemy"):
		return
	
	if damage_type == "knockback":
		if attacker is Node2D:
			apply_knockback(attacker.global_position.direction_to(global_position) * damage)
		return
	
	var response := _get_incoming_attack_response(damage, damage_type, attacker)
	var blockable := bool(response.get("blockable", true))
	
	if _shield_is_active() and blockable and _is_attack_from_shield_front(attacker):
		_handle_frontal_shield_block(damage, damage_type, attacker, response)
		return
	
	if _shield_attack_startup and Time.get_ticks_msec() * 0.001 < _shield_startup_until:
		_flash_sprite(Color(0.85, 0.9, 1.0), 0.04)
	
	super._on_hurt_box_hurt(damage, damage_type, attacker)


func _handle_frontal_shield_block(damage: int, damage_type: String, attacker: Node, response: Dictionary) -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	var posture_meta := float(response.get("posture_on_block", shield_block_posture_base))
	var reduced_posture = max(0.5, posture_meta * shield_posture_reduction)
	response["posture_on_block"] = reduced_posture
	
	_block_stagger_until = now + BLOCK_STAGGER_TIME
	_on_block_impact(attacker, false, response)
	
	_frontal_pressure_count += 1
	_last_frontal_block_time = now
	_frontal_pressure_reset_time = now + frontal_pressure_reset_delay
	
	_hop_after_shield_block(now)
	
	notify_combat_got_hit({
		"damage": damage,
		"blocked": true,
		"damage_type": damage_type
	})
	
	if _frontal_pressure_count >= frontal_pressure_retaliation_threshold:
		_frontal_pressure_count = 0
		_queue_spear_retaliation()


# =============================================================================
# ATTACK SELECTION
# =============================================================================

func _try_start_attack() -> bool:
	if telegraphing or is_attacking or swinging or _attack_recovery:
		return false
	
	if _dbroken_active or has_died:
		return false
	
	if _is_hopping() or _is_hop_landing():
		return false
	
	if not _request_attack_token():
		return false
	
	var selected := _select_attack_type()
	_start_custom_attack(selected)
	return true


func _select_attack_type() -> int:
	if not is_instance_valid(player):
		return ELITE_ATTACK_TRIPLE_THRUST
	
	var dist := global_position.distance_to(player.global_position)
	var is_frontal := _is_attack_from_shield_front(player)
	
	if not is_frontal:
		return ELITE_ATTACK_TRIPLE_THRUST
	
	if _frontal_pressure_count >= 2:
		_frontal_pressure_count = 0
		return ELITE_ATTACK_SPEAR_THROW
	
	if dist <= thrust_string_range + 20.0:
		if randf() < 0.60:
			return ELITE_ATTACK_TRIPLE_THRUST
		return ELITE_ATTACK_SPEAR_THROW
	
	if dist <= spear_max_range + 30.0:
		if randf() < 0.80:
			return ELITE_ATTACK_SPEAR_THROW
		return ELITE_ATTACK_TRIPLE_THRUST
	
	return ELITE_ATTACK_TRIPLE_THRUST


func _start_custom_attack(attack_id: int) -> void:
	_current_attack_type = attack_id
	
	match attack_id:
		ELITE_ATTACK_TRIPLE_THRUST:
			_start_triple_thrust()
		
		ELITE_ATTACK_SPEAR_THROW:
			_start_spear_throw()
		
		_:
			_start_triple_thrust()


func _queue_spear_retaliation() -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if now < next_swipe_time:
		return
	
	if telegraphing or is_attacking or swinging or _attack_recovery:
		return
	
	if _dbroken_active or has_died:
		return
	
	if not _request_attack_token():
		return
	
	_current_attack_type = ELITE_ATTACK_SPEAR_THROW
	_start_spear_throw()


# =============================================================================
# TRIPLE THRUST
# =============================================================================

func _start_triple_thrust() -> void:
	if telegraphing or is_attacking or _dbroken_active:
		_release_attack_token()
		return
	
	telegraphing = true
	_parry_gen += 1
	var my_gen := _parry_gen
	
	_release_role("advance_move")
	
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
	
	var total_duration := thrust_string_telegraph + ((thrust_hit_active + thrust_hit_gap) * 3.0) + thrust_recovery_time
	_show_parry_indicator(total_duration, false)
	_play_thrust_windup(thrust_string_telegraph)
	
	_shield_attack_startup = true
	_shield_startup_until = Time.get_ticks_msec() * 0.001 + followthrough_protection_time
	
	await get_tree().create_timer(thrust_string_telegraph).timeout
	
	if my_gen != _parry_gen:
		_abort_attack_sequence()
		return
	
	telegraphing = false
	_shield_attack_startup = false
	_set_anim_speed_safe(1.0)
	
	for hit_index in range(3):
		if my_gen != _parry_gen:
			_abort_attack_sequence()
			return
		
		if not await _perform_triple_thrust_hit(hit_index, my_gen):
			return
		
		if hit_index < 2:
			await get_tree().create_timer(thrust_hit_gap).timeout
			
			if my_gen != _parry_gen:
				_abort_attack_sequence()
				return
	
	_attack_recovery = true
	
	await get_tree().create_timer(thrust_recovery_time).timeout
	
	if my_gen != _parry_gen:
		_abort_attack_sequence()
		return
	
	_finish_attack()


func _perform_triple_thrust_hit(_hit_index: int, gen: int) -> bool:
	if gen != _parry_gen:
		_abort_attack_sequence()
		return false
	
	await _wait_for_hitstop()
	
	if gen != _parry_gen:
		_abort_attack_sequence()
		return false
	
	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_attack_gen := _attack_gen
	
	_spawn_shield_thrust_hitbox(thrust_string_damage, thrust_string_range)
	
	var dir := _get_locked_windup_dir()
	_lunge_dir = dir
	_lunge_speed = thrust_lunge_hit_speed
	_lunge_until = Time.get_ticks_msec() * 0.001 + (thrust_lunge_per_hit / max(1.0, thrust_lunge_hit_speed))
	
	_play_attack_anim_and_get_duration(["thrust", "attack_thrust", "attack", "attack_slash"], thrust_hit_active + 0.1)
	
	await get_tree().create_timer(thrust_hit_active).timeout
	
	if gen != _parry_gen or my_attack_gen != _attack_gen:
		_abort_attack_sequence()
		return false
	
	_cleanup_swipe()
	swinging = false
	
	return true


func _play_thrust_windup(wind: float) -> void:
	if anim == null:
		return
	
	if anim.has_animation("thrust_windup"):
		var base_len := anim.get_animation("thrust_windup").length
		anim.speed_scale = base_len / max(0.001, wind)
		anim.play("thrust_windup")
	elif anim.has_animation("attack_windup"):
		var base_len := anim.get_animation("attack_windup").length
		anim.speed_scale = base_len / max(0.001, wind)
		anim.play("attack_windup")


# =============================================================================
# SPEAR THROW
# =============================================================================

func _start_spear_throw() -> void:
	if telegraphing or is_attacking or _dbroken_active:
		_release_attack_token()
		return
	
	telegraphing = true
	_parry_gen += 1
	var my_gen := _parry_gen
	
	_release_role("advance_move")
	
	var total_duration := spear_throw_telegraph + (spear_throw_interval * spear_count) + spear_throw_recovery
	_show_parry_indicator(total_duration, false)
	_play_throw_windup(spear_throw_telegraph)
	
	_shield_attack_startup = true
	_shield_startup_until = Time.get_ticks_msec() * 0.001 + followthrough_protection_time
	
	await get_tree().create_timer(spear_throw_telegraph).timeout
	
	if my_gen != _parry_gen:
		_abort_attack_sequence()
		return
	
	telegraphing = false
	_shield_attack_startup = false
	_set_anim_speed_safe(1.0)
	
	is_attacking = true
	_attack_gen += 1
	var my_attack_gen := _attack_gen
	
	for i in range(spear_count):
		if my_gen != _parry_gen or my_attack_gen != _attack_gen:
			_abort_attack_sequence()
			return
		
		var throw_dir := _get_live_player_dir()
		
		if sprite and abs(throw_dir.x) > 0.1:
			sprite.flip_h = throw_dir.x > 0.0
		
		_spawn_spear_projectile(throw_dir)
		_play_attack_anim_and_get_duration(["throw", "attack_throw", "attack", "attack_slash"], spear_throw_interval)
		
		if i < spear_count - 1:
			await get_tree().create_timer(spear_throw_interval).timeout
	
	_attack_recovery = true
	swinging = false
	
	await get_tree().create_timer(spear_throw_recovery).timeout
	
	if my_gen != _parry_gen or my_attack_gen != _attack_gen:
		_abort_attack_sequence()
		return
	
	_finish_attack()


func _play_throw_windup(wind: float) -> void:
	if anim == null:
		return
	
	if anim.has_animation("throw_windup"):
		var base_len := anim.get_animation("throw_windup").length
		anim.speed_scale = base_len / max(0.001, wind)
		anim.play("throw_windup")
	elif anim.has_animation("attack_windup"):
		var base_len := anim.get_animation("attack_windup").length
		anim.speed_scale = base_len / max(0.001, wind)
		anim.play("attack_windup")


# =============================================================================
# HITBOXES / PROJECTILES
# =============================================================================

func _spawn_shield_thrust_hitbox(dmg: int, range_val: float) -> void:
	_cleanup_swipe()
	
	var area := Area2D.new()
	area.name = "EliteDefenderThrust"
	area.add_to_group("attack")
	area.add_to_group("enemy_attack")
	
	area.set_meta("attacker", self)
	area.set_meta("damage", dmg)
	area.set_meta("damage_type", "melee")
	area.set_meta("parryable", true)
	area.set_meta("blockable", true)
	area.set_meta("swing_token", Time.get_ticks_msec() + randi_range(0, 9999))
	area.set_meta("knockback_force", 70.0)
	
	var dir := _get_locked_windup_dir()
	
	var shape := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = thrust_hitbox_width * 0.5
	capsule.height = max(8.0, range_val)
	shape.shape = capsule
	shape.rotation = dir.angle() + PI / 2.0
	area.add_child(shape)
	
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitoring = true
	area.monitorable = true
	
	add_child(area)
	_current_swipe_area = area
	
	var offset := range_val * 0.55
	area.position = dir * offset
	area.set_meta("swing_dir", dir)
	area.set_meta("swing_offset", offset)
	
	area.area_entered.connect(_on_elite_attack_area_entered.bind(area))


func _on_elite_attack_area_entered(other: Area2D, attack_area: Area2D) -> void:
	if not is_instance_valid(attack_area):
		return
	
	if attack_area.has_meta("consumed") and bool(attack_area.get_meta("consumed")):
		return
	
	if not other.is_in_group("player_hurtbox"):
		return
	
	attack_area.set_meta("consumed", true)
	
	if other.has_signal("hurt"):
		other.emit_signal(
			"hurt",
			int(attack_area.get_meta("damage", enemy_damage)),
			str(attack_area.get_meta("damage_type", "melee")),
			attack_area
		)


func _spawn_spear_projectile(direction: Vector2) -> void:
	_spear_uid_counter += 1
	
	var spear := Area2D.new()
	spear.name = "EliteDefenderSpear_%d" % _spear_uid_counter
	spear.add_to_group("attack")
	spear.add_to_group("enemy_projectile")
	spear.add_to_group("enemy_attack")
	
	spear.set_meta("attacker", self)
	spear.set_meta("damage", spear_throw_damage)
	spear.set_meta("damage_type", "melee")
	spear.set_meta("parryable", true)
	spear.set_meta("blockable", true)
	spear.set_meta("swing_token", Time.get_ticks_msec() * 100 + _spear_uid_counter)
	spear.set_meta("consumed", false)
	spear.set_meta("block_posture_damage", spear_block_posture_damage)
	spear.set_meta("direction", direction.normalized())
	spear.set_meta("speed", spear_speed)
	spear.set_meta("spawn_pos", global_position)
	spear.set_meta("max_range", spear_max_range)
	
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = spear_hitbox_radius
	shape.shape = circle
	spear.add_child(shape)
	
	spear.monitoring = false
	spear.monitorable = true
	spear.collision_layer = spear_collision_layer
	spear.collision_mask = spear_collision_mask
	
	spear.global_position = global_position + direction.normalized() * 16.0
	
	var visual := ColorRect.new()
	visual.size = Vector2(12, 4)
	visual.position = Vector2(-6, -2)
	visual.color = Color(0.6, 0.55, 0.4, 0.9)
	visual.rotation = direction.angle()
	spear.add_child(visual)
	
	var parent := get_tree().current_scene
	if parent == null:
		parent = get_parent()
	
	parent.add_child(spear)
	_active_spears.append(spear)
	_drive_spear_projectile(spear)


func _drive_spear_projectile(spear: Area2D) -> void:
	var dir: Vector2 = spear.get_meta("direction", Vector2.RIGHT)
	var spd := float(spear.get_meta("speed", spear_speed))
	var spawn_pos: Vector2 = spear.get_meta("spawn_pos", spear.global_position)
	var max_dist := float(spear.get_meta("max_range", spear_max_range))
	var dmg := int(spear.get_meta("damage", spear_throw_damage))
	
	spear.monitoring = true
	spear.monitorable = true
	
	await get_tree().physics_frame
	
	if not is_instance_valid(spear):
		return
	
	while is_instance_valid(spear):
		spear.global_position += dir.normalized() * spd * get_physics_process_delta_time()
		
		var traveled := spear.global_position.distance_to(spawn_pos)
		if traveled >= max_dist:
			_cleanup_spear(spear)
			return
		
		if bool(spear.get_meta("consumed", false)):
			await get_tree().physics_frame
			continue
		
		for area in spear.get_overlapping_areas():
			if not is_instance_valid(area):
				continue
			
			if not area.is_in_group("player_hurtbox"):
				continue
			
			spear.set_meta("consumed", true)
			
			if area.has_signal("hurt"):
				area.emit_signal("hurt", dmg, "melee", spear)
			
			await get_tree().physics_frame
			await get_tree().physics_frame
			
			_cleanup_spear(spear)
			return
		
		await get_tree().physics_frame


func _cleanup_spear(spear: Area2D) -> void:
	if _active_spears.has(spear):
		_active_spears.erase(spear)
	
	if is_instance_valid(spear):
		spear.queue_free()


func _cleanup_spears() -> void:
	for spear in _active_spears:
		if is_instance_valid(spear):
			spear.queue_free()
	
	_active_spears.clear()


# =============================================================================
# PARRY RESPONSE
# =============================================================================

func on_parried(player_pos: Vector2) -> void:
	if _current_attack_type == ELITE_ATTACK_TRIPLE_THRUST:
		_hide_parry_indicator()
		_cleanup_swipe()
		
		add_posture_damage(thrust_posture_on_parry)
		notify_combat_got_hit({"parried": true})
		
		var dir_vec := global_position - player_pos
		if dir_vec.length_squared() < 0.0001:
			dir_vec = Vector2.RIGHT
		
		knockback += dir_vec.normalized() * (parry_knockback_force * 0.35)
		hitstop_local(0.14)
		_flash_sprite(Color(1.0, 1.0, 1.5), 0.08)
		
		_spawn_parry_flash()
		
		# Do not increment _parry_gen here.
		# Triple thrust continues so each jab can be individually parried.
		return
	
	# Spear throw or any other committed action gets interrupted normally.
	_parry_gen += 1
	_attack_gen += 1
	
	add_posture_damage(thrust_posture_on_parry)
	notify_combat_got_hit({"parried": true})
	
	var dir := global_position - player_pos
	if dir.length_squared() < 0.0001:
		dir = Vector2.RIGHT
	
	knockback += dir.normalized() * parry_knockback_force
	hitstop_local(0.14)
	_flash_sprite(Color(1.0, 1.0, 1.5), 0.08)
	_spawn_parry_flash()
	_abort_attack_sequence()


func _spawn_parry_flash() -> void:
	var flash := ColorRect.new()
	flash.color = Color(1, 1, 1, 0.6)
	flash.size = Vector2(40, 40)
	flash.position = Vector2(-20, -20)
	flash.z_index = 100
	add_child(flash)
	
	var t := create_tween()
	t.tween_property(flash, "modulate:a", 0.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_callback(func():
		if is_instance_valid(flash):
			flash.queue_free()
	)


# =============================================================================
# HOP SYSTEM
# =============================================================================

func _is_hopping() -> bool:
	return Time.get_ticks_msec() * 0.001 < _hop_active_until


func _is_hop_landing() -> bool:
	var now := Time.get_ticks_msec() * 0.001
	return now >= _hop_active_until and now < _hop_landing_until


func _can_hop(now: float) -> bool:
	if now < _hop_cooldown_until:
		return false
	
	if now < _hop_landing_until:
		return false
	
	if telegraphing or is_attacking or swinging or _attack_recovery:
		return false
	
	if _dbroken_active:
		return false
	
	return true


func _do_hop(direction: Vector2, now: float) -> void:
	if direction.length_squared() < 0.001:
		return
	
	_hop_velocity = direction.normalized() * hop_speed
	_hop_active_until = now + hop_duration
	_hop_landing_until = now + hop_duration + hop_landing_recovery
	_hop_cooldown_until = now + hop_duration + hop_landing_recovery + randf_range(hop_cooldown_min, hop_cooldown_max)
	set_meta("_hop_start_time", now)


func _get_eased_hop_velocity(now: float) -> Vector2:
	var start := float(get_meta("_hop_start_time", now))
	var elapsed := now - start
	var t := clampf(elapsed / max(0.001, hop_duration), 0.0, 1.0)
	var ease_mult := 1.0 - (t * t * 0.8)
	return _hop_velocity * ease_mult


func _pick_and_execute_hop(dir_to_player: Vector2, dist: float, now: float) -> bool:
	if not _can_hop(now):
		return false
	
	if not is_instance_valid(player):
		return false
	
	var facing := _get_shield_facing_dir()
	var to_player := dir_to_player.normalized()
	var dot := facing.dot(to_player)
	var frontal_threshold := cos(deg_to_rad(shield_front_half_angle))
	
	# Player drifted off shield front: lateral realign hop.
	if dot < frontal_threshold and dist < mid_range and dist > 20.0:
		var cross := facing.x * to_player.y - facing.y * to_player.x
		var step_dir := Vector2.ZERO
		
		if cross > 0.0:
			step_dir = Vector2(-facing.y, facing.x)
		else:
			step_dir = Vector2(facing.y, -facing.x)
		
		if dist > close_range:
			step_dir = (step_dir + to_player * 0.2).normalized()
		
		_do_hop(step_dir, now)
		return true
	
	# Too close: retreat hop.
	if dist < close_range * 0.7 and randf() < retreat_hop_chance:
		var retreat := -to_player
		var perp := Vector2(-to_player.y, to_player.x)
		
		if randf() < 0.5:
			perp = -perp
		
		retreat = (retreat + perp * randf_range(0.2, 0.5)).normalized()
		_do_hop(retreat, now)
		return true
	
	# Side hop while holding shield line.
	if dist < mid_range and dist > 30.0 and dot >= frontal_threshold:
		if randf() < lateral_hop_chance:
			var perp2 := Vector2(-to_player.y, to_player.x)
			
			if randf() < 0.5:
				perp2 = -perp2
			
			var bias := to_player * randf_range(-0.15, 0.2)
			_do_hop((perp2 + bias).normalized(), now)
			return true
	
	return false


func _hop_after_shield_block(now: float) -> void:
	if randf() >= hop_after_block_chance:
		return
	
	if not _can_hop(now):
		return
	
	if not is_instance_valid(player):
		return
	
	var to_player := (player.global_position - global_position).normalized()
	var perp := Vector2(-to_player.y, to_player.x)
	
	if randf() < 0.5:
		perp = -perp
	
	var hop_dir := (perp + (-to_player) * 0.15).normalized()
	_do_hop(hop_dir, now)


func _get_shield_facing_dir() -> Vector2:
	if not is_instance_valid(sprite):
		return Vector2.RIGHT
	
	return Vector2.RIGHT if sprite.flip_h else Vector2.LEFT


# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================

func _on_base_posture_broken(duration: float) -> void:
	_enter_posture_break(max(duration, posture_break_duration))


func _on_base_posture_meter_filled() -> void:
	_enter_posture_break(posture_break_duration)


func _enter_posture_break(duration: float) -> void:
	if has_died:
		return
	
	_dbroken_active = true
	_dbreak_until = Time.get_ticks_msec() * 0.001 + duration
	stunned_until = _dbreak_until
	
	_full_reset_humanoid_attack_runtime()
	_cleanup_spears()
	_set_blocking(false)
	_shield_up = false
	
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
	return _dbroken_active


func receive_deathblow(_attacker: Node) -> void:
	death()


# =============================================================================
# ATTACK CLEANUP / UTILS
# =============================================================================

func _finish_attack() -> void:
	_cleanup_swipe()
	_hide_parry_indicator()
	
	telegraphing = false
	swinging = false
	is_attacking = false
	_attack_recovery = false
	_shield_attack_startup = false
	
	_lunge_until = 0.0
	_lunge_speed = 0.0
	_lunge_dir = Vector2.ZERO
	
	_set_anim_speed_safe(1.0)
	_release_attack_token()
	
	var now := Time.get_ticks_msec() * 0.001
	_last_attack_ended_at = now
	next_swipe_time = now + randf_range(attack_cooldown_min, attack_cooldown_max)
	_recover_lock_until = now + post_attack_lockout
	_passive_timer = 0.0


func _abort_attack_sequence() -> void:
	_soft_reset_humanoid_attack_runtime()
	_current_attack_type = -1
	_shield_attack_startup = false
	_release_attack_token()
	
	var now := Time.get_ticks_msec() * 0.001
	next_swipe_time = now + 0.45
	_recover_lock_until = now + 0.25


func _cancel_attack() -> void:
	_abort_attack_sequence()


func _get_locked_windup_dir() -> Vector2:
	var dir := Vector2.RIGHT
	
	if _windup_player_pos0 != Vector2.ZERO:
		var dv := _windup_player_pos0 - global_position
		if dv.length() > 0.001:
			dir = dv.normalized()
	elif is_instance_valid(player):
		dir = global_position.direction_to(player.global_position)
	
	return dir


func _get_live_player_dir() -> Vector2:
	if is_instance_valid(player):
		var dv := player.global_position - global_position
		if dv.length() > 0.001:
			return dv.normalized()
	
	return Vector2.RIGHT if sprite and sprite.flip_h else Vector2.LEFT


# =============================================================================
# DEATH
# =============================================================================

func death() -> void:
	if is_in_group("shield_enemy"):
		remove_from_group("shield_enemy")
	
	_cleanup_spears()
	super.death()
