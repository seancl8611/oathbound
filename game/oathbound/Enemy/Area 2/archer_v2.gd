extends "res://Enemy/Area 2/Encounter/lantern_wraith.gd"

## Legacy compatibility shim.
##
## lantern_wraith.tscn from the imported prototype still points at the old
## `res://Enemy/Area 2/archer_v2.gd` path, while the actual migrated implementation
## lives in `Encounter/lantern_wraith.gd`. Keep the old path resolvable during the
## engine migration. The live September 3 Yomori playtest also proved that the
## imported implementation's SceneTreeTimer lambdas could retain wave/pulse captures
## after those temporary Area2D objects were freed. Override only the temporary attack
## lifetime wiring here until this compatibility alias is retired.


func _spawn_wave_projectile(dir: Vector2, speed: float) -> void:
	var wave := Area2D.new()
	wave.name = "LanternWave"
	wave.collision_layer = 0
	wave.collision_mask = 2
	wave.monitoring = true
	wave.monitorable = true
	wave.add_to_group("attack")

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(wave_height, wave_width)
	shape.shape = rect
	shape.rotation = dir.angle()
	wave.add_child(shape)

	wave.set_meta("attacker", self)
	wave.set_meta("shooter_id", get_instance_id())
	wave.set_meta("shooter", self)
	wave.set_meta("faction", "enemy")
	wave.set_meta("parryable", true)
	wave.set_meta("damage", projectile_damage)
	wave.set_meta("damage_type", "ranged")
	wave.set_meta("direction", dir)
	wave.set_meta("speed", speed)
	wave.set_meta("swing_token", Time.get_ticks_msec())

	var visual := Polygon2D.new()
	var hw := wave_width * 0.5
	var hh := wave_height * 0.5
	visual.polygon = PackedVector2Array([
		Vector2(-hh, -hw),
		Vector2(hh, -hw),
		Vector2(hh, hw),
		Vector2(-hh, hw),
	])
	visual.color = Color(0.65, 0.5, 0.85, 0.7)
	visual.rotation = dir.angle()
	wave.add_child(visual)

	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root
	parent.add_child(wave)
	wave.global_position = global_position

	var wave_id: int = wave.get_instance_id()
	wave.area_entered.connect(Callable(self, "_on_compat_wave_area_entered").bind(wave_id))
	_active_waves.append(wave)

	# Keep lifetime ownership under the projectile itself. If a hit frees the wave,
	# its Timer disappears with it rather than leaving a SceneTreeTimer lambda that
	# later tries to materialize a freed Object capture.
	var lifetime := Timer.new()
	lifetime.one_shot = true
	lifetime.wait_time = max_range / maxf(1.0, speed) + wave_lifetime_padding
	wave.add_child(lifetime)
	lifetime.timeout.connect(Callable(wave, "queue_free"))
	lifetime.start()


func _on_compat_wave_area_entered(area: Area2D, wave_id: int) -> void:
	var wave_value: Object = instance_from_id(wave_id)
	if wave_value is Area2D and is_instance_valid(wave_value):
		_on_wave_area_entered(wave_value as Area2D, area)


func _spawn_aoe_pulse(pos: Vector2) -> void:
	var pulse := Area2D.new()
	pulse.name = "LanternRepulse"
	pulse.collision_layer = 0
	pulse.collision_mask = 2
	pulse.monitoring = true

	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = aoe_radius
	shape.shape = circle
	pulse.add_child(shape)
	pulse.global_position = pos

	var flash_visual := Polygon2D.new()
	var points := PackedVector2Array()
	for s in range(20):
		var angle := float(s) / 20.0 * TAU
		points.append(Vector2(cos(angle), sin(angle)) * aoe_radius)
	flash_visual.polygon = points
	flash_visual.color = Color(1.0, 0.4, 0.3, 0.6)
	flash_visual.z_index = -1
	pulse.add_child(flash_visual)

	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root
	parent.add_child(pulse)

	var pulse_id: int = pulse.get_instance_id()
	pulse.area_entered.connect(Callable(self, "_on_compat_pulse_area_entered").bind(pulse_id))

	var overlap_probe := Timer.new()
	overlap_probe.one_shot = true
	overlap_probe.wait_time = 0.05
	pulse.add_child(overlap_probe)
	overlap_probe.timeout.connect(Callable(self, "_on_compat_pulse_overlap_timeout").bind(pulse_id))
	overlap_probe.start()

	var lifetime := Timer.new()
	lifetime.one_shot = true
	lifetime.wait_time = 0.15
	pulse.add_child(lifetime)
	lifetime.timeout.connect(Callable(pulse, "queue_free"))
	lifetime.start()


func _on_compat_pulse_area_entered(area: Area2D, pulse_id: int) -> void:
	if area == null or not area.is_in_group("player_hurtbox"):
		return
	var pulse_value: Object = instance_from_id(pulse_id)
	if not (pulse_value is Area2D) or not is_instance_valid(pulse_value):
		return
	var pulse := pulse_value as Area2D
	if pulse.has_meta("_aoe_hit"):
		return
	pulse.set_meta("_aoe_hit", true)
	if area.has_signal("hurt"):
		area.emit_signal("hurt", aoe_damage, "unblockable", self)


func _on_compat_pulse_overlap_timeout(pulse_id: int) -> void:
	var pulse_value: Object = instance_from_id(pulse_id)
	if not (pulse_value is Area2D) or not is_instance_valid(pulse_value):
		return
	var pulse := pulse_value as Area2D
	for area_value: Variant in pulse.get_overlapping_areas():
		if area_value is Area2D:
			_on_compat_pulse_area_entered(area_value as Area2D, pulse_id)
