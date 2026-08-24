extends "res://GUI/BloodwellMenu.gd"

## Release presentation layer for Bloodwell. Permanent progression structure, unlock
## stages, costs, affordability, purchases, and effect values remain owned by the
## Strand progression runtime. This layer only localizes visible copy from stable node
## IDs and applies shared readability styling.

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")


func _ready() -> void:
	super._ready()
	call_deferred("_refresh_release_presentation")


func _refresh() -> void:
	super._refresh()
	call_deferred("_refresh_release_presentation")


func _refresh_release_presentation() -> void:
	_localize_static_copy()
	_localize_progression_nodes()
	READABILITY_STYLER.apply(self)


func _localize_static_copy() -> void:
	var replacements: Dictionary = {
		"BLOODWELL": LOCALIZATION.ui("bloodwell.title", "BLOODWELL"),
		"Close": LOCALIZATION.ui("common.close", "Close"),
		"Permanent Akio and Run Infrastructure progression. Mist and regional boss materials persist immediately.": LOCALIZATION.ui("bloodwell.intro", "Permanent Akio and Run Infrastructure progression. Mist and regional boss materials persist immediately."),
		"AKIO": LOCALIZATION.ui("bloodwell.tab.akio", "AKIO"),
		"RUN INFRASTRUCTURE": LOCALIZATION.ui("bloodwell.tab.run_infrastructure", "RUN INFRASTRUCTURE"),
		"Purchased": LOCALIZATION.ui("status.purchased", "Purchased"),
		"Owned permanently": LOCALIZATION.ui("progression.state.owned", "Owned permanently"),
		"Available": LOCALIZATION.ui("progression.state.available", "Available"),
		"Unlocks after first Keeper defeat": LOCALIZATION.ui("progression.state.after_keeper", "Unlocks after first Keeper defeat"),
		"Unlocks after first Twin Maws defeat": LOCALIZATION.ui("progression.state.after_twin_maws", "Unlocks after first Twin Maws defeat"),
		"Unlocks after first Shogun defeat / first Binding clear": LOCALIZATION.ui("progression.state.after_shogun", "Unlocks after first Shogun defeat / first Binding clear"),
		"Locked": LOCALIZATION.ui("progression.state.locked", "Locked"),
		"Permanent reliability upgrade": LOCALIZATION.ui("progression.effect.reliability_upgrade", "Permanent reliability upgrade"),
		"Permanent reliability improvement": LOCALIZATION.ui("progression.effect.reliability_improvement", "Permanent reliability improvement"),
		"Improved route information": LOCALIZATION.ui("progression.effect.route_information", "Improved route information"),
		"Improves authored transition support": LOCALIZATION.ui("progression.effect.transition_support", "Improves authored transition support"),
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

	_localize_resource_summary()
	_localize_cost_and_effect_tokens()


func _localize_progression_nodes() -> void:
	if typeof(MetaProgressionManager) != TYPE_OBJECT:
		return
	for data_value: Variant in MetaProgressionManager.get_nodes_for_station("bloodwell"):
		if not (data_value is Dictionary):
			continue
		var data: Dictionary = data_value
		var node_id: String = str(data.get("id", ""))
		var fallback_name: String = str(data.get("name", node_id))
		if node_id.is_empty() or fallback_name.is_empty():
			continue
		_replace_token(fallback_name, LOCALIZATION.catalog_name("progression", node_id, fallback_name))


func _localize_resource_summary() -> void:
	if _resource_label == null:
		return
	var mist_name := LOCALIZATION.ui("currency.mist", "Mist")
	var keeper_name := LOCALIZATION.ui("material.keeper.short", "Keeper")
	var twin_name := LOCALIZATION.ui("material.twin_maws.short", "Twin")
	var shogun_name := LOCALIZATION.ui("material.shogun.short", "Shogun")
	_resource_label.text = "%s %d   %s %d   %s %d   %s %d" % [
		mist_name, int(MetaProgress.mist), keeper_name, MetaProgress.get_boss_material("keeper"),
		twin_name, MetaProgress.get_boss_material("twin_maws"), shogun_name, MetaProgress.get_boss_material("eclipse_shogun")]


func _localize_cost_and_effect_tokens() -> void:
	var mist_name := LOCALIZATION.ui("currency.mist", "Mist")
	var health_name := LOCALIZATION.ui("stat.health", "Health")
	var posture_name := LOCALIZATION.ui("stat.posture", "Posture")
	var spirit_name := LOCALIZATION.ui("stat.spirit", "Spirit")
	var replacements: Dictionary = {
		" Mist": " %s" % mist_name,
		"max Health": LOCALIZATION.ui("progression.effect.max_health", "max %s" % health_name),
		"max Posture": LOCALIZATION.ui("progression.effect.max_posture", "max %s" % posture_name),
		"max Spirit": LOCALIZATION.ui("progression.effect.max_spirit", "max %s" % spirit_name),
		"Rest recovery": LOCALIZATION.ui("progression.effect.rest_recovery", "Rest recovery"),
		"approved Health recovery": LOCALIZATION.ui("progression.effect.health_recovery", "approved %s recovery" % health_name),
		"posture recovery": LOCALIZATION.ui("progression.effect.posture_recovery", "posture recovery"),
		"Parries clear": LOCALIZATION.ui("progression.effect.parries_clear", "Parries clear"),
		"Deathblows clear": LOCALIZATION.ui("progression.effect.deathblows_clear", "Deathblows clear"),
		"posture": LOCALIZATION.ui("stat.posture", "posture"),
		"Technique reroll per run": LOCALIZATION.ui("progression.effect.technique_reroll", "Technique reroll per run"),
		"Resist returns Corruption to": LOCALIZATION.ui("progression.effect.resist_corruption", "Resist returns Corruption to"),
		"approved persistent rewards": LOCALIZATION.ui("progression.effect.persistent_rewards", "approved persistent rewards"),
	}
	for fallback_value: Variant in replacements.keys():
		var fallback: String = str(fallback_value)
		var translated: String = str(replacements[fallback_value])
		if translated != fallback:
			_replace_token(fallback, translated)


func _material_name(key: String) -> String:
	match key:
		"keeper": return LOCALIZATION.ui("material.keeper.full", "Keeper material")
		"twin_maws": return LOCALIZATION.ui("material.twin_maws.full", "Twin Maws material")
		"eclipse_shogun": return LOCALIZATION.ui("material.shogun.full", "Shogun material")
	return LOCALIZATION.ui("material.boss.generic", "boss material")


func _replace_token(fallback: String, translated: String) -> void:
	if fallback.is_empty() or translated == fallback:
		return
	for node: Node in find_children("*", "Control", true, false):
		if node is Label and (node as Label).text.contains(fallback):
			(node as Label).text = (node as Label).text.replace(fallback, translated)
		elif node is Button and (node as Button).text.contains(fallback):
			(node as Button).text = (node as Button).text.replace(fallback, translated)
