extends "res://autoload/ProstheticManager.gd"

## Current Oathbound Prosthetic registry/progression authority.
##
## The imported manager remains the compatibility surface for save/UI callers, but
## the current roster, Spirit costs, starting loadout, and permanent upgrade economy
## come from docs/gameplay/PROSTHETICS.md.

const CURRENT_IDS: Array[String] = [
	"beast_whistle",
	"thunder_rod",
	"smoke_gourd",
	"fang_harpoon",
	"mirror_umbrella",
	"flame_vent",
	"mist_raven",
	"bloodletting_gourd",
]
const STARTING_PROSTHETIC: String = "beast_whistle"
const EXPECTED_UPGRADE_COUNT: int = 19


func _ready() -> void:
	_registry.clear()
	_relic_registry.clear()
	_register_defaults()
	_validate_current_registry()


func _register_defaults() -> void:
	# Prosthetic-owned Relic sockets/modifiers are not part of the approved current
	# Prosthetic contract. max_relic_slots is therefore 0 on current registrations.
	_register_prosthetic_from_code(
		"beast_whistle", "Beast-Bane Whistle",
		"A short-radius interrupt pulse with stronger posture pressure against beast-classified enemies.",
		16, 0, ["control", "beast", "area"],
		[
			_upgrade("reinforced_resonance", "Reinforced Resonance", "Normal posture 18→24; beast posture 28→38.", 2),
			_upgrade("broad_resonance", "Broad Resonance", "Pulse radius 110→145 px.", 4, ["reinforced_resonance"]),
		]
	)
	_register_prosthetic_from_code(
		"thunder_rod", "Thunder Rod",
		"A fixed-direction first-target line strike that applies Shock setup for the next direct sword hit.",
		22, 0, ["line", "shock", "setup"],
		[
			_upgrade("charged_conductor", "Charged Conductor", "Impact 22→28 Health and 18→24 posture.", 2),
			_upgrade("lingering_current", "Lingering Current", "Shock duration 3.0→5.0 s.", 4, ["charged_conductor"]),
		]
	)
	_register_prosthetic_from_code(
		"smoke_gourd", "Smoke Gourd",
		"Creates a temporary control field that disrupts ordinary enemy targeting without hiding committed attack tells.",
		24, 0, ["control", "field", "defensive"],
		[
			_upgrade("expanded_cloud", "Expanded Cloud", "Field radius 115→155 px.", 2),
			_upgrade("dense_mixture", "Dense Mixture", "Field persistence 3.0→4.5 s.", 4, ["expanded_cloud"]),
		]
	)
	_register_prosthetic_from_code(
		"fang_harpoon", "Fang Harpoon",
		"A fixed-direction medium-range shot with strong posture pressure and an eligible enemy pull.",
		18, 0, ["ranged", "pull", "posture"],
		[
			_upgrade("reinforced_chain", "Reinforced Chain", "Eligible pull distance 45→65 px.", 2),
			_upgrade("heavy_barb", "Heavy Barb", "Posture 20→28 and stronger ordinary-enemy interrupt.", 4, ["reinforced_chain"]),
		]
	)
	_register_prosthetic_from_code(
		"mirror_umbrella", "Mirror Umbrella",
		"A timed frontal guard that converts incoming block pressure into a compact posture release.",
		20, 0, ["guard", "defensive", "posture"],
		[
			_upgrade("reinforced_canopy", "Reinforced Canopy", "Stored-pressure capacity 50→70.", 2),
			_upgrade("efficient_mechanism", "Efficient Mechanism", "Spirit cost 20→15.", 4, ["reinforced_canopy"]),
			_upgrade("weighted_release", "Weighted Release", "Release becomes 100% stored pressure, capped at 55 posture.", 6, ["efficient_mechanism"]),
		]
	)
	_register_prosthetic_from_code(
		"flame_vent", "Flame Vent",
		"A short forward cone that deals direct Health damage and applies the Prosthetic Burn status.",
		20, 0, ["fire", "burn", "cone"],
		[
			_upgrade("pressurized_vent", "Pressurized Vent", "Cone reach 100→130 px.", 2),
			_upgrade("refined_fuel", "Refined Fuel", "Immediate Health damage 18→25.", 4, ["pressurized_vent"]),
			_upgrade("persistent_burn", "Persistent Burn", "Burn duration 4.0→6.0 s at the same 3 Health/sec rate.", 6, ["refined_fuel"]),
		]
	)
	_register_prosthetic_from_code(
		"mist_raven", "Mist Raven",
		"A very short fixed-direction invulnerable blink used for tactical repositioning.",
		26, 0, ["mobility", "invulnerable", "blink"],
		[
			_upgrade("efficient_passage", "Efficient Passage", "Spirit cost 26→20.", 2),
			_upgrade("farther_passage", "Farther Passage", "Blink distance 72→92 px.", 4, ["efficient_passage"]),
		]
	)
	_register_prosthetic_from_code(
		"bloodletting_gourd", "Bloodletting Gourd",
		"Immediate healing followed by a short window that returns part of actual direct sword Health damage as healing.",
		30, 0, ["healing", "sustain", "aggression"],
		[
			_upgrade("deeper_draught", "Deeper Draught", "Immediate heal 15→22 Health.", 2),
			_upgrade("longer_bloodletting", "Longer Bloodletting", "Healing-on-hit window 4.0→6.0 s.", 4, ["deeper_draught"]),
			_upgrade("stronger_return", "Stronger Return", "Healing return 12%→18% and activation cap 12→18 Health.", 6, ["longer_bloodletting"]),
		]
	)

	# Preserve the currently imported Relic registry only as a compatibility surface.
	# Current Prosthetics do not consume these modifiers; Relics are reconciled in the
	# next player-build implementation package.
	_register_relic_from_code("ember_core", "Ember Core", "Compatibility relic pending current Relic reconciliation.", {}, [], "Uncommon")
	_register_relic_from_code("wind_charm", "Wind Charm", "Compatibility relic pending current Relic reconciliation.", {}, [], "Common")
	_register_relic_from_code("iron_bead", "Iron Prayer Bead", "Compatibility relic pending current Relic reconciliation.", {}, [], "Common")

	# Campaign default: Beast-Bane Whistle is the only guaranteed starting unlock.
	if not unlocked_prosthetics.has(STARTING_PROSTHETIC):
		unlocked_prosthetics[STARTING_PROSTHETIC] = true
	if equipped_prosthetic_id.is_empty() or not _registry.has(equipped_prosthetic_id):
		equipped_prosthetic_id = STARTING_PROSTHETIC

	print("[OathboundProstheticManager] current roster=%d upgrades=%d equipped=%s" % [
		_registry.size(), get_total_upgrade_count(), equipped_prosthetic_id,
	])


