extends BeastEnemyBase
class_name Rootfang

# =============================================================================
# ENUMS
# =============================================================================
enum Phase { ALIVE, DEAD }
enum BehaviorState { IDLE, PURSUING, APPROACHING, ATTACKING, ROOTED, RECOVERING }
enum AttackType { NONE, CLAW_COMBO, LUNGE, HEAVY_SLAM, EMPOWERED_BEAM }
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

# =============================================================================
# ROLE & MANAGER
# =============================================================================
@export var manager_path: NodePath = ""
var _manager: DuoBossManager = null

# =============================================================================
# HP & ROOTFANG THRESHOLDS
# =============================================================================
@export_group("HP & Rootfang")
@export var rootfang_max_hp: int = 160
## Stumble time before rootfang closes
@export var rootfang_entry_stumble = 0.35

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage = 22.0
@export var deathblow_window_duration = 3.0
@export var deathblow_immunity_time = 0.3
@export var unguarded_posture_mult = 0.3

# =============================================================================
# WINDUP ARMOR
# =============================================================================
@export_group("Windup Armor")
@export var windup_posture_mult = 0.5
@export var windup_hit_flash_color = Color(0.8, 0.9, 1.0, 1.0)

# =============================================================================
# PARRY TIMING
# =============================================================================
@export_group("Parry Timing")
@export var parry_early_window = 0.12
@export var parry_linger_window = 0.20

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
@export var base_movement_speed = 55.0
@export var approach_speed = 140.0
@export var approach_acceleration = 40.0
@export var approach_max_speed = 190.0
@export var approach_commitment_time = 3.0

@export_group("Empowered Beam (inherited)")
@export var emp_beam_length = 220.0
@export var emp_beam_width = 24.0
@export var emp_beam_telegraph = 0.45
@export var emp_beam_damage = 11
@export var emp_beam_aim_track_pct = 0.55

# =============================================================================
# CLAW COMBO
# =============================================================================
@export_group("Claw Combo")
@export var claw_damage = 10
@export var claw_range = 60.0
@export var claw_width = 50.0
@export var claw_telegraph = 0.32
@export var claw_active = 0.12
@export var claw_recovery = 0.30
@export var claw_lunge_distance = 30.0
@export var claw_rootfang_lunge_speed = 420.0
@export var claw_inter_hit_gap = 0.10
@export var claw_initial_windup = 0.28

# =============================================================================
# LUNGE ATTACK
# =============================================================================
@export_group("Lunge Attack")
@export var lunge_damage = 14
@export var lunge_range = 65.0
@export var lunge_width = 40.0
@export var lunge_telegraph = 0.50
@export var lunge_active = 0.14
@export var rootfang_lunge_recovery = 0.45
@export var lunge_distance = 70.0
@export var rootfang_lunge_speed = 500.0

# =============================================================================
# HEAVY SLAM (unblockable — dodge-only)
# =============================================================================
@export_group("Heavy Slam")
@export var slam_damage = 16
@export var slam_radius = 55.0
@export var slam_windup = 0.70
@export var slam_recovery = 0.55
@export var slam_parry_preframe = 0.10

# =============================================================================
# RAGE (when partner dies)
# =============================================================================
@export_group("Rage")
@export var rage_duration = 12.0
@export var rage_speed_mult = 0.82

# =============================================================================
# ATTACK PACING
# =============================================================================
@export_group("Attack Pacing")
@export var min_attack_cooldown = 0.8
@export var max_attack_cooldown = 1.5

@export_group("Rootfang Roll")
@export var rootfang_hp_threshold = 0.50
@export var rootfang_roll_count = 3
@export var rootfang_roll_speed = 450.0
@export var rootfang_roll_distance = 280.0
@export var rootfang_roll_damage = 12
@export var rootfang_roll_hitbox_radius = 28.0
@export var rootfang_roll_damage_reduction = 0.65
@export var rootfang_roll_first_windup = 0.55
@export var rootfang_roll_windup = 0.35
@export var rootfang_roll_pause = 1.0

# =============================================================================
# STATE
# =============================================================================
var _phase = Phase.ALIVE
var _behavior_state = BehaviorState.IDLE
var _current_attack = AttackType.NONE
var _pending_melee_attack = AttackType.NONE
var _combat_phase = CombatPhase.NONE

var _rootfang_triggered = false
var _rootfang_deferred = false
var _rootfang_rolling = false
var _is_empowered = false

