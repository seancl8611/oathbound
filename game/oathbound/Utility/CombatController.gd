extends Node
class_name CombatController

## =============================================================================
## COMBAT CONTROLLER - OATHBOUND SHARED COMBAT RUNTIME
## =============================================================================
## Compatibility-oriented runtime used by the existing Player/enemy scenes while the
## old prototype is reconciled with docs/gameplay/COMBAT_IMPLEMENTATION_BASELINE.md.
##
## Current shared rules:
## - 0.10 s action input buffer baseline; parry remains immediate.
## - Fixed parry window; no universal parry-spam window decay.
## - Health does not modify Posture recovery.
## - Posture recovery uses the host config's fixed delay/rate.
## - Posture break opens a timed window and resets to the configured ratio on expiry.
## - Canonical AttackEvent posture values override legacy per-damage-type scaling
##   while an imported enemy processes that same contact.
## =============================================================================

# =============================================================================
# SIGNALS
# =============================================================================
signal attack_started(combo_index: int)
signal attack_buffered()
signal dodge_started()
signal parry_opened(window_s: float, is_perfect_window: bool)
signal block_started()
signal block_ended()

signal posture_changed(current: float, max_value: float)
signal posture_broken(duration_s: float)
signal deathblow_available(target: Node, duration_s: float)
signal deathblow_cleared()

signal combo_continued(hit_index: int)
signal combo_finished()
signal combo_dropped()
signal prosthetic_started()

# =============================================================================
# CONFIGURATION
# =============================================================================
@export var config: CombatConfig

# =============================================================================
# HOST STATE (fed each frame by player/enemy host)
# =============================================================================
var _is_attacking = false
var _attack_cancel_ok = false
var _is_dodging = false
var _dodge_ready = true
var _is_blocking = false
# Retained for compatibility/telemetry only. It no longer affects Posture recovery.
var _health_ratio = 1.0

# =============================================================================
# CANONICAL ATTACK EVENT BRIDGE
# =============================================================================
# HurtBox opens this transaction only while the legacy receiver is processing the
# same collision. This lets old enemy code keep calling add_posture(amount) while the
# shared runtime uses the authored event value instead of old response-table scaling.
var _incoming_attack_event: Dictionary = {}
# Some later imported elites still only call notify_got_hit() and expect that call to
# consume hit Posture. Track whether the receiver already claimed this canonical event
# through add_posture()/set_posture() so the compatibility fallback can never become a
# second Posture pass.
var _incoming_attack_posture_applied: bool = false

# Receiver-authored Posture mutations and compatibility notifications are intentionally
# separate concepts. This serial lets notify_got_hit(parried=true) detect that an old
# enemy already applied its authored parry amount before sending the legacy notification.
var _receiver_posture_increase_serial: int = 0
var _receiver_posture_increase_serial_at_last_notify: int = 0

# =============================================================================
# PROSTHETIC SYSTEM
# =============================================================================
var _prosthetic_cooldown_until = -1.0
var _is_using_prosthetic = false

# =============================================================================
# INPUT BUFFER SYSTEM
# =============================================================================
var _buf_time = {"attack": -1.0, "dodge": -1.0, "parry": -1.0, "prosthetic": -1.0}
var _buf_used = {"attack": false, "dodge": false, "parry": false, "prosthetic": false}

# =============================================================================
# COMBO SYSTEM
# =============================================================================
var _combo_index = 0
var _combo_window_open = false
var _combo_window_until = -1.0
var _last_attack_end_ts = -1.0

# =============================================================================
# PARRY COMPATIBILITY STATE
# =============================================================================
# These counters remain because older UI/progression code may read them, but they do
# not shrink the universal parry window anymore.
var _parry_miss_count = 0
var _parry_series_timer: Timer
var _last_parry_ts = -1.0
var _consecutive_deflects = 0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
var _posture = 0.0
var _last_posture_hit_ts = -1.0
# Host's own Posture-break timer. This must never be reused for an external target.
var _break_until_ts = -1.0
var _deathblow_target: Node = null
# Independent timer for another actor that this CombatController may execute.
var _deathblow_until_ts = -1.0
var _recovery_suppressed_until = -1.0

# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	_parry_series_timer = Timer.new()
	_parry_series_timer.one_shot = true
	add_child(_parry_series_timer)
	_parry_series_timer.timeout.connect(_on_parry_series_timeout)

func _on_parry_series_timeout() -> void:
	_parry_miss_count = 0

func _now_s() -> float:
	return Time.get_ticks_msec() * 0.001


