extends HumanoidEnemyBase
class_name EclipseShogun

# =============================================================================
# CORE STATS
# =============================================================================
@export var bar_hp = 250
@export var base_movement_speed = 50.0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage = 22.0
@export var block_posture_damage = 7.0
@export var deathblow_window_duration = 3.5
@export var deathblow_immunity_time = 0.3
@export var deathblow_damage = 120

# =============================================================================
# WINDUP ARMOR
# =============================================================================
@export_group("Windup Armor")
@export var windup_damage_mult = 0.5
@export var windup_posture_mult = 0.4
@export var windup_knockback_mult = 0.3
@export var windup_hit_flash_color = Color(0.8, 0.3, 0.2, 1.0)

# =============================================================================
# PARRY TIMING
# =============================================================================
@export_group("Parry Timing")
@export var parry_early_window = 0.12
@export var parry_linger_window = 0.20
@export var hitbox_min_lifetime = 0.15

# =============================================================================
# PHASE SCALING
# =============================================================================
@export_group("Phase Scaling")
@export var phase_2_speed_mult = 1.15
@export var phase_2_attack_speed = 0.88
@export var phase_3_speed_mult = 1.25
@export var phase_3_attack_speed = 0.78

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
@export var too_close_threshold = 30.0
@export var lunge_min_distance = 20.0
@export var min_separation = 18.0
@export var post_combo_spacing_chance = 0.20
@export var spacing_slide_distance = 40.0
@export var spacing_slide_speed = 90.0

# =============================================================================
# APPROACH
# =============================================================================
@export_group("Approach")
@export var approach_speed = 130.0
@export var approach_acceleration = 40.0
@export var approach_max_speed = 170.0
@export var approach_commitment_time = 3.0

# =============================================================================
# FUNERAL MEASURE (Phase 1 — 3-hit scythe combo, delayed 3rd)
# =============================================================================
@export_group("Funeral Measure")
@export var fm_damage = 12
@export var fm_range = 70.0
@export var fm_width = 55.0
@export var fm_telegraph = 0.36
@export var fm_active = 0.14
@export var fm_recovery = 0.35
@export var fm_lunge_distance = 32.0
@export var fm_lunge_speed = 380.0
@export var fm_inter_hit_gap = 0.10
@export var fm_initial_windup = 0.28
## Third hit has a longer, delayed wind-up — teaches the rhythm
@export var fm_heavy_telegraph_mult = 1.6

# =============================================================================
# BLADE DANCE (Phase 1 — spinning projectile throw + catch)
# =============================================================================
@export_group("Blade Dance")
@export var bd_projectile_speed = 220.0
@export var bd_projectile_range = 140.0
@export var bd_projectile_damage = 8
@export var bd_projectile_radius = 22.0
@export var bd_recovery = 1.0
@export var bd_telegraph = 0.50

# =============================================================================
# DEATHLY DASH (Phase 1 — charge + dash + delayed trail detonation)
# =============================================================================
@export_group("Deathly Dash")
@export var dd_telegraph = 0.55
@export var dd_dash_speed = 500.0
@export var dd_dash_distance = 160.0
@export var dd_trail_delay = 0.6
@export var dd_trail_damage = 10
@export var dd_trail_width = 30.0
@export var dd_recovery = 0.65

# =============================================================================
# SCYTHE RIFT (Phase 1 — forward slash + ground hazard)
# =============================================================================
@export_group("Scythe Rift")
@export var sr_slash_damage = 10
@export var sr_telegraph = 0.42
@export var sr_rift_delay = 0.8
@export var sr_rift_damage = 8
@export var sr_rift_radius = 35.0
@export var sr_rift_lifetime = 2.0
@export var sr_recovery = 0.40

# =============================================================================
# PREDATOR'S FEINT (Phase 2 — fake dash → pounce)
# =============================================================================
@export_group("Predator's Feint")
@export var pf_fake_dash_distance = 60.0
@export var pf_fake_telegraph = 0.35
@export var pf_pounce_telegraph = 0.22
@export var pf_pounce_distance = 100.0
@export var pf_pounce_speed = 550.0
@export var pf_damage = 14
@export var pf_recovery = 0.50

# =============================================================================
# RAVENOUS REND (Phase 2 — savage close-range combo + punishable finisher)
# =============================================================================
@export_group("Ravenous Rend")
@export var rr_damage = 10
@export var rr_hits = 3
@export var rr_telegraph = 0.28
@export var rr_finisher_telegraph = 0.50
@export var rr_finisher_damage = 16
@export var rr_recovery = 0.70
@export var rr_inter_hit_gap = 0.08

# =============================================================================
# BLOOD HALO (Phase 2 — brief rotating ring hazard)
# =============================================================================
@export_group("Blood Halo")
@export var bh_duration = 3.5
@export var bh_radius = 60.0
@export var bh_damage = 6
@export var bh_tick_interval = 0.5

# =============================================================================
# TIMELESS ZONE (Phase 2 — darkness + safe zone + boss attacks)
# =============================================================================
@export_group("Timeless Zone")
@export var tz_duration = 5.0
@export var tz_safe_radius = 90.0
@export var tz_darkness_dps = 8.0
@export var tz_attack_count = 2

# =============================================================================
# ECLIPSE MEASURE (Phase 3 — evolved Funeral Measure + beast lunge)
# =============================================================================
@export_group("Eclipse Measure")
@export var em_damage = 14
@export var em_beast_lunge_damage = 16
@export var em_beast_lunge_distance = 80.0
@export var em_beast_lunge_speed = 480.0
@export var em_beast_telegraph = 0.25

# =============================================================================
# BLACK WING ASCENT (Phase 3 — rise + slam + shock lanes)
# =============================================================================
@export_group("Black Wing Ascent")
@export var bwa_telegraph = 0.65
@export var bwa_slam_damage = 12
@export var bwa_slam_radius = 45.0
@export var bwa_lane_count = 6
@export var bwa_lane_damage = 10
@export var bwa_lane_speed = 300.0
@export var bwa_lane_width = 24.0
@export var bwa_recovery = 0.55

# =============================================================================
# CRIMSON RIFT BLOOM (Phase 3 — radial delayed rifts from center)
# =============================================================================
@export_group("Crimson Rift Bloom")
@export var crb_telegraph = 0.50
@export var crb_rift_count = 8
@export var crb_rift_delay = 0.4
@export var crb_rift_damage = 10
@export var crb_rift_radius = 30.0
@export var crb_bloom_spacing = 50.0
@export var crb_recovery = 0.55

# =============================================================================
# LAST ECLIPSE (Phase 3 — desperation chain at low HP)
# =============================================================================
@export_group("Last Eclipse")
@export var le_hp_threshold = 0.30
@export var le_teleport_damage = 10
@export var le_pounce_damage = 12
@export var le_rift_damage = 8
@export var le_repetitions = 2

# =============================================================================
# ATTACK PACING
# =============================================================================
@export_group("Attack Pacing")
@export var min_attack_cooldown = 0.9
@export var max_attack_cooldown = 1.6
@export var unguarded_posture_mult = 0.3

