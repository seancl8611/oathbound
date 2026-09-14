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
##
## Combat V2 defense retirement:
## Player Posture is no longer a player-facing durability resource. Health is the sole
## ordinary durability meter; holding guard converts eligible frontal hits into authored
## Health chip instead of filling a second meter. The inherited stagger fields remain at
## a safe compatibility shape until the legacy controller can be deleted outright.

const AREA1_PRESSURE_MAX_HITS: int = 6
const AREA1_PRESSURE_MIDPOINT_HIT: int = 3
const BASE_KATANA_IDS: Array[String] = ["quick_slash", "cross_cut", "heavy_cleave"]
const PARRY_POLICY = preload("res://Core/Combat/OathboundParryPolicy.gd")

const PLAYER_POSTURE_COMPATIBILITY_MAX: float = 100.0
const BASE_BLOCK_HEALTH_RATIO: float = 0.35
const RONIN_BLOCK_HEALTH_RATIO_T0: float = 0.30
const RONIN_BLOCK_HEALTH_TIER_STEP: float = 0.025
const RONIN_BLOCK_HEALTH_RATIO_MIN: float = 0.20

var _area1_pressure_hits_started: int = 0
var _area1_pressure_active: bool = false


func _ready() -> void:
	super._ready()
	_retire_player_posture_state()
	print("[OathboundPlayer] v2.3 - Health guard + retired player Posture")


# =============================================================================
# PLAYER DEFENSE - HEALTH + GUARD, NO PLAYER POSTURE
# =============================================================================

func apply_aspect_configuration() -> void:
	# Preserve all non-defense Aspect setup owned by the inherited integration layer,
	# then neutralize the legacy player-Posture compatibility fields.
	super.apply_aspect_configuration()
	_retire_player_posture_state()


func _setup_stagger_ui() -> void:
	# The imported controller creates this dynamically. Keeping setup as a deliberate
	# no-op prevents a retired meter from entering the scene tree in the first place.
	_stagger_ui = null
	_stagger_bg = null
	_stagger_fill = null
	_stagger_border = null


func _update_stagger_ui() -> void:
	stagger = 0.0
	if _stagger_ui != null and is_instance_valid(_stagger_ui):
		_stagger_ui.visible = false


func _tick_stagger(_delta: float) -> void:
	# Some imported mechanics still write the compatibility field. It may never persist
	# long enough to become a gameplay resource or trigger the old break state.
	if not is_zero_approx(float(stagger)):
		stagger = 0.0


func _posture_break() -> void:
	# Compatibility-only override. Player Posture cannot stun Akio in Combat V2.
	stagger = 0.0
	_stun_until = 0.0
	_stun_started_at = 0.0
	if _state == State.STUNNED:
		_change_state(State.IDLE)
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("retired_player_posture_break_ignored", {
			"player": CombatTelemetry.snapshot_actor(self),
		})


func _retire_player_posture_state() -> void:
	stagger = 0.0
	stagger_max = PLAYER_POSTURE_COMPATIBILITY_MAX
	stagger_regen_rate = 0.0
	stagger_regen_blocked = 0.0
	_stagger_suppress_until = 0.0
	_stun_until = 0.0
	_stun_started_at = 0.0
	_update_stagger_ui()


func _player_block_health_ratio() -> float:
	if typeof(AspectRuntime) == TYPE_OBJECT and str(AspectRuntime.selected_aspect) == str(ASPECT_CATALOG.RONIN):
		var tier: int = clampi(int(AspectRuntime.tier), 0, 4)
		return maxf(
			RONIN_BLOCK_HEALTH_RATIO_MIN,
			RONIN_BLOCK_HEALTH_RATIO_T0 - RONIN_BLOCK_HEALTH_TIER_STEP * float(tier)
		)
	return BASE_BLOCK_HEALTH_RATIO


func get_player_block_health_ratio_for_test() -> float:
	return _player_block_health_ratio()


func is_player_posture_retired() -> bool:
	return true


