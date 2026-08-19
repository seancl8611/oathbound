# res://UI/QuestMenu.gd
extends Control

signal menu_closed
signal quest_claimed(quest_id: String)

# Match CodexMenu theme
const COLOR_BG = Color(0.08, 0.08, 0.1, 1.0)
const COLOR_PANEL = Color(0.12, 0.12, 0.15, 1.0)
const COLOR_PANEL_HOVER = Color(0.16, 0.16, 0.2, 1.0)
const COLOR_ACCENT = Color(0.85, 0.75, 0.45, 1.0)
const COLOR_ACCENT_DIM = Color(0.5, 0.45, 0.3, 1.0)
const COLOR_TEXT = Color(0.9, 0.9, 0.88, 1.0)
const COLOR_TEXT_DIM = Color(0.55, 0.55, 0.5, 1.0)
const COLOR_GOOD = Color(0.35, 0.65, 0.35, 1.0)
const COLOR_BAD = Color(0.6, 0.3, 0.3, 1.0)
const COLOR_TAB_ACTIVE = Color(0.18, 0.18, 0.22, 1.0)
const COLOR_TAB_INACTIVE = Color(0.1, 0.1, 0.12, 1.0)

var current_tab := 0 # 0=Active, 1=Completed, 2=Claimed
var tab_buttons: Array = []

var content_container: VBoxContainer
var detail_container: VBoxContainer

var selected_quest_id := ""
var _counter_label: Label

func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true

	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = false

	_build_ui()
	_refresh_tab()

	if QuestManager.has_signal("changed"):
		QuestManager.changed.connect(_refresh_tab)
		
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()

func _build_ui():
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP

	var dimmer := ColorRect.new()
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0, 0, 0, 0.65)
	add_child(dimmer)

	var main_panel := PanelContainer.new()
	main_panel.anchor_left = 0.05
	main_panel.anchor_top = 0.05
	main_panel.anchor_right = 0.95
	main_panel.anchor_bottom = 0.95
	main_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_BG, 4, COLOR_ACCENT_DIM, 1))
	add_child(main_panel)

	var root_margin := MarginContainer.new()
	root_margin.add_theme_constant_override("margin_left", 6)
	root_margin.add_theme_constant_override("margin_right", 6)
	root_margin.add_theme_constant_override("margin_top", 4)
	root_margin.add_theme_constant_override("margin_bottom", 4)
	main_panel.add_child(root_margin)

	var root_vbox := VBoxContainer.new()
	root_vbox.add_theme_constant_override("separation", 3)
	root_margin.add_child(root_vbox)

	# Title bar
	var title_bar := HBoxContainer.new()
	title_bar.add_theme_constant_override("separation", 6)
	root_vbox.add_child(title_bar)

	var title_label := Label.new()
	title_label.text = "QUEST ALTAR"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.add_theme_font_size_override("font_size", 12)
	title_label.add_theme_color_override("font_color", COLOR_ACCENT)
	title_bar.add_child(title_label)

	_counter_label = Label.new()
	_counter_label.add_theme_font_size_override("font_size", 8)
	_counter_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	title_bar.add_child(_counter_label)

	var close_btn := Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(16, 16)
	close_btn.add_theme_font_size_override("font_size", 9)
	close_btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.4, 0.15, 0.15), 2))
	close_btn.add_theme_stylebox_override("hover", _make_stylebox(Color(0.55, 0.2, 0.2), 2))
	close_btn.add_theme_stylebox_override("pressed", _make_stylebox(Color(0.3, 0.1, 0.1), 2))
	close_btn.pressed.connect(_close)
	title_bar.add_child(close_btn)

	root_vbox.add_child(HSeparator.new())

	# Tabs
	var tab_bar := HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 2)
	root_vbox.add_child(tab_bar)

	var tab_names = ["Active", "Completed", "Claimed"]
	for i in range(tab_names.size()):
		var b := Button.new()
		b.text = tab_names[i]
		b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		b.custom_minimum_size = Vector2(0, 16)
		b.add_theme_font_size_override("font_size", 8)
		b.add_theme_color_override("font_color", COLOR_TEXT)
		b.pressed.connect(_on_tab_pressed.bind(i))
		tab_bar.add_child(b)
		tab_buttons.append(b)

	_update_tab_styles()

	# Split
	var split := HBoxContainer.new()
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	split.add_theme_constant_override("separation", 4)
	root_vbox.add_child(split)

	# Left list
	var left_panel := PanelContainer.new()
	left_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left_panel.size_flags_stretch_ratio = 0.38
	left_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 2))
	split.add_child(left_panel)

	var left_scroll := ScrollContainer.new()
	left_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL # FIX: prevent width collapse
	left_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	left_panel.add_child(left_scroll)

	content_container = VBoxContainer.new()
	content_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL # FIX: ensure rows get full width
	content_container.add_theme_constant_override("separation", 1)
	left_scroll.add_child(content_container)

	# Right detail
	var right_panel := PanelContainer.new()
	right_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right_panel.size_flags_stretch_ratio = 0.62
	right_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 2))
	split.add_child(right_panel)

	var right_scroll := ScrollContainer.new()
	right_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right_scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL # FIX: prevent width collapse
	right_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	right_panel.add_child(right_scroll)

	var right_margin := MarginContainer.new()
	right_margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL # FIX: allow detail content to use full width
	right_margin.add_theme_constant_override("margin_left", 4)
	right_margin.add_theme_constant_override("margin_right", 4)
	right_margin.add_theme_constant_override("margin_top", 3)
	right_margin.add_theme_constant_override("margin_bottom", 3)
	right_scroll.add_child(right_margin)

	detail_container = VBoxContainer.new()
	detail_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL # FIX: stops vertical letter-wrapping
	detail_container.add_theme_constant_override("separation", 3)
	right_margin.add_child(detail_container)

