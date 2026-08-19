# res://UI/MetaShrineMenu.gd
extends Control

## MetaShrineMenu — Tree-based meta progression UI built entirely in script.
## Replaces the old flat-list menu with branching upgrade trees.
##
## Depends on: MetaProgressionManager (autoload), CurrencyManager (autoload)

signal menu_closed
signal upgrade_purchased(upgrade_id: String)

# =====================
# THEME COLORS (match existing CodexMenu / ForgeMenu style)
# =====================

const COLOR_BG = Color(0.06, 0.06, 0.08, 1.0)
const COLOR_PANEL = Color(0.10, 0.10, 0.13, 1.0)
const COLOR_PANEL_HOVER = Color(0.14, 0.14, 0.18, 1.0)
const COLOR_ACCENT = Color(0.85, 0.75, 0.45, 1.0)
const COLOR_ACCENT_DIM = Color(0.5, 0.45, 0.3, 1.0)
const COLOR_TEXT = Color(0.9, 0.9, 0.88, 1.0)
const COLOR_TEXT_DIM = Color(0.50, 0.48, 0.45, 1.0)
const COLOR_GOOD = Color(0.45, 0.72, 0.45, 1.0)
const COLOR_BAD = Color(0.65, 0.35, 0.35, 1.0)
const COLOR_MAXED = Color(0.72, 0.68, 0.48, 1.0)
const COLOR_LOCKED = Color(0.30, 0.28, 0.32, 0.5)
const COLOR_MIST = Color(0.66, 0.48, 0.87, 1.0)
const COLOR_EMBLEM = Color(0.84, 0.66, 0.27, 1.0)

const BRANCH_COLORS = {
	"steel": Color(0.45, 0.58, 0.78),
	"secrets": Color(0.45, 0.72, 0.50),
	"vows": Color(0.78, 0.58, 0.42),
}

const BRANCH_NAMES = {
	"steel": "WAY OF STEEL",
	"secrets": "WAY OF SECRETS",
	"vows": "WAY OF VOWS",
}

const TIER_NAMES = {
	1: "Tier I",
	2: "Tier II",
	3: "Tier III",
}

# =====================
# STATE
# =====================

var _prev_paused = false
var _active_branch = "steel"

# UI refs
var _tab_buttons = {}          # branch -> Button
var _branch_panels = {}        # branch -> VBoxContainer
var _node_cards = {}           # upgrade_id -> PanelContainer
var _buy_buttons = {}          # upgrade_id -> Button
var _rank_labels = {}          # upgrade_id -> Label
var _effect_labels = {}        # upgrade_id -> Label
var _gate_containers = {}      # "branch_tier" -> HBoxContainer
var _gate_text_labels = {}     # "branch_tier" -> Label
var _currency_label: Label
var _detail_panel: PanelContainer
var _detail_name: Label
var _detail_desc: Label
var _detail_effect: Label
var _detail_cost: Label

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
	_show_branch("steel")
	_refresh_all()

	# Live updates when currencies change
	var cm = get_node_or_null("/root/CurrencyManager")
	if cm:
		cm.currency_changed.connect(_on_currency_changed)

	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp and mp.has_signal("changed"):
		mp.changed.connect(_on_meta_changed)


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
	dimmer.color = Color(0, 0, 0, 0.7)
	add_child(dimmer)

	# Main panel: 92% of viewport
	var main_panel = PanelContainer.new()
	main_panel.anchor_left = 0.04
	main_panel.anchor_top = 0.04
	main_panel.anchor_right = 0.96
	main_panel.anchor_bottom = 0.96
	main_panel.add_theme_stylebox_override("panel", _make_stylebox(COLOR_BG, 4, COLOR_ACCENT_DIM, 1))
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

	# --- Title bar ---
	_build_title_bar(root_vbox)

	# --- Separator ---
	var sep = HSeparator.new()
	sep.add_theme_constant_override("separation", 2)
	root_vbox.add_child(sep)

	# --- Tab row (branch selector) ---
	_build_tab_row(root_vbox)

	# --- Scrollable tree area ---
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root_vbox.add_child(scroll)

	var scroll_inner = VBoxContainer.new()
	scroll_inner.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll_inner.add_theme_constant_override("separation", 0)
	scroll.add_child(scroll_inner)

	# Build each branch panel (only one visible at a time)
	for branch in ["steel", "secrets", "vows"]:
		var panel = VBoxContainer.new()
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		panel.add_theme_constant_override("separation", 3)
		panel.visible = false
		scroll_inner.add_child(panel)
		_branch_panels[branch] = panel
		_build_branch_panel(panel, branch)

	# --- Hover detail panel (bottom) ---
	_build_detail_panel(root_vbox)


