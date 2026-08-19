extends Node
class_name CombatController

## =============================================================================
## COMBAT CONTROLLER - v10.0 PROFESSIONAL RESPONSIVE COMBAT
## =============================================================================
## Research-driven enhancements:
## - Proper input buffering (attacks/dodge buffered, parry NOT buffered)
## - Combo chain tracking with link windows
## - Dynamic parry window with spam penalty
## - Deflect streak tracking for bonus damage
## - Sekiro-accurate posture recovery curves
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
# HOST STATE (fed each frame by player)
# =============================================================================
var _is_attacking = false
var _attack_cancel_ok = false
var _is_dodging = false
var _dodge_ready = true
var _is_blocking = false
var _health_ratio = 1.0

# =============================================================================
# PROSTHETIC SYSTEM
# =============================================================================
var _prosthetic_cooldown_until = -1.0
var _is_using_prosthetic = false

# =============================================================================
# INPUT BUFFER SYSTEM
# Research: 100-166ms buffer for attacks/dodge, 0 for parry
# =============================================================================
var _buf_time = {"attack": -1.0, "dodge": -1.0, "parry": -1.0, "prosthetic": -1.0}
var _buf_used = {"attack": false, "dodge": false, "parry": false, "prosthetic": false}

# =============================================================================
# COMBO SYSTEM
# =============================================================================
var _combo_index = 0  # Current hit in combo (0, 1, 2)
var _combo_window_open = false
var _combo_window_until = -1.0
var _last_attack_end_ts = -1.0

# =============================================================================
# PARRY ANTI-SPAM SYSTEM
# Research: Dynamic window that shrinks with spam
# =============================================================================
var _parry_miss_count = 0
var _parry_series_timer: Timer
var _last_parry_ts = -1.0
var _consecutive_deflects = 0

# =============================================================================
# POSTURE / DEATHBLOW
# =============================================================================
var _posture = 0.0
var _last_posture_hit_ts = -1.0
var _break_until_ts = -1.0
var _deathblow_target: Node = null
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
# INPUT REQUEST API (called by player on input)
# =============================================================================

func request_attack() -> void:
	"""Buffer an attack input. Will execute when able."""
	_buf_time["attack"] = _now_s()
	_buf_used["attack"] = false

func request_dodge() -> void:
	"""Buffer a dodge input. Will execute when able."""
	_buf_time["dodge"] = _now_s()
	_buf_used["dodge"] = false

func request_parry() -> void:
	"""Request parry - NOT BUFFERED per research (precision required)."""
	# Parry executes immediately if possible, no buffer
	_buf_time["parry"] = _now_s()
	_buf_used["parry"] = false


# =============================================================================
# HOST STATE UPDATE (called by player each frame)
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
	"""Called by player when attack reaches combo window point."""
	_combo_window_open = true
	_combo_window_until = _now_s() + duration

func close_combo_window() -> void:
	"""Close combo window (attack ended or window expired)."""
	_combo_window_open = false

func on_attack_ended() -> void:
	"""Called when attack animation finishes."""
	_last_attack_end_ts = _now_s()
	
	# Check if we have a buffered attack for combo continuation
	var link_window = config.combo_link_window if config else 0.35
	
	# Don't immediately close - allow link window
	if not _combo_window_open:
		_combo_window_open = true
		_combo_window_until = _now_s() + link_window

func reset_combo() -> void:
	"""Reset combo to first hit."""
	if _combo_index > 0:
		emit_signal("combo_finished")
	_combo_index = 0
	_combo_window_open = false
	_combo_window_until = -1.0

func drop_combo() -> void:
	"""Combo was interrupted/dropped."""
	if _combo_index > 0:
		emit_signal("combo_dropped")
	_combo_index = 0
	_combo_window_open = false

func get_combo_index() -> int:
	return _combo_index

func get_max_combo() -> int:
	return config.max_combo_hits if config else 3


# =============================================================================
# MAIN TICK (called by player each physics frame)
# =============================================================================

