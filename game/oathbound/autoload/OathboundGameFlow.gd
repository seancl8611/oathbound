extends "res://autoload/GameFlow.gd"

## Current Oathbound GameFlow layer.
##
## The imported GameFlow remains route/room compatibility plumbing, but every current
## run must obtain its Player through this one factory. This prevents RunScene or a
## fallback path from silently instantiating res://Player/player.tscn while the current
## runtime expects the Blood-Aspect player.

const CURRENT_PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")


func _ready() -> void:
	set_player_scene(CURRENT_PLAYER_SCENE)
	print("[OathboundGameFlow] canonical Player factory -> res://Player/aspect_player.tscn")


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
	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event(event_name, {
			"player_script": script_path,
			"expected_player_script": "res://Player/OathboundAspectPlayerRuntime.gd",
			"matches_expected": script_path == "res://Player/OathboundAspectPlayerRuntime.gd",
		})
