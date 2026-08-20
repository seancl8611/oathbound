# GameFlow.gd
# Autoload - Core run management with Hades-style choice support
# Add to Project > Project Settings > Autoload as "GameFlow"
extends Node

signal room_changed(room_name: String)
signal choice_presented(options: Array, slot_index: int)
signal run_completed(area_id: int)


const PLAYER_SCENE_PATH = "res://Player/player.tscn"
const HUB_SCENE_PATH = "res://World/HubScene.tscn"

var route: Array[String] = []
var current_index: int = 0
var player: Node = null
var room_container: Node = null
var _player_packed: PackedScene = null
var _upgrade_ui: Node = null
var AREA_NAMES = {
	1: "The Mist Veil",
	2: "The Ashen Depths",
	3: "The Shattered Peak"
}
# Add near the top with other vars
var current_area: int = 1
var max_area: int = 3  # hub -> area1 -> area2 -> area3 -> hub

# Choice state
var _awaiting_choice: bool = false
var _choice_slot: int = -1

func setup(container: Node) -> void:
	room_container = container

func set_player(p: Node) -> void:
	player = p

func set_route(new_route: Array[String]) -> void:
	route = new_route.duplicate()
	current_index = 0

func start_run() -> void:
	# Check for debug warp override
	if not _debug_warp_pending.is_empty():
		var warp = _debug_warp_pending.duplicate()
		_debug_warp_pending = {}
		if _player_packed == null:
			if ResourceLoader.exists(PLAYER_SCENE_PATH):
				_player_packed = load(PLAYER_SCENE_PATH)
		_execute_debug_warp(int(warp.area), str(warp.room))
		return

	if route.is_empty():
		push_error("GameFlow.start_run(): route is empty.")
		return
	if _player_packed == null:
		if ResourceLoader.exists(PLAYER_SCENE_PATH):
			_player_packed = load(PLAYER_SCENE_PATH)
		else:
			push_error("GameFlow: PLAYER_SCENE_PATH not found: " + PLAYER_SCENE_PATH)
	current_index = 0
	_awaiting_choice = false
	_load_current_room()

func next_room() -> void:
	# Track progress in RunData if it exists
	if current_index < route.size():
		var token = str(route[current_index])
		if not token.begins_with("CHOICE_"):
			var rd = get_node_or_null("/root/RunData")
			if rd and rd.has_method("advance_depth"):
				rd.advance_depth(token)

	if current_index < route.size() - 1:
		current_index += 1

		var next_key = route[current_index]
		if next_key.begins_with("CHOICE_"):
			var slot = int(next_key.split("_")[1])
			_present_choice(slot)
		else:
			_load_current_room()
	else:
		# Area complete
		emit_signal("run_completed", current_area)
		
		if current_area < max_area:
			_advance_to_next_area()
		else:
			# Full run complete — return to hub
			current_area = 1
			get_tree().change_scene_to_file(HUB_SCENE_PATH)

func _advance_to_next_area() -> void:
	current_area += 1
	print("[GameFlow] Advancing to Area %d" % current_area)
	
	var rd = get_node_or_null("/root/RunData")
	if rd:
		rd.current_area_id = current_area
	
	# Show title card (awaits through the hold, room loads during fade-out)
	await _show_area_transition(current_area)
	
	route = RouteGenerator.generate_area_route(current_area)
	current_index = 0
	_awaiting_choice = false
	_choice_slot = -1
	
	_load_current_room()
	
func make_choice(chosen_room: String) -> void:
	if not _awaiting_choice:
		push_warning("[GameFlow] make_choice called but not awaiting choice")
		return
	
	# Resolve in RouteGenerator
	RouteGenerator.resolve_choice(_choice_slot, chosen_room)
	
	# Update local route
	route[current_index] = chosen_room
	
	_awaiting_choice = false
	_choice_slot = -1
	
	# Now load the chosen room
	_load_current_room()

func _present_choice(slot_index: int) -> void:
	_awaiting_choice = true
	_choice_slot = slot_index
	
	var options = RouteGenerator.get_choice_options(slot_index)
	print("[GameFlow] Choice at slot %d: %s" % [slot_index, options])
	emit_signal("choice_presented", options, slot_index)

