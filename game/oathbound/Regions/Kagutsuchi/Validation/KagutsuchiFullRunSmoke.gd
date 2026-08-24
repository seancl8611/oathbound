extends Node

## Headless structural traversal of one legitimate generated Kagutsuchi route.
## Combat/reward completion is bypassed; this exercises the real GameFlow,
## SceneRegistry, route choices, persistent Player ownership, all 11 counted chambers,
## authored Court encounter selection, miniboss loading, Eclipse Shogun endpoint, and
## the non-counted post-Shogun Heart handoff boundary.

const KAGUTSUCHI_CATALOG = preload("res://Regions/Kagutsuchi/Encounters/KagutsuchiEncounterCatalog.gd")
const ENDGAME_FLOW = preload("res://Core/Endgame/OathboundEndgameFlow.gd")
const EXPECTED_PLAYER_SCRIPT := "res://Player/OathboundCombatPlayer.gd"
const EXPECTED_COMBAT_SCENE := "res://Regions/Kagutsuchi/Chambers/CombatChamber.tscn"
const EXPECTED_BOSS_SCENE := "res://Regions/Kagutsuchi/Chambers/EclipseShogunChamber.tscn"
const EXPECTED_HANDOFF_SCENE := "res://Core/Endgame/HeartHandoffChamber.tscn"
const EXPECTED_TREASURE_SCENE := "res://Core/Chambers/Types/TreasureChamber.tscn"
const REQUIRED_ROLES: Array[String] = ["combat", "shrine", "merchant", "rest", "treasure", "miniboss", "boss"]
const SEARCH_SEED_LIMIT := 4096

var _failures: Array[String] = []
var _room_container: Node2D
var _resolved_route: Array[String] = []
var _coverage_seed := 0
var _coverage_assignments: Dictionary = {}
var _visited_roles: Dictionary = {}
var _player_instance_id := 0


func _ready() -> void:
	await get_tree().process_frame
	await _run_traversal()
	if _failures.is_empty():
		print("[KagutsuchiFullRunSmoke] PASS - seed=%d | 11 chambers | roles=%s | Eclipse Shogun -> non-counted Heart handoff | persistent canonical Player=%d" % [_coverage_seed, str(_visited_roles.keys()), _player_instance_id])
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[KagutsuchiFullRunSmoke] %s" % failure)
		get_tree().quit(1)


func _run_traversal() -> void:
	if typeof(RouteGenerator) != TYPE_OBJECT or typeof(GameFlow) != TYPE_OBJECT or typeof(SceneRegistry) != TYPE_OBJECT or typeof(RunData) != TYPE_OBJECT:
		_fail("required run autoload missing")
		return
	_prepare_awakened_run_state()
	var plan := _find_coverage_plan()
	if plan.is_empty():
		_fail("Could not find Kagutsuchi coverage route")
		return
	_coverage_seed = int(plan.get("seed", 0))
	_coverage_assignments = (plan.get("assignments", {}) as Dictionary).duplicate(true)

	RouteGenerator.set_seed(_coverage_seed)
	var generated_value: Variant = GameFlow.build_route_for_area(3)
	if not (generated_value is Array):
		_fail("Coverage seed did not regenerate an Array")
		return
	_resolved_route = _resolve_route_choices(generated_value as Array)
	if _resolved_route.size() != 11:
		_fail("Resolved route has %d chambers instead of 11" % _resolved_route.size())
		return

	_room_container = Node2D.new()
	_room_container.name = "RoomContainer"
	add_child(_room_container)
	GameFlow.setup(_room_container)
	GameFlow.current_area = 3
	RunData.reset_for_new_run(3)
	GameFlow.set_route(_resolved_route)
	GameFlow.start_run()
	await _wait_frames(8)

	if GameFlow.player == null or not is_instance_valid(GameFlow.player):
		_fail("GameFlow failed to create Player")
		return
	_player_instance_id = GameFlow.player.get_instance_id()

	for index: int in range(_resolved_route.size()):
		_validate_loaded_chamber(index)
		if not _failures.is_empty():
			return
		if index < _resolved_route.size() - 1:
			GameFlow.next_room()
			await _wait_frames(8)

	for role: String in REQUIRED_ROLES:
		_expect(_visited_roles.has(role), "Traversal never loaded required role %s" % role)
	_expect(int(GameFlow.current_index) == 10, "Traversal should stop at Chamber 11/index 10")
	_expect(RunData.hushiro_encounters_seen.is_empty(), "Kagutsuchi leaked Hushiro encounter history")
	_expect(RunData.yomori_encounters_seen.is_empty(), "Kagutsuchi leaked Yomori encounter history")
	_expect(not RunData.kagutsuchi_encounters_seen.is_empty(), "No authored Kagutsuchi encounter registered")
	for encounter_id: String in RunData.kagutsuchi_encounters_seen:
		_expect(not KAGUTSUCHI_CATALOG.get_by_id(encounter_id).is_empty(), "Unknown Kagutsuchi encounter %s" % encounter_id)

	await _validate_post_shogun_handoff()


