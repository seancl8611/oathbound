extends BeastEnemyBase
class_name CellarBilemass

## =============================================================================
## CELLAR BILEMASS - Beast Area-Denial Enemy
## =============================================================================
## Role:
## - Non-blocking creature enemy
## - Skitters around the player instead of dueling
## - Spits delayed puddles at random positions near the player
## - Puddles apply DoT + slow and bypass block/parry
## - Uses BeastEnemyBase for shared refs, no-blocking behavior, damage intake,
##   stance/prosthetic ticking, hitstop, knockback, aggro fields, and cleanup.
## =============================================================================

# =============================================================================
# INDICATOR TEXTURES
# =============================================================================

@export_group("Landing Indicator Textures")
@export var indicator_light_red: Texture2D = null
@export var indicator_medium_red: Texture2D = null
@export var indicator_dark_red: Texture2D = null


# =============================================================================
# CORE TUNING
# =============================================================================

@export_group("Cellar Bilemass Stats")
@export var bilemass_hp: int = 80
@export var bilemass_experience: int = 2
@export var bilemass_move_speed: float = 55.0

@export_group("Spit Attack")
@export var spit_travel_time: float = 3.0
@export var spit_cd_min: float = 1.9
@export var spit_cd_max: float = 2.5
@export var spit_windup_duration: float = 0.30
@export var spit_vomit_duration: float = 0.45

@export var aim_radius_min: float = 140.0
@export var aim_radius_max: float = 260.0
@export var aim_jitter_px: float = 24.0

@export var require_melee_pressure: bool = false

@export_group("Puddle")
@export var puddle_lifetime: float = 3.5
@export var puddle_radius: float = 56.0
@export var dot_tick: float = 0.25
@export var dot_damage_per_tick: float = 0.5
@export var puddle_slow_pct: float = 0.50

@export var max_puddles_per_enemy: int = 2
@export var room_puddle_cap: int = 8

@export_group("Movement")
@export var skitter_speed_multiplier: float = 1.5
@export var orbit_speed_mul: float = 1.35
@export var pre_aggro_speed_multiplier: float = 0.45
@export var skitter_goal_min: float = 110.0
@export var skitter_goal_max: float = 170.0

@export_group("Rewards")
@export var exp_gem_scene: PackedScene = null


# =============================================================================
# INTERNAL STATE
# =============================================================================

var player_in_range: bool = false
var player_in_range2: bool = false

var _active_puddles: int = 0
var _spit_gen: int = 0

var _flip_until: float = 0.0
var _lateral_sign: float = 1.0

var _spawn_pos: Vector2 = Vector2.ZERO
var _patrol_goal: Vector2 = Vector2.ZERO
var _next_patrol_repick: float = 0.0

var _last_pos: Vector2 = Vector2.ZERO
var _last_move_speed: float = 0.0
var _last_move_dir: Vector2 = Vector2.ZERO
var _no_progress_time: float = 0.0
var _last_goal_dist: float = 0.0

var _escape_until: float = 0.0
var _escape_dir: Vector2 = Vector2.ZERO

var _range2_radius: float = -1.0
var _pending_spit_indicator: Node2D = null

var _current_anim: String = ""

signal remove_from_array(object)


const AKAN_WALK_DUR: float = 0.60
const AKAN_IDLE_DUR: float = 0.60
const AKAN_HURT_DUR: float = 0.28
const AKAN_DEATH_DUR: float = 0.70


# =============================================================================
# PUDDLE CLASS
# =============================================================================