func _build_title_bar(parent: Control) -> void:
	var title_bar = HBoxContainer.new()
	title_bar.add_theme_constant_override("separation", 8)
	parent.add_child(title_bar)

	var title_label = Label.new()
	title_label.text = "THE SHRINE"
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_label.add_theme_font_size_override("font_size", 14)
	title_label.add_theme_color_override("font_color", COLOR_ACCENT)
	title_bar.add_child(title_label)

	# Currency display
	_currency_label = Label.new()
	_currency_label.add_theme_font_size_override("font_size", 9)
	_currency_label.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	title_bar.add_child(_currency_label)

	var close_btn = Button.new()
	close_btn.text = "X"
	close_btn.custom_minimum_size = Vector2(18, 18)
	close_btn.add_theme_font_size_override("font_size", 9)
	close_btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.4, 0.15, 0.15), 2))
	close_btn.add_theme_stylebox_override("hover", _make_stylebox(Color(0.55, 0.2, 0.2), 2))
	close_btn.add_theme_stylebox_override("pressed", _make_stylebox(Color(0.3, 0.1, 0.1), 2))
	close_btn.pressed.connect(_close)
	title_bar.add_child(close_btn)


func _build_tab_row(parent: Control) -> void:
	var tab_bar = HBoxContainer.new()
	tab_bar.add_theme_constant_override("separation", 3)
	tab_bar.alignment = BoxContainer.ALIGNMENT_CENTER
	parent.add_child(tab_bar)

	for branch in ["steel", "secrets", "vows"]:
		var btn = Button.new()
		btn.text = BRANCH_NAMES[branch]
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.custom_minimum_size = Vector2(0, 20)
		btn.add_theme_font_size_override("font_size", 9)
		btn.add_theme_color_override("font_color", COLOR_TEXT)
		btn.pressed.connect(_on_branch_tab_pressed.bind(branch))
		tab_bar.add_child(btn)
		_tab_buttons[branch] = btn


func _build_branch_panel(parent: Control, branch: String) -> void:
	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp == null:
		return

	for tier in [1, 2, 3]:
		# Tier header
		var tier_header = Label.new()
		tier_header.text = TIER_NAMES[tier]
		tier_header.add_theme_font_size_override("font_size", 10)
		tier_header.add_theme_color_override("font_color", COLOR_TEXT_DIM)
		parent.add_child(tier_header)

		# Node cards row
		var row = HBoxContainer.new()
		row.add_theme_constant_override("separation", 6)
		row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		parent.add_child(row)

		var tier_ids = mp.get_tree_ids_for_tier(branch, tier)
		for id in tier_ids:
			_build_node_card(row, id, branch)

		# Gate between tiers (not after tier 3)
		if tier < 3:
			var gate = HBoxContainer.new()
			gate.add_theme_constant_override("separation", 6)
			gate.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			parent.add_child(gate)

			var gate_text = Label.new()
			gate_text.add_theme_font_size_override("font_size", 9)
			gate.add_child(gate_text)

			var gate_sep = HSeparator.new()
			gate_sep.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			gate.add_child(gate_sep)

			var gate_key = branch + "_" + str(tier + 1)
			_gate_containers[gate_key] = gate
			_gate_text_labels[gate_key] = gate_text


