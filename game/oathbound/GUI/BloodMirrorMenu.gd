extends Control

## Blood Mirror — persistent Blood Aspect progression.
## PROGRESSION.md owns the three-node-per-Aspect structure and campaign cadence.

signal menu_closed
signal upgrade_purchased(upgrade_id: String)

const COLOR_BG := Color(0.055, 0.045, 0.065, 0.98)
const COLOR_PANEL := Color(0.11, 0.08, 0.13, 1.0)
const COLOR_LOCKED := Color(0.075, 0.065, 0.085, 0.78)
const COLOR_ACCENT := Color(0.72, 0.30, 0.40, 1.0)
const COLOR_TEXT := Color(0.92, 0.90, 0.90, 1.0)
const COLOR_DIM := Color(0.60, 0.55, 0.62, 1.0)

var _prev_paused := false
var _active_aspect := "wolf"
var _content: VBoxContainer
var _resource_label: Label
var _status_label: Label
var _aspect_buttons: Dictionary = {}


func _ready() -> void:
	_prev_paused = get_tree().paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = false
	_build_ui()
	_refresh()
	if MetaProgress != null and MetaProgress.has_signal("persistent_resources_changed"):
		MetaProgress.persistent_resources_changed.connect(_refresh)
	if MetaProgress != null and MetaProgress.has_signal("progression_changed"):
		MetaProgress.progression_changed.connect(_refresh)
	if MetaProgressionManager != null and MetaProgressionManager.has_signal("changed"):
		MetaProgressionManager.changed.connect(_refresh)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	var dimmer := ColorRect.new()
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0, 0, 0, 0.76)
	add_child(dimmer)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.12
	panel.anchor_top = 0.10
	panel.anchor_right = 0.88
	panel.anchor_bottom = 0.90
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = COLOR_BG
	panel_style.border_color = COLOR_ACCENT
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(6)
	panel.add_theme_stylebox_override("panel", panel_style)
	add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 18)
	margin.add_theme_constant_override("margin_right", 18)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)

	var title_row := HBoxContainer.new()
	root.add_child(title_row)
	var title := Label.new()
	title.text = "BLOOD MIRROR"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", COLOR_ACCENT)
	title_row.add_child(title)
	_resource_label = Label.new()
	_resource_label.add_theme_font_size_override("font_size", 10)
	_resource_label.add_theme_color_override("font_color", COLOR_DIM)
	title_row.add_child(_resource_label)
	var close_button := Button.new()
	close_button.text = "Close"
	close_button.pressed.connect(_close)
	title_row.add_child(close_button)

	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status_label.add_theme_font_size_override("font_size", 10)
	_status_label.add_theme_color_override("font_color", COLOR_DIM)
	root.add_child(_status_label)

	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	root.add_child(tabs)
	for aspect_id in ["wolf", "wraith", "ronin"]:
		var button := Button.new()
		button.text = str(aspect_id).capitalize()
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_set_aspect.bind(aspect_id))
		tabs.add_child(button)
		_aspect_buttons[aspect_id] = button

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_theme_constant_override("separation", 8)
	scroll.add_child(_content)


func _set_aspect(aspect_id: String) -> void:
	_active_aspect = aspect_id
	_refresh()


func _refresh() -> void:
	if _content == null:
		return
	_resource_label.text = "Mist %d" % int(MetaProgress.mist)
	var mirror_unlocked := bool(MetaProgressionManager.is_blood_mirror_unlocked())
	_status_label.text = (
		"Permanent Blood Aspect reliability. The Mirror awakens after the first Keeper defeat; deeper nodes unlock after Twin Maws and the Shogun."
		if mirror_unlocked else
		"Dormant. Defeat the Keeper once to awaken the Blood Mirror."
	)
	for aspect_id in _aspect_buttons:
		(_aspect_buttons[aspect_id] as Button).disabled = aspect_id == _active_aspect
	for child in _content.get_children():
		child.queue_free()
	for data_value in MetaProgressionManager.get_nodes_for_station("blood_mirror"):
		var data: Dictionary = data_value as Dictionary
		if str(data.get("group", "")) == _active_aspect:
			_content.add_child(_build_node_card(data, mirror_unlocked))


