extends "res://Core/Aspects/AspectRuntime.gd"

## Integration-hardening layer for the Blood Aspect runtime.
## Keeps cross-system timing/collision adaptations out of the primary Aspect rules file.

func _physics_process(_delta: float) -> void:
	call_deferred("_enforce_aspect_enemy_slow")

func begin_wraith_reach(player: Node, direction: Vector2) -> void:
	# Stage 1 only. The primary corridor itself is the player's authored blood-art
	# attack profile; the delayed repetition is scheduled when that corridor finishes.
	if not is_instance_valid(player):
		return
	for enemy in _enemies_in_front(_position(player), direction, 105.0, 0.35):
		_apply_health(enemy, 8, "wraith_reach_sweep")
		_apply_posture(enemy, 22.0, "wraith_reach_sweep")
	_record("wraith_reach_sweep", {"direction": [direction.x, direction.y]})

func schedule_wraith_reach_echo(origin: Vector2, direction: Vector2) -> void:
	var fixed_direction := direction.normalized()
	if fixed_direction.length_squared() <= 0.001:
		fixed_direction = Vector2.RIGHT
	get_tree().create_timer(WRAITH_ECHO_DELAY).timeout.connect(func():
		for enemy in _enemies_in_corridor(origin, fixed_direction, WRAITH_CORRIDOR_LENGTH, WRAITH_CORRIDOR_HALF_WIDTH):
			_apply_health(enemy, 14, "wraith_reach_echo")
			_apply_posture(enemy, 18.0, "wraith_reach_echo")
		_record("wraith_reach_echo", {"origin": [origin.x, origin.y], "direction": [fixed_direction.x, fixed_direction.y]})
		finish_blood_art()
	)

func is_secondary_passage_contact(area: Area2D, target: Node) -> bool:
	if area == null or target == null or selected_aspect != CATALOG.WRAITH or tier < 3:
		return false
	if not bool(area.get_meta("aspect_passage", false)):
		return false
	var token := str(area.get_meta("swing_token", "%d" % area.get_instance_id()))
	if not _passage_actions.has(token):
		return false
	var targets: Array = (_passage_actions[token] as Dictionary).get("targets", [])
	var index := targets.find(target.get_instance_id())
	return index > 0

func _enforce_aspect_enemy_slow() -> void:
	var now := Time.get_ticks_msec() * 0.001
	for enemy in _enemy_nodes():
		if not is_instance_valid(enemy) or not (enemy is CharacterBody2D):
			continue
		var until := float(enemy.get_meta("_aspect_slow_until", 0.0))
		if until <= now:
			if enemy.has_meta("_aspect_slow_until"):
				enemy.remove_meta("_aspect_slow_until")
				enemy.remove_meta("_aspect_slow_mult")
			continue
		var multiplier := clampf(float(enemy.get_meta("_aspect_slow_mult", 1.0)), 0.0, 1.0)
		(enemy as CharacterBody2D).velocity *= multiplier
