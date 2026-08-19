extends HumanoidEnemyBase
class_name CourtGuard

## =============================================================================
## COURT GUARD — Area 3 Sword-Spirit Soldier
## =============================================================================
## Replaces old Soldier V3 inheritance chain:
##   OLD: Court Guard / Soldier V3 -> soldier_v2.gd -> old soldier base
##   NEW: Court Guard -> HumanoidEnemyBase -> EnemyBase
##
## Preserved functionality:
## - Disciplined humanoid sword enemy
## - Blocks through HumanoidEnemyBase
## - Basic swing
## - Quick thrust
## - Cross swing
## - Charge slash
## - Three-hit spirit combo: hits 1-2 blockable, hit 3 perilous
## - First death triggers corruption reform
## - Reform phase 1: invulnerable channel
## - Reform phase 2: vulnerable body can be destroyed
## - If not destroyed, revives once
## - Deathblow kills permanently
## =============================================================================

enum AttackType {
	BASIC_SWING,
	QUICK_THRUST,
	CROSS_SWING,
	CHARGE_SLASH,
	SPIRIT_COMBO
}

# =============================================================================
# COURT GUARD CORE
# =============================================================================

@export_group("Court Guard Core")
@export var court_guard_debug_name: String = "Court Guard"
@export var debug_logs: bool = false

# =============================================================================
# AI / ENGAGEMENT
# =============================================================================

@export_group("AI / Engagement")
@export var preferred_range: float = 58.0
@export var attack_range: float = 72.0
@export var approach_stop_range: float = 46.0
@export var attack_cooldown_min: float = 0.85
@export var attack_cooldown_max: float = 1.35
@export var post_attack_lockout: float = 0.35
@export var backoff_speed_fraction: float = 0.65
@export var orbit_speed_fraction: float = 0.45
@export var orbit_flip_chance: float = 0.35

var _last_attack_type: int = AttackType.BASIC_SWING
var _last_attack_ended_at: float = -99.0
var _orbit_dir: float = 1.0

# =============================================================================
# BASIC SWING
# =============================================================================

@export_group("Basic Swing")
@export var basic_damage: int = 7
@export var basic_range: float = 58.0
@export var basic_windup: float = 0.42
@export var basic_active: float = 0.18
@export var basic_recovery: float = 0.35
@export var basic_chance: float = 0.42
@export var basic_lunge_speed: float = 120.0
@export var basic_lunge_time: float = 0.08

# =============================================================================
# QUICK THRUST
# =============================================================================

@export_group("Quick Thrust")
@export var thrust_damage: int = 8
@export var thrust_range: float = 76.0
@export var thrust_windup: float = 0.48
@export var thrust_active: float = 0.16
@export var thrust_recovery: float = 0.42
@export var thrust_chance: float = 0.24
@export var thrust_lunge_speed: float = 180.0
@export var thrust_lunge_time: float = 0.12
@export var thrust_knockback_force: float = 80.0

# =============================================================================
# CROSS SWING
# =============================================================================

@export_group("Cross Swing")
@export var cross_damage: int = 9
@export var cross_range: float = 66.0
@export var cross_windup: float = 0.55
@export var cross_active: float = 0.22
@export var cross_recovery: float = 0.48
@export var cross_chance: float = 0.20
@export var cross_lunge_speed: float = 135.0
@export var cross_lunge_time: float = 0.10
@export var cross_knockback_force: float = 120.0

# =============================================================================
# CHARGE SLASH
# =============================================================================

@export_group("Charge Slash")
@export var charge_damage: int = 12
@export var charge_range: float = 88.0
@export var charge_min_distance: float = 86.0
@export var charge_windup: float = 0.68
@export var charge_active: float = 0.22
@export var charge_recovery: float = 0.58
@export var charge_chance: float = 0.30
@export var charge_cooldown: float = 5.0
@export var charge_lunge_speed: float = 260.0
@export var charge_lunge_time: float = 0.18
@export var charge_knockback_force: float = 220.0

var _last_charge_time: float = -99.0

# =============================================================================
# SPIRIT COMBO
# =============================================================================

