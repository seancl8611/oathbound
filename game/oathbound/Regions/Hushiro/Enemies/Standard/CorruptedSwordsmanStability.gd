extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanController.gd"

## Readability/stability layer for the current Hushiro Swordsman.
## Combat V2 reference slice: keeps the existing attack implementations and authored
## sprites while replacing permanent DEFEND blocking and unconditional hit interruption
## with authored guard windows and state-dependent poise.

const RESPONSE_PROFILE_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseProfile.gd")
const RESPONSE_RUNTIME_SCRIPT = preload("res://Core/Combat/EnemyCombatResponseRuntime.gd")

const LIGHT_HIT_STUN := 0.16
const MEDIUM_HIT_STUN := 0.22
const HEAVY_HIT_STUN := 0.30
const POST_HIT_BREATHING_ROOM := 0.24
const GUARD_CUE_COLOR := Color(0.86, 0.94, 1.0, 0.95)

var _guard_cue: Line2D = null
var _v2_response: Node = null


func _ready() -> void:
	# Keep the actual tells readable, but shorten the idle/observation gaps. The room
	# director still controls concurrency in this first V2 slice; individual response
	# behavior is migrated before PressureDirector V2 changes encounter admission.
	telegraph_time = 0.68
	thrust_telegraph_time = 0.72
	cross_telegraph_time = 0.68
	running_telegraph_time = 0.72
	swipe_cooldown_min = 0.82
	swipe_cooldown_max = 1.28
	attack_gap_minimum = 0.86
	cross_swing_hit_delay = 0.56
	followup_delay = 0.54
	recover_lock = 0.18
	start_delay_min = 0.05
	start_delay_max = 0.12
	observation_time_min = 0.35
	observation_time_max = 0.78
	max_passive_time = 1.85
	commitment_duration = 1.10
	counter_attack_chance = 0.28
	counter_attack_delay = 0.50
	pre_pause_min = 0.06
	pre_pause_max = 0.12
	idle_sway_amount = 4.0
	orbit_speed = 24.0
	watch_orbit_speed = 30.0
	super._ready()
	_install_v2_response_runtime()
	_arm_legacy_timer_cleanup()
	_ensure_guard_cue()
	_sync_guard_cue(false)
	print("[CorruptedSwordsman] v2.3 - Combat V2 guard/poise reference slice")


func _install_v2_response_runtime() -> void:
	if _v2_response != null and is_instance_valid(_v2_response):
		return
	var runtime_value: Variant = RESPONSE_RUNTIME_SCRIPT.new()
	if not (runtime_value is Node):
		push_error("[CorruptedSwordsman] Could not create EnemyCombatResponseRuntime")
		return
	_v2_response = runtime_value as Node
	_v2_response.name = "EnemyCombatResponseRuntime"
	add_child(_v2_response)

	var profile_value: Variant = RESPONSE_PROFILE_SCRIPT.corrupted_swordsman_v2()
	if profile_value == null:
		push_error("[CorruptedSwordsman] Could not create V2 response profile")
		return
	_v2_response.call("configure", self, profile_value)


func _arm_legacy_timer_cleanup() -> void:
	# The imported legacy controller exposes `attack_timer` for compatibility, but
	# constructs it with Timer.new() and never parents it. Preserve that surface for
	# the Swordsman's active lifetime, then explicitly release the orphan when this
	# enemy leaves the tree so room transitions and process shutdown cannot leak it.
	if not is_instance_valid(attack_timer):
		return
	if attack_timer.get_parent() != null:
		return
	if not tree_exiting.is_connected(_release_legacy_attack_timer):
		tree_exiting.connect(_release_legacy_attack_timer, CONNECT_ONE_SHOT)


func _release_legacy_attack_timer() -> void:
	if is_instance_valid(attack_timer) and attack_timer.get_parent() == null:
		attack_timer.free()
	attack_timer = null


# =============================================================================
# COMBAT V2 GUARD BEHAVIOR
# =============================================================================
# Guard is now a short authored action window with a real cooldown. DEFEND remains the
# legacy tactical intent for this migration slice, but it no longer means "block for
# the entire state." Heavy/strong-poise impacts can collapse the guard early.

func _update_blocking(_delta: float, now: float) -> void:
	if _v2_response == null or not is_instance_valid(_v2_response):
		super._update_blocking(_delta, now)
		return

	var wants_guard: bool = true
	if not can_block or _dbroken_active:
		wants_guard = false
	elif telegraphing or (is_attacking and not _attack_recovery):
		wants_guard = false
	elif ProstheticEffects.is_confused(self):
		wants_guard = false
	elif now < _block_stagger_until:
		wants_guard = false
	elif not is_instance_valid(player):
		wants_guard = false
	elif ai_state != AIState.DEFEND:
		wants_guard = false
	else:
		var profile_value: Variant = _v2_response.get("profile")
		var guard_range: float = hushiro_guard_range
		if profile_value != null:
			var configured_range: Variant = profile_value.get("guard_range")
			if configured_range != null:
				guard_range = minf(guard_range, float(configured_range))
		wants_guard = global_position.distance_to(player.global_position) <= minf(guard_range, deaggro_radius)

	var active_value: Variant = _v2_response.call("tick_guard", now, wants_guard)
	_set_blocking(bool(active_value))


