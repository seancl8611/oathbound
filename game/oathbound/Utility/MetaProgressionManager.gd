extends Node

## =============================================================================
## PERSISTENT PROGRESSION COORDINATOR
## =============================================================================
## PROGRESSION.md owns the current architecture:
##   - Bloodwell: Akio + Run Infrastructure
##   - Forge Bench: Prosthetics + Relics
##   - Blood Mirror: Blood Aspects
##
## The imported Way of Steel / Secrets / Vows tree, Mist Shards, and generic Boss
## Emblems are retired. Exact Bloodwell/Blood Mirror numerical node values and Mist
## prices remain intentionally unauthored, so this coordinator exposes structure and
## campaign gates without inventing purchasable upgrades.
##
## Legacy public methods remain as safe no-op compatibility shims until old hub UI
## scenes are migrated away from this autoload.
## =============================================================================

signal changed

const STATION_BLOODWELL := "bloodwell"
const STATION_FORGE := "forge"
const STATION_BLOOD_MIRROR := "blood_mirror"

const STAGE_FIRST_RETURN := "first_return"
const STAGE_AFTER_KEEPER := "after_keeper"
const STAGE_AFTER_TWIN_MAWS := "after_twin_maws"
const STAGE_AFTER_SHOGUN := "after_shogun"
const STAGE_AFTER_KEEPER_OR_LATER := "after_keeper_or_later"

const STRUCTURAL_NODES := [
	# Bloodwell — Akio
	{"id": "vitality", "name": "Vitality", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_FIRST_RETURN},
	{"id": "composure", "name": "Composure", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_FIRST_RETURN},
	{"id": "spirit_reserve", "name": "Spirit Reserve", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_FIRST_RETURN},
	{"id": "posture_recovery", "name": "Posture Recovery", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_AFTER_KEEPER_OR_LATER},
	{"id": "recovery_efficiency", "name": "Recovery Efficiency", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_AFTER_KEEPER_OR_LATER},
	{"id": "deflection_stability", "name": "Deflection Stability", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_AFTER_KEEPER_OR_LATER},
	{"id": "execution_stability", "name": "Execution Stability", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_AFTER_KEEPER_OR_LATER},
	{"id": "body_mastery", "name": "Body Mastery", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_AFTER_KEEPER, "boss_material": MetaProgress.BOSS_MATERIAL_KEEPER},
	{"id": "resource_mastery", "name": "Resource Mastery", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_AFTER_TWIN_MAWS, "boss_material": MetaProgress.BOSS_MATERIAL_TWIN_MAWS},
	{"id": "returning_blood_mastery", "name": "Returning Blood Mastery", "station": STATION_BLOODWELL, "group": "akio", "stage": STAGE_AFTER_SHOGUN, "boss_material": MetaProgress.BOSS_MATERIAL_ECLIPSE_SHOGUN},

	# Bloodwell — Run Infrastructure
	{"id": "field_rest", "name": "Field Rest", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_FIRST_RETURN},
	{"id": "shrine_stabilization", "name": "Shrine Stabilization", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_AFTER_KEEPER},
	{"id": "expedition_preparation", "name": "Expedition Preparation", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_FIRST_RETURN},
	{"id": "route_intelligence", "name": "Route Intelligence", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_AFTER_KEEPER},
	{"id": "salvage_protocol", "name": "Salvage Protocol", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_AFTER_TWIN_MAWS},
	{"id": "keeper_passage", "name": "Keeper Passage", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_AFTER_KEEPER, "boss_material": MetaProgress.BOSS_MATERIAL_KEEPER},
	{"id": "twin_passage", "name": "Twin Passage", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_AFTER_TWIN_MAWS, "boss_material": MetaProgress.BOSS_MATERIAL_TWIN_MAWS},
	{"id": "heart_passage", "name": "Heart Passage", "station": STATION_BLOODWELL, "group": "run_infrastructure", "stage": STAGE_AFTER_SHOGUN, "boss_material": MetaProgress.BOSS_MATERIAL_ECLIPSE_SHOGUN},

	# Blood Mirror — three structural nodes per Aspect. Exact effects/prices are later tuning.
	{"id": "wolf_tier0_handling", "name": "Wolf Tier 0 Handling", "station": STATION_BLOOD_MIRROR, "group": "wolf", "stage": STAGE_AFTER_KEEPER},
	{"id": "wolf_signature_reliability", "name": "Wolf Signature Reliability", "station": STATION_BLOOD_MIRROR, "group": "wolf", "stage": STAGE_AFTER_TWIN_MAWS},
	{"id": "wolf_blood_discipline", "name": "Wolf Blood Discipline", "station": STATION_BLOOD_MIRROR, "group": "wolf", "stage": STAGE_AFTER_SHOGUN},
	{"id": "wraith_tier0_handling", "name": "Wraith Tier 0 Handling", "station": STATION_BLOOD_MIRROR, "group": "wraith", "stage": STAGE_AFTER_KEEPER},
	{"id": "wraith_signature_reliability", "name": "Wraith Signature Reliability", "station": STATION_BLOOD_MIRROR, "group": "wraith", "stage": STAGE_AFTER_TWIN_MAWS},
	{"id": "wraith_blood_discipline", "name": "Wraith Blood Discipline", "station": STATION_BLOOD_MIRROR, "group": "wraith", "stage": STAGE_AFTER_SHOGUN},
	{"id": "ronin_tier0_handling", "name": "Ronin Tier 0 Handling", "station": STATION_BLOOD_MIRROR, "group": "ronin", "stage": STAGE_AFTER_KEEPER},
	{"id": "ronin_signature_reliability", "name": "Ronin Signature Reliability", "station": STATION_BLOOD_MIRROR, "group": "ronin", "stage": STAGE_AFTER_TWIN_MAWS},
	{"id": "ronin_blood_discipline", "name": "Ronin Blood Discipline", "station": STATION_BLOOD_MIRROR, "group": "ronin", "stage": STAGE_AFTER_SHOGUN},
]

