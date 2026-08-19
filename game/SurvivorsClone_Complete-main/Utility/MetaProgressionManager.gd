# res://Meta/MetaProgressionManager.gd   (autoload this as "MetaProgressionManager")
extends Node

signal changed

# Simple built-in catalog (convert to Resources later if you want)
# category: "room_upgrade" | "wheel_wedge" | "gameplay_mod"
const UPGRADE_CATALOG := [
	{
		"id": "room_treasure_cache",
		"name": "Treasure Cache Room",
		"desc": "Adds a rare Treasure Cache room type to the run pool.",
		"category": "room_upgrade",
		"cost": {"boss_emblems": 1, "mist_shards": 75},
		"payload": {"room_type": "treasure_cache"},
	},
	{
		"id": "room_rest_fire",
		"name": "Rest Fire Room",
		"desc": "Adds a Rest Fire room type (light healing + calm upgrade choice).",
		"category": "room_upgrade",
		"cost": {"boss_emblems": 1, "mist_shards": 100},
		"payload": {"room_type": "rest_fire"},
	},
	{
		"id": "wheel_wedge_focus",
		"name": "Wheel Wedge: Focus",
		"desc": "Adds a new wedge variant focused on posture/playstyle synergy.",
		"category": "wheel_wedge",
		"cost": {"boss_emblems": 1, "mist_shards": 60},
		"payload": {"wedge_id": "focus"},
	},
	{
		"id": "mod_small_posture_cap",
		"name": "Posture +1",
		"desc": "Permanent small increase to max posture.",
		"category": "gameplay_mod",
		"cost": {"boss_emblems": 2, "mist_shards": 120},
		"payload": {"stat": "max_posture", "add": 1},
	},
]

const TIER_GATE_REQUIREMENT = 2  # Buy 2 nodes in tier N to unlock tier N+1

