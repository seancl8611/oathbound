extends "res://Regions/Hushiro/Enemies/Standard/Hollow.gd"

## Runtime completion layer for the rebuilt Hollow.
##
## Hollow.gd owns its authored swarm behavior. This layer ensures the shared
## CombatController is actually ticked every frame, so the Hushiro 1.5 s posture
## recovery delay / 20 posture-per-second recovery contract functions. It also records
## explicit parry posture before/after values and uses the shared Hushiro stagger-first
## Deathblow contract.

const HOLLOW_PARRY_POSTURE_DAMAGE: float = 20.0


func _ready() -> void:
	super._ready()
	print("[Hollow] v2.2 - posture + stagger-first deathblow runtime active")


func _physics_process(delta: float) -> void:
	if state != HollowState.DEAD and not has_died:
		_tick_hollow_combat_runtime(delta)
	super._physics_process(delta)


func _tick_hollow_combat_runtime(delta: float) -> void:
	if combat == null:
		return

	var attacking: bool = state == HollowState.WINDUP or state == HollowState.ATTACK
	combat.update_host_state(attacking, false, false, true)
	combat.tick(delta)


func is_deathblow_ready() -> bool:
	if has_died or state == HollowState.DEAD or int(hp) <= 0:
		return false
	var runtime: Node = get_node_or_null("HushiroPostureBreakRuntime")
	if runtime != null and runtime.has_method("is_deathblow_armed"):
		return bool(runtime.call("is_deathblow_armed"))
	return bool(get_meta("_oathbound_deathblow_ready", false))


func on_parried(parrier_pos: Vector2) -> void:
	var posture_before: float = get_posture_value()
	super.on_parried(parrier_pos)
	var posture_after: float = get_posture_value()
	var posture_max: float = 0.0
	if combat != null and combat.config != null:
		posture_max = combat.config.posture_max

	# CombatController already emits posture_changed when posture is added. Refreshing
	# once here makes the successful parry's visible result authoritative even while the
	# Hollow is entering local hitstop/recoil.
	if posture_max > 0.0:
		_update_posture_bar(posture_after, posture_max)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hollow_parry_posture", {
			"enemy": CombatTelemetry.snapshot_actor(self),
			"posture_before": posture_before,
			"posture_after": posture_after,
			"posture_delta": posture_after - posture_before,
			"expected_parry_posture": HOLLOW_PARRY_POSTURE_DAMAGE,
			"posture_max": posture_max,
		})
