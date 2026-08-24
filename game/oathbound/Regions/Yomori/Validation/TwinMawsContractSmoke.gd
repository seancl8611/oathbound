extends Node

## Focused structural/behavior contract for the Region 2 boss.
## Uses lightweight test twins for manager state transitions so the assertions are
## deterministic, while separately inspecting the authored Twin Maws scene to ensure
## the real Rootfang/Briarthorn nodes are wired to the same manager contract.

const DUO_MANAGER_SCRIPT: Script = preload("res://Utility/duo_boss_manager.gd")
const TWIN_MAWS_SCENE: PackedScene = preload("res://Regions/Yomori/Chambers/TwinMawsChamber.tscn")
const EXPECTED_MANAGER_SCRIPT: String = "res://Utility/duo_boss_manager.gd"

class TestTwin:
	extends Node
	var dead: bool = false
	var partner_died_calls: int = 0
	var deferred_special_calls: int = 0
	var assigned_manager: Node = null

	func set_manager(value: Node) -> void:
		assigned_manager = value

	func is_dead() -> bool:
		return dead

	func on_partner_died() -> void:
		partner_died_calls += 1

	func trigger_deferred_shell() -> void:
		deferred_special_calls += 1


var _failures: Array[String] = []
var _defeated_count: int = 0
var _twin_died_count: int = 0


func _ready() -> void:
	_validate_authored_scene()
	await _validate_manager_behavior()

	if _failures.is_empty():
		print("[TwinMawsContractSmoke] PASS - explicit twins | serialized special | survivor empowered | defeat after both")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[TwinMawsContractSmoke] %s" % failure)
		print("[TwinMawsContractSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _validate_authored_scene() -> void:
	var chamber: Node = TWIN_MAWS_SCENE.instantiate()
	_expect(int(chamber.get_meta("area_id", -1)) == 2, "Twin Maws chamber must own area_id=2")
	var container: Node = chamber.get_node_or_null("TwinMaws")
	_expect(container != null, "Twin Maws chamber missing TwinMaws boss container")
	if container == null:
		chamber.free()
		return
	_expect(int(container.get_meta("boss_area", -1)) == 2, "Twin Maws boss container must own boss_area=2")

	var manager: Node = container.get_node_or_null("TwinMawsManager")
	var rootfang: Node = container.get_node_or_null("Rootfang")
	var briarthorn: Node = container.get_node_or_null("Briarthorn")
	_expect(manager != null, "Twin Maws scene missing TwinMawsManager")
	_expect(rootfang != null, "Twin Maws scene missing Rootfang")
	_expect(briarthorn != null, "Twin Maws scene missing Briarthorn")
	if manager != null:
		_expect(_script_path(manager) == EXPECTED_MANAGER_SCRIPT, "Twin Maws scene manager script drifted: %s" % _script_path(manager))
		_expect(str(manager.get("twin_a_path")) == "../Rootfang", "Twin Maws manager must explicitly target Rootfang")
		_expect(str(manager.get("twin_b_path")) == "../Briarthorn", "Twin Maws manager must explicitly target Briarthorn")
	chamber.free()


func _validate_manager_behavior() -> void:
	var container := Node.new()
	container.name = "TwinMawsTestContainer"
	var rootfang := TestTwin.new()
	rootfang.name = "Rootfang"
	var briarthorn := TestTwin.new()
	briarthorn.name = "Briarthorn"
	var manager_value: Variant = DUO_MANAGER_SCRIPT.new()
	if not (manager_value is Node):
		_fail("Could not instantiate DuoBossManager")
		return
	var manager: Node = manager_value as Node
	manager.name = "TwinMawsManager"
	manager.set("twin_a_path", NodePath("../Rootfang"))
	manager.set("twin_b_path", NodePath("../Briarthorn"))
	manager.connect("defeated", Callable(self, "_on_defeated"))
	manager.connect("twin_died", Callable(self, "_on_twin_died"))

	container.add_child(rootfang)
	container.add_child(briarthorn)
	container.add_child(manager)
	add_child(container)
	await get_tree().process_frame

	_expect(rootfang.assigned_manager == manager, "Rootfang did not receive DuoBossManager")
	_expect(briarthorn.assigned_manager == manager, "Briarthorn did not receive DuoBossManager")
	_expect(manager.call("get_partner", rootfang) == briarthorn, "Rootfang partner must be Briarthorn")
	_expect(manager.call("get_partner", briarthorn) == rootfang, "Briarthorn partner must be Rootfang")

	var rootfang_started: bool = bool(manager.call("request_special_mode", rootfang))
	var briarthorn_started: bool = bool(manager.call("request_special_mode", briarthorn))
	_expect(rootfang_started, "First twin special mode should start immediately")
	_expect(not briarthorn_started, "Second twin special mode must defer while partner is active")
	_expect(manager.call("get_special_mode_twin") == rootfang, "Rootfang should own the active special-mode slot")
	manager.call("notify_special_mode_ended", rootfang)
	await get_tree().process_frame
	_expect(manager.call("get_special_mode_twin") == briarthorn, "Deferred Briarthorn special mode did not become active")
	_expect(briarthorn.deferred_special_calls == 1, "Deferred twin special trigger was not dispatched exactly once")

	rootfang.dead = true
	manager.call("notify_died", rootfang)
	_expect(_twin_died_count == 1, "First twin death must emit twin_died exactly once")
	_expect(_defeated_count == 0, "Twin Maws must not emit defeated after only one twin dies")
	_expect(briarthorn.partner_died_calls == 1, "Surviving Briarthorn did not receive on_partner_died handoff")
	_expect(bool(manager.call("is_partner_alive", briarthorn)) == false, "Briarthorn should observe Rootfang as dead")

	briarthorn.dead = true
	manager.call("notify_died", briarthorn)
	_expect(_twin_died_count == 2, "Second twin death must emit the second twin_died")
	_expect(_defeated_count == 1, "Twin Maws must emit defeated exactly once after both twins die")

	container.queue_free()
	await get_tree().process_frame


func _on_defeated() -> void:
	_defeated_count += 1


func _on_twin_died(_who: Node) -> void:
	_twin_died_count += 1


func _script_path(instance: Object) -> String:
	if instance == null:
		return ""
	var script_value: Variant = instance.get_script()
	if script_value is Script:
		return (script_value as Script).resource_path
	return ""


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_fail(message)


func _fail(message: String) -> void:
	_failures.append(message)