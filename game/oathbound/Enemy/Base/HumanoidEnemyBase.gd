extends EnemyBase
class_name HumanoidEnemyBase

## =============================================================================
## HUMANOID ENEMY BASE
## =============================================================================
## Shared base for enemies that behave like armed humanoids:
## - blocking / guard state
## - block stagger timing
## - parry indicator setup/show/hide
## - frontal attack checks
## - block impact spark response
## - shared humanoid attack runtime state
## - generic attack cleanup helpers
##
## This should NOT own specific attack selection, patrol AI, HFSM, or soldier-specific move choices.
## =============================================================================

# =============================================================================
# HUMANOID BLOCKING
# =============================================================================

@export_group("Humanoid Blocking")
@export var can_block: bool = true
@export var block_by_default: bool = true
@export var block_chance_on_hit: float = 1.0
@export var block_recovery_time: float = 0.06
@export var perfect_block_window: float = 0.15

var _block_active: bool = false
var _block_stagger_until: float = 0.0

const BLOCK_STAGGER_TIME: float = 0.08
const BLOCK_STAGGER_HEAVY: float = 0.12

# =============================================================================
# SHARED HUMANOID AGGRO / PATROL
# =============================================================================

@export_group("Humanoid Awareness")
@export var aggro_radius: float = 200.0
@export var deaggro_radius: float = 300.0
@export var auto_aggro_on_spawn: bool = false

@export_group("Humanoid Patrol")
@export var patrol_wander_radius: float = 32.0
@export var patrol_step_time_min: float = 1.0
@export var patrol_step_time_max: float = 2.0
@export var patrol_pause_min: float = 1.2
@export var patrol_pause_max: float = 4.2
@export var patrol_speed_fraction: float = 0.35

var _home_pos: Vector2 = Vector2.ZERO
var _saw_player_once: bool = false

var _patrol_target: Vector2 = Vector2.ZERO
var _patrol_until: float = 0.0
var _patrol_pause_until: float = 0.0

var _patrol_stuck_time: float = 0.0
var _patrol_last_pos: Vector2 = Vector2.ZERO
const PATROL_STUCK_THRESHOLD: float = 0.5
const PATROL_STUCK_DISTANCE: float = 3.0

# =============================================================================
# SHARED HUMANOID CROWD / BACKOFF
# =============================================================================

var _backoff_until: float = 0.0
var _approach_denied_until: float = 0.0

# =============================================================================
# SHARED HUMANOID REWARDS / DEATH ASSETS
# =============================================================================
@export_group("Humanoid Death / Rewards")
@export var death_anim: PackedScene = null
@export var exp_gem: PackedScene = null

@onready var loot_base: Node = get_tree().get_first_node_in_group("loot")

# =============================================================================
# HUMANOID COMBAT RUNTIME
# =============================================================================

var _contact_hb: Area2D = null

var next_swipe_time: float = 0.0
var telegraphing: bool = false
var swinging: bool = false
var is_attacking: bool = false
var stunned_until: float = 0.0
var _attack_recovery: bool = false

var telegraph_active: bool = false
var telegraph_duration: float = 0.5
var active_window: float = 0.22

var _current_swipe_area: Area2D = null
var _parry_gen: int = 0
var _attack_gen: int = 0

var _windup_player_pos0: Vector2 = Vector2.ZERO

var _lunge_until: float = 0.0
var _lunge_speed: float = 0.0
var _lunge_dir: Vector2 = Vector2.ZERO
var _recover_lock_until: float = 0.0

var attack_type: String = "melee"

# =============================================================================
# SHARED HUMANOID COUNTER / LUNGE / COMMITMENT POLISH
# =============================================================================

@export_group("Humanoid Counter Attacks")
@export var humanoid_can_counter_after_block: bool = true
@export_range(0.0, 1.0, 0.01) var humanoid_counter_chance: float = 0.45
@export var humanoid_counter_delay: float = 0.22
@export var humanoid_counter_cooldown: float = 1.10
@export var humanoid_counter_min_attack_gap: float = 0.55
@export var humanoid_counter_max_range_bonus: float = 18.0
@export_range(0.0, 1.0, 0.01) var humanoid_counter_thrust_chance: float = 0.35

