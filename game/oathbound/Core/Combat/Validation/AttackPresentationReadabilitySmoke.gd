extends Node

const ParryIndicatorScript = preload("res://Combat/parry_indicator.gd")
const PilgrimRuntimeScript = preload("res://Enemy/Area 2/Minibosses/embered_pilgrim_runtime.gd")
const RootfangRuntimeScript = preload("res://Enemy/Area 2/Boss/rootfang_runtime.gd")
const BriarthornRuntimeScript = preload("res://Enemy/Area 2/Boss/briarthorn_runtime.gd")
const ShogunRuntimeScript = preload("res://Regions/Kagutsuchi/Enemies/Bosses/EclipseShogunRuntime.gd")

const PASS_LINE := "[AttackPresentationReadabilitySmoke] PASS - phase-driven cue | blocked lunge stop | Timeless viewport overlay"


class DummyCueOwner:
	extends Node2D
	var _combat_phase: int = 0
	var telegraphing: bool = false
	var swinging: bool = false
	var is_attacking: bool = false
	var _attack_recovery: bool = false


func _ready() -> void:
	var failures: Array[String] = []
	_check_phase_driven_indicator(failures)
	_check_runtime_motion_contracts(failures)
	_check_timeless_overlay_contract(failures)

	if failures.is_empty():
		print(PASS_LINE)
		get_tree().quit(0)
		return

	for failure: String in failures:
		push_error("[AttackPresentationReadabilitySmoke] " + failure)
	get_tree().quit(1)


func _check_phase_driven_indicator(failures: Array[String]) -> void:
	var owner := DummyCueOwner.new()
	owner.name = "CueOwner"
	add_child(owner)

	var indicator := Node2D.new()
	indicator.name = "ParryIndicator"
	indicator.set_script(ParryIndicatorScript)
	owner.add_child(indicator)

	owner._combat_phase = 1
	indicator.call("warn_attack", 0.6, false)
	indicator.call("_process", 0.0)
	if not indicator.visible:
		failures.append("windup cue was not visible")

	owner._combat_phase = 2
	indicator.call("_process", 0.0)
	if not bool(indicator.get("_seen_active")):
		failures.append("cue did not mark the live ACTIVE contact phase")

	owner._combat_phase = 3
	indicator.call("_process", 0.0)
	if indicator.visible:
		failures.append("cue remained visible into RECOVERY")

	owner.free()


func _check_runtime_motion_contracts(failures: Array[String]) -> void:
	var pilgrim_source: String = PilgrimRuntimeScript.source_code
	var rootfang_source: String = RootfangRuntimeScript.source_code
	var briarthorn_source: String = BriarthornRuntimeScript.source_code
	var shogun_source: String = ShogunRuntimeScript.source_code

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


func _check_timeless_overlay_contract(failures: Array[String]) -> void:
	var shogun_source: String = ShogunRuntimeScript.source_code
	if "Control.PRESET_FULL_RECT" not in shogun_source:
		failures.append("Timeless Zone darkness is not viewport-anchored")
	if "darkness.position = -viewport_size * 0.5" in shogun_source:
		failures.append("Timeless Zone restored the legacy world-centered CanvasLayer offset")
