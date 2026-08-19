extends RoomBase
# ShrineRoom.gd — Heal or Feed the Prayer Flame

@export var interact_action: String = "interact"
@export var heal_fraction: float = 0.30  # 30% of max HP

@onready var pedestal: Area2D = $InteractShrine
@onready var prompt: Label = $InteractShrine/Prompt

var _player_inside: bool = false
var _resolved: bool = false

var _ui_layer: CanvasLayer
var _panel: PanelContainer
var _heal_btn: Button
var _feed_btn: Button
var _heal_label: Label
var _feed_label: Label
var _progress_bar: ProgressBar
var _tier_label: Label
var _milestone_label: Label
var _backdrop: ColorRect

func _ready() -> void:
	lock_all_gates()
	pedestal.body_entered.connect(_on_pedestal_entered)
	pedestal.body_exited.connect(_on_pedestal_exited)
	_build_ui()

func _physics_process(_delta: float) -> void:
	if _resolved:
		return
	if _player_inside and not _panel.visible and Input.is_action_just_pressed(interact_action):
		_open_menu()
		
# =============================================================================
# UI CONSTRUCTION (code-only, no .tscn dependency)
# =============================================================================

func _build_ui() -> void:
	_ui_layer = CanvasLayer.new()
	_ui_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	_ui_layer.layer = 100
	add_child(_ui_layer)

	# Full-screen anchor wrapper (explicit anchors for CanvasLayer compatibility)
	var anchor = Control.new()
	anchor.set_anchors_preset(Control.PRESET_FULL_RECT)
	anchor.anchor_left = 0.0
	anchor.anchor_top = 0.0
	anchor.anchor_right = 1.0
	anchor.anchor_bottom = 1.0
	anchor.offset_left = 0
	anchor.offset_top = 0
	anchor.offset_right = 0
	anchor.offset_bottom = 0
	anchor.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_ui_layer.add_child(anchor)

	# Dimmed backdrop when menu is open
	_backdrop = ColorRect.new()
	_backdrop.name = "Backdrop"
	_backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	_backdrop.color = Color(0.0, 0.0, 0.0, 0.55)
	_backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_backdrop.visible = false
	anchor.add_child(_backdrop)

	# Center container
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	center.mouse_filter = Control.MOUSE_FILTER_IGNORE
	anchor.add_child(center)

	# --- Styled panel ---
	_panel = PanelContainer.new()
	_panel.custom_minimum_size = Vector2(340, 0)
	_panel.visible = false

	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = Color(0.08, 0.07, 0.1, 0.94)
	panel_style.border_color = Color(0.9, 0.45, 0.15, 0.7)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(6)
	panel_style.shadow_color = Color(0.0, 0.0, 0.0, 0.5)
	panel_style.shadow_size = 8
	panel_style.set_content_margin_all(0)
	_panel.add_theme_stylebox_override("panel", panel_style)
	center.add_child(_panel)

	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 20)
	margin.add_theme_constant_override("margin_right", 20)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	_panel.add_child(margin)

	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	margin.add_child(vbox)

	# --- Title: Flame tier name ---
	_tier_label = Label.new()
	_tier_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_tier_label.add_theme_font_size_override("font_size", 20)
	vbox.add_child(_tier_label)

	# Decorative separator
	var sep1 = HSeparator.new()
	var sep_style1 = StyleBoxFlat.new()
	sep_style1.bg_color = Color(0.9, 0.45, 0.15, 0.4)
	sep_style1.set_content_margin_all(0)
	sep_style1.content_margin_top = 1
	sep_style1.content_margin_bottom = 1
	sep1.add_theme_stylebox_override("separator", sep_style1)
	vbox.add_child(sep1)

	# Spacer
	var spacer1 = Control.new()
	spacer1.custom_minimum_size = Vector2(0, 4)
	vbox.add_child(spacer1)

	# --- HEAL OPTION ---
	var heal_box = _build_option_box()
	vbox.add_child(heal_box)

	_heal_label = Label.new()
	_heal_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_heal_label.add_theme_font_size_override("font_size", 13)
	_heal_label.add_theme_color_override("font_color", Color(0.65, 0.85, 0.65))
	heal_box.add_child(_heal_label)

	_heal_btn = _build_styled_button("Receive Power", Color(0.2, 0.55, 0.25))
	_heal_btn.pressed.connect(_on_heal_selected)
	heal_box.add_child(_heal_btn)

	# Spacer between options
	var spacer2 = Control.new()
	spacer2.custom_minimum_size = Vector2(0, 4)
	vbox.add_child(spacer2)

	# --- FEED OPTION ---
	var feed_box = _build_option_box()
	vbox.add_child(feed_box)

	_feed_label = Label.new()
	_feed_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_feed_label.add_theme_font_size_override("font_size", 13)
	_feed_label.add_theme_color_override("font_color", Color(1.0, 0.75, 0.4))
	feed_box.add_child(_feed_label)

	_feed_btn = _build_styled_button("Tend the Flame", Color(0.7, 0.35, 0.1))
	_feed_btn.pressed.connect(_on_feed_selected)
	feed_box.add_child(_feed_btn)

	# Bottom separator
	var sep2 = HSeparator.new()
	sep2.add_theme_stylebox_override("separator", sep_style1)
	vbox.add_child(sep2)

	# --- Progress section ---
	_milestone_label = Label.new()
	_milestone_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_milestone_label.add_theme_font_size_override("font_size", 12)
	_milestone_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.75))
	vbox.add_child(_milestone_label)

	# Styled progress bar
	_progress_bar = ProgressBar.new()
	_progress_bar.custom_minimum_size = Vector2(0, 10)
	_progress_bar.show_percentage = false

	var bar_bg = StyleBoxFlat.new()
	bar_bg.bg_color = Color(0.15, 0.13, 0.18)
	bar_bg.set_corner_radius_all(4)
	bar_bg.set_border_width_all(1)
	bar_bg.border_color = Color(0.3, 0.28, 0.35)
	_progress_bar.add_theme_stylebox_override("background", bar_bg)

	var bar_fill = StyleBoxFlat.new()
	bar_fill.bg_color = Color(0.9, 0.45, 0.15)
	bar_fill.set_corner_radius_all(4)
	_progress_bar.add_theme_stylebox_override("fill", bar_fill)

	vbox.add_child(_progress_bar)


