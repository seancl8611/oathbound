extends Node

## Stable combat-pressure coordinator.
##
## Core invariant: an active melee turn is never stolen. An enemy that owns the
## `melee_attack` role keeps it until that enemy releases it, dies, or is freed.
## Waiting enemies may approach/orbit, but crowd spacing and stall prevention never
## revoke an active attack and hand the same turn to a second enemy mid-swing.

signal role_released(role: String)
signal crowd_backoff(targets: Array)

@export_group("Attack Turns")
@export var max_melee_attackers: int = 1
@export var grant_gap_sec: float = 0.35
@export var per_enemy_cooldown: float = 1.25
@export var attack_turnover_delay: float = 0.45

@export_group("Spacing")
@export var max_frontline: int = 3
@export var frontline_radius: float = 90.0
@export var orbit_distance: float = 130.0
@export var backoff_duration: float = 1.35

@export_group("Stall Prevention")
@export var stall_check_interval: float = 1.0
@export var stall_threshold_sec: float = 3.0
@export var max_idle_time: float = 4.5

@export var role_defaults: Dictionary = {
	"melee_attack": {"limit": 1, "cooldown": 1.25},
	"dog_lunge": {"limit": 1, "cooldown": 2.2},
	"hollow_lunge": {"limit": 1, "cooldown": 2.2},
	"advance_move": {"limit": 3, "cooldown": 0.65},
	"ranged_attack": {"limit": 2, "cooldown": 2.5},
	"frontal": {"limit": 1, "cooldown": 1.0},
	"flank_left": {"limit": 1, "cooldown": 1.0},
	"flank_right": {"limit": 1, "cooldown": 1.0},
}

var _roles: Dictionary = {}
var _deny_until: Dictionary = {}
var _last_attack_time: float = 0.0
var _current_duelist: WeakRef = null


func _ready() -> void:
	if role_defaults.has("melee_attack") and role_defaults["melee_attack"] is Dictionary:
		role_defaults["melee_attack"]["limit"] = max_melee_attackers
		role_defaults["melee_attack"]["cooldown"] = per_enemy_cooldown

	for role in role_defaults.keys():
		_ensure_role(str(role))

	var crowd_timer := Timer.new()
	crowd_timer.name = "CrowdTick"
	crowd_timer.one_shot = false
	crowd_timer.wait_time = 0.30
	add_child(crowd_timer)
	crowd_timer.timeout.connect(_crowd_tick)
	crowd_timer.start()

	var stall_timer := Timer.new()
	stall_timer.name = "StallPrevention"
	stall_timer.one_shot = false
	stall_timer.wait_time = maxf(0.5, stall_check_interval)
	add_child(stall_timer)
	stall_timer.timeout.connect(_stall_prevention_tick)
	stall_timer.start()

	_last_attack_time = Time.get_ticks_msec() * 0.001
	print("[AttackDirector] v4.0 - Stable single-turn combat")


func _ensure_role(role: String) -> void:
	if _roles.has(role):
		return
	var defaults: Dictionary = role_defaults.get(role, {"limit": 1, "cooldown": 1.0})
	_roles[role] = {
		"limit": int(defaults.get("limit", 1)),
		"holders": {},
		"cooldown": float(defaults.get("cooldown", 1.0)),
		"last_release": {},
		"last_grant": -999.0,
	}


func request_role(who: Node, role: String) -> bool:
	if not is_instance_valid(who):
		return false
	_ensure_role(role)

	var data: Dictionary = _roles[role]
	var holders: Dictionary = data["holders"]
	_cleanup_dead(holders)

	var id := who.get_instance_id()
	if holders.has(id):
		return true

	var now := Time.get_ticks_msec() * 0.001
	if _is_denied(role, id, now):
		return false

	var limit := maxi(0, int(data["limit"]))
	if limit == 0 or holders.size() >= limit:
		return false

	var last_release: Dictionary = data["last_release"]
	var cooldown := maxf(0.0, float(data["cooldown"]))
	if last_release.has(id) and now - float(last_release[id]) < cooldown:
		return false

	var gap := grant_gap_sec
	if role == "melee_attack":
		gap = maxf(gap, attack_turnover_delay)
	if now - float(data["last_grant"]) < gap:
		return false

	holders[id] = weakref(who)
	data["last_grant"] = now

	if role == "melee_attack":
		_current_duelist = weakref(who)
		_last_attack_time = now

	return true


