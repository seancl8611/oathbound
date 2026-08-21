extends Node

## Canonical Technique offer service.
##
## Oathbound Techniques have no global inventory cap and no action-slot occupancy.
## Action Techniques describe what sword action triggers them; owning one never blocks
## another Technique tied to the same action. This service owns current eligibility,
## family cohesion/diversity, rarity/source weighting, refinements, Legendaries, and
## whole-screen Technique rerolls.

signal technique_acquired(technique_id: String, data: Dictionary)

const CATALOG = preload("res://Core/Techniques/TechniqueCatalog.gd")

const SOURCE_STANDARD := "standard"
const SOURCE_SHOP := "shop"
const SOURCE_TREASURE := "treasure"
const SOURCE_MINIBOSS := "miniboss"
const SOURCE_REGIONAL_BOSS := "regional_boss"

const FAMILY_COHESION_WEIGHT := 1.35

const STANDARD_RARITY_WEIGHTS := {
	1: {"common": 55.0, "uncommon": 35.0, "rare": 10.0},
	2: {"common": 35.0, "uncommon": 45.0, "rare": 20.0},
	3: {"common": 20.0, "uncommon": 45.0, "rare": 35.0},
}

const SHOP_RARITY_WEIGHTS := {
	1: {"common": 45.0, "uncommon": 35.0, "rare": 20.0},
	2: {"common": 25.0, "uncommon": 45.0, "rare": 30.0},
	3: {"common": 10.0, "uncommon": 45.0, "rare": 45.0},
}

const PREMIUM_RARITY_WEIGHTS := {
	SOURCE_TREASURE: {"common": 10.0, "uncommon": 40.0, "rare": 50.0},
	SOURCE_MINIBOSS: {"common": 0.0, "uncommon": 35.0, "rare": 65.0},
	SOURCE_REGIONAL_BOSS: {"common": 0.0, "uncommon": 25.0, "rare": 75.0},
}

const LEGENDARY_SCREEN_CHANCE := {
	SOURCE_STANDARD: 0.05,
	SOURCE_SHOP: 0.07,
	SOURCE_TREASURE: 0.10,
	SOURCE_MINIBOSS: 0.12,
	SOURCE_REGIONAL_BOSS: 0.15,
}

const REFINEMENT_SCREEN_CHANCE := {
	SOURCE_STANDARD: 0.25,
	SOURCE_SHOP: 0.25,
	SOURCE_TREASURE: 0.20,
	SOURCE_MINIBOSS: 0.10,
	SOURCE_REGIONAL_BOSS: 0.10,
}


func get_three_choices() -> Array:
	var area_id := 1
	if RunData != null:
		area_id = int(RunData.current_area_id)
	return get_three_choices_for_source(SOURCE_STANDARD, area_id)


func get_three_choices_for_source(source: String, area_id: int = 1, exclude_ids: Array = []) -> Array:
	var acquired := _get_acquired()
	var opening_hushiro := area_id == 1 and acquired.is_empty()
	if opening_hushiro:
		return _generate_opening_hushiro(source, area_id, acquired, exclude_ids)
	return _generate_normal_screen(source, area_id, acquired, exclude_ids)


func reroll_three_choices(source: String, area_id: int, previous_choices: Array) -> Array:
	if RunData == null or not RunData.has_method("spend_technique_reroll"):
		return []
	if not RunData.spend_technique_reroll():
		return []
	var excluded: Array = []
	for choice in previous_choices:
		if choice is Dictionary:
			var id := str(choice.get("id", ""))
			if not id.is_empty():
				excluded.append(id)
	var rerolled := get_three_choices_for_source(source, area_id, excluded)
	if rerolled.size() < 3:
		# Preserve the resource spend but relax immediate-repeat exclusion if the
		# eligible pool is unusually small. Rarity/eligibility rules still hold.
		rerolled = get_three_choices_for_source(source, area_id)
	return rerolled


func apply_upgrade(choice: Dictionary) -> void:
	var id := str(choice.get("id", ""))
	if id.is_empty() or id == "technique_none":
		return
	if not CATALOG.get_entry(id).is_empty():
		RunData.record_upgrade(id)
		var player := get_tree().get_first_node_in_group("player")
		if player != null and "collected_upgrades" in player and id not in player.collected_upgrades:
			player.collected_upgrades.append(id)
		technique_acquired.emit(id, choice.duplicate(true))
		print("[UpgradeService] Technique acquired: %s" % choice.get("displayname", id))


