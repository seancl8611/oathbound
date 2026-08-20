extends Node

## ProstheticManager — Autoload singleton managing all prosthetic state.
## Add to Project > Project Settings > Autoload as "ProstheticManager".

# --- Signals ---
signal prosthetic_unlocked(prosthetic_id: String)
signal prosthetic_equipped(prosthetic_id: String)
signal upgrade_purchased(prosthetic_id: String, upgrade_id: String)
signal relic_socketed(prosthetic_id: String, slot_index: int, relic_id: String)
signal relic_removed(prosthetic_id: String, slot_index: int)

# --- Registry ---
var _registry: Dictionary = {}        # { prosthetic_id: ProstheticData }
var _relic_registry: Dictionary = {}   # { relic_id: RelicData }

# --- Player State ---
var unlocked_prosthetics: Dictionary = {}   # { prosthetic_id: true }
var equipped_prosthetic_id: String = ""
var purchased_upgrades: Dictionary = {}     # { prosthetic_id: { upgrade_id: true } }
var socketed_relics: Dictionary = {}        # { prosthetic_id: [relic_id, ...] }
var unlocked_relics: Dictionary = {}        # { relic_id: true }

# --- Data Paths — these must be DIRECTORIES containing .tres files ---
const PROSTHETIC_DATA_DIR = "res://Data/Prosthetics/"
const RELIC_DATA_DIR = "res://Data/Relics/"


func _ready():
	_load_registry()
	_load_relic_registry()
	_register_defaults()


# =====================
# REGISTRY LOADING
# =====================

func _load_registry():
	_registry.clear()
	var dir = DirAccess.open(PROSTHETIC_DATA_DIR)
	if dir == null:
		push_warning("[ProstheticManager] Prosthetic data dir not found: %s — Using code-registered prosthetics only." % PROSTHETIC_DATA_DIR)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var path = PROSTHETIC_DATA_DIR + file_name
			var data = load(path)
			if data is ProstheticData and data.id != "":
				_registry[data.id] = data
		file_name = dir.get_next()
	dir.list_dir_end()
	print("[ProstheticManager] Loaded %d prosthetics from disk" % _registry.size())


func _load_relic_registry():
	_relic_registry.clear()
	var dir = DirAccess.open(RELIC_DATA_DIR)
	if dir == null:
		push_warning("[ProstheticManager] Relic data dir not found: %s — Using code-registered relics only." % RELIC_DATA_DIR)
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres") or file_name.ends_with(".res"):
			var path = RELIC_DATA_DIR + file_name
			var data = load(path)
			if data is RelicData and data.id != "":
				_relic_registry[data.id] = data
		file_name = dir.get_next()
	dir.list_dir_end()
	print("[ProstheticManager] Loaded %d relics from disk" % _relic_registry.size())


