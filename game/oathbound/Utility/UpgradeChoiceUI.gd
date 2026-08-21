extends CanvasLayer

## Canonical three-card Technique reward UI.
## Keeps the legacy `choice_made` / `open_with_choices` API so existing chamber code
## can transition incrementally, while current callers should use `open_with_context`
## to preserve source-quality rules across whole-screen rerolls.

signal choice_made(choice: Dictionary)

const CARD_WIDTH := 190.0
const CARD_HEIGHT := 205.0

const FAMILY_COLORS := {
	"echo": Color(0.82, 0.84, 0.88),
	"rupture": Color(0.90, 0.72, 0.25),
	"seal": Color(0.58, 0.36, 0.82),
	"rift": Color(0.90, 0.87, 0.72),
	"crimson": Color(0.78, 0.20, 0.22),
	"cross": Color(0.68, 0.66, 0.74),
	"neutral": Color(0.70, 0.70, 0.70),
}

const FAMILY_NAMES := {
	"echo": "ECHO",
	"rupture": "RUPTURE",
	"seal": "SEAL",
	"rift": "RIFT",
	"crimson": "CRIMSON",
	"cross": "HYBRID",
	"neutral": "TECHNIQUE",
}

const RARITY_COLORS := {
	"common": Color(0.72, 0.72, 0.72),
	"uncommon": Color(0.42, 0.82, 0.48),
	"rare": Color(0.45, 0.62, 1.0),
	"legendary": Color(1.0, 0.82, 0.2),
	"refinement": Color(0.80, 0.62, 0.92),
}

var options: Array = []
var _source: String = ""
var _area_id: int = 1
var _focused_index: int = 0

var _overlay: ColorRect
var _root_container: VBoxContainer
var _title_label: Label
var _subtitle_label: Label
var _cards_container: HBoxContainer
var _cards: Array[Button] = []
var _reroll_button: Button


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	add_to_group("upgrade_ui")
	_build_ui()
	visible = false


func _build_ui() -> void:
	_overlay = ColorRect.new()
	_overlay.color = Color(0.0, 0.0, 0.0, 0.72)
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(_overlay)

	var center: CenterContainer = CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	_root_container = VBoxContainer.new()
	_root_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_root_container.add_theme_constant_override("separation", 12)
	center.add_child(_root_container)

	_title_label = Label.new()
	_title_label.text = "Choose a Technique"
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.add_theme_font_size_override("font_size", 20)
	_root_container.add_child(_title_label)

	_subtitle_label = Label.new()
	_subtitle_label.text = "Techniques are run-only and have no inventory or action-slot cap."
	_subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_subtitle_label.add_theme_font_size_override("font_size", 10)
	_root_container.add_child(_subtitle_label)

	_cards_container = HBoxContainer.new()
	_cards_container.alignment = BoxContainer.ALIGNMENT_CENTER
	_cards_container.add_theme_constant_override("separation", 12)
	_root_container.add_child(_cards_container)

	for index: int in range(3):
		var card: Button = Button.new()
		card.custom_minimum_size = Vector2(CARD_WIDTH, CARD_HEIGHT)
		card.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		card.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
		card.alignment = HORIZONTAL_ALIGNMENT_CENTER
		card.pressed.connect(_select_choice.bind(index))
		card.focus_entered.connect(_set_focus.bind(index))
		_cards_container.add_child(card)
		_cards.append(card)

	_reroll_button = Button.new()
	_reroll_button.custom_minimum_size = Vector2(180, 28)
	_reroll_button.pressed.connect(_on_reroll_pressed)
	_root_container.add_child(_reroll_button)


func open_with_choices(list: Array) -> void:
	_source = ""
	_area_id = 1
	_open(list)


func open_with_context(list: Array, source: String, area_id: int) -> void:
	_source = source
	_area_id = area_id
	_open(list)


