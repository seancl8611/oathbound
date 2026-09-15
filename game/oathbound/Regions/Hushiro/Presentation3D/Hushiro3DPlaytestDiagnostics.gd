extends Node

## Low-frequency diagnostics for the live Hushiro planar-combat -> 3D presentation.
##
## This node is deliberately observational. It never changes combat, camera, animation,
## visibility, or model selection. During debug playtests it records a compact snapshot
## whenever the presentation composition changes, making screenshots/logs diagnosable
## without adding per-frame telemetry cost.

@export var bridge_path: NodePath = NodePath("../Planar3DPresentationBridge")
@export_range(0.25, 2.0, 0.05) var sample_interval: float = 0.50

var _sample_left: float = 0.0
var _last_signature: String = ""
var _last_active: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not OS.is_debug_build():
		set_process(false)


func _process(delta: float) -> void:
	_sample_left -= delta
	if _sample_left > 0.0:
		return
	_sample_left = sample_interval

	var bridge := get_node_or_null(bridge_path)
	if bridge == null:
		return
	var active := bridge.has_method("is_presentation_enabled") and bool(bridge.call("is_presentation_enabled"))
	if not active:
		if _last_active:
			_record("hushiro_3d_presentation_disabled", {"active": false})
		_last_active = false
		_last_signature = ""
		return

	_last_active = true
	var snapshot := _snapshot_for_bridge(bridge)
	if snapshot.is_empty():
		return
	var signature := _signature_for(snapshot)
	if signature == _last_signature:
		return
	_last_signature = signature
	_record("hushiro_3d_presentation_snapshot", snapshot)


func get_current_snapshot_for_test() -> Dictionary:
	var bridge := get_node_or_null(bridge_path)
	if bridge == null:
		return {}
	return _snapshot_for_bridge(bridge)


func _snapshot_for_bridge(bridge: Node) -> Dictionary:
	if bridge == null:
		return {}
	var state_value: Variant = null
	if bridge.has_method("get_presentation_state"):
		state_value = bridge.call("get_presentation_state")
	elif bridge.has_method("get_layering_state_for_test"):
		# Compatibility path for older bridge implementations during migration.
		state_value = bridge.call("get_layering_state_for_test")
	if not (state_value is Dictionary):
		return {}
	var state := state_value as Dictionary
	var viewport_value: Variant = state.get("viewport_size", Vector2i.ZERO)
	var viewport_size := viewport_value as Vector2i if viewport_value is Vector2i else Vector2i.ZERO
	var environment_value: Variant = state.get("environment_state", {})
	var environment_state := environment_value as Dictionary if environment_value is Dictionary else {}
	var animation_value: Variant = state.get("curated_animation_states_by_role", {})
	var animation_states := animation_value as Dictionary if animation_value is Dictionary else {}

	return {
		"active": bridge.has_method("is_presentation_enabled") and bool(bridge.call("is_presentation_enabled")),
		"actor_visual_count": int(state.get("actor_visual_count", 0)),
		"player_actor_count": int(state.get("player_actor_count", 0)),
		"swordsman_actor_count": int(state.get("swordsman_actor_count", 0)),
		"curated_actor_count": int(state.get("curated_actor_count", 0)),
		"animated_curated_actor_count": int(state.get("animated_curated_actor_count", 0)),
		"hound_actor_count": int(state.get("hound_actor_count", 0)),
		"role_specific_actor_count": int(state.get("role_specific_actor_count", 0)),
		"procedural_actor_count": int(state.get("procedural_actor_count", 0)),
		"contact_shadow_count": int(state.get("contact_shadow_count", 0)),
		"attack_vfx_count": int(state.get("attack_vfx_count", 0)),
		"min_actor_y": float(state.get("min_actor_y", 0.0)),
		"camera_ground_compression": float(state.get("illustrated_ground_compression", 0.0)),
		"camera_elevation_degrees": float(state.get("illustrated_camera_elevation_degrees", 0.0)),
		"camera_presentation_zoom": float(state.get("illustrated_presentation_zoom", 0.0)),
		"camera3d_orthogonal": bool(state.get("camera3d_orthogonal", false)),
		"camera3d_current": bool(state.get("camera3d_current", false)),
		"viewport_width": viewport_size.x,
		"viewport_height": viewport_size.y,
		"presentation_canvas_layer": int(state.get("presentation_canvas_layer", 0)),
		"texture_mouse_passthrough": bool(state.get("texture_mouse_passthrough", false)),
		"background_hidden": bool(state.get("background_hidden", false)),
		"scenery_hidden": bool(state.get("scenery_hidden", false)),
		"combat_fx_visible": bool(state.get("combat_fx_visible", false)),
		"environment_has_ground": bool(environment_state.get("has_ground", false)),
		"environment_has_ruined_torii": bool(environment_state.get("has_ruined_torii", false)),
		"environment_has_shrine_landmark": bool(environment_state.get("has_shrine_landmark", false)),
		"environment_has_moon_key": bool(environment_state.get("has_moon_key", false)),
		"environment_ritual_accent_count": int(environment_state.get("ritual_accent_count", 0)),
		"environment_warm_light_count": int(environment_state.get("warm_light_count", 0)),
		"environment_foreground_occluder_count": int(environment_state.get("foreground_occluder_count", 0)),
		"environment_landmark_count": int(environment_state.get("landmark_count", 0)),
		"player_animation_mode": _animation_mode(animation_states, "player"),
		"swordsman_animation_mode": _animation_mode(animation_states, "swordsman"),
	}


func _animation_mode(animation_states: Dictionary, role: String) -> Dictionary:
	var value: Variant = animation_states.get(role, {})
	if not (value is Dictionary):
		return {}
	var state := value as Dictionary
	return {
		"active": bool(state.get("active", false)),
		"clip_count": int(state.get("clip_count", 0)),
		"idle_clip": str(state.get("idle_clip", "")),
		"locomotion_clip": str(state.get("locomotion_clip", "")),
		"dash_mode": str(state.get("dash_mode", "")),
		"attack_mode": str(state.get("attack_mode", "")),
	}


func _signature_for(snapshot: Dictionary) -> String:
	# Only composition/contract values participate in deduplication. Action progress and
	# positions are intentionally absent so this cannot become hidden per-frame telemetry.
	return JSON.stringify(snapshot)


func _record(event_name: String, data: Dictionary) -> void:
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event(event_name, data)
