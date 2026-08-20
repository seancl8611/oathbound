extends HumanoidEnemyBase
class_name Warden

## =============================================================================
## WARDEN - Humanoid Chain Controller
## =============================================================================
## Role:
## - Armed humanoid control enemy
## - Extends HumanoidEnemyBase for shared humanoid refs, blocking/parry indicator,
##   patrol/aggro helpers, damage intake, posture, AttackDirector helpers, and death flow.
## - Owns its own chain attack / restrain logic locally.
## =============================================================================

enum WardenState {
	PATROL,
	ENGAGE,
	WINDUP,
	ATTACK,
	RECOVER,
	STAGGER,
	DEAD
}

enum WardenAttack {
	CHAIN_SWING,
	QUICK_THRUST,
	CROSS_SWING,
	RUNNING_SWING
}

# =============================================================================
# WARDEN TUNING
# =============================================================================

@export_group("Warden Stats")
@export var warden_hp: int = 28
@export var warden_experience: int = 2
@export var warden_move_speed: float = 65.0

@export_group("Warden Movement")
@export var approach_speed: float = 95.0
@export var orbit_speed: float = 40.0
@export var hold_distance: float = 45.0
@export var close_combat_range: float = 60.0
@export var attack_start_min_range: float = 18.0
@export var attack_start_max_range: float = 80.0
@export var engage_deaggro_radius: float = 300.0

@export_group("Chain Attack")
@export var chain_damage: int = 8
@export var chain_range: float = 70.0
@export var chain_thickness: float = 14.0
@export var chain_duration: float = 1.0
@export var chain_break_action: String = "attack"
@export var chain_break_presses: int = 6
@export var chain_windup: float = 0.45
@export var chain_active_time: float = 0.15

@export_group("Quick Thrust")
@export var thrust_damage: int = 6
@export var thrust_range: float = 62.0
@export var thrust_width: float = 12.0
@export var thrust_windup: float = 0.32
@export var thrust_active_time: float = 0.13

@export_group("Cross Swing")
@export var cross_damage: int = 5
@export var cross_range: float = 58.0
@export var cross_radius: float = 24.0
@export var cross_windup: float = 0.38
@export var cross_active_time: float = 0.14
@export var cross_second_delay: float = 0.28

@export_group("Running Swing")
@export var running_damage: int = 7
@export var running_range: float = 64.0
@export var running_radius: float = 24.0
@export var running_windup: float = 0.38
@export var running_active_time: float = 0.16
@export var running_lunge_speed: float = 280.0
@export var running_lunge_time: float = 0.18

@export_group("Combat Rhythm")
@export var recover_time: float = 0.42
@export var attack_cd_min: float = 0.90
@export var attack_cd_max: float = 1.60
@export var parry_recoil_time: float = 0.55
@export var parry_knockback_force: float = 90.0
@export var hurt_stun_time: float = 0.12

@export_group("Rewards")
@export var exp_gem_scene: PackedScene = null

# =============================================================================
# RUNTIME
# =============================================================================

var state: int = WardenState.PATROL
var _state_timer: float = 0.0

var _aggro: bool = false
var _next_attack_ready: float = 0.0
var _stunned_until: float = 0.0

var _current_attack: int = WardenAttack.CHAIN_SWING
var _last_attack: int = WardenAttack.CHAIN_SWING

var _attack_dir: Vector2 = Vector2.RIGHT
var _attack_area: Area2D = null
var _chain_target_pos: Vector2 = Vector2.ZERO

var _restraining: bool = false
var _restrain_until: float = 0.0
var _restrained_player: Node2D = null

var _combo_hits_remaining: int = 0
var _last_pos: Vector2 = Vector2.ZERO
var _last_move_speed: float = 0.0
var _current_anim: String = ""

signal remove_from_array(object)

# =============================================================================
# INITIALIZATION
# =============================================================================

func _ready() -> void:
	_apply_warden_defaults()
	super._ready()
	_load_warden_reward_assets_if_needed()
	
	can_block = true
	block_by_default = true
	block_chance_on_hit = 1.0
	
	_home_pos = global_position
	_patrol_target = global_position
	
	print("[Warden] v1.0 - HumanoidEnemyBase migrated")


func _apply_warden_defaults() -> void:
	hp = warden_hp
	experience = warden_experience
	movement_speed = warden_move_speed
	deaggro_radius = engage_deaggro_radius


