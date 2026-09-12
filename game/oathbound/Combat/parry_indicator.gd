extends Node2D

## Shared player-facing enemy attack cue.
##
## Combat V2 close-pressure enemies already reserve an absolute predicted impact time
## through PressureDirectorV2. When such a reservation exists, this cue consumes that
## timing directly instead of reverse-engineering a controller-specific duration:
## - warning diamond appears 0.20 s before predicted contact
## - fixed inner mark appears 0.12 s before contact, matching Akio's perfect parry window
## - cue disappears at predicted contact; there is no post-contact V2 pulse
##
## Non-V2 / non-frontline attacks retain the existing phase-driven compatibility path.
## This deliberately keeps later regions and legacy special attacks stable while Hushiro
## migrates presentation onto explicit current combat ownership.

const NORMAL_COLOR := Color(1.0, 0.93, 0.62, 1.0)
const NORMAL_OUTLINE := Color(0.25, 0.20, 0.10, 0.95)
const PERILOUS_COLOR := Color(1.0, 0.20, 0.12, 1.0)
const PERILOUS_OUTLINE := Color(0.38, 0.04, 0.03, 0.98)
const ACTIVE_COLOR := Color(1.0, 1.0, 1.0, 1.0)
const ACTIVE_PULSE_SECONDS := 0.14
const MIN_WARNING_SECONDS := 0.06

const V2_WARNING_LEAD_SECONDS: float = 0.20
const V2_PARRY_BEAT_LEAD_SECONDS: float = 0.12
const META_FRONTLINE_PRESSURE_BODY: StringName = &"oathbound_frontline_pressure_body"

var _diamond: Polygon2D = null
var _outline: Polygon2D = null
var _ring: Line2D = null
var _inner_mark: Polygon2D = null
var _cue_tween: Tween = null

var _armed: bool = false
var _is_unblockable: bool = false
var _fallback_ready_at: float = 0.0
var _fallback_hide_at: float = 0.0
var _seen_windup: bool = false
var _seen_active: bool = false

var _v2_contact_timed: bool = false
var _v2_contact_at: float = -1.0

var _has_combat_phase: bool = false
var _has_telegraphing: bool = false
var _has_swinging: bool = false
var _has_is_attacking: bool = false
var _has_attack_recovery: bool = false


func _ready() -> void:
	position = Vector2(0.0, -45.0)
	z_index = 150
	visible = false
	_build_visuals()
	_cache_owner_contract()
	set_process(true)


func warn_attack(duration: float, is_unblockable: bool = false) -> void:
	var now: float = Time.get_ticks_msec() * 0.001
	var v2_impact_at: float = _resolve_v2_pressure_impact_at(now)
	if v2_impact_at > now:
		_warn_v2_until_contact(v2_impact_at, is_unblockable, now)
		return

	# Compatibility path for non-migrated, non-frontline, follow-up, and special attacks.
	_v2_contact_timed = false
	_v2_contact_at = -1.0
	_set_inner_mark_visible(false)
	_is_unblockable = is_unblockable
	_armed = true
	_seen_windup = false
	_seen_active = false
	_fallback_ready_at = now + maxf(MIN_WARNING_SECONDS, duration)
	_fallback_hide_at = 0.0
	visible = true
	modulate.a = 1.0
	_set_warning_colors()
	scale = Vector2(1.55, 1.55)

	_kill_cue_tween()
	_cue_tween = create_tween()
	_cue_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_cue_tween.tween_property(self, "scale", Vector2(0.92, 0.92), maxf(MIN_WARNING_SECONDS, duration))


func _warn_v2_until_contact(impact_at: float, is_unblockable: bool, now: float) -> void:
	_v2_contact_timed = true
	_v2_contact_at = impact_at
	_is_unblockable = is_unblockable
	_armed = true
	_seen_windup = true
	_seen_active = false
	_fallback_ready_at = 0.0
	_fallback_hide_at = 0.0
	_kill_cue_tween()
	scale = Vector2.ONE
	modulate.a = 1.0
	_set_warning_colors()
	_apply_v2_contact_state(impact_at - now)
	_record_v2_cue(impact_at)


