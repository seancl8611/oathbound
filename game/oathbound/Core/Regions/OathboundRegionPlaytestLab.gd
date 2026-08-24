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
	{"id": "embered_pilgrim", "name": "Embered Pilgrim", "scene": "res://Enemy/Area 2/Miniboss/embered_pilgrim.tscn"},
	{"id": "rotwood_host", "name": "Rotwood Host", "scene": "res://Enemy/Area 2/Miniboss/rotwood_host.tscn"},
]

var _yomori_actor_dropdown: OptionButton
var _region_status: Label


func _build_build_tab(tabs: TabContainer) -> void:
	super._build_build_tab(tabs)
	_build_region_tab(tabs)


func _build_region_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Regions")

	var title := Label.new()
	title.text = "Targeted region tests"
	vbox.add_child(title)

	var room_row_a := HBoxContainer.new()
	vbox.add_child(room_row_a)
	for entry: Dictionary in [
		{"label": "Yomori Combat", "token": "combat"},
		{"label": "Yomori Miniboss", "token": "miniboss"},
		{"label": "Twin Maws", "token": "boss"},
		{"label": "Treasure", "token": "treasure"},
	]:
		var button := Button.new()
		button.text = str(entry.get("label", ""))
		button.pressed.connect(_warp_yomori_room.bind(str(entry.get("token", "combat"))))
		room_row_a.add_child(button)

	var room_row_b := HBoxContainer.new()
	vbox.add_child(room_row_b)
	for entry: Dictionary in [
		{"label": "Shrine", "token": "shrine"},
		{"label": "Merchant", "token": "merchant"},
		{"label": "Rest", "token": "rest"},
	]:
		var button := Button.new()
		button.text = str(entry.get("label", ""))
		button.pressed.connect(_warp_yomori_room.bind(str(entry.get("token", "rest"))))
		room_row_b.add_child(button)

	var separator := HSeparator.new()
	vbox.add_child(separator)

	_yomori_actor_dropdown = OptionButton.new()
	for entry: Dictionary in YOMORI_TEST_ACTORS:
		_yomori_actor_dropdown.add_item(str(entry.get("name", entry.get("id", ""))))
		_yomori_actor_dropdown.set_item_metadata(_yomori_actor_dropdown.item_count - 1, entry)
	vbox.add_child(_yomori_actor_dropdown)

	var spawn_row := HBoxContainer.new()
	vbox.add_child(spawn_row)

	var spawn_one := Button.new()
	spawn_one.text = "Spawn Selected"
	spawn_one.pressed.connect(_spawn_selected_yomori_actor)
	spawn_row.add_child(spawn_one)

	var clear := Button.new()
	clear.text = "Clear Enemies"
	clear.pressed.connect(_clear_enemies)
	spawn_row.add_child(clear)

	_region_status = Label.new()
	_region_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_region_status.modulate = Color(0.70, 0.74, 0.82)
	_region_status.text = "Room warps reset run-scoped state and load the current Region 2 authority directly. Actor spawns are behavior-isolation tests only; use the Miniboss/Twin Maws warps for chamber reward and boss-manager contracts."
	vbox.add_child(_region_status)

	print("[OathboundPlaytestLab] Regions tab built with Yomori targeted tests")


func _warp_yomori_room(room_token: String) -> void:
	_close_lab()
	if typeof(GameFlow) == TYPE_OBJECT and GameFlow.has_method("debug_warp"):
		GameFlow.call("debug_warp", 2, room_token)
		print("[PlaytestLab] Targeted warp: Yomori -> %s" % room_token)
	else:
		push_warning("[PlaytestLab] GameFlow.debug_warp is unavailable.")


func _spawn_selected_yomori_actor() -> void:
	var player := _get_player()
	if player == null or not (player is Node2D):
		push_warning("[PlaytestLab] Yomori actor spawn requires an active Player.")
		return
	if _yomori_actor_dropdown == null or _yomori_actor_dropdown.item_count <= 0:
		return

	var metadata: Variant = _yomori_actor_dropdown.get_item_metadata(_yomori_actor_dropdown.selected)
	if not (metadata is Dictionary):
		return
	var entry: Dictionary = metadata as Dictionary
	var scene_path: String = str(entry.get("scene", ""))
	if scene_path.is_empty() or not ResourceLoader.exists(scene_path):
		push_warning("[PlaytestLab] Missing Yomori actor scene: %s" % scene_path)
		return

	var packed := load(scene_path) as PackedScene
	if packed == null:
		push_warning("[PlaytestLab] Could not load Yomori actor scene: %s" % scene_path)
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
	if not actor.is_in_group("enemy"):
		actor.add_to_group("enemy")
	print("[PlaytestLab] Spawned targeted Yomori actor: %s" % str(entry.get("name", actor.name)))
	_refresh_status()
