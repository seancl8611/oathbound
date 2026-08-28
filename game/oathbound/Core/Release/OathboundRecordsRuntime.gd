extends Node

## Launch-facing records/completion authority.
##
## ENDGAME_POSTGAME_RELEASE.md owns which records and 100% goals matter. This runtime
## derives those records from existing MetaProgress, Strand, Prosthetic, Relic,
## Technique, Narrative, and Achievement authorities rather than introducing another
## progression save. Record values therefore travel with the selected save slot.

signal records_changed
signal run_result_ready(result: Dictionary)

const TECHNIQUE_CATALOG = preload("res://Core/Techniques/TechniqueCatalog.gd")
const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

const FLAG_PREFIX := "records/"
const FLAG_TOTAL_ATTEMPTS := FLAG_PREFIX + "total_attempts"
const FLAG_FASTEST_STANDARD := FLAG_PREFIX + "fastest_standard_seconds"
const FLAG_FASTEST_SUPPRESSION := FLAG_PREFIX + "fastest_suppression_seconds"
const FLAG_DEEPEST_FIRST_ATTEMPT := FLAG_PREFIX + "deepest_first_attempt"
const FLAG_FIRST_HEART_VICTORY := FLAG_PREFIX + "first_heart_victory"
const FLAG_MINIBOSS_DEFEATS := FLAG_PREFIX + "miniboss_defeats_total"
const FLAG_LAST_RESULT := FLAG_PREFIX + "last_result"
const FLAG_RESULT_PENDING := FLAG_PREFIX + "result_pending"
const TECHNIQUE_RECORD_PREFIX := "technique_record/"
const HEART_ASPECT_PREFIX := "heart_clear_aspect/"

# Completion counts only Blood Cavern trials that are actually playable in the current
# release runtime. `last_oath_trial` remains reserved challenge/Relic sequencing data in
# OathboundStrandProgressionManager, but it must not make 100% completion impossible
# before an authored player-facing trial path exists.
const REQUIRED_BLOOD_CAVERN_TRIALS: Array[String] = [
	"execution_trial",
]

# The approved launch catalog contains ten Relics, but Last Oath is currently reserved
# behind the not-yet-authored `last_oath_trial`. Completion therefore counts the nine
# Relics that have player-accessible acquisition paths today and their two mastery ranks.
# When the second challenge becomes playable, add Last Oath here rather than changing
# the 10-Relic catalog or inventing a temporary acquisition source.
const REQUIRED_OBTAINABLE_RELICS: Array[String] = [
	RELIC_CATALOG.TRAVELERS_COIN,
	RELIC_CATALOG.MERCHANTS_SEAL,
	RELIC_CATALOG.IRON_PRAYER_BEAD,
	RELIC_CATALOG.SPIRIT_TASSEL,
	RELIC_CATALOG.EXECUTION_BEAD,
	RELIC_CATALOG.WAYFARERS_CHARM,
	RELIC_CATALOG.UNBROKEN_CORD,
	RELIC_CATALOG.SCRIBES_LENS,
	RELIC_CATALOG.BLOOD_MOON_SHARD,
]

# All 24 authored launch Lore / Records entries now have deterministic player-facing
# unlock paths through existing campaign, Relic, and miniboss state. Keep this list in
# lockstep with those reachable authored records; a future catalog entry must gain a
# real discovery path before it becomes part of required completion.
const REQUIRED_DISCOVERY_RECORDS: Array[String] = [
	"record_plague_year",
	"record_first_extraction",
	"record_seven_bindings",
	"record_beast_blood_spread",
	"record_containment",
	"record_keeper_oath",
	"record_escaped_child",
	"record_returning_blood",
	"record_false_mastery",
	"record_order_crossings",
	"record_hushiro",
	"record_yomori",
	"record_kagutsuchi",
	"record_keeper_gate",
	"record_twin_maws",
	"record_eclipse_shogun",
	"record_blood_lotus",
	"record_eternal_swordsman",
	"record_relic_provenance",
	"record_prosthetic_craft",
	"record_blood_aspects",
	"record_heart_rejection",
	"record_unbound_heart",
	"record_after_heart",
]

var _run_active := false
var _run_started_msec: int = 0
var _run_elapsed_before_resume: float = 0.0
var _run_resource_start: Dictionary = {}
var _first_attempt_at_start := false
var _completion_recalc_queued := false


