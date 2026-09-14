extends "res://Utility/CombatController.gd"
class_name StandardEnemyCombatController

## Compatibility controller for ordinary enemies after the universal Posture/Deathblow
## loop was retired. It deliberately preserves CombatController's non-Posture API so
## imported Area 2/3 actors do not need to be rewritten just to stop participating in
## the old Sekiro-style meter game.
##
## Standard enemies are defeated through Health. Interruption resistance belongs to
## EnemyCombatResponseRuntime/Poise when that package is installed by the actor. Bosses,
## minibosses, and explicitly authored execution encounters must continue using the
## normal CombatController instead of this subclass.

func _ready() -> void:
	super._ready()
	call_deferred("_retire_standard_enemy_posture_presentation")


func _retire_standard_enemy_posture_presentation() -> void:
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return
	enemy.set_meta("standard_enemy_health_only", true)
	if not enemy.is_in_group("standard_enemy"):
		enemy.add_to_group("standard_enemy")
	if enemy.has_method("hide_posture_bar"):
		enemy.call("hide_posture_bar")
	var posture_bar := enemy.get_node_or_null("PostureBar") as CanvasItem
	if posture_bar != null:
		posture_bar.visible = false


func notify_got_hit(_event: Dictionary) -> void:
	# Standard enemies never convert incoming contacts into Posture.
	pass


func _add_posture(_amount: float) -> void:
	pass


func _posture_passive_recover(_delta: float) -> void:
	pass


func _reset_posture_after_break() -> void:
	pass


func get_posture() -> float:
	return 0.0


func get_posture_ratio() -> float:
	return 0.0


func set_posture(_value: float) -> void:
	# Compatibility no-op for imported standard-enemy scripts.
	pass


func add_posture(_amount: float) -> void:
	# Compatibility no-op. Poise/interruption is resolved independently.
	pass


func reset_posture() -> void:
	pass


func suppress_recovery(_duration: float) -> void:
	# There is no standard-enemy Posture recovery to suppress.
	pass


func get_recovery_state() -> String:
	return "retired"
