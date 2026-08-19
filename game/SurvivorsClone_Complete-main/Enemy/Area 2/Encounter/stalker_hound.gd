extends BlightedHound
class_name StalkerHound

## =============================================================================
## STALKER HOUND - Area 2 elite Blighted Hound variant
## =============================================================================
## Design:
## - Mostly behaves like a stronger Blighted Hound.
## - Adds an occasional mist-stalk pounce.
## - The pounce is block-breaking / parry-preferred, but dodgeable.
## - Successful parry heavily punishes the hound.
## =============================================================================


# =============================================================================
# STALKER STATS
# =============================================================================
@export var stalker_hp: int = 85
@export var stalker_movement_speed: float = 92.0
@export var stalker_lunge_speed: float = 285.0
@export var stalker_experience: int = 3
@export var stalker_max_posture: float = 120.0


# =============================================================================
# MIST POUNCE TUNING
# =============================================================================
@export var mist_pounce_damage: int = 12
@export var mist_pounce_block_posture: float = 30.0

@export var mist_pounce_cd: float = 8.0
@export var mist_pounce_first_delay: float = 2.5

@export var mist_pounce_min_range: float = 55.0
@export var mist_pounce_max_range: float = 280.0

@export var mist_pounce_windup: float = 0.85
@export var mist_pounce_reveal_time: float = 0.32
@export var mist_pounce_active_time: float = 0.26
@export var mist_pounce_end_lag: float = 0.18

@export var mist_pounce_speed: float = 420.0
@export var mist_pounce_hitbox_size: Vector2 = Vector2(44, 30)

@export var mist_reposition_distance: float = 125.0
@export var mist_reposition_side_bias: float = 0.75
@export var mist_backout_speed: float = 95.0
@export var mist_room_margin: float = 24.0

@export var mist_pounce_parry_posture_gain: float = 70.0
@export var mist_pounce_parry_recoil_time: float = 0.95
@export var mist_pounce_parry_knockback_force: float = 135.0

@export var debug_mist_pounce: bool = false


# =============================================================================
# RUNTIME
# =============================================================================
var _next_mist_pounce_ready: float = 0.0
var _mist_pounce_active: bool = false
var _mist_reposition_done: bool = false
var _mist_reappear_pos: Vector2 = Vector2.ZERO
var _mist_original_sprite_modulate: Color = Color.WHITE


# =============================================================================
# INITIALIZATION
# =============================================================================
func _apply_hound_defaults() -> void:
	# Apply Blighted Hound defaults first, then upgrade into the Area 2 variant.
	super._apply_hound_defaults()

	hp = stalker_hp

	# EnemyBase uses _max_hp, not max_hp.
	# This keeps health-ratio logic accurate without requiring base-script changes.
	_max_hp = stalker_hp

	movement_speed = stalker_movement_speed
	lunge_speed = stalker_lunge_speed
	experience = stalker_experience

	max_posture = stalker_max_posture


func _ready() -> void:
	super._ready()

	var now := Time.get_ticks_msec() * 0.001
	_next_mist_pounce_ready = now + mist_pounce_first_delay

	if sprite:
		_mist_original_sprite_modulate = sprite.modulate

	print("[StalkerHound] v1.2 - Area 2 hound variant active")