func release_role(who: Node, role: String) -> void:
	if not is_instance_valid(who) or not _roles.has(role):
		return
	var data: Dictionary = _roles[role]
	var holders: Dictionary = data["holders"]
	var id := who.get_instance_id()
	if not holders.erase(id):
		return

	var now := Time.get_ticks_msec() * 0.001
	data["last_release"][id] = now
	if role == "melee_attack":
		data["last_grant"] = now
		if _current_duelist != null and _current_duelist.get_ref() == who:
			_current_duelist = null
		emit_signal("role_released", role)
	else:
		emit_signal("role_released", role)


func release_all_for(who: Node) -> void:
	if not is_instance_valid(who):
		return
	for role in _roles.keys():
		release_role(who, str(role))


func is_holding_role(who: Node, role: String) -> bool:
	if not is_instance_valid(who) or not _roles.has(role):
		return false
	var holders: Dictionary = _roles[role]["holders"]
	_cleanup_dead(holders)
	return holders.has(who.get_instance_id())


func count_role(role: String) -> int:
	_ensure_role(role)
	var holders: Dictionary = _roles[role]["holders"]
	_cleanup_dead(holders)
	return holders.size()


func get_role_limit(role: String) -> int:
	_ensure_role(role)
	return int(_roles[role]["limit"])


# Legacy token API used by current imported enemy controllers.
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


func set_role_limits(limits: Dictionary) -> void:
	for role_value in limits.keys():
		var role := str(role_value)
		_ensure_role(role)
		_roles[role]["limit"] = maxi(0, int(limits[role_value]))
		# Never prune an active holder. A lowered cap simply prevents new grants until
		# existing holders finish their turns naturally.


func set_role_cooldowns(values: Dictionary) -> void:
	for role_value in values.keys():
		var role := str(role_value)
		_ensure_role(role)
		_roles[role]["cooldown"] = maxf(0.0, float(values[role_value]))


func _cleanup_dead(holders: Dictionary) -> void:
	for id in holders.keys():
		var wr: WeakRef = holders[id]
		var node: Node = wr.get_ref() if wr != null else null
		if node == null or not is_instance_valid(node) or _node_is_dead(node):
			holders.erase(id)


func _node_is_dead(node: Node) -> bool:
	if node.has_method("is_dead"):
		return bool(node.call("is_dead"))
	var has_died = node.get("has_died")
	return bool(has_died) if has_died != null else false


func _is_denied(role: String, id: int, now: float) -> bool:
	if not _deny_until.has(role):
		return false
	var denied: Dictionary = _deny_until[role]
	if not denied.has(id):
		return false
	if now >= float(denied[id]):
		denied.erase(id)
		return false
	return true


func _crowd_tick() -> void:
	var player := _get_player()
	if player == null:
		return

	# Dead/freed role owners are cleaned without revoking a living active attack.
	for role in _roles.keys():
		_cleanup_dead(_roles[role]["holders"])
	_refresh_current_duelist()

	var frontline: Array = []
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or not (enemy is Node2D) or _node_is_dead(enemy):
			continue
		if (enemy as Node2D).global_position.distance_to(player.global_position) <= frontline_radius:
			frontline.append(enemy)

	if frontline.size() <= max_frontline:
		return

	frontline.sort_custom(func(a, b):
		var a_attacking := is_holding_role(a, "melee_attack")
		var b_attacking := is_holding_role(b, "melee_attack")
		if a_attacking != b_attacking:
			return a_attacking
		return (a as Node2D).global_position.distance_to(player.global_position) < (b as Node2D).global_position.distance_to(player.global_position)
	)

	var backoff_list: Array = []
	for i in range(max_frontline, frontline.size()):
		var enemy: Node = frontline[i]
		# Active attacks are sacred: spacing never interrupts them.
		if is_holding_role(enemy, "melee_attack"):
			continue
		backoff_list.append(enemy)

	if backoff_list.is_empty():
		return

	var now := Time.get_ticks_msec() * 0.001
	if not _deny_until.has("advance_move"):
		_deny_until["advance_move"] = {}
	var denied_advance: Dictionary = _deny_until["advance_move"]

	for enemy in backoff_list:
		denied_advance[enemy.get_instance_id()] = now + backoff_duration + randf_range(0.0, 0.35)
		release_role(enemy, "advance_move")
		if enemy.has_method("_crowd_force_backoff"):
			enemy.call_deferred("_crowd_force_backoff", backoff_duration)

	emit_signal("crowd_backoff", backoff_list)


