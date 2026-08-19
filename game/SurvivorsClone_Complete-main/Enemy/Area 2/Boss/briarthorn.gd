extends BeastEnemyBase
class_name Briarthorn

# =============================================================================
# ENUMS
# =============================================================================
enum Phase { ALIVE, DEAD }
enum BehaviorState { IDLE, REPOSITIONING, ATTACKING, EVADING, ROOTED, UNROOTING}
enum AttackType { NONE, GROUND_AOE, LINE_BEAM, TAIL_SWIPE, DOUBLE_AOE, EMPOWERED_LUNGE }
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

# =============================================================================
# MANAGER
# =============================================================================
@export var manager_path: NodePath = ""
var _manager: DuoBossManager = null

# =============================================================================
# HP
# =============================================================================
@export_group("HP")
@export var briarthorn_max_hp: int = 140

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage = 22.0
@export var deathblow_window_duration = 3.0
@export var deathblow_immunity_time = 0.3
@export var unguarded_posture_mult = 0.4

# =============================================================================
# WINDUP ARMOR
# =============================================================================
@export_group("Windup Armor")
@export var windup_posture_mult = 0.5
@export var windup_hit_flash_color = Color(0.8, 0.9, 1.0, 1.0)

# =============================================================================
# PARRY TIMING (tail swipe only)
# =============================================================================
@export_group("Parry Timing")
@export var parry_early_window = 0.12
@export var parry_linger_window = 0.18

# =============================================================================
# DISTANCE THRESHOLDS
# =============================================================================
@export_group("Distance Thresholds")
@export var preferred_min = 120.0
@export var preferred_max = 180.0
@export var close_range = 70.0
@export var far_range = 220.0

# =============================================================================
# MOVEMENT
# =============================================================================
@export_group("Movement")
@export var base_movement_speed = 50.0
@export var reposition_speed = 100.0
@export var evade_hop_speed = 400.0
@export var evade_hop_distance = 80.0
@export var min_separation = 20.0

# =============================================================================
# GROUND AOE
# =============================================================================
@export_group("Ground AOE")
@export var aoe_radius = 50.0
@export var aoe_telegraph = 0.80
@export var aoe_damage = 10
@export var aoe_offset_range = 20.0

# =============================================================================
# LINE BEAM
# =============================================================================
@export_group("Line Beam")
@export var beam_length = 250.0
@export var beam_width = 22.0
@export var beam_telegraph = 0.50
@export var beam_damage = 12
@export var beam_aim_track_pct = 0.60

# =============================================================================
# TAIL SWIPE (parryable melee)
# =============================================================================
@export_group("Tail Swipe")
@export var swipe_damage = 8
@export var swipe_range = 55.0
@export var swipe_width = 45.0
@export var swipe_telegraph = 0.30
@export var swipe_active = 0.10
@export var swipe_recovery = 0.35

# =============================================================================
# DOUBLE AOE
# =============================================================================
@export_group("Double AOE")
@export var double_aoe_spacing = 60.0

# =============================================================================
# BRIARTHORN MODE
# =============================================================================
@export_group("Briarthorn Mode")
@export var briarthorn_hp_threshold = 0.50
@export var briarthorn_entry_stumble = 0.35
@export var briarthorn_damage_reduction = 0.50
## Sweep beam
@export var sweep_beam_length = 200.0
@export var sweep_beam_width = 28.0
@export var sweep_beam_damage = 14
@export var sweep_arc_degrees = 130.0
@export var sweep_duration = 2.5
@export var sweep_count = 2
## Briarthorn multi-AOE
@export var briarthorn_aoe_count = 3
@export var briarthorn_aoe_radius = 55.0
@export var briarthorn_aoe_telegraph = 0.60
@export var briarthorn_aoe_damage = 10

@export_group("Empowered Lunge (inherited)")
@export var emp_lunge_damage = 13
@export var emp_lunge_range = 60.0
@export var emp_lunge_width = 42.0
@export var emp_lunge_telegraph = 0.45
@export var emp_lunge_active = 0.12
@export var emp_lunge_recovery = 0.40
@export var emp_lunge_distance = 80.0
@export var emp_lunge_speed = 480.0

# =============================================================================
# RAGE (when partner dies)
# =============================================================================
@export_group("Rage")
@export var rage_duration = 12.0

# =============================================================================
# ATTACK PACING
# =============================================================================
@export_group("Attack Pacing")
@export var min_attack_cooldown = 1.0
@export var max_attack_cooldown = 2.0
@export var evade_cooldown = 1.5

# =============================================================================
# STATE
# =============================================================================
var _phase = Phase.ALIVE
var _behavior_state = BehaviorState.IDLE
var _current_attack = AttackType.NONE
var _combat_phase = CombatPhase.NONE

# Briarthorn state
var _briarthorn_triggered = false
var _briarthorn_deferred = false
var _is_rooted = false
var _briarthorn_rooted = false
var _is_empowered = false

# Attack sequencing
var _attack_sequence_id = 0
var _attack_cooldown = 0.0
var _combo_interrupted = false

# Evade
var _evade_cooldown_until = 0.0

# Parry recoil
var _parry_recoil_until = 0.0
var _parry_recoil_velocity = Vector2.ZERO
var _parry_stagger_until = 0.0

# Deathblow
var _dbroken_active = false
var _dbreak_until = -1.0
var _dbreak_immunity_until = 0.0
var _deathblow_in_progress = false
var _stun_until = 0.0

# Rage
var _rage_until = 0.0
var _partner_alive = true

# Posture break flash
var _posture_break_flash_timer: Timer = null
var _posture_break_flash_on = false
var _base_modulate = Color(1, 1, 1)

# Hitbox tracking
var _current_hitbox: Area2D = null

# UI bars
var _bars_container: Node2D
var _briarthorn_posture_bg: ColorRect
var _briarthorn_posture_fill: ColorRect
var _hp_bg: ColorRect
var _hp_fill: ColorRect

# Orbit direction for lateral movement
var _lateral_dir = 1

var _rng = RandomNumberGenerator.new()

# =============================================================================
# SIGNALS
# =============================================================================
signal defeated
signal posture_broken(duration: float)
signal posture_recovered