# =============================================================================
# CHASE OVERRIDE
# =============================================================================
func _state_chase(delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(State.PATROL)
		return

	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()

	if _try_start_mist_pounce(now, dist):
		return

	# If the special attack does not start, behave exactly like a Blighted Hound.
	super._state_chase(delta, now)


# =============================================================================
# ORBIT OVERRIDE
# =============================================================================
func _state_orbit(delta: float, now: float) -> void:
	if not is_instance_valid(player):
		_goto(State.PATROL)
		return

	var to_player: Vector2 = player.global_position - global_position
	var dist: float = to_player.length()

	if _try_start_mist_pounce(now, dist):
		return

	super._state_orbit(delta, now)


# =============================================================================
# MIST POUNCE GATE
# =============================================================================
func _try_start_mist_pounce(now: float, dist: float) -> bool:
	if not _can_start_mist_pounce(now, dist):
		return false

	if not _request_attack_token():
		if debug_mist_pounce:
			print("[StalkerHound] Mist pounce blocked: no attack token")
		return false

	if not _request_lunge_role():
		if debug_mist_pounce:
			print("[StalkerHound] Mist pounce blocked: no dog_lunge role")
		_release_attack_token()
		return false

	if debug_mist_pounce:
		print("[StalkerHound] Starting mist pounce | state=", state, " dist=", snapped(dist, 0.1))

	_start_mist_pounce_windup(now)
	return true


func _can_start_mist_pounce(now: float, dist: float) -> bool:
	if _mist_pounce_active:
		return false

	if now < _next_mist_pounce_ready:
		return false

	if not is_instance_valid(player):
		return false

	if _player_hidden_in_smoke():
		return false

	# Allow the special from normal chase/orbit behavior.
	# Do not require CHASE only, because the parent hound often enters ORBIT.
	if state != State.CHASE and state != State.ORBIT:
		return false

	if dist < mist_pounce_min_range:
		if debug_mist_pounce:
			print("[StalkerHound] Mist pounce blocked: too close dist=", snapped(dist, 0.1))
		return false

	if dist > mist_pounce_max_range:
		if debug_mist_pounce:
			print("[StalkerHound] Mist pounce blocked: too far dist=", snapped(dist, 0.1))
		return false

	return true


# =============================================================================
# MIST POUNCE
# =============================================================================
func _start_mist_pounce_windup(now: float) -> void:
	if debug_mist_pounce:
		print("[StalkerHound] Mist windup started")

	_release_role("advance_move")
	_bump_attack_gen()

	_mist_pounce_active = true
	_mist_reposition_done = false

	if is_instance_valid(player):
		_charge_dir = (player.global_position - global_position).normalized()
	else:
		_charge_dir = Vector2.RIGHT

	_mist_reappear_pos = _pick_mist_reappear_position()

	# Give the player a readable warning window.
	_show_parry_indicator(mist_pounce_windup + mist_pounce_active_time + mist_pounce_end_lag, false)

	_goto(State.LUNGE_WINDUP, mist_pounce_windup)


func _pick_mist_reappear_position() -> Vector2:
	if not is_instance_valid(player):
		return global_position

	var from_hound := global_position - player.global_position
	var base_dir := from_hound.normalized()

	if base_dir == Vector2.ZERO:
		base_dir = Vector2.RIGHT

	# Pick a flank angle instead of directly behind the player every time.
	var side := 1.0 if randf() > 0.5 else -1.0
	var flank_dir := base_dir.rotated(side * PI * 0.5 * mist_reposition_side_bias).normalized()
	var candidate := player.global_position + flank_dir * mist_reposition_distance

	return _clamp_to_active_combat_bounds(candidate)


func _clamp_to_active_combat_bounds(candidate: Vector2) -> Vector2:
	# CombatRoom is added to the "room" group by GameFlow. Its RoomBounds already
	# defines the legal spawn/camera rectangle, so reuse that authority for
	# teleport-like repositioning rather than allowing a direct global-position
	# write to escape the room.
	var room: Node = get_tree().get_first_node_in_group("room")
	if room == null:
		return candidate

	var bounds: Node = room.get_node_or_null("RoomBounds")
	if bounds == null or not bounds.has_method("get_rect_global"):
		return candidate

	var rect: Rect2 = bounds.call("get_rect_global")
	var max_margin := min(rect.size.x, rect.size.y) * 0.25
	var margin := clamp(mist_room_margin, 0.0, max_margin)
	var safe_rect := rect.grow(-margin)
	if safe_rect.size.x <= 0.0 or safe_rect.size.y <= 0.0:
		safe_rect = rect

	return Vector2(
		clamp(candidate.x, safe_rect.position.x, safe_rect.end.x),
		clamp(candidate.y, safe_rect.position.y, safe_rect.end.y)
	)


func _state_lunge_windup(delta: float, now: float) -> void:
	if not _mist_pounce_active:
		super._state_lunge_windup(delta, now)
		return

	# Phase 1: back away and fade slightly.
	if not _mist_reposition_done and _state_timer > mist_pounce_reveal_time:
		velocity = -_charge_dir * mist_backout_speed

		if sprite:
			sprite.modulate = Color(
				_mist_original_sprite_modulate.r,
				_mist_original_sprite_modulate.g,
				_mist_original_sprite_modulate.b,
				0.45
			)

		return

	# Phase 2: reappear at the flank angle.
	if not _mist_reposition_done:
		global_position = _mist_reappear_pos
		_mist_reposition_done = true

		if is_instance_valid(player):
			_charge_dir = (player.global_position - global_position).normalized()

		if sprite:
			sprite.modulate = _mist_original_sprite_modulate

		velocity = Vector2.ZERO
		return

	# Phase 3: visible crouch/coil before the leap.
	velocity = Vector2.ZERO

	if is_instance_valid(player) and _state_timer > 0.12:
		_charge_dir = (player.global_position - global_position).normalized()

	if _state_timer <= 0:
		_execute_mist_pounce(now)


func _execute_mist_pounce(now: float) -> void:
	if debug_mist_pounce:
		print("[StalkerHound] Mist pounce executed")

	var gen := _bump_attack_gen()

	_goto(State.LUNGE, mist_pounce_active_time + mist_pounce_end_lag)

	_arm_hitbox(mist_pounce_damage, mist_pounce_hitbox_size, mist_pounce_block_posture, true)
	_apply_mist_pounce_hitbox_meta()

	get_tree().create_timer(mist_pounce_active_time).timeout.connect(func():
		if gen != _attack_gen:
			return
		_set_hitbox_active(false)
	)


func _apply_mist_pounce_hitbox_meta() -> void:
	if not hitbox:
		return

	# Your player.gd already treats "perilous" as parryable but not blockable.
	# This gives the exact behavior we want:
	# - parry works
	# - block fails
	# - dodge still works naturally by avoiding the hitbox
	hitbox.set_meta("attack_id", "stalker_mist_pounce")
	hitbox.set_meta("damage_type", "perilous")
	hitbox.set_meta("parry_only", true)
	hitbox.set_meta("blockable", false)

	# Important: do NOT set unblockable = true here.
	# In your player.gd, unblockable attacks cannot be parried.
	if hitbox.has_meta("unblockable"):
		hitbox.remove_meta("unblockable")


func _clear_mist_pounce_hitbox_meta() -> void:
	if not hitbox:
		return

	if hitbox.has_meta("attack_id"):
		hitbox.remove_meta("attack_id")
	if hitbox.has_meta("parry_only"):
		hitbox.remove_meta("parry_only")
	if hitbox.has_meta("blockable"):
		hitbox.remove_meta("blockable")
	if hitbox.has_meta("unblockable"):
		hitbox.remove_meta("unblockable")

	# Reset to the normal hound damage type so future bite/lunge attacks
	# do not accidentally inherit the pounce behavior.
	hitbox.set_meta("damage_type", "melee")


func _state_lunge(delta: float, now: float) -> void:
	if not _mist_pounce_active:
		super._state_lunge(delta, now)
		return

	velocity = _charge_dir * mist_pounce_speed

	if _state_timer <= 0:
		_finish_mist_pounce(now)


func _finish_mist_pounce(now: float) -> void:
	if debug_mist_pounce:
		print("[StalkerHound] Mist pounce finished")

	_hide_parry_indicator()
	_disarm_hitbox()
	_clear_mist_pounce_hitbox_meta()

	_release_role(beast_attack_role)
	_release_attack_token()

	_mist_pounce_active = false
	_mist_reposition_done = false

	if sprite:
		sprite.modulate = _mist_original_sprite_modulate

	_next_mist_pounce_ready = now + mist_pounce_cd
	_next_lunge_ready = max(_next_lunge_ready, now + 1.2)
	_next_attack_ready = now + attack_cd

	_goto(State.RECOVER, recover_time)


# =============================================================================
# PARRY OVERRIDE
# =============================================================================
func on_parried(parrier_pos: Vector2) -> void:
	if not _mist_pounce_active:
		super.on_parried(parrier_pos)
		return

	var old_parry_posture := parry_posture_gain
	var old_recoil_time := parry_recoil_time
	var old_knockback_force := parry_knockback_force

	parry_posture_gain = mist_pounce_parry_posture_gain
	parry_recoil_time = mist_pounce_parry_recoil_time
	parry_knockback_force = mist_pounce_parry_knockback_force

	super.on_parried(parrier_pos)

	parry_posture_gain = old_parry_posture
	parry_recoil_time = old_recoil_time
	parry_knockback_force = old_knockback_force

	_mist_pounce_active = false
	_mist_reposition_done = false

	var now := Time.get_ticks_msec() * 0.001
	_next_mist_pounce_ready = now + mist_pounce_cd

	_clear_mist_pounce_hitbox_meta()

	if sprite:
		sprite.modulate = _mist_original_sprite_modulate


# =============================================================================
# CLEANUP
# =============================================================================
func _cancel_current_attack(now: float, because_revoked: bool = false) -> void:
	_mist_pounce_active = false
	_mist_reposition_done = false

	_clear_mist_pounce_hitbox_meta()

	if sprite:
		sprite.modulate = _mist_original_sprite_modulate

	super._cancel_current_attack(now, because_revoked)


func death() -> void:
	_mist_pounce_active = false
	_mist_reposition_done = false

	_clear_mist_pounce_hitbox_meta()

	if sprite:
		sprite.modulate = _mist_original_sprite_modulate

	super.death()
