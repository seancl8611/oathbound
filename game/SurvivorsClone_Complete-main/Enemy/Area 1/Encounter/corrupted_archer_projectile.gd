extends Area2D

## =============================================================================
## ARCHER PROJECTILE - v2.5 TIMING BUG FIX
## =============================================================================
## BUG FOUND: Arrow waits 2 frames before enabling monitoring, but it's already
## moving during that time. If it reaches the player before monitoring enables,
## area_entered never fires (signal only fires on ENTRY, not pre-existing overlap).
##
## FIX: Check for overlaps after arming AND every frame in _physics_process.
## =============================================================================

@export var speed: float = 140.0
@export var damage: int = 2
@export var lifetime: float = 3.0

var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var _is_deflected = false
var _is_blocked = false
var _deflect_damage_multiplier = 1.5

@onready var sprite = $Sprite2D

var _spawn_time = 0.0
var _lifetime_exceeded = false
var _hit_something = false
var _armed = false  # Track if we're armed and checking collisions

func _ready() -> void:
	set_meta("attack_type", "arrow")
	set_meta("parryable", true)
	set_meta("projectile", true)
	set_meta("reflected", false)
	set_meta("deflected", false)

	# FIX: preserve the sprite's authored rotation offset (from the scene)
	if sprite:
		set_meta("sprite_base_rotation", sprite.rotation)

	_spawn_time = Time.get_ticks_msec() * 0.001

	monitorable = false
	monitoring = false
	call_deferred("_arm_projectile")

	if direction == Vector2.ZERO:
		direction = Vector2.RIGHT.rotated(rotation)

	velocity = direction * speed

	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	# Lifetime check
	var now = Time.get_ticks_msec() * 0.001
	if now - _spawn_time > lifetime:
		if not _lifetime_exceeded:
			_lifetime_exceeded = true
			queue_free()
		return
	
	# Don't process if already hit something or blocked
	if _is_blocked or _hit_something:
		return
	
	# Move arrow
	position += velocity * delta
	
	# Update rotation to match trajectory (no extra sprite spin)
	if velocity.length() > 0.0:
		rotation = velocity.angle()
	
	# CRITICAL FIX: Check for overlaps every frame after armed
	if _armed and not _hit_something:
		_check_overlaps()
		
func _check_overlaps() -> void:
	if _hit_something:
		return
	
	var areas = get_overlapping_areas()
	for area in areas:
		if _is_deflected:
			# Deflected mode - check for enemy hurtboxes
			if area.is_in_group("hurtbox") and not area.is_in_group("player_hurtbox"):
				var enemy = area.get_parent()
				if enemy and enemy.is_in_group("enemy"):
					_hit_enemy(area, enemy)
					return
		else:
			# Normal mode - check for player hurtbox
			if area.is_in_group("player_hurtbox"):
				_hit_something = true
				_handle_player_collision(area)
				return


func _on_body_entered(body: Node) -> void:
	if _hit_something:
		return
	
	if not _is_deflected:
		return
	
	if body.is_in_group("enemy"):
		_hit_something = true
		var deflect_dmg = int(damage * _deflect_damage_multiplier)
		
		if body.has_node("HurtBox"):
			var hb = body.get_node("HurtBox")
			if hb.has_signal("hurt"):
				var player = get_tree().get_first_node_in_group("player")
				if player:
					set_meta("attacker", player)
				hb.emit_signal("hurt", deflect_dmg, "arrow_deflect", self)
		
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if not is_instance_valid(area):
		return
	
	if _hit_something:
		return
	
	var shooter_id = get_meta("shooter_id", 0)
	
	# Deflected mode - hit enemies
	if _is_deflected:
		if area.is_in_group("player_hurtbox"):
			return
		
		if area.is_in_group("hurtbox"):
			var enemy = area.get_parent()
			if enemy and enemy.is_in_group("enemy"):
				_hit_enemy(area, enemy)
		return
	
	# Normal mode - ignore shooter and other enemies
	var owner_node = area.get_parent()
	if owner_node and owner_node.get_instance_id() == shooter_id:
		return
	
	if area.is_in_group("hurtbox"):
		return
	
	# Hit player
	if area.is_in_group("player_hurtbox"):
		_hit_something = true
		_handle_player_collision(area)


## Handle hitting an enemy (when deflected)
func _hit_enemy(area: Area2D, enemy: Node) -> void:
	_hit_something = true
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		set_meta("attacker", player)
	
	var deflect_dmg = int(damage * _deflect_damage_multiplier)
	
	if area.has_signal("hurt"):
		area.emit_signal("hurt", deflect_dmg, "arrow_deflect", self)
	
	queue_free()


