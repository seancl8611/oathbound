extends Node

## Compatibility Technique offer service.
##
## The checked-in runtime still uses the imported UpgradeDB data model while the
## current Technique catalog is migrated. This service deliberately does NOT add a
## global Technique inventory cap or slot limit. It now owns the approved reward-
## source rarity weighting so Combat, Miniboss, and Boss Technique rewards can share
## one source-aware generation path.

const COHESION_BIAS := 1.35
const BIASED_SLOTS := 2
const LEGENDARY_DOMAIN_REQ := 2 # Compatibility gate until current catalog migration.
const FALLBACK_ID := "food"

const SOURCE_STANDARD := "standard"
const SOURCE_SHOP := "shop"
const SOURCE_TREASURE := "treasure"
const SOURCE_MINIBOSS := "miniboss"
const SOURCE_REGIONAL_BOSS := "regional_boss"

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


## Legacy-compatible default entry point.
func get_three_choices() -> Array:
	var area_id := 1
	var rd := get_node_or_null("/root/RunData")
	if rd != null and "current_area_id" in rd:
		area_id = int(rd.current_area_id)
	return get_three_choices_for_source(SOURCE_STANDARD, area_id)


## Generates a three-card Technique screen using the approved source-quality table.
## Eligibility remains based on the currently migrated UpgradeDB data; no artificial
## slot cap is introduced here.
func get_three_choices_for_source(source: String, area_id: int = 1) -> Array:
	var rd := get_node_or_null("/root/RunData")
	var acquired: Array = []
	if rd != null and rd.has_method("get_acquired_upgrades"):
		acquired = rd.get_acquired_upgrades()

	var domain_picks := _count_domain_picks(acquired)
	var eligible := _build_eligible_pool(acquired, domain_picks)
	if eligible.is_empty():
		return _fallback_choices()

	var ordinary: Array = []
	var legendary: Array = []
	for entry in eligible:
		if str(entry.get("rarity", "common")).to_lower() == "legendary":
			legendary.append(entry)
		else:
			ordinary.append(entry)

	var choices: Array = []
	var top_domain := _get_top_domain(domain_picks)
	var weights := _get_source_rarity_weights(source, area_id)

	for i in range(3):
		if ordinary.is_empty():
			break
		var available_rarities := _available_rarities(ordinary)
		var rarity := _roll_available_rarity(weights, available_rarities)
		var rarity_pool := _filter_rarity(ordinary, rarity)
		if rarity_pool.is_empty():
			rarity_pool = ordinary.duplicate()

		var use_bias := i < BIASED_SLOTS and not top_domain.is_empty()
		var pick: Dictionary = _weighted_pick(rarity_pool, top_domain, use_bias)
		choices.append(pick)
		_remove_choice_by_id(ordinary, str(pick.get("id", "")))

	# Legendary is a separate screen-level check and may replace at most one card.
	var legendary_chance := float(LEGENDARY_SCREEN_CHANCE.get(source, 0.05))
	if not legendary.is_empty() and not choices.is_empty() and randf() < legendary_chance:
		var legendary_pick: Dictionary = _weighted_pick(legendary, top_domain, true)
		choices[choices.size() - 1] = legendary_pick

	while choices.size() < 3:
		choices.append(_make_fallback())

	return choices


func apply_upgrade(choice: Dictionary) -> void:
	var id := str(choice.get("id", ""))
	var rd := get_node_or_null("/root/RunData")
	if rd != null and rd.has_method("record_upgrade"):
		rd.record_upgrade(id)

	var player := get_tree().get_first_node_in_group("player")
	if player != null and "collected_upgrades" in player:
		if id not in player.collected_upgrades:
			player.collected_upgrades.append(id)

	# Compatibility fallback from the imported database. This is not a launch
	# consumable system; it remains only while old UpgradeDB entries are migrated.
	if id == "food":
		if player != null and "hp" in player and "maxhp" in player:
			player.hp = min(player.hp + 20, player.maxhp)
			if player.has_method("_update_health_bar"):
				player._update_health_bar()

	print("[UpgradeService] Applied Technique bridge: %s" % choice.get("displayname", id))


