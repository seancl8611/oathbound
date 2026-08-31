extends Node2D
class_name OathboundPlaytestFxStatus

## Persistent procedural marker attached to an actor while a playtest-visible state is active.
## Pure CanvasItem drawing; it does not own or mutate gameplay state.

var style: String = ""
var fx_color: Color = Color.WHITE
var intensity: float = 1.0
var stacks: int = 1
var direction: Vector2 = Vector2.RIGHT
var _phase: float = 0.0


func _ready() -> void:
	z_index = 165
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("playtest_fx")
	queue_redraw()


func set_state(new_style: String, color: Color, new_intensity: float = 1.0, new_stacks: int = 1, new_direction: Vector2 = Vector2.RIGHT) -> void:
	style = new_style
	fx_color = color
	intensity = clampf(new_intensity, 0.0, 1.0)
	stacks = maxi(1, new_stacks)
	direction = new_direction.normalized() if new_direction.length_squared() > 0.001 else Vector2.RIGHT
	queue_redraw()


func _process(delta: float) -> void:
	_phase += delta
	queue_redraw()


func _color(alpha: float = 1.0, lighten: float = 0.0) -> Color:
	var color: Color = fx_color.lightened(lighten) if lighten > 0.0 else fx_color
	color.a *= clampf(alpha, 0.0, 1.0)
	return color


func _pulse(amount: float = 1.0) -> float:
	return 1.0 + sin(_phase * 5.0) * 0.06 * amount


func _draw() -> void:
	match style:
		"echo":
			_draw_echo()
		"rupture":
			_draw_rupture()
		"seal":
			_draw_seal(false)
		"bound":
			_draw_seal(true)
		"rift":
			_draw_rift()
		"vulnerable":
			_draw_vulnerable()
		"shock":
			_draw_shock()
		"burn":
			_draw_burn()
		"slow":
			_draw_slow()
		"deathblow":
			_draw_deathblow()
		"unseen":
			_draw_unseen()
		"umbrella":
			_draw_umbrella()
		"bloodletting":
			_draw_bloodletting()
		"aspect":
			_draw_aspect()
		_:
			pass


func _draw_echo() -> void:
	var radius: float = 19.0 * _pulse()
	var rotation: float = _phase * 1.8
	draw_arc(Vector2.ZERO, radius, rotation, rotation + 2.25, 18, _color(0.72), 1.8, true)
	draw_arc(Vector2.ZERO, radius + 5.0, rotation + PI, rotation + PI + 2.0, 16, _color(0.34, 0.22), 1.2, true)


func _draw_rupture() -> void:
	var radius: float = (22.0 + 7.0 * intensity) * _pulse(0.5)
	draw_arc(Vector2.ZERO, radius, -PI * 0.5, -PI * 0.5 + TAU * maxf(0.08, intensity), 36, _color(0.72), 2.1, true)
	for index: int in range(6):
		var angle: float = TAU * float(index) / 6.0 + 0.18
		var axis: Vector2 = Vector2(cos(angle), sin(angle))
		var side: Vector2 = axis.orthogonal()
		var inner: Vector2 = axis * 9.0
		var mid: Vector2 = axis * (15.0 + 4.0 * intensity) + side * (2.5 if index % 2 == 0 else -2.5)
		var outer: Vector2 = axis * radius
		var points := PackedVector2Array([inner, mid, outer])
		draw_polyline(points, _color(0.58, 0.16), 1.2, true)


func _draw_seal(bound: bool) -> void:
	var base_radius: float = 26.0 * _pulse(0.45)
	var ring_count: int = 3 if bound else clampi(stacks, 1, 3)
	for index: int in range(ring_count):
		var radius: float = base_radius + float(index) * 4.5
		var start: float = _phase * (0.65 + float(index) * 0.10) + float(index) * 0.9
		draw_arc(Vector2.ZERO, radius, start, start + (TAU * 0.68 if not bound else TAU), 30, _color(0.55 - float(index) * 0.07, 0.14), 1.5, true)
	if bound:
		for angle: float in [0.0, PI * 0.5, PI, PI * 1.5]:
			var axis: Vector2 = Vector2(cos(angle), sin(angle))
			draw_line(axis * 10.0, axis * 35.0, _color(0.72, 0.22), 1.8, true)
		draw_line(Vector2(-20.0, -20.0), Vector2(20.0, 20.0), _color(0.50), 1.0, true)
		draw_line(Vector2(-20.0, 20.0), Vector2(20.0, -20.0), _color(0.50), 1.0, true)


func _draw_rift() -> void:
	var radius: float = (28.0 + 3.0 * float(stacks - 1)) * _pulse()
	var rotation: float = _phase * 0.9
	for index: int in range(clampi(stacks, 1, 3)):
		var r: float = radius + float(index) * 4.0
		var points := PackedVector2Array()
		for corner: int in range(4):
			var angle: float = rotation + PI * 0.25 + float(corner) * PI * 0.5
			points.append(Vector2(cos(angle), sin(angle)) * r)
		points.append(points[0])
		draw_polyline(points, _color(0.58 - float(index) * 0.10, 0.18), 1.5, true)
	var crack := PackedVector2Array([Vector2(-5.0, -17.0), Vector2(2.0, -6.0), Vector2(-3.0, 1.0), Vector2(5.0, 10.0), Vector2(1.0, 20.0)])
	draw_polyline(crack, _color(0.86, 0.24), 2.0, true)


