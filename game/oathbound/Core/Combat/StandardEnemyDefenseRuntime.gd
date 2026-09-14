extends Node
class_name StandardEnemyDefenseRuntime

## Presentation/identity bridge for ordinary enemies after universal Posture/Deathblow
## was retired. This node does not own Health or interruption logic. It marks the host as
## a standard Health-first enemy and removes legacy floating resource bars and universal
## parry prompts. Explicit special-counter attacks should use their dedicated special cue.
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
const RETIRED_LEGACY_CUE_NAMES: Array[String] = ["ParryIndicator"]


func _ready() -> void:
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return

	enemy.set_meta("standard_enemy_health_only", true)
	enemy.set_meta("standard_enemy_hide_resource_bars", true)
	enemy.set_meta("standard_enemy_special_only_parry", true)
	if not enemy.is_in_group("standard_enemy"):
		enemy.add_to_group("standard_enemy")

	# EnemyBase and some imported actors construct compatibility presentation in the
	# parent's _ready(). Defer cleanup so initialization order cannot leak old meters.
	call_deferred("_retire_standard_presentation")


func _process(_delta: float) -> void:
	# Older attack scripts can re-show their universal ParryIndicator later in combat.
	# Keep that legacy cue retired. Explicit special counters use separate authored cues.
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return
	_hide_named_canvas_items(enemy, RETIRED_LEGACY_CUE_NAMES)


func _retire_standard_presentation() -> void:
	var enemy := get_parent()
	if enemy == null or not is_instance_valid(enemy):
		return

	if enemy.has_method("hide_posture_bar"):
		enemy.call("hide_posture_bar")
	_hide_named_canvas_items(enemy, RETIRED_BAR_NAMES)
	_hide_named_canvas_items(enemy, RETIRED_LEGACY_CUE_NAMES)

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("standard_enemy_health_only_ready", {
			"enemy": CombatTelemetry.snapshot_actor(enemy),
			"has_combat": enemy.get_node_or_null("Combat") != null,
			"resource_bars_hidden": true,
			"legacy_parry_prompt_hidden": true,
		})


func _hide_named_canvas_items(root: Node, names: Array[String]) -> void:
	for child: Node in root.get_children():
		if str(child.name) in names and child is CanvasItem:
			(child as CanvasItem).visible = false
		_hide_named_canvas_items(child, names)
