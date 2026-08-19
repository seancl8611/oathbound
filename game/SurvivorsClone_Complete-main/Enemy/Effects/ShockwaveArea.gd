# shockwave_area.gd
extends Area2D

@export var damage: int = 10
@export var knockback_strength: float = 1.0

func _ready():
	add_to_group("attack")  # So this can be recognized as an attacking area
