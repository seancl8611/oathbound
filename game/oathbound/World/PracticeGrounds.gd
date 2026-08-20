extends HubInteractable

## Practice Grounds — Test prosthetics and combos on combat dummies.
## Player enters a small practice arena with spawnable dummies.

signal practice_started
signal practice_ended

# TODO: Create PracticeArena.tscn (a small sub-scene or transition)
# var practice_scene = preload("res://World/PracticeArena.tscn")

func _on_ready_custom():
	pass

func _open_menu():
	super._open_menu()

	# --- Two approaches (pick one during implementation) ---
	#
	# APPROACH A: Inline — spawn dummies in the hub itself (simpler)
	#   Spawn CombatDummy nodes nearby, let player fight freely,
	#   provide an "Exit Training" prompt to despawn them.
	#
	# APPROACH B: Sub-scene — transition to a dedicated PracticeArena scene
	#   Cleaner separation, can have its own layout, damage numbers, combo counter.
	#
	# For now, placeholder:

	practice_started.emit()
	print("[PracticeGrounds] Entering practice mode (placeholder)")

	# TODO: Implement one of the approaches above
	# _spawn_practice_dummies()  — Approach A
	# _enter_practice_arena()    — Approach B

	close_menu()

func _spawn_practice_dummies():
	## Approach A: Spawn dummies near the practice grounds in the hub.
	# var dummy_scene = preload("res://Enemies/PracticeDummy/PracticeDummy.tscn")
	# var spawn_points = $DummySpawnPoints.get_children()
	# for point in spawn_points:
	#     var dummy = dummy_scene.instantiate()
	#     dummy.global_position = point.global_position
	#     get_parent().add_child(dummy)
	pass

func _enter_practice_arena():
	## Approach B: Transition to a dedicated practice scene.
	# get_tree().change_scene_to_file("res://World/PracticeArena.tscn")
	pass

func _on_menu_closed_custom():
	practice_ended.emit()
