extends HumanoidEnemyBase
class_name CorruptedSwordsman

## =============================================================================
## CORRUPTED SWORDSMAN
## =============================================================================
## Default Area 1 humanoid melee enemy.
##
## Owns:
## - soldier-specific patrol / engage / defend / attack HFSM
## - basic swing / quick thrust / cross swing / running swing
## - counterattack behavior after blocking
## - Corrupted Swordsman tuning values
##
## Inherits from:
## EnemyBase -> shared health, damage, posture, hitstop, knockback, death/reward helpers
## HumanoidEnemyBase -> blocking, parry indicator, humanoid attack runtime cleanup
## =============================================================================

# =============================================================================
# ATTACK TYPES - ALL BLOCKABLE
# =============================================================================
enum AttackType {
	BASIC_SWING,      # Standard single swing (parryable)
	QUICK_THRUST,     # Fast thrust attack (parryable - NOT unblockable anymore)
	CROSS_SWING,      # Two diagonal slashes combo
	RUNNING_SWING     # Approach + overhead slash
}

# =============================================================================
# CORE STATS
# =============================================================================
@export var suppress_parry_auto_walk: bool = false

# =============================================================================
# COMBAT STATE
# =============================================================================
var _hold_band_entered_at: float = -1.0

var _block_until: float = 0.0
var _block_cooldown_until: float = 0.0

# =============================================================================
# ATTACK TUNING - FAST AND RESPONSIVE
# =============================================================================
@export var attack_start_min_range: float = 15.0
@export var attack_start_max_range: float = 75.0
@export var parry_knockback_force: float = 120.0
@export var parry_window: float = 0.45
@export var parry_posture_gain: float = 25.0


# Base telegraph/swing values - FAST
@export var telegraph_time: float = 0.55  # Quick windup
@export var swipe_cooldown_min: float = 0.5   # Very fast cooldown
@export var swipe_cooldown_max: float = 1.2   # Max cooldown
@export var swipe_damage: int = 6
@export var swipe_range: float = 62.0
@export var parry_recoil_time: float = 0.50
@export var inner_attack_min_range: float = 10.0
@export var hold_distance: float = 55.0  # CLOSER hold distance

# =============================================================================
# ATTACK-SPECIFIC TUNING - ALL BLOCKABLE
# =============================================================================
@export_group("Quick Thrust")
@export var thrust_damage: int = 8
@export var thrust_range: float = 70.0
@export var thrust_telegraph_time: float = 0.48 
@export var thrust_lunge_speed: float = 350.0
@export var thrust_lunge_time: float = 0.15
@export var thrust_chance: float = 0.25

@export_group("Cross Swing")
@export var cross_damage_per_hit: int = 5
@export var cross_range: float = 58.0
@export var cross_telegraph_time: float = 0.52
@export var cross_swing_delay: float = 0.25
@export var cross_chance: float = 0.30

@export_group("Running Swing")
@export var running_damage: int = 8
@export var running_range: float = 65.0
@export var running_telegraph_time: float = 0.50
@export var running_approach_speed: float = 320.0
@export var running_min_distance: float = 80.0
@export var running_chance: float = 0.35

@export_group("Behavior Variance")
@export var telegraph_variance: float = 0.08     # Random +/- to telegraph time
@export var idle_sway_amount: float = 8.0        # Subtle position variance when idle
@export var movement_smoothing: float = 0.15     # Velocity interpolation factor
@export var wall_check_distance: float = 25.0    # Distance to check for walls
@export var hesitation_chance: float = 0.4            # Chance to hesitate instead of attack
@export var observation_time_min: float = 0.6         # Min time watching before allowed to attack
@export var observation_time_max: float = 1.4         # Max observation time
@export var watch_orbit_speed: float = 35.0           # Speed when circling/watching
@export var watch_distance: float = 85.0              # Distance to maintain when watching

@export_group("Proactive Combat")
## Time before enemy forces an attack even if player is passive
@export var max_passive_time: float = 2.5
## Time enemy will commit to attacking once in range
@export var commitment_duration: float = 1.5
## Minimum time between ANY two attacks (prevents spam)
@export var attack_gap_minimum: float = 0.7
## Delay between cross swing hits (must be reactable)
@export var cross_swing_hit_delay: float = 0.45
## Delay before follow-up/counter attacks
@export var followup_delay: float = 0.5

var _observation_until: float = 0.0       # Must observe until this time before attacking
var _last_hesitation_time: float = 0.0    # Cooldown on hesitation checks
var _orbit_direction: int = 1             # 1 or -1 for circle direction
var _watching_mode: bool = false          # True when another enemy is attacking
var _smoothed_velocity: Vector2 = Vector2.ZERO
var _idle_sway_offset: Vector2 = Vector2.ZERO
var _idle_sway_timer: float = 0.0
var _reposition_cooldown: float = 0.0
var _stuck_check_timer: float = 0.0
var _last_combat_pos: Vector2 = Vector2.ZERO
var _last_attack_ended_at: float = 0.0       # Tracks when ANY attack finished
var _passive_timer: float = 0.0              # How long player has been passive
var _commitment_until: float = 0.0           # Committed to attacking until this time
var _player_last_action_time: float = 0.0    # Last time player did something
var _force_attack_soon: bool = false         # Flag to force next attack opportunity

# =============================================================================
# CLOSE RANGE COMBAT - IMMEDIATE RESPONSE
# =============================================================================
@export_group("Close Combat")
@export var close_combat_range: float = 50.0  # Within this = fight immediately
@export var counter_attack_chance: float = 0.8  # 80% chance to counter after block
@export var counter_attack_delay: float = 0.15  # Quick counter

# Movement tuning - MINIMAL MOVEMENT IN COMBAT
@export var pre_pause_min: float = 0.02
@export var pre_pause_max: float = 0.06
@export var dash_speed: float = 350.0
@export var dash_time: float = 0.12
@export var swing_step_speed: float = 180.0
@export var swing_step_time: float = 0.10
@export var recover_lock: float = 0.05  # Very fast recovery
@export var start_delay_min: float = 0.01
@export var start_delay_max: float = 0.05
@export var cooldown_jitter: float = 0.10
@export var dwell_jitter: float = 0.10
@export var close_attack_threshold: float = 55.0

# =============================================================================
# AI HFSM + ENGAGEMENT
# =============================================================================
enum AIState { IDLE, ENGAGE, DEFEND, ATTACK, STUNNED, DEAD }

@export var far_dist: float = 200.0
@export var mid_dist: float = 100.0
@export var close_dist: float = 55.0
@export var approach_speed: float = 90.0
@export var orbit_speed: float = 25.0  # REDUCED - less circling
@export var stepback_speed: float = 30.0
@export var defend_min: float = 0.8  # Very short defend
@export var defend_max: float = 1.8
@export var dash_min_dist: float = 25.0
@export var dash_player_away_min: float = 12.0

var _patrol_theta: float = 0.0
var _patrol_force_move: bool = false

var ai_state: int = AIState.IDLE
var _state_t: float = 0.0
var _defend_until: float = 0.0
var _engaged: bool = false
var _dbreak_immunity_until: float = 0.0

var _dbroken_active: bool = false
var _dbreak_until: float = 0.0

var _last_token_frame: int = -1
var _seen_tokens_this_frame: Dictionary = {}

# Current attack tracking
var _current_attack_type: int = AttackType.BASIC_SWING
var _combo_hits_remaining: int = 0
var _thrust_hit_player: bool = false
var _in_running_approach: bool = false
var _last_attack_type: int = AttackType.BASIC_SWING

var _prepause_until: float = 0.0
var _cooldown_mul: float = 1.0
var _dwell_mul: float = 1.0

# =============================================================================
# SEPARATION & ORBITING - REDUCED
# =============================================================================
@export var separation_radius: float = 35.0  # Smaller separation
@export var separation_push: float = 50.0   # Less push
var _vel_target: Vector2 = Vector2.ZERO
var _orbit_dir: float = 1.0

var _recent_hurt_sources: Dictionary = {}
const _HURT_SOURCE_TTL := 0.12

var state: String = "walk"
func set_state(s: String) -> void:
	state = s

@onready var snd_hit = $snd_hit
@onready var attack_timer = Timer.new()
@export var DEBUG_SHOW_ENEMY_HITBOX: bool = true

signal remove_from_array(object)

