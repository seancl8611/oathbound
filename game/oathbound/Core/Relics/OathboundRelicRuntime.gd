extends Node

## Current Relic persistence + runtime authority.
##
## RELICS.md owns the one-slot collection/mastery model and the ten launch effects.
## Numeric mastery thresholds/improvements remain first-playtest tuning in RelicCatalog.
## Acquisition-source identity assignment (which exact 4/2/4 Relics belong to campaign,
## challenge, and run-discovery sources) remains intentionally data-driven because the
## approved design defers those identities to content sequencing.

signal collection_changed
signal equipped_changed(relic_id: String)
signal mastery_changed(relic_id: String, kills: int, rank: int)
signal relic_discovered(relic_id: String)
signal relic_effect_triggered(relic_id: String, effect: String, amount: float)

const CATALOG = preload("res://Core/Relics/RelicCatalog.gd")
const SAVE_PATH: String = "user://oathbound_relic_progress.cfg"
const SAVE_SECTION: String = "relics"
const RUNTIME_VERSION: String = "relic_runtime_v1"

const EQUIP_CONTEXT_FORGE: String = "forge"
const EQUIP_CONTEXT_KEEPER_TRANSITION: String = "keeper_transition"
const EQUIP_CONTEXT_TWIN_TRANSITION: String = "twin_transition"
const EQUIP_CONTEXT_DISCOVERY: String = "discovery"
const ALLOWED_EQUIP_CONTEXTS: Array[String] = [
	EQUIP_CONTEXT_FORGE,
	EQUIP_CONTEXT_KEEPER_TRANSITION,
	EQUIP_CONTEXT_TWIN_TRANSITION,
	EQUIP_CONTEXT_DISCOVERY,
]

var unlocked_relics: Dictionary = {}
var mastery_kills: Dictionary = {}
var equipped_relic_id: String = ""

var _last_oath_used: bool = false
var _merchant_discount_used_by_area: Dictionary = {}
var _scribe_uses_by_area: Dictionary = {}
var _room_health_damage_taken: bool = false
var _tracked_enemies: Dictionary = {}
var _enemy_scan_accum: float = 0.0


func _ready() -> void:
	_load_progress()
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not get_tree().node_added.is_connected(_on_tree_node_added):
		get_tree().node_added.connect(_on_tree_node_added)
	call_deferred("_track_existing_enemies")
	print("[OathboundRelicRuntime] v1.0 - one-slot persistent Relic runtime | unlocked=%d equipped=%s" % [
		unlocked_relics.size(), equipped_relic_id if not equipped_relic_id.is_empty() else "none",
	])


func _process(delta: float) -> void:
	_enemy_scan_accum += delta
	if _enemy_scan_accum < 0.10:
		return
	_enemy_scan_accum = 0.0
	for id_value: Variant in _tracked_enemies.keys().duplicate():
		var id: int = int(id_value)
		var wr_value: Variant = _tracked_enemies.get(id)
		var enemy: Node = (wr_value as WeakRef).get_ref() if wr_value is WeakRef else null
		if enemy == null or not is_instance_valid(enemy):
			_tracked_enemies.erase(id)
			continue
		if _enemy_is_dead(enemy):
			_record_enemy_kill_once(enemy)


# =============================================================================
# COLLECTION / MASTERY
# =============================================================================

func discover_relic(relic_id: String, equip_now: bool = false) -> bool:
	if not CATALOG.has(relic_id):
		return false
	var newly_discovered: bool = not unlocked_relics.has(relic_id)
	unlocked_relics[relic_id] = true
	if not mastery_kills.has(relic_id):
		mastery_kills[relic_id] = 0
	if equip_now:
		equip_relic(relic_id, EQUIP_CONTEXT_DISCOVERY)
	_save_progress()
	collection_changed.emit()
	if newly_discovered:
		relic_discovered.emit(relic_id)
		_record("relic_discovered", {"relic_id": relic_id, "equip_now": equip_now})
	return newly_discovered


