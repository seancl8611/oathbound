extends Node

@export var enabled: bool = true

const HUB_SCENE := "res://World/HubScene.tscn"
const RUN_SCENE := "res://Utility/RunScene.tscn"

# Minimal spawn registry (add more as you go)
var enemy_scenes: Dictionary = {
	"grunt": "res://Enemy/foot_soldier.tscn",
	"lostshade": "res://Enemy/lost_shades.tscn",
	"pilgrim": "res://Enemy/ashen_pilgrim.tscn",
	"husk": "res://Enemy/hollow_husk.tscn",
}

var _warp_area_dropdown: OptionButton
var _warp_room_dropdown: OptionButton

# Simple overlay refs
var _ui: CanvasLayer
var _enemy_dropdown: OptionButton
var _boon_line: LineEdit
var _target_dropdown: OptionButton
var _currency_dropdown: OptionButton
var _currency_amount: SpinBox
enum TargetMode { PLAYER, NEAREST_ENEMY }

func _ready() -> void:
	print("[DebugService] enabled=", enabled, " debug_build=", OS.is_debug_build())
	enabled = enabled and OS.is_debug_build()
	if not enabled:
		return
	call_deferred("_build_minimal_ui")
	
func _unhandled_input(event: InputEvent) -> void:
	if not enabled:
		return

	if event.is_action_pressed("dbg_to_hub"):
		to_hub()

	if event.is_action_pressed("dbg_restart_run"):
		restart_run()

	if event.is_action_pressed("dbg_toggle_debug_ui"):
		_ui.visible = not _ui.visible

# --------------------------
# Scene controls
# --------------------------
func to_hub() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(HUB_SCENE)

func restart_run() -> void:
	get_tree().paused = false
	# RunScene._ready() already resets RunData and starts GameFlow. :contentReference[oaicite:0]{index=0}
	get_tree().change_scene_to_file(RUN_SCENE)

# --------------------------
# Boons (RunData)
# --------------------------
func add_boon(id: String) -> void:
	var rd = get_node_or_null("/root/RunData")
	if rd and rd.has_method("record_upgrade"):
		rd.record_upgrade(id) # :contentReference[oaicite:1]{index=1}

func remove_boon(id: String) -> void:
	var rd = get_node_or_null("/root/RunData")
	if rd == null:
		return
	# Minimal removal without changing RunData.gd:
	if "acquired_upgrades" in rd:
		rd.acquired_upgrades.erase(id)

# --------------------------
# Spawn
# --------------------------
func spawn_enemy(enemy_id: String, where: Vector2) -> Node:
	if not enemy_scenes.has(enemy_id):
		push_warning("[DebugService] Unknown enemy id: %s" % enemy_id)
		return null

	var ps: PackedScene = load(enemy_scenes[enemy_id])
	if ps == null:
		push_warning("[DebugService] Could not load: %s" % enemy_scenes[enemy_id])
		return null

	var e = ps.instantiate()
	if e is Node2D:
		(e as Node2D).global_position = where

	# Ensure group (your systems rely on "enemy" group)
	if not e.is_in_group("enemy"):
		e.add_to_group("enemy")

	get_tree().current_scene.add_child(e)
	return e

func _get_player() -> Node2D:
	var p = get_tree().get_first_node_in_group("player")
	return p as Node2D

func _get_nearest_enemy(to_pos: Vector2, max_dist := 99999.0) -> Node2D:
	var best: Node2D = null
	var best_d := max_dist
	for n in get_tree().get_nodes_in_group("enemy"):
		if n is Node2D:
			var d = (n as Node2D).global_position.distance_to(to_pos)
			if d < best_d:
				best_d = d
				best = n
	return best

