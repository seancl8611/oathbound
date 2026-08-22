extends "res://GUI/ForgeMenu.gd"

## Current Forge overlay: keeps the imported Prosthetic Forge UI as compatibility
## presentation and adds the approved one-slot Relic collection/mastery management.

const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

var _relic_panel: PanelContainer
var _relic_list: VBoxContainer
var _relic_detail_name: Label
var _relic_detail_effect: Label
var _relic_detail_mastery: Label
var _relic_equip_button: Button
var _selected_relic_id: String = ""


func _ready() -> void:
	super._ready()
	_build_relic_management_overlay()
	print("[OathboundForgeMenu] v1.0 - Forge Relic collection/mastery management")


func _build_relic_management_overlay() -> void:
	var open_button := Button.new()
	open_button.name = "OpenRelicsButton"
	open_button.text = "Relics"
	open_button.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	open_button.position = Vector2(-105, 8)
	open_button.custom_minimum_size = Vector2(88, 28)
	open_button.z_index = 30
	open_button.pressed.connect(_open_relic_panel)
	add_child(open_button)

	_relic_panel = PanelContainer.new()
	_relic_panel.name = "CurrentRelicManagement"
	_relic_panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_relic_panel.offset_left = 36
	_relic_panel.offset_top = 28
	_relic_panel.offset_right = -36
	_relic_panel.offset_bottom = -28
	_relic_panel.z_index = 40
	_relic_panel.visible = false
	_relic_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.07, 0.065, 0.10, 0.985)
	style.border_color = Color(0.60, 0.47, 0.72, 1.0)
	style.set_border_width_all(2)
	style.set_corner_radius_all(6)
	style.set_content_margin_all(12)
	_relic_panel.add_theme_stylebox_override("panel", style)
	add_child(_relic_panel)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 8)
	_relic_panel.add_child(root)

	var header := HBoxContainer.new()
	root.add_child(header)
	var title := Label.new()
	title.text = "RELIC COLLECTION"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 16)
	header.add_child(title)
	var close_button := Button.new()
	close_button.text = "Close"
	close_button.pressed.connect(_close_relic_panel)
	header.add_child(close_button)

	var explanation := Label.new()
	explanation.text = "One Relic may be equipped. Only the equipped Relic gains mastery from eligible enemy kills."
	explanation.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	explanation.modulate = Color(0.72, 0.72, 0.78)
	root.add_child(explanation)

	var content := HBoxContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 10)
	root.add_child(content)

	var left_scroll := ScrollContainer.new()
	left_scroll.custom_minimum_size = Vector2(260, 0)
	left_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	content.add_child(left_scroll)
	_relic_list = VBoxContainer.new()
	_relic_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_relic_list.add_theme_constant_override("separation", 4)
	left_scroll.add_child(_relic_list)

	var details := VBoxContainer.new()
	details.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	details.add_theme_constant_override("separation", 8)
	content.add_child(details)

	_relic_detail_name = Label.new()
	_relic_detail_name.text = "Select an unlocked Relic"
	_relic_detail_name.add_theme_font_size_override("font_size", 16)
	details.add_child(_relic_detail_name)

	_relic_detail_effect = Label.new()
	_relic_detail_effect.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_relic_detail_effect.modulate = Color(0.80, 0.80, 0.85)
	details.add_child(_relic_detail_effect)

	_relic_detail_mastery = Label.new()
	_relic_detail_mastery.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_relic_detail_mastery.modulate = Color(0.68, 0.62, 0.80)
	details.add_child(_relic_detail_mastery)

	_relic_equip_button = Button.new()
	_relic_equip_button.text = "Equip Relic"
	_relic_equip_button.disabled = true
	_relic_equip_button.pressed.connect(_equip_selected_relic)
	details.add_child(_relic_equip_button)

	var unequip_button := Button.new()
	unequip_button.text = "Unequip Relic"
	unequip_button.pressed.connect(_unequip_relic)
	details.add_child(unequip_button)


func _open_relic_panel() -> void:
	_relic_panel.visible = true
	_refresh_relic_list()
	_refresh_relic_details()


func _close_relic_panel() -> void:
	_relic_panel.visible = false


func _refresh_relic_list() -> void:
	if _relic_list == null:
		return
	for child: Node in _relic_list.get_children():
		child.queue_free()
	var runtime := _relic_runtime()
	if runtime == null:
		var missing := Label.new()
		missing.text = "Relic runtime unavailable."
		_relic_list.add_child(missing)
		return
	var found: bool = false
	for relic_id: String in RELIC_CATALOG.IDS:
		if not bool(runtime.call("is_unlocked", relic_id)):
			continue
		found = true
		var data: Dictionary = RELIC_CATALOG.get_data(relic_id)
		var rank: int = int(runtime.call("get_mastery_rank", relic_id))
		var button := Button.new()
		button.text = "%s%s  —  %s" % [
			"◆ " if str(runtime.get("equipped_relic_id")) == relic_id else "",
			str(data.get("name", relic_id)),
			_mastery_label(rank),
		]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(_select_relic.bind(relic_id))
		_relic_list.add_child(button)
	if not found:
		var empty := Label.new()
		empty.text = "No Relics discovered yet.\nRelic discoveries persist immediately when earned."
		empty.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		empty.modulate = Color(0.65, 0.65, 0.70)
		_relic_list.add_child(empty)


func _select_relic(relic_id: String) -> void:
	_selected_relic_id = relic_id
	_refresh_relic_details()


func _refresh_relic_details() -> void:
	var runtime := _relic_runtime()
	if runtime == null or _selected_relic_id.is_empty() or not RELIC_CATALOG.has(_selected_relic_id):
		_relic_detail_name.text = "Select an unlocked Relic"
		_relic_detail_effect.text = ""
		_relic_detail_mastery.text = ""
		_relic_equip_button.disabled = true
		return
	var data: Dictionary = RELIC_CATALOG.get_data(_selected_relic_id)
	var rank: int = int(runtime.call("get_mastery_rank", _selected_relic_id))
	var kills: int = int(runtime.call("get_mastery_kills", _selected_relic_id))
	_relic_detail_name.text = str(data.get("name", _selected_relic_id))
	_relic_detail_effect.text = "%s\n\nRole: %s" % [str(data.get("approved", "")), str(data.get("role", ""))]
	_relic_detail_mastery.text = "%s | %d eligible kills\nMastery I: %d kills | Mastery II: %d kills\nCurrent first-playtest effect value: %s" % [
		_mastery_label(rank),
		kills,
		RELIC_CATALOG.MASTERY_I_KILLS,
		RELIC_CATALOG.MASTERY_II_KILLS,
		str(runtime.call("get_effective_value", _selected_relic_id)),
	]
	var equipped: bool = str(runtime.get("equipped_relic_id")) == _selected_relic_id
	_relic_equip_button.text = "Equipped" if equipped else "Equip Relic"
	_relic_equip_button.disabled = equipped


func _equip_selected_relic() -> void:
	var runtime := _relic_runtime()
	if runtime == null or _selected_relic_id.is_empty():
		return
	if bool(runtime.call("equip_relic", _selected_relic_id, "forge")):
		_refresh_relic_list()
		_refresh_relic_details()


func _unequip_relic() -> void:
	var runtime := _relic_runtime()
	if runtime == null:
		return
	runtime.call("equip_relic", "", "forge")
	_refresh_relic_list()
	_refresh_relic_details()


func _mastery_label(rank: int) -> String:
	match rank:
		1: return "Mastery I"
		2: return "Mastery II / Complete"
		_: return "Base"


func _relic_runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")
