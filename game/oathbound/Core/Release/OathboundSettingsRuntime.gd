extends Node

## Release settings/accessibility authority. Values are persistent and applied at startup.

signal settings_changed
signal input_device_changed(device_kind: String)

const SAVE_PATH := "user://oathbound_settings.cfg"
const SECTION := "settings"
const REBIND_ACTIONS := ["up", "down", "left", "right", "attack", "dash", "parry", "interact", "special", "prosthetic"]

var master_volume := 1.0
var music_volume := 1.0
var sfx_volume := 1.0
var ambience_volume := 1.0
var vibration_enabled := true
var vibration_strength := 1.0
var screen_shake := true
var reduced_flashing := false
var reduced_vfx := false
var high_contrast := false
var damage_numbers := true
var ui_scale := 1.0
var text_scale := 1.0
var dialogue_text_speed := 1.0
var instant_text := false
var hold_to_toggle := false
var last_input_device := "keyboard_mouse"


func _ready() -> void:
	_load()
	_apply_audio()
	_apply_saved_bindings()


func set_setting(key: String, value: Variant) -> bool:
	match key:
		"master_volume": master_volume = clampf(float(value), 0.0, 1.0)
		"music_volume": music_volume = clampf(float(value), 0.0, 1.0)
		"sfx_volume": sfx_volume = clampf(float(value), 0.0, 1.0)
		"ambience_volume": ambience_volume = clampf(float(value), 0.0, 1.0)
		"vibration_enabled": vibration_enabled = bool(value)
		"vibration_strength": vibration_strength = clampf(float(value), 0.0, 1.0)
		"screen_shake": screen_shake = bool(value)
		"reduced_flashing": reduced_flashing = bool(value)
		"reduced_vfx": reduced_vfx = bool(value)
		"high_contrast": high_contrast = bool(value)
		"damage_numbers": damage_numbers = bool(value)
		"ui_scale": ui_scale = clampf(float(value), 0.75, 1.5)
		"text_scale": text_scale = clampf(float(value), 0.8, 1.5)
		"dialogue_text_speed": dialogue_text_speed = clampf(float(value), 0.5, 2.0)
		"instant_text": instant_text = bool(value)
		"hold_to_toggle": hold_to_toggle = bool(value)
		_: return false
	_save()
	_apply_audio()
	settings_changed.emit()
	return true


func get_setting(key: String, default_value: Variant = null) -> Variant:
	match key:
		"master_volume": return master_volume
		"music_volume": return music_volume
		"sfx_volume": return sfx_volume
		"ambience_volume": return ambience_volume
		"vibration_enabled": return vibration_enabled
		"vibration_strength": return vibration_strength
		"screen_shake": return screen_shake
		"reduced_flashing": return reduced_flashing
		"reduced_vfx": return reduced_vfx
		"high_contrast": return high_contrast
		"damage_numbers": return damage_numbers
		"ui_scale": return ui_scale
		"text_scale": return text_scale
		"dialogue_text_speed": return dialogue_text_speed
		"instant_text": return instant_text
		"hold_to_toggle": return hold_to_toggle
	return default_value


func rebind_action(action: String, event: InputEvent) -> bool:
	if action not in REBIND_ACTIONS or event == null:
		return false
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)
	_save_binding(action, event)
	settings_changed.emit()
	return true


func reset_binding(action: String) -> void:
	var defaults := _default_event_for(action)
	if defaults == null:
		return
	rebind_action(action, defaults)


func reset_all_bindings() -> void:
	for action in REBIND_ACTIONS:
		reset_binding(action)


func binding_label(action: String) -> String:
	var events := InputMap.action_get_events(action)
	if events.is_empty():
		return "Unbound"
	return _event_label(events[0])


func note_input(event: InputEvent) -> void:
	var kind := last_input_device
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		kind = "controller"
	elif event is InputEventKey or event is InputEventMouse:
		kind = "keyboard_mouse"
	if kind != last_input_device:
		last_input_device = kind
		input_device_changed.emit(kind)


func vibration(strength: float = 1.0, duration_seconds: float = 0.08) -> void:
	if not vibration_enabled or last_input_device != "controller":
		return
	var magnitude := clampf(strength * vibration_strength, 0.0, 1.0)
	Input.start_joy_vibration(0, magnitude, magnitude, duration_seconds)


