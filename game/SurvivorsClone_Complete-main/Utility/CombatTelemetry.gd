extends Node

## Structured development-only combat capture for Godot playtests.
##
## Every debug run writes a JSONL file under res://playtest_logs/. The file is
## intentionally machine-readable so a playtest can be compared against approved
## combat/encounter contracts without relying only on subjective descriptions.
##
## Captured facts include:
## - actor positions, velocities, Health/Posture and combat state at 10 Hz,
## - attack hitbox spawn/end and activation/shape changes,
## - hitbox positions and attack metadata,
## - receiver/attacker geometry at contact,
## - explicit parry/block/posture-break events emitted by current combat code.

const SAMPLE_INTERVAL: float = 0.10
const LOG_DIR: String = "res://playtest_logs"

var _capturing: bool = false
var _capture_file: FileAccess = null
var _capture_path: String = ""
var _capture_start_ms: int = 0
var _sample_accumulator: float = 0.0
var _known_hitboxes: Dictionary = {}
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
	var absolute_dir: String = ProjectSettings.globalize_path(LOG_DIR)
	var dir_error: Error = DirAccess.make_dir_recursive_absolute(absolute_dir)
	if dir_error != OK and dir_error != ERR_ALREADY_EXISTS:
		push_warning("[CombatTelemetry] Could not create playtest log directory: %s" % absolute_dir)
		return

	var stamp: int = int(Time.get_unix_time_from_system())
	_capture_path = "%s/combat_%d.jsonl" % [LOG_DIR, stamp]
	_capture_file = FileAccess.open(_capture_path, FileAccess.WRITE)
	if _capture_file == null:
		push_warning("[CombatTelemetry] Could not open capture file: %s" % _capture_path)
		_capture_path = ""
		return

	_capture_start_ms = Time.get_ticks_msec()
	_sample_accumulator = 0.0
	_known_hitboxes.clear()
	_event_counts.clear()
	_capturing = true

	var version_info: Dictionary = Engine.get_version_info()
	record_event("session_start", {
		"engine": str(version_info.get("string", "unknown")),
		"project": str(ProjectSettings.get_setting("application/config/name", "Oathbound")),
		"capture_path": _capture_path,
	})
	print("[CombatTelemetry] Capturing structured combat data: ", get_capture_path_absolute())


func _stop_capture() -> void:
	if not _capturing:
		return

	record_event("session_end", {"event_counts": _event_counts.duplicate(true)})
	_capturing = false
	if _capture_file != null:
		_capture_file.flush()
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
	for key: Variant in data.keys():
		payload[key] = data[key]

	var count: int = int(_event_counts.get(event_name, 0)) + 1
	_event_counts[event_name] = count
	_capture_file.store_line(JSON.stringify(payload))
	_capture_file.flush()


func snapshot_actor(actor: Node) -> Dictionary:
	if actor == null or not is_instance_valid(actor):
		return {}

	var data: Dictionary = _node_identity(actor)
	data["role"] = _actor_role(actor)

	if actor is Node2D:
		var actor_2d: Node2D = actor as Node2D
		data["pos"] = _vec2(actor_2d.global_position)
		data["rotation_deg"] = rad_to_deg(actor_2d.global_rotation)

	if actor is CharacterBody2D:
		var body: CharacterBody2D = actor as CharacterBody2D
		data["velocity"] = _vec2(body.velocity)
		data["speed"] = body.velocity.length()

	var hp_value: Variant = _first_property(actor, ["hp", "health"])
	if hp_value != null:
		data["health"] = float(hp_value)

	var max_hp_value: Variant = _first_property(actor, ["maxhp", "max_health", "_max_hp"])
	if max_hp_value != null:
		data["max_health"] = float(max_hp_value)

	var player_posture: Variant = _first_property(actor, ["stagger"])
	var player_posture_max: Variant = _first_property(actor, ["stagger_max"])
	if player_posture != null:
		data["posture"] = float(player_posture)
	if player_posture_max != null:
		data["max_posture"] = float(player_posture_max)

	var combat_node: Node = actor.get_node_or_null("Combat")
	if combat_node != null:
		if combat_node.has_method("get_posture"):
			data["posture"] = float(combat_node.call("get_posture"))
		var config_value: Variant = combat_node.get("config")
		if config_value != null and config_value is Resource:
			var config_resource: Resource = config_value as Resource
			var posture_max_value: Variant = _first_property(config_resource, ["posture_max"])
			if posture_max_value != null:
				data["max_posture"] = float(posture_max_value)

	var state_value: Variant = _first_property(actor, ["state", "_state", "ai_state"])
	if state_value != null:
		data["state"] = state_value

	for flag_name: String in ["is_attacking", "telegraphing", "swinging", "has_attack_token", "_block_active", "_parry_active"]:
		var flag_value: Variant = _first_property(actor, [flag_name])
		if flag_value != null:
			data[flag_name] = bool(flag_value)

	var facing_value: Variant = _first_property(actor, ["_facing_dir", "facing_dir", "spawn_forward"])
	if facing_value is Vector2:
		data["facing"] = _vec2(facing_value as Vector2)

	var sprite_node: Sprite2D = actor.get_node_or_null("Sprite2D") as Sprite2D
	if sprite_node != null:
		data["sprite_flip_h"] = sprite_node.flip_h

	return data


