extends Node

## =============================================================================
## ATTACK DIRECTOR - v3.1 BALANCED SEKIRO COMBAT
## =============================================================================
## Philosophy: Controlled aggression, not chaos or stalling
## - 1-2 enemies can attack at a time (feels like dueling)
## - Others orbit and wait for openings
## - Long enough cooldowns for readability
## - Stall prevention ensures combat keeps moving
## =============================================================================

signal role_released(role: String)

# =============================================================================
# CORE COMBAT SETTINGS
# =============================================================================

## How many can attack simultaneously (1-2 for duel feel)
@export var max_melee_attackers: int = 1

## Delay between granting attack tokens
@export var grant_gap_sec: float = 0.5

## Individual enemy cooldown after attacking
@export var per_enemy_cooldown: float = 2.0

## Delay after one enemy finishes before another can start
@export var attack_turnover_delay: float = 0.8

# =============================================================================
# SPACING CONTROL
# =============================================================================

## Max enemies in close range at once
@export var max_frontline: int = 3

## What counts as frontline
@export var frontline_radius: float = 90.0

## Orbit distance for waiting enemies
@export var orbit_distance: float = 130.0

## How long backoff lasts
@export var backoff_duration: float = 1.8

# =============================================================================
# STALL PREVENTION - Keeps combat moving
# =============================================================================

@export var stall_check_interval: float = 2.0
@export var stall_threshold_sec: float = 2.5
@export var max_idle_time: float = 3.5

# =============================================================================
# ROLE DEFINITIONS
# =============================================================================

@export var role_defaults: Dictionary = {
	"melee_attack": {"limit": 1, "cooldown": 3.0},
	"dog_lunge": {"limit": 1, "cooldown": 2.2},
	"advance_move": {"limit": 3, "cooldown": 1.2},
	"ranged_attack": {"limit": 2, "cooldown": 2.5},
	"frontal": {"limit": 1, "cooldown": 1.0},
	"flank_left": {"limit": 1, "cooldown": 1.0},
	"flank_right": {"limit": 1, "cooldown": 1.0},
}

# =============================================================================
# INTERNAL STATE
# =============================================================================

var _roles: Dictionary = {}
var _deny_until: Dictionary = {}
var _last_attack_time: float = 0.0
var _current_duelist: WeakRef = null

func _ready() -> void:
	# Keep melee_attack limit in sync with max_melee_attackers (quality-of-life)
	if role_defaults.has("melee_attack") and role_defaults["melee_attack"] is Dictionary:
		role_defaults["melee_attack"]["limit"] = max_melee_attackers
	
	for r in role_defaults.keys():
		_ensure_role(r)
	
	# Crowd control timer
	var crowd_timer = Timer.new()
	crowd_timer.name = "CrowdTick"
	crowd_timer.one_shot = false
	crowd_timer.wait_time = 0.3
	add_child(crowd_timer)
	crowd_timer.timeout.connect(_crowd_tick)
	crowd_timer.start()
	
	# Stall prevention timer
	var stall_timer = Timer.new()
	stall_timer.name = "StallPrevention"
	stall_timer.one_shot = false
	stall_timer.wait_time = stall_check_interval
	add_child(stall_timer)
	stall_timer.timeout.connect(_stall_prevention_tick)
	stall_timer.start()
	
	_last_attack_time = Time.get_ticks_msec() * 0.001
	print("[AttackDirector] v3.1 - Balanced Sekiro Combat")


func _ensure_role(role: String) -> void:
	if not _roles.has(role):
		var defaults = role_defaults.get(role, {"limit": 1, "cooldown": 2.0})
		_roles[role] = {
			"limit": defaults.get("limit", 1),
			"holders": {},
			"cooldown": defaults.get("cooldown", 2.0),
			"last_release": {},
			"last_grant": 0.0,
		}

