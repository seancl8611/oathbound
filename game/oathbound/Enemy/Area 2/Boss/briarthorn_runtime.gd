extends "res://Enemy/Area 2/Boss/briarthorn.gd"

## Runtime lifetime hardening for the live Twin Maws Briarthorn scene.
## Temporary AOE/beam attacks used orphanable SceneTreeTimer lambdas that captured
## their Area2D. Their timing and damage stay unchanged; probes/lifetimes now belong
## to the temporary attack node and cross delayed boundaries by integer instance id.


func _spawn_aoe_detonation(center: Vector2, radius: float, damage: int) -> void:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = radius
	col.shape = shape
	area.add_child(col)
	area.global_position = center
	get_parent().add_child(area)

	var flash := Polygon2D.new()
	var pts := PackedVector2Array()
	var seg := 24
	for s in range(seg):
		var angle := float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * radius)
	flash.polygon = pts
	flash.color = Color(1.0, 0.5, 0.2, 0.6)
	area.add_child(flash)

	area.set_deferred("monitoring", true)
	_arm_briarthorn_overlap_probe(area)
	_arm_briarthorn_self_free(area, 0.2)


func _spawn_beam_hitbox(dir: Vector2, length: float, width: float, damage: int) -> void:
	var area := Area2D.new()
	area.add_to_group("attack")
	area.collision_layer = 2
	area.collision_mask = 4
	area.set_meta("damage", damage)
	area.set_meta("attacker", self)
	area.set_meta("damage_type", "unblockable")
	area.set_meta("parryable", false)
	area.set_meta("unblockable", true)
	area.set_meta("telegraphed", true)

	var col := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(length, width)
	col.shape = rect
	area.add_child(col)

	area.global_position = global_position + dir * (length * 0.5)
	area.rotation = dir.angle()
	get_parent().add_child(area)
	_current_hitbox = area

	var vis := ColorRect.new()
	vis.size = Vector2(length, width)
	vis.position = Vector2(-length * 0.5, -width * 0.5)
	vis.color = Color(0.95, 0.6, 0.2, 0.7)
	area.add_child(vis)

	area.set_deferred("monitoring", true)
	_arm_briarthorn_overlap_probe(area)


func _arm_briarthorn_overlap_probe(area: Area2D) -> void:
	var probe := Timer.new()
	probe.name = "RuntimeOverlapProbe"
	probe.one_shot = true
	probe.wait_time = 0.05
	area.add_child(probe)
	probe.timeout.connect(Callable(self, "_on_briarthorn_runtime_overlap_probe").bind(area.get_instance_id()))
	probe.start()


func _arm_briarthorn_self_free(area: Area2D, delay: float) -> void:
	var lifetime := Timer.new()
	lifetime.name = "RuntimeLifetime"
	lifetime.one_shot = true
	lifetime.wait_time = maxf(0.001, delay)
	area.add_child(lifetime)
	lifetime.timeout.connect(Callable(area, "queue_free"))
	lifetime.start()


func _on_briarthorn_runtime_overlap_probe(area_id: int) -> void:
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
