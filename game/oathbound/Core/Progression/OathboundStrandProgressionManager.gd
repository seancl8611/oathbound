extends "res://Utility/MetaProgressionManager.gd"

## Canonical first-playtest Strand permanent-progression runtime.
## PROGRESSION.md owns the structure; the values below are deliberately centralized
## first-playtest tuning so they can move without changing the approved node roles.

const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

const TRIAL_EXECUTION := "execution_trial"
const TRIAL_LAST_OATH := "last_oath_trial"

const CAMPAIGN_RELICS: Dictionary = {
	"first_return": RELIC_CATALOG.TRAVELERS_COIN,
	"keeper": RELIC_CATALOG.IRON_PRAYER_BEAD,
	"twin_maws": RELIC_CATALOG.SPIRIT_TASSEL,
	"shogun": RELIC_CATALOG.BLOOD_MOON_SHARD,
}
const CHALLENGE_RELICS: Dictionary = {
	TRIAL_EXECUTION: RELIC_CATALOG.EXECUTION_BEAD,
	TRIAL_LAST_OATH: RELIC_CATALOG.LAST_OATH,
}
const RUN_DISCOVERED_RELICS: Array[String] = [
	RELIC_CATALOG.MERCHANTS_SEAL,
	RELIC_CATALOG.WAYFARERS_CHARM,
	RELIC_CATALOG.UNBROKEN_CORD,
	RELIC_CATALOG.SCRIBES_LENS,
]

# First-playtest tuning only. Cost bands and node roles come from PROGRESSION.md.
const NODE_TUNING: Dictionary = {
	"vitality": {"mist": 50, "effects": {"max_health": 10.0}},
	"composure": {"mist": 50, "effects": {"max_posture": 10.0}},
	"spirit_reserve": {"mist": 50, "effects": {"max_spirit": 10.0}},
	"field_rest": {"mist": 50, "effects": {"rest_heal_mult": 1.15}},
	"expedition_preparation": {"mist": 75, "effects": {"starting_rerolls": 1.0}},

	"posture_recovery": {"mist": 75, "effects": {"posture_recovery_mult": 1.12}},
	"recovery_efficiency": {"mist": 75, "effects": {"recovery_heal_mult": 1.15}},
	"deflection_stability": {"mist": 100, "effects": {"parry_posture_clear": 4.0}},
	"execution_stability": {"mist": 100, "effects": {"deathblow_posture_clear": 12.0}},
	"shrine_stabilization": {"mist": 100, "effects": {"resist_corruption_target": 65.0}},
	"route_intelligence": {"mist": 100, "effects": {"route_intelligence": 1.0}},
	"body_mastery": {"mist": 200, "material": MATERIAL_KEEPER, "material_cost": 1, "effects": {"max_health": 15.0, "max_posture": 10.0}},
	"keeper_passage": {"mist": 200, "material": MATERIAL_KEEPER, "material_cost": 1, "effects": {"keeper_passage": 1.0}},

	"salvage_protocol": {"mist": 125, "effects": {"persistent_reward_mult": 1.10}},
	"resource_mastery": {"mist": 200, "material": MATERIAL_TWIN_MAWS, "material_cost": 1, "effects": {"max_spirit": 15.0}},
	"twin_passage": {"mist": 225, "material": MATERIAL_TWIN_MAWS, "material_cost": 1, "effects": {"twin_passage": 1.0}},

	"returning_blood_mastery": {"mist": 250, "material": MATERIAL_ECLIPSE_SHOGUN, "material_cost": 1, "effects": {"max_health": 10.0, "max_posture": 10.0, "max_spirit": 10.0}},
	"heart_passage": {"mist": 250, "material": MATERIAL_ECLIPSE_SHOGUN, "material_cost": 1, "effects": {"heart_passage": 1.0}},

	"wolf_tier0_handling": {"mist": 75, "effects": {"wolf_recovery_mult": 0.95}},
	"wolf_signature_reliability": {"mist": 100, "effects": {"wolf_signature_recovery_mult": 0.92}},
	"wolf_blood_discipline": {"mist": 125, "effects": {"wolf_blood_hunt_heal_bonus": 5.0}},
	"wraith_tier0_handling": {"mist": 75, "effects": {"wraith_recovery_mult": 0.95}},
	"wraith_signature_reliability": {"mist": 100, "effects": {"wraith_spectral_min_range_mult": 0.90}},
	"wraith_blood_discipline": {"mist": 125, "effects": {"wraith_blood_recovery_mult": 0.90}},
	"ronin_tier0_handling": {"mist": 75, "effects": {"ronin_recovery_mult": 0.95}},
	"ronin_signature_reliability": {"mist": 100, "effects": {"ronin_block_posture_mult": 0.95}},
	"ronin_blood_discipline": {"mist": 125, "effects": {"ronin_falling_mountain_posture_bonus": 7.0}},
}


