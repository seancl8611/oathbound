extends "res://Utility/RunScene.gd"

## Current run-start integration layer. The imported RunScene owns route/choice UI
## compatibility, but it must not hard-code an older Player scene.

func _ready() -> void:
	get_tree().paused = false
	print("[OathboundRunScene] _ready() — paused=%s container=%s" % [get_tree().paused, $RoomContainer])

	GameFlow.setup($RoomContainer)

	var current_player: Node = null
	if GameFlow.has_method("create_player_instance"):
		current_player = GameFlow.create_player_instance()
	else:
		push_error("[OathboundRunScene] GameFlow lacks canonical create_player_instance()")
		return
	if current_player == null:
		push_error("[OathboundRunScene] Canonical Player factory returned null")
		return
	GameFlow.set_player(current_player)

	if not GameFlow.is_connected("room_changed", Callable(self, "_on_room_changed")):
		GameFlow.connect("room_changed", Callable(self, "_on_room_changed"))
	if not GameFlow.is_connected("choice_presented", Callable(self, "_on_choice_presented")):
		GameFlow.connect("choice_presented", Callable(self, "_on_choice_presented"))
	if not GameFlow.is_connected("run_completed", Callable(self, "_on_run_completed")):
		GameFlow.connect("run_completed", Callable(self, "_on_run_completed"))

	_create_choice_ui()

	if debug_start_area >= 2:
		GameFlow.current_area = debug_start_area
		RunData.reset_for_new_run(debug_start_area)
		GameFlow.route = RouteGenerator.generate_area_route(debug_start_area)
		GameFlow.current_index = 0
	else:
		RunData.reset_for_new_run(1)
		GameFlow.build_area1_route()

	print("[OathboundRunScene] starting run… area=%d" % GameFlow.current_area)
	GameFlow.start_run()
