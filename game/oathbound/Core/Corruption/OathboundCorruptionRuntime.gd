extends Node

## Run-scoped Corruption + Shrine progression authority.
##
## docs/gameplay/CORRUPTION_AND_SHRINES.md owns the approved first-playtest values
## and state transitions. AspectRuntime remains the sole owner of Aspect Tier effects;
## this runtime only decides when a Shrine may call advance_tier().

signal corruption_changed(current: int, maximum: int, state: String)
signal shrine_ready_changed(ready: bool)
signal returning_blood_state_changed(awakened: bool)
signal shrine_resolved(action: String, result: Dictionary)

const CORRUPTION_MAX: int = 100
const NEAR_FULL_THRESHOLD: int = 80

const ENEMY_DEFEAT: int = 1
const ELITE_DEFEAT: int = 3
const SUCCESSFUL_PARRY: int = 1
const POSTURE_BREAK: int = 2
const DEATHBLOW: int = 3
const STANDARD_CLEAR: int = 4
const MINIBOSS_CLEAR: int = 10
const BOSS_CHECKPOINT: int = 5
const BOSS_DEFEAT: int = 10

const STANDARD_CAP: int = 16
const MINIBOSS_CAP: int = 24
const BOSS_CAP: int = 30
const PARRY_CHAMBER_CAP: int = 4

const SUPPORT_HEALTH: float = 0.20
const SUPPORT_SPIRIT: float = 0.25
const RESIST_HEALTH: float = 0.25
const RESIST_SPIRIT: float = 0.35
const STABILIZE_HEALTH: float = 0.30
const STABILIZE_SPIRIT: float = 0.40

const RESIST_CORRUPTION: int = 75
const STABILIZE_CORRUPTION: int = 50

const RUNTIME_VERSION: String = "corruption_runtime_v1"

var corruption: int = 0
var _encounter_kind: String = "none"
var _encounter_token: String = ""
var _encounter_awarded: int = 0
var _parry_credit_count: int = 0
var _boss_checkpoints_awarded: Dictionary = {}
var _tracked_enemies: Dictionary = {}
var _enemy_scan_accum: float = 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not get_tree().node_added.is_connected(_on_tree_node_added):
		get_tree().node_added.connect(_on_tree_node_added)
	call_deferred("_track_existing_enemies")
	_emit_state()
	print("[OathboundCorruptionRuntime] v1.0 - 0/100 run pressure + Shrine authority | awakened=%s" % str(is_awakened()))


func _process(delta: float) -> void:
	_enemy_scan_accum += delta
	if _enemy_scan_accum < 0.10:
		return
	_enemy_scan_accum = 0.0
	for id_value: Variant in _tracked_enemies.keys().duplicate():
		var instance_id: int = int(id_value)
		var weak_value: Variant = _tracked_enemies.get(instance_id)
		var enemy: Node = (weak_value as WeakRef).get_ref() if weak_value is WeakRef else null
		if enemy == null or not is_instance_valid(enemy):
			_tracked_enemies.erase(instance_id)
			continue
		if _enemy_is_dead(enemy):
			on_enemy_defeated(enemy)
			_tracked_enemies.erase(instance_id)


# =============================================================================
# CAMPAIGN / RUN STATE
# =============================================================================

func is_awakened() -> bool:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return true
	if MetaProgress.has_method("is_returning_blood_awakened"):
		return bool(MetaProgress.call("is_returning_blood_awakened"))
	return true


func awaken_returning_blood() -> bool:
	if is_awakened():
		return false
	var changed: bool = false
	if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_method("awaken_returning_blood"):
		changed = bool(MetaProgress.call("awaken_returning_blood"))
	returning_blood_state_changed.emit(true)
	_emit_state()
	_record("returning_blood_awakened", {"changed": changed})
	return changed


func on_new_run(_area_id: int = 1) -> void:
	corruption = 0
	_reset_encounter_state()
	_boss_checkpoints_awarded.clear()
	if is_awakened() and typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("reset_for_new_run"):
		AspectRuntime.call("reset_for_new_run")
	_emit_state()
	_record("corruption_run_reset", {"reason": "new_run", "awakened": is_awakened()})