# =============================================================================
# READY
# =============================================================================
func _ready() -> void:
	super._ready()
	
	hp = briarthorn_max_hp
	_max_hp = briarthorn_max_hp
	
	movement_speed = base_movement_speed
	beast_move_speed = base_movement_speed
	
	_phase = Phase.ALIVE
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	
	_briarthorn_triggered = false
	_briarthorn_deferred = false
	_is_rooted = false
	_briarthorn_rooted = false
	_is_empowered = false
	
	_attack_sequence_id = 0
	_attack_cooldown = 0.0
	_combo_interrupted = false
	
	_dbroken_active = false
	_dbreak_until = -1.0
	_deathblow_in_progress = false
	_stun_until = 0.0
	
	_rng.randomize()
	_lateral_dir = 1 if _rng.randf() < 0.5 else -1
	
	add_to_group("boss")
	add_to_group("duo_boss")
	add_to_group("duo_boss_twin")
	add_to_group("briarthorn")
	add_to_group("briarthorn_duo_twin")
	
	if combat and not combat.config:
		combat.config = CombatConfig.create_boss_config()
	
	_setup_bars()
	
	if combat:
		if combat.has_method("update_health_ratio"):
			combat.update_health_ratio(float(hp), float(get_max_hp()))
		
		if not combat.is_connected("posture_changed", Callable(self, "_on_posture_changed")):
			combat.connect("posture_changed", Callable(self, "_on_posture_changed"))
		
		if not combat.is_connected("posture_broken", Callable(self, "_on_posture_broken")):
			combat.connect("posture_broken", Callable(self, "_on_posture_broken"))
		
		var maxv = combat.config.posture_max if combat.config else 100.0
		combat.emit_signal("posture_changed", 0.0, maxv)
	
	if _manager == null and manager_path != NodePath(""):
		var mgr = get_node_or_null(manager_path)
		if mgr is DuoBossManager:
			_manager = mgr

# =============================================================================
# PHYSICS PROCESS
# =============================================================================
func _physics_process(delta: float) -> void:
	if _phase == Phase.DEAD:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _beast_tick_shared(delta):
		if _bars_container:
			_bars_container.global_position = global_position
		_update_bars()
		move_and_slide()
		return
	
	if _bars_container:
		_bars_container.global_position = global_position
	_update_bars()

	var now = Time.get_ticks_msec() * 0.001

	if combat:
		combat.update_health_ratio(float(hp), float(get_max_hp()))
		combat.tick(delta)

	# Deathblow window expiry
	if _dbroken_active and now >= _dbreak_until:
		_end_deathblow_window()

	# Stun
	if _stun_until > 0.0:
		if now < _stun_until:
			velocity = Vector2.ZERO
			move_and_slide()
			return
		else:
			_stun_until = 0.0

	# Posture broken
	if _dbroken_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Parry recoil
	if _parry_recoil_until > 0.0:
		if now < _parry_recoil_until:
			velocity = _parry_recoil_velocity
			move_and_slide()
			return
		else:
			_parry_recoil_until = 0.0
			_parry_recoil_velocity = Vector2.ZERO

	# --- BRIARTHORN STATE ---
	if _is_rooted:
		if _briarthorn_rooted:
			velocity = Vector2.ZERO
		move_and_slide()
		return

	# --- UNROOTING---
	if _behavior_state == BehaviorState.UNROOTING:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	_attack_cooldown = max(_attack_cooldown - delta, 0.0)

	# --- AI ---
	var player = _get_player()
	if not player:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var dir = to_player.normalized() if dist > 0.0 else Vector2.RIGHT

	match _behavior_state:
		BehaviorState.IDLE:
			_process_idle(player, dist, dir, delta)
		BehaviorState.REPOSITIONING:
			_process_repositioning(player, dist, dir, delta)
		BehaviorState.ATTACKING:
			pass  # Coroutine handles
		BehaviorState.EVADING:
			pass  # Coroutine handles

	_apply_soft_separation()
	move_and_slide()


# =============================================================================
# AI STATES
# =============================================================================
func _process_idle(player: Node2D, dist: float, dir: Vector2, delta: float) -> void:
	_face_direction(dir)

	var now = Time.get_ticks_msec() * 0.001

	# Player too close — evade
	if dist < close_range and now >= _evade_cooldown_until:
		_start_evasive_hop(dir)
		return

	# Player too far — approach
	if dist > far_range:
		_behavior_state = BehaviorState.REPOSITIONING
		return

	# In preferred band — attack or drift laterally
	if _attack_cooldown <= 0.0:
		var attack = _choose_attack(dist)
		if attack != AttackType.NONE:
			_start_attack(attack)
			return

	# Maintain distance with lateral drift
	_drift_in_band(player, dist, dir, delta)

