extends Node
class_name PressureDirectorV2

## Combat V2 room-fairness coordinator.
##
## Unlike the legacy AttackDirector, this runtime does not grant an enemy an entire
## melee turn. It reserves predicted dangerous impact windows. Multiple enemies may
## approach, aim, and wind up together when their damaging windows remain readable.
## EnemyBrain still chooses attacks; this class only admits or delays room pressure.

@export_group("Impact Spacing")
@export var normal_spacing: float = 0.24
@export var heavy_spacing: float = 0.34
@export var perilous_spacing: float = 0.44

@export_group("Pressure Budget")
@export var budget_window: float = 0.22
@export var max_near_impact_cost: float = 2.0
@export var stale_reservation_grace: float = 1.0

var _reservations: Dictionary = {}
var _next_serial: int = 1


func request_threat(who: Node, request: Dictionary) -> Dictionary:
	var now: float = Time.get_ticks_msec() * 0.001
	_cleanup(now)
	if who == null or not is_instance_valid(who):
		return _denied(now, now + 0.10, "invalid_enemy")

	var existing: Dictionary = _reservation_for(who)
	if not existing.is_empty():
		return {
			"admitted": true,
			"reservation_id": str(existing.get("reservation_id", "")),
			"impact_at": float(existing.get("impact_at", now)),
			"existing": true,
		}

	var attack_id: String = str(request.get("attack_id", "attack"))
	var severity: String = _normalized_severity(str(request.get("severity", "normal")))
	var impact_delay: float = maxf(0.01, float(request.get("impact_delay", 0.25)))
	var impact_at: float = maxf(now + 0.01, float(request.get("impact_at", now + impact_delay)))
	var active_duration: float = maxf(0.01, float(request.get("active_duration", 0.16)))
	var threat_cost: float = maxf(0.0, float(request.get("threat_cost", _default_cost(severity))))
	var spacing: float = _spacing_for(severity)
	var retry_at: float = now
	var conflict_reason: String = ""

	for reservation_value: Variant in _reservations.values():
		if not (reservation_value is Dictionary):
			continue
		var other: Dictionary = reservation_value as Dictionary
		var other_impact: float = float(other.get("impact_at", now))
		var other_severity: String = str(other.get("severity", "normal"))
		var required_spacing: float = maxf(spacing, _spacing_for(other_severity))
		if absf(impact_at - other_impact) < required_spacing:
			conflict_reason = "impact_spacing"
			retry_at = maxf(retry_at, other_impact + required_spacing - impact_delay)

	var near_cost: float = threat_cost
	for reservation_value: Variant in _reservations.values():
		if not (reservation_value is Dictionary):
			continue
		var other: Dictionary = reservation_value as Dictionary
		if absf(impact_at - float(other.get("impact_at", now))) <= budget_window:
			near_cost += float(other.get("threat_cost", 0.0))
	if near_cost > max_near_impact_cost + 0.001:
		conflict_reason = "pressure_budget" if conflict_reason.is_empty() else conflict_reason
		var latest_near_impact: float = impact_at
		for reservation_value: Variant in _reservations.values():
			if not (reservation_value is Dictionary):
				continue
			var other: Dictionary = reservation_value as Dictionary
			var other_impact: float = float(other.get("impact_at", now))
			if absf(impact_at - other_impact) <= budget_window:
				latest_near_impact = maxf(latest_near_impact, other_impact)
		retry_at = maxf(retry_at, latest_near_impact + budget_window - impact_delay)

	_record("enemy_v2_threat_requested", who, {
		"attack_id": attack_id,
		"severity": severity,
		"impact_delay": impact_delay,
		"impact_at": impact_at,
		"threat_cost": threat_cost,
	})

	if not conflict_reason.is_empty():
		retry_at = maxf(now + 0.06, retry_at)
		_record("enemy_v2_threat_delayed", who, {
			"attack_id": attack_id,
			"severity": severity,
			"impact_at": impact_at,
			"retry_at": retry_at,
			"reason": conflict_reason,
		})
		return _denied(now, retry_at, conflict_reason)

	var reservation_id: String = "%d:%d" % [who.get_instance_id(), _next_serial]
	_next_serial += 1
	var reservation: Dictionary = {
		"reservation_id": reservation_id,
		"enemy": weakref(who),
		"enemy_id": who.get_instance_id(),
		"attack_id": attack_id,
		"severity": severity,
		"requested_at": now,
		"impact_at": impact_at,
		"active_duration": active_duration,
		"threat_cost": threat_cost,
		"expires_at": impact_at + active_duration + stale_reservation_grace,
	}
	_reservations[reservation_id] = reservation
	_record("enemy_v2_threat_admitted", who, {
		"reservation_id": reservation_id,
		"attack_id": attack_id,
		"severity": severity,
		"impact_at": impact_at,
		"active_duration": active_duration,
		"threat_cost": threat_cost,
		"concurrent_reservations": _reservations.size(),
	})
	return {
		"admitted": true,
		"reservation_id": reservation_id,
		"impact_at": impact_at,
		"existing": false,
	}