func _build_option_box() -> VBoxContainer:
	var box = VBoxContainer.new()
	box.add_theme_constant_override("separation", 4)

	var bg = PanelContainer.new()
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.11, 0.15, 0.6)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(8)
	bg.add_theme_stylebox_override("panel", style)

	# Wrap: bg holds the vbox, return the inner vbox for adding children
	# Actually simpler: just style the VBox itself with a panel behind it
	# Use a PanelContainer wrapping a VBox
	var inner = VBoxContainer.new()
	inner.add_theme_constant_override("separation", 4)
	bg.add_child(inner)

	# Return a container that holds the styled panel
	# We need to return something addable that contains bg
	# Cleanest: return bg, and caller adds children to bg's inner vbox
	# But caller expects VBoxContainer... let's just return inner and add bg to vbox
	# Actually, rethink: just return the PanelContainer, add labels/buttons to inner
	# We'll store inner ref differently

	# Simplest: skip the wrapper, style the VBoxContainer area via a parent PanelContainer
	return box


func _build_styled_button(text: String, base_color: Color) -> Button:
	var btn = Button.new()
	btn.text = text
	btn.custom_minimum_size = Vector2(0, 36)

	var normal = StyleBoxFlat.new()
	normal.bg_color = base_color
	normal.set_corner_radius_all(4)
	normal.set_content_margin_all(8)
	btn.add_theme_stylebox_override("normal", normal)

	var hover = StyleBoxFlat.new()
	hover.bg_color = base_color.lightened(0.2)
	hover.set_corner_radius_all(4)
	hover.set_content_margin_all(8)
	hover.border_color = Color(1.0, 1.0, 1.0, 0.3)
	hover.set_border_width_all(1)
	btn.add_theme_stylebox_override("hover", hover)

	var pressed = StyleBoxFlat.new()
	pressed.bg_color = base_color.darkened(0.15)
	pressed.set_corner_radius_all(4)
	pressed.set_content_margin_all(8)
	btn.add_theme_stylebox_override("pressed", pressed)

	var focus = StyleBoxFlat.new()
	focus.bg_color = base_color.lightened(0.15)
	focus.set_corner_radius_all(4)
	focus.set_content_margin_all(8)
	focus.border_color = Color(1.0, 0.85, 0.5, 0.6)
	focus.set_border_width_all(2)
	btn.add_theme_stylebox_override("focus", focus)

	btn.add_theme_color_override("font_color", Color(0.95, 0.92, 0.88))
	btn.add_theme_color_override("font_hover_color", Color.WHITE)
	btn.add_theme_font_size_override("font_size", 15)

	return btn
	
# =============================================================================
# MENU LOGIC
# =============================================================================

func _open_menu() -> void:
	if _resolved:
		return

	var player = _get_player()
	if player == null:
		return

	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	_refresh_ui(player)
	_backdrop.visible = true
	_panel.visible = true
	_heal_btn.grab_focus()
	
