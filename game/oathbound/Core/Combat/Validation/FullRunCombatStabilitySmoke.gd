extends Node

const RouteGateScript = preload("res://Core/Chambers/RouteGate.gd")
const LingeringWraithRuntime = preload("res://Enemy/Area 2/Encounter/lingering_wraith_runtime.gd")

const PASS_LINE := "[FullRunCombatStabilitySmoke] PASS - deferred gate emission | Lingering Wraith range authority"

var _failures: Array[String] = []
var _gate_signal_count: int = 0


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
	var gate_value: Variant = RouteGateScript.new()
	if not (gate_value is Node2D):
		_failures.append("could not instantiate RouteGate")
		return
	var gate := gate_value as Node2D
	gate.set("locked", false)
	gate.set("entry_grace_seconds", 0.0)
	gate.connect("gate_used", Callable(self, "_on_test_gate_used"))
	add_child(gate)

	var player := CharacterBody2D.new()
	player.name = "GateSmokePlayer"
	player.add_to_group("player")
	add_child(player)

	_gate_signal_count = 0
	gate.call("_on_Area2D_body_entered", player)
	if _gate_signal_count != 0:
		_failures.append("RouteGate emitted gate_used synchronously inside body_entered")

	# call_deferred() is guaranteed to leave the originating callback, but a headless
	# smoke can observe it on the following idle turn rather than the first process
	# frame boundary. Give the deferred queue two frames without weakening the key
	# assertion above that emission never happens synchronously.
	await get_tree().process_frame
	await get_tree().process_frame
	if _gate_signal_count != 1:
		_failures.append("RouteGate deferred gate_used did not emit exactly once")

	player.free()
	gate.free()


func _on_test_gate_used(_gate_type: String) -> void:
	_gate_signal_count += 1


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
