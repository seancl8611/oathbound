extends HumanoidEnemyBase
class_name VillageOgre

@export var base_movement_speed := 60.0

# =============================================================================
# POSTURE / DEATHBLOW SETTINGS
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage := 25.0
@export var block_posture_damage := 8.0
@export var deathblow_window_duration := 3.0
@export var deathblow_immunity_time := 0.3
@export var deathblow_damage := 75
@export var deathblow_instant_kill := false
@export var deathblow_pips := 1

# =============================================================================
# NEW v10.0: WINDUP ARMOR SYSTEM
# =============================================================================
@export_group("Windup Armor")
## Damage multiplier during windup (0.6 = 40% reduction)
@export var windup_damage_mult := 0.6
## Posture damage multiplier during windup
@export var windup_posture_mult := 0.5
## Also reduces knockback during windup
@export var windup_knockback_mult := 0.3
## Flash color when hit during windup (visual feedback)
@export var windup_hit_flash_color := Color(0.8, 0.9, 1.0, 1.0)

# =============================================================================
# PARRY WINDOW TIMING - v11.0 MORE GENEROUS
# =============================================================================
@export_group("Parry Timing")
## How early before active frames the hitbox becomes parryable (seconds)
@export var parry_early_window := 0.12   # Was 0.15 - slightly earlier
## How long after active starts the parry window stays open (linger)
@export var parry_linger_window := 0.20  # Was 0.20 - longer linger
## Total "parryable" duration = parry_early_window + parry_linger_window
## Minimum time hitbox must exist before cleanup (prevents instant-vanish)
@export var hitbox_min_lifetime := 0.15  # NEW - ensures hitbox is detectable

# =============================================================================
# SEKIRO-STYLE BLOCKING SETTINGS
# =============================================================================
@export_group("Guard / Blocking")
@export var guard_block_series_timeout := 1.7
@export var guard_block_tolerance_min := 2
@export var guard_block_tolerance_max := 3
@export var guard_chip_damage_mult := 0.0
@export var guard_frontal_cone := 120.0
@export var guard_block_chance := 0.90
@export var deflect_pause_time := 0.15

# =============================================================================
# BACKSTEP SYSTEM
# =============================================================================
@export_group("Backstep System")
@export var melee_pressure_threshold := 4.2
@export var melee_staleness_threshold := 3
@export var backstep_speed := 250.0
@export var backstep_duration := 0.35
@export var backstep_recovery := 0.2
@export var backstep_chance := 0.35
@export var backstep_ranged_preference := 0.75

# =============================================================================
# DISTANCE THRESHOLDS
# =============================================================================
@export_group("Distance Thresholds")
@export var close_range := 100.0
@export var mid_range := 200.0
@export var far_range := 300.0
@export var cannon_min_range := 120.0
@export var parry_ideal_range := 90.0

# =============================================================================
# v17.0: SPACING SYSTEM - Prevents face-hugging
# =============================================================================
@export_group("Spacing System")
## Ideal distance for melee combat (Sekiro-style dueling range)
@export var ideal_combat_distance := 70.0
## Below this = face-hugging zone, need to back off
@export var too_close_threshold := 40.0
## Don't lunge if already closer than this
@export var lunge_min_distance := 30.0
## Minimum separation enforced by soft collision
@export var min_separation := 25.0
## Chance to do a spacing adjustment after finishing a melee combo
@export var post_combo_spacing_chance := 0.35
## Max distance for post-attack spacing slide
@export var spacing_slide_distance := 45.0
## Speed of spacing slide
@export var spacing_slide_speed := 100.0

# =============================================================================
# APPROACH BEHAVIOR
# =============================================================================
@export_group("Approach Behavior")
@export var approach_speed := 140.0
@export var approach_acceleration := 40.0
@export var approach_max_speed := 180.0
@export var approach_commitment_time := 3.5
@export var approach_give_up_distance := 250.0

# =============================================================================
# SHIELD ADVANCE (Gap Closer) - PARRYABLE during charge
# v10.0: Hitbox spawns 0.15s before charge with parry linger
# =============================================================================
@export_group("Shield Advance")
@export var shield_advance_speed := 280.0
@export var shield_advance_duration := 0.5
@export var shield_advance_recovery := 0.4
@export var shield_advance_damage := 10
@export var shield_advance_windup := 0.55

@export var gap_close_chance := 0.7

# =============================================================================
# OVERHEAD BREAKER - PARRYABLE at impact
# v10.0: Impact hitbox spawns 0.12s before slam with linger
# =============================================================================
@export_group("Overhead Breaker")
@export var overhead_windup_time := 0.95
@export var overhead_recovery_time := 0.7
@export var overhead_slam_radius := 65.0
@export var overhead_slam_damage := 14
## NEW: Pre-impact parry window
@export var overhead_parry_preframe := 0.12

# =============================================================================
# TRIPLE COMBO - PARRYABLE (each hit)
# v11.0: SLOWED DOWN for readable rhythm and reliable parry windows
# =============================================================================
@export_group("Triple Combo - Timing")
@export var combo_initial_windup := 0.45  # Was 0.55 - more telegraph
@export var combo_parry_resume_delay := 0.15
@export var combo_parry_hitstop := 0.12
@export var combo1_anticipation := 0.30  # Was 0.35
@export var combo_hits_use_knockback := false
@export var combo1_active_time := 0.18   # Was 0.22
@export var combo1_recovery := 0.45      # Was 0.18 - MUCH longer recovery window
@export var combo2_anticipation := 0.42  # Was 0.32
@export var combo2_active_time := 0.10   # Was 0.22
@export var combo2_recovery := 0.38      # v18.0: Increased for breathing room before finisher
@export var combo_finisher_windup := 0.55  # Was 0.75 - big telegraph for big hit
@export var combo_finisher_active := 0.20  # Was 0.30
@export var combo_final_recovery := 0.45   # Was 0.70 - punish window after finisher
@export var combo_tracking_rate := 45.0
## v18.0: Gap between combo hits to prevent animation overlap
@export var combo_inter_hit_gap := 0.12

@export_group("Triple Combo - Movement")
@export var combo1_lunge_distance := 40.0
@export var combo1_lunge_speed := 450.0
@export var combo2_lunge_distance := 30.0
@export var combo2_lunge_speed := 400.0
@export var combo_finisher_step := 35.0
@export var combo_finisher_step_speed := 120.0
@export var combo_lunge_tracking := 35.0
@export var combo_retarget_between_hits := true

@export_group("Triple Combo - Damage")
@export var combo1_damage := 8
@export var combo2_damage := 10
@export var combo_finisher_damage := 16
@export var combo_swing_length := 80.0
@export var combo_swing_width := 60.0

# =============================================================================
# CANNONFIRE MARK - NOT PARRYABLE
# =============================================================================
@export_group("Cannonfire Mark")
@export var cannon_warning_time := 0.8
@export var cannon_pattern_recovery := 0.7
@export var cannon_min_marks := 2
@export var cannon_max_marks := 4
@export var cannon_inner_radius := 80.0
@export var cannon_outer_radius := 160.0
@export var cannon_aoe_radius := 50.0
@export var cannon_aoe_damage := 10
@export var cannon_mark_linger := 0.5
# =============================================================================
# HAMMER SPIN - NOT PARRYABLE, NOT BLOCKABLE
# =============================================================================
@export_group("Hammer Spin")
@export var spin_duration := 4.5
@export var spin_move_speed := 110.0
@export var spin_turn_rate_deg := 65.0
@export var spin_hit_radius := 55.0
@export var spin_hitbox_size := 28.0
@export var spin_damage := 10
@export var spin_orbit_speed_deg := 540.0
@export var spin_min_range := 120.0
@export var spin_global_cooldown := 10.0
@export var spin_recovery := 0.7
@export var spin_hit_cooldown := 0.4

# =============================================================================
# ATTACK PACING & DESIRE SYSTEM
# =============================================================================
@export_group("Attack Pacing")
@export var min_attack_cooldown := 1.2
@export var max_attack_cooldown := 2.0

@export_group("Desire System - Base Chances")
@export var cannon_base_chance := 0.10
@export var overhead_base_chance := 0.12
@export var combo_base_chance := 0.12
@export var spin_base_chance := 0.08
@export var shield_advance_base_chance := 0.15

@export_group("Desire System - Growth Per Skip")
@export var cannon_desire_growth := 0.12
@export var overhead_desire_growth := 0.10
@export var combo_desire_growth := 0.10
@export var spin_desire_growth := 0.08
@export var shield_advance_desire_growth := 0.08

@export_group("Desire System - Caps")
@export var max_desire := 0.60

# =============================================================================
# STATE MACHINE
# =============================================================================
enum Phase { ALIVE, DEAD }
enum BehaviorState { IDLE, PURSUING, APPROACHING, ATTACKING, BACKSTEPPING }
enum AttackType { NONE, SHIELD_ADVANCE, OVERHEAD_BREAKER, CANNONFIRE_MARK, HAMMER_SPIN, TRIPLE_COMBO }
enum AttackCategory { NONE, MELEE, RANGED, SPECIAL }

# v10.0: Combat phase tracking for armor system
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

@export var ogre_max_hp: int = 220
var _phase := Phase.ALIVE
var _behavior_state := BehaviorState.IDLE
var _current_attack := AttackType.NONE
var _pending_melee_attack := AttackType.NONE
var _pending_ranged_attack := AttackType.NONE

var _combo_hit_index := 0          # Which hit we're on (1, 2, or 3)
var _combo_parry_freeze_until := 0.0  # Hitstop end time
var _combo_is_frozen := false      # Currently in hitstop?
var _combo_should_continue := true # Still executing combo?

# v10.0: Current combat phase for windup armor
var _combat_phase := CombatPhase.NONE

var _posture_break_flash_timer: Timer = null
var _posture_break_flash_on: bool = false
var _base_modulate: Color = Color(1, 1, 1)

var _attack_cooldown := 0.0
var _approach_timer := 0.0
var _approach_current_speed := 0.0
var _spin_cooldown := 0.0
var _cannon_cooldown := 0.0
var _consecutive_ranged_attacks := 0

@export var cannon_cooldown := 5.0
@export var max_consecutive_ranged := 2

var _current_pip := 1

var _guarding := false
var _guard_block_count := 0
var _guard_last_block_ts := 0.0

var _cannon_desire := 0.0
var _overhead_desire := 0.0
var _combo_desire := 0.0
var _spin_desire := 0.0
var _shield_advance_desire := 0.0

var _spin_hit_targets: Dictionary = {}
var _current_hitbox: Area2D = null
var _combo_interrupted := false
var _attack_sequence_id := 0

var _dbroken_active := false
var _dbreak_until := -1.0
var _dbreak_immunity_until := 0.0
var _deathblow_in_progress := false
var _stun_until := 0.0

# Short parry recoil after a successful deflect
var _parry_recoil_until: float = 0.0
var _parry_recoil_velocity: Vector2 = Vector2.ZERO
const PARRY_INDICATOR_DURATION := 0.22
# =============================================================================
# v12.0: COMBO-PARRY SYNCHRONIZATION SYSTEM
# =============================================================================
# When parried mid-combo, the combo coroutine must WAIT for stagger to finish
# before continuing. This prevents hits from coming out during recoil.
var _parry_stagger_until: float = 0.0  # Combo waits for this to expire
var _post_parry_recovery: float = 0.28  # Extra breathing room after recoil ends

