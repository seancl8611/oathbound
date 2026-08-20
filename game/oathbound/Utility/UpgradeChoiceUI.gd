extends CanvasLayer

## =============================================================================
## UPGRADE CHOICE UI — Polished Boon Selection Screen (Code-Built)
## =============================================================================
## No scene tree dependency — builds all UI through code.
## Delete any child nodes (Panel, VBoxContainer, Btn1-3) from the scene.
## =============================================================================

signal choice_made(choice: Dictionary)

var options: Array = []

# ─── References (created in code) ──────────────────────────
var _overlay: ColorRect
var _root_container: VBoxContainer
var _title_label: Label
var _cards_container: HBoxContainer
var _cards: Array = []      # Array of PanelContainer
var _focused_index: int = 0

# ─── Domain Colors ─────────────────────────────────────────
const DOMAIN_COLORS = {
	"storm":  Color(0.3, 0.72, 1.0),
	"frost":  Color(0.5, 0.82, 1.0),
	"hex":    Color(0.65, 0.32, 0.85),
	"ember":  Color(1.0, 0.52, 0.2),
	"shadow": Color(0.52, 0.32, 0.65),
	"item":   Color(0.9, 0.8, 0.35),
}

const DOMAIN_NAMES = {
	"storm": "Storm", "frost": "Frost", "hex": "Hex",
	"ember": "Ember", "shadow": "Shadow", "item": "Item",
}

# ─── Rarity Colors ─────────────────────────────────────────
const RARITY_COLORS = {
	"common":    Color(0.7, 0.7, 0.7),
	"uncommon":  Color(0.4, 0.85, 0.4),
	"rare":      Color(0.45, 0.6, 1.0),
	"legendary": Color(1.0, 0.82, 0.2),
}

const RARITY_NAMES = {
	"common": "Common", "uncommon": "Uncommon",
	"rare": "Rare", "legendary": "Legendary",
}

# ─── Card Sizing ───────────────────────────────────────────
const CARD_WIDTH = 180
const CARD_MIN_HEIGHT = 185
const CARD_SEPARATION = 12
const CARD_PADDING = 10

# ─── Style Colors ──────────────────────────────────────────
const BG_COLOR = Color(0.08, 0.07, 0.1, 0.92)
const CARD_BG_COLOR = Color(0.12, 0.11, 0.16, 0.95)
const CARD_HOVER_COLOR = Color(0.18, 0.16, 0.24, 0.97)
const CARD_BORDER_COLOR = Color(0.3, 0.28, 0.38, 0.6)
const OVERLAY_COLOR = Color(0.0, 0.0, 0.0, 0.6)
const TEXT_COLOR = Color(0.88, 0.86, 0.92)
const DETAIL_COLOR = Color(0.65, 0.62, 0.72)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_to_group("upgrade_ui")
	_build_ui()
	visible = false


func _build_ui() -> void:
	var vp_size = get_viewport().get_visible_rect().size

	# === DARK OVERLAY (manually sized to viewport) ===
	_overlay = ColorRect.new()
	_overlay.color = OVERLAY_COLOR
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	_overlay.position = Vector2.ZERO
	_overlay.size = vp_size
	_overlay.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_child(_overlay)

	# === ROOT CONTAINER (positioned manually at screen center) ===
	_root_container = VBoxContainer.new()
	_root_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_root_container.add_theme_constant_override("separation", 16)
	_root_container.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_child(_root_container)

	# === TITLE ===
	_title_label = Label.new()
	_title_label.text = "Choose a Boon"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 18)
	_title_label.add_theme_color_override("font_color", Color(0.9, 0.85, 0.7))
	_root_container.add_child(_title_label)

	# === CARDS CONTAINER ===
	_cards_container = HBoxContainer.new()
	_cards_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_cards_container.add_theme_constant_override("separation", CARD_SEPARATION)
	_root_container.add_child(_cards_container)

	# === BUILD 3 CARDS ===
	_cards.clear()
	for i in 3:
		var card = _build_card(i)
		_cards_container.add_child(card)
		_cards.append(card)

	_position_root()
	
