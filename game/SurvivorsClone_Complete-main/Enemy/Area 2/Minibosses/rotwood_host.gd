extends BeastEnemyBase
class_name RotwoodHost

# =============================================================================
# SPIRIT HP — The real boss health
# =============================================================================
@export_group("Spirit HP")
@export var max_spirit_hp = 200
## Damage the player deals to the spirit per hit during chase
@export var spirit_hit_damage = 18
## Minimum bugs to reassemble — below this, boss dies
@export var spirit_death_threshold = 0

# =============================================================================
# SHELL STATS (no HP — posture only)
# =============================================================================
@export_group("Shell Stats")
@export var base_movement_speed = 55.0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage = 24.0
@export var block_posture_damage = 8.0
@export var deathblow_window_duration = 3.0
@export var deathblow_immunity_time = 0.3
@export var unguarded_posture_mult = 0.3

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
# DISTANCE THRESHOLDS
# =============================================================================
@export_group("Distance Thresholds")
@export var close_range = 80.0
@export var mid_range = 160.0
@export var far_range = 260.0

# =============================================================================
# SPACING
# =============================================================================
@export_group("Spacing")
@export var ideal_combat_distance = 55.0
@export var too_close_threshold = 30.0
@export var lunge_min_distance = 20.0
@export var min_separation = 18.0
@export var post_combo_spacing_chance = 0.20
@export var spacing_slide_distance = 35.0
@export var spacing_slide_speed = 85.0

# =============================================================================
# APPROACH
# =============================================================================
@export_group("Approach")
@export var approach_speed = 140.0
@export var approach_acceleration = 40.0
@export var approach_max_speed = 190.0
@export var approach_commitment_time = 3.0

# =============================================================================
# CLAW FLURRY
# =============================================================================
@export_group("Claw Flurry")
@export var claw_damage = 10
@export var claw_range = 60.0
@export var claw_width = 50.0
@export var claw_telegraph = 0.32
@export var claw_active = 0.12
@export var claw_recovery = 0.30
@export var claw_lunge_distance = 30.0
@export var claw_lunge_speed = 420.0
@export var claw_inter_hit_gap = 0.10
@export var claw_initial_windup = 0.28
## Delay before hit 3 (the rhythm-breaker)
@export var claw_hit3_delay = 0.30

# =============================================================================
# LUNGING BITE
# =============================================================================
@export_group("Lunging Bite")
@export var bite_damage = 14
@export var bite_range = 65.0
@export var bite_width = 40.0
@export var bite_telegraph = 0.55
@export var bite_active = 0.14
@export var bite_recovery = 0.45
@export var bite_lunge_distance = 70.0
@export var bite_lunge_speed = 500.0
## Feint pause before real lunge
@export var bite_feint_duration = 0.40

# =============================================================================
# TAIL LASH (perilous — parry-only)
# =============================================================================
@export_group("Tail Lash")
@export var tail_damage = 8
@export var tail_range = 65.0
@export var tail_width = 80.0
@export var tail_telegraph = 0.28
@export var tail_active = 0.12
@export var tail_recovery = 0.35

# =============================================================================
# RISING SLAM (unblockable — dodge-only)
# =============================================================================
@export_group("Rising Slam")
@export var slam_damage = 16
@export var slam_radius = 55.0
@export var slam_windup = 0.75
@export var slam_recovery = 0.55
@export var slam_parry_preframe = 0.10
## Follow-up claw after missed slam (parryable)
@export var slam_followup_telegraph = 0.22
@export var slam_followup_damage = 8

# =============================================================================
# SCREECH (reactive push-back)
# =============================================================================
@export_group("Screech")
@export var screech_radius = 50.0
@export var screech_posture_damage_to_player = 10.0
@export var screech_knockback_force = 180.0
@export var screech_telegraph = 0.25
@export var screech_recovery = 0.40
@export var screech_player_hit_threshold = 3

# =============================================================================
# POUNCE (gap closer)
# =============================================================================
@export_group("Pounce")
@export var pounce_damage = 10
@export var pounce_speed = 350.0
@export var pounce_duration = 0.30
@export var pounce_landing_radius = 40.0
@export var pounce_recovery = 0.30
@export var pounce_min_range = 100.0

# =============================================================================
# SPIRIT CHASE PHASE
# =============================================================================
@export_group("Spirit Chase")
## How long the spirit stays out before reabsorbing
@export var spirit_chase_duration = 9.0
## Pause at each landing point
@export var spirit_pause_at_point = 0.6
## Dash speed between points
@export var spirit_dash_speed = 350.0
## Stagger on hit (brief freeze as feedback)
@export var spirit_hit_stagger = 0.3
## Spirit trail (ember patch reuse)
@export var spirit_trail_damage = 1.0
@export var spirit_trail_duration = 1.5
@export var spirit_trail_radius = 18.0

