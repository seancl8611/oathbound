extends Node
class_name HushiroStandardNoPostureRuntime

## Compatibility boundary for Hushiro standard enemies after the V2 defense rewrite.
## Standard enemies no longer own player-facing Health/Posture bars or a Posture-driven
## Deathblow state. CombatController remains attached because imported controllers use it
## for unrelated combat timing, but any Posture mutation is synchronously neutralized
## before CombatController can evaluate a break.
##
## Ordinary attacks also no longer advertise the legacy universal parry diamond. Explicit
## special-counter attacks keep their dedicated authored cue instead.

const RETIRED_BAR_NAMES: Array[String] = [
	"PostureBar",
	"HealthBar",
	"HealthBarRoot",
	"HPBar",
	"HpBar",
	"EnemyHealthBar",
]
const RETIRED_LEGACY_CUE_NAMES: Array[String] = ["ParryIndicator"]

var enemy: Node = null
var combat: Node = null
var _neutralizing: bool = false


func configure(owner_enemy: Node) -> void:
	enemy = owner_enemy
	if enemy != null:
		combat = enemy.get_node_or_null("Combat")


func _ready() -> void:
	if enemy == null:
		enemy = get_parent()
	if combat == null and enemy != null:
		combat = enemy.get_node_or_null("Combat")

	if enemy != null and is_instance_valid(enemy):
		enemy.set_meta("standard_enemy_health_only", true)
		enemy.set_meta("standard_enemy_hide_resource_bars", true)
		enemy.set_meta("standard_enemy_special_only_parry", true)
		if not enemy.is_in_group("standard_enemy"):
			enemy.add_to_group("standard_enemy")

	_retire_legacy_posture_helpers()
	_connect_posture_guard()
	_neutralize_posture_state()
	call_deferred("_retire_standard_presentation")


func _process(_delta: float) -> void:
	# A few imported standard attack scripts can re-show ParryIndicator during windup.
	# Keep that universal cue retired. Special counters use separate authored cues.
	if enemy == null or not is_instance_valid(enemy):
		return
	_hide_named_canvas_items(enemy, RETIRED_LEGACY_CUE_NAMES)


func is_posture_retired() -> bool:
	return true


func _connect_posture_guard() -> void:
	if combat == null or not is_instance_valid(combat):
		return
	if not combat.has_signal("posture_changed"):
		return
	var callback := Callable(self, "_on_posture_changed")
	if not combat.is_connected("posture_changed", callback):
		combat.connect("posture_changed", callback)


func _on_posture_changed(_current: float, _maximum: float) -> void:
	# CombatController emits posture_changed before it checks the break threshold.
	# Resetting its compatibility field inside this synchronous callback guarantees
	# ordinary standard-enemy contacts can never accumulate into posture_broken.
	_neutralize_posture_state()


func _neutralize_posture_state() -> void:
	if _neutralizing:
		return
	_neutralizing = true

	if combat != null and is_instance_valid(combat):
		combat.set("_posture", 0.0)
		combat.set("_break_until_ts", -1.0)
		combat.set("_recovery_suppressed_until", -1.0)

	if enemy != null and is_instance_valid(enemy):
		_set_property_if_present(enemy, "posture", 0.0)
		_set_property_if_present(enemy, "_dbroken_active", false)
		_retire_standard_presentation()

	_neutralizing = false


func _retire_legacy_posture_helpers() -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	for child_name: String in ["HushiroPostureBreakRuntime", "HushiroPostureReadabilityRuntime"]:
		var helper := enemy.get_node_or_null(child_name)
		if helper == null:
			continue
		helper.set_process(false)
		helper.set_physics_process(false)
		helper.queue_free()


func _retire_standard_presentation() -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	if enemy.has_method("hide_posture_bar"):
		enemy.call("hide_posture_bar")
	_hide_named_canvas_items(enemy, RETIRED_BAR_NAMES)
	_hide_named_canvas_items(enemy, RETIRED_LEGACY_CUE_NAMES)

	var ui_value: Variant = enemy.get("_posture_ui") if _has_property(enemy, "_posture_ui") else null
	if ui_value is CanvasItem:
		(ui_value as CanvasItem).visible = false


func _hide_named_canvas_items(root: Node, names: Array[String]) -> void:
	for child: Node in root.get_children():
		if str(child.name) in names and child is CanvasItem:
			(child as CanvasItem).visible = false
		_hide_named_canvas_items(child, names)


func _set_property_if_present(object: Object, property_name: String, value: Variant) -> void:
	if _has_property(object, property_name):
		object.set(property_name, value)


func _has_property(object: Object, property_name: String) -> bool:
	if object == null or not is_instance_valid(object):
		return false
	for property_data: Dictionary in object.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			return true
	return false