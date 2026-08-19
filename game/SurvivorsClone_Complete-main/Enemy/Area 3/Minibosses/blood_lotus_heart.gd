extends EnemyBase
class_name BloodLotusHeart

signal defeated

# =============================================================================
# CONFIGURATION
# =============================================================================

## Total boss HP — only damaged via deathblow during core windows
@export var total_hp: int = 3
## Deathblow damage per core window (1 = 3 cycles to kill)
@export var deathblow_chunk: int = 1
## How many stalks per cycle
@export var stalks_per_cycle: int = 3
## Core exposure duration (seconds)
@export var core_window_duration: float = 5.0
## Posture needed to deathblow the core (fills fast from sword hits)
@export var core_posture_max: float = 40.0
## Time before Orb of Fury triggers (if stalks still alive)
@export var orb_fury_delay: float = 12.0
## Orb count per fury
@export var orb_count: int = 5
## Orb speed
@export var orb_speed: float = 120.0
## Orb tracking strength (0-1, higher = tighter tracking)
@export var orb_tracking: float = 0.6
## Orb HP damage
@export var orb_damage: int = 4
## Time between stalk re-emerge after orb phase
@export var stalk_respawn_delay: float = 1.5

## stalk scene to instantiate
@export var stalk_scene: PackedScene

## Spawn positions for stalks (local coords relative to container parent)
@export var stalk_spawn_positions: Array[Vector2] = [
	Vector2(-120, 40),
	Vector2(0, 60),
	Vector2(120, 40),
]

# =============================================================================
# STATE
# =============================================================================

enum Phase { STALKS_ACTIVE, ORB_FURY, CORE_EXPOSED, RETREATING, DEAD }

var _phase: int = Phase.STALKS_ACTIVE
var _current_hp: int = 0
var _cycle: int = 0

# stalk tracking
var _active_stalks: Array = []
var _stalks_destroyed: int = 0

# Core window
var _core_window_until: float = 0.0

# Orb fury
var _orb_fury_timer: float = 0.0
var _orb_fury_fired: bool = false
var _active_orbs: Array = []

# stalk recall
var _recalled_stalks: Array = []

# References
var _player: Node2D = null
var _container: Node2D = null

# Deathblow state (matches shield captain pattern)
var _dbroken_active: bool = false
var _dbreak_until: float = -1.0
var _deathblow_in_progress: bool = false

# UI
var _hp_bar_bg: ColorRect = null
var _hp_bar_fill: ColorRect = null
var _posture_bar_bg: ColorRect = null
var _posture_bar_fill: ColorRect = null
var _posture_flash_tween: Tween = null
var _core_pulse_tween: Tween = null

# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	_base_enemy_ready()
	
	add_to_group("miniboss")
	add_to_group("blood_lotus_heart")
	set_meta("boss_area", 3)
	
	_current_hp = total_hp
	hp = total_hp
	_max_hp = total_hp
	
	_container = self
	
	if combat and not combat.config:
		combat.config = CombatConfig.create_boss_config()
	
	if combat:
		combat.config.posture_max = core_posture_max
		combat.config.can_do_finisher = true
		
		if not combat.is_connected("posture_changed", Callable(self, "_on_posture_changed")):
			combat.connect("posture_changed", Callable(self, "_on_posture_changed"))
		
		if not combat.is_connected("posture_broken", Callable(self, "_on_posture_broken")):
			combat.connect("posture_broken", Callable(self, "_on_posture_broken"))
		
		combat.update_health_ratio(float(_current_hp), float(total_hp))
	
	_set_core_hurtbox_active(false)
	_setup_boss_ui()
	
	await get_tree().process_frame
	_player = get_tree().get_first_node_in_group("player")
	_spawn_stalk_cycle()

