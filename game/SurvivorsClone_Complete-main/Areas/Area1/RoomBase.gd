extends Node2D
class_name RoomBase

signal room_cleared

var cleared: bool = false

func _ready() -> void:
	# Subclasses should call super._ready() if they override this
	pass

func scripted_walk_in(player: Node) -> void:
	# Optional: briefly disable control and nudge player forward
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
	# Set all exit gates to display what's next
	for g in get_tree().get_nodes_in_group("mist_gates"):
		if g.has_method("set_indicator"):
			g.set_indicator(next_type)
			
func _is_gate_in_this_room(g: Node) -> bool:
	return g != null and self.is_ancestor_of(g)

func lock_all_gates() -> void:
	var gate1 = get_node_or_null("ExitGate")
	var gate2 = get_node_or_null("ExitGate2")

	if gate1 and gate1.has_method("lock"):
		gate1.lock()
	if gate2 and gate2.has_method("lock"):
		gate2.lock()

func unlock_all_gates() -> void:
	var gate1 = get_node_or_null("ExitGate")
	var gate2 = get_node_or_null("ExitGate2")

	if gate1 and gate1.has_method("unlock"):
		gate1.unlock()
	if gate2 and gate2.has_method("unlock"):
		gate2.unlock()

func connect_exit_gates_to_flow() -> void:
	var gate1 = get_node_or_null("ExitGate")
	var gate2 = get_node_or_null("ExitGate2")

	if gate1 and gate1.has_signal("gate_used"):
		if not gate1.is_connected("gate_used", Callable(self, "_on_gate_used")):
			gate1.connect("gate_used", Callable(self, "_on_gate_used").bind(gate1))

	if gate2 and gate2.has_signal("gate_used"):
		if not gate2.is_connected("gate_used", Callable(self, "_on_gate_used")):
			gate2.connect("gate_used", Callable(self, "_on_gate_used").bind(gate2))
	
func _on_gate_used(next_type: String, gate: Node = null) -> void:
	# Prefer the authoritative value GameFlow assigns to gates.
	var chosen := next_type
	if gate != null and gate.has_meta("next_room_type"):
		chosen = str(gate.get_meta("next_room_type"))

	print("[RoomBase] gate_used → chosen=%s (signal=%s)" % [chosen, next_type])

	# If it's a choice room type, commit the choice; otherwise advance normally.
	if chosen != "" and typeof(GameFlow) == TYPE_OBJECT:
		if GameFlow.has_method("make_choice"):
			GameFlow.make_choice(chosen)
		else:
			# Fallback: if make_choice doesn't exist, just advance.
			GameFlow.next_room()

func setup_exit_gates(options: Array) -> void:
	var gate1 = get_node_or_null("ExitGate")
	var gate2 = get_node_or_null("ExitGate2")
	
	if options.is_empty():
		# End of run
		_decorate_single_gate(gate1, "End")
		if gate2:
			gate2.visible = false
			if gate2.has_method("lock"):
				gate2.lock()
		return
	
	if options.size() == 1:
		# Single path - one gate
		_decorate_single_gate(gate1, options[0])
		if gate1:
			gate1.set_meta("next_room_type", options[0])
		if gate2:
			gate2.visible = false
			if gate2.has_method("lock"):
				gate2.lock()
	else:
		# Choice - two gates (Hades-style)
		_decorate_single_gate(gate1, options[0])
		if gate1:
			gate1.set_meta("next_room_type", options[0])
		
		if gate2:
			_decorate_single_gate(gate2, options[1])
			gate2.set_meta("next_room_type", options[1])
			gate2.visible = true
		else:
			push_warning("[RoomBase] Room needs ExitGate2 node for choice display!")

func _decorate_single_gate(gate: Node, room_type: String) -> void:
	if gate == null:
		return
	
	# Use RouteGenerator for display info
	var info = RouteGenerator.get_room_display_info(room_type)
	
	# Update Label if present
	var label = gate.get_node_or_null("Label")
	if label and label is Label:
		label.text = "%s\n%s" % [info.icon, room_type]
		label.add_theme_color_override("font_color", info.color)
	
	# Tint Sprite2D if present
	var sprite = gate.get_node_or_null("Sprite2D")
	if sprite and sprite is Sprite2D:
		sprite.modulate = info.color
	
	# Use existing set_indicator method if gate has it
	if gate.has_method("set_indicator"):
		gate.set_indicator(room_type)
