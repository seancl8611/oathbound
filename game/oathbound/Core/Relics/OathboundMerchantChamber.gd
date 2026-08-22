extends "res://Core/Chambers/Types/MerchantChamber.gd"

## Current Shop Relic overlay.
## Merchant's Seal changes only the first item actually purchased in each region.
## Offer generation/grants remain owned by the current Merchant chamber.

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


func _relic_runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")
