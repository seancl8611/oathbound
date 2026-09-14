extends Node2D

## Procedural eight-direction stand-in while production three-quarter character art is
## authored. The parent CharacterBody2D remains authoritative for movement, collision,
## attacks and AI; this script only observes that state and draws presentation.

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
const YOMORI_BODY := Color(0.135, 0.205, 0.195, 1.0)
const YOMORI_GLOW := Color(0.34, 0.74, 0.66, 0.82)
const YOMORI_LANTERN := Color(0.78, 0.58, 0.21, 0.92)
const COURT_BODY := Color(0.255, 0.095, 0.080, 1.0)
const COURT_DARK := Color(0.095, 0.045, 0.045, 1.0)
const COURT_GOLD := Color(0.68, 0.47, 0.17, 1.0)
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
var _action_tag := ""
var _animation_progress := 0.0


func configure(vertical_compression: float) -> void:
	_compression = clampf(vertical_compression, 0.50, 1.0)
	# Counter-project only upright body presentation. Ground-space cues manually reapply
	# compression so they still lie on the projected combat plane.
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
		visible = _legacy_sprite.visible

	_role = _resolve_role()
	var velocity := Vector2.ZERO
	if _actor is CharacterBody2D:
		velocity = (_actor as CharacterBody2D).velocity
	_move_speed = velocity.length()
	if _move_speed > 4.0:
		_facing = _quantize_eight_direction(velocity)
		_motion_phase += dt * clampf(5.0 + _move_speed * 0.025, 5.0, 12.0)
	else:
		_motion_phase += dt * 2.0

	_update_animation_state()
	_update_controller_presentation_state()
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
	for metadata_key: StringName in [&"hushiro_enemy_type", &"yomori_enemy_type", &"kagutsuchi_enemy_type", &"enemy_type"]:
		var metadata_role := str(_actor.get_meta(metadata_key, "")).to_lower()
		if not metadata_role.is_empty():
			return metadata_role

	var identity := str(_actor.name).to_lower()
	var script_value: Variant = _actor.get_script()
	if script_value is Script:
		identity += " " + (script_value as Script).resource_path.to_lower()

	# Long/specific names first so hound/hollow compatibility tokens do not swallow
	# later-region identities.
	for candidate: String in [
		"lingering_wraith", "lantern_wraith", "mist_shepherd", "stalker_hound",
		"court_guard", "court_caster", "elite_defender", "hollow_vessel", "court_sentinel",
		"eclipse_shogun", "rootfang", "briarthorn",
		"swordsman", "archer", "bilemass", "warden", "hound", "hollow",
	]:
		if identity.contains(candidate):
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
	_action_tag = ""
	_animation_progress = 0.0
	if _animation_player == null or not is_instance_valid(_animation_player):
		return
	# Stopped playback is normal in several current controllers. Never query playback
	# length unless an enabled animation is actually playing; this removes the 4.7.2
	# "AnimationPlayer has no current animation" playtest spam.
	if not _animation_player.is_playing():
		return
	var animation_name := str(_animation_player.current_animation)
	if animation_name.is_empty() or not _animation_player.has_animation(animation_name):
		return
	_action_tag = animation_name.to_lower()
	var animation := _animation_player.get_animation(animation_name)
	if animation == null:
		return
	var length := float(animation.length)
	if length > 0.001:
		_animation_progress = clampf(_animation_player.current_animation_position / length, 0.0, 1.0)


func _update_controller_presentation_state() -> void:
	if _actor == null or _role != "player":
		return

	# Canonical Player combat can be controller-driven while its imported AnimationPlayer
	# is stopped. Read only existing presentation-relevant controller fields so facing and
	# attack/guard silhouettes stay truthful without changing gameplay authority.
	var facing_value: Variant = _actor.get("_facing_dir")
	if facing_value is Vector2 and (facing_value as Vector2).length_squared() > 0.001:
		_facing = _quantize_eight_direction(facing_value as Vector2)

	var profile_value: Variant = _actor.get("_attack_profile")
	if profile_value is Dictionary and not (profile_value as Dictionary).is_empty():
		var profile := profile_value as Dictionary
		var duration := maxf(0.001, float(profile.get("duration", 0.30)))
		var elapsed := float(_actor.get("_attack_elapsed"))
		if elapsed < duration:
			_action_tag = "attack_" + str(profile.get("id", "basic"))
			_animation_progress = clampf(elapsed / duration, 0.0, 1.0)
			return

	if bool(_actor.get("_block_held")) or bool(_actor.get("_parry_active")):
		_action_tag = "guard"


