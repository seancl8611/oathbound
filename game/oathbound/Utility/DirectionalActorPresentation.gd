extends Node2D

## Presentation-only adapter for Oathbound's planar actors.
##
## The authoritative CharacterBody2D/Node2D still owns movement, hitboxes, Health, Poise,
## attack timing and AI. This node turns that state into an eight-direction 2D visual.
## A DirectionalSpriteProfile can point at hand-drawn frames or offline 3D-rig renders;
## the gameplay actor never needs to know how its body art was produced.
##
## Baseline naming:
##   <state>_<direction>              e.g. idle_s, move_ne, hurt_se
##   attack_<action_id>_<direction>  e.g. attack_quick_slash_w
## Directions: e, se, s, sw, w, nw, n, ne.

const PROFILE_SCRIPT = preload("res://Presentation/DirectionalSpriteProfile.gd")
const LEGACY_VISIBLE_META := &"_oathbound_directional2d_base_visible"
const KEEP_WITH_REPLACEMENT_META := &"oathbound_keep_with_replacement_visual"
const DIRECTIONS: Array[String] = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]
const VALID_STATES: Array[String] = ["idle", "move", "dash", "attack", "defend", "hurt", "death"]

@export var visual_scale: float = 1.0
@export var ground_compression: float = 0.72
@export var use_placeholder_when_atlas_missing: bool = true

var source_actor: Node2D = null
var actor_role: String = "enemy"
var _base_visual_scale: float = 1.0
var _facing := Vector2(0.0, 1.0)
var _direction_name := "s"
var _semantic_state := "idle"
var _action_id := ""
var _action_phase := "IDLE"
var _authoritative_progress: float = -1.0
var _last_draw_signature := ""
var _resolved_animation_name := ""
var _authoritative_sampled := false
var _sampled_frame := -1
var _sprite: AnimatedSprite2D = null
var _sprite_frames: SpriteFrames = null
var _profile: Resource = null


func _ready() -> void:
	set_meta(KEEP_WITH_REPLACEMENT_META, true)
	_sprite = AnimatedSprite2D.new()
	_sprite.name = "DirectionalSprite"
	_sprite.centered = false
	_sprite.position = Vector2.ZERO
	_sprite.flip_h = false
	_sprite.set_meta(KEEP_WITH_REPLACEMENT_META, true)
	add_child(_sprite)
	_apply_profile_settings()
	_apply_counter_projection()
	queue_redraw()


func _exit_tree() -> void:
	_restore_legacy_body()


func configure(actor: Node2D, role: String, scale_factor: float, compression: float) -> void:
	source_actor = actor
	actor_role = role.strip_edges().to_lower()
	_base_visual_scale = maxf(0.05, scale_factor)
	ground_compression = clampf(compression, 0.35, 1.0)
	_apply_profile_settings()
	_apply_counter_projection()
	_sync_from_source(0.0)


func set_profile(profile: Resource) -> void:
	_profile = profile
	if _profile != null:
		var role_value: Variant = _profile.get("actor_role")
		if role_value != null and not str(role_value).strip_edges().is_empty():
			actor_role = str(role_value).strip_edges().to_lower()
		var frames_value: Variant = _profile.get("sprite_frames")
		_sprite_frames = frames_value as SpriteFrames if frames_value is SpriteFrames else null
	_apply_profile_settings()
	_apply_counter_projection()
	_sync_atlas_animation(true)
	queue_redraw()


func get_profile() -> Resource:
	return _profile


func set_sprite_frames(frames: SpriteFrames) -> void:
	# Compatibility seam for temporary/test atlases. Production content should normally
	# be assigned through DirectionalSpriteProfile so pivot/filter/validation stay bundled.
	_sprite_frames = frames
	if _sprite != null:
		_sprite.sprite_frames = frames
	_apply_profile_settings()
	_apply_counter_projection()
	_sync_atlas_animation(true)


func sync_from_source(delta: float) -> void:
	_sync_from_source(delta)


func _process(delta: float) -> void:
	if source_actor == null or not is_instance_valid(source_actor):
		queue_free()
		return
	_sync_from_source(delta)


