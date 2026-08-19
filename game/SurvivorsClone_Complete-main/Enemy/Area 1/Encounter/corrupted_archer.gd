extends HumanoidEnemyBase
class_name CorruptedArcher

## =============================================================================
## ARCHER - v4.3 SEKIRO COMBAT (SMOOTH MOVEMENT FIX)
## =============================================================================
## FIXES:
## - FIXED: Patrol mode now faces movement direction correctly
## - FIXED: Added hysteresis to prevent oscillation at range boundaries
## - FIXED: Movement commitment time prevents rapid direction changes
## - FIXED: Smoother velocity transitions with lerping
## - FIXED: Better corner avoidance with wall detection
## - Natural, fluid movement that doesn't jitter
## =============================================================================

# States
enum ArcherState {
	IDLE,
	ENGAGE,     # Moving to optimal range
	AIM,        # Winding up shot
	SHOOT,      # Firing arrow
	RECOVER,    # Post-shot recovery
	REPOSITION, # Strafing/repositioning
	BACKOFF     # Fleeing from melee range
}

@export var indicator_light_red = preload("res://Textures/Enemy/indicator1.png")
@export var indicator_medium_red = preload("res://Textures/Enemy/indicator2.png")
@export var indicator_dark_red = preload("res://Textures/Enemy/indicator3.png")

# SEKIRO-STYLE STATS - With hysteresis buffers
@export var optimal_range_min = 120.0
@export var optimal_range_max = 160.0
@export var min_range = 50.0
@export var max_range = 220.0
@export var projectile_scene: PackedScene = null
@export var projectile_speed = 140.0
@export var projectile_damage = 2
@export var aim_duration = 0.6
@export var shoot_duration = 0.35
@export var recover_duration = 0.7
@export var shot_cooldown = 4.5
@export var reposition_interval = 2.5

# Hysteresis buffers - prevent oscillation at boundaries
const RANGE_HYSTERESIS = 15.0  # Buffer zone to prevent flip-flopping

# Movement smoothing
const VELOCITY_LERP_SPEED = 8.0  # How fast velocity changes
const MIN_MOVEMENT_COMMIT_TIME = 0.3  # Minimum time to commit to a direction
const WALL_CHECK_DISTANCE = 40.0  # Distance to check for walls
# Add near other constants (around line 50)
const STUCK_THRESHOLD = 3.0            # If moved less than this, considered stuck
const STUCK_CHECK_INTERVAL = 0.5       # How often to check if stuck
var _stuck_position = Vector2.ZERO
var _stuck_check_timer: float = 0.0
var _is_stuck = false

# Predictive aiming
@export var lead_prediction = true
@export var prediction_strength = 0.7

# Deflection tracking
var _active_projectiles: Array = []
var _deflect_posture_cost = 15.0

# State machine
var _state = ArcherState.IDLE
var _state_timer = 0.0
var _reposition_type = 0
var _last_reposition_time = 0.0
var _shots_fired = 0

# Smooth movement
var _target_velocity = Vector2.ZERO  # What we're lerping toward
var _movement_commit_timer = 0.0     # How long until we can change direction
var _last_movement_decision = ""     # Track what decision we made
var _was_in_optimal_range = false    # Hysteresis tracking

# Animation tracking
var _current_anim: String = ""
var _last_pos: Vector2 = Vector2.ZERO
var _last_move_speed: float = 0.0
# Add these variables near the top with other movement tracking vars (around line 74)
var _facing_lock_timer = 0.0           # Prevents rapid flip-flopping
const FACING_DEADZONE = 20.0           # Larger deadzone for stability
const FACING_LOCK_TIME = 0.15          # Minimum time between facing changes

# Player tracking
var _player_velocity = Vector2.ZERO
var _player_last_pos = Vector2.ZERO

const CombatControllerScript = preload("res://Utility/CombatController.gd")

