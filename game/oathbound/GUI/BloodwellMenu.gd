extends Control

## Canonical Bloodwell presentation for the current permanent-progression structure.
## Numerical node effects and final Mist prices are intentionally not purchaseable
## until their owning design pass defines them in PROGRESSION.md.

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
	dimmer.color = Color(0.0, 0.0, 0.0, 0.72)
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
	intro.text = "Permanent Akio and Run Infrastructure progression. Final node values and Mist prices remain prototype tuning work."
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

	_resource_label.text = "Mist %d   Keeper %d   Twin Maws %d   Shogun %d" % [
		int(MetaProgress.mist),
		MetaProgress.get_boss_material(MetaProgress.BOSS_MATERIAL_KEEPER),
		MetaProgress.get_boss_material(MetaProgress.BOSS_MATERIAL_TWIN_MAWS),
		MetaProgress.get_boss_material(MetaProgress.BOSS_MATERIAL_ECLIPSE_SHOGUN),
	]

	_akio_button.disabled = _active_group == "akio"
	_infrastructure_button.disabled = _active_group == "run_infrastructure"

	for child in _content.get_children():
		child.queue_free()

	for data in MetaProgressionManager.get_structural_nodes(MetaProgressionManager.STATION_BLOODWELL):
		if str(data.get("group", "")) != _active_group:
			continue
		_content.add_child(_build_node_card(data))


func _build_node_card(data: Dictionary) -> Control:
	var available := _stage_reached(str(data.get("stage", "")))
	var card := PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var style := StyleBoxFlat.new()
	style.bg_color = COLOR_PANEL if available else COLOR_PANEL_LOCKED
	style.border_color = COLOR_ACCENT if available else COLOR_TEXT_DIM
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	card.add_theme_stylebox_override("panel", style)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	card.add_child(box)

	var name_label := Label.new()
	name_label.text = str(data.get("name", data.get("id", "Upgrade")))
	name_label.add_theme_font_size_override("font_size", 12)
	name_label.add_theme_color_override("font_color", COLOR_TEXT if available else COLOR_TEXT_DIM)
	box.add_child(name_label)

	var gate_label := Label.new()
	gate_label.add_theme_font_size_override("font_size", 9)
	gate_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	gate_label.text = _stage_text(str(data.get("stage", "")), available)
	box.add_child(gate_label)

	if data.has("boss_material"):
		var material_key := str(data.get("boss_material", ""))
		var material_label := Label.new()
		material_label.add_theme_font_size_override("font_size", 9)
		material_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		material_label.text = "Major mastery gate • %s material owned: %d" % [
			_material_display_name(material_key),
			MetaProgress.get_boss_material(material_key),
		]
		box.add_child(material_label)

	var pending := Label.new()
	pending.text = "Approved structure • exact numerical effect and Mist price pending tuning"
	pending.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	pending.add_theme_font_size_override("font_size", 9)
	pending.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	box.add_child(pending)

	return card


func _stage_reached(stage: String) -> bool:
	match stage:
		MetaProgressionManager.STAGE_AFTER_KEEPER, MetaProgressionManager.STAGE_AFTER_KEEPER_OR_LATER:
			return MetaProgress.has_cleared_boss(1)
		MetaProgressionManager.STAGE_AFTER_TWIN_MAWS:
			return MetaProgress.has_cleared_boss(2)
		MetaProgressionManager.STAGE_AFTER_SHOGUN:
			return MetaProgress.has_cleared_boss(3)
		_:
			# Bloodwell is only presented after Returning Blood has opened the station.
			return true


func _stage_text(stage: String, available: bool) -> String:
	if available:
		return "Available progression band"
	match stage:
		MetaProgressionManager.STAGE_AFTER_KEEPER, MetaProgressionManager.STAGE_AFTER_KEEPER_OR_LATER:
			return "Unlocks after the first Keeper defeat"
		MetaProgressionManager.STAGE_AFTER_TWIN_MAWS:
			return "Unlocks after the first Twin Maws defeat"
		MetaProgressionManager.STAGE_AFTER_SHOGUN:
			return "Unlocks after the first Shogun defeat / Binding clear"
		_:
			return "Locked"


func _material_display_name(material_key: String) -> String:
	match material_key:
		MetaProgress.BOSS_MATERIAL_KEEPER:
			return "Keeper"
		MetaProgress.BOSS_MATERIAL_TWIN_MAWS:
			return "Twin Maws"
		MetaProgress.BOSS_MATERIAL_ECLIPSE_SHOGUN:
			return "Shogun"
		_:
			return "Regional boss"


func _close() -> void:
	get_tree().paused = _prev_paused
	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = true
	menu_closed.emit()
	queue_free()
