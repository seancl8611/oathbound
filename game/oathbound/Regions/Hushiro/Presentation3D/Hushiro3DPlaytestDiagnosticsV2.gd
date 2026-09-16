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
	var production_exists_value: Variant = state.get("production_model_slot_exists_by_role", state.get("production_model_ready_by_role", {}))
	var production_exists := production_exists_value as Dictionary if production_exists_value is Dictionary else {}
	var production_renderable_value: Variant = state.get("production_model_slot_renderable_by_role", {})
	var production_renderable := production_renderable_value as Dictionary if production_renderable_value is Dictionary else {}
	var production_activation_value: Variant = state.get("production_model_activation_ready_by_role", {})
	var production_activation := production_activation_value as Dictionary if production_activation_value is Dictionary else {}
	var production_validation_value: Variant = state.get("production_model_validation_by_role", {})
	var production_validation := production_validation_value as Dictionary if production_validation_value is Dictionary else {}
	var production_spawned_value: Variant = state.get("production_model_spawned_by_role", {})
	var production_spawned := production_spawned_value as Dictionary if production_spawned_value is Dictionary else {}
	var production_active_value: Variant = state.get("production_model_active_by_role", {})
	var production_active := production_active_value as Dictionary if production_active_value is Dictionary else {}
	var production_animation_value: Variant = state.get("production_animation_state_by_role", {})
	var production_animation := production_animation_value as Dictionary if production_animation_value is Dictionary else {}
	var environment_value: Variant = state.get("environment_state", {})
	var environment_state := environment_value as Dictionary if environment_value is Dictionary else {}

	snapshot["presentation_revision"] = int(state.get("presentation_revision", 1))
	snapshot["hushiro_standard_actor_count"] = int(state.get("hushiro_standard_actor_count", 0))
	snapshot["unknown_hushiro_actor_count"] = int(state.get("unknown_hushiro_actor_count", 0))
	snapshot["actor_role_counts"] = role_counts.duplicate(true)
	snapshot["production_model_slot_count"] = int(state.get("production_model_slot_count", 0))
	snapshot["production_model_slot_exists_count"] = int(state.get("production_model_slot_exists_count", state.get("production_model_ready_count", 0)))
	snapshot["production_model_slot_exists_by_role"] = production_exists.duplicate(true)
	snapshot["production_model_slot_renderable_count"] = int(state.get("production_model_slot_renderable_count", 0))
	snapshot["production_model_slot_renderable_by_role"] = production_renderable.duplicate(true)
	snapshot["production_model_activation_ready_count"] = int(state.get("production_model_activation_ready_count", 0))
	snapshot["production_model_activation_ready_by_role"] = production_activation.duplicate(true)
	snapshot["production_model_validation_state_by_role"] = _validation_states(production_validation)
	snapshot["production_model_semantic_clips_by_role"] = _semantic_clips(production_validation)
	snapshot["production_model_contract_player_path_by_role"] = _validation_field_map(production_validation, "animation_contract_player_path", "")
	snapshot["production_model_contract_player_count_by_role"] = _validation_field_map(production_validation, "animation_contract_player_count", 0)
	snapshot["production_model_root_transform_track_count_by_role"] = _validation_field_map(production_validation, "animation_root_transform_track_count", 0)
	snapshot["production_model_spawned_by_role"] = production_spawned.duplicate(true)
	snapshot["production_model_active_count"] = int(state.get("production_model_active_count", 0))
	snapshot["production_model_active_by_role"] = production_active.duplicate(true)
	snapshot["production_animation_state_by_role"] = production_animation.duplicate(true)
	# Compatibility fields retained for existing telemetry consumers.
	snapshot["production_model_ready_count"] = int(state.get("production_model_ready_count", 0))
	snapshot["production_model_ready_by_role"] = production_exists.duplicate(true)
	snapshot["environment_composition_revision"] = int(environment_state.get("composition_revision", 0))
	snapshot["environment_quiet_center"] = bool(environment_state.get("quiet_center", false))
	return snapshot


func _validation_states(validation_by_role: Dictionary) -> Dictionary:
	var states: Dictionary = {}
	for role_value: Variant in validation_by_role.keys():
		var role := str(role_value)
		var validation_value: Variant = validation_by_role.get(role_value, {})
		states[role] = str((validation_value as Dictionary).get("state", "unknown")) if validation_value is Dictionary else "unknown"
	return states


func _semantic_clips(validation_by_role: Dictionary) -> Dictionary:
	var clips_by_role: Dictionary = {}
	for role_value: Variant in validation_by_role.keys():
		var role := str(role_value)
		var validation_value: Variant = validation_by_role.get(role_value, {})
		if not (validation_value is Dictionary):
			clips_by_role[role] = {}
			continue
		var clips_value: Variant = (validation_value as Dictionary).get("semantic_animation_clips", {})
		clips_by_role[role] = (clips_value as Dictionary).duplicate(true) if clips_value is Dictionary else {}
	return clips_by_role


func _validation_field_map(validation_by_role: Dictionary, field: String, fallback: Variant) -> Dictionary:
	var values: Dictionary = {}
	for role_value: Variant in validation_by_role.keys():
		var role := str(role_value)
		var validation_value: Variant = validation_by_role.get(role_value, {})
		values[role] = (validation_value as Dictionary).get(field, fallback) if validation_value is Dictionary else fallback
	return values
