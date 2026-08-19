extends Resource
class_name ProstheticData

## Defines a single prosthetic tool the player can equip.
## Create .tres files for each prosthetic (e.g. flame_vent.tres, shuriken.tres).

@export var id: String = ""
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D = null

## How many relics can be socketed into this prosthetic
@export var max_relic_slots: int = 2

## Spirit Emblem cost per use during a run (0 = free)
@export var spirit_cost: int = 1

## Upgrade tree for this prosthetic — ordered list of nodes.
## Each entry is a dict: { "id": String, "name": String, "description": String,
##   "cost_mist_shards": int, "cost_gold": int, "prerequisites": Array[String] }
## Keep it simple: linear chain or small branches.
@export var upgrade_nodes: Array[Dictionary] = []

## Tags for filtering in the UI (e.g. "fire", "ranged", "aoe")
@export var tags: Array[String] = []
