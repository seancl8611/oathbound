extends Node

## =============================================================================
## ENCOUNTER DATABASE - v3.1 (DEBUG-FRIENDLY)
## =============================================================================
## How this plugs in:
## - CombatRoom requests a template (Dictionary) from EncounterDB
## - EnemyEncounterSpawner resolves each group's `type` via /root/SceneRegistry.enemies_by_area[area_id]
## - Therefore: EncounterDB `type` strings MUST match SceneRegistry keys.
##
## This version adds one encounter per enemy archetype for fast iteration/debug.
## Those encounters have weight = 0, so they are not picked randomly.
## =============================================================================

var last_encounter_id_area1: String = ""
var last_encounter_id_area2: String = ""
var last_encounter_id_area3: String = ""

## Wave spacing - deliberate but not too slow
const DEFAULT_WAVE_SPACING := [6.0, 8.0]

## NOTE: `weight <= 0` means "disabled from random" (still accessible by id).
var area1_encounters := [
	# ---------------------------------------------------------------------
	# DEBUG ENCOUNTERS (force these by id from CombatRoom)
	# ---------------------------------------------------------------------
	{
		"id": "debug_akaname",
		"weight": 0,
		"description": "(debug) Akaname only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "akaname", "count": 2}
			]},
			{"groups": [
				{"type": "akaname", "count": 1}
			]}
		]
	},
	{
		"id": "debug_archer",
		"weight": 0,
		"description": "(debug) Archer only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "archer", "count": 2}
			]},
			{"groups": [
				{"type": "archer", "count": 1}
			]}
		]
	},
	{
		"id": "debug_soldier",
		"weight": 0,
		"description": "(debug) Ashen soldier only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "soldier", "count": 2}
			]},
			{"groups": [
				{"type": "soldier", "count": 1}
			]}
		]
	},
	{
		"id": "debug_shade",
		"weight": 0,
		"description": "(debug) Lost shade only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "shade", "count": 2}
			]},
			{"groups": [
				{"type": "shade", "count": 1}
			]}
		]
	},
	{
		"id": "debug_wardens",
		"weight": 0,
		"description": "(debug) Wardens only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "warden", "count": 2}
			]},
			{"groups": [
				{"type": "warden", "count": 1}
			]}
		]
	},
	{
		"id": "debug_dog",
		"weight": 0,
		"description": "(debug) Wild dog only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "dog", "count": 2}
			]},
			{"groups": [
				{"type": "dog", "count": 1}
			]}
		]
	},
	# ---------------------------------------------------------------------
	# GAMEPLAY ENCOUNTERS (weight > 0)
	# ---------------------------------------------------------------------
	{
		"id": "full_assault",
		"weight": 2,
		"description": "Mixed pressure (melee + shade + dog)",
		"wave_spacing": [10.0, 12.0],
		"waves": [
			{"groups": [
				{"type": "soldier", "count": 1},
				{"type": "shade", "count": 2}
			]},
			{"groups": [
				{"type": "dog", "count": 2},
				{"type": "shade", "count": 1}
			]}
		]
	},
	{
		"id": "ranged_harass",
		"weight": 2,
		"description": "Archer support + single melee",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "soldier", "count": 1},
				{"type": "warden", "count": 1}
			]},
			{"groups": [
				{"type": "shade", "count": 1}
			]}
		]
	},
	{
		"id": "puddles_and_fangs",
		"weight": 2,
		"description": "Akaname zoning + dogs",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "soldier", "count": 1}
			]},
			{"groups": [
				{"type": "shade", "count": 2}
			]}
		]
	},
	{
		"id": "warden_guard",
		"weight": 1,
		"description": "Warden presence + shades",
		"wave_spacing": [8.0, 10.0],
		"waves": [
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "soldier", "count": 1}
			]},
			{"groups": [
				{"type": "shade", "count": 2}
			]}
		]
	},
]

