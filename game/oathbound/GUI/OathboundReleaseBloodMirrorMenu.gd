extends "res://GUI/BloodMirrorMenu.gd"

## Release presentation layer for the Blood Mirror. Aspect progression structure,
## campaign gates, costs, purchases, and numerical effects remain owned by the Strand
## progression runtime. This layer only localizes visible copy from stable Aspect/node
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
	_localize_aspect_tabs()
	_localize_progression_nodes()
	_localize_dynamic_copy()
	READABILITY_STYLER.apply(self)


func _localize_static_copy() -> void:
	var replacements: Dictionary = {
		"BLOOD MIRROR": LOCALIZATION.ui("blood_mirror.title", "BLOOD MIRROR"),
		"Close": LOCALIZATION.ui("common.close", "Close"),
		"Permanent Blood Aspect reliability. The Mirror awakens after the first Keeper defeat; deeper nodes unlock after Twin Maws and the Shogun.": LOCALIZATION.ui("blood_mirror.status.active", "Permanent Blood Aspect reliability. The Mirror awakens after the first Keeper defeat; deeper nodes unlock after Twin Maws and the Shogun."),
		"Dormant. Defeat the Keeper once to awaken the Blood Mirror.": LOCALIZATION.ui("blood_mirror.status.dormant", "Dormant. Defeat the Keeper once to awaken the Blood Mirror."),
		"Purchased": LOCALIZATION.ui("status.purchased", "Purchased"),
		"Owned permanently": LOCALIZATION.ui("progression.state.owned", "Owned permanently"),
		"Blood Mirror unlocks after first Keeper defeat": LOCALIZATION.ui("blood_mirror.state.after_keeper", "Blood Mirror unlocks after first Keeper defeat"),
		"Available": LOCALIZATION.ui("progression.state.available", "Available"),
		"Unlocks after first Twin Maws defeat": LOCALIZATION.ui("progression.state.after_twin_maws", "Unlocks after first Twin Maws defeat"),
		"Unlocks after first Shogun defeat / first Binding clear": LOCALIZATION.ui("progression.state.after_shogun", "Unlocks after first Shogun defeat / first Binding clear"),
		"Locked": LOCALIZATION.ui("progression.state.locked", "Locked"),
		"Aspect reliability improvement": LOCALIZATION.ui("blood_mirror.effect.reliability", "Aspect reliability improvement"),
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


func _localize_aspect_tabs() -> void:
	for aspect_id_value: Variant in _aspect_buttons.keys():
		var aspect_id: String = str(aspect_id_value)
		var button_value: Variant = _aspect_buttons[aspect_id_value]
		if button_value is Button:
			(button_value as Button).text = LOCALIZATION.resolve("aspect.%s.name" % aspect_id, aspect_id.capitalize())


func _localize_progression_nodes() -> void:
	if typeof(MetaProgressionManager) != TYPE_OBJECT:
		return
	for data_value: Variant in MetaProgressionManager.get_nodes_for_station("blood_mirror"):
		if not (data_value is Dictionary):
			continue
		var data: Dictionary = data_value
		var node_id: String = str(data.get("id", ""))
		var fallback_name: String = str(data.get("name", node_id))
		if node_id.is_empty() or fallback_name.is_empty():
			continue
		_replace_token(fallback_name, LOCALIZATION.catalog_name("progression", node_id, fallback_name))


func _localize_dynamic_copy() -> void:
	if _resource_label != null:
		_resource_label.text = "%s %d" % [LOCALIZATION.ui("currency.mist", "Mist"), int(MetaProgress.mist)]

	var replacements: Dictionary = {
		"Wolf Tier 0 attack recovery": LOCALIZATION.ui("blood_mirror.effect.wolf_tier0_recovery", "Wolf Tier 0 attack recovery"),
		"Wolf signature recovery": LOCALIZATION.ui("blood_mirror.effect.wolf_signature_recovery", "Wolf signature recovery"),
		"Blood Hunt heal": LOCALIZATION.ui("blood_mirror.effect.blood_hunt_heal", "Blood Hunt heal"),
		"Wraith Tier 0 attack recovery": LOCALIZATION.ui("blood_mirror.effect.wraith_tier0_recovery", "Wraith Tier 0 attack recovery"),
		"Spectral minimum range": LOCALIZATION.ui("blood_mirror.effect.spectral_min_range", "Spectral minimum range"),
		"Wraith Blood recovery": LOCALIZATION.ui("blood_mirror.effect.wraith_blood_recovery", "Wraith Blood recovery"),
		"Ronin Tier 0 attack recovery": LOCALIZATION.ui("blood_mirror.effect.ronin_tier0_recovery", "Ronin Tier 0 attack recovery"),
		"Ronin block posture cost": LOCALIZATION.ui("blood_mirror.effect.ronin_block_posture", "Ronin block posture cost"),
		"Falling Mountain posture damage": LOCALIZATION.ui("blood_mirror.effect.falling_mountain_posture", "Falling Mountain posture damage"),
		" Mist": " %s" % LOCALIZATION.ui("currency.mist", "Mist"),
	}
	for fallback_value: Variant in replacements.keys():
		var fallback: String = str(fallback_value)
		var translated: String = str(replacements[fallback_value])
		if translated != fallback:
			_replace_token(fallback, translated)


func _replace_token(fallback: String, translated: String) -> void:
	if fallback.is_empty() or translated == fallback:
		return
	for node: Node in find_children("*", "Control", true, false):
		if node is Label and (node as Label).text.contains(fallback):
			(node as Label).text = (node as Label).text.replace(fallback, translated)
		elif node is Button and (node as Button).text.contains(fallback):
			(node as Button).text = (node as Button).text.replace(fallback, translated)
