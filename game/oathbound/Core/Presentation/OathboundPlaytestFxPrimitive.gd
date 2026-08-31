extends Node2D
class_name OathboundPlaytestFxPrimitive

## Debug/playtest-only procedural world-space FX primitive.
## Uses CanvasItem drawing only: no textures, spritesheets, shaders, or external art.

var kind: String = "ring"
var fx_color: Color = Color.WHITE
var accent_color: Color = Color.WHITE
var duration: float = 0.35
var radius: float = 40.0
var start_radius: float = 6.0
var line_width: float = 2.0
var direction: Vector2 = Vector2.RIGHT
var length: float = 80.0
var spread: float = deg_to_rad(70.0)
var local_points: PackedVector2Array = PackedVector2Array()
var persistent: bool = false

var _elapsed: float = 0.0
var _phase: float = 0.0


func configure(
		effect_kind: String,
		color: Color,
		effect_duration: float = 0.35,
		effect_radius: float = 40.0,
		effect_direction: Vector2 = Vector2.RIGHT,
		effect_length: float = 80.0,
		effect_spread: float = 1.20,
		keep_alive: bool = false
	) -> void:
	kind = effect_kind
	fx_color = color
	accent_color = color.lightened(0.28)
	duration = maxf(0.04, effect_duration)
	radius = maxf(4.0, effect_radius)
	direction = effect_direction.normalized() if effect_direction.length_squared() > 0.001 else Vector2.RIGHT
	length = maxf(4.0, effect_length)
	spread = maxf(0.10, effect_spread)
	persistent = keep_alive
	queue_redraw()


func _ready() -> void:
	z_index = 180
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("playtest_fx")
	queue_redraw()


func _process(delta: float) -> void:
	_elapsed += delta
	_phase += delta
	if not persistent and _elapsed >= duration:
		queue_free()
		return
	queue_redraw()


func _progress() -> float:
	if persistent:
		return 0.5 + sin(_phase * 4.0) * 0.08
	return clampf(_elapsed / maxf(duration, 0.001), 0.0, 1.0)


func _alpha() -> float:
	if persistent:
		return 0.58 + sin(_phase * 5.0) * 0.12
	return pow(1.0 - _progress(), 0.65)


func _color(alpha_scale: float = 1.0, accent: bool = false) -> Color:
	var color: Color = accent_color if accent else fx_color
	color.a *= clampf(_alpha() * alpha_scale, 0.0, 1.0)
	return color


func _draw() -> void:
	match kind:
		"ring":
			_draw_ring()
		"burst":
			_draw_burst()
		"slash":
			_draw_slash()
		"line":
			_draw_line_fx(false)
		"chain":
			_draw_line_fx(true)
		"cone":
			_draw_cone()
		"smoke":
			_draw_smoke()
		"shield":
			_draw_shield()
		"trail":
			_draw_trail()
		"howl":
			_draw_howl()
		"corridor":
			_draw_corridor()
		_:
			_draw_ring()


func _draw_ring() -> void:
	var p: float = _progress()
	var current_radius: float = lerpf(start_radius, radius, p)
	draw_arc(Vector2.ZERO, current_radius, 0.0, TAU, 48, _color(), line_width, true)
	draw_arc(Vector2.ZERO, maxf(2.0, current_radius - 5.0), 0.0, TAU, 40, _color(0.45, true), 1.0, true)


func _draw_burst() -> void:
	var p: float = _progress()
	var current_radius: float = lerpf(radius * 0.18, radius, p)
	draw_arc(Vector2.ZERO, current_radius, 0.0, TAU, 48, _color(0.90), line_width + 0.7, true)
	for index: int in range(12):
		var angle: float = TAU * float(index) / 12.0 + _phase * 0.35
		var inner: Vector2 = Vector2(cos(angle), sin(angle)) * current_radius * 0.45
		var outer: Vector2 = Vector2(cos(angle), sin(angle)) * current_radius * (0.90 + 0.08 * float(index % 3))
		draw_line(inner, outer, _color(0.75, index % 2 == 0), maxf(1.0, line_width - 0.3), true)
	draw_circle(Vector2.ZERO, maxf(2.0, radius * 0.09 * (1.0 - p)), _color(0.55, true))


func _draw_slash() -> void:
	var p: float = _progress()
	var angle: float = direction.angle()
	var slash_radius: float = radius * (0.86 + p * 0.18)
	var half_arc: float = spread * 0.5
	draw_arc(Vector2.ZERO, slash_radius, angle - half_arc, angle + half_arc, 24, _color(), line_width + 1.4, true)
	draw_arc(Vector2.ZERO, slash_radius - 6.0, angle - half_arc * 0.92, angle + half_arc * 0.92, 20, _color(0.45, true), 1.4, true)
	var tip: Vector2 = direction.rotated(-half_arc) * slash_radius
	draw_circle(tip, 2.0 + 2.0 * (1.0 - p), _color(0.75, true))


