extends HumanoidEnemyBase
class_name Keeper

signal defeated
signal phase_changed(new_phase: int)
signal posture_broken(duration: float)
signal posture_recovered

# =============================================================================
# STATS
# =============================================================================
@export var keeper_max_hp: int = 350
@export var base_movement_speed = 55.0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage = 30.0
@export var deathblow_window_duration = 3.5
@export var deathblow_damage = 120
@export var deathblow_immunity_time = 0.3

# =============================================================================
# WINDUP ARMOR
# =============================================================================
@export_group("Windup Armor")
@export var windup_damage_mult = 0.6
@export var windup_posture_mult = 0.5

# =============================================================================
# PARRY TIMING
# =============================================================================
@export_group("Parry Timing")
@export var parry_early_window = 0.10
@export var parry_linger_window = 0.18
@export var parry_hitstop_duration = 0.10

# =============================================================================
# DISTANCE THRESHOLDS
# =============================================================================
@export_group("Distance")
@export var close_range = 90.0
@export var mid_range = 180.0
@export var far_range = 280.0
@export var ideal_combat_distance = 75.0
@export var too_close_threshold = 35.0
@export var lunge_min_distance = 25.0

# =============================================================================
# SEKIRO-STYLE SPACING & RHYTHM
# =============================================================================
@export_group("Combat Polish")
## Boss backs off after completing a combo to maintain spacing
@export var post_combo_backstep_chance = 0.55
@export var backstep_distance = 45.0
@export var backstep_speed = 150.0
@export var backstep_duration = 0.25
## Maximum distance a lunge can close (prevents teleporting to player)
@export var max_lunge_close_distance = 55.0
## Minimum time between attacks (rhythm breathing room)
@export var min_rhythm_gap = 0.35
## Distance at which boss will circle instead of approach
@export var circling_distance = 65.0
## How aggressively boss maintains ideal distance (0-1)
@export var spacing_aggression = 0.35

# =============================================================================
# ATTACK VARIETY SYSTEM (v4.5) - Prevents spam, forces variety
# =============================================================================
@export_group("Attack Variety")
## How many recent attacks to track for penalty weighting
@export var attack_history_size = 4
## Weight penalty multiplier for recently used attacks (0.0 = full penalty, 1.0 = no penalty)
@export var repeat_attack_penalty = 0.15
## After this many consecutive close-range attacks, force spacing
@export var max_consecutive_close_attacks = 3
## Per-attack minimum cooldown (seconds) before same attack can be chosen again
@export var per_attack_cooldown = 2.5
## Chance to force a spacing attack when close-range spam detected
@export var forced_spacing_chance = 0.85

# =============================================================================
# PHASE 1: KEEPER BLADE DANCE (4-hit combo)
# =============================================================================
@export_group("Keeper Blade Dance")
@export var blade_dance_windup = 0.40
@export var blade_dance_hit1_anticipation = 0.30
@export var blade_dance_hit1_active = 0.12
@export var blade_dance_hit1_recovery = 0.22
@export var blade_dance_hit2_anticipation = 0.26
@export var blade_dance_hit2_active = 0.12
@export var blade_dance_hit2_recovery = 0.20
@export var blade_dance_hit3_anticipation = 0.45  # DELAYED
@export var blade_dance_hit3_active = 0.15
@export var blade_dance_hit3_recovery = 0.18
@export var blade_dance_hit4_anticipation = 0.28
@export var blade_dance_hit4_active = 0.14
@export var blade_dance_hit4_recovery = 0.55
@export var blade_dance_damage = 12
@export var blade_dance_lunge_distance = 35.0
@export var blade_dance_lunge_speed = 180.0
@export var blade_dance_arc_width = 70.0
@export var blade_dance_arc_length = 75.0

# =============================================================================
# PHASE 1: EMBER OVERHEAD - v4.6 FIX: Increased windup for better reaction time
# =============================================================================
@export_group("Ember Overhead")
## Windup time before the hit (v4.6: increased from 0.70 to 0.90 for better reaction)
@export var overhead_windup = 0.90
@export var overhead_active = 0.14
@export var overhead_recovery = 0.30
@export var overhead_damage = 18
@export var overhead_arc_length = 80.0
@export var overhead_arc_width = 55.0
@export var overhead_branch_distance = 100.0
## Delay before branching to perilous attack (gives player reaction time)
@export var overhead_branch_delay = 0.45

# =============================================================================
# PHASE 1: PERILOUS THRUST - v4.8 FIX: Distance cap + longer telegraph
# =============================================================================
@export_group("Perilous Thrust")
## Telegraph time for red indicator BEFORE the thrust (v4.8: increased for dodge window)
@export var thrust_telegraph_time = 0.70
@export var thrust_dash_speed = 380.0
@export var thrust_dash_duration = 0.28
@export var thrust_damage = 22
@export var thrust_lane_width = 50.0
@export var thrust_lane_length = 200.0
## v4.8: Maximum distance the thrust can travel (prevents crossing entire arena)
@export var thrust_max_distance = 140.0

# =============================================================================
# PHASE 1: PERILOUS SWEEP
# =============================================================================
@export_group("Perilous Sweep")
## Telegraph time for red indicator BEFORE the sweep (increased for readability)
@export var sweep_telegraph_time = 0.48
@export var sweep_active = 0.18
@export var sweep_damage = 20
@export var sweep_inner_radius = 30.0
@export var sweep_outer_radius = 100.0
@export var sweep_arc_degrees = 270.0

# =============================================================================
# PHASE 1: IAIJUTSU DRAW
# =============================================================================
@export_group("Iaijutsu Draw")
@export var iaijutsu_windup = 0.55
@export var iaijutsu_dash_speed = 350.0
@export var iaijutsu_dash_duration = 0.22
@export var iaijutsu_hit1_active = 0.10
@export var iaijutsu_hit1_recovery = 0.25
@export var iaijutsu_hit2_anticipation = 0.20
@export var iaijutsu_hit2_active = 0.14
@export var iaijutsu_hit2_recovery = 0.50
@export var iaijutsu_damage = 14
@export var iaijutsu_arc_length = 85.0
@export var iaijutsu_arc_width = 60.0

# =============================================================================
# PHASE 1: DISCIPLINE CUT
# =============================================================================
@export_group("Discipline Cut")
@export var discipline_windup = 0.28
@export var discipline_active = 0.10
@export var discipline_recovery = 0.35
@export var discipline_damage = 10
@export var discipline_arc_length = 70.0
@export var discipline_arc_width = 45.0
@export var discipline_lunge_distance = 25.0
@export var discipline_lunge_speed = 200.0

# =============================================================================
# PHASE 2: FERAL ONSLAUGHT
# =============================================================================
@export_group("Feral Onslaught")
@export var feral_windup = 0.35
@export var feral_hit1_anticipation = 0.28
@export var feral_hit2_anticipation = 0.22
@export var feral_hit3_anticipation = 0.24
@export var feral_hit4_anticipation = 0.22
@export var feral_hit5_anticipation = 0.20
@export var feral_active_time = 0.12
@export var feral_inter_hit_recovery = 0.12
@export var feral_final_recovery = 0.70
@export var feral_damage = 14
@export var feral_advance_distance = 40.0
@export var feral_advance_speed = 200.0
@export var feral_arc_length = 80.0
@export var feral_arc_width = 75.0

# =============================================================================
# PHASE 2: SAVAGE SWEEP - v5.0: Fixed indicator visual
# =============================================================================
@export_group("Savage Sweep")
## v4.7 FIX: Increased from 0.38 to 0.58 for better player reaction time
@export var savage_telegraph_time = 0.58
@export var savage_active = 0.20
@export var savage_recovery = 0.45
@export var savage_damage = 24
@export var savage_radius = 95.0

# =============================================================================
# PHASE 2: LEAPING SLAM - v4.5 FIX: Increased telegraph time
# =============================================================================
@export_group("Leaping Slam")
## Crouch telegraph time BEFORE leap (v4.5: increased from 0.40 to 0.70)
@export var slam_crouch_time = 0.70
@export var slam_air_time = 0.50
## Delay after landing before damage hitbox appears (v4.5: added for reaction time)
@export var slam_landing_delay = 0.25
@export var slam_impact_active = 0.15
@export var slam_recovery = 0.55
@export var slam_damage = 28
@export var slam_target_radius = 60.0
@export var slam_shockwave_radius = 120.0
@export var slam_shockwave_expand_time = 0.25

# =============================================================================
# PHASE 2: BLOODIED LUNGE - v4.8 FIX: Distance cap + longer telegraph
# =============================================================================
@export_group("Bloodied Lunge")
## v4.8: Increased telegraph time (0.30 → 0.65) for proper dodge window
@export var lunge_telegraph_time = 0.65
@export var lunge_dash_speed = 420.0
@export var lunge_dash_duration = 0.35
@export var lunge_recovery = 0.60
@export var lunge_damage = 22
@export var lunge_lane_width = 55.0
@export var lunge_lane_length = 250.0
## v4.8: Maximum distance the lunge can travel (prevents crossing entire arena)
@export var lunge_max_distance = 160.0

# =============================================================================
# ATTACK PACING
# =============================================================================
@export_group("Pacing")
@export var phase1_min_cooldown = 0.8
@export var phase1_max_cooldown = 1.4
@export var phase2_min_cooldown = 0.5
@export var phase2_max_cooldown = 1.0

# =============================================================================
# STATE MACHINE
# =============================================================================
enum BossPhase { PHASE_1, PHASE_2, DEAD }
enum BehaviorState { IDLE, PURSUING, ATTACKING, STAGGERED, TRANSITIONING }
enum AttackType { 
	NONE, BLADE_DANCE, EMBER_OVERHEAD, PERILOUS_THRUST, PERILOUS_SWEEP,
	IAIJUTSU_DRAW, DISCIPLINE_CUT, FERAL_ONSLAUGHT, SAVAGE_SWEEP, 
	LEAPING_SLAM, BLOODIED_LUNGE
}
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

var _boss_phase = BossPhase.PHASE_1
var _behavior_state = BehaviorState.IDLE
var _current_attack = AttackType.NONE
var _combat_phase = CombatPhase.NONE

var _attack_cooldown = 0.0
var _attack_sequence_id = 0
var _combo_hit_index = 0
var _combo_interrupted = false
var _combo_is_frozen = false
var _combo_parry_freeze_until = 0.0

var _parry_recoil_until = 0.0
var _parry_recoil_velocity = Vector2.ZERO
var _parry_stagger_until = 0.0

