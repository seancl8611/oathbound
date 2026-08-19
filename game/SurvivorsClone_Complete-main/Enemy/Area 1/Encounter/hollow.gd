extends BeastEnemyBase
class_name Hollow

## =============================================================================
## HOLLOW - Lightweight Beast Swarm Enemy
## =============================================================================
## Role:
## - Weak, simple, feral swarm enemy
## - No blocking
## - No counterattack-on-block behavior
## - Simple chase -> bite/lunge/double bite loop
## - Uses BeastEnemyBase for shared refs, damage intake, parry indicator,
##   AttackDirector helpers, stance/prosthetic ticking, hitstop, and cleanup.
## =============================================================================

# =============================================================================
# ATTACK TYPES
# =============================================================================

enum HollowAttack {
	QUICK_BITE,
	LUNGE_BITE,
	DOUBLE_BITE
}


enum HollowState {
	PATROL,
	CHASE,
	WINDUP,
	ATTACK,
	RECOVER,
	STAGGER,
	DEAD
}


# =============================================================================
# HOLLOW TUNING
# =============================================================================

@export_group("Hollow Stats")
@export var hollow_hp: int = 28
@export var hollow_experience: int = 1
@export var hollow_move_speed: float = 48.0

@export_group("Hollow Spacing")
@export var patrol_speed: float = 28.0
@export var attack_min_range: float = 12.0
@export var quick_bite_range: float = 42.0
@export var lunge_bite_min_range: float = 42.0
@export var lunge_bite_max_range: float = 82.0
@export var chase_stop_distance: float = 28.0

@export_group("Hollow Attacks")
@export var quick_bite_damage: int = 2
@export var lunge_bite_damage: int = 3
@export var double_bite_damage: int = 2

@export var quick_bite_windup: float = 0.24
@export var lunge_bite_windup: float = 0.34
@export var double_bite_windup: float = 0.26
@export var double_bite_second_windup: float = 0.16

@export var bite_active_time: float = 0.16
@export var recover_time: float = 0.45

@export var attack_cooldown_min: float = 0.55
@export var attack_cooldown_max: float = 1.05

@export var bite_move_speed: float = 95.0
@export var lunge_bite_move_speed: float = 245.0
@export var bite_radius: float = 24.0
@export var bite_offset: float = 20.0

@export_group("Hollow Parry / Stagger")
@export var parry_recoil_time: float = 0.55
@export var parry_knockback_force: float = 75.0
@export var parry_hp_damage: int = 6
@export var hurt_stun_time: float = 0.12

@export_group("Hollow Rewards")
@export var exp_gem_scene: PackedScene = null


# =============================================================================
# RUNTIME
# =============================================================================

var state: int = HollowState.PATROL
var _state_timer: float = 0.0

var _aggro: bool = false
var _next_attack_ready: float = 0.0
var _stunned_until: float = 0.0

var _current_attack: int = HollowAttack.QUICK_BITE
var _last_attack: int = HollowAttack.QUICK_BITE
var _combo_bites_remaining: int = 0

var _attack_dir: Vector2 = Vector2.RIGHT
var _attack_move_speed: float = 0.0
var _hollow_attack_area: Area2D = null

var _last_pos: Vector2 = Vector2.ZERO
var _last_move_speed: float = 0.0
var _current_anim: String = ""

signal remove_from_array(object)


# =============================================================================
# INITIALIZATION
# =============================================================================

func _ready() -> void:
	_apply_hollow_defaults()
	super._ready()
	_load_default_reward_assets_if_needed()
	
	beast_attack_role = "hollow_lunge"
	beast_face_player = false
	
	_home_pos = global_position
	_patrol_target = global_position
	
	print("[Hollow] v1.0 - BeastEnemyBase migrated")


func _apply_hollow_defaults() -> void:
	hp = hollow_hp
	experience = hollow_experience
	movement_speed = hollow_move_speed
	
	# Keep BeastEnemyBase lunge speed separate from this script's local lunge bite speed.
	lunge_speed = lunge_bite_move_speed


func _load_default_reward_assets_if_needed() -> void:
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
	
	if state == HollowState.DEAD:
		return
	
	_sync_attack_director_roles(now)
	
	_track_movement_speed(delta)
	
	if _beast_tick_shared(delta):
		_update_animation()
		return
	
	if now < _stunned_until and state != HollowState.STAGGER:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		_update_sprite_facing()
		_update_animation()
		return
	
	if _state_timer > 0.0:
		_state_timer -= delta
	
	match state:
		HollowState.PATROL:
			_state_patrol(delta, now)
		HollowState.CHASE:
			_state_chase(delta, now)
		HollowState.WINDUP:
			_state_windup(delta, now)
		HollowState.ATTACK:
			_state_attack(delta, now)
		HollowState.RECOVER:
			_state_recover(delta, now)
		HollowState.STAGGER:
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