# Rootfang state
var _is_rootfanged = false

# Combo tracking
var _combo_hit_index = 0
var _combo_interrupted = false
var _combo_is_frozen = false
var _combo_parry_freeze_until = 0.0

# Attack sequencing
var _attack_sequence_id = 0
var _attack_cooldown = 0.0
var _approach_timer = 0.0
var _approach_current_speed = 0.0

# Player aggression tracking
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

# Rage (partner died)
var _rage_until = 0.0
var _partner_alive = true

# Posture break flash
var _posture_break_flash_timer: Timer = null
var _posture_break_flash_on = false
var _base_modulate = Color(1, 1, 1)

# Hitbox tracking
var _current_hitbox: Area2D = null
var _is_current_hitbox_melee = false

# UI
var _bars_container: Node2D
var _rootfang_posture_bg: ColorRect
var _rootfang_posture_fill: ColorRect
var _hp_bg: ColorRect
var _hp_fill: ColorRect

var _rng = RandomNumberGenerator.new()

# =============================================================================
# SIGNALS
# =============================================================================
signal defeated
signal posture_broken(duration: float)
signal posture_recovered

func _ready() -> void:
	super._ready()
	
	hp = rootfang_max_hp
	_max_hp = rootfang_max_hp
	
	movement_speed = base_movement_speed
	beast_move_speed = base_movement_speed
	
	_phase = Phase.ALIVE
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_pending_melee_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	
	_rootfang_triggered = false
	_rootfang_deferred = false
	_rootfang_rolling = false
	_is_rootfanged = false
	_is_empowered = false

	_combo_hit_index = 0
	_combo_interrupted = false
	_combo_is_frozen = false
	
	_attack_sequence_id = 0
	_attack_cooldown = 0.0
	_approach_timer = 0.0
	_approach_current_speed = 0.0
	
	_dbroken_active = false
	_dbreak_until = -1.0
	_deathblow_in_progress = false
	_stun_until = 0.0
	
	_rng.randomize()
	
	add_to_group("boss")
	add_to_group("duo_boss")
	add_to_group("duo_boss_twin")
	add_to_group("rootfang")
	add_to_group("rootfang_duo_twin")
	
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
	
	# Combo hitstop freeze
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

	# Feed own HP ratio into CombatController (drives posture recovery)
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

	# --- ROOTFANG STATE ---
	if _is_rootfanged:
		_process_rootfanged_state(delta)
		move_and_slide()
		return

	# --- RECOVERING (stand-up recovery) ---
	if _behavior_state == BehaviorState.RECOVERING:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	_attack_cooldown = max(_attack_cooldown - delta, 0.0)
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

	_apply_soft_separation()
	move_and_slide()

func _process_rootfanged_state(_delta: float) -> void:
	# Roll coroutine manages velocity directly — nothing to do here
	# move_and_slide() is called by _physics_process after this returns
	pass
	
func _enter_rootfang() -> void:
	if _is_rootfanged:
		return

	_attack_sequence_id += 1
	_combo_interrupted = true
	_cleanup_hitbox()
	_combat_phase = CombatPhase.NONE
	_current_attack = AttackType.NONE
	velocity = Vector2.ZERO

	_is_rootfanged = true
	_rootfang_rolling = false
	_behavior_state = BehaviorState.ROOTED

	if sprite:
		sprite.modulate = Color(0.5, 0.45, 0.4, 0.95)

	if anim and anim.has_animation("rootfang_enter"):
		anim.play("rootfang_enter")

	# Start the roll sequence coroutine
	_do_rootfang_roll_sequence()

func _exit_rootfang() -> void:
	if not _is_rootfanged:
		return

	_is_rootfanged = false
	_rootfang_rolling = false
	_behavior_state = BehaviorState.RECOVERING

	if _manager:
		_manager.notify_rootfang_ended(self)

	if sprite:
		sprite.modulate = Color(1.0, 1.0, 1.0)

	if anim and anim.has_animation("rootfang_exit"):
		anim.play("rootfang_exit")
	elif anim and anim.has_animation("idle"):
		anim.play("idle")

	_do_unrootfang_recovery()

func trigger_deferred_rootfang() -> void:
	## Called by manager when the partner's rootfang ends and we were waiting.
	if not _rootfang_deferred or _is_rootfanged or _phase == Phase.DEAD:
		return
	_rootfang_deferred = false
	_do_rootfang_entry_stumble()

