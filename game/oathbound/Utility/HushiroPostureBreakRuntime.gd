extends Node

## Runtime component attached by HushiroEnemyContract to every current Hushiro
## standard enemy. A full shared CombatController posture meter now enters a real
## stagger first, then arms the Deathblow after a short readability beat. This keeps
## the posture-break cue and the execution cue mechanically distinct.

const DEATHBLOW_ARM_DELAY: float = 0.20

var enemy: Node = null
var combat: Node = null
var enemy_type: String = ""
var _break_active: bool = false
var _deathblow_armed: bool = false
var _break_started_at: float = -1.0
var _break_ends_at: float = -1.0


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

	if not _enemy_is_alive():
		if _break_active:
			_exit_break()
		else:
			_clear_ready_marker()
		_clear_forwarded_target_if_owned()
		return

	var ready: bool = _is_shared_posture_broken()
	if ready and not _break_active:
		_enter_break()
	elif not ready and _break_active:
		_exit_break()

	if not ready:
		return

	# Parent enemy physics runs before this child component. Re-cancel every frame so
	# no AI can begin a new attack in the same frame that it is posture-broken.
	_cancel_current_offense()
	if enemy is CharacterBody2D:
		(enemy as CharacterBody2D).velocity = Vector2.ZERO

	if not _deathblow_armed and _now() >= _break_started_at + DEATHBLOW_ARM_DELAY:
		_arm_deathblow()

	enemy.set_meta("_oathbound_deathblow_ready", _deathblow_armed)


func _now() -> float:
	return Time.get_ticks_msec() * 0.001


func _combat_config() -> CombatConfig:
	if combat == null:
		return null
	return combat.get("config") as CombatConfig


func _is_shared_posture_broken() -> bool:
	if not _enemy_is_alive():
		return false
	if combat == null or not combat.has_method("get_posture"):
		return false
	var cfg: CombatConfig = _combat_config()
	if cfg == null:
		return false
	var maximum: float = float(cfg.posture_max)
	var current: float = float(combat.call("get_posture"))
	return maximum > 0.0 and current >= maximum - 0.001


func _enemy_is_alive() -> bool:
	if enemy == null or not is_instance_valid(enemy) or enemy.is_queued_for_deletion():
		return false
	if _has_property(enemy, "has_died") and bool(enemy.get("has_died")):
		return false
	# This runtime is attached only to standard Hushiro enemies. Unlike bosses, they do
	# not intentionally remain executable at zero Health.
	if _has_property(enemy, "hp") and float(enemy.get("hp")) <= 0.0:
		return false
	return true


func _enter_break() -> void:
	_break_active = true
	_deathblow_armed = false
	_break_started_at = _now()
	var duration: float = 2.5
	var cfg: CombatConfig = _combat_config()
	if cfg != null:
		duration = float(cfg.posture_break_duration)
	_break_ends_at = _break_started_at + maxf(duration, DEATHBLOW_ARM_DELAY + 0.05)

	_clear_ready_marker()
	_cancel_current_offense()
	_play_break_animation_if_available()
	_record("enemy_posture_break_enter")


func _arm_deathblow() -> void:
	if not _break_active or _deathblow_armed or not _enemy_is_alive():
		return
	_deathblow_armed = true
	enemy.set_meta("_oathbound_deathblow_ready", true)
	_forward_deathblow_window()
	_record("enemy_deathblow_armed")


func _exit_break() -> void:
	var was_active: bool = _break_active
	_break_active = false
	_deathblow_armed = false
	_clear_ready_marker()
	_clear_forwarded_target_if_owned()
	if was_active:
		_record("enemy_posture_break_exit")
	_break_started_at = -1.0
	_break_ends_at = -1.0


func _clear_ready_marker() -> void:
	if enemy != null and is_instance_valid(enemy):
		enemy.set_meta("_oathbound_deathblow_ready", false)


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
	var remaining: float = maxf(0.05, _break_ends_at - _now())
	player_combat.call("set_deathblow_target", enemy, remaining)


func _clear_forwarded_target_if_owned() -> void:
	var player: Node = get_tree().get_first_node_in_group("player")
	if player == null or not is_instance_valid(player):
		return
	var player_combat: Node = player.get_node_or_null("Combat")
	if player_combat == null:
		return
	if not player_combat.has_method("get_deathblow_target") or not player_combat.has_method("set_deathblow_target"):
		return
	var current: Node = player_combat.call("get_deathblow_target")
	if current == enemy:
		player_combat.call("set_deathblow_target", null, 0.0)


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


func is_break_active() -> bool:
	return _break_active


func is_deathblow_armed() -> bool:
	return _break_active and _deathblow_armed and _enemy_is_alive()


func get_break_ends_at() -> float:
	return _break_ends_at


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
		"break_active": _break_active,
		"deathblow_ready": _deathblow_armed,
		"deathblow_arm_delay": DEATHBLOW_ARM_DELAY,
	})


func _has_property(object: Object, property_name: String) -> bool:
	for property_data: Dictionary in object.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			return true
	return false