func _register_defaults():
	## Register all prosthetics and relics from code.
	## Won't overwrite anything already loaded from .tres files.

	# =================================================================
	# PROSTHETICS
	# =================================================================

	# 1) Beast-Bane Whistle
	_register_prosthetic_from_code(
		"beast_whistle", "Beast-Bane Whistle",
		"Emits a short pulse that staggers enemies in a medium radius. Beasts suffer a greater and longer effect.",
		2, 2, ["beast", "control", "aoe"],
		[
			{ "id": "whistle_radius", "name": "Widened Bell", "description": "Increases pulse radius by 30%", "cost_mist_shards": 80, "cost_gold": 30, "prerequisites": [] },
			{ "id": "whistle_beast_posture", "name": "Primal Resonance", "description": "Beasts take bonus posture damage while staggered by whistle", "cost_mist_shards": 120, "cost_gold": 50, "prerequisites": ["whistle_radius"] },
			{ "id": "whistle_interrupt", "name": "Shrill Cry", "description": "Pulse also interrupts enemy telegraphs once", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["whistle_beast_posture"] },
		]
	)

	# 2) Thunder Rod
	_register_prosthetic_from_code(
		"thunder_rod", "Thunder Rod",
		"Calls a lightning strike along a line in your aim direction. Applies Shock: slows enemy wind-ups and deals extra posture damage.",
		2, 2, ["line", "status", "posture"],
		[
			{ "id": "thunder_chain", "name": "Forked Path", "description": "Lightning chains to 1 extra nearby enemy", "cost_mist_shards": 100, "cost_gold": 40, "prerequisites": [] },
			{ "id": "thunder_duration", "name": "Lingering Charge", "description": "Shock status lasts 50% longer", "cost_mist_shards": 150, "cost_gold": 60, "prerequisites": ["thunder_chain"] },
			{ "id": "thunder_parry", "name": "Conductive Frame", "description": "Next parry window vs shocked target is slightly more forgiving", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["thunder_duration"] },
		]
	)

	# 3) Smoke Gourd
	_register_prosthetic_from_code(
		"smoke_gourd", "Smoke Gourd",
		"Drops a smoke cloud that breaks enemy targeting and interrupts enemies briefly.",
		2, 2, ["defensive", "utility", "aoe"],
		[
			{ "id": "smoke_iframes", "name": "Phantom Veil", "description": "Exiting the smoke cloud grants brief invincibility frames", "cost_mist_shards": 100, "cost_gold": 40, "prerequisites": [] },
			{ "id": "smoke_slow", "name": "Choking Fumes", "description": "Enemies inside smoke are slowed", "cost_mist_shards": 150, "cost_gold": 60, "prerequisites": ["smoke_iframes"] },
			{ "id": "smoke_slash", "name": "Smoke Slash", "description": "First sword hit out of smoke deals bonus posture and HP damage", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["smoke_slow"] },
		]
	)

	# 4) Fang Harpoon
	_register_prosthetic_from_code(
		"fang_harpoon", "Fang Harpoon",
		"A medium-range piercing shot that deals low HP but high posture damage. Slightly pulls the target toward you.",
		1, 1, ["ranged", "interrupt", "posture"],
		[
			{ "id": "harpoon_refund", "name": "Soul Siphon", "description": "Refunds 1 spirit if harpoon causes a posture break", "cost_mist_shards": 100, "cost_gold": 40, "prerequisites": [] },
			{ "id": "harpoon_pierce", "name": "Barbed Tip", "description": "Harpoon pierces through the first enemy hit", "cost_mist_shards": 150, "cost_gold": 60, "prerequisites": ["harpoon_refund"] },
			{ "id": "harpoon_pull", "name": "Iron Chain", "description": "Pull strength increased (capped to prevent overlap)", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["harpoon_pierce"] },
		]
	)

	# 5) Mirror Umbrella
	_register_prosthetic_from_code(
		"mirror_umbrella", "Mirror Umbrella",
		"Briefly deploys a parasol shield that negates one hit or reflects one projectile.",
		2, 1, ["defensive", "reflect"],
		[
			{ "id": "umbrella_counter", "name": "Counter Wave", "description": "Successful block triggers a short-range counter wave", "cost_mist_shards": 120, "cost_gold": 50, "prerequisites": [] },
			{ "id": "umbrella_reflect_posture", "name": "Polished Mirror", "description": "Reflected projectiles gain bonus posture damage", "cost_mist_shards": 180, "cost_gold": 70, "prerequisites": ["umbrella_counter"] },
			{ "id": "umbrella_duration", "name": "Wide Canopy", "description": "Umbrella lasts slightly longer but costs +1 spirit", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["umbrella_reflect_posture"] },
		]
	)

	# 6) Flame Vent
	_register_prosthetic_from_code(
		"flame_vent", "Flame Vent",
		"Short-range cone burst that deals low HP and high posture damage. Applies Burn (posture DoT). Punishes turtling enemies.",
		2, 2, ["fire", "dot", "status"],
		[
			{ "id": "flame_sword", "name": "Living Flame", "description": "Sword strikes deal burn damage for a short duration afterwards", "cost_mist_shards": 100, "cost_gold": 40, "prerequisites": [] },
			{ "id": "flame_posture", "name": "Searing Weakness", "description": "Burned enemies take bonus posture damage from your attacks", "cost_mist_shards": 150, "cost_gold": 60, "prerequisites": ["flame_sword"] },
			{ "id": "flame_range", "name": "Extended Barrel", "description": "Cone range increases significantly", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["flame_posture"] },
		]
	)

	# 7) Mist Raven
	_register_prosthetic_from_code(
		"mist_raven", "Mist Raven",
		"Short-range teleport dash that leaves a smoke afterimage. Acts as both mobility and emergency escape.",
		2, 1, ["mobility", "defensive", "dodge"],
		[
			{ "id": "raven_stagger", "name": "Phantom Strike", "description": "Teleporting through an enemy staggers them", "cost_mist_shards": 100, "cost_gold": 40, "prerequisites": [] },
			{ "id": "raven_distance", "name": "Lengthened Shadow", "description": "Teleport distance increases", "cost_mist_shards": 150, "cost_gold": 60, "prerequisites": ["raven_stagger"] },
			{ "id": "raven_emergency", "name": "Desperate Fade", "description": "Can teleport during an action or at full posture (emergency escape)", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["raven_distance"] },
		]
	)

	# 8) Bloodletting Gourd
	_register_prosthetic_from_code(
		"bloodletting_gourd", "Bloodletting Gourd",
		"Sacrifice spirit to restore HP. A desperate tool for those willing to trade resources for survival.",
		0, 1, ["resource", "risky", "utility"],
		[
			{ "id": "gourd_cost", "name": "Efficient Siphon", "description": "Spirit cost reduced to 2 (from 3)", "cost_mist_shards": 100, "cost_gold": 40, "prerequisites": [] },
			{ "id": "gourd_heal", "name": "Deep Bloodletting", "description": "HP restored increases to +25 (from +20)", "cost_mist_shards": 150, "cost_gold": 60, "prerequisites": ["gourd_cost"] },
			{ "id": "gourd_buff", "name": "Blood Frenzy", "description": "Gain a brief damage buff after use", "cost_mist_shards": 200, "cost_gold": 80, "prerequisites": ["gourd_heal"] },
		]
	)

	# =================================================================
	# RELICS
	# =================================================================

	_register_relic_from_code(
		"ember_core", "Ember Core",
		"A smoldering core that reduces spirit cost and adds lingering burn.",
		{ "spirit_cost_reduction": -1, "burn_duration_bonus": 2.0 },
		["fire"], "Uncommon"
	)

	_register_relic_from_code(
		"wind_charm", "Wind Charm",
		"A lightweight charm that boosts projectile speed and range.",
		{ "projectile_speed_bonus": 1.5, "range_bonus": 0.2 },
		["ranged"], "Common"
	)

	_register_relic_from_code(
		"iron_bead", "Iron Prayer Bead",
		"A dense bead that grants a small posture bonus to any prosthetic.",
		{ "posture_damage_bonus": 3 },
		[], "Common"  # Empty compatible_tags = universal
	)

	# Auto-unlock starters for testing — adjust as needed
	unlock_prosthetic("beast_whistle")
	unlock_prosthetic("thunder_rod")
	unlock_prosthetic("smoke_gourd")
	unlock_prosthetic("fang_harpoon")
	unlock_prosthetic("mirror_umbrella")
	unlock_prosthetic("flame_vent")
	unlock_prosthetic("mist_raven")
	unlock_prosthetic("bloodletting_gourd")
	unlock_relic("ember_core")
	unlock_relic("wind_charm")
	unlock_relic("iron_bead")

	print("[ProstheticManager] Registered %d total prosthetics, %d total relics" % [_registry.size(), _relic_registry.size()])


