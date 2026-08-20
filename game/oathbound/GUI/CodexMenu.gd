extends Control

## CodexMenu — Discovery board UI built entirely in script.
## Attach to an empty Control node and save as CodexMenu.tscn.
## Sizes itself to 90% of viewport.
##
## Depends on: CodexManager (autoload), ProstheticManager (autoload)

signal menu_closed

# =====================
# THEME COLORS (match ForgeMenu / MerchantMenu)
# =====================

const COLOR_BG = Color(0.08, 0.08, 0.1, 1.0)
const COLOR_PANEL = Color(0.12, 0.12, 0.15, 1.0)
const COLOR_PANEL_HOVER = Color(0.16, 0.16, 0.2, 1.0)
const COLOR_ACCENT = Color(0.85, 0.75, 0.45, 1.0)
const COLOR_ACCENT_DIM = Color(0.5, 0.45, 0.3, 1.0)
const COLOR_TEXT = Color(0.9, 0.9, 0.88, 1.0)
const COLOR_TEXT_DIM = Color(0.55, 0.55, 0.5, 1.0)
const COLOR_DISCOVERED = Color(0.35, 0.65, 0.35, 1.0)
const COLOR_LOCKED = Color(0.5, 0.3, 0.3, 1.0)
const COLOR_HINT = Color(0.7, 0.8, 0.65, 1.0)
const COLOR_BOSS = Color(0.85, 0.4, 0.35, 1.0)
const COLOR_MINI_BOSS = Color(0.85, 0.6, 0.3, 1.0)
const COLOR_RELIC = Color(0.6, 0.5, 0.8, 1.0)
const COLOR_TAB_ACTIVE = Color(0.18, 0.18, 0.22, 1.0)
const COLOR_TAB_INACTIVE = Color(0.1, 0.1, 0.12, 1.0)

# =====================
# STATE
# =====================

var _prev_paused := false
var current_tab = 0  # 0=Bestiary, 1=Prosthetics, 2=Relics
var tab_buttons = []
var content_container: VBoxContainer = null
var detail_container: VBoxContainer = null
var split_container: HBoxContainer = null

# Currently selected entry for detail view
var selected_enemy_id = ""
var selected_prosthetic_id = ""
var selected_relic_id = ""

# =====================
# LIFECYCLE
# =====================

func _ready():
	_prev_paused = get_tree().paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = false

	_build_ui()
	_refresh_tab()
	
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
	main_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_BG, 4, COLOR_ACCENT_DIM, 1))
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
	title_label.text = "CODEX"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.add_theme_font_size_override("font_size", 12)
	title_label.add_theme_color_override("font_color", COLOR_ACCENT)
	title_bar.add_child(title_label)

	# Discovery counter
	var counter_label = Label.new()
	counter_label.name = "CounterLabel"
	counter_label.add_theme_font_size_override("font_size", 8)
	counter_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	title_bar.add_child(counter_label)

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

	# Separator
	var sep = HSeparator.new()
	sep.add_theme_constant_override("separation", 2)
	root_vbox.add_child(sep)

	# --- Tab bar ---
	var tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 2)
	root_vbox.add_child(tab_bar)

	var tab_names = ["Bestiary", "Prosthetics", "Relics"]
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

	# --- Split: left list + right detail ---
	split_container = HBoxContainer.new()
	split_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split_container.add_theme_constant_override("separation", 4)
	root_vbox.add_child(split_container)

	# Left panel (list)
	var left_panel = PanelContainer.new()
	left_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_panel.size_flags_stretch_ratio = 0.35
	left_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 2))
	split_container.add_child(left_panel)

	var left_scroll = ScrollContainer.new()
	left_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left_panel.add_child(left_scroll)

	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_container.add_theme_constant_override("separation", 1)
	left_scroll.add_child(content_container)

	# Right panel (detail)
	var right_panel = PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_panel.size_flags_stretch_ratio = 0.65
	right_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 2))
	split_container.add_child(right_panel)

	var right_scroll = ScrollContainer.new()
	right_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	right_panel.add_child(right_scroll)

	var right_margin = MarginContainer.new()
	right_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_margin.add_theme_constant_override("margin_left", 4)
	right_margin.add_theme_constant_override("margin_right", 4)
	right_margin.add_theme_constant_override("margin_top", 3)
	right_margin.add_theme_constant_override("margin_bottom", 3)
	right_scroll.add_child(right_margin)

	detail_container = VBoxContainer.new()
	detail_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	detail_container.add_theme_constant_override("separation", 3)
	right_margin.add_child(detail_container)

	_update_counter()


