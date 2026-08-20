extends EnemyBase
class_name BeastEnemyBase

# =============================================================================
# BEAST CORE TUNING
# =============================================================================

@export_group("Beast Movement")
@export var beast_move_speed: float = 120.0
@export var beast_accel: float = 12.0
@export var beast_turn_speed: float = 10.0
@export var beast_face_player: bool = true

@export_group("Beast Combat")
@export var beast_attack_role: String = "dog_lunge"
@export var beast_contact_damage: int = 5
@export var beast_contact_damage_type: String = "melee"
@export var beast_attack_cooldown: float = 0.8
@export var beast_recovery_time: float = 0.25

@export_group("Beast Lunge")
@export var lunge_speed: float = 360.0
@export var lunge_duration: float = 0.18
@export var lunge_recovery: float = 0.30

# =============================================================================
# BEAST RUNTIME
# =============================================================================

var beast_is_attacking: bool = false
var beast_is_lunging: bool = false
var beast_in_recovery: bool = false

var beast_next_attack_time: float = 0.0
var beast_recovery_until: float = 0.0

var _beast_attack_gen: int = 0
var _beast_contact_area: Area2D = null

var _beast_lunge_dir: Vector2 = Vector2.ZERO
var _beast_lunge_until: float = 0.0

# =============================================================================
# SHARED BEAST AGGRO / PACK STATE
# =============================================================================

@export_group("Beast Awareness")
@export var auto_aggro_on_spawn: bool = false
@export var aggro_radius: float = 140.0
@export var deaggro_radius: float = 300.0
@export var patrol_wander_radius: float = 80.0

var _saw_player_once: bool = false
var _home_pos: Vector2 = Vector2.ZERO
var _patrol_target: Vector2 = Vector2.ZERO
var _patrol_until: float = 0.0

var _backoff_until: float = 0.0
var _approach_denied_until: float = 0.0

var AttackDir: Node = null

# Generic generation guard used by creature attacks with delayed timers.
var _attack_gen: int = 0

# Optional parry indicator for telegraphed beast attacks.
var _parry_indicator: Node2D = null

# =============================================================================
# BASE READY
# =============================================================================
func _ready() -> void:
	_beast_base_ready()

func _beast_base_ready() -> void:
	_base_enemy_ready()
	
	_home_pos = global_position
	_patrol_target = global_position
	
	AttackDir = get_attack_director()
	
	_setup_beast_parry_indicator()
	_connect_beast_attack_director_signals()
	
# =============================================================================
# BEAST STATE HELPERS
# =============================================================================
func is_beast_enemy() -> bool:
	return true


func can_block_hit() -> bool:
	return false


func is_blocking() -> bool:
	return false


func is_deathblow_ready() -> bool:
	return false


func _get_player_dir() -> Vector2:
	if not is_instance_valid(player):
		return Vector2.ZERO
	
	var to_player := player.global_position - global_position
	if to_player.length_squared() <= 0.001:
		return Vector2.ZERO
	
	return to_player.normalized()


func _get_player_distance() -> float:
	if not is_instance_valid(player):
		return INF
	
	return global_position.distance_to(player.global_position)


func _face_player_if_needed() -> void:
	if not beast_face_player:
		return
	
	if sprite == null:
		return
	
	if not is_instance_valid(player):
		return
	
	var to_player := player.global_position - global_position
	if abs(to_player.x) < 5.0:
		return
	
	sprite.flip_h = to_player.x > 0.0


func _can_start_beast_attack() -> bool:
	var now := Time.get_ticks_msec() * 0.001
	
	if has_died:
		return false
	
	if beast_is_attacking or beast_is_lunging:
		return false
	
	if now < beast_next_attack_time:
		return false
	
	if now < beast_recovery_until:
		return false
	
	if combat and combat.get("is_posture_broken") == true:
		return false
	
	if ProstheticEffects.is_confused(self):
		return false
	
	return true


func _begin_beast_attack() -> bool:
	if not _can_start_beast_attack():
		return false
	
	if beast_attack_role != "":
		if not _request_role(beast_attack_role):
			return false
	
	beast_is_attacking = true
	_beast_attack_gen += 1
	return true


func _finish_beast_attack() -> void:
	var now := Time.get_ticks_msec() * 0.001
	
	beast_is_attacking = false
	beast_is_lunging = false
	beast_in_recovery = true
	
	beast_next_attack_time = now + beast_attack_cooldown
	beast_recovery_until = now + beast_recovery_time
	
	_cleanup_beast_contact_area()
	
	if beast_attack_role != "":
		_release_role(beast_attack_role)


