extends Node

## Launch-facing settings/accessibility authority.
## ENDGAME_POSTGAME_RELEASE.md owns the required option categories. This runtime keeps
## settings global across save slots and provides a reusable input-rebinding API.

signal settings_changed
signal binding_changed(action: String)

const SAVE_PATH: String = "user://oathbound_settings.cfg"
const SECTION: String = "settings"
const BINDINGS_SECTION: String = "bindings"

const BINDABLE_ACTIONS: Array[String] = [
	"up", "down", "left", "right",
	"attack", "parry", "dash", "interact", "prosthetic", "special", "execute_finisher",
]

const DEFAULTS: Dictionary = {
	"master_volume": 1.0,
	"music_volume": 0.80,
	"sfx_volume": 0.90,
	"ambience_volume": 0.80,
	"vibration_enabled": true,
	"vibration_strength": 1.0,
	"screen_shake": 1.0,
	"reduced_flashing": false,
	"reduced_intense_vfx": false,
	"ui_scale": 1.0,
	"text_scale": 1.0,
	"high_contrast": false,
	"damage_numbers": true,
	"dialogue_text_speed": 1.0,
	"instant_text": false,
	"block_mode": "hold",
}

var values: Dictionary = DEFAULTS.duplicate(true)
var _custom_bindings: Dictionary = {}


func _ready() -> void:
	_load()
	_apply_audio()
	_apply_bindings()


func get_value(key: String, fallback: Variant = null) -> Variant:
	if values.has(key):
		return values[key]
	return fallback


func set_value(key: String, value: Variant) -> bool:
	if not DEFAULTS.has(key):
		return false
	var normalized := _normalize_setting(key, value)
	if values.get(key) == normalized:
		return true
	values[key] = normalized
	_save()
	if key.ends_with("_volume"):
		_apply_audio()
	settings_changed.emit()
	return true


func reset_defaults() -> void:
	values = DEFAULTS.duplicate(true)
	_custom_bindings.clear()
	_save()
	_apply_audio()
	_reset_bindings_to_project_defaults()
	settings_changed.emit()


func get_bindable_actions() -> Array[String]:
	return BINDABLE_ACTIONS.duplicate()


func bind_event(action: String, event: InputEvent) -> bool:
	if action not in BINDABLE_ACTIONS or event == null:
		return false
	var encoded := _encode_event(event)
	if encoded.is_empty():
		return false
	var device_family := str(encoded.get("family", ""))
	var current_value: Variant = _custom_bindings.get(action, [])
	var current: Array = current_value.duplicate(true) if current_value is Array else []
	for i in range(current.size() - 1, -1, -1):
		var existing: Variant = current[i]
		if existing is Dictionary and str(existing.get("family", "")) == device_family:
			current.remove_at(i)
	current.append(encoded)
	_custom_bindings[action] = current
	_apply_action_binding(action)
	_save()
	binding_changed.emit(action)
	return true


func get_binding_labels(action: String) -> Array[String]:
	var labels: Array[String] = []
	if not InputMap.has_action(action):
		return labels
	for event: InputEvent in InputMap.action_get_events(action):
		labels.append(_event_label(event))
	return labels


func get_ui_scale() -> float:
	return float(values.get("ui_scale", 1.0))


func get_text_scale() -> float:
	return float(values.get("text_scale", 1.0))


func should_show_damage_numbers() -> bool:
	return bool(values.get("damage_numbers", true))


func vibration_enabled() -> bool:
	return bool(values.get("vibration_enabled", true))


func get_vibration_strength() -> float:
	return float(values.get("vibration_strength", 1.0))


func _normalize_setting(key: String, value: Variant) -> Variant:
	match key:
		"master_volume", "music_volume", "sfx_volume", "ambience_volume", "vibration_strength", "screen_shake":
			return clampf(float(value), 0.0, 1.0)
		"ui_scale", "text_scale":
			return clampf(float(value), 0.75, 1.50)
		"dialogue_text_speed":
			return clampf(float(value), 0.50, 2.00)
		"vibration_enabled", "reduced_flashing", "reduced_intense_vfx", "high_contrast", "damage_numbers", "instant_text":
			return bool(value)
		"block_mode":
			return "toggle" if str(value).to_lower() == "toggle" else "hold"
	return value


func _apply_audio() -> void:
	_apply_bus("Master", float(values.get("master_volume", 1.0)))
	_apply_bus("Music", float(values.get("music_volume", 0.8)))
	_apply_bus("SFX", float(values.get("sfx_volume", 0.9)))
	_apply_bus("Ambience", float(values.get("ambience_volume", 0.8)))


