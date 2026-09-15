extends "res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridge.gd"

## Second-pass live Hushiro 3D bridge based on the first real gameplay acceptance pass.
## This is a presentation revision only: authoritative 2D combat positions, ranges, timing,
## AI and Pressure Director behavior remain untouched.

const HUSHIRO_ENVIRONMENT_V2_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/Hushiro3DEnvironmentV2.gd")
const HUSHIRO_CURATED_HUMAN_V2_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroCuratedActorVisualV2.gd")
const HUSHIRO_STANDARD_ENEMY_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroStandardEnemyActorVisual.gd")

const HUSHIRO_V2_MODEL_PATHS: Dictionary = {
	"player": "res://Art3D/Characters/Akio/akio.glb",
	"swordsman": "res://Art3D/Characters/HushiroSwordsman/hushiro_swordsman.glb",
	"hound": "res://Art3D/Characters/BlightedHound/blighted_hound.glb",
	"hollow": "res://Art3D/Characters/Hollow/hollow.glb",
	"archer": "res://Art3D/Characters/HushiroArcher/hushiro_archer.glb",
	"bilemass": "res://Art3D/Characters/CellarBilemass/cellar_bilemass.glb",
	"warden": "res://Art3D/Characters/HushiroWarden/hushiro_warden.glb",
}


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
	super._ready()


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
	if visual.has_method("set_external_model_path"):
		visual.call("set_external_model_path", production_model_path)
	return visual


func get_presentation_state() -> Dictionary:
	var state := super.get_presentation_state()
	var authored_standard_count := 0
	var unknown_hushiro_count := 0
	var role_counts: Dictionary = {}

	for visual_value: Variant in _actor_visuals.values():
		if not (visual_value is Node3D) or not is_instance_valid(visual_value as Node3D):
			continue
		var visual := visual_value as Node3D
		var role := str(visual.get("actor_role"))
		role_counts[role] = int(role_counts.get(role, 0)) + 1
		if visual.has_method("get_visual_tier"):
			var tier := str(visual.call("get_visual_tier"))
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
	state["presentation_revision"] = 2
	return state