func peek_next_type() -> String:
	if current_index < route.size() - 1:
		var next_key = route[current_index + 1]
		if next_key.begins_with("CHOICE_"):
			return "Choice"
		return next_key
	return "End"

## Returns choice options if next room is a choice, empty otherwise
func peek_next_choice_options() -> Array:
	if current_index < route.size() - 1:
		var next_key = route[current_index + 1]
		if next_key.begins_with("CHOICE_"):
			var slot = int(next_key.split("_")[1])
			return RouteGenerator.get_choice_options(slot)
	return []

## Check if we're currently waiting for a choice
func is_awaiting_choice() -> bool:
	return _awaiting_choice

func get_progress() -> Dictionary:
	return {
		"current": current_index,
		"total": route.size(),
		"room_type": route[current_index] if current_index < route.size() else "None"
	}

func _load_current_room() -> void:
	if room_container == null:
		push_error("[GameFlow] room_container not set")
		return
	if route.is_empty():
		push_error("[GameFlow] route is empty")
		return
	if current_index < 0 or current_index >= route.size():
		push_error("[GameFlow] current_index out of range: %d (route size=%d)" % [current_index, route.size()])
		return

	var token: String = str(route[current_index])

	# Handle unresolved choice
	if token.begins_with("CHOICE_"):
		var slot := int(token.split("_")[1])
		_present_choice(slot)
		return

	var reg := get_node_or_null("/root/SceneRegistry")
	if reg == null:
		push_error("[GameFlow] SceneRegistry autoload missing (/root/SceneRegistry)")
		return

	# IMPORTANT: route can now contain tokens like "combat:boon"
	var base_key = RouteGenerator.get_base_room_type(token) # "combat"
	var lookup_key = base_key.to_lower()

	var rooms_dict: Dictionary = reg.rooms
	var packed: PackedScene = rooms_dict.get(lookup_key, null)

	print("[GameFlow] _load_current_room(): idx=%d token=%s base=%s packed=%s" %
		[current_index, token, lookup_key, str(packed)])

	if packed == null:
		push_error("[GameFlow] Missing room scene for token=%s (base=%s) in SceneRegistry.rooms" %
			[token, lookup_key])
		return

	# Detach player while clearing the container
	if player and player.get_parent():
		player.get_parent().remove_child(player)

	for c in room_container.get_children():
		c.queue_free()
	await get_tree().process_frame

	var room: Node = packed.instantiate()
	room.add_to_group("room")
	
	# Set metadata BEFORE adding to tree so _ready() can read it
	var reward_key = RouteGenerator.get_reward_key(token)
	var area_id = 1
	var rd = get_node_or_null("/root/RunData")
	if rd:
		area_id = rd.current_area_id
	room.set_meta("reward_key", reward_key)
	room.set_meta("area_id", area_id)
	
	room_container.add_child(room)
	
	await get_tree().process_frame

	# Ensure we have a player instance
	if player == null:
		if _player_packed == null:
			_player_packed = load(PLAYER_SCENE_PATH)
			if _player_packed == null:
				push_error("[GameFlow] Could not load Player scene at " + PLAYER_SCENE_PATH)
				return
		player = _player_packed.instantiate()

	# Add player hidden, then place & reveal
	if player is Node:
		player.set_physics_process(false)
	if player is CanvasItem:
		player.visible = false
	if not player.is_in_group("player"):
		player.add_to_group("player")

	room_container.add_child(player)
	await get_tree().process_frame

	# Position at spawn
	var target_pos := (player as Node2D).global_position if player is Node2D else Vector2.ZERO
	var spawn := room.get_node_or_null("PlayerSpawn")
	if spawn and player is Node2D and spawn is Node2D:
		target_pos = (spawn as Node2D).global_position

	if player is Node2D:
		(player as Node2D).global_position = target_pos

	# Reveal / enable
	if player is Node:
		player.set_physics_process(true)
	if player is CanvasItem:
		player.visible = true
		player.modulate.a = 1.0

	# Setup exit gates with next room info
	_setup_exit_gates(room)

	# Connect clear signal
	if room.has_signal("room_cleared"):
		if not room.is_connected("room_cleared", Callable(self, "_on_room_cleared")):
			room.connect("room_cleared", Callable(self, "_on_room_cleared").bind(room))

	emit_signal("room_changed", token)