func _ready() -> void:
	_humanoid_base_ready()
	# Shared humanoid combat polish tuning.
	humanoid_can_counter_after_block = true
	humanoid_counter_chance = counter_attack_chance
	humanoid_counter_delay = counter_attack_delay
	humanoid_counter_cooldown = followup_delay + 0.85
	humanoid_counter_min_attack_gap = attack_gap_minimum
	humanoid_counter_thrust_chance = thrust_chance
	
	_connect_attack_director_signal("role_released", Callable(self, "_on_ad_role_released"))
	
	ai_state = AIState.IDLE
	_state_t = 0.0
	_defend_until = 0.0
	_orbit_dir = 1.0 if (randi() & 1) == 0 else -1.0
	
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	_cooldown_mul = rng.randf_range(1.0 - cooldown_jitter, 1.0 + cooldown_jitter)
	_dwell_mul = rng.randf_range(1.0 - dwell_jitter, 1.0 + dwell_jitter)
	
	print("[CorruptedSwordsman] v1.0 - Humanoid soldier enemy active")

	_smoothed_velocity = Vector2.ZERO
	_last_combat_pos = global_position
	_idle_sway_timer = randf() * TAU
	_orbit_direction = 1 if randf() < 0.5 else -1
	_observation_until = Time.get_ticks_msec() * 0.001 + randf_range(0.5, 1.0)
	
	_last_attack_ended_at = Time.get_ticks_msec() * 0.001
	_passive_timer = 0.0
	_commitment_until = 0.0
	_player_last_action_time = Time.get_ticks_msec() * 0.001
	_force_attack_soon = false

func _physics_process(delta):
	var direction = Vector2.ZERO
	if is_instance_valid(player):
		direction = global_position.direction_to(player.global_position)
	
	var now = Time.get_ticks_msec() / 1000.0
	
	# Keep token state consistent with AttackDirector.
	_sync_attack_token_with_director(now)
	
	# Posture break recovery and post-break rapid decay.
	_tick_posture_break_recovery(now)
	_tick_post_break_decay(delta, now)
	
	# Stunned.
	if now < stunned_until:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_movement_anim()
		return
	
	# Shared stance / prosthetic / hitstop / knockback / posture processing.
	if _humanoid_shared_tick(delta):
		_update_movement_anim()
		return
	
	if _smoothed_velocity == Vector2.ZERO and velocity != Vector2.ZERO:
		_smoothed_velocity = velocity
	
	# Blocking.
	_update_blocking(delta, now)
	
	# Default before HFSM.
	velocity = knockback

	# Soldier-specific HFSM.
	_hfsm_tick(delta)

	# Attack movement must be applied AFTER HFSM so it cannot be overwritten
	# by engage/defend movement in the same physics frame.
	if telegraphing or swinging or is_attacking:
		if now < _lunge_until:
			velocity = _lunge_dir * _lunge_speed + knockback
		else:
			velocity = knockback
	elif _in_running_approach:
		if is_instance_valid(player):
			velocity = direction * running_approach_speed + knockback
		else:
			velocity = knockback

	# Sprite facing after HFSM updates movement intent.
	_update_sprite_facing()
	
	# Frost stance slow.
	var _frost_speed_mult = float(get_meta("_stance_frost_speed_mult", 1.0))
	if _frost_speed_mult < 1.0:
		velocity *= _frost_speed_mult
	
	move_and_slide()
	_update_movement_anim()

func _update_movement_anim() -> void:
	if anim == null:
		return
	
	var is_moving = velocity.length() > 5.0
	
	if is_moving:
		if anim.has_animation("walk") and anim.current_animation != "walk":
			anim.play("walk")
	else:
		if anim.has_animation("idle"):
			if anim.current_animation == "walk":
				anim.play("idle")
		elif anim.current_animation == "walk":
			anim.stop()

func _update_sprite_facing() -> void:
	super._update_sprite_facing()

func _trigger_posture_break(duration: float) -> void:
	_dbroken_active = true
	_dbreak_until = Time.get_ticks_msec() * 0.001 + duration
	_dbreak_immunity_until = _dbreak_until + 0.5

	# Cancel any post-break decay if we re-break immediately
	set_meta("_post_break_decay_active", false)

	_set_blocking(false)
	_cancel_attack()

	stunned_until = _dbreak_until

	if anim and anim.has_animation("stagger"):
		anim.play("stagger")

	if sprite:
		var tw = create_tween()
		tw.tween_property(sprite, "modulate", Color(1.0, 0.5, 0.5), 0.1)
		tw.tween_property(sprite, "modulate", Color.WHITE, duration - 0.1)

func _on_base_posture_meter_filled() -> void:
	if not _dbroken_active:
		_trigger_posture_break(4.0)
		
func is_deathblow_ready() -> bool:
	return _dbroken_active

func receive_deathblow(attacker: Node) -> void:
	_soft_reset_humanoid_attack_runtime()

	_in_running_approach = false
	_combo_hits_remaining = 0
	
	if anim:
		anim.stop()
	
	_set_anim_speed_safe(1.0)
	
	if anim:
		if anim.has_animation("hurt"):
			anim.play("hurt")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
	
	force_kill_hp()
	death()

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	# Any real interaction cancels post-break rapid decay so posture behaves normally.
	set_meta("_post_break_decay_active", false)

	var frame_now = Engine.get_frames_drawn()
	if frame_now != _last_token_frame:
		_seen_tokens_this_frame.clear()
		_last_token_frame = frame_now

	if attacker is Area2D and attacker.has_meta("swing_token"):
		var tk = str(attacker.get_meta("swing_token"))
		if _seen_tokens_this_frame.has(tk):
			return
		_seen_tokens_this_frame[tk] = true

	if attacker is Area2D:
		var now_ts2 = Time.get_ticks_msec() * 0.001
		var key = int(attacker.get_instance_id())
		var exp = float(_recent_hurt_sources.get(key, 0.0))
		if now_ts2 < exp:
			return
		_recent_hurt_sources[key] = now_ts2 + _HURT_SOURCE_TTL

		if _recent_hurt_sources.size() > 32:
			var now_prune = now_ts2
			for k in _recent_hurt_sources.keys():
				if float(_recent_hurt_sources[k]) <= now_prune:
					_recent_hurt_sources.erase(k)

	var now_ts = Time.get_ticks_msec() * 0.001
	if now_ts < _dbreak_immunity_until and damage_type != "knockback":
		return

	var source := _resolve_hurt_source(attacker)

	if source and is_instance_valid(source) and source.is_in_group("enemy"):
		return

	if attacker != null:
		var is_attack_area = (attacker is Area2D) and attacker.is_in_group("attack")
		var is_enemy_body = (attacker is CharacterBody2D or attacker is Node2D) and attacker.is_in_group("enemy")
		if is_enemy_body and not is_attack_area:
			return

	if damage_type == "knockback":
		if attacker is Node2D:
			apply_knockback(attacker.global_position.direction_to(global_position) * damage)
		return

	var response := _get_incoming_attack_response(damage, damage_type, attacker)

	var blocked = false
	var is_heavy_attack = bool(response.get("heavy", false))

	var can_block_now = can_block and not telegraphing and not _dbroken_active
	if is_attacking and not _attack_recovery:
		can_block_now = false
	
	var is_blockable_type = bool(response.get("blockable", true))
	if damage_type == "true" or damage_type == "unblockable":
		is_blockable_type = false

	if can_block_now and is_blockable_type:
		if _block_active:
			blocked = true
		elif _is_frontal_attack(attacker):
			blocked = true

	var hp_damage = int(round(float(damage) * float(response.get("hp_mult", 1.0))))

	if blocked:
		hp_damage = 0
		_block_stagger_until = now_ts + float(response.get("block_stagger", BLOCK_STAGGER_TIME))
		_on_block_impact(attacker, is_heavy_attack, response)
	else:
		_block_stagger_until = now_ts + _get_heavy_block_stagger_time()
		
		add_posture_damage(float(response.get("posture_on_hit", damage * 0.5)))
		
		var hit_kb := float(response.get("hit_knockback", 0.0))
		if hit_kb > 0.0:
			var kb_source: Node = source if source else attacker
			if kb_source is Node2D:
				var kb_dir = (global_position - kb_source.global_position).normalized()
				apply_knockback(kb_dir * hit_kb)
		
		hitstop_local(float(response.get("hitstop_hit", 0.06)))

	apply_hp_damage(hp_damage)

	if hp_damage > 0:
		var is_crit = false
		if source and source.has_method("is_critical_strike") and source.is_critical_strike():
			is_crit = true
		
		var display_type = "critical" if is_crit else damage_type
		show_enemy_damage_number(hp_damage, display_type, -20.0)

	notify_combat_got_hit({
		"damage": damage,
		"blocked": blocked,
		"damage_type": damage_type
	})

	# Smoke Slash bonus: first sword hit after leaving smoke cloud.
	if not blocked and hp_damage > 0:
		if is_instance_valid(player) and player.has_meta("smoke_slash_ready") and player.get_meta("smoke_slash_ready"):
			var bonus_hp = int(hp_damage * 0.5)
			var bonus_posture = 8.0
			apply_hp_damage(bonus_hp)
			add_posture_damage(bonus_posture)
			show_enemy_damage_number(bonus_hp, "prosthetic", -25.0)
			player.set_meta("smoke_slash_ready", false)

	# Bloodletting Gourd: lifesteal on sword HP damage.
	if not blocked and hp_damage > 0 and is_instance_valid(player):
		ProstheticEffects.check_lifesteal(player, hp_damage)

	if hp <= 0:
		death()
	else:
		snd_hit.play()
		
