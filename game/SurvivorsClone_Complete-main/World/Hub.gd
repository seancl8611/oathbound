extends Node2D

## Hub — Central hub scene connecting all player-facing stations.
##
## Expected scene tree (Area2D nodes with HubInteractable-derived scripts):
##   Hub (Node2D)
##   ├── Sprite2D                  (background)
##   ├── Player
##   ├── TheWell                   (Area2D — run start, was BattleDoor)
##   │   ├── CollisionShape2D
##   │   └── InteractPopup
##   ├── ForgeBench                (Area2D — prosthetics, was ArmoryObject)
##   │   ├── CollisionShape2D
##   │   └── InteractPopup
##   ├── CodexBoard                (Area2D — discovery log)
##   │   ├── CollisionShape2D
##   │   └── InteractPopup
##   ├── QuestAltar                (Area2D — quests & rewards)
##   │   ├── CollisionShape2D
##   │   └── InteractPopup
##   ├── MetaShrine                (Area2D — permanent progression)
##   │   ├── CollisionShape2D
##   │   └── InteractPopup
##   ├── MerchantStall             (Area2D — shop)
##   │   ├── CollisionShape2D
##   │   └── InteractPopup
##   ├── PracticeGrounds           (Area2D — combat testing)
##   │   ├── CollisionShape2D
##   │   └── InteractPopup
##   └── UILayer (CanvasLayer)

@onready var player: Node = null
var _currency_hud: Node


func _ready() -> void:
	_find_player()
	_setup_currency_hud()
	_connect_stations()


# --- Player Setup ---

func _find_player() -> void:
	# Try as direct child first, then search by group
	player = get_node_or_null("Player")
	if player == null:
		player = get_tree().root.get_node_or_null("Player")
	if player == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
	
	if player:
		if not player.is_in_group("player"):
			player.add_to_group("player")
		# Hide combat UI elements in hub
		if player.get("run_hud") and player.run_hud.has_method("set_hub_mode"):
			player.run_hud.set_hub_mode(true)
	else:
		push_warning("[Hub] Player not found in scene tree.")
		
func _setup_currency_hud() -> void:
	var root = get_tree().root
	
	# Remove old HUD if lingering from a previous hub load
	var old_layer = root.get_node_or_null("CurrencyHUDLayer")
	if old_layer:
		old_layer.queue_free()
	var old_hub = root.get_node_or_null("HubHUD")
	if old_hub:
		old_hub.queue_free()
	
	var HubHUDScript = load("res://GUI/HubHUD.gd")
	if HubHUDScript:
		_currency_hud = HubHUDScript.new()
		root.add_child(_currency_hud)
		
# --- Station Connections ---

func _connect_stations() -> void:
	# 1. The Well (Run Start)
	var well = get_node_or_null("TheWell")
	if well:
		well.run_started.connect(_on_run_started)

	# 2. Forge Bench (Prosthetics)
	var forge = get_node_or_null("ForgeBench")
	if forge:
		forge.prosthetic_equipped.connect(_on_prosthetic_equipped)

	# 3. Codex Board — no hub-level signals needed yet

	# 4. Quest Altar
	var altar = get_node_or_null("QuestAltar")
	if altar:
		altar.reward_claimed.connect(_on_quest_reward_claimed)

	# 5. Meta Progression Shrine
	var shrine = get_node_or_null("MetaShrine")
	if shrine:
		shrine.upgrade_purchased.connect(_on_meta_upgrade_purchased)

	# 6. Merchant Stall
	var merchant = get_node_or_null("MerchantStall")
	if merchant:
		merchant.item_purchased.connect(_on_merchant_item_purchased)

	# 7. Practice Grounds
	var practice = get_node_or_null("PracticeGrounds")
	if practice:
		practice.practice_started.connect(_on_practice_started)
		practice.practice_ended.connect(_on_practice_ended)


# --- Signal Handlers ---

func _on_run_started():
	print("[Hub] Run started — transitioning to dungeon...")
	# TODO: Scene transition to RunScene

func _on_prosthetic_equipped(prosthetic_id: String):
	print("[Hub] Prosthetic equipped: ", prosthetic_id)
	# Legacy support — remove when ArmoryMenu is fully replaced
	Global.selected_weapon_name = prosthetic_id

func _on_quest_reward_claimed(quest_id: String):
	print("[Hub] Quest reward claimed: ", quest_id)

func _on_meta_upgrade_purchased(upgrade_id: String):
	print("[Hub] Meta upgrade purchased: ", upgrade_id)

func _on_merchant_item_purchased(item_id: String):
	print("[Hub] Merchant purchase: ", item_id)

func _on_practice_started():
	print("[Hub] Practice mode entered")
	# TODO: Optional — disable other station interactions during practice

func _on_practice_ended():
	print("[Hub] Practice mode exited")

func _exit_tree() -> void:
	# Remove HubHUD from root when leaving hub
	if _currency_hud and is_instance_valid(_currency_hud):
		_currency_hud.queue_free()
		_currency_hud = null
	
	# Restore RunHUD to combat mode
	if player and is_instance_valid(player) and player.get("run_hud"):
		if player.run_hud.has_method("set_hub_mode"):
			player.run_hud.set_hub_mode(false)