func hide_now() -> void:
	_armed = false
	_seen_windup = false
	_seen_active = false
	_fallback_ready_at = 0.0
	_fallback_hide_at = 0.0
	_v2_contact_timed = false
	_v2_contact_at = -1.0
	_kill_cue_tween()
	visible = false
	_set_inner_mark_visible(false)
	scale = Vector2.ONE
	modulate.a = 1.0


func _process(_delta: float) -> void:
	if not _armed:
		return

	var now: float = Time.get_ticks_msec() * 0.001
	if _v2_contact_timed:
		_apply_v2_contact_state(_v2_contact_at - now)
		return

	if not visible:
		return

	if _has_combat_phase:
		var phase: int = int(get_parent().get("_combat_phase"))
		match phase:
			1: # WINDUP
				_seen_windup = true
				return
			2: # ACTIVE
				if not _seen_active:
					_pulse_active(now)
				return
			3: # RECOVERY
				hide_now()
				return
			0: # NONE
				if _seen_windup or _seen_active:
					hide_now()
					return

	if _has_telegraphing or _has_swinging or _has_is_attacking:
		var winding: bool = _read_owner_bool("telegraphing") if _has_telegraphing else false
		var swinging_now: bool = _read_owner_bool("swinging") if _has_swinging else false
		var attacking_now: bool = _read_owner_bool("is_attacking") if _has_is_attacking else false
		var recovering: bool = _read_owner_bool("_attack_recovery") if _has_attack_recovery else false
		var active_now: bool = swinging_now or (attacking_now and not winding and not recovering)

		if winding:
			_seen_windup = true
			return
		if active_now:
			if not _seen_active:
				_pulse_active(now)
			return
		if recovering or ((_seen_windup or _seen_active) and not attacking_now):
			hide_now()
			return

	# Special legacy attacks do not always expose a combat phase. Keep those readable
	# without forcing their state machines through Combat V2.
	if not _seen_active and now >= _fallback_ready_at:
		_pulse_active(now)
	if _seen_active and _fallback_hide_at > 0.0 and now >= _fallback_hide_at:
		hide_now()


func _resolve_v2_pressure_impact_at(now: float) -> float:
	var owner: Node = get_parent()
	if owner == null or not is_instance_valid(owner):
		return -1.0
	if not owner.has_meta(META_FRONTLINE_PRESSURE_BODY) or not bool(owner.get_meta(META_FRONTLINE_PRESSURE_BODY)):
		return -1.0

	var director: Node = get_node_or_null("/root/AttackDir")
	if director == null or not director.has_method("snapshot_pressure_reservations"):
		return -1.0
	var reservations_value: Variant = director.call("snapshot_pressure_reservations")
	if not (reservations_value is Array):
		return -1.0

	for reservation_value: Variant in reservations_value as Array:
		if not (reservation_value is Dictionary):
			continue
		var reservation: Dictionary = reservation_value as Dictionary
		if int(reservation.get("enemy_id", -1)) != owner.get_instance_id():
			continue
		var impact_at: float = float(reservation.get("impact_at", -1.0))
		# A multi-hit follow-up can reuse the same whole-action reservation after its first
		# predicted impact. Never rewind the cue to a timestamp that already passed;
		# follow-ups stay on their existing authored/phase compatibility presentation.
		if impact_at > now + 0.001:
			return impact_at
	return -1.0


func _apply_v2_contact_state(remaining: float) -> void:
	var state: Dictionary = _v2_state_for_remaining(remaining)
	if bool(state.get("expired", false)):
		hide_now()
		return
	visible = bool(state.get("warning", false))
	_set_inner_mark_visible(bool(state.get("parry_beat", false)))
	scale = Vector2.ONE
	modulate.a = 1.0


func _v2_state_for_remaining(remaining: float) -> Dictionary:
	var positive: bool = remaining > 0.0
	return {
		"expired": not positive,
		"warning": positive and remaining <= V2_WARNING_LEAD_SECONDS,
		"parry_beat": positive and remaining <= V2_PARRY_BEAT_LEAD_SECONDS,
	}


func counter_cue_state_for_remaining_for_test(remaining: float) -> Dictionary:
	return _v2_state_for_remaining(remaining)


func uses_v2_pressure_timing_for_test() -> bool:
	return _v2_contact_timed