func _state_patrol(_delta: float, now: float) -> void:
	if _check_aggro():
		_goto(HollowState.CHASE)
		return
	
	if global_position.distance_to(_patrol_target) < 8.0 or now >= _patrol_until:
		var angle := randf() * TAU
		var dist := randf_range(24.0, patrol_wander_radius)
		_patrol_target = _home_pos + Vector2(cos(angle), sin(angle)) * dist
		_patrol_until = now + randf_range(1.6, 3.2)
	
	var to_target := _patrol_target - global_position
	if to_target.length() > 2.0:
		velocity = to_target.normalized() * patrol_speed
	else:
		velocity = Vector2.ZERO


func _state_chase(_delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(HollowState.PATROL)
		return
	
	if _player_hidden_in_smoke():
		_cancel_hollow_attack(0.25)
		velocity = Vector2.ZERO
		return
	
	var to_player := player.global_position - global_position
	var dist := to_player.length()
	var dir := to_player.normalized() if dist > 0.001 else Vector2.RIGHT
	
	if dist > deaggro_radius:
		_saw_player_once = false
		_goto(HollowState.PATROL)
		return
	
	if now < _backoff_until:
		velocity = dir.rotated(PI * 0.5) * movement_speed * 0.45
		return
	
	if now >= _next_attack_ready and _can_start_hollow_attack(dist):
		_try_start_hollow_attack(dist)
		return
	
	if dist > chase_stop_distance:
		if _approach_gate_ok():
			velocity = dir * movement_speed
		else:
			velocity = dir.rotated(PI * 0.5) * movement_speed * 0.45
	else:
		velocity = Vector2.ZERO


func _state_windup(_delta: float, _now: float) -> void:
	velocity = Vector2.ZERO
	
	# Light tracking during early windup only.
	if is_instance_valid(player) and _state_timer > 0.08:
		var to_player := player.global_position - global_position
		if to_player.length_squared() > 0.001:
			_attack_dir = to_player.normalized()
	
	if _state_timer <= 0.0:
		_begin_active_bite()


func _state_attack(_delta: float, _now: float) -> void:
	velocity = _attack_dir * _attack_move_speed
	
	if _state_timer <= 0.0:
		_cleanup_hollow_attack_area()
		
		_combo_bites_remaining -= 1
		if _combo_bites_remaining > 0:
			_enter_windup(double_bite_second_windup)
			return
		
		_finish_hollow_attack()


func _state_recover(_delta: float, _now: float) -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 350.0 * _delta)
	
	if _state_timer <= 0.0:
		_goto(HollowState.CHASE)


func _state_stagger(_delta: float, _now: float) -> void:
	velocity = knockback
	
	if _state_timer <= 0.0:
		_goto(HollowState.CHASE)


# =============================================================================
# ATTACK SELECTION / EXECUTION
# =============================================================================

func _can_start_hollow_attack(dist: float) -> bool:
	if has_died:
		return false
	
	if state == HollowState.WINDUP or state == HollowState.ATTACK:
		return false
	
	if ProstheticEffects.is_confused(self):
		return false
	
	return dist >= attack_min_range and dist <= lunge_bite_max_range


func _try_start_hollow_attack(dist: float) -> void:
	if not _request_attack_token():
		return
	
	var chosen := _select_hollow_attack(dist)
	
	if chosen == HollowAttack.LUNGE_BITE:
		if not _request_lunge_role():
			_release_attack_token()
			return
	
	_start_hollow_attack(chosen)


func _select_hollow_attack(dist: float) -> int:
	var weights := {
		HollowAttack.QUICK_BITE: 0.50,
		HollowAttack.LUNGE_BITE: 0.25,
		HollowAttack.DOUBLE_BITE: 0.25
	}
	
	if dist < lunge_bite_min_range:
		weights[HollowAttack.LUNGE_BITE] = 0.0
	elif dist <= lunge_bite_max_range:
		weights[HollowAttack.LUNGE_BITE] = 0.40
	
	if dist > quick_bite_range:
		weights[HollowAttack.QUICK_BITE] = 0.15
		weights[HollowAttack.DOUBLE_BITE] = 0.15
	
	if weights.has(_last_attack):
		weights[_last_attack] = float(weights[_last_attack]) * 0.35
	
	var total := 0.0
	for value in weights.values():
		total += float(value)
	
	if total <= 0.001:
		_last_attack = HollowAttack.QUICK_BITE
		return HollowAttack.QUICK_BITE
	
	var roll := randf() * total
	var cumulative := 0.0
	
	for attack_type in weights.keys():
		cumulative += float(weights[attack_type])
		if roll <= cumulative:
			_last_attack = int(attack_type)
			return int(attack_type)
	
	_last_attack = HollowAttack.QUICK_BITE
	return HollowAttack.QUICK_BITE