func tick(delta: float) -> void:
	var now = _now_s()
	
	# --- ATTACK INPUT PROCESSING ---
	if _want_attack():
		var can_attack = false
		var is_combo = false
		
		if not _is_attacking:
			# Not attacking - can start fresh attack
			can_attack = true
		elif _combo_window_open and _combo_index < get_max_combo() - 1:
			# In combo window - can continue combo
			can_attack = true
			is_combo = true
		elif _attack_cancel_ok:
			# In cancel window but not combo - restart combo
			can_attack = true
		
		if can_attack:
			_consume("attack")
			
			if is_combo:
				_combo_index += 1
				emit_signal("combo_continued", _combo_index)
			else:
				# Fresh attack or restart
				_combo_index = 0
			
			_combo_window_open = false
			emit_signal("attack_started", _combo_index)
	
	# --- DODGE INPUT PROCESSING ---
	if _want_dodge():
		if _dodge_ready and not _is_dodging:
			_consume("dodge")
			drop_combo()  # Dodging drops combo
			emit_signal("dodge_started")
	
	# --- PARRY INPUT PROCESSING (immediate, not buffered) ---
	if _want_parry():
		if (not _is_attacking or _attack_cancel_ok) and not _is_dodging:
			_consume("parry")
			drop_combo()  # Parrying drops combo
			
			var window = _effective_parry_window()
			var is_perfect = true  # First frames are always perfect window
			emit_signal("parry_opened", window, is_perfect)
			_parry_series_timer.start(_parry_decay_reset_sec())
	
	# --- PROSTHETIC INPUT PROCESSING ---
	if _want_prosthetic():
		if not _is_using_prosthetic and not _is_dodging and is_prosthetic_ready():
			_consume("prosthetic")
			drop_combo()
			emit_signal("prosthetic_started")
			
	# --- COMBO WINDOW EXPIRATION ---
	if _combo_window_open and now >= _combo_window_until:
		_combo_window_open = false
		# If no input came, combo ends
		if not _is_attacking:
			reset_combo()
	
	# --- POSTURE PASSIVE RECOVERY ---
	_posture_passive_recover(delta)
	
	# --- DEATHBLOW WINDOW EXPIRATION ---
	if _break_until_ts > 0.0 and now >= _break_until_ts:
		_break_until_ts = -1.0
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
	# Parry uses minimal/no buffer - precision required
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
	return config.input_buffer_ms if config else 133

func _get_dodge_buffer_ms() -> int:
	return config.dodge_buffer_ms if config else 100

func _get_parry_buffer_ms() -> int:
	# Research: Parry should NOT be buffered for skill expression
	# But we allow a tiny window (1-2 frames) for input latency
	return config.parry_buffer_ms if config else 33


# =============================================================================
# PARRY WINDOW SYSTEM
# Research: Dynamic window with spam penalty
# =============================================================================

func _parry_decay_steps() -> Array:
	# Each spam reduces window by ~2 frames (33ms)
	return [0.0, 0.033, 0.066, 0.10, 0.133]

func _parry_decay_reset_sec() -> float:
	return config.parry_spam_recovery if config else 0.5

func _parry_base_window() -> float:
	return config.parry_window_base if config else 0.20

func _parry_min_window() -> float:
	return config.parry_window_min if config else 0.067

func _effective_parry_window() -> float:
	var steps = _parry_decay_steps()
	var idx = clamp(_parry_miss_count, 0, steps.size() - 1)
	var penalty = steps[idx]
	var window = max(_parry_min_window(), _parry_base_window() - penalty)
	return window

func get_perfect_parry_window() -> float:
	return config.perfect_parry_window if config else 0.05


# =============================================================================
# PARRY RESULT NOTIFICATION
# =============================================================================

func notify_parry_result(success: bool) -> void:
	if success:
		_parry_miss_count = 0
		_consecutive_deflects += 1
		_parry_series_timer.start(_parry_decay_reset_sec())
	else:
		_parry_miss_count = min(_parry_miss_count + 1, _parry_decay_steps().size() - 1)
		_consecutive_deflects = 0

func get_deflect_streak() -> int:
	return _consecutive_deflects

func reset_deflect_streak() -> void:
	_consecutive_deflects = 0


# =============================================================================
# HIT NOTIFICATION (for posture suppression)
# =============================================================================

func notify_hit(event: Dictionary) -> void:
	# Called when player hits something (optional tracking)
	pass

