extends HumanoidEnemyBase

## =============================================================================
## COURT SENTINEL — Area 3 Elite Heavy Enforcer
## =============================================================================
## OLD:
##   Court Sentinel / Brute -> CharacterBody2D standalone controller
##
## NEW:
##   Court Sentinel -> HumanoidEnemyBase -> EnemyBase
##
## Identity:
## - Slow, high-HP, high-posture heavy humanoid
## - Blocks by default when not committed to an attack
## - Heavy attacks resist stagger during windup/active
## - Parryable heavy pressure with one perilous rush
## - Frenzy phase below HP threshold
## =============================================================================

enum SentinelState { IDLE, PURSUING, APPROACHING, ATTACKING }
enum AttackType { NONE, ARC_SWING, OVERHEAD_SLAM, BULL_RUSH, BACKHAND_SHOVE, FRENZY }
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

signal formation_broken
signal defeated
signal posture_recovered

# =============================================================================
# CORE
# =============================================================================

@export_group("Court Sentinel Core")
@export var sentinel_default_hp: int = 140
@export var base_movement_speed: float = 45.0
@export var approach_speed: float = 85.0
@export var debug_logs: bool = false

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================

@export_group("Posture / Deathblow")
@export var parry_posture_damage: float = 20.0
@export var posture_break_duration: float = 3.0
@export var deathblow_instant_kill: bool = true
@export var deathblow_damage: int = 999

# =============================================================================
# DISTANCE / SPACING
# =============================================================================

@export_group("Distance Thresholds")
@export var close_range: float = 95.0
@export var mid_range: float = 180.0
@export var far_range: float = 280.0
@export var too_close_threshold: float = 40.0

@export_group("Spacing")
@export var ideal_combat_distance: float = 75.0
@export var min_separation: float = 25.0

# =============================================================================
# ATTACK PACING
# =============================================================================

@export_group("Attack Pacing")
@export var min_attack_cooldown: float = 1.4
@export var max_attack_cooldown: float = 2.2

# =============================================================================
# ARC SWING
# =============================================================================

@export_group("Arc Swing")
@export var arc_windup: float = 0.65
@export var arc_active: float = 0.18
@export var arc_recovery: float = 0.50
@export var arc_lunge_distance: float = 50.0
@export var arc_lunge_speed: float = 200.0
@export var arc_damage: int = 12
@export var arc_swing_length: float = 90.0
@export var arc_swing_width: float = 70.0
@export var arc_overstay_range: float = 55.0
@export var arc_overstay_window: float = 0.25

# =============================================================================
# OVERHEAD SLAM
# =============================================================================

@export_group("Overhead Slam")
@export var slam_windup: float = 0.75
@export var slam_active: float = 0.15
@export var slam_recovery: float = 0.60
@export var slam_damage: int = 14
@export var slam_radius: float = 55.0
@export var shockwave_delay: float = 0.08
@export var shockwave_damage: int = 8
@export var shockwave_radius: float = 75.0
@export var shockwave_lifetime: float = 0.20

# =============================================================================
# BULL RUSH
# =============================================================================

@export_group("Bull Rush")
@export var rush_windup: float = 0.50
@export var rush_charge_speed: float = 300.0
@export var rush_charge_duration: float = 0.35
@export var rush_damage: int = 16
@export var rush_recovery: float = 0.55
@export var rush_hitbox_length: float = 50.0
@export var rush_hitbox_width: float = 36.0

# =============================================================================
# BACKHAND SHOVE
# =============================================================================

@export_group("Backhand Shove")
@export var shove_windup: float = 0.22
@export var shove_active: float = 0.10
@export var shove_damage: int = 8
@export var shove_recovery: float = 0.30
@export var shove_swing_length: float = 60.0
@export var shove_swing_width: float = 50.0

# =============================================================================
# FRENZY
# =============================================================================

@export_group("Frenzy")
@export var frenzy_roar_time: float = 0.45
@export var frenzy_slam_count_min: int = 4
@export var frenzy_slam_count_max: int = 6
@export var frenzy_slam_interval_base: float = 0.40
@export var frenzy_slam_interval_variance: float = 0.12
@export var frenzy_slam_damage: int = 8
@export var frenzy_slam_radius: float = 50.0
@export var frenzy_recovery: float = 0.80
@export var frenzy_hp_threshold: float = 0.60
@export var frenzy_cooldown: float = 12.0
@export var frenzy_random_chance: float = 0.04

@export_group("Frenzy Movement")
@export var frenzy_move_speed: float = 145.0
@export var frenzy_step_time: float = 0.10
@export var frenzy_leash_radius: float = 42.0
@export var frenzy_return_pull: float = 220.0

# =============================================================================
# PARRY / GUARD
# =============================================================================

