extends Node

## Canonical first-playtest Technique combat executor.
##
## This runtime follows docs/gameplay/TECHNIQUE_CATALOG.md. The catalog intentionally
## leaves exact numerical tuning open, so the constants below are implementation
## baselines for playtesting rather than new design authority. Technique ownership,
## eligibility, rarity, and reward generation remain owned by UpgradeService.
##
## Current responsibilities:
## - classify sword contacts by canonical attack_id;
## - execute Echo, Rupture, Seal, Rift, and Crimson Action Techniques;
## - execute the approved Supporting, Cross-family, Legendary, and refinement rules
##   where their parent mechanic exists;
## - maintain enemy status state/visual readouts without depending on old elemental
##   Storm/Frost/Hex/Ember/Shadow effects;
## - emit lightweight telemetry for long playtests.

const ECHO_DELAY := 0.32
const ECHO_BASIC_MULT := 0.55
const ECHO_HELD_MULT := 0.80
const ECHO_DASH_MULT := 0.65
const ECHO_COUNTER_MULT := 0.70
const ECHO_SECONDARY_MULT := 0.55
const ECHO_SEARCH_RADIUS := 125.0

const RUPTURE_MAX := 100.0
const RUPTURE_BASIC := 18.0
const RUPTURE_DASH := 24.0
const RUPTURE_COUNTER := 46.0
const RUPTURE_DEATHBLOW := 26.0
const RUPTURE_PROC_POSTURE := 42.0
const RUPTURE_NEARBY_POSTURE := 14.0
const RUPTURE_RADIUS := 120.0
const RUPTURE_CHAIN_START := 18.0
const RUPTURE_HEAVENBREAKER_THRESHOLD := 68.0

const SEAL_DURATION := 5.0
const SEAL_REFINED_DURATION := 7.0
const SEAL_BIND_DURATION := 1.35
const SEAL_ONE_MOVE_MULT := 0.88
const SEAL_TWO_MOVE_MULT := 0.72
const SEAL_SPREAD_RADIUS := 115.0

const RIFT_FUSE := 1.20
const RIFT_FAST_FUSE := 0.82
const RIFT_MAX_INTENSITY := 3
const RIFT_DAMAGE := [0, 10, 17, 25]
const RIFT_RADIUS := 115.0
const RIFT_COLLAPSE_RADIUS := 92.0
const RIFT_COLLAPSE_DAMAGE := 10

const VULNERABLE_DURATION := 3.0
const VULNERABLE_REFINED_DURATION := 4.5
const VULNERABLE_BACKSTAB_BONUS := 0.75
const DEEP_CUT_BACKSTAB_BONUS := 1.35
const UNSEEN_DURATION := 2.4
const UNSEEN_BACKSTAB_BONUS := 1.00
const CRIMSON_AOE_RADIUS := 92.0
const BLOOD_ARC_DAMAGE := 7
const SEVERED_LINE_DAMAGE := 8

const INDICATOR_OFFSET := Vector2(-18.0, -42.0)


func _ready() -> void:
	if not get_tree().node_removed.is_connected(_on_node_removed):
		get_tree().node_removed.connect(_on_node_removed)
	print("[TechniqueEffects] v1.0 - canonical five-family runtime")


func _process(_delta: float) -> void:
	var now := _now()
	for enemy in _enemy_nodes():
		if not is_instance_valid(enemy):
			continue
		enemy.set_meta("_technique_runtime_seen_enemy", true)
		_tick_enemy_status(enemy, now)
	_tick_player_status(now)


func _physics_process(_delta: float) -> void:
	# Apply movement restrictions after authored enemy physics has had its turn. This
	# preserves attack/AI state while making Seal constrain movement rather than stun.
	call_deferred("_enforce_control_states")


# =============================================================================
# PUBLIC HOOKS
# =============================================================================

