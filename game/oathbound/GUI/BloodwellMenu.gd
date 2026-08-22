extends Control

## Current Bloodwell presentation for the approved 10 Akio + 8 Run Infrastructure
## permanent nodes. Values/prices are first-playtest tuning owned centrally by the
## Strand progression runtime.

signal menu_closed
signal upgrade_purchased(upgrade_id: String)

const COLOR_BG := Color(0.06, 0.06, 0.08, 0.98)
const COLOR_PANEL := Color(0.10, 0.10, 0.13, 1.0)
const COLOR_PANEL_LOCKED := Color(0.08, 0.08, 0.10, 0.75)
const COLOR_ACCENT := Color(0.66, 0.48, 0.87, 1.0)
const COLOR_TEXT := Color(0.90, 0.90, 0.88, 1.0)
const COLOR_TEXT_DIM := Color(0.56, 0.54, 0.60, 1.0)

var _prev_paused := false
var _active_group := "akio"
var _content: VBoxContainer
var _resource_label: Label
var _akio_button: Button
var _infrastructure_button: Button


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
	dimmer.color = Color(0, 0, 0, 0.72)
	add_child(dimmer)
	var panel := PanelContainer.new()
	panel.anchor_left = 0.08
	panel.anchor_top = 0.08
	panel.anchor_right = 0.92
	panel.anchor_bottom = 0.92
	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = COLOR_BG
	panel_style.border_color = COLOR_ACCENT
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(6)
	panel.add_theme_stylebox_override("panel", panel_style)
	add_child(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 12)
	margin.add_theme_constant_override("margin_bottom", 12)
	panel.add_child(margin)
	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	margin.add_child(root)
	var title_row := HBoxContainer.new()
	root.add_child(title_row)
	var title := Label.new()
	title.text = "BLOODWELL"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 20)
	title.add_theme_color_override("font_color", COLOR_ACCENT)
	title_row.add_child(title)
	_resource_label = Label.new()
	_resource_label.add_theme_font_size_override("font_size", 10)
	_resource_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	title_row.add_child(_resource_label)
	var close_button := Button.new()
	close_button.text = "Close"
	close_button.pressed.connect(_close)
	title_row.add_child(close_button)
	var intro := Label.new()
	intro.text = "Permanent Akio and Run Infrastructure progression. Mist and regional boss materials persist immediately."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.add_theme_font_size_override("font_size", 10)
	intro.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	root.add_child(intro)
	var tabs := HBoxContainer.new()
	tabs.add_theme_constant_override("separation", 8)
	root.add_child(tabs)
	_akio_button = Button.new()
	_akio_button.text = "AKIO"
	_akio_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_akio_button.pressed.connect(_set_group.bind("akio"))
	tabs.add_child(_akio_button)
	_infrastructure_button = Button.new()
	_infrastructure_button.text = "RUN INFRASTRUCTURE"
	_infrastructure_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_infrastructure_button.pressed.connect(_set_group.bind("run_infrastructure"))
	tabs.add_child(_infrastructure_button)
	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_theme_constant_override("separation", 8)
	scroll.add_child(_content)


func _set_group(group_name: String) -> void:
	_active_group = group_name
	_refresh()


func _refresh() -> void:
	if _content == null:
		return
	_resource_label.text = "Mist %d   Keeper %d   Twin %d   Shogun %d" % [
		int(MetaProgress.mist), MetaProgress.get_boss_material("keeper"),
		MetaProgress.get_boss_material("twin_maws"), MetaProgress.get_boss_material("eclipse_shogun")]
	_akio_button.disabled = _active_group == "akio"
	_infrastructure_button.disabled = _active_group == "run_infrastructure"
	for child in _content.get_children():
		child.queue_free()
	for data_value in MetaProgressionManager.get_nodes_for_station("bloodwell"):
		var data: Dictionary = data_value as Dictionary
		if str(data.get("group", "")) == _active_group:
			_content.add_child(_build_node_card(data))