func _ready() -> void:
	if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_signal("progression_changed"):
		var progression_cb := Callable(self, "_queue_completion_recalc")
		if not MetaProgress.is_connected("progression_changed", progression_cb):
			MetaProgress.connect("progression_changed", progression_cb)
	if typeof(RelicRuntime) == TYPE_OBJECT:
		if RelicRuntime.has_signal("collection_changed"):
			var collection_cb := Callable(self, "_queue_completion_recalc")
			if not RelicRuntime.is_connected("collection_changed", collection_cb):
				RelicRuntime.connect("collection_changed", collection_cb)
		if RelicRuntime.has_signal("mastery_changed"):
			var mastery_cb := Callable(self, "_on_relic_mastery_changed")
			if not RelicRuntime.is_connected("mastery_changed", mastery_cb):
				RelicRuntime.connect("mastery_changed", mastery_cb)
	if typeof(ProstheticManager) == TYPE_OBJECT:
		if ProstheticManager.has_signal("prosthetic_unlocked"):
			var unlock_cb := Callable(self, "_on_prosthetic_changed")
			if not ProstheticManager.is_connected("prosthetic_unlocked", unlock_cb):
				ProstheticManager.connect("prosthetic_unlocked", unlock_cb)
		if ProstheticManager.has_signal("prosthetic_equipped"):
			var equip_cb := Callable(self, "_on_prosthetic_changed")
			if not ProstheticManager.is_connected("prosthetic_equipped", equip_cb):
				ProstheticManager.connect("prosthetic_equipped", equip_cb)
		if ProstheticManager.has_signal("upgrade_purchased"):
			var upgrade_cb := Callable(self, "_on_prosthetic_upgrade_changed")
			if not ProstheticManager.is_connected("upgrade_purchased", upgrade_cb):
				ProstheticManager.connect("upgrade_purchased", upgrade_cb)
	_queue_completion_recalc()


func on_run_started(resumed: bool = false, elapsed_before_resume: float = 0.0, resource_start: Dictionary = {}) -> void:
	if _run_active:
		return
	_run_active = true
	_run_started_msec = Time.get_ticks_msec()
	_run_elapsed_before_resume = maxf(0.0, elapsed_before_resume)
	_first_attempt_at_start = typeof(MetaProgress) == TYPE_OBJECT and not bool(MetaProgress.is_returning_blood_awakened())
	if resource_start.is_empty() and typeof(MetaProgress) == TYPE_OBJECT:
		_run_resource_start = MetaProgress.get_resource_snapshot()
	else:
		_run_resource_start = resource_start.duplicate(true)

	if not resumed:
		_set_record_int(FLAG_TOTAL_ATTEMPTS, get_total_attempts() + 1)
	if typeof(SaveSlots) == TYPE_OBJECT:
		SaveSlots.begin_gameplay_session()
	recalculate_completion()
	records_changed.emit()


func on_run_finished(successful: bool, completion_kind: String = "failed") -> Dictionary:
	if not _run_active:
		return {}
	var elapsed := get_current_run_elapsed_seconds()
	var normalized_kind := completion_kind.to_lower()
	if normalized_kind.is_empty():
		normalized_kind = "failed"

	var result := _build_run_result(successful, normalized_kind, elapsed)
	MetaProgress.set_progression_flag(FLAG_LAST_RESULT, result)
	MetaProgress.set_progression_flag(FLAG_RESULT_PENDING, true)

	if _first_attempt_at_start:
		_set_record_int(FLAG_DEEPEST_FIRST_ATTEMPT, maxi(get_deepest_first_attempt(), int(result.get("depth", 0))))

	if successful and normalized_kind == RunData.RUN_GOAL_STANDARD_EXPEDITION:
		_set_personal_best(FLAG_FASTEST_STANDARD, elapsed)
	elif successful and normalized_kind == RunData.RUN_GOAL_HEART_SUPPRESSION:
		_set_personal_best(FLAG_FASTEST_SUPPRESSION, elapsed)

	if successful and normalized_kind in ["story_complete", RunData.RUN_GOAL_HEART_SUPPRESSION]:
		var aspect_id := str(result.get("aspect", "")).to_lower()
		if typeof(AchievementRuntime) == TYPE_OBJECT and AchievementRuntime.has_method("record_heart_clear"):
			AchievementRuntime.record_heart_clear(aspect_id)
		if normalized_kind == "story_complete":
			MetaProgress.set_progression_flag(FLAG_FIRST_HEART_VICTORY, true)

	_run_active = false
	_run_started_msec = 0
	_run_elapsed_before_resume = 0.0
	_run_resource_start.clear()
	_first_attempt_at_start = false
	if typeof(SaveSlots) == TYPE_OBJECT:
		SaveSlots.clear_safe_checkpoint()
	recalculate_completion()
	run_result_ready.emit(result.duplicate(true))
	records_changed.emit()
	return result


