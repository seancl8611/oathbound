extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanController.gd"

## Readability/stability layer for the current Hushiro Swordsman.
## Keeps the existing attack implementations and authored sprites while replacing the
## imported "FAST" pacing with deliberate duel cadence and visible sword-hit recoil.

const LIGHT_HIT_STUN := 0.16
const MEDIUM_HIT_STUN := 0.22
const HEAVY_HIT_STUN := 0.30
const POST_HIT_BREATHING_ROOM := 0.28


func _ready() -> void:
	# Set current Hushiro combat pacing before the inherited ready path copies values
	# into shared humanoid helpers.
	telegraph_time = 0.68
	thrust_telegraph_time = 0.72
	cross_telegraph_time = 0.68
	running_telegraph_time = 0.72
	swipe_cooldown_min = 1.05
	swipe_cooldown_max = 1.65
	attack_gap_minimum = 1.05
	cross_swing_hit_delay = 0.58
	followup_delay = 0.62
	recover_lock = 0.22
	start_delay_min = 0.08
	start_delay_max = 0.18
	observation_time_min = 0.65
	observation_time_max = 1.25
	max_passive_time = 3.25
	commitment_duration = 0.90
	counter_attack_chance = 0.25
	counter_attack_delay = 0.55
	pre_pause_min = 0.08
	pre_pause_max = 0.16
	idle_sway_amount = 4.0
	orbit_speed = 20.0
	watch_orbit_speed = 26.0
	super._ready()
	print("[CorruptedSwordsman] v2.0 - deliberate Hushiro duel cadence")


func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	var hp_before := hp
	super._on_hurt_box_hurt(damage, damage_type, attacker)
	if has_died or hp <= 0 or _dbroken_active:
		return
	if hp >= hp_before:
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

	var reaction := LIGHT_HIT_STUN
	if damage >= 18 or damage_type in ["heavy", "counter", "thrust"]:
		reaction = HEAVY_HIT_STUN
	elif damage >= 11:
		reaction = MEDIUM_HIT_STUN

	var now := Time.get_ticks_msec() * 0.001
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
