extends HubInteractable

## The Well — portal to begin a new run.
##
## FIRST_ATTEMPT.md owns the run-start boundary:
## - before Returning Blood awakens, the first attempt begins immediately with the
##   base katana / no-Aspect state;
## - after awakening, every run must explicitly select Wolf, Wraith, or Ronin before
##   entering RunScene. The Well owns this minimal run-preparation selection surface
##   until the broader Strand presentation pass replaces it.

signal run_started

const ASPECT_IDS: Array[String] = ["wolf", "wraith", "ronin"]

var _aspect_menu: CanvasLayer = null


func _on_ready_custom():
	pass


func _open_menu():
	super._open_menu()
	if _returning_blood_awakened():
		_open_aspect_menu()
	else:
		_start_run()


func _returning_blood_awakened() -> bool:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return true
	if MetaProgress.has_method("is_returning_blood_awakened"):
		return bool(MetaProgress.call("is_returning_blood_awakened"))
	return bool(MetaProgress.get("returning_blood_awakened"))


func _open_aspect_menu() -> void:
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
	panel.custom_minimum_size = Vector2(360, 0)
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
		button.pressed.connect(_select_aspect_and_start.bind(aspect_id))
		column.add_child(button)

	var current_id: String = str(AspectRuntime.selected_aspect)
	if current_id in ASPECT_IDS:
		var current := Label.new()
		current.text = "Current selection: %s" % current_id.capitalize()
		current.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		column.add_child(current)

	var cancel := Button.new()
	cancel.text = "Cancel"
	cancel.pressed.connect(_cancel_aspect_menu)
	column.add_child(cancel)


func _select_aspect_and_start(aspect_id: String) -> void:
	if typeof(AspectRuntime) != TYPE_OBJECT or not AspectRuntime.has_method("select_aspect"):
		push_error("[TheWell] AspectRuntime selection API unavailable")
		return
	if not bool(AspectRuntime.call("select_aspect", aspect_id)):
		push_error("[TheWell] Could not select Aspect: %s" % aspect_id)
		return
	print("[TheWell] Selected Blood Aspect: %s" % aspect_id)
	_close_aspect_menu()
	_start_run()


func _cancel_aspect_menu() -> void:
	_close_aspect_menu()
	close_menu()


func _close_aspect_menu() -> void:
	if _aspect_menu != null and is_instance_valid(_aspect_menu):
		_aspect_menu.queue_free()
	_aspect_menu = null


func _start_run():
	if _returning_blood_awakened():
		if typeof(AspectRuntime) != TYPE_OBJECT or not AspectRuntime.has_method("has_active_aspect") or not bool(AspectRuntime.call("has_active_aspect")):
			push_error("[TheWell] Awakened run blocked until a Blood Aspect is explicitly selected")
			return
	run_started.emit()
	print("[TheWell] Starting run...")
	get_tree().change_scene_to_file("res://Utility/RunScene.tscn")
	close_menu()


func _exit_tree() -> void:
	_close_aspect_menu()
