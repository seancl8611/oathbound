extends Area2D

@export var damage = 10
@onready var collision_shape = $CollisionShape2D

func _on_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		if area.has_signal("hurt"):
			area.emit_signal("hurt", damage, "normal", self)