func _process_repositioning(player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	_face_direction(dir)

	# Target the midpoint of our preferred band
	var target_dist = (preferred_min + preferred_max) * 0.5

	if dist > target_dist + 15.0:
		velocity = dir * reposition_speed
		_play_walk()
	elif dist < target_dist - 15.0:
		velocity = -dir * reposition_speed * 0.7
		_play_walk()
	else:
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		_play_idle()

func _drift_in_band(player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	var target_vel = Vector2.ZERO

	# Slight distance correction
	var mid = (preferred_min + preferred_max) * 0.5
	if dist < preferred_min - 10.0:
		target_vel += -dir * base_movement_speed * 0.6
	elif dist > preferred_max + 10.0:
		target_vel += dir * base_movement_speed * 0.6

	# Lateral movement
	var lateral = Vector2(-dir.y, dir.x) * _lateral_dir
	target_vel += lateral * base_movement_speed * 0.4

	# Occasionally flip lateral direction
	if _rng.randf() < 0.008:
		_lateral_dir *= -1

	velocity = target_vel
	if target_vel.length() > 5.0:
		_play_walk()
	else:
		_play_idle()


# =============================================================================
# EVASIVE HOP
# =============================================================================
func _start_evasive_hop(dir_to_player: Vector2) -> void:
	_behavior_state = BehaviorState.EVADING
	_evade_cooldown_until = Time.get_ticks_msec() * 0.001 + evade_cooldown
	_do_evasive_hop(dir_to_player)

func _do_evasive_hop(dir_to_player: Vector2) -> void:
	var hop_dir = -dir_to_player.normalized()
	if hop_dir == Vector2.ZERO:
		hop_dir = Vector2.RIGHT

	var hop_time = evade_hop_distance / evade_hop_speed
	var elapsed = 0.0

	if anim and anim.has_animation("hop"):
		anim.play("hop")

	while elapsed < hop_time:
		if _phase == Phase.DEAD or _dbroken_active:
			velocity = Vector2.ZERO
			_behavior_state = BehaviorState.IDLE
			return
		velocity = hop_dir * evade_hop_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()

	velocity = Vector2.ZERO
	_behavior_state = BehaviorState.IDLE

	# Immediate punish after hop if player chased
	var player = _get_player()
	if player and is_instance_valid(player):
		var d = (player.global_position - global_position).length()
		if d < close_range * 1.3:
			_start_attack(AttackType.TAIL_SWIPE)
		elif d < preferred_max:
			_attack_cooldown = min(_attack_cooldown, 0.3)

func _choose_attack(dist: float) -> AttackType:
	var weights = {}
	var enraged = _is_enraged()

	# TAIL SWIPE — close range only
	var sw = 0.0
	if dist < close_range * 1.3:
		sw = 0.50
	weights[AttackType.TAIL_SWIPE] = sw

	# GROUND AOE — works at any range, better at mid-far
	var aoe_w = 0.30
	if dist > preferred_min:
		aoe_w = 0.45
	if dist < close_range:
		aoe_w = 0.10
	if enraged:
		aoe_w *= 1.3
	weights[AttackType.GROUND_AOE] = aoe_w

	# LINE BEAM — mid range preferred
	var beam_w = 0.25
	if dist >= preferred_min and dist <= preferred_max:
		beam_w = 0.40
	if dist < close_range:
		beam_w = 0.05
	if enraged:
		beam_w *= 1.2
	weights[AttackType.LINE_BEAM] = beam_w

	# DOUBLE AOE — occasional power move
	var dbl_w = 0.08
	if enraged:
		dbl_w = 0.15
	if dist < close_range:
		dbl_w = 0.0
	weights[AttackType.DOUBLE_AOE] = dbl_w

	# EMPOWERED LUNGE (only when partner is dead)
	var lunge_w = 0.0
	if _is_empowered:
		lunge_w = 0.25
		if dist > close_range and dist <= preferred_max:
			lunge_w = 0.40
		if dist <= close_range * 0.5:
			lunge_w = 0.10
	weights[AttackType.EMPOWERED_LUNGE] = lunge_w

	# Weighted selection
	var total = 0.0
	for w in weights.values():
		total += w
	if total <= 0.0:
		return AttackType.GROUND_AOE

	var pick = _rng.randf() * total
	var acc = 0.0
	for atk in weights:
		acc += weights[atk]
		if pick <= acc and weights[atk] > 0.0:
			return atk

	return AttackType.GROUND_AOE

# =============================================================================
# ATTACK DISPATCH
# =============================================================================
func _start_attack(attack: AttackType) -> void:
	_behavior_state = BehaviorState.ATTACKING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1

	match attack:
		AttackType.GROUND_AOE:
			_do_ground_aoe()
		AttackType.LINE_BEAM:
			_do_line_beam()
		AttackType.TAIL_SWIPE:
			_do_tail_swipe()
		AttackType.DOUBLE_AOE:
			_do_double_aoe()
		AttackType.EMPOWERED_LUNGE:
			_do_empowered_lunge()

# =============================================================================
# ATTACK: EMPOWERED LUNGE (inherited from melee twin)
# =============================================================================
func _do_empowered_lunge() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	var dir = Vector2.RIGHT
	if player:
		dir = (player.global_position - global_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	_face_direction(dir)

	var total = emp_lunge_telegraph + parry_early_window + emp_lunge_active + parry_linger_window
	_show_parry_indicator(total, false)

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

	# Re-aim before charging
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

	# Charge forward
	var lunge_elapsed = 0.0
	var l_time = emp_lunge_distance / emp_lunge_speed if emp_lunge_speed > 0 else 0.0
	while lunge_elapsed < l_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_finish_attack()
			return
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
	
func _finish_attack() -> void:
	var cd_min = min_attack_cooldown
	var cd_max = max_attack_cooldown
	if _is_enraged():
		cd_min *= 0.6
		cd_max *= 0.7

	_attack_cooldown = _rng.randf_range(cd_min, cd_max)
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_behavior_state = BehaviorState.IDLE
	_cleanup_hitbox()
	_combo_interrupted = false
	_play_idle()


# =============================================================================
# ATTACK: GROUND AOE
# =============================================================================
func _do_ground_aoe() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	if not player:
		_finish_attack()
		return
	_face_direction((player.global_position - global_position).normalized())

	# Target position: player + small random offset
	var target_pos = player.global_position + Vector2(
		_rng.randf_range(-aoe_offset_range, aoe_offset_range),
		_rng.randf_range(-aoe_offset_range, aoe_offset_range)
	)

	# Spawn warning ring
	var warning = _spawn_aoe_warning(target_pos, aoe_radius, aoe_telegraph)

	if anim and anim.has_animation("cast"):
		anim.play("cast")

	# Wait for telegraph
	if not await _wait_duration_interruptible(aoe_telegraph, my_seq):
		_remove_node_safe(warning)
		return

	if _should_abort_attack(my_seq):
		_remove_node_safe(warning)
		_finish_attack()
		return

	# Detonate
	_set_combat_phase(CombatPhase.ACTIVE)
	_remove_node_safe(warning)
	_spawn_aoe_detonation(target_pos, aoe_radius, aoe_damage)

	# Brief active window
	if not await _wait_duration_interruptible(0.15, my_seq):
		return

	# Recovery
	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(0.3, my_seq):
		return

	_finish_attack()


# =============================================================================
# ATTACK: DOUBLE AOE
# =============================================================================
func _do_double_aoe() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	if not player:
		_finish_attack()
		return
	_face_direction((player.global_position - global_position).normalized())

	# Two target positions offset from player
	var perp = Vector2(-1, 1).normalized() * double_aoe_spacing * 0.5
	var target_a = player.global_position + perp + Vector2(_rng.randf_range(-10, 10), _rng.randf_range(-10, 10))
	var target_b = player.global_position - perp + Vector2(_rng.randf_range(-10, 10), _rng.randf_range(-10, 10))

	var warn_a = _spawn_aoe_warning(target_a, aoe_radius, aoe_telegraph)
	var warn_b = _spawn_aoe_warning(target_b, aoe_radius, aoe_telegraph)

	if anim and anim.has_animation("cast"):
		anim.play("cast")

	if not await _wait_duration_interruptible(aoe_telegraph, my_seq):
		_remove_node_safe(warn_a)
		_remove_node_safe(warn_b)
		return

	if _should_abort_attack(my_seq):
		_remove_node_safe(warn_a)
		_remove_node_safe(warn_b)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	_remove_node_safe(warn_a)
	_remove_node_safe(warn_b)
	_spawn_aoe_detonation(target_a, aoe_radius, aoe_damage)
	_spawn_aoe_detonation(target_b, aoe_radius, aoe_damage)

	if not await _wait_duration_interruptible(0.15, my_seq):
		return

	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(0.4, my_seq):
		return

	_finish_attack()


# =============================================================================
# ATTACK: LINE BEAM
# =============================================================================
func _do_line_beam() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	if not player:
		_finish_attack()
		return

	var dir = (player.global_position - global_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	_face_direction(dir)

	_show_parry_indicator(beam_telegraph + 0.15, true)

	# Aim line visual
	var aim_line = _spawn_aim_line(dir)

	if anim and anim.has_animation("beam_charge"):
		anim.play("beam_charge")

	# Telegraph — track player for first portion, then lock
	var tel_elapsed = 0.0
	var lock_time = beam_telegraph * beam_aim_track_pct
	while tel_elapsed < beam_telegraph:
		if _should_abort_attack(my_seq):
			_remove_node_safe(aim_line)
			_finish_attack()
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		tel_elapsed += get_physics_process_delta_time()

		if tel_elapsed < lock_time and player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT
			_face_direction(dir)
			_update_aim_line(aim_line, dir)

	# Final aim lock
	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT

	_remove_node_safe(aim_line)

	if _should_abort_attack(my_seq):
		_finish_attack()
		return

	# Fire beam
	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_beam_hitbox(dir, beam_length, beam_width, beam_damage)

	if anim and anim.has_animation("beam_fire"):
		anim.play("beam_fire")

	if not await _wait_duration_interruptible(0.15, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(0.4, my_seq):
		return

	_finish_attack()


# =============================================================================
# ATTACK: TAIL SWIPE (parryable melee)
# =============================================================================
func _do_tail_swipe() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	var dir = Vector2.RIGHT
	if player:
		dir = (player.global_position - global_position).normalized()
	if dir == Vector2.ZERO:
		dir = Vector2.RIGHT
	_face_direction(dir)

	var total = swipe_telegraph + parry_early_window + swipe_active + parry_linger_window
	_show_parry_indicator(total, false)

	if anim and anim.has_animation("swipe_antic"):
		anim.play("swipe_antic")

	if not await _wait_duration_interruptible(swipe_telegraph, my_seq):
		return

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_finish_attack()
		return

	# Re-aim
	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_melee_hitbox(dir, swipe_damage, swipe_range, swipe_width, false, false)

	if anim and anim.has_animation("swipe_active"):
		anim.play("swipe_active")

	if not await _wait_duration_interruptible(parry_early_window, my_seq):
		return
	if not await _wait_duration_interruptible(swipe_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(swipe_recovery, my_seq):
		return

	_finish_attack()


# =============================================================================
# BRIARTHORN SYSTEM
# =============================================================================
func _check_briarthorn_threshold() -> void:
	if _briarthorn_triggered or _is_rooted or _phase == Phase.DEAD or _dbroken_active:
		return
	var hp_ratio = float(hp) / float(_max_hp)
	if hp_ratio > briarthorn_hp_threshold:
		return

	_briarthorn_triggered = true

	if not _manager:
		_do_briarthorn_entry_stumble()
		return
	if _manager.request_briarthorn(self):
		_do_briarthorn_entry_stumble()
	else:
		_briarthorn_deferred = true

func trigger_deferred_briarthorn() -> void:
	if not _briarthorn_deferred or _is_rooted or _phase == Phase.DEAD:
		return
	_briarthorn_deferred = false
	_do_briarthorn_entry_stumble()

func _do_briarthorn_entry_stumble() -> void:
	_attack_sequence_id += 1
	_combo_interrupted = true
	_cleanup_hitbox()
	_combat_phase = CombatPhase.NONE
	_current_attack = AttackType.NONE
	velocity = Vector2.ZERO
	_behavior_state = BehaviorState.IDLE

	if anim and anim.has_animation("stagger"):
		anim.play("stagger")

	var elapsed = 0.0
	while elapsed < briarthorn_entry_stumble:
		if _phase == Phase.DEAD or _dbroken_active:
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()

	if _phase == Phase.DEAD or _dbroken_active:
		return
	_enter_briarthorn()

func _enter_briarthorn() -> void:
	if _is_rooted:
		return

	_attack_sequence_id += 1
	_combo_interrupted = true
	_cleanup_hitbox()
	_combat_phase = CombatPhase.NONE
	_current_attack = AttackType.NONE
	velocity = Vector2.ZERO

	_is_rooted = true
	_briarthorn_rooted = true
	_behavior_state = BehaviorState.ROOTED

	if sprite:
		sprite.modulate = Color(0.45, 0.5, 0.55, 0.95)

	if anim and anim.has_animation("briarthorn_enter"):
		anim.play("briarthorn_enter")

	_do_briarthorn_sequence()

func _exit_briarthorn() -> void:
	if not _is_rooted:
		return

	_is_rooted = false
	_briarthorn_rooted = false
	_behavior_state = BehaviorState.UNROOTING
	_cleanup_hitbox()

	if _manager:
		_manager.notify_briarthorn_ended(self)

	if sprite:
		sprite.modulate = Color(1.0, 1.0, 1.0)

	if anim and anim.has_animation("briarthorn_exit"):
		anim.play("briarthorn_exit")
	elif anim and anim.has_animation("idle"):
		anim.play("idle")

	_do_unbriarthorn_recovery()

func _do_unbriarthorn_recovery() -> void:
	var elapsed = 0.0
	var recovery_time = 0.8
	while elapsed < recovery_time:
		if _phase == Phase.DEAD or _dbroken_active:
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()

	if _phase == Phase.DEAD:
		return
	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = _rng.randf_range(min_attack_cooldown, max_attack_cooldown)
	_play_idle()


# =============================================================================
# BRIARTHORN SEQUENCE — Alternates sweeps and multi-AOEs
# =============================================================================
func _do_briarthorn_sequence() -> void:
	# Pattern: sweep → multi-aoe → sweep → done
	for i in range(sweep_count):
		if _phase == Phase.DEAD or _dbroken_active:
			break

		# Sweep beam pass
		await _do_sweep_beam()
		if not is_instance_valid(self) or _phase == Phase.DEAD or _dbroken_active:
			break

		# Brief pause
		var pause_elapsed = 0.0
		while pause_elapsed < 0.5:
			if _phase == Phase.DEAD or _dbroken_active:
				_exit_briarthorn()
				return
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			pause_elapsed += get_physics_process_delta_time()

		# Multi-AOE between sweeps (except after the last sweep)
		if i < sweep_count - 1:
			await _do_briarthorn_multi_aoe()
			if not is_instance_valid(self) or _phase == Phase.DEAD or _dbroken_active:
				break

			pause_elapsed = 0.0
			while pause_elapsed < 0.6:
				if _phase == Phase.DEAD or _dbroken_active:
					_exit_briarthorn()
					return
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
				pause_elapsed += get_physics_process_delta_time()

	_exit_briarthorn()


# =============================================================================
# BRIARTHORN: SWEEP BEAM — Rotating line beam around the twin
# =============================================================================
func _do_sweep_beam() -> void:
	if _phase == Phase.DEAD or _dbroken_active:
		return

	var player = _get_player()
	var start_dir = Vector2.RIGHT
	if player and is_instance_valid(player):
		start_dir = (player.global_position - global_position).normalized()
	if start_dir == Vector2.ZERO:
		start_dir = Vector2.RIGHT

	# Start the sweep offset to one side so it sweeps across the player
	var half_arc = deg_to_rad(sweep_arc_degrees * 0.5)
	var start_angle = start_dir.angle() - half_arc
	var end_angle = start_dir.angle() + half_arc

	# Randomize sweep direction
	if _rng.randf() < 0.5:
		var tmp = start_angle
		start_angle = end_angle
		end_angle = tmp

	# Create pivot + beam visual/hitbox
	var pivot = Node2D.new()
	pivot.global_position = global_position
	get_parent().add_child(pivot)

	var beam_area = Area2D.new()
	beam_area.add_to_group("attack")
	beam_area.collision_layer = 2
	beam_area.collision_mask = 4
	beam_area.set_meta("damage", sweep_beam_damage)
	beam_area.set_meta("attacker", self)
	beam_area.set_meta("damage_type", "unblockable")
	beam_area.set_meta("parryable", false)
	beam_area.set_meta("unblockable", true)
	beam_area.set_meta("telegraphed", true)

	var col = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(sweep_beam_length, sweep_beam_width)
	col.shape = rect
	beam_area.add_child(col)
	beam_area.position = Vector2(sweep_beam_length * 0.5, 0)
	pivot.add_child(beam_area)

	# Beam visual
	var beam_visual = ColorRect.new()
	beam_visual.size = Vector2(sweep_beam_length, sweep_beam_width)
	beam_visual.position = Vector2(0, -sweep_beam_width * 0.5)
	beam_visual.color = Color(0.9, 0.4, 0.15, 0.6)
	beam_area.add_child(beam_visual)

	pivot.rotation = start_angle

	_show_parry_indicator(sweep_duration, true)

	# Sweep
	var sweep_elapsed = 0.0
	var total_angle = end_angle - start_angle
	var rotation_speed = total_angle / sweep_duration

	while sweep_elapsed < sweep_duration:
		if _phase == Phase.DEAD or _dbroken_active:
			break
		pivot.global_position = global_position
		pivot.rotation = start_angle + rotation_speed * sweep_elapsed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			_remove_node_safe(pivot)
			return
		sweep_elapsed += get_physics_process_delta_time()

	_remove_node_safe(pivot)


# =============================================================================
# BRIARTHORN: MULTI-AOE — Multiple simultaneous ground zones
# =============================================================================
func _do_briarthorn_multi_aoe() -> void:
	if _phase == Phase.DEAD or _dbroken_active:
		return

	var player = _get_player()
	if not player:
		return

	var warnings = []
	var targets = []

	for i in range(briarthorn_aoe_count):
		var offset = Vector2(
			_rng.randf_range(-80, 80),
			_rng.randf_range(-80, 80)
		)
		var target = player.global_position + offset
		targets.append(target)
		var w = _spawn_aoe_warning(target, briarthorn_aoe_radius, briarthorn_aoe_telegraph)
		warnings.append(w)

	# Wait for telegraph
	var tel_elapsed = 0.0
	while tel_elapsed < briarthorn_aoe_telegraph:
		if _phase == Phase.DEAD or _dbroken_active:
			for w in warnings:
				_remove_node_safe(w)
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		tel_elapsed += get_physics_process_delta_time()

	# Detonate all
	for i in range(targets.size()):
		if i < warnings.size():
			_remove_node_safe(warnings[i])
		_spawn_aoe_detonation(targets[i], briarthorn_aoe_radius, briarthorn_aoe_damage)


# =============================================================================
# SPAWNERS — AOE, BEAM, MELEE
# =============================================================================
func _spawn_aoe_warning(center: Vector2, radius: float, duration: float) -> Node2D:
	var container = Node2D.new()
	container.global_position = center
	container.z_index = -1

	# Filled danger zone
	var fill = Polygon2D.new()
	var points = PackedVector2Array()
	var seg = 24
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * radius)
	fill.polygon = points
	fill.color = Color(1.0, 0.2, 0.1, 0.15)
	container.add_child(fill)

	# Outer ring
	var ring = Line2D.new()
	ring.width = 2.0
	ring.default_color = Color(1.0, 0.3, 0.1, 0.7)
	var ring_pts = PackedVector2Array()
	for s in range(seg + 1):
		var angle = float(s) / float(seg) * TAU
		ring_pts.append(Vector2(cos(angle), sin(angle)) * radius)
	ring.points = ring_pts
	container.add_child(ring)

	get_parent().add_child(container)

	# Pulse the fill opacity to signal approaching detonation
	var tw = get_tree().create_tween()
	tw.tween_property(fill, "color:a", 0.45, duration * 0.8)

	return container

func _spawn_aoe_detonation(center: Vector2, radius: float, damage: int) -> void:
	var area = Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	col.shape = shape
	area.add_child(col)
	area.global_position = center
	get_parent().add_child(area)

	# Flash visual
	var flash = Polygon2D.new()
	var pts = PackedVector2Array()
	var seg = 24
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * radius)
	flash.polygon = pts
	flash.color = Color(1.0, 0.5, 0.2, 0.6)
	area.add_child(flash)

	# Deferred overlap check
	area.set_deferred("monitoring", true)
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(area):
			for body in area.get_overlapping_bodies():
				area.body_entered.emit(body)
			for a in area.get_overlapping_areas():
				area.area_entered.emit(a)
	)

	# Cleanup
	get_tree().create_timer(0.2).timeout.connect(func():
		if is_instance_valid(area):
			area.queue_free()
	)

func _spawn_beam_hitbox(dir: Vector2, length: float, width: float, damage: int) -> void:
	var area = Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width)
	col.shape = rect
	area.add_child(col)

	area.global_position = global_position + dir * (length * 0.5)
	area.rotation = dir.angle()
	get_parent().add_child(area)
	_current_hitbox = area

	# Visual
	var vis = ColorRect.new()
	vis.size = Vector2(length, width)
	vis.position = Vector2(-length * 0.5, -width * 0.5)
	vis.color = Color(0.95, 0.6, 0.2, 0.7)
	area.add_child(vis)

	# Deferred overlap
	area.set_deferred("monitoring", true)
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(area):
			for body in area.get_overlapping_bodies():
				area.body_entered.emit(body)
			for a in area.get_overlapping_areas():
				area.area_entered.emit(a)
	)

func _spawn_melee_hitbox(dir: Vector2, damage: int, range_dist: float, width: float, parry_only: bool, unblockable: bool) -> Area2D:
	var hitbox = Area2D.new()
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("telegraphed", true)

	if unblockable:
		hitbox.set_meta("damage_type", "unblockable")
		hitbox.set_meta("parryable", false)
		hitbox.set_meta("unblockable", true)
	else:
		hitbox.set_meta("damage_type", "briarthorn_melee")
		hitbox.set_meta("parryable", true)
		hitbox.set_meta("unblockable", false)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(range_dist, width)
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (range_dist * 0.5)
	hitbox.rotation = dir.angle()
	return hitbox

func _spawn_aim_line(dir: Vector2) -> Line2D:
	var line = Line2D.new()
	line.width = 3.0
	line.default_color = Color(1.0, 0.4, 0.15, 0.5)
	line.z_index = 50
	line.add_point(Vector2.ZERO)
	line.add_point(dir * beam_length)
	add_child(line)
	return line

func _update_aim_line(line: Line2D, dir: Vector2) -> void:
	if not is_instance_valid(line):
		return
	if line.get_point_count() >= 2:
		line.set_point_position(1, dir * beam_length)

func _cleanup_hitbox() -> void:
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
		_current_hitbox.queue_free()
	
	_current_hitbox = null

# =============================================================================
# DAMAGE HANDLING
# =============================================================================
func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _phase == Phase.DEAD or damage <= 0 or attacker == null:
		return

	var is_player_attack = attacker.is_in_group("player")
	if not is_player_attack and attacker is Area2D:
		if attacker.has_meta("attacker"):
			var meta_att = attacker.get_meta("attacker")
			if meta_att is Node and meta_att.is_in_group("player"):
				is_player_attack = true
	if not is_player_attack and attacker.is_in_group("attack"):
		var owner_check = attacker.get_parent()
		while owner_check != null:
			if owner_check.is_in_group("player"):
				is_player_attack = true
				break
			if owner_check.is_in_group("enemy"):
				break
			owner_check = owner_check.get_parent()
	if not is_player_attack:
		return

	# Briarthorn armor while rooted
	if _is_rooted and _briarthorn_rooted:
		var reduced = int(round(float(damage) * (1.0 - briarthorn_damage_reduction)))
		if combat:
			var orig = combat.config.hit_posture_gain if combat.config else 12.0
			if combat.config:
				combat.config.hit_posture_gain = orig * (1.0 - briarthorn_damage_reduction)
			combat.notify_got_hit({"damage": reduced, "blocked": true})
			if combat.config:
				combat.config.hit_posture_gain = orig
		if attacker is Area2D and attacker.has_meta("prosthetic_source"):
			ProstheticEffects.apply(attacker, self, true)
		if reduced > 0:
			hp = max(hp - reduced, 1)
			_update_bars()
		_flash_block()
		return

	# Ranged twin has no passive guard — all unrooted hits deal full damage
	var posture_mult = unguarded_posture_mult
	if _is_in_windup():
		posture_mult *= windup_posture_mult
		_flash_windup_hit()

	if combat:
		var orig = combat.config.hit_posture_gain if combat.config else 12.0
		if combat.config:
			combat.config.hit_posture_gain = orig * posture_mult
		combat.notify_got_hit({"damage": damage, "blocked": false})
		if combat.config:
			combat.config.hit_posture_gain = orig

	if attacker is Area2D and attacker.has_meta("prosthetic_source"):
		ProstheticEffects.apply(attacker, self, false)

	var se_node = get_node_or_null("/root/StanceEffects")
	if se_node and se_node.has_method("on_enemy_hit"):
		se_node.on_enemy_hit(attacker, self, false)

	_apply_hp_damage(damage)

func _apply_hp_damage(damage: int) -> void:
	if _phase == Phase.DEAD:
		return
	
	hp = max(hp - damage, 0)
	_update_bars()
	
	if hp <= 0:
		_die()
		return
	
	_flash_hurt_sprite()
	_check_briarthorn_threshold()

# =============================================================================
# PARRY HANDLING (tail swipe only)
# =============================================================================
func on_parried(parry_source_pos: Vector2) -> void:
	if _dbroken_active or _phase == Phase.DEAD:
		return
	_hide_parry_indicator()

	if combat and combat.config:
		var current = combat.get_posture()
		var maxv = combat.config.posture_max
		combat.set_posture(min(current + parry_posture_damage, maxv))
		combat.notify_got_hit({"damage": 0, "parried": true})
		combat.suppress_recovery(1.0)

	_cleanup_hitbox()

	# Full stagger on parry (ranged twin has no combo parry)
	_combo_interrupted = true
	_attack_sequence_id += 1

	var player = _get_player()
	var source = parry_source_pos
	if player:
		source = player.global_position
	var away = (global_position - source).normalized()
	if away == Vector2.ZERO:
		away = Vector2.RIGHT

	_parry_recoil_velocity = away * 110.0
	var now = Time.get_ticks_msec() * 0.001
	_parry_recoil_until = now + 0.20
	_parry_stagger_until = now + 0.20

	if anim:
		if anim.has_animation("parried"):
			anim.play("parried")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
	_parry_flash_tint()

	await get_tree().create_timer(0.25).timeout
	if not is_instance_valid(self):
		return

	_parry_recoil_until = 0.0
	_parry_recoil_velocity = Vector2.ZERO
	_parry_stagger_until = 0.0
	velocity = Vector2.ZERO

	if _dbroken_active or _phase == Phase.DEAD:
		return

	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.2, max_attack_cooldown * 1.5)
	_combo_interrupted = false
	_play_idle()


