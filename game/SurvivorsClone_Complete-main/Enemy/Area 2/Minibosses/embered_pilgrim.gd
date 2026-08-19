extends HumanoidEnemyBase
class_name EmberedPilgrim

# =============================================================================
# CORE STATS
# =============================================================================
@export var pilgrim_max_hp: int = 280
@export var base_movement_speed = 50.0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage = 22.0
@export var block_posture_damage = 8.0
@export var deathblow_window_duration = 3.0
@export var deathblow_immunity_time = 0.3
@export var deathblow_damage = 90
@export var deathblow_instant_kill = false
@export var deathblow_pips = 1

# =============================================================================
# WINDUP ARMOR
# =============================================================================
@export_group("Windup Armor")
@export var windup_damage_mult = 0.6
@export var windup_posture_mult = 0.5
@export var windup_knockback_mult = 0.3
@export var windup_hit_flash_color = Color(0.8, 0.9, 1.0, 1.0)

# =============================================================================
# PARRY TIMING
# =============================================================================
@export_group("Parry Timing")
@export var parry_early_window = 0.12
@export var parry_linger_window = 0.20
@export var hitbox_min_lifetime = 0.15

# =============================================================================
# PYRE CHARGE SYSTEM — The core mechanic
# =============================================================================
@export_group("Pyre Charge")
## Seconds of combat before Channel 1 becomes available
@export var channel_1_threshold = 22.0
## Seconds of combat before Channel 2 becomes available
@export var channel_2_threshold = 48.0
## How long each channel takes (player punish window)
@export var channel_duration = 3.8
## Damage multiplier during channeling (0.35 = 65% reduction)
@export var channel_damage_mult = 0.35
## AOE blast at end of channel
@export var channel_aoe_radius = 80.0
@export var channel_aoe_damage = 12
@export var channel_aoe_posture = 20.0
## Telegraph time for channel AOE (shorter on channel 2)
@export var channel_1_aoe_telegraph = 0.8
@export var channel_2_aoe_telegraph = 0.6
## How long pyre charge pauses after player lands a parry
@export var pyre_parry_pause_duration = 1.5

# =============================================================================
# PHASE SPEED MULTIPLIERS (relative to base_movement_speed)
# =============================================================================
@export_group("Phase Scaling")
@export var phase_1_speed_mult = 1.15
@export var phase_2_speed_mult = 1.30
## Attack speed multiplier per phase (scales telegraph/recovery times)
@export var phase_1_attack_speed = 0.88
@export var phase_2_attack_speed = 0.75

# =============================================================================
# DISTANCE THRESHOLDS
# =============================================================================
@export_group("Distance Thresholds")
@export var close_range = 90.0
@export var mid_range = 180.0
@export var far_range = 280.0

# =============================================================================
# SPACING
# =============================================================================
@export_group("Spacing")
@export var ideal_combat_distance = 65.0
@export var too_close_threshold = 35.0
@export var lunge_min_distance = 25.0
@export var min_separation = 20.0
@export var post_combo_spacing_chance = 0.30
@export var spacing_slide_distance = 40.0
@export var spacing_slide_speed = 90.0

# =============================================================================
# APPROACH
# =============================================================================
@export_group("Approach")
@export var approach_speed = 130.0
@export var approach_acceleration = 35.0
@export var approach_max_speed = 170.0
@export var approach_commitment_time = 3.5

# =============================================================================
# NORMAL SWINGS (adapted from Triple Combo)
# =============================================================================
@export_group("Normal Swings")
@export var swing_damage = 8
@export var swing_range = 70.0
@export var swing_width = 55.0
@export var swing_telegraph = 0.40
@export var swing_active = 0.15
@export var swing_recovery = 0.40
@export var swing_lunge_distance = 35.0
@export var swing_lunge_speed = 400.0
@export var swing_inter_hit_gap = 0.12
@export var swing_initial_windup = 0.35

# =============================================================================
# OVERHEAD SLAM
# =============================================================================
@export_group("Overhead Slam")
@export var overhead_windup = 0.85
@export var overhead_recovery = 0.65
@export var overhead_slam_radius = 60.0
@export var overhead_slam_damage = 14
@export var overhead_parry_preframe = 0.12
## Charging variant (Phase 1+)
@export var overhead_charge_speed = 260.0
@export var overhead_charge_duration = 0.45
@export var overhead_charge_track_base = 0.70
## Posture multiplier when hit while guard is down (HP is the main reward)
@export var unguarded_posture_mult = 0.3
# =============================================================================
# ASH STOMP
# =============================================================================
@export_group("Ash Stomp")
@export var stomp_radius = 45.0
@export var stomp_damage = 4
@export var stomp_posture_damage = 15.0
@export var stomp_telegraph = 0.30
@export var stomp_recovery = 0.35
@export var stomp_player_hit_threshold_base = 3
@export var stomp_player_hit_threshold_p1 = 2

# =============================================================================
# PYRE SWEEP (always parry-only)
# =============================================================================
@export_group("Pyre Sweep")
@export var sweep_range = 85.0
@export var sweep_width = 70.0
@export var sweep_damage = 10
@export var sweep_telegraph = 0.50
@export var sweep_active = 0.18
@export var sweep_recovery = 0.45

# =============================================================================
# BURNING THRUST
# =============================================================================
@export_group("Burning Thrust")
@export var thrust_damage = 12
@export var thrust_range = 90.0
@export var thrust_telegraph = 0.75
@export var thrust_active = 0.15
@export var thrust_recovery_base = 0.50
@export var thrust_recovery_p2 = 0.70
@export var thrust_lunge_distance = 60.0
@export var thrust_lunge_speed = 500.0
@export var thrust_parry_stagger_mult = 1.5
@export var thrust_burn_duration_p1 = 2.5
@export var thrust_burn_duration_p2 = 3.5
@export var thrust_burn_dps = 2.0

# =============================================================================
# DARK ORBS (Phase 1+ only)
# =============================================================================
@export_group("Dark Orbs")
@export var orb_count_phase1 = 3
@export var orb_count_phase2 = 5
@export var orb_speed = 280.0
@export var orb_damage = 6
@export var orb_spread_angle_p1 = 30.0
@export var orb_spread_angle_p2 = 22.0
@export var orb_telegraph = 0.60
@export var orb_recovery = 0.50
@export var orb_track_cutoff_p1 = 0.5
@export var orb_track_cutoff_p2 = 0.3
@export var orb_min_range = 120.0
## Phase 2: dash after orb volley
@export var orb_dash_speed = 300.0
@export var orb_dash_duration = 0.25

# =============================================================================
# AFTERIMAGE SYSTEM (Phase 2 only)
# =============================================================================
@export_group("Afterimage")
@export var afterimage_duration = 0.3
@export var afterimage_posture_damage = 5.0
@export var afterimage_alpha = 0.4

# =============================================================================
# EMBER PATCHES (lingering damage areas)
# =============================================================================
@export_group("Ember Patches")
@export var ember_tick_damage = 1.0
@export var ember_posture_per_sec = 3.0

# =============================================================================
# ATTACK PACING & DESIRE SYSTEM
# =============================================================================
@export_group("Attack Pacing")
@export var min_attack_cooldown = 1.0
@export var max_attack_cooldown = 1.8

@export_group("Desire System")
@export var swing_base_chance = 0.22
@export var overhead_base_chance = 0.10
@export var sweep_base_chance = 0.06
@export var thrust_base_chance = 0.04
@export var orb_base_chance = 0.08
@export var desire_growth = 0.10
@export var max_desire = 0.55

# =============================================================================
# ENUMS
# =============================================================================
enum Phase { ALIVE, DEAD }
enum PyrePhase { BASE, PHASE_1, PHASE_2 }
enum BehaviorState { IDLE, PURSUING, APPROACHING, ATTACKING, CHANNELING }
enum AttackType { NONE, NORMAL_SWINGS, OVERHEAD_SLAM, ASH_STOMP, PYRE_SWEEP, BURNING_THRUST, DARK_ORBS, PYRE_CHANNEL }
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

# =============================================================================
# STATE
# =============================================================================
var _phase = Phase.ALIVE
var _pyre_phase = PyrePhase.BASE
var _behavior_state = BehaviorState.IDLE
var _current_attack = AttackType.NONE
var _pending_melee_attack = AttackType.NONE
var _combat_phase = CombatPhase.NONE

# Pyre charge
var _pyre_charge = 0.0
var _pyre_charge_paused_until = 0.0
var _channel_pending = false
var _is_channeling = false

# Combo tracking
var _combo_hit_index = 0
var _combo_interrupted = false
var _combo_is_frozen = false
var _combo_parry_freeze_until = 0.0
var _combo_should_continue = true

# Attack sequencing
var _attack_sequence_id = 0
var _attack_cooldown = 0.0
var _approach_timer = 0.0
var _approach_current_speed = 0.0

# Desire accumulators
var _swing_desire = 0.0
var _overhead_desire = 0.0
var _sweep_desire = 0.0
var _thrust_desire = 0.0
var _orb_desire = 0.0

# Player aggression tracking (for Ash Stomp reactive trigger)
var _player_recent_hits = 0.0
var _player_hit_decay_rate = 2.0

# Parry recoil
var _parry_recoil_until = 0.0
var _parry_recoil_velocity = Vector2.ZERO
var _parry_stagger_until = 0.0
var _post_parry_recovery = 0.28
var _combo_parry_hitstop = 0.12
var _combo_parry_resume_delay = 0.15

