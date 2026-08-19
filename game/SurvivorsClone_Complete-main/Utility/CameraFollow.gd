extends Camera2D

@export var smoothing_on_start := true
@export var smoothing_speed := 8.0

var _target: Node2D

func _ready() -> void:
	# Follow parent (the Player)
	_target = get_parent() as Node2D
	# Snap to player BEFORE enabling smoothing/current to avoid the initial slide
	if _target:
		global_position = _target.global_position

	make_current()
	position_smoothing_enabled = smoothing_on_start
	position_smoothing_speed = smoothing_speed

func _physics_process(_dt: float) -> void:
	if _target:
		global_position = _target.global_position

# Optional helpers so rooms can control timing
func snap_to_target() -> void:
	if _target:
		global_position = _target.global_position

func set_smoothing_enabled(on: bool) -> void:
	position_smoothing_enabled = on