func is_run_active() -> bool:
	return _run_active


func get_current_run_elapsed_seconds() -> float:
	if not _run_active or _run_started_msec <= 0:
		return _run_elapsed_before_resume
	return _run_elapsed_before_resume + maxf(0.0, float(Time.get_ticks_msec() - _run_started_msec) / 1000.0)


func get_run_resume_record_state() -> Dictionary:
	return {
		"elapsed_seconds": get_current_run_elapsed_seconds(),
		"resource_start": _run_resource_start.duplicate(true),
	}


func get_current_run_performance_snapshot() -> Dictionary:
	if typeof(RunData) != TYPE_OBJECT:
		return {}
	return {
		"enemies_defeated": int(RunData.enemies_killed),
		"parries": int(RunData.parries_performed),
		"perfect_parries": int(RunData.perfect_parries),
		"damage_taken": int(RunData.damage_taken),
		"combat_rooms_cleared": int(RunData.combat_rooms_cleared),
		"blessings_received": int(RunData.blessings_received),
		"treasures_opened": int(RunData.treasures_opened),
		"items_purchased": int(RunData.items_purchased),
	}


func consume_pending_result() -> Dictionary:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return {}
	if not bool(MetaProgress.get_progression_flag(FLAG_RESULT_PENDING, false)):
		return {}
	var value: Variant = MetaProgress.get_progression_flag(FLAG_LAST_RESULT, {})
	MetaProgress.set_progression_flag(FLAG_RESULT_PENDING, false)
	return (value as Dictionary).duplicate(true) if value is Dictionary else {}


func peek_last_result() -> Dictionary:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return {}
	var value: Variant = MetaProgress.get_progression_flag(FLAG_LAST_RESULT, {})
	return (value as Dictionary).duplicate(true) if value is Dictionary else {}


func record_miniboss_defeat() -> void:
	_set_record_int(FLAG_MINIBOSS_DEFEATS, get_miniboss_defeat_count() + 1)
	records_changed.emit()


func get_total_attempts() -> int:
	return _record_int(FLAG_TOTAL_ATTEMPTS)


func get_fastest_standard_seconds() -> float:
	return _record_float(FLAG_FASTEST_STANDARD)


func get_fastest_suppression_seconds() -> float:
	return _record_float(FLAG_FASTEST_SUPPRESSION)


func get_deepest_first_attempt() -> int:
	return _record_int(FLAG_DEEPEST_FIRST_ATTEMPT)


func get_miniboss_defeat_count() -> int:
	return _record_int(FLAG_MINIBOSS_DEFEATS)


func get_records_snapshot() -> Dictionary:
	return {
		"total_attempts": get_total_attempts(),
		"standard_expedition_clears": int(MetaProgress.standard_expedition_clears) if typeof(MetaProgress) == TYPE_OBJECT else 0,
		"heart_suppression_clears": int(MetaProgress.heart_suppression_clears) if typeof(MetaProgress) == TYPE_OBJECT else 0,
		"fastest_standard_seconds": get_fastest_standard_seconds(),
		"fastest_suppression_seconds": get_fastest_suppression_seconds(),
		"heart_wolf": _heart_aspect_clear("wolf"),
		"heart_wraith": _heart_aspect_clear("wraith"),
		"heart_ronin": _heart_aspect_clear("ronin"),
		"boss_defeat_counts": MetaProgress.boss_defeat_counts.duplicate(true) if typeof(MetaProgress) == TYPE_OBJECT else {},
		"miniboss_defeats": get_miniboss_defeat_count(),
		"deepest_first_attempt": get_deepest_first_attempt(),
		"first_heart_victory": bool(MetaProgress.is_story_complete()) if typeof(MetaProgress) == TYPE_OBJECT else false,
		"completion_percent": get_completion_percent(),
	}


