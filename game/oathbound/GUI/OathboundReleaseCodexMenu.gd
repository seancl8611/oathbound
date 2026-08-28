extends "res://GUI/CodexMenu.gd"

## Release presentation layer for the existing Codex authority. Discovery state,
## encounter counts, unlocks, Prosthetic ownership, Relic ownership, and selection
## behavior remain owned by CodexMenu/CodexManager/ProstheticManager. This layer only
## resolves player-facing text from stable IDs and applies shared readability styling.

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")


func _ready():
	super._ready()
	call_deferred("_refresh_release_presentation")


func _refresh_tab():
	super._refresh_tab()
	call_deferred("_refresh_release_presentation")


func _refresh_release_presentation() -> void:
	_localize_static_copy()
	_localize_enemy_content()
	_localize_prosthetic_content()
	_localize_relic_content()
	READABILITY_STYLER.apply(self)


func _localize_static_copy() -> void:
	var replacements: Dictionary = {
		"CODEX": LOCALIZATION.ui("codex.title", "CODEX"),
		"Bestiary": LOCALIZATION.ui("codex.tab.bestiary", "Bestiary"),
		"Prosthetics": LOCALIZATION.ui("codex.tab.prosthetics", "Prosthetics"),
		"Relics": LOCALIZATION.ui("codex.tab.relics", "Relics"),
		"Enemies": LOCALIZATION.ui("codex.category.enemies", "Enemies"),
		"Mini-Bosses": LOCALIZATION.ui("codex.category.minibosses", "Mini-Bosses"),
		"Bosses": LOCALIZATION.ui("codex.category.bosses", "Bosses"),
		"BOSS": LOCALIZATION.ui("codex.tag.boss", "BOSS"),
		"MINI-BOSS": LOCALIZATION.ui("codex.tag.miniboss", "MINI-BOSS"),
		"ENEMY": LOCALIZATION.ui("codex.tag.enemy", "ENEMY"),
		"Weakness Hints": LOCALIZATION.ui("codex.weakness_hints", "Weakness Hints"),
		"Fight this enemy more to reveal weaknesses...": LOCALIZATION.ui("codex.hints.locked", "Fight this enemy more to reveal weaknesses..."),
		"Discovered": LOCALIZATION.ui("codex.discovered", "Discovered"),
		"Undiscovered": LOCALIZATION.ui("codex.undiscovered", "Undiscovered"),
		"  None yet": LOCALIZATION.ui("codex.none_yet", "  None yet"),
		"  All discovered!": LOCALIZATION.ui("codex.all_discovered", "  All discovered!"),
		"EQUIPPED": LOCALIZATION.ui("status.equipped", "EQUIPPED"),
		"Upgrade Path": LOCALIZATION.ui("codex.upgrade_path", "Upgrade Path"),
		"Effects": LOCALIZATION.ui("codex.effects", "Effects"),
		"No enemies discovered yet. Enter combat to unlock entries.": LOCALIZATION.ui("codex.empty.enemies", "No enemies discovered yet. Enter combat to unlock entries."),
		"No prosthetics discovered yet.": LOCALIZATION.ui("codex.empty.prosthetics", "No prosthetics discovered yet."),
		"No relics discovered yet.": LOCALIZATION.ui("codex.empty.relics", "No relics discovered yet."),
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


func _localize_enemy_content() -> void:
	if typeof(CodexManager) != TYPE_OBJECT:
		return
	for enemy_id_value: Variant in CodexManager.get_all_enemy_ids():
		var enemy_id: String = str(enemy_id_value)
		var data: Dictionary = CodexManager.get_enemy_data(enemy_id)
		if data.is_empty():
			continue
		var fallback_name: String = str(data.get("display_name", enemy_id))
		var fallback_details: String = str(data.get("description", ""))
		_replace_exact_text(fallback_name, LOCALIZATION.catalog_name("enemy", enemy_id, fallback_name))
		if not fallback_details.is_empty():
			_replace_exact_text(fallback_details, LOCALIZATION.catalog_details("enemy", enemy_id, fallback_details))

		var revealed_value: Variant = CodexManager.get_revealed_hints(enemy_id)
		if revealed_value is Array:
			var revealed: Array = revealed_value
			for hint_index: int in range(revealed.size()):
				var fallback_hint: String = str(revealed[hint_index])
				var translated_hint := LOCALIZATION.resolve("catalog.enemy.%s.hint_%d" % [enemy_id, hint_index + 1], fallback_hint)
				_replace_numbered_hint(fallback_hint, translated_hint)

	if not selected_enemy_id.is_empty():
		_localize_selected_enemy_counts(selected_enemy_id)


func _localize_selected_enemy_counts(enemy_id: String) -> void:
	var count: int = CodexManager.get_enemy_encounter_count(enemy_id)
	var fallback_count := "Encountered 1 time" if count == 1 else "Encountered %d times" % count
	var count_template := LOCALIZATION.ui("codex.encounter_count.one", "Encountered %d time") if count == 1 else LOCALIZATION.ui("codex.encounter_count.many", "Encountered %d times")
	_replace_exact_text(fallback_count, count_template % count)

	var revealed_value: Variant = CodexManager.get_revealed_hints(enemy_id)
	var revealed_count: int = revealed_value.size() if revealed_value is Array else 0
	var locked_count: int = maxi(0, CodexManager.get_total_hint_count(enemy_id) - revealed_count)
	if locked_count <= 0:
		return
	var fallback_remaining := "1 hint remaining..." if locked_count == 1 else "%d hints remaining..." % locked_count
	var remaining_template := LOCALIZATION.ui("codex.hints.remaining.one", "%d hint remaining...") if locked_count == 1 else LOCALIZATION.ui("codex.hints.remaining.many", "%d hints remaining...")
	_replace_exact_text(fallback_remaining, remaining_template % locked_count)


func _localize_prosthetic_content() -> void:
	if typeof(ProstheticManager) != TYPE_OBJECT:
		return
	for prosthetic_id_value: Variant in ProstheticManager.get_all_prosthetic_ids():
		var prosthetic_id: String = str(prosthetic_id_value)
		var data: Variant = ProstheticManager.get_prosthetic(prosthetic_id)
		if data == null:
			continue
		var fallback_name: String = str(data.display_name) if str(data.display_name) != "" else prosthetic_id.replace("_", " ").capitalize()
		var fallback_details: String = str(data.description)
		_replace_exact_text(fallback_name, LOCALIZATION.catalog_name("prosthetic", prosthetic_id, fallback_name))
		if not fallback_details.is_empty():
			_replace_exact_text(fallback_details, LOCALIZATION.catalog_details("prosthetic", prosthetic_id, fallback_details))

		for tag_value: Variant in data.tags:
			var fallback_tag: String = str(tag_value)
			_replace_token(fallback_tag, LOCALIZATION.resolve("tag.%s.name" % fallback_tag.to_lower().replace(" ", "_"), fallback_tag))

		var fallback_stats := "Spirit Cost: %d  |  Relic Slots: %d" % [int(data.spirit_cost), int(data.max_relic_slots)]
		var translated_stats := "%s: %d  |  %s: %d" % [
			LOCALIZATION.ui("codex.spirit_cost", "Spirit Cost"), int(data.spirit_cost),
			LOCALIZATION.ui("codex.relic_slots", "Relic Slots"), int(data.max_relic_slots),
		]
		_replace_exact_text(fallback_stats, translated_stats)

		for upgrade_value: Variant in data.upgrade_nodes:
			if not (upgrade_value is Dictionary):
				continue
			var upgrade: Dictionary = upgrade_value
			var upgrade_id: String = str(upgrade.get("id", ""))
			var fallback_upgrade_name: String = str(upgrade.get("name", upgrade_id))
			var fallback_upgrade_details: String = str(upgrade.get("description", ""))
			var translated_upgrade_name := LOCALIZATION.resolve("catalog.prosthetic.%s.upgrade.%s.name" % [prosthetic_id, upgrade_id], fallback_upgrade_name)
			var translated_upgrade_details := LOCALIZATION.resolve("catalog.prosthetic.%s.upgrade.%s.details" % [prosthetic_id, upgrade_id], fallback_upgrade_details)
			_replace_text_prefix(fallback_upgrade_name, translated_upgrade_name)
			if not fallback_upgrade_details.is_empty():
				_replace_exact_text(fallback_upgrade_details, translated_upgrade_details)

	_replace_token("[OWNED]", LOCALIZATION.ui("status.owned_bracket", "[OWNED]"))


func _localize_relic_content() -> void:
	if typeof(ProstheticManager) != TYPE_OBJECT:
		return
	var registry_value: Variant = ProstheticManager.get("_relic_registry")
	if not (registry_value is Dictionary):
		return
	var registry: Dictionary = registry_value
	for relic_id_value: Variant in registry.keys():
		var relic_id: String = str(relic_id_value)
		var data: Variant = ProstheticManager.get_relic(relic_id)
		if data == null:
			continue
		var fallback_name: String = str(data.display_name) if str(data.display_name) != "" else relic_id.replace("_", " ").capitalize()
		var fallback_details: String = str(data.description)
		_replace_exact_text(fallback_name, LOCALIZATION.catalog_name("relic", relic_id, fallback_name))
		if not fallback_details.is_empty():
			_replace_exact_text(fallback_details, LOCALIZATION.catalog_details("relic", relic_id, fallback_details))
		var fallback_rarity: String = str(data.rarity) if str(data.rarity) != "" else "Common"
		_replace_exact_text(fallback_rarity, LOCALIZATION.resolve("rarity.%s.name" % fallback_rarity.to_lower(), fallback_rarity))
		for tag_value: Variant in data.compatible_tags:
			var fallback_tag: String = str(tag_value)
			_replace_token(fallback_tag, LOCALIZATION.resolve("tag.%s.name" % fallback_tag.to_lower().replace(" ", "_"), fallback_tag))

	_replace_text_prefix("Compatible: All prosthetics", LOCALIZATION.ui("codex.compatible_all", "Compatible: All prosthetics"))
	_replace_text_prefix("Compatible: ", LOCALIZATION.ui("codex.compatible_prefix", "Compatible: "))
	_localize_modifier_labels()


func _localize_modifier_labels() -> void:
	for node: Node in find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var label := node as Label
		var stripped := label.text.strip_edges()
		var separator := stripped.find(":")
		if separator <= 0:
			continue
		var fallback_key := stripped.substr(0, separator)
		var stable_key := fallback_key.to_lower().replace(" ", "_")
		var translated_key := LOCALIZATION.resolve("stat.%s.name" % stable_key, fallback_key)
		if translated_key != fallback_key:
			var indent := label.text.substr(0, label.text.length() - label.text.lstrip(" ").length())
			label.text = "%s%s%s" % [indent, translated_key, stripped.substr(separator)]


func _replace_numbered_hint(fallback: String, translated: String) -> void:
	for node: Node in find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var label := node as Label
		if label.text.ends_with(fallback):
			var prefix_length := label.text.length() - fallback.length()
			var prefix := label.text.substr(0, prefix_length)
			if prefix.strip_edges().trim_suffix(".").is_valid_int():
				label.text = prefix + translated


func _replace_exact_text(fallback: String, translated: String) -> void:
	if fallback.is_empty() or translated == fallback:
		return
	for node: Node in find_children("*", "Control", true, false):
		if node is Label and (node as Label).text == fallback:
			(node as Label).text = translated
		elif node is Button and (node as Button).text == fallback:
			(node as Button).text = translated


func _replace_text_prefix(fallback_prefix: String, translated_prefix: String) -> void:
	for node: Node in find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var label := node as Label
		if label.text.begins_with(fallback_prefix):
			label.text = translated_prefix + label.text.trim_prefix(fallback_prefix)


func _replace_token(fallback: String, translated: String) -> void:
	if fallback.is_empty() or translated == fallback:
		return
	for node: Node in find_children("*", "Control", true, false):
		if node is Label and (node as Label).text.contains(fallback):
			(node as Label).text = (node as Label).text.replace(fallback, translated)
		elif node is Button and (node as Button).text.contains(fallback):
			(node as Button).text = (node as Button).text.replace(fallback, translated)