func _do_rootfang_roll_sequence() -> void:
	## Executes 2-3 deliberate roll passes across the arena.
	## Each pass: wind-up aim → high-speed charge → vulnerable pause.
	var roll_count = rootfang_roll_count

	for i in range(roll_count):
		if _phase == Phase.DEAD or _dbroken_active:
			break

		# --- Wind-up: aim toward player ---
		var player = _get_player()
		var dir = Vector2.RIGHT
		if player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

		var windup = rootfang_roll_first_windup if i == 0 else rootfang_roll_windup

		var roll_time = rootfang_roll_distance / rootfang_roll_speed
		_show_parry_indicator(windup + roll_time, true)

		if anim and anim.has_animation("roll_antic"):
			anim.play("roll_antic")
		elif anim and anim.has_animation("claw_antic"):
			anim.play("claw_antic")

		var wu_elapsed = 0.0
		while wu_elapsed < windup:
			if _phase == Phase.DEAD or _dbroken_active:
				_cleanup_hitbox()
				velocity = Vector2.ZERO
				_exit_rootfang()
				return
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			wu_elapsed += get_physics_process_delta_time()
			# Track player during first 80% of windup
			if player and is_instance_valid(player) and wu_elapsed < windup * 0.8:
				dir = (player.global_position - global_position).normalized()
				if dir == Vector2.ZERO:
					dir = Vector2.RIGHT
				_face_direction(dir)

		# Final aim lock
		if player and is_instance_valid(player):
			dir = (player.global_position - global_position).normalized()
			if dir == Vector2.ZERO:
				dir = Vector2.RIGHT
			_face_direction(dir)

		# --- Execute roll charge ---
		_rootfang_rolling = true
		_current_hitbox = _spawn_roll_hitbox()

		if anim and anim.has_animation("roll"):
			anim.play("roll")

		var roll_elapsed = 0.0
		var roll_duration = rootfang_roll_distance / rootfang_roll_speed
		while roll_elapsed < roll_duration:
			if _phase == Phase.DEAD or _dbroken_active:
				_rootfang_rolling = false
				_cleanup_hitbox()
				velocity = Vector2.ZERO
				_exit_rootfang()
				return
			velocity = dir * rootfang_roll_speed
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			roll_elapsed += get_physics_process_delta_time()

		velocity = Vector2.ZERO
		_rootfang_rolling = false
		_cleanup_hitbox()

		# --- Pause between passes (VULNERABLE PUNISH WINDOW) ---
		if i < roll_count - 1:
			if anim and anim.has_animation("roll_recover"):
				anim.play("roll_recover")
			elif anim and anim.has_animation("idle"):
				anim.play("idle")

			var pause_elapsed = 0.0
			while pause_elapsed < rootfang_roll_pause:
				if _phase == Phase.DEAD or _dbroken_active:
					_exit_rootfang()
					return
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
				pause_elapsed += get_physics_process_delta_time()

	# --- All rolls complete ---
	_exit_rootfang()

func _spawn_roll_hitbox() -> Area2D:
	## Circular hitbox centered on the twin — moves with it during rolls.
	var hitbox = Area2D.new()
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	hitbox.set_meta("damage", rootfang_roll_damage)
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("damage_type", "unblockable")
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("unblockable", true)
	hitbox.set_meta("telegraphed", true)

	var col = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = rootfang_roll_hitbox_radius
	col.shape = shape
	hitbox.add_child(col)
	add_child(hitbox)  # Child of twin — follows its position
	return hitbox

func _do_unrootfang_recovery() -> void:
	var recovery_time = 0.8
	var elapsed = 0.0
	while elapsed < recovery_time:
		if _phase == Phase.DEAD or _dbroken_active:
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()

	if _phase == Phase.DEAD:
		return

	# Transition to idle — manager will assign role
	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = _rng.randf_range(min_attack_cooldown, max_attack_cooldown)
	_play_idle()

func _check_rootfang_threshold() -> void:
	if _rootfang_triggered or _is_rootfanged or _phase == Phase.DEAD or _dbroken_active:
		return

	var hp_ratio = float(hp) / float(get_max_hp())
	if hp_ratio > rootfang_hp_threshold:
		return

	_rootfang_triggered = true

	if not _manager:
		_do_rootfang_entry_stumble()
		return

	if _manager.request_rootfang(self):
		_do_rootfang_entry_stumble()
	else:
		# Partner is rootfanging — defer until they finish
		_rootfang_deferred = true