var _melee_pressure_time := 0.0
var _consecutive_melee_attacks := 0
var _last_attack_category := AttackCategory.NONE
var _backstep_direction := Vector2.ZERO
var _post_backstep_ranged := false

var _last_token_frame: int = -1
var _seen_tokens_this_frame := {}

var _rng := RandomNumberGenerator.new()

var _bars_container: Node2D
var _ogre_posture_bg: ColorRect
var _ogre_posture_fill: ColorRect
var _hp_bg: ColorRect
var _hp_fill: ColorRect

signal defeated
signal posture_broken(duration: float)
signal posture_recovered

# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	super._ready()
	
	hp = ogre_max_hp
	_max_hp = ogre_max_hp
	
	_current_pip = 1
	_guarding = false
	_guard_block_count = 0
	_guard_last_block_ts = 0.0
	_melee_pressure_time = 0.0
	_consecutive_melee_attacks = 0
	_attack_sequence_id = 0
	_combat_phase = CombatPhase.NONE
	
	_rng.randomize()
	
	add_to_group("brute")
	add_to_group("village_ogre")
	
	if combat and not combat.config:
		combat.config = CombatConfig.create_boss_config()
	
	if combat:
		if combat.has_method("update_health_ratio"):
			combat.update_health_ratio(float(hp), float(get_max_hp()))
		
		if not combat.is_connected("posture_changed", Callable(self, "_on_posture_changed")):
			combat.connect("posture_changed", Callable(self, "_on_posture_changed"))
		
		if not combat.is_connected("posture_broken", Callable(self, "_on_posture_broken")):
			combat.connect("posture_broken", Callable(self, "_on_posture_broken"))
		
		var maxv := combat.config.posture_max if combat.config else 100.0
		combat.emit_signal("posture_changed", 0.0, maxv)
	_setup_dual_bars()
	_update_bars()

# =============================================================================
# v10.0: COMBAT PHASE MANAGEMENT
# =============================================================================
func _set_combat_phase(phase: CombatPhase) -> void:
	_combat_phase = phase

func _is_in_windup() -> bool:
	return _combat_phase == CombatPhase.WINDUP

func _is_in_active() -> bool:
	return _combat_phase == CombatPhase.ACTIVE

func _is_in_recovery() -> bool:
	return _combat_phase == CombatPhase.RECOVERY

# =============================================================================
# v12.0: PARRY STAGGER STATE HELPERS
# =============================================================================
func _is_in_parry_stagger() -> bool:
	"""Returns true if we're currently staggered from a parry."""
	var now := Time.get_ticks_msec() * 0.001
	return now < _parry_stagger_until

func _is_in_parry_recoil() -> bool:
	"""Returns true if we're currently in parry recoil motion."""
	var now := Time.get_ticks_msec() * 0.001
	return _parry_recoil_until > 0.0 and now < _parry_recoil_until

# =============================================================================
# v17.0: SPACING SYSTEM HELPERS
# =============================================================================
func _is_face_hugging() -> bool:
	"""Returns true if enemy is too close to the player."""
	var player := _get_player()
	if not player:
		return false
	var dist = (player.global_position - global_position).length()
	return dist < too_close_threshold

func _get_current_distance_to_player() -> float:
	"""Returns current distance to player, or -1 if no player."""
	var player := _get_player()
	if not player:
		return -1.0
	return (player.global_position - global_position).length()

func _calculate_needed_lunge(base_distance: float, attack_range: float) -> float:
	"""
	v17.0: Calculate actual lunge distance based on current spacing.
	Returns reduced distance if already close, 0 if already in range.
	"""
	var current_dist := _get_current_distance_to_player()
	if current_dist < 0:
		return base_distance
	
	# If already in face-hug range, no lunge at all
	if current_dist < lunge_min_distance:
		return 0.0
	
	# Calculate how far we need to go to reach attack range
	var needed := current_dist - attack_range
	
	# Already in range - minimal or no lunge
	if needed <= 0:
		return 0.0
	
	# Close but not in range - partial lunge (80% of needed to avoid overshoot)
	if needed < base_distance:
		return needed * 0.8
	
	# Far away - full lunge
	return base_distance

func _do_spacing_slide() -> void:
	"""
	v17.0: Quick slide backward to reset to ideal combat distance.
	Called after combos when too close. Not a full backstep - just repositioning.
	"""
	if _phase == Phase.DEAD or _dbroken_active:
		return
	
	var player := _get_player()
	if not player:
		return
	
	var current_dist = (player.global_position - global_position).length()
	
	# Only slide if we're too close
	if current_dist >= ideal_combat_distance * 0.85:
		return
	
	var retreat_dir = (global_position - player.global_position).normalized()
	if retreat_dir == Vector2.ZERO:
		retreat_dir = Vector2.LEFT if sprite and not sprite.flip_h else Vector2.RIGHT
	
	var retreat_dist = min(ideal_combat_distance - current_dist, spacing_slide_distance)
	var retreat_time = retreat_dist / spacing_slide_speed
	var elapsed := 0.0
	
	while elapsed < retreat_time:
		if _phase == Phase.DEAD or _dbroken_active:
			velocity = Vector2.ZERO
			return
		velocity = retreat_dir * spacing_slide_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	
func _wait_for_parry_recovery(seq_id: int) -> bool:
	"""
	v13.0: Waits for hitstop/stagger to finish before continuing combo.
	"""
	# Wait for combo hitstop
	while _combo_is_frozen:
		if _should_abort_attack(seq_id):
			return true
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return true
	
	# Wait for legacy stagger
	while _is_in_parry_stagger() or _is_in_parry_recoil():
		if _should_abort_attack(seq_id):
			return true
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return true
	
	# Post-parry breathing room
	if _post_parry_recovery > 0.0:
		var recovery_elapsed := 0.0
		while recovery_elapsed < _post_parry_recovery:
			if _should_abort_attack(seq_id):
				return true
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return true
			recovery_elapsed += get_physics_process_delta_time()
	
	return false
	
func _setup_dual_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsUI"
	_bars_container.z_index = 100
	add_child(_bars_container)
	
	_ogre_posture_bg = ColorRect.new()
	_ogre_posture_bg.size = Vector2(54, 6)
	_ogre_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	_ogre_posture_bg.position = Vector2(-27, -45)
	_bars_container.add_child(_ogre_posture_bg)

	_ogre_posture_fill = ColorRect.new()
	_ogre_posture_fill.size = Vector2(0, 6)
	_ogre_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	_ogre_posture_fill.position = Vector2.ZERO
	_ogre_posture_bg.add_child(_ogre_posture_fill)
	
	var posture_border := ColorRect.new()
	posture_border.size = Vector2(56, 8)
	posture_border.color = Color(0.3, 0.25, 0.1, 0.9)
	posture_border.position = Vector2(-28, -46)
	posture_border.z_index = -1
	_bars_container.add_child(posture_border)
	
	_hp_bg = ColorRect.new()
	_hp_bg.size = Vector2(54, 5)
	_hp_bg.color = Color(0.15, 0.02, 0.02, 0.8)
	_hp_bg.position = Vector2(-27, -36)
	_bars_container.add_child(_hp_bg)
	
	_hp_fill = ColorRect.new()
	_hp_fill.size = Vector2(54, 5)
	_hp_fill.color = Color(0.85, 0.15, 0.1, 0.95)
	_hp_fill.position = Vector2.ZERO
	_hp_bg.add_child(_hp_fill)
	
	var hp_border := ColorRect.new()
	hp_border.size = Vector2(56, 7)
	hp_border.color = Color(0.25, 0.08, 0.08, 0.9)
	hp_border.position = Vector2(-28, -37)
	hp_border.z_index = -1
	_bars_container.add_child(hp_border)
	
	_bars_container.visible = true

func _update_bars() -> void:
	if _hp_fill:
		var hp_pct = clamp(float(hp) / float(_max_hp), 0.0, 1.0)
		_hp_fill.size.x = 54.0 * hp_pct
		
		if hp_pct >= 0.5:
			_hp_fill.color = Color(0.85, 0.15, 0.1, 0.95)
		elif hp_pct >= 0.25:
			_hp_fill.color = Color(0.9, 0.3, 0.1, 0.95)
		else:
			var flash := 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.008)
			_hp_fill.color = Color(1.0, 0.2 * flash, 0.1 * flash, 0.95)

func _update_posture_bar(cur: float, maxv: float) -> void:
	if not _ogre_posture_fill or not _ogre_posture_bg:
		return
	
	var pct = clamp(cur / max(0.001, maxv), 0.0, 1.0)
	_ogre_posture_fill.size.x = 54.0 * pct
	
	var hp_ratio = clamp(float(hp) / float(_max_hp), 0.0, 1.0)
	
	if hp_ratio >= 0.75:
		_ogre_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
		_ogre_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	elif hp_ratio >= 0.50:
		_ogre_posture_fill.color = Color(1.0, 0.6, 0.1, 0.95)
		_ogre_posture_bg.color = Color(0.15, 0.1, 0.02, 0.8)
	elif hp_ratio >= 0.25:
		_ogre_posture_fill.color = Color(1.0, 0.4, 0.1, 0.95)
		_ogre_posture_bg.color = Color(0.18, 0.06, 0.02, 0.8)
	else:
		var flash := 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.01)
		_ogre_posture_fill.color = Color(1.0, 0.25 * flash, 0.1, 0.95)
		_ogre_posture_bg.color = Color(0.22, 0.04, 0.02, 0.85)
	
	if pct >= 0.85:
		var break_flash := 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.015)
		_ogre_posture_fill.color.a = break_flash

# =============================================================================
# ATTACK CATEGORY HELPER
# =============================================================================
func _get_attack_category(attack: AttackType) -> AttackCategory:
	match attack:
		AttackType.SHIELD_ADVANCE, AttackType.OVERHEAD_BREAKER, AttackType.TRIPLE_COMBO:
			return AttackCategory.MELEE
		AttackType.CANNONFIRE_MARK:
			return AttackCategory.RANGED
		AttackType.HAMMER_SPIN:
			return AttackCategory.SPECIAL
		_:
			return AttackCategory.NONE

# =============================================================================
# FRONTAL ATTACK CHECK FOR BLOCKING
# =============================================================================
func _is_frontal_attack_pos(attacker_pos: Vector2) -> bool:
	var to_attacker := (attacker_pos - global_position).normalized()
	if to_attacker.length_squared() < 0.001:
		return true
	
	var facing := Vector2.LEFT
	if sprite and sprite.flip_h:
		facing = Vector2.RIGHT
	
	var half_cone := deg_to_rad(guard_frontal_cone / 2.0)
	var angle_to_attacker := facing.angle_to(to_attacker)
	
	return abs(angle_to_attacker) <= half_cone

