extends "res://Core/Release/OathboundRunResultsOverlay.gd"

const LOCALIZATION = preload("res://Core/Release/OathboundLocalization.gd")
const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")
const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")
const TECHNIQUE_CATALOG_RELEASE = preload("res://Core/Techniques/TechniqueCatalog.gd")


func present(result: Dictionary) -> void:
	super.present(result)
	if result.is_empty():
		return
	_translate_direct_copy(result)
	call_deferred("_apply_readability")


func _result_title(result: Dictionary) -> String:
	var kind := str(result.get("completion_kind", ""))
	match kind:
		"first_return": return LOCALIZATION.ui("run_results.title.first_return", "THE BLOOD RETURNS")
		"failed": return LOCALIZATION.ui("run_results.title.failed", "RUN ENDED")
		"story_complete": return LOCALIZATION.ui("run_results.title.story_complete", "STORY COMPLETE")
		"heart_suppression": return LOCALIZATION.ui("run_results.title.heart_suppression", "HEART SUPPRESSED")
		"standard_expedition": return LOCALIZATION.ui("run_results.title.standard_expedition", "EXPEDITION COMPLETE")
	if kind.begins_with("binding_"):
		return LOCALIZATION.ui("run_results.title.binding_destroyed", "HEART BINDING DESTROYED")
	if bool(result.get("successful", false)):
		return LOCALIZATION.ui("run_results.title.complete", "RUN COMPLETE")
	return LOCALIZATION.ui("run_results.title.returned", "RETURNED TO THE STRAND")


func _result_subtitle(result: Dictionary) -> String:
	var kind := str(result.get("completion_kind", ""))
	match kind:
		"first_return":
			return LOCALIZATION.ui("run_results.subtitle.first_return", "Akio died on the island. Returning Blood rebuilt him at The Strand. Permanent gains remain; the run build is gone.")
		"failed":
			return LOCALIZATION.ui("run_results.subtitle.failed", "The attempt ended, but permanent resources and discoveries were banked when earned.")
		"story_complete":
			return LOCALIZATION.ui("run_results.subtitle.story_complete", "The Heart's curse can no longer create or spread new Beast Blood. The completed save now enters canonical postgame.")
		"heart_suppression":
			return LOCALIZATION.ui("run_results.subtitle.heart_suppression", "Dangerous Heart regrowth was suppressed. The contained remnant survives without a path to new hosts.")
		"standard_expedition":
			return LOCALIZATION.ui("run_results.subtitle.standard_expedition", "The expedition ended at the Eclipse Shogun as selected before departure.")
	if kind.begins_with("binding_"):
		return LOCALIZATION.ui("run_results.subtitle.binding_destroyed", "The Shogun fell and another restraint on the Heart was destroyed.")
	return LOCALIZATION.ui("run_results.subtitle.returned", "The run has returned to The Strand.")


func _add_line(column: VBoxContainer, label_text: String, value_text: String) -> void:
	super._add_line(column, _localized_line_label(label_text), value_text)


func _add_section(column: VBoxContainer, text_value: String) -> void:
	super._add_section(column, _localized_section(text_value))