func notify_got_hit(event: Dictionary) -> void:
	"""Called when player takes a hit - handles posture and suppression."""
	var base_hit_gain = config.hit_posture_gain if config else 12.0
	var parry_spike = config.parry_posture_spike if config else 40.0
	
	if event.has("parried") and event["parried"] == true:
		# Successful parry: Big posture spike on ENEMY + long suppression
		_recovery_suppressed_until = _now_s() + 1.0
		_add_posture(parry_spike)
	elif event.has("blocked") and event["blocked"] == true:
		# Blocked: Moderate suppression
		_recovery_suppressed_until = _now_s() + 0.5
		_add_posture(base_hit_gain * 0.6)
	else:
		# Raw hit: Standard suppression
		_recovery_suppressed_until = _now_s() + 0.6
		_add_posture(base_hit_gain)


# =============================================================================
# DEATHBLOW SYSTEM
# =============================================================================

func set_deathblow_target(target: Node, duration_s: float) -> void:
	if not config or not config.can_do_finisher:
		return
	_deathblow_target = target
	_break_until_ts = _now_s() + max(0.0, duration_s)
	emit_signal("deathblow_available", target, duration_s)

func is_deathblow_window() -> bool:
	return _break_until_ts > 0.0 and _now_s() < _break_until_ts

func get_deathblow_target() -> Node:
	return _deathblow_target


# =============================================================================
# POSTURE SYSTEM
# =============================================================================

func _add_posture(amount: float) -> void:
	if amount <= 0.0:
		return
	_last_posture_hit_ts = _now_s()
	
	var maxv = config.posture_max if config else 100.0
	_posture = min(maxv, _posture + amount)
	emit_signal("posture_changed", _posture, maxv)
	
	# Break check
	if _posture >= maxv:
		_posture = maxv
		emit_signal("posture_changed", _posture, maxv)
		var dur = config.posture_break_duration if config else 3.0
		_break_until_ts = _now_s() + dur
		emit_signal("posture_broken", dur)

func _posture_passive_recover(delta: float) -> void:
	var maxv = config.posture_max if config else 100.0
	if _posture <= 0.0:
		return
	
	var now = _now_s()
	
	# Sekiro rules: No recovery while blocking, attacking, suppressed, or broken
	if _is_blocking:
		return
	if _is_attacking:
		return
	if now < _recovery_suppressed_until:
		return
	if _break_until_ts > 0.0 and now < _break_until_ts:
		return
	
	# Delay after last posture hit
	var delay = config.posture_recover_delay if config else 2.0
	if _last_posture_hit_ts > 0.0 and (now - _last_posture_hit_ts) < delay:
		return
	
	var base_rate = config.posture_recover_rate if config else 10.0
	
	# HP-to-recovery curve (Sekiro-style)
	var hr = clamp(_health_ratio, 0.0, 1.0)
	var recovery_mult = 1.0
	
	if config and config.can_do_finisher:
		# Boss/miniboss curve - very strict at low HP
		if hr > 0.75:
			recovery_mult = 1.0
		elif hr > 0.50:
			recovery_mult = 0.25
		elif hr > 0.25:
			recovery_mult = 0.05
		else:
			recovery_mult = 0.01
	else:
		# Regular enemy curve
		recovery_mult = lerp(0.15, 1.0, hr)
	
	var rate = base_rate * recovery_mult
	# Ember stance: Intensity 3 burn slows posture recovery
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		rate *= se.get_burn_posture_recovery_mult(get_parent())
	_posture = max(0.0, _posture - rate * delta)
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
	_posture = clamp(value, 0.0, maxv)
	emit_signal("posture_changed", _posture, maxv)

func add_posture(amount: float) -> void:
	_add_posture(amount)

func reset_posture() -> void:
	_posture = 0.0
	var maxv = config.posture_max if config else 100.0
	emit_signal("posture_changed", _posture, maxv)

func reset_parry_decay() -> void:
	_parry_miss_count = 0

func suppress_recovery(duration: float) -> void:
	_recovery_suppressed_until = max(_recovery_suppressed_until, _now_s() + duration)

func get_recovery_state() -> String:
	var hr = _health_ratio
	if hr >= 0.75:
		return "normal"
	elif hr >= 0.50:
		return "reduced"
	elif hr >= 0.25:
		return "critical"
	else:
		return "stopped"


# =============================================================================
# CANCEL WINDOW HELPERS
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
