extends "res://GUI/ForgeMenu.gd"

## Release presentation layer for the Forge. Purchase/equip/socket authorities remain in
## ForgeMenu + ProstheticManager; this layer only resolves player-facing text by stable
## IDs and applies the shared High Contrast treatment.

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")


func _ready() -> void:
	super._ready()
	call_deferred("_refresh_release_presentation")


func _create_list_item(data: ProstheticData) -> Button:
	var button: Button = super._create_list_item(data)
	var labels: Array[Node] = button.find_children("*", "Label", true, false)
	if not labels.is_empty() and labels[0] is Label:
		(labels[0] as Label).text = LOCALIZATION.catalog_name("prosthetic", data.id, data.display_name)
	if labels.size() >= 2 and labels[1] is Label:
		var subtitle: Label = labels[1] as Label
		if data.id == ProstheticManager.equipped_prosthetic_id:
			subtitle.text = LOCALIZATION.ui("forge.equipped", "EQUIPPED")
		else:
			subtitle.text = _localized_tags(data.tags)
	return button


func _refresh_detail() -> void:
	super._refresh_detail()
	var data_value: Variant = ProstheticManager.get_prosthetic(selected_prosthetic_id)
	if not (data_value is ProstheticData):
		_refresh_release_presentation()
		return
	var data: ProstheticData = data_value as ProstheticData
	var is_equipped: bool = ProstheticManager.equipped_prosthetic_id == selected_prosthetic_id
	detail_name_label.text = LOCALIZATION.catalog_name("prosthetic", data.id, data.display_name)
	detail_desc_label.text = LOCALIZATION.catalog_details("prosthetic", data.id, data.description)
	status_label.text = LOCALIZATION.ui("forge.equipped", "EQUIPPED") if is_equipped else ""
	if data.spirit_cost > 0:
		var cost_template: String = LOCALIZATION.ui("forge.spirit_cost_per_use", "Spirit Cost: %d per use")
		spirit_cost_label.text = cost_template % data.spirit_cost
	else:
		spirit_cost_label.text = LOCALIZATION.ui("forge.spirit_cost_free", "Spirit Cost: Free")
	equip_button.text = LOCALIZATION.ui("forge.unequip", "Unequip") if is_equipped else LOCALIZATION.ui("forge.equip", "Equip")
	_refresh_release_presentation()


func _refresh_relic_slots(data: ProstheticData) -> void:
	super._refresh_relic_slots(data)
	var slots: Array = ProstheticManager.get_socketed_relics(data.id)
	var slot_buttons: Array[Node] = relic_slots_container.get_children()
	for index: int in range(slot_buttons.size()):
		var button_node: Node = slot_buttons[index]
		if not (button_node is Button):
			continue
		var labels: Array[Node] = button_node.find_children("*", "Label", true, false)
		if labels.size() < 2:
			continue
		var relic_id: String = str(slots[index]) if index < slots.size() else ""
		if relic_id.is_empty():
			(labels[0] as Label).text = LOCALIZATION.ui("forge.empty", "Empty")
		else:
			var relic_value: Variant = ProstheticManager.get_relic(relic_id)
			if relic_value is RelicData:
				var relic: RelicData = relic_value as RelicData
				(labels[0] as Label).text = LOCALIZATION.catalog_name("relic", relic.id, relic.display_name)
		var slot_template: String = LOCALIZATION.ui("forge.slot", "Slot %d")
		(labels[1] as Label).text = slot_template % (index + 1)
	_apply_readability()


func _show_relic_popup() -> void:
	super._show_relic_popup()
	var remove_button: Node = relic_popup.find_child("RemoveRelicBtn", true, false)
	if remove_button is Button:
		(remove_button as Button).text = LOCALIZATION.ui("forge.remove_relic", "Remove Relic")

	var owned_relics: Array = ProstheticManager.get_unlocked_relics()
	var relic_index: int = 0
	for child: Node in relic_popup_list.get_children():
		if not (child is Button):
			continue
		if relic_index >= owned_relics.size():
			break
		var relic_value: Variant = owned_relics[relic_index]
		relic_index += 1
		if not (relic_value is RelicData):
			continue
		var relic: RelicData = relic_value as RelicData
		var labels: Array[Node] = child.find_children("*", "Label", true, false)
		if not labels.is_empty() and labels[0] is Label:
			var rarity: String = LOCALIZATION.ui("rarity.%s" % relic.rarity.to_lower(), relic.rarity)
			(labels[0] as Label).text = "%s  [%s]" % [LOCALIZATION.catalog_name("relic", relic.id, relic.display_name), rarity]
		if labels.size() >= 2 and labels[1] is Label:
			(labels[1] as Label).text = LOCALIZATION.catalog_details("relic", relic.id, relic.description)
		if labels.size() >= 3 and labels[2] is Label:
			var requires_template: String = LOCALIZATION.ui("forge.requires", "Requires: %s")
			(labels[2] as Label).text = requires_template % _localized_tags(relic.compatible_tags)
	_refresh_release_presentation()