func _sync_from_source(_delta: float) -> void:
	if source_actor == null or not is_instance_valid(source_actor):
		return

	_hide_legacy_body()
	var runtime_contract := _resolve_runtime_contract()
	var facing := _resolve_facing(runtime_contract)
	if facing.length_squared() > 0.001:
		_facing = facing.normalized()
	_direction_name = _quantized_direction_name(_facing)
	_semantic_state = _resolve_semantic_state(runtime_contract)
	_action_id = str(runtime_contract.get("action_id", ""))
	_action_phase = str(runtime_contract.get("action_phase", "IDLE"))
	_authoritative_progress = float(runtime_contract.get("action_progress", -1.0))

	var source_position := source_actor.global_position
	if _profile_bool("snap_actor_to_pixel_grid", false) and _sprite_frames != null:
		source_position = Vector2(round(source_position.x), round(source_position.y))
	global_position = source_position
	# Presentation sorting uses the actor's feet/world anchor, independent of sprite height.
	z_index = clampi(1000 + int(round(source_actor.global_position.y)), -4095, 4095)
	_apply_counter_projection()
	_sync_atlas_animation(false)

	var signature := "%s|%s|%s|%.3f" % [_semantic_state, _direction_name, _action_id, visual_scale]
	if signature != _last_draw_signature:
		_last_draw_signature = signature
		queue_redraw()


func _resolve_runtime_contract() -> Dictionary:
	var result: Dictionary = {
		"action_id": "",
		"action_phase": "IDLE",
		"action_progress": -1.0,
	}

	# The shared CombatActionRunner is the clean boundary for attack identity/timing.
	# This lets rig-rendered attack frames be sampled from gameplay progress instead of
	# letting AnimatedSprite2D decide when an impact should occur.
	var runner := source_actor.get_node_or_null("CombatActionRunner")
	if runner != null and is_instance_valid(runner) and runner.has_method("presentation_snapshot"):
		var snapshot_value: Variant = runner.call("presentation_snapshot")
		if snapshot_value is Dictionary:
			var snapshot := snapshot_value as Dictionary
			if bool(snapshot.get("running", false)):
				result["action_id"] = str(snapshot.get("action_id", ""))
				result["action_phase"] = str(snapshot.get("phase", "IDLE"))
				result["action_progress"] = float(snapshot.get("action_progress", -1.0))
				result["state"] = "attack"

	# Hushiro Swordsman follow-up beats can temporarily override the runner's parent
	# action id. Alias mapping in its profile decides whether those beats share a clip.
	var override_value := _property_value(source_actor, "_hushiro_attack_id_override")
	if override_value != null and not str(override_value).strip_edges().is_empty():
		result["action_id"] = str(override_value)
		result["state"] = "attack"

	# Generic fallback for player profiles on scenes where a CombatActionRunner has not
	# yet been attached. Reading presentation state is allowed; mutation never is.
	if str(result.get("action_id", "")).is_empty():
		var profile_value := _property_value(source_actor, "_attack_profile")
		if profile_value is Dictionary:
			var attack_profile := profile_value as Dictionary
			if not attack_profile.is_empty():
				result["action_id"] = str(attack_profile.get("id", ""))

	return result


func _apply_profile_settings() -> void:
	visual_scale = _base_visual_scale
	if _profile != null and _sprite_frames != null:
		visual_scale *= maxf(0.05, float(_profile_value("visual_scale_multiplier", 1.0)))

	if _sprite == null:
		return
	_sprite.sprite_frames = _sprite_frames
	_sprite.flip_h = false
	if _profile != null:
		var anchor_value: Variant = _profile_value("foot_anchor_px", Vector2.ZERO)
		var offset_value: Variant = _profile_value("visual_offset", Vector2.ZERO)
		var anchor := anchor_value as Vector2 if anchor_value is Vector2 else Vector2.ZERO
		var offset := offset_value as Vector2 if offset_value is Vector2 else Vector2.ZERO
		_sprite.position = offset - anchor
		_sprite.texture_filter = (
			CanvasItem.TEXTURE_FILTER_NEAREST
			if _profile_bool("pixel_art", false)
			else CanvasItem.TEXTURE_FILTER_LINEAR
		)
	else:
		_sprite.position = Vector2.ZERO


func _apply_counter_projection() -> void:
	var safe_compression := maxf(0.01, ground_compression)
	# Ground positions are vertically compressed by CameraFollow. Character art is
	# counter-scaled so actors stay upright while their feet still occupy the isometric plane.
	scale = Vector2(visual_scale, visual_scale / safe_compression)


