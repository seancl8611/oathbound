extends "res://autoload/OathboundGameFlow.gd"

## Region-aware run lifecycle layered on the current Oathbound GameFlow.
## Normal progression still uses OathboundGameFlow's room/player authorities, while
## this layer owns regional choice boundaries and debug warps so unresolved route
## choices cannot instantiate orphan Players and Region 2+ use their authored route
## authorities rather than the imported generic RouteGenerator path.

const EXPECTED_REGION_PLAYTEST_LAB_SCRIPT := "res://Core/Regions/OathboundRegionPlaytestLab.gd"

var _active_area_transition: CanvasLayer = null


func _assert_current_playtest_lab() -> void:
	_assert_autoload_script("PlaytestLab", EXPECTED_REGION_PLAYTEST_LAB_SCRIPT, true)


func _load_current_room() -> void:
	# OathboundGameFlow creates the canonical Player before delegating to the imported
	# router. If the current route slot is still an unresolved choice, the imported
	# router returns without loading a room, leaving that freshly instantiated Player
	# unparented. Intercept choice slots before the Player factory runs. A Player should
	# only exist once a concrete chamber has been selected and can own it.
	if current_index >= 0 and current_index < route.size():
		var token := str(route[current_index])
		if token.begins_with("CHOICE_"):
			var area_id: int = int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else current_area
			if typeof(SceneRegistry) == TYPE_OBJECT and SceneRegistry.has_method("activate_area"):
				SceneRegistry.call("activate_area", area_id)
			var slot := int(token.split("_")[1])
			_present_choice(slot)
			return

	await super._load_current_room()


# =============================================================================
# REGION TRANSITION PRESENTATION
# =============================================================================
# The imported transition returned after a fixed 2.4-second timer even though its
# visual tween lasted 3.5 seconds. Regions 2 and 3 intentionally begin on CHOICE_*
# slots, and RunScene pauses the SceneTree when that choice is presented. That pause
# froze the still-active layer-200 transition above the layer-100 choice UI, producing
# an apparent permanent transition-screen hang after Keeper/Twin Maws.
#
# Current regional authority owns this seam. The transition is scene-scoped, survives
# incidental SceneTree pauses, and does not return until its overlay is fully removed.
# This makes "transition presentation finished" a real lifecycle boundary before any
# route choice, room load, checkpoint write, or other modal UI can begin.
func _show_area_transition(area_id: int) -> void:
	_clear_stale_area_transition()

	var canvas := CanvasLayer.new()
	canvas.name = "AreaTransition"
	canvas.layer = 200
	canvas.process_mode = Node.PROCESS_MODE_ALWAYS
	_active_area_transition = canvas

	var host: Node = get_tree().current_scene
	if host == null or not is_instance_valid(host):
		host = get_tree().root
	host.add_child(canvas)

	var container := Control.new()
	container.name = "TransitionContainer"
	container.process_mode = Node.PROCESS_MODE_ALWAYS
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	container.mouse_filter = Control.MOUSE_FILTER_STOP
	canvas.add_child(container)

	var bg := ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	bg.mouse_filter = Control.MOUSE_FILTER_STOP
	container.add_child(bg)

	var area_label := Label.new()
	area_label.text = "— Area %d —" % area_id
	area_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	area_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	area_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	area_label.add_theme_font_size_override("font_size", 22)
	area_label.add_theme_color_override("font_color", Color(0.6, 0.55, 0.4))
	area_label.offset_bottom = -30
	area_label.modulate.a = 0.0
	area_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(area_label)

	var title := Label.new()
	title.text = AREA_NAMES.get(area_id, "Unknown Realm")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	title.modulate.a = 0.0
	title.mouse_filter = Control.MOUSE_FILTER_IGNORE
	container.add_child(title)

	var tween := get_tree().create_tween()
	# Any modal UI can pause the SceneTree. A transition must still finish instead of
	# becoming a permanent root/scene overlay that hides the modal which caused pause.
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(title, "modulate:a", 1.0, 0.6)
	tween.tween_property(area_label, "modulate:a", 1.0, 0.3)
	tween.tween_interval(1.8)
	tween.tween_property(container, "modulate:a", 0.0, 0.8)
	await tween.finished

	if is_instance_valid(canvas):
		canvas.queue_free()
	if _active_area_transition == canvas:
		_active_area_transition = null
	# queue_free() is deferred. Do not allow a CHOICE_* signal to pause the tree until
	# the overlay is actually gone from the scene tree.
	await get_tree().process_frame


