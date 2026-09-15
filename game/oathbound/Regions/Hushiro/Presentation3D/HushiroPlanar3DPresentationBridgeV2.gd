extends "res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridge.gd"

## Second-pass live Hushiro 3D bridge based on the first real gameplay acceptance pass.
## This is a presentation revision only: authoritative 2D combat positions, ranges, timing,
## AI and Pressure Director behavior remain untouched.

const HUSHIRO_ENVIRONMENT_V2_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/Hushiro3DEnvironmentV2.gd")
const HUSHIRO_CURATED_HUMAN_V2_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroCuratedActorVisualV2.gd")
const HUSHIRO_STANDARD_ENEMY_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroStandardEnemyActorVisual.gd")
const PRODUCTION_MODEL_VALIDATOR = preload("res://Utility/Planar3DProductionModelValidator.gd")

const HUSHIRO_V2_MODEL_PATHS: Dictionary = {
	"player": "res://Art3D/Characters/Akio/akio.glb",
	"swordsman": "res://Art3D/Characters/HushiroSwordsman/hushiro_swordsman.glb",
	"hound": "res://Art3D/Characters/BlightedHound/blighted_hound.glb",
	"hollow": "res://Art3D/Characters/Hollow/hollow.glb",
	"archer": "res://Art3D/Characters/HushiroArcher/hushiro_archer.glb",
	"bilemass": "res://Art3D/Characters/CellarBilemass/cellar_bilemass.glb",
	"warden": "res://Art3D/Characters/HushiroWarden/hushiro_warden.glb",
}

# Production files are immutable for one running build, so expensive scene inspection is
# cached lazily the first time runtime selection, diagnostics, or CI asks for it.
var _production_model_validation_cache: Dictionary = {}


func _ready() -> void:
	# The rejected first pass used 38.3 degrees / 0.72 zoom and still read almost top-down
	# and too close. Make the second pass materially different: ~28.7 degree elevation and
	# a 0.52 zoom expose most of the authored combat floor while vertical landmarks remain
	# visible behind the actors.
	illustrated_ground_compression = 0.48
	illustrated_presentation_zoom = 0.52
	illustrated_framing_world_offset = Vector2(0.0, -30.0)
	actor_ground_lift = 0.075

	# The bottom-left migration badge was useful during engineering but visibly polluted
	# the actual acceptance screenshot. Diagnostics remain in telemetry instead.
	show_debug_label = false
	_production_model_validation_cache.clear()
	super._ready()

	# Emit one region/revision-owned startup marker after the shared bridge has initialized.
	# CI can use this to prove that the live RunScene actually instantiated V2 even when a
	# Camera2D is not yet available early enough for the parent camera-profile log.
	print(
		"[HushiroPlanar3DV2] revision=2 compression=%.2f elevation=%.1fdeg zoom=%.2f"
		% [illustrated_ground_compression, rad_to_deg(asin(illustrated_ground_compression)), illustrated_presentation_zoom]
	)


func _setup_world() -> void:
	super._setup_world()
	# Lift the rejected slice's near-black ambient floor without changing Hushiro's night
	# identity. Region-local override keeps future areas free to choose their own lighting.
	if _world_root == null:
		return
	var world_environment := _world_root.get_node_or_null("WorldEnvironment") as WorldEnvironment
	if world_environment == null or world_environment.environment == null:
		return
	world_environment.environment.background_color = Color(0.025, 0.027, 0.036, 1.0)
	world_environment.environment.ambient_light_color = Color(0.34, 0.37, 0.46, 1.0)
	world_environment.environment.ambient_light_energy = 0.92


func _create_environment_root() -> Node3D:
	var environment_value: Variant = HUSHIRO_ENVIRONMENT_V2_SCRIPT.new()
	if not (environment_value is Node3D):
		return null
	var environment := environment_value as Node3D
	environment.name = "Hushiro3DEnvironmentV2"
	return environment


func _create_actor_visual(_actor: Node2D, role: String) -> Node3D:
	var visual_value: Variant
	match role:
		"hound":
			visual_value = HUSHIRO_HOUND_VISUAL_SCRIPT.new()
		"player", "swordsman":
			visual_value = HUSHIRO_CURATED_HUMAN_V2_SCRIPT.new()
		_:
			visual_value = HUSHIRO_STANDARD_ENEMY_SCRIPT.new()

	if not (visual_value is Node3D):
		return null
	var visual := visual_value as Node3D
	var production_model_path := str(HUSHIRO_V2_MODEL_PATHS.get(role, ""))
	var validation := _production_model_validation_for_role(role, production_model_path)
	# A final-art file does not automatically displace a proven fallback. The current
	# shared adapter needs renderable geometry plus semantic Idle + locomotion + Attack
	# clips before it can present a production actor without becoming static in combat.
	if bool(validation.get("activation_ready", false)) and visual.has_method("set_external_model_path"):
		visual.call("set_external_model_path", production_model_path)
	return visual