const TREE_UPGRADES = {
	# =========================================================================
	# BRANCH 1 — WAY OF STEEL (Combat & Survivability)
	# =========================================================================
	"vitality": {
		"name": "Vitality",
		"branch": "steel",
		"tier": 1,
		"max_rank": 3,
		"description": "Increase maximum HP.",
		"effect_text": ["+5 max HP", "+8 max HP", "+12 max HP"],
		"costs": [
			{"mist": 12, "emblems": 0},
			{"mist": 20, "emblems": 0},
			{"mist": 30, "emblems": 0},
		],
		"effects": [
			{"max_hp_bonus": 5},
			{"max_hp_bonus": 8},
			{"max_hp_bonus": 12},
		],
	},
	"iron_composure": {
		"name": "Iron Composure",
		"branch": "steel",
		"tier": 1,
		"max_rank": 2,
		"description": "Increase maximum posture.",
		"effect_text": ["+15 max posture", "+25 max posture"],
		"costs": [
			{"mist": 10, "emblems": 0},
			{"mist": 18, "emblems": 0},
		],
		"effects": [
			{"max_posture_bonus": 15},
			{"max_posture_bonus": 25},
		],
	},
	"deflect_mastery": {
		"name": "Deflect Mastery",
		"branch": "steel",
		"tier": 2,
		"max_rank": 1,
		"description": "Perfect-deflect streaks empower your next attack.",
		"effect_text": ["+3 posture per streak, cap +18, decays 3s"],
		"costs": [
			{"mist": 22, "emblems": 0},
		],
		"effects": [
			{"deflect_posture_per_streak": 3, "deflect_posture_cap": 18, "deflect_decay_sec": 3.0},
		],
	},
	"second_wind": {
		"name": "Second Wind",
		"branch": "steel",
		"tier": 2,
		"max_rank": 3,
		"description": "Heal on room clear.",
		"effect_text": ["+1 HP on clear", "+2 HP on clear", "+3 HP on clear"],
		"costs": [
			{"mist": 16, "emblems": 0},
			{"mist": 26, "emblems": 0},
			{"mist": 38, "emblems": 0},
		],
		"effects": [
			{"heal_on_clear": 1},
			{"heal_on_clear": 2},
			{"heal_on_clear": 3},
		],
	},
	"stance_synergy": {
		"name": "Stance Synergy",
		"branch": "steel",
		"tier": 3,
		"max_rank": 3,
		"description": "Bonus damage vs targets with 2+ stance effects.",
		"effect_text": ["12% bonus", "16% bonus", "20% bonus"],
		"costs": [
			{"mist": 20, "emblems": 0},
			{"mist": 34, "emblems": 0},
			{"mist": 50, "emblems": 0},
		],
		"effects": [
			{"stance_synergy_mult": 0.12},
			{"stance_synergy_mult": 0.16},
			{"stance_synergy_mult": 0.20},
		],
	},
	"bloodprice": {
		"name": "Bloodprice",
		"branch": "steel",
		"tier": 3,
		"max_rank": 1,
		"description": "Desperation fuels your blade. +10% damage below 30% HP.",
		"effect_text": ["+10% damage below 30% HP"],
		"costs": [
			{"mist": 28, "emblems": 0},
		],
		"effects": [
			{"low_hp_damage_mult": 0.10, "low_hp_threshold": 0.30},
		],
	},

	# =========================================================================
	# BRANCH 2 — WAY OF SECRETS (Utility & Economy)
	# =========================================================================
	"keen_eye": {
		"name": "Keen Eye",
		"branch": "secrets",
		"tier": 1,
		"max_rank": 1,
		"description": "Reveal room rewards before entering.",
		"effect_text": ["See room rewards on map"],
		"costs": [
			{"mist": 14, "emblems": 0},
		],
		"effects": [
			{"reveal_room_rewards": true},
		],
	},
	"seed_money": {
		"name": "Seed Money",
		"branch": "secrets",
		"tier": 1,
		"max_rank": 3,
		"description": "Start runs with bonus gold.",
		"effect_text": ["+15 gold", "+35 gold", "+55 gold"],
		"costs": [
			{"mist": 10, "emblems": 0},
			{"mist": 18, "emblems": 0},
			{"mist": 30, "emblems": 0},
		],
		"effects": [
			{"starting_gold_bonus": 15},
			{"starting_gold_bonus": 35},
			{"starting_gold_bonus": 55},
		],
	},
	"spirit_well": {
		"name": "Spirit Well",
		"branch": "secrets",
		"tier": 2,
		"max_rank": 2,
		"description": "Begin runs with extra spirit emblems.",
		"effect_text": ["+2 max spirit", "+4 max spirit"],
		"costs": [
			{"mist": 14, "emblems": 0},
			{"mist": 26, "emblems": 0},
		],
		"effects": [
			{"max_spirit_bonus": 2},
			{"max_spirit_bonus": 4},
		],
	},
	"scavenger": {
		"name": "Scavenger",
		"branch": "secrets",
		"tier": 2,
		"max_rank": 2,
		"description": "Chance to conserve spirit on prosthetic use.",
		"effect_text": ["10% save chance", "20% save chance"],
		"costs": [
			{"mist": 16, "emblems": 0},
			{"mist": 28, "emblems": 0},
		],
		"effects": [
			{"spirit_save_chance": 0.10},
			{"spirit_save_chance": 0.20},
		],
	},
	"reroll_fortune": {
		"name": "Reroll Fortune",
		"branch": "secrets",
		"tier": 3,
		"max_rank": 2,
		"description": "More chances to find the boon you need.",
		"effect_text": ["+1 reroll", "+2 rerolls"],
		"costs": [
			{"mist": 30, "emblems": 0},
			{"mist": 55, "emblems": 0},
		],
		"effects": [
			{"bonus_rerolls": 1},
			{"bonus_rerolls": 2},
		],
	},
	"swift_step": {
		"name": "Swift Step",
		"branch": "secrets",
		"tier": 3,
		"max_rank": 1,
		"description": "Master the art of evasion. +1 consecutive dash charge.",
		"effect_text": ["+1 dash charge"],
		"costs": [
			{"mist": 75, "emblems": 1},
		],
		"effects": [
			{"bonus_dash_charges": 1},
		],
	},

	# =========================================================================
	# BRANCH 3 — WAY OF VOWS (Boons & Progression)
	# =========================================================================
	"stance_affinity": {
		"name": "Stance Affinity",
		"branch": "vows",
		"tier": 1,
		"max_rank": 1,
		"description": "Begin with a random stance already active.",
		"effect_text": ["Start with random rank-1 stance"],
		"costs": [
			{"mist": 18, "emblems": 0},
		],
		"effects": [
			{"start_with_random_stance": true},
		],
	},
	"auspicious_offering": {
		"name": "Auspicious Offering",
		"branch": "vows",
		"tier": 1,
		"max_rank": 3,
		"description": "Better boon rarity across the run.",
		"effect_text": ["+15% rarity", "+25% rarity", "+35% rarity"],
		"costs": [
			{"mist": 16, "emblems": 0},
			{"mist": 30, "emblems": 0},
			{"mist": 48, "emblems": 0},
		],
		"effects": [
			{"rarity_bonus": 0.15},
			{"rarity_bonus": 0.25},
			{"rarity_bonus": 0.35},
		],
	},
	"cinder_tithe": {
		"name": "Cinder Tithe",
		"branch": "vows",
		"tier": 2,
		"max_rank": 2,
		"description": "Prayer Flame offerings yield more Cinder.",
		"effect_text": ["+15% Cinder", "+30% Cinder"],
		"costs": [
			{"mist": 22, "emblems": 0},
			{"mist": 42, "emblems": 0},
		],
		"effects": [
			{"cinder_bonus": 0.15},
			{"cinder_bonus": 0.30},
		],
	},
	"death_defiance": {
		"name": "Death Defiance",
		"branch": "vows",
		"tier": 2,
		"max_rank": 2,
		"description": "Cheat death itself.",
		"effect_text": ["+1 extra life", "+2 extra lives"],
		"costs": [
			{"mist": 60, "emblems": 1},
			{"mist": 90, "emblems": 1},
		],
		"effects": [
			{"extra_lives": 1},
			{"extra_lives": 2},
		],
	},
	"boon_of_abundance": {
		"name": "Boon of Abundance",
		"branch": "vows",
		"tier": 3,
		"max_rank": 1,
		"description": "More options when choosing boons. +1 boon choice (4 instead of 3).",
		"effect_text": ["+1 boon choice"],
		"costs": [
			{"mist": 120, "emblems": 2},
		],
		"effects": [
			{"bonus_boon_choices": 1},
		],
	},
}

