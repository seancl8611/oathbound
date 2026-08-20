extends EnemyBase
class_name MistShepherd

## =============================================================================
## MIST SHEPHERD - Area 2 Support Caster
## =============================================================================
## Role:
## - Non-blocking support enemy
## - Keeps distance from the player
## - Buffs nearby enemies with spectral mist/threads
## - Teleports once at low HP
## - Extends EnemyBase directly because it is not a beast attacker or humanoid duelist
## =============================================================================

# =============================================================================
# CORE TUNING
# =============================================================================

@export_group("Mist Shepherd Stats")
@export var shepherd_hp: int = 20
@export var shepherd_experience: int = 1
@export var shepherd_move_speed: float = 25.0

@export_group("Range Keeping")
@export var min_range: float = 250.0
@export var max_range: float = 300.0

@export_group("Buff System")
@export var buff_radius: float = 250.0
@export var buff_speed_mult: float = 1.5
@export var buff_damage_mult: float = 1.5
@export var buff_hp_mult: float = 1.5
@export var buff_interval: float = 1.0

@export_group("Teleport")
@export var teleport_hp_threshold: float = 0.5
@export var teleport_distance_min: float = 200.0
@export var teleport_distance_max: float = 300.0
@export var teleport_windup: float = 0.30

@export_group("Reaction")
@export var hurt_stun_time: float = 0.12
@export var posture_break_duration: float = 4.0
@export var posture_break_immunity_extra: float = 0.5

@export_group("Death / Rewards")
@export var death_anim_scene: PackedScene = null
@export var exp_gem_scene: PackedScene = null


# =============================================================================
# RUNTIME
# =============================================================================

var stunned_until: float = 0.0

var has_teleported: bool = false

var _dbroken_active: bool = false
var _dbreak_until: float = 0.0
var _dbreak_immunity_until: float = 0.0

var _buff_timer: Timer = null
var _last_pos: Vector2 = Vector2.ZERO
var _last_move_speed: float = 0.0
var _current_anim: String = ""

signal remove_from_array(object)


# =============================================================================
# INITIALIZATION
# =============================================================================

func _ready() -> void:
	_apply_shepherd_defaults()
	_load_default_assets_if_needed()
	
	_base_enemy_ready()
	
	_setup_buff_timer()
	
	if anim and anim.has_animation("walk"):
		anim.play("walk")
		_current_anim = "walk"
	elif anim and anim.has_animation("idle"):
		anim.play("idle")
		_current_anim = "idle"
	
	print("[MistShepherd] v1.0 - EnemyBase support caster migrated")


func _apply_shepherd_defaults() -> void:
	hp = shepherd_hp
	experience = shepherd_experience
	movement_speed = shepherd_move_speed
	
	if _max_hp <= 0:
		_max_hp = hp


func _load_default_assets_if_needed() -> void:
	if death_anim_scene == null:
		var death_paths := [
			"res://Enemy/explosion.tscn",
			"res://Enemy/Explosion.tscn",
			"res://Effects/explosion.tscn",
			"res://VFX/explosion.tscn"
		]
		
		for path in death_paths:
			if ResourceLoader.exists(path):
				death_anim_scene = load(path) as PackedScene
				break
	
	if exp_gem_scene == null:
		var exp_paths := [
			"res://Objects/experience_gem.tscn",
			"res://Objects/ExperienceGem.tscn",
			"res://Items/experience_gem.tscn"
		]
		
		for path in exp_paths:
			if ResourceLoader.exists(path):
				exp_gem_scene = load(path) as PackedScene
				break


func _setup_buff_timer() -> void:
	_buff_timer = get_node_or_null("BuffTimer") as Timer
	
	if _buff_timer == null:
		_buff_timer = Timer.new()
		_buff_timer.name = "BuffTimer"
		add_child(_buff_timer)
	
	_buff_timer.wait_time = buff_interval
	_buff_timer.one_shot = false
	_buff_timer.autostart = true
	
	if not _buff_timer.timeout.is_connected(_buff_nearby_enemies):
		_buff_timer.timeout.connect(_buff_nearby_enemies)
	
	_buff_timer.start()


# =============================================================================
# MAIN LOOP
# =============================================================================

