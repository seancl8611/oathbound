extends "res://Utility/hurt_box.gd"

## Aspect-aware contact adapter. The parent remains the collision/event authority; this
## layer transforms direct Wraith passage contacts before damage resolution and reports
## actual applied Health/Posture deltas to AspectRuntime after the event transaction.
## It also records authored-vs-applied posture for every canonical contact so recovery
## between contacts is not mistaken for inconsistent per-hit scaling.

var _aspect_before_hp: float = 0.0
var _aspect_before_posture: float = 0.0
var _aspect_pending_contact: bool = false

func _cache_attack_event(area: Area2D, resolved_attacker: Node) -> void:
	if area == null:
		return
	var event: Dictionary = {
		"health_damage": int(area.get_meta("health_damage", area.get_meta("damage", 0))),
		"posture_damage": float(area.get_meta("posture_damage", 0.0)),
		"block_posture_damage": float(area.get_meta("block_posture_damage", area.get_meta("posture_damage", 0.0))),
		"stagger_level": int(area.get_meta("stagger_level", 0)),
		"proc_coefficient": float(area.get_meta("proc_coefficient", 1.0)),
	}
	var receiver: Node = get_parent()
	if typeof(AspectRuntime) == TYPE_OBJECT:
		event = AspectRuntime.transform_sword_contact(area, receiver, resolved_attacker, event)

	set_meta("last_attack_area", area)
	set_meta("last_attack_source", resolved_attacker)
	set_meta("last_health_damage", int(event.get("health_damage", 0)))
	set_meta("last_posture_damage", float(event.get("posture_damage", 0.0)))
	set_meta("last_block_posture_damage", float(event.get("block_posture_damage", 0.0)))
	set_meta("last_stagger_level", int(event.get("stagger_level", 0)))
	set_meta("last_proc_coefficient", float(event.get("proc_coefficient", 1.0)))
	set_meta("last_damage", int(event.get("health_damage", 0)))
	set_meta("last_damage_type", str(area.get_meta("damage_type", "normal")))
	set_meta("last_attack_id", str(area.get_meta("attack_id", "")))
	set_meta("last_hitbox_shape", str(area.get_meta("hitbox_shape", "")))
	set_meta("last_combo_index", int(area.get_meta("combo_index", 0)))
	set_meta("last_knockback_force", float(area.get_meta("knockback_force", 0.0)))
	set_meta("last_hitstop", float(area.get_meta("hitstop", 0.0)))

	_aspect_before_hp = _read_actor_hp(receiver)
	_aspect_before_posture = _read_actor_posture(receiver)
	_aspect_pending_contact = true

func _read_health_damage(area: Area2D) -> int:
	if get_meta("last_attack_area", null) == area:
		return int(get_meta("last_health_damage", 0))
	return super._read_health_damage(area)

func _end_attack_event_transaction(combat_node: Node) -> void:
	super._end_attack_event_transaction(combat_node)
	if not _aspect_pending_contact:
		return
	_aspect_pending_contact = false
	var area_value: Variant = get_meta("last_attack_area", null)
	var attacker_value: Variant = get_meta("last_attack_source", null)
	var receiver: Node = get_parent()
	if area_value is Area2D and is_instance_valid(area_value):
		var area: Area2D = area_value as Area2D
		_record_posture_resolution(receiver, area)
		if typeof(AspectRuntime) == TYPE_OBJECT:
			AspectRuntime.record_sword_contact(receiver, area, attacker_value as Node, _aspect_before_hp, _aspect_before_posture)

func _record_posture_resolution(receiver: Node, area: Area2D) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var after_posture: float = _read_actor_posture(receiver)
	var actual_delta: float = maxf(0.0, after_posture - _aspect_before_posture)
	var authored: float = float(get_meta("last_posture_damage", area.get_meta("posture_damage", 0.0)))
	var maximum: float = _read_actor_posture_max(receiver)
	CombatTelemetry.record_event("canonical_posture_resolution", {
		"receiver": CombatTelemetry.snapshot_actor(receiver),
		"attack_id": str(area.get_meta("attack_id", "")),
		"action_trigger": str(area.get_meta("action_trigger", "")),
		"posture_before": _aspect_before_posture,
		"authored_posture": authored,
		"actual_posture_delta": actual_delta,
		"posture_after": after_posture,
		"posture_max": maximum,
		"entered_break": maximum > 0.0 and _aspect_before_posture < maximum - 0.001 and after_posture >= maximum - 0.001,
	})

func _read_actor_hp(actor: Node) -> float:
	if actor == null:
		return 0.0
	var value: Variant = actor.get("hp")
	return float(value) if value != null else 0.0

func _read_actor_posture(actor: Node) -> float:
	if actor == null:
		return 0.0
	var combat_node: Node = actor.get_node_or_null("Combat")
	if combat_node != null:
		if combat_node.has_method("get_posture"):
			return float(combat_node.call("get_posture"))
		var internal_value: Variant = combat_node.get("_posture")
		if internal_value != null:
			return float(internal_value)
	var value: Variant = actor.get("stagger")
	return float(value) if value != null else 0.0

func _read_actor_posture_max(actor: Node) -> float:
	if actor == null:
		return 0.0
	var combat_node: Node = actor.get_node_or_null("Combat")
	if combat_node != null:
		var cfg: CombatConfig = combat_node.get("config") as CombatConfig
		if cfg != null:
			return float(cfg.posture_max)
	var value: Variant = actor.get("stagger_max")
	return float(value) if value != null else 0.0
