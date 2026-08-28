extends RefCounted

## Shared launch-readability styling helper. High Contrast intentionally changes only
## presentation. It never changes combat rules, input timing, progression, or world state.

const HIGH_CONTRAST_TEXT: Color = Color(1.0, 1.0, 1.0, 1.0)
const HIGH_CONTRAST_DIM_TEXT: Color = Color(0.88, 0.88, 0.88, 1.0)
const HIGH_CONTRAST_BG: Color = Color(0.0, 0.0, 0.0, 0.96)
const HIGH_CONTRAST_BORDER: Color = Color(1.0, 1.0, 1.0, 1.0)


static func is_enabled() -> bool:
	return typeof(SettingsManager) == TYPE_OBJECT \
		and SettingsManager.has_method("is_high_contrast_enabled") \
		and bool(SettingsManager.is_high_contrast_enabled())


static func apply(root: Node) -> void:
	if root == null or not is_enabled():
		return
	_apply_recursive(root)


static func _apply_recursive(node: Node) -> void:
	_style_node(node)
	for child: Node in node.get_children():
		_apply_recursive(child)


static func _style_node(node: Node) -> void:
	if node is Label:
		var label: Label = node as Label
		label.modulate = HIGH_CONTRAST_TEXT
		label.add_theme_color_override("font_color", HIGH_CONTRAST_TEXT)
		return

	if node is RichTextLabel:
		var rich: RichTextLabel = node as RichTextLabel
		rich.modulate = HIGH_CONTRAST_TEXT
		rich.add_theme_color_override("default_color", HIGH_CONTRAST_TEXT)
		return

	if node is Button:
		_style_button(node as Button)
		return

	if node is PanelContainer:
		var panel: PanelContainer = node as PanelContainer
		var panel_style: StyleBoxFlat = StyleBoxFlat.new()
		panel_style.bg_color = HIGH_CONTRAST_BG
		panel_style.border_color = HIGH_CONTRAST_BORDER
		panel_style.set_border_width_all(2)
		panel_style.set_corner_radius_all(3)
		panel_style.set_content_margin_all(6)
		panel.add_theme_stylebox_override("panel", panel_style)
		return

	if node is ColorRect:
		var rect: ColorRect = node as ColorRect
		# Only replace large/opaque readability backplates. Tiny ColorRects are often
		# gameplay meters or icons whose fill/shape already carries semantic meaning.
		if rect.color.a >= 0.70 and (rect.size.x >= 120.0 or rect.size.y >= 80.0):
			rect.color = HIGH_CONTRAST_BG


static func _style_button(button: Button) -> void:
	button.add_theme_color_override("font_color", HIGH_CONTRAST_TEXT)
	button.add_theme_color_override("font_hover_color", Color.BLACK)
	button.add_theme_color_override("font_pressed_color", Color.BLACK)
	button.add_theme_color_override("font_focus_color", HIGH_CONTRAST_TEXT)
	button.add_theme_color_override("font_disabled_color", Color(0.68, 0.68, 0.68, 1.0))

	var normal: StyleBoxFlat = _button_style(Color.BLACK, Color.WHITE, 2)
	var focus: StyleBoxFlat = _button_style(Color.BLACK, Color.WHITE, 3)
	var active: StyleBoxFlat = _button_style(Color.WHITE, Color.WHITE, 2)
	button.add_theme_stylebox_override("normal", normal)
	button.add_theme_stylebox_override("focus", focus)
	button.add_theme_stylebox_override("hover", active)
	button.add_theme_stylebox_override("pressed", active)


static func _button_style(background: Color, border: Color, width: int) -> StyleBoxFlat:
	var style: StyleBoxFlat = StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(width)
	style.set_corner_radius_all(2)
	style.set_content_margin_all(5)
	return style