@export_group("Spirit Combo")
@export var combo3_damage_per_hit: int = 6
@export var combo3_range: float = 60.0
@export var combo3_telegraph_time: float = 0.50
@export var combo3_hit_delay: float = 0.40
@export var combo3_active: float = 0.18
@export var combo3_final_damage: int = 10
@export var combo3_final_telegraph: float = 0.55
@export var combo3_chance: float = 0.40
@export var combo3_cooldown: float = 4.0
@export var combo3_lunge_speed: float = 180.0
@export var combo3_lunge_time: float = 0.10
@export var combo3_recovery_time: float = 0.50
@export var combo3_knockback_force: float = 250.0

var _last_combo3_time: float = -99.0
var _combo_hits_remaining: int = 0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================

@export_group("Posture Break")
@export var posture_break_duration: float = 3.0

var _dbroken_active: bool = false
var _dbreak_until: float = 0.0

# =============================================================================
# CORRUPTION REVIVE
# =============================================================================

@export_group("Corruption Revive")
@export var channel_time: float = 3.0
@export var vulnerable_time: float = 4.0
@export var reform_hp: int = 30
@export var revive_hp_ratio: float = 0.40

var _reforming: bool = false
var _reform_phase: int = 0 # 0 = none, 1 = channeling, 2 = vulnerable
var _reform_until: float = 0.0
var _reform_hp_current: int = 0
var _has_revived: bool = false
var _reform_tween: Tween = null

# =============================================================================
# GENERATED ATTACK HITBOX
# =============================================================================

@export_group("Generated Attack Hitbox")
@export var attack_hitbox_radius: float = 18.0
@export var attack_hitbox_offset: float = 24.0
@export var attack_collision_layer: int = 0
@export var attack_collision_mask: int = 0

var _current_hit_targets: Dictionary = {}

# =============================================================================
# READY / PHYSICS
# =============================================================================
func _ready() -> void:
	super._ready()
	
	can_block = true
	block_by_default = true
	block_chance_on_hit = 1.0
	
	# Area 3 disciplined soldier tuning.
	# Court Guard should counter more often and faster than earlier humanoids.
	humanoid_can_counter_after_block = true
	humanoid_counter_chance = 0.60
	humanoid_counter_delay = 0.16
	humanoid_counter_cooldown = 0.95
	humanoid_counter_min_attack_gap = 0.15
	humanoid_counter_thrust_chance = 0.42
	humanoid_counter_max_range_bonus = 22.0
	
	humanoid_lock_facing_during_attack = true
	humanoid_lunge_close_ratio = 0.50
	humanoid_lunge_in_range_ratio = 0.88
	humanoid_lunge_barely_outside_bonus = 20.0
	
	if auto_aggro_on_spawn:
		_saw_player_once = true
	
	next_swipe_time = Time.get_ticks_msec() * 0.001 + randf_range(0.35, 0.85)


func _physics_process(delta: float) -> void:
	if _reforming:
		_tick_reform()
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _humanoid_shared_tick(delta):
		_update_basic_movement_anim()
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	_update_posture_break(now)
	_update_sprite_facing()
	_update_blocking(delta, now)
	
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
	
	_run_court_guard_ai(now)
	move_and_slide()
	_update_basic_movement_anim()


func _run_court_guard_ai(now: float) -> void:
	if not is_instance_valid(player):
		velocity = Vector2.ZERO
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.ZERO
	
	# Process queued block counters before normal AI attacks.
	var was_counter_queued := _humanoid_counter_queued
	_tick_humanoid_counter_queue(now)

	if was_counter_queued and (telegraphing or is_attacking or swinging):
		velocity = Vector2.ZERO
		return

	if now < _recover_lock_until:
		velocity = knockback
		return

	if now >= next_swipe_time and dist <= attack_range:
		if _try_start_attack():
			velocity = Vector2.ZERO
			return
	
	if dist > preferred_range:
		if _approach_gate_ok():
			velocity = dir * movement_speed + knockback
		else:
			velocity = knockback
		return
	
	_release_role("advance_move")
	
	if dist < approach_stop_range:
		velocity = -dir * movement_speed * backoff_speed_fraction + knockback
		return
	
	var side := Vector2(-dir.y, dir.x) * _orbit_dir
	velocity = side * movement_speed * orbit_speed_fraction + knockback


# =============================================================================
# EXTERNAL ENGAGE HOOK
# =============================================================================

func engage() -> void:
	_saw_player_once = true
	auto_aggro_on_spawn = true


# =============================================================================
# ATTACK SELECTION
# =============================================================================