# =============================================================================
# PARRY HANDLING
# =============================================================================

func on_parried(player_pos: Vector2) -> void:
	# Parry = interrupt decay; posture should proceed normally from here
	set_meta("_post_break_decay_active", false)

	_set_contact_damage_enabled(false)

	_soft_reset_humanoid_attack_runtime()

	_in_running_approach = false
	_combo_hits_remaining = 0

	# --- CRITICAL FIX: never remain in ATTACK after a parry ---
	# If we stay in AIState.ATTACK, _state_attack_tick() used to do nothing,
	# and the fallback velocity code makes the enemy mindlessly run at player forever.
	_switch_state(AIState.STUNNED)

	var dir_vec = global_position - player_pos
	if dir_vec.length_squared() < 0.0001:
		dir_vec = Vector2.RIGHT
	var dir = dir_vec.normalized()

	knockback = Vector2.ZERO
	apply_knockback(dir * parry_knockback_force)

	var now = Time.get_ticks_msec() * 0.001
	var recoil = max(0.4, parry_recoil_time)
	stunned_until = now + recoil
	next_swipe_time = max(next_swipe_time, stunned_until + 0.15)

	_block_stagger_until = stunned_until

	if combat:
		add_posture_damage(parry_posture_gain)
	else:
		if not has_meta("_parry_count"):
			set_meta("_parry_count", 0)
		var count = get_meta("_parry_count") + 1
		set_meta("_parry_count", count)
		if count >= 3:
			set_meta("_parry_count", 0)
			_trigger_posture_break(4.0)

	var flash = ColorRect.new()
	flash.color = Color(1, 1, 1, 0.6)
	flash.size = Vector2(40, 40)
	flash.position = Vector2(-20, -20)
	flash.z_index = 100
	add_child(flash)

	var t = create_tween()
	t.tween_property(flash, "modulate:a", 0.0, 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	t.tween_callback(func():
		if is_instance_valid(flash):
			flash.queue_free()
	)

	hitstop_local(0.12)

	if anim and anim.has_animation("parried"):
		anim.stop()
		anim.play("parried")
		if anim.has_animation("walk"):
			anim.queue("walk")

	notify_combat_got_hit({"parried": true})

	_parry_gen += 1
	var my_gen = _parry_gen
	await get_tree().create_timer(recoil).timeout
	if my_gen != _parry_gen:
		return

	knockback = Vector2.ZERO
	velocity = Vector2.ZERO
	_do_after(0.06, func(): _set_contact_damage_enabled(true))
	if next_swipe_time < Time.get_ticks_msec() * 0.001 + 0.15:
		next_swipe_time = Time.get_ticks_msec() * 0.001 + 0.15
	if not suppress_parry_auto_walk:
		_resume_movement_anim()

	_release_attack_token()

	# --- CRITICAL FIX: ensure we re-enter normal decision logic after stun ---
	if not has_died and ai_state != AIState.DEAD:
		_switch_state(AIState.ENGAGE)

func freeze_interrupt() -> void:
	# Cancel any in-progress attack — mirrors parry cleanup, no knockback.
	_set_contact_damage_enabled(false)

	_full_reset_humanoid_attack_runtime()

	_in_running_approach = false
	_combo_hits_remaining = 0

	_switch_state(AIState.STUNNED)
	
func _hfsm_tick(delta: float) -> void:
	_state_t += delta
	var _now_s = Time.get_ticks_msec() * 0.001
	
	match ai_state:
		AIState.IDLE:
			_state_idle_tick(delta)
		AIState.ENGAGE:
			_state_engage_tick(delta)
		AIState.DEFEND:
			_state_defend_tick(delta)
		AIState.ATTACK:
			_state_attack_tick(delta)
		AIState.STUNNED:
			_state_stunned_tick(delta)


func _state_idle_tick(delta: float) -> void:
	_try_proximity_aggro()
	
	if not _saw_player_once and not auto_aggro_on_spawn:
		_patrol_step(delta)
		return
	
	_switch_state(AIState.ENGAGE)


func _state_engage_tick(delta: float) -> void:
	if not is_instance_valid(player):
		return

	_engaged = true
	_reposition_cooldown = max(0.0, _reposition_cooldown - delta)

	var to_p = player.global_position - global_position
	var dist = to_p.length()
	var dir = to_p / max(0.001, dist)

	# CONFUSION: autoload overrides movement and handles move_and_slide internally
	if ProstheticEffects.override_movement(self, delta):
		return

	# === SMOKE CLOUD: don't engage player while they're in smoke ===
	if is_instance_valid(player) and player.has_meta("in_smoke_cloud") and player.get_meta("in_smoke_cloud"):
		velocity = _get_idle_sway(delta) * 2.0 + knockback
		return

	if dist > deaggro_radius:
		_engaged = false
		_switch_state(AIState.IDLE)
		return

	var now_s = Time.get_ticks_msec() * 0.001
	
	# Process any queued counter-attacks from blocking.
	# If a counter starts, stop normal engage logic from overwriting it.
	var was_counter_queued := _humanoid_counter_queued
	_tick_humanoid_counter_queue(now_s)

	if was_counter_queued and (telegraphing or is_attacking or swinging or ai_state == AIState.ATTACK):
		return
	
	# Check if stuck against wall during combat
	_check_combat_stuck(delta)

	# === TRACK PLAYER PASSIVITY ===
	_update_player_passivity(delta)

	# === CHECK IF WE SHOULD FORCE ENGAGEMENT ===
	var should_force_attack = _should_force_proactive_attack(now_s)

	# === COMMITMENT SYSTEM: Once committed, stay aggressive ===
	var is_committed = now_s < _commitment_until

	# === WATCHING MODE: Only watch if another enemy is MID-SWING ===
	_watching_mode = _is_another_enemy_mid_swing()

	# If we're committed or forcing attack, ignore watching mode
	if is_committed or should_force_attack:
		_watching_mode = false

	if _watching_mode and not should_force_attack:
		_do_watch_movement(delta, dir, dist)
		return

	# === CLOSE RANGE COMBAT - BE AGGRESSIVE ===
	if dist <= close_combat_range:
		if not is_committed and _commitment_until < now_s:
			_commitment_until = now_s + commitment_duration
			is_committed = true

		var skip_hesitation = _passive_timer > 1.5 or is_committed or should_force_attack

		if not skip_hesitation and _should_hesitate_smart(now_s):
			var sway = _get_idle_sway(delta) * 0.5
			velocity = sway + knockback
			return

		if _can_attack_now(now_s):
			_try_attack()
			return

		var sway2 = _get_idle_sway(delta)
		var micro_approach = dir * 15.0 if dist > 35.0 else Vector2.ZERO
		velocity = sway2 + micro_approach + knockback
		return

	# === NORMAL ATTACK RANGE ===
	if dist <= attack_start_max_range and dist >= attack_start_min_range:
		var skip_hesitation2 = _passive_timer > 2.0 or should_force_attack

		if not skip_hesitation2 and _should_hesitate_smart(now_s):
			_do_approach_movement(delta, dir, dist)
			return

		if _can_attack_now(now_s):
			_try_attack()
			return

	# FIX (#2/#3): if we're in/near hold band and can't attack, stop hard-chasing and enter DEFEND
	if dist <= hold_distance and dist > close_combat_range:
		if not should_force_attack and not is_committed and not _can_attack_now(now_s):
			_switch_state(AIState.DEFEND)
			return

	# === MOVEMENT - Approach with purpose ===
	_do_approach_movement(delta, dir, dist)

func _state_defend_tick(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	_reposition_cooldown = max(0.0, _reposition_cooldown - delta)
	
	var to_p = player.global_position - global_position
	var dist = to_p.length()
	var dir = to_p / max(0.001, dist)
	
	var now_s = Time.get_ticks_msec() * 0.001
	
	# Track passivity in defend too
	_update_player_passivity(delta)
	
	# Only watch if another enemy is mid-swing
	_watching_mode = _is_another_enemy_mid_swing()
	
	# If player is passive, be more aggressive even in defend state
	var be_aggressive = _passive_timer > 1.5 or _should_force_proactive_attack(now_s)
	
	if _watching_mode and not be_aggressive:
		_do_watch_movement(delta, dir, dist)
		if _defend_until < now_s + 0.3:
			_defend_until = now_s + 0.3
		return
	
	# More likely to attack from defend if player is passive
	var attack_chance = 0.4 if be_aggressive else 0.25
	
	if randf() < attack_chance:
		if dist <= close_combat_range:
			if _can_attack_now(now_s):
				_try_attack()
				return
		elif dist <= attack_start_max_range and dist >= attack_start_min_range:
			if _can_attack_now(now_s):
				_try_attack()
				return
	
	# Move with purpose, not just circle
	_do_approach_movement(delta, dir, dist)
	
	if now_s > _defend_until:
		_switch_state(AIState.ENGAGE)
		
func _smooth_velocity(target: Vector2, delta: float) -> Vector2:
	# Smoothly interpolate velocity for less snappy movement
	var smoothing = movement_smoothing
	if target.length() < 10.0:
		smoothing *= 2.0  # Faster smoothing when slowing down
	_smoothed_velocity = _smoothed_velocity.lerp(target, 1.0 - pow(smoothing, delta * 60.0))
	return _smoothed_velocity


func _get_idle_sway(delta: float) -> Vector2:
	# Subtle weight-shifting movement when holding position
	_idle_sway_timer += delta
	
	# Use sine waves with different frequencies for organic movement
	var sway_x = sin(_idle_sway_timer * 0.8 + global_position.x * 0.01) * idle_sway_amount
	var sway_y = sin(_idle_sway_timer * 0.6 + global_position.y * 0.01) * idle_sway_amount * 0.5
	
	return Vector2(sway_x, sway_y)


func _compute_wall_avoidance() -> Vector2:
	# Check for nearby walls and push away from them
	var avoidance = Vector2.ZERO
	var space_state = get_world_2d().direct_space_state
	if space_state == null:
		return avoidance
	
	# Check 4 cardinal directions
	var directions = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]
	
	for dir in directions:
		var query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + dir * wall_check_distance,
			1  # Wall collision layer
		)
		query.exclude = [self]
		
		var result = space_state.intersect_ray(query)
		if not result.is_empty():
			# Wall detected - push away proportional to closeness
			var wall_dist = global_position.distance_to(result.position)
			var push_strength = 1.0 - (wall_dist / wall_check_distance)
			avoidance -= dir * push_strength * 40.0
	
	return avoidance