# =============================================================================
# ATTACK PACING
# =============================================================================
@export_group("Attack Pacing")
@export var min_attack_cooldown = 0.8
@export var max_attack_cooldown = 1.5

# =============================================================================
# ENUMS
# =============================================================================
enum Phase { ALIVE, DEAD }
enum BehaviorState { IDLE, PURSUING, APPROACHING, ATTACKING, SPIRIT_CHASE }
enum AttackType { NONE, CLAW_FLURRY, LUNGING_BITE, TAIL_LASH, RISING_SLAM, SCREECH, POUNCE }
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

# =============================================================================
# STATE
# =============================================================================
var _phase = Phase.ALIVE
var _behavior_state = BehaviorState.IDLE
var _current_attack = AttackType.NONE
var _pending_melee_attack = AttackType.NONE
var _combat_phase = CombatPhase.NONE

# Spirit system
var spirit_hp = 0
var _spirit_phase_active = false
var _spirit_entity: Node2D = null
var _spirit_chase_timer = 0.0
var _deathblow_cycle_count = 0

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

# Player aggression tracking (for Screech reactive trigger)
var _player_recent_hits = 0.0
var _player_hit_decay_rate = 2.0

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

# UI
var _bars_container: Node2D
var _rotwood_posture_bg: ColorRect
var _rotwood_posture_fill: ColorRect
var _hp_bg: ColorRect
var _hp_fill: ColorRect

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
	
	spirit_hp = max_spirit_hp
	hp = spirit_hp
	_max_hp = max_spirit_hp
	
	movement_speed = base_movement_speed
	beast_move_speed = base_movement_speed
	
	_phase = Phase.ALIVE
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_pending_melee_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	
	_spirit_phase_active = false
	_spirit_entity = null
	_spirit_chase_timer = 0.0
	_deathblow_cycle_count = 0
	
	_attack_sequence_id = 0
	_attack_cooldown = 0.0
	_approach_timer = 0.0
	_approach_current_speed = 0.0
	
	_combo_interrupted = false
	_combo_is_frozen = false
	_combo_should_continue = true
	
	_rng.randomize()
	
	add_to_group("miniboss")
	add_to_group("rotwood_host")
	
	if combat and not combat.config:
		combat.config = CombatConfig.create_boss_config()
	
	_setup_bars()
	
	if combat:
		if combat.has_method("update_health_ratio"):
			combat.update_health_ratio(float(spirit_hp), float(max_spirit_hp))
		
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
	
	if _beast_tick_shared(delta):
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
	
	if _bars_container:
		_bars_container.global_position = global_position
	
	_update_bars()
	
	var now = Time.get_ticks_msec() * 0.001
	
	if combat:
		combat.update_health_ratio(float(spirit_hp), float(max_spirit_hp))
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

	# Spirit chase phase — shell is inert
	if _spirit_phase_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	_attack_cooldown = max(_attack_cooldown - delta, 0.0)

	# Player hit decay (for Screech)
	_player_recent_hits = max(0.0, _player_recent_hits - _player_hit_decay_rate * delta)

	# AI STATE MACHINE
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
		BehaviorState.SPIRIT_CHASE:
			pass

	_apply_soft_separation()
	_update_shell_degradation_visual()
	move_and_slide()
	
# =============================================================================
# DEGRADATION SYSTEM — Everything scales off spirit HP ratio
# =============================================================================
func _get_spirit_ratio() -> float:
	## 1.0 = full strength, 0.0 = dead
	if max_spirit_hp <= 0:
		return 0.0
	return clamp(float(spirit_hp) / float(max_spirit_hp), 0.0, 1.0)

func _get_speed_mult() -> float:
	## Shell gets slower as spirit weakens
	var ratio = _get_spirit_ratio()
	return lerp(0.6, 1.0, ratio)

func _get_attack_speed_mult() -> float:
	## Telegraphs get longer (easier) as spirit weakens
	## Returns > 1.0 when weak = longer windups
	var ratio = _get_spirit_ratio()
	return lerp(1.4, 1.0, ratio)

func _get_claw_count() -> int:
	var ratio = _get_spirit_ratio()
	if ratio > 0.65:
		return 3
	elif ratio > 0.30:
		return 2
	return 1

func _has_bite_feint() -> bool:
	return _get_spirit_ratio() > 0.50

func _has_slam_followup() -> bool:
	return _get_spirit_ratio() > 0.40

func _pounce_deals_damage() -> bool:
	return _get_spirit_ratio() > 0.55
	