func _start_parry_recoil_v13(local_attack: AttackType, parry_source_pos: Vector2) -> void:
	"""
	v13.0: Combo hits get HITSTOP (freeze in place).
		   Single attacks get KNOCKBACK (pushed away).
		   
	This creates Sekiro-style flow where combo strings feel like a dance.
	"""
	_hide_parry_indicator()
	
	var player := _get_player()
	
	# =========================================================================
	# COMBO ATTACKS: Hitstop only, no knockback
	# =========================================================================
	if local_attack == AttackType.TRIPLE_COMBO and not combo_hits_use_knockback:
		# Freeze in place
		velocity = Vector2.ZERO
		_combo_is_frozen = true
		
		# Start hitstop timer
		var now := Time.get_ticks_msec() * 0.001
		_combo_parry_freeze_until = now + combo_parry_hitstop
		
		# Brief freeze effect
		_do_parry_hitstop()
		return
	
	# =========================================================================
	# SINGLE ATTACKS: Full knockback (original behavior)
	# =========================================================================
	var source_pos := parry_source_pos
	if player:
		source_pos = player.global_position
	
	var away := (global_position - source_pos).normalized()
	if away == Vector2.ZERO:
		away = Vector2.RIGHT
	
	var dist := 0.0
	if player:
		dist = (player.global_position - global_position).length()
	
	# Knockback parameters based on attack type
	var recoil_time := 0.18
	var recoil_speed := 100.0
	var max_recoil := 35.0
	
	match local_attack:
		AttackType.OVERHEAD_BREAKER:
			recoil_time = 0.20
			recoil_speed = 120.0
			max_recoil = 40.0
		AttackType.SHIELD_ADVANCE:
			recoil_time = 0.18
			recoil_speed = 110.0
			max_recoil = 35.0
		_:
			recoil_time = 0.18
			recoil_speed = 100.0
			max_recoil = 35.0
	
	# Reduce knockback if already at ideal range
	var ideal := parry_ideal_range
	if ideal <= 0.0:
		ideal = close_range
	
	if dist >= ideal:
		recoil_speed = 40.0
		max_recoil = 12.0
	
	# Cap maximum knockback distance
	var potential := recoil_speed * recoil_time
	if potential > max_recoil:
		recoil_speed = max_recoil / recoil_time
	
	_parry_recoil_velocity = away * recoil_speed
	var now := Time.get_ticks_msec() * 0.001
	_parry_recoil_until = now + recoil_time
	_parry_stagger_until = now + recoil_time

func _do_parry_hitstop() -> void:
	"""
	Creates the Sekiro-style "clash" feeling when a combo hit is parried.
	Boss freezes briefly with visual feedback.
	"""
	# Pause animation
	if anim:
		anim.pause()
	
	# Flash effect
	if sprite:
		var original_mod := sprite.modulate
		sprite.modulate = Color(1.0, 1.0, 1.6)  # Bright flash
		
		# Wait for hitstop duration
		await get_tree().create_timer(combo_parry_hitstop).timeout
		
		if is_instance_valid(sprite):
			sprite.modulate = original_mod
	else:
		await get_tree().create_timer(combo_parry_hitstop).timeout
	
	# Resume
	_combo_is_frozen = false
	if anim and is_instance_valid(anim):
		# Don't resume old animation - let the combo code handle it
		pass

func _should_abort_attack(sequence_id: int) -> bool:
	if _phase == Phase.DEAD:
		return true
	if _dbroken_active:
		return true
	if _combo_interrupted:
		return true
	if sequence_id != _attack_sequence_id:
		return true
	return false

func _physics_process(delta: float) -> void:
	if _phase == Phase.DEAD:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _combo_is_frozen:
		var now := Time.get_ticks_msec() * 0.001
		if now >= _combo_parry_freeze_until:
			_combo_is_frozen = false
		else:
			velocity = Vector2.ZERO
			_apply_soft_separation()
			move_and_slide()
			return
			
	if _bars_container:
		_bars_container.global_position = global_position
	
	_update_bars()
	
	var now := Time.get_ticks_msec() * 0.001
	
	# Expire deathblow window
	if _dbroken_active and now >= _dbreak_until:
		_end_deathblow_window()
	
	# Short stun after non-lethal deathblows (or other sources)
	if _stun_until > 0.0:
		if now < _stun_until:
			velocity = Vector2.ZERO
			move_and_slide()
			return
		else:
			_stun_until = 0.0
	
	# While posture is broken, the captain is locked and waiting for (or recovering from) deathblow
	if _dbroken_active:
		if _guarding:
			_end_guard()
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	# Short parry recoil window: let the parry reaction own movement
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
	ProstheticEffects.tick(self, delta)
	if ProstheticEffects.override_movement(self, delta):
		return
	
	_attack_cooldown = max(_attack_cooldown - delta, 0.0)
	_spin_cooldown = max(_spin_cooldown - delta, 0.0)
	_cannon_cooldown = max(_cannon_cooldown - delta, 0.0)
	
	_update_guard_block_decay(delta)
	
	var player := _get_player()
	if not player:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var to_player: Vector2 = player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.0 else Vector2.RIGHT
	
	if dist <= close_range:
		_melee_pressure_time += delta
	else:
		_melee_pressure_time = max(0.0, _melee_pressure_time - delta * 2.0)
	
	match _behavior_state:
		BehaviorState.IDLE:
			_process_idle_state(player, dist, dir, delta)
		BehaviorState.PURSUING:
			_process_pursuing_state(player, dist, dir, delta)
		BehaviorState.APPROACHING:
			_process_approaching_state(player, dist, dir, delta)
		BehaviorState.BACKSTEPPING:
			_process_backstep_state(player, dist, dir, delta)
		BehaviorState.ATTACKING:
			pass
	
	_apply_soft_separation()
	
	move_and_slide()

func _apply_soft_separation() -> void:
	"""
	v17.0: Gentle push away from player when overlapping.
	Prevents hard clipping without disrupting combat flow.
	"""
	# Don't apply during certain states
	if _phase == Phase.DEAD or _dbroken_active:
		return
	if _combat_phase == CombatPhase.ACTIVE:
		return
	if _parry_recoil_until > 0.0:
		return
	
	var player := _get_player()
	if not player:
		return
	
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	if dist < min_separation and dist > 0.1:
		var push_strength = (min_separation - dist) * 4.0
		var push_dir = -to_player.normalized()
		velocity += push_dir * push_strength
		
func _process_backstep_state(_player: Node2D, _dist: float, _dir: Vector2, _delta: float) -> void:
	pass

func _should_backstep(dist: float) -> bool:
	if dist > close_range * 1.5:
		return false
	
	var pressure_trigger := _melee_pressure_time >= melee_pressure_threshold
	var staleness_trigger := _consecutive_melee_attacks >= melee_staleness_threshold
	var ranged_desire_high := (_cannon_desire >= max_desire * 0.7) or (_spin_desire >= max_desire * 0.7)
	var ranged_blocked := dist < cannon_min_range
	var desire_trigger := ranged_desire_high and ranged_blocked
	
	if (pressure_trigger or staleness_trigger or desire_trigger):
		return _rng.randf() < backstep_chance
	
	return false

func _do_backstep() -> void:
	if _phase == Phase.DEAD or _dbroken_active:
		return

	_behavior_state = BehaviorState.BACKSTEPPING

	if _guarding:
		_end_guard()

	var player := _get_player()
	if player:
		_backstep_direction = (global_position - player.global_position).normalized()
	else:
		_backstep_direction = Vector2.LEFT if sprite and not sprite.flip_h else Vector2.RIGHT

	if _backstep_direction == Vector2.ZERO:
		_backstep_direction = Vector2.LEFT

	if anim and anim.has_animation("backstep"):
		anim.play("backstep")
	elif anim and anim.has_animation("dodge"):
		anim.play("dodge")

	var elapsed := 0.0
	while elapsed < backstep_duration and _phase != Phase.DEAD and not _dbroken_active:
		await get_tree().physics_frame
		var dt := get_physics_process_delta_time()
		elapsed += dt
		velocity = _backstep_direction * backstep_speed

	velocity = Vector2.ZERO

	await get_tree().create_timer(backstep_recovery).timeout

	if _phase == Phase.DEAD or _dbroken_active:
		_behavior_state = BehaviorState.IDLE
		return

	_melee_pressure_time = 0.0
	_consecutive_melee_attacks = 0

	# ---- NEW: if we queued a ranged/special, execute it after the spacing attempt ----
	if _pending_ranged_attack != AttackType.NONE:
		var atk := _pending_ranged_attack
		_pending_ranged_attack = AttackType.NONE
		_behavior_state = BehaviorState.IDLE
		_attack_cooldown = 0.0
		_start_attack(atk)
		return
	# -------------------------------------------------------------------------------

	if _rng.randf() < backstep_ranged_preference:
		_post_backstep_ranged = true
		var new_dist := 0.0
		if player and is_instance_valid(player):
			new_dist = (player.global_position - global_position).length()

		if new_dist >= cannon_min_range:
			_behavior_state = BehaviorState.IDLE
			_attack_cooldown = 0.0
			_start_attack(AttackType.CANNONFIRE_MARK)
		elif new_dist >= spin_min_range and _spin_cooldown <= 0.0:
			_behavior_state = BehaviorState.IDLE
			_attack_cooldown = 0.0
			_start_attack(AttackType.HAMMER_SPIN)
		else:
			_post_backstep_ranged = false
			_behavior_state = BehaviorState.IDLE
			_attack_cooldown = _rng.randf_range(min_attack_cooldown * 0.5, max_attack_cooldown * 0.5)
	else:
		_post_backstep_ranged = false
		_behavior_state = BehaviorState.IDLE
		_attack_cooldown = _rng.randf_range(min_attack_cooldown * 0.5, max_attack_cooldown * 0.5)