func get_acquired_technique_data() -> Array:
	var out: Array = []
	for id in _get_acquired():
		var data := CATALOG.get_entry(str(id))
		if not data.is_empty():
			data["id"] = str(id)
			out.append(data)
	return out


func _generate_opening_hushiro(source: String, area_id: int, acquired: Array, exclude_ids: Array) -> Array:
	var pool := _eligible_techniques(acquired, exclude_ids)
	var action_pool: Array = []
	for item in pool:
		if str(item.get("kind", "")) == CATALOG.KIND_ACTION:
			action_pool.append(item)

	var choices: Array = []
	var used_families: Array[String] = []
	var used_actions: Array[String] = []
	var rarity_weights := _source_rarity_weights(source, area_id)

	for _i in range(3):
		var preferred: Array = []
		for item in action_pool:
			if str(item.get("family", "")) in used_families:
				continue
			if str(item.get("action", "")) in used_actions:
				continue
			preferred.append(item)
		var selection_pool := preferred if not preferred.is_empty() else action_pool
		if selection_pool.is_empty():
			break
		var pick := _pick_by_source_rarity(selection_pool, rarity_weights, [])
		if pick.is_empty():
			break
		choices.append(pick)
		used_families.append(str(pick.get("family", "")))
		used_actions.append(str(pick.get("action", "")))
		_remove_by_id(action_pool, str(pick.get("id", "")))

	return _fill_screen(choices, pool, rarity_weights, [])


func _generate_normal_screen(source: String, area_id: int, acquired: Array, exclude_ids: Array) -> Array:
	var eligible := _eligible_techniques(acquired, exclude_ids)
	var ordinary: Array = []
	var legendary: Array = []
	for item in eligible:
		match str(item.get("kind", "")):
			CATALOG.KIND_LEGENDARY:
				legendary.append(item)
			CATALOG.KIND_REFINEMENT:
				pass
			_:
				ordinary.append(item)

	var refinements := _eligible_refinements(acquired, exclude_ids)
	var rarity_weights := _source_rarity_weights(source, area_id)
	var owned_families := _owned_families(acquired)
	var choices: Array = []
	var cross_used := false

	# With no slot system there is no empty-slot composition table. Keep one Action
	# Technique on a normal screen whenever one remains eligible so screens do not
	# collapse entirely into narrow optimization cards.
	var action_pool: Array = []
	for item in ordinary:
		if str(item.get("kind", "")) == CATALOG.KIND_ACTION:
			action_pool.append(item)
	if not action_pool.is_empty():
		var first := _pick_by_source_rarity(action_pool, rarity_weights, owned_families)
		if not first.is_empty():
			choices.append(first)
			cross_used = str(first.get("kind", "")) == CATALOG.KIND_CROSS
			_remove_by_id(ordinary, str(first.get("id", "")))

	while choices.size() < 3 and not ordinary.is_empty():
		var filtered := _screen_candidate_pool(ordinary, choices, cross_used)
		if filtered.is_empty():
			filtered = ordinary.duplicate()
		var pick := _pick_by_source_rarity(filtered, rarity_weights, owned_families)
		if pick.is_empty():
			break
		choices.append(pick)
		if str(pick.get("kind", "")) == CATALOG.KIND_CROSS:
			cross_used = true
		_remove_by_id(ordinary, str(pick.get("id", "")))

	choices = _ensure_owned_family_card(choices, eligible, owned_families, rarity_weights)

	var legendary_inserted := false
	if not legendary.is_empty() and not choices.is_empty() and randf() < float(LEGENDARY_SCREEN_CHANCE.get(source, 0.05)):
		var legendary_pick := _weighted_pick(legendary, owned_families)
		var index := choices.size() - 1
		choices[index] = legendary_pick
		legendary_inserted = true

	if not refinements.is_empty() and not choices.is_empty() and randf() < float(REFINEMENT_SCREEN_CHANCE.get(source, 0.25)):
		var refinement_pick := _weighted_pick(refinements, owned_families)
		var refinement_index := choices.size() - 1
		if legendary_inserted and choices.size() >= 2:
			refinement_index = choices.size() - 2
		choices[refinement_index] = refinement_pick

	return _fill_screen(choices, eligible, rarity_weights, owned_families)


func _eligible_techniques(acquired: Array, exclude_ids: Array) -> Array:
	var pool: Array = []
	var counts := _owned_family_counts(acquired)
	var tags := _owned_tags(acquired)
	var families := _owned_families(acquired)

	for id in CATALOG.TECHNIQUES:
		if id in acquired or id in exclude_ids:
			continue
		var data: Dictionary = CATALOG.TECHNIQUES[id].duplicate(true)
		if not _entry_is_eligible(data, acquired, counts, tags, families):
			continue
		data["id"] = id
		pool.append(data)
	return pool


