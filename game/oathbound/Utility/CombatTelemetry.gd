extends Node

## Lightweight structured combat telemetry for development playtests.
##
## The previous capture scanned and serialized every moving hitbox every physics frame
## and flushed the file after every event. That made the diagnostic tool capable of
## changing the combat it was measuring. Current capture keeps high-value contacts,
## resolutions, authored events, and low-frequency world samples while batching disk
## flushes and avoiding per-frame hitbox scans.

const SAMPLE_INTERVAL: float = 0.25
const FLUSH_INTERVAL: float = 1.0
const LOG_DIR: String = "res://playtest_logs"

var _capturing: bool = false
var _capture_file: FileAccess = null
var _capture_path: String = ""
var _capture_start_ms: int = 0
var _sample_accumulator: float = 0.0
var _flush_accumulator: float = 0.0
var _event_counts: Dictionary = {}


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not OS.is_debug_build():
		set_physics_process(false)
		return
	_start_capture()


func _exit_tree() -> void:
	_stop_capture()


func is_capturing() -> bool:
	return _capturing


func get_capture_path() -> String:
	return _capture_path


func get_capture_path_absolute() -> String:
	if _capture_path.is_empty():
		return ""
	return ProjectSettings.globalize_path(_capture_path)


func _start_capture() -> void:
	var absolute_dir := ProjectSettings.globalize_path(LOG_DIR)
	var dir_error := DirAccess.make_dir_recursive_absolute(absolute_dir)
	if dir_error != OK and dir_error != ERR_ALREADY_EXISTS:
		push_warning("[CombatTelemetry] Could not create playtest log directory: %s" % absolute_dir)
		return

	var stamp := int(Time.get_unix_time_from_system())
	_capture_path = "%s/combat_%d.jsonl" % [LOG_DIR, stamp]
	_capture_file = FileAccess.open(_capture_path, FileAccess.WRITE)
	if _capture_file == null:
		push_warning("[CombatTelemetry] Could not open capture file: %s" % _capture_path)
		_capture_path = ""
		return

	_capture_start_ms = Time.get_ticks_msec()
	_sample_accumulator = 0.0
	_flush_accumulator = 0.0
	_event_counts.clear()
	_capturing = true

	var version_info := Engine.get_version_info()
	record_event("session_start", {
		"engine": str(version_info.get("string", "unknown")),
		"project": str(ProjectSettings.get_setting("application/config/name", "Oathbound")),
		"capture_path": _capture_path,
		"telemetry_mode": "lightweight",
	})
	_flush_now()
	print("[CombatTelemetry] Lightweight capture: ", get_capture_path_absolute())


func _stop_capture() -> void:
	if not _capturing:
		return
	record_event("session_end", {"event_counts": _event_counts.duplicate(true)})
	_flush_now()
	_capturing = false
	if _capture_file != null:
		_capture_file.close()
		_capture_file = null
	print("[CombatTelemetry] Capture saved: ", get_capture_path_absolute())


func record_event(event_name: String, data: Dictionary = {}) -> void:
	if not _capturing or _capture_file == null:
		return
	var payload: Dictionary = {
		"event": event_name,
		"t_ms": Time.get_ticks_msec() - _capture_start_ms,
		"physics_frame": Engine.get_physics_frames(),
		"scene": _current_scene_path(),
	}
	for key_value in data.keys():
		payload[key_value] = data[key_value]
	_event_counts[event_name] = int(_event_counts.get(event_name, 0)) + 1
	_capture_file.store_line(JSON.stringify(payload))


