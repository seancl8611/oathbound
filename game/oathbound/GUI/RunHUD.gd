extends CanvasLayer

## RunHUD — Always-visible combat HUD, built entirely via script.
##
## Shows: HP bar, posture bar, gold counter, spirit pips (0–10),
##        equipped prosthetic icon with cooldown ring, spirit cost badge,
##        and relic socket dots.
##
## Usage:
##   var hud = load("res://GUI/RunHUD.gd").new()
##   add_child(hud)
##   hud.setup(self)  # pass player reference
##
## The HUD auto-connects to ProstheticExecutor and CurrencyManager signals.
## Call update_*() methods from player when values change, or connect signals.

# ─── Layout constants ───
const HP_BAR_WIDTH = 180.0
const HP_BAR_HEIGHT = 8.0
const POSTURE_BAR_WIDTH = 150.0
const POSTURE_BAR_HEIGHT = 5.0
const SPIRIT_PIP_W = 10.0
const SPIRIT_PIP_H = 14.0
const SPIRIT_PIP_GAP = 3.0
const PROSTHETIC_BOX_SIZE = 44.0
const COOLDOWN_RING_RADIUS = 24.0
const COOLDOWN_RING_WIDTH = 2.5
const COL_MIST = Color(0.66, 0.48, 0.87, 1.0)
const COL_SCROLL = Color(0.87, 0.78, 0.55, 1.0)
const COL_EMBLEM = Color(0.87, 0.66, 0.27, 1.0)
const COL_MAXHP = Color(0.85, 0.2, 0.15, 1.0)
const COL_MAXPOSTURE = Color(0.87, 0.67, 0.13, 1.0)
# ─── Colors ───
const COL_HP_FILL = Color(0.8, 0.13, 0.13, 0.95)
const COL_HP_LOW = Color(0.9, 0.2, 0.1, 1.0)
const COL_HP_BG = Color(0.15, 0.04, 0.04, 0.8)
const COL_HP_BORDER = Color(0.25, 0.08, 0.08, 0.9)
const COL_POSTURE_FILL = Color(0.87, 0.67, 0.13, 0.95)
const COL_POSTURE_HIGH = Color(0.9, 0.4, 0.05, 1.0)
const COL_POSTURE_BG = Color(0.1, 0.1, 0.03, 0.8)
const COL_GOLD = Color(0.91, 0.77, 0.29, 1.0)
const COL_SPIRIT_FILLED = Color(0.35, 0.69, 0.87, 1.0)
const COL_SPIRIT_GLOW = Color(0.48, 0.81, 1.0, 1.0)
const COL_SPIRIT_EMPTY = Color(0.1, 0.16, 0.23, 0.8)
const COL_SPIRIT_BORDER = Color(0.35, 0.69, 0.87, 0.3)
const COL_COOLDOWN = Color(0.35, 0.69, 0.87, 0.85)
const COL_COOLDOWN_BG = Color(0.35, 0.69, 0.87, 0.1)
const COL_PANEL_BG = Color(0.09, 0.09, 0.12, 0.9)
const COL_BORDER = Color(0.17, 0.17, 0.23, 1.0)
const COL_TEXT = Color(0.85, 0.85, 0.88, 1.0)
const COL_TEXT_DIM = Color(0.42, 0.42, 0.48, 1.0)
const COL_RELIC_EMPTY = Color(0.17, 0.17, 0.23, 1.0)
const COL_RELIC_FILLED = Color(0.66, 0.48, 0.87, 1.0)

# ─── State ───
var _player: Node = null

var _hp: int = 50
var _max_hp: int = 50
var _posture: float = 0.0
var _posture_max: float = 100.0
var _gold: int = 0
var _spirit: int = 10
var _spirit_max: int = 10
var _cooldown_pct: float = 0.0  # 0 = ready, 1 = full cooldown
var _spirit_cost: int = 0
var _relic_sockets: int = 0
var _relic_filled: int = 0
var _prosthetic_id: String = ""
var _toast_container: VBoxContainer

# ─── UI node refs ───
var _root: Control
var _hp_fill: ColorRect
var _hp_text: Label
var _posture_fill: ColorRect
var _gold_label: Label
var _spirit_pips: Array = []  # Array of ColorRect
var _prosthetic_icon_label: Label
var _cost_label: Label
var _cooldown_drawer: Control  # Custom draw for arc
var _relic_dot_container: HBoxContainer
var _spirit_pop_label: Label
var _spirit_pop_tween: Tween
var _hp_container: Node
var _posture_container: Node
var _is_hub_mode: bool = false
var _gold_container: Node

