extends Node

## Release completion/record projection. This does not own progression; it summarizes
## existing persistent authorities and the achievement metrics they expose.

signal completion_changed(percent: int)

const TOTAL_BLOODWELL := 18
const TOTAL_MIRROR := 9
const TOTAL_PROSTHETICS := 8
const TOTAL_PROSTHETIC_UPGRADES := 19
const TOTAL_RELICS := 10
const TOTAL_RELIC_MASTERIES := 20
const TOTAL_TECHNIQUE_RECORDS := 60
const TOTAL_RECORDS := 24
const TOTAL_HEART_ASPECTS := 3
const TOTAL_WEIGHT := 1 + TOTAL_BLOODWELL + TOTAL_MIRROR + TOTAL_PROSTHETICS + TOTAL_PROSTHETIC_UPGRADES + TOTAL_RELICS + TOTAL_RELIC_MASTERIES + TOTAL_TECHNIQUE_RECORDS + 1 + TOTAL_RECORDS + TOTAL_HEART_ASPECTS

var _last_percent := -1


func _ready() -> void:
	for signal_name in ["progression_changed", "campaign_changed"]:
		if MetaProgress.has_signal(signal_name):
			var cb := Callable(self, "refresh")
			if not MetaProgress.is_connected(signal_name, cb):
				MetaProgress.connect(signal_name, cb)
	call_deferred("refresh")


func refresh() -> int:
	var percent := get_completion_percent()
	if percent != _last_percent:
		_last_percent = percent
		if typeof(AchievementRuntime) == TYPE_OBJECT:
			AchievementRuntime.set_metric("completion_percent", percent)
		completion_changed.emit(percent)
	return percent


func get_completion_percent() -> int:
	var score := 0
	score += 1 if MetaProgress.is_story_complete() else 0
	var station_counts := _strand_station_counts()
	score += mini(TOTAL_BLOODWELL, int(station_counts.get("bloodwell", 0)))
	score += mini(TOTAL_MIRROR, int(station_counts.get("blood_mirror", 0)))
	score += mini(TOTAL_PROSTHETICS, AchievementRuntime.get_metric("prosthetics"))
	score += mini(TOTAL_PROSTHETIC_UPGRADES, AchievementRuntime.get_metric("prosthetic_upgrades"))
	score += mini(TOTAL_RELICS, AchievementRuntime.get_metric("relics"))
	score += mini(TOTAL_RELIC_MASTERIES, AchievementRuntime.get_metric("relic_masteries"))
	score += mini(TOTAL_TECHNIQUE_RECORDS, AchievementRuntime.get_metric("technique_records"))
	score += 1 if bool(MetaProgress.get_progression_flag("all_required_trials_complete", false)) else 0
	score += mini(TOTAL_RECORDS, NarrativeRuntime.get_unlocked_lore().size())
	score += _heart_aspect_clear_count()
	return clampi(int(round(float(score) / float(TOTAL_WEIGHT) * 100.0)), 0, 100)


func get_record_snapshot() -> Dictionary:
	return {
		"completion_percent": get_completion_percent(),
		"total_attempts": maxi(0, AchievementRuntime.get_metric("total_attempts")),
		"standard_expedition_clears": maxi(0, MetaProgress.standard_expedition_clears),
		"heart_suppression_clears": maxi(0, MetaProgress.heart_suppression_clears),
		"fastest_standard_seconds": maxi(0, AchievementRuntime.get_metric("fastest_standard_seconds")),
		"fastest_suppression_seconds": maxi(0, AchievementRuntime.get_metric("fastest_suppression_seconds")),
		"heart_clear_wolf": bool(MetaProgress.get_progression_flag("heart_clear_aspect/wolf", false)),
		"heart_clear_wraith": bool(MetaProgress.get_progression_flag("heart_clear_aspect/wraith", false)),
		"heart_clear_ronin": bool(MetaProgress.get_progression_flag("heart_clear_aspect/ronin", false)),
		"boss_defeat_counts": MetaProgress.boss_defeat_counts.duplicate(true),
		"unique_minibosses": maxi(0, AchievementRuntime.get_metric("unique_minibosses")),
		"deepest_first_attempt": maxi(0, AchievementRuntime.get_metric("deepest_first_attempt")),
		"first_heart_victory": MetaProgress.is_story_complete(),
	}


func record_run_start() -> void:
	AchievementRuntime.increment_metric("total_attempts")


func record_run_clear(kind: String, elapsed_seconds: int, aspect_id: String = "") -> void:
	var seconds := maxi(0, elapsed_seconds)
	if kind == "standard_expedition":
		_record_fastest("fastest_standard_seconds", seconds)
	elif kind in ["heart_suppression", "story_heart"]:
		_record_fastest("fastest_suppression_seconds", seconds)
		if not aspect_id.is_empty():
			AchievementRuntime.record_heart_clear(aspect_id)
	refresh()


func record_first_attempt_depth(depth: int) -> void:
	var current := AchievementRuntime.get_metric("deepest_first_attempt")
	if depth > current:
		AchievementRuntime.set_metric("deepest_first_attempt", depth)


func _record_fastest(metric_id: String, seconds: int) -> void:
	if seconds <= 0:
		return
	var current := AchievementRuntime.get_metric(metric_id)
	if current <= 0 or seconds < current:
		AchievementRuntime.set_metric(metric_id, seconds)


func _strand_station_counts() -> Dictionary:
	var result := {"bloodwell": 0, "blood_mirror": 0}
	if typeof(MetaProgressionManager) != TYPE_OBJECT or not MetaProgressionManager.has_method("get_nodes_for_station"):
		return result
	for station in ["bloodwell", "blood_mirror"]:
		var nodes: Array = MetaProgressionManager.call("get_nodes_for_station", station)
		var count := 0
		for node in nodes:
			if node is Dictionary and bool((node as Dictionary).get("owned", false)):
				count += 1
		result[station] = count
	return result


func _heart_aspect_clear_count() -> int:
	var count := 0
	for aspect in ["wolf", "wraith", "ronin"]:
		if bool(MetaProgress.get_progression_flag("heart_clear_aspect/" + aspect, false)):
			count += 1
	return count