func _setup_boss_ui() -> void:
	# Boss HP bar (top of screen, similar to other bosses)
	var canvas = CanvasLayer.new()
	canvas.name = "BloodLotusHeartUI"
	canvas.layer = 10
	add_child(canvas)
	
	var viewport_size = get_viewport_rect().size
	var bar_width = 300.0
	var bar_height = 10.0
	var bar_x = (viewport_size.x - bar_width) * 0.5
	var bar_y = 30.0
	
	# HP bar
	_hp_bar_bg = ColorRect.new()
	_hp_bar_bg.size = Vector2(bar_width + 4, bar_height + 4)
	_hp_bar_bg.position = Vector2(bar_x - 2, bar_y - 2)
	_hp_bar_bg.color = Color(0.1, 0.1, 0.1, 0.8)
	canvas.add_child(_hp_bar_bg)
	
	_hp_bar_fill = ColorRect.new()
	_hp_bar_fill.size = Vector2(bar_width, bar_height)
	_hp_bar_fill.position = Vector2(bar_x, bar_y)
	_hp_bar_fill.color = Color(0.7, 0.15, 0.15, 0.9)
	canvas.add_child(_hp_bar_fill)
	
	# Core posture bar (below HP, hidden until core exposed)
	var posture_y = bar_y + bar_height + 8
	_posture_bar_bg = ColorRect.new()
	_posture_bar_bg.size = Vector2(bar_width + 4, 6)
	_posture_bar_bg.position = Vector2(bar_x - 2, posture_y - 1)
	_posture_bar_bg.color = Color(0.1, 0.1, 0.1, 0.8)
	_posture_bar_bg.visible = false
	canvas.add_child(_posture_bar_bg)
	
	_posture_bar_fill = ColorRect.new()
	_posture_bar_fill.size = Vector2(0, 4)
	_posture_bar_fill.position = Vector2(bar_x, posture_y)
	_posture_bar_fill.color = Color(1.0, 0.6, 0.1, 0.9)
	_posture_bar_fill.visible = false
	canvas.add_child(_posture_bar_fill)
	
	_update_hp_bar()


func _update_hp_bar() -> void:
	if _hp_bar_fill == null:
		return
	var ratio = float(_current_hp) / float(max(total_hp, 1))
	var max_width = 300.0
	_hp_bar_fill.size.x = max_width * ratio

func _update_posture_bar(_current: float, _max_value: float) -> void:
	if _posture_bar_fill == null:
		return
	if not combat:
		return
	
	var maxv = combat.config.posture_max if combat and combat.config else core_posture_max
	var ratio = combat.get_posture() / max(maxv, 1.0)
	var max_width = 300.0
	_posture_bar_fill.size.x = max_width * clamp(ratio, 0.0, 1.0)

# =============================================================================
# stalk MANAGEMENT
# =============================================================================

func _spawn_stalk_cycle() -> void:
	_phase = Phase.STALKS_ACTIVE
	_stalks_destroyed = 0
	_orb_fury_timer = 0.0
	_orb_fury_fired = false
	_active_stalks.clear()
	_cycle += 1
	
	if stalk_scene == null:
		return
	
	for i in range(stalks_per_cycle):
		var stalk = stalk_scene.instantiate()
		
		# Position relative to container
		var pos_index = i % stalk_spawn_positions.size()
		stalk.position = stalk_spawn_positions[pos_index]
		
		# Tag stalk with controller reference
		stalk.set_meta("blood_lotus_heart", self)
		stalk.set_meta("stalk_index", i)
		
		# Connect death signal
		if stalk.has_signal("enemy_died"):
			stalk.enemy_died.connect(_on_stalk_died)
		elif stalk.has_signal("defeated"):
			stalk.defeated.connect(_on_stalk_died)
		elif stalk.has_signal("destroyed"):
			stalk.destroyed.connect(_on_stalk_died)
		else:
			push_warning("[BloodLotusHeart] stalk has no supported death signal: %s" % stalk.name)
		
		_container.add_child(stalk)
		_active_stalks.append(stalk)
	
	print("[Blood Lotus Heart] Cycle %d — %d stalks spawned" % [_cycle, _active_stalks.size()])

func _on_stalk_died(stalk: Node) -> void:
	if _phase == Phase.DEAD:
		return
	
	_active_stalks.erase(stalk)
	_stalks_destroyed += 1
	
	print("[BloodLotusHeart] stalk destroyed (%d/%d)" % [_stalks_destroyed, stalks_per_cycle])
	
	if _active_stalks.is_empty() and _phase == Phase.STALKS_ACTIVE:
		_expose_core()
	elif _active_stalks.is_empty() and _phase == Phase.ORB_FURY:
		_clear_orbs()
		_expose_core()