func on_player_hit(target: Node, player: Node, attack_area: Area2D = null) -> void:
	if not is_instance_valid(target) or not is_instance_valid(player):
		return

	var acquired := _acquired()
	if acquired.is_empty():
		return

	var attack_id := ""
	var base_damage := 0
	var proc_coefficient := 1.0
	if attack_area != null:
		attack_id = str(attack_area.get_meta("attack_id", ""))
		base_damage = int(attack_area.get_meta("health_damage", attack_area.get_meta("damage", 0)))
		proc_coefficient = float(attack_area.get_meta("proc_coefficient", 1.0))

	var trigger := _trigger_for_attack_id(attack_id)
	var was_vulnerable := _is_vulnerable(target)
	var backstab := _is_genuine_backstab(target, player)

	# Vulnerable is a family rule, not a specific Technique. Existing Vulnerable
	# amplifies genuine backstabs from any sword action without manufacturing one.
	if was_vulnerable and backstab and base_damage > 0:
		_apply_health_damage(target, maxi(1, int(round(base_damage * VULNERABLE_BACKSTAB_BONUS))), "vulnerable_backstab")
		if "crimson_fresh_wound" in acquired:
			_apply_vulnerable(target, VULNERABLE_DURATION, "fresh_wound")
		if "crimson_severed_line" in acquired:
			_damage_enemy_behind(target, player, SEVERED_LINE_DAMAGE, CRIMSON_AOE_RADIUS, "severed_line")

	if _player_is_unseen(player):
		if backstab and base_damage > 0:
			_apply_health_damage(target, maxi(1, int(round(base_damage * UNSEEN_BACKSTAB_BONUS))), "unseen_backstab")
		_clear_unseen(player)

	_match_echo_hit(target, player, attack_area, trigger, base_damage, acquired)
	_match_rupture_hit(target, player, trigger, proc_coefficient, acquired)
	_match_seal_hit(target, player, trigger, acquired)
	_match_rift_hit(target, player, trigger, acquired)
	_match_crimson_hit(target, player, trigger, base_damage, backstab, acquired)


func get_target_debug_state(target: Node) -> Dictionary:
	if not is_instance_valid(target):
		return {}
	return {
		"rupture": float(target.get_meta("_tech_rupture", 0.0)),
		"seal": int(target.get_meta("_tech_seal_count", 0)),
		"bound_until": float(target.get_meta("_tech_bound_until", 0.0)),
		"rift_intensity": int(target.get_meta("_tech_rift_intensity", 0)),
		"rift_open_at": float(target.get_meta("_tech_rift_open_at", 0.0)),
		"vulnerable_until": float(target.get_meta("_tech_vulnerable_until", 0.0)),
	}


# =============================================================================
# ACTION DISPATCH
# =============================================================================

func _match_echo_hit(target: Node, player: Node, attack_area: Area2D, trigger: String, base_damage: int, acquired: Array) -> void:
	if base_damage <= 0:
		return
	match trigger:
		"basic":
			if "echo_lingering_cut" in acquired:
				_schedule_echo(target, player, base_damage, ECHO_BASIC_MULT, false, acquired)
		"held":
			if "echo_second_draw" in acquired:
				_schedule_echo(target, player, base_damage, ECHO_HELD_MULT, false, acquired)
		"dash":
			if "echo_passing_shadow" in acquired:
				_schedule_echo(target, player, base_damage, ECHO_DASH_MULT, false, acquired)
		"counter":
			if "echo_remembered_reversal" in acquired:
				_schedule_echo(target, player, base_damage, ECHO_COUNTER_MULT, false, acquired)


func _match_rupture_hit(target: Node, _player: Node, trigger: String, proc_coefficient: float, acquired: Array) -> void:
	match trigger:
		"basic":
			if "rupture_rupturing_edge" in acquired:
				var amount := RUPTURE_BASIC * maxf(0.1, proc_coefficient)
				if "refine_rupture_rupturing_edge" in acquired:
					amount *= 1.30
				_add_rupture(target, amount, acquired, false)
		"held":
			if "rupture_mountain_breaker" in acquired:
				_apply_posture_damage(target, 18.0, "mountain_breaker")
		"dash":
			if "rupture_breaching_step" in acquired:
				_apply_posture_damage(target, 8.0, "breaching_step")
				_add_rupture(target, RUPTURE_DASH, acquired, false)
		"counter":
			if "rupture_breaking_reversal" in acquired:
				_add_rupture(target, RUPTURE_COUNTER, acquired, false)


func _match_seal_hit(target: Node, _player: Node, trigger: String, acquired: Array) -> void:
	match trigger:
		"basic":
			if "seal_sealing_cuts" in acquired:
				var duration := SEAL_REFINED_DURATION if "refine_seal_sealing_cuts" in acquired else SEAL_DURATION
				_apply_seal(target, 1, acquired, duration, false)
		"held":
			if "seal_binding_draw" in acquired:
				_apply_seal(target, 2, acquired, SEAL_DURATION, false)
		"dash":
			if "seal_warding_step" in acquired:
				var already_sealed := int(target.get_meta("_tech_seal_count", 0)) > 0
				_apply_seal(target, 1, acquired, SEAL_DURATION, false)
				if already_sealed:
					var nearby := _nearest_enemy(target.global_position, target, SEAL_SPREAD_RADIUS)
					if nearby != null:
						_apply_seal(nearby, 1, acquired, SEAL_DURATION, true)
		"counter":
			if "seal_counterseal" in acquired:
				_apply_seal(target, 2, acquired, SEAL_DURATION, false)


