extends Node

const DIAGNOSTICS_SCRIPT = preload("res://Utility/CombatTelemetryDiagnostics.gd")
const PASS_LINE := "[CombatTelemetryDiagnosticsSmoke] PASS - contract repeats | brain invalidation reasons | Poise absorption profiles | reset"


func _ready() -> void:
	var failures: Array[String] = []
	var diagnostics_value: Variant = DIAGNOSTICS_SCRIPT.new()
	if not (diagnostics_value is CombatTelemetryDiagnostics):
		failures.append("could not instantiate CombatTelemetryDiagnostics")
		_finish(failures)
		return
	var diagnostics: CombatTelemetryDiagnostics = diagnostics_value as CombatTelemetryDiagnostics

	# Two unique enemies with one repeated contract event. The reducer reports facts,
	# not policy: an intentional future force=true re-normalization would also appear as
	# a repeat, while ordinary playtest sessions after PR #183 should remain at zero.
	diagnostics.observe("hushiro_enemy_contract_applied", {"enemy_id": 101, "enemy_type": "hollow"})
	diagnostics.observe("hushiro_enemy_contract_applied", {"enemy_id": 102, "enemy_type": "hound"})
	diagnostics.observe("hushiro_enemy_contract_applied", {"enemy_id": 101, "enemy_type": "hollow"})

	# Brain invalidations retain both reason distribution and per-enemy concentration so
	# a future playtest can distinguish legitimate re-engagement cycles from frame churn.
	diagnostics.observe("enemy_v2_brain_intent_invalidated", {"reason": "deaggro", "enemy": {"id": 101}})
	diagnostics.observe("enemy_v2_brain_intent_invalidated", {"reason": "deaggro", "enemy": {"id": 101}})
	diagnostics.observe("enemy_v2_brain_intent_invalidated", {"reason": "pressure_revoked", "enemy": {"id": 102}})

	# Protected-commitment evidence is summarized by authored response profile without
	# interpreting it as a balance verdict.
	diagnostics.observe("enemy_v2_hit_absorbed_by_poise", {"profile": "swordsman_v2"})
	diagnostics.observe("enemy_v2_hit_absorbed_by_poise", {"profile": "swordsman_v2"})
	diagnostics.observe("enemy_v2_hit_absorbed_by_poise", {"profile": "warden_v2"})

	var snapshot: Dictionary = diagnostics.snapshot()
	var contract: Dictionary = snapshot.get("hushiro_contract", {}) as Dictionary
	_expect(int(contract.get("application_events", -1)) == 3, "contract application event count is wrong", failures)
	_expect(int(contract.get("unique_enemy_count", -1)) == 2, "contract unique-enemy count is wrong", failures)
	_expect(int(contract.get("repeat_application_events", -1)) == 1, "contract repeat count is wrong", failures)
	_expect(int(contract.get("max_applications_per_enemy", -1)) == 2, "contract per-enemy max is wrong", failures)

	var brain: Dictionary = snapshot.get("brain_invalidation", {}) as Dictionary
	_expect(int(brain.get("total_events", -1)) == 3, "brain invalidation total is wrong", failures)
	_expect(int(brain.get("deaggro_events", -1)) == 2, "deaggro invalidation count is wrong", failures)
	_expect(int(brain.get("unique_enemy_count", -1)) == 2, "brain invalidation unique-enemy count is wrong", failures)
	_expect(int(brain.get("max_events_per_enemy", -1)) == 2, "brain invalidation per-enemy max is wrong", failures)
	var reason_counts: Dictionary = brain.get("reason_counts", {}) as Dictionary
	_expect(int(reason_counts.get("deaggro", -1)) == 2, "deaggro reason distribution is wrong", failures)
	_expect(int(reason_counts.get("pressure_revoked", -1)) == 1, "secondary invalidation reason was lost", failures)

	var poise: Dictionary = snapshot.get("poise_absorption", {}) as Dictionary
	_expect(int(poise.get("total_events", -1)) == 3, "Poise absorption total is wrong", failures)
	var profile_counts: Dictionary = poise.get("profile_counts", {}) as Dictionary
	_expect(int(profile_counts.get("swordsman_v2", -1)) == 2, "Swordsman Poise profile count is wrong", failures)
	_expect(int(profile_counts.get("warden_v2", -1)) == 1, "Warden Poise profile count is wrong", failures)

	diagnostics.reset()
	var reset_snapshot: Dictionary = diagnostics.snapshot()
	var reset_contract: Dictionary = reset_snapshot.get("hushiro_contract", {}) as Dictionary
	var reset_brain: Dictionary = reset_snapshot.get("brain_invalidation", {}) as Dictionary
	var reset_poise: Dictionary = reset_snapshot.get("poise_absorption", {}) as Dictionary
	_expect(int(reset_contract.get("application_events", -1)) == 0, "reset retained contract events", failures)
	_expect(int(reset_brain.get("total_events", -1)) == 0, "reset retained brain invalidations", failures)
	_expect(int(reset_poise.get("total_events", -1)) == 0, "reset retained Poise events", failures)

	_finish(failures)


func _expect(condition: bool, message: String, failures: Array[String]) -> void:
	if not condition:
		failures.append(message)


func _finish(failures: Array[String]) -> void:
	if failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return
	for failure: String in failures:
		push_error("[CombatTelemetryDiagnosticsSmoke] " + failure)
	get_tree().quit(1)