# =============================================================================
# ENUMS
# =============================================================================
enum Phase { ALIVE, DEAD }
enum BossPhase { PHASE_1, PHASE_2, PHASE_3 }
enum BehaviorState { IDLE, PURSUING, APPROACHING, ATTACKING }
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

enum AttackType {
	NONE,
	# Phase 1
	FUNERAL_MEASURE, BLADE_DANCE, DEATHLY_DASH, SCYTHE_RIFT,
	# Phase 2
	PREDATORS_FEINT, RAVENOUS_REND, BLOOD_HALO, TIMELESS_ZONE,
	# Phase 3
	ECLIPSE_MEASURE, BLACK_WING_ASCENT, CRIMSON_RIFT_BLOOM, LAST_ECLIPSE
}

# =============================================================================
# STATE
# =============================================================================
var _max_bar_hp = 0
var _phase = Phase.ALIVE
var _boss_phase = BossPhase.PHASE_1
var _current_bar = 1  # 1, 2, 3
var _behavior_state = BehaviorState.IDLE
var _current_attack = AttackType.NONE
var _pending_melee_attack = AttackType.NONE
var _combat_phase = CombatPhase.NONE

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

# Parry recoil
var _parry_recoil_until = 0.0
var _parry_recoil_velocity = Vector2.ZERO
var _parry_stagger_until = 0.0
var _post_parry_recovery = 0.25
var _combo_parry_hitstop = 0.10
var _combo_parry_resume_delay = 0.12

# Deathblow
var _dbroken_active = false
var _dbreak_until = -1.0
var _dbreak_immunity_until = 0.0
var _deathblow_in_progress = false
var _stun_until = 0.0

# Posture break flash
var _posture_break_flash_timer: Timer = null
var _posture_break_flash_on = false
var _base_modulate = Color(1, 1, 1)

# Hitbox tracking
var _current_hitbox: Area2D = null
var _is_current_hitbox_melee = false

# Active arena hazards (cleaned up on death/phase transition)
var _active_hazards: Array = []
# Blood Halo reference
var _blood_halo_node: Node2D = null
# Timeless Zone state
var _timeless_zone_active = false

# Last Eclipse tracking
var _last_eclipse_used = false

# UI
var _bars_container: Node2D
var _shogun_posture_bg: ColorRect
var _shogun_posture_fill: ColorRect
var _hp_bg: ColorRect
var _hp_fill: ColorRect
var _bar_pips: Array = []  # 3 pip indicators

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
	
	_max_bar_hp = bar_hp
	hp = _max_bar_hp
	_max_hp = _max_bar_hp
	
	movement_speed = base_movement_speed
	
	can_block = true
	block_by_default = true
	
	_current_bar = 1
	_boss_phase = BossPhase.PHASE_1
	_phase = Phase.ALIVE
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_pending_melee_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	
	_combo_hit_index = 0
	_combo_interrupted = false
	_combo_is_frozen = false
	_combo_should_continue = true
	
	_attack_sequence_id = 0
	_attack_cooldown = 0.0
	_approach_timer = 0.0
	_approach_current_speed = 0.0
	
	_dbroken_active = false
	_dbreak_until = -1.0
	_deathblow_in_progress = false
	_stun_until = 0.0
	
	_last_eclipse_used = false
	_timeless_zone_active = false
	
	_rng.randomize()
	
	add_to_group("boss")
	add_to_group("final_boss")
	add_to_group("eclipse_shogun")
	set_meta("boss_area", 3)
	
	if combat and not combat.config:
		combat.config = CombatConfig.create_boss_config()
	
	if combat and combat.config:
		combat.config.posture_break_duration = deathblow_window_duration
		combat.config.can_do_finisher = true
	
	_setup_bars()
	
	if combat:
		if combat.has_method("update_health_ratio"):
			combat.update_health_ratio(float(hp), float(_max_bar_hp))
		
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
		if _bars_container:
			_bars_container.global_position = global_position
		_update_bars()
		move_and_slide()
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
		combat.update_health_ratio(float(hp), float(_max_bar_hp))
		combat.tick(delta)

	_attack_cooldown = max(_attack_cooldown - delta, 0.0)

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

	_apply_soft_separation()
	move_and_slide()


# =============================================================================
# PHASE HELPERS
# =============================================================================
func _get_speed_mult() -> float:
	match _boss_phase:
		BossPhase.PHASE_2: return phase_2_speed_mult
		BossPhase.PHASE_3: return phase_3_speed_mult
	return 1.0

func _get_attack_speed_mult() -> float:
	match _boss_phase:
		BossPhase.PHASE_2: return phase_2_attack_speed
		BossPhase.PHASE_3: return phase_3_attack_speed
	return 1.0

func _transition_phase(new_phase: BossPhase) -> void:
	_boss_phase = new_phase
	_current_bar += 1
	_clear_deathblow_state()
	_deathblow_in_progress = false

	# Reset HP for new bar
	hp = _max_bar_hp
	_max_hp = _max_bar_hp
	
	# Reset posture
	if combat:
		combat.reset_posture()
		# Slightly increase posture recovery each phase
		if combat.config and new_phase == BossPhase.PHASE_3:
			combat.config.posture_recover_rate *= 1.2

	# Clear active hazards
	_cleanup_all_hazards()

	# Brief stun during transition
	var now = Time.get_ticks_msec() * 0.001
	_stun_until = now + 0.8
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	_cleanup_hitbox()

	# Phase transition visual
	if sprite:
		sprite.modulate = Color(1.0, 0.3, 0.2)
	if anim and anim.has_animation("phase_transition"):
		anim.play("phase_transition")
	elif anim and anim.has_animation("deathblow"):
		anim.play("deathblow")

	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(sprite):
		sprite.modulate = Color.WHITE

	_attack_cooldown = _rng.randf_range(0.8, 1.2)


