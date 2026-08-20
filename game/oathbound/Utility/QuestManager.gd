# res://Utility/QuestManager.gd
extends Node

signal changed
signal quest_completed(quest_id: String)
signal quest_claimed(quest_id: String)

const SAVE_PATH := "user://quests.cfg"
const SAVE_SECTION := "quests"

# Reward formats:
# { "type":"currency", "currency": CurrencyManager.Currency.MIST_SHARDS, "amount": 50 }
# { "type":"prosthetic_unlock", "prosthetic_id":"flame_vent" }
# { "type":"relic_unlock", "relic_id":"some_relic" }
# { "type":"cosmetic", "cosmetic_id":"red_scarf" } (placeholder: you can hook later)

# Objective formats:
# { "type":"enemy_kills", "enemy_id":"grunt", "target":10 }
# { "type":"boss_kill", "boss_id":"chain_collector", "target":1 }
# { "type":"reach_area", "area_id":"area_2", "target":1 }

# --- Starter catalog (edit freely) ---
var _quests: Array[Dictionary] = [
	{
		"id": "q_kill_grunts_10",
		"title": "Cull the Rabble",
		"desc": "Defeat 10 Grunts.",
		"objective": {"type":"enemy_kills","enemy_id":"grunt","target":10},
		"reward": {"type":"currency","currency": CurrencyManager.Currency.MIST_SHARDS, "amount": 75},
	},
	{
		"id": "q_first_boss",
		"title": "Fell a Champion",
		"desc": "Defeat any boss.",
		"objective": {"type":"boss_kill","boss_id":"any","target":1},
		"reward": {"type":"prosthetic_unlock","prosthetic_id":"flame_vent"},
	},
	{
		"id": "q_reach_area_2",
		"title": "Deeper Descent",
		"desc": "Reach Area 2.",
		"objective": {"type":"reach_area","area_id":"area_2","target":1},
		"reward": {"type":"currency","currency": CurrencyManager.Currency.BOSS_EMBLEM, "amount": 1},
	},
]

# Runtime state
var _progress := {}   # id -> int
var _completed := {}  # id -> true
var _claimed := {}    # id -> true

func _ready():
	_load()

# =====================
# Public query API
# =====================

func list_all() -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	for q in _quests:
		out.append(q.duplicate(true))
	return out

func get_quest(id: String) -> Dictionary:
	for q in _quests:
		if str(q.get("id","")) == id:
			return q
	return {}

func get_progress(id: String) -> int:
	return int(_progress.get(id, 0))

func is_completed(id: String) -> bool:
	return _completed.has(id)

func is_claimed(id: String) -> bool:
	return _claimed.has(id)

func has_claimable() -> bool:
	for q in _quests:
		var id := str(q.get("id",""))
		if is_completed(id) and not is_claimed(id):
			return true
	return false

func get_status_bucket(id: String) -> String:
	# "active" | "completed" | "claimed"
	if is_claimed(id):
		return "claimed"
	if is_completed(id):
		return "completed"
	return "active"

# =====================
# Progress events (call these from your game systems)
# =====================

func report_enemy_kill(enemy_id: String, amount := 1) -> void:
	_apply_progress({"type":"enemy_kills","enemy_id": enemy_id}, amount)

func report_boss_kill(boss_id: String, amount := 1) -> void:
	# boss_id can be specific or any
	_apply_progress({"type":"boss_kill","boss_id": boss_id}, amount)
	_apply_progress({"type":"boss_kill","boss_id": "any"}, amount)

func report_reach_area(area_id: String) -> void:
	_apply_progress({"type":"reach_area","area_id": area_id}, 1)

# =====================
# Claim
# =====================

func claim(id: String) -> bool:
	if not is_completed(id) or is_claimed(id):
		return false

	var q := get_quest(id)
	if q.is_empty():
		return false

	var reward: Dictionary = q.get("reward", {})
	if not _apply_reward(reward):
		return false

	_claimed[id] = true
	_save()
	quest_claimed.emit(id)
	changed.emit()
	return true

# =====================
# Internal helpers
# =====================

func _apply_progress(matcher: Dictionary, amount: int) -> void:
	var changed_any := false

	for q in _quests:
		var id := str(q.get("id",""))
		if is_claimed(id):
			continue

		var obj: Dictionary = q.get("objective", {})
		if not _objective_matches(obj, matcher):
			continue

		var target := int(obj.get("target", 1))
		var cur := int(_progress.get(id, 0))
		var nxt = min(cur + amount, target)
		if nxt != cur:
			_progress[id] = nxt
			changed_any = true

		if nxt >= target and not _completed.has(id):
			_completed[id] = true
			quest_completed.emit(id)

	if changed_any:
		_save()
		changed.emit()

func _objective_matches(obj: Dictionary, matcher: Dictionary) -> bool:
	if str(obj.get("type","")) != str(matcher.get("type","")):
		return false

	match str(obj.get("type","")):
		"enemy_kills":
			return str(obj.get("enemy_id","")) == str(matcher.get("enemy_id",""))
		"boss_kill":
			return str(obj.get("boss_id","")) == str(matcher.get("boss_id",""))
		"reach_area":
			return str(obj.get("area_id","")) == str(matcher.get("area_id",""))
		_:
			return false

func _apply_reward(reward: Dictionary) -> bool:
	var t := str(reward.get("type",""))

	match t:
		"currency":
			var currency := int(reward.get("currency", 0))
			var amount := int(reward.get("amount", 0))
			if amount <= 0:
				return false
			CurrencyManager.add(currency, amount)
			return true

		"prosthetic_unlock":
			var pid := str(reward.get("prosthetic_id",""))
			if pid == "":
				return false
			ProstheticManager.unlock_prosthetic(pid)
			return true

		"relic_unlock":
			var rid := str(reward.get("relic_id",""))
			if rid == "":
				return false
			ProstheticManager.unlock_relic(rid)
			return true

		"cosmetic":
			# Placeholder: hook a CosmeticManager later
			return true

		_:
			return false

func _load() -> void:
	var cf := ConfigFile.new()
	if cf.load(SAVE_PATH) != OK:
		return

	_progress = cf.get_value(SAVE_SECTION, "progress", {})
	_completed = cf.get_value(SAVE_SECTION, "completed", {})
	_claimed = cf.get_value(SAVE_SECTION, "claimed", {})

func _save() -> void:
	var cf := ConfigFile.new()
	cf.set_value(SAVE_SECTION, "progress", _progress)
	cf.set_value(SAVE_SECTION, "completed", _completed)
	cf.set_value(SAVE_SECTION, "claimed", _claimed)
	cf.save(SAVE_PATH)
