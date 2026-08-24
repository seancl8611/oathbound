extends HubInteractable

## Boat — canonical Strand run-preparation and departure surface.
## The Boat owns final run confirmation. Permanent progression remains owned by
## Bloodwell, Forge Bench, and Blood Mirror.

signal run_started

const ASPECT_IDS: Array[String] = ["wolf", "wraith", "ronin"]
const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

var _aspect_menu: CanvasLayer = null
var _goal_menu: CanvasLayer = null
var _confirmation_menu: CanvasLayer = null


func _on_ready_custom() -> void:
	pass


func _open_menu() -> void:
	super._open_menu()
	if _returning_blood_awakened():
		_open_aspect_menu()
	else:
		if not _request_run_goal(RunData.RUN_GOAL_CAMPAIGN if typeof(RunData) == TYPE_OBJECT else "campaign"):
			return
		_open_confirmation_menu()


func _on_menu_closed_custom() -> void:
	_close_aspect_menu()
	_close_goal_menu()
	_close_confirmation_menu()


func _returning_blood_awakened() -> bool:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return true
	if MetaProgress.has_method("is_returning_blood_awakened"):
		return bool(MetaProgress.call("is_returning_blood_awakened"))
	return bool(MetaProgress.get("returning_blood_awakened"))


func _story_complete() -> bool:
	return typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("is_story_complete") and bool(MetaProgress.call("is_story_complete"))


# =============================================================================
# ASPECT SELECTION
# =============================================================================

func _open_aspect_menu() -> void:
	_close_goal_menu()
	_close_confirmation_menu()
	if _aspect_menu != null and is_instance_valid(_aspect_menu):
		return
	if typeof(AspectRuntime) != TYPE_OBJECT:
		push_error("[Boat] AspectRuntime unavailable; cannot prepare awakened run")
		return

	_aspect_menu = CanvasLayer.new()
	_aspect_menu.name = "BoatAspectRunSetup"
	_aspect_menu.layer = 120
	get_tree().root.add_child(_aspect_menu)
	_aspect_menu.add_child(_menu_backdrop())
	var column := _menu_column(_aspect_menu, 410)

	column.add_child(_title_label(LOCALIZATION.ui("boat.aspect.title", "Choose Blood Aspect")))
	column.add_child(_body_label(LOCALIZATION.ui("boat.aspect.subtitle", "Choose Akio's Blood Aspect foundation for this crossing.")))

	for aspect_id: String in ASPECT_IDS:
		var button := Button.new()
		button.text = _aspect_name(aspect_id)
		button.custom_minimum_size = Vector2(0, 40)
		button.pressed.connect(_select_aspect_for_departure.bind(aspect_id))
		column.add_child(button)

	var current_id: String = str(AspectRuntime.selected_aspect)
	if current_id in ASPECT_IDS:
		column.add_child(_body_label(LOCALIZATION.ui("boat.aspect.current", "Current selection: %s") % _aspect_name(current_id)))

	if _story_complete():
		column.add_child(_body_label(LOCALIZATION.ui("boat.aspect.postgame_hint", "After choosing an Aspect, select Standard Expedition or Heart Suppression.")))

	var cancel := Button.new()
	cancel.text = LOCALIZATION.ui("common.cancel", "Cancel")
	cancel.pressed.connect(_cancel_departure_menu)
	column.add_child(cancel)
	READABILITY_STYLER.apply(_aspect_menu)


func _select_aspect_for_departure(aspect_id: String) -> void:
	if typeof(AspectRuntime) != TYPE_OBJECT or not AspectRuntime.has_method("select_aspect"):
		push_error("[Boat] AspectRuntime selection API unavailable")
		return
	if not bool(AspectRuntime.call("select_aspect", aspect_id)):
		push_error("[Boat] Could not select Aspect: %s" % aspect_id)
		return
	print("[Boat] Selected Blood Aspect: %s" % aspect_id)
	_close_aspect_menu()
	if _story_complete():
		_open_run_goal_menu()
	else:
		if not _request_run_goal(RunData.RUN_GOAL_CAMPAIGN if typeof(RunData) == TYPE_OBJECT else "campaign"):
			return
		_open_confirmation_menu()


# =============================================================================
# POSTGAME GOAL
# =============================================================================