func _process_idle_state(player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	velocity = Vector2.ZERO
	_face_direction(dir)

	# Confused: wander aimlessly
	if ProstheticEffects.is_confused(self):
		var wander = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		velocity = wander * base_movement_speed * 0.25
		if _guarding:
			_end_guard()
		return
	
	# Smoke cloud: player hidden, don't attack or pursue
	if _player_hidden_in_smoke(player):
		_play_idle()
		return
		
	var want_guard = dist <= mid_range
	if want_guard and not _guarding:
		_start_guard()
	elif not want_guard and _guarding:
		_end_guard()
	
	_play_idle()

	if dist > mid_range + 50.0:
		_transition_to_pursuing()
		return

	if dist > far_range and _pending_melee_attack != AttackType.NONE:
		_transition_to_approaching(_pending_melee_attack)
		return

	if _attack_cooldown <= 0.0:
		if _should_backstep(dist):
			_do_backstep()
			return

		if _guarding:
			_end_guard()

		var attack = _choose_attack(dist)
		if attack == AttackType.NONE:
			return

		if attack == AttackType.CANNONFIRE_MARK and dist < cannon_min_range:
			_pending_ranged_attack = AttackType.CANNONFIRE_MARK
			_do_backstep()
			return

		if attack == AttackType.HAMMER_SPIN and dist < spin_min_range:
			_pending_ranged_attack = AttackType.HAMMER_SPIN
			_do_backstep()
			return

		if dist > close_range and attack in [AttackType.OVERHEAD_BREAKER, AttackType.TRIPLE_COMBO]:
			_pending_melee_attack = attack
			_transition_to_approaching(attack)
		else:
			_start_attack(attack)
			
func _process_pursuing_state(_player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	if ProstheticEffects.is_confused(self):
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * base_movement_speed * 0.25
		return
	if _player_hidden_in_smoke(_player):
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		return
	if dist <= mid_range:
		_behavior_state = BehaviorState.IDLE
		return
	velocity = dir * base_movement_speed
	_face_direction(dir)
	_play_walk()
	
func _process_approaching_state(player: Node2D, dist: float, dir: Vector2, delta: float) -> void:
	if _player_hidden_in_smoke(player):
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		_pending_melee_attack = AttackType.NONE
		return
	_approach_timer -= delta
	_approach_current_speed = min(_approach_current_speed + approach_acceleration * delta, approach_max_speed)
	velocity = dir * _approach_current_speed
	_face_direction(dir)
	_play_walk()
	
	if dist <= close_range:
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		if _pending_melee_attack != AttackType.NONE:
			_execute_melee_attack(_pending_melee_attack)
		return
	
	if _approach_timer <= 0.0:
		if _pending_melee_attack != AttackType.NONE and dist <= close_range * 2.0:
			_execute_melee_attack(_pending_melee_attack)
		elif dist > approach_give_up_distance and _rng.randf() < gap_close_chance:
			_start_attack(AttackType.SHIELD_ADVANCE)
		else:
			_behavior_state = BehaviorState.IDLE

func _transition_to_pursuing() -> void:
	if _guarding:
		_end_guard()
	_behavior_state = BehaviorState.PURSUING
	_pending_melee_attack = AttackType.NONE

func _transition_to_approaching(attack: AttackType) -> void:
	if _guarding:
		_end_guard()
	_behavior_state = BehaviorState.APPROACHING
	_pending_melee_attack = attack
	_approach_timer = approach_commitment_time
	_approach_current_speed = approach_speed

func _start_attack(attack: AttackType) -> void:
	# FIX: Do NOT always drop guard when attacking.
	# Keep guard for most melee so player attacks mostly convert to posture (block),
	# and only drop guard for explicit specials that shouldn’t be guarded.
	if _guarding and attack in [AttackType.HAMMER_SPIN, AttackType.CANNONFIRE_MARK]:
		_end_guard()

	# Minimal movement polish: prevent leftover pursuit/approach velocity from "skating" into attack windups
	velocity = Vector2.ZERO

	_behavior_state = BehaviorState.ATTACKING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1

	var category := _get_attack_category(attack)
	if category == AttackCategory.MELEE:
		if _last_attack_category == AttackCategory.MELEE:
			_consecutive_melee_attacks += 1
		else:
			_consecutive_melee_attacks = 1
	else:
		_consecutive_melee_attacks = 0
	_last_attack_category = category

	match attack:
		AttackType.SHIELD_ADVANCE:
			_do_shield_advance()
		AttackType.OVERHEAD_BREAKER:
			_do_overhead_breaker()
		AttackType.CANNONFIRE_MARK:
			_do_cannonfire_mark()
		AttackType.HAMMER_SPIN:
			_do_hammer_spin()
		AttackType.TRIPLE_COMBO:
			_do_triple_combo()

func _execute_melee_attack(attack: AttackType) -> void:
	_pending_melee_attack = AttackType.NONE
	_start_attack(attack)

func _finish_attack() -> void:
	# === v18.0 FIX: Set cooldown FIRST to prevent race condition ===
	# Calculate cooldown before any state changes to prevent new attacks from starting
	var cd_min := min_attack_cooldown
	var cd_max := max_attack_cooldown

	# Sekiro-style pacing:
	# - After melee strings: re-engage quickly
	# - After ranged/specials: give a slightly longer breather
	match _last_attack_category:
		AttackCategory.MELEE:
			cd_min *= 0.7
			cd_max *= 0.9
		AttackCategory.RANGED, AttackCategory.SPECIAL:
			cd_min *= 1.1
			cd_max *= 1.25
		_:
			pass

	# Set cooldown BEFORE changing state to prevent race condition
	_attack_cooldown = _rng.randf_range(cd_min, cd_max)
	
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE

	# === v18.0: Post-attack spacing adjustment ===
	# Use BACKSTEPPING state during slide to prevent new attacks
	if _last_attack_category == AttackCategory.MELEE:
		if _is_face_hugging() or _rng.randf() < post_combo_spacing_chance:
			_behavior_state = BehaviorState.BACKSTEPPING  # Prevents new attacks
			await _do_spacing_slide()
	
	# NOW set to IDLE (after cooldown is set and slide is done)
	_behavior_state = BehaviorState.IDLE

	_cleanup_hitbox()
	_combo_interrupted = false
	_play_idle()
	
func _choose_attack(dist: float) -> AttackType:
	var weights := {}

	if _post_backstep_ranged:
		_post_backstep_ranged = false
		if _cannon_cooldown <= 0.0:
			return AttackType.CANNONFIRE_MARK
		if _spin_cooldown <= 0.0:
			return AttackType.HAMMER_SPIN

	var force_melee := _consecutive_ranged_attacks >= max_consecutive_ranged

	# === v17.0: SPACING-AWARE ATTACK SELECTION ===
	var is_too_close := dist < too_close_threshold

	if is_too_close:
		if _should_backstep(dist):
			return AttackType.NONE

		weights[AttackType.OVERHEAD_BREAKER] = (overhead_base_chance + _overhead_desire) * 1.5
		weights[AttackType.TRIPLE_COMBO] = (combo_base_chance + _combo_desire) * 0.4
		weights[AttackType.SHIELD_ADVANCE] = 0.0
	else:
		weights[AttackType.SHIELD_ADVANCE] = shield_advance_base_chance + _shield_advance_desire

		if dist <= close_range * 1.8:
			weights[AttackType.OVERHEAD_BREAKER] = overhead_base_chance + _overhead_desire
		else:
			weights[AttackType.OVERHEAD_BREAKER] = 0.0

		weights[AttackType.TRIPLE_COMBO] = combo_base_chance + _combo_desire

	# ---- CHANGED: allow cannon/spin weighting even at close–mid (no long-range gate) ----
	if _cannon_cooldown <= 0.0 and not force_melee:
		# slightly reduce when extremely close so it doesn’t spam point-blank
		var close_mult := 0.65 if dist < close_range else 1.0
		weights[AttackType.CANNONFIRE_MARK] = (cannon_base_chance + _cannon_desire) * close_mult
	else:
		weights[AttackType.CANNONFIRE_MARK] = 0.0

	if _spin_cooldown <= 0.0 and not force_melee:
		var close_mult2 := 0.75 if dist < close_range else 1.0
		weights[AttackType.HAMMER_SPIN] = (spin_base_chance + _spin_desire) * close_mult2
	else:
		weights[AttackType.HAMMER_SPIN] = 0.0
	# -------------------------------------------------------------------------------

	var total := 0.0
	for w in weights.values():
		total += w

	if total <= 0.0:
		_grow_all_desires_except(AttackType.SHIELD_ADVANCE)
		return AttackType.SHIELD_ADVANCE

	var pick := _rng.randf() * total
	var acc := 0.0

	for atk in weights:
		acc += weights[atk]
		if pick <= acc and weights[atk] > 0.0:
			_on_attack_chosen(atk)
			return atk

	_on_attack_chosen(AttackType.SHIELD_ADVANCE)
	return AttackType.SHIELD_ADVANCE

func _on_attack_chosen(chosen: AttackType) -> void:
	var category := _get_attack_category(chosen)
	if category == AttackCategory.RANGED:
		_consecutive_ranged_attacks += 1
		_consecutive_melee_attacks = 0
	elif category == AttackCategory.MELEE:
		_consecutive_melee_attacks += 1
		_consecutive_ranged_attacks = 0
	else:
		_consecutive_ranged_attacks = 0
		_consecutive_melee_attacks = 0
	
	match chosen:
		AttackType.SHIELD_ADVANCE:
			_shield_advance_desire = 0.0
		AttackType.OVERHEAD_BREAKER:
			_overhead_desire = 0.0
		AttackType.TRIPLE_COMBO:
			_combo_desire = 0.0
		AttackType.CANNONFIRE_MARK:
			_cannon_desire = 0.0
			_cannon_cooldown = cannon_cooldown
		AttackType.HAMMER_SPIN:
			_spin_desire = 0.0
			_spin_cooldown = spin_global_cooldown
	
	_grow_all_desires_except(chosen)

func _grow_all_desires_except(except: AttackType) -> void:
	if except != AttackType.SHIELD_ADVANCE:
		_shield_advance_desire = minf(_shield_advance_desire + shield_advance_desire_growth, max_desire)
	if except != AttackType.OVERHEAD_BREAKER:
		_overhead_desire = minf(_overhead_desire + overhead_desire_growth, max_desire)
	if except != AttackType.TRIPLE_COMBO:
		_combo_desire = minf(_combo_desire + combo_desire_growth, max_desire)
	if except != AttackType.CANNONFIRE_MARK:
		_cannon_desire = minf(_cannon_desire + cannon_desire_growth, max_desire)
	if except != AttackType.HAMMER_SPIN:
		_spin_desire = minf(_spin_desire + spin_desire_growth, max_desire)

func _do_shield_advance() -> void:
	var my_sequence := _attack_sequence_id
	
	if _should_abort_attack(my_sequence):
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
	
	# v15.0 FIX: Show indicator at START of windup for early warning!
	# Total indicator time = windup + active phases
	var total_attack_duration := shield_advance_windup + parry_early_window + shield_advance_duration + parry_linger_window * 0.5
	_show_parry_indicator(total_attack_duration, false)
	
	if anim and anim.has_animation("shield_advance_windup"):
		anim.play("shield_advance_windup")
	
	var windup_elapsed := 0.0
	while windup_elapsed < shield_advance_windup:
		if _should_abort_attack(my_sequence):
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		windup_elapsed += get_physics_process_delta_time()
	
	if _should_abort_attack(my_sequence):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return
	
	# Re-target
	if player and is_instance_valid(player):
		var new_dir = (player.global_position - global_position).normalized()
		if new_dir != Vector2.ZERO:
			dir = new_dir
			_face_direction(dir)
	
	# --- ACTIVE: Spawn hitbox (indicator already showing from windup) ---
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_charge_hitbox(dir)
	
	# v15.0: Indicator now shown during windup, not here
	
	# Early parry window
	var early_elapsed := 0.0
	while early_elapsed < parry_early_window:
		if _should_abort_attack(my_sequence):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		early_elapsed += get_physics_process_delta_time()
	
	if _should_abort_attack(my_sequence):
		velocity = Vector2.ZERO
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return
	
	if anim and anim.has_animation("shield_advance"):
		anim.play("shield_advance")
	
	# Charge loop
	var charge_elapsed := 0.0
	while charge_elapsed < shield_advance_duration:
		if _should_abort_attack(my_sequence):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		
		velocity = dir * shield_advance_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		charge_elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	
	# Linger
	var linger_elapsed := 0.0
	while linger_elapsed < parry_linger_window * 0.5:
		if _should_abort_attack(my_sequence):
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		linger_elapsed += get_physics_process_delta_time()
	
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(shield_advance_recovery).timeout
	
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()
	
func _do_overhead_breaker() -> void:
	var my_sequence := _attack_sequence_id
	
	if _should_abort_attack(my_sequence):
		return
	
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	
	var player := _get_player()
	if player:
		var dir = (player.global_position - global_position).normalized()
		_face_direction(dir)
	
	# v15.0 FIX: Show indicator at START of windup for early warning!
	var total_attack_duration := overhead_windup_time + parry_linger_window
	_show_parry_indicator(total_attack_duration, false)
	
	if anim and anim.has_animation("overhead_windup"):
		anim.play("overhead_windup")
	
	var windup_elapsed := 0.0
	var windup_target := overhead_windup_time - overhead_parry_preframe
	while windup_elapsed < windup_target:
		if _should_abort_attack(my_sequence):
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		windup_elapsed += get_physics_process_delta_time()
	
	if _should_abort_attack(my_sequence):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return
	
	# --- ACTIVE: Spawn hitbox (indicator already showing from windup) ---
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_slam_hitbox(global_position, overhead_slam_damage)
	
	# v15.0: Indicator now shown during windup, not here
	
	# Pre-impact
	var pre_elapsed := 0.0
	while pre_elapsed < overhead_parry_preframe:
		if _should_abort_attack(my_sequence):
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		pre_elapsed += get_physics_process_delta_time()
	
	if _should_abort_attack(my_sequence):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return
	
	if anim:
		if anim.has_animation("overhead_impact"):
			anim.play("overhead_impact")
		elif anim.has_animation("overhead"):
			anim.play("overhead")
	
	velocity = Vector2.ZERO
	
	# Linger
	var linger_elapsed := 0.0
	while linger_elapsed < parry_linger_window:
		if _should_abort_attack(my_sequence):
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		linger_elapsed += get_physics_process_delta_time()
	
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(overhead_recovery_time).timeout
	
	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()
	
func _do_cannonfire_mark() -> void:
	var my_sequence := _attack_sequence_id
	if _should_abort_attack(my_sequence):
		return

	_combo_interrupted = false
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	# === UNBLOCKABLE ROUTING (robust): if the player receives "attacker" as self, this guarantees unblockable ===
	set_meta("unblockable", true)

	var total_duration = 0.3 + cannon_mark_linger + cannon_pattern_recovery
	_show_parry_indicator(total_duration, true)

	if anim and anim.has_animation("cannon_mark"):
		anim.play("cannon_mark")
		await anim.animation_finished
	else:
		await get_tree().create_timer(0.3).timeout

	if _should_abort_attack(my_sequence):
		_hide_parry_indicator()
		_set_combat_phase(CombatPhase.NONE)
		# clear unblockable flag on abort
		if has_meta("unblockable"):
			set_meta("unblockable", false)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)

	# Target around the Ogre/player area. No old shield-formation dependency.
	var ring_radius := cannon_outer_radius
	var max_r = max(0.0, ring_radius - cannon_aoe_radius - 6.0)

	var player := _get_player()
	var ring_center := global_position
	var desired_center := ring_center
	if player and is_instance_valid(player):
		# bias toward player but still clamp into the ring
		desired_center = player.global_position

	var count := _rng.randi_range(cannon_min_marks, cannon_max_marks)
	var positions: Array[Vector2] = []

	for i in count:
		# sample around desired_center but clamp to ring
		var angle := _rng.randf_range(0.0, TAU)

		# bias toward inner area so it actually threatens the player more often
		# (sqrt bias produces more points near center than uniform radius)
		var r = sqrt(_rng.randf()) * max_r

		var raw = desired_center + Vector2.RIGHT.rotated(angle) * r
		var v = raw - ring_center
		if v.length() > max_r:
			raw = ring_center + v.normalized() * max_r

		positions.append(raw)

	velocity = Vector2.ZERO
	for pos in positions:
		if _should_abort_attack(my_sequence):
			break
		_spawn_cannon_marker_and_aoe(pos)

	if _should_abort_attack(my_sequence):
		_hide_parry_indicator()
		_set_combat_phase(CombatPhase.NONE)
		# clear unblockable flag on abort
		if has_meta("unblockable"):
			set_meta("unblockable", false)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(cannon_pattern_recovery).timeout

	# Hide indicator at end of recovery
	_hide_parry_indicator()

	# clear unblockable flag when done
	if has_meta("unblockable"):
		set_meta("unblockable", false)

	if _should_abort_attack(my_sequence):
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _do_hammer_spin() -> void:
	var my_sequence := _attack_sequence_id
	if _should_abort_attack(my_sequence):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO
	_spin_hit_targets.clear()

	# === UNBLOCKABLE ROUTING (robust): guarantees player sees unblockable even if attacker passed is self ===
	set_meta("unblockable", true)

	var player := _get_player()
	var move_dir := Vector2.RIGHT
	if player:
		move_dir = (player.global_position - global_position).normalized()
	if move_dir == Vector2.ZERO:
		move_dir = Vector2.RIGHT
	_face_direction(move_dir)

	# Show red/yellow unblockable indicator through HumanoidEnemyBase helper.
	var total_duration := 0.5 + spin_duration + spin_recovery
	_show_parry_indicator(total_duration, true)

	if anim and anim.has_animation("spin_windup"):
		anim.play("spin_windup")
		await anim.animation_finished
	else:
		await get_tree().create_timer(0.5).timeout

	if _should_abort_attack(my_sequence):
		_hide_parry_indicator()
		_set_combat_phase(CombatPhase.NONE)
		# clear unblockable flag on abort
		if has_meta("unblockable"):
			set_meta("unblockable", false)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	var remaining := spin_duration
	var orbit_angle := 0.0

	var hitbox := Area2D.new()
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", spin_damage)
	hitbox.set_meta("damage_type", "spin_unblockable")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("unblockable", true)

	var shape := CircleShape2D.new()
	shape.radius = spin_hitbox_size
	var col := CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = Vector2.RIGHT.rotated(orbit_angle) * spin_hit_radius
	hitbox.area_entered.connect(_on_spin_orbit_hit)

	_current_hitbox = hitbox

	if anim and anim.has_animation("spin_loop"):
		anim.play("spin_loop")

	while remaining > 0.0 and not _should_abort_attack(my_sequence):
		await get_tree().physics_frame
		var dt := get_physics_process_delta_time()
		remaining -= dt

		orbit_angle += deg_to_rad(spin_orbit_speed_deg) * dt
		orbit_angle = wrapf(orbit_angle, 0.0, TAU)

		var pl := _get_player()
		if pl:
			var desired = (pl.global_position - global_position).normalized()
			if desired != Vector2.ZERO:
				var angle_diff := wrapf(desired.angle() - move_dir.angle(), -PI, PI)
				var max_step := deg_to_rad(spin_turn_rate_deg) * dt
				var step = clamp(angle_diff, -max_step, max_step)
				move_dir = move_dir.rotated(step)

		velocity = move_dir * spin_move_speed
		_face_direction(move_dir)

		if is_instance_valid(hitbox):
			hitbox.position = Vector2.RIGHT.rotated(orbit_angle) * spin_hit_radius

		var current_time := Time.get_ticks_msec() / 1000.0
		var expired_keys := []
		for target_id in _spin_hit_targets:
			if current_time - _spin_hit_targets[target_id] > spin_hit_cooldown:
				expired_keys.append(target_id)
		for key in expired_keys:
			_spin_hit_targets.erase(key)

	velocity = Vector2.ZERO
	_cleanup_hitbox()

	if _should_abort_attack(my_sequence):
		_hide_parry_indicator()
		_set_combat_phase(CombatPhase.NONE)
		# clear unblockable flag on abort
		if has_meta("unblockable"):
			set_meta("unblockable", false)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.RECOVERY)
	if anim and anim.has_animation("spin_end"):
		anim.play("spin_end")
		await anim.animation_finished
	else:
		await get_tree().create_timer(spin_recovery).timeout

	# Hide indicator at end
	_hide_parry_indicator()

	# clear unblockable flag when done
	if has_meta("unblockable"):
		set_meta("unblockable", false)

	if _should_abort_attack(my_sequence):
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()
	_attack_cooldown += spin_recovery

