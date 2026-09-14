extends Node2D

## Procedural directional stand-in used while production three-quarter character art is
## being authored. This is presentation-only: the parent CharacterBody2D remains the
## authoritative actor for movement, collision, attacks and AI.
##
## CameraFollow counter-projects this node vertically so the body remains upright while
## helper ground cues are manually compressed back onto the projected combat plane.

const PLAYER_BODY := Color(0.105, 0.120, 0.145, 1.0)
const PLAYER_CLOTH := Color(0.175, 0.195, 0.220, 1.0)
const PLAYER_ACCENT := Color(0.54, 0.075, 0.070, 1.0)
const PLAYER_STEEL := Color(0.74, 0.76, 0.75, 1.0)
const ENEMY_BODY := Color(0.205, 0.180, 0.165, 1.0)
const ENEMY_DARK := Color(0.095, 0.075, 0.073, 1.0)
const ENEMY_ACCENT := Color(0.58, 0.105, 0.080, 1.0)
const HOLLOW_BODY := Color(0.315, 0.305, 0.285, 1.0)
const BILE_BODY := Color(0.235, 0.285, 0.165, 1.0)
const WARDEN_BODY := Color(0.185, 0.170, 0.160, 1.0)
const SKIN := Color(0.66, 0.57, 0.48, 1.0)
const ATTACK_PLAYER := Color(0.82, 0.86, 0.90, 0.64)
const ATTACK_ENEMY := Color(0.88, 0.20, 0.12, 0.58)
const GUARD_COLOR := Color(0.70, 0.76, 0.80, 0.52)
const EIGHT_DIRECTION_STEP := TAU / 8.0

var _actor: Node2D = null
var _legacy_sprite: Sprite2D = null
var _animation_player: AnimationPlayer = null
var _compression := 0.84
var _facing := Vector2(0.0, 1.0)
var _move_speed := 0.0
var _motion_phase := 0.0
var _role := "enemy"
var _current_animation := ""
var _animation_progress := 0.0


func configure(vertical_compression: float) -> void:
	_compression = clampf(vertical_compression, 0.50, 1.0)
	# This cancels Camera2D's vertical ground compression for upright body artwork.
	scale = Vector2(1.0, 1.0 / _compression)
	_refresh_references()
	queue_redraw()


func _ready() -> void:
	_refresh_references()
	set_process(true)
	queue_redraw()


func _process(dt: float) -> void:
	if _actor == null or not is_instance_valid(_actor):
		queue_free()
		return

	if _legacy_sprite != null and is_instance_valid(_legacy_sprite):
		# CameraFollow hides the legacy art through self_modulate, so `visible` remains a
		# useful authority for intentional actor disappearance.
		visible = _legacy_sprite.visible

	var velocity := Vector2.ZERO
	if _actor is CharacterBody2D:
		velocity = (_actor as CharacterBody2D).velocity
	_move_speed = velocity.length()
	if _move_speed > 4.0:
		# Eight discrete sectors deliberately mirror the intended production sprite
		# pipeline. The proxy therefore tests directional readability rather than an
		# impossible infinitely-rotating vector character.
		_facing = _quantize_eight_direction(velocity)
		_motion_phase += dt * clampf(5.0 + _move_speed * 0.025, 5.0, 12.0)
	else:
		_motion_phase += dt * 2.0

	_update_animation_state()
	_role = _resolve_role()
	queue_redraw()


func _quantize_eight_direction(direction: Vector2) -> Vector2:
	if direction.length_squared() < 0.001:
		return _facing
	var angle := direction.angle()
	var snapped := roundf(angle / EIGHT_DIRECTION_STEP) * EIGHT_DIRECTION_STEP
	return Vector2(cos(snapped), sin(snapped)).normalized()


func _refresh_references() -> void:
	_actor = get_parent() as Node2D
	if _actor == null:
		return
	_legacy_sprite = _actor.get_node_or_null("Sprite2D") as Sprite2D
	_animation_player = _find_animation_player(_actor)
	_role = _resolve_role()


