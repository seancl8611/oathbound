extends Node
class_name ProstheticExecutor

## Runtime prosthetic execution — child of Player.
## Handles spirit costs, cooldowns, spawning hitboxes/projectiles,
## and applying relic stat modifiers to prosthetic behavior.

signal prosthetic_used(prosthetic_id: String)
signal prosthetic_finished(prosthetic_id: String)
signal spirit_changed(current: int, max_value: int)

# --- Spirit Emblems ---
@export var max_spirit: int = 10
var current_spirit: int = 10

# --- Cooldown ---
@export var base_cooldown: float = 1.0
var _active_prosthetic_id: String = ""
var _use_timer: float = 0.0
var _use_duration: float = 0.0
var _cooldown_timer: float = 0.0
var _cooldown_total: float = 0.0

# --- References ---
var _owner_player: CharacterBody2D = null
var _combat: CombatController = null

# --- Projectiles ---
var _active_projectiles: Array = []
var _active_smoke_cloud: Dictionary = {}  # { "area": Area2D, "pos": Vector2, "radius": float }
	
# --- Prosthetic durations (how long the "using" state lasts) ---
var PROSTHETIC_USE_DURATIONS = {
	"beast_whistle": 0.35,
	"thunder_rod": 0.40,
	"smoke_gourd": 0.25,
	"fang_harpoon": 0.25,
	"mirror_umbrella": 1.5,
	"flame_vent": 0.30,
	"mist_raven": 0.25,
	"bloodletting_gourd": 0.40,
}

# --- Prosthetic cooldowns ---
var PROSTHETIC_COOLDOWNS = {
	"beast_whistle": 6.0,
	"thunder_rod": 6.0,
	"smoke_gourd": 7.0,
	"fang_harpoon": 3.5,
	"mirror_umbrella": 6.0,
	"flame_vent": 5.0,
	"mist_raven": 5.0,
	"bloodletting_gourd": 7.0,
}


func _ready():
	current_spirit = max_spirit


func setup(player: CharacterBody2D, combat_controller: CombatController) -> void:
	_owner_player = player
	_combat = combat_controller
	_combat.prosthetic_started.connect(_on_prosthetic_requested)

func _physics_process(delta: float) -> void:
	# Prosthetic use timer
	if _use_timer > 0.0:
		_use_timer -= delta
		if _use_timer <= 0.0:
			_finish_prosthetic()
	# Cooldown tick
	if _cooldown_timer > 0.0:
		_cooldown_timer -= delta
		if _cooldown_timer < 0.0:
			_cooldown_timer = 0.0
			
	# Mirror umbrella: end early when button released
	if _active_prosthetic_id == "mirror_umbrella" and _use_timer > 0.0:
		if not Input.is_action_pressed("prosthetic"):
			_use_timer = 0.0
			_finish_prosthetic()

	# Move projectiles
	var i = _active_projectiles.size() - 1
	while i >= 0:
		var proj = _active_projectiles[i]
		if not is_instance_valid(proj):
			_active_projectiles.remove_at(i)
		else:
			var dir = proj.get_meta("direction")
			var spd = proj.get_meta("speed")
			proj.global_position += dir * spd * delta
		i -= 1

	# Track player inside/outside smoke cloud
	if _active_smoke_cloud.size() > 0 and _owner_player:
		var cloud_area = _active_smoke_cloud.get("area", null)
		if cloud_area and is_instance_valid(cloud_area):
			var cloud_pos = _active_smoke_cloud.get("pos", Vector2.ZERO)
			var cloud_radius = _active_smoke_cloud.get("radius", 50.0)
			var dist = _owner_player.global_position.distance_to(cloud_pos)
			var was_in = _owner_player.has_meta("in_smoke_cloud") and _owner_player.get_meta("in_smoke_cloud")
			var is_in = dist <= cloud_radius

			_owner_player.set_meta("in_smoke_cloud", is_in)

			# Player just left the cloud
			if was_in and not is_in:
				_on_player_exit_smoke()
		else:
			# Cloud was freed — clean up
			_cleanup_smoke_cloud()
			
func _on_prosthetic_requested() -> void:
	var prosthetic_id = ProstheticManager.equipped_prosthetic_id
	if prosthetic_id == "":
		return

	var data = ProstheticManager.get_prosthetic(prosthetic_id)
	if data == null:
		return

	# Check spirit cost (apply relic modifiers)
	var modifiers = ProstheticManager.get_equipped_stat_modifiers()
	var cost = data.spirit_cost + modifiers.get("spirit_cost_reduction", 0)
	cost = max(0, cost)

	if current_spirit < cost:
		return

	# Spend spirit
	current_spirit -= cost
	spirit_changed.emit(current_spirit, max_spirit)

	# Start prosthetic use
	_active_prosthetic_id = prosthetic_id
	_use_duration = PROSTHETIC_USE_DURATIONS.get(prosthetic_id, 0.35)
	_use_timer = _use_duration

	if _combat:
		_combat.set_using_prosthetic(true)
		var cooldown = PROSTHETIC_COOLDOWNS.get(prosthetic_id, base_cooldown)
		_cooldown_timer = cooldown
		_cooldown_total = cooldown
		_combat.start_prosthetic_cooldown(cooldown)

	# Execute the actual prosthetic effect
	_execute_prosthetic(prosthetic_id, data, modifiers)
	prosthetic_used.emit(prosthetic_id)


