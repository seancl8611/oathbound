extends "res://GUI/MerchantMenu.gd"

## Release presentation layer for the existing MerchantMenu authority. Stock, prices,
## ownership, purchase callbacks, currency mutation, and progression remain owned by
## MerchantMenu/MerchantManager/ProstheticManager. This layer only resolves visible
## copy from stable IDs and applies shared readability styling.

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")


func _ready():
	super._ready()
	call_deferred("_refresh_release_presentation")


func _refresh_tab():
	super._refresh_tab()
	call_deferred("_refresh_release_presentation")


func _show_confirmation(text: String, on_confirm: Callable):
	super._show_confirmation(_localize_confirmation(text), on_confirm)
	call_deferred("_refresh_release_presentation")


func _show_mystery_result(prosthetic_id: String):
	super._show_mystery_result(prosthetic_id)
	call_deferred("_refresh_release_presentation")


func _refresh_release_presentation() -> void:
	_localize_static_copy()
	_localize_stat_catalog()
	_localize_prosthetic_catalog()
	_localize_cosmetic_catalog()
	_localize_dynamic_copy()
	READABILITY_STYLER.apply(self)


func _localize_static_copy() -> void:
	var replacements: Dictionary = {
		"MERCHANT STALL": LOCALIZATION.ui("merchant.title", "MERCHANT STALL"),
		"Upgrades": LOCALIZATION.ui("merchant.tab.upgrades", "Upgrades"),
		"Prosthetics": LOCALIZATION.ui("merchant.tab.prosthetics", "Prosthetics"),
		"Cosmetics": LOCALIZATION.ui("merchant.tab.cosmetics", "Cosmetics"),
		"Mystery": LOCALIZATION.ui("merchant.tab.mystery", "Mystery"),
		"Stat Upgrades": LOCALIZATION.ui("merchant.upgrades.title", "Stat Upgrades"),
		"Small permanent buffs. Each stat has a hard cap.": LOCALIZATION.ui("merchant.upgrades.description", "Small permanent buffs. Each stat has a hard cap."),
		"Purchase prosthetic tools. Equip them at the Forge Bench.": LOCALIZATION.ui("merchant.prosthetics.description", "Purchase prosthetic tools. Equip them at the Forge Bench."),
		"Visual customizations for your character and runs.": LOCALIZATION.ui("merchant.cosmetics.description", "Visual customizations for your character and runs."),
		"Mystery Prosthetic": LOCALIZATION.ui("merchant.mystery.title", "Mystery Prosthetic"),
		"Player Skins": LOCALIZATION.ui("merchant.category.player_skin", "Player Skins"),
		"Wheel Variants": LOCALIZATION.ui("merchant.category.wheel_variant", "Wheel Variants"),
		"Room Variants": LOCALIZATION.ui("merchant.category.room_variant", "Room Variants"),
		"Other": LOCALIZATION.ui("merchant.category.misc", "Other"),
		"MAXED": LOCALIZATION.ui("status.maxed", "MAXED"),
		"OWNED": LOCALIZATION.ui("status.owned", "OWNED"),
		"No prosthetics in stock.": LOCALIZATION.ui("merchant.prosthetics.empty", "No prosthetics in stock."),
		"You own all available prosthetics!": LOCALIZATION.ui("merchant.prosthetics.all_owned", "You own all available prosthetics!"),
		"No cosmetics available yet.": LOCALIZATION.ui("merchant.cosmetics.empty", "No cosmetics available yet."),
		"The merchant has nothing mysterious to offer right now. Come back after a few more runs...": LOCALIZATION.ui("merchant.mystery.unavailable", "The merchant has nothing mysterious to offer right now. Come back after a few more runs..."),
		"You already own every prosthetic. Nothing left to discover!": LOCALIZATION.ui("merchant.mystery.complete", "You already own every prosthetic. Nothing left to discover!"),
		"? Mysterious Offering ?": LOCALIZATION.ui("merchant.mystery.offering", "? Mysterious Offering ?"),
		"Pay a hefty sum for a random prosthetic you don't own. Risky, but rewarding.": LOCALIZATION.ui("merchant.mystery.description", "Pay a hefty sum for a random prosthetic you don't own. Risky, but rewarding."),
		"Roll the Dice": LOCALIZATION.ui("merchant.mystery.roll", "Roll the Dice"),
		"Not enough Mist Shards": LOCALIZATION.ui("merchant.not_enough_mist", "Not enough Mist Shards"),
		"You received...": LOCALIZATION.ui("merchant.mystery.received", "You received..."),
		"Equip it at the Forge Bench.": LOCALIZATION.ui("merchant.mystery.forge_hint", "Equip it at the Forge Bench."),
		"Nice!": LOCALIZATION.ui("merchant.mystery.accept", "Nice!"),
		"Buy": LOCALIZATION.ui("merchant.confirm.buy_action", "Buy"),
		"Cancel": LOCALIZATION.ui("common.cancel", "Cancel"),
	}
	for node: Node in find_children("*", "Control", true, false):
		if node is Label:
			var label := node as Label
			if replacements.has(label.text):
				label.text = str(replacements[label.text])
		elif node is Button:
			var button := node as Button
			if replacements.has(button.text):
				button.text = str(replacements[button.text])


