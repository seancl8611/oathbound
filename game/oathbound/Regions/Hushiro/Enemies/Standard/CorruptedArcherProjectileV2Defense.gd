extends "res://Regions/Hushiro/Enemies/Standard/CorruptedArcherProjectile.gd"

## Current Hushiro defense policy for the ordinary Corrupted Archer arrow.
## The projectile remains blockable/dodgeable, but it is not a special parry opportunity.
## Future signature projectiles can opt in by authoring `special_parry=true` instead of
## making reflection the default answer to every ranged shot.


func _ready() -> void:
	super._ready()
	set_meta("special_parry", false)
	set_meta("parryable", false)


func _check_player_parrying(player: Node) -> bool:
	if player == null:
		return false
	if player.has_method("can_parry_incoming_attack"):
		return (
			bool(player.call("can_parry_incoming_attack", self, "arrow"))
			and super._check_player_parrying(player)
		)
	return false