func _execute_prosthetic(prosthetic_id: String, data: ProstheticData, modifiers: Dictionary) -> void:
	match prosthetic_id:
		"beast_whistle":
			_use_beast_whistle(modifiers)
		"thunder_rod":
			_use_thunder_rod(modifiers)
		"smoke_gourd":
			_use_smoke_gourd(modifiers)
		"fang_harpoon":
			_use_fang_harpoon(modifiers)
		"mirror_umbrella":
			_use_mirror_umbrella(modifiers)
		"flame_vent":
			_use_flame_vent(modifiers)
		"mist_raven":
			_use_mist_raven(modifiers)
		"bloodletting_gourd":
			_use_bloodletting_gourd(modifiers)
		_:
			push_warning("[ProstheticExecutor] No execution logic for: " + prosthetic_id)

func _finish_prosthetic() -> void:
	match _active_prosthetic_id:
		"mirror_umbrella":
			if _owner_player:
				_release_umbrella_wave()
				_owner_player.set_meta("mirror_umbrella_active", false)
				_owner_player.remove_meta("_umbrella_stored_posture")

	if _combat:
		_combat.set_using_prosthetic(false)
	prosthetic_finished.emit(_active_prosthetic_id)
	_active_prosthetic_id = ""
	
# =============================================================================
# PROSTHETIC IMPLEMENTATIONS
# =============================================================================

# ---------- 1. BEAST-BANE WHISTLE ----------
func _use_beast_whistle(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	var base_posture = 12.0 + modifiers.get("posture_damage_bonus", 0)
	var base_damage = 2
	var base_radius = 60.0
	var radius_mult = 1.0 + modifiers.get("range_bonus", 0.0)

	if ProstheticManager.is_upgrade_purchased("beast_whistle", "whistle_radius"):
		radius_mult += 0.3

	var final_radius = base_radius * radius_mult

	var beast_posture_bonus = 0.0
	if ProstheticManager.is_upgrade_purchased("beast_whistle", "whistle_beast_posture"):
		beast_posture_bonus = 8.0

	var can_interrupt = ProstheticManager.is_upgrade_purchased("beast_whistle", "whistle_interrupt")

	# Spawn circular pulse — carries all effect data as metadata
	var pulse = Area2D.new()
	pulse.collision_layer = 0
	pulse.collision_mask = 4  # Enemy layer
	pulse.add_to_group("attack")

	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = final_radius
	shape.shape = circle
	pulse.add_child(shape)

	pulse.global_position = _owner_player.global_position

	# Metadata for _on_hurt_box_hurt to read
	pulse.set_meta("attacker", _owner_player)
	pulse.set_meta("swing_token", Time.get_ticks_msec())
	pulse.set_meta("prosthetic_source", "beast_whistle")
	pulse.set_meta("stagger", true)
	pulse.set_meta("stagger_duration", 0.3)
	pulse.set_meta("hits", [])

	get_tree().current_scene.add_child(pulse)

	# Hit callback — routes through existing _on_hurt_box_hurt pipeline
	var on_hit = func(body: Node) -> void:
		if body == _owner_player:
			return
		if not body.is_in_group("enemy"):
			return
		var hits = pulse.get_meta("hits")
		if hits.has(body):
			return
		hits.append(body)
		pulse.set_meta("hits", hits)

		if not body.has_method("_on_hurt_box_hurt"):
			return

		# Beast detection — stronger effect on beast-tagged enemies
		var is_beast = false
		if body.has_method("get_enemy_tags"):
			is_beast = body.get_enemy_tags().has("beast")
		elif body.get("enemy_tags") != null:
			is_beast = body.enemy_tags.has("beast")

		var posture_dmg = base_posture
		var hp_dmg = base_damage
		var stagger_dur = 0.3

		if is_beast:
			posture_dmg += beast_posture_bonus
			hp_dmg = int(hp_dmg * 1.5)
			stagger_dur = 0.6

		# Update per-target values on the pulse before calling
		pulse.set_meta("posture_damage", posture_dmg)
		pulse.set_meta("stagger_duration", stagger_dur)
		if can_interrupt:
			pulse.set_meta("interrupt", true)

		# Route through existing pipeline — "true" bypasses block (sonic wave)
		body._on_hurt_box_hurt(hp_dmg, "true", pulse)

	_connect_enemy_detection(pulse, on_hit)

	# Deferred check for bodies/areas already overlapping on spawn frame
	pulse.set_deferred("monitoring", true)
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(pulse):
			for body in pulse.get_overlapping_bodies():
				pulse.body_entered.emit(body)
			for area in pulse.get_overlapping_areas():
				pulse.area_entered.emit(area)
	)

	# Cleanup — pulse is instant
	get_tree().create_timer(0.15).timeout.connect(func():
		if is_instance_valid(pulse):
			pulse.queue_free()
	)
	