func _recall_stalks() -> void:
	_recalled_stalks.clear()
	for stalk in _active_stalks:
		if is_instance_valid(stalk):
			_recalled_stalks.append(stalk)
			# Fade out FIRST — stalk stays vulnerable and visible during the fade
			if "sprite" in stalk and stalk.sprite != null:
				var tw = create_tween()
				tw.tween_property(stalk.sprite, "modulate:a", 0.2, 0.3)
				# Only set invulnerable AFTER fade completes
				var stalk_ref = stalk
				tw.tween_callback(func():
					if is_instance_valid(stalk_ref):
						stalk_ref.set_meta("recalled", true)
						if "hurt_box" in stalk_ref and stalk_ref.hurt_box != null:
							stalk_ref.hurt_box.set_deferred("monitorable", false)
				)
			else:
				# No sprite — set immediately
				stalk.set_meta("recalled", true)
				if "hurt_box" in stalk and stalk.hurt_box != null:
					stalk.hurt_box.set_deferred("monitorable", false)

func _re_emerge_stalks() -> void:
	var available_positions = stalk_spawn_positions.duplicate()
	available_positions.shuffle()
	
	var index = 0
	for stalk in _recalled_stalks:
		if is_instance_valid(stalk):
			# Move to new position first
			if index < available_positions.size():
				stalk.position = available_positions[index]
			index += 1
			
			# Re-enable hurtbox BEFORE clearing recalled — hittable immediately
			if "hurt_box" in stalk and stalk.hurt_box != null:
				stalk.hurt_box.set_deferred("monitorable", true)
			
			# Clear recalled flag so stalk resumes AI and takes damage
			stalk.remove_meta("recalled")
			
			# Fade sprite back in
			if "sprite" in stalk and stalk.sprite != null:
				var tw = create_tween()
				tw.tween_property(stalk.sprite, "modulate:a", 1.0, 0.3)
	
	_recalled_stalks.clear()

# =============================================================================
# CORE EXPOSURE
# =============================================================================
func _expose_core() -> void:
	_phase = Phase.CORE_EXPOSED
	_dbroken_active = false
	_deathblow_in_progress = false
	_core_window_until = Time.get_ticks_msec() * 0.001 + core_window_duration
	
	# Reset posture for fresh window
	if combat:
		combat.set_posture(0.0)
	
	# Enable hurt box
	_set_core_hurtbox_active(true)
	
	# Show posture bar
	if _posture_bar_bg:
		_posture_bar_bg.visible = true
	if _posture_bar_fill:
		_posture_bar_fill.visible = true
	_update_posture_bar(0.0, core_posture_max)
	
	# Visual pulse
	if has_node("Sprite2D"):
		if _core_pulse_tween and _core_pulse_tween.is_valid():
			_core_pulse_tween.kill()
		var spr = $Sprite2D
		_core_pulse_tween = create_tween()
		_core_pulse_tween.set_loops(0)
		_core_pulse_tween.tween_property(spr, "modulate", Color(1.0, 0.5, 0.5, 1.0), 0.3)
		_core_pulse_tween.tween_property(spr, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.3)
	
	print("[BloodLotusHeart] Core exposed! Posture window open for %.1fs" % core_window_duration)

func _close_core_window() -> void:
	_set_core_hurtbox_active(false)
	_dbroken_active = false
	_dbreak_until = -1.0
	
	if _posture_bar_bg:
		_posture_bar_bg.visible = false
	if _posture_bar_fill:
		_posture_bar_fill.visible = false
	
	if _core_pulse_tween and _core_pulse_tween.is_valid():
		_core_pulse_tween.kill()
		_core_pulse_tween = null
	if sprite:
		sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
	# Always check for death first
	if _current_hp <= 0:
		_die()
		return
	
	# Not dead — retreat and spawn new cycle
	_phase = Phase.RETREATING
	get_tree().create_timer(1.5).timeout.connect(_spawn_stalk_cycle)
	
func _get_player() -> Node:
	if _player and is_instance_valid(_player):
		return _player
	_player = get_tree().get_first_node_in_group("player")
	return _player
	
func _set_core_hurtbox_active(active: bool) -> void:
	if hurt_box == null:
		return
	hurt_box.set_deferred("monitoring", active)
	hurt_box.set_deferred("monitorable", active)
	for child in hurt_box.get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", not active)

