extends RoomBase

## =============================================================================
## COMBAT ROOM - PRESSURE PACING
## =============================================================================
## Philosophy: coordinated enemy pressure instead of sequential dueling.
## - One attacker for small encounters, up to two melee attackers in larger packs.
## - Ranged pressure may overlap melee pressure without becoming constant spam.
## - Short turnover/cooldown windows keep enemies active while preserving readable tells.
## - AttackDirector remains the compatibility API; migrated enemies may use the newer
##   pressure-reservation path layered on top of it.
## =============================================================================

@onready var ui: CanvasLayer = preload("res://Utility/UpgradeChoiceUI.tscn").instantiate()
@onready var spawner: Node = $EnemyEncounterSpawner
@onready var room_bounds: Node = $RoomBounds

# Debug: set this in the editor to force a specific EncounterDB template by id.
# Example IDs (from EncounterDB):
#   debug_akaname, debug_archer, debug_ashen_soldier, debug_lost_shade, debug_wardens, debug_wild_dog
@export var encounter_id_override: String = ""

var _spawn_rect: Rect2
var _alive = 0
var _encounter_aggro_locked: bool = false

const COMBAT_REWARDS = {
	"gold":   {1: 50, 2: 75, 3: 100},
	"mist":   {1: 4,  2: 5,  3: 6},
	"scroll": {1: 1,  2: 2,  3: 3},
	"maxhp":  {1: 3,  2: 4,  3: 5},
}

const SMALL_ENCOUNTER_MELEE_LIMIT: int = 1
const LARGE_ENCOUNTER_MELEE_LIMIT: int = 2
const LARGE_ENCOUNTER_THRESHOLD: int = 3
const MAX_ADVANCE_SLOTS: int = 4
const MAX_RANGED_ATTACKERS: int = 2

const MELEE_COOLDOWN_SEC: float = 1.35
const ADVANCE_COOLDOWN_SEC: float = 0.65
const RANGED_COOLDOWN_SEC: float = 2.0
const FORMATION_COOLDOWN_SEC: float = 0.8
const ATTACK_GRANT_GAP_SEC: float = 0.25
const ATTACK_TURNOVER_SEC: float = 0.30


func _ready() -> void:
	print("[CombatRoom] Pressure pacing active")
	add_child(ui)
	ui.visible = false
	ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	ui.layer = 100

	# RoomBounds setup
	var cam = get_viewport().get_camera_2d()
	if cam and room_bounds and room_bounds.has_method("apply_camera_limits"):
		room_bounds.call("apply_camera_limits", cam)

	# Cache spawn rectangle
	if room_bounds and room_bounds.has_method("get_rect_global"):
		_spawn_rect = room_bounds.call("get_rect_global")
	else:
		_spawn_rect = Rect2(global_position - Vector2(800, 450), Vector2(1600, 900))

	_push_spawn_rect_to_spawner(_spawn_rect)

	lock_all_gates()

	# Establish readable pressure defaults before the encounter begins. Autoscaling
	# raises melee concurrency only when enough enemies are actually alive to justify it.
	_configure_pressure_tokens()

	_start_encounter()


## Configure AttackDirector compatibility roles for Hades-like encounter pressure.
func _configure_pressure_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	AttackDir.set_role_limits({
		"melee_attack": SMALL_ENCOUNTER_MELEE_LIMIT,
		"advance_move": 3,
		"ranged_attack": MAX_RANGED_ATTACKERS,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})

	AttackDir.set_role_cooldowns({
		"melee_attack": MELEE_COOLDOWN_SEC,
		"advance_move": ADVANCE_COOLDOWN_SEC,
		"ranged_attack": RANGED_COOLDOWN_SEC,
		"frontal": FORMATION_COOLDOWN_SEC,
		"flank_left": FORMATION_COOLDOWN_SEC,
		"flank_right": FORMATION_COOLDOWN_SEC,
	})

	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = ATTACK_GRANT_GAP_SEC
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = ATTACK_TURNOVER_SEC
	if _has_property(AttackDir, "max_frontline"):
		AttackDir.max_frontline = 4

	print("[CombatRoom] Pressure roles configured: dynamic 1-2 melee, up to 2 ranged")


