extends HumanoidEnemyBase
class_name LingeringWraith

## =============================================================================
## LINGERING WRAITH - Area 2 Humanoid Soldier Variant
## =============================================================================
## Role:
## - Area 2 upgraded corrupted soldier / half-spirit swordsman
## - Similar baseline role to Corrupted Swordsman, but more spectral and dangerous
## - Adds a perilous charge thrust with longer yellow telegraph
## - Extends HumanoidEnemyBase directly instead of inheriting CorruptedSwordsman
## =============================================================================

enum WraithState {
	PATROL,
	ENGAGE,
	WINDUP,
	ATTACK,
	RECOVER,
	STAGGER,
	DEAD
}

enum WraithAttack {
	BASIC_SWING,
	QUICK_THRUST,
	CROSS_SWING,
	RUNNING_SWING,
	PERILOUS_CHARGE
}


# =============================================================================
# WRAITH TUNING
# =============================================================================

@export_group("Wraith Stats")
@export var wraith_hp: int = 42
@export var wraith_experience: int = 2
@export var wraith_move_speed: float = 72.0

@export_group("Movement")
@export var approach_speed: float = 105.0
@export var orbit_speed: float = 42.0
@export var hold_distance: float = 48.0
@export var close_combat_range: float = 58.0
@export var attack_start_min_range: float = 18.0
@export var attack_start_max_range: float = 82.0
@export var engage_deaggro_radius: float = 320.0

@export_group("Basic Swing")
@export var basic_damage: int = 5
@export var basic_range: float = 48.0
@export var basic_radius: float = 22.0
@export var basic_windup: float = 0.32
@export var basic_active_time: float = 0.15

@export_group("Quick Thrust")
@export var thrust_damage: int = 6
@export var thrust_range: float = 62.0
@export var thrust_width: float = 12.0
@export var thrust_windup: float = 0.28
@export var thrust_active_time: float = 0.13

@export_group("Cross Swing")
@export var cross_damage: int = 5
@export var cross_range: float = 54.0
@export var cross_radius: float = 23.0
@export var cross_windup: float = 0.36
@export var cross_active_time: float = 0.14
@export var cross_second_delay: float = 0.22

@export_group("Running Swing")
@export var running_damage: int = 7
@export var running_range: float = 62.0
@export var running_radius: float = 24.0
@export var running_min_distance: float = 70.0
@export var running_windup: float = 0.36
@export var running_active_time: float = 0.16
@export var running_lunge_speed: float = 245.0
@export var running_lunge_time: float = 0.17

@export_group("Perilous Charge")
@export var charge_damage: int = 10
@export var charge_range: float = 78.0
@export var charge_width: float = 16.0
@export var charge_telegraph_time: float = 0.80
@export var charge_rush_speed: float = 320.0
@export var charge_rush_time: float = 0.50
@export var charge_chance: float = 0.45
@export var charge_recovery_time: float = 0.60
@export var charge_cooldown: float = 3.5
@export var charge_knockback_force: float = 300.0
@export var charge_hitbox_delay: float = 0.10
@export var charge_min_range: float = 70.0
@export var charge_max_range: float = 180.0

@export_group("Backstep Before Charge")
@export var backstep_if_closer_than: float = 90.0
@export var backstep_speed: float = 250.0
@export var backstep_time: float = 0.25

@export_group("Combat Rhythm")
@export var attack_cd_min: float = 0.75
@export var attack_cd_max: float = 1.25
@export var recover_time: float = 0.36
@export var parry_recoil_time: float = 0.55
@export var parry_knockback_force: float = 95.0
@export var hurt_stun_time: float = 0.12


# =============================================================================
# RUNTIME
# =============================================================================

var state: int = WraithState.PATROL
var _state_timer: float = 0.0

var _aggro: bool = false
var _next_attack_ready: float = 0.0
var _stunned_until: float = 0.0

var _current_attack: int = WraithAttack.BASIC_SWING
var _last_attack: int = WraithAttack.BASIC_SWING

