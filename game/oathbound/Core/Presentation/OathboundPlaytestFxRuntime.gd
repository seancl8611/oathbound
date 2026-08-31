extends Node
class_name OathboundPlaytestFxRuntime

## Debug-only procedural FX layer for integration playtests.
##
## This runtime is deliberately observational. It reads already-authored Technique,
## Aspect, Prosthetic, and combat state and renders temporary CanvasItem geometry.
## It never changes damage, Posture, timers, status ownership, rewards, or progression.
## No external visual assets are required.

const FX_SCRIPT: Script = preload("res://Core/Presentation/OathboundPlaytestFxPrimitive.gd")
const STATUS_SCRIPT: Script = preload("res://Core/Presentation/OathboundPlaytestFxStatus.gd")
const SCAN_INTERVAL: float = 0.05

const COLOR_ECHO := Color(0.68, 0.88, 1.0, 0.95)
const COLOR_RUPTURE := Color(1.0, 0.58, 0.12, 0.98)
const COLOR_SEAL := Color(0.72, 0.40, 1.0, 0.98)
const COLOR_RIFT := Color(1.0, 0.96, 0.78, 0.98)
const COLOR_CRIMSON := Color(0.95, 0.16, 0.20, 0.98)
const COLOR_SHOCK := Color(0.90, 0.94, 0.30, 0.98)
const COLOR_BURN := Color(1.0, 0.38, 0.10, 0.96)
const COLOR_SLOW := Color(0.52, 0.88, 1.0, 0.90)
const COLOR_DEATHBLOW := Color(1.0, 0.78, 0.22, 1.0)
const COLOR_SMOKE := Color(0.62, 0.66, 0.70, 0.72)
const COLOR_UMBRELLA := Color(0.66, 0.82, 1.0, 0.96)
const COLOR_BLOODLETTING := Color(0.76, 0.08, 0.12, 0.94)
const COLOR_WOLF := Color(0.94, 0.18, 0.14, 0.94)
const COLOR_WRAITH := Color(0.72, 0.88, 1.0, 0.92)
const COLOR_RONIN := Color(0.95, 0.72, 0.28, 0.94)

var _enabled: bool = false
var _scan_accumulator: float = 0.0
var _enemy_states: Dictionary = {}
var _player_state: Dictionary = {}
var _player_ref: WeakRef = null
var _prosthetic_ref: WeakRef = null


func _ready() -> void:
	_enabled = OS.is_debug_build()
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process(_enabled)
	if not _enabled:
		return
	call_deferred("_connect_global_signals")
	print("[PlaytestFx] debug-only procedural Technique/Aspect/Prosthetic FX enabled")


func enable_for_tests() -> void:
	_enabled = true
	set_process(true)
	_connect_global_signals()


func is_enabled() -> bool:
	return _enabled


func _process(delta: float) -> void:
	if not _enabled:
		return
	_scan_accumulator += delta
	if _scan_accumulator < SCAN_INTERVAL:
		return
	_scan_accumulator = 0.0
	_ensure_player_binding()
	_scan_enemy_states()
	_scan_player_states()


func _connect_global_signals() -> void:
	if typeof(AspectRuntime) != TYPE_OBJECT:
		return
	var blood_art_cb := Callable(self, "_on_blood_art_started")
	if AspectRuntime.has_signal("blood_art_started") and not AspectRuntime.is_connected("blood_art_started", blood_art_cb):
		AspectRuntime.connect("blood_art_started", blood_art_cb)
	var aspect_cb := Callable(self, "_on_aspect_changed")
	if AspectRuntime.has_signal("aspect_changed") and not AspectRuntime.is_connected("aspect_changed", aspect_cb):
		AspectRuntime.connect("aspect_changed", aspect_cb)
	var tier_cb := Callable(self, "_on_tier_changed")
	if AspectRuntime.has_signal("tier_changed") and not AspectRuntime.is_connected("tier_changed", tier_cb):
		AspectRuntime.connect("tier_changed", tier_cb)