func _setup_exit_gates(room: Node) -> void:
	var next_type := peek_next_type()
	var choice_options := peek_next_choice_options()

	# Let the room configure its own visuals if it wants, but GameFlow remains authoritative.
	if room and room.has_method("setup_exit_gates"):
		if choice_options.size() >= 2:
			room.setup_exit_gates(choice_options)
		else:
			room.setup_exit_gates([next_type])

	print("[GameFlow] gates: idx=%d key=%s next_type=%s choice_options=%s" %
	[current_index, route[current_index], next_type, str(choice_options)])

	var gate1: Node = room.get_node_or_null("ExitGate")
	var gate2: Node = room.get_node_or_null("ExitGate2")

	# Assign meta + decorate
	if choice_options.size() >= 2:
		_decorate_gate(gate1, choice_options[0])
		if gate1:
			gate1.set_meta("next_room_type", choice_options[0])

		_decorate_gate(gate2, choice_options[1])
		if gate2:
			gate2.set_meta("next_room_type", choice_options[1])
			if gate2 is CanvasItem:
				(gate2 as CanvasItem).visible = true
	else:
		_decorate_gate(gate1, next_type)
		if gate1:
			gate1.set_meta("next_room_type", next_type)
		if gate2 and gate2 is CanvasItem:
			(gate2 as CanvasItem).visible = false
	
	# --- CRITICAL: wire gates here so every room works ---
	_wire_gate_to_gameflow(gate1)
	_wire_gate_to_gameflow(gate2)


func _wire_gate_to_gameflow(gate: Node) -> void:
	if gate == null:
		return
	if not gate.has_signal("gate_used"):
		return

	# Disconnect any previous connection to avoid duplicate callbacks when rooms reload.
	var cb := Callable(self, "_on_gate_used_from_gate").bind(gate)
	if gate.is_connected("gate_used", cb):
		gate.disconnect("gate_used", cb)

	gate.connect("gate_used", cb)

func _on_gate_used_from_gate(_signal_type: String, gate: Node) -> void:
	if gate == null or not is_instance_valid(gate):
		return

	var chosen := ""
	if gate.has_meta("next_room_type"):
		chosen = str(gate.get_meta("next_room_type"))

	print("[GameFlow] gate_used -> chosen=%s" % chosen)
	if chosen == "":
		return

	# Decide based on what the NEXT route slot actually is.
	if current_index < route.size() - 1:
		var next_key := route[current_index + 1]

		# If next slot is a CHOICE placeholder, resolve it immediately from the gate.
		if next_key.begins_with("CHOICE_"):
			var slot := int(next_key.split("_")[1])
			RouteGenerator.resolve_choice(slot, chosen)
			route[current_index + 1] = chosen
			current_index += 1
			_load_current_room()
			return

	# Otherwise it's a linear step.
	next_room()

func _decorate_gate(gate: Node, room_type: String) -> void:
	if gate == null:
		return

	var info = RouteGenerator.get_room_display_info(room_type)

	var label = gate.get_node_or_null("Label")
	if label and label is Label:
		label.text = "%s\n%s" % [info.icon, str(room_type)]
		label.add_theme_color_override("font_color", info.color)

	var sprite = gate.get_node_or_null("Sprite2D")
	if sprite and sprite is Sprite2D:
		sprite.modulate = info.color

	if gate.has_method("set_indicator"):
		gate.set_indicator(room_type)

func _on_room_cleared(room: Node) -> void:
	if room and room.has_method("post_clear"):
		await room.post_clear()
		
func build_area1_route() -> void:
	current_area = 1
	route = RouteGenerator.generate_area_route(current_area)
	current_index = 0

func build_area1_route_single_pass() -> void:
	build_area1_route()
	
