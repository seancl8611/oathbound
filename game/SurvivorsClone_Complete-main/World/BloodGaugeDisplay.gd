extends Node2D

@export var max_stacks := 10
@onready var icon = $Icon
@onready var stack_label = $StackLabel

var current_stack_count := 0
var can_detonate := false

func update_display(stack_count: int, detonation_ready: bool):
	current_stack_count = stack_count
	can_detonate = detonation_ready

	if can_detonate:
		icon.texture = preload("res://Player/GUI/right_click.png")  # Replace with actual skull icon
		stack_label.visible = false
		modulate = Color(1, 0.2, 0.2)
		# Optional pulse
		create_tween().tween_property(self, "scale", Vector2(1.2, 1.2), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_loops()
	else:
		icon.texture = preload("res://icon.svg")  # Replace with your normal icon
		stack_label.visible = true
		stack_label.text = str(stack_count)
		modulate = Color(1, 1, 1)
