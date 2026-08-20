extends Control

## ForgeMenu — Full Forge Bench UI built entirely in script.
## Attach this to an empty Control node and save as ForgeMenu.tscn.
## Uses anchor-based layout so it works at any viewport resolution.

signal prosthetic_equipped(prosthetic_id: String)
signal menu_closed

# --- Colors ---
const COLOR_BG = Color(0.08, 0.08, 0.12, 0.95)
const COLOR_PANEL = Color(0.12, 0.12, 0.18, 1.0)
const COLOR_PANEL_HOVER = Color(0.18, 0.18, 0.25, 1.0)
const COLOR_PANEL_SELECTED = Color(0.15, 0.2, 0.3, 1.0)
const COLOR_ACCENT = Color(0.4, 0.7, 1.0, 1.0)
const COLOR_ACCENT_DIM = Color(0.25, 0.45, 0.7, 1.0)
const COLOR_EQUIPPED = Color(0.3, 0.85, 0.4, 1.0)
const COLOR_LOCKED = Color(0.4, 0.4, 0.4, 1.0)
const COLOR_GOLD = Color(1.0, 0.85, 0.3, 1.0)
const COLOR_RELIC_SLOT = Color(0.18, 0.14, 0.22, 1.0)
const COLOR_RELIC_FILLED = Color(0.25, 0.2, 0.35, 1.0)
const COLOR_UPGRADE_AVAILABLE = Color(0.15, 0.35, 0.2, 1.0)
const COLOR_UPGRADE_BOUGHT = Color(0.2, 0.5, 0.25, 1.0)
const COLOR_UPGRADE_LOCKED = Color(0.15, 0.15, 0.18, 1.0)
const COLOR_TEXT = Color(0.9, 0.9, 0.9, 1.0)
const COLOR_TEXT_DIM = Color(0.55, 0.55, 0.6, 1.0)
const COLOR_RED = Color(0.9, 0.3, 0.3, 1.0)

# --- State ---
var selected_prosthetic_id: String = ""
var relic_assign_slot: int = -1

# --- UI Refs ---
var list_container: VBoxContainer
var detail_container: VBoxContainer
var detail_name_label: Label
var detail_desc_label: Label
var spirit_cost_label: Label
var status_label: Label
var equip_button: Button
var relic_slots_container: HBoxContainer
var upgrade_container: VBoxContainer
var relic_popup: PanelContainer
var relic_popup_list: VBoxContainer
var no_selection_label: Label
var _prev_tree_paused: bool = false
var _pause_applied: bool = false

func _ready():
	_build_ui()
	_populate_list()

	if ProstheticManager.equipped_prosthetic_id != "":
		_select_prosthetic(ProstheticManager.equipped_prosthetic_id)

	_apply_pause(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()


# ============================
# UI CONSTRUCTION
# ============================

func _build_ui():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Full-screen dim
	var dimmer = ColorRect.new()
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0, 0, 0, 0.65)
	add_child(dimmer)

	# Main panel: 90% of viewport via anchors
	var main_panel = PanelContainer.new()
	main_panel.anchor_left = 0.05
	main_panel.anchor_top = 0.05
	main_panel.anchor_right = 0.95
	main_panel.anchor_bottom = 0.95
	main_panel.offset_left = 0
	main_panel.offset_top = 0
	main_panel.offset_right = 0
	main_panel.offset_bottom = 0
	var main_style = _make_stylebox(COLOR_BG, 4, COLOR_ACCENT_DIM, 1)
	main_panel.add_theme_stylebox_override("panel", main_style)
	add_child(main_panel)

	var root_margin = MarginContainer.new()
	root_margin.add_theme_constant_override("margin_left", 8)
	root_margin.add_theme_constant_override("margin_right", 8)
	root_margin.add_theme_constant_override("margin_top", 6)
	root_margin.add_theme_constant_override("margin_bottom", 6)
	main_panel.add_child(root_margin)

	var root_vbox = VBoxContainer.new()
	root_vbox.add_theme_constant_override("separation", 4)
	root_margin.add_child(root_vbox)

	# Title bar
	var title_bar = HBoxContainer.new()
	root_vbox.add_child(title_bar)

	var title_label = Label.new()
	title_label.text = "FORGE BENCH"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.add_theme_font_size_override("font_size", 12)
	title_label.add_theme_color_override("font_color", COLOR_ACCENT)
	title_bar.add_child(title_label)

	var close_btn = Button.new()
	close_btn.text = "X"
	close_btn.add_theme_font_size_override("font_size", 10)
	close_btn.pressed.connect(_close)
	title_bar.add_child(close_btn)

	var sep = HSeparator.new()
	root_vbox.add_child(sep)

	# Main content: left list + right detail
	var content_hbox = HBoxContainer.new()
	content_hbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content_hbox.add_theme_constant_override("separation", 6)
	root_vbox.add_child(content_hbox)

	_build_left_panel(content_hbox)
	_build_right_panel(content_hbox)

	_build_relic_popup()


