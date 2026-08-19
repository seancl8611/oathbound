extends HumanoidEnemyBase
class_name TheCollector

@export var collector_max_hp: int = 180
@export var base_movement_speed := 70.0     # FASTER - more aggressive pursuit

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export_group("Posture System")
@export var parry_posture_damage := 25.0
@export var block_posture_damage := 8.0
@export var deathblow_window_duration := 3.0
@export var deathblow_damage := 75

# =============================================================================
# PARRY TIMING
# =============================================================================
@export_group("Parry Timing")
@export var parry_early_window := 0.20
@export var parry_linger_window := 0.20
@export var parry_recoil_duration := 0.18   # Shorter recoil - recovers faster
@export var parry_recoil_speed := 80.0      # Less knockback
@export var post_parry_recovery := 0.35     # Recovers faster after parry

# =============================================================================
# DISTANCE THRESHOLDS
# =============================================================================
@export_group("Distance Thresholds")
@export var close_range := 70.0
@export var mid_range := 130.0
@export var far_range := 200.0              # Reduced - closes gap sooner
@export var ideal_combat_distance := 55.0   # Stays closer to player
@export var too_close_threshold := 25.0     # Almost never retreats

# =============================================================================
# ATTACK PACING - SEKIRO STYLE (MUCH FASTER)
# =============================================================================
@export_group("Attack Pacing")
@export var min_attack_cooldown := 0.85        # was 0.65
@export var max_attack_cooldown := 1.70        # was 1.40
@export var combo_continuation_chance := 0.40  # was 0.55 – fewer back-to-back strings
@export var parry_recovery_penalty := 0.10  # was 0.15

# =============================================================================
# GREED LASH (Attack 1) - FAST POKE
# =============================================================================
@export_group("Greed Lash")
@export var lash_range := 100.0
@export var lash_windup := 0.58             # was 0.42 – clearer telegraph
@export var lash_active := 0.13
@export var lash_recovery := 0.34           # was 0.30 – slightly more punish window
@export var lash_damage := 8
@export var lash_swing_length := 85.0
@export var lash_swing_width := 50.0

# =============================================================================
# SOUL-CHAIN SNARE (Attack 2 - Unblockable grab)
# =============================================================================
@export_group("Soul-Chain Snare")
@export var snare_range := 75.0
@export var snare_cone_angle := 75.0
@export var snare_windup := 0.65            # Slower - gives warning for unblockable
@export var snare_active := 0.22
@export var snare_recovery_on_miss := 0.70  # Punishable on whiff
@export var snare_restrain_duration := 1.5
@export var snare_lunge_distance := 55.0
@export var snare_lunge_speed := 350.0      # Faster lunge
@export var snare_hitbox_length := 70.0
@export var snare_hitbox_width := 85.0
@export var chest_crush_windup := 0.45
@export var chest_crush_damage := 25
@export var chest_crush_posture_damage := 30.0
@export var snare_min_interval := 5.0

@export_group("Invisibility")
@export var invis_duration := 2.0          # was 1.2 – stays vanished longer
@export var invis_cooldown := 5.0
@export var invis_reappear_min_dist := 50.0
@export var invis_reappear_max_dist := 70.0
@export var invis_fade_time := 0.20
@export var ambush_dash_speed := 400.0
@export var ambush_dash_duration := 0.15
@export var ambush_windup_reduction := 0.25  # was 0.40 – ambush attacks telegraph more

# =============================================================================
# CHAIN COMBO (Attack 4 - EXPANDED TO 3+ HITS)
# =============================================================================
@export_group("Chain Combo")
@export var combo_max_hits := 4

@export var combo_hit1_windup := 0.55       # was 0.40
@export var combo_hit1_active := 0.12
@export var combo_hit1_recovery := 0.22     # was 0.18

@export var combo_hit1_damage := 9
@export var combo_hit1_range := 80.0
@export var combo_hit1_lunge_distance := 40.0
@export var combo_hit1_lunge_speed := 300.0

@export var combo_inter_hit_gap := 0.18     # was 0.12 – more space between swings

@export var combo_hit2_windup := 0.50       # was 0.35
@export var combo_hit2_active := 0.12
@export var combo_hit2_recovery := 0.22     # was 0.18
@export var combo_hit2_damage := 11
@export var combo_hit2_range := 90.0
@export var combo_hit2_lunge_distance := 35.0
@export var combo_hit2_lunge_speed := 280.0

# Hit 3 - Faster still (rhythm acceleration)
@export var combo_hit3_windup := 0.45       # was 0.30
@export var combo_hit3_active := 0.10
@export var combo_hit3_recovery := 0.24     # was 0.20
@export var combo_hit3_damage := 13

# Hit 4 - Big finisher (slower, more damage)
@export var combo_hit4_windup := 0.70       # was 0.52
@export var combo_hit4_active := 0.15
@export var combo_hit4_recovery := 0.45     # was 0.40
@export var combo_hit4_damage := 18
@export var combo_swing_length := 80.0
@export var combo_swing_width := 55.0

@export var miss_block_chance := 0.18  # 0.10–0.25 feels reasonable

# =============================================================================
# GROUND MASSES
# =============================================================================
@export_group("Ground Masses")
@export var masses_windup := 0.60
@export var masses_recovery := 0.45
@export var masses_count := 3
@export var masses_speed := 55.0
@export var masses_turn_rate_deg := 35.0
@export var masses_lifetime := 5.0
@export var masses_damage := 12
@export var masses_radius := 22.0
@export var masses_cooldown := 6.0
@export var masses_min_range := 50.0

# =============================================================================
# NEW: QUICK SLASH (Fast gap-closer attack)
# =============================================================================
@export_group("Quick Slash")
@export var quick_slash_windup := 0.38      # was 0.26
@export var quick_slash_active := 0.11
@export var quick_slash_recovery := 0.32    # was 0.28
@export var quick_slash_damage := 6
@export var quick_slash_dash_speed := 330.0
@export var quick_slash_dash_duration := 0.10
@export var quick_slash_range := 120.0

# =============================================================================
# NEW: REACTIVE AI SETTINGS
# =============================================================================
@export_group("Reactive AI")
@export var heal_punish_reaction_time := 0.20   # How fast to react to healing
@export var retreat_punish_distance := 100.0    # If player backs up this much, chase
@export var aggression_level := 0.75            # 0-1, higher = more aggressive
@export var pressure_mode_threshold := 0.40     # Enter pressure mode below this HP%

# =============================================================================
# STATE MACHINE
# =============================================================================
enum Phase { ALIVE, DEAD }
enum BehaviorState { IDLE, APPROACHING, ATTACKING, CIRCLING, RETREATING, INVISIBLE, CHASING }
enum AttackType { NONE, GREED_LASH, SOUL_CHAIN_SNARE, INVISIBILITY, CHAIN_COMBO, GROUND_MASSES, QUICK_SLASH }
enum CombatPhase { NONE, WINDUP, ACTIVE, RECOVERY }

var _phase := Phase.ALIVE
var _behavior_state := BehaviorState.IDLE
var _current_attack := AttackType.NONE
var _combat_phase := CombatPhase.NONE
var _attack_cooldown := 0.0
var _attack_sequence_id := 0

# Parry state
var _parry_stagger_until := 0.0
var _parry_recoil_until := 0.0
var _parry_recoil_velocity := Vector2.ZERO

# Combo state - EXPANDED
var _combo_hit_index := 0
var _combo_should_continue := true
var _combo_interrupted := false
var _combo_was_parried := false
var _combo_planned_hits := 2              # How many hits in current combo
var _in_combo_sequence := false           # Are we mid-combo?

# Posture break
var _dbroken_active := false
var _dbreak_until := -1.0
var _dbreak_immunity_until := 0.0

# Snare state
var _snare_active := false
var _snare_target: Node2D = null
var _last_snare_time := -999.0
var _snare_attempts_since_hit := 0