func _do_rootfang_entry_stumble() -> void:
	_attack_sequence_id += 1
	_combo_interrupted = true
	_cleanup_hitbox()
	_combat_phase = CombatPhase.NONE
	_current_attack = AttackType.NONE
	velocity = Vector2.ZERO
	_behavior_state = BehaviorState.IDLE

	if anim and anim.has_animation("stagger"):
		anim.play("stagger")
	elif anim and anim.has_animation("hurt"):
		anim.play("hurt")

	var stumble_elapsed = 0.0
	while stumble_elapsed < rootfang_entry_stumble:
		if _phase == Phase.DEAD or _dbroken_active:
			return
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		stumble_elapsed += get_physics_process_delta_time()

	if _phase == Phase.DEAD or _dbroken_active:
		return

	_enter_rootfang()

func on_partner_died() -> void:
	_partner_alive = false

	# Exit rootfang if currently in it — fight enters final phase
	if _is_rootfanged:
		_rootfang_rolling = false
		_cleanup_hitbox()
		velocity = Vector2.ZERO
		_exit_rootfang()

	# Rage boost
	var now = Time.get_ticks_msec() * 0.001
	_rage_until = now + rage_duration

	# Empowered — gains beam + stat boosts
	_is_empowered = true

	# Stat boosts: ~20% faster attacks, ~15% more damage, tighter cooldowns
	claw_telegraph *= 0.80
	claw_recovery *= 0.80
	lunge_telegraph *= 0.80
	rootfang_lunge_recovery *= 0.80
	slam_windup *= 0.85
	slam_recovery *= 0.80
	claw_damage = int(claw_damage * 1.15)
	lunge_damage = int(lunge_damage * 1.15)
	slam_damage = int(slam_damage * 1.15)
	min_attack_cooldown *= 0.70
	max_attack_cooldown *= 0.70
	approach_speed *= 1.15

	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = 0.0
	
func _is_enraged() -> bool:
	return Time.get_ticks_msec() * 0.001 < _rage_until

func get_enemy_damage() -> int:
	return claw_damage

func get_enemy_tags() -> Array:
	return ["beast", "rootfang", "duo_boss"]

func is_dead() -> bool:
	return _phase == Phase.DEAD

func set_manager(mgr: DuoBossManager) -> void:
	_manager = mgr