var _dbroken_active = false
var _dbreak_until = -1.0
var _dbreak_immunity_until = 0.0
var _deathblow_in_progress = false  # Guard to prevent re-entry during async deathblow

# Sekiro-style spacing state
var _is_backstepping = false
var _backstep_until = 0.0
var _backstep_dir = Vector2.ZERO
var _last_attack_end_time = 0.0
var _consecutive_attacks = 0

# =============================================================================
# ATTACK VARIETY TRACKING (v4.5)
# =============================================================================
var _attack_history: Array[AttackType] = []  # Recent attacks for penalty weighting
var _attack_last_used: Dictionary = {}  # AttackType -> timestamp of last use
var _consecutive_close_attacks = 0  # Counter for forcing spacing
var _needs_spacing_attack = false  # Flag to force gap creation

var _active_telegraph: Node2D = null
var _posture_break_flash_timer: Timer = null
var _posture_break_flash_on = false
var _base_modulate = Color(1, 1, 1)
var _original_modulate = Color(1, 1, 1)  # Stored at init, never changes (used for reliable restoration)

# v4.5 FIX: Flash state tracking to prevent race conditions
var _is_flashing = false  # Prevents overlapping flash conflicts

var _rng = RandomNumberGenerator.new()

var _bars_container: Node2D
var _keeper_posture_bg: ColorRect
var _keeper_posture_fill: ColorRect
var _hp_bg: ColorRect
var _hp_fill: ColorRect

var _current_hitbox: Area2D = null

# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	super._ready()
	
	hp = keeper_max_hp
	_max_hp = keeper_max_hp
	
	movement_speed = base_movement_speed
	
	can_block = true
	block_by_default = true
	
	_boss_phase = BossPhase.PHASE_1
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	
	_attack_cooldown = 0.0
	_attack_sequence_id = 0
	_combo_hit_index = 0
	_combo_interrupted = false
	_combo_is_frozen = false
	
	_dbroken_active = false
	_dbreak_until = -1.0
	_deathblow_in_progress = false
	
	_is_backstepping = false
	_backstep_until = 0.0
	_backstep_dir = Vector2.ZERO
	
	_rng.randomize()
	
	add_to_group("boss")
	add_to_group("keeper")
	
	if sprite:
		_original_modulate = sprite.modulate
		_base_modulate = sprite.modulate
	
	_attack_history.clear()
	_attack_last_used.clear()
	_consecutive_close_attacks = 0
	_needs_spacing_attack = false
	
	if combat and not combat.config:
		combat.config = CombatConfig.create_boss_config()
	
	if combat and combat.config:
		combat.config.posture_max = 150.0
		combat.config.posture_break_duration = deathblow_window_duration
	
	_setup_dual_bars()
	
	if combat:
		if combat.has_method("update_health_ratio"):
			combat.update_health_ratio(float(hp), float(get_max_hp()))
		
		if not combat.is_connected("posture_changed", Callable(self, "_on_posture_changed")):
			combat.connect("posture_changed", Callable(self, "_on_posture_changed"))
		
		if not combat.is_connected("posture_broken", Callable(self, "_on_posture_broken")):
			combat.connect("posture_broken", Callable(self, "_on_posture_broken"))
		
		var maxv = combat.config.posture_max if combat.config else 100.0
		combat.emit_signal("posture_changed", 0.0, maxv)

func _setup_dual_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsContainer"
	_bars_container.z_index = 10
	get_tree().current_scene.call_deferred("add_child", _bars_container)
	
	_keeper_posture_bg = ColorRect.new()
	_keeper_posture_bg.size = Vector2(64, 6)
	_keeper_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	_keeper_posture_bg.position = Vector2(-32, -52)
	_bars_container.add_child(_keeper_posture_bg)

	_keeper_posture_fill = ColorRect.new()
	_keeper_posture_fill.size = Vector2(0, 6)
	_keeper_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	_keeper_posture_fill.position = Vector2.ZERO
	_keeper_posture_bg.add_child(_keeper_posture_fill)
	
	_hp_bg = ColorRect.new()
	_hp_bg.size = Vector2(64, 6)
	_hp_bg.color = Color(0.15, 0.02, 0.02, 0.8)
	_hp_bg.position = Vector2(-32, -44)
	_bars_container.add_child(_hp_bg)
	
	_hp_fill = ColorRect.new()
	_hp_fill.size = Vector2(64, 6)
	_hp_fill.color = Color(0.85, 0.15, 0.1, 0.95)
	_hp_fill.position = Vector2.ZERO
	_hp_bg.add_child(_hp_fill)

func _update_bars() -> void:
	if _hp_fill:
		var hp_pct = clampf(float(hp) / float(get_max_hp()), 0.0, 1.0)
		_hp_fill.size.x = 64.0 * hp_pct

func _update_posture_bar(cur: float, maxv: float) -> void:
	if not _keeper_posture_fill:
		return
	
	var pct = clampf(cur / maxf(0.001, maxv), 0.0, 1.0)
	_keeper_posture_fill.size.x = 64.0 * pct

func _set_combat_phase(phase: CombatPhase) -> void:
	_combat_phase = phase

func _is_in_windup() -> bool:
	return _combat_phase == CombatPhase.WINDUP

# =============================================================================
# v4.5 FIX: CENTRALIZED MODULATE RESTORATION
# =============================================================================
func _get_correct_modulate() -> Color:
	"""Returns the correct modulate color based on current boss state.
	   Use this instead of storing/restoring local 'orig' variables."""
	if _boss_phase == BossPhase.PHASE_2:
		return Color(1.1, 0.9, 0.9)  # Beast mode tint
	else:
		return _original_modulate  # Clean Phase 1 modulate

func _restore_modulate() -> void:
	"""Safely restores sprite modulate to the correct state-based color."""
	if sprite and is_instance_valid(sprite):
		sprite.modulate = _get_correct_modulate()
	_is_flashing = false

# =============================================================================
# MAIN LOOP
# =============================================================================
func _physics_process(delta: float) -> void:
	if _boss_phase == BossPhase.DEAD:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _humanoid_shared_tick(delta):
		if _bars_container:
			_bars_container.global_position = global_position
		_update_bars()
		return
	
	if _combo_is_frozen:
		var now = Time.get_ticks_msec() * 0.001
		if now >= _combo_parry_freeze_until:
			_combo_is_frozen = false
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			return
	
	if _bars_container:
		_bars_container.global_position = global_position
	_update_bars()
	
	var now = Time.get_ticks_msec() * 0.001
	
	_set_blocking(_is_guarding())
	
	if _dbroken_active and now >= _dbreak_until:
		_end_deathblow_window()
	
	if _dbroken_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Handle backstep movement (Sekiro-style retreat after combos)
	if _is_backstepping:
		if now < _backstep_until:
			velocity = _backstep_dir * backstep_speed
			move_and_slide()
			return
		else:
			_is_backstepping = false
			_backstep_dir = Vector2.ZERO
			velocity = Vector2.ZERO
	
	if _parry_recoil_until > 0.0:
		if now < _parry_recoil_until:
			velocity = _parry_recoil_velocity
			move_and_slide()
			return
		else:
			_parry_recoil_until = 0.0
			_parry_recoil_velocity = Vector2.ZERO
	
	if combat:
		combat.update_health_ratio(float(hp), float(get_max_hp()))
		combat.tick(delta)
	
	_attack_cooldown = maxf(_attack_cooldown - delta, 0.0)
	
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
			_process_idle(player, dist, dir)
		BehaviorState.PURSUING:
			_process_pursuing(player, dist, dir)
		BehaviorState.ATTACKING, BehaviorState.STAGGERED, BehaviorState.TRANSITIONING:
			pass
	
	_apply_spacing_behavior(dist, dir)
	move_and_slide()

func _process_idle(_player: Node2D, dist: float, dir: Vector2) -> void:
	velocity = Vector2.ZERO
	_face_direction(dir)
	_play_anim("idle")
	
	# Boss confused: brief pause, no attacks
	if ProstheticEffects.is_confused(self):
		return
	
	if dist > mid_range + 30.0:
		_behavior_state = BehaviorState.PURSUING
		return
	
	if _attack_cooldown <= 0.0:
		var attack = _choose_attack(dist)
		if attack != AttackType.NONE:
			_start_attack(attack)
			
func _process_pursuing(_player: Node2D, dist: float, dir: Vector2) -> void:
	if ProstheticEffects.is_confused(self):
		velocity = Vector2.ZERO
		return
	if dist <= mid_range:
		_behavior_state = BehaviorState.IDLE
		return
	velocity = dir * base_movement_speed
	_face_direction(dir)
	_play_anim("walk")
	
# =============================================================================
# SEKIRO-STYLE SPACING BEHAVIOR
# =============================================================================
func _apply_spacing_behavior(dist: float, dir: Vector2) -> void:
	# Don't apply spacing during active combat states
	if _boss_phase == BossPhase.DEAD or _dbroken_active:
		return
	if _combat_phase == CombatPhase.ACTIVE or _combat_phase == CombatPhase.WINDUP:
		return
	if _is_backstepping:
		return
	if _behavior_state == BehaviorState.ATTACKING:
		return
	
	# FACE-HUG PREVENTION: If too close, gently push away
	if dist < too_close_threshold and dist > 0.1:
		var push_strength = (too_close_threshold - dist) / too_close_threshold
		velocity += -dir * push_strength * 80.0
		return
	
	# IDEAL SPACING: Maintain ideal combat distance when idle
	if _behavior_state == BehaviorState.IDLE and _combat_phase == CombatPhase.NONE:
		var dist_from_ideal = dist - ideal_combat_distance
		
		# Too close - back off slightly
		if dist_from_ideal < -15.0:
			velocity += -dir * absf(dist_from_ideal) * spacing_aggression
		# Too far but within attack range - subtle approach
		elif dist_from_ideal > 20.0 and dist < mid_range:
			velocity += dir * minf(dist_from_ideal * spacing_aggression, base_movement_speed * 0.5)

func _start_backstep() -> void:
	var player = _get_player()
	if not player:
		return
	
	var away_dir = (global_position - player.global_position).normalized()
	if away_dir == Vector2.ZERO:
		away_dir = Vector2.RIGHT
	
	_is_backstepping = true
	_backstep_dir = away_dir
	_backstep_until = Time.get_ticks_msec() * 0.001 + backstep_duration
	_face_direction(-away_dir)  # Face player while backing up

func _maybe_backstep_after_combo() -> void:
	# Sekiro-style: Boss often backs off after completing a combo
	if _rng.randf() < post_combo_backstep_chance:
		_start_backstep()
	_consecutive_attacks = 0

