extends RefCounted

## Canonical Region 2 route authority.
##
## Mutates the existing RouteGenerator autoload's public route/choice state so current
## GameFlow gate plumbing continues to work while Yomori no longer depends on the
## imported LEGACY_AREA_CONFIGS table.

const TOTAL_CHAMBERS: int = 10
const BOSS_CHAMBER: int = 10
const MINIBOSS_START: int = 4
const MINIBOSS_END: int = 7

const BRANCH_WEIGHTS: Dictionary = {
	"opening": {1: 50.0, 2: 50.0, 3: 0.0},
	"main": {1: 25.0, 2: 70.0, 3: 5.0},
	"preboss": {1: 45.0, 2: 55.0, 3: 0.0},
}

const ROOM_WEIGHTS: Dictionary = {
	"opening": {"combat": 82.0, "shrine": 6.0, "rest": 4.0, "merchant": 2.0, "treasure": 6.0},
	"main": {"combat": 70.0, "shrine": 8.0, "rest": 7.0, "merchant": 7.0, "treasure": 8.0},
	"preboss": {"combat": 58.0, "shrine": 5.0, "rest": 13.0, "merchant": 13.0, "treasure": 11.0},
}

# Current RewardPickup can resolve these four categories directly. The remaining
# approved Health/Spirit/capacity/reroll standard-combat categories stay capability-
# gated until their unified reward bridge is installed; their probability is
# proportionally redistributed instead of emitting a dead token.
const COMBAT_REWARD_WEIGHTS: Dictionary = {
	"technique": 32.0,
	"gold": 20.0,
	"mist": 10.0,
	"scroll": 8.0,
}

const PREBOSS_SUPPORT: Array[String] = ["rest", "merchant", "combat:technique", "treasure"]
const SAFE_SERVICES: Array[String] = ["rest", "merchant"]


static func generate(route_generator: Node) -> Array[String]:
	if route_generator == null:
		return []

	route_generator.current_area = 2
	route_generator.current_route.clear()
	route_generator.pending_choices.clear()

	if int(route_generator._seed) == 0:
		route_generator.set_seed(int(Time.get_unix_time_from_system()) ^ 2674)

	var guarantees: Dictionary = _build_guarantee_slots(route_generator)
	var three_exit_used := false
	var single_main_streak := 0

	# Chambers 1-9 are generated. Chamber 10 is always Twin Maws.
	for chamber_number: int in range(1, BOSS_CHAMBER):
		var forced: Array[String] = _forced_tokens(route_generator, chamber_number, guarantees)
		var branch_count: int = _roll_branch_count(route_generator, chamber_number)

		# Branching begins immediately in Yomori. Guaranteed opportunities must also
		# remain optional route choices rather than forced visits.
		if chamber_number == 1 or not forced.is_empty():
			branch_count = maxi(branch_count, 2)
		branch_count = maxi(branch_count, forced.size())
		branch_count = mini(branch_count, 3)

		if _band(chamber_number) == "main":
			if branch_count == 1:
				single_main_streak += 1
				if single_main_streak > 2:
					branch_count = 2
					single_main_streak = 0
			else:
				single_main_streak = 0

		if branch_count == 3:
			if three_exit_used or _band(chamber_number) != "main":
				branch_count = 2
			else:
				three_exit_used = true

		var slot_index := chamber_number - 1
		if branch_count <= 1:
			route_generator.current_route.append(_roll_room_token(route_generator, chamber_number, []))
		else:
			var options: Array[String] = _build_options(route_generator, chamber_number, branch_count, forced)
			route_generator.pending_choices[slot_index] = options
			route_generator.current_route.append("CHOICE_%d" % slot_index)

	route_generator.current_route.append("boss")
	_validate(route_generator)
	return route_generator.current_route


static func _build_guarantee_slots(route_generator: Node) -> Dictionary:
	# Keep Shrine/Shop/Rest opportunities separated. Yomori's shorter route then uses
	# remaining slots for two Technique offers and one optional miniboss branch.
	var service_candidates: Array[int] = [1, 2, 3, 4, 5, 6, 7]
	route_generator._shuffle_in_place(service_candidates)
	var services: Array[int] = []
	for candidate: int in service_candidates:
		var adjacent := false
		for used: int in services:
			if absi(candidate - used) <= 1:
				adjacent = true
				break
		if not adjacent:
			services.append(candidate)
		if services.size() >= 3:
			break
	if services.size() < 3:
		services = [1, 3, 6]

	var occupied: Array[int] = services.duplicate()
	var technique_candidates: Array[int] = [1, 2, 3, 4, 5, 6, 7]
	for used: int in occupied:
		technique_candidates.erase(used)
	route_generator._shuffle_in_place(technique_candidates)
	var technique_a: int = technique_candidates[0] if technique_candidates.size() > 0 else 2
	var technique_b: int = technique_candidates[1] if technique_candidates.size() > 1 else 7
	occupied.append(technique_a)
	occupied.append(technique_b)

	var miniboss_candidates: Array[int] = [4, 5, 6, 7]
	route_generator._shuffle_in_place(miniboss_candidates)
	var miniboss_slot := miniboss_candidates[0]
	for candidate: int in miniboss_candidates:
		if not occupied.has(candidate):
			miniboss_slot = candidate
			break

	# At least one visible preparation route must exist across Chambers 8-9.
	var preboss_slot: int = 8 if route_generator.rng.randi_range(0, 1) == 0 else 9

	return {
		"shrine": services[0],
		"merchant": services[1],
		"rest": services[2],
		"technique_a": technique_a,
		"technique_b": technique_b,
		"miniboss": miniboss_slot,
		"preboss_support": preboss_slot,
	}