func _build_left_panel(parent: Control):
	var left_panel = PanelContainer.new()
	left_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_panel.size_flags_stretch_ratio = 0.35
	var style = _make_stylebox(COLOR_PANEL, 3)
	left_panel.add_theme_stylebox_override("panel", style)
	parent.add_child(left_panel)

	var left_margin = MarginContainer.new()
	left_margin.add_theme_constant_override("margin_left", 4)
	left_margin.add_theme_constant_override("margin_right", 4)
	left_margin.add_theme_constant_override("margin_top", 4)
	left_margin.add_theme_constant_override("margin_bottom", 4)
	left_panel.add_child(left_margin)

	var left_vbox = VBoxContainer.new()
	left_vbox.add_theme_constant_override("separation", 4)
	left_margin.add_child(left_vbox)

	var list_title = Label.new()
	list_title.text = "Prosthetics"
	list_title.add_theme_font_size_override("font_size", 10)
	list_title.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	left_vbox.add_child(list_title)

	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left_vbox.add_child(scroll)

	list_container = VBoxContainer.new()
	list_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list_container.add_theme_constant_override("separation", 3)
	scroll.add_child(list_container)


func _build_right_panel(parent: Control):
	var right_panel = PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_panel.size_flags_stretch_ratio = 0.65
	var style = _make_stylebox(COLOR_PANEL, 3)
	right_panel.add_theme_stylebox_override("panel", style)
	parent.add_child(right_panel)

	var right_margin = MarginContainer.new()
	right_margin.add_theme_constant_override("margin_left", 6)
	right_margin.add_theme_constant_override("margin_right", 6)
	right_margin.add_theme_constant_override("margin_top", 4)
	right_margin.add_theme_constant_override("margin_bottom", 4)
	right_panel.add_child(right_margin)

	var scroll = ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_margin.add_child(scroll)

	detail_container = VBoxContainer.new()
	detail_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_container.add_theme_constant_override("separation", 4)
	scroll.add_child(detail_container)

	no_selection_label = Label.new()
	no_selection_label.text = "Select a prosthetic."
	no_selection_label.add_theme_font_size_override("font_size", 10)
	no_selection_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	detail_container.add_child(no_selection_label)

	var name_row = HBoxContainer.new()
	name_row.visible = false
	name_row.name = "NameRow"
	detail_container.add_child(name_row)

	detail_name_label = Label.new()
	detail_name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_name_label.add_theme_font_size_override("font_size", 12)
	detail_name_label.add_theme_color_override("font_color", COLOR_TEXT)
	name_row.add_child(detail_name_label)

	status_label = Label.new()
	status_label.add_theme_font_size_override("font_size", 9)
	status_label.add_theme_color_override("font_color", COLOR_EQUIPPED)
	name_row.add_child(status_label)

	spirit_cost_label = Label.new()
	spirit_cost_label.visible = false
	spirit_cost_label.add_theme_font_size_override("font_size", 8)
	spirit_cost_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	detail_container.add_child(spirit_cost_label)

	detail_desc_label = Label.new()
	detail_desc_label.visible = false
	detail_desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_desc_label.add_theme_font_size_override("font_size", 8)
	detail_desc_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	detail_container.add_child(detail_desc_label)

	equip_button = Button.new()
	equip_button.visible = false
	equip_button.custom_minimum_size = Vector2(60, 18)
	equip_button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	equip_button.add_theme_font_size_override("font_size", 9)
	equip_button.pressed.connect(_on_equip_pressed)
	detail_container.add_child(equip_button)

	var relic_section = VBoxContainer.new()
	relic_section.name = "RelicSection"
	relic_section.visible = false
	relic_section.add_theme_constant_override("separation", 3)
	detail_container.add_child(relic_section)

	var relic_header = Label.new()
	relic_header.text = "Relic Slots"
	relic_header.add_theme_font_size_override("font_size", 10)
	relic_header.add_theme_color_override("font_color", COLOR_ACCENT_DIM)
	relic_section.add_child(relic_header)

	relic_slots_container = HBoxContainer.new()
	relic_slots_container.add_theme_constant_override("separation", 6)
	relic_section.add_child(relic_slots_container)

	var upgrade_section = VBoxContainer.new()
	upgrade_section.name = "UpgradeSection"
	upgrade_section.visible = false
	upgrade_section.add_theme_constant_override("separation", 3)
	detail_container.add_child(upgrade_section)

	var upgrade_header = Label.new()
	upgrade_header.text = "Upgrades"
	upgrade_header.add_theme_font_size_override("font_size", 10)
	upgrade_header.add_theme_color_override("font_color", COLOR_ACCENT_DIM)
	upgrade_section.add_child(upgrade_header)

	upgrade_container = VBoxContainer.new()
	upgrade_container.add_theme_constant_override("separation", 3)
	upgrade_section.add_child(upgrade_container)