func _load_default_projectile_if_needed() -> void:
	if projectile_scene != null:
		return
	
	var paths := [
		"res://Enemy/Area 1/Encounter/corrupted_archer_projectile.tscn",
		"res://Enemy/corrupted_archer_projectile.tscn",
		"res://Enemy/archer_projectile.tscn"
	]
	
	for path in paths:
		if ResourceLoader.exists(path):
			projectile_scene = load(path) as PackedScene
			return
			
func _ready() -> void:
	hp = 40
	experience = 2
	movement_speed = 50.0
	
	can_block = true
	block_by_default = false
	
	add_to_group("archer")
	add_to_group("ranged")
	
	if not has_node("Combat"):
		var c = CombatControllerScript.new()
		c.name = "Combat"
		add_child(c)

	super._ready()
	_load_default_projectile_if_needed()

	var players = get_tree().get_nodes_in_group("player")
	for n in players:
		if n.has_node("HurtBox"):
			player = n
			_player_last_pos = player.global_position
			break

	_last_pos = global_position
	
	if hurt_box and not hurt_box.is_connected("hurt", Callable(self, "_on_archer_hurt")):
		hurt_box.connect("hurt", Callable(self, "_on_archer_hurt"))

	# FIX: ensure walk loops (prevents "slide after a little bit" during continuous retreat)
	if anim and anim.has_animation("walk"):
		var a = anim.get_animation("walk")
		if a:
			a.loop_mode = Animation.LOOP_LINEAR
	
	print("[Archer] v4.3 - Smooth Movement Fix")
	
func _physics_process(delta: float) -> void:
	_state_timer += delta
	_movement_commit_timer = max(0.0, _movement_commit_timer - delta)
	
	# Stuck detection - check if we've barely moved
	_stuck_check_timer += delta
	if _stuck_check_timer >= STUCK_CHECK_INTERVAL:
		_stuck_check_timer = 0.0
		var moved_dist = global_position.distance_to(_stuck_position)
		_is_stuck = moved_dist < STUCK_THRESHOLD and _target_velocity.length() > 10.0
		_stuck_position = global_position
		
		# If stuck, clear any cached lateral direction to try a new escape
		if _is_stuck and has_meta("backoff_lateral"):
			remove_meta("backoff_lateral")
			
	# Track player velocity for predictive aiming (use player's velocity if available; smooth it)
	if is_instance_valid(player):
		var player_pos = player.global_position
		var raw_vel := Vector2.ZERO

		# Prefer true velocity (stable), fallback to finite-diff
		if player is CharacterBody2D:
			raw_vel = player.velocity
		else:
			raw_vel = (player_pos - _player_last_pos) / max(delta, 0.001)

		_player_last_pos = player_pos

		# Exponential smoothing to remove jitter spikes (especially during accel/decel)
		var alpha := 1.0 - exp(-delta * 12.0)
		_player_velocity = _player_velocity.lerp(raw_vel, alpha)
	
		if _humanoid_shared_tick(delta):
			_update_movement_tracking(delta)
			_update_animation_state()
			return
		
	if not is_instance_valid(player):
		super._physics_process(delta)
		_update_animation_state()
		_update_patrol_facing()
		return

	var now = Time.get_ticks_msec() * 0.001

	# Handle stun
	if now < stunned_until:
		velocity = knockback
		move_and_slide()
		_update_movement_tracking(delta)
		_update_animation_state()
		return

	# Pre-aggro (patrol mode)
	if not _saw_player_once and not auto_aggro_on_spawn:
		super._physics_process(delta)
		_update_movement_tracking(delta)
		_update_animation_state()
		_update_patrol_facing()
		if combat:
			combat.update_host_state(is_attacking, false, false, velocity.length() > 0.1)
		return

	# Backoff override - but don't interrupt active attacks
	if now < _backoff_until and _state not in [ArcherState.AIM, ArcherState.SHOOT]:
		_state = ArcherState.BACKOFF

	# State machine
	_run_state_machine(delta)

	# SMOOTH VELOCITY - Lerp toward target instead of instant changes
	velocity = velocity.lerp(_target_velocity, VELOCITY_LERP_SPEED * delta)

	# Stop tiny movements
	if velocity.length() < 3.0:
		velocity = Vector2.ZERO

	move_and_slide()
	_update_movement_tracking(delta)
	_update_animation_state()

	# Stable facing (deadzone + prefer movement direction while moving)
	_update_combat_facing()

	if combat:
		combat.update_host_state(is_attacking, false, false, velocity.length() > 0.1)