func _process_idle_state(player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	velocity = Vector2.ZERO
	_face_direction(dir)
	_play_idle()

	if dist > mid_range + 50.0:
		_transition_to_pursuing()
		return

	if _attack_cooldown <= 0.0:
		# Reactive screech check
		if _should_screech(dist):
			_start_attack(AttackType.SCREECH)
			return

		var attack = _choose_attack(dist)
		if attack == AttackType.NONE:
			return

		if dist > close_range and attack in [AttackType.CLAW_FLURRY, AttackType.LUNGING_BITE, AttackType.TAIL_LASH, AttackType.RISING_SLAM]:
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

func _start_attack(attack: AttackType) -> void:
	_behavior_state = BehaviorState.ATTACKING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1

	match attack:
		AttackType.CLAW_FLURRY:
			_do_claw_flurry()
		AttackType.LUNGING_BITE:
			_do_lunging_bite()
		AttackType.TAIL_LASH:
			_do_tail_lash()
		AttackType.RISING_SLAM:
			_do_rising_slam()
		AttackType.SCREECH:
			_do_screech()
		AttackType.POUNCE:
			_do_pounce()

func _finish_attack() -> void:
	var cd_min = min_attack_cooldown
	var cd_max = max_attack_cooldown

	# Beast is aggressive — shorter cooldowns after melee
	if _current_attack in [AttackType.CLAW_FLURRY, AttackType.LUNGING_BITE, AttackType.TAIL_LASH]:
		cd_min *= 0.6
		cd_max *= 0.75

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

func _choose_attack(dist: float) -> AttackType:
	var weights = {}
	var is_too_close = dist < too_close_threshold
	var ratio = _get_spirit_ratio()

	# --- CLAW FLURRY (bread and butter) ---
	var claw_w = 0.45
	if is_too_close:
		claw_w *= 0.6
	if dist > close_range * 1.5:
		claw_w = 0.0
	weights[AttackType.CLAW_FLURRY] = claw_w

	# --- LUNGING BITE (gap closer + parry test) ---
	var bite_w = 0.15
	if dist > close_range * 0.8 and dist <= mid_range:
		bite_w *= 2.0  # Best at mid range
	elif dist <= close_range * 0.5:
		bite_w *= 0.3  # Too close for lunge
	if dist > mid_range:
		bite_w = 0.0
	weights[AttackType.LUNGING_BITE] = bite_w

	# --- TAIL LASH (perilous, rear punish) ---
	var tail_w = 0.15
	if is_too_close:
		tail_w *= 1.5  # Good when face-hugging
	if dist > close_range * 1.3:
		tail_w = 0.0
	weights[AttackType.TAIL_LASH] = tail_w

	# --- RISING SLAM (unblockable) ---
	var slam_w = 0.10
	if ratio < 0.30:
		slam_w *= 0.4  # Weak shell rarely slams
	if dist > close_range * 1.5:
		slam_w = 0.0
	weights[AttackType.RISING_SLAM] = slam_w

	# --- POUNCE (gap closer, mid-far range only) ---
	var pounce_w = 0.0
	if dist >= pounce_min_range and dist <= far_range:
		pounce_w = 0.20
		if ratio < 0.30:
			pounce_w *= 0.5  # Weak shell pounces less
	weights[AttackType.POUNCE] = pounce_w

	# Weighted random selection
	var total = 0.0
	for w in weights.values():
		total += w

	if total <= 0.0:
		return AttackType.CLAW_FLURRY

	var pick = _rng.randf() * total
	var acc = 0.0
	for atk in weights:
		acc += weights[atk]
		if pick <= acc and weights[atk] > 0.0:
			return atk

	return AttackType.CLAW_FLURRY

func _should_screech(dist: float) -> bool:
	if dist > screech_radius + 15.0:
		return false
	if _get_spirit_ratio() < 0.25:
		return false  # Weak shell can't push back
	return _player_recent_hits >= screech_player_hit_threshold

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
		hitbox.set_meta("damage_type", "rotwood_claw")
		hitbox.set_meta("parryable", true)
		hitbox.set_meta("unblockable", false)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(claw_range, claw_width)
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (claw_range * 0.5)
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
		area.set_meta("damage_type", "rotwood_slam")
		area.set_meta("parryable", true)
		area.set_meta("unblockable", false)

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius if radius > 0.0 else slam_radius
	cs.shape = shape
	area.add_child(cs)
	area.global_position = center
	get_parent().add_child(area)
	return area
	
func _cleanup_hitbox() -> void:
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
		_current_hitbox.queue_free()
	
	_current_hitbox = null
	_is_current_hitbox_melee = false
	
func _should_abort_attack(sequence_id: int) -> bool:
	if _phase == Phase.DEAD:
		return true
	if _dbroken_active:
		return true
	if _spirit_phase_active:
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

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _phase == Phase.DEAD:
		return
	if _spirit_phase_active:
		return  # Shell is inert during spirit chase
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

	_player_recent_hits += 1.0

	var guarding = _is_guarding()

	# --- GUARDING: posture chip only ---
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

	# --- NOT GUARDING: posture damage only (shell has no HP) ---
	var posture_mult = unguarded_posture_mult

	# Windup armor reduces posture gain
	if _is_in_windup():
		posture_mult *= windup_posture_mult
		_flash_windup_hit()

	if combat:
		var posture_event = {"damage": 0, "blocked": false}
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

	# Visual feedback only — no HP damage to shell
	hitstop_local(0.005)
	_flash_hurt_sprite()
	
func on_parried(parry_source_pos: Vector2) -> void:
	if _dbroken_active or _phase == Phase.DEAD:
		return

	_hide_parry_indicator()

	var local_attack = _current_attack

	# Posture damage from parry
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

	# Claw flurry: combo parry (hitstop only, no knockback)
	if local_attack == AttackType.CLAW_FLURRY:
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

	# Single attacks: full knockback
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
	if local_attack == AttackType.LUNGING_BITE:
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
		AttackType.LUNGING_BITE:
			recoil_time = 0.22
			recoil_speed = 130.0
			max_recoil = 45.0
		AttackType.TAIL_LASH:
			recoil_time = 0.16
			recoil_speed = 90.0
			max_recoil = 30.0

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

	# Reset posture for next cycle
	if combat and combat.config:
		combat.set_posture(0.0)

	_clear_deathblow_state()
	_deathblow_cycle_count += 1

	# Deathblow visual
	if anim and anim.has_animation("deathblow"):
		anim.play("deathblow")
	elif anim and anim.has_animation("hurt"):
		anim.play("hurt")

	var original_mod = sprite.modulate if sprite else Color.WHITE
	if sprite:
		sprite.modulate = Color(0.6, 0.8, 1.0)
	await get_tree().create_timer(0.3).timeout
	if not is_instance_valid(self):
		return
	if sprite:
		sprite.modulate = original_mod

	# Eject spirit — enter chase phase
	_deathblow_in_progress = false
	emit_signal("posture_recovered")
	_begin_spirit_chase()

func on_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func receive_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)
	