func _set_blocking(active: bool) -> void:
	super._set_blocking(active)
	_sync_guard_cue(bool(_block_active))


func _should_resolve_v2_guard_hit(damage: int, damage_type: String, attacker: Node) -> bool:
	if _v2_response == null or not is_instance_valid(_v2_response) or not _block_active:
		return false
	if _dbroken_active or telegraphing or (is_attacking and not _attack_recovery):
		return false
	var response: Dictionary = _get_incoming_attack_response(damage, damage_type, attacker)
	if not bool(response.get("blockable", true)):
		return false
	if damage_type in ["true", "unblockable"]:
		return false
	return _is_frontal_attack(attacker)


func _consume_v2_guard_contact(attacker: Node) -> bool:
	var frame_now: int = Engine.get_frames_drawn()
	if frame_now != _last_token_frame:
		_seen_tokens_this_frame.clear()
		_last_token_frame = frame_now

	if attacker is Area2D and attacker.has_meta("swing_token"):
		var token: String = str(attacker.get_meta("swing_token"))
		if _seen_tokens_this_frame.has(token):
			return false
		_seen_tokens_this_frame[token] = true

	if attacker is Area2D:
		var now_ts: float = Time.get_ticks_msec() * 0.001
		var key: int = int(attacker.get_instance_id())
		var expires_at: float = float(_recent_hurt_sources.get(key, 0.0))
		if now_ts < expires_at:
			return false
		_recent_hurt_sources[key] = now_ts + _HURT_SOURCE_TTL
		if _recent_hurt_sources.size() > 32:
			for old_key: Variant in _recent_hurt_sources.keys():
				if float(_recent_hurt_sources[old_key]) <= now_ts:
					_recent_hurt_sources.erase(old_key)
	return true


func _resolve_v2_guard_hit(damage: int, damage_type: String, attacker: Node) -> void:
	if not _consume_v2_guard_contact(attacker):
		return
	set_meta("_post_break_decay_active", false)

	var source: Node = _resolve_hurt_source(attacker)
	if source != null and is_instance_valid(source) and source.is_in_group("enemy"):
		return

	var response: Dictionary = _get_incoming_attack_response(damage, damage_type, attacker)
	var decorated_value: Variant = _v2_response.call("decorate_guard_response", response)
	if decorated_value is Dictionary:
		response = decorated_value as Dictionary

	var now: float = Time.get_ticks_msec() * 0.001
	var posture_before: float = 0.0
	if combat != null and combat.has_method("get_posture"):
		posture_before = float(combat.call("get_posture"))

	var hp_before: int = int(hp)
	var hp_damage_value: Variant = _v2_response.call("guarded_health_damage", damage)
	var hp_damage: int = maxi(0, int(hp_damage_value))
	var is_heavy: bool = bool(response.get("heavy", false))

	_block_stagger_until = now + float(response.get("block_stagger", BLOCK_STAGGER_TIME))
	_on_block_impact(attacker, is_heavy, response)
	apply_hp_damage(hp_damage)

	if hp_damage > 0:
		var is_crit: bool = source != null and source.has_method("is_critical_strike") and bool(source.call("is_critical_strike"))
		var display_type: String = "critical" if is_crit else damage_type
		show_enemy_damage_number(hp_damage, display_type, -20.0)

	notify_combat_got_hit({
		"damage": damage,
		"health_damage": hp_damage,
		"blocked": true,
		"damage_type": damage_type,
		"v2_guard": true,
	})

	var broke_guard: bool = bool(_v2_response.call("on_guard_contact", now, attacker, response))
	if broke_guard:
		_set_blocking(false)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		var posture_after: float = posture_before
		if combat != null and combat.has_method("get_posture"):
			posture_after = float(combat.call("get_posture"))
		CombatTelemetry.record_event("enemy_v2_guard_resolution", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"raw_health_damage": damage,
			"health_damage_received": hp_before - int(hp),
			"posture_before": posture_before,
			"posture_after": posture_after,
			"guard_broken": broke_guard,
			"damage_type": damage_type,
		})

	if hp <= 0:
		death()
	elif snd_hit != null:
		snd_hit.play()


func _v2_attack_was_committed() -> bool:
	return telegraphing or (is_attacking and not _attack_recovery) or _in_running_approach


# =============================================================================
# PLAYER-FACING GUARD READABILITY
# =============================================================================