var area2_encounters := [
	# ---------------------------------------------------------------------
	# DEBUG ENCOUNTERS (weight = 0, force by id)
	# ---------------------------------------------------------------------
	{
		"id": "debug_soldier2",
		"weight": 0,
		"description": "(debug) Soldier v2 only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "soldier2", "count": 2}
			]},
			{"groups": [
				{"type": "soldier2", "count": 1}
			]}
		]
	},
	{
		"id": "debug_archer2",
		"weight": 0,
		"description": "(debug) Soldier v1 + v2 mix",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "archer2", "count": 1},
				{"type": "archer2", "count": 1}
			]}
		]
	},
	{
		"id": "debug_dog2",
		"weight": 0,
		"description": "(debug) Beasts only (area 2)",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "dog", "count": 2}
			]},
			{"groups": [
				{"type": "dog", "count": 1}
			]}
		]
	},
	{
		"id": "debug_shade2",
		"weight": 0,
		"description": "(debug) Lost shades only (area 2)",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "shade", "count": 2}
			]},
			{"groups": [
				{"type": "shade", "count": 1}
			]}
		]
	},
	{
		"id": "debug_warden2",
		"weight": 0,
		"description": "(debug) Wardens only (area 2)",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "warden", "count": 2}
			]},
			{"groups": [
				{"type": "warden", "count": 1}
			]}
		]
	},
	{
		"id": "debug_healer",
		"weight": 0,
		"description": "(debug) Spirit monk healer only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "healer", "count": 1},
				{"type": "soldier", "count": 1}
			]},
			{"groups": [
				{"type": "healer", "count": 1},
				{"type": "soldier", "count": 1}
			]}
		]
	},
	{
		"id": "debug_stalker",
		"weight": 0,
		"description": "(debug) Stalker only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "stalker", "count": 2}
			]},
			{"groups": [
				{"type": "stalker", "count": 1}
			]}
		]
	},
	# ---------------------------------------------------------------------
	# GAMEPLAY ENCOUNTERS (weight > 0)
	# ---------------------------------------------------------------------
	{
		"id": "a2_patrol",
		"weight": 2,
		"description": "Mixed soldiers — v1 holds the line, v2 charges",
		"wave_spacing": [8.0, 10.0],
		"waves": [
			{"groups": [
				{"type": "soldier", "count": 1},
				{"type": "soldier2", "count": 1}
			]},
			{"groups": [
				{"type": "soldier2", "count": 1},
				{"type": "archer", "count": 1}
			]}
		]
	},
	{
		"id": "a2_chargers",
		"weight": 2,
		"description": "Soldier v2 pressure with archer support",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [
				{"type": "soldier2", "count": 2}
			]},
			{"groups": [
				{"type": "soldier2", "count": 1},
				{"type": "archer", "count": 1}
			]}
		]
	},
	{
		"id": "a2_frontline",
		"weight": 1,
		"description": "Soldiers hold while archer harasses",
		"wave_spacing": [8.0, 10.0],
		"waves": [
			{"groups": [
				{"type": "soldier", "count": 1},
				{"type": "archer", "count": 1}
			]},
			{"groups": [
				{"type": "soldier2", "count": 2}
			]}
		]
	},
			{
		"id": "a2_feral_rush",
		"weight": 2,
		"description": "Beasts and shades close fast from all sides",
		"wave_spacing": [8.0, 10.0],
		"waves": [
			{"groups": [
				{"type": "dog", "count": 2},
				{"type": "shade", "count": 1}
			]},
			{"groups": [
				{"type": "shade", "count": 2},
				{"type": "dog", "count": 1}
			]}
		]
	},
	{
		"id": "a2_blessed_guard",
		"weight": 2,
		"description": "Spirit monk buffs soldier frontline — kill the healer",
		"wave_spacing": [8.0, 10.0],
		"waves": [
			{"groups": [
				{"type": "soldier2", "count": 1},
				{"type": "soldier", "count": 1},
				{"type": "healer", "count": 1}
			]},
			{"groups": [
				{"type": "soldier2", "count": 1},
				{"type": "shade", "count": 1}
			]}
		]
	},
	{
		"id": "a2_chain_snare",
		"weight": 2,
		"description": "Wardens restrain while wave archers punish from range",
		"wave_spacing": [10.0, 12.0],
		"waves": [
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "archer2", "count": 1}
			]},
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "soldier2", "count": 1}
			]}
		]
	},
	{
		"id": "a2_spirit_battery",
		"weight": 1,
		"description": "Archers and healer behind soldier screen — break through",
		"wave_spacing": [10.0, 12.0],
		"waves": [
			{"groups": [
				{"type": "soldier", "count": 1},
				{"type": "archer2", "count": 1},
				{"type": "healer", "count": 1}
			]},
			{"groups": [
				{"type": "soldier2", "count": 1},
				{"type": "archer", "count": 1}
			]}
		]
	},
	{
		"id": "a2_cage_hunt",
		"weight": 2,
		"description": "Beasts rush in, warden follows to lock you down",
		"wave_spacing": [8.0, 10.0],
		"waves": [
			{"groups": [
				{"type": "dog", "count": 2}
			]},
			{"groups": [
				{"type": "warden", "count": 1},
				{"type": "dog", "count": 1},
				{"type": "shade", "count": 1}
			]}
		]
	},
	{
		"id": "a2_convergence",
		"weight": 1,
		"description": "All threat types converge — melee, ranged, restraint, heals",
		"wave_spacing": [10.0, 14.0],
		"waves": [
			{"groups": [
				{"type": "soldier2", "count": 1},
				{"type": "archer2", "count": 1},
				{"type": "warden", "count": 1}
			]},
			{"groups": [
				{"type": "shade", "count": 1},
				{"type": "healer", "count": 1},
				{"type": "dog", "count": 1}
			]}
		]
	},
	{
		"id": "a2_relentless_shades",
		"weight": 2,
		"description": "Shades lunge relentlessly while monk keeps them buffed",
		"wave_spacing": [8.0, 10.0],
		"waves": [
			{"groups": [
				{"type": "shade", "count": 2},
				{"type": "healer", "count": 1}
			]},
			{"groups": [
				{"type": "shade", "count": 2}
			]}
		]
	},
]

