extends CanvasLayer

## Strand-only persistent progression display.
## Gold is run-only and is not a Strand currency. The always-visible Strand wallet is
## intentionally limited to Mist + Scrolls; regional boss materials stay contextual.

const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")

const COL_BG := Color(0.06, 0.06, 0.09, 0.85)
const COL_BORDER := Color(0.12, 0.12, 0.18, 1.0)
const COL_MIST := Color(0.66, 0.48, 0.87, 1.0)
const COL_SCROLL := Color(0.87, 0.78, 0.55, 1.0)

var _root: Control
var _mist_label: Label
var _scroll_label: Label


func _ready() -> void:
	layer = 50
	name = "HubHUD"
	add_to_group("game_hud")
	_build_ui()
	if MetaProgress != null and MetaProgress.has_signal("persistent_resources_changed"):
		MetaProgress.persistent_resources_changed.connect(_refresh_all)
	_refresh_all()
	call_deferred("_apply_readability")


func _build_ui() -> void:
	_root = Control.new()
	_root.name = "HubHUDRoot"
	_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	var panel := VBoxContainer.new()
	panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	panel.position = Vector2(-175, 12)
	panel.add_theme_constant_override("separation", 2)
	_root.add_child(panel)

	_mist_label = _make_resource_row(panel, "Mist", COL_MIST)
	_scroll_label = _make_resource_row(panel, "Scrolls", COL_SCROLL)


func _make_resource_row(parent: Control, resource_name: String, value_color: Color) -> Label:
	var bg := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = COL_BG
	style.border_color = COL_BORDER
	style.set_border_width_all(1)
	style.set_corner_radius_all(2)
	style.set_content_margin_all(4)
	bg.add_theme_stylebox_override("panel", style)
	parent.add_child(bg)

	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 6)
	bg.add_child(row)

	var name_label := Label.new()
	name_label.text = resource_name
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_font_size_override("font_size", 9)
	name_label.add_theme_color_override("font_color", value_color)
	row.add_child(name_label)

	var value_label := Label.new()
	value_label.custom_minimum_size = Vector2(28, 0)
	value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	value_label.add_theme_font_size_override("font_size", 9)
	value_label.add_theme_color_override("font_color", value_color)
	row.add_child(value_label)
	return value_label


func _refresh_all() -> void:
	if _mist_label == null:
		return
	_mist_label.text = str(MetaProgress.mist)
	_scroll_label.text = str(MetaProgress.scrolls)


func _apply_readability() -> void:
	if _root != null:
		READABILITY_STYLER.apply(_root)
