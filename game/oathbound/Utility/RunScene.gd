# RunScene.gd
# Main scene for active runs - handles choice UI and initialization
extends Node2D

# Choice UI (created dynamically)
var _choice_panel: Control = null
# Debug area warp is opt-in. Normal playtests must begin in Area 1 / Hushiro.
@export var debug_start_area: int = 0  # 0 = normal, 2 = skip to area 2, etc.

func _ready() -> void:
	get_tree().paused = false
	print("[RunScene] _ready() — paused=%s container=%s" % [get_tree().paused, $RoomContainer])

	GameFlow.setup($RoomContainer)
	# Do not instantiate a Player here. OathboundGameFlow is the single current Player
	# factory and will create res://Player/aspect_player.tscn when the first room loads.

	# Connect signals
	if not GameFlow.is_connected("room_changed", Callable(self, "_on_room_changed")):
		GameFlow.connect("room_changed", Callable(self, "_on_room_changed"))
	if not GameFlow.is_connected("choice_presented", Callable(self, "_on_choice_presented")):
		GameFlow.connect("choice_presented", Callable(self, "_on_choice_presented"))
	if not GameFlow.is_connected("run_completed", Callable(self, "_on_run_completed")):
		GameFlow.connect("run_completed", Callable(self, "_on_run_completed"))

	# Create choice UI
	_create_choice_ui()

	# Debug: set debug_start_area in editor to skip to that area (0 = normal).
	# Always route through current GameFlow so all three regions use their reconciled
	# authorities. This also resets GameFlow.current_area explicitly; a previous debug or
	# validation session must never make a normal F5 run start with stale Area 2/3 state.
	if debug_start_area >= 2:
		RunData.reset_for_new_run(debug_start_area)
		if GameFlow.has_method("build_route_for_area"):
			GameFlow.build_route_for_area(debug_start_area)
		else:
			GameFlow.current_area = debug_start_area
			GameFlow.route = RouteGenerator.generate_area_route(debug_start_area)
			GameFlow.current_index = 0
	else:
		RunData.reset_for_new_run(1)
		if GameFlow.has_method("build_route_for_area"):
			GameFlow.build_route_for_area(1)
		else:
			GameFlow.current_area = 1
			GameFlow.build_area1_route()

	print("[RunScene] starting run… area=%d" % GameFlow.current_area)
	GameFlow.start_run()
	
func _on_room_changed(room_name: String) -> void:
	print("[RunScene] room_changed => ", room_name)

func _on_choice_presented(options: Array, slot_index: int) -> void:
	print("[RunScene] Choice presented at slot %d: %s" % [slot_index, options])
	_show_choice_ui(options)

func _on_run_completed(area_id: int) -> void:
	print("[RunScene] ★ Area %d complete!" % area_id)

# ============================================================================
# CHOICE UI
# ============================================================================

func _create_choice_ui() -> void:
	var canvas = CanvasLayer.new()
	canvas.name = "ChoiceLayer"
	canvas.layer = 100
	canvas.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(canvas)
	
	_choice_panel = PanelContainer.new()
	_choice_panel.name = "ChoicePanel"
	_choice_panel.visible = false
	_choice_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	_choice_panel.set_anchors_preset(Control.PRESET_CENTER)
	_choice_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_choice_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 0.95)
	style.border_color = Color(0.8, 0.7, 0.3)
	style.set_border_width_all(3)
	style.set_corner_radius_all(10)
	style.set_content_margin_all(30)
	_choice_panel.add_theme_stylebox_override("panel", style)
	
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.add_theme_constant_override("separation", 25)
	_choice_panel.add_child(vbox)
	
	var title = Label.new()
	title.name = "Title"
	title.text = "Choose Your Path"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(0.9, 0.8, 0.4))
	vbox.add_child(title)
	
	var button_box = HBoxContainer.new()
	button_box.name = "Buttons"
	button_box.alignment = BoxContainer.ALIGNMENT_CENTER
	button_box.add_theme_constant_override("separation", 50)
	vbox.add_child(button_box)
	canvas.add_child(_choice_panel)

func _show_choice_ui(options: Array) -> void:
	if _choice_panel == null:
		push_error("[RunScene] Choice panel not created!")
		if options.size() > 0:
			GameFlow.make_choice(options[0])
		return
	
	get_tree().paused = true
	var button_box = _choice_panel.get_node("VBox/Buttons")
	for child in button_box.get_children():
		child.queue_free()
	await get_tree().process_frame
	for room_type in options:
		var btn = _create_room_button(room_type)
		button_box.add_child(btn)
	_choice_panel.visible = true

func _create_room_button(room_type: String) -> Button:
	var info = RouteGenerator.get_room_display_info(room_type)
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(200, 150)
	btn.text = "%s\n%s\n\n%s" % [info.icon, room_type, info.desc]
	btn.process_mode = Node.PROCESS_MODE_ALWAYS
	btn.add_theme_font_size_override("font_size", 20)
	
	var normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color(0.15, 0.15, 0.2)
	normal_style.border_color = info.color
	normal_style.set_border_width_all(2)
	normal_style.set_corner_radius_all(8)
	normal_style.set_content_margin_all(15)
	btn.add_theme_stylebox_override("normal", normal_style)
	
	var hover_style = normal_style.duplicate()
	hover_style.bg_color = Color(0.25, 0.25, 0.3)
	hover_style.border_color = info.color.lightened(0.3)
	btn.add_theme_stylebox_override("hover", hover_style)
	
	var pressed_style = normal_style.duplicate()
	pressed_style.bg_color = info.color.darkened(0.5)
	btn.add_theme_stylebox_override("pressed", pressed_style)
	btn.pressed.connect(func(): _on_choice_button_pressed(room_type))
	return btn

func _on_choice_button_pressed(room_type: String) -> void:
	print("[RunScene] Player chose: %s" % room_type)
	_choice_panel.visible = false
	get_tree().paused = false
	GameFlow.make_choice(room_type)