@export_group("Parry Timing")
@export var parry_linger_window: float = 0.18

@export_group("Guard / Blocking")
@export var guard_slipthrough_chance: float = 0.10
@export var block_posture_bonus_light: float = 3.0
@export var block_posture_bonus_heavy: float = 6.0

# =============================================================================
# RUNTIME
# =============================================================================

var _sentinel_state: int = SentinelState.IDLE
var _current_attack: int = AttackType.NONE
var _combat_phase: int = CombatPhase.NONE

var _attack_cooldown: float = 0.0
var _approach_timer: float = 0.0
var _approach_current_speed: float = 0.0

var _attack_sequence_id: int = 0
var _combo_interrupted: bool = false

var _parry_recoil_until: float = 0.0
var _parry_recoil_velocity: Vector2 = Vector2.ZERO

var _dbroken_active: bool = false
var _dbreak_until: float = -1.0
var _dbreak_immunity_until: float = 0.0
var _deathblow_in_progress: bool = false

var _frenzy_triggered_threshold: bool = false
var _frenzy_cooldown_until: float = 0.0

var _force_attack_soon: bool = false
var _current_hitbox: Area2D = null

var _formation_broken: bool = false
var _rng := RandomNumberGenerator.new()

# =============================================================================
# READY / PHYSICS
# =============================================================================

func _ready() -> void:
	super._ready()
	
	if hp == 200:
		hp = sentinel_default_hp
		_max_hp = sentinel_default_hp
	
	movement_speed = base_movement_speed
	
	can_block = true
	block_by_default = true
	
	_rng.randomize()
	add_to_group("brute")
	add_to_group("court_sentinel")
	
	if combat and combat.has_method("update_health_ratio"):
		combat.update_health_ratio(float(hp), float(get_max_hp()))
	
	if auto_aggro_on_spawn:
		_saw_player_once = true


func _physics_process(delta: float) -> void:
	if has_died:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _humanoid_shared_tick(delta):
		_update_basic_movement_anim()
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	_update_posture_break(now)
	_update_blocking(delta, now)
	_update_sprite_facing()
	
	if _dbroken_active:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if now < stunned_until:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	if now < _parry_recoil_until:
		velocity = _parry_recoil_velocity
		move_and_slide()
		_update_basic_movement_anim()
		return
	else:
		_parry_recoil_velocity = Vector2.ZERO
	
	if combat and combat.has_method("update_health_ratio"):
		combat.update_health_ratio(float(hp), float(get_max_hp()))
	
	_attack_cooldown = max(_attack_cooldown - delta, 0.0)
	
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
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.RIGHT
	
	match _sentinel_state:
		SentinelState.IDLE:
			_process_idle(dist, dir)
		SentinelState.PURSUING:
			_process_pursuing(dist, dir)
		SentinelState.APPROACHING:
			_process_approaching(dist, dir, delta)
		SentinelState.ATTACKING:
			pass
	
	_apply_soft_separation()
	move_and_slide()
	_update_basic_movement_anim()


func engage() -> void:
	_saw_player_once = true
	auto_aggro_on_spawn = true


# =============================================================================
# STATE PROCESSING
# =============================================================================

func _process_idle(dist: float, dir: Vector2) -> void:
	velocity = Vector2.ZERO
	_face_direction(dir)
	_play_idle()
	
	if _is_backed_off():
		return
	
	if dist > mid_range + 50.0:
		_sentinel_state = SentinelState.PURSUING
		return
	
	if _attack_cooldown > 0.0:
		return
	
	if _should_frenzy():
		_try_start_attack(AttackType.FRENZY)
		return
	
	if _force_attack_soon:
		_force_attack_soon = false
		_attack_cooldown = 0.0
	
	var attack := _choose_attack(dist)
	
	if attack == AttackType.NONE:
		return
	
	if dist > close_range and attack in [AttackType.ARC_SWING, AttackType.OVERHEAD_SLAM]:
		_transition_to_approaching()
		return
	
	_try_start_attack(attack)


func _process_pursuing(dist: float, dir: Vector2) -> void:
	if dist <= mid_range:
		_sentinel_state = SentinelState.IDLE
		return
	
	if _is_backed_off():
		velocity = Vector2.ZERO
		_play_idle()
		return
	
	velocity = dir * base_movement_speed
	_face_direction(dir)
	_play_walk()


