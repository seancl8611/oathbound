extends "res://Enemy/Area 2/Minibosses/rotwood_host.gd"

## Runtime lifetime hardening for Rotwood Host's spirit-trail hazards.
## The imported implementation left a SceneTreeTimer lambda alive after the trail
## itself could be removed. The trail now owns its timer and fade tween, so removing
## the hazard automatically removes every delayed callback that refers to it.


func _spawn_spirit_trail(pos: Vector2) -> void:
	var trail := Area2D.new()
	trail.collision_layer = 2
	trail.collision_mask = 4
	trail.global_position = pos

	var cs := CollisionShape2D.new()
	var shape := CircleShape2D.new()
	shape.radius = spirit_trail_radius
	cs.shape = shape
	trail.add_child(cs)

	var visual := Polygon2D.new()
	var pts := PackedVector2Array()
	var seg := 10
	for s in range(seg):
		var angle := float(s) / float(seg) * TAU
		pts.append(Vector2(cos(angle), sin(angle)) * spirit_trail_radius)
	visual.polygon = pts
	visual.color = Color(0.4, 0.5, 0.9, 0.2)
	visual.z_index = -1
	trail.add_child(visual)

	get_parent().add_child(trail)
	var trail_id := trail.get_instance_id()
	trail.body_entered.connect(Callable(self, "_on_rotwood_runtime_trail_body_entered").bind(trail_id))

	var lifetime := Timer.new()
	lifetime.name = "RuntimeTrailLifetime"
	lifetime.one_shot = true
	lifetime.wait_time = spirit_trail_duration
	trail.add_child(lifetime)
	lifetime.timeout.connect(Callable(self, "_on_rotwood_runtime_trail_fade").bind(trail_id, visual.get_instance_id()))
	lifetime.start()


func _on_rotwood_runtime_trail_body_entered(body: Node, trail_id: int) -> void:
	var trail_value: Object = instance_from_id(trail_id)
	if not (trail_value is Area2D) or not is_instance_valid(trail_value):
		return
	if body == null or not is_instance_valid(body) or not body.is_in_group("player"):
		return
	if "hp" in body:
		body.hp -= int(spirit_trail_damage)
		if body.has_method("_update_health_bar"):
			body.call("_update_health_bar")


func _on_rotwood_runtime_trail_fade(trail_id: int, visual_id: int) -> void:
	var trail_value: Object = instance_from_id(trail_id)
	var visual_value: Object = instance_from_id(visual_id)
	if not (trail_value is Area2D) or not is_instance_valid(trail_value):
		return
	if not (visual_value is Polygon2D) or not is_instance_valid(visual_value):
		(trail_value as Area2D).queue_free()
		return
	var trail := trail_value as Area2D
	var visual := visual_value as Polygon2D
	var tween := visual.create_tween()
	tween.tween_property(visual, "color:a", 0.0, 0.3)
	tween.tween_callback(Callable(trail, "queue_free"))
