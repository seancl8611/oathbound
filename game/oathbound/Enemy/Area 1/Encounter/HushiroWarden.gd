extends "res://Enemy/Area 1/Encounter/warden.gd"

## Current Hushiro rules layer for the imported Warden controller.
##
## The legacy controller remains useful for chain geometry, animation, movement, and
## basic attack plumbing. This wrapper replaces the superseded gameplay rules that
## conflict with docs/content/area_1/enemies/WARDEN.md.

const HUSHIRO_WARDEN_HP: int = 140
const RESTRAINT_PARRY_OPEN_FRACTION: float = 0.62
const RESTRAINT_PARRY_CLOSE_LEAD: float = 0.08
const RESTRAINT_PARRY_STAGGER: float = 1.20
const RESTRAINT_FAILURE_POSTURE: float = 25.0

var _restraint_parry_open_at: float = 0.0
var _restraint_parry_close_at: float = 0.0
var _restraint_tell_shown: bool = false


func _ready() -> void:
	# Feed the inherited default application the current Hushiro durability target.
	warden_hp = HUSHIRO_WARDEN_HP

	# The imported Player CHAINED state still has a mash escape implementation. Point
	# it at parry with an unreachable press count; this wrapper owns the actual single
	# timed parry check below and hides the obsolete mash progress UI.
	chain_break_action = "parry"
	chain_break_presses = 999

	super._ready()

	# Warden is a slow restraint/support priority target, not another permanent-guard
	# swordsman. It can still react defensively through inherited humanoid hooks, but it
	# does not idle behind a default block state.
	can_block = true
	block_by_default = false
	block_chance_on_hit = 0.35

	print("[HushiroWarden] Current restraint contract active")


func _start_restrain(p: Node2D) -> void:
	super._start_restrain(p)

	var now := Time.get_ticks_msec() * 0.001
	_restraint_parry_open_at = now + chain_duration * RESTRAINT_PARRY_OPEN_FRACTION
	_restraint_parry_close_at = maxf(_restraint_parry_open_at + 0.05, _restrain_until - RESTRAINT_PARRY_CLOSE_LEAD)
	_restraint_tell_shown = false

	# Remove the imported mash-progress presentation. The Warden itself supplies the
	# pre-yank parry tell through the shared parry indicator.
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
		_apply_restrain_failure_posture()
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

	# Successful escape is intentionally a strong punish window: the Warden is a
	# support/controller enemy whose restraint should become dangerous only when the
	# player misses this readable response.
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


func _apply_restrain_failure_posture() -> void:
	var p: Node2D = _restrained_player
	if not is_instance_valid(p):
		return

	var current_value: Variant = p.get("stagger")
	var max_value: Variant = p.get("stagger_max")
	if current_value == null or max_value == null:
		return

	var before := float(current_value)
	var maximum := maxf(1.0, float(max_value))
	var after := minf(maximum, before + RESTRAINT_FAILURE_POSTURE)
	p.set("stagger", after)
	if p.has_method("_update_stagger_ui"):
		p.call("_update_stagger_ui")

	if CombatTelemetry != null and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("warden_restrain_failed", {
			"warden": CombatTelemetry.snapshot_actor(self),
			"player": CombatTelemetry.snapshot_actor(p),
			"posture_before": before,
			"posture_added": RESTRAINT_FAILURE_POSTURE,
			"posture_after": after,
		})
