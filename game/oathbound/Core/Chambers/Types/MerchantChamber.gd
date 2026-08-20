extends RoomBase

## =============================================================================
## SHOP ROOM — Hades-style Power / Meta / Flex pedestals
## =============================================================================
## Scene tree expects:
##   $HealPedestal      → used as Pedestal A (Power)
##   $RelicPedestal     → used as Pedestal B (Meta)
##   $ConsumablePedestal → used as Pedestal C (Flex)
##   Each has: CollisionShape2D, Prompt (Label), ItemSprite (Node2D)
## =============================================================================

@export var interact_action: String = "interact"

# Scene node references (reusing existing pedestal nodes)
@onready var pedestal_a: Area2D = $HealPedestal
@onready var prompt_a: Label = $HealPedestal/Prompt
@onready var item_a: Node2D = $HealPedestal/ItemSprite

@onready var pedestal_b: Area2D = $RelicPedestal
@onready var prompt_b: Label = $RelicPedestal/Prompt
@onready var item_b: Node2D = $RelicPedestal/ItemSprite

@onready var pedestal_c: Area2D = $ConsumablePedestal
@onready var prompt_c: Label = $ConsumablePedestal/Prompt
@onready var item_c: Node2D = $ConsumablePedestal/ItemSprite

@onready var exit_gate: Node = $ExitGate

# =============================================================================
# OFFER DATA TABLES (area_id -> {item_key -> {label, cost, amount}})
# =============================================================================

const POWER_OFFERS = {
	1: {
		"boon":        {"label": "Boon",         "cost": 100},
		"maxhp":       {"label": "+3 Max HP",    "cost": 75,  "amount": 3},
		"maxposture":  {"label": "+5 Posture",   "cost": 60,  "amount": 5},
	},
	2: {
		"boon":        {"label": "Boon",         "cost": 150},
		"maxhp":       {"label": "+4 Max HP",    "cost": 110, "amount": 4},
		"maxposture":  {"label": "+7 Posture",   "cost": 90,  "amount": 7},
	},
	3: {
		"boon":        {"label": "Boon",         "cost": 200},
		"maxhp":       {"label": "+5 Max HP",    "cost": 150, "amount": 5},
		"maxposture":  {"label": "+10 Posture",  "cost": 120, "amount": 10},
	},
}

const META_OFFERS = {
	1: {
		"mist":   {"label": "2 Mist Shards", "cost": 65,  "amount": 2},
		"scroll": {"label": "1 Scroll",      "cost": 80,  "amount": 1},
	},
	2: {
		"mist":   {"label": "3 Mist Shards", "cost": 100, "amount": 3},
		"scroll": {"label": "1 Scroll",      "cost": 120, "amount": 1},
	},
	3: {
		"mist":     {"label": "4 Mist Shards",  "cost": 140, "amount": 4},
		"scroll":   {"label": "2 Scrolls",      "cost": 160, "amount": 2},
		"emblem":   {"label": "Boss Emblem",     "cost": 350, "amount": 1},
	},
}

const HEAL_OFFERS = {
	1: {"label": "Heal 8 HP",  "cost": 45,  "amount": 8},
	2: {"label": "Heal 12 HP", "cost": 65,  "amount": 12},
	3: {"label": "Heal 15 HP", "cost": 85,  "amount": 15},
}

# Flex weights when HP > 35%
const FLEX_WEIGHTS = {
	"boon": 30, "maxhp": 20, "maxposture": 20,
	"mist": 15, "scroll": 15, "heal": 5,
}

# =============================================================================
# STATE
# =============================================================================

var _offer_a: Dictionary = {}  # {key, label, cost, amount?}
var _offer_b: Dictionary = {}
var _offer_c: Dictionary = {}

var _bought_a: bool = false
var _bought_b: bool = false
var _bought_c: bool = false

var _near_pedestal: String = ""  # "a", "b", "c", or ""

