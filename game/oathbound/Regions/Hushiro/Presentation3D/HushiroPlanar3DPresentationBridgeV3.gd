extends "res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridgeV2.gd"

## Third-pass Hushiro presentation after the first correct-head V2 gameplay review.
##
## V2 proved the planar-to-3D bridge, but the live result still read too close and too
## conventionally real-time 3D. V3 deliberately pushes the rendering toward an illustrated
## 2.5D read without changing any combat authority:
## - show materially more arena;
## - reduce actor screen size;
## - flatten temporary actor lighting while preserving the authored 3D environment;
## - keep one explicit contact shadow rather than volumetric actor shadows;
## - quantize facing to eight presentation directions so motion reads more like authored
##   directional animation than a freely rotating third-person model;
## - enforce legacy-body exclusivity every frame;
## - retire orphaned presentation actors safely when their authoritative source is freed.

@export_category("Hybrid illustrated 2.5D")
# The first correct-head V3 run proved that farther framing materially improves readability,
# but the user still read the arena as too close and the placeholder actors as too large.
# Make one final controlled framing pass before changing actor-rendering architecture.
@export_range(0.28, 0.60, 0.01) var hybrid_presentation_zoom: float = 0.35
@export_range(0.50, 1.00, 0.01) var hybrid_actor_scale: float = 0.68
@export_range(0.42, 0.65, 0.01) var hybrid_ground_compression: float = 0.50
@export var hybrid_framing_world_offset := Vector2(0.0, -24.0)
@export var flatten_actor_shading: bool = true
@export var quantize_actor_facing: bool = true

const EIGHT_WAY_FACING_STEP := TAU / 8.0


func _ready() -> void:
	# Let V2 initialize its production-model/animation contracts and defer activation first.
	# These values are then replaced before the deferred shared bridge activation executes.
	super._ready()
	illustrated_ground_compression = hybrid_ground_compression
	illustrated_presentation_zoom = hybrid_presentation_zoom
	illustrated_framing_world_offset = hybrid_framing_world_offset
	actor_ground_lift = 0.06
	print(
		"[HushiroPlanar3DV3] revision=3 hybrid_2_5d=true compression=%.2f elevation=%.1fdeg zoom=%.2f actor_scale=%.2f framing_iteration=2"
		% [
			illustrated_ground_compression,
			rad_to_deg(asin(illustrated_ground_compression)),
			illustrated_presentation_zoom,
			hybrid_actor_scale,
		]
	)


func _add_actor_visual(actor: Node2D) -> void:
	super._add_actor_visual(actor)
	if actor == null or not is_instance_valid(actor):
		return
	var visual_value: Variant = _actor_visuals.get(actor.get_instance_id(), null)
	if not _is_live_object(visual_value):
		return
	if not (visual_value is Node3D):
		return
	var visual := visual_value as Node3D
	visual.scale = Vector3.ONE * hybrid_actor_scale
	if flatten_actor_shading:
		_apply_flat_actor_treatment(visual)


func _reconcile_actors() -> void:
	# Do not delegate stale-entry cleanup to the shared V1 bridge. Its historical cleanup
	# path performs `is Node2D` before proving the Variant still references a live object,
	# which is exactly the failure exposed by the second V3 manual run. V3 keeps all object
	# lifetime checks ahead of type checks in both synchronization and reconciliation.
	var seen: Dictionary = {}
	for actor: Node2D in _presentation_actors():
		if actor == null or not is_instance_valid(actor):
			continue
		var actor_id := actor.get_instance_id()
		seen[actor_id] = true
		var has_visual := _v3_has_valid_actor_visual(actor_id)
		if not has_visual:
			_restore_actor_art(actor)
			_add_actor_visual(actor)
			has_visual = _v3_has_valid_actor_visual(actor_id)

		if hide_legacy_actor_art and has_visual:
			_hide_actor_art(actor)
		else:
			_restore_actor_art(actor)

	for actor_id: Variant in _actor_visuals.keys():
		if seen.has(actor_id):
			continue
		var visual_value: Variant = _actor_visuals.get(actor_id, null)
		if not _is_live_object(visual_value):
			_actor_visuals.erase(actor_id)
			continue
		if not (visual_value is Node):
			_actor_visuals.erase(actor_id)
			continue

		var visual := visual_value as Node
		var source_value: Variant = visual.get("source_actor")
		if _is_live_object(source_value) and source_value is Node2D:
			_restore_actor_art(source_value as Node2D)
		visual.queue_free()
		_actor_visuals.erase(actor_id)


