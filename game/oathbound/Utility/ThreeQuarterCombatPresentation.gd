extends Node2D

## Ground-space readability layer for the adopted three-quarter presentation.
##
## This node never participates in damage, targeting, collision or AI. It observes the
## existing combat actors and renders projected arrival/action cues underneath them so
## the current combat remains legible while production VFX are rebuilt for the new POV.

@export var enabled := true
@export var show_spawn_ripples := true
@export var show_action_cues := true
@export var show_ranged_sightlines := true

const SPAWN_LIFETIME := 0.72
const ENEMY_CUE := Color(0.78, 0.105, 0.075, 0.46)
const ENEMY_CUE_SOFT := Color(0.60, 0.085, 0.065, 0.20)
const PLAYER_CUE := Color(0.72, 0.80, 0.84, 0.32)
const SPAWN_CUE := Color(0.63, 0.16, 0.105, 0.42)
const RANGED_LINE := Color(0.82, 0.22, 0.14, 0.26)
const BILE_CUE := Color(0.43, 0.58, 0.18, 0.28)

var _spawn_ages: Dictionary = {}
var _scan_left := 0.0
var _presentation_active := true


func _ready() -> void:
	z_index = 900
	set_process(true)


func set_presentation_active(active: bool) -> void:
	_presentation_active = active
	visible = active
	queue_redraw()


func _process(dt: float) -> void:
	if not enabled or not _presentation_active:
		return

	for id_value: Variant in _spawn_ages.keys():
		_spawn_ages[id_value] = float(_spawn_ages[id_value]) + dt

	_scan_left -= dt
	if _scan_left <= 0.0:
		_scan_left = 0.08
		_refresh_actor_registry()
	queue_redraw()


func _refresh_actor_registry() -> void:
	var current_ids: Dictionary = {}
	for actor: Node2D in _actors():
		var actor_id := actor.get_instance_id()
		current_ids[actor_id] = true
		if not _spawn_ages.has(actor_id):
			_spawn_ages[actor_id] = 0.0

	for id_value: Variant in _spawn_ages.keys():
		if not current_ids.has(id_value):
			_spawn_ages.erase(id_value)


func _actors() -> Array[Node2D]:
	var out: Array[Node2D] = []
	var tree := get_tree()
	if tree == null:
		return out
	for group_name: StringName in [&"player", &"enemy"]:
		for candidate: Node in tree.get_nodes_in_group(group_name):
			if is_instance_valid(candidate) and candidate is Node2D:
				out.append(candidate as Node2D)
	return out


func _draw() -> void:
	if not enabled or not _presentation_active:
		return

	var player := _find_player()
	for actor: Node2D in _actors():
		var local_pos := to_local(actor.global_position)
		var is_player := actor.is_in_group("player")
		var role := _role_for(actor)
		var animation := _animation_name(actor)

		if show_spawn_ripples and not is_player:
			_draw_spawn_ripple(actor, local_pos)

		if not show_action_cues:
			continue

		var attacking := _is_attack_animation(animation)
		var hurt := animation.contains("hurt") or animation.contains("stagger")
		if attacking:
			if is_player:
				_draw_ground_ring(local_pos, 30.0, PLAYER_CUE, 1.6)
			elif role == "archer" and player != null:
				_draw_archer_cue(local_pos, to_local(player.global_position))
			elif role == "bilemass":
				_draw_ground_ring(local_pos, 48.0, BILE_CUE, 2.0)
				_draw_ground_fill(local_pos, 38.0, Color(BILE_CUE.r, BILE_CUE.g, BILE_CUE.b, 0.07))
			elif role == "hound":
				_draw_ground_ring(local_pos, 25.0, ENEMY_CUE, 2.0)
			else:
				_draw_ground_ring(local_pos, 30.0, ENEMY_CUE, 2.0)
		elif hurt and not is_player:
			_draw_ground_ring(local_pos, 19.0, Color(0.78, 0.32, 0.20, 0.26), 1.4)


func _draw_spawn_ripple(actor: Node2D, center: Vector2) -> void:
	var actor_id := actor.get_instance_id()
	if not _spawn_ages.has(actor_id):
		return
	var age := float(_spawn_ages[actor_id])
	if age > SPAWN_LIFETIME:
		return
	var t := clampf(age / SPAWN_LIFETIME, 0.0, 1.0)
	var radius := lerpf(9.0, 31.0, t)
	var alpha := (1.0 - t) * SPAWN_CUE.a
	_draw_ground_ring(center, radius, Color(SPAWN_CUE.r, SPAWN_CUE.g, SPAWN_CUE.b, alpha), lerpf(3.0, 1.0, t))


func _draw_archer_cue(origin: Vector2, target: Vector2) -> void:
	if show_ranged_sightlines:
		var delta := target - origin
		var distance := delta.length()
		if distance > 1.0:
			var dir := delta / distance
			var start := origin + dir * 16.0
			var finish := target - dir * 10.0
			draw_dashed_line(start, finish, RANGED_LINE, 1.2, 8.0, true)
	_draw_ground_ring(target, 17.0, ENEMY_CUE_SOFT, 1.7)


func _draw_ground_ring(center: Vector2, radius: float, color: Color, width: float) -> void:
	# This node lives in world space. CameraFollow's non-uniform zoom naturally projects
	# these true combat-space circles into the correct on-screen ellipses.
	draw_arc(center, radius, 0.0, TAU, 40, color, width, true)


func _draw_ground_fill(center: Vector2, radius: float, color: Color) -> void:
	var points := PackedVector2Array()
	for index: int in range(32):
		var angle := TAU * float(index) / 32.0
		points.append(center + Vector2(cos(angle), sin(angle)) * radius)
	draw_colored_polygon(points, color)


func _find_player() -> Node2D:
	var tree := get_tree()
	if tree == null:
		return null
	var player := tree.get_first_node_in_group("player")
	return player as Node2D if player is Node2D else null


func _role_for(actor: Node2D) -> String:
	if actor.is_in_group("player"):
		return "player"
	var metadata_role := str(actor.get_meta("hushiro_enemy_type", "")).to_lower()
	if not metadata_role.is_empty():
		return metadata_role
	var lowered := str(actor.name).to_lower()
	for candidate: String in ["swordsman", "archer", "hound", "hollow", "bilemass", "warden"]:
		if lowered.contains(candidate):
			return candidate
	return "enemy"


func _animation_name(actor: Node) -> String:
	var animation_player := _find_animation_player(actor)
	return str(animation_player.current_animation).to_lower() if animation_player != null else ""


func _find_animation_player(node: Node) -> AnimationPlayer:
	for child: Node in node.get_children():
		if child is AnimationPlayer:
			return child as AnimationPlayer
		var nested := _find_animation_player(child)
		if nested != null:
			return nested
	return null


func _is_attack_animation(animation: String) -> bool:
	for keyword: String in ["attack", "slash", "cleave", "lunge", "shoot", "fire", "cast", "bite"]:
		if animation.contains(keyword):
			return true
	return false
