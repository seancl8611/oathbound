extends Node

# ─── Tuning ───────────────────────────────────────────────
const COHESION_BIAS = 1.35        # weight multiplier for top-domain slots
const BIASED_SLOTS = 2            # of 3 choices, how many get cohesion bias
const LEGENDARY_DOMAIN_REQ = 2    # domain picks needed before legendary can appear
const RARE_DOMAIN_REQ = 1         # domain picks needed before rare can appear
const FALLBACK_ID = "food"

# ─── Public API ───────────────────────────────────────────

## Returns 3 choice dicts, each with an "id" key matching UpgradeDB.UPGRADES.
## `acquired` = Array[String] of upgrade IDs the player has picked this run.
func get_three_choices() -> Array:
	var rd = get_node_or_null("/root/RunData")
	var acquired: Array = []
	if rd and rd.has_method("get_acquired_upgrades"):
		acquired = rd.get_acquired_upgrades()

	var domain_picks = _count_domain_picks(acquired)
	var pool = _build_eligible_pool(acquired, domain_picks)

	if pool.size() == 0:
		return _fallback_choices()

	var choices: Array = []
	var top_domain = _get_top_domain(domain_picks)

	for i in 3:
		if pool.size() == 0:
			break
		var use_bias = (i < BIASED_SLOTS and top_domain != "")
		var pick = _weighted_pick(pool, top_domain, use_bias)
		choices.append(pick)
		for j in pool.size():
			if pool[j]["id"] == pick["id"]:
				pool.remove_at(j)
				break

	while choices.size() < 3:
		choices.append(_make_fallback())

	return choices

# REPLACE apply_upgrade
func apply_upgrade(choice: Dictionary) -> void:
	var id = choice.get("id", "")
	var rd = get_node_or_null("/root/RunData")
	if rd and rd.has_method("record_upgrade"):
		rd.record_upgrade(id)
	
	var player = get_tree().get_first_node_in_group("player")
	if player and "collected_upgrades" in player:
		if id not in player.collected_upgrades:
			player.collected_upgrades.append(id)
	
	# Handle food heal directly
	if id == "food":
		if player and "hp" in player and "max_hp" in player:
			player.hp = min(player.hp + 20, player.max_hp)
			print("[UpgradeService] Healed 20 HP")
	
	print("[UpgradeService] Applied: %s" % choice.get("displayname", id))
	
func _build_eligible_pool(acquired: Array, domain_picks: Dictionary) -> Array:
	var pool: Array = []
	var db = UpgradeDb.UPGRADES

	for id in db:
		var data = db[id]

		# Already owned — skip
		if id in acquired:
			continue

		# Prerequisites not met — skip
		if not _prereqs_met(data, acquired):
			continue

		# Rarity gating by domain investment
		var domain = data.get("domain", "")
		var picks_in_domain = domain_picks.get(domain, 0)
		var rarity = data.get("rarity", "common")

		if rarity == "legendary" and picks_in_domain < LEGENDARY_DOMAIN_REQ:
			continue
		if rarity == "rare" and picks_in_domain < RARE_DOMAIN_REQ:
			continue

		var entry = data.duplicate()
		entry["id"] = id
		pool.append(entry)

	return pool

func _prereqs_met(data: Dictionary, acquired: Array) -> bool:
	var prereqs = data.get("prerequisite", [])
	for prereq in prereqs:
		if prereq not in acquired:
			return false
	return true

# ─── Cohesion Bias ────────────────────────────────────────

func _count_domain_picks(acquired: Array) -> Dictionary:
	var counts: Dictionary = {}
	var db = UpgradeDb.UPGRADES
	for id in acquired:
		if id in db:
			var domain = db[id].get("domain", "")
			if domain != "" and domain != "item":
				counts[domain] = counts.get(domain, 0) + 1
	return counts

func _get_top_domain(domain_picks: Dictionary) -> String:
	var best_domain = ""
	var best_count = 0
	for domain in domain_picks:
		if domain_picks[domain] > best_count:
			best_count = domain_picks[domain]
			best_domain = domain
	return best_domain

# ─── Weighted Random Selection ────────────────────────────

func _weighted_pick(pool: Array, top_domain: String, use_bias: bool) -> Dictionary:
	var total_weight = 0.0
	var weights: Array = []

	for item in pool:
		var w = float(item.get("weight", 1))
		if use_bias and item.get("domain", "") == top_domain:
			w *= COHESION_BIAS
		weights.append(w)
		total_weight += w

	if total_weight <= 0.0:
		return pool[0]

	var roll = randf() * total_weight
	var cumulative = 0.0
	for i in weights.size():
		cumulative += weights[i]
		if roll <= cumulative:
			return pool[i]

	return pool[pool.size() - 1]

# ─── Fallbacks ────────────────────────────────────────────

func _fallback_choices() -> Array:
	return [_make_fallback(), _make_fallback(), _make_fallback()]

func _make_fallback() -> Dictionary:
	if FALLBACK_ID in UpgradeDb.UPGRADES:
		var fb = UpgradeDb.UPGRADES[FALLBACK_ID].duplicate()
		fb["id"] = FALLBACK_ID
		return fb
	return {"id": FALLBACK_ID, "displayname": "Food", "details": "Heals you for 20 health."}
