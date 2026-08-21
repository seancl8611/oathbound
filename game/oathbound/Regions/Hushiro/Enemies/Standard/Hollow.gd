extends BeastEnemyBase
class_name Hollow

## Hushiro's simple swarm enemy.
##
## Hollows intentionally use one readable bite. Hounds own fast lunge pressure; the
## Hollow's job is to occupy space, threaten a clear attack turn, and visibly recoil
## when Akio wins contact. This keeps a group from behaving like four duelists.

enum HollowState {
	PATROL,
	CHASE,
	WINDUP,
	ATTACK,
	RECOVER,
	STAGGER,
	DEAD,
}

@export_group("Hollow Stats")
@export var hollow_hp: int = 60
@export var hollow_experience: int = 1
@export var hollow_move_speed: float = 52.0

@export_group("Hollow Spacing")
@export var patrol_speed: float = 26.0
@export var preferred_wait_distance: float = 78.0
@export var attack_range: float = 46.0
@export var chase_stop_distance: float = 36.0
@export var orbit_speed: float = 28.0

@export_group("Hollow Bite")
@export var bite_damage: int = 3
@export var bite_windup: float = 0.40
@export var bite_active_time: float = 0.13
@export var bite_recover_time: float = 0.65
@export var attack_cooldown_min: float = 1.15
@export var attack_cooldown_max: float = 1.65
@export var bite_move_speed: float = 78.0
@export var bite_radius: float = 23.0
@export var bite_offset: float = 19.0

@export_group("Hollow Reactions")
@export var hurt_stun_time: float = 0.22
@export var parry_recoil_time: float = 0.58
@export var parry_knockback_force: float = 75.0
@export var parry_hp_damage: int = 0

@export_group("Hollow Rewards")
@export var exp_gem_scene: PackedScene = null

var state: int = HollowState.PATROL
var _state_timer: float = 0.0
var _next_attack_ready: float = 0.0
var _attack_dir: Vector2 = Vector2.RIGHT
var _attack_area: Area2D = null
var _orbit_direction: float = 1.0
var _last_anim: String = ""

signal remove_from_array(object)


func _ready() -> void:
	hp = hollow_hp
	experience = hollow_experience
	movement_speed = hollow_move_speed
	beast_attack_role = ""
	beast_face_player = false
	super._ready()
	_home_pos = global_position
	_patrol_target = global_position
	_orbit_direction = -1.0 if randf() < 0.5 else 1.0
	_load_default_reward_assets_if_needed()
	print("[Hollow] v2.0 - readable swarm pressure")


func _physics_process(delta: float) -> void:
	if state == HollowState.DEAD or has_died:
		return

	var now := Time.get_ticks_msec() * 0.001
	_sync_attack_director_roles(now)

	if _beast_tick_shared(delta):
		_update_animation()
		return

	_state_timer = maxf(0.0, _state_timer - delta)

	match state:
		HollowState.PATROL:
			_tick_patrol(now)
		HollowState.CHASE:
			_tick_chase(now)
		HollowState.WINDUP:
			_tick_windup()
		HollowState.ATTACK:
			_tick_attack()
		HollowState.RECOVER:
			_tick_recover()
		HollowState.STAGGER:
			_tick_stagger()

	if knockback.length() > 1.0:
		velocity += knockback

	move_and_slide()
	_update_sprite_facing()
	_update_animation()


func _goto(next_state: int, duration: float = 0.0) -> void:
	state = next_state
	_state_timer = duration


func _tick_patrol(now: float) -> void:
	if _is_engaged():
		_goto(HollowState.CHASE)
		return

	if global_position.distance_to(_patrol_target) < 8.0 or now >= _patrol_until:
		var angle := randf() * TAU
		_patrol_target = _home_pos + Vector2.from_angle(angle) * randf_range(20.0, patrol_wander_radius)
		_patrol_until = now + randf_range(1.5, 3.0)

	var to_target := _patrol_target - global_position
	velocity = to_target.normalized() * patrol_speed if to_target.length() > 4.0 else Vector2.ZERO


