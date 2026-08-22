extends CanvasLayer

## Generic approved Relic discovery presentation.
## Call present(relic_id) only after a content source has selected an eligible Relic.
## Discovery is persisted immediately; the player then chooses Equip Now or Keep Current.

signal discovery_finished(relic_id: String, equipped: bool)

const CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

var _relic_id: String = ""
var _was_paused: bool = false
var _finished: bool = false


func present(relic_id: String) -> bool:
	var runtime: Node = _runtime()
	if runtime == null or not CATALOG.has(relic_id):
		return false
	_relic_id = relic_id
	# RELICS.md: discovery is permanent immediately, even before the equip decision.
	runtime.call("discover_relic", relic_id, false)
	process_mode = Node.PROCESS_MODE_ALWAYS
	layer = 270
	_was_paused = get_tree().paused
	get_tree().paused = true
	_build_ui()
	return true


func _build_ui() -> void:
	var data: Dictionary = CATALOG.get_data(_relic_id)
	var backdrop := ColorRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.80)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(backdrop)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(430, 250)
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.075, 0.065, 0.105, 0.99)
	style.border_color = Color(0.68, 0.50, 0.78, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(7)
	style.set_content_margin_all(16)
	panel.add_theme_stylebox_override("panel", style)
	center.add_child(panel)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 10)
	panel.add_child(root)

	var header := Label.new()
	header.text = "Relic Discovered"
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 18)
	root.add_child(header)

	var name_label := Label.new()
	name_label.text = str(data.get("name", _relic_id))
	name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	name_label.add_theme_font_size_override("font_size", 22)
	root.add_child(name_label)

	var effect := Label.new()
	effect.text = str(data.get("approved", ""))
	effect.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	effect.modulate = Color(0.80, 0.80, 0.86)
	root.add_child(effect)

	var note := Label.new()
	note.text = "Added permanently to your Relic collection."
	note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	note.modulate = Color(0.62, 0.62, 0.70)
	root.add_child(note)

	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 12)
	root.add_child(buttons)

	var keep := Button.new()
	keep.text = "Keep Current"
	keep.pressed.connect(_finish.bind(false))
	buttons.add_child(keep)

	var equip := Button.new()
	equip.text = "Equip Now"
	equip.pressed.connect(_finish.bind(true))
	buttons.add_child(equip)


func _finish(equip_now: bool) -> void:
	if _finished:
		return
	_finished = true
	var runtime: Node = _runtime()
	if equip_now and runtime != null:
		runtime.call("equip_relic", _relic_id, "discovery")
	get_tree().paused = _was_paused
	discovery_finished.emit(_relic_id, equip_now)
	queue_free()


func _runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")
