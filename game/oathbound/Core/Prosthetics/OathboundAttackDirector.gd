extends "res://Utility/AttackDirector.gd"

## Current attack-admission overlay for Prosthetic control effects and Combat V2.
##
## Non-migrated enemies continue using the inherited stable role/token API unchanged.
## Migrated enemies may instead reserve future impact windows through PressureDirectorV2.
## Smoke applies to both paths so V2 pressure admission cannot bypass Prosthetic control.

const DEFAULT_SMOKE_ATTACK_DISTANCE: float = 50.0
const PRESSURE_DIRECTOR_SCRIPT = preload("res://Core/Combat/PressureDirectorV2.gd")
const META_V2_PRESSURE_MIGRATED: StringName = &"oathbound_v2_pressure_migrated"
const META_FRONTLINE_PRESSURE_BODY: StringName = &"oathbound_frontline_pressure_body"
const LEGACY_DAMAGING_ROLES: Array[String] = ["melee_attack", "ranged_attack", "dog_lunge", "hollow_lunge"]

var _pressure_director_v2: PressureDirectorV2 = null


func _ready() -> void:
	super._ready()
	_install_pressure_director_v2()
	print("[AttackDirector] Combat V2 pressure-window facade active")


func _install_pressure_director_v2() -> void:
	if _pressure_director_v2 != null and is_instance_valid(_pressure_director_v2):
		return
	var value: Variant = PRESSURE_DIRECTOR_SCRIPT.new()
	if not (value is PressureDirectorV2):
		push_error("[AttackDirector] Could not create PressureDirectorV2")
		return
	_pressure_director_v2 = value as PressureDirectorV2
	_pressure_director_v2.name = "PressureDirectorV2"
	add_child(_pressure_director_v2)


func request_role(who: Node, role: String) -> bool:
	if who != null and is_instance_valid(who) and is_holding_role(who, role):
		return true
	if _smoke_prevents_new_attack(who, role):
		return false
	if _v2_pressure_blocks_legacy_role(who, role):
		return false
	return super.request_role(who, role)


func request_pressure_threat(who: Node, request: Dictionary) -> Dictionary:
	_install_pressure_director_v2()
	var now: float = Time.get_ticks_msec() * 0.001
	if who == null or not is_instance_valid(who) or _pressure_director_v2 == null:
		return {"admitted": false, "retry_at": now + 0.10, "reason": "pressure_unavailable"}
	if _smoke_prevents_new_attack(who, "melee_attack"):
		return {"admitted": false, "retry_at": now + 0.12, "reason": "smoke_disrupted"}

	# During incremental migration, a legacy melee holder remains exclusive. This keeps
	# old enemies safe while multiple V2 actors can overlap with one another based on
	# their future impact windows instead of the old one-turn token.
	if count_role("melee_attack") > 0 and not super.is_holding_role(who, "melee_attack"):
		return {"admitted": false, "retry_at": now + 0.12, "reason": "legacy_melee_active"}

	return _pressure_director_v2.request_threat(who, request)


func release_pressure_threat(who: Node, reservation_id: String = "", reason: String = "completed") -> void:
	if _pressure_director_v2 == null or not is_instance_valid(_pressure_director_v2):
		return
	_pressure_director_v2.release_threat(who, reservation_id, reason)


func has_pressure_reservation(who: Node) -> bool:
	if _pressure_director_v2 == null or not is_instance_valid(_pressure_director_v2):
		return false
	return _pressure_director_v2.has_reservation(who)


func pressure_reservation_count() -> int:
	if _pressure_director_v2 == null or not is_instance_valid(_pressure_director_v2):
		return 0
	return _pressure_director_v2.reservation_count()


func snapshot_pressure_reservations() -> Array[Dictionary]:
	if _pressure_director_v2 == null or not is_instance_valid(_pressure_director_v2):
		return []
	return _pressure_director_v2.snapshot_reservations()


func get_pressure_director_v2() -> PressureDirectorV2:
	_install_pressure_director_v2()
	return _pressure_director_v2