var _warned_legacy_purchase := false


func _ready() -> void:
	if MetaProgress != null and MetaProgress.has_signal("persistent_resources_changed"):
		MetaProgress.persistent_resources_changed.connect(_on_persistent_resources_changed)


func _on_persistent_resources_changed() -> void:
	changed.emit()


# =============================================================================
# CANONICAL RESOURCE / CAMPAIGN API
# =============================================================================

func get_mist() -> int:
	return int(MetaProgress.mist)


func get_scrolls() -> int:
	return int(MetaProgress.scrolls)


func get_boss_material(material_key: String) -> int:
	return MetaProgress.get_boss_material(material_key)


func can_afford_persistent_cost(mist_cost: int = 0, material_key: String = "", material_cost: int = 0) -> bool:
	if get_mist() < maxi(0, mist_cost):
		return false
	if material_key != "" and not MetaProgress.has_boss_material(material_key, material_cost):
		return false
	return true


func spend_persistent_cost(mist_cost: int = 0, material_key: String = "", material_cost: int = 0) -> bool:
	mist_cost = maxi(0, mist_cost)
	material_cost = maxi(0, material_cost)
	if not can_afford_persistent_cost(mist_cost, material_key, material_cost):
		return false

	if mist_cost > 0 and not MetaProgress.spend_mist(mist_cost):
		return false
	if material_key != "" and material_cost > 0:
		if not MetaProgress.spend_boss_material(material_key, material_cost):
			# Atomic refund if the material spend unexpectedly fails.
			MetaProgress.add_mist(mist_cost)
			return false
	return true


func is_blood_mirror_unlocked() -> bool:
	return MetaProgress.has_cleared_boss(1)


func get_boss_progression_stage() -> String:
	if MetaProgress.has_cleared_boss(3):
		return STAGE_AFTER_SHOGUN
	if MetaProgress.has_cleared_boss(2):
		return STAGE_AFTER_TWIN_MAWS
	if MetaProgress.has_cleared_boss(1):
		return STAGE_AFTER_KEEPER
	return STAGE_FIRST_RETURN


func get_structural_nodes(station: String = "") -> Array:
	var out: Array = []
	for node in STRUCTURAL_NODES:
		if station == "" or str(node.get("station", "")) == station:
			out.append(node.duplicate(true))
	return out


func get_structural_node(node_id: String) -> Dictionary:
	for node in STRUCTURAL_NODES:
		if str(node.get("id", "")) == node_id:
			return node.duplicate(true)
	return {}


# =============================================================================
# LEGACY TREE COMPATIBILITY
# =============================================================================
# The old tree is intentionally not purchaseable. Returning empty/default data keeps
# imported UI and run-start callers stable without applying obsolete permanent buffs.

func list_upgrades() -> Array:
	return []


func is_unlocked(_upgrade_id: String) -> bool:
	return false


func get_upgrade(_upgrade_id: String) -> Dictionary:
	return {}


func get_upgrade_cost(_upgrade_id: String) -> Dictionary:
	return {}


func can_purchase(_upgrade_id: String) -> bool:
	return false


func purchase(_upgrade_id: String) -> bool:
	_warn_legacy_purchase_once()
	return false


func get_unlocked_room_types() -> Array[String]:
	return []


func get_unlocked_wedges() -> Array[String]:
	return []


func get_gameplay_modifiers() -> Array[Dictionary]:
	return []


func get_tree_rank(_upgrade_id: String) -> int:
	return 0


func is_tree_maxed(_upgrade_id: String) -> bool:
	return false


func get_tree_upgrade(_upgrade_id: String) -> Dictionary:
	return {}


func get_tree_ids_for_branch(_branch: String) -> Array:
	return []


func get_tree_ids_for_tier(_branch: String, _tier: int) -> Array:
	return []


func count_tier_owned(_branch: String, _tier: int) -> int:
	return 0


func is_tier_unlocked(_branch: String, _tier: int) -> bool:
	return false


func get_tree_cost(_upgrade_id: String) -> Dictionary:
	return {}


func can_tree_purchase(_upgrade_id: String) -> bool:
	return false


func tree_purchase(_upgrade_id: String) -> bool:
	_warn_legacy_purchase_once()
	return false


func get_tree_effect(_upgrade_id: String) -> Dictionary:
	return {}


func get_total_tree_effect(_key: String) -> float:
	return 0.0


func has_tree_effect(_key: String) -> bool:
	return false


func apply_tree_effects(_player: Node) -> void:
	# No current permanent node has an approved numerical runtime effect yet.
	pass


func _warn_legacy_purchase_once() -> void:
	if _warned_legacy_purchase:
		return
	_warned_legacy_purchase = true
	push_warning("[MetaProgressionManager] Legacy Steel/Secrets/Vows purchases are retired; use Bloodwell/Forge/Blood Mirror progression.")