func _ready() -> void:
	layer = 100
	name = "RunHUD"
	add_to_group("game_hud")
	_build_ui()
	
func setup(player: Node) -> void:
	_player = player
	_connect_signals()
	_refresh_all()


# =============================================================================
# UI CONSTRUCTION
# =============================================================================

func _build_ui() -> void:
	_root = Control.new()
	_root.name = "RunHUDRoot"
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_build_hp_section()
	_build_posture_section()
	_build_gold_section()
	_build_spirit_section()
	_build_prosthetic_section()
	_build_toast_section()

func _build_hp_section() -> void:
	# Container: top-left
	var container = HBoxContainer.new()
	container.position = Vector2(16, 12)
	container.add_theme_constant_override("separation", 8)
	_root.add_child(container)
	_hp_container = container

	# HP icon (simple red diamond)
	var icon_container = Control.new()
	icon_container.custom_minimum_size = Vector2(14, 14)
	container.add_child(icon_container)

	var icon = ColorRect.new()
	icon.size = Vector2(10, 10)
	icon.position = Vector2(2, 2)
	icon.color = Color(0.85, 0.2, 0.15, 0.9)
	icon.rotation = deg_to_rad(45)
	icon_container.add_child(icon)

	# Bar background
	var bar_group = Control.new()
	bar_group.custom_minimum_size = Vector2(HP_BAR_WIDTH + 4, HP_BAR_HEIGHT + 4)
	container.add_child(bar_group)

	var border = ColorRect.new()
	border.size = Vector2(HP_BAR_WIDTH + 4, HP_BAR_HEIGHT + 4)
	border.position = Vector2(-2, -2)
	border.color = COL_HP_BORDER
	bar_group.add_child(border)

	var bg = ColorRect.new()
	bg.size = Vector2(HP_BAR_WIDTH, HP_BAR_HEIGHT)
	bg.color = COL_HP_BG
	bar_group.add_child(bg)

	_hp_fill = ColorRect.new()
	_hp_fill.size = Vector2(HP_BAR_WIDTH, HP_BAR_HEIGHT)
	_hp_fill.color = COL_HP_FILL
	bar_group.add_child(_hp_fill)

	# HP text
	_hp_text = Label.new()
	_hp_text.add_theme_font_size_override("font_size", 11)
	_hp_text.add_theme_color_override("font_color", COL_TEXT_DIM)
	container.add_child(_hp_text)


func _build_posture_section() -> void:
	# Sits below HP bar, indented slightly
	var container = Control.new()
	container.position = Vector2(38, 28)
	_root.add_child(container)
	_posture_container = container
	
	var border = ColorRect.new()
	border.size = Vector2(POSTURE_BAR_WIDTH + 2, POSTURE_BAR_HEIGHT + 2)
	border.position = Vector2(-1, -1)
	border.color = Color(0.2, 0.17, 0.07, 0.7)
	container.add_child(border)

	var bg = ColorRect.new()
	bg.size = Vector2(POSTURE_BAR_WIDTH, POSTURE_BAR_HEIGHT)
	bg.color = COL_POSTURE_BG
	container.add_child(bg)

	_posture_fill = ColorRect.new()
	_posture_fill.size = Vector2(0, POSTURE_BAR_HEIGHT)
	_posture_fill.color = COL_POSTURE_FILL
	container.add_child(_posture_fill)


func _build_gold_section() -> void:
	# Top-right
	var container = HBoxContainer.new()
	container.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
	container.position = Vector2(-80, 14)
	container.add_theme_constant_override("separation", 6)
	_root.add_child(container)
	_gold_container = container

	# Coin icon
	var coin = ColorRect.new()
	coin.custom_minimum_size = Vector2(14, 14)
	coin.color = COL_GOLD
	coin.size = Vector2(14, 14)
	# Make it round-ish via a small trick — we just use a rect. For a real game
	# you'd swap this with a TextureRect. Works fine as placeholder.
	container.add_child(coin)

	_gold_label = Label.new()
	_gold_label.add_theme_font_size_override("font_size", 14)
	_gold_label.add_theme_color_override("font_color", COL_GOLD)
	container.add_child(_gold_label)