func is_area_transition_active() -> bool:
	return _active_area_transition != null and is_instance_valid(_active_area_transition)


func _clear_stale_area_transition() -> void:
	if _active_area_transition != null and is_instance_valid(_active_area_transition):
		_active_area_transition.free()
	_active_area_transition = null

	# Clean up only the exact transition node owned by this lifecycle. This also
	# removes an overlay stranded by an older build before another region handoff.
	var scene: Node = get_tree().current_scene
	if scene != null and is_instance_valid(scene):
		var stale_scene := scene.get_node_or_null("AreaTransition")
		if stale_scene != null and is_instance_valid(stale_scene):
			stale_scene.free()
	var stale_root := get_tree().root.get_node_or_null("AreaTransition")
	if stale_root != null and is_instance_valid(stale_root):
		stale_root.free()


func _execute_debug_warp(area_id: int, room_token: String) -> void:
	current_area = area_id
	_awaiting_choice = false
	_choice_slot = -1

	if typeof(RunData) == TYPE_OBJECT:
		RunData.reset_for_new_run(area_id)
		RunData.current_area_id = area_id

	if typeof(SceneRegistry) == TYPE_OBJECT and SceneRegistry.has_method("activate_area"):
		SceneRegistry.call("activate_area", area_id)

	# Critical difference from the imported debug warp: use the current regional
	# route authority. Region 2 therefore uses YomoriRouteAuthority rather than the
	# legacy generic RouteGenerator implementation.
	build_route_for_area(area_id)

	var requested_base := room_token.to_lower()
	var target_index := -1

	# Prefer a fixed/resolved slot already present in the authored route.
	for i in range(route.size()):
		var token := str(route[i])
		if token.begins_with("CHOICE_"):
			continue
		if RouteGenerator.get_base_room_type(token).to_lower() == requested_base:
			target_index = i
			break

	# Then inspect authored choice opportunities and resolve the requested option.
	if target_index == -1:
		for slot_value: Variant in RouteGenerator.pending_choices.keys():
			var slot := int(slot_value)
			var options_value: Variant = RouteGenerator.pending_choices.get(slot, [])
			if not (options_value is Array):
				continue
			for option_value: Variant in options_value:
				var option := str(option_value)
				if RouteGenerator.get_base_room_type(option).to_lower() != requested_base:
					continue
				RouteGenerator.resolve_choice(slot, option)
				if slot >= 0 and slot < route.size():
					route[slot] = option
					target_index = slot
				break
			if target_index != -1:
				break

	# Treasure is eligible but intentionally not guaranteed in Yomori. Other future
	# authored regions can have similar optional room types. For a targeted debug
	# test, load that current room authority directly instead of silently warping to
	# an unrelated chamber.
	if target_index == -1:
		route = [requested_base]
		target_index = 0
		print("[OathboundGameFlow] DEBUG WARP direct isolated room: Area %d -> '%s'" % [area_id, requested_base])
	else:
		# Resolve unresolved choice slots before the target so route metadata remains
		# coherent if the tester exits the isolated chamber and continues briefly.
		for i in range(target_index + 1):
			if not str(route[i]).begins_with("CHOICE_"):
				continue
			var slot := int(str(route[i]).split("_")[1])
			var options := RouteGenerator.get_choice_options(slot)
			if options.size() > 0:
				RouteGenerator.resolve_choice(slot, str(options[0]))
				route[i] = str(options[0])

	current_index = target_index
	_load_current_room()
	print("[OathboundGameFlow] DEBUG WARP current authority: Area %d -> '%s' (index %d)" % [area_id, requested_base, target_index])