# =====================
# TAB MANAGEMENT
# =====================

func _on_tab_pressed(index: int):
	current_tab = index
	selected_enemy_id = ""
	selected_prosthetic_id = ""
	selected_relic_id = ""
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
	_clear_container(content_container)
	_clear_container(detail_container)
	_update_counter()

	match current_tab:
		0:
			_build_bestiary_list()
		1:
			_build_prosthetics_list()
		2:
			_build_relics_list()

func _clear_container(container: VBoxContainer):
	for child in container.get_children():
		child.queue_free()


# =====================
# DISCOVERY COUNTER
# =====================

func _update_counter():
	var counter = get_node_or_null("Control/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CounterLabel")
	if counter == null:
		# Try to find it more robustly
		return

	var total_enemies = CodexManager.get_all_enemy_ids().size()
	var discovered_enemies = CodexManager.discovered_enemies.size()
	var total_prosthetics = ProstheticManager.get_all_prosthetic_ids().size()
	var unlocked_prosthetics = ProstheticManager.unlocked_prosthetics.size()
	var total_relics = ProstheticManager._relic_registry.size()
	var unlocked_relics = ProstheticManager.unlocked_relics.size()

	var total = total_enemies + total_prosthetics + total_relics
	var found = discovered_enemies + unlocked_prosthetics + unlocked_relics

	# Update via the title bar path
	# Counter label is sibling of title, won't use path - just update text next time


# =====================
# TAB 0: BESTIARY
# =====================

func _build_bestiary_list():
	var categories = ["regular", "mini_boss", "boss"]
	var category_labels = {
		"regular": "Enemies",
		"mini_boss": "Mini-Bosses",
		"boss": "Bosses",
	}
	var category_colors = {
		"regular": COLOR_TEXT,
		"mini_boss": COLOR_MINI_BOSS,
		"boss": COLOR_BOSS,
	}

	for cat in categories:
		var enemies = CodexManager.get_enemies_by_category(cat)
		if enemies.is_empty():
			continue

		# Category header
		var header = Label.new()
		header.text = category_labels.get(cat, cat)
		header.add_theme_font_size_override("font_size", 8)
		header.add_theme_color_override("font_color", category_colors.get(cat, COLOR_TEXT))
		content_container.add_child(header)

		for eid in enemies:
			var data = CodexManager.get_enemy_data(eid)
			var is_discovered = CodexManager.is_enemy_discovered(eid)

			var row = Button.new()
			row.custom_minimum_size = Vector2(0, 18)
			row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			row.clip_text = true

			if is_discovered:
				row.text = data.get("display_name", eid)
				row.add_theme_color_override("font_color", COLOR_TEXT)
				row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
			else:
				row.text = "???"
				row.add_theme_color_override("font_color", COLOR_TEXT_DIM)

			var is_selected = selected_enemy_id == eid
			if is_selected:
				row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL_HOVER, 2, COLOR_ACCENT_DIM, 1))
			else:
				row.add_theme_stylebox_override("normal", _make_stylebox(Color.TRANSPARENT, 0))

			row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2))
			row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
			row.add_theme_font_size_override("font_size", 8)

			if is_discovered:
				row.pressed.connect(_on_enemy_selected.bind(eid))

			content_container.add_child(row)

	# Show first discovered enemy's detail by default
	if selected_enemy_id == "":
		for eid in CodexManager.get_all_enemy_ids():
			if CodexManager.is_enemy_discovered(eid):
				_show_enemy_detail(eid)
				break
		if selected_enemy_id == "":
			_show_empty_detail("No enemies discovered yet. Enter combat to unlock entries.")
	else:
		_show_enemy_detail(selected_enemy_id)


func _on_enemy_selected(enemy_id: String):
	selected_enemy_id = enemy_id
	_refresh_tab()