func _localize_stat_catalog() -> void:
	if typeof(MerchantManager) != TYPE_OBJECT:
		return
	for stat_id_value: Variant in MerchantManager.stat_upgrade_defs.keys():
		var stat_id: String = str(stat_id_value)
		var data: Dictionary = MerchantManager.stat_upgrade_defs.get(stat_id, {})
		var fallback_name: String = str(data.get("display_name", stat_id))
		var fallback_details: String = str(data.get("description", ""))
		_replace_token(fallback_name, LOCALIZATION.catalog_name("merchant_stat", stat_id, fallback_name))
		if not fallback_details.is_empty():
			_replace_token(fallback_details, LOCALIZATION.catalog_details("merchant_stat", stat_id, fallback_details))


func _localize_prosthetic_catalog() -> void:
	if typeof(ProstheticManager) != TYPE_OBJECT:
		return
	for prosthetic_id_value: Variant in ProstheticManager.get_all_prosthetic_ids():
		var prosthetic_id: String = str(prosthetic_id_value)
		var data: Variant = ProstheticManager.get_prosthetic(prosthetic_id)
		if data == null:
			continue
		var fallback_name: String = str(data.display_name) if str(data.display_name) != "" else prosthetic_id.replace("_", " ").capitalize()
		var fallback_details: String = str(data.description)
		_replace_token(fallback_name, LOCALIZATION.catalog_name("prosthetic", prosthetic_id, fallback_name))
		if not fallback_details.is_empty():
			_replace_token(fallback_details, LOCALIZATION.catalog_details("prosthetic", prosthetic_id, fallback_details))


func _localize_cosmetic_catalog() -> void:
	if typeof(MerchantManager) != TYPE_OBJECT:
		return
	for cosmetic_id_value: Variant in MerchantManager.get_all_cosmetics():
		var cosmetic_id: String = str(cosmetic_id_value)
		var data: Dictionary = MerchantManager.get_cosmetic_data(cosmetic_id)
		var fallback_name: String = str(data.get("display_name", cosmetic_id))
		var fallback_details: String = str(data.get("description", ""))
		_replace_token(fallback_name, LOCALIZATION.catalog_name("cosmetic", cosmetic_id, fallback_name))
		if not fallback_details.is_empty():
			_replace_token(fallback_details, LOCALIZATION.catalog_details("cosmetic", cosmetic_id, fallback_details))


