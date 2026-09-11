extends Node
class_name EnemyBrain

## Combat V2 tactical-intent cadence component.
##
## The brain does not move the actor, execute attacks, own hitboxes, or mutate combat
## resources. The owning enemy publishes scored candidate intents; this component
## chooses and holds one at controlled decision boundaries so tactical behavior is not
## re-rolled every physics frame.

var actor: Node = null
var decision_interval: float = 0.18
var minimum_intent_hold: float = 0.12
var current_intent_bias: float = 0.08

var _current_intent: StringName = &"idle"
var _intent_started_at: float = -1.0
var _next_decision_at: float = -1.0
var _decision_serial: int = 0
var _last_scores: Dictionary = {}


func configure(
	owner_actor: Node,
	interval: float = 0.18,
	minimum_hold: float = 0.12,
	stickiness_bias: float = 0.08
) -> void:
	actor = owner_actor
	decision_interval = maxf(0.05, interval)
	minimum_intent_hold = maxf(0.0, minimum_hold)
	current_intent_bias = maxf(0.0, stickiness_bias)
	_next_decision_at = -1.0
	_intent_started_at = -1.0
	_record("enemy_v2_brain_attached", {
		"decision_interval": decision_interval,
		"minimum_intent_hold": minimum_intent_hold,
	})


func choose_intent(now: float, candidate_scores: Dictionary, force: bool = false) -> StringName:
	if candidate_scores.is_empty():
		set_intent(&"idle", now, "no_candidates")
		return _current_intent

	# Keep the current intent between decision boundaries. This is the central V2
	# guarantee: scoring may be computed every frame by the owner, but selection does
	# not churn or re-roll every frame.
	if not force:
		if now < _next_decision_at:
			return _current_intent
		if _intent_started_at >= 0.0 and now - _intent_started_at < minimum_intent_hold:
			_next_decision_at = maxf(_next_decision_at, _intent_started_at + minimum_intent_hold)
			return _current_intent

	_decision_serial += 1
	_last_scores = candidate_scores.duplicate(true)

	var best_intent: StringName = &"idle"
	var best_score: float = -INF
	for key: Variant in candidate_scores.keys():
		var intent := StringName(str(key))
		var score: float = float(candidate_scores.get(key, -INF))
		if intent == _current_intent:
			score += current_intent_bias
		if score > best_score:
			best_score = score
			best_intent = intent

	if best_score == -INF:
		best_intent = &"idle"

	var changed: bool = best_intent != _current_intent
	if changed:
		_current_intent = best_intent
		_intent_started_at = now
	elif _intent_started_at < 0.0:
		_intent_started_at = now

	_next_decision_at = now + decision_interval
	_record("enemy_v2_brain_decision", {
		"intent": str(_current_intent),
		"changed": changed,
		"decision_serial": _decision_serial,
		"scores": _last_scores,
	})
	return _current_intent


func set_intent(intent: StringName, now: float, reason: String = "forced") -> void:
	var changed: bool = intent != _current_intent
	_current_intent = intent
	_intent_started_at = now
	_next_decision_at = now + decision_interval
	_record("enemy_v2_brain_intent_forced", {
		"intent": str(intent),
		"changed": changed,
		"reason": reason,
	})


func request_immediate_reconsideration() -> void:
	_next_decision_at = -1.0


func invalidate_intent(reason: String = "invalidated") -> void:
	var now: float = Time.get_ticks_msec() * 0.001
	_current_intent = &"idle"
	_intent_started_at = now
	_next_decision_at = -1.0
	_record("enemy_v2_brain_intent_invalidated", {"reason": reason})


func current_intent() -> StringName:
	return _current_intent


func next_decision_at() -> float:
	return _next_decision_at


func last_scores() -> Dictionary:
	return _last_scores.duplicate(true)


func _record(event_name: String, extra: Dictionary = {}) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = extra.duplicate(true)
	if actor != null and is_instance_valid(actor):
		payload["enemy"] = CombatTelemetry.snapshot_actor(actor)
	CombatTelemetry.record_event(event_name, payload)