func _update_patrol_facing() -> void:
	if not is_instance_valid(sprite):
		return
	if velocity.length() > 5.0:
		sprite.flip_h = (velocity.x < 0)

func _run_state_machine(delta: float) -> void:
	# Smoke conceal: do not target the player while they're inside smoke.
	# If we were mid-aim/shoot, abort cleanly.
	if is_instance_valid(player) and player.has_meta("in_smoke_cloud") and player.get_meta("in_smoke_cloud"):
		if _state == ArcherState.AIM or _state == ArcherState.SHOOT:
			_release_archer_token()
			telegraphing = false
			is_attacking = false
			_hide_parry_indicator()
			_change_state(ArcherState.ENGAGE)
		_target_velocity = Vector2.ZERO
		return

	var to_p = player.global_position - global_position
	var dist = to_p.length()
	var dir = to_p / max(dist, 0.001)
	var now = Time.get_ticks_msec() * 0.001
	
	var player_charging = _is_player_charging_at_us()
	var kiting = _is_kite_shot()
	
	match _state:
		ArcherState.IDLE:
			_target_velocity = Vector2.ZERO
			if dist < max_range:
				_change_state(ArcherState.ENGAGE)
		
		ArcherState.ENGAGE:
			_process_engage_state(dist, dir, player_charging, now)
		
		ArcherState.AIM:
			# FIX: do NOT cancel the shot just because the player rushed into min_range.
			# If we're kiting, keep running while aiming.
			if kiting:
				_apply_kite_movement(dir)
			else:
				_target_velocity = Vector2.ZERO
			
			if _state_timer >= aim_duration:
				_change_state(ArcherState.SHOOT)
		
		ArcherState.SHOOT:
			# Kiting shots keep moving during release.
			if kiting:
				_apply_kite_movement(dir)
			else:
				_target_velocity = Vector2.ZERO
			
			if _state_timer >= shoot_duration:
				_change_state(ArcherState.RECOVER)
		
		ArcherState.RECOVER:
			# Kiting recover keeps moving; normal recover stays mostly still.
			if kiting:
				_apply_kite_movement(dir)
			else:
				_target_velocity = Vector2.ZERO
				
				if _state_timer > recover_duration * 0.6:
					if dist < min_range:
						_target_velocity = -dir * movement_speed * 0.4
			
			if _state_timer >= recover_duration:
				# After a kite-shot, if still close, keep backing off; otherwise re-engage.
				if kiting and dist < optimal_range_min:
					_change_state(ArcherState.BACKOFF)
				else:
					_change_state(ArcherState.ENGAGE)
		
		ArcherState.REPOSITION:
			_execute_reposition(dir, dist)
			
			if _state_timer > 1.5:
				_last_reposition_time = now
				_change_state(ArcherState.ENGAGE)
		
		ArcherState.BACKOFF:
			_process_backoff_state(dist, dir, now)

