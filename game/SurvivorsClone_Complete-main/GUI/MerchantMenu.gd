extends Control

## MerchantMenu — Full merchant shop UI built entirely in script.
## Attach this to an empty Control node and save as MerchantMenu.tscn.
## Sizes itself to 90% of viewport so it works at any resolution.
##
## Depends on: MerchantManager (autoload), CurrencyManager (autoload),
##             ProstheticManager (autoload)

signal item_purchased(item_id: String)
signal menu_closed

# =====================
# THEME COLORS (match ForgeMenu)
# =====================

const COLOR_BG = Color(0.08, 0.08, 0.1, 1.0)
const COLOR_PANEL = Color(0.12, 0.12, 0.15, 1.0)
const COLOR_PANEL_HOVER = Color(0.16, 0.16, 0.2, 1.0)
const COLOR_ACCENT = Color(0.85, 0.75, 0.45, 1.0)       # Gold
const COLOR_ACCENT_DIM = Color(0.5, 0.45, 0.3, 1.0)
const COLOR_TEXT = Color(0.9, 0.9, 0.88, 1.0)
const COLOR_TEXT_DIM = Color(0.55, 0.55, 0.5, 1.0)
const COLOR_BOUGHT = Color(0.35, 0.65, 0.35, 1.0)        # Green for owned
const COLOR_MAXED = Color(0.35, 0.65, 0.35, 1.0)
const COLOR_LOCKED = Color(0.5, 0.3, 0.3, 1.0)           # Red-ish for can't afford
const COLOR_MYSTERY = Color(0.6, 0.35, 0.75, 1.0)        # Purple for mystery
const COLOR_COSMETIC = Color(0.4, 0.7, 0.85, 1.0)        # Light blue for cosmetics
const COLOR_TAB_ACTIVE = Color(0.18, 0.18, 0.22, 1.0)
const COLOR_TAB_INACTIVE = Color(0.1, 0.1, 0.12, 1.0)

# =====================
# STATE
# =====================

var current_tab = 0  # 0=Stats, 1=Prosthetics, 2=Cosmetics, 3=Mystery
var tab_buttons = []
var content_container: VBoxContainer = null
var currency_label: Label = null
var confirmation_popup: PanelContainer = null
var pending_purchase_callback: Callable = Callable()
var pending_purchase_text = ""
var _prev_tree_paused: bool = false
var _pause_applied: bool = false

# =====================
# LIFECYCLE
# =====================

func _ready():
	_build_ui()
	_refresh_tab()
	_apply_pause(true)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()


# =====================
# UI CONSTRUCTION
# =====================