func _ready() -> void:
	super._ready()
	if MetaProgress != null and MetaProgress.has_signal("progression_changed"):
		var cb := Callable(self, "_on_progression_changed")
		if not MetaProgress.is_connected("progression_changed", cb):
			MetaProgress.connect("progression_changed", cb)
	call_deferred("synchronize_campaign_rewards")
	print("[OathboundStrandProgression] v1.0 - Bloodwell/Blood Mirror/campaign progression")


func _on_progression_changed() -> void:
	changed.emit()
	call_deferred("synchronize_campaign_rewards")


func is_strand_progression_unlocked() -> bool:
	return typeof(MetaProgress) == TYPE_OBJECT and bool(MetaProgress.is_returning_blood_awakened())


func get_progression_node(node_id: String) -> Dictionary:
	var structural := get_structural_node(node_id)
	if structural.is_empty():
		return {}
	var tuning: Dictionary = NODE_TUNING.get(node_id, {})
	for key in tuning:
		structural[key] = tuning[key]
	structural["owned"] = is_node_owned(node_id)
	structural["available"] = is_node_available(node_id)
	return structural


func get_nodes_for_station(station: String) -> Array:
	var out: Array = []
	for structural in get_structural_nodes(station):
		out.append(get_progression_node(str(structural.get("id", ""))))
	return out


func is_node_owned(node_id: String) -> bool:
	return typeof(MetaProgress) == TYPE_OBJECT and bool(MetaProgress.is_progression_node_owned(node_id))


func is_node_available(node_id: String) -> bool:
	if not is_strand_progression_unlocked():
		return false
	var node := get_structural_node(node_id)
	if node.is_empty():
		return false
	if str(node.get("station", "")) == STATION_BLOOD_MIRROR and not is_blood_mirror_unlocked():
		return false
	return _stage_is_available(str(node.get("stage", STAGE_FIRST_RETURN)))


func _stage_is_available(stage: String) -> bool:
	match stage:
		STAGE_FIRST_RETURN:
			return true
		STAGE_AFTER_KEEPER, STAGE_AFTER_KEEPER_OR_LATER:
			return MetaProgress.has_cleared_boss(1)
		STAGE_AFTER_TWIN_MAWS:
			return MetaProgress.has_cleared_boss(2)
		STAGE_AFTER_SHOGUN:
			return MetaProgress.has_cleared_boss(3)
	return false


func get_node_cost(node_id: String) -> Dictionary:
	var tuning: Dictionary = NODE_TUNING.get(node_id, {})
	if tuning.is_empty():
		return {}
	return {
		"mist": int(tuning.get("mist", 0)),
		"material": str(tuning.get("material", "")),
		"material_cost": int(tuning.get("material_cost", 0)),
	}


func can_purchase_node(node_id: String) -> bool:
	if is_node_owned(node_id) or not is_node_available(node_id):
		return false
	var cost := get_node_cost(node_id)
	if cost.is_empty():
		return false
	return can_afford_persistent_cost(int(cost.get("mist", 0)), str(cost.get("material", "")), int(cost.get("material_cost", 0)))