@export_group("Humanoid Attack Commitment")
@export var humanoid_lock_facing_during_attack: bool = true
@export var humanoid_lunge_close_ratio: float = 0.55
@export var humanoid_lunge_in_range_ratio: float = 0.90
@export var humanoid_lunge_barely_outside_bonus: float = 18.0
@export var humanoid_lunge_crowd_safety_mult: float = 0.55

var _humanoid_counter_queued: bool = false
var _humanoid_counter_until: float = 0.0
var _humanoid_counter_kind: String = "quick_slash"

var _attack_facing_locked: bool = false
var _attack_facing_right: bool = false

# =============================================================================
# SHARED HUMANOID READY / PHYSICS
# =============================================================================
func _ready() -> void:
	_humanoid_base_ready()

func _load_default_reward_assets_if_needed() -> void:
	if death_anim == null:
		var death_paths := [
			"res://Enemy/explosion.tscn",
			"res://Enemy/Explosion.tscn",
			"res://Effects/explosion.tscn",
			"res://VFX/explosion.tscn"
		]
		
		for path in death_paths:
			if ResourceLoader.exists(path):
				death_anim = load(path) as PackedScene
				break
	
	if exp_gem == null:
		var exp_paths := [
			"res://Objects/experience_gem.tscn",
			"res://Objects/ExperienceGem.tscn",
			"res://Items/experience_gem.tscn"
		]
		
		for path in exp_paths:
			if ResourceLoader.exists(path):
				exp_gem = load(path) as PackedScene
				break
				
func _humanoid_base_ready() -> void:
	_base_enemy_ready()
	_load_default_reward_assets_if_needed()
	
	if not is_in_group("enemy"):
		add_to_group("enemy")
	
	_home_pos = global_position
	_patrol_last_pos = global_position
	
	_contact_hb = get_node_or_null("ContactHitBox") as Area2D
	if _contact_hb == null:
		_contact_hb = get_node_or_null("ContactHurtBox") as Area2D
	
	_setup_parry_indicator()
	
	if anim:
		if anim.has_animation("idle"):
			anim.play("idle")
		elif anim.has_animation("walk"):
			anim.play("walk")
	
	if anim and not anim.is_connected("animation_finished", Callable(self, "_on_anim_finished")):
		anim.connect("animation_finished", Callable(self, "_on_anim_finished"))
	
	_connect_attack_director_signal("crowd_backoff", Callable(self, "_on_crowd_backoff"))

func _physics_process(delta: float) -> void:
	# Generic fallback for humanoids that do not override physics.
	# Specific enemies like CorruptedSwordsman can override this and call
	# _humanoid_shared_tick(delta) directly.
	if _humanoid_shared_tick(delta):
		_update_basic_movement_anim()
		return
	
	if not is_instance_valid(player):
		_patrol_step(delta)
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	if now < stunned_until:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_basic_movement_anim()
		return
	
	if not _saw_player_once and not auto_aggro_on_spawn:
		_try_proximity_aggro()
		_patrol_step(delta)
		move_and_slide()
		_update_basic_movement_anim()
		return
	
	velocity = knockback
	move_and_slide()
	_update_basic_movement_anim()

func _humanoid_shared_tick(delta: float) -> bool:
	ProstheticEffects.tick(self, delta)
	
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		se.tick(self, delta)
	
	if tick_base_hitstop():
		move_and_slide()
		return true
	
	if ProstheticEffects.override_movement(self, delta):
		return true
	
	sync_posture_bar_position()
	tick_base_knockback(delta)
	
	return false
	
# =============================================================================
# HUMANOID ATTACK UTILITY HELPERS
# =============================================================================

func _set_contact_damage_enabled(enabled: bool) -> void:
	if _contact_hb and is_instance_valid(_contact_hb):
		_contact_hb.monitoring = enabled
		_contact_hb.monitorable = enabled


func _cleanup_swipe() -> void:
	if _current_swipe_area and is_instance_valid(_current_swipe_area):
		_current_swipe_area.queue_free()
		_current_swipe_area = null


func _hard_cleanup_swipe() -> void:
	if _current_swipe_area and is_instance_valid(_current_swipe_area):
		_current_swipe_area.set_deferred("monitoring", false)
		_current_swipe_area.set_deferred("monitorable", false)
		_current_swipe_area.set_meta("consumed", true)
		_current_swipe_area.queue_free()
		_current_swipe_area = null