func _cancel_beast_attack(hard_cleanup: bool = true) -> void:
	_beast_attack_gen += 1
	
	beast_is_attacking = false
	beast_is_lunging = false
	beast_in_recovery = false
	
	_beast_lunge_until = 0.0
	_beast_lunge_dir = Vector2.ZERO
	
	if hard_cleanup:
		_hard_cleanup_beast_contact_area()
	else:
		_cleanup_beast_contact_area()
	
	if beast_attack_role != "":
		_release_role(beast_attack_role)

func _reset_beast_runtime() -> void:
	_bump_attack_gen()
	_cancel_beast_attack(true)
	_hide_parry_indicator()
	_release_role(beast_attack_role)
	_release_attack_token()
	_release_role("advance_move")

# =============================================================================
# BEAST MOVEMENT HELPERS
# =============================================================================

func _beast_move_toward(target_velocity: Vector2, delta: float) -> void:
	velocity = velocity.lerp(target_velocity + knockback, clamp(beast_accel * delta, 0.0, 1.0))


func _beast_stop(delta: float) -> void:
	velocity = velocity.move_toward(knockback, beast_move_speed * delta)


func _beast_tick_shared(delta: float) -> bool:
	ProstheticEffects.tick(self, delta)
	
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		se.tick(self, delta)
	
	if tick_base_hitstop():
		move_and_slide()
		return true
	
	if ProstheticEffects.override_movement(self, delta):
		return true
	
	tick_base_knockback(delta)
	sync_posture_bar_position()
	_face_player_if_needed()
	
	return false


func _beast_apply_lunge_motion() -> bool:
	var now := Time.get_ticks_msec() * 0.001
	
	if not beast_is_lunging:
		return false
	
	if now >= _beast_lunge_until:
		beast_is_lunging = false
		return false
	
	velocity = _beast_lunge_dir * lunge_speed + knockback
	return true


func _start_beast_lunge(dir: Vector2) -> void:
	if dir.length_squared() <= 0.001:
		dir = _get_player_dir()
	
	if dir.length_squared() <= 0.001:
		dir = Vector2.RIGHT
	
	beast_is_lunging = true
	_beast_lunge_dir = dir.normalized()
	_beast_lunge_until = Time.get_ticks_msec() * 0.001 + lunge_duration

# =============================================================================
# SHARED BEAST PARRY INDICATOR
# =============================================================================

func _setup_beast_parry_indicator() -> void:
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
	
	_parry_indicator = _create_simple_beast_indicator()
	add_child(_parry_indicator)


func _setup_parry_indicator() -> void:
	# Compatibility alias for migrated beast scripts.
	_setup_beast_parry_indicator()


func _create_simple_beast_indicator() -> Node2D:
	var ind := Node2D.new()
	ind.name = "ParryIndicator"
	ind.position = Vector2(0, -45)
	ind.visible = false
	ind.z_index = 100
	
	var size := 11.0
	var h := size
	var w := size * 0.6
	
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
	
	var poly := Polygon2D.new()
	poly.polygon = PackedVector2Array([
		Vector2(0, -h),
		Vector2(w, 0),
		Vector2(0, h),
		Vector2(-w, 0)
	])
	poly.color = Color(1.0, 0.95, 0.8, 1.0)
	ind.add_child(poly)
	
	ind.set_meta("poly", poly)
	ind.set_meta("outline", outline)
	
	return ind

func _show_parry_indicator(duration: float, is_unblockable: bool = false) -> void:
	if _parry_indicator == null:
		return
	
	if _parry_indicator.has_method("warn_attack"):
		_parry_indicator.warn_attack(duration, is_unblockable)
		return
	
	_parry_indicator.visible = true
	_parry_indicator.scale = Vector2(1.5, 1.5)
	
	var poly = _parry_indicator.get_meta("poly") if _parry_indicator.has_meta("poly") else null
	var outline = _parry_indicator.get_meta("outline") if _parry_indicator.has_meta("outline") else null
	
	if poly:
		poly.color = Color(1.0, 0.2, 0.15, 1.0) if is_unblockable else Color(1.0, 0.95, 0.8, 1.0)
	
	if outline:
		outline.color = Color(0.5, 0.1, 0.1, 0.95) if is_unblockable else Color(0.3, 0.25, 0.2, 0.95)
	
	var tw := create_tween()
	tw.tween_property(_parry_indicator, "scale", Vector2(1.0, 1.0), 0.1)


