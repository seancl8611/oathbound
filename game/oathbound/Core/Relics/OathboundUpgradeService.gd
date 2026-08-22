extends "res://autoload/UpgradeService.gd"

## Relic-aware Technique offer layer.
## Scribe's Lens adds one card to the approved first N Technique rewards per region,
## where N is 1 at Base and first-playtest mastery tuning may increase its frequency.
## All eligibility/rarity/family rules remain owned by the canonical parent service.

const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")


func get_three_choices_for_source(source: String, area_id: int = 1, exclude_ids: Array = []) -> Array:
	var choices: Array = super.get_three_choices_for_source(source, area_id, exclude_ids)
	var runtime := _relic_runtime()
	if runtime == null or choices.size() < 3:
		return choices
	if not bool(runtime.call("consume_scribe_extra_choice", area_id)):
		return choices
	return _append_extra_choice(choices, source, area_id, exclude_ids)


func reroll_three_choices(source: String, area_id: int, previous_choices: Array) -> Array:
	if RunData == null or not RunData.has_method("spend_technique_reroll"):
		return []
	if not RunData.spend_technique_reroll():
		return []

	var excluded: Array = []
	for choice_value: Variant in previous_choices:
		if choice_value is Dictionary:
			var id: String = str((choice_value as Dictionary).get("id", ""))
			if not id.is_empty():
				excluded.append(id)

	# Do not consume another Scribe's Lens regional use on reroll. Preserve the screen
	# width the player already earned on the original reward.
	var rerolled: Array = super.get_three_choices_for_source(source, area_id, excluded)
	if previous_choices.size() >= 4:
		rerolled = _append_extra_choice(rerolled, source, area_id, excluded)
	var desired_count: int = 4 if previous_choices.size() >= 4 else 3
	if rerolled.size() < desired_count:
		rerolled = super.get_three_choices_for_source(source, area_id)
		if desired_count >= 4:
			rerolled = _append_extra_choice(rerolled, source, area_id, [])
	return rerolled


func _append_extra_choice(base_choices: Array, source: String, area_id: int, exclude_ids: Array) -> Array:
	var out: Array = base_choices.duplicate(true)
	if out.size() >= 4:
		return out

	var acquired: Array = _get_acquired()
	var excluded: Array = exclude_ids.duplicate()
	var existing_cross: bool = false
	for choice_value: Variant in out:
		if not (choice_value is Dictionary):
			continue
		var choice: Dictionary = choice_value as Dictionary
		var id: String = str(choice.get("id", ""))
		if not id.is_empty() and id not in excluded:
			excluded.append(id)
		if str(choice.get("kind", "")) == RELIC_CATALOG.get_name("__never__"):
			pass
		if str(choice.get("kind", "")) == "cross":
			existing_cross = true

	var eligible: Array = _eligible_techniques(acquired, excluded)
	var opening_hushiro: bool = area_id == 1 and acquired.is_empty()
	var candidates: Array = []
	for item_value: Variant in eligible:
		if not (item_value is Dictionary):
			continue
		var item: Dictionary = item_value as Dictionary
		var kind: String = str(item.get("kind", ""))
		if opening_hushiro and kind != "action":
			continue
		# Preserve Legendary screen insertion as a special parent-service event rather
		# than making the extra Relic card a free Legendary roll.
		if kind == "legendary" or kind == "refinement":
			continue
		if existing_cross and kind == "cross":
			continue
		candidates.append(item)

	if candidates.is_empty() and not opening_hushiro:
		var refinements: Array = _eligible_refinements(acquired, excluded)
		for refinement_value: Variant in refinements:
			if refinement_value is Dictionary:
				candidates.append(refinement_value)
	if candidates.is_empty():
		return out

	var rarity_weights: Dictionary = _source_rarity_weights(source, area_id)
	var owned_families: Array[String] = _owned_families(acquired)
	var pick: Dictionary = _pick_by_source_rarity(candidates, rarity_weights, owned_families)
	if not pick.is_empty():
		out.append(pick)
	return out


func _relic_runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")
