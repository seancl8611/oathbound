extends Area2D

@onready var collision = $CollisionShape2D

signal trainer_hit(area: Area2D)

func _ready():
	print("[TRAINER HURTBOX] Ready.")

func _on_area_entered(area):
	if area.is_in_group("attack"):
		print("[TRAINER HURTBOX] Hit by:", area.name)
		emit_signal("trainer_hit", area)