func get_completion_percent() -> int:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return 0
	return clampi(int(MetaProgress.get_progression_flag("achievement_metric/completion_percent", 0)), 0, 100)


func get_completion_breakdown() -> Dictionary:
	var bloodwell_total := 0
	var bloodwell_owned := 0
	var infrastructure_total := 0
	var infrastructure_owned := 0
	var mirror_total := 0
	var mirror_owned := 0
	if typeof(MetaProgressionManager) == TYPE_OBJECT and MetaProgressionManager.has_method("get_structural_nodes"):
		for node_value: Variant in MetaProgressionManager.get_structural_nodes():
			if not (node_value is Dictionary):
				continue
			var node: Dictionary = node_value as Dictionary
			var station := str(node.get("station", ""))
			var group := str(node.get("group", ""))
			var node_id := str(node.get("id", ""))
			if station == "bloodwell":
				if group == "run_infrastructure":
					infrastructure_total += 1
					if MetaProgress.is_progression_node_owned(node_id):
						infrastructure_owned += 1
				else:
					bloodwell_total += 1
					if MetaProgress.is_progression_node_owned(node_id):
						bloodwell_owned += 1
			elif station == "blood_mirror":
				mirror_total += 1
				if MetaProgress.is_progression_node_owned(node_id):
					mirror_owned += 1

	var prosthetics_total := 0
	var prosthetics_owned := 0
	var prosthetic_upgrades_total := 0
	var prosthetic_upgrades_owned := 0
	if typeof(ProstheticManager) == TYPE_OBJECT:
		var prosthetics: Array = ProstheticManager.get_all_prosthetics() if ProstheticManager.has_method("get_all_prosthetics") else []
		prosthetics_total = prosthetics.size()
		prosthetics_owned = ProstheticManager.get_unlocked_prosthetics().size() if ProstheticManager.has_method("get_unlocked_prosthetics") else 0
		for data_value: Variant in prosthetics:
			if data_value == null:
				continue
			var prosthetic_id := str(data_value.get("id"))
			var upgrades_value: Variant = data_value.get("upgrade_nodes")
			if upgrades_value is Array:
				for upgrade_value: Variant in upgrades_value:
					if not (upgrade_value is Dictionary):
						continue
					prosthetic_upgrades_total += 1
					var upgrade_id := str((upgrade_value as Dictionary).get("id", ""))
					if ProstheticManager.is_upgrade_purchased(prosthetic_id, upgrade_id):
						prosthetic_upgrades_owned += 1

	var relics_total := REQUIRED_OBTAINABLE_RELICS.size()
	var relics_owned := 0
	var relic_mastery_total := REQUIRED_OBTAINABLE_RELICS.size() * 2
	var relic_mastery_owned := 0
	if typeof(RelicRuntime) == TYPE_OBJECT:
		for relic_id: String in REQUIRED_OBTAINABLE_RELICS:
			if RelicRuntime.has_method("is_unlocked") and bool(RelicRuntime.call("is_unlocked", relic_id)):
				relics_owned += 1
			if RelicRuntime.has_method("get_mastery_rank"):
				relic_mastery_owned += clampi(int(RelicRuntime.call("get_mastery_rank", relic_id)), 0, 2)

	var technique_total := TECHNIQUE_CATALOG.TECHNIQUES.size() + TECHNIQUE_CATALOG.REFINEMENTS.size()
	var technique_owned := _count_technique_records()
	var trial_total := REQUIRED_BLOOD_CAVERN_TRIALS.size()
	var trial_owned := 0
	for trial_id: String in REQUIRED_BLOOD_CAVERN_TRIALS:
		if MetaProgress.has_completed_blood_cavern_trial(trial_id):
			trial_owned += 1

	var records_total := REQUIRED_DISCOVERY_RECORDS.size()
	var records_owned := 0
	if typeof(NarrativeRuntime) == TYPE_OBJECT and NarrativeRuntime.has_method("is_lore_unlocked"):
		for record_id: String in REQUIRED_DISCOVERY_RECORDS:
			if NarrativeRuntime.is_lore_unlocked(record_id):
				records_owned += 1

	var aspects_total := 3
	var aspects_owned := int(_heart_aspect_clear("wolf")) + int(_heart_aspect_clear("wraith")) + int(_heart_aspect_clear("ronin"))

	return {
		"story": {"owned": 1 if MetaProgress.is_story_complete() else 0, "total": 1},
		"bloodwell": {"owned": bloodwell_owned, "total": bloodwell_total},
		"run_infrastructure": {"owned": infrastructure_owned, "total": infrastructure_total},
		"blood_mirror": {"owned": mirror_owned, "total": mirror_total},
		"prosthetics": {"owned": prosthetics_owned, "total": prosthetics_total},
		"prosthetic_upgrades": {"owned": prosthetic_upgrades_owned, "total": prosthetic_upgrades_total},
		"relics": {"owned": relics_owned, "total": relics_total},
		"relic_mastery": {"owned": relic_mastery_owned, "total": relic_mastery_total},
		"techniques": {"owned": technique_owned, "total": technique_total},
		"trials": {"owned": trial_owned, "total": trial_total},
		"discovery_records": {"owned": records_owned, "total": records_total},
		"heart_aspects": {"owned": aspects_owned, "total": aspects_total},
	}


