extends Node

## Oathbound's development-only in-game test harness.
## This replaces the old ad-hoc DebugService UI. It only exposes current systems;
## obsolete boon/stance controls are deliberately not carried forward.

const HUB_SCENE := "res://World/HubScene.tscn"

const HUSHIRO_ENEMIES := {
	"Swordsman": "res://Enemy/Area 1/Encounter/corrupted_swordsman.tscn",
	"Archer": "res://Enemy/Area 1/Encounter/corrupted_archer.tscn",
	"Blighted Hound": "res://Enemy/Area 1/Encounter/blighted_hound.tscn",
	"Hollow": "res://Enemy/Area 1/Encounter/hollow.tscn",
	"Bilemass": "res://Enemy/Area 1/Encounter/Cellar_Bilemass.tscn",
	"Warden": "res://Enemy/Area 1/Encounter/warden.tscn",
}

var _ui: CanvasLayer
var _status_label: Label
var _enemy_dropdown: OptionButton
var _room_dropdown: OptionButton
var _health_spin: SpinBox
var _posture_spin: SpinBox
var _spirit_spin: SpinBox
var _invulnerable_check: CheckButton
var _paused_before_open := false
var _status_refresh_accum := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not OS.is_debug_build():
		set_process(false)
		set_process_unhandled_input(false)
		return
	call_deferred("_build_ui")
	print("[PlaytestLab] Ready. Press ` (backtick) to toggle.")


func _process(delta: float) -> void:
	if _ui == null or not _ui.visible:
		return
	_status_refresh_accum += delta
	if _status_refresh_accum >= 0.2:
		_status_refresh_accum = 0.0
		_refresh_status()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("playtest_lab_toggle"):
		_toggle_lab()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	_ui = CanvasLayer.new()
	_ui.name = "PlaytestLabUI"
	_ui.layer = 300
	_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	_ui.visible = false
	add_child(_ui)

	var backdrop := ColorRect.new()
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0.0, 0.0, 0.0, 0.45)
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	_ui.add_child(backdrop)

	var panel := PanelContainer.new()
	panel.position = Vector2(12, 12)
	panel.custom_minimum_size = Vector2(430, 330)
	panel.process_mode = Node.PROCESS_MODE_ALWAYS
	_ui.add_child(panel)

	var panel_style := StyleBoxFlat.new()
	panel_style.bg_color = Color(0.055, 0.06, 0.075, 0.98)
	panel_style.border_color = Color(0.45, 0.48, 0.56, 1.0)
	panel_style.set_border_width_all(1)
	panel_style.set_corner_radius_all(6)
	panel_style.set_content_margin_all(10)
	panel.add_theme_stylebox_override("panel", panel_style)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 5)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel.add_child(vbox)

	var title := Label.new()
	title.text = "OATHBOUND PLAYTEST LAB"
	title.add_theme_font_size_override("font_size", 20)
	vbox.add_child(title)

	_status_label = Label.new()
	_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status_label.custom_minimum_size = Vector2(395, 42)
	vbox.add_child(_status_label)

	var tabs := TabContainer.new()
	tabs.custom_minimum_size = Vector2(405, 225)
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	vbox.add_child(tabs)

	_build_player_tab(tabs)
	_build_enemy_tab(tabs)
	_build_room_tab(tabs)
	_build_build_tab(tabs)

	var footer := Label.new()
	footer.text = "` closes the lab. Gameplay pauses while the lab is open."
	footer.modulate = Color(0.68, 0.7, 0.75)
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

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	margin.add_child(vbox)
	return vbox