class AkanamePuddle extends Area2D:
	var radius: float = 56.0
	var dot_tick: float = 0.25
	var damage_per_tick: float = 0.5
	var slow_pct: float = 0.50
	var lifetime: float = 3.5
	var tex: Texture2D = null

	var _players_inside: Array[Node] = []
	var _dmg_accum: Dictionary = {}

	func _ready() -> void:
		name = "AkanamePuddle"
		monitoring = true
		monitorable = true
		add_to_group("puddle_hazard")
		set_meta("slow_pct", slow_pct)

		for i in range(1, 33):
			set_collision_layer_value(i, false)
			set_collision_mask_value(i, false)

		set_collision_layer_value(1, true)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)

		if get_node_or_null("CollisionShape2D") == null:
			var cs := CollisionShape2D.new()
			var circle := CircleShape2D.new()
			circle.radius = radius
			cs.shape = circle
			add_child(cs)

		if tex:
			var spr := Sprite2D.new()
			spr.texture = tex
			spr.centered = true
			spr.modulate = Color(1, 1, 1, 0.32)
			add_child(spr)

			var ts := tex.get_size()
			if ts.x > 0 and ts.y > 0:
				spr.scale = Vector2((radius * 2.0) / ts.x, (radius * 2.0) / ts.y)

			var tw := create_tween()
			tw.set_loops()
			tw.set_trans(Tween.TRANS_SINE)
			tw.set_ease(Tween.EASE_IN_OUT)
			tw.tween_property(spr, "modulate:a", 0.20, 0.55)
			tw.tween_property(spr, "modulate:a", 0.32, 0.55)

		body_entered.connect(Callable(self, "_on_body_entered"))
		body_exited.connect(Callable(self, "_on_body_exited"))
		area_entered.connect(Callable(self, "_on_area_entered"))
		area_exited.connect(Callable(self, "_on_area_exited"))

		var tick := Timer.new()
		tick.wait_time = dot_tick
		tick.one_shot = false
		tick.autostart = true
		add_child(tick)
		tick.timeout.connect(Callable(self, "_on_tick"))

		var life := Timer.new()
		life.wait_time = lifetime
		life.one_shot = true
		life.autostart = true
		add_child(life)
		life.timeout.connect(Callable(self, "_expire"))

	func _resolve_player(n: Node) -> Node:
		if not is_instance_valid(n):
			return null

		if n.is_in_group("player"):
			return n

		var p := n.get_parent()
		if is_instance_valid(p) and p.is_in_group("player"):
			return p

		return null

	func _track_enter(n: Node) -> void:
		var pl := _resolve_player(n)
		if pl == null:
			return

		if not _players_inside.has(pl):
			_players_inside.append(pl)

		_apply_slow(pl)

	func _track_exit(n: Node) -> void:
		var pl := _resolve_player(n)
		if pl == null:
			return

		if _players_inside.has(pl):
			_players_inside.erase(pl)

		_recompute_slow(pl)
		_dmg_accum.erase(pl.get_instance_id())

	func _on_body_entered(body: Node2D) -> void:
		_track_enter(body)

	func _on_body_exited(body: Node2D) -> void:
		_track_exit(body)

	func _on_area_entered(area: Area2D) -> void:
		_track_enter(area)
		if area and area.get_parent():
			_track_enter(area.get_parent())

	func _on_area_exited(area: Area2D) -> void:
		_track_exit(area)
		if area and area.get_parent():
			_track_exit(area.get_parent())

	func _apply_slow(player_node: Node) -> void:
		if not is_instance_valid(player_node):
			return

		var current := float(player_node.get_meta("puddle_slow_amount", 0.0))
		if slow_pct > current:
			player_node.set_meta("puddle_slow_amount", slow_pct)

	func _player_is_in_puddle(puddle: Area2D, player_node: Node) -> bool:
		if not is_instance_valid(puddle) or not is_instance_valid(player_node):
			return false

		if puddle.has_method("get_overlapping_bodies"):
			if puddle.get_overlapping_bodies().has(player_node):
				return true

		if player_node.has_node("HurtBox") and puddle.has_method("get_overlapping_areas"):
			var hb := player_node.get_node("HurtBox")
			if puddle.get_overlapping_areas().has(hb):
				return true

		return false

	func _recompute_slow(player_node: Node) -> void:
		if not is_instance_valid(player_node):
			return

		var best := 0.0

		for h in get_tree().get_nodes_in_group("puddle_hazard"):
			if not is_instance_valid(h) or not (h is Area2D):
				continue

			var a := h as Area2D
			if not a.monitoring:
				continue

			if _player_is_in_puddle(a, player_node):
				var s := 0.0
				if a.has_meta("slow_pct"):
					s = float(a.get_meta("slow_pct"))
				best = max(best, s)

		player_node.set_meta("puddle_slow_amount", best)

	func _on_tick() -> void:
		for pl in _players_inside:
			if not is_instance_valid(pl):
				continue

			_apply_slow(pl)

			var invincible = pl.get("is_invincible")
			if invincible != null and bool(invincible):
				continue

			_apply_dot_to_player(pl)

	func _apply_dot_to_player(target: Node) -> void:
		var id := target.get_instance_id()
		var acc := float(_dmg_accum.get(id, 0.0))
		acc += damage_per_tick

		var dmg_int := int(floor(acc))
		if dmg_int > 0:
			if target.has_method("take_damage"):
				target.take_damage(dmg_int, false)
			else:
				var hp_value = target.get("hp")
				if hp_value != null:
					target.set("hp", max(0, int(hp_value) - dmg_int))

			acc -= float(dmg_int)

		_dmg_accum[id] = acc

		if target.has_method("_flash_player"):
			target._flash_player(Color(0.5, 0.8, 0.3, 0.35), 0.05)

	func _expire() -> void:
		for pl in _players_inside:
			if is_instance_valid(pl):
				_recompute_slow(pl)

		queue_free()