func recalculate_completion() -> int:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return 0
	var breakdown := get_completion_breakdown()
	var owned := 0
	var total := 0
	for value: Variant in breakdown.values():
		if not (value is Dictionary):
			continue
		owned += maxi(0, int((value as Dictionary).get("owned", 0)))
		total += maxi(0, int((value as Dictionary).get("total", 0)))
	var percent := clampi(int(round(100.0 * float(owned) / float(maxi(1, total)))), 0, 100)

	var trials_complete := _breakdown_complete(breakdown, "trials")
	var records_complete := _breakdown_complete(breakdown, "discovery_records")
	MetaProgress.set_progression_flag("all_required_trials_complete", trials_complete)
	MetaProgress.set_progression_flag("required_records_complete", records_complete)

	if typeof(AchievementRuntime) == TYPE_OBJECT:
		_set_achievement_metric("bloodwell_nodes", _breakdown_owned(breakdown, "bloodwell") + _breakdown_owned(breakdown, "run_infrastructure"))
		_set_achievement_metric("mirror_nodes", _breakdown_owned(breakdown, "blood_mirror"))
		_set_achievement_metric("prosthetics", _breakdown_owned(breakdown, "prosthetics"))
		_set_achievement_metric("prosthetic_upgrades", _breakdown_owned(breakdown, "prosthetic_upgrades"))
		_set_achievement_metric("relics", _breakdown_owned(breakdown, "relics"))
		_set_achievement_metric("relic_masteries", _breakdown_owned(breakdown, "relic_mastery"))
		_set_achievement_metric("technique_records", _breakdown_owned(breakdown, "techniques"))
		_set_achievement_metric("trials", _breakdown_owned(breakdown, "trials"))
		_set_achievement_metric("completion_percent", percent)
	else:
		MetaProgress.set_progression_flag("achievement_metric/completion_percent", percent)

	records_changed.emit()
	return percent