# Deathblow
var _dbroken_active = false
var _dbreak_until = -1.0
var _dbreak_immunity_until = 0.0
var _deathblow_in_progress = false
var _stun_until = 0.0
var _current_pip = 1

# Posture break flash
var _posture_break_flash_timer: Timer = null
var _posture_break_flash_on = false
var _base_modulate = Color(1, 1, 1)

# Hitbox tracking
var _current_hitbox: Area2D = null
var _is_current_hitbox_melee = false

# Active projectiles (dark orbs)
var _active_projectiles: Array = []

# UI
var _bars_container: Node2D
var _pilgrim_posture_bg: ColorRect
var _pilgrim_posture_fill: ColorRect
var _hp_bg: ColorRect
var _hp_fill: ColorRect
# Pyre charge bar
var _pyre_bg: ColorRect
var _pyre_fill: ColorRect

var _rng = RandomNumberGenerator.new()

# =============================================================================
# SIGNALS
# =============================================================================
signal defeated
signal posture_broken(duration: float)
signal posture_recovered

# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	super._ready()
	
	hp = pilgrim_max_hp
	_max_hp = pilgrim_max_hp
	
	_current_pip = 1
	_pyre_phase = PyrePhase.BASE
	_pyre_charge = 0.0
	_channel_pending = false
	_is_channeling = false
	_attack_sequence_id = 0
	_combat_phase = CombatPhase.NONE
	
	can_block = true
	block_by_default = true
	movement_speed = base_movement_speed
	
	_rng.randomize()
	
	add_to_group("miniboss")
	add_to_group("embered_pilgrim")
	
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

# =============================================================================
# PHYSICS PROCESS
# =============================================================================
func _physics_process(delta: float) -> void:
	if _phase == Phase.DEAD:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _humanoid_shared_tick(delta):
		_tick_projectiles(delta)
		if _bars_container:
			_bars_container.global_position = global_position
		_update_bars()
		return
	
	# Combo hitstop freeze
	if _combo_is_frozen:
		var now = Time.get_ticks_msec() * 0.001
		if now >= _combo_parry_freeze_until:
			_combo_is_frozen = false
		else:
			velocity = Vector2.ZERO
			_apply_soft_separation()
			move_and_slide()
			return
	
	_tick_projectiles(delta)
	
	if _bars_container:
		_bars_container.global_position = global_position
	_update_bars()

	var now = Time.get_ticks_msec() * 0.001
	_set_blocking(_is_guarding())

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

	# Posture broken — locked
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

	if combat:
		combat.update_health_ratio(float(hp), float(get_max_hp()))
		combat.tick(delta)

	_attack_cooldown = max(_attack_cooldown - delta, 0.0)

	# --- PYRE CHARGE TICK ---
	_tick_pyre_charge(delta, now)

	# --- PLAYER HIT DECAY (for Ash Stomp) ---
	_player_recent_hits = max(0.0, _player_recent_hits - _player_hit_decay_rate * delta)

	# --- AI STATE MACHINE ---
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
			_process_idle_state(player, dist, dir, delta)
		BehaviorState.PURSUING:
			_process_pursuing_state(player, dist, dir, delta)
		BehaviorState.APPROACHING:
			_process_approaching_state(player, dist, dir, delta)
		BehaviorState.ATTACKING:
			pass
		BehaviorState.CHANNELING:
			pass

	_apply_soft_separation()
	_update_pyre_glow()
	move_and_slide()


# =============================================================================
# PYRE CHARGE SYSTEM
# =============================================================================
func _tick_pyre_charge(delta: float, now: float) -> void:
	if _phase == Phase.DEAD or _dbroken_active:
		return
	if _pyre_phase == PyrePhase.PHASE_2:
		return
	if _is_channeling:
		return
	if now < _pyre_charge_paused_until:
		return

	_pyre_charge += delta

	var should_channel = false
	if _pyre_phase == PyrePhase.BASE and _pyre_charge >= channel_1_threshold:
		should_channel = true
	elif _pyre_phase == PyrePhase.PHASE_1 and _pyre_charge >= channel_2_threshold:
		should_channel = true

	if should_channel and not _channel_pending:
		_channel_pending = true
		# Force-interrupt any in-progress attack or approach
		if _behavior_state == BehaviorState.ATTACKING:
			_attack_sequence_id += 1
			_combo_interrupted = true
			_cleanup_hitbox()
			_combat_phase = CombatPhase.NONE
			_current_attack = AttackType.NONE
			velocity = Vector2.ZERO
		if _behavior_state == BehaviorState.APPROACHING:
			_pending_melee_attack = AttackType.NONE
			velocity = Vector2.ZERO
		# Force to IDLE so channel picks up this same frame
		_behavior_state = BehaviorState.IDLE

func _update_pyre_glow() -> void:
	if not sprite:
		return
	if _phase == Phase.DEAD:
		return

	var glow_t = 0.0
	match _pyre_phase:
		PyrePhase.BASE:
			glow_t = clamp(_pyre_charge / max(1.0, channel_1_threshold), 0.0, 1.0) * 0.4
		PyrePhase.PHASE_1:
			var progress = (_pyre_charge - channel_1_threshold) / max(1.0, channel_2_threshold - channel_1_threshold)
			glow_t = 0.4 + clamp(progress, 0.0, 1.0) * 0.3
		PyrePhase.PHASE_2:
			glow_t = 0.7 + 0.15 * sin(Time.get_ticks_msec() * 0.003)

	# Don't override posture break flash or channel visuals
	if _dbroken_active or _is_channeling:
		return

	var base = Color(1.0, 1.0, 1.0)
	var ember = Color(1.0, 0.7, 0.3)
	sprite.modulate = base.lerp(ember, glow_t)

func pause_pyre_charge() -> void:
	_pyre_charge_paused_until = Time.get_ticks_msec() * 0.001 + pyre_parry_pause_duration

func _advance_pyre_phase() -> void:
	match _pyre_phase:
		PyrePhase.BASE:
			_pyre_phase = PyrePhase.PHASE_1
		PyrePhase.PHASE_1:
			_pyre_phase = PyrePhase.PHASE_2

func _get_speed_mult() -> float:
	match _pyre_phase:
		PyrePhase.PHASE_1:
			return phase_1_speed_mult
		PyrePhase.PHASE_2:
			return phase_2_speed_mult
	return 1.0

func _get_attack_speed_mult() -> float:
	## Returns a multiplier < 1.0 that shortens telegraph/recovery times
	match _pyre_phase:
		PyrePhase.PHASE_1:
			return phase_1_attack_speed
		PyrePhase.PHASE_2:
			return phase_2_attack_speed
	return 1.0


