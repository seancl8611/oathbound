extends "res://Core/Release/OathboundPauseOverview.gd"

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const PAUSE_RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")


func _ready() -> void:
	super._ready()
	call_deferred("_refresh_release_presentation")


func _prosthetic_name() -> String:
	if typeof(ProstheticManager) != TYPE_OBJECT:
		return LOCALIZATION.ui("common.none", "None")
	var id := str(ProstheticManager.get("equipped_prosthetic_id"))
	if id.is_empty():
		return LOCALIZATION.ui("common.none", "None")
	if ProstheticManager.has_method("get_prosthetic"):
		var data: Variant = ProstheticManager.get_prosthetic(id)
		if data != null and data.get("display_name") != null:
			return LOCALIZATION.catalog_name("prosthetic", id, str(data.get("display_name")))
	return LOCALIZATION.catalog_name("prosthetic", id, id.replace("_", " ").capitalize())


func _relic_summary() -> String:
	if typeof(RelicRuntime) != TYPE_OBJECT:
		return LOCALIZATION.ui("common.none", "None")
	var id := str(RelicRuntime.get("equipped_relic_id"))
	if id.is_empty():
		return LOCALIZATION.ui("common.none", "None")
	var entry: Dictionary = PAUSE_RELIC_CATALOG.DATA.get(id, {})
	var fallback_name := str(entry.get("name", id.replace("_", " ").capitalize()))
	var name := LOCALIZATION.catalog_name("relic", id, fallback_name)
	var rank := int(RelicRuntime.get_mastery_rank(id)) if RelicRuntime.has_method("get_mastery_rank") else 0
	var rank_label := LOCALIZATION.ui("relic.rank.base", "Base") if rank <= 0 else LOCALIZATION.ui("relic.rank.mastery_%d" % rank, "Mastery %s" % ("I" if rank == 1 else "II"))
	var fallback_effect := str(entry.get("approved", ""))
	var effect := LOCALIZATION.catalog_details("relic", id, fallback_effect)
	return "%s — %s\n  %s" % [name, rank_label, effect]


func _temporary_capacity_suffix(current_max: int, run_start_max: int) -> String:
	var bonus := maxi(0, current_max - run_start_max)
	if bonus <= 0:
		return ""
	var template := LOCALIZATION.ui("pause.temporary_capacity", "  (+%d temporary)")
	return template % bonus


func _refresh_release_presentation() -> void:
	_translate_static_copy(self)
	for node: Node in find_children("*", "RichTextLabel", true, false):
		if node is RichTextLabel:
			(node as RichTextLabel).text = _localized_rich_text((node as RichTextLabel).text)
	_apply_readability()


func _translate_static_copy(root: Node) -> void:
	for node: Node in root.find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var label := node as Label
		match label.text:
			"PAUSE / BUILD OVERVIEW": label.text = LOCALIZATION.ui("pause.title", "PAUSE / BUILD OVERVIEW")
			"Read-only. Techniques remain additive run knowledge; this screen cannot respec the build. Safe run resume is saved at chamber boundaries.":
				label.text = LOCALIZATION.ui("pause.footer", label.text)
	for node: Node in root.find_children("*", "Button", true, false):
		if node is Button and (node as Button).text == "Resume":
			(node as Button).text = LOCALIZATION.ui("pause.resume", "Resume")


func _localized_rich_text(text: String) -> String:
	var replacements: Array[Array] = [
		["Current Run", LOCALIZATION.ui("pause.current_run", "Current Run")],
		["Run Resources", LOCALIZATION.ui("pause.run_resources", "Run Resources")],
		["Technique Rerolls", LOCALIZATION.ui("pause.technique_rerolls", "Technique Rerolls")],
		["Banked Mist", LOCALIZATION.ui("pause.banked_mist", "Banked Mist")],
		["Banked Scrolls", LOCALIZATION.ui("pause.banked_scrolls", "Banked Scrolls")],
		["Equipment", LOCALIZATION.ui("pause.equipment", "Equipment")],
		["Owned Techniques", LOCALIZATION.ui("pause.owned_techniques", "Owned Techniques")],
		["Grouped by trigger, not exclusive slots.", LOCALIZATION.ui("pause.technique_grouping_help", "Grouped by trigger, not exclusive slots.")],
		["Supporting / Cross-family / Legendary", LOCALIZATION.ui("pause.technique_group.supporting", "Supporting / Cross-family / Legendary")],
		["Parry / Counter", LOCALIZATION.ui("pause.technique_group.parry_counter", "Parry / Counter")],
		["Basic Attack", LOCALIZATION.ui("pause.technique_group.basic", "Basic Attack")],
		["Held Attack", LOCALIZATION.ui("pause.technique_group.held", "Held Attack")],
		["Deathblow", LOCALIZATION.ui("pause.technique_group.deathblow", "Deathblow")],
		["Refinements", LOCALIZATION.ui("pause.technique_group.refinements", "Refinements")],
		["No Techniques acquired yet.", LOCALIZATION.ui("pause.no_techniques", "No Techniques acquired yet.")],
		["Corruption: Unavailable before Returning Blood", LOCALIZATION.ui("pause.corruption_unavailable", "Corruption: Unavailable before Returning Blood")],
		["Aspect:", LOCALIZATION.ui("pause.aspect", "Aspect") + ":"],
		["Corruption:", LOCALIZATION.ui("pause.corruption", "Corruption") + ":"],
		["Health:", LOCALIZATION.ui("pause.health", "Health") + ":"],
		["Spirit:", LOCALIZATION.ui("pause.spirit", "Spirit") + ":"],
		["Gold:", LOCALIZATION.ui("currency.gold", "Gold") + ":"],
		["Prosthetic:", LOCALIZATION.ui("pause.prosthetic", "Prosthetic") + ":"],
		["Relic:", LOCALIZATION.ui("pause.relic", "Relic") + ":"],
		["Controls", LOCALIZATION.ui("pause.controls", "Controls")],
		["Block Input:", LOCALIZATION.ui("pause.block_input", "Block Input") + ":"],
	]
	var localized := text
	for pair: Array in replacements:
		localized = localized.replace(str(pair[0]), str(pair[1]))
	return localized


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