func _cleanup_owned_attack_areas() -> void:
	for a in get_tree().get_nodes_in_group("attack"):
		if not is_instance_valid(a):
			continue
		if not (a is Area2D):
			continue
		if not a.has_meta("attacker"):
			continue
		if a.get_meta("attacker") != self:
			continue
		
		a.queue_free()


func _hard_cleanup_owned_attack_areas() -> void:
	for a in get_tree().get_nodes_in_group("attack"):
		if not is_instance_valid(a):
			continue
		if not (a is Area2D):
			continue
		if not a.has_meta("attacker"):
			continue
		if a.get_meta("attacker") != self:
			continue
		
		a.set_deferred("monitoring", false)
		a.set_deferred("monitorable", false)
		a.set_meta("consumed", true)
		a.queue_free()


func _update_swipe_hitbox_position() -> void:
	if not is_instance_valid(_current_swipe_area):
		return
	
	var aim_dir: Vector2 = Vector2.RIGHT
	if _current_swipe_area.has_meta("swing_dir"):
		aim_dir = _current_swipe_area.get_meta("swing_dir")
	
	var offset: float = 16.0
	if _current_swipe_area.has_meta("swing_offset"):
		offset = float(_current_swipe_area.get_meta("swing_offset"))
	
	_current_swipe_area.position = aim_dir * offset
	
	if is_instance_valid(sprite):
		_current_swipe_area.z_index = sprite.z_index + 1


func _play_attack_anim_and_get_duration(names: Array, fallback_sec: float) -> float:
	if anim == null:
		return fallback_sec
	
	for n in names:
		var name := String(n)
		if anim.has_animation(name):
			anim.play(name)
			var a = anim.get_animation(name)
			if a:
				var sp = max(0.001, anim.speed_scale)
				return float(a.length) / sp
			return fallback_sec
	
	return fallback_sec

func _reset_humanoid_attack_runtime() -> void:
	telegraphing = false
	swinging = false
	is_attacking = false
	_attack_recovery = false
	
	_lunge_until = 0.0
	_lunge_speed = 0.0
	_lunge_dir = Vector2.ZERO
	
	_clear_attack_facing_lock()
	_hide_parry_indicator()
	_cleanup_swipe()
	_set_anim_speed_safe(1.0)

func _full_reset_humanoid_attack_runtime() -> void:
	_invalidate_humanoid_attack_gens()
	_reset_humanoid_attack_runtime()
	_hard_cleanup_owned_attack_areas()
	_hard_cleanup_swipe()
	_release_attack_token()

func _soft_reset_humanoid_attack_runtime() -> void:
	_invalidate_humanoid_attack_gens()
	_reset_humanoid_attack_runtime()
	_cleanup_owned_attack_areas()
	_cleanup_swipe()
	_release_attack_token()
	
func _invalidate_humanoid_attack_gens() -> void:
	_parry_gen += 1
	_attack_gen += 1

var _parry_indicator: Node2D = null
var _parry_indicator_attack_gen: int = 0


func _get_default_block_stagger_time() -> float:
	return BLOCK_STAGGER_TIME


func _get_heavy_block_stagger_time() -> float:
	return BLOCK_STAGGER_HEAVY


# =============================================================================
# BLOCKING
# =============================================================================

func _update_blocking(_delta: float, now: float) -> void:
	var dbroken_active := bool(object_get_property(self, "_dbroken_active", false))
	var telegraphing_now := bool(object_get_property(self, "telegraphing", false))
	var attacking_now := bool(object_get_property(self, "is_attacking", false))
	var attack_recovery_now := bool(object_get_property(self, "_attack_recovery", false))
	var guard_radius := float(object_get_property(self, "deaggro_radius", 220.0))
	
	if not can_block or dbroken_active:
		_set_blocking(false)
		return
	
	# Cannot block during telegraph or active attack, but can block during recovery.
	if telegraphing_now or (attacking_now and not attack_recovery_now):
		_set_blocking(false)
		return
	
	if ProstheticEffects.is_confused(self):
		_set_blocking(false)
		return
	
	if now < _block_stagger_until:
		_set_blocking(false)
		return
	
	if is_instance_valid(player):
		var dist := global_position.distance_to(player.global_position)
		if dist <= guard_radius:
			_set_blocking(true)
			set("_engaged", true)
			return
	
	_set_blocking(false)


func _set_blocking(active: bool) -> void:
	if _block_active == active:
		return
	
	_block_active = active
	
	if combat == null:
		return
	
	if active:
		if combat.has_method("start_block"):
			combat.start_block()
	else:
		if combat.has_method("end_block"):
			combat.end_block()