func _process_approaching(dist: float, dir: Vector2, delta: float) -> void:
	if _is_backed_off():
		_sentinel_state = SentinelState.IDLE
		velocity = Vector2.ZERO
		return
	
	_approach_timer -= delta
	_approach_current_speed = min(_approach_current_speed + 30.0 * delta, approach_speed)
	
	velocity = dir * _approach_current_speed
	_face_direction(dir)
	_play_walk()
	
	if dist <= close_range:
		velocity = Vector2.ZERO
		_sentinel_state = SentinelState.IDLE
		_attack_cooldown = 0.0
		return
	
	if _approach_timer <= 0.0:
		if dist <= close_range * 2.0:
			_sentinel_state = SentinelState.IDLE
			_attack_cooldown = 0.0
		elif dist > far_range:
			_try_start_attack(AttackType.BULL_RUSH)
		else:
			_sentinel_state = SentinelState.IDLE


func _transition_to_approaching() -> void:
	_sentinel_state = SentinelState.APPROACHING
	_approach_timer = 3.0
	_approach_current_speed = approach_speed * 0.6


# =============================================================================
# ATTACK SELECTION
# =============================================================================

func _choose_attack(dist: float) -> int:
	var weights := {}
	
	weights[AttackType.ARC_SWING] = 0.40 if dist <= close_range * 1.5 else 0.10
	weights[AttackType.OVERHEAD_SLAM] = 0.25 if dist <= close_range * 1.3 else 0.05
	
	if dist > close_range * 0.8:
		weights[AttackType.BULL_RUSH] = 0.35 if dist > mid_range * 0.7 else 0.15
	else:
		weights[AttackType.BULL_RUSH] = 0.0
	
	var total := 0.0
	for w in weights.values():
		total += float(w)
	
	if total <= 0.0:
		return AttackType.ARC_SWING
	
	var pick := _rng.randf() * total
	var acc := 0.0
	
	for atk in weights.keys():
		acc += float(weights[atk])
		if pick <= acc and float(weights[atk]) > 0.0:
			return int(atk)
	
	return AttackType.ARC_SWING


func _should_frenzy() -> bool:
	var now := Time.get_ticks_msec() * 0.001
	
	if now < _frenzy_cooldown_until:
		return false
	
	var hp_ratio := get_hp_ratio()
	
	if hp_ratio <= frenzy_hp_threshold and not _frenzy_triggered_threshold:
		_frenzy_triggered_threshold = true
		return true
	
	if hp_ratio <= frenzy_hp_threshold and _rng.randf() < frenzy_random_chance:
		return true
	
	return false


# =============================================================================
# ATTACK LIFECYCLE
# =============================================================================
func _try_start_attack(attack: int) -> bool:
	if _sentinel_state == SentinelState.ATTACKING:
		return false
	
	if _dbroken_active or has_died:
		return false
	
	if not _request_attack_token():
		return false
	
	_start_attack(attack)
	return true

func _start_attack(attack: int) -> void:
	_sentinel_state = SentinelState.ATTACKING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1
	
	match attack:
		AttackType.ARC_SWING:
			_do_arc_swing()
		AttackType.OVERHEAD_SLAM:
			_do_overhead_slam()
		AttackType.BULL_RUSH:
			_do_bull_rush()
		AttackType.BACKHAND_SHOVE:
			_do_backhand_shove()
		AttackType.FRENZY:
			_do_frenzy()


func _finish_attack() -> void:
	_attack_cooldown = _rng.randf_range(min_attack_cooldown, max_attack_cooldown)
	
	_release_role("melee_attack")
	_release_attack_token()
	
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_sentinel_state = SentinelState.IDLE
	
	_cleanup_hitbox()
	_combo_interrupted = false
	_play_idle()


func _should_abort_attack(sequence_id: int) -> bool:
	if has_died:
		return true
	
	if _dbroken_active:
		return true
	
	if _combo_interrupted:
		return true
	
	if sequence_id != _attack_sequence_id:
		return true
	
	return false


func _set_combat_phase(phase: int) -> void:
	_combat_phase = phase


func _has_stagger_resistance() -> bool:
	if _combat_phase != CombatPhase.WINDUP and _combat_phase != CombatPhase.ACTIVE:
		return false
	
	match _current_attack:
		AttackType.ARC_SWING, AttackType.OVERHEAD_SLAM, AttackType.BULL_RUSH, AttackType.FRENZY:
			return true
	
	return false


# =============================================================================
# ATTACK 1: ARC SWING
# =============================================================================