func get_presentation_state() -> Dictionary:
	var state := super.get_presentation_state()
	var authored_standard_count := 0
	var unknown_hushiro_count := 0
	var role_counts: Dictionary = {}

	# Keep production-model concepts separate in diagnostics:
	# - slot exists: a resource is present at the canonical path;
	# - slot renderable: that resource can instantiate a Node3D with mesh geometry;
	# - activation ready: renderable + the semantic animation aliases the runtime drives;
	# - spawned: this role currently has a live presentation actor;
	# - active: that actor actually accepted/rendered the role-specific GLB.
	var production_model_slot_exists_by_role: Dictionary = {}
	var production_model_slot_renderable_by_role: Dictionary = {}
	var production_model_activation_ready_by_role: Dictionary = {}
	var production_model_validation_by_role: Dictionary = {}
	var production_model_spawned_by_role: Dictionary = {}
	var production_model_active_by_role: Dictionary = {}
	var production_model_slot_exists_count := 0
	var production_model_slot_renderable_count := 0
	var production_model_activation_ready_count := 0
	var production_model_active_count := 0
	for role_value: Variant in HUSHIRO_V2_MODEL_PATHS.keys():
		var slot_role := str(role_value)
		var model_path := str(HUSHIRO_V2_MODEL_PATHS.get(slot_role, ""))
		var validation := _production_model_validation_for_role(slot_role, model_path)
		var slot_exists := bool(validation.get("exists", false))
		var slot_renderable := bool(validation.get("renderable", false))
		var activation_ready := bool(validation.get("activation_ready", false))
		production_model_validation_by_role[slot_role] = validation
		production_model_slot_exists_by_role[slot_role] = slot_exists
		production_model_slot_renderable_by_role[slot_role] = slot_renderable
		production_model_activation_ready_by_role[slot_role] = activation_ready
		production_model_spawned_by_role[slot_role] = false
		production_model_active_by_role[slot_role] = false
		if slot_exists:
			production_model_slot_exists_count += 1
		if slot_renderable:
			production_model_slot_renderable_count += 1
		if activation_ready:
			production_model_activation_ready_count += 1

	for visual_value: Variant in _actor_visuals.values():
		if not (visual_value is Node3D) or not is_instance_valid(visual_value as Node3D):
			continue
		var visual := visual_value as Node3D
		var role := str(visual.get("actor_role"))
		role_counts[role] = int(role_counts.get(role, 0)) + 1
		if production_model_spawned_by_role.has(role):
			production_model_spawned_by_role[role] = true
		if visual.has_method("get_visual_tier"):
			var tier := str(visual.call("get_visual_tier"))
			if tier == "role_specific_glb" and production_model_active_by_role.has(role):
				if not bool(production_model_active_by_role.get(role, false)):
					production_model_active_count += 1
				production_model_active_by_role[role] = true
			if tier == "hushiro_authored_standard":
				authored_standard_count += 1
				if role not in ["hollow", "archer", "bilemass", "warden"]:
					unknown_hushiro_count += 1

	# Parent V1 introspection did not know this new authored tier, so it counted these
	# visuals as procedural. Reclassify them for diagnostics/CI without changing rendering.
	state["hushiro_standard_actor_count"] = authored_standard_count
	state["unknown_hushiro_actor_count"] = unknown_hushiro_count
	state["actor_role_counts"] = role_counts
	state["procedural_actor_count"] = maxi(0, int(state.get("procedural_actor_count", 0)) - authored_standard_count)
	state["role_specific_actor_count"] = int(state.get("role_specific_actor_count", 0)) + authored_standard_count
	state["production_model_slot_count"] = HUSHIRO_V2_MODEL_PATHS.size()
	state["production_model_slot_exists_count"] = production_model_slot_exists_count
	state["production_model_slot_exists_by_role"] = production_model_slot_exists_by_role
	state["production_model_slot_renderable_count"] = production_model_slot_renderable_count
	state["production_model_slot_renderable_by_role"] = production_model_slot_renderable_by_role
	state["production_model_activation_ready_count"] = production_model_activation_ready_count
	state["production_model_activation_ready_by_role"] = production_model_activation_ready_by_role
	state["production_model_validation_by_role"] = production_model_validation_by_role
	state["production_model_spawned_by_role"] = production_model_spawned_by_role
	state["production_model_active_count"] = production_model_active_count
	state["production_model_active_by_role"] = production_model_active_by_role

	# Compatibility aliases for diagnostics consumers created before the existence/active
	# distinction. `ready` here means only that a canonical slot resource exists.
	state["production_model_ready_count"] = production_model_slot_exists_count
	state["production_model_ready_by_role"] = production_model_slot_exists_by_role.duplicate(true)
	state["presentation_revision"] = 2
	return state


func _production_model_validation_for_role(role: String, model_path: String) -> Dictionary:
	var cached_value: Variant = _production_model_validation_cache.get(role, null)
	if cached_value is Dictionary:
		var cached := cached_value as Dictionary
		if str(cached.get("path", "")) == model_path:
			return cached.duplicate(true)
	var validation_value: Variant = PRODUCTION_MODEL_VALIDATOR.inspect_scene(model_path)
	var validation := validation_value as Dictionary if validation_value is Dictionary else {
		"path": model_path,
		"exists": false,
		"renderable": false,
		"animation_contract_ready": false,
		"activation_ready": false,
		"state": "validator_error",
	}
	_production_model_validation_cache[role] = validation.duplicate(true)
	return validation.duplicate(true)