func _process_engage_state(dist: float, dir: Vector2, player_charging: bool, now: float) -> void:
	# Emergency backoff if player charging close
	if player_charging and dist < optimal_range_min:
		_change_state(ArcherState.BACKOFF)
		return
	
	# Definite too close - must backoff
	if dist < min_range - RANGE_HYSTERESIS:
		_change_state(ArcherState.BACKOFF)
		return
	
	var in_optimal_range = false
	
	if _was_in_optimal_range:
		in_optimal_range = dist >= (optimal_range_min - RANGE_HYSTERESIS) and dist <= (optimal_range_max + RANGE_HYSTERESIS)
	else:
		in_optimal_range = dist >= optimal_range_min and dist <= optimal_range_max
	
	_was_in_optimal_range = in_optimal_range
	
	if in_optimal_range:
		# Normal shot in ideal range
		if _can_shoot():
			if has_meta("kite_shot"):
				remove_meta("kite_shot")
			_change_state(ArcherState.AIM)
		elif now - _last_reposition_time > reposition_interval:
			_change_state(ArcherState.REPOSITION)
		else:
			_set_movement_target(Vector2.ZERO, "hold")
	elif dist < optimal_range_min:
		# Retreating: allow "kiting" shots while backing up
		if _can_shoot(true):
			set_meta("kite_shot", true)
			_change_state(ArcherState.AIM)
			return
		_set_movement_target(-dir * movement_speed * 0.5, "retreat")
	elif dist > optimal_range_max and dist < max_range:
		_set_movement_target(dir * movement_speed * 0.6, "advance")
	else:
		_set_movement_target(dir * movement_speed * 0.8, "advance_fast")
		
func _process_backoff_state(dist: float, dir: Vector2, now: float) -> void:
	# Calculate backoff direction with wall avoidance
	var backoff_dir = -dir
	var adjusted_dir = _get_wall_avoiding_direction(backoff_dir)

	# FIX: Only generate lateral once, and keep it longer
	# Also flip lateral if we detect we're stuck
	if not has_meta("backoff_lateral"):
		var lateral_sign = 1.0 if randf() > 0.5 else -1.0
		set_meta("backoff_lateral", lateral_sign * randf_range(0.15, 0.30))
		set_meta("backoff_lateral_set_time", now)
	elif _is_stuck:
		# Flip the lateral direction when stuck
		var old_lat = float(get_meta("backoff_lateral", 0.15))
		set_meta("backoff_lateral", -old_lat)
		_is_stuck = false  # Reset stuck flag after adjusting

	var lat_amt = float(get_meta("backoff_lateral", 0.15))
	var lateral = Vector2(-dir.y, dir.x) * lat_amt

	var final_dir = (adjusted_dir + lateral).normalized()
	_target_velocity = final_dir * movement_speed * 1.1

	# Allow shooting while running away (kite-shot)
	if _state_timer >= 0.25 and _can_shoot(true):
		set_meta("kite_shot", true)
		_change_state(ArcherState.AIM)
		return

	# Exit backoff when safe - but DON'T clear lateral immediately
	if dist >= optimal_range_min + RANGE_HYSTERESIS and now >= _backoff_until:
		# Only clear lateral if it's been set for a while
		var lat_set_time = float(get_meta("backoff_lateral_set_time", 0.0))
		if now - lat_set_time > 1.0:
			if has_meta("backoff_lateral"):
				remove_meta("backoff_lateral")
			if has_meta("backoff_lateral_set_time"):
				remove_meta("backoff_lateral_set_time")
		_change_state(ArcherState.ENGAGE)
		
func _set_movement_target(new_velocity: Vector2, decision_type: String) -> void:
	# If we're committed to a different movement, don't change yet
	if _movement_commit_timer > 0 and _last_movement_decision != decision_type:
		# Only override if the new decision is urgent (like retreating)
		if decision_type != "retreat" and decision_type != "advance_fast":
			return
	
	_target_velocity = new_velocity
	_last_movement_decision = decision_type
	
	# Commit to this movement for a bit
	if new_velocity.length() > 5.0:
		_movement_commit_timer = MIN_MOVEMENT_COMMIT_TIME