func _do_arc_swing() -> void:
	var my_seq := _attack_sequence_id
	
	if _should_abort_attack(my_seq):
		return
	
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	var dir := _get_player_dir()
	_face_direction(dir)
	
	_show_parry_indicator(arc_windup + arc_active + parry_linger_window, false)
	
	if anim and anim.has_animation("arc_windup"):
		anim.play("arc_windup")
	
	var lunge_time := arc_lunge_distance / arc_lunge_speed if arc_lunge_speed > 0.0 else 0.0
	var pre_lunge = max(0.0, arc_windup - lunge_time)
	
	if not await _wait_interruptible(pre_lunge, my_seq):
		return
	
	if lunge_time > 0.0:
		dir = _get_player_dir()
		_face_direction(dir)
		
		if not await _lunge_phase(dir, arc_lunge_distance, arc_lunge_speed, lunge_time, my_seq):
			return
	
	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_finish_attack()
		return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_rect_hitbox("CourtSentinelArc", dir, arc_damage, "melee", arc_swing_length, arc_swing_width, false)
	
	if anim and anim.has_animation("arc_swing"):
		anim.play("arc_swing")
	
	if not await _wait_interruptible(arc_active + parry_linger_window, my_seq):
		return
	
	_cleanup_hitbox()
	velocity = Vector2.ZERO
	
	_set_combat_phase(CombatPhase.RECOVERY)
	
	var overstay_elapsed := 0.0
	
	while overstay_elapsed < arc_overstay_window:
		if _should_abort_attack(my_seq):
			_finish_attack()
			return
		
		await get_tree().physics_frame
		
		if not is_instance_valid(self):
			return
		
		overstay_elapsed += get_physics_process_delta_time()
		
		if is_instance_valid(player):
			var d := player.global_position.distance_to(global_position)
			if d <= arc_overstay_range:
				_cleanup_hitbox()
				_set_combat_phase(CombatPhase.NONE)
				_current_attack = AttackType.BACKHAND_SHOVE
				_do_backhand_shove()
				return
	
	var remaining_recovery = max(0.0, arc_recovery - arc_overstay_window)
	
	if not await _wait_interruptible(remaining_recovery, my_seq):
		return
	
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK 2: OVERHEAD SLAM
# =============================================================================

func _do_overhead_slam() -> void:
	var my_seq := _attack_sequence_id
	
	if _should_abort_attack(my_seq):
		return
	
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	var dir := _get_player_dir()
	_face_direction(dir)
	
	_show_parry_indicator(slam_windup + slam_active + parry_linger_window, false)
	
	if anim and anim.has_animation("overhead_windup"):
		anim.play("overhead_windup")
	
	if not await _wait_interruptible(slam_windup, my_seq):
		return
	
	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_finish_attack()
		return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_circle_hitbox("CourtSentinelSlam", global_position, slam_damage, "melee", slam_radius, false)
	
	if anim:
		if anim.has_animation("overhead_impact"):
			anim.play("overhead_impact")
		elif anim.has_animation("overhead"):
			anim.play("overhead")
	
	if not await _wait_interruptible(slam_active + parry_linger_window, my_seq):
		return
	
	_cleanup_hitbox()
	
	if not _should_abort_attack(my_seq):
		if not await _wait_interruptible(shockwave_delay, my_seq):
			return
		
		_spawn_shockwave(global_position)
	
	_set_combat_phase(CombatPhase.RECOVERY)
	
	if not await _wait_interruptible(slam_recovery, my_seq):
		return
	
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK 3: BULL RUSH
# =============================================================================

func _do_bull_rush() -> void:
	var my_seq := _attack_sequence_id
	
	if _should_abort_attack(my_seq):
		return
	
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	var dir := _get_player_dir()
	_face_direction(dir)
	
	_show_parry_indicator(rush_windup + rush_charge_duration + rush_recovery, true)
	
	if anim and anim.has_animation("rush_windup"):
		anim.play("rush_windup")
	
	if not await _wait_interruptible(rush_windup, my_seq):
		return
	
	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_finish_attack()
		return
	
	dir = _get_player_dir()
	_face_direction(dir)
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_rect_hitbox("CourtSentinelRush", dir, rush_damage, "perilous", rush_hitbox_length, rush_hitbox_width, true)
	
	if anim and anim.has_animation("rush_charge"):
		anim.play("rush_charge")
	
	var charge_elapsed := 0.0
	
	while charge_elapsed < rush_charge_duration:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_finish_attack()
			return
		
		velocity = dir * rush_charge_speed
		
		await get_tree().physics_frame
		
		if not is_instance_valid(self):
			return
		
		charge_elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	
	if not await _wait_interruptible(rush_recovery, my_seq):
		return
	
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK 4: BACKHAND SHOVE
# =============================================================================

func _do_backhand_shove() -> void:
	var my_seq := _attack_sequence_id
	
	if _should_abort_attack(my_seq):
		return
	
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	var dir := _get_player_dir()
	_face_direction(dir)
	
	_show_parry_indicator(shove_windup + shove_active + parry_linger_window * 0.5, false)
	
	if anim and anim.has_animation("shove_windup"):
		anim.play("shove_windup")
	
	if not await _wait_interruptible(shove_windup, my_seq):
		return
	
	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_finish_attack()
		return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_rect_hitbox("CourtSentinelShove", dir, shove_damage, "melee", shove_swing_length, shove_swing_width, false)
	
	if anim and anim.has_animation("shove_swing"):
		anim.play("shove_swing")
	
	if not await _wait_interruptible(shove_active + parry_linger_window * 0.5, my_seq):
		return
	
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	
	if not await _wait_interruptible(shove_recovery, my_seq):
		return
	
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK 5: FRENZY
# =============================================================================