# =============================================================================
# POSTURE / DEATHBLOW PIPELINE
# =============================================================================
func _on_posture_changed(current: float, max_value: float) -> void:
	_update_posture_bar(current, max_value)

func _on_posture_broken(duration: float) -> void:
	if _dbroken_active or _phase == Phase.DEAD:
		return
	_hide_parry_indicator()

	var window = duration
	if window <= 0.0:
		window = deathblow_window_duration

	_attack_sequence_id += 1

	if _is_rooted:
		_is_rooted = false
		_briarthorn_rooted = false
		_cleanup_hitbox()
		if _manager:
			_manager.notify_briarthorn_ended(self)

	_trigger_posture_break(window)

	var now = Time.get_ticks_msec() * 0.001
	_dbroken_active = true
	_dbreak_until = now + window
	_dbreak_immunity_until = now + deathblow_immunity_time
	_deathblow_in_progress = false

	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	_cleanup_hitbox()

	if anim:
		if anim.has_animation("stunned"):
			anim.play("stunned")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		else:
			anim.play("idle")

	_start_posture_break_flash()
	emit_signal("posture_broken", window)

func _trigger_posture_break(duration: float) -> void:
	var player = _get_player()
	if player:
		var pc = player.get_node_or_null("Combat")
		if pc and pc.has_method("set_deathblow_target"):
			pc.set_deathblow_target(self, duration)
		elif pc and pc.has_signal("deathblow_available"):
			pc.emit_signal("deathblow_available", self, duration)

