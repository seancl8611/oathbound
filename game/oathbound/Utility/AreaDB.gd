extends Node

# --- AREA DEFINITIONS (data only) ---
# Add/adjust weights or tiers per area as needed.
var areas := {
	1: {
		"name": "The Fallen Battlefield of Daimura",
		"map_weights": { "combat": 70, "shrine": 12, "shop": 8, "treasure": 6, "event": 4 },
		"tiers": 6,
		"fixed_tail": ["rest", "boss"]
	},
	2: {
		"name": "The Blighted Heartlands",
		"map_weights": { "combat": 65, "shrine": 12, "shop": 10, "treasure": 8, "event": 5 },
		"tiers": 6,
		"fixed_tail": ["rest", "boss"]
	},
	3: {
		"name": "The Shogun’s Citadel",
		"map_weights": { "combat": 60, "shrine": 15, "shop": 10, "treasure": 10, "event": 5 },
		"tiers": 6,
		"fixed_tail": ["rest", "boss"]
	}
}

# --- API ---

func is_area_available(id: int) -> bool:
	return MetaProgress.areas_unlocked.has(id)

func get_map_weights(area_id: int) -> Dictionary:
	if areas.has(area_id):
		return areas[area_id].get("map_weights", {})
	return {}

func get_fixed_tail(area_id: int) -> Array:
	if areas.has(area_id):
		return areas[area_id].get("fixed_tail", [])
	return []

func get_tiers(area_id: int) -> int:
	if areas.has(area_id):
		return int(areas[area_id].get("tiers", 6))
	return 6

# Spawn configuration helper (depth-based; no time system).
# You can customize per-area later if you want different curves.
func get_spawn_config(area_id: int, depth: int) -> Dictionary:
	var base_min := 3
	var base_max := 8
	# Simple curve: +1 enemy every 2 rooms, clamped
	var count = clamp(base_min + depth / 2, base_min, base_max)
	# Allow elites after a few rooms
	var allow_elites := depth >= 4
	return {
		"count": count,
		"allow_elites": allow_elites
	}