func _draw() -> void:
	if _actor == null:
		return
	_draw_ground_readability()

	match _role:
		"player":
			_draw_humanoid(true, 1.0)
		"hound":
			_draw_hound(Color(0.14, 0.11, 0.105, 1.0), 1.0)
		"stalker_hound":
			_draw_hound(Color(0.075, 0.135, 0.125, 1.0), 1.08)
		"rootfang":
			_draw_hound(Color(0.095, 0.145, 0.105, 1.0), 1.55)
		"briarthorn":
			_draw_hound(Color(0.16, 0.105, 0.12, 1.0), 1.55)
		"bilemass":
			_draw_bilemass()
		"hollow":
			_draw_humanoid(false, 0.82, HOLLOW_BODY)
		"warden":
			_draw_humanoid(false, 1.18, WARDEN_BODY)
		"archer":
			_draw_humanoid(false, 0.96)
			_draw_bow()
		"lingering_wraith":
			_draw_wraith(false)
		"lantern_wraith":
			_draw_wraith(true)
		"mist_shepherd":
			_draw_humanoid(false, 1.04, YOMORI_BODY, YOMORI_GLOW)
			_draw_staff(YOMORI_GLOW, 1.0)
		"court_guard":
			_draw_humanoid(false, 1.03, COURT_BODY, COURT_GOLD)
			_draw_enemy_blade(1.0, 0.0)
		"court_caster":
			_draw_humanoid(false, 0.98, Color(0.20, 0.07, 0.10, 1.0), COURT_GOLD)
			_draw_staff(COURT_GOLD, 1.0)
		"elite_defender":
			_draw_humanoid(false, 1.22, Color(0.18, 0.07, 0.06, 1.0), COURT_GOLD)
			_draw_shield(1.18)
		"hollow_vessel":
			_draw_humanoid(false, 0.92, Color(0.30, 0.25, 0.24, 1.0), Color(0.48, 0.08, 0.07, 1.0))
		"court_sentinel":
			_draw_humanoid(false, 1.30, Color(0.15, 0.055, 0.05, 1.0), COURT_GOLD)
			_draw_shield(1.28)
		"eclipse_shogun":
			_draw_humanoid(false, 1.52, Color(0.18, 0.045, 0.045, 1.0), COURT_GOLD)
			_draw_enemy_blade(1.55, 0.0)
			_draw_shogun_crest()
		_:
			_draw_humanoid(false, 1.0)

	_draw_action_readability()


func _draw_ground_readability() -> void:
	var screen_facing := _project_ground_vector(_facing.normalized())
	var side := Vector2(-screen_facing.y, screen_facing.x)
	var base := Vector2(0.0, 3.5)
	var wedge := PackedVector2Array([base + side * 3.0, screen_facing * 12.0 + base, base - side * 3.0])
	var color := Color(0.74, 0.78, 0.78, 0.20) if _role == "player" else Color(0.72, 0.18, 0.13, 0.16)
	draw_colored_polygon(wedge, color)