# =====================
# CODE-BASED REGISTRATION
# =====================

func _register_prosthetic_from_code(id: String, display_name: String, description: String,
		spirit_cost: int, max_relic_slots: int, tags: Array, upgrade_nodes: Array):
	## Registers a prosthetic without needing a .tres file.
	## Won't overwrite if already loaded from disk.
	if _registry.has(id):
		return
	var data = ProstheticData.new()
	data.id = id
	data.display_name = display_name
	data.description = description
	data.spirit_cost = spirit_cost
	data.max_relic_slots = max_relic_slots
	# Convert plain arrays to typed arrays
	for tag in tags:
		data.tags.append(tag)
	for node in upgrade_nodes:
		data.upgrade_nodes.append(node)
	_registry[id] = data


func _register_relic_from_code(id: String, display_name: String, description: String,
		stat_modifiers: Dictionary, compatible_tags: Array, rarity: String):
	if _relic_registry.has(id):
		return
	var data = RelicData.new()
	data.id = id
	data.display_name = display_name
	data.description = description
	data.stat_modifiers = stat_modifiers
	for tag in compatible_tags:
		data.compatible_tags.append(tag)
	data.rarity = rarity
	_relic_registry[id] = data


# =====================
# GETTERS
# =====================

func get_prosthetic(prosthetic_id: String) -> ProstheticData:
	return _registry.get(prosthetic_id, null)

