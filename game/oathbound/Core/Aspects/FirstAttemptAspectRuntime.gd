extends "res://Core/Aspects/AspectRuntimeIntegrated.gd"

## First-attempt campaign gate around the already-reconciled Blood Aspect runtime.
##
## FIRST_ATTEMPT.md owns this boundary: before Returning Blood awakens, Akio has no
## selected Blood Aspect, no Tier progression, no Blood/Blood Art, and no Aspect HUD.
## After awakening, this layer delegates to the existing Aspect runtime unchanged once
## a valid pre-run Aspect has been selected.

const NO_ASPECT := ""


func _ready() -> void:
	if typeof(MetaProgress) == TYPE_OBJECT and MetaProgress.has_signal("returning_blood_awakened_changed"):
		var callback := Callable(self, "_on_returning_blood_awakened_changed")
		if not MetaProgress.is_connected("returning_blood_awakened_changed", callback):
			MetaProgress.connect("returning_blood_awakened_changed", callback)
	synchronize_campaign_state(false)
	super._ready()
	print("[FirstAttemptAspectRuntime] pre-awakening base-katana gate active")


func is_returning_blood_awakened() -> bool:
	if typeof(MetaProgress) != TYPE_OBJECT:
		return true
	if MetaProgress.has_method("is_returning_blood_awakened"):
		return bool(MetaProgress.call("is_returning_blood_awakened"))
	return bool(MetaProgress.get("returning_blood_awakened"))


func has_active_aspect() -> bool:
	return is_returning_blood_awakened() and selected_aspect in CATALOG.ASPECTS


func synchronize_campaign_state(apply_to_player: bool = true) -> void:
	if not is_returning_blood_awakened():
		selected_aspect = NO_ASPECT
		tier = 0
		blood = 0.0
		blood_art_resolving = false
		_clear_contact_cache()
		if apply_to_player:
			_apply_to_live_player()
		aspect_changed.emit(selected_aspect)
		tier_changed.emit(tier)
		_emit_state()
		return

	# Awakening unlocks Aspect selection; it does not silently choose one. The actual
	# pre-run selection remains owned by the Strand/run-preparation flow.
	if selected_aspect not in CATALOG.ASPECTS:
		selected_aspect = NO_ASPECT
		tier = 0
		blood = 0.0
		blood_art_resolving = false
		_clear_contact_cache()
		if apply_to_player:
			_apply_to_live_player()
		aspect_changed.emit(selected_aspect)
		tier_changed.emit(tier)
		_emit_state()


func select_aspect(aspect: String) -> bool:
	if not is_returning_blood_awakened():
		return false
	return super.select_aspect(aspect)


func set_tier(value: int) -> void:
	if not has_active_aspect():
		tier = 0
		blood = 0.0
		blood_art_resolving = false
		_emit_state()
		return
	super.set_tier(value)


func advance_tier() -> bool:
	if not has_active_aspect():
		return false
	return super.advance_tier()


func reset_for_new_run() -> void:
	if not has_active_aspect():
		tier = 0
		blood = 0.0
		blood_art_resolving = false
		_clear_contact_cache()
		_apply_to_live_player()
		tier_changed.emit(tier)
		_emit_state()
		return
	super.reset_for_new_run()


func set_blood_for_playtest(value: float) -> void:
	if not has_active_aspect():
		blood = 0.0
		blood_art_resolving = false
		_emit_state()
		return
	super.set_blood_for_playtest(value)


func is_blood_unlocked() -> bool:
	return has_active_aspect() and super.is_blood_unlocked()


func is_blood_ready() -> bool:
	return has_active_aspect() and super.is_blood_ready()


func blood_state() -> String:
	if not has_active_aspect():
		return "unavailable"
	return super.blood_state()


func add_blood(amount: float, source: String = "combat") -> void:
	if not has_active_aspect():
		return
	super.add_blood(amount, source)


func commit_blood_art() -> bool:
	if not has_active_aspect():
		return false
	return super.commit_blood_art()


func transform_sword_contact(area: Area2D, target: Node, attacker: Node, event: Dictionary) -> Dictionary:
	if not has_active_aspect():
		return event.duplicate(true)
	return super.transform_sword_contact(area, target, attacker, event)


func record_sword_contact(target: Node, area: Area2D, attacker: Node, before_hp: float, before_posture: float) -> void:
	if not has_active_aspect():
		return
	super.record_sword_contact(target, area, attacker, before_hp, before_posture)


func _refresh_hud() -> void:
	if _hud != null:
		_hud.visible = has_active_aspect()
	if not has_active_aspect():
		if _hud_label != null:
			_hud_label.text = ""
		return
	super._refresh_hud()


func _on_returning_blood_awakened_changed(_awakened: bool) -> void:
	synchronize_campaign_state(true)