func is_blocking() -> bool:
	return _block_active


func _is_frontal_attack(attacker) -> bool:
	if not is_instance_valid(player):
		return true
	
	var to_player := (player.global_position - global_position).normalized()
	var to_attacker := to_player
	
	if attacker is Node2D:
		to_attacker = (attacker.global_position - global_position).normalized()
	
	# Lenient by design: the base swordsman should reliably guard frontal pressure.
	return to_player.dot(to_attacker) > -0.5


func _on_block_impact(attacker, is_heavy: bool, response: Dictionary = {}) -> void:
	_flash_sprite(Color(0.7, 0.7, 1.0), 0.08)
	
	var hitstop_time := float(response.get("hitstop_block", 0.06 if is_heavy else 0.04))
	hitstop_local(hitstop_time)
	
	var kb_force := float(response.get("block_knockback", 50.0 if is_heavy else 25.0))
	var kb_source := _resolve_hurt_source(attacker)
	
	if kb_source is Node2D:
		var kb_dir = (global_position - kb_source.global_position).normalized()
		apply_knockback(kb_dir * kb_force)
	elif attacker is Node2D:
		var kb_dir = (global_position - attacker.global_position).normalized()
		apply_knockback(kb_dir * kb_force)
	
	_spawn_block_sparks()
	
	var posture_dmg := float(response.get("posture_on_block", 6.0 if is_heavy else 3.0))
	add_posture_damage(posture_dmg)
	
	if is_instance_valid(player) and player.has_method("_on_attack_hit"):
		player._on_attack_hit(self, 0)

	_try_queue_humanoid_counter_after_block(attacker, is_heavy, response)

func _spawn_block_sparks() -> void:
	for i in range(5):
		var spark := ColorRect.new()
		spark.size = Vector2(4, 4)
		spark.color = Color(1.0, 0.95, 0.8, 1.0)
		spark.z_index = 100
		add_child(spark)
		spark.position = Vector2(-2, -12)
		
		var angle := randf_range(-PI * 0.7, PI * 0.7)
		var dist := randf_range(15, 35)
		var end_pos := Vector2(cos(angle), sin(angle) - 0.5) * dist
		
		var tw := create_tween()
		tw.set_parallel(true)
		tw.tween_property(spark, "position", spark.position + end_pos, 0.15)
		tw.tween_property(spark, "modulate:a", 0.0, 0.15)
		tw.chain().tween_callback(_safe_queue_free.bind(spark))

# =============================================================================
# SHARED HUMANOID PATROL / AGGRO HELPERS
# =============================================================================

func _try_proximity_aggro() -> void:
	if not is_instance_valid(player):
		return
	
	var dist := global_position.distance_to(player.global_position)
	if dist <= aggro_radius:
		_saw_player_once = true


func set_auto_aggro_on_spawn(v: bool) -> void:
	auto_aggro_on_spawn = v
	if not auto_aggro_on_spawn:
		_saw_player_once = false


