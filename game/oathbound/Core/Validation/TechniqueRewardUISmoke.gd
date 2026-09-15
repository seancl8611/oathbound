extends Node

## Regression smoke for Technique reward exhaustion, reroll safety and keyboard focus.
## A reward screen must always provide a completion path even when no eligible Technique
## remains, because RewardPickup waits for `choice_made` while the SceneTree is paused.

const UI_SCRIPT = preload("res://Core/Rewards/TechniqueRewardUI.gd")
const TECHNIQUE_CATALOG = preload("res://Core/Techniques/TechniqueCatalog.gd")

var _failed := false
var _choice_count := 0
var _last_choice: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run_smoke")


func _run_smoke() -> void:
	var ui_value: Variant = UI_SCRIPT.new()
	if not (ui_value is CanvasLayer):
		_fail("TechniqueRewardUI failed to instantiate")
		_finish()
		return
	var ui := ui_value as CanvasLayer
	add_child(ui)
	ui.choice_made.connect(_on_choice_made)
	await get_tree().process_frame

	var original_rerolls := int(RunData.technique_rerolls) if RunData != null else 0
	var original_acquired: Array = RunData.acquired_upgrades.duplicate(true) if RunData != null else []
	if RunData != null:
		RunData.technique_rerolls = 1

	# Empty canonical callers must receive a selectable no-op continuation instead of a
	# paused screen with no cards. Even if a reroll resource exists, an entirely exhausted
	# screen must not offer a button that can spend it for another no-op screen.
	ui.call("open_with_context", [], UpgradeService.SOURCE_STANDARD, 1)
	_expect(get_tree().paused, "empty Technique reward did not pause while choice UI was open")
	var empty_options_value: Variant = ui.get("options")
	var empty_options := empty_options_value as Array if empty_options_value is Array else []
	_expect(empty_options.size() == 1, "empty Technique reward did not synthesize exactly one continuation choice")
	if not empty_options.is_empty() and empty_options[0] is Dictionary:
		_expect(str((empty_options[0] as Dictionary).get("id", "")) == "technique_none", "empty Technique reward fallback used the wrong compatibility id")
	else:
		_fail("empty Technique reward fallback was not a Dictionary")
	var reroll_button_value: Variant = ui.get("_reroll_button")
	if reroll_button_value is Button:
		_expect((reroll_button_value as Button).visible, "canonical exhausted Technique screen unexpectedly hid reroll control")
		_expect((reroll_button_value as Button).disabled, "exhausted Technique screen allowed wasting a reroll resource")
	else:
		_fail("Technique reroll button was unavailable for validation")
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

	# The service boundary must be safe even if a future caller bypasses this UI. Exhaust
	# the real catalog, then request a reroll directly. No alternative exists, so the call
	# must return no replacement screen and must not consume the resource.
	if RunData != null:
		var exhausted_ids: Array = []
		for technique_id: Variant in TECHNIQUE_CATALOG.TECHNIQUES.keys():
			exhausted_ids.append(str(technique_id))
		for refinement_id: Variant in TECHNIQUE_CATALOG.REFINEMENTS.keys():
			exhausted_ids.append(str(refinement_id))
		RunData.acquired_upgrades = exhausted_ids
		RunData.technique_rerolls = 1
		var service_result: Array = UpgradeService.reroll_three_choices(
			UpgradeService.SOURCE_STANDARD,
			1,
			[{"id": "validation_current"}]
		)
		_expect(service_result.is_empty(), "exhausted reroll service returned a fake alternative screen")
		_expect(int(RunData.technique_rerolls) == 1, "reroll service consumed resource before proving an alternative existed")

	if RunData != null:
		RunData.acquired_upgrades = original_acquired
		RunData.technique_rerolls = original_rerolls
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
	print("[TechniqueRewardUISmoke] PASS - exhausted pool continues safely | technique_none selectable | hidden-card focus blocked | exhausted reroll spend blocked | service reroll spend deferred")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_fail(message)


func _fail(message: String) -> void:
	_failed = true
	push_error("[TechniqueRewardUISmoke] FAIL - %s" % message)
