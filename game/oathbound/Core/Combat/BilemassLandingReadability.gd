extends Node
class_name BilemassLandingReadability

## Presentation-only ground-hazard readability for Cellar Bilemass.
##
## The canonical Bilemass controller still owns target selection, hazard timing, puddle
## construction, DoT/slow, caps, and cleanup. This runtime observes the controller's
## existing `_pending_spit_indicator` once the spit has committed, hides that legacy
## single-texture marker, and mirrors the same target with a staged warning that remains
## alive through the ACTUAL remaining launch timeline:
##
##     spit_vomit_duration + spit_travel_time
##
## The marker is spatial hazard language only. It is never a parry/block/counter cue.

const STAGE_LIGHT: StringName = &"light"
const STAGE_MEDIUM: StringName = &"medium"
const STAGE_DARK: StringName = &"dark"

const LIGHT_ALPHA: float = 0.70
const MEDIUM_ALPHA: float = 0.86
const DARK_ALPHA: float = 1.00
const FAILSAFE_SECONDS: float = 0.20

var _active_indicator: Node2D = null
var _active_sprite: Sprite2D = null
var _active_stage: StringName = &""
var _warning_started_at: float = -1.0
var _landing_at: float = -1.0
var _warning_duration: float = 0.0
var _last_pending_id: int = 0


func _ready() -> void:
	set_process(true)


func _process(_delta: float) -> void:
	var source: Node = get_parent()
	if source == null or not is_instance_valid(source):
		_clear_active_indicator("source_missing")
		return

	_observe_new_pending_indicator(source)

	if _active_indicator == null or not is_instance_valid(_active_indicator):
		return

	var now: float = Time.get_ticks_msec() * 0.001
	var hazard_launched: bool = _read_bool(source, "_v2_hazard_launched", false)
	var attacking: bool = _read_bool(source, "beast_is_attacking", false)
	if not attacking and not hazard_launched and now < _landing_at:
		_clear_active_indicator("spit_cancelled")
		return

	_update_stage(now)
	if now >= _landing_at:
		_clear_active_indicator("landing_due")


func _observe_new_pending_indicator(source: Node) -> void:
	var pending_value: Variant = source.get("_pending_spit_indicator")
	if not (pending_value is Node2D):
		return
	var pending: Node2D = pending_value as Node2D
	if not is_instance_valid(pending) or not pending.is_inside_tree():
		return
	var pending_id: int = pending.get_instance_id()
	if pending_id == _last_pending_id:
		return

	_last_pending_id = pending_id
	_hide_legacy_indicator_visual(pending)
	_start_spatial_warning(source, pending.global_position)


func _start_spatial_warning(source: Node, target_position: Vector2) -> void:
	_clear_active_indicator("replaced")

	_warning_duration = expected_warning_duration(source)
	_warning_started_at = Time.get_ticks_msec() * 0.001
	_landing_at = _warning_started_at + _warning_duration

	var root := Node2D.new()
	root.name = "BilemassLandingWarning"
	root.global_position = target_position
	root.z_index = 140
	root.add_to_group("bilemass_landing_warning")
	root.set_meta("warning_started_at", _warning_started_at)
	root.set_meta("landing_at", _landing_at)
	root.set_meta("warning_duration", _warning_duration)
	root.set_meta("hazard_language", "ground_landing")
	root.set_meta("parry_prompt", false)

	var sprite := Sprite2D.new()
	sprite.name = "LandingStage"
	sprite.centered = true
	root.add_child(sprite)

	var scene: Node = get_tree().current_scene
	if scene == null:
		scene = get_tree().root
	scene.add_child(root)
	root.global_position = target_position

	_active_indicator = root
	_active_sprite = sprite
	_active_stage = &""
	_apply_stage(source, STAGE_LIGHT)

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("bilemass_landing_warning_armed", {
			"source_id": source.get_instance_id(),
			"source_name": source.name,
			"target": [target_position.x, target_position.y],
			"warning_started_at": _warning_started_at,
			"landing_at": _landing_at,
			"warning_duration": _warning_duration,
			"vomit_duration": _read_float(source, "spit_vomit_duration", 0.0),
			"travel_duration": _read_float(source, "spit_travel_time", 0.0),
			"parry_prompt": false,
		})