func _open_run_goal_menu() -> void:
	_close_confirmation_menu()
	if _goal_menu != null and is_instance_valid(_goal_menu):
		return
	_goal_menu = CanvasLayer.new()
	_goal_menu.name = "BoatPostgameRunGoalSetup"
	_goal_menu.layer = 121
	get_tree().root.add_child(_goal_menu)
	_goal_menu.add_child(_menu_backdrop())
	var column := _menu_column(_goal_menu, 530)

	column.add_child(_title_label(LOCALIZATION.ui("boat.goal.title", "Choose Expedition Goal")))

	var standard := Button.new()
	standard.text = "%s\n%s" % [
		LOCALIZATION.ui("boat.goal.standard.name", "Standard Expedition"),
		LOCALIZATION.ui("boat.goal.standard.details", "End after the Eclipse Shogun"),
	]
	standard.custom_minimum_size = Vector2(0, 58)
	standard.pressed.connect(_select_run_goal.bind(RunData.RUN_GOAL_STANDARD_EXPEDITION))
	column.add_child(standard)

	var suppression := Button.new()
	suppression.text = "%s\n%s" % [
		LOCALIZATION.ui("boat.goal.suppression.name", "Heart Suppression"),
		LOCALIZATION.ui("boat.goal.suppression.details", "Continue from the Shogun into the regenerated Heart"),
	]
	suppression.custom_minimum_size = Vector2(0, 66)
	suppression.pressed.connect(_select_run_goal.bind(RunData.RUN_GOAL_HEART_SUPPRESSION))
	column.add_child(suppression)

	column.add_child(_body_label(LOCALIZATION.ui("boat.goal.note", "The route goal is committed before departure. Both objectives use the same three-region run until the Shogun.")))

	var back := Button.new()
	back.text = LOCALIZATION.ui("common.back", "Back")
	back.pressed.connect(_back_to_aspect_menu)
	column.add_child(back)
	READABILITY_STYLER.apply(_goal_menu)


func _select_run_goal(goal: String) -> void:
	if not _request_run_goal(goal):
		return
	_close_goal_menu()
	_open_confirmation_menu()


func _request_run_goal(goal: String) -> bool:
	if typeof(RunData) != TYPE_OBJECT or not RunData.has_method("request_run_goal"):
		push_error("[Boat] RunData run-goal API unavailable")
		return false
	if not bool(RunData.call("request_run_goal", goal)):
		push_error("[Boat] Run goal rejected: %s" % goal)
		return false
	print("[Boat] Run goal selected: %s" % goal)
	return true


# =============================================================================
# FINAL LOADOUT CONFIRMATION
# =============================================================================

func _open_confirmation_menu() -> void:
	_close_aspect_menu()
	_close_goal_menu()
	if _confirmation_menu != null and is_instance_valid(_confirmation_menu):
		return

	_confirmation_menu = CanvasLayer.new()
	_confirmation_menu.name = "BoatRunConfirmation"
	_confirmation_menu.layer = 122
	get_tree().root.add_child(_confirmation_menu)
	_confirmation_menu.add_child(_menu_backdrop())
	var column := _menu_column(_confirmation_menu, 500)

	column.add_child(_title_label(LOCALIZATION.ui("boat.confirm.title", "Prepare the Boat")))
	column.add_child(_body_label(LOCALIZATION.ui("boat.confirm.subtitle", "Confirm the prepared loadout before crossing the barrier.")))
	column.add_child(_summary_label(LOCALIZATION.ui("boat.confirm.aspect", "Blood Aspect: %s") % _prepared_aspect_name()))
	column.add_child(_summary_label(LOCALIZATION.ui("boat.confirm.prosthetic", "Prosthetic: %s") % _prepared_prosthetic_name()))
	column.add_child(_summary_label(LOCALIZATION.ui("boat.confirm.relic", "Relic: %s") % _prepared_relic_name()))

	if _story_complete():
		column.add_child(_summary_label(LOCALIZATION.ui("boat.confirm.goal", "Expedition Goal: %s") % _prepared_goal_name()))

	column.add_child(_body_label(LOCALIZATION.ui("boat.confirm.techniques", "Direct Techniques begin empty and are acquired during the run.")))

	var start := Button.new()
	start.text = LOCALIZATION.ui("boat.confirm.start", "Start Run")
	start.custom_minimum_size = Vector2(0, 44)
	start.pressed.connect(_start_run)
	column.add_child(start)

	if _returning_blood_awakened():
		var change_aspect := Button.new()
		change_aspect.text = LOCALIZATION.ui("boat.confirm.change_aspect", "Change Aspect")
		change_aspect.pressed.connect(_back_to_aspect_menu)
		column.add_child(change_aspect)

	if _story_complete():
		var change_goal := Button.new()
		change_goal.text = LOCALIZATION.ui("boat.confirm.change_goal", "Change Goal")
		change_goal.pressed.connect(_back_to_goal_menu)
		column.add_child(change_goal)

	var cancel := Button.new()
	cancel.text = LOCALIZATION.ui("common.cancel", "Cancel")
	cancel.pressed.connect(_cancel_departure_menu)
	column.add_child(cancel)
	READABILITY_STYLER.apply(_confirmation_menu)


func _prepared_aspect_name() -> String:
	if not _returning_blood_awakened():
		return LOCALIZATION.resolve("aspect.base_katana.name", "Base Katana")
	if typeof(AspectRuntime) != TYPE_OBJECT:
		return LOCALIZATION.ui("common.none", "None")
	return _aspect_name(str(AspectRuntime.selected_aspect))