func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	if _phase != Phase.CORE_EXPOSED:
		return
	if _dbroken_active:
		return
	if damage <= 0:
		return
	
	# Route posture through CombatController (no HP damage — only deathblow deals HP)
	if combat:
		var posture_event = {"damage": damage, "blocked": false}
		combat.notify_got_hit(posture_event)
	
	# Prosthetic bonus posture
	if attacker is Area2D and attacker.has_meta("posture_damage"):
		var extra = float(attacker.get_meta("posture_damage"))
		if combat:
			combat.add_posture(extra)
	
	# Damage number
	if DamageNumberManager:
		var posture_gain = 12.0
		if combat and combat.config:
			posture_gain = combat.config.hit_posture_gain
		DamageNumberManager.show_damage_number(
			int(posture_gain),
			global_position + Vector2(randf_range(-10, 10), randf_range(-30, -20)),
			"posture",
			self
		)
	
	# Hitstop feedback
	if attacker and is_instance_valid(attacker):
		var source = attacker
		if attacker is Area2D and attacker.has_meta("attacker"):
			source = attacker.get_meta("attacker")
		if is_instance_valid(source) and source.has_method("apply_hitstop"):
			source.apply_hitstop(0.04)
	
	# Apply prosthetic effects
	if attacker:
		ProstheticEffects.apply(attacker, self, false, 0.0)
	
	# Lifesteal check
	var source_player = attacker
	if attacker is Area2D and attacker.has_meta("attacker"):
		source_player = attacker.get_meta("attacker")
	if source_player and is_instance_valid(source_player) and source_player.is_in_group("player"):
		ProstheticEffects.check_lifesteal(source_player, damage)

func _trigger_posture_break(duration: float) -> void:
	var player = _get_player()
	if player:
		var pc = player.get_node_or_null("Combat")
		if pc and pc.has_method("set_deathblow_target"):
			pc.set_deathblow_target(self, duration)
		elif pc and pc.has_signal("deathblow_available"):
			pc.emit_signal("deathblow_available", self, duration)

func _on_posture_broken(duration: float) -> void:
	if _dbroken_active or _phase != Phase.CORE_EXPOSED:
		return
	
	var window = duration
	if window <= 0.0:
		window = 5.0
	
	_trigger_posture_break(window)
	
	var now = Time.get_ticks_msec() * 0.001
	_dbroken_active = true
	_dbreak_until = now + window
	_deathblow_in_progress = false
	
	# Flash posture bar
	if _posture_bar_fill:
		if _posture_flash_tween and _posture_flash_tween.is_valid():
			_posture_flash_tween.kill()
		_posture_flash_tween = create_tween()
		_posture_flash_tween.set_loops(0)
		_posture_flash_tween.tween_property(_posture_bar_fill, "color", Color(1.0, 1.0, 1.0, 1.0), 0.15)
		_posture_flash_tween.tween_property(_posture_bar_fill, "color", Color(1.0, 0.6, 0.1, 0.9), 0.15)
	
	print("[BloodLotusHeart] Core posture broken — deathblow available!")

func _on_posture_changed(current: float, max_value: float) -> void:
	_update_posture_bar(current, max_value)
	
func receive_deathblow(attacker: Node) -> void:
	take_deathblow(attacker)

func take_deathblow(attacker: Node) -> void:
	if _phase == Phase.DEAD:
		return
	if not _dbroken_active:
		return
	if _deathblow_in_progress:
		return
	_deathblow_in_progress = true
	
	# Reset posture
	if combat:
		combat.set_posture(0.0)
	_update_posture_bar(0.0, core_posture_max)
	
	# Stop posture flash
	if _posture_flash_tween:
		_posture_flash_tween.kill()
		_posture_flash_tween = null
	
	# Clear deathblow state
	_dbroken_active = false
	_dbreak_until = -1.0
	
	# Apply HP damage
	_current_hp -= deathblow_chunk
	_update_hp_bar()
	
	if DamageNumberManager:
		DamageNumberManager.show_damage_number(
			deathblow_chunk * 100,
			global_position + Vector2(0, -40),
			"deathblow",
			self
		)
	
	_deathblow_in_progress = false
	
	# Close core window after brief delay
	get_tree().create_timer(0.5).timeout.connect(_close_core_window)