func _sync_atlas_animation(force_restart: bool) -> void:
	_resolved_animation_name = ""
	_authoritative_sampled = false
	_sampled_frame = -1
	if _sprite == null:
		return
	if _sprite_frames == null:
		_sprite.visible = false
		return

	var candidates := _animation_candidates()
	var desired := StringName()
	for candidate: String in candidates:
		var candidate_name := StringName(candidate)
		if _sprite_frames.has_animation(candidate_name):
			desired = candidate_name
			break
	if desired == StringName():
		_sprite.visible = false
		return

	_sprite.visible = true
	_resolved_animation_name = str(desired)
	var sample_from_authority := (
		_authoritative_progress >= 0.0
		and _profile_should_sample(_semantic_state)
	)
	if sample_from_authority:
		_sample_animation(desired, _authoritative_progress)
		return

	if force_restart or _sprite.animation != desired or not _sprite.is_playing():
		_sprite.play(desired)


func _animation_candidates() -> PackedStringArray:
	if _profile != null and _profile.has_method("animation_candidates"):
		var result_value: Variant = _profile.call("animation_candidates", _semantic_state, _action_id, _direction_name)
		if result_value is PackedStringArray:
			return result_value as PackedStringArray

	var result := PackedStringArray()
	var base := _semantic_state
	if _semantic_state == "attack" and not _action_id.strip_edges().is_empty():
		base = "attack_%s" % _sanitize_action_id(_action_id)
	_append_unique(result, "%s_%s" % [base, _direction_name])
	if base != _semantic_state:
		_append_unique(result, "%s_%s" % [_semantic_state, _direction_name])
	_append_unique(result, "idle_%s" % _direction_name)
	_append_unique(result, "idle_s")
	return result


func _sample_animation(animation_name: StringName, progress: float) -> void:
	if _sprite_frames == null:
		return
	var frame_count := _sprite_frames.get_frame_count(animation_name)
	if frame_count <= 0:
		return
	if _sprite.animation != animation_name:
		_sprite.animation = animation_name
	_sprite.pause()
	var clamped := clampf(progress, 0.0, 1.0)
	var frame_index := frame_count - 1 if clamped >= 1.0 else int(floor(clamped * float(frame_count)))
	frame_index = clampi(frame_index, 0, frame_count - 1)
	_sprite.frame = frame_index
	_authoritative_sampled = true
	_sampled_frame = frame_index


func _resolve_facing(runtime_contract: Dictionary) -> Vector2:
	# During attacks, authoritative aim/target snapshot has priority over locomotion.
	if str(runtime_contract.get("state", "")) == "attack":
		for property_name: String in ["_attack_aim_dir", "attack_aim_dir"]:
			var attack_facing := _property_value(source_actor, property_name)
			if attack_facing is Vector2 and (attack_facing as Vector2).length_squared() > 0.001:
				return attack_facing as Vector2
		var target_snapshot := _property_value(source_actor, "_windup_player_pos0")
		if target_snapshot is Vector2:
			var to_snapshot := (target_snapshot as Vector2) - source_actor.global_position
			if to_snapshot.length_squared() > 0.001:
				return to_snapshot

	# Dash direction should remain stable even when the authoritative dash temporarily
	# suppresses locomotion velocity elsewhere.
	var dodge_timer := _property_value(source_actor, "_dodge_timer")
	var dodge_dir := _property_value(source_actor, "_dodge_dir")
	if dodge_timer is float and float(dodge_timer) > 0.0 and dodge_dir is Vector2 and (dodge_dir as Vector2).length_squared() > 0.001:
		return dodge_dir as Vector2

	for property_name: String in ["facing_direction", "last_direction", "aim_direction", "direction", "_facing_dir", "_last_move_dir"]:
		var value := _property_value(source_actor, property_name)
		if value is Vector2 and (value as Vector2).length_squared() > 0.001:
			return value as Vector2

	if source_actor is CharacterBody2D:
		var velocity := (source_actor as CharacterBody2D).velocity
		if velocity.length_squared() > 1.0:
			return velocity

	# Defensive humanoids should still face the current player when stationary.
	if _bool_property(source_actor, "_block_active") or _bool_property(source_actor, "_block_held"):
		var player_value := _property_value(source_actor, "player")
		if player_value is Node2D and is_instance_valid(player_value):
			var to_player := (player_value as Node2D).global_position - source_actor.global_position
			if to_player.length_squared() > 0.001:
				return to_player
	return _facing


