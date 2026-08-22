extends RefCounted
class_name RelicCatalog

## Approved launch Relic roster from docs/gameplay/RELICS.md.
##
## The identities and core effects are design authority. Exact numeric values for most
## Relics, mastery thresholds, and mastery improvements are explicitly deferred by the
## design doc, so the values below are FIRST-PLAYTEST TUNING ONLY. Keep them easy to
## find and change; do not treat them as newly approved paper-design numbers.

const TRAVELERS_COIN: String = "travelers_coin"
const MERCHANTS_SEAL: String = "merchants_seal"
const IRON_PRAYER_BEAD: String = "iron_prayer_bead"
const SPIRIT_TASSEL: String = "spirit_tassel"
const EXECUTION_BEAD: String = "execution_bead"
const WAYFARERS_CHARM: String = "wayfarers_charm"
const LAST_OATH: String = "last_oath"
const UNBROKEN_CORD: String = "unbroken_cord"
const SCRIBES_LENS: String = "scribes_lens"
const BLOOD_MOON_SHARD: String = "blood_moon_shard"

const IDS: Array[String] = [
	TRAVELERS_COIN,
	MERCHANTS_SEAL,
	IRON_PRAYER_BEAD,
	SPIRIT_TASSEL,
	EXECUTION_BEAD,
	WAYFARERS_CHARM,
	LAST_OATH,
	UNBROKEN_CORD,
	SCRIBES_LENS,
	BLOOD_MOON_SHARD,
]

# First-playtest mastery thresholds. The approved structure is exactly Base ->
# Mastery I -> Mastery II; the exact kill thresholds remain playtest tuning.
const MASTERY_I_KILLS: int = 15
const MASTERY_II_KILLS: int = 40

# Each values array is [Base, Mastery I, Mastery II].
const DATA: Dictionary = {
	TRAVELERS_COIN: {
		"name": "Traveler's Coin",
		"role": "Economy",
		"effect": "starting_gold",
		"values": [40.0, 60.0, 80.0],
		"approved": "Begin each run with additional Gold.",
	},
	MERCHANTS_SEAL: {
		"name": "Merchant's Seal",
		"role": "Economy",
		"effect": "regional_first_purchase_discount",
		# Base 20% is approved. Mastery values are first-playtest tuning.
		"values": [0.20, 0.25, 0.30],
		"approved": "The first purchase in each region costs 20% less Gold at Base.",
	},
	IRON_PRAYER_BEAD: {
		"name": "Iron Prayer Bead",
		"role": "Survival",
		"effect": "max_health",
		"values": [10.0, 15.0, 20.0],
		"approved": "Increase Akio's maximum Health.",
	},
	SPIRIT_TASSEL: {
		"name": "Spirit Tassel",
		"role": "Prosthetic-resource support",
		"effect": "max_spirit",
		"values": [15.0, 20.0, 25.0],
		"approved": "Increase Akio's maximum Spirit capacity.",
	},
	EXECUTION_BEAD: {
		"name": "Execution Bead",
		"role": "Combat sustain",
		"effect": "deathblow_spirit",
		"values": [10.0, 15.0, 20.0],
		"approved": "Deathblows restore a small amount of Spirit.",
	},
	WAYFARERS_CHARM: {
		"name": "Wayfarer's Charm",
		"role": "Steady recovery",
		"effect": "room_entry_heal",
		"values": [3.0, 5.0, 7.0],
		"approved": "Entering a room restores a small amount of Health.",
	},
	LAST_OATH: {
		"name": "Last Oath",
		"role": "Emergency survival",
		"effect": "lethal_survival_hp",
		# Base 25 HP is approved. Mastery values are first-playtest tuning.
		"values": [25.0, 30.0, 35.0],
		"approved": "Once per run, lethal damage instead leaves Akio at 25 HP at Base.",
	},
	UNBROKEN_CORD: {
		"name": "Unbroken Cord",
		"role": "Clean-play reward",
		"effect": "clean_room_gold",
		"values": [15.0, 25.0, 35.0],
		"approved": "Clearing a combat room without taking Health damage grants bonus Gold.",
	},
	SCRIBES_LENS: {
		"name": "Scribe's Lens",
		"role": "Build consistency",
		"effect": "regional_technique_extra_choice",
		# Base = first Technique reward in each region. Mastery keeps the same effect
		# and improves its frequency, which the design doc explicitly permits.
		"values": [1.0, 2.0, 3.0],
		"approved": "The first Technique reward in each region presents one additional choice.",
	},
	BLOOD_MOON_SHARD: {
		"name": "Blood Moon Shard",
		"role": "Blood / Spirit interaction",
		"effect": "blood_art_spirit",
		"values": [8.0, 12.0, 16.0],
		"approved": "Using a Blood Art restores a small amount of Spirit.",
	},
}


static func has(relic_id: String) -> bool:
	return DATA.has(relic_id)


static func get_data(relic_id: String) -> Dictionary:
	if not DATA.has(relic_id):
		return {}
	var data: Dictionary = DATA[relic_id]
	var copy: Dictionary = data.duplicate(true)
	copy["id"] = relic_id
	return copy


static func get_name(relic_id: String) -> String:
	return str(DATA.get(relic_id, {}).get("name", relic_id))


static func mastery_rank_for_kills(kills: int) -> int:
	if kills >= MASTERY_II_KILLS:
		return 2
	if kills >= MASTERY_I_KILLS:
		return 1
	return 0


static func value_for_rank(relic_id: String, rank: int) -> float:
	if not DATA.has(relic_id):
		return 0.0
	var values_value: Variant = DATA[relic_id].get("values", [])
	if not (values_value is Array):
		return 0.0
	var values: Array = values_value as Array
	if values.is_empty():
		return 0.0
	var index: int = clampi(rank, 0, values.size() - 1)
	return float(values[index])