func _patrol_step(delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if now < _patrol_pause_until:
		velocity = Vector2.ZERO
		if anim and anim.has_animation("idle") and anim.current_animation != "idle":
			anim.play("idle")
		return
	
	var need_new_target := false
	if now >= _patrol_until:
		need_new_target = true
	
	var moved_dist := global_position.distance_to(_patrol_last_pos)
	if velocity.length() > 1.0 and moved_dist < PATROL_STUCK_DISTANCE:
		_patrol_stuck_time += delta
		if _patrol_stuck_time >= PATROL_STUCK_THRESHOLD:
			need_new_target = true
			_patrol_stuck_time = 0.0
	else:
		_patrol_stuck_time = 0.0
	
	_patrol_last_pos = global_position
	
	if need_new_target:
		if randf() < 0.4:
			_patrol_pause_until = now + randf_range(patrol_pause_min, patrol_pause_max)
			velocity = Vector2.ZERO
			if anim and anim.has_animation("idle") and anim.current_animation != "idle":
				anim.play("idle")
			return
		
		_patrol_target = _find_valid_patrol_target()
		_patrol_until = now + randf_range(patrol_step_time_min, patrol_step_time_max)
	
	var to_target := _patrol_target - global_position
	if to_target.length() > 4.0:
		if _is_path_clear(to_target.normalized(), 16.0):
			velocity = to_target.normalized() * movement_speed * patrol_speed_fraction
			if anim and anim.has_animation("walk") and anim.current_animation != "walk":
				anim.play("walk")
		else:
			_patrol_until = 0.0
			velocity = Vector2.ZERO
			if anim and anim.has_animation("idle") and anim.current_animation != "idle":
				anim.play("idle")
	else:
		velocity = Vector2.ZERO
		if anim and anim.has_animation("idle") and anim.current_animation != "idle":
			anim.play("idle")


func _find_valid_patrol_target() -> Vector2:
	var attempts := 5
	
	for i in range(attempts):
		var angle := randf() * TAU
		var dist := randf_range(0.3, 1.0) * patrol_wander_radius
		var candidate := _home_pos + Vector2(cos(angle), sin(angle)) * dist
		
		var to_candidate := candidate - global_position
		if to_candidate.length() > 0.1:
			if _is_path_clear(to_candidate.normalized(), to_candidate.length()):
				return candidate
	
	var to_home := _home_pos - global_position
	if to_home.length() > 0.1 and _is_path_clear(to_home.normalized(), to_home.length()):
		return _home_pos
	
	return global_position

func _is_path_clear(direction: Vector2, distance: float) -> bool:
	if direction.length() < 0.001:
		return true
	
	var space_state := get_world_2d().direct_space_state
	if space_state == null:
		return true
	
	var query := PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + direction.normalized() * distance,
		1
	)
	query.exclude = [self]
	
	var result := space_state.intersect_ray(query)
	return result.is_empty()

func _resume_movement_anim() -> void:
	if anim == null:
		return
	
	if anim.has_animation("walk"):
		anim.play("walk")
	elif anim.has_animation("idle"):
		anim.play("idle")


func _update_basic_movement_anim() -> void:
	if anim == null:
		return
	
	if telegraphing or is_attacking or swinging:
		return
	
	var is_moving := velocity.length() > 5.0
	
	if is_moving:
		if anim.has_animation("walk") and anim.current_animation != "walk":
			anim.play("walk")
	else:
		if anim.has_animation("idle"):
			if anim.current_animation == "walk":
				anim.play("idle")
		elif anim.current_animation == "walk":
			anim.stop()

func _update_movement_anim() -> void:
	_update_basic_movement_anim()

func _update_sprite_facing() -> void:
	if sprite == null:
		return
	
	if _attack_facing_locked:
		sprite.flip_h = _attack_facing_right
		return
	
	if not is_instance_valid(player):
		return
	
	var to_player := player.global_position - global_position
	
	if abs(to_player.x) < 5.0:
		return
	
	sprite.flip_h = to_player.x > 0.0
	
func _on_anim_finished(anim_name: String) -> void:
	if anim_name == "attack_recover":
		_resume_movement_anim()
	elif anim_name == "parried":
		_resume_movement_anim()
	elif anim_name == "stagger":
		_resume_movement_anim()


func _on_crowd_backoff(targets) -> void:
	if targets is Array:
		if not targets.has(self):
			return
		
		var backoff_duration := _get_attack_director_float_property("backoff_sec", 0.8)
		_backoff_until = Time.get_ticks_msec() * 0.001 + backoff_duration + randf() * 0.3
	else:
		_backoff_until = Time.get_ticks_msec() * 0.001 + float(targets)


func _crowd_force_backoff(duration: float) -> void:
	_backoff_until = Time.get_ticks_msec() * 0.001 + duration

func _approach_gate_ok() -> bool:
	var now := Time.get_ticks_msec() * 0.001
	
	if now < _backoff_until:
		return false
	
	if now < _approach_denied_until:
		return false
	
	var ad := get_attack_director()
	if ad == null:
		return true
	
	if _held_roles.has("advance_move"):
		return true
	
	if ad.has_method("request_role"):
		if ad.request_role(self, "advance_move"):
			_held_roles["advance_move"] = true
			return true
	
	_approach_denied_until = now + 0.35
	return false

func _wants_frontline() -> bool:
	return false


func play_hurt_animation() -> void:
	if anim and anim.has_animation("hurt"):
		anim.play("hurt")
		_set_anim_speed_safe(1.0)


func play_death_and_free() -> void:
	if anim and anim.has_animation("death"):
		anim.play("death")
		await get_tree().create_timer(0.6).timeout
	
	queue_free()