var _tree_ranks = {}  # { "vitality": 2, "keen_eye": 1, ... } — 0 or missing = not purchased

const SAVE_PATH := "user://meta_progression.cfg"
const SAVE_SECTION := "meta"

var _unlocked := {} # upgrade_id -> true

func _ready() -> void:
	_load()
	_load_tree()

func _load_tree() -> void:
	var cf = ConfigFile.new()
	if cf.load(SAVE_PATH) != OK:
		return
	var ranks = cf.get_value(SAVE_SECTION, "tree_ranks", {})
	if ranks is Dictionary:
		_tree_ranks = ranks
		
func list_upgrades() -> Array:
	# Returns shallow copies so UI can safely read
	var out: Array = []
	for u in UPGRADE_CATALOG:
		out.append(u.duplicate(true))
	return out

func is_unlocked(upgrade_id: String) -> bool:
	return _unlocked.has(upgrade_id)

func get_upgrade(upgrade_id: String) -> Dictionary:
	for u in UPGRADE_CATALOG:
		if u.id == upgrade_id:
			return u
	return {}

func get_upgrade_cost(upgrade_id: String) -> Dictionary:
	var u := get_upgrade(upgrade_id)
	return u.get("cost", {"boss_emblems": 0, "mist_shards": 0})

func can_purchase(upgrade_id: String) -> bool:
	if is_unlocked(upgrade_id):
		return false

	var cost := get_upgrade_cost(upgrade_id)
	return _can_afford(cost.get("boss_emblems", 0), cost.get("mist_shards", 0))