# =============================================================================
# v4.5 FIX: FORCED SPACING BEHAVIOR
# =============================================================================
func _force_create_spacing() -> void:
	"""Forces the boss to create distance from the player.
	   Used when close-range attacks have been spammed too much."""
	print("[Keeper] FORCING SPACING - too many consecutive close attacks!")
	_start_backstep()
	# Add extra cooldown to give breathing room
	_attack_cooldown += 0.6
	_consecutive_close_attacks = 0
	_needs_spacing_attack = false

# =============================================================================
# v4.5 FIX: ATTACK VARIETY SYSTEM
# =============================================================================
func _record_attack_used(attack: AttackType) -> void:
	"""Records an attack being used for variety tracking."""
	var now = Time.get_ticks_msec() * 0.001
	_attack_last_used[attack] = now
	
	# Add to history, maintaining size limit
	_attack_history.push_back(attack)
	while _attack_history.size() > attack_history_size:
		_attack_history.pop_front()
	
	# Track consecutive close-range attacks
	if _is_close_range_attack(attack):
		_consecutive_close_attacks += 1
		if _consecutive_close_attacks >= max_consecutive_close_attacks:
			_needs_spacing_attack = true
	else:
		_consecutive_close_attacks = 0

func _is_close_range_attack(attack: AttackType) -> bool:
	"""Returns true if this is a close-range melee attack."""
	match attack:
		AttackType.BLADE_DANCE, AttackType.EMBER_OVERHEAD, AttackType.DISCIPLINE_CUT:
			return true
		AttackType.FERAL_ONSLAUGHT, AttackType.SAVAGE_SWEEP:
			return true
		_:
			return false

func _is_spacing_attack(attack: AttackType) -> bool:
	"""Returns true if this attack creates or uses distance."""
	match attack:
		AttackType.IAIJUTSU_DRAW, AttackType.LEAPING_SLAM, AttackType.BLOODIED_LUNGE:
			return true
		AttackType.PERILOUS_THRUST:
			return true
		_:
			return false

func _get_attack_weight_penalty(attack: AttackType) -> float:
	"""Returns weight multiplier (0.0-1.0) based on recent usage.
	   Lower = more penalty for recently used attacks."""
	var now = Time.get_ticks_msec() * 0.001
	var penalty = 1.0
	
	# Check per-attack cooldown
	if _attack_last_used.has(attack):
		var time_since = now - _attack_last_used[attack]
		if time_since < per_attack_cooldown:
			# Strong penalty for attacks used very recently
			penalty *= repeat_attack_penalty
	
	# Check history for repeated attacks
	var history_count = _attack_history.count(attack)
	if history_count > 0:
		# More repeats = more penalty
		penalty *= pow(0.5, history_count)
	
	return penalty

func _choose_attack(dist: float) -> AttackType:
	# v4.5: Check if we need to force spacing first
	if _needs_spacing_attack:
		if _rng.randf() < forced_spacing_chance:
			_force_create_spacing()
			return AttackType.NONE  # Don't attack, just create space
		else:
			_needs_spacing_attack = false  # Lucky roll, continue normally
	
	var attack: AttackType
	if _boss_phase == BossPhase.PHASE_1:
		attack = _choose_phase1_attack_weighted(dist)
		print("[Keeper] Phase 1 - Chose attack: ", AttackType.keys()[attack], " (dist: ", int(dist), ", close_attacks: ", _consecutive_close_attacks, ")")
	else:
		attack = _choose_phase2_attack_weighted(dist)
		print("[Keeper] Phase 2 - Chose attack: ", AttackType.keys()[attack], " (dist: ", int(dist), ", close_attacks: ", _consecutive_close_attacks, ")")
	
	return attack

func _choose_phase1_attack_weighted(dist: float) -> AttackType:
	"""Phase 1 attack selection with variety weighting."""
	var candidates: Array[Dictionary] = []  # [{attack: AttackType, weight: float}]
	
	if dist <= close_range:
		# Close range: All attacks available with base weights
		candidates.append({"attack": AttackType.BLADE_DANCE, "weight": 0.35})
		candidates.append({"attack": AttackType.EMBER_OVERHEAD, "weight": 0.35})
		candidates.append({"attack": AttackType.DISCIPLINE_CUT, "weight": 0.20})
		# Small chance for gap-closer even at close range (for variety)
		candidates.append({"attack": AttackType.IAIJUTSU_DRAW, "weight": 0.10})
	elif dist <= mid_range:
		# Mid range: Mix of gap-closers and melee
		candidates.append({"attack": AttackType.IAIJUTSU_DRAW, "weight": 0.40})
		candidates.append({"attack": AttackType.EMBER_OVERHEAD, "weight": 0.25})
		candidates.append({"attack": AttackType.BLADE_DANCE, "weight": 0.20})
		candidates.append({"attack": AttackType.DISCIPLINE_CUT, "weight": 0.15})
	else:
		# Far range - ONLY use gap-closers
		return AttackType.IAIJUTSU_DRAW
	
	return _select_weighted_attack(candidates)

func _choose_phase2_attack_weighted(dist: float) -> AttackType:
	"""Phase 2 attack selection with variety weighting."""
	var candidates: Array[Dictionary] = []
	
	if dist <= close_range:
		candidates.append({"attack": AttackType.FERAL_ONSLAUGHT, "weight": 0.40})
		candidates.append({"attack": AttackType.SAVAGE_SWEEP, "weight": 0.35})
		candidates.append({"attack": AttackType.LEAPING_SLAM, "weight": 0.15})
		# Small chance for lunge even at close range
		candidates.append({"attack": AttackType.BLOODIED_LUNGE, "weight": 0.10})
	elif dist <= mid_range:
		candidates.append({"attack": AttackType.LEAPING_SLAM, "weight": 0.35})
		candidates.append({"attack": AttackType.BLOODIED_LUNGE, "weight": 0.30})
		candidates.append({"attack": AttackType.FERAL_ONSLAUGHT, "weight": 0.25})
		candidates.append({"attack": AttackType.SAVAGE_SWEEP, "weight": 0.10})
	else:
		# Far range in Phase 2: Use gap-closers
		candidates.append({"attack": AttackType.BLOODIED_LUNGE, "weight": 0.55})
		candidates.append({"attack": AttackType.LEAPING_SLAM, "weight": 0.45})
	
	return _select_weighted_attack(candidates)

func _select_weighted_attack(candidates: Array[Dictionary]) -> AttackType:
	"""Selects an attack from candidates using variety-adjusted weights."""
	if candidates.is_empty():
		return AttackType.NONE
	
	# Apply variety penalties to weights
	var total_weight = 0.0
	for c in candidates:
		var penalty = _get_attack_weight_penalty(c["attack"])
		c["adjusted_weight"] = c["weight"] * penalty
		total_weight += c["adjusted_weight"]
	
	# If all weights are near zero (everything recently used), reset and pick randomly
	if total_weight < 0.01:
		var idx = _rng.randi() % candidates.size()
		var chosen = candidates[idx]["attack"]
		_record_attack_used(chosen)
		return chosen
	
	# Weighted random selection
	var roll = _rng.randf() * total_weight
	var cumulative = 0.0
	for c in candidates:
		cumulative += c["adjusted_weight"]
		if roll <= cumulative:
			var chosen = c["attack"]
			_record_attack_used(chosen)
			return chosen
	
	# Fallback (shouldn't happen)
	var fallback = candidates[0]["attack"]
	_record_attack_used(fallback)
	return fallback

# =============================================================================
# ATTACK DISPATCH
# =============================================================================
func _start_attack(attack: AttackType) -> void:
	_behavior_state = BehaviorState.ATTACKING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1
	
	match attack:
		AttackType.BLADE_DANCE: _do_blade_dance()
		AttackType.EMBER_OVERHEAD: _do_ember_overhead()
		AttackType.IAIJUTSU_DRAW: _do_iaijutsu_draw()
		AttackType.DISCIPLINE_CUT: _do_discipline_cut()
		AttackType.FERAL_ONSLAUGHT: _do_feral_onslaught()
		AttackType.SAVAGE_SWEEP: _do_savage_sweep()
		AttackType.LEAPING_SLAM: _do_leaping_slam()
		AttackType.BLOODIED_LUNGE: _do_bloodied_lunge()

func _finish_attack() -> void:
	var cd_min = phase1_min_cooldown if _boss_phase == BossPhase.PHASE_1 else phase2_min_cooldown
	var cd_max = phase1_max_cooldown if _boss_phase == BossPhase.PHASE_1 else phase2_max_cooldown
	
	# Track consecutive attacks for rhythm management
	_consecutive_attacks += 1
	_last_attack_end_time = Time.get_ticks_msec() * 0.001
	
	# Enforce minimum rhythm gap
	var cooldown = _rng.randf_range(cd_min, cd_max)
	cooldown = maxf(cooldown, min_rhythm_gap)
	
	# After multiple consecutive attacks, take a longer break (Sekiro breathing room)
	if _consecutive_attacks >= 3:
		cooldown += 0.4
	
	_attack_cooldown = cooldown
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_behavior_state = BehaviorState.IDLE
	_cleanup_hitbox()
	_cleanup_telegraph()
	_combo_interrupted = false
	_play_anim("idle")
	
	# Sekiro-style: Maybe backstep after finishing a combo
	_maybe_backstep_after_combo()

func _should_abort_attack(seq_id: int) -> bool:
	return _boss_phase == BossPhase.DEAD or _dbroken_active or _combo_interrupted or seq_id != _attack_sequence_id

# =============================================================================
# PHASE 1: KEEPER BLADE DANCE
# =============================================================================
func _do_blade_dance() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_face_player()
	
	# Initial windup
	_play_anim("combo_start")
	if not await _wait_interruptible(blade_dance_windup, seq): _finish_attack(); return
	
	# Hit 1
	_combo_hit_index = 1
	if not await _execute_blade_dance_hit(seq, blade_dance_hit1_anticipation, blade_dance_hit1_active, blade_dance_hit1_recovery, "combo_hit1"):
		_finish_attack(); return
	
	# Hit 2
	_combo_hit_index = 2
	_face_player()
	if not await _execute_blade_dance_hit(seq, blade_dance_hit2_anticipation, blade_dance_hit2_active, blade_dance_hit2_recovery, "combo_hit2"):
		_finish_attack(); return
	
	# Hit 3 (DELAYED)
	_combo_hit_index = 3
	_face_player()
	if not await _execute_blade_dance_hit(seq, blade_dance_hit3_anticipation, blade_dance_hit3_active, blade_dance_hit3_recovery, "combo_hit1"):
		_finish_attack(); return
	
	# Hit 4 (finisher)
	_combo_hit_index = 4
	_face_player()
	if not await _execute_blade_dance_hit(seq, blade_dance_hit4_anticipation, blade_dance_hit4_active, blade_dance_hit4_recovery, "combo_hit2"):
		_finish_attack(); return
	
	print("[Keeper] Completed: BLADE_DANCE (4 hits)")
	_finish_attack()

