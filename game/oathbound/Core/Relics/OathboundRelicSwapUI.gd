extends CanvasLayer

## Safe-transition Relic equipment screen used after Keeper and Twin Maws.
## Only already-unlocked Relics appear; this screen never discovers content.

signal selection_finished

const CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

var _context: String = ""
var _was_paused: bool = false
var _closed: bool = false


func present(context: String) -> void:
	_context = context
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 260
	_was_paused = get_tree().paused
	get_tree().paused = true
	_build_ui()


func _build_ui() -> void:
	var backdrop := ColorRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.76)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(480, 300)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.06, 0.10, 0.98)
	style.border_color = Color(0.62, 0.48, 0.76, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(7)
	style.set_content_margin_all(14)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	panel.add_child(root)

	var title := Label.new()
	title.text = "Safe Relic Swap"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 20)
	root.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "Keep your current Relic or equip another unlocked Relic before the next region."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.modulate = Color(0.72, 0.72, 0.78)
	root.add_child(subtitle)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(450, 185)
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	root.add_child(scroll)

	var list := VBoxContainer.new()
	list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	list.add_theme_constant_override("separation", 4)
	scroll.add_child(list)

	var runtime: Node = _runtime()
	var current: String = str(runtime.get("equipped_relic_id")) if runtime != null else ""
	if runtime != null:
		for relic_id: String in CATALOG.IDS:
			if not bool(runtime.call("is_unlocked", relic_id)):
				continue
			var data: Dictionary = CATALOG.get_data(relic_id)
			var rank: int = int(runtime.call("get_mastery_rank", relic_id))
			var button := Button.new()
			button.text = "%s%s — %s" % [
				"◆ " if current == relic_id else "",
				str(data.get("name", relic_id)),
				_mastery_label(rank),
			]
			button.alignment = HORIZONTAL_ALIGNMENT_LEFT
			button.pressed.connect(_select_relic.bind(relic_id))
			list.add_child(button)

	var keep := Button.new()
	keep.text = "Keep Current Relic"
	keep.pressed.connect(_finish)
	root.add_child(keep)


func _select_relic(relic_id: String) -> void:
	var runtime: Node = _runtime()
	if runtime != null and runtime.has_method("equip_relic"):
		runtime.call("equip_relic", relic_id, _context)
	_finish()


func _finish() -> void:
	if _closed:
		return
	_closed = true
	get_tree().paused = _was_paused
	selection_finished.emit()
	queue_free()


func _mastery_label(rank: int) -> String:
	match rank:
		1: return "Mastery I"
		2: return "Mastery II"
		_: return "Base"


func _runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")
