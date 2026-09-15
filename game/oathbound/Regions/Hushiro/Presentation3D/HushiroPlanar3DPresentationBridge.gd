extends "res://Utility/Planar3DPresentationBridge.gd"

## Hushiro-specific hardening and art-direction profile for the live planar-combat -> 3D
## presentation bridge.
##
## Combat ownership remains entirely in the existing 2D actors. This wrapper owns only
## the visual replacement contract: persistent legacy-art suppression, actor grounding,
## curated placeholder selection, combat-synced presentation VFX, and the Hushiro camera
## profile used to make real-time 3D read closer to illustrated 2D.

const HUSHIRO_ACTOR_VISUAL_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroCuratedActorVisual.gd")
const HUSHIRO_HOUND_VISUAL_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroHoundActorVisual.gd")
const HUSHIRO_ATTACK_VFX_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroAttackVFX.gd")

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
	var role := _role_for(actor)
	var visual_value: Variant = HUSHIRO_HOUND_VISUAL_SCRIPT.new() if role == "hound" else HUSHIRO_ACTOR_VISUAL_SCRIPT.new()
	if not (visual_value is Node3D):
		return
	var visual := visual_value as Node3D
	visual.name = "Actor3D_%s" % str(actor.get_instance_id())
	_world_root.add_child(visual)
	if visual.has_method("configure"):
		visual.call("configure", role, actor)

	# Sword arcs are deliberately separate from actor animation/model ownership. They read
	# authoritative action state only and can therefore be replaced independently by final
	# particles/shaders without touching combat timing or the final character GLBs.
	if role in ["player", "swordsman"]:
		var vfx_value: Variant = HUSHIRO_ATTACK_VFX_SCRIPT.new()
		if vfx_value is Node3D:
			var vfx := vfx_value as Node3D
			vfx.name = "HushiroAttackVFX"
			visual.add_child(vfx)
			if vfx.has_method("configure"):
				vfx.call("configure", role, actor)

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
	var player_actor_count := 0
	var swordsman_actor_count := 0
	var curated_actor_count := 0
	var animated_curated_actor_count := 0
	var hound_actor_count := 0
	var role_specific_actor_count := 0
	var procedural_actor_count := 0
	var contact_shadow_count := 0
	var attack_vfx_count := 0
	var first_curated_animation_state: Dictionary = {}
	for visual_value: Variant in _actor_visuals.values():
		if visual_value is Node3D and is_instance_valid(visual_value as Node3D):
			var visual := visual_value as Node3D
			if actor_count == 0:
				min_actor_y = visual.position.y
			else:
				min_actor_y = minf(min_actor_y, visual.position.y)
			actor_count += 1

			var role := str(visual.get("actor_role"))
			if role == "player":
				player_actor_count += 1
			elif role == "swordsman":
				swordsman_actor_count += 1

			contact_shadow_count += _count_named_descendants(visual, &"ContactShadow")
			var vfx := visual.get_node_or_null("HushiroAttackVFX")
			if vfx != null and vfx.has_method("is_contract_ready") and bool(vfx.call("is_contract_ready")):
				attack_vfx_count += 1

			if visual.has_method("get_visual_tier"):
				match str(visual.call("get_visual_tier")):
					"curated_cc0_humanoid":
						curated_actor_count += 1
						if visual.has_method("get_animation_tier") and str(visual.call("get_animation_tier")) == "curated_animation_library":
							animated_curated_actor_count += 1
							if first_curated_animation_state.is_empty() and visual.has_method("get_curated_animation_state_for_test"):
								var animation_state_value: Variant = visual.call("get_curated_animation_state_for_test")
								if animation_state_value is Dictionary:
									first_curated_animation_state = animation_state_value as Dictionary
					"hushiro_stylized_hound":
						hound_actor_count += 1
					"role_specific_glb":
						role_specific_actor_count += 1
					_:
						procedural_actor_count += 1

	var environment_state: Dictionary = {}
	if _environment_root != null and is_instance_valid(_environment_root) and _environment_root.has_method("get_presentation_state_for_test"):
		var environment_value: Variant = _environment_root.call("get_presentation_state_for_test")
		if environment_value is Dictionary:
			environment_state = environment_value as Dictionary

	var viewport_size := Vector2i.ZERO
	if _subviewport != null and is_instance_valid(_subviewport):
		viewport_size = _subviewport.size
	var canvas_layer_value := 0
	if _canvas_layer != null and is_instance_valid(_canvas_layer):
		canvas_layer_value = _canvas_layer.layer
	var texture_mouse_passthrough := false
	if _texture_rect != null and is_instance_valid(_texture_rect):
		texture_mouse_passthrough = _texture_rect.mouse_filter == Control.MOUSE_FILTER_IGNORE

	return {
		"background_hidden": background == null or not background.visible,
		"scenery_hidden": scenery == null or not scenery.visible,
		"combat_fx_visible": combat_fx == null or combat_fx.visible,
		"actor_visual_count": actor_count,
		"player_actor_count": player_actor_count,
		"swordsman_actor_count": swordsman_actor_count,
		"curated_actor_count": curated_actor_count,
		"animated_curated_actor_count": animated_curated_actor_count,
		"curated_animation_state": first_curated_animation_state,
		"hound_actor_count": hound_actor_count,
		"role_specific_actor_count": role_specific_actor_count,
		"procedural_actor_count": procedural_actor_count,
		"contact_shadow_count": contact_shadow_count,
		"attack_vfx_count": attack_vfx_count,
		"min_actor_y": min_actor_y,
		"illustrated_ground_compression": illustrated_ground_compression,
		"illustrated_camera_elevation_degrees": rad_to_deg(asin(illustrated_ground_compression)),
		"illustrated_presentation_zoom": illustrated_presentation_zoom,
		"viewport_size": viewport_size,
		"camera3d_orthogonal": _camera3d != null and is_instance_valid(_camera3d) and _camera3d.projection == Camera3D.PROJECTION_ORTHOGONAL,
		"camera3d_current": _camera3d != null and is_instance_valid(_camera3d) and _camera3d.current,
		"presentation_canvas_layer": canvas_layer_value,
		"texture_mouse_passthrough": texture_mouse_passthrough,
		"environment_state": environment_state,
	}


func _count_named_descendants(node: Node, target_name: StringName) -> int:
	var count := 0
	for child: Node in node.get_children():
		if child.name == target_name:
			count += 1
		count += _count_named_descendants(child, target_name)
	return count
