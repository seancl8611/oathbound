extends "res://Utility/AttackDirector.gd"

## Current attack-admission overlay for Prosthetic control effects.
## Smoke only denies NEW player-targeted attacks while a disrupted ordinary enemy is
## farther than the approved close-range exception. Existing role holders are allowed
## to finish committed attacks normally.

const DEFAULT_SMOKE_ATTACK_DISTANCE: float = 50.0


func request_role(who: Node, role: String) -> bool:
	if who != null and is_instance_valid(who) and is_holding_role(who, role):
		return true
	if _smoke_prevents_new_attack(who, role):
		return false
	return super.request_role(who, role)


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
