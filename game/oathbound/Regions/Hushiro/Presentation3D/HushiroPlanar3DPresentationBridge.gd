extends "res://Utility/Planar3DPresentationBridge.gd"

## Hushiro-specific hardening for the live planar-combat -> 3D presentation bridge.
##
## The first real-player 3D playtest exposed two presentation-only failures:
## - legacy opaque 2D room dressing could become visible again above the 3D SubViewport;
## - mirrored actor roots sat exactly on Y=0 while temporary 3D floor pieces rise a few
##   centimeters above that plane, visually burying feet/lower bodies.
##
## Combat ownership remains entirely in the existing 2D actors. This wrapper only makes
## the Hushiro visual replacement deterministic while the production 3D path is proven.

@export var actor_ground_lift: float = 0.10


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
	for visual_value: Variant in _actor_visuals.values():
		if visual_value is Node3D and is_instance_valid(visual_value as Node3D):
			var visual := visual_value as Node3D
			if actor_count == 0:
				min_actor_y = visual.position.y
			else:
				min_actor_y = minf(min_actor_y, visual.position.y)
			actor_count += 1

	return {
		"background_hidden": background == null or not background.visible,
		"scenery_hidden": scenery == null or not scenery.visible,
		"combat_fx_visible": combat_fx == null or combat_fx.visible,
		"actor_visual_count": actor_count,
		"min_actor_y": min_actor_y,
	}