func snapshot_hitbox(hitbox: Node) -> Dictionary:
	if hitbox == null or not is_instance_valid(hitbox):
		return {}

	var data: Dictionary = _node_identity(hitbox)
	if hitbox is Node2D:
		var hitbox_2d: Node2D = hitbox as Node2D
		data["pos"] = _vec2(hitbox_2d.global_position)
		data["rotation_deg"] = rad_to_deg(hitbox_2d.global_rotation)

	if hitbox is Area2D:
		var area: Area2D = hitbox as Area2D
		data["monitoring"] = area.monitoring
		data["monitorable"] = area.monitorable
		data["collision_layer"] = area.collision_layer
		data["collision_mask"] = area.collision_mask

	for meta_name: String in [
		"attack_id", "damage_type", "health_damage", "damage", "posture_damage",
		"block_posture_damage", "stagger_on_block", "stagger_level", "proc_coefficient",
		"parryable", "parry_only", "blockable", "unblockable", "combo_index"
	]:
		if hitbox.has_meta(meta_name):
			data[meta_name] = _json_safe_variant(hitbox.get_meta(meta_name))

	var attacker: Node = _resolve_attacker(hitbox)
	if attacker != null:
		data["attacker"] = _node_identity(attacker)
		if attacker is Node2D and hitbox is Node2D:
			var attacker_2d: Node2D = attacker as Node2D
			var hitbox_2d_for_offset: Node2D = hitbox as Node2D
			var offset: Vector2 = hitbox_2d_for_offset.global_position - attacker_2d.global_position
			data["offset_from_attacker"] = _vec2(offset)
			data["offset_angle_deg"] = rad_to_deg(offset.angle()) if offset.length_squared() > 0.001 else 0.0
			data["offset_distance"] = offset.length()

	data["shapes"] = _shape_snapshots(hitbox)
	return data


func record_contact(receiver: Node, hitbox: Node, attacker: Node, before: Dictionary) -> void:
	if not _capturing:
		return
	var after: Dictionary = snapshot_actor(receiver)
	var data: Dictionary = {
		"receiver": after,
		"receiver_before": before,
		"attacker": _node_identity(attacker) if attacker != null else {},
		"hitbox": snapshot_hitbox(hitbox),
	}

	if receiver is Node2D and attacker is Node2D:
		var receiver_2d: Node2D = receiver as Node2D
		var attacker_2d: Node2D = attacker as Node2D
		var attack_vector: Vector2 = attacker_2d.global_position - receiver_2d.global_position
		data["attacker_to_receiver_distance"] = attack_vector.length()
		data["attacker_world_angle_deg"] = rad_to_deg(attack_vector.angle()) if attack_vector.length_squared() > 0.001 else 0.0

		var facing: Vector2 = _actor_facing(receiver)
		if facing.length_squared() > 0.001 and attack_vector.length_squared() > 0.001:
			data["receiver_relative_attack_angle_deg"] = rad_to_deg(facing.normalized().angle_to(attack_vector.normalized()))

	record_event("contact_resolved", data)


func record_resolution(kind: String, receiver: Node, attacker: Node, hitbox: Node, extra: Dictionary = {}) -> void:
	var data: Dictionary = {
		"receiver": snapshot_actor(receiver),
		"attacker": _node_identity(attacker) if attacker != null else {},
		"hitbox": snapshot_hitbox(hitbox),
	}
	for key: Variant in extra.keys():
		data[key] = extra[key]
	record_event(kind, data)


func _physics_process(delta: float) -> void:
	if not _capturing:
		return
	_scan_hitboxes()
	_sample_accumulator += delta
	if _sample_accumulator >= SAMPLE_INTERVAL:
		_sample_accumulator = 0.0
		_record_world_sample()


func _scan_hitboxes() -> void:
	var seen: Dictionary = {}
	var attack_nodes: Array = get_tree().get_nodes_in_group("attack")
	for node_value: Variant in attack_nodes:
		if not (node_value is Node):
			continue
		var hitbox: Node = node_value as Node
		if not is_instance_valid(hitbox):
			continue
		var instance_id: int = int(hitbox.get_instance_id())
		seen[instance_id] = true
		var state: Dictionary = snapshot_hitbox(hitbox)
		var signature: String = _hitbox_signature(state)
		if not _known_hitboxes.has(instance_id):
			_known_hitboxes[instance_id] = {"signature": signature, "last": state}
			record_event("hitbox_spawn", {"hitbox": state})
		else:
			var previous_value: Variant = _known_hitboxes[instance_id]
			var previous: Dictionary = previous_value as Dictionary
			var previous_signature: String = str(previous.get("signature", ""))
			if signature != previous_signature:
				record_event("hitbox_state_change", {
					"before": previous.get("last", {}),
					"after": state,
				})
			_known_hitboxes[instance_id] = {"signature": signature, "last": state}

	var known_ids: Array = _known_hitboxes.keys()
	for id_value: Variant in known_ids:
		var known_id: int = int(id_value)
		if seen.has(known_id):
			continue
		var last_value: Variant = _known_hitboxes.get(known_id, {})
		var last_entry: Dictionary = last_value as Dictionary
		record_event("hitbox_end", {"hitbox": last_entry.get("last", {})})
		_known_hitboxes.erase(known_id)