# Invisibility state
var _invisible := false
var _invis_cooldown_until := 0.0
var _pre_invis_modulate := Color.WHITE
var _is_ambushing := false

# Ground Masses
var _active_masses: Array = []
var _masses_cooldown_until := 0.0

# AI state - ENHANCED
var _circle_timer := 0.0
var _circle_direction := 1.0
var _recent_attacks: Array[AttackType] = []
var _times_parried := 0
var _consecutive_parries := 0             # Track parry streaks for AI adaptation
var _last_player_position := Vector2.ZERO # Track player movement
var _player_retreating := false           # Is player backing up?
var _player_healing := false              # Is player trying to heal?
var _pressure_mode := false               # Enhanced aggression at low HP
var _attack_chain_count := 0              # How many attacks in current chain

var _current_hitbox: Area2D = null
var _rng := RandomNumberGenerator.new()

# UI
var _bars_container: Node2D
var _hp_bg: ColorRect
var _hp_fill: ColorRect
var _collector_posture_bg: ColorRect
var _collector_posture_fill: ColorRect

signal defeated
signal posture_broken(duration: float)
signal posture_recovered

# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	super._ready()
	
	hp = collector_max_hp
	_max_hp = collector_max_hp
	
	_attack_sequence_id = 0
	_combat_phase = CombatPhase.NONE
	_rng.randomize()
	
	add_to_group("miniboss")
	add_to_group("the_collector")
	
	if combat and not combat.config:
		combat.config = CombatConfig.create_miniboss_config()
	
	_setup_dual_bars()
	
	if combat:
		if combat.has_method("update_health_ratio"):
			combat.update_health_ratio(float(hp), float(get_max_hp()))
		
		if not combat.is_connected("posture_changed", Callable(self, "_on_posture_changed")):
			combat.connect("posture_changed", Callable(self, "_on_posture_changed"))
		
		if not combat.is_connected("posture_broken", Callable(self, "_on_posture_broken")):
			combat.connect("posture_broken", Callable(self, "_on_posture_broken"))
		
		var maxv := combat.config.posture_max if combat.config else 100.0
		combat.emit_signal("posture_changed", 0.0, maxv)
	
	# Start with a short cooldown — aggressive from the start.
	_attack_cooldown = _rng.randf_range(0.3, 0.5)

func _setup_dual_bars() -> void:
	_bars_container = Node2D.new()
	_bars_container.name = "BarsUI"
	_bars_container.z_index = 100
	add_child(_bars_container)
	
	_collector_posture_bg = ColorRect.new()
	_collector_posture_bg.size = Vector2(54, 6)
	_collector_posture_bg.color = Color(0.12, 0.12, 0.02, 0.8)
	_collector_posture_bg.position = Vector2(-27, -45)
	_bars_container.add_child(_collector_posture_bg)

	_collector_posture_fill = ColorRect.new()
	_collector_posture_fill.size = Vector2(0, 6)
	_collector_posture_fill.color = Color(1.0, 0.85, 0.15, 0.95)
	_collector_posture_fill.position = Vector2.ZERO
	_collector_posture_bg.add_child(_collector_posture_fill)
	
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


# =============================================================================
# COMBAT PHASE MANAGEMENT
# =============================================================================
func _set_combat_phase(phase: CombatPhase) -> void:
	_combat_phase = phase

func _is_in_windup() -> bool:
	return _combat_phase == CombatPhase.WINDUP

func _is_in_parry_stagger() -> bool:
	return Time.get_ticks_msec() * 0.001 < _parry_stagger_until

func _is_in_parry_recoil() -> bool:
	return _parry_recoil_until > 0.0 and Time.get_ticks_msec() * 0.001 < _parry_recoil_until


# =============================================================================
# MAIN LOOP - ENHANCED WITH REACTIVE AI
# =============================================================================
func _physics_process(delta: float) -> void:
	if _phase == Phase.DEAD:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	_update_posture_break(delta)
	_update_masses(delta)
	_update_bars()
	_update_reactive_ai(delta)  # NEW: Track player behavior
	
	if combat:
		combat.update_health_ratio(float(hp), float(get_max_hp()))
	
	# Check for pressure mode (low HP = more aggressive)
	var hp_pct := float(hp) / float(get_max_hp())
	_pressure_mode = hp_pct < pressure_mode_threshold
	
	if _humanoid_shared_tick(delta):
		_update_bars()
		return
	
	if _dbroken_active:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if _is_in_parry_stagger() or _is_in_parry_recoil():
		if _is_in_parry_recoil():
			var now := Time.get_ticks_msec() * 0.001
			var t = clamp((_parry_recoil_until - now) / max(0.001, parry_recoil_duration), 0.0, 1.0)
			# Fast ease-out: strong at start, quickly settles
			var ease = t * t
			velocity = _parry_recoil_velocity * ease
		else:
			velocity = Vector2.ZERO
		move_and_slide()
		return
	
	if not _is_in_parry_recoil():
		_parry_recoil_velocity = Vector2.ZERO
	
	match _behavior_state:
		BehaviorState.IDLE:
			_process_idle_sekiro(delta)  # RENAMED - uses new aggressive logic
		BehaviorState.APPROACHING:
			_process_approaching_aggressive(delta)
		BehaviorState.CIRCLING:
			_process_circling_brief(delta)  # Much shorter circling
		BehaviorState.RETREATING:
			_process_retreating_minimal(delta)  # Almost never retreat
		BehaviorState.CHASING:
			_process_chasing(delta)  # NEW: Aggressive pursuit
		BehaviorState.ATTACKING:
			pass
		BehaviorState.INVISIBLE:
			pass
	
	move_and_slide()


# =============================================================================
# NEW: REACTIVE AI - Track player behavior and respond
# =============================================================================
func _update_reactive_ai(_delta: float) -> void:
	var player := _get_player()
	if not player:
		return
	
	# Track if player is retreating
	var current_pos = player.global_position
	if _last_player_position != Vector2.ZERO:
		var movement = current_pos - _last_player_position
		var to_me = global_position - current_pos
		# Player is retreating if moving away from us
		_player_retreating = movement.dot(to_me.normalized()) < -5.0
	_last_player_position = current_pos
	
	# Track if player is healing (check for healing animation/state)
	if player.has_method("is_healing"):
		var was_healing := _player_healing
		_player_healing = player.is_healing()
		# PUNISH HEALING - immediately attack!
		if _player_healing and not was_healing and _behavior_state == BehaviorState.IDLE:
			if _attack_cooldown <= 0.3:  # Can react quickly
				_start_attack(AttackType.QUICK_SLASH)
	elif "is_healing" in player:
		var was_healing := _player_healing
		_player_healing = player.is_healing
		if _player_healing and not was_healing and _behavior_state == BehaviorState.IDLE:
			if _attack_cooldown <= 0.3:
				_start_attack(AttackType.QUICK_SLASH)


# =============================================================================
# SEKIRO-STYLE IDLE - MINIMAL DOWNTIME
# =============================================================================
func _process_idle_sekiro(delta: float) -> void:
	velocity = Vector2.ZERO
	_attack_cooldown -= delta
	
	# Confused: wander aimlessly
	if ProstheticEffects.is_confused(self):
		var wander = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		velocity = wander * base_movement_speed * 0.25
		_play_idle()
		return
	
	var player = _get_player()
	if not player:
		_play_idle()
		return
	if _player_hidden_in_smoke(player):
		_play_idle()
		return
	
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	_face_direction(to_player.normalized())
	
	if _attack_cooldown <= 0:
		var attack = _pick_next_attack_sekiro(dist)
		if attack == AttackType.NONE:
			_attack_cooldown = _rng.randf_range(0.1, 0.3)
			return
		
		var needed_range = _get_attack_range(attack)
		if dist > needed_range and attack != AttackType.GROUND_MASSES and attack != AttackType.INVISIBILITY:
			if dist < quick_slash_range:
				_start_attack(AttackType.QUICK_SLASH)
			else:
				_behavior_state = BehaviorState.CHASING
				_current_attack = attack
			return
		
		_start_attack(attack)
		return
	
	if _player_retreating and dist > ideal_combat_distance:
		_behavior_state = BehaviorState.CHASING
		return
	
	if dist > mid_range:
		_behavior_state = BehaviorState.APPROACHING
		return
		