func _try_start_attack() -> bool:
	if telegraphing or is_attacking or swinging or _attack_recovery:
		return false
	
	if _dbroken_active or _reforming:
		return false
	
	if not _request_attack_token():
		return false
	
	var selected := _select_attack_type()
	_start_custom_attack(selected)
	return true

func _start_humanoid_counter_attack(counter_kind: String) -> void:
	print("[CourtGuard] counter start requested kind=", counter_kind)
	if has_died or _reforming or _dbroken_active:
		return
	
	if telegraphing or is_attacking or swinging or _attack_recovery:
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	if now < stunned_until:
		return
	
	var cd_until: float = 0.0
	if has_meta("_humanoid_counter_cd_until"):
		cd_until = float(get_meta("_humanoid_counter_cd_until"))
	if now < cd_until:
		return
	
	if not _request_attack_token():
		return
	
	set_meta("_humanoid_counter_cd_until", now + humanoid_counter_cooldown)
	next_swipe_time = now + humanoid_counter_cooldown
	
	match counter_kind:
		"thrust_poke":
			_start_custom_attack(AttackType.QUICK_THRUST)
		"quick_slash":
			_start_custom_attack(AttackType.BASIC_SWING)
		_:
			_start_custom_attack(AttackType.BASIC_SWING)
			
func _select_attack_type() -> int:
	if not is_instance_valid(player):
		return AttackType.BASIC_SWING
	
	var now := Time.get_ticks_msec() * 0.001
	var dist := global_position.distance_to(player.global_position)
	
	var charge_ready := (now - _last_charge_time) >= charge_cooldown
	var combo_ready := (now - _last_combo3_time) >= combo3_cooldown
	
	var weights := {
		AttackType.BASIC_SWING: basic_chance,
		AttackType.QUICK_THRUST: thrust_chance,
		AttackType.CROSS_SWING: cross_chance
	}
	
	if charge_ready and dist >= charge_min_distance:
		weights[AttackType.CHARGE_SLASH] = charge_chance
	
	if combo_ready and dist <= combo3_range + 22.0:
		weights[AttackType.SPIRIT_COMBO] = combo3_chance
	
	if weights.has(_last_attack_type):
		weights[_last_attack_type] *= 0.35
	
	var total := 0.0
	for w in weights.values():
		total += float(w)
	
	if total <= 0.0:
		_last_attack_type = AttackType.BASIC_SWING
		return AttackType.BASIC_SWING
	
	var roll := randf() * total
	var cumulative := 0.0
	
	for atype in weights.keys():
		cumulative += float(weights[atype])
		if roll <= cumulative:
			_last_attack_type = int(atype)
			return int(atype)
	
	_last_attack_type = AttackType.BASIC_SWING
	return AttackType.BASIC_SWING


func _start_custom_attack(attack_id: int) -> void:
	match attack_id:
		AttackType.BASIC_SWING:
			_start_single_sword_attack(
				"basic_swing",
				basic_damage,
				basic_range,
				basic_windup,
				basic_active,
				basic_recovery,
				false,
				basic_lunge_speed,
				basic_lunge_time,
				0.0
			)
		
		AttackType.QUICK_THRUST:
			_start_single_sword_attack(
				"quick_thrust",
				thrust_damage,
				thrust_range,
				thrust_windup,
				thrust_active,
				thrust_recovery,
				false,
				thrust_lunge_speed,
				thrust_lunge_time,
				thrust_knockback_force
			)
		
		AttackType.CROSS_SWING:
			_start_single_sword_attack(
				"cross_swing",
				cross_damage,
				cross_range,
				cross_windup,
				cross_active,
				cross_recovery,
				false,
				cross_lunge_speed,
				cross_lunge_time,
				cross_knockback_force
			)
		
		AttackType.CHARGE_SLASH:
			_start_charge_slash()
		
		AttackType.SPIRIT_COMBO:
			_start_spirit_combo()
		
		_:
			_start_single_sword_attack(
				"basic_swing",
				basic_damage,
				basic_range,
				basic_windup,
				basic_active,
				basic_recovery,
				false,
				basic_lunge_speed,
				basic_lunge_time,
				0.0
			)


# =============================================================================
# SINGLE SWORD ATTACK
# =============================================================================

