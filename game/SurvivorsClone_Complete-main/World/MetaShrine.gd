# res://Hub/MetaShrine.gd
extends HubInteractable
## Meta Progression Shrine — Spend Boss Emblems + Mist Shards for permanent unlocks.

signal upgrade_purchased(upgrade_id: String)

# Uses script-built UI (no .tscn required)
const META_MENU_SCENE := preload("res://GUI/MetaShrineMenu.tscn")

var _menu: Control = null

func _on_ready_custom() -> void:
	pass

func _open_menu() -> void:
	super._open_menu()

	if _menu and is_instance_valid(_menu):
		return

	_menu = META_MENU_SCENE.instantiate()
	var ui_layer := get_tree().current_scene.get_node("UILayer")
	ui_layer.add_child(_menu)

	# Wire flow like CodexBoard: menu emits close, and we also close if freed
	if _menu.has_signal("menu_closed"):
		_menu.menu_closed.connect(close_menu)

	if _menu.has_signal("upgrade_purchased"):
		_menu.upgrade_purchased.connect(_on_upgrade_purchased)

	_menu.tree_exited.connect(close_menu)

func _on_upgrade_purchased(upgrade_id: String) -> void:
	upgrade_purchased.emit(upgrade_id)
	print("[MetaShrine] Purchased upgrade: ", upgrade_id)

func _on_menu_closed_custom() -> void:
	_menu = null