func _build_node_card(parent: Control, upgrade_id: String, branch: String) -> void:
	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp == null:
		return
	var data = mp.get_tree_upgrade(upgrade_id)
	if data.is_empty():
		return

	var card = PanelContainer.new()
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.custom_minimum_size = Vector2(200, 0)
	card.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 4, BRANCH_COLORS.get(branch, COLOR_TEXT_DIM), 1))
	parent.add_child(card)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 2)
	card.add_child(vbox)

	# Top: name + rank
	var top = HBoxContainer.new()
	top.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	vbox.add_child(top)

	var name_lbl = Label.new()
	name_lbl.text = data.get("name", upgrade_id)
	name_lbl.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_lbl.add_theme_font_size_override("font_size", 10)
	name_lbl.add_theme_color_override("font_color", COLOR_TEXT)
	top.add_child(name_lbl)

	var rank_lbl = Label.new()
	rank_lbl.add_theme_font_size_override("font_size", 8)
	rank_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	top.add_child(rank_lbl)
	_rank_labels[upgrade_id] = rank_lbl

	# Description
	var desc_lbl = Label.new()
	desc_lbl.text = data.get("description", "")
	desc_lbl.add_theme_font_size_override("font_size", 7)
	desc_lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	desc_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(desc_lbl)

	# Effect text
	var effect_lbl = Label.new()
	effect_lbl.add_theme_font_size_override("font_size", 7)
	effect_lbl.add_theme_color_override("font_color", Color(0.58, 0.55, 0.65))
	effect_lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(effect_lbl)
	_effect_labels[upgrade_id] = effect_lbl

	# Buy button
	var buy_btn = Button.new()
	buy_btn.custom_minimum_size = Vector2(0, 18)
	buy_btn.add_theme_font_size_override("font_size", 8)
	buy_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	buy_btn.pressed.connect(_on_buy_pressed.bind(upgrade_id))
	vbox.add_child(buy_btn)
	_buy_buttons[upgrade_id] = buy_btn

	# Hover events for detail panel
	card.mouse_entered.connect(_on_card_hover.bind(upgrade_id))
	card.mouse_exited.connect(_on_card_unhover)

	_node_cards[upgrade_id] = card


func _build_detail_panel(parent: Control) -> void:
	_detail_panel = PanelContainer.new()
	_detail_panel.custom_minimum_size = Vector2(0, 44)
	_detail_panel.visible = false
	_detail_panel.add_theme_stylebox_override("panel", _make_stylebox(Color(0.06, 0.05, 0.08, 0.95), 3, COLOR_ACCENT_DIM, 1))
	parent.add_child(_detail_panel)

	var hbox = HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 12)
	_detail_panel.add_child(hbox)

	var left = VBoxContainer.new()
	left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	left.add_theme_constant_override("separation", 1)
	hbox.add_child(left)

	_detail_name = Label.new()
	_detail_name.add_theme_font_size_override("font_size", 11)
	_detail_name.add_theme_color_override("font_color", COLOR_ACCENT)
	left.add_child(_detail_name)

	_detail_desc = Label.new()
	_detail_desc.add_theme_font_size_override("font_size", 8)
	_detail_desc.add_theme_color_override("font_color", COLOR_TEXT)
	_detail_desc.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	left.add_child(_detail_desc)

	_detail_effect = Label.new()
	_detail_effect.add_theme_font_size_override("font_size", 7)
	_detail_effect.add_theme_color_override("font_color", COLOR_TEXT_DIM)
	_detail_effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	left.add_child(_detail_effect)

	_detail_cost = Label.new()
	_detail_cost.add_theme_font_size_override("font_size", 9)
	hbox.add_child(_detail_cost)


# =====================
# REFRESH
# =====================

func _refresh_all() -> void:
	_update_currency_label()
	_update_tab_styles()

	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp == null:
		return

	for upgrade_id in _node_cards:
		_refresh_card(upgrade_id)

	_refresh_gates()


func _update_currency_label() -> void:
	var cm = get_node_or_null("/root/CurrencyManager")
	var mist = 0
	var emblems = 0
	if cm:
		mist = int(cm.get_amount(cm.Currency.MIST_SHARDS))
		emblems = int(cm.get_amount(cm.Currency.BOSS_EMBLEM))
	_currency_label.text = "Mist: %d  |  Emblems: %d" % [mist, emblems]


func _update_tab_styles() -> void:
	for branch in _tab_buttons:
		var btn = _tab_buttons[branch]
		var accent = BRANCH_COLORS.get(branch, COLOR_TEXT)
		if branch == _active_branch:
			btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.14, 0.14, 0.18), 2, accent, 1))
			btn.add_theme_stylebox_override("hover", _make_stylebox(Color(0.16, 0.16, 0.20), 2, accent, 1))
			btn.add_theme_color_override("font_color", accent)
		else:
			btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.08, 0.08, 0.10), 2))
			btn.add_theme_stylebox_override("hover", _make_stylebox(COLOR_PANEL_HOVER, 2))
			btn.add_theme_color_override("font_color", COLOR_TEXT_DIM)