func _ready() -> void:
	# Shop is optional — both gates open from the start
	# Do NOT call lock_all_gates() here
	
	var gate1 = get_node_or_null("ExitGate")
	var gate2 = get_node_or_null("ExitGate2")
	
	# Ensure both gates are unlocked and open
	for gate in [gate1, gate2]:
		if gate == null:
			continue
		if gate.has_method("unlock"):
			gate.call_deferred("unlock")
		if gate.has_method("open"):
			gate.call_deferred("open")
	
	# Connect pedestal triggers
	if pedestal_a:
		pedestal_a.body_entered.connect(_on_enter.bind("a"))
		pedestal_a.body_exited.connect(_on_exit.bind("a"))
	if pedestal_b:
		pedestal_b.body_entered.connect(_on_enter.bind("b"))
		pedestal_b.body_exited.connect(_on_exit.bind("b"))
	if pedestal_c:
		pedestal_c.body_entered.connect(_on_enter.bind("c"))
		pedestal_c.body_exited.connect(_on_exit.bind("c"))
	
	_hide_all_prompts()
	_roll_offers()
	
func _physics_process(_delta: float) -> void:
	if _near_pedestal == "":
		return
	if Input.is_action_just_pressed(interact_action):
		match _near_pedestal:
			"a":
				_try_buy("a")
			"b":
				_try_buy("b")
			"c":
				_try_buy("c")


# =============================================================================
# OFFER GENERATION
# =============================================================================

func _roll_offers() -> void:
	var area_id = _get_area_id()
	var used_keys: Array = []
	
	# Pedestal A — Power (random from pool)
	var power_pool = POWER_OFFERS.get(area_id, POWER_OFFERS[1])
	var power_keys = power_pool.keys()
	power_keys.shuffle()
	var a_key = power_keys[0]
	_offer_a = power_pool[a_key].duplicate()
	_offer_a["key"] = a_key
	used_keys.append(a_key)
	
	# Pedestal B — Meta (random from pool, exclude boss emblem if not unlocked)
	var meta_pool = META_OFFERS.get(area_id, META_OFFERS[1]).duplicate()
	if meta_pool.has("emblem") and not _is_boss_emblem_unlocked():
		meta_pool.erase("emblem")
	var meta_keys = meta_pool.keys()
	meta_keys.shuffle()
	var b_key = meta_keys[0]
	_offer_b = meta_pool[b_key].duplicate()
	_offer_b["key"] = b_key
	used_keys.append(b_key)
	
	# Pedestal C — Flex (weighted random, pity heal, no duplicates)
	_offer_c = _roll_flex_offer(area_id, used_keys)


func _roll_flex_offer(area_id: int, used_keys: Array) -> Dictionary:
	var player = _get_player()
	var hp_ratio = 1.0
	if player and "hp" in player and "maxhp" in player and player.maxhp > 0:
		hp_ratio = float(player.hp) / float(player.maxhp)
	
	# Pity rule: HP <= 35% forces heal
	if hp_ratio <= 0.35:
		var heal_data = HEAL_OFFERS.get(area_id, HEAL_OFFERS[1]).duplicate()
		heal_data["key"] = "heal"
		return heal_data
	
	# Build weighted pool, excluding used keys
	var pool: Array = []
	var weights = FLEX_WEIGHTS.duplicate()
	
	# Remove emblem if not unlocked or not area 3
	if area_id < 3 or not _is_boss_emblem_unlocked():
		weights.erase("emblem")
	
	for key in weights.keys():
		if key in used_keys:
			continue
		pool.append({"key": key, "weight": weights[key]})
	
	if pool.is_empty():
		var heal_data = HEAL_OFFERS.get(area_id, HEAL_OFFERS[1]).duplicate()
		heal_data["key"] = "heal"
		return heal_data
	
	# Weighted selection
	var total_weight = 0
	for entry in pool:
		total_weight += entry["weight"]
	
	var roll = randf() * total_weight
	var cumulative = 0
	var chosen_key = pool[0]["key"]
	for entry in pool:
		cumulative += entry["weight"]
		if roll <= cumulative:
			chosen_key = entry["key"]
			break
	
	# Build the offer dict from the appropriate source table
	return _build_flex_offer(chosen_key, area_id)


func _build_flex_offer(key: String, area_id: int) -> Dictionary:
	var power_pool = POWER_OFFERS.get(area_id, POWER_OFFERS[1])
	var meta_pool = META_OFFERS.get(area_id, META_OFFERS[1])
	var offer = {}
	
	if key == "heal":
		offer = HEAL_OFFERS.get(area_id, HEAL_OFFERS[1]).duplicate()
	elif power_pool.has(key):
		offer = power_pool[key].duplicate()
	elif meta_pool.has(key):
		offer = meta_pool[key].duplicate()
	else:
		offer = {"label": key.capitalize(), "cost": 100}
	
	offer["key"] = key
	return offer