func _build_ui():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	# Full-screen dim
	var dimmer = ColorRect.new()
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0, 0, 0, 0.65)
	add_child(dimmer)

	# Main panel: 90% of viewport
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

	# Root margin
	var root_margin = MarginContainer.new()
	root_margin.add_theme_constant_override("margin_left", 6)
	root_margin.add_theme_constant_override("margin_right", 6)
	root_margin.add_theme_constant_override("margin_top", 4)
	root_margin.add_theme_constant_override("margin_bottom", 4)
	main_panel.add_child(root_margin)

	var root_vbox = VBoxContainer.new()
	root_vbox.add_theme_constant_override("separation", 3)
	root_margin.add_child(root_vbox)

	# --- Title bar ---
	var title_bar = HBoxContainer.new()
	title_bar.add_theme_constant_override("separation", 6)
	root_vbox.add_child(title_bar)

	var title_label = Label.new()
	title_label.text = "MERCHANT STALL"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.add_theme_font_size_override("font_size", 12)
	title_label.add_theme_color_override("font_color", COLOR_ACCENT)
	title_bar.add_child(title_label)

	# Currency display
	currency_label = Label.new()
	currency_label.add_theme_font_size_override("font_size", 9)
	currency_label.add_theme_color_override("font_color", COLOR_ACCENT)
	_update_currency_label()
	title_bar.add_child(currency_label)

	# Close button
	var close_btn = Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(16, 16)
	close_btn.add_theme_font_size_override("font_size", 9)
	close_btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.4, 0.15, 0.15), 2))
	close_btn.add_theme_stylebox_override("hover", _make_stylebox(Color(0.55, 0.2, 0.2), 2))
	close_btn.add_theme_stylebox_override("pressed", _make_stylebox(Color(0.3, 0.1, 0.1), 2))
	close_btn.pressed.connect(_close)
	title_bar.add_child(close_btn)

	# --- Separator ---
	var sep = HSeparator.new()
	sep.add_theme_constant_override("separation", 2)
	root_vbox.add_child(sep)

	# --- Tab bar ---
	var tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 2)
	root_vbox.add_child(tab_bar)

	var tab_names = ["Upgrades", "Prosthetics", "Cosmetics", "Mystery"]
	for i in range(tab_names.size()):
		var tab_btn = Button.new()
		tab_btn.text = tab_names[i]
		tab_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tab_btn.custom_minimum_size = Vector2(0, 16)
		tab_btn.add_theme_font_size_override("font_size", 8)
		tab_btn.add_theme_color_override("font_color", COLOR_TEXT)
		tab_btn.pressed.connect(_on_tab_pressed.bind(i))
		tab_bar.add_child(tab_btn)
		tab_buttons.append(tab_btn)

	_update_tab_styles()

	# --- Content area (scrollable) ---
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root_vbox.add_child(scroll)

	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 3)
	scroll.add_child(content_container)


# =====================
# TAB MANAGEMENT
# =====================

func _on_tab_pressed(index: int):
	current_tab = index
	_update_tab_styles()
	_refresh_tab()

func _update_tab_styles():
	for i in range(tab_buttons.size()):
		var btn = tab_buttons[i]
		if i == current_tab:
			btn.add_theme_stylebox_override("normal", _make_stylebox(COLOR_TAB_ACTIVE, 2, COLOR_ACCENT_DIM, 1))
			btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_TAB_ACTIVE, 2, COLOR_ACCENT, 1))
			btn.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_TAB_ACTIVE, 2, COLOR_ACCENT, 1))
		else:
			btn.add_theme_stylebox_override("normal", _make_stylebox(COLOR_TAB_INACTIVE, 2))
			btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2))
			btn.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_TAB_INACTIVE, 2))

func _refresh_tab():
	# Clear content
	for child in content_container.get_children():
		child.queue_free()

	_update_currency_label()

	match current_tab:
		0:
			_build_stat_upgrades_tab()
		1:
			_build_prosthetics_tab()
		2:
			_build_cosmetics_tab()
		3:
			_build_mystery_tab()


# =====================
# TAB 0: STAT UPGRADES
# =====================

