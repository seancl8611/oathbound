extends Node2D

## Ground-space readability layer for the adopted three-quarter presentation.
## Presentation only: damage, targeting, collision and AI remain owned by current combat.

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
const YOMORI_CUE := Color(0.28, 0.68, 0.58, 0.30)
const COURT_CUE := Color(0.70, 0.24, 0.12, 0.32)
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
			_draw_spawn_ripple(actor, local_pos, role)
		if not show_action_cues:
			continue

		var attacking := _is_attack_animation(animation)
		var hurt := animation.contains("hurt") or animation.contains("stagger") or animation.contains("parried")
		if attacking:
			if is_player:
				_draw_ground_ring(local_pos, 30.0, PLAYER_CUE, 1.6)
			elif role in ["archer", "court_caster", "mist_shepherd", "lantern_wraith"] and player != null:
				_draw_ranged_cue(local_pos, to_local(player.global_position), role)
			elif role == "bilemass":
				_draw_ground_ring(local_pos, 48.0, BILE_CUE, 2.0)
				_draw_ground_fill(local_pos, 38.0, Color(BILE_CUE.r, BILE_CUE.g, BILE_CUE.b, 0.07))
			elif role in ["hound", "stalker_hound"]:
				_draw_ground_ring(local_pos, 25.0, ENEMY_CUE, 2.0)
			elif role in ["rootfang", "briarthorn", "eclipse_shogun"]:
				_draw_ground_ring(local_pos, 44.0, _cue_for_role(role), 3.0)
			else:
				_draw_ground_ring(local_pos, 30.0, _cue_for_role(role), 2.0)
		elif hurt and not is_player:
			_draw_ground_ring(local_pos, 19.0, Color(0.78, 0.32, 0.20, 0.26), 1.4)


func _draw_spawn_ripple(actor: Node2D, center: Vector2, role: String) -> void:
	var actor_id := actor.get_instance_id()
	if not _spawn_ages.has(actor_id):
		return
	var age := float(_spawn_ages[actor_id])
	if age > SPAWN_LIFETIME:
		return
	var t := clampf(age / SPAWN_LIFETIME, 0.0, 1.0)
	var radius := lerpf(9.0, 31.0, t)
	var base := _cue_for_role(role)
	var alpha := (1.0 - t) * minf(0.42, base.a + 0.08)
	_draw_ground_ring(center, radius, Color(base.r, base.g, base.b, alpha), lerpf(3.0, 1.0, t))


func _draw_ranged_cue(origin: Vector2, target: Vector2, role: String) -> void:
	var color := _cue_for_role(role)
	if show_ranged_sightlines:
		var delta := target - origin
		var distance := delta.length()
		if distance > 1.0:
			var dir := delta / distance
			draw_dashed_line(origin + dir * 16.0, target - dir * 10.0, Color(color.r, color.g, color.b, 0.28), 1.2, 8.0, true)
	_draw_ground_ring(target, 17.0, Color(color.r, color.g, color.b, 0.20), 1.7)


func _cue_for_role(role: String) -> Color:
	if role in ["lingering_wraith", "lantern_wraith", "mist_shepherd", "stalker_hound", "rootfang", "briarthorn"]:
		return YOMORI_CUE
	if role in ["court_guard", "court_caster", "elite_defender", "hollow_vessel", "court_sentinel", "eclipse_shogun"]:
		return COURT_CUE
	return ENEMY_CUE


func _draw_ground_ring(center: Vector2, radius: float, color: Color, width: float) -> void:
	# True world-space circles are intentionally projected by Camera2D into screen-space
	# ellipses, preserving gameplay distance while matching the three-quarter plane.
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
	for metadata_key: StringName in [&"hushiro_enemy_type", &"yomori_enemy_type", &"kagutsuchi_enemy_type", &"enemy_type"]:
		var role := str(actor.get_meta(metadata_key, "")).to_lower()
		if not role.is_empty():
			return role
	var identity := str(actor.name).to_lower()
	var script_value: Variant = actor.get_script()
	if script_value is Script:
		identity += " " + (script_value as Script).resource_path.to_lower()
	for candidate: String in [
		"lingering_wraith", "lantern_wraith", "mist_shepherd", "stalker_hound",
		"court_guard", "court_caster", "elite_defender", "hollow_vessel", "court_sentinel",
		"eclipse_shogun", "rootfang", "briarthorn",
		"swordsman", "archer", "bilemass", "warden", "hound", "hollow",
	]:
		if identity.contains(candidate):
			return candidate
	return "enemy"


func _animation_name(actor: Node) -> String:
	var animation_player := _find_animation_player(actor)
	if animation_player == null or not animation_player.is_playing():
		return ""
	return str(animation_player.current_animation).to_lower()


func _find_animation_player(node: Node) -> AnimationPlayer:
	for child: Node in node.get_children():
		if child is AnimationPlayer:
			return child as AnimationPlayer
		var nested := _find_animation_player(child)
		if nested != null:
			return nested
	return null


func _is_attack_animation(animation: String) -> bool:
	for keyword: String in ["attack", "slash", "cleave", "lunge", "shoot", "fire", "cast", "bite", "charge"]:
		if animation.contains(keyword):
			return true
	return false
