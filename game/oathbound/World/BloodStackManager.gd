extends Node

var blood_targets: Array = []


func register_enemy(enemy: Node) -> void:
	if enemy == null or not is_instance_valid(enemy):
		return
	if not blood_targets.has(enemy):
		blood_targets.append(enemy)


func unregister_enemy(enemy: Node) -> void:
	if enemy == null:
		return
	if blood_targets.has(enemy):
		blood_targets.erase(enemy)


func _process(_delta: float) -> void:
	# This autoload survives room/scene teardown. A freed Godot Object is not a safe
	# target merely because an Array slot was once non-null, so prune with the engine's
	# actual instance-lifetime check before invoking any enemy method.
	for index in range(blood_targets.size() - 1, -1, -1):
		var enemy: Variant = blood_targets[index]
		if enemy == null or not is_instance_valid(enemy):
			blood_targets.remove_at(index)
			continue
		if enemy is Node and (enemy as Node).has_method("_update_blood_stack_timer"):
			(enemy as Node).call("_update_blood_stack_timer")