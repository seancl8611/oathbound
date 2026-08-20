extends CanvasLayer

## HubHUD — Hub-only currency display, built entirely via script.
##
## Shows stacked currency rows: Gold, Mist Shards, Boss Emblems.
## Only instantiated in the Hub scene. Replaces the old CurrencyHUD.tscn.
##
## Usage (from hub.gd):
##   var hud = load("res://GUI/HubHUD.gd").new()
##   get_tree().root.add_child(hud)

# ─── Colors ───
const COL_BG = Color(0.06, 0.06, 0.09, 0.85)
const COL_BORDER = Color(0.12, 0.12, 0.18, 1.0)
const COL_GOLD = Color(0.91, 0.77, 0.29, 1.0)
const COL_MIST = Color(0.66, 0.48, 0.87, 1.0)
const COL_EMBLEM = Color(0.87, 0.66, 0.27, 1.0)
const COL_TEXT = Color(0.85, 0.85, 0.88, 1.0)
const COL_TEXT_DIM = Color(0.42, 0.42, 0.48, 1.0)
const COL_SCROLL = Color(0.87, 0.78, 0.55, 1.0)

# ─── UI refs ───
var _root: Control
var _gold_label: Label
var _mist_label: Label
var _emblem_label: Label
var _scroll_label: Label

func _ready() -> void:
	layer = 50
	name = "HubHUD"
	add_to_group("game_hud")
	_build_ui()
	_connect_signals()
	_refresh_all()
	
func _build_ui() -> void:
	_root = Control.new()
	_root.name = "HubHUDRoot"
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	var panel = VBoxContainer.new()
	panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	panel.position = Vector2(-70, 12)
	panel.add_theme_constant_override("separation", 2)
	_root.add_child(panel)

	_gold_label = _make_currency_row(panel, COL_GOLD)
	_mist_label = _make_currency_row(panel, COL_MIST)
	_scroll_label = _make_currency_row(panel, COL_SCROLL)
	_emblem_label = _make_currency_row(panel, COL_EMBLEM)
	
func _make_currency_row(parent: Control, value_color: Color) -> Label:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 4)
	parent.add_child(row)

	# Small background
	var bg = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = COL_BG
	style.border_color = COL_BORDER
	style.border_width_left = 1
	style.border_width_right = 1
	style.border_width_top = 1
	style.border_width_bottom = 1
	style.corner_radius_top_left = 2
	style.corner_radius_top_right = 2
	style.corner_radius_bottom_left = 2
	style.corner_radius_bottom_right = 2
	style.content_margin_left = 6
	style.content_margin_right = 6
	style.content_margin_top = 2
	style.content_margin_bottom = 2
	bg.add_theme_stylebox_override("panel", style)
	row.add_child(bg)

	var inner = HBoxContainer.new()
	inner.add_theme_constant_override("separation", 5)
	bg.add_child(inner)

	# Tiny icon square
	var icon = ColorRect.new()
	icon.custom_minimum_size = Vector2(8, 8)
	icon.color = value_color
	inner.add_child(icon)

	# Value only — no name text
	var val_lbl = Label.new()
	val_lbl.add_theme_font_size_override("font_size", 10)
	val_lbl.add_theme_color_override("font_color", value_color)
	val_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	val_lbl.custom_minimum_size = Vector2(24, 0)
	inner.add_child(val_lbl)

	return val_lbl
	
func _connect_signals() -> void:
	CurrencyManager.currency_changed.connect(_on_currency_changed)

func _refresh_all() -> void:
	_gold_label.text = str(CurrencyManager.get_amount(CurrencyManager.Currency.GOLD))
	_mist_label.text = str(CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS))
	_scroll_label.text = str(CurrencyManager.get_amount(CurrencyManager.Currency.SCROLLS))
	_emblem_label.text = str(CurrencyManager.get_amount(CurrencyManager.Currency.BOSS_EMBLEM))
	
func _on_currency_changed(currency: int, new_amount: int) -> void:
	match currency:
		CurrencyManager.Currency.GOLD:
			_gold_label.text = str(new_amount)
		CurrencyManager.Currency.MIST_SHARDS:
			_mist_label.text = str(new_amount)
		CurrencyManager.Currency.SCROLLS:
			_scroll_label.text = str(new_amount)
		CurrencyManager.Currency.BOSS_EMBLEM:
			_emblem_label.text = str(new_amount)