func _hide_parry_indicator() -> void:
	if _parry_indicator == null:
		return
	
	if _parry_indicator.has_method("hide_now"):
		_parry_indicator.hide_now()
	else:
		_parry_indicator.visible = false

# =============================================================================
# SHARED BEAST ATTACK DIRECTOR / PACK HELPERS
# =============================================================================

func _connect_beast_attack_director_signals() -> void:
	AttackDir = get_attack_director()
	if AttackDir == null:
		return
	
	if AttackDir.has_signal("role_released"):
		var role_cb := Callable(self, "_on_ad_role_released")
		if not AttackDir.is_connected("role_released", role_cb):
			AttackDir.connect("role_released", role_cb)
	
	if AttackDir.has_signal("crowd_backoff"):
		var crowd_cb := Callable(self, "_on_crowd_backoff")
		if not AttackDir.is_connected("crowd_backoff", crowd_cb):
			AttackDir.connect("crowd_backoff", crowd_cb)


func _disconnect_beast_attack_director_signals() -> void:
	AttackDir = get_attack_director()
	if AttackDir == null:
		return
	
	if AttackDir.has_signal("role_released"):
		var role_cb := Callable(self, "_on_ad_role_released")
		if AttackDir.is_connected("role_released", role_cb):
			AttackDir.disconnect("role_released", role_cb)
	
	if AttackDir.has_signal("crowd_backoff"):
		var crowd_cb := Callable(self, "_on_crowd_backoff")
		if AttackDir.is_connected("crowd_backoff", crowd_cb):
			AttackDir.disconnect("crowd_backoff", crowd_cb)


func _on_ad_role_released(_role: String) -> void:
	_sync_attack_director_roles(Time.get_ticks_msec() * 0.001)


func _on_crowd_backoff(targets) -> void:
	if targets is Array:
		if not targets.has(self):
			return
		
		var backoff_duration := 1.2
		if AttackDir:
			var configured = AttackDir.get("backoff_duration")
			if configured != null:
				backoff_duration = float(configured)
		
		_backoff_until = Time.get_ticks_msec() * 0.001 + backoff_duration + randf() * 0.5
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
	
	AttackDir = get_attack_director()
	if AttackDir == null:
		return true
	
	if _held_roles.has("advance_move"):
		return true
	
	if AttackDir.has_method("request_role"):
		if AttackDir.request_role(self, "advance_move"):
			_held_roles["advance_move"] = true
			return true
	
	_approach_denied_until = now + 0.4
	return false


func _request_attack_token() -> bool:
	# Beast scripts use a melee pressure slot. Prefer the role path when available,
	# but still support older/direct token AttackDirector APIs.
	if has_attack_token:
		return true
	
	AttackDir = get_attack_director()
	if AttackDir == null:
		has_attack_token = true
		return true
	
	if AttackDir.has_method("request_role"):
		if AttackDir.request_role(self, "melee_attack"):
			has_attack_token = true
			_held_roles["melee_attack"] = true
			return true
	
	if AttackDir.has_method("request_token"):
		if AttackDir.request_token(self):
			has_attack_token = true
			return true
	
	return false


func _release_attack_token() -> void:
	if not has_attack_token:
		return
	
	has_attack_token = false
	_held_roles.erase("melee_attack")
	
	AttackDir = get_attack_director()
	if AttackDir == null:
		return
	
	if AttackDir.has_method("release_role"):
		AttackDir.release_role(self, "melee_attack")
	elif AttackDir.has_method("release_token"):
		AttackDir.release_token(self)


func _request_lunge_role() -> bool:
	if _held_roles.has(beast_attack_role):
		return true
	
	AttackDir = get_attack_director()
	if AttackDir == null:
		_held_roles[beast_attack_role] = true
		return true
	
	if AttackDir.has_method("request_role"):
		if AttackDir.request_role(self, beast_attack_role):
			_held_roles[beast_attack_role] = true
			return true
	
	return false


