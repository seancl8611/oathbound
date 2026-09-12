extends Node2D

## Flight-local defensive readability for the Hushiro Corrupted Archer's arrow.
##
## The Archer's PressureDirectorV2 reservation predicts room-level impact timing before
## the shot is fired, but the projectile itself owns the actual trajectory after launch.
## This runtime therefore uses current relative motion to decide whether the arrow is
## still on a collision course with Akio. Only a genuinely threatening arrow receives
## the final warning/parry beat; a dodged arrow stops advertising a false counter prompt.

const WARNING_LEAD_SECONDS: float = 0.20
const PARRY_BEAT_LEAD_SECONDS: float = 0.12
const COLLISION_MARGIN: float = 3.0
const DEFAULT_PLAYER_RADIUS: float = 18.0
const DEFAULT_PROJECTILE_RADIUS: float = 6.0
const WARNING_COLOR: Color = Color(1.0, 0.88, 0.40, 0.96)
const PARRY_COLOR: Color = Color(1.0, 1.0, 1.0, 1.0)

var _projectile: Area2D = null
var _ring: Line2D = null
var _parry_mark: Polygon2D = null
var _warning_visible_last: bool = false
var _parry_visible_last: bool = false


func _ready() -> void:
	_projectile = get_parent() as Area2D
	_build_visuals()
	visible = false
	set_process(true)


func _process(_delta: float) -> void:
	_update_counter_cue()


func _update_counter_cue() -> void:
	if _projectile == null or not is_instance_valid(_projectile):
		_hide_cue()
		return
	if bool(_projectile.get_meta("deflected", false)) or _parent_flag("_is_deflected") or _parent_flag("_is_blocked") or _parent_flag("_hit_something"):
		_hide_cue()
		return
	if not _parent_flag("_armed"):
		_hide_cue()
		return

	var player_value: Node = get_tree().get_first_node_in_group("player")
	if not (player_value is Node2D):
		_hide_cue()
		return
	var player: Node2D = player_value as Node2D

	var projectile_velocity_value: Variant = _projectile.get("velocity")
	if not (projectile_velocity_value is Vector2):
		_hide_cue()
		return
	var projectile_velocity: Vector2 = projectile_velocity_value as Vector2
	if projectile_velocity.length_squared() <= 0.001:
		_hide_cue()
		return

	var player_velocity: Vector2 = Vector2.ZERO
	if player is CharacterBody2D:
		player_velocity = (player as CharacterBody2D).velocity
	else:
		var player_velocity_value: Variant = player.get("velocity")
		if player_velocity_value is Vector2:
			player_velocity = player_velocity_value as Vector2

	var relative_position: Vector2 = player.global_position - _projectile.global_position
	var relative_velocity: Vector2 = player_velocity - projectile_velocity
	var collision_radius: float = _player_collision_radius(player) + _projectile_collision_radius() + COLLISION_MARGIN
	var prediction: Dictionary = predict_collision_course(relative_position, relative_velocity, collision_radius)
	var eta: float = float(prediction.get("eta", INF))
	var threatening: bool = bool(prediction.get("threatening", false))
	var state: Dictionary = counter_state_for_eta(eta, threatening)
	var warning: bool = bool(state.get("warning", false))
	var parry_beat: bool = bool(state.get("parry_beat", false))

	# Keep the cue screen-oriented even though the projectile root rotates with flight.
	global_rotation = 0.0
	visible = warning
	if _parry_mark != null:
		_parry_mark.visible = parry_beat

	if warning and not _warning_visible_last:
		_record_warning_telemetry(eta, float(prediction.get("closest_distance", INF)), collision_radius)
	if parry_beat and not _parry_visible_last:
		_record_parry_beat_telemetry(eta)
	_warning_visible_last = warning
	_parry_visible_last = parry_beat


func predict_collision_course(relative_position: Vector2, relative_velocity: Vector2, collision_radius: float) -> Dictionary:
	var speed_sq: float = relative_velocity.length_squared()
	if speed_sq <= 0.001:
		return {"eta": INF, "closest_distance": relative_position.length(), "threatening": false}
	var eta: float = -relative_position.dot(relative_velocity) / speed_sq
	if eta <= 0.0:
		return {"eta": eta, "closest_distance": relative_position.length(), "threatening": false}
	var closest_offset: Vector2 = relative_position + relative_velocity * eta
	var closest_distance: float = closest_offset.length()
	return {
		"eta": eta,
		"closest_distance": closest_distance,
		"threatening": closest_distance <= maxf(0.0, collision_radius),
	}


func counter_state_for_eta(eta: float, threatening: bool) -> Dictionary:
	var warning: bool = threatening and eta > 0.0 and eta <= WARNING_LEAD_SECONDS
	return {
		"warning": warning,
		"parry_beat": warning and eta <= PARRY_BEAT_LEAD_SECONDS,
	}


func force_update_for_test() -> void:
	_update_counter_cue()


func warning_visible_for_test() -> bool:
	return visible