func _build_player_tab(tabs: TabContainer) -> void:
	var vbox := _make_tab(tabs, "Player")

	var action_row := HBoxContainer.new()
	vbox.add_child(action_row)

	var restore_button := Button.new()
	restore_button.text = "Restore Full"
	restore_button.pressed.connect(_restore_player)
	action_row.add_child(restore_button)

	_invulnerable_check = CheckButton.new()
	_invulnerable_check.text = "Invulnerable"
	_invulnerable_check.toggled.connect(_set_player_invulnerable)
	action_row.add_child(_invulnerable_check)

	var labels := HBoxContainer.new()
	vbox.add_child(labels)
	for text in ["Health", "Posture", "Spirit"]:
		var label := Label.new()
		label.text = text
		label.custom_minimum_size = Vector2(115, 0)
		labels.add_child(label)

	var values := HBoxContainer.new()
	vbox.add_child(values)
	_health_spin = _resource_spin(0, 100, 100)
	_posture_spin = _resource_spin(0, 100, 0)
	_spirit_spin = _resource_spin(0, 100, 100)
	values.add_child(_health_spin)
	values.add_child(_posture_spin)
	values.add_child(_spirit_spin)

	var apply_button := Button.new()
	apply_button.text = "Apply Player Resources"
	apply_button.pressed.connect(_apply_player_resources)
	vbox.add_child(apply_button)

	var baseline_button := Button.new()
	baseline_button.text = "Print Core Combat Baseline"
	baseline_button.pressed.connect(_print_core_baseline)
	vbox.add_child(baseline_button)


func _resource_spin(minimum: float, maximum: float, initial: float) -> SpinBox:
	var spin := SpinBox.new()
	spin.min_value = minimum
	spin.max_value = maximum
	spin.step = 1
	spin.value = initial
	spin.custom_minimum_size = Vector2(115, 0)
	return spin


func _build_enemy_tab(tabs: TabContainer) -> void:
	var vbox := _make_tab(tabs, "Enemies")

	_enemy_dropdown = OptionButton.new()
	for enemy_name in HUSHIRO_ENEMIES.keys():
		_enemy_dropdown.add_item(str(enemy_name))
	vbox.add_child(_enemy_dropdown)

	var row := HBoxContainer.new()
	vbox.add_child(row)

	var spawn_one := Button.new()
	spawn_one.text = "Spawn 1"
	spawn_one.pressed.connect(func(): _spawn_selected_enemy(1))
	row.add_child(spawn_one)

	var spawn_three := Button.new()
	spawn_three.text = "Spawn 3"
	spawn_three.pressed.connect(func(): _spawn_selected_enemy(3))
	row.add_child(spawn_three)

	var clear_button := Button.new()
	clear_button.text = "Clear Enemies"
	clear_button.pressed.connect(_clear_enemies)
	row.add_child(clear_button)

	var note := Label.new()
	note.text = "Spawns the six current Hushiro standard enemy scenes near Akio."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(note)


func _build_room_tab(tabs: TabContainer) -> void:
	var vbox := _make_tab(tabs, "Room")

	var row := HBoxContainer.new()
	vbox.add_child(row)

	var reload_button := Button.new()
	reload_button.text = "Reload Current Room"
	reload_button.pressed.connect(_reload_current_room)
	row.add_child(reload_button)

	var hub_button := Button.new()
	hub_button.text = "Return to Hub"
	hub_button.pressed.connect(_return_to_hub)
	row.add_child(hub_button)

	_room_dropdown = OptionButton.new()
	for room_type in ["combat", "shrine", "treasure", "rest", "shop", "boss"]:
		_room_dropdown.add_item(room_type.capitalize())
	vbox.add_child(_room_dropdown)

	var warp_button := Button.new()
	warp_button.text = "Warp to Area 1 Room"
	warp_button.pressed.connect(_warp_area1_room)
	vbox.add_child(warp_button)


func _build_build_tab(tabs: TabContainer) -> void:
	var vbox := _make_tab(tabs, "Build")

	var title := Label.new()
	title.text = "Current build-system adapters"
	vbox.add_child(title)

	var status := Label.new()
	status.text = "Aspects: not connected yet\nTechniques: not connected yet\nRelics: not connected yet\nProsthetics: legacy runtime only\nCorruption/Blood: not connected yet"
	status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	vbox.add_child(status)

	var note := Label.new()
	note.text = "Controls become active as each current Oathbound system is implemented. The lab will not manipulate obsolete boon/stance data."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.72, 0.74, 0.8)
	vbox.add_child(note)


func _toggle_lab() -> void:
	if _ui == null:
		return
	var opening := not _ui.visible
	if opening:
		_paused_before_open = get_tree().paused
		_ui.visible = true
		get_tree().paused = true
		_sync_player_controls()
		_refresh_status()
	else:
		_ui.visible = false
		get_tree().paused = _paused_before_open


func _close_lab(unpause: bool = true) -> void:
	if _ui:
		_ui.visible = false
	if unpause:
		get_tree().paused = false
	else:
		get_tree().paused = _paused_before_open


