extends Node2D

## Current prototype wrapper for the Eternal Swordsman duel.
## Reuses the mature Court sword/parry/counter runtime while explicitly removing the
## Court Guard revival mechanic. This keeps the encounter a single focused martial
## duel as approved, without freezing final phase counts, VFX, or animation scope.

signal defeated

@export var duel_hp: int = 430
@export var attack_cooldown_scale: float = 0.82
@export var posture_break_duration: float = 2.4

@onready var swordsman: Node = get_node_or_null("Swordsman")
var _resolved := false
var _duel_activated := false


func _ready() -> void:
	add_to_group("miniboss")
	set_meta("boss_area", 3)
	if swordsman == null:
		push_error("[EternalSwordsman] Missing mature Court sword runtime")
		call_deferred("_resolve_missing_runtime")
		return

	# Children become ready before their parent, so re-baseline the mature runtime now.
	if "hp" in swordsman:
		swordsman.set("hp", duel_hp)
	if "_max_hp" in swordsman:
		swordsman.set("_max_hp", duel_hp)
	if "_has_revived" in swordsman:
		swordsman.set("_has_revived", true)
	if "posture_break_duration" in swordsman:
		swordsman.set("posture_break_duration", posture_break_duration)
	if "attack_cooldown_min" in swordsman:
		swordsman.set("attack_cooldown_min", float(swordsman.get("attack_cooldown_min")) * attack_cooldown_scale)
	if "attack_cooldown_max" in swordsman:
		swordsman.set("attack_cooldown_max", float(swordsman.get("attack_cooldown_max")) * attack_cooldown_scale)
	if "combo3_chance" in swordsman:
		swordsman.set("combo3_chance", maxf(0.45, float(swordsman.get("combo3_chance"))))
	if "charge_chance" in swordsman:
		swordsman.set("charge_chance", maxf(0.34, float(swordsman.get("charge_chance"))))

	var visual := swordsman.get_node_or_null("Sprite2D")
	if visual is CanvasItem:
		(visual as CanvasItem).modulate = Color(0.78, 0.9, 1.15, 0.92)

	if swordsman.has_signal("enemy_died"):
		swordsman.connect("enemy_died", Callable(self, "_on_swordsman_died"))
	elif swordsman.has_signal("defeated"):
		swordsman.connect("defeated", Callable(self, "_on_swordsman_defeated"))
	else:
		push_error("[EternalSwordsman] Duel runtime exposes no supported defeat signal")

	# MinibossChamber adds the wrapper before assigning its final spawn position. The
	# embedded Court Guard therefore completes _ready() at the pre-spawn transform.
	# Activate one deferred boundary later so patrol/home state is re-based after the
	# chamber has moved the wrapper, and explicitly engage this authored solo duel.
	call_deferred("_activate_duel_runtime")


func _activate_duel_runtime() -> void:
	if _duel_activated or _resolved:
		return
	if swordsman == null or not is_instance_valid(swordsman) or not swordsman.is_inside_tree():
		return

	_duel_activated = true
	if swordsman is Node2D:
		var live_position: Vector2 = (swordsman as Node2D).global_position
		if "_home_pos" in swordsman:
			swordsman.set("_home_pos", live_position)
		if "_patrol_target" in swordsman:
			swordsman.set("_patrol_target", live_position)
		if "_patrol_last_pos" in swordsman:
			swordsman.set("_patrol_last_pos", live_position)

	if swordsman.has_method("engage"):
		swordsman.call("engage")
	else:
		if "_saw_player_once" in swordsman:
			swordsman.set("_saw_player_once", true)
		if "auto_aggro_on_spawn" in swordsman:
			swordsman.set("auto_aggro_on_spawn", true)

	print("[EternalSwordsman] focused Court duel active | revival disabled | engagement armed")


func _on_swordsman_died(_enemy: Node) -> void:
	_resolve_defeat()


func _on_swordsman_defeated() -> void:
	_resolve_defeat()


func _resolve_missing_runtime() -> void:
	_resolve_defeat()


func _resolve_defeat() -> void:
	if _resolved:
		return
	_resolved = true
	emit_signal("defeated")
	print("[EternalSwordsman] duel defeated")