func request_role(who: Node, role: String) -> bool:
	if not is_instance_valid(who):
		return false
	_ensure_role(role)
	
	var id = who.get_instance_id()
	var now = Time.get_ticks_msec() * 0.001
	var data = _roles[role]
	var holders: Dictionary = data["holders"]
	
	# Already holding
	if holders.has(id):
		return true
	
	# Deny list check
	if _deny_until.has(role):
		var d = _deny_until[role]
		if d.has(id) and now < float(d[id]):
			return false
		else:
			d.erase(id)
	
	# Per-enemy cooldown - REDUCED STRICTNESS
	var last: Dictionary = data["last_release"]
	var cooldown_time = float(data["cooldown"])
	
	# If no one is attacking, reduce cooldown requirement
	var current_holders = holders.size()
	_cleanup_dead(holders)
	current_holders = holders.size()
	
	if current_holders == 0:
		cooldown_time *= 0.5  # Half cooldown if no one attacking
	
	if last.has(id) and now - float(last[id]) < cooldown_time:
		return false
	
	var limit = int(data["limit"])
	var cap_full = holders.size() >= limit
	
	# Grant gap - REDUCED when no attackers
	var effective_gap = grant_gap_sec
	if current_holders == 0:
		effective_gap *= 0.4
	
	var too_soon = (now - float(data["last_grant"])) < effective_gap
	
	# Distance-based preemption for melee
	if cap_full and role == "melee_attack":
		var p = _get_player()
		if p and who is Node2D:
			var who_dist = (who.global_position - p.global_position).length()
			if who_dist <= frontline_radius:
				var far_id = -1
				var far_dist = -1.0
				var far_node: Node2D = null
				for hid in holders.keys():
					var wr: WeakRef = holders[hid]
					var h = wr.get_ref()
					if h and h is Node2D:
						var hd = (h.global_position - p.global_position).length()
						if hd > far_dist:
							far_dist = hd
							far_id = hid
							far_node = h
				if far_id != -1 and who_dist + 25.0 < far_dist:
					if far_node:
						release_role(far_node, "melee_attack")
					cap_full = false
					too_soon = false
	
	if cap_full or too_soon:
		return false
	
	# Grant
	holders[id] = weakref(who)
	data["last_grant"] = now
	
	if role == "melee_attack":
		_current_duelist = weakref(who)
		_last_attack_time = now
	
	return true
	
func release_role(who: Node, role: String) -> void:
	if not is_instance_valid(who):
		return
	if not _roles.has(role):
		return
	
	var id = who.get_instance_id()
	var data = _roles[role]
	var holders: Dictionary = data["holders"]
	
	if holders.erase(id):
		var now = Time.get_ticks_msec() * 0.001
		data["last_release"][id] = now
		
		if role == "melee_attack":
			if _current_duelist != null:
				var duelist = _current_duelist.get_ref()
				if duelist == who:
					_current_duelist = null
					# Apply turnover delay
					data["last_grant"] = now - grant_gap_sec + attack_turnover_delay
		
		emit_signal("role_released", role)


func is_holding_role(who: Node, role: String) -> bool:
	if not is_instance_valid(who):
		return false
	if not _roles.has(role):
		return false
	return _roles[role]["holders"].has(who.get_instance_id())


func count_role(role: String) -> int:
	_ensure_role(role)
	var data = _roles[role]
	_cleanup_dead(data["holders"])
	return data["holders"].size()


func get_role_limit(role: String) -> int:
	if not _roles.has(role):
		return 0
	return int(_roles[role]["limit"])


# =============================================================================
# LEGACY API
# =============================================================================

func request_token(who: Node) -> bool:
	if not is_instance_valid(who):
		return false
	if who.is_in_group("archer") or who.is_in_group("ranged"):
		return request_role(who, "ranged_attack")
	return request_role(who, "melee_attack")


func release_token(who: Node) -> void:
	if not is_instance_valid(who):
		return
	if who.is_in_group("archer") or who.is_in_group("ranged"):
		release_role(who, "ranged_attack")
	else:
		release_role(who, "melee_attack")


func holder_count() -> int:
	return count_role("melee_attack")


# =============================================================================
# EXTERNAL CONFIGURATION
# =============================================================================

func set_role_limits(limits: Dictionary) -> void:
	for r in limits.keys():
		_ensure_role(r)
		_roles[r]["limit"] = max(0, int(limits[r]))
		_prune_role(r)


func set_role_cooldowns(d: Dictionary) -> void:
	for r in d.keys():
		_ensure_role(r)
		_roles[r]["cooldown"] = float(d[r])


