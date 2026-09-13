extends "res://Core/Combat/ArcherProjectileCounterCue.gd"

## Ordinary arrows rely on trajectory/body readability and do not advertise a parry.
## Keep the geometry-aware counter cue available for future explicitly-authored special
## projectiles without paying the visual cost on every ranged shot.


func _update_counter_cue() -> void:
	var projectile := get_parent()
	if projectile == null or not is_instance_valid(projectile) or not bool(projectile.get_meta("special_parry", false)):
		_hide_cue()
		return
	super._update_counter_cue()
