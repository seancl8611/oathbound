extends Node

## Headless structural traversal of one legitimate generated Yomori route.
## Combat/reward completion is intentionally bypassed: this validates the real
## GameFlow + RouteGenerator choice resolution, regional SceneRegistry ownership,
## all 10 counted chamber loads, canonical Player persistence, authored Yomori
## encounter selection, Treasure ownership, optional miniboss loading, and the
## Twin Maws endpoint. Interactive combat remains the manual playtest boundary.

const YOMORI_CATALOG = preload("res://Regions/Yomori/Encounters/YomoriEncounterCatalog.gd")
const EXPECTED_PLAYER_SCRIPT: String = "res://Player/OathboundCombatPlayer.gd"
const EXPECTED_COMBAT_SCENE: String = "res://Regions/Yomori/Chambers/CombatChamber.tscn"
const EXPECTED_TWIN_MAWS_SCENE: String = "res://Regions/Yomori/Chambers/TwinMawsChamber.tscn"
const EXPECTED_TREASURE_SCENE: String = "res://Core/Chambers/Types/TreasureChamber.tscn"
const REQUIRED_ROLES: Array[String] = ["combat", "shrine", "merchant", "rest", "treasure", "miniboss", "boss"]
const SEARCH_SEED_LIMIT: int = 4096

var _failures: Array[String] = []
var _room_container: Node2D
var _resolved_route: Array[String] = []
var _coverage_seed: int = 0
var _coverage_assignments: Dictionary = {}
var _visited_roles: Dictionary = {}
var _player_instance_id: int = 0


