extends "res://Enemy/Area 2/Boss/rootfang.gd"

## Runtime-only lifetime repair for the bespoke Twin Maws melee boss.
## Rootfang's empowered beam previously armed a SceneTreeTimer lambda capturing the
## temporary Area2D. If the beam or room was cleaned first, that callback could become
## the same freed-Object class already observed elsewhere in boss playtests.


func _spawn_emp_beam_hitbox(dir: Vector2) -> void:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", emp_beam_damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(emp_beam_length, emp_beam_width)
	col.shape = rect
	area.add_child(col)

	area.global_position = global_position + dir * (emp_beam_length * 0.5)
	area.rotation = dir.angle()
	get_parent().add_child(area)
	_current_hitbox = area
	_is_current_hitbox_melee = false

	var vis := ColorRect.new()
	vis.size = Vector2(emp_beam_length, emp_beam_width)
	vis.position = Vector2(-emp_beam_length * 0.5, -emp_beam_width * 0.5)
	vis.color = Color(0.95, 0.5, 0.15, 0.7)
	area.add_child(vis)

	area.set_deferred("monitoring", true)
	var overlap_probe := OwnedAreaOverlapProbe.new()
	area.add_child(overlap_probe)
	overlap_probe.arm(0.05)