# =============================================================================
# CANONICAL ATTACK EVENT TRANSACTION
# =============================================================================

func begin_attack_event(event: Dictionary) -> void:
	_incoming_attack_event = event.duplicate(true)
	_incoming_attack_posture_applied = false

func end_attack_event() -> void:
	_incoming_attack_event.clear()
	_incoming_attack_posture_applied = false

func has_active_attack_event() -> bool:
	return not _incoming_attack_event.is_empty()

func get_active_attack_event() -> Dictionary:
	return _incoming_attack_event.duplicate(true)

func _resolve_authored_posture_amount(fallback: float) -> float:
	if _incoming_attack_event.is_empty():
		return fallback

	var host: Node = get_parent()
	var blocked: bool = _is_blocking
	if host and host.has_method("is_blocking"):
		blocked = bool(host.call("is_blocking"))

	var key: String = "block_posture_damage" if blocked else "posture_damage"
	return maxf(0.0, float(_incoming_attack_event.get(key, fallback)))


# =============================================================================
# INPUT REQUEST API
# =============================================================================

func request_attack() -> void:
	_buf_time["attack"] = _now_s()
	_buf_used["attack"] = false

func request_dodge() -> void:
	_buf_time["dodge"] = _now_s()
	_buf_used["dodge"] = false

func request_parry() -> void:
	# Precision action: no intentional gameplay buffer.
	_buf_time["parry"] = _now_s()
	_buf_used["parry"] = false


# =============================================================================
# HOST STATE UPDATE
# =============================================================================

func update_host_state(is_attacking: bool, attack_cancel_ok: bool, is_dodging: bool, dodge_ready: bool) -> void:
	_is_attacking = is_attacking
	_attack_cancel_ok = attack_cancel_ok
	_is_dodging = is_dodging
	_dodge_ready = dodge_ready

func start_block() -> void:
	if not _is_blocking:
		_is_blocking = true
		emit_signal("block_started")

func end_block() -> void:
	if _is_blocking:
		_is_blocking = false
		emit_signal("block_ended")

func is_blocking() -> bool:
	return _is_blocking

func update_health_ratio(current_hp: float, max_hp: float) -> void:
	if max_hp <= 0.0:
		_health_ratio = 1.0
	else:
		_health_ratio = clamp(current_hp / max_hp, 0.0, 1.0)


# =============================================================================
# COMBO SYSTEM API
# =============================================================================

func open_combo_window(duration: float) -> void:
	_combo_window_open = true
	_combo_window_until = _now_s() + duration

func close_combo_window() -> void:
	_combo_window_open = false

func on_attack_ended() -> void:
	_last_attack_end_ts = _now_s()
	var link_window = config.combo_link_window if config else 0.20
	if not _combo_window_open:
		_combo_window_open = true
		_combo_window_until = _now_s() + link_window

func reset_combo() -> void:
	if _combo_index > 0:
		emit_signal("combo_finished")
	_combo_index = 0
	_combo_window_open = false
	_combo_window_until = -1.0

func drop_combo() -> void:
	if _combo_index > 0:
		emit_signal("combo_dropped")
	_combo_index = 0
	_combo_window_open = false

func get_combo_index() -> int:
	return _combo_index

func get_max_combo() -> int:
	return config.max_combo_hits if config else 3


# =============================================================================
# MAIN TICK
# =============================================================================

func tick(delta: float) -> void:
	var now = _now_s()

	if _want_attack():
		var can_attack = false
		var is_combo = false

		if not _is_attacking:
			can_attack = true
		elif _combo_window_open and _combo_index < get_max_combo() - 1:
			can_attack = true
			is_combo = true
		elif _attack_cancel_ok:
			can_attack = true

		if can_attack:
			_consume("attack")
			if is_combo:
				_combo_index += 1
				emit_signal("combo_continued", _combo_index)
			else:
				_combo_index = 0
			_combo_window_open = false
			emit_signal("attack_started", _combo_index)

	if _want_dodge():
		if _dodge_ready and not _is_dodging:
			_consume("dodge")
			drop_combo()
			emit_signal("dodge_started")

	if _want_parry():
		if (not _is_attacking or _attack_cancel_ok) and not _is_dodging:
			_consume("parry")
			drop_combo()
			emit_signal("parry_opened", _effective_parry_window(), false)

	if _want_prosthetic():
		if not _is_using_prosthetic and not _is_dodging and is_prosthetic_ready():
			_consume("prosthetic")
			drop_combo()
			emit_signal("prosthetic_started")

	if _combo_window_open and now >= _combo_window_until:
		_combo_window_open = false
		if not _is_attacking:
			reset_combo()

	_posture_passive_recover(delta)

	# Host posture-break recovery and an external deathblow opportunity are separate
	# state machines. Expiring one must never mutate the other.
	if _break_until_ts > 0.0 and now >= _break_until_ts:
		_break_until_ts = -1.0
		_reset_posture_after_break()

	if _deathblow_until_ts > 0.0 and now >= _deathblow_until_ts:
		_deathblow_until_ts = -1.0
		_deathblow_target = null
		emit_signal("deathblow_cleared")


