extends Area2D

@export var radius: float = 100.0
@export var knockback_strength: float = 100.0
@export var weapon_owner: Node2D

func _ready():
	# Make sure the Area2D is active
	monitoring = true
	monitorable = true

	# Set collision layer and mask to match enemies' HurtBox
	collision_layer = 1
	collision_mask = 1

	# Set up shape
	var shape = CircleShape2D.new()
	shape.radius = radius

	var shape_node = CollisionShape2D.new()
	shape_node.shape = shape
	add_child(shape_node)

	# Wait for physics frame so overlaps register
	await get_tree().physics_frame

	print("[DEBUG] KnockbackPulse checking overlaps...")
	apply_knockback()

func apply_knockback():
	var overlaps = get_overlapping_areas()
	print("[DEBUG] Overlapping areas count:", overlaps.size())

	for area in overlaps:
		if area.is_in_group("hurtbox"):
			var enemy = area.get_parent()
			if enemy != weapon_owner and enemy.is_inside_tree():
				var dir = (enemy.global_position - global_position).normalized()
				
				# ✅ Directly apply knockback if the enemy supports it
				if enemy.has_method("apply_knockback"):
					enemy.apply_knockback(dir * knockback_strength)
					print("[DEBUG] Direct Knockback Applied:", enemy.name, "Direction:", dir)
				else:
					print("[ERROR] Enemy has no apply_knockback method:", enemy.name)
			else:
				print("[DEBUG] Area found but not valid:", area.name, "Groups:", area.get_groups())

	queue_free()