func _end_deathblow_window() -> void:
	if not _dbroken_active:
		return
	_clear_deathblow_state()
	_deathblow_in_progress = false

	if combat and combat.config:
		combat.set_posture(combat.config.posture_max * 0.35)
	elif combat:
		combat.set_posture(0.0)

	if _phase != Phase.DEAD:
		_behavior_state = BehaviorState.IDLE
		_attack_cooldown = _rng.randf_range(min_attack_cooldown, max_attack_cooldown)
		_play_idle()
	emit_signal("posture_recovered")

func _clear_deathblow_state() -> void:
	_dbroken_active = false
	_dbreak_until = -1.0
	_dbreak_immunity_until = -1.0
	_stop_posture_break_flash()

func take_deathblow(attacker: Node) -> void:
	if _phase == Phase.DEAD or not _dbroken_active or _deathblow_in_progress:
		return
	_deathblow_in_progress = true

	if combat and combat.config:
		combat.set_posture(0.0)
	_clear_deathblow_state()

	if anim and anim.has_animation("deathblow"):
		anim.play("deathblow")
	elif anim and anim.has_animation("hurt"):
		anim.play("hurt")

	var original_mod = sprite.modulate if sprite else Color.WHITE
	if sprite:
		sprite.modulate = Color(1.0, 0.6, 0.3)
	await get_tree().create_timer(0.3).timeout
	if not is_instance_valid(self):
		return
	if sprite:
		sprite.modulate = original_mod

	_deathblow_in_progress = false
	emit_signal("posture_recovered")
	_die()

