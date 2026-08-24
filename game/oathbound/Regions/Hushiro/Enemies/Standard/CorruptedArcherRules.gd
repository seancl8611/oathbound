extends "res://Regions/Hushiro/Enemies/Standard/CorruptedArcherController.gd"

## Current Hushiro rules layer over the imported Archer movement/aiming controller.
## The inherited firing-line spacing and retreat behavior already match the approved
## qualitative role; this wrapper owns current durability/Posture and execution rules.

const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")
const HUSHIRO_PROJECTILE = preload("res://Regions/Hushiro/Enemies/Standard/CorruptedArcherProjectile.tscn")


func _ready() -> void:
	# Keep current Hushiro runtime identity and dependencies on canonical resources.
	name = "CorruptedArcher"
	projectile_scene = HUSHIRO_PROJECTILE

	super._ready()
	HUSHIRO_ENEMY_CONTRACT.apply(self, "archer")

	# Archer remains vulnerable once Akio closes cleanly. Keep a weak reactive guard,
	# never a permanent/default frontal defense.
	can_block = true
	block_by_default = false
	block_chance_on_hit = 0.20

	print("[CorruptedArcherRules] 75 Health / 65 Posture firing-line contract active")


# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
# EnemyBase intentionally exposes a no-op receive_deathblow() virtual. The imported
# Archer never implemented that virtual, so a valid 65/65 Posture break could be
# targeted and play finisher feedback while leaving the Archer alive. Keep the
# executable contract explicit at the current Hushiro rules layer.

func is_deathblow_ready() -> bool:
	if has_died or combat == null:
		return false
	return combat.get_posture_ratio() >= 0.999


func receive_deathblow(attacker: Node) -> void:
	if has_died:
		return

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_deathblow_executed", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"attacker": CombatTelemetry.snapshot_actor(attacker) if attacker != null else {},
		})

	death()
