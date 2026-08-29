extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanController.gd"

## Readability/stability layer for the current Hushiro Swordsman.
## Keeps the existing attack implementations and authored sprites while replacing the
## imported pacing with a controlled Sekiro-like duel cadence and visible hit recoil.

const LIGHT_HIT_STUN := 0.16
const MEDIUM_HIT_STUN := 0.22
const HEAVY_HIT_STUN := 0.30
const POST_HIT_BREATHING_ROOM := 0.24
const GUARD_CUE_COLOR := Color(0.86, 0.94, 1.0, 0.95)

var _guard_cue: Line2D = null


func _ready() -> void:
	# Keep the actual tells readable, but shorten the idle/observation gaps. The room
	# director now controls concurrency, so an individual Swordsman should actively
	# contest Akio when it owns the turn rather than circle for several seconds.
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
	_arm_legacy_timer_cleanup()
	_ensure_guard_cue()
	_sync_guard_cue(false)
	print("[CorruptedSwordsman] v2.2 - active duel cadence + explicit guard cue")


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
# PLAYER-FACING GUARD READABILITY
# =============================================================================
# The imported foot-soldier sheet has no authored block animation. Previously the
# Swordsman could be mechanically guarding while still displaying its walk frame,
# making a posture-only block look like an ordinary HP hit. Keep combat ownership in
# HumanoidEnemyBase, but expose the active guard state with a small shield outline.

func _set_blocking(active: bool) -> void:
	super._set_blocking(active)
	_sync_guard_cue(bool(_block_active))


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
	var hp_before: int = int(hp)
	super._on_hurt_box_hurt(damage, damage_type, attacker)
	if has_died or int(hp) <= 0 or _dbroken_active:
		return
	if int(hp) >= hp_before:
		return
	_apply_sword_hit_reaction(damage, damage_type)


func _apply_sword_hit_reaction(damage: int, damage_type: String) -> void:
	# Winning a clean sword contact must visibly interrupt ordinary offense. This is
	# intentionally short: it gives impact readability without turning light attacks
	# into permanent stun-lock.
	_cancel_attack()
	_set_blocking(false)
	_in_running_approach = false
	_combo_hits_remaining = 0
	_commitment_until = 0.0
	_force_attack_soon = false

	var reaction: float = LIGHT_HIT_STUN
	if damage >= 18 or damage_type in ["heavy", "counter", "thrust"]:
		reaction = HEAVY_HIT_STUN
	elif damage >= 11:
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
		})
