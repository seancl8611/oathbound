extends "res://Player/OathboundCombatPlayer.gd"

## Area 1 player-paced pressure-string adapter.
##
## The canonical imported controller still owns input resolution, hitboxes, AttackEvent
## delivery, dash/parry cancellation, hold-Thrust branching, and recovery timing. This
## layer changes only the pre-awakening base-katana *continuation boundary*: the first
## Heavy Cleave is a midpoint punctuation that may flow into a second Quick/Cross/Heavy
## phrase. The second Heavy remains the natural endpoint.
##
## Target clean string: 9 -> 12 -> 21 -> 9 -> 12 -> 21 = 84 Health damage.

const AREA1_PRESSURE_MAX_HITS: int = 6
const AREA1_PRESSURE_MIDPOINT_HIT: int = 3
const BASE_KATANA_IDS: Array[String] = ["quick_slash", "cross_cut", "heavy_cleave"]

var _area1_pressure_hits_started: int = 0
var _area1_pressure_active: bool = false


func _ready() -> void:
	super._ready()
	print("[OathboundPlayer] v2.2 - Area 1 six-hit player-paced pressure string")


func _start_profile_attack(profile: Dictionary, combo_idx: int = 0) -> void:
	var resolved: Dictionary = profile
	var id: String = str(profile.get("id", ""))
	var base_katana_basic: bool = _area1_pressure_enabled() and id in BASE_KATANA_IDS

	if base_katana_basic:
		# A neutral Quick Slash begins a new pressure commitment. A Quick Slash launched
		# directly from ATTACK_RECOVERY after the midpoint Heavy is the second phrase and
		# therefore keeps the existing hit count.
		var continuing_second_phrase: bool = (
			_area1_pressure_active
			and combo_idx == 0
			and _state == State.ATTACK_RECOVERY
			and _area1_pressure_hits_started == AREA1_PRESSURE_MIDPOINT_HIT
		)
		if combo_idx == 0 and not continuing_second_phrase:
			_area1_reset_pressure_string()
			_area1_pressure_active = true
		elif not _area1_pressure_active:
			_area1_pressure_active = true

		_area1_pressure_hits_started = mini(AREA1_PRESSURE_MAX_HITS, _area1_pressure_hits_started + 1)

		# The first Heavy is no longer a mandatory neutral reset. Mark only this instance
		# combo-capable so the inherited tap-vs-hold branch machinery can queue Quick #4
		# or preserve the existing held-Thrust option. The second Heavy keeps canonical
		# can_combo=false behavior and final restart lockout.
		if id == "heavy_cleave" and _area1_pressure_hits_started == AREA1_PRESSURE_MIDPOINT_HIT:
			resolved = profile.duplicate(true)
			resolved["can_combo"] = true
			resolved["area1_pressure_midpoint"] = true
			# Give the midpoint Heavy a real late queue window while keeping its authored
			# startup/active/recovery and heavy locomotion profile unchanged.
			resolved["queue_start"] = 0.70
			resolved["combo_start"] = 0.72
			resolved["combo_end"] = 1.00
			resolved["restart_lockout"] = 0.0

	super._start_profile_attack(resolved, combo_idx)

	if base_katana_basic and typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_area1_pressure_swing", {
			"hit_number": _area1_pressure_hits_started,
			"attack_id": id,
			"combo_index": combo_idx,
			"midpoint": bool(resolved.get("area1_pressure_midpoint", false)),
			"max_hits": AREA1_PRESSURE_MAX_HITS,
		})


func _begin_attack_branch_hold() -> void:
	if _area1_is_midpoint_heavy():
		if _queued_combo_index != -1:
			return
		if not _queued_attack_profile.is_empty():
			return
		if _combo_attack_queued:
			return
		_attack_branch_hold_active = true
		_attack_branch_hold_timer = 0.0
		return
	super._begin_attack_branch_hold()


func _can_queue_next_combo_attack() -> bool:
	# The imported controller treats combo index 2 as an absolute endpoint. For the
	# pre-awakening Area 1 pressure string only, the *first* Heavy is instead the
	# phrase boundary and therefore uses the same authored queue window below.
	if _area1_is_midpoint_heavy():
		return _can_queue_sword_branch()
	return super._can_queue_next_combo_attack()


func _can_queue_sword_branch() -> bool:
	if not _area1_is_midpoint_heavy():
		return super._can_queue_sword_branch()

	if _queued_combo_index != -1:
		return false
	if not _queued_attack_profile.is_empty():
		return false
	if _queued_attack_hold_branch or _combo_attack_queued:
		return false
	if _attack_profile.is_empty() or not bool(_attack_profile.get("can_combo", false)):
		return false

	var duration: float = float(_attack_profile.get("duration", 0.30))
	var queue_start: float = float(_attack_profile.get("queue_start", 0.70))
	var combo_end: float = float(_attack_profile.get("combo_end", 1.00))
	var progress: float = _attack_elapsed / maxf(duration, 0.001)
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	return false


func _queue_next_combo_attack() -> void:
	if not _area1_is_midpoint_heavy():
		super._queue_next_combo_attack()
		return

	if _queued_combo_index != -1 or not _queued_attack_profile.is_empty() or _queued_attack_hold_branch or _combo_attack_queued:
		return

	# Wrap the logical six-hit pressure string from Heavy #3 back to Quick #4. The
	# inherited recovery resolver already knows how to launch queued combo index 0.
	_queued_combo_index = 0
	_combo_attack_queued = true
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("player_area1_pressure_phrase_queued", {
			"completed_hits": _area1_pressure_hits_started,
			"next_combo_index": 0,
		})


func _state_attack_recovery(delta: float) -> void:
	super._state_attack_recovery(delta)
	# When the second Heavy completes normally, close the six-hit commitment. If the
	# player stopped after hit five, the inherited combo grace eventually returns the
	# next neutral Quick to a fresh commitment through _start_profile_attack().
	if _area1_pressure_hits_started >= AREA1_PRESSURE_MAX_HITS and _state not in [State.ATTACKING, State.ATTACK_RECOVERY]:
		_area1_reset_pressure_string()


func _drop_combo() -> void:
	_area1_reset_pressure_string()
	super._drop_combo()


func _area1_pressure_enabled() -> bool:
	return typeof(AspectRuntime) == TYPE_OBJECT and str(AspectRuntime.selected_aspect).is_empty()


func _area1_is_midpoint_heavy() -> bool:
	return (
		_area1_pressure_enabled()
		and _area1_pressure_active
		and _area1_pressure_hits_started == AREA1_PRESSURE_MIDPOINT_HIT
		and _combo_index == 2
		and str(_attack_profile.get("id", "")) == "heavy_cleave"
		and bool(_attack_profile.get("area1_pressure_midpoint", false))
	)


func _area1_reset_pressure_string() -> void:
	_area1_pressure_hits_started = 0
	_area1_pressure_active = false


func get_area1_pressure_snapshot() -> Dictionary:
	return {
		"enabled": _area1_pressure_enabled(),
		"active": _area1_pressure_active,
		"hits_started": _area1_pressure_hits_started,
		"max_hits": AREA1_PRESSURE_MAX_HITS,
		"midpoint_can_continue": _area1_is_midpoint_heavy(),
	}


static func area1_pressure_damage_target() -> Array[int]:
	return [9, 12, 21, 9, 12, 21]


static func area1_pressure_total_damage_target() -> int:
	var total: int = 0
	for damage: int in area1_pressure_damage_target():
		total += damage
	return total
