extends Node

## Run-scoped authority for the selected Blood Aspect, Tier, Blood meter, Blood Arts,
## shared Blood generation, and Tier effects that resolve after direct katana contact.

signal aspect_changed(aspect: String)
signal tier_changed(tier: int)
signal blood_changed(current: float, maximum: float, state: String)
signal blood_art_started(aspect: String)
signal blood_art_finished(aspect: String)

const CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const BLOOD_MAX := 100.0
const WRAITH_ECHO_DELAY := 0.48
const WRAITH_CORRIDOR_LENGTH := 360.0
const WRAITH_CORRIDOR_HALF_WIDTH := 34.0
const RONIN_RUPTURE_DELAY := 3.0
const RONIN_RUPTURE_RADIUS := 78.0

var selected_aspect: String = CATALOG.WOLF
var tier: int = 0
var blood: float = 0.0
var blood_art_resolving: bool = false

var _blood_actions: Dictionary = {}
var _passage_actions: Dictionary = {}
var _counter_bonus_tokens: Dictionary = {}
var _hud: CanvasLayer = null
var _hud_label: Label = null

func _ready() -> void:
	call_deferred("_build_hud")
	_emit_state()
	print("[AspectRuntime] v1.0 - Wolf/Wraith/Ronin runtime")

func _process(_delta: float) -> void:
	_cleanup_action_cache()
	_refresh_hud()

# =============================================================================
# RUN STATE
# =============================================================================

func select_aspect(aspect: String) -> bool:
	var normalized: String = aspect.to_lower()
	if normalized not in CATALOG.ASPECTS:
		return false
	selected_aspect = normalized
	tier = 0
	blood = 0.0
	blood_art_resolving = false
	_clear_contact_cache()
	_apply_to_live_player()
	aspect_changed.emit(selected_aspect)
	tier_changed.emit(tier)
	_emit_state()
	_record("aspect_selected", {"aspect": selected_aspect})
	return true

func set_tier(value: int) -> void:
	tier = clampi(value, 0, 4)
	if tier < 2:
		blood = 0.0
		blood_art_resolving = false
	_apply_to_live_player()
	tier_changed.emit(tier)
	_emit_state()
	_record("aspect_tier_changed", {"aspect": selected_aspect, "tier": tier})

func advance_tier() -> bool:
	if tier >= 4:
		return false
	set_tier(tier + 1)
	return true

func reset_for_new_run() -> void:
	tier = 0
	blood = 0.0
	blood_art_resolving = false
	_clear_contact_cache()
	_apply_to_live_player()
	tier_changed.emit(tier)
	_emit_state()

func set_blood_for_playtest(value: float) -> void:
	if tier < 2:
		blood = 0.0
	else:
		blood = clampf(value, 0.0, BLOOD_MAX)
	_emit_state()

func is_blood_unlocked() -> bool:
	return tier >= 2

func is_blood_ready() -> bool:
	return tier >= 2 and blood >= BLOOD_MAX - 0.001 and not blood_art_resolving

func blood_state() -> String:
	if tier < 2:
		return "unavailable"
	if blood_art_resolving:
		return "resolving"
	if blood >= BLOOD_MAX - 0.001:
		return "ready"
	if blood >= 80.0:
		return "near-ready"
	if blood <= 0.001:
		return "empty"
	return "building"

func add_blood(amount: float, source: String = "combat") -> void:
	if amount <= 0.0 or tier < 2 or blood_art_resolving:
		return
	var before: float = blood
	blood = minf(BLOOD_MAX, blood + amount)
	if blood > before:
		_emit_state()
		_record("blood_gain", {"amount": blood - before, "source": source, "total": blood})

func commit_blood_art() -> bool:
	if not is_blood_ready():
		return false
	blood = 0.0
	blood_art_resolving = true
	blood_art_started.emit(selected_aspect)
	_emit_state()
	_record("blood_art_started", {"aspect": selected_aspect, "tier": tier})
	return true

func finish_blood_art() -> void:
	if not blood_art_resolving:
		return
	blood_art_resolving = false
	blood_art_finished.emit(selected_aspect)
	_emit_state()
	_record("blood_art_finished", {"aspect": selected_aspect, "tier": tier})

func record_deathblow() -> void:
	add_blood(6.0, "deathblow")

# =============================================================================
# DIRECT SWORD CONTACT TRANSFORM
# =============================================================================

