# RestRoom.gd
extends RoomBase
class_name RestRoom

@onready var exit_gate: Node = $ExitGate        # MistGate
@onready var rest_healer: RestHealer = $RestHealer

func _ready() -> void:
	# Start with the gate locked & closed, and hook it into the run flow
	lock_all_gates()
	connect_exit_gates_to_flow()

	# Listen for the rest being used once
	if rest_healer and rest_healer.has_signal("rest_used"):
		rest_healer.rest_used.connect(_on_rest_used)


func _on_rest_used() -> void:
	# Player has taken the heal; open the exit so they can move on
	_open_exit_gate()

func _open_exit_gate() -> void:
	# Choice slots need BOTH exits active; RoomBase handles ExitGate + ExitGate2.
	unlock_all_gates()
