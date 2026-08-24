extends "res://Utility/RunScene.gd"

## Current run-start integration layer. The imported RunScene owns route/choice UI
## compatibility, while this layer owns canonical Player creation, current regional
## route authorities, release-shell safe-checkpoint resume, failed-run closure, and the
## approved read-only Pause / Build Overview.

const PAUSE_OVERVIEW_SCRIPT = preload("res://Core/Release/OathboundAccessiblePauseOverview.gd")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")

var _pause_overview: CanvasLayer = null


func _ready() -> void:
	get_tree().paused = false
	INPUT_GLYPHS.ensure_controller_defaults()
	print("[OathboundRunScene] _ready() — paused=%s container=%s" % [get_tree().paused, $RoomContainer])
	_record_playtest_build_identity()

	GameFlow.setup($RoomContainer)

	if not GameFlow.is_connected("room_changed", Callable(self, "_on_room_changed")):
		GameFlow.connect("room_changed", Callable(self, "_on_room_changed"))
	if not GameFlow.is_connected("choice_presented", Callable(self, "_on_choice_presented")):
		GameFlow.connect("choice_presented", Callable(self, "_on_choice_presented"))
	if not GameFlow.is_connected("run_completed", Callable(self, "_on_run_completed")):
		GameFlow.connect("run_completed", Callable(self, "_on_run_completed"))

	_create_choice_ui()

	if GameFlow.has_method("has_prepared_resume_checkpoint") and bool(GameFlow.has_prepared_resume_checkpoint()):
		print("[OathboundRunScene] restoring safe chamber checkpoint")
		if not GameFlow.has_method("resume_prepared_run") or not bool(await GameFlow.resume_prepared_run()):
			push_error("[OathboundRunScene] Prepared safe checkpoint could not be resumed")
			if typeof(SaveSlots) == TYPE_OBJECT:
				SaveSlots.clear_safe_checkpoint()
			get_tree().change_scene_to_file("res://World/HubScene.tscn")
		return

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

	print("[OathboundRunScene] starting run… area=%d" % GameFlow.current_area)
	GameFlow.start_run()


func _record_playtest_build_identity() -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return

	var sha_output: Array = []
	var branch_output: Array = []
	var sha_exit: int = OS.execute("git", PackedStringArray(["rev-parse", "HEAD"]), sha_output, true)
	var branch_exit: int = OS.execute("git", PackedStringArray(["rev-parse", "--abbrev-ref", "HEAD"]), branch_output, true)
	var git_sha: String = str(sha_output[0]).strip_edges() if sha_exit == 0 and not sha_output.is_empty() else "unavailable"
	var git_branch: String = str(branch_output[0]).strip_edges() if branch_exit == 0 and not branch_output.is_empty() else "unavailable"

	CombatTelemetry.record_event("build_identity", {
		"git_sha": git_sha,
		"git_branch": git_branch,
		"identity_source": "git_rev_parse" if git_sha != "unavailable" else "unavailable",
	})
	print("[OathboundRunScene] playtest build sha=%s branch=%s" % [git_sha, git_branch])


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return
	if _choice_panel != null and is_instance_valid(_choice_panel) and _choice_panel.visible:
		return
	if _pause_overview != null and is_instance_valid(_pause_overview):
		return
	_open_pause_overview()
	get_viewport().set_input_as_handled()


func _open_pause_overview() -> void:
	var overlay_value: Variant = PAUSE_OVERVIEW_SCRIPT.new()
	if not (overlay_value is CanvasLayer):
		push_error("[OathboundRunScene] Could not create Pause / Build Overview")
		return
	_pause_overview = overlay_value as CanvasLayer
	_pause_overview.name = "PauseBuildOverview"
	_pause_overview.closed.connect(_on_pause_overview_closed)
	get_tree().root.add_child(_pause_overview)


func _on_pause_overview_closed() -> void:
	_pause_overview = null


func _process(_delta: float) -> void:
	# Ordinary combat death may be handled by the imported Player scene transition
	# rather than GameFlow._return_to_strand(). Close the run as soon as the canonical
	# Player reaches zero HP. RecordsRuntime remembers whether this run began as the
	# first attempt and presents the correct first-return result state.
	if typeof(RecordsRuntime) != TYPE_OBJECT or not RecordsRuntime.is_run_active():
		return
	var active_player: Node = GameFlow.player if typeof(GameFlow) == TYPE_OBJECT else null
	if active_player == null or not is_instance_valid(active_player):
		return
	var hp_value: Variant = active_player.get("hp")
	if hp_value != null and int(hp_value) <= 0:
		RecordsRuntime.on_run_finished(false, "failed")