func _sync_attack_director_roles(now: float) -> void:
	AttackDir = get_attack_director()
	if AttackDir == null or not AttackDir.has_method("is_holding_role"):
		return
	
	if has_attack_token and not AttackDir.is_holding_role(self, "melee_attack"):
		has_attack_token = false
		_held_roles.erase("melee_attack")
		_on_beast_attack_director_revoked(now)
	
	if beast_attack_role != "" and _held_roles.has(beast_attack_role):
		if not AttackDir.is_holding_role(self, beast_attack_role):
			_held_roles.erase(beast_attack_role)
			_on_beast_attack_director_revoked(now)
	
	if _held_roles.has("advance_move"):
		if not AttackDir.is_holding_role(self, "advance_move"):
			_held_roles.erase("advance_move")


func _on_beast_attack_director_revoked(_now: float) -> void:
	# Virtual hook. Specific beasts can override for their state-machine cleanup.
	_cancel_beast_attack(true)


func _bump_attack_gen() -> int:
	_attack_gen += 1
	if _attack_gen > 1000000000:
		_attack_gen = 1
	return _attack_gen
	
# =============================================================================
# BEAST CONTACT HITBOX HELPERS
# =============================================================================
func _spawn_beast_contact_area(
	damage: int = -1,
	damage_type: String = "",
	radius: float = 18.0,
	offset: Vector2 = Vector2.ZERO
) -> Area2D:
	_cleanup_beast_contact_area()
	
	var area := Area2D.new()
	area.name = "BeastContactArea"
	area.add_to_group("attack")
	area.set_meta("attacker", self)
	area.set_meta("damage", beast_contact_damage if damage < 0 else damage)
	area.set_meta("damage_type", beast_contact_damage_type if damage_type == "" else damage_type)
	area.set_meta("swing_token", Time.get_ticks_msec())
	
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	shape.shape = circle
	area.add_child(shape)
	
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitoring = true
	area.monitorable = true
	
	area.position = offset
	
	if not area.is_connected("area_entered", Callable(self, "_on_beast_contact_area_entered")):
		area.connect("area_entered", Callable(self, "_on_beast_contact_area_entered"))
	
	add_child(area)
	_beast_contact_area = area
	
	return area


func _on_beast_contact_area_entered(area: Area2D) -> void:
	if area == null:
		return
	
	if not area.is_in_group("player_hurtbox"):
		return
	
	if _beast_contact_area and _beast_contact_area.has_meta("consumed"):
		if bool(_beast_contact_area.get_meta("consumed")):
			return
	
	if _beast_contact_area:
		_beast_contact_area.set_meta("consumed", true)
	
	var dmg := beast_contact_damage
	var dtype := beast_contact_damage_type
	
	if _beast_contact_area:
		if _beast_contact_area.has_meta("damage"):
			dmg = int(_beast_contact_area.get_meta("damage"))
		if _beast_contact_area.has_meta("damage_type"):
			dtype = str(_beast_contact_area.get_meta("damage_type"))
	
	area.emit_signal("hurt", dmg, dtype, self)


func _cleanup_beast_contact_area() -> void:
	if _beast_contact_area and is_instance_valid(_beast_contact_area):
		_beast_contact_area.queue_free()
	
	_beast_contact_area = null


func _hard_cleanup_beast_contact_area() -> void:
	if _beast_contact_area and is_instance_valid(_beast_contact_area):
		_beast_contact_area.set_deferred("monitoring", false)
		_beast_contact_area.set_deferred("monitorable", false)
		_beast_contact_area.set_meta("consumed", true)
		_beast_contact_area.queue_free()
	
	_beast_contact_area = null


# =============================================================================
# DAMAGE / PARRY / FREEZE HOOKS
# =============================================================================

func on_parried(player_pos: Vector2) -> void:
	_cancel_beast_attack(true)
	
	var dir_vec := global_position - player_pos
	if dir_vec.length_squared() < 0.001:
		dir_vec = Vector2.RIGHT
	
	apply_knockback(dir_vec.normalized() * 140.0)
	hitstop_local(0.10)
	add_posture_damage(20.0)


func freeze_interrupt() -> void:
	_cancel_beast_attack(true)


func receive_deathblow(_attacker: Node) -> void:
	_reset_beast_runtime()
	force_kill_hp()
	death()

func death() -> void:
	if not mark_dead():
		return
	
	_reset_beast_runtime()
	notify_stance_effects_enemy_death()
	emit_signal("enemy_died", self)
	base_death_cleanup()

func _exit_tree() -> void:
	_reset_beast_runtime()
	_disconnect_beast_attack_director_signals()
	_release_all_attack_director_state()