func is_deathblow_ready() -> bool:
	return _dbroken_active

func _apply_damage(damage: int, _damage_type: String, _attacker: Node) -> void:
	# Shell has no HP to damage — this only exists for prosthetic/stance compatibility
	# Actual progress is through spirit HP during chase phase
	if _phase == Phase.DEAD:
		return
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
	_spirit_phase_active = false
	velocity = Vector2.ZERO
	_attack_sequence_id += 1
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if _bars_container:
		_bars_container.visible = false
	
	_cleanup_hitbox()
	_reset_beast_runtime()
	
	if is_instance_valid(_spirit_entity):
		if _spirit_entity.is_in_group("enemy"):
			_spirit_entity.remove_from_group("enemy")
		_spirit_entity.queue_free()
		_spirit_entity = null
	
	if is_in_group("miniboss"):
		remove_from_group("miniboss")
	
	if is_in_group("rotwood_host"):
		remove_from_group("rotwood_host")
	
	emit_signal("defeated")
	emit_signal("enemy_died", self)
	
	notify_stance_effects_enemy_death()
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

func _setup_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsUI"
	_bars_container.z_index = 100
	add_child(_bars_container)

	# Posture bar
	_rotwood_posture_bg = ColorRect.new()
	_rotwood_posture_bg.size = Vector2(54, 6)
	_rotwood_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	_rotwood_posture_bg.position = Vector2(-27, -55)
	_bars_container.add_child(_rotwood_posture_bg)

	_rotwood_posture_fill = ColorRect.new()
	_rotwood_posture_fill.size = Vector2(0, 6)
	_rotwood_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	_rotwood_posture_fill.position = Vector2.ZERO
	_rotwood_posture_bg.add_child(_rotwood_posture_fill)

	var posture_border = ColorRect.new()
	posture_border.size = Vector2(56, 8)
	posture_border.color = Color(0.3, 0.25, 0.1, 0.9)
	posture_border.position = Vector2(-28, -56)
	posture_border.z_index = -1
	_bars_container.add_child(posture_border)

	# Spirit HP bar (the real health bar)
	_hp_bg = ColorRect.new()
	_hp_bg.size = Vector2(54, 5)
	_hp_bg.color = Color(0.02, 0.08, 0.15, 0.8)
	_hp_bg.position = Vector2(-27, -46)
	_bars_container.add_child(_hp_bg)
	_hp_fill = ColorRect.new()
	_hp_fill.size = Vector2(54, 5)
	_hp_fill.color = Color(0.3, 0.6, 0.9, 0.95)
	_hp_fill.position = Vector2.ZERO
	_hp_bg.add_child(_hp_fill)

	var hp_border = ColorRect.new()
	hp_border.size = Vector2(56, 7)
	hp_border.color = Color(0.08, 0.12, 0.25, 0.9)
	hp_border.position = Vector2(-28, -47)
	hp_border.z_index = -1
	_bars_container.add_child(hp_border)

	_bars_container.visible = true