func _build_spirit_section() -> void:
	# Bottom-left
	var container = HBoxContainer.new()
	container.position = Vector2(16, -36)
	container.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	container.add_theme_constant_override("separation", int(SPIRIT_PIP_GAP))
	_root.add_child(container)

	# "SPIRIT" label
	var label = Label.new()
	label.text = "SPIRIT"
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color(COL_SPIRIT_FILLED, 0.6))
	container.add_child(label)

	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(4, 0)
	container.add_child(spacer)

	# Build 10 pips
	_spirit_pips.clear()
	for i in range(10):
		var pip = ColorRect.new()
		pip.custom_minimum_size = Vector2(SPIRIT_PIP_W, SPIRIT_PIP_H)
		pip.color = COL_SPIRIT_EMPTY
		container.add_child(pip)
		_spirit_pips.append(pip)

	# "+1" popup label (floats up on pickup)
	_spirit_pop_label = Label.new()
	_spirit_pop_label.text = "+1"
	_spirit_pop_label.add_theme_font_size_override("font_size", 13)
	_spirit_pop_label.add_theme_color_override("font_color", COL_SPIRIT_GLOW)
	_spirit_pop_label.position = Vector2(80, -20)
	_spirit_pop_label.modulate.a = 0.0
	container.add_child(_spirit_pop_label)


func _build_prosthetic_section() -> void:
	# Bottom-right
	var anchor = Control.new()
	anchor.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	anchor.position = Vector2(-68, -68)
	_root.add_child(anchor)

	# Icon background box
	var icon_bg = ColorRect.new()
	icon_bg.size = Vector2(PROSTHETIC_BOX_SIZE, PROSTHETIC_BOX_SIZE)
	icon_bg.color = COL_PANEL_BG
	anchor.add_child(icon_bg)

	var icon_border = ColorRect.new()
	icon_border.size = Vector2(PROSTHETIC_BOX_SIZE + 2, PROSTHETIC_BOX_SIZE + 2)
	icon_border.position = Vector2(-1, -1)
	icon_border.color = COL_BORDER
	icon_border.z_index = -1
	anchor.add_child(icon_border)

	# Prosthetic name/icon placeholder (text for now)
	_prosthetic_icon_label = Label.new()
	_prosthetic_icon_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_prosthetic_icon_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_prosthetic_icon_label.size = Vector2(PROSTHETIC_BOX_SIZE, PROSTHETIC_BOX_SIZE)
	_prosthetic_icon_label.add_theme_font_size_override("font_size", 10)
	_prosthetic_icon_label.add_theme_color_override("font_color", COL_TEXT)
	anchor.add_child(_prosthetic_icon_label)

	# Cooldown ring drawer (custom Control that draws arcs)
	_cooldown_drawer = _CooldownRing.new()
	_cooldown_drawer.position = Vector2(PROSTHETIC_BOX_SIZE * 0.5, PROSTHETIC_BOX_SIZE * 0.5)
	_cooldown_drawer.z_index = 5
	anchor.add_child(_cooldown_drawer)

	# Spirit cost badge (bottom-right of icon)
	var cost_bg = ColorRect.new()
	cost_bg.size = Vector2(18, 14)
	cost_bg.position = Vector2(PROSTHETIC_BOX_SIZE - 16, PROSTHETIC_BOX_SIZE - 12)
	cost_bg.color = Color(0.05, 0.08, 0.15, 0.9)
	cost_bg.z_index = 6
	anchor.add_child(cost_bg)

	_cost_label = Label.new()
	_cost_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_cost_label.size = Vector2(18, 14)
	_cost_label.position = cost_bg.position
	_cost_label.add_theme_font_size_override("font_size", 9)
	_cost_label.add_theme_color_override("font_color", COL_SPIRIT_FILLED)
	_cost_label.z_index = 7
	anchor.add_child(_cost_label)

	# Relic dots (top of icon)
	_relic_dot_container = HBoxContainer.new()
	_relic_dot_container.position = Vector2(PROSTHETIC_BOX_SIZE * 0.5 - 12, -8)
	_relic_dot_container.add_theme_constant_override("separation", 3)
	_relic_dot_container.z_index = 6
	anchor.add_child(_relic_dot_container)

	# Keybind hint
	var keybind = Label.new()
	keybind.text = "Q"
	keybind.add_theme_font_size_override("font_size", 8)
	keybind.add_theme_color_override("font_color", COL_TEXT_DIM)
	keybind.position = Vector2(PROSTHETIC_BOX_SIZE - 8, -10)
	anchor.add_child(keybind)