func _ensure_player_binding() -> void:
	var player: Node = get_tree().get_first_node_in_group("player")
	var previous: Node = _player_ref.get_ref() if _player_ref != null else null
	if player != previous:
		_player_ref = weakref(player) if player != null else null
		_prosthetic_ref = null
		_player_state.clear()
	if player == null or not is_instance_valid(player):
		return
	var executor: Node = player.get_node_or_null("ProstheticExecutor")
	if executor == null:
		return
	var previous_executor: Node = _prosthetic_ref.get_ref() if _prosthetic_ref != null else null
	if executor == previous_executor:
		return
	_prosthetic_ref = weakref(executor)
	var prosthetic_cb := Callable(self, "_on_prosthetic_used")
	if executor.has_signal("prosthetic_used") and not executor.is_connected("prosthetic_used", prosthetic_cb):
		executor.connect("prosthetic_used", prosthetic_cb)


func _player() -> Node:
	var player: Node = _player_ref.get_ref() if _player_ref != null else null
	if player != null and is_instance_valid(player):
		return player
	return get_tree().get_first_node_in_group("player")


func _world_parent() -> Node:
	var current: Node = get_tree().current_scene
	return current if current != null else get_tree().root


func _spawn_fx(
		kind: String,
		position: Vector2,
		color: Color,
		duration: float = 0.35,
		radius: float = 40.0,
		direction: Vector2 = Vector2.RIGHT,
		length: float = 80.0,
		spread: float = 1.20
	) -> Node2D:
	var fx_value: Variant = FX_SCRIPT.new()
	if not (fx_value is Node2D):
		return null
	var fx := fx_value as Node2D
	_world_parent().add_child(fx)
	fx.global_position = position
	fx.call("configure", kind, color, duration, radius, direction, length, spread, false)
	return fx


func _spawn_trail(start: Vector2, finish: Vector2, color: Color, duration: float = 0.38) -> void:
	if start.distance_to(finish) <= 2.0:
		return
	var fx: Node2D = _spawn_fx("trail", start, color, duration, 20.0, start.direction_to(finish), start.distance_to(finish), 1.0)
	if fx == null:
		return
	var points := PackedVector2Array()
	points.append(Vector2.ZERO)
	var delta: Vector2 = finish - start
	points.append(delta * 0.32 + delta.orthogonal().normalized() * 3.0)
	points.append(delta * 0.68 - delta.orthogonal().normalized() * 3.0)
	points.append(delta)
	fx.set("local_points", points)
	fx.queue_redraw()


func _spawn_delayed_fx(delay: float, kind: String, position: Vector2, color: Color, duration: float, radius: float, direction: Vector2 = Vector2.RIGHT, length: float = 80.0, spread: float = 1.20) -> void:
	get_tree().create_timer(maxf(0.0, delay)).timeout.connect(func() -> void:
		if is_inside_tree():
			_spawn_fx(kind, position, color, duration, radius, direction, length, spread)
	)


func _callout(target: Node, text: String, color: Color) -> void:
	if target == null or not is_instance_valid(target) or not (target is Node2D):
		return
	var label := Label.new()
	label.text = text
	label.position = Vector2(-maxf(18.0, float(text.length()) * 2.7), -72.0)
	label.z_index = 210
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", color)
	target.add_child(label)
	var tween := label.create_tween()
	tween.set_parallel(true)
	tween.tween_property(label, "position", label.position + Vector2(0.0, -12.0), 0.42)
	tween.tween_property(label, "modulate:a", 0.0, 0.42)
	tween.finished.connect(func() -> void:
		if is_instance_valid(label):
			label.queue_free()
	)


# =============================================================================
# TECHNIQUE / ENEMY STATE OBSERVATION
# =============================================================================