func _refresh_upgrades(data: ProstheticData) -> void:
	super._refresh_upgrades(data)
	if data.upgrade_nodes.is_empty():
		_refresh_release_presentation()
		return

	var rows: Array[Node] = upgrade_container.get_children()
	for index: int in range(mini(rows.size(), data.upgrade_nodes.size())):
		var row: Node = rows[index]
		if not (row is Button):
			continue
		var node_data: Dictionary = data.upgrade_nodes[index]
		var upgrade_id: String = str(node_data.get("id", ""))
		var fallback_name: String = str(node_data.get("name", upgrade_id))
		var fallback_desc: String = str(node_data.get("description", ""))
		var localized_name: String = LOCALIZATION.catalog_name("prosthetic_upgrade", "%s.%s" % [data.id, upgrade_id], fallback_name)
		var localized_desc: String = LOCALIZATION.catalog_details("prosthetic_upgrade", "%s.%s" % [data.id, upgrade_id], fallback_desc)
		var labels: Array[Node] = row.find_children("*", "Label", true, false)
		if not labels.is_empty() and labels[0] is Label:
			var is_bought: bool = ProstheticManager.is_upgrade_purchased(data.id, upgrade_id)
			var can_buy: bool = ProstheticManager.can_purchase_upgrade(data.id, upgrade_id)
			if is_bought:
				(labels[0] as Label).text = "%s  [%s]" % [localized_name, LOCALIZATION.ui("forge.owned", "OWNED")]
			elif can_buy:
				(labels[0] as Label).text = localized_name
			else:
				(labels[0] as Label).text = "%s  [%s]" % [localized_name, LOCALIZATION.ui("forge.locked", "LOCKED")]
		if labels.size() >= 2 and labels[1] is Label:
			var info_text: String = localized_desc
			if not ProstheticManager.is_upgrade_purchased(data.id, upgrade_id):
				var cost_parts: Array[String] = []
				var cost_mist: int = int(node_data.get("cost_mist_shards", 0))
				var cost_gold: int = int(node_data.get("cost_gold", 0))
				if cost_mist > 0:
					cost_parts.append("%d %s" % [cost_mist, LOCALIZATION.ui("currency.mist", "Mist")])
				if cost_gold > 0:
					cost_parts.append("%d %s" % [cost_gold, LOCALIZATION.ui("currency.gold", "Gold")])
				if not cost_parts.is_empty():
					info_text += "  |  " + ", ".join(cost_parts)
			(labels[1] as Label).text = info_text
	_refresh_release_presentation()


func _refresh_release_presentation() -> void:
	_translate_static_copy(self)
	_apply_readability()


func _translate_static_copy(root: Node) -> void:
	for node: Node in root.find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var label: Label = node as Label
		match label.text:
			"FORGE BENCH": label.text = LOCALIZATION.ui("forge.title", "FORGE BENCH")
			"Prosthetics": label.text = LOCALIZATION.ui("forge.prosthetics", "Prosthetics")
			"Select a prosthetic.": label.text = LOCALIZATION.ui("forge.select_prosthetic", "Select a prosthetic.")
			"Relic Slots": label.text = LOCALIZATION.ui("forge.relic_slots", "Relic Slots")
			"Upgrades": label.text = LOCALIZATION.ui("forge.upgrades", "Upgrades")
			"Choose Relic": label.text = LOCALIZATION.ui("forge.choose_relic", "Choose Relic")
			"No prosthetics unlocked.": label.text = LOCALIZATION.ui("forge.no_prosthetics", "No prosthetics unlocked.")
			"No relics owned.": label.text = LOCALIZATION.ui("forge.no_relics", "No relics owned.")
			"No upgrades available.": label.text = LOCALIZATION.ui("forge.no_upgrades", "No upgrades available.")


func _localized_tags(tags: Array[String]) -> String:
	if tags.is_empty():
		return LOCALIZATION.ui("tag.general", "General")
	var result: Array[String] = []
	for tag: String in tags:
		result.append(LOCALIZATION.ui("tag.%s" % tag, tag.capitalize()))
	return ", ".join(result)


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