## Main handler for player collision
func _handle_player_collision(hurtbox: Area2D) -> void:
	var player = _get_player(hurtbox)
	
	if not player:
		queue_free()
		return
	
	set_meta("damage", damage)
	set_meta("attack_type", "arrow")
	
	# Check player state DIRECTLY
	var player_is_parrying = _check_player_parrying(player)
	var player_is_blocking = _check_player_blocking(player)
	
	if player_is_parrying:
		# PARRY - Emit signal for effects, then deflect
		if hurtbox.has_signal("hurt"):
			hurtbox.emit_signal("hurt", damage, "arrow", self)
		_deflect_arrow(player)
		return
	
	if player_is_blocking:
		# BLOCK - Emit signal for effects, then despawn
		if hurtbox.has_signal("hurt"):
			hurtbox.emit_signal("hurt", damage, "arrow", self)
		_do_blocked_despawn()
		return
	
	# NORMAL HIT - Emit signal, then despawn
	if hurtbox.has_signal("hurt"):
		hurtbox.emit_signal("hurt", damage, "arrow", self)
	
	queue_free()


func _get_player(hurtbox: Area2D) -> Node:
	var player = hurtbox.get_parent()
	if player and player.is_in_group("player"):
		return player
	return get_tree().get_first_node_in_group("player")

func _check_player_parrying(player: Node) -> bool:
	if player == null:
		return false
	
	if player.has_method("is_parrying"):
		if player.is_parrying():
			return true
	
	var parry_active = player.get("_parry_active")
	if parry_active != null and bool(parry_active):
		return true
	
	var state_value = player.get("_state")
	if state_value != null and int(state_value) == 6:
		return true
	
	var grace_until = player.get("_parry_grace_until")
	if grace_until != null:
		var now = Time.get_ticks_msec() * 0.001
		if now < float(grace_until):
			return true
	
	return false

func _check_player_blocking(player: Node) -> bool:
	if player == null:
		return false
	
	if player.has_method("is_blocking"):
		if player.is_blocking():
			return true
	
	var state_value = player.get("_state")
	if state_value != null and int(state_value) == 5:
		return true
	
	return false

func _do_blocked_despawn() -> void:
	_is_blocked = true
	velocity = Vector2.ZERO
	
	if sprite:
		var tw = create_tween()
		tw.tween_property(sprite, "modulate:a", 0.0, 0.08)
		tw.tween_callback(queue_free)
	else:
		queue_free()

func _deflect_arrow(deflector: Node) -> void:
	if _is_deflected:
		return

	_is_deflected = true
	_hit_something = false

	set_meta("reflected", true)
	set_meta("deflected", true)

	collision_layer = 4
	collision_mask = 4
	set_collision_mask_value(1, true)

	var shooter = get_meta("shooter", null)
	if is_instance_valid(shooter) and shooter is Node2D:
		direction = (shooter.global_position - global_position).normalized()
		velocity = direction * speed * 1.2
		rotation = direction.angle()

		# FIX: Don't call on_parried() here - that causes double posture damage
		# The deflected arrow will deal posture/HP damage when it actually hits the archer
		# (Removed: shooter.on_parried() call)
	else:
		direction = -direction
		velocity = direction * speed
		rotation = direction.angle()

	lifetime = max(lifetime, 2.5)
	_spawn_time = Time.get_ticks_msec() * 0.001

	if sprite:
		sprite.modulate = Color(1.2, 1.2, 1.5)

		# FIX: restore authored sprite rotation offset (don't zero it)
		sprite.rotation = float(get_meta("sprite_base_rotation", sprite.rotation))

	_spawn_deflect_trail()
	
func _spawn_deflect_trail() -> void:
	for i in range(3):
		var trail = ColorRect.new()
		trail.size = Vector2(3, 3)
		trail.color = Color(0.7, 0.9, 1.0, 0.6)
		trail.z_index = -1
		add_child(trail)
		trail.position = Vector2(-5 * i, 0)
		
		var tw = create_tween()
		tw.tween_property(trail, "modulate:a", 0.0, 0.3)
		tw.tween_callback(trail.queue_free)


func deflect(deflector: Node) -> void:
	if not _is_deflected and not _is_blocked:
		_deflect_arrow(deflector)


func on_blocked() -> void:
	if not _is_deflected and not _is_blocked:
		_do_blocked_despawn()


func launch(dir: Vector2, spd: float, dmg: int = 2) -> void:
	direction = dir.normalized()
	speed = spd
	damage = dmg
	velocity = direction * speed
	rotation = direction.angle()


func initialize(dir: Vector2, spd: float, dmg: int = 2) -> void:
	launch(dir, spd, dmg)


func _arm_projectile() -> void:
	await get_tree().process_frame
	await get_tree().process_frame
	
	add_to_group("attack")
	add_to_group("enemy_projectile")
	add_to_group("deflectable")
	add_to_group("enemy_attack")
	monitorable = true
	monitoring = true
	_armed = true
	
	# CRITICAL: Check for overlaps immediately after arming
	# This catches arrows that are already inside the player
	await get_tree().physics_frame
	_check_overlaps()
