extends "res://Player/OathboundCombatPlayerCore.gd"

## Release accessibility bridge around the canonical combat Player implementation.
## The copied core remains the gameplay authority; this wrapper only scales presentation
## feedback according to launch accessibility settings while preserving this canonical
## script path for Player ownership checks and scene references.


func _handle_parry_success(area: Area2D, attacker: Node, dmg_type: String, atk_pos: Vector2, is_perfect: bool):
	# Some imported elite enemies react to a parry without actually applying their
	# authored enemy-posture pressure. Preserve enemies that already mutate posture,
	# but provide one bounded fallback for a configured parry_posture_damage when the
	# parry reaction left posture completely unchanged. This fixes Collector without
	# double-counting Keeper or ordinary enemies that already own their parry posture.
	var resolved_attacker: Node = _resolve_attacker(area, attacker)
	var target_combat: Node = null
	var posture_before: float = 0.0
	if resolved_attacker != null and is_instance_valid(resolved_attacker):
		target_combat = resolved_attacker.get_node_or_null("Combat")
		if target_combat != null and target_combat.has_method("get_posture"):
			posture_before = float(target_combat.call("get_posture"))

	super._handle_parry_success(area, attacker, dmg_type, atk_pos, is_perfect)

	if resolved_attacker == null or not is_instance_valid(resolved_attacker) or target_combat == null:
		return
	if not target_combat.has_method("get_posture") or not target_combat.has_method("add_posture"):
		return
	var posture_after: float = float(target_combat.call("get_posture"))
	if absf(posture_after - posture_before) > 0.001:
		return
	var configured_value: Variant = resolved_attacker.get("parry_posture_damage")
	if configured_value == null:
		return
	var fallback_posture: float = maxf(0.0, float(configured_value))
	if fallback_posture <= 0.0:
		return
	target_combat.call("add_posture", fallback_posture)
	if target_combat.has_method("suppress_recovery"):
		target_combat.call("suppress_recovery", 1.0)
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_parry_posture_fallback", {
			"target": CombatTelemetry.snapshot_actor(resolved_attacker),
			"posture_before": posture_before,
			"posture_after": float(target_combat.call("get_posture")),
			"configured_amount": fallback_posture,
		})


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