func parry_beat_visible_for_test() -> bool:
	return _parry_mark != null and _parry_mark.visible


func scheduled_pressure_impact_at_for_test() -> float:
	return _scheduled_pressure_impact_at()


func _player_collision_radius(player: Node2D) -> float:
	var shape_node: CollisionShape2D = player.get_node_or_null("HurtBox/CollisionShape2D") as CollisionShape2D
	return _collision_shape_radius(shape_node, DEFAULT_PLAYER_RADIUS)


func _projectile_collision_radius() -> float:
	if _projectile == null:
		return DEFAULT_PROJECTILE_RADIUS
	var shape_node: CollisionShape2D = _projectile.get_node_or_null("CollisionShape2D") as CollisionShape2D
	return _collision_shape_radius(shape_node, DEFAULT_PROJECTILE_RADIUS)


func _collision_shape_radius(shape_node: CollisionShape2D, fallback: float) -> float:
	if shape_node == null or shape_node.shape == null:
		return fallback
	var sx: float = absf(shape_node.global_scale.x)
	var sy: float = absf(shape_node.global_scale.y)
	var shape_value: Shape2D = shape_node.shape
	if shape_value is RectangleShape2D:
		var rectangle: RectangleShape2D = shape_value as RectangleShape2D
		return maxf(rectangle.size.x * sx, rectangle.size.y * sy) * 0.5
	if shape_value is CircleShape2D:
		var circle: CircleShape2D = shape_value as CircleShape2D
		return circle.radius * maxf(sx, sy)
	if shape_value is CapsuleShape2D:
		var capsule: CapsuleShape2D = shape_value as CapsuleShape2D
		return maxf(capsule.radius * 2.0 * sx, capsule.height * sy) * 0.5
	return fallback * maxf(sx, sy)


func _parent_flag(property_name: String) -> bool:
	if _projectile == null:
		return false
	var value: Variant = _projectile.get(property_name)
	return value != null and bool(value)


func _build_visuals() -> void:
	z_index = 12
	_ring = Line2D.new()
	_ring.width = 2.0
	_ring.default_color = WARNING_COLOR
	var points := PackedVector2Array()
	for i in range(17):
		var angle: float = TAU * float(i) / 16.0
		points.append(Vector2(cos(angle), sin(angle)) * 10.0)
	_ring.points = points
	add_child(_ring)

	_parry_mark = Polygon2D.new()
	_parry_mark.polygon = PackedVector2Array([
		Vector2(0.0, -3.5),
		Vector2(2.2, 0.0),
		Vector2(0.0, 3.5),
		Vector2(-2.2, 0.0),
	])
	_parry_mark.color = PARRY_COLOR
	_parry_mark.visible = false
	_parry_mark.z_index = 1
	add_child(_parry_mark)


func _hide_cue() -> void:
	visible = false
	if _parry_mark != null:
		_parry_mark.visible = false
	_warning_visible_last = false
	_parry_visible_last = false


func _scheduled_pressure_impact_at() -> float:
	if _projectile == null:
		return -1.0
	var shooter_id: int = int(_projectile.get_meta("shooter_id", 0))
	if shooter_id <= 0:
		return -1.0
	var director: Node = get_node_or_null("/root/AttackDir")
	if director == null or not director.has_method("snapshot_pressure_reservations"):
		return -1.0
	var reservations_value: Variant = director.call("snapshot_pressure_reservations")
	if not (reservations_value is Array):
		return -1.0
	for reservation_value: Variant in reservations_value as Array:
		if not (reservation_value is Dictionary):
			continue
		var reservation: Dictionary = reservation_value as Dictionary
		if int(reservation.get("enemy_id", -1)) == shooter_id:
			return float(reservation.get("impact_at", -1.0))
	return -1.0


func _record_warning_telemetry(eta: float, closest_distance: float, collision_radius: float) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var now: float = Time.get_ticks_msec() * 0.001
	var scheduled_impact_at: float = _scheduled_pressure_impact_at()
	var payload: Dictionary = {
		"projectile_id": _projectile.get_instance_id() if _projectile != null else -1,
		"shooter_id": int(_projectile.get_meta("shooter_id", 0)) if _projectile != null else 0,
		"eta": eta,
		"dynamic_impact_at": now + eta,
		"closest_distance": closest_distance,
		"collision_radius": collision_radius,
		"warning_lead": WARNING_LEAD_SECONDS,
		"parry_beat_lead": PARRY_BEAT_LEAD_SECONDS,
		"scheduled_impact_at": scheduled_impact_at,
	}
	if scheduled_impact_at > 0.0:
		payload["scheduler_delta"] = (now + eta) - scheduled_impact_at
	CombatTelemetry.record_event("archer_projectile_counter_cue_armed", payload)


func _record_parry_beat_telemetry(eta: float) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event("archer_projectile_parry_beat", {
		"projectile_id": _projectile.get_instance_id() if _projectile != null else -1,
		"shooter_id": int(_projectile.get_meta("shooter_id", 0)) if _projectile != null else 0,
		"eta": eta,
	})
