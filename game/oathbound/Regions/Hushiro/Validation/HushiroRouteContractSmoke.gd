extends Node

## Headless structural contract for the approved Hushiro route graph.
## Uses the real RouteGenerator/SceneRegistry authority and checks many deterministic
## seeds so route-shape regressions cannot hide behind one startup smoke.

const ROOM_BASE_SCRIPT: Script = preload("res://Core/Chambers/ChamberBase.gd")
const ROUTE_GATE_SCENE: PackedScene = preload("res://Core/Chambers/RouteGate.tscn")
const SEED_COUNT: int = 256

var _failures: Array[String] = []
var _three_exit_routes: int = 0


func _ready() -> void:
	await get_tree().process_frame
	_run_seed_contracts()
	await _validate_dynamic_third_gate()

	if _three_exit_routes <= 0:
		_fail("No seeded route exercised the approved main-band 3-exit branch")

	if _failures.is_empty():
		print("[HushiroRouteContractSmoke] PASS - %d seeds | three-exit routes=%d | guarantees/gates valid" % [SEED_COUNT, _three_exit_routes])
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[HushiroRouteContractSmoke] %s" % failure)
		print("[HushiroRouteContractSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _run_seed_contracts() -> void:
	if typeof(RouteGenerator) != TYPE_OBJECT:
		_fail("RouteGenerator autoload missing")
		return
	if typeof(SceneRegistry) != TYPE_OBJECT:
		_fail("SceneRegistry autoload missing")
		return

	var rooms_value: Variant = SceneRegistry.get("rooms")
	if not (rooms_value is Dictionary):
		_fail("SceneRegistry.rooms is not a Dictionary")
		return
	var rooms: Dictionary = rooms_value as Dictionary
	for required_role: String in ["combat", "shrine", "merchant", "rest", "miniboss", "boss"]:
		if not rooms.has(required_role) or not (rooms[required_role] is PackedScene):
			_fail("SceneRegistry missing current Hushiro room role '%s'" % required_role)

	for seed: int in range(1, SEED_COUNT + 1):
		if _failures.size() >= 40:
			return
		_validate_seed(seed)


func _validate_seed(seed: int) -> void:
	RouteGenerator.set_seed(seed)
	var route_value: Variant = RouteGenerator.generate_area_route(1)
	if not (route_value is Array):
		_fail("seed %d: generator did not return an Array" % seed)
		return
	var route: Array = route_value as Array

	_expect(route.size() == 12, "seed %d: expected 12 counted chambers, got %d" % [seed, route.size()])
	if route.size() != 12:
		return
	_expect(str(route[0]).to_lower() == "combat:technique", "seed %d: Chamber 1 must be fixed combat:technique" % seed)
	_expect(str(RouteGenerator.get_base_room_type(str(route[11]))) == "boss", "seed %d: Chamber 12 must be boss" % seed)

	var technique_slots: Array[int] = []
	var accessible_services: Dictionary = {"shrine": false, "merchant": false, "rest": false}
	var miniboss_accessible: bool = false
	var preboss_support: bool = false
	var three_exit_count: int = 0
	var main_single_streak: int = 0

	for slot_index: int in range(route.size()):
		var chamber_number: int = slot_index + 1
		var token: String = str(route[slot_index])
		var options: Array[String] = _slot_options(slot_index, token)

		if token.begins_with("CHOICE_"):
			_expect(options.size() >= 2 and options.size() <= 3, "seed %d chamber %d: choice must expose 2-3 options, got %d" % [seed, chamber_number, options.size()])
		else:
			_expect(options.size() == 1, "seed %d chamber %d: linear chamber should expose exactly one token" % [seed, chamber_number])

		_validate_distinct_options(seed, chamber_number, options)

		if options.size() == 3:
			three_exit_count += 1
			_expect(chamber_number >= 4 and chamber_number <= 8, "seed %d chamber %d: 3-exit choice outside main band" % [seed, chamber_number])
		if chamber_number <= 3 and chamber_number >= 2:
			_expect(options.size() <= 2, "seed %d chamber %d: opening band cannot expose 3 exits" % [seed, chamber_number])
		if chamber_number >= 9 and chamber_number <= 11:
			_expect(options.size() <= 2, "seed %d chamber %d: pre-boss band cannot expose 3 exits" % [seed, chamber_number])

		if chamber_number >= 4 and chamber_number <= 8:
			if options.size() == 1:
				main_single_streak += 1
				_expect(main_single_streak <= 2, "seed %d chamber %d: more than two consecutive main-band single-exit chambers" % [seed, chamber_number])
			else:
				main_single_streak = 0
		else:
			main_single_streak = 0

		var has_technique: bool = false
		for option: String in options:
			var base: String = str(RouteGenerator.get_base_room_type(option)).to_lower()
			var reward: String = str(RouteGenerator.get_reward_key(option)).to_lower()
			if base == "combat" and reward == "technique":
				has_technique = true
			if accessible_services.has(base):
				accessible_services[base] = true
			if base == "miniboss":
				_expect(chamber_number >= 5 and chamber_number <= 8, "seed %d chamber %d: miniboss outside Chambers 5-8" % [seed, chamber_number])
				miniboss_accessible = true
		if has_technique:
			technique_slots.append(chamber_number)

		if chamber_number == 11:
			for option: String in options:
				var support_base: String = str(RouteGenerator.get_base_room_type(option)).to_lower()
				if support_base in ["rest", "merchant"]:
					preboss_support = true

		if _contains_base(options, "miniboss"):
			var has_non_miniboss: bool = false
			for option: String in options:
				if str(RouteGenerator.get_base_room_type(option)).to_lower() != "miniboss":
					has_non_miniboss = true
					break
			_expect(has_non_miniboss, "seed %d chamber %d: miniboss must compete with a non-miniboss route" % [seed, chamber_number])

	_expect(three_exit_count <= 1, "seed %d: more than one 3-exit choice generated" % seed)
	if three_exit_count == 1:
		_three_exit_routes += 1
	_expect(technique_slots.size() >= 3, "seed %d: fewer than 3 accessible Technique opportunities (%s)" % [seed, str(technique_slots)])
	for service: String in ["shrine", "merchant", "rest"]:
		_expect(bool(accessible_services[service]), "seed %d: no accessible %s opportunity" % [seed, service])
	_expect(miniboss_accessible, "seed %d: no accessible Chambers 5-8 miniboss opportunity" % seed)
	_expect(preboss_support, "seed %d: Chamber 11 lacks Rest/Merchant pre-boss support" % seed)


func _slot_options(slot_index: int, token: String) -> Array[String]:
	if not token.begins_with("CHOICE_"):
		return [token]
	var options_value: Variant = RouteGenerator.get_choice_options(slot_index)
	var out: Array[String] = []
	if options_value is Array:
		for value: Variant in options_value:
			out.append(str(value).to_lower())
	return out


func _validate_distinct_options(seed: int, chamber_number: int, options: Array[String]) -> void:
	var primary_categories: Dictionary = {}
	for option: String in options:
		var category: String = _primary_category(option)
		_expect(not primary_categories.has(category), "seed %d chamber %d: duplicate primary choice category '%s' in %s" % [seed, chamber_number, category, str(options)])
		primary_categories[category] = true


func _primary_category(token: String) -> String:
	var base: String = str(RouteGenerator.get_base_room_type(token)).to_lower()
	if base == "combat":
		var reward: String = str(RouteGenerator.get_reward_key(token)).to_lower()
		return reward if not reward.is_empty() else "combat"
	return base


func _contains_base(options: Array[String], base_type: String) -> bool:
	for option: String in options:
		if str(RouteGenerator.get_base_room_type(option)).to_lower() == base_type:
			return true
	return false


func _validate_dynamic_third_gate() -> void:
	var room_value: Variant = ROOM_BASE_SCRIPT.new()
	if not (room_value is Node2D):
		_fail("Could not instantiate RoomBase for 3-exit gate contract")
		return
	var room: Node2D = room_value as Node2D
	room.name = "ThreeExitContractRoom"
	add_child(room)

	var gate1: Node = ROUTE_GATE_SCENE.instantiate()
	gate1.name = "ExitGate"
	room.add_child(gate1)
	var gate2: Node = ROUTE_GATE_SCENE.instantiate()
	gate2.name = "ExitGate2"
	room.add_child(gate2)
	await get_tree().process_frame

	room.call("setup_exit_gates", ["combat:gold", "shrine", "merchant"])
	await get_tree().process_frame
	var gate3: Node = room.get_node_or_null("ExitGate3")
	_expect(gate3 != null, "RoomBase failed to create ExitGate3 for a legal 3-exit route")
	if gate3 != null:
		_expect(str(gate3.get_meta("next_room_type", "")) == "merchant", "ExitGate3 did not receive the third route token")
		_expect(gate3.has_signal("gate_used"), "ExitGate3 lacks RouteGate gate_used signal")
		if typeof(GameFlow) == TYPE_OBJECT:
			var cb := Callable(GameFlow, "_on_gate_used_from_gate").bind(gate3)
			_expect(gate3.is_connected("gate_used", cb), "ExitGate3 is not wired to authoritative GameFlow")

	room.queue_free()
	await get_tree().process_frame


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
