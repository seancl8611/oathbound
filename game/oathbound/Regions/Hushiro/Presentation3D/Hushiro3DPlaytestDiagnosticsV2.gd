extends "res://Regions/Hushiro/Presentation3D/Hushiro3DPlaytestDiagnostics.gd"

## Adds second-pass presentation completeness to the existing low-frequency telemetry.
## This remains observational only.


func _snapshot_for_bridge(bridge: Node) -> Dictionary:
	var snapshot := super._snapshot_for_bridge(bridge)
	if bridge == null or not bridge.has_method("get_presentation_state"):
		return snapshot
	var state_value: Variant = bridge.call("get_presentation_state")
	if not (state_value is Dictionary):
		return snapshot
	var state := state_value as Dictionary
	var role_counts_value: Variant = state.get("actor_role_counts", {})
	var role_counts := role_counts_value as Dictionary if role_counts_value is Dictionary else {}
	var production_ready_value: Variant = state.get("production_model_ready_by_role", {})
	var production_ready := production_ready_value as Dictionary if production_ready_value is Dictionary else {}
	var environment_value: Variant = state.get("environment_state", {})
	var environment_state := environment_value as Dictionary if environment_value is Dictionary else {}

	snapshot["presentation_revision"] = int(state.get("presentation_revision", 1))
	snapshot["hushiro_standard_actor_count"] = int(state.get("hushiro_standard_actor_count", 0))
	snapshot["unknown_hushiro_actor_count"] = int(state.get("unknown_hushiro_actor_count", 0))
	snapshot["actor_role_counts"] = role_counts.duplicate(true)
	snapshot["production_model_slot_count"] = int(state.get("production_model_slot_count", 0))
	snapshot["production_model_ready_count"] = int(state.get("production_model_ready_count", 0))
	snapshot["production_model_ready_by_role"] = production_ready.duplicate(true)
	snapshot["environment_composition_revision"] = int(environment_state.get("composition_revision", 0))
	snapshot["environment_quiet_center"] = bool(environment_state.get("quiet_center", false))
	return snapshot