func _match_rift_hit(target: Node, _player: Node, trigger: String, acquired: Array) -> void:
	match trigger:
		"basic":
			if "rift_rift_edge" in acquired:
				var amount := 1
				if int(target.get_meta("_tech_rift_intensity", 0)) > 0 and "refine_rift_rift_edge" in acquired:
					amount = 2
				_apply_rift(target, amount, RIFT_FUSE, acquired, false, false)
		"held":
			if "rift_deep_rift" in acquired:
				_apply_rift(target, 2, RIFT_FUSE, acquired, false, false)
		"dash":
			if "rift_shearing_step" in acquired:
				_apply_rift(target, 1, RIFT_FAST_FUSE, acquired, false, true)
		"counter":
			if "rift_rift_reversal" in acquired:
				var existed := int(target.get_meta("_tech_rift_intensity", 0)) > 0
				_apply_rift(target, 2, RIFT_FAST_FUSE, acquired, false, true)
				if existed and is_instance_valid(target):
					_open_rift(target, acquired, false)


func _match_crimson_hit(target: Node, player: Node, trigger: String, base_damage: int, backstab: bool, acquired: Array) -> void:
	match trigger:
		"basic":
			if "crimson_open_wound" in acquired:
				var duration := VULNERABLE_REFINED_DURATION if "refine_crimson_open_wound" in acquired else VULNERABLE_DURATION
				_apply_vulnerable(target, duration, "open_wound")
		"dash":
			if "crimson_blood_arc" in acquired:
				_apply_health_damage(target, BLOOD_ARC_DAMAGE, "blood_arc")
				var radius := CRIMSON_AOE_RADIUS * (1.25 if "refine_crimson_blood_arc" in acquired else 1.0)
				_damage_nearby(target.global_position, target, radius, BLOOD_ARC_DAMAGE, "blood_arc_aoe", 3)
		"counter":
			if "crimson_exposed_guard" in acquired:
				_apply_vulnerable(target, VULNERABLE_DURATION, "exposed_guard")
		"held":
			if "crimson_deep_cut" in acquired and backstab and base_damage > 0:
				_apply_health_damage(target, maxi(1, int(round(base_damage * DEEP_CUT_BACKSTAB_BONUS))), "deep_cut")


# =============================================================================
# ECHO
# =============================================================================

func _schedule_echo(target: Node, player: Node, source_damage: int, multiplier: float, secondary: bool, acquired: Array) -> void:
	if not is_instance_valid(target):
		return
	var pending := int(target.get_meta("_tech_echo_pending", 0))
	target.set_meta("_tech_echo_pending", pending + 1)
	var strength := multiplier
	if "echo_gathering_memory" in acquired:
		strength *= 1.0 + minf(0.60, float(pending) * 0.20)
	var damage := maxi(1, int(round(float(source_damage) * strength)))
	var target_ref := weakref(target)
	var player_ref := weakref(player)
	_record("echo_scheduled", target, {"damage": damage, "secondary": secondary, "pending": pending + 1})
	get_tree().create_timer(ECHO_DELAY).timeout.connect(func():
		var resolved: Node = target_ref.get_ref() if target_ref != null else null
		var resolved_player: Node = player_ref.get_ref() if player_ref != null else null
		if resolved == null or not is_instance_valid(resolved):
			return
		resolved.set_meta("_tech_echo_pending", maxi(0, int(resolved.get_meta("_tech_echo_pending", 1)) - 1))
		var hp_before := _read_hp(resolved)
		var posture_before := _read_posture(resolved)
		_apply_health_damage(resolved, damage, "echo")
		_pulse(resolved, Color(0.85, 0.92, 1.0, 1.0), "ECHO")
		if "cross_resonant_break" in acquired:
			_add_rupture(resolved, 10.0, acquired, true)
		if "cross_fractured_memory" in acquired and int(resolved.get_meta("_tech_rift_intensity", 0)) > 0:
			_apply_rift(resolved, 1, RIFT_FUSE, acquired, true, false)
		if "echo_pale_wake" in acquired and resolved_player != null and is_instance_valid(resolved_player):
			_damage_enemy_behind(resolved, resolved_player, maxi(1, int(round(damage * 0.55))), ECHO_SEARCH_RADIUS, "pale_wake")
		var killed := hp_before > 0.0 and _read_hp(resolved) <= 0.0
		var broke := posture_before < _read_posture_max(resolved) and _read_posture(resolved) >= _read_posture_max(resolved)
		if not secondary and "echo_passing_memory" in acquired and (killed or broke):
			var next := _nearest_enemy((resolved as Node2D).global_position if resolved is Node2D else Vector2.ZERO, resolved, ECHO_SEARCH_RADIUS)
			if next != null:
				_schedule_echo(next, resolved_player, damage, ECHO_SECONDARY_MULT, true, acquired)
		if not secondary and "echo_unforgotten_steel" in acquired and is_instance_valid(resolved):
			_schedule_echo(resolved, resolved_player, damage, ECHO_SECONDARY_MULT, true, acquired)
	)


