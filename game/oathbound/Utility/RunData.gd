# RunData.gd
# Autoload - Tracks run-only state/statistics and mirrors persistent resource totals.
extends Node

var current_area_id: int = 1
var depth: int = 0
var gold: int = 0

# Canonical persistent names. These mirror MetaProgress for existing run HUD callers;
# they are NOT reset at run start.
var mist: int = 0
var scrolls: int = 0

# Deprecated compatibility alias. Old callers may still read `mist_shards` until the
# remaining UI/progression migration is complete, but new code must use Mist.
var mist_shards: int = 0

# Run-only Technique reroll resource.
var technique_rerolls: int = 0

var path_history: Array[String] = []
var acquired_upgrades: Array = []
var hushiro_encounters_seen: Array[String] = []
var yomori_encounters_seen: Array[String] = []
var kagutsuchi_encounters_seen: Array[String] = []

var enemies_killed: int = 0
var parries_performed: int = 0
var perfect_parries: int = 0
var damage_taken: int = 0
var combat_rooms_cleared: int = 0
var blessings_received: int = 0
var treasures_opened: int = 0
var items_purchased: int = 0


func advance_depth(room_type: String) -> void:
	var token := str(room_type).to_lower()
	var base := token
	if base.find(":") != -1:
		base = base.split(":", false)[0]
	path_history.append(token)
	depth += 1
	match base:
		"combat", "miniboss": combat_rooms_cleared += 1
		"shrine": blessings_received += 1
		"treasure": treasures_opened += 1
	print("[RunData] Depth: %d | Chamber: %s | Path: %s" % [depth, token, path_history])


func reset_for_new_run(area_id: int = 1) -> void:
	current_area_id = area_id
	depth = 0
	gold = 0
	technique_rerolls = 0
	if typeof(MetaProgressionManager) == TYPE_OBJECT and MetaProgressionManager.has_method("get_starting_reroll_bonus"):
		technique_rerolls = maxi(0, int(MetaProgressionManager.call("get_starting_reroll_bonus")))
	path_history.clear()
	acquired_upgrades.clear()
	hushiro_encounters_seen.clear()
	yomori_encounters_seen.clear()
	kagutsuchi_encounters_seen.clear()
	enemies_killed = 0
	parries_performed = 0
	perfect_parries = 0
	damage_taken = 0
	combat_rooms_cleared = 0
	blessings_received = 0
	treasures_opened = 0
	items_purchased = 0
	CurrencyManager.set_amount(CurrencyManager.Currency.GOLD, 0)
	sync_persistent_resources()
	print("[RunData] New run started - Region %d | Banked Mist %d | Scrolls %d | Rerolls %d" % [area_id, mist, scrolls, technique_rerolls])


func sync_persistent_resources() -> void:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return
	mist = int(MetaProgress.mist)
	scrolls = int(MetaProgress.scrolls)
	mist_shards = mist
	CurrencyManager.set_amount(CurrencyManager.Currency.MIST_SHARDS, mist)
	CurrencyManager.set_amount(CurrencyManager.Currency.SCROLLS, scrolls)


func add_gold(amount: int) -> void:
	gold += amount
	CurrencyManager.add(CurrencyManager.Currency.GOLD, amount)
	print("[RunData] Gold: %d (+%d)" % [gold, amount])


func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		items_purchased += 1
		CurrencyManager.spend(CurrencyManager.Currency.GOLD, amount)
		return true
	return false


func add_mist(amount: int) -> void:
	if amount <= 0:
		return
	MetaProgress.add_mist(amount)
	sync_persistent_resources()
	print("[RunData] Mist: %d (+%d persistent)" % [mist, amount])


func add_mist_shards(amount: int) -> void:
	add_mist(amount)


func spend_mist(amount: int) -> bool:
	if not MetaProgress.spend_mist(amount):
		return false
	sync_persistent_resources()
	return true


func spend_mist_shards(amount: int) -> bool:
	return spend_mist(amount)


func add_scrolls(amount: int) -> void:
	if amount <= 0:
		return
	MetaProgress.add_scrolls(amount)
	sync_persistent_resources()
	print("[RunData] Scrolls: %d (+%d persistent)" % [scrolls, amount])


func spend_scrolls(amount: int) -> bool:
	if not MetaProgress.spend_scrolls(amount):
		return false
	sync_persistent_resources()
	return true


func add_technique_rerolls(amount: int) -> void:
	if amount <= 0:
		return
	technique_rerolls += amount
	print("[RunData] Technique rerolls: %d (+%d)" % [technique_rerolls, amount])


func spend_technique_reroll() -> bool:
	if technique_rerolls <= 0:
		return false
	technique_rerolls -= 1
	return true


func record_enemy_killed() -> void:
	enemies_killed += 1


func record_parry(perfect: bool = false) -> void:
	parries_performed += 1
	if perfect:
		perfect_parries += 1


func record_upgrade(upgrade_id: String) -> void:
	if upgrade_id not in acquired_upgrades:
		acquired_upgrades.append(upgrade_id)
	print("[RunData] Upgrade acquired: %s | Total: %d" % [upgrade_id, acquired_upgrades.size()])


func get_acquired_upgrades() -> Array:
	return acquired_upgrades


func get_run_summary() -> Dictionary:
	return {
		"area": current_area_id,
		"depth": depth,
		"gold": gold,
		"mist": mist,
		"mist_shards": mist_shards,
		"scrolls": scrolls,
		"technique_rerolls": technique_rerolls,
		"path": path_history.duplicate(),
		"hushiro_encounters": hushiro_encounters_seen.duplicate(),
		"yomori_encounters": yomori_encounters_seen.duplicate(),
		"kagutsuchi_encounters": kagutsuchi_encounters_seen.duplicate(),
		"enemies_killed": enemies_killed,
		"parries": parries_performed,
		"perfect_parries": perfect_parries,
		"combat_rooms": combat_rooms_cleared,
		"blessings": blessings_received,
	}


func print_summary() -> void:
	var s = get_run_summary()
	print("\n=== RUN SUMMARY ===")
	print("  Region: %d | Depth: %d | Gold: %d" % [s.area, s.depth, s.gold])
	print("  Banked Mist: %d | Scrolls: %d" % [s.mist, s.scrolls])
	print("  Enemies: %d | Parries: %d (Perfect: %d)" % [s.enemies_killed, s.parries, s.perfect_parries])
	print("  Path: %s" % str(s.path))
	print("===================\n")
