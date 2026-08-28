extends CanvasLayer

## Non-blocking release presentation for canonical regional bosses. This layer never
## pauses gameplay or owns boss state; BossChamber triggers it after selecting the live
## boss and combat continues underneath the presentation.

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const DISPLAY_SECONDS: float = 3.0

const BOSS_PRESENTATION: Dictionary = {
	1: {
		"title_key": "boss.keeper.title",
		"title": "Keeper",
		"region_key": "region.hushiro.title",
		"region": "Hushiro Village",
	},
	2: {
		"title_key": "boss.twin_maws.title",
		"title": "Twin Maws",
		"region_key": "region.yomori.title",
		"region": "Hunting Grounds",
	},
	3: {
		"title_key": "boss.eclipse_shogun.title",
		"title": "Eclipse Shogun",
		"region_key": "region.kagutsuchi.title",
		"region": "Kagutsuchi Court",
	},
}

var auto_free_on_dismiss := true
var _panel: PanelContainer = null
var _region_label: Label = null
var _title_label: Label = null
var _rule: ColorRect = null
var _timer: Timer = null
var _current_area_id := 0


func _ready() -> void:
	layer = 110
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	_connect_settings()
	_apply_style()


func present(area_id: int) -> bool:
	var config_value: Variant = BOSS_PRESENTATION.get(area_id, {})
	if not (config_value is Dictionary) or (config_value as Dictionary).is_empty():
		push_warning("[BossTitleCard] No presentation contract for area %d" % area_id)
		return false
	var config: Dictionary = config_value as Dictionary
	_current_area_id = area_id
	_region_label.text = LOCALIZATION.resolve(
		str(config.get("region_key", "")),
		str(config.get("region", ""))
	).to_upper()
	_title_label.text = LOCALIZATION.resolve(
		str(config.get("title_key", "")),
		str(config.get("title", ""))
	)
	_apply_style()
	_panel.visible = true
	_timer.start(DISPLAY_SECONDS)
	print("[BossTitleCard] area=%d title=%s region=%s" % [area_id, _title_label.text, _region_label.text])
	return true


func _build_ui() -> void:
	_panel = PanelContainer.new()
	_panel.name = "BossTitleCard"
	_panel.visible = false
	_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_panel.anchor_left = 0.5
	_panel.anchor_right = 0.5
	_panel.anchor_top = 0.0
	_panel.anchor_bottom = 0.0
	add_child(_panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 11)
	margin.add_theme_constant_override("margin_bottom", 12)
	_panel.add_child(margin)

	var column := VBoxContainer.new()
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 4)
	margin.add_child(column)

	_region_label = Label.new()
	_region_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(_region_label)

	_title_label = Label.new()
	_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_title_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_title_label)

	_rule = ColorRect.new()
	_rule.custom_minimum_size = Vector2(210, 2)
	_rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	column.add_child(_rule)

	_timer = Timer.new()
	_timer.one_shot = true
	_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	_timer.timeout.connect(_dismiss)
	add_child(_timer)


func _connect_settings() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT or not SettingsManager.has_signal("settings_changed"):
		return
	var callback := Callable(self, "_on_settings_changed")
	if not SettingsManager.is_connected("settings_changed", callback):
		SettingsManager.connect("settings_changed", callback)


func _on_settings_changed() -> void:
	_apply_style()


func _apply_style() -> void:
	if _panel == null or _region_label == null or _title_label == null:
		return
	var ui_scale := 1.0
	var text_scale := 1.0
	if typeof(SettingsManager) == TYPE_OBJECT:
		if SettingsManager.has_method("get_ui_scale"):
			ui_scale = float(SettingsManager.get_ui_scale())
		if SettingsManager.has_method("get_text_scale"):
			text_scale = float(SettingsManager.get_text_scale())

	var width := 420.0 * ui_scale
	var top_margin := 34.0 * ui_scale
	_panel.offset_left = -width * 0.5
	_panel.offset_right = width * 0.5
	_panel.offset_top = top_margin
	_panel.offset_bottom = top_margin + (96.0 * ui_scale)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.035, 0.03, 0.04, 0.92)
	panel_style.border_color = Color(0.46, 0.12, 0.16, 0.95)
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(3)
	_panel.add_theme_stylebox_override("panel", panel_style)

	_region_label.add_theme_font_size_override("font_size", maxi(1, roundi(11.0 * text_scale)))
	_title_label.add_theme_font_size_override("font_size", maxi(1, roundi(25.0 * text_scale)))
	_region_label.add_theme_color_override("font_color", Color(0.76, 0.57, 0.58, 1.0))
	_title_label.add_theme_color_override("font_color", Color(0.96, 0.93, 0.88, 1.0))
	_rule.color = Color(0.52, 0.13, 0.17, 0.9)
	if READABILITY_STYLER.is_enabled():
		READABILITY_STYLER.apply(_panel)


func _dismiss() -> void:
	if _timer != null:
		_timer.stop()
	if _panel != null:
		_panel.visible = false
	_current_area_id = 0
	if auto_free_on_dismiss:
		queue_free()


func dismiss_for_playtest() -> void:
	_dismiss()


func get_current_content_for_playtest() -> Dictionary:
	return {
		"area_id": _current_area_id,
		"region": _region_label.text if _region_label != null else "",
		"title": _title_label.text if _title_label != null else "",
		"visible": _panel != null and _panel.visible,
	}


func get_title_font_size_for_playtest() -> int:
	return _title_label.get_theme_font_size("font_size") if _title_label != null else 0