func _on_spin_orbit_hit(other: Area2D) -> void:
	if not is_instance_valid(other):
		return
	var owner_node := other.get_parent()
	if owner_node == null or not owner_node.is_in_group("player"):
		return
	var target_id := owner_node.get_instance_id()
	var current_time := Time.get_ticks_msec() / 1000.0
	if _spin_hit_targets.has(target_id) and current_time - _spin_hit_targets[target_id] < spin_hit_cooldown:
		return
	_spin_hit_targets[target_id] = current_time

# =============================================================================
# v10.0: TRIPLE COMBO - Each hit has early parry window + linger
# =============================================================================
func _do_triple_combo() -> void:
	var my_sequence := _attack_sequence_id
	
	if _should_abort_attack(my_sequence):
		return
	
	# Reset combo state
	_combo_interrupted = false
	_combo_hit_index = 0
	_combo_should_continue = true
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
	
	# =========================================================================
	# INITIAL WINDUP - Boss raises weapon, no indicator yet
	# =========================================================================
	if anim and anim.has_animation("combo_start"):
		anim.play("combo_start")
	
	if not await _wait_duration_interruptible(combo_initial_windup, my_sequence):
		return
	
	# =========================================================================
	# HIT 1 - First slash
	# =========================================================================
	_combo_hit_index = 1
	
	if not await _execute_combo_hit(
		my_sequence,
		combo1_anticipation,
		combo1_active_time,
		combo1_recovery,
		combo1_lunge_distance,
		combo1_lunge_speed,
		combo1_damage,
		"combo_hit1_antic",
		"combo_hit1"
	):
		return
	
	# === v18.0: Inter-hit gap to prevent animation overlap ===
	if combo_inter_hit_gap > 0.0:
		if not await _wait_duration_interruptible(combo_inter_hit_gap, my_sequence):
			return
	
	# =========================================================================
	# HIT 2 - Second slash  
	# =========================================================================
	_combo_hit_index = 2
	
	if not await _execute_combo_hit(
		my_sequence,
		combo2_anticipation,
		combo2_active_time,
		combo2_recovery,
		combo2_lunge_distance,
		combo2_lunge_speed,
		combo2_damage,
		"combo_hit2_antic",
		"combo_hit2"
	):
		return
	
	# === v18.0: Inter-hit gap before finisher ===
	if combo_inter_hit_gap > 0.0:
		if not await _wait_duration_interruptible(combo_inter_hit_gap, my_sequence):
			return
	
	# =========================================================================
	# HIT 3 (FINISHER) - Overhead slam
	# =========================================================================
	_combo_hit_index = 3
	
	if not await _execute_combo_finisher(my_sequence):
		return
	
	# =========================================================================
	# COMBO COMPLETE
	# =========================================================================
	_set_combat_phase(CombatPhase.NONE)
	_combo_interrupted = false
	_combo_hit_index = 0
	_finish_attack()