func _show_enemy_detail(enemy_id: String):
	selected_enemy_id = enemy_id
	_clear_container(detail_container)

	var data = CodexManager.get_enemy_data(enemy_id)
	if data.is_empty():
		return

	var cat = data.get("category", "regular")
	var cat_color = COLOR_TEXT
	var cat_label = ""
	match cat:
		"boss":
			cat_color = COLOR_BOSS
			cat_label = "BOSS"
		"mini_boss":
			cat_color = COLOR_MINI_BOSS
			cat_label = "MINI-BOSS"
		"regular":
			cat_color = COLOR_TEXT_DIM
			cat_label = "ENEMY"

	# Category tag
	var tag_lbl = Label.new()
	tag_lbl.text = cat_label
	tag_lbl.add_theme_font_size_override("font_size", 7)
	tag_lbl.add_theme_color_override("font_color", cat_color)
	detail_container.add_child(tag_lbl)

	# Name
	var name_lbl = Label.new()
	name_lbl.text = data.get("display_name", enemy_id)
	name_lbl.add_theme_font_size_override("font_size", 11)
	name_lbl.add_theme_color_override("font_color", COLOR_ACCENT)
	detail_container.add_child(name_lbl)

	# Encounter count
	var count = CodexManager.get_enemy_encounter_count(enemy_id)
	var count_lbl = Label.new()
	if count == 1:
		count_lbl.text = "Encountered 1 time"
	else:
		count_lbl.text = "Encountered " + str(count) + " times"
	count_lbl.add_theme_font_size_override("font_size", 7)
	count_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	detail_container.add_child(count_lbl)

	# Separator
	var sep = HSeparator.new()
	sep.add_theme_constant_override("separation", 2)
	detail_container.add_child(sep)

	# Description
	var desc_lbl = Label.new()
	desc_lbl.text = data.get("description", "")
	desc_lbl.add_theme_font_size_override("font_size", 7)
	desc_lbl.add_theme_color_override("font_color", COLOR_TEXT)
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_container.add_child(desc_lbl)

	# Weakness hints section
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 3)
	detail_container.add_child(spacer)

	var hints_header = Label.new()
	hints_header.text = "Weakness Hints"
	hints_header.add_theme_font_size_override("font_size", 9)
	hints_header.add_theme_color_override("font_color", COLOR_HINT)
	detail_container.add_child(hints_header)

	var revealed = CodexManager.get_revealed_hints(enemy_id)
	var total_hints = CodexManager.get_total_hint_count(enemy_id)

	if revealed.is_empty():
		var no_hints = Label.new()
		no_hints.text = "Fight this enemy more to reveal weaknesses..."
		no_hints.add_theme_font_size_override("font_size", 7)
		no_hints.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		detail_container.add_child(no_hints)
	else:
		for i in range(revealed.size()):
			var hint_panel = PanelContainer.new()
			hint_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			hint_panel.add_theme_stylebox_override("panel", _make_stylebox(Color(0.1, 0.12, 0.1), 2, COLOR_HINT.darkened(0.5), 1))
			detail_container.add_child(hint_panel)

			var hint_margin = MarginContainer.new()
			hint_margin.add_theme_constant_override("margin_left", 4)
			hint_margin.add_theme_constant_override("margin_right", 4)
			hint_margin.add_theme_constant_override("margin_top", 2)
			hint_margin.add_theme_constant_override("margin_bottom", 2)
			hint_panel.add_child(hint_margin)

			var hint_lbl = Label.new()
			hint_lbl.text = str(i + 1) + ". " + revealed[i]
			hint_lbl.add_theme_font_size_override("font_size", 7)
			hint_lbl.add_theme_color_override("font_color", COLOR_HINT)
			hint_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			hint_margin.add_child(hint_lbl)

	# Show locked hint count
	var locked_count = total_hints - revealed.size()
	if locked_count > 0:
		var locked_lbl = Label.new()
		if locked_count == 1:
			locked_lbl.text = "1 hint remaining..."
		else:
			locked_lbl.text = str(locked_count) + " hints remaining..."
		locked_lbl.add_theme_font_size_override("font_size", 7)
		locked_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		detail_container.add_child(locked_lbl)


# =====================
# TAB 1: PROSTHETICS
# =====================