func _build_stat_upgrades_tab():
	var header = Label.new()
	header.text = "Stat Upgrades"
	header.add_theme_font_size_override("font_size", 10)
	header.add_theme_color_override("font_color", COLOR_ACCENT)
	content_container.add_child(header)

	var desc_label = Label.new()
	desc_label.text = "Small permanent buffs. Each stat has a hard cap."
	desc_label.add_theme_font_size_override("font_size", 7)
	desc_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content_container.add_child(desc_label)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 2)
	content_container.add_child(spacer)

	for stat_id in MerchantManager.stat_upgrade_defs:
		var def = MerchantManager.stat_upgrade_defs[stat_id]
		var tier = MerchantManager.get_stat_tier(stat_id)
		var max_tier = def.get("max_tier", 0)
		var is_maxed = tier >= max_tier
		var cost = MerchantManager.get_stat_next_cost(stat_id)
		var can_afford = false
		if not is_maxed:
			var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
			can_afford = current_mist >= cost

		# Row container
		var row = Button.new()
		row.custom_minimum_size = Vector2(0, 28)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND if (not is_maxed and can_afford) else Control.CURSOR_ARROW

		if is_maxed:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2, COLOR_MAXED, 1))
			row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL, 2, COLOR_MAXED, 1))
			row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2, COLOR_MAXED, 1))
			row.disabled = true
		elif can_afford:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2))
			row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2, COLOR_ACCENT_DIM, 1))
			row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
		else:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2))
			row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL, 2))
			row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
			row.disabled = true

		# Use a HBoxContainer inside the button for layout
		var hbox = HBoxContainer.new()
		hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hbox.add_theme_constant_override("separation", 4)
		hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(hbox)

		# Name
		var name_lbl = Label.new()
		name_lbl.text = def.get("display_name", stat_id)
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.add_theme_font_size_override("font_size", 8)
		name_lbl.add_theme_color_override("font_color", COLOR_TEXT)
		name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(name_lbl)

		# Tier pips
		var pip_label = Label.new()
		var pip_text = ""
		for i in range(max_tier):
			if i < tier:
				pip_text += "[*]"
			else:
				pip_text += "[ ]"
			if i < max_tier - 1:
				pip_text += " "
		pip_label.text = pip_text
		pip_label.add_theme_font_size_override("font_size", 7)
		pip_label.add_theme_color_override("font_color", COLOR_MAXED if is_maxed else COLOR_TEXT_DIM)
		pip_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(pip_label)

		# Cost or status
		var cost_lbl = Label.new()
		if is_maxed:
			cost_lbl.text = "MAXED"
			cost_lbl.add_theme_color_override("font_color", COLOR_MAXED)
		else:
			cost_lbl.text = str(cost) + " Shards"
			cost_lbl.add_theme_color_override("font_color", COLOR_ACCENT if can_afford else COLOR_LOCKED)
		cost_lbl.add_theme_font_size_override("font_size", 7)
		cost_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(cost_lbl)

		if not is_maxed and can_afford:
			row.pressed.connect(_on_stat_upgrade_pressed.bind(stat_id, def.get("display_name", stat_id), cost))

		content_container.add_child(row)

		# Description under the row
		var desc = Label.new()
		desc.text = "  " + def.get("description", "")
		desc.add_theme_font_size_override("font_size", 7)
		desc.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content_container.add_child(desc)


func _on_stat_upgrade_pressed(stat_id: String, display_name: String, cost: int):
	_show_confirmation(
		"Buy " + display_name + " for " + str(cost) + " Mist Shards?",
		func():
			var success = MerchantManager.purchase_stat_upgrade(stat_id)
			if success:
				item_purchased.emit("stat_" + stat_id)
			_refresh_tab()
	)


# =====================
# TAB 1: PROSTHETICS
# =====================