# =============================================================================
# AGGRESSIVE APPROACH
# =============================================================================
func _process_approaching_aggressive(delta: float) -> void:
	var player := _get_player()
	if not player:
		_behavior_state = BehaviorState.IDLE
		return
	
	# Smoke cloud: abort approach
	if _player_hidden_in_smoke(player):
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		return
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	_attack_cooldown -= delta
	
	var needed_range := _get_attack_range(_current_attack) if _current_attack != AttackType.NONE else mid_range * 0.75
	
	if dist <= needed_range:
		if _current_attack != AttackType.NONE and _attack_cooldown <= 0:
			_start_attack(_current_attack)
		else:
			_behavior_state = BehaviorState.IDLE
		return
	
	# FAST approach - don't dawdle
	velocity = to_player.normalized() * base_movement_speed
	_face_direction(to_player.normalized())
	_play_walk()


# =============================================================================
# NEW: AGGRESSIVE CHASE - Used when player retreats
# =============================================================================
func _process_chasing(delta: float) -> void:
	var player := _get_player()
	if not player:
		_behavior_state = BehaviorState.IDLE
		return
	# Smoke cloud: stop chasing
	if _player_hidden_in_smoke(player):
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		return
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	_attack_cooldown -= delta
	
	# If we've closed the gap, attack!
	if dist <= quick_slash_range and _attack_cooldown <= 0:
		_start_attack(AttackType.QUICK_SLASH)
		return
	
	if dist <= mid_range:
		_behavior_state = BehaviorState.IDLE
		return
	
	# SPRINT after them
	velocity = to_player.normalized() * base_movement_speed * 1.3
	_face_direction(to_player.normalized())
	_play_walk()


# =============================================================================
# BRIEF CIRCLING (Not the long passive orbiting)
# =============================================================================
func _process_circling_brief(delta: float) -> void:
	var player := _get_player()
	if not player:
		_behavior_state = BehaviorState.IDLE
		return
	# Smoke cloud: stop circling
	if _player_hidden_in_smoke(player):
		velocity = Vector2.ZERO
		_behavior_state = BehaviorState.IDLE
		return
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	_circle_timer -= delta
	_attack_cooldown -= delta
	
	# Circle for MUCH shorter time
	if _circle_timer <= 0 or _attack_cooldown <= 0:
		_behavior_state = BehaviorState.IDLE
		return
	
	var target_dir = to_player.normalized()
	var circle_dir = target_dir.rotated(PI * 0.5 * _circle_direction)
	
	var dist_diff = dist - ideal_combat_distance
	var approach_weight = clamp(dist_diff / 40.0, -1.0, 1.0)
	var move_dir = (circle_dir + target_dir * approach_weight * 0.6).normalized()
	
	velocity = move_dir * base_movement_speed * 0.8
	_face_direction(target_dir)
	_play_walk()


func _start_circling_brief() -> void:
	_behavior_state = BehaviorState.CIRCLING
	_circle_timer = _rng.randf_range(0.6, 1.2)  # MUCH shorter than before
	_circle_direction = 1.0 if randf() > 0.5 else -1.0


# =============================================================================
# MINIMAL RETREATING - Sekiro bosses almost never back off
# =============================================================================
func _process_retreating_minimal(delta: float) -> void:
	var player := _get_player()
	if not player:
		_behavior_state = BehaviorState.IDLE
		return
	
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	_attack_cooldown -= delta
	
	# Stop retreating almost immediately
	if dist >= too_close_threshold + 5.0 or _attack_cooldown <= 0.2:
		_behavior_state = BehaviorState.IDLE
		return
	
	# Brief backstep
	velocity = -to_player.normalized() * base_movement_speed * 0.6
	_face_direction(to_player.normalized())
	_play_walk()


# =============================================================================
# SEKIRO-STYLE ATTACK SELECTION
# =============================================================================
# Key differences:
#   - Much higher chance to chain attacks together
#   - Quick attacks used for gap-closing
#   - Pressure mode at low HP = relentless aggression
#   - Attacks chosen to maintain rhythm/pressure
# =============================================================================

func _pick_next_attack_sekiro(dist: float) -> AttackType:
	var player = _get_player()
	if not player:
		return AttackType.NONE

	var now = Time.get_ticks_msec() * 0.001
	var hp_pct = float(hp) / float(get_max_hp())

	# =========================================================================
	# COMBO CONTINUATION - FIX: properly reset when chain ends
	# =========================================================================
	if _in_combo_sequence:
		if randf() < combo_continuation_chance:
			_attack_chain_count += 1
			if _attack_chain_count >= _rng.randi_range(3, 5):
				# Chain hit its cap - end the sequence
				_in_combo_sequence = false
				_attack_chain_count = 0
				return AttackType.NONE

			if dist < close_range:
				return [AttackType.GREED_LASH, AttackType.CHAIN_COMBO, AttackType.CHAIN_COMBO].pick_random()
			else:
				return [AttackType.QUICK_SLASH, AttackType.GREED_LASH].pick_random()
		else:
			# FIX: Continuation roll failed - reset chain state cleanly
			# Without this, _in_combo_sequence stays true forever and
			# _attack_chain_count keeps climbing across separate sequences
			_in_combo_sequence = false
			_attack_chain_count = 0

	# =========================================================================
	# INVISIBILITY ESCAPE / AMBUSH
	# =========================================================================
	if _should_use_invisibility(hp_pct, dist):
		return AttackType.INVISIBILITY

	# =========================================================================
	# PRESSURE MODE (Low HP) - still aggressive, but not brainless
	# =========================================================================
	if _pressure_mode:
		var time_since_snare = now - _last_snare_time
		if time_since_snare >= snare_min_interval and dist < snare_range + snare_lunge_distance:
			return AttackType.SOUL_CHAIN_SNARE

		if dist < close_range:
			return [AttackType.CHAIN_COMBO, AttackType.CHAIN_COMBO, AttackType.GREED_LASH].pick_random()
		elif dist < mid_range:
			return [AttackType.QUICK_SLASH, AttackType.CHAIN_COMBO].pick_random()
		else:
			return AttackType.QUICK_SLASH

	# =========================================================================
	# SOUL CHAIN SNARE - periodic signature attack
	# =========================================================================
	var time_since_snare = now - _last_snare_time
	if time_since_snare >= snare_min_interval and dist < snare_range + snare_lunge_distance:
		if randf() < 0.50:
			return AttackType.SOUL_CHAIN_SNARE

	# =========================================================================
	# GROUND MASSES - area denial / zoning
	# =========================================================================
	var masses_ready = now >= _masses_cooldown_until
	if masses_ready and dist > masses_min_range and randf() < 0.45:
		return AttackType.GROUND_MASSES

	# =========================================================================
	# DISTANCE-BASED SELECTION
	# =========================================================================

	# CLOSE RANGE
	if dist < close_range:
		var roll = randf()
		if roll < 0.45:
			return AttackType.CHAIN_COMBO
		elif roll < 0.75:
			return AttackType.GREED_LASH
		elif roll < 0.90 and not _was_recently_used(AttackType.SOUL_CHAIN_SNARE):
			return AttackType.SOUL_CHAIN_SNARE
		else:
			return AttackType.CHAIN_COMBO

	# MID RANGE
	if dist < mid_range:
		var roll2 = randf()
		if roll2 < 0.30:
			return AttackType.CHAIN_COMBO
		elif roll2 < 0.55:
			return AttackType.GREED_LASH
		elif roll2 < 0.75:
			return AttackType.QUICK_SLASH
		elif masses_ready:
			return AttackType.GROUND_MASSES
		else:
			return AttackType.QUICK_SLASH

	# FAR RANGE
	if masses_ready and randf() < 0.40:
		return AttackType.GROUND_MASSES
	return AttackType.QUICK_SLASH
	
