extends "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanV2Brain.gd"

## Combat V2 Phase 4 pressure-admission adapter.
##
## The Swordsman no longer requests the legacy one-at-a-time melee token. EnemyBrain
## chooses an authored attack, this layer predicts its first dangerous impact, and the
## shared AttackDir/PressureDirectorV2 facade admits or delays that pressure window.
## Existing attack coroutines still own animation/hitboxes/contact and remain unchanged.

const PRESSURE_RETRY_FLOOR: float = 0.08

# Area 1 guard propensity is pressure-responsive rather than a universal per-hit RNG.
# At full Health with an attack ready, offense remains the stronger intent. After Akio
# has already built Health/Posture pressure and the Swordsman's attack is cooling down,
# its finite guard becomes competitive enough to occasionally deny the otherwise lethal
# five-hit base-katana line. Hit six remains a pressure extension after a defended hit.
# Guard duration/cooldown still come from the response profile, so this cannot become a
# permanent blocking state or turn a normal soldier into a long solo duel.
const AREA1_GUARD_BASE_SCORE: float = 0.36
const AREA1_GUARD_POSTURE_WEIGHT: float = 0.24
const AREA1_GUARD_HEALTH_PRESSURE_WEIGHT: float = 0.62
const AREA1_GUARD_ATTACK_COOLDOWN_BONUS: float = 0.18
const AREA1_GUARD_CLOSE_BONUS: float = 0.08
const AREA1_GUARD_ALLY_ACTIVE_BONUS: float = 0.06
const AREA1_GUARD_SCORE_CAP: float = 0.98

var _v2_pressure_reservation_id: String = ""
var _v2_pressure_retry_until: float = -1.0
var _v2_pending_attack_type: int = -1


func _ready() -> void:
	super._ready()
	print("[CorruptedSwordsman] v2.7 - player-paced pressure + tactical guard")


func _v2_build_intent_scores(now: float, distance: float) -> Dictionary:
	var scores: Dictionary = super._v2_build_intent_scores(now, distance)
	if not _v2_guard_ready(now) or distance > hushiro_guard_range:
		return scores

	var posture_ratio: float = _get_humanoid_posture_ratio_safe()
	var health_pressure: float = clampf(1.0 - get_hp_ratio(), 0.0, 1.0)
	var attack_ready: bool = _v2_attack_temporally_ready(now)
	var another_enemy_active: bool = _is_another_enemy_mid_swing()

	var guard_score: float = AREA1_GUARD_BASE_SCORE
	guard_score += posture_ratio * AREA1_GUARD_POSTURE_WEIGHT
	guard_score += health_pressure * AREA1_GUARD_HEALTH_PRESSURE_WEIGHT
	if not attack_ready:
		guard_score += AREA1_GUARD_ATTACK_COOLDOWN_BONUS
	if distance <= close_combat_range:
		guard_score += AREA1_GUARD_CLOSE_BONUS
	if another_enemy_active:
		guard_score += AREA1_GUARD_ALLY_ACTIVE_BONUS
	guard_score = minf(guard_score, AREA1_GUARD_SCORE_CAP)

	# The base brain still owns all other tactical scoring. This layer only replaces
	# the Swordsman's guard score with the Area 1 pressure-sensitive version.
	scores[&"guard"] = guard_score
	return scores


func area1_guard_score_for_test(now: float, distance: float) -> float:
	var scores: Dictionary = _v2_build_intent_scores(now, distance)
	return float(scores.get(&"guard", -INF))


func _can_attack_now(now: float) -> bool:
	# Phase 4 deliberately bypasses the inherited legacy melee token. The actual room
	# admission decision occurs after an attack has been selected, because the pressure
	# director needs that attack's predicted impact timing/severity.
	if not _v2_attack_temporally_ready(now):
		return false
	return now >= _v2_pressure_retry_until


func _try_attack() -> void:
	var now: float = Time.get_ticks_msec() * 0.001
	if not _can_attack_now(now):
		return

	var attack_choice: int = _v2_pending_attack_type
	if attack_choice < 0:
		attack_choice = _select_attack_type()

	var admission: Dictionary = _request_v2_pressure_for_attack(attack_choice, now, false)
	if not bool(admission.get("admitted", false)):
		_v2_pending_attack_type = attack_choice
		_v2_pressure_retry_until = maxf(now + PRESSURE_RETRY_FLOOR, float(admission.get("retry_at", now + PRESSURE_RETRY_FLOOR)))
		if _v2_enemy_brain != null and is_instance_valid(_v2_enemy_brain):
			_v2_enemy_brain.request_immediate_reconsideration()
		return

	_v2_pending_attack_type = -1
	_v2_pressure_retry_until = -1.0
	_v2_pressure_reservation_id = str(admission.get("reservation_id", ""))
	_current_attack_type = attack_choice
	_commitment_until = now + commitment_duration

	match _current_attack_type:
		AttackType.BASIC_SWING:
			_start_basic_swing()
		AttackType.QUICK_THRUST:
			_start_quick_thrust()
		AttackType.CROSS_SWING:
			_start_cross_swing()
		AttackType.RUNNING_SWING:
			_start_running_swing()
		_:
			_start_custom_attack(_current_attack_type)

	_switch_state(AIState.ATTACK)


