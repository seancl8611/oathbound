extends CharacterBody2D
class_name ShieldEnemy

## Legacy parser-compatibility shell for the imported ShieldFormationController.
##
## The original ShieldEnemy implementation was not present in the migrated source,
## but ShieldFormationController still has static type annotations for it. Oathbound's
## current launch design does not depend on this legacy formation system. This shell
## exists only so Godot can parse the old controller while the obsolete system is
## audited/retired during content reconciliation.

signal ring_guard_died

var home: Vector2 = Vector2.ZERO
var facing: Vector2 = Vector2.RIGHT
var knockback: Vector2 = Vector2.ZERO


func configure_as_ring_guard(slot_position: Vector2, center: Vector2, _legacy_mode = null, _legacy_arc = null) -> void:
	# The imported ShieldFormationController calls this legacy method with three
	# arguments, while older variants used four. Optional compatibility parameters
	# intentionally accept either shape until this obsolete formation system is removed.
	home = slot_position
	var to_center := center - global_position
	if to_center.length_squared() > 0.001:
		facing = to_center.normalized()


func start_flee() -> void:
	# Compatibility no-op. No current launch scene should instantiate this shell.
	pass


func set_ring_wall_mode(_active: bool) -> void:
	# Compatibility no-op. No current launch scene should instantiate this shell.
	pass