func _build_prosthetics_tab():
	var header = Label.new()
	header.text = "Prosthetics"
	header.add_theme_font_size_override("font_size", 10)
	header.add_theme_color_override("font_color", COLOR_ACCENT)
	content_container.add_child(header)

	var desc_label = Label.new()
	desc_label.text = "Purchase prosthetic tools. Equip them at the Forge Bench."
	desc_label.add_theme_font_size_override("font_size", 7)
	desc_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content_container.add_child(desc_label)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 2)
	content_container.add_child(spacer)

	var stock = MerchantManager.prosthetic_shop_stock
	var any_available = false

	for pid in stock:
		var cost = stock[pid]
		var is_owned = ProstheticManager.unlocked_prosthetics.has(pid)
		var prosthetic_data = ProstheticManager.get_prosthetic(pid)
		var display_name = pid.replace("_", " ").capitalize()
		if prosthetic_data and prosthetic_data.display_name != "":
			display_name = prosthetic_data.display_name

		var can_afford = false
		if not is_owned:
			any_available = true
			var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
			can_afford = current_mist >= cost

		var row = Button.new()
		row.custom_minimum_size = Vector2(0, 26)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		if is_owned:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2, COLOR_BOUGHT, 1))
			row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL, 2, COLOR_BOUGHT, 1))
			row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2, COLOR_BOUGHT, 1))
			row.disabled = true
		elif can_afford:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2))
			row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2, COLOR_ACCENT_DIM, 1))
			row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
			row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2))
			row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL, 2))
			row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
			row.disabled = true

		var hbox = HBoxContainer.new()
		hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		hbox.add_theme_constant_override("separation", 4)
		hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
		row.add_child(hbox)

		var name_lbl = Label.new()
		name_lbl.text = display_name
		name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		name_lbl.add_theme_font_size_override("font_size", 8)
		name_lbl.add_theme_color_override("font_color", COLOR_TEXT)
		name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(name_lbl)

		var cost_lbl = Label.new()
		if is_owned:
			cost_lbl.text = "OWNED"
			cost_lbl.add_theme_color_override("font_color", COLOR_BOUGHT)
		else:
			cost_lbl.text = str(cost) + " Shards"
			cost_lbl.add_theme_color_override("font_color", COLOR_ACCENT if can_afford else COLOR_LOCKED)
		cost_lbl.add_theme_font_size_override("font_size", 7)
		cost_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
		hbox.add_child(cost_lbl)

		if not is_owned and can_afford:
			row.pressed.connect(_on_prosthetic_purchase_pressed.bind(pid, display_name, cost))

		content_container.add_child(row)

	if stock.is_empty():
		var empty_lbl = Label.new()
		empty_lbl.text = "No prosthetics in stock."
		empty_lbl.add_theme_font_size_override("font_size", 8)
		empty_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		content_container.add_child(empty_lbl)

	if not any_available and not stock.is_empty():
		var all_owned = Label.new()
		all_owned.text = "You own all available prosthetics!"
		all_owned.add_theme_font_size_override("font_size", 8)
		all_owned.add_theme_color_override("font_color", COLOR_BOUGHT)
		content_container.add_child(all_owned)


func _on_prosthetic_purchase_pressed(pid: String, display_name: String, cost: int):
	_show_confirmation(
		"Buy " + display_name + " for " + str(cost) + " Mist Shards?",
		func():
			var success = MerchantManager.purchase_prosthetic(pid)
			if success:
				item_purchased.emit(pid)
			_refresh_tab()
	)


# =====================
# TAB 2: COSMETICS
# =====================