func _tick_chase(now: float) -> void:
	if not is_instance_valid(player):
		_goto(HollowState.PATROL)
		velocity = Vector2.ZERO
		return

	if _player_hidden_in_smoke():
		velocity = Vector2.ZERO
		return

	var to_player := player.global_position - global_position
	var distance := to_player.length()
	if distance > deaggro_radius:
		_saw_player_once = false
		_goto(HollowState.PATROL)
		return

	var toward := to_player.normalized() if distance > 0.001 else Vector2.RIGHT

	if now >= _next_attack_ready and distance <= attack_range:
		if _request_attack_token():
			_begin_bite(toward)
			return

	# Waiting Hollows do not crowd the active duelist. They orbit outside bite range,
	# approaching only when there is room in the frontline.
	if has_attack_token:
		velocity = toward * movement_speed
	elif distance > preferred_wait_distance + 14.0:
		if _approach_gate_ok():
			velocity = toward * movement_speed * 0.75
		else:
			velocity = toward.rotated(_orbit_direction * PI * 0.5) * orbit_speed
	elif distance < chase_stop_distance:
		velocity = -toward * movement_speed * 0.45
	else:
		var tangent := toward.rotated(_orbit_direction * PI * 0.5)
		var radial_error := clampf((distance - preferred_wait_distance) / 30.0, -1.0, 1.0)
		velocity = tangent * orbit_speed + toward * (radial_error * 18.0)


func _begin_bite(toward: Vector2) -> void:
	_release_role("advance_move")
	_attack_dir = toward if toward.length_squared() > 0.001 else Vector2.RIGHT
	_cleanup_attack_area()
	_show_parry_indicator(bite_windup + bite_active_time, false)
	if anim and anim.has_animation("attack_windup"):
		var base_len := anim.get_animation("attack_windup").length
		_set_anim_speed_safe(base_len / maxf(0.001, bite_windup))
		anim.play("attack_windup")
	_last_anim = "attack_windup"
	velocity = Vector2.ZERO
	_goto(HollowState.WINDUP, bite_windup)


func _tick_windup() -> void:
	velocity = Vector2.ZERO
	if _state_timer <= 0.0:
		_begin_active_bite()


func _begin_active_bite() -> void:
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	_spawn_bite_area()
	if anim and anim.has_animation("attack_slash"):
		anim.play("attack_slash")
		_last_anim = "attack_slash"
	_goto(HollowState.ATTACK, bite_active_time)


func _tick_attack() -> void:
	velocity = _attack_dir * bite_move_speed
	if _state_timer <= 0.0:
		_cleanup_attack_area()
		_release_attack_token()
		_next_attack_ready = Time.get_ticks_msec() * 0.001 + randf_range(attack_cooldown_min, attack_cooldown_max)
		_goto(HollowState.RECOVER, bite_recover_time)


func _tick_recover() -> void:
	velocity = velocity.move_toward(Vector2.ZERO, 300.0 * get_physics_process_delta_time())
	if _state_timer <= 0.0:
		_goto(HollowState.CHASE)


func _tick_stagger() -> void:
	velocity = knockback
	if _state_timer <= 0.0:
		_goto(HollowState.CHASE)


func _cancel_current_action(recovery: float = 0.28) -> void:
	_cleanup_attack_area()
	_hide_parry_indicator()
	_set_anim_speed_safe(1.0)
	_release_attack_token()
	_release_role("advance_move")
	_next_attack_ready = maxf(_next_attack_ready, Time.get_ticks_msec() * 0.001 + 0.55)
	if state != HollowState.DEAD:
		_goto(HollowState.RECOVER, recovery)


func _on_beast_attack_director_revoked(_now: float) -> void:
	# This should now happen only for cleanup/death, never because another enemy stole
	# the active melee turn.
	_cancel_current_action(0.30)


func _spawn_bite_area() -> void:
	_cleanup_attack_area()
	var area := Area2D.new()
	area.name = "HollowBite"
	area.add_to_group("attack")
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitoring = true
	area.monitorable = true
	area.position = _attack_dir * bite_offset
	area.set_meta("attacker", self)
	area.set_meta("attack_id", "hollow_bite")
	area.set_meta("damage", bite_damage)
	area.set_meta("health_damage", bite_damage)
	area.set_meta("damage_type", "melee")
	area.set_meta("parryable", true)
	area.set_meta("blockable", true)
	area.set_meta("block_posture_damage", 6.0)
	area.set_meta("consumed", false)

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = bite_radius
	shape.shape = circle
	area.add_child(shape)
	area.area_entered.connect(_on_bite_area_entered)
	add_child(area)
	_attack_area = area


func _on_bite_area_entered(hurtbox: Area2D) -> void:
	if hurtbox == null or not hurtbox.is_in_group("player_hurtbox"):
		return
	if _attack_area == null or not is_instance_valid(_attack_area):
		return
	if bool(_attack_area.get_meta("consumed", false)):
		return
	_attack_area.set_meta("consumed", true)

	var receiver := hurtbox.get_parent()
	var before: Dictionary = {}
	if CombatTelemetry != null and CombatTelemetry.is_capturing() and receiver != null:
		before = CombatTelemetry.snapshot_actor(receiver)

	if hurtbox.has_signal("hurt"):
		hurtbox.emit_signal("hurt", bite_damage, "melee", _attack_area)

	if CombatTelemetry != null and CombatTelemetry.is_capturing() and receiver != null:
		CombatTelemetry.record_contact(receiver, _attack_area, self, before)


