extends RefCounted
class_name CombatTelemetryDiagnostics

## Small stateful reducer for objective playtest diagnostics.
##
## CombatTelemetry owns file I/O. This helper only observes already-authored telemetry
## events and builds a compact end-of-session summary, so diagnostic reporting cannot
## alter combat state, timing, targeting, or damage resolution.

var _contract_application_counts: Dictionary = {}
var _contract_application_events: int = 0
var _contract_forced_application_events: int = 0
var _contract_unexpected_duplicate_events: int = 0

var _brain_invalidation_counts: Dictionary = {}
var _brain_invalidation_reason_counts: Dictionary = {}
var _brain_invalidation_events: int = 0

var _poise_absorption_profile_counts: Dictionary = {}
var _poise_absorption_events: int = 0


func reset() -> void:
	_contract_application_counts.clear()
	_contract_application_events = 0
	_contract_forced_application_events = 0
	_contract_unexpected_duplicate_events = 0
	_brain_invalidation_counts.clear()
	_brain_invalidation_reason_counts.clear()
	_brain_invalidation_events = 0
	_poise_absorption_profile_counts.clear()
	_poise_absorption_events = 0


func observe(event_name: String, data: Dictionary) -> void:
	match event_name:
		"hushiro_enemy_contract_applied":
			_observe_contract_application(data)
		"enemy_v2_brain_intent_invalidated":
			_observe_brain_invalidation(data)
		"enemy_v2_hit_absorbed_by_poise":
			_observe_poise_absorption(data)


func snapshot() -> Dictionary:
	return {
		"hushiro_contract": {
			"application_events": _contract_application_events,
			"unique_enemy_count": _contract_application_counts.size(),
			"forced_application_events": _contract_forced_application_events,
			"unexpected_duplicate_application_events": _contract_unexpected_duplicate_events,
			"max_applications_per_enemy": _max_count(_contract_application_counts),
		},
		"brain_invalidation": {
			"total_events": _brain_invalidation_events,
			"deaggro_events": int(_brain_invalidation_reason_counts.get("deaggro", 0)),
			"unique_enemy_count": _brain_invalidation_counts.size(),
			"max_events_per_enemy": _max_count(_brain_invalidation_counts),
			"reason_counts": _brain_invalidation_reason_counts.duplicate(true),
		},
		"poise_absorption": {
			"total_events": _poise_absorption_events,
			"profile_counts": _poise_absorption_profile_counts.duplicate(true),
		},
	}


func _observe_contract_application(data: Dictionary) -> void:
	_contract_application_events += 1
	var forced: bool = bool(data.get("forced", false))
	if forced:
		_contract_forced_application_events += 1

	var enemy_id: int = int(data.get("enemy_id", -1))
	if enemy_id < 0:
		return
	var key: String = str(enemy_id)
	var previous: int = int(_contract_application_counts.get(key, 0))
	_contract_application_counts[key] = previous + 1
	# A repeated forced application is an explicit caller request. The suspicious case
	# is a second ordinary install for the same actor, which PR #183 made unreachable.
	if not forced and previous > 0:
		_contract_unexpected_duplicate_events += 1


func _observe_brain_invalidation(data: Dictionary) -> void:
	_brain_invalidation_events += 1
	var reason: String = str(data.get("reason", "unspecified"))
	_brain_invalidation_reason_counts[reason] = int(_brain_invalidation_reason_counts.get(reason, 0)) + 1

	var enemy_value: Variant = data.get("enemy", {})
	if not (enemy_value is Dictionary):
		return
	var enemy: Dictionary = enemy_value as Dictionary
	var enemy_id: int = int(enemy.get("id", -1))
	if enemy_id < 0:
		return
	var key: String = str(enemy_id)
	_brain_invalidation_counts[key] = int(_brain_invalidation_counts.get(key, 0)) + 1


func _observe_poise_absorption(data: Dictionary) -> void:
	_poise_absorption_events += 1
	var profile: String = str(data.get("profile", "unspecified"))
	_poise_absorption_profile_counts[profile] = int(_poise_absorption_profile_counts.get(profile, 0)) + 1


func _max_count(counts: Dictionary) -> int:
	var result: int = 0
	for value: Variant in counts.values():
		result = maxi(result, int(value))
	return result