func _execute_blade_dance_hit(seq: int, antic: float, active: float, recov: float, hit_anim: String) -> bool:
	_set_combat_phase(CombatPhase.WINDUP)
	_play_anim("combo_start")
	
	_show_parry_indicator(antic + active + parry_linger_window, false)
	
	var player = _get_player()
	var attack_dir = _get_facing_direction()
	if player: attack_dir = (player.global_position - global_position).normalized()
	
	if not await _lunge_toward(attack_dir, blade_dance_lunge_distance, blade_dance_lunge_speed, antic, seq): return false
	if _should_abort_attack(seq): return false
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim(hit_anim)
	_spawn_melee_hitbox(attack_dir, blade_dance_arc_length, blade_dance_arc_width, blade_dance_damage, true)
	if not await _wait_interruptible(active, seq): _cleanup_hitbox(); return false
	_cleanup_hitbox()
	velocity = Vector2.ZERO
	
	if _should_abort_attack(seq): return false
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	return await _wait_interruptible(recov, seq)

# =============================================================================
# PHASE 1: EMBER OVERHEAD
# =============================================================================
func _do_ember_overhead() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_face_player()
	
	var total = overhead_windup + overhead_active + parry_linger_window
	_show_parry_indicator(total, false)
	
	_play_anim("overhead_windup")
	if not await _wait_interruptible(overhead_windup, seq): _finish_attack(); return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("overhead_impact")
	_spawn_melee_hitbox(_get_facing_direction(), overhead_arc_length, overhead_arc_width, overhead_damage, true)
	if not await _wait_interruptible(overhead_active, seq): _cleanup_hitbox(); _finish_attack(); return
	_cleanup_hitbox()
	
	if _should_abort_attack(seq): _finish_attack(); return
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	if not await _wait_interruptible(overhead_recovery, seq): _finish_attack(); return
	
	print("[Keeper] Completed: EMBER_OVERHEAD - branching to perilous...")
	
	# === FIX: Add delay before perilous attack so player can react ===
	# Boss pauses briefly, giving visual cue that something dangerous is coming
	_play_anim("combo_start")  # Anticipation pose
	if not await _wait_interruptible(overhead_branch_delay, seq): _finish_attack(); return
	
	var player = _get_player()
	var dist = far_range
	if player: dist = (player.global_position - global_position).length()
	
	if dist >= overhead_branch_distance:
		_current_attack = AttackType.PERILOUS_THRUST
		await _do_perilous_thrust(seq)
	else:
		_current_attack = AttackType.PERILOUS_SWEEP
		await _do_perilous_sweep(seq)
	_finish_attack()

func _do_perilous_thrust(seq: int) -> void:
	_set_combat_phase(CombatPhase.WINDUP)
	_face_player()
	var player = _get_player()
	var dir = _get_facing_direction()
	
	# v4.8 FIX: Lock direction at telegraph start - NO MORE TRACKING
	var start_pos = global_position
	if player: 
		dir = (player.global_position - global_position).normalized()
	
	# v4.8 FIX: Calculate actual dash distance with cap
	var dist_to_player = far_range
	if player:
		dist_to_player = (player.global_position - global_position).length()
	
	# Cap the dash distance - don't lunge past player or beyond max range
	# Leave some spacing so boss doesn't end up inside player
	var actual_dash_distance = minf(thrust_max_distance, maxf(0.0, dist_to_player - ideal_combat_distance * 0.5))
	var actual_duration = actual_dash_distance / thrust_dash_speed if thrust_dash_speed > 0 else thrust_dash_duration
	
	# v4.8 FIX: Telegraph shows the ACTUAL danger zone (from boss start to dash end)
	# Hitbox length should cover from current position to where boss will end up
	var telegraph_length = actual_dash_distance + 60.0  # Small buffer for hitbox width
	_spawn_lane_telegraph(dir, telegraph_length, thrust_lane_width, thrust_telegraph_time)
	_play_anim("overhead_windup")
	
	# === Show RED UNBLOCKABLE indicator ===
	_show_parry_indicator(thrust_telegraph_time + actual_duration, true)
	_flash_perilous_warning()
	
	if not await _wait_interruptible(thrust_telegraph_time, seq): return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("combo_hit1")
	
	# v4.8 FIX: Use STATIC hitbox in world space - matches telegraph exactly
	# Hitbox stays where telegraph was, boss dashes through it
	_spawn_lane_hitbox_static(start_pos, dir, telegraph_length, thrust_lane_width, thrust_damage, false)
	
	# Execute the dash with FIXED direction (no tracking)
	var elapsed = 0.0
	var distance_traveled = 0.0
	while elapsed < actual_duration and distance_traveled < actual_dash_distance:
		if _should_abort_attack(seq): _cleanup_hitbox(); return
		await get_tree().physics_frame
		if not is_instance_valid(self): return
		var dt = get_physics_process_delta_time()
		elapsed += dt
		distance_traveled += thrust_dash_speed * dt
		velocity = dir * thrust_dash_speed
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	await _wait_interruptible(0.35, seq)
	print("[Keeper] Completed: PERILOUS_THRUST (dist: ", actual_dash_distance, ")")

func _do_perilous_sweep(seq: int) -> void:
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_spawn_arc_telegraph(sweep_inner_radius, sweep_outer_radius, sweep_arc_degrees, sweep_telegraph_time)
	_play_anim("overhead_windup")
	
	# === FIX: Show RED UNBLOCKABLE indicator (not just sprite flash) ===
	_show_parry_indicator(sweep_telegraph_time + sweep_active, true)
	_flash_perilous_warning()  # Keep sprite flash too for extra visibility
	
	if not await _wait_interruptible(sweep_telegraph_time, seq): return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("overhead_impact")
	_spawn_sweep_hitbox(sweep_inner_radius, sweep_outer_radius, sweep_arc_degrees, sweep_damage)
	if not await _wait_interruptible(sweep_active, seq): _cleanup_hitbox(); return
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	await _wait_interruptible(0.30, seq)
	print("[Keeper] Completed: PERILOUS_SWEEP")

# =============================================================================
# PHASE 1: IAIJUTSU DRAW - FIX 2: Hitbox follows boss during dash
# =============================================================================
func _do_iaijutsu_draw() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_face_player()
	
	_show_parry_indicator(iaijutsu_windup + iaijutsu_dash_duration + iaijutsu_hit1_active + parry_linger_window, false)
	
	_play_anim("combo_start")
	if not await _wait_interruptible(iaijutsu_windup, seq): _finish_attack(); return
	
	var player = _get_player()
	var dash_dir = _get_facing_direction()
	if player: dash_dir = (player.global_position - global_position).normalized()
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("combo_hit1")
	# FIX 2: Use ATTACHED hitbox so it moves with the boss during dash
	_spawn_melee_hitbox_attached(dash_dir, iaijutsu_arc_length, iaijutsu_arc_width, iaijutsu_damage, true)
	
	var elapsed = 0.0
	while elapsed < iaijutsu_dash_duration:
		if _should_abort_attack(seq): _cleanup_hitbox(); _finish_attack(); return
		await get_tree().physics_frame
		if not is_instance_valid(self): return
		elapsed += get_physics_process_delta_time()
		velocity = dash_dir * iaijutsu_dash_speed
	velocity = Vector2.ZERO
	
	if not await _wait_interruptible(iaijutsu_hit1_active, seq): _cleanup_hitbox(); _finish_attack(); return
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	if not await _wait_interruptible(iaijutsu_hit1_recovery, seq): _finish_attack(); return
	
	_face_player()
	var attack_dir = _get_facing_direction()
	if player and is_instance_valid(player): attack_dir = (player.global_position - global_position).normalized()
	
	_show_parry_indicator(iaijutsu_hit2_anticipation + iaijutsu_hit2_active + parry_linger_window, false)
	
	_set_combat_phase(CombatPhase.WINDUP)
	_play_anim("combo_start")
	if not await _wait_interruptible(iaijutsu_hit2_anticipation, seq): _finish_attack(); return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("combo_hit2")
	# Second hit doesn't move, so standard hitbox is fine
	_spawn_melee_hitbox(attack_dir, iaijutsu_arc_length * 1.1, iaijutsu_arc_width * 1.2, iaijutsu_damage, true)
	if not await _wait_interruptible(iaijutsu_hit2_active, seq): _cleanup_hitbox(); _finish_attack(); return
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	await _wait_interruptible(iaijutsu_hit2_recovery, seq)
	print("[Keeper] Completed: IAIJUTSU_DRAW (2 hits)")
	_finish_attack()

# =============================================================================
# PHASE 1: DISCIPLINE CUT
# =============================================================================
func _do_discipline_cut() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_face_player()
	
	_show_parry_indicator(discipline_windup + discipline_active + parry_linger_window, false)
	_play_anim("combo_start")
	
	var player = _get_player()
	var attack_dir = _get_facing_direction()
	if player: attack_dir = (player.global_position - global_position).normalized()
	
	var lunge_result = await _lunge_toward_with_min_wait(attack_dir, discipline_lunge_distance, discipline_lunge_speed, discipline_windup, seq)
	if not lunge_result: _finish_attack(); return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("combo_hit1")
	_spawn_melee_hitbox(attack_dir, discipline_arc_length, discipline_arc_width, discipline_damage, true)
	if not await _wait_interruptible(discipline_active, seq): _cleanup_hitbox(); _finish_attack(); return
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	await _wait_interruptible(discipline_recovery, seq)
	print("[Keeper] Completed: DISCIPLINE_CUT")
	_finish_attack()