func _apply_bus(bus_name: String, linear: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index < 0:
		return
	AudioServer.set_bus_volume_db(index, linear_to_db(maxf(0.0001, linear)))
	AudioServer.set_bus_mute(index, linear <= 0.0001)


func _save() -> void:
	var file := ConfigFile.new()
	for key: String in DEFAULTS.keys():
		file.set_value(SECTION, key, values.get(key, DEFAULTS[key]))
	for action: String in _custom_bindings.keys():
		file.set_value(BINDINGS_SECTION, action, _custom_bindings[action])
	var err := file.save(SAVE_PATH)
	if err != OK:
		push_warning("[Settings] Could not save settings: %s" % error_string(err))


func _load() -> void:
	values = DEFAULTS.duplicate(true)
	_custom_bindings.clear()
	var file := ConfigFile.new()
	if file.load(SAVE_PATH) != OK:
		return
	for key: String in DEFAULTS.keys():
		values[key] = _normalize_setting(key, file.get_value(SECTION, key, DEFAULTS[key]))
	for action: String in BINDABLE_ACTIONS:
		var stored: Variant = file.get_value(BINDINGS_SECTION, action, [])
		if stored is Array and not stored.is_empty():
			_custom_bindings[action] = stored


func _apply_bindings() -> void:
	for action: String in _custom_bindings.keys():
		_apply_action_binding(action)


func _apply_action_binding(action: String) -> void:
	if not InputMap.has_action(action):
		return
	var stored_value: Variant = _custom_bindings.get(action, [])
	if not (stored_value is Array):
		return
	var stored: Array = stored_value
	if stored.is_empty():
		return
	# Keep project defaults for any device family the player has not overridden.
	var overridden_families: Dictionary = {}
	for encoded_value: Variant in stored:
		if encoded_value is Dictionary:
			overridden_families[str(encoded_value.get("family", ""))] = true
	var defaults := InputMap.action_get_events(action).duplicate()
	InputMap.action_erase_events(action)
	for default_event: InputEvent in defaults:
		if not overridden_families.has(_device_family(default_event)):
			InputMap.action_add_event(action, default_event)
	for encoded_value: Variant in stored:
		if not (encoded_value is Dictionary):
			continue
		var decoded := _decode_event(encoded_value)
		if decoded != null:
			InputMap.action_add_event(action, decoded)


func _reset_bindings_to_project_defaults() -> void:
	# Project defaults are restored on the next launch after the custom binding section
	# is cleared. During the current session, reload project.godot's InputMap settings.
	for action: String in BINDABLE_ACTIONS:
		if not InputMap.has_action(action):
			continue
		var property_name := "input/%s" % action
		var config_value: Variant = ProjectSettings.get_setting(property_name, null)
		if not (config_value is Dictionary):
			continue
		InputMap.action_erase_events(action)
		var events_value: Variant = config_value.get("events", [])
		if events_value is Array:
			for event_value: Variant in events_value:
				if event_value is InputEvent:
					InputMap.action_add_event(action, event_value)


func _encode_event(event: InputEvent) -> Dictionary:
	if event is InputEventKey:
		return {
			"family": "keyboard_mouse",
			"type": "key",
			"physical_keycode": int((event as InputEventKey).physical_keycode),
			"keycode": int((event as InputEventKey).keycode),
		}
	if event is InputEventMouseButton:
		return {
			"family": "keyboard_mouse",
			"type": "mouse_button",
			"button_index": int((event as InputEventMouseButton).button_index),
		}
	if event is InputEventJoypadButton:
		return {
			"family": "controller",
			"type": "joy_button",
			"button_index": int((event as InputEventJoypadButton).button_index),
		}
	if event is InputEventJoypadMotion and absf((event as InputEventJoypadMotion).axis_value) >= 0.5:
		return {
			"family": "controller",
			"type": "joy_axis",
			"axis": int((event as InputEventJoypadMotion).axis),
			"axis_value": 1.0 if (event as InputEventJoypadMotion).axis_value > 0.0 else -1.0,
		}
	return {}


func _decode_event(encoded: Dictionary) -> InputEvent:
	match str(encoded.get("type", "")):
		"key":
			var event := InputEventKey.new()
			event.physical_keycode = int(encoded.get("physical_keycode", 0))
			event.keycode = int(encoded.get("keycode", 0))
			return event
		"mouse_button":
			var event := InputEventMouseButton.new()
			event.button_index = int(encoded.get("button_index", MOUSE_BUTTON_LEFT)) as MouseButton
			return event
		"joy_button":
			var event := InputEventJoypadButton.new()
			event.button_index = int(encoded.get("button_index", 0)) as JoyButton
			return event
		"joy_axis":
			var event := InputEventJoypadMotion.new()
			event.axis = int(encoded.get("axis", 0)) as JoyAxis
			event.axis_value = float(encoded.get("axis_value", 1.0))
			return event
	return null


func _device_family(event: InputEvent) -> String:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		return "controller"
	if event is InputEventKey or event is InputEventMouseButton:
		return "keyboard_mouse"
	return "other"


func _event_label(event: InputEvent) -> String:
	if event is InputEventKey:
		var key := event as InputEventKey
		var code := key.physical_keycode if key.physical_keycode != 0 else key.keycode
		return OS.get_keycode_string(code)
	if event is InputEventMouseButton:
		return "Mouse %d" % int((event as InputEventMouseButton).button_index)
	if event is InputEventJoypadButton:
		return "Pad Button %d" % int((event as InputEventJoypadButton).button_index)
	if event is InputEventJoypadMotion:
		var axis := event as InputEventJoypadMotion
		return "Pad Axis %d %s" % [int(axis.axis), "+" if axis.axis_value > 0.0 else "-"]
	return event.as_text()
