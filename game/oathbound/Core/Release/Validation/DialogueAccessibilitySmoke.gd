extends Node

## Non-destructive smoke for dialogue readability settings. It edits the in-memory
## SettingsManager values only and restores them before exit, so no settings file is written.

const DIALOGUE_SCRIPT = preload("res://GUI/OathboundDialogueOverlay.gd")
const TEST_LINE: String = "The blood remembers every road back to the Strand, and this deliberately long line verifies that readable dialogue reveal is not forced to appear all at once."

var _failed: bool = false
var _original_instant: Variant
var _original_speed: Variant


func _ready() -> void:
	call_deferred("_run_smoke")


func _run_smoke() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		_expect(false, "SettingsManager autoload missing")
		_finish_test()
		return

	_original_instant = SettingsManager.values.get("instant_text", false)
	_original_speed = SettingsManager.values.get("dialogue_text_speed", 1.0)

	SettingsManager.values["instant_text"] = false
	SettingsManager.values["dialogue_text_speed"] = 0.50
	var overlay: Control = _new_overlay()
	if overlay == null:
		_restore_settings()
		_finish_test()
		return
	overlay.present({"id": "dialogue_accessibility_smoke", "speaker": "Keeper", "lines": [TEST_LINE]})
	var body: Label = _find_body_label(overlay, TEST_LINE)
	_expect(body != null, "dialogue body label missing")
	if body != null:
		_expect(body.visible_characters == 0, "non-instant dialogue should begin hidden for progressive reveal")
	var slow_rate: float = float(overlay.call("_dialogue_chars_per_second"))
	_expect(is_equal_approx(slow_rate, 21.0), "0.5x dialogue speed did not scale reveal rate")

	overlay.call("_advance")
	if body != null:
		_expect(body.visible_characters == -1, "first confirm did not reveal the active line instantly")
	overlay.call("_finish")
	await get_tree().process_frame
	_expect(not get_tree().paused, "closing progressive dialogue did not restore pause state")

	SettingsManager.values["instant_text"] = true
	SettingsManager.values["dialogue_text_speed"] = 2.00
	var instant_overlay: Control = _new_overlay()
	if instant_overlay != null:
		instant_overlay.present({"id": "instant_dialogue_smoke", "speaker": "Raven", "lines": [TEST_LINE]})
		var instant_body: Label = _find_body_label(instant_overlay, TEST_LINE)
		_expect(instant_body != null, "instant-text dialogue body label missing")
		if instant_body != null:
			_expect(instant_body.visible_characters == -1, "Instant Text did not reveal the full line immediately")
		var fast_rate: float = float(instant_overlay.call("_dialogue_chars_per_second"))
		_expect(is_equal_approx(fast_rate, 84.0), "2.0x dialogue speed did not scale reveal rate")
		instant_overlay.call("_finish")
		await get_tree().process_frame

	_restore_settings()
	_finish_test()


func _new_overlay() -> Control:
	var value: Variant = DIALOGUE_SCRIPT.new()
	_expect(value is Control, "dialogue overlay did not instantiate as Control")
	if not (value is Control):
		return null
	var overlay: Control = value as Control
	add_child(overlay)
	return overlay


func _find_body_label(overlay: Control, expected_text: String) -> Label:
	for node: Node in overlay.find_children("*", "Label", true, false):
		if node is Label and (node as Label).text == expected_text:
			return node as Label
	return null


func _restore_settings() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT:
		return
	SettingsManager.values["instant_text"] = _original_instant
	SettingsManager.values["dialogue_text_speed"] = _original_speed


func _finish_test() -> void:
	if _failed:
		get_tree().quit(1)
		return
	print("[DialogueAccessibilitySmoke] PASS - progressive reveal | confirm-to-reveal | Instant Text | speed scaling")
	get_tree().quit(0)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[DialogueAccessibilitySmoke] FAIL - %s" % message)
