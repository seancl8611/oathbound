extends Node

## Area-1-only runtime bridge that guarantees the approved Hushiro standard-enemy
## durability/Posture contract no matter how an enemy is instantiated (authored room,
## Playtest Lab, or direct scene test). Later regions are intentionally untouched.

const HUSHIRO_ENEMY_CONTRACT = preload("res://Utility/HushiroEnemyContract.gd")


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not get_tree().node_added.is_connected(_on_tree_node_added):
		get_tree().node_added.connect(_on_tree_node_added)
	call_deferred("_apply_existing_enemies")


func _on_tree_node_added(node: Node) -> void:
	if node == null:
		return
	# Wait until the enemy's own _ready() and scene-owned defaults have completed.
	call_deferred("_apply_if_hushiro_enemy", node)


func _apply_existing_enemies() -> void:
	for node: Node in get_tree().get_nodes_in_group("enemy"):
		_apply_if_hushiro_enemy(node)


func _apply_if_hushiro_enemy(node: Node) -> void:
	if node == null or not is_instance_valid(node):
		return
	if not node.is_in_group("enemy"):
		return
	if not _area_one_is_active(node):
		return

	var enemy_type := _infer_type(node)
	if enemy_type.is_empty():
		return

	HUSHIRO_ENEMY_CONTRACT.apply(node, enemy_type)


func _area_one_is_active(node: Node) -> bool:
	var room := get_tree().get_first_node_in_group("room")
	if room != null and room.has_meta("area_id"):
		return int(room.get_meta("area_id")) == 1
	if typeof(RunData) == TYPE_OBJECT:
		return int(RunData.current_area_id) == 1
	return true


func _infer_type(node: Node) -> String:
	var scene_path := node.scene_file_path.to_lower()
	var script_path := ""
	var script_value: Variant = node.get_script()
	if script_value is Script:
		script_path = (script_value as Script).resource_path.to_lower()

	var identity := scene_path + "|" + script_path
	if identity.contains("corrupted_swordsman") or identity.contains("corruptedswordsmancontroller"):
		return "swordsman"
	if identity.contains("corrupted_archer") or identity.contains("hushiroarcher"):
		return "archer"
	if identity.contains("blighted_hound"):
		return "hound"
	if identity.contains("cellar_bilemass"):
		return "bilemass"
	if identity.contains("hollow.tscn") or identity.contains("/hollow.gd"):
		return "hollow"
	if identity.contains("warden.tscn") or identity.contains("hushirowarden") or identity.contains("/warden.gd"):
		return "warden"
	return ""