func _blocked_health_damage(incoming_damage: int) -> int:
	if incoming_damage <= 0:
		return 0
	return maxi(1, int(round(float(incoming_damage) * _player_block_health_ratio())))


func _handle_block(area: Area2D, dmg: int, dmg_type: String, attacker: Node, atk_pos: Vector2) -> void:
	var resolved_attacker: Node = _resolve_attacker(area, attacker)
	var attack_origin: Vector2 = atk_pos
	if resolved_attacker is Node2D and is_instance_valid(resolved_attacker):
		attack_origin = (resolved_attacker as Node2D).global_position

	var to_attacker: Vector2 = attack_origin - global_position
	var facing: Vector2 = _facing_dir.normalized()
	if facing.length_squared() <= 0.001:
		facing = Vector2.RIGHT
	var relative_angle: float = 0.0
	if to_attacker.length_squared() > 0.001:
		relative_angle = absf(rad_to_deg(facing.angle_to(to_attacker.normalized())))
	var inside_arc: bool = to_attacker.length_squared() <= 0.001 or relative_angle <= CURRENT_BLOCK_ARC_DEGREES * 0.5

	if not inside_arc:
		if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
			CombatTelemetry.record_resolution("block_failed_outside_arc", self, resolved_attacker, area, {
				"damage": dmg,
				"damage_type": dmg_type,
				"attack_position": [attack_origin.x, attack_origin.y],
				"relative_angle_deg": relative_angle,
				"block_half_arc_deg": CURRENT_BLOCK_ARC_DEGREES * 0.5,
				"player_posture_retired": true,
			})
		take_damage(dmg)
		var rear_kb_dir: Vector2 = (global_position - attack_origin).normalized()
		knockback += rear_kb_dir * 120.0
		if combat:
			combat.notify_got_hit({"damage": dmg, "type": dmg_type})
		return

	var hp_before: int = int(hp)
	var guard_damage: int = _blocked_health_damage(dmg)
	if guard_damage > 0:
		take_damage(guard_damage, false)
	var hp_after: int = int(hp)
	var actual_health_lost: int = maxi(0, hp_before - hp_after)
	stagger = 0.0

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_resolution("block_success", self, resolved_attacker, area, {
			"damage_type": dmg_type,
			"incoming_health_damage": dmg,
			"health_damage_received": actual_health_lost,
			"block_health_ratio": _player_block_health_ratio(),
			"player_posture_retired": true,
			"aspect": str(AspectRuntime.selected_aspect) if typeof(AspectRuntime) == TYPE_OBJECT else "",
			"aspect_tier": int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0,
			"attack_position": [attack_origin.x, attack_origin.y],
			"relative_angle_deg": relative_angle,
		})

	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)

	var kb_dir: Vector2 = (global_position - attack_origin).normalized()
	knockback += kb_dir * 50.0

	var contact_source: Node = attacker if attacker != null and is_instance_valid(attacker) else resolved_attacker
	if contact_source != null and is_instance_valid(contact_source):
		if contact_source.has_method("on_blocked"):
			contact_source.call("on_blocked")
		elif contact_source.is_in_group("enemy_projectile") or contact_source.is_in_group("deflectable"):
			contact_source.queue_free()

	# Ronin keeps its authored block-to-Reprisal conversion. Its stronger guard identity
	# now lives in lower Health chip rather than a larger/slower Posture meter.
	if hp > 0 and typeof(AspectRuntime) == TYPE_OBJECT and str(AspectRuntime.selected_aspect) == str(ASPECT_CATALOG.RONIN) and int(AspectRuntime.tier) >= 1:
		_aspect_reprisal_until = Time.get_ticks_msec() * 0.001 + 0.85