func _lunge_toward_with_min_wait(dir: Vector2, distance: float, speed: float, min_duration: float, seq_id: int) -> bool:
	var start_time = Time.get_ticks_msec() * 0.001
	
	var player = _get_player()
	var current_dist = 999.0
	if player: current_dist = (player.global_position - global_position).length()
	
	var should_skip_lunge = (dir == Vector2.ZERO or speed <= 0 or current_dist < lunge_min_distance)
	
	if should_skip_lunge:
		if not await _wait_interruptible(min_duration, seq_id): return false
		return not _should_abort_attack(seq_id)
	
	var max_close = minf(distance, max_lunge_close_distance)
	var target_dist = current_dist - max_close
	
	if target_dist < ideal_combat_distance * 0.5:
		max_close = current_dist - (ideal_combat_distance * 0.5)
	
	var adjusted = maxf(0.0, minf(distance, max_close))
	
	if current_dist < ideal_combat_distance:
		adjusted = adjusted * clampf((current_dist - lunge_min_distance) / (ideal_combat_distance - lunge_min_distance), 0.0, 1.0)
	
	if adjusted < 5.0:
		if not await _wait_interruptible(min_duration, seq_id): return false
		return not _should_abort_attack(seq_id)
	
	var start_pos = global_position
	var adj_dur = adjusted / speed if speed > 0 else min_duration
	var elapsed = 0.0
	
	while elapsed < adj_dur:
		if _should_abort_attack(seq_id): velocity = Vector2.ZERO; return false
		if _combo_is_frozen:
			velocity = Vector2.ZERO
			while _combo_is_frozen:
				if _should_abort_attack(seq_id): return false
				await get_tree().physics_frame
				if not is_instance_valid(self): return false
			continue
		if global_position.distance_to(start_pos) >= adjusted: 
			velocity = Vector2.ZERO
			break
		velocity = dir.normalized() * speed
		await get_tree().physics_frame
		if not is_instance_valid(self): return false
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO
	
	var actual_elapsed = (Time.get_ticks_msec() * 0.001) - start_time
	var remaining = min_duration - actual_elapsed
	if remaining > 0.0:
		if not await _wait_interruptible(remaining, seq_id): return false
	
	return not _should_abort_attack(seq_id)

# =============================================================================
# PHASE 2: FERAL ONSLAUGHT
# =============================================================================
func _do_feral_onslaught() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_face_player()
	
	var anticipations = [feral_hit1_anticipation, feral_hit2_anticipation, feral_hit3_anticipation, feral_hit4_anticipation, feral_hit5_anticipation]
	
	_play_anim("combo_start")
	if not await _wait_interruptible(feral_windup, seq): _finish_attack(); return
	
	var hit_anims = ["combo_hit1", "combo_hit2", "combo_hit1", "combo_hit2", "combo_hit1"]
	
	for i in range(5):
		_combo_hit_index = i + 1
		_face_player()
		var recov = feral_inter_hit_recovery if i < 4 else feral_final_recovery
		if not await _execute_feral_hit(seq, anticipations[i], feral_active_time, recov, hit_anims[i]):
			_finish_attack(); return
	
	print("[Keeper] Completed: FERAL_ONSLAUGHT (5 hits)")
	_finish_attack()

func _execute_feral_hit(seq: int, antic: float, active: float, recov: float, hit_anim: String) -> bool:
	_set_combat_phase(CombatPhase.WINDUP)
	_play_anim("combo_start")
	
	_show_parry_indicator(antic + active + parry_linger_window, false)
	
	var player = _get_player()
	var attack_dir = _get_facing_direction()
	if player: attack_dir = (player.global_position - global_position).normalized()
	
	if not await _lunge_toward(attack_dir, feral_advance_distance, feral_advance_speed, antic, seq): return false
	if _should_abort_attack(seq): return false
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim(hit_anim)
	_spawn_melee_hitbox(attack_dir, feral_arc_length, feral_arc_width, feral_damage, true)
	if not await _wait_interruptible(active, seq): _cleanup_hitbox(); return false
	_cleanup_hitbox()
	velocity = Vector2.ZERO
	
	if _should_abort_attack(seq): return false
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	return await _wait_interruptible(recov, seq)

# =============================================================================
# PHASE 2: SAVAGE SWEEP - v5.0: Fixed indicator visual
# =============================================================================
func _do_savage_sweep() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	# v5.0: Use full circle telegraph (matches the actual circular hitbox)
	_spawn_circle_telegraph_centered(savage_radius, savage_telegraph_time)
	_play_anim("overhead_windup")
	
	# === FIX: Show RED UNBLOCKABLE indicator ===
	_show_parry_indicator(savage_telegraph_time + savage_active, true)
	_flash_perilous_warning()
	
	if not await _wait_interruptible(savage_telegraph_time, seq): _finish_attack(); return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("overhead_impact")
	_spawn_circle_hitbox(savage_radius, savage_damage)
	if not await _wait_interruptible(savage_active, seq): _cleanup_hitbox(); _finish_attack(); return
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	await _wait_interruptible(savage_recovery, seq)
	print("[Keeper] Completed: SAVAGE_SWEEP")
	_finish_attack()

# =============================================================================
# PHASE 2: LEAPING SLAM - v4.5 FIX: Proper reaction time
# =============================================================================
func _do_leaping_slam() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	var player = _get_player()
	var target_pos = global_position + Vector2(100, 0)
	if player: target_pos = player.global_position
	
	# v4.5 FIX: Total telegraph time now includes landing delay for better readability
	var total_telegraph = slam_crouch_time + slam_air_time + slam_landing_delay
	_spawn_circle_telegraph(target_pos, slam_target_radius, total_telegraph)
	_play_anim("overhead_windup")
	
	# Show RED UNBLOCKABLE indicator
	_show_parry_indicator(total_telegraph + slam_impact_active, true)
	_flash_perilous_warning()
	
	# v4.5: Increased crouch time (0.40 -> 0.70) gives more time to see telegraph
	if not await _wait_interruptible(slam_crouch_time, seq): _finish_attack(); return
	
	_play_anim("combo_start")
	if sprite: sprite.scale = Vector2(0.6, 0.6)
	
	var start_pos = global_position
	var elapsed = 0.0
	while elapsed < slam_air_time:
		if _should_abort_attack(seq):
			if sprite: sprite.scale = Vector2(1.0, 1.0)
			_finish_attack(); return
		await get_tree().physics_frame
		if not is_instance_valid(self): return
		elapsed += get_physics_process_delta_time()
		global_position = start_pos.lerp(target_pos, elapsed / slam_air_time)
	
	global_position = target_pos
	if sprite: sprite.scale = Vector2(1.0, 1.0)
	
	# v4.5 FIX: Add landing impact delay - boss lands but doesn't damage immediately
	# This gives players a brief moment to react after the boss lands
	_play_anim("overhead_windup")  # Visual "charging" pose on landing
	_flash_landing_warning()  # Visual cue that impact is imminent
	if not await _wait_interruptible(slam_landing_delay, seq): _finish_attack(); return
	
	# NOW the damage comes
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("overhead_impact")
	_spawn_circle_hitbox(slam_target_radius, slam_damage)
	await _wait_interruptible(slam_impact_active, seq)
	_cleanup_hitbox()
	
	# Shockwave
	var step_time = slam_shockwave_expand_time / 4.0
	var step_radius = slam_shockwave_radius / 4.0
	for i in range(4):
		if _should_abort_attack(seq): break
		_spawn_ring_hitbox(step_radius * i, step_radius * (i + 1), int(slam_damage * 0.7))
		await _wait_interruptible(step_time, seq)
		_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	await _wait_interruptible(slam_recovery, seq)
	print("[Keeper] Completed: LEAPING_SLAM")
	_finish_attack()

# v4.5: Visual warning flash when boss lands (before damage)
func _flash_landing_warning() -> void:
	if not sprite or _is_flashing: return
	_is_flashing = true
	
	# Quick yellow/orange flash to signal imminent impact
	sprite.modulate = Color(1.5, 1.2, 0.4, 1.0)
	await get_tree().create_timer(0.08).timeout
	if is_instance_valid(sprite) and not _dbroken_active and _boss_phase != BossPhase.DEAD:
		sprite.modulate = Color(1.8, 0.5, 0.3, 1.0)
		await get_tree().create_timer(0.08).timeout
		if is_instance_valid(sprite) and not _dbroken_active and _boss_phase != BossPhase.DEAD:
			_restore_modulate()
	_is_flashing = false

# =============================================================================
# PHASE 2: BLOODIED LUNGE - v4.8 FIX: Distance cap + no tracking
# =============================================================================
func _do_bloodied_lunge() -> void:
	var seq = _attack_sequence_id
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_face_player()
	
	var player = _get_player()
	var dir = _get_facing_direction()
	
	# v4.8 FIX: Lock direction at telegraph start - NO MORE TRACKING
	var start_pos = global_position
	if player: 
		dir = (player.global_position - global_position).normalized()
	
	# v4.8 FIX: Calculate actual dash distance with cap
	var dist_to_player = far_range
	if player:
		dist_to_player = (player.global_position - global_position).length()
	
	# Cap the dash distance - don't lunge past player or beyond max range
	# Leave some spacing so boss doesn't end up inside player
	var actual_dash_distance = minf(lunge_max_distance, maxf(0.0, dist_to_player - ideal_combat_distance * 0.5))
	var actual_duration = actual_dash_distance / lunge_dash_speed if lunge_dash_speed > 0 else lunge_dash_duration
	
	# v4.8 FIX: Telegraph shows the ACTUAL danger zone (from boss start to dash end)
	var telegraph_length = actual_dash_distance + 60.0  # Small buffer for hitbox width
	_spawn_lane_telegraph(dir, telegraph_length, lunge_lane_width, lunge_telegraph_time)
	_play_anim("overhead_windup")
	
	# === Show RED UNBLOCKABLE indicator ===
	_show_parry_indicator(lunge_telegraph_time + actual_duration, true)
	_flash_perilous_warning()
	
	if not await _wait_interruptible(lunge_telegraph_time, seq): _finish_attack(); return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_play_anim("combo_hit1")
	
	# v4.8 FIX: Use STATIC hitbox in world space - matches telegraph exactly
	# Hitbox stays where telegraph was, boss dashes through it
	_spawn_lane_hitbox_static(start_pos, dir, telegraph_length, lunge_lane_width, lunge_damage, false)
	
	# Execute the dash with FIXED direction (no tracking)
	var elapsed = 0.0
	var distance_traveled = 0.0
	while elapsed < actual_duration and distance_traveled < actual_dash_distance:
		if _should_abort_attack(seq): _cleanup_hitbox(); _finish_attack(); return
		await get_tree().physics_frame
		if not is_instance_valid(self): return
		var dt = get_physics_process_delta_time()
		elapsed += dt
		distance_traveled += lunge_dash_speed * dt
		velocity = dir * lunge_dash_speed
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	_play_anim("idle")
	await _wait_interruptible(lunge_recovery, seq)
	print("[Keeper] Completed: BLOODIED_LUNGE (dist: ", actual_dash_distance, ")")
	_finish_attack()