func _physics_process(delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	if has_died:
		return
	
	_track_movement_speed(delta)
	
	ProstheticEffects.tick(self, delta)
	
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		se.tick(self, delta)
	
	_tick_shepherd_posture_break_recovery(now)
	
	if tick_base_hitstop():
		move_and_slide()
		_update_animation()
		return
	
	if now < stunned_until:
		velocity = knockback
		move_and_slide()
		tick_base_knockback(delta)
		sync_posture_bar_position()
		_update_sprite_facing()
		_update_animation()
		return
	
	if ProstheticEffects.override_movement(self, delta):
		sync_posture_bar_position()
		return
	
	sync_posture_bar_position()
	tick_base_knockback(delta)
	
	_update_range_keeping()
	
	var frost_mult := float(get_meta("_stance_frost_speed_mult", 1.0))
	if frost_mult < 1.0:
		velocity *= frost_mult
	
	move_and_slide()
	_update_sprite_facing()
	_update_animation()


func _track_movement_speed(delta: float) -> void:
	var prev := _last_pos if _last_pos != Vector2.ZERO else global_position
	var moved := global_position - prev
	_last_move_speed = moved.length() / max(0.0001, delta)
	_last_pos = global_position


func _update_range_keeping() -> void:
	if not is_instance_valid(player):
		velocity = knockback
		return
	
	var distance := global_position.distance_to(player.global_position)
	var direction := (player.global_position - global_position).normalized()
	
	if distance < min_range:
		velocity = -direction * movement_speed + knockback
	elif distance > max_range:
		velocity = direction * movement_speed + knockback
	else:
		velocity = knockback


# =============================================================================
# DAMAGE / POSTURE / TELEPORT
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	if has_died:
		return
	
	if hp_damage <= 0:
		return
	
	stunned_until = Time.get_ticks_msec() * 0.001 + hurt_stun_time
	
	if not has_teleported and get_hp_ratio() <= teleport_hp_threshold:
		has_teleported = true
		call_deferred("_teleport_away")
	else:
		if has_node("snd_hit"):
			var snd = get_node("snd_hit")
			if snd and snd.has_method("play"):
				snd.play()
		
		_flash_sprite(Color(1.0, 0.6, 0.6), 0.08)
	
	if anim and anim.has_animation("hurt"):
		anim.play("hurt")
		_set_anim_speed_safe(1.0)


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()


func _on_base_posture_meter_filled() -> void:
	if not _dbroken_active:
		_trigger_shepherd_posture_break(posture_break_duration)


func _on_base_posture_broken(duration: float) -> void:
	_trigger_shepherd_posture_break(duration)


func _trigger_shepherd_posture_break(duration: float) -> void:
	if has_died:
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	_dbroken_active = true
	_dbreak_until = now + duration
	_dbreak_immunity_until = _dbreak_until + posture_break_immunity_extra
	
	stunned_until = _dbreak_until
	
	if anim and anim.has_animation("stagger"):
		anim.play("stagger")
	elif anim and anim.has_animation("hurt"):
		anim.play("hurt")
	
	if sprite:
		var tw := create_tween()
		tw.tween_property(sprite, "modulate", Color(1.0, 0.5, 0.5), 0.1)
		tw.tween_property(sprite, "modulate", Color.WHITE, max(0.01, duration - 0.1))


func _tick_shepherd_posture_break_recovery(now: float) -> void:
	if not _dbroken_active:
		return
	
	if now < _dbreak_until:
		return
	
	_dbroken_active = false
	_dbreak_until = 0.0
	stunned_until = 0.0
	
	if anim and anim.has_animation("walk"):
		anim.play("walk")
		_current_anim = "walk"


func is_deathblow_ready() -> bool:
	return _dbroken_active


func receive_deathblow(_attacker: Node) -> void:
	force_kill_hp()
	death()


# =============================================================================
# TELEPORT
# =============================================================================

func _teleport_away() -> void:
	if has_died:
		return
	
	if not is_instance_valid(player):
		return
	
	if anim and anim.has_animation("teleport"):
		anim.play("teleport")
	
	await get_tree().create_timer(teleport_windup).timeout
	
	if has_died or not is_inside_tree():
		return
	
	var offset_distance := randf_range(teleport_distance_min, teleport_distance_max)
	var angle := randf() * TAU
	var offset := Vector2(cos(angle), sin(angle)) * offset_distance
	
	global_position = player.global_position + offset
	
	if anim and anim.has_animation("walk"):
		anim.play("walk")
		_current_anim = "walk"


# =============================================================================
# BUFF SYSTEM
# =============================================================================

func _buff_nearby_enemies() -> void:
	if has_died:
		return
	
	if ProstheticEffects.is_confused(self):
		return
	
	if Time.get_ticks_msec() * 0.001 < stunned_until:
		return
	
	if _dbroken_active:
		return
	
	var enemies := get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		if enemy == self or not is_instance_valid(enemy):
			continue
		
		var dist := global_position.distance_to(enemy.global_position)
		var in_range := dist <= buff_radius
		
		if not enemy.has_meta("buff_sources"):
			enemy.set_meta("buff_sources", [])
		
		var buff_sources: Array = enemy.get_meta("buff_sources")
		
		for i in range(buff_sources.size() - 1, -1, -1):
			if not is_instance_valid(buff_sources[i]):
				buff_sources.remove_at(i)
		
		enemy.set_meta("buff_sources", buff_sources)
		
		if in_range and not buff_sources.has(self):
			_apply_buff_to_enemy(enemy, buff_sources)
		elif not in_range and buff_sources.has(self):
			buff_sources.erase(self)
			enemy.set_meta("buff_sources", buff_sources)
			
			if buff_sources.is_empty():
				_remove_buff_from_enemy(enemy)


func _apply_buff_to_enemy(enemy: Node, buff_sources: Array) -> void:
	buff_sources.append(self)
	enemy.set_meta("buff_sources", buff_sources)
	
	if buff_sources.size() != 1:
		_set_enemy_buff_visual(enemy, true)
		return
	
	if enemy.get("movement_speed") != null:
		enemy.set_meta("original_movement_speed", enemy.get("movement_speed"))
		enemy.set("movement_speed", float(enemy.get("movement_speed")) * buff_speed_mult)
	
	if enemy.get("enemy_damage") != null:
		enemy.set_meta("original_damage", enemy.get("enemy_damage"))
		enemy.set("enemy_damage", int(enemy.get("enemy_damage")) * buff_damage_mult)
	
	if enemy.get("hp") != null:
		enemy.set_meta("original_hp", enemy.get("hp"))
		enemy.set("hp", int(enemy.get("hp")) * buff_hp_mult)
	
	_set_enemy_buff_visual(enemy, true)


func _remove_buff_from_enemy(enemy: Node) -> void:
	if not is_instance_valid(enemy):
		return
	
	if enemy.has_meta("original_movement_speed"):
		enemy.set("movement_speed", enemy.get_meta("original_movement_speed"))
		enemy.remove_meta("original_movement_speed")
	
	if enemy.has_meta("original_damage"):
		enemy.set("enemy_damage", enemy.get_meta("original_damage"))
		enemy.remove_meta("original_damage")
	
	if enemy.has_meta("original_hp"):
		var original_hp := int(enemy.get_meta("original_hp"))
		if enemy.get("hp") != null and int(enemy.get("hp")) > original_hp:
			enemy.set("hp", original_hp)
		enemy.remove_meta("original_hp")
	
	_set_enemy_buff_visual(enemy, false)


func _set_enemy_buff_visual(enemy: Node, active: bool) -> void:
	if not is_instance_valid(enemy):
		return
	
	var enemy_sprite := enemy.get_node_or_null("Sprite2D") as Sprite2D
	if enemy_sprite == null:
		return
	
	var material := enemy_sprite.material as ShaderMaterial
	if material == null:
		return
	
	material.set_shader_parameter("is_buffed", active)


func _unbuff_all_enemies() -> void:
	var enemies := get_tree().get_nodes_in_group("enemy")
	
	for enemy in enemies:
		if enemy == self or not is_instance_valid(enemy):
			continue
		
		if not enemy.has_meta("buff_sources"):
			continue
		
		var sources: Array = enemy.get_meta("buff_sources")
		sources.erase(self)
		enemy.set_meta("buff_sources", sources)
		
		if sources.is_empty():
			_remove_buff_from_enemy(enemy)


# =============================================================================
# DEATH
# =============================================================================

func death() -> void:
	if not mark_dead():
		return
	
	_unbuff_all_enemies()
	
	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)
	
	notify_stance_effects_enemy_death()
	spawn_death_vfx(death_anim_scene)
	spawn_experience_gem(exp_gem_scene, get_tree().get_first_node_in_group("loot"))
	award_area_gold_drop()
	
	for turret in get_tree().get_nodes_in_group("blossom_turret"):
		if not is_instance_valid(turret):
			continue
		
		if turret.has_method("get_attack_radius") and turret.global_position.distance_to(global_position) <= turret.get_attack_radius():
			if turret.has_method("add_blossom_stack"):
				turret.add_blossom_stack()
	
	hide_posture_bar()
	queue_free()


# =============================================================================
# ANIMATION / FACING / HELPERS
# =============================================================================

func _update_sprite_facing() -> void:
	if sprite == null or not is_instance_valid(player):
		return
	
	var to_player := player.global_position - global_position
	
	if abs(to_player.x) < 5.0:
		return
	
	sprite.flip_h = to_player.x > 0.0


func _update_animation() -> void:
	if anim == null:
		return
	
	if _dbroken_active:
		return
	
	var anim_name := "walk" if _last_move_speed > 5.0 else "idle"
	
	if anim.has_animation(anim_name) and _current_anim != anim_name:
		anim.play(anim_name)
		_current_anim = anim_name
	
	if anim_name == "walk":
		anim.speed_scale = clamp(_last_move_speed / max(1.0, movement_speed), 0.5, 1.35)
	elif anim_name == "idle":
		anim.speed_scale = 1.0


func get_enemy_tags() -> Array:
	return enemy_tags


# =============================================================================
# CLEANUP
# =============================================================================

func _exit_tree() -> void:
	_unbuff_all_enemies()