func _start_single_sword_attack(
	attack_id: String,
	damage: int,
	range: float,
	windup: float,
	active_time: float,
	recovery: float,
	perilous: bool,
	lunge_speed: float,
	lunge_time: float,
	knockback_force: float
) -> void:
	if telegraphing or is_attacking or _dbroken_active or _reforming:
		_release_attack_token()
		return
	
	telegraphing = true
	_parry_gen += 1
	var my_parry_gen := _parry_gen
	
	_release_role("advance_move")
	
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
	
	_show_parry_indicator(windup, perilous)
	_play_windup_animation(windup)
	
	await get_tree().create_timer(windup).timeout
	
	if my_parry_gen != _parry_gen or _dbroken_active or _reforming:
		_abort_attack_sequence()
		return
	
	telegraphing = false
	_set_anim_speed_safe(1.0)
	
	await _wait_for_hitstop()
	
	if my_parry_gen != _parry_gen or _dbroken_active or _reforming:
		_abort_attack_sequence()
		return
	
	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_attack_gen := _attack_gen
	
	active_window = active_time

	_lock_attack_facing_toward_player_or_snapshot()
	_start_attack_lunge(range, lunge_speed, lunge_time)

	_spawn_attack_hitbox(
		damage,
		range,
		perilous,
		attack_id,
		knockback_force
	)
	
	_play_attack_anim_and_get_duration(
		["attack_" + attack_id, attack_id, "attack_slash", "attack"],
		active_time + recovery
	)
	
	await get_tree().create_timer(active_time).timeout
	
	if my_parry_gen != _parry_gen or my_attack_gen != _attack_gen:
		_abort_attack_sequence()
		return
	
	_cleanup_swipe()
	swinging = false
	is_attacking = false
	_attack_recovery = true
	
	await get_tree().create_timer(recovery).timeout
	
	if my_parry_gen != _parry_gen:
		return
	
	_finish_attack()

# =============================================================================
# CHARGE SLASH
# =============================================================================
func _start_charge_slash() -> void:
	_last_charge_time = Time.get_ticks_msec() * 0.001
	
	_start_single_sword_attack(
		"charge_slash",
		charge_damage,
		charge_range,
		charge_windup,
		charge_active,
		charge_recovery,
		true,
		charge_lunge_speed,
		charge_lunge_time,
		charge_knockback_force
	)


# =============================================================================
# SPIRIT COMBO
# =============================================================================

func _start_spirit_combo() -> void:
	if telegraphing or is_attacking or _dbroken_active or _reforming:
		_release_attack_token()
		return
	
	telegraphing = true
	_last_combo3_time = Time.get_ticks_msec() * 0.001
	_parry_gen += 1
	var my_gen := _parry_gen
	
	_release_role("advance_move")
	_combo_hits_remaining = 3
	
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
	
	_show_parry_indicator(combo3_telegraph_time, false)
	_play_windup_animation(combo3_telegraph_time)
	
	await get_tree().create_timer(combo3_telegraph_time).timeout
	
	if my_gen != _parry_gen or _dbroken_active or _reforming:
		_abort_attack_sequence()
		return
	
	telegraphing = false
	_set_anim_speed_safe(1.0)
	
	_perform_spirit_combo_hit(1, my_gen)