func _update_bars() -> void:
	# Spirit HP bar
	if _hp_fill:
		var hp_pct = clamp(float(spirit_hp) / float(max_spirit_hp), 0.0, 1.0)
		_hp_fill.size.x = 54.0 * hp_pct
		if hp_pct >= 0.5:
			_hp_fill.color = Color(0.3, 0.6, 0.9, 0.95)
		elif hp_pct >= 0.25:
			_hp_fill.color = Color(0.5, 0.5, 0.8, 0.95)
		else:
			var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.008)
			_hp_fill.color = Color(0.6, 0.3 * flash, 0.8, 0.95)

func _update_shell_degradation_visual() -> void:
	if not sprite or _phase == Phase.DEAD or _dbroken_active:
		return
	# Shell gets darker/more transparent as spirit weakens
	var ratio = _get_spirit_ratio()
	var base = Color(1.0, 1.0, 1.0)
	var weak = Color(0.5, 0.5, 0.6)
	sprite.modulate = base.lerp(weak, 1.0 - ratio)

# =============================================================================
# ATTACK: CLAW FLURRY
# =============================================================================
func _do_claw_flurry() -> void:
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

	if anim and anim.has_animation("claw_antic"):
		anim.play("claw_antic")
	if not await _wait_duration_interruptible(claw_initial_windup * _get_attack_speed_mult(), my_seq):
		return

	var hit_count = _get_claw_count()

	for i in range(hit_count):
		_combo_hit_index = i + 1
		var telegraph = claw_telegraph * _get_attack_speed_mult()
		var recovery = claw_recovery * _get_attack_speed_mult()

		# Hit 3 rhythm-breaker: extra delay before the telegraph
		if i == 2:
			if not await _wait_duration_interruptible(claw_hit3_delay * _get_attack_speed_mult(), my_seq):
				return

		if not await _execute_rotwood_combo_hit(
			my_seq, telegraph, claw_active, recovery,
			claw_lunge_distance, claw_lunge_speed, claw_damage,
			false, false
		):
			return

		if i < hit_count - 1 and claw_inter_hit_gap > 0.0:
			if not await _wait_duration_interruptible(claw_inter_hit_gap, my_seq):
				return

	_set_combat_phase(CombatPhase.NONE)
	_combo_interrupted = false
	_combo_hit_index = 0
	_finish_attack()