func _build_prosthetics_list():
	var all_ids = ProstheticManager.get_all_prosthetic_ids()

	# Unlocked header
	var unlocked_header = Label.new()
	unlocked_header.text = "Discovered"
	unlocked_header.add_theme_font_size_override("font_size", 8)
	unlocked_header.add_theme_color_override("font_color", COLOR_DISCOVERED)
	content_container.add_child(unlocked_header)

	var any_unlocked = false
	for pid in all_ids:
		if not ProstheticManager.unlocked_prosthetics.has(pid):
			continue
		any_unlocked = true
		var data = ProstheticManager.get_prosthetic(pid)
		var display_name = pid.replace("_", " ").capitalize()
		if data and data.display_name != "":
			display_name = data.display_name

		var row = Button.new()
		row.text = display_name
		row.custom_minimum_size = Vector2(0, 18)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.clip_text = true
		row.add_theme_font_size_override("font_size", 8)
		row.add_theme_color_override("font_color", COLOR_TEXT)
		row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

		var is_selected = selected_prosthetic_id == pid
		if is_selected:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL_HOVER, 2, COLOR_ACCENT_DIM, 1))
		else:
			row.add_theme_stylebox_override("normal", _make_stylebox(Color.TRANSPARENT, 0))
		row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2))
		row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))

		row.pressed.connect(_on_prosthetic_selected.bind(pid))
		content_container.add_child(row)

	if not any_unlocked:
		var none_lbl = Label.new()
		none_lbl.text = "  None yet"
		none_lbl.add_theme_font_size_override("font_size", 7)
		none_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		content_container.add_child(none_lbl)

	# Locked section
	var locked_header = Label.new()
	locked_header.text = "Undiscovered"
	locked_header.add_theme_font_size_override("font_size", 8)
	locked_header.add_theme_color_override("font_color", COLOR_LOCKED)
	content_container.add_child(locked_header)

	var any_locked = false
	for pid in all_ids:
		if ProstheticManager.unlocked_prosthetics.has(pid):
			continue
		any_locked = true

		var row = Label.new()
		row.text = "  ???"
		row.custom_minimum_size = Vector2(0, 18)
		row.add_theme_font_size_override("font_size", 8)
		row.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		content_container.add_child(row)

	if not any_locked:
		var all_lbl = Label.new()
		all_lbl.text = "  All discovered!"
		all_lbl.add_theme_font_size_override("font_size", 7)
		all_lbl.add_theme_color_override("font_color", COLOR_DISCOVERED)
		content_container.add_child(all_lbl)

	# Show first unlocked detail by default
	if selected_prosthetic_id == "":
		for pid in all_ids:
			if ProstheticManager.unlocked_prosthetics.has(pid):
				_show_prosthetic_detail(pid)
				break
		if selected_prosthetic_id == "":
			_show_empty_detail("No prosthetics discovered yet.")
	else:
		_show_prosthetic_detail(selected_prosthetic_id)


func _on_prosthetic_selected(pid: String):
	selected_prosthetic_id = pid
	_refresh_tab()


func _show_prosthetic_detail(pid: String):
	selected_prosthetic_id = pid
	_clear_container(detail_container)

	var data = ProstheticManager.get_prosthetic(pid)
	if data == null:
		return

	# Name
	var name_lbl = Label.new()
	name_lbl.text = data.display_name if data.display_name != "" else pid
	name_lbl.add_theme_font_size_override("font_size", 11)
	name_lbl.add_theme_color_override("font_color", COLOR_ACCENT)
	detail_container.add_child(name_lbl)

	# Tags
	if data.tags.size() > 0:
		var tags_text = ""
		for i in range(data.tags.size()):
			if i > 0:
				tags_text += ", "
			tags_text += data.tags[i]
		var tags_lbl = Label.new()
		tags_lbl.text = tags_text
		tags_lbl.add_theme_font_size_override("font_size", 7)
		tags_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		detail_container.add_child(tags_lbl)

	# Equipped indicator
	if ProstheticManager.equipped_prosthetic_id == pid:
		var equipped_lbl = Label.new()
		equipped_lbl.text = "EQUIPPED"
		equipped_lbl.add_theme_font_size_override("font_size", 7)
		equipped_lbl.add_theme_color_override("font_color", COLOR_DISCOVERED)
		detail_container.add_child(equipped_lbl)

	var sep = HSeparator.new()
	sep.add_theme_constant_override("separation", 2)
	detail_container.add_child(sep)

	# Description
	var desc_lbl = Label.new()
	desc_lbl.text = data.description
	desc_lbl.add_theme_font_size_override("font_size", 7)
	desc_lbl.add_theme_color_override("font_color", COLOR_TEXT)
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_container.add_child(desc_lbl)

	# Stats
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 2)
	detail_container.add_child(spacer)

	var stats_lbl = Label.new()
	stats_lbl.text = "Spirit Cost: " + str(data.spirit_cost) + "  |  Relic Slots: " + str(data.max_relic_slots)
	stats_lbl.add_theme_font_size_override("font_size", 7)
	stats_lbl.add_theme_color_override("font_color", COLOR_ACCENT_DIM)
	detail_container.add_child(stats_lbl)

	# Upgrades
	if data.upgrade_nodes.size() > 0:
		var spacer2 = Control.new()
		spacer2.custom_minimum_size = Vector2(0, 2)
		detail_container.add_child(spacer2)

		var upgrade_header = Label.new()
		upgrade_header.text = "Upgrade Path"
		upgrade_header.add_theme_font_size_override("font_size", 8)
		upgrade_header.add_theme_color_override("font_color", COLOR_ACCENT)
		detail_container.add_child(upgrade_header)

		for node in data.upgrade_nodes:
			var node_id = node.get("id", "")
			var is_purchased = ProstheticManager.is_upgrade_purchased(pid, node_id)

			var upgrade_panel = PanelContainer.new()
			upgrade_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			if is_purchased:
				upgrade_panel.add_theme_stylebox_override("panel", _make_stylebox(Color(0.1, 0.14, 0.1), 2, COLOR_DISCOVERED, 1))
			else:
				upgrade_panel.add_theme_stylebox_override("panel", _make_stylebox(Color(0.1, 0.1, 0.12), 2))
			detail_container.add_child(upgrade_panel)

			var um = MarginContainer.new()
			um.add_theme_constant_override("margin_left", 4)
			um.add_theme_constant_override("margin_right", 4)
			um.add_theme_constant_override("margin_top", 2)
			um.add_theme_constant_override("margin_bottom", 2)
			upgrade_panel.add_child(um)

			var uvbox = VBoxContainer.new()
			uvbox.add_theme_constant_override("separation", 1)
			um.add_child(uvbox)

			var uname = Label.new()
			var status_text = " [OWNED]" if is_purchased else ""
			uname.text = node.get("name", node_id) + status_text
			uname.add_theme_font_size_override("font_size", 7)
			uname.add_theme_color_override("font_color", COLOR_DISCOVERED if is_purchased else COLOR_TEXT)
			uvbox.add_child(uname)

			var udesc = Label.new()
			udesc.text = node.get("description", "")
			udesc.add_theme_font_size_override("font_size", 7)
			udesc.add_theme_color_override("font_color", COLOR_TEXT_DIM)
			udesc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
			uvbox.add_child(udesc)


