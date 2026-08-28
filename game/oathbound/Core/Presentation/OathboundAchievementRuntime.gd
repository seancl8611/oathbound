extends Node

## In-game launch achievement runtime. Platform trophy APIs intentionally remain outside
## this portable Godot layer; stable achievement IDs can be mapped to a platform later.

signal achievement_unlocked(achievement_id: String)

const Catalog = preload("res://Core/Presentation/OathboundPresentationCatalog.gd")
const UNLOCK_PREFIX := "achievement_unlocked/"
const METRIC_PREFIX := "achievement_metric/"
const HEART_ASPECT_PREFIX := "heart_clear_aspect/"
const MINIBOSS_COUNTS_FLAG := "records/miniboss_defeat_counts"

# Last Oath remains reserved behind the not-yet-authored second Blood Cavern challenge.
# Launch achievements therefore follow the same currently obtainable Relic pool used by
# RecordsRuntime completion: nine Relics and two mastery ranks for each.
const REQUIRED_OBTAINABLE_RELIC_COUNT := 9
const REQUIRED_OBTAINABLE_RELIC_MASTERY_RANKS := 18


func _ready() -> void:
	if MetaProgress != null:
		for signal_name in ["campaign_changed", "progression_changed", "persistent_resources_changed"]:
			if MetaProgress.has_signal(signal_name):
				var cb := Callable(self, "evaluate")
				if not MetaProgress.is_connected(signal_name, cb):
					MetaProgress.connect(signal_name, cb)
	call_deferred("evaluate")
	print("[OathboundAchievementRuntime] v1.0 - 30 launch achievement contracts")


func get_catalog() -> Array[Dictionary]:
	return Catalog.achievements()


func is_unlocked(achievement_id: String) -> bool:
	return bool(MetaProgress.get_progression_flag(UNLOCK_PREFIX + achievement_id, false))


func get_unlocked_count() -> int:
	var count := 0
	for achievement in Catalog.achievements():
		if is_unlocked(str(achievement.get("id", ""))):
			count += 1
	return count


func set_metric(metric_id: String, value: int) -> void:
	if metric_id.is_empty():
		return
	if _temporary_persistence_sandbox_active():
		return
	var current := get_metric(metric_id)
	if value == current:
		return
	MetaProgress.set_progression_flag(METRIC_PREFIX + metric_id, maxi(0, value))
	evaluate()


func increment_metric(metric_id: String, amount: int = 1) -> void:
	if amount <= 0:
		return
	set_metric(metric_id, get_metric(metric_id) + amount)


func get_metric(metric_id: String) -> int:
	return maxi(0, int(MetaProgress.get_progression_flag(METRIC_PREFIX + metric_id, 0)))


func record_heart_clear(aspect_id: String) -> void:
	if _temporary_persistence_sandbox_active():
		return
	var normalized := aspect_id.to_lower()
	if normalized not in ["wolf", "wraith", "ronin"]:
		return
	MetaProgress.set_progression_flag(HEART_ASPECT_PREFIX + normalized, true)
	evaluate()


func record_miniboss_defeat(miniboss_id: String) -> void:
	if _temporary_persistence_sandbox_active():
		return
	if miniboss_id.is_empty():
		return
	var normalized := miniboss_id.to_lower()
	var counts_value: Variant = MetaProgress.get_progression_flag(MINIBOSS_COUNTS_FLAG, {})
	var counts: Dictionary = (counts_value as Dictionary).duplicate(true) if counts_value is Dictionary else {}
	counts[normalized] = maxi(0, int(counts.get(normalized, 0))) + 1
	MetaProgress.set_progression_flag(MINIBOSS_COUNTS_FLAG, counts)
	increment_metric("miniboss_defeats", 1)

	var seen_flag := "miniboss_metric_seen/" + normalized
	var first_defeat := not bool(MetaProgress.get_progression_flag(seen_flag, false))
	MetaProgress.set_progression_flag("miniboss_defeated/" + normalized, true)
	if first_defeat:
		increment_metric("unique_minibosses", 1)
		MetaProgress.set_progression_flag(seen_flag, true)