func transform_sword_contact(area: Area2D, target: Node, attacker: Node, event: Dictionary) -> Dictionary:
	var out: Dictionary = event.duplicate(true)
	if not _is_current_player_sword(area, attacker):
		return out
	if selected_aspect != CATALOG.WRAITH or tier < 3 or not bool(area.get_meta("aspect_passage", false)):
		return out

	var token: String = str(area.get_meta("swing_token", "%d" % area.get_instance_id()))
	var data: Dictionary = _passage_actions.get(token, {"targets": []})
	var target_id: int = target.get_instance_id() if is_instance_valid(target) else 0
	if target_id in data["targets"]:
		return out
	var index: int = int(data["targets"].size())
	data["targets"].append(target_id)
	data["time"] = Time.get_ticks_msec() * 0.001
	_passage_actions[token] = data

	if index <= 0:
		return out
	if target.is_in_group("miniboss") or bool(target.get_meta("aspect_heavy_stopper", false)):
		return out

	out["health_damage"] = int(round(float(out.get("health_damage", 0)) * 0.60))
	out["posture_damage"] = float(out.get("posture_damage", 0.0)) * 0.75
	out["block_posture_damage"] = float(out.get("block_posture_damage", 0.0)) * 0.75
	out["aspect_secondary_contact"] = true
	return out

func record_sword_contact(target: Node, area: Area2D, attacker: Node, before_hp: float, before_posture: float) -> void:
	if not _is_current_player_sword(area, attacker) or not is_instance_valid(target):
		return
	var after_hp: float = _read_hp(target)
	var after_posture: float = _read_posture(target)
	var actual_health: float = maxf(0.0, before_hp - after_hp)
	var actual_posture: float = maxf(0.0, after_posture - before_posture)
	var trigger: String = str(area.get_meta("action_trigger", ""))
	var attack_id: String = str(area.get_meta("attack_id", ""))

	# Wraith Spectral Edge is direct posture/guard pressure from the originating katana
	# action and therefore contributes to Blood like other direct Aspect-owned pressure.
	var spectral_bonus: float = _apply_wraith_spectral_edge(target, area, attacker, attack_id)
	actual_posture += spectral_bonus

	if bool(area.get_meta("blood_generation", true)) and not bool(area.get_meta("aspect_secondary_contact", false)):
		_record_damage_blood(area, target, actual_health, actual_posture)
	elif bool(area.get_meta("blood_generation", true)):
		_record_damage_blood(area, target, actual_health, actual_posture, true)

	var token: String = str(area.get_meta("swing_token", "%d" % area.get_instance_id()))
	if trigger == "counter" and not _counter_bonus_tokens.has(token):
		_counter_bonus_tokens[token] = Time.get_ticks_msec() * 0.001
		add_blood(2.0, "parry_counter")

	var posture_max: float = _read_posture_max(target)
	if before_posture < posture_max - 0.001 and after_posture >= posture_max - 0.001:
		add_blood(4.0, "enemy_posture_break")

	_apply_post_contact_tier_effects(target, area, attacker, attack_id)

func _record_damage_blood(area: Area2D, target: Node, health: float, posture: float, forced_secondary: bool = false) -> void:
	if health <= 0.0 and posture <= 0.0:
		return
	var raw: float = (health * 0.035 + posture * 0.015) * CATALOG.blood_multiplier(selected_aspect)
	if raw <= 0.0:
		return
	var token: String = str(area.get_meta("swing_token", "%d" % area.get_instance_id()))
	var data: Dictionary = _blood_actions.get(token, {"targets": [], "primary": 0.0, "awarded": 0.0, "time": 0.0})
	var target_id: int = target.get_instance_id()
	if target_id in data["targets"]:
		return
	var secondary: bool = forced_secondary or not data["targets"].is_empty()
	data["targets"].append(target_id)
	if not secondary:
		data["primary"] = raw
	var scaled: float = raw * (0.35 if secondary else 1.0)
	var cap: float = maxf(raw, float(data.get("primary", raw))) * 1.5
	var room: float = maxf(0.0, cap - float(data.get("awarded", 0.0)))
	var award: float = minf(scaled, room)
	data["awarded"] = float(data.get("awarded", 0.0)) + award
	data["time"] = Time.get_ticks_msec() * 0.001
	_blood_actions[token] = data
	add_blood(award, "direct_katana")

# =============================================================================
# TIER CONTACT EFFECTS
# =============================================================================