func _run_humanoid_death_rewards() -> void:
	notify_stance_effects_enemy_death()
	_hide_parry_indicator()
	_release_all_attack_director_state()
	
	if death_anim:
		spawn_death_vfx(death_anim)
	
	if exp_gem:
		spawn_experience_gem(exp_gem, loot_base)
	
	award_area_gold_drop()
	
	_soft_reset_humanoid_attack_runtime()
	
func death() -> void:
	if not mark_dead():
		return
	
	emit_signal("enemy_died", self)
	_run_humanoid_death_rewards()
	base_death_cleanup()

func _exit_tree() -> void:
	_release_all_attack_director_state()
	_disconnect_attack_director_signal("crowd_backoff", Callable(self, "_on_crowd_backoff"))

func _lock_attack_facing_toward_position(target_pos: Vector2) -> void:
	if not humanoid_lock_facing_during_attack:
		return
	
	if sprite == null:
		return
	
	var to_target := target_pos - global_position
	
	if abs(to_target.x) < 3.0:
		return
	
	_attack_facing_locked = true
	_attack_facing_right = to_target.x > 0.0
	sprite.flip_h = _attack_facing_right


func _lock_attack_facing_toward_player_or_snapshot() -> void:
	if _windup_player_pos0 != Vector2.ZERO:
		_lock_attack_facing_toward_position(_windup_player_pos0)
	elif is_instance_valid(player):
		_lock_attack_facing_toward_position(player.global_position)


func _clear_attack_facing_lock() -> void:
	_attack_facing_locked = false


func _compute_humanoid_attack_lunge(
	range_val: float,
	base_step_speed: float,
	base_step_time: float,
	strong_step_speed: float,
	strong_step_time: float
) -> Dictionary:
	var result := {
		"dir": Vector2.ZERO,
		"speed": 0.0,
		"time": 0.0
	}
	
	if not is_instance_valid(player):
		return result
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	
	if dist <= 0.001:
		return result
	
	var dir := to_player.normalized()
	
	# Already close: do not magnet-lunge into the player.
	if dist <= range_val * humanoid_lunge_close_ratio:
		return result
	
	# In range: small readable step.
	if dist <= range_val * humanoid_lunge_in_range_ratio:
		result["dir"] = dir
		result["speed"] = base_step_speed * 0.85
		result["time"] = base_step_time
		return result
	
	# Barely outside range: stronger lunge to help the attack connect.
	if dist <= range_val + humanoid_lunge_barely_outside_bonus:
		result["dir"] = dir
		result["speed"] = strong_step_speed
		result["time"] = strong_step_time
		return result
	
	# Too far: no magnetism. Let the AI approach first.
	return result


func _apply_humanoid_lunge(lunge_data: Dictionary, now_s: float) -> void:
	_lunge_dir = Vector2.ZERO
	_lunge_speed = 0.0
	_lunge_until = 0.0
	
	if lunge_data.is_empty():
		return
	
	var dir := lunge_data.get("dir", Vector2.ZERO) as Vector2
	var speed := float(lunge_data.get("speed", 0.0))
	var time := float(lunge_data.get("time", 0.0))
	
	if dir.length() <= 0.001 or speed <= 0.0 or time <= 0.0:
		return
	
	_lunge_dir = dir.normalized()
	_lunge_speed = speed
	_lunge_until = now_s + time