# =============================================================================
# NEW: _execute_combo_hit() - Single combo hit with proper phase separation
# =============================================================================
func _execute_combo_hit(
	seq_id: int,
	anticipation_time: float,
	active_time: float,
	recovery_time: float,
	lunge_distance: float,
	lunge_speed: float,
	damage: int,
	antic_anim: String,
	swing_anim: String
) -> bool:
	"""
	v15.0 FIX: Indicator shows at START of anticipation for early warning!
	Phases: ANTICIPATION (indicator here) → LUNGE → ACTIVE → RECOVERY
	"""
	
	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return false
	
	# --- PHASE 1: ANTICIPATION (show indicator NOW for early warning!) ---
	_set_combat_phase(CombatPhase.WINDUP)
	
	var attack_dir := Vector2.RIGHT
	var player := _get_player()
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
		if attack_dir == Vector2.ZERO:
			attack_dir = Vector2.RIGHT
	_face_direction(attack_dir)
	
	# v15.0 FIX: Show indicator at START of anticipation!
	# Total indicator time = anticipation + early + active + linger
	var total_attack_duration := anticipation_time + parry_early_window + active_time + parry_linger_window
	_show_parry_indicator(total_attack_duration, false)
	
	if anim and anim.has_animation(antic_anim):
		anim.play(antic_anim)
	
	# Calculate lunge time
	var lunge_time := lunge_distance / lunge_speed if lunge_speed > 0 else 0.0
	var pre_lunge_wait = max(0.0, anticipation_time - lunge_time)
	
	if pre_lunge_wait > 0.0:
		if not await _wait_duration_interruptible(pre_lunge_wait, seq_id):
			return false
	
	# --- PHASE 2: LUNGE (still NO indicator) ---
	if lunge_time > 0.0:
		if not await _lunge_phase(attack_dir, lunge_distance, lunge_speed, lunge_time, seq_id):
			return false
	
	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return false
	
	# --- PHASE 3: ACTIVE (spawn hitbox, indicator already showing) ---
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_combo_hitbox(attack_dir, damage)
	
	# v15.0: Indicator now shown during anticipation, not here
	
	if anim and anim.has_animation(swing_anim):
		anim.play(swing_anim)
	
	# Early parry window
	if not await _wait_duration_interruptible(parry_early_window, seq_id):
		return false
	
	# Active frames
	if not await _wait_duration_interruptible(active_time, seq_id):
		return false
	
	# Linger window
	if not await _wait_duration_interruptible(parry_linger_window, seq_id):
		return false
	
	# === v18.0: Wait for swing animation to complete (prevents cut-off) ===
	# Only wait if animation is still playing the swing anim
	if anim and anim.is_playing() and anim.current_animation == swing_anim:
		var anim_wait_timeout := 0.5  # Max additional wait to prevent infinite loops
		var anim_wait_elapsed := 0.0
		while anim.is_playing() and anim.current_animation == swing_anim and anim_wait_elapsed < anim_wait_timeout:
			if _should_abort_attack(seq_id):
				_cleanup_hitbox()
				_set_combat_phase(CombatPhase.NONE)
				_finish_attack()
				return false
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return false
			anim_wait_elapsed += get_physics_process_delta_time()
	
	# Cleanup hitbox (hides indicator)
	_cleanup_hitbox()
	velocity = Vector2.ZERO
	
	# --- PHASE 4: RECOVERY (NO indicator) ---
	_set_combat_phase(CombatPhase.RECOVERY)
	
	if not await _wait_duration_interruptible(recovery_time, seq_id):
		return false
	
	if not await _wait_for_combo_parry_recovery(seq_id):
		return false
	
	return true
	
func _execute_combo_finisher(seq_id: int) -> bool:
	"""v15.0 FIX: Show indicator at START of windup for early warning."""
	
	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return false
	
	_set_combat_phase(CombatPhase.WINDUP)
	
	var attack_dir := Vector2.RIGHT
	var player := _get_player()
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
		if attack_dir == Vector2.ZERO:
			attack_dir = Vector2.RIGHT
	_face_direction(attack_dir)
	
	# v15.0 FIX: Show indicator at START of windup for early warning!
	var total_attack_duration := combo_finisher_windup + combo_finisher_active + parry_linger_window
	_show_parry_indicator(total_attack_duration, false)
	
	# Overhead windup
	if anim and anim.has_animation("overhead_windup"):
		anim.play("overhead_windup")
	
	var step_time := combo_finisher_step / combo_finisher_step_speed if combo_finisher_step_speed > 0 else 0.0
	var windup_wait = max(0.0, combo_finisher_windup - step_time - overhead_parry_preframe)
	
	if windup_wait > 0.0:
		if not await _wait_duration_interruptible(windup_wait, seq_id):
			return false
	
	if step_time > 0.0:
		if not await _lunge_phase(attack_dir, combo_finisher_step, combo_finisher_step_speed, step_time, seq_id):
			return false
	
	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return false
	
	# --- ACTIVE: spawn hitbox (indicator already showing from windup) ---
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_slam_hitbox(global_position, combo_finisher_damage)
	
	# v15.0: Indicator now shown during windup, not here
	
	if not await _wait_duration_interruptible(overhead_parry_preframe, seq_id):
		return false
	
	if anim:
		if anim.has_animation("overhead_impact"):
			anim.play("overhead_impact")
		elif anim.has_animation("overhead"):
			anim.play("overhead")
	
	velocity = Vector2.ZERO
	
	if not await _wait_duration_interruptible(combo_finisher_active, seq_id):
		return false
	
	if not await _wait_duration_interruptible(parry_linger_window, seq_id):
		return false
	
	# === v18.0: Wait for impact animation to complete (prevents cut-off) ===
	if anim and anim.is_playing():
		var impact_anim := "overhead_impact" if anim.has_animation("overhead_impact") else "overhead"
		if anim.current_animation == impact_anim:
			var anim_wait_timeout := 0.5  # Max additional wait
			var anim_wait_elapsed := 0.0
			while anim.is_playing() and anim.current_animation == impact_anim and anim_wait_elapsed < anim_wait_timeout:
				if _should_abort_attack(seq_id):
					_cleanup_hitbox()
					_set_combat_phase(CombatPhase.NONE)
					_finish_attack()
					return false
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return false
				anim_wait_elapsed += get_physics_process_delta_time()
	
	_cleanup_hitbox()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(combo_final_recovery, seq_id):
		return false
	
	return true
	
func _lunge_phase(dir: Vector2, distance: float, speed: float, duration: float, seq_id: int) -> bool:
	"""
	v17.0: Spacing-aware lunge that doesn't overshoot into face-hug range.
	Scales lunge distance based on current distance to player.
	
	Returns false if attack should abort.
	"""
	if dir == Vector2.ZERO or speed <= 0:
		return not _should_abort_attack(seq_id)
	
	# === v17.0: SPACING CHECK ===
	var current_dist := _get_current_distance_to_player()
	var adjusted_distance := distance
	
	if current_dist >= 0:
		# If already in face-hug range, skip lunge entirely
		if current_dist < lunge_min_distance:
			return not _should_abort_attack(seq_id)
		
		# Scale lunge based on how close we already are
		var distance_ratio := clampf(
			(current_dist - lunge_min_distance) / (ideal_combat_distance - lunge_min_distance),
			0.0, 1.0
		)
		adjusted_distance = distance * distance_ratio
	
	# If calculated lunge is negligible, skip it
	if adjusted_distance < 5.0:
		return not _should_abort_attack(seq_id)
	
	var start_pos := global_position
	var elapsed := 0.0
	var adjusted_duration := (adjusted_distance / speed) if speed > 0 else duration
	
	while elapsed < adjusted_duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return false
		
		# Check for hitstop
		if _combo_is_frozen:
			velocity = Vector2.ZERO
			while _combo_is_frozen:
				if _should_abort_attack(seq_id):
					return false
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return false
			continue
		
		var traveled := global_position.distance_to(start_pos)
		if traveled >= adjusted_distance:
			velocity = Vector2.ZERO
			# Wait out remaining duration
			while elapsed < adjusted_duration:
				if _should_abort_attack(seq_id):
					return false
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return false
				elapsed += get_physics_process_delta_time()
			return true
		
		velocity = dir.normalized() * speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false
		elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	return not _should_abort_attack(seq_id)
	
func _wait_duration_interruptible(duration: float, seq_id: int) -> bool:
	"""
	Waits for specified duration, checking for abort conditions each frame.
	Also handles hitstop pauses properly.
	
	Returns false if should abort, true if completed normally.
	"""
	var elapsed := 0.0
	
	while elapsed < duration:
		if _should_abort_attack(seq_id):
			return false
		
		# If in hitstop, pause the timer
		if _combo_is_frozen:
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return false
			continue  # Don't add to elapsed while frozen
		
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false
		elapsed += get_physics_process_delta_time()
	
	return true
	
func _wait_for_combo_parry_recovery(seq_id: int) -> bool:
	while _combo_is_frozen:
		if _should_abort_attack(seq_id):
			return false
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false
	
	# Also wait for legacy stagger system (for compatibility)
	while _is_in_parry_stagger():
		if _should_abort_attack(seq_id):
			return false
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false
	
	# Brief pause after parry before next attack (creates rhythm)
	if combo_parry_resume_delay > 0.0:
		var delay_elapsed := 0.0
		while delay_elapsed < combo_parry_resume_delay:
			if _should_abort_attack(seq_id):
				return false
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return false
			delay_elapsed += get_physics_process_delta_time()
	
	return true
	
func _lunge_toward_direction(dir: Vector2, distance: float, speed: float, duration: float, sequence_id: int = -1) -> void:
	var traveled := 0.0
	var elapsed := 0.0
	var current_dir := dir
	
	while elapsed < duration and traveled < distance:
		if sequence_id >= 0 and _should_abort_attack(sequence_id):
			break
		if _phase == Phase.DEAD or _dbroken_active:
			break
		
		await get_tree().physics_frame
		var dt := get_physics_process_delta_time()
		elapsed += dt
		var player := _get_player()
		if player and is_instance_valid(player):
			var to_player = (player.global_position - global_position).normalized()
			if to_player != Vector2.ZERO:
				current_dir = _rotate_toward(current_dir, to_player, combo_lunge_tracking * 0.3 * dt)
		velocity = current_dir * speed
		_face_direction(current_dir)
		traveled += speed * dt
	velocity = Vector2.ZERO

func _lunge_toward_direction_interruptible(dir: Vector2, dist: float, spd: float, duration: float, seq_id: int) -> void:
	"""
	v13.0: Lunge that respects hitstop but doesn't fight with parry recoil.
	During combos, if we're in hitstop, we just freeze - no velocity conflict.
	"""
	if dir == Vector2.ZERO:
		return
	
	var start_pos := global_position
	var elapsed := 0.0
	
	while elapsed < duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return
		
		# v13.0: If in combo hitstop, freeze and wait (don't fight with recoil)
		if _combo_is_frozen:
			velocity = Vector2.ZERO
			while _combo_is_frozen:
				if _should_abort_attack(seq_id):
					velocity = Vector2.ZERO
					return
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
			# After hitstop, stop lunge and let combo handle continuation
			velocity = Vector2.ZERO
			return
		
		# Legacy parry recoil check (for non-combo attacks)
		if _is_in_parry_recoil() and _current_attack != AttackType.TRIPLE_COMBO:
			while _is_in_parry_recoil():
				if _should_abort_attack(seq_id):
					velocity = Vector2.ZERO
					return
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
			velocity = Vector2.ZERO
			return
		
		var traveled := global_position.distance_to(start_pos)
		if traveled >= dist:
			velocity = Vector2.ZERO
			while elapsed < duration:
				if _should_abort_attack(seq_id):
					return
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
				elapsed += get_physics_process_delta_time()
			return
		
		velocity = dir.normalized() * spd
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	
func _step_toward_player_during_windup_interruptible(dir: Vector2, step_dist: float, step_speed: float, duration: float, seq_id: int) -> void:
	"""Step toward player during windup, interruptible. Yields to parry recoil."""
	var start_pos := global_position
	var elapsed := 0.0
	
	while elapsed < duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return
		
		# v12.0: If we're in parry recoil, don't set velocity
		if _is_in_parry_recoil():
			while _is_in_parry_recoil():
				if _should_abort_attack(seq_id):
					velocity = Vector2.ZERO
					return
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
			velocity = Vector2.ZERO
			return
		
		var traveled := global_position.distance_to(start_pos)
		if traveled < step_dist:
			velocity = dir.normalized() * step_speed
		else:
			velocity = Vector2.ZERO
		
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO
	
