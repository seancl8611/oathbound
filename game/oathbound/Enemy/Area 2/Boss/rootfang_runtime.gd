extends "res://Enemy/Area 2/Boss/rootfang.gd"

## Runtime lifetime hardening for the live Twin Maws Rootfang scene.
##
## Rootfang's empowered beam used a SceneTreeTimer lambda that captured its temporary
## Area2D. If the beam was cleaned up before the delayed overlap probe fired, Godot
## could materialize a freed Object capture before is_instance_valid() ran. Keep the
## authored attack exactly the same while making the probe owned by the beam itself
## and resolving it through an integer instance id.


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
	var probe := Timer.new()
	probe.name = "RuntimeOverlapProbe"
	probe.one_shot = true
	probe.wait_time = 0.05
	area.add_child(probe)
	probe.timeout.connect(Callable(self, "_on_rootfang_runtime_overlap_probe").bind(area.get_instance_id()))
	probe.start()


func _on_rootfang_runtime_overlap_probe(area_id: int) -> void:
	var area_value: Object = instance_from_id(area_id)
	if not (area_value is Area2D) or not is_instance_valid(area_value):
		return
	var area := area_value as Area2D
	if not area.is_inside_tree():
		return
	for body_value: Variant in area.get_overlapping_bodies():
		area.body_entered.emit(body_value)
	for overlap_value: Variant in area.get_overlapping_areas():
		area.area_entered.emit(overlap_value)