func get_relic(relic_id: String) -> RelicData:
	return _relic_registry.get(relic_id, null)

func get_all_prosthetics() -> Array:
	return _registry.values()

func get_unlocked_prosthetics() -> Array:
	var result = []
	for pid in unlocked_prosthetics:
		if _registry.has(pid):
			result.append(_registry[pid])
	return result

func get_locked_prosthetics() -> Array:
	var result = []
	for pid in _registry:
		if not unlocked_prosthetics.has(pid):
			result.append(_registry[pid])
	return result

func get_equipped_data() -> ProstheticData:
	if equipped_prosthetic_id == "":
		return null
	return _registry.get(equipped_prosthetic_id, null)

func get_unlocked_relics() -> Array:
	var result = []
	for rid in unlocked_relics:
		if _relic_registry.has(rid):
			result.append(_relic_registry[rid])
	return result

func get_socketed_relics(prosthetic_id: String) -> Array:
	if not socketed_relics.has(prosthetic_id):
		var data = get_prosthetic(prosthetic_id)
		if data:
			var slots = []
			for i in range(data.max_relic_slots):
				slots.append("")
			socketed_relics[prosthetic_id] = slots
	return socketed_relics.get(prosthetic_id, [])

func is_upgrade_purchased(prosthetic_id: String, upgrade_id: String) -> bool:
	if not purchased_upgrades.has(prosthetic_id):
		return false
	return purchased_upgrades[prosthetic_id].has(upgrade_id)

func can_purchase_upgrade(prosthetic_id: String, upgrade_id: String) -> bool:
	if is_upgrade_purchased(prosthetic_id, upgrade_id):
		return false
	var data = get_prosthetic(prosthetic_id)
	if data == null:
		return false
	for node in data.upgrade_nodes:
		if node.get("id", "") == upgrade_id:
			var prereqs = node.get("prerequisites", [])
			for prereq in prereqs:
				if not is_upgrade_purchased(prosthetic_id, prereq):
					return false
			return true
	return false

func get_upgrade_cost(prosthetic_id: String, upgrade_id: String) -> Dictionary:
	var data = get_prosthetic(prosthetic_id)
	if data == null:
		return {}
	for node in data.upgrade_nodes:
		if node.get("id", "") == upgrade_id:
			return {
				"mist_shards": node.get("cost_mist_shards", 0),
				"gold": node.get("cost_gold", 0)
			}
	return {}

func get_all_prosthetic_ids() -> Array:
	return _registry.keys()
	
# =====================
# ACTIONS
# =====================

func unlock_prosthetic(prosthetic_id: String) -> bool:
	if not _registry.has(prosthetic_id):
		push_warning("[ProstheticManager] Unknown prosthetic: " + prosthetic_id)
		return false
	if unlocked_prosthetics.has(prosthetic_id):
		return false
	unlocked_prosthetics[prosthetic_id] = true
	prosthetic_unlocked.emit(prosthetic_id)
	return true

func equip_prosthetic(prosthetic_id: String) -> bool:
	if not unlocked_prosthetics.has(prosthetic_id):
		push_warning("[ProstheticManager] Cannot equip locked prosthetic: " + prosthetic_id)
		return false
	equipped_prosthetic_id = prosthetic_id
	prosthetic_equipped.emit(prosthetic_id)
	return true

func unequip_prosthetic():
	equipped_prosthetic_id = ""