func _do_frenzy() -> void:
	var my_seq := _attack_sequence_id
	
	if _should_abort_attack(my_seq):
		return
	
	_frenzy_cooldown_until = Time.get_ticks_msec() * 0.001 + frenzy_cooldown
	
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	var frenzy_origin := global_position
	
	if anim and anim.has_animation("frenzy_roar"):
		anim.play("frenzy_roar")
	
	if not await _wait_interruptible(frenzy_roar_time, my_seq):
		return
	
	if _should_abort_attack(my_seq):
		_finish_attack()
		return
	
	var slam_count := _rng.randi_range(frenzy_slam_count_min, frenzy_slam_count_max)
	
	for i in range(slam_count):
		if _should_abort_attack(my_seq):
			_cleanup_hitbox()
			_finish_attack()
			return
		
		var slam_dir := _pick_frenzy_slam_direction(i, slam_count)
		_face_direction(slam_dir)
		
		_set_combat_phase(CombatPhase.WINDUP)
		
		if not await _do_frenzy_step(slam_dir, frenzy_origin, frenzy_step_time, my_seq):
			return
		
		if not await _wait_interruptible(0.08, my_seq):
			return
		
		_set_combat_phase(CombatPhase.ACTIVE)
		_current_hitbox = _spawn_circle_hitbox(
			"CourtSentinelFrenzySlam",
			global_position + slam_dir.normalized() * (frenzy_slam_radius * 0.4),
			frenzy_slam_damage,
			"melee",
			frenzy_slam_radius,
			false
		)
		
		if anim and anim.has_animation("frenzy_slam"):
			anim.play("frenzy_slam")
		
		if not await _wait_interruptible(0.10, my_seq):
			return
		
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		
		var interval := frenzy_slam_interval_base + _rng.randf_range(-frenzy_slam_interval_variance, frenzy_slam_interval_variance)
		interval = max(0.15, interval)
		
		if not await _wait_interruptible(interval, my_seq):
			return
	
	_set_combat_phase(CombatPhase.RECOVERY)
	velocity = Vector2.ZERO
	
	if anim and anim.has_animation("frenzy_exhausted"):
		anim.play("frenzy_exhausted")
	
	if not await _wait_interruptible(frenzy_recovery, my_seq):
		return
	
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


func _do_frenzy_step(move_dir: Vector2, origin: Vector2, duration: float, seq_id: int) -> bool:
	var elapsed := 0.0
	
	while elapsed < duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return false
		
		var desired_vel := move_dir.normalized() * frenzy_move_speed
		
		var to_origin := origin - global_position
		if to_origin.length() > frenzy_leash_radius:
			desired_vel += to_origin.normalized() * frenzy_return_pull
		
		velocity = desired_vel
		
		await get_tree().physics_frame
		
		if not is_instance_valid(self):
			return false
		
		elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	return true


func _pick_frenzy_slam_direction(index: int, total: int) -> Vector2:
	var to_player := _get_player_dir()
	
	if index == 0 or index == total - 1:
		return to_player.rotated(_rng.randf_range(-0.3, 0.3))
	
	if _rng.randf() < 0.4:
		return to_player.rotated(_rng.randf_range(-0.4, 0.4))
	
	var angle := to_player.angle() + _rng.randf_range(-PI * 0.6, PI * 0.6)
	return Vector2.RIGHT.rotated(angle)


# =============================================================================
# HITBOXES
# =============================================================================

func _spawn_rect_hitbox(
	hitbox_name: String,
	dir: Vector2,
	damage: int,
	damage_type: String,
	length: float,
	width: float,
	perilous: bool
) -> Area2D:
	var area := Area2D.new()
	area.name = hitbox_name
	area.add_to_group("attack")
	area.add_to_group("enemy_attack")
	
	area.collision_layer = 2
	area.collision_mask = 4
	area.monitoring = true
	area.monitorable = true
	
	area.set_meta("damage", damage)
	area.set_meta("damage_type", damage_type)
	area.set_meta("attacker", self)
	area.set_meta("parryable", true)
	area.set_meta("blockable", not perilous)
	area.set_meta("parry_only", perilous)
	area.set_meta("telegraphed", true)
	area.set_meta("swing_token", Time.get_ticks_msec() + randi_range(0, 9999))
	area.set_meta("consumed", false)
	
	var cs := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, width)
	cs.shape = rect
	area.add_child(cs)
	
	add_child(area)
	area.position = dir.normalized() * (length * 0.45)
	area.rotation = dir.angle()
	
	area.area_entered.connect(_on_sentinel_hitbox_area_entered.bind(area))
	
	return area


