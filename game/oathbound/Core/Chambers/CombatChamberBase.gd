extends RoomBase

## =============================================================================
## COMBAT ROOM - v2.0 SEKIRO DUEL SYSTEM
## =============================================================================
## Philosophy: Support sequential dueling, not crowd management
## - Strict token limits (1 attacker at a time)
## - Longer cooldowns for deliberate pacing
## - Proper wave spacing
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
	"gold":        {1: 50, 2: 75, 3: 100},
	"mist":        {1: 4,  2: 5,  3: 6},
	"scroll":      {1: 1,  2: 2,  3: 3},
	"maxhp":       {1: 3,  2: 4,  3: 5},
	"maxposture":  {1: 5,  2: 7,  3: 10},
}

func _ready() -> void:
	print("[CombatRoom] v2.0 - Sekiro Duel System")
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
	
	# Initialize AttackDirector with duel settings BEFORE starting encounter
	_configure_duel_tokens()
	
	_start_encounter()


## Configure AttackDirector for Sekiro-style dueling
func _configure_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return
	
	# CORE DUEL SETTINGS - One attacker at a time
	AttackDir.set_role_limits({
		"melee_attack": 1,    # Only ONE enemy attacks at a time
		"advance_move": 2,    # Two can approach (one dueling, one waiting)
		"ranged_attack": 1,   # One ranged enemy can fire
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1
	})
	
	# LONG COOLDOWNS - Deliberate pacing
	AttackDir.set_role_cooldowns({
		"melee_attack": 4.0,  # Same enemy can't attack again for 4 seconds
		"advance_move": 2.0,  # Slower approach cycling
		"ranged_attack": 3.5, # Archers fire less often
		"frontal": 1.5,
		"flank_left": 1.5,
		"flank_right": 1.5
	})
	
	# Configure global grant gap if available
	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 1.2  # 1.2 seconds between any attack grants
	
	# Configure attack turnover if available
	if _has_property(AttackDir, "attack_turnover_delay"):
		AttackDir.attack_turnover_delay = 1.8  # Delay after attack before next enemy can go
	
	print("[CombatRoom] Duel tokens configured: 1 melee, 2 advance, long cooldowns")

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
	
	# Start token management
	_start_token_autoscale()


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
	
	# Determine reward amount (0 for boon — handled internally by pickup)
	var amount = 0
	if reward_key != "boon" and reward_key != "":
		var table = COMBAT_REWARDS.get(reward_key, {})
		amount = table.get(area_id, table.get(1, 0))
	
	# Default to boon if no reward key
	if reward_key == "":
		reward_key = "boon"
	
	# Find spawn position (center of room or near player)
	var spawn_pos = Vector2.ZERO
	var room_center = get_node_or_null("RoomCenter")
	if room_center and room_center is Node2D:
		spawn_pos = room_center.global_position
	else:
		# Fallback: use spawn rect center
		spawn_pos = _spawn_rect.get_center() if _spawn_rect.size != Vector2.ZERO else global_position
	
	# Spawn the pickup
	var RewardPickupScript = load("res://Objects/RewardPickup.gd")
	var pickup = RewardPickupScript.new()
	pickup.setup(reward_key, amount, area_id)
	pickup.global_position = spawn_pos
	add_child(pickup)
	
	# Wait for player to collect, then unlock gates
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


func _grant_max_posture(amount: int) -> void:
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		var p = players[0]
		if "stagger_max" in p:
			p.stagger_max += amount
			
## Default fallback template - simple duel encounter
func _default_template() -> Dictionary:
	return {
		"id": "fallback_duel",
		"wave_spacing": [8.0, 10.0],
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
	# Token scaling is still handled by autoscale tick.


func _start_token_autoscale() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return
	if not is_instance_valid(self):
		return
	
	if not has_node("TokenTick"):
		var t = Timer.new()
		t.name = "TokenTick"
		t.wait_time = 1.0  # Slower tick for deliberate combat
		t.one_shot = false
		add_child(t)
		t.timeout.connect(_autoscale_tick)
	
	# Initial tick
	_autoscale_tick()
	$TokenTick.start()


func _autoscale_tick() -> void:
	# Recount alive enemies
	var count = 0
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e) and is_ancestor_of(e):
			count += 1
	_alive = count

	# Check aggro state
	_update_encounter_aggro_lock()
	
	# Update tokens based on enemy count
	# KEY: Even with more enemies, keep strict duel limits
	_update_duel_tokens()


## Update tokens maintaining duel feel regardless of enemy count
func _update_duel_tokens() -> void:
	if typeof(AttackDir) != TYPE_OBJECT:
		return

	var alive = 0
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e) and is_ancestor_of(e):
			alive += 1

	# SEKIRO DUEL PHILOSOPHY:
	# - Always keep melee attackers at 1 (true dueling)
	# - Only slightly increase advance slots with more enemies
	# - Ranged stays at 1 to not overwhelm
	
	var melee = 1                           # ALWAYS 1 - core duel principle
	var advance = clampi(alive / 2, 1, 2)   # 1-2 can approach
	var ranged = 1                          # Always 1 ranged
	
	AttackDir.set_role_limits({
		"melee_attack": melee,
		"advance_move": advance,
		"ranged_attack": ranged,
		"frontal": 1,
		"flank_left": 1,
		"flank_right": 1
	})

	# Keep cooldowns long for deliberate pacing
	AttackDir.set_role_cooldowns({
		"melee_attack": 4.0,
		"advance_move": 2.0,
		"ranged_attack": 3.5,
		"frontal": 1.5,
		"flank_left": 1.5,
		"flank_right": 1.5
	})

	if _has_property(AttackDir, "grant_gap_sec"):
		AttackDir.grant_gap_sec = 1.2


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