# =============================================================================
# INITIALIZATION
# =============================================================================

func _ready() -> void:
	_apply_bilemass_defaults()
	_load_default_assets_if_needed()

	super._ready()

	beast_attack_role = "cellar_bilemass_spit"
	beast_face_player = false

	_spawn_pos = global_position
	_pick_patrol_goal()
	global_position = _patrol_goal
	_last_pos = global_position

	_resolve_player_reference()

	call_deferred("_connect_range_signals")
	call_deferred("_sync_attack_range_from_Range2")

	print("[CellarBilemass] v1.0 - BeastEnemyBase area-denial enemy")


func _apply_bilemass_defaults() -> void:
	if hp == 200:
		hp = bilemass_hp

	if experience == 1:
		experience = bilemass_experience

	if movement_speed == 55.0:
		movement_speed = bilemass_move_speed


func _load_default_assets_if_needed() -> void:
	if indicator_light_red == null:
		var path := "res://Textures/Enemy/indicator1.png"
		if ResourceLoader.exists(path):
			indicator_light_red = load(path) as Texture2D

	if indicator_medium_red == null:
		var path := "res://Textures/Enemy/indicator2.png"
		if ResourceLoader.exists(path):
			indicator_medium_red = load(path) as Texture2D

	if indicator_dark_red == null:
		var path := "res://Textures/Enemy/indicator3.png"
		if ResourceLoader.exists(path):
			indicator_dark_red = load(path) as Texture2D

	if exp_gem_scene == null:
		var paths := [
			"res://Objects/experience_gem.tscn",
			"res://Objects/ExperienceGem.tscn",
			"res://Items/experience_gem.tscn"
		]

		for path in paths:
			if ResourceLoader.exists(path):
				exp_gem_scene = load(path) as PackedScene
				return


func _resolve_player_reference() -> void:
	var players := get_tree().get_nodes_in_group("player")
	for n in players:
		if n.has_node("HurtBox"):
			player = n as Node2D
			return


# =============================================================================
# MAIN LOOP
# =============================================================================