func snapshot_actor(actor: Node) -> Dictionary:
	if actor == null or not is_instance_valid(actor):
		return {}
	var data := _node_identity(actor)
	data["role"] = _actor_role(actor)
	if actor is Node2D:
		data["pos"] = _vec2((actor as Node2D).global_position)
		data["rotation_deg"] = rad_to_deg((actor as Node2D).global_rotation)
	if actor is CharacterBody2D:
		data["velocity"] = _vec2((actor as CharacterBody2D).velocity)
		data["speed"] = (actor as CharacterBody2D).velocity.length()

	var hp_value = _first_property(actor, ["hp", "health"])
	if hp_value != null:
		data["health"] = float(hp_value)
	var max_hp_value = _first_property(actor, ["maxhp", "max_health", "_max_hp"])
	if max_hp_value != null:
		data["max_health"] = float(max_hp_value)
	var posture_value = _first_property(actor, ["stagger"])
	var posture_max_value = _first_property(actor, ["stagger_max"])
	if posture_value != null:
		data["posture"] = float(posture_value)
	if posture_max_value != null:
		data["max_posture"] = float(posture_max_value)

	var combat_node := actor.get_node_or_null("Combat")
	if combat_node != null:
		if combat_node.has_method("get_posture"):
			data["posture"] = float(combat_node.call("get_posture"))
		var config_value = _property_value(combat_node, "config")
		if config_value is Resource:
			var max_value = _first_property(config_value, ["posture_max"])
			if max_value != null:
				data["max_posture"] = float(max_value)

	var state_value = _first_property(actor, ["state", "_state", "ai_state"])
	if state_value != null:
		data["state"] = _json_safe_variant(state_value)

	for flag_name in ["is_attacking", "telegraphing", "swinging", "has_attack_token", "_block_active", "_parry_active"]:
		var flag_value = _property_value(actor, str(flag_name))
		if flag_value != null:
			data[str(flag_name)] = bool(flag_value)

	var facing_value = _first_property(actor, ["_facing_dir", "facing_dir", "spawn_forward"])
	if typeof(facing_value) == TYPE_VECTOR2:
		data["facing"] = _vec2(facing_value)
	var sprite_node := actor.get_node_or_null("Sprite2D") as Sprite2D
	if sprite_node != null:
		data["sprite_flip_h"] = sprite_node.flip_h
	return data


func snapshot_hitbox(hitbox: Node) -> Dictionary:
	if hitbox == null or not is_instance_valid(hitbox):
		return {}
	var data := _node_identity(hitbox)
	if hitbox is Node2D:
		data["pos"] = _vec2((hitbox as Node2D).global_position)
		data["rotation_deg"] = rad_to_deg((hitbox as Node2D).global_rotation)
	if hitbox is Area2D:
		data["monitoring"] = (hitbox as Area2D).monitoring
		data["collision_layer"] = (hitbox as Area2D).collision_layer
		data["collision_mask"] = (hitbox as Area2D).collision_mask

	for meta_name in ["attack_id", "damage_type", "health_damage", "damage", "posture_damage", "block_posture_damage", "stagger_on_block", "parryable", "blockable", "unblockable", "combo_index"]:
		if hitbox.has_meta(meta_name):
			data[meta_name] = _json_safe_variant(hitbox.get_meta(meta_name))

	var attacker := _resolve_attacker(hitbox)
	if attacker != null:
		data["attacker"] = _node_identity(attacker)
		if attacker is Node2D and hitbox is Node2D:
			var offset := (hitbox as Node2D).global_position - (attacker as Node2D).global_position
			data["offset_from_attacker"] = _vec2(offset)
			data["offset_distance"] = offset.length()

	# Shapes are useful at actual contact/resolution time, but are no longer scanned
	# every frame merely because the attack Area2D moved.
	data["shapes"] = _shape_snapshots(hitbox)
	return data


func record_contact(receiver: Node, hitbox: Node, attacker: Node, before: Dictionary) -> void:
	if not _capturing:
		return
	var after := snapshot_actor(receiver)
	var data: Dictionary = {
		"receiver_before": before,
		"receiver": after,
		"attacker": _node_identity(attacker) if attacker != null else {},
		"hitbox": snapshot_hitbox(hitbox),
	}
	if receiver is Node2D and attacker is Node2D:
		var attack_vector := (attacker as Node2D).global_position - (receiver as Node2D).global_position
		data["attacker_to_receiver_distance"] = attack_vector.length()
		var facing := _actor_facing(receiver)
		if facing.length_squared() > 0.001 and attack_vector.length_squared() > 0.001:
			data["receiver_relative_attack_angle_deg"] = rad_to_deg(facing.normalized().angle_to(attack_vector.normalized()))
	record_event("contact_resolved", data)


func record_resolution(kind: String, receiver: Node, attacker: Node, hitbox: Node, extra: Dictionary = {}) -> void:
	var data: Dictionary = {
		"receiver": snapshot_actor(receiver),
		"attacker": _node_identity(attacker) if attacker != null else {},
		"hitbox": snapshot_hitbox(hitbox),
	}
	for key_value in extra.keys():
		data[key_value] = extra[key_value]
	record_event(kind, data)