func _prune_role(role: String) -> void:
	var data = _roles[role]
	var holders: Dictionary = data["holders"]
	_cleanup_dead(holders)
	while holders.size() > int(data["limit"]):
		var drop_id = holders.keys()[0]
		holders.erase(drop_id)
		data["last_release"][drop_id] = Time.get_ticks_msec() * 0.001
		emit_signal("role_released", role)


func _cleanup_dead(dict: Dictionary) -> void:
	for id in dict.keys():
		var wr: WeakRef = dict[id]
		if wr == null or wr.get_ref() == null:
			dict.erase(id)


# =============================================================================
# CROWD CONTROL
# =============================================================================

signal crowd_backoff(targets: Array)

func _crowd_tick() -> void:
	var p = _get_player()
	if p == null:
		return
	
	var now = Time.get_ticks_msec() * 0.001
	
	# Prune distant melee holders
	if _roles.has("melee_attack"):
		var md = _roles["melee_attack"]
		var holders: Dictionary = md["holders"]
		var drop: Array = []
		for hid in holders.keys():
			var wr: WeakRef = holders[hid]
			var h = wr.get_ref()
			if h == null or not (h is Node2D):
				drop.append(hid)
			else:
				var hd = (h.global_position - p.global_position).length()
				if hd > 200.0:
					drop.append(hid)
		
		for hid in drop:
			var wr: WeakRef = md["holders"].get(hid, null)
			var h = wr and wr.get_ref()
			if h and h is Node2D:
				release_role(h, "melee_attack")
			else:
				md["holders"].erase(hid)
				md["last_release"][hid] = now
				emit_signal("role_released", "melee_attack")
	
	# Collect frontline enemies
	var frontline: Array = []
	for e in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(e) or not (e is Node2D):
			continue
		var dist = (e.global_position - p.global_position).length()
		if dist <= frontline_radius:
			frontline.append(e)
	
	if frontline.is_empty():
		return
	
	# Decide who stays
	var keep: Array = []
	
	# Priority 1: Current attacker
	for e in frontline:
		if is_holding_role(e, "melee_attack"):
			keep.append(e)
			break
	
	# Priority 2: Advance permission
	if keep.size() < max_frontline:
		for e in frontline:
			if keep.has(e):
				continue
			if is_holding_role(e, "advance_move"):
				keep.append(e)
				if keep.size() >= max_frontline:
					break
	
	# Priority 3: Closest
	if keep.size() < max_frontline:
		var rest: Array = []
		for e in frontline:
			if not keep.has(e):
				rest.append(e)
		rest.sort_custom(func(a, b):
			return a.global_position.distance_to(p.global_position) < b.global_position.distance_to(p.global_position)
		)
		for e in rest:
			keep.append(e)
			if keep.size() >= max_frontline:
				break
	
	# Force backoff for others
	var backoff_list: Array = []
	for e in frontline:
		if not keep.has(e):
			backoff_list.append(e)
	
	if backoff_list.is_empty():
		return
	
	for e in backoff_list:
		var id = e.get_instance_id()
		
		if not _deny_until.has("advance_move"):
			_deny_until["advance_move"] = {}
		_deny_until["advance_move"][id] = now + backoff_duration + randf() * 0.5
		
		release_role(e, "advance_move")
		release_role(e, "melee_attack")
		
		if e.has_method("_crowd_force_backoff"):
			e.call_deferred("_crowd_force_backoff", backoff_duration)
	
	emit_signal("crowd_backoff", backoff_list)

func _stall_prevention_tick() -> void:
	var p = _get_player()
	if p == null:
		return
	
	var now = Time.get_ticks_msec() * 0.001
	var time_since_attack = now - _last_attack_time
	
	# === MORE AGGRESSIVE STALL PREVENTION ===
	
	# Early nudge - start encouraging attacks sooner
	if time_since_attack >= stall_threshold_sec * 0.6:
		_soft_nudge_closest()
	
	if time_since_attack < stall_threshold_sec:
		return
	
	var engaged: Array = []
	for e in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(e) or not (e is Node2D):
			continue
		var dist = (e.global_position - p.global_position).length()
		if dist <= orbit_distance + 80.0:
			engaged.append({"enemy": e, "dist": dist})
	
	if engaged.is_empty():
		return
	
	engaged.sort_custom(func(a, b): return a["dist"] < b["dist"])
	
	if time_since_attack >= max_idle_time:
		_force_attack(engaged)
	elif time_since_attack >= stall_threshold_sec:
		_nudge_enemies(engaged)