func _start_encounter() -> void:
	if spawner:
		if not spawner.is_connected("encounter_cleared", Callable(self, "_on_encounter_cleared")):
			spawner.connect("encounter_cleared", Callable(self, "_on_encounter_cleared"))
		if not spawner.is_connected("encounter_started", Callable(self, "_on_encounter_started")):
			spawner.connect("encounter_started", Callable(self, "_on_encounter_started"))
		if not spawner.is_connected("enemy_spawned", Callable(self, "_on_enemy_spawned")):
			spawner.connect("enemy_spawned", Callable(self, "_on_enemy_spawned"))

		var tmpl: Dictionary = {}
		var area_id = get_meta("area_id") if has_meta("area_id") else 1

		# Use EncounterDB if available
		if typeof(EncounterDB) == TYPE_OBJECT:
			var forced_id = encounter_id_override.strip_edges()
			if not forced_id.is_empty() and EncounterDB.has_method("get_encounter_by_id"):
				tmpl = EncounterDB.get_encounter_by_id(forced_id)
				if tmpl.is_empty():
					push_warning("[CombatRoom] Unknown encounter_id_override: %s" % forced_id)
					forced_id = ""
				else:
					# Detect correct area from which array the encounter lives in
					area_id = _detect_encounter_area(forced_id, area_id)

			if tmpl.is_empty():
				tmpl = _pick_encounter_for_area(area_id)
		else:
			tmpl = _default_template()

		print("[CombatRoom] Area %d | Starting encounter: %s" % [area_id, tmpl.get("id", "<local>")])
		spawner.start_template(tmpl, area_id)
	else:
		push_warning("[CombatRoom] EnemyEncounterSpawner missing; falling back to timer")
		await get_tree().create_timer(6.0).timeout
		_on_room_cleared()


func _pick_encounter_for_area(area_id: int) -> Dictionary:
	if typeof(EncounterDB) != TYPE_OBJECT:
		return _default_template()

	match area_id:
		1:
			if EncounterDB.has_method("pick_area1"):
				return EncounterDB.pick_area1()
		2:
			if EncounterDB.has_method("pick_area2"):
				return EncounterDB.pick_area2()
			# Fallback to area 1 until area 2 encounters exist
			if EncounterDB.has_method("pick_area1"):
				push_warning("[CombatRoom] No pick_area2() yet — using area 1 encounters")
				return EncounterDB.pick_area1()
		3:
			if EncounterDB.has_method("pick_area3"):
				return EncounterDB.pick_area3()
			if EncounterDB.has_method("pick_area1"):
				push_warning("[CombatRoom] No pick_area3() yet — using area 1 encounters")
				return EncounterDB.pick_area1()

	return _default_template()


func _on_encounter_started() -> void:
	print("[CombatRoom] Encounter started")
	_alive = 0
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e) and is_ancestor_of(e):
			_alive += 1
			_wire_enemy_signals(e)

	_start_pressure_autoscale()


func _on_encounter_cleared() -> void:
	print("[CombatRoom] Encounter cleared → opening reward")
	_on_room_cleared()


func _on_room_cleared() -> void:
	if cleared:
		return
	cleared = true
	print("[CombatRoom] Room cleared → preparing reward")
	emit_signal("room_cleared")


func post_clear() -> void:
	print("[CombatRoom] Post-clear → spawning reward pickup")

	var reward_key = get_meta("reward_key") if has_meta("reward_key") else ""
	var area_id = get_meta("area_id") if has_meta("area_id") else 1

	# Technique rewards are resolved by their own picker rather than a numeric amount.
	var amount = 0
	if reward_key not in ["boon", "technique", ""]:
		var table = COMBAT_REWARDS.get(reward_key, {})
		amount = table.get(area_id, table.get(1, 0))

	# New combat rooms default to current Technique terminology. `boon` remains accepted
	# by RewardPickup only for compatibility with imported later-area route data.
	if reward_key == "":
		reward_key = "technique"

	# Find spawn position (center of room or near player)
	var spawn_pos = Vector2.ZERO
	var room_center = get_node_or_null("RoomCenter")
	if room_center and room_center is Node2D:
		spawn_pos = room_center.global_position
	else:
		spawn_pos = _spawn_rect.get_center() if _spawn_rect.size != Vector2.ZERO else global_position

	var RewardPickupScript = load("res://Objects/RewardPickup.gd")
	var pickup = RewardPickupScript.new()
	pickup.setup(reward_key, amount, area_id)
	pickup.global_position = spawn_pos
	add_child(pickup)

	await pickup.collected
	unlock_all_gates()
	print("[CombatRoom] Reward collected → gates unlocked")


func _grant_max_hp(amount: int) -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var p = players[0]
		if "maxhp" in p:
			p.maxhp += amount
			p.hp = min(p.hp + amount, p.maxhp)
			if p.has_method("_update_health_bar"):
				p._update_health_bar()


## Default fallback template - short two-wave pressure encounter.
func _default_template() -> Dictionary:
	return {
		"id": "fallback_pressure",
		"wave_spacing": [3.0, 4.0],
		"waves": [
			{"groups": [
				{"type": "soldier", "count": 1}
			]},
			{"groups": [
				{"type": "soldier", "count": 2}
			]}
		]
	}


func _wire_enemy_signals(e: Node) -> void:
	if not is_instance_valid(e):
		return

	if e.has_signal("enemy_died") and not e.is_connected("enemy_died", Callable(self, "_on_enemy_died")):
		e.connect("enemy_died", Callable(self, "_on_enemy_died"))


func _on_enemy_died(_enemy: Node) -> void:
	_alive = max(0, _alive - 1)
	# Pressure scaling is still handled by the autoscale tick.


