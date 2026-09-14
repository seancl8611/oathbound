extends "res://Regions/Hushiro/Enemies/Standard/WardenController.gd"

## Current Hushiro rules layer for the imported Warden controller.
##
## The legacy controller remains useful for chain geometry, animation, movement, and
## basic attack plumbing. This wrapper replaces the superseded gameplay rules that
## conflict with docs/content/area_1/enemies/WARDEN.md.

const HUSHIRO_WARDEN_HP: int = 140
const RESTRAINT_PARRY_OPEN_FRACTION: float = 0.62
const RESTRAINT_PARRY_CLOSE_LEAD: float = 0.08
const RESTRAINT_PARRY_STAGGER: float = 1.20
const RESTRAINT_FAILURE_HEALTH_DAMAGE: int = 4
# Temporary symbol compatibility for WardenV2's older validation dictionary. The
# runtime no longer applies player Posture on restraint failure.
const RESTRAINT_FAILURE_POSTURE: float = 0.0

var _restraint_parry_open_at: float = 0.0
var _restraint_parry_close_at: float = 0.0
var _restraint_tell_shown: bool = false


func _ready() -> void:
	warden_hp = HUSHIRO_WARDEN_HP
	chain_break_action = "parry"
	chain_break_presses = 999
	super._ready()
	can_block = true
	block_by_default = false
	block_chance_on_hit = 0.35
	print("[WardenRules] Current Hushiro restraint contract active")


func _start_restrain(p: Node2D) -> void:
	super._start_restrain(p)
	var now := Time.get_ticks_msec() * 0.001
	_restraint_parry_open_at = now + chain_duration * RESTRAINT_PARRY_OPEN_FRACTION
	_restraint_parry_close_at = maxf(_restraint_parry_open_at + 0.05, _restrain_until - RESTRAINT_PARRY_CLOSE_LEAD)
	_restraint_tell_shown = false
	if is_instance_valid(p):
		var chain_ui_value: Variant = p.get("_chain_ui")
		if chain_ui_value is CanvasItem:
			(chain_ui_value as CanvasItem).visible = false
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("warden_restrain_start", {
			"warden": CombatTelemetry.snapshot_actor(self),
			"player": CombatTelemetry.snapshot_actor(p),
			"duration": chain_duration,
			"parry_open_after": _restraint_parry_open_at - now,
			"parry_window": _restraint_parry_close_at - _restraint_parry_open_at,
		})


func _end_restrain_if_elapsed() -> void:
	if not _restraining:
		return
	var now := Time.get_ticks_msec() * 0.001
	if not _restraint_tell_shown and now >= _restraint_parry_open_at:
		_restraint_tell_shown = true
		_show_parry_indicator(maxf(0.05, _restraint_parry_close_at - now), false)
		if CombatTelemetry != null and CombatTelemetry.is_capturing():
			CombatTelemetry.record_event("warden_restrain_parry_open", {
				"warden": CombatTelemetry.snapshot_actor(self),
				"window": maxf(0.0, _restraint_parry_close_at - now),
			})
	if now >= _restraint_parry_open_at and now <= _restraint_parry_close_at and Input.is_action_just_pressed("parry"):
		_break_restrain_with_parry()
		return
	if now >= _restrain_until:
		_apply_restrain_failure_health_damage()
		_hide_parry_indicator()
		super._end_restrain_if_elapsed()


func _break_restrain_with_parry() -> void:
	var now := Time.get_ticks_msec() * 0.001
	var p: Node2D = _restrained_player
	if is_instance_valid(p) and p.has_method("_end_chain_restraint"):
		p.call("_end_chain_restraint")
	_restraining = false
	_restrained_player = null
	_restrain_until = 0.0
	_restraint_parry_open_at = 0.0
	_restraint_parry_close_at = 0.0
	_restraint_tell_shown = false
	_hide_parry_indicator()
	var knock_dir := Vector2.RIGHT
	if is_instance_valid(p):
		var away := global_position - p.global_position
		if away.length_squared() > 0.001:
			knock_dir = away.normalized()
	knockback = Vector2.ZERO
	apply_knockback(knock_dir * parry_knockback_force)
	_stunned_until = now + RESTRAINT_PARRY_STAGGER
	_backoff_until = now + RESTRAINT_PARRY_STAGGER
	_goto(WardenState.STAGGER, RESTRAINT_PARRY_STAGGER)
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("warden_restrain_parried", {
			"warden": CombatTelemetry.snapshot_actor(self),
			"player": CombatTelemetry.snapshot_actor(p) if is_instance_valid(p) else {},
			"stagger_duration": RESTRAINT_PARRY_STAGGER,
		})


func _apply_restrain_failure_health_damage() -> void:
	var p: Node2D = _restrained_player
	if not is_instance_valid(p):
		return
	var hp_before: int = int(p.get("hp")) if p.get("hp") != null else 0
	if p.has_method("take_damage"):
		p.call("take_damage", RESTRAINT_FAILURE_HEALTH_DAMAGE)
	elif p.get("hp") != null:
		p.set("hp", maxi(0, hp_before - RESTRAINT_FAILURE_HEALTH_DAMAGE))
	var hp_after: int = int(p.get("hp")) if p.get("hp") != null else hp_before
	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("warden_restrain_failed", {
			"warden": CombatTelemetry.snapshot_actor(self),
			"player": CombatTelemetry.snapshot_actor(p),
			"health_before": hp_before,
			"health_damage": maxi(0, hp_before - hp_after),
			"health_after": hp_after,
			"player_posture_retired": true,
		})


func get_restrain_failure_health_damage_for_test() -> int:
	return RESTRAINT_FAILURE_HEALTH_DAMAGE