func _ensure_guard_cue() -> void:
	if _guard_cue != null and is_instance_valid(_guard_cue):
		return
	_guard_cue = Line2D.new()
	_guard_cue.name = "GuardCue"
	_guard_cue.width = 2.0
	_guard_cue.default_color = GUARD_CUE_COLOR
	_guard_cue.points = PackedVector2Array([
		Vector2(-6.0, -5.0),
		Vector2(-6.0, 1.0),
		Vector2(0.0, 7.0),
		Vector2(6.0, 1.0),
		Vector2(6.0, -5.0),
		Vector2(-6.0, -5.0),
	])
	_guard_cue.position = Vector2(0.0, -28.0)
	_guard_cue.z_index = 125
	_guard_cue.visible = false
	add_child(_guard_cue)


func _sync_guard_cue(active: bool) -> void:
	_ensure_guard_cue()
	if _guard_cue != null and is_instance_valid(_guard_cue):
		_guard_cue.visible = active


func is_guard_cue_visible() -> bool:
	return _guard_cue != null and is_instance_valid(_guard_cue) and _guard_cue.visible


func _current_attack_requires_perilous_warning(requested_unblockable: bool = false) -> bool:
	var show_perilous_warning: bool = requested_unblockable
	if is_instance_valid(_current_swipe_area):
		show_perilous_warning = show_perilous_warning or bool(_current_swipe_area.get_meta("perilous", false))
	return show_perilous_warning


func _show_parry_indicator(duration: float, is_unblockable: bool = false) -> void:
	# The inherited Quick Thrust windup historically passed `false` here even though
	# the current Hushiro rules layer stamps that exact hitbox as perilous/blockable=false.
	# Drive the warning from the authored live hitbox metadata so the visual language
	# cannot contradict the contact resolver. Follow-up slashes are stamped non-perilous
	# and therefore keep the normal indicator even though they occur inside a thrust combo.
	super._show_parry_indicator(duration, _current_attack_requires_perilous_warning(is_unblockable))


func is_deathblow_ready() -> bool:
	# Legacy Swordsman marks `_dbroken_active` on the same frame posture fills. The
	# shared Hushiro runtime owns the player-facing contract: stagger first, then arm.
	if has_died or int(hp) <= 0:
		return false
	var runtime: Node = get_node_or_null("HushiroPostureBreakRuntime")
	if runtime != null and runtime.has_method("is_deathblow_armed"):
		return bool(runtime.call("is_deathblow_armed"))
	return bool(get_meta("_oathbound_deathblow_ready", false))


func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	# Guarded hits are resolved here so Combat V2 can independently author partial
	# Health-through-guard and posture pressure without adding a second damage pass.
	if _should_resolve_v2_guard_hit(damage, damage_type, attacker):
		_resolve_v2_guard_hit(damage, damage_type, attacker)
		return

	var hp_before: int = int(hp)
	var committed_before: bool = _v2_attack_was_committed()
	super._on_hurt_box_hurt(damage, damage_type, attacker)
	if has_died or int(hp) <= 0 or _dbroken_active:
		return
	if int(hp) >= hp_before:
		return
	_apply_sword_hit_reaction(damage, damage_type, attacker, committed_before)


func _apply_sword_hit_reaction(damage: int, damage_type: String, attacker: Node, committed_before: bool) -> void:
	var should_interrupt: bool = true
	var response: Dictionary = _get_incoming_attack_response(damage, damage_type, attacker)
	if _v2_response != null and is_instance_valid(_v2_response):
		should_interrupt = bool(_v2_response.call("should_interrupt", attacker, response, committed_before))

	# Combat V2 distinction: Health damage always lands here, but a committed attack
	# may keep going when the incoming strike lacks enough poise power.
	if not should_interrupt:
		if CombatTelemetry != null and CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("enemy_v2_hit_absorbed_by_poise", {
				"enemy": CombatTelemetry.snapshot_actor(self),
				"damage": damage,
				"damage_type": damage_type,
				"committed": committed_before,
			})
		return

	# Winning a clean interruptible sword contact visibly cancels ordinary offense.
	_cancel_attack()
	_set_blocking(false)
	_in_running_approach = false
	_combo_hits_remaining = 0
	_commitment_until = 0.0
	_force_attack_soon = false

	var reaction: float = LIGHT_HIT_STUN
	if damage >= 18 or damage_type in ["heavy", "counter", "thrust", "sword_heavy", "sword_counter", "sword_thrust"]:
		reaction = HEAVY_HIT_STUN
	elif damage >= 11 or damage_type == "sword_medium":
		reaction = MEDIUM_HIT_STUN

	var now: float = Time.get_ticks_msec() * 0.001
	stunned_until = maxf(stunned_until, now + reaction)
	next_swipe_time = maxf(next_swipe_time, stunned_until + POST_HIT_BREATHING_ROOM)
	_last_attack_ended_at = maxf(_last_attack_ended_at, now)
	_switch_state(AIState.STUNNED)

	if anim:
		if anim.has_animation("parried"):
			anim.stop()
			anim.play("parried")
		elif anim.has_animation("hurt"):
			anim.stop()
			anim.play("hurt")

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_hit_reaction", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"damage": damage,
			"damage_type": damage_type,
			"stun_sec": reaction,
			"combat_v2": true,
		})