func _close_menu() -> void:
	_panel.visible = false
	_backdrop.visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_INHERIT
	
func _refresh_ui(player: Node) -> void:
	var heal_amount = _calc_heal(player)
	var cinder_gain = _calc_cinder(player, heal_amount)
	var bonus_active = _is_ahead(player)

	# Tier title
	var tier_color = FlameProgress.get_tier_color()
	_tier_label.text = FlameProgress.get_tier_name()
	_tier_label.add_theme_color_override("font_color", tier_color)

	# Update panel border to match flame tier
	var panel_style = _panel.get_theme_stylebox("panel") as StyleBoxFlat
	if panel_style:
		panel_style.border_color = Color(tier_color, 0.7)

	# Update progress bar fill color to match tier
	var bar_fill = _progress_bar.get_theme_stylebox("fill") as StyleBoxFlat
	if bar_fill:
		bar_fill.bg_color = tier_color

	# Heal description
	var missing_hp = 0
	if "hp" in player and "maxhp" in player:
		missing_hp = player.maxhp - player.hp
	var heal_display = min(heal_amount, missing_hp)
	_heal_label.text = "Restore %d HP  (%d%% of max)" % [heal_amount, int(heal_fraction * 100)]

	# Feed description
	if bonus_active:
		_feed_label.text = "Skip heal  →  +%d Cinder  (+25%% Ahead)" % cinder_gain
	else:
		_feed_label.text = "Skip heal  →  +%d Cinder" % cinder_gain

	# Progress
	if FlameProgress.is_max_tier():
		_milestone_label.text = "Prayer Flame Complete  (%d Cinder)" % FlameProgress.cinder_total
		_progress_bar.value = 100.0
	else:
		var next_t = FlameProgress.get_next_threshold()
		var next_name = FlameProgress.TIER_NAMES[FlameProgress.flame_tier + 1]
		_milestone_label.text = "Cinder: %d / %d  →  %s" % [FlameProgress.cinder_total, next_t, next_name]
		_progress_bar.value = FlameProgress.get_cinder_toward_next() * 100.0

	if FlameProgress.trial_pending:
		_milestone_label.text += "   ⚔ Trial Available"
		_milestone_label.add_theme_color_override("font_color", Color(1.0, 0.85, 0.4))
	else:
		_milestone_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.75))
		
# =============================================================================
# CALCULATIONS
# =============================================================================

func _calc_heal(player: Node) -> int:
	if not ("maxhp" in player):
		return 0
	return int(round(player.maxhp * heal_fraction))


func _calc_cinder(player: Node, heal_amount: int) -> int:
	var base = heal_amount
	if _is_ahead(player):
		base = int(base * 1.25)
	return base


func _is_ahead(player: Node) -> bool:
	if not ("hp" in player and "maxhp" in player):
		return false
	return player.hp >= int(player.maxhp * 0.9)


# =============================================================================
# CHOICE HANDLERS
# =============================================================================

func _on_heal_selected() -> void:
	var player = _get_player()
	if player == null:
		_resolve()
		return

	var heal_amount = _calc_heal(player)
	if "hp" in player and "maxhp" in player:
		player.hp = min(player.maxhp, player.hp + heal_amount)
		if player.has_method("_update_health_bar"):
			player._update_health_bar()

	print("[Shrine] Healed for %d HP" % heal_amount)
	_resolve()


func _on_feed_selected() -> void:
	var player = _get_player()
	var heal_amount = _calc_heal(player) if player else 0
	var cinder_gain = _calc_cinder(player, heal_amount) if player else 0

	FlameProgress.add_cinder(cinder_gain)
	print("[Shrine] Fed the flame: +%d Cinder (total: %d)" % [cinder_gain, FlameProgress.cinder_total])
	_resolve()

func _resolve() -> void:
	_resolved = true
	_close_menu()
	prompt.visible = false
	# Disable pedestal so it stops detecting the player
	var col = pedestal.get_node_or_null("CollisionShape2D")
	if col:
		col.set_deferred("disabled", true)
	unlock_all_gates()
	
# =============================================================================
# PEDESTAL INTERACTION
# =============================================================================

func _on_pedestal_entered(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = true
		prompt.visible = true


func _on_pedestal_exited(body: Node) -> void:
	if body.is_in_group("player"):
		_player_inside = false
		prompt.visible = false
	if not _resolved:
		_close_menu()


func _get_player() -> Node:
	return get_tree().get_first_node_in_group("player")

func _unhandled_input(event: InputEvent) -> void:
	if not _panel.visible:
		return
	if event.is_action_pressed("ui_cancel"):
		_close_menu()
		get_viewport().set_input_as_handled()