var area3_encounters := [
	# ---------------------------------------------------------------------
	# DEBUG ENCOUNTERS (weight = 0, force by id)
	# ---------------------------------------------------------------------
	{
		"id": "debug_soldier3",
		"weight": 0,
		"description": "(debug) Sword-Spirit Soldier only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [{"type": "soldier3", "count": 2}]},
			{"groups": [{"type": "soldier3", "count": 1}]}
		]
	},
	{
		"id": "debug_archer3",
		"weight": 0,
		"description": "(debug) Shade Splitter only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [{"type": "archer3", "count": 2}]},
			{"groups": [{"type": "archer3", "count": 1}]}
		]
	},
	{
		"id": "debug_den",
		"weight": 0,
		"description": "(debug) Corrupted Den only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [{"type": "den", "count": 1}]}
		]
	},
	{
		"id": "debug_brute",
		"weight": 0,
		"description": "(debug) Brute only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [{"type": "brute", "count": 1}]},
			{"groups": [{"type": "brute", "count": 1}]}
		]
	},
	{
		"id": "debug_shield",
		"weight": 0,
		"description": "(debug) Shield Enemy only",
		"wave_spacing": DEFAULT_WAVE_SPACING,
		"waves": [
			{"groups": [{"type": "shield", "count": 2}]},
			{"groups": [{"type": "shield", "count": 1}]}
		]
	},
]