func _apply_wraith_spectral_edge(target: Node, area: Area2D, attacker: Node, attack_id: String) -> float:
	if selected_aspect != CATALOG.WRAITH or tier < 1 or not bool(area.get_meta("spectral_edge", false)):
		return 0.0
	if tier < 4 and attack_id in ["wraith_pale_lance", "wraith_ghostline_slash"]:
		return 0.0
	if not (target is Node2D) or not (attacker is Node2D):
		return 0.0
	var min_range: float = float(area.get_meta("spectral_min_range", 0.0))
	if min_range <= 0.0 or (target as Node2D).global_position.distance_to((attacker as Node2D).global_position) < min_range:
		return 0.0
	var pct: float = float([0.0, 0.15, 0.20, 0.25, 0.30][clampi(tier, 0, 4)])
	var base_posture: float = float(area.get_meta("posture_damage", 0.0))
	var bonus: float = base_posture * pct
	_apply_posture(target, bonus, "spectral_edge")
	_record("spectral_edge", {"target": target.get_instance_id(), "bonus_posture": bonus, "tier": tier})
	return bonus

func _apply_post_contact_tier_effects(target: Node, area: Area2D, attacker: Node, attack_id: String) -> void:
	if selected_aspect == CATALOG.WOLF and tier >= 4 and attack_id in ["wolf_blood_cleave", "wolf_predators_passage", "wolf_fang_reversal", "wolf_blood_fang"]:
		_apply_health(target, 18, "apex_mauling")
		_apply_posture(target, 26.0, "apex_mauling")
		target.set_meta("_aspect_slow_until", Time.get_ticks_msec() * 0.001 + 1.5)
		target.set_meta("_aspect_slow_mult", 0.80)
		for enemy in _nearby_enemies(_position(target), target, 72.0, 2):
			_apply_health(enemy, 7, "apex_mauling_secondary")
			_apply_posture(enemy, 12.0, "apex_mauling_secondary")
		_record("apex_mauling", {"target": target.get_instance_id()})

	if selected_aspect == CATALOG.RONIN and tier >= 4 and attack_id in ["ronin_bloodfall", "ronin_stillness_draw", "ronin_answering_steel", "ronin_reprisal_cut", "ronin_falling_mountain"]:
		_apply_shattering_wake(target, area, attacker)

func _apply_shattering_wake(primary: Node, area: Area2D, attacker: Node) -> void:
	if not (primary is Node2D) or not (attacker is Node2D):
		return
	var direction: Vector2 = ((primary as Node2D).global_position - (attacker as Node2D).global_position).normalized()
	if direction.length_squared() <= 0.001:
		return
	var origin: Vector2 = (primary as Node2D).global_position
	var source_health: int = int(area.get_meta("health_damage", 0))
	var source_posture: float = float(area.get_meta("posture_damage", 0.0))
	for enemy in _enemy_nodes():
		if enemy == primary or not (enemy is Node2D) or _is_dead(enemy):
			continue
		var offset: Vector2 = (enemy as Node2D).global_position - origin
		var dist: float = offset.length()
		if dist <= 1.0 or dist > 120.0 or direction.dot(offset.normalized()) < 0.72:
			continue
		_apply_health(enemy, int(round(source_health * 0.50)), "shattering_wake")
		_apply_posture(enemy, source_posture * 0.80, "shattering_wake")
	_record("shattering_wake", {"primary": primary.get_instance_id()})

# =============================================================================
# BLOOD ART HELPERS
# =============================================================================

func begin_wolf_blood_hunt(player: Node) -> void:
	if not is_instance_valid(player):
		return
	if player.has_method("heal"):
		player.call("heal", 15)
	for enemy in _nearby_enemies(_position(player), null, 100.0, 8):
		_apply_posture(enemy, 14.0, "blood_hunt_howl")
	_record("wolf_blood_hunt_howl", {})

func resolve_wolf_blood_fang(player: Node, direction: Vector2) -> void:
	if not is_instance_valid(player):
		finish_blood_art()
		return
	var target: Node = _nearest_enemy(_position(player), null, 62.0)
	if target != null:
		_apply_health(target, 36, "wolf_blood_fang")
		_apply_posture(target, 40.0, "wolf_blood_fang")
		if tier >= 4:
			# Blood Fang is a qualifying Apex Mauling contact.
			_apply_health(target, 18, "apex_mauling")
			_apply_posture(target, 26.0, "apex_mauling")
	_record("wolf_blood_fang", {"direction": [direction.x, direction.y]})
	finish_blood_art()