func on_player_death() -> void:
	var was_awakened: bool = is_awakened()
	if not was_awakened:
		awaken_returning_blood()
	corruption = 0
	_reset_encounter_state()
	_boss_checkpoints_awarded.clear()
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("reset_for_new_run"):
		AspectRuntime.call("reset_for_new_run")
	_emit_state()
	_record("corruption_run_reset", {"reason": "death", "first_awakening": not was_awakened})


func on_successful_run_completed() -> void:
	corruption = 0
	_reset_encounter_state()
	_boss_checkpoints_awarded.clear()
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("reset_for_new_run"):
		AspectRuntime.call("reset_for_new_run")
	_emit_state()
	_record("corruption_run_reset", {"reason": "successful_run"})


func on_room_entered(room_token: String) -> void:
	_encounter_token = room_token
	_encounter_kind = _classify_room(room_token)
	_encounter_awarded = 0
	_parry_credit_count = 0
	_boss_checkpoints_awarded.clear()
	_record("corruption_encounter_started", {
		"room": room_token,
		"kind": _encounter_kind,
		"corruption": corruption,
	})


func get_corruption() -> int:
	return corruption


func get_corruption_state() -> String:
	if not is_awakened():
		return "hidden"
	if corruption >= CORRUPTION_MAX:
		return "full"
	if corruption >= NEAR_FULL_THRESHOLD:
		return "near-full"
	if corruption <= 0:
		return "empty"
	return "filling"


func is_shrine_ready() -> bool:
	return is_awakened() and corruption >= CORRUPTION_MAX


func set_corruption_for_playtest(value: int) -> void:
	corruption = clampi(value, 0, CORRUPTION_MAX)
	_emit_state()


# =============================================================================
# APPROVED CORRUPTION CREDIT EVENTS
# =============================================================================

func on_successful_parry() -> int:
	if _parry_credit_count >= PARRY_CHAMBER_CAP:
		return 0
	var awarded: int = _award(SUCCESSFUL_PARRY, "successful_parry")
	if awarded > 0:
		_parry_credit_count += 1
	return awarded


func on_posture_broken(enemy: Node) -> int:
	if not _enemy_credit_eligible(enemy):
		return 0
	if bool(enemy.get_meta("_corruption_posture_break_credit", false)):
		return 0
	enemy.set_meta("_corruption_posture_break_credit", true)
	return _award(POSTURE_BREAK, "first_posture_break", enemy)


func on_deathblow(enemy: Node = null) -> int:
	if enemy != null:
		if not _enemy_credit_eligible(enemy):
			return 0
		if bool(enemy.get_meta("_corruption_deathblow_credit", false)):
			return 0
		enemy.set_meta("_corruption_deathblow_credit", true)
	return _award(DEATHBLOW, "deathblow", enemy)


func on_enemy_defeated(enemy: Node) -> int:
	if not _enemy_credit_eligible(enemy):
		return 0
	if bool(enemy.get_meta("_corruption_defeat_credit", false)):
		return 0
	enemy.set_meta("_corruption_defeat_credit", true)
	var amount: int = ELITE_DEFEAT if _enemy_is_elite(enemy) else ENEMY_DEFEAT
	return _award(amount, "elite_defeated" if amount == ELITE_DEFEAT else "enemy_defeated", enemy)


func on_room_cleared(room_token: String) -> int:
	var kind: String = _classify_room(room_token)
	match kind:
		"combat":
			return _award(STANDARD_CLEAR, "standard_combat_clear")
		"miniboss":
			return _award(MINIBOSS_CLEAR, "miniboss_clear")
		"boss":
			return _award(BOSS_DEFEAT, "regional_boss_defeat")
	return 0


func award_boss_checkpoint(checkpoint_id: String) -> int:
	if checkpoint_id.is_empty() or _encounter_kind != "boss":
		return 0
	if _boss_checkpoints_awarded.has(checkpoint_id):
		return 0
	_boss_checkpoints_awarded[checkpoint_id] = true
	return _award(BOSS_CHECKPOINT, "regional_boss_checkpoint", null, {"checkpoint": checkpoint_id})


