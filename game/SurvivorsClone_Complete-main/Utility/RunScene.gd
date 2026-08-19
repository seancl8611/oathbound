# RunScene.gd
# Main scene for active runs - handles choice UI and initialization
extends Node2D

# Choice UI (created dynamically)
var _choice_panel: Control = null
# Debug area warp is opt-in. Normal playtests must begin in Area 1 / Hushiro.
@export var debug_start_area: int = 0  # 0 = normal, 2 = skip to area 2, etc.

func _ready() -> void:
	get_tree().paused = false
	print("[RunScene] _ready() — paused=%s container=%s" % [get_tree().paused, $RoomContainer])

	GameFlow.setup($RoomContainer)

	# There is one canonical Player scene. It directly uses OathboundPlayer.gd.
	var player_scene = "res://Player/player.tscn"
	if ResourceLoader.exists(player_scene):
		var packed: PackedScene = load(player_scene)
		var p = packed.instantiate()
		GameFlow.set_player(p)

	# Connect signals
	if not GameFlow.is_connected("room_changed", Callable(self, "_on_room_changed")):
		GameFlow.connect("room_changed", Callable(self, "_on_room_changed"))
	if not GameFlow.is_connected("choice_presented", Callable(self, "_on_choice_presented")):
		GameFlow.connect("choice_presented", Callable(self, "_on_choice_presented"))
	if not GameFlow.is_connected("run_completed", Callable(self, "_on_run_completed")):
		GameFlow.connect("run_completed", Callable(self, "_on_run_completed"))

	# Create choice UI
	_create_choice_ui()

	# Debug: set debug_start_area in editor to skip to that area (0 = normal)
	if debug_start_area >= 2:
		GameFlow.current_area = debug_start_area
		RunData.reset_for_new_run(debug_start_area)
		GameFlow.route = RouteGenerator.generate_area_route(debug_start_area)
		GameFlow.current_index = 0
	else:
		RunData.reset_for_new_run(1)
		GameFlow.build_area1_route()

	print("[RunScene] starting run… area=%d" % GameFlow.current_area)
	GameFlow.start_run()
	
func _on_room_changed(room_name: String) -> void:
	print("[RunScene] room_changed => ", room_name)

func _on_choice_presented(options: Array, slot_index: int) -> void:
	print("[RunScene] Choice presented at slot %d: %s" % [slot_index, options])
	_show_choice_ui(options)

func _on_run_completed(area_id: int) -> void:
	print("[RunScene] ★ Area %d complete!" % area_id)

# ============================================================================
# CHOICE UI
# ============================================================================

func _create_choice_ui() -> void:
	# Create CanvasLayer for UI
	var canvas = CanvasLayer.new()
	canvas.name = "ChoiceLayer"
	canvas.layer = 100
	canvas.process_mode = Node.PROCESS_MODE_ALWAYS  # Works even when paused
	add_child(canvas)
	
	# Create panel
	_choice_panel = PanelContainer.new()
	_choice_panel.name = "ChoicePanel"
	_choice_panel.visible = false
	_choice_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Center it
	_choice_panel.set_anchors_preset(Control.PRESET_CENTER)
	_choice_panel.grow_horizontal = Control.GROW_DIRECTION_BOTH
	_choice_panel.grow_vertical = Control.GROW_DIRECTION_BOTH
	
	# Style
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.1, 0.15, 0.95)
	style.border_color = Color(0.8, 0.7, 0.3)
	style.set_border_width_all(3)
	style.set_corner_radius_all(10)
	style.set_content_margin_all(30)
	_choice_panel.add_theme_stylebox_override("panel", style)
	
	# Main container
	var vbox = VBoxContainer.new()
	vbox.name = "VBox"
	vbox.add_theme_constant_override("separation", 25)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "OATHBOUND PLAYTEST LAB"
	title.add_theme_font_size_override("font_size", 20)
	vbox.add_child(title)

	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status_label.custom_minimum_size = Vector2(390, 42)
	vbox.add_child(_status_label)

	var tabs := TabContainer.new()
	tabs.custom_minimum_size = Vector2(400, 235)
	vbox.add_child(tabs)

	_build_player_tab(tabs)
	_build_enemy_tab(tabs)
	_build_room_tab(tabs)
	_build_build_tab(tabs)

	var footer := Label.new()
	footer.text = "F8 closes the lab. Gameplay pauses while the lab is open."
	footer.modulate = Color(0.7, 0.7, 0.7)
	vbox.add_child(footer)

	_refresh_status()


func _make_tab(tabs: TabContainer, title: String) -> VBoxContainer:
	var margin := MarginContainer.new()
	margin.name = title
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	tabs.add_child(margin)

	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 6)
	margin.add_child(v)
	return v