func _start_humanoid_counter_attack(counter_kind: String) -> void:
	# Guard counters previously re-entered the legacy token API through a separate path.
	# Keep their authored timing/attack choice but reserve room pressure consistently.
	if is_attacking or telegraphing or swinging or _dbroken_active:
		return
	var now: float = Time.get_ticks_msec() * 0.001
	if now < stunned_until:
		return

	var attack_choice: int = AttackType.BASIC_SWING
	if counter_kind == "thrust_poke":
		attack_choice = AttackType.QUICK_THRUST

	var admission: Dictionary = _request_v2_pressure_for_attack(attack_choice, now, true)
	if not bool(admission.get("admitted", false)):
		return

	_v2_pressure_reservation_id = str(admission.get("reservation_id", ""))
	_v2_pressure_retry_until = -1.0
	set_meta("_humanoid_counter_cd_until", now + humanoid_counter_cooldown)
	next_swipe_time = now + followup_delay + 0.30
	_current_attack_type = attack_choice
	_commitment_until = now + commitment_duration

	if attack_choice == AttackType.QUICK_THRUST:
		_start_quick_thrust()
	else:
		_start_basic_swing()
	_switch_state(AIState.ATTACK)


func _request_v2_pressure_for_attack(attack_choice: int, now: float, is_counter: bool) -> Dictionary:
	var director: Node = get_attack_director()
	if director == null or not director.has_method("request_pressure_threat"):
		# Safe compatibility fallback for unusual test scenes or old bootstraps. Production
		# AttackDir owns PressureDirectorV2, but do not leave the enemy inert if absent.
		if _request_attack_token():
			return {"admitted": true, "reservation_id": "legacy_token", "impact_at": now}
		return {"admitted": false, "retry_at": now + 0.12, "reason": "legacy_fallback_denied"}

	var request: Dictionary = _v2_pressure_request_for_attack(attack_choice, now, is_counter)
	var value: Variant = director.call("request_pressure_threat", self, request)
	if value is Dictionary:
		return value as Dictionary
	return {"admitted": false, "retry_at": now + 0.12, "reason": "invalid_pressure_response"}


func _v2_pressure_request_for_attack(attack_choice: int, now: float, is_counter: bool) -> Dictionary:
	var attack_id: String = "basic_swing"
	var impact_delay: float = maxf(0.10, telegraph_time)
	var active_duration: float = maxf(0.04, active_window)
	var severity: String = "normal"
	var threat_cost: float = 1.0

	match attack_choice:
		AttackType.QUICK_THRUST:
			attack_id = "quick_thrust"
			impact_delay = maxf(0.10, thrust_telegraph_time)
			active_duration = maxf(active_window, thrust_lunge_time + 0.08)
			severity = "perilous"
			threat_cost = 1.50
		AttackType.CROSS_SWING:
			attack_id = "cross_swing"
			impact_delay = maxf(0.10, cross_telegraph_time)
			active_duration = maxf(active_window, 0.24)
			severity = "normal"
			threat_cost = 1.10
		AttackType.RUNNING_SWING:
			attack_id = "running_swing"
			impact_delay = maxf(0.10, _calculate_approach_time() + running_telegraph_time)
			active_duration = maxf(active_window, 0.18)
			severity = "heavy"
			threat_cost = 1.30
		_:
			pass

	if is_counter:
		attack_id += "_counter"
		threat_cost += 0.05

	return {
		"attack_id": attack_id,
		"requested_at": now,
		"impact_at": now + impact_delay,
		"impact_delay": impact_delay,
		"active_duration": active_duration,
		"severity": severity,
		"threat_cost": threat_cost,
	}


func _release_v2_pressure(reason: String) -> void:
	var reservation_id: String = _v2_pressure_reservation_id
	_v2_pressure_reservation_id = ""
	_v2_pending_attack_type = -1
	if reservation_id.is_empty():
		return
	if reservation_id == "legacy_token":
		_release_attack_token()
		return
	var director: Node = get_attack_director()
	if director != null and director.has_method("release_pressure_threat"):
		director.call("release_pressure_threat", self, reservation_id, reason)


func _finish_attack() -> void:
	_release_v2_pressure("completed")
	super._finish_attack()


func _cancel_attack() -> void:
	_release_v2_pressure("cancelled")
	super._cancel_attack()


func _soft_reset_humanoid_attack_runtime() -> void:
	_release_v2_pressure("soft_reset")
	super._soft_reset_humanoid_attack_runtime()


func _full_reset_humanoid_attack_runtime() -> void:
	_release_v2_pressure("full_reset")
	super._full_reset_humanoid_attack_runtime()


func _exit_tree() -> void:
	_release_v2_pressure("exit_tree")
	super._exit_tree()


func has_v2_pressure_runtime() -> bool:
	var director: Node = get_attack_director()
	return director != null and director.has_method("request_pressure_threat") and director.has_method("release_pressure_threat")


func has_v2_pressure_reservation() -> bool:
	if _v2_pressure_reservation_id.is_empty():
		return false
	if _v2_pressure_reservation_id == "legacy_token":
		return has_attack_token
	var director: Node = get_attack_director()
	if director != null and director.has_method("has_pressure_reservation"):
		return bool(director.call("has_pressure_reservation", self))
	return false