func _nudge_enemies(enemies: Array) -> void:
	var now = Time.get_ticks_msec() * 0.001
	
	# Clear cooldowns for closest 2 enemies
	for enemy_data in enemies.slice(0, 2):
		var e = enemy_data["enemy"]
		if not is_instance_valid(e):
			continue
		
		var id = e.get_instance_id()
		
		if _roles.has("melee_attack"):
			var md = _roles["melee_attack"]
			md["last_grant"] = max(0.0, now - grant_gap_sec - 0.1)
			var last: Dictionary = md["last_release"]
			if last.has(id):
				last[id] = max(0.0, now - float(md["cooldown"]) - 0.1)
		
		if _roles.has("advance_move"):
			var ad = _roles["advance_move"]
			ad["last_grant"] = max(0.0, now - grant_gap_sec - 0.1)
			var ad_last: Dictionary = ad["last_release"]
			if ad_last.has(id):
				ad_last[id] = max(0.0, now - float(ad["cooldown"]) - 0.1)
		
		for role in _deny_until.keys():
			if _deny_until[role].has(id):
				_deny_until[role].erase(id)
		
		if e.has_meta("backoff_until"):
			e.remove_meta("backoff_until")


func _force_attack(enemies: Array) -> void:
	var now = Time.get_ticks_msec() * 0.001
	
	# Release current holders
	if _roles.has("melee_attack"):
		var md = _roles["melee_attack"]
		var holders: Dictionary = md["holders"]
		for hid in holders.keys():
			var wr: WeakRef = holders[hid]
			var h = wr.get_ref()
			if h:
				release_role(h, "melee_attack")
	
	_current_duelist = null
	_nudge_enemies(enemies)
	
	for enemy_data in enemies:
		var e = enemy_data["enemy"]
		if not is_instance_valid(e):
			continue
		
		if request_role(e, "melee_attack"):
			_last_attack_time = now
			
			if e.has_method("_ai_autonomous_think"):
				e.call_deferred("_ai_autonomous_think", now)
			
			break


# =============================================================================
# PUBLIC API
# =============================================================================

func get_time_since_last_attack() -> float:
	return Time.get_ticks_msec() * 0.001 - _last_attack_time


func reset_attack_timer() -> void:
	_last_attack_time = Time.get_ticks_msec() * 0.001


func force_engagement() -> void:
	var p = _get_player()
	if p == null:
		return
	
	var engaged: Array = []
	for e in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(e) or not (e is Node2D):
			continue
		var dist = (e.global_position - p.global_position).length()
		if dist <= orbit_distance + 80.0:
			engaged.append({"enemy": e, "dist": dist})
	
	if not engaged.is_empty():
		engaged.sort_custom(func(a, b): return a["dist"] < b["dist"])
		_force_attack(engaged)


func get_current_duelist() -> Node:
	if _current_duelist == null:
		return null
	return _current_duelist.get_ref()


func _get_player() -> Node2D:
	var ps = get_tree().get_nodes_in_group("player")
	if ps.size() > 0 and ps[0] is Node2D:
		return ps[0] as Node2D
	return null

func _soft_nudge_closest() -> void:
	"""Gently encourage closest enemy to attack without clearing all cooldowns"""
	var p = _get_player()
	if p == null:
		return
	
	var closest_enemy: Node2D = null
	var closest_dist = INF
	
	for e in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(e) or not (e is Node2D):
			continue
		var dist = (e.global_position - p.global_position).length()
		if dist < closest_dist and dist <= frontline_radius + 30.0:
			closest_dist = dist
			closest_enemy = e
	
	if closest_enemy == null:
		return
	
	# Flag the enemy to force attack soon
	# FIX: Variable name is _force_attack_soon (with underscore prefix)
	if "_force_attack_soon" in closest_enemy:
		closest_enemy._force_attack_soon = true