func _build_cosmetics_tab():
	var header = Label.new()
	header.text = "Cosmetics"
	header.add_theme_font_size_override("font_size", 10)
	header.add_theme_color_override("font_color", COLOR_COSMETIC)
	content_container.add_child(header)

	var desc_label = Label.new()
	desc_label.text = "Visual customizations for your character and runs."
	desc_label.add_theme_font_size_override("font_size", 7)
	desc_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content_container.add_child(desc_label)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 2)
	content_container.add_child(spacer)

	# Group cosmetics by category
	var categories = {}
	var all_cosmetics = MerchantManager.get_all_cosmetics()
	for cid in all_cosmetics:
		var data = MerchantManager.get_cosmetic_data(cid)
		var cat = data.get("category", "misc")
		if not categories.has(cat):
			categories[cat] = []
		categories[cat].append(cid)

	var category_labels = {
		"player_skin": "Player Skins",
		"wheel_variant": "Wheel Variants",
		"room_variant": "Room Variants",
		"misc": "Other",
	}

	for cat in categories:
		# Category header
		var cat_header = Label.new()
		cat_header.text = category_labels.get(cat, cat.capitalize())
		cat_header.add_theme_font_size_override("font_size", 8)
		cat_header.add_theme_color_override("font_color", COLOR_COSMETIC)
		content_container.add_child(cat_header)

		for cid in categories[cat]:
			var data = MerchantManager.get_cosmetic_data(cid)
			var is_owned = MerchantManager.is_cosmetic_unlocked(cid)
			var cost = data.get("cost", 0)
			var can_afford = false
			if not is_owned:
				var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
				can_afford = current_mist >= cost

			var row = Button.new()
			row.custom_minimum_size = Vector2(0, 24)
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL

			if is_owned:
				row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2, COLOR_BOUGHT, 1))
				row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL, 2, COLOR_BOUGHT, 1))
				row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2, COLOR_BOUGHT, 1))
				row.disabled = true
			elif can_afford:
				row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2))
				row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2, COLOR_COSMETIC, 1))
				row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
				row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			else:
				row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 2))
				row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL, 2))
				row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
				row.disabled = true

			var hbox = HBoxContainer.new()
			hbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			hbox.add_theme_constant_override("separation", 4)
			hbox.mouse_filter = Control.MOUSE_FILTER_IGNORE
			row.add_child(hbox)

			var name_lbl = Label.new()
			name_lbl.text = data.get("display_name", cid)
			name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			name_lbl.add_theme_font_size_override("font_size", 8)
			name_lbl.add_theme_color_override("font_color", COLOR_TEXT)
			name_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			hbox.add_child(name_lbl)

			var cost_lbl = Label.new()
			if is_owned:
				cost_lbl.text = "OWNED"
				cost_lbl.add_theme_color_override("font_color", COLOR_BOUGHT)
			else:
				cost_lbl.text = str(cost) + " Shards"
				cost_lbl.add_theme_color_override("font_color", COLOR_ACCENT if can_afford else COLOR_LOCKED)
			cost_lbl.add_theme_font_size_override("font_size", 7)
			cost_lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
			hbox.add_child(cost_lbl)

			if not is_owned and can_afford:
				row.pressed.connect(_on_cosmetic_purchase_pressed.bind(cid, data.get("display_name", cid), cost))

			content_container.add_child(row)

			# Description
			var desc = Label.new()
			desc.text = "  " + data.get("description", "")
			desc.add_theme_font_size_override("font_size", 7)
			desc.add_theme_color_override("font_color", COLOR_TEXT_DIM)
			desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			content_container.add_child(desc)

	if all_cosmetics.is_empty():
		var empty_lbl = Label.new()
		empty_lbl.text = "No cosmetics available yet."
		empty_lbl.add_theme_font_size_override("font_size", 8)
		empty_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		content_container.add_child(empty_lbl)


func _on_cosmetic_purchase_pressed(cid: String, display_name: String, cost: int):
	_show_confirmation(
		"Buy " + display_name + " for " + str(cost) + " Mist Shards?",
		func():
			var success = MerchantManager.purchase_cosmetic(cid)
			if success:
				item_purchased.emit("cosmetic_" + cid)
			_refresh_tab()
	)


# =====================
# TAB 3: MYSTERY PROSTHETIC
# =====================