var _attack_dir: Vector2 = Vector2.RIGHT
var _attack_area: Area2D = null

var _combo_hits_remaining: int = 0
var _last_charge_time: float = -99.0
var _charge_backstep_active: bool = false

var _last_pos: Vector2 = Vector2.ZERO
var _last_move_speed: float = 0.0
var _current_anim: String = ""

signal remove_from_array(object)


# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	_apply_wraith_defaults()
	super._ready()
	
	can_block = true
	block_by_default = true
	block_chance_on_hit = 1.0
	
	# Shared humanoid counter tuning.
	# Wraith counters less often than Corrupted Swordsman, but is more likely
	# to choose a thrust poke when it does counter.
	humanoid_can_counter_after_block = true
	humanoid_counter_chance = 0.35
	humanoid_counter_delay = 0.22
	humanoid_counter_cooldown = 1.15
	humanoid_counter_min_attack_gap = 0.20
	humanoid_counter_thrust_chance = 0.50
	humanoid_counter_max_range_bonus = 22.0
	
	# Shared humanoid lunge / commitment tuning.
	humanoid_lock_facing_during_attack = true
	humanoid_lunge_close_ratio = 0.50
	humanoid_lunge_in_range_ratio = 0.88
	humanoid_lunge_barely_outside_bonus = 20.0
	
	_home_pos = global_position
	_patrol_target = global_position
	
	print("[LingeringWraith] v1.1 - Humanoid counter/lunge kit active")

func _apply_wraith_defaults() -> void:
	hp = wraith_hp
	experience = wraith_experience
	movement_speed = wraith_move_speed
	deaggro_radius = engage_deaggro_radius


# =============================================================================
# MAIN LOOP
# =============================================================================