func _try_queue_humanoid_counter_after_block(attacker, is_heavy: bool, response: Dictionary = {}) -> void:
	if not humanoid_can_counter_after_block:
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	if _humanoid_counter_queued:
		return
	
	if now < stunned_until:
		return
	
	if telegraphing or is_attacking or swinging:
		return
	
	var dbroken_active := bool(object_get_property(self, "_dbroken_active", false))
	if dbroken_active:
		return
	
	var last_attack_end := float(object_get_property(self, "_last_attack_ended_at", -999.0))
	if now - last_attack_end < humanoid_counter_min_attack_gap:
		return
	
	var cd_until: float = 0.0
	if has_meta("_humanoid_counter_cd_until"):
		cd_until = float(get_meta("_humanoid_counter_cd_until"))
	if now < cd_until:
		return
	
	if not is_instance_valid(player):
		return
	
	var attack_max_range := float(object_get_property(self, "attack_start_max_range", 70.0))
	var close_range := float(object_get_property(self, "close_combat_range", 50.0))
	var thrust_range_val := float(object_get_property(self, "thrust_range", attack_max_range))
	var dist := global_position.distance_to(player.global_position)
	
	# Too far: do not counter from unrealistic range.
	if dist > attack_max_range + humanoid_counter_max_range_bonus:
		return
	
	var score := humanoid_counter_chance
	
	# Close range blocks feel like believable counter opportunities.
	if dist <= close_range:
		score += 0.15
	
	# Heavy player attacks should usually create more block stun, not an automatic punish.
	if is_heavy:
		score -= 0.20
	
	# If posture is already high, be less willing to counter.
	var posture_ratio := _get_humanoid_posture_ratio_safe()
	if posture_ratio >= 0.70:
		score -= 0.25
	
	# Reduce dogpiling if another enemy already owns attack pressure.
	if _humanoid_attack_director_has_other_active_attacker():
		score -= 0.30
	
	score = clamp(score, 0.0, 0.95)
	
	if randf() > score:
		return
	
	_humanoid_counter_kind = _choose_humanoid_counter_kind(dist, close_range, thrust_range_val)
	if _humanoid_counter_kind == "":
		print("[HumanoidCounter] no counter kind")
		return

	print("[HumanoidCounter] queued kind=", _humanoid_counter_kind, " delay=", humanoid_counter_delay)

	_humanoid_counter_queued = true
	_humanoid_counter_until = now + max(0.05, humanoid_counter_delay)

func _choose_humanoid_counter_kind(dist: float, close_range: float, thrust_range_val: float) -> String:
	# Very close: quick slash is more readable than a point-blank thrust.
	if dist <= close_range:
		if randf() < 0.75:
			return "quick_slash"
		return "thrust_poke"
	
	# Mid / outer range: thrust becomes more likely.
	if dist <= thrust_range_val + humanoid_counter_max_range_bonus:
		if randf() < humanoid_counter_thrust_chance:
			return "thrust_poke"
		return "quick_slash"
	
	return ""


func _tick_humanoid_counter_queue(now: float) -> void:
	if not _humanoid_counter_queued:
		return
	
	if now < stunned_until:
		_clear_humanoid_counter_queue()
		return
	
	if telegraphing or is_attacking or swinging:
		_clear_humanoid_counter_queue()
		return
	
	var dbroken_active := bool(object_get_property(self, "_dbroken_active", false))
	if dbroken_active:
		_clear_humanoid_counter_queue()
		return
	
	if now < _humanoid_counter_until:
		return
	
	_humanoid_counter_queued = false
	
	set_meta("_humanoid_counter_cd_until", now + humanoid_counter_cooldown)
	_start_humanoid_counter_attack(_humanoid_counter_kind)


func _clear_humanoid_counter_queue() -> void:
	_humanoid_counter_queued = false
	_humanoid_counter_until = 0.0
	_humanoid_counter_kind = "quick_slash"

func _start_humanoid_counter_attack(counter_kind: String) -> void:
	if now_is_invalid_for_humanoid_counter():
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	if not _request_attack_token():
		return
	
	# Give this counter its own normal attack spacing.
	next_swipe_time = now + humanoid_counter_cooldown
	
	var started := false
	
	match counter_kind:
		"thrust_poke":
			started = _call_first_existing_method([
				"_start_quick_thrust",
				"_start_thrust",
				"_start_thrust_poke",
				"_start_basic_swing",
				"_start_slash"
			])
		"quick_slash":
			started = _call_first_existing_method([
				"_start_basic_swing",
				"_start_quick_slash",
				"_start_slash"
			])
		_:
			started = _call_first_existing_method([
				"_start_basic_swing",
				"_start_slash"
			])
	
	if not started:
		_release_attack_token()
		return
	
	_on_humanoid_counter_attack_started(counter_kind)

func now_is_invalid_for_humanoid_counter() -> bool:
	var now := Time.get_ticks_msec() * 0.001
	
	if now < stunned_until:
		return true
	
	if telegraphing or is_attacking or swinging:
		return true
	
	var dbroken_active := bool(object_get_property(self, "_dbroken_active", false))
	if dbroken_active:
		return true
	
	var cd_until: float = 0.0
	if has_meta("_humanoid_counter_cd_until"):
		cd_until = float(get_meta("_humanoid_counter_cd_until"))
	if now < cd_until:
		return true
	
	return false

