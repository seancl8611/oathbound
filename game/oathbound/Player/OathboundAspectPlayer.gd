extends "res://Player/OathboundPlayerStability.gd"

## Current Blood-Aspect-aware Player layer. It replaces the old generic sword attack
## profiles with Wolf/Wraith/Ronin weapon kits while preserving shared locomotion,
## dash, parry/block, deathblow, Technique, and Prosthetic plumbing.

const ASPECT_CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")

var _aspect_attack_connected := false
var _aspect_previous_attack_id := ""
var _aspect_previous_connected := false
var _aspect_attack_hp_start := 0
var _aspect_barrage_count := 0
var _aspect_barrage_direction := Vector2.RIGHT
var _aspect_reprisal_until := 0.0
var _aspect_measured_until := 0.0
var _aspect_perfect_weight_pending := false
var _aspect_fanged_guard_available := false
var _aspect_resolve_available := false
var _blood_hunt_exceptions: Array[Node] = []

func _ready() -> void:
	super._ready()
	apply_aspect_configuration()
	print("[OathboundAspectPlayer] %s Tier %d" % [AspectRuntime.selected_aspect, AspectRuntime.tier])

# =============================================================================
# ASPECT CONFIGURATION / PROFILES
# =============================================================================

func apply_aspect_configuration() -> void:
	if typeof(AspectRuntime) != TYPE_OBJECT:
		return
	var old_max := maxf(1.0, float(stagger_max))
	var ratio := clampf(float(stagger) / old_max, 0.0, 1.0)
	stagger_max = ASPECT_CATALOG.max_posture(AspectRuntime.selected_aspect, AspectRuntime.tier)
	stagger = minf(stagger_max, ratio * stagger_max)
	stagger_regen_rate = ASPECT_CATALOG.posture_recovery_rate(AspectRuntime.selected_aspect)
	_update_stagger_ui()

func _get_combo_profile(combo_idx: int) -> Dictionary:
	var profiles := ASPECT_CATALOG.get_basic_profiles(AspectRuntime.selected_aspect, AspectRuntime.tier)
	if profiles.is_empty():
		return super._get_combo_profile(combo_idx)
	return profiles[clampi(combo_idx, 0, profiles.size() - 1)].duplicate(true)

func _start_tap_attack_from_hold() -> void:
	var profiles := ASPECT_CATALOG.get_basic_profiles(AspectRuntime.selected_aspect, AspectRuntime.tier)
	var next_combo := 0
	if _combo_link_timer > 0.0 and _combo_index < profiles.size() - 1 and bool(_attack_profile.get("can_combo", true)):
		next_combo = _combo_index + 1
	_start_attack(next_combo)

func _start_thrust() -> void:
	_attack_hold_timer = 0.0
	_attack_hold_ready = false
	var profile := ASPECT_CATALOG.get_held_profile(AspectRuntime.selected_aspect, AspectRuntime.tier)
	_start_profile_attack(profile, 0)

func _start_dash_slash() -> void:
	if not _can_start_dash_slash():
		return
	_dash_slash_consumed = true
	_clear_dash_slash_window()
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	_start_profile_attack(ASPECT_CATALOG.get_dash_profile(AspectRuntime.selected_aspect, AspectRuntime.tier), 0)

func _start_counter_cut() -> void:
	if _state == State.BLOCKING and combat:
		combat.end_block()
	_parry_active = false
	_block_held = false
	_wants_block_takeover = false
	_clear_counter_cut_window()
	_start_profile_attack(ASPECT_CATALOG.get_counter_profile(AspectRuntime.selected_aspect, AspectRuntime.tier), 0)