func equip_relic(relic_id: String, context: String = EQUIP_CONTEXT_FORGE) -> bool:
	if relic_id.is_empty():
		equipped_relic_id = ""
		_save_progress()
		equipped_changed.emit("")
		return true
	if context not in ALLOWED_EQUIP_CONTEXTS:
		return false
	if not unlocked_relics.has(relic_id) or not CATALOG.has(relic_id):
		return false
	equipped_relic_id = relic_id
	_save_progress()
	equipped_changed.emit(relic_id)
	_record("relic_equipped", {"relic_id": relic_id, "context": context})
	return true


func is_unlocked(relic_id: String) -> bool:
	return unlocked_relics.has(relic_id)


func is_equipped(relic_id: String) -> bool:
	return not relic_id.is_empty() and equipped_relic_id == relic_id


func get_mastery_kills(relic_id: String) -> int:
	return maxi(0, int(mastery_kills.get(relic_id, 0)))


func get_mastery_rank(relic_id: String) -> int:
	return CATALOG.mastery_rank_for_kills(get_mastery_kills(relic_id))


func get_equipped_mastery_rank() -> int:
	return get_mastery_rank(equipped_relic_id) if not equipped_relic_id.is_empty() else 0


func get_effective_value(relic_id: String) -> float:
	return CATALOG.value_for_rank(relic_id, get_mastery_rank(relic_id))


func record_eligible_kill(enemy: Node = null) -> void:
	if equipped_relic_id.is_empty() or not unlocked_relics.has(equipped_relic_id):
		return
	var before_rank: int = get_mastery_rank(equipped_relic_id)
	var kills: int = get_mastery_kills(equipped_relic_id) + 1
	mastery_kills[equipped_relic_id] = kills
	var after_rank: int = get_mastery_rank(equipped_relic_id)
	_save_progress()
	mastery_changed.emit(equipped_relic_id, kills, after_rank)
	_record("relic_mastery_kill", {
		"relic_id": equipped_relic_id,
		"kills": kills,
		"rank": after_rank,
		"rank_advanced": after_rank > before_rank,
		"enemy_id": enemy.get_instance_id() if enemy != null and is_instance_valid(enemy) else 0,
	})


# =============================================================================
# RUN STATE / EFFECT API
# =============================================================================

func on_new_run(area_id: int = 1) -> void:
	_last_oath_used = false
	_merchant_discount_used_by_area.clear()
	_scribe_uses_by_area.clear()
	_room_health_damage_taken = false
	if is_equipped(CATALOG.TRAVELERS_COIN) and typeof(RunData) == TYPE_OBJECT:
		var amount: int = int(round(get_effective_value(CATALOG.TRAVELERS_COIN)))
		if amount > 0:
			RunData.add_gold(amount)
			_trigger(CATALOG.TRAVELERS_COIN, "starting_gold", float(amount), {"area_id": area_id})
	_record("relic_run_reset", {"equipped": equipped_relic_id, "area_id": area_id})


func apply_player_capacity(player: Node) -> void:
	if player == null or not is_instance_valid(player):
		return
	if is_equipped(CATALOG.IRON_PRAYER_BEAD):
		var hp_bonus: int = int(round(get_effective_value(CATALOG.IRON_PRAYER_BEAD)))
		if hp_bonus > 0 and "maxhp" in player and "hp" in player:
			player.set("maxhp", int(player.get("maxhp")) + hp_bonus)
			player.set("hp", int(player.get("hp")) + hp_bonus)
			if player.has_method("_update_health_bar"):
				player.call("_update_health_bar")
			_trigger(CATALOG.IRON_PRAYER_BEAD, "max_health", float(hp_bonus))

	if is_equipped(CATALOG.SPIRIT_TASSEL):
		var spirit_bonus: int = int(round(get_effective_value(CATALOG.SPIRIT_TASSEL)))
		var executor_value: Variant = player.get("prosthetic_executor")
		if spirit_bonus > 0 and executor_value is Node and is_instance_valid(executor_value):
			var executor: Node = executor_value as Node
			var current_max: int = int(executor.get("max_spirit")) if "max_spirit" in executor else 100
			var current_spirit: int = int(executor.call("get_spirit")) if executor.has_method("get_spirit") else current_max
			executor.set("max_spirit", current_max + spirit_bonus)
			executor.set("current_spirit", mini(current_max + spirit_bonus, current_spirit + spirit_bonus))
			if executor.has_signal("spirit_changed"):
				executor.emit_signal("spirit_changed", int(executor.get("current_spirit")), int(executor.get("max_spirit")))
			_trigger(CATALOG.SPIRIT_TASSEL, "max_spirit", float(spirit_bonus))