## Simple test route without choices (for debugging)
func build_test_route() -> void:
	route = ["Combat", "Combat", "Rest", "Treasure", "Shop", "Boss"]
	current_index = 0

func _show_area_transition(area_id: int) -> void:
	var canvas = CanvasLayer.new()
	canvas.name = "AreaTransition"
	canvas.layer = 200
	get_tree().root.add_child(canvas)
	
	# Container Control so we can fade everything at once
	var container = Control.new()
	container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	canvas.add_child(container)
	
	# Full screen dark overlay
	var bg = ColorRect.new()
	bg.color = Color(0.0, 0.0, 0.0, 1.0)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	container.add_child(bg)
	
	# Area number label (smaller, above title)
	var area_label = Label.new()
	area_label.text = "— Area %d —" % area_id
	area_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	area_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	area_label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	area_label.add_theme_font_size_override("font_size", 22)
	area_label.add_theme_color_override("font_color", Color(0.6, 0.55, 0.4))
	area_label.offset_bottom = -30
	area_label.modulate.a = 0.0
	container.add_child(area_label)
	
	# Area name label (large, centered)
	var title = Label.new()
	title.text = AREA_NAMES.get(area_id, "Unknown Realm")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	title.modulate.a = 0.0
	container.add_child(title)
	
	# Animate: fade in title, hold, fade out container (which is a Control = has modulate)
	var tw = get_tree().create_tween()
	tw.tween_property(title, "modulate:a", 1.0, 0.6)
	tw.tween_property(area_label, "modulate:a", 1.0, 0.3)
	tw.tween_interval(1.8)
	tw.tween_property(container, "modulate:a", 0.0, 0.8)
	tw.tween_callback(func():
		if is_instance_valid(canvas):
			canvas.queue_free()
	)
	
	# Wait for fade-in + hold before returning (room loads during fade-out)
	await get_tree().create_timer(2.4).timeout

# =============================================================================
# DEBUG WARP — Skip directly to any room in any area
# =============================================================================
var _debug_warp_pending = {}

func debug_warp(area_id: int, room_token: String) -> void:
	if room_container != null and room_container.is_inside_tree():
		_execute_debug_warp(area_id, room_token)
	else:
		# Not in RunScene yet — queue warp and switch scenes
		_debug_warp_pending = {"area": area_id, "room": room_token}
		get_tree().change_scene_to_file("res://Utility/RunScene.tscn")

func _execute_debug_warp(area_id: int, room_token: String) -> void:
	current_area = area_id
	_awaiting_choice = false
	_choice_slot = -1

	var rd = get_node_or_null("/root/RunData")
	if rd:
		rd.reset_for_new_run(area_id)

	# Generate route for target area
	route = RouteGenerator.generate_area_route(area_id)

	# Find first slot matching the requested room type
	var target_index = -1

	# Check fixed/resolved slots first
	for i in range(route.size()):
		if route[i].begins_with("CHOICE_"):
			continue
		var base = RouteGenerator.get_base_room_type(route[i])
		if base == room_token:
			target_index = i
			break

	# If not found in fixed slots, check choice slots
	if target_index == -1:
		for slot in RouteGenerator.pending_choices:
			var options = RouteGenerator.pending_choices[slot]
			for opt in options:
				var opt_base = RouteGenerator.get_base_room_type(opt)
				if opt_base == room_token:
					RouteGenerator.resolve_choice(slot, opt)
					route[slot] = opt
					target_index = slot
					break
			if target_index != -1:
				break

	if target_index == -1:
		push_warning("[GameFlow] DEBUG WARP: Could not find '%s' in area %d, defaulting to index 0" % [room_token, area_id])
		target_index = 0

	# Resolve any choice slots up to and including our target
	for i in range(target_index + 1):
		if route[i].begins_with("CHOICE_"):
			var slot = int(route[i].split("_")[1])
			var options = RouteGenerator.get_choice_options(slot)
			if options.size() > 0:
				RouteGenerator.resolve_choice(slot, options[0])
				route[i] = options[0]

	current_index = target_index
	_load_current_room()
	print("[GameFlow] DEBUG WARP: Area %d -> '%s' (index %d)" % [area_id, room_token, target_index])
