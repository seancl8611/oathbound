# RouteGenerator.gd
# Autoload - current Hushiro route generation + legacy Area 2/3 compatibility
extends Node

signal route_generated(route: Array)

# =============================================================================
# HUSHIRO AUTHORITY
# =============================================================================

const HUSHIRO_TOTAL_CHAMBERS: int = 12
const HUSHIRO_BOSS_CHAMBER: int = 12
const HUSHIRO_MINIBOSS_START: int = 5
const HUSHIRO_MINIBOSS_END: int = 8

const HUSHIRO_BRANCH_WEIGHTS: Dictionary = {
	"opening": {1: 50.0, 2: 50.0, 3: 0.0},
	"main": {1: 25.0, 2: 70.0, 3: 5.0},
	"preboss": {1: 45.0, 2: 55.0, 3: 0.0},
}

const HUSHIRO_ROOM_WEIGHTS: Dictionary = {
	"opening": {"combat": 82.0, "shrine": 6.0, "rest": 4.0, "shop": 2.0, "treasure": 6.0},
	"main": {"combat": 70.0, "shrine": 8.0, "rest": 7.0, "shop": 7.0, "treasure": 8.0},
	"preboss": {"combat": 58.0, "shrine": 5.0, "rest": 13.0, "shop": 13.0, "treasure": 11.0},
}

# These are the approved Hushiro Standard Combat reward weights for the reward
# categories that the current playable runtime can actually resolve. Health/Spirit,
# temporary capacity, and Technique rerolls remain capability-gated until their
# current systems replace the imported reward plumbing; their weight is redistributed
# proportionally instead of emitting a dead reward token.
const HUSHIRO_COMBAT_REWARD_WEIGHTS: Dictionary = {
	"technique": 36.0,
	"gold": 20.0,
	"mist": 11.0,
	"scroll": 7.0,
}

const HUSHIRO_SAFE_SERVICES: Array[String] = ["rest", "shop"]
const HUSHIRO_PREBOSS_SUPPORT: Array[String] = ["rest", "shop", "treasure"]

# =============================================================================
# LEGACY LATER-AREA COMPATIBILITY
# =============================================================================
# Yomori/Kagutsuchi are not reconciled in this pass. Keep their imported route data
# isolated here so replacing Hushiro does not make debug warps or later-area plumbing
# unusable. These tables are explicitly NOT design authority.

const LEGACY_TREASURE_SYMBOLS = ["boon", "gold", "mist", "scroll", "maxhp", "maxposture"]

const LEGACY_AREA_CONFIGS = {
	2: {
		"total_rooms": 10,
		"fixed_slots": {5: "treasure", 8: "shop", 9: "boss"},
		"choice_slots": {
			0: ["combat:boon", "combat:gold"],
			1: ["combat:mist", "combat:scroll"],
			2: ["combat:gold", "treasure:boon"],
			3: ["combat:boon", "shrine"],
			4: ["combat:maxhp", "combat:maxposture"],
			6: ["combat:gold", "combat:mist"],
			7: ["combat:boon", "combat:scroll"],
		}
	},
	3: {
		"total_rooms": 12,
		"fixed_slots": {7: "treasure", 10: "shop", 11: "boss"},
		"choice_slots": {
			0: ["combat:boon", "combat:scroll"],
			1: ["combat:gold", "treasure:mist"],
			2: ["combat:mist", "shrine"],
			3: ["combat:maxhp", "combat:maxposture"],
			4: ["combat:boon", "combat:gold"],
			5: ["combat:scroll", "treasure:gold"],
			6: ["combat:boon", "combat:mist"],
			8: ["combat:gold", "rest"],
			9: ["combat:boon", "combat:scroll"],
		}
	},
	4: {
		"total_rooms": 5,
		"fixed_slots": {0: "shop", 4: "boss"},
		"choice_slots": {
			1: ["combat:gold", "combat:maxhp"],
			2: ["combat:boon", "combat:mist"],
			3: ["combat:boon", "combat:maxposture"],
		}
	},
}

# =============================================================================
# RUNTIME STATE
# =============================================================================

var current_route: Array[String] = []
var pending_choices: Dictionary = {} # slot_index -> Array[String]
var current_area: int = 1

var rng := RandomNumberGenerator.new()
var _seed: int = 0