func _check_combat_stuck(delta: float) -> void:
	# Detect if enemy is stuck against a wall during combat
	_stuck_check_timer += delta
	
	if _stuck_check_timer >= 0.5:
		_stuck_check_timer = 0.0
		
		var moved = global_position.distance_to(_last_combat_pos)
		_last_combat_pos = global_position
		
		# If we've barely moved but should be moving, we might be stuck
		if moved < 3.0 and velocity.length() > 20.0 and _reposition_cooldown <= 0.0:
			# Try to reposition
			_trigger_reposition()

func _trigger_reposition() -> void:
	# Force a small repositioning move to get unstuck
	_reposition_cooldown = 1.5
	
	if not is_instance_valid(player):
		return
	
	# Try to move perpendicular to player direction
	var to_player = (player.global_position - global_position).normalized()
	var perpendicular = Vector2(-to_player.y, to_player.x)
	
	# Randomly pick left or right
	if randf() < 0.5:
		perpendicular = -perpendicular
	
	# Check if that direction is clear
	if _is_path_clear(perpendicular, 30.0):
		apply_knockback(perpendicular * 60.0)
	elif _is_path_clear(-perpendicular, 30.0):
		apply_knockback(-perpendicular * 60.0)
		
func _state_attack_tick(_delta: float) -> void:
	# CRITICAL FIX:
	# ATTACK state must not be a dead-end. If an attack was cancelled/parried,
	# and we are no longer telegraphing/swinging/attacking, we must return to ENGAGE
	# so distance checks + token logic resume.
	var now_s := Time.get_ticks_msec() * 0.001

	# While stunned, don't change state here (STUNNED state handles it too).
	if now_s < stunned_until:
		return

	# If an actual attack sequence is running, stay in ATTACK.
	if telegraphing or swinging or is_attacking or _in_running_approach:
		return

	# No active attack happening -> go back to ENGAGE so HFSM distance logic runs.
	_switch_state(AIState.ENGAGE)

func _state_stunned_tick(delta: float) -> void:
	velocity = knockback
	tick_base_knockback(delta)

	# CRITICAL FIX: leave STUNNED when timer expires.
	var now_s := Time.get_ticks_msec() * 0.001
	if now_s >= stunned_until and not has_died:
		_switch_state(AIState.ENGAGE)

func _switch_state(new_state: int) -> void:
	var old = ai_state
	ai_state = new_state
	_state_t = 0.0
	
	if new_state == AIState.DEFEND:
		var dwell = randf_range(defend_min, defend_max) * _dwell_mul
		_defend_until = Time.get_ticks_msec() * 0.001 + dwell
		# NEW: defenders should not keep advance permission (prevents crowding)
		_release_role("advance_move")
	
	# NEW: if we leave ENGAGE for any reason, drop advance permission
	if old == AIState.ENGAGE and new_state != AIState.ENGAGE:
		_hold_band_entered_at = -1.0
		_release_role("advance_move")
	
	# NEW: also drop advance when idling / stunned / dead (safety)
	if new_state == AIState.IDLE or new_state == AIState.STUNNED or new_state == AIState.DEAD:
		_release_role("advance_move")

func _compute_separation() -> Vector2:
	var sep = Vector2.ZERO
	for e in get_tree().get_nodes_in_group("enemy"):
		if e == self or not is_instance_valid(e):
			continue
		var diff = global_position - e.global_position
		var dist = diff.length()
		if dist < separation_radius and dist > 0.001:
			var push_str = (separation_radius - dist) / separation_radius
			sep += diff.normalized() * separation_push * push_str
	return sep

func _try_attack() -> void:
	if is_attacking or telegraphing:
		return
	
	# Cannot attack when posture is broken
	if _dbroken_active:
		return
	
	var now = Time.get_ticks_msec() * 0.001
	
	# === SPAM PREVENTION ===
	if now - _last_attack_ended_at < attack_gap_minimum:
		return
	
	if now < next_swipe_time:
		return
	
	if not _request_attack_token():
		return
	
	_current_attack_type = _select_attack_type()
	
	# Reset commitment when starting attack
	_commitment_until = now + commitment_duration
	
	match _current_attack_type:
		AttackType.BASIC_SWING:
			_start_basic_swing()
		AttackType.QUICK_THRUST:
			_start_quick_thrust()
		AttackType.CROSS_SWING:
			_start_cross_swing()
		AttackType.RUNNING_SWING:
			_start_running_swing()
		_:
			_start_custom_attack(_current_attack_type)
	
	_switch_state(AIState.ATTACK)

func _start_custom_attack(_attack_id: int) -> void:
	# Virtual — override in subclass for custom attack types
	_start_basic_swing()
	
func _select_attack_type() -> int:
	if not is_instance_valid(player):
		return AttackType.BASIC_SWING
	
	var dist = global_position.distance_to(player.global_position)
	
	# Running swing when far
	if dist >= running_min_distance:
		if randf() < running_chance:
			_last_attack_type = AttackType.RUNNING_SWING
			return AttackType.RUNNING_SWING
	
	# Weighted selection - avoid repeating
	var weights = {
		AttackType.BASIC_SWING: 0.35,
		AttackType.QUICK_THRUST: thrust_chance,
		AttackType.CROSS_SWING: cross_chance
	}
	
	if weights.has(_last_attack_type):
		weights[_last_attack_type] *= 0.3
	
	var total = 0.0
	for w in weights.values():
		total += w
	
	var roll = randf() * total
	var cumulative = 0.0
	
	for atype in weights.keys():
		cumulative += weights[atype]
		if roll <= cumulative:
			_last_attack_type = atype
			return atype
	
	_last_attack_type = AttackType.BASIC_SWING
	return AttackType.BASIC_SWING

func _start_swipe_telegraph() -> void:
	_start_basic_swing()


func _perform_token_swipe() -> void:
	_perform_basic_swing()
	

func _spawn_token_swipe_hitbox(dmg: int, is_telegraph: bool) -> void:
	_spawn_attack_hitbox(dmg, swipe_range, is_telegraph)


func _cancel_telegraph() -> void:
	_cancel_attack()