func _scan_enemy_states() -> void:
	var now: float = Time.get_ticks_msec() * 0.001
	var seen: Dictionary = {}
	for target: Node in _enemy_nodes():
		if target == null or not is_instance_valid(target) or not (target is Node2D):
			continue
		var id: int = target.get_instance_id()
		seen[id] = true
		var current: Dictionary = _read_enemy_state(target, now)
		var previous: Dictionary = _enemy_states.get(id, {})
		if not previous.is_empty():
			_handle_enemy_transitions(target, previous, current)
		_refresh_enemy_status_visuals(target, current)
		_enemy_states[id] = current

	for id_value: Variant in _enemy_states.keys().duplicate():
		var id: int = int(id_value)
		if not seen.has(id):
			_enemy_states.erase(id)


func _enemy_nodes() -> Array[Node]:
	var out: Array[Node] = []
	for group_name: String in ["enemy", "miniboss", "boss"]:
		for node: Node in get_tree().get_nodes_in_group(group_name):
			if is_instance_valid(node) and node not in out:
				out.append(node)
	return out


func _read_enemy_state(target: Node, now: float) -> Dictionary:
	return {
		"echo": int(target.get_meta("_tech_echo_pending", 0)),
		"rupture": float(target.get_meta("_tech_rupture", 0.0)),
		"seal": int(target.get_meta("_tech_seal_count", 0)),
		"bound": float(target.get_meta("_tech_bound_until", 0.0)) > now,
		"rift": int(target.get_meta("_tech_rift_intensity", 0)),
		"vulnerable": float(target.get_meta("_tech_vulnerable_until", 0.0)) > now,
		"shock": float(target.get_meta("_oathbound_shock_until", 0.0)) > now,
		"burn": float(target.get_meta("_oathbound_burn_until", 0.0)) > now,
		"slow": float(target.get_meta("_aspect_slow_until", 0.0)) > now,
		"deathblow": _deathblow_ready(target),
	}


func _handle_enemy_transitions(target: Node, previous: Dictionary, current: Dictionary) -> void:
	var position: Vector2 = (target as Node2D).global_position
	var previous_echo: int = int(previous.get("echo", 0))
	var current_echo: int = int(current.get("echo", 0))
	if current_echo > previous_echo:
		_spawn_fx("ring", position, COLOR_ECHO, 0.28, 27.0)
		_callout(target, "ECHO MARK", COLOR_ECHO)
	elif current_echo < previous_echo and previous_echo > 0:
		_spawn_fx("slash", position, COLOR_ECHO, 0.34, 42.0, Vector2.RIGHT, 80.0, 1.55)
		_spawn_fx("burst", position, COLOR_ECHO, 0.28, 38.0)
		_callout(target, "ECHO", COLOR_ECHO)

	var previous_rupture: float = float(previous.get("rupture", 0.0))
	var current_rupture: float = float(current.get("rupture", 0.0))
	if current_rupture > previous_rupture + 0.5:
		var rupture_radius: float = 22.0 + minf(18.0, current_rupture * 0.16)
		_spawn_fx("burst", position, COLOR_RUPTURE, 0.22, rupture_radius)
		_callout(target, "RUPTURE %d" % int(round(current_rupture)), COLOR_RUPTURE)
	elif previous_rupture >= 70.0 and current_rupture < previous_rupture - 20.0:
		_spawn_fx("howl", position, COLOR_RUPTURE, 0.52, 120.0)
		_spawn_fx("burst", position, COLOR_RUPTURE, 0.38, 70.0)
		_callout(target, "RUPTURE!", COLOR_RUPTURE)

	var previous_seal: int = int(previous.get("seal", 0))
	var current_seal: int = int(current.get("seal", 0))
	if current_seal > previous_seal:
		_spawn_fx("ring", position, COLOR_SEAL, 0.30, 30.0 + float(current_seal) * 5.0)
		_callout(target, "SEAL %d" % current_seal, COLOR_SEAL)
	if bool(current.get("bound", false)) and not bool(previous.get("bound", false)):
		_spawn_fx("burst", position, COLOR_SEAL, 0.38, 55.0)
		_callout(target, "BOUND", COLOR_SEAL)

	var previous_rift: int = int(previous.get("rift", 0))
	var current_rift: int = int(current.get("rift", 0))
	if current_rift > previous_rift:
		_spawn_fx("slash", position, COLOR_RIFT, 0.34, 38.0 + float(current_rift) * 4.0, Vector2.DOWN, 70.0, 0.90)
		_callout(target, "RIFT x%d" % current_rift, COLOR_RIFT)
	elif previous_rift > 0 and current_rift == 0:
		_spawn_fx("burst", position, COLOR_RIFT, 0.48, 68.0 + float(previous_rift) * 10.0)
		_spawn_fx("ring", position, COLOR_RIFT, 0.50, 115.0)
		_callout(target, "RIFT OPEN", COLOR_RIFT)

	if bool(current.get("vulnerable", false)) and not bool(previous.get("vulnerable", false)):
		_spawn_fx("slash", position, COLOR_CRIMSON, 0.36, 44.0, Vector2.UP, 72.0, 1.25)
		_callout(target, "VULNERABLE", COLOR_CRIMSON)
	if bool(current.get("shock", false)) and not bool(previous.get("shock", false)):
		_spawn_fx("burst", position, COLOR_SHOCK, 0.28, 42.0)
		_callout(target, "SHOCK", COLOR_SHOCK)
	if bool(current.get("burn", false)) and not bool(previous.get("burn", false)):
		_spawn_fx("burst", position, COLOR_BURN, 0.30, 40.0)
		_callout(target, "BURN", COLOR_BURN)
	if bool(current.get("slow", false)) and not bool(previous.get("slow", false)):
		_spawn_fx("ring", position, COLOR_SLOW, 0.30, 48.0)
		_callout(target, "SLOWED", COLOR_SLOW)
	if bool(current.get("deathblow", false)) and not bool(previous.get("deathblow", false)):
		_spawn_fx("burst", position, COLOR_DEATHBLOW, 0.42, 62.0)
		_callout(target, "DEATHBLOW", COLOR_DEATHBLOW)


