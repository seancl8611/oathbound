extends HubInteractable

## Merchant Stall — Spend Mist Shards on prosthetics, small stat upgrades,
## cosmetics, and mystery prosthetic rolls.
##
## Stat upgrades (hard-capped):
##   - Small max posture increase
##   - Slightly faster posture recovery
##   - Slightly faster heal use
##   - Tiny parry posture gain bonus
##
## Mystery reward: "Pay X for a random prosthetic" — expensive, appears periodically.
## Cosmetics: player skins, wheel variants, room variants.

signal item_purchased(item_id: String)

var merchant_menu_scene = preload("res://GUI/MerchantMenu.tscn")

func _on_ready_custom():
	MerchantManager.refresh_stock()

func _open_menu():
	super._open_menu()

	var menu = merchant_menu_scene.instantiate()
	var canvas_layer = get_tree().current_scene.get_node("UILayer")
	canvas_layer.add_child(menu)

	menu.item_purchased.connect(_on_item_purchased)
	menu.menu_closed.connect(close_menu)
	menu.tree_exited.connect(close_menu)

func _on_item_purchased(item_id: String):
	item_purchased.emit(item_id)
	print("[MerchantStall] Purchased: ", item_id)

func _on_menu_closed_custom():
	pass