func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	if profile.is_empty():
		return
	var resolved := profile.duplicate(true)
	resolved["aspect_id"] = AspectRuntime.selected_aspect
	resolved["aspect_tier"] = AspectRuntime.tier

	var id := str(resolved.get("id", ""))
	var blood_tempo_continuation := _is_blood_tempo_continuation(id, combo_idx)
	if AspectRuntime.selected_aspect == ASPECT_CATALOG.WOLF and AspectRuntime.tier >= 1 and blood_tempo_continuation:
		var bonus := ASPECT_CATALOG.feral_bonus(combo_idx, AspectRuntime.tier)
		resolved["health_damage"] = int(round(float(resolved.get("health_damage", 0)) * (1.0 + bonus)))
		resolved["damage"] = resolved["health_damage"]
		resolved["posture_damage"] = float(resolved.get("posture_damage", 0.0)) * (1.0 + bonus)
		resolved["posture"] = resolved["posture_damage"]
		resolved["block_posture_damage"] = float(resolved.get("block_posture_damage", 0.0)) * (1.0 + bonus)
		resolved["blood_tempo_continuation"] = true

	_aspect_perfect_weight_pending = false
	if AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN and AspectRuntime.tier >= 3 and _measured_weight_active() and id in ["ronin_bloodfall", "ronin_stillness_draw", "ronin_answering_steel", "ronin_reprisal_cut"]:
		resolved["posture_damage"] = float(resolved.get("posture_damage", 0.0)) * 1.35
		resolved["posture"] = resolved["posture_damage"]
		resolved["block_posture_damage"] = float(resolved.get("block_posture_damage", 0.0)) * 1.35
		resolved["perfect_weight"] = true
		_aspect_perfect_weight_pending = true

	_aspect_attack_connected = false
	_aspect_attack_hp_start = hp
	_aspect_fanged_guard_available = _wolf_fanged_guard_eligible(id, blood_tempo_continuation)
	_aspect_resolve_available = AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN and AspectRuntime.tier >= 3 and id in ["ronin_bloodfall", "ronin_stillness_draw", "ronin_answering_steel", "ronin_reprisal_cut"]

	super._start_profile_attack(resolved, combo_idx)

	if id == "wraith_pale_barrage":
		_attack_aim_dir = _aspect_barrage_direction
		_update_sprite_facing(_attack_aim_dir)
		_position_sword_hitbox_for_attack()

func _on_attack_hit(target: Node, combo_idx: int) -> void:
	super._on_attack_hit(target, combo_idx)
	_aspect_attack_connected = true
	if bool(_attack_profile.get("perfect_weight", false)):
		_aspect_measured_until = 0.0
		_aspect_perfect_weight_pending = false

func _end_attack() -> void:
	var id := str(_attack_profile.get("id", ""))

	# Wraith Tier I: holding through Pale Lance continues into up to four restricted
	# stationary jabs along the original line. Release ends the sequence immediately.
	if AspectRuntime.selected_aspect == ASPECT_CATALOG.WRAITH and AspectRuntime.tier >= 1:
		if id == "wraith_pale_lance" and Input.is_action_pressed("attack"):
			_aspect_barrage_count = 1
			_aspect_barrage_direction = _attack_aim_dir
			_start_profile_attack(ASPECT_CATALOG.get_wraith_barrage_profile(), 0)
			return
		if id == "wraith_pale_barrage" and Input.is_action_pressed("attack") and _aspect_barrage_count < 4:
			_aspect_barrage_count += 1
			_start_profile_attack(ASPECT_CATALOG.get_wraith_barrage_profile(), 0)
			return
		if id == "wraith_pale_barrage":
			_aspect_barrage_count = 0

	var connected := _aspect_attack_connected
	var hp_unchanged := hp >= _aspect_attack_hp_start
	var was_blood_tempo := bool(_attack_profile.get("blood_tempo_continuation", false))

	super._end_attack()

	if AspectRuntime.selected_aspect == ASPECT_CATALOG.WOLF and AspectRuntime.tier >= 1 and connected:
		_recovery_timer *= 0.60

	if AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN and AspectRuntime.tier >= 3 and connected and hp_unchanged and id in ["ronin_severing_cut", "ronin_crushing_cross", "ronin_bloodfall", "ronin_stillness_draw", "ronin_answering_steel", "ronin_reprisal_cut"] and not bool(_attack_profile.get("perfect_weight", false)):
		_aspect_measured_until = Time.get_ticks_msec() * 0.001 + 4.0

	_aspect_previous_attack_id = id
	_aspect_previous_connected = connected
	_aspect_fanged_guard_available = false
	_aspect_resolve_available = false

	if id == "wolf_blood_hunt":
		_clear_blood_hunt_exceptions()
		AspectRuntime.resolve_wolf_blood_fang(self, _attack_aim_dir)
	elif id == "wraith_reach_corridor":
		AspectRuntime.schedule_wraith_reach_echo(global_position, _attack_aim_dir)
	elif id == "ronin_falling_mountain":
		AspectRuntime.resolve_ronin_falling_mountain(global_position)

func _is_blood_tempo_continuation(next_id: String, combo_idx: int) -> bool:
	if AspectRuntime.selected_aspect != ASPECT_CATALOG.WOLF or AspectRuntime.tier < 1 or not _aspect_previous_connected:
		return false
	if combo_idx <= 0:
		return false
	var allowed := {
		"wolf_fang_slash": "wolf_rending_cross",
		"wolf_rending_cross": "wolf_raking_fang",
		"wolf_raking_fang": "wolf_blood_cleave",
		"wolf_predators_passage": "wolf_rending_cross",
		"wolf_hunting_slash": "wolf_rending_cross",
		"wolf_fang_reversal": "wolf_rending_cross",
	}
	return str(allowed.get(_aspect_previous_attack_id, "")) == next_id