func purchase_node(node_id: String) -> bool:
	if not can_purchase_node(node_id):
		return false
	var cost := get_node_cost(node_id)
	if not spend_persistent_cost(int(cost.get("mist", 0)), str(cost.get("material", "")), int(cost.get("material_cost", 0))):
		return false
	if not MetaProgress.mark_progression_node_owned(node_id):
		# This should be unreachable after the ownership check. Refund defensively.
		MetaProgress.add_mist(int(cost.get("mist", 0)))
		var material := str(cost.get("material", ""))
		var material_cost := int(cost.get("material_cost", 0))
		if not material.is_empty() and material_cost > 0:
			MetaProgress.add_boss_material(material, material_cost)
		return false
	changed.emit()
	return true


func get_effect_total(effect_key: String) -> float:
	var total := 0.0
	for node_id in NODE_TUNING:
		if not is_node_owned(str(node_id)):
			continue
		var effects_value: Variant = (NODE_TUNING[node_id] as Dictionary).get("effects", {})
		if effects_value is Dictionary:
			total += float((effects_value as Dictionary).get(effect_key, 0.0))
	return total


func has_effect(effect_key: String) -> bool:
	return absf(get_effect_total(effect_key)) > 0.0001


func get_multiplier(effect_key: String, default_value: float = 1.0) -> float:
	# Multipliers are single authored nodes in the current launch package. Returning the
	# stored value avoids treating 1.15 as a +115% additive modifier.
	for node_id in NODE_TUNING:
		if not is_node_owned(str(node_id)):
			continue
		var effects: Dictionary = (NODE_TUNING[node_id] as Dictionary).get("effects", {})
		if effects.has(effect_key):
			return float(effects[effect_key])
	return default_value


func apply_player_capacity(player: Node) -> void:
	if player == null or not is_instance_valid(player):
		return
	var hp_bonus := int(round(get_effect_total("max_health")))
	var posture_bonus := float(get_effect_total("max_posture"))
	var spirit_bonus := int(round(get_effect_total("max_spirit")))

	if "maxhp" in player and "hp" in player:
		var old_hp_bonus := int(player.get_meta("_strand_health_bonus", 0))
		var base_max := maxi(1, int(player.get("maxhp")) - old_hp_bonus)
		var delta := hp_bonus - old_hp_bonus
		player.set("maxhp", base_max + hp_bonus)
		player.set("hp", mini(int(player.get("maxhp")), int(player.get("hp")) + maxi(0, delta)))
		player.set_meta("_strand_health_bonus", hp_bonus)
		if player.has_method("_update_health_bar"):
			player.call("_update_health_bar")

	if "stagger_max" in player:
		var old_posture_bonus := float(player.get_meta("_strand_posture_bonus", 0.0))
		var base_posture := maxf(1.0, float(player.get("stagger_max")) - old_posture_bonus)
		player.set("stagger_max", base_posture + posture_bonus)
		player.set_meta("_strand_posture_bonus", posture_bonus)
	if "stagger_regen_rate" in player:
		player.set("stagger_regen_rate", float(player.get("stagger_regen_rate")) * get_multiplier("posture_recovery_mult", 1.0))

	var executor_value: Variant = player.get("prosthetic_executor")
	if executor_value is Node and is_instance_valid(executor_value):
		var executor := executor_value as Node
		var old_spirit_bonus := int(executor.get_meta("_strand_spirit_bonus", 0))
		var current_max := int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else int(executor.get("max_spirit"))
		var current := int(executor.call("get_spirit")) if executor.has_method("get_spirit") else int(executor.get("current_spirit"))
		var base_spirit := maxi(1, current_max - old_spirit_bonus)
		var delta_spirit := spirit_bonus - old_spirit_bonus
		executor.set("max_spirit", base_spirit + spirit_bonus)
		executor.set("current_spirit", mini(base_spirit + spirit_bonus, current + maxi(0, delta_spirit)))
		executor.set_meta("_strand_spirit_bonus", spirit_bonus)
		if executor.has_signal("spirit_changed"):
			executor.emit_signal("spirit_changed", int(executor.get("current_spirit")), int(executor.get("max_spirit")))


