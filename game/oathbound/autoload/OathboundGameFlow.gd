extends "res://autoload/GameFlow.gd"

## Current Oathbound GameFlow layer.
##
## The imported GameFlow remains route/room compatibility plumbing, but every current
## run must obtain its Player through this one factory. This prevents RunScene or a
## fallback path from silently instantiating res://Player/player.tscn while the current
## runtime expects the Blood-Aspect player.

const CURRENT_PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")
const EXPECTED_PLAYER_SCRIPT: String = "res://Player/OathboundCombatPlayer.gd"
const CURRENT_PROSTHETIC_MANAGER_SCRIPT: Script = preload("res://Core/Prosthetics/OathboundProstheticManager.gd")
const EXPECTED_PROSTHETIC_MANAGER_SCRIPT: String = "res://Core/Prosthetics/OathboundProstheticManager.gd"
const CURRENT_ATTACK_DIRECTOR_SCRIPT: Script = preload("res://Core/Prosthetics/OathboundAttackDirector.gd")
const EXPECTED_ATTACK_DIRECTOR_SCRIPT: String = "res://Core/Prosthetics/OathboundAttackDirector.gd"


func _ready() -> void:
	_install_current_prosthetic_manager()
	_install_current_attack_director()
	set_player_scene(CURRENT_PLAYER_SCENE)
	print("[OathboundGameFlow] canonical Player factory -> res://Player/aspect_player.tscn")


func _install_current_prosthetic_manager() -> void:
	var manager: Node = get_node_or_null("/root/ProstheticManager")
	if manager == null:
		push_error("[OathboundGameFlow] ProstheticManager autoload missing")
		return

	var current_script_path: String = ""
	var current_script: Variant = manager.get_script()
	if current_script is Script:
		current_script_path = (current_script as Script).resource_path

	if current_script_path != EXPECTED_PROSTHETIC_MANAGER_SCRIPT:
		manager.set_script(CURRENT_PROSTHETIC_MANAGER_SCRIPT)
		# set_script() changes the runtime authority after the imported autoload has
		# already entered the tree, so initialize the current registry explicitly.
		if manager.has_method("_ready"):
			manager.call("_ready")

	var installed_script_path: String = ""
	var installed_script: Variant = manager.get_script()
	if installed_script is Script:
		installed_script_path = (installed_script as Script).resource_path
	print("[OathboundGameFlow] prosthetic_manager script=%s" % installed_script_path)
	if installed_script_path != EXPECTED_PROSTHETIC_MANAGER_SCRIPT:
		push_error("[OathboundGameFlow] Wrong ProstheticManager script: %s" % installed_script_path)


func _install_current_attack_director() -> void:
	var director: Node = get_node_or_null("/root/AttackDir")
	if director == null:
		push_error("[OathboundGameFlow] AttackDir autoload missing")
		return
	var script_path: String = ""
	var script_value: Variant = director.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path
	if script_path != EXPECTED_ATTACK_DIRECTOR_SCRIPT:
		director.set_script(CURRENT_ATTACK_DIRECTOR_SCRIPT)
	var installed_path: String = ""
	var installed_script: Variant = director.get_script()
	if installed_script is Script:
		installed_path = (installed_script as Script).resource_path
	print("[OathboundGameFlow] attack_director script=%s" % installed_path)
	if installed_path != EXPECTED_ATTACK_DIRECTOR_SCRIPT:
		push_error("[OathboundGameFlow] Wrong AttackDir script: %s" % installed_path)


func set_player_scene(scene: PackedScene) -> void:
	if scene == null:
		push_error("[OathboundGameFlow] Refusing null Player scene")
		return
	_player_packed = scene


func create_player_instance() -> Node:
	if _player_packed == null:
		_player_packed = CURRENT_PLAYER_SCENE
	var instance: Node = _player_packed.instantiate()
	_record_player_runtime("player_factory_created", instance)
	return instance


func set_player(p: Node) -> void:
	super.set_player(p)
	if p != null and is_instance_valid(p):
		_record_player_runtime("player_factory_assigned", p)


func _load_current_room() -> void:
	# A freed Player reference must not block the parent from creating a fresh instance.
	if player != null and not is_instance_valid(player):
		player = null
	if _player_packed == null:
		_player_packed = CURRENT_PLAYER_SCENE
	super._load_current_room()


func _record_player_runtime(event_name: String, instance: Node) -> void:
	if instance == null or not is_instance_valid(instance):
		return
	var script_path: String = ""
	var script_value: Variant = instance.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path
	print("[OathboundGameFlow] %s script=%s" % [event_name, script_path])
	if script_path != EXPECTED_PLAYER_SCRIPT:
		push_error("[OathboundGameFlow] Wrong active Player script: %s (expected %s)" % [script_path, EXPECTED_PLAYER_SCRIPT])
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event(event_name, {
			"player_script": script_path,
			"expected_player_script": EXPECTED_PLAYER_SCRIPT,
			"matches_expected": script_path == EXPECTED_PLAYER_SCRIPT,
		})
