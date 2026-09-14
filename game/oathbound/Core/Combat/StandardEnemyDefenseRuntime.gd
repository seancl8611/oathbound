extends Node
class_name StandardEnemyDefenseRuntime

## Presentation/identity bridge for ordinary enemies after universal Posture/Deathblow
## was retired. This node does not own Health or interruption logic. It marks the host as
## a standard Health-first enemy and removes the inherited Posture presentation that
## older EnemyBase descendants may still construct during _ready().
##
## Scenes that still contain a Combat node should pair this runtime with
## StandardEnemyCombatController. Scenes with no Combat node only need this runtime.

func _ready() -> void:
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return

	enemy.set_meta("standard_enemy_health_only", true)
	if not enemy.is_in_group("standard_enemy"):
		enemy.add_to_group("standard_enemy")

	# EnemyBase creates its compatibility bar in the parent's _ready(), which runs after
	# child _ready() callbacks. Defer the presentation cleanup one frame so both old and
	# migrated standard scenes converge on the same Health-only presentation.
	call_deferred("_retire_posture_presentation")


func _retire_posture_presentation() -> void:
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return

	if enemy.has_method("hide_posture_bar"):
		enemy.call("hide_posture_bar")

	var posture_bar := enemy.get_node_or_null("PostureBar") as CanvasItem
	if posture_bar != null:
		posture_bar.visible = false

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("standard_enemy_health_only_ready", {
			"enemy": CombatTelemetry.snapshot_actor(enemy),
			"has_combat": enemy.get_node_or_null("Combat") != null,
		})
