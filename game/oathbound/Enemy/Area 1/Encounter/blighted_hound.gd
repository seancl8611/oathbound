extends BeastEnemyBase
class_name BlightedHound

## =============================================================================
## WILD DOG - v5.4 POLISHED (Parry + Pack Fix)
## =============================================================================
## FIXES IN v5.4:
## - Lunge parry indicator now appears close to impact (distance-aware), not at windup start
## - Lunge hitbox active window now aligns with the indicator (distance-aware)
## - Robust handling for AttackDirector preemption: if a role/token is revoked, dog cancels the attack cleanly
## - Optional pack control: uses AttackDirector role "dog_lunge" to prevent multiple dogs lunging simultaneously
## - Waiting dogs keep a wider orbit distance when denied approach (less clumping / fewer triple-lunges)
## =============================================================================

# =============================================================================
# STATS
# =============================================================================
@export var bite_speed: float = 180.0

@export var lunge_damage: int = 8
@export var bite_damage: int = 5
@export var hit_posture_gain: float = 0.35

# v5.3: Block posture damage (what player takes when blocking, NOT raw damage)
@export var lunge_block_posture: float = 12.0
@export var bite_block_posture: float = 8.0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
@export var parry_posture_gain: float = 35.0
@export var max_posture: float = 60.0
@export var posture_recovery_delay: float = 1.5
@export var posture_decay_rate: float = 20.0
@export var posture_break_duration: float = 2.5

var posture: float = 0.0
var _posture_recovery_ready_at: float = 0.0
var _dbroken_active: bool = false
var _dbreak_until: float = 0.0

# =============================================================================
# ATTACK TUNING - v5.2: Slightly longer windups for readability
# =============================================================================
@export var lunge_range: float = 130.0
@export var lunge_min_range: float = 50.0
@export var bite_range: float = 65.0
@export var bite_min_range: float = 20.0

@export var lunge_windup: float = 0.45      # v5.3: Was 0.40, now more readable
@export var bite_windup: float = 0.32       # v5.3: Was 0.28, now more readable
@export var lunge_active_time: float = 0.26  # v5.4: slightly larger parry/hit window
@export var lunge_window_center_bias: float = 0.55  # 0.5=center; >0.5 starts a little earlier
@export var lunge_end_lag: float = 0.06            # follow-through after active window
@export var lunge_reach_fudge: float = 12.0        # extra reach for impact estimate (player hurtbox, etc.)
@export var lunge_max_total_time: float = 0.55     # safety cap for very long lunges
@export var bite_active_time: float = 0.16
@export var recover_time: float = 0.8

@export var lunge_cd: float = 3.5
@export var bite_cd: float = 2.0
@export var attack_cd: float = 0.8

@export var parry_knockback_force: float = 80.0
@export var parry_recoil_time: float = 0.55

# =============================================================================
# HITBOX
# =============================================================================
@export var mouth_offset: Vector2 = Vector2(12, 0)
@export var bite_hitbox_size: Vector2 = Vector2(28, 20)
@export var lunge_hitbox_size: Vector2 = Vector2(36, 24)

# =============================================================================
# PATROL / AGGRO / SPACING
# =============================================================================
@export var patrol_speed: float = 35.0
@export var hold_distance: float = 70.0
@export var orbit_speed: float = 60.0

# =============================================================================
# EXPERIENCE
# =============================================================================
var exp_gem = preload("res://Objects/experience_gem.tscn")

# =============================================================================
# STATE MACHINE
# =============================================================================
enum State { PATROL, IDLE, CHASE, ORBIT, LUNGE_WINDUP, LUNGE, BITE_WINDUP, BITE, RECOVER, STAGGER, DEAD }
var state: int = State.PATROL
var _state_timer: float = 0.0

var _aggro: bool = false
var _charge_dir: Vector2 = Vector2.RIGHT
var _orbit_dir: float = 1.0

var _next_lunge_ready: float = 0.0
var _next_bite_ready: float = 0.0
var _next_attack_ready: float = 0.0

var stunned_until: float = 0.0

# =============================================================================
# HITBOX
# =============================================================================
var _hitbox_armed: bool = false
var _hitbox_consumed: bool = false

