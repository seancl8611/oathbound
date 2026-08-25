extends HubInteractable

## Blood Mirror — permanent Blood Aspect progression mechanism inside Blood Cavern.
## The outer Cavern remains usable before the first Keeper defeat; the deeper Mirror
## stays dormant until that campaign gate and its menu owns the visible locked state.

signal upgrade_purchased(upgrade_id: String)

const BLOOD_MIRROR_MENU := preload("res://GUI/BloodMirrorMenu.tscn")

var _menu: Control = null


func _on_ready_custom() -> void:
	pass


func _open_menu() -> void:
	super._open_menu()
	if _menu != null and is_instance_valid(_menu):
		return
	_menu = BLOOD_MIRROR_MENU.instantiate()
	var ui_layer := get_tree().current_scene.get_node_or_null("UILayer")
	if ui_layer == null:
		push_error("[BloodMirror] Hub UILayer missing")
		close_menu()
		return
	ui_layer.add_child(_menu)
	if _menu.has_signal("menu_closed"):
		_menu.menu_closed.connect(close_menu)
	if _menu.has_signal("upgrade_purchased"):
		_menu.upgrade_purchased.connect(_on_upgrade_purchased)
	_menu.tree_exited.connect(close_menu)


func _on_upgrade_purchased(upgrade_id: String) -> void:
	upgrade_purchased.emit(upgrade_id)
	print("[BloodMirror] Purchased Aspect progression: %s" % upgrade_id)


func _on_menu_closed_custom() -> void:
	_menu = null