func _step_toward_player_during_windup(dir: Vector2, distance: float, speed: float, duration: float, sequence_id: int = -1) -> void:
	var traveled := 0.0
	var elapsed := 0.0
	var current_dir := dir
	
	while elapsed < duration:
		if sequence_id >= 0 and _should_abort_attack(sequence_id):
			break
		if _phase == Phase.DEAD or _dbroken_active:
			break
		
		await get_tree().physics_frame
		var dt := get_physics_process_delta_time()
		elapsed += dt
		var player := _get_player()
		if player and is_instance_valid(player):
			var to_player = (player.global_position - global_position).normalized()
			if to_player != Vector2.ZERO:
				current_dir = _rotate_toward(current_dir, to_player, 90.0 * dt)
				_face_direction(current_dir)
		if traveled < distance:
			velocity = current_dir * speed
			traveled += speed * dt
		else:
			velocity = Vector2.ZERO
	velocity = Vector2.ZERO

# =============================================================================
# HITBOX SPAWNING
# =============================================================================
func _spawn_charge_hitbox(dir: Vector2) -> Area2D:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", shield_advance_damage)
	area.set_meta("damage_type", "captain_charge")
	area.set_meta("attacker", self)
	area.set_meta("parryable", true)
	area.set_meta("telegraphed", true)
	
	var cs := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(48, 36)
	cs.shape = rect
	area.add_child(cs)
	area.position = dir.normalized() * 26.0
	area.rotation = dir.angle()
	add_child(area)
	return area
	
# v10.0: Separate slam hitbox that persists for parry window
func _spawn_slam_hitbox(center: Vector2, damage: int) -> Area2D:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("damage_type", "captain_slam")
	area.set_meta("attacker", self)
	area.set_meta("parryable", true)
	area.set_meta("telegraphed", true)
	
	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = overhead_slam_radius
	cs.shape = shape
	area.add_child(cs)
	area.global_position = center
	get_parent().add_child(area)
	return area

func _spawn_combo_hitbox(dir: Vector2, damage: int) -> Area2D:
	var hitbox := Area2D.new()
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "captain_slash")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", true)
	hitbox.set_meta("telegraphed", true)
	
	var shape := RectangleShape2D.new()
	shape.size = Vector2(combo_swing_length, combo_swing_width)
	var col := CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (combo_swing_length * 0.5)
	hitbox.rotation = dir.angle()
	return hitbox
	
func _spawn_cannon_marker_and_aoe(target_pos: Vector2) -> void:
	var marker := Node2D.new()
	marker.global_position = target_pos
	marker.z_index = z_index - 1
	
	var poly := Polygon2D.new()
	var pts := PackedVector2Array()
	var segments := 20
	for i in range(segments):
		var angle := TAU * float(i) / float(segments)
		pts.append(Vector2(cos(angle), sin(angle)) * cannon_aoe_radius)
	poly.polygon = pts
	poly.color = Color(1, 0, 0, 0.3)
	marker.add_child(poly)
	get_parent().add_child(marker)
	
	await get_tree().create_timer(cannon_warning_time).timeout
	if is_instance_valid(marker):
		marker.queue_free()
	
	_spawn_cannon_aoe(target_pos)

func _spawn_cannon_aoe(center: Vector2) -> void:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", cannon_aoe_damage)
	area.set_meta("damage_type", "cannon")
	area.set_meta("attacker", self)
	area.set_meta("parryable", false)
	area.set_meta("telegraphed", true)

	# Minimal fix: ensure player treats this as unblockable (can’t block/parry)
	area.set_meta("unblockable", true)
	
	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = cannon_aoe_radius
	cs.shape = shape
	area.add_child(cs)
	area.global_position = center
	get_parent().add_child(area)
	
	await get_tree().create_timer(0.25).timeout
	if is_instance_valid(area):
		area.queue_free()

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _phase == Phase.DEAD:
		return
	if damage <= 0 and not (attacker is Area2D and attacker.has_meta("prosthetic_source")):
		return
	if attacker == null:
		return

	var is_player_attack = attacker.is_in_group("player")

	if not is_player_attack and attacker is Area2D:
		if attacker.has_meta("attacker"):
			var meta_attacker = attacker.get_meta("attacker")
			if meta_attacker is Node and meta_attacker.is_in_group("player"):
				is_player_attack = true

	if not is_player_attack and attacker.is_in_group("attack"):
		var owner_check: Node = attacker.get_parent()
		while owner_check != null:
			if owner_check.is_in_group("player"):
				is_player_attack = true
				break
			if owner_check.is_in_group("enemy"):
				break
			owner_check = owner_check.get_parent()

	if not is_player_attack:
		return

	var attacker_pos = global_position
	if attacker is Node2D:
		attacker_pos = attacker.global_position
	elif attacker.has_method("get_parent") and attacker.get_parent() is Node2D:
		attacker_pos = attacker.get_parent().global_position

	var is_blocking_hit = false
	if not _dbroken_active and _phase != Phase.DEAD:
		if _combat_phase != CombatPhase.WINDUP and _combat_phase != CombatPhase.ACTIVE:
			# Confused enemies can't block
			if not ProstheticEffects.is_confused(self):
				if _rng.randf() <= guard_block_chance:
					is_blocking_hit = true

	var final_damage = damage
	var posture_mult = 1.0

	if _is_in_windup():
		final_damage = int(round(float(damage) * windup_damage_mult))
		posture_mult = windup_posture_mult
		_flash_windup_hit()

	if combat:
		var posture_event = {
			"damage": final_damage,
			"blocked": is_blocking_hit
		}
		if posture_mult < 1.0:
			var orig_gain = combat.config.hit_posture_gain if combat.config else 12.0
			if combat.config:
				combat.config.hit_posture_gain = orig_gain * posture_mult
			combat.notify_got_hit(posture_event)
			if combat.config:
				combat.config.hit_posture_gain = orig_gain
		else:
			combat.notify_got_hit(posture_event)

	if is_blocking_hit:
		_guard_block_count += 1
		_guard_last_block_ts = Time.get_ticks_msec() * 0.001

		var chip = int(round(float(final_damage) * guard_chip_damage_mult))
		if chip > 0:
			_apply_damage(chip, damage_type, attacker)
		else:
			_flash_block()

		if guard_block_tolerance_max > 0 and guard_block_tolerance_min > 0:
			var tol_min = max(1, guard_block_tolerance_min)
			var tol_max = max(tol_min, guard_block_tolerance_max)
			var threshold = int(_rng.randi_range(tol_min, tol_max))
			if _guard_block_count >= threshold:
				_guard_block_count = 0
				_start_block_deflect_counter()
	else:
		_guard_block_count = 0
		_apply_damage(final_damage, damage_type, attacker)

	# === PROSTHETIC EFFECTS (centralized, boss resistance) ===
	ProstheticEffects.apply(attacker, self, is_blocking_hit, 0.5)
					
func _flash_windup_hit() -> void:
	if not sprite:
		return
	var orig := sprite.modulate
	sprite.modulate = windup_hit_flash_color
	await get_tree().create_timer(0.04).timeout
	if is_instance_valid(sprite):
		sprite.modulate = orig

func _flash_block() -> void:
	if not sprite:
		return
	var orig := sprite.modulate
	sprite.modulate = Color(0.7, 0.8, 1.0)
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(sprite):
		sprite.modulate = orig

func _flash_hurt_sprite() -> void:
	if not sprite:
		return
	
	var orig := sprite.modulate
	sprite.modulate = Color(1, 0.4, 0.4)
	
	await get_tree().create_timer(0.08).timeout
	
	if is_instance_valid(sprite):
		sprite.modulate = orig

func _apply_damage(damage: int, _damage_type: String, _attacker: Node) -> void:
	if _phase == Phase.DEAD:
		return

	hp = max(hp - damage, 0)

	# Bloodletting Gourd: lifesteal
	if damage > 0:
		var player = _get_player()
		if is_instance_valid(player):
			ProstheticEffects.check_lifesteal(player, damage)

	if hp <= 0:
		_die()
	else:
		hitstop_local(0.005)
		_flash_hurt_sprite()
		
func hitstop_local(duration: float) -> void:
	if anim:
		var was_playing := anim.current_animation
		anim.pause()
		await get_tree().create_timer(duration).timeout
		# FIX: Don't resume old animation if we've died during the hitstop
		if is_instance_valid(anim) and was_playing != "" and _phase != Phase.DEAD:
			anim.play(was_playing)
			
func on_parried(parry_source_pos: Vector2) -> void:
	if _dbroken_active or _phase == Phase.DEAD:
		return
	
	# v15.0: ALWAYS hide indicator immediately on parry
	_hide_parry_indicator()
	
	var local_attack := _current_attack
	var category := _get_attack_category(local_attack)
	
	# v15.0 FIX: APPLY POSTURE DAMAGE - This was completely missing!
	if combat and combat.config:
		# Get current posture using the public getter (FIXED: _posture is private!)
		var current = combat.get_posture()
		var maxv := combat.config.posture_max
		var new_posture = min(current + parry_posture_damage, maxv)
		combat.set_posture(new_posture)
		combat.notify_got_hit({"damage": 0, "parried": true})
		combat.suppress_recovery(1.0)
		print("[VillageOgre] PARRIED! Posture: ", current, " -> ", new_posture, " (+", parry_posture_damage, ")")
	
	_cleanup_hitbox()
	if _guarding:
		_end_guard()
	
	hitstop_local(0.06)
	
	if local_attack == AttackType.TRIPLE_COMBO:
		_start_parry_recoil_v13(local_attack, parry_source_pos)
		
		if anim:
			if anim.has_animation("parried"):
				anim.play("parried")
			elif anim.has_animation("stagger"):
				anim.play("stagger")
		
		_parry_flash_tint()
		
		if _behavior_state != BehaviorState.ATTACKING:
			_behavior_state = BehaviorState.ATTACKING
		
		return
	
	_combo_interrupted = true
	_attack_sequence_id += 1
	
	_start_parry_recoil_v13(local_attack, parry_source_pos)
	
	if anim:
		if anim.has_animation("parried"):
			anim.play("parried")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		elif anim.has_animation("hurt"):
			anim.play("hurt")
		else:
			anim.play("idle")
	
	_parry_flash_tint()
	
	var stagger_time := 0.22
	match local_attack:
		AttackType.OVERHEAD_BREAKER:
			stagger_time = 0.28
		AttackType.SHIELD_ADVANCE:
			stagger_time = 0.24
		_:
			stagger_time = 0.22
	
	await get_tree().create_timer(stagger_time).timeout
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
	
	if min_attack_cooldown > 0.0 and max_attack_cooldown >= min_attack_cooldown:
		_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.2, max_attack_cooldown * 1.5)
	else:
		_attack_cooldown = 0.5
	
	_combo_interrupted = false
	_play_idle()
	
func _parry_flash_tint() -> void:
	"""Non-blocking parry flash for visual feedback."""
	if not sprite:
		return
	var original_mod := sprite.modulate
	sprite.modulate = Color(1.0, 1.0, 1.5)
	await get_tree().create_timer(0.10).timeout
	if is_instance_valid(sprite):
		sprite.modulate = original_mod