func refresh_enemy_phase_credit(enemy: Node, refresh_posture_break: bool = true, refresh_deathblow: bool = true) -> void:
	# Authored boss phases may explicitly call this only when a phase is a genuine new
	# combat state. Ordinary enemies never refresh these once-per-life credits.
	if enemy == null or not is_instance_valid(enemy):
		return
	if refresh_posture_break and enemy.has_meta("_corruption_posture_break_credit"):
		enemy.remove_meta("_corruption_posture_break_credit")
	if refresh_deathblow and enemy.has_meta("_corruption_deathblow_credit"):
		enemy.remove_meta("_corruption_deathblow_credit")


# =============================================================================
# SHRINE STATE / RESOLUTION
# =============================================================================

func get_shrine_state() -> String:
	if not is_awakened():
		return "pre-awakening-support"
	if corruption < CORRUPTION_MAX:
		return "support"
	var tier: int = int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0
	if tier >= 4:
		return "stabilize"
	return "full-choice"


func resolve_shrine(action: String, player: Node) -> Dictionary:
	var state: String = get_shrine_state()
	var result: Dictionary = {
		"success": false,
		"action": action,
		"state": state,
		"health_restored": 0,
		"spirit_restored": 0,
		"corruption_before": corruption,
		"corruption_after": corruption,
		"tier_before": int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0,
		"tier_after": int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0,
	}

	match state:
		"pre-awakening-support", "support":
			if action != "support":
				return result
			var restored := _restore_resources(player, SUPPORT_HEALTH, SUPPORT_SPIRIT)
			result["health_restored"] = int(restored.get("health", 0))
			result["spirit_restored"] = int(restored.get("spirit", 0))
			result["success"] = true
		"full-choice":
			if action == "resist":
				corruption = RESIST_CORRUPTION
				var restored := _restore_resources(player, RESIST_HEALTH, RESIST_SPIRIT)
				result["health_restored"] = int(restored.get("health", 0))
				result["spirit_restored"] = int(restored.get("spirit", 0))
				result["success"] = true
			elif action == "embrace":
				if typeof(AspectRuntime) != TYPE_OBJECT or not AspectRuntime.has_method("advance_tier"):
					return result
				if not bool(AspectRuntime.call("advance_tier")):
					return result
				corruption = 0
				result["success"] = true
		"stabilize":
			if action != "stabilize":
				return result
			corruption = STABILIZE_CORRUPTION
			var restored := _restore_resources(player, STABILIZE_HEALTH, STABILIZE_SPIRIT)
			result["health_restored"] = int(restored.get("health", 0))
			result["spirit_restored"] = int(restored.get("spirit", 0))
			result["success"] = true

	if not bool(result.get("success", false)):
		return result
	result["corruption_after"] = corruption
	result["tier_after"] = int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else int(result.get("tier_before", 0))
	_emit_state()
	shrine_resolved.emit(action, result)
	_record("shrine_resolved", result)
	return result


func get_current_tier_headline() -> String:
	if not is_awakened() or typeof(AspectRuntime) != TYPE_OBJECT:
		return ""
	return get_tier_headline(str(AspectRuntime.selected_aspect), int(AspectRuntime.tier))


func get_next_tier_headline() -> String:
	if not is_awakened() or typeof(AspectRuntime) != TYPE_OBJECT:
		return ""
	var tier: int = int(AspectRuntime.tier)
	if tier >= 4:
		return "Maximum Tier reached"
	return get_tier_headline(str(AspectRuntime.selected_aspect), tier + 1)


func get_tier_headline(aspect: String, tier: int) -> String:
	var normalized: String = aspect.to_lower()
	var headlines: Dictionary = {
		"wolf": [
			"Tier 0 — complete Wolf pursuit kit",
			"Tier I — Blood Tempo recovery cancels + Feral Momentum",
			"Tier II — Blood Hunt / Blood Fang; Blood meter and Blood Art available",
			"Tier III — Fanged Guard during qualifying commitments",
			"Tier IV — Apex Mauling primary-target payoff",
		],
		"wraith": [
			"Tier 0 — complete Wraith reach/control kit",
			"Tier I — Pale Barrage + Spectral Edge",
			"Tier II — Wraith's Reach; Blood meter and Blood Art available",
			"Tier III — Spectral Passage through additional ordinary enemies",
			"Tier IV — Beyond the Veil reach + Veilstride",
		],
		"ronin": [
			"Tier 0 — complete Ronin commitment/guard kit",
			"Tier I — Reprisal Cut + increased maximum posture",
			"Tier II — Falling Mountain / Deep Rupture; Blood meter and Blood Art available",
			"Tier III — Measured Weight / Perfect Weight + Unbroken Resolve",
			"Tier IV — Shattering Wake",
		],
	}
	var values_value: Variant = headlines.get(normalized, [])
	if not (values_value is Array) or (values_value as Array).is_empty():
		return "Tier %d" % tier
	var values: Array = values_value as Array
	return str(values[clampi(tier, 0, values.size() - 1)])