func _build_toast_section() -> void:
	# Toast container sits below the gold display, top-right
	_toast_container = VBoxContainer.new()
	_toast_container.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_toast_container.position = Vector2(-120, 36)
	_toast_container.add_theme_constant_override("separation", 4)
	_toast_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_root.add_child(_toast_container)
	
# =============================================================================
# SIGNAL CONNECTIONS
# =============================================================================

func _connect_signals() -> void:
	if _player == null:
		return

	# Prosthetic executor signals
	var executor = _player.get("prosthetic_executor")
	if executor:
		if executor.has_signal("spirit_changed"):
			executor.spirit_changed.connect(_on_spirit_changed)
		if executor.has_signal("prosthetic_used"):
			executor.prosthetic_used.connect(_on_prosthetic_used)

	# Currency
	if CurrencyManager.has_signal("currency_changed"):
		CurrencyManager.currency_changed.connect(_on_currency_changed)


# =============================================================================
# PUBLIC UPDATE API — call these from player.gd
# =============================================================================

func update_hp(current: int, maximum: int) -> void:
	_hp = current
	_max_hp = max(1, maximum)
	var pct = clampf(float(_hp) / float(_max_hp), 0.0, 1.0)
	_hp_fill.size.x = HP_BAR_WIDTH * pct
	_hp_text.text = "%d / %d" % [_hp, _max_hp]

	# Color shift when low
	if pct < 0.25:
		_hp_fill.color = COL_HP_LOW
	else:
		_hp_fill.color = COL_HP_FILL

func show_currency_toast(reward_key: String, amount: int) -> void:
	if _toast_container == null:
		return
	
	var toast_colors = {
		"gold": COL_GOLD,
		"mist": COL_MIST,
		"scroll": COL_SCROLL,
		"maxhp": COL_MAXHP,
		"maxposture": COL_MAXPOSTURE,
		"emblem": COL_EMBLEM,
	}
	var toast_labels = {
		"gold": "Gold",
		"mist": "Mist Shards",
		"scroll": "Scrolls",
		"maxhp": "Max HP",
		"maxposture": "Max Posture",
		"emblem": "Boss Emblems",
	}
	
	var color = toast_colors.get(reward_key, COL_TEXT)
	var label_text = toast_labels.get(reward_key, reward_key.capitalize())
	
	# Get the NEW total (after the reward was already added)
	var new_total = _get_currency_total(reward_key)
	var old_total = new_total - amount
	
	# Build toast row
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	row.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	var bg = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.06, 0.09, 0.85)
	style.border_color = Color(color.r, color.g, color.b, 0.4)
	style.set_border_width_all(1)
	style.set_corner_radius_all(3)
	style.content_margin_left = 8
	style.content_margin_right = 8
	style.content_margin_top = 4
	style.content_margin_bottom = 4
	bg.add_theme_stylebox_override("panel", style)
	row.add_child(bg)
	
	var inner = HBoxContainer.new()
	inner.add_theme_constant_override("separation", 6)
	bg.add_child(inner)
	
	# Icon dot
	var icon = ColorRect.new()
	icon.custom_minimum_size = Vector2(8, 8)
	icon.color = color
	inner.add_child(icon)
	
	# "+X" amount label
	var plus_label = Label.new()
	plus_label.text = "+%d" % amount
	plus_label.add_theme_font_size_override("font_size", 12)
	plus_label.add_theme_color_override("font_color", color)
	inner.add_child(plus_label)
	
	# Type name
	var name_label = Label.new()
	name_label.text = label_text
	name_label.add_theme_font_size_override("font_size", 10)
	name_label.add_theme_color_override("font_color", Color(color.r, color.g, color.b, 0.7))
	inner.add_child(name_label)
	
	# Spacer
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(8, 0)
	inner.add_child(spacer)
	
	# Total label (will count up from old to new)
	var total_label = Label.new()
	total_label.text = str(old_total)
	total_label.add_theme_font_size_override("font_size", 11)
	total_label.add_theme_color_override("font_color", Color(color.r, color.g, color.b, 0.9))
	total_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	total_label.custom_minimum_size = Vector2(28, 0)
	inner.add_child(total_label)
	
	_toast_container.add_child(row)
	
	# Animate: fade in, count up total, hold, fade out
	row.modulate.a = 0.0
	var tw = create_tween()
	tw.tween_property(row, "modulate:a", 1.0, 0.15)
	tw.tween_interval(0.2)
	
	# Count-up animation over 0.4s
	var count_steps = mini(amount, 15)  # Cap steps so large amounts don't take forever
	var step_delay = 0.4 / maxf(count_steps, 1)
	for i in range(count_steps):
		var display_val = int(lerpf(old_total, new_total, float(i + 1) / float(count_steps)))
		tw.tween_callback(func():
			if is_instance_valid(total_label):
				total_label.text = str(display_val)
		)
		tw.tween_interval(step_delay)
	
	# Ensure final value is exact
	tw.tween_callback(func():
		if is_instance_valid(total_label):
			total_label.text = str(new_total)
	)
	
	# Brief flash on the total when count finishes
	tw.tween_callback(func():
		if is_instance_valid(total_label):
			total_label.add_theme_color_override("font_color", Color.WHITE)
	)
	tw.tween_interval(0.15)
	tw.tween_callback(func():
		if is_instance_valid(total_label):
			total_label.add_theme_color_override("font_color", Color(color.r, color.g, color.b, 0.9))
	)
	
	# Hold then fade
	tw.tween_interval(1.8)
	tw.tween_property(row, "modulate:a", 0.0, 0.5)
	tw.tween_callback(func():
		if is_instance_valid(row):
			row.queue_free()
	)