func _physics_process(delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001

	if has_died:
		return

	_sync_attack_director_roles(now)

	if _beast_tick_shared(delta):
		_ensure_move_anim()
		return

	if not is_instance_valid(player):
		_pre_aggro_patrol(delta)
		return

	if now < _backoff_until:
		_pre_aggro_patrol(delta)
		return

	# Pre-aggro patrol
	if not _saw_player_once and not auto_aggro_on_spawn:
		_pre_aggro_patrol(delta)
		return

	_skitter_combat_move(delta, now)
	_try_spit_from_commit_window(now)

	if combat:
		combat.update_host_state(false, false, false, _last_move_speed > 10.0)
		combat.tick(delta)


func _skitter_combat_move(delta: float, now: float) -> void:
	var ms := _ms()
	var to_p := player.global_position - global_position
	var dist := to_p.length()
	var dir = to_p / max(dist, 0.0001)

	var dist_to_goal := global_position.distance_to(_patrol_goal)
	var goal_expired := now >= _next_patrol_repick

	if _last_goal_dist <= 0.001:
		_last_goal_dist = dist_to_goal
	elif dist_to_goal < _last_goal_dist - 2.0:
		_no_progress_time = 0.0
		_last_goal_dist = dist_to_goal
	else:
		_no_progress_time += delta

	if (goal_expired or _no_progress_time > 0.5) and now >= _escape_until:
		_patrol_goal = _choose_skitter_goal(dir, dist)
		_next_patrol_repick = now + randf_range(0.9, 1.3)
		_last_goal_dist = global_position.distance_to(_patrol_goal)
		_no_progress_time = 0.0

	var v_target := Vector2.ZERO
	if now < _escape_until:
		v_target = _escape_dir * ms
	else:
		v_target = (_patrol_goal - global_position).normalized() * ms

	velocity = velocity.lerp(v_target, 0.12)

	var before := global_position
	move_and_slide()
	var moved := global_position - before

	_last_move_speed = moved.length() / max(0.0001, delta)
	_last_move_dir = moved

	var room := _get_room_rect()
	if room.size != Vector2.ZERO and now >= _escape_until:
		var edges := _near_edges(room, 8.0)
		var near_h: bool = edges["L"] or edges["R"]
		var near_v: bool = edges["T"] or edges["B"]

		if near_h and near_v:
			_start_corner_escape_by_edges(edges)
		elif get_slide_collision_count() > 0:
			var col := get_slide_collision(0)
			if col:
				_start_escape(col.get_normal(), dir)
				_no_progress_time = 0.0
				_last_goal_dist = global_position.distance_to(_patrol_goal)

	if _no_progress_time > 0.35 and now >= _escape_until:
		_patrol_goal = _choose_skitter_goal(dir, dist)
		_next_patrol_repick = now + randf_range(0.9, 1.3)
		_last_goal_dist = global_position.distance_to(_patrol_goal)
		_no_progress_time = 0.0

	_update_motion_facing(now, moved)
	_ensure_move_anim()


func _try_spit_from_commit_window(now: float) -> void:
	var can_spit := not beast_is_attacking and now >= beast_next_attack_time
	var near_commit_end := (_next_patrol_repick - now) < 0.12
	var near_goal := global_position.distance_to(_patrol_goal) < 12.0

	if can_spit and player_in_range2 and (near_goal or near_commit_end):
		_perform_spit_tokened()


# =============================================================================
# RANGE SIGNALS
# =============================================================================

func _connect_range_signals() -> void:
	if has_node("Range"):
		var r := $Range

		if not r.is_connected("body_entered", Callable(self, "_on_Range_body_entered")):
			r.connect("body_entered", Callable(self, "_on_Range_body_entered"))

		if not r.is_connected("body_exited", Callable(self, "_on_Range_body_exited")):
			r.connect("body_exited", Callable(self, "_on_Range_body_exited"))

		if r.has_method("get_overlapping_bodies"):
			for b in r.get_overlapping_bodies():
				if b.is_in_group("player"):
					player_in_range = true
					break

	if has_node("Range2"):
		var r2 := $Range2

		if not r2.is_connected("body_entered", Callable(self, "_on_Range2_body_entered")):
			r2.connect("body_entered", Callable(self, "_on_Range2_body_entered"))

		if not r2.is_connected("body_exited", Callable(self, "_on_Range2_body_exited")):
			r2.connect("body_exited", Callable(self, "_on_Range2_body_exited"))

		if r2.has_method("get_overlapping_bodies"):
			for b in r2.get_overlapping_bodies():
				if b.is_in_group("player"):
					player_in_range2 = true
					break

	var cs = get_node_or_null("Range2/CollisionShape2D")
	if cs and cs.shape and not cs.shape.is_connected("changed", Callable(self, "_on_range2_shape_changed")):
		cs.shape.connect("changed", Callable(self, "_on_range2_shape_changed"))


func _on_Range_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		_saw_player_once = true


func _on_Range_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false


func _on_Range2_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range2 = true
		_saw_player_once = true


func _on_Range2_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range2 = false


func _sync_attack_range_from_Range2() -> void:
	var cs = get_node_or_null("Range2/CollisionShape2D")
	_range2_radius = -1.0

	if cs and cs.shape:
		if cs.shape is CircleShape2D:
			_range2_radius = cs.shape.radius
		elif cs.shape is RectangleShape2D:
			_range2_radius = min(cs.shape.size.x, cs.shape.size.y) * 0.5
		elif cs.shape is CapsuleShape2D:
			_range2_radius = cs.shape.radius + cs.shape.height * 0.5


func _on_range2_shape_changed() -> void:
	_sync_attack_range_from_Range2()


# =============================================================================
# SPIT ATTACK
# =============================================================================

func _perform_spit_tokened() -> void:
	if _player_hidden_in_smoke():
		beast_next_attack_time = Time.get_ticks_msec() * 0.001 + 0.25
		return

	if require_melee_pressure and AttackDir != null and AttackDir.has_method("count_role"):
		if AttackDir.count_role("melee_attack") <= 0:
			return

	var now0 := Time.get_ticks_msec() * 0.001

	if _active_puddles >= int(max_puddles_per_enemy):
		beast_next_attack_time = now0 + 0.35
		return

	if _room_puddle_count() >= int(room_puddle_cap):
		beast_next_attack_time = now0 + 0.35
		return

	if not _request_ranged_role():
		return

	beast_is_attacking = true
	_bump_attack_gen()
	var my_attack_gen := _attack_gen

	velocity = Vector2.ZERO

	_play_anim_exact("attack_windup", spit_windup_duration, true)
	await get_tree().create_timer(spit_windup_duration).timeout

	if not is_inside_tree() or my_attack_gen != _attack_gen:
		return

	if _player_hidden_in_smoke():
		_abort_spit()
		beast_next_attack_time = Time.get_ticks_msec() * 0.001 + 0.35
		return

	if not is_instance_valid(player):
		_abort_spit()
		return

	var target_pos := _pick_random_target_point(player.global_position)

	if is_instance_valid(_pending_spit_indicator):
		_pending_spit_indicator.queue_free()

	_pending_spit_indicator = _spawn_landing_indicator(target_pos, spit_travel_time)

	if is_instance_valid(sprite):
		sprite.flip_h = target_pos.x < global_position.x
		_flip_until = Time.get_ticks_msec() * 0.001 + spit_vomit_duration

	_play_anim_exact("shoot", spit_vomit_duration, true)
	await get_tree().create_timer(spit_vomit_duration).timeout

	if not is_inside_tree() or my_attack_gen != _attack_gen:
		return

	_ensure_move_anim()

	await get_tree().create_timer(spit_travel_time).timeout

	if not is_inside_tree() or my_attack_gen != _attack_gen:
		_abort_spit()
		return

	_spawn_puddle_inline(target_pos)

	var now2 := Time.get_ticks_msec() * 0.001
	beast_next_attack_time = now2 + randf_range(spit_cd_min, spit_cd_max)
	beast_recovery_until = now2 + beast_recovery_time

	_abort_spit()


func _request_ranged_role() -> bool:
	if has_attack_token:
		return true

	if _request_role("ranged_attack"):
		has_attack_token = true
		return true

	return false


func _release_ranged_role() -> void:
	if has_attack_token:
		_release_role("ranged_attack")

	has_attack_token = false


func _abort_spit() -> void:
	_bump_attack_gen()

	if is_instance_valid(_pending_spit_indicator):
		_pending_spit_indicator.queue_free()

	_pending_spit_indicator = null
	beast_is_attacking = false

	_release_ranged_role()
	_set_anim_speed_safe(1.0)


func _on_beast_attack_director_revoked(_now: float) -> void:
	_abort_spit()
	_backoff_until = max(_backoff_until, Time.get_ticks_msec() * 0.001 + 0.45)


func _pick_random_target_point(center: Vector2) -> Vector2:
	var max_ring := aim_radius_max

	if _range2_radius > 0.0:
		max_ring = min(max_ring, _range2_radius * 0.5)

	var min_ring = min(aim_radius_min, max_ring * 0.6)

	var r := randf_range(min_ring, max_ring)
	var a := randf() * TAU
	var p := center + Vector2(cos(a), sin(a)) * r

	if aim_jitter_px > 0.0:
		p += Vector2(
			randf_range(-aim_jitter_px, aim_jitter_px),
			randf_range(-aim_jitter_px, aim_jitter_px)
		)

	var room := _get_room_rect()
	if room.size != Vector2.ZERO:
		p = _clamp_point_to_rect(p, room, puddle_radius + 4.0)

	return p


func _spawn_landing_indicator(pos: Vector2, duration: float) -> Node2D:
	var root := Node2D.new()
	root.global_position = pos

	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root

	parent.add_child(root)

	var spr := Sprite2D.new()
	spr.texture = indicator_light_red
	spr.centered = true
	spr.modulate = Color(1, 1, 1, 0.9)
	root.add_child(spr)

	if spr.texture:
		var tex_size := spr.texture.get_size()
		if tex_size.x > 0 and tex_size.y > 0:
			var sx := (puddle_radius * 2.0) / float(tex_size.x)
			var sy := (puddle_radius * 2.0) / float(tex_size.y)
			spr.scale = Vector2(sx, sy)

	var tw := root.create_tween()
	tw.set_trans(Tween.TRANS_SINE)
	tw.set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(spr, "modulate:a", 0.35, duration)

	get_tree().create_timer(duration + 0.25).timeout.connect(root.queue_free)

	return root


func _spawn_puddle_inline(pos: Vector2) -> void:
	var room := _get_room_rect()
	if room.size != Vector2.ZERO:
		pos = _clamp_point_to_rect(pos, room, puddle_radius + 4.0)

	var parent := get_tree().current_scene
	if parent == null:
		parent = get_tree().root

	var puddle := AkanamePuddle.new()
	puddle.global_position = pos
	puddle.radius = puddle_radius
	puddle.dot_tick = dot_tick
	puddle.damage_per_tick = dot_damage_per_tick
	puddle.slow_pct = puddle_slow_pct
	puddle.lifetime = puddle_lifetime
	puddle.tex = indicator_dark_red

	parent.add_child(puddle)

	_active_puddles += 1
	puddle.tree_exited.connect(func():
		_active_puddles = max(0, _active_puddles - 1)
	)


func _room_puddle_count() -> int:
	var c := 0

	for n in get_tree().get_nodes_in_group("puddle_hazard"):
		if is_instance_valid(n):
			c += 1

	return c


# =============================================================================
# DAMAGE / DEATH
# =============================================================================

func _on_base_damaged(hp_damage: int, _damage_type: String, _source: Node, _response: Dictionary) -> void:
	if has_died:
		return

	if hp_damage <= 0:
		return

	_abort_spit()
	_backoff_until = max(_backoff_until, Time.get_ticks_msec() * 0.001 + 0.35)

	play_hurt_animation()


func _on_base_killed_by_damage(_source: Node, _damage_type: String) -> void:
	death()


func play_hurt_animation() -> void:
	_play_anim_exact("hurt", AKAN_HURT_DUR, true)


func play_death_and_free() -> void:
	_play_anim_exact("death", AKAN_DEATH_DUR, true)
	await get_tree().create_timer(AKAN_DEATH_DUR).timeout
	queue_free()


func receive_deathblow(_attacker: Node) -> void:
	force_kill_hp()
	death()


func death() -> void:
	if has_died:
		return

	if not mark_dead():
		return

	_abort_spit()
	_reset_beast_runtime()

	emit_signal("remove_from_array", self)
	emit_signal("enemy_died", self)

	hide_posture_bar()
	notify_stance_effects_enemy_death()
	_spawn_bilemass_rewards()

	velocity = Vector2.ZERO

	if anim and anim.has_animation("death"):
		_play_anim_exact("death", AKAN_DEATH_DUR, true)
		await get_tree().create_timer(AKAN_DEATH_DUR).timeout
	else:
		await get_tree().create_timer(0.30).timeout

	queue_free()


func _spawn_bilemass_rewards() -> void:
	if exp_gem_scene == null:
		return

	var loot_parent := get_tree().get_first_node_in_group("loot")
	var gem := exp_gem_scene.instantiate()

	if gem is Node2D:
		gem.global_position = global_position
		gem.set("experience", experience)

		if loot_parent:
			loot_parent.call_deferred("add_child", gem)
		else:
			var parent := get_parent()
			if parent:
				parent.call_deferred("add_child", gem)


# =============================================================================
# ROOM / MOVEMENT HELPERS
# =============================================================================

func _ms() -> float:
	return float(movement_speed) * skitter_speed_multiplier


func _pre_aggro_patrol(delta: float) -> void:
	var now := Time.get_ticks_msec() * 0.001
	var dist := global_position.distance_to(_patrol_goal)

	if dist < 8.0:
		velocity = Vector2.ZERO
		_last_move_speed = 0.0
		_last_move_dir = Vector2.ZERO
		_ensure_move_anim()

		if now >= _next_patrol_repick:
			_pick_patrol_goal()

		return

	if now >= _next_patrol_repick:
		_pick_patrol_goal()

	var v := (_patrol_goal - global_position).normalized() * (_ms() * pre_aggro_speed_multiplier)
	velocity = v

	var before := global_position
	move_and_slide()
	var moved := global_position - before

	_last_move_speed = moved.length() / max(0.0001, delta)
	_last_move_dir = moved

	if get_slide_collision_count() > 0:
		_pick_patrol_goal()

	_update_motion_facing(now, moved)
	_ensure_move_anim()


func _pick_patrol_goal() -> void:
	var room := _get_room_rect()
	var rad := patrol_wander_radius
	var attempts := 5
	var p := global_position

	while attempts > 0:
		var a := randf() * TAU
		var test := global_position + Vector2(cos(a), sin(a)) * rad * randf()

		if room.has_point(test):
			p = test
			break

		attempts -= 1

	if room.size != Vector2.ZERO:
		p = _clamp_point_to_rect(p, room, puddle_radius + 12.0)

	_patrol_goal = p
	_next_patrol_repick = Time.get_ticks_msec() * 0.001 + randf_range(1.2, 1.8)


func _choose_skitter_goal(dir_to_player: Vector2, player_dist: float) -> Vector2:
	var room := _get_room_rect()

	var mid := _range2_radius if _range2_radius > 0.0 else 260.0
	var too_close := player_dist < (mid * 0.55)
	var too_far := player_dist > (mid * 1.30)

	var choice := randf()
	var dir := Vector2.ZERO

	if too_close and choice < 0.60:
		dir = (-dir_to_player).normalized()
	elif too_far and choice < 0.35:
		dir = dir_to_player.normalized()
	else:
		dir = _pick_lateral_dir(dir_to_player).normalized()

	var hop := randf_range(skitter_goal_min, skitter_goal_max)
	var target := global_position + dir * hop

	if room.size != Vector2.ZERO:
		target = _clamp_point_to_rect(target, room, puddle_radius + 12.0)

	return target


func _start_escape(n: Vector2, dir_to_player: Vector2) -> void:
	var t1 := Vector2(-n.y, n.x).normalized()
	var t2 := -t1
	var away := -dir_to_player
	var t := t1 if t1.dot(away) >= t2.dot(away) else t2

	var center := _get_room_rect().get_center()
	var to_center := (center - global_position).normalized()
	var escape := (t * 0.8 + to_center * 0.2).normalized()

	_escape_dir = escape
	_escape_until = Time.get_ticks_msec() * 0.001 + randf_range(0.35, 0.55)

	_patrol_goal = global_position + escape * randf_range(120.0, 180.0)
	_next_patrol_repick = max(_next_patrol_repick, Time.get_ticks_msec() * 0.001 + 0.4)


func _pick_lateral_dir(dir_to_player: Vector2) -> Vector2:
	var t1 := Vector2(-dir_to_player.y, dir_to_player.x)
	var t2 := -t1

	if randf() < 0.15:
		_lateral_sign = -_lateral_sign

	return t1 if _lateral_sign >= 0.0 else t2


func _near_edges(r: Rect2, tol: float) -> Dictionary:
	var left_edge := r.position.x
	var right_edge := r.position.x + r.size.x
	var top_edge := r.position.y
	var bottom_edge := r.position.y + r.size.y

	return {
		"L": (global_position.x - left_edge) <= tol,
		"R": (right_edge - global_position.x) <= tol,
		"T": (global_position.y - top_edge) <= tol,
		"B": (bottom_edge - global_position.y) <= tol
	}


func _start_corner_escape_by_edges(edges: Dictionary) -> void:
	var push := Vector2.ZERO

	if edges.get("L", false):
		push.x += 1.0
	if edges.get("R", false):
		push.x -= 1.0
	if edges.get("T", false):
		push.y += 1.0
	if edges.get("B", false):
		push.y -= 1.0

	if push == Vector2.ZERO:
		push = (_get_room_rect().get_center() - global_position)

	var escape := push.normalized()

	var jitter_ang := randf_range(-0.35, 0.35)
	var ca := cos(jitter_ang)
	var sa := sin(jitter_ang)
	escape = Vector2(
		escape.x * ca - escape.y * sa,
		escape.x * sa + escape.y * ca
	).normalized()

	_escape_dir = escape
	_escape_until = Time.get_ticks_msec() * 0.001 + randf_range(0.50, 0.80)
	_patrol_goal = global_position + escape * randf_range(140.0, 200.0)
	_next_patrol_repick = max(_next_patrol_repick, _escape_until + 0.20)
	_last_goal_dist = global_position.distance_to(_patrol_goal)
	_no_progress_time = 0.0


func _get_room_rect() -> Rect2:
	var scene := get_tree().current_scene
	if scene:
		var rb := scene.find_child("RoomBounds", true, false)
		if rb and rb.has_method("get_rect_global"):
			return rb.call("get_rect_global")

	return Rect2(global_position - Vector2(800, 450), Vector2(1600, 900))


func _clamp_point_to_rect(p: Vector2, r: Rect2, margin: float) -> Vector2:
	var left := r.position.x + margin
	var right := r.position.x + r.size.x - margin
	var top := r.position.y + margin
	var bottom := r.position.y + r.size.y - margin

	return Vector2(
		clamp(p.x, left, right),
		clamp(p.y, top, bottom)
	)


# =============================================================================
# ANIMATION / FACING
# =============================================================================

func _play_anim_exact(anim_name: String, duration: float, force: bool = false) -> void:
	if not anim or not anim.has_animation(anim_name):
		return

	if not force and anim.current_animation == anim_name:
		return

	var base_len := anim.get_animation(anim_name).length
	anim.speed_scale = base_len / max(0.001, duration)
	anim.play(anim_name)
	_current_anim = anim_name


func _ensure_move_anim() -> void:
	if not anim:
		return

	if beast_is_attacking:
		return

	var moving := _last_move_speed > 5.0

	if moving:
		if anim.current_animation != "walk":
			anim.play("walk")
			_current_anim = "walk"

		var ratio = clamp(_last_move_speed / max(1.0, _ms()), 0.35, 1.6)
		anim.speed_scale = ratio
	else:
		if anim.current_animation != "idle":
			anim.play("idle")
			_current_anim = "idle"

		anim.speed_scale = 1.0


func _update_motion_facing(now: float, moved: Vector2) -> void:
	if not is_instance_valid(sprite):
		return

	if moved.length() <= 0.01:
		return

	if now < _flip_until:
		return

	if abs(moved.x) > 2.0:
		sprite.flip_h = moved.x < 0.0
		_flip_until = now + 0.25


func _player_hidden_in_smoke() -> bool:
	if not is_instance_valid(player):
		return false

	return player.has_meta("in_smoke_cloud") and bool(player.get_meta("in_smoke_cloud"))


# =============================================================================
# CLEANUP
# =============================================================================

func _exit_tree() -> void:
	_abort_spit()
	_disconnect_beast_attack_director_signals()
	_release_all_attack_director_state()