# =============================================================================
# ATTACK: LUNGING BITE
# =============================================================================
func _do_lunging_bite() -> void:
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

	var telegraph = bite_telegraph * _get_attack_speed_mult()
	var total_duration = telegraph + parry_early_window + bite_active + parry_linger_window
	_show_parry_indicator(total_duration, false)

	if anim and anim.has_animation("bite_antic"):
		anim.play("bite_antic")

	# Feint: short forward jerk then pause
	if _has_bite_feint():
		velocity = dir * bite_lunge_speed * 0.3
		await get_tree().create_timer(0.08).timeout
		if not is_instance_valid(self):
			return
		velocity = Vector2.ZERO
		if _should_abort_attack(my_seq):
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		if not await _wait_duration_interruptible(bite_feint_duration * _get_attack_speed_mult(), my_seq):
			return
		# Re-aim after feint
		if player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT
			_face_direction(dir)
	else:
		if not await _wait_duration_interruptible(telegraph, my_seq):
			return

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_bite_hitbox(dir, bite_damage)
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("bite_active"):
		anim.play("bite_active")

	# Lunge forward during active frames
	var lunge_elapsed = 0.0
	var lunge_time = bite_lunge_distance / bite_lunge_speed if bite_lunge_speed > 0 else 0.0
	while lunge_elapsed < lunge_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		velocity = dir * bite_lunge_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		lunge_elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if not await _wait_duration_interruptible(bite_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(bite_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: TAIL LASH (perilous — parry-only)
# =============================================================================
func _do_tail_lash() -> void:
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

	var telegraph = tail_telegraph * _get_attack_speed_mult()
	var total_duration = telegraph + parry_early_window + tail_active + parry_linger_window
	_show_parry_indicator(total_duration, false)

	if anim and anim.has_animation("tail_antic"):
		anim.play("tail_antic")

	if not await _wait_duration_interruptible(telegraph, my_seq):
		return

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	# Wide arc behind/around the rotwood
	_current_hitbox = _spawn_tail_hitbox(dir)
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("tail_active"):
		anim.play("tail_active")

	if not await _wait_duration_interruptible(parry_early_window, my_seq):
		return
	if not await _wait_duration_interruptible(tail_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(tail_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: RISING SLAM (unblockable — dodge-only, with followup claw)
# =============================================================================
func _do_rising_slam() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	if player:
		_face_direction((player.global_position - global_position).normalized())

	var windup_time = slam_windup * _get_attack_speed_mult()
	var total_duration = windup_time + parry_linger_window
	_show_parry_indicator(total_duration, true)

	if anim and anim.has_animation("slam_windup"):
		anim.play("slam_windup")

	if not await _wait_duration_interruptible(windup_time - slam_parry_preframe, my_seq):
		return

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_slam_hitbox(global_position, slam_damage, true, slam_radius)
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("slam_impact"):
		anim.play("slam_impact")

	if not await _wait_duration_interruptible(slam_parry_preframe, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	# Follow-up claw if degradation allows it
	if _has_slam_followup() and not _should_abort_attack(my_seq):
		if player and is_instance_valid(player):
			var dir = (player.global_position - global_position).normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT
			_face_direction(dir)

			if not await _execute_rotwood_combo_hit(
				my_seq, slam_followup_telegraph, claw_active, claw_recovery * 0.8,
				claw_lunge_distance * 0.5, claw_lunge_speed, slam_followup_damage,
				false, false
			):
				return
	else:
		_set_combat_phase(CombatPhase.RECOVERY)
		await get_tree().create_timer(slam_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: SCREECH (reactive push-back)
# =============================================================================
func _do_screech() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	if anim and anim.has_animation("screech_antic"):
		anim.play("screech_antic")

	if not await _wait_duration_interruptible(screech_telegraph * _get_attack_speed_mult(), my_seq):
		return

	if _should_abort_attack(my_seq):
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	_set_combat_phase(CombatPhase.ACTIVE)

	# Push player back + posture damage
	var player = _get_player()
	if player and is_instance_valid(player):
		var dist = (player.global_position - global_position).length()
		if dist <= screech_radius:
			var push_dir = (player.global_position - global_position).normalized()
			if push_dir == Vector2.ZERO:
				push_dir = Vector2.RIGHT
			if "knockback" in player:
				player.knockback = push_dir * screech_knockback_force
			var pc = player.get_node_or_null("Combat")
			if pc and pc.has_method("add_posture"):
				pc.add_posture(screech_posture_damage_to_player)

	if anim and anim.has_animation("screech_active"):
		anim.play("screech_active")

	# Reset player aggression counter
	_player_recent_hits = 0.0

	if not await _wait_duration_interruptible(0.15, my_seq):
		return

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(screech_recovery * _get_attack_speed_mult()).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()


# =============================================================================
# ATTACK: POUNCE (gap closer)
# =============================================================================
func _do_pounce() -> void:
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

	var deals_damage = _pounce_deals_damage()
	if deals_damage:
		_show_parry_indicator(pounce_duration + pounce_recovery, true)

	if anim and anim.has_animation("pounce_antic"):
		anim.play("pounce_antic")

	if not await _wait_duration_interruptible(0.25 * _get_attack_speed_mult(), my_seq):
		return

	# Re-aim at player before launching
	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

	_set_combat_phase(CombatPhase.ACTIVE)

	# Spawn landing AOE hitbox if strong enough
	if deals_damage:
		_current_hitbox = _spawn_slam_hitbox(global_position, pounce_damage, true, pounce_landing_radius)
		_is_current_hitbox_melee = true

	# Fly toward player
	var pounce_elapsed = 0.0
	while pounce_elapsed < pounce_duration:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		velocity = dir * pounce_speed
		# Move hitbox with us
		if is_instance_valid(_current_hitbox):
			_current_hitbox.global_position = global_position
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		pounce_elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if not await _wait_duration_interruptible(0.1, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)

	# Weak shell stumbles on landing — free punish window
	var recovery = pounce_recovery * _get_attack_speed_mult()
	if _get_spirit_ratio() < 0.40:
		recovery *= 2.0  # Stumble

	await get_tree().create_timer(recovery).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

# =============================================================================
# GENERIC COMBO HIT HELPER
# =============================================================================
func _execute_rotwood_combo_hit(
	seq_id: int,
	anticipation_time: float,
	active_time: float,
	recovery_time: float,
	lunge_distance: float,
	lunge_speed: float,
	damage: int,
	is_parry_only: bool,
	is_unblockable: bool
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

	if anim and anim.has_animation("claw_antic"):
		anim.play("claw_antic")

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
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("claw_active"):
		anim.play("claw_active")

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
# HITBOX SPAWNERS — Bite and Tail
# =============================================================================
func _spawn_bite_hitbox(dir: Vector2, damage: int) -> Area2D:
	var hitbox = Area2D.new()
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "rotwood_bite")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", true)
	hitbox.set_meta("unblockable", false)
	hitbox.set_meta("telegraphed", true)

	var shape = RectangleShape2D.new()
	shape.size = Vector2(bite_range, bite_width)
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = dir.normalized() * (bite_range * 0.5)
	hitbox.rotation = dir.angle()
	return hitbox

func _spawn_tail_hitbox(dir: Vector2) -> Area2D:
	var hitbox = Area2D.new()
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", tail_damage)
	hitbox.set_meta("damage_type", "perilous")
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("parryable", true)
	hitbox.set_meta("unblockable", false)
	hitbox.set_meta("telegraphed", true)

	# Wide arc — covers behind and sides
	var shape = CircleShape2D.new()
	shape.radius = tail_range
	var col = CollisionShape2D.new()
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)
	hitbox.position = Vector2.ZERO
	return hitbox

# =============================================================================
# SPIRIT CHASE PHASE
# =============================================================================
func _begin_spirit_chase() -> void:
	_spirit_phase_active = true
	_behavior_state = BehaviorState.SPIRIT_CHASE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO

	# Shell collapses
	if anim and anim.has_animation("collapse"):
		anim.play("collapse")
	elif anim and anim.has_animation("stunned"):
		anim.play("stunned")

	# Dim the shell visually
	if sprite:
		sprite.modulate = Color(0.3, 0.3, 0.35, 0.7)

	# Spawn spirit entity
	_spirit_entity = _create_spirit_entity()
	_spirit_entity.global_position = global_position
	get_parent().add_child(_spirit_entity)

	# Start chase coroutine
	_run_spirit_chase()

func _create_spirit_entity() -> CharacterBody2D:
	var spirit = CharacterBody2D.new()
	spirit.name = "RotwoodSpirit"
	spirit.collision_layer = 0
	spirit.collision_mask = 0

	# HurtBox so player can hit it
	var hb = Area2D.new()
	hb.name = "SpiritHurtBox"
	hb.collision_layer = 4  # Enemy layer
	hb.collision_mask = 2   # Player attack layer
	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 14.0
	cs.shape = shape
	hb.add_child(cs)
	spirit.add_child(hb)

	# Add to enemy group so player attacks detect it
	spirit.add_to_group("enemy")

	# Visual — ghostly orb
	var visual = ColorRect.new()
	visual.size = Vector2(20, 20)
	visual.position = Vector2(-10, -10)
	visual.color = Color(0.4, 0.6, 1.0, 0.7)
	spirit.add_child(visual)

	# Connect hurt signal
	if hb.has_signal("hurt"):
		hb.connect("hurt", Callable(self, "_on_spirit_hurt"))

	# Also connect area_entered for player attack areas
	hb.area_entered.connect(func(area: Area2D) -> void:
		if area.is_in_group("attack"):
			var attacker_node = area.get_meta("attacker", null)
			if attacker_node and attacker_node is Node and attacker_node.is_in_group("player"):
				_on_spirit_hit_by_attack(area)
	)

	return spirit

func _run_spirit_chase() -> void:
	var chase_elapsed = 0.0
	var player = _get_player()

	# Generate dash points around the arena
	var dash_interval = spirit_pause_at_point + 0.3  # pause + dash time
	var center = global_position  # Shell position as arena center

	while chase_elapsed < spirit_chase_duration:
		if _phase == Phase.DEAD or spirit_hp <= spirit_death_threshold:
			break
		if not is_instance_valid(_spirit_entity):
			break

		# Pick a random point near the arena
		var angle = _rng.randf() * TAU
		var dist = _rng.randf_range(60.0, 140.0)
		var target_pos = center + Vector2(cos(angle), sin(angle)) * dist

		# Dash to target
		var dash_dir = (target_pos - _spirit_entity.global_position).normalized()
		var dash_dist = _spirit_entity.global_position.distance_to(target_pos)
		var dash_time = dash_dist / spirit_dash_speed
		var dash_elapsed = 0.0

		var trail_interval = 0.25
		var next_trail_time = trail_interval
		while dash_elapsed < dash_time:
			if _phase == Phase.DEAD or not is_instance_valid(_spirit_entity):
				break
			_spirit_entity.velocity = dash_dir * spirit_dash_speed
			_spirit_entity.move_and_slide()

			# Spawn trail at fixed intervals
			if dash_elapsed >= next_trail_time:
				_spawn_spirit_trail(_spirit_entity.global_position)
				next_trail_time += trail_interval

			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			dash_elapsed += get_physics_process_delta_time()
			chase_elapsed += get_physics_process_delta_time()

		if not is_instance_valid(_spirit_entity):
			break
		_spirit_entity.velocity = Vector2.ZERO

		# Pause at landing point
		var pause_elapsed = 0.0
		while pause_elapsed < spirit_pause_at_point:
			if _phase == Phase.DEAD or not is_instance_valid(_spirit_entity):
				break
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			pause_elapsed += get_physics_process_delta_time()
			chase_elapsed += get_physics_process_delta_time()

	# Spirit returns to shell
	_end_spirit_chase()

func _end_spirit_chase() -> void:
	if is_instance_valid(_spirit_entity):
		if _spirit_entity.is_in_group("enemy"):
			_spirit_entity.remove_from_group("enemy")
		_spirit_entity.queue_free()
		_spirit_entity = null

	_spirit_phase_active = false

	# Check if spirit is dead
	if spirit_hp <= spirit_death_threshold:
		_die()
		return

	# Shell reforms — sync hp for health_ratio
	hp = spirit_hp

	# Restore shell visual
	_update_shell_degradation_visual()

	if anim and anim.has_animation("reform"):
		anim.play("reform")
	elif anim and anim.has_animation("idle"):
		anim.play("idle")

	# Brief stun after reforming
	var now = Time.get_ticks_msec() * 0.001
	_stun_until = now + 0.8
	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = _rng.randf_range(min_attack_cooldown, max_attack_cooldown)

func _on_spirit_hurt(damage: int, _damage_type: String, attacker: Node) -> void:
	_deal_spirit_damage(attacker)

func _on_spirit_hit_by_attack(attack_area: Area2D) -> void:
	# Dedup via swing token
	var token = attack_area.get_meta("swing_token", -1)
	if _spirit_entity and _spirit_entity.has_meta("_last_hit_token"):
		if _spirit_entity.get_meta("_last_hit_token") == token:
			return
	if _spirit_entity:
		_spirit_entity.set_meta("_last_hit_token", token)

	var attacker = attack_area.get_meta("attacker", null)
	_deal_spirit_damage(attacker)

func _deal_spirit_damage(attacker: Node) -> void:
	spirit_hp = max(spirit_hp - spirit_hit_damage, 0)
	hp = spirit_hp  # Keep in sync

	_update_bars()

	# Show damage number
	if DamageNumberManager and is_instance_valid(_spirit_entity):
		DamageNumberManager.show_damage_number(
			spirit_hit_damage,
			_spirit_entity.global_position + Vector2(_rng.randf_range(-10, 10), _rng.randf_range(-25, -15)),
			"spirit",
			_spirit_entity
		)

	# Brief stagger feedback
	if is_instance_valid(_spirit_entity):
		_spirit_entity.velocity = Vector2.ZERO
		var visual = _spirit_entity.get_child(_spirit_entity.get_child_count() - 1)
		if visual is ColorRect:
			var orig_color = visual.color
			visual.color = Color(1.0, 1.0, 1.0, 0.9)
			await get_tree().create_timer(spirit_hit_stagger).timeout
			if is_instance_valid(visual):
				visual.color = orig_color

	# Check death
	if spirit_hp <= spirit_death_threshold:
		_end_spirit_chase()

func _spawn_spirit_trail(pos: Vector2) -> void:
	var trail = Area2D.new()
	trail.collision_layer = 2
	trail.collision_mask = 4
	trail.global_position = pos

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = spirit_trail_radius
	cs.shape = shape
	trail.add_child(cs)

	var visual = Polygon2D.new()
	var pts = PackedVector2Array()
	var seg = 10
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * spirit_trail_radius)
	visual.polygon = pts
	visual.color = Color(0.4, 0.5, 0.9, 0.2)
	visual.z_index = -1
	trail.add_child(visual)

	get_parent().add_child(trail)

	# Damage player on contact
	trail.body_entered.connect(func(body: Node) -> void:
		if body.is_in_group("player") and "hp" in body:
			body.hp -= int(spirit_trail_damage)
			if body.has_method("_update_health_bar"):
				body._update_health_bar()
	)

	# Fade and cleanup
	get_tree().create_timer(spirit_trail_duration).timeout.connect(func():
		if is_instance_valid(trail):
			var tw = get_tree().create_tween()
			tw.tween_property(visual, "color:a", 0.0, 0.3)
			tw.tween_callback(func():
				if is_instance_valid(trail):
					trail.queue_free()
			)
	)
	
func _update_posture_bar(cur: float, maxv: float) -> void:
	if not _rotwood_posture_fill or not _rotwood_posture_bg:
		return
	
	var pct = clamp(cur / max(0.001, maxv), 0.0, 1.0)
	_rotwood_posture_fill.size.x = 54.0 * pct
	
	var hp_ratio = clamp(float(spirit_hp) / float(max_spirit_hp), 0.0, 1.0)
	
	if hp_ratio >= 0.75:
		_rotwood_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	elif hp_ratio >= 0.50:
		_rotwood_posture_fill.color = Color(1.0, 0.6, 0.1, 0.95)
	elif hp_ratio >= 0.25:
		_rotwood_posture_fill.color = Color(1.0, 0.4, 0.1, 0.95)
	else:
		var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.01)
		_rotwood_posture_fill.color = Color(1.0, 0.25 * flash, 0.1, 0.95)
	
	if pct >= 0.85:
		var break_flash = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.015)
		_rotwood_posture_fill.color.a = break_flash

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

func _update_sprite_facing() -> void:
	var player = _get_player()
	if player and sprite:
		sprite.flip_h = player.global_position.x > global_position.x

func _is_guarding() -> bool:
	if _phase == Phase.DEAD:
		return false
	if _dbroken_active:
		return false
	if _spirit_phase_active:
		return false
	if _combat_phase != CombatPhase.NONE:
		return false
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

func get_enemy_damage() -> int:
	return claw_damage

func get_enemy_tags() -> Array:
	return ["beast", "rotwood"]
