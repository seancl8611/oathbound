extends HubInteractable

## The Well — current run-preparation / departure surface.
##
## FIRST_ATTEMPT.md owns the pre-awakening exception. After awakening the player
## explicitly selects an Aspect before every run. After Story Complete, the approved
## endgame package additionally requires a pre-departure choice between Standard
## Expedition and Heart Suppression; campaign runs before that point are automatic.

signal run_started

const ASPECT_IDS: Array[String] = ["wolf", "wraith", "ronin"]

var _aspect_menu: CanvasLayer = null
var _goal_menu: CanvasLayer = null


func _on_ready_custom():
	pass


func _open_menu():
	super._open_menu()
	if _returning_blood_awakened():
		_open_aspect_menu()
	else:
		_request_run_goal(RunData.RUN_GOAL_CAMPAIGN if typeof(RunData) == TYPE_OBJECT else "campaign")
		_start_run()


func _on_menu_closed_custom() -> void:
	_close_aspect_menu()
	_close_goal_menu()


func _returning_blood_awakened() -> bool:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return true
	if MetaProgress.has_method("is_returning_blood_awakened"):
		return bool(MetaProgress.call("is_returning_blood_awakened"))
	return bool(MetaProgress.get("returning_blood_awakened"))


func _story_complete() -> bool:
	return typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("is_story_complete") and bool(MetaProgress.call("is_story_complete"))


func _open_aspect_menu() -> void:
	_close_goal_menu()
	if _aspect_menu != null and is_instance_valid(_aspect_menu):
		return
	if typeof(AspectRuntime) != TYPE_OBJECT:
		push_error("[TheWell] AspectRuntime unavailable; cannot prepare awakened run")
		return

	_aspect_menu = CanvasLayer.new()
	_aspect_menu.name = "AspectRunSetup"
	_aspect_menu.layer = 120
	get_tree().root.add_child(_aspect_menu)

	var backdrop := ColorRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.02, 0.02, 0.025, 0.82)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_aspect_menu.add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_aspect_menu.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(390, 0)
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	margin.add_child(column)

	var title := Label.new()
	title.text = "Choose Blood Aspect"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	column.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Returning Blood is awake. Choose Akio's weapon foundation for this run."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(subtitle)

	for aspect_id: String in ASPECT_IDS:
		var button := Button.new()
		button.text = aspect_id.capitalize()
		button.custom_minimum_size = Vector2(0, 38)
		button.pressed.connect(_select_aspect_for_departure.bind(aspect_id))
		column.add_child(button)

	var current_id: String = str(AspectRuntime.selected_aspect)
	if current_id in ASPECT_IDS:
		var current := Label.new()
		current.text = "Current selection: %s" % current_id.capitalize()
		current.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		column.add_child(current)

	if _story_complete():
		var postgame_hint := Label.new()
		postgame_hint.text = "After choosing an Aspect, select Standard Expedition or Heart Suppression."
		postgame_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		postgame_hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		column.add_child(postgame_hint)

	var cancel := Button.new()
	cancel.text = "Cancel"
	cancel.pressed.connect(_cancel_departure_menu)
	column.add_child(cancel)


func _select_aspect_for_departure(aspect_id: String) -> void:
	if typeof(AspectRuntime) != TYPE_OBJECT or not AspectRuntime.has_method("select_aspect"):
		push_error("[TheWell] AspectRuntime selection API unavailable")
		return
	if not bool(AspectRuntime.call("select_aspect", aspect_id)):
		push_error("[TheWell] Could not select Aspect: %s" % aspect_id)
		return
	print("[TheWell] Selected Blood Aspect: %s" % aspect_id)
	_close_aspect_menu()
	if _story_complete():
		_open_run_goal_menu()
	else:
		if not _request_run_goal(RunData.RUN_GOAL_CAMPAIGN if typeof(RunData) == TYPE_OBJECT else "campaign"):
			return
		_start_run()


func _open_run_goal_menu() -> void:
	if _goal_menu != null and is_instance_valid(_goal_menu):
		return
	_goal_menu = CanvasLayer.new()
	_goal_menu.name = "PostgameRunGoalSetup"
	_goal_menu.layer = 121
	get_tree().root.add_child(_goal_menu)

	var backdrop := ColorRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.02, 0.02, 0.025, 0.84)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_goal_menu.add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_goal_menu.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(520, 0)
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 12)
	margin.add_child(column)

	var title := Label.new()
	title.text = "Choose Expedition Goal"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	column.add_child(title)

	var standard := Button.new()
	standard.text = "Standard Expedition\nEnd after the Eclipse Shogun"
	standard.custom_minimum_size = Vector2(0, 56)
	standard.pressed.connect(_select_run_goal_and_start.bind(RunData.RUN_GOAL_STANDARD_EXPEDITION))
	column.add_child(standard)

	var suppression := Button.new()
	suppression.text = "Heart Suppression\nContinue from the Shogun into the regenerated Heart"
	suppression.custom_minimum_size = Vector2(0, 64)
	suppression.pressed.connect(_select_run_goal_and_start.bind(RunData.RUN_GOAL_HEART_SUPPRESSION))
	column.add_child(suppression)

	var note := Label.new()
	note.text = "The route goal is committed before departure. Both objectives use the same three-region run until the Shogun."
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(note)

	var back := Button.new()
	back.text = "Back"
	back.pressed.connect(_back_to_aspect_menu)
	column.add_child(back)


func _select_run_goal_and_start(goal: String) -> void:
	if not _request_run_goal(goal):
		return
	_close_goal_menu()
	_start_run()


func _request_run_goal(goal: String) -> bool:
	if typeof(RunData) != TYPE_OBJECT or not RunData.has_method("request_run_goal"):
		push_error("[TheWell] RunData run-goal API unavailable")
		return false
	if not bool(RunData.call("request_run_goal", goal)):
		push_error("[TheWell] Run goal rejected: %s" % goal)
		return false
	print("[TheWell] Run goal selected: %s" % goal)
	return true


func _back_to_aspect_menu() -> void:
	_close_goal_menu()
	_open_aspect_menu()


func _cancel_departure_menu() -> void:
	_close_aspect_menu()
	_close_goal_menu()
	close_menu()


func _close_aspect_menu() -> void:
	if _aspect_menu != null and is_instance_valid(_aspect_menu):
		_aspect_menu.queue_free()
	_aspect_menu = null


func _close_goal_menu() -> void:
	if _goal_menu != null and is_instance_valid(_goal_menu):
		_goal_menu.queue_free()
	_goal_menu = null


func _start_run():
	if _returning_blood_awakened():
		if typeof(AspectRuntime) != TYPE_OBJECT or not AspectRuntime.has_method("has_active_aspect") or not bool(AspectRuntime.call("has_active_aspect")):
			push_error("[TheWell] Awakened run blocked until a Blood Aspect is explicitly selected")
			return
	run_started.emit()
	print("[TheWell] Starting run...")
	get_tree().change_scene_to_file("res://Utility/RunScene.tscn")
	close_menu()