func _prepare_awakened_run_state() -> void:
	if typeof(MetaProgress) == TYPE_OBJECT:
		MetaProgress.set("returning_blood_awakened", true)
		MetaProgress.set("heart_bindings_destroyed", 0)
		MetaProgress.set("story_complete", false)
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("select_aspect"):
		AspectRuntime.call("select_aspect", "wolf")
	if typeof(CorruptionRuntime) == TYPE_OBJECT and CorruptionRuntime.has_method("set_corruption_for_playtest"):
		CorruptionRuntime.call("set_corruption_for_playtest", 0)


func _find_coverage_plan() -> Dictionary:
	for seed: int in range(1, SEARCH_SEED_LIMIT + 1):
		RouteGenerator.set_seed(seed)
		var route_value: Variant = GameFlow.build_route_for_area(3)
		if not (route_value is Array) or (route_value as Array).size() != 11:
			continue
		var route: Array = route_value as Array
		var assignments: Dictionary = {}
		var used_slots: Dictionary = {}
		var complete := true
		for required_role: String in ["miniboss", "treasure", "shrine", "merchant", "rest", "combat"]:
			var found_slot := -1
			var found_token := ""
			for slot_index: int in range(0, 10):
				if used_slots.has(slot_index):
					continue
				for option: String in _slot_options(slot_index, str(route[slot_index])):
					if str(RouteGenerator.get_base_room_type(option)).to_lower() == required_role:
						found_slot = slot_index
						found_token = option
						break
				if found_slot >= 0:
					break
			if found_slot < 0:
				complete = false
				break
			assignments[found_slot] = found_token
			used_slots[found_slot] = true
		if not complete:
			continue
		var has_three_exit := false
		for slot_index: int in range(0, 10):
			if _slot_options(slot_index, str(route[slot_index])).size() == 3:
				has_three_exit = true
				break
		if has_three_exit:
			return {"seed": seed, "assignments": assignments}
	return {}


func _resolve_route_choices(route: Array) -> Array[String]:
	for slot_index: int in range(route.size()):
		var token := str(route[slot_index])
		if not token.begins_with("CHOICE_"):
			continue
		var options := _slot_options(slot_index, token)
		if options.is_empty():
			_fail("choice slot %d had no options" % slot_index)
			continue
		var chosen := str(_coverage_assignments.get(slot_index, options[0]))
		if not options.has(chosen):
			chosen = options[0]
		RouteGenerator.resolve_choice(slot_index, chosen)
	var out: Array[String] = []
	for value: Variant in RouteGenerator.current_route:
		out.append(str(value).to_lower())
	return out


