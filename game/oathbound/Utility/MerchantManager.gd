extends Node

## MerchantManager — Autoload managing the merchant's inventory, stat upgrades,
## mystery prosthetic rolls, and cosmetic unlocks.
##
## Add as autoload: Project > Project Settings > Autoload > MerchantManager
##
## Depends on: CurrencyManager (autoload), ProstheticManager (autoload)

signal stock_refreshed
signal stat_upgraded(stat_id: String, new_tier: int)
signal cosmetic_unlocked(cosmetic_id: String)
signal mystery_rolled(prosthetic_id: String)

# =====================
# STAT UPGRADE DEFINITIONS
# =====================

## Each stat upgrade has a max tier (hard cap), cost per tier, and value per tier.
## These are small, incremental buffs — not game-breaking.

var stat_upgrade_defs = {
	"max_posture": {
		"display_name": "Max Posture",
		"description": "Slightly increases maximum posture.",
		"max_tier": 3,
		"values": [5, 5, 5],           # +5 per tier, total +15
		"costs": [80, 150, 250],        # Mist Shards per tier
		"icon_hint": "shield",
	},
	"posture_recovery": {
		"display_name": "Posture Recovery",
		"description": "Slightly faster posture recovery rate.",
		"max_tier": 3,
		"values": [0.05, 0.05, 0.05],   # +5% per tier
		"costs": [80, 150, 250],
		"icon_hint": "refresh",
	},
	"heal_speed": {
		"display_name": "Heal Speed",
		"description": "Slightly faster healing gourd use.",
		"max_tier": 3,
		"values": [0.05, 0.05, 0.05],   # +5% speed per tier
		"costs": [100, 175, 300],
		"icon_hint": "heart",
	},
	"parry_posture_bonus": {
		"display_name": "Parry Posture Gain",
		"description": "Tiny bonus to posture damage on parry.",
		"max_tier": 3,
		"values": [2, 2, 3],            # +2, +2, +3 flat bonus
		"costs": [100, 175, 300],
		"icon_hint": "sword",
	},
}

## Current tier for each stat upgrade (0 = not purchased)
var stat_tiers = {}

# =====================
# PROSTHETIC SHOP STOCK
# =====================

## Prosthetics available for direct purchase (id -> cost in mist shards).
## Only shows prosthetics the player hasn't unlocked yet.
var prosthetic_shop_stock = {
	"flame_vent": 200,
	"loaded_shuriken": 200,
	"iron_shield": 250,
}

# =====================
# COSMETIC DEFINITIONS
# =====================

## Cosmetics the player can buy. Organized by category.
var cosmetic_defs = {
	"red_scarf_skin": {
		"display_name": "Red Scarf",
		"description": "A crimson scarf trailing behind the player.",
		"category": "player_skin",
		"cost": 300,
	},
	"shadow_cloak_skin": {
		"display_name": "Shadow Cloak",
		"description": "Dark wisps emanate from the player.",
		"category": "player_skin",
		"cost": 400,
	},
	"ember_trail": {
		"display_name": "Ember Trail",
		"description": "Leaves faint embers on the ground when walking.",
		"category": "player_skin",
		"cost": 350,
	},
	"golden_wheel_wedge": {
		"display_name": "Golden Wheel",
		"description": "Cosmetic gold variant for the reward wheel.",
		"category": "wheel_variant",
		"cost": 500,
	},
	"blood_moon_rooms": {
		"display_name": "Blood Moon Rooms",
		"description": "Red-tinted lighting in dungeon rooms.",
		"category": "room_variant",
		"cost": 450,
	},
}

## Unlocked cosmetics (id -> true)
var unlocked_cosmetics = {}

# =====================
# MYSTERY PROSTHETIC
# =====================

## Mystery roll settings
var mystery_cost = 500
var mystery_available = true
var mystery_cooldown_runs = 3   # Re-appears every N runs
var runs_since_last_mystery = 0

# =====================
# INIT
# =====================

func _ready():
	# Initialize stat tiers to 0
	for stat_id in stat_upgrade_defs:
		if not stat_tiers.has(stat_id):
			stat_tiers[stat_id] = 0