func _build_relic_popup():
	relic_popup = PanelContainer.new()
	relic_popup.visible = false
	relic_popup.z_index = 10
	relic_popup.anchor_left = 0.2
	relic_popup.anchor_top = 0.15
	relic_popup.anchor_right = 0.8
	relic_popup.anchor_bottom = 0.85
	relic_popup.offset_left = 0
	relic_popup.offset_top = 0
	relic_popup.offset_right = 0
	relic_popup.offset_bottom = 0
	var style = _make_stylebox(Color(0.1, 0.1, 0.15, 0.98), 4, COLOR_GOLD, 1)
	relic_popup.add_theme_stylebox_override("panel", style)
	add_child(relic_popup)

	var popup_margin = MarginContainer.new()
	popup_margin.add_theme_constant_override("margin_left", 6)
	popup_margin.add_theme_constant_override("margin_right", 6)
	popup_margin.add_theme_constant_override("margin_top", 4)
	popup_margin.add_theme_constant_override("margin_bottom", 4)
	relic_popup.add_child(popup_margin)

	var popup_vbox = VBoxContainer.new()
	popup_vbox.add_theme_constant_override("separation", 4)
	popup_margin.add_child(popup_vbox)

	var popup_title_row = HBoxContainer.new()
	popup_vbox.add_child(popup_title_row)

	var popup_title = Label.new()
	popup_title.text = "Choose Relic"
	popup_title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	popup_title.add_theme_font_size_override("font_size", 10)
	popup_title.add_theme_color_override("font_color", COLOR_GOLD)
	popup_title_row.add_child(popup_title)

	var popup_close = Button.new()
	popup_close.text = "X"
	popup_close.add_theme_font_size_override("font_size", 9)
	popup_close.pressed.connect(_close_relic_popup)
	popup_title_row.add_child(popup_close)

	var remove_btn = Button.new()
	remove_btn.name = "RemoveRelicBtn"
	remove_btn.text = "Remove Relic"
	remove_btn.add_theme_font_size_override("font_size", 9)
	remove_btn.pressed.connect(_on_remove_relic)
	popup_vbox.add_child(remove_btn)

	var popup_scroll = ScrollContainer.new()
	popup_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	popup_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	popup_vbox.add_child(popup_scroll)

	relic_popup_list = VBoxContainer.new()
	relic_popup_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	relic_popup_list.add_theme_constant_override("separation", 3)
	popup_scroll.add_child(relic_popup_list)


# ============================
# PROSTHETIC LIST
# ============================

func _populate_list():
	for child in list_container.get_children():
		child.queue_free()

	var unlocked = ProstheticManager.get_unlocked_prosthetics()

	if unlocked.size() == 0:
		var empty_label = Label.new()
		empty_label.text = "No prosthetics unlocked."
		empty_label.add_theme_font_size_override("font_size", 9)
		empty_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		empty_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		list_container.add_child(empty_label)
		return

	for data in unlocked:
		var item_btn = _create_list_item(data)
		list_container.add_child(item_btn)