var _hushiro_three_exit_used: bool = false
var _hushiro_single_main_streak: int = 0
var _hushiro_guarantee_slots: Dictionary = {}
var _hushiro_miniboss_token: String = ""


func set_seed(seed: int) -> void:
	_seed = seed
	rng.seed = seed


func _shuffle_in_place(arr: Array) -> void:
	for i in range(arr.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = arr[i]
		arr[i] = arr[j]
		arr[j] = tmp


func get_base_room_type(token: String) -> String:
	if token == null:
		return ""
	var s := str(token).to_lower()
	if s.begins_with("choice_"):
		return s
	var parts := s.split(":", false)
	return parts[0] if parts.size() > 0 else s


func get_reward_key(token: String) -> String:
	if token == null:
		return ""
	var s := str(token).to_lower()
	var parts := s.split(":", false)
	return parts[1] if parts.size() > 1 else ""


func generate_area_route(area_id: int = 1) -> Array[String]:
	current_area = area_id
	current_route.clear()
	pending_choices.clear()

	if _seed == 0:
		set_seed(int(Time.get_unix_time_from_system()) ^ (area_id * 1337))

	if area_id == 1:
		_generate_hushiro_route()
	else:
		_generate_legacy_area_route(area_id)

	_print_route()
	emit_signal("route_generated", current_route)
	return current_route


# =============================================================================
# HUSHIRO ROUTE GENERATION
# =============================================================================

func _generate_hushiro_route() -> void:
	_hushiro_three_exit_used = false
	_hushiro_single_main_streak = 0
	_hushiro_guarantee_slots = _build_hushiro_guarantee_slots()
	_hushiro_miniboss_token = _pick_hushiro_miniboss_token() if _miniboss_runtime_available() else ""

	if _hushiro_miniboss_token.is_empty():
		push_warning("[RouteGenerator] Hushiro miniboss route is structurally supported but no Area 1 miniboss room is registered yet; skipping the runtime offer instead of generating a dead route.")

	# Chamber 1 is fixed by authority: authored standard Combat + Technique reward.
	current_route.append("combat:technique")

	# Chambers 2-11 are generated by chamber band. Chamber 12 is Keeper.
	for chamber_number in range(2, HUSHIRO_BOSS_CHAMBER):
		var forced_tokens: Array[String] = _forced_hushiro_tokens(chamber_number)
		var branch_count: int = _roll_hushiro_branch_count(chamber_number)

		# A guaranteed opportunity must be an actual choice, not a forced visit.
		if not forced_tokens.is_empty():
			branch_count = maxi(branch_count, 2)

		# Chamber 11 must expose meaningful pre-boss preparation.
		if chamber_number == 11:
			branch_count = maxi(branch_count, 2)

		# No more than two consecutive ordinary forced one-exit chambers in the main stretch.
		if _hushiro_band(chamber_number) == "main":
			if branch_count == 1:
				_hushiro_single_main_streak += 1
				if _hushiro_single_main_streak > 2:
					branch_count = 2
					_hushiro_single_main_streak = 0
			else:
				_hushiro_single_main_streak = 0

		# Three-exit choices may occur only in the main stretch and at most once.
		if branch_count == 3:
			if _hushiro_three_exit_used or _hushiro_band(chamber_number) != "main":
				branch_count = 2
			else:
				_hushiro_three_exit_used = true

		var slot_index: int = chamber_number - 1
		if branch_count <= 1:
			current_route.append(_roll_hushiro_room_token(chamber_number, []))
		else:
			var options: Array[String] = _build_hushiro_options(chamber_number, branch_count, forced_tokens)
			pending_choices[slot_index] = options
			current_route.append("CHOICE_%d" % slot_index)

	current_route.append("boss")
	_validate_hushiro_route_shape()


func _build_hushiro_guarantee_slots() -> Dictionary:
	# Spread required network opportunities across Chambers 2-10. Service slots are
	# selected so Shrine/Shop/Rest do not become a predetermined back-to-back safe run.
	var service_slots: Array[int] = []
	var service_candidates: Array[int] = [2, 3, 4, 5, 6, 7, 8, 9, 10]
	_shuffle_in_place(service_candidates)

	for candidate: int in service_candidates:
		var adjacent := false
		for used: int in service_slots:
			if absi(candidate - used) <= 1:
				adjacent = true
				break
		if not adjacent:
			service_slots.append(candidate)
		if service_slots.size() >= 3:
			break

	# Extremely defensive fallback for unusual future chamber-window edits.
	if service_slots.size() < 3:
		service_slots = [3, 6, 9]

	var occupied: Array[int] = service_slots.duplicate()
	var technique_candidates: Array[int] = [2, 3, 4, 5, 6, 7, 8, 9, 10]
	for used: int in occupied:
		technique_candidates.erase(used)
	_shuffle_in_place(technique_candidates)

	var technique_a: int = technique_candidates[0] if technique_candidates.size() > 0 else 4
	var technique_b: int = technique_candidates[1] if technique_candidates.size() > 1 else 8
	occupied.append(technique_a)
	occupied.append(technique_b)

	var miniboss_slot: int = 0
	var miniboss_candidates: Array[int] = [5, 6, 7, 8]
	_shuffle_in_place(miniboss_candidates)
	for candidate: int in miniboss_candidates:
		if not occupied.has(candidate):
			miniboss_slot = candidate
			break
	if miniboss_slot == 0:
		miniboss_slot = miniboss_candidates[0]

	return {
		"shrine": service_slots[0],
		"shop": service_slots[1],
		"rest": service_slots[2],
		"technique_a": technique_a,
		"technique_b": technique_b,
		"miniboss": miniboss_slot,
	}


func _forced_hushiro_tokens(chamber_number: int) -> Array[String]:
	var forced: Array[String] = []

	if chamber_number == int(_hushiro_guarantee_slots.get("shrine", -1)):
		forced.append("shrine")
	if chamber_number == int(_hushiro_guarantee_slots.get("shop", -1)):
		forced.append("shop")
	if chamber_number == int(_hushiro_guarantee_slots.get("rest", -1)):
		forced.append("rest")
	if chamber_number == int(_hushiro_guarantee_slots.get("technique_a", -1)):
		forced.append("combat:technique")
	if chamber_number == int(_hushiro_guarantee_slots.get("technique_b", -1)):
		forced.append("combat:technique")
	if chamber_number == int(_hushiro_guarantee_slots.get("miniboss", -1)) and not _hushiro_miniboss_token.is_empty():
		forced.append(_hushiro_miniboss_token)

	if chamber_number == 11:
		forced.append(str(HUSHIRO_PREBOSS_SUPPORT[rng.randi_range(0, HUSHIRO_PREBOSS_SUPPORT.size() - 1)]))

	return forced


func _roll_hushiro_branch_count(chamber_number: int) -> int:
	var band: String = _hushiro_band(chamber_number)
	var weights: Dictionary = HUSHIRO_BRANCH_WEIGHTS[band]
	var roll := rng.randf_range(0.0, 100.0)
	var cumulative := 0.0
	for count: int in [1, 2, 3]:
		cumulative += float(weights.get(count, 0.0))
		if roll <= cumulative:
			return count
	return 1


func _build_hushiro_options(chamber_number: int, count: int, forced_tokens: Array[String]) -> Array[String]:
	var options: Array[String] = []
	for token: String in forced_tokens:
		if not options.has(token):
			options.append(token)

	while options.size() < count:
		var candidate: String = _roll_hushiro_room_token(chamber_number, options)
		if candidate.is_empty():
			candidate = "combat:" + _roll_hushiro_combat_reward()
		if not _same_primary_category_exists(candidate, options):
			options.append(candidate)
		elif options.size() == 0:
			options.append(candidate)
		else:
			# Deterministic escape from pathological rerolls.
			var fallback := _fallback_distinct_option(options)
			if not fallback.is_empty():
				options.append(fallback)

		if options.size() >= count:
			break

	# A miniboss must always compete with at least one non-miniboss route.
	if _contains_base_type(options, "miniboss"):
		var has_non_miniboss := false
		for option: String in options:
			if get_base_room_type(option) != "miniboss":
				has_non_miniboss = true
				break
		if not has_non_miniboss:
			options.append("combat:" + _roll_hushiro_combat_reward())

	_shuffle_in_place(options)
	return options


func _roll_hushiro_room_token(chamber_number: int, existing_options: Array[String]) -> String:
	var band: String = _hushiro_band(chamber_number)
	var weights: Dictionary = HUSHIRO_ROOM_WEIGHTS[band]
	var blocked_types: Array[String] = []

	# Do not create duplicate primary choices in one branch presentation.
	for existing: String in existing_options:
		var base := get_base_room_type(existing)
		if base != "combat":
			blocked_types.append(base)

	var room_type: String = _weighted_pick_string(weights, blocked_types)
	if room_type.is_empty():
		room_type = "combat"

	if room_type == "combat":
		var reward := _roll_hushiro_combat_reward()
		var candidate := "combat:" + reward
		var attempts := 0
		while _same_primary_category_exists(candidate, existing_options) and attempts < 8:
			reward = _roll_hushiro_combat_reward()
			candidate = "combat:" + reward
			attempts += 1
		return candidate

	return room_type


func _roll_hushiro_combat_reward() -> String:
	return _weighted_pick_string(HUSHIRO_COMBAT_REWARD_WEIGHTS, [])


func _weighted_pick_string(weights: Dictionary, excluded: Array[String]) -> String:
	var total := 0.0
	for key_value: Variant in weights.keys():
		var key := str(key_value)
		if excluded.has(key):
			continue
		total += float(weights[key_value])

	if total <= 0.001:
		return ""

	var roll := rng.randf_range(0.0, total)
	var cumulative := 0.0
	for key_value: Variant in weights.keys():
		var key := str(key_value)
		if excluded.has(key):
			continue
		cumulative += float(weights[key_value])
		if roll <= cumulative:
			return key

	return ""


func _same_primary_category_exists(candidate: String, options: Array[String]) -> bool:
	var category := _primary_category(candidate)
	for option: String in options:
		if _primary_category(option) == category:
			return true
	return false


func _primary_category(token: String) -> String:
	var base := get_base_room_type(token)
	if base == "combat":
		var reward := get_reward_key(token)
		return reward if not reward.is_empty() else "combat"
	return base


func _fallback_distinct_option(options: Array[String]) -> String:
	for candidate: String in ["combat:technique", "combat:gold", "combat:mist", "combat:scroll", "shrine", "rest", "shop", "treasure"]:
		if not _same_primary_category_exists(candidate, options):
			return candidate
	return ""


func _contains_base_type(options: Array[String], base_type: String) -> bool:
	for option: String in options:
		if get_base_room_type(option) == base_type:
			return true
	return false


func _hushiro_band(chamber_number: int) -> String:
	if chamber_number <= 3:
		return "opening"
	if chamber_number <= 8:
		return "main"
	return "preboss"


func _pick_hushiro_miniboss_token() -> String:
	return "miniboss:ogre" if rng.randf() < 0.5 else "miniboss:collector"


func _miniboss_runtime_available() -> bool:
	var registry := get_node_or_null("/root/SceneRegistry")
	if registry == null:
		return false
	var rooms_value: Variant = registry.get("rooms")
	if typeof(rooms_value) != TYPE_DICTIONARY:
		return false
	return (rooms_value as Dictionary).has("miniboss")


func _validate_hushiro_route_shape() -> void:
	if current_route.size() != HUSHIRO_TOTAL_CHAMBERS:
		push_error("[RouteGenerator] Hushiro generated %d chambers; expected %d." % [current_route.size(), HUSHIRO_TOTAL_CHAMBERS])
	if current_route.is_empty() or current_route[0] != "combat:technique":
		push_error("[RouteGenerator] Hushiro Chamber 1 must be combat:technique.")
	if current_route.size() >= HUSHIRO_BOSS_CHAMBER and get_base_room_type(current_route[HUSHIRO_BOSS_CHAMBER - 1]) != "boss":
		push_error("[RouteGenerator] Hushiro Chamber 12 must be Keeper/boss.")


# =============================================================================
# LEGACY AREA 2/3 GENERATION
# =============================================================================

func _generate_legacy_area_route(area_id: int) -> void:
	var config = LEGACY_AREA_CONFIGS.get(area_id)
	if config == null:
		push_error("[RouteGenerator] Unknown area: %d" % area_id)
		return

	for slot in range(int(config.total_rooms)):
		if config.fixed_slots.has(slot):
			var fixed_token = str(config.fixed_slots[slot]).to_lower()
			if fixed_token == "treasure":
				var sym = LEGACY_TREASURE_SYMBOLS[rng.randi_range(0, LEGACY_TREASURE_SYMBOLS.size() - 1)]
				current_route.append("treasure:" + sym)
			else:
				current_route.append(fixed_token)
		elif config.choice_slots.has(slot):
			var options: Array = config.choice_slots[slot].duplicate(true)
			for k in range(options.size()):
				options[k] = str(options[k]).to_lower()
			_shuffle_in_place(options)
			pending_choices[slot] = options
			current_route.append("CHOICE_%d" % slot)
		else:
			current_route.append("combat:gold")


# =============================================================================
# CHOICE / DISPLAY API
# =============================================================================

func resolve_choice(slot_index: int, chosen_type: String) -> void:
	if not pending_choices.has(slot_index):
		push_warning("[RouteGenerator] No pending choice at slot %d" % slot_index)
		return

	var chosen := str(chosen_type).to_lower()
	var options: Array = pending_choices[slot_index]
	if not (chosen in options):
		push_error("[RouteGenerator] Invalid choice '%s'. Options were: %s" % [chosen, options])
		return

	current_route[slot_index] = chosen
	pending_choices.erase(slot_index)
	print("[RouteGenerator] Resolved slot %d -> %s" % [slot_index, chosen])


func get_choice_options(slot_index: int) -> Array:
	return pending_choices.get(slot_index, [])


func is_pending_choice(slot_index: int) -> bool:
	return pending_choices.has(slot_index)


func get_room_at(slot_index: int) -> String:
	if slot_index < 0 or slot_index >= current_route.size():
		return ""
	return current_route[slot_index]


func get_room_display_info(room_type: String) -> Dictionary:
	var token = str(room_type).to_lower()
	var base = get_base_room_type(token)
	var reward = get_reward_key(token)

	var info = {
		"combat": {"icon": "⚔", "color": Color(0.9, 0.2, 0.2), "desc": "Battle awaits"},
		"shrine": {"icon": "✦", "color": Color(0.8, 0.2, 0.2), "desc": "Face the Shrine"},
		"shop": {"icon": "$", "color": Color(0.9, 0.8, 0.2), "desc": "Spend Gold"},
		"treasure": {"icon": "◆", "color": Color(0.2, 0.8, 0.9), "desc": "Claim a premium reward"},
		"rest": {"icon": "+", "color": Color(0.7, 0.9, 0.7), "desc": "Recover Health and Spirit"},
		"miniboss": {"icon": "!", "color": Color(0.85, 0.35, 0.2), "desc": "Optional elite challenge"},
		"boss": {"icon": "X", "color": Color(0.6, 0.1, 0.1), "desc": "Keeper of the Gate"},
		"choice": {"icon": "?", "color": Color(0.7, 0.7, 0.9), "desc": "Choose among three routes"},
		"end": {"icon": "✓", "color": Color(0.3, 0.9, 0.3), "desc": "Victory"},
	}

	var out: Dictionary = info.get(base, {"icon": "?", "color": Color.WHITE, "desc": "Unknown"}).duplicate()

	match reward:
		"technique":
			out["icon"] = "T"
			out["desc"] = "Fight for a Technique"
		"gold":
			out["icon"] = "$"
			out["desc"] = "Fight for Gold" if base == "combat" else "Claim Gold"
		"mist":
			out["icon"] = "M"
			out["desc"] = "Fight for Mist" if base == "combat" else "Claim Mist"
		"scroll":
			out["icon"] = "S"
			out["desc"] = "Fight for a Scroll" if base == "combat" else "Claim Scrolls"
		"ogre":
			out["desc"] = "Village Ogre"
		"collector":
			out["desc"] = "The Collector"
		# Later-area compatibility only.
		"boon":
			out["icon"] = "T"
			out["desc"] = "Legacy build reward"
		"maxhp":
			out["desc"] = "Legacy vitality reward"
		"maxposture":
			out["desc"] = "Legacy posture reward"

	return out


func _print_route() -> void:
	print("\n[RouteGenerator] === AREA %d ROUTE ===" % current_area)
	for i in range(current_route.size()):
		var room = current_route[i]
		var extra = ""
		if room.begins_with("CHOICE_"):
			var slot = int(room.split("_")[1])
			extra = " -> %s" % str(pending_choices.get(slot, []))
		print("  [%d] %s%s" % [i, room, extra])
	print("================================\n")
