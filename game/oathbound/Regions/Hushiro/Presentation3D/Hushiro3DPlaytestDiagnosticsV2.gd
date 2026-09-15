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

	snapshot["presentation_revision"] = int(state.get("presentation_revision", 1))
	snapshot["hushiro_standard_actor_count"] = int(state.get("hushiro_standard_actor_count", 0))
	snapshot["unknown_hushiro_actor_count"] = int(state.get("unknown_hushiro_actor_count", 0))
	snapshot["actor_role_counts"] = role_counts.duplicate(true)
	return snapshot