func is_deathblow_ready() -> bool:
	return _dbroken_active

# =============================================================================
# ORB OF FURY
# =============================================================================

func _start_orb_fury() -> void:
	if _phase != Phase.STALKS_ACTIVE:
		return
	if _active_stalks.is_empty():
		return
	
	_phase = Phase.ORB_FURY
	_orb_fury_fired = true
	
	# Recall surviving stalks
	_recall_stalks()
	
	# Brief telegraph before firing orbs
	get_tree().create_timer(0.8).timeout.connect(_fire_orbs)


func _fire_orbs() -> void:
	if _phase != Phase.ORB_FURY:
		return
	if not _player or not is_instance_valid(_player):
		_end_orb_fury()
		return
	
	for i in range(orb_count):
		# Stagger orb spawns slightly
		get_tree().create_timer(0.3 * i).timeout.connect(func():
			if _phase != Phase.ORB_FURY:
				return
			_spawn_single_orb()
		)
	
	# End orb fury after all orbs have been fired + travel time
	var total_orb_time = 0.3 * orb_count + 2.5
	get_tree().create_timer(total_orb_time).timeout.connect(_end_orb_fury)


func _spawn_single_orb() -> void:
	if not _player or not is_instance_valid(_player):
		return
	
	var orb = Area2D.new()
	orb.collision_layer = 0
	orb.collision_mask = 2  # Detects player hurtbox
	orb.add_to_group("attack")
	orb.add_to_group("enemy_projectile")
	orb.monitoring = true
	
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = 8.0
	shape.shape = circle
	orb.add_child(shape)
	
	# Visual
	var visual = ColorRect.new()
	visual.size = Vector2(12, 12)
	visual.position = Vector2(-6, -6)
	visual.color = Color(0.9, 0.2, 0.2, 0.85)
	orb.add_child(visual)
	
	orb.global_position = global_position + Vector2(randf_range(-20, 20), 0)
	
	orb.set_meta("damage", orb_damage)
	orb.set_meta("damage_type", "unblockable")
	orb.set_meta("attacker", self)
	orb.set_meta("swing_token", Time.get_ticks_msec())
	orb.set_meta("orb_speed", orb_speed)
	orb.set_meta("orb_tracking", orb_tracking)
	orb.set_meta("orb_lifetime", 4.0)
	orb.set_meta("orb_spawn_time", Time.get_ticks_msec() * 0.001)
	orb.set_meta("hit", false)
	
	get_tree().current_scene.add_child(orb)
	_active_orbs.append(orb)
	
	# Same hit pattern as enemy.gd: attack detects player hurtbox, emits hurt on it
	var orb_ref = orb
	var watcher_ref = self
	var dmg = orb_damage
	orb.area_entered.connect(func(area: Area2D) -> void:
		if not is_instance_valid(orb_ref):
			return
		if orb_ref.get_meta("hit"):
			return
		if area == null or not area.is_in_group("player_hurtbox"):
			return
		orb_ref.set_meta("hit", true)
		area.emit_signal("hurt", dmg, "unblockable", watcher_ref)
		orb_ref.queue_free()
	)

func _end_orb_fury() -> void:
	if _phase != Phase.ORB_FURY:
		return
	
	_clear_orbs()
	
	# Check if any stalks survived
	var surviving = []
	for stalk in _active_stalks:
		if is_instance_valid(stalk):
			surviving.append(stalk)
	_active_stalks = surviving
	
	if _active_stalks.is_empty():
		# All stalks died during fury — expose core
		_expose_core()
	else:
		# Re-emerge surviving stalks at new positions
		_phase = Phase.STALKS_ACTIVE
		get_tree().create_timer(stalk_respawn_delay).timeout.connect(_re_emerge_stalks)


func _clear_orbs() -> void:
	for orb in _active_orbs:
		if is_instance_valid(orb):
			orb.queue_free()
	_active_orbs.clear()


