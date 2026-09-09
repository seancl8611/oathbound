extends Node

const INDICATOR_PATH := "res://Combat/parry_indicator.gd"
const PILGRIM_PATH := "res://Enemy/Area 2/Minibosses/embered_pilgrim_runtime.gd"
const ROOTFANG_PATH := "res://Enemy/Area 2/Boss/rootfang_runtime.gd"
const BRIARTHORN_PATH := "res://Enemy/Area 2/Boss/briarthorn_runtime.gd"
const SHOGUN_PATH := "res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogunRuntime.gd"

const PASS_LINE := "[AttackPresentationReadabilitySmoke] PASS - phase-driven cue | blocked lunge stop | Timeless viewport overlay"


func _ready() -> void:
	var failures: Array[String] = []
	var indicator_source: String = _read_source(INDICATOR_PATH, failures)
	var pilgrim_source: String = _read_source(PILGRIM_PATH, failures)
	var rootfang_source: String = _read_source(ROOTFANG_PATH, failures)
	var briarthorn_source: String = _read_source(BRIARTHORN_PATH, failures)
	var shogun_source: String = _read_source(SHOGUN_PATH, failures)

	_check_phase_driven_indicator_contract(indicator_source, failures)
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


func _check_phase_driven_indicator_contract(indicator_source: String, failures: Array[String]) -> void:
	if "func warn_attack" not in indicator_source:
		failures.append("shared attack indicator lost warn_attack compatibility")
	if "_has_combat_phase" not in indicator_source or "2: # ACTIVE" not in indicator_source:
		failures.append("shared attack indicator no longer derives the live ACTIVE phase")
	if "_has_telegraphing" not in indicator_source or "_has_swinging" not in indicator_source:
		failures.append("shared attack indicator lost legacy humanoid windup/active compatibility")
	if "func _pulse_active" not in indicator_source:
		failures.append("shared attack indicator lost the contact-ready pulse")
	if "func hide_now" not in indicator_source:
		failures.append("shared attack indicator lost deterministic cleanup")


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