func _build_node_card(data: Dictionary, mirror_unlocked: bool) -> Control:
	var available := mirror_unlocked and bool(data.get("available", false))
	var owned := bool(data.get("owned", false))
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_PANEL if available or owned else COLOR_LOCKED
	style.border_color = COLOR_ACCENT if available or owned else COLOR_DIM
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(9)
	card.add_theme_stylebox_override("panel", style)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	card.add_child(row)
	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_box)

	var name_label := Label.new()
	name_label.text = "%s%s" % ["✓ " if owned else "", str(data.get("name", "Blood Mirror node"))]
	name_label.add_theme_font_size_override("font_size", 12)
	name_label.add_theme_color_override("font_color", COLOR_TEXT if available or owned else COLOR_DIM)
	text_box.add_child(name_label)

	var effect := Label.new()
	effect.text = _effect_text(data)
	effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect.add_theme_font_size_override("font_size", 9)
	effect.add_theme_color_override("font_color", COLOR_DIM)
	text_box.add_child(effect)

	var state := Label.new()
	state.text = _state_text(data, mirror_unlocked)
	state.add_theme_font_size_override("font_size", 9)
	state.add_theme_color_override("font_color", COLOR_DIM)
	text_box.add_child(state)

	var buy := Button.new()
	buy.custom_minimum_size = Vector2(112, 0)
	buy.text = "Purchased" if owned else _cost_text(data)
	buy.disabled = owned or not bool(MetaProgressionManager.can_purchase_node(str(data.get("id", ""))))
	buy.pressed.connect(_purchase.bind(str(data.get("id", ""))))
	row.add_child(buy)
	return card


func _purchase(node_id: String) -> void:
	if MetaProgressionManager.purchase_node(node_id):
		upgrade_purchased.emit(node_id)
	_refresh()


func _cost_text(data: Dictionary) -> String:
	var cost: Dictionary = MetaProgressionManager.get_node_cost(str(data.get("id", "")))
	return "%d Mist" % int(cost.get("mist", 0))


func _effect_text(data: Dictionary) -> String:
	var effects_value: Variant = data.get("effects", {})
	if not (effects_value is Dictionary):
		return "Aspect reliability improvement"
	var effects := effects_value as Dictionary
	for key_value in effects.keys():
		var key := str(key_value)
		var value := float(effects[key_value])
		match key:
			"wolf_recovery_mult": return "Wolf Tier 0 attack recovery -%d%%" % int(round((1.0 - value) * 100.0))
			"wolf_signature_recovery_mult": return "Wolf signature recovery -%d%%" % int(round((1.0 - value) * 100.0))
			"wolf_blood_hunt_heal_bonus": return "Blood Hunt heal +%d" % int(value)
			"wraith_recovery_mult": return "Wraith Tier 0 attack recovery -%d%%" % int(round((1.0 - value) * 100.0))
			"wraith_spectral_min_range_mult": return "Spectral minimum range -%d%%" % int(round((1.0 - value) * 100.0))
			"wraith_blood_recovery_mult": return "Wraith Blood recovery -%d%%" % int(round((1.0 - value) * 100.0))
			"ronin_recovery_mult": return "Ronin Tier 0 attack recovery -%d%%" % int(round((1.0 - value) * 100.0))
			"ronin_block_posture_mult": return "Ronin block posture cost -%d%%" % int(round((1.0 - value) * 100.0))
			"ronin_falling_mountain_posture_bonus": return "Falling Mountain posture damage +%d" % int(value)
	return "Aspect reliability improvement"


func _state_text(data: Dictionary, mirror_unlocked: bool) -> String:
	if bool(data.get("owned", false)):
		return "Owned permanently"
	if not mirror_unlocked:
		return "Blood Mirror unlocks after first Keeper defeat"
	if bool(data.get("available", false)):
		return "Available"
	match str(data.get("stage", "")):
		"after_twin_maws": return "Unlocks after first Twin Maws defeat"
		"after_shogun": return "Unlocks after first Shogun defeat / first Binding clear"
	return "Locked"


func _close() -> void:
	get_tree().paused = _prev_paused
	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = true
	menu_closed.emit()
	queue_free()