func _start_basic_swing() -> void:
	if telegraphing or is_attacking:
		return
	if _dbroken_active:
		return
	
	telegraphing = true
	_apply_shock_attack_penalty()
	_parry_gen += 1
	var my_gen = _parry_gen
	
	_release_role("advance_move")
	
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
	
	await get_tree().process_frame
	
	_spawn_attack_hitbox(swipe_damage, swipe_range, true)
	
	var wind = _compute_wind_time(telegraph_time)
	var total_duration = wind + active_window + 0.15
	_show_parry_indicator(total_duration, false)
	
	if anim and anim.has_animation("attack_windup"):
		var base_len = anim.get_animation("attack_windup").length
		anim.speed_scale = base_len / wind
		anim.play("attack_windup")
	
	await get_tree().create_timer(wind).timeout
	
	# NEW: if invalidated, abort instead of silently returning stuck in windup/telegraph
	if my_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	
	telegraphing = false
	_set_anim_speed_safe(1.0)
	
	_perform_basic_swing()

func _perform_basic_swing() -> void:
	if swinging or is_attacking:
		return

	await _wait_for_hitstop()

	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_gen = _attack_gen

	_spawn_attack_hitbox(swipe_damage, swipe_range, false)

	var now_s := Time.get_ticks_msec() * 0.001

	_lock_attack_facing_toward_player_or_snapshot()

	var lunge := _compute_humanoid_attack_lunge(
		swipe_range,
		swing_step_speed,
		swing_step_time,
		dash_speed,
		dash_time
	)

	_apply_humanoid_lunge(lunge, now_s)

	var anim_len := _play_attack_anim_and_get_duration(["attack", "attack_slash"], 0.40)

	# Hitbox active frames
	await get_tree().create_timer(active_window).timeout
	if my_gen != _attack_gen:
		return
	_cleanup_swipe()
	_attack_recovery = true

	# Keep enemy "in attack" until full animation ends
	var remaining = max(0.0, anim_len - active_window)
	if remaining > 0.0:
		await get_tree().create_timer(remaining).timeout
		if my_gen != _attack_gen:
			return

	_finish_attack()

func _start_quick_thrust() -> void:
	if telegraphing or is_attacking:
		return
	if _dbroken_active:
		return
	
	telegraphing = true
	_apply_shock_attack_penalty()
	_thrust_hit_player = false
	_parry_gen += 1
	var my_gen = _parry_gen
	
	_release_role("advance_move")
	
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
	
	await get_tree().process_frame
	
	_spawn_thrust_hitbox(thrust_damage, thrust_range, true)
	
	var wind = _compute_wind_time(thrust_telegraph_time)
	var total_duration = wind + thrust_lunge_time + 0.2
	_show_parry_indicator(total_duration, false)
	
	if anim:
		if anim.has_animation("thrust_windup"):
			var base_len = anim.get_animation("thrust_windup").length
			anim.speed_scale = base_len / wind
			anim.play("thrust_windup")
		elif anim.has_animation("attack_windup"):
			var base_len = anim.get_animation("attack_windup").length
			anim.speed_scale = base_len / wind
			anim.play("attack_windup")
	
	await get_tree().create_timer(wind).timeout
	
	if my_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	
	telegraphing = false
	_set_anim_speed_safe(1.0)
	
	_perform_quick_thrust()

func _perform_quick_thrust() -> void:
	if swinging or is_attacking:
		return

	await _wait_for_hitstop()

	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_gen = _attack_gen

	_spawn_thrust_hitbox(thrust_damage, thrust_range, false)

	var now_s := Time.get_ticks_msec() * 0.001

	_lock_attack_facing_toward_player_or_snapshot()

	var lunge := _compute_humanoid_attack_lunge(
		thrust_range,
		thrust_lunge_speed * 0.45,
		thrust_lunge_time * 0.65,
		thrust_lunge_speed,
		thrust_lunge_time
	)

	_apply_humanoid_lunge(lunge, now_s)

	var anim_len := _play_attack_anim_and_get_duration(["thrust", "attack", "attack_slash"], thrust_lunge_time + 0.20)

	# Active frames for thrust hitbox
	var active = max(thrust_lunge_time + 0.08, active_window)
	await get_tree().create_timer(active).timeout
	if my_gen != _attack_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	_cleanup_swipe()
	_attack_recovery = true
	
	# Hold attack state until full anim ends (prevents instant extra attacks)
	var remaining = max(0.0, anim_len - active)
	if remaining > 0.0:
		await get_tree().create_timer(remaining).timeout
		if my_gen != _attack_gen:
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

	# If thrust hit, chance to follow up, enforce readable delay
	if _thrust_hit_player and randf() < 0.5:
		swinging = false

		await get_tree().create_timer(max(followup_delay, 0.45)).timeout
		if my_gen != _attack_gen:
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

		_perform_thrust_followup()
	else:
		_finish_attack()

func _perform_thrust_followup() -> void:
	"""Follow-up attacks after thrust hit - each with proper windup and indicator."""
	_combo_hits_remaining = 2
	_parry_gen += 1
	var my_parry_gen = _parry_gen
	
	# First follow-up hit (with full windup)
	await _execute_combo_swing(cross_damage_per_hit, cross_range, active_window)
	
	if my_parry_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	
	# Gap between hits
	await get_tree().create_timer(0.2).timeout
	
	if my_parry_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	
	# Second follow-up hit (with full windup)
	if _combo_hits_remaining > 0:
		await _execute_combo_swing(cross_damage_per_hit, cross_range, active_window)
	
	_finish_attack()
	
func _spawn_thrust_hitbox(dmg: int, range_val: float, is_telegraph: bool) -> void:
	if _current_swipe_area and is_instance_valid(_current_swipe_area):
		_current_swipe_area.queue_free()
		_current_swipe_area = null
	
	var area := Area2D.new()
	area.name = "ThrustArea"
	area.add_to_group("attack")
	area.set_meta("attacker", self)
	area.set_meta("damage", dmg)
	area.set_meta("swing_token", Time.get_ticks_msec())
	
	var dir := Vector2.RIGHT
	if is_instance_valid(player):
		var target_pos = _windup_player_pos0 if _windup_player_pos0 != Vector2.ZERO else player.global_position
		var dv = target_pos - global_position
		if dv.length() > 0.001:
			dir = dv.normalized()
	
	var shape := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = (14.0 if is_telegraph else 18.0)
	capsule.height = max(8.0, range_val)
	shape.shape = capsule
	shape.rotation = dir.angle() + PI / 2.0
	area.add_child(shape)
	
	area.collision_layer = 0
	area.collision_mask = 2
	
	if not is_telegraph:
		area.monitoring = true
		if not area.is_connected("area_entered", Callable(self, "_on_thrust_area_entered")):
			area.connect("area_entered", Callable(self, "_on_thrust_area_entered"))
	else:
		area.monitoring = false
	
	add_child(area)
	_current_swipe_area = area
	
	var offset := range_val * 0.55
	area.position = dir * offset
	area.set_meta("swing_dir", dir)
	area.set_meta("swing_offset", offset)

func _on_thrust_area_entered(area: Area2D) -> void:
	if area == null:
		return
	if not area.is_in_group("player_hurtbox"):
		return
	
	if _current_swipe_area and _current_swipe_area.has_meta("consumed"):
		if _current_swipe_area.get_meta("consumed"):
			return
		_current_swipe_area.set_meta("consumed", true)
	
	_thrust_hit_player = true
	
	var dmg = thrust_damage
	if _current_swipe_area and _current_swipe_area.has_meta("damage"):
		dmg = int(_current_swipe_area.get_meta("damage"))
	
	# Regular melee damage - NOT perilous
	area.emit_signal("hurt", dmg, "melee", self)

func _start_cross_swing() -> void:
	if telegraphing or is_attacking:
		return
	if _dbroken_active:
		return
	
	telegraphing = true
	_apply_shock_attack_penalty()
	_parry_gen += 1
	var my_gen = _parry_gen
	
	_release_role("advance_move")
	_combo_hits_remaining = 2
	
	if is_instance_valid(player):
		_windup_player_pos0 = player.global_position
	
	await get_tree().process_frame
	
	_spawn_attack_hitbox(cross_damage_per_hit, cross_range, true)
	
	var wind = _compute_wind_time(cross_telegraph_time)
	var total_duration = wind + active_window + max(cross_swing_hit_delay, 0.45) + active_window + 0.2
	_show_parry_indicator(total_duration, false)
	
	if anim and anim.has_animation("attack_windup"):
		var base_len = anim.get_animation("attack_windup").length
		anim.speed_scale = base_len / wind
		anim.play("attack_windup")
	
	await get_tree().create_timer(wind).timeout
	
	if my_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	
	telegraphing = false
	_set_anim_speed_safe(1.0)
	
	_perform_cross_swing_hit(1, my_gen)


