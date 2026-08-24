extends EnemyBase

## Weak expendable pressure unit produced by Hollow Vessel.
## The Vessel is the encounter priority; Spillborn deliberately stays simple so the
## source-management mechanic remains readable and does not become a second elite kit.

@export_group("Spillborn")
@export var attack_range: float = 30.0
@export var attack_damage: int = 4
@export var attack_windup: float = 0.28
@export var attack_active: float = 0.12
@export var attack_recovery: float = 0.42
@export var attack_cooldown: float = 0.65

@onready var attack_collision: CollisionShape2D = get_node_or_null("HitBox/CollisionShape2D") as CollisionShape2D

var _attack_state := 0 # 0 chase, 1 windup, 2 active, 3 recovery
var _state_until := 0.0
var _next_attack_at := 0.0


func _ready() -> void:
	_base_enemy_ready()
	add_to_group("spillborn")
	if attack_collision:
		attack_collision.disabled = true


func engage() -> void:
	player = get_tree().get_first_node_in_group("player") as Node2D


func get_enemy_damage() -> int:
	return attack_damage


func _physics_process(delta: float) -> void:
	if has_died:
		velocity = Vector2.ZERO
		return
	if tick_base_hitstop():
		move_and_slide()
		return

	tick_base_knockback(delta)
	var now := Time.get_ticks_msec() * 0.001
	if _attack_state != 0:
		_tick_attack(now)
		move_and_slide()
		return

	var target := get_player_ref()
	if target == null:
		velocity = knockback
		move_and_slide()
		return

	var offset := target.global_position - global_position
	var distance := offset.length()
	if distance <= attack_range and now >= _next_attack_at:
		_begin_attack(now)
	else:
		velocity = offset.normalized() * movement_speed + knockback if distance > 0.001 else knockback
	move_and_slide()


func _begin_attack(now: float) -> void:
	_attack_state = 1
	_state_until = now + attack_windup
	velocity = Vector2.ZERO


func _tick_attack(now: float) -> void:
	velocity = knockback
	if now < _state_until:
		return

	match _attack_state:
		1:
			_attack_state = 2
			_state_until = now + attack_active
			_set_attack_enabled(true)
		2:
			_set_attack_enabled(false)
			_attack_state = 3
			_state_until = now + attack_recovery
		3:
			_attack_state = 0
			_next_attack_at = now + attack_cooldown


func _set_attack_enabled(enabled: bool) -> void:
	if attack_collision:
		attack_collision.set_deferred("disabled", not enabled)


func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if has_died or damage <= 0:
		return
	var source := _resolve_hurt_source(attacker)
	if source != null and is_instance_valid(source) and source.is_in_group("enemy"):
		return
	var hp_damage := apply_hp_damage(damage)
	if hp_damage > 0:
		show_enemy_damage_number(hp_damage, damage_type, -14.0)
		notify_combat_got_hit({"damage": damage, "blocked": false, "damage_type": damage_type})
	if hp <= 0:
		death()


func death() -> void:
	if not mark_dead():
		return
	_set_attack_enabled(false)
	if hurt_box:
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
	if is_in_group("enemy"):
		remove_from_group("enemy")
	emit_signal("enemy_died", self)
	queue_free()