func _aspect_name(aspect_id: String) -> String:
	if aspect_id.is_empty():
		return LOCALIZATION.ui("common.none", "None")
	return LOCALIZATION.resolve("aspect.%s.name" % aspect_id, aspect_id.replace("_", " ").capitalize())


func _prepared_prosthetic_name() -> String:
	if typeof(ProstheticManager) != TYPE_OBJECT:
		return LOCALIZATION.ui("common.none", "None")
	var prosthetic_id: String = str(ProstheticManager.equipped_prosthetic_id)
	if prosthetic_id.is_empty():
		return LOCALIZATION.ui("common.none", "None")
	var fallback := prosthetic_id.replace("_", " ").capitalize()
	if ProstheticManager.has_method("get_prosthetic"):
		var data: Variant = ProstheticManager.get_prosthetic(prosthetic_id)
		if data != null and data.get("display_name") != null:
			fallback = str(data.get("display_name"))
	return LOCALIZATION.catalog_name("prosthetic", prosthetic_id, fallback)


func _prepared_relic_name() -> String:
	if typeof(RelicRuntime) != TYPE_OBJECT:
		return LOCALIZATION.ui("common.none", "None")
	var relic_id: String = str(RelicRuntime.get("equipped_relic_id"))
	if relic_id.is_empty():
		return LOCALIZATION.ui("common.none", "None")
	var entry: Dictionary = RELIC_CATALOG.DATA.get(relic_id, {})
	var fallback := str(entry.get("name", relic_id.replace("_", " ").capitalize()))
	return LOCALIZATION.catalog_name("relic", relic_id, fallback)


func _prepared_goal_name() -> String:
	if typeof(RunData) != TYPE_OBJECT:
		return LOCALIZATION.ui("boat.goal.campaign.name", "Campaign")
	var goal: String = str(RunData.get("requested_run_goal"))
	match goal:
		"standard_expedition": return LOCALIZATION.ui("boat.goal.standard.name", "Standard Expedition")
		"heart_suppression": return LOCALIZATION.ui("boat.goal.suppression.name", "Heart Suppression")
		_: return LOCALIZATION.ui("boat.goal.campaign.name", "Campaign")


func _confirmation_snapshot_for_playtest() -> Dictionary:
	return {
		"aspect": _prepared_aspect_name(),
		"prosthetic": _prepared_prosthetic_name(),
		"relic": _prepared_relic_name(),
		"goal": _prepared_goal_name(),
		"techniques": LOCALIZATION.ui("boat.confirm.techniques", "Direct Techniques begin empty and are acquired during the run."),
		"start": LOCALIZATION.ui("boat.confirm.start", "Start Run"),
	}


# =============================================================================
# SHARED MENU BUILDERS
# =============================================================================

func _menu_backdrop() -> ColorRect:
	var backdrop := ColorRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.02, 0.02, 0.025, 0.84)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	return backdrop


func _menu_column(layer: CanvasLayer, width: float) -> VBoxContainer:
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(width, 0)
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 20)
	margin.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 11)
	margin.add_child(column)
	return column


func _title_label(text_value: String) -> Label:
	var label := Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 20)
	return label


func _body_label(text_value: String) -> Label:
	var label := Label.new()
	label.text = text_value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	return label


func _summary_label(text_value: String) -> Label:
	var label := Label.new()
	label.text = text_value
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_font_size_override("font_size", 14)
	return label


# =============================================================================
# NAVIGATION / RUN START
# =============================================================================

func _back_to_aspect_menu() -> void:
	_close_goal_menu()
	_close_confirmation_menu()
	_open_aspect_menu()


func _back_to_goal_menu() -> void:
	_close_confirmation_menu()
	_open_run_goal_menu()


func _cancel_departure_menu() -> void:
	_close_aspect_menu()
	_close_goal_menu()
	_close_confirmation_menu()
	close_menu()


func _close_aspect_menu() -> void:
	if _aspect_menu != null and is_instance_valid(_aspect_menu):
		_aspect_menu.queue_free()
	_aspect_menu = null


func _close_goal_menu() -> void:
	if _goal_menu != null and is_instance_valid(_goal_menu):
		_goal_menu.queue_free()
	_goal_menu = null


func _close_confirmation_menu() -> void:
	if _confirmation_menu != null and is_instance_valid(_confirmation_menu):
		_confirmation_menu.queue_free()
	_confirmation_menu = null


func _start_run() -> void:
	if _returning_blood_awakened():
		if typeof(AspectRuntime) != TYPE_OBJECT or not AspectRuntime.has_method("has_active_aspect") or not bool(AspectRuntime.call("has_active_aspect")):
			push_error("[Boat] Awakened run blocked until a Blood Aspect is explicitly selected")
			return
	_close_confirmation_menu()
	run_started.emit()
	print("[Boat] Starting run with Aspect=%s Prosthetic=%s Relic=%s" % [_prepared_aspect_name(), _prepared_prosthetic_name(), _prepared_relic_name()])
	get_tree().change_scene_to_file("res://Utility/RunScene.tscn")
	close_menu()
