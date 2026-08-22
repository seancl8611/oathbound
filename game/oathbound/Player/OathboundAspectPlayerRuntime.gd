extends "res://Player/OathboundAspectPlayer.gd"

## Final integration layer used by the inherited Aspect player scene.
## Owns compatibility adaptations that the imported 3-hit controller cannot express:
## Wolf's fourth Basic, Aspect metadata publication, and run-start Aspect state reset.

func _ready() -> void:
	# A new Player instance marks a new run. Keep the player's selected Aspect, but
	# start the run at Tier 0 with an empty/locked Blood meter as documented.
	if typeof(AspectRuntime) == TYPE_OBJECT:
		AspectRuntime.reset_for_new_run()
	super._ready()

func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	var authored_index := int(profile.get("aspect_combo_index", combo_idx))
	super._start_profile_attack(profile, authored_index)
	# LegacyPlayerController clamps to its imported MAX_COMBO_HITS=3. Restore the
	# authored Wolf index after legacy initialization so the fourth Basic remains real.
	_combo_index = authored_index

func _activate_current_attack_hitbox() -> void:
	super._activate_current_attack_hitbox()
	if sword_hitbox == null or _attack_profile.is_empty():
		return
	sword_hitbox.set_meta("action_trigger", str(_attack_profile.get("action_trigger", "")))
	sword_hitbox.set_meta("aspect_id", str(_attack_profile.get("aspect_id", AspectRuntime.selected_aspect)))
	sword_hitbox.set_meta("aspect_tier", int(_attack_profile.get("aspect_tier", AspectRuntime.tier)))
	sword_hitbox.set_meta("blood_generation", bool(_attack_profile.get("blood_generation", true)))
	sword_hitbox.set_meta("spectral_min_range", float(_attack_profile.get("spectral_min_range", 0.0)))
	sword_hitbox.set_meta("spectral_edge", bool(_attack_profile.get("spectral_edge", false)))
	sword_hitbox.set_meta("aspect_passage", bool(_attack_profile.get("aspect_passage", false)))
	sword_hitbox.set_meta("perfect_weight", bool(_attack_profile.get("perfect_weight", false)))
	sword_hitbox.set_meta("blood_tempo_continuation", bool(_attack_profile.get("blood_tempo_continuation", false)))

func _aspect_basic_count() -> int:
	return ASPECT_CATALOG.get_basic_profiles(AspectRuntime.selected_aspect, AspectRuntime.tier).size()

func _can_queue_next_combo_attack() -> bool:
	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _queued_attack_hold_branch or _combo_attack_queued:
		return false
	if _combo_index >= _aspect_basic_count() - 1:
		return false
	if _attack_profile.is_empty() or not bool(_attack_profile.get("can_combo", true)):
		return false
	var duration := float(_attack_profile.get("duration", 0.30))
	var queue_start := float(_attack_profile.get("queue_start", 0.40))
	var combo_end := float(_attack_profile.get("combo_end", 1.00))
	var progress := _attack_elapsed / maxf(duration, 0.001)
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	return false

func _begin_attack_branch_hold() -> void:
	if not bool(_attack_profile.get("can_combo", true)):
		return
	if _combo_index >= _aspect_basic_count() - 1:
		return
	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _combo_attack_queued:
		return
	_attack_branch_hold_active = true
	_attack_branch_hold_timer = 0.0

func _can_queue_sword_branch() -> bool:
	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _queued_attack_hold_branch or _combo_attack_queued:
		return false
	if _attack_profile.is_empty() or not bool(_attack_profile.get("can_combo", true)):
		return false
	var duration := float(_attack_profile.get("duration", 0.30))
	var queue_start := float(_attack_profile.get("queue_start", 0.40))
	var combo_end := float(_attack_profile.get("combo_end", 1.00))
	var progress := _attack_elapsed / maxf(duration, 0.001)
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	return false

func _queue_next_combo_attack() -> void:
	if not _can_queue_next_combo_attack():
		return
	var next_index := _combo_index + 1
	if next_index >= 3:
		# The imported recovery resolver rejects queued combo indices >=3. Queue the
		# fourth Wolf attack as an authored profile instead and carry its true index.
		var profile := _get_combo_profile(next_index).duplicate(true)
		profile["aspect_combo_index"] = next_index
		_queued_attack_profile = profile
		_queued_combo_index = -1
	else:
		_queued_combo_index = next_index
	_combo_attack_queued = true
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()