func _perform_cross_swing_hit(hit_num: int, gen: int) -> void:
	if gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	await _wait_for_hitstop()

	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_attack_gen = _attack_gen

	_spawn_attack_hitbox(cross_damage_per_hit, cross_range, false)

	var now_s := Time.get_ticks_msec() * 0.001

	_lock_attack_facing_toward_player_or_snapshot()

	var lunge := _compute_humanoid_attack_lunge(
		cross_range,
		120.0,
		0.06,
		180.0,
		0.08
	)

	_apply_humanoid_lunge(lunge, now_s)

	var anim_len := _play_attack_anim_and_get_duration(["attack", "attack_slash"], 0.45)

	await get_tree().create_timer(active_window).timeout
	if gen != _parry_gen or my_attack_gen != _attack_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	_cleanup_swipe()
	swinging = false

	# Hold until full slash anim completes (prevents too-rapid combo cadence)
	var remaining = max(0.0, anim_len - active_window)
	if remaining > 0.0:
		await get_tree().create_timer(remaining).timeout
		if gen != _parry_gen or my_attack_gen != _attack_gen:
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

	if hit_num == 1 and _combo_hits_remaining > 1:
		_combo_hits_remaining -= 1

		# FULL readable windup for second hit (respect your tuning var)
		var combo_windup = max(cross_swing_hit_delay, 0.45)

		_show_parry_indicator(combo_windup + active_window + 0.15, false)

		if anim and anim.has_animation("attack_windup"):
			var base_len = anim.get_animation("attack_windup").length
			anim.speed_scale = base_len / combo_windup
			anim.play("attack_windup")

		telegraphing = true
		await get_tree().create_timer(combo_windup).timeout

		if gen != _parry_gen:
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

		telegraphing = false
		_set_anim_speed_safe(1.0)

		_perform_cross_swing_hit(2, gen)
	else:
		_finish_attack()

func _execute_combo_swing(dmg: int, range_val: float, duration: float) -> void:
	# This function MUST lock the enemy into attack state so AI can't start extra attacks.
	if _combo_hits_remaining <= 0:
		return

	var my_parry_gen = _parry_gen

	# Windup (combo)
	var combo_windup := 0.35
	_show_parry_indicator(combo_windup + duration + 0.1, false)

	if anim and anim.has_animation("attack_windup"):
		var base_len = anim.get_animation("attack_windup").length
		anim.speed_scale = base_len / combo_windup
		anim.play("attack_windup")

	telegraphing = true
	is_attacking = true
	swinging = false

	await get_tree().create_timer(combo_windup).timeout
	if my_parry_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	telegraphing = false
	_set_anim_speed_safe(1.0)

	await _wait_for_hitstop()

	# Active swing
	swinging = true
	_attack_gen += 1
	var my_attack_gen = _attack_gen

	_spawn_attack_hitbox(dmg, range_val, false)

	var now_s := Time.get_ticks_msec() * 0.001

	_lock_attack_facing_toward_player_or_snapshot()

	var lunge := _compute_humanoid_attack_lunge(
		range_val,
		swing_step_speed * 0.65,
		0.05,
		swing_step_speed * 0.90,
		0.06
	)

	_apply_humanoid_lunge(lunge, now_s)

	# Full anim duration lock (per-slash)
	_set_anim_speed_safe(1.0)
	var anim_len := _play_attack_anim_and_get_duration(["attack", "attack_slash"], 0.40)

	await get_tree().create_timer(duration).timeout
	if my_parry_gen != _parry_gen or my_attack_gen != _attack_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return

	_cleanup_swipe()
	swinging = false
	_attack_recovery = true

	var remaining = max(0.0, anim_len - duration)
	if remaining > 0.0:
		await get_tree().create_timer(remaining).timeout
		if my_parry_gen != _parry_gen or my_attack_gen != _attack_gen:
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

	_combo_hits_remaining -= 1
	# NOTE: leave is_attacking true; caller will end via _finish_attack() after final hit.

func _start_running_swing() -> void:
	if telegraphing or is_attacking:
		return
	if _dbroken_active:
		return
	
	telegraphing = true
	_apply_shock_attack_penalty()
	_in_running_approach = true
	_parry_gen += 1
	var my_gen := _parry_gen
	
	_release_role("advance_move")
	_windup_player_pos0 = Vector2.ZERO
	
	await get_tree().process_frame
	
	var approach_time := _calculate_approach_time()
	var wind = _compute_wind_time(running_telegraph_time)
	var total_duration = approach_time + wind + active_window + 0.2
	_show_parry_indicator(total_duration, false)
	
	if anim and anim.has_animation("run"):
		anim.speed_scale = 1.0
		anim.play("run")
	elif anim and anim.has_animation("walk"):
		anim.speed_scale = 1.5
		anim.play("walk")
	
	var approach_start := Time.get_ticks_msec() * 0.001
	
	while _in_running_approach and is_instance_valid(player):
		var now_s := Time.get_ticks_msec() * 0.001
		
		# If attack got invalidated (parry/cancel/token revoke), abort CLEANLY.
		if my_gen != _parry_gen:
			_in_running_approach = false
			_abort_attack_sequence(now_s)
			return
		
		# Snapshot player position near the end of the approach so windup aims correctly
		# but doesn't track continuously during the swing.
		var dist := global_position.distance_to(player.global_position)
		if dist <= close_attack_threshold + 8.0:
			_windup_player_pos0 = player.global_position
			break
		
		# Timeout: still swing (whiff is allowed), but take snapshot now.
		if now_s - approach_start > 1.2:
			_windup_player_pos0 = player.global_position
			break
		
		await get_tree().create_timer(0.04).timeout
	
	_in_running_approach = false
	
	# If invalidated right after loop, abort cleanly.
	if my_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	
	# Windup
	if anim:
		anim.speed_scale = 1.0
		if anim.has_animation("attack_windup"):
			var base_len = anim.get_animation("attack_windup").length
			anim.speed_scale = base_len / wind
			anim.play("attack_windup")
	
	await get_tree().create_timer(wind).timeout
	
	if my_gen != _parry_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	
	telegraphing = false
	_set_anim_speed_safe(1.0)
	
	_perform_running_swing()

func _calculate_approach_time() -> float:
	if not is_instance_valid(player):
		return 0.4
	var dist = global_position.distance_to(player.global_position)
	var target_dist = close_attack_threshold
	var approach_dist = max(0, dist - target_dist)
	return approach_dist / running_approach_speed

func _perform_running_swing() -> void:
	if swinging or is_attacking:
		return

	await _wait_for_hitstop()

	swinging = true
	is_attacking = true
	_attack_gen += 1
	var my_gen = _attack_gen

	_spawn_attack_hitbox(running_damage, running_range, false)

	var now_s := Time.get_ticks_msec() * 0.001

	_lock_attack_facing_toward_player_or_snapshot()

	var lunge := _compute_humanoid_attack_lunge(
		running_range,
		swing_step_speed,
		0.08,
		running_approach_speed * 0.60,
		0.12
	)

	_apply_humanoid_lunge(lunge, now_s)

	var anim_len := _play_attack_anim_and_get_duration(["attack", "attack_slash"], 0.45)

	await get_tree().create_timer(active_window).timeout
	if my_gen != _attack_gen:
		_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
		return
	_cleanup_swipe()
	_attack_recovery = true

	var remaining = max(0.0, anim_len - active_window)
	if remaining > 0.0:
		await get_tree().create_timer(remaining).timeout
		if my_gen != _attack_gen:
			_abort_attack_sequence(Time.get_ticks_msec() * 0.001)
			return

	_finish_attack()

func _spawn_attack_hitbox(dmg: int, range_val: float, is_telegraph: bool) -> void:
	if _current_swipe_area and is_instance_valid(_current_swipe_area):
		_current_swipe_area.queue_free()
		_current_swipe_area = null
	
	var area := Area2D.new()
	area.name = "SwipeArea"
	area.add_to_group("attack")
	area.set_meta("attacker", self)
	area.set_meta("damage", dmg)
	area.set_meta("swing_token", Time.get_ticks_msec())
	
	# Lock direction at windup start (snapshot), so player can dodge out and cause a whiff.
	var dir := Vector2.RIGHT
	if is_instance_valid(player):
		var target_pos = _windup_player_pos0 if _windup_player_pos0 != Vector2.ZERO else player.global_position
		var dv = target_pos - global_position
		if dv.length() > 0.001:
			dir = dv.normalized()
	
	# Capsule "blade" in front. Total forward reach is ~range_val (not 2x).
	var shape := CollisionShape2D.new()
	var capsule := CapsuleShape2D.new()
	capsule.radius = (14.0 if is_telegraph else 18.0)
	capsule.height = max(8.0, range_val)  # length of the swing
	shape.shape = capsule
	
	# Capsule is oriented along Y by default, so rotate by +PI/2 to point along dir.
	shape.rotation = dir.angle() + PI / 2.0
	area.add_child(shape)
	
	area.collision_layer = 0
	area.collision_mask = 2
	
	if not is_telegraph:
		area.monitoring = true
		if not area.is_connected("area_entered", Callable(self, "_on_swipe_area_entered")):
			area.connect("area_entered", Callable(self, "_on_swipe_area_entered"))
	else:
		area.monitoring = false
	
	add_child(area)
	_current_swipe_area = area
	
	# Fixed offset: center the capsule forward so its far tip is ~range_val from the enemy.
	var offset := range_val * 0.55
	area.position = dir * offset
	
	# Store locked values so _update_swipe_hitbox_position does not retarget.
	area.set_meta("swing_dir", dir)
	area.set_meta("swing_offset", offset)

