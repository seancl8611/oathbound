extends "res://Utility/AttackDirector.gd"

## Current attack-admission overlay for Prosthetic control effects and Combat V2.
##
## Non-migrated enemies continue using the inherited stable role/token API unchanged.
## Migrated enemies may instead reserve future impact windows through PressureDirectorV2.
## Smoke applies to both paths so V2 pressure admission cannot bypass Prosthetic control.

const DEFAULT_SMOKE_ATTACK_DISTANCE: float = 50.0
const PRESSURE_DIRECTOR_SCRIPT = preload("res://Core/Combat/PressureDirectorV2.gd")

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
	return super.request_role(who, role)


func request_pressure_threat(who: Node, request: Dictionary) -> Dictionary:
	_install_pressure_director_v2()
	var now: float = Time.get_ticks_msec() * 0.001
	if who == null or not is_instance_valid(who) or _pressure_director_v2 == null:
		return {"admitted": false, "retry_at": now + 0.10, "reason": "pressure_unavailable"}
	if _smoke_prevents_new_attack(who, "melee_attack"):
		return {"admitted": false, "retry_at": now + 0.12, "reason": "smoke_disrupted"}

	# During incremental migration, a legacy melee holder remains exclusive. This keeps
	# old enemies safe while multiple V2 Swordsmen can overlap with one another based on
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
	# Swordsman out of its already-admitted attack. The legacy holder collection itself
	# is not modified, so legacy token limits remain unchanged for non-migrated enemies.
	if role == "melee_attack" and has_pressure_reservation(who):
		return true
	return super.is_holding_role(who, role)


func release_all_for(who: Node) -> void:
	if _pressure_director_v2 != null and is_instance_valid(_pressure_director_v2):
		_pressure_director_v2.release_all_for(who, "director_release_all")
	super.release_all_for(who)


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