func _start_hollow_attack(attack_type: int) -> void:
	_current_attack = attack_type
	_combo_bites_remaining = 2 if attack_type == HollowAttack.DOUBLE_BITE else 1
	
	if is_instance_valid(player):
		var to_player := player.global_position - global_position
		if to_player.length_squared() > 0.001:
			_attack_dir = to_player.normalized()
	
	match attack_type:
		HollowAttack.QUICK_BITE:
			_enter_windup(quick_bite_windup)
		HollowAttack.LUNGE_BITE:
			_enter_windup(lunge_bite_windup)
		HollowAttack.DOUBLE_BITE:
			_enter_windup(double_bite_windup)


func _enter_windup(windup_time: float) -> void:
	_bump_attack_gen()
	_cleanup_hollow_attack_area()
	
	var indicator_duration := windup_time + bite_active_time + 0.10
	_show_parry_indicator(indicator_duration, false)
	
	if anim and anim.has_animation("attack_windup"):
		anim.play("attack_windup")
		var base_len := anim.get_animation("attack_windup").length
		_set_anim_speed_safe(base_len / max(0.001, windup_time))
	
	_goto(HollowState.WINDUP, windup_time)


func _begin_active_bite() -> void:
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	var damage := quick_bite_damage
	_attack_move_speed = bite_move_speed
	
	match _current_attack:
		HollowAttack.QUICK_BITE:
			damage = quick_bite_damage
			_attack_move_speed = bite_move_speed
		HollowAttack.LUNGE_BITE:
			damage = lunge_bite_damage
			_attack_move_speed = lunge_bite_move_speed
		HollowAttack.DOUBLE_BITE:
			damage = double_bite_damage
			_attack_move_speed = bite_move_speed
	
	_spawn_hollow_bite_area(damage)
	
	if anim and anim.has_animation("attack_slash"):
		anim.play("attack_slash")
	elif anim and anim.has_animation("attack"):
		anim.play("attack")
	
	_goto(HollowState.ATTACK, bite_active_time)


func _finish_hollow_attack() -> void:
	_cleanup_hollow_attack_area()
	_hide_parry_indicator()
	
	_release_attack_token()
	_release_role(beast_attack_role)
	_release_role("advance_move")
	
	var now := Time.get_ticks_msec() * 0.001
	_next_attack_ready = now + randf_range(attack_cooldown_min, attack_cooldown_max)
	
	_goto(HollowState.RECOVER, recover_time)


func _cancel_hollow_attack(backoff_time: float = 0.35) -> void:
	_bump_attack_gen()
	_cleanup_hollow_attack_area()
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	
	_combo_bites_remaining = 0
	_release_attack_token()
	_release_role(beast_attack_role)
	_release_role("advance_move")
	
	var now := Time.get_ticks_msec() * 0.001
	_backoff_until = max(_backoff_until, now + backoff_time)
	_next_attack_ready = max(_next_attack_ready, now + backoff_time)
	
	if state != HollowState.DEAD:
		_goto(HollowState.RECOVER, min(recover_time, 0.35))


func _on_beast_attack_director_revoked(_now: float) -> void:
	_cancel_hollow_attack(0.55)


# =============================================================================
# BITE HITBOX
# =============================================================================

func _spawn_hollow_bite_area(damage: int) -> void:
	_cleanup_hollow_attack_area()
	
	var area := Area2D.new()
	area.name = "HollowBite"
	area.add_to_group("attack")
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitoring = true
	area.monitorable = true
	
	area.set_meta("attacker", self)
	area.set_meta("damage", damage)
	area.set_meta("damage_type", "melee")
	area.set_meta("attack_type", "melee")
	area.set_meta("parryable", true)
	area.set_meta("stagger_on_block", 6.0)
	area.set_meta("swing_token", Time.get_ticks_msec())
	area.set_meta("consumed", false)
	
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = bite_radius
	shape.shape = circle
	area.add_child(shape)
	
	area.position = _attack_dir * bite_offset
	
	if is_instance_valid(sprite):
		area.z_index = sprite.z_index - 1
	else:
		area.z_index = z_index - 1
	
	area.show_behind_parent = true
	
	if not area.is_connected("area_entered", Callable(self, "_on_hollow_bite_area_entered")):
		area.connect("area_entered", Callable(self, "_on_hollow_bite_area_entered"))
	
	add_child(area)
	_hollow_attack_area = area