# =============================================================================
# NODE REFERENCES
# =============================================================================
@onready var hitbox: Area2D = $HitBox
@onready var hitbox_shape: CollisionShape2D = get_node_or_null("HitBox/CollisionShape2D")
@onready var snd_hit: AudioStreamPlayer2D = get_node_or_null("snd_hit")

signal remove_from_array(object)


# =============================================================================
# INITIALIZATION
# =============================================================================
func _apply_hound_defaults() -> void:
	# Only overwrite untouched base defaults.
	# This avoids fighting Inspector overrides on existing scenes.
	if hp == 200:
		hp = 65
	
	if movement_speed == 55.0:
		movement_speed = 85.0
	
	if lunge_speed == 360.0:
		lunge_speed = 270.0
	
	if experience == 1:
		experience = 2
		
func _ready() -> void:
	_apply_hound_defaults()
	super._ready()
	
	_home_pos = global_position
	_patrol_target = global_position
	_orbit_dir = 1.0 if (randi() & 1) == 0 else -1.0
	
	beast_attack_role = "dog_lunge"
	
	_setup_hitbox()
	
	print("[BlightedHound] v5.6 - Hushiro baseline")

func _setup_posture_bar() -> void:
	if _posture_ui != null:
		return
	
	_posture_ui = Node2D.new()
	_posture_ui.name = "PostureBar"
	add_child(_posture_ui)

	_posture_bg = ColorRect.new()
	_posture_bg.size = Vector2(40, 4)
	_posture_bg.position = Vector2(-20, -32)
	_posture_bg.color = Color(0.15, 0.15, 0.15, 0.85)
	_posture_ui.add_child(_posture_bg)

	_posture_fill = ColorRect.new()
	_posture_fill.size = Vector2(0, 4)
	_posture_fill.position = Vector2(-20, -32)
	_posture_fill.color = Color(0.95, 0.6, 0.1, 0.95)
	_posture_ui.add_child(_posture_fill)

	_posture_ui.visible = false

func _setup_hitbox() -> void:
	if not hitbox:
		return
	
	hitbox.collision_layer = 0
	hitbox.collision_mask = 2
	hitbox.monitoring = false
	hitbox.monitorable = true
	
	if not hitbox.is_in_group("attack"):
		hitbox.add_to_group("attack")
	
	if hitbox_shape and hitbox_shape.shape == null:
		hitbox_shape.shape = RectangleShape2D.new()
	
	if not hitbox.is_connected("area_entered", Callable(self, "_on_hitbox_area_entered")):
		hitbox.connect("area_entered", Callable(self, "_on_hitbox_area_entered"))
	
	_disarm_hitbox()

func _set_hitbox_active(active: bool) -> void:
	if not hitbox:
		return
	if not _hitbox_armed:
		return
	# Use set_deferred to avoid signal blocking errors
	hitbox.set_deferred("monitoring", active)

func _cancel_current_attack(now: float, because_revoked: bool = false) -> void:
	_bump_attack_gen()
	_hide_parry_indicator()
	_disarm_hitbox()
	_release_role(beast_attack_role)
	
	if state in [State.LUNGE_WINDUP, State.LUNGE, State.BITE_WINDUP, State.BITE, State.RECOVER]:
		_backoff_until = max(_backoff_until, now + 0.6)
		_next_attack_ready = max(_next_attack_ready, now + 0.6)
		_goto(State.ORBIT)

func _on_beast_attack_director_revoked(now: float) -> void:
	_cancel_current_attack(now, true)
	