func _get_currency_total(reward_key: String) -> int:
	var rd = get_node_or_null("/root/RunData")
	match reward_key:
		"gold":
			if rd:
				return rd.gold
			return CurrencyManager.get_amount(CurrencyManager.Currency.GOLD)
		"mist":
			if rd:
				return rd.mist_shards
			return CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
		"scroll":
			if rd:
				return rd.scrolls
			return CurrencyManager.get_amount(CurrencyManager.Currency.SCROLLS)
		"emblem":
			return CurrencyManager.get_amount(CurrencyManager.Currency.BOSS_EMBLEM)
		"maxhp":
			var players = get_tree().get_nodes_in_group("player")
			if players.size() > 0 and "maxhp" in players[0]:
				return players[0].maxhp
			return 0
		"maxposture":
			var players = get_tree().get_nodes_in_group("player")
			if players.size() > 0 and "stagger_max" in players[0]:
				return int(players[0].stagger_max)
			return 0
	return 0
	
func update_posture(current: float, maximum: float) -> void:
	_posture = current
	_posture_max = max(0.001, maximum)
	var pct = clampf(_posture / _posture_max, 0.0, 1.0)
	_posture_fill.size.x = POSTURE_BAR_WIDTH * pct

	# Color shift when high
	if pct > 0.75:
		_posture_fill.color = COL_POSTURE_HIGH
	else:
		_posture_fill.color = COL_POSTURE_FILL


func update_gold(amount: int) -> void:
	_gold = amount
	_gold_label.text = str(_gold)


func update_spirit(current: int, maximum: int) -> void:
	var old_spirit = _spirit
	_spirit = current
	_spirit_max = maximum

	for i in range(_spirit_pips.size()):
		var pip = _spirit_pips[i] as ColorRect
		if i < _spirit:
			pip.color = COL_SPIRIT_FILLED
		elif i < _spirit_max:
			pip.color = COL_SPIRIT_EMPTY
		else:
			pip.color = Color(COL_SPIRIT_EMPTY, 0.3)

	# "+1" pop on gain
	if current > old_spirit:
		_show_spirit_pop(current - old_spirit)


func update_cooldown(pct: float) -> void:
	_cooldown_pct = clampf(pct, 0.0, 1.0)
	if _cooldown_drawer:
		(_cooldown_drawer as _CooldownRing).ring_pct = _cooldown_pct
		_cooldown_drawer.queue_redraw()


