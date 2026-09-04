extends Node

const ROUTE_GATE_SCENE: PackedScene = preload("res://Core/Chambers/RouteGate.tscn")
const LingeringWraithRuntime = preload("res://Enemy/Area 2/Encounter/lingering_wraith_runtime.gd")

const PASS_LINE := "[FullRunCombatStabilitySmoke] PASS - deferred gate emission | Lingering Wraith range authority"

var _failures: Array[String] = []
var _gate_signal_count: int = 0
var _gate_test_player: CharacterBody2D = null


func _ready() -> void:
	await _check_route_gate_deferred_emission()
	_check_lingering_wraith_attack_ranges()

	if _failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return

	for failure: String in _failures:
		push_error("[FullRunCombatStabilitySmoke] " + failure)
	get_tree().quit(1)


func _check_route_gate_deferred_emission() -> void:
	# Use the real authored gate scene and let Godot generate the body_entered signal
	# from an actual physics overlap. The listener deliberately frees a CollisionObject,
	# mirroring the Heart-Handoff scene replacement that produced the September 4
	# engine error. If gate_used is still emitted inside the physics callback, Godot will
	# print the same CollisionObject-removal ERROR and CI rejects this smoke's log.
	var gate_value: Variant = ROUTE_GATE_SCENE.instantiate()
	if not (gate_value is Node2D):
		_failures.append("could not instantiate authored RouteGate scene")
		return
	var gate := gate_value as Node2D
	gate.set("locked", false)
	gate.set("entry_grace_seconds", 0.0)
	gate.connect("gate_used", Callable(self, "_on_test_gate_used"))
	add_child(gate)

	_gate_test_player = CharacterBody2D.new()
	_gate_test_player.name = "GateSmokePlayer"
	_gate_test_player.add_to_group("player")
	_gate_test_player.collision_layer = 1
	_gate_test_player.collision_mask = 1
	var collision := CollisionShape2D.new()
	collision.name = "CollisionShape2D"
	var shape := CircleShape2D.new()
	shape.radius = 8.0
	collision.shape = shape
	_gate_test_player.add_child(collision)
	add_child(_gate_test_player)

	_gate_signal_count = 0
	# RouteGate._ready() applies monitoring/shape state with deferred physics-server
	# mutation. Give those changes one idle turn, then let the next real physics tick
	# detect the overlapping Player body.
	await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().process_frame
	await get_tree().process_frame

	if _gate_signal_count != 1:
		_failures.append("authored RouteGate overlap did not defer and emit gate_used exactly once")

	if is_instance_valid(_gate_test_player):
		_gate_test_player.free()
	_gate_test_player = null
	if is_instance_valid(gate):
		gate.free()


func _on_test_gate_used(_gate_type: String) -> void:
	_gate_signal_count += 1
	# This is intentionally immediate. The production fix's responsibility is to make
	# sure listeners reach this point only after leaving Area2D.body_entered. If this
	# executes from the physics callback, Godot itself emits the exact error we saw in
	# the full run and the workflow's ERROR grep fails.
	if is_instance_valid(_gate_test_player):
		_gate_test_player.free()
		_gate_test_player = null


func _check_lingering_wraith_attack_ranges() -> void:
	var wraith_value: Variant = LingeringWraithRuntime.new()
	if not (wraith_value is Node):
		_failures.append("could not instantiate Lingering Wraith runtime")
		return
	var wraith: Node = wraith_value as Node

	# Test the pure range/cooldown seam rather than unrelated live-state guards such as
	# confusion, attack-in-progress, or death state. Production _can_start... delegates
	# to this exact seam only after those guards pass.
	var now := Time.get_ticks_msec() * 0.001
	wraith.set("_last_charge_time", now)
	if bool(wraith.call("_has_legal_attack_at_distance", 170.0)):
		_failures.append("Lingering Wraith still has a legal non-charge attack at 170 px")

	# When charge is ready at the same distance, the long-range perilous attack remains
	# legal and must be the only selectable attack.
	var charge_cooldown := float(wraith.get("charge_cooldown"))
	wraith.set("_last_charge_time", now - charge_cooldown - 1.0)
	if not bool(wraith.call("_has_legal_attack_at_distance", 170.0)):
		_failures.append("Lingering Wraith lost its authored long-range charge")
	else:
		for _i in range(8):
			if int(wraith.call("_select_wraith_attack", 170.0)) != 4:
				_failures.append("Lingering Wraith selected an ordinary attack at 170 px")
				break

	# Around 100 px, with charge on cooldown, the authored running swing is the legal
	# gap closer; ordinary 48-62 px swings still must not be selected.
	now = Time.get_ticks_msec() * 0.001
	wraith.set("_last_charge_time", now)
	if not bool(wraith.call("_has_legal_attack_at_distance", 100.0)):
		_failures.append("Lingering Wraith running gap-close range became unavailable")
	else:
		for _i in range(8):
			if int(wraith.call("_select_wraith_attack", 100.0)) != 3:
				_failures.append("Lingering Wraith selected an ordinary attack outside normal start range")
				break

	wraith.free()