func _draw_humanoid(is_player: bool, size_factor: float, body_override: Color = Color(-1, -1, -1, -1), accent_override: Color = Color(-1, -1, -1, -1)) -> void:
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
	if accent_override.a >= 0.0:
		accent_color = accent_override

	var leg_y := -2.0 + bob
	draw_line(Vector2(-4.0 - stride * 0.35, leg_y - 7.0), Vector2(-5.0 + stride, leg_y + 2.0), cloth_color, 3.2 * size_factor, true)
	draw_line(Vector2(4.0 + stride * 0.35, leg_y - 7.0), Vector2(5.0 - stride, leg_y + 2.0), cloth_color, 3.2 * size_factor, true)

	var shoulder_shift := lateral * 2.0
	var torso := PackedVector2Array([
		Vector2(-8.0 + shoulder_shift, -23.0 + bob), Vector2(8.0 + shoulder_shift, -23.0 + bob),
		Vector2(6.0, -7.0 + bob), Vector2(-6.0, -7.0 + bob),
	])
	for i: int in range(torso.size()):
		torso[i] *= size_factor
	draw_colored_polygon(torso, body_color)
	draw_line(Vector2(-6.5, -9.0 + bob) * size_factor, Vector2(6.5, -9.0 + bob) * size_factor, accent_color, 2.2 * size_factor, true)

	var head_pos := Vector2(shoulder_shift * 0.45, -29.0 + bob) * size_factor
	draw_circle(head_pos, 5.2 * size_factor, cloth_color if facing_away else SKIN)
	if not facing_away:
		var eye_color := Color(0.10, 0.08, 0.07, 0.88) if is_player else accent_color
		draw_circle(head_pos + Vector2(-1.6, -0.3) * size_factor, 0.65 * size_factor, eye_color)
		draw_circle(head_pos + Vector2(1.6, -0.3) * size_factor, 0.65 * size_factor, eye_color)

	if is_player:
		_draw_katana(size_factor, bob)
	elif _role in ["swordsman", "warden", "enemy"]:
		_draw_enemy_blade(size_factor, bob)

	var scarf_side := -1.0 if lateral >= 0.0 else 1.0
	var scarf_origin := Vector2(scarf_side * 4.5, -21.0 + bob) * size_factor
	var scarf_tip := scarf_origin + Vector2(scarf_side * 10.0, 5.0 + maxf(0.0, _facing.y) * 2.0) * size_factor
	draw_line(scarf_origin, scarf_tip, accent_color, 2.5 * size_factor, true)


func _draw_katana(size_factor: float, bob: float) -> void:
	var side := 1.0 if _facing.x >= -0.15 else -1.0
	var hand := Vector2(side * 7.0, -16.0 + bob) * size_factor
	var blade_dir := Vector2(side * 0.96, -0.25) if _is_attacking() else Vector2(side * 0.62, -0.78)
	var tip := hand + blade_dir * (23.0 * size_factor)
	draw_line(hand, tip, PLAYER_STEEL, 2.0 * size_factor, true)
	draw_line(hand - Vector2(side * 2.5, 0.0), hand + Vector2(side * 2.5, 0.0), PLAYER_ACCENT, 2.6 * size_factor, true)


func _draw_enemy_blade(size_factor: float, bob: float) -> void:
	var side := -1.0 if _facing.x < 0.0 else 1.0
	var hand := Vector2(side * 7.0, -15.0 + bob) * size_factor
	var direction := Vector2(side * 0.94, -0.24) if _is_attacking() else Vector2(side * 0.66, -0.74)
	draw_line(hand, hand + direction * (20.0 * size_factor), Color(0.62, 0.61, 0.57, 1.0), 2.0 * size_factor, true)


func _draw_bow() -> void:
	var side := 1.0 if _facing.x >= 0.0 else -1.0
	var center := Vector2(side * 8.0, -15.0)
	var points := PackedVector2Array()
	for index: int in range(9):
		var t := float(index) / 8.0
		points.append(center + Vector2(sin(t * PI) * 4.0 * side, lerpf(-11.0, 11.0, t)))
	draw_polyline(points, Color(0.38, 0.22, 0.13, 1.0), 2.0, true)
	draw_line(center + Vector2(0.0, -11.0), center + Vector2(0.0, 11.0), Color(0.72, 0.68, 0.55, 0.8), 1.0, true)


func _draw_staff(color: Color, size_factor: float) -> void:
	var side := 1.0 if _facing.x >= 0.0 else -1.0
	var base := Vector2(side * 9.0, 0.0)
	var top := Vector2(side * 11.0, -39.0) * size_factor
	draw_line(base, top, Color(0.20, 0.12, 0.08, 1.0), 2.6 * size_factor, true)
	draw_circle(top, 3.4 * size_factor, color)


func _draw_shield(size_factor: float) -> void:
	var side := -1.0 if _facing.x >= 0.0 else 1.0
	var center := Vector2(side * 11.0, -14.0) * size_factor
	var points := PackedVector2Array([
		center + Vector2(-6, -8) * size_factor, center + Vector2(6, -8) * size_factor,
		center + Vector2(7, 5) * size_factor, center + Vector2(0, 10) * size_factor,
		center + Vector2(-7, 5) * size_factor,
	])
	draw_colored_polygon(points, COURT_DARK)
	draw_polyline(PackedVector2Array([points[0], points[1], points[2], points[3], points[4], points[0]]), COURT_GOLD, 1.4 * size_factor, true)