func _build_mystery_tab():
	var header = Label.new()
	header.text = "Mystery Prosthetic"
	header.add_theme_font_size_override("font_size", 10)
	header.add_theme_color_override("font_color", COLOR_MYSTERY)
	content_container.add_child(header)

	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 4)
	content_container.add_child(spacer)

	var is_available = MerchantManager.is_mystery_available()
	var cost = MerchantManager.get_mystery_cost()
	var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
	var can_afford = current_mist >= cost

	# Check if there are any locked prosthetics to roll
	var locked_count = 0
	var all_prosthetics = ProstheticManager.get_all_prosthetic_ids()
	for pid in all_prosthetics:
		if not ProstheticManager.unlocked_prosthetics.has(pid):
			locked_count += 1

	if not is_available:
		# Not available right now
		var unavail_panel = PanelContainer.new()
		unavail_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		unavail_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 4, COLOR_TEXT_DIM, 1))
		content_container.add_child(unavail_panel)

		var unavail_margin = MarginContainer.new()
		unavail_margin.add_theme_constant_override("margin_left", 8)
		unavail_margin.add_theme_constant_override("margin_right", 8)
		unavail_margin.add_theme_constant_override("margin_top", 6)
		unavail_margin.add_theme_constant_override("margin_bottom", 6)
		unavail_panel.add_child(unavail_margin)

		var unavail_vbox = VBoxContainer.new()
		unavail_vbox.add_theme_constant_override("separation", 4)
		unavail_margin.add_child(unavail_vbox)

		var unavail_title = Label.new()
		unavail_title.text = "? ? ?"
		unavail_title.add_theme_font_size_override("font_size", 10)
		unavail_title.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		unavail_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unavail_vbox.add_child(unavail_title)

		var unavail_desc = Label.new()
		unavail_desc.text = "The merchant has nothing mysterious to offer right now. Come back after a few more runs..."
		unavail_desc.add_theme_font_size_override("font_size", 7)
		unavail_desc.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		unavail_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		unavail_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		unavail_vbox.add_child(unavail_desc)

	elif locked_count == 0:
		# All prosthetics already owned
		var complete_lbl = Label.new()
		complete_lbl.text = "You already own every prosthetic. Nothing left to discover!"
		complete_lbl.add_theme_font_size_override("font_size", 8)
		complete_lbl.add_theme_color_override("font_color", COLOR_BOUGHT)
		complete_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		content_container.add_child(complete_lbl)

	else:
		# Available for purchase
		var mystery_panel = PanelContainer.new()
		mystery_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		mystery_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 4, COLOR_MYSTERY, 1))
		content_container.add_child(mystery_panel)

		var mystery_margin = MarginContainer.new()
		mystery_margin.add_theme_constant_override("margin_left", 8)
		mystery_margin.add_theme_constant_override("margin_right", 8)
		mystery_margin.add_theme_constant_override("margin_top", 6)
		mystery_margin.add_theme_constant_override("margin_bottom", 6)
		mystery_panel.add_child(mystery_margin)

		var mystery_vbox = VBoxContainer.new()
		mystery_vbox.add_theme_constant_override("separation", 4)
		mystery_margin.add_child(mystery_vbox)

		var mystery_title = Label.new()
		mystery_title.text = "? Mysterious Offering ?"
		mystery_title.add_theme_font_size_override("font_size", 10)
		mystery_title.add_theme_color_override("font_color", COLOR_MYSTERY)
		mystery_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		mystery_vbox.add_child(mystery_title)

		var mystery_desc = Label.new()
		mystery_desc.text = "Pay a hefty sum for a random prosthetic you don't own. Risky, but rewarding."
		mystery_desc.add_theme_font_size_override("font_size", 7)
		mystery_desc.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		mystery_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		mystery_desc.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		mystery_vbox.add_child(mystery_desc)

		var pool_lbl = Label.new()
		pool_lbl.text = str(locked_count) + " undiscovered prosthetic(s) remain"
		pool_lbl.add_theme_font_size_override("font_size", 7)
		pool_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		pool_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		mystery_vbox.add_child(pool_lbl)

		var cost_label = Label.new()
		cost_label.text = str(cost) + " Mist Shards"
		cost_label.add_theme_font_size_override("font_size", 9)
		cost_label.add_theme_color_override("font_color", COLOR_ACCENT if can_afford else COLOR_LOCKED)
		cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		mystery_vbox.add_child(cost_label)

		var roll_btn = Button.new()
		roll_btn.text = "Roll the Dice"
		roll_btn.custom_minimum_size = Vector2(0, 20)
		roll_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		roll_btn.add_theme_font_size_override("font_size", 8)
		roll_btn.add_theme_color_override("font_color", COLOR_TEXT)

		if can_afford:
			roll_btn.add_theme_stylebox_override("normal", _make_stylebox(COLOR_MYSTERY.darkened(0.5), 3, COLOR_MYSTERY, 1))
			roll_btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_MYSTERY.darkened(0.3), 3, COLOR_MYSTERY, 1))
			roll_btn.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_MYSTERY.darkened(0.6), 3, COLOR_MYSTERY, 1))
			roll_btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			roll_btn.pressed.connect(_on_mystery_roll_pressed.bind(cost))
		else:
			roll_btn.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL, 3))
			roll_btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL, 3))
			roll_btn.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 3))
			roll_btn.disabled = true

		mystery_vbox.add_child(roll_btn)

		if not can_afford:
			var cant_afford_lbl = Label.new()
			cant_afford_lbl.text = "Not enough Mist Shards"
			cant_afford_lbl.add_theme_font_size_override("font_size", 7)
			cant_afford_lbl.add_theme_color_override("font_color", COLOR_LOCKED)
			cant_afford_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			mystery_vbox.add_child(cant_afford_lbl)