func _refresh_enemy_status_visuals(target: Node, state: Dictionary) -> void:
	_set_status_visual(target, "echo", int(state.get("echo", 0)) > 0, "echo", COLOR_ECHO, 1.0, maxi(1, int(state.get("echo", 0))))
	var rupture: float = float(state.get("rupture", 0.0))
	_set_status_visual(target, "rupture", rupture > 0.01, "rupture", COLOR_RUPTURE, clampf(rupture / 100.0, 0.0, 1.0), 1)
	var bound: bool = bool(state.get("bound", false))
	var seals: int = int(state.get("seal", 0))
	_set_status_visual(target, "seal", seals > 0 and not bound, "seal", COLOR_SEAL, float(seals) / 3.0, maxi(1, seals))
	_set_status_visual(target, "bound", bound, "bound", COLOR_SEAL, 1.0, 3)
	var rift: int = int(state.get("rift", 0))
	_set_status_visual(target, "rift", rift > 0, "rift", COLOR_RIFT, float(rift) / 3.0, maxi(1, rift))
	_set_status_visual(target, "vulnerable", bool(state.get("vulnerable", false)), "vulnerable", COLOR_CRIMSON, 1.0, 1)
	_set_status_visual(target, "shock", bool(state.get("shock", false)), "shock", COLOR_SHOCK, 1.0, 1)
	_set_status_visual(target, "burn", bool(state.get("burn", false)), "burn", COLOR_BURN, 1.0, 1)
	_set_status_visual(target, "slow", bool(state.get("slow", false)), "slow", COLOR_SLOW, 1.0, 1)
	_set_status_visual(target, "deathblow", bool(state.get("deathblow", false)), "deathblow", COLOR_DEATHBLOW, 1.0, 1)