func _validate_loaded_chamber(index: int) -> void:
	var token := _resolved_route[index]
	var base_role := str(RouteGenerator.get_base_room_type(token)).to_lower()
	_visited_roles[base_role] = true
	_expect(int(GameFlow.current_index) == index, "Chamber %d GameFlow index drift" % (index + 1))

	var loaded_rooms: Array[Node] = []
	for child: Node in _room_container.get_children():
		if child.is_in_group("room"):
			loaded_rooms.append(child)
	_expect(loaded_rooms.size() == 1, "Chamber %d expected one room, got %d" % [index + 1, loaded_rooms.size()])
	if loaded_rooms.size() != 1:
		return
	var room := loaded_rooms[0]
	_expect(int(room.get_meta("area_id", -1)) == 3, "Chamber %d area metadata is not 3" % (index + 1))
	_expect(room.get_node_or_null("PlayerSpawn") != null, "Chamber %d lacks PlayerSpawn" % (index + 1))
	if base_role == "combat":
		_expect(room.scene_file_path == EXPECTED_COMBAT_SCENE, "Kagutsuchi combat leaked to %s" % room.scene_file_path)
	if base_role == "treasure":
		_expect(room.scene_file_path == EXPECTED_TREASURE_SCENE, "Treasure aliases another room")
	if base_role == "boss":
		_validate_shogun_room(room, index)

	var player: Node = GameFlow.player
	_expect(player != null and is_instance_valid(player), "Chamber %d Player missing" % (index + 1))
	if player != null and is_instance_valid(player):
		_expect(player.get_instance_id() == _player_instance_id, "Player recreated at Chamber %d" % (index + 1))
		_expect(_script_path(player) == EXPECTED_PLAYER_SCRIPT, "Wrong Player script at Chamber %d" % (index + 1))
	print("[KagutsuchiFullRunSmoke] Chamber %02d token=%s role=%s scene=%s" % [index + 1, token, base_role, room.scene_file_path])


func _validate_shogun_room(room: Node, index: int) -> void:
	_expect(room.scene_file_path == EXPECTED_BOSS_SCENE, "Chamber %d is not dedicated Eclipse Shogun chamber" % (index + 1))
	var container := room.get_node_or_null("ShogunBoss")
	_expect(container != null, "Eclipse Shogun container missing")
	if container != null:
		var shogun := container.get_node_or_null("EclipseShogun")
		_expect(shogun != null, "Eclipse Shogun actor missing")
		_expect(shogun != null and shogun.has_signal("defeated"), "Eclipse Shogun must expose defeated signal")
		_expect(room.get("_boss") == shogun, "BossChamber did not select Eclipse Shogun as defeat authority")


func _validate_post_shogun_handoff() -> void:
	var bindings_before := int(MetaProgress.get_heart_bindings_destroyed()) if typeof(MetaProgress) == TYPE_OBJECT else -1
	GameFlow.next_room()
	await _wait_frames(10)

	_expect(int(GameFlow.current_index) == 10, "Post-Shogun handoff must not create a counted Chamber 12")
	_expect(int(RunData.depth) == 11, "Counted run depth must finish at exactly 11 Kagutsuchi chambers, got %d" % int(RunData.depth))
	_expect(RunData.path_history.size() == 11, "Counted path history must contain exactly 11 Kagutsuchi entries")
	_expect(int(MetaProgress.get_heart_bindings_destroyed()) == bindings_before, "Loading the Binding handoff must not destroy a Binding before player interaction")

	var handoff: Node = null
	for child: Node in _room_container.get_children():
		if child.scene_file_path == EXPECTED_HANDOFF_SCENE:
			handoff = child
			break
	_expect(handoff != null, "Shogun next_room() did not load the non-counted Heart handoff scene")
	if handoff != null:
		_expect(str(handoff.get("outcome")) == ENDGAME_FLOW.OUTCOME_BINDING_COMPLETION, "Awakened zero-Binding run must enter Binding completion handoff")
		_expect(handoff.get_node_or_null("PlayerSpawn") != null, "Heart handoff missing PlayerSpawn")
		_expect(handoff.get_node_or_null("ExitGate") != null, "Heart handoff missing explicit interaction gate")

	var player: Node = GameFlow.player
	_expect(player != null and is_instance_valid(player), "Player lost during Shogun -> Heart handoff")
	if player != null and is_instance_valid(player):
		_expect(player.get_instance_id() == _player_instance_id, "Shogun -> Heart handoff recreated the Player/build")
		_expect(_script_path(player) == EXPECTED_PLAYER_SCRIPT, "Wrong Player script after Shogun -> Heart handoff")


func _slot_options(slot_index: int, token: String) -> Array[String]:
	if not token.begins_with("CHOICE_"):
		return [token.to_lower()]
	var value: Variant = RouteGenerator.get_choice_options(slot_index)
	var out: Array[String] = []
	if value is Array:
		for option: Variant in value:
			out.append(str(option).to_lower())
	return out


func _script_path(instance: Object) -> String:
	var script_value: Variant = instance.get_script() if instance != null else null
	return (script_value as Script).resource_path if script_value is Script else ""


func _wait_frames(count: int) -> void:
	for _i: int in range(count):
		await get_tree().process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)