func purchase(upgrade_id: String) -> bool:
	if not can_purchase(upgrade_id):
		return false

	var cost := get_upgrade_cost(upgrade_id)
	var ok := _spend_currency(cost.get("boss_emblems", 0), cost.get("mist_shards", 0))
	if not ok:
		return false

	_unlocked[upgrade_id] = true
	_save()
	changed.emit()
	return true

# --- Effects query helpers for your run systems (RouteGenerator, RewardWheel, etc.) ---

func get_unlocked_room_types() -> Array[String]:
	var out: Array[String] = []
	for u in UPGRADE_CATALOG:
		if is_unlocked(u.id) and u.category == "room_upgrade":
			var rt = u.payload.get("room_type", "")
			if rt != "":
				out.append(rt)
	return out

func get_unlocked_wedges() -> Array[String]:
	var out: Array[String] = []
	for u in UPGRADE_CATALOG:
		if is_unlocked(u.id) and u.category == "wheel_wedge":
			var wid = u.payload.get("wedge_id", "")
			if wid != "":
				out.append(wid)
	return out

func get_gameplay_modifiers() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for u in UPGRADE_CATALOG:
		if is_unlocked(u.id) and u.category == "gameplay_mod":
			out.append(u.payload.duplicate(true))
	return out

# --- Persistence ---

func _load() -> void:
	var cf := ConfigFile.new()
	if cf.load(SAVE_PATH) != OK:
		return

	var ids: Array = cf.get_value(SAVE_SECTION, "unlocked_ids", [])
	_unlocked.clear()
	for id in ids:
		_unlocked[str(id)] = true

func _save() -> void:
	var cf := ConfigFile.new()
	var ids: Array = _unlocked.keys()
	cf.set_value(SAVE_SECTION, "unlocked_ids", ids)
	cf.set_value(SAVE_SECTION, "tree_ranks", _tree_ranks)
	cf.save(SAVE_PATH)

# --- Currency integration ---
# Expected autoload: CurrencyManager
# Supported patterns:
#  - CurrencyManager.get_boss_emblems(), get_mist_shards()
#  - CurrencyManager.boss_emblems / mist_shards properties
#  - CurrencyManager.spend_boss_emblems(n), spend_mist_shards(n)
# If your names differ, adjust these helpers.

func _can_afford(boss_emblems: int, mist_shards: int) -> bool:
	var cm := get_node_or_null("/root/CurrencyManager")
	if cm == null:
		push_warning("[MetaProgressionManager] CurrencyManager autoload not found.")
		return false

	var have_emblems := int(cm.get_amount(cm.Currency.BOSS_EMBLEM))
	var have_mist := int(cm.get_amount(cm.Currency.MIST_SHARDS))
	return have_emblems >= boss_emblems and have_mist >= mist_shards


func _spend_currency(boss_emblems: int, mist_shards: int) -> bool:
	var cm := get_node_or_null("/root/CurrencyManager")
	if cm == null:
		return false

	# can_purchase() already checks affordability, so spends should succeed.
	if mist_shards > 0:
		if not cm.spend(cm.Currency.MIST_SHARDS, mist_shards):
			return false

	if boss_emblems > 0:
		if not cm.spend(cm.Currency.BOSS_EMBLEM, boss_emblems):
			# Optional: refund mist if you want strict atomicity
			if mist_shards > 0:
				cm.add(cm.Currency.MIST_SHARDS, mist_shards)
			return false

	return true