func on_room_entered(player: Node, area_id: int, room_token: String) -> void:
	_room_health_damage_taken = false
	if is_equipped(CATALOG.WAYFARERS_CHARM) and player != null and is_instance_valid(player):
		var heal_amount: int = int(round(get_effective_value(CATALOG.WAYFARERS_CHARM)))
		if heal_amount > 0:
			_heal_player(player, heal_amount)
			_trigger(CATALOG.WAYFARERS_CHARM, "room_entry_heal", float(heal_amount), {
				"area_id": area_id,
				"room": room_token,
			})


func on_player_health_damage(amount: int) -> void:
	if amount > 0:
		_room_health_damage_taken = true


func on_combat_room_cleared(area_id: int, room_token: String) -> int:
	if not is_equipped(CATALOG.UNBROKEN_CORD) or _room_health_damage_taken:
		return 0
	var bonus: int = int(round(get_effective_value(CATALOG.UNBROKEN_CORD)))
	if bonus > 0 and typeof(RunData) == TYPE_OBJECT:
		RunData.add_gold(bonus)
		_trigger(CATALOG.UNBROKEN_CORD, "clean_room_gold", float(bonus), {
			"area_id": area_id,
			"room": room_token,
		})
	return bonus


func get_effective_shop_price(base_price: int, area_id: int) -> int:
	base_price = maxi(0, base_price)
	if not is_equipped(CATALOG.MERCHANTS_SEAL) or bool(_merchant_discount_used_by_area.get(area_id, false)):
		return base_price
	var discount: float = clampf(get_effective_value(CATALOG.MERCHANTS_SEAL), 0.0, 0.90)
	return maxi(0, int(floor(float(base_price) * (1.0 - discount) + 0.0001)))


func consume_shop_discount(area_id: int, base_price: int, paid_price: int) -> void:
	if not is_equipped(CATALOG.MERCHANTS_SEAL) or bool(_merchant_discount_used_by_area.get(area_id, false)):
		return
	_merchant_discount_used_by_area[area_id] = true
	var saved: int = maxi(0, base_price - paid_price)
	_trigger(CATALOG.MERCHANTS_SEAL, "regional_first_purchase_discount", float(saved), {
		"area_id": area_id,
		"base_price": base_price,
		"paid_price": paid_price,
	})


func consume_scribe_extra_choice(area_id: int) -> bool:
	if not is_equipped(CATALOG.SCRIBES_LENS):
		return false
	var quota: int = maxi(1, int(round(get_effective_value(CATALOG.SCRIBES_LENS))))
	var used: int = maxi(0, int(_scribe_uses_by_area.get(area_id, 0)))
	if used >= quota:
		return false
	_scribe_uses_by_area[area_id] = used + 1
	_trigger(CATALOG.SCRIBES_LENS, "regional_technique_extra_choice", 1.0, {
		"area_id": area_id,
		"use": used + 1,
		"quota": quota,
	})
	return true


func should_preserve_scribe_count(previous_choice_count: int) -> bool:
	return previous_choice_count >= 4 and is_equipped(CATALOG.SCRIBES_LENS)