func update_prosthetic_info(prosthetic_id: String, spirit_cost: int, sockets: int, filled: int) -> void:
	_prosthetic_id = prosthetic_id
	_spirit_cost = spirit_cost
	_relic_sockets = sockets
	_relic_filled = filled

	# Update icon text (swap for TextureRect when you have real art)
	var short_names = {
		"beast_whistle": "BEAST",
		"thunder_rod": "THDR",
		"smoke_gourd": "SMOKE",
		"fang_harpoon": "FANG",
		"mirror_umbrella": "UMBR",
		"flame_vent": "FLAME",
		"phantom_kunai": "KNAI",
		"mist_raven": "MIST",
		"bloodletting_gourd": "BLOOD",
	}
	_prosthetic_icon_label.text = short_names.get(prosthetic_id, prosthetic_id.substr(0, 5).to_upper())

	# Cost badge
	_cost_label.text = str(_spirit_cost)

	# Relic dots
	_refresh_relic_dots()


# =============================================================================
# INTERNAL
# =============================================================================

func _refresh_all() -> void:
	update_hp(_hp, _max_hp)
	update_posture(0.0, _posture_max)
	update_gold(CurrencyManager.get_amount(CurrencyManager.Currency.GOLD))
	update_spirit(_spirit, _spirit_max)

	# Pull prosthetic info
	if _player and _player.get("prosthetic_executor"):
		var executor = _player.prosthetic_executor
		_spirit = executor.get_spirit() if executor.has_method("get_spirit") else 10
		_spirit_max = executor.get_max_spirit() if executor.has_method("get_max_spirit") else 10
		update_spirit(_spirit, _spirit_max)

	# Pull equipped prosthetic data
	if ProstheticManager:
		var pid = ProstheticManager.equipped_prosthetic_id
		if pid != "":
			var data = ProstheticManager.get_prosthetic(pid)
			if data:
				var sockets = data.relic_sockets if "relic_sockets" in data else 0
				var socketed = ProstheticManager.get_socketed_relics(pid)
				var filled_count = 0
				for r in socketed:
					if r != "":
						filled_count += 1
				update_prosthetic_info(pid, data.spirit_cost, sockets, filled_count)


func _refresh_relic_dots() -> void:
	for child in _relic_dot_container.get_children():
		child.queue_free()

	for i in range(_relic_sockets):
		var dot = ColorRect.new()
		dot.custom_minimum_size = Vector2(5, 5)
		if i < _relic_filled:
			dot.color = COL_RELIC_FILLED
		else:
			dot.color = COL_RELIC_EMPTY
		_relic_dot_container.add_child(dot)


func _show_spirit_pop(amount: int) -> void:
	if _spirit_pop_label == null:
		return
	_spirit_pop_label.text = "+%d" % amount

	if _spirit_pop_tween and _spirit_pop_tween.is_valid():
		_spirit_pop_tween.kill()

	_spirit_pop_label.modulate.a = 1.0
	_spirit_pop_label.position.y = -20

	_spirit_pop_tween = create_tween().set_parallel(true)
	_spirit_pop_tween.tween_property(_spirit_pop_label, "position:y", -40.0, 0.8)
	_spirit_pop_tween.tween_property(_spirit_pop_label, "modulate:a", 0.0, 0.8).set_delay(0.3)


# ─── Signal handlers ───

func _on_spirit_changed(current: int, max_value: int) -> void:
	update_spirit(current, max_value)


func _on_prosthetic_used(prosthetic_id: String) -> void:
	# Trigger cooldown visual — actual timing is driven by player calling update_cooldown()
	pass


func _on_currency_changed(currency: int, new_amount: int) -> void:
	if currency == CurrencyManager.Currency.GOLD:
		update_gold(new_amount)

func set_hub_mode(enabled: bool) -> void:
	_is_hub_mode = enabled
	if _hp_container:
		_hp_container.visible = not enabled
	if _posture_container:
		_posture_container.visible = not enabled
	if _gold_container:
		_gold_container.visible = not enabled
		
# =============================================================================
# COOLDOWN RING — Inner class using _draw()
# =============================================================================

class _CooldownRing extends Control:
	var ring_pct: float = 0.0  # 0 = ready, 1 = full cooldown

	func _draw() -> void:
		var radius = 24.0
		var width = 2.5
		var segments = 48

		# Background ring (always visible, dim)
		draw_arc(Vector2.ZERO, radius, 0, TAU, segments,
			Color(0.35, 0.69, 0.87, 0.1), width, true)

		# Cooldown fill ring
		if ring_pct > 0.001:
			var sweep = TAU * ring_pct
			# Start from top (-PI/2), sweep clockwise
			draw_arc(Vector2.ZERO, radius, -PI * 0.5, -PI * 0.5 + sweep, segments,
				Color(0.35, 0.69, 0.87, 0.85), width, true)
