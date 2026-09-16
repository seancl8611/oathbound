extends Resource
class_name DirectionalSpriteProfile

## Asset/runtime contract for a rig-rendered or hand-authored eight-direction actor.
##
## Gameplay never depends on this resource. It only describes how a fixed-canvas
## SpriteFrames set is registered to an authoritative Node2D actor.

const DIRECTIONS: Array[String] = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]

@export_category("Identity")
@export var profile_id: String = ""
@export var actor_role: String = "enemy"
@export var asset_ready: bool = false

@export_category("Runtime atlas")
@export var sprite_frames: SpriteFrames = null
@export var visual_scale_multiplier: float = 1.0
@export var visual_offset: Vector2 = Vector2.ZERO
@export var foot_anchor_px: Vector2 = Vector2(64.0, 112.0)
@export var frame_canvas_size: Vector2i = Vector2i(128, 128)
@export var enforce_frame_canvas_size: bool = true
@export var pixel_art: bool = true
@export var snap_actor_to_pixel_grid: bool = true
@export var default_fps: float = 12.0

@export_category("Animation contract")
@export var required_animation_bases: PackedStringArray = PackedStringArray(["idle", "move"])
@export var looping_animation_bases: PackedStringArray = PackedStringArray(["idle", "move"])
@export var authoritative_sample_states: PackedStringArray = PackedStringArray(["attack"])
@export var action_aliases: Dictionary = {}


func animation_candidates(state: String, action_id: String, direction: String) -> PackedStringArray:
	var result := PackedStringArray()
	var safe_direction := _safe_direction(direction)
	var base := animation_base_for(state, action_id)
	_append_unique(result, "%s_%s" % [base, safe_direction])

	# Action-specific attacks intentionally fall back to a generic directional attack
	# before idle. This lets an early rig test ship one attack set while later moves are
	# added without changing presentation code.
	var safe_state := _sanitize_token(state)
	if base != safe_state:
		_append_unique(result, "%s_%s" % [safe_state, safe_direction])
	_append_unique(result, "idle_%s" % safe_direction)
	_append_unique(result, "idle_s")
	return result


func animation_base_for(state: String, action_id: String = "") -> String:
	var safe_state := _sanitize_token(state)
	if safe_state == "attack" and not action_id.strip_edges().is_empty():
		return "attack_%s" % resolve_action_alias(action_id)
	return safe_state if not safe_state.is_empty() else "idle"


func resolve_action_alias(action_id: String) -> String:
	var raw := action_id.strip_edges().to_lower()
	var mapped: String = str(action_aliases.get(raw, raw))
	return _sanitize_token(mapped)


func should_authoritatively_sample(state: String) -> bool:
	return authoritative_sample_states.has(_sanitize_token(state))


func is_looping_animation_base(animation_base: String) -> bool:
	return looping_animation_bases.has(_sanitize_token(animation_base))


func expected_animation_names() -> PackedStringArray:
	var result := PackedStringArray()
	for animation_base: String in required_animation_bases:
		var safe_base := _sanitize_token(animation_base)
		if safe_base.is_empty():
			continue
		for direction: String in DIRECTIONS:
			result.append("%s_%s" % [safe_base, direction])
	return result


func animation_base_from_name(animation_name: String) -> String:
	for direction: String in DIRECTIONS:
		var suffix := "_%s" % direction
		if animation_name.ends_with(suffix):
			return animation_name.left(animation_name.length() - suffix.length())
	return animation_name


func validate_contract(require_assets: bool = false) -> PackedStringArray:
	var errors := PackedStringArray()
	if profile_id.strip_edges().is_empty():
		errors.append("profile_id is empty")
	if actor_role.strip_edges().is_empty():
		errors.append("actor_role is empty")
	if visual_scale_multiplier <= 0.0:
		errors.append("visual_scale_multiplier must be positive")
	if frame_canvas_size.x <= 0 or frame_canvas_size.y <= 0:
		errors.append("frame_canvas_size must be positive")
	if foot_anchor_px.x < 0.0 or foot_anchor_px.y < 0.0:
		errors.append("foot_anchor_px cannot be negative")
	if foot_anchor_px.x > float(frame_canvas_size.x) or foot_anchor_px.y > float(frame_canvas_size.y):
		errors.append("foot_anchor_px must remain inside frame_canvas_size")
	if default_fps <= 0.0:
		errors.append("default_fps must be positive")
	if required_animation_bases.is_empty():
		errors.append("required_animation_bases is empty")

	var must_validate_assets := require_assets or asset_ready
	if must_validate_assets and sprite_frames == null:
		errors.append("sprite_frames is required when asset_ready=true or assets are explicitly required")
		return errors
	if sprite_frames == null:
		return errors

	if must_validate_assets:
		for expected_name: String in expected_animation_names():
			var animation_name := StringName(expected_name)
			if not sprite_frames.has_animation(animation_name):
				errors.append("missing animation: %s" % expected_name)
				continue
			var frame_count := sprite_frames.get_frame_count(animation_name)
			if frame_count <= 0:
				errors.append("animation has no frames: %s" % expected_name)
				continue

			var animation_base := animation_base_from_name(expected_name)
			var should_loop := is_looping_animation_base(animation_base)
			if sprite_frames.get_animation_loop(animation_name) != should_loop:
				errors.append("loop flag mismatch: %s" % expected_name)

			if enforce_frame_canvas_size:
				for frame_index: int in range(frame_count):
					var texture := sprite_frames.get_frame_texture(animation_name, frame_index)
					if texture == null:
						errors.append("null texture: %s frame %d" % [expected_name, frame_index])
						continue
					var size := texture.get_size()
					var actual := Vector2i(roundi(size.x), roundi(size.y))
					if actual != frame_canvas_size:
						errors.append(
							"frame canvas mismatch: %s frame %d expected=%s actual=%s"
							% [expected_name, frame_index, str(frame_canvas_size), str(actual)]
						)
	return errors


func contract_summary() -> Dictionary:
	return {
		"profile_id": profile_id,
		"actor_role": actor_role,
		"asset_ready": asset_ready,
		"direction_count": DIRECTIONS.size(),
		"required_animation_count": expected_animation_names().size(),
		"pixel_art": pixel_art,
		"frame_canvas_size": frame_canvas_size,
		"foot_anchor_px": foot_anchor_px,
		"default_fps": default_fps,
	}


func _safe_direction(direction: String) -> String:
	var candidate := direction.strip_edges().to_lower()
	return candidate if candidate in DIRECTIONS else "s"


func _sanitize_token(value: String) -> String:
	var result := value.strip_edges().to_lower()
	for token: String in [" ", "-", "/", ":", "."]:
		result = result.replace(token, "_")
	while result.contains("__"):
		result = result.replace("__", "_")
	return result.trim_prefix("_").trim_suffix("_")


func _append_unique(target: PackedStringArray, value: String) -> void:
	if not target.has(value):
		target.append(value)
