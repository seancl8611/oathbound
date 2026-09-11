extends Node
class_name EnemyCombatResponseRuntime

## Combat V2 reaction/guard component. It resolves authoring policy only; the owning
## enemy remains responsible for applying Health/Posture mutations and animation.
## This lets V1 enemies migrate package-by-package without creating a second damage pass.

var enemy: Node = null
var profile: EnemyCombatResponseProfile = null

var _guard_active: bool = false
var _guard_until: float = -1.0
var _guard_cooldown_until: float = -1.0


func configure(owner_enemy: Node, response_profile: EnemyCombatResponseProfile) -> void:
	enemy = owner_enemy
	profile = response_profile
	_record("enemy_v2_response_attached", {
		"profile": profile.profile_id if profile != null else "none",
	})


func tick_guard(now: float, wants_guard: bool) -> bool:
	if profile == null:
		return false

	if _guard_active:
		if not wants_guard or now >= _guard_until:
			_end_guard(now, profile.guard_cooldown, "expired" if now >= _guard_until else "cancelled")
		return _guard_active

	if not wants_guard or now < _guard_cooldown_until:
		return false

	_guard_active = true
	_guard_until = now + maxf(0.05, profile.guard_duration)
	_record("enemy_v2_guard_started", {
		"profile": profile.profile_id,
		"duration": profile.guard_duration,
		"cooldown_ready_at": _guard_cooldown_until,
	})
	return true


func force_guard_off(now: float, cooldown: float = -1.0, reason: String = "forced") -> void:
	if profile == null:
		_guard_active = false
		_guard_until = -1.0
		return
	var resolved_cooldown: float = profile.guard_cooldown if cooldown < 0.0 else cooldown
	_end_guard(now, resolved_cooldown, reason)


func decorate_guard_response(base_response: Dictionary) -> Dictionary:
	var response: Dictionary = base_response.duplicate(true)
	if profile == null:
		return response
	response["posture_on_block"] = maxf(0.0, float(response.get("posture_on_block", 0.0))) * profile.guard_posture_multiplier
	response["v2_guard_health_multiplier"] = profile.guard_health_multiplier
	return response


func guarded_health_damage(raw_damage: int) -> int:
	if profile == null:
		return 0
	return maxi(0, int(round(float(raw_damage) * clampf(profile.guard_health_multiplier, 0.0, 1.0))))


func incoming_poise_power(attacker: Variant, response: Dictionary = {}) -> int:
	var source: Object = _resolve_attack_event_source(attacker)
	if source != null:
		if source.has_meta("poise_damage"):
			return maxi(0, int(source.get_meta("poise_damage")))
		if source.has_meta("stagger_level"):
			# V2 migration bridge: canonical V1 attacks already publish stagger_level.
			# Until action profiles explicitly author poise_damage, level 0 maps to power 1
			# and level 1 maps to power 2. Health/Posture remain otherwise untouched.
			return maxi(1, int(source.get_meta("stagger_level")) + 1)
	if bool(response.get("heavy", false)):
		return 2
	return 1


func should_interrupt(attacker: Variant, response: Dictionary, committed: bool) -> bool:
	if profile == null:
		return true
	var required: int = profile.committed_poise_required if committed else profile.neutral_poise_required
	var power: int = incoming_poise_power(attacker, response)
	var allowed: bool = power >= maxi(1, required)
	_record("enemy_v2_poise_resolution", {
		"profile": profile.profile_id,
		"committed": committed,
		"incoming_power": power,
		"required_power": required,
		"interrupt": allowed,
	})
	return allowed


func on_guard_contact(now: float, attacker: Variant, response: Dictionary) -> bool:
	if not _guard_active or profile == null:
		return false
	var power: int = incoming_poise_power(attacker, response)
	if power < maxi(1, profile.guard_break_poise_required):
		return false
	_end_guard(now, profile.guard_break_cooldown, "broken")
	_record("enemy_v2_guard_broken", {
		"profile": profile.profile_id,
		"incoming_power": power,
		"required_power": profile.guard_break_poise_required,
	})
	return true


func is_guard_active() -> bool:
	return _guard_active


func guard_cooldown_remaining(now: float) -> float:
	return maxf(0.0, _guard_cooldown_until - now)


func _resolve_attack_event_source(attacker: Variant) -> Object:
	# Live HurtBox canonical events emit the resolved attacker (usually Player), while
	# the attack Area2D carrying stagger/poise metadata remains cached on the receiver.
	# Prefer that exact attack area when available so direct and live contacts resolve
	# identical poise power.
	if enemy != null and is_instance_valid(enemy) and enemy.has_method("get_last_attack_area"):
		var cached_value: Variant = enemy.call("get_last_attack_area")
		if cached_value != null and is_instance_valid(cached_value) and cached_value is Object:
			return cached_value as Object
	if attacker != null and is_instance_valid(attacker) and attacker is Object:
		return attacker as Object
	return null


func _end_guard(now: float, cooldown: float, reason: String) -> void:
	if not _guard_active:
		return
	_guard_active = false
	_guard_until = -1.0
	_guard_cooldown_until = maxf(_guard_cooldown_until, now + maxf(0.0, cooldown))
	_record("enemy_v2_guard_ended", {
		"profile": profile.profile_id if profile != null else "none",
		"reason": reason,
		"cooldown": maxf(0.0, cooldown),
	})


func _record(event_name: String, extra: Dictionary = {}) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = extra.duplicate(true)
	if enemy != null and is_instance_valid(enemy):
		payload["enemy"] = CombatTelemetry.snapshot_actor(enemy)
	CombatTelemetry.record_event(event_name, payload)
