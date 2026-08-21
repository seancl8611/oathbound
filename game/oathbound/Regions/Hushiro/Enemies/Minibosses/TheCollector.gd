extends "res://Regions/Hushiro/Enemies/Minibosses/TheCollectorController.gd"

## Canonical Hushiro rules layer for The Collector.
## The imported controller supplies the attack implementations; this layer enforces
## the approved first-playtest durability, Deathblow, fog, hazard, and selection rules.

const HUSHIRO_MAX_HEALTH := 525
const HUSHIRO_MAX_POSTURE := 300.0
const HUSHIRO_DEATHBLOW_WINDOW := 3.0
const HUSHIRO_POSTURE_RESET_RATIO := 0.50
const HUSHIRO_REAPPEAR_TELL := 0.45
const HUSHIRO_FOG_ALPHA := 0.30
const HUSHIRO_REAPPEAR_ALPHA := 0.65

var _hushiro_finisher_kill := false
var _hushiro_last_major_attack: int = -1
var _hushiro_repeat_count := 0
var _hushiro_base_invis_cooldown := 0.0


func _ready() -> void:
	super._ready()

	collector_max_hp = HUSHIRO_MAX_HEALTH
	hp = HUSHIRO_MAX_HEALTH
	_max_hp = HUSHIRO_MAX_HEALTH
	deathblow_window_duration = HUSHIRO_DEATHBLOW_WINDOW

	# Disable the imported generic pressure-mode speedup. Hushiro's <50% escalation
	# is authored below as more combo pressure and a modestly shorter fog cooldown.
	pressure_mode_threshold = 0.0
	_hushiro_base_invis_cooldown = invis_cooldown
	masses_count = 1

	if combat:
		combat.config = CombatConfig.create_miniboss_config()
		combat.config.posture_max = HUSHIRO_MAX_POSTURE
		combat.config.posture_break_duration = HUSHIRO_DEATHBLOW_WINDOW
		combat.config.posture_break_reset_ratio = HUSHIRO_POSTURE_RESET_RATIO
		combat.set_posture(0.0)

	_update_bars()
	print("[TheCollector] Hushiro contract active: 525 Health / 300 Posture")


func _physics_process(delta: float) -> void:
	# Only Fog Vanish cooldown changes below half Health; movement and global attack
	# cooldowns remain unchanged so escalation does not become a generic speed boost.
	invis_cooldown = _hushiro_base_invis_cooldown * (0.85 if _hushiro_is_escalated() else 1.0)
	super._physics_process(delta)


func _pick_next_attack_sekiro(dist: float) -> AttackType:
	var chosen: AttackType = super._pick_next_attack_sekiro(dist)

	if chosen == AttackType.GROUND_MASSES and _hushiro_active_mass_count() >= _hushiro_mass_limit():
		chosen = AttackType.GREED_LASH if dist > close_range else AttackType.QUICK_SLASH

	# Below half Health, increase Chain Combo selection weight without globally
	# accelerating the boss. Snare remains a distinct close-range response.
	if _hushiro_is_escalated() and dist <= mid_range and chosen != AttackType.SOUL_CHAIN_SNARE:
		if _rng.randf() < 0.25:
			chosen = AttackType.CHAIN_COMBO

	if _would_repeat_major_attack(chosen):
		chosen = _fallback_major_attack(chosen, dist)

	return chosen


func _start_attack(atk: AttackType) -> void:
	var resolved: AttackType = atk
	var player := _get_player()
	var dist := 0.0
	if player != null and is_instance_valid(player):
		dist = global_position.distance_to(player.global_position)

	if resolved == AttackType.GROUND_MASSES and _hushiro_active_mass_count() >= _hushiro_mass_limit():
		resolved = AttackType.GREED_LASH if dist > close_range else AttackType.QUICK_SLASH
	if _would_repeat_major_attack(resolved):
		resolved = _fallback_major_attack(resolved, dist)

	if int(resolved) == _hushiro_last_major_attack:
		_hushiro_repeat_count += 1
	else:
		_hushiro_last_major_attack = int(resolved)
		_hushiro_repeat_count = 1

	super._start_attack(resolved)