func _localize_dynamic_copy() -> void:
	var mist_name := LOCALIZATION.ui("currency.mist_shards", "Mist Shards")
	var shards_name := LOCALIZATION.ui("currency.shards_short", "Shards")
	for node: Node in find_children("*", "Control", true, false):
		var text: String = ""
		if node is Label:
			text = (node as Label).text
		elif node is Button:
			text = (node as Button).text
		else:
			continue

		if text.contains("Mist Shards") and mist_name != "Mist Shards":
			text = text.replace("Mist Shards", mist_name)
		elif text.ends_with(" Shards") and shards_name != "Shards":
			text = text.trim_suffix(" Shards") + " " + shards_name

		var pool_suffix := " undiscovered prosthetic(s) remain"
		if text.ends_with(pool_suffix):
			var count_text := text.trim_suffix(pool_suffix)
			if count_text.is_valid_int():
				text = LOCALIZATION.ui("merchant.mystery.pool_remaining", "%d undiscovered prosthetic(s) remain") % int(count_text)

		if node is Label:
			(node as Label).text = text
		else:
			(node as Button).text = text


func _localize_confirmation(text: String) -> String:
	if text.begins_with("Spend ") and text.ends_with(" Mist Shards on a mystery prosthetic?"):
		var raw_cost := text.trim_prefix("Spend ").trim_suffix(" Mist Shards on a mystery prosthetic?")
		if raw_cost.is_valid_int():
			return LOCALIZATION.ui("merchant.confirm.mystery", "Spend %d %s on a mystery prosthetic?") % [int(raw_cost), LOCALIZATION.ui("currency.mist_shards", "Mist Shards")]

	if text.begins_with("Buy "):
		for stat_id_value: Variant in MerchantManager.stat_upgrade_defs.keys():
			var stat_id: String = str(stat_id_value)
			var data: Dictionary = MerchantManager.stat_upgrade_defs.get(stat_id, {})
			var fallback_name: String = str(data.get("display_name", stat_id))
			var localized_name := LOCALIZATION.catalog_name("merchant_stat", stat_id, fallback_name)
			text = text.replace("Buy %s for " % fallback_name, "Buy %s for " % localized_name)
		for prosthetic_id_value: Variant in ProstheticManager.get_all_prosthetic_ids():
			var prosthetic_id: String = str(prosthetic_id_value)
			var prosthetic: Variant = ProstheticManager.get_prosthetic(prosthetic_id)
			if prosthetic == null:
				continue
			var fallback_prosthetic: String = str(prosthetic.display_name) if str(prosthetic.display_name) != "" else prosthetic_id.replace("_", " ").capitalize()
			text = text.replace("Buy %s for " % fallback_prosthetic, "Buy %s for " % LOCALIZATION.catalog_name("prosthetic", prosthetic_id, fallback_prosthetic))
		for cosmetic_id_value: Variant in MerchantManager.get_all_cosmetics():
			var cosmetic_id: String = str(cosmetic_id_value)
			var cosmetic: Dictionary = MerchantManager.get_cosmetic_data(cosmetic_id)
			var fallback_cosmetic: String = str(cosmetic.get("display_name", cosmetic_id))
			text = text.replace("Buy %s for " % fallback_cosmetic, "Buy %s for " % LOCALIZATION.catalog_name("cosmetic", cosmetic_id, fallback_cosmetic))
		if text.ends_with(" Mist Shards?"):
			text = text.trim_suffix(" Mist Shards?") + " " + LOCALIZATION.ui("currency.mist_shards", "Mist Shards") + "?"
		var buy_prefix := LOCALIZATION.ui("merchant.confirm.buy_prefix", "Buy ")
		if text.begins_with("Buy ") and buy_prefix != "Buy ":
			text = buy_prefix + text.trim_prefix("Buy ")
	return text


func _replace_token(fallback: String, translated: String) -> void:
	if fallback.is_empty() or translated == fallback:
		return
	for node: Node in find_children("*", "Control", true, false):
		if node is Label and (node as Label).text.contains(fallback):
			(node as Label).text = (node as Label).text.replace(fallback, translated)
		elif node is Button and (node as Button).text.contains(fallback):
			(node as Button).text = (node as Button).text.replace(fallback, translated)
