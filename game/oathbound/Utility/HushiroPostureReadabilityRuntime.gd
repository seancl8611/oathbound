extends Node

## Player-facing posture readability bridge for current Hushiro standard enemies.
##
## HushiroEnemyContract normalizes CombatController posture configuration after the
## enemy's _ready() path has already built its PostureBar. CombatController remains the
## mechanical authority; this runtime only mirrors that canonical value into the
## existing EnemyBase presentation so Posture buildup and Deathblow approach cannot
## become invisible because a later runtime layer missed a posture_changed refresh.

var enemy: Node = null
var combat: Node = null


func configure(owner_enemy: Node) -> void:
	enemy = owner_enemy
	if enemy != null:
		combat = enemy.get_node_or_null("Combat")


func _ready() -> void:
	# Run after the parent enemy and the shared posture-break component. This is a
	# presentation reconciliation pass only; it never mutates posture or break state.
	process_physics_priority = 150
	if enemy == null:
		enemy = get_parent()
	if combat == null and enemy != null:
		combat = enemy.get_node_or_null("Combat")
	sync_now()


func _physics_process(_delta: float) -> void:
	sync_now()


func sync_now() -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	if combat == null or not is_instance_valid(combat):
		combat = enemy.get_node_or_null("Combat")
	if combat == null or not is_instance_valid(combat):
		return
	if not combat.has_method("get_posture") or not enemy.has_method("_update_posture_bar"):
		return

	var cfg_value: Variant = combat.get("config")
	if cfg_value == null:
		return
	var maximum_value: Variant = cfg_value.get("posture_max")
	if maximum_value == null:
		return

	var current: float = float(combat.call("get_posture"))
	var maximum: float = float(maximum_value)
	enemy.call("_update_posture_bar", current, maximum)