# =============================================================================
# INPUT BUFFER HELPERS
# =============================================================================

func _want_attack() -> bool:
	return _want("attack", _get_attack_buffer_ms())

func _want_dodge() -> bool:
	return _want("dodge", _get_dodge_buffer_ms())

func _want_parry() -> bool:
	return _want("parry", _get_parry_buffer_ms())

func _want(action: String, buffer_ms: int) -> bool:
	var ts = _buf_time.get(action, -1.0)
	if ts < 0:
		return false
	if _buf_used.get(action, false):
		return false
	return (_now_s() - ts) * 1000.0 <= buffer_ms

func _consume(action: String) -> void:
	_buf_used[action] = true

func _get_attack_buffer_ms() -> int:
	return config.input_buffer_ms if config else 100

func _get_dodge_buffer_ms() -> int:
	return config.dodge_buffer_ms if config else 100

func _get_parry_buffer_ms() -> int:
	return config.parry_buffer_ms if config else 0


# =============================================================================
# PARRY WINDOW SYSTEM
# =============================================================================

func _parry_decay_steps() -> Array:
	# Compatibility API: there is no universal window decay in the Oathbound baseline.
	return [0.0]

func _parry_decay_reset_sec() -> float:
	return config.parry_spam_recovery if config else 0.0

func _parry_base_window() -> float:
	return config.parry_window_base if config else 0.12

func _parry_min_window() -> float:
	return config.parry_window_min if config else 0.12

func _effective_parry_window() -> float:
	return max(_parry_min_window(), _parry_base_window())

func get_perfect_parry_window() -> float:
	# No separate universal perfect-parry tier. Kept for old callers.
	return 0.0


# =============================================================================
# PARRY RESULT NOTIFICATION
# =============================================================================

func notify_parry_result(success: bool) -> void:
	if success:
		_parry_miss_count = 0
		_consecutive_deflects += 1
	else:
		# Preserve telemetry without changing the active parry window.
		_parry_miss_count += 1
		_consecutive_deflects = 0

func get_deflect_streak() -> int:
	return _consecutive_deflects

func reset_deflect_streak() -> void:
	_consecutive_deflects = 0


# =============================================================================
# HIT NOTIFICATION
# =============================================================================

func notify_hit(_event: Dictionary) -> void:
	pass

func notify_got_hit(event: Dictionary) -> void:
	# A canonical HurtBox transaction may arrive at either a modern receiver that has
	# already called add_posture(), or an older Area 2/3 receiver that still expects this
	# notification to apply hit posture. Fill the latter gap only once, using the exact
	# authored AttackEvent value rather than the receiver's legacy damage scaling.
	_recovery_suppressed_until = _now_s() + (config.posture_recover_delay if config else 1.5)

	var parried: bool = bool(event.get("parried", false))
	var receiver_already_added_posture: bool = _receiver_posture_increase_serial != _receiver_posture_increase_serial_at_last_notify

	if parried:
		# Several imported elites manually set/add their authored parry posture and then
		# send this legacy notification. Only provide the generic compatibility spike if
		# there has been no receiver-authored increase since the preceding notification.
		if not receiver_already_added_posture:
			var parry_spike: float = config.parry_posture_spike if config else 25.0
			_add_posture(parry_spike)
	elif not _incoming_attack_event.is_empty() and not _incoming_attack_posture_applied:
		_incoming_attack_posture_applied = true
		var legacy_fallback: float = config.hit_posture_gain if config else 12.0
		var canonical_posture: float = _resolve_authored_posture_amount(legacy_fallback)
		_add_posture(canonical_posture)

	_receiver_posture_increase_serial_at_last_notify = _receiver_posture_increase_serial


# =============================================================================
# DEATHBLOW SYSTEM
# =============================================================================

func set_deathblow_target(target: Node, duration_s: float) -> void:
	if not config or not config.can_do_finisher:
		return
	_deathblow_target = target
	_deathblow_until_ts = _now_s() + max(0.0, duration_s)
	emit_signal("deathblow_available", target, duration_s)

