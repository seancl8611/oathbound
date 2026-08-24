extends HubInteractable

## Discovery Board — routes to campaign Records/Help/Achievements while preserving the
## existing detailed Bestiary / Prosthetics / Relics codex as a nested view.

const BOARD_MENU := preload("res://GUI/DiscoveryBoardMenu.tscn")
const CODEX_MENU := preload("res://GUI/CodexMenu.tscn")

var _active_menu: Control = null


func _on_ready_custom() -> void:
	pass


func _open_menu() -> void:
	super._open_menu()
	_open_board()


func _open_board() -> void:
	if _active_menu != null and is_instance_valid(_active_menu):
		return
	var menu := BOARD_MENU.instantiate()
	_active_menu = menu
	var canvas_layer := get_tree().current_scene.get_node_or_null("UILayer")
	if canvas_layer == null:
		push_error("[CodexBoard] Hub UILayer missing")
		menu.queue_free()
		_active_menu = null
		close_menu()
		return
	canvas_layer.add_child(menu)
	menu.menu_closed.connect(close_menu)
	menu.codex_requested.connect(_open_codex)
	menu.tree_exited.connect(_on_child_menu_exited)


func _open_codex() -> void:
	_active_menu = null
	var menu := CODEX_MENU.instantiate()
	_active_menu = menu
	var canvas_layer := get_tree().current_scene.get_node_or_null("UILayer")
	if canvas_layer == null:
		menu.queue_free()
		_active_menu = null
		close_menu()
		return
	canvas_layer.add_child(menu)
	menu.menu_closed.connect(close_menu)
	menu.tree_exited.connect(_on_child_menu_exited)


func _on_child_menu_exited() -> void:
	_active_menu = null


func _on_menu_closed_custom() -> void:
	_active_menu = null