func _deathblow_ready(target: Node) -> bool:
	if target == null or not is_instance_valid(target):
		return false
	if target.has_method("is_deathblow_ready"):
		return bool(target.call("is_deathblow_ready"))
	var ready_value: Variant = target.get("can_be_finished")
	if ready_value != null and bool(ready_value):
		return true
	var broken_value: Variant = target.get("_dbroken_active")
	return broken_value != null and bool(broken_value)


func _set_status_visual(target: Node, key: String, active: bool, style: String, color: Color, intensity: float = 1.0, stacks: int = 1, direction: Vector2 = Vector2.RIGHT) -> void:
	if target == null or not is_instance_valid(target) or not (target is Node2D):
		return
	var node_name: String = "PlaytestFx_%s" % key
	var existing: Node = target.get_node_or_null(NodePath(node_name))
	if not active:
		if existing != null and is_instance_valid(existing):
			existing.queue_free()
		return
	if existing == null:
		var status_value: Variant = STATUS_SCRIPT.new()
		if not (status_value is Node2D):
			return
		existing = status_value as Node2D
		existing.name = node_name
		target.add_child(existing)
	existing.call("set_state", style, color, intensity, stacks, direction)


# =============================================================================
# PLAYER / ASPECT STATE
# =============================================================================

func _scan_player_states() -> void:
	var player: Node = _player()
	if player == null or not is_instance_valid(player) or not (player is Node2D):
		return
	var now: float = Time.get_ticks_msec() * 0.001
	var unseen: bool = bool(player.get_meta("_tech_unseen_active", false)) and float(player.get_meta("_tech_unseen_until", 0.0)) > now
	var umbrella: bool = bool(player.get_meta("_oathbound_umbrella_active", false))
	var bloodletting: bool = float(player.get_meta("_oathbound_bloodletting_until", 0.0)) > now
	var direction: Vector2 = _player_direction(player)
	_set_status_visual(player, "unseen", unseen, "unseen", COLOR_ECHO, 1.0, 1, direction)
	_set_status_visual(player, "umbrella", umbrella, "umbrella", COLOR_UMBRELLA, 1.0, 1, direction)
	_set_status_visual(player, "bloodletting", bloodletting, "bloodletting", COLOR_BLOODLETTING, 1.0, 1, direction)

	var aspect: String = ""
	var tier: int = 0
	var blood_state: String = "unavailable"
	if typeof(AspectRuntime) == TYPE_OBJECT:
		aspect = str(AspectRuntime.get("selected_aspect"))
		tier = int(AspectRuntime.get("tier"))
		if AspectRuntime.has_method("blood_state"):
			blood_state = str(AspectRuntime.call("blood_state"))
	var active_aspect: bool = aspect in ["wolf", "wraith", "ronin"] and tier > 0
	_set_status_visual(player, "aspect", active_aspect, "aspect", _aspect_color(aspect), clampf(float(tier) / 4.0, 0.25, 1.0), 1, direction)

	var previous_blood_state: String = str(_player_state.get("blood_state", ""))
	if blood_state == "ready" and previous_blood_state != "ready":
		_spawn_fx("howl", (player as Node2D).global_position, _aspect_color(aspect), 0.52, 72.0)
		_callout(player, "BLOOD ART READY", _aspect_color(aspect))
	_player_state = {
		"unseen": unseen,
		"umbrella": umbrella,
		"bloodletting": bloodletting,
		"aspect": aspect,
		"tier": tier,
		"blood_state": blood_state,
	}


func _on_aspect_changed(aspect: String) -> void:
	if aspect not in ["wolf", "wraith", "ronin"]:
		return
	var player: Node = _player()
	if player == null or not (player is Node2D):
		return
	_spawn_fx("ring", (player as Node2D).global_position, _aspect_color(aspect), 0.50, 52.0)
	_callout(player, "%s ASPECT" % aspect.to_upper(), _aspect_color(aspect))


