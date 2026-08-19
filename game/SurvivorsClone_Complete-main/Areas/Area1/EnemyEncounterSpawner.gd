extends Node2D

signal encounter_started
signal encounter_cleared
signal enemy_spawned(enemy: Node)

# --- pacing knobs (Hades-like) ---
@export var opener_delay: float = 0.3        # small beat before wave 1
@export var wave_spacing_min: float = 6.5    # average ~7s between waves
@export var wave_spacing_max: float = 7.5

@export var group_spacing: float = 0.25      # space between groups within a wave
@export var unit_stagger: float  = 0.04      # tiny delay between units in a group
@export var active_cap: int = 12             # max concurrent enemies visible

# --- spawn shapes ---
@export var ring_radius: float = 420.0
@export var edge_multiplier_min: float = 1.1
@export var edge_multiplier_max: float = 1.4

var _player: Node2D = null
var _running := false
var _alive := 0
var _waves: Array = []  # [{groups:[{scene, count, pattern}, ...], spacing: float|[min,max]?}, ...]
var _encounter_hint := {}  # copy of the template root for optional overrides

var _spawn_rect: Rect2 = Rect2() 
var _use_spawn_rect: bool = false

func _ready() -> void:
	_player = get_tree().get_first_node_in_group("player")

func is_running() -> bool:
	return _running

# --- public: start via a template dict from EncounterDB.pick_area1() ---
func start_template(template: Dictionary, area_id: int = 1) -> void:
	if _running: return
	_running = true
	_encounter_hint = template.duplicate(true)
	emit_signal("encounter_started")

	_waves = _resolve_template(template, area_id)
	await _spawn_first_then_wait_and_pace()  # new flow: spawn wave1 idle, wait for first aggro, then pace others
	await _wait_until_cleared()

	_running = false
	emit_signal("encounter_cleared")

func _resolve_template(template: Dictionary, area_id: int) -> Array:
	var type_map: Dictionary = {}
	var reg := get_node_or_null("/root/SceneRegistry")
	if reg:
		# support either a field or a getter
		var eba = reg.get("enemies_by_area") if reg.has_method("get") else null
		if typeof(eba) == TYPE_DICTIONARY:
			type_map = eba.get(area_id, {})
		elif reg.has_method("get_enemies_by_area"):
			var got = reg.call("get_enemies_by_area")
			if typeof(got) == TYPE_DICTIONARY:
				type_map = got.get(area_id, {})

	var resolved: Array = []
	var wave_spacing_hint = template.get("wave_spacing", null)
	var waves: Array = template.get("waves", [])
	for w in waves:
		var groups_in = w.get("groups", [])
		var groups_out: Array = []
		for g in groups_in:
			var t := String(g.get("type",""))
			var cnt := int(g.get("count", 1))
			if t.is_empty() or cnt <= 0:
				continue
			var scene: PackedScene = type_map.get(t, null)
			if scene == null:
				push_warning("Unknown enemy type for area %d: %s" % [area_id, t])
				continue
			var pattern := _pattern_for_type(t)
			groups_out.append({"scene": scene, "count": cnt, "pattern": pattern})
		if groups_out.size() > 0:
			var wave_out := {"groups": groups_out}
			if w.has("spacing"):
				wave_out["spacing"] = w["spacing"]
			elif wave_spacing_hint != null:
				wave_out["spacing"] = wave_spacing_hint
			resolved.append(wave_out)
	return resolved

func _pattern_for_type(t: String) -> String:
	match t:
		# melee / duel
		"soldier", "grub", "ashen_soldier", "brute", "shade", "lost_shade", "warden", "wardens":
			return "ring"
		# ranged / fast flank
		"archer", "dog", "wild_dog", "akaname":
			return "edge"
		_:
			return "edge"
			
func _calc_wave_spacing_for(i:int) -> float:
	var w = _waves[i]
	# Per-wave explicit spacing (float or [min,max])
	if w.has("spacing"):
		var s = w["spacing"]
		if typeof(s) == TYPE_FLOAT and s >= 0.0:
			return s
		if typeof(s) == TYPE_ARRAY and s.size() >= 2:
			return randf_range(float(s[0]), float(s[1]))

	# Per-encounter explicit spacing on root (float or [min,max])
	if _encounter_hint.has("wave_spacing"):
		var e = _encounter_hint["wave_spacing"]
		if typeof(e) == TYPE_FLOAT and e >= 0.0:
			return e
		if typeof(e) == TYPE_ARRAY and e.size() >= 2:
			return randf_range(float(e[0]), float(e[1]))

	# Default random range (Area 1)
	return randf_range(wave_spacing_min, wave_spacing_max)

func _spawn_wave(wave: Dictionary, auto_aggro_on_spawn: bool = true) -> void:
	var groups: Array = wave.get("groups", [])
	for g in groups:
		await _spawn_group(g, auto_aggro_on_spawn)
		if group_spacing > 0.0:
			await get_tree().create_timer(group_spacing).timeout

