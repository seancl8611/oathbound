extends "res://Utility/Planar3DPresentationBridge.gd"

## Hushiro-specific hardening and art-direction profile for the live planar-combat -> 3D
## presentation bridge.
##
## Combat ownership remains entirely in the existing 2D actors. This wrapper owns only
## the visual replacement contract: persistent legacy-art suppression, actor grounding,
## curated placeholder selection, and the Hushiro camera profile used to make real-time
## 3D read closer to illustrated 2D.

const HUSHIRO_ACTOR_VISUAL_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroCuratedActorVisual.gd")

@export var actor_ground_lift: float = 0.10

@export_category("Illustrated three-quarter camera")
# The first live-3D playtest inherited the compatibility projection (0.84 ~= 57 degrees
# above the ground) and read too top-down/chunky. Hushiro now deliberately uses a flatter
# three-quarter projection: asin(0.62) ~= 38.3 degrees above the combat plane.
@export_range(0.50, 0.75, 0.01) var illustrated_ground_compression: float = 0.62
# Camera2D zoom is also mirrored by the Camera3D bridge. 0.72 shows roughly 30% more arena
# than the previous 0.94 profile, bringing the framing closer to an authored Hades-like
# room composition without changing any combat distances.
@export_range(0.60, 0.90, 0.01) var illustrated_presentation_zoom: float = 0.72
@export var illustrated_framing_world_offset := Vector2(0.0, -8.0)


func _process(delta: float) -> void:
	super._process(delta)
	if not is_presentation_enabled():
		return

	# ThreeQuarterPresentationVisibility is a compatibility system and can legitimately
	# re-apply its own visibility state after room/camera initialization. While live 3D is
	# authoritative, keep opaque legacy room art suppressed every frame instead of relying
	# on one initialization-order-sensitive hide call.
	if hide_legacy_room_art:
		_hide_legacy_room_art()

	# Base sync intentionally maps gameplay coordinates to the Y=0 ground plane. The
	# temporary 3D floor kit contains slightly raised stone surfaces, so lift only the
	# presentation roots after base synchronization. Gameplay positions/hitboxes do not move.
	_apply_actor_ground_lift()


func _add_actor_visual(actor: Node2D) -> void:
	if _world_root == null:
		return
	var visual_value: Variant = HUSHIRO_ACTOR_VISUAL_SCRIPT.new()
	if not (visual_value is Node3D):
		return
	var visual := visual_value as Node3D
	visual.name = "Actor3D_%s" % str(actor.get_instance_id())
	_world_root.add_child(visual)
	if visual.has_method("configure"):
		visual.call("configure", _role_for(actor), actor)
	_actor_visuals[actor.get_instance_id()] = visual


func _capture_and_adjust_legacy_camera() -> void:
	super._capture_and_adjust_legacy_camera()
	var camera2d := get_viewport().get_camera_2d()
	if camera2d == null:
		return

	_set_camera_profile_property(camera2d, "ground_vertical_compression", illustrated_ground_compression)
	_set_camera_profile_property(camera2d, "presentation_zoom", illustrated_presentation_zoom)
	_set_camera_profile_property(camera2d, "framing_world_offset", illustrated_framing_world_offset)

	# CameraFollow caches its exported profile into Camera2D.zoom. Apply immediately so
	# the first Camera3D sync and the surviving 2D CombatFX share the exact same projection.
	if camera2d.has_method("_apply_presentation_profile"):
		camera2d.call("_apply_presentation_profile")
	if camera2d.has_method("snap_to_target"):
		camera2d.call("snap_to_target")

	print(
		"[HushiroPlanar3D] illustrated camera profile compression=%.2f elevation=%.1fdeg zoom=%.2f"
		% [illustrated_ground_compression, rad_to_deg(asin(illustrated_ground_compression)), illustrated_presentation_zoom]
	)


func _restore_legacy_presentation() -> void:
	var camera2d := get_viewport().get_camera_2d() if is_inside_tree() else null
	super._restore_legacy_presentation()
	# Restoring the exported values alone does not recalculate CameraFollow.zoom. Reapply
	# its profile so leaving live 3D cannot strand the compatibility camera at Hushiro's
	# flatter test values.
	if camera2d != null and is_instance_valid(camera2d):
		if camera2d.has_method("_apply_presentation_profile"):
			camera2d.call("_apply_presentation_profile")
		if camera2d.has_method("snap_to_target"):
			camera2d.call("snap_to_target")


func _set_camera_profile_property(camera2d: Camera2D, property_name: String, value: Variant) -> void:
	if not _has_property(camera2d, property_name):
		return
	if not _camera2d_settings.has(property_name):
		_camera2d_settings[property_name] = camera2d.get(property_name)
	camera2d.set(property_name, value)


func _hide_legacy_room_art() -> void:
	var room := get_parent()
	if room == null:
		return

	var background := room.get_node_or_null("Background") as CanvasItem
	if background != null:
		_remember_and_hide(background)

	var presentation := room.get_node_or_null("ThreeQuarterPresentation")
	if presentation == null:
		return

	# CombatFX contains ground telegraphs/readability cues that still belong to the
	# authoritative planar simulation. Hide the old visual room dressing, not those cues.
	for child: Node in presentation.get_children():
		if child.name == &"CombatFX":
			continue
		if child is CanvasItem:
			_remember_and_hide(child as CanvasItem)


func _apply_actor_ground_lift() -> void:
	var safe_lift := maxf(0.0, actor_ground_lift)
	for visual_value: Variant in _actor_visuals.values():
		if visual_value is Node3D and is_instance_valid(visual_value as Node3D):
			(visual_value as Node3D).position.y = safe_lift


func get_layering_state_for_test() -> Dictionary:
	var room := get_parent()
	var background: CanvasItem = null
	var scenery: CanvasItem = null
	var combat_fx: CanvasItem = null
	if room != null:
		background = room.get_node_or_null("Background") as CanvasItem
		scenery = room.get_node_or_null("ThreeQuarterPresentation/Scenery") as CanvasItem
		combat_fx = room.get_node_or_null("ThreeQuarterPresentation/CombatFX") as CanvasItem

	var min_actor_y := actor_ground_lift
	var actor_count := 0
	var curated_actor_count := 0
	var role_specific_actor_count := 0
	var procedural_actor_count := 0
	for visual_value: Variant in _actor_visuals.values():
		if visual_value is Node3D and is_instance_valid(visual_value as Node3D):
			var visual := visual_value as Node3D
			if actor_count == 0:
				min_actor_y = visual.position.y
			else:
				min_actor_y = minf(min_actor_y, visual.position.y)
			actor_count += 1
			if visual.has_method("get_visual_tier"):
				match str(visual.call("get_visual_tier")):
					"curated_cc0_humanoid":
						curated_actor_count += 1
					"role_specific_glb":
						role_specific_actor_count += 1
					_:
						procedural_actor_count += 1

	return {
		"background_hidden": background == null or not background.visible,
		"scenery_hidden": scenery == null or not scenery.visible,
		"combat_fx_visible": combat_fx == null or combat_fx.visible,
		"actor_visual_count": actor_count,
		"curated_actor_count": curated_actor_count,
		"role_specific_actor_count": role_specific_actor_count,
		"procedural_actor_count": procedural_actor_count,
		"min_actor_y": min_actor_y,
		"illustrated_ground_compression": illustrated_ground_compression,
		"illustrated_camera_elevation_degrees": rad_to_deg(asin(illustrated_ground_compression)),
		"illustrated_presentation_zoom": illustrated_presentation_zoom,
	}