func _on_tier_changed(value: int) -> void:
	if value <= 0:
		return
	var player: Node = _player()
	if player == null or not (player is Node2D):
		return
	var aspect: String = str(AspectRuntime.get("selected_aspect")) if typeof(AspectRuntime) == TYPE_OBJECT else ""
	if aspect not in ["wolf", "wraith", "ronin"]:
		return
	_spawn_fx("burst", (player as Node2D).global_position, _aspect_color(aspect), 0.42, 48.0 + float(value) * 8.0)
	_callout(player, "%s T%d" % [aspect.to_upper(), value], _aspect_color(aspect))


func _on_blood_art_started(aspect: String) -> void:
	var player: Node = _player()
	if player == null or not (player is Node2D):
		return
	var position: Vector2 = (player as Node2D).global_position
	var direction: Vector2 = _player_direction(player)
	match aspect:
		"wolf":
			_spawn_fx("howl", position, COLOR_WOLF, 0.70, 110.0)
			_spawn_delayed_fx(0.12, "howl", position, COLOR_WOLF, 0.60, 145.0)
			_callout(player, "BLOOD HUNT", COLOR_WOLF)
		"wraith":
			_spawn_fx("corridor", position, COLOR_WRAITH, 0.82, 34.0, direction, 360.0, 1.0)
			_spawn_delayed_fx(0.18, "slash", position + direction * 42.0, COLOR_WRAITH, 0.45, 64.0, direction, 90.0, 1.5)
			_callout(player, "WRAITH REACH", COLOR_WRAITH)
		"ronin":
			_spawn_fx("burst", position, COLOR_RONIN, 0.62, 78.0)
			_spawn_fx("ring", position, COLOR_RONIN, 0.78, 112.0)
			_callout(player, "FALLING MOUNTAIN", COLOR_RONIN)


func _aspect_color(aspect: String) -> Color:
	match aspect:
		"wolf":
			return COLOR_WOLF
		"wraith":
			return COLOR_WRAITH
		"ronin":
			return COLOR_RONIN
	return Color(0.90, 0.78, 0.62, 0.86)


# =============================================================================
# PROSTHETIC ACTIVATION SILHOUETTES
# =============================================================================

func _on_prosthetic_used(prosthetic_id: String) -> void:
	var player: Node = _player()
	if player == null or not is_instance_valid(player) or not (player is Node2D):
		return
	var position: Vector2 = (player as Node2D).global_position
	var direction: Vector2 = _player_direction(player)
	match prosthetic_id:
		"beast_whistle":
			_spawn_fx("howl", position, Color(0.86, 0.72, 0.28, 0.96), 0.62, 110.0)
			_spawn_delayed_fx(0.12, "ring", position, Color(0.86, 0.72, 0.28, 0.84), 0.55, 145.0)
			_callout(player, "BEAST WHISTLE", Color(0.92, 0.78, 0.34, 1.0))
		"thunder_rod":
			_spawn_fx("line", position, COLOR_SHOCK, 0.38, 18.0, direction, 260.0, 1.0)
			_spawn_fx("burst", position + direction * 20.0, COLOR_SHOCK, 0.26, 25.0)
			_callout(player, "THUNDER ROD", COLOR_SHOCK)
		"smoke_gourd":
			var smoke_radius: float = 155.0 if _prosthetic_upgrade("smoke_gourd", "expanded_cloud") else 115.0
			var smoke_duration: float = 4.5 if _prosthetic_upgrade("smoke_gourd", "dense_mixture") else 3.0
			_spawn_fx("smoke", position, COLOR_SMOKE, smoke_duration, smoke_radius)
			_spawn_fx("ring", position, COLOR_SMOKE, 0.48, smoke_radius)
			_callout(player, "SMOKE GOURD", Color(0.78, 0.82, 0.84, 1.0))
		"fang_harpoon":
			_spawn_fx("chain", position, Color(0.82, 0.76, 0.62, 0.96), 0.48, 20.0, direction, 220.0, 1.0)
			_callout(player, "FANG HARPOON", Color(0.90, 0.82, 0.68, 1.0))
		"mirror_umbrella":
			_spawn_fx("shield", position, COLOR_UMBRELLA, 0.46, 48.0, direction, 80.0, 1.0)
			_callout(player, "MIRROR UMBRELLA", COLOR_UMBRELLA)
		"flame_vent":
			var reach: float = 130.0 if _prosthetic_upgrade("flame_vent", "pressurized_vent") else 100.0
			_spawn_fx("cone", position, COLOR_BURN, 0.56, reach, direction, reach, deg_to_rad(70.0))
			_callout(player, "FLAME VENT", COLOR_BURN)
		"mist_raven":
			var start: Vector2 = position
			var player_ref := weakref(player)
			_spawn_fx("burst", start, COLOR_WRAITH, 0.32, 32.0)
			get_tree().create_timer(0.10).timeout.connect(func() -> void:
				var resolved: Node = player_ref.get_ref() if player_ref != null else null
				if resolved != null and is_instance_valid(resolved) and resolved is Node2D:
					var finish: Vector2 = (resolved as Node2D).global_position
					_spawn_trail(start, finish, COLOR_WRAITH, 0.46)
					_spawn_fx("burst", finish, COLOR_WRAITH, 0.32, 34.0)
			)
			_callout(player, "MIST RAVEN", COLOR_WRAITH)
		"bloodletting_gourd":
			_spawn_fx("burst", position, COLOR_BLOODLETTING, 0.48, 52.0)
			_spawn_fx("ring", position, COLOR_BLOODLETTING, 0.68, 70.0)
			_callout(player, "BLOODLETTING", Color(1.0, 0.28, 0.30, 1.0))