func _wolf_fanged_guard_eligible(id: String, blood_tempo: bool) -> bool:
	if AspectRuntime.selected_aspect != ASPECT_CATALOG.WOLF or AspectRuntime.tier < 3:
		return false
	if id == "wolf_predators_passage":
		return true
	return blood_tempo and id in ["wolf_raking_fang", "wolf_blood_cleave"]

# =============================================================================
# BLOOD ART INPUT / EXECUTION
# =============================================================================

func _gather_input() -> void:
	super._gather_input()
	if Input.is_action_just_pressed("special"):
		_try_activate_blood_art()

func _try_activate_blood_art() -> void:
	if _state not in [State.IDLE, State.MOVING] or not AspectRuntime.commit_blood_art():
		return
	_drop_combo()
	var direction := (get_global_mouse_position() - global_position).normalized()
	if direction.length_squared() <= 0.001:
		direction = _facing_dir
	var profile := ASPECT_CATALOG.get_blood_art_profile(AspectRuntime.selected_aspect)
	match AspectRuntime.selected_aspect:
		ASPECT_CATALOG.WOLF:
			AspectRuntime.begin_wolf_blood_hunt(self)
			_setup_blood_hunt_exceptions()
		ASPECT_CATALOG.WRAITH:
			AspectRuntime.begin_wraith_reach(self, direction)
		ASPECT_CATALOG.RONIN:
			AspectRuntime.begin_ronin_falling_mountain(self)
	_start_profile_attack(profile, 0)
	_attack_aim_dir = direction
	_update_sprite_facing(direction)
	_position_sword_hitbox_for_attack()

func _setup_blood_hunt_exceptions() -> void:
	_clear_blood_hunt_exceptions()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or enemy.is_in_group("miniboss") or bool(enemy.get_meta("aspect_heavy_stopper", false)):
			continue
		if enemy is PhysicsBody2D:
			add_collision_exception_with(enemy)
			_blood_hunt_exceptions.append(enemy)

func _clear_blood_hunt_exceptions() -> void:
	for enemy in _blood_hunt_exceptions:
		if is_instance_valid(enemy) and enemy is PhysicsBody2D:
			remove_collision_exception_with(enemy)
	_blood_hunt_exceptions.clear()

# =============================================================================
# RONIN BLOCK / REPRISAL + WOLF FANGED GUARD
# =============================================================================

func _on_hurt(dmg: int, dmg_type: String, attacker: Node = null) -> void:
	if _try_fanged_guard(dmg, dmg_type, attacker):
		return
	var preserve_knockback := _aspect_resolve_available and _ronin_resolve_hit_eligible(dmg_type, attacker)
	var old_knockback := knockback
	super._on_hurt(dmg, dmg_type, attacker)
	if preserve_knockback and _state == State.ATTACKING and stagger < stagger_max and hp > 0:
		knockback = old_knockback
		_aspect_resolve_available = false

func _try_fanged_guard(_dmg: int, dmg_type: String, attacker: Node) -> bool:
	if not _aspect_fanged_guard_available or _state != State.ATTACKING:
		return false
	if dmg_type in ["grab", "mass", "unblockable", "perilous"]:
		return false
	var source := _resolve_attacker(attacker if attacker is Area2D else null, attacker)
	if not (source is Node2D):
		return false
	var to_attacker := (source as Node2D).global_position - global_position
	if to_attacker.length_squared() > 0.001:
		var facing := _attack_aim_dir.normalized()
		if facing.dot(to_attacker.normalized()) < cos(deg_to_rad(CURRENT_BLOCK_ARC_DEGREES * 0.5)):
			return false
	var block_posture := 12.0
	if attacker != null and attacker.has_meta("block_posture_damage"):
		block_posture = float(attacker.get_meta("block_posture_damage"))
	stagger = clampf(stagger + block_posture, 0.0, stagger_max)
	_stagger_suppress_until = Time.get_ticks_msec() * 0.001 + ASPECT_CATALOG.posture_recovery_delay(AspectRuntime.selected_aspect)
	_aspect_fanged_guard_available = false
	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	if stagger >= stagger_max - 0.001:
		_posture_break()
	return true

func _handle_block(area: Area2D, dmg: int, dmg_type: String, attacker: Node, atk_pos: Vector2) -> void:
	var before_posture := float(stagger)
	var before_hp := hp
	super._handle_block(area, dmg, dmg_type, attacker, atk_pos)
	if AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN and hp == before_hp and _state != State.STUNNED:
		var added := maxf(0.0, float(stagger) - before_posture)
		stagger = before_posture + added * ASPECT_CATALOG.block_posture_multiplier(AspectRuntime.selected_aspect)
		_stagger_suppress_until = Time.get_ticks_msec() * 0.001 + ASPECT_CATALOG.posture_recovery_delay(AspectRuntime.selected_aspect)
		if AspectRuntime.tier >= 1:
			_aspect_reprisal_until = Time.get_ticks_msec() * 0.001 + 0.85