# =============================================================================
# RUPTURE
# =============================================================================

func _add_rupture(target: Node, amount: float, acquired: Array, secondary: bool) -> void:
	if not is_instance_valid(target) or amount <= 0.0:
		return
	if "rupture_guardbreaker" in acquired and target.has_method("is_blocking") and bool(target.call("is_blocking")):
		amount *= 1.45
	var value := minf(RUPTURE_MAX, float(target.get_meta("_tech_rupture", 0.0)) + amount)
	target.set_meta("_tech_rupture", value)
	_update_indicator(target)
	_record("rupture_buildup", target, {"amount": amount, "total": value, "secondary": secondary})
	if value >= RUPTURE_MAX:
		_trigger_rupture(target, acquired, secondary)


func _trigger_rupture(target: Node, acquired: Array, secondary: bool) -> void:
	if not is_instance_valid(target):
		return
	target.set_meta("_tech_rupture", RUPTURE_CHAIN_START if "rupture_faultline" in acquired else 0.0)
	_apply_posture_damage(target, RUPTURE_PROC_POSTURE, "rupture")
	_pulse(target, Color(1.0, 0.72, 0.18, 1.0), "RUPTURE")
	_damage_posture_nearby(_node_position(target), target, RUPTURE_RADIUS, RUPTURE_NEARBY_POSTURE, "rupture_wave", 4)

	if "rupture_chain_break" in acquired:
		for nearby in _nearby_enemies(_node_position(target), target, RUPTURE_RADIUS, 3):
			_add_rupture(nearby, 18.0, acquired, true)

	if "cross_shattered_scar" in acquired and int(target.get_meta("_tech_rift_intensity", 0)) > 0:
		_apply_rift(target, 2, RIFT_FAST_FUSE, acquired, true, true)
	if "cross_exposed_break" in acquired:
		_apply_vulnerable(target, VULNERABLE_DURATION, "exposed_break")

	if not secondary and "rupture_heavenbreaker" in acquired:
		for nearby in _nearby_enemies(_node_position(target), target, RUPTURE_RADIUS, 4):
			if float(nearby.get_meta("_tech_rupture", 0.0)) >= RUPTURE_HEAVENBREAKER_THRESHOLD:
				nearby.set_meta("_tech_rupture", RUPTURE_MAX)
				_trigger_rupture(nearby, acquired, true)

	_update_indicator(target)
	_record("rupture_triggered", target, {"secondary": secondary})


# =============================================================================
# SEAL
# =============================================================================

func _apply_seal(target: Node, steps: int, acquired: Array, duration: float, secondary: bool) -> void:
	if not is_instance_valid(target) or steps <= 0:
		return
	var now := _now()
	if float(target.get_meta("_tech_bound_until", 0.0)) > now:
		return
	var count := clampi(int(target.get_meta("_tech_seal_count", 0)) + steps, 0, 3)
	target.set_meta("_tech_seal_count", count)
	target.set_meta("_tech_seal_expire_at", now + duration)
	_update_indicator(target)
	_record("seal_applied", target, {"steps": steps, "count": count, "secondary": secondary})
	if count >= 3:
		_trigger_bind(target, acquired, secondary)


func _trigger_bind(target: Node, acquired: Array, secondary: bool) -> void:
	if not is_instance_valid(target):
		return
	var now := _now()
	target.set_meta("_tech_seal_count", 0)
	target.set_meta("_tech_seal_expire_at", 0.0)
	target.set_meta("_tech_bound_until", now + SEAL_BIND_DURATION)
	target.set_meta("_tech_bound_anchor", _node_position(target))
	_pulse(target, Color(0.72, 0.40, 1.0, 1.0), "BIND")

	if "cross_bound_wound" in acquired:
		_apply_vulnerable(target, SEAL_BIND_DURATION + 0.6, "bound_wound")

	if "seal_shared_restraint" in acquired:
		for nearby in _nearby_enemies(_node_position(target), target, SEAL_SPREAD_RADIUS, 3):
			_apply_seal(nearby, 1, acquired, SEAL_DURATION, true)

	if not secondary and "seal_closed_circle" in acquired:
		for nearby in _nearby_enemies(_node_position(target), target, SEAL_SPREAD_RADIUS, 2):
			_apply_seal(nearby, 2, acquired, SEAL_DURATION, true)

	_update_indicator(target)
	_record("seal_bound", target, {"duration": SEAL_BIND_DURATION, "secondary": secondary})


# =============================================================================
# RIFT
# =============================================================================