func _start_pressure_autoscale() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return
	if not is_instance_valid(self):
		return

	if not has_node("PressureTick"):
		var t = Timer.new()
		t.name = "PressureTick"
		t.wait_time = 0.5
		t.one_shot = false
		add_child(t)
		t.timeout.connect(_autoscale_tick)

	_autoscale_tick()
	$PressureTick.start()


func _autoscale_tick() -> void:
	var count = 0
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e) and is_ancestor_of(e):
			count += 1
	_alive = count

	_update_encounter_aggro_lock()
	_update_pressure_tokens()


## Scale compatibility roles by live encounter pressure. Small fights remain readable;
## packs of three or more may overlap a second melee action instead of forming a queue.
func _update_pressure_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	var alive = 0
	var ranged_bodies = 0
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e) and is_ancestor_of(e):
			alive += 1
			if e.is_in_group("archer") or e.is_in_group("ranged"):
				ranged_bodies += 1

	var melee = SMALL_ENCOUNTER_MELEE_LIMIT if alive < LARGE_ENCOUNTER_THRESHOLD else LARGE_ENCOUNTER_MELEE_LIMIT
	var advance = clampi(alive, 1, MAX_ADVANCE_SLOTS)
	var ranged = mini(MAX_RANGED_ATTACKERS, ranged_bodies)
	if ranged_bodies > 0:
		ranged = maxi(1, ranged)

	AttackDir.set_role_limits({
		"melee_attack": melee,
		"advance_move": advance,
		"ranged_attack": ranged,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1,
	})

	AttackDir.set_role_cooldowns({
		"melee_attack": MELEE_COOLDOWN_SEC,
		"advance_move": ADVANCE_COOLDOWN_SEC,
		"ranged_attack": RANGED_COOLDOWN_SEC,
		"frontal": FORMATION_COOLDOWN_SEC,
		"flank_left": FORMATION_COOLDOWN_SEC,
		"flank_right": FORMATION_COOLDOWN_SEC,
	})

	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = ATTACK_GRANT_GAP_SEC
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = ATTACK_TURNOVER_SEC


func _on_enemy_spawned(e: Node) -> void:
	if is_instance_valid(e) and is_ancestor_of(e):
		# Clamp position to spawn rect
		if e is Node2D:
			var p = (e as Node2D).global_position
			(e as Node2D).global_position = _clamp_point_to_rect(p, _spawn_rect)

		_alive += 1
		_wire_enemy_signals(e)

		_update_encounter_aggro_lock()
		_apply_spawn_aggro(e)


func _push_spawn_rect_to_spawner(r: Rect2) -> void:
	if not spawner:
		push_warning("[CombatRoom] EnemyEncounterSpawner not found.")
		return
	if spawner.has_method("set_spawn_rect"):
		spawner.set_spawn_rect(r)
	elif spawner.has_method("set_spawn_area"):
		spawner.set_spawn_area(r)
	elif spawner.has_method("set_bounds"):
		spawner.set_bounds(r)
	elif spawner.has_method("set_spawn_region"):
		spawner.set_spawn_region(r)
	else:
		spawner.set_meta("spawn_rect", r)
	print("[CombatRoom] Spawn rect set to:", r)


func _clamp_point_to_rect(p: Vector2, r: Rect2) -> Vector2:
	var rx = clamp(p.x, r.position.x, r.position.x + r.size.x)
	var ry = clamp(p.y, r.position.y, r.position.y + r.size.y)
	return Vector2(rx, ry)


func _update_encounter_aggro_lock() -> void:
	if _encounter_aggro_locked:
		return
	for n in get_tree().get_nodes_in_group("enemy"):
		if not (is_instance_valid(n) and is_ancestor_of(n)):
			continue
		if _has_property(n, "_saw_player_once") and bool(n.get("_saw_player_once")):
			_encounter_aggro_locked = true
			break


func _apply_spawn_aggro(e: Object) -> void:
	# Only auto-aggro for waves 2+
	if not _encounter_aggro_locked:
		return

	if _has_property(e, "auto_aggro_on_spawn"):
		e.set("auto_aggro_on_spawn", true)
		return

	var touched = false
	if _has_property(e, "_saw_player_once"):
		e.set("_saw_player_once", true)
		touched = true
	if _has_property(e, "_aggro"):
		e.set("_aggro", true)
		touched = true
	if not touched and e.has_method("force_aggro"):
		e.call("force_aggro")


func _has_property(o: Object, name: String) -> bool:
	for p in o.get_property_list():
		if p.has("name") and p["name"] == name:
			return true
	return false


func _detect_encounter_area(encounter_id: String, fallback: int) -> int:
	if typeof(EncounterDB) != TYPE_OBJECT:
		return fallback

	# Check each area's encounter list for the ID
	if EncounterDB.get("area1_encounters") != null:
		for enc in EncounterDB.area1_encounters:
			if enc.get("id", "") == encounter_id:
				return 1

	if EncounterDB.get("area2_encounters") != null:
		for enc in EncounterDB.area2_encounters:
			if enc.get("id", "") == encounter_id:
				return 2

	return fallback
