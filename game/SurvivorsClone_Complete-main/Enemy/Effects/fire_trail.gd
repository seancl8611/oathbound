extends Area2D

@export var duration: float = 2.0  # Time before fire disappears
@export var damage: int = 10  # Damage to player if touched

@onready var timer = $Timer

func _ready():
	# Connect timer to remove fire after duration
	timer.wait_time = duration
	timer.start()
	timer.connect("timeout", Callable(self, "queue_free"))  # Deletes fire after time expires

	# Connect player collision
	connect("area_entered", Callable(self, "_on_area_entered"))

func _on_area_entered(area):
	if area.is_in_group("player_hurtbox"):  
		if area.has_signal("hurt"):
			area.emit_signal("hurt", damage, Vector2.ZERO, 0)  # Apply fire damage