func on_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func receive_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func is_deathblow_ready() -> bool:
	return _dbroken_active


# =============================================================================
# DEATH
# =============================================================================
func death() -> void:
	_die()


func _die(_attacker: Node = null) -> void:
	if _phase == Phase.DEAD:
		return
	
	if not mark_dead():
		return
	
	_hide_parry_indicator()
	
	_phase = Phase.DEAD
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_is_rooted = false
	_briarthorn_rooted = false
	velocity = Vector2.ZERO
	_attack_sequence_id += 1
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if _bars_container:
		_bars_container.visible = false
	
	_cleanup_hitbox()
	_reset_beast_runtime()
	
	if is_in_group("boss"):
		remove_from_group("boss")
	
	if is_in_group("duo_boss"):
		remove_from_group("duo_boss")
	
	if is_in_group("briarthorn"):
		remove_from_group("briarthorn")
	
	if is_in_group("briarthorn_duo_twin"):
		remove_from_group("briarthorn_duo_twin")
	
	if _manager:
		_manager.notify_died(self)
	
	emit_signal("defeated")
	emit_signal("enemy_died", self)
	
	award_area_gold_drop()
	notify_stance_effects_enemy_death()
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		var start_time = Time.get_ticks_msec() * 0.001
		
		while anim.is_playing() and (Time.get_ticks_msec() * 0.001 - start_time) < 4.0:
			await get_tree().process_frame
	else:
		await get_tree().create_timer(0.5).timeout
	
	if not is_instance_valid(self):
		return
	
	if sprite:
		sprite.visible = false
	
	queue_free()