## Check for walls and return adjusted direction - improved with fan rays and stuck escape
func _get_wall_avoiding_direction(desired_dir: Vector2) -> Vector2:
	var space_state = get_world_2d().direct_space_state
	if space_state == null:
		return desired_dir
	
	# Primary ray check
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + desired_dir * WALL_CHECK_DISTANCE,
		1  # Collision mask for walls/terrain
	)
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	
	if result.is_empty() and not _is_stuck:
		return desired_dir  # No wall, go straight
	
	# Wall detected or stuck - need to find escape route
	var wall_normal = result.get("normal", Vector2.ZERO) if not result.is_empty() else Vector2.ZERO
	
	# Try sliding along wall first
	if wall_normal != Vector2.ZERO and not _is_stuck:
		var slide_dir = desired_dir.slide(wall_normal).normalized()
		if slide_dir.length() > 0.1:
			# Verify slide direction is clear
			var slide_query = PhysicsRayQueryParameters2D.create(
				global_position,
				global_position + slide_dir * WALL_CHECK_DISTANCE,
				1
			)
			slide_query.exclude = [self]
			if space_state.intersect_ray(slide_query).is_empty():
				return slide_dir
	
	# Fan ray check - try multiple angles to find escape
	var best_dir = desired_dir
	var best_dist = 0.0
	
	# Check 8 directions around the archer
	for i in range(8):
		var angle = i * PI * 0.25  # 45 degree increments
		var test_dir = Vector2.RIGHT.rotated(angle)
		
		var fan_query = PhysicsRayQueryParameters2D.create(
			global_position,
			global_position + test_dir * WALL_CHECK_DISTANCE * 1.5,
			1
		)
		fan_query.exclude = [self]
		
		var fan_result = space_state.intersect_ray(fan_query)
		
		var clear_dist = WALL_CHECK_DISTANCE * 1.5
		if not fan_result.is_empty():
			clear_dist = global_position.distance_to(fan_result["position"])
		
		# Prefer directions that are somewhat aligned with desired direction
		var alignment = test_dir.dot(desired_dir) * 0.3 + 0.7  # Slight preference for desired dir
		var score = clear_dist * alignment
		
		if score > best_dist:
			best_dist = score
			best_dir = test_dir
	
	return best_dir
	
func _execute_reposition(dir: Vector2, dist: float) -> void:
	# FIX: do NOT re-randomize direction every frame.
	# Cache the random choices once per REPOSITION in _change_state().
	var new_vel = Vector2.ZERO

	var perp_sign: float = float(get_meta("reposition_perp_sign", 1.0))
	var lateral_amt: float = float(get_meta("reposition_lateral_amt", 0.0))
	var angle_sign: float = float(get_meta("reposition_angle_sign", 1.0))

	match _reposition_type:
		0:  # Strafe perpendicular
			var perp = Vector2(-dir.y, dir.x) * perp_sign
			new_vel = perp * movement_speed * 0.75
		1:  # Retreat while maintaining angle
			var retreat = -dir * 0.7
			var lateral = Vector2(-dir.y, dir.x) * lateral_amt
			new_vel = (retreat + lateral).normalized() * movement_speed * 0.6
		2:  # Angle shift (circle around player)
			var angle_offset = PI * 0.3 * angle_sign
			var new_dir = dir.rotated(angle_offset)
			new_vel = new_dir * movement_speed * 0.5

	# Apply wall avoidance
	if new_vel.length() > 0:
		var adjusted = _get_wall_avoiding_direction(new_vel.normalized())
		new_vel = adjusted * new_vel.length()

	_target_velocity = new_vel

	# FIX: remove the per-frame cycling (was causing rapid jitter)
	# (Do not modify _reposition_type here.)

func _is_player_charging_at_us() -> bool:
	if not is_instance_valid(player):
		return false
	
	var player_speed = _player_velocity.length()
	if player_speed < 80.0:
		return false
	
	var player_dir = _player_velocity.normalized()
	var to_us = (global_position - player.global_position).normalized()
	
	return player_dir.dot(to_us) > 0.6