func get_miniboss_defeat_counts() -> Dictionary:
	var value: Variant = MetaProgress.get_progression_flag(MINIBOSS_COUNTS_FLAG, {})
	return (value as Dictionary).duplicate(true) if value is Dictionary else {}


func evaluate() -> void:
	if MetaProgress == null or _temporary_persistence_sandbox_active():
		return
	var bindings := MetaProgress.get_heart_bindings_destroyed()
	_unlock_if("first_return", MetaProgress.is_returning_blood_awakened())
	_unlock_if("keeper_fallen", MetaProgress.has_cleared_boss(1))
	_unlock_if("twin_maws_fallen", MetaProgress.has_cleared_boss(2))
	_unlock_if("shogun_fallen", MetaProgress.has_cleared_boss(3))
	_unlock_if("binding_one", bindings >= 1)
	_unlock_if("binding_three", bindings >= 3)
	_unlock_if("binding_six", bindings >= 6)
	_unlock_if("story_complete", MetaProgress.is_story_complete())
	_unlock_if("first_standard", MetaProgress.standard_expedition_clears >= 1)
	_unlock_if("first_suppression", MetaProgress.heart_suppression_clears >= 1)

	var wolf := bool(MetaProgress.get_progression_flag(HEART_ASPECT_PREFIX + "wolf", false))
	var wraith := bool(MetaProgress.get_progression_flag(HEART_ASPECT_PREFIX + "wraith", false))
	var ronin := bool(MetaProgress.get_progression_flag(HEART_ASPECT_PREFIX + "ronin", false))
	_unlock_if("wolf_heart", wolf)
	_unlock_if("wraith_heart", wraith)
	_unlock_if("ronin_heart", ronin)
	_unlock_if("three_aspects_heart", wolf and wraith and ronin)

	_unlock_if("bloodwell_first", get_metric("bloodwell_nodes") >= 1)
	_unlock_if("bloodwell_all", get_metric("bloodwell_nodes") >= 18)
	_unlock_if("mirror_first", get_metric("mirror_nodes") >= 1)
	_unlock_if("mirror_all", get_metric("mirror_nodes") >= 9)
	_unlock_if("prosthetics_all", get_metric("prosthetics") >= 8)
	_unlock_if("prosthetic_upgrades_all", get_metric("prosthetic_upgrades") >= 19)
	_unlock_if("relics_all", get_metric("relics") >= REQUIRED_OBTAINABLE_RELIC_COUNT)
	_unlock_if("relic_mastery_first", get_metric("relic_masteries") >= 1)
	_unlock_if("relic_mastery_all", get_metric("relic_masteries") >= REQUIRED_OBTAINABLE_RELIC_MASTERY_RANKS)
	_unlock_if("techniques_ten", get_metric("technique_records") >= 10)
	_unlock_if("techniques_all", get_metric("technique_records") >= 60)
	_unlock_if("trial_first", get_metric("trials") >= 1)
	_unlock_if("trials_all", bool(MetaProgress.get_progression_flag("all_required_trials_complete", false)))
	_unlock_if("records_all", bool(MetaProgress.get_progression_flag("required_records_complete", false)))
	_unlock_if("miniboss_hunter", get_metric("unique_minibosses") >= 6)
	_unlock_if("completion_100", get_metric("completion_percent") >= 100)


func _temporary_persistence_sandbox_active() -> bool:
	return (
		typeof(MetaProgress) == TYPE_OBJECT
		and MetaProgress.has_method("is_temporary_persistence_sandbox_active")
		and bool(MetaProgress.call("is_temporary_persistence_sandbox_active"))
	)


func _unlock_if(achievement_id: String, condition: bool) -> void:
	if not condition or is_unlocked(achievement_id):
		return
	MetaProgress.set_progression_flag(UNLOCK_PREFIX + achievement_id, true)
	achievement_unlocked.emit(achievement_id)
	print("[OathboundAchievementRuntime] unlocked: %s" % achievement_id)
