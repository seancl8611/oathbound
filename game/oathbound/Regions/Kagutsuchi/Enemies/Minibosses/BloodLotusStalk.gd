extends EnemyBase

## Prototype combat arm for Blood Lotus.
## Stationary pure-HP target with the three approved attack families: parryable sweep,
## perilous heavy smash, and slow parryable spit. It deliberately has no posture or
## deathblow state; destroying the arm advances the Heart controller's objective cycle.

@export var stalk_hp: int = 55
@export var attack_interval_min: float = 1.8
@export var attack_interval_max: float = 2.7
@export var sweep_damage: int = 7
@export var smash_damage: int = 11
@export var spit_damage: int = 6
@export var spit_speed: float = 150.0

var _next_attack_at: float = 0.0
var _busy: bool = false


func _ready() -> void:
	hp = stalk_hp
	_max_hp = stalk_hp
	movement_speed = 0.0
	_base_enemy_ready()
	add_to_group("blood_lotus_stalk")
	_next_attack_at = _now() + randf_range(0.8, 1.5)


func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	if has_died or _busy or bool(get_meta("recalled", false)):
		return
	if _now() >= _next_attack_at:
		_busy = true
		_perform_attack(randi_range(0, 2))


func _perform_attack(kind: int) -> void:
	match kind:
		0:
			await _telegraph_and_strike("sweep", 0.55, sweep_damage, 76.0, false)
		1:
			await _telegraph_and_strike("smash", 0.85, smash_damage, 58.0, true)
		_:
			await _spit()
	_busy = false
	_next_attack_at = _now() + randf_range(attack_interval_min, attack_interval_max)


func _telegraph_and_strike(attack_id: String, windup: float, damage: int, radius: float, perilous: bool) -> void:
	_set_visual_state(Color(1.25, 0.55, 0.55, 1.0) if perilous else Color(1.1, 0.85, 0.65, 1.0))
	await get_tree().create_timer(windup).timeout
	if has_died or bool(get_meta("recalled", false)):
		_set_visual_state(Color.WHITE)
		return
	var attack := Area2D.new()
	attack.name = "BloodLotus_%s" % attack_id
	attack.add_to_group("attack")
	attack.add_to_group("enemy_attack")
	attack.set_meta("attacker", self)
	attack.set_meta("damage", damage)
	attack.set_meta("attack_id", "blood_lotus_%s" % attack_id)
	attack.set_meta("damage_type", "perilous" if perilous else "normal")
	attack.set_meta("parryable", true)
	attack.set_meta("blockable", not perilous)
	attack.set_meta("parry_only", perilous)
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	shape.shape = circle
	attack.add_child(shape)
	add_child(attack)
	await get_tree().create_timer(0.20).timeout
	if is_instance_valid(attack):
		attack.queue_free()
	_set_visual_state(Color.WHITE)


func _spit() -> void:
	_set_visual_state(Color(0.8, 1.15, 0.9, 1.0))
	await get_tree().create_timer(0.70).timeout
	if has_died or bool(get_meta("recalled", false)):
		_set_visual_state(Color.WHITE)
		return
	var target := get_player_ref()
	if target == null:
		_set_visual_state(Color.WHITE)
		return
	var projectile := Area2D.new()
	projectile.name = "BloodLotusSpit"
	projectile.add_to_group("attack")
	projectile.add_to_group("enemy_attack")
	projectile.set_meta("attacker", self)
	projectile.set_meta("damage", spit_damage)
	projectile.set_meta("attack_id", "blood_lotus_spit")
	projectile.set_meta("damage_type", "normal")
	projectile.set_meta("parryable", true)
	projectile.set_meta("blockable", true)
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 10.0
	shape.shape = circle
	projectile.add_child(shape)
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	var direction := global_position.direction_to(target.global_position)
	var tween := get_tree().create_tween()
	tween.tween_property(projectile, "global_position", global_position + direction * 520.0, 520.0 / spit_speed)
	tween.tween_callback(projectile.queue_free)
	_set_visual_state(Color.WHITE)


func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if has_died or bool(get_meta("recalled", false)):
		return
	if attacker != null and attacker.is_in_group("enemy") and not attacker.is_in_group("attack"):
		return
	if damage_type == "knockback":
		return
	var dealt := apply_hp_damage(maxi(1, damage))
	show_enemy_damage_number(dealt, damage_type, -18.0)
	_flash_sprite(Color.WHITE, 0.05)
	if hp <= 0:
		_die_stalk()


func _die_stalk() -> void:
	if not mark_dead():
		return
	if hurt_box != null:
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)
	emit_signal("enemy_died", self)
	base_death_cleanup()


func _set_visual_state(color: Color) -> void:
	var visual := get_node_or_null("PrototypeVisual")
	if visual is CanvasItem:
		(visual as CanvasItem).modulate = color


func _now() -> float:
	return Time.get_ticks_msec() * 0.001
