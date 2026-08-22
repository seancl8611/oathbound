extends "res://GUI/RunHUD.gd"

## Current run HUD overlay.
## - preserves the imported HUD layout
## - presents canonical 0-100 Prosthetic Spirit
## - adds the approved awakened-only Corruption / Shrine-ready state

var _corruption_root: Control
var _corruption_panel: PanelContainer
var _corruption_bar: ProgressBar
var _corruption_label: Label
var _corruption_detail: Label


func _ready() -> void:
	super._ready()
	_build_corruption_hud()
	_connect_corruption_runtime()
	_refresh_corruption_hud()


func update_spirit(current: int, maximum: int) -> void:
	var old_spirit: int = _spirit
	_spirit = maxi(0, current)
	_spirit_max = maxi(1, maximum)
	var segment_count: int = maxi(1, _spirit_pips.size())

	for index: int in range(_spirit_pips.size()):
		var pip := _spirit_pips[index] as ColorRect
		var threshold: float = float(index + 1) / float(segment_count)
		var filled: bool = float(_spirit) / float(_spirit_max) >= threshold - 0.0001
		pip.color = COL_SPIRIT_FILLED if filled else COL_SPIRIT_EMPTY

	if current > old_spirit:
		_show_spirit_pop(current - old_spirit)


func _build_corruption_hud() -> void:
	_corruption_root = Control.new()
	_corruption_root.name = "CorruptionHUD"
	_corruption_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_corruption_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_corruption_root)

	_corruption_panel = PanelContainer.new()
	_corruption_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_corruption_panel.offset_left = -254.0
	_corruption_panel.offset_top = 16.0
	_corruption_panel.offset_right = -16.0
	_corruption_panel.offset_bottom = 91.0
	_corruption_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.055, 0.035, 0.075, 0.90)
	style.border_color = Color(0.52, 0.20, 0.35, 0.75)
	style.set_border_width_all(1)
	style.set_corner_radius_all(5)
	style.set_content_margin_all(8)
	_corruption_panel.add_theme_stylebox_override("panel", style)
	_corruption_root.add_child(_corruption_panel)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 3)
	_corruption_panel.add_child(vbox)

	_corruption_label = Label.new()
	_corruption_label.add_theme_font_size_override("font_size", 13)
	vbox.add_child(_corruption_label)

	_corruption_bar = ProgressBar.new()
	_corruption_bar.min_value = 0.0
	_corruption_bar.max_value = 100.0
	_corruption_bar.show_percentage = false
	_corruption_bar.custom_minimum_size = Vector2(220, 9)
	vbox.add_child(_corruption_bar)

	_corruption_detail = Label.new()
	_corruption_detail.add_theme_font_size_override("font_size", 11)
	_corruption_detail.modulate = Color(0.78, 0.75, 0.84)
	vbox.add_child(_corruption_detail)


func _connect_corruption_runtime() -> void:
	var runtime := get_node_or_null("/root/CorruptionRuntime")
	if runtime != null:
		var corruption_cb := Callable(self, "_on_corruption_changed")
		if runtime.has_signal("corruption_changed") and not runtime.is_connected("corruption_changed", corruption_cb):
			runtime.connect("corruption_changed", corruption_cb)
		var awakening_cb := Callable(self, "_on_returning_blood_state_changed")
		if runtime.has_signal("returning_blood_state_changed") and not runtime.is_connected("returning_blood_state_changed", awakening_cb):
			runtime.connect("returning_blood_state_changed", awakening_cb)
	if typeof(AspectRuntime) == TYPE_OBJECT:
		var tier_cb := Callable(self, "_on_aspect_tier_changed")
		if AspectRuntime.has_signal("tier_changed") and not AspectRuntime.is_connected("tier_changed", tier_cb):
			AspectRuntime.connect("tier_changed", tier_cb)
		var aspect_cb := Callable(self, "_on_aspect_changed")
		if AspectRuntime.has_signal("aspect_changed") and not AspectRuntime.is_connected("aspect_changed", aspect_cb):
			AspectRuntime.connect("aspect_changed", aspect_cb)


func _on_corruption_changed(_current: int, _maximum: int, _state: String) -> void:
	_refresh_corruption_hud()


func _on_returning_blood_state_changed(_awakened: bool) -> void:
	_refresh_corruption_hud()


func _on_aspect_tier_changed(_tier: int) -> void:
	_refresh_corruption_hud()


func _on_aspect_changed(_aspect: String) -> void:
	_refresh_corruption_hud()


func _refresh_corruption_hud() -> void:
	if _corruption_panel == null:
		return
	var runtime := get_node_or_null("/root/CorruptionRuntime")
	if runtime == null or not runtime.has_method("is_awakened"):
		_corruption_panel.visible = false
		return
	var awakened: bool = bool(runtime.call("is_awakened"))
	_corruption_panel.visible = awakened
	if not awakened:
		return

	var current: int = int(runtime.call("get_corruption"))
	var state: String = str(runtime.call("get_corruption_state"))
	var aspect: String = str(AspectRuntime.selected_aspect).capitalize() if typeof(AspectRuntime) == TYPE_OBJECT else "Aspect"
	var tier: int = int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0
	_corruption_bar.value = current
	_corruption_label.text = "Corruption  %d / 100" % current
	if state == "full":
		_corruption_detail.text = "%s Tier %d  —  SHRINE READY" % [aspect, tier]
	elif state == "near-full":
		_corruption_detail.text = "%s Tier %d  —  Near full" % [aspect, tier]
	else:
		_corruption_detail.text = "%s Tier %d" % [aspect, tier]
