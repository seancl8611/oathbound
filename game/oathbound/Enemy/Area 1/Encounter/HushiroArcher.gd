extends "res://Enemy/Area 1/Encounter/corrupted_archer.gd"

## Current Hushiro rules layer over the imported Archer movement/aiming controller.
## The inherited firing-line spacing and retreat behavior already match the approved
## qualitative role; this wrapper removes stale durability/Posture defaults everywhere
## the scene is instantiated, including direct Playtest Lab spawns.

const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")


func _ready() -> void:
	super._ready()
	HUSHIRO_ENEMY_CONTRACT.apply(self, "archer")

	# Archer remains vulnerable once Akio closes cleanly. Keep a weak reactive guard,
	# never a permanent/default frontal defense.
	can_block = true
	block_by_default = false
	block_chance_on_hit = 0.20

	print("[HushiroArcher] 75 Health / 65 Posture firing-line contract active")