func _technique_names(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if not (value is Array):
		return result
	for id_value: Variant in value:
		var technique_id := str(id_value)
		var data: Dictionary = {}
		if TECHNIQUE_CATALOG_RELEASE.TECHNIQUES.has(technique_id):
			data = TECHNIQUE_CATALOG_RELEASE.TECHNIQUES[technique_id] as Dictionary
		elif TECHNIQUE_CATALOG_RELEASE.REFINEMENTS.has(technique_id):
			data = TECHNIQUE_CATALOG_RELEASE.REFINEMENTS[technique_id] as Dictionary
		var fallback := str(data.get("displayname", data.get("name", technique_id))).replace("_", " ")
		result.append(LOCALIZATION.catalog_name("technique", technique_id, fallback))
	return result


func _material_delta_text(value: Variant) -> String:
	if not (value is Dictionary):
		return ""
	var parts: Array[String] = []
	for key_value: Variant in (value as Dictionary).keys():
		var amount := int((value as Dictionary).get(key_value, 0))
		if amount <= 0:
			continue
		var material_id := str(key_value)
		var fallback := material_id.replace("_", " ").capitalize()
		parts.append("%s +%d" % [LOCALIZATION.catalog_name("material", material_id, fallback), amount])
	return ", ".join(parts)


func _aspect_label(value: String) -> String:
	if value.is_empty() or value == "base_katana":
		return LOCALIZATION.resolve("aspect.base_katana.name", "Base Katana")
	return LOCALIZATION.resolve("aspect.%s.name" % value, value.capitalize())


func _fallback_label(value: String) -> String:
	if value.is_empty():
		return LOCALIZATION.ui("common.none", "None")
	if typeof(ProstheticManager) == TYPE_OBJECT and ProstheticManager.has_method("get_prosthetic"):
		var prosthetic_value: Variant = ProstheticManager.get_prosthetic(value)
		if prosthetic_value != null and prosthetic_value.get("display_name") != null:
			return LOCALIZATION.catalog_name("prosthetic", value, str(prosthetic_value.get("display_name")))
	var relic_entry: Dictionary = RELIC_CATALOG.DATA.get(value, {})
	if not relic_entry.is_empty():
		return LOCALIZATION.catalog_name("relic", value, str(relic_entry.get("name", value.replace("_", " ").capitalize())))
	return value.replace("_", " ").capitalize()


func _localized_line_label(fallback: String) -> String:
	match fallback:
		"Time": return LOCALIZATION.ui("run_results.label.time", fallback)
		"Deepest progress": return LOCALIZATION.ui("run_results.label.deepest_progress", fallback)
		"Heart Bindings": return LOCALIZATION.ui("run_results.label.heart_bindings", fallback)
		"Mist": return LOCALIZATION.ui("currency.mist", fallback)
		"Scrolls": return LOCALIZATION.ui("currency.scrolls", fallback)
		"Boss materials": return LOCALIZATION.ui("run_results.label.boss_materials", fallback)
		"Aspect": return LOCALIZATION.ui("run_results.label.aspect", fallback)
		"Highest Tier": return LOCALIZATION.ui("run_results.label.highest_tier", fallback)
		"Prosthetic": return LOCALIZATION.ui("run_results.label.prosthetic", fallback)
		"Relic": return LOCALIZATION.ui("run_results.label.relic", fallback)
		"Techniques": return LOCALIZATION.ui("run_results.label.techniques", fallback)
		"Best Standard": return LOCALIZATION.ui("run_results.label.best_standard", fallback)
		"Best Suppression": return LOCALIZATION.ui("run_results.label.best_suppression", fallback)
		_: return fallback


func _localized_section(fallback: String) -> String:
	match fallback:
		"Permanent progress retained": return LOCALIZATION.ui("run_results.section.permanent_progress", fallback)
		"Final build": return LOCALIZATION.ui("run_results.section.final_build", fallback)
		"Ending": return LOCALIZATION.ui("run_results.section.ending", fallback)
		_: return fallback


func _translate_direct_copy(result: Dictionary) -> void:
	for node: Node in find_children("*", "Label", true, false):
		if not (node is Label):
			continue
		var label := node as Label
		if label.text.begins_with("Run-only state lost: "):
			var localized_losses: Array[String] = []
			for loss: String in _string_array(result.get("run_only_lost", [])):
				localized_losses.append(_localized_loss(loss))
			var template := LOCALIZATION.ui("run_results.run_only_lost", "Run-only state lost: %s")
			label.text = template % ", ".join(localized_losses)
		elif label.text.begins_with("Overall completion: "):
			var template := LOCALIZATION.ui("run_results.overall_completion", "Overall completion: %d%%")
			label.text = template % RecordsRuntime.get_completion_percent() if typeof(RecordsRuntime) == TYPE_OBJECT else label.text
		elif label.text == "Postgame unlocked: choose Standard Expedition or Heart Suppression at the Boat before departure.":
			label.text = LOCALIZATION.ui("run_results.postgame_unlocked", label.text)
	for node: Node in find_children("*", "Button", true, false):
		if node is Button and (node as Button).text == "Return to The Strand":
			(node as Button).text = LOCALIZATION.ui("run_results.return_strand", "Return to The Strand")


func _localized_loss(fallback: String) -> String:
	match fallback:
		"Gold": return LOCALIZATION.ui("currency.gold", fallback)
		"Techniques": return LOCALIZATION.ui("run_results.loss.techniques", fallback)
		_: return LOCALIZATION.ui("run_results.loss.%s" % fallback.to_lower().replace(" ", "_"), fallback)


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