func _prosthetic_upgrade(prosthetic_id: String, upgrade_id: String) -> bool:
	if typeof(ProstheticManager) != TYPE_OBJECT or not ProstheticManager.has_method("is_upgrade_purchased"):
		return false
	return bool(ProstheticManager.call("is_upgrade_purchased", prosthetic_id, upgrade_id))


func _player_direction(player: Node) -> Vector2:
	if player != null and player.has_method("get_defensive_facing"):
		var facing_value: Variant = player.call("get_defensive_facing")
		if facing_value is Vector2 and (facing_value as Vector2).length_squared() > 0.001:
			return (facing_value as Vector2).normalized()
	if player != null:
		var facing_property: Variant = player.get("_facing_dir")
		if facing_property is Vector2 and (facing_property as Vector2).length_squared() > 0.001:
			return (facing_property as Vector2).normalized()
	return Vector2.RIGHT


# =============================================================================
# VALIDATION SHOWCASE
# =============================================================================

func debug_spawn_showcase(center: Vector2) -> int:
	var before: int = get_tree().get_nodes_in_group("playtest_fx").size()
	_spawn_fx("ring", center + Vector2(-90.0, -45.0), COLOR_ECHO, 0.65, 34.0)
	_spawn_fx("burst", center + Vector2(-30.0, -45.0), COLOR_RUPTURE, 0.65, 44.0)
	_spawn_fx("howl", center + Vector2(35.0, -45.0), COLOR_SEAL, 0.65, 48.0)
	_spawn_fx("slash", center + Vector2(95.0, -45.0), COLOR_RIFT, 0.65, 44.0, Vector2.RIGHT, 70.0, 1.4)
	_spawn_fx("cone", center + Vector2(-65.0, 35.0), COLOR_BURN, 0.65, 70.0, Vector2.RIGHT, 70.0, deg_to_rad(70.0))
	_spawn_fx("chain", center + Vector2(10.0, 35.0), Color(0.82, 0.76, 0.62, 0.96), 0.65, 20.0, Vector2.RIGHT, 90.0, 1.0)
	_spawn_fx("shield", center + Vector2(100.0, 35.0), COLOR_UMBRELLA, 0.65, 42.0, Vector2.RIGHT, 70.0, 1.0)
	return get_tree().get_nodes_in_group("playtest_fx").size() - before
