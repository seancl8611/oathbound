extends Node

## Runtime component attached by HushiroEnemyContract to every current Hushiro
## standard enemy. It turns a full shared CombatController posture meter into an
## explicit, observable Deathblow-ready state and prevents ordinary AI movement or
## attack commitment from visually overriding that break window.

var enemy: Node = null
var combat: Node = null
var enemy_type: String = ""
var _break_active: bool = false


func configure(owner_enemy: Node, type_id: String) -> void:
	enemy = owner_enemy
	enemy_type = type_id
	if enemy != null:
		combat = enemy.get_node_or_null("Combat")


func _ready() -> void:
	process_physics_priority = 100
	if enemy == null:
		enemy = get_parent()
	if combat == null and enemy != null:
		combat = enemy.get_node_or_null("Combat")


func _physics_process(_delta: float) -> void:
	if enemy == null or not is_instance_valid(enemy) or combat == null or not is_instance_valid(combat):
		return

	var ready: bool = _is_shared_posture_broken()
	if ready and not _break_active:
		_enter_break()
	elif not ready and _break_active:
		_exit_break()

	if ready:
		# Parent enemy physics runs before this child component. Zeroing velocity here
		# ensures a broken enemy cannot continue a chase/lunge after its own AI update.
		if enemy is CharacterBody2D:
			(enemy as CharacterBody2D).velocity = Vector2.ZERO
		enemy.set_meta("_oathbound_deathblow_ready", true)


func _combat_config() -> CombatConfig:
	if combat == null:
		return null
	return combat.get("config") as CombatConfig


func _is_shared_posture_broken() -> bool:
	if combat == null or not combat.has_method("get_posture"):
		return false
	var cfg: CombatConfig = _combat_config()
	if cfg == null:
		return false
	var maximum: float = float(cfg.posture_max)
	var current: float = float(combat.call("get_posture"))
	return maximum > 0.0 and current >= maximum - 0.001


func _enter_break() -> void:
	_break_active = true
	enemy.set_meta("_oathbound_deathblow_ready", true)
	_cancel_current_offense()
	_forward_deathblow_window()
	_play_break_animation_if_available()
	_record("enemy_posture_break_enter")


func _exit_break() -> void:
	_break_active = false
	if enemy != null and is_instance_valid(enemy):
		enemy.set_meta("_oathbound_deathblow_ready", false)
	_record("enemy_posture_break_exit")


func _cancel_current_offense() -> void:
	if enemy == null:
		return
	# Known Hushiro/imported attack-cancellation seams. Avoid generic guessed calls
	# with unknown signatures.
	if enemy.has_method("_cancel_current_action"):
		enemy.call("_cancel_current_action", 0.0)
	if enemy.has_method("_cancel_beast_attack"):
		enemy.call("_cancel_beast_attack", true)
	if enemy.has_method("_release_attack_token"):
		enemy.call("_release_attack_token")
	if enemy.has_method("_release_role"):
		enemy.call("_release_role", "advance_move")
	if enemy is CharacterBody2D:
		(enemy as CharacterBody2D).velocity = Vector2.ZERO


func _forward_deathblow_window() -> void:
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null or not is_instance_valid(player):
		return
	var player_combat: Node = player.get_node_or_null("Combat")
	if player_combat == null or not player_combat.has_method("set_deathblow_target"):
		return
	var duration: float = 2.5
	var cfg: CombatConfig = _combat_config()
	if cfg != null:
		duration = float(cfg.posture_break_duration)
	player_combat.call("set_deathblow_target", enemy, duration)


func _play_break_animation_if_available() -> void:
	var animation: AnimationPlayer = null
	if enemy.has_method("get_animation_node"):
		var animation_value: Variant = enemy.call("get_animation_node")
		if animation_value is AnimationPlayer:
			animation = animation_value as AnimationPlayer
	if animation == null:
		animation = enemy.get_node_or_null("AnimationPlayer") as AnimationPlayer
	if animation == null:
		return
	for animation_name: String in ["deathblow_ready", "posture_broken", "parried_recoil", "parried", "hurt"]:
		if animation.has_animation(animation_name):
			animation.play(animation_name)
			return


func _record(event_name: String) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	var current: float = float(combat.call("get_posture")) if combat != null and combat.has_method("get_posture") else 0.0
	var maximum: float = 0.0
	var cfg: CombatConfig = _combat_config()
	if cfg != null:
		maximum = float(cfg.posture_max)
	CombatTelemetry.record_event(event_name, {
		"enemy_type": enemy_type,
		"enemy": CombatTelemetry.snapshot_actor(enemy),
		"posture": current,
		"posture_max": maximum,
		"deathblow_ready": _break_active,
	})
