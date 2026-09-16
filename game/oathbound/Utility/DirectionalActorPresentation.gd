extends Node2D

## Presentation-only adapter for Oathbound's planar actors.
##
## The authoritative CharacterBody2D/Node2D still owns movement, hitboxes, Health, Poise,
## attack timing and AI. This node turns that state into an eight-direction 2D visual.
## Today it draws a deliberately simple readable placeholder. Later a hand-drawn or
## offline-3D-rendered SpriteFrames atlas can replace the placeholder without changing
## combat code.
##
## Production animation naming contract:
##   <state>_<direction>, e.g. idle_s, move_ne, attack_w, hurt_se, death_n
## States currently resolved here: idle, move, dash, attack, defend, hurt, death.
## Directions: e, se, s, sw, w, nw, n, ne.

const LEGACY_VISIBLE_META := &"_oathbound_directional2d_base_visible"
const KEEP_WITH_REPLACEMENT_META := &"oathbound_keep_with_replacement_visual"
const DIRECTIONS: Array[String] = ["e", "se", "s", "sw", "w", "nw", "n", "ne"]

@export var visual_scale: float = 1.0
@export var ground_compression: float = 0.72
@export var use_placeholder_when_atlas_missing: bool = true

var source_actor: Node2D = null
var actor_role: String = "enemy"
var _facing := Vector2(0.0, 1.0)
var _direction_name := "s"
var _semantic_state := "idle"
var _last_draw_signature := ""
var _sprite: AnimatedSprite2D = null
var _sprite_frames: SpriteFrames = null


func _ready() -> void:
	set_meta(KEEP_WITH_REPLACEMENT_META, true)
	_sprite = AnimatedSprite2D.new()
	_sprite.name = "DirectionalSprite"
	_sprite.centered = false
	_sprite.position = Vector2.ZERO
	_sprite.set_meta(KEEP_WITH_REPLACEMENT_META, true)
	add_child(_sprite)
	_apply_counter_projection()
	queue_redraw()


func _exit_tree() -> void:
	_restore_legacy_body()


func configure(actor: Node2D, role: String, scale_factor: float, compression: float) -> void:
	source_actor = actor
	actor_role = role.strip_edges().to_lower()
	visual_scale = maxf(0.05, scale_factor)
	ground_compression = clampf(compression, 0.35, 1.0)
	_apply_counter_projection()
	_sync_from_source(0.0)


func set_sprite_frames(frames: SpriteFrames) -> void:
	_sprite_frames = frames
	if _sprite != null:
		_sprite.sprite_frames = frames
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
	var facing := _resolve_facing()
	if facing.length_squared() > 0.001:
		_facing = facing.normalized()
	_direction_name = _quantized_direction_name(_facing)
	_semantic_state = _resolve_semantic_state()

	global_position = source_actor.global_position
	# Presentation sorting uses the actor's feet/world anchor, independent of sprite height.
	z_index = clampi(1000 + int(round(global_position.y)), -4095, 4095)
	_apply_counter_projection()
	_sync_atlas_animation(false)

	var signature := "%s|%s|%.3f" % [_semantic_state, _direction_name, visual_scale]
	if signature != _last_draw_signature:
		_last_draw_signature = signature
		queue_redraw()


func _apply_counter_projection() -> void:
	var safe_compression := maxf(0.01, ground_compression)
	# Ground positions are vertically compressed by CameraFollow. Character art is
	# counter-scaled so actors stay upright while their feet still occupy the isometric plane.
	scale = Vector2(visual_scale, visual_scale / safe_compression)


func _sync_atlas_animation(force_restart: bool) -> void:
	if _sprite == null:
		return
	if _sprite_frames == null:
		_sprite.visible = false
		return
	var desired := StringName("%s_%s" % [_semantic_state, _direction_name])
	if not _sprite_frames.has_animation(desired):
		var fallback := StringName("idle_%s" % _direction_name)
		if _sprite_frames.has_animation(fallback):
			desired = fallback
		elif _sprite_frames.has_animation(&"idle_s"):
			desired = &"idle_s"
		else:
			_sprite.visible = false
			return

	_sprite.visible = true
	if force_restart or _sprite.animation != desired or not _sprite.is_playing():
		_sprite.play(desired)


func _resolve_facing() -> Vector2:
	for property_name: String in ["facing_direction", "last_direction", "aim_direction", "direction"]:
		var value := _property_value(source_actor, property_name)
		if value is Vector2 and (value as Vector2).length_squared() > 0.001:
			return value as Vector2

	if source_actor is CharacterBody2D:
		var velocity := (source_actor as CharacterBody2D).velocity
		if velocity.length_squared() > 1.0:
			return velocity
	return _facing


func _resolve_semantic_state() -> String:
	if _source_dead():
		return "death"

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
	for property_name: String in ["dead", "is_dead"]:
		var value := _property_value(source_actor, property_name)
		if value is bool and bool(value):
			return true
	var health_value := _property_value(source_actor, "health")
	if health_value is int or health_value is float:
		return float(health_value) <= 0.0
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

	# Split legs and a directional weapon/readability line make facing obvious even before
	# final directional atlases exist.
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

	# Tiny directional face accent is enough to make eight-way orientation legible.
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
		"visual_scale": visual_scale,
		"ground_compression": ground_compression,
		"atlas_active": _sprite != null and _sprite.visible and _sprite_frames != null,
		"placeholder_active": use_placeholder_when_atlas_missing and (_sprite == null or not _sprite.visible),
	}
