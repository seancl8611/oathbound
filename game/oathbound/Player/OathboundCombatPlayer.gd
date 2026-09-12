extends "res://Player/OathboundCombatPlayerCore.gd"

## Release accessibility bridge around the canonical combat Player implementation.
## The copied core remains the gameplay authority; this wrapper only scales presentation
## feedback according to launch accessibility settings while preserving this canonical
## script path for Player ownership checks and scene references.
##
## The Area 1 player-paced pressure extension also lives here rather than replacing the
## canonical Player script. It changes only the pre-awakening base-katana continuation
## boundary: the first Heavy Cleave may flow into a second Quick/Cross/Heavy phrase.
## Hitboxes, AttackEvent delivery, dash/parry cancellation, held-Thrust branching,
## PlayerMotor, CombatActionRunner, and recovery timing remain owned by the core.

const AREA1_PRESSURE_MAX_HITS: int = 6
const AREA1_PRESSURE_MIDPOINT_HIT: int = 3
const BASE_KATANA_IDS: Array[String] = ["quick_slash", "cross_cut", "heavy_cleave"]

var _area1_pressure_hits_started: int = 0
var _area1_pressure_active: bool = false


func _ready() -> void:
	super._ready()
	print("[OathboundPlayer] v2.2 - Area 1 six-hit player-paced pressure string")


func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	var resolved: Dictionary = profile
	var id: String = str(profile.get("id", ""))
	var base_katana_basic: bool = _area1_pressure_enabled() and id in BASE_KATANA_IDS

	if base_katana_basic:
		var continuing_second_phrase: bool = (
			_area1_pressure_active
			and combo_idx == 0
			and _state == State.ATTACK_RECOVERY
			and _area1_pressure_hits_started == AREA1_PRESSURE_MIDPOINT_HIT
		)
		if combo_idx == 0 and not continuing_second_phrase:
			_area1_reset_pressure_string()
			_area1_pressure_active = true
		elif not _area1_pressure_active:
			_area1_pressure_active = true

		_area1_pressure_hits_started = mini(AREA1_PRESSURE_MAX_HITS, _area1_pressure_hits_started + 1)

		if id == "heavy_cleave" and _area1_pressure_hits_started == AREA1_PRESSURE_MIDPOINT_HIT:
			resolved = profile.duplicate(true)
			resolved["can_combo"] = true
			resolved["area1_pressure_midpoint"] = true
			resolved["queue_start"] = 0.70
			resolved["combo_start"] = 0.72
			resolved["combo_end"] = 1.00
			resolved["restart_lockout"] = 0.0

	super._start_profile_attack(resolved, combo_idx)

	if base_katana_basic and typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_area1_pressure_swing", {
			"hit_number": _area1_pressure_hits_started,
			"attack_id": id,
			"combo_index": combo_idx,
			"midpoint": bool(resolved.get("area1_pressure_midpoint", false)),
			"max_hits": AREA1_PRESSURE_MAX_HITS,
		})


func _begin_attack_branch_hold() -> void:
	if _area1_is_midpoint_heavy():
		if _queued_combo_index != -1:
			return
		if not _queued_attack_profile.is_empty():
			return
		if _combo_attack_queued:
			return
		_attack_branch_hold_active = true
		_attack_branch_hold_timer = 0.0
		return
	super._begin_attack_branch_hold()


func _can_queue_next_combo_attack() -> bool:
	if _area1_is_midpoint_heavy():
		return _can_queue_sword_branch()
	return super._can_queue_next_combo_attack()


func _can_queue_sword_branch() -> bool:
	if not _area1_is_midpoint_heavy():
		return super._can_queue_sword_branch()

	if _queued_combo_index != -1:
		return false
	if not _queued_attack_profile.is_empty():
		return false
	if _queued_attack_hold_branch or _combo_attack_queued:
		return false
	if _attack_profile.is_empty() or not bool(_attack_profile.get("can_combo", false)):
		return false

	var duration: float = float(_attack_profile.get("duration", 0.30))
	var queue_start: float = float(_attack_profile.get("queue_start", 0.70))
	var combo_end: float = float(_attack_profile.get("combo_end", 1.00))
	var progress: float = _attack_elapsed / maxf(duration, 0.001)
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	return false


func _queue_next_combo_attack() -> void:
	if not _area1_is_midpoint_heavy():
		super._queue_next_combo_attack()
		return

	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _queued_attack_hold_branch or _combo_attack_queued:
		return

	_queued_combo_index = 0
	_combo_attack_queued = true
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_area1_pressure_phrase_queued", {
			"completed_hits": _area1_pressure_hits_started,
			"next_combo_index": 0,
		})


func _state_attack_recovery(delta: float) -> void:
	super._state_attack_recovery(delta)
	if _area1_pressure_hits_started >= AREA1_PRESSURE_MAX_HITS and _state not in [State.ATTACKING, State.ATTACK_RECOVERY]:
		_area1_reset_pressure_string()


func _drop_combo() -> void:
	_area1_reset_pressure_string()
	super._drop_combo()


func _area1_pressure_enabled() -> bool:
	return typeof(AspectRuntime) == TYPE_OBJECT and str(AspectRuntime.selected_aspect).is_empty()


func _area1_is_midpoint_heavy() -> bool:
	return (
		_area1_pressure_enabled()
		and _area1_pressure_active
		and _area1_pressure_hits_started == AREA1_PRESSURE_MIDPOINT_HIT
		and _combo_index == 2
		and str(_attack_profile.get("id", "")) == "heavy_cleave"
		and bool(_attack_profile.get("area1_pressure_midpoint", false))
	)


func _area1_reset_pressure_string() -> void:
	_area1_pressure_hits_started = 0
	_area1_pressure_active = false


func get_area1_pressure_snapshot() -> Dictionary:
	return {
		"enabled": _area1_pressure_enabled(),
		"active": _area1_pressure_active,
		"hits_started": _area1_pressure_hits_started,
		"max_hits": AREA1_PRESSURE_MAX_HITS,
		"midpoint_can_continue": _area1_is_midpoint_heavy(),
	}


static func area1_pressure_damage_target() -> Array[int]:
	return [9, 12, 21, 9, 12, 21]


static func area1_pressure_total_damage_target() -> int:
	var total: int = 0
	for damage: int in area1_pressure_damage_target():
		total += damage
	return total


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