func _get_player() -> Node:
	return get_tree().get_first_node_in_group("player")


func _get_active_room() -> Node:
	return get_tree().get_first_node_in_group("room")


func _refresh_status() -> void:
	if _status_label == null:
		return

	var player := _get_player()
	var room := _get_active_room()
	var enemy_count := 0
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(enemy) and (room == null or room.is_ancestor_of(enemy)):
			enemy_count += 1

	var area := 0
	if RunData:
		area = int(RunData.current_area_id)
	var room_text := str(room.name) if room else "none"

	if player and player.has_method("get_playtest_snapshot"):
		var snapshot: Dictionary = player.get_playtest_snapshot()
		_status_label.text = "Area %d | Room %s | Enemies %d\nHP %s/%s | Posture %.0f/%.0f | Spirit %s/%s | %s" % [
			area,
			room_text,
			enemy_count,
			str(snapshot.get("health", "?")),
			str(snapshot.get("max_health", "?")),
			float(snapshot.get("posture", 0.0)),
			float(snapshot.get("max_posture", 0.0)),
			str(snapshot.get("spirit", "?")),
			str(snapshot.get("max_spirit", "?")),
			str(snapshot.get("state", "?")),
		]
	else:
		_status_label.text = "Area %d | Room %s | Enemies %d\nPlayer not available in this scene." % [area, room_text, enemy_count]


func _sync_player_controls() -> void:
	var player := _get_player()
	if player == null or not player.has_method("get_playtest_snapshot"):
		return
	var snapshot: Dictionary = player.get_playtest_snapshot()
	_health_spin.max_value = float(snapshot.get("max_health", 100))
	_posture_spin.max_value = float(snapshot.get("max_posture", 100))
	_spirit_spin.max_value = float(snapshot.get("max_spirit", 100))
	_health_spin.value = float(snapshot.get("health", 100))
	_posture_spin.value = float(snapshot.get("posture", 0))
	_spirit_spin.value = float(snapshot.get("spirit", 100))
	_invulnerable_check.set_pressed_no_signal(bool(snapshot.get("invulnerable", false)))


func _restore_player() -> void:
	var player := _get_player()
	if player and player.has_method("playtest_restore_full"):
		player.playtest_restore_full()
	_sync_player_controls()
	_refresh_status()


func _set_player_invulnerable(enabled: bool) -> void:
	var player := _get_player()
	if player and player.has_method("set_playtest_invulnerable"):
		player.set_playtest_invulnerable(enabled)
	_refresh_status()


func _apply_player_resources() -> void:
	var player := _get_player()
	if player and player.has_method("playtest_set_resources"):
		player.playtest_set_resources(_health_spin.value, _posture_spin.value, _spirit_spin.value)
	_refresh_status()


func _print_core_baseline() -> void:
	var player := _get_player()
	if player and player.has_method("get_core_combat_baseline"):
		print("[PlaytestLab] Core baseline: ", player.get_core_combat_baseline())
	else:
		push_warning("[PlaytestLab] Current Player does not expose core combat baseline data.")


func _spawn_selected_enemy(count: int) -> void:
	var player := _get_player()
	if player == null or not (player is Node2D):
		push_warning("[PlaytestLab] Spawn requires an active Player.")
		return
	if _enemy_dropdown == null or _enemy_dropdown.item_count == 0:
		return

	var enemy_name := _enemy_dropdown.get_item_text(_enemy_dropdown.selected)
	var scene_path := str(HUSHIRO_ENEMIES.get(enemy_name, ""))
	if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
		push_warning("[PlaytestLab] Missing enemy scene: %s" % scene_path)
		return

	var packed := load(scene_path) as PackedScene
	if packed == null:
		push_warning("[PlaytestLab] Could not load enemy scene: %s" % scene_path)
		return

	var parent := _get_active_room()
	if parent == null:
		parent = get_tree().current_scene

	for i in range(max(1, count)):
		var enemy := packed.instantiate()
		var angle := TAU * float(i) / float(max(1, count))
		var spawn_global := (player as Node2D).global_position + Vector2.RIGHT.rotated(angle) * 90.0
		if enemy is Node2D:
			if parent is Node2D:
				(enemy as Node2D).position = (parent as Node2D).to_local(spawn_global)
			else:
				(enemy as Node2D).position = spawn_global
		parent.add_child(enemy)
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
