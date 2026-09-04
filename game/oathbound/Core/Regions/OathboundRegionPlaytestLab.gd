extends "res://Core/Corruption/OathboundCorruptionPlaytestLab.gd"

## Region-focused Playtest Lab controls.
##
## The normal run remains the authority for progression. These controls exist only
## to isolate one regional variable at a time so content development does not
## require replaying earlier regions for every manual check.

const YOMORI_TEST_ACTORS := [
	{"id": "lingering_wraith", "name": "Lingering Wraith", "scene": "res://Enemy/Area 2/Encounter/lingering_wraith.tscn"},
	{"id": "lantern_wraith", "name": "Lantern Wraith", "scene": "res://Enemy/Area 2/Encounter/lantern_wraith.tscn"},
	{"id": "mist_shepherd", "name": "Mist Shepherd", "scene": "res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn"},
	{"id": "stalker_hound", "name": "Stalker Hound", "scene": "res://Enemy/Area 2/Encounter/stalker_hound.tscn"},
	{"id": "embered_pilgrim", "name": "Embered Pilgrim", "scene": "res://Enemy/Area 2/Minibosses/embered_pilgrim.tscn"},
	{"id": "rotwood_host", "name": "Rotwood Host", "scene": "res://Enemy/Area 2/Minibosses/rotwood_host.tscn"},
]

