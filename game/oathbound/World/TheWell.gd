extends "res://World/Boat.gd"

## Compatibility shim for older authored/resource references. The live Strand departure
## service is the Boat. New code must reference res://World/Boat.gd.
##
## Until the localization readiness fixture is migrated to Boat terminology, this shim
## preserves its legacy overlay names and `ui.well.*` translation aliases. No live Hub
## scene references this script.

const WELL_LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")


func _open_aspect_menu() -> void:
	super._open_aspect_menu()
	if _aspect_menu == null or not is_instance_valid(_aspect_menu):
		return
	_aspect_menu.name = "AspectRunSetup"
	for node: Node in _aspect_menu.find_children("*", "Label", true, false):
		if node is Label and (node as Label).text == "Choose Blood Aspect":
			(node as Label).text = WELL_LOCALIZATION.ui("well.aspect.title", "Choose Blood Aspect")


func _open_run_goal_menu() -> void:
	super._open_run_goal_menu()
	if _goal_menu == null or not is_instance_valid(_goal_menu):
		return
	_goal_menu.name = "PostgameRunGoalSetup"
	for node: Node in _goal_menu.find_children("*", "Label", true, false):
		if node is Label and (node as Label).text == "Choose Expedition Goal":
			(node as Label).text = WELL_LOCALIZATION.ui("well.goal.title", "Choose Expedition Goal")
	for node: Node in _goal_menu.find_children("*", "Button", true, false):
		if not (node is Button):
			continue
		var button := node as Button
		if button.text.begins_with("Standard Expedition"):
			var details := WELL_LOCALIZATION.ui("boat.goal.standard.details", "End after the Eclipse Shogun")
			button.text = "%s\n%s" % [WELL_LOCALIZATION.ui("well.goal.standard.name", "Standard Expedition"), details]
