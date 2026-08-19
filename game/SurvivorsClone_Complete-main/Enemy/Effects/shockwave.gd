extends Node2D

@export var shockwave_speed: float = 100.0
@export var max_radius: float = 1000.0
@export var damage: int = 10
@export var duration: float = 7.0
@export var ring_thickness: float = 30.0  # How thick the damaging ring is

@onready var sprite = $ShockwaveSprite
@onready var collision_shape = $ShockwaveArea/ShockwaveCollision
@onready var timer = $ShockwaveTimer

var circle_shape: CircleShape2D
var current_radius: float = 1.0

func _ready():
	circle_shape = collision_shape.shape as CircleShape2D
	circle_shape.radius = current_radius
	sprite.scale = Vector2.ZERO

	timer.stop()
	timer.wait_time = duration
	timer.one_shot = true

	if not timer.is_connected("timeout", Callable(self, "_on_timer_timeout")):
		timer.connect("timeout", Callable(self, "_on_timer_timeout"))

	timer.start()

func _process(delta):
	var radius_increase = shockwave_speed * delta
	current_radius += radius_increase
	circle_shape.radius = current_radius

	# Match sprite visual to collision shape
	var texture_radius = sprite.texture.get_size().x / 2.0
	if texture_radius > 0:
		sprite.scale = Vector2.ONE * (current_radius / texture_radius)

func _on_timer_timeout():
	print("[DEBUG] Shockwave expired after ", duration, " seconds.")
	queue_free()

func _on_ShockwaveArea_area_entered(area):
	if not area.is_in_group("player_hurtbox"):
		return

	var player_pos = area.global_position
	var distance = global_position.distance_to(player_pos)

	if distance >= current_radius - ring_thickness and distance <= current_radius + ring_thickness:
		print("[DEBUG] Shockwave hit player at edge of ring!")

		# Get damage info from the Area2D (self)
		var dmg = $ShockwaveArea.damage if $ShockwaveArea.has_variable("damage") else damage
		var knock = $ShockwaveArea.knockback_strength if $ShockwaveArea.has_variable("knockback_strength") else 1.0

		area.emit_signal("hurt", dmg, global_position.direction_to(player_pos), knock)
	else:
		print("[DEBUG] Player passed through center safely (no damage).")
