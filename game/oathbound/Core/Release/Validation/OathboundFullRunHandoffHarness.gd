extends "res://Core/Release/Validation/OathboundRunHandoffHarness.gd"

## Final-integration extension of the release handoff harness.
## Production next_room(), Shogun outcome selection, and Heart scene construction stay
## untouched. Only the actual scene-tree replacement is intercepted so headless CI can
## prove the Region 3 -> Heart boundary without requiring authored Heart combat.

var specialized_scene_names: Array[String] = []
var specialized_scene_scripts: Array[String] = []
var specialized_scene_outcomes: Array[String] = []


func _replace_room_with_specialized_scene(scene: Node) -> void:
	if scene == null:
		return
	specialized_scene_names.append(scene.name)
	var script_path := ""
	var script_value: Variant = scene.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path
	specialized_scene_scripts.append(script_path)
	specialized_scene_outcomes.append(str(scene.get_meta("endgame_outcome", "")))
	scene.free()
	await get_tree().process_frame