func _cleanup_attack_area() -> void:
	if _attack_area != null and is_instance_valid(_attack_area):
		_attack_area.monitoring = false
		_attack_area.monitorable = false
		_attack_area.set_meta("consumed", true)
		_attack_area.queue_free()
	_attack_area = null


func _on_base_damaged(hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	if hp_damage <= 0 or state == HollowState.DEAD or has_died:
		return
	_cancel_current_action(0.0)
	_goto(HollowState.STAGGER, hurt_stun_time)
	if anim:
		if anim.has_animation("parried"):
			anim.play("parried")
			_last_anim = "parried"
		elif anim.has_animation("hurt"):
			anim.play("hurt")
			_last_anim = "hurt"


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()


func on_parried(parrier_pos: Vector2) -> void:
	if state == HollowState.DEAD or has_died:
		return
	_cancel_current_action(0.0)
	var away := global_position - parrier_pos
	if away.length_squared() <= 0.001:
		away = Vector2.RIGHT
	knockback = Vector2.ZERO
	apply_knockback(away.normalized() * parry_knockback_force)
	hitstop_local(0.08)
	add_posture_damage(20.0)
	if parry_hp_damage > 0:
		apply_hp_damage(parry_hp_damage)
	if hp <= 0:
		death()
		return
	_goto(HollowState.STAGGER, parry_recoil_time)
	if anim and anim.has_animation("parried"):
		anim.play("parried")
		_last_anim = "parried"


func receive_deathblow(_attacker: Node) -> void:
	force_kill_hp()
	death()


func death() -> void:
	if state == HollowState.DEAD or not mark_dead():
		return
	state = HollowState.DEAD
	_cleanup_attack_area()
	_reset_beast_runtime()
	notify_stance_effects_enemy_death()
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)
	hide_posture_bar()
	_spawn_hollow_rewards()
	velocity = Vector2.ZERO
	if anim and anim.has_animation("death"):
		anim.play("death")
		await get_tree().create_timer(0.40).timeout
	else:
		await get_tree().create_timer(0.18).timeout
	queue_free()


func _load_default_reward_assets_if_needed() -> void:
	if exp_gem_scene != null:
		return
	for path in ["res://Objects/experience_gem.tscn", "res://Objects/ExperienceGem.tscn", "res://Items/experience_gem.tscn"]:
		if ResourceLoader.exists(path):
			exp_gem_scene = load(path) as PackedScene
			return


func _spawn_hollow_rewards() -> void:
	if exp_gem_scene == null:
		return
	var gem := exp_gem_scene.instantiate()
	if not (gem is Node2D):
		return
	(gem as Node2D).global_position = global_position
	gem.set("experience", experience)
	var loot_parent := get_tree().get_first_node_in_group("loot")
	if loot_parent != null:
		loot_parent.call_deferred("add_child", gem)
	elif get_parent() != null:
		get_parent().call_deferred("add_child", gem)


func _is_engaged() -> bool:
	if not is_instance_valid(player):
		return false
	if auto_aggro_on_spawn or _saw_player_once:
		_saw_player_once = true
		return true
	if global_position.distance_to(player.global_position) <= aggro_radius:
		_saw_player_once = true
		return true
	return false


func _player_hidden_in_smoke() -> bool:
	return is_instance_valid(player) and player.has_meta("in_smoke_cloud") and bool(player.get_meta("in_smoke_cloud"))


func _update_sprite_facing() -> void:
	if sprite == null:
		return
	if velocity.length() > 5.0:
		sprite.flip_h = velocity.x < 0.0
	elif is_instance_valid(player):
		sprite.flip_h = player.global_position.x < global_position.x


func _update_animation() -> void:
	if anim == null or state in [HollowState.WINDUP, HollowState.ATTACK, HollowState.STAGGER, HollowState.DEAD]:
		return
	var desired := "walk" if velocity.length() > 7.0 else "RESET"
	if not anim.has_animation(desired):
		desired = "walk" if anim.has_animation("walk") else ""
	if not desired.is_empty() and desired != _last_anim:
		anim.play(desired)
		_last_anim = desired
	if desired == "walk":
		anim.speed_scale = clampf(velocity.length() / maxf(1.0, movement_speed), 0.55, 1.15)


func _exit_tree() -> void:
	_cleanup_attack_area()
	_disconnect_beast_attack_director_signals()
	_release_all_attack_director_state()
