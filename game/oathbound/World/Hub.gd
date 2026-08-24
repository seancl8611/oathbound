extends Node2D

## Hub — Central hub scene connecting all player-facing stations.
##
## Expected scene tree (Area2D nodes with HubInteractable-derived scripts):
##   Hub (Node2D)
##   ├── Sprite2D                  (background)
##   ├── Player
##   ├── TheWell                   (Area2D — run start, was BattleDoor)
##   ├── ForgeBench                (Area2D — prosthetics, was ArmoryObject)
##   ├── CodexBoard                (Area2D — discovery log / records)
##   ├── QuestAltar
##   ├── MetaShrine
##   ├── MerchantStall
##   ├── PracticeGrounds
##   └── UILayer (CanvasLayer)

const RUN_RESULTS_OVERLAY = preload("res://Core/Release/OathboundAccessibleRunResultsOverlay.gd")

@onready var player: Node = null
var _currency_hud: Node


func _ready() -> void:
	_find_player()
	_setup_currency_hud()
	_connect_stations()
	call_deferred("_show_pending_run_result")


# --- Player Setup ---

func _find_player() -> void:
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
		if player.get("run_hud") and player.run_hud.has_method("set_hub_mode"):
			player.run_hud.set_hub_mode(true)
	else:
		push_warning("[Hub] Player not found in scene tree.")


func _setup_currency_hud() -> void:
	var root = get_tree().root
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


func _show_pending_run_result() -> void:
	if typeof(RecordsRuntime) != TYPE_OBJECT or not RecordsRuntime.has_method("consume_pending_result"):
		return
	var result: Dictionary = RecordsRuntime.consume_pending_result()
	if result.is_empty():
		return
	var overlay_value: Variant = RUN_RESULTS_OVERLAY.new()
	if not (overlay_value is CanvasLayer):
		push_error("[Hub] Could not create run-results overlay")
		return
	var overlay := overlay_value as CanvasLayer
	get_tree().root.add_child(overlay)
	overlay.present(result)


# --- Station Connections ---

func _connect_stations() -> void:
	var well = get_node_or_null("TheWell")
	if well:
		well.run_started.connect(_on_run_started)

	var forge = get_node_or_null("ForgeBench")
	if forge:
		forge.prosthetic_equipped.connect(_on_prosthetic_equipped)

	var altar = get_node_or_null("QuestAltar")
	if altar:
		altar.reward_claimed.connect(_on_quest_reward_claimed)

	var shrine = get_node_or_null("MetaShrine")
	if shrine:
		shrine.upgrade_purchased.connect(_on_meta_upgrade_purchased)

	var merchant = get_node_or_null("MerchantStall")
	if merchant:
		merchant.item_purchased.connect(_on_merchant_item_purchased)

	var practice = get_node_or_null("PracticeGrounds")
	if practice:
		practice.practice_started.connect(_on_practice_started)
		practice.practice_ended.connect(_on_practice_ended)


# --- Signal Handlers ---

func _on_run_started():
	print("[Hub] Run started — transitioning to dungeon...")

func _on_prosthetic_equipped(prosthetic_id: String):
	print("[Hub] Prosthetic equipped: ", prosthetic_id)
	Global.selected_weapon_name = prosthetic_id

func _on_quest_reward_claimed(quest_id: String):
	print("[Hub] Quest reward claimed: ", quest_id)

func _on_meta_upgrade_purchased(upgrade_id: String):
	print("[Hub] Meta upgrade purchased: ", upgrade_id)
	if typeof(RecordsRuntime) == TYPE_OBJECT:
		RecordsRuntime.recalculate_completion()

func _on_merchant_item_purchased(item_id: String):
	print("[Hub] Merchant purchase: ", item_id)

func _on_practice_started():
	print("[Hub] Practice mode entered")

func _on_practice_ended():
	print("[Hub] Practice mode exited")

func _exit_tree() -> void:
	if _currency_hud and is_instance_valid(_currency_hud):
		_currency_hud.queue_free()
		_currency_hud = null
	
	if player and is_instance_valid(player) and player.get("run_hud"):
		if player.run_hud.has_method("set_hub_mode"):
			player.run_hud.set_hub_mode(false)