func v2_contact_at_for_test() -> float:
	return _v2_contact_at


func _pulse_active(now: float) -> void:
	_seen_active = true
	_fallback_hide_at = now + ACTIVE_PULSE_SECONDS
	_set_inner_mark_visible(false)
	_kill_cue_tween()
	if _diamond != null:
		_diamond.color = ACTIVE_COLOR
	if _ring != null:
		_ring.default_color = ACTIVE_COLOR
	if _outline != null:
		_outline.color = PERILOUS_OUTLINE if _is_unblockable else NORMAL_OUTLINE
	scale = Vector2(0.82, 0.82)
	_cue_tween = create_tween()
	_cue_tween.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	_cue_tween.tween_property(self, "scale", Vector2(1.28, 1.28), 0.07)
	_cue_tween.tween_property(self, "scale", Vector2.ONE, 0.07)


func _build_visuals() -> void:
	_outline = Polygon2D.new()
	_outline.polygon = _diamond_points(14.0)
	_outline.color = NORMAL_OUTLINE
	_outline.z_index = -1
	add_child(_outline)

	_diamond = Polygon2D.new()
	_diamond.polygon = _diamond_points(10.5)
	_diamond.color = NORMAL_COLOR
	add_child(_diamond)

	_inner_mark = Polygon2D.new()
	_inner_mark.polygon = _diamond_points(4.5)
	_inner_mark.color = ACTIVE_COLOR
	_inner_mark.z_index = 1
	_inner_mark.visible = false
	add_child(_inner_mark)

	_ring = Line2D.new()
	_ring.width = 2.0
	_ring.default_color = NORMAL_COLOR
	var ring_points := PackedVector2Array()
	for i in range(17):
		var angle: float = TAU * float(i) / 16.0
		ring_points.append(Vector2(cos(angle), sin(angle)) * 18.0)
	_ring.points = ring_points
	_ring.z_index = -2
	add_child(_ring)


func _diamond_points(size: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(0.0, -size),
		Vector2(size * 0.62, 0.0),
		Vector2(0.0, size),
		Vector2(-size * 0.62, 0.0),
	])


func _set_warning_colors() -> void:
	var main_color: Color = PERILOUS_COLOR if _is_unblockable else NORMAL_COLOR
	var outline_color: Color = PERILOUS_OUTLINE if _is_unblockable else NORMAL_OUTLINE
	if _diamond != null:
		_diamond.color = main_color
	if _ring != null:
		_ring.default_color = main_color
	if _outline != null:
		_outline.color = outline_color
	if _inner_mark != null:
		_inner_mark.color = ACTIVE_COLOR


func _set_inner_mark_visible(value: bool) -> void:
	if _inner_mark != null:
		_inner_mark.visible = value


func _cache_owner_contract() -> void:
	var owner: Object = get_parent()
	if owner == null:
		return
	_has_combat_phase = _object_has_property(owner, "_combat_phase")
	_has_telegraphing = _object_has_property(owner, "telegraphing")
	_has_swinging = _object_has_property(owner, "swinging")
	_has_is_attacking = _object_has_property(owner, "is_attacking")
	_has_attack_recovery = _object_has_property(owner, "_attack_recovery")


func _object_has_property(object: Object, property_name: String) -> bool:
	for property_value: Dictionary in object.get_property_list():
		if String(property_value.get("name", "")) == property_name:
			return true
	return false


func _read_owner_bool(property_name: String) -> bool:
	var owner: Object = get_parent()
	if owner == null:
		return false
	return bool(owner.get(property_name))


func _record_v2_cue(impact_at: float) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var owner: Node = get_parent()
	var payload: Dictionary = {
		"impact_at": impact_at,
		"warning_lead": V2_WARNING_LEAD_SECONDS,
		"parry_beat_lead": V2_PARRY_BEAT_LEAD_SECONDS,
	}
	if owner != null and is_instance_valid(owner):
		payload["enemy"] = CombatTelemetry.snapshot_actor(owner)
	CombatTelemetry.record_event("enemy_v2_counter_cue_armed", payload)


func _kill_cue_tween() -> void:
	if _cue_tween != null and _cue_tween.is_valid():
		_cue_tween.kill()
	_cue_tween = null