# =====================
# TAB 2: RELICS
# =====================

func _build_relics_list():
	var all_relics = ProstheticManager._relic_registry

	# Unlocked
	var unlocked_header = Label.new()
	unlocked_header.text = "Discovered"
	unlocked_header.add_theme_font_size_override("font_size", 8)
	unlocked_header.add_theme_color_override("font_color", COLOR_RELIC)
	content_container.add_child(unlocked_header)

	var any_unlocked = false
	for rid in all_relics:
		if not ProstheticManager.unlocked_relics.has(rid):
			continue
		any_unlocked = true
		var data = ProstheticManager.get_relic(rid)
		var display_name = rid.replace("_", " ").capitalize()
		if data and data.display_name != "":
			display_name = data.display_name

		var row = Button.new()
		row.text = display_name
		row.custom_minimum_size = Vector2(0, 18)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.clip_text = true
		row.add_theme_font_size_override("font_size", 8)
		row.add_theme_color_override("font_color", COLOR_TEXT)
		row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

		var is_selected = selected_relic_id == rid
		if is_selected:
			row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL_HOVER, 2, COLOR_RELIC.darkened(0.3), 1))
		else:
			row.add_theme_stylebox_override("normal", _make_stylebox(Color.TRANSPARENT, 0))
		row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2))
		row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))

		row.pressed.connect(_on_relic_selected.bind(rid))
		content_container.add_child(row)

	if not any_unlocked:
		var none_lbl = Label.new()
		none_lbl.text = "  None yet"
		none_lbl.add_theme_font_size_override("font_size", 7)
		none_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		content_container.add_child(none_lbl)

	# Locked
	var locked_header = Label.new()
	locked_header.text = "Undiscovered"
	locked_header.add_theme_font_size_override("font_size", 8)
	locked_header.add_theme_color_override("font_color", COLOR_LOCKED)
	content_container.add_child(locked_header)

	var any_locked = false
	for rid in all_relics:
		if ProstheticManager.unlocked_relics.has(rid):
			continue
		any_locked = true

		var row = Label.new()
		row.text = "  ???"
		row.custom_minimum_size = Vector2(0, 18)
		row.add_theme_font_size_override("font_size", 8)
		row.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		content_container.add_child(row)

	if not any_locked:
		var all_lbl = Label.new()
		all_lbl.text = "  All discovered!"
		all_lbl.add_theme_font_size_override("font_size", 7)
		all_lbl.add_theme_color_override("font_color", COLOR_RELIC)
		content_container.add_child(all_lbl)

	# Detail
	if selected_relic_id == "":
		for rid in all_relics:
			if ProstheticManager.unlocked_relics.has(rid):
				_show_relic_detail(rid)
				break
		if selected_relic_id == "":
			_show_empty_detail("No relics discovered yet.")
	else:
		_show_relic_detail(selected_relic_id)