func _physics_process(delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if state == WraithState.DEAD:
		return
	
	_track_movement_speed(delta)
	
	if _humanoid_shared_tick(delta):
		_update_animation()
		return
	
	if now < _stunned_until and state != WraithState.STAGGER:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_sprite_facing()
		_update_animation()
		return
	
	_update_blocking(delta, now)
	
	if _state_timer > 0.0:
		_state_timer -= delta
	
	match state:
		WraithState.PATROL:
			_state_patrol(delta, now)
		WraithState.ENGAGE:
			_state_engage(delta, now)
		WraithState.WINDUP:
			_state_windup(delta, now)
		WraithState.ATTACK:
			_state_attack(delta, now)
		WraithState.RECOVER:
			_state_recover(delta, now)
		WraithState.STAGGER:
			_state_stagger(delta, now)
	
	if knockback.length() > 1.0:
		velocity += knockback
		tick_base_knockback(delta)
	
	move_and_slide()
	_update_sprite_facing()
	_update_animation()


func _track_movement_speed(delta: float) -> void:
	var prev := _last_pos if _last_pos != Vector2.ZERO else global_position
	var moved := global_position - prev
	_last_move_speed = moved.length() / max(0.0001, delta)
	_last_pos = global_position


# =============================================================================
# STATE MACHINE
# =============================================================================

func _goto(new_state: int, timer: float = 0.0) -> void:
	state = new_state
	_state_timer = timer


func _state_patrol(delta: float, _now: float) -> void:
	if _check_aggro():
		_goto(WraithState.ENGAGE)
		return
	
	_patrol_step(delta)


func _state_engage(_delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(WraithState.PATROL)
		return
	
	if _player_hidden_in_smoke():
		velocity = Vector2.ZERO
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.RIGHT
	
	if dist > deaggro_radius:
		_saw_player_once = false
		_goto(WraithState.PATROL)
		return
	
	# Process any queued counter-attacks from blocking.
	# If a counter starts, stop normal engage logic from overwriting it.
	var was_counter_queued := _humanoid_counter_queued
	_tick_humanoid_counter_queue(now)
	
	if was_counter_queued and (telegraphing or is_attacking or swinging or state == WraithState.WINDUP or state == WraithState.ATTACK):
		return
	
	if now < _backoff_until:
		velocity = dir.rotated(PI * 0.5) * orbit_speed
		return
	
	if now >= _next_attack_ready and _can_start_wraith_attack(dist):
		_try_start_wraith_attack(dist)
		return
	
	if dist > hold_distance:
		if _approach_gate_ok():
			velocity = dir * approach_speed
		else:
			velocity = dir.rotated(PI * 0.5) * orbit_speed
	elif dist < attack_start_min_range:
		velocity = -dir * movement_speed * 0.45
	else:
		velocity = dir.rotated(PI * 0.5) * orbit_speed * 0.45

func _state_windup(_delta: float, _now: float) -> void:
	velocity = Vector2.ZERO
	
	# Allow slight tracking early in windup only.
	# Once the timer is low, the attack direction is committed.
	if is_instance_valid(player) and _state_timer > 0.12:
		var to_player := player.global_position - global_position
		if to_player.length_squared() > 0.001:
			_attack_dir = to_player.normalized()
			_windup_player_pos0 = player.global_position
	
	if _state_timer <= 0.12:
		_lock_attack_facing_toward_player_or_snapshot()
	
	if _state_timer <= 0.0:
		_begin_active_attack()

func _state_attack(_delta: float, _now: float) -> void:
	if _current_attack == WraithAttack.PERILOUS_CHARGE:
		velocity = _attack_dir * charge_rush_speed
	elif _now < _lunge_until:
		velocity = _lunge_dir * _lunge_speed
	else:
		velocity = Vector2.ZERO
	
	if _state_timer <= 0.0:
		_cleanup_attack_area()
		
		if _current_attack == WraithAttack.CROSS_SWING:
			_combo_hits_remaining -= 1
			if _combo_hits_remaining > 0:
				_enter_windup(cross_second_delay)
				return
		
		_finish_wraith_attack()


func _state_recover(_delta: float, _now: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 350.0 * _delta)
	
	if _state_timer <= 0.0:
		_goto(WraithState.ENGAGE)


func _state_stagger(_delta: float, _now: float) -> void:
	velocity = knockback
	
	if _state_timer <= 0.0:
		_goto(WraithState.ENGAGE)


# =============================================================================
# ATTACK SELECTION
# =============================================================================

func _can_start_wraith_attack(dist: float) -> bool:
	if has_died:
		return false
	
	if telegraphing or is_attacking or swinging:
		return false
	
	if ProstheticEffects.is_confused(self):
		return false
	
	return dist >= attack_start_min_range and dist <= charge_max_range


func _try_start_wraith_attack(dist: float) -> void:
	if not _request_role("melee_attack"):
		return
	
	has_attack_token = true
	
	var chosen := _select_wraith_attack(dist)
	_start_wraith_attack(chosen)

func _start_humanoid_counter_attack(counter_kind: String) -> void:
	if state == WraithState.DEAD or has_died:
		return
	
	if telegraphing or is_attacking or swinging:
		return
	
	if state == WraithState.STAGGER:
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	var cd_until: float = 0.0
	if has_meta("_humanoid_counter_cd_until"):
		cd_until = float(get_meta("_humanoid_counter_cd_until"))
	if now < cd_until:
		return
	
	# Counters are allowed to bypass the normal _next_attack_ready cooldown,
	# but still respect their own humanoid counter cooldown.
	set_meta("_humanoid_counter_cd_until", now + humanoid_counter_cooldown)
	_next_attack_ready = now + humanoid_counter_cooldown
	
	if not _request_role("melee_attack"):
		return
	
	has_attack_token = true
	
	match counter_kind:
		"thrust_poke":
			_start_wraith_attack(WraithAttack.QUICK_THRUST)
		"quick_slash":
			_start_wraith_attack(WraithAttack.BASIC_SWING)
		_:
			_start_wraith_attack(WraithAttack.BASIC_SWING)
			
func _select_wraith_attack(dist: float) -> int:
	var now := Time.get_ticks_msec() * 0.001
	var charge_ready := (now - _last_charge_time) >= charge_cooldown
	
	var weights := {
		WraithAttack.BASIC_SWING: 0.28,
		WraithAttack.QUICK_THRUST: 0.24,
		WraithAttack.CROSS_SWING: 0.22,
		WraithAttack.RUNNING_SWING: 0.12,
		WraithAttack.PERILOUS_CHARGE: 0.0
	}
	
	if dist >= running_min_distance:
		weights[WraithAttack.RUNNING_SWING] = 0.22
	
	if charge_ready and dist >= charge_min_range and dist <= charge_max_range:
		weights[WraithAttack.PERILOUS_CHARGE] = charge_chance
	
	if dist < 35.0:
		weights[WraithAttack.RUNNING_SWING] = 0.0
		weights[WraithAttack.PERILOUS_CHARGE] = 0.0
	
	if weights.has(_last_attack):
		weights[_last_attack] = float(weights[_last_attack]) * 0.35
	
	var total := 0.0
	for value in weights.values():
		total += float(value)
	
	if total <= 0.001:
		_last_attack = WraithAttack.BASIC_SWING
		return WraithAttack.BASIC_SWING
	
	var roll := randf() * total
	var cumulative := 0.0
	
	for attack_type in weights.keys():
		cumulative += float(weights[attack_type])
		if roll <= cumulative:
			_last_attack = int(attack_type)
			return int(attack_type)
	
	_last_attack = WraithAttack.BASIC_SWING
	return WraithAttack.BASIC_SWING

func _start_wraith_attack(attack_type: int) -> void:
	_current_attack = attack_type
	
	_windup_player_pos0 = Vector2.ZERO
	
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
		var to_player := _windup_player_pos0 - global_position
		if to_player.length_squared() > 0.001:
			_attack_dir = to_player.normalized()
	
	match attack_type:
		WraithAttack.BASIC_SWING:
			_enter_windup(basic_windup)
		WraithAttack.QUICK_THRUST:
			_enter_windup(thrust_windup)
		WraithAttack.CROSS_SWING:
			_combo_hits_remaining = 2
			_enter_windup(cross_windup)
		WraithAttack.RUNNING_SWING:
			_enter_windup(running_windup)
		WraithAttack.PERILOUS_CHARGE:
			_start_charge_sequence()


# =============================================================================
# ATTACK EXECUTION
# =============================================================================

func _enter_windup(windup_time: float) -> void:
	_bump_attack_gens()
	_cleanup_attack_area()
	
	telegraphing = true
	is_attacking = false
	swinging = false
	
	_release_role("advance_move")
	
	var active_time := _get_current_active_time()
	var indicator_duration := windup_time + active_time
	var is_perilous := _current_attack == WraithAttack.PERILOUS_CHARGE
	
	_show_parry_indicator(indicator_duration, is_perilous)
	
	if anim and anim.has_animation("attack_windup"):
		anim.play("attack_windup")
		var base_len := anim.get_animation("attack_windup").length
		_set_anim_speed_safe(base_len / max(0.001, windup_time))
	
	_goto(WraithState.WINDUP, windup_time)


func _start_charge_sequence() -> void:
	_bump_attack_gens()
	_cleanup_attack_area()
	
	telegraphing = true
	is_attacking = false
	swinging = false
	_last_charge_time = Time.get_ticks_msec() * 0.001
	
	_release_role("advance_move")
	
	if is_instance_valid(player):
		var dist := global_position.distance_to(player.global_position)
		if dist < backstep_if_closer_than:
			_begin_charge_backstep()
			return
	
	_enter_windup(charge_telegraph_time)


func _begin_charge_backstep() -> void:
	_charge_backstep_active = true
	
	var backstep_dir := Vector2.RIGHT
	if is_instance_valid(player):
		backstep_dir = player.global_position.direction_to(global_position)
	elif sprite:
		backstep_dir = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
	
	_lunge_dir = backstep_dir.normalized()
	_lunge_speed = backstep_speed
	_lunge_until = Time.get_ticks_msec() * 0.001 + backstep_time
	
	if anim:
		if anim.has_animation("dodge"):
			anim.play("dodge")
		elif anim.has_animation("walk"):
			anim.play("walk")
			_set_anim_speed_safe(1.4)
	
	await get_tree().create_timer(backstep_time).timeout
	
	if state == WraithState.DEAD or has_died:
		return
	
	_charge_backstep_active = false
	_lunge_speed = 0.0
	_lunge_until = 0.0
	_set_anim_speed_safe(1.0)
	
	_enter_windup(charge_telegraph_time)

func _begin_active_attack() -> void:
	telegraphing = false
	is_attacking = true
	swinging = true
	
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	var now_s := Time.get_ticks_msec() * 0.001
	
	_lock_attack_facing_toward_player_or_snapshot()
	
	match _current_attack:
		WraithAttack.BASIC_SWING:
			_apply_humanoid_lunge(
				_compute_humanoid_attack_lunge(
					basic_range,
					90.0,
					basic_active_time,
					155.0,
					min(0.12, basic_active_time)
				),
				now_s
			)
		
		WraithAttack.QUICK_THRUST:
			_apply_humanoid_lunge(
				_compute_humanoid_attack_lunge(
					thrust_range,
					110.0,
					thrust_active_time,
					230.0,
					min(0.14, thrust_active_time)
				),
				now_s
			)
		
		WraithAttack.CROSS_SWING:
			_apply_humanoid_lunge(
				_compute_humanoid_attack_lunge(
					cross_range,
					85.0,
					cross_active_time,
					150.0,
					min(0.10, cross_active_time)
				),
				now_s
			)
		
		WraithAttack.RUNNING_SWING:
			_apply_humanoid_lunge(
				_compute_humanoid_attack_lunge(
					running_range,
					running_lunge_speed * 0.45,
					min(0.10, running_active_time),
					running_lunge_speed,
					running_lunge_time
				),
				now_s
			)
			
	match _current_attack:
		WraithAttack.BASIC_SWING:
			_spawn_circle_hitbox(basic_damage, basic_radius, basic_range, "melee")
			_goto(WraithState.ATTACK, basic_active_time)
		WraithAttack.QUICK_THRUST:
			_spawn_thrust_hitbox(thrust_damage, thrust_range, thrust_width, "melee")
			_goto(WraithState.ATTACK, thrust_active_time)
		WraithAttack.CROSS_SWING:
			_spawn_circle_hitbox(cross_damage, cross_radius, cross_range, "melee")
			_goto(WraithState.ATTACK, cross_active_time)
		WraithAttack.RUNNING_SWING:
			_spawn_circle_hitbox(running_damage, running_radius, running_range, "melee")
			_goto(WraithState.ATTACK, running_active_time)
		WraithAttack.PERILOUS_CHARGE:
			_spawn_thrust_hitbox(charge_damage, charge_range, charge_width, "perilous")
			if _attack_area:
				_attack_area.set_meta("knockback_force", charge_knockback_force)
			_goto(WraithState.ATTACK, charge_rush_time)
	
	if anim:
		if _current_attack == WraithAttack.PERILOUS_CHARGE and anim.has_animation("charge_attack"):
			anim.play("charge_attack")
		elif anim.has_animation("attack_slash"):
			anim.play("attack_slash")
		elif anim.has_animation("attack"):
			anim.play("attack")


func _get_current_active_time() -> float:
	match _current_attack:
		WraithAttack.BASIC_SWING:
			return basic_active_time
		WraithAttack.QUICK_THRUST:
			return thrust_active_time
		WraithAttack.CROSS_SWING:
			return cross_active_time
		WraithAttack.RUNNING_SWING:
			return running_active_time
		WraithAttack.PERILOUS_CHARGE:
			return charge_rush_time
	
	return basic_active_time


func _finish_wraith_attack() -> void:
	_cleanup_attack_area()
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	telegraphing = false
	is_attacking = false
	swinging = false
	_combo_hits_remaining = 0
	_charge_backstep_active = false
	_clear_attack_facing_lock()
	_clear_humanoid_counter_queue()
	_lunge_until = 0.0
	_lunge_speed = 0.0
	_lunge_dir = Vector2.ZERO
	
	_release_role("melee_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	var now := Time.get_ticks_msec() * 0.001
	var cd := randf_range(attack_cd_min, attack_cd_max)
	if _current_attack == WraithAttack.PERILOUS_CHARGE:
		cd = max(cd, charge_recovery_time)
	
	_next_attack_ready = now + cd
	
	_goto(WraithState.RECOVER, recover_time)


func _cancel_wraith_attack(backoff_time: float = 0.45) -> void:
	_bump_attack_gens()
	_cleanup_attack_area()
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	telegraphing = false
	is_attacking = false
	swinging = false
	_combo_hits_remaining = 0
	_charge_backstep_active = false
	
	_lunge_until = 0.0
	_lunge_speed = 0.0
	_lunge_dir = Vector2.ZERO
	
	_clear_attack_facing_lock()
	_clear_humanoid_counter_queue()
	
	_release_role("melee_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	var now := Time.get_ticks_msec() * 0.001
	_backoff_until = max(_backoff_until, now + backoff_time)
	_next_attack_ready = max(_next_attack_ready, now + backoff_time)
	
	if state != WraithState.DEAD:
		_goto(WraithState.RECOVER, min(recover_time, 0.35))


func _bump_attack_gens() -> void:
	_attack_gen += 1
	_parry_gen += 1


# =============================================================================
# HITBOXES
# =============================================================================

func _spawn_circle_hitbox(damage: int, radius: float, range_val: float, damage_type: String) -> void:
	_cleanup_attack_area()
	
	var hit := Area2D.new()
	hit.name = "WraithSwingHit"
	hit.add_to_group("attack")
	hit.collision_layer = 0
	hit.collision_mask = 2
	hit.monitoring = true
	hit.monitorable = true
	
	var cs := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	cs.shape = circle
	hit.add_child(cs)
	
	hit.position = _attack_dir * range_val
	
	_apply_hitbox_meta(hit, damage, damage_type)
	
	hit.connect("area_entered", Callable(self, "_on_wraith_hit_area_entered"))
	add_child(hit)
	_attack_area = hit


func _spawn_thrust_hitbox(damage: int, range_val: float, width: float, damage_type: String) -> void:
	_cleanup_attack_area()
	
	var hit := Area2D.new()
	hit.name = "WraithThrustHit"
	hit.add_to_group("attack")
	hit.collision_layer = 0
	hit.collision_mask = 2
	hit.monitoring = true
	hit.monitorable = true
	
	var cs := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(range_val, width)
	cs.shape = rect
	hit.add_child(cs)
	
	hit.position = _attack_dir * (range_val * 0.5)
	hit.rotation = _attack_dir.angle()
	
	_apply_hitbox_meta(hit, damage, damage_type)
	
	hit.connect("area_entered", Callable(self, "_on_wraith_hit_area_entered"))
	add_child(hit)
	_attack_area = hit


func _apply_hitbox_meta(hit: Area2D, damage: int, damage_type: String) -> void:
	hit.set_meta("attacker", self)
	hit.set_meta("damage", damage)
	hit.set_meta("damage_type", damage_type)
	hit.set_meta("attack_type", damage_type)
	hit.set_meta("parryable", true)
	hit.set_meta("stagger_on_block", 10.0)
	hit.set_meta("swing_token", Time.get_ticks_msec())
	hit.set_meta("hit_ids", {})
	
	if damage_type == "perilous":
		hit.set_meta("unblockable", true)
		hit.set_meta("perilous", true)


func _on_wraith_hit_area_entered(other: Area2D) -> void:
	if not is_attacking or not swinging:
		return
	
	if other == null or not other.is_in_group("player_hurtbox"):
		return
	
	if _attack_area == null or not is_instance_valid(_attack_area):
		return
	
	if _hitbox_already_hit(other):
		return
	
	var dmg := int(_attack_area.get_meta("damage", basic_damage))
	var dtype := str(_attack_area.get_meta("damage_type", "melee"))
	
	other.emit_signal("hurt", dmg, dtype, _attack_area)


func _hitbox_already_hit(other: Area2D) -> bool:
	if _attack_area == null or not is_instance_valid(_attack_area):
		return true
	
	var hit_ids: Dictionary = {}
	if _attack_area.has_meta("hit_ids"):
		hit_ids = _attack_area.get_meta("hit_ids")
	
	var oid := str(other.get_instance_id())
	if hit_ids.has(oid):
		return true
	
	hit_ids[oid] = true
	_attack_area.set_meta("hit_ids", hit_ids)
	return false


func _cleanup_attack_area() -> void:
	if _attack_area and is_instance_valid(_attack_area):
		_attack_area.set_deferred("monitoring", false)
		_attack_area.set_deferred("monitorable", false)
		_attack_area.set_meta("consumed", true)
		_attack_area.queue_free()
	
	_attack_area = null


# =============================================================================
# DAMAGE / PARRY / DEATH
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	if state == WraithState.DEAD or has_died:
		return
	
	if hp_damage <= 0:
		return
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + hurt_stun_time
	
	if state == WraithState.WINDUP or state == WraithState.ATTACK:
		_cancel_wraith_attack(0.25)
	
	if anim and anim.has_animation("hurt"):
		anim.play("hurt")
		_set_anim_speed_safe(1.0)


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()


func on_parried(player_pos: Vector2) -> void:
	if state == WraithState.DEAD or has_died:
		return
	
	_cancel_wraith_attack(0.5)
	
	var kb_dir := global_position - player_pos
	if kb_dir.length_squared() < 0.001:
		kb_dir = Vector2.RIGHT
	
	knockback = Vector2.ZERO
	apply_knockback(kb_dir.normalized() * parry_knockback_force)
	hitstop_local(0.08)
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + parry_recoil_time
	_goto(WraithState.STAGGER, parry_recoil_time)


func receive_deathblow(_attacker: Node) -> void:
	force_kill_hp()
	death()


func death() -> void:
	if state == WraithState.DEAD:
		return
	
	if not mark_dead():
		return
	
	_goto(WraithState.DEAD)
	_bump_attack_gens()
	_cleanup_attack_area()
	_hide_parry_indicator()
	_release_role("melee_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)
	
	hide_posture_bar()
	_clear_attack_facing_lock()
	_clear_humanoid_counter_queue()
	_run_humanoid_death_rewards()
	
	velocity = Vector2.ZERO
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		await get_tree().create_timer(0.45).timeout
	else:
		await get_tree().create_timer(0.25).timeout
	
	queue_free()

func _exit_tree() -> void:
	_bump_attack_gens()
	_cleanup_attack_area()
	_hide_parry_indicator()
	_release_role("melee_attack")
	_release_role("advance_move")
	_release_all_attack_director_state()


# =============================================================================
# AGGRO / ANIMATION / HELPERS
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

func _update_sprite_facing() -> void:
	if _attack_facing_locked:
		super._update_sprite_facing()
		return
	
	if sprite == null:
		return
	
	if velocity.length() > 5.0:
		sprite.flip_h = velocity.x < 0.0
	elif is_instance_valid(player):
		sprite.flip_h = (player.global_position.x - global_position.x) < 0.0

func _update_animation() -> void:
	if anim == null:
		return
	
	if state == WraithState.WINDUP or state == WraithState.ATTACK:
		return
	
	var anim_name := "idle"
	
	match state:
		WraithState.PATROL, WraithState.ENGAGE:
			anim_name = "walk" if _last_move_speed > 8.0 else "idle"
		WraithState.RECOVER:
			anim_name = "idle"
		WraithState.STAGGER:
			anim_name = "hurt" if anim.has_animation("hurt") else "idle"
		WraithState.DEAD:
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