func _create_list_item(data: ProstheticData) -> Button:
	var btn = Button.new()
	btn.custom_minimum_size = Vector2(0, 28)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
	btn.pressed.connect(_select_prosthetic.bind(data.id))

	var is_selected = (data.id == selected_prosthetic_id)
	var is_equipped = (data.id == ProstheticManager.equipped_prosthetic_id)

	var bg_color = COLOR_PANEL_SELECTED if is_selected else COLOR_PANEL
	var style_normal = _make_stylebox(bg_color, 3)
	if is_equipped:
		style_normal.border_width_left = 2
		style_normal.border_color = COLOR_EQUIPPED
	btn.add_theme_stylebox_override("normal", style_normal)

	var style_hover = _make_stylebox(COLOR_PANEL_HOVER, 3)
	if is_equipped:
		style_hover.border_width_left = 2
		style_hover.border_color = COLOR_EQUIPPED
	btn.add_theme_stylebox_override("hover", style_hover)

	var vbox = VBoxContainer.new()
	vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 0)
	btn.add_child(vbox)

	var name_label = Label.new()
	name_label.text = data.display_name
	name_label.add_theme_font_size_override("font_size", 9)
	name_label.add_theme_color_override("font_color", COLOR_TEXT)
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vbox.add_child(name_label)

	var subtitle = Label.new()
	subtitle.mouse_filter = Control.MOUSE_FILTER_IGNORE
	subtitle.add_theme_font_size_override("font_size", 7)
	if is_equipped:
		subtitle.text = "EQUIPPED"
		subtitle.add_theme_color_override("font_color", COLOR_EQUIPPED)
	else:
		var tag_text = ", ".join(data.tags) if data.tags.size() > 0 else "General"
		subtitle.text = tag_text
		subtitle.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	vbox.add_child(subtitle)

	btn.text = ""
	return btn


# ============================
# DETAIL PANEL
# ============================

func _select_prosthetic(prosthetic_id: String):
	selected_prosthetic_id = prosthetic_id
	_populate_list()
	_refresh_detail()


func _refresh_detail():
	var data = ProstheticManager.get_prosthetic(selected_prosthetic_id)
	if data == null:
		_show_detail_elements(false)
		no_selection_label.visible = true
		return

	no_selection_label.visible = false
	_show_detail_elements(true)

	var is_equipped = (ProstheticManager.equipped_prosthetic_id == selected_prosthetic_id)

	detail_name_label.text = data.display_name
	status_label.text = "EQUIPPED" if is_equipped else ""
	spirit_cost_label.text = "Spirit Cost: %d per use" % data.spirit_cost if data.spirit_cost > 0 else "Spirit Cost: Free"
	detail_desc_label.text = data.description

	equip_button.text = "Unequip" if is_equipped else "Equip"

	_refresh_relic_slots(data)
	_refresh_upgrades(data)


func _show_detail_elements(visible_state: bool):
	var name_row = detail_container.get_node_or_null("NameRow")
	if name_row:
		name_row.visible = visible_state
	spirit_cost_label.visible = visible_state
	detail_desc_label.visible = visible_state
	equip_button.visible = visible_state
	var relic_section = detail_container.get_node_or_null("RelicSection")
	if relic_section:
		relic_section.visible = visible_state
	var upgrade_section = detail_container.get_node_or_null("UpgradeSection")
	if upgrade_section:
		upgrade_section.visible = visible_state


func _on_equip_pressed():
	if selected_prosthetic_id == "":
		return

	var is_equipped = (ProstheticManager.equipped_prosthetic_id == selected_prosthetic_id)
	if is_equipped:
		ProstheticManager.unequip_prosthetic()
	else:
		ProstheticManager.equip_prosthetic(selected_prosthetic_id)
		prosthetic_equipped.emit(selected_prosthetic_id)

	_populate_list()
	_refresh_detail()


# ============================
# RELIC SLOTS
# ============================

func _refresh_relic_slots(data: ProstheticData):
	for child in relic_slots_container.get_children():
		child.queue_free()

	var slots = ProstheticManager.get_socketed_relics(data.id)

	for i in range(data.max_relic_slots):
		var relic_id = slots[i] if i < slots.size() else ""
		var is_filled = (relic_id != "")

		var slot_btn = Button.new()
		slot_btn.custom_minimum_size = Vector2(56, 28)
		slot_btn.pressed.connect(_on_relic_slot_clicked.bind(i))

		var bg_col = COLOR_RELIC_FILLED if is_filled else COLOR_RELIC_SLOT
		var border_col = COLOR_GOLD if is_filled else COLOR_TEXT_DIM
		var style = _make_stylebox(bg_col, 3, border_col, 1)
		slot_btn.add_theme_stylebox_override("normal", style)
		slot_btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 3, border_col, 1))

		var vbox = VBoxContainer.new()
		vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		vbox.alignment = BoxContainer.ALIGNMENT_CENTER
		slot_btn.add_child(vbox)

		var slot_label = Label.new()
		slot_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot_label.add_theme_font_size_override("font_size", 7)

		if is_filled:
			var relic_data = ProstheticManager.get_relic(relic_id)
			slot_label.text = relic_data.display_name if relic_data else relic_id
			slot_label.add_theme_color_override("font_color", COLOR_GOLD)
		else:
			slot_label.text = "Empty"
			slot_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		vbox.add_child(slot_label)

		var slot_num = Label.new()
		slot_num.text = "Slot %d" % (i + 1)
		slot_num.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		slot_num.mouse_filter = Control.MOUSE_FILTER_IGNORE
		slot_num.add_theme_font_size_override("font_size", 6)
		slot_num.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		vbox.add_child(slot_num)

		slot_btn.text = ""
		relic_slots_container.add_child(slot_btn)