func _build_run_result(successful: bool, completion_kind: String, elapsed: float) -> Dictionary:
	var current_resources: Dictionary = MetaProgress.get_resource_snapshot() if typeof(MetaProgress) == TYPE_OBJECT else {}
	var start_materials_value: Variant = _run_resource_start.get("boss_materials", {})
	var current_materials_value: Variant = current_resources.get("boss_materials", {})
	var start_materials: Dictionary = start_materials_value if start_materials_value is Dictionary else {}
	var current_materials: Dictionary = current_materials_value if current_materials_value is Dictionary else {}
	var gained_materials: Dictionary = {}
	for material_id in current_materials.keys():
		var delta := int(current_materials.get(material_id, 0)) - int(start_materials.get(material_id, 0))
		if delta > 0:
			gained_materials[str(material_id)] = delta

	return {
		"successful": successful,
		"completion_kind": completion_kind,
		"clear_time_seconds": elapsed,
		"area": int(RunData.current_area_id) if typeof(RunData) == TYPE_OBJECT else 1,
		"depth": int(RunData.depth) if typeof(RunData) == TYPE_OBJECT else 0,
		"run_goal": str(RunData.run_goal) if typeof(RunData) == TYPE_OBJECT else "",
		"performance": get_current_run_performance_snapshot(),
		"mist_gained": maxi(0, int(current_resources.get("mist", 0)) - int(_run_resource_start.get("mist", 0))),
		"scrolls_gained": maxi(0, int(current_resources.get("scrolls", 0)) - int(_run_resource_start.get("scrolls", 0))),
		"boss_materials_gained": gained_materials,
		"bindings_destroyed": int(MetaProgress.heart_bindings_destroyed) if typeof(MetaProgress) == TYPE_OBJECT else 0,
		"bindings_remaining": int(MetaProgress.remaining_heart_bindings()) if typeof(MetaProgress) == TYPE_OBJECT else 6,
		"story_complete": bool(MetaProgress.is_story_complete()) if typeof(MetaProgress) == TYPE_OBJECT else false,
		"aspect": str(AspectRuntime.selected_aspect) if typeof(AspectRuntime) == TYPE_OBJECT else "",
		"highest_tier": int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0,
		"techniques": RunData.get_acquired_upgrades().duplicate() if typeof(RunData) == TYPE_OBJECT else [],
		"equipped_prosthetic": str(ProstheticManager.equipped_prosthetic_id) if typeof(ProstheticManager) == TYPE_OBJECT else "",
		"equipped_relic": str(RelicRuntime.equipped_relic_id) if typeof(RelicRuntime) == TYPE_OBJECT else "",
		"run_only_lost": ["Gold", "Techniques", "Refinements", "Tier", "Blood", "Corruption", "Temporary Capacity"],
	}


func _count_technique_records() -> int:
	var count := 0
	if typeof(MetaProgress) != TYPE_OBJECT:
		return count
	for technique_id in TECHNIQUE_CATALOG.TECHNIQUES.keys():
		if bool(MetaProgress.get_progression_flag(TECHNIQUE_RECORD_PREFIX + str(technique_id), false)):
			count += 1
	for refinement_id in TECHNIQUE_CATALOG.REFINEMENTS.keys():
		if bool(MetaProgress.get_progression_flag(TECHNIQUE_RECORD_PREFIX + str(refinement_id), false)):
			count += 1
	return count


func _heart_aspect_clear(aspect_id: String) -> bool:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return false
	return bool(MetaProgress.get_progression_flag(HEART_ASPECT_PREFIX + aspect_id, false))


func _record_int(flag: String) -> int:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return 0
	return maxi(0, int(MetaProgress.get_progression_flag(flag, 0)))


func _record_float(flag: String) -> float:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return 0.0
	return maxf(0.0, float(MetaProgress.get_progression_flag(flag, 0.0)))


func _set_record_int(flag: String, value: int) -> void:
	MetaProgress.set_progression_flag(flag, maxi(0, value))


func _set_personal_best(flag: String, value: float) -> void:
	var current := _record_float(flag)
	if current <= 0.0 or value < current:
		MetaProgress.set_progression_flag(flag, maxf(0.0, value))


func _set_achievement_metric(metric_id: String, value: Variant) -> void:
	if typeof(AchievementRuntime) == TYPE_OBJECT and AchievementRuntime.has_method("set_metric"):
		AchievementRuntime.set_metric(metric_id, value)
	else:
		MetaProgress.set_progression_flag("achievement_metric/%s" % metric_id, value)


func _queue_completion_recalc() -> void:
	if _completion_recalc_queued:
		return
	_completion_recalc_queued = true
	call_deferred("_run_queued_completion_recalc")


func _run_queued_completion_recalc() -> void:
	_completion_recalc_queued = false
	recalculate_completion()


func _on_relic_mastery_changed(_relic_id: String, _kills: int, _rank: int) -> void:
	_queue_completion_recalc()


func _on_prosthetic_changed(_prosthetic_id: String) -> void:
	_queue_completion_recalc()


func _on_prosthetic_upgrade_changed(_prosthetic_id: String, _upgrade_id: String) -> void:
	_queue_completion_recalc()


func _breakdown_owned(breakdown: Dictionary, key: String) -> int:
	var value: Variant = breakdown.get(key, {})
	return int((value as Dictionary).get("owned", 0)) if value is Dictionary else 0


func _breakdown_complete(breakdown: Dictionary, key: String) -> bool:
	var value: Variant = breakdown.get(key, {})
	if not (value is Dictionary):
		return false
	return int((value as Dictionary).get("owned", 0)) >= int((value as Dictionary).get("total", 1))