func _build_eligible_pool(acquired: Array, domain_picks: Dictionary) -> Array:
	var pool: Array = []
	var db = UpgradeDb.UPGRADES

	for id in db:
		var data = db[id]
		if id in acquired:
			continue
		if not _prereqs_met(data, acquired):
			continue

		# Rare Techniques are not universally gated by prior family investment. Keep
		# only the old Legendary compatibility gate until the current catalog replaces
		# this imported UpgradeDB model.
		var rarity := str(data.get("rarity", "common")).to_lower()
		var domain := str(data.get("domain", ""))
		if rarity == "legendary" and int(domain_picks.get(domain, 0)) < LEGENDARY_DOMAIN_REQ:
			continue

		var entry = data.duplicate()
		entry["id"] = id
		entry["rarity"] = rarity
		pool.append(entry)

	return pool


func _prereqs_met(data: Dictionary, acquired: Array) -> bool:
	var prereqs = data.get("prerequisite", [])
	for prereq in prereqs:
		if prereq not in acquired:
			return false
	return true


func _count_domain_picks(acquired: Array) -> Dictionary:
	var counts: Dictionary = {}
	var db = UpgradeDb.UPGRADES
	for id in acquired:
		if id in db:
			var domain := str(db[id].get("domain", ""))
			if not domain.is_empty() and domain != "item":
				counts[domain] = int(counts.get(domain, 0)) + 1
	return counts


func _get_top_domain(domain_picks: Dictionary) -> String:
	var best_domain := ""
	var best_count := 0
	for domain in domain_picks:
		if int(domain_picks[domain]) > best_count:
			best_count = int(domain_picks[domain])
			best_domain = str(domain)
	return best_domain


func _get_source_rarity_weights(source: String, area_id: int) -> Dictionary:
	var region := clampi(area_id, 1, 3)
	if source == SOURCE_SHOP:
		return SHOP_RARITY_WEIGHTS.get(region, SHOP_RARITY_WEIGHTS[1]).duplicate()
	if PREMIUM_RARITY_WEIGHTS.has(source):
		return PREMIUM_RARITY_WEIGHTS[source].duplicate()
	return STANDARD_RARITY_WEIGHTS.get(region, STANDARD_RARITY_WEIGHTS[1]).duplicate()


func _available_rarities(pool: Array) -> Array[String]:
	var available: Array[String] = []
	for item in pool:
		var rarity := str(item.get("rarity", "common")).to_lower()
		if rarity != "legendary" and not available.has(rarity):
			available.append(rarity)
	return available


func _roll_available_rarity(weights: Dictionary, available: Array[String]) -> String:
	if available.is_empty():
		return "common"

	var total := 0.0
	for rarity in available:
		total += maxf(0.0, float(weights.get(rarity, 0.0)))

	# If source weighting gives zero to every available rarity, redistribute evenly.
	if total <= 0.0:
		return available[randi_range(0, available.size() - 1)]

	var roll := randf() * total
	var cumulative := 0.0
	for rarity in available:
		cumulative += maxf(0.0, float(weights.get(rarity, 0.0)))
		if roll <= cumulative:
			return rarity
	return available[available.size() - 1]


func _filter_rarity(pool: Array, rarity: String) -> Array:
	var out: Array = []
	for item in pool:
		if str(item.get("rarity", "common")).to_lower() == rarity:
			out.append(item)
	return out


func _weighted_pick(pool: Array, top_domain: String, use_bias: bool) -> Dictionary:
	var total_weight := 0.0
	var weights: Array[float] = []
	for item in pool:
		var weight := float(item.get("weight", 1.0))
		if use_bias and str(item.get("domain", "")) == top_domain:
			weight *= COHESION_BIAS
		weights.append(weight)
		total_weight += weight

	if total_weight <= 0.0:
		return pool[0]

	var roll := randf() * total_weight
	var cumulative := 0.0
	for i in range(weights.size()):
		cumulative += weights[i]
		if roll <= cumulative:
			return pool[i]
	return pool[pool.size() - 1]


func _remove_choice_by_id(pool: Array, id: String) -> void:
	for i in range(pool.size() - 1, -1, -1):
		if str(pool[i].get("id", "")) == id:
			pool.remove_at(i)
			return


func _fallback_choices() -> Array:
	return [_make_fallback(), _make_fallback(), _make_fallback()]


func _make_fallback() -> Dictionary:
	if FALLBACK_ID in UpgradeDb.UPGRADES:
		var fallback = UpgradeDb.UPGRADES[FALLBACK_ID].duplicate()
		fallback["id"] = FALLBACK_ID
		return fallback
	return {
		"id": FALLBACK_ID,
		"displayname": "Fallback Recovery",
		"details": "Compatibility fallback while the current Technique catalog is migrated.",
		"rarity": "common",
	}
