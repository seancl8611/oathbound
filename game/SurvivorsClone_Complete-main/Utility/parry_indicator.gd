extends Node2D
class_name ParryIndicator

## =============================================================================
## PARRY INDICATOR - v4.0 EARLY WARNING SYSTEM
## =============================================================================
## 
## DESIGN PHILOSOPHY:
## This indicator does NOT tell you WHEN to parry.
## It tells you WHAT is coming so you can PREPARE.
##
## - Appears early in attack anticipation (not at parry window)
## - Stays visible through entire attack
## - WHITE = parryable/blockable (hold block, time deflect)
## - RED = unblockable (must dodge)
##
## Players learn TIMING through practice and enemy animations.
## The indicator provides AWARENESS of attack type.
##
## Usage:
##   indicator.warn_attack(duration, is_unblockable)
##   indicator.hide_now()
## =============================================================================

# =============================================================================
# CONFIGURATION
# =============================================================================
@export_group("Positioning")
@export var y_offset: float = -50.0
@export var position_offset: Vector2 = Vector2.ZERO

@export_group("Size")
@export var indicator_size: float = 11.0
@export var outline_thickness: float = 2.5

@export_group("Colors - Parryable")
## Bright white/cream - "you can handle this"
@export var parry_inner: Color = Color(1.0, 0.98, 0.95, 1.0)
@export var parry_outline: Color = Color(0.3, 0.25, 0.2, 0.95)

@export_group("Colors - Unblockable")  
## Warning red - "dodge this!"
@export var danger_inner: Color = Color(1.0, 0.2, 0.15, 1.0)
@export var danger_outline: Color = Color(0.5, 0.1, 0.1, 0.95)

@export_group("Animation")
@export var appear_scale: float = 1.6
@export var settle_speed: float = 16.0
@export var pulse_intensity: float = 0.08
@export var pulse_speed: float = 7.0

# =============================================================================
# STATE
# =============================================================================
var _root: Node2D
var _outline: Polygon2D
var _inner: Polygon2D

var _active: bool = false
var _unblockable: bool = false
var _expire_time: float = 0.0
var _start_time: float = 0.0
var _scale: float = 1.0

# =============================================================================
# SETUP
# =============================================================================
func _ready() -> void:
	_root = Node2D.new()
	_root.name = "Root"
	add_child(_root)
	
	var shape := _diamond_shape(indicator_size)
	var outline_shape := _diamond_shape(indicator_size + outline_thickness)
	
	_outline = Polygon2D.new()
	_outline.polygon = outline_shape
	_root.add_child(_outline)
	
	_inner = Polygon2D.new()
	_inner.polygon = shape
	_root.add_child(_inner)
	
	position = Vector2(0, y_offset) + position_offset
	_root.visible = false
	_set_colors(false)

func _diamond_shape(size: float) -> PackedVector2Array:
	var h := size
	var w := size * 0.6
	return PackedVector2Array([
		Vector2(0, -h),
		Vector2(w, 0),
		Vector2(0, h),
		Vector2(-w, 0)
	])

func _set_colors(unblockable: bool) -> void:
	if unblockable:
		_inner.color = danger_inner
		_outline.color = danger_outline
	else:
		_inner.color = parry_inner
		_outline.color = parry_outline

# =============================================================================
# PUBLIC API
# =============================================================================

func warn_attack(duration: float, unblockable: bool = false) -> void:
	"""
	Show early warning that an attack is coming.
	
	Call this at the START of enemy attack anticipation.
	Duration = full attack time (anticipation + active + linger)
	
	unblockable = false: White indicator, player can block/parry
	unblockable = true: Red indicator, player must dodge
	"""
	if duration <= 0.0:
		duration = 0.6
	
	var now := Time.get_ticks_msec() * 0.001
	_start_time = now
	_expire_time = now + duration
	_unblockable = unblockable
	_scale = appear_scale
	
	_set_colors(unblockable)
	_root.visible = true
	_root.scale = Vector2(_scale, _scale)
	_root.modulate.a = 1.0
	_active = true

func warn_parryable(duration: float) -> void:
	"""Convenience: white indicator for parryable attack."""
	warn_attack(duration, false)

func warn_unblockable(duration: float) -> void:
	"""Convenience: red indicator for unblockable attack."""
	warn_attack(duration, true)

func hide_now() -> void:
	"""Hide immediately - call on successful parry or when attack ends."""
	_root.visible = false
	_active = false

func is_active() -> bool:
	return _active

func is_showing_danger() -> bool:
	return _active and _unblockable

# =============================================================================
# UPDATE
# =============================================================================
func _process(delta: float) -> void:
	if not _active:
		return
	
	var now := Time.get_ticks_msec() * 0.001
	
	# Auto-expire
	if now >= _expire_time:
		hide_now()
		return
	
	# Settle the pop-in
	if _scale > 1.0:
		_scale = lerp(_scale, 1.0, delta * settle_speed)
		if _scale < 1.01:
			_scale = 1.0
	
	# Gentle pulse when settled
	var pulse := 1.0
	if _scale <= 1.0:
		var t := (now - _start_time) * pulse_speed * TAU
		pulse = 1.0 + sin(t) * pulse_intensity
	
	_root.scale = Vector2(_scale * pulse, _scale * pulse)

# =============================================================================
# LEGACY COMPATIBILITY
# =============================================================================
func telegraph_attack(duration: float) -> void:
	warn_parryable(duration)

func flash_parry(duration: float = 0.5) -> void:
	warn_parryable(duration)

func show_attack(_phase, unblockable: bool = false) -> void:
	warn_attack(0.6, unblockable)

func hide_indicator() -> void:
	hide_now()

func start_windup(unblockable: bool = false) -> void:
	warn_attack(0.8, unblockable)

func start_parry_window() -> void:
	pass

func start_active() -> void:
	pass

func end_attack() -> void:
	hide_now()

func set_phase(_p) -> void:
	pass

func is_showing() -> bool:
	return _active

# =============================================================================
# FACTORY
# =============================================================================
static func create_for_enemy(enemy: Node2D, y_off: float = -50.0) -> ParryIndicator:
	var ind := ParryIndicator.new()
	ind.y_offset = y_off
	ind.name = "ParryIndicator"
	enemy.add_child(ind)
	return ind