func get_tree_rank(upgrade_id: String) -> int:
	return _tree_ranks.get(upgrade_id, 0)


func is_tree_maxed(upgrade_id: String) -> bool:
	if not TREE_UPGRADES.has(upgrade_id):
		return false
	return get_tree_rank(upgrade_id) >= TREE_UPGRADES[upgrade_id]["max_rank"]


func get_tree_upgrade(upgrade_id: String) -> Dictionary:
	if TREE_UPGRADES.has(upgrade_id):
		return TREE_UPGRADES[upgrade_id]
	return {}


func get_tree_ids_for_branch(branch: String) -> Array:
	var result = []
	for id in TREE_UPGRADES:
		if TREE_UPGRADES[id]["branch"] == branch:
			result.append(id)
	return result


func get_tree_ids_for_tier(branch: String, tier: int) -> Array:
	var result = []
	for id in TREE_UPGRADES:
		var data = TREE_UPGRADES[id]
		if data["branch"] == branch and data["tier"] == tier:
			result.append(id)
	return result


func count_tier_owned(branch: String, tier: int) -> int:
	## How many nodes in this branch+tier have rank >= 1.
	var count = 0
	for id in get_tree_ids_for_tier(branch, tier):
		if get_tree_rank(id) >= 1:
			count += 1
	return count


func is_tier_unlocked(branch: String, tier: int) -> bool:
	if tier <= 1:
		return true
	return count_tier_owned(branch, tier - 1) >= TIER_GATE_REQUIREMENT


# --- Tree Purchase ---

func get_tree_cost(upgrade_id: String) -> Dictionary:
	## Returns the cost for the NEXT rank. Empty dict if maxed or invalid.
	var data = get_tree_upgrade(upgrade_id)
	if data.is_empty():
		return {}
	var rank = get_tree_rank(upgrade_id)
	var costs = data.get("costs", [])
	if rank < 0 or rank >= costs.size():
		return {}
	return costs[rank]


func can_tree_purchase(upgrade_id: String) -> bool:
	var data = get_tree_upgrade(upgrade_id)
	if data.is_empty():
		return false
	if is_tree_maxed(upgrade_id):
		return false
	if not is_tier_unlocked(data["branch"], data["tier"]):
		return false

	var cost = get_tree_cost(upgrade_id)
	if cost.is_empty():
		return false

	return _can_afford(cost.get("emblems", 0), cost.get("mist", 0))


func tree_purchase(upgrade_id: String) -> bool:
	if not can_tree_purchase(upgrade_id):
		return false

	var cost = get_tree_cost(upgrade_id)
	var ok = _spend_currency(cost.get("emblems", 0), cost.get("mist", 0))
	if not ok:
		return false

	var new_rank = get_tree_rank(upgrade_id) + 1
	_tree_ranks[upgrade_id] = new_rank

	print("[MetaProgressionManager] Tree upgrade: %s -> rank %d" % [upgrade_id, new_rank])

	_save()
	changed.emit()
	return true


# --- Tree Effect Queries ---

func get_tree_effect(upgrade_id: String) -> Dictionary:
	## Returns the effect dict for the current purchased rank (empty if rank 0).
	var rank = get_tree_rank(upgrade_id)
	if rank <= 0:
		return {}
	var data = get_tree_upgrade(upgrade_id)
	var effects = data.get("effects", [])
	var idx = rank - 1
	if idx < 0 or idx >= effects.size():
		return {}
	return effects[idx]


func get_total_tree_effect(key: String) -> float:
	## Sum a specific effect key across ALL purchased tree upgrades.
	var total = 0.0
	for id in _tree_ranks:
		var effect = get_tree_effect(id)
		if effect.has(key):
			total += float(effect[key])
	return total


func has_tree_effect(key: String) -> bool:
	for id in _tree_ranks:
		var effect = get_tree_effect(id)
		if effect.has(key):
			return true
	return false


# --- Run-Start Application ---

func apply_tree_effects(player: Node) -> void:
	## Call at the start of each run to apply all purchased tree upgrades.
	for upgrade_id in _tree_ranks:
		var rank = _tree_ranks[upgrade_id]
		if rank <= 0:
			continue
		var effect = get_tree_effect(upgrade_id)
		if effect.is_empty():
			continue
		_apply_tree_effect(player, effect)
	print("[MetaProgressionManager] Applied tree effects (%d upgrades)" % _tree_ranks.size())


func _apply_tree_effect(player: Node, effect: Dictionary) -> void:
	# --- Steel ---
	if effect.has("max_hp_bonus"):
		if "maxhp" in player:
			player.maxhp += int(effect["max_hp_bonus"])
			player.hp = min(player.hp + int(effect["max_hp_bonus"]), player.maxhp)

	if effect.has("max_posture_bonus"):
		if "combat" in player and player.combat != null:
			if player.combat.config != null:
				player.combat.config.posture_max += float(effect["max_posture_bonus"])

	if effect.has("deflect_posture_per_streak"):
		player.set_meta("meta_deflect_per_streak", effect["deflect_posture_per_streak"])
		player.set_meta("meta_deflect_cap", effect.get("deflect_posture_cap", 18))
		player.set_meta("meta_deflect_decay", effect.get("deflect_decay_sec", 3.0))

	if effect.has("heal_on_clear"):
		player.set_meta("meta_heal_on_clear", int(effect["heal_on_clear"]))

	if effect.has("stance_synergy_mult"):
		player.set_meta("meta_stance_synergy_mult", float(effect["stance_synergy_mult"]))

	if effect.has("low_hp_damage_mult"):
		player.set_meta("meta_bloodprice_mult", float(effect["low_hp_damage_mult"]))
		player.set_meta("meta_bloodprice_threshold", float(effect.get("low_hp_threshold", 0.30)))

	# --- Secrets ---
	if effect.has("reveal_room_rewards"):
		player.set_meta("meta_keen_eye", true)

	if effect.has("starting_gold_bonus"):
		var cm = get_node_or_null("/root/CurrencyManager")
		if cm:
			cm.add(cm.Currency.GOLD, int(effect["starting_gold_bonus"]))

	if effect.has("max_spirit_bonus"):
		var executor = player.get_node_or_null("ProstheticExecutor")
		if executor:
			executor.max_spirit += int(effect["max_spirit_bonus"])
			executor.current_spirit += int(effect["max_spirit_bonus"])

	if effect.has("spirit_save_chance"):
		player.set_meta("meta_spirit_save_chance", float(effect["spirit_save_chance"]))

	if effect.has("bonus_rerolls"):
		player.set_meta("meta_bonus_rerolls", int(effect["bonus_rerolls"]))

	if effect.has("bonus_dash_charges"):
		player.set_meta("meta_bonus_dashes", int(effect["bonus_dash_charges"]))

	# --- Vows ---
	if effect.has("start_with_random_stance"):
		player.set_meta("meta_start_stance", true)

	if effect.has("rarity_bonus"):
		player.set_meta("meta_rarity_bonus", float(effect["rarity_bonus"]))

	if effect.has("cinder_bonus"):
		player.set_meta("meta_cinder_bonus", float(effect["cinder_bonus"]))

	if effect.has("extra_lives"):
		player.set_meta("meta_extra_lives", int(effect["extra_lives"]))

	if effect.has("bonus_boon_choices"):
		player.set_meta("meta_bonus_boon_choices", int(effect["bonus_boon_choices"]))


func reset_tree() -> void:
	## Debug / testing — wipes all tree progression.
	_tree_ranks = {}
	_save()
	changed.emit()
	print("[MetaProgressionManager] Tree progression reset")