func _resolve_semantic_state(runtime_contract: Dictionary) -> String:
	if _source_dead():
		return "death"
	var explicit := str(runtime_contract.get("state", "")).strip_edges().to_lower()
	if explicit in VALID_STATES:
		return explicit
	if _bool_property(source_actor, "_dbroken_active"):
		return "hurt"
	if _bool_property(source_actor, "_block_active") or _bool_property(source_actor, "_block_held"):
		return "defend"

	var animation_name := _current_animation_name().to_lower()
	if _contains_any(animation_name, ["hurt", "hit", "stagger", "parried"]):
		return "hurt"
	if _contains_any(animation_name, ["dash", "dodge", "roll", "evade"]):
		return "dash"
	if _contains_any(animation_name, ["attack", "slash", "cleave", "thrust", "strike", "counter", "shoot", "vomit", "lunge", "bite"]):
		return "attack"
	if _contains_any(animation_name, ["block", "guard", "parry", "defend"]):
		return "defend"

	if source_actor is CharacterBody2D and (source_actor as CharacterBody2D).velocity.length() > 8.0:
		return "move"
	return "idle"


func _source_dead() -> bool:
	for property_name: String in ["dead", "is_dead", "_combat_dead"]:
		var value := _property_value(source_actor, property_name)
		if value is bool and bool(value):
			return true
	for health_property: String in ["health", "hp"]:
		var health_value := _property_value(source_actor, health_property)
		if health_value is int or health_value is float:
			if float(health_value) <= 0.0:
				return true
	return false


func _current_animation_name() -> String:
	for candidate: Node in source_actor.find_children("*", "AnimationPlayer", true, false):
		if candidate is AnimationPlayer:
			var player := candidate as AnimationPlayer
			if not str(player.current_animation).is_empty():
				return str(player.current_animation)
	return ""


func _property_value(object: Object, property_name: String) -> Variant:
	if object == null or not is_instance_valid(object):
		return null
	for info: Dictionary in object.get_property_list():
		if str(info.get("name", "")) == property_name:
			return object.get(property_name)
	return null


func _bool_property(object: Object, property_name: String) -> bool:
	var value := _property_value(object, property_name)
	return value is bool and bool(value)


func _profile_value(property_name: String, fallback: Variant) -> Variant:
	if _profile == null:
		return fallback
	for info: Dictionary in _profile.get_property_list():
		if str(info.get("name", "")) == property_name:
			return _profile.get(property_name)
	return fallback


func _profile_bool(property_name: String, fallback: bool) -> bool:
	var value := _profile_value(property_name, fallback)
	return bool(value) if value is bool else fallback


func _profile_should_sample(state: String) -> bool:
	if _profile != null and _profile.has_method("should_authoritatively_sample"):
		return bool(_profile.call("should_authoritatively_sample", state))
	return state == "attack"


func _quantized_direction_name(direction: Vector2) -> String:
	if direction.length_squared() <= 0.001:
		return _direction_name
	var angle := wrapf(atan2(direction.y, direction.x), 0.0, TAU)
	var index := posmod(int(round(angle / (TAU / 8.0))), 8)
	return DIRECTIONS[index]


func _contains_any(value: String, tokens: Array[String]) -> bool:
	for token: String in tokens:
		if value.contains(token):
			return true
	return false


func _sanitize_action_id(value: String) -> String:
	var result := value.strip_edges().to_lower()
	for token: String in [" ", "-", "/", ":", "."]:
		result = result.replace(token, "_")
	while result.contains("__"):
		result = result.replace("__", "_")
	return result.trim_prefix("_").trim_suffix("_")


func _append_unique(target: PackedStringArray, value: String) -> void:
	if not target.has(value):
		target.append(value)


func _hide_legacy_body() -> void:
	if source_actor == null or not is_instance_valid(source_actor):
		return
	for child: Node in source_actor.get_children():
		if bool(child.get_meta(KEEP_WITH_REPLACEMENT_META, false)):
			continue
		if not _is_primary_body_visual(child):
			continue
		var item := child as CanvasItem
		if not item.has_meta(LEGACY_VISIBLE_META):
			item.set_meta(LEGACY_VISIBLE_META, item.visible)
		item.visible = false


