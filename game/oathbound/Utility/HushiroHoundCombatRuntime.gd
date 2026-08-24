extends Node

## Hushiro Hound adapter.
##
## The imported BlightedHound still owns a legacy local `posture` meter while every
## other current Hushiro standard enemy uses CombatController. This adapter makes the
## shared meter authoritative without rewriting the Hound's authored movement/attack
## controller in the middle of the Area 3 reconciliation PR.
##
## Responsibilities:
## - tick the Hound's shared CombatController;
## - apply canonical sword AttackEvent posture to that controller;
## - absorb legacy parry posture into the same shared meter;
## - mirror the shared value back to the existing Hound posture UI;
## - expose the shared stagger/deathblow state through the Hound's legacy readiness
##   fields so DeathblowSystem sees the same delayed readiness as every other enemy;
## - record actual Hound -> player hitbox contacts so future playtest logs can measure
##   the pressure that was previously invisible in combat telemetry.

var enemy: Node = null
var combat: Node = null
var posture_runtime: Node = null
var hurtbox: Area2D = null
var attack_hitbox: Area2D = null


func configure(owner_enemy: Node) -> void:
	enemy = owner_enemy
	if enemy != null:
		combat = enemy.get_node_or_null("Combat")
		posture_runtime = enemy.get_node_or_null("HushiroPostureBreakRuntime")
		hurtbox = enemy.get_node_or_null("HurtBox") as Area2D
		attack_hitbox = enemy.get_node_or_null("HitBox") as Area2D


func _ready() -> void:
	process_physics_priority = 90
	if enemy == null:
		enemy = get_parent()
	if combat == null and enemy != null:
		combat = enemy.get_node_or_null("Combat")
	if posture_runtime == null and enemy != null:
		posture_runtime = enemy.get_node_or_null("HushiroPostureBreakRuntime")
	if hurtbox == null and enemy != null:
		hurtbox = enemy.get_node_or_null("HurtBox") as Area2D
	if attack_hitbox == null and enemy != null:
		attack_hitbox = enemy.get_node_or_null("HitBox") as Area2D
	if hurtbox != null and hurtbox.has_signal("hurt"):
		var hurt_callback := Callable(self, "_on_hound_hurt")
		if not hurtbox.is_connected("hurt", hurt_callback):
			hurtbox.connect("hurt", hurt_callback)
	if attack_hitbox != null and attack_hitbox.has_signal("area_entered"):
		var contact_callback := Callable(self, "_on_hound_attack_area_entered")
		if not attack_hitbox.is_connected("area_entered", contact_callback):
			attack_hitbox.connect("area_entered", contact_callback)
	_sync_local_from_shared()
	_update_legacy_posture_visual()


func _physics_process(delta: float) -> void:
	if enemy == null or not is_instance_valid(enemy) or combat == null or not is_instance_valid(combat):
		return
	if _enemy_is_dead():
		_set_property_if_present(enemy, "_dbroken_active", false)
		return

	if combat.has_method("update_health_ratio"):
		var hp: float = float(enemy.get("hp")) if _has_property(enemy, "hp") else 1.0
		var max_hp: float = float(enemy.get("maxhp")) if _has_property(enemy, "maxhp") else maxf(1.0, hp)
		combat.call("update_health_ratio", hp, max_hp)

	if combat.has_method("update_host_state"):
		var state_value: int = int(enemy.get("state")) if _has_property(enemy, "state") else -1
		# Imported Hound states 4-7 are windup/active attack states.
		var attacking: bool = state_value >= 4 and state_value <= 7
		combat.call("update_host_state", attacking, false, false, true)
	if combat.has_method("tick"):
		combat.call("tick", delta)

	_absorb_legacy_parry_posture()
	_sync_local_from_shared()
	_sync_legacy_deathblow_bridge()
	_update_legacy_posture_visual()


func _on_hound_hurt(_damage: int, _damage_type: String, _attacker: Node = null) -> void:
	if enemy == null or combat == null or _enemy_is_dead():
		return
	if not combat.has_method("has_active_attack_event") or not bool(combat.call("has_active_attack_event")):
		return
	if not combat.has_method("get_active_attack_event") or not combat.has_method("add_posture"):
		return

	var event_value: Variant = combat.call("get_active_attack_event")
	if not (event_value is Dictionary):
		return
	var event: Dictionary = event_value as Dictionary
	var authored_posture: float = maxf(0.0, float(event.get("posture_damage", 0.0)))
	if authored_posture <= 0.0:
		return

	# Hound's imported hurt callback owns HP only. Apply the canonical authored Posture
	# exactly once here while HurtBox's attack-event transaction is still active.
	combat.call("add_posture", authored_posture)
	_sync_local_from_shared()
	_update_legacy_posture_visual()

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hound_canonical_posture_applied", {
			"enemy": CombatTelemetry.snapshot_actor(enemy),
			"authored_posture": authored_posture,
			"shared_posture": _shared_posture(),
			"shared_posture_max": _shared_posture_max(),
		})