func _on_tab_pressed(i: int):
	current_tab = i
	selected_quest_id = ""
	_update_tab_styles()
	_refresh_tab()

func _update_tab_styles():
	for i in range(tab_buttons.size()):
		var btn: Button = tab_buttons[i]
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

	var all = QuestManager.list_all()
	var filtered: Array[Dictionary] = []

	for q in all:
		var id := str(q.get("id",""))
		var bucket = QuestManager.get_status_bucket(id)
		if current_tab == 0 and bucket == "active":
			filtered.append(q)
		elif current_tab == 1 and bucket == "completed":
			filtered.append(q)
		elif current_tab == 2 and bucket == "claimed":
			filtered.append(q)

	filtered.sort_custom(func(a, b):
		return str(a.get("title","")) < str(b.get("title",""))
	)

	_update_counter()

	if filtered.is_empty():
		_show_empty_detail("No quests in this category.")
		return

	for q in filtered:
		var id := str(q.get("id",""))
		content_container.add_child(_make_row(q))
		if selected_quest_id == "":
			selected_quest_id = id

	_show_detail(selected_quest_id)

func _make_row(q: Dictionary) -> Control:
	var id := str(q.get("id",""))
	var title := str(q.get("title", id))
	var status = QuestManager.get_status_bucket(id)

	var row := Button.new()
	row.custom_minimum_size = Vector2(0, 18)
	row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	row.clip_text = true
	row.text = title
	row.add_theme_font_size_override("font_size", 8)

	if status == "completed":
		row.add_theme_color_override("font_color", COLOR_GOOD)
	elif status == "claimed":
		row.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	else:
		row.add_theme_color_override("font_color", COLOR_TEXT)

	var is_selected := (selected_quest_id == id)
	if is_selected:
		row.add_theme_stylebox_override("normal", _make_stylebox(COLOR_PANEL_HOVER, 2, COLOR_ACCENT_DIM, 1))
	else:
		row.add_theme_stylebox_override("normal", _make_stylebox(Color.TRANSPARENT, 0))

	row.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2))
	row.add_theme_stylebox_override("pressed", _make_stylebox(COLOR_PANEL, 2))
	row.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

	row.pressed.connect(func():
		selected_quest_id = id
		_show_detail(id)
	)

	return row