# =============================================================================
# HITBOX SPAWNING - v4.6 FIX: All non-parryable hitboxes are also unblockable
# =============================================================================
# Standard hitbox - spawns in world space (doesn't move with boss)
func _spawn_melee_hitbox(dir: Vector2, length: float, width: float, damage: int, parryable: bool) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_melee")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", parryable)
	hitbox.set_meta("unblockable", not parryable)  # v4.6 FIX: Unparryable = unblockable
	hitbox.set_meta("telegraphed", true)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width)
	shape.shape = rect
	hitbox.add_child(shape)
	
	# Add to scene and position globally
	get_tree().current_scene.add_child(hitbox)
	hitbox.global_position = global_position + dir.normalized() * (length * 0.5)
	hitbox.rotation = dir.angle()
	_current_hitbox = hitbox

# FIX 2: Attached hitbox - spawns as child of boss (moves with boss)
func _spawn_melee_hitbox_attached(dir: Vector2, length: float, width: float, damage: int, parryable: bool) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_melee")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", parryable)
	hitbox.set_meta("unblockable", not parryable)  # v4.6 FIX: Unparryable = unblockable
	hitbox.set_meta("telegraphed", true)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width)
	shape.shape = rect
	hitbox.add_child(shape)
	
	# Add as child of boss so it moves with the boss
	add_child(hitbox)
	hitbox.position = dir.normalized() * (length * 0.5)
	hitbox.rotation = dir.angle()
	_current_hitbox = hitbox

func _spawn_circle_hitbox(radius: float, damage: int) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_slam")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("unblockable", true)  # v4.6 FIX: Cannot be blocked
	hitbox.set_meta("telegraphed", true)
	
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	shape.shape = circle
	hitbox.add_child(shape)
	add_child(hitbox)
	_current_hitbox = hitbox

func _spawn_ring_hitbox(inner: float, outer: float, damage: int) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_shockwave")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("unblockable", true)  # v4.6 FIX: Cannot be blocked
	hitbox.set_meta("telegraphed", true)
	hitbox.set_meta("inner_radius", inner)
	
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = outer
	shape.shape = circle
	hitbox.add_child(shape)
	add_child(hitbox)
	_current_hitbox = hitbox

func _spawn_sweep_hitbox(inner: float, outer: float, arc_deg: float, damage: int) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_sweep")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("unblockable", true)  # v4.6 FIX: Cannot be blocked
	hitbox.set_meta("telegraphed", true)
	
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = outer
	shape.shape = circle
	hitbox.add_child(shape)
	add_child(hitbox)
	_current_hitbox = hitbox

func _spawn_lane_hitbox(dir: Vector2, length: float, width: float, damage: int, parryable: bool) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_thrust")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", parryable)
	hitbox.set_meta("unblockable", not parryable)  # v4.6 FIX: Unparryable = unblockable
	hitbox.set_meta("telegraphed", true)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width)
	shape.shape = rect
	hitbox.add_child(shape)
	
	# Add to scene (not as child of boss) and position globally
	get_tree().current_scene.add_child(hitbox)
	hitbox.global_position = global_position + dir.normalized() * (length * 0.5)
	hitbox.rotation = dir.angle()
	_current_hitbox = hitbox

# FIX 2: Lane hitbox that follows boss during movement attacks
func _spawn_lane_hitbox_attached(dir: Vector2, length: float, width: float, damage: int, parryable: bool) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_thrust")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", parryable)
	hitbox.set_meta("unblockable", not parryable)  # v4.6 FIX: Unparryable = unblockable
	hitbox.set_meta("telegraphed", true)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width)
	shape.shape = rect
	hitbox.add_child(shape)
	
	# Add as child so it moves with boss
	add_child(hitbox)
	hitbox.position = dir.normalized() * (length * 0.5)
	hitbox.rotation = dir.angle()
	_current_hitbox = hitbox

# v4.8 FIX: Static lane hitbox for unblockable lunge attacks
# Spawns at a specific world position (matching telegraph), does NOT move with boss
# This allows player to dodge by moving perpendicular to the attack lane
func _spawn_lane_hitbox_static(start_pos: Vector2, dir: Vector2, length: float, width: float, damage: int, parryable: bool) -> void:
	_cleanup_hitbox()
	var hitbox = Area2D.new()
	hitbox.name = "BossHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "keeper_thrust")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", parryable)
	hitbox.set_meta("unblockable", not parryable)  # Unparryable = unblockable
	hitbox.set_meta("telegraphed", true)
	
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width)
	shape.shape = rect
	hitbox.add_child(shape)
	
	# Add to scene (NOT as child of boss) - stays in world space
	get_tree().current_scene.add_child(hitbox)
	# Position at the START position (where boss was when telegraph spawned)
	# Center of hitbox is at midpoint of the lane
	hitbox.global_position = start_pos + dir.normalized() * (length * 0.5)
	hitbox.rotation = dir.angle()
	_current_hitbox = hitbox

func _cleanup_hitbox() -> void:
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
		_current_hitbox.queue_free()
	
	_current_hitbox = null

# =============================================================================
# FLOOR TELEGRAPHS - v5.0: Fixed arc/circle telegraphs
# =============================================================================
func _spawn_lane_telegraph(dir: Vector2, length: float, width: float, duration: float) -> void:
	_cleanup_telegraph()
	var telegraph = Node2D.new()
	telegraph.name = "LaneTelegraph"
	var line = Line2D.new()
	line.width = width
	line.default_color = Color(0.9, 0.2, 0.1, 0.0)
	line.add_point(Vector2.ZERO)
	line.add_point(dir * length)
	telegraph.add_child(line)
	telegraph.global_position = global_position
	get_tree().current_scene.add_child(telegraph)
	_active_telegraph = telegraph
	var tween = create_tween()
	tween.tween_property(line, "default_color:a", 0.7, duration * 0.3)
	tween.tween_interval(duration * 0.7)
	tween.tween_callback(_cleanup_telegraph)

# v5.0 FIX: Arc telegraph now properly closes the polygon when inner_radius = 0
func _spawn_arc_telegraph(inner: float, outer: float, arc_deg: float, duration: float) -> void:
	_cleanup_telegraph()
	var telegraph = Node2D.new()
	telegraph.name = "ArcTelegraph"
	telegraph.global_position = global_position
	var poly = Polygon2D.new()
	poly.color = Color(0.9, 0.2, 0.1, 0.0)
	var points: PackedVector2Array = []
	var segments = 32  # v5.0: Increased from 24 for smoother arc
	var half_arc = deg_to_rad(arc_deg / 2.0)
	var facing_angle = _get_facing_direction().angle()
	
	# Draw outer arc from start to end
	for i in range(segments + 1):
		var t = float(i) / segments
		var angle = facing_angle + lerpf(-half_arc, half_arc, t)
		points.append(Vector2.from_angle(angle) * outer)
	
	# v5.0 FIX: When inner = 0, add center point to create proper wedge shape
	# When inner > 0, trace back along inner arc to create annular segment
	if inner > 0.1:  # Has inner radius - create annular segment
		for i in range(segments, -1, -1):
			var t = float(i) / segments
			var angle = facing_angle + lerpf(-half_arc, half_arc, t)
			points.append(Vector2.from_angle(angle) * inner)
	else:
		# No inner radius - add center point to create pie/wedge shape
		# This fixes the "cut off" appearance!
		points.append(Vector2.ZERO)
	
	poly.polygon = points
	telegraph.add_child(poly)
	get_tree().current_scene.add_child(telegraph)
	_active_telegraph = telegraph
	var tween = create_tween()
	tween.tween_property(poly, "color:a", 0.6, duration * 0.3)
	tween.tween_interval(duration * 0.7)
	tween.tween_callback(_cleanup_telegraph)

# Standard circle telegraph - positions at a specific world location (for LEAPING_SLAM)
func _spawn_circle_telegraph(center: Vector2, radius: float, duration: float) -> void:
	_cleanup_telegraph()
	var telegraph = Node2D.new()
	telegraph.name = "CircleTelegraph"
	telegraph.global_position = center
	var poly = Polygon2D.new()
	poly.color = Color(0.9, 0.2, 0.1, 0.0)
	var points: PackedVector2Array = []
	var segments = 32  # v5.0: Increased for smoother circle
	for i in range(segments):
		points.append(Vector2.from_angle((float(i) / segments) * TAU) * radius)
	poly.polygon = points
	telegraph.add_child(poly)
	get_tree().current_scene.add_child(telegraph)
	_active_telegraph = telegraph
	var tween = create_tween()
	tween.tween_property(poly, "color:a", 0.7, duration * 0.2)
	tween.tween_interval(duration * 0.8)
	tween.tween_callback(_cleanup_telegraph)

# v5.0: New centered circle telegraph - positions centered on boss (for SAVAGE_SWEEP)
func _spawn_circle_telegraph_centered(radius: float, duration: float) -> void:
	_cleanup_telegraph()
	var telegraph = Node2D.new()
	telegraph.name = "CircleTelegraph"
	telegraph.global_position = global_position
	var poly = Polygon2D.new()
	poly.color = Color(0.9, 0.2, 0.1, 0.0)
	var points: PackedVector2Array = []
	var segments = 32  # Smooth circle
	for i in range(segments):
		points.append(Vector2.from_angle((float(i) / segments) * TAU) * radius)
	poly.polygon = points
	telegraph.add_child(poly)
	
	# Add as child of boss so it follows position during telegraph
	add_child(telegraph)
	telegraph.position = Vector2.ZERO  # Centered on boss
	_active_telegraph = telegraph
	var tween = create_tween()
	tween.tween_property(poly, "color:a", 0.7, duration * 0.2)
	tween.tween_interval(duration * 0.8)
	tween.tween_callback(_cleanup_telegraph)

func _cleanup_telegraph() -> void:
	if is_instance_valid(_active_telegraph): _active_telegraph.queue_free()
	_active_telegraph = null

# =============================================================================
# v4.5 FIX: SAFE FLASH FUNCTIONS - Use centralized modulate restoration
# =============================================================================
func _flash_perilous_warning() -> void:
	"""Flashes red for perilous/unblockable attacks. Uses safe restoration."""
	if not sprite or _is_flashing: return
	_is_flashing = true
	
	sprite.modulate = Color(1.5, 0.3, 0.3, 1.0)
	await get_tree().create_timer(0.15).timeout
	
	# v4.5 FIX: Use centralized restoration instead of stored 'orig'
	if is_instance_valid(sprite) and not _dbroken_active and _boss_phase != BossPhase.DEAD:
		_restore_modulate()
	_is_flashing = false