func _spawn_circle_hitbox(
	hitbox_name: String,
	center: Vector2,
	damage: int,
	damage_type: String,
	radius: float,
	perilous: bool
) -> Area2D:
	var area := Area2D.new()
	area.name = hitbox_name
	area.add_to_group("attack")
	area.add_to_group("enemy_attack")
	
	area.collision_layer = 2
	area.collision_mask = 4
	area.monitoring = true
	area.monitorable = true
	
	area.set_meta("damage", damage)
	area.set_meta("damage_type", damage_type)
	area.set_meta("attacker", self)
	area.set_meta("parryable", true)
	area.set_meta("blockable", not perilous)
	area.set_meta("parry_only", perilous)
	area.set_meta("telegraphed", true)
	area.set_meta("swing_token", Time.get_ticks_msec() + randi_range(0, 9999))
	area.set_meta("consumed", false)
	
	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = radius
	cs.shape = shape
	area.add_child(cs)
	
	var parent := get_parent()
	if parent:
		parent.add_child(area)
	else:
		add_child(area)
	
	area.global_position = center
	area.area_entered.connect(_on_sentinel_hitbox_area_entered.bind(area))
	
	return area


func _spawn_shockwave(center: Vector2) -> void:
	var area := _spawn_circle_hitbox(
		"CourtSentinelShockwave",
		center,
		shockwave_damage,
		"unblockable",
		shockwave_radius,
		false
	)
	
	area.set_meta("parryable", false)
	area.set_meta("blockable", false)
	area.set_meta("unblockable", true)
	
	get_tree().create_timer(shockwave_lifetime).timeout.connect(func():
		if is_instance_valid(area):
			area.queue_free()
	)


func _on_sentinel_hitbox_area_entered(other: Area2D, attack_area: Area2D) -> void:
	if not is_instance_valid(attack_area):
		return
	
	if bool(attack_area.get_meta("consumed", false)):
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


func _cleanup_hitbox() -> void:
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
		_current_hitbox.queue_free()
	
	_current_hitbox = null
	_cleanup_all_owned_attacks()


func _cleanup_all_owned_attacks() -> void:
	for area in get_tree().get_nodes_in_group("attack"):
		if not is_instance_valid(area):
			continue
		
		if area == _current_hitbox:
			continue
		
		if area.has_meta("attacker") and area.get_meta("attacker") == self:
			area.queue_free()


# =============================================================================
# DAMAGE / BLOCKING
# =============================================================================

func _update_blocking(_delta: float, now: float) -> void:
	if not can_block or _dbroken_active or has_died:
		_set_blocking(false)
		return
	
	if now < _block_stagger_until:
		_set_blocking(false)
		return
	
	if _combat_phase == CombatPhase.WINDUP or _combat_phase == CombatPhase.ACTIVE:
		_set_blocking(false)
		return
	
	if ProstheticEffects.is_confused(self):
		_set_blocking(false)
		return
	
	_set_blocking(block_by_default)


func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if has_died:
		return
	
	if damage <= 0 and damage_type != "knockback":
		return
	
	var source := _resolve_hurt_source(attacker)
	
	if source and is_instance_valid(source) and source.is_in_group("enemy"):
		return
	
	if damage_type == "knockback":
		if attacker is Node2D:
			apply_knockback(attacker.global_position.direction_to(global_position) * damage)
		return
	
	var now := Time.get_ticks_msec() * 0.001
	var response := _get_incoming_attack_response(damage, damage_type, attacker)
	var blockable := bool(response.get("blockable", true))
	var is_heavy := bool(response.get("heavy", false))
	
	var can_block_now := can_block and is_blocking() and blockable
	
	if _combat_phase == CombatPhase.WINDUP or _combat_phase == CombatPhase.ACTIVE:
		can_block_now = false
	
	if can_block_now and _is_frontal_attack(attacker):
		var hp_damage := damage
		
		if _rng.randf() >= guard_slipthrough_chance:
			hp_damage = 0
		
		response["posture_on_block"] = block_posture_bonus_heavy if is_heavy else block_posture_bonus_light
		_block_stagger_until = now + (BLOCK_STAGGER_HEAVY if is_heavy else BLOCK_STAGGER_TIME)
		_on_block_impact(attacker, is_heavy, response)
		
		if hp_damage > 0:
			apply_hp_damage(hp_damage)
			show_enemy_damage_number(hp_damage, damage_type, -20.0)
		
		notify_combat_got_hit({
			"damage": damage,
			"blocked": true,
			"damage_type": damage_type
		})
		
		if hp <= 0:
			death()
		
		return
	
	super._on_hurt_box_hurt(damage, damage_type, attacker)
	
	if hp > 0 and _has_stagger_resistance():
		_flash_hyper_armor_hit()


