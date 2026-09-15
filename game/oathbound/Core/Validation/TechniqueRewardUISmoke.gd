extends Node

## Regression smoke for Technique reward exhaustion and keyboard focus safety.
## A reward screen must always provide a completion path even when no eligible Technique
## remains, because RewardPickup waits for `choice_made` while the SceneTree is paused.

const UI_SCRIPT = preload("res://Utility/UpgradeChoiceUI.gd")

var _failed := false
var _choice_count := 0
var _last_choice: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run_smoke")


func _run_smoke() -> void:
	var ui_value: Variant = UI_SCRIPT.new()
	if not (ui_value is CanvasLayer):
		_fail("UpgradeChoiceUI failed to instantiate")
		_finish()
		return
	var ui := ui_value as CanvasLayer
	add_child(ui)
	ui.choice_made.connect(_on_choice_made)
	await get_tree().process_frame

	# Empty legacy callers must receive a selectable no-op continuation instead of a
	# paused screen with no cards.
	ui.call("open_with_choices", [])
	_expect(get_tree().paused, "empty Technique reward did not pause while choice UI was open")
	var empty_options_value: Variant = ui.get("options")
	var empty_options := empty_options_value as Array if empty_options_value is Array else []
	_expect(empty_options.size() == 1, "empty Technique reward did not synthesize exactly one continuation choice")
	if not empty_options.is_empty() and empty_options[0] is Dictionary:
		_expect(str((empty_options[0] as Dictionary).get("id", "")) == "technique_none", "empty Technique reward fallback used the wrong compatibility id")
	else:
		_fail("empty Technique reward fallback was not a Dictionary")
	ui.call("_select_choice", 0)
	_expect(not get_tree().paused, "selecting exhausted-pool continuation did not unpause the SceneTree")
	_expect(_choice_count == 1, "selecting exhausted-pool continuation did not emit choice_made exactly once")
	_expect(str(_last_choice.get("id", "")) == "technique_none", "exhausted-pool continuation emitted the wrong choice")

	# UpgradeService can also explicitly pad a short/exhausted offer with technique_none.
	# That compatibility sentinel must remain selectable.
	ui.call("open_with_choices", [{
		"id": "technique_none",
		"displayname": "No Eligible Technique",
		"details": "Continue",
		"family": "neutral",
		"kind": "none",
		"rarity": "common",
	}])
	_expect(get_tree().paused, "explicit technique_none reward did not open normally")
	ui.call("_select_choice", 0)
	_expect(not get_tree().paused, "explicit technique_none selection did not unpause")
	_expect(_choice_count == 2, "explicit technique_none did not emit choice_made")

	# With fewer than three real options, keyboard navigation must never focus one of the
	# hidden card buttons. Sending Right while only one option exists should remain on 0.
	ui.call("open_with_choices", [{
		"id": "validation_technique",
		"displayname": "Validation Technique",
		"details": "Validation only",
		"family": "echo",
		"kind": "support",
		"rarity": "common",
	}])
	var right_event := InputEventAction.new()
	right_event.action = &"right"
	right_event.pressed = true
	ui.call("_input", right_event)
	_expect(int(ui.get("_focused_index")) == 0, "keyboard navigation moved focus onto a hidden Technique card")
	ui.call("_select_choice", 0)
	_expect(not get_tree().paused, "single-option reward did not resume after selection")
	_expect(_choice_count == 3, "single-option reward did not emit choice_made")

	ui.queue_free()
	await get_tree().process_frame
	_finish()


func _on_choice_made(choice: Dictionary) -> void:
	_choice_count += 1
	_last_choice = choice.duplicate(true)


func _finish() -> void:
	# A failed assertion must never leave CI hanging behind a paused SceneTree.
	get_tree().paused = false
	if _failed:
		get_tree().quit(1)
		return
	print("[TechniqueRewardUISmoke] PASS - exhausted pool continues safely | technique_none selectable | hidden-card focus blocked")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_fail(message)


func _fail(message: String) -> void:
	_failed = true
	push_error("[TechniqueRewardUISmoke] FAIL - %s" % message)
