extends Node

const HUB_SCENE = preload("res://World/HubScene.tscn")
const INPUT_GLYPHS = preload("res://Core/Release/OathboundInputGlyphs.gd")

var _failed: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	INPUT_GLYPHS.ensure_controller_defaults()
	_expect(INPUT_GLYPHS.preferred_label("interact", INPUT_GLYPHS.FAMILY_KEYBOARD_MOUSE) == "[E]", "default keyboard Interact glyph is not [E]")
	_expect(INPUT_GLYPHS.preferred_label("interact", INPUT_GLYPHS.FAMILY_CONTROLLER) == "[A]", "default controller Interact glyph is not [A]")
	_validate_default_controller_layout()

	var hub: Node = HUB_SCENE.instantiate()
	add_child(hub)
	await get_tree().process_frame
	await get_tree().process_frame

	var well_prompt: Label = hub.get_node_or_null("TheWell/InteractPopup") as Label
	var keeper_prompt: Label = hub.get_node_or_null("KeeperNPC/InteractPopup") as Label
	_expect(well_prompt != null and well_prompt.text == "The Well [E]", "live Strand Well prompt did not use keyboard binding")
	_expect(keeper_prompt != null and keeper_prompt.text == "Keeper [E]", "live Strand NPC prompt did not use keyboard binding")
	_expect(hub.get_node_or_null("QuestAltar") == null, "legacy Quest Altar is still authored into the live Strand")

	hub.call("_set_prompt_input_family_for_playtest", INPUT_GLYPHS.FAMILY_CONTROLLER)
	_expect(well_prompt != null and well_prompt.text == "The Well [A]", "live Strand Well prompt did not switch to controller glyph")
	_expect(keeper_prompt != null and keeper_prompt.text == "Keeper [A]", "live Strand NPC prompt did not switch to controller glyph")

	var custom_interact := InputEventJoypadButton.new()
	custom_interact.device = -1
	custom_interact.button_index = 3
	_expect(SettingsManager.bind_event("interact", custom_interact), "controller Interact rebind was rejected")
	_expect(well_prompt != null and well_prompt.text == "The Well [Y]", "live Strand prompt did not update after controller Interact rebind")

	SettingsManager.reset_defaults()
	INPUT_GLYPHS.ensure_controller_defaults()
	hub.call("_set_prompt_input_family_for_playtest", INPUT_GLYPHS.FAMILY_CONTROLLER)
	_expect(well_prompt != null and well_prompt.text == "The Well [A]", "controller default did not recover after settings reset")

	hub.queue_free()
	await get_tree().process_frame

	if _failed:
		get_tree().quit(1)
		return
	print("[HubPromptGlyphSmoke] PASS - keyboard [E] | controller [A] | live rebind [Y] | text-labelled prompts | no stale Quest Altar")
	get_tree().quit(0)


func _validate_default_controller_layout() -> void:
	var expected: Dictionary = {
		"attack": "[X]",
		"parry": "[LB]",
		"dash": "[B]",
		"interact": "[A]",
		"prosthetic": "[Y]",
		"special": "[RB]",
		"execute_finisher": "[A]",
		"left": "[LS Left]",
		"right": "[LS Right]",
		"up": "[LS Up]",
		"down": "[LS Down]",
	}
	for action_value: Variant in expected.keys():
		var action: String = str(action_value)
		_expect(INPUT_GLYPHS.preferred_label(action, INPUT_GLYPHS.FAMILY_CONTROLLER) == str(expected[action]), "controller default mismatch for %s" % action)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[HubPromptGlyphSmoke] FAIL - %s" % message)