func _flash_hyper_armor_hit() -> void:
	if not sprite:
		return
	
	var orig := sprite.modulate
	sprite.modulate = Color(0.85, 0.9, 1.0, 1.0)
	
	await get_tree().create_timer(0.04).timeout
	
	if is_instance_valid(sprite):
		sprite.modulate = orig


# =============================================================================
# PARRY / POSTURE / DEATHBLOW
# =============================================================================

func on_parried(parry_source_pos: Vector2) -> void:
	if _dbroken_active or has_died:
		return
	
	_hide_parry_indicator()
	add_posture_damage(parry_posture_damage)
	notify_combat_got_hit({"damage": 0, "parried": true})
	
	_combo_interrupted = true
	_attack_sequence_id += 1
	_cleanup_hitbox()
	
	var source_pos := parry_source_pos
	
	if is_instance_valid(player):
		source_pos = player.global_position
	
	var away := (global_position - source_pos).normalized()
	
	if away == Vector2.ZERO:
		away = Vector2.RIGHT
	
	var recoil_time := 0.22
	var recoil_speed := 110.0
	
	match _current_attack:
		AttackType.OVERHEAD_SLAM, AttackType.BULL_RUSH:
			recoil_time = 0.26
			recoil_speed = 130.0
	
	_parry_recoil_velocity = away * recoil_speed
	_parry_recoil_until = Time.get_ticks_msec() * 0.001 + recoil_time
	
	hitstop_local(0.06)
	_flash_sprite(Color(1.0, 1.0, 1.5), 0.08)
	
	if anim:
		if anim.has_animation("parried"):
			anim.play("parried")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		elif anim.has_animation("hurt"):
			anim.play("hurt")
	
	await get_tree().create_timer(recoil_time + 0.06).timeout
	
	if not is_instance_valid(self):
		return
	
	_parry_recoil_until = 0.0
	_parry_recoil_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	
	if _dbroken_active or has_died:
		return
	
	_sentinel_state = SentinelState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.2, max_attack_cooldown * 1.4)
	_combo_interrupted = false
	_play_idle()


func _on_base_posture_broken(duration: float) -> void:
	_enter_posture_break(max(duration, posture_break_duration))


func _on_base_posture_meter_filled() -> void:
	_enter_posture_break(posture_break_duration)


func _enter_posture_break(duration: float) -> void:
	if _dbroken_active or has_died:
		return
	
	_hide_parry_indicator()
	
	_attack_sequence_id += 1
	
	_dbroken_active = true
	_dbreak_until = Time.get_ticks_msec() * 0.001 + duration
	_dbreak_immunity_until = Time.get_ticks_msec() * 0.001 + 0.3
	_deathblow_in_progress = false
	
	_sentinel_state = SentinelState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	
	_cleanup_hitbox()
	_set_blocking(false)
	_forward_deathblow_available(duration)
	
	if anim:
		if anim.has_animation("stunned"):
			anim.play("stunned")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		elif anim.has_animation("hurt"):
			anim.play("hurt")
	
	_emit_posture_broken(duration)


func _update_posture_break(now: float) -> void:
	if not _dbroken_active:
		return
	
	if now < _dbreak_until:
		return
	
	_dbroken_active = false
	_dbreak_until = -1.0
	_dbreak_immunity_until = -1.0
	_deathblow_in_progress = false
	
	if combat and combat.has_method("set_posture"):
		var maxv = combat.get("max_posture")
		if maxv != null:
			combat.set_posture(float(maxv) * 0.35)
		else:
			set_posture_value(0.0)
	else:
		set_posture_value(0.0)
	
	if not has_died:
		_sentinel_state = SentinelState.IDLE
		_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.1, max_attack_cooldown * 1.4)
		_play_idle()
	
	emit_signal("posture_recovered")


func is_deathblow_ready() -> bool:
	return _dbroken_active


func receive_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)


func take_deathblow(_attacker: Node) -> void:
	if has_died:
		return
	
	if not _dbroken_active:
		return
	
	if _deathblow_in_progress:
		return
	
	_deathblow_in_progress = true
	
	if combat and combat.has_method("set_posture"):
		combat.set_posture(0.0)
	
	var damage_to_deal = max(hp, 1) if deathblow_instant_kill else deathblow_damage
	apply_hp_damage(damage_to_deal)
	
	_dbroken_active = false
	_dbreak_until = -1.0
	_dbreak_immunity_until = -1.0
	emit_signal("posture_recovered")
	
	if hp <= 0:
		_deathblow_in_progress = false
		death()
		return
	
	_deathblow_in_progress = false
	stunned_until = Time.get_ticks_msec() * 0.001 + 0.65
	_sentinel_state = SentinelState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	
	if anim and anim.has_animation("deathblow"):
		anim.play("deathblow")
	elif anim and anim.has_animation("hurt"):
		anim.play("hurt")