func _v3_has_valid_actor_visual(actor_id: Variant) -> bool:
	if not _actor_visuals.has(actor_id):
		return false
	var visual_value: Variant = _actor_visuals.get(actor_id, null)
	if not _is_live_object(visual_value):
		_actor_visuals.erase(actor_id)
		return false
	if not (visual_value is Node3D):
		_actor_visuals.erase(actor_id)
		return false
	var visual := visual_value as Node3D
	if _actor_visual_is_ready(visual):
		return true
	visual.queue_free()
	_actor_visuals.erase(actor_id)
	return false


func _sync_actor_visuals(delta: float) -> void:
	# Lifetime checks deliberately happen before `is` type checks. Godot raises
	# "Left operand of 'is' is a previously freed instance" when a dead source actor is
	# still referenced by its presentation visual for the fraction of a frame before the
	# reconciliation pass. Remove that orphan immediately instead of touching the freed ref.
	for actor_id: Variant in _actor_visuals.keys():
		var visual_value: Variant = _actor_visuals.get(actor_id, null)
		if not _is_live_object(visual_value):
			_actor_visuals.erase(actor_id)
			continue
		if not (visual_value is Node3D):
			_actor_visuals.erase(actor_id)
			continue

		var visual := visual_value as Node3D
		var source_value: Variant = visual.get("source_actor")
		if not _is_live_object(source_value):
			visual.queue_free()
			_actor_visuals.erase(actor_id)
			continue
		if not (source_value is Node2D):
			visual.queue_free()
			_actor_visuals.erase(actor_id)
			continue

		var source := source_value as Node2D
		visual.position = map_2d_to_3d(source.global_position)
		if visual.has_method("sync_from_source"):
			visual.call("sync_from_source", delta)

		if quantize_actor_facing:
			visual.rotation.y = roundf(visual.rotation.y / EIGHT_WAY_FACING_STEP) * EIGHT_WAY_FACING_STEP

		# Compatibility scripts can re-enable nested Sprite2D/AnimatedSprite2D body art at
		# runtime. A valid V3 replacement owns presentation exclusively, so suppress the old
		# body every frame rather than trusting one reconciliation-time visibility write.
		if hide_legacy_actor_art:
			_hide_actor_art(source)


func _is_live_object(value: Variant) -> bool:
	return value != null and typeof(value) == TYPE_OBJECT and is_instance_valid(value)


func _apply_flat_actor_treatment(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		# Keep the dedicated contact-shadow mesh intact. All other temporary character
		# geometry stops casting volumetric shadows; the single authored ground shadow carries
		# grounding while the body reads more like an illustrated cutout.
		if mesh_instance.name != &"ContactShadow":
			mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		if mesh_instance.mesh != null:
			for surface_index: int in range(mesh_instance.mesh.get_surface_count()):
				var source_material := mesh_instance.get_active_material(surface_index)
				if source_material is StandardMaterial3D:
					var styled := (source_material as StandardMaterial3D).duplicate(true) as StandardMaterial3D
					if styled != null:
						styled.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
						styled.roughness = 1.0
						styled.metallic = 0.0
						mesh_instance.set_surface_override_material(surface_index, styled)
	for child: Node in node.get_children():
		_apply_flat_actor_treatment(child)


func get_presentation_state() -> Dictionary:
	var state := super.get_presentation_state()
	state["presentation_revision"] = 3
	state["hybrid_2_5d"] = true
	state["hybrid_framing_iteration"] = 2
	state["hybrid_actor_scale"] = hybrid_actor_scale
	state["hybrid_flat_actor_shading"] = flatten_actor_shading
	state["hybrid_eight_way_facing"] = quantize_actor_facing
	state["illustrated_ground_compression"] = illustrated_ground_compression
	state["illustrated_camera_elevation_degrees"] = rad_to_deg(asin(illustrated_ground_compression))
	state["illustrated_presentation_zoom"] = illustrated_presentation_zoom
	return state