func _open(list: Array) -> void:
	options = list.duplicate(true)
	_focused_index = 0
	_refresh_cards()
	_refresh_reroll()
	visible = true
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if not _cards.is_empty():
		_cards[0].grab_focus()
	print("[TechniqueRewardUI] opened — %d choices | source=%s" % [options.size(), _source if not _source.is_empty() else "legacy"])


func _refresh_cards() -> void:
	for index: int in range(_cards.size()):
		var card: Button = _cards[index]
		if index >= options.size():
			card.visible = false
			continue
		card.visible = true
		var data: Dictionary = options[index]
		var family: String = str(data.get("family", "neutral"))
		var family_label: String = str(FAMILY_NAMES.get(family, family.to_upper()))
		if family == "cross":
			var names: Array[String] = []
			var families_value: Variant = data.get("families", [])
			if families_value is Array:
				for family_name: Variant in families_value:
					names.append(str(family_name).capitalize())
			if not names.is_empty():
				family_label = " + ".join(names).to_upper()

		var rarity: String = str(data.get("rarity", "common")).to_lower()
		var rarity_label: String = rarity.capitalize()
		var kind_label: String = _kind_label(data)
		card.text = "%s\n%s\n\n%s\n\n%s\n%s" % [
			family_label,
			kind_label,
			str(data.get("displayname", "Technique")),
			str(data.get("details", "")),
			rarity_label,
		]

		var family_color: Color = FAMILY_COLORS.get(family, FAMILY_COLORS["neutral"])
		var rarity_color: Color = RARITY_COLORS.get(rarity, RARITY_COLORS["common"])
		card.add_theme_color_override("font_color", family_color)
		card.add_theme_color_override("font_focus_color", rarity_color)
		card.add_theme_color_override("font_hover_color", rarity_color)


func _kind_label(data: Dictionary) -> String:
	var kind: String = str(data.get("kind", ""))
	match kind:
		"action":
			var action: String = str(data.get("action", ""))
			match action:
				"basic": return "BASIC ATTACK"
				"held": return "HELD ATTACK"
				"dash": return "DASH ATTACK"
				"counter": return "PARRY / COUNTER"
				"deathblow": return "DEATHBLOW"
			return "ACTION TECHNIQUE"
		"support": return "SUPPORTING TECHNIQUE"
		"cross": return "CROSS-FAMILY TECHNIQUE"
		"legendary": return "LEGENDARY TECHNIQUE"
		"refinement": return "REFINEMENT"
		_: return "TECHNIQUE"


func _refresh_reroll() -> void:
	var count: int = 0
	if RunData != null:
		count = int(RunData.technique_rerolls)
	_reroll_button.text = "Reroll Entire Screen (%d)" % count
	_reroll_button.disabled = _source.is_empty() or count <= 0
	_reroll_button.visible = not _source.is_empty()


func _on_reroll_pressed() -> void:
	if _source.is_empty():
		return
	var rerolled: Array = UpgradeService.reroll_three_choices(_source, _area_id, options)
	if rerolled.is_empty():
		_refresh_reroll()
		return
	options = rerolled
	_focused_index = 0
	_refresh_cards()
	_refresh_reroll()
	if not _cards.is_empty():
		_cards[0].grab_focus()
	print("[TechniqueRewardUI] rerolled entire screen")


func _input(event: InputEvent) -> void:
	if not visible or not event.is_pressed():
		return
	if event.is_action_pressed("left"):
		_focused_index = maxi(0, _focused_index - 1)
		_cards[_focused_index].grab_focus()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("right"):
		_focused_index = mini(_cards.size() - 1, _focused_index + 1)
		_cards[_focused_index].grab_focus()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("interact"):
		_select_choice(_focused_index)
		get_viewport().set_input_as_handled()


func _set_focus(index: int) -> void:
	_focused_index = index


func _select_choice(index: int) -> void:
	if index < 0 or index >= options.size():
		return
	var choice: Dictionary = options[index]
	if str(choice.get("id", "")) == "technique_none":
		return
	visible = false
	get_tree().paused = false
	choice_made.emit(choice)