# =============================================================================
# ENEMY PROGRESSION-CREDIT TRACKING
# =============================================================================

func _on_tree_node_added(node: Node) -> void:
	if node == null:
		return
	call_deferred("_try_track_enemy_id", node.get_instance_id())


func _track_existing_enemies() -> void:
	for group_name: String in ["enemy", "miniboss", "elite"]:
		for enemy: Node in get_tree().get_nodes_in_group(group_name):
			_try_track_enemy(enemy)


func _try_track_enemy_id(instance_id: int) -> void:
	var object: Object = instance_from_id(instance_id)
	if object == null or not is_instance_valid(object) or not (object is Node):
		return
	_try_track_enemy(object as Node)


func _try_track_enemy(enemy: Node) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	if not enemy.is_in_group("enemy") and not enemy.is_in_group("miniboss") and not enemy.is_in_group("elite"):
		return
	var instance_id: int = enemy.get_instance_id()
	if _tracked_enemies.has(instance_id):
		return
	_tracked_enemies[instance_id] = weakref(enemy)

	var exit_cb := Callable(self, "_on_tracked_enemy_exiting").bind(instance_id)
	if not enemy.tree_exiting.is_connected(exit_cb):
		enemy.tree_exiting.connect(exit_cb, CONNECT_ONE_SHOT)

	var combat: Node = enemy.get_node_or_null("Combat")
	if combat != null and combat.has_signal("posture_broken"):
		var break_cb := Callable(self, "_on_tracked_enemy_posture_broken").bind(instance_id)
		if not combat.is_connected("posture_broken", break_cb):
			combat.connect("posture_broken", break_cb)


func _on_tracked_enemy_posture_broken(_duration_s: float, instance_id: int) -> void:
	var object: Object = instance_from_id(instance_id)
	if object is Node and is_instance_valid(object):
		on_posture_broken(object as Node)


func _on_tracked_enemy_exiting(instance_id: int) -> void:
	var object: Object = instance_from_id(instance_id)
	if object is Node and is_instance_valid(object):
		var enemy: Node = object as Node
		if _enemy_is_dead(enemy):
			on_enemy_defeated(enemy)
	_tracked_enemies.erase(instance_id)


func _enemy_credit_eligible(enemy: Node) -> bool:
	if enemy == null or not is_instance_valid(enemy):
		return false
	if enemy.has_meta("progression_credit_eligible") and not bool(enemy.get_meta("progression_credit_eligible")):
		return false
	if bool(enemy.get_meta("no_progression_credit", false)) or bool(enemy.get_meta("corruption_no_credit", false)):
		return false
	return true


func _enemy_is_elite(enemy: Node) -> bool:
	return enemy.is_in_group("elite") or enemy.is_in_group("miniboss") or bool(enemy.get_meta("progression_elite", false)) or bool(enemy.get_meta("corruption_elite", false))


func _enemy_is_dead(enemy: Node) -> bool:
	if enemy == null:
		return false
	if enemy.has_method("is_dead"):
		return bool(enemy.call("is_dead"))
	var has_died_value: Variant = enemy.get("has_died")
	if has_died_value != null and bool(has_died_value):
		return true
	var hp_value: Variant = enemy.get("hp")
	if hp_value != null and float(hp_value) <= 0.0:
		return true
	var combat: Node = enemy.get_node_or_null("Combat")
	if combat != null and combat.has_method("is_dead"):
		return bool(combat.call("is_dead"))
	return false


# =============================================================================
# INTERNAL HELPERS
# =============================================================================

