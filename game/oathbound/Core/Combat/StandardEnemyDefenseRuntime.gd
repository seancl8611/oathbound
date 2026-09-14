extends Node
class_name StandardEnemyDefenseRuntime

## Presentation/identity bridge for ordinary enemies after universal Posture/Deathblow
## was retired. This node does not own Health or interruption logic. It marks the host as
## a standard Health-first enemy and removes legacy floating resource bars. Health remains
## authoritative for defeat, but standard-enemy Health is communicated through damage,
## hit reactions, silhouette/VFX, and death rather than a permanent overhead meter.
##
## Scenes that still contain a Combat node should pair this runtime with
## StandardEnemyCombatController. Scenes with no Combat node only need this runtime.

const RETIRED_BAR_NAMES: Array[String] = [
	"PostureBar",
	"HealthBar",
	"HealthBarRoot",
	"HPBar",
	"HpBar",
	"EnemyHealthBar",
]


func _ready() -> void:
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return

	enemy.set_meta("standard_enemy_health_only", true)
	enemy.set_meta("standard_enemy_hide_resource_bars", true)
	if not enemy.is_in_group("standard_enemy"):
		enemy.add_to_group("standard_enemy")

	# EnemyBase and some imported actors construct compatibility bars in the parent's
	# _ready(). Defer cleanup so every standard scene converges on the same bar-free
	# presentation regardless of initialization order.
	call_deferred("_retire_standard_resource_presentation")


func _retire_standard_resource_presentation() -> void:
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return

	if enemy.has_method("hide_posture_bar"):
		enemy.call("hide_posture_bar")
	_hide_named_resource_bars(enemy)

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("standard_enemy_health_only_ready", {
			"enemy": CombatTelemetry.snapshot_actor(enemy),
			"has_combat": enemy.get_node_or_null("Combat") != null,
			"resource_bars_hidden": true,
		})


func _hide_named_resource_bars(root: Node) -> void:
	for child: Node in root.get_children():
		var child_name := str(child.name)
		if child_name in RETIRED_BAR_NAMES and child is CanvasItem:
			(child as CanvasItem).visible = false
		_hide_named_resource_bars(child)