# =============================================================================
# MAIN LOOP
# =============================================================================
func _physics_process(delta: float) -> void:
	var now = Time.get_ticks_msec() * 0.001
	
	if state == State.DEAD:
		return
	
	_sync_attack_director_roles(now)
	
	# Check deathblow window expiry
	if _dbroken_active and now >= _dbreak_until:
		_end_posture_break()
	
	# Hushiro baseline: posture waits 1.5s after pressure, then recovers at 20/s.
	if state != State.STAGGER and posture > 0 and now >= _posture_recovery_ready_at:
		posture = max(0.0, posture - posture_decay_rate * delta)
		_update_hound_posture_bar()
	
	if _state_timer > 0:
		_state_timer -= delta
	
	# Stunned check
	if now < stunned_until and state != State.STAGGER:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_sprite_facing()
		return
	
	if _beast_tick_shared(delta):
		return

	if ProstheticEffects.is_confused(self):
		# Hold a wander direction briefly to avoid per-frame flipping
		var wander: Vector2 = get_meta("_pros_wander_dir", Vector2.ZERO)
		var until: float = float(get_meta("_pros_wander_until", 0.0))

		if now >= until or wander == Vector2.ZERO:
			until = now + randf_range(0.20, 0.45)
			wander = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
			if wander == Vector2.ZERO:
				wander = Vector2.RIGHT
			set_meta("_pros_wander_until", until)
			set_meta("_pros_wander_dir", wander)

		velocity = wander * movement_speed * 0.3 + knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_sprite_facing()
		return
	
	# Smoke cloud: player hidden — stop chasing, orbit passively
	if _player_hidden_in_smoke():
		if state == State.CHASE or state == State.LUNGE_WINDUP or state == State.BITE_WINDUP:
			_release_attack_token()
			_hide_parry_indicator()
			_goto(State.ORBIT)
		if state == State.LUNGE or state == State.BITE:
			pass  # Let active attacks finish naturally
		elif state != State.ORBIT and state != State.PATROL and state != State.STAGGER and state != State.RECOVER:
			_goto(State.ORBIT)
	# State machine
	match state:
		State.PATROL:
			_state_patrol(delta, now)
		State.IDLE:
			_state_idle(delta, now)
		State.CHASE:
			_state_chase(delta, now)
		State.ORBIT:
			_state_orbit(delta, now)
		State.LUNGE_WINDUP:
			_state_lunge_windup(delta, now)
		State.LUNGE:
			_state_lunge(delta, now)
		State.BITE_WINDUP:
			_state_bite_windup(delta, now)
		State.BITE:
			_state_bite(delta, now)
		State.RECOVER:
			_state_recover(delta, now)
		State.STAGGER:
			_state_stagger(delta, now)
	
	if knockback.length() > 1.0:
		velocity += knockback
		tick_base_knockback(delta)
	
	move_and_slide()
	_update_sprite_facing()
	_update_animation()


# =============================================================================
# STATE FUNCTIONS
# =============================================================================
func _goto(new_state: int, timer: float = 0.0) -> void:
	state = new_state
	_state_timer = timer


func _state_patrol(delta: float, now: float) -> void:
	if _check_aggro():
		_goto(State.CHASE)
		return
	
	if global_position.distance_to(_patrol_target) < 10.0 or now >= _patrol_until:
		var angle = randf() * TAU
		var dist = randf_range(30.0, patrol_wander_radius)
		_patrol_target = _home_pos + Vector2(cos(angle), sin(angle)) * dist
		_patrol_until = now + randf_range(2.0, 4.0)
	
	var dir = (_patrol_target - global_position).normalized()
	velocity = dir * patrol_speed


func _state_idle(delta: float, now: float) -> void:
	velocity = Vector2.ZERO
	if _check_aggro():
		_goto(State.CHASE)