func _pick_ambush_attack() -> AttackType:
	if randf() < 0.55:
		return AttackType.SOUL_CHAIN_SNARE
	else:
		return AttackType.CHAIN_COMBO


func _was_recently_used(attack: AttackType) -> bool:
	if _recent_attacks.size() >= 2:
		return attack in _recent_attacks.slice(-2)
	return attack in _recent_attacks


func _record_attack(attack: AttackType) -> void:
	_recent_attacks.append(attack)
	if _recent_attacks.size() > 4:
		_recent_attacks.pop_front()

func _should_use_invisibility(hp_pct: float, dist: float) -> bool:
	var now := Time.get_ticks_msec() * 0.001
	if now < _invis_cooldown_until:
		return false
	if _invisible:
		return false

	# 1) Pressure reaction – vanish after 2 parries in a row.
	if _consecutive_parries >= 2:
		_consecutive_parries = 0
		return true

	# 2) Low-HP panic: always vanish once you're really hurt.
	if hp_pct < 0.35:
		return true

	# 3) Mid-HP: fairly likely to reposition at < 60% HP.
	if hp_pct < 0.60 and _rng.randf() < 0.40:
		return true

	# 4) Player kiting / backing off: use invis to re-engage more often.
	if dist > mid_range or (_player_retreating and dist > close_range * 1.1):
		if _rng.randf() < 0.65:
			return true

	return false

func _get_attack_range(attack: AttackType) -> float:
	match attack:
		AttackType.GREED_LASH:
			return lash_range * 0.85
		AttackType.SOUL_CHAIN_SNARE:
			return snare_range * 0.9
		AttackType.CHAIN_COMBO:
			return combo_hit1_range * 0.85
		AttackType.QUICK_SLASH:
			return quick_slash_range * 0.9
		AttackType.GROUND_MASSES, AttackType.INVISIBILITY:
			return far_range
	return mid_range


# =============================================================================
# ATTACK ROUTER
# =============================================================================
func _start_attack(atk: AttackType) -> void:
	if _phase == Phase.DEAD or _dbroken_active or _is_in_parry_stagger():
		return
	
	_current_attack = atk
	_behavior_state = BehaviorState.ATTACKING
	_attack_sequence_id += 1
	_combo_interrupted = false
	_in_combo_sequence = true  # Start combo sequence
	if _attack_chain_count == 0:
		_attack_chain_count = 1
	var seq_id := _attack_sequence_id
	
	_record_attack(atk)
	
	match atk:
		AttackType.GREED_LASH:
			_perform_greed_lash_fast(seq_id)
		AttackType.SOUL_CHAIN_SNARE:
			_perform_soul_chain_snare(seq_id)
		AttackType.INVISIBILITY:
			_perform_invisibility(seq_id)
		AttackType.CHAIN_COMBO:
			_perform_chain_combo_extended(seq_id)
		AttackType.GROUND_MASSES:
			_perform_ground_masses(seq_id)
		AttackType.QUICK_SLASH:
			_perform_quick_slash(seq_id)
		_:
			_finish_attack()


func _should_abort_attack(seq_id: int) -> bool:
	if _phase == Phase.DEAD:
		return true
	if _dbroken_active:
		return true
	if _combo_interrupted:
		return true
	if seq_id != _attack_sequence_id:
		return true
	return false


func _finish_attack() -> void:
	# SEKIRO-STYLE: Very short cooldown between attacks
	var base_cooldown := _rng.randf_range(min_attack_cooldown, max_attack_cooldown)
	
	# Even shorter cooldown if we were just parried (recover and counter)
	if _combo_was_parried:
		base_cooldown += parry_recovery_penalty  # Slightly longer to give player a window
		_combo_was_parried = false
	
	# Pressure mode = faster attacks
	if _pressure_mode:
		base_cooldown *= 0.7
	
	_attack_cooldown = base_cooldown
	
	_cleanup_hitbox()
	_set_combat_phase(CombatPhase.NONE)
	_current_attack = AttackType.NONE
	_behavior_state = BehaviorState.IDLE
	velocity = Vector2.ZERO
	_play_idle()

# =============================================================================
# ATTACK 1: GREED LASH - FAST VERSION (SHARP PARRY INDICATOR)
# =============================================================================
func _perform_greed_lash_fast(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return

	var player := _get_player()
	var attack_dir := _get_facing_direction()
	if player:
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)

	velocity = Vector2.ZERO

	# SMALL STEP-IN so the attack doesn't look glued in place
	if player:
		var step_distance := 28.0
		var step_speed := 260.0
		var step_time := step_distance / step_speed
		var elapsed := 0.0

		while elapsed < step_time:
			if _should_abort_attack(seq_id) or _is_in_parry_stagger():
				velocity = Vector2.ZERO
				return

			if player and is_instance_valid(player):
				attack_dir = (player.global_position - global_position).normalized()
				_face_direction(attack_dir)

			velocity = attack_dir * step_speed
			await get_tree().physics_frame
			if not is_instance_valid(self):
				return
			elapsed += get_physics_process_delta_time()

	velocity = Vector2.ZERO

	_set_combat_phase(CombatPhase.WINDUP)
	_play_anim("attack1")

	# FIX #2: show parry indicator a bit earlier (extra lead)
	var early := parry_early_window + 0.06
	var lead_time = max(0.0, lash_windup - early)
	if lead_time > 0.0:
		await get_tree().create_timer(lead_time).timeout
		if _should_abort_attack(seq_id):
			return

	var shown_early = min(early, lash_windup)
	_show_parry_indicator(shown_early + lash_active + parry_linger_window, false)

	var remaining_windup = lash_windup - lead_time
	if remaining_windup > 0.0:
		await get_tree().create_timer(remaining_windup).timeout
		if _should_abort_attack(seq_id):
			return

	# Refresh direction right before active
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()

	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_melee_hitbox(lash_damage, lash_swing_length, lash_swing_width, attack_dir, true)

	await get_tree().create_timer(lash_active).timeout
	if _should_abort_attack(seq_id):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(lash_recovery).timeout
	if _should_abort_attack(seq_id):
		return

	_finish_attack()

func _perform_quick_slash(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return

	var player := _get_player()
	var attack_dir := _get_facing_direction()

	# Initial face (visuals)
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)

	_set_combat_phase(CombatPhase.WINDUP)
	_play_anim("attack1")

	# DASH toward player first (no parry indicator yet)
	var elapsed := 0.0
	while elapsed < quick_slash_dash_duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return

		if player and is_instance_valid(player):
			attack_dir = (player.global_position - global_position).normalized()
			_face_direction(attack_dir)

		velocity = attack_dir * quick_slash_dash_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()

	velocity = Vector2.ZERO

	# Lock strike direction once at windup start (prevents jittery last-moment retarget)
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)

	# FIX #2: show parry indicator a bit earlier (extra lead)
	var early := parry_early_window + 0.06
	var lead_time = max(0.0, quick_slash_windup - early)
	if lead_time > 0.0:
		await get_tree().create_timer(lead_time).timeout
		if _should_abort_attack(seq_id):
			return

	var shown_early = min(early, quick_slash_windup)
	_show_parry_indicator(shown_early + quick_slash_active + parry_linger_window, false)

	var remaining_windup = quick_slash_windup - lead_time
	if remaining_windup > 0.0:
		await get_tree().create_timer(remaining_windup).timeout
		if _should_abort_attack(seq_id):
			return

	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_melee_hitbox(
		quick_slash_damage,
		lash_swing_length * 0.9,
		lash_swing_width * 0.9,
		attack_dir,
		true
	)

	await get_tree().create_timer(quick_slash_active).timeout
	if _should_abort_attack(seq_id):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(quick_slash_recovery).timeout
	if _should_abort_attack(seq_id):
		return

	_finish_attack()

