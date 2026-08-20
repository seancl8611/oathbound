extends Area2D

@export var damage: int = 0
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var disable_timer: Timer = $DisableHitBoxTimer

func _ready() -> void:
	# Ensure this talks to the Player HurtBox (Player HurtBox should be layer=4, mask includes 2)
	collision_layer = 2
	collision_mask = 4
	add_to_group("attack")

	# Standard metadata the Player expects
	var p := get_parent()
	if p != null:
		set_meta("attacker", p)
	set_meta("parryable", true)
	set_meta("telegraphed", true)

	# Auto-damage from parent if provided (no int() constructor; handle types safely)
	if p != null and p.has_method("get_enemy_damage"):
		var v = p.call("get_enemy_damage")
		if v is int:
			damage = v
		elif v is float:
			damage = floori(v)   # or roundi(v) if you prefer rounding
		elif v is String:
			damage = v.to_int()
		else:
			damage = 0

	# Make sure our signal is connected
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))
		
func tempdisable() -> void:
	if collision:
		collision.call_deferred("set", "disabled", true)
	if disable_timer:
		disable_timer.start()

func _on_disable_hit_box_timer_timeout() -> void:
	if collision:
		collision.call_deferred("set", "disabled", false)

func _on_area_entered(area: Area2D) -> void:
	if area != null and (area.is_in_group("player_hurtbox") or area.is_in_group("enemy_hurtbox")):
		if area.has_signal("hurt"):
			area.emit_signal("hurt", damage, "normal", get_parent())