func release_threat(who: Node, reservation_id: String = "", reason: String = "completed") -> void:
	var id: String = reservation_id
	if id.is_empty() and who != null and is_instance_valid(who):
		var existing: Dictionary = _reservation_for(who)
		id = str(existing.get("reservation_id", ""))
	if id.is_empty() or not _reservations.has(id):
		return
	var reservation: Dictionary = _reservations[id]
	_reservations.erase(id)
	var owner: Node = who
	var owner_ref_value: Variant = reservation.get("enemy")
	if owner_ref_value is WeakRef:
		var resolved: Variant = (owner_ref_value as WeakRef).get_ref()
		if resolved is Node and is_instance_valid(resolved):
			owner = resolved as Node
	_record("enemy_v2_threat_released", owner, {
		"reservation_id": id,
		"attack_id": str(reservation.get("attack_id", "")),
		"reason": reason,
		"remaining_reservations": _reservations.size(),
	})


func release_all_for(who: Node, reason: String = "released_all") -> void:
	if who == null or not is_instance_valid(who):
		return
	var ids: Array[String] = []
	for id_value: Variant in _reservations.keys():
		var id: String = str(id_value)
		var reservation: Dictionary = _reservations[id]
		if int(reservation.get("enemy_id", -1)) == who.get_instance_id():
			ids.append(id)
	for id: String in ids:
		release_threat(who, id, reason)


func has_reservation(who: Node) -> bool:
	if who == null or not is_instance_valid(who):
		return false
	_cleanup(Time.get_ticks_msec() * 0.001)
	return not _reservation_for(who).is_empty()


func reservation_count() -> int:
	_cleanup(Time.get_ticks_msec() * 0.001)
	return _reservations.size()


func snapshot_reservations() -> Array[Dictionary]:
	_cleanup(Time.get_ticks_msec() * 0.001)
	var result: Array[Dictionary] = []
	for value: Variant in _reservations.values():
		if not (value is Dictionary):
			continue
		var source: Dictionary = value as Dictionary
		var item: Dictionary = source.duplicate(true)
		item.erase("enemy")
		result.append(item)
	result.sort_custom(func(a: Dictionary, b: Dictionary) -> bool:
		return float(a.get("impact_at", 0.0)) < float(b.get("impact_at", 0.0))
	)
	return result


func reset_for_test() -> void:
	_reservations.clear()
	_next_serial = 1


func _reservation_for(who: Node) -> Dictionary:
	if who == null or not is_instance_valid(who):
		return {}
	var enemy_id: int = who.get_instance_id()
	for value: Variant in _reservations.values():
		if value is Dictionary and int((value as Dictionary).get("enemy_id", -1)) == enemy_id:
			return value as Dictionary
	return {}


func _cleanup(now: float) -> void:
	var stale_ids: Array[String] = []
	for id_value: Variant in _reservations.keys():
		var id: String = str(id_value)
		var reservation: Dictionary = _reservations[id]
		var owner_ref_value: Variant = reservation.get("enemy")
		var owner: Node = null
		if owner_ref_value is WeakRef:
			var resolved: Variant = (owner_ref_value as WeakRef).get_ref()
			if resolved is Node and is_instance_valid(resolved):
				owner = resolved as Node
		var expired: bool = now >= float(reservation.get("expires_at", now))
		var dead: bool = owner == null or _node_is_dead(owner)
		if expired or dead:
			stale_ids.append(id)
	for id: String in stale_ids:
		_reservations.erase(id)


func _node_is_dead(node: Node) -> bool:
	if node.has_method("is_dead"):
		return bool(node.call("is_dead"))
	var died_value: Variant = node.get("has_died")
	return bool(died_value) if died_value != null else false


func _normalized_severity(value: String) -> String:
	var normalized: String = value.to_lower()
	if normalized in ["perilous", "heavy", "normal"]:
		return normalized
	return "normal"


func _spacing_for(severity: String) -> float:
	match _normalized_severity(severity):
		"perilous":
			return maxf(0.01, perilous_spacing)
		"heavy":
			return maxf(0.01, heavy_spacing)
		_:
			return maxf(0.01, normal_spacing)


func _default_cost(severity: String) -> float:
	match _normalized_severity(severity):
		"perilous":
			return 1.50
		"heavy":
			return 1.30
		_:
			return 1.00


func _denied(now: float, retry_at: float, reason: String) -> Dictionary:
	return {
		"admitted": false,
		"reservation_id": "",
		"retry_at": maxf(now + 0.01, retry_at),
		"reason": reason,
	}


func _record(event_name: String, who: Node, extra: Dictionary = {}) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = extra.duplicate(true)
	if who != null and is_instance_valid(who):
		payload["enemy"] = CombatTelemetry.snapshot_actor(who)
	CombatTelemetry.record_event(event_name, payload)