func is_holding_role(who: Node, role: String) -> bool:
	# Base crowd spacing treats active melee holders as sacred. Expose a V2 pressure
	# reservation through that read-only query so crowd backoff cannot shove a migrated
	# close-pressure actor out of its already-admitted attack. The legacy holder
	# collection itself is not modified, so old token limits remain unchanged.
	if role == "melee_attack" and has_pressure_reservation(who):
		return true
	return super.is_holding_role(who, role)


func release_all_for(who: Node) -> void:
	if _pressure_director_v2 != null and is_instance_valid(_pressure_director_v2):
		_pressure_director_v2.release_all_for(who, "director_release_all")
	super.release_all_for(who)


func _v2_pressure_blocks_legacy_role(who: Node, role: String) -> bool:
	if role not in LEGACY_DAMAGING_ROLES:
		return false
	if who != null and is_instance_valid(who) and has_pressure_reservation(who):
		# Some migrated controllers retain inherited compatibility role calls inside an
		# already-admitted action. Never deadlock the reservation owner against itself.
		return false
	return pressure_reservation_count() > 0


# Combat V2 room pressure is role-aware. The global base AttackDirector still has a
# useful close-body backoff algorithm, but Hushiro's migrated Archer/Bilemass should
# not consume close-frontline occupancy simply because they happen to cross the 90 px
# radius while kiting/skittering. Actors without metadata retain legacy behavior.
func _crowd_tick() -> void:
	var player := _get_player()
	if player == null:
		return

	for role in _roles.keys():
		_cleanup_dead(_roles[role]["holders"])
	_refresh_current_duelist()

	var frontline: Array = []
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or not (enemy is Node2D) or _node_is_dead(enemy):
			continue
		if not _counts_toward_close_frontline(enemy):
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
		# Active attacks remain sacred. Oathbound's is_holding_role overlay includes V2
		# pressure reservations so an admitted close-pressure action cannot be displaced.
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


func _counts_toward_close_frontline(who: Node) -> bool:
	if who != null and is_instance_valid(who) and who.has_meta(META_FRONTLINE_PRESSURE_BODY):
		return bool(who.get_meta(META_FRONTLINE_PRESSURE_BODY))
	return true


# The inherited stall-prevention mechanism exists to rescue old single-turn actors.
# All six current Hushiro standard families own EnemyBrain/PressureDirectorV2 cadence,
# so forcing `_force_attack_soon` or clearing their backoff every second reintroduces
# V1 timing interference. Mixed legacy/V2 scenes still retain the nudge for legacy
# actors because only migrated actors are filtered here.
func _closest_engaged_enemy() -> Node:
	var player := _get_player()
	if player == null:
		return null
	var best: Node = null
	var best_dist := INF
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or not (enemy is Node2D) or _node_is_dead(enemy):
			continue
		if _uses_v2_pressure_cadence(enemy):
			continue
		var dist: float = (enemy as Node2D).global_position.distance_to(player.global_position)
		if dist <= orbit_distance + 80.0 and dist < best_dist:
			best = enemy
			best_dist = dist
	return best


func _uses_v2_pressure_cadence(who: Node) -> bool:
	return (
		who != null
		and is_instance_valid(who)
		and who.has_meta(META_V2_PRESSURE_MIGRATED)
		and bool(who.get_meta(META_V2_PRESSURE_MIGRATED))
	)


func _smoke_prevents_new_attack(who: Node, role: String) -> bool:
	if who == null or not is_instance_valid(who):
		return false
	if role not in ["melee_attack", "ranged_attack", "dog_lunge", "hollow_lunge", "frontal", "flank_left", "flank_right"]:
		return false
	var now: float = Time.get_ticks_msec() * 0.001
	var disrupted_until: float = float(who.get_meta("_oathbound_smoke_disrupted_until", 0.0))
	if disrupted_until <= now:
		return false
	if not (who is Node2D):
		return true
	var player: Node2D = _get_player()
	if player == null:
		return true
	var allowed_distance: float = float(who.get_meta("_oathbound_smoke_attack_distance", DEFAULT_SMOKE_ATTACK_DISTANCE))
	return (who as Node2D).global_position.distance_to(player.global_position) > allowed_distance