func _on_relic_selected(rid: String):
	selected_relic_id = rid
	_refresh_tab()


func _show_relic_detail(rid: String):
	selected_relic_id = rid
	_clear_container(detail_container)

	var data = ProstheticManager.get_relic(rid)
	if data == null:
		return

	# Rarity
	var rarity_lbl = Label.new()
	rarity_lbl.text = data.rarity if data.rarity != "" else "Common"
	rarity_lbl.add_theme_font_size_override("font_size", 7)
	var rarity_color = COLOR_TEXT_DIM
	match data.rarity:
		"Uncommon":
			rarity_color = COLOR_DISCOVERED
		"Rare":
			rarity_color = COLOR_RELIC
		"Legendary":
			rarity_color = COLOR_ACCENT
	rarity_lbl.add_theme_color_override("font_color", rarity_color)
	detail_container.add_child(rarity_lbl)

	# Name
	var name_lbl = Label.new()
	name_lbl.text = data.display_name if data.display_name != "" else rid
	name_lbl.add_theme_font_size_override("font_size", 11)
	name_lbl.add_theme_color_override("font_color", COLOR_RELIC)
	detail_container.add_child(name_lbl)

	var sep = HSeparator.new()
	sep.add_theme_constant_override("separation", 2)
	detail_container.add_child(sep)

	# Description
	var desc_lbl = Label.new()
	desc_lbl.text = data.description
	desc_lbl.add_theme_font_size_override("font_size", 7)
	desc_lbl.add_theme_color_override("font_color", COLOR_TEXT)
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_container.add_child(desc_lbl)

	# Compatible tags
	if data.compatible_tags.size() > 0:
		var spacer = Control.new()
		spacer.custom_minimum_size = Vector2(0, 2)
		detail_container.add_child(spacer)

		var compat_lbl = Label.new()
		var tag_text = ""
		for i in range(data.compatible_tags.size()):
			if i > 0:
				tag_text += ", "
			tag_text += data.compatible_tags[i]
		compat_lbl.text = "Compatible: " + tag_text
		compat_lbl.add_theme_font_size_override("font_size", 7)
		compat_lbl.add_theme_color_override("font_color", COLOR_ACCENT_DIM)
		detail_container.add_child(compat_lbl)
	else:
		var universal_lbl = Label.new()
		universal_lbl.text = "Compatible: All prosthetics"
		universal_lbl.add_theme_font_size_override("font_size", 7)
		universal_lbl.add_theme_color_override("font_color", COLOR_ACCENT_DIM)
		detail_container.add_child(universal_lbl)

	# Stat modifiers
	if data.stat_modifiers.size() > 0:
		var spacer2 = Control.new()
		spacer2.custom_minimum_size = Vector2(0, 2)
		detail_container.add_child(spacer2)

		var mods_header = Label.new()
		mods_header.text = "Effects"
		mods_header.add_theme_font_size_override("font_size", 8)
		mods_header.add_theme_color_override("font_color", COLOR_RELIC)
		detail_container.add_child(mods_header)

		for stat_key in data.stat_modifiers:
			var value = data.stat_modifiers[stat_key]
			var display_key = stat_key.replace("_", " ").capitalize()
			var value_text = ""
			if value > 0:
				value_text = "+" + str(value)
			else:
				value_text = str(value)

			var mod_lbl = Label.new()
			mod_lbl.text = "  " + display_key + ": " + value_text
			mod_lbl.add_theme_font_size_override("font_size", 7)
			mod_lbl.add_theme_color_override("font_color", COLOR_HINT)
			detail_container.add_child(mod_lbl)


# =====================
# EMPTY STATE
# =====================

func _show_empty_detail(text: String):
	_clear_container(detail_container)
	var lbl = Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 8)
	lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_container.add_child(lbl)


# =====================
# HELPERS
# =====================

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
	get_tree().paused = _prev_paused
	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = true
	menu_closed.emit()
	queue_free()