func _build_player_tab(tabs: TabContainer) -> void:
	var v := _make_tab(tabs, "Player")

	var row := HBoxContainer.new()
	v.add_child(row)
	var restore := Button.new()
	restore.text = "Restore Full"
	restore.pressed.connect(_restore_player)
	row.add_child(restore)

	_invulnerable_check = CheckButton.new()
	_invulnerable_check.text = "Invulnerable"
	_invulnerable_check.toggled.connect(_set_player_invulnerable)
	row.add_child(_invulnerable_check)

	var labels := HBoxContainer.new()
	v.add_child(labels)
	for text in ["Health", "Posture", "Spirit"]:
		var l := Label.new()
		l.text = text
		l.custom_minimum_size = Vector2(115, 0)
		labels.add_child(l)

	var values := HBoxContainer.new()
	v.add_child(values)
	_health_spin = _resource_spin(0, 100, 100)
	_posture_spin = _resource_spin(0, 100, 0)
	_spirit_spin = _resource_spin(0, 100, 100)
	values.add_child(_health_spin)
	values.add_child(_posture_spin)
	values.add_child(_spirit_spin)

	var apply := Button.new()
	apply.text = "Apply Player Resources"
	apply.pressed.connect(_apply_player_resources)
	v.add_child(apply)

	var baseline := Button.new()
	baseline.text = "Print Core Combat Baseline"
	baseline.pressed.connect(_print_core_baseline)
	v.add_child(baseline)


func _resource_spin(minimum: float, maximum: float, initial: float) -> SpinBox:
	var spin := SpinBox.new()
	spin.min_value = minimum
	spin.max_value = maximum
	spin.step = 1
	spin.value = initial
	spin.custom_minimum_size = Vector2(115, 0)
	return spin


func _build_enemy_tab(tabs: TabContainer) -> void:
	var v := _make_tab(tabs, "Enemies")

	_enemy_dropdown = OptionButton.new()
	for enemy_name in HUSHIRO_ENEMIES.keys():
		_enemy_dropdown.add_item(enemy_name)
	v.add_child(_enemy_dropdown)

	var row := HBoxContainer.new()
	v.add_child(row)
	var spawn_one := Button.new()
	spawn_one.text = "Spawn 1"
	spawn_one.pressed.connect(func(): _spawn_selected_enemy(1))
	row.add_child(spawn_one)

	var spawn_three := Button.new()
	spawn_three.text = "Spawn 3"
	spawn_three.pressed.connect(func(): _spawn_selected_enemy(3))
	row.add_child(spawn_three)

	var clear := Button.new()
	clear.text = "Clear Enemies"
	clear.pressed.connect(_clear_enemies)
	row.add_child(clear)

	var note := Label.new()
	note.text = "Spawns the six current Hushiro standard enemy scenes near Akio."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(note)


func _build_room_tab(tabs: TabContainer) -> void:
	var v := _make_tab(tabs, "Room")

	var row := HBoxContainer.new()
	v.add_child(row)
	var reload := Button.new()
	reload.text = "Reload Current Room"
	reload.pressed.connect(_reload_current_room)
	row.add_child(reload)

	var hub := Button.new()
	hub.text = "Return to Hub"
	hub.pressed.connect(_return_to_hub)
	row.add_child(hub)

	_room_dropdown = OptionButton.new()
	for room_type in ["combat", "shrine", "treasure", "rest", "shop", "boss"]:
		_room_dropdown.add_item(room_type.capitalize())
	v.add_child(_room_dropdown)

	var warp := Button.new()
	warp.text = "Warp to Area 1 Room"
	warp.pressed.connect(_warp_area1_room)
	v.add_child(warp)


func _build_build_tab(tabs: TabContainer) -> void:
	var v := _make_tab(tabs, "Build")
	var title := Label.new()
	title.text = "Current build-system adapters"
	v.add_child(title)

	var status := Label.new()
	status.text = "Aspects: not connected yet\nTechniques: not connected yet\nRelics: not connected yet\nProsthetics: legacy runtime only\nCorruption/Blood: not connected yet"
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	v.add_child(status)

	var note := Label.new()
	note.text = "This tab is intentionally honest: controls become active as each current Oathbound system is implemented, instead of manipulating obsolete boon/stance data."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.75, 0.75, 0.75)
	v.add_child(note)


func _toggle_lab() -> void:
	if _ui == null:
		return
	var opening := not _ui.visible
	_ui.visible = opening
	get_tree().paused = opening
	if opening:
		_sync_player_controls()
		_refresh_status()


func _close_lab() -> void:
	if _ui:
		_ui.visible = false
	get_tree().paused = false


func _get_player() -> Node:
	return get_tree().get_first_node_in_group("player")


func _get_active_room() -> Node:
	return get_tree().get_first_node_in_group("room")


