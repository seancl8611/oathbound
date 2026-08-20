extends HubInteractable

## Codex / Discovery Board — View unlocked enemy pages, weakness hints,
## and discovered vs locked prosthetics and relics.

var codex_menu_scene = preload("res://GUI/CodexMenu.tscn")

func _on_ready_custom():
	pass

func _open_menu():
	super._open_menu()

	var menu = codex_menu_scene.instantiate()
	var canvas_layer = get_tree().current_scene.get_node("UILayer")
	canvas_layer.add_child(menu)

	menu.menu_closed.connect(close_menu)
	menu.tree_exited.connect(close_menu)

func _on_menu_closed_custom():
	pass