func is_deathblow_window() -> bool:
	return _deathblow_until_ts > 0.0 and _now_s() < _deathblow_until_ts

func get_deathblow_target() -> Node:
	return _deathblow_target


# =============================================================================
# POSTURE SYSTEM
# =============================================================================

func _add_posture(amount: float) -> void:
	if amount <= 0.0:
		return
	if _break_until_ts > 0.0 and _now_s() < _break_until_ts:
		return

	_last_posture_hit_ts = _now_s()
	var maxv = config.posture_max if config else 100.0
	_posture = min(maxv, _posture + amount)
	emit_signal("posture_changed", _posture, maxv)

	if _posture >= maxv:
		_posture = maxv
		emit_signal("posture_changed", _posture, maxv)
		var dur = config.posture_break_duration if config else 2.5
		_break_until_ts = _now_s() + dur
		emit_signal("posture_broken", dur)

func _posture_passive_recover(delta: float) -> void:
	var maxv = config.posture_max if config else 100.0
	if _posture <= 0.0:
		return

	var now = _now_s()
	if _is_blocking:
		return
	if _is_attacking:
		return
	if now < _recovery_suppressed_until:
		return
	if _break_until_ts > 0.0 and now < _break_until_ts:
		return

	var delay = config.posture_recover_delay if config else 1.5
	if _last_posture_hit_ts > 0.0 and (now - _last_posture_hit_ts) < delay:
		return

	var rate = config.posture_recover_rate if config else 20.0
	_posture = max(0.0, _posture - rate * delta)
	emit_signal("posture_changed", _posture, maxv)

func _reset_posture_after_break() -> void:
	var maxv = config.posture_max if config else 100.0
	var reset_ratio = config.posture_break_reset_ratio if config else 0.50
	_posture = clamp(maxv * reset_ratio, 0.0, maxv)
	_last_posture_hit_ts = _now_s()
	emit_signal("posture_changed", _posture, maxv)


# =============================================================================
# POSTURE PUBLIC API
# =============================================================================

func get_posture() -> float:
	return _posture

func get_posture_ratio() -> float:
	var maxv = config.posture_max if config else 100.0
	if maxv <= 0.0:
		return 0.0
	return _posture / maxv

func set_posture(value: float) -> void:
	var maxv = config.posture_max if config else 100.0
	var before: float = _posture
	_posture = clamp(value, 0.0, maxv)
	if _posture > before + 0.001:
		_receiver_posture_increase_serial += 1
		if not _incoming_attack_event.is_empty():
			_incoming_attack_posture_applied = true
	emit_signal("posture_changed", _posture, maxv)

func add_posture(amount: float) -> void:
	# Public add_posture() means the receiver explicitly owns this posture mutation.
	# During a canonical contact, mark it consumed before resolving the authored amount
	# so notify_got_hit() cannot add a second copy later in the same transaction.
	if not _incoming_attack_event.is_empty():
		_incoming_attack_posture_applied = true
	var before: float = _posture
	_add_posture(_resolve_authored_posture_amount(amount))
	if _posture > before + 0.001:
		_receiver_posture_increase_serial += 1

func reset_posture() -> void:
	_posture = 0.0
	var maxv = config.posture_max if config else 100.0
	emit_signal("posture_changed", _posture, maxv)

func reset_parry_decay() -> void:
	_parry_miss_count = 0

func suppress_recovery(duration: float) -> void:
	_recovery_suppressed_until = max(_recovery_suppressed_until, _now_s() + duration)

func get_recovery_state() -> String:
	# Compatibility API for old UI. Health no longer changes recovery behavior.
	return "normal"


# =============================================================================
# CANCEL WINDOW / PROSTHETIC HELPERS
# =============================================================================

func set_attack_cancel_ok(v: bool) -> void:
	_attack_cancel_ok = v

func is_in_combo_window() -> bool:
	return _combo_window_open

func can_combo_continue() -> bool:
	return _combo_window_open and _combo_index < get_max_combo() - 1

func request_prosthetic() -> void:
	_buf_time["prosthetic"] = _now_s()
	_buf_used["prosthetic"] = false

func _want_prosthetic() -> bool:
	return _want("prosthetic", _get_attack_buffer_ms())

func is_prosthetic_ready() -> bool:
	return _now_s() >= _prosthetic_cooldown_until

func start_prosthetic_cooldown(duration: float) -> void:
	_prosthetic_cooldown_until = _now_s() + duration

func set_using_prosthetic(value: bool) -> void:
	_is_using_prosthetic = value

func is_using_prosthetic() -> bool:
	return _is_using_prosthetic