func _try_fanged_guard(dmg: int, dmg_type: String, attacker: Node) -> bool:
	# Wolf Tier III remains one qualifying frontal normal guard during its authored
	# commitment window. It now resolves through the same Health-chip rule as ordinary
	# guard and can no longer build or break player Posture.
	if not _aspect_fanged_guard_available or _state != State.ATTACKING:
		return false
	if dmg_type in ["grab", "mass", "unblockable", "perilous"]:
		return false
	var source: Node = _resolve_attacker(attacker if attacker is Area2D else null, attacker)
	if not (source is Node2D):
		return false
	var to_attacker: Vector2 = (source as Node2D).global_position - global_position
	if to_attacker.length_squared() > 0.001:
		var attack_facing: Vector2 = _attack_aim_dir.normalized()
		if attack_facing.dot(to_attacker.normalized()) < cos(deg_to_rad(CURRENT_BLOCK_ARC_DEGREES * 0.5)):
			return false

	var hp_before: int = int(hp)
	var guard_damage: int = _blocked_health_damage(dmg)
	if guard_damage > 0:
		take_damage(guard_damage, false)
	_aspect_fanged_guard_available = false
	stagger = 0.0
	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("wolf_fanged_guard", {
			"player": CombatTelemetry.snapshot_actor(self),
			"incoming_health_damage": dmg,
			"health_damage_received": maxi(0, hp_before - int(hp)),
			"block_health_ratio": _player_block_health_ratio(),
			"player_posture_retired": true,
		})
	return true


func get_playtest_snapshot() -> Dictionary:
	var snapshot: Dictionary = super.get_playtest_snapshot()
	snapshot["posture"] = 0.0
	snapshot["max_posture"] = 0.0
	snapshot["posture_retired"] = true
	snapshot["block_health_ratio"] = _player_block_health_ratio()
	return snapshot


func get_core_combat_baseline() -> Dictionary:
	var baseline: Dictionary = super.get_core_combat_baseline()
	baseline["max_posture"] = 0.0
	baseline["posture_recover_delay"] = 0.0
	baseline["posture_recover_rate"] = 0.0
	baseline["posture_break_duration"] = 0.0
	baseline["posture_break_reset_ratio"] = 0.0
	baseline["player_posture_retired"] = true
	baseline["block_health_ratio"] = _player_block_health_ratio()
	return baseline


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


# =============================================================================
# SPECIAL-ONLY PARRY CLASSIFICATION
# =============================================================================

func can_parry_incoming_attack(source: Node, damage_type: String = "") -> bool:
	return bool(PARRY_POLICY.is_special_parry_attack(source, damage_type))


func _on_hurt(dmg: int, dmg_type: String, attacker: Node = null) -> void:
	# The imported resolver assumes every non-unblockable attack is parryable. Combat V2
	# intentionally inverts that default. For ordinary hits, temporarily close only the
	# parry/grace path while preserving the PARRYING state; the inherited resolver then
	# routes a held defense input into its existing auto-block path when the attack is
	# blockable. Explicit specials keep the canonical parry behavior unchanged.
	if can_parry_incoming_attack(attacker, dmg_type):
		super._on_hurt(dmg, dmg_type, attacker)
		return

	var parry_was_active: bool = bool(_parry_active)
	var grace_until_before: float = float(_parry_grace_until)
	var perfect_before: bool = bool(_perfect_parry_available)
	var now: float = Time.get_ticks_msec() * 0.001
	var defense_was_parry_window: bool = parry_was_active or now < grace_until_before

	_parry_active = false
	_parry_grace_until = -1.0
	_perfect_parry_available = false
	super._on_hurt(dmg, dmg_type, attacker)

	# If the ordinary hit resolved as the inherited PARRYING-state auto-block, keep the
	# remainder of Akio's input window alive for a later explicitly special attack.
	if hp > 0 and _state == State.PARRYING:
		_parry_active = parry_was_active and _parry_timer > 0.0
		_parry_grace_until = grace_until_before if now < grace_until_before else -1.0
		_perfect_parry_available = perfect_before

	if defense_was_parry_window and typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("ordinary_attack_parry_bypassed", {
			"player": CombatTelemetry.snapshot_actor(self),
			"source": CombatTelemetry.snapshot_actor(attacker) if attacker != null and is_instance_valid(attacker) else {},
			"damage_type": dmg_type,
			"blockable_path_preserved": dmg_type not in ["grab", "mass", "unblockable", "perilous"],
		})


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