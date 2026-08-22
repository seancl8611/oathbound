extends "res://Core/Aspects/AspectRuntime.gd"

## Integration-hardening layer for the Blood Aspect runtime.
## Keeps cross-system timing/collision adaptations out of the primary Aspect rules file.

func _physics_process(_delta: float) -> void:
	call_deferred("_enforce_aspect_enemy_slow")

func record_sword_contact(target: Node, area: Area2D, attacker: Node, before_hp: float, before_posture: float) -> void:
	if not _is_current_player_sword(area, attacker) or not is_instance_valid(target):
		return
	var trigger := str(area.get_meta("action_trigger", ""))
	var attack_id := str(area.get_meta("attack_id", ""))

	# Apply Spectral Edge first, then re-read the actor. Blood must use actual applied
	# values after clamping so overkill/overbreak never inflate the meter.
	_apply_wraith_spectral_edge(target, area, attacker, attack_id)
	var after_hp := _read_hp(target)
	var after_posture := _read_posture(target)
	var actual_health := maxf(0.0, before_hp - after_hp)
	var actual_posture := maxf(0.0, after_posture - before_posture)

	if bool(area.get_meta("blood_generation", true)):
		_record_damage_blood(area, target, actual_health, actual_posture, is_secondary_passage_contact(area, target))

	var token := str(area.get_meta("swing_token", "%d" % area.get_instance_id()))
	if trigger == "counter" and not _counter_bonus_tokens.has(token):
		_counter_bonus_tokens[token] = Time.get_ticks_msec() * 0.001
		add_blood(2.0, "parry_counter")

	var posture_max := _read_posture_max(target)
	if before_posture < posture_max - 0.001 and after_posture >= posture_max - 0.001:
		add_blood(4.0, "enemy_posture_break")

	_apply_post_contact_tier_effects(target, area, attacker, attack_id)

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