func _upgrade(id: String, name: String, description: String, scroll_cost: int, prerequisites: Array = []) -> Dictionary:
	return {
		"id": id,
		"name": name,
		"description": description,
		"cost_scrolls": scroll_cost,
		"cost_mist_shards": 0,
		"cost_gold": 0,
		"prerequisites": prerequisites.duplicate(),
	}


func get_total_upgrade_count() -> int:
	var total: int = 0
	for prosthetic_id: String in CURRENT_IDS:
		var data: ProstheticData = get_prosthetic(prosthetic_id)
		if data != null:
			total += data.upgrade_nodes.size()
	return total


func get_effective_spirit_cost(prosthetic_id: String) -> int:
	var data: ProstheticData = get_prosthetic(prosthetic_id)
	if data == null:
		return 0
	if prosthetic_id == "mirror_umbrella" and is_upgrade_purchased(prosthetic_id, "efficient_mechanism"):
		return 15
	if prosthetic_id == "mist_raven" and is_upgrade_purchased(prosthetic_id, "efficient_passage"):
		return 20
	return maxi(0, data.spirit_cost)


func get_upgrade_cost(prosthetic_id: String, upgrade_id: String) -> Dictionary:
	var data: ProstheticData = get_prosthetic(prosthetic_id)
	if data == null:
		return {}
	for node: Dictionary in data.upgrade_nodes:
		if str(node.get("id", "")) == upgrade_id:
			return {"scrolls": int(node.get("cost_scrolls", 0))}
	return {}


func purchase_upgrade(prosthetic_id: String, upgrade_id: String) -> bool:
	if not can_purchase_upgrade(prosthetic_id, upgrade_id):
		return false
	var cost: Dictionary = get_upgrade_cost(prosthetic_id, upgrade_id)
	var scroll_cost: int = int(cost.get("scrolls", 0))
	if typeof(MetaProgress) != TYPE_OBJECT or not MetaProgress.spend_scrolls(scroll_cost):
		return false
	if not purchased_upgrades.has(prosthetic_id):
		purchased_upgrades[prosthetic_id] = {}
	purchased_upgrades[prosthetic_id][upgrade_id] = true
	upgrade_purchased.emit(prosthetic_id, upgrade_id)
	return true


func get_equipped_stat_modifiers() -> Dictionary:
	# The imported socketed-Prosthetic Relic modifier path is not part of the current
	# approved Prosthetic package. Return no modifiers until Relics are reconciled.
	return {}


func unlock_all_for_playtest() -> void:
	for prosthetic_id: String in CURRENT_IDS:
		unlocked_prosthetics[prosthetic_id] = true


func grant_all_upgrades_for_playtest(prosthetic_id: String) -> void:
	var data: ProstheticData = get_prosthetic(prosthetic_id)
	if data == null:
		return
	if not purchased_upgrades.has(prosthetic_id):
		purchased_upgrades[prosthetic_id] = {}
	for node: Dictionary in data.upgrade_nodes:
		purchased_upgrades[prosthetic_id][str(node.get("id", ""))] = true


func clear_upgrades_for_playtest(prosthetic_id: String) -> void:
	purchased_upgrades.erase(prosthetic_id)


func _validate_current_registry() -> void:
	var issues: Array[String] = []
	for prosthetic_id: String in CURRENT_IDS:
		if not _registry.has(prosthetic_id):
			issues.append("missing:%s" % prosthetic_id)
	if _registry.size() != CURRENT_IDS.size():
		issues.append("roster_count=%d" % _registry.size())
	if get_total_upgrade_count() != EXPECTED_UPGRADE_COUNT:
		issues.append("upgrade_count=%d" % get_total_upgrade_count())
	if issues.is_empty():
		print("[OathboundProstheticManager] registry validation PASS")
	else:
		push_error("[OathboundProstheticManager] registry validation FAIL: %s" % ", ".join(issues))
