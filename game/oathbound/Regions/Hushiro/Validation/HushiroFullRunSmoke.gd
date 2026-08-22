extends Node

## Headless structural traversal of one legitimate generated Hushiro route.
## The smoke deliberately bypasses combat completion/reward pickup so it can validate
## all 12 counted chamber loads quickly; it does not replace an interactive combat
## playtest. Route generation, choice resolution, GameFlow, SceneRegistry, RunData,
## the canonical Player factory, and per-room lifecycle are all the real runtime paths.

const EXPECTED_PLAYER_SCRIPT: String = "res://Player/OathboundCombatPlayer.gd"
const REQUIRED_ROLES: Array[String] = ["combat", "shrine", "merchant", "rest", "miniboss", "boss"]
const SEARCH_SEED_LIMIT: int = 1024

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
		print("[HushiroFullRunSmoke] PASS - seed=%d | 12 chambers | roles=%s | persistent canonical Player=%d" % [
			_coverage_seed,
			str(_visited_roles.keys()),
			_player_instance_id,
		])
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[HushiroFullRunSmoke] %s" % failure)
		print("[HushiroFullRunSmoke] FAIL count=%d" % _failures.size())
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
		_fail("Could not find a seeded Hushiro route with distinct Shrine/Merchant/Rest/Miniboss visits and a legal 3-exit branch")
		return
	_coverage_seed = int(plan.get("seed", 0))
	_coverage_assignments = (plan.get("assignments", {}) as Dictionary).duplicate(true)

	RouteGenerator.set_seed(_coverage_seed)
	var generated_value: Variant = RouteGenerator.generate_area_route(1)
	if not (generated_value is Array):
		_fail("Coverage seed did not regenerate a route Array")
		return
	_resolved_route = _resolve_route_choices(generated_value as Array)
	if _resolved_route.size() != 12:
		_fail("Resolved route has %d chambers instead of 12" % _resolved_route.size())
		return
	for token: String in _resolved_route:
		if token.begins_with("CHOICE_"):
			_fail("Resolved traversal route still contains choice placeholder %s" % token)
			return

	_room_container = Node2D.new()
	_room_container.name = "RoomContainer"
	add_child(_room_container)
	GameFlow.setup(_room_container)
	GameFlow.current_area = 1
	RunData.reset_for_new_run(1)
	GameFlow.set_route(_resolved_route)
	GameFlow.start_run()
	await _wait_frames(6)

	if GameFlow.player == null or not is_instance_valid(GameFlow.player):
		_fail("GameFlow failed to create the canonical Player in Chamber 1")
		return
	_player_instance_id = GameFlow.player.get_instance_id()

	for index: int in range(_resolved_route.size()):
		_validate_loaded_chamber(index)
		if not _failures.is_empty():
			return
		if index < _resolved_route.size() - 1:
			GameFlow.next_room()
			await _wait_frames(6)

	for required_role: String in REQUIRED_ROLES:
		_expect(_visited_roles.has(required_role), "Traversal never loaded required Hushiro room role '%s'" % required_role)
	_expect(int(GameFlow.current_index) == 11, "Traversal should stop on counted Chamber 12 / index 11")
	_expect(str(RouteGenerator.get_base_room_type(_resolved_route[11])).to_lower() == "boss", "Final loaded chamber must be Keeper/boss")


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
		var route_value: Variant = RouteGenerator.generate_area_route(1)
		if not (route_value is Array):
			continue
		var route: Array = route_value as Array
		if route.size() != 12:
			continue

		var assignments: Dictionary = {}
		var used_slots: Dictionary = {}
		var complete: bool = true
		# Miniboss is the rarest required visit; reserve it first, then the three safe/service roles.
		for required_role: String in ["miniboss", "shrine", "merchant", "rest"]:
			var found_slot: int = -1
			var found_token: String = ""
			for slot_index: int in range(1, 11):
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

		var three_exit_slot: int = -1
		for slot_index: int in range(1, 11):
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
	var three_exit_slot: int = -1
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
			_fail("Choice slot %d had no options" % slot_index)
			continue
		var chosen: String = str(_coverage_assignments.get(slot_index, ""))
		if chosen.is_empty():
			# Exercise resolution of the third option on the legal 3-exit branch when that
			# slot is not already reserved for a coverage role.
			chosen = options[2] if slot_index == three_exit_slot and options.size() == 3 else options[0]
		if not options.has(chosen):
			_fail("Coverage choice '%s' is no longer valid at slot %d: %s" % [chosen, slot_index, str(options)])
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
	_expect(str(GameFlow.route[index]).to_lower() == token, "Chamber %d: GameFlow route token drifted from resolved route" % [index + 1])

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
		_fail("SceneRegistry.rooms unavailable during Chamber %d" % [index + 1])
		return
	var expected_scene_value: Variant = (rooms_value as Dictionary).get(base_role)
	_expect(expected_scene_value is PackedScene, "Chamber %d: SceneRegistry has no PackedScene for role %s" % [index + 1, base_role])
	if expected_scene_value is PackedScene:
		var expected_scene: PackedScene = expected_scene_value as PackedScene
		_expect(room.scene_file_path == expected_scene.resource_path, "Chamber %d: loaded %s for role %s, expected %s" % [index + 1, room.scene_file_path, base_role, expected_scene.resource_path])

	_expect(int(room.get_meta("area_id", -1)) == 1, "Chamber %d: room area_id metadata must remain Hushiro/1" % [index + 1])
	_expect(str(room.get_meta("reward_key", "")).to_lower() == str(RouteGenerator.get_reward_key(token)).to_lower(), "Chamber %d: reward metadata does not match route token %s" % [index + 1, token])
	_expect(room.get_node_or_null("PlayerSpawn") != null, "Chamber %d: current room role %s lacks PlayerSpawn" % [index + 1, base_role])

	var player: Node = GameFlow.player
	_expect(player != null and is_instance_valid(player), "Chamber %d: canonical Player missing" % [index + 1])
	if player != null and is_instance_valid(player):
		_expect(player.get_instance_id() == _player_instance_id, "Chamber %d: Player was recreated instead of persisting across rooms" % [index + 1])
		_expect(player.get_parent() == _room_container, "Chamber %d: Player not parented to current RoomContainer" % [index + 1])
		_expect(_script_path(player) == EXPECTED_PLAYER_SCRIPT, "Chamber %d: active Player script=%s" % [index + 1, _script_path(player)])

	if typeof(CorruptionRuntime) == TYPE_OBJECT:
		_expect(str(CorruptionRuntime.get("_encounter_token")).to_lower() == token, "Chamber %d: CorruptionRuntime room lifecycle token did not follow GameFlow" % [index + 1])

	if index == 0:
		var seen_value: Variant = RunData.get("hushiro_encounters_seen")
		if seen_value is Array:
			var seen: Array = seen_value as Array
			_expect(not seen.is_empty(), "Chamber 1 did not register an authored Hushiro encounter")
			if not seen.is_empty():
				_expect(str(seen[0]) == "H01_broken_patrol", "Chamber 1 must start fixed H01_broken_patrol, got %s" % str(seen[0]))

	print("[HushiroFullRunSmoke] Chamber %02d token=%s role=%s scene=%s player=%d" % [
		index + 1,
		token,
		base_role,
		room.scene_file_path,
		_player_instance_id,
	])


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