func _state_chase(delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(State.PATROL)
		return
	
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	
	if dist > deaggro_radius:
		_saw_player_once = false
		_goto(State.PATROL)
		return
	
	_charge_dir = to_player.normalized() if dist > 0.1 else Vector2.RIGHT
	
	# Check if we're on backoff
	if now < _backoff_until:
		# Orbit instead of chase
		_goto(State.ORBIT)
		return
	
	var can_attack = now >= _next_attack_ready
	var can_lunge = now >= _next_lunge_ready
	var can_bite = now >= _next_bite_ready
	
	if can_attack:
		if can_lunge and dist >= lunge_min_range and dist <= lunge_range:
			if _request_attack_token():
				# v5.4: Prevent multi-dog simultaneous lunges (optional AttackDirector role)
				if _request_lunge_role():
					_start_lunge_windup()
					return
				# Couldn't get lunge slot -> release melee token so another enemy can go
				_release_attack_token()
		
		if can_bite and dist >= bite_min_range and dist <= bite_range:
			if _request_attack_token():
				_start_bite_windup()
				return
	
	# Movement - respect advance_move gating
	var wait_dist := hold_distance
	if AttackDir != null:
		var orbit_distance = AttackDir.get("orbit_distance")
		if orbit_distance != null:
			wait_dist = max(wait_dist, float(orbit_distance) * 0.85)

	if dist > hold_distance:
		if _approach_gate_ok():
			velocity = _charge_dir * movement_speed
		else:
			# Denied approach -> keep wider orbit and avoid stacking in close range
			if dist < wait_dist - 12.0:
				velocity = -_charge_dir * movement_speed * 0.35
			else:
				var tangent = _charge_dir.rotated(PI * 0.5 * _orbit_dir)
				velocity = tangent * orbit_speed
	elif dist < bite_min_range:
		velocity = -_charge_dir * movement_speed * 0.3
	else:
		# At hold distance - orbit
		var tangent = _charge_dir.rotated(PI * 0.5 * _orbit_dir)
		velocity = tangent * orbit_speed * 0.7


func _state_orbit(delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(State.PATROL)
		return
	
	var to_player = player.global_position - global_position
	var dist = to_player.length()
	_charge_dir = to_player.normalized() if dist > 0.1 else Vector2.RIGHT
	
	# Check if backoff ended
	if now >= _backoff_until:
		_goto(State.CHASE)
		return
	
	# Orbit around player (keep spacing in packs)
	var wait_dist := hold_distance
	if AttackDir != null:
		var orbit_distance = AttackDir.get("orbit_distance")
		if orbit_distance != null:
			wait_dist = max(wait_dist, float(orbit_distance))

	if dist < wait_dist - 12.0:
		velocity = -_charge_dir * movement_speed * 0.35
	elif dist > wait_dist + 40.0:
		velocity = _charge_dir * movement_speed * 0.25
	else:
		var tangent = _charge_dir.rotated(PI * 0.5 * _orbit_dir)
		velocity = tangent * orbit_speed

func _start_lunge_windup() -> void:
	_release_role("advance_move")
	_bump_attack_gen()
	
	# Lock charge direction at start of windup
	if is_instance_valid(player):
		_charge_dir = (player.global_position - global_position).normalized()
	
	# Calculate distance-aware timing for indicator
	var dist = 0.0
	if is_instance_valid(player):
		dist = global_position.distance_to(player.global_position)
	
	# Estimate how long the lunge travel will take
	var reach = (lunge_hitbox_size.x * 0.5 + 8.0) + lunge_reach_fudge
	var dist_to_cover = max(0.0, dist - reach)
	var travel_time = dist_to_cover / max(1.0, lunge_speed)
	
	# Cap travel time to prevent absurdly long lunges
	travel_time = min(travel_time, lunge_max_total_time)
	
	# Total indicator duration: windup + travel + active window + buffer
	var total_indicator_duration = lunge_windup + travel_time + lunge_active_time + 0.1
	
	# Show parry indicator at start of windup for FULL duration
	_show_parry_indicator(total_indicator_duration, false)
	
	_goto(State.LUNGE_WINDUP, lunge_windup)

func _start_bite_windup() -> void:
	_release_role("advance_move")
	_bump_attack_gen()
	
	# Lock charge direction at start of windup
	if is_instance_valid(player):
		_charge_dir = (player.global_position - global_position).normalized()
	
	# Calculate total indicator duration: windup + active window + small buffer
	var total_indicator_duration = bite_windup + bite_active_time + 0.15
	
	# Show parry indicator IMMEDIATELY at start of windup (like enemy.gd)
	_show_parry_indicator(total_indicator_duration, false)
	
	_goto(State.BITE_WINDUP, bite_windup)
	
func _state_lunge_windup(delta: float, now: float) -> void:
	velocity = Vector2.ZERO
	
	# Track player during first 60% of windup (allows some aim adjustment)
	if is_instance_valid(player) and _state_timer > lunge_windup * 0.4:
		_charge_dir = (player.global_position - global_position).normalized()
	
	if _state_timer <= 0:
		_execute_lunge(now)
		
func _execute_lunge(now: float) -> void:
	var gen = _bump_attack_gen()
	
	# Calculate distance to player at moment of lunge execution
	var dist = 0.0
	if is_instance_valid(player):
		dist = global_position.distance_to(player.global_position)
	
	# Calculate when the dog will reach the player
	var reach = (lunge_hitbox_size.x * 0.5 + 8.0) + lunge_reach_fudge
	var dist_to_cover = max(0.0, dist - reach)
	var impact_time = dist_to_cover / max(1.0, lunge_speed)
	
	# Cap to prevent infinite lunges
	impact_time = min(impact_time, lunge_max_total_time)
	
	# Calculate when to START the active window (centered around impact with early bias)
	var hitbox_start = max(0.0, impact_time - (lunge_active_time * lunge_window_center_bias))
	var hitbox_end = hitbox_start + lunge_active_time
	
	# Total lunge state duration = until hitbox ends + end lag
	var total_lunge_time = hitbox_end + lunge_end_lag
	
	_goto(State.LUNGE, total_lunge_time)
	
	# Arm hitbox but DON'T enable it yet (enable_now = false)
	_arm_hitbox(lunge_damage, lunge_hitbox_size, lunge_block_posture, false)
	
	# Schedule hitbox ACTIVATION near predicted impact
	if hitbox_start > 0.01:
		get_tree().create_timer(hitbox_start).timeout.connect(func():
			if gen != _attack_gen:
				return
			if state != State.LUNGE:
				return
			_set_hitbox_active(true)
		)
	else:
		# Close range - activate immediately
		_set_hitbox_active(true)
	
	# Schedule hitbox DEACTIVATION after active window ends
	get_tree().create_timer(hitbox_end).timeout.connect(func():
		if gen != _attack_gen:
			return
		_set_hitbox_active(false)
	)
	
func _state_lunge(delta: float, now: float) -> void:
	velocity = _charge_dir * lunge_speed
	
	if _state_timer <= 0:
		# Attack finished - clean up
		_hide_parry_indicator()
		_disarm_hitbox()
		_release_role(beast_attack_role)
		_release_attack_token()
		_next_lunge_ready = now + lunge_cd
		_next_attack_ready = now + attack_cd
		_goto(State.RECOVER, recover_time)
		
func _state_bite_windup(delta: float, now: float) -> void:
	velocity = Vector2.ZERO
	
	# Track player during first 50% of windup (allows some aim adjustment)
	if is_instance_valid(player) and _state_timer > bite_windup * 0.5:
		_charge_dir = (player.global_position - global_position).normalized()
	
	if _state_timer <= 0:
		_execute_bite(now)
		
func _execute_bite(now: float) -> void:
	var gen = _bump_attack_gen()
	
	# Enter bite state
	_goto(State.BITE, bite_active_time)
	
	# Arm hitbox immediately when bite begins (after windup)
	_arm_hitbox(bite_damage, bite_hitbox_size, bite_block_posture, true)
	
func _state_bite(delta: float, now: float) -> void:
	velocity = _charge_dir * bite_speed
	
	if _state_timer <= 0:
		# Attack finished - clean up
		_hide_parry_indicator()
		_disarm_hitbox()
		_release_attack_token()
		_next_bite_ready = now + bite_cd
		_next_attack_ready = now + attack_cd
		_goto(State.RECOVER, recover_time)
		
func _state_recover(delta: float, now: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 300.0 * delta)
	
	if _state_timer <= 0:
		_goto(State.CHASE)


func _state_stagger(delta: float, now: float) -> void:
	velocity = knockback
	knockback = knockback.move_toward(Vector2.ZERO, 200.0 * delta)


# =============================================================================
# HITBOX - v5.3: Use stagger_on_block, set_deferred
# =============================================================================
func _arm_hitbox(damage: int, size: Vector2, block_posture: float = 10.0, enable_now: bool = true) -> void:
	if not hitbox or not hitbox_shape:
		return
	
	hitbox.position = _charge_dir * (size.x * 0.5 + 8.0)
	hitbox.rotation = _charge_dir.angle()
	
	var rect = hitbox_shape.shape as RectangleShape2D
	if rect:
		rect.size = size
	
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("damage_type", "melee")
	hitbox.set_meta("attacker", self)
	# v5.3: Use stagger_on_block (what player.gd expects) for posture damage
	hitbox.set_meta("stagger_on_block", block_posture)
	hitbox.set_meta("swing_token", Time.get_ticks_msec())
	
	_hitbox_armed = true
	_hitbox_consumed = false
	# v5.3 FIX: Use set_deferred to avoid signal blocking error
	hitbox.set_deferred("monitoring", enable_now)


func _disarm_hitbox() -> void:
	_hitbox_armed = false
	if hitbox:
		# v5.3 FIX: Use set_deferred to avoid signal blocking error
		hitbox.set_deferred("monitoring", false)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if not _hitbox_armed or _hitbox_consumed:
		return
	if not is_instance_valid(area):
		return
	if not area.is_in_group("player_hurtbox"):
		return
	
	_hitbox_consumed = true
	
	var dmg = hitbox.get_meta("damage", 5) as int
	var dmg_type = hitbox.get_meta("damage_type", "melee") as String
	
	if area.has_signal("hurt"):
		# v5.3 FIX: Pass hitbox as attacker so player can read metadata
		area.emit_signal("hurt", dmg, dmg_type, hitbox)

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if state == State.DEAD or has_died:
		return
	
	if damage <= 0 and damage_type != "knockback":
		return
	
	if damage_type == "knockback":
		if attacker is Node2D:
			apply_knockback(attacker.global_position.direction_to(global_position) * damage)
		return
	
	var hp_damage := apply_hp_damage(damage)

	# Bloodletting Gourd: lifesteal on sword HP damage.
	if hp_damage > 0 and is_instance_valid(player):
		ProstheticEffects.check_lifesteal(player, hp_damage)
	
	if hp_damage > 0:
		show_enemy_damage_number(hp_damage, damage_type, -20.0)
	
	notify_combat_got_hit({
		"damage": damage,
		"blocked": false,
		"damage_type": damage_type
	})
	
	if hp <= 0:
		death()
		return
	
	stunned_until = Time.get_ticks_msec() * 0.001 + 0.12
	
	ProstheticEffects.apply(attacker, self, false)
	
	if snd_hit:
		snd_hit.play()

# =============================================================================
# POSTURE BREAK / DEATHBLOW
# =============================================================================
func _trigger_posture_break() -> void:
	var now = Time.get_ticks_msec() * 0.001
	
	_dbroken_active = true
	_dbreak_until = now + posture_break_duration
	
	_bump_attack_gen()
	_hide_parry_indicator()
	_disarm_hitbox()
	_release_role(beast_attack_role)
	_release_attack_token()
	_release_role("advance_move")
	
	_goto(State.STAGGER, posture_break_duration)
	stunned_until = _dbreak_until
	
	if sprite:
		var tw = create_tween()
		tw.tween_property(sprite, "modulate", Color(1.0, 0.4, 0.4), 0.1)
	
	var p = get_tree().get_first_node_in_group("player")
	if p:
		var pc = p.get_node_or_null("Combat")
		if pc and pc.has_method("set_deathblow_target"):
			pc.set_deathblow_target(self, posture_break_duration)


func _end_posture_break() -> void:
	_dbroken_active = false
	posture = 0.0
	_update_hound_posture_bar()
	
	if sprite:
		sprite.modulate = Color.WHITE
	
	if state == State.STAGGER:
		_goto(State.RECOVER, 0.3)


func is_deathblow_ready() -> bool:
	return _dbroken_active

func receive_deathblow(attacker: Node) -> void:
	force_kill_hp()
	death()

func _update_hound_posture_bar() -> void:
	if not _posture_fill:
		return

	var pct = clamp(posture / max_posture, 0.0, 1.0)
	_posture_fill.size.x = 40.0 * pct

	var r = 0.95
	var g = 0.6 - (0.5 * pct)
	_posture_fill.color = Color(r, g, 0.1, 0.95)

	# Only show when posture is actually present (parries) or during deathblow/posture-break window
	if _posture_ui:
		_posture_ui.visible = (posture > 0.001) or _dbroken_active

func _check_aggro() -> bool:
	if not is_instance_valid(player):
		return false
	
	if auto_aggro_on_spawn or _saw_player_once:
		_saw_player_once = true
		return true
	
	if _aggro:
		_saw_player_once = true
		return true
	
	var dist = global_position.distance_to(player.global_position)
	if dist <= aggro_radius:
		_saw_player_once = true
		return true
	
	return false


func _update_sprite_facing() -> void:
	if not sprite:
		return
	if velocity.length() > 5.0:
		sprite.flip_h = velocity.x < 0
	elif is_instance_valid(player):
		sprite.flip_h = (player.global_position.x - global_position.x) < 0


func _update_animation() -> void:
	if not anim:
		return
	
	var anim_name = "idle"
	match state:
		State.PATROL, State.CHASE, State.ORBIT:
			anim_name = "walk" if velocity.length() > 10.0 else "idle"
		State.LUNGE_WINDUP, State.BITE_WINDUP:
			anim_name = "attack" if anim.has_animation("attack") else "idle"
		State.LUNGE, State.BITE:
			anim_name = "attack" if anim.has_animation("attack") else "walk"
		State.RECOVER:
			anim_name = "idle"
		State.STAGGER:
			anim_name = "hurt" if anim.has_animation("hurt") else "idle"
		State.DEAD:
			anim_name = "death" if anim.has_animation("death") else "idle"
	
	if anim.has_animation(anim_name) and anim.current_animation != anim_name:
		anim.play(anim_name)

func on_parried(parrier_pos: Vector2) -> void:
	_bump_attack_gen()
	_hide_parry_indicator()
	_disarm_hitbox()
	_release_role(beast_attack_role)
	_release_attack_token()
	
	var kb_dir = (global_position - parrier_pos).normalized()
	knockback = Vector2.ZERO
	apply_knockback(kb_dir * parry_knockback_force)
	hitstop_local(0.08)
	
	var now = Time.get_ticks_msec() * 0.001
	stunned_until = now + parry_recoil_time
	
	# Add posture from parry and delay recovery after fresh pressure.
	posture = min(posture + parry_posture_gain, max_posture)
	_posture_recovery_ready_at = now + posture_recovery_delay
	_update_hound_posture_bar()
	
	if posture >= max_posture:
		_trigger_posture_break()
	else:
		_goto(State.RECOVER, parry_recoil_time)
	
	# Visual feedback
	if sprite:
		var tw = create_tween()
		tw.tween_property(sprite, "modulate", Color(1.5, 1.5, 1.5), 0.05)
		tw.tween_property(sprite, "modulate", Color.WHITE, 0.15)

func _spawn_hound_rewards() -> void:
	var loot_parent := get_tree().get_first_node_in_group("loot")
	
	if loot_parent and exp_gem:
		var new_gem = exp_gem.instantiate()
		if new_gem is Node2D:
			new_gem.global_position = global_position
			new_gem.set("experience", experience)
			loot_parent.call_deferred("add_child", new_gem)
			
func death() -> void:
	if state == State.DEAD:
		return
	
	if not mark_dead():
		return
	
	_goto(State.DEAD)
	_bump_attack_gen()
	_disarm_hitbox()
	_reset_beast_runtime()
	
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)
	
	hide_posture_bar()
	notify_stance_effects_enemy_death()
	
	_spawn_hound_rewards()
	
	velocity = Vector2.ZERO
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		await get_tree().create_timer(0.5).timeout
	else:
		await get_tree().create_timer(0.3).timeout
	
	queue_free()

func _exit_tree() -> void:
	_bump_attack_gen()
	_disarm_hitbox()
	_release_role(beast_attack_role)
	_release_attack_token()
	_release_role("advance_move")
	_disconnect_beast_attack_director_signals()
	_release_all_attack_director_state()

# =============================================================================
# SIGNAL CONNECTIONS (for scene editor compatibility)
# =============================================================================
func _on_player_trigger_range_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = true


func _on_player_trigger_range_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = false

func _player_hidden_in_smoke() -> bool:
	if not is_instance_valid(player):
		return false
	return player.has_meta("in_smoke_cloud") and player.get_meta("in_smoke_cloud")