# =============================================================================
# TICK
# =============================================================================
func _physics_process(delta: float) -> void:
	if _phase == Phase.DEAD:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	
	var now = Time.get_ticks_msec() * 0.001
	
	match _phase:
		Phase.STALKS_ACTIVE:
			if not _orb_fury_fired and not _active_stalks.is_empty():
				_orb_fury_timer += delta
				if _orb_fury_timer >= orb_fury_delay:
					_start_orb_fury()
		
		Phase.CORE_EXPOSED:
			if combat and not _dbroken_active:
				combat.update_health_ratio(float(_current_hp), float(total_hp))
				combat.tick(delta)
			
			if _dbroken_active and not _deathblow_in_progress:
				if now >= _dbreak_until:
					_dbroken_active = false
					_dbreak_until = -1.0
					_close_core_window()
			elif not _dbroken_active and not _deathblow_in_progress and now >= _core_window_until:
				_close_core_window()
		
		Phase.ORB_FURY:
			_tick_orbs(delta)
		
		Phase.RETREATING:
			pass
	
	if not _active_orbs.is_empty():
		_tick_orbs(delta)
	
	velocity = Vector2.ZERO
	move_and_slide()

func _tick_orbs(delta: float) -> void:
	if not _player or not is_instance_valid(_player):
		return
	
	var now = Time.get_ticks_msec() * 0.001
	var to_remove = []
	
	for orb in _active_orbs:
		if not is_instance_valid(orb):
			to_remove.append(orb)
			continue
		
		if orb.get_meta("hit"):
			to_remove.append(orb)
			continue
		
		# Lifetime check
		var spawn_time = float(orb.get_meta("orb_spawn_time"))
		var lifetime = float(orb.get_meta("orb_lifetime"))
		if now - spawn_time >= lifetime:
			orb.queue_free()
			to_remove.append(orb)
			continue
		
		# Tracking movement toward player
		var to_player = (_player.global_position - orb.global_position)
		var dist = to_player.length()
		if dist < 5.0:
			continue
		
		var desired_dir = to_player.normalized()
		var current_dir = orb.get_meta("orb_dir", desired_dir)
		var tracking = float(orb.get_meta("orb_tracking"))
		var blended_dir = (current_dir * (1.0 - tracking) + desired_dir * tracking).normalized()
		orb.set_meta("orb_dir", blended_dir)
		
		var spd = float(orb.get_meta("orb_speed"))
		orb.global_position += blended_dir * spd * delta
	
	for orb in to_remove:
		_active_orbs.erase(orb)


# =============================================================================
# DEATH
# =============================================================================
func death() -> void:
	_die()


func _die() -> void:
	if _phase == Phase.DEAD:
		return
	
	if not mark_dead():
		return
	
	_phase = Phase.DEAD
	
	if _player and is_instance_valid(_player):
		if "enemy_close" in _player:
			_player.enemy_close.erase(self)
		if "_db_target" in _player and _player._db_target == self:
			_player._db_target = null
			_player._db_until = -1.0
	
	for stalk in _active_stalks:
		if is_instance_valid(stalk):
			stalk.queue_free()
	_active_stalks.clear()
	_recalled_stalks.clear()
	
	_clear_orbs()
	
	if _core_pulse_tween and _core_pulse_tween.is_valid():
		_core_pulse_tween.kill()
		_core_pulse_tween = null
	
	if _posture_flash_tween and _posture_flash_tween.is_valid():
		_posture_flash_tween.kill()
		_posture_flash_tween = null
	
	if _hp_bar_bg:
		_hp_bar_bg.visible = false
	if _hp_bar_fill:
		_hp_bar_fill.visible = false
	if _posture_bar_bg:
		_posture_bar_bg.visible = false
	if _posture_bar_fill:
		_posture_bar_fill.visible = false
	
	if is_in_group("miniboss"):
		remove_from_group("miniboss")
	if is_in_group("blood_lotus_heart"):
		remove_from_group("blood_lotus_heart")
	
	emit_signal("defeated")
	emit_signal("enemy_died", self)
	
	award_area_gold_drop()
	notify_stance_effects_enemy_death()
	
	if sprite:
		var tw = create_tween()
		tw.tween_property(sprite, "modulate:a", 0.0, 1.0)
		tw.tween_callback(func():
			if is_instance_valid(self):
				queue_free()
		)
	else:
		queue_free()
	
	print("[BloodLotusHeart] Defeated after %d cycles!" % _cycle)
