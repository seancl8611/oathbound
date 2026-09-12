extends "res://Player/OathboundPlayerMotion.gd"

## Combat V2 player target-handoff adapter.
##
## This layer is intentionally a bounded soft-assist, not a lock-on system. Basic sword
## attacks may bias toward a nearby enemy that already lies inside the player's current
## aim cone. The player remains authoritative: moving the aim outside the release cone
## drops the target immediately, and no target changes attack timing, hitboxes, damage,
## movement permissions, or collision ownership.
##
## The main purpose is hack-and-slash continuity. If a fodder enemy dies on hit 3/4/5,
## the next queued basic swing can inherit the unfinished string while facing another
## nearby enemy instead of spending that swing into empty space.

const V2_HANDOFF_RANGE: float = 132.0
const V2_HANDOFF_HALF_ANGLE_DEG: float = 58.0
const V2_HANDOFF_RELEASE_ANGLE_DEG: float = 76.0
const V2_HANDOFF_MOUSE_DEADZONE: float = 18.0
const V2_HANDOFF_ALIGNMENT_WEIGHT: float = 2.25
const V2_HANDOFF_DISTANCE_WEIGHT: float = 0.65

var _v2_attack_soft_target: Node2D = null


func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	super._start_profile_attack(profile, combo_idx)
	if _state != State.ATTACKING or _attack_profile.is_empty():
		_v2_clear_attack_soft_target("attack_not_started")
		return
	if not _v2_profile_allows_handoff(_attack_profile):
		_v2_clear_attack_soft_target("profile_opt_out")
		return

	var intent: Vector2 = _v2_attack_intent_direction()
	var target: Node2D = _v2_acquire_attack_soft_target(intent)
	_v2_set_attack_soft_target(target, intent, "swing_start")
	if target != null:
		_v2_face_soft_target(target)


func _v2_update_attack_steering(delta: float) -> void:
	if not _v2_profile_allows_handoff(_attack_profile):
		_v2_clear_attack_soft_target("profile_opt_out")
		super._v2_update_attack_steering(delta)
		return

	var intent: Vector2 = _v2_attack_intent_direction()
	if intent.length_squared() <= 0.01:
		super._v2_update_attack_steering(delta)
		return

	if not _v2_soft_target_viable(_v2_attack_soft_target):
		_v2_set_attack_soft_target(_v2_acquire_attack_soft_target(intent), intent, "target_invalid")
	elif _v2_attack_soft_target != null:
		var to_target: Vector2 = _v2_attack_soft_target.global_position - global_position
		if to_target.length_squared() <= 0.01:
			_v2_clear_attack_soft_target("target_overlap")
		else:
			var target_dir: Vector2 = to_target.normalized()
			var release_dot: float = cos(deg_to_rad(V2_HANDOFF_RELEASE_ANGLE_DEG))
			if intent.dot(target_dir) < release_dot:
				_v2_clear_attack_soft_target("player_aim_override")
				_v2_set_attack_soft_target(_v2_acquire_attack_soft_target(intent), intent, "player_redirect")

	if _v2_soft_target_viable(_v2_attack_soft_target):
		var assisted_dir: Vector2 = (_v2_attack_soft_target.global_position - global_position).normalized()
		_v2_turn_attack_toward(assisted_dir, delta)
		return

	super._v2_update_attack_steering(delta)


func _v2_profile_allows_handoff(profile: Dictionary) -> bool:
	if profile.is_empty():
		return false
	if not bool(profile.get("v2_target_handoff", true)):
		return false
	return str(profile.get("action_trigger", "basic")) == "basic"


func _v2_attack_intent_direction() -> Vector2:
	var mouse_delta: Vector2 = get_global_mouse_position() - global_position
	if mouse_delta.length() >= V2_HANDOFF_MOUSE_DEADZONE:
		return mouse_delta.normalized()
	if _move_input.length() > 0.1:
		return _move_input.normalized()
	var facing: Vector2 = _facing_dir.normalized()
	if facing.length_squared() > 0.01:
		return facing
	return Vector2.RIGHT