func _apply_rift(target: Node, intensity_add: int, fuse: float, acquired: Array, secondary: bool, accelerate: bool) -> void:
	if not is_instance_valid(target):
		return
	var now := _now()
	var current := int(target.get_meta("_tech_rift_intensity", 0))
	var first := current <= 0
	if first:
		current = 1 if not bool(target.get_meta("_tech_rift_scar", false)) else 2
		target.set_meta("_tech_rift_scar", false)
		intensity_add -= 1
	current = clampi(current + maxi(0, intensity_add), 1, RIFT_MAX_INTENSITY)
	target.set_meta("_tech_rift_intensity", current)
	var existing_open := float(target.get_meta("_tech_rift_open_at", 0.0))
	var desired_open := now + fuse
	if first or existing_open <= now:
		target.set_meta("_tech_rift_open_at", desired_open)
	elif accelerate:
		target.set_meta("_tech_rift_open_at", minf(existing_open, desired_open))
	target.set_meta("_tech_rift_secondary", secondary)
	_update_indicator(target)
	_record("rift_changed", target, {"intensity": current, "secondary": secondary, "open_at": float(target.get_meta("_tech_rift_open_at", 0.0))})
	if current >= RIFT_MAX_INTENSITY and "rift_overpressure" in acquired:
		_open_rift(target, acquired, secondary)


func _open_rift(target: Node, acquired: Array, secondary: bool) -> void:
	if not is_instance_valid(target):
		return
	var intensity := clampi(int(target.get_meta("_tech_rift_intensity", 0)), 0, RIFT_MAX_INTENSITY)
	if intensity <= 0:
		return
	target.set_meta("_tech_rift_intensity", 0)
	target.set_meta("_tech_rift_open_at", 0.0)
	var damage := int(RIFT_DAMAGE[intensity])
	_apply_health_damage(target, damage, "rift")
	_pulse(target, Color(1.0, 0.96, 0.82, 1.0), "RIFT %d" % intensity)

	if "rift_lingering_scar" in acquired:
		target.set_meta("_tech_rift_scar", true)

	if intensity >= RIFT_MAX_INTENSITY and "rift_ivory_collapse" in acquired:
		_damage_nearby(_node_position(target), target, RIFT_COLLAPSE_RADIUS, RIFT_COLLAPSE_DAMAGE, "ivory_collapse", 4)

	if not secondary and "rift_fracture_spread" in acquired:
		var nearby := _nearest_enemy(_node_position(target), target, RIFT_RADIUS)
		if nearby != null:
			_apply_rift(nearby, 1, RIFT_FUSE, acquired, true, false)

	_update_indicator(target)
	_record("rift_opened", target, {"intensity": intensity, "damage": damage, "secondary": secondary})


# =============================================================================
# CRIMSON
# =============================================================================

func _apply_vulnerable(target: Node, duration: float, source: String) -> void:
	if not is_instance_valid(target):
		return
	target.set_meta("_tech_vulnerable_until", maxf(float(target.get_meta("_tech_vulnerable_until", 0.0)), _now() + duration))
	_update_indicator(target)
	_record("vulnerable_applied", target, {"duration": duration, "source": source})


func _apply_unseen(player: Node) -> void:
	if not is_instance_valid(player):
		return
	player.set_meta("_tech_unseen_until", _now() + UNSEEN_DURATION)
	player.set_meta("_tech_unseen_active", true)
	if player is CanvasItem:
		(player as CanvasItem).modulate.a = 0.55
	_record("unseen_started", player, {"duration": UNSEEN_DURATION})


func _clear_unseen(player: Node) -> void:
	if not is_instance_valid(player):
		return
	player.set_meta("_tech_unseen_until", 0.0)
	player.set_meta("_tech_unseen_active", false)
	if player is CanvasItem:
		(player as CanvasItem).modulate.a = 1.0
	_record("unseen_ended", player, {})


# =============================================================================
# DEATH / DEATHBLOW
# =============================================================================

func _on_node_removed(node: Node) -> void:
	if node == null or not bool(node.get_meta("_technique_runtime_seen_enemy", false)):
		return
	if bool(node.get_meta("_technique_death_processed", false)):
		return
	if not _node_is_dead(node):
		return
	node.set_meta("_technique_death_processed", true)
	_process_enemy_death(node)


func _process_enemy_death(target: Node) -> void:
	var acquired := _acquired()
	if acquired.is_empty():
		return
	var position := _node_position(target)
	var player := get_tree().get_first_node_in_group("player")
	var was_vulnerable := float(target.get_meta("_tech_vulnerable_until", 0.0)) > 0.0
	var seal_count := int(target.get_meta("_tech_seal_count", 0))

	if "seal_passing_script" in acquired and seal_count > 0:
		var seal_target := _nearest_enemy(position, target, SEAL_SPREAD_RADIUS)
		if seal_target != null:
			_apply_seal(seal_target, 1, acquired, SEAL_DURATION, true)

	if "crimson_blood_trail" in acquired and was_vulnerable:
		var blood_target := _nearest_enemy(position, target, CRIMSON_AOE_RADIUS + 35.0)
		if blood_target != null:
			_apply_vulnerable(blood_target, VULNERABLE_DURATION, "blood_trail")

	if player != null and is_instance_valid(player) and _player_in_deathblow_state(player):
		_on_deathblow(position, target, player, acquired)


