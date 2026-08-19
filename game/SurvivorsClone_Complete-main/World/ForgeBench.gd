extends HubInteractable

## Forge Bench — Equip prosthetics, attach relics, unlock upgrade nodes.

signal prosthetic_equipped(prosthetic_id: String)

var forge_menu_scene = preload("res://GUI/ForgeMenu.tscn")

func _on_ready_custom():
	pass

func _open_menu():
	super._open_menu()

	var menu = forge_menu_scene.instantiate()
	var canvas_layer = get_tree().current_scene.get_node("UILayer")
	canvas_layer.add_child(menu)

	menu.prosthetic_equipped.connect(_on_prosthetic_equipped)
	menu.menu_closed.connect(close_menu)
	menu.tree_exited.connect(close_menu)

func _on_prosthetic_equipped(prosthetic_id: String):
	prosthetic_equipped.emit(prosthetic_id)
	Global.selected_weapon_name = prosthetic_id

	if player_ref and player_ref.has_method("equip_prosthetic"):
		player_ref.equip_prosthetic(prosthetic_id)
	elif player_ref and player_ref.has_method("change_weapon"):
		player_ref.change_weapon(prosthetic_id)

func _on_menu_closed_custom():
	pass