# =============================================================================
# PURCHASE LOGIC
# =============================================================================

func _try_buy(pedestal: String) -> void:
	var offer = {}
	var bought = false
	
	match pedestal:
		"a":
			if _bought_a:
				return
			offer = _offer_a
		"b":
			if _bought_b:
				return
			offer = _offer_b
		"c":
			if _bought_c:
				return
			offer = _offer_c
	
	var cost = int(offer.get("cost", 0))
	if not _has_enough_gold(cost):
		_show_prompt(pedestal, "Need %dG (have %dG)" % [cost, _get_gold()])
		return
	
	if not _spend_gold(cost):
		return
	
	_grant_offer(offer)
	
	match pedestal:
		"a":
			_bought_a = true
			_mark_pedestal_bought(pedestal_a, item_a)
			item_a = null
		"b":
			_bought_b = true
			_mark_pedestal_bought(pedestal_b, item_b)
			item_b = null
		"c":
			_bought_c = true
			_mark_pedestal_bought(pedestal_c, item_c)
			item_c = null
	
	_update_prompt(pedestal)

func _grant_offer(offer: Dictionary) -> void:
	var key = offer.get("key", "")
	var amount = int(offer.get("amount", 0))
	var rd = get_node_or_null("/root/RunData")
	var player = _get_player()
	
	match key:
		"boon":
			_trigger_boon_selection()
		"maxhp":
			if player and "maxhp" in player:
				player.maxhp += amount
				player.hp = min(player.hp + amount, player.maxhp)
				if player.has_method("_update_health_bar"):
					player._update_health_bar()
			_show_toast("maxhp", amount)
		"maxposture":
			if player and "stagger_max" in player:
				player.stagger_max += amount
			_show_toast("maxposture", amount)
		"mist":
			if rd:
				rd.add_mist_shards(amount)
			_show_toast("mist", amount)
		"scroll":
			if rd:
				rd.add_scrolls(amount)
			_show_toast("scroll", amount)
		"emblem":
			CurrencyManager.add(CurrencyManager.Currency.BOSS_EMBLEM, amount)
			_show_toast("emblem", amount)
		"heal":
			if player:
				if player.has_method("heal"):
					player.heal(amount)
				elif "hp" in player and "maxhp" in player:
					player.hp = min(player.maxhp, player.hp + amount)
					if player.has_method("_update_health_bar"):
						player._update_health_bar()
	
	_play_purchase_sound()
	print("[ShopRoom] Purchased: %s" % offer.get("label", key))


func _show_toast(reward_key: String, amount: int) -> void:
	var player = _get_player()
	if player and "run_hud" in player and player.run_hud != null:
		if player.run_hud.has_method("show_currency_toast"):
			player.run_hud.show_currency_toast(reward_key, amount)
			
func _trigger_boon_selection() -> void:
	var upgrade_ui = get_tree().get_first_node_in_group("upgrade_ui")
	if upgrade_ui == null:
		var ui_scene = preload("res://Utility/UpgradeChoiceUI.tscn")
		upgrade_ui = ui_scene.instantiate()
		upgrade_ui.add_to_group("upgrade_ui")
		upgrade_ui.layer = 100
		upgrade_ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		add_child(upgrade_ui)
	
	var choices = UpgradeService.get_three_choices()
	upgrade_ui.visible = true
	upgrade_ui.open_with_choices(choices)
	# Note: choice_made signal is already handled by UpgradeChoiceUI internally
	# The UI pauses tree and unpauses on selection


# =============================================================================
# PEDESTAL ENTER / EXIT
# =============================================================================

func _on_enter(body: Node, pedestal_id: String) -> void:
	if not body.is_in_group("player"):
		return
	_near_pedestal = pedestal_id
	_update_prompt(pedestal_id)
	
	var item_node = _get_item_node(pedestal_id)
	if item_node and is_instance_valid(item_node) and item_node.has_method("set_player_nearby"):
		item_node.set_player_nearby(true)