func _show_detail(id: String):
	_clear_container(detail_container)
	selected_quest_id = id

	var q = QuestManager.get_quest(id)
	if q.is_empty():
		_show_empty_detail("Quest not found.")
		return

	var status = QuestManager.get_status_bucket(id)
	var obj: Dictionary = q.get("objective", {})
	var target := int(obj.get("target", 1))
	var prog = QuestManager.get_progress(id)

	# Status tag
	var tag := Label.new()
	tag.add_theme_font_size_override("font_size", 7)
	tag.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	if status == "completed":
		tag.text = "COMPLETED"
		tag.add_theme_color_override("font_color", COLOR_GOOD)
	elif status == "claimed":
		tag.text = "CLAIMED"
	else:
		tag.text = "ACTIVE"
	detail_container.add_child(tag)

	# Title
	var name_lbl := Label.new()
	name_lbl.text = str(q.get("title", id))
	name_lbl.add_theme_font_size_override("font_size", 11)
	name_lbl.add_theme_color_override("font_color", COLOR_ACCENT)
	detail_container.add_child(name_lbl)

	var sep := HSeparator.new()
	sep.add_theme_constant_override("separation", 2)
	detail_container.add_child(sep)

	# Description
	var desc := Label.new()
	desc.text = str(q.get("desc",""))
	desc.add_theme_font_size_override("font_size", 7)
	desc.add_theme_color_override("font_color", COLOR_TEXT)
	desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_container.add_child(desc)

	# Progress
	var prog_lbl := Label.new()
	prog_lbl.text = "Progress: %d / %d" % [prog, target]
	prog_lbl.add_theme_font_size_override("font_size", 7)
	prog_lbl.add_theme_color_override("font_color", COLOR_ACCENT_DIM)
	detail_container.add_child(prog_lbl)

	# Reward summary
	var reward = q.get("reward", {})
	var reward_lbl := Label.new()
	reward_lbl.text = "Reward: " + _format_reward(reward)
	reward_lbl.add_theme_font_size_override("font_size", 7)
	reward_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	reward_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_container.add_child(reward_lbl)

	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 4)
	detail_container.add_child(spacer)

	# Claim button
	var btn := Button.new()
	btn.custom_minimum_size = Vector2(0, 18)
	btn.add_theme_font_size_override("font_size", 8)
	btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	if status == "completed":
		btn.text = "CLAIM REWARD"
		btn.disabled = false
		btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.12, 0.12, 0.15), 2, COLOR_ACCENT_DIM, 1))
		btn.add_theme_stylebox_override("hover", _make_stylebox(Color(0.16, 0.16, 0.2), 2, COLOR_ACCENT, 1))
		btn.add_theme_stylebox_override("pressed", _make_stylebox(Color(0.10, 0.10, 0.12), 2, COLOR_ACCENT, 1))
	elif status == "claimed":
		btn.text = "REWARD CLAIMED"
		btn.disabled = true
		btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.12, 0.12, 0.15), 2))
	else:
		btn.text = "NOT COMPLETE"
		btn.disabled = true
		btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.14, 0.12, 0.12), 2, COLOR_BAD, 1))

	btn.pressed.connect(func():
		if QuestManager.claim(id):
			quest_claimed.emit(id)
			_refresh_tab()
	)

	detail_container.add_child(btn)

func _update_counter():
	var all = QuestManager.list_all()
	var active := 0
	var completed := 0
	var claimed := 0
	for q in all:
		var id := str(q.get("id",""))
		match QuestManager.get_status_bucket(id):
			"active": active += 1
			"completed": completed += 1
			"claimed": claimed += 1
	_counter_label.text = "Active %d  |  Ready %d  |  Claimed %d" % [active, completed, claimed]

func _format_reward(r: Dictionary) -> String:
	var t := str(r.get("type",""))
	match t:
		"currency":
			var amt := int(r.get("amount", 0))
			var c := int(r.get("currency", 0))
			var cname := "Currency"
			if c == CurrencyManager.Currency.MIST_SHARDS:
				cname = "Mist Shards"
			elif c == CurrencyManager.Currency.BOSS_EMBLEM:
				cname = "Boss Emblems"
			return "%d %s" % [amt, cname]
		"prosthetic_unlock":
			return "Unlock Prosthetic: " + str(r.get("prosthetic_id",""))
		"relic_unlock":
			return "Unlock Relic: " + str(r.get("relic_id",""))
		"cosmetic":
			return "Cosmetic: " + str(r.get("cosmetic_id",""))
		_:
			return "Unknown"

func _show_empty_detail(text: String):
	_clear_container(detail_container)
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 8)
	lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_container.add_child(lbl)

func _clear_container(container: VBoxContainer):
	for child in container.get_children():
		child.queue_free()

func _make_stylebox(bg_color: Color, corner_radius: int = 0, border_color: Color = Color.TRANSPARENT, border_width: int = 0) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
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
	get_tree().paused = false
	for hud in get_tree().get_nodes_in_group("game_hud"):
		hud.visible = true
	menu_closed.emit()
	queue_free()