func _eligible_refinements(acquired: Array, exclude_ids: Array) -> Array:
	var pool: Array = []
	for id in CATALOG.REFINEMENTS:
		if id in acquired or id in exclude_ids:
			continue
		var data: Dictionary = CATALOG.REFINEMENTS[id].duplicate(true)
		var parent_id := str(data.get("parent_id", ""))
		if parent_id.is_empty() or parent_id not in acquired:
			continue
		data["id"] = id
		pool.append(data)
	return pool


func _entry_is_eligible(data: Dictionary, acquired: Array, counts: Dictionary, tags: Array[String], families: Array[String]) -> bool:
	var kind := str(data.get("kind", ""))
	if kind == CATALOG.KIND_ACTION:
		return true

	for required_family in data.get("requires_families", []):
		if str(required_family) not in families:
			return false

	var required_all_tags: Array = data.get("requires_all_tags", [])
	for required_tag in required_all_tags:
		if str(required_tag) not in tags:
			return false

	var required_any_tags: Array = data.get("requires_any_tags", [])
	if not required_any_tags.is_empty():
		var found_tag := false
		for required_tag in required_any_tags:
			if str(required_tag) in tags:
				found_tag = true
				break
		if not found_tag:
			return false

	var family := str(data.get("family", ""))
	var min_family_count := int(data.get("min_family_count", 0))
	if min_family_count > 0 and int(counts.get(family, 0)) < min_family_count:
		return false

	if bool(data.get("requires_action_in_family", false)) and not _owns_action_in_family(acquired, family):
		return false

	return true


func _screen_candidate_pool(pool: Array, choices: Array, cross_used: bool) -> Array:
	var out: Array = []
	var family_counts: Dictionary = {}
	for choice in choices:
		var family := str(choice.get("family", ""))
		family_counts[family] = int(family_counts.get(family, 0)) + 1

	for item in pool:
		if cross_used and str(item.get("kind", "")) == CATALOG.KIND_CROSS:
			continue
		var family := str(item.get("family", ""))
		if int(family_counts.get(family, 0)) >= 2:
			var has_other_family := false
			for other in pool:
				if str(other.get("family", "")) != family:
					has_other_family = true
					break
			if has_other_family:
				continue
		out.append(item)
	return out


func _ensure_owned_family_card(choices: Array, eligible: Array, owned_families: Array[String], rarity_weights: Dictionary) -> Array:
	if owned_families.is_empty() or choices.is_empty():
		return choices
	for choice in choices:
		if _entry_advances_owned_family(choice, owned_families):
			return choices

	var candidates: Array = []
	for item in eligible:
		if str(item.get("kind", "")) == CATALOG.KIND_LEGENDARY:
			continue
		if _entry_advances_owned_family(item, owned_families):
			var duplicate := false
			for current in choices:
				if str(current.get("id", "")) == str(item.get("id", "")):
					duplicate = true
					break
			if not duplicate:
				candidates.append(item)
	if candidates.is_empty():
		return choices

	var replacement := _pick_by_source_rarity(candidates, rarity_weights, owned_families)
	if not replacement.is_empty():
		choices[choices.size() - 1] = replacement
	return choices


func _entry_advances_owned_family(entry: Dictionary, owned_families: Array[String]) -> bool:
	var family := str(entry.get("family", ""))
	if family in owned_families:
		return true
	for family_name in entry.get("families", []):
		if str(family_name) in owned_families:
			return true
	return false


func _pick_by_source_rarity(pool: Array, rarity_weights: Dictionary, owned_families: Array[String]) -> Dictionary:
	if pool.is_empty():
		return {}
	var available := _available_rarities(pool)
	var rarity := _roll_available_rarity(rarity_weights, available)
	var rarity_pool: Array = []
	for item in pool:
		if str(item.get("rarity", "common")) == rarity:
			rarity_pool.append(item)
	if rarity_pool.is_empty():
		rarity_pool = pool.duplicate()
	return _weighted_pick(rarity_pool, owned_families)