func _load() -> void:
	var file := ConfigFile.new()
	if file.load(SAVE_PATH) != OK:
		return
	master_volume = clampf(float(file.get_value(SECTION, "master_volume", master_volume)), 0.0, 1.0)
	music_volume = clampf(float(file.get_value(SECTION, "music_volume", music_volume)), 0.0, 1.0)
	sfx_volume = clampf(float(file.get_value(SECTION, "sfx_volume", sfx_volume)), 0.0, 1.0)
	ambience_volume = clampf(float(file.get_value(SECTION, "ambience_volume", ambience_volume)), 0.0, 1.0)
	vibration_enabled = bool(file.get_value(SECTION, "vibration_enabled", vibration_enabled))
	vibration_strength = clampf(float(file.get_value(SECTION, "vibration_strength", vibration_strength)), 0.0, 1.0)
	screen_shake = bool(file.get_value(SECTION, "screen_shake", screen_shake))
	reduced_flashing = bool(file.get_value(SECTION, "reduced_flashing", reduced_flashing))
	reduced_vfx = bool(file.get_value(SECTION, "reduced_vfx", reduced_vfx))
	high_contrast = bool(file.get_value(SECTION, "high_contrast", high_contrast))
	damage_numbers = bool(file.get_value(SECTION, "damage_numbers", damage_numbers))
	ui_scale = clampf(float(file.get_value(SECTION, "ui_scale", ui_scale)), 0.75, 1.5)
	text_scale = clampf(float(file.get_value(SECTION, "text_scale", text_scale)), 0.8, 1.5)
	dialogue_text_speed = clampf(float(file.get_value(SECTION, "dialogue_text_speed", dialogue_text_speed)), 0.5, 2.0)
	instant_text = bool(file.get_value(SECTION, "instant_text", instant_text))
	hold_to_toggle = bool(file.get_value(SECTION, "hold_to_toggle", hold_to_toggle))


func _save() -> void:
	var file := ConfigFile.new()
	if FileAccess.file_exists(SAVE_PATH):
		file.load(SAVE_PATH)
	for key in ["master_volume", "music_volume", "sfx_volume", "ambience_volume", "vibration_enabled", "vibration_strength", "screen_shake", "reduced_flashing", "reduced_vfx", "high_contrast", "damage_numbers", "ui_scale", "text_scale", "dialogue_text_speed", "instant_text", "hold_to_toggle"]:
		file.set_value(SECTION, key, get_setting(key))
	file.save(SAVE_PATH)


func _save_binding(action: String, event: InputEvent) -> void:
	var file := ConfigFile.new()
	if FileAccess.file_exists(SAVE_PATH):
		file.load(SAVE_PATH)
	file.set_value("bindings", action, event)
	file.save(SAVE_PATH)


func _apply_saved_bindings() -> void:
	var file := ConfigFile.new()
	if file.load(SAVE_PATH) != OK:
		return
	for action in REBIND_ACTIONS:
		var event: Variant = file.get_value("bindings", action, null)
		if event is InputEvent:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)


func _apply_audio() -> void:
	_apply_bus("Master", master_volume)
	_apply_bus("Music", music_volume)
	_apply_bus("SFX", sfx_volume)
	_apply_bus("Ambience", ambience_volume)


func _apply_bus(bus_name: String, linear: float) -> void:
	var index := AudioServer.get_bus_index(bus_name)
	if index < 0:
		return
	AudioServer.set_bus_volume_db(index, linear_to_db(maxf(linear, 0.0001)))
	AudioServer.set_bus_mute(index, linear <= 0.0001)


func _default_event_for(action: String) -> InputEvent:
	var key := InputEventKey.new()
	match action:
		"up": key.physical_keycode = KEY_W
		"down": key.physical_keycode = KEY_S
		"left": key.physical_keycode = KEY_A
		"right": key.physical_keycode = KEY_D
		"dash": key.physical_keycode = KEY_SPACE
		"interact": key.physical_keycode = KEY_E
		"special": key.physical_keycode = KEY_Q
		"prosthetic": key.physical_keycode = KEY_F
		"attack":
			var mouse := InputEventMouseButton.new(); mouse.button_index = MOUSE_BUTTON_LEFT; return mouse
		"parry":
			var mouse := InputEventMouseButton.new(); mouse.button_index = MOUSE_BUTTON_RIGHT; return mouse
		_: return null
	return key


func _event_label(event: InputEvent) -> String:
	if event is InputEventKey:
		return OS.get_keycode_string((event as InputEventKey).physical_keycode)
	if event is InputEventMouseButton:
		return "Mouse %d" % int((event as InputEventMouseButton).button_index)
	if event is InputEventJoypadButton:
		return "Pad Button %d" % int((event as InputEventJoypadButton).button_index)
	if event is InputEventJoypadMotion:
		return "Pad Axis %d" % int((event as InputEventJoypadMotion).axis)
	return "Input"
