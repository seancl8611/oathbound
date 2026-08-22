extends "res://Core/Chambers/Types/MerchantChamber.gd"

## Current Shop + Merchant's Seal overlay.
##
## ITEMS_AND_REWARDS.md defines three live Shop categories and stable prototype prices:
## Survival / Build / Flex. The imported Boon/Mist-Shard/Boss-Emblem inventory is not
## current Oathbound behavior. Flex weighting below is first-playtest tuning except the
## documented ~10% Relic opportunity when an eligible run-discovery pool exists.

const CURRENT_SURVIVAL_OFFERS: Array[Dictionary] = [
	{"key": "moderate_health", "label": "Restore 25% Health", "cost": 35, "percent": 0.25},
	{"key": "moderate_spirit", "label": "Restore 30% Spirit", "cost": 30, "percent": 0.30},
]

const CURRENT_BUILD_OFFERS: Array[Dictionary] = [
	{"key": "technique", "label": "Technique", "cost": 100},
	{"key": "temp_maxhp", "label": "+15% Max Health This Run", "cost": 65, "percent": 0.15},
	{"key": "temp_spirit", "label": "+20% Max Spirit This Run", "cost": 60, "percent": 0.20},
	{"key": "reroll", "label": "+1 Technique Reroll", "cost": 45, "amount": 1},
]

# First-playtest Flex weights. Relic remains exactly 10% when eligible; the other
# weights are tuning and can move without changing the approved Shop structure.
const CURRENT_FLEX_OFFERS: Array[Dictionary] = [
	{"key": "technique", "label": "Technique", "cost": 100, "weight": 22.0},
	{"key": "temp_maxhp", "label": "+15% Max Health This Run", "cost": 65, "percent": 0.15, "weight": 16.0},
	{"key": "temp_spirit", "label": "+20% Max Spirit This Run", "cost": 60, "percent": 0.20, "weight": 16.0},
	{"key": "reroll", "label": "+1 Technique Reroll", "cost": 45, "amount": 1, "weight": 10.0},
	{"key": "large_health", "label": "Restore 45% Health", "cost": 55, "percent": 0.45, "weight": 13.0},
	{"key": "large_spirit", "label": "Restore 50% Spirit", "cost": 50, "percent": 0.50, "weight": 13.0},
	{"key": "relic", "label": "Relic Discovery", "cost": 140, "weight": 10.0},
]


func _roll_offers() -> void:
	_offer_a = _pick_random_offer(CURRENT_SURVIVAL_OFFERS)
	_offer_b = _pick_random_offer(CURRENT_BUILD_OFFERS)
	_offer_c = _pick_flex_offer(str(_offer_b.get("key", "")))
	print("[OathboundMerchant] current offers survival=%s build=%s flex=%s" % [
		str(_offer_a.get("key", "")), str(_offer_b.get("key", "")), str(_offer_c.get("key", "")),
	])


func _pick_random_offer(pool: Array[Dictionary]) -> Dictionary:
	if pool.is_empty():
		return {}
	var index: int = randi_range(0, pool.size() - 1)
	return pool[index].duplicate(true)


func _pick_flex_offer(exclude_key: String) -> Dictionary:
	var candidates: Array[Dictionary] = []
	var total_weight: float = 0.0
	for source: Dictionary in CURRENT_FLEX_OFFERS:
		var key: String = str(source.get("key", ""))
		if key == exclude_key:
			continue
		if key == "relic" and not _has_eligible_relic_discovery():
			continue
		var item: Dictionary = source.duplicate(true)
		var weight: float = maxf(0.0, float(item.get("weight", 0.0)))
		if weight <= 0.0:
			continue
		candidates.append(item)
		total_weight += weight
	if candidates.is_empty() or total_weight <= 0.0:
		return _pick_random_offer(CURRENT_SURVIVAL_OFFERS)

	var roll: float = randf() * total_weight
	var cumulative: float = 0.0
	for candidate: Dictionary in candidates:
		cumulative += float(candidate.get("weight", 0.0))
		if roll <= cumulative:
			candidate.erase("weight")
			return candidate
	var fallback: Dictionary = candidates[candidates.size() - 1].duplicate(true)
	fallback.erase("weight")
	return fallback


func _grant_offer(offer: Dictionary) -> void:
	var key: String = str(offer.get("key", ""))
	match key:
		"moderate_health", "large_health":
			_restore_health_percent(float(offer.get("percent", 0.0)))
		"moderate_spirit", "large_spirit":
			_restore_spirit_percent(float(offer.get("percent", 0.0)))
		"technique":
			_trigger_shop_technique()
		"reroll":
			if typeof(RunData) == TYPE_OBJECT:
				RunData.add_technique_rerolls(int(offer.get("amount", 1)))
		"temp_maxhp":
			_grant_temporary_max_health(float(offer.get("percent", 0.15)))
		"temp_spirit":
			_grant_temporary_max_spirit(float(offer.get("percent", 0.20)))
		"relic":
			# Exact 4 run-discovered Relic identities remain a deferred content-sequencing
			# decision. This key is only eligible once a configured pool API exists.
			push_warning("[OathboundMerchant] Relic opportunity selected without configured run-discovery pool")
		_:
			push_warning("[OathboundMerchant] Unknown current offer: %s" % key)

	_play_purchase_sound()
	print("[OathboundMerchant] Purchased: %s" % str(offer.get("label", key)))


