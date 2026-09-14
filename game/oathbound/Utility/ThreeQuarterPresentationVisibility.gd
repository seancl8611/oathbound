extends Node2D

## Keeps authored three-quarter room dressing synchronized with the active CameraFollow
## presentation mode. This is intentionally presentation-only and safe to remove once
## the three-quarter direction no longer needs a legacy A/B toggle.

@export var background_path: NodePath = NodePath("../Background")
@export var active_background_modulate := Color(0.34, 0.29, 0.26, 1.0)

var _background: CanvasItem = null
var _background_base_modulate := Color.WHITE
var _last_active := false
var _initialized := false


func _ready() -> void:
	_background = get_node_or_null(background_path) as CanvasItem
	if _background != null:
		_background_base_modulate = _background.modulate
	_apply_mode(_is_three_quarter_active())


func _process(_dt: float) -> void:
	var active := _is_three_quarter_active()
	if not _initialized or active != _last_active:
		_apply_mode(active)


func _is_three_quarter_active() -> bool:
	var camera := get_viewport().get_camera_2d()
	if camera == null:
		# CameraFollow defaults to the adopted three-quarter profile. During room/player
		# construction the current camera may not exist for a frame, so avoid flashing the
		# new room dressing off while GameFlow finishes the hierarchy.
		return true
	if camera.has_method("is_three_quarter_enabled"):
		return bool(camera.call("is_three_quarter_enabled"))
	return false


func _apply_mode(active: bool) -> void:
	_initialized = true
	_last_active = active

	# Every CanvasItem child under this controller is three-quarter-only content. This
	# keeps scenery, combat VFX and future presentation layers on the same F9 A/B switch.
	for child: Node in get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = active
		if child.has_method("set_presentation_active"):
			child.call("set_presentation_active", active)

	if _background != null:
		_background.modulate = active_background_modulate if active else _background_base_modulate
