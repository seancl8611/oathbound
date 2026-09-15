extends Node

## Validates the V2 production-GLB handoff diagnostics without assuming that any final
## asset has landed yet. A canonical path existing, a role being spawned, and a final GLB
## actually being accepted are deliberately separate states.

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridgeV2.gd")
const ROLES: Array[String] = ["player", "swordsman", "hound", "hollow", "archer", "bilemass", "warden"]

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var room := Node2D.new()
	room.name = "ProductionModelStateSmokeRoom"

	var background := Sprite2D.new()
	background.name = "Background"
	room.add_child(background)
	var presentation := Node2D.new()
	presentation.name = "ThreeQuarterPresentation"
	room.add_child(presentation)
	var scenery := Node2D.new()
	scenery.name = "Scenery"
	presentation.add_child(scenery)
	var combat_fx := Node2D.new()
	combat_fx.name = "CombatFX"
	presentation.add_child(combat_fx)

	for index: int in range(ROLES.size()):
		var role := ROLES[index]
		var actor := CharacterBody2D.new()
		actor.name = "ProductionState_%s" % role
		actor.position = Vector2(float(index * 48), float((index % 2) * 40))
		if role == "player":
			actor.add_to_group("player")
		else:
			actor.add_to_group("enemy")
			actor.set_meta("presentation_role", role)
			actor.set_meta("hushiro_enemy_type", role)
		var legacy_body := Sprite2D.new()
		legacy_body.name = "LegacyBody"
		actor.add_child(legacy_body)
		room.add_child(actor)

	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("V2 bridge failed to instantiate")
		_finish()
		return
	var bridge := bridge_value as Node
	bridge.name = "Planar3DPresentationBridge"
	room.add_child(bridge)
	add_child(room)

	for _i: int in range(10):
		await get_tree().process_frame

	var state_value: Variant = bridge.call("get_presentation_state")
	if not (state_value is Dictionary):
		_fail("production model diagnostics state unavailable")
		room.queue_free()
		await get_tree().process_frame
		_finish()
		return
	var state := state_value as Dictionary

	_expect(int(state.get("production_model_slot_count", 0)) == ROLES.size(), "canonical production model slot count drifted")
	var exists_value: Variant = state.get("production_model_slot_exists_by_role", {})
	var spawned_value: Variant = state.get("production_model_spawned_by_role", {})
	var active_value: Variant = state.get("production_model_active_by_role", {})
	if not (exists_value is Dictionary and spawned_value is Dictionary and active_value is Dictionary):
		_fail("production model existence/spawned/active maps unavailable")
	else:
		var exists_map := exists_value as Dictionary
		var spawned_map := spawned_value as Dictionary
		var active_map := active_value as Dictionary
		var counted_exists := 0
		var counted_active := 0
		for role: String in ROLES:
			_expect(exists_map.has(role), "slot-existence diagnostics missing role %s" % role)
			_expect(spawned_map.has(role), "spawn diagnostics missing role %s" % role)
			_expect(active_map.has(role), "active-GLB diagnostics missing role %s" % role)
			_expect(bool(spawned_map.get(role, false)), "representative role was not marked spawned: %s" % role)
			var slot_exists := bool(exists_map.get(role, false))
			var final_active := bool(active_map.get(role, false))
			if slot_exists:
				counted_exists += 1
			if final_active:
				counted_active += 1
				_expect(slot_exists, "role-specific GLB active without canonical slot resource: %s" % role)
			if not slot_exists:
				_expect(not final_active, "missing production slot incorrectly reported active: %s" % role)
		_expect(int(state.get("production_model_slot_exists_count", -1)) == counted_exists, "production model existence count disagrees with role map")
		_expect(int(state.get("production_model_active_count", -1)) == counted_active, "production model active count disagrees with role map")

	# Compatibility `ready` fields remain an existence alias until old telemetry consumers
	# are retired. They must not diverge from the explicit slot-existence state.
	var ready_value: Variant = state.get("production_model_ready_by_role", {})
	if ready_value is Dictionary and exists_value is Dictionary:
		var ready_map := ready_value as Dictionary
		var exists_map := exists_value as Dictionary
		for role: String in ROLES:
			_expect(bool(ready_map.get(role, false)) == bool(exists_map.get(role, false)), "legacy ready alias diverged for %s" % role)
		_expect(int(state.get("production_model_ready_count", -1)) == int(state.get("production_model_slot_exists_count", -2)), "legacy ready count diverged from slot existence count")
	else:
		_fail("legacy production model readiness aliases unavailable")

	room.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DProductionModelStateSmoke] PASS - production slot existence, spawned-role state, and active GLB state remain distinct and consistent")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DProductionModelStateSmoke] %s" % failure)
	print("[Planar3DProductionModelStateSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