func _process_idle_state(player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	velocity = Vector2.ZERO
	_face_direction(dir)
	_play_idle()

	if dist > mid_range + 50.0:
		_behavior_state = BehaviorState.PURSUING
		return

	if _attack_cooldown <= 0.0:
		var attack = _choose_attack(dist)
		if attack == AttackType.NONE:
			return

		if attack == AttackType.EMPOWERED_BEAM:
			_start_attack(attack)
		elif dist > close_range and attack in [AttackType.CLAW_COMBO, AttackType.LUNGE, AttackType.HEAVY_SLAM]:
			_pending_melee_attack = attack
			_behavior_state = BehaviorState.APPROACHING
			_approach_timer = approach_commitment_time
			_approach_current_speed = approach_speed
		else:
			_start_attack(attack)

func _process_pursuing_state(_player: Node2D, dist: float, dir: Vector2, _delta: float) -> void:
	if dist <= mid_range:
		_behavior_state = BehaviorState.IDLE
		return
	velocity = dir * base_movement_speed
	_face_direction(dir)
	_play_walk()

func _process_approaching_state(player: Node2D, dist: float, dir: Vector2, delta: float) -> void:
	_approach_timer -= delta
	_approach_current_speed = min(_approach_current_speed + approach_acceleration * delta, approach_max_speed)
	velocity = dir * _approach_current_speed
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
			_pending_melee_attack = AttackType.NONE
			_behavior_state = BehaviorState.IDLE

func _choose_attack(dist: float) -> AttackType:
	var weights = {}
	var is_too_close = dist < too_close_threshold
	var is_enraged = _is_enraged()

	# --- CLAW COMBO ---
	var claw_w = 0.45
	if is_too_close:
		claw_w *= 0.6
	if dist > close_range * 1.5:
		claw_w = 0.0
	if is_enraged:
		claw_w *= 1.3
	weights[AttackType.CLAW_COMBO] = claw_w

	# --- LUNGE ---
	var lunge_w = 0.15
	if dist > close_range * 0.8 and dist <= mid_range:
		lunge_w *= 2.0
	elif dist <= close_range * 0.5:
		lunge_w *= 0.3
	if dist > mid_range:
		lunge_w = 0.0
	if is_enraged:
		lunge_w *= 1.2
	weights[AttackType.LUNGE] = lunge_w

	# --- HEAVY SLAM ---
	var slam_w = 0.10
	if dist > close_range * 1.5:
		slam_w = 0.0
	if is_enraged:
		slam_w *= 1.5
	weights[AttackType.HEAVY_SLAM] = slam_w

	# --- EMPOWERED BEAM (only when partner is dead) ---
	var beam_w = 0.0
	if _is_empowered:
		beam_w = 0.20
		if dist > close_range:
			beam_w = 0.35
		if dist > mid_range:
			beam_w = 0.45
	weights[AttackType.EMPOWERED_BEAM] = beam_w

	# Weighted selection
	var total = 0.0
	for w in weights.values():
		total += w

	if total <= 0.0:
		return AttackType.CLAW_COMBO

	var pick = _rng.randf() * total
	var acc = 0.0
	for atk in weights:
		acc += weights[atk]
		if pick <= acc and weights[atk] > 0.0:
			return atk

	return AttackType.CLAW_COMBO

func _start_attack(attack: AttackType) -> void:
	_behavior_state = BehaviorState.ATTACKING
	_current_attack = attack
	_combo_interrupted = false
	_attack_sequence_id += 1

	match attack:
		AttackType.CLAW_COMBO:
			_do_claw_combo()
		AttackType.LUNGE:
			_do_lunge_attack()
		AttackType.HEAVY_SLAM:
			_do_heavy_slam()
		AttackType.EMPOWERED_BEAM:
			_do_empowered_beam()

# =============================================================================
# ATTACK: EMPOWERED BEAM (inherited from ranged twin)
# =============================================================================
func _do_empowered_beam() -> void:
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

	_show_parry_indicator(emp_beam_telegraph + 0.15, true)

	# Aim line visual
	var aim_line = _spawn_emp_aim_line(dir)

	if anim and anim.has_animation("beam_charge"):
		anim.play("beam_charge")
	elif anim and anim.has_animation("claw_antic"):
		anim.play("claw_antic")

	# Telegraph — track player for first portion, then lock
	var tel_elapsed = 0.0
	var lock_time = emp_beam_telegraph * emp_beam_aim_track_pct
	while tel_elapsed < emp_beam_telegraph:
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
			_update_emp_aim_line(aim_line, dir)

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
	_spawn_emp_beam_hitbox(dir)

	if anim and anim.has_animation("beam_fire"):
		anim.play("beam_fire")
	elif anim and anim.has_animation("slam_impact"):
		anim.play("slam_impact")

	if not await _wait_duration_interruptible(0.15, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	if not await _wait_duration_interruptible(0.45, my_seq):
		return

	_finish_attack()

func _spawn_emp_beam_hitbox(dir: Vector2) -> void:
	var area = Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", emp_beam_damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(emp_beam_length, emp_beam_width)
	col.shape = rect
	area.add_child(col)

	area.global_position = global_position + dir * (emp_beam_length * 0.5)
	area.rotation = dir.angle()
	get_parent().add_child(area)
	_current_hitbox = area
	_is_current_hitbox_melee = false

	var vis = ColorRect.new()
	vis.size = Vector2(emp_beam_length, emp_beam_width)
	vis.position = Vector2(-emp_beam_length * 0.5, -emp_beam_width * 0.5)
	vis.color = Color(0.95, 0.5, 0.15, 0.7)
	area.add_child(vis)

	area.set_deferred("monitoring", true)
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(area):
			for body in area.get_overlapping_bodies():
				area.body_entered.emit(body)
			for a in area.get_overlapping_areas():
				area.area_entered.emit(a)
	)

func _spawn_emp_aim_line(dir: Vector2) -> Line2D:
	var line = Line2D.new()
	line.width = 3.0
	line.default_color = Color(1.0, 0.35, 0.1, 0.5)
	line.z_index = 50
	line.add_point(Vector2.ZERO)
	line.add_point(dir * emp_beam_length)
	add_child(line)
	return line

func _update_emp_aim_line(line: Line2D, dir: Vector2) -> void:
	if not is_instance_valid(line):
		return
	if line.get_point_count() >= 2:
		line.set_point_position(1, dir * emp_beam_length)

func _remove_node_safe(node: Node) -> void:
	if node != null and is_instance_valid(node):
		node.queue_free()


func _finish_attack() -> void:
	var cd_min = min_attack_cooldown
	var cd_max = max_attack_cooldown

	if _current_attack in [AttackType.CLAW_COMBO, AttackType.LUNGE]:
		cd_min *= 0.6
		cd_max *= 0.75

	if _is_enraged():
		cd_min *= 0.5
		cd_max *= 0.6

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

func _get_claw_count() -> int:
	return 3

func _apply_soft_separation() -> void:
	if _phase == Phase.DEAD or _dbroken_active or _is_rootfanged:
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

	# Also separate from partner twin
	if _manager:
		var partner = _manager.get_partner(self)
		if partner and is_instance_valid(partner) and not partner.is_dead():
			var to_partner = partner.global_position - global_position
			var p_dist = to_partner.length()
			if p_dist < min_separation * 1.5 and p_dist > 0.1:
				var push_strength = (min_separation * 1.5 - p_dist) * 3.0
				var push_dir = -to_partner.normalized()
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
	if _phase == Phase.DEAD or _dbroken_active or _is_rootfanged:
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
		if _phase == Phase.DEAD or _dbroken_active or _is_rootfanged:
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
	if _is_rootfanged:
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

# =============================================================================
# COROUTINE HELPERS
# =============================================================================
func _should_abort_attack(sequence_id: int) -> bool:
	if _phase == Phase.DEAD:
		return true
	if _dbroken_active:
		return true
	if _is_rootfanged:
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
# HITBOX SPAWNERS
# =============================================================================
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
	elif parry_only:
		hitbox.set_meta("damage_type", "perilous")
		hitbox.set_meta("parryable", true)
		hitbox.set_meta("unblockable", false)
	else:
		hitbox.set_meta("damage_type", "rootfang_twin_melee")
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

func _spawn_slam_hitbox(center: Vector2, damage: int, radius: float) -> Area2D:
	var area = Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("telegraphed", true)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)

	var cs = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = radius
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