func _update_stage(now: float) -> void:
	if _warning_duration <= 0.0:
		return
	var elapsed: float = clampf(now - _warning_started_at, 0.0, _warning_duration)
	var progress: float = clampf(elapsed / _warning_duration, 0.0, 1.0)
	var stage: StringName = STAGE_LIGHT
	if progress >= (2.0 / 3.0):
		stage = STAGE_DARK
	elif progress >= (1.0 / 3.0):
		stage = STAGE_MEDIUM
	if stage == _active_stage:
		return
	var source: Node = get_parent()
	if source != null and is_instance_valid(source):
		_apply_stage(source, stage)


func _apply_stage(source: Node, stage: StringName) -> void:
	if _active_sprite == null or not is_instance_valid(_active_sprite):
		return

	var texture_property: String = "indicator_light_red"
	var alpha: float = LIGHT_ALPHA
	match stage:
		STAGE_MEDIUM:
			texture_property = "indicator_medium_red"
			alpha = MEDIUM_ALPHA
		STAGE_DARK:
			texture_property = "indicator_dark_red"
			alpha = DARK_ALPHA
		_:
			pass

	var texture_value: Variant = source.get(texture_property)
	_active_sprite.texture = texture_value as Texture2D if texture_value is Texture2D else null
	_active_sprite.modulate = Color(1.0, 1.0, 1.0, alpha)
	_scale_sprite_to_hazard(source)
	_active_stage = stage
	if _active_indicator != null and is_instance_valid(_active_indicator):
		_active_indicator.set_meta("stage", String(stage))

	if typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("bilemass_landing_warning_stage", {
			"source_id": source.get_instance_id(),
			"stage": String(stage),
			"landing_at": _landing_at,
			"remaining": maxf(0.0, _landing_at - Time.get_ticks_msec() * 0.001),
		})


func _scale_sprite_to_hazard(source: Node) -> void:
	if _active_sprite == null or _active_sprite.texture == null:
		return
	var radius: float = maxf(1.0, _read_float(source, "puddle_radius", 56.0))
	var size: Vector2 = _active_sprite.texture.get_size()
	if size.x <= 0.0 or size.y <= 0.0:
		return
	_active_sprite.scale = Vector2((radius * 2.0) / size.x, (radius * 2.0) / size.y)


func _hide_legacy_indicator_visual(pending: Node2D) -> void:
	for child: Node in pending.get_children():
		if child is CanvasItem:
			(child as CanvasItem).visible = false
	pending.set_meta("superseded_by_bilemass_landing_readability", true)


func expected_warning_duration(source: Node = null) -> float:
	var actor: Node = source if source != null else get_parent()
	if actor == null or not is_instance_valid(actor):
		return 0.01
	return maxf(
		0.01,
		_read_float(actor, "spit_vomit_duration", 0.0)
		+ _read_float(actor, "spit_travel_time", 0.0)
	)


func active_stage_name() -> String:
	return String(_active_stage)


func active_landing_at() -> float:
	return _landing_at


func active_warning_duration() -> float:
	return _warning_duration


func has_active_warning() -> bool:
	return _active_indicator != null and is_instance_valid(_active_indicator)


func active_indicator_for_test() -> Node2D:
	return _active_indicator


func _clear_active_indicator(reason: String) -> void:
	var had_indicator: bool = _active_indicator != null and is_instance_valid(_active_indicator)
	if had_indicator:
		_active_indicator.queue_free()
	_active_indicator = null
	_active_sprite = null
	_active_stage = &""
	if had_indicator and typeof(CombatTelemetry) == TYPE_OBJECT and CombatTelemetry.is_capturing():
		CombatTelemetry.record_event("bilemass_landing_warning_cleared", {
			"reason": reason,
			"landing_at": _landing_at,
		})
	if reason == "landing_due":
		# Keep the recorded deadline available for post-frame validation; the next warning
		# overwrites it. This runtime owns presentation only, never hazard spawning.
		return
	_warning_started_at = -1.0
	_landing_at = -1.0
	_warning_duration = 0.0


func _read_float(source: Node, property_name: String, fallback: float) -> float:
	var value: Variant = source.get(property_name)
	return float(value) if value != null else fallback


func _read_bool(source: Node, property_name: String, fallback: bool) -> bool:
	var value: Variant = source.get(property_name)
	return bool(value) if value != null else fallback


func _exit_tree() -> void:
	_clear_active_indicator("runtime_exit")