## Pick a weighted random encounter, avoiding repeats.
## Encounters with weight <= 0 are excluded from random selection.
func pick_area1() -> Dictionary:
	var bag: Array = []

	for enc in area1_encounters:
		# Skip last picked encounter
		if enc.get("id", "") == last_encounter_id_area1:
			continue

		var w := int(enc.get("weight", 1))
		if w <= 0:
			continue

		for i in range(w):
			bag.append(enc)

	# Fallback if bag empty (all weights may be 0, or we skipped due to repeat)
	if bag.is_empty():
		for enc in area1_encounters:
			var w2 := int(enc.get("weight", 1))
			if w2 > 0:
				bag.append(enc)
		if bag.is_empty():
			bag = area1_encounters.duplicate(true)

	var choice: Dictionary = bag[randi() % bag.size()]
	last_encounter_id_area1 = String(choice.get("id", ""))

	# Ensure wave_spacing is set
	if not choice.has("wave_spacing"):
		choice["wave_spacing"] = DEFAULT_WAVE_SPACING

	print("[EncounterDB] Picked: %s (enemies: %d)" % [choice.get("id", "?"), get_encounter_enemy_count(choice)])
	return choice

func pick_area2() -> Dictionary:
	var bag: Array = []

	for enc in area2_encounters:
		if enc.get("id", "") == last_encounter_id_area2:
			continue
		var w = int(enc.get("weight", 1))
		if w <= 0:
			continue
		for i in range(w):
			bag.append(enc)

	if bag.is_empty():
		for enc in area2_encounters:
			var w2 = int(enc.get("weight", 1))
			if w2 > 0:
				bag.append(enc)
		if bag.is_empty():
			bag = area2_encounters.duplicate(true)

	var choice: Dictionary = bag[randi() % bag.size()]
	last_encounter_id_area2 = String(choice.get("id", ""))

	if not choice.has("wave_spacing"):
		choice["wave_spacing"] = DEFAULT_WAVE_SPACING

	print("[EncounterDB] Area 2 Picked: %s (enemies: %d)" % [choice.get("id", "?"), get_encounter_enemy_count(choice)])
	return choice

func pick_area3() -> Dictionary:
	var bag: Array = []

	for enc in area3_encounters:
		if enc.get("id", "") == last_encounter_id_area3:
			continue
		var w = int(enc.get("weight", 1))
		if w <= 0:
			continue
		for i in range(w):
			bag.append(enc)

	if bag.is_empty():
		for enc in area3_encounters:
			var w2 = int(enc.get("weight", 1))
			if w2 > 0:
				bag.append(enc)
		if bag.is_empty():
			bag = area3_encounters.duplicate(true)

	var choice: Dictionary = bag[randi() % bag.size()]
	last_encounter_id_area3 = String(choice.get("id", ""))

	if not choice.has("wave_spacing"):
		choice["wave_spacing"] = DEFAULT_WAVE_SPACING

	print("[EncounterDB] Area 3 Picked: %s (enemies: %d)" % [choice.get("id", "?"), get_encounter_enemy_count(choice)])
	return choice
	
func get_encounter_by_id(id: String) -> Dictionary:
	for enc in area1_encounters:
		if enc.get("id", "") == id:
			return enc
	for enc in area2_encounters:
		if enc.get("id", "") == id:
			return enc
	for enc in area3_encounters:
		if enc.get("id", "") == id:
			return enc
	return {}
	
## Convenience: list encounter IDs (useful for logs / debug UI)
func get_area1_encounter_ids(include_weight_zero: bool = true) -> Array:
	var out: Array = []
	for enc in area1_encounters:
		var w := int(enc.get("weight", 1))
		if (not include_weight_zero) and w <= 0:
			continue
		out.append(String(enc.get("id", "")))
	return out


## Get total enemy count for an encounter
func get_encounter_enemy_count(enc: Dictionary) -> int:
	var total := 0
	for wave in enc.get("waves", []):
		for group in wave.get("groups", []):
			total += int(group.get("count", 0))
	return total


## Debug: Print all encounters
func debug_print_encounters() -> void:
	print("=== AREA 1 ENCOUNTERS ===")
	for enc in area1_encounters:
		var id = enc.get("id", "unknown")
		var weight = int(enc.get("weight", 1))
		var count = get_encounter_enemy_count(enc)
		print("  %s (w:%d, enemies:%d)" % [id, weight, count])
