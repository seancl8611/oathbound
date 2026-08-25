extends Node

## Non-destructive presentation smoke for the documented run-end results surface.
## Uses synthetic result dictionaries so persistent records/save data are never mutated.

const RUN_RESULTS_SCRIPT = preload("res://Core/Release/OathboundRunResultsOverlay.gd")

var _failed: bool = false


func _ready() -> void:
	call_deferred("_run_smoke")


func _run_smoke() -> void:
	var overlay_value: Variant = RUN_RESULTS_SCRIPT.new()
	_expect(overlay_value is CanvasLayer, "run-results overlay did not instantiate as CanvasLayer")
	if not (overlay_value is CanvasLayer):
		get_tree().quit(1)
		return

	var overlay: CanvasLayer = overlay_value as CanvasLayer
	add_child(overlay)
	overlay.present({
		"completion_kind": "failed",
		"successful": false,
		"clear_time_seconds": 184.0,
		"area": 2,
		"depth": 7,
		"deepest_chamber_reached": 7,
		"mist_gained": 12,
		"scrolls_gained": 1,
		"boss_materials_gained": {},
		"aspect": "wolf",
		"highest_tier": 2,
		"equipped_prosthetic": "beast_whistle",
		"equipped_relic": "",
		"techniques": [],
		"run_only_lost": ["Gold", "Techniques"],
	})
	await get_tree().process_frame

	_expect(get_tree().paused, "run-results overlay did not pause gameplay")
	var title_found: bool = false
	var permanent_section_found: bool = false
	var build_section_found: bool = false
	var return_action_found: bool = false

	for label_node: Node in overlay.find_children("*", "Label", true, false):
		if not (label_node is Label):
			continue
		var text: String = (label_node as Label).text
		if text == "RUN ENDED":
			title_found = true
		elif text == "Permanent progress retained":
			permanent_section_found = true
		elif text == "Final build":
			build_section_found = true

	for button_node: Node in overlay.find_children("*", "Button", true, false):
		if button_node is Button and (button_node as Button).text == "Return to The Strand":
			return_action_found = true

	_expect(title_found, "failed-run result title missing")
	_expect(permanent_section_found, "permanent-progress result section missing")
	_expect(build_section_found, "final-build result section missing")
	_expect(return_action_found, "Return to The Strand action missing")

	overlay.call("_dismiss")
	await get_tree().process_frame
	_expect(not get_tree().paused, "dismissing run results did not restore gameplay pause state")

	# Story Complete owns the postgame handoff. The canonical departure station is the
	# Boat; The Well is retired and must not reappear in release-facing guidance.
	var story_value: Variant = RUN_RESULTS_SCRIPT.new()
	_expect(story_value is CanvasLayer, "story-complete results overlay did not instantiate")
	if story_value is CanvasLayer:
		var story: CanvasLayer = story_value as CanvasLayer
		add_child(story)
		story.present({
			"completion_kind": "story_complete",
			"successful": true,
			"clear_time_seconds": 1200.0,
			"area": 3,
			"depth": 33,
			"deepest_chamber_reached": 33,
			"mist_gained": 0,
			"scrolls_gained": 0,
			"boss_materials_gained": {},
			"aspect": "wolf",
			"highest_tier": 4,
			"equipped_prosthetic": "beast_whistle",
			"equipped_relic": "",
			"techniques": [],
			"run_only_lost": ["Gold", "Techniques"],
		})
		await get_tree().process_frame
		var boat_guidance_found := false
		var well_guidance_found := false
		for label_node: Node in story.find_children("*", "Label", true, false):
			if not (label_node is Label):
				continue
			var text := (label_node as Label).text
			if text.contains("Postgame unlocked") and text.contains("Boat"):
				boat_guidance_found = true
			if text.contains("The Well"):
				well_guidance_found = true
		_expect(boat_guidance_found, "Story Complete results did not route postgame selection to the Boat")
		_expect(not well_guidance_found, "Story Complete results reintroduced retired The Well guidance")
		story.call("_dismiss")
		await get_tree().process_frame
		_expect(not get_tree().paused, "dismissing Story Complete results did not restore gameplay pause state")

	if _failed:
		get_tree().quit(1)
		return
	print("[RunResultsOverlaySmoke] PASS - failed run summary | retained progress | final build | Strand return | Boat-owned postgame guidance")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[RunResultsOverlaySmoke] FAIL - %s" % message)