func _perform_spirit_combo_hit(hit_num: int, gen: int) -> void:
	if gen != _parry_gen or _dbroken_active or _reforming:
		_abort_attack_sequence()
		return
	
	await _wait_for_hitstop()
	
	if gen != _parry_gen or _dbroken_active or _reforming:
		_abort_attack_sequence()
		return
	
	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_attack_gen := _attack_gen
	
	var is_final := hit_num == 3
	var hit_damage := combo3_final_damage if is_final else combo3_damage_per_hit
	var attack_id := "spirit_combo_final" if is_final else "spirit_combo_%d" % hit_num
	
	active_window = combo3_active

	_lock_attack_facing_toward_player_or_snapshot()
	_start_attack_lunge(combo3_range, combo3_lunge_speed, combo3_lunge_time)

	_spawn_attack_hitbox(
		hit_damage,
		combo3_range,
		is_final,
		attack_id,
		combo3_knockback_force if is_final else 0.0
	)
	
	var anim_len := _play_attack_anim_and_get_duration(
		["attack_combo_%d" % hit_num, "spirit_combo_%d" % hit_num, "attack_slash", "attack"],
		0.40
	)
	
	await get_tree().create_timer(combo3_active).timeout
	
	if gen != _parry_gen or my_attack_gen != _attack_gen:
		_abort_attack_sequence()
		return
	
	_cleanup_swipe()
	swinging = false
	is_attacking = false
	
	var remaining = max(0.0, anim_len - combo3_active)
	if remaining > 0.0:
		await get_tree().create_timer(remaining).timeout
		
		if gen != _parry_gen or my_attack_gen != _attack_gen:
			_abort_attack_sequence()
			return
	
	_combo_hits_remaining -= 1
	
	if hit_num < 3 and _combo_hits_remaining > 0:
		var next_is_final := hit_num + 1 == 3
		var windup_time = combo3_final_telegraph if next_is_final else max(combo3_hit_delay, 0.25)
		
		telegraphing = true
		_show_parry_indicator(windup_time, next_is_final)
		_play_windup_animation(windup_time)
		
		await get_tree().create_timer(windup_time).timeout
		
		if gen != _parry_gen or _dbroken_active or _reforming:
			_abort_attack_sequence()
			return
		
		telegraphing = false
		_set_anim_speed_safe(1.0)
		
		_perform_spirit_combo_hit(hit_num + 1, gen)
		return
	
	_attack_recovery = true
	
	await get_tree().create_timer(combo3_recovery_time).timeout
	
	if gen != _parry_gen:
		return
	
	_finish_attack()


# =============================================================================
# ATTACK HELPERS
# =============================================================================

func _play_windup_animation(windup_time: float) -> void:
	if anim == null:
		return
	
	if anim.has_animation("attack_windup"):
		var base_len := anim.get_animation("attack_windup").length
		if windup_time > 0.001:
			anim.speed_scale = base_len / windup_time
		anim.play("attack_windup")
		return
	
	if anim.has_animation("windup"):
		var base_len := anim.get_animation("windup").length
		if windup_time > 0.001:
			anim.speed_scale = base_len / windup_time
		anim.play("windup")

func _start_attack_lunge(range_val: float, speed: float, duration: float) -> void:
	if speed <= 0.0 or duration <= 0.0:
		_lunge_dir = Vector2.ZERO
		_lunge_speed = 0.0
		_lunge_until = 0.0
		return
	
	var now_s := Time.get_ticks_msec() * 0.001
	
	var lunge := _compute_humanoid_attack_lunge(
		range_val,
		speed * 0.55,
		duration * 0.75,
		speed,
		duration
	)
	
	_apply_humanoid_lunge(lunge, now_s)

func _spawn_attack_hitbox(
	damage: int,
	range: float,
	perilous: bool,
	attack_id: String,
	knockback_force: float = 0.0
) -> void:
	_cleanup_swipe()
	_current_hit_targets.clear()
	
	var area := Area2D.new()
	area.name = "CourtGuardAttack_%s" % attack_id
	area.add_to_group("attack")
	area.add_to_group("enemy_attack")
	
	area.monitoring = true
	area.monitorable = true
	
	if attack_collision_layer > 0:
		area.collision_layer = attack_collision_layer
	
	if attack_collision_mask > 0:
		area.collision_mask = attack_collision_mask
	
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = max(attack_hitbox_radius, range * 0.28)
	shape.shape = circle
	area.add_child(shape)
	
	var aim_dir := Vector2.RIGHT

	if _windup_player_pos0 != Vector2.ZERO:
		var dv := _windup_player_pos0 - global_position
		if dv.length() > 0.001:
			aim_dir = dv.normalized()
	elif is_instance_valid(player):
		aim_dir = global_position.direction_to(player.global_position)
	elif sprite and sprite.flip_h:
		aim_dir = Vector2.RIGHT
	else:
		aim_dir = Vector2.LEFT
	
	var offset = min(range, attack_hitbox_offset + range * 0.25)
	area.position = aim_dir * offset
	
	area.set_meta("attacker", self)
	area.set_meta("damage", damage)
	area.set_meta("damage_type", "perilous" if perilous else "normal")
	area.set_meta("attack_id", attack_id)
	area.set_meta("parryable", true)
	area.set_meta("blockable", not perilous)
	area.set_meta("parry_only", perilous)
	area.set_meta("knockback_force", knockback_force)
	area.set_meta("swing_dir", aim_dir)
	area.set_meta("swing_offset", offset)
	area.set_meta("consumed", false)
	
	add_child(area)
	_current_swipe_area = area
	
	area.area_entered.connect(_on_attack_area_entered.bind(area))
	area.body_entered.connect(_on_attack_body_entered.bind(area))


