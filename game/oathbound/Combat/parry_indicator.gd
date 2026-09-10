extends Node2D

## Shared player-facing enemy attack cue.
##
## `warn_attack()` remains source-compatible with existing enemies, but the supplied
## legacy duration is translated by CounterCueTiming into seconds until the attack
## can first contact Akio. Presentation timing is then identical for every enemy:
##
## - 0.20 s before contact: fixed-size warning appears.
## - 0.12 s before contact: fixed-size inner commit mark appears. This matches the
##   canonical Player parry window.
## - contact/ACTIVE: cue disappears. There is no contact color flash or scale pulse.
##
## Normal and perilous attacks keep different static colors for classification only;
## color never communicates timing.

const CounterCueTimingScript = preload("res://Combat/CounterCueTiming.gd")

const NORMAL_COLOR := Color(1.0, 0.93, 0.62, 1.0)
const NORMAL_OUTLINE := Color(0.25, 0.20, 0.10, 0.95)
const PERILOUS_COLOR := Color(1.0, 0.20, 0.12, 1.0)
const PERILOUS_OUTLINE := Color(0.38, 0.04, 0.03, 0.98)

var _diamond: Polygon2D = null
var _outline: Polygon2D = null
var _ring: Line2D = null
var _commit_mark: Polygon2D = null

var _armed: bool = false
var _is_unblockable: bool = false
var _impact_times: Array[float] = []
var _impact_index: int = 0
var _warning_visible: bool = false
var _commit_visible: bool = false


func _ready() -> void:
	position = Vector2(0.0, -45.0)
	z_index = 150
	visible = false
	scale = Vector2.ONE
	_build_visuals()
	set_process(true)


func warn_attack(legacy_duration: float, is_unblockable: bool = false) -> void:
	_is_unblockable = is_unblockable
	_impact_times.clear()
	_impact_index = 0
	_warning_visible = false
	_commit_visible = false

	var owner := get_parent()
	var offsets: Array[float] = CounterCueTimingScript.resolve_impact_offsets(owner, legacy_duration)
	var now: float = Time.get_ticks_msec() * 0.001
	for offset: float in offsets:
		_impact_times.append(now + maxf(CounterCueTimingScript.MIN_OFFSET_SECONDS, offset))

	_armed = not _impact_times.is_empty()
	visible = false
	scale = Vector2.ONE
	_set_classification_colors()
	_set_commit_visible(false)
	_update_cue(now)


func hide_now() -> void:
	_clear_schedule()


func _process(_delta: float) -> void:
	if not _armed:
		return
	_update_cue(Time.get_ticks_msec() * 0.001)


func _update_cue(now: float) -> void:
	while _impact_index < _impact_times.size() and now >= _impact_times[_impact_index]:
		# The prompt's job is prediction. It disappears when the attack becomes live;
		# there is intentionally no ACTIVE/contact flash.
		visible = false
		_warning_visible = false
		_commit_visible = false
		_set_commit_visible(false)
		_impact_index += 1

	if _impact_index >= _impact_times.size():
		_clear_schedule()
		return

	var remaining: float = _impact_times[_impact_index] - now
	if remaining <= CounterCueTimingScript.WARNING_LEAD_SECONDS:
		if not _warning_visible:
			_show_warning()
		if remaining <= CounterCueTimingScript.PARRY_BEAT_LEAD_SECONDS and not _commit_visible:
			_show_commit_mark()
	else:
		visible = false
		_warning_visible = false
		_commit_visible = false
		_set_commit_visible(false)


func _show_warning() -> void:
	_warning_visible = true
	_commit_visible = false
	visible = true
	scale = Vector2.ONE
	_set_classification_colors()
	_set_commit_visible(false)


func _show_commit_mark() -> void:
	_commit_visible = true
	visible = true
	scale = Vector2.ONE
	# Timing is conveyed only by the appearance of this inner mark. The outer cue
	# does not resize and its normal/perilous classification color does not change.
	_set_commit_visible(true)


func _clear_schedule() -> void:
	_armed = false
	_impact_times.clear()
	_impact_index = 0
	_warning_visible = false
	_commit_visible = false
	visible = false
	scale = Vector2.ONE
	_set_commit_visible(false)


func _build_visuals() -> void:
	_outline = Polygon2D.new()
	_outline.polygon = _diamond_points(14.0)
	_outline.color = NORMAL_OUTLINE
	_outline.z_index = -1
	add_child(_outline)

	_diamond = Polygon2D.new()
	_diamond.polygon = _diamond_points(10.5)
	_diamond.color = NORMAL_COLOR
	add_child(_diamond)

	_ring = Line2D.new()
	_ring.width = 2.0
	_ring.default_color = NORMAL_COLOR
	var ring_points := PackedVector2Array()
	for i in range(17):
		var angle: float = TAU * float(i) / 16.0
		ring_points.append(Vector2(cos(angle), sin(angle)) * 18.0)
	_ring.points = ring_points
	_ring.z_index = -2
	add_child(_ring)

	# A small fixed center bar appears only for the final canonical parry beat.
	# It never scales or changes the classification color of the outer prompt.
	_commit_mark = Polygon2D.new()
	_commit_mark.polygon = PackedVector2Array([
		Vector2(-2.0, -7.0),
		Vector2(2.0, -7.0),
		Vector2(2.0, 7.0),
		Vector2(-2.0, 7.0),
	])
	_commit_mark.color = NORMAL_COLOR
	_commit_mark.visible = false
	_commit_mark.z_index = 1
	add_child(_commit_mark)


func _diamond_points(size: float) -> PackedVector2Array:
	return PackedVector2Array([
		Vector2(0.0, -size),
		Vector2(size * 0.62, 0.0),
		Vector2(0.0, size),
		Vector2(-size * 0.62, 0.0),
	])


func _set_classification_colors() -> void:
	var main_color: Color = PERILOUS_COLOR if _is_unblockable else NORMAL_COLOR
	var outline_color: Color = PERILOUS_OUTLINE if _is_unblockable else NORMAL_OUTLINE
	if _diamond != null:
		_diamond.color = main_color
	if _ring != null:
		_ring.default_color = main_color
	if _outline != null:
		_outline.color = outline_color
	if _commit_mark != null:
		_commit_mark.color = main_color


func _set_commit_visible(value: bool) -> void:
	if _commit_mark != null:
		_commit_mark.visible = value