func get_starting_reroll_bonus() -> int:
	return int(round(get_effect_total("starting_rerolls")))


func get_rest_heal_amount(base_amount: int) -> int:
	var amount := float(base_amount) * get_multiplier("rest_heal_mult", 1.0) * get_multiplier("recovery_heal_mult", 1.0)
	return maxi(0, int(round(amount)))


func get_resist_corruption_target(default_target: int = 75) -> int:
	if has_effect("resist_corruption_target"):
		return clampi(int(round(get_effect_total("resist_corruption_target"))), 0, 100)
	return default_target


func get_route_intelligence_level() -> int:
	return int(round(get_effect_total("route_intelligence")))


func get_persistent_reward_multiplier() -> float:
	return get_multiplier("persistent_reward_mult", 1.0)


func has_passage_upgrade(passage_id: String) -> bool:
	return has_effect(passage_id)


# =============================================================================
# RELIC SOURCE PARTITION / BLOOD CAVERN FIRST-TIME CLAIMS
# =============================================================================

func synchronize_campaign_rewards() -> void:
	if not is_strand_progression_unlocked():
		return
	_grant_campaign_relic("first_return")
	if MetaProgress.has_cleared_boss(1):
		_grant_campaign_relic("keeper")
	if MetaProgress.has_cleared_boss(2):
		_grant_campaign_relic("twin_maws")
	if MetaProgress.has_cleared_boss(3):
		_grant_campaign_relic("shogun")


func _grant_campaign_relic(stage_id: String) -> bool:
	var relic_id := str(CAMPAIGN_RELICS.get(stage_id, ""))
	if relic_id.is_empty() or typeof(RelicRuntime) != TYPE_OBJECT:
		return false
	var flag := "relic_campaign_%s" % stage_id
	if bool(MetaProgress.get_progression_flag(flag, false)):
		return false
	RelicRuntime.discover_relic(relic_id, false)
	MetaProgress.set_progression_flag(flag, true)
	return true


func complete_blood_cavern_trial(trial_id: String) -> Dictionary:
	var result := {"first_clear": false, "relic_id": ""}
	if trial_id not in CHALLENGE_RELICS:
		return result
	var first_clear := MetaProgress.mark_blood_cavern_trial_complete(trial_id)
	result["first_clear"] = first_clear
	if not first_clear:
		return result
	var relic_id := str(CHALLENGE_RELICS[trial_id])
	if typeof(RelicRuntime) == TYPE_OBJECT:
		RelicRuntime.discover_relic(relic_id, false)
	result["relic_id"] = relic_id
	return result


func get_run_discovered_relic_pool() -> Array[String]:
	var undiscovered: Array[String] = []
	var all_pool: Array[String] = []
	for relic_id in RUN_DISCOVERED_RELICS:
		all_pool.append(relic_id)
		if typeof(RelicRuntime) != TYPE_OBJECT or not RelicRuntime.is_unlocked(relic_id):
			undiscovered.append(relic_id)
	return undiscovered if not undiscovered.is_empty() else all_pool


func is_run_discovered_relic(relic_id: String) -> bool:
	return relic_id in RUN_DISCOVERED_RELICS


# =============================================================================
# LEGACY TREE API — map old callers onto current ownership where harmless.
# =============================================================================

func list_upgrades() -> Array:
	return get_nodes_for_station(STATION_BLOODWELL)


func is_unlocked(upgrade_id: String) -> bool:
	return is_node_owned(upgrade_id)


func get_upgrade(upgrade_id: String) -> Dictionary:
	return get_progression_node(upgrade_id)


func get_upgrade_cost(upgrade_id: String) -> Dictionary:
	return get_node_cost(upgrade_id)


func can_purchase(upgrade_id: String) -> bool:
	return can_purchase_node(upgrade_id)


func purchase(upgrade_id: String) -> bool:
	return purchase_node(upgrade_id)


func get_total_tree_effect(key: String) -> float:
	return get_effect_total(key)


func has_tree_effect(key: String) -> bool:
	return has_effect(key)


func apply_tree_effects(player: Node) -> void:
	apply_player_capacity(player)