func _on_mystery_roll_pressed(cost: int):
	_show_confirmation(
		"Spend " + str(cost) + " Mist Shards on a mystery prosthetic?",
		func():
			var result = MerchantManager.roll_mystery_prosthetic()
			if result != "":
				_show_mystery_result(result)
				item_purchased.emit("mystery_" + result)
			else:
				_refresh_tab()
	)


func _show_mystery_result(prosthetic_id: String):
	## Show a result popup for what was rolled
	# Clear content and show result
	for child in content_container.get_children():
		child.queue_free()

	var result_panel = PanelContainer.new()
	result_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	result_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 4, COLOR_MYSTERY, 2))
	content_container.add_child(result_panel)

	var result_margin = MarginContainer.new()
	result_margin.add_theme_constant_override("margin_left", 10)
	result_margin.add_theme_constant_override("margin_right", 10)
	result_margin.add_theme_constant_override("margin_top", 8)
	result_margin.add_theme_constant_override("margin_bottom", 8)
	result_panel.add_child(result_margin)

	var result_vbox = VBoxContainer.new()
	result_vbox.add_theme_constant_override("separation", 6)
	result_margin.add_child(result_vbox)

	var reveal_lbl = Label.new()
	reveal_lbl.text = "You received..."
	reveal_lbl.add_theme_font_size_override("font_size", 8)
	reveal_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	reveal_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_vbox.add_child(reveal_lbl)

	var prosthetic_data = ProstheticManager.get_prosthetic(prosthetic_id)
	var display_name = prosthetic_id.replace("_", " ").capitalize()
	if prosthetic_data and prosthetic_data.display_name != "":
		display_name = prosthetic_data.display_name

	var name_lbl = Label.new()
	name_lbl.text = display_name + "!"
	name_lbl.add_theme_font_size_override("font_size", 12)
	name_lbl.add_theme_color_override("font_color", COLOR_MYSTERY)
	name_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_vbox.add_child(name_lbl)

	if prosthetic_data and prosthetic_data.description != "":
		var desc_lbl = Label.new()
		desc_lbl.text = prosthetic_data.description
		desc_lbl.add_theme_font_size_override("font_size", 7)
		desc_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		desc_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		result_vbox.add_child(desc_lbl)

	var hint_lbl = Label.new()
	hint_lbl.text = "Equip it at the Forge Bench."
	hint_lbl.add_theme_font_size_override("font_size", 7)
	hint_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	hint_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_vbox.add_child(hint_lbl)

	var ok_btn = Button.new()
	ok_btn.text = "Nice!"
	ok_btn.custom_minimum_size = Vector2(0, 18)
	ok_btn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	ok_btn.add_theme_font_size_override("font_size", 8)
	ok_btn.add_theme_stylebox_override("normal", _make_stylebox(COLOR_MYSTERY.darkened(0.5), 3, COLOR_MYSTERY, 1))
	ok_btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_MYSTERY.darkened(0.3), 3, COLOR_MYSTERY, 1))
	ok_btn.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_MYSTERY.darkened(0.6), 3, COLOR_MYSTERY, 1))
	ok_btn.pressed.connect(_refresh_tab)
	result_vbox.add_child(ok_btn)