func _refresh_card(upgrade_id: String) -> void:
	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp == null:
		return

	var data = mp.get_tree_upgrade(upgrade_id)
	if data.is_empty():
		return

	var rank = mp.get_tree_rank(upgrade_id)
	var max_rank = data.get("max_rank", 1)
	var tier = data.get("tier", 1)
	var branch = data.get("branch", "steel")
	var tier_ok = mp.is_tier_unlocked(branch, tier)
	var is_max = mp.is_tree_maxed(upgrade_id)
	var can_buy = mp.can_tree_purchase(upgrade_id)
	var accent = BRANCH_COLORS.get(branch, COLOR_TEXT)

	# Rank label
	if _rank_labels.has(upgrade_id):
		_rank_labels[upgrade_id].text = "%d / %d" % [rank, max_rank]
		if is_max:
			_rank_labels[upgrade_id].add_theme_color_override("font_color", COLOR_MAXED)
		else:
			_rank_labels[upgrade_id].add_theme_color_override("font_color", COLOR_TEXT_DIM)

	# Effect text
	if _effect_labels.has(upgrade_id):
		var effect_texts = data.get("effect_text", [])
		if rank > 0 and rank <= effect_texts.size():
			_effect_labels[upgrade_id].text = "Current: " + effect_texts[rank - 1]
			_effect_labels[upgrade_id].add_theme_color_override("font_color", Color(0.65, 0.62, 0.72))
		elif effect_texts.size() > 0:
			_effect_labels[upgrade_id].text = effect_texts[0]
			_effect_labels[upgrade_id].add_theme_color_override("font_color", Color(0.50, 0.48, 0.55))
		else:
			_effect_labels[upgrade_id].text = ""

	# Card visual state
	var card = _node_cards.get(upgrade_id)
	if card:
		if not tier_ok:
			card.add_theme_stylebox_override("panel", _make_stylebox(Color(0.06, 0.06, 0.08, 0.5), 4, COLOR_LOCKED, 1))
			card.modulate = Color(0.5, 0.5, 0.5, 0.6)
		elif is_max:
			card.add_theme_stylebox_override("panel", _make_stylebox(Color(0.12, 0.11, 0.15), 4, Color(accent.r, accent.g, accent.b, 0.4), 1))
			card.modulate = Color.WHITE
		else:
			card.add_theme_stylebox_override("panel", _make_stylebox(COLOR_PANEL, 4, Color(accent.r, accent.g, accent.b, 0.2), 1))
			card.modulate = Color.WHITE

	# Buy button
	if _buy_buttons.has(upgrade_id):
		var btn = _buy_buttons[upgrade_id]
		if not tier_ok:
			btn.text = "LOCKED"
			btn.disabled = true
			btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.08, 0.08, 0.10), 2))
			btn.add_theme_color_override("font_color", COLOR_LOCKED)
		elif is_max:
			btn.text = "MASTERED"
			btn.disabled = true
			btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.10, 0.12, 0.10), 2, COLOR_MAXED, 1))
			btn.add_theme_color_override("font_color", COLOR_MAXED)
		elif can_buy:
			var cost = mp.get_tree_cost(upgrade_id)
			btn.text = "PURCHASE - " + _format_cost(cost)
			btn.disabled = false
			btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.10, 0.10, 0.13), 2, COLOR_ACCENT_DIM, 1))
			btn.add_theme_stylebox_override("hover", _make_stylebox(Color(0.14, 0.14, 0.18), 2, COLOR_ACCENT, 1))
			btn.add_theme_stylebox_override("pressed", _make_stylebox(Color(0.08, 0.08, 0.10), 2, COLOR_ACCENT, 1))
			btn.add_theme_color_override("font_color", COLOR_GOOD)
		else:
			var cost = mp.get_tree_cost(upgrade_id)
			if cost.is_empty():
				btn.text = "MAX"
				btn.disabled = true
			else:
				btn.text = _format_cost(cost)
				btn.disabled = true
			btn.add_theme_stylebox_override("normal", _make_stylebox(Color(0.10, 0.08, 0.08), 2, COLOR_BAD, 1))
			btn.add_theme_color_override("font_color", COLOR_BAD)