func _on_relic_slot_clicked(slot_index: int):
	relic_assign_slot = slot_index
	_show_relic_popup()


func _show_relic_popup():
	for child in relic_popup_list.get_children():
		child.queue_free()

	var data = ProstheticManager.get_prosthetic(selected_prosthetic_id)
	var owned_relics = ProstheticManager.get_unlocked_relics()
	var current_slots = ProstheticManager.get_socketed_relics(selected_prosthetic_id)
	var current_relic = current_slots[relic_assign_slot] if relic_assign_slot < current_slots.size() else ""

	var remove_btn = relic_popup.find_child("RemoveRelicBtn", true, false)
	if remove_btn:
		remove_btn.visible = (current_relic != "")

	if owned_relics.size() == 0:
		var empty_label = Label.new()
		empty_label.text = "No relics owned."
		empty_label.add_theme_font_size_override("font_size", 9)
		empty_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		relic_popup_list.add_child(empty_label)
	else:
		for relic_data in owned_relics:
			var compatible = true
			if relic_data.compatible_tags.size() > 0 and data:
				compatible = false
				for tag in relic_data.compatible_tags:
					if data.tags.has(tag):
						compatible = true
						break

			var relic_btn = Button.new()
			relic_btn.custom_minimum_size = Vector2(0, 24)
			relic_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			relic_btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
			relic_btn.disabled = not compatible
			relic_btn.text = ""

			var btn_vbox = VBoxContainer.new()
			btn_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
			btn_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			relic_btn.add_child(btn_vbox)

			var name_lbl = Label.new()
			name_lbl.text = "%s  [%s]" % [relic_data.display_name, relic_data.rarity]
			name_lbl.add_theme_font_size_override("font_size", 8)
			name_lbl.add_theme_color_override("font_color", COLOR_TEXT if compatible else COLOR_LOCKED)
			name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			btn_vbox.add_child(name_lbl)

			var desc_lbl = Label.new()
			desc_lbl.text = relic_data.description
			desc_lbl.add_theme_font_size_override("font_size", 7)
			desc_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
			desc_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			desc_lbl.clip_text = true
			btn_vbox.add_child(desc_lbl)

			if not compatible:
				var compat_lbl = Label.new()
				compat_lbl.text = "Requires: %s" % ", ".join(relic_data.compatible_tags)
				compat_lbl.add_theme_font_size_override("font_size", 6)
				compat_lbl.add_theme_color_override("font_color", COLOR_RED)
				compat_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
				btn_vbox.add_child(compat_lbl)

			relic_btn.pressed.connect(_on_relic_chosen.bind(relic_data.id))
			relic_popup_list.add_child(relic_btn)

	relic_popup.visible = true


func _on_relic_chosen(relic_id: String):
	ProstheticManager.socket_relic(selected_prosthetic_id, relic_assign_slot, relic_id)
	_close_relic_popup()
	_refresh_detail()


func _on_remove_relic():
	if relic_assign_slot >= 0:
		ProstheticManager.remove_relic(selected_prosthetic_id, relic_assign_slot)
	_close_relic_popup()
	_refresh_detail()


func _close_relic_popup():
	relic_popup.visible = false
	relic_assign_slot = -1


# ============================
# UPGRADES
# ============================