# =============================================================================
# AI STATE MACHINE
# =============================================================================
func _process_idle_state(player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	velocity = Vector2.ZERO
	_face_direction(dir)
	_play_idle()

	if dist > mid_range + 50.0:
		_transition_to_pursuing()
		return

	if _attack_cooldown <= 0.0:
		var attack = _choose_attack(dist)
		if attack == AttackType.NONE:
			return

		# Melee attacks need approach if too far
		var melee_attacks = [
			AttackType.FUNERAL_MEASURE, AttackType.RAVENOUS_REND,
			AttackType.ECLIPSE_MEASURE
		]
		if dist > close_range and attack in melee_attacks:
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
# ATTACK SELECTION
# =============================================================================
func _choose_attack(dist: float) -> AttackType:
	var pool = []

	match _boss_phase:
		BossPhase.PHASE_1:
			pool = _get_phase_1_pool(dist)
		BossPhase.PHASE_2:
			pool = _get_phase_2_pool(dist)
		BossPhase.PHASE_3:
			pool = _get_phase_3_pool(dist)

	if pool.is_empty():
		return AttackType.NONE

	# Weighted random from pool
	var total = 0.0
	for entry in pool:
		total += entry[1]
	if total <= 0.0:
		return pool[0][0]

	var pick = _rng.randf() * total
	var acc = 0.0
	for entry in pool:
		acc += entry[1]
		if pick <= acc and entry[1] > 0.0:
			return entry[0]

	return pool[0][0]

func _get_phase_1_pool(dist: float) -> Array:
	var pool = []
	if dist <= close_range * 1.5:
		pool.append([AttackType.FUNERAL_MEASURE, 0.30])
		pool.append([AttackType.SCYTHE_RIFT, 0.20])
	if dist <= mid_range:
		pool.append([AttackType.BLADE_DANCE, 0.25])
		pool.append([AttackType.DEATHLY_DASH, 0.25])
	return pool

func _get_phase_2_pool(dist: float) -> Array:
	# Phase 2 keeps some Phase 1 attacks + adds new ones
	var pool = []
	if dist <= close_range * 1.5:
		pool.append([AttackType.FUNERAL_MEASURE, 0.20])
		pool.append([AttackType.RAVENOUS_REND, 0.25])
	if dist <= mid_range:
		pool.append([AttackType.PREDATORS_FEINT, 0.22])
		pool.append([AttackType.BLADE_DANCE, 0.10])
		pool.append([AttackType.DEATHLY_DASH, 0.10])
	# Arena mechanics — lower weight, used less often
	pool.append([AttackType.BLOOD_HALO, 0.08])
	pool.append([AttackType.TIMELESS_ZONE, 0.05])
	return pool

func _get_phase_3_pool(dist: float) -> Array:
	var pool = []
	# Check Last Eclipse desperation
	if not _last_eclipse_used:
		var hp_ratio = float(hp) / float(_max_bar_hp)
		if hp_ratio <= le_hp_threshold:
			return [[AttackType.LAST_ECLIPSE, 1.0]]

	if dist <= close_range * 1.5:
		pool.append([AttackType.ECLIPSE_MEASURE, 0.28])
		pool.append([AttackType.RAVENOUS_REND, 0.15])
	if dist <= mid_range:
		pool.append([AttackType.PREDATORS_FEINT, 0.15])
		pool.append([AttackType.BLACK_WING_ASCENT, 0.18])
	pool.append([AttackType.CRIMSON_RIFT_BLOOM, 0.14])
	pool.append([AttackType.DEATHLY_DASH, 0.10])
	return pool


# =============================================================================
# ATTACK START / FINISH
# =============================================================================
func _start_attack(attack: AttackType) -> void:
	_behavior_state = BehaviorState.ATTACKING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1

	match attack:
		# Phase 1
		AttackType.FUNERAL_MEASURE: _do_funeral_measure()
		AttackType.BLADE_DANCE: _do_blade_dance()
		AttackType.DEATHLY_DASH: _do_deathly_dash()
		AttackType.SCYTHE_RIFT: _do_scythe_rift()
		# Phase 2
		AttackType.PREDATORS_FEINT: _do_predators_feint()
		AttackType.RAVENOUS_REND: _do_ravenous_rend()
		AttackType.BLOOD_HALO: _do_blood_halo()
		AttackType.TIMELESS_ZONE: _do_timeless_zone()
		# Phase 3
		AttackType.ECLIPSE_MEASURE: _do_eclipse_measure()
		AttackType.BLACK_WING_ASCENT: _do_black_wing_ascent()
		AttackType.CRIMSON_RIFT_BLOOM: _do_crimson_rift_bloom()
		AttackType.LAST_ECLIPSE: _do_last_eclipse()

func _finish_attack() -> void:
	var cd_min = min_attack_cooldown
	var cd_max = max_attack_cooldown

	_attack_cooldown = _rng.randf_range(cd_min, cd_max)
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE

	if _is_face_hugging() or _rng.randf() < post_combo_spacing_chance:
		_behavior_state = BehaviorState.IDLE
		await _do_spacing_slide()

	_behavior_state = BehaviorState.IDLE
	_cleanup_hitbox()
	_combo_interrupted = false
	_play_idle()


# =============================================================================
# PHASE 1 ATTACKS
# =============================================================================

# --- FUNERAL MEASURE: 3-hit scythe combo, delayed 3rd hit ---
func _do_funeral_measure() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_combo_interrupted = false
	_combo_hit_index = 0
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
	if not await _wait_duration_interruptible(fm_initial_windup * _get_attack_speed_mult(), my_seq):
		return

	for i in range(3):
		_combo_hit_index = i + 1

		var telegraph = fm_telegraph * _get_attack_speed_mult()
		var damage = fm_damage

		# Third hit: longer delayed wind-up (teaches the rhythm)
		if i == 2:
			telegraph *= fm_heavy_telegraph_mult

		if not await _execute_combo_hit(
			my_seq, telegraph, fm_active, fm_recovery,
			fm_lunge_distance, fm_lunge_speed, damage,
			false, false, true
		):
			return

		if i < 2 and fm_inter_hit_gap > 0.0:
			if not await _wait_duration_interruptible(fm_inter_hit_gap, my_seq):
				return

	_set_combat_phase(CombatPhase.NONE)
	_combo_hit_index = 0
	_finish_attack()

# --- BLADE DANCE: throw spinning projectile, punish recovery on catch ---
func _do_blade_dance() -> void:
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

	var telegraph = bd_telegraph * _get_attack_speed_mult()
	_show_parry_indicator(telegraph + 0.5, true)

	if anim and anim.has_animation("swing_antic"):
		anim.play("swing_antic")

	if not await _wait_duration_interruptible(telegraph, my_seq):
		return

	if _should_abort_attack(my_seq):
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	# Spawn crescent projectile
	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_blade_dance_projectile(dir)

	# Boss is stationary during flight — punishable
	_set_combat_phase(CombatPhase.RECOVERY)
	var flight_time = (bd_projectile_range * 2.0) / bd_projectile_speed
	await get_tree().create_timer(flight_time + bd_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _spawn_blade_dance_projectile(dir: Vector2) -> void:
	var proj = Area2D.new()
	proj.add_to_group("attack")
	proj.collision_layer = 2
	proj.collision_mask = 4
	proj.set_meta("damage", bd_projectile_damage)
	proj.set_meta("attacker", self)
	proj.set_meta("telegraphed", true)
	proj.set_meta("damage_type", "unblockable")
	proj.set_meta("parryable", false)
	proj.set_meta("unblockable", true)

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = bd_projectile_radius
	cs.shape = shape
	proj.add_child(cs)

	var visual = Polygon2D.new()
	var pts = PackedVector2Array()
	for s in range(6):
		var angle = float(s) / 6.0 * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * bd_projectile_radius)
	visual.polygon = pts
	visual.color = Color(0.8, 0.15, 0.1, 0.7)
	proj.add_child(visual)

	proj.global_position = global_position + dir * 20.0
	get_parent().add_child(proj)

	# Animate: go out, come back
	var start_pos = proj.global_position
	var end_pos = start_pos + dir * bd_projectile_range
	var speed = bd_projectile_speed
	var out_time = bd_projectile_range / speed
	var return_pos = start_pos  # Comes back to boss

	var tw = get_tree().create_tween()
	tw.tween_property(proj, "global_position", end_pos, out_time)
	tw.tween_property(proj, "global_position", return_pos, out_time)
	tw.tween_callback(func():
		if is_instance_valid(proj):
			proj.queue_free()
	)

	_active_hazards.append(proj)

# --- DEATHLY DASH: charge + dash + delayed trail detonation ---
func _do_deathly_dash() -> void:
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

	var telegraph = dd_telegraph * _get_attack_speed_mult()
	_show_parry_indicator(telegraph + 0.3, true)

	if anim and anim.has_animation("dash_windup"):
		anim.play("dash_windup")
	elif anim and anim.has_animation("swing_antic"):
		anim.play("swing_antic")

	if not await _wait_duration_interruptible(telegraph, my_seq):
		return

	if _should_abort_attack(my_seq):
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	# Final aim
	if player and is_instance_valid(player):
		var new_dir = (player.global_position - global_position).normalized()
		if new_dir != Vector2.ZERO:
			dir = new_dir
			_face_direction(dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	var start_pos = global_position

	# Dash
	var dash_time = dd_dash_distance / dd_dash_speed
	var elapsed = 0.0
	while elapsed < dash_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		velocity = dir * dd_dash_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	var end_pos = global_position

	# Spawn delayed trail
	_spawn_deathly_trail(start_pos, end_pos)

	# Recovery — boss is punishable here
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(dd_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _spawn_deathly_trail(start_pos: Vector2, end_pos: Vector2) -> void:
	var mid = (start_pos + end_pos) * 0.5
	var trail_dir = (end_pos - start_pos)
	var trail_length = trail_dir.length()
	if trail_length < 5.0:
		return

	# Visual warning line
	var warning = Line2D.new()
	warning.width = dd_trail_width * 0.4
	warning.default_color = Color(0.6, 0.1, 0.1, 0.4)
	warning.add_point(start_pos)
	warning.add_point(end_pos)
	warning.z_index = -1
	get_parent().add_child(warning)
	_active_hazards.append(warning)

	# After delay, detonate
	await get_tree().create_timer(dd_trail_delay).timeout
	if not is_instance_valid(self):
		return

	# Remove warning
	if is_instance_valid(warning):
		warning.queue_free()

	# Spawn damage zone
	var trail_hit = Area2D.new()
	trail_hit.add_to_group("attack")
	trail_hit.collision_layer = 2
	trail_hit.collision_mask = 4
	trail_hit.set_meta("damage", dd_trail_damage)
	trail_hit.set_meta("attacker", self)
	trail_hit.set_meta("telegraphed", true)
	trail_hit.set_meta("damage_type", "unblockable")
	trail_hit.set_meta("parryable", false)
	trail_hit.set_meta("unblockable", true)

	var cs = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(trail_length, dd_trail_width)
	cs.shape = rect
	trail_hit.add_child(cs)

	trail_hit.global_position = mid
	trail_hit.rotation = trail_dir.angle()
	get_parent().add_child(trail_hit)

	# Brief active then cleanup
	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(trail_hit):
		trail_hit.queue_free()

# --- SCYTHE RIFT: forward slash + delayed ground hazard ---
func _do_scythe_rift() -> void:
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

	var telegraph = sr_telegraph * _get_attack_speed_mult()
	var total_dur = telegraph + parry_early_window + fm_active + parry_linger_window
	_show_parry_indicator(total_dur, false)

	if anim and anim.has_animation("swing_antic"):
		anim.play("swing_antic")

	if not await _wait_duration_interruptible(telegraph, my_seq):
		return
	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	# Slash hit (parryable)
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_swing_hitbox(dir, sr_slash_damage, false, false)
	_is_current_hitbox_melee = true

	if not await _wait_duration_interruptible(parry_early_window, my_seq):
		return
	if not await _wait_duration_interruptible(fm_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	# Spawn rift at slash endpoint
	var rift_pos = global_position + dir * fm_range * 0.8
	_spawn_ground_rift(rift_pos)

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(sr_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _spawn_ground_rift(pos: Vector2) -> void:
	# Warning circle
	var warning = _create_warning_circle(pos, sr_rift_radius, Color(0.5, 0.0, 0.0, 0.3), sr_rift_delay)
	_active_hazards.append(warning)

	await get_tree().create_timer(sr_rift_delay).timeout
	if not is_instance_valid(self):
		return

	if is_instance_valid(warning):
		warning.queue_free()

	# Damage burst
	var rift = _spawn_radial_burst(pos, sr_rift_radius, sr_rift_damage, true)
	_active_hazards.append(rift)

	# Lingering hazard zone
	await get_tree().create_timer(sr_rift_lifetime).timeout
	if is_instance_valid(rift):
		rift.queue_free()


# =============================================================================
# PHASE 2 ATTACKS
# =============================================================================

# --- PREDATOR'S FEINT: fake dash → cancel → pounce ---
func _do_predators_feint() -> void:
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

	# Fake dash telegraph (looks like Deathly Dash)
	_show_parry_indicator(pf_fake_telegraph + 0.5, true)

	if anim and anim.has_animation("dash_windup"):
		anim.play("dash_windup")
	elif anim and anim.has_animation("swing_antic"):
		anim.play("swing_antic")

	if not await _wait_duration_interruptible(pf_fake_telegraph * _get_attack_speed_mult(), my_seq):
		return

	# Short fake dash (abort early)
	var fake_time = pf_fake_dash_distance / dd_dash_speed
	var elapsed = 0.0
	while elapsed < fake_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_finish_attack()
			return
		velocity = dir * dd_dash_speed * 0.6
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	# Cancel into pounce — re-aim at player
	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

	# Brief pounce telegraph
	if not await _wait_duration_interruptible(pf_pounce_telegraph * _get_attack_speed_mult(), my_seq):
		return

	# Pounce
	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_swing_hitbox(dir, pf_damage, false, false)
	_is_current_hitbox_melee = true

	var total_dur = parry_early_window + fm_active + parry_linger_window
	_show_parry_indicator(total_dur, false)

	var pounce_time = pf_pounce_distance / pf_pounce_speed
	elapsed = 0.0
	while elapsed < pounce_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_finish_attack()
			return
		velocity = dir * pf_pounce_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if not await _wait_duration_interruptible(fm_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return
	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(pf_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

# --- RAVENOUS REND: fast close-range combo + punishable finisher ---
func _do_ravenous_rend() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_combo_interrupted = false
	_combo_hit_index = 0
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

	# Fast hits
	for i in range(rr_hits):
		_combo_hit_index = i + 1
		var telegraph = rr_telegraph * _get_attack_speed_mult()

		if not await _execute_combo_hit(
			my_seq, telegraph, fm_active, 0.15,
			fm_lunge_distance * 0.6, fm_lunge_speed, rr_damage,
			false, false, true
		):
			return

		if i < rr_hits - 1 and rr_inter_hit_gap > 0.0:
			if not await _wait_duration_interruptible(rr_inter_hit_gap, my_seq):
				return

	# Committed finisher — longer telegraph, bigger damage, punishable
	_combo_hit_index = rr_hits + 1
	if not await _execute_combo_hit(
		my_seq, rr_finisher_telegraph * _get_attack_speed_mult(), fm_active, rr_recovery,
		fm_lunge_distance, fm_lunge_speed * 0.8, rr_finisher_damage,
		false, false, true
	):
		return

	_set_combat_phase(CombatPhase.NONE)
	_combo_hit_index = 0
	_finish_attack()

# --- BLOOD HALO: brief rotating ring hazard around boss ---
func _do_blood_halo() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	velocity = Vector2.ZERO

	if sprite:
		sprite.modulate = Color(1.0, 0.4, 0.3)

	# Spawn ring hazard that follows the boss
	var halo = Node2D.new()
	halo.name = "BloodHalo"
	add_child(halo)
	_blood_halo_node = halo

	# Visual ring
	var visual = Polygon2D.new()
	var pts = PackedVector2Array()
	var seg = 24
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * bh_radius)
	visual.polygon = pts
	visual.color = Color(0.7, 0.1, 0.05, 0.25)
	visual.z_index = -1
	halo.add_child(visual)

	# Tick damage at intervals
	var ticks = int(bh_duration / bh_tick_interval)
	for t in range(ticks):
		if _should_abort_attack(my_seq) or not is_instance_valid(halo):
			break
		# Check player in ring
		var player = _get_player()
		if player and is_instance_valid(player):
			var dist = player.global_position.distance_to(global_position)
			# Damage if player is near the ring edge (between 0.7*radius and 1.1*radius)
			if dist >= bh_radius * 0.7 and dist <= bh_radius * 1.1:
				# Spawn brief hitbox at player position
				var tick_hit = _spawn_radial_burst(player.global_position, 15.0, bh_damage, true)
				get_tree().create_timer(0.15).timeout.connect(func():
					if is_instance_valid(tick_hit):
						tick_hit.queue_free()
				)

		await get_tree().create_timer(bh_tick_interval).timeout
		if not is_instance_valid(self):
			return

	# Cleanup
	if is_instance_valid(halo):
		halo.queue_free()
	_blood_halo_node = null

	if sprite:
		sprite.modulate = Color.WHITE

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(0.3).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

# --- TIMELESS ZONE: darkness + safe zone + boss attacks ---
func _do_timeless_zone() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	_timeless_zone_active = true
	velocity = Vector2.ZERO

	var player = _get_player()
	if not player:
		_timeless_zone_active = false
		_finish_attack()
		return

	# Place safe zone at current player position
	var safe_pos = player.global_position

	# Visual: safe zone circle
	var safe_zone = Node2D.new()
	safe_zone.global_position = safe_pos
	get_parent().add_child(safe_zone)
	_active_hazards.append(safe_zone)

	var safe_visual = Polygon2D.new()
	var pts = PackedVector2Array()
	var seg = 24
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * tz_safe_radius)
	safe_visual.polygon = pts
	safe_visual.color = Color(0.9, 0.8, 0.5, 0.15)
	safe_visual.z_index = -1
	safe_zone.add_child(safe_visual)

	# Darkness overlay (CanvasLayer for full-screen dim)
	var darkness = ColorRect.new()
	var viewport_size = get_viewport_rect().size
	darkness.size = viewport_size
	darkness.position = -viewport_size * 0.5
	darkness.color = Color(0.0, 0.0, 0.05, 0.7)
	darkness.z_index = 50
	# Add to a temporary CanvasLayer so it covers everything
	var dark_layer = CanvasLayer.new()
	dark_layer.layer = 10
	dark_layer.add_child(darkness)
	get_parent().add_child(dark_layer)
	_active_hazards.append(dark_layer)

	# Duration loop: tick darkness damage + boss attacks into safe zone
	var elapsed = 0.0
	var attacks_done = 0
	var next_attack_time = tz_duration / float(tz_attack_count + 1)
	var attack_timer = next_attack_time

	while elapsed < tz_duration:
		if _should_abort_attack(my_seq):
			break

		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		var dt = get_physics_process_delta_time()
		elapsed += dt
		attack_timer -= dt

		# Darkness damage if player outside safe zone
		if player and is_instance_valid(player):
			var dist_to_safe = player.global_position.distance_to(safe_pos)
			if dist_to_safe > tz_safe_radius:
				# Tick damage
				if "hp" in player:
					var tick_dmg = tz_darkness_dps * dt
					# Accumulate fractional damage
					var accum = float(get_meta("_tz_dmg_accum", 0.0)) + tick_dmg
					if accum >= 1.0:
						var whole = int(accum)
						accum -= whole
						player.hp = max(0, player.hp - whole)
						if player.has_method("_update_health_bar"):
							player._update_health_bar()
					set_meta("_tz_dmg_accum", accum)

		# Boss attacks into the safe zone at intervals
		if attacks_done < tz_attack_count and attack_timer <= 0.0:
			attacks_done += 1
			attack_timer = next_attack_time

			# Teleport near safe zone edge and do a swing
			var attack_dir = (safe_pos - global_position).normalized()
			if attack_dir == Vector2.ZERO:
				attack_dir = Vector2.RIGHT
			var teleport_pos = safe_pos - attack_dir * (tz_safe_radius + 30.0)
			global_position = teleport_pos
			_face_direction(attack_dir)

			# Quick swing into the zone
			_current_hitbox = _spawn_swing_hitbox(attack_dir, fm_damage, false, false)
			_is_current_hitbox_melee = true
			_show_parry_indicator(parry_early_window + fm_active + parry_linger_window, false)

			await get_tree().create_timer(parry_early_window + fm_active + parry_linger_window).timeout
			if not is_instance_valid(self):
				return
			_cleanup_hitbox()

	# Cleanup
	remove_meta("_tz_dmg_accum")
	_timeless_zone_active = false

	if is_instance_valid(safe_zone):
		safe_zone.queue_free()
	if is_instance_valid(dark_layer):
		dark_layer.queue_free()

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(0.5).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# PHASE 3 ATTACKS
# =============================================================================

# --- ECLIPSE MEASURE: evolved Funeral Measure + beast lunge between hits 2-3 ---
func _do_eclipse_measure() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_combo_interrupted = false
	_combo_hit_index = 0
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
	if not await _wait_duration_interruptible(fm_initial_windup * _get_attack_speed_mult(), my_seq):
		return

	# Hit 1: normal scythe swing
	_combo_hit_index = 1
	if not await _execute_combo_hit(
		my_seq, fm_telegraph * _get_attack_speed_mult(), fm_active, 0.15,
		fm_lunge_distance, fm_lunge_speed, em_damage,
		false, false, true
	):
		return

	if not await _wait_duration_interruptible(fm_inter_hit_gap, my_seq):
		return

	# Hit 2: normal scythe swing
	_combo_hit_index = 2
	if not await _execute_combo_hit(
		my_seq, fm_telegraph * _get_attack_speed_mult(), fm_active, 0.12,
		fm_lunge_distance, fm_lunge_speed, em_damage,
		false, false, true
	):
		return

	# Beast lunge insert — sudden forward pounce (perilous)
	if _should_abort_attack(my_seq):
		_finish_attack()
		return

	_combo_hit_index = 3

	if sprite:
		sprite.modulate = Color(1.0, 0.4, 0.3)

	var beast_telegraph = em_beast_telegraph * _get_attack_speed_mult()
	_show_parry_indicator(beast_telegraph + 0.3, true)

	if not await _wait_duration_interruptible(beast_telegraph, my_seq):
		if sprite:
			sprite.modulate = Color.WHITE
		return

	# Re-aim at player
	if player and is_instance_valid(player):
		base_dir = (player.global_position - global_position).normalized()
		if base_dir == Vector2.ZERO:
			base_dir = Vector2.RIGHT
		_face_direction(base_dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_swing_hitbox(base_dir, em_beast_lunge_damage, false, true)
	_is_current_hitbox_melee = true

	# Lunge forward
	var lunge_time = em_beast_lunge_distance / em_beast_lunge_speed
	var elapsed = 0.0
	while elapsed < lunge_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			if sprite:
				sprite.modulate = Color.WHITE
			_finish_attack()
			return
		velocity = base_dir * em_beast_lunge_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	await get_tree().create_timer(fm_active).timeout
	_cleanup_hitbox()

	if sprite:
		sprite.modulate = Color.WHITE

	# Hit 4: heavy delayed finisher (same as Funeral Measure hit 3)
	_combo_hit_index = 4
	if not await _execute_combo_hit(
		my_seq, fm_telegraph * fm_heavy_telegraph_mult * _get_attack_speed_mult(),
		fm_active, fm_recovery, fm_lunge_distance, fm_lunge_speed, em_damage,
		false, false, true
	):
		return

	_set_combat_phase(CombatPhase.NONE)
	_combo_hit_index = 0
	_finish_attack()

# --- BLACK WING ASCENT: rise + slam + shock lanes ---
func _do_black_wing_ascent() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	if sprite:
		sprite.modulate = Color(0.6, 0.2, 0.2)

	_show_parry_indicator(bwa_telegraph + 0.3, true)

	# Rise (visual: boss rises)
	if not await _wait_duration_interruptible(bwa_telegraph * _get_attack_speed_mult(), my_seq):
		if sprite:
			sprite.modulate = Color.WHITE
		return

	if _should_abort_attack(my_seq):
		if sprite:
			sprite.modulate = Color.WHITE
		_finish_attack()
		return

	# Slam — radial burst at landing
	_set_combat_phase(CombatPhase.ACTIVE)
	var slam_pos = global_position
	var slam_hit = _spawn_radial_burst(slam_pos, bwa_slam_radius, bwa_slam_damage, true)

	if sprite:
		sprite.modulate = Color(1.0, 0.3, 0.2)

	await get_tree().create_timer(0.15).timeout
	if is_instance_valid(slam_hit):
		slam_hit.queue_free()

	# Shock lanes radiating outward
	for i in range(bwa_lane_count):
		var angle = float(i) / float(bwa_lane_count) * TAU
		var lane_dir = Vector2(cos(angle), sin(angle))
		_spawn_shock_lane(slam_pos, lane_dir)

	if sprite:
		sprite.modulate = Color.WHITE

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(bwa_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _spawn_shock_lane(origin: Vector2, dir: Vector2) -> void:
	# Projectile-style lane that travels outward
	var lane = Area2D.new()
	lane.add_to_group("attack")
	lane.collision_layer = 2
	lane.collision_mask = 4
	lane.set_meta("damage", bwa_lane_damage)
	lane.set_meta("attacker", self)
	lane.set_meta("telegraphed", true)
	lane.set_meta("damage_type", "unblockable")
	lane.set_meta("parryable", false)
	lane.set_meta("unblockable", true)

	var cs = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(bwa_lane_width * 2.0, bwa_lane_width)
	cs.shape = rect
	cs.rotation = dir.angle()
	lane.add_child(cs)

	# Visual
	var visual = ColorRect.new()
	visual.size = Vector2(bwa_lane_width * 2.0, bwa_lane_width * 0.6)
	visual.position = Vector2(-bwa_lane_width, -bwa_lane_width * 0.3)
	visual.color = Color(0.6, 0.1, 0.05, 0.6)
	visual.rotation = dir.angle()
	lane.add_child(visual)

	lane.global_position = origin + dir * 20.0
	get_parent().add_child(lane)
	_active_hazards.append(lane)

	# Move outward
	var travel_time = 200.0 / bwa_lane_speed
	var tw = get_tree().create_tween()
	tw.tween_property(lane, "global_position", origin + dir * 200.0, travel_time)
	tw.tween_callback(func():
		if is_instance_valid(lane):
			lane.queue_free()
	)

# --- CRIMSON RIFT BLOOM: plant weapon, radial delayed rifts ---
func _do_crimson_rift_bloom() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	if sprite:
		sprite.modulate = Color(0.8, 0.2, 0.15)

	_show_parry_indicator(crb_telegraph + crb_rift_delay * 2.0, true)

	if not await _wait_duration_interruptible(crb_telegraph * _get_attack_speed_mult(), my_seq):
		if sprite:
			sprite.modulate = Color.WHITE
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	var center = global_position

	# Spawn rifts in rings outward from center
	for i in range(crb_rift_count):
		var angle = float(i) / float(crb_rift_count) * TAU
		var rift_dir = Vector2(cos(angle), sin(angle))
		var rift_pos = center + rift_dir * crb_bloom_spacing

		# Stagger the detonation times for readability
		var delay = crb_rift_delay + float(i) * 0.08
		_spawn_timed_rift(rift_pos, delay, crb_rift_damage, crb_rift_radius)

	if sprite:
		sprite.modulate = Color.WHITE

	_set_combat_phase(CombatPhase.RECOVERY)
	# Recovery matches the total rift detonation time
	var total_rift_time = crb_rift_delay + float(crb_rift_count) * 0.08 + 0.3
	await get_tree().create_timer(max(crb_recovery, total_rift_time)).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _spawn_timed_rift(pos: Vector2, delay: float, damage: int, radius: float) -> void:
	var warning = _create_warning_circle(pos, radius, Color(0.5, 0.0, 0.0, 0.3), delay)
	_active_hazards.append(warning)

	await get_tree().create_timer(delay).timeout
	if not is_instance_valid(self):
		return
	if is_instance_valid(warning):
		warning.queue_free()

	var burst = _spawn_radial_burst(pos, radius, damage, true)
	_active_hazards.append(burst)

	await get_tree().create_timer(0.2).timeout
	if is_instance_valid(burst):
		burst.queue_free()

# --- LAST ECLIPSE: desperation chain ---
func _do_last_eclipse() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_last_eclipse_used = true
	_set_combat_phase(CombatPhase.ACTIVE)
	velocity = Vector2.ZERO

	if sprite:
		sprite.modulate = Color(1.0, 0.2, 0.15)

	for rep in range(le_repetitions):
		if _should_abort_attack(my_seq):
			break

		var player = _get_player()
		if not player or not is_instance_valid(player):
			break

		# 1. Teleport slash
		var dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		var teleport_pos = player.global_position - dir * ideal_combat_distance * 0.6
		global_position = teleport_pos
		_face_direction(dir)

		_current_hitbox = _spawn_swing_hitbox(dir, le_teleport_damage, false, false)
		_is_current_hitbox_melee = true
		_show_parry_indicator(0.25 + fm_active, false)

		if not await _wait_duration_interruptible(0.25, my_seq):
			break
		if not await _wait_duration_interruptible(fm_active, my_seq):
			break
		if not await _wait_duration_interruptible(parry_linger_window, my_seq):
			break
		_cleanup_hitbox()

		if _should_abort_attack(my_seq):
			break

		# 2. Beast pounce
		if player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT

		_show_parry_indicator(0.2 + fm_active, true)

		if not await _wait_duration_interruptible(0.15, my_seq):
			break

		_current_hitbox = _spawn_swing_hitbox(dir, le_pounce_damage, false, true)
		_is_current_hitbox_melee = true

		var pounce_time = 80.0 / pf_pounce_speed
		var elapsed = 0.0
		while elapsed < pounce_time:
			if _should_abort_attack(my_seq):
				velocity = Vector2.ZERO
				_cleanup_hitbox()
				break
			velocity = dir * pf_pounce_speed
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			elapsed += get_physics_process_delta_time()
		velocity = Vector2.ZERO

		if not await _wait_duration_interruptible(fm_active, my_seq):
			break
		_cleanup_hitbox()

		# 3. Delayed rift at current position
		_spawn_timed_rift(global_position, 0.4, le_rift_damage, sr_rift_radius)

		if not await _wait_duration_interruptible(0.3, my_seq):
			break

	if sprite:
		sprite.modulate = Color.WHITE

	_set_combat_phase(CombatPhase.RECOVERY)
	# Long recovery after desperation — big punish window
	await get_tree().create_timer(1.0).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

func _execute_combo_hit(
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
		hitbox.set_meta("damage_type", "boss_swing")
		hitbox.set_meta("parryable", true)
		hitbox.set_meta("unblockable", false)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(fm_range, fm_width)
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (fm_range * 0.5)
	hitbox.rotation = dir.angle()
	return hitbox

func _spawn_radial_burst(center: Vector2, radius: float, damage: int, unblockable: bool) -> Area2D:
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
		area.set_meta("damage_type", "boss_burst")
		area.set_meta("parryable", false)
		area.set_meta("unblockable", false)

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
	cs.shape = shape
	area.add_child(cs)
	area.global_position = center
	get_parent().add_child(area)
	return area


# =============================================================================
# ARENA HAZARD HELPERS
# =============================================================================
func _create_warning_circle(pos: Vector2, radius: float, color: Color, lifetime: float) -> Node2D:
	var node = Node2D.new()
	node.global_position = pos
	get_parent().add_child(node)

	var visual = Polygon2D.new()
	var pts = PackedVector2Array()
	var seg = 16
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * radius)
	visual.polygon = pts
	visual.color = color
	visual.z_index = -1
	node.add_child(visual)

	return node

func _cleanup_all_hazards() -> void:
	for hazard in _active_hazards:
		if is_instance_valid(hazard):
			hazard.queue_free()
	_active_hazards.clear()

	if is_instance_valid(_blood_halo_node):
		_blood_halo_node.queue_free()
		_blood_halo_node = null

func _cleanup_hitbox() -> void:
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
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
# DAMAGE HANDLING
# =============================================================================
func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _phase == Phase.DEAD:
		return
	if damage <= 0:
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

	var guarding = _is_guarding()

	# --- GUARDING: posture damage only ---
	if guarding:
		if combat:
			combat.notify_got_hit({"damage": 0, "blocked": true})

		if attacker is Area2D and attacker.has_meta("prosthetic_source"):
			ProstheticEffects.apply(attacker, self, true)

		var se = get_node_or_null("/root/StanceEffects")
		if se and se.has_method("on_enemy_hit"):
			se.on_enemy_hit(attacker, self, true)

		_flash_block()
		return

	# --- NOT GUARDING: HP damage ---
	var final_damage = damage
	var posture_mult = unguarded_posture_mult

	# Windup armor
	if _is_in_windup():
		final_damage = int(round(float(final_damage) * windup_damage_mult))
		posture_mult *= windup_posture_mult
		_flash_windup_hit()

	# Posture via CombatController
	if combat:
		var posture_event = {"damage": final_damage, "blocked": false}
		var orig_gain = combat.config.hit_posture_gain if combat.config else 12.0
		if combat.config:
			combat.config.hit_posture_gain = orig_gain * posture_mult
		combat.notify_got_hit(posture_event)
		if combat.config:
			combat.config.hit_posture_gain = orig_gain

	if attacker is Area2D and attacker.has_meta("prosthetic_source"):
		ProstheticEffects.apply(attacker, self, false)

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

	_hide_parry_indicator()

	var local_attack = _current_attack

	if combat and combat.config:
		var current = combat.get_posture()
		var maxv = combat.config.posture_max
		var bonus = parry_posture_damage
		var new_posture = min(current + bonus, maxv)
		combat.set_posture(new_posture)
		combat.notify_got_hit({"damage": 0, "parried": true})
		combat.suppress_recovery(1.0)

	_cleanup_hitbox()
	hitstop_local(0.06)

	# Combo parries: freeze + flinch, combo continues
	if local_attack in [AttackType.FUNERAL_MEASURE, AttackType.RAVENOUS_REND, AttackType.ECLIPSE_MEASURE]:
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

	# Non-combo attacks: full interrupt
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

	# Deathblow deals big damage to current bar
	_apply_damage(deathblow_damage, "deathblow", attacker)

	_clear_deathblow_state()
	emit_signal("posture_recovered")

	var now = Time.get_ticks_msec() * 0.001
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

	var original_mod = sprite.modulate if sprite else Color.WHITE
	if sprite:
		sprite.modulate = Color(1.0, 0.3, 0.2)
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
# DAMAGE / DEATH / PHASE TRANSITIONS
# =============================================================================
func _apply_damage(damage: int, _damage_type: String, _attacker: Node) -> void:
	if _phase == Phase.DEAD:
		return
	
	hp = max(hp - damage, 0)
	_update_bars()
	
	if combat and combat.has_method("update_health_ratio"):
		combat.update_health_ratio(float(hp), float(_max_bar_hp))

	# Check for bar depletion → phase transition
	if hp <= 0:
		if _current_bar < 3:
			# Phase transition
			match _current_bar:
				1: _transition_phase(BossPhase.PHASE_2)
				2: _transition_phase(BossPhase.PHASE_3)
		else:
			# Final bar depleted — die
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
	_timeless_zone_active = false
	velocity = Vector2.ZERO
	_attack_sequence_id += 1
	
	_cleanup_all_hazards()
	_cleanup_hitbox()
	_stop_posture_break_flash()
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if _bars_container:
		_bars_container.visible = false
	
	if is_in_group("boss"):
		remove_from_group("boss")
	
	if is_in_group("final_boss"):
		remove_from_group("final_boss")
	
	if is_in_group("eclipse_shogun"):
		remove_from_group("eclipse_shogun")
	
	emit_signal("defeated")
	emit_signal("enemy_died", self)
	
	_run_humanoid_death_rewards()
	
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

func _flash_block() -> void:
	if not sprite:
		return
	var orig = sprite.modulate
	sprite.modulate = Color(0.7, 0.85, 1.0)
	await get_tree().create_timer(0.06).timeout
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
	sprite.modulate = Color(0.8, 0.3, 0.2)

func _on_posture_break_flash_tick() -> void:
	if not _dbroken_active or _phase == Phase.DEAD:
		_stop_posture_break_flash()
		return
	if not sprite:
		return
	if _posture_break_flash_on:
		sprite.modulate = _base_modulate
	else:
		sprite.modulate = Color(0.8, 0.3, 0.2)
	_posture_break_flash_on = not _posture_break_flash_on

func _stop_posture_break_flash() -> void:
	if _posture_break_flash_timer:
		_posture_break_flash_timer.stop()
	_posture_break_flash_on = false
	if sprite:
		sprite.modulate = _base_modulate


# =============================================================================
# UI BARS — HP + Posture + Bar Pips
# =============================================================================
func _setup_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsUI"
	_bars_container.z_index = 100
	add_child(_bars_container)

	_shogun_posture_bg = ColorRect.new()
	_shogun_posture_bg.size = Vector2(64, 6)
	_shogun_posture_bg.color = Color(0.08, 0.08, 0.15, 0.8)
	_shogun_posture_bg.position = Vector2(-32, -65)
	_bars_container.add_child(_shogun_posture_bg)

	_shogun_posture_fill = ColorRect.new()
	_shogun_posture_fill.size = Vector2(0, 6)
	_shogun_posture_fill.color = Color(0.9, 0.5, 0.3, 0.95)
	_shogun_posture_fill.position = Vector2.ZERO
	_shogun_posture_bg.add_child(_shogun_posture_fill)

	var posture_border = ColorRect.new()
	posture_border.size = Vector2(66, 8)
	posture_border.color = Color(0.2, 0.1, 0.1, 0.9)
	posture_border.position = Vector2(-33, -66)
	posture_border.z_index = -1
	_bars_container.add_child(posture_border)

	# HP bar
	_hp_bg = ColorRect.new()
	_hp_bg.size = Vector2(64, 6)
	_hp_bg.color = Color(0.15, 0.02, 0.02, 0.8)
	_hp_bg.position = Vector2(-32, -56)
	_bars_container.add_child(_hp_bg)
	_hp_fill = ColorRect.new()
	_hp_fill.size = Vector2(64, 6)
	_hp_fill.color = Color(0.85, 0.15, 0.1, 0.95)
	_hp_fill.position = Vector2.ZERO
	_hp_bg.add_child(_hp_fill)

	var hp_border = ColorRect.new()
	hp_border.size = Vector2(66, 8)
	hp_border.color = Color(0.25, 0.08, 0.08, 0.9)
	hp_border.position = Vector2(-33, -57)
	hp_border.z_index = -1
	_bars_container.add_child(hp_border)

	# Bar pip indicators (3 dots below HP bar)
	_bar_pips.clear()
	for i in range(3):
		var pip = ColorRect.new()
		pip.size = Vector2(6, 6)
		pip.position = Vector2(-12 + i * 10, -47)
		pip.color = Color(0.9, 0.3, 0.2, 0.9) if i < (4 - _current_bar) else Color(0.3, 0.1, 0.1, 0.5)
		_bars_container.add_child(pip)
		_bar_pips.append(pip)

	_bars_container.visible = true

func _update_bars() -> void:
	if _hp_fill:
		var hp_pct = clamp(float(hp) / float(_max_bar_hp), 0.0, 1.0)
		_hp_fill.size.x = 64.0 * hp_pct
		if hp_pct >= 0.5:
			_hp_fill.color = Color(0.85, 0.15, 0.1, 0.95)
		elif hp_pct >= 0.25:
			_hp_fill.color = Color(0.9, 0.3, 0.1, 0.95)
		else:
			var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.008)
			_hp_fill.color = Color(1.0, 0.2 * flash, 0.1 * flash, 0.95)

	# Update pip indicators
	for i in range(_bar_pips.size()):
		if is_instance_valid(_bar_pips[i]):
			# Remaining bars = 4 - _current_bar (since _current_bar is 1-indexed)
			# Pip i is "alive" if i < remaining bars
			var remaining = 4 - _current_bar
			_bar_pips[i].color = Color(0.9, 0.3, 0.2, 0.9) if i < remaining else Color(0.3, 0.1, 0.1, 0.5)

func _update_posture_bar(cur: float, maxv: float) -> void:
	if not _shogun_posture_fill or not _shogun_posture_bg:
		return
	
	var pct = clamp(cur / max(0.001, maxv), 0.0, 1.0)
	_shogun_posture_fill.size.x = 64.0 * pct
	
	var hp_ratio = clamp(float(hp) / float(_max_bar_hp), 0.0, 1.0)
	
	if hp_ratio >= 0.75:
		_shogun_posture_fill.color = Color(0.9, 0.5, 0.3, 0.95)
	elif hp_ratio >= 0.50:
		_shogun_posture_fill.color = Color(0.95, 0.4, 0.3, 0.95)
	elif hp_ratio >= 0.25:
		_shogun_posture_fill.color = Color(1.0, 0.3, 0.25, 0.95)
	else:
		var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.01)
		_shogun_posture_fill.color = Color(1.0, 0.2 * flash, 0.15 * flash, 0.95)
	
	if pct >= 0.85:
		var break_flash = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.015)
		_shogun_posture_fill.color.a = break_flash

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
	return fm_damage

func get_enemy_tags() -> Array:
	return ["eclipse", "samurai", "beast"]

func _update_sprite_facing() -> void:
	var player = _get_player()
	if player and sprite:
		sprite.flip_h = player.global_position.x > global_position.x

func _is_guarding() -> bool:
	if _phase == Phase.DEAD:
		return false
	
	if _dbroken_active:
		return false
	
	if _timeless_zone_active:
		return false
	
	if _combat_phase != CombatPhase.NONE:
		return false
	
	if _is_current_hitbox_melee:
		return false
	
	var now = Time.get_ticks_msec() * 0.001
	
	if _parry_recoil_until > 0.0 and now < _parry_recoil_until:
		return false
	
	if _stun_until > 0.0 and now < _stun_until:
		return false
	
	return true
