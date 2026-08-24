extends Node

const KAGUTSUCHI_CATALOG = preload("res://Regions/Kagutsuchi/Encounters/KagutsuchiEncounterCatalog.gd")
const SEED_COUNT: int = 256

var _failures: Array[String] = []
var _three_exit_routes: int = 0


func _ready() -> void:
	await get_tree().process_frame
	_validate_registry_and_catalog()
	_run_seed_contracts()

	if _three_exit_routes <= 0:
		_fail("No seeded route exercised the approved Kagutsuchi main-band 3-exit branch")

	if _failures.is_empty():
		print("[KagutsuchiRouteContractSmoke] PASS - %d seeds | 11 chambers | guarantees/roster/Eclipse Shogun valid" % SEED_COUNT)
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[KagutsuchiRouteContractSmoke] %s" % failure)
		print("[KagutsuchiRouteContractSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_registry_and_catalog() -> void:
	if typeof(SceneRegistry) != TYPE_OBJECT:
		_fail("SceneRegistry autoload missing")
		return
	SceneRegistry.activate_area(3)
	var rooms_value: Variant = SceneRegistry.get("rooms")
	if not (rooms_value is Dictionary):
		_fail("SceneRegistry.rooms is not a Dictionary")
		return
	var rooms: Dictionary = rooms_value as Dictionary
	for role: String in ["combat", "shrine", "merchant", "rest", "treasure", "miniboss", "boss"]:
		if not rooms.has(role) or not (rooms[role] is PackedScene):
			_fail("Kagutsuchi registry missing room role %s" % role)

	_expect(_scene_path(rooms.get("combat")) == "res://Regions/Kagutsuchi/Chambers/CombatChamber.tscn", "Area 3 combat does not resolve to canonical Kagutsuchi chamber")
	_expect(_scene_path(rooms.get("boss")) == "res://Regions/Kagutsuchi/Chambers/EclipseShogunChamber.tscn", "Area 3 boss does not resolve to dedicated Eclipse Shogun chamber")
	_expect(_scene_path(rooms.get("treasure")) == "res://Core/Chambers/Types/TreasureChamber.tscn", "Treasure does not resolve to current Treasure chamber")

	var all_enemies_value: Variant = SceneRegistry.get("enemies_by_area")
	if all_enemies_value is Dictionary:
		var area3_value: Variant = (all_enemies_value as Dictionary).get(3, {})
		if area3_value is Dictionary:
			var keys: Array[String] = []
			for key_value: Variant in (area3_value as Dictionary).keys():
				keys.append(str(key_value))
			keys.sort()
			var expected := KAGUTSUCHI_CATALOG.approved_enemy_types()
			expected.sort()
			_expect(keys == expected, "Area 3 enemy registry differs from approved five-enemy Court roster: %s" % str(keys))
		else:
			_fail("SceneRegistry Area 3 enemy roster missing")

	for error_message: String in KAGUTSUCHI_CATALOG.validate_catalog():
		_fail(error_message)


func _run_seed_contracts() -> void:
	if typeof(RouteGenerator) != TYPE_OBJECT or typeof(GameFlow) != TYPE_OBJECT:
		_fail("RouteGenerator/GameFlow autoload missing")
		return
	for seed: int in range(1, SEED_COUNT + 1):
		if _failures.size() >= 50:
			return
		RouteGenerator.set_seed(seed)
		var route_value: Variant = GameFlow.build_route_for_area(3)
		if not (route_value is Array):
			_fail("seed %d: Kagutsuchi route did not return Array" % seed)
			continue
		_validate_seed(seed, route_value as Array)


func _validate_seed(seed: int, route: Array) -> void:
	_expect(route.size() == 11, "seed %d: expected 11 counted chambers, got %d" % [seed, route.size()])
	if route.size() != 11:
		return
	_expect(str(route[0]).begins_with("CHOICE_"), "seed %d: Chamber 1 must branch immediately" % seed)
	_expect(str(RouteGenerator.get_base_room_type(str(route[10]))) == "boss", "seed %d: Chamber 11 must be Eclipse Shogun/boss" % seed)

	var technique_slots: Dictionary = {}
	var services: Dictionary = {"shrine": false, "merchant": false, "rest": false}
	var miniboss_slots: Array[int] = []
	var final_prep := false
	var three_exit_count := 0
	var main_single_streak := 0

	for slot_index: int in range(route.size()):
		var chamber_number := slot_index + 1
		var token := str(route[slot_index])
		var options := _slot_options(slot_index, token)

		if token.begins_with("CHOICE_"):
			_expect(options.size() >= 2 and options.size() <= 3, "seed %d chamber %d: choice must expose 2-3 options" % [seed, chamber_number])
		else:
			_expect(options.size() == 1, "seed %d chamber %d: linear chamber must expose one token" % [seed, chamber_number])

		_validate_distinct_options(seed, chamber_number, options)
		if options.size() == 3:
			three_exit_count += 1
			_expect(chamber_number >= 3 and chamber_number <= 7, "seed %d chamber %d: 3-exit outside Kagutsuchi main stretch" % [seed, chamber_number])
		if chamber_number <= 2 or (chamber_number >= 8 and chamber_number <= 10):
			_expect(options.size() <= 2, "seed %d chamber %d: opening/final stretch cannot expose 3 exits" % [seed, chamber_number])

		if chamber_number >= 3 and chamber_number <= 7:
			if options.size() == 1:
				main_single_streak += 1
				_expect(main_single_streak <= 2, "seed %d chamber %d: >2 consecutive main single exits" % [seed, chamber_number])
			else:
				main_single_streak = 0
		else:
			main_single_streak = 0

		var contains_miniboss := false
		for option: String in options:
			var base := str(RouteGenerator.get_base_room_type(option)).to_lower()
			var reward := str(RouteGenerator.get_reward_key(option)).to_lower()
			_expect(base not in ["shop"], "seed %d chamber %d: legacy shop token leaked into Kagutsuchi" % [seed, chamber_number])
			_expect(reward not in ["boon", "maxhp", "maxposture"], "seed %d chamber %d: legacy reward token leaked into Kagutsuchi: %s" % [seed, chamber_number, option])
			if base == "combat" and reward == "technique":
				technique_slots[chamber_number] = true
			if services.has(base):
				services[base] = true
			if base == "miniboss":
				contains_miniboss = true
				_expect(chamber_number >= 4 and chamber_number <= 7, "seed %d chamber %d: miniboss outside 4-7" % [seed, chamber_number])
			if chamber_number in [9, 10] and (base in ["rest", "merchant", "treasure"] or (base == "combat" and reward == "technique")):
				final_prep = true

		if contains_miniboss:
			miniboss_slots.append(chamber_number)
			var has_non_miniboss := false
			for option: String in options:
				if str(RouteGenerator.get_base_room_type(option)).to_lower() != "miniboss":
					has_non_miniboss = true
					break
			_expect(has_non_miniboss, "seed %d chamber %d: miniboss does not compete with another route" % [seed, chamber_number])

	_expect(three_exit_count <= 1, "seed %d: more than one 3-exit Kagutsuchi branch" % seed)
	if three_exit_count == 1:
		_three_exit_routes += 1
	_expect(technique_slots.size() >= 2, "seed %d: fewer than two Technique opportunities" % seed)
	for service: String in ["shrine", "merchant", "rest"]:
		_expect(bool(services[service]), "seed %d: no accessible %s opportunity" % [seed, service])
	_expect(miniboss_slots.size() == 1, "seed %d: expected exactly one miniboss opportunity, got %s" % [seed, str(miniboss_slots)])
	_expect(final_prep, "seed %d: Chambers 9-10 expose no meaningful final preparation" % seed)


func _slot_options(slot_index: int, token: String) -> Array[String]:
	if not token.begins_with("CHOICE_"):
		return [token]
	var out: Array[String] = []
	var value: Variant = RouteGenerator.get_choice_options(slot_index)
	if value is Array:
		for option_value: Variant in value:
			out.append(str(option_value).to_lower())
	return out


func _validate_distinct_options(seed: int, chamber_number: int, options: Array[String]) -> void:
	var categories: Dictionary = {}
	for option: String in options:
		var category := _primary_category(option)
		_expect(not categories.has(category), "seed %d chamber %d: duplicate route category %s in %s" % [seed, chamber_number, category, str(options)])
		categories[category] = true


func _primary_category(token: String) -> String:
	var base := str(RouteGenerator.get_base_room_type(token)).to_lower()
	if base == "combat":
		var reward := str(RouteGenerator.get_reward_key(token)).to_lower()
		return reward if not reward.is_empty() else "combat"
	return base


func _scene_path(value: Variant) -> String:
	return (value as PackedScene).resource_path if value is PackedScene else ""


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
