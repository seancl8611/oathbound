extends RefCounted

## Launch input-glyph authority for presentation surfaces. Project keyboard/mouse defaults
## remain untouched; missing controller bindings are supplied at runtime so packaged and
## development builds share a complete default controller layout. Player rebindings win
## because a default is added only when that device family has no binding for the action.

const FAMILY_KEYBOARD_MOUSE: String = "keyboard_mouse"
const FAMILY_CONTROLLER: String = "controller"

const DEFAULT_CONTROLLER_BUTTONS: Dictionary = {
	"attack": 2,             # X / Square position
	"parry": 9,              # LB / L1
	"dash": 1,               # B / Circle
	"interact": 0,           # A / Cross
	"prosthetic": 3,         # Y / Triangle
	"special": 10,           # RB / R1
	"execute_finisher": 0,   # contextual A / Cross
}

const DEFAULT_CONTROLLER_AXES: Dictionary = {
	"left": {"axis": 0, "value": -1.0},
	"right": {"axis": 0, "value": 1.0},
	"up": {"axis": 1, "value": -1.0},
	"down": {"axis": 1, "value": 1.0},
}


static func ensure_controller_defaults() -> void:
	for action_value: Variant in DEFAULT_CONTROLLER_BUTTONS.keys():
		var action: String = str(action_value)
		if not InputMap.has_action(action) or _has_family_binding(action, FAMILY_CONTROLLER):
			continue
		var event := InputEventJoypadButton.new()
		event.device = -1
		event.button_index = int(DEFAULT_CONTROLLER_BUTTONS[action])
		InputMap.action_add_event(action, event)

	for action_value: Variant in DEFAULT_CONTROLLER_AXES.keys():
		var action: String = str(action_value)
		if not InputMap.has_action(action) or _has_family_binding(action, FAMILY_CONTROLLER):
			continue
		var axis_data: Dictionary = DEFAULT_CONTROLLER_AXES[action]
		var event := InputEventJoypadMotion.new()
		event.device = -1
		event.axis = int(axis_data.get("axis", 0))
		event.axis_value = float(axis_data.get("value", 1.0))
		InputMap.action_add_event(action, event)


static func preferred_label(action: String, family: String) -> String:
	if not InputMap.has_action(action):
		return "[?]"
	for event: InputEvent in InputMap.action_get_events(action):
		if event_family(event) == family:
			return event_label(event)
	for event: InputEvent in InputMap.action_get_events(action):
		var fallback: String = event_label(event)
		if not fallback.is_empty():
			return fallback
	return "[?]"


static func event_family(event: InputEvent) -> String:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return FAMILY_CONTROLLER
	if event is InputEventKey or event is InputEventMouseButton:
		return FAMILY_KEYBOARD_MOUSE
	return "other"


static func is_meaningful_family_switch_event(event: InputEvent) -> bool:
	if event is InputEventKey:
		var key: InputEventKey = event as InputEventKey
		return key.pressed and not key.echo
	if event is InputEventMouseButton:
		return (event as InputEventMouseButton).pressed
	if event is InputEventJoypadButton:
		return (event as InputEventJoypadButton).pressed
	if event is InputEventJoypadMotion:
		return absf((event as InputEventJoypadMotion).axis_value) >= 0.55
	return false


static func event_label(event: InputEvent) -> String:
	if event is InputEventKey:
		var key: InputEventKey = event as InputEventKey
		var code: Key = key.physical_keycode if key.physical_keycode != 0 else key.keycode
		var label: String = OS.get_keycode_string(code)
		return "[%s]" % label if not label.is_empty() else "[Key]"
	if event is InputEventMouseButton:
		return "[Mouse %d]" % int((event as InputEventMouseButton).button_index)
	if event is InputEventJoypadButton:
		return _joy_button_glyph(int((event as InputEventJoypadButton).button_index))
	if event is InputEventJoypadMotion:
		var motion: InputEventJoypadMotion = event as InputEventJoypadMotion
		if int(motion.axis) == 0:
			return "[LS Right]" if motion.axis_value > 0.0 else "[LS Left]"
		if int(motion.axis) == 1:
			return "[LS Down]" if motion.axis_value > 0.0 else "[LS Up]"
		return "[Axis %d %s]" % [int(motion.axis), "+" if motion.axis_value > 0.0 else "-"]
	return ""


static func _has_family_binding(action: String, family: String) -> bool:
	for event: InputEvent in InputMap.action_get_events(action):
		if event_family(event) == family:
			return true
	return false


static func _joy_button_glyph(button_index: int) -> String:
	var labels: Dictionary = {
		0: "[A]",
		1: "[B]",
		2: "[X]",
		3: "[Y]",
		4: "[Back]",
		5: "[Guide]",
		6: "[Start]",
		7: "[L3]",
		8: "[R3]",
		9: "[LB]",
		10: "[RB]",
		11: "[D-Pad Up]",
		12: "[D-Pad Down]",
		13: "[D-Pad Left]",
		14: "[D-Pad Right]",
	}
	return str(labels.get(button_index, "[Pad %d]" % button_index))