func _on_posture_changed(current: float, max_value: float) -> void:
	# Purely UI: update the posture bar and “near break” flashing
	_update_posture_bar(current, max_value)
	# Actual break / deathblow windows are driven by CombatController.posture_broken
	# to avoid double-firing and float/rounding edge cases.

func _trigger_posture_break(duration: float) -> void:
	var player := _get_player()
	if player:
		var pc := player.get_node_or_null("Combat")
		if pc and pc.has_method("set_deathblow_target"):
			pc.set_deathblow_target(self, duration)
		elif pc and pc.has_signal("deathblow_available"):
			pc.emit_signal("deathblow_available", self, duration)

func _on_posture_broken(duration: float) -> void:
	if _guarding:
		_end_guard()
	
	if _dbroken_active or _phase == Phase.DEAD:
		return
	
	_hide_parry_indicator()
		
	# Use the CombatConfig duration when present, fall back to our local default.
	var window := duration
	if window <= 0.0:
		window = deathblow_window_duration
	
	_attack_sequence_id += 1
	
	# Announce the deathblow opportunity to the player
	_trigger_posture_break(window)
	
	var now := Time.get_ticks_msec() * 0.001
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
		elif anim.has_animation("parried"):
			anim.play("parried")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		elif anim.has_animation("hurt"):
			anim.play("hurt")
		else:
			anim.play("idle")
	
	# Start red flashing while posture is broken
	_start_posture_break_flash()
	
	# Local signal for any UI / other listeners
	emit_signal("posture_broken", window)

func _clear_deathblow_state() -> void:
	_dbroken_active = false
	_dbreak_until = -1.0
	_dbreak_immunity_until = -1.0
	
	# Stop posture-break red flashing and restore base tint
	_stop_posture_break_flash()

func _end_deathblow_window() -> void:
	# Called when the deathblow window expires without the player finishing,
	# or when we manually clear it (e.g. multi-pip partial).
	if not _dbroken_active:
		return
	
	_clear_deathblow_state()
	_deathblow_in_progress = false
	
	# Recover some posture so we don't re-break instantly if the fight continues
	if combat and combat.config:
		var maxv := combat.config.posture_max
		combat.set_posture(maxv * 0.35)
	elif combat:
		combat.set_posture(0.0)
	
	if _phase != Phase.DEAD:
		_behavior_state = BehaviorState.IDLE
		_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.1, max_attack_cooldown * 1.4)
		_play_idle()
	
	emit_signal("posture_recovered")

func take_deathblow(attacker: Node) -> void:
	# Only valid while posture is broken and we're alive
	if _phase == Phase.DEAD:
		return
	if not _dbroken_active:
		return
	if _deathblow_in_progress:
		return
	_deathblow_in_progress = true
	
	# Fully drain posture on a successful finisher
	if combat and combat.config:
		combat.set_posture(0.0)
	
	var final_damage := deathblow_damage
	var instant_kill := deathblow_instant_kill
	
	# Optional multi-pip style – only really useful once you add UI for it.
	# For partial pips we play a finisher animation + stun, but DO NOT deal HP damage yet.
	if deathblow_pips > 1:
		if _current_pip < deathblow_pips:
			_current_pip += 1
			# Partial finisher: consume the current window but don't actually damage HP.
			_clear_deathblow_state()
			_deathblow_in_progress = false
			
			var now := Time.get_ticks_msec() * 0.001
			_stun_until = now + 0.65
			_behavior_state = BehaviorState.IDLE
			_current_attack = AttackType.NONE
			_combat_phase = CombatPhase.NONE
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			
			if anim and anim.has_animation("deathblow"):
				anim.play("deathblow")
			elif anim and anim.has_animation("hurt"):
				anim.play("hurt")
			else:
				_play_idle()
			
			# This posture break is over; clear any red-tint VFX listeners.
			emit_signal("posture_recovered")
			return
		# If we reached here on a multi-pip setup we've already filled all pips,
		# so we fall through to apply real HP damage below.
	
	# Normal / final-pip deathblow: convert configuration into actual HP damage.
	var damage_to_deal := 0
	if instant_kill:
		# Make sure we actually kill, regardless of current HP value.
		damage_to_deal = max(hp, 1)
	else:
		damage_to_deal = final_damage
	
	_apply_damage(damage_to_deal, "deathblow", attacker)
	
	if hp <= 0:
		# Lethal finisher: _apply_damage already called _die() and started the death animation.
		_clear_deathblow_state()
		_deathblow_in_progress = false
		# Clear posture-broken visuals even if we died during the deathblow.
		emit_signal("posture_recovered")
		return
	
	# Non-lethal deathblow: big chunk of HP, then enemy recovers from
	# the broken state after a short stun – posture must be re-broken
	# for another finisher.
	_clear_deathblow_state()
	emit_signal("posture_recovered")
	
	var now2 := Time.get_ticks_msec() * 0.001
	_stun_until = now2 + 0.65
	
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	
	_cleanup_hitbox()
	
	if anim and anim.has_animation("deathblow"):
		anim.play("deathblow")
	elif anim and anim.has_animation("hurt"):
		anim.play("hurt")
	else:
		_play_idle()
	
	var original_mod := sprite.modulate if sprite else Color.WHITE
	if sprite:
		sprite.modulate = Color(1.0, 0.8, 0.4)
	await get_tree().create_timer(0.15).timeout
	if is_instance_valid(sprite):
		sprite.modulate = original_mod
	
	await get_tree().create_timer(0.50).timeout
	if not is_instance_valid(self):
		return
	
	velocity = Vector2.ZERO
	_deathblow_in_progress = false
	
	if _phase != Phase.DEAD:
		if anim and anim.has_animation("idle"):
			anim.play("idle")
		_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.1, max_attack_cooldown * 1.5)
		_behavior_state = BehaviorState.IDLE

func on_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

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
	velocity = Vector2.ZERO
	
	_attack_sequence_id += 1
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if _bars_container:
		_bars_container.visible = false
	
	_cleanup_hitbox()
	_release_all_attack_director_state()
	
	if is_in_group("brute"):
		remove_from_group("brute")
	
	if is_in_group("village_ogre"):
		remove_from_group("village_ogre")
	
	emit_signal("defeated")
	emit_signal("enemy_died", self)
	
	notify_stance_effects_enemy_death()
	
	if death_anim:
		spawn_death_vfx(death_anim)
	
	if exp_gem:
		spawn_experience_gem(exp_gem, loot_base)
	
	award_area_gold_drop()
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		var start_time := Time.get_ticks_msec() * 0.001
		var max_wait := 4.0
		
		while anim.is_playing() and (Time.get_ticks_msec() * 0.001 - start_time) < max_wait:
			await get_tree().process_frame
	else:
		await get_tree().create_timer(0.5).timeout
	
	if not is_instance_valid(self):
		return
	
	if sprite:
		sprite.visible = false
	
	queue_free()

# =============================================================================
# GUARD HELPERS
# =============================================================================
func _start_guard() -> void:
	_guarding = true
	_guard_block_count = 0
	_guard_last_block_ts = 0.0
	_set_blocking(true)

func _end_guard() -> void:
	_guarding = false
	_guard_block_count = 0
	_guard_last_block_ts = 0.0
	_set_blocking(false)

func _update_guard_block_decay(_delta: float) -> void:
	if _guard_block_count <= 0:
		return
	if guard_block_series_timeout <= 0.0:
		return
	var now := Time.get_ticks_msec() * 0.001
	if now - _guard_last_block_ts > guard_block_series_timeout:
		_guard_block_count = 0

func _start_block_deflect_counter() -> void:
	if _phase == Phase.DEAD or _dbroken_active:
		return

	# Small freeze after the last blocked hit
	await get_tree().create_timer(deflect_pause_time).timeout

	if not is_instance_valid(self):
		return

	var player := _get_player()
	if not player:
		return

	var to_player = player.global_position - global_position
	var dist = to_player.length()
	var dir = to_player.normalized() if dist > 0.0 else Vector2.RIGHT

	_face_direction(dir)
	_attack_cooldown = 0.0

	# Sekiro-style: after multiple blocks, always counter with a clear melee string
	var melee_choice := AttackType.TRIPLE_COMBO if _rng.randf() < 0.5 else AttackType.OVERHEAD_BREAKER

	if dist > close_range:
		# Walk in, then perform the chosen string
		_pending_melee_attack = melee_choice
		_transition_to_approaching(melee_choice)
	else:
		# Already in range – strike immediately
		_start_attack(melee_choice)

func _get_player() -> Node:
	var p := get_tree().get_first_node_in_group("player")
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

func _rotate_toward(current: Vector2, target: Vector2, max_degrees: float) -> Vector2:
	if current == Vector2.ZERO:
		return target
	if target == Vector2.ZERO:
		return current
	var angle_diff := wrapf(target.angle() - current.angle(), -PI, PI)
	var max_radians := deg_to_rad(max_degrees)
	var step = clamp(angle_diff, -max_radians, max_radians)
	return current.rotated(step).normalized()

func get_enemy_damage() -> int:
	return combo1_damage

func _cleanup_hitbox() -> void:
	# v14.0: Always hide indicator when hitbox is cleaned up
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
		_current_hitbox.queue_free()
	_current_hitbox = null
	
func _start_posture_break_flash() -> void:
	if not sprite:
		return
	
	# Remember the normal tint so we can restore it later
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
	
	# Immediately go to red so the feedback is instant
	sprite.modulate = Color(1.0, 0.35, 0.35)


func _on_posture_break_flash_tick() -> void:
	# Stop if the posture-break state is gone or we died
	if not _dbroken_active or _phase == Phase.DEAD:
		_stop_posture_break_flash()
		return
	
	if not sprite:
		return
	
	if _posture_break_flash_on:
		sprite.modulate = _base_modulate
	else:
		# Red tint while broken
		sprite.modulate = Color(1.0, 0.35, 0.35)
	
	_posture_break_flash_on = not _posture_break_flash_on


func _stop_posture_break_flash() -> void:
	if _posture_break_flash_timer:
		_posture_break_flash_timer.stop()
	_posture_break_flash_on = false
	
	if sprite:
		# Restore the normal look (no lingering tint)
		sprite.modulate = _base_modulate

# Minimal compatibility wrapper: Player fallback deathblow calls receive_deathblow()
func receive_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func is_deathblow_ready() -> bool:
	return _dbroken_active and _phase != Phase.DEAD

func _should_block_incoming_sc(attacker_pos: Vector2, damage_type: String) -> bool:
	# Never block while posture-broken or dead
	if _dbroken_active or _phase == Phase.DEAD:
		return false

	# Mirror ChainCollector behavior: don’t “auto-block” during windup/active
	# (these are the vulnerable frames where HP can slip through)
	if _combat_phase == CombatPhase.WINDUP or _combat_phase == CombatPhase.ACTIVE:
		return false

	# Optional safety: don’t block special incoming types if you ever tag them
	var dtype := str(damage_type)
	if dtype == "grab" or dtype == "mass":
		return false

	# Must be in front to block
	if not _is_frontal_attack_pos(attacker_pos):
		return false

	# Main guard chance
	return _rng.randf() <= guard_block_chance

func _player_hidden_in_smoke(player: Node2D) -> bool:
	if not is_instance_valid(player):
		return false
	return player.has_meta("in_smoke_cloud") and player.get_meta("in_smoke_cloud")