func _draw_line_fx(chain: bool) -> void:
	var end: Vector2 = direction * length
	draw_line(Vector2.ZERO, end, _color(), line_width + (0.8 if chain else 0.0), true)
	draw_line(Vector2.ZERO, end, _color(0.35, true), maxf(1.0, line_width * 0.45), true)
	if chain:
		var normal: Vector2 = direction.orthogonal()
		for index: int in range(1, 9):
			var t: float = float(index) / 9.0
			var center: Vector2 = end * t
			var offset: float = 4.0 if index % 2 == 0 else -4.0
			draw_line(center - normal * 4.0 + direction * offset, center + normal * 4.0 + direction * offset, _color(0.75, true), 1.0, true)
	else:
		for index: int in range(1, 6):
			var t: float = float(index) / 6.0
			draw_circle(end * t, 1.6, _color(0.65, index % 2 == 0))


func _draw_cone() -> void:
	var angle: float = direction.angle()
	var half: float = spread * 0.5
	var outer_color: Color = _color(0.75)
	draw_arc(Vector2.ZERO, radius, angle - half, angle + half, 28, outer_color, line_width, true)
	draw_line(Vector2.ZERO, direction.rotated(-half) * radius, _color(0.55), 1.2, true)
	draw_line(Vector2.ZERO, direction.rotated(half) * radius, _color(0.55), 1.2, true)
	for index: int in range(5):
		var t: float = (float(index) + 0.5) / 5.0
		var ray_angle: float = lerpf(angle - half * 0.82, angle + half * 0.82, t)
		var ray_dir: Vector2 = Vector2(cos(ray_angle), sin(ray_angle))
		draw_line(ray_dir * radius * 0.20, ray_dir * radius * (0.58 + 0.06 * float(index % 2)), _color(0.42, true), 1.1, true)


func _draw_smoke() -> void:
	for index: int in range(10):
		var angle: float = TAU * float(index) / 10.0 + sin(_phase * 0.7 + float(index)) * 0.18
		var orbit: float = radius * (0.22 + 0.055 * float(index % 5))
		var center: Vector2 = Vector2(cos(angle), sin(angle)) * orbit
		center += Vector2(0.0, sin(_phase * 1.8 + float(index) * 0.9) * 5.0)
		var puff: float = radius * (0.17 + 0.025 * float(index % 4))
		draw_circle(center, puff, _color(0.10 + 0.018 * float(index % 3), index % 3 == 0))
	draw_arc(Vector2.ZERO, radius * 0.92, 0.0, TAU, 40, _color(0.22), 1.2, true)


func _draw_shield() -> void:
	var angle: float = direction.angle()
	var shield_radius: float = radius * (0.95 + sin(_phase * 7.0) * 0.04)
	draw_arc(Vector2.ZERO, shield_radius, angle - 1.28, angle + 1.28, 32, _color(), line_width + 1.6, true)
	draw_arc(Vector2.ZERO, shield_radius - 6.0, angle - 1.18, angle + 1.18, 28, _color(0.42, true), 1.2, true)
	for offset: float in [-0.75, 0.0, 0.75]:
		var spoke: Vector2 = Vector2(cos(angle + offset), sin(angle + offset)) * shield_radius
		draw_line(Vector2.ZERO, spoke, _color(0.24, true), 1.0, true)


func _draw_trail() -> void:
	if local_points.size() < 2:
		return
	draw_polyline(local_points, _color(), line_width + 1.8, true)
	var ghost: PackedVector2Array = PackedVector2Array()
	var normal: Vector2 = Vector2.ZERO
	if local_points.size() >= 2:
		var axis: Vector2 = (local_points[local_points.size() - 1] - local_points[0]).normalized()
		normal = axis.orthogonal() * 4.0
	for point: Vector2 in local_points:
		ghost.append(point + normal)
	draw_polyline(ghost, _color(0.32, true), 1.1, true)


func _draw_howl() -> void:
	var p: float = _progress()
	var current_radius: float = lerpf(radius * 0.24, radius, p)
	draw_arc(Vector2.ZERO, current_radius, 0.0, TAU, 48, _color(), line_width + 0.8, true)
	for index: int in range(16):
		var angle: float = TAU * float(index) / 16.0
		var axis: Vector2 = Vector2(cos(angle), sin(angle))
		var inner: Vector2 = axis * current_radius * 0.82
		var outer: Vector2 = axis * current_radius * (1.08 + 0.06 * float(index % 2))
		draw_line(inner, outer, _color(0.68, index % 2 == 0), 1.4, true)


func _draw_corridor() -> void:
	var axis: Vector2 = direction.normalized()
	var normal: Vector2 = axis.orthogonal()
	var half_width: float = radius
	var end: Vector2 = axis * length
	draw_line(normal * half_width, end + normal * half_width, _color(0.50), 1.4, true)
	draw_line(-normal * half_width, end - normal * half_width, _color(0.50), 1.4, true)
	draw_line(Vector2.ZERO, end, _color(0.82, true), line_width + 0.6, true)
	for index: int in range(1, 7):
		var t: float = float(index) / 7.0
		var center: Vector2 = end * t
		draw_line(center - normal * half_width * 0.70, center + normal * half_width * 0.70, _color(0.22), 1.0, true)