const KAGUTSUCHI_TEST_ACTORS := [
	{"id": "court_guard", "name": "Court Guard", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/CourtGuard.tscn"},
	{"id": "court_caster", "name": "Court Caster", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/CourtCaster.tscn"},
	{"id": "elite_defender", "name": "Elite Defender", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/EliteDefender.tscn"},
	{"id": "hollow_vessel", "name": "Hollow Vessel", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/HollowVessel.tscn"},
	{"id": "court_sentinel", "name": "Court Sentinel", "scene": "res://Regions/Kagutsuchi/Enemies/Standard/CourtSentinel.tscn"},
	{"id": "blood_lotus", "name": "Blood Lotus", "scene": "res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotus.tscn"},
	{"id": "eternal_swordsman", "name": "Eternal Swordsman", "scene": "res://Regions/Kagutsuchi/Enemies/Minibosses/EternalSwordsman.tscn"},
	{"id": "eclipse_shogun", "name": "Eclipse Shogun", "scene": "res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogun.tscn"},
]

const PLAYTEST_POWER_MULTIPLIERS: Array[float] = [1.0, 2.0, 3.0, 5.0, 10.0]
const RECOMMENDED_INTEGRATION_POWER: float = 5.0
const FAST_CLEAR_POWER: float = 10.0

var _yomori_actor_dropdown: OptionButton
var _kagutsuchi_actor_dropdown: OptionButton
var _region_status: Label
var _chamber_area_dropdown: OptionButton
var _power_health_dropdown: OptionButton
var _power_posture_dropdown: OptionButton
var _power_status: Label
var _playtest_health_damage_multiplier: float = 1.0
var _playtest_posture_damage_multiplier: float = 1.0


func _build_ui() -> void:
	super._build_ui()
	# The inherited lab used a fixed minimum-size panel. At the project's 640x360
	# authority viewport, taller inherited tabs can extend below the screen. Keep the
	# shell inside the viewport; each tab is independently scrollable via _make_tab().
	if _ui == null:
		return
	for child: Node in _ui.get_children():
		if child is PanelContainer:
			var panel := child as PanelContainer
			panel.anchor_left = 0.0
			panel.anchor_top = 0.0
			panel.anchor_right = 1.0
			panel.anchor_bottom = 1.0
			panel.offset_left = 12.0
			panel.offset_top = 12.0
			panel.offset_right = -12.0
			panel.offset_bottom = -12.0
			panel.custom_minimum_size = Vector2.ZERO
			break


func _make_tab(tabs: TabContainer, title: String) -> VBoxContainer:
	# Keep the public helper contract used by all inherited Playtest Lab layers while
	# putting every tab inside a real ScrollContainer. Mouse wheel and scrollbars now
	# reach controls that do not fit at small viewport/window sizes.
	var scroll := ScrollContainer.new()
	scroll.name = title
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.add_child(scroll)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	margin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(margin)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 6)
	vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	margin.add_child(vbox)
	return vbox


func _build_build_tab(tabs: TabContainer) -> void:
	super._build_build_tab(tabs)
	_build_power_tab(tabs)
	_build_region_tab(tabs)


func _build_power_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Power")

	var title := Label.new()
	title.text = "Playtest-only combat power"
	title.add_theme_font_size_override("font_size", 18)
	vbox.add_child(title)

	var intro := Label.new()
	intro.text = "Outgoing multipliers are debug-session controls only. 1x is canonical gameplay and remains the default."
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.modulate = Color(0.72, 0.74, 0.82)
	vbox.add_child(intro)

	var health_label := Label.new()
	health_label.text = "Health damage multiplier"
	vbox.add_child(health_label)
	_power_health_dropdown = _make_power_dropdown()
	_power_health_dropdown.item_selected.connect(func(_index: int) -> void: _apply_custom_power())
	vbox.add_child(_power_health_dropdown)

	var posture_label := Label.new()
	posture_label.text = "Posture damage multiplier"
	vbox.add_child(posture_label)
	_power_posture_dropdown = _make_power_dropdown()
	_power_posture_dropdown.item_selected.connect(func(_index: int) -> void: _apply_custom_power())
	vbox.add_child(_power_posture_dropdown)

	var preset_row := HBoxContainer.new()
	vbox.add_child(preset_row)

	var normal := Button.new()
	normal.text = "Normal 1x"
	normal.pressed.connect(_set_power_preset.bind(1.0, false))
	preset_row.add_child(normal)

	var recommended := Button.new()
	recommended.text = "Recommended 5x + Invulnerable"
	recommended.pressed.connect(_set_power_preset.bind(RECOMMENDED_INTEGRATION_POWER, true))
	preset_row.add_child(recommended)

	var fast_clear := Button.new()
	fast_clear.text = "Fast Clear 10x + Invulnerable"
	fast_clear.pressed.connect(_set_power_preset.bind(FAST_CLEAR_POWER, true))
	preset_row.add_child(fast_clear)

	var restore := Button.new()
	restore.text = "Restore HP / Posture / Spirit"
	restore.pressed.connect(_restore_player)
	vbox.add_child(restore)

	_power_status = Label.new()
	_power_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_power_status.modulate = Color(0.78, 0.80, 0.88)
	vbox.add_child(_power_status)

	var note := Label.new()
	note.text = "Recommended integration setting: 5x Health + 5x Posture + Invulnerable. Use 10x only when you need to reach teardown, reward, or region-transition logic quickly; it is intentionally too strong for pacing/balance evaluation."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.66, 0.68, 0.76)
	vbox.add_child(note)

	_sync_power_dropdowns()
	_refresh_power_status()


func _make_power_dropdown() -> OptionButton:
	var dropdown := OptionButton.new()
	for multiplier: float in PLAYTEST_POWER_MULTIPLIERS:
		dropdown.add_item("%.0fx" % multiplier)
		dropdown.set_item_metadata(dropdown.item_count - 1, multiplier)
	return dropdown


func _selected_power_multiplier(dropdown: OptionButton) -> float:
	if dropdown == null or dropdown.item_count <= 0:
		return 1.0
	return clampf(float(dropdown.get_item_metadata(dropdown.selected)), 1.0, FAST_CLEAR_POWER)


func _apply_custom_power() -> void:
	_playtest_health_damage_multiplier = _selected_power_multiplier(_power_health_dropdown)
	_playtest_posture_damage_multiplier = _selected_power_multiplier(_power_posture_dropdown)
	_refresh_power_status()
	print("[PlaytestLab] Custom power: Health %.1fx | Posture %.1fx" % [
		_playtest_health_damage_multiplier,
		_playtest_posture_damage_multiplier,
	])


func _set_power_preset(multiplier: float, invulnerable: bool) -> void:
	var clamped := clampf(multiplier, 1.0, FAST_CLEAR_POWER)
	_playtest_health_damage_multiplier = clamped
	_playtest_posture_damage_multiplier = clamped
	_sync_power_dropdowns()
	var player: Node = _get_player()
	if player != null:
		if player.has_method("set_playtest_invulnerable"):
			player.call("set_playtest_invulnerable", invulnerable)
		if player.has_method("playtest_restore_full"):
			player.call("playtest_restore_full")
	_sync_player_controls()
	_refresh_status()
	_refresh_power_status()
	print("[PlaytestLab] Power preset: %.1fx Health/Posture | Invulnerable=%s" % [clamped, str(invulnerable)])


func _sync_power_dropdowns() -> void:
	_select_power_dropdown_value(_power_health_dropdown, _playtest_health_damage_multiplier)
	_select_power_dropdown_value(_power_posture_dropdown, _playtest_posture_damage_multiplier)


func _select_power_dropdown_value(dropdown: OptionButton, multiplier: float) -> void:
	if dropdown == null:
		return
	for index: int in range(dropdown.item_count):
		if is_equal_approx(float(dropdown.get_item_metadata(index)), multiplier):
			dropdown.select(index)
			return


func _refresh_power_status() -> void:
	if _power_status == null:
		return
	var player: Node = _get_player()
	var invulnerable := false
	if player != null and player.has_method("is_playtest_invulnerable"):
		invulnerable = bool(player.call("is_playtest_invulnerable"))
	_power_status.text = "Current: Health %.1fx | Posture %.1fx | Invulnerable: %s\nPower multipliers stay active across chamber/region warps until changed or the debug session ends." % [
		_playtest_health_damage_multiplier,
		_playtest_posture_damage_multiplier,
		str(invulnerable),
	]


func get_playtest_health_damage_multiplier() -> float:
	if not OS.is_debug_build():
		return 1.0
	return clampf(_playtest_health_damage_multiplier, 1.0, FAST_CLEAR_POWER)


func get_playtest_posture_damage_multiplier() -> float:
	if not OS.is_debug_build():
		return 1.0
	return clampf(_playtest_posture_damage_multiplier, 1.0, FAST_CLEAR_POWER)


func _build_room_tab(tabs: TabContainer) -> void:
	# Replace the imported Hushiro-only chamber warp with one obvious selector that
	# can jump directly into any current region. This is the primary manual-integration
	# path; the dedicated Regions tab below remains useful for one-click named targets.
	var vbox: VBoxContainer = _make_tab(tabs, "Chambers")

	var row := HBoxContainer.new()
	vbox.add_child(row)

	var reload_button := Button.new()
	reload_button.text = "Reload Current Chamber"
	reload_button.pressed.connect(_reload_current_room)
	row.add_child(reload_button)

	var hub_button := Button.new()
	hub_button.text = "Return to Hub"
	hub_button.pressed.connect(_return_to_hub)
	row.add_child(hub_button)

	var area_label := Label.new()
	area_label.text = "Target Region"
	vbox.add_child(area_label)

	_chamber_area_dropdown = OptionButton.new()
	for entry: Dictionary in [
		{"label": "Area 1 - Hushiro", "id": 1},
		{"label": "Area 2 - Yomori", "id": 2},
		{"label": "Area 3 - Kagutsuchi", "id": 3},
	]:
		_chamber_area_dropdown.add_item(str(entry.get("label", "")))
		_chamber_area_dropdown.set_item_metadata(_chamber_area_dropdown.item_count - 1, int(entry.get("id", 1)))
	vbox.add_child(_chamber_area_dropdown)

	var room_label := Label.new()
	room_label.text = "Target Chamber"
	vbox.add_child(room_label)

	_room_dropdown = OptionButton.new()
	for room_type: String in ["combat", "shrine", "merchant", "rest", "miniboss", "boss"]:
		_room_dropdown.add_item(room_type.capitalize())
	vbox.add_child(_room_dropdown)

	var warp_button := Button.new()
	warp_button.text = "Warp Directly to Selected Region / Chamber"
	warp_button.pressed.connect(_warp_selected_region_chamber)
	vbox.add_child(warp_button)

	var note := Label.new()
	note.text = "Debug warp resets run-scoped state for the selected region. You do not need to clear Hushiro or kill Keeper before testing Yomori or Kagutsuchi."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.70, 0.74, 0.82)
	vbox.add_child(note)


func _warp_selected_region_chamber() -> void:
	if _chamber_area_dropdown == null or _chamber_area_dropdown.item_count <= 0:
		return
	if _room_dropdown == null or _room_dropdown.item_count <= 0:
		return
	var area_id := int(_chamber_area_dropdown.get_item_metadata(_chamber_area_dropdown.selected))
	var room_token := _room_dropdown.get_item_text(_room_dropdown.selected).to_lower()
	_warp_region_room(area_id, room_token)


func _build_region_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Regions")

	var title := Label.new()
	title.text = "Targeted region tests"
	vbox.add_child(title)

	_add_region_heading(vbox, "Yomori Grove")
	_add_room_warp_row(vbox, 2, [
		{"label": "Yomori Combat", "token": "combat"},
		{"label": "Yomori Miniboss", "token": "miniboss"},
		{"label": "Twin Maws", "token": "boss"},
		{"label": "Treasure", "token": "treasure"},
	])
	_add_room_warp_row(vbox, 2, [
		{"label": "Shrine", "token": "shrine"},
		{"label": "Merchant", "token": "merchant"},
		{"label": "Rest", "token": "rest"},
	])

	_yomori_actor_dropdown = _make_actor_dropdown(YOMORI_TEST_ACTORS)
	vbox.add_child(_yomori_actor_dropdown)
	_add_actor_spawn_row(vbox, _yomori_actor_dropdown, "Yomori")

	vbox.add_child(HSeparator.new())
	_add_region_heading(vbox, "Kagutsuchi Court")
	_add_room_warp_row(vbox, 3, [
		{"label": "Court Combat", "token": "combat"},
		{"label": "Court Miniboss", "token": "miniboss"},
		{"label": "Eclipse Shogun", "token": "boss"},
		{"label": "Treasure", "token": "treasure"},
	])
	_add_room_warp_row(vbox, 3, [
		{"label": "Shrine", "token": "shrine"},
		{"label": "Merchant", "token": "merchant"},
		{"label": "Rest", "token": "rest"},
	])

	_kagutsuchi_actor_dropdown = _make_actor_dropdown(KAGUTSUCHI_TEST_ACTORS)
	vbox.add_child(_kagutsuchi_actor_dropdown)
	_add_actor_spawn_row(vbox, _kagutsuchi_actor_dropdown, "Kagutsuchi")

	_region_status = Label.new()
	_region_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_region_status.modulate = Color(0.70, 0.74, 0.82)
	_region_status.text = "Room warps reset run-scoped state and load the selected regional authority directly. Actor spawns isolate behavior only; use room warps to validate chamber rewards, miniboss resolution, Twin Maws, and Eclipse Shogun flow."
	vbox.add_child(_region_status)

	print("[OathboundPlaytestLab] Regions tab built with Yomori + Kagutsuchi targeted tests")


func _add_region_heading(vbox: VBoxContainer, text: String) -> void:
	var heading := Label.new()
	heading.text = text
	heading.add_theme_font_size_override("font_size", 18)
	vbox.add_child(heading)


func _add_room_warp_row(vbox: VBoxContainer, area_id: int, entries: Array) -> void:
	var row := HBoxContainer.new()
	vbox.add_child(row)
	for entry_value: Variant in entries:
		if not (entry_value is Dictionary):
			continue
		var entry: Dictionary = entry_value as Dictionary
		var button := Button.new()
		button.text = str(entry.get("label", ""))
		button.pressed.connect(_warp_region_room.bind(area_id, str(entry.get("token", "combat"))))
		row.add_child(button)


func _make_actor_dropdown(entries: Array) -> OptionButton:
	var dropdown := OptionButton.new()
	for entry_value: Variant in entries:
		if not (entry_value is Dictionary):
			continue
		var entry: Dictionary = entry_value as Dictionary
		dropdown.add_item(str(entry.get("name", entry.get("id", ""))))
		dropdown.set_item_metadata(dropdown.item_count - 1, entry)
	return dropdown


func _add_actor_spawn_row(vbox: VBoxContainer, dropdown: OptionButton, region_name: String) -> void:
	var row := HBoxContainer.new()
	vbox.add_child(row)
	var spawn_one := Button.new()
	spawn_one.text = "Spawn Selected"
	spawn_one.pressed.connect(_spawn_selected_region_actor.bind(dropdown, region_name))
	row.add_child(spawn_one)
	var clear := Button.new()
	clear.text = "Clear Enemies"
	clear.pressed.connect(_clear_enemies)
	row.add_child(clear)


func _warp_yomori_room(room_token: String) -> void:
	_warp_region_room(2, room_token)


func _warp_region_room(area_id: int, room_token: String) -> void:
	_close_lab()
	if typeof(GameFlow) == TYPE_OBJECT and GameFlow.has_method("debug_warp"):
		GameFlow.call("debug_warp", area_id, room_token)
		print("[PlaytestLab] Targeted warp: Area %d -> %s" % [area_id, room_token])
	else:
		push_warning("[PlaytestLab] GameFlow.debug_warp is unavailable.")


func _spawn_selected_yomori_actor() -> void:
	_spawn_selected_region_actor(_yomori_actor_dropdown, "Yomori")


func _spawn_selected_region_actor(dropdown: OptionButton, region_name: String) -> void:
	var player := _get_player()
	if player == null or not (player is Node2D):
		push_warning("[PlaytestLab] %s actor spawn requires an active Player." % region_name)
		return
	if dropdown == null or dropdown.item_count <= 0:
		return

	var metadata: Variant = dropdown.get_item_metadata(dropdown.selected)
	if not (metadata is Dictionary):
		return
	var entry: Dictionary = metadata as Dictionary
	var scene_path := str(entry.get("scene", ""))
	if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
		push_warning("[PlaytestLab] Missing %s actor scene: %s" % [region_name, scene_path])
		return
	var packed := load(scene_path) as PackedScene
	if packed == null:
		push_warning("[PlaytestLab] Could not load %s actor scene: %s" % [region_name, scene_path])
		return

	var parent := _get_active_room()
	if parent == null:
		parent = get_tree().current_scene
	if parent == null:
		return

	var actor := packed.instantiate()
	parent.add_child(actor)
	if actor is Node2D:
		(actor as Node2D).global_position = (player as Node2D).global_position + Vector2(110.0, 0.0)
	if not actor.is_in_group("enemy") and not actor.is_in_group("miniboss") and not actor.is_in_group("boss"):
		actor.add_to_group("enemy")
	print("[PlaytestLab] Spawned targeted %s actor: %s" % [region_name, str(entry.get("name", actor.name))])
	_refresh_status()