func _would_repeat_major_attack(attack: AttackType) -> bool:
	return int(attack) == _hushiro_last_major_attack and _hushiro_repeat_count >= 2


func _fallback_major_attack(blocked_attack: AttackType, dist: float) -> AttackType:
	if dist > mid_range and blocked_attack != AttackType.GREED_LASH:
		return AttackType.GREED_LASH
	if dist <= close_range and blocked_attack != AttackType.QUICK_SLASH:
		return AttackType.QUICK_SLASH
	if blocked_attack != AttackType.CHAIN_COMBO:
		return AttackType.CHAIN_COMBO
	return AttackType.GREED_LASH


func _hushiro_is_escalated() -> bool:
	return float(hp) / float(maxi(1, get_max_hp())) < 0.50


func _hushiro_mass_limit() -> int:
	return 2 if _hushiro_is_escalated() else 1


func _hushiro_active_mass_count() -> int:
	var count := 0
	for mass in _active_masses:
		if is_instance_valid(mass):
			count += 1
	return count


func _spawn_masses() -> void:
	var player := _get_player()
	if player == null:
		return

	var available := maxi(0, _hushiro_mass_limit() - _hushiro_active_mass_count())
	var spawn_count := mini(masses_count, available)
	for _i in range(spawn_count):
		var mass := _create_mass()
		var offset := Vector2(_rng.randf_range(-40.0, 40.0), _rng.randf_range(-40.0, 40.0))
		mass.global_position = player.global_position + offset
		get_parent().add_child(mass)
		_active_masses.append(mass)