func _change_state(new_state: ArcherState) -> void:
	# Clear kite-shot mode whenever we move into non-shooting states
	if new_state in [ArcherState.IDLE, ArcherState.ENGAGE, ArcherState.REPOSITION, ArcherState.BACKOFF]:
		if has_meta("kite_shot"):
			remove_meta("kite_shot")

	# If we are leaving REPOSITION, advance the type ONCE (not every frame)
	if _state == ArcherState.REPOSITION and new_state != ArcherState.REPOSITION:
		_reposition_type = (_reposition_type + 1) % 3
		if has_meta("reposition_perp_sign"):
			remove_meta("reposition_perp_sign")
		if has_meta("reposition_lateral_amt"):
			remove_meta("reposition_lateral_amt")
		if has_meta("reposition_angle_sign"):
			remove_meta("reposition_angle_sign")

	match _state:
		ArcherState.AIM:
			_hide_parry_indicator()

	_state = new_state
	_state_timer = 0.0
	_movement_commit_timer = 0.0

	match new_state:
		ArcherState.AIM:
			_start_aim()
		ArcherState.SHOOT:
			_fire_arrow()
		ArcherState.REPOSITION:
			set_meta("reposition_perp_sign", 1.0 if randf() > 0.5 else -1.0)
			set_meta("reposition_lateral_amt", randf_range(-0.35, 0.35))
			set_meta("reposition_angle_sign", 1.0 if randf() > 0.5 else -1.0)
		ArcherState.BACKOFF:
			_movement_commit_timer = 0.0

func _can_shoot(allow_close: bool = false) -> bool:
	# Smoke conceal: cannot aim/shoot while player is inside smoke
	if is_instance_valid(player) and player.has_meta("in_smoke_cloud") and player.get_meta("in_smoke_cloud"):
		return false

	var now = Time.get_ticks_msec() * 0.001
	if now < next_swipe_time or telegraphing or is_attacking:
		return false

	if is_instance_valid(player):
		var dist = global_position.distance_to(player.global_position)

		# Never fire when basically overlapping (prevents degenerate point-blank spam)
		if dist < 18.0:
			return false

		# Normal behavior: don't shoot if too close
		if not allow_close:
			if dist < min_range * 1.2:
				return false
	
	return true

func _start_aim() -> void:
	if not has_attack_token:
		if not _request_role("ranged_attack"):
			if has_meta("kite_shot"):
				remove_meta("kite_shot")
			_change_state(ArcherState.ENGAGE)
			return
		
		has_attack_token = true

	telegraphing = true

	if not _is_kite_shot():
		_target_velocity = Vector2.ZERO

	_show_parry_indicator(aim_duration, false)

	if anim and anim.has_animation("attack_windup"):
		anim.play("attack_windup")
		var base_len = anim.get_animation("attack_windup").length
		anim.speed_scale = base_len / max(0.001, aim_duration)
	
	if is_instance_valid(player) and is_instance_valid(sprite):
		var to_player = player.global_position - global_position
		sprite.flip_h = to_player.x < 0.0
		
func _fire_arrow() -> void:
	telegraphing = false
	is_attacking = true
	
	# FIX: Ensure facing player when firing
	if is_instance_valid(player) and is_instance_valid(sprite):
		var to_player = player.global_position - global_position
		sprite.flip_h = to_player.x < 0.0

	if anim and anim.has_animation("shoot"):
		anim.play("shoot")
		var base_len = anim.get_animation("shoot").length
		anim.speed_scale = base_len / max(0.001, shoot_duration)

	_hide_parry_indicator()

	if projectile_scene and is_instance_valid(player):
		var shot_speed = max(projectile_speed, 220.0)

		var target_pos = player.global_position
		target_pos = _get_predicted_target_pos(global_position, target_pos, shot_speed)

		var dir = (target_pos - global_position).normalized()

		var p = projectile_scene.instantiate()
		p.rotation = dir.angle()

		p.set_meta("shooter_id", get_instance_id())
		p.set_meta("shooter", self)
		p.set_meta("faction", "enemy")
		p.set_meta("attacker", self)
		p.set_meta("parryable", true)
		p.set_meta("damage", projectile_damage)

		if p is Area2D:
			p.collision_layer = 2
			p.collision_mask = 2

		if p.has_method("launch"):
			p.launch(dir, shot_speed, projectile_damage)
		elif p.has_method("initialize"):
			p.initialize(dir, shot_speed, projectile_damage)

		# FIX: Add to tree FIRST, then set global_position
		# Setting global_position on orphan nodes is unreliable
		get_tree().current_scene.add_child(p)
		p.global_position = global_position

		_active_projectiles.append(p)
		_shots_fired += 1

	var now = Time.get_ticks_msec() * 0.001
	var cooldown_variance = randf_range(-0.5, 0.5)
	next_swipe_time = now + shot_cooldown + cooldown_variance

	get_tree().create_timer(shoot_duration).timeout.connect(_release_archer_token)
	