func _on_attack_area_entered(other: Area2D, attack_area: Area2D) -> void:
	_apply_attack_to_target(other, attack_area)


func _on_attack_body_entered(other: Node2D, attack_area: Area2D) -> void:
	_apply_attack_to_target(other, attack_area)


func _apply_attack_to_target(other: Node, attack_area: Area2D) -> void:
	if not is_instance_valid(attack_area):
		return
	
	if not is_instance_valid(other):
		return
	
	if bool(attack_area.get_meta("consumed", false)):
		return
	
	var root: Node = other
	
	if not root.is_in_group("player") and other.get_parent() and other.get_parent().is_in_group("player"):
		root = other.get_parent()
	
	if not root.is_in_group("player"):
		return
	
	if _current_hit_targets.has(root):
		return
	
	_current_hit_targets[root] = true
	
	var damage := int(attack_area.get_meta("damage", enemy_damage))
	var damage_type := str(attack_area.get_meta("damage_type", "normal"))
	
	if other.has_method("hurt"):
		other.hurt(damage, damage_type, self)
	elif root.has_method("hurt"):
		root.hurt(damage, damage_type, self)
	elif root.has_method("_on_hurt_box_hurt"):
		root._on_hurt_box_hurt(damage, damage_type, self)
	elif root.has_method("take_damage"):
		root.take_damage(damage)


func _finish_attack() -> void:
	_cleanup_swipe()
	_hide_parry_indicator()
	
	telegraphing = false
	swinging = false
	is_attacking = false
	_attack_recovery = false
	
	_lunge_until = 0.0
	_lunge_speed = 0.0
	_lunge_dir = Vector2.ZERO
	_clear_attack_facing_lock()
	_clear_humanoid_counter_queue()
	_set_anim_speed_safe(1.0)
	_release_attack_token()
	
	var now := Time.get_ticks_msec() * 0.001
	_last_attack_ended_at = now
	next_swipe_time = now + randf_range(attack_cooldown_min, attack_cooldown_max)
	_recover_lock_until = now + post_attack_lockout
	
	if randf() < orbit_flip_chance:
		_orbit_dir *= -1.0


func _abort_attack_sequence() -> void:
	_soft_reset_humanoid_attack_runtime()
	_combo_hits_remaining = 0
	_release_attack_token()
	_clear_attack_facing_lock()
	_clear_humanoid_counter_queue()
	
	var now := Time.get_ticks_msec() * 0.001
	next_swipe_time = now + 0.45
	_recover_lock_until = now + 0.25