func purchase_upgrade(prosthetic_id: String, upgrade_id: String) -> bool:
	if not can_purchase_upgrade(prosthetic_id, upgrade_id):
		return false

	var cost = get_upgrade_cost(prosthetic_id, upgrade_id)
	var mist_cost = cost.get("mist_shards", 0)
	var gold_cost = cost.get("gold", 0)

	# Check currency
	if mist_cost > 0:
		var current_mist = CurrencyManager.get_amount(CurrencyManager.Currency.MIST_SHARDS)
		if current_mist < mist_cost:
			return false
	if gold_cost > 0:
		var current_gold = CurrencyManager.get_amount(CurrencyManager.Currency.GOLD)
		if current_gold < gold_cost:
			return false

	# Deduct
	if mist_cost > 0:
		CurrencyManager.add_amount(CurrencyManager.Currency.MIST_SHARDS, -mist_cost)
	if gold_cost > 0:
		CurrencyManager.add_amount(CurrencyManager.Currency.GOLD, -gold_cost)

	if not purchased_upgrades.has(prosthetic_id):
		purchased_upgrades[prosthetic_id] = {}
	purchased_upgrades[prosthetic_id][upgrade_id] = true

	upgrade_purchased.emit(prosthetic_id, upgrade_id)
	return true

func socket_relic(prosthetic_id: String, slot_index: int, relic_id: String) -> bool:
	if not unlocked_relics.has(relic_id):
		return false
	var data = get_prosthetic(prosthetic_id)
	if data == null:
		return false

	var relic_data = get_relic(relic_id)
	if relic_data == null:
		return false

	if relic_data.compatible_tags.size() > 0:
		var compatible = false
		for tag in relic_data.compatible_tags:
			if data.tags.has(tag):
				compatible = true
				break
		if not compatible:
			return false

	var slots = get_socketed_relics(prosthetic_id)
	if slot_index < 0 or slot_index >= slots.size():
		return false

	for i in range(slots.size()):
		if slots[i] == relic_id and i != slot_index:
			slots[i] = ""

	slots[slot_index] = relic_id
	socketed_relics[prosthetic_id] = slots
	relic_socketed.emit(prosthetic_id, slot_index, relic_id)
	return true

func remove_relic(prosthetic_id: String, slot_index: int) -> bool:
	var slots = get_socketed_relics(prosthetic_id)
	if slot_index < 0 or slot_index >= slots.size():
		return false
	if slots[slot_index] == "":
		return false
	slots[slot_index] = ""
	socketed_relics[prosthetic_id] = slots
	relic_removed.emit(prosthetic_id, slot_index)
	return true

func unlock_relic(relic_id: String) -> bool:
	if not _relic_registry.has(relic_id):
		return false
	unlocked_relics[relic_id] = true
	return true


# =====================
# STAT AGGREGATION
# =====================

func get_equipped_stat_modifiers() -> Dictionary:
	var combined = {}
	if equipped_prosthetic_id == "":
		return combined

	var slots = get_socketed_relics(equipped_prosthetic_id)
	for relic_id in slots:
		if relic_id == "":
			continue
		var relic_data = get_relic(relic_id)
		if relic_data == null:
			continue
		for stat_key in relic_data.stat_modifiers:
			if combined.has(stat_key):
				combined[stat_key] += relic_data.stat_modifiers[stat_key]
			else:
				combined[stat_key] = relic_data.stat_modifiers[stat_key]
	return combined


# =====================
# SAVE / LOAD
# =====================

func get_save_data() -> Dictionary:
	return {
		"unlocked_prosthetics": unlocked_prosthetics.keys(),
		"equipped_prosthetic_id": equipped_prosthetic_id,
		"purchased_upgrades": purchased_upgrades.duplicate(true),
		"socketed_relics": socketed_relics.duplicate(true),
		"unlocked_relics": unlocked_relics.keys(),
	}

func load_save_data(data: Dictionary):
	unlocked_prosthetics.clear()
	for pid in data.get("unlocked_prosthetics", []):
		unlocked_prosthetics[pid] = true
	equipped_prosthetic_id = data.get("equipped_prosthetic_id", "")
	purchased_upgrades = data.get("purchased_upgrades", {})
	socketed_relics = data.get("socketed_relics", {})
	unlocked_relics.clear()
	for rid in data.get("unlocked_relics", []):
		unlocked_relics[rid] = true