func _perform_chain_combo_extended(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return
	
	_combo_hit_index = 0
	_combo_should_continue = true
	_combo_was_parried = false
	
	# Determine combo length (2-4 hits, weighted toward longer)
	_combo_planned_hits = _rng.randi_range(2, combo_max_hits)
	if _pressure_mode:
		_combo_planned_hits = min(_combo_planned_hits + 1, combo_max_hits)
	
	# Execute each hit
	for hit_num in range(1, _combo_planned_hits + 1):
		if _should_abort_attack(seq_id) or not _combo_should_continue:
			break
		
		await _perform_combo_hit_fast(seq_id, hit_num)
		
		if hit_num < _combo_planned_hits and _combo_should_continue:
			# Short gap between hits
			var gap := combo_inter_hit_gap
			if _combo_was_parried:
				gap += 0.08  # Tiny extra time after parry
			await get_tree().create_timer(gap).timeout
	
	if _should_abort_attack(seq_id):
		_finish_attack()
		return
	
	_finish_attack()

func _perform_combo_hit_fast(seq_id: int, hit_num: int) -> void:
	if _should_abort_attack(seq_id):
		return

	var player = _get_player()
	var attack_dir = _get_facing_direction()
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)

	var windup = combo_hit1_windup
	var active_time = combo_hit1_active
	var recovery_time = combo_hit1_recovery
	var damage = combo_hit1_damage

	match hit_num:
		2:
			windup = combo_hit2_windup
			active_time = combo_hit2_active
			recovery_time = combo_hit2_recovery
			damage = combo_hit2_damage
		3:
			windup = combo_hit3_windup
			active_time = combo_hit3_active
			recovery_time = combo_hit3_recovery
			damage = combo_hit3_damage
		4:
			windup = combo_hit4_windup
			active_time = combo_hit4_active
			recovery_time = combo_hit4_recovery
			damage = combo_hit4_damage

	var reduced_windup = windup
	if hit_num <= 2:
		reduced_windup = max(0.10, windup - (hit_num - 1) * 0.03)

	_set_combat_phase(CombatPhase.WINDUP)
	_play_anim("attack1")

	# FIX #2: show parry indicator a bit earlier (extra lead)
	var early := parry_early_window + 0.06
	var lead_time = max(0.0, reduced_windup - early)
	if lead_time > 0.0:
		await get_tree().create_timer(lead_time).timeout
		if _should_abort_attack(seq_id):
			return

	var shown_early = min(early, reduced_windup)
	_show_parry_indicator(shown_early + active_time + parry_linger_window, false)

	var remaining_windup = reduced_windup - lead_time
	if remaining_windup > 0.0:
		await get_tree().create_timer(remaining_windup).timeout
		if _should_abort_attack(seq_id):
			return

	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()

	_set_combat_phase(CombatPhase.ACTIVE)

	var length = combo_swing_length
	var width = combo_swing_width
	if hit_num >= 3:
		length *= 1.05
		width *= 1.05

	_spawn_melee_hitbox(damage, length, width, attack_dir, true)

	await get_tree().create_timer(active_time).timeout
	if _should_abort_attack(seq_id):
		return

	_cleanup_hitbox()

	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(recovery_time).timeout

func _perform_soul_chain_snare(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return
	
	var player = _get_player()
	var attack_dir = _get_facing_direction()
	if player:
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)
	
	velocity = Vector2.ZERO
	_snare_active = false
	_snare_target = null
	# FIX: Snare is a heavy commitment — don't allow combo chaining off it
	_in_combo_sequence = false
	_attack_chain_count = 0
	
	# Lunge phase
	if snare_lunge_distance > 0 and player:
		var current_dist = (player.global_position - global_position).length()
		var desired = current_dist * 0.75
		var actual_lunge = clamp(desired, 12.0, snare_lunge_distance)
		if actual_lunge > 0.0:
			var lunge_time = actual_lunge / snare_lunge_speed
			var elapsed = 0.0
			_play_walk()
			while elapsed < min(lunge_time, 0.18):
				if _should_abort_attack(seq_id):
					velocity = Vector2.ZERO
					return
				if player and is_instance_valid(player):
					attack_dir = (player.global_position - global_position).normalized()
					_face_direction(attack_dir)
				velocity = attack_dir * snare_lunge_speed
				await get_tree().physics_frame
				if not is_instance_valid(self):
					return
				elapsed += get_physics_process_delta_time()
			velocity = Vector2.ZERO

	# WINDUP
	_set_combat_phase(CombatPhase.WINDUP)
	_show_parry_indicator(snare_windup + snare_active + 0.2, true)
	_play_anim("attack2")
	
	await get_tree().create_timer(snare_windup).timeout
	if _should_abort_attack(seq_id):
		return
	
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
	
	# ACTIVE
	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_grab_hitbox(attack_dir)
	var grabbed = _try_grab_player(attack_dir)
	
	await get_tree().create_timer(snare_active).timeout
	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		_release_snare()  # FIX: always release snare on abort
		return
	
	_cleanup_hitbox()
	
	if grabbed and _snare_target:
		await _perform_chest_crush(seq_id)
	else:
		_set_combat_phase(CombatPhase.RECOVERY)
		_hide_parry_indicator()
		await get_tree().create_timer(snare_recovery_on_miss).timeout
	
	if _should_abort_attack(seq_id):
		_release_snare()  # FIX: release on late abort too
		return
	
	_snare_active = false
	_snare_target = null
	_last_snare_time = Time.get_ticks_msec() * 0.001
	
	_finish_attack()
	
func on_parried(player_pos: Vector2) -> void:
	if _phase == Phase.DEAD:
		return
	
	var player := _get_player()
	var event := {
		"damage": 0,
		"damage_type": "parry",
		"parried": true,
		"blocked": false,
		"attacker": player
	}
	
	_cleanup_hitbox()
	_trigger_parry_stagger(event)

func _try_grab_player(dir: Vector2) -> bool:
	var player = _get_player()
	if not player:
		return false
	
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	if dist > snare_range * 1.1:
		return false
	
	var angle = rad_to_deg(abs(dir.angle_to(to_player.normalized())))
	if angle > snare_cone_angle * 0.55:
		return false
	
	if player.has_method("is_invulnerable") and player.is_invulnerable():
		return false
	if player.has_method("is_dodging") and player.is_dodging():
		return false
	
	_snare_active = true
	_snare_target = player
	
	if player.has_method("apply_chain_restrain"):
		player.apply_chain_restrain(self, snare_restrain_duration, "attack", 6)
	
	return true
	
func _spawn_grab_hitbox(direction: Vector2) -> void:
	# No grabs during stagger/death OR while invisible.
	if _dbroken_active or _phase == Phase.DEAD or _invisible or _behavior_state == BehaviorState.INVISIBLE:
		return

	_cleanup_hitbox()

	var hitbox = Area2D.new()
	hitbox.name = "GrabHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	add_child(hitbox)

	var cs = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(snare_hitbox_length, snare_hitbox_width)
	cs.shape = rect
	cs.position = direction * (snare_hitbox_length * 0.4)
	cs.rotation = direction.angle()
	hitbox.add_child(cs)

	hitbox.set_meta("attacker", self)
	hitbox.set_meta("damage", 0)
	hitbox.set_meta("damage_type", "grab")
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("unblockable", true)
	hitbox.set_meta("consumed", false)

	_current_hitbox = hitbox