func _resolve_role() -> String:
	if _actor == null:
		return "enemy"
	if _actor.is_in_group("player"):
		return "player"
	var metadata_role := str(_actor.get_meta("hushiro_enemy_type", "")).to_lower()
	if not metadata_role.is_empty():
		return metadata_role
	var lowered := str(_actor.name).to_lower()
	for candidate: String in ["swordsman", "archer", "hound", "hollow", "bilemass", "warden"]:
		if lowered.contains(candidate):
			return candidate
	return "enemy"


func _find_animation_player(node: Node) -> AnimationPlayer:
	for child: Node in node.get_children():
		if child is AnimationPlayer:
			return child as AnimationPlayer
		var nested := _find_animation_player(child)
		if nested != null:
			return nested
	return null


func _update_animation_state() -> void:
	_current_animation = ""
	_animation_progress = 0.0
	if _animation_player == null or not is_instance_valid(_animation_player):
		return
	_current_animation = str(_animation_player.current_animation).to_lower()
	var length := _animation_player.current_animation_length
	if length > 0.001:
		_animation_progress = clampf(_animation_player.current_animation_position / length, 0.0, 1.0)


func _draw() -> void:
	if _actor == null:
		return

	_draw_ground_readability()
	match _role:
		"player":
			_draw_humanoid(true, 1.0)
		"hound":
			_draw_hound()
		"bilemass":
			_draw_bilemass()
		"hollow":
			_draw_humanoid(false, 0.82, HOLLOW_BODY)
		"warden":
			_draw_humanoid(false, 1.18, WARDEN_BODY)
		"archer":
			_draw_humanoid(false, 0.96)
			_draw_bow()
		_:
			_draw_humanoid(false, 1.0)

	_draw_action_readability()


func _draw_ground_readability() -> void:
	# Small facing wedge is intentionally subtle. It makes the eight-direction sector
	# readable even before final directional animation exists.
	var screen_facing := _project_ground_vector(_facing.normalized())
	var side := Vector2(-screen_facing.y, screen_facing.x)
	var tip := screen_facing * 12.0 + Vector2(0.0, 3.5)
	var base := Vector2(0.0, 3.5)
	var wedge := PackedVector2Array([
		base + side * 3.0,
		tip,
		base - side * 3.0,
	])
	var color := Color(0.74, 0.78, 0.78, 0.20) if _role == "player" else Color(0.72, 0.18, 0.13, 0.16)
	draw_colored_polygon(wedge, color)