func _refresh_status() -> void:
	if _status_label == null:
		return
	var p := _get_player()
	var enemy_count := 0
	var room := _get_active_room()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(enemy) and (room == null or room.is_ancestor_of(enemy)):
			enemy_count += 1

	var area := int(RunData.current_area_id) if RunData else 0
	var room_text := room.name if room else "none"
	if p and p.has_method("get_playtest_snapshot"):
		var s: Dictionary = p.get_playtest_snapshot()
		_status_label.text = "Area %d | Room %s | Enemies %d\nHP %s/%s | Posture %.0f/%.0f | Spirit %s/%s | %s" % [
			area, room_text, enemy_count,
			str(s.get("health", "?")), str(s.get("max_health", "?")),
			float(s.get("posture", 0.0)), float(s.get("max_posture", 0.0)),
			str(s.get("spirit", "?")), str(s.get("max_spirit", "?")),
			str(s.get("state", "?"))
		]
	else:
		_status_label.text = "Area %d | Room %s | Enemies %d\nPlayer not available in this scene." % [area, room_text, enemy_count]


func _sync_player_controls() -> void:
	var p := _get_player()
	if p == null or not p.has_method("get_playtest_snapshot"):
		return
	var s: Dictionary = p.get_playtest_snapshot()
	_health_spin.max_value = float(s.get("max_health", 100))
	_posture_spin.max_value = float(s.get("max_posture", 100))
	_spirit_spin.max_value = float(s.get("max_spirit", 100))
	_health_spin.value = float(s.get("health", 100))
	_posture_spin.value = float(s.get("posture", 0))
	_spirit_spin.value = float(s.get("spirit", 100))
	_invulnerable_check.set_pressed_no_signal(bool(s.get("invulnerable", false)))


func _restore_player() -> void:
	var p := _get_player()
	if p and p.has_method("playtest_restore_full"):
		p.playtest_restore_full()
	_sync_player_controls()
	_refresh_status()


func _set_player_invulnerable(enabled: bool) -> void:
	var p := _get_player()
	if p and p.has_method("set_playtest_invulnerable"):
		p.set_playtest_invulnerable(enabled)
	_refresh_status()


func _apply_player_resources() -> void:
	var p := _get_player()
	if p and p.has_method("playtest_set_resources"):
		p.playtest_set_resources(_health_spin.value, _posture_spin.value, _spirit_spin.value)
	_refresh_status()


func _print_core_baseline() -> void:
	var p := _get_player()
	if p and p.has_method("get_core_combat_baseline"):
		print("[PlaytestLab] Core baseline: ", p.get_core_combat_baseline())
	else:
		push_warning("[PlaytestLab] Current Player does not expose core combat baseline data.")


func _spawn_selected_enemy(count: int) -> void:
	var p := _get_player()
	if p == null or not (p is Node2D):
		push_warning("[PlaytestLab] Spawn requires an active Player.")
		return
	if _enemy_dropdown == null or _enemy_dropdown.item_count == 0:
		return

	var enemy_name := _enemy_dropdown.get_item_text(_enemy_dropdown.selected)
	var path := str(HUSHIRO_ENEMIES.get(enemy_name, ""))
	if path.is_empty() or not ResourceLoader.exists(path):
		push_warning("[PlaytestLab] Missing enemy scene: %s" % path)
		return

	var packed := load(path) as PackedScene
	if packed == null:
		push_warning("[PlaytestLab] Could not load enemy scene: %s" % path)
		return

	var parent := _get_active_room()
	if parent == null:
		parent = get_tree().current_scene

	for i in range(max(1, count)):
		var enemy := packed.instantiate()
		parent.add_child(enemy)
		if enemy is Node2D:
			var angle := TAU * float(i) / float(max(1, count))
			(enemy as Node2D).global_position = (p as Node2D).global_position + Vector2.RIGHT.rotated(angle) * 90.0
		if not enemy.is_in_group("enemy"):
			enemy.add_to_group("enemy")

	_refresh_status()


func _clear_enemies() -> void:
	var room := _get_active_room()
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		if room == null or room.is_ancestor_of(enemy):
			enemy.queue_free()
	_refresh_status()


func _reload_current_room() -> void:
	_close_lab()
	if GameFlow and GameFlow.has_method("_load_current_room"):
		GameFlow.call_deferred("_load_current_room")
	else:
		push_warning("[PlaytestLab] GameFlow cannot reload the current room.")


func _return_to_hub() -> void:
	_close_lab()
	get_tree().change_scene_to_file(HUB_SCENE)


func _warp_area1_room() -> void:
	if _room_dropdown == null or _room_dropdown.item_count == 0:
		return
	var room_type := _room_dropdown.get_item_text(_room_dropdown.selected).to_lower()
	_close_lab()
	if GameFlow and GameFlow.has_method("debug_warp"):
		GameFlow.debug_warp(1, room_type)
	else:
		push_warning("[PlaytestLab] GameFlow.debug_warp is unavailable.")