func _release_archer_token() -> void:
	is_attacking = false
	telegraphing = false
	
	_release_role("ranged_attack")
	has_attack_token = false
	
	_set_anim_speed_safe(1.0)

func on_parried(player_pos: Vector2) -> void:
	_hide_parry_indicator()
	
	if _state == ArcherState.AIM or _state == ArcherState.SHOOT:
		_release_archer_token()
		telegraphing = false
		is_attacking = false
		
		add_posture_damage(_deflect_posture_cost)
		
		var now = Time.get_ticks_msec() * 0.001
		_backoff_until = now + 1.5
		
		_change_state(ArcherState.BACKOFF)
		return
	
	var dir_vec = global_position - player_pos
	if dir_vec.length_squared() < 0.001:
		dir_vec = Vector2.RIGHT
	
	apply_knockback(dir_vec.normalized() * 90.0)
	hitstop_local(0.08)
	add_posture_damage(_deflect_posture_cost)
	
	var now = Time.get_ticks_msec() * 0.001
	stunned_until = now + 0.35
	_backoff_until = now + 1.0
	
	_change_state(ArcherState.BACKOFF)

func _crowd_force_backoff(duration: float) -> void:
	var now = Time.get_ticks_msec() * 0.001
	_backoff_until = now + duration
	
	if _state == ArcherState.AIM or _state == ArcherState.SHOOT:
		_release_archer_token()
		telegraphing = false
		is_attacking = false
		_hide_parry_indicator()

func _on_archer_hurt(_damage: int, _damage_type: String, _attacker: Node = null) -> void:
	if has_died:
		return
	
	var now = Time.get_ticks_msec() * 0.001
	_backoff_until = now + 1.2
	
	if _state == ArcherState.AIM or _state == ArcherState.SHOOT:
		return
	
	_change_state(ArcherState.BACKOFF)
	
func _update_movement_tracking(delta: float) -> void:
	var moved = global_position - _last_pos
	_last_move_speed = moved.length() / max(0.0001, delta)
	_last_pos = global_position

func _update_animation_state() -> void:
	if not anim:
		return

	# FIX: Attack animations must have priority even while kiting/moving.
	# Do not let walk override windup/shoot.
	if telegraphing or is_attacking:
		return

	var is_moving = _last_move_speed > 8.0

	if is_moving:
		if anim.has_animation("walk"):
			if anim.current_animation != "walk" or not anim.is_playing():
				anim.play("walk")
			_current_anim = "walk"
			anim.speed_scale = clamp(_last_move_speed / max(1.0, movement_speed), 0.4, 1.3)
	else:
		if anim.has_animation("idle"):
			if anim.current_animation != "idle" or not anim.is_playing():
				anim.play("idle")
			_current_anim = "idle"
			anim.speed_scale = 1.0
		elif anim.has_animation("walk"):
			if anim.current_animation != "walk" or not anim.is_playing():
				anim.play("walk")
			_current_anim = "walk"
			anim.speed_scale = 0.0

func _is_kite_shot() -> bool:
	return bool(get_meta("kite_shot", false))

func _apply_kite_movement(dir: Vector2) -> void:
	# Same geometry as BACKOFF, but slightly less extreme so it doesn't look like panic fleeing.
	var backoff_dir = -dir
	var adjusted_dir = _get_wall_avoiding_direction(backoff_dir)

	if not has_meta("backoff_lateral"):
		var sign = 1.0 if randf() > 0.5 else -1.0
		set_meta("backoff_lateral", sign * randf_range(0.10, 0.22))

	var lat_amt: float = float(get_meta("backoff_lateral", 0.15))
	var lateral = Vector2(-dir.y, dir.x) * lat_amt
	var final_dir = (adjusted_dir + lateral).normalized()

	_target_velocity = final_dir * movement_speed * 1.0