func _refresh_gates() -> void:
	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp == null:
		return

	for branch in ["steel", "secrets", "vows"]:
		for tier in [2, 3]:
			var gate_key = branch + "_" + str(tier)
			if not _gate_text_labels.has(gate_key):
				continue

			var unlocked = mp.is_tier_unlocked(branch, tier)
			var owned = mp.count_tier_owned(branch, tier - 1)
			var needed = mp.TIER_GATE_REQUIREMENT
			var lbl = _gate_text_labels[gate_key]

			if unlocked:
				lbl.text = "~ %s Unlocked ~" % TIER_NAMES[tier]
				lbl.add_theme_color_override("font_color", COLOR_GOOD)
			else:
				lbl.text = "Buy %d %s nodes to unlock (%d/%d)" % [needed, TIER_NAMES[tier - 1], owned, needed]
				lbl.add_theme_color_override("font_color", COLOR_TEXT_DIM)


# =====================
# CALLBACKS
# =====================

func _on_branch_tab_pressed(branch: String) -> void:
	_show_branch(branch)


func _show_branch(branch: String) -> void:
	_active_branch = branch
	for b in _branch_panels:
		_branch_panels[b].visible = (b == branch)
	_update_tab_styles()


func _on_buy_pressed(upgrade_id: String) -> void:
	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp == null:
		return

	if mp.tree_purchase(upgrade_id):
		upgrade_purchased.emit(upgrade_id)
		# Flash feedback
		var card = _node_cards.get(upgrade_id)
		if card:
			var original = card.modulate
			card.modulate = Color(1.3, 1.25, 1.0)
			var tw = create_tween()
			tw.tween_property(card, "modulate", original, 0.25)


func _on_card_hover(upgrade_id: String) -> void:
	var mp = get_node_or_null("/root/MetaProgressionManager")
	if mp == null:
		return

	var data = mp.get_tree_upgrade(upgrade_id)
	if data.is_empty():
		return

	var rank = mp.get_tree_rank(upgrade_id)
	var max_rank = data.get("max_rank", 1)
	var effect_texts = data.get("effect_text", [])

	_detail_name.text = data.get("name", upgrade_id)
	_detail_desc.text = data.get("description", "")

	# Show current rank + next rank preview
	var lines = []
	if rank > 0 and rank <= effect_texts.size():
		lines.append("Current (Rank %d): %s" % [rank, effect_texts[rank - 1]])
	if rank < max_rank and rank < effect_texts.size():
		lines.append("Next (Rank %d): %s" % [rank + 1, effect_texts[rank]])
	elif rank == 0 and effect_texts.size() > 0:
		lines.append("Rank 1: %s" % effect_texts[0])
	_detail_effect.text = "\n".join(lines)

	# Cost
	if rank < max_rank:
		var cost = mp.get_tree_cost(upgrade_id)
		_detail_cost.text = _format_cost(cost)
		if mp.can_tree_purchase(upgrade_id):
			_detail_cost.add_theme_color_override("font_color", COLOR_GOOD)
		else:
			_detail_cost.add_theme_color_override("font_color", COLOR_BAD)
	else:
		_detail_cost.text = "MASTERED"
		_detail_cost.add_theme_color_override("font_color", COLOR_MAXED)

	_detail_panel.visible = true


func _on_card_unhover() -> void:
	_detail_panel.visible = false


func _on_currency_changed(_currency: int, _new_amount: int) -> void:
	_refresh_all()


func _on_meta_changed() -> void:
	_refresh_all()


# =====================
# FORMAT HELPERS
# =====================

func _format_cost(cost: Dictionary) -> String:
	var parts = []
	var mist = int(cost.get("mist", 0))
	var emb = int(cost.get("emblems", 0))
	if mist > 0:
		parts.append("%d Mist" % mist)
	if emb > 0:
		if emb == 1:
			parts.append("1 Emblem")
		else:
			parts.append("%d Emblems" % emb)
	if parts.size() == 0:
		return "Free"
	return " + ".join(parts)


# =====================
# SHARED HELPERS (same as your existing _make_stylebox / _close pattern)
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