func _award(amount: int, source: String, enemy: Node = null, extra: Dictionary = {}) -> int:
	if amount <= 0 or not is_awakened() or corruption >= CORRUPTION_MAX:
		return 0
	var encounter_cap: int = _encounter_cap()
	if encounter_cap <= 0:
		return 0
	var cap_remaining: int = maxi(0, encounter_cap - _encounter_awarded)
	if cap_remaining <= 0:
		return 0
	var actual: int = mini(mini(amount, cap_remaining), CORRUPTION_MAX - corruption)
	if actual <= 0:
		return 0
	var was_ready: bool = is_shrine_ready()
	corruption += actual
	_encounter_awarded += actual
	_emit_state()
	var payload: Dictionary = extra.duplicate(true)
	payload["source"] = source
	payload["requested"] = amount
	payload["awarded"] = actual
	payload["total"] = corruption
	payload["encounter_awarded"] = _encounter_awarded
	payload["encounter_cap"] = encounter_cap
	payload["room"] = _encounter_token
	payload["kind"] = _encounter_kind
	payload["enemy_id"] = enemy.get_instance_id() if enemy != null and is_instance_valid(enemy) else 0
	_record("corruption_gain", payload)
	if not was_ready and is_shrine_ready():
		_record("corruption_shrine_ready", {"room": _encounter_token, "kind": _encounter_kind})
	return actual


func _encounter_cap() -> int:
	match _encounter_kind:
		"combat": return STANDARD_CAP
		"miniboss": return MINIBOSS_CAP
		"boss": return BOSS_CAP
	return 0


func _classify_room(room_token: String) -> String:
	if room_token.is_empty():
		return "none"
	var base_key: String = room_token.to_lower()
	if typeof(RouteGenerator) == TYPE_OBJECT and RouteGenerator.has_method("get_base_room_type"):
		base_key = str(RouteGenerator.call("get_base_room_type", room_token)).to_lower()
	if base_key in ["combat", "miniboss", "boss"]:
		return base_key
	return "none"


func _restore_resources(player: Node, health_fraction: float, spirit_fraction: float) -> Dictionary:
	var restored_health: int = 0
	var restored_spirit: int = 0
	if player != null and is_instance_valid(player):
		var max_hp_value: Variant = player.get("maxhp")
		var hp_value: Variant = player.get("hp")
		if max_hp_value != null and hp_value != null:
			var max_hp: int = maxi(1, int(max_hp_value))
			var before_hp: int = clampi(int(hp_value), 0, max_hp)
			var requested_hp: int = maxi(0, int(round(float(max_hp) * health_fraction)))
			var after_hp: int = mini(max_hp, before_hp + requested_hp)
			restored_health = after_hp - before_hp
			player.set("hp", after_hp)
			if player.has_method("_update_health_bar"):
				player.call("_update_health_bar")

		var executor_value: Variant = player.get("prosthetic_executor")
		if executor_value is Node and is_instance_valid(executor_value):
			var executor: Node = executor_value as Node
			var spirit_max: int = int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else int(executor.get("max_spirit"))
			var spirit_before: int = int(executor.call("get_spirit")) if executor.has_method("get_spirit") else int(executor.get("current_spirit"))
			spirit_max = maxi(1, spirit_max)
			spirit_before = clampi(spirit_before, 0, spirit_max)
			var requested_spirit: int = maxi(0, int(round(float(spirit_max) * spirit_fraction)))
			var spirit_after: int = mini(spirit_max, spirit_before + requested_spirit)
			restored_spirit = spirit_after - spirit_before
			if restored_spirit > 0 and executor.has_method("add_spirit"):
				executor.call("add_spirit", restored_spirit)
	return {"health": restored_health, "spirit": restored_spirit}


func _reset_encounter_state() -> void:
	_encounter_kind = "none"
	_encounter_token = ""
	_encounter_awarded = 0
	_parry_credit_count = 0


func _emit_state() -> void:
	corruption = clampi(corruption, 0, CORRUPTION_MAX)
	corruption_changed.emit(corruption, CORRUPTION_MAX, get_corruption_state())
	shrine_ready_changed.emit(is_shrine_ready())


func _record(event_name: String, payload: Dictionary) -> void:
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event(event_name, payload)
