extends "res://Core/Techniques/TechniqueEffects.gd"

## Runtime-hardening layer for the first-playtest Technique executor.
## Keeps timing-sensitive integration fixes separate from the family-rule implementation.


func on_player_hit(target: Node, player: Node, attack_area: Area2D = null) -> void:
	# Unseen ends as soon as Akio commits an attack. OathboundPlayerStability preserves
	# one pending Unseen strike token so the attack that broke stealth can still receive
	# its documented backstab payoff if it genuinely lands from behind.
	if is_instance_valid(player) and bool(player.get_meta("_tech_unseen_attack_bonus_pending", false)):
		var base_damage := 0
		if attack_area != null:
			base_damage = int(attack_area.get_meta("health_damage", attack_area.get_meta("damage", 0)))
		if base_damage > 0 and _is_genuine_backstab(target, player):
			_apply_health_damage(target, maxi(1, int(round(float(base_damage) * UNSEEN_BACKSTAB_BONUS))), "unseen_backstab")
		player.set_meta("_tech_unseen_attack_bonus_pending", false)

	super.on_player_hit(target, player, attack_area)


func _player_in_deathblow_state(player: Node) -> bool:
	if is_instance_valid(player):
		var until := float(player.get_meta("_technique_deathblow_until", 0.0))
		if until > _now():
			return true
	return super._player_in_deathblow_state(player)


func _tick_player_status(now: float) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null or not is_instance_valid(player):
		return
	# The base helper tests active-and-not-expired, which cannot itself detect the
	# transition to expired. Inspect the active flag directly here.
	if bool(player.get_meta("_tech_unseen_active", false)) and now >= float(player.get_meta("_tech_unseen_until", 0.0)):
		_clear_unseen(player)


func _match_echo_hit(target: Node, player: Node, attack_area: Area2D, trigger: String, base_damage: int, acquired: Array) -> void:
	super._match_echo_hit(target, player, attack_area, trigger, base_damage, acquired)
	# Lingering Cut's refinement widens that specific Echo enough to clip one nearby
	# enemy. It must not widen unrelated Echo sources.
	if trigger != "basic" or "echo_lingering_cut" not in acquired or "refine_echo_lingering_cut" not in acquired:
		return
	if not is_instance_valid(target) or base_damage <= 0:
		return
	var target_ref := weakref(target)
	var clip_damage := maxi(1, int(round(float(base_damage) * ECHO_BASIC_MULT * 0.45)))
	get_tree().create_timer(ECHO_DELAY).timeout.connect(func():
		var resolved: Node = target_ref.get_ref() if target_ref != null else null
		if resolved == null or not is_instance_valid(resolved):
			return
		var nearby := _nearest_enemy(_node_position(resolved), resolved, 52.0)
		if nearby != null:
			_apply_health_damage(nearby, clip_damage, "lingering_cut_refinement")
			_pulse(nearby, Color(0.85, 0.92, 1.0, 1.0), "ECHO")
	)


func _match_rupture_hit(target: Node, player: Node, trigger: String, proc_coefficient: float, acquired: Array) -> void:
	super._match_rupture_hit(target, player, trigger, proc_coefficient, acquired)
	# Breaching Step is explicitly a short forward posture-impact shockwave, not only
	# primary-target buildup. Keep the secondary pressure modest and bounded.
	if trigger == "dash" and "rupture_breaching_step" in acquired and is_instance_valid(target):
		_damage_posture_nearby(_node_position(target), target, RUPTURE_RADIUS * 0.60, 5.0, "breaching_step_wave", 2)