func _spawn_group(group: Dictionary, auto_aggro_on_spawn: bool = true) -> void:
	var scene: PackedScene = group.get("scene", null)
	var count: int = int(group.get("count", 1))
	var pattern: String = str(group.get("pattern", "edge"))
	if scene == null or count <= 0:
		return

	for i in count:
		while _alive >= active_cap:
			await get_tree().process_frame

		var spawn_pos := _ring_spawn_pos(i, count) if pattern == "ring" else _edge_spawn_pos()

		# Instantiate and set flags BEFORE add_child so _ready() can read them.
		var e := scene.instantiate()
		if e.has_method("set_auto_aggro_on_spawn"):
			e.set_auto_aggro_on_spawn(auto_aggro_on_spawn)
		elif _prop_exists(e, "auto_aggro_on_spawn"):
			e.set("auto_aggro_on_spawn", auto_aggro_on_spawn)

		add_child(e)

		if e is Node2D:
			(e as Node2D).global_position = spawn_pos
			if _player:
				var fwd := (_player.global_position - spawn_pos).normalized()
				e.set("spawn_forward", fwd)

		_alive += 1

		# death signals — prefer new EnemyBase signal, keep fallbacks for older enemies
		if e.has_signal("enemy_died"):
			e.connect("enemy_died", Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)
		elif e.has_signal("remove_from_array"):
			e.connect("remove_from_array", Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)
		elif e.has_signal("died"):
			e.connect("died", Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)
		else:
			e.tree_exited.connect(Callable(self, "_on_enemy_died"), CONNECT_ONE_SHOT)

		emit_signal("enemy_spawned", e)

		# Engage on the next frame so all _ready/_enter_tree setup is done.
		if auto_aggro_on_spawn and e.has_method("engage"):
			await get_tree().process_frame
			e.call_deferred("engage")

		if unit_stagger > 0.0:
			await get_tree().create_timer(unit_stagger).timeout

func _on_enemy_died(_e: Variant = null) -> void:
	_alive = max(0, _alive - 1)

func _wait_until_cleared() -> void:
	while _alive > 0:
		await get_tree().process_frame

# --- spawn positions ---
func _ring_spawn_pos(i:int, count:int) -> Vector2:
	var center := _player.global_position if _player else global_position
	var ang = TAU * (float(i) / max(1, count))
	return center + Vector2(cos(ang), sin(ang)) * ring_radius

# Edge spawns that respect the room's spawn rect when provided
func _edge_spawn_pos() -> Vector2:
	var center := (_player.global_position if _player else global_position)

	if _use_spawn_rect and _spawn_rect.size != Vector2.ZERO:
		var r := _spawn_rect
		var side = ["up","down","right","left"].pick_random()
		match side:
			"up":
				return Vector2(randf_range(r.position.x, r.position.x + r.size.x), r.position.y)
			"down":
				return Vector2(randf_range(r.position.x, r.position.x + r.size.x), r.position.y + r.size.y)
			"right":
				return Vector2(r.position.x + r.size.x, randf_range(r.position.y, r.position.y + r.size.y))
			"left":
				return Vector2(r.position.x, randf_range(r.position.y, r.position.y + r.size.y))
		return center

	# Fallback: viewport-sized ring around player
	var size := get_viewport_rect().size * randf_range(edge_multiplier_min, edge_multiplier_max)
	var half := size * 0.5
	var tl := Vector2(center.x - half.x, center.y - half.y)
	var tr := Vector2(center.x + half.x, center.y - half.y)
	var bl := Vector2(center.x - half.x, center.y + half.y)
	var br := Vector2(center.x + half.x, center.y + half.y)

	var side2 = ["up","down","right","left"].pick_random()
	match side2:
		"up":
			return Vector2(randf_range(tl.x, tr.x), tl.y)
		"down":
			return Vector2(randf_range(bl.x, br.x), bl.y)
		"right":
			return Vector2(tr.x, randf_range(tr.y, br.y))
		"left":
			return Vector2(tl.x, randf_range(tl.y, bl.y))
	return center

func set_spawn_rect(r: Rect2) -> void:
	_spawn_rect = r
	_use_spawn_rect = true

func _spawn_first_then_wait_and_pace() -> void:
	if _waves.is_empty():
		return

	# small dramatic beat before first wave
	if opener_delay > 0.0:
		await get_tree().create_timer(opener_delay).timeout

	# Wave 1 spawns in patrol/idle. Do not auto-aggro.
	await _spawn_wave(_waves[0], false)

	# Wait for any enemy (under this spawner) to mark player as seen.
	await _wait_for_player_spotted()

	# Broadcast: everyone in this room engages now.
	_force_all_enemies_engage()

	for i in range(1, _waves.size()):
		var delay := _calc_wave_spacing_for(i)    # was i - 1
		if delay > 0.0:
			await get_tree().create_timer(delay).timeout
		await _spawn_wave(_waves[i], true)

func _wait_for_player_spotted() -> void:
	while true:
		await get_tree().process_frame
		for e in get_tree().get_nodes_in_group("enemy"):
			if not (is_instance_valid(e) and is_ancestor_of(e)):
				continue

			var seen := false
			# Dog and some enemies expose _saw_player_once / _aggro
			if _prop_exists(e, "_saw_player_once") and bool(e.get("_saw_player_once")):
				seen = true
			elif _prop_exists(e, "_aggro") and bool(e.get("_aggro")):
				seen = true
			# Base Enemy HFSM left IDLE (ai_state != 0)
			elif _prop_exists(e, "ai_state") and int(e.get("ai_state")) != 0:
				seen = true
			# Dog state CHASE or higher (0=PATROL,1=IDLE, >=2 = engaged)
			elif _prop_exists(e, "state") and int(e.get("state")) >= 2:
				seen = true

			if seen:
				return

func _force_all_enemies_engage() -> void:
	for e in get_tree().get_nodes_in_group("enemy"):
		if not (is_instance_valid(e) and is_ancestor_of(e)):
			continue
		# ensure flag true for any first-wave enemies
		if e.has_method("set_auto_aggro_on_spawn"):
			e.set_auto_aggro_on_spawn(true)
		elif _prop_exists(e, "auto_aggro_on_spawn"):
			e.set("auto_aggro_on_spawn", true)
		# defer engage to avoid racing enemy internals
		if e.has_method("engage"):
			e.call_deferred("engage")

func _prop_exists(o: Object, name: String) -> bool:
	for p in o.get_property_list():
		if p.has("name") and String(p["name"]) == name:
			return true
	return false