func _on_deathblow(position: Vector2, target: Node, player: Node, acquired: Array) -> void:
	if "echo_final_memory" in acquired:
		var count := 4 if "refine_echo_final_memory" in acquired else 3
		var candidates := _nearby_enemies(position, target, ECHO_SEARCH_RADIUS + 25.0, count)
		for candidate in candidates:
			_schedule_echo(candidate, player, 18, 0.75, false, acquired)

	if "rupture_shattered_ground" in acquired:
		var radius := RUPTURE_RADIUS * (1.25 if "refine_rupture_shattered_ground" in acquired else 1.0)
		for candidate in _nearby_enemies(position, target, radius, 5):
			_apply_posture_damage(candidate, RUPTURE_NEARBY_POSTURE, "shattered_ground")
			_add_rupture(candidate, RUPTURE_DEATHBLOW, acquired, true)

	if "seal_passing_seal" in acquired:
		var transfers := 2 if "refine_seal_passing_seal" in acquired else 1
		for candidate in _nearby_enemies(position, target, SEAL_SPREAD_RADIUS, transfers):
			_apply_seal(candidate, 1, acquired, SEAL_DURATION, true)

	if "rift_parting_rift" in acquired:
		var rift_target := _nearest_enemy(position, target, RIFT_RADIUS + 20.0)
		if rift_target != null:
			var amount := 2 if "refine_rift_parting_rift" in acquired else 1
			_apply_rift(rift_target, amount, RIFT_FUSE, acquired, true, false)

	if "crimson_predators_wake" in acquired:
		for candidate in _nearby_enemies(position, target, CRIMSON_AOE_RADIUS + 30.0, 4):
			_apply_vulnerable(candidate, VULNERABLE_DURATION, "predators_wake")

	if "crimson_unseen" in acquired:
		_apply_unseen(player)

	_record("deathblow_techniques", player, {"position": [position.x, position.y]})


# =============================================================================
# STATUS TICK / CONTROL
# =============================================================================

func _tick_enemy_status(target: Node, now: float) -> void:
	var seal_count := int(target.get_meta("_tech_seal_count", 0))
	var seal_expire := float(target.get_meta("_tech_seal_expire_at", 0.0))
	if seal_count > 0 and seal_expire > 0.0 and now >= seal_expire:
		target.set_meta("_tech_seal_count", 0)
		target.set_meta("_tech_seal_expire_at", 0.0)

	var bound_until := float(target.get_meta("_tech_bound_until", 0.0))
	if bound_until > 0.0 and now >= bound_until:
		target.set_meta("_tech_bound_until", 0.0)
		if "seal_residual_knot" in _acquired():
			target.set_meta("_tech_seal_count", 1)
			target.set_meta("_tech_seal_expire_at", now + SEAL_DURATION)

	var open_at := float(target.get_meta("_tech_rift_open_at", 0.0))
	if open_at > 0.0 and now >= open_at and int(target.get_meta("_tech_rift_intensity", 0)) > 0:
		_open_rift(target, _acquired(), bool(target.get_meta("_tech_rift_secondary", false)))

	if float(target.get_meta("_tech_vulnerable_until", 0.0)) > 0.0 and now >= float(target.get_meta("_tech_vulnerable_until", 0.0)):
		target.set_meta("_tech_vulnerable_until", 0.0)

	_update_indicator(target)


func _tick_player_status(now: float) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null or not is_instance_valid(player):
		return
	if _player_is_unseen(player) and now >= float(player.get_meta("_tech_unseen_until", 0.0)):
		_clear_unseen(player)


func _enforce_control_states() -> void:
	var now := _now()
	for target in _enemy_nodes():
		if not is_instance_valid(target):
			continue
		var bound_until := float(target.get_meta("_tech_bound_until", 0.0))
		if bound_until > now:
			if target is Node2D:
				var anchor: Vector2 = target.get_meta("_tech_bound_anchor", (target as Node2D).global_position)
				(target as Node2D).global_position = anchor
			if target is CharacterBody2D:
				(target as CharacterBody2D).velocity = Vector2.ZERO
			continue
		var seals := int(target.get_meta("_tech_seal_count", 0))
		if target is CharacterBody2D and seals > 0:
			var mult := SEAL_ONE_MOVE_MULT if seals == 1 else SEAL_TWO_MOVE_MULT
			(target as CharacterBody2D).velocity *= mult