func _restore_legacy_body() -> void:
	if source_actor == null or not is_instance_valid(source_actor):
		return
	for child: Node in source_actor.get_children():
		if not (child is CanvasItem):
			continue
		var item := child as CanvasItem
		if item.has_meta(LEGACY_VISIBLE_META):
			item.visible = bool(item.get_meta(LEGACY_VISIBLE_META))
			item.remove_meta(LEGACY_VISIBLE_META)


func _is_primary_body_visual(node: Node) -> bool:
	if not (node is Sprite2D or node is AnimatedSprite2D or node is Polygon2D):
		return false
	var lower := str(node.name).to_lower()
	return lower in ["sprite2d", "animatedsprite2d", "bodysprite", "body_sprite", "actorvisual", "actor_visual", "visual"]


func _draw() -> void:
	if _sprite != null and _sprite.visible:
		return
	if not use_placeholder_when_atlas_missing:
		return

	var role_style := _role_style(actor_role)
	var body_color: Color = role_style["body"]
	var accent_color: Color = role_style["accent"]
	var width := float(role_style["width"])
	var height := float(role_style["height"])
	var direction := _direction_vector(_direction_name)

	# Counter-projection stretches local Y, so pre-compress the contact shadow to preserve
	# a low ellipse on screen. The feet remain the visual origin at Vector2.ZERO.
	draw_colored_polygon(_ellipse_points(Vector2(0.0, 2.0), Vector2(width * 0.62, 5.0 * ground_compression), 18), Color(0.01, 0.01, 0.015, 0.42))

	if actor_role == "hound":
		_draw_hound_placeholder(body_color, accent_color, direction, width, height)
	else:
		_draw_humanoid_placeholder(body_color, accent_color, direction, width, height)

	if _semantic_state == "hurt":
		draw_arc(Vector2(0.0, -height * 0.52), width * 0.55, 0.0, TAU, 18, Color(1.0, 0.24, 0.20, 0.72), 2.0)
	elif _semantic_state == "attack":
		var center := Vector2(direction.x * width * 0.45, -height * 0.46 + direction.y * 3.0)
		draw_arc(center, width * 0.95, -1.0, 1.0, 14, accent_color.lightened(0.28), 2.4)


func _draw_humanoid_placeholder(body_color: Color, accent_color: Color, direction: Vector2, width: float, height: float) -> void:
	var lean := direction.x * 2.0
	var torso_center := Vector2(lean, -height * 0.48)
	var torso := PackedVector2Array([
		Vector2(torso_center.x - width * 0.34, -height * 0.70),
		Vector2(torso_center.x + width * 0.34, -height * 0.70),
		Vector2(torso_center.x + width * 0.28, -height * 0.20),
		Vector2(torso_center.x - width * 0.28, -height * 0.20),
	])
	draw_colored_polygon(torso, body_color)
	draw_circle(Vector2(lean, -height * 0.86), width * 0.20, body_color.lightened(0.10))

	draw_line(Vector2(-width * 0.15, -height * 0.22), Vector2(-width * 0.23, 0.0), body_color.darkened(0.10), width * 0.16)
	draw_line(Vector2(width * 0.15, -height * 0.22), Vector2(width * 0.23, 0.0), body_color.darkened(0.10), width * 0.16)
	var weapon_start := Vector2(direction.x * width * 0.20, -height * 0.58 + direction.y * 2.0)
	var weapon_end := weapon_start + direction * width * (1.1 if actor_role == "archer" else 1.45)
	draw_line(weapon_start, weapon_end, accent_color, maxf(2.0, width * 0.09))

	if actor_role == "archer":
		draw_arc(weapon_start + direction * width * 0.62, width * 0.42, -1.2, 1.2, 10, accent_color, 1.8)
	elif actor_role == "warden":
		draw_arc(torso_center, width * 0.48, 0.0, TAU, 16, accent_color.darkened(0.12), 3.0)
	elif actor_role == "bilemass":
		draw_circle(Vector2(0.0, -height * 0.43), width * 0.46, body_color.darkened(0.06))

	var face := Vector2(lean, -height * 0.86) + direction * width * 0.12
	draw_circle(face, maxf(1.3, width * 0.055), accent_color)


