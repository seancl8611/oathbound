extends "res://Player/OathboundCombatPlayerCore.gd"

## Release accessibility bridge around the canonical combat Player implementation.
## The copied core remains the gameplay authority; this wrapper only scales presentation
## feedback according to launch accessibility settings while preserving this canonical
## script path for Player ownership checks and scene references.


func _shake_camera(intensity: float, duration: float) -> void:
	_apply_impact_vibration(intensity, duration)
	var scale: float = 1.0
	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("get_screen_shake_scale"):
		scale = clampf(float(SettingsManager.get_screen_shake_scale()), 0.0, 1.0)
	if scale <= 0.001:
		var cam: Node = get_node_or_null("Camera2D")
		if cam != null:
			cam.offset = Vector2.ZERO
		return
	super._shake_camera(intensity * scale, duration)


func _flash_player(color: Color, duration: float) -> void:
	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("should_reduce_flashing") and bool(SettingsManager.should_reduce_flashing()):
		var base_color: Color = _base_sprite_modulate if typeof(_base_sprite_modulate) == TYPE_COLOR else Color.WHITE
		super._flash_player(base_color.lerp(color, 0.35), minf(duration, 0.06))
		return
	super._flash_player(color, duration)


func _spawn_parry_effect(pos: Vector2, is_perfect: bool) -> void:
	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("should_reduce_intense_vfx") and bool(SettingsManager.should_reduce_intense_vfx()):
		return
	super._spawn_parry_effect(pos, is_perfect)


func _spawn_block_sparks(pos: Vector2) -> void:
	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("should_reduce_intense_vfx") and bool(SettingsManager.should_reduce_intense_vfx()):
		return
	super._spawn_block_sparks(pos)


func _apply_impact_vibration(intensity: float, duration: float) -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	if not SettingsManager.has_method("vibration_enabled") or not bool(SettingsManager.vibration_enabled()):
		return
	var strength: float = clampf(float(SettingsManager.get_vibration_strength()), 0.0, 1.0) if SettingsManager.has_method("get_vibration_strength") else 1.0
	if strength <= 0.001:
		return
	var normalized: float = clampf(intensity / maxf(1.0, SHAKE_HEAVY), 0.0, 1.0)
	var weak: float = normalized * 0.30 * strength
	var strong: float = normalized * 0.70 * strength
	for device_id: int in Input.get_connected_joypads():
		Input.start_joy_vibration(device_id, weak, strong, maxf(0.02, duration))