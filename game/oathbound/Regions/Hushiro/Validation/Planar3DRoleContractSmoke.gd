extends Node

## Regression proof for the region-neutral actor-role handoff into Planar3D presentation.
## Hushiro may keep its legacy `hushiro_enemy_type` metadata for compatibility, but the
## presentation bridge must prefer and preserve arbitrary shared `presentation_role`
## values so future region roles are not collapsed into generic `enemy`.

const BRIDGE_SCRIPT = preload("res://Regions/Hushiro/Presentation3D/HushiroPlanar3DPresentationBridge.gd")
const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var swordsman := Node2D.new()
	swordsman.name = "PresentationRoleSwordsman"
	add_child(swordsman)
	HUSHIRO_ENEMY_CONTRACT.apply(swordsman, "swordsman")
	await get_tree().process_frame

	_expect(str(swordsman.get_meta("presentation_role", "")) == "swordsman", "Hushiro contract did not publish shared swordsman presentation_role")
	# Deliberately poison the compatibility key. The shared presentation identity must win.
	swordsman.set_meta("hushiro_enemy_type", "hound")

	var bridge_value: Variant = BRIDGE_SCRIPT.new()
	if not (bridge_value is Node):
		_fail("Hushiro Planar3D bridge failed to instantiate")
		_finish()
		return
	var bridge := bridge_value as Node
	_expect(str(bridge.call("_role_for", swordsman)) == "swordsman", "Planar3D role resolution ignored shared presentation_role precedence")

	var hound := Node2D.new()
	hound.name = "PresentationRoleHound"
	hound.set_meta("presentation_role", "hound")
	hound.set_meta("hushiro_enemy_type", "swordsman")
	add_child(hound)
	_expect(str(bridge.call("_role_for", hound)) == "hound", "Planar3D hound role resolution fell back to Hushiro-specific metadata")

	# Prove the shared bridge is not hard-coded to the two roles already converted in the
	# vertical slice. Archer is a real Hushiro role and exercises arbitrary semantic-role
	# pass-through that later Yomori/Kagutsuchi presenters will also depend on.
	var archer := Node2D.new()
	archer.name = "PresentationRoleArcher"
	add_child(archer)
	HUSHIRO_ENEMY_CONTRACT.apply(archer, "archer")
	await get_tree().process_frame
	_expect(str(archer.get_meta("presentation_role", "")) == "archer", "Hushiro contract did not publish shared archer presentation_role")
	archer.set_meta("hushiro_enemy_type", "hound")
	_expect(str(bridge.call("_role_for", archer)) == "archer", "Planar3D collapsed arbitrary shared archer role instead of preserving it")

	# `enemy_type` remains a region-neutral fallback for actors that have not adopted the
	# explicit presentation_role key yet. It must also preserve arbitrary role names.
	var future_role := Node2D.new()
	future_role.name = "FutureRegionalController"
	future_role.set_meta("enemy_type", "controller")
	add_child(future_role)
	_expect(str(bridge.call("_role_for", future_role)) == "controller", "Planar3D collapsed shared enemy_type fallback into generic enemy")

	bridge.free()
	swordsman.queue_free()
	hound.queue_free()
	archer.queue_free()
	future_role.queue_free()
	await get_tree().process_frame
	_finish()


func _finish() -> void:
	if _failures.is_empty():
		print("[Planar3DRoleContractSmoke] PASS - shared presentation roles preserve swordsman, hound, archer and future regional identities")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[Planar3DRoleContractSmoke] %s" % failure)
	print("[Planar3DRoleContractSmoke] FAIL count=%d" % _failures.size())
	get_tree().quit(1)


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)