func _on_swipe_area_entered(area: Area2D) -> void:
	if area == null:
		return
	if not area.is_in_group("player_hurtbox"):
		return
	
	if _current_swipe_area and _current_swipe_area.has_meta("consumed"):
		if _current_swipe_area.get_meta("consumed"):
			return
		_current_swipe_area.set_meta("consumed", true)
	
	var dmg = swipe_damage
	if _current_swipe_area and _current_swipe_area.has_meta("damage"):
		dmg = int(_current_swipe_area.get_meta("damage"))
	
	# NEW: read damage_type from hitbox meta (subclasses can set "unblockable", etc.)
	var dtype = "melee"
	if _current_swipe_area and _current_swipe_area.has_meta("damage_type"):
		dtype = str(_current_swipe_area.get_meta("damage_type"))
	
	area.emit_signal("hurt", dmg, dtype, self)
	
func _finish_attack() -> void:
	"""Called when any attack fully completes"""
	var now = Time.get_ticks_msec() * 0.001
	
	# === RECORD ATTACK END TIME ===
	_last_attack_ended_at = now
	
	# Clean up
	_reset_humanoid_attack_runtime()

	_in_running_approach = false
	_combo_hits_remaining = 0
	
	# Set cooldown - ensure minimum gap
	var cooldown = randf_range(swipe_cooldown_min, swipe_cooldown_max) * _cooldown_mul
	cooldown = max(cooldown, attack_gap_minimum)
	next_swipe_time = now + cooldown
	
	# Recovery lock
	_recover_lock_until = now + recover_lock
	
	# Release token
	_release_attack_token()
	
	# Post-attack behavior: sometimes defend, sometimes re-engage
	if not _force_attack_soon and randf() < 0.45:
		_switch_state(AIState.DEFEND)
	else:
		_switch_state(AIState.ENGAGE)
	
	# Resume movement animation
	_resume_movement_anim()
	
func _cancel_attack() -> void:
	"""Cancel current attack (called on parry, stun, etc.)"""
	var now = Time.get_ticks_msec() * 0.001
	
	_soft_reset_humanoid_attack_runtime()
	
	_in_running_approach = false
	_combo_hits_remaining = 0
	
	# Record as attack end for spam prevention.
	_last_attack_ended_at = now
	
	# Enforce cooldown after cancel too.
	next_swipe_time = max(next_swipe_time, now + attack_gap_minimum)

# =============================================================================
# ATTACK DIRECTOR INTEGRATION - SIMPLIFIED
# =============================================================================
func _approach_gate_ok() -> bool:
	var now_s = Time.get_ticks_msec() * 0.001
	
	if now_s < _backoff_until:
		return false
	
	if now_s < _approach_denied_until:
		return false
	
	if get_attack_director() == null:
		return true
	
	if _held_roles.has("advance_move"):
		return true
	
	if _request_role("advance_move"):
		return true
	
	_approach_denied_until = now_s + 0.3
	return false

func _on_ad_role_released(_role: String) -> void:
	pass

# =============================================================================
# DEATH
# =============================================================================
func death():
	if not mark_dead():
		return
	
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)
	
	_run_humanoid_death_rewards()
	base_death_cleanup()

func _exit_tree() -> void:
	_release_all_attack_director_state()
	
	_disconnect_attack_director_signal("role_released", Callable(self, "_on_ad_role_released"))
	_disconnect_attack_director_signal("crowd_backoff", Callable(self, "_on_crowd_backoff"))
	
func _is_another_enemy_attacking() -> bool:
	"""Check if another enemy currently has the attack token and is mid-attack."""
	if get_attack_director() == null:
		return false
	
	if has_attack_token:
		return false
	
	var duelist := _attack_director_current_duelist()
	if duelist != null and duelist != self:
		return true
	
	return _attack_director_holder_count() > 0

# =============================================================================
# NEW FUNCTION: Sekiro-style hesitation check
# =============================================================================

func _should_hesitate(now: float) -> bool:
	"""Random chance to pause and observe instead of attacking immediately"""
	# Don't spam hesitation
	if now - _last_hesitation_time < 1.5:
		return false
	
	if randf() < hesitation_chance:
		_last_hesitation_time = now
		# Start an observation period
		_observation_until = now + randf_range(observation_time_min, observation_time_max)
		return true
	
	return false

func _do_watch_movement(delta: float, to_player_dir: Vector2, dist: float) -> void:
	"""Movement when watching - approach slowly, don't just orbit"""
	var sep = _compute_separation()
	var wall_avoid = _compute_wall_avoidance()
	
	var target_vel = Vector2.ZERO
	
	if dist > watch_distance + 30.0:
		# Too far - approach more directly
		target_vel = to_player_dir * (approach_speed * 0.5) + sep
	elif dist < watch_distance - 20.0:
		# Too close - back away slightly
		var retreat = -to_player_dir * (stepback_speed * 0.7)
		target_vel = retreat + sep
	else:
		# Good distance - minimal circling, mostly hold position with sway
		var perp = Vector2(-to_player_dir.y, to_player_dir.x) * _orbit_direction
		var sway = _get_idle_sway(delta)
		
		# Very slow orbit + sway
		target_vel = perp * (watch_orbit_speed * 0.3) + sway * 0.5 + sep
		
		# Occasionally change direction
		if randf() < 0.004:
			_orbit_direction *= -1
	
	if wall_avoid.length() > 0.1:
		target_vel += wall_avoid * 0.5
	
	target_vel += knockback
	velocity = _smooth_velocity(target_vel, delta)
	