func _draw_shogun_crest() -> void:
	var y := -49.0
	draw_line(Vector2(-10, y), Vector2(0, y - 9), COURT_GOLD, 2.2, true)
	draw_line(Vector2(0, y - 9), Vector2(10, y), COURT_GOLD, 2.2, true)


func _draw_hound(body_color: Color, size_factor: float) -> void:
	var walking := clampf(_move_speed / 180.0, 0.0, 1.0)
	var bob := absf(sin(_motion_phase)) * 0.8 * walking
	var side := 1.0 if _facing.x >= 0.0 else -1.0
	var body := PackedVector2Array([
		Vector2(-12.0, -10.0 + bob), Vector2(10.0, -11.0 + bob),
		Vector2(15.0, -4.0 + bob), Vector2(-10.0, -3.0 + bob),
	])
	for i: int in range(body.size()):
		body[i] *= size_factor
	draw_colored_polygon(body, body_color)
	var head := Vector2(side * 14.0, -12.0 + bob) * size_factor
	draw_circle(head, 5.5 * size_factor, body_color.lightened(0.15))
	draw_circle(head + Vector2(side * 2.0, -1.0) * size_factor, 1.0 * size_factor, Color(0.95, 0.16, 0.10, 0.9))
	for x: float in [-8.0, 7.0]:
		draw_line(Vector2(x, -4.0 + bob) * size_factor, Vector2(x + sin(_motion_phase + x) * 2.0, 2.0) * size_factor, ENEMY_DARK, 2.6 * size_factor, true)


func _draw_wraith(with_lantern: bool) -> void:
	var float_y := -12.0 + sin(_motion_phase * 1.35) * 1.8
	var cloth := PackedVector2Array([
		Vector2(-9, float_y - 17), Vector2(9, float_y - 17), Vector2(12, float_y + 3),
		Vector2(5, float_y - 1), Vector2(0, float_y + 7), Vector2(-6, float_y), Vector2(-12, float_y + 3),
	])
	draw_colored_polygon(cloth, Color(YOMORI_BODY.r, YOMORI_BODY.g, YOMORI_BODY.b, 0.88))
	draw_circle(Vector2(0, float_y - 23), 5.0, Color(0.11, 0.15, 0.15, 1.0))
	draw_circle(Vector2(-1.6, float_y - 23), 0.8, YOMORI_GLOW)
	draw_circle(Vector2(1.6, float_y - 23), 0.8, YOMORI_GLOW)
	if with_lantern:
		var side := 1.0 if _facing.x >= 0.0 else -1.0
		var lantern := Vector2(side * 12.0, float_y - 8.0)
		draw_line(Vector2(side * 6.0, float_y - 14.0), lantern, Color(0.25, 0.15, 0.08, 1.0), 1.8, true)
		draw_circle(lantern, 4.0, YOMORI_LANTERN)


func _draw_bilemass() -> void:
	var pulse := sin(_motion_phase * 1.4) * 0.8
	_draw_local_ellipse(Vector2(0.0, -8.0), Vector2(13.5 + pulse, 11.0 - pulse * 0.25), BILE_BODY)
	_draw_local_ellipse(Vector2(-5.0, -13.0), Vector2(5.0, 4.0), Color(0.34, 0.39, 0.20, 0.75))
	draw_circle(Vector2(5.5, -11.0), 1.3, Color(0.92, 0.26, 0.11, 0.9))


func _is_attacking() -> bool:
	for keyword: String in ["attack", "slash", "cleave", "lunge", "shoot", "fire", "cast", "bite"]:
		if _action_tag.contains(keyword):
			return true
	return false


func _draw_action_readability() -> void:
	var attacking := _is_attacking()
	var guarding := _action_tag.contains("block") or _action_tag.contains("parry") or _action_tag.contains("guard")
	if attacking:
		var cue_color := ATTACK_PLAYER if _role == "player" else ATTACK_ENEMY
		var radius := 36.0 if _role in ["rootfang", "briarthorn", "eclipse_shogun"] else 29.0
		_draw_ground_arc(radius, -0.92, 0.92, cue_color, 2.6 if _role == "player" else 2.2)
		_draw_ground_arc(radius + 4.0, 0.35, 0.92, cue_color.lightened(0.20), 1.4)
	elif guarding:
		_draw_ground_arc(20.0, -0.72, 0.72, GUARD_COLOR, 2.3)


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