func on_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)


# =============================================================================
# HELPERS
# =============================================================================

func _wait_interruptible(duration: float, seq_id: int) -> bool:
	var elapsed := 0.0
	
	while elapsed < duration:
		if _should_abort_attack(seq_id):
			return false
		
		await get_tree().physics_frame
		
		if not is_instance_valid(self):
			return false
		
		elapsed += get_physics_process_delta_time()
	
	return true


func _lunge_phase(dir: Vector2, distance: float, speed: float, duration: float, seq_id: int) -> bool:
	if dir == Vector2.ZERO or speed <= 0.0:
		return not _should_abort_attack(seq_id)
	
	var current_dist := _get_current_distance_to_player()
	var adjusted_distance := distance
	
	if current_dist >= 0.0:
		if current_dist < too_close_threshold:
			return not _should_abort_attack(seq_id)
		
		var needed := current_dist - ideal_combat_distance * 0.8
		
		if needed < distance:
			adjusted_distance = max(0.0, needed * 0.8)
	
	if adjusted_distance < 5.0:
		return not _should_abort_attack(seq_id)
	
	var start_pos := global_position
	var elapsed := 0.0
	var adjusted_duration := adjusted_distance / speed if speed > 0.0 else duration
	
	while elapsed < adjusted_duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return false
		
		var traveled := global_position.distance_to(start_pos)
		
		if traveled >= adjusted_distance:
			velocity = Vector2.ZERO
			break
		
		velocity = dir.normalized() * speed
		
		await get_tree().physics_frame
		
		if not is_instance_valid(self):
			return false
		
		elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	return not _should_abort_attack(seq_id)

func _apply_soft_separation() -> void:
	if has_died or _dbroken_active:
		return
	
	if _combat_phase == CombatPhase.ACTIVE:
		return
	
	if _parry_recoil_until > 0.0:
		return
	
	if not is_instance_valid(player):
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	
	if dist < min_separation and dist > 0.1:
		var push_strength := (min_separation - dist) * 4.0
		var push_dir := -to_player.normalized()
		velocity += push_dir * push_strength


func _get_current_distance_to_player() -> float:
	if not is_instance_valid(player):
		return -1.0
	
	return player.global_position.distance_to(global_position)


func _get_player_dir() -> Vector2:
	if is_instance_valid(player):
		var dir := player.global_position - global_position
		
		if dir.length_squared() > 0.001:
			return dir.normalized()
	
	return Vector2.RIGHT


func _face_direction(dir: Vector2) -> void:
	if dir == Vector2.ZERO or not sprite:
		return
	
	if abs(dir.x) < 0.2:
		return
	
	sprite.flip_h = dir.x > 0.0


func _play_idle() -> void:
	if has_died or not anim:
		return
	
	if anim.has_animation("idle") and anim.current_animation != "idle":
		anim.play("idle")


func _play_walk() -> void:
	if has_died or not anim:
		return
	
	if anim.has_animation("walk") and anim.current_animation != "walk":
		anim.play("walk")


func _is_backed_off() -> bool:
	if not has_meta("backoff_until"):
		return false
	
	var now := Time.get_ticks_msec() * 0.001
	
	if now < float(get_meta("backoff_until")):
		return true
	
	remove_meta("backoff_until")
	return false


func get_enemy_damage() -> int:
	return arc_damage


func _ai_autonomous_think(_now: float) -> void:
	if has_died or _dbroken_active:
		return
	
	if _sentinel_state == SentinelState.ATTACKING:
		return
	
	_attack_cooldown = 0.0
	_force_attack_soon = true


func _crowd_force_backoff(duration: float) -> void:
	if has_died or _dbroken_active:
		return
	
	if _sentinel_state == SentinelState.ATTACKING:
		return
	
	set_meta("backoff_until", Time.get_ticks_msec() * 0.001 + duration)
	_attack_cooldown = max(_attack_cooldown, duration * 0.5)


# =============================================================================
# DEATH
# =============================================================================

func death() -> void:
	if has_died:
		return
	
	_cleanup_hitbox()
	_release_role("melee_attack")
	
	if is_in_group("brute"):
		remove_from_group("brute")
	
	if is_in_group("court_sentinel"):
		remove_from_group("court_sentinel")
	
	_break_formation_once()
	emit_signal("defeated")
	
	super.death()


func _break_formation_once() -> void:
	if _formation_broken:
		return
	
	_formation_broken = true
	emit_signal("formation_broken")