# =============================================================================
# MANAGER INTERFACE
# =============================================================================
func set_manager(mgr: DuoBossManager) -> void:
	_manager = mgr

func on_partner_died() -> void:
	_partner_alive = false
	if _is_rooted:
		_briarthorn_rooted = false
		_cleanup_hitbox()
		velocity = Vector2.ZERO
		_exit_briarthorn()

	var now = Time.get_ticks_msec() * 0.001
	_rage_until = now + rage_duration

	# Empowered — gains lunge + stat boosts
	_is_empowered = true

	# Stat boosts: faster cadence, slightly bigger zones, more willing to fight close
	aoe_telegraph *= 0.80
	beam_telegraph *= 0.80
	swipe_telegraph *= 0.85
	swipe_recovery *= 0.80
	aoe_damage = int(aoe_damage * 1.15)
	beam_damage = int(beam_damage * 1.15)
	swipe_damage = int(swipe_damage * 1.15)
	min_attack_cooldown *= 0.65
	max_attack_cooldown *= 0.70
	reposition_speed *= 1.20
	# Shrink preferred distance band — more aggressive positioning
	preferred_min *= 0.80
	preferred_max *= 0.85

	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = 0.0

func _is_enraged() -> bool:
	return Time.get_ticks_msec() * 0.001 < _rage_until

func is_dead() -> bool:
	return _phase == Phase.DEAD

func get_enemy_damage() -> int:
	return swipe_damage

func get_enemy_tags() -> Array:
	return ["beast", "briarthorn", "duo_boss"]


# =============================================================================
# COROUTINE HELPERS
# =============================================================================
func _should_abort_attack(sequence_id: int) -> bool:
	if _phase == Phase.DEAD:
		return true
	if _dbroken_active:
		return true
	if _is_rooted:
		return true
	if _combo_interrupted:
		return true
	if sequence_id != _attack_sequence_id:
		return true
	return false

func _wait_duration_interruptible(duration: float, seq_id: int) -> bool:
	var elapsed = 0.0
	while elapsed < duration:
		if _should_abort_attack(seq_id):
			return false
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false
		elapsed += get_physics_process_delta_time()
	return true

func _set_combat_phase(phase: CombatPhase) -> void:
	_combat_phase = phase

func _is_in_windup() -> bool:
	return _combat_phase == CombatPhase.WINDUP


# =============================================================================
# MOVEMENT / VISUAL HELPERS
# =============================================================================
func _get_player() -> Node:
	var p = get_tree().get_first_node_in_group("player")
	if p and p is Node2D:
		return p
	return null

func _face_direction(dir: Vector2) -> void:
	if dir == Vector2.ZERO or not sprite:
		return
	if abs(dir.x) < 0.2:
		return
	sprite.flip_h = dir.x > 0.0

func _play_idle() -> void:
	if _phase == Phase.DEAD or not anim:
		return
	if anim.has_animation("idle") and anim.current_animation != "idle":
		anim.play("idle")

func _play_walk() -> void:
	if _phase == Phase.DEAD or not anim:
		return
	if anim.has_animation("walk") and anim.current_animation != "walk":
		anim.play("walk")

func _update_sprite_facing() -> void:
	var player = _get_player()
	if player and sprite:
		sprite.flip_h = player.global_position.x > global_position.x

func _apply_soft_separation() -> void:
	if _phase == Phase.DEAD or _dbroken_active or _is_rooted:
		return
	if _combat_phase == CombatPhase.ACTIVE:
		return

	var player = _get_player()
	if not player:
		return
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	if dist < min_separation and dist > 0.1:
		var push = -to_player.normalized() * (min_separation - dist) * 4.0
		velocity += push

	if _manager:
		var partner = _manager.get_partner(self)
		if partner and is_instance_valid(partner) and not partner.is_dead():
			var to_p = partner.global_position - global_position
			var pd = to_p.length()
			if pd < min_separation * 1.5 and pd > 0.1:
				velocity += -to_p.normalized() * (min_separation * 1.5 - pd) * 3.0