# =====================
# CONFIRMATION POPUP
# =====================

func _show_confirmation(text: String, on_confirm: Callable):
	if confirmation_popup and is_instance_valid(confirmation_popup):
		confirmation_popup.queue_free()

	pending_purchase_callback = on_confirm
	pending_purchase_text = text

	confirmation_popup = PanelContainer.new()
	confirmation_popup.anchor_left = 0.2
	confirmation_popup.anchor_top = 0.3
	confirmation_popup.anchor_right = 0.8
	confirmation_popup.anchor_bottom = 0.7
	confirmation_popup.offset_left = 0
	confirmation_popup.offset_top = 0
	confirmation_popup.offset_right = 0
	confirmation_popup.offset_bottom = 0
	confirmation_popup.add_theme_stylebox_override("panel", _make_stylebox(COLOR_BG, 4, COLOR_ACCENT, 2))
	add_child(confirmation_popup)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", 6)
	confirmation_popup.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	margin.add_child(vbox)

	var confirm_label = Label.new()
	confirm_label.text = text
	confirm_label.add_theme_font_size_override("font_size", 8)
	confirm_label.add_theme_color_override("font_color", COLOR_TEXT)
	confirm_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	confirm_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirm_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(confirm_label)

	var btn_row = HBoxContainer.new()
	btn_row.add_theme_constant_override("separation", 8)
	btn_row.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_child(btn_row)

	var yes_btn = Button.new()
	yes_btn.text = "Buy"
	yes_btn.custom_minimum_size = Vector2(40, 16)
	yes_btn.add_theme_font_size_override("font_size", 8)
	yes_btn.add_theme_stylebox_override("normal", _make_stylebox(COLOR_BOUGHT.darkened(0.3), 2, COLOR_BOUGHT, 1))
	yes_btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_BOUGHT.darkened(0.1), 2, COLOR_BOUGHT, 1))
	yes_btn.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_BOUGHT.darkened(0.5), 2, COLOR_BOUGHT, 1))
	yes_btn.pressed.connect(_on_confirm_yes)
	btn_row.add_child(yes_btn)

	var no_btn = Button.new()
	no_btn.text = "Cancel"
	no_btn.custom_minimum_size = Vector2(40, 16)
	no_btn.add_theme_font_size_override("font_size", 8)
	no_btn.add_theme_stylebox_override("normal", _make_stylebox(COLOR_LOCKED.darkened(0.3), 2))
	no_btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_LOCKED.darkened(0.1), 2))
	no_btn.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_LOCKED.darkened(0.5), 2))
	no_btn.pressed.connect(_on_confirm_no)
	btn_row.add_child(no_btn)


func _on_confirm_yes():
	if confirmation_popup and is_instance_valid(confirmation_popup):
		confirmation_popup.queue_free()
		confirmation_popup = null
	if pending_purchase_callback.is_valid():
		pending_purchase_callback.call()

func _on_confirm_no():
	if confirmation_popup and is_instance_valid(confirmation_popup):
		confirmation_popup.queue_free()
		confirmation_popup = null


# =====================
# HELPERS
# =====================

func _update_currency_label():
	if currency_label:
		var mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
		currency_label.text = str(mist) + " Mist Shards"

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

func _exit_tree() -> void:
	_apply_pause(false)

func _apply_pause(enable: bool) -> void:
	if enable:
		if _pause_applied:
			return
		_prev_tree_paused = get_tree().paused
		get_tree().paused = true
		_pause_applied = true
		process_mode = Node.PROCESS_MODE_ALWAYS

		for hud in get_tree().get_nodes_in_group("game_hud"):
			hud.visible = false
	else:
		if not _pause_applied:
			return
		get_tree().paused = _prev_tree_paused
		_pause_applied = false

		for hud in get_tree().get_nodes_in_group("game_hud"):
			hud.visible = true