func _physics_process(delta: float) -> void:
	if not _capturing:
		return
	_sample_accumulator += delta
	_flush_accumulator += delta
	if _sample_accumulator >= SAMPLE_INTERVAL:
		_sample_accumulator = 0.0
		_record_world_sample()
	if _flush_accumulator >= FLUSH_INTERVAL:
		_flush_accumulator = 0.0
		_flush_now()


func _flush_now() -> void:
	if _capture_file != null:
		_capture_file.flush()


func _record_world_sample() -> void:
	var player_snapshot: Dictionary = {}
	var player_node := get_tree().get_first_node_in_group("player")
	if player_node is Node:
		player_snapshot = snapshot_actor(player_node)

	var enemy_snapshots: Array = []
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy is Node and is_instance_valid(enemy):
			enemy_snapshots.append(snapshot_actor(enemy))

	if player_snapshot.is_empty() and enemy_snapshots.is_empty():
		return
	record_event("world_sample", {
		"player": player_snapshot,
		"enemies": enemy_snapshots,
		"active_attack_count": get_tree().get_nodes_in_group("attack").size(),
	})


func _shape_snapshots(root: Node) -> Array:
	var result: Array = []
	for node in root.find_children("*", "CollisionShape2D", true, false):
		var collision_shape := node as CollisionShape2D
		if collision_shape == null:
			continue
		var shape_data: Dictionary = {
			"name": String(collision_shape.name),
			"disabled": collision_shape.disabled,
			"pos": _vec2(collision_shape.global_position),
		}
		var shape := collision_shape.shape
		if shape is RectangleShape2D:
			shape_data["type"] = "rectangle"
			shape_data["size"] = _vec2((shape as RectangleShape2D).size)
		elif shape is CircleShape2D:
			shape_data["type"] = "circle"
			shape_data["radius"] = (shape as CircleShape2D).radius
		elif shape is CapsuleShape2D:
			shape_data["type"] = "capsule"
			shape_data["radius"] = (shape as CapsuleShape2D).radius
			shape_data["height"] = (shape as CapsuleShape2D).height
		elif shape != null:
			shape_data["type"] = shape.get_class()
		result.append(shape_data)
	return result


func _resolve_attacker(hitbox: Node) -> Node:
	if hitbox == null:
		return null
	if hitbox.has_meta("attacker"):
		var value = hitbox.get_meta("attacker")
		if value is Node and is_instance_valid(value):
			return value
	return hitbox.get_parent()


func _actor_facing(actor: Node) -> Vector2:
	var value = _first_property(actor, ["_facing_dir", "facing_dir", "spawn_forward"])
	return value if typeof(value) == TYPE_VECTOR2 else Vector2.ZERO


func _actor_role(actor: Node) -> String:
	if actor.is_in_group("player"):
		return "player"
	if actor.is_in_group("miniboss"):
		return "miniboss"
	if actor.is_in_group("enemy"):
		return "enemy"
	return "other"


func _node_identity(node: Node) -> Dictionary:
	if node == null or not is_instance_valid(node):
		return {}
	var data: Dictionary = {
		"id": int(node.get_instance_id()),
		"name": String(node.name),
		"path": str(node.get_path()),
	}
	var script_resource := node.get_script() as Script
	if script_resource != null:
		data["script"] = script_resource.resource_path
	return data


func _first_property(object: Object, property_names: Array) -> Variant:
	if object == null:
		return null
	for property_name in property_names:
		var value = _property_value(object, str(property_name))
		if value != null:
			return value
	return null


func _property_value(object: Object, property_name: String) -> Variant:
	if not _has_property(object, property_name):
		return null
	return object.get(property_name)


func _has_property(object: Object, property_name: String) -> bool:
	if object == null:
		return false
	for property_data in object.get_property_list():
		if str(property_data.get("name", "")) == property_name:
			return true
	return false


func _vec2(value: Vector2) -> Array:
	return [snappedf(value.x, 0.01), snappedf(value.y, 0.01)]


func _json_safe_variant(value: Variant) -> Variant:
	if typeof(value) == TYPE_VECTOR2:
		return _vec2(value)
	if typeof(value) == TYPE_STRING_NAME:
		return str(value)
	if value is Node:
		return _node_identity(value)
	return value


func _current_scene_path() -> String:
	var scene := get_tree().current_scene
	return scene.scene_file_path if scene != null else ""