func _perform_chain_combo_extended(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return

	_combo_hit_index = 0
	_combo_should_continue = true
	_combo_was_parried = false
	_combo_planned_hits = 4

	for hit_num in range(1, 5):
		if _should_abort_attack(seq_id) or not _combo_should_continue:
			break
		await _perform_combo_hit_fast(seq_id, hit_num)
		if hit_num < 4 and _combo_should_continue:
			var gap := combo_inter_hit_gap + (0.08 if _combo_was_parried else 0.0)
			await get_tree().create_timer(gap).timeout

	if _should_abort_attack(seq_id):
		_finish_attack()
		return
	_finish_attack()


func _perform_invisibility(seq_id: int) -> void:
	if _should_abort_attack(seq_id):
		return

	_cleanup_hitbox()
	velocity = Vector2.ZERO
	_behavior_state = BehaviorState.INVISIBLE
	_invisible = true
	_pre_invis_modulate = sprite.modulate if sprite else Color.WHITE
	_in_combo_sequence = false
	_attack_chain_count = 0
	_hide_parry_indicator()

	# Fog Vanish is controlled concealment, not true invisibility. Keep the body,
	# HurtBox, health/posture bars, and a visible silhouette active throughout.
	if sprite:
		var fade := create_tween()
		fade.tween_property(sprite, "modulate:a", HUSHIRO_FOG_ALPHA, invis_fade_time)
		await fade.finished

	if _should_abort_attack(seq_id):
		_hushiro_restore_from_fog()
		_finish_attack()
		return

	await get_tree().create_timer(invis_duration).timeout
	if _should_abort_attack(seq_id):
		_hushiro_restore_from_fog()
		_finish_attack()
		return

	var player := _get_player()
	if player != null and is_instance_valid(player):
		global_position = _hushiro_pick_legal_reappear_position(player)
		_face_direction((player.global_position - global_position).normalized())

	# Reappearance becomes readable before the attack. Restore collision visibility
	# enough to clearly telegraph the silhouette, then perform a standard re-entry hit.
	_invisible = false
	_behavior_state = BehaviorState.ATTACKING
	_invis_cooldown_until = Time.get_ticks_msec() * 0.001 + invis_cooldown
	if sprite:
		sprite.modulate = _pre_invis_modulate
		sprite.modulate.a = HUSHIRO_REAPPEAR_ALPHA

	await get_tree().create_timer(HUSHIRO_REAPPEAR_TELL).timeout
	if _should_abort_attack(seq_id):
		_hushiro_restore_from_fog()
		_finish_attack()
		return

	if sprite:
		sprite.modulate = _pre_invis_modulate
		sprite.modulate.a = 1.0

	_is_ambushing = true
	await _perform_ambush_slash(seq_id)
	_is_ambushing = false
	_cleanup_hitbox()
	_finish_attack()


func _hushiro_restore_from_fog() -> void:
	_invisible = false
	_invis_cooldown_until = Time.get_ticks_msec() * 0.001 + invis_cooldown
	if _phase != Phase.DEAD:
		_behavior_state = BehaviorState.IDLE
	if sprite:
		sprite.modulate = _pre_invis_modulate
		sprite.modulate.a = 1.0
	if _bars_container:
		_bars_container.visible = true


func _hushiro_pick_legal_reappear_position(player: Node2D) -> Vector2:
	var min_dist := maxf(50.0, invis_reappear_min_dist)
	var max_dist := maxf(min_dist, invis_reappear_max_dist)
	var bounds_rect := Rect2()
	var has_bounds := false
	var chamber := get_parent()
	if chamber != null:
		var bounds := chamber.get_node_or_null("RoomBounds")
		if bounds != null and bounds.has_method("get_rect_global"):
			bounds_rect = bounds.call("get_rect_global")
			has_bounds = bounds_rect.size != Vector2.ZERO

	var space := get_world_2d().direct_space_state
	for _attempt in range(10):
		var angle := _rng.randf_range(0.0, TAU)
		var distance := _rng.randf_range(min_dist, max_dist)
		var candidate := player.global_position + Vector2.RIGHT.rotated(angle) * distance
		if has_bounds:
			candidate.x = clampf(candidate.x, bounds_rect.position.x + 24.0, bounds_rect.end.x - 24.0)
			candidate.y = clampf(candidate.y, bounds_rect.position.y + 24.0, bounds_rect.end.y - 24.0)

		var query := PhysicsPointQueryParameters2D.new()
		query.position = candidate
		query.collision_mask = 1
		query.collide_with_areas = false
		query.collide_with_bodies = true
		if space.intersect_point(query, 8).is_empty():
			return candidate

	# Stable fallback: stay navigable and never teleport directly onto Akio.
	var fallback := player.global_position + Vector2.RIGHT * min_dist
	if has_bounds:
		fallback.x = clampf(fallback.x, bounds_rect.position.x + 24.0, bounds_rect.end.x - 24.0)
		fallback.y = clampf(fallback.y, bounds_rect.position.y + 24.0, bounds_rect.end.y - 24.0)
	return fallback


func _die() -> void:
	if _hushiro_finisher_kill:
		super._die()
		return

	# Health depletion opens the same 3-second killing Deathblow opportunity as a
	# posture break. The Collector remains at minimum 1 Health until executed.
	if _phase == Phase.DEAD:
		return
	hp = 1
	_update_bars()
	if not _dbroken_active:
		_on_posture_broken(HUSHIRO_DEATHBLOW_WINDOW)


func _update_posture_break(delta: float) -> void:
	var was_broken := _dbroken_active
	super._update_posture_break(delta)
	if was_broken and not _dbroken_active and _phase != Phase.DEAD:
		hp = maxi(hp, 1)
		if combat and combat.config:
			combat.set_posture(combat.config.posture_max * HUSHIRO_POSTURE_RESET_RATIO)
		_update_bars()


func take_deathblow(_attacker: Node) -> void:
	if _phase == Phase.DEAD or not _dbroken_active:
		return
	_hushiro_finisher_kill = true
	hp = 0
	_dbroken_active = false
	_set_body_collision_enabled(true)
	_cleanup_hitbox()
	_release_snare()
	_hide_parry_indicator()
	super._die()
