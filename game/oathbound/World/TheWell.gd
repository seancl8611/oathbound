extends HubInteractable

## The Well — Portal to begin a new run.
## Replaces the old BattleDoor. Player interacts to descend into the dungeon.

signal run_started

func _on_ready_custom():
	pass

func _open_menu():
	super._open_menu()
	# TODO: Open a confirmation UI or run-setup screen
	# For now, emit directly — later replace with a pre-run menu
	# (e.g. show selected prosthetic loadout, confirm, then start)
	_start_run()

func _start_run():
	run_started.emit()
	print("[TheWell] Starting run...")
	# TODO: Transition to the run/dungeon scene
	get_tree().change_scene_to_file("res://Utility/RunScene.tscn")
	close_menu()