# =====================
# STAT UPGRADES
# =====================

func get_stat_tier(stat_id: String) -> int:
	return stat_tiers.get(stat_id, 0)

func get_stat_max_tier(stat_id: String) -> int:
	var def = stat_upgrade_defs.get(stat_id, null)
	if def == null:
		return 0
	return def.get("max_tier", 0)

func is_stat_maxed(stat_id: String) -> bool:
	return get_stat_tier(stat_id) >= get_stat_max_tier(stat_id)

func get_stat_next_cost(stat_id: String) -> int:
	var def = stat_upgrade_defs.get(stat_id, null)
	if def == null:
		return 0
	var tier = get_stat_tier(stat_id)
	var costs = def.get("costs", [])
	if tier >= costs.size():
		return 0
	return costs[tier]

func get_stat_next_value(stat_id: String):
	var def = stat_upgrade_defs.get(stat_id, null)
	if def == null:
		return 0
	var tier = get_stat_tier(stat_id)
	var values = def.get("values", [])
	if tier >= values.size():
		return 0
	return values[tier]

func get_stat_total_value(stat_id: String) -> float:
	## Returns the cumulative value from all purchased tiers.
	var def = stat_upgrade_defs.get(stat_id, null)
	if def == null:
		return 0.0
	var tier = get_stat_tier(stat_id)
	var values = def.get("values", [])
	var total = 0.0
	for i in range(mini(tier, values.size())):
		total += values[i]
	return total

func purchase_stat_upgrade(stat_id: String) -> bool:
	if is_stat_maxed(stat_id):
		print("[MerchantManager] Stat already maxed: ", stat_id)
		return false

	var cost = get_stat_next_cost(stat_id)
	var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
	if current_mist < cost:
		print("[MerchantManager] Not enough mist shards for: ", stat_id)
		return false

	CurrencyManager.add_amount(CurrencyManager.Currency.MIST_SHARDS, -cost)
	stat_tiers[stat_id] = get_stat_tier(stat_id) + 1

	var new_tier = stat_tiers[stat_id]
	stat_upgraded.emit(stat_id, new_tier)
	print("[MerchantManager] Upgraded %s to tier %d" % [stat_id, new_tier])
	return true


# =====================
# PROSTHETIC PURCHASES
# =====================

func get_available_prosthetics() -> Array:
	## Returns prosthetic IDs that are in stock and NOT yet unlocked by the player.
	var available = []
	for pid in prosthetic_shop_stock:
		if not ProstheticManager.unlocked_prosthetics.has(pid):
			available.append(pid)
	return available

func get_prosthetic_cost(prosthetic_id: String) -> int:
	return prosthetic_shop_stock.get(prosthetic_id, 0)

func purchase_prosthetic(prosthetic_id: String) -> bool:
	if ProstheticManager.unlocked_prosthetics.has(prosthetic_id):
		print("[MerchantManager] Already unlocked: ", prosthetic_id)
		return false

	var cost = get_prosthetic_cost(prosthetic_id)
	if cost <= 0:
		return false

	var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
	if current_mist < cost:
		print("[MerchantManager] Not enough mist shards for prosthetic: ", prosthetic_id)
		return false

	CurrencyManager.add_amount(CurrencyManager.Currency.MIST_SHARDS, -cost)
	ProstheticManager.unlock_prosthetic(prosthetic_id)
	print("[MerchantManager] Purchased prosthetic: ", prosthetic_id)
	return true


# =====================
# COSMETICS
# =====================

func get_available_cosmetics() -> Array:
	## Returns cosmetic IDs not yet unlocked.
	var available = []
	for cid in cosmetic_defs:
		if not unlocked_cosmetics.has(cid):
			available.append(cid)
	return available

func get_all_cosmetics() -> Array:
	## Returns all cosmetic IDs (for display purposes — show locked ones too).
	return cosmetic_defs.keys()

func get_cosmetic_data(cosmetic_id: String) -> Dictionary:
	return cosmetic_defs.get(cosmetic_id, {})

func is_cosmetic_unlocked(cosmetic_id: String) -> bool:
	return unlocked_cosmetics.has(cosmetic_id)

func purchase_cosmetic(cosmetic_id: String) -> bool:
	if unlocked_cosmetics.has(cosmetic_id):
		print("[MerchantManager] Cosmetic already owned: ", cosmetic_id)
		return false

	var data = cosmetic_defs.get(cosmetic_id, {})
	if data.is_empty():
		return false

	var cost = data.get("cost", 0)
	var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
	if current_mist < cost:
		print("[MerchantManager] Not enough mist shards for cosmetic: ", cosmetic_id)
		return false

	CurrencyManager.add_amount(CurrencyManager.Currency.MIST_SHARDS, -cost)
	unlocked_cosmetics[cosmetic_id] = true
	cosmetic_unlocked.emit(cosmetic_id)
	print("[MerchantManager] Cosmetic unlocked: ", cosmetic_id)
	return true


# =====================
# MYSTERY PROSTHETIC
# =====================

func is_mystery_available() -> bool:
	return mystery_available

func get_mystery_cost() -> int:
	return mystery_cost

func roll_mystery_prosthetic() -> String:
	## Rolls a random prosthetic the player doesn't own. Returns "" if none available.
	if not mystery_available:
		return ""

	var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
	if current_mist < mystery_cost:
		print("[MerchantManager] Not enough mist shards for mystery roll")
		return ""

	# Collect all locked prosthetics
	var locked = []
	var all_prosthetics = ProstheticManager.get_all_prosthetic_ids()
	for pid in all_prosthetics:
		if not ProstheticManager.unlocked_prosthetics.has(pid):
			locked.append(pid)

	if locked.is_empty():
		print("[MerchantManager] No locked prosthetics remaining for mystery roll")
		return ""

	CurrencyManager.add_amount(CurrencyManager.Currency.MIST_SHARDS, -mystery_cost)

	# Random pick
	var rolled_id = locked[randi() % locked.size()]
	ProstheticManager.unlock_prosthetic(rolled_id)

	mystery_available = false
	runs_since_last_mystery = 0

	mystery_rolled.emit(rolled_id)
	print("[MerchantManager] Mystery roll result: ", rolled_id)
	return rolled_id

func on_run_completed():
	## Call this after each run to tick the mystery cooldown.
	if not mystery_available:
		runs_since_last_mystery += 1
		if runs_since_last_mystery >= mystery_cooldown_runs:
			mystery_available = true
			runs_since_last_mystery = 0
			print("[MerchantManager] Mystery prosthetic is available again!")

func refresh_stock():
	## Called when entering the hub or opening the merchant.
	stock_refreshed.emit()


# =====================
# AGGREGATE STAT BONUSES (for combat system)
# =====================

func get_all_stat_bonuses() -> Dictionary:
	## Returns a dictionary of all purchased stat bonuses.
	## Combat system can query this to apply merchant upgrades.
	## Example: { "max_posture": 10, "posture_recovery": 0.1, ... }
	var bonuses = {}
	for stat_id in stat_upgrade_defs:
		var total = get_stat_total_value(stat_id)
		if total > 0:
			bonuses[stat_id] = total
	return bonuses


# =====================
# SAVE / LOAD
# =====================

func get_save_data() -> Dictionary:
	return {
		"stat_tiers": stat_tiers.duplicate(),
		"unlocked_cosmetics": unlocked_cosmetics.keys(),
		"mystery_available": mystery_available,
		"runs_since_last_mystery": runs_since_last_mystery,
	}

func load_save_data(data: Dictionary):
	stat_tiers = data.get("stat_tiers", {})
	# Fill any missing stat tiers with 0
	for stat_id in stat_upgrade_defs:
		if not stat_tiers.has(stat_id):
			stat_tiers[stat_id] = 0

	unlocked_cosmetics.clear()
	for cid in data.get("unlocked_cosmetics", []):
		unlocked_cosmetics[cid] = true

	mystery_available = data.get("mystery_available", true)
	runs_since_last_mystery = data.get("runs_since_last_mystery", 0)