func _update_player_passivity(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	var player_is_active = false
	
	# Check if player is doing anything
	if player.has_method("is_attacking") and player.is_attacking():
		player_is_active = true
	elif player.has_node("Combat"):
		var pc = player.get_node("Combat")
		if pc and pc.has_method("is_blocking") and pc.is_blocking():
			player_is_active = true
	
	# Check player movement
	if player is CharacterBody2D and player.velocity.length() > 30.0:
		player_is_active = true
	
	if player_is_active:
		_passive_timer = 0.0
		_player_last_action_time = Time.get_ticks_msec() * 0.001
	else:
		_passive_timer += delta

func _should_force_proactive_attack(now: float) -> bool:
	# If flagged for forced attack, do it
	if _force_attack_soon:
		_force_attack_soon = false
		return true
	
	# If player has been passive too long, force engagement
	if _passive_timer >= max_passive_time:
		_passive_timer = 0.0  # Reset so we don't spam
		return true
	
	# If we haven't attacked in a while and we're in range
	var time_since_attack = now - _last_attack_ended_at
	if time_since_attack > max_passive_time + 1.0:
		if is_instance_valid(player):
			var dist = global_position.distance_to(player.global_position)
			if dist <= attack_start_max_range:
				return true
	
	return false

func _is_another_enemy_mid_swing() -> bool:
	"""Check if another enemy is currently in the middle of an attack animation"""
	for e in get_tree().get_nodes_in_group("enemy"):
		if e == self or not is_instance_valid(e):
			continue
		
		# Check if they're actually swinging (not just have token)
		var other_swinging = e.get("swinging")
		if other_swinging != null and bool(other_swinging):
			return true

		var other_attacking = e.get("is_attacking")
		var other_telegraphing = e.get("telegraphing")
		if other_attacking != null and other_telegraphing != null:
			if bool(other_attacking) and not bool(other_telegraphing):
				return true
	
	return false

func _should_hesitate_smart(now: float) -> bool:
	"""Hesitation that adapts to combat flow"""
	# Don't spam hesitation checks
	if now - _last_hesitation_time < 2.0:
		return false
	
	# Lower hesitation chance if player is passive
	var effective_chance = hesitation_chance
	if _passive_timer > 1.0:
		effective_chance *= 0.3  # Much less hesitation vs passive player
	if _passive_timer > 2.0:
		effective_chance = 0.0   # No hesitation - attack!
	
	if randf() < effective_chance:
		_last_hesitation_time = now
		# Shorter observation time
		_observation_until = now + randf_range(0.3, 0.6)
		return true
	
	return false

func _can_attack_now(now: float) -> bool:
	"""Single source of truth for whether we can attack"""
	# Basic state checks
	if telegraphing or swinging or is_attacking:
		return false
	if _dbroken_active:
		return false
	if now < stunned_until:
		return false
	if ProstheticEffects.is_confused(self):
		return false
	if now < _recover_lock_until:
		return false

	# === SPAM PREVENTION: Enforce minimum gap between attacks ===
	var time_since_last_attack = now - _last_attack_ended_at
	if time_since_last_attack < attack_gap_minimum:
		return false

	# Standard cooldown check
	if now < next_swipe_time:
		return false

	# Don't attack if another enemy is mid-swing (brief courtesy)
	# But skip this check if we've been waiting too long
	if _is_another_enemy_mid_swing() and _passive_timer < 2.0:
		return false

	# Token check
	if not has_attack_token:
		if not _request_attack_token():
			if _passive_timer > max_passive_time:
				_force_attack_soon = true
			return false

	return true

func _do_approach_movement(delta: float, dir: Vector2, dist: float) -> void:
	"""Move toward player with purpose (now respects AttackDirector spacing gate)"""
	var now_s = Time.get_ticks_msec() * 0.001
	
	var sep = _compute_separation()
	var wall_avoid = _compute_wall_avoidance()
	var target_vel = Vector2.ZERO
	
	# NEW: If we are not allowed to advance (or we're in forced backoff), do NOT keep pushing forward.
	# This is what makes enemies stop dogpiling and instead orbit/step-back.
	if not _approach_gate_ok():
		# If too close, step back; otherwise orbit at/near hold distance.
		if dist < hold_distance - 15.0:
			target_vel = (-dir) * stepback_speed + sep
		else:
			var perp = Vector2(-dir.y, dir.x) * _orbit_direction
			target_vel = perp * orbit_speed + sep * 0.85
		
		# Occasionally change orbit direction to avoid robotic movement
		if randf() < 0.01:
			_orbit_direction *= -1
		
		if wall_avoid.length() > 0.1:
			target_vel += wall_avoid * 0.6
		
		target_vel += knockback
		velocity = _smooth_velocity(target_vel, delta)
		return
	
	# NEW: DEFEND state should behave like “hold/orbit” more than “advance hard”
	if ai_state == AIState.DEFEND:
		var perp2 = Vector2(-dir.y, dir.x) * _orbit_direction
		var orbit_component = perp2 * (orbit_speed * 0.7)
		var micro_approach = dir * (approach_speed * 0.15) if dist > hold_distance + 10.0 else Vector2.ZERO
		target_vel = orbit_component + micro_approach + sep
		
		if randf() < 0.008:
			_orbit_direction *= -1
		
		if wall_avoid.length() > 0.1:
			target_vel += wall_avoid * 0.6
		
		target_vel += knockback
		velocity = _smooth_velocity(target_vel, delta)
		return
	
	# --- Existing approach logic (ENGAGE / general) ---
	if dist > hold_distance + 20.0:
		# Far away - approach directly
		var approach_dir = dir
		if wall_avoid.length() > 0.1:
			approach_dir = (dir + wall_avoid * 0.4).normalized()
		target_vel = approach_dir * approach_speed + sep
		
	elif dist > hold_distance - 10.0:
		# At hold distance - slight approach with minimal orbit
		var approach_component = dir * (approach_speed * 0.4)
		var perp = Vector2(-dir.y, dir.x) * _orbit_direction
		var orbit_component = perp * (orbit_speed * 0.3)
		target_vel = approach_component + orbit_component + sep
		
		# Occasionally change orbit direction
		if randf() < 0.005:
			_orbit_direction *= -1
	else:
		# Close - move in for attack
		target_vel = dir * (approach_speed * 0.6) + sep
	
	if wall_avoid.length() > 0.1:
		target_vel += wall_avoid * 0.5
	
	target_vel += knockback
	velocity = _smooth_velocity(target_vel, delta)

func _sync_attack_token_with_director(now: float) -> void:
	var ad := get_attack_director()
	if ad == null:
		return
	
	if not has_attack_token:
		return
	
	var duelist := _attack_director_current_duelist()
	if duelist != null and duelist != self:
		has_attack_token = false
		
		if telegraphing or swinging or is_attacking:
			_abort_attack_sequence(now)
		
		return

func _abort_attack_sequence(now: float) -> void:
	# Lightweight hard reset that prevents getting stuck in windup/attack states.
	_soft_reset_humanoid_attack_runtime()
	
	_in_running_approach = false
	_combo_hits_remaining = 0
	
	_last_attack_ended_at = now
	next_swipe_time = max(next_swipe_time, now + attack_gap_minimum)
	_recover_lock_until = max(_recover_lock_until, now + recover_lock)
	
	_switch_state(AIState.ENGAGE)
	_resume_movement_anim()

func _tick_posture_break_recovery(now_s: float) -> void:
	if not _dbroken_active:
		return

	if now_s < _dbreak_until:
		return

	# Recovery completed (player missed deathblow)
	_dbroken_active = false
	_dbreak_until = 0.0

	# DO NOT hard reset posture to 0 here.
	# Instead: start a rapid decay from current posture (typically max) downwards.
	# If the player interrupts with hit/parry, we cancel this decay (see on_parried/_on_hurt_box_hurt).
	var decay_seconds := 0.85
	var maxv := 100.0
	if combat and combat.get("config") != null:
		var cfg = combat.get("config")
		if cfg and cfg.get("posture_max") != null:
			maxv = float(cfg.get("posture_max"))

	set_meta("_post_break_decay_active", true)
	set_meta("_post_break_decay_until", now_s + decay_seconds)
	set_meta("_post_break_decay_rate", maxv / max(0.05, decay_seconds)) # posture per second

	# Full state reset.
	_soft_reset_humanoid_attack_runtime()

	_in_running_approach = false
	_combo_hits_remaining = 0

	stunned_until = 0.0
	_recover_lock_until = 0.0

	clear_hitstop_state()

	# Small grace period before next attack
	next_swipe_time = now_s + 0.4
	_last_attack_ended_at = now_s

	_switch_state(AIState.ENGAGE)
	_resume_movement_anim()

func _tick_post_break_decay(delta: float, now_s: float) -> void:
	if not has_meta("_post_break_decay_active"):
		return
	if not bool(get_meta("_post_break_decay_active")):
		return

	var until := float(get_meta("_post_break_decay_until")) if has_meta("_post_break_decay_until") else 0.0
	if now_s >= until:
		set_meta("_post_break_decay_active", false)
		return

	if combat == null:
		set_meta("_post_break_decay_active", false)
		return

	var rate := float(get_meta("_post_break_decay_rate")) if has_meta("_post_break_decay_rate") else 120.0
	var cur := get_posture_value()

	if cur <= 0.0:
		set_meta("_post_break_decay_active", false)
		return

	var next = max(0.0, cur - rate * delta)
	set_posture_value(next)

func _compute_wind_time(base_telegraph: float) -> float:
	var wind = max(0.1, base_telegraph + randf_range(-telegraph_variance, telegraph_variance))
	wind *= ProstheticEffects.get_shock_telegraph_mult(self)
	return wind
	
func _apply_shock_attack_penalty() -> void:
	# Existing prosthetic shock penalty
	var penalty = ProstheticEffects.get_shock_attack_penalty(self)
	if penalty > 0.0:
		add_posture_damage(penalty)
	
	# === STANCE EFFECTS: consume shock stacks on attack start ===
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		se.on_enemy_attack_start(self)

func _start_humanoid_counter_attack(counter_kind: String) -> void:
	if is_attacking or telegraphing or swinging:
		return
	
	if _dbroken_active:
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
	
	# Counters are allowed to bypass normal next_swipe_time.
	# After the counter begins, apply its own cooldown.
	set_meta("_humanoid_counter_cd_until", now + humanoid_counter_cooldown)
	next_swipe_time = now + followup_delay + 0.30
	
	match counter_kind:
		"thrust_poke":
			_current_attack_type = AttackType.QUICK_THRUST
			_start_quick_thrust()
		"quick_slash":
			_current_attack_type = AttackType.BASIC_SWING
			_start_basic_swing()
		_:
			_current_attack_type = AttackType.BASIC_SWING
			_start_basic_swing()
	
	_switch_state(AIState.ATTACK)