func _v2_acquire_attack_soft_target(intent: Vector2) -> Node2D:
	if not is_inside_tree():
		return null
	var resolved_intent: Vector2 = intent.normalized()
	if resolved_intent.length_squared() <= 0.01:
		return null

	var min_dot: float = cos(deg_to_rad(V2_HANDOFF_HALF_ANGLE_DEG))
	var best_target: Node2D = null
	var best_score: float = -INF

	for candidate_value: Variant in get_tree().get_nodes_in_group("enemy"):
		if not (candidate_value is Node2D):
			continue
		var candidate: Node2D = candidate_value as Node2D
		if not _v2_soft_target_viable(candidate):
			continue
		var offset: Vector2 = candidate.global_position - global_position
		var distance: float = offset.length()
		if distance <= 0.01 or distance > V2_HANDOFF_RANGE:
			continue
		var candidate_dir: Vector2 = offset / distance
		var alignment: float = resolved_intent.dot(candidate_dir)
		if alignment < min_dot:
			continue
		var distance_score: float = 1.0 - clampf(distance / V2_HANDOFF_RANGE, 0.0, 1.0)
		var score: float = alignment * V2_HANDOFF_ALIGNMENT_WEIGHT + distance_score * V2_HANDOFF_DISTANCE_WEIGHT
		if score > best_score:
			best_score = score
			best_target = candidate

	return best_target


func _v2_soft_target_viable(target: Node2D) -> bool:
	if target == null or not is_instance_valid(target) or target.is_queued_for_deletion():
		return false
	if not target.is_inside_tree():
		return false
	if not target.is_in_group("enemy"):
		return false
	if target is CanvasItem and not (target as CanvasItem).is_visible_in_tree():
		return false
	if target.has_method("is_dead") and bool(target.call("is_dead")):
		return false
	if "hp" in target:
		var hp_value: Variant = target.get("hp")
		if typeof(hp_value) in [TYPE_INT, TYPE_FLOAT] and float(hp_value) <= 0.0:
			return false
	return true


func _v2_turn_attack_toward(target_dir: Vector2, delta: float) -> void:
	if target_dir.length_squared() <= 0.01:
		return
	var current_dir: Vector2 = _attack_aim_dir.normalized()
	if current_dir.length_squared() <= 0.01:
		current_dir = target_dir
	var turn_rate_deg: float = float(_attack_profile.get("v2_startup_turn_rate_deg", DEFAULT_STARTUP_TURN_RATE_DEG))
	var max_step: float = deg_to_rad(maxf(0.0, turn_rate_deg)) * maxf(0.0, delta)
	var angle_delta: float = wrapf(target_dir.angle() - current_dir.angle(), -PI, PI)
	var next_angle: float = current_dir.angle() + clampf(angle_delta, -max_step, max_step)
	_attack_aim_dir = Vector2(cos(next_angle), sin(next_angle)).normalized()
	_update_sprite_facing(_attack_aim_dir)
	_position_sword_hitbox_for_attack()


func _v2_face_soft_target(target: Node2D) -> void:
	if not _v2_soft_target_viable(target):
		return
	var direction: Vector2 = target.global_position - global_position
	if direction.length_squared() <= 0.01:
		return
	_attack_aim_dir = direction.normalized()
	_update_sprite_facing(_attack_aim_dir)
	_position_sword_hitbox_for_attack()


func _v2_set_attack_soft_target(target: Node2D, intent: Vector2, reason: String) -> void:
	if target == _v2_attack_soft_target:
		return
	var previous: Node2D = _v2_attack_soft_target
	_v2_attack_soft_target = target
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = {
		"reason": reason,
		"intent": [intent.x, intent.y],
		"previous": CombatTelemetry.snapshot_actor(previous) if previous != null and is_instance_valid(previous) else {},
		"target": CombatTelemetry.snapshot_actor(target) if target != null and is_instance_valid(target) else {},
	}
	if target != null and is_instance_valid(target):
		payload["distance"] = global_position.distance_to(target.global_position)
	CombatTelemetry.record_event("player_attack_target_handoff", payload)


func _v2_clear_attack_soft_target(reason: String) -> void:
	if _v2_attack_soft_target == null:
		return
	_v2_set_attack_soft_target(null, _v2_attack_intent_direction(), reason)


func get_v2_attack_soft_target() -> Node2D:
	if not _v2_soft_target_viable(_v2_attack_soft_target):
		return null
	return _v2_attack_soft_target


func get_playtest_snapshot() -> Dictionary:
	var snapshot: Dictionary = super.get_playtest_snapshot()
	var target: Node2D = get_v2_attack_soft_target()
	snapshot["v2_target_handoff"] = true
	snapshot["v2_soft_target"] = target.name if target != null else ""
	return snapshot