func try_last_oath(current_hp: int, incoming_actual_damage: int) -> int:
	if not is_equipped(CATALOG.LAST_OATH) or _last_oath_used:
		return -1
	if current_hp <= 0 or incoming_actual_damage < current_hp:
		return -1
	_last_oath_used = true
	var survivor_hp: int = maxi(1, int(round(get_effective_value(CATALOG.LAST_OATH))))
	_trigger(CATALOG.LAST_OATH, "lethal_survival_hp", float(survivor_hp))
	return survivor_hp


func on_deathblow(player: Node) -> int:
	if not is_equipped(CATALOG.EXECUTION_BEAD):
		return 0
	var amount: int = int(round(get_effective_value(CATALOG.EXECUTION_BEAD)))
	if _grant_spirit(player, amount):
		_trigger(CATALOG.EXECUTION_BEAD, "deathblow_spirit", float(amount))
		return amount
	return 0


func on_blood_art_used(player: Node) -> int:
	if not is_equipped(CATALOG.BLOOD_MOON_SHARD):
		return 0
	var amount: int = int(round(get_effective_value(CATALOG.BLOOD_MOON_SHARD)))
	if _grant_spirit(player, amount):
		_trigger(CATALOG.BLOOD_MOON_SHARD, "blood_art_spirit", float(amount))
		return amount
	return 0


# =============================================================================
# PLAYTEST / INSPECTION
# =============================================================================

func unlock_all_for_playtest() -> void:
	for relic_id: String in CATALOG.IDS:
		unlocked_relics[relic_id] = true
		if not mastery_kills.has(relic_id):
			mastery_kills[relic_id] = 0
	_save_progress()
	collection_changed.emit()


func equip_for_playtest(relic_id: String) -> bool:
	if not CATALOG.has(relic_id):
		return false
	if not unlocked_relics.has(relic_id):
		discover_relic(relic_id, false)
	equipped_relic_id = relic_id
	_save_progress()
	equipped_changed.emit(relic_id)
	return true


func set_mastery_rank_for_playtest(relic_id: String, rank: int) -> void:
	if not CATALOG.has(relic_id):
		return
	var clamped_rank: int = clampi(rank, 0, 2)
	var kills: int = 0
	if clamped_rank == 1:
		kills = CATALOG.MASTERY_I_KILLS
	elif clamped_rank == 2:
		kills = CATALOG.MASTERY_II_KILLS
	mastery_kills[relic_id] = kills
	_save_progress()
	mastery_changed.emit(relic_id, kills, clamped_rank)


func get_runtime_snapshot() -> Dictionary:
	return {
		"version": RUNTIME_VERSION,
		"equipped": equipped_relic_id,
		"unlocked_count": unlocked_relics.size(),
		"mastery_rank": get_equipped_mastery_rank(),
		"mastery_kills": get_mastery_kills(equipped_relic_id),
		"last_oath_used": _last_oath_used,
		"room_health_damage_taken": _room_health_damage_taken,
	}


# =============================================================================
# ENEMY KILL TRACKING FOR MASTERY
# =============================================================================

func _on_tree_node_added(node: Node) -> void:
	if node == null:
		return
	call_deferred("_try_track_enemy", node)


func _track_existing_enemies() -> void:
	for group_name: String in ["enemy", "miniboss"]:
		for enemy: Node in get_tree().get_nodes_in_group(group_name):
			_try_track_enemy(enemy)


func _try_track_enemy(enemy: Node) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	if not enemy.is_in_group("enemy") and not enemy.is_in_group("miniboss"):
		return
	var id: int = enemy.get_instance_id()
	if _tracked_enemies.has(id):
		return
	_tracked_enemies[id] = weakref(enemy)
	if not enemy.tree_exiting.is_connected(_on_tracked_enemy_exiting.bind(enemy)):
		enemy.tree_exiting.connect(_on_tracked_enemy_exiting.bind(enemy), CONNECT_ONE_SHOT)