func begin_wraith_reach(player: Node, direction: Vector2) -> void:
	if not is_instance_valid(player):
		return
	for enemy in _enemies_in_front(_position(player), direction, 105.0, 0.35):
		_apply_health(enemy, 8, "wraith_reach_sweep")
		_apply_posture(enemy, 22.0, "wraith_reach_sweep")
	var origin: Vector2 = _position(player)
	var fixed_direction: Vector2 = direction.normalized()
	get_tree().create_timer(WRAITH_ECHO_DELAY).timeout.connect(func():
		for enemy in _enemies_in_corridor(origin, fixed_direction, WRAITH_CORRIDOR_LENGTH, WRAITH_CORRIDOR_HALF_WIDTH):
			_apply_health(enemy, 14, "wraith_reach_echo")
			_apply_posture(enemy, 18.0, "wraith_reach_echo")
		_record("wraith_reach_echo", {"origin": [origin.x, origin.y], "direction": [fixed_direction.x, fixed_direction.y]})
		finish_blood_art()
	)

func begin_ronin_falling_mountain(player: Node) -> void:
	if not is_instance_valid(player):
		return
	var current_posture: float = float(player.get("stagger")) if player.get("stagger") != null else 0.0
	player.set("stagger", maxf(0.0, current_posture - 35.0))
	_record("ronin_falling_mountain_posture_clear", {"before": current_posture, "after": float(player.get("stagger"))})

func resolve_ronin_falling_mountain(impact: Vector2) -> void:
	for enemy in _nearby_enemies(impact, null, 92.0, 6):
		_apply_health(enemy, 12, "falling_mountain_impact")
		_apply_posture(enemy, 18.0, "falling_mountain_impact")
	get_tree().create_timer(RONIN_RUPTURE_DELAY).timeout.connect(func():
		for enemy in _nearby_enemies(impact, null, RONIN_RUPTURE_RADIUS, 6):
			_apply_health(enemy, 28, "deep_rupture")
			_apply_posture(enemy, 40.0, "deep_rupture")
		_record("deep_rupture", {"position": [impact.x, impact.y]})
		finish_blood_art()
	)

func start_veilstride(player: Node) -> void:
	if selected_aspect != CATALOG.WRAITH or tier < 4 or not is_instance_valid(player):
		return
	player.set_meta("_aspect_veilstride_until", Time.get_ticks_msec() * 0.001 + 2.0)
	_record("veilstride", {"duration": 2.0})

# =============================================================================
# QUERIES / HELPERS
# =============================================================================

func _is_current_player_sword(area: Area2D, attacker: Node) -> bool:
	if area == null or attacker == null or not is_instance_valid(attacker):
		return false
	if not attacker.is_in_group("player") or area.has_meta("prosthetic_source"):
		return false
	return area.has_meta("attack_id")

func _apply_to_live_player() -> void:
	var player: Node = get_tree().get_first_node_in_group("player")
	if player != null and player.has_method("apply_aspect_configuration"):
		player.call_deferred("apply_aspect_configuration")

func _emit_state() -> void:
	blood_changed.emit(blood, BLOOD_MAX, blood_state())
	_refresh_hud()

func _clear_contact_cache() -> void:
	_blood_actions.clear()
	_passage_actions.clear()
	_counter_bonus_tokens.clear()

func _cleanup_action_cache() -> void:
	var now: float = Time.get_ticks_msec() * 0.001
	for table in [_blood_actions, _passage_actions, _counter_bonus_tokens]:
		for key in table.keys():
			var value = table[key]
			var timestamp: float = float(value.get("time", 0.0)) if value is Dictionary else float(value)
			if now - timestamp > 3.0:
				table.erase(key)

func _read_hp(target: Node) -> float:
	var value = target.get("hp")
	return float(value) if value != null else 0.0

func _read_posture(target: Node) -> float:
	var combat: Node = target.get_node_or_null("Combat")
	if combat != null and combat.get("posture") != null:
		return float(combat.get("posture"))
	var value = target.get("stagger")
	return float(value) if value != null else 0.0

func _read_posture_max(target: Node) -> float:
	var combat: Node = target.get_node_or_null("Combat")
	if combat != null and combat.get("max_posture") != null:
		return maxf(1.0, float(combat.get("max_posture")))
	var value = target.get("stagger_max")
	return maxf(1.0, float(value)) if value != null else 100.0

func _apply_health(target: Node, amount: int, source: String) -> void:
	if not is_instance_valid(target) or amount <= 0 or _is_dead(target):
		return
	if target.has_method("apply_hp_damage"):
		target.call("apply_hp_damage", amount)
	elif target.get("hp") != null:
		target.set("hp", maxi(0, int(target.get("hp")) - amount))
	if target.has_method("show_enemy_damage_number"):
		target.call("show_enemy_damage_number", amount, "aspect", -31.0)
	if target.get("hp") != null and int(target.get("hp")) <= 0 and target.has_method("death"):
		target.call_deferred("death")
	_record("aspect_health_damage", {"source": source, "amount": amount, "target": target.get_instance_id()})