func _refresh_upgrades(data: ProstheticData):
	for child in upgrade_container.get_children():
		child.queue_free()

	if data.upgrade_nodes.size() == 0:
		var empty_label = Label.new()
		empty_label.text = "No upgrades available."
		empty_label.add_theme_font_size_override("font_size", 9)
		empty_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		upgrade_container.add_child(empty_label)
		return

	for node_data in data.upgrade_nodes:
		var node_id = node_data.get("id", "")
		var node_name = node_data.get("name", node_id)
		var node_desc = node_data.get("description", "")
		var cost_mist = node_data.get("cost_mist_shards", 0)
		var cost_gold = node_data.get("cost_gold", 0)

		var is_bought = ProstheticManager.is_upgrade_purchased(data.id, node_id)
		var can_buy = ProstheticManager.can_purchase_upgrade(data.id, node_id)

		var row_btn = Button.new()
		row_btn.custom_minimum_size = Vector2(0, 26)
		row_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row_btn.disabled = is_bought or not can_buy
		row_btn.text = ""

		var bg_col = COLOR_UPGRADE_BOUGHT if is_bought else (COLOR_UPGRADE_AVAILABLE if can_buy else COLOR_UPGRADE_LOCKED)
		var style = _make_stylebox(bg_col, 3)
		row_btn.add_theme_stylebox_override("normal", style)
		row_btn.add_theme_stylebox_override("disabled", style)
		row_btn.add_theme_stylebox_override("hover", _make_stylebox(bg_col.lightened(0.1), 3))

		var row_vbox = VBoxContainer.new()
		row_vbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		row_btn.add_child(row_vbox)

		var name_lbl = Label.new()
		name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		name_lbl.add_theme_font_size_override("font_size", 8)
		if is_bought:
			name_lbl.text = node_name + "  [OWNED]"
			name_lbl.add_theme_color_override("font_color", COLOR_EQUIPPED)
		elif can_buy:
			name_lbl.text = node_name
			name_lbl.add_theme_color_override("font_color", COLOR_TEXT)
		else:
			name_lbl.text = node_name + "  [LOCKED]"
			name_lbl.add_theme_color_override("font_color", COLOR_LOCKED)
		row_vbox.add_child(name_lbl)

		var info_text = node_desc
		if not is_bought:
			var cost_parts = []
			if cost_mist > 0:
				cost_parts.append("%d Mist" % cost_mist)
			if cost_gold > 0:
				cost_parts.append("%d Gold" % cost_gold)
			if cost_parts.size() > 0:
				info_text += "  |  " + ", ".join(cost_parts)

		var info_lbl = Label.new()
		info_lbl.text = info_text
		info_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		info_lbl.add_theme_font_size_override("font_size", 7)
		info_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		info_lbl.clip_text = true
		row_vbox.add_child(info_lbl)

		if can_buy and not is_bought:
			row_btn.pressed.connect(_on_upgrade_pressed.bind(data.id, node_id))

		upgrade_container.add_child(row_btn)


func _on_upgrade_pressed(prosthetic_id: String, upgrade_id: String):
	var success = ProstheticManager.purchase_upgrade(prosthetic_id, upgrade_id)
	if not success:
		print("[ForgeMenu] Cannot afford upgrade: ", upgrade_id)
	_refresh_detail()


# ============================
# HELPERS
# ============================

func _make_stylebox(bg_color: Color, corner_radius: int = 0, border_color: Color = Color.TRANSPARENT, border_width: int = 0) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = bg_color
	style.corner_radius_top_left = corner_radius
	style.corner_radius_top_right = corner_radius
	style.corner_radius_bottom_left = corner_radius
	style.corner_radius_bottom_right = corner_radius
	if border_width > 0:
		style.border_width_left = border_width
		style.border_width_right = border_width
		style.border_width_top = border_width
		style.border_width_bottom = border_width
		style.border_color = border_color
	style.content_margin_left = 4
	style.content_margin_right = 4
	style.content_margin_top = 2
	style.content_margin_bottom = 2
	return style

func _close():
	_apply_pause(false)
	menu_closed.emit()
	queue_free()

func _apply_pause(enable: bool) -> void:
	if enable:
		if _pause_applied:
			return

		_prev_tree_paused = get_tree().paused
		get_tree().paused = true
		_pause_applied = true

		process_mode = Node.PROCESS_MODE_ALWAYS

		# Hide all HUD layers so they don't cover the menu
		for hud in get_tree().get_nodes_in_group("game_hud"):
			hud.visible = false
	else:
		if not _pause_applied:
			return

		get_tree().paused = _prev_tree_paused
		_pause_applied = false

		# Restore HUD visibility
		for hud in get_tree().get_nodes_in_group("game_hud"):
			hud.visible = true
			
func _exit_tree() -> void:
	_apply_pause(false)