func _remove_node_safe(node: Node) -> void:
	if node != null and is_instance_valid(node):
		node.queue_free()


# =============================================================================
# VISUAL HELPERS
# =============================================================================
func _flash_windup_hit() -> void:
	if not sprite:
		return
	var orig = sprite.modulate
	sprite.modulate = windup_hit_flash_color
	await get_tree().create_timer(0.04).timeout
	if is_instance_valid(sprite):
		sprite.modulate = orig

func _flash_hurt_sprite() -> void:
	if not sprite:
		return
	
	var orig = sprite.modulate
	sprite.modulate = Color(1, 0.4, 0.4)
	
	await get_tree().create_timer(0.08).timeout
	
	if is_instance_valid(sprite):
		sprite.modulate = orig

func _flash_block() -> void:
	if not sprite:
		return
	var orig = sprite.modulate
	sprite.modulate = Color(0.7, 0.85, 1.0)
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(sprite):
		sprite.modulate = orig

func _parry_flash_tint() -> void:
	if not sprite:
		return
	var orig = sprite.modulate
	sprite.modulate = Color(1.0, 1.0, 1.5)
	await get_tree().create_timer(0.10).timeout
	if is_instance_valid(sprite):
		sprite.modulate = orig

func _start_posture_break_flash() -> void:
	if not sprite:
		return
	_base_modulate = sprite.modulate
	if _posture_break_flash_timer == null:
		_posture_break_flash_timer = Timer.new()
		_posture_break_flash_timer.name = "PostureBreakFlash"
		_posture_break_flash_timer.one_shot = false
		_posture_break_flash_timer.wait_time = 0.12
		add_child(_posture_break_flash_timer)
		_posture_break_flash_timer.timeout.connect(Callable(self, "_on_posture_break_flash_tick"))
	elif not _posture_break_flash_timer.timeout.is_connected(Callable(self, "_on_posture_break_flash_tick")):
		_posture_break_flash_timer.timeout.connect(Callable(self, "_on_posture_break_flash_tick"))
	_posture_break_flash_on = false
	_posture_break_flash_timer.start()
	sprite.modulate = Color(1.0, 0.35, 0.35)

func _on_posture_break_flash_tick() -> void:
	if not _dbroken_active or _phase == Phase.DEAD:
		_stop_posture_break_flash()
		return
	if not sprite:
		return
	if _posture_break_flash_on:
		sprite.modulate = _base_modulate
	else:
		sprite.modulate = Color(1.0, 0.35, 0.35)
	_posture_break_flash_on = not _posture_break_flash_on

func _stop_posture_break_flash() -> void:
	if _posture_break_flash_timer:
		_posture_break_flash_timer.stop()
	_posture_break_flash_on = false
	if sprite:
		sprite.modulate = _base_modulate


# =============================================================================
# UI BARS
# =============================================================================
func _setup_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsUI"
	_bars_container.z_index = 100
	add_child(_bars_container)

	_briarthorn_posture_bg = ColorRect.new()
	_briarthorn_posture_bg.size = Vector2(54, 6)
	_briarthorn_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	_briarthorn_posture_bg.position = Vector2(-27, -55)
	_bars_container.add_child(_briarthorn_posture_bg)

	_briarthorn_posture_fill = ColorRect.new()
	_briarthorn_posture_fill.size = Vector2(0, 6)
	_briarthorn_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	_briarthorn_posture_fill.position = Vector2.ZERO
	_briarthorn_posture_bg.add_child(_briarthorn_posture_fill)

	var posture_border = ColorRect.new()
	posture_border.size = Vector2(56, 8)
	posture_border.color = Color(0.3, 0.25, 0.1, 0.9)
	posture_border.position = Vector2(-28, -56)
	posture_border.z_index = -1
	_bars_container.add_child(posture_border)

	_hp_bg = ColorRect.new()
	_hp_bg.size = Vector2(54, 5)
	_hp_bg.color = Color(0.15, 0.02, 0.02, 0.8)
	_hp_bg.position = Vector2(-27, -46)
	_bars_container.add_child(_hp_bg)
	_hp_fill = ColorRect.new()
	_hp_fill.size = Vector2(54, 5)
	_hp_fill.color = Color(0.85, 0.15, 0.1, 0.95)
	_hp_fill.position = Vector2.ZERO
	_hp_bg.add_child(_hp_fill)

	var hp_border = ColorRect.new()
	hp_border.size = Vector2(56, 7)
	hp_border.color = Color(0.25, 0.08, 0.08, 0.9)
	hp_border.position = Vector2(-28, -47)
	hp_border.z_index = -1
	_bars_container.add_child(hp_border)

	_bars_container.visible = true

func _update_bars() -> void:
	if _hp_fill:
		var hp_pct = clamp(float(hp) / float(get_max_hp()), 0.0, 1.0)
		_hp_fill.size.x = 54.0 * hp_pct
		if hp_pct >= 0.5:
			_hp_fill.color = Color(0.85, 0.15, 0.1, 0.95)
		elif hp_pct >= 0.25:
			_hp_fill.color = Color(0.9, 0.3, 0.1, 0.95)
		else:
			var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.008)
			_hp_fill.color = Color(1.0, 0.2 * flash, 0.1 * flash, 0.95)

	if _is_rooted and _bars_container:
		_bars_container.modulate = Color(0.6, 0.6, 0.6, 0.7)
	elif _bars_container:
		_bars_container.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _update_posture_bar(cur: float, maxv: float) -> void:
	if not _briarthorn_posture_fill or not _briarthorn_posture_bg:
		return
	
	var pct = clamp(cur / max(0.001, maxv), 0.0, 1.0)
	_briarthorn_posture_fill.size.x = 54.0 * pct
	
	var hp_ratio = clamp(float(hp) / float(get_max_hp()), 0.0, 1.0)
	
	if hp_ratio >= 0.75:
		_briarthorn_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	elif hp_ratio >= 0.50:
		_briarthorn_posture_fill.color = Color(1.0, 0.6, 0.1, 0.95)
	elif hp_ratio >= 0.25:
		_briarthorn_posture_fill.color = Color(1.0, 0.4, 0.1, 0.95)
	else:
		var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.01)
		_briarthorn_posture_fill.color = Color(1.0, 0.25 * flash, 0.1, 0.95)
	
	if pct >= 0.85:
		var break_flash = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.015)
		_briarthorn_posture_fill.color.a = break_flash
