extends CanvasLayer

## Global player-facing achievement unlock presentation. AchievementRuntime remains the
## persistence/contract owner; this layer only consumes its signal and renders queued,
## localization-ready notifications that respect launch readability settings.

const Catalog = preload("res://Core/Presentation/OathboundPresentationCatalog.gd")
const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const TOAST_SECONDS: float = 4.5
const BASE_WIDTH: float = 332.0
const BASE_HEIGHT: float = 104.0

var _queue: Array[Dictionary] = []
var _showing := false
var _active_id: String = ""
var _toast: PanelContainer = null
var _kicker: Label = null
var _title: Label = null
var _description: Label = null
var _timer: Timer = null


func _ready() -> void:
	layer = 120
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_ui()
	_connect_runtime()
	_connect_settings()
	_apply_style()


func _connect_runtime() -> void:
	var runtime: Node = get_node_or_null("/root/AchievementRuntime")
	if runtime == null or not runtime.has_signal("achievement_unlocked"):
		push_error("[AchievementPresenter] AchievementRuntime signal unavailable")
		return
	var callback := Callable(self, "_on_achievement_unlocked")
	if not runtime.is_connected("achievement_unlocked", callback):
		runtime.connect("achievement_unlocked", callback)


func _connect_settings() -> void:
	if typeof(SettingsManager) != TYPE_OBJECT or not SettingsManager.has_signal("settings_changed"):
		return
	var callback := Callable(self, "_on_settings_changed")
	if not SettingsManager.is_connected("settings_changed", callback):
		SettingsManager.connect("settings_changed", callback)


func _build_ui() -> void:
	_toast = PanelContainer.new()
	_toast.name = "AchievementToast"
	_toast.visible = false
	_toast.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_toast.anchor_left = 1.0
	_toast.anchor_right = 1.0
	_toast.anchor_top = 0.0
	_toast.anchor_bottom = 0.0
	add_child(_toast)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	_toast.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 3)
	margin.add_child(column)

	_kicker = Label.new()
	_kicker.text = LOCALIZATION.ui("achievement_unlocked", "Achievement Unlocked").to_upper()
	column.add_child(_kicker)

	_title = Label.new()
	_title.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_title)

	_description = Label.new()
	_description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(_description)

	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = TOAST_SECONDS
	_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	_timer.timeout.connect(_dismiss_current)
	add_child(_timer)


func _on_achievement_unlocked(achievement_id: String) -> void:
	_queue_achievement(achievement_id)


func _queue_achievement(achievement_id: String) -> bool:
	var entry := _entry_for(achievement_id)
	if entry.is_empty():
		push_warning("[AchievementPresenter] Unknown achievement id: %s" % achievement_id)
		return false
	_queue.append(entry)
	if not _showing:
		_show_next()
	return true


func _show_next() -> void:
	if _queue.is_empty():
		_showing = false
		_active_id = ""
		if _toast != null:
			_toast.visible = false
		return

	var value: Variant = _queue.pop_front()
	if not (value is Dictionary):
		_show_next()
		return
	var entry: Dictionary = value as Dictionary
	_active_id = str(entry.get("id", ""))
	_title.text = _localized_entry_text(entry, "name", str(entry.get("name", _active_id)))
	_description.text = _localized_entry_text(entry, "description", str(entry.get("description", "")))
	_kicker.text = LOCALIZATION.ui("achievement_unlocked", "Achievement Unlocked").to_upper()
	_showing = true
	_apply_style()
	_toast.visible = true
	_timer.start()
	print("[AchievementPresenter] showing: %s" % _active_id)


func _dismiss_current() -> void:
	if _timer != null:
		_timer.stop()
	if _toast != null:
		_toast.visible = false
	_showing = false
	_active_id = ""
	if not _queue.is_empty():
		call_deferred("_show_next")


func _localized_entry_text(entry: Dictionary, suffix: String, fallback: String) -> String:
	var base_key: String = str(entry.get("loc_key", ""))
	if base_key.is_empty():
		return fallback
	return LOCALIZATION.resolve("%s.%s" % [base_key, suffix], fallback)


func _entry_for(achievement_id: String) -> Dictionary:
	for entry: Dictionary in Catalog.achievements():
		if str(entry.get("id", "")) == achievement_id:
			return entry.duplicate(true)
	return {}


func _on_settings_changed() -> void:
	_apply_style()


func _apply_style() -> void:
	if _toast == null or _kicker == null or _title == null or _description == null:
		return
	var ui_scale: float = 1.0
	var text_scale: float = 1.0
	if typeof(SettingsManager) == TYPE_OBJECT:
		if SettingsManager.has_method("get_ui_scale"):
			ui_scale = float(SettingsManager.get_ui_scale())
		if SettingsManager.has_method("get_text_scale"):
			text_scale = float(SettingsManager.get_text_scale())

	var right_margin := 24.0 * ui_scale
	var top_margin := 24.0 * ui_scale
	var width := BASE_WIDTH * ui_scale
	var height := BASE_HEIGHT * ui_scale
	_toast.offset_left = -(right_margin + width)
	_toast.offset_right = -right_margin
	_toast.offset_top = top_margin
	_toast.offset_bottom = top_margin + height

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.055, 0.05, 0.065, 0.96)
	panel_style.border_color = Color(0.58, 0.16, 0.22, 1.0)
	panel_style.set_border_width_all(2)
	panel_style.set_corner_radius_all(4)
	_toast.add_theme_stylebox_override("panel", panel_style)

	_kicker.add_theme_font_size_override("font_size", maxi(1, roundi(11.0 * text_scale)))
	_title.add_theme_font_size_override("font_size", maxi(1, roundi(18.0 * text_scale)))
	_description.add_theme_font_size_override("font_size", maxi(1, roundi(13.0 * text_scale)))
	_kicker.add_theme_color_override("font_color", Color(0.82, 0.56, 0.60, 1.0))
	_title.add_theme_color_override("font_color", Color(0.96, 0.93, 0.90, 1.0))
	_description.add_theme_color_override("font_color", Color(0.76, 0.74, 0.73, 1.0))
	if READABILITY_STYLER.is_enabled():
		READABILITY_STYLER.apply(_toast)


# Test-only presentation seam. It never touches AchievementRuntime or MetaProgress.
func present_for_playtest(achievement_id: String) -> bool:
	return _queue_achievement(achievement_id)


func reset_for_playtest() -> void:
	if _timer != null:
		_timer.stop()
	_queue.clear()
	_showing = false
	_active_id = ""
	if _toast != null:
		_toast.visible = false


func dismiss_current_for_playtest() -> void:
	_dismiss_current()


func get_current_achievement_id_for_playtest() -> String:
	return _active_id


func get_current_text_for_playtest() -> Dictionary:
	return {
		"kicker": _kicker.text if _kicker != null else "",
		"title": _title.text if _title != null else "",
		"description": _description.text if _description != null else "",
	}


func get_queue_size_for_playtest() -> int:
	return _queue.size()


func is_visible_for_playtest() -> bool:
	return _toast != null and _toast.visible


func get_title_font_size_for_playtest() -> int:
	return _title.get_theme_font_size("font_size") if _title != null else 0