func _on_hollow_bite_area_entered(area: Area2D) -> void:
	if area == null:
		return
	
	if not area.is_in_group("player_hurtbox"):
		return
	
	if _hollow_attack_area == null or not is_instance_valid(_hollow_attack_area):
		return
	
	if _hollow_attack_area.has_meta("consumed") and bool(_hollow_attack_area.get_meta("consumed")):
		return
	
	_hollow_attack_area.set_meta("consumed", true)
	
	var damage := int(_hollow_attack_area.get_meta("damage", quick_bite_damage))
	var damage_type := str(_hollow_attack_area.get_meta("damage_type", "melee"))
	
	if area.has_signal("hurt"):
		# Pass the hitbox Area2D so player-side block/parry logic can inspect metadata.
		area.emit_signal("hurt", damage, damage_type, _hollow_attack_area)


func _cleanup_hollow_attack_area() -> void:
	if _hollow_attack_area and is_instance_valid(_hollow_attack_area):
		_hollow_attack_area.set_deferred("monitoring", false)
		_hollow_attack_area.set_deferred("monitorable", false)
		_hollow_attack_area.set_meta("consumed", true)
		_hollow_attack_area.queue_free()
	
	_hollow_attack_area = null


# =============================================================================
# DAMAGE / PARRY / DEATH
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	if state == HollowState.DEAD or has_died:
		return
	
	if hp_damage <= 0:
		return
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + hurt_stun_time
	
	if state == HollowState.WINDUP or state == HollowState.ATTACK:
		_cancel_hollow_attack(0.25)
	
	if safe_play_anim("hurt", true):
		_set_anim_speed_safe(1.0)


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()


func on_parried(parrier_pos: Vector2) -> void:
	if state == HollowState.DEAD or has_died:
		return
	
	_cancel_hollow_attack(0.5)
	
	var kb_dir := global_position - parrier_pos
	if kb_dir.length_squared() < 0.001:
		kb_dir = Vector2.RIGHT
	
	knockback = Vector2.ZERO
	apply_knockback(kb_dir.normalized() * parry_knockback_force)
	hitstop_local(0.08)
	
	if parry_hp_damage > 0:
		apply_hp_damage(parry_hp_damage)
		show_enemy_damage_number(parry_hp_damage, "parry", -24.0)
	
	if hp <= 0:
		death()
		return
	
	_stunned_until = Time.get_ticks_msec() * 0.001 + parry_recoil_time
	_goto(HollowState.STAGGER, parry_recoil_time)
	
	if sprite:
		var tw := create_tween()
		tw.tween_property(sprite, "modulate", Color(1.5, 1.5, 1.5), 0.05)
		tw.tween_property(sprite, "modulate", Color.WHITE, 0.15)


func receive_deathblow(_attacker: Node) -> void:
	force_kill_hp()
	death()


func death() -> void:
	if state == HollowState.DEAD:
		return
	
	if not mark_dead():
		return
	
	_goto(HollowState.DEAD)
	_bump_attack_gen()
	_cleanup_hollow_attack_area()
	_reset_beast_runtime()
	
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)
	
	hide_posture_bar()
	notify_stance_effects_enemy_death()
	_spawn_hollow_rewards()
	
	velocity = Vector2.ZERO
	
	if anim and anim.has_animation("death"):
		anim.play("death")
		await get_tree().create_timer(0.45).timeout
	else:
		await get_tree().create_timer(0.25).timeout
	
	queue_free()


func _spawn_hollow_rewards() -> void:
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
	_bump_attack_gen()
	_cleanup_hollow_attack_area()
	_disconnect_beast_attack_director_signals()
	_release_all_attack_director_state()


# =============================================================================
# AGGRO / ANIMATION / HELPERS
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
	
	if state == HollowState.WINDUP or state == HollowState.ATTACK:
		return
	
	var anim_name := "idle"
	
	match state:
		HollowState.PATROL, HollowState.CHASE:
			anim_name = "walk" if _last_move_speed > 8.0 else "idle"
		HollowState.RECOVER:
			anim_name = "idle"
		HollowState.STAGGER:
			anim_name = "hurt" if anim.has_animation("hurt") else "idle"
		HollowState.DEAD:
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


# =============================================================================
# SIGNAL CONNECTIONS
# =============================================================================

func _on_player_trigger_range_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = true


func _on_player_trigger_range_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_aggro = false