# =============================================================================
# GENERIC COMBO HIT HELPER
# =============================================================================
func _execute_combo_hit(
	seq_id: int,
	anticipation_time: float,
	active_time: float,
	recovery_time: float,
	hit_lunge_distance: float,
	hit_rootfang_lunge_speed: float,
	damage: int,
	hit_range: float,
	hit_width: float,
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

	var l_time = hit_lunge_distance / hit_rootfang_lunge_speed if hit_rootfang_lunge_speed > 0 else 0.0
	var pre_lunge_wait = max(0.0, anticipation_time - l_time)

	if pre_lunge_wait > 0.0:
		if not await _wait_duration_interruptible(pre_lunge_wait, seq_id):
			return false

	if l_time > 0.0:
		if not await _lunge_phase(attack_dir, hit_lunge_distance, hit_rootfang_lunge_speed, l_time, seq_id):
			return false

	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return false

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_melee_hitbox(attack_dir, damage, hit_range, hit_width, is_parry_only, is_unblockable)
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
# ATTACK: CLAW COMBO
# =============================================================================
func _do_claw_combo() -> void:
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

	if anim and anim.has_animation("claw_antic"):
		anim.play("claw_antic")
	if not await _wait_duration_interruptible(claw_initial_windup, my_seq):
		return

	var hit_count = _get_claw_count()
	if _is_enraged():
		hit_count = min(hit_count + 1, 4)

	for i in range(hit_count):
		_combo_hit_index = i + 1

		if not await _execute_combo_hit(
			my_seq, claw_telegraph, claw_active, claw_recovery,
			claw_lunge_distance, claw_rootfang_lunge_speed, claw_damage,
			claw_range, claw_width,
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
# ATTACK: LUNGE
# =============================================================================
func _do_lunge_attack() -> void:
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

	var telegraph = lunge_telegraph
	if _is_enraged():
		telegraph *= 0.8
	var total_duration = telegraph + parry_early_window + lunge_active + parry_linger_window
	_show_parry_indicator(total_duration, false)

	if anim and anim.has_animation("lunge_antic"):
		anim.play("lunge_antic")

	if not await _wait_duration_interruptible(telegraph, my_seq):
		return

	if _should_abort_attack(my_seq):
		_cleanup_hitbox()
		_set_combat_phase(CombatPhase.NONE)
		_finish_attack()
		return

	# Re-aim at player before lunging
	if player and is_instance_valid(player):
		dir = (player.global_position - global_position).normalized()
		if dir == Vector2.ZERO:
			dir = Vector2.RIGHT
		_face_direction(dir)

	_set_combat_phase(CombatPhase.ACTIVE)
	_current_hitbox = _spawn_melee_hitbox(dir, lunge_damage, lunge_range, lunge_width, false, false)
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("lunge_active"):
		anim.play("lunge_active")

	# Lunge forward during active frames
	var lunge_elapsed = 0.0
	var l_time = lunge_distance / rootfang_lunge_speed if rootfang_lunge_speed > 0 else 0.0
	while lunge_elapsed < l_time:
		if _should_abort_attack(my_seq):
			velocity = Vector2.ZERO
			_cleanup_hitbox()
			_set_combat_phase(CombatPhase.NONE)
			_finish_attack()
			return
		velocity = dir * rootfang_lunge_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		lunge_elapsed += get_physics_process_delta_time()
	velocity = Vector2.ZERO

	if not await _wait_duration_interruptible(lunge_active, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	var recovery = rootfang_lunge_recovery
	if _is_enraged():
		recovery *= 0.75
	await get_tree().create_timer(recovery).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

# =============================================================================
# ATTACK: HEAVY SLAM (unblockable — dodge-only)
# =============================================================================
func _do_heavy_slam() -> void:
	var my_seq = _attack_sequence_id
	if _should_abort_attack(my_seq):
		return

	_set_combat_phase(CombatPhase.WINDUP)
	velocity = Vector2.ZERO

	var player = _get_player()
	if player:
		_face_direction((player.global_position - global_position).normalized())

	var windup_time = slam_windup
	if _is_enraged():
		windup_time *= 0.8
	var total_duration = windup_time + parry_linger_window
	_show_parry_indicator(total_duration, true)

	if anim and anim.has_animation("slam_windup"):
		anim.play("slam_windup")

	# Track player during windup
	var windup_elapsed = 0.0
	var track_cutoff = windup_time * 0.7
	while windup_elapsed < windup_time - slam_parry_preframe:
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
	_current_hitbox = _spawn_slam_hitbox(global_position, slam_damage, slam_radius)
	_is_current_hitbox_melee = true

	if anim and anim.has_animation("slam_impact"):
		anim.play("slam_impact")

	if not await _wait_duration_interruptible(slam_parry_preframe, my_seq):
		return
	if not await _wait_duration_interruptible(parry_linger_window, my_seq):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	var recovery = slam_recovery
	if _is_enraged():
		recovery *= 0.8
	await get_tree().create_timer(recovery).timeout

	_set_combat_phase(CombatPhase.NONE)
	_finish_attack()

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

	_player_recent_hits += 1.0

	# --- ROOTFANG ROLL ARMOR: reduced damage during active rolls only ---
	if _is_rootfanged and _rootfang_rolling:
		var reduced_damage = int(round(float(damage) * (1.0 - rootfang_roll_damage_reduction)))
		if combat:
			var orig_gain = combat.config.hit_posture_gain if combat.config else 12.0
			if combat.config:
				combat.config.hit_posture_gain = orig_gain * (1.0 - rootfang_roll_damage_reduction)
			combat.notify_got_hit({"damage": reduced_damage, "blocked": true})
			if combat.config:
				combat.config.hit_posture_gain = orig_gain

		if attacker is Area2D and attacker.has_meta("prosthetic_source"):
			ProstheticEffects.apply(attacker, self, true)

		if reduced_damage > 0:
			hp = max(hp - reduced_damage, 1)
			_update_bars()
		_flash_block()
		return
	# If rootfanged but NOT rolling (pause between rolls), falls through to
	# normal guarding/unguarded checks — this is the punish window.
	# _is_guarding() already returns false when _is_rootfanged, so full damage applies.

	var guarding = _is_guarding()

	# --- GUARDING: posture chip only ---
	if guarding:
		if combat:
			combat.notify_got_hit({"damage": 0, "blocked": true})

		if attacker is Area2D and attacker.has_meta("prosthetic_source"):
			ProstheticEffects.apply(attacker, self, true)

		var se_node = get_node_or_null("/root/StanceEffects")
		if se_node and se_node.has_method("on_enemy_hit"):
			se_node.on_enemy_hit(attacker, self, true)

		_flash_block()
		return

	# --- NOT GUARDING: HP + reduced posture ---
	var final_damage = damage
	var posture_mult = unguarded_posture_mult

	if _is_in_windup():
		posture_mult *= windup_posture_mult
		_flash_windup_hit()

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

	var se_node = get_node_or_null("/root/StanceEffects")
	if se_node and se_node.has_method("on_enemy_hit"):
		se_node.on_enemy_hit(attacker, self, false)

	_apply_hp_damage(final_damage)
	
func _apply_hp_damage(damage: int) -> void:
	if _phase == Phase.DEAD:
		return
	
	hp = max(hp - damage, 0)
	_update_bars()
	
	if hp <= 0:
		_die()
		return
	
	hitstop_local(0.005)
	_flash_hurt_sprite()
	
	_check_rootfang_threshold()

# =============================================================================
# PARRY HANDLING
# =============================================================================
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

	# Claw combo: combo parry (hitstop only, no knockback)
	if local_attack == AttackType.CLAW_COMBO:
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
	if local_attack == AttackType.LUNGE:
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
		AttackType.LUNGE:
			recoil_time = 0.22
			recoil_speed = 130.0
			max_recoil = 45.0
		AttackType.HEAVY_SLAM:
			recoil_time = 0.20
			recoil_speed = 110.0
			max_recoil = 38.0

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

	# Exit rootfang if posture broken while rootfanged
	if _is_rootfanged:
		_is_rootfanged = false
		_rootfang_rolling = false
		_cleanup_hitbox()
		if _manager:
			_manager.notify_rootfang_ended(self)

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

	_clear_deathblow_state()

	# Deathblow kills this twin
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

	# Deathblow = death for rootfang twins
	_die()

func on_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func receive_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func is_deathblow_ready() -> bool:
	return _dbroken_active

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
	_is_rootfanged = false
	_rootfang_rolling = false
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
	
	if is_in_group("rootfang"):
		remove_from_group("rootfang")
	
	if is_in_group("rootfang_duo_twin"):
		remove_from_group("rootfang_duo_twin")
	
	if _manager:
		_manager.notify_died(self)
	
	emit_signal("defeated")
	emit_signal("enemy_died", self)
	
	award_area_gold_drop()
	notify_stance_effects_enemy_death()
	
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

func hitstop_local(duration: float) -> void:
	if anim:
		var was_playing = anim.current_animation
		anim.pause()
		await get_tree().create_timer(duration).timeout
		if is_instance_valid(anim) and was_playing != "" and _phase != Phase.DEAD:
			anim.play(was_playing)

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
# UI BARS — HP + Posture
# =============================================================================
func _setup_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsUI"
	_bars_container.z_index = 100
	add_child(_bars_container)

	# Posture bar
	_rootfang_posture_bg = ColorRect.new()
	_rootfang_posture_bg.size = Vector2(54, 6)
	_rootfang_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	_rootfang_posture_bg.position = Vector2(-27, -55)
	_bars_container.add_child(_rootfang_posture_bg)

	_rootfang_posture_fill = ColorRect.new()
	_rootfang_posture_fill.size = Vector2(0, 6)
	_rootfang_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	_rootfang_posture_fill.position = Vector2.ZERO
	_rootfang_posture_bg.add_child(_rootfang_posture_fill)

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

	# Dim bars when rootfanged
	if _is_rootfanged and _bars_container:
		_bars_container.modulate = Color(0.6, 0.6, 0.6, 0.7)
	elif _bars_container:
		_bars_container.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _update_posture_bar(cur: float, maxv: float) -> void:
	if not _rootfang_posture_fill or not _rootfang_posture_bg:
		return
	
	var pct = clamp(cur / max(0.001, maxv), 0.0, 1.0)
	_rootfang_posture_fill.size.x = 54.0 * pct
	
	var hp_ratio = clamp(float(hp) / float(get_max_hp()), 0.0, 1.0)
	
	if hp_ratio >= 0.75:
		_rootfang_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	elif hp_ratio >= 0.50:
		_rootfang_posture_fill.color = Color(1.0, 0.6, 0.1, 0.95)
	elif hp_ratio >= 0.25:
		_rootfang_posture_fill.color = Color(1.0, 0.4, 0.1, 0.95)
	else:
		var flash = 0.7 + 0.3 * sin(Time.get_ticks_msec() * 0.01)
		_rootfang_posture_fill.color = Color(1.0, 0.25 * flash, 0.1, 0.95)
	
	if pct >= 0.85:
		var break_flash = 0.8 + 0.2 * sin(Time.get_ticks_msec() * 0.015)
		_rootfang_posture_fill.color.a = break_flash