func _ready() -> void:
	await get_tree().process_frame
	await _run_traversal()
	if _failures.is_empty():
		print("[YomoriFullRunSmoke] PASS - seed=%d | 10 chambers | roles=%s | Twin Maws endpoint | persistent canonical Player=%d" % [
			_coverage_seed,
			str(_visited_roles.keys()),
			_player_instance_id,
		])
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[YomoriFullRunSmoke] %s" % failure)
		print("[YomoriFullRunSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _run_traversal() -> void:
	if typeof(RouteGenerator) != TYPE_OBJECT or typeof(GameFlow) != TYPE_OBJECT:
		_fail("RouteGenerator/GameFlow autoload missing")
		return
	if typeof(SceneRegistry) != TYPE_OBJECT or typeof(RunData) != TYPE_OBJECT:
		_fail("SceneRegistry/RunData autoload missing")
		return

	_prepare_awakened_run_state()
	var plan: Dictionary = _find_coverage_plan()
	if plan.is_empty():
		_fail("Could not find a seeded Yomori route covering combat/Shrine/Merchant/Rest/Treasure/miniboss plus a legal 3-exit branch")
		return
	_coverage_seed = int(plan.get("seed", 0))
	_coverage_assignments = (plan.get("assignments", {}) as Dictionary).duplicate(true)

	RouteGenerator.set_seed(_coverage_seed)
	var generated_value: Variant = GameFlow.build_route_for_area(2)
	if not (generated_value is Array):
		_fail("Coverage seed did not regenerate a Yomori route Array")
		return
	_resolved_route = _resolve_route_choices(generated_value as Array)
	if _resolved_route.size() != 10:
		_fail("Resolved Yomori route has %d chambers instead of 10" % _resolved_route.size())
		return
	for token: String in _resolved_route:
		if token.begins_with("CHOICE_"):
			_fail("Resolved Yomori traversal still contains choice placeholder %s" % token)
			return

	_room_container = Node2D.new()
	_room_container.name = "RoomContainer"
	add_child(_room_container)
	GameFlow.setup(_room_container)
	GameFlow.current_area = 2
	RunData.reset_for_new_run(2)
	GameFlow.set_route(_resolved_route)
	GameFlow.start_run()
	await _wait_frames(8)

	if GameFlow.player == null or not is_instance_valid(GameFlow.player):
		_fail("GameFlow failed to create the canonical Player in Yomori Chamber 1")
		return
	_player_instance_id = GameFlow.player.get_instance_id()

	for index: int in range(_resolved_route.size()):
		_validate_loaded_chamber(index)
		if not _failures.is_empty():
			return
		if index < _resolved_route.size() - 1:
			GameFlow.next_room()
			await _wait_frames(8)

	for required_role: String in REQUIRED_ROLES:
		_expect(_visited_roles.has(required_role), "Traversal never loaded required Yomori room role '%s'" % required_role)
	_expect(int(GameFlow.current_index) == 9, "Traversal should stop on counted Yomori Chamber 10 / index 9")
	_expect(str(RouteGenerator.get_base_room_type(_resolved_route[9])).to_lower() == "boss", "Final Yomori chamber must be Twin Maws/boss")
	_expect(RunData.hushiro_encounters_seen.is_empty(), "Yomori traversal leaked Hushiro encounter tracking: %s" % str(RunData.hushiro_encounters_seen))
	_expect(not RunData.yomori_encounters_seen.is_empty(), "Yomori traversal never registered an authored standard encounter")
	for encounter_id: String in RunData.yomori_encounters_seen:
		_expect(not YOMORI_CATALOG.get_by_id(encounter_id).is_empty(), "Unknown/non-Yomori encounter entered run history: %s" % encounter_id)


func _prepare_awakened_run_state() -> void:
	if typeof(MetaProgress) == TYPE_OBJECT:
		MetaProgress.set("returning_blood_awakened", true)
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("select_aspect"):
		AspectRuntime.call("select_aspect", "wolf")
	if typeof(CorruptionRuntime) == TYPE_OBJECT and CorruptionRuntime.has_method("set_corruption_for_playtest"):
		CorruptionRuntime.call("set_corruption_for_playtest", 0)


func _find_coverage_plan() -> Dictionary:
	for seed: int in range(1, SEARCH_SEED_LIMIT + 1):
		RouteGenerator.set_seed(seed)
		var route_value: Variant = GameFlow.build_route_for_area(2)
		if not (route_value is Array):
			continue
		var route: Array = route_value as Array
		if route.size() != 10:
			continue

		var assignments: Dictionary = {}
		var used_slots: Dictionary = {}
		var complete := true
		# Reserve rarer/structural roles first, each on a distinct counted chamber.
		for required_role: String in ["miniboss", "treasure", "shrine", "merchant", "rest", "combat"]:
			var found_slot := -1
			var found_token := ""
			for slot_index: int in range(0, 9):
				if used_slots.has(slot_index):
					continue
				var options: Array[String] = _slot_options(slot_index, str(route[slot_index]))
				for option: String in options:
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

		var three_exit_slot := -1
		for slot_index: int in range(0, 9):
			if _slot_options(slot_index, str(route[slot_index])).size() == 3:
				three_exit_slot = slot_index
				break
		if three_exit_slot < 0:
			continue

		return {
			"seed": seed,
			"assignments": assignments,
			"three_exit_slot": three_exit_slot,
		}
	return {}


func _resolve_route_choices(route: Array) -> Array[String]:
	var three_exit_slot := -1
	for slot_index: int in range(route.size()):
		if _slot_options(slot_index, str(route[slot_index])).size() == 3:
			three_exit_slot = slot_index
			break

	for slot_index: int in range(route.size()):
		var token: String = str(route[slot_index])
		if not token.begins_with("CHOICE_"):
			continue
		var options: Array[String] = _slot_options(slot_index, token)
		if options.is_empty():
			_fail("Yomori choice slot %d had no options" % slot_index)
			continue
		var chosen: String = str(_coverage_assignments.get(slot_index, ""))
		if chosen.is_empty():
			chosen = options[2] if slot_index == three_exit_slot and options.size() == 3 else options[0]
		if not options.has(chosen):
			_fail("Yomori coverage choice '%s' invalid at slot %d: %s" % [chosen, slot_index, str(options)])
			continue
		RouteGenerator.resolve_choice(slot_index, chosen)

	var out: Array[String] = []
	for value: Variant in RouteGenerator.current_route:
		out.append(str(value).to_lower())
	return out


func _validate_loaded_chamber(index: int) -> void:
	var token: String = _resolved_route[index]
	var base_role: String = str(RouteGenerator.get_base_room_type(token)).to_lower()
	_visited_roles[base_role] = true

	_expect(int(GameFlow.current_index) == index, "Chamber %d: GameFlow index=%d" % [index + 1, int(GameFlow.current_index)])
	_expect(str(GameFlow.route[index]).to_lower() == token, "Chamber %d: GameFlow route token drifted" % [index + 1])

	var loaded_rooms: Array[Node] = []
	for child: Node in _room_container.get_children():
		if child.is_in_group("room"):
			loaded_rooms.append(child)
	_expect(loaded_rooms.size() == 1, "Chamber %d: expected exactly one active room, found %d" % [index + 1, loaded_rooms.size()])
	if loaded_rooms.size() != 1:
		return
	var room: Node = loaded_rooms[0]

	var rooms_value: Variant = SceneRegistry.get("rooms")
	if not (rooms_value is Dictionary):
		_fail("SceneRegistry.rooms unavailable during Yomori Chamber %d" % [index + 1])
		return
	var expected_scene_value: Variant = (rooms_value as Dictionary).get(base_role)
	_expect(expected_scene_value is PackedScene, "Chamber %d: SceneRegistry has no PackedScene for role %s" % [index + 1, base_role])
	if expected_scene_value is PackedScene:
		var expected_scene: PackedScene = expected_scene_value as PackedScene
		_expect(room.scene_file_path == expected_scene.resource_path, "Chamber %d: loaded %s for role %s, expected %s" % [index + 1, room.scene_file_path, base_role, expected_scene.resource_path])

	_expect(int(room.get_meta("area_id", -1)) == 2, "Chamber %d: room area_id metadata must remain Yomori/2" % [index + 1])
	_expect(str(room.get_meta("reward_key", "")).to_lower() == str(RouteGenerator.get_reward_key(token)).to_lower(), "Chamber %d: reward metadata does not match route token %s" % [index + 1, token])
	_expect(room.get_node_or_null("PlayerSpawn") != null, "Chamber %d: room role %s lacks PlayerSpawn" % [index + 1, base_role])

	if base_role == "combat":
		_expect(room.scene_file_path == EXPECTED_COMBAT_SCENE, "Chamber %d: combat leaked outside canonical Yomori chamber" % [index + 1])
	if base_role == "treasure":
		_expect(room.scene_file_path == EXPECTED_TREASURE_SCENE, "Chamber %d: Treasure aliases another room" % [index + 1])
	if base_role == "boss":
		_validate_twin_maws_room(room, index)

	var player: Node = GameFlow.player
	_expect(player != null and is_instance_valid(player), "Chamber %d: canonical Player missing" % [index + 1])
	if player != null and is_instance_valid(player):
		_expect(player.get_instance_id() == _player_instance_id, "Chamber %d: Player was recreated across Yomori rooms" % [index + 1])
		_expect(player.get_parent() == _room_container, "Chamber %d: Player not parented to current RoomContainer" % [index + 1])
		_expect(_script_path(player) == EXPECTED_PLAYER_SCRIPT, "Chamber %d: active Player script=%s" % [index + 1, _script_path(player)])

	if typeof(CorruptionRuntime) == TYPE_OBJECT:
		_expect(str(CorruptionRuntime.get("_encounter_token")).to_lower() == token, "Chamber %d: CorruptionRuntime lifecycle token did not follow Yomori GameFlow" % [index + 1])

	print("[YomoriFullRunSmoke] Chamber %02d token=%s role=%s scene=%s player=%d" % [
		index + 1,
		token,
		base_role,
		room.scene_file_path,
		_player_instance_id,
	])


func _validate_twin_maws_room(room: Node, index: int) -> void:
	_expect(room.scene_file_path == EXPECTED_TWIN_MAWS_SCENE, "Chamber %d: boss endpoint is not Twin Maws" % [index + 1])
	var container: Node = room.get_node_or_null("TwinMaws")
	_expect(container != null, "Chamber %d: Twin Maws container missing" % [index + 1])
	if container == null:
		return
	_expect(container.get_node_or_null("Rootfang") != null, "Chamber %d: Rootfang missing" % [index + 1])
	_expect(container.get_node_or_null("Briarthorn") != null, "Chamber %d: Briarthorn missing" % [index + 1])
	var manager: Node = container.get_node_or_null("TwinMawsManager")
	_expect(manager != null, "Chamber %d: TwinMawsManager missing" % [index + 1])
	if manager != null:
		var selected_boss_value: Variant = room.get("_boss")
		_expect(selected_boss_value == manager, "Chamber %d: BossChamber did not select TwinMawsManager as defeat authority" % [index + 1])


func _slot_options(slot_index: int, token: String) -> Array[String]:
	if not token.begins_with("CHOICE_"):
		return [token.to_lower()]
	var options_value: Variant = RouteGenerator.get_choice_options(slot_index)
	var out: Array[String] = []
	if options_value is Array:
		for value: Variant in options_value:
			out.append(str(value).to_lower())
	return out


func _script_path(instance: Object) -> String:
	if instance == null:
		return ""
	var script_value: Variant = instance.get_script()
	if script_value is Script:
		return (script_value as Script).resource_path
	return ""


func _wait_frames(count: int) -> void:
	for _i: int in range(count):
		await get_tree().process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)