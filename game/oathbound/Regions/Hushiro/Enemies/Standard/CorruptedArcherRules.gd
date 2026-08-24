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

	print("[CorruptedArcherRules] 75 Health / 65 Posture stagger-first firing-line contract active")


# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
# EnemyBase intentionally exposes a no-op receive_deathblow() virtual. The imported
# Archer never implemented that virtual, so keep the executable contract explicit at
# this current Hushiro rules layer. Readiness itself is owned by the shared Hushiro
# posture-break runtime so 65/65 first means stagger, then Deathblow-ready.

func is_deathblow_ready() -> bool:
	if has_died or int(hp) <= 0 or combat == null:
		return false
	var runtime: Node = get_node_or_null("HushiroPostureBreakRuntime")
	if runtime != null and runtime.has_method("is_deathblow_armed"):
		return bool(runtime.call("is_deathblow_armed"))
	return bool(get_meta("_oathbound_deathblow_ready", false))


func receive_deathblow(attacker: Node) -> void:
	if has_died or int(hp) <= 0:
		return

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("enemy_deathblow_executed", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"attacker": CombatTelemetry.snapshot_actor(attacker) if attacker != null else {},
		})

	death()