# --------------------------
# Minimal UI
# --------------------------
func _build_minimal_ui() -> void:
	_ui = CanvasLayer.new()
	_ui.layer = 200
	_ui.visible = false
	_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().root.add_child.call_deferred(_ui)

	var panel = PanelContainer.new()
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	panel.set_anchors_preset(Control.PRESET_TOP_LEFT)
	panel.position = Vector2(16, 16)
	panel.custom_minimum_size = Vector2(280, 0)
	_ui.add_child(panel)

	var scroll = ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(280, min(get_viewport().get_visible_rect().size.y - 40, 500))
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(scroll)

	var v = VBoxContainer.new()
	v.add_theme_constant_override("separation", 4)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(v)

	var title := Label.new()
	title.text = "DEBUG"
	v.add_child(title)

	# Target selector
	_target_dropdown = OptionButton.new()
	_target_dropdown.add_item("Player", TargetMode.PLAYER)
	_target_dropdown.add_item("Nearest Enemy", TargetMode.NEAREST_ENEMY)
	v.add_child(_target_dropdown)

	# Enemy dropdown
	_enemy_dropdown = OptionButton.new()
	for k in enemy_scenes.keys():
		_enemy_dropdown.add_item(str(k))
	v.add_child(_enemy_dropdown)

	var spawn_btn := Button.new()
	spawn_btn.text = "Spawn Enemy Near Player"
	spawn_btn.pressed.connect(func():
		var p := _get_player()
		if p == null:
			return
		var id := _enemy_dropdown.get_item_text(_enemy_dropdown.selected)
		spawn_enemy(id, p.global_position + Vector2(64, 0))
	)
	v.add_child(spawn_btn)

	# Boon input
	_boon_line = LineEdit.new()
	_boon_line.placeholder_text = "boon id (e.g. storm_shock_1)"
	v.add_child(_boon_line)

	var hb := HBoxContainer.new()
	v.add_child(hb)

	var add_btn := Button.new()
	add_btn.text = "Add Boon"
	add_btn.pressed.connect(func(): add_boon(_boon_line.text.strip_edges()))
	hb.add_child(add_btn)

	var rem_btn := Button.new()
	rem_btn.text = "Remove Boon"
	rem_btn.pressed.connect(func(): remove_boon(_boon_line.text.strip_edges()))
	hb.add_child(rem_btn)
	
		# --------------------------
	# Currency
	# --------------------------
	var cur_title := Label.new()
	cur_title.text = "Currency"
	v.add_child(cur_title)

	_currency_dropdown = OptionButton.new()
	_currency_dropdown.add_item("Gold", int(CurrencyManager.Currency.GOLD))
	_currency_dropdown.add_item("Mist Shards", int(CurrencyManager.Currency.MIST_SHARDS))
	_currency_dropdown.add_item("Boss Emblem", int(CurrencyManager.Currency.BOSS_EMBLEM))
	_currency_dropdown.add_item("Scrolls", int(CurrencyManager.Currency.SCROLLS))
	v.add_child(_currency_dropdown)

	_currency_amount = SpinBox.new()
	_currency_amount.min_value = -999999
	_currency_amount.max_value = 999999
	_currency_amount.step = 1
	_currency_amount.value = 100
	v.add_child(_currency_amount)

	var cur_hb := HBoxContainer.new()
	v.add_child(cur_hb)

	var add_cur_btn := Button.new()
	add_cur_btn.text = "Add Currency"
	add_cur_btn.pressed.connect(func():
		var cm := get_node_or_null("/root/CurrencyManager")
		if cm == null:
			push_warning("[DebugService] CurrencyManager not found at /root/CurrencyManager")
			return
		var currency_id := _currency_dropdown.get_item_id(_currency_dropdown.selected)
		cm.add(currency_id, int(_currency_amount.value))
	)
	cur_hb.add_child(add_cur_btn)

	var set_cur_btn := Button.new()
	set_cur_btn.text = "Set Currency"
	set_cur_btn.pressed.connect(func():
		var cm := get_node_or_null("/root/CurrencyManager")
		if cm == null:
			push_warning("[DebugService] CurrencyManager not found at /root/CurrencyManager")
			return
		var currency_id := _currency_dropdown.get_item_id(_currency_dropdown.selected)
		cm.set_amount(currency_id, int(_currency_amount.value))
	)
	cur_hb.add_child(set_cur_btn)
	# --------------------------
	# Room Warp
	# --------------------------
	var warp_title = Label.new()
	warp_title.text = "Room Warp"
	v.add_child(warp_title)

	var warp_hb1 = HBoxContainer.new()
	v.add_child(warp_hb1)

	var area_label = Label.new()
	area_label.text = "Area:"
	warp_hb1.add_child(area_label)

	_warp_area_dropdown = OptionButton.new()
	_warp_area_dropdown.add_item("Area 1", 1)
	_warp_area_dropdown.add_item("Area 2", 2)
	_warp_area_dropdown.add_item("Area 3", 3)
	warp_hb1.add_child(_warp_area_dropdown)

	var room_label = Label.new()
	room_label.text = "Room:"
	warp_hb1.add_child(room_label)

	_warp_room_dropdown = OptionButton.new()
	_warp_room_dropdown.add_item("combat")
	_warp_room_dropdown.add_item("shrine")
	_warp_room_dropdown.add_item("treasure")
	_warp_room_dropdown.add_item("rest")
	_warp_room_dropdown.add_item("shop")
	_warp_room_dropdown.add_item("boss")
	warp_hb1.add_child(_warp_room_dropdown)

	var warp_btn = Button.new()
	warp_btn.text = "Warp to Room"
	warp_btn.pressed.connect(func():
		var area_id = _warp_area_dropdown.get_item_id(_warp_area_dropdown.selected)
		var room_type = _warp_room_dropdown.get_item_text(_warp_room_dropdown.selected)
		var gf = get_node_or_null("/root/GameFlow")
		if gf and gf.has_method("debug_warp"):
			gf.debug_warp(area_id, room_type)
			_ui.visible = false
		else:
			push_warning("[DebugService] GameFlow not found or missing debug_warp")
	)
	v.add_child(warp_btn)
	
func _get_currency_manager() -> Node:
	return get_node_or_null("/root/CurrencyManager")