func _on_exit(body: Node, pedestal_id: String) -> void:
	if not body.is_in_group("player"):
		return
	if _near_pedestal == pedestal_id:
		_near_pedestal = ""
	
	var prompt = _get_prompt(pedestal_id)
	if prompt:
		prompt.visible = false
	
	var item_node = _get_item_node(pedestal_id)
	if item_node and is_instance_valid(item_node) and item_node.has_method("set_player_nearby"):
		item_node.set_player_nearby(false)


# =============================================================================
# PROMPT HELPERS
# =============================================================================

func _update_prompt(pedestal_id: String) -> void:
	var prompt = _get_prompt(pedestal_id)
	if prompt == null:
		return
	
	var offer = _get_offer(pedestal_id)
	var bought = _is_bought(pedestal_id)
	
	if bought:
		prompt.text = "Sold"
	else:
		var gold = _get_gold()
		prompt.text = "%s — %dG (You: %dG)" % [offer.get("label", "???"), offer.get("cost", 0), gold]
	
	prompt.visible = true


func _show_prompt(pedestal_id: String, text: String) -> void:
	var prompt = _get_prompt(pedestal_id)
	if prompt:
		prompt.text = text
		prompt.visible = true


func _hide_all_prompts() -> void:
	if prompt_a:
		prompt_a.visible = false
	if prompt_b:
		prompt_b.visible = false
	if prompt_c:
		prompt_c.visible = false


# =============================================================================
# LOOKUP HELPERS
# =============================================================================

func _get_offer(pedestal_id: String) -> Dictionary:
	match pedestal_id:
		"a": return _offer_a
		"b": return _offer_b
		"c": return _offer_c
	return {}

func _is_bought(pedestal_id: String) -> bool:
	match pedestal_id:
		"a": return _bought_a
		"b": return _bought_b
		"c": return _bought_c
	return false

func _get_prompt(pedestal_id: String) -> Label:
	match pedestal_id:
		"a": return prompt_a
		"b": return prompt_b
		"c": return prompt_c
	return null

func _get_item_node(pedestal_id: String) -> Node2D:
	match pedestal_id:
		"a": return item_a
		"b": return item_b
		"c": return item_c
	return null

func _get_area_id() -> int:
	var rd = get_node_or_null("/root/RunData")
	if rd and "current_area_id" in rd:
		return rd.current_area_id
	return 1

func _is_boss_emblem_unlocked() -> bool:
	# TODO: Check Global or MetaProgressionManager for boss defeat flag
	# For now, return false (emblem never appears until you wire this)
	return false


# =============================================================================
# CURRENCY HELPERS
# =============================================================================

func _get_gold() -> int:
	var rd = get_node_or_null("/root/RunData")
	if rd:
		return rd.gold
	return CurrencyManager.get_amount(CurrencyManager.Currency.GOLD)

func _has_enough_gold(cost: int) -> bool:
	return _get_gold() >= cost

func _spend_gold(cost: int) -> bool:
	var rd = get_node_or_null("/root/RunData")
	if rd:
		return rd.spend_gold(cost)
	return CurrencyManager.spend(CurrencyManager.Currency.GOLD, cost)


# =============================================================================
# VISUAL HELPERS
# =============================================================================

func _mark_pedestal_bought(pedestal: Area2D, item_node: Node2D) -> void:
	var mat_sprite = pedestal.get_node_or_null("MatSprite")
	if mat_sprite == null:
		mat_sprite = pedestal.get_node_or_null("Sprite2D")
	if mat_sprite and mat_sprite is Sprite2D:
		var tween = create_tween()
		tween.tween_property(mat_sprite, "modulate", Color(0.3, 0.3, 0.3, 0.8), 0.3)

	var player = _get_player()
	if item_node and is_instance_valid(item_node) and player and item_node.has_method("play_collect_animation"):
		var target_pos = player.global_position + Vector2(0, -16)
		item_node.play_collect_animation(target_pos)
	elif item_node and is_instance_valid(item_node) and item_node.has_method("set_dimmed"):
		item_node.set_dimmed(true)
	elif item_node and is_instance_valid(item_node) and item_node is Sprite2D:
		item_node.modulate = Color(1.0, 1.0, 1.0, 0.2)


func _play_purchase_sound() -> void:
	pass


func _get_player() -> Node:
	var p = get_tree().get_first_node_in_group("player")
	if p == null:
		push_warning("[ShopRoom] No player found")
	return p
