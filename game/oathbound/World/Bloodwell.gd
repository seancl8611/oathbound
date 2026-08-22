extends HubInteractable

## Bloodwell — canonical permanent Akio + Run Infrastructure progression station.
## Returning Blood must be awake before permanent progression can be purchased; the
## menu exposes unavailable campaign-gated nodes without reviving retired currencies.

signal upgrade_purchased(upgrade_id: String)

const BLOODWELL_MENU := preload("res://GUI/BloodwellMenu.tscn")

var _menu: Control = null


func _on_ready_custom() -> void:
	pass


func _open_menu() -> void:
	super._open_menu()
	if _menu != null and is_instance_valid(_menu):
		return
	_menu = BLOODWELL_MENU.instantiate()
	var ui_layer := get_tree().current_scene.get_node_or_null("UILayer")
	if ui_layer == null:
		push_error("[Bloodwell] Hub UILayer missing")
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
	print("[Bloodwell] Purchased permanent progression: %s" % upgrade_id)


func _on_menu_closed_custom() -> void:
	_menu = null