func _draw_hound_placeholder(body_color: Color, accent_color: Color, direction: Vector2, width: float, height: float) -> void:
	var tangent := Vector2(-direction.y, direction.x)
	var center := Vector2(0.0, -height * 0.34)
	var half_length := width * 0.52
	var half_thickness := height * 0.20
	var body := PackedVector2Array([
		center - direction * half_length - tangent * half_thickness,
		center + direction * half_length - tangent * half_thickness,
		center + direction * half_length + tangent * half_thickness,
		center - direction * half_length + tangent * half_thickness,
	])
	draw_colored_polygon(body, body_color)
	var head := center + direction * width * 0.58
	draw_circle(head, height * 0.23, body_color.lightened(0.07))
	draw_circle(head + direction * height * 0.12, maxf(1.2, height * 0.055), accent_color)
	for side: float in [-1.0, 1.0]:
		var leg_base := center + tangent * side * width * 0.30
		draw_line(leg_base, leg_base + Vector2(0.0, height * 0.32), body_color.darkened(0.14), maxf(2.0, height * 0.10))


func _role_style(role: String) -> Dictionary:
	match role:
		"player":
			return {"body": Color(0.73, 0.42, 0.20, 1.0), "accent": Color(0.82, 0.90, 0.98, 1.0), "width": 25.0, "height": 54.0}
		"swordsman":
			return {"body": Color(0.18, 0.20, 0.24, 1.0), "accent": Color(0.82, 0.12, 0.10, 1.0), "width": 25.0, "height": 52.0}
		"hollow":
			return {"body": Color(0.22, 0.24, 0.26, 1.0), "accent": Color(0.88, 0.12, 0.12, 1.0), "width": 21.0, "height": 45.0}
		"archer":
			return {"body": Color(0.20, 0.22, 0.25, 1.0), "accent": Color(0.92, 0.30, 0.13, 1.0), "width": 22.0, "height": 49.0}
		"bilemass":
			return {"body": Color(0.29, 0.25, 0.20, 1.0), "accent": Color(0.54, 0.82, 0.25, 1.0), "width": 31.0, "height": 50.0}
		"warden":
			return {"body": Color(0.17, 0.18, 0.21, 1.0), "accent": Color(0.68, 0.18, 0.14, 1.0), "width": 34.0, "height": 61.0}
		"hound":
			return {"body": Color(0.20, 0.10, 0.09, 1.0), "accent": Color(0.90, 0.08, 0.08, 1.0), "width": 42.0, "height": 28.0}
		_:
			return {"body": Color(0.23, 0.23, 0.25, 1.0), "accent": Color(0.82, 0.14, 0.12, 1.0), "width": 23.0, "height": 48.0}


func _direction_vector(direction_name: String) -> Vector2:
	match direction_name:
		"e": return Vector2(1.0, 0.0)
		"se": return Vector2(0.7071, 0.7071)
		"s": return Vector2(0.0, 1.0)
		"sw": return Vector2(-0.7071, 0.7071)
		"w": return Vector2(-1.0, 0.0)
		"nw": return Vector2(-0.7071, -0.7071)
		"n": return Vector2(0.0, -1.0)
		"ne": return Vector2(0.7071, -0.7071)
		_: return Vector2(0.0, 1.0)


func _ellipse_points(center: Vector2, radii: Vector2, segments: int) -> PackedVector2Array:
	var points := PackedVector2Array()
	for index: int in range(maxi(8, segments)):
		var angle := TAU * float(index) / float(maxi(8, segments))
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	return points


func get_presentation_state_for_test() -> Dictionary:
	return {
		"role": actor_role,
		"state": _semantic_state,
		"direction": _direction_name,
		"action_id": _action_id,
		"action_phase": _action_phase,
		"action_progress": _authoritative_progress,
		"visual_scale": visual_scale,
		"ground_compression": ground_compression,
		"profile_id": str(_profile_value("profile_id", "")),
		"asset_ready": _profile_bool("asset_ready", false),
		"pixel_art": _profile_bool("pixel_art", false),
		"resolved_animation": _resolved_animation_name,
		"authoritative_sampled": _authoritative_sampled,
		"sampled_frame": _sampled_frame,
		"atlas_active": _sprite != null and _sprite.visible and _sprite_frames != null,
		"placeholder_active": use_placeholder_when_atlas_missing and (_sprite == null or not _sprite.visible),
	}