# ---------- 2. THUNDER ROD ----------
func _use_thunder_rod(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	var aim_dir = _get_aim_direction()

	var bolt_speed = 400.0
	var bolt_range = 200.0
	var bolt_hp_damage = 3
	var bolt_posture_damage = 10.0 + modifiers.get("posture_damage_bonus", 0)
	var shock_duration = 4.0
	var shock_posture_penalty = 6.0

	var can_chain = ProstheticManager.is_upgrade_purchased("thunder_rod", "thunder_chain")
	if ProstheticManager.is_upgrade_purchased("thunder_rod", "thunder_duration"):
		shock_duration *= 1.5
	var grants_parry_bonus = ProstheticManager.is_upgrade_purchased("thunder_rod", "thunder_parry")

	# Spawn line projectile
	var bolt = Area2D.new()
	bolt.collision_layer = 0
	bolt.collision_mask = 4  # Enemy layer
	bolt.add_to_group("attack")

	var shape = CollisionShape2D.new()
	var capsule = CapsuleShape2D.new()
	capsule.radius = 8.0
	capsule.height = 24.0
	shape.shape = capsule
	shape.rotation = aim_dir.angle() + PI / 2.0
	bolt.add_child(shape)

	bolt.global_position = _owner_player.global_position + aim_dir * 16.0

	# Metadata — same patterns as your existing hitboxes
	bolt.set_meta("attacker", _owner_player)
	bolt.set_meta("swing_token", Time.get_ticks_msec())
	bolt.set_meta("prosthetic_source", "thunder_rod")
	bolt.set_meta("posture_damage", bolt_posture_damage)
	bolt.set_meta("shock_duration", shock_duration)
	bolt.set_meta("shock_posture", shock_posture_penalty)
	bolt.set_meta("direction", aim_dir)
	bolt.set_meta("speed", bolt_speed)
	bolt.set_meta("hits", [])
	bolt.set_meta("hit_primary", false)
	bolt.set_meta("damage_type", "prosthetic")
	
	get_tree().current_scene.add_child(bolt)

	# Simple visual
	var visual = ColorRect.new()
	visual.size = Vector2(20, 6)
	visual.position = Vector2(-10, -3)
	visual.color = Color(0.6, 0.85, 1.0, 0.9)
	visual.rotation = aim_dir.angle()
	bolt.add_child(visual)

	# Hit callback — extracted so both body_entered and area_entered can use it
	var on_bolt_hit = func(body: Node) -> void:
		if body == _owner_player:
			return
		if not body.is_in_group("enemy"):
			return
		var hits = bolt.get_meta("hits")
		if hits.has(body):
			return
		hits.append(body)
		bolt.set_meta("hits", hits)

		if not body.has_method("_on_hurt_box_hurt"):
			return

		# Route through existing pipeline — blockable
		body._on_hurt_box_hurt(bolt_hp_damage, "prosthetic", bolt)

		# Parry bonus flag for player to read
		if grants_parry_bonus and body.has_method("is_shocked"):
			_owner_player.set_meta("thunder_parry_target", body)

		# First hit stops the bolt
		if not bolt.get_meta("hit_primary"):
			bolt.set_meta("hit_primary", true)

			if can_chain:
				_thunder_chain_to_nearby(body, bolt_hp_damage, bolt_posture_damage, shock_duration, shock_posture_penalty)

			bolt.set_meta("speed", 0.0)
			get_tree().create_timer(0.05).timeout.connect(func():
				if is_instance_valid(bolt):
					bolt.queue_free()
			)

	_connect_enemy_detection(bolt, on_bolt_hit)

	# Movement handled by existing _active_projectiles in _physics_process
	_active_projectiles.append(bolt)

	# Max lifetime
	var max_time = bolt_range / bolt_speed
	get_tree().create_timer(max_time + 0.1).timeout.connect(func():
		if is_instance_valid(bolt):
			bolt.queue_free()
	)

func _thunder_chain_to_nearby(primary_target: Node, hp_dmg: int, posture_dmg: float, shock_dur: float, shock_post: float) -> void:
	if not is_instance_valid(primary_target):
		return

	var chain_radius = 80.0
	var best_enemy = null
	var best_dist = chain_radius

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy == primary_target or not is_instance_valid(enemy):
			continue
		if not enemy.has_method("_on_hurt_box_hurt"):
			continue
		var dist = primary_target.global_position.distance_to(enemy.global_position)
		if dist < best_dist:
			best_dist = dist
			best_enemy = enemy

	if best_enemy == null:
		return

	# Temp Area2D to carry chain hit metadata through the pipeline
	var chain_area = Area2D.new()
	chain_area.add_to_group("attack")
	chain_area.set_meta("attacker", _owner_player)
	chain_area.set_meta("swing_token", Time.get_ticks_msec() + 1)
	chain_area.set_meta("prosthetic_source", "thunder_rod")
	chain_area.set_meta("posture_damage", posture_dmg * 0.6)
	chain_area.set_meta("shock_duration", shock_dur)
	chain_area.set_meta("shock_posture", shock_post)

	get_tree().current_scene.add_child(chain_area)

	best_enemy._on_hurt_box_hurt(int(hp_dmg * 0.5), "prosthetic", chain_area)

	_spawn_chain_visual(primary_target.global_position, best_enemy.global_position)

	chain_area.queue_free()


# ─────────────────────────────────────────────────────────────────────────────
# NEW: _spawn_chain_visual — quick jagged line between two points
# ─────────────────────────────────────────────────────────────────────────────

func _spawn_chain_visual(from_pos: Vector2, to_pos: Vector2) -> void:
	var line = Line2D.new()
	line.width = 3.0
	line.default_color = Color(0.6, 0.85, 1.0, 0.8)
	line.z_index = 100

	var dir = (to_pos - from_pos)
	var norm = dir.normalized()
	var perp = Vector2(-norm.y, norm.x)

	line.add_point(from_pos)
	for i in range(1, 4):
		var t = float(i) / 4.0
		var mid = from_pos + dir * t + perp * randf_range(-8.0, 8.0)
		line.add_point(mid)
	line.add_point(to_pos)

	get_tree().current_scene.add_child(line)

	var tw = get_tree().create_tween()
	tw.tween_property(line, "modulate:a", 0.0, 0.2)
	tw.tween_callback(func():
		if is_instance_valid(line):
			line.queue_free()
	)
	
# ---------- 3. SMOKE GOURD ----------
func _use_smoke_gourd(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	var cloud_duration = 3.0
	var cloud_radius = 55.0
	var confusion_duration = 2.5

	# Upgrade: longer cloud duration
	if ProstheticManager.is_upgrade_purchased("smoke_gourd", "smoke_iframes"):
		cloud_duration += 1.0

	# Upgrade: slow enemies
	var should_slow = ProstheticManager.is_upgrade_purchased("smoke_gourd", "smoke_slow")

	# Upgrade: smoke slash
	var smoke_slash = ProstheticManager.is_upgrade_purchased("smoke_gourd", "smoke_slash")

	var cloud_pos = _owner_player.global_position

	# Spawn cloud Area2D (kept for visual + reference)
	var cloud = Area2D.new()
	cloud.collision_layer = 0
	cloud.collision_mask = 4
	cloud.global_position = cloud_pos

	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = cloud_radius
	shape.shape = circle
	cloud.add_child(shape)

	cloud.set_meta("hits", [])

	get_tree().current_scene.add_child(cloud)

	# Visual — semi-transparent smoke circle
	var visual = Polygon2D.new()
	var points = PackedVector2Array()
	var seg = 24
	for s in range(seg):
		var angle = float(s) / float(seg) * TAU
		points.append(Vector2(cos(angle), sin(angle)) * cloud_radius)
	visual.polygon = points
	visual.color = Color(0.6, 0.6, 0.6, 0.35)
	visual.z_index = -1
	cloud.add_child(visual)

	# Store cloud reference for player tracking in _physics_process
	_active_smoke_cloud = { "area": cloud, "pos": cloud_pos, "radius": cloud_radius }

	# Player starts inside the cloud
	_owner_player.set_meta("in_smoke_cloud", true)

	# Set smoke_slash ready if upgraded (consumed on first hit after leaving)
	if smoke_slash:
		_owner_player.set_meta("smoke_slash_ready", true)

	# --- Immediate scan: confuse all enemies already in range ---
	_apply_smoke_to_nearby_enemies(cloud, cloud_pos, cloud_radius, confusion_duration, should_slow)

	# --- Recurring scan every 0.4s so enemies that walk in also get confused ---
	var scan_count = int(cloud_duration / 0.4)
	for i in range(scan_count):
		var delay = 0.4 * (i + 1)
		get_tree().create_timer(delay).timeout.connect(func():
			if is_instance_valid(cloud):
				_apply_smoke_to_nearby_enemies(cloud, cloud_pos, cloud_radius, confusion_duration, should_slow)
		)

	# Cloud lifetime — fade out and clean up
	get_tree().create_timer(cloud_duration).timeout.connect(func():
		if is_instance_valid(cloud):
			var tw = get_tree().create_tween()
			tw.tween_property(visual, "color:a", 0.0, 0.3)
			tw.tween_callback(func():
				if is_instance_valid(cloud):
					cloud.queue_free()
				_cleanup_smoke_cloud()
			)
	)
	
func _on_player_exit_smoke() -> void:
	# Upgrade: brief i-frames on exiting smoke
	if ProstheticManager.is_upgrade_purchased("smoke_gourd", "smoke_iframes"):
		if _owner_player and _owner_player.has_method("set_invincibility"):
			_owner_player.set_invincibility(true)
			get_tree().create_timer(0.25).timeout.connect(func():
				if is_instance_valid(_owner_player) and _owner_player.has_method("set_invincibility"):
					# Only clear if dodge iframes aren't active (dodge manages its own)
					if "_is_invincible" in _owner_player and not _owner_player._is_invincible:
						_owner_player.set_invincibility(false)
			)


func _cleanup_smoke_cloud() -> void:
	if _owner_player:
		_owner_player.set_meta("in_smoke_cloud", false)
		# Don't clear smoke_slash_ready here — it persists until consumed by a hit
	_active_smoke_cloud = {}

func _apply_smoke_to_nearby_enemies(cloud: Area2D, cloud_pos: Vector2, cloud_radius: float, confusion_duration: float, should_slow: bool) -> void:
	if not is_instance_valid(cloud):
		return
	var hits = cloud.get_meta("hits")
	for enemy in get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		if hits.has(enemy):
			continue
		if enemy.global_position.distance_to(cloud_pos) > cloud_radius:
			continue

		hits.append(enemy)
		cloud.set_meta("hits", hits)

		# === UNIVERSAL: works on ANY enemy, no has_method check needed ===
		ProstheticEffects.apply_confusion(enemy, confusion_duration)

		if should_slow and enemy.get("movement_speed") != null:
			var original = enemy.movement_speed
			enemy.movement_speed *= 0.5
			get_tree().create_timer(confusion_duration).timeout.connect(func():
				if is_instance_valid(enemy) and enemy.get("movement_speed") != null:
					enemy.movement_speed = original
			)
			
# ---------- 4. FANG HARPOON ----------
func _use_fang_harpoon(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	var aim_dir = _get_aim_direction()

	var harpoon_speed = 350.0
	var harpoon_range = 150.0
	var harpoon_hp_damage = 4
	var harpoon_posture_damage = 6.0 + modifiers.get("posture_damage_bonus", 0)
	var pull_force = 80.0

	# Upgrades
	var can_pierce = ProstheticManager.is_upgrade_purchased("fang_harpoon", "harpoon_pierce")
	var spirit_refund = ProstheticManager.is_upgrade_purchased("fang_harpoon", "harpoon_refund")
	if ProstheticManager.is_upgrade_purchased("fang_harpoon", "harpoon_pull"):
		pull_force = 140.0  # Stronger but still capped

	# Spawn harpoon projectile
	var harpoon = Area2D.new()
	harpoon.collision_layer = 0
	harpoon.collision_mask = 4  # Enemy layer
	harpoon.add_to_group("attack")

	var shape = CollisionShape2D.new()
	var capsule = CapsuleShape2D.new()
	capsule.radius = 5.0
	capsule.height = 16.0
	shape.shape = capsule
	shape.rotation = aim_dir.angle() + PI / 2.0
	harpoon.add_child(shape)

	harpoon.global_position = _owner_player.global_position + aim_dir * 14.0

	# Metadata — same patterns as thunder rod
	harpoon.set_meta("attacker", _owner_player)
	harpoon.set_meta("swing_token", Time.get_ticks_msec())
	harpoon.set_meta("prosthetic_source", "fang_harpoon")
	harpoon.set_meta("damage_type", "prosthetic")
	harpoon.set_meta("posture_damage", harpoon_posture_damage)
	harpoon.set_meta("interrupt", true)
	harpoon.set_meta("pull_force", pull_force)
	harpoon.set_meta("direction", aim_dir)
	harpoon.set_meta("speed", harpoon_speed)
	harpoon.set_meta("hits", [])

	get_tree().current_scene.add_child(harpoon)

	# Simple visual — small elongated shape
	var visual = ColorRect.new()
	visual.size = Vector2(14, 4)
	visual.position = Vector2(-7, -2)
	visual.color = Color(0.75, 0.65, 0.5, 0.9)
	visual.rotation = aim_dir.angle()
	harpoon.add_child(visual)

	# Capture reference for spirit refund closure
	var executor_ref = self

	# Hit callback — extracted so both body_entered and area_entered can use it
	var on_harpoon_hit = func(body: Node) -> void:
		if body == _owner_player:
			return
		if not body.is_in_group("enemy"):
			return
		var hits = harpoon.get_meta("hits")
		if hits.has(body):
			return
		hits.append(body)
		harpoon.set_meta("hits", hits)

		if not body.has_method("_on_hurt_box_hurt"):
			return

		# Route through existing pipeline — blockable
		body._on_hurt_box_hurt(harpoon_hp_damage, "prosthetic", harpoon)

		# Spirit refund check: if posture broke from this hit
		if spirit_refund and is_instance_valid(executor_ref):
			if body.has_method("is_deathblow_ready") and body.is_deathblow_ready():
				executor_ref.restore_spirit(1)

		# Stop on first hit unless pierce upgrade
		if not can_pierce:
			harpoon.set_meta("speed", 0.0)
			get_tree().create_timer(0.05).timeout.connect(func():
				if is_instance_valid(harpoon):
					harpoon.queue_free()
			)

	_connect_enemy_detection(harpoon, on_harpoon_hit)

	# Movement handled by existing _active_projectiles
	_active_projectiles.append(harpoon)

	# Max lifetime
	var max_time = harpoon_range / harpoon_speed
	get_tree().create_timer(max_time + 0.1).timeout.connect(func():
		if is_instance_valid(harpoon):
			harpoon.queue_free()
	)
	
# ---------- 5. MIRROR UMBRELLA ----------
func _use_mirror_umbrella(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	_owner_player.set_meta("mirror_umbrella_active", true)
	_owner_player.set_meta("_umbrella_stored_posture", 0.0)
	
# ---------- 6. FLAME VENT ----------
func _use_flame_vent(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	var aim_dir = _get_aim_direction()
	var cone_range = 65.0
	var cone_half_angle = 50.0  # degrees — ~100° arc
	var hp_damage = 3
	var burn_duration = 4.0
	var burn_dps = 3.0  # HP per second while burning

	# Build a polygon cone shape (fan/wedge) so collision itself is directional
	var points = PackedVector2Array()
	points.append(Vector2.ZERO)  # apex at player
	var segments = 8
	var base_angle = aim_dir.angle()
	for i in range(segments + 1):
		var t = float(i) / float(segments)
		var a = base_angle + deg_to_rad(-cone_half_angle + t * cone_half_angle * 2.0)
		points.append(Vector2(cos(a), sin(a)) * cone_range)

	var burst = Area2D.new()
	burst.collision_layer = 0
	burst.collision_mask = 4  # Enemy layer
	burst.add_to_group("attack")

	var shape = CollisionShape2D.new()
	var poly = ConvexPolygonShape2D.new()
	poly.points = points
	shape.shape = poly
	burst.add_child(shape)

	burst.global_position = _owner_player.global_position

	# Metadata for ProstheticEffects.apply() pipeline
	burst.set_meta("attacker", _owner_player)
	burst.set_meta("swing_token", Time.get_ticks_msec())
	burst.set_meta("prosthetic_source", "flame_vent")
	burst.set_meta("burn_duration", burn_duration)
	burst.set_meta("burn_dps", burn_dps)
	burst.set_meta("hits", [])

	get_tree().current_scene.add_child(burst)

	var on_hit = func(body: Node) -> void:
		if body == _owner_player:
			return
		if not body.is_in_group("enemy"):
			return
		var hits = burst.get_meta("hits")
		if hits.has(body):
			return
		hits.append(body)
		burst.set_meta("hits", hits)

		if not body.has_method("_on_hurt_box_hurt"):
			return

		# Route through existing pipeline — blockable, small HP damage
		body._on_hurt_box_hurt(hp_damage, "prosthetic", burst)

	_connect_enemy_detection(burst, on_hit)

	# Deferred overlap check for enemies already in cone
	burst.set_deferred("monitoring", true)
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(burst):
			for body in burst.get_overlapping_bodies():
				burst.body_entered.emit(body)
			for area in burst.get_overlapping_areas():
				burst.area_entered.emit(area)
	)

	# Cleanup — burst is instant
	get_tree().create_timer(0.15).timeout.connect(func():
		if is_instance_valid(burst):
			burst.queue_free()
	)
	
# ---------- 8. MIST RAVEN ----------
func _use_mist_raven(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	var aim_dir = _get_aim_direction()
	var teleport_dist = 100.0
	var iframe_time = 0.35  # Covers use_duration (0.25s) + buffer to move away
	var path_posture_dmg = 8.0
	var speed_boost = 0.38
	var boost_duration = 1.2

	var start_pos = _owner_player.global_position
	var end_pos = start_pos + aim_dir * teleport_dist

	# --- I-frames FIRST (before teleport so overlap on arrival is safe) ---
	if _owner_player.has_method("set_invincibility"):
		_owner_player.set_invincibility(true)
		get_tree().create_timer(iframe_time).timeout.connect(func():
			if is_instance_valid(_owner_player) and _owner_player.has_method("set_invincibility"):
				_owner_player.set_invincibility(false)
		)

	# --- Teleport ---
	_owner_player.global_position = end_pos

	# --- Speed boost (stored as meta, applied in player _calculate_velocity) ---
	var now = Time.get_ticks_msec() * 0.001
	_owner_player.set_meta("_mist_raven_boost", speed_boost)
	_owner_player.set_meta("_mist_raven_boost_until", now + boost_duration)

	# --- Path damage: thin rectangle from start to end ---
	var mid_pos = (start_pos + end_pos) * 0.5
	var path_length = teleport_dist

	var path_hit = Area2D.new()
	path_hit.collision_layer = 0
	path_hit.collision_mask = 4
	path_hit.add_to_group("attack")

	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(path_length, 20.0)
	shape.shape = rect
	shape.rotation = aim_dir.angle()
	path_hit.add_child(shape)

	path_hit.global_position = mid_pos

	path_hit.set_meta("attacker", _owner_player)
	path_hit.set_meta("swing_token", Time.get_ticks_msec())
	path_hit.set_meta("prosthetic_source", "mist_raven")
	path_hit.set_meta("posture_damage", path_posture_dmg)
	path_hit.set_meta("hits", [])

	get_tree().current_scene.add_child(path_hit)

	var on_hit = func(body: Node) -> void:
		if body == _owner_player:
			return
		if not body.is_in_group("enemy"):
			return
		var hits = path_hit.get_meta("hits")
		if hits.has(body):
			return
		hits.append(body)
		path_hit.set_meta("hits", hits)
		if body.has_method("_on_hurt_box_hurt"):
			body._on_hurt_box_hurt(0, "prosthetic", path_hit)

	_connect_enemy_detection(path_hit, on_hit)

	path_hit.set_deferred("monitoring", true)
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(path_hit):
			for body in path_hit.get_overlapping_bodies():
				path_hit.body_entered.emit(body)
			for area in path_hit.get_overlapping_areas():
				path_hit.area_entered.emit(area)
	)

	get_tree().create_timer(0.12).timeout.connect(func():
		if is_instance_valid(path_hit):
			path_hit.queue_free()
	)
	
# ---------- 9. BLOODLETTING GOURD ----------
func _use_bloodletting_gourd(modifiers: Dictionary) -> void:
	if _owner_player == null:
		return

	# Instant heal
	var instant_heal = 10
	_owner_player.hp = min(_owner_player.maxhp, _owner_player.hp + instant_heal)
	if _owner_player.has_method("_update_health_bar"):
		_owner_player._update_health_bar()

	# Set lifesteal window (checked by enemies when taking sword HP damage)
	var now = Time.get_ticks_msec() * 0.001
	_owner_player.set_meta("_lifesteal_until", now + 3.0)
	_owner_player.set_meta("_lifesteal_per_hit", 2)
	_owner_player.set_meta("_lifesteal_remaining", 10)
	
# =============================================================================
# HELPERS
# =============================================================================

func _get_aim_direction() -> Vector2:
	if _owner_player == null:
		return Vector2.RIGHT
	var mouse_pos = _owner_player.get_global_mouse_position()
	var dir = (mouse_pos - _owner_player.global_position).normalized()
	if dir.length() < 0.1:
		return Vector2.RIGHT
	return dir
	
func _create_prosthetic_hitbox(direction: Vector2, range_dist: float, width: float, damage: int, posture_damage: float, lifetime: float) -> Area2D:
	## Creates a short-lived Area2D hitbox for melee prosthetics.
	var hitbox = Area2D.new()
	hitbox.collision_layer = 0
	hitbox.collision_mask = 4  # Enemy layer

	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(range_dist, width)
	shape.shape = rect
	hitbox.add_child(shape)

	# Position in front of player
	hitbox.global_position = _owner_player.global_position + direction * (range_dist * 0.5)
	hitbox.rotation = direction.angle()

	# Store damage info as metadata
	hitbox.set_meta("damage", damage)
	hitbox.set_meta("posture_damage", posture_damage)
	hitbox.set_meta("source", _owner_player)

	get_tree().current_scene.add_child(hitbox)

	# Connect to detect hits
	hitbox.body_entered.connect(func(body):
		if body.has_method("take_damage"):
			var event = {
				"damage": hitbox.get_meta("damage"),
				"posture_damage": hitbox.get_meta("posture_damage"),
				"source": _owner_player,
				"prosthetic": true,
			}
			if hitbox.has_meta("burn_duration"):
				event["burn_duration"] = hitbox.get_meta("burn_duration")
			if hitbox.has_meta("knockback_force"):
				event["knockback_force"] = hitbox.get_meta("knockback_force")
				event["knockback_dir"] = (_owner_player.global_position.direction_to(body.global_position))
			if hitbox.has_meta("stagger"):
				event["stagger"] = hitbox.get_meta("stagger")
			if hitbox.has_meta("stagger_duration"):
				event["stagger_duration"] = hitbox.get_meta("stagger_duration")
			body.take_damage(event)
	)

	# Auto-cleanup
	var timer = get_tree().create_timer(lifetime)
	timer.timeout.connect(func():
		if is_instance_valid(hitbox):
			hitbox.queue_free()
	)

	return hitbox

# MIRROR UMBRELLA — called by player each time umbrella blocks a hit
func on_umbrella_absorb(damage: int) -> void:
	if _owner_player == null:
		return
	var store_amount = float(damage) * 0.5
	var current = float(_owner_player.get_meta("_umbrella_stored_posture", 0.0))
	var cap = 30.0
	_owner_player.set_meta("_umbrella_stored_posture", min(cap, current + store_amount))
	
# MIRROR UMBRELLA — on close, release stored posture as radial shock
func _release_umbrella_wave() -> void:
	if _owner_player == null:
		return
	var stored = float(_owner_player.get_meta("_umbrella_stored_posture", 0.0))
	if stored <= 0.0:
		return

	var wave = Area2D.new()
	wave.collision_layer = 0
	wave.collision_mask = 4  # Enemy layer
	wave.add_to_group("attack")

	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 55.0
	shape.shape = circle
	wave.add_child(shape)

	wave.global_position = _owner_player.global_position

	# Metadata — routes through existing enemy _on_hurt_box_hurt pipeline
	wave.set_meta("attacker", _owner_player)
	wave.set_meta("prosthetic_source", "mirror_umbrella")
	wave.set_meta("swing_token", Time.get_ticks_msec())
	wave.set_meta("posture_damage", stored)
	wave.set_meta("stagger", true)
	wave.set_meta("stagger_duration", 0.2)
	wave.set_meta("hits", [])

	get_tree().current_scene.add_child(wave)

	var on_hit = func(body: Node) -> void:
		if body == _owner_player:
			return
		if not body.is_in_group("enemy"):
			return
		var hits = wave.get_meta("hits")
		if hits.has(body):
			return
		hits.append(body)
		wave.set_meta("hits", hits)
		if body.has_method("_on_hurt_box_hurt"):
			body._on_hurt_box_hurt(0, "prosthetic", wave)

	_connect_enemy_detection(wave, on_hit)

	# Deferred overlap check for enemies already in range
	wave.set_deferred("monitoring", true)
	get_tree().create_timer(0.05).timeout.connect(func():
		if is_instance_valid(wave):
			for body in wave.get_overlapping_bodies():
				wave.body_entered.emit(body)
			for area in wave.get_overlapping_areas():
				wave.area_entered.emit(area)
	)

	# Brief pulse — auto-cleanup
	get_tree().create_timer(0.12).timeout.connect(func():
		if is_instance_valid(wave):
			wave.queue_free()
	)
	
func _spawn_projectile(direction: Vector2, speed: float, damage: int, posture_damage: float, pierce: bool) -> void:
	## Creates a simple projectile Area2D that moves in a direction.
	var proj = Area2D.new()
	proj.collision_layer = 0
	proj.collision_mask = 4  # Enemy layer

	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 4.0
	shape.shape = circle
	proj.add_child(shape)

	proj.global_position = _owner_player.global_position + direction * 12.0

	proj.set_meta("damage", damage)
	proj.set_meta("posture_damage", posture_damage)
	proj.set_meta("direction", direction)
	proj.set_meta("speed", speed)
	proj.set_meta("pierce", pierce)
	proj.set_meta("source", _owner_player)
	proj.set_meta("hits", [])  # Track what we've already hit

	get_tree().current_scene.add_child(proj)

	proj.body_entered.connect(func(body):
		if body == _owner_player:
			return
		var hits = proj.get_meta("hits")
		if hits.has(body):
			return
		hits.append(body)
		proj.set_meta("hits", hits)

		if body.has_method("take_damage"):
			var event = {
				"damage": proj.get_meta("damage"),
				"posture_damage": proj.get_meta("posture_damage"),
				"source": _owner_player,
				"prosthetic": true,
			}
			body.take_damage(event)

		if not proj.get_meta("pierce"):
			proj.queue_free()
	)
	
	_active_projectiles.append(proj)
	
	# Auto-cleanup after max range time
	var timer = get_tree().create_timer(2.0)
	timer.timeout.connect(func():
		if is_instance_valid(proj):
			proj.queue_free()
	)

func get_spirit() -> int:
	return current_spirit

func get_max_spirit() -> int:
	return max_spirit

func restore_spirit(amount: int) -> void:
	current_spirit = min(max_spirit, current_spirit + amount)
	spirit_changed.emit(current_spirit, max_spirit)

func reset_spirit() -> void:
	current_spirit = max_spirit
	spirit_changed.emit(current_spirit, max_spirit)

func get_active_prosthetic_id() -> String:
	return _active_prosthetic_id

func is_using() -> bool:
	return _use_timer > 0.0

## Connects both body_entered and area_entered on a prosthetic Area2D.
## body_entered catches regular enemies (CharacterBody2D on layer 3).
## area_entered catches bosses (whose HurtBox Area2D is on layer 3
## but whose CharacterBody2D is on a different layer).
## hit_callback receives a single Node — the enemy CharacterBody2D.
## Deduplication is handled by the prosthetic's existing "hits" meta array
## inside the hit_callback (each prosthetic already checks this).
func _connect_enemy_detection(prosthetic_area: Area2D, hit_callback: Callable) -> void:
	prosthetic_area.body_entered.connect(func(body: Node) -> void:
		if body != _owner_player:
			hit_callback.call(body)
	)
	prosthetic_area.area_entered.connect(func(area: Area2D) -> void:
		var body = area.get_parent()
		if body != null and body != _owner_player:
			hit_callback.call(body)
)

func get_cooldown_pct() -> float:
	if _cooldown_total <= 0.0:
		return 0.0
	return clampf(_cooldown_timer / _cooldown_total, 0.0, 1.0)

func get_equipped_info() -> Dictionary:
	var pid = ProstheticManager.equipped_prosthetic_id
	if pid == "":
		return {"id": "", "spirit_cost": 0, "sockets": 0, "filled": 0}
	var data = ProstheticManager.get_prosthetic(pid)
	if data == null:
		return {"id": pid, "spirit_cost": 0, "sockets": 0, "filled": 0}
	var socketed = ProstheticManager.get_socketed_relics(pid)
	var filled = 0
	for r in socketed:
		if r != "":
			filled += 1
	return {
		"id": pid,
		"spirit_cost": data.spirit_cost,
		"sockets": data.relic_sockets if "relic_sockets" in data else 0,
		"filled": filled,
	}
