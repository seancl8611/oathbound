extends "res://Regions/Hushiro/Enemies/Standard/BlightedHound.gd"

## Current Hushiro posture-break completion layer for the Blighted Hound.
## BeastEnemyBase's imported deathblow query is permanently false; current Hushiro
## combat instead derives readiness from the shared CombatController's full/broken
## posture state and stops ordinary beast AI for that window.

var _oathbound_break_active: bool = false


func _ready() -> void:
	super._ready()
	print("[BlightedHound] posture-break runtime active")


func is_deathblow_ready() -> bool:
	return _shared_posture_break_active()


func _beast_tick_shared(delta: float) -> bool:
	var parent_consumed: bool = super._beast_tick_shared(delta)
	var broken: bool = _shared_posture_break_active()
	if broken:
		if not _oathbound_break_active:
			_enter_oathbound_posture_break(_shared_break_duration())
		velocity = Vector2.ZERO
		sync_posture_bar_position()
		return true
	if _oathbound_break_active:
		_exit_oathbound_posture_break()
	return parent_consumed


func _on_base_posture_broken(duration: float) -> void:
	super._on_base_posture_broken(duration)
	_enter_oathbound_posture_break(duration)


func _enter_oathbound_posture_break(duration: float) -> void:
	if _oathbound_break_active:
		return
	_oathbound_break_active = true
	set_meta("_oathbound_deathblow_ready", true)
	_cancel_beast_attack(true)
	_hide_parry_indicator()
	_release_attack_token()
	_release_role("advance_move")
	velocity = Vector2.ZERO
	_play_break_animation()
	_record_break_state("enemy_posture_break_enter", duration)


func _exit_oathbound_posture_break() -> void:
	if not _oathbound_break_active:
		return
	_oathbound_break_active = false
	set_meta("_oathbound_deathblow_ready", false)
	_record_break_state("enemy_posture_break_exit", 0.0)


func _shared_posture_break_active() -> bool:
	if combat == null or combat.config == null or not combat.has_method("get_posture"):
		return false
	var current: float = float(combat.get_posture())
	var maximum: float = float(combat.config.posture_max)
	return maximum > 0.0 and current >= maximum - 0.001


func _shared_break_duration() -> float:
	if combat != null and combat.config != null:
		return float(combat.config.posture_break_duration)
	return 2.5


func _play_break_animation() -> void:
	if anim == null:
		return
	for animation_name: String in ["deathblow_ready", "posture_broken", "parried", "hurt"]:
		if anim.has_animation(animation_name):
			anim.play(animation_name)
			return


func _record_break_state(event_name: String, duration: float) -> void:
	if typeof(CombatTelemetry) != TYPE_OBJECT or not CombatTelemetry.is_capturing():
		return
	CombatTelemetry.record_event(event_name, {
		"enemy": CombatTelemetry.snapshot_actor(self),
		"duration": duration,
		"deathblow_ready": is_deathblow_ready(),
	})
