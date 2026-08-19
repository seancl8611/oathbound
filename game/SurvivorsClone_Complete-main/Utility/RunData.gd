# RunData.gd
# Autoload - Tracks run state and statistics
# Add to Project > Project Settings > Autoload as "RunData"
extends Node

var current_area_id: int = 1
var depth: int = 0
var gold: int = 0
var mist_shards: int = 0
var scrolls: int = 0
var path_history: Array[String] = []
var acquired_upgrades: Array = []

# Combat stats
var enemies_killed: int = 0
var parries_performed: int = 0
var perfect_parries: int = 0
var damage_taken: int = 0

# Room stats
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
		"combat", "miniboss":
			combat_rooms_cleared += 1
		"shrine":
			blessings_received += 1
		"treasure":
			treasures_opened += 1

	print("[RunData] Depth: %d | Room: %s | Path: %s" % [depth, token, path_history])

func reset_for_new_run(area_id: int = 1) -> void:
	current_area_id = area_id
	depth = 0
	gold = 0
	mist_shards = 0
	scrolls = 0
	path_history.clear()
	acquired_upgrades.clear()
	
	enemies_killed = 0
	parries_performed = 0
	perfect_parries = 0
	damage_taken = 0
	
	combat_rooms_cleared = 0
	blessings_received = 0
	treasures_opened = 0
	items_purchased = 0
	
	# Sync to CurrencyManager
	CurrencyManager.set_amount(CurrencyManager.Currency.GOLD, 0)
	CurrencyManager.set_amount(CurrencyManager.Currency.MIST_SHARDS, 0)
	CurrencyManager.set_amount(CurrencyManager.Currency.SCROLLS, 0)
	
	print("[RunData] New run started - Area %d" % area_id)
	
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
	
func record_enemy_killed() -> void:
	enemies_killed += 1

func record_parry(perfect: bool = false) -> void:
	parries_performed += 1
	if perfect:
		perfect_parries += 1

func get_run_summary() -> Dictionary:
	return {
		"area": current_area_id,
		"depth": depth,
		"gold": gold,
		"mist_shards": mist_shards,
		"scrolls": scrolls,
		"path": path_history.duplicate(),
		"enemies_killed": enemies_killed,
		"parries": parries_performed,
		"perfect_parries": perfect_parries,
		"combat_rooms": combat_rooms_cleared,
		"blessings": blessings_received
	}
	
func print_summary() -> void:
	var s = get_run_summary()
	print("\n=== RUN SUMMARY ===")
	print("  Area: %d | Depth: %d | Gold: %d" % [s.area, s.depth, s.gold])
	print("  Enemies: %d | Parries: %d (Perfect: %d)" % [s.enemies_killed, s.parries, s.perfect_parries])
	print("  Path: %s" % str(s.path))
	print("===================\n")

func add_mist_shards(amount: int) -> void:
	mist_shards += amount
	CurrencyManager.add(CurrencyManager.Currency.MIST_SHARDS, amount)
	print("[RunData] Mist Shards: %d (+%d)" % [mist_shards, amount])

func spend_mist_shards(amount: int) -> bool:
	if mist_shards >= amount:
		mist_shards -= amount
		CurrencyManager.spend(CurrencyManager.Currency.MIST_SHARDS, amount)
		return true
	return false
	
func record_upgrade(upgrade_id: String) -> void:
	if upgrade_id not in acquired_upgrades:
		acquired_upgrades.append(upgrade_id)
	print("[RunData] Upgrade acquired: %s | Total: %d" % [upgrade_id, acquired_upgrades.size()])

func get_acquired_upgrades() -> Array:
	return acquired_upgrades

func add_scrolls(amount: int) -> void:
	scrolls += amount
	CurrencyManager.add(CurrencyManager.Currency.SCROLLS, amount)
	print("[RunData] Scrolls: %d (+%d)" % [scrolls, amount])

func spend_scrolls(amount: int) -> bool:
	if scrolls >= amount:
		scrolls -= amount
		CurrencyManager.spend(CurrencyManager.Currency.SCROLLS, amount)
		return true
	return false
