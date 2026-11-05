extends Node

## Hades-inspired authored melee surround for Area 1 Swordsmen.
## ORIGINAL GODOT IMPLEMENTATION, not a Lua source-code port.
## Controls desired positioning only; PressureDirectorV2 controls impact timing.
## Each enemy keeps its own motion motor, hitboxes, guards and action lifecycle.

const GROUP_NAME: StringName = &"hushiro_melee_surround"
const ENGAGE_DISTANCE: float = 44.0
const SUPPORT_DISTANCE: float = 94.0
const MIN_SUPPORT_ANGLE: float = 1.20
const ENGAGER_MIN_LEASE: float = 0.80

var _active_id: int = 0
var _engager_lease_until: float = 0.0
var _anchors: Dictionary = {}
var _last_plan_roles: Dictionary = {}


func _ready() -> void:
	add_to_group(GROUP_NAME)


func _exit_tree() -> void:
	_active_id = 0
	_anchors.clear()
	_last_plan_roles.clear()


func plan_for(actor: Node2D, player: Node2D) -> Dictionary:
	if not is_instance_valid(actor) or not is_instance_valid(player):
		return {}
	var roster: Array[Node2D] = _roster()
	if not roster.has(actor):
		return {}
	var now: float = Time.get_ticks_msec() * 0.001
	_cleanup_anchors(roster)
	_ensure_active(roster, player, now)

	# Hades II-style close-pressure retaliation: if Akio moves directly onto a
	# waiting Swordsman while the active attacker is far away, that nearby unit
	# becomes the attacker after the minimum lease. This avoids passive fleeing.
	var actor_range: float = actor.global_position.distance_to(player.global_position)
	if actor.get_instance_id() != _active_id and actor_range < 36.0 and now >= _engager_lease_until:
		var current_lead: Node2D = null
		for current: Node2D in roster:
			if current.get_instance_id() == _active_id:
				current_lead = current
				break
		if current_lead == null or current_lead.global_position.distance_to(player.global_position) > 68.0:
			_active_id = actor.get_instance_id()
			_engager_lease_until = now + ENGAGER_MIN_LEASE

	var id: int = actor.get_instance_id()
	if not _anchors.has(id):
		var initial_dir: Vector2 = actor.global_position - player.global_position
		_anchors[id] = initial_dir.angle() if initial_dir.length_squared() > 1.0 else 0.0
	var angle: float = float(_anchors[id])
	var role: String = "engage" if id == _active_id else "support"
	if role == "support":
		# Avoid two Swordsmen pursuing the same small patch next to Akio.
		var lead_angle: float = float(_anchors.get(_active_id, angle))
		var delta_angle: float = wrapf(angle - lead_angle, -PI, PI)
		if absf(delta_angle) < MIN_SUPPORT_ANGLE:
			angle = lead_angle + (MIN_SUPPORT_ANGLE if id > _active_id else -MIN_SUPPORT_ANGLE)

	var distance: float = ENGAGE_DISTANCE if role == "engage" else SUPPORT_DISTANCE
	var destination: Vector2 = _inside_room(player.global_position + Vector2.RIGHT.rotated(angle) * distance)
	if _last_plan_roles.get(id, "") != role:
		_last_plan_roles[id] = role
		_record("hushiro_surround_role", actor, role, destination)
	return {"role": role, "position": destination, "active_id": _active_id}


func attack_completed(actor: Node2D) -> void:
	if not is_instance_valid(actor) or actor.get_instance_id() != _active_id:
		return
	var now: float = Time.get_ticks_msec() * 0.001
	if now < _engager_lease_until:
		return
	var roster: Array[Node2D] = _roster()
	if roster.size() < 2:
		return
	# Stable rotation AFTER a completed attack, not every 0.18s decision.
	roster.sort_custom(func(a: Node2D, b: Node2D) -> bool:
		return a.get_instance_id() < b.get_instance_id()
	)
	var index: int = roster.find(actor)
	if index < 0:
		return
	var next_actor: Node2D = roster[(index + 1) % roster.size()]
	if next_actor == actor:
		return
	_active_id = next_actor.get_instance_id()
	_engager_lease_until = now + ENGAGER_MIN_LEASE


func role_for_test(actor: Node2D, player: Node2D) -> String:
	return str(plan_for(actor, player).get("role", ""))


func _roster() -> Array[Node2D]:
	var roster: Array[Node2D] = []
	var room: Node = get_parent()
	for item: Node in get_tree().get_nodes_in_group("enemy"):
		if not (item is Node2D) or not is_instance_valid(item):
			continue
		if room != null and not room.is_ancestor_of(item):
			continue
		if not item.has_method("uses_hades_melee_policy") or not bool(item.call("uses_hades_melee_policy")):
			continue
		if item.has_method("is_dead") and bool(item.call("is_dead")):
			continue
		roster.append(item as Node2D)
	return roster


func _ensure_active(roster: Array[Node2D], player: Node2D, now: float) -> void:
	for actor: Node2D in roster:
		if actor.get_instance_id() == _active_id:
			return
	_active_id = 0
	if roster.is_empty():
		return
	# Select the first active melee threat by distance; then retain that actor
	# until an attack finishes or the actor leaves/dies.
	var best: Node2D = roster[0]
	for actor: Node2D in roster:
		if actor.global_position.distance_squared_to(player.global_position) < best.global_position.distance_squared_to(player.global_position):
			best = actor
	_active_id = best.get_instance_id()
	_engager_lease_until = now + ENGAGER_MIN_LEASE


func _cleanup_anchors(roster: Array[Node2D]) -> void:
	var ids: Dictionary = {}
	for actor: Node2D in roster:
		ids[actor.get_instance_id()] = true
	for id: Variant in _anchors.keys():
		if not ids.has(id):
			_anchors.erase(id)
			_last_plan_roles.erase(id)


func _inside_room(point: Vector2) -> Vector2:
	var bounds: Node = get_parent().get_node_or_null("RoomBounds") if get_parent() != null else null
	if bounds == null or not bounds.has_method("get_rect_global"):
		return point
	var rect: Rect2 = bounds.call("get_rect_global")
	if rect.size.x < 100.0 or rect.size.y < 100.0:
		return point
	var margin: float = 34.0
	return Vector2(
		clampf(point.x, rect.position.x + margin, rect.end.x - margin),
		clampf(point.y, rect.position.y + margin, rect.end.y - margin)
	)


func _record(event_name: String, actor: Node2D, role: String, destination: Vector2) -> void:
	if CombatTelemetry == null or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event(event_name, {
		"enemy": CombatTelemetry.snapshot_actor(actor),
		"role": role,
		"destination": destination,
		"active_id": _active_id,
	})