func _perform_chest_crush(seq_id: int) -> void:
	_set_combat_phase(CombatPhase.ACTIVE)
	
	await get_tree().create_timer(chest_crush_windup).timeout
	if _should_abort_attack(seq_id):
		_release_snare()
		return
	
	if is_instance_valid(_snare_target) and _snare_active:
		# Apply HP damage through proper channels
		if _snare_target.has_method("take_damage"):
			_snare_target.take_damage(chest_crush_damage, true)
		elif "hp" in _snare_target:
			_snare_target.hp -= chest_crush_damage
		
		# FIX: Apply posture damage with proper clamping and regen suppression
		if "stagger" in _snare_target:
			var max_stagger = _snare_target.stagger_max if "stagger_max" in _snare_target else 100.0
			_snare_target.stagger = min(_snare_target.stagger + chest_crush_posture_damage, max_stagger)
			# Suppress posture regen so grab damage actually sticks
			if "_stagger_suppress_until" in _snare_target:
				_snare_target._stagger_suppress_until = Time.get_ticks_msec() * 0.001 + 0.6
	
	_release_snare()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(0.4).timeout

func _release_snare() -> void:
	_snare_active = false
	_snare_target = null


func on_chain_broken(_player: Node) -> void:
	_release_snare()

func _perform_invisibility(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return

	_cleanup_hitbox()
	velocity = Vector2.ZERO

	_behavior_state = BehaviorState.INVISIBLE
	_invisible = true
	_pre_invis_modulate = sprite.modulate if sprite else Color.WHITE
	_in_combo_sequence = false
	_attack_chain_count = 0

	_hide_parry_indicator()

	# Hide ALL UI elements during invisibility
	if _bars_container:
		_bars_container.visible = false

	# Disable HurtBox while invisible so we don't get weird overlaps / interactions
	if hurt_box:
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)

	# Fade out fast
	if sprite:
		var tw := create_tween()
		tw.tween_property(sprite, "modulate:a", 0.0, invis_fade_time)
		await tw.finished

	if _should_abort_attack(seq_id):
		_end_invisibility()
		_finish_attack()
		return

	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)

	await get_tree().create_timer(invis_duration).timeout
	if _should_abort_attack(seq_id):
		_end_invisibility()
		_finish_attack()
		return

	var player := _get_player()
	if player and is_instance_valid(player):
		var reappear_dist := _rng.randf_range(invis_reappear_min_dist, invis_reappear_max_dist)

		var behind_dir: Vector2
		if "velocity" in player and player.velocity.length() > 10:
			behind_dir = -player.velocity.normalized()
		elif player.has_method("get_facing_direction"):
			behind_dir = -player.get_facing_direction()
		else:
			var angle := _rng.randf_range(PI * 0.5, PI * 1.5)
			behind_dir = Vector2.RIGHT.rotated(angle)

		behind_dir = behind_dir.rotated(_rng.randf_range(-0.3, 0.3))
		global_position = player.global_position + behind_dir * reappear_dist

	_end_invisibility()

	if _should_abort_attack(seq_id):
		_finish_attack()
		return

	_is_ambushing = true
	var ambush_attack := _pick_ambush_attack()

	await get_tree().create_timer(0.10).timeout
	if _should_abort_attack(seq_id):
		_is_ambushing = false
		_cleanup_hitbox()
		_finish_attack()
		return

	if player and is_instance_valid(player):
		_face_direction((player.global_position - global_position).normalized())

	match ambush_attack:
		AttackType.SOUL_CHAIN_SNARE:
			await _perform_ambush_snare(seq_id)
		AttackType.CHAIN_COMBO:
			await _perform_ambush_combo(seq_id)
		_:
			await _perform_ambush_slash(seq_id)

	_is_ambushing = false
	_cleanup_hitbox()
	_finish_attack()
	
func _perform_ambush_snare(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return
	
	var player = _get_player()
	var attack_dir = _get_facing_direction()
	if player:
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)
	
	await _perform_ambush_dash(seq_id, attack_dir)
	if _should_abort_attack(seq_id):
		return
	
	var reduced_windup = snare_windup * (1.0 - ambush_windup_reduction)
	
	_set_combat_phase(CombatPhase.WINDUP)
	_show_parry_indicator(reduced_windup + snare_active + 0.2, true)
	_play_anim("attack2")
	
	await get_tree().create_timer(reduced_windup).timeout
	if _should_abort_attack(seq_id):
		return
	
	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_grab_hitbox(attack_dir)           # FIX: Spawn the actual grab hitbox
	var grabbed = _try_grab_player(attack_dir)
	
	await get_tree().create_timer(snare_active).timeout
	if _should_abort_attack(seq_id):
		_cleanup_hitbox()
		return
	
	_cleanup_hitbox()                         # FIX: Clean up grab hitbox after active window
	
	if grabbed and _snare_target:
		await _perform_chest_crush(seq_id)
	else:
		_set_combat_phase(CombatPhase.RECOVERY)
		_hide_parry_indicator()
		await get_tree().create_timer(snare_recovery_on_miss * 0.6).timeout
	
	_snare_active = false
	_snare_target = null
	_last_snare_time = Time.get_ticks_msec() * 0.001
	
func _perform_ambush_combo(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return

	var player := _get_player()
	var attack_dir := _get_facing_direction()
	if player:
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)

	await _perform_ambush_dash(seq_id, attack_dir)
	if _should_abort_attack(seq_id):
		return

	var reduced_windup := combo_hit1_windup * (1.0 - ambush_windup_reduction)

	_set_combat_phase(CombatPhase.WINDUP)
	# FIX #2: earlier parry indicator on ambush
	var early := parry_early_window + 0.06
	_show_parry_indicator(min(early, reduced_windup) + combo_hit1_active + parry_linger_window, false)
	_play_anim("attack1")

	await get_tree().create_timer(reduced_windup).timeout
	if _should_abort_attack(seq_id):
		return

	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()

	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_melee_hitbox(combo_hit1_damage + 3, combo_swing_length, combo_swing_width, attack_dir, true)

	await get_tree().create_timer(combo_hit1_active).timeout
	if _should_abort_attack(seq_id):
		return

	_cleanup_hitbox()
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(combo_hit1_recovery * 0.6).timeout