func _load_warden_reward_assets_if_needed() -> void:
	if exp_gem_scene != null:
		return
	
	var paths := [
		"res://Objects/experience_gem.tscn",
		"res://Objects/ExperienceGem.tscn",
		"res://Items/experience_gem.tscn"
	]
	
	for path in paths:
		if ResourceLoader.exists(path):
			exp_gem_scene = load(path) as PackedScene
			return


# =============================================================================
# MAIN LOOP
# =============================================================================

func _physics_process(delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if state == WardenState.DEAD:
		return
	
	_end_restrain_if_elapsed()
	_track_movement_speed(delta)
	
	if _humanoid_shared_tick(delta):
		_update_animation()
		return
	
	if now < _stunned_until and state != WardenState.STAGGER:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_sprite_facing()
		_update_animation()
		return
	
	_update_blocking(delta, now)
	
	if _state_timer > 0.0:
		_state_timer -= delta
	
	match state:
		WardenState.PATROL:
			_state_patrol(delta, now)
		WardenState.ENGAGE:
			_state_engage(delta, now)
		WardenState.WINDUP:
			_state_windup(delta, now)
		WardenState.ATTACK:
			_state_attack(delta, now)
		WardenState.RECOVER:
			_state_recover(delta, now)
		WardenState.STAGGER:
			_state_stagger(delta, now)
	
	if knockback.length() > 1.0:
		velocity += knockback
		tick_base_knockback(delta)
	
	move_and_slide()
	_update_sprite_facing()
	_update_animation()


func _track_movement_speed(delta: float) -> void:
	var prev := _last_pos if _last_pos != Vector2.ZERO else global_position
	var moved := global_position - prev
	_last_move_speed = moved.length() / max(0.0001, delta)
	_last_pos = global_position


# =============================================================================
# STATE MACHINE
# =============================================================================

func _goto(new_state: int, timer: float = 0.0) -> void:
	state = new_state
	_state_timer = timer


func _state_patrol(delta: float, now: float) -> void:
	if _check_aggro():
		_goto(WardenState.ENGAGE)
		return
	
	_patrol_step(delta)


func _state_engage(_delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(WardenState.PATROL)
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.RIGHT
	
	if dist > deaggro_radius:
		_saw_player_once = false
		_goto(WardenState.PATROL)
		return
	
	if now < _backoff_until:
		velocity = dir.rotated(PI * 0.5) * orbit_speed
		return
	
	if now >= _next_attack_ready and _can_start_warden_attack(dist):
		_try_start_warden_attack(dist)
		return
	
	if dist > hold_distance:
		if _approach_gate_ok():
			velocity = dir * approach_speed
		else:
			velocity = dir.rotated(PI * 0.5) * orbit_speed
	elif dist < attack_start_min_range:
		velocity = -dir * movement_speed * 0.45
	else:
		velocity = dir.rotated(PI * 0.5) * orbit_speed * 0.45


func _state_windup(_delta: float, _now: float) -> void:
	velocity = Vector2.ZERO
	
	if is_instance_valid(player) and _state_timer > 0.08:
		var to_player := player.global_position - global_position
		if to_player.length_squared() > 0.001:
			_attack_dir = to_player.normalized()
	
	if _state_timer <= 0.0:
		_begin_active_attack()


func _state_attack(_delta: float, _now: float) -> void:
	match _current_attack:
		WardenAttack.RUNNING_SWING:
			velocity = _attack_dir * running_lunge_speed
		_:
			velocity = _attack_dir * 70.0
	
	if _state_timer <= 0.0:
		_cleanup_attack_area()
		
		if _current_attack == WardenAttack.CROSS_SWING:
			_combo_hits_remaining -= 1
			if _combo_hits_remaining > 0:
				_enter_windup(cross_second_delay)
				return
		
		_finish_warden_attack()


func _state_recover(_delta: float, _now: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 350.0 * _delta)
	
	if _state_timer <= 0.0:
		_goto(WardenState.ENGAGE)


func _state_stagger(_delta: float, _now: float) -> void:
	velocity = knockback
	
	if _state_timer <= 0.0:
		_goto(WardenState.ENGAGE)


# =============================================================================
# ATTACK SELECTION
# =============================================================================

func _can_start_warden_attack(dist: float) -> bool:
	if has_died:
		return false
	
	if telegraphing or is_attacking or swinging:
		return false
	
	if ProstheticEffects.is_confused(self):
		return false
	
	return dist >= attack_start_min_range and dist <= attack_start_max_range


func _try_start_warden_attack(dist: float) -> void:
	if not _request_role("melee_attack"):
		return
	
	has_attack_token = true
	
	var chosen := _select_warden_attack(dist)
	_start_warden_attack(chosen)


func _select_warden_attack(dist: float) -> int:
	var weights := {
		WardenAttack.CHAIN_SWING: 0.45,
		WardenAttack.QUICK_THRUST: 0.25,
		WardenAttack.CROSS_SWING: 0.20,
		WardenAttack.RUNNING_SWING: 0.10
	}
	
	if dist > close_combat_range:
		weights[WardenAttack.RUNNING_SWING] = 0.25
		weights[WardenAttack.CHAIN_SWING] = 0.40
	
	if dist < 35.0:
		weights[WardenAttack.RUNNING_SWING] = 0.0
	
	if weights.has(_last_attack):
		weights[_last_attack] = float(weights[_last_attack]) * 0.35
	
	var total := 0.0
	for value in weights.values():
		total += float(value)
	
	if total <= 0.001:
		_last_attack = WardenAttack.CHAIN_SWING
		return WardenAttack.CHAIN_SWING
	
	var roll := randf() * total
	var cumulative := 0.0
	
	for attack_type in weights.keys():
		cumulative += float(weights[attack_type])
		if roll <= cumulative:
			_last_attack = int(attack_type)
			return int(attack_type)
	
	_last_attack = WardenAttack.CHAIN_SWING
	return WardenAttack.CHAIN_SWING


func _start_warden_attack(attack_type: int) -> void:
	_current_attack = attack_type
	
	if is_instance_valid(player):
		var to_player := player.global_position - global_position
		if to_player.length_squared() > 0.001:
			_attack_dir = to_player.normalized()
		_chain_target_pos = player.global_position
	else:
		_chain_target_pos = global_position + _attack_dir * chain_range
	
	match attack_type:
		WardenAttack.CHAIN_SWING:
			_enter_windup(chain_windup)
		WardenAttack.QUICK_THRUST:
			_enter_windup(thrust_windup)
		WardenAttack.CROSS_SWING:
			_combo_hits_remaining = 2
			_enter_windup(cross_windup)
		WardenAttack.RUNNING_SWING:
			_enter_windup(running_windup)


func _enter_windup(windup_time: float) -> void:
	_bump_attack_gens()
	_cleanup_attack_area()
	
	telegraphing = true
	is_attacking = false
	swinging = false
	
	_release_role("advance_move")
	
	var active_time := _get_current_active_time()
	var indicator_duration := windup_time + active_time
	_show_parry_indicator(indicator_duration, false)
	
	if anim and anim.has_animation("attack_windup"):
		anim.play("attack_windup")
		var base_len := anim.get_animation("attack_windup").length
		_set_anim_speed_safe(base_len / max(0.001, windup_time))
	
	_goto(WardenState.WINDUP, windup_time)


func _begin_active_attack() -> void:
	telegraphing = false
	is_attacking = true
	swinging = true
	
	_set_anim_speed_safe(1.0)
	
	match _current_attack:
		WardenAttack.CHAIN_SWING:
			_spawn_chain_hitbox(chain_damage)
			_goto(WardenState.ATTACK, chain_active_time)
		WardenAttack.QUICK_THRUST:
			_spawn_thrust_hitbox(thrust_damage)
			_goto(WardenState.ATTACK, thrust_active_time)
		WardenAttack.CROSS_SWING:
			_spawn_circle_hitbox(cross_damage, cross_radius, cross_range)
			_goto(WardenState.ATTACK, cross_active_time)
		WardenAttack.RUNNING_SWING:
			_spawn_circle_hitbox(running_damage, running_radius, running_range)
			_goto(WardenState.ATTACK, running_active_time)
	
	if anim and anim.has_animation("attack_slash"):
		anim.play("attack_slash")
	elif anim and anim.has_animation("attack"):
		anim.play("attack")


func _get_current_active_time() -> float:
	match _current_attack:
		WardenAttack.CHAIN_SWING:
			return chain_active_time
		WardenAttack.QUICK_THRUST:
			return thrust_active_time
		WardenAttack.CROSS_SWING:
			return cross_active_time
		WardenAttack.RUNNING_SWING:
			return running_active_time
	
	return chain_active_time


func _finish_warden_attack() -> void:
	_cleanup_attack_area()
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	telegraphing = false
	is_attacking = false
	swinging = false
	
	_release_role("melee_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	var now := Time.get_ticks_msec() * 0.001
	_next_attack_ready = now + randf_range(attack_cd_min, attack_cd_max)
	
	_goto(WardenState.RECOVER, recover_time)


func _cancel_warden_attack(backoff_time: float = 0.45) -> void:
	_bump_attack_gens()
	_cleanup_attack_area()
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	telegraphing = false
	is_attacking = false
	swinging = false
	_combo_hits_remaining = 0
	
	_release_role("melee_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	var now := Time.get_ticks_msec() * 0.001
	_backoff_until = max(_backoff_until, now + backoff_time)
	_next_attack_ready = max(_next_attack_ready, now + backoff_time)
	
	if state != WardenState.DEAD:
		_goto(WardenState.RECOVER, min(recover_time, 0.35))


func _bump_attack_gens() -> void:
	_attack_gen += 1
	_parry_gen += 1


# =============================================================================
# HITBOXES
# =============================================================================

func _spawn_chain_hitbox(damage: int) -> void:
	_cleanup_attack_area()
	
	var start := global_position
	var target := _chain_target_pos
	
	if target == Vector2.ZERO:
		target = start + _attack_dir * chain_range
	
	var to_target := target - start
	var dist = clamp(to_target.length(), chain_range * 0.55, chain_range * 1.35)
	var dir := to_target.normalized() if to_target.length_squared() > 0.001 else _attack_dir
	
	var hit := Area2D.new()
	hit.name = "WardenChainHit"
	hit.add_to_group("attack")
	hit.collision_layer = 0
	hit.collision_mask = 2
	hit.monitoring = true
	hit.monitorable = true
	
	var cs := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(dist, chain_thickness)
	cs.shape = rect
	hit.add_child(cs)
	
	hit.position = dir * (dist * 0.5)
	hit.rotation = dir.angle()
	
	hit.set_meta("attacker", self)
	hit.set_meta("damage", damage)
	hit.set_meta("damage_type", "melee")
	hit.set_meta("attack_type", "melee")
	hit.set_meta("parryable", true)
	hit.set_meta("stagger_on_block", 10.0)
	hit.set_meta("swing_token", Time.get_ticks_msec())
	hit.set_meta("is_chain_attack", true)
	hit.set_meta("allow_restrain", true)
	hit.set_meta("hit_ids", {})
	
	hit.connect("area_entered", Callable(self, "_on_chain_hit_area_entered"))
	add_child(hit)
	_attack_area = hit


func _spawn_thrust_hitbox(damage: int) -> void:
	_cleanup_attack_area()
	
	var hit := Area2D.new()
	hit.name = "WardenThrustHit"
	hit.add_to_group("attack")
	hit.collision_layer = 0
	hit.collision_mask = 2
	hit.monitoring = true
	hit.monitorable = true
	
	var cs := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(thrust_range, thrust_width)
	cs.shape = rect
	hit.add_child(cs)
	
	hit.position = _attack_dir * (thrust_range * 0.5)
	hit.rotation = _attack_dir.angle()
	
	hit.set_meta("attacker", self)
	hit.set_meta("damage", damage)
	hit.set_meta("damage_type", "melee")
	hit.set_meta("attack_type", "melee")
	hit.set_meta("parryable", true)
	hit.set_meta("stagger_on_block", 8.0)
	hit.set_meta("swing_token", Time.get_ticks_msec())
	hit.set_meta("hit_ids", {})
	
	hit.connect("area_entered", Callable(self, "_on_generic_hit_area_entered"))
	add_child(hit)
	_attack_area = hit


func _spawn_circle_hitbox(damage: int, radius: float, range_val: float) -> void:
	_cleanup_attack_area()
	
	var hit := Area2D.new()
	hit.name = "WardenSwingHit"
	hit.add_to_group("attack")
	hit.collision_layer = 0
	hit.collision_mask = 2
	hit.monitoring = true
	hit.monitorable = true
	
	var cs := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	cs.shape = circle
	hit.add_child(cs)
	
	hit.position = _attack_dir * range_val
	
	hit.set_meta("attacker", self)
	hit.set_meta("damage", damage)
	hit.set_meta("damage_type", "melee")
	hit.set_meta("attack_type", "melee")
	hit.set_meta("parryable", true)
	hit.set_meta("stagger_on_block", 8.0)
	hit.set_meta("swing_token", Time.get_ticks_msec())
	hit.set_meta("hit_ids", {})
	
	hit.connect("area_entered", Callable(self, "_on_generic_hit_area_entered"))
	add_child(hit)
	_attack_area = hit


func _on_generic_hit_area_entered(other: Area2D) -> void:
	if not is_attacking or not swinging:
		return
	
	if other == null or not other.is_in_group("player_hurtbox"):
		return
	
	if _attack_area == null or not is_instance_valid(_attack_area):
		return
	
	if _hitbox_already_hit(other):
		return
	
	var dmg := int(_attack_area.get_meta("damage", chain_damage))
	other.emit_signal("hurt", dmg, "melee", _attack_area)


func _on_chain_hit_area_entered(other: Area2D) -> void:
	if not is_attacking or not swinging:
		return
	
	if other == null or not other.is_in_group("player_hurtbox"):
		return
	
	if _attack_area == null or not is_instance_valid(_attack_area):
		return
	
	if _hitbox_already_hit(other):
		return
	
	var p := other.get_parent()
	if p == null or not p.is_in_group("player"):
		return
	
	var dmg := int(_attack_area.get_meta("damage", chain_damage))
	
	if p.has_method("has_parry_grace") and p.has_parry_grace():
		return
	
	if p.has_method("is_parrying") and p.is_parrying():
		return
	
	var allow_restrain := bool(_attack_area.get_meta("allow_restrain", false))
	
	if p.has_method("is_blocking") and p.is_blocking():
		other.emit_signal("hurt", dmg, "melee", _attack_area)
		
		if not _restraining and allow_restrain and p.has_method("apply_chain_restrain"):
			p.apply_chain_restrain(self, chain_duration, chain_break_action, chain_break_presses)
			_start_restrain(p)
		return
	
	if not _restraining and allow_restrain and p.has_method("apply_chain_restrain"):
		p.apply_chain_restrain(self, chain_duration, chain_break_action, chain_break_presses)
		_start_restrain(p)
	
	other.emit_signal("hurt", dmg, "melee", _attack_area)


func _hitbox_already_hit(other: Area2D) -> bool:
	if _attack_area == null or not is_instance_valid(_attack_area):
		return true
	
	var hit_ids: Dictionary = {}
	if _attack_area.has_meta("hit_ids"):
		hit_ids = _attack_area.get_meta("hit_ids")
	
	var oid := str(other.get_instance_id())
	if hit_ids.has(oid):
		return true
	
	hit_ids[oid] = true
	_attack_area.set_meta("hit_ids", hit_ids)
	return false


func _cleanup_attack_area() -> void:
	if _attack_area and is_instance_valid(_attack_area):
		_attack_area.set_deferred("monitoring", false)
		_attack_area.set_deferred("monitorable", false)
		_attack_area.queue_free()
	
	_attack_area = null


# =============================================================================
# CHAIN RESTRAIN
# =============================================================================

func _start_restrain(p: Node2D) -> void:
	_restraining = true
	_restrained_player = p
	_restrain_until = Time.get_ticks_msec() * 0.001 + chain_duration
	
	velocity = Vector2.ZERO
	_cancel_warden_attack(0.30)


func on_chain_broken(by_player: Node = null) -> void:
	_restraining = false
	_restrained_player = null
	_restrain_until = 0.0
	
	var now := Time.get_ticks_msec() * 0.001
	_backoff_until = now + 0.4


func _end_restrain_if_elapsed() -> void:
	if not _restraining:
		return
	
	var now := Time.get_ticks_msec() * 0.001
	if now < _restrain_until:
		return
	
	_restraining = false
	_restrained_player = null
	_restrain_until = 0.0


# =============================================================================
# DAMAGE / PARRY / DEATH
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	if state == WardenState.DEAD or has_died:
		return
	
	if hp_damage <= 0:
		return
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + hurt_stun_time
	
	if state == WardenState.WINDUP or state == WardenState.ATTACK:
		_cancel_warden_attack(0.25)
	
	if anim and anim.has_animation("hurt"):
		anim.play("hurt")
		_set_anim_speed_safe(1.0)


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()


func on_parried(player_pos: Vector2) -> void:
	if state == WardenState.DEAD or has_died:
		return
	
	_cancel_warden_attack(0.5)
	
	var kb_dir := global_position - player_pos
	if kb_dir.length_squared() < 0.001:
		kb_dir = Vector2.RIGHT
	
	knockback = Vector2.ZERO
	apply_knockback(kb_dir.normalized() * parry_knockback_force)
	hitstop_local(0.08)
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + parry_recoil_time
	_goto(WardenState.STAGGER, parry_recoil_time)


func receive_deathblow(_attacker: Node) -> void:
	force_kill_hp()
	death()


func death() -> void:
	if state == WardenState.DEAD:
		return
	
	if not mark_dead():
		return
	
	_goto(WardenState.DEAD)
	_bump_attack_gens()
	_cleanup_attack_area()
	_hide_parry_indicator()
	_release_role("melee_attack")
	_release_role("advance_move")
	has_attack_token = false
	
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)
	
	hide_posture_bar()
	notify_stance_effects_enemy_death()
	_hide_parry_indicator()
	_release_all_attack_director_state()
	_spawn_warden_rewards()
	
	velocity = Vector2.ZERO
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		await get_tree().create_timer(0.45).timeout
	else:
		await get_tree().create_timer(0.25).timeout
	
	queue_free()


func _spawn_warden_rewards() -> void:
	if exp_gem_scene == null:
		return
	
	var loot_parent := get_tree().get_first_node_in_group("loot")
	var gem := exp_gem_scene.instantiate()
	
	if gem is Node2D:
		gem.global_position = global_position
		gem.set("experience", experience)
		
		if loot_parent:
			loot_parent.call_deferred("add_child", gem)
		else:
			var parent := get_parent()
			if parent:
				parent.call_deferred("add_child", gem)


func _exit_tree() -> void:
	_bump_attack_gens()
	_cleanup_attack_area()
	_hide_parry_indicator()
	_release_role("melee_attack")
	_release_role("advance_move")
	_release_all_attack_director_state()


# =============================================================================
# AGGRO / ANIMATION / SIGNALS
# =============================================================================

func _check_aggro() -> bool:
	if not is_instance_valid(player):
		return false
	
	if auto_aggro_on_spawn or _saw_player_once:
		_saw_player_once = true
		return true
	
	if _aggro:
		_saw_player_once = true
		return true
	
	var dist := global_position.distance_to(player.global_position)
	if dist <= aggro_radius:
		_saw_player_once = true
		return true
	
	return false


func _update_sprite_facing() -> void:
	if sprite == null:
		return
	
	if velocity.length() > 5.0:
		sprite.flip_h = velocity.x < 0.0
	elif is_instance_valid(player):
		sprite.flip_h = (player.global_position.x - global_position.x) < 0.0


func _update_animation() -> void:
	if anim == null:
		return
	
	if state == WardenState.WINDUP or state == WardenState.ATTACK:
		return
	
	var anim_name := "idle"
	
	match state:
		WardenState.PATROL, WardenState.ENGAGE:
			anim_name = "walk" if _last_move_speed > 8.0 else "idle"
		WardenState.RECOVER:
			anim_name = "idle"
		WardenState.STAGGER:
			anim_name = "hurt" if anim.has_animation("hurt") else "idle"
		WardenState.DEAD:
			anim_name = "death" if anim.has_animation("death") else "idle"
	
	if anim.has_animation(anim_name) and _current_anim != anim_name:
		anim.play(anim_name)
		_current_anim = anim_name
	
	if anim_name == "walk":
		anim.speed_scale = clamp(_last_move_speed / max(1.0, movement_speed), 0.5, 1.35)
	elif anim_name == "idle":
		anim.speed_scale = 1.0


func _player_hidden_in_smoke() -> bool:
	if not is_instance_valid(player):
		return false
	
	return player.has_meta("in_smoke_cloud") and bool(player.get_meta("in_smoke_cloud"))


func _on_player_trigger_range_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = true


func _on_player_trigger_range_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = false