func _resolve_attack_press() -> bool:
	if AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN and AspectRuntime.tier >= 1 and Time.get_ticks_msec() * 0.001 <= _aspect_reprisal_until and _state in [State.IDLE, State.MOVING]:
		if _get_deathblow_target() == null and not _can_start_dash_slash() and not _can_start_counter_cut():
			_aspect_reprisal_until = 0.0
			_start_profile_attack(ASPECT_CATALOG.get_reprisal_profile(), 0)
			return true
	return super._resolve_attack_press()

func _ronin_resolve_hit_eligible(dmg_type: String, attacker: Node) -> bool:
	if AspectRuntime.selected_aspect != ASPECT_CATALOG.RONIN or AspectRuntime.tier < 3:
		return false
	if dmg_type in ["grab", "mass", "unblockable", "perilous"]:
		return false
	var source := _resolve_attacker(attacker if attacker is Area2D else null, attacker)
	if not (source is Node2D):
		return false
	var to_attacker := (source as Node2D).global_position - global_position
	return to_attacker.length_squared() <= 0.001 or _attack_aim_dir.normalized().dot(to_attacker.normalized()) >= 0.35

func take_damage(amount: int, show_feedback: bool = true) -> void:
	if amount > 0:
		_aspect_measured_until = 0.0
	super.take_damage(amount, show_feedback)

func _measured_weight_active() -> bool:
	return AspectRuntime.selected_aspect == ASPECT_CATALOG.RONIN and AspectRuntime.tier >= 3 and Time.get_ticks_msec() * 0.001 <= _aspect_measured_until

# =============================================================================
# WRAITH TIER IV / MOVEMENT
# =============================================================================

func _get_deathblow_target() -> Node:
	var normal := super._get_deathblow_target()
	if normal != null or AspectRuntime.selected_aspect != ASPECT_CATALOG.WRAITH or AspectRuntime.tier < 4:
		return normal
	var facing := _facing_dir.normalized()
	var best: Node = null
	var best_dist := 180.0
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or not (enemy is Node2D):
			continue
		var ready := false
		if enemy.has_method("is_deathblow_ready"):
			ready = bool(enemy.call("is_deathblow_ready"))
		elif enemy.get("can_be_finished") != null:
			ready = bool(enemy.get("can_be_finished"))
		if not ready:
			continue
		var offset := (enemy as Node2D).global_position - global_position
		var dist := offset.length()
		if dist > best_dist or dist <= 0.001 or facing.dot(offset.normalized()) < 0.55:
			continue
		best = enemy
		best_dist = dist
	return best

func _try_deathblow() -> bool:
	var target := _get_deathblow_target()
	var result := super._try_deathblow()
	if result and target != null:
		AspectRuntime.record_deathblow()
		if AspectRuntime.selected_aspect == ASPECT_CATALOG.WRAITH and AspectRuntime.tier >= 4:
			AspectRuntime.start_veilstride(self)
	return result

func _calculate_velocity(delta: float) -> void:
	super._calculate_velocity(delta)
	if _state in [State.IDLE, State.MOVING] and Time.get_ticks_msec() * 0.001 < float(get_meta("_aspect_veilstride_until", 0.0)):
		velocity *= 1.20

func _tick_stagger(delta: float) -> void:
	if stagger <= 0.0 or _state == State.BLOCKING or _state == State.STUNNED:
		return
	var now := Time.get_ticks_msec() * 0.001
	if now < _stagger_suppress_until:
		return
	stagger = maxf(0.0, stagger - ASPECT_CATALOG.posture_recovery_rate(AspectRuntime.selected_aspect) * delta)

# =============================================================================
# PLAYTEST INTROSPECTION
# =============================================================================

func get_playtest_snapshot() -> Dictionary:
	var snapshot := super.get_playtest_snapshot()
	snapshot["aspect"] = AspectRuntime.selected_aspect
	snapshot["aspect_tier"] = AspectRuntime.tier
	snapshot["blood"] = AspectRuntime.blood
	snapshot["blood_state"] = AspectRuntime.blood_state()
	snapshot["reprisal_ready"] = Time.get_ticks_msec() * 0.001 <= _aspect_reprisal_until
	snapshot["measured_weight"] = _measured_weight_active()
	return snapshot

func _exit_tree() -> void:
	_clear_blood_hunt_exceptions()