func _perform_ambush_slash(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return

	var player := _get_player()
	var attack_dir := _get_facing_direction()
	if player:
		attack_dir = (player.global_position - global_position).normalized()
		_face_direction(attack_dir)

	await _perform_ambush_dash(seq_id, attack_dir)
	if _should_abort_attack(seq_id):
		return

	var reduced_windup := quick_slash_windup * (1.0 - ambush_windup_reduction)

	_set_combat_phase(CombatPhase.WINDUP)
	# FIX #2: earlier parry indicator on ambush
	var early := parry_early_window + 0.06
	_show_parry_indicator(min(early, reduced_windup) + quick_slash_active + parry_linger_window, false)
	_play_anim("attack1")

	await get_tree().create_timer(reduced_windup).timeout
	if _should_abort_attack(seq_id):
		return

	if player and is_instance_valid(player):
		attack_dir = (player.global_position - global_position).normalized()

	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_melee_hitbox(quick_slash_damage + 2, lash_swing_length, lash_swing_width, attack_dir, true)

	await get_tree().create_timer(quick_slash_active).timeout
	if _should_abort_attack(seq_id):
		return

	_cleanup_hitbox()
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(quick_slash_recovery * 0.5).timeout

func _perform_ambush_dash(seq_id: int, direction: Vector2) -> void:
	var elapsed := 0.0
	_play_walk()
	
	while elapsed < ambush_dash_duration:
		if _should_abort_attack(seq_id):
			velocity = Vector2.ZERO
			return
		
		var player := _get_player()
		if player and is_instance_valid(player):
			direction = (player.global_position - global_position).normalized()
			_face_direction(direction)
		
		velocity = direction * ambush_dash_speed
		await get_tree().physics_frame
		if not is_instance_valid(self):
			return
		elapsed += get_physics_process_delta_time()
	
	velocity = Vector2.ZERO

func _end_invisibility() -> void:
	_invisible = false
	_invis_cooldown_until = Time.get_ticks_msec() * 0.001 + invis_cooldown

	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", false)

	if hurt_box:
		hurt_box.set_deferred("monitoring", true)
		hurt_box.set_deferred("monitorable", true)

	if sprite:
		sprite.modulate = _pre_invis_modulate
		sprite.modulate.a = 1.0

	# Re-show UI elements
	if _bars_container:
		_bars_container.visible = true

	_cleanup_hitbox()
	_cleanup_mass_hitboxes()
	
func _perform_ground_masses(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return
	
	var player := _get_player()
	if player:
		_face_direction((player.global_position - global_position).normalized())
	
	velocity = Vector2.ZERO
	_in_combo_sequence = false
	_attack_chain_count = 0
	
	_set_combat_phase(CombatPhase.WINDUP)
	_show_parry_indicator(masses_windup + 0.3, true)
	_play_anim("attack1")
	
	await get_tree().create_timer(masses_windup).timeout
	if _should_abort_attack(seq_id):
		return
	
	_set_combat_phase(CombatPhase.ACTIVE)
	_spawn_masses()
	
	_hide_parry_indicator()
	
	_set_combat_phase(CombatPhase.RECOVERY)
	await get_tree().create_timer(masses_recovery).timeout
	if _should_abort_attack(seq_id):
		return
	
	_masses_cooldown_until = Time.get_ticks_msec() * 0.001 + masses_cooldown
	_finish_attack()

func _spawn_masses() -> void:
	var player := _get_player()
	if not player:
		return
	
	for i in range(masses_count):
		var mass := _create_mass()
		# Spawn near the player, not inside the boss, to avoid visual overlap
		var offset := Vector2(
			_rng.randf_range(-40.0, 40.0),
			_rng.randf_range(-40.0, 40.0)
		)
		mass.global_position = player.global_position + offset
		get_parent().add_child(mass)
		_active_masses.append(mass)


func _create_mass() -> RigidBody2D:
	var mass := RigidBody2D.new()
	mass.name = "GroundMass"
	mass.gravity_scale = 0.0
	mass.linear_damp = 6.0
	mass.angular_damp = 6.0
	mass.freeze = false

	mass.add_to_group("enemy_projectile")

	# Body should NOT participate in physics collisions – we only care about the inner hitbox.
	mass.collision_layer = 0
	mass.collision_mask = 0

	# --- IMPORTANT: ensure Player can detect "unblockable" even if HurtBox passes the mass body ---
	mass.set_meta("unblockable", true)
	mass.set_meta("parryable", false)
	mass.set_meta("damage_type", "mass")
	mass.set_meta("damage", masses_damage)
	mass.set_meta("attacker", self)

	# Visual
	var sprite_node := Sprite2D.new()
	sprite_node.modulate = Color(0.2, 0.1, 0.3, 0.8)
	sprite_node.centered = true
	mass.add_child(sprite_node)

	# (Optional) visual radius collider; with layer/mask = 0 this is non-interactive
	var cs := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = masses_radius
	cs.shape = circle
	mass.add_child(cs)

	# Actual damage hitbox
	var hitbox := Area2D.new()
	hitbox.name = "Hitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4

	var hcs := CollisionShape2D.new()
	var hcircle := CircleShape2D.new()
	hcircle.radius = masses_radius * 0.8
	hcs.shape = hcircle
	hitbox.add_child(hcs)

	# Meta used by player.gd / hurt_box.gd
	hitbox.set_meta("attacker", self)
	hitbox.set_meta("damage", masses_damage)
	hitbox.set_meta("damage_type", "mass")
	hitbox.set_meta("unblockable", true)
	hitbox.set_meta("parryable", false)
	hitbox.set_meta("consumed", false)
	
	hitbox.add_to_group("collector_mass_hitbox")

	mass.add_child(hitbox)

	mass.set_meta("direction", Vector2.ZERO)
	mass.set_meta("lifetime", masses_lifetime)
	mass.set_meta("turn_rate", masses_turn_rate_deg)
	mass.set_meta("speed", masses_speed)

	return mass

func _cleanup_mass_hitboxes() -> void:
	for a in get_tree().get_nodes_in_group("collector_mass_hitbox"):
		if is_instance_valid(a):
			a.queue_free()

func _update_masses(delta: float) -> void:
	var player := _get_player()
	var to_remove := []

	for mass in _active_masses:
		if not is_instance_valid(mass):
			to_remove.append(mass)
			continue

		var lifetime: float = mass.get_meta("lifetime", 0.0) - delta
		mass.set_meta("lifetime", lifetime)

		if lifetime <= 0.0:
			to_remove.append(mass)
			# Disable hitbox monitoring BEFORE queue_free to prevent
			# lingering damage/overlap during the deferred-free frame
			var hitbox_node = mass.get_node_or_null("Hitbox")
			if hitbox_node:
				hitbox_node.set_deferred("monitoring", false)
				hitbox_node.set_deferred("monitorable", false)
			# Kill velocity so the body can't push anything in its final frame
			mass.linear_velocity = Vector2.ZERO
			mass.queue_free()
			continue

		if player and is_instance_valid(player):
			var to_player = (player.global_position - mass.global_position).normalized()
			var current_dir: Vector2 = mass.get_meta("direction", to_player)
			var turn_rate: float = mass.get_meta("turn_rate", masses_turn_rate_deg)
			var new_dir := _rotate_toward(current_dir, to_player, turn_rate * delta)
			mass.set_meta("direction", new_dir)

			var spd: float = mass.get_meta("speed", masses_speed)
			mass.linear_velocity = new_dir * spd

	for mass in to_remove:
		_active_masses.erase(mass)
		
func _spawn_melee_hitbox(damage: int, length: float, width: float, direction: Vector2, parryable: bool) -> void:
	# Refuse to create hitboxes during stagger/death OR while invisible.
	# This prevents any delayed/animation-triggered spawns during invis,
	# which is the reliable fix for the “ghost slash from old location” edge case.
	if _dbroken_active or _phase == Phase.DEAD or _invisible or _behavior_state == BehaviorState.INVISIBLE:
		return

	_cleanup_hitbox()

	var hitbox = Area2D.new()
	hitbox.name = "MeleeHitbox"
	hitbox.add_to_group("attack")
	hitbox.collision_layer = 2
	hitbox.collision_mask = 4
	add_child(hitbox)

	var cs = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width)
	cs.shape = rect
	cs.position = direction * (length * 0.5)
	cs.rotation = direction.angle()
	hitbox.add_child(cs)

	hitbox.set_meta("attacker", self)
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "melee")
	hitbox.set_meta("parryable", parryable)
	hitbox.set_meta("consumed", false)

	_current_hitbox = hitbox

func _cleanup_hitbox() -> void:
	_hide_parry_indicator()
	
	if is_instance_valid(_current_hitbox):
		_current_hitbox.queue_free()
	
	_current_hitbox = null

func _should_block_incoming(event: Dictionary) -> bool:
	var dtype = str(event.get("damage_type", ""))
	if dtype == "grab" or dtype == "mass":
		return false
	if _dbroken_active:
		return false
	if ProstheticEffects.is_confused(self):
		return false
	if _combat_phase == CombatPhase.WINDUP or _combat_phase == CombatPhase.ACTIVE:
		return false
	return randf() >= miss_block_chance
	