func _record_world_sample() -> void:
	var player_snapshot: Dictionary = {}
	var player_nodes: Array = get_tree().get_nodes_in_group("player")
	if not player_nodes.is_empty() and player_nodes[0] is Node:
		player_snapshot = snapshot_actor(player_nodes[0] as Node)

	var enemy_snapshots: Array = []
	var enemy_nodes: Array = get_tree().get_nodes_in_group("enemy")
	for enemy_value: Variant in enemy_nodes:
		if enemy_value is Node and is_instance_valid(enemy_value):
			enemy_snapshots.append(snapshot_actor(enemy_value as Node))

	var hitbox_snapshots: Array = []
	var attack_nodes: Array = get_tree().get_nodes_in_group("attack")
	for hitbox_value: Variant in attack_nodes:
		if hitbox_value is Node and is_instance_valid(hitbox_value):
			var hitbox: Node = hitbox_value as Node
			var minimal: Dictionary = _node_identity(hitbox)
			if hitbox is Node2D:
				minimal["pos"] = _vec2((hitbox as Node2D).global_position)
			if hitbox is Area2D:
				minimal["monitoring"] = (hitbox as Area2D).monitoring
			if hitbox.has_meta("attack_id"):
				minimal["attack_id"] = str(hitbox.get_meta("attack_id"))
			hitbox_snapshots.append(minimal)

	if player_snapshot.is_empty() and enemy_snapshots.is_empty() and hitbox_snapshots.is_empty():
		return

	record_event("world_sample", {
		"player": player_snapshot,
		"enemies": enemy_snapshots,
		"hitboxes": hitbox_snapshots,
	})


func _shape_snapshots(root: Node) -> Array:
	var result: Array = []
	var shape_nodes: Array[Node] = root.find_children("*", "CollisionShape2D", true, false)
	for shape_node: Node in shape_nodes:
		var collision_shape: CollisionShape2D = shape_node as CollisionShape2D
		if collision_shape == null:
			continue
		var shape_data: Dictionary = {
			"name": String(collision_shape.name),
			"disabled": collision_shape.disabled,
			"pos": _vec2(collision_shape.global_position),
			"rotation_deg": rad_to_deg(collision_shape.global_rotation),
		}
		var shape: Shape2D = collision_shape.shape
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


func _hitbox_signature(state: Dictionary) -> String:
	var signature_data: Dictionary = {
		"monitoring": state.get("monitoring", null),
		"monitorable": state.get("monitorable", null),
		"attack_id": state.get("attack_id", ""),
		"damage_type": state.get("damage_type", ""),
		"health_damage": state.get("health_damage", state.get("damage", null)),
		"posture_damage": state.get("posture_damage", null),
		"block_posture_damage": state.get("block_posture_damage", state.get("stagger_on_block", null)),
		"shapes": state.get("shapes", []),
	}
	return JSON.stringify(signature_data)


func _resolve_attacker(hitbox: Node) -> Node:
	if hitbox == null:
		return null
	if hitbox.has_meta("attacker"):
		var meta_attacker: Variant = hitbox.get_meta("attacker")
		if meta_attacker is Node and is_instance_valid(meta_attacker):
			return meta_attacker as Node
	var parent: Node = hitbox.get_parent()
	if parent != null:
		return parent
	return null


func _actor_facing(actor: Node) -> Vector2:
	var facing_value: Variant = _first_property(actor, ["_facing_dir", "facing_dir", "spawn_forward"])
	if facing_value is Vector2:
		return facing_value as Vector2
	return Vector2.ZERO


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
	var script_resource: Script = node.get_script() as Script
	if script_resource != null:
		data["script"] = script_resource.resource_path
	return data


func _first_property(object: Object, property_names: Array) -> Variant:
	if object == null:
		return null
	for name_value: Variant in property_names:
		var property_name: String = str(name_value)
		if _has_property(object, property_name):
			return object.get(property_name)
	return null


func _has_property(object: Object, property_name: String) -> bool:
	if object == null:
		return false
	var property_list: Array[Dictionary] = object.get_property_list()
	for property_data: Dictionary in property_list:
		if str(property_data.get("name", "")) == property_name:
			return true
	return false


func _vec2(value: Vector2) -> Array:
	return [snappedf(value.x, 0.01), snappedf(value.y, 0.01)]


func _json_safe_variant(value: Variant) -> Variant:
	if value is Vector2:
		return _vec2(value as Vector2)
	if value is Node:
		return _node_identity(value as Node)
	if value is StringName:
		return str(value)
	return value


func _current_scene_path() -> String:
	var scene: Node = get_tree().current_scene
	if scene == null:
		return ""
	return scene.scene_file_path