func _on_tracked_enemy_exiting(enemy: Node) -> void:
	if enemy == null:
		return
	if _enemy_is_dead(enemy):
		_record_enemy_kill_once(enemy)
	_tracked_enemies.erase(enemy.get_instance_id())


func _record_enemy_kill_once(enemy: Node) -> void:
	if enemy == null or bool(enemy.get_meta("_relic_mastery_kill_recorded", false)):
		return
	enemy.set_meta("_relic_mastery_kill_recorded", true)
	record_eligible_kill(enemy)
	if typeof(RunData) == TYPE_OBJECT and RunData.has_method("record_enemy_killed"):
		RunData.record_enemy_killed()
	_tracked_enemies.erase(enemy.get_instance_id())


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
# HELPERS / SAVE
# =============================================================================

func _heal_player(player: Node, amount: int) -> void:
	if amount <= 0:
		return
	if player.has_method("heal"):
		player.call("heal", amount)
		return
	if "hp" in player and "maxhp" in player:
		player.set("hp", mini(int(player.get("maxhp")), int(player.get("hp")) + amount))
		if player.has_method("_update_health_bar"):
			player.call("_update_health_bar")


func _grant_spirit(player: Node, amount: int) -> bool:
	if amount <= 0 or player == null or not is_instance_valid(player):
		return false
	var executor_value: Variant = player.get("prosthetic_executor")
	if not (executor_value is Node) or not is_instance_valid(executor_value):
		return false
	var executor: Node = executor_value as Node
	if not executor.has_method("add_spirit"):
		return false
	executor.call("add_spirit", amount)
	return true


func _trigger(relic_id: String, effect: String, amount: float, extra: Dictionary = {}) -> void:
	relic_effect_triggered.emit(relic_id, effect, amount)
	var payload: Dictionary = extra.duplicate(true)
	payload["relic_id"] = relic_id
	payload["effect"] = effect
	payload["amount"] = amount
	payload["mastery_rank"] = get_mastery_rank(relic_id)
	_record("relic_effect_triggered", payload)


func _record(event_name: String, payload: Dictionary) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event(event_name, payload)


func _save_progress() -> void:
	var file := ConfigFile.new()
	file.set_value(SAVE_SECTION, "version", RUNTIME_VERSION)
	file.set_value(SAVE_SECTION, "unlocked_relics", unlocked_relics)
	file.set_value(SAVE_SECTION, "mastery_kills", mastery_kills)
	file.set_value(SAVE_SECTION, "equipped_relic_id", equipped_relic_id)
	var err: Error = file.save(SAVE_PATH)
	if err != OK:
		push_warning("[OathboundRelicRuntime] Could not save Relic progress: %s" % error_string(err))


func _load_progress() -> void:
	unlocked_relics.clear()
	mastery_kills.clear()
	equipped_relic_id = ""
	var file := ConfigFile.new()
	if file.load(SAVE_PATH) != OK:
		return
	var unlocked_value: Variant = file.get_value(SAVE_SECTION, "unlocked_relics", {})
	if unlocked_value is Dictionary:
		for relic_id_value: Variant in (unlocked_value as Dictionary).keys():
			var relic_id: String = str(relic_id_value)
			if CATALOG.has(relic_id) and bool((unlocked_value as Dictionary).get(relic_id_value, false)):
				unlocked_relics[relic_id] = true
	var mastery_value: Variant = file.get_value(SAVE_SECTION, "mastery_kills", {})
	if mastery_value is Dictionary:
		for relic_id: String in CATALOG.IDS:
			mastery_kills[relic_id] = maxi(0, int((mastery_value as Dictionary).get(relic_id, 0)))
	var equipped_value: String = str(file.get_value(SAVE_SECTION, "equipped_relic_id", ""))
	if equipped_value.is_empty() or unlocked_relics.has(equipped_value):
		equipped_relic_id = equipped_value