func _restore_health_percent(percent: float) -> void:
	var player: Node = _get_player()
	if player == null or not ("hp" in player) or not ("maxhp" in player):
		return
	var amount: int = maxi(1, int(round(float(player.get("maxhp")) * maxf(0.0, percent))))
	if player.has_method("heal"):
		player.call("heal", amount)
	else:
		player.set("hp", mini(int(player.get("maxhp")), int(player.get("hp")) + amount))
		if player.has_method("_update_health_bar"):
			player.call("_update_health_bar")


func _restore_spirit_percent(percent: float) -> void:
	var executor: Node = _player_prosthetic_executor()
	if executor == null or not executor.has_method("add_spirit"):
		return
	var maximum: int = int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else 100
	var amount: int = maxi(1, int(round(float(maximum) * maxf(0.0, percent))))
	executor.call("add_spirit", amount)


func _grant_temporary_max_health(percent: float) -> void:
	var player: Node = _get_player()
	if player == null or not ("hp" in player) or not ("maxhp" in player):
		return
	if not player.has_meta("_oathbound_run_start_max_health"):
		player.set_meta("_oathbound_run_start_max_health", int(player.get("maxhp")))
	var starting_max: int = maxi(1, int(player.get_meta("_oathbound_run_start_max_health")))
	var amount: int = maxi(1, int(round(float(starting_max) * maxf(0.0, percent))))
	player.set("maxhp", int(player.get("maxhp")) + amount)
	player.set("hp", mini(int(player.get("maxhp")), int(player.get("hp")) + amount))
	if player.has_method("_update_health_bar"):
		player.call("_update_health_bar")


func _grant_temporary_max_spirit(percent: float) -> void:
	var executor: Node = _player_prosthetic_executor()
	if executor == null:
		return
	var current_max: int = int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else 100
	if not executor.has_meta("_oathbound_run_start_max_spirit"):
		executor.set_meta("_oathbound_run_start_max_spirit", current_max)
	var starting_max: int = maxi(1, int(executor.get_meta("_oathbound_run_start_max_spirit")))
	var amount: int = maxi(1, int(round(float(starting_max) * maxf(0.0, percent))))
	var current_spirit: int = int(executor.call("get_spirit")) if executor.has_method("get_spirit") else current_max
	executor.set("max_spirit", current_max + amount)
	executor.set("current_spirit", mini(current_max + amount, current_spirit + amount))
	if executor.has_signal("spirit_changed"):
		executor.emit_signal("spirit_changed", int(executor.get("current_spirit")), int(executor.get("max_spirit")))


func _trigger_shop_technique() -> void:
	var upgrade_ui: Node = get_tree().get_first_node_in_group("upgrade_ui")
	if upgrade_ui == null:
		var ui_scene: PackedScene = preload("res://Utility/UpgradeChoiceUI.tscn")
		upgrade_ui = ui_scene.instantiate()
		upgrade_ui.add_to_group("upgrade_ui")
		upgrade_ui.set("layer", 100)
		upgrade_ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		add_child(upgrade_ui)
	var area_id: int = _get_area_id()
	var choices: Array = UpgradeService.get_three_choices_for_source("shop", area_id)
	if upgrade_ui.has_method("open_with_context"):
		upgrade_ui.call("open_with_context", choices, "shop", area_id)
	else:
		upgrade_ui.call("open_with_choices", choices)


# =============================================================================
# MERCHANT'S SEAL
# =============================================================================

func _has_enough_gold(cost: int) -> bool:
	return _get_gold() >= _effective_price(cost)


func _spend_gold(cost: int) -> bool:
	var paid_price: int = _effective_price(cost)
	var spent: bool = false
	var rd: Node = get_node_or_null("/root/RunData")
	if rd != null and rd.has_method("spend_gold"):
		spent = bool(rd.call("spend_gold", paid_price))
	else:
		spent = bool(CurrencyManager.spend(CurrencyManager.Currency.GOLD, paid_price))
	if not spent:
		return false

	var runtime: Node = _relic_runtime()
	if runtime != null and runtime.has_method("consume_shop_discount"):
		runtime.call("consume_shop_discount", _get_area_id(), maxi(0, cost), paid_price)
	return true


func _update_prompt(pedestal_id: String) -> void:
	var prompt: Label = _get_prompt(pedestal_id)
	if prompt == null:
		return
	var offer: Dictionary = _get_offer(pedestal_id)
	var bought: bool = _is_bought(pedestal_id)
	if bought:
		prompt.text = "Sold"
	else:
		var base_cost: int = int(offer.get("cost", 0))
		var effective_cost: int = _effective_price(base_cost)
		var gold: int = _get_gold()
		if effective_cost < base_cost:
			prompt.text = "%s — %dG → %dG (You: %dG)" % [
				str(offer.get("label", "???")), base_cost, effective_cost, gold,
			]
		else:
			prompt.text = "%s — %dG (You: %dG)" % [str(offer.get("label", "???")), effective_cost, gold]
	prompt.visible = true


func _effective_price(base_cost: int) -> int:
	var runtime: Node = _relic_runtime()
	if runtime != null and runtime.has_method("get_effective_shop_price"):
		return int(runtime.call("get_effective_shop_price", maxi(0, base_cost), _get_area_id()))
	return maxi(0, base_cost)


func _has_eligible_relic_discovery() -> bool:
	var runtime: Node = _relic_runtime()
	if runtime == null or not runtime.has_method("get_eligible_run_discoveries"):
		return false
	var eligible_value: Variant = runtime.call("get_eligible_run_discoveries")
	return eligible_value is Array and not (eligible_value as Array).is_empty()


func _player_prosthetic_executor() -> Node:
	var player: Node = _get_player()
	if player == null:
		return null
	var executor_value: Variant = player.get("prosthetic_executor")
	return executor_value as Node if executor_value is Node and is_instance_valid(executor_value) else null


func _relic_runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")