static func _forced_tokens(route_generator: Node, chamber_number: int, guarantees: Dictionary) -> Array[String]:
	var forced: Array[String] = []
	if chamber_number == int(guarantees.get("shrine", -1)):
		forced.append("shrine")
	if chamber_number == int(guarantees.get("merchant", -1)):
		forced.append("merchant")
	if chamber_number == int(guarantees.get("rest", -1)):
		forced.append("rest")
	if chamber_number == int(guarantees.get("technique_a", -1)):
		forced.append("combat:technique")
	if chamber_number == int(guarantees.get("technique_b", -1)):
		forced.append("combat:technique")
	if chamber_number == int(guarantees.get("miniboss", -1)):
		forced.append("miniboss")
	if chamber_number == int(guarantees.get("preboss_support", -1)):
		var prep: String = PREBOSS_SUPPORT[route_generator.rng.randi_range(0, PREBOSS_SUPPORT.size() - 1)]
		if not forced.has(prep):
			forced.append(prep)
	return forced


static func _roll_branch_count(route_generator: Node, chamber_number: int) -> int:
	var weights: Dictionary = BRANCH_WEIGHTS[_band(chamber_number)]
	var roll: float = route_generator.rng.randf_range(0.0, 100.0)
	var cumulative := 0.0
	for count: int in [1, 2, 3]:
		cumulative += float(weights.get(count, 0.0))
		if roll <= cumulative:
			return count
	return 1


static func _build_options(route_generator: Node, chamber_number: int, count: int, forced: Array[String]) -> Array[String]:
	var options: Array[String] = []
	for token: String in forced:
		if not options.has(token):
			options.append(token)

	while options.size() < count:
		var candidate := _roll_room_token(route_generator, chamber_number, options)
		if candidate.is_empty():
			candidate = "combat:" + _roll_combat_reward(route_generator)
		if not route_generator._same_primary_category_exists(candidate, options):
			options.append(candidate)
		else:
			var fallback := _fallback_distinct(route_generator, options)
			if not fallback.is_empty():
				options.append(fallback)
			else:
				break

	# Miniboss is always an optional escalation, never the only route.
	if route_generator._contains_base_type(options, "miniboss"):
		var has_non_miniboss := false
		for option: String in options:
			if route_generator.get_base_room_type(option) != "miniboss":
				has_non_miniboss = true
				break
		if not has_non_miniboss:
			options.append("combat:" + _roll_combat_reward(route_generator))

	route_generator._shuffle_in_place(options)
	return options


static func _roll_room_token(route_generator: Node, chamber_number: int, existing: Array[String]) -> String:
	var weights: Dictionary = ROOM_WEIGHTS[_band(chamber_number)]
	var blocked: Array[String] = []
	for option: String in existing:
		var base: String = route_generator.get_base_room_type(option)
		if base != "combat":
			blocked.append(base)
	var room_type: String = str(route_generator._weighted_pick_string(weights, blocked))
	if room_type.is_empty():
		room_type = "combat"
	if room_type == "combat":
		var reward := _roll_combat_reward(route_generator)
		var candidate := "combat:" + reward
		var attempts := 0
		while route_generator._same_primary_category_exists(candidate, existing) and attempts < 8:
			reward = _roll_combat_reward(route_generator)
			candidate = "combat:" + reward
			attempts += 1
		return candidate
	return room_type


static func _roll_combat_reward(route_generator: Node) -> String:
	return str(route_generator._weighted_pick_string(COMBAT_REWARD_WEIGHTS, []))


static func _fallback_distinct(route_generator: Node, options: Array[String]) -> String:
	for candidate: String in ["combat:technique", "combat:gold", "combat:mist", "combat:scroll", "shrine", "rest", "merchant", "treasure"]:
		if not route_generator._same_primary_category_exists(candidate, options):
			return candidate
	return ""


static func _band(chamber_number: int) -> String:
	if chamber_number <= 2:
		return "opening"
	if chamber_number <= 7:
		return "main"
	return "preboss"


static func _validate(route_generator: Node) -> void:
	if route_generator.current_route.size() != TOTAL_CHAMBERS:
		push_error("[YomoriRouteAuthority] generated %d chambers; expected %d" % [route_generator.current_route.size(), TOTAL_CHAMBERS])
	if route_generator.current_route.is_empty() or not str(route_generator.current_route[0]).begins_with("CHOICE_"):
		push_error("[YomoriRouteAuthority] Chamber 1 must begin with a route choice")
	if route_generator.get_base_room_type(str(route_generator.current_route[BOSS_CHAMBER - 1])) != "boss":
		push_error("[YomoriRouteAuthority] Chamber 10 must be Twin Maws/boss")