func _weighted_pick(pool: Array, owned_families: Array[String]) -> Dictionary:
	if pool.is_empty():
		return {}
	var weights: Array[float] = []
	var total := 0.0
	for item in pool:
		var weight := float(item.get("selection_weight", 1.0))
		if _entry_advances_owned_family(item, owned_families):
			weight *= FAMILY_COHESION_WEIGHT
		weights.append(weight)
		total += weight
	if total <= 0.0:
		return pool[0].duplicate(true)
	var roll := randf() * total
	var cumulative := 0.0
	for i in range(pool.size()):
		cumulative += weights[i]
		if roll <= cumulative:
			return pool[i].duplicate(true)
	return pool[pool.size() - 1].duplicate(true)


func _fill_screen(choices: Array, eligible: Array, rarity_weights: Dictionary, owned_families: Array[String]) -> Array:
	var out := choices.duplicate(true)
	var remaining: Array = []
	for item in eligible:
		var already_used := false
		for current in out:
			if str(current.get("id", "")) == str(item.get("id", "")):
				already_used = true
				break
		if not already_used and str(item.get("kind", "")) != CATALOG.KIND_LEGENDARY:
			remaining.append(item)
	while out.size() < 3 and not remaining.is_empty():
		var pick := _pick_by_source_rarity(remaining, rarity_weights, owned_families)
		if pick.is_empty():
			break
		out.append(pick)
		_remove_by_id(remaining, str(pick.get("id", "")))
	while out.size() < 3:
		out.append({
			"id": "technique_none",
			"displayname": "No Eligible Technique",
			"details": "No additional Technique currently satisfies this reward's eligibility rules.",
			"family": "neutral",
			"kind": "none",
			"rarity": "common",
		})
	return out


func _source_rarity_weights(source: String, area_id: int) -> Dictionary:
	var region := clampi(area_id, 1, 3)
	if source == SOURCE_SHOP:
		return SHOP_RARITY_WEIGHTS.get(region, SHOP_RARITY_WEIGHTS[1]).duplicate()
	if PREMIUM_RARITY_WEIGHTS.has(source):
		return PREMIUM_RARITY_WEIGHTS[source].duplicate()
	return STANDARD_RARITY_WEIGHTS.get(region, STANDARD_RARITY_WEIGHTS[1]).duplicate()


func _available_rarities(pool: Array) -> Array[String]:
	var out: Array[String] = []
	for item in pool:
		var rarity := str(item.get("rarity", "common"))
		if rarity != "legendary" and rarity != "refinement" and rarity not in out:
			out.append(rarity)
	return out


func _roll_available_rarity(weights: Dictionary, available: Array[String]) -> String:
	if available.is_empty():
		return "common"
	var total := 0.0
	for rarity in available:
		total += maxf(0.0, float(weights.get(rarity, 0.0)))
	if total <= 0.0:
		return available[randi_range(0, available.size() - 1)]
	var roll := randf() * total
	var cumulative := 0.0
	for rarity in available:
		cumulative += maxf(0.0, float(weights.get(rarity, 0.0)))
		if roll <= cumulative:
			return rarity
	return available[available.size() - 1]


func _get_acquired() -> Array:
	if RunData != null and RunData.has_method("get_acquired_upgrades"):
		return RunData.get_acquired_upgrades().duplicate()
	return []


func _owned_family_counts(acquired: Array) -> Dictionary:
	var counts: Dictionary = {}
	for id in acquired:
		var data := CATALOG.get_entry(str(id))
		if data.is_empty():
			continue
		var kind := str(data.get("kind", ""))
		if kind not in [CATALOG.KIND_ACTION, CATALOG.KIND_SUPPORT]:
			continue
		var family := str(data.get("family", ""))
		counts[family] = int(counts.get(family, 0)) + 1
	return counts


func _owned_families(acquired: Array) -> Array[String]:
	var out: Array[String] = []
	var counts := _owned_family_counts(acquired)
	for family in counts:
		if int(counts[family]) > 0:
			out.append(str(family))
	return out


func _owned_tags(acquired: Array) -> Array[String]:
	var out: Array[String] = []
	for id in acquired:
		var data := CATALOG.get_entry(str(id))
		for tag in data.get("tags", []):
			var token := str(tag)
			if token not in out:
				out.append(token)
	return out


func _owns_action_in_family(acquired: Array, family: String) -> bool:
	for id in acquired:
		var data := CATALOG.get_entry(str(id))
		if str(data.get("kind", "")) == CATALOG.KIND_ACTION and str(data.get("family", "")) == family:
			return true
	return false


func _remove_by_id(pool: Array, id: String) -> void:
	for i in range(pool.size() - 1, -1, -1):
		if str(pool[i].get("id", "")) == id:
			pool.remove_at(i)
			return