func _call_first_existing_method(method_names: Array) -> bool:
	for method_name in method_names:
		var method_string := String(method_name)
		if has_method(method_string):
			call(method_string)
			return true
	
	return false


func _on_humanoid_counter_attack_started(_counter_kind: String) -> void:
	# Optional child hook.
	# Child enemies can override this if they need to enter a specific AI state.
	pass
	
func _get_humanoid_posture_ratio_safe() -> float:
	if combat == null:
		return 0.0
	
	if combat.has_method("get_posture_ratio"):
		return float(combat.get_posture_ratio())
	
	var current_posture = combat.get("posture")
	var max_posture = combat.get("max_posture")
	
	if current_posture == null or max_posture == null:
		return 0.0
	
	var max_val := float(max_posture)
	if max_val <= 0.001:
		return 0.0
	
	return clamp(float(current_posture) / max_val, 0.0, 1.0)

func _humanoid_attack_director_has_other_active_attacker() -> bool:
	var ad := get_attack_director()
	if ad == null:
		return false
	
	# Safe fallback: if your AttackDirector does not expose this yet, this returns false.
	if ad.has_method("has_active_attacker"):
		return bool(ad.has_active_attacker())
	
	return false
# =============================================================================
# PARRY INDICATOR
# =============================================================================

func _setup_parry_indicator() -> void:
	if _parry_indicator != null:
		return
	
	var indicator_path := "res://Combat/parry_indicator.gd"
	if ResourceLoader.exists(indicator_path):
		var script = load(indicator_path)
		if script:
			_parry_indicator = Node2D.new()
			_parry_indicator.set_script(script)
			_parry_indicator.name = "ParryIndicator"
			add_child(_parry_indicator)
			return
	
	_parry_indicator = _create_simple_indicator()
	add_child(_parry_indicator)


func _create_simple_indicator() -> Node2D:
	var ind := Node2D.new()
	ind.name = "ParryIndicator"
	ind.position = Vector2(0, -45)
	ind.visible = false
	
	var poly := Polygon2D.new()
	var size := 11.0
	var h := size
	var w := size * 0.6
	poly.polygon = PackedVector2Array([
		Vector2(0, -h),
		Vector2(w, 0),
		Vector2(0, h),
		Vector2(-w, 0)
	])
	poly.color = Color(1.0, 0.95, 0.8, 1.0)
	ind.add_child(poly)
	
	var outline := Polygon2D.new()
	var oh := size + 2.5
	var ow := (size + 2.5) * 0.6
	outline.polygon = PackedVector2Array([
		Vector2(0, -oh),
		Vector2(ow, 0),
		Vector2(0, oh),
		Vector2(-ow, 0)
	])
	outline.color = Color(0.3, 0.25, 0.2, 0.95)
	outline.z_index = -1
	ind.add_child(outline)
	
	ind.set_meta("poly", poly)
	ind.set_meta("outline", outline)
	
	return ind


func _show_parry_indicator(duration: float, _is_unblockable: bool = false) -> void:
	if _parry_indicator == null:
		return
	
	var attack_gen_value = get("_attack_gen")
	if attack_gen_value != null:
		_parry_indicator_attack_gen = int(attack_gen_value)
	
	if _parry_indicator.has_method("warn_attack"):
		_parry_indicator.warn_attack(duration, _is_unblockable)
		return
	
	_parry_indicator.visible = true
	_parry_indicator.scale = Vector2(1.5, 1.5)
	
	var poly = _parry_indicator.get_meta("poly") if _parry_indicator.has_meta("poly") else null
	var outline = _parry_indicator.get_meta("outline") if _parry_indicator.has_meta("outline") else null
	
	if _is_unblockable:
		if poly:
			poly.color = Color(1.0, 0.85, 0.1, 1.0)
		if outline:
			outline.color = Color(0.45, 0.35, 0.0, 0.95)
	else:
		if poly:
			poly.color = Color(1.0, 0.95, 0.8, 1.0)
		if outline:
			outline.color = Color(0.3, 0.25, 0.2, 0.95)
	
	var tw := create_tween()
	tw.tween_property(_parry_indicator, "scale", Vector2(1.0, 1.0), 0.1)


func _hide_parry_indicator() -> void:
	if _parry_indicator == null:
		return
	
	if _parry_indicator.has_method("hide_now"):
		_parry_indicator.hide_now()
	else:
		_parry_indicator.visible = false
