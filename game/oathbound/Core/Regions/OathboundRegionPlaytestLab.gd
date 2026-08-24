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
	{"id": "court_guard", "name": "Court Guard", "scene": "res://Enemy/Area 3/Encounter/court_guard.tscn"},
	{"id": "court_caster", "name": "Court Caster", "scene": "res://Enemy/Area 3/Encounter/court_caster.tscn"},
	{"id": "elite_defender", "name": "Elite Defender", "scene": "res://Enemy/Area 3/Encounter/elite_defender.tscn"},
	{"id": "hollow_vessel", "name": "Hollow Vessel", "scene": "res://Enemy/Area 3/Encounter/hollow_vessel.tscn"},
	{"id": "court_sentinel", "name": "Court Sentinel", "scene": "res://Enemy/Area 3/Encounter/court_sentinel.tscn"},
	{"id": "blood_lotus", "name": "Blood Lotus", "scene": "res://Regions/Kagutsuchi/Enemies/Minibosses/BloodLotus.tscn"},
	{"id": "eternal_swordsman", "name": "Eternal Swordsman", "scene": "res://Regions/Kagutsuchi/Enemies/Minibosses/EternalSwordsman.tscn"},
	{"id": "eclipse_shogun", "name": "Eclipse Shogun", "scene": "res://Enemy/Area 3/Boss/eclipse_shogun.tscn"},
]

var _yomori_actor_dropdown: OptionButton
var _kagutsuchi_actor_dropdown: OptionButton
var _region_status: Label


func _build_build_tab(tabs: TabContainer) -> void:
	super._build_build_tab(tabs)
	_build_region_tab(tabs)


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