func _apply_posture(target: Node, amount: float, source: String) -> void:
	if not is_instance_valid(target) or amount <= 0.0 or _is_dead(target):
		return
	if target.has_method("add_posture_damage"):
		target.call("add_posture_damage", amount)
	else:
		var combat: Node = target.get_node_or_null("Combat")
		if combat != null and combat.has_method("add_posture"):
			combat.call("add_posture", amount)
	_record("aspect_posture_damage", {"source": source, "amount": amount, "target": target.get_instance_id()})

func _enemy_nodes() -> Array[Node]:
	var out: Array[Node] = []
	for group_name in ["enemy", "miniboss"]:
		for node in get_tree().get_nodes_in_group(group_name):
			if is_instance_valid(node) and node not in out:
				out.append(node)
	return out

func _nearby_enemies(position: Vector2, exclude: Node, radius: float, limit: int) -> Array[Node]:
	var out: Array[Node] = []
	for enemy in _enemy_nodes():
		if enemy == exclude or not (enemy is Node2D) or _is_dead(enemy):
			continue
		if (enemy as Node2D).global_position.distance_to(position) <= radius:
			out.append(enemy)
	out.sort_custom(func(a: Node, b: Node) -> bool:
		return (a as Node2D).global_position.distance_to(position) < (b as Node2D).global_position.distance_to(position)
	)
	if limit > 0 and out.size() > limit:
		out.resize(limit)
	return out

func _nearest_enemy(position: Vector2, exclude: Node, radius: float) -> Node:
	var out: Array[Node] = _nearby_enemies(position, exclude, radius, 1)
	return out[0] if not out.is_empty() else null

func _enemies_in_front(origin: Vector2, direction: Vector2, radius: float, min_dot: float) -> Array[Node]:
	var out: Array[Node] = []
	var facing: Vector2 = direction.normalized()
	for enemy in _nearby_enemies(origin, null, radius, 12):
		var offset: Vector2 = _position(enemy) - origin
		if offset.length_squared() > 0.001 and facing.dot(offset.normalized()) >= min_dot:
			out.append(enemy)
	return out

func _enemies_in_corridor(origin: Vector2, direction: Vector2, length: float, half_width: float) -> Array[Node]:
	var out: Array[Node] = []
	var axis: Vector2 = direction.normalized()
	var perpendicular: Vector2 = axis.orthogonal()
	for enemy in _enemy_nodes():
		if not (enemy is Node2D) or _is_dead(enemy):
			continue
		var offset: Vector2 = _position(enemy) - origin
		var forward: float = axis.dot(offset)
		var lateral: float = absf(perpendicular.dot(offset))
		if forward >= 0.0 and forward <= length and lateral <= half_width:
			out.append(enemy)
	return out

func _position(node: Node) -> Vector2:
	return (node as Node2D).global_position if node is Node2D else Vector2.ZERO

func _is_dead(node: Node) -> bool:
	if not is_instance_valid(node):
		return true
	if node.has_method("is_dead"):
		return bool(node.call("is_dead"))
	if node.get("has_died") != null and bool(node.get("has_died")):
		return true
	return node.get("hp") != null and int(node.get("hp")) <= 0

# =============================================================================
# MINIMAL HUD / TELEMETRY
# =============================================================================

func _build_hud() -> void:
	if _hud != null:
		return
	_hud = CanvasLayer.new()
	_hud.name = "AspectHUD"
	_hud.layer = 90
	add_child(_hud)
	_hud_label = Label.new()
	_hud_label.position = Vector2(16, 78)
	_hud_label.z_index = 90
	_hud_label.add_theme_font_size_override("font_size", 13)
	_hud_label.add_theme_color_override("font_color", Color(0.95, 0.82, 0.72, 1.0))
	_hud.add_child(_hud_label)
	_refresh_hud()

func _refresh_hud() -> void:
	if _hud_label == null:
		return
	var aspect_name: String = selected_aspect.capitalize()
	if tier < 2:
		_hud_label.text = "%s  T%d | Blood: locked" % [aspect_name, tier]
	else:
		_hud_label.text = "%s  T%d | Blood: %d/100 [%s]" % [aspect_name, tier, int(round(blood)), blood_state()]

func _record(event_name: String, data: Dictionary) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var payload: Dictionary = data.duplicate(true)
	payload["aspect"] = selected_aspect
	payload["tier"] = tier
	payload["blood"] = blood
	CombatTelemetry.record_event("aspect_%s" % event_name, payload)