func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _phase == Phase.DEAD:
		return
	
	if damage <= 0:
		return
	
	var event := {
		"damage": damage,
		"damage_type": damage_type,
		"attacker": attacker,
		"blocked": false,
		"parried": false
	}
	
	var dmg: int = damage
	
	var is_blocked := false
	
	if not ProstheticEffects.is_confused(self) and _should_block_incoming(event):
		is_blocked = true
	
	if is_blocked:
		if combat:
			var hit_posture = max(6.0, float(dmg) * 0.9)
			combat.add_posture(hit_posture)
			combat.suppress_recovery(0.55)
		
		_consecutive_parries = 0
		ProstheticEffects.apply(attacker, self, true, 0.5)
		return
	
	hp -= dmg
	hp = max(0, hp)
	
	if dmg > 0:
		var player = _get_player()
		if is_instance_valid(player):
			ProstheticEffects.check_lifesteal(player, dmg)
	
	if combat:
		var hit_posture = float(dmg) * 0.5
		combat.add_posture(hit_posture)
		combat.suppress_recovery(0.6)
	
	_consecutive_parries = 0
	
	ProstheticEffects.apply(attacker, self, false, 0.5)
	
	if hp <= 0:
		_die()
		return
			
func _trigger_parry_stagger(event: Dictionary) -> void:
	_hide_parry_indicator()

	# Cancel any in-flight attack coroutine immediately (prevents lingering hitboxes)
	_attack_sequence_id += 1
	_combo_interrupted = true
	_in_combo_sequence = false
	_attack_chain_count = 0
	_current_attack = AttackType.NONE
	_set_combat_phase(CombatPhase.NONE)
	_cleanup_hitbox()
	_cleanup_mass_hitboxes()

	_play_anim("idle")
	_parry_flash_tint()

	var attacker = event.get("attacker", null)
	var away := Vector2.ZERO
	if attacker and is_instance_valid(attacker) and attacker is Node2D:
		away = (global_position - attacker.global_position).normalized()
	else:
		away = -_get_facing_direction()

	var now := Time.get_ticks_msec() * 0.001
	_parry_recoil_velocity = away * parry_recoil_speed
	_parry_recoil_until = now + parry_recoil_duration

	# FIX #1: add a small, guaranteed post-parry pause so we don't immediately
	# start another attack and cut animations / feel too frantic.
	_parry_stagger_until = now + parry_recoil_duration + post_parry_recovery
	_attack_cooldown = max(_attack_cooldown, post_parry_recovery)

	# Return to idle behavior; physics loop will handle recoil movement
	_behavior_state = BehaviorState.IDLE

func _parry_flash_tint() -> void:
	if not sprite:
		return
	var orig := sprite.modulate
	sprite.modulate = Color(1.0, 1.0, 1.5)
	await get_tree().create_timer(0.08).timeout
	if is_instance_valid(sprite):
		sprite.modulate = orig


# =============================================================================
# POSTURE BREAK / DEATHBLOW
# =============================================================================
func _on_posture_changed(current: float, max_value: float) -> void:
	if _collector_posture_fill:
		var pct = clamp(current / max(0.001, max_value), 0.0, 1.0)
		_collector_posture_fill.size.x = 54.0 * pct

func _on_posture_broken(duration: float) -> void:
	if _dbroken_active or _phase == Phase.DEAD:
		return

	_hide_parry_indicator()

	var window = duration if duration > 0 else deathblow_window_duration

	_attack_sequence_id += 1
	_combo_interrupted = true

	var player = _get_player()
	if player:
		var pc = player.get_node_or_null("Combat")
		if pc and pc.has_method("set_deathblow_target"):
			pc.set_deathblow_target(self, window)

	var now = Time.get_ticks_msec() * 0.001
	_dbroken_active = true
	_dbreak_until = now + window
	_dbreak_immunity_until = now + 0.3

	_set_body_collision_enabled(false)

	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_in_combo_sequence = false
	_attack_chain_count = 0
	_combo_should_continue = false
	velocity = Vector2.ZERO

	_cleanup_hitbox()
	_release_snare()  # FIX: free player from grab if posture breaks mid-snare

	if anim:
		if anim.has_animation("stagger"):
			anim.play("stagger")
		else:
			anim.play("idle")

	emit_signal("posture_broken", window)

func _update_posture_break(_delta: float) -> void:
	if not _dbroken_active:
		return

	var now := Time.get_ticks_msec() * 0.001
	if now >= _dbreak_until:
		_dbroken_active = false

		# --- re-enable body collision after broken window ends ---
		_set_body_collision_enabled(true)

		if combat:
			combat.reset_posture()
		emit_signal("posture_recovered")

func take_deathblow(_attacker: Node) -> void:
	if _phase == Phase.DEAD:
		return

	_attack_sequence_id += 1
	_combo_interrupted = true
	_combo_should_continue = false
	_in_combo_sequence = false
	_attack_chain_count = 0
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_behavior_state = BehaviorState.IDLE

	_cleanup_hitbox()
	_release_snare()  # FIX: free player from grab on deathblow
	_hide_parry_indicator()

	hp -= deathblow_damage
	hp = max(0, hp)

	_dbroken_active = false
	_set_body_collision_enabled(true)

	if hp <= 0:
		_die()
	else:
		if combat:
			combat.reset_posture()
		_attack_cooldown = _rng.randf_range(0.8, 1.2)
		velocity = Vector2.ZERO
		
func on_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func is_deathblow_ready() -> bool:
	return _dbroken_active and _phase != Phase.DEAD

func receive_deathblow(attacker: Node) -> void:
	# DeathblowSystem prefers this method name
	take_deathblow(attacker)

# =============================================================================
# DEATH
# =============================================================================
func death() -> void:
	_die()
	
func _die() -> void:
	if _phase == Phase.DEAD:
		return
	
	if not mark_dead():
		return
	
	_phase = Phase.DEAD
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	
	_attack_sequence_id += 1
	
	_hide_parry_indicator()
	_cleanup_hitbox()
	_cleanup_masses()
	_cleanup_mass_hitboxes()
	_release_snare()
	_release_all_attack_director_state()
	
	if has_node("CollisionShape2D"):
		$CollisionShape2D.set_deferred("disabled", true)
	
	if _bars_container:
		_bars_container.visible = false
	
	if is_in_group("miniboss"):
		remove_from_group("miniboss")
	
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
		await get_tree().create_timer(1.0).timeout
	else:
		if sprite:
			var tw := create_tween()
			tw.tween_property(sprite, "modulate:a", 0.0, 0.5)
			await tw.finished
		else:
			await get_tree().create_timer(0.5).timeout
	
	if is_instance_valid(self):
		if sprite:
			sprite.visible = false
		queue_free()

func _cleanup_masses() -> void:
	for m in _active_masses:
		if is_instance_valid(m):
			var hitbox_node = m.get_node_or_null("Hitbox")
			if hitbox_node:
				hitbox_node.set_deferred("monitoring", false)
				hitbox_node.set_deferred("monitorable", false)
			m.linear_velocity = Vector2.ZERO
			m.queue_free()
	_active_masses.clear()
	
func _update_bars() -> void:
	if _hp_fill:
		var pct = clamp(float(hp) / float(get_max_hp()), 0.0, 1.0)
		_hp_fill.size.x = 54.0 * pct

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


func _get_facing_direction() -> Vector2:
	if sprite and sprite.flip_h:
		return Vector2.RIGHT
	return Vector2.LEFT


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


func _play_anim(anim_name: String) -> void:
	if not anim or _phase == Phase.DEAD:
		return
	if anim.has_animation(anim_name) and anim.current_animation != anim_name:
		anim.play(anim_name)


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
	return lash_damage

var _body_collision_was_disabled := false

func _set_body_collision_enabled(enabled: bool) -> void:
	var cs := get_node_or_null("CollisionShape2D")
	if cs == null:
		return

	if enabled:
		if _body_collision_was_disabled:
			cs.set_deferred("disabled", false)
			_body_collision_was_disabled = false
	else:
		# Only disable if currently enabled (avoid stomping other logic)
		if not cs.disabled:
			cs.set_deferred("disabled", true)
			_body_collision_was_disabled = true

func _player_hidden_in_smoke(player: Node2D) -> bool:
	if not is_instance_valid(player):
		return false
	return player.has_meta("in_smoke_cloud") and player.get_meta("in_smoke_cloud")
