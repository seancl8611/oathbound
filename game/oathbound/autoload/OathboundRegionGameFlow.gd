extends "res://autoload/OathboundGameFlow.gd"

## Region-aware run lifecycle layered on the current Oathbound GameFlow.
## Normal progression still uses OathboundGameFlow's room/player authorities, while
## this layer owns regional choice boundaries and debug warps so unresolved route
## choices cannot instantiate orphan Players and Region 2+ use their authored route
## authorities rather than the imported generic RouteGenerator path.

const EXPECTED_REGION_PLAYTEST_LAB_SCRIPT := "res://Core/Regions/OathboundRegionPlaytestLab.gd"
const KEEPER_READABILITY_RUNTIME: Script = preload("res://Core/Release/OathboundKeeperReadabilityRuntime.gd")
const AREA_TRANSITION_CLEANUP_TIMEOUT := 2.0


func _ready() -> void:
	super._ready()
	var runtime_value: Variant = KEEPER_READABILITY_RUNTIME.new()
	if runtime_value is Node:
		var runtime := runtime_value as Node
		runtime.name = "KeeperReadabilityRuntime"
		add_child(runtime)
	else:
		push_error("[OathboundGameFlow] Could not instantiate Keeper readability runtime")


func _assert_current_playtest_lab() -> void:
	_assert_autoload_script("PlaytestLab", EXPECTED_REGION_PLAYTEST_LAB_SCRIPT, true)


func _show_area_transition(area_id: int) -> void:
	# Imported GameFlow returns from its transition presentation after the title hold,
	# while its layer-200 fade-out is still running for roughly another second. Yomori
	# and Kagutsuchi intentionally begin on an immediate CHOICE_ slot. RunScene pauses
	# the tree as soon as that choice is presented, which used to freeze the higher
	# transition layer over the layer-100 choice UI and make the run look softlocked.
	# Keep the imported presentation, but do not allow regional routing to continue
	# until that presentation is actually gone.
	await super._show_area_transition(area_id)
	var started_at: float = Time.get_ticks_msec() * 0.001
	var overlay: Node = get_tree().root.get_node_or_null("AreaTransition")
	while overlay != null and is_instance_valid(overlay):
		if Time.get_ticks_msec() * 0.001 - started_at >= AREA_TRANSITION_CLEANUP_TIMEOUT:
			push_warning("[OathboundGameFlow] Area transition overlay exceeded cleanup timeout; removing stale presentation layer")
			overlay.queue_free()
			await get_tree().process_frame
			break
		await get_tree().process_frame
		overlay = get_tree().root.get_node_or_null("AreaTransition")


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