func _cancel_attack() -> void:
	_abort_attack_sequence()


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
	
	_full_reset_humanoid_attack_runtime()
	_set_blocking(false)
	
	if anim and anim.has_animation("stagger"):
		anim.play("stagger")
	
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
	if has_died:
		return
	
	# Reform phase 1: invulnerable channel.
	if _reforming and _reform_phase == 1:
		return
	
	# Reform phase 2: vulnerable corruption body.
	if _reforming and _reform_phase == 2:
		var reform_damage = max(1, damage)
		_reform_hp_current -= reform_damage
		
		show_enemy_damage_number(reform_damage, "default", randf_range(-30.0, -20.0))
		_flash_sprite(Color(1.0, 1.0, 1.0, 1.0), 0.05)
		
		if _reform_hp_current <= 0:
			_permanent_death()
		
		return
	
	if damage <= 0 and damage_type != "knockback":
		return
	
	var source := _resolve_hurt_source(attacker)
	
	if source and is_instance_valid(source) and source.is_in_group("enemy"):
		return
	
	if attacker != null:
		var is_attack_area := (attacker is Area2D) and attacker.is_in_group("attack")
		var is_enemy_body := (attacker is CharacterBody2D or attacker is Node2D) and attacker.is_in_group("enemy")
		if is_enemy_body and not is_attack_area:
			return
	
	if damage_type == "knockback":
		if attacker is Node2D:
			apply_knockback(attacker.global_position.direction_to(global_position) * damage)
		return
	
	var response := _get_incoming_attack_response(damage, damage_type, attacker)
	var is_heavy_attack := bool(response.get("heavy", false))
	
	var blocked := false
	var can_block_now := can_block and not telegraphing and not _dbroken_active and not _reforming
	
	if is_attacking and not _attack_recovery:
		can_block_now = false
	
	var is_blockable_type := bool(response.get("blockable", true))
	if damage_type == "true" or damage_type == "unblockable":
		is_blockable_type = false
	
	if can_block_now and is_blockable_type:
		if _block_active:
			blocked = true
		elif _is_frontal_attack(attacker):
			blocked = true
	
	var hp_damage := int(round(float(damage) * float(response.get("hp_mult", 1.0))))
	
	if blocked:
		hp_damage = 0
		_block_stagger_until = Time.get_ticks_msec() * 0.001 + float(response.get("block_stagger", BLOCK_STAGGER_TIME))
		_on_block_impact(attacker, is_heavy_attack, response)
	else:
		_block_stagger_until = Time.get_ticks_msec() * 0.001 + _get_heavy_block_stagger_time()
		
		add_posture_damage(float(response.get("posture_on_hit", max(1.0, float(damage) * 0.5))))
		
		var hit_kb := float(response.get("hit_knockback", 0.0))
		if hit_kb > 0.0:
			var kb_source: Node = source if source else attacker
			if kb_source is Node2D:
				var kb_dir = (global_position - kb_source.global_position).normalized()
				apply_knockback(kb_dir * hit_kb)
		
		hitstop_local(float(response.get("hitstop_hit", 0.06)))
	
	apply_hp_damage(hp_damage)
	
	if hp_damage > 0:
		var is_crit := false
		if source and source.has_method("is_critical_strike") and source.is_critical_strike():
			is_crit = true
		
		var display_type := "critical" if is_crit else damage_type
		show_enemy_damage_number(hp_damage, display_type, -20.0)
	
	notify_combat_got_hit({
		"damage": damage,
		"blocked": blocked,
		"damage_type": damage_type
	})
	
	# Current prosthetic/stance-era systems.
	if not blocked and hp_damage > 0 and is_instance_valid(player):
		if player.has_meta("smoke_slash_ready") and player.get_meta("smoke_slash_ready"):
			var bonus_hp := int(hp_damage * 0.5)
			var bonus_posture := 8.0
			
			apply_hp_damage(bonus_hp)
			add_posture_damage(bonus_posture)
			show_enemy_damage_number(bonus_hp, "prosthetic", -25.0)
			player.set_meta("smoke_slash_ready", false)
		
		ProstheticEffects.check_lifesteal(player, hp_damage)
	
	if hp <= 0:
		death()

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
	
	# Keep the node alive during reform. This prevents the spawner from counting it dead
	# until the body is actually destroyed or permanently killed.
	hp = 1
	
	_full_reset_humanoid_attack_runtime()
	_set_blocking(false)
	_release_all_attack_director_state()
	_clear_humanoid_counter_queue()
	_clear_attack_facing_lock()
	_dbroken_active = false
	_dbreak_until = 0.0
	stunned_until = 0.0
	
	velocity = Vector2.ZERO
	knockback = Vector2.ZERO
	
	if hurt_box and is_instance_valid(hurt_box):
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
	
	set_collision_mask_value(3, false)
	
	if anim and anim.has_animation("stagger"):
		anim.play("stagger")
	
	_start_reform_visual()
	hide_posture_bar()
	
	if debug_logs:
		print("[CourtGuard] Reform Phase 1 — channeling %.1fs" % channel_time)


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
		print("[CourtGuard] Reform Phase 2 — vulnerable %d HP for %.1fs" % [_reform_hp_current, vulnerable_time])


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
	
	var now := Time.get_ticks_msec() * 0.001
	_last_attack_ended_at = now
	next_swipe_time = now + 1.0
	_recover_lock_until = now + 0.5
	
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
		print("[CourtGuard] Corruption revive complete — %d HP" % hp)


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


func _permanent_death() -> void:
	_reforming = false
	_reform_phase = 0
	
	_stop_reform_visual()
	
	if hurt_box and is_instance_valid(hurt_box):
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
	
	if not mark_dead():
		return
	
	emit_signal("enemy_died", self)
	
	_run_humanoid_death_rewards()
	_clear_humanoid_counter_queue()
	_clear_attack_facing_lock()
	base_death_cleanup()