func _stall_prevention_tick() -> void:
	_refresh_current_duelist()
	if count_role("melee_attack") > 0:
		return

	var now := Time.get_ticks_msec() * 0.001
	if now - _last_attack_time < stall_threshold_sec:
		return

	var closest := _closest_engaged_enemy()
	if closest == null:
		return

	# Nudge only the enemy's approach/decision state. Do not grant or steal an attack
	# role here; the enemy must request its own turn when its authored windup begins.
	if "_force_attack_soon" in closest:
		closest.set("_force_attack_soon", true)
	if closest.has_method("_crowd_force_backoff"):
		# Clear an old local backoff by passing zero when supported.
		closest.call("_crowd_force_backoff", 0.0)

	if now - _last_attack_time >= max_idle_time:
		_clear_enemy_cooldown_for(closest, "melee_attack")
		_clear_enemy_cooldown_for(closest, "advance_move")


func _clear_enemy_cooldown_for(enemy: Node, role: String) -> void:
	if not is_instance_valid(enemy):
		return
	_ensure_role(role)
	var data: Dictionary = _roles[role]
	var id := enemy.get_instance_id()
	var last: Dictionary = data["last_release"]
	last.erase(id)
	data["last_grant"] = minf(float(data["last_grant"]), Time.get_ticks_msec() * 0.001 - grant_gap_sec)
	if _deny_until.has(role):
		(_deny_until[role] as Dictionary).erase(id)


func _closest_engaged_enemy() -> Node:
	var player := _get_player()
	if player == null:
		return null
	var best: Node = null
	var best_dist := INF
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or not (enemy is Node2D) or _node_is_dead(enemy):
			continue
		var dist := (enemy as Node2D).global_position.distance_to(player.global_position)
		if dist <= orbit_distance + 80.0 and dist < best_dist:
			best = enemy
			best_dist = dist
	return best


func _refresh_current_duelist() -> void:
	if _current_duelist != null:
		var current: Node = _current_duelist.get_ref()
		if current != null and is_instance_valid(current) and is_holding_role(current, "melee_attack"):
			return
	_current_duelist = null
	if not _roles.has("melee_attack"):
		return
	var holders: Dictionary = _roles["melee_attack"]["holders"]
	_cleanup_dead(holders)
	for wr_value in holders.values():
		var wr: WeakRef = wr_value
		var node: Node = wr.get_ref() if wr != null else null
		if node != null and is_instance_valid(node):
			_current_duelist = weakref(node)
			return


func get_time_since_last_attack() -> float:
	return Time.get_ticks_msec() * 0.001 - _last_attack_time


func reset_attack_timer() -> void:
	_last_attack_time = Time.get_ticks_msec() * 0.001


func force_engagement() -> void:
	var closest := _closest_engaged_enemy()
	if closest == null:
		return
	if "_force_attack_soon" in closest:
		closest.set("_force_attack_soon", true)
	_clear_enemy_cooldown_for(closest, "melee_attack")
	_clear_enemy_cooldown_for(closest, "advance_move")


func get_current_duelist() -> Node:
	_refresh_current_duelist()
	return _current_duelist.get_ref() if _current_duelist != null else null


func _get_player() -> Node2D:
	var players := get_tree().get_nodes_in_group("player")
	if not players.is_empty() and players[0] is Node2D:
		return players[0] as Node2D
	return null