func _draw_humanoid(is_player: bool, size_factor: float, body_override: Color = Color(-1, -1, -1, -1)) -> void:
	var walking := clampf(_move_speed / 150.0, 0.0, 1.0)
	var bob := sin(_motion_phase * 2.0) * 0.75 * walking
	var stride := sin(_motion_phase) * 2.5 * walking
	var lateral := _facing.x
	var facing_away := _facing.y < -0.20

	var body_color := PLAYER_BODY if is_player else ENEMY_BODY
	if body_override.a >= 0.0:
		body_color = body_override
	var cloth_color := PLAYER_CLOTH if is_player else ENEMY_DARK
	var accent_color := PLAYER_ACCENT if is_player else ENEMY_ACCENT

	# Feet/legs anchor at y=0. Their tiny alternating offset gives motion without touching
	# gameplay position or waiting for final sprite animation.
	var leg_y := -2.0 + bob
	draw_line(Vector2(-4.0 - stride * 0.35, leg_y - 7.0), Vector2(-5.0 + stride, leg_y + 2.0), cloth_color, 3.2 * size_factor, true)
	draw_line(Vector2(4.0 + stride * 0.35, leg_y - 7.0), Vector2(5.0 - stride, leg_y + 2.0), cloth_color, 3.2 * size_factor, true)

	# Torso is a slightly asymmetric trapezoid. The shoulder shift communicates left/right
	# facing while the head/face treatment distinguishes front from back.
	var shoulder_shift := lateral * 2.0
	var torso := PackedVector2Array([
		Vector2(-8.0 + shoulder_shift, -23.0 + bob),
		Vector2(8.0 + shoulder_shift, -23.0 + bob),
		Vector2(6.0, -7.0 + bob),
		Vector2(-6.0, -7.0 + bob),
	])
	for i: int in range(torso.size()):
		torso[i] *= size_factor
	draw_colored_polygon(torso, body_color)

	# Waist sash / corruption band.
	draw_line(Vector2(-6.5, -9.0 + bob) * size_factor, Vector2(6.5, -9.0 + bob) * size_factor, accent_color, 2.2 * size_factor, true)

	var head_pos := Vector2(shoulder_shift * 0.45, -29.0 + bob) * size_factor
	draw_circle(head_pos, 5.2 * size_factor, cloth_color if facing_away else SKIN)
	if not facing_away:
		var eye_y := head_pos.y - 0.3 * size_factor
		var eye_offset := 1.6 * size_factor
		var eye_color := Color(0.10, 0.08, 0.07, 0.88) if is_player else Color(0.90, 0.18, 0.12, 0.88)
		draw_circle(Vector2(head_pos.x - eye_offset, eye_y), 0.65 * size_factor, eye_color)
		draw_circle(Vector2(head_pos.x + eye_offset, eye_y), 0.65 * size_factor, eye_color)

	if is_player:
		_draw_katana(size_factor, bob)
	elif _role == "swordsman" or _role == "warden" or _role == "enemy":
		_draw_enemy_blade(size_factor, bob)

	# Scarf/rag direction reinforces orientation and creates a more dimensional silhouette.
	var scarf_side := -1.0 if lateral >= 0.0 else 1.0
	var scarf_origin := Vector2(scarf_side * 4.5, -21.0 + bob) * size_factor
	var scarf_tip := scarf_origin + Vector2(scarf_side * 10.0, 5.0 + maxf(0.0, _facing.y) * 2.0) * size_factor
	draw_line(scarf_origin, scarf_tip, accent_color, 2.5 * size_factor, true)


func _draw_katana(size_factor: float, bob: float) -> void:
	var side := 1.0 if _facing.x >= -0.15 else -1.0
	var hand := Vector2(side * 7.0, -16.0 + bob) * size_factor
	var blade_dir := Vector2(side * 0.62, -0.78)
	if _current_animation.contains("attack"):
		blade_dir = Vector2(side * 0.96, -0.25)
	var tip := hand + blade_dir * (23.0 * size_factor)
	draw_line(hand, tip, PLAYER_STEEL, 2.0 * size_factor, true)
	draw_line(hand - Vector2(side * 2.5, 0.0), hand + Vector2(side * 2.5, 0.0), PLAYER_ACCENT, 2.6 * size_factor, true)


func _draw_enemy_blade(size_factor: float, bob: float) -> void:
	var side := -1.0 if _facing.x < 0.0 else 1.0
	var hand := Vector2(side * 7.0, -15.0 + bob) * size_factor
	var tip := hand + Vector2(side * 0.66, -0.74) * (20.0 * size_factor)
	draw_line(hand, tip, Color(0.54, 0.53, 0.50, 1.0), 2.0 * size_factor, true)


func _draw_bow() -> void:
	var side := 1.0 if _facing.x >= 0.0 else -1.0
	var center := Vector2(side * 8.0, -15.0)
	var bow_color := Color(0.38, 0.22, 0.13, 1.0)
	var points := PackedVector2Array()
	for index: int in range(9):
		var t := float(index) / 8.0
		var y := lerpf(-11.0, 11.0, t)
		var x := sin(t * PI) * 4.0 * side
		points.append(center + Vector2(x, y))
	draw_polyline(points, bow_color, 2.0, true)
	draw_line(center + Vector2(0.0, -11.0), center + Vector2(0.0, 11.0), Color(0.72, 0.68, 0.55, 0.8), 1.0, true)