func _build_node_card(data: Dictionary) -> Control:
	var available := bool(data.get("available", false))
	var owned := bool(data.get("owned", false))
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_PANEL if available or owned else COLOR_PANEL_LOCKED
	style.border_color = COLOR_ACCENT if available or owned else COLOR_TEXT_DIM
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	card.add_theme_stylebox_override("panel", style)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	card.add_child(row)
	var text_box := VBoxContainer.new()
	text_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.add_child(text_box)
	var name_label := Label.new()
	name_label.text = "%s%s" % ["✓ " if owned else "", str(data.get("name", data.get("id", "Upgrade")))]
	name_label.add_theme_font_size_override("font_size", 12)
	name_label.add_theme_color_override("font_color", COLOR_TEXT if available or owned else COLOR_TEXT_DIM)
	text_box.add_child(name_label)
	var effect_label := Label.new()
	effect_label.text = _effect_text(data)
	effect_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect_label.add_theme_font_size_override("font_size", 9)
	effect_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	text_box.add_child(effect_label)
	var state_label := Label.new()
	state_label.text = _state_text(data)
	state_label.add_theme_font_size_override("font_size", 9)
	state_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	text_box.add_child(state_label)
	var buy := Button.new()
	buy.custom_minimum_size = Vector2(118, 0)
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
	var text := "%d Mist" % int(cost.get("mist", 0))
	if not str(cost.get("material", "")).is_empty():
		text += " + %d %s" % [int(cost.get("material_cost", 0)), _material_name(str(cost.get("material", "")))]
	return text


func _effect_text(data: Dictionary) -> String:
	var effects_value: Variant = data.get("effects", {})
	if not (effects_value is Dictionary):
		return "Permanent reliability upgrade"
	var parts: Array[String] = []
	for key in (effects_value as Dictionary):
		parts.append(_effect_piece(str(key), float((effects_value as Dictionary)[key])))
	return ", ".join(parts)


func _effect_piece(key: String, value: float) -> String:
	match key:
		"max_health": return "+%d max Health" % int(value)
		"max_posture": return "+%d max Posture" % int(value)
		"max_spirit": return "+%d max Spirit" % int(value)
		"rest_heal_mult": return "+%d%% Rest recovery" % int(round((value - 1.0) * 100.0))
		"recovery_heal_mult": return "+%d%% approved Health recovery" % int(round((value - 1.0) * 100.0))
		"posture_recovery_mult": return "+%d%% posture recovery" % int(round((value - 1.0) * 100.0))
		"parry_posture_clear": return "Parries clear %d posture" % int(value)
		"deathblow_posture_clear": return "Deathblows clear %d posture" % int(value)
		"starting_rerolls": return "+%d Technique reroll per run" % int(value)
		"resist_corruption_target": return "Resist returns Corruption to %d" % int(value)
		"route_intelligence": return "Improved route information"
		"persistent_reward_mult": return "+%d%% approved persistent rewards" % int(round((value - 1.0) * 100.0))
		"keeper_passage", "twin_passage", "heart_passage": return "Improves authored transition support"
	return "Permanent reliability improvement"


func _state_text(data: Dictionary) -> String:
	if bool(data.get("owned", false)):
		return "Owned permanently"
	if bool(data.get("available", false)):
		return "Available"
	match str(data.get("stage", "")):
		"after_keeper", "after_keeper_or_later": return "Unlocks after first Keeper defeat"
		"after_twin_maws": return "Unlocks after first Twin Maws defeat"
		"after_shogun": return "Unlocks after first Shogun defeat / first Binding clear"
	return "Locked"


func _material_name(key: String) -> String:
	match key:
		"keeper": return "Keeper material"
		"twin_maws": return "Twin Maws material"
		"eclipse_shogun": return "Shogun material"
	return "boss material"


func _close() -> void:
	get_tree().paused = _prev_paused
	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = true
	menu_closed.emit()
	queue_free()
