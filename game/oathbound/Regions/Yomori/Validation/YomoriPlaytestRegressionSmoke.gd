extends Node

## Regression coverage for blockers reproduced by the September 3 Yomori manual playtest:
## - Mist Shepherd must classify as an enemy before child HurtBox _ready() and accept player attacks;
## - merchant gates must ignore the persistent Player's stale re-parent position during room load;
## - Lantern Wraith temporary wave/pulse lifetime callbacks must not retain freed lambda captures.

const MIST_SHEPHERD_SCENE: PackedScene = preload("res://Enemy/Area 2/Encounter/Mist_Shepherd.tscn")
const LANTERN_WRAITH_SCENE: PackedScene = preload("res://Enemy/Area 2/Encounter/lantern_wraith.tscn")
const MERCHANT_SCENE: PackedScene = preload("res://Core/Chambers/Types/MerchantChamber.tscn")

var _failures: Array[String] = []
var _player: CharacterBody2D


func _ready() -> void:
	_player = CharacterBody2D.new()
	_player.name = "RegressionPlayer"
	_player.add_to_group("player")
	add_child(_player)
	await get_tree().process_frame

	await _validate_mist_shepherd_targetability()
	await _validate_merchant_entry_grace()
	await _validate_lantern_temporary_attack_lifetimes()

	if _failures.is_empty():
		print("[YomoriPlaytestRegressionSmoke] PASS - Mist Shepherd targetable | merchant entry grace | Lantern temporary callbacks safe")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[YomoriPlaytestRegressionSmoke] %s" % failure)
		print("[YomoriPlaytestRegressionSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_mist_shepherd_targetability() -> void:
	var shepherd: Node = MIST_SHEPHERD_SCENE.instantiate()
	_expect(shepherd.is_in_group("enemy"), "Mist Shepherd root is not authored into the enemy group before _ready()")
	add_child(shepherd)
	await get_tree().process_frame

	var hurtbox: Node = shepherd.get_node_or_null("HurtBox")
	_expect(hurtbox != null, "Mist Shepherd HurtBox missing")
	if hurtbox == null:
		shepherd.queue_free()
		return
	_expect(int(hurtbox.get("HurtBoxType")) == 1, "Mist Shepherd HurtBox is not explicitly Enemy type")
	_expect(bool(hurtbox.get("_is_enemy_hurtbox")), "Mist Shepherd HurtBox classified itself as non-enemy during child _ready()")
	_expect(not bool(hurtbox.call("_is_friendly_fire", _player)), "Mist Shepherd HurtBox rejects player-owned attacks as friendly fire")

	var attack := Area2D.new()
	attack.name = "RegressionSwordAttack"
	attack.add_to_group("attack")
	attack.set_meta("attacker", _player)
	attack.set_meta("health_damage", 5)
	attack.set_meta("damage", 5)
	attack.set_meta("posture_damage", 4.0)
	attack.set_meta("block_posture_damage", 4.0)
	attack.set_meta("damage_type", "sword_light")
	attack.set_meta("attack_id", "regression_quick_slash")
	add_child(attack)
	await get_tree().process_frame

	var hp_before: int = int(shepherd.get("hp"))
	hurtbox.call("_on_area_entered", attack)
	await get_tree().process_frame
	_expect(int(shepherd.get("hp")) < hp_before, "Mist Shepherd did not lose Health from a player-owned sword contact")

	attack.queue_free()
	shepherd.queue_free()
	await get_tree().process_frame


func _validate_merchant_entry_grace() -> void:
	var merchant: Node = MERCHANT_SCENE.instantiate()
	add_child(merchant)
	await get_tree().process_frame
	await get_tree().process_frame

	var gate: Node = merchant.get_node_or_null("ExitGate")
	_expect(gate != null, "Merchant ExitGate missing")
	if gate == null:
		merchant.queue_free()
		return
	_expect(float(gate.get("entry_grace_seconds")) >= 0.20, "Merchant gate does not opt into stale-position entry grace")
	if gate.has_method("unlock"):
		gate.call("unlock")

	# Reproduce the loader race directly: the persistent Player is re-parented while it
	# still overlaps coordinates inherited from the previous room. That first overlap
	# must not consume an optional merchant exit.
	gate.call("_on_Area2D_body_entered", _player)
	_expect(not bool(gate.get("_used")), "Merchant gate consumed the Player during its room-entry grace window")

	await get_tree().create_timer(0.30).timeout
	gate.call("_on_Area2D_body_entered", _player)
	_expect(bool(gate.get("_used")), "Merchant gate did not become usable after the entry grace window")

	merchant.queue_free()
	await get_tree().process_frame


func _validate_lantern_temporary_attack_lifetimes() -> void:
	var lantern: Node = LANTERN_WRAITH_SCENE.instantiate()
	add_child(lantern)
	await get_tree().process_frame

	# The old implementation used SceneTreeTimer lambdas that captured the wave/pulse
	# Object. Freeing the temporary attack before those timers fired reproduced the
	# engine error: "Lambda capture at index 0 was freed. Passed null instead."
	lantern.call("_spawn_wave_projectile", Vector2.RIGHT, 1000.0)
	await get_tree().process_frame
	var wave := _find_named_node("LanternWave")
	_expect(wave != null, "Lantern regression could not spawn LanternWave")
	if wave != null:
		wave.free()
	await get_tree().create_timer(0.85).timeout

	lantern.call("_spawn_aoe_pulse", Vector2.ZERO)
	await get_tree().process_frame
	var pulse := _find_named_node("LanternRepulse")
	_expect(pulse != null, "Lantern regression could not spawn LanternRepulse")
	if pulse != null:
		pulse.free()
	await get_tree().create_timer(0.25).timeout

	lantern.queue_free()
	await get_tree().process_frame


func _find_named_node(node_name: String) -> Node:
	for child: Node in get_tree().current_scene.get_children():
		if child.name == node_name:
			return child
	return null


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