func _cleanup_active_projectiles() -> void:
	for p in _active_projectiles:
		if is_instance_valid(p):
			p.queue_free()
	
	_active_projectiles.clear()
	
func death() -> void:
	_release_archer_token()
	_cleanup_active_projectiles()
	super.death()

func _exit_tree() -> void:
	_release_archer_token()
	_cleanup_active_projectiles()
	super._exit_tree()

func _update_combat_facing() -> void:
	if not is_instance_valid(sprite):
		return
	if not is_instance_valid(player):
		return

	# Lock facing during windup/attack to avoid flicker mid-telegraph
	if telegraphing or is_attacking:
		return
	
	# Cooldown to prevent rapid flip-flopping
	if _facing_lock_timer > 0:
		_facing_lock_timer -= get_physics_process_delta_time()
		return

	var to_player = player.global_position - global_position

	# Prefer facing movement direction when we're actually moving
	var face_vec = to_player
	if velocity.length() > 20.0 and abs(velocity.x) > 10.0:
		face_vec = velocity

	# Larger deadzone to prevent flip jitter when x is near 0
	if abs(face_vec.x) < FACING_DEADZONE:
		return
	
	# Determine desired facing
	var want_flip = face_vec.x < 0.0
	
	# Only apply cooldown if we're actually changing direction
	if sprite.flip_h != want_flip:
		sprite.flip_h = want_flip
		_facing_lock_timer = FACING_LOCK_TIME
		
func _get_predicted_target_pos(shooter_pos: Vector2, target_pos: Vector2, proj_speed: float) -> Vector2:
	if not lead_prediction:
		return target_pos

	# Cap tracked speed so dodge spikes (500) don't cause extreme over-leading.
	# Also helps noisy velocity reads.
	var v = _player_velocity
	var max_track := 260.0
	if v.length() > max_track:
		v = v.normalized() * max_track

	var speed := v.length()
	if speed < 40.0:
		return target_pos

	var t := _compute_intercept_time(shooter_pos, target_pos, v, max(1.0, proj_speed))
	if t <= 0.0:
		t = shooter_pos.distance_to(target_pos) / max(1.0, proj_speed)

	# Hard clamp prevents “aiming into next week” when proj speed is low / target jukes.
	var max_lead_time := 0.65
	t = clamp(t, 0.0, max_lead_time)

	# Dynamic strength: more lead at higher player speed; less lead at long lead-times.
	var speed_factor = clamp((speed - 40.0) / 180.0, 0.0, 1.0)  # player base speed is 180
	var time_factor = clamp(1.0 - (t / max_lead_time) * 0.35, 0.65, 1.0)

	var strength = clamp(prediction_strength * speed_factor * time_factor, 0.0, 0.85)

	var full_pred = target_pos + v * t
	return target_pos.lerp(full_pred, strength)

func _compute_intercept_time(shooter_pos: Vector2, target_pos: Vector2, target_vel: Vector2, proj_speed: float) -> float:
	# Solve |(target_pos + target_vel*t) - shooter_pos| = proj_speed * t
	var r := target_pos - shooter_pos
	var a := target_vel.dot(target_vel) - proj_speed * proj_speed
	var b := 2.0 * r.dot(target_vel)
	var c := r.dot(r)

	# Nearly linear case
	if abs(a) < 0.0001:
		if abs(b) < 0.0001:
			return -1.0
		var tlin := -c / b
		return tlin if tlin > 0.0 else -1.0

	var disc := b * b - 4.0 * a * c
	if disc < 0.0:
		return -1.0

	var sqrt_disc := sqrt(disc)
	var t1 := (-b - sqrt_disc) / (2.0 * a)
	var t2 := (-b + sqrt_disc) / (2.0 * a)

	var best := 1e20
	if t1 > 0.0:
		best = min(best, t1)
	if t2 > 0.0:
		best = min(best, t2)

	return best if best < 1e10 else -1.0
