extends Node

const INDICATOR_PATH := "res://Combat/parry_indicator.gd"
const TIMING_PATH := "res://Combat/CounterCueTiming.gd"
const PILGRIM_PATH := "res://Enemy/Area 2/Minibosses/embered_pilgrim_runtime.gd"
const ROOTFANG_PATH := "res://Enemy/Area 2/Boss/rootfang_runtime.gd"
const BRIARTHORN_PATH := "res://Enemy/Area 2/Boss/briarthorn_runtime.gd"
const SHOGUN_PATH := "res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogunRuntime.gd"

const CounterCueTimingScript = preload("res://Combat/CounterCueTiming.gd")

const PASS_LINE := "[AttackPresentationReadabilitySmoke] PASS - global counter cue | blocked lunge stop | Timeless viewport overlay"


func _ready() -> void:
	var failures: Array[String] = []
	var indicator_source: String = _read_source(INDICATOR_PATH, failures)
	var timing_source: String = _read_source(TIMING_PATH, failures)
	var pilgrim_source: String = _read_source(PILGRIM_PATH, failures)
	var rootfang_source: String = _read_source(ROOTFANG_PATH, failures)
	var briarthorn_source: String = _read_source(BRIARTHORN_PATH, failures)
	var shogun_source: String = _read_source(SHOGUN_PATH, failures)

	_check_global_counter_cue_contract(indicator_source, timing_source, failures)
	_check_live_cue_caller_coverage(failures)
	_check_runtime_motion_contracts(pilgrim_source, rootfang_source, briarthorn_source, shogun_source, failures)
	_check_timeless_overlay_contract(shogun_source, failures)

	if failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return

	for failure: String in failures:
		push_error("[AttackPresentationReadabilitySmoke] " + failure)
	get_tree().quit(1)


func _read_source(path: String, failures: Array[String]) -> String:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		failures.append("could not read runtime source: %s" % path)
		return ""
	return file.get_as_text()


func _check_global_counter_cue_contract(
	indicator_source: String,
	timing_source: String,
	failures: Array[String]
) -> void:
	if "WARNING_LEAD_SECONDS: float = 0.20" not in timing_source:
		failures.append("global warning lead is not locked to 0.20 seconds")
	if "PARRY_BEAT_LEAD_SECONDS: float = 0.12" not in timing_source:
		failures.append("global commit beat is not locked to canonical 0.12-second parry window")
	if "resolve_impact_offsets" not in indicator_source:
		failures.append("shared indicator no longer resolves attacks through global timing authority")
	if "func _show_commit_mark" not in indicator_source:
		failures.append("shared indicator lost the fixed pre-contact commit mark")
	if "tween_property(self, \"scale\"" in indicator_source or "_pulse_active" in indicator_source:
		failures.append("shared indicator reintroduced duration-driven shrinking/pulsing")
	if "ACTIVE_COLOR" in indicator_source:
		failures.append("shared indicator reintroduced a contact-time color change")
	if "while _impact_index < _impact_times.size() and now >= _impact_times[_impact_index]" not in indicator_source:
		failures.append("shared indicator no longer disappears at the resolved contact boundary")


func _check_live_cue_caller_coverage(failures: Array[String]) -> void:
	var roots: Array[String] = [
		"res://Regions/Hushiro/Enemies",
		"res://Enemy/Area 2",
		"res://Regions/Kagutsuchi/Enemies",
	]
	for root: String in roots:
		_scan_cue_callers(root, failures)


func _scan_cue_callers(path: String, failures: Array[String]) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		failures.append("could not scan cue callers under %s" % path)
		return

	dir.list_dir_begin()
	var entry := dir.get_next()
	while not entry.is_empty():
		if entry == "." or entry == "..":
			entry = dir.get_next()
			continue
		var child := path.path_join(entry)
		if dir.current_is_dir():
			_scan_cue_callers(child, failures)
		elif entry.ends_with(".gd") and not child.contains("/Enemy/Base/"):
			var file := FileAccess.open(child, FileAccess.READ)
			if file != null:
				var source := file.get_as_text()
				if _source_has_cue_call(source):
					var authority_path := child
					# The Hushiro controller inherits the legacy implementation; runtime
					# resolution sees the controller script, not the inherited source path.
					if child.ends_with("CorruptedSwordsmanLegacy.gd"):
						authority_path = "res://Regions/Hushiro/Enemies/Standard/CorruptedSwordsmanController.gd"
					if not CounterCueTimingScript.supports_script_path(authority_path):
						failures.append("live cue caller is not registered with global timing authority: %s" % child)
		entry = dir.get_next()
	dir.list_dir_end()


func _source_has_cue_call(source: String) -> bool:
	for raw_line: String in source.split("\n"):
		var line := raw_line.strip_edges()
		if line.begins_with("func _show_parry_indicator"):
			continue
		if "_show_parry_indicator(" in line:
			return true
	return false


func _check_runtime_motion_contracts(
	pilgrim_source: String,
	rootfang_source: String,
	briarthorn_source: String,
	shogun_source: String,
	failures: Array[String]
) -> void:
	if "test_move(global_transform" not in pilgrim_source:
		failures.append("Embered Pilgrim runtime lost predictive blocked-lunge stopping")
	if "test_move(global_transform" not in rootfang_source:
		failures.append("Rootfang runtime lost predictive blocked-lunge stopping")
	if "test_move(global_transform" not in briarthorn_source:
		failures.append("Briarthorn runtime lost predictive blocked-lunge stopping")
	if "test_move(global_transform" not in shogun_source:
		failures.append("Eclipse Shogun runtime lost predictive blocked-lunge stopping")

	if "telegraphing = phase == CombatPhase.WINDUP" not in pilgrim_source:
		failures.append("Embered Pilgrim no longer mirrors WINDUP into shared attack state")
	if "swinging = phase == CombatPhase.ACTIVE" not in shogun_source:
		failures.append("Eclipse Shogun no longer mirrors ACTIVE into shared attack state")
	if "_set_combat_phase(CombatPhase.ACTIVE)" not in rootfang_source:
		failures.append("Rootfang roll no longer exposes an ACTIVE attack phase")
	if "_runtime_attack_step_blocked(dir, emp_lunge_speed)" not in briarthorn_source:
		failures.append("Briarthorn empowered lunge no longer stops before blocked motion")


func _check_timeless_overlay_contract(shogun_source: String, failures: Array[String]) -> void:
	if "Control.PRESET_FULL_RECT" not in shogun_source:
		failures.append("Timeless Zone darkness is not viewport-anchored")
	if "darkness.position = -viewport_size * 0.5" in shogun_source:
		failures.append("Timeless Zone restored the legacy world-centered CanvasLayer offset")