func _draw_hound() -> void:
	var walking := clampf(_move_speed / 180.0, 0.0, 1.0)
	var bob := absf(sin(_motion_phase)) * 0.8 * walking
	var side := 1.0 if _facing.x >= 0.0 else -1.0
	var body := PackedVector2Array([
		Vector2(-12.0, -10.0 + bob), Vector2(10.0, -11.0 + bob),
		Vector2(15.0, -4.0 + bob), Vector2(-10.0, -3.0 + bob),
	])
	draw_colored_polygon(body, Color(0.14, 0.11, 0.105, 1.0))
	var head := Vector2(side * 14.0, -12.0 + bob)
	draw_circle(head, 5.5, ENEMY_BODY)
	draw_circle(head + Vector2(side * 2.0, -1.0), 1.0, Color(0.95, 0.16, 0.10, 0.9))
	for x: float in [-8.0, 7.0]:
		draw_line(Vector2(x, -4.0 + bob), Vector2(x + sin(_motion_phase + x) * 2.0, 2.0), ENEMY_DARK, 2.6, true)
	draw_line(Vector2(-12.0 * side, -8.0 + bob), Vector2(-21.0 * side, -14.0 + bob), ENEMY_DARK, 2.5, true)


func _draw_bilemass() -> void:
	var pulse := sin(_motion_phase * 1.4) * 0.8
	var body_color := BILE_BODY.lightened(0.04 * sin(_motion_phase))
	_draw_local_ellipse(Vector2(0.0, -8.0), Vector2(13.5 + pulse, 11.0 - pulse * 0.25), body_color)
	_draw_local_ellipse(Vector2(-5.0, -13.0), Vector2(5.0, 4.0), Color(0.34, 0.39, 0.20, 0.75))
	draw_circle(Vector2(5.5, -11.0), 1.3, Color(0.92, 0.26, 0.11, 0.9))


func _draw_action_readability() -> void:
	var attacking := _current_animation.contains("attack") or _current_animation.contains("slash") or _current_animation.contains("cleave")
	var guarding := _current_animation.contains("block") or _current_animation.contains("parry") or _current_animation.contains("guard")
	var dashing := _current_animation.contains("dash")

	if attacking:
		var cue_color := ATTACK_PLAYER if _role == "player" else ATTACK_ENEMY
		var width := 2.6 if _role == "player" else 2.2
		_draw_ground_arc(29.0, -0.92, 0.92, cue_color, width)
		# Bright leading edge gives the slash a direction rather than reading as a ring.
		_draw_ground_arc(33.0, 0.35, 0.92, cue_color.lightened(0.20), 1.4)
	elif guarding:
		_draw_ground_arc(20.0, -0.72, 0.72, GUARD_COLOR, 2.3)

	if dashing:
		var rear := -_project_ground_vector(_facing.normalized())
		draw_line(rear * 8.0 + Vector2(0.0, -15.0), rear * 24.0 + Vector2(0.0, -15.0), Color(0.68, 0.74, 0.78, 0.28), 5.0, true)


func _draw_ground_arc(radius: float, start_offset: float, end_offset: float, color: Color, width: float) -> void:
	var projected_facing := _project_ground_vector(_facing.normalized())
	if projected_facing.length_squared() < 0.001:
		projected_facing = Vector2.RIGHT
	var center_angle := atan2(projected_facing.y, projected_facing.x)
	var points := PackedVector2Array()
	const SEGMENTS := 18
	for index: int in range(SEGMENTS + 1):
		var t := float(index) / float(SEGMENTS)
		var angle := center_angle + lerpf(start_offset, end_offset, t)
		var raw := Vector2(cos(angle), sin(angle)) * radius
		# The proxy body is counter-projected; manually reapply ground compression so this
		# cue still lies on the arena plane.
		points.append(Vector2(raw.x, raw.y * _compression) + Vector2(0.0, 3.0))
	draw_polyline(points, color, width, true)


func _project_ground_vector(world_vector: Vector2) -> Vector2:
	var projected := Vector2(world_vector.x, world_vector.y * _compression)
	return projected.normalized() if projected.length_squared() > 0.001 else Vector2.RIGHT


func _draw_local_ellipse(center: Vector2, radii: Vector2, color: Color) -> void:
	var points := PackedVector2Array()
	for index: int in range(20):
		var angle := TAU * float(index) / 20.0
		points.append(center + Vector2(cos(angle) * radii.x, sin(angle) * radii.y))
	draw_colored_polygon(points, color)
