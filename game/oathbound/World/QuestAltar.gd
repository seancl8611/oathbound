# res://Hub/QuestAltar.gd
extends HubInteractable

## Quest Altar — View active objectives, claim completed quest rewards.
## Objectives: enemy kills, boss kills, reach certain areas, etc.
## Rewards: prosthetic unlocks, relic unlocks, currency, cosmetics.

signal reward_claimed(quest_id: String)

const QUEST_MENU_SCRIPT := preload("res://GUI/QuestMenu.tscn")
var _menu: Control = null

func _on_ready_custom():
	# Optional: show indicator if any claimable rewards
	_update_notification_indicator()

func _open_menu():
	super._open_menu()

	if _menu and is_instance_valid(_menu):
		return

	_menu = QUEST_MENU_SCRIPT.instantiate()
	var ui_layer := get_tree().current_scene.get_node("UILayer")
	ui_layer.add_child(_menu)

	_menu.menu_closed.connect(close_menu)
	_menu.quest_claimed.connect(_on_quest_claimed)
	_menu.tree_exited.connect(close_menu)

func _on_quest_claimed(quest_id: String):
	reward_claimed.emit(quest_id)
	_update_notification_indicator()

func _update_notification_indicator():
	# Minimal: if you add a Sprite2D/AnimatedSprite2D named "ClaimIcon" as a child, toggle it.
	var icon := get_node_or_null("ClaimIcon")
	if icon:
		icon.visible = QuestManager.has_claimable()

func _on_menu_closed_custom():
	_menu = null
