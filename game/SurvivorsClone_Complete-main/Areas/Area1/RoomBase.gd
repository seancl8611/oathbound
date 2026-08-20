extends Node2D
class_name RoomBase

signal room_cleared

var cleared: bool = false


func _ready() -> void:
	# Subclasses should call super._ready() if they override this
	pass


func scripted_walk_in(player: Node) -> void:
	if player and player.has_method("set_control_enabled"):
		player.set_control_enabled(false)
	await get_tree().create_timer(0.35).timeout
	if player:
		var target: Vector2 = player.global_position + Vector2(0, -48)
		var t: float = 0.0
		while t < 0.25:
			t += get_process_delta_time()
			player.global_position = player.global_position.lerp(target, 0.25)
			await get_tree().process_frame
	if player and player.has_method("set_control_enabled"):
		player.set_control_enabled(true)


func decorate_exit_gates(next_type: String) -> void:
	for g in get_tree().get_nodes_in_group("mist_gates"):
		if g.has_method("set_indicator"):
			g.set_indicator(next_type)


func _is_gate_in_this_room(g: Node) -> bool:
	return g != null and self.is_ancestor_of(g)


func lock_all_gates() -> void:
	for gate_name: String in ["ExitGate", "ExitGate2", "ExitGate3"]:
		var gate := get_node_or_null(gate_name)
		if gate and gate.has_method("lock"):
			gate.lock()


func unlock_all_gates() -> void:
	for gate_name: String in ["ExitGate", "ExitGate2", "ExitGate3"]:
		var gate := get_node_or_null(gate_name)
		if gate and gate.has_method("unlock"):
			gate.unlock()


func connect_exit_gates_to_flow() -> void:
	for gate_name: String in ["ExitGate", "ExitGate2", "ExitGate3"]:
		var gate := get_node_or_null(gate_name)
		if gate and gate.has_signal("gate_used"):
			var cb := Callable(self, "_on_gate_used").bind(gate)
			if not gate.is_connected("gate_used", cb):
				gate.connect("gate_used", cb)


func _on_gate_used(next_type: String, gate: Node = null) -> void:
	var chosen := next_type
	if gate != null and gate.has_meta("next_room_type"):
		chosen = str(gate.get_meta("next_room_type"))

	print("[RoomBase] gate_used → chosen=%s (signal=%s)" % [chosen, next_type])

	if chosen != "" and typeof(GameFlow) == TYPE_OBJECT:
		if GameFlow.has_method("make_choice"):
			GameFlow.make_choice(chosen)
		else:
			GameFlow.next_room()


func setup_exit_gates(options: Array) -> void:
	var gate1 := get_node_or_null("ExitGate")
	var gate2 := get_node_or_null("ExitGate2")
	var gate3 := get_node_or_null("ExitGate3")

	if options.is_empty():
		_decorate_single_gate(gate1, "End")
		_hide_and_lock_gate(gate2)
		_hide_and_lock_gate(gate3)
		return

	if options.size() == 1:
		_decorate_single_gate(gate1, str(options[0]))
		if gate1:
			gate1.set_meta("next_room_type", options[0])
		_hide_and_lock_gate(gate2)
		_hide_and_lock_gate(gate3)
		return

	# Standard Hades-like two-exit presentation.
	_decorate_single_gate(gate1, str(options[0]))
	if gate1:
		gate1.set_meta("next_room_type", options[0])

	if gate2:
		_decorate_single_gate(gate2, str(options[1]))
		gate2.set_meta("next_room_type", options[1])
		if gate2 is CanvasItem:
			(gate2 as CanvasItem).visible = true
	else:
		push_warning("[RoomBase] Room needs ExitGate2 node for choice display!")

	if options.size() >= 3:
		gate3 = _ensure_third_gate(gate1, gate2)
		if gate3:
			_decorate_single_gate(gate3, str(options[2]))
			gate3.set_meta("next_room_type", options[2])
			if gate3 is CanvasItem:
				(gate3 as CanvasItem).visible = true

			# GameFlow's existing setup pass knows about the two authored gate nodes.
			# Wire this dynamic third gate into that same authoritative callback here.
			if typeof(GameFlow) == TYPE_OBJECT and GameFlow.has_method("_wire_gate_to_gameflow"):
				GameFlow.call("_wire_gate_to_gameflow", gate3)
	else:
		_hide_and_lock_gate(gate3)


func _ensure_third_gate(gate1: Node, gate2: Node) -> Node:
	var existing := get_node_or_null("ExitGate3")
	if existing:
		return existing

	var template: Node = gate2 if gate2 != null else gate1
	if template == null:
		push_warning("[RoomBase] Cannot create ExitGate3 without an existing Mist Gate template.")
		return null

	# Exclude signal duplication; GameFlow wires the new gate explicitly after creation.
	var flags := Node.DUPLICATE_GROUPS | Node.DUPLICATE_SCRIPTS | Node.DUPLICATE_USE_INSTANTIATION
	var gate3 := template.duplicate(flags)
	gate3.name = "ExitGate3"
	add_child(gate3)

	# The authored gates were locked earlier in room _ready(). A dynamically-created
	# third gate must enter the same locked state so it cannot bypass combat/reward clear.
	if gate3.has_method("lock"):
		gate3.lock()

	if gate3 is Node2D:
		var p3 := (gate3 as Node2D).position
		if gate1 is Node2D and gate2 is Node2D:
			var p1 := (gate1 as Node2D).position
			var p2 := (gate2 as Node2D).position
			var delta := p2 - p1
			if absf(delta.x) >= absf(delta.y):
				p3 = (p1 + p2) * 0.5 + Vector2(0, -64)
			else:
				p3 = (p1 + p2) * 0.5 + Vector2(64, 0)
		else:
			p3 += Vector2(64, 0)
		(gate3 as Node2D).position = p3

	return gate3


func _hide_and_lock_gate(gate: Node) -> void:
	if gate == null:
		return
	if gate is CanvasItem:
		(gate as CanvasItem).visible = false
	if gate.has_method("lock"):
		gate.lock()


func _decorate_single_gate(gate: Node, room_type: String) -> void:
	if gate == null:
		return

	var info = RouteGenerator.get_room_display_info(room_type)

	var label = gate.get_node_or_null("Label")
	if label and label is Label:
		label.text = "%s\n%s" % [info.icon, room_type]
		label.add_theme_color_override("font_color", info.color)

	var sprite = gate.get_node_or_null("Sprite2D")
	if sprite and sprite is Sprite2D:
		sprite.modulate = info.color

	if gate.has_method("set_indicator"):
		gate.set_indicator(room_type)