func _on_hound_attack_area_entered(area: Area2D) -> void:
	if enemy == null or attack_hitbox == null or not is_instance_valid(area):
		return
	if not area.is_in_group("player_hurtbox"):
		return
	# BlightedHound connected its own area_entered handler before this adapter is
	# attached. Therefore `_hitbox_consumed == true` means this overlap was the actual
	# one-per-swing contact that emitted player HurtBox.hurt, not merely a nearby area.
	if _has_property(enemy, "_hitbox_consumed") and not bool(enemy.get("_hitbox_consumed")):
		return
	if CombatTelemetry == null or not CombatTelemetry.is_capturing():
		return

	var player_node: Node = area.get_parent()
	var damage: int = int(attack_hitbox.get_meta("damage", 0))
	var damage_type: String = str(attack_hitbox.get_meta("damage_type", "melee"))
	var state_value: int = int(enemy.get("state")) if _has_property(enemy, "state") else -1
	CombatTelemetry.record_event("hound_attack_contact", {
		"enemy": CombatTelemetry.snapshot_actor(enemy),
		"player": CombatTelemetry.snapshot_actor(player_node) if player_node != null else {},
		"damage": damage,
		"damage_type": damage_type,
		"hound_state": state_value,
		"swing_token": attack_hitbox.get_meta("swing_token", 0),
	})


func _absorb_legacy_parry_posture() -> void:
	if not _has_property(enemy, "posture") or not combat.has_method("add_posture"):
		return
	var local_value: float = maxf(0.0, float(enemy.get("posture")))
	var shared_value: float = _shared_posture()
	if local_value <= shared_value + 0.001:
		return

	var delta: float = local_value - shared_value
	combat.call("add_posture", delta)

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("hound_parry_posture_bridged", {
			"enemy": CombatTelemetry.snapshot_actor(enemy),
			"posture_delta": delta,
			"shared_posture": _shared_posture(),
			"shared_posture_max": _shared_posture_max(),
		})


func _sync_local_from_shared() -> void:
	if enemy == null or combat == null:
		return
	_set_property_if_present(enemy, "posture", _shared_posture())


func _sync_legacy_deathblow_bridge() -> void:
	if posture_runtime == null or not is_instance_valid(posture_runtime):
		posture_runtime = enemy.get_node_or_null("HushiroPostureBreakRuntime")
	if posture_runtime == null:
		return

	var break_active: bool = bool(posture_runtime.call("is_break_active")) if posture_runtime.has_method("is_break_active") else false
	var armed: bool = bool(posture_runtime.call("is_deathblow_armed")) if posture_runtime.has_method("is_deathblow_armed") else false
	var break_ends_at: float = float(posture_runtime.call("get_break_ends_at")) if posture_runtime.has_method("get_break_ends_at") else -1.0

	# BlightedHound.is_deathblow_ready() still reads `_dbroken_active`. Keep that field
	# false during the stagger-only beat and true only once the shared runtime arms.
	_set_property_if_present(enemy, "_dbroken_active", armed)
	if break_ends_at > 0.0:
		_set_property_if_present(enemy, "_dbreak_until", break_ends_at)

	if break_active:
		# Keep the imported AI in its existing stun branch so its animation/attack state
		# cannot overwrite the shared posture-break presentation on the next frame.
		_set_property_if_present(enemy, "stunned_until", maxf(float(enemy.get("stunned_until")), break_ends_at))
		if enemy is CharacterBody2D:
			(enemy as CharacterBody2D).velocity = Vector2.ZERO


func _update_legacy_posture_visual() -> void:
	if enemy == null:
		return
	var current: float = _shared_posture()
	var maximum: float = _shared_posture_max()
	var pct: float = clampf(current / maximum, 0.0, 1.0) if maximum > 0.0 else 0.0

	var fill_value: Variant = enemy.get("_posture_fill") if _has_property(enemy, "_posture_fill") else null
	if fill_value is ColorRect:
		var fill := fill_value as ColorRect
		fill.size.x = 40.0 * pct
		fill.color = Color(0.95, 0.6 - (0.5 * pct), 0.1, 0.95)

	var ui_value: Variant = enemy.get("_posture_ui") if _has_property(enemy, "_posture_ui") else null
	if ui_value is CanvasItem:
		var break_active: bool = false
		if posture_runtime != null and is_instance_valid(posture_runtime) and posture_runtime.has_method("is_break_active"):
			break_active = bool(posture_runtime.call("is_break_active"))
		(ui_value as CanvasItem).visible = current > 0.001 or break_active


func _shared_posture() -> float:
	if combat != null and combat.has_method("get_posture"):
		return float(combat.call("get_posture"))
	return 0.0


func _shared_posture_max() -> float:
	if combat == null:
		return 0.0
	var cfg: CombatConfig = combat.get("config") as CombatConfig
	return float(cfg.posture_max) if cfg != null else 0.0


func _enemy_is_dead() -> bool:
	if enemy == null or not is_instance_valid(enemy) or enemy.is_queued_for_deletion():
		return true
	if _has_property(enemy, "has_died") and bool(enemy.get("has_died")):
		return true
	if _has_property(enemy, "hp") and float(enemy.get("hp")) <= 0.0:
		return true
	return false


func _set_property_if_present(object: Object, property_name: String, value: Variant) -> void:
	if _has_property(object, property_name):
		object.set(property_name, value)


func _has_property(object: Object, property_name: String) -> bool:
	for property_data: Dictionary in object.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			return true
	return false
