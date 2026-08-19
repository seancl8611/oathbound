extends Resource
class_name RelicData

## A relic that can be socketed into a prosthetic at the Forge Bench.
## Relics modify the prosthetic's behavior or grant passive bonuses while equipped.

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D = null

## Stat modifiers applied while this relic is socketed.
## Keys match stat names in your player/combat system.
## e.g. { "spirit_cost_reduction": -1, "burn_damage_bonus": 5 }
@export var stat_modifiers: Dictionary = {}

## Optional: restrict which prosthetic tags this relic can socket into.
## Empty = universal (fits any prosthetic).
## e.g. ["fire"] means only fire-tagged prosthetics.
@export var compatible_tags: Array[String] = []

## Rarity for UI styling / merchant pricing
@export_enum("Common", "Uncommon", "Rare", "Legendary") var rarity: String = "Common"
