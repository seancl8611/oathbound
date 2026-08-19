extends Node

var blood_targets := []

func register_enemy(enemy):
	if not blood_targets.has(enemy):
		blood_targets.append(enemy)

func unregister_enemy(enemy):
	if blood_targets.has(enemy):
		blood_targets.erase(enemy)

func _process(_delta):
	# Clean up null entries
	blood_targets = blood_targets.filter(func(e): return e != null)

	for enemy in blood_targets:
		if enemy.has_method("_update_blood_stack_timer"):
			enemy._update_blood_stack_timer()