func _build_card(index: int) -> PanelContainer:
	var card = PanelContainer.new()
	card.custom_minimum_size = Vector2(CARD_WIDTH, CARD_MIN_HEIGHT)
	card.mouse_filter = Control.MOUSE_FILTER_STOP
	card.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Base style
	var style = StyleBoxFlat.new()
	style.bg_color = CARD_BG_COLOR
	style.border_color = CARD_BORDER_COLOR
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(0)
	card.add_theme_stylebox_override("panel", style)

	# Inner layout
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 4)
	card.add_child(vbox)

	# --- Rarity color bar (top stripe) ---
	var rarity_bar = ColorRect.new()
	rarity_bar.name = "RarityBar"
	rarity_bar.custom_minimum_size = Vector2(0, 3)
	rarity_bar.color = RARITY_COLORS["common"]
	vbox.add_child(rarity_bar)

	# --- Content margin container ---
	var margin = MarginContainer.new()
	margin.add_theme_constant_override("margin_left", CARD_PADDING)
	margin.add_theme_constant_override("margin_right", CARD_PADDING)
	margin.add_theme_constant_override("margin_top", 6)
	margin.add_theme_constant_override("margin_bottom", CARD_PADDING)
	vbox.add_child(margin)

	var content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 6)
	margin.add_child(content)

	# --- Domain tag ---
	var domain_label = Label.new()
	domain_label.name = "DomainLabel"
	domain_label.add_theme_font_size_override("font_size", 10)
	domain_label.add_theme_color_override("font_color", DOMAIN_COLORS.get("storm", TEXT_COLOR))
	domain_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	content.add_child(domain_label)

	# --- Boon name ---
	var name_label = Label.new()
	name_label.name = "NameLabel"
	name_label.add_theme_font_size_override("font_size", 13)
	name_label.add_theme_color_override("font_color", TEXT_COLOR)
	name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	content.add_child(name_label)

	# --- Thin separator ---
	var sep = ColorRect.new()
	sep.custom_minimum_size = Vector2(0, 1)
	sep.color = Color(0.35, 0.32, 0.42, 0.5)
	content.add_child(sep)

	# --- Description ---
	var desc_label = Label.new()
	desc_label.name = "DescLabel"
	desc_label.add_theme_font_size_override("font_size", 10)
	desc_label.add_theme_color_override("font_color", DETAIL_COLOR)
	desc_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	desc_label.custom_minimum_size = Vector2(CARD_WIDTH - CARD_PADDING * 2 - 2, 0)
	content.add_child(desc_label)

	# --- Spacer to push rarity tag to bottom ---
	var spacer = Control.new()
	spacer.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_child(spacer)

	# --- Rarity label (bottom) ---
	var rarity_label = Label.new()
	rarity_label.name = "RarityLabel"
	rarity_label.add_theme_font_size_override("font_size", 9)
	rarity_label.add_theme_color_override("font_color", RARITY_COLORS["common"])
	rarity_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	content.add_child(rarity_label)

	# --- Hover / Click signals ---
	card.mouse_entered.connect(_on_card_hover.bind(index, true))
	card.mouse_exited.connect(_on_card_hover.bind(index, false))
	card.gui_input.connect(_on_card_input.bind(index))

	return card

func _position_root() -> void:
	# Wait one frame so the container knows its own size after children are added
	await get_tree().process_frame
	var vp_size = get_viewport().get_visible_rect().size
	var container_size = _root_container.size
	_root_container.position = (vp_size - container_size) * 0.5
	# Also resize overlay in case viewport changed
	_overlay.size = vp_size
	
# =============================================================================
# PUBLIC API
# =============================================================================

func open_with_choices(list: Array) -> void:
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	visible = true
	options = list
	_focused_index = 0

	for i in 3:
		if i < list.size():
			_populate_card(i, list[i])

	_update_focus_visuals()
	_position_root()
	print("[UpgradeChoiceUI] opened — tree paused, showing %d choices" % list.size())


func _populate_card(index: int, data: Dictionary) -> void:
	var card = _cards[index]
	var vbox = card.get_child(0)  # The outer VBoxContainer

	# Get the child nodes by name path
	var rarity_bar = vbox.get_node("RarityBar")
	var margin = vbox.get_child(1)
	var content = margin.get_child(0)
	var domain_label = content.get_node("DomainLabel")
	var name_label = content.get_node("NameLabel")
	var desc_label = content.get_node("DescLabel")
	var rarity_label = content.get_node("RarityLabel")

	var domain = data.get("domain", "item")
	var rarity = data.get("rarity", "common")
	var domain_color = DOMAIN_COLORS.get(domain, TEXT_COLOR)
	var rarity_color = RARITY_COLORS.get(rarity, RARITY_COLORS["common"])

	# Rarity bar color
	rarity_bar.color = rarity_color

	# Domain tag
	var domain_name = DOMAIN_NAMES.get(domain, domain.capitalize())
	domain_label.text = domain_name.to_upper()
	domain_label.add_theme_color_override("font_color", domain_color)

	# Boon name
	name_label.text = data.get("displayname", data.get("name", "???"))

	# Description
	desc_label.text = data.get("details", "")

	# Rarity tag
	var rarity_name = RARITY_NAMES.get(rarity, rarity.capitalize())
	rarity_label.text = rarity_name
	rarity_label.add_theme_color_override("font_color", rarity_color)

	# Border color matches domain
	var style = card.get_theme_stylebox("panel").duplicate()
	style.border_color = Color(domain_color.r, domain_color.g, domain_color.b, 0.35)
	card.add_theme_stylebox_override("panel", style)


# =============================================================================
# INPUT — Keyboard + Mouse
# =============================================================================

func _input(event: InputEvent) -> void:
	if not visible:
		return

	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_LEFT, KEY_A:
				_focused_index = max(0, _focused_index - 1)
				_update_focus_visuals()
				get_viewport().set_input_as_handled()
			KEY_RIGHT, KEY_D:
				_focused_index = min(2, _focused_index + 1)
				_update_focus_visuals()
				get_viewport().set_input_as_handled()
			KEY_ENTER, KEY_SPACE, KEY_E:
				_select_choice(_focused_index)
				get_viewport().set_input_as_handled()


func _on_card_hover(index: int, entering: bool) -> void:
	if entering:
		_focused_index = index
		_update_focus_visuals()


func _on_card_input(event: InputEvent, index: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_select_choice(index)


func _update_focus_visuals() -> void:
	for i in _cards.size():
		var card = _cards[i]
		var style = card.get_theme_stylebox("panel").duplicate()
		if i == _focused_index:
			style.bg_color = CARD_HOVER_COLOR
			style.set_border_width_all(2)
			# Brighten border for focused card
			var base_border = style.border_color
			style.border_color = Color(base_border.r, base_border.g, base_border.b, 0.85)
		else:
			style.bg_color = CARD_BG_COLOR
			style.set_border_width_all(1)
			var base_border = style.border_color
			style.border_color = Color(base_border.r, base_border.g, base_border.b, 0.35)
		card.add_theme_stylebox_override("panel", style)


# =============================================================================
# SELECTION
# =============================================================================

func _select_choice(index: int) -> void:
	if index < 0 or index >= options.size():
		return
	var choice = options[index]
	print("[UpgradeChoiceUI] selected: %s" % choice.get("displayname", "?"))
	visible = false
	get_tree().paused = false
	emit_signal("choice_made", choice)


func _on_Btn1_pressed() -> void: _select_choice(0)
func _on_Btn2_pressed() -> void: _select_choice(1)
func _on_Btn3_pressed() -> void: _select_choice(2)