# =============================================================================
# DAMAGE / QUERY HELPERS
# =============================================================================

func _apply_health_damage(target: Node, amount: int, source: String) -> void:
	if not is_instance_valid(target) or amount <= 0:
		return
	if target.has_method("apply_hp_damage"):
		target.call("apply_hp_damage", amount)
	elif target.get("hp") != null:
		target.set("hp", maxi(0, int(target.get("hp")) - amount))
	if target.has_method("show_enemy_damage_number"):
		target.call("show_enemy_damage_number", amount, "technique", -28.0)
	_record("technique_health_damage", target, {"amount": amount, "source": source})
	_finish_if_dead(target)


func _apply_posture_damage(target: Node, amount: float, source: String) -> void:
	if not is_instance_valid(target) or amount <= 0.0:
		return
	if target.has_method("add_posture_damage"):
		target.call("add_posture_damage", amount)
	else:
		var combat := target.get_node_or_null("Combat")
		if combat != null and combat.has_method("add_posture"):
			combat.call("add_posture", amount)
	_record("technique_posture_damage", target, {"amount": amount, "source": source})


func _finish_if_dead(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var hp := target.get("hp")
	if hp == null or int(hp) > 0:
		return
	if target.has_method("death"):
		target.call_deferred("death")


func _damage_nearby(position: Vector2, exclude: Node, radius: float, amount: int, source: String, limit: int) -> void:
	for enemy in _nearby_enemies(position, exclude, radius, limit):
		_apply_health_damage(enemy, amount, source)


func _damage_posture_nearby(position: Vector2, exclude: Node, radius: float, amount: float, source: String, limit: int) -> void:
	for enemy in _nearby_enemies(position, exclude, radius, limit):
		_apply_posture_damage(enemy, amount, source)


func _damage_enemy_behind(primary: Node, player: Node, amount: int, radius: float, source: String) -> void:
	if not (primary is Node2D) or not (player is Node2D):
		return
	var axis := ((primary as Node2D).global_position - (player as Node2D).global_position).normalized()
	if axis.length_squared() <= 0.001:
		return
	var origin := (primary as Node2D).global_position
	var best: Node = null
	var best_dist := INF
	for candidate in _enemy_nodes():
		if candidate == primary or not (candidate is Node2D) or _node_is_dead(candidate):
			continue
		var offset := (candidate as Node2D).global_position - origin
		var dist := offset.length()
		if dist <= 1.0 or dist > radius:
			continue
		if axis.dot(offset.normalized()) < 0.60:
			continue
		if dist < best_dist:
			best_dist = dist
			best = candidate
	if best != null:
		_apply_health_damage(best, amount, source)


func _nearby_enemies(position: Vector2, exclude: Node, radius: float, limit: int) -> Array[Node]:
	var candidates: Array[Node] = []
	for enemy in _enemy_nodes():
		if enemy == exclude or not (enemy is Node2D) or _node_is_dead(enemy):
			continue
		if (enemy as Node2D).global_position.distance_to(position) <= radius:
			candidates.append(enemy)
	candidates.sort_custom(func(a: Node, b: Node) -> bool:
		return (a as Node2D).global_position.distance_to(position) < (b as Node2D).global_position.distance_to(position)
	)
	if limit > 0 and candidates.size() > limit:
		candidates.resize(limit)
	return candidates


func _nearest_enemy(position: Vector2, exclude: Node, radius: float) -> Node:
	var found := _nearby_enemies(position, exclude, radius, 1)
	return found[0] if not found.is_empty() else null


func _enemy_nodes() -> Array[Node]:
	var out: Array[Node] = []
	for group_name in ["enemy", "miniboss"]:
		for node in get_tree().get_nodes_in_group(group_name):
			if is_instance_valid(node) and node not in out:
				out.append(node)
	return out


func _node_position(node: Node) -> Vector2:
	return (node as Node2D).global_position if node is Node2D else Vector2.ZERO


func _read_hp(target: Node) -> float:
	var hp := target.get("hp")
	return float(hp) if hp != null else 1.0


func _read_posture(target: Node) -> float:
	var combat := target.get_node_or_null("Combat")
	if combat != null:
		var value := combat.get("posture")
		if value != null:
			return float(value)
	var stagger := target.get("stagger")
	return float(stagger) if stagger != null else 0.0


func _read_posture_max(target: Node) -> float:
	var combat := target.get_node_or_null("Combat")
	if combat != null:
		var value := combat.get("max_posture")
		if value != null:
			return maxf(1.0, float(value))
	var stagger_max := target.get("stagger_max")
	return maxf(1.0, float(stagger_max)) if stagger_max != null else 100.0


func _node_is_dead(node: Node) -> bool:
	if node == null or not is_instance_valid(node):
		return true
	if node.has_method("is_dead"):
		return bool(node.call("is_dead"))
	var has_died := node.get("has_died")
	if has_died != null and bool(has_died):
		return true
	var hp := node.get("hp")
	return hp != null and int(hp) <= 0


func _is_vulnerable(target: Node) -> bool:
	return is_instance_valid(target) and float(target.get_meta("_tech_vulnerable_until", 0.0)) > _now()


func _is_genuine_backstab(target: Node, player: Node) -> bool:
	if not (target is Node2D) or not (player is Node2D):
		return false
	var to_player := (player as Node2D).global_position - (target as Node2D).global_position
	if to_player.length_squared() <= 0.001:
		return false
	var facing := Vector2.RIGHT
	if target is CharacterBody2D and (target as CharacterBody2D).velocity.length() > 12.0:
		facing = (target as CharacterBody2D).velocity.normalized()
	else:
		var visual: Node = target.get_node_or_null("Sprite2D")
		if visual == null:
			visual = target.get_node_or_null("Sprite")
		if visual is Sprite2D:
			facing = Vector2.LEFT if (visual as Sprite2D).flip_h else Vector2.RIGHT
		elif visual is AnimatedSprite2D:
			facing = Vector2.LEFT if (visual as AnimatedSprite2D).flip_h else Vector2.RIGHT
	return facing.normalized().dot(to_player.normalized()) <= -0.45


func _trigger_for_attack_id(attack_id: String) -> String:
	match attack_id:
		"quick_slash", "cross_cut", "heavy_cleave":
			return "basic"
		"hold_thrust", "thrust":
			return "held"
		"dash_slash":
			return "dash"
		"counter_cut":
			return "counter"
		_:
			if attack_id.begins_with("combo_"):
				return "basic"
	return ""


func _player_in_deathblow_state(player: Node) -> bool:
	if not is_instance_valid(player) or not player.has_method("get_playtest_snapshot"):
		return false
	var snapshot: Dictionary = player.call("get_playtest_snapshot")
	return str(snapshot.get("state", "")) == "DEATHBLOW"


func _player_is_unseen(player: Node) -> bool:
	return is_instance_valid(player) and bool(player.get_meta("_tech_unseen_active", false)) and float(player.get_meta("_tech_unseen_until", 0.0)) > _now()


func _acquired() -> Array:
	if typeof(RunData) == TYPE_OBJECT and RunData.has_method("get_acquired_upgrades"):
		return RunData.get_acquired_upgrades()
	return []


func _now() -> float:
	return Time.get_ticks_msec() * 0.001


# =============================================================================
# READABILITY / TELEMETRY
# =============================================================================

func _update_indicator(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var label := target.get_node_or_null("TechniqueStatus") as Label
	var rupture := float(target.get_meta("_tech_rupture", 0.0))
	var seals := int(target.get_meta("_tech_seal_count", 0))
	var bound := float(target.get_meta("_tech_bound_until", 0.0)) > _now()
	var rift := int(target.get_meta("_tech_rift_intensity", 0))
	var vulnerable := _is_vulnerable(target)
	var parts: Array[String] = []
	if rupture > 0.0:
		parts.append("R:%d" % int(round(rupture)))
	if bound:
		parts.append("BIND")
	elif seals > 0:
		parts.append("S:%d" % seals)
	if rift > 0:
		parts.append("F:%d" % rift)
	if vulnerable:
		parts.append("VULN")

	if parts.is_empty():
		if label != null:
			label.queue_free()
		return
	if label == null:
		label = Label.new()
		label.name = "TechniqueStatus"
		label.position = INDICATOR_OFFSET
		label.z_index = 50
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		target.add_child(label)
	label.text = " | ".join(parts)
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color(1.0, 0.93, 0.78, 1.0))


func _pulse(target: Node, color: Color, text: String) -> void:
	if not is_instance_valid(target) or not (target is Node2D):
		return
	var label := Label.new()
	label.text = text
	label.position = Vector2(-22.0, -58.0)
	label.z_index = 60
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 11)
	label.add_theme_color_override("font_color", color)
	target.add_child(label)
	var tween := label.create_tween()
	tween.tween_property(label, "position", label.position + Vector2(0.0, -10.0), 0.22)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.22)
	tween.finished.connect(func():
		if is_instance_valid(label):
			label.queue_free()
	)


func _record(event_name: String, target: Node, data: Dictionary) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload := data.duplicate(true)
	payload["target_id"] = target.get_instance_id() if is_instance_valid(target) else 0
	payload["target_name"] = target.name if is_instance_valid(target) else "freed"
	CombatTelemetry.record_event("technique_%s" % event_name, payload)