# =============================================================================
# AI STATE MACHINE
# =============================================================================
func _process_idle_state(player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	velocity = Vector2.ZERO
	_face_direction(dir)
	_play_idle()

	# Channel takes absolute priority — no cooldown gate
	if _channel_pending:
		_channel_pending = false
		_pending_melee_attack = AttackType.NONE
		_start_attack(AttackType.PYRE_CHANNEL)
		return

	if dist > mid_range + 50.0:
		_transition_to_pursuing()
		return

	if _attack_cooldown <= 0.0:
		if _should_ash_stomp(dist):
			_start_attack(AttackType.ASH_STOMP)
			return

		var attack = _choose_attack(dist)
		if attack == AttackType.NONE:
			return

		if dist > close_range and attack in [AttackType.NORMAL_SWINGS, AttackType.OVERHEAD_SLAM, AttackType.BURNING_THRUST, AttackType.PYRE_SWEEP]:
			_pending_melee_attack = attack
			_transition_to_approaching(attack)
		else:
			_start_attack(attack)

func _process_pursuing_state(_player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	if dist <= mid_range:
		_behavior_state = BehaviorState.IDLE
		return
	velocity = dir * base_movement_speed * _get_speed_mult()
	_face_direction(dir)
	_play_walk()

func _process_approaching_state(player: Node2D, dist: float, dir: Vector2, delta: float) -> void:
	_approach_timer -= delta
	_approach_current_speed = min(_approach_current_speed + approach_acceleration * delta, approach_max_speed)
	velocity = dir * _approach_current_speed * _get_speed_mult()
	_face_direction(dir)
	_play_walk()

	if dist <= close_range:
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		if _pending_melee_attack != AttackType.NONE:
			var atk = _pending_melee_attack
			_pending_melee_attack = AttackType.NONE
			_start_attack(atk)
		return

	if _approach_timer <= 0.0:
		if _pending_melee_attack != AttackType.NONE and dist <= close_range * 2.0:
			var atk = _pending_melee_attack
			_pending_melee_attack = AttackType.NONE
			_start_attack(atk)
		else:
			_behavior_state = BehaviorState.IDLE

func _transition_to_pursuing() -> void:
	_behavior_state = BehaviorState.PURSUING
	_pending_melee_attack = AttackType.NONE

func _transition_to_approaching(attack: AttackType) -> void:
	_behavior_state = BehaviorState.APPROACHING
	_pending_melee_attack = attack
	_approach_timer = approach_commitment_time
	_approach_current_speed = approach_speed


# =============================================================================
# ATTACK START / FINISH
# =============================================================================
func _start_attack(attack: AttackType) -> void:
	_behavior_state = BehaviorState.ATTACKING if attack != AttackType.PYRE_CHANNEL else BehaviorState.CHANNELING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1

	match attack:
		AttackType.NORMAL_SWINGS:
			_do_normal_swings()
		AttackType.OVERHEAD_SLAM:
			_do_overhead_slam()
		AttackType.ASH_STOMP:
			_do_ash_stomp()
		AttackType.PYRE_SWEEP:
			_do_pyre_sweep()
		AttackType.BURNING_THRUST:
			_do_burning_thrust()
		AttackType.DARK_ORBS:
			_do_dark_orbs()
		AttackType.PYRE_CHANNEL:
			_do_pyre_channel()

func _finish_attack() -> void:
	var cd_min = min_attack_cooldown
	var cd_max = max_attack_cooldown

	# Slightly faster re-engagement after melee
	if _current_attack in [AttackType.NORMAL_SWINGS, AttackType.OVERHEAD_SLAM, AttackType.PYRE_SWEEP, AttackType.BURNING_THRUST]:
		cd_min *= 0.7
		cd_max *= 0.85

	_attack_cooldown = _rng.randf_range(cd_min, cd_max)
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE

	# Post-attack spacing slide if too close
	if _is_face_hugging() or _rng.randf() < post_combo_spacing_chance:
		_behavior_state = BehaviorState.IDLE
		await _do_spacing_slide()

	_behavior_state = BehaviorState.IDLE
	_cleanup_hitbox()
	_combo_interrupted = false
	_play_idle()


# =============================================================================
# ATTACK SELECTION — Phase-dependent weighted desire system
# =============================================================================
func _choose_attack(dist: float) -> AttackType:
	var weights = {}
	var is_too_close = dist < too_close_threshold

	# --- NORMAL SWINGS ---
	var swing_weight = swing_base_chance + _swing_desire
	match _pyre_phase:
		PyrePhase.BASE:
			swing_weight *= 2.5   # Dominant in base phase
		PyrePhase.PHASE_1:
			swing_weight *= 1.8
		PyrePhase.PHASE_2:
			swing_weight *= 1.2
	if is_too_close:
		swing_weight *= 0.5
	weights[AttackType.NORMAL_SWINGS] = swing_weight

	# --- OVERHEAD SLAM ---
	var overhead_weight = overhead_base_chance + _overhead_desire
	if is_too_close:
		overhead_weight *= 1.4  # Good at close range (no lunge needed)
	elif dist > close_range * 1.8:
		overhead_weight = 0.0
	# Phase 1+: charge variant makes it usable at mid-range too
	if _pyre_phase != PyrePhase.BASE and dist > close_range and dist <= mid_range:
		overhead_weight *= 1.3
	weights[AttackType.OVERHEAD_SLAM] = overhead_weight

	# --- PYRE SWEEP (always parry-only, scales with phase) ---
	var sweep_weight = sweep_base_chance + _sweep_desire
	match _pyre_phase:
		PyrePhase.BASE:
			sweep_weight *= 0.6   # Rare in base
		PyrePhase.PHASE_1:
			sweep_weight *= 1.5
		PyrePhase.PHASE_2:
			sweep_weight *= 2.5   # Very frequent in phase 2
	if dist > close_range * 1.5:
		sweep_weight = 0.0
	weights[AttackType.PYRE_SWEEP] = sweep_weight

	# --- BURNING THRUST ---
	var thrust_weight = thrust_base_chance + _thrust_desire
	match _pyre_phase:
		PyrePhase.BASE:
			thrust_weight *= 0.4  # Very rare
		PyrePhase.PHASE_1:
			thrust_weight *= 1.2
		PyrePhase.PHASE_2:
			thrust_weight *= 2.0
	if dist > mid_range:
		thrust_weight = 0.0
	weights[AttackType.BURNING_THRUST] = thrust_weight

	# --- DARK ORBS (Phase 1+ only, ranged) ---
	var orb_weight = 0.0
	if _pyre_phase != PyrePhase.BASE and dist >= orb_min_range:
		orb_weight = orb_base_chance + _orb_desire
		if _pyre_phase == PyrePhase.PHASE_2:
			orb_weight *= 1.5
	weights[AttackType.DARK_ORBS] = orb_weight

	# Weighted random selection
	var total = 0.0
	for w in weights.values():
		total += w

	if total <= 0.0:
		# Nothing valid — just swing
		_on_attack_chosen(AttackType.NORMAL_SWINGS)
		return AttackType.NORMAL_SWINGS

	var pick = _rng.randf() * total
	var acc = 0.0
	for atk in weights:
		acc += weights[atk]
		if pick <= acc and weights[atk] > 0.0:
			_on_attack_chosen(atk)
			return atk

	_on_attack_chosen(AttackType.NORMAL_SWINGS)
	return AttackType.NORMAL_SWINGS

func _on_attack_chosen(chosen: AttackType) -> void:
	# Reset chosen desire, grow all others
	match chosen:
		AttackType.NORMAL_SWINGS: _swing_desire = 0.0
		AttackType.OVERHEAD_SLAM: _overhead_desire = 0.0
		AttackType.PYRE_SWEEP: _sweep_desire = 0.0
		AttackType.BURNING_THRUST: _thrust_desire = 0.0
		AttackType.DARK_ORBS: _orb_desire = 0.0

	if chosen != AttackType.NORMAL_SWINGS:
		_swing_desire = minf(_swing_desire + desire_growth, max_desire)
	if chosen != AttackType.OVERHEAD_SLAM:
		_overhead_desire = minf(_overhead_desire + desire_growth, max_desire)
	if chosen != AttackType.PYRE_SWEEP:
		_sweep_desire = minf(_sweep_desire + desire_growth, max_desire)
	if chosen != AttackType.BURNING_THRUST:
		_thrust_desire = minf(_thrust_desire + desire_growth, max_desire)
	if chosen != AttackType.DARK_ORBS:
		_orb_desire = minf(_orb_desire + desire_growth, max_desire)

func _should_ash_stomp(dist: float) -> bool:
	if dist > stomp_radius + 20.0:
		return false
	match _pyre_phase:
		PyrePhase.BASE:
			return _player_recent_hits >= stomp_player_hit_threshold_base
		PyrePhase.PHASE_1:
			return _player_recent_hits >= stomp_player_hit_threshold_p1
		PyrePhase.PHASE_2:
			# Phase 2: proactive — use it as opener/mid-fight tool
			return _rng.randf() < 0.25
	return false

# =============================================================================
# ATTACK: NORMAL SWINGS
# =============================================================================
# Base: 2-hit combo, blockable/parryable
# Phase 1: 3-hit combo, third hit parry-only
# Phase 2: 3-hit combo, first two parry-only, third unblockable
# =============================================================================
func _do_normal_swings() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_combo_interrupted = false
	_combo_hit_index = 0
	_combo_should_continue = true
	_combo_is_frozen = false
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	var base_dir = Vector2.RIGHT
	if player:
		base_dir = (player.global_position - global_position).normalized()
	if base_dir == Vector2.ZERO:
		base_dir = Vector2.RIGHT
	_face_direction(base_dir)

	if anim and anim.has_animation("combo_start"):
		anim.play("combo_start")
	if not await _wait_duration_interruptible(swing_initial_windup * _get_attack_speed_mult(), my_seq):
		return

	var hit_count = _get_swing_hit_count()

	for i in range(hit_count):
		_combo_hit_index = i + 1
		var is_unblockable = _is_swing_unblockable(i)
		var is_parry_only = _is_swing_parry_only(i)
		var telegraph = swing_telegraph * _get_attack_speed_mult()
		var recovery = swing_recovery * _get_attack_speed_mult()

		if not await _execute_pilgrim_combo_hit(
			my_seq, telegraph, swing_active, recovery,
			swing_lunge_distance, swing_lunge_speed, swing_damage,
			is_parry_only, is_unblockable, true
		):
			return

		if i < hit_count - 1 and swing_inter_hit_gap > 0.0:
			if not await _wait_duration_interruptible(swing_inter_hit_gap, my_seq):
				return

	_set_combat_phase(CombatPhase.NONE)
	_combo_interrupted = false
	_combo_hit_index = 0
	_finish_attack()

func _get_swing_hit_count() -> int:
	if _pyre_phase == PyrePhase.BASE:
		return 2
	return 3

func _is_swing_parry_only(hit_index: int) -> bool:
	match _pyre_phase:
		PyrePhase.BASE:
			return false
		PyrePhase.PHASE_1:
			return hit_index == 2
		PyrePhase.PHASE_2:
			return hit_index < 2
	return false

func _is_swing_unblockable(hit_index: int) -> bool:
	if _pyre_phase == PyrePhase.PHASE_2 and hit_index == 2:
		return true
	return false


# =============================================================================
# ATTACK: OVERHEAD SLAM
# =============================================================================
func _do_overhead_slam() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	var player = _get_player()
	var dist = 0.0
	if player:
		dist = (player.global_position - global_position).length()

	var use_charge = false
	if _pyre_phase != PyrePhase.BASE and dist > close_range * 0.8 and dist <= mid_range:
		use_charge = true

	if use_charge:
		await _do_overhead_charge(my_seq)
	else:
		await _do_overhead_standing(my_seq)

func _do_overhead_standing(my_seq: int) -> void:
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	if player:
		_face_direction((player.global_position - global_position).normalized())

	var is_unblockable = _pyre_phase == PyrePhase.PHASE_2
	var total_duration = overhead_windup * _get_attack_speed_mult() + parry_linger_window

	_show_parry_indicator(total_duration, is_unblockable)

	if anim and anim.has_animation("overhead_windup"):
		anim.play("overhead_windup")

	var windup_target = overhead_windup * _get_attack_speed_mult() - overhead_parry_preframe
	var windup_elapsed = 0.0
	var track_cutoff = windup_target * overhead_charge_track_base
	while windup_elapsed < windup_target:
		if _should_abort_attack(my_seq):
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		if windup_elapsed < track_cutoff and player and is_instance_valid(player):
			_face_direction((player.global_position - global_position).normalized())
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		windup_elapsed += get_physics_process_delta_time()

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	var slam_radius = overhead_slam_radius
	if _pyre_phase == PyrePhase.PHASE_2:
		slam_radius *= 1.25
	_current_hitbox = _spawn_slam_hitbox(global_position, overhead_slam_damage, is_unblockable, slam_radius)
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("overhead_impact"):
		anim.play("overhead_impact")

	if not await _wait_duration_interruptible(overhead_parry_preframe, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	if _pyre_phase == PyrePhase.PHASE_2:
		_spawn_ember_patch(global_position, slam_radius * 0.8, 2.0)

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(overhead_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _do_overhead_charge(my_seq: int) -> void:
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	var dir = Vector2.RIGHT
	if player:
		dir = (player.global_position - global_position).normalized()
	_face_direction(dir)

	var total_duration = overhead_windup * _get_attack_speed_mult() * 0.6 + overhead_charge_duration + parry_linger_window
	_show_parry_indicator(total_duration, true)

	if anim and anim.has_animation("overhead_windup"):
		anim.play("overhead_windup")

	var short_windup = overhead_windup * _get_attack_speed_mult() * 0.5
	if not await _wait_duration_interruptible(short_windup, my_seq):
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_charge_hitbox(dir, overhead_slam_damage, true)
	_is_current_hitbox_melee = true

	var track_pct = overhead_charge_track_base
	if _pyre_phase == PyrePhase.PHASE_1:
		track_pct = 0.75
	elif _pyre_phase == PyrePhase.PHASE_2:
		track_pct = 0.80

	var charge_elapsed = 0.0
	var charge_speed = overhead_charge_speed * _get_speed_mult()
	while charge_elapsed < overhead_charge_duration:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		if charge_elapsed < overhead_charge_duration * track_pct and player and is_instance_valid(player):
			var new_dir = (player.global_position - global_position).normalized()
			if new_dir != Vector2.ZERO:
				dir = dir.lerp(new_dir, 0.1)
				_face_direction(dir)
		velocity = dir * charge_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		charge_elapsed += get_physics_process_delta_time()

	velocity = Vector2.ZERO

	if anim and anim.has_animation("overhead_impact"):
		anim.play("overhead_impact")

	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return
	_cleanup_hitbox()

	if _pyre_phase == PyrePhase.PHASE_2:
		_spawn_ember_patch(global_position, overhead_slam_radius, 2.0)

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(overhead_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: ASH STOMP
# =============================================================================
func _do_ash_stomp() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var is_parry_only = _pyre_phase == PyrePhase.PHASE_2
	var total_duration = stomp_telegraph * _get_attack_speed_mult() + 0.15 + stomp_recovery
	_show_parry_indicator(total_duration, false)

	if anim and anim.has_animation("stomp_windup"):
		anim.play("stomp_windup")

	if not await _wait_duration_interruptible(stomp_telegraph * _get_attack_speed_mult(), my_seq):
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	var radius = stomp_radius
	if _pyre_phase == PyrePhase.PHASE_2:
		radius *= 1.3
	_current_hitbox = _spawn_stomp_hitbox(global_position, radius, is_parry_only)
	_is_current_hitbox_melee = false

	if anim and anim.has_animation("stomp_impact"):
		anim.play("stomp_impact")

	if not await _wait_duration_interruptible(0.15, my_seq):
		return
	_cleanup_hitbox()

	if _pyre_phase != PyrePhase.BASE:
		var patch_duration = 1.5
		var patch_radius = stomp_radius
		if _pyre_phase == PyrePhase.PHASE_2:
			patch_duration = 2.0
			patch_radius = stomp_radius * 1.3
		_spawn_ember_patch(global_position, patch_radius, patch_duration)

	_set_combat_phase(CombatPhase.RECOVERY)

	# Phase 2: can combo stomp into immediate swing
	if _pyre_phase == PyrePhase.PHASE_2 and _rng.randf() < 0.5:
		await get_tree().create_timer(0.15).timeout
		if not _should_abort_attack(my_seq) and is_instance_valid(self):
			var player = _get_player()
			var dir = Vector2.RIGHT
			if player:
				dir = (player.global_position - global_position).normalized()
			_face_direction(dir)
			await _execute_pilgrim_combo_hit(
				my_seq, swing_telegraph * 0.7, swing_active, swing_recovery * 0.8,
				swing_lunge_distance * 0.5, swing_lunge_speed, swing_damage,
				true, false, true
			)
	else:
		await get_tree().create_timer(stomp_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: PYRE SWEEP (always parry-only)
# =============================================================================
func _do_pyre_sweep() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	var dir = Vector2.RIGHT
	if player:
		dir = (player.global_position - global_position).normalized()
	_face_direction(dir)

	var telegraph = sweep_telegraph * _get_attack_speed_mult()
	var total_duration = telegraph + parry_early_window + sweep_active + parry_linger_window
	_show_parry_indicator(total_duration, false)

	if anim and anim.has_animation("sweep_windup"):
		anim.play("sweep_windup")

	if not await _wait_duration_interruptible(telegraph, my_seq):
		return

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	var width = sweep_width
	if _pyre_phase == PyrePhase.PHASE_2:
		width *= 1.3
	_current_hitbox = _spawn_sweep_hitbox(dir, sweep_range, width, sweep_damage)
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("sweep_swing"):
		anim.play("sweep_swing")

	if not await _wait_duration_interruptible(parry_early_window, my_seq):
		return
	if not await _wait_duration_interruptible(sweep_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	var sweep_pos = global_position
	var sweep_dir = dir
	_cleanup_hitbox()

	if _pyre_phase != PyrePhase.BASE:
		var trail_dur = 1.0 if _pyre_phase == PyrePhase.PHASE_1 else 1.5
		_spawn_ember_patch(sweep_pos + sweep_dir * (sweep_range * 0.4), sweep_range * 0.6, trail_dur)

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(sweep_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: BURNING THRUST
# =============================================================================
func _do_burning_thrust() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	var dir = Vector2.RIGHT
	if player:
		dir = (player.global_position - global_position).normalized()
	_face_direction(dir)

	var is_unblockable = _pyre_phase == PyrePhase.PHASE_2
	var telegraph = thrust_telegraph * _get_attack_speed_mult()
	var total_duration = telegraph + parry_early_window + thrust_active + parry_linger_window

	_show_parry_indicator(total_duration, is_unblockable)

	if anim and anim.has_animation("thrust_windup"):
		anim.play("thrust_windup")

	if not await _wait_duration_interruptible(telegraph, my_seq):
		return

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	if player and is_instance_valid(player):
		var new_dir = (player.global_position - global_position).normalized()
		if new_dir != Vector2.ZERO:
			dir = new_dir
			_face_direction(dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_thrust_hitbox(dir, thrust_range, thrust_damage, is_unblockable)
	_is_current_hitbox_melee = true

	if _current_hitbox and not is_unblockable:
		_current_hitbox.set_meta("burning_thrust_parry_bonus", true)

	if anim and anim.has_animation("thrust_active"):
		anim.play("thrust_active")

	var lunge_elapsed = 0.0
	var lunge_time = thrust_lunge_distance / thrust_lunge_speed if thrust_lunge_speed > 0 else 0.0
	while lunge_elapsed < lunge_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		velocity = dir * thrust_lunge_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		lunge_elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if not await _wait_duration_interruptible(thrust_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	var recovery = thrust_recovery_base if _pyre_phase != PyrePhase.PHASE_2 else thrust_recovery_p2
	recovery *= _get_attack_speed_mult()

	if anim and anim.has_animation("thrust_recovery"):
		anim.play("thrust_recovery")

	await get_tree().create_timer(recovery).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: DARK ORBS (Phase 1+ only)
# =============================================================================
func _do_dark_orbs() -> void:
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

	var is_p2 = _pyre_phase == PyrePhase.PHASE_2
	var telegraph_total = orb_telegraph * _get_attack_speed_mult()
	var total_duration = telegraph_total + orb_recovery

	_show_parry_indicator(total_duration, is_p2)

	if anim and anim.has_animation("orb_windup"):
		anim.play("orb_windup")

	# Track player during telegraph
	var telegraph_elapsed = 0.0
	var track_cutoff = orb_track_cutoff_p1 if _pyre_phase == PyrePhase.PHASE_1 else orb_track_cutoff_p2
	while telegraph_elapsed < telegraph_total:
		if _should_abort_attack(my_seq):
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		if (telegraph_total - telegraph_elapsed) > track_cutoff and player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT
			_face_direction(dir)
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		telegraph_elapsed += get_physics_process_delta_time()

	if _should_abort_attack(my_seq):
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)

	# Final aim toward player
	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

	if anim and anim.has_animation("orb_fire"):
		anim.play("orb_fire")

	var count = orb_count_phase1 if _pyre_phase == PyrePhase.PHASE_1 else orb_count_phase2
	var spread = deg_to_rad(orb_spread_angle_p1 if _pyre_phase == PyrePhase.PHASE_1 else orb_spread_angle_p2)
	var fire_interval = 0.15

	# Staggered fire: one orb at a time, re-aim each
	for i in range(count):
		if _should_abort_attack(my_seq):
			break

		# Re-aim toward player for each orb
		if player and is_instance_valid(player):
			var fresh_dir = (player.global_position - global_position).normalized()
			if fresh_dir != Vector2.ZERO:
				dir = fresh_dir

		# Small spread offset per orb in the volley
		var angle_offset = 0.0
		if count > 1:
			var t = float(i) / float(count - 1)
			angle_offset = lerp(-spread * 0.5, spread * 0.5, t)
		var orb_dir = dir.rotated(angle_offset)

		_spawn_dark_orb(global_position + dir * 16.0, orb_dir, is_p2)

		if i < count - 1:
			if not await _wait_duration_interruptible(fire_interval, my_seq):
				break

	_hide_parry_indicator()

	# Phase 2: dash toward player after volley
	if is_p2 and not _should_abort_attack(my_seq):
		if player and is_instance_valid(player):
			var dash_dir = (player.global_position - global_position).normalized()
			var dash_elapsed = 0.0
			while dash_elapsed < orb_dash_duration:
				if _should_abort_attack(my_seq):
					velocity = Vector2.ZERO
					break
				velocity = dash_dir * orb_dash_speed
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
				dash_elapsed += get_physics_process_delta_time()
			velocity = Vector2.ZERO

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(orb_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _destroy_nearest_orb_to_player() -> void:
	var player = _get_player()
	if not player:
		return
	var best_orb = null
	var best_dist = INF
	for proj in _active_projectiles:
		if not is_instance_valid(proj):
			continue
		if not proj.has_meta("is_projectile"):
			continue
		var d = proj.global_position.distance_to(player.global_position)
		if d < best_dist:
			best_dist = d
			best_orb = proj
	if best_orb:
		_active_projectiles.erase(best_orb)
		best_orb.queue_free()
		
# =============================================================================
# ATTACK: PYRE CHANNEL
# =============================================================================
func _do_pyre_channel() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_is_channeling = true
	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	if anim and anim.has_animation("channel_start"):
		anim.play("channel_start")
	await get_tree().create_timer(0.3).timeout
	if not is_instance_valid(self):
		return
	if _phase == Phase.DEAD or _dbroken_active:
		_is_channeling = false
		_set_combat_phase(CombatPhase.NONE)
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	if anim and anim.has_animation("channel_loop"):
		anim.play("channel_loop")

	var channel_elapsed = 0.0
	while channel_elapsed < channel_duration:
		if _phase == Phase.DEAD:
			_is_channeling = false
			return
		if _dbroken_active:
			_is_channeling = false
			_set_combat_phase(CombatPhase.NONE)
			return

		if sprite:
			var pulse = 0.5 + 0.5 * sin(channel_elapsed * 6.0)
			sprite.modulate = Color(1.0, 0.6 + 0.3 * pulse, 0.2 + 0.2 * pulse)

		velocity = Vector2.ZERO
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		channel_elapsed += get_physics_process_delta_time()

	if _phase == Phase.DEAD or _dbroken_active:
		_is_channeling = false
		return

	# AOE blast telegraph
	var aoe_telegraph = channel_1_aoe_telegraph
	if _pyre_phase == PyrePhase.PHASE_1:
		aoe_telegraph = channel_2_aoe_telegraph

	var telegraph_visual = _spawn_aoe_telegraph(global_position, channel_aoe_radius, aoe_telegraph)

	await get_tree().create_timer(aoe_telegraph).timeout
	if not is_instance_valid(self):
		return

	if is_instance_valid(telegraph_visual):
		telegraph_visual.queue_free()

	if _phase == Phase.DEAD or _dbroken_active:
		_is_channeling = false
		return

	# AOE blast
	var blast = _spawn_slam_hitbox(global_position, channel_aoe_damage, true, channel_aoe_radius)
	if blast:
		blast.set_meta("posture_damage_override", channel_aoe_posture)

	if sprite:
		sprite.modulate = Color(1.0, 1.0, 0.8)

	await get_tree().create_timer(0.15).timeout
	if is_instance_valid(blast):
		blast.queue_free()

	_advance_pyre_phase()
	_is_channeling = false

	if sprite:
		sprite.modulate = Color(1.0, 1.0, 1.0)

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(0.5).timeout

	_set_combat_phase(CombatPhase.NONE)
	_current_attack = AttackType.NONE
	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = _rng.randf_range(min_attack_cooldown, max_attack_cooldown)
	_play_idle()


# =============================================================================
# GENERIC COMBO HIT HELPER
# =============================================================================
func _execute_pilgrim_combo_hit(
	seq_id: int,
	anticipation_time: float,
	active_time: float,
	recovery_time: float,
	lunge_distance: float,
	lunge_speed: float,
	damage: int,
	is_parry_only: bool,
	is_unblockable: bool,
	is_melee_for_afterimage: bool
) -> bool:
	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return false

	_set_combat_phase(CombatPhase.WINDUP)

	var attack_dir = Vector2.RIGHT
	var player = _get_player()
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
		if attack_dir == Vector2.ZERO:
			attack_dir = Vector2.RIGHT
	_face_direction(attack_dir)

	var total_attack_duration = anticipation_time + parry_early_window + active_time + parry_linger_window
	_show_parry_indicator(total_attack_duration, is_unblockable)

	if anim and anim.has_animation("swing_antic"):
		anim.play("swing_antic")

	var lunge_time = lunge_distance / lunge_speed if lunge_speed > 0 else 0.0
	var pre_lunge_wait = max(0.0, anticipation_time - lunge_time)

	if pre_lunge_wait > 0.0:
		if not await _wait_duration_interruptible(pre_lunge_wait, seq_id):
			return false

	if lunge_time > 0.0:
		if not await _lunge_phase(attack_dir, lunge_distance, lunge_speed, lunge_time, seq_id):
			return false

	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return false

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_swing_hitbox(attack_dir, damage, is_parry_only, is_unblockable)
	_is_current_hitbox_melee = is_melee_for_afterimage

	if anim and anim.has_animation("swing_active"):
		anim.play("swing_active")

	if not await _wait_duration_interruptible(parry_early_window, seq_id):
		return false
	if not await _wait_duration_interruptible(active_time, seq_id):
		return false
	if not await _wait_duration_interruptible(parry_linger_window, seq_id):
		return false

	_cleanup_hitbox()
	velocity = Vector2.ZERO

	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(recovery_time, seq_id):
		return false
	if not await _wait_for_combo_parry_recovery(seq_id):
		return false

	return true


# =============================================================================
# HITBOX SPAWNING
# =============================================================================
func _spawn_swing_hitbox(dir: Vector2, damage: int, parry_only: bool, unblockable: bool) -> Area2D:
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
	elif parry_only:
		hitbox.set_meta("damage_type", "perilous")
		hitbox.set_meta("parryable", true)
		hitbox.set_meta("unblockable", false)
	else:
		hitbox.set_meta("damage_type", "pilgrim_swing")
		hitbox.set_meta("parryable", true)
		hitbox.set_meta("unblockable", false)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(swing_range, swing_width)
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (swing_range * 0.5)
	hitbox.rotation = dir.angle()
	return hitbox

func _spawn_slam_hitbox(center: Vector2, damage: int, unblockable: bool, radius: float = -1.0) -> Area2D:
	var area = Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("telegraphed", true)

	if unblockable:
		area.set_meta("damage_type", "unblockable")
		area.set_meta("parryable", false)
		area.set_meta("unblockable", true)
	else:
		area.set_meta("damage_type", "pilgrim_slam")
		area.set_meta("parryable", true)
		area.set_meta("unblockable", false)

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius if radius > 0.0 else overhead_slam_radius
	cs.shape = shape
	area.add_child(cs)
	area.global_position = center
	get_parent().add_child(area)
	return area

func _spawn_charge_hitbox(dir: Vector2, damage: int, unblockable: bool) -> Area2D:
	var area = Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("telegraphed", true)

	if unblockable:
		area.set_meta("damage_type", "unblockable")
		area.set_meta("parryable", false)
		area.set_meta("unblockable", true)
	else:
		area.set_meta("damage_type", "pilgrim_charge")
		area.set_meta("parryable", true)
		area.set_meta("unblockable", false)

	var cs = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(48, 36)
	cs.shape = rect
	area.add_child(cs)
	area.position = dir.normalized() * 26.0
	area.rotation = dir.angle()
	add_child(area)
	return area

func _spawn_stomp_hitbox(center: Vector2, radius: float, parry_only: bool) -> Area2D:
	var area = Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", stomp_damage)
	area.set_meta("attacker", self)
	area.set_meta("telegraphed", true)
	area.set_meta("posture_damage_override", stomp_posture_damage)

	if parry_only:
		area.set_meta("damage_type", "perilous")
	else:
		area.set_meta("damage_type", "pilgrim_stomp")
	area.set_meta("parryable", true)
	area.set_meta("unblockable", false)

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	cs.shape = shape
	area.add_child(cs)
	area.global_position = center
	get_parent().add_child(area)
	return area

func _spawn_sweep_hitbox(dir: Vector2, range_dist: float, width: float, damage: int) -> Area2D:
	var hitbox = Area2D.new()
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "perilous")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", true)
	hitbox.set_meta("unblockable", false)
	hitbox.set_meta("telegraphed", true)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(range_dist, width)
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (range_dist * 0.4)
	hitbox.rotation = dir.angle()
	return hitbox

func _spawn_thrust_hitbox(dir: Vector2, range_dist: float, damage: int, unblockable: bool) -> Area2D:
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
		hitbox.set_meta("damage_type", "perilous")
		hitbox.set_meta("parryable", true)
		hitbox.set_meta("unblockable", false)

	# Burn DoT on hit (Phase 1+)
	if _pyre_phase == PyrePhase.PHASE_1:
		hitbox.set_meta("burn_duration", thrust_burn_duration_p1)
		hitbox.set_meta("burn_dps", thrust_burn_dps)
	elif _pyre_phase == PyrePhase.PHASE_2:
		hitbox.set_meta("burn_duration", thrust_burn_duration_p2)
		hitbox.set_meta("burn_dps", thrust_burn_dps)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(range_dist, 18.0)
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (range_dist * 0.5)
	hitbox.rotation = dir.angle()
	return hitbox
	
# =============================================================================
# AFTERIMAGE SYSTEM (Phase 2 only)
# =============================================================================
func _spawn_afterimage_from_hitbox(hitbox: Area2D) -> void:
	if not is_instance_valid(hitbox):
		return

	var ghost = Area2D.new()
	ghost.add_to_group("attack")
	ghost.collision_layer = 2
	ghost.collision_mask = 4
	ghost.set_meta("damage", 0)
	ghost.set_meta("damage_type", "unblockable")
	ghost.set_meta("attacker", self)
	ghost.set_meta("parryable", false)
	ghost.set_meta("unblockable", true)
	ghost.set_meta("telegraphed", false)
	ghost.set_meta("posture_damage_override", afterimage_posture_damage)

	# Copy shape from original hitbox
	for child in hitbox.get_children():
		if child is CollisionShape2D and child.shape:
			var col = CollisionShape2D.new()
			col.shape = child.shape.duplicate()
			ghost.add_child(col)
			break

	# Position in world space
	ghost.global_position = hitbox.global_position
	ghost.global_rotation = hitbox.global_rotation
	get_parent().add_child(ghost)

	# Faded visual
	var visual = ColorRect.new()
	visual.size = Vector2(20, 20)
	visual.position = Vector2(-10, -10)
	visual.color = Color(1.0, 0.5, 0.2, afterimage_alpha)
	ghost.add_child(visual)

	# Self-destruct
	get_tree().create_timer(afterimage_duration).timeout.connect(func():
		if is_instance_valid(ghost):
			ghost.queue_free()
	)


# =============================================================================
# EMBER PATCHES (lingering damage areas)
# =============================================================================
func _spawn_ember_patch(pos: Vector2, radius: float, duration: float) -> void:
	var patch = Area2D.new()
	patch.collision_layer = 2
	patch.collision_mask = 4
	patch.global_position = pos

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	cs.shape = shape
	patch.add_child(cs)

	# Visual
	var visual = Polygon2D.new()
	var pts = PackedVector2Array()
	var seg = 16
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * radius)
	visual.polygon = pts
	visual.color = Color(1.0, 0.4, 0.1, 0.25)
	visual.z_index = -1
	patch.add_child(visual)

	get_parent().add_child(patch)

	# Damage tick via metadata
	patch.set_meta("ember_dps", ember_tick_damage)
	patch.set_meta("ember_posture_ps", ember_posture_per_sec)
	patch.set_meta("ember_owner", self)
	patch.set_meta("ember_hit_cooldown", {})

	patch.body_entered.connect(func(body: Node) -> void:
		if not body.is_in_group("player"):
			return
		patch.set_meta("_player_inside", true)
	)
	patch.body_exited.connect(func(body: Node) -> void:
		if not body.is_in_group("player"):
			return
		patch.set_meta("_player_inside", false)
	)

	# Tick damage while player stands in it
	var tick_interval = 0.3
	var ticks = int(duration / tick_interval)
	for i in range(ticks):
		get_tree().create_timer(tick_interval * (i + 1)).timeout.connect(func():
			if not is_instance_valid(patch):
				return
			if not patch.get_meta("_player_inside", false):
				return
			var p = get_tree().get_first_node_in_group("player")
			if not p or not is_instance_valid(p):
				return
			# Apply tick damage
			if "hp" in p:
				p.hp -= int(ember_tick_damage)
				if p.has_method("_update_health_bar"):
					p._update_health_bar()
			# Apply posture damage to player combat controller
			var pc = p.get_node_or_null("Combat")
			if pc and pc.has_method("add_posture"):
				pc.add_posture(ember_posture_per_sec * tick_interval)
		)

	# Fade out and cleanup
	get_tree().create_timer(duration).timeout.connect(func():
		if is_instance_valid(patch):
			var tw = get_tree().create_tween()
			tw.tween_property(visual, "color:a", 0.0, 0.3)
			tw.tween_callback(func():
				if is_instance_valid(patch):
					patch.queue_free()
			)
	)

func _spawn_aoe_telegraph(pos: Vector2, radius: float, duration: float) -> Node2D:
	var marker = Node2D.new()
	marker.global_position = pos
	marker.z_index = z_index - 1

	var poly = Polygon2D.new()
	var pts = PackedVector2Array()
	var segments = 20
	for i in range(segments):
		var angle = TAU * float(i) / float(segments)
		pts.append(Vector2(cos(angle), sin(angle)) * radius)
	poly.polygon = pts
	poly.color = Color(1.0, 0.5, 0.1, 0.0)
	marker.add_child(poly)
	get_parent().add_child(marker)

	# Fade in telegraph
	var tw = get_tree().create_tween()
	tw.tween_property(poly, "color:a", 0.4, duration * 0.8)

	return marker

func _spawn_dark_orb(origin: Vector2, dir: Vector2, unblockable: bool = false) -> void:
	var orb = Area2D.new()
	orb.add_to_group("attack")
	orb.collision_layer = 2
	orb.collision_mask = 0  # Orb doesn't detect anything; player's HurtBox detects it
	orb.set_meta("damage", orb_damage)
	orb.set_meta("attacker", self)
	orb.set_meta("telegraphed", true)
	orb.set_meta("is_projectile", true)
	orb.set_meta("swing_token", Time.get_ticks_msec())

	if unblockable:
		orb.set_meta("damage_type", "unblockable")
		orb.set_meta("parryable", false)
		orb.set_meta("unblockable", true)
	else:
		orb.set_meta("damage_type", "pilgrim_orb")
		orb.set_meta("parryable", true)
		orb.set_meta("unblockable", false)

	# Homing metadata
	orb.set_meta("direction", dir)
	orb.set_meta("speed", orb_speed)
	orb.set_meta("homing", true)
	orb.set_meta("homing_strength", 1.8)
	orb.set_meta("homing_delay", 0.25)
	orb.set_meta("spawn_time", Time.get_ticks_msec() * 0.001)

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 8.0
	cs.shape = shape
	orb.add_child(cs)
	orb.global_position = origin

	var visual = ColorRect.new()
	visual.size = Vector2(12, 12)
	visual.position = Vector2(-6, -6)
	visual.color = Color(0.3, 0.1, 0.5, 0.9)
	orb.add_child(visual)

	get_tree().current_scene.add_child(orb)
	_active_projectiles.append(orb)

	# Lifetime — longer than before since homing orbs curve
	get_tree().create_timer(3.5).timeout.connect(func():
		if is_instance_valid(orb):
			orb.queue_free()
	)

func _tick_projectiles(delta: float) -> void:
	var player = _get_player()
	var i = _active_projectiles.size() - 1
	while i >= 0:
		var proj = _active_projectiles[i]
		if not is_instance_valid(proj):
			_active_projectiles.remove_at(i)
		else:
			var dir = proj.get_meta("direction", Vector2.ZERO)
			var spd = proj.get_meta("speed", 0.0)

			# Homing: gently steer toward player after initial delay
			if proj.has_meta("homing") and proj.get_meta("homing"):
				if player and is_instance_valid(player):
					var spawn_time = float(proj.get_meta("spawn_time", 0.0))
					var homing_delay = float(proj.get_meta("homing_delay", 0.3))
					var now = Time.get_ticks_msec() * 0.001
					if now - spawn_time > homing_delay:
						var to_player = (player.global_position - proj.global_position).normalized()
						var turn_rate = float(proj.get_meta("homing_strength", 2.0))
						dir = dir.lerp(to_player, turn_rate * delta).normalized()
						proj.set_meta("direction", dir)

			proj.global_position += dir * spd * delta
		i -= 1

# =============================================================================
# HITBOX CLEANUP (with afterimage support)
# =============================================================================
func _cleanup_hitbox() -> void:
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
		# Phase 2: spawn afterimage before destroying melee hitboxes
		if _pyre_phase == PyrePhase.PHASE_2 and _is_current_hitbox_melee:
			_spawn_afterimage_from_hitbox(_current_hitbox)
		
		_current_hitbox.queue_free()
	
	_current_hitbox = null
	_is_current_hitbox_melee = false

# =============================================================================
# COROUTINE HELPERS
# =============================================================================
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

func _wait_duration_interruptible(duration: float, seq_id: int) -> bool:
	var elapsed = 0.0
	while elapsed < duration:
		if _should_abort_attack(seq_id):
			return false
		if _combo_is_frozen:
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return false
			continue
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false
		elapsed += get_physics_process_delta_time()
	return true

func _lunge_phase(dir: Vector2, distance: float, speed: float, duration: float, seq_id: int) -> bool:
	if dir == Vector2.ZERO or speed <= 0:
		return not _should_abort_attack(seq_id)

	var current_dist = _get_current_distance_to_player()
	var adjusted_distance = distance

	if current_dist >= 0:
		if current_dist < lunge_min_distance:
			return not _should_abort_attack(seq_id)
		var distance_ratio = clampf(
			(current_dist - lunge_min_distance) / (ideal_combat_distance - lunge_min_distance),
			0.0, 1.0
		)
		adjusted_distance = distance * distance_ratio

	if adjusted_distance < 5.0:
		return not _should_abort_attack(seq_id)

	var start_pos = global_position
	var elapsed = 0.0
	var adjusted_duration = (adjusted_distance / speed) if speed > 0 else duration

	while elapsed < adjusted_duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return false
		if _combo_is_frozen:
			velocity = Vector2.ZERO
			while _combo_is_frozen:
				if _should_abort_attack(seq_id):
					return false
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return false
			continue
		var traveled = global_position.distance_to(start_pos)
		if traveled >= adjusted_distance:
			velocity = Vector2.ZERO
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

func _wait_for_combo_parry_recovery(seq_id: int) -> bool:
	while _combo_is_frozen:
		if _should_abort_attack(seq_id):
			return false
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false

	while _is_in_parry_stagger():
		if _should_abort_attack(seq_id):
			return false
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return false

	if _combo_parry_resume_delay > 0.0:
		var delay_elapsed = 0.0
		while delay_elapsed < _combo_parry_resume_delay:
			if _should_abort_attack(seq_id):
				return false
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return false
			delay_elapsed += get_physics_process_delta_time()

	return true


# =============================================================================
# COMBAT PHASE HELPERS
# =============================================================================
func _set_combat_phase(phase: CombatPhase) -> void:
	_combat_phase = phase

func _is_in_windup() -> bool:
	return _combat_phase == CombatPhase.WINDUP

func _is_in_parry_stagger() -> bool:
	return Time.get_ticks_msec() * 0.001 < _parry_stagger_until

func _is_in_parry_recoil() -> bool:
	var now = Time.get_ticks_msec() * 0.001
	return _parry_recoil_until > 0.0 and now < _parry_recoil_until


# =============================================================================
# DAMAGE HANDLING — with channel damage reduction and windup armor
# =============================================================================
func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _phase == Phase.DEAD:
		return
	if damage <= 0:
		return
	if attacker == null:
		return

	var is_player_attack := false

	if attacker.is_in_group("player"):
		is_player_attack = true

	if not is_player_attack and attacker is Area2D:
		if attacker.has_meta("attacker"):
			var meta_attacker = attacker.get_meta("attacker")
			if meta_attacker is Node and meta_attacker.is_in_group("player"):
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

	# Track player aggression for Ash Stomp
	_player_recent_hits += 1.0

	var guarding = _is_guarding()

	# --- GUARDING: posture damage only, no HP damage (Sekiro-style) ---
	if guarding:
		if combat:
			combat.notify_got_hit({"damage": 0, "blocked": true})

		# Prosthetic effects (reduced when blocked)
		if attacker is Area2D and attacker.has_meta("prosthetic_source"):
			ProstheticEffects.apply(attacker, self, true)

		# Stance effects
		var se = get_node_or_null("/root/StanceEffects")
		if se and se.has_method("on_enemy_hit"):
			se.on_enemy_hit(attacker, self, true)

		_flash_block()
		return

	# --- NOT GUARDING: HP damage is the main reward, posture is secondary ---
	var final_damage = damage
	var posture_mult = unguarded_posture_mult  # Base: reduced posture on raw hits

	# Channel damage reduction
	if _is_channeling:
		final_damage = int(round(float(damage) * channel_damage_mult))
		posture_mult *= channel_damage_mult

	# Windup armor
	if _is_in_windup() and not _is_channeling:
		final_damage = int(round(float(final_damage) * windup_damage_mult))
		posture_mult *= windup_posture_mult
		_flash_windup_hit()

	# Posture via CombatController (raw hit — not blocked, but reduced)
	if combat:
		var posture_event = {"damage": final_damage, "blocked": false}
		var orig_gain = combat.config.hit_posture_gain if combat.config else 12.0
		if combat.config:
			combat.config.hit_posture_gain = orig_gain * posture_mult
		combat.notify_got_hit(posture_event)
		if combat.config:
			combat.config.hit_posture_gain = orig_gain

	# Prosthetic effects (full when not blocked)
	if attacker is Area2D and attacker.has_meta("prosthetic_source"):
		ProstheticEffects.apply(attacker, self, false)

	# Stance effects
	var se = get_node_or_null("/root/StanceEffects")
	if se and se.has_method("on_enemy_hit"):
		se.on_enemy_hit(attacker, self, false)

	_apply_damage(final_damage, damage_type, attacker)
	
# =============================================================================
# PARRY HANDLING
# =============================================================================
func on_parried(parry_source_pos: Vector2) -> void:
	if _dbroken_active or _phase == Phase.DEAD:
		return

	# --- PROJECTILE PARRY: no active melee hitbox = parried a flying orb ---
	if not is_instance_valid(_current_hitbox):
		_destroy_nearest_orb_to_player()
		# Small posture reward (not the full melee-parry spike)
		if combat:
			combat.add_posture(parry_posture_damage * 0.25)
			combat.suppress_recovery(0.5)
		pause_pyre_charge()
		return

	_hide_parry_indicator()

	var local_attack = _current_attack

	if combat and combat.config:
		var current = combat.get_posture()
		var maxv = combat.config.posture_max
		var bonus = parry_posture_damage

		if local_attack == AttackType.BURNING_THRUST and _pyre_phase != PyrePhase.PHASE_2:
			bonus *= thrust_parry_stagger_mult

		var new_posture = min(current + bonus, maxv)
		combat.set_posture(new_posture)
		combat.notify_got_hit({"damage": 0, "parried": true})
		combat.suppress_recovery(1.0)

	pause_pyre_charge()

	_cleanup_hitbox()
	hitstop_local(0.06)

	if local_attack == AttackType.NORMAL_SWINGS:
		_start_parry_recoil_combo(parry_source_pos)

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

	_start_parry_recoil_single(local_attack, parry_source_pos)

	if anim:
		if anim.has_animation("parried"):
			anim.play("parried")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		elif anim.has_animation("hurt"):
			anim.play("hurt")
	_parry_flash_tint()

	var stagger_time = 0.22
	if local_attack == AttackType.BURNING_THRUST:
		stagger_time = 0.22 * thrust_parry_stagger_mult
	elif local_attack == AttackType.OVERHEAD_SLAM:
		stagger_time = 0.28

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
	_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.2, max_attack_cooldown * 1.5)
	_combo_interrupted = false
	_play_idle()

func _start_parry_recoil_combo(parry_source_pos: Vector2) -> void:
	velocity = Vector2.ZERO
	_combo_is_frozen = true
	var now = Time.get_ticks_msec() * 0.001
	_combo_parry_freeze_until = now + _combo_parry_hitstop
	_do_parry_hitstop()

func _start_parry_recoil_single(local_attack: AttackType, parry_source_pos: Vector2) -> void:
	var player = _get_player()
	var source_pos = parry_source_pos
	if player:
		source_pos = player.global_position

	var away = (global_position - source_pos).normalized()
	if away == Vector2.ZERO:
		away = Vector2.RIGHT

	var recoil_time = 0.18
	var recoil_speed = 100.0
	var max_recoil = 35.0

	match local_attack:
		AttackType.OVERHEAD_SLAM:
			recoil_time = 0.20
			recoil_speed = 120.0
			max_recoil = 40.0
		AttackType.BURNING_THRUST:
			recoil_time = 0.22
			recoil_speed = 130.0
			max_recoil = 45.0

	var potential = recoil_speed * recoil_time
	if potential > max_recoil:
		recoil_speed = max_recoil / recoil_time

	_parry_recoil_velocity = away * recoil_speed
	var now = Time.get_ticks_msec() * 0.001
	_parry_recoil_until = now + recoil_time
	_parry_stagger_until = now + recoil_time

func _do_parry_hitstop() -> void:
	if anim:
		anim.pause()

	if sprite:
		var original_mod = sprite.modulate
		sprite.modulate = Color(1.0, 1.0, 1.6)
		await get_tree().create_timer(_combo_parry_hitstop).timeout
		if is_instance_valid(sprite):
			sprite.modulate = original_mod
	else:
		await get_tree().create_timer(_combo_parry_hitstop).timeout

	_combo_is_frozen = false

func _parry_flash_tint() -> void:
	if not sprite:
		return
	var original_mod = sprite.modulate
	sprite.modulate = Color(1.0, 1.0, 1.5)
	await get_tree().create_timer(0.10).timeout
	if is_instance_valid(sprite):
		sprite.modulate = original_mod


# =============================================================================
# POSTURE / DEATHBLOW PIPELINE
# =============================================================================
func _on_posture_changed(current: float, max_value: float) -> void:
	_update_posture_bar(current, max_value)

func _trigger_posture_break(duration: float) -> void:
	var player = _get_player()
	if player:
		var pc = player.get_node_or_null("Combat")
		if pc and pc.has_method("set_deathblow_target"):
			pc.set_deathblow_target(self, duration)
		elif pc and pc.has_signal("deathblow_available"):
			pc.emit_signal("deathblow_available", self, duration)

func _on_posture_broken(duration: float) -> void:
	if _dbroken_active or _phase == Phase.DEAD:
		return

	_hide_parry_indicator()

	var window = duration
	if window <= 0.0:
		window = deathblow_window_duration

	_attack_sequence_id += 1
	_is_channeling = false
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
		elif anim.has_animation("parried"):
			anim.play("parried")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		elif anim.has_animation("hurt"):
			anim.play("hurt")
		else:
			anim.play("idle")

	_start_posture_break_flash()
	emit_signal("posture_broken", window)

func _clear_deathblow_state() -> void:
	_dbroken_active = false
	_dbreak_until = -1.0
	_dbreak_immunity_until = -1.0
	_stop_posture_break_flash()

func _end_deathblow_window() -> void:
	if not _dbroken_active:
		return
	_clear_deathblow_state()
	_deathblow_in_progress = false

	if combat and combat.config:
		var maxv = combat.config.posture_max
		combat.set_posture(maxv * 0.35)
	elif combat:
		combat.set_posture(0.0)

	if _phase != Phase.DEAD:
		_behavior_state = BehaviorState.IDLE
		_attack_cooldown = _rng.randf_range(min_attack_cooldown * 1.1, max_attack_cooldown * 1.4)
		_play_idle()
	emit_signal("posture_recovered")

func take_deathblow(attacker: Node) -> void:
	if _phase == Phase.DEAD:
		return
	if not _dbroken_active:
		return
	if _deathblow_in_progress:
		return
	_deathblow_in_progress = true

	if combat and combat.config:
		combat.set_posture(0.0)

	var final_damage = deathblow_damage
	var instant_kill = deathblow_instant_kill

	if deathblow_pips > 1:
		if _current_pip < deathblow_pips:
			_current_pip += 1
			_clear_deathblow_state()
			_deathblow_in_progress = false
			var now = Time.get_ticks_msec() * 0.001
			_stun_until = now + 0.65
			_behavior_state = BehaviorState.IDLE
			_current_attack = AttackType.NONE
			_combat_phase = CombatPhase.NONE
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			if anim and anim.has_animation("deathblow"):
				anim.play("deathblow")
			emit_signal("posture_recovered")
			return

	var damage_to_deal = 0
	if instant_kill:
		damage_to_deal = max(hp, 1)
	else:
		damage_to_deal = final_damage

	_apply_damage(damage_to_deal, "deathblow", attacker)

	if hp <= 0:
		_clear_deathblow_state()
		_deathblow_in_progress = false
		emit_signal("posture_recovered")
		return

	_clear_deathblow_state()
	emit_signal("posture_recovered")

	var now2 = Time.get_ticks_msec() * 0.001
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

	var original_mod = sprite.modulate if sprite else Color.WHITE
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

func receive_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)
	
func is_deathblow_ready() -> bool:
	return _dbroken_active


# =============================================================================
# DAMAGE / DEATH
# =============================================================================
func _apply_damage(damage: int, _damage_type: String, _attacker: Node) -> void:
	if _phase == Phase.DEAD:
		return
	hp = max(hp - damage, 0)
	if hp <= 0:
		_die()
	else:
		hitstop_local(0.005)
		_flash_hurt_sprite()

func hitstop_local(duration: float) -> void:
	if anim:
		var was_playing = anim.current_animation
		anim.pause()
		await get_tree().create_timer(duration).timeout
		if is_instance_valid(anim) and was_playing != "" and _phase != Phase.DEAD:
			anim.play(was_playing)

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
	_is_channeling = false
	velocity = Vector2.ZERO
	_attack_sequence_id += 1
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if _bars_container:
		_bars_container.visible = false
	
	_cleanup_hitbox()
	_release_all_attack_director_state()
	
	for proj in _active_projectiles:
		if is_instance_valid(proj):
			proj.queue_free()
	_active_projectiles.clear()
	
	if is_in_group("miniboss"):
		remove_from_group("miniboss")
	
	if is_in_group("embered_pilgrim"):
		remove_from_group("embered_pilgrim")
	
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
		var start_time = Time.get_ticks_msec() * 0.001
		var max_wait = 4.0
		
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
# UI BARS — HP + Posture + Pyre Charge
# =============================================================================
func _setup_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsUI"
	_bars_container.z_index = 100
	add_child(_bars_container)

	# Posture bar
	_pilgrim_posture_bg = ColorRect.new()
	_pilgrim_posture_bg.size = Vector2(54, 6)
	_pilgrim_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	_pilgrim_posture_bg.position = Vector2(-27, -55)
	_bars_container.add_child(_pilgrim_posture_bg)

	_pilgrim_posture_fill = ColorRect.new()
	_pilgrim_posture_fill.size = Vector2(0, 6)
	_pilgrim_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	_pilgrim_posture_fill.position = Vector2.ZERO
	_pilgrim_posture_bg.add_child(_pilgrim_posture_fill)

	var posture_border = ColorRect.new()
	posture_border.size = Vector2(56, 8)
	posture_border.color = Color(0.3, 0.25, 0.1, 0.9)
	posture_border.position = Vector2(-28, -56)
	posture_border.z_index = -1
	_bars_container.add_child(posture_border)

	# HP bar
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

	# Pyre charge bar (below HP)
	_pyre_bg = ColorRect.new()
	_pyre_bg.size = Vector2(54, 4)
	_pyre_bg.color = Color(0.08, 0.04, 0.02, 0.7)
	_pyre_bg.position = Vector2(-27, -38)
	_bars_container.add_child(_pyre_bg)
	_pyre_fill = ColorRect.new()
	_pyre_fill.size = Vector2(0, 4)
	_pyre_fill.color = Color(1.0, 0.5, 0.15, 0.9)
	_pyre_fill.position = Vector2.ZERO
	_pyre_bg.add_child(_pyre_fill)

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

	# Pyre charge bar
	if _pyre_fill and _pyre_phase != PyrePhase.PHASE_2:
		var max_threshold = channel_1_threshold if _pyre_phase == PyrePhase.BASE else channel_2_threshold
		var min_threshold = 0.0 if _pyre_phase == PyrePhase.BASE else channel_1_threshold
		var pct = clamp((_pyre_charge - min_threshold) / max(0.01, max_threshold - min_threshold), 0.0, 1.0)
		_pyre_fill.size.x = 54.0 * pct
		# Pulse brighter as charge approaches threshold
		if pct > 0.8:
			var pulse = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.01)
			_pyre_fill.color = Color(1.0, 0.4 * pulse, 0.1, 0.95)
		else:
			_pyre_fill.color = Color(1.0, 0.5, 0.15, 0.9)
	elif _pyre_fill and _pyre_phase == PyrePhase.PHASE_2:
		_pyre_fill.size.x = 54.0
		var pulse = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.006)
		_pyre_fill.color = Color(1.0, 0.3 * pulse, 0.1, 0.95)

func _update_posture_bar(cur: float, maxv: float) -> void:
	if not _pilgrim_posture_fill or not _pilgrim_posture_bg:
		return
	
	var pct = clamp(cur / max(0.001, maxv), 0.0, 1.0)
	_pilgrim_posture_fill.size.x = 54.0 * pct
	
	var hp_ratio = clamp(float(hp) / float(get_max_hp()), 0.0, 1.0)
	
	if hp_ratio >= 0.75:
		_pilgrim_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	elif hp_ratio >= 0.50:
		_pilgrim_posture_fill.color = Color(1.0, 0.6, 0.1, 0.95)
	elif hp_ratio >= 0.25:
		_pilgrim_posture_fill.color = Color(1.0, 0.4, 0.1, 0.95)
	else:
		var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.01)
		_pilgrim_posture_fill.color = Color(1.0, 0.25 * flash, 0.1, 0.95)
	
	if pct >= 0.85:
		var break_flash = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.015)
		_pilgrim_posture_fill.color.a = break_flash

# =============================================================================
# SPACING & MOVEMENT HELPERS
# =============================================================================
func _apply_soft_separation() -> void:
	if _phase == Phase.DEAD or _dbroken_active:
		return
	if _combat_phase == CombatPhase.ACTIVE:
		return
	if _parry_recoil_until > 0.0:
		return

	var player = _get_player()
	if not player:
		return
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	if dist < min_separation and dist > 0.1:
		var push_strength = (min_separation - dist) * 4.0
		var push_dir = -to_player.normalized()
		velocity += push_dir * push_strength

func _is_face_hugging() -> bool:
	var player = _get_player()
	if not player:
		return false
	return (player.global_position - global_position).length() < too_close_threshold

func _get_current_distance_to_player() -> float:
	var player = _get_player()
	if not player:
		return -1.0
	return (player.global_position - global_position).length()

func _do_spacing_slide() -> void:
	if _phase == Phase.DEAD or _dbroken_active:
		return
	var player = _get_player()
	if not player:
		return
	var current_dist = (player.global_position - global_position).length()
	if current_dist >= ideal_combat_distance * 0.85:
		return
	var retreat_dir = (global_position - player.global_position).normalized()
	if retreat_dir == Vector2.ZERO:
		retreat_dir = Vector2.LEFT if sprite and not sprite.flip_h else Vector2.RIGHT
	var retreat_dist = min(ideal_combat_distance - current_dist, spacing_slide_distance)
	var retreat_time = retreat_dist / spacing_slide_speed
	var elapsed = 0.0
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

func get_enemy_damage() -> int:
	return swing_damage

func get_enemy_tags() -> Array:
	return ["zealot"]

func _update_sprite_facing() -> void:
	var player = _get_player()
	if player and sprite:
		sprite.flip_h = player.global_position.x > global_position.x

func _is_guarding() -> bool:
	## Sekiro-style: Pilgrim guards by default. Only vulnerable during actions.
	if _phase == Phase.DEAD:
		return false
	if _dbroken_active:
		return false
	if _is_channeling:
		return false
	if _combat_phase != CombatPhase.NONE:
		return false  # WINDUP, ACTIVE, RECOVERY = vulnerable
	var now = Time.get_ticks_msec() * 0.001
	if _parry_recoil_until > 0.0 and now < _parry_recoil_until:
		return false
	if _stun_until > 0.0 and now < _stun_until:
		return false
	return true
	
func _flash_block() -> void:
	if not sprite:
		return
	var orig = sprite.modulate
	sprite.modulate = Color(0.7, 0.85, 1.0)
	await get_tree().create_timer(0.06).timeout
	if is_instance_valid(sprite):
		sprite.modulate = orig