func _draw_vulnerable() -> void:
	var radius: float = 37.0 * _pulse(0.5)
	draw_arc(Vector2.ZERO, radius, 0.15, PI - 0.15, 26, _color(0.54), 1.7, true)
	draw_arc(Vector2.ZERO, radius, PI + 0.15, TAU - 0.15, 26, _color(0.54), 1.7, true)
	for x: float in [-8.0, 0.0, 8.0]:
		var top := Vector2(x, -44.0)
		draw_line(top, top + Vector2(-5.0, 7.0), _color(0.80, 0.16), 1.7, true)
		draw_line(top, top + Vector2(5.0, 7.0), _color(0.80, 0.16), 1.7, true)


func _draw_shock() -> void:
	var radius: float = 41.0 * _pulse()
	for index: int in range(4):
		var angle: float = TAU * float(index) / 4.0 + _phase * 0.75
		var axis: Vector2 = Vector2(cos(angle), sin(angle))
		var side: Vector2 = axis.orthogonal()
		var points := PackedVector2Array([
			axis * radius * 0.45,
			axis * radius * 0.64 + side * 4.0,
			axis * radius * 0.76 - side * 3.0,
			axis * radius,
		])
		draw_polyline(points, _color(0.76, 0.22), 1.7, true)


func _draw_burn() -> void:
	var base_y: float = 30.0
	for index: int in range(5):
		var x: float = -20.0 + float(index) * 10.0
		var height: float = 9.0 + float((index * 3) % 7) + sin(_phase * 6.0 + float(index)) * 2.0
		var flame := PackedVector2Array([
			Vector2(x - 4.0, base_y),
			Vector2(x, base_y - height),
			Vector2(x + 4.0, base_y),
		])
		draw_colored_polygon(flame, _color(0.42 + float(index % 2) * 0.08, 0.16))
	draw_arc(Vector2.ZERO, 43.0 * _pulse(0.4), 0.0, TAU, 36, _color(0.32), 1.2, true)


func _draw_slow() -> void:
	var radius: float = 48.0 * _pulse(0.35)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 40, _color(0.28), 1.1, true)
	for index: int in range(6):
		var angle: float = TAU * float(index) / 6.0 + _phase * 0.25
		var center: Vector2 = Vector2(cos(angle), sin(angle)) * radius
		var axis: Vector2 = Vector2(cos(angle), sin(angle)) * 5.0
		var side: Vector2 = axis.orthogonal()
		draw_line(center - axis, center + axis, _color(0.58, 0.20), 1.0, true)
		draw_line(center - side, center + side, _color(0.58, 0.20), 1.0, true)


func _draw_deathblow() -> void:
	var radius: float = 55.0 * _pulse()
	var points := PackedVector2Array([
		Vector2(0.0, -radius),
		Vector2(radius * 0.52, 0.0),
		Vector2(0.0, radius),
		Vector2(-radius * 0.52, 0.0),
		Vector2(0.0, -radius),
	])
	draw_polyline(points, _color(0.80, 0.20), 2.2, true)
	draw_arc(Vector2.ZERO, radius * 0.68, 0.0, TAU, 32, _color(0.34), 1.2, true)


func _draw_unseen() -> void:
	var radius: float = 34.0 * _pulse()
	for index: int in range(4):
		var start: float = _phase * 1.2 + float(index) * PI * 0.5
		draw_arc(Vector2.ZERO, radius + float(index % 2) * 5.0, start, start + 0.70, 10, _color(0.34 + float(index) * 0.06), 1.4, true)


func _draw_umbrella() -> void:
	var angle: float = direction.angle()
	var radius: float = 46.0 * _pulse(0.35)
	draw_arc(Vector2.ZERO, radius, angle - 1.32, angle + 1.32, 34, _color(0.78, 0.18), 2.5, true)
	draw_arc(Vector2.ZERO, radius - 6.0, angle - 1.22, angle + 1.22, 28, _color(0.34), 1.3, true)


func _draw_bloodletting() -> void:
	var radius: float = 38.0 * _pulse(0.5)
	draw_arc(Vector2.ZERO, radius, 0.0, TAU, 38, _color(0.38), 1.3, true)
	for index: int in range(4):
		var angle: float = TAU * float(index) / 4.0 + _phase * 0.6
		var center: Vector2 = Vector2(cos(angle), sin(angle)) * radius
		draw_circle(center, 2.5 + float(index % 2), _color(0.70, 0.14))


func _draw_aspect() -> void:
	var radius: float = 20.0 * _pulse(0.7)
	draw_arc(Vector2.ZERO, radius, _phase * 0.55, _phase * 0.55 + TAU * 0.72, 26, _color(0.24), 1.0, true)
	draw_arc(Vector2.ZERO, radius + 4.0, -_phase * 0.45, -_phase * 0.45 + TAU * 0.48, 20, _color(0.18, 0.16), 1.0, true)
