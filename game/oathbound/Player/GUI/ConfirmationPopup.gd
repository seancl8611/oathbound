extends Control

signal confirmed_start_run
signal cancelled_start_run

@onready var btn_yes = $Panel/VBoxContainer/YesButton
@onready var btn_no = $Panel/VBoxContainer/NoButton

func _ready():
	# Make the root Control node cover the entire screen
	anchor_left = 0
	anchor_top = 0
	anchor_right = 1
	anchor_bottom = 1

	offset_left = 0
	offset_top = 0
	offset_right = 0
	offset_bottom = 0

	size = get_viewport_rect().size
	position = Vector2.ZERO

	# Add a dimmed fullscreen background
	var dim_bg := ColorRect.new()
	dim_bg.color = Color(0, 0, 0, 0.5)  # Semi-transparent black
	dim_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE  # Allow clicks to pass through
	add_child(dim_bg)
	move_child(dim_bg, 0)  # Send it to the bottom

	dim_bg.anchor_left = 0
	dim_bg.anchor_top = 0
	dim_bg.anchor_right = 1
	dim_bg.anchor_bottom = 1
	dim_bg.offset_left = 0
	dim_bg.offset_top = 0
	dim_bg.offset_right = 0
	dim_bg.offset_bottom = 0

	# Center and size the panel nicely
	if has_node("Panel"):
		var panel = $Panel
		panel.anchor_left = 0.3
		panel.anchor_top = 0.3
		panel.anchor_right = 0.7
		panel.anchor_bottom = 0.7
		panel.offset_left = 0
		panel.offset_top = 0
		panel.offset_right = 0
		panel.offset_bottom = 0

	# Connect button signals
	# Pause the game while the menu is active
	get_tree().paused = true

func _on_yes_pressed():
	get_tree().paused = false
	emit_signal("confirmed_start_run")
	queue_free()

func _on_no_pressed():
	get_tree().paused = false
	emit_signal("cancelled_start_run")
	queue_free()