# =============================================================================
# DAMAGE HANDLING - Phase 2 triggers when HP first hits 0
# =============================================================================
func _apply_damage(damage: int, _damage_type: String, _attacker: Node) -> void:
	"""Centralized damage application. Phase 2 triggers when HP first hits 0 in Phase 1."""
	if _boss_phase == BossPhase.DEAD:
		return
	
	var hp_before = hp
	hp = maxi(hp - damage, 0)

	# Bloodletting Gourd: lifesteal
	if damage > 0:
		var player = _get_player()
		if is_instance_valid(player):
			ProstheticEffects.check_lifesteal(player, damage)
	
	# Force HP bar update immediately
	_update_bars()
	
	if hp <= 0:
		if _boss_phase == BossPhase.PHASE_1:
			# Phase 1 HP depleted -> Trigger Phase 2 transition (don't die yet)
			print("[Keeper] HP hit 0 in Phase 1 - triggering Phase 2 transition!")
			_trigger_phase_transition()
		else:
			# Phase 2 HP depleted -> Actually die
			_die()
	else:
		_flash_hurt_sprite()

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _boss_phase == BossPhase.DEAD or attacker == null: return
	if damage <= 0 and not (attacker is Area2D and attacker.has_meta("prosthetic_source")): return
	
	var is_player_attack = attacker.is_in_group("player")
	if not is_player_attack and attacker is Area2D and attacker.has_meta("attacker"):
		var meta_attacker = attacker.get_meta("attacker")
		if meta_attacker is Node and meta_attacker.is_in_group("player"): is_player_attack = true
	if not is_player_attack and attacker.is_in_group("attack"):
		var owner_check: Node = attacker.get_parent()
		while owner_check != null:
			if owner_check.is_in_group("player"): is_player_attack = true; break
			if owner_check.is_in_group("enemy"): break
			owner_check = owner_check.get_parent()
	if not is_player_attack: return
	
	var final_damage = damage
	var posture_mult = 1.0
	if _is_in_windup():
		final_damage = int(round(float(damage) * windup_damage_mult))
		posture_mult = windup_posture_mult
	
	if combat:
		var posture_event = {"damage": final_damage, "blocked": false}
		if posture_mult < 1.0 and combat.config:
			var orig_gain = combat.config.hit_posture_gain
			combat.config.hit_posture_gain = orig_gain * posture_mult
			combat.notify_got_hit(posture_event)
			combat.config.hit_posture_gain = orig_gain
		else:
			combat.notify_got_hit(posture_event)
	
	_apply_damage(final_damage, damage_type, attacker)

	# === PROSTHETIC EFFECTS (centralized, boss resistance) ===
	ProstheticEffects.apply(attacker, self, false, 0.5)

func _flash_hurt_sprite() -> void:
	"""Damage flash. Uses safe restoration to prevent stuck tints."""
	if not sprite or _is_flashing:
		return
	
	_is_flashing = true
	sprite.modulate = Color(1.5, 1.5, 1.5)
	
	await get_tree().create_timer(0.08).timeout
	
	if is_instance_valid(sprite) and not _dbroken_active and _boss_phase != BossPhase.DEAD:
		_restore_modulate()
	
	_is_flashing = false
	
func on_parried(parry_source_pos: Vector2) -> void:
	if _dbroken_active or _boss_phase == BossPhase.DEAD: return
	_hide_parry_indicator()
	
	if combat and combat.config:
		var current = combat.get_posture()
		var maxv = combat.config.posture_max
		combat.set_posture(minf(current + parry_posture_damage, maxv))
		combat.notify_got_hit({"damage": 0, "parried": true})
		combat.suppress_recovery(1.0)
	
	_cleanup_hitbox()
	_parry_flash_tint()
	
	if _current_attack in [AttackType.BLADE_DANCE, AttackType.FERAL_ONSLAUGHT]:
		_combo_is_frozen = true
		_combo_parry_freeze_until = Time.get_ticks_msec() * 0.001 + parry_hitstop_duration
		return
	
	_combo_interrupted = true
	_attack_sequence_id += 1
	_start_parry_recoil(parry_source_pos)
	
	if anim:
		if anim.has_animation("parried"): anim.play("parried")
		elif anim.has_animation("stagger"): anim.play("stagger")
		else: anim.play("idle")
	
	await get_tree().create_timer(0.25).timeout
	if not is_instance_valid(self) or _boss_phase == BossPhase.DEAD or _dbroken_active: return
	
	_parry_recoil_until = 0.0
	_parry_recoil_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_play_anim("idle")
	_attack_cooldown = _rng.randf_range(phase1_min_cooldown * 0.8, phase1_max_cooldown * 1.2)

func _start_parry_recoil(parry_source_pos: Vector2) -> void:
	var away = (global_position - parry_source_pos).normalized()
	if away == Vector2.ZERO: away = Vector2.RIGHT
	_parry_recoil_velocity = away * 150.0
	_parry_recoil_until = Time.get_ticks_msec() * 0.001 + 0.12

# v4.5 FIX: Safe parry flash that uses centralized restoration
func _parry_flash_tint() -> void:
	"""Parry flash. Uses safe restoration to prevent stuck tints."""
	if not sprite or _is_flashing: return
	_is_flashing = true
	
	sprite.modulate = Color(1.0, 1.0, 1.5)
	await get_tree().create_timer(0.10).timeout
	
	# v4.5 FIX: Use centralized restoration
	if is_instance_valid(sprite) and not _dbroken_active and _boss_phase != BossPhase.DEAD:
		_restore_modulate()
	_is_flashing = false

func _on_posture_changed(current: float, max_value: float) -> void:
	_update_posture_bar(current, max_value)

func _on_posture_broken(duration: float) -> void:
	if _dbroken_active or _boss_phase == BossPhase.DEAD: return
	_hide_parry_indicator()
	
	var window = duration if duration > 0.0 else deathblow_window_duration
	
	_attack_sequence_id += 1
	_trigger_posture_break(window)
	
	var now = Time.get_ticks_msec() * 0.001
	_dbroken_active = true
	_dbreak_until = now + window
	_dbreak_immunity_until = now + deathblow_immunity_time
	
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	
	_cleanup_hitbox()
	
	if anim:
		if anim.has_animation("stunned"): anim.play("stunned")
		elif anim.has_animation("stagger"): anim.play("stagger")
		else: anim.play("idle")
	
	_start_posture_break_flash()
	emit_signal("posture_broken", window)

func _trigger_posture_break(duration: float) -> void:
	add_to_group("deathblow_target")
	
	var player = _get_player()
	if player:
		var pc = player.get_node_or_null("Combat")
		if pc and pc.has_method("set_deathblow_target"):
			pc.set_deathblow_target(self, duration)
		elif pc and pc.has_signal("deathblow_available"):
			pc.emit_signal("deathblow_available", self, duration)

func _end_deathblow_window() -> void:
	if not _dbroken_active: return
	print("[Keeper] Deathblow window EXPIRED - boss recovers!")
	
	_clear_deathblow_state()
	_deathblow_in_progress = false
	
	# Recover some posture so we don't re-break instantly
	if combat and combat.config:
		var maxv = combat.config.posture_max
		combat.set_posture(maxv * 0.35)
	elif combat:
		combat.set_posture(0.0)
	
	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = 1.0
	emit_signal("posture_recovered")

# =============================================================================
# DEATHBLOW STATE HELPER (matches Shield Captain pattern)
# =============================================================================
func _clear_deathblow_state() -> void:
	"""Centralized deathblow state clearing - ensures flash is ALWAYS stopped."""
	_dbroken_active = false
	_dbreak_until = -1.0
	_dbreak_immunity_until = -1.0
	
	# Remove from deathblow_target group
	if is_in_group("deathblow_target"):
		remove_from_group("deathblow_target")
	
	# CRITICAL: Stop the posture break flash and restore modulate
	_stop_posture_break_flash()
	
	# Clear player's combat controller deathblow state
	var player = _get_player()
	if player:
		var pc = player.get_node_or_null("Combat")
		if pc and pc.has_signal("deathblow_cleared"):
			pc.emit_signal("deathblow_cleared")

# =============================================================================
# DEATHBLOW HANDLING - Always deals damage, phase transition via _apply_damage
# =============================================================================
func take_deathblow(attacker: Node) -> void:
	# Only valid while posture is broken and we're alive
	if _boss_phase == BossPhase.DEAD:
		return
	if not _dbroken_active:
		print("[Keeper] take_deathblow called but not in deathblow state!")
		return
	# Prevent re-entry during async operations
	if _deathblow_in_progress:
		print("[Keeper] take_deathblow already in progress, ignoring duplicate call")
		return
	_deathblow_in_progress = true
	
	# v4.5 FIX: Cancel any active flash before deathblow visuals
	_is_flashing = false
	
	var hp_before = hp
	var phase_before = _boss_phase
	print("[Keeper] DEATHBLOW EXECUTED! Phase: ", _boss_phase, " HP before: ", hp_before)
	
	# Fully drain posture on a successful finisher
	if combat and combat.config:
		combat.set_posture(0.0)
	
	# Clear all deathblow state FIRST (stops flash, clears flags)
	_clear_deathblow_state()
	
	# Stop all movement and actions
	_behavior_state = BehaviorState.STAGGERED
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	
	# === FIX: Apply damage IMMEDIATELY for instant HP bar feedback ===
	# This makes the deathblow feel responsive - player sees HP chunk disappear right away
	print("[Keeper] Dealing deathblow damage: ", deathblow_damage)
	_apply_damage(deathblow_damage, "deathblow", attacker)
	
	print("[Keeper] DEATHBLOW complete. HP: ", hp_before, " -> ", hp, " Phase: ", phase_before, " -> ", _boss_phase)
	
	# Check if we died or transitioned BEFORE doing long visuals
	if _boss_phase == BossPhase.DEAD:
		# Do quick death visual then exit
		await _do_deathblow_visuals_quick()
		_deathblow_in_progress = false
		emit_signal("posture_recovered")
		return
	
	# Check if we just transitioned to Phase 2
	if _boss_phase == BossPhase.PHASE_2 and phase_before == BossPhase.PHASE_1:
		# Phase transition handles its own visuals
		_deathblow_in_progress = false
		emit_signal("posture_recovered")
		return
	
	# Still alive - do full deathblow visuals AFTER damage is applied
	await _do_deathblow_visuals()
	
	emit_signal("posture_recovered")
	
	# Still alive in current phase - recover and resume fighting
	if anim and anim.has_animation("hurt"):
		anim.play("hurt")
	
	await get_tree().create_timer(0.5).timeout
	if not is_instance_valid(self) or _boss_phase == BossPhase.DEAD:
		_deathblow_in_progress = false
		return
	
	# v4.6 FIX: REMOVED duplicate combat.reset_posture() call here
	# Posture was already reset at the start of deathblow (line 1913-1914)
	# The old code called reset_posture() AGAIN after 0.5s, which caused
	# the bug where posture would briefly increase then snap back to 0
	# if the player attacked quickly after the deathblow finished
	
	_deathblow_in_progress = false
	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = 1.2
	_play_anim("idle")

func _do_deathblow_visuals_quick() -> void:
	"""Quick hitstop + flash for death/transition scenarios (damage already applied)."""
	# Screen shake effect
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("shake"):
		camera.shake(0.5, 15.0)  # Stronger for death
	
	# Quick hitstop
	Engine.time_scale = 0.05
	await get_tree().create_timer(0.012).timeout
	Engine.time_scale = 1.0
	
	# Quick white flash only
	if sprite:
		sprite.modulate = Color(4.0, 4.0, 4.0, 1.0)
		await get_tree().create_timer(0.05).timeout
		if is_instance_valid(sprite):
			# v4.5 FIX: Use centralized restoration
			_restore_modulate()

# v4.5 FIX: Deathblow visuals with guaranteed proper restoration
func _do_deathblow_visuals() -> void:
	# Screen shake effect (if camera supports it)
	var camera = get_viewport().get_camera_2d()
	if camera and camera.has_method("shake"):
		camera.shake(0.4, 12.0)
	
	# Hitstop effect (brief game pause for impact)
	Engine.time_scale = 0.05
	await get_tree().create_timer(0.015).timeout  # Very short real-time pause
	Engine.time_scale = 1.0
	
	# Strong visual flash on the boss
	if sprite:
		# White flash (impact)
		sprite.modulate = Color(4.0, 4.0, 4.0, 1.0)
		await get_tree().create_timer(0.06).timeout
		if not is_instance_valid(sprite): return
		
		# Red flash (damage)
		sprite.modulate = Color(2.0, 0.2, 0.2, 1.0)
		await get_tree().create_timer(0.1).timeout
		if not is_instance_valid(sprite): return
		
		# Orange flash
		sprite.modulate = Color(1.5, 0.6, 0.2, 1.0)
		await get_tree().create_timer(0.08).timeout
		if not is_instance_valid(sprite): return
		
		# v4.5 FIX: Use centralized restoration
		_restore_modulate()

# =============================================================================
# POSTURE BREAK FLASH - v4.5 FIX: Reliable cleanup
# =============================================================================
func _start_posture_break_flash() -> void:
	_stop_posture_break_flash()  # Clean up any existing flash first
	
	if not sprite: return
	
	_posture_break_flash_on = false
	_posture_break_flash_timer = Timer.new()
	_posture_break_flash_timer.wait_time = 0.12
	_posture_break_flash_timer.autostart = true
	add_child(_posture_break_flash_timer)
	_posture_break_flash_timer.timeout.connect(_on_posture_break_flash_tick)

func _on_posture_break_flash_tick() -> void:
	if not is_instance_valid(sprite) or _boss_phase == BossPhase.DEAD or not _dbroken_active:
		_stop_posture_break_flash()
		return
	
	_posture_break_flash_on = not _posture_break_flash_on
	if _posture_break_flash_on:
		sprite.modulate = Color(1.0, 0.4, 0.4, 1.0)  # Red tint
	else:
		sprite.modulate = Color(1.5, 1.5, 1.5, 1.0)  # White flash

func _stop_posture_break_flash() -> void:
	if _posture_break_flash_timer:
		_posture_break_flash_timer.stop()
		if _posture_break_flash_timer.timeout.is_connected(_on_posture_break_flash_tick):
			_posture_break_flash_timer.timeout.disconnect(_on_posture_break_flash_tick)
		_posture_break_flash_timer.queue_free()
		_posture_break_flash_timer = null
	
	_posture_break_flash_on = false
	
	# v4.5 FIX: Use centralized restoration
	_restore_modulate()
	
	print("[Keeper] Flash stopped, modulate restored to: ", sprite.modulate if sprite else "no sprite")

# =============================================================================
# PHASE TRANSITION - Called when HP first hits 0 in Phase 1
# =============================================================================
func _trigger_phase_transition() -> void:
	if _boss_phase != BossPhase.PHASE_1: 
		return
	
	print("[Keeper] === PHASE TRANSITION STARTING ===")
	
	# v4.5 FIX: Cancel any active flashing
	_is_flashing = false
	
	# Clear any lingering deathblow state
	if _dbroken_active:
		_clear_deathblow_state()
	
	_behavior_state = BehaviorState.TRANSITIONING
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_attack_sequence_id += 1
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	_cleanup_telegraph()
	
	if combat: 
		combat.reset_posture()
	
	# RESTORE HP FOR PHASE 2 - Boss gets a second health bar
	hp = get_max_hp()
	_update_bars()
	print("[Keeper] HP restored to ", hp, " for Phase 2")
	
	# v4.5: Reset attack variety tracking for Phase 2
	_attack_history.clear()
	_attack_last_used.clear()
	_consecutive_close_attacks = 0
	_needs_spacing_attack = false
	
	# Play transformation animation (use overhead_windup as dramatic pose)
	_play_anim("overhead_windup")
	
	# Visual transformation effect
	if sprite:
		var tween = create_tween()
		# Flash white
		tween.tween_property(sprite, "modulate", Color(2.0, 2.0, 2.0), 0.2)
		# Transition to beast red tint
		tween.tween_property(sprite, "modulate", Color(1.3, 0.5, 0.4), 0.4)
		# Settle to slightly red (beast form indicator)
		tween.tween_property(sprite, "modulate", Color(1.1, 0.9, 0.9), 0.4)
	
	# Brief invulnerability during transition
	await get_tree().create_timer(1.5).timeout
	
	if not is_instance_valid(self): 
		return
	
	_boss_phase = BossPhase.PHASE_2
	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = 0.5
	
	print("[Keeper] === PHASE 2 ACTIVE - Beast Mode ===")
	emit_signal("phase_changed", 2)

func death() -> void:
	_die()


func _die() -> void:
	if _boss_phase == BossPhase.DEAD:
		return
	
	if not mark_dead():
		return
	
	_boss_phase = BossPhase.DEAD
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	_attack_sequence_id += 1
	
	_cleanup_hitbox()
	_cleanup_telegraph()
	
	_is_flashing = false
	_stop_posture_break_flash()
	_hide_parry_indicator()
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if _bars_container:
		_bars_container.visible = false
	
	if is_in_group("boss"):
		remove_from_group("boss")
	
	if is_in_group("keeper"):
		remove_from_group("keeper")
	
	emit_signal("defeated")
	emit_signal("enemy_died", self)
	
	_run_humanoid_death_rewards()
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		var start = Time.get_ticks_msec() * 0.001
		
		while anim.is_playing() and (Time.get_ticks_msec() * 0.001 - start) < 4.0:
			await get_tree().process_frame
	else:
		await get_tree().create_timer(1.0).timeout
	
	if not is_instance_valid(self):
		return
	
	if sprite:
		sprite.visible = false
	
	queue_free()

# =============================================================================
# UTILITIES
# =============================================================================
func _get_player() -> Node:
	var p = get_tree().get_first_node_in_group("player")
	return p if p and p is Node2D else null

func _face_player() -> void:
	var player = _get_player()
	if player: _face_direction((player.global_position - global_position).normalized())

func _face_direction(dir: Vector2) -> void:
	if dir == Vector2.ZERO or not sprite or absf(dir.x) < 0.1: return
	sprite.flip_h = dir.x > 0.0

func _get_facing_direction() -> Vector2:
	return Vector2.RIGHT if sprite and sprite.flip_h else Vector2.LEFT

func _play_anim(anim_name: String) -> void:
	if _boss_phase == BossPhase.DEAD or not anim: return
	if anim.has_animation(anim_name) and anim.current_animation != anim_name: anim.play(anim_name)

func _wait_interruptible(duration: float, seq_id: int) -> bool:
	var elapsed = 0.0
	while elapsed < duration:
		if _should_abort_attack(seq_id): return false
		if _combo_is_frozen:
			await get_tree().physics_frame
			if not is_instance_valid(self): return false
			continue
		await get_tree().physics_frame
		if not is_instance_valid(self): return false
		elapsed += get_physics_process_delta_time()
	return true

func _lunge_toward(dir: Vector2, distance: float, speed: float, duration: float, seq_id: int) -> bool:
	if dir == Vector2.ZERO or speed <= 0: return not _should_abort_attack(seq_id)
	var player = _get_player()
	var current_dist = 999.0
	if player: current_dist = (player.global_position - global_position).length()
	
	# Don't lunge if already too close
	if current_dist < lunge_min_distance: return not _should_abort_attack(seq_id)
	
	# SEKIRO-STYLE: Cap maximum distance the lunge can close
	var max_close = minf(distance, max_lunge_close_distance)
	var target_dist = current_dist - max_close
	
	if target_dist < ideal_combat_distance * 0.5:
		max_close = current_dist - (ideal_combat_distance * 0.5)
	
	var adjusted = maxf(0.0, minf(distance, max_close))
	
	if current_dist < ideal_combat_distance:
		adjusted = adjusted * clampf((current_dist - lunge_min_distance) / (ideal_combat_distance - lunge_min_distance), 0.0, 1.0)
	
	if adjusted < 5.0: return not _should_abort_attack(seq_id)
	
	var start_pos = global_position
	var elapsed = 0.0
	var adj_dur = adjusted / speed if speed > 0 else duration
	while elapsed < adj_dur:
		if _should_abort_attack(seq_id): velocity = Vector2.ZERO; return false
		if _combo_is_frozen:
			velocity = Vector2.ZERO
			while _combo_is_frozen:
				if _should_abort_attack(seq_id): return false
				await get_tree().physics_frame
				if not is_instance_valid(self): return false
			continue
		if global_position.distance_to(start_pos) >= adjusted: velocity = Vector2.ZERO; return true
		velocity = dir.normalized() * speed
		await get_tree().physics_frame
		if not is_instance_valid(self): return false
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO
	return not _should_abort_attack(seq_id)

func get_enemy_damage() -> int:
	return blade_dance_damage

func _is_guarding() -> bool:
	if _boss_phase == BossPhase.DEAD:
		return false
	
	if _dbroken_active:
		return false
	
	if _combat_phase != CombatPhase.NONE:
		return false
	
	if _is_backstepping:
		return false
	
	if _parry_recoil_until > 0.0 and Time.get_ticks_msec() * 0.001 < _parry_recoil_until:
		return false
	
	return true
