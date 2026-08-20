extends CharacterBody2D

var is_attacking = false
@export var indicator_light_red = preload("res://Textures/Enemy/indicator_trainer1.png")
@export var indicator_medium_red = preload("res://Textures/Enemy/indicator_trainer2.png")
@export var indicator_dark_red = preload("res://Textures/Enemy/indicator_trainer3.png")

# Sword-only variables
@onready var sword_hitbox = get_node("%SwordHitBox")
@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var enemy_detection_area = $EnemyDetectionArea2
@onready var hurtbox = $HurtBox
var last_attack_aim_vector = Vector2.RIGHT

var dash_timer := 0.0
var dash_speed = 400.0
var dash_duration = 0.2
var is_dashing = false
var dash_direction = Vector2.ZERO
var dash_time_remaining = 0.0
var can_dash = true

var target_player: Node = null

var attack_range = 75
var chase_range = 200

@onready var duel_popup = $DuelPopup
var duel_requested = false
var duel_started = false
var player_in_range := false
@onready var interaction_zone = $InteractionZone 
@onready var attack_indicator = $attack_indicator
enum TrainerPhase { PHASE_1, PHASE_2, PHASE_3 }

var current_phase: TrainerPhase = TrainerPhase.PHASE_1
var phase_attack_index: int = 0
var phase_attack_timer: float = 0.0
var is_executing_attack: bool = false
var current_attack_index = 0

var honor_gauge := 0.0
var honor_max := 1.0
var honor_gain_per_attack := 0.2
var honor_loss_on_hit := 0.15
var finisher_ready := false
@onready var honor_bar: ProgressBar = $CanvasLayer/HonorBar  # Adjust path as needed
@onready var finisher_prompt: Label = null

func _ready():
	hurtbox.connect("trainer_hit", Callable(self, "_on_HurtBox_area_entered"))
	interaction_zone.connect("area_entered", _on_interaction_area_entered)
	interaction_zone.connect("area_exited", _on_interaction_area_exited)
	duel_popup.connect("confirmed", _on_DuelPopup_confirmed)
	duel_popup.connect("canceled", _on_DuelPopup_canceled)
	phase_attack_timer = 0.1
	randomize()
	set_indicator_visibility(false)
	honor_bar.visible = false

	# --- E prompt (code-only) ---
	if not finisher_prompt:
		finisher_prompt = Label.new()
		finisher_prompt.text = "E"
		finisher_prompt.z_index = 50
		finisher_prompt.modulate.a = 0.95
		finisher_prompt.add_theme_color_override("font_outline_color", Color.BLACK)
		finisher_prompt.add_theme_constant_override("outline_size", 2)
		finisher_prompt.visible = false

		# Parent to THIS node (world space) to avoid any world↔screen math.
		add_child(finisher_prompt)

func _physics_process(delta):
	update_player_target()
	process_state(delta)
	move_and_slide()
	process_phase(delta)

	# --- Finisher input (centralized here) ---
	if duel_started and finisher_ready and target_player and Input.is_action_just_pressed("execute_finisher"):
		if can_accept_finisher():
			start_finisher(target_player)

	# Interaction trigger
	if player_in_range and not duel_started and not duel_popup.visible:
		if Input.is_action_just_pressed("interact"):
			print("[DEBUG] Interact key pressed while in range.")
			duel_popup.visible = true
			duel_popup.popup_centered()
			get_tree().paused = true
	
	_update_finisher_prompt()

func attack_player(aim_vector: Vector2):
	is_attacking = true
	sprite.flip_h = aim_vector.x < 0

	# Snap to 8-direction angle for the hitbox
	var snapped_angle = round(rad_to_deg(aim_vector.angle()) / 45.0) * 45.0
	sword_hitbox.rotation_degrees = snapped_angle

	var offset_distance = 12
	var radians = deg_to_rad(snapped_angle)
	var offset = Vector2(cos(radians), sin(radians)) * offset_distance
	sword_hitbox.position = offset

	if sword_hitbox:
		setup_sword_hitbox()
		sword_hitbox.activate_hitbox()

	animation.play("attack")
	print("[COMBAT TRAINER] Attacking towards player.")

func handle_dash(delta):
	if is_dashing:
		dash_time_remaining -= delta
		self.velocity = dash_direction * dash_speed
		if dash_time_remaining <= 0:
			end_dash()

func start_dash(direction: Vector2):
	dash_direction = direction.normalized()
	dash_time_remaining = dash_duration
	is_dashing = true
	self.velocity = dash_direction * dash_speed
	animation.play("dash")
	print("[DASH] Trainer started dash in direction:", dash_direction)
	
func end_dash():
	is_dashing = false
	self.velocity = Vector2.ZERO  # Optional: stop sliding after dash

func update_player_target():
	for body in enemy_detection_area.get_overlapping_bodies():
		if body.is_in_group("player"):
			target_player = body
			return
	target_player = null

func attack_with_sword(aim_vector: Vector2):
	if is_attacking:
		return

	if aim_vector == Vector2.ZERO:
		aim_vector = Vector2.RIGHT

	last_attack_aim_vector = aim_vector
	sprite.flip_h = aim_vector.x < 0

	# Snap to 8-direction angle
	var snapped_angle = round(rad_to_deg(aim_vector.angle()) / 45.0) * 45.0
	sword_hitbox.rotation_degrees = snapped_angle

	# Offset hitbox
	var offset_distance = 12
	var radians = deg_to_rad(snapped_angle)
	var offset = Vector2(cos(radians), sin(radians)) * offset_distance
	sword_hitbox.position = offset

	is_attacking = true
	self.velocity = Vector2.ZERO
	animation.play("attack")

	# Wait for attack animation to finish
	await animation.animation_finished

	is_attacking = false

	# Transition to correct movement animation after attacking
	if self.velocity.length() > 0:
		animation.play("walk")
	else:
		animation.play("idle")

func process_state(delta):
	if not duel_started:
		self.velocity = Vector2.ZERO
		animation.play("idle")
		return
	
	if in_stagger or in_finisher:
		self.velocity = Vector2.ZERO
		# keep whatever anim the stagger/finisher set
		return

	handle_dash(delta)

	if not target_player:
		self.velocity = Vector2.ZERO
		animation.play("idle")
		return

	var to_player = target_player.global_position - global_position
	var distance = to_player.length()

	# === FIXED MOVEMENT LOGIC ===
	if is_dashing:
		# Let handle_dash set velocity
		return

	elif not is_attacking and not is_executing_attack:
		var direction = to_player.normalized()
		self.velocity = direction * 60  # Normal movement

		sprite.flip_h = direction.x < 0
		if animation.current_animation != "walk":
			animation.play("walk")
	elif not is_dashing:
		self.velocity = Vector2.ZERO

func _on_AnimationPlayer_animation_finished(name):
	if name == "attack":
		is_attacking = false  # ✅ Ensure the attack state is reset
		sword_hitbox.collision_shape.disabled = true  # Disable hitbox

		# Deactivate the sword hitbox
		if sword_hitbox:
			sword_hitbox.deactivate_hitbox()
		
		# ✅ Reset to idle or walk animation, but allow movement
		if self.velocity.length() > 0:
			animation.play("walk")
		else:
			animation.play("idle")
		print("[DEBUG] Attack animation finished. Reset to:", "walk" if self.velocity.length() > 0 else "idle")

func _on_DuelPopup_confirmed():
	duel_started = true

	if target_player and target_player.has_method("set_gui_visible"):
		target_player.set_gui_visible(true)

	if target_player and target_player.has_signal("took_damage"):
		print("[DEBUG] Connecting to took_damage on:", target_player)

		if not target_player.is_connected("took_damage", Callable(self, "_on_player_took_damage")):
			var result = target_player.connect("took_damage", Callable(self, "_on_player_took_damage"))
			print("[DEBUG] ✅ Signal connection attempt result:", result)
		else:
			print("[DEBUG] ⚠️ took_damage signal already connected to _on_player_took_damage.")

	else:
		print("[ERROR] target_player is missing took_damage signal!")

	duel_requested = true
	get_tree().paused = false
	duel_popup.visible = false
	honor_bar.visible = true
	update_honor_bar()

func _on_DuelPopup_canceled():
	get_tree().paused = false

func _on_interaction_area_entered(area):
	print("[DEBUG] Area entered:", area.name, "Parent:", area.get_parent().name)
	if area.get_parent() and area.get_parent().is_in_group("player"):
		player_in_range = true
		print("[DEBUG] Player entered interaction zone")

func _on_interaction_area_exited(area):
	if area.get_parent() and area.get_parent().is_in_group("player"):
		player_in_range = false
		print("[DEBUG] Player exited interaction zone")

func process_phase(delta):
	if not duel_started or is_dashing:
		return
	
	if in_stagger or in_finisher:
		return
		
	if is_executing_attack:
		return  # Wait for attack to finish

	phase_attack_timer -= delta
	if phase_attack_timer > 0:
		return
		
	print("[DEBUG] process_phase running. is_executing_attack =", is_executing_attack)

	match current_phase:
		TrainerPhase.PHASE_1:
			print("[PHASE] Phase 1 active")
			# Intro phase: spacing + wind pressure, occasional dash approach.
			var pattern = [
				"wind_slashes",
				"slash",
				"backstep",
				"wind_slashes",
				"dash_slash",
				"pause_and_stare",
				"wind_slashes",
				"slash"
			]
			execute_phase_attack(pattern)

		TrainerPhase.PHASE_2:
			print("[PHASE] Phase 2 active")
			# Mid phase: slam patterns come online with wind coverage; still some footsies.
			var pattern = [
				"slam_combo",
				"wind_slashes",
				"backstep",
				"slam_combo",
				"dash_slash",
				"wind_slashes",
				"slam_combo",
				"pause_and_stare"
			]
			execute_phase_attack(pattern)

		TrainerPhase.PHASE_3:
			print("[PHASE] Phase 3 active")
			# Final phase: more aggression and shorter downtime.
			var pattern = [
				"dash_slash",
				"slam_combo",
				"wind_slashes",
				"dash_slash",
				"backstep",
				"slam_combo",
				"wind_slashes",
				"dash_slash"
			]
			execute_phase_attack(pattern)

func execute_phase_attack(pattern: Array):
	if phase_attack_index >= pattern.size():
		# Do NOT auto-advance phases here anymore.
		phase_attack_index = 0  # loop within current phase only

	var action = pattern[phase_attack_index]
	print("[PHASE ACTION] Selected:", action)
	phase_attack_index += 1
	is_executing_attack = true
	perform_phase_action_from_string(action)

	# Reset timer
	phase_attack_timer = 1.5

func perform_aoe_slash(direction: Vector2 = Vector2.ZERO, is_spin_slash: bool = false):
	if cancel_attacks or in_stagger or in_finisher:
		is_executing_attack = false
		return
	if not target_player:
		is_attacking = false
		is_executing_attack = false
		return

	is_attacking = true
	sprite.flip_h = direction.x < 0 if direction != Vector2.ZERO else false
	self.velocity = Vector2.ZERO

	if is_spin_slash:
		print("[TRAINER] Charging Spin Slash...")
		animation.play("idle")
		await get_tree().create_timer(0.4).timeout  # charge up

		print("[TRAINER] Performing Circular Spin Slash!")
		var hitbox_steps = 8  # 8 directions (every 45 degrees)
		var offset_distance = 16  # radius of slash
		var delay_between_slashes = 0.05  # delay between each slash

		for i in range(hitbox_steps):
			var angle_deg = i * 360 / hitbox_steps
			var radians = deg_to_rad(angle_deg)
			var offset = Vector2(cos(radians), sin(radians)) * offset_distance

			sword_hitbox.rotation_degrees = angle_deg
			sword_hitbox.position = offset

			if sword_hitbox:
				setup_sword_hitbox()
				sword_hitbox.activate_hitbox()
				await get_tree().create_timer(delay_between_slashes).timeout
				sword_hitbox.deactivate_hitbox()

		animation.play("attack")
		await animation.animation_finished

	else:
		# Default AoE slash (directional)
		if direction == Vector2.ZERO:
			direction = (target_player.global_position - global_position).normalized()

		sprite.flip_h = direction.x < 0
		var snapped_angle = round(rad_to_deg(direction.angle()) / 45.0) * 45.0
		sword_hitbox.rotation_degrees = snapped_angle

		var offset_distance = 12
		var radians = deg_to_rad(snapped_angle)
		var offset = Vector2(cos(radians), sin(radians)) * offset_distance
		sword_hitbox.position = offset

		if sword_hitbox:
			setup_sword_hitbox()
			sword_hitbox.activate_hitbox()

		animation.play("attack")
		print("[TRAINER] Executing AoE Slash!")

		await animation.animation_finished
		if sword_hitbox:
			sword_hitbox.deactivate_hitbox()

	is_attacking = false
	is_executing_attack = false

func perform_dash_slash():
	if cancel_attacks or in_stagger or in_finisher:
		is_executing_attack = false
		return

	print("[TRAINER] Dash + AoE Slash initiated!")
	is_executing_attack = true

	# Phase 1: Brief pause before committing to dash
	self.velocity = Vector2.ZERO
	animation.play("idle")
	await get_tree().create_timer(0.3).timeout

	# Phase 2: Dash toward player (recalculate after pause)
	if not target_player:
		print("[TRAINER] No player found. Canceling attack.")
		is_executing_attack = false
		return

	var to_player = (target_player.global_position - global_position)
	if to_player.length() < 5:
		to_player = last_attack_aim_vector
	else:
		to_player = to_player.normalized()
		last_attack_aim_vector = to_player  # Update known good vector

	start_dash(to_player)
	print("[DEBUG] Dash direction to player (adjusted):", to_player)
	await get_tree().create_timer(dash_duration).timeout
	end_dash()

	# Phase 3: Random chance to attack after dash
	var distance = global_position.distance_to(target_player.global_position)
	if distance <= attack_range + 20:
		var should_slash := randi_range(0, 99) < 60  # 60% chance
		if should_slash:
			print("[TRAINER] In range after dash. Executing AoE Slash!")
			await perform_aoe_slash(Vector2.ZERO, true)
		else:
			print("[TRAINER] In range, but choosing to feint — no slash.")
	else:
		print("[TRAINER] Out of range. Slash canceled.")

	await get_tree().create_timer(0.5).timeout
	is_executing_attack = false

func perform_backstep():
	if cancel_attacks or in_stagger or in_finisher:
		is_executing_attack = false
		return
	if not target_player:
		is_executing_attack = false
		return

	var away_vector = (global_position - target_player.global_position).normalized()
	start_dash(away_vector)
	await get_tree().create_timer(dash_duration).timeout
	end_dash()
	print("[TRAINER] Performed backstep.")

	# 60% chance to follow up with teleport lunge
	if randi_range(0, 99) < 60:
		await perform_teleport_lunge()
	else:
		is_executing_attack = false

func perform_pause_and_stare():
	print("[TRAINER] Dramatic pause...")
	animation.play("idle")
	await get_tree().create_timer(1.2).timeout
	is_executing_attack = false

func perform_phase_action_from_string(action: String):
	print("[DEBUG] Performing phase action:", action)

	match action:
		"slash":
			await perform_aoe_slash(Vector2.ZERO, true)
		"dash_slash":
			await perform_dash_slash()
		"backstep":
			await perform_backstep()
		"pause_and_stare":
			await perform_pause_and_stare()
		"wind_slashes":
			await perform_wind_slash_combo()
		"slam_combo":
			await perform_slam_zone_attack()

	await get_tree().create_timer(0.5).timeout
	is_executing_attack = false

func advance_phase():
	match current_phase:
		TrainerPhase.PHASE_1:
			current_phase = TrainerPhase.PHASE_2
		TrainerPhase.PHASE_2:
			current_phase = TrainerPhase.PHASE_3
		TrainerPhase.PHASE_3:
			pass  # Remain at final phase or loop/reset if desired
	phase_attack_index = 0
	print("[PHASE] Transitioned to:", current_phase)

func perform_teleport_lunge():
	if cancel_attacks or in_stagger or in_finisher:
		is_executing_attack = false
		return
	print("[TRAINER] Preparing teleport lunge...")
	
	# Phase 1: Pause briefly and vanish
	animation.play("idle")
	await get_tree().create_timer(0.4).timeout

	visible = false
	collision_layer = 0
	collision_mask = 0
	print("[TRAINER] Vanished from battlefield.")

	await get_tree().create_timer(4.0).timeout

	if not target_player:
		print("[TRAINER] No player found. Canceling lunge.")
		is_executing_attack = false
		return

	# Phase 2: Reappear at fixed radius around player
	var radius = 150
	var angle = randf() * TAU
	var offset = Vector2(cos(angle), sin(angle)) * radius
	global_position = target_player.global_position + offset

	visible = true
	# ❌ Remove this:
	# set_physics_process(true)
	collision_layer = 1
	collision_mask = 1
	animation.play("idle")
	print("[TRAINER] Reappeared for lunge setup.")
	await get_tree().create_timer(0.6).timeout

	var lunge_dir = (target_player.global_position - global_position).normalized()
	start_dash(lunge_dir)

	animation.play("attack")

	if sword_hitbox:
		setup_sword_hitbox()
		sword_hitbox.rotation_degrees = rad_to_deg(lunge_dir.angle())
		sword_hitbox.position = lunge_dir * 12
		sword_hitbox.activate_hitbox()

	await get_tree().create_timer(dash_duration).timeout

	end_dash()

	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()

	print("[TRAINER] Finished teleport lunge.")
	is_executing_attack = false

func perform_wind_slash_combo():
	if cancel_attacks or in_stagger or in_finisher:
		is_executing_attack = false
		return

	is_executing_attack = true
	self.velocity = Vector2.ZERO
	animation.play("idle")
	await get_tree().create_timer(0.5).timeout  # brief charge
	if cancel_attacks or in_stagger or in_finisher:
		is_executing_attack = false
		return

	for i in range(4):
		if cancel_attacks or in_stagger or in_finisher:
			is_executing_attack = false
			return

		if not target_player:
			break

		# Recalculate direction toward player for each slash
		var to_player = (target_player.global_position - global_position).normalized()

		# Move slightly forward based on current player location
		var step_vector = to_player * 20
		global_position += step_vector

		match i:
			0:
				emit_wind_projectile(to_player, "thin_fast")
			1:
				emit_wind_projectile(to_player, "wide_hole_pattern_1")
			2:
				emit_wind_projectile(to_player, "wide_hole_pattern_2")
			3:
				emit_wind_projectile(to_player, "thin_fast")

		animation.play("attack")
		await animation.animation_finished
		if cancel_attacks or in_stagger or in_finisher:
			is_executing_attack = false
			return
		await get_tree().create_timer(0.2).timeout

	is_executing_attack = false

func emit_wind_projectile(direction: Vector2, type: String):
	var wind = Area2D.new()
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()

	match type:
		"thin_fast":
			shape.size = Vector2(24, 6)
		"wide_hole_pattern_1", "wide_hole_pattern_2":
			shape.size = Vector2(120, 40)  # Wider and taller for big horizontal slash

	collision.shape = shape
	collision.set_deferred("disabled", false)
	wind.add_child(collision)
	get_tree().current_scene.add_child(wind)
	_track_spawned(wind)

	# ✅ Set metadata and groups BEFORE attaching handler
	wind.set_meta("damage", 4)
	wind.set_meta("damage_type", "wind")
	wind.set_meta("weapon_owner", self)
	wind.add_to_group("attack")
	wind.set_collision_layer(2)
	wind.set_collision_mask(0)

	await get_tree().process_frame  # ensure registration in scene tree

	attach_damage_handler_to(wind)

	print("[DEBUG] Wind projectile setup complete. Type:", type, "GlobalPos:", wind.global_position)
	print("[DEBUG] Wind projectile spawned:", wind.name, "at", wind.global_position)

	# Position and rotation setup
	wind.global_position = global_position
	wind.rotation = direction.angle()

	# Travel config
	var travel_distance = 300
	var travel_time = 0.4 if type == "thin_fast" else 0.9
	var speed = travel_distance / travel_time
	var elapsed = 0.0
	var move_vector = direction.normalized() * speed

	# ✅ No flickering logic applied for any projectile type
	while elapsed < travel_time:
		wind.global_position += move_vector * get_process_delta_time()
		await get_tree().process_frame
		elapsed += get_process_delta_time()

	wind.queue_free()

func spawn_slam_damage(position: Vector2, radius: float = 48.0, damage: int = 6):
	var aoe = Area2D.new()
	var shape = CollisionShape2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	shape.shape = circle
	shape.set_deferred("disabled", false)  # Ensure active shape

	aoe.add_child(shape)
	aoe.global_position = position

	# ✅ Set necessary metadata and properties
	aoe.set_meta("damage", damage)
	aoe.set_meta("damage_type", "slam")
	aoe.set_meta("weapon_owner", self)
	aoe.add_to_group("attack")

	# ✅ Use layer 0, mask 2 to only hit player HurtBox
	aoe.set_collision_layer(2)
	aoe.set_collision_mask(0)
	
	attach_damage_handler_to(aoe)
	
	get_tree().current_scene.add_child(aoe)
	_track_spawned(aoe)
	print("[DEBUG] Slam AOE added at:", position)
	
	await get_tree().create_timer(0.1).timeout
	aoe.queue_free()

func set_indicator_texture(stage: String):
	match stage:
		"light":
			attack_indicator.texture = indicator_light_red
		"medium":
			attack_indicator.texture = indicator_medium_red
		"dark":
			attack_indicator.texture = indicator_dark_red

func set_indicator_visibility(is_visible: bool):
	attack_indicator.visible = is_visible

func perform_slam_zone_attack():
	if cancel_attacks or in_stagger or in_finisher:
		is_executing_attack = false
		return

	is_executing_attack = true
	print("[TRAINER] Starting 4-slam AOE zone pattern!")

	var radius = 48.0  # Must match spawn_slam_damage()
	var indicator_size = indicator_light_red.get_size().x / 2.0  # Assume square texture
	var scale_factor = radius / indicator_size

	for i in range(4):
		if cancel_attacks or in_stagger or in_finisher:
			is_executing_attack = false
			return

		if not target_player or not is_instance_valid(target_player):
			is_executing_attack = false
			return

		# Face the player
		var to_player = (target_player.global_position - global_position).normalized()
		sprite.flip_h = to_player.x < 0
		await get_tree().create_timer(0.6).timeout
		if cancel_attacks or in_stagger or in_finisher:
			is_executing_attack = false
			return

		# Calculate dash
		var dash_target = target_player.global_position + to_player * -32  # stop ~32 px short
		var dash_speed = 2000.0
		var dash_duration = global_position.distance_to(dash_target) / dash_speed

		# Perform the dash manually over time
		var timer := 0.0
		while timer < dash_duration:
			if cancel_attacks or in_stagger or in_finisher:
				is_executing_attack = false
				return
			var delta = get_process_delta_time()
			var step = dash_speed * delta
			var new_pos = global_position.move_toward(dash_target, step)
			global_position = new_pos
			timer += delta
			await get_tree().process_frame

		await get_tree().create_timer(0.3).timeout
		if cancel_attacks or in_stagger or in_finisher:
			is_executing_attack = false
			return

		# Pick pattern and spawn indicators all at once
		var pattern = pick_random_slam_pattern()
		var player_pos = target_player.global_position
		var indicators: Array = []

		for offset in pattern:
			if cancel_attacks or in_stagger or in_finisher:
				# ensure we don't leave partial indicators around
				for _ind in indicators:
					if is_instance_valid(_ind):
						_ind.queue_free()
				is_executing_attack = false
				return
			var pos = player_pos + offset
			var indicator = Sprite2D.new()
			indicator.texture = indicator_light_red
			indicator.centered = true
			indicator.z_index = 10
			indicator.global_position = pos
			indicator.scale = Vector2.ONE * scale_factor
			get_tree().current_scene.add_child(indicator)
			_track_spawned(indicator)
			indicators.append(indicator)

		# Color transition: light → medium → dark
		await get_tree().create_timer(0.25).timeout
		if cancel_attacks or in_stagger or in_finisher:
			for ind in indicators:
				if is_instance_valid(ind):
					ind.queue_free()
			is_executing_attack = false
			return
		for ind in indicators:
			ind.texture = indicator_medium_red

		await get_tree().create_timer(0.25).timeout
		if cancel_attacks or in_stagger or in_finisher:
			for ind in indicators:
				if is_instance_valid(ind):
					ind.queue_free()
			is_executing_attack = false
			return
		for ind in indicators:
			ind.texture = indicator_dark_red

		# Slam execution
		await get_tree().create_timer(0.25).timeout
		if cancel_attacks or in_stagger or in_finisher:
			for ind in indicators:
				if is_instance_valid(ind):
					ind.queue_free()
			is_executing_attack = false
			return
		for ind in indicators:
			spawn_slam_damage(ind.global_position, radius)
			ind.queue_free()

		await get_tree().create_timer(0.4).timeout
		if cancel_attacks or in_stagger or in_finisher:
			is_executing_attack = false
			return

	is_executing_attack = false
	print("[TRAINER] Slam zone pattern complete.")

func pick_random_slam_pattern() -> Array:
	var radius = 48.0
	var patterns = [
		[Vector2(60, 0), Vector2(-60, 0), Vector2(0, 60)],
		[Vector2(60, 60), Vector2(-60, -60), Vector2(60, -60)],
		[Vector2(80, 0), Vector2(0, -50), Vector2(-80, 0)],
		[Vector2(0, 60), Vector2(50, -50), Vector2(-50, -50)],
	]
	return patterns[randi() % patterns.size()]

func show_slam_indicator(position: Vector2, initial_texture: Texture) -> Sprite2D:
	var indicator = Sprite2D.new()
	indicator.texture = initial_texture
	indicator.z_index = 10  # Ensure it's above ground visuals
	get_tree().current_scene.add_child(indicator)
	indicator.global_position = position
	return indicator

func update_honor_bar():
	honor_bar.value = honor_gauge * 100

	var was_ready := finisher_ready
	finisher_ready = honor_gauge >= (honor_max - 0.01)

	# One-shot: when we *just* became ready, open the 4s stagger window
	if not was_ready and finisher_ready:
		_start_stagger_window()
	
	print("[HONOR] Gauge:", int(round(honor_gauge * 100.0)), "% | was_ready:", was_ready, " -> now_ready:", finisher_ready)
	if not was_ready and finisher_ready:
		print("[HONOR] Reached 100% → opening 4s stagger window")
	
	_update_finisher_prompt()

func gain_honor(amount: float):
	if not duel_started or finisher_ready or in_stagger or in_finisher:
		return
	honor_gauge = clamp(honor_gauge + amount, 0.0, honor_max)
	print("[HONOR] +", amount, " → ", int(round(honor_gauge * 100.0)), "%")
	update_honor_bar()

func lose_honor(amount: float):
	if in_stagger or in_finisher:
		print("[HONOR] loss ignored during stagger/finisher")
		return
	honor_gauge = max(0.0, honor_gauge - amount)
	print("[HONOR] -", amount, " → ", int(round(honor_gauge * 100.0)), "%")
	update_honor_bar()

func perform_finisher():
	# Backward-compatible entry point; use the new sequence.
	if target_player:
		start_finisher(target_player)
	else:
		print("[FINISHER] No target_player to finisher on.")

func _on_HurtBox_area_entered(area):
	if not area.is_in_group("attack"):
		return

	# Prevent trainer from gaining honor from self-hit projectiles or effects
	if area.get_parent() == self:
		return

	gain_honor(honor_gain_per_attack)

func _on_player_took_damage(amount: int):
	print("[HONOR] Player took damage. Honor gauge lowered.")
	lose_honor(honor_loss_on_hit)

func attach_damage_handler_to(area: Area2D):
	if not area:
		return

	# ✅ Ensure it's in the correct group
	if not area.is_in_group("attack"):
		area.add_to_group("attack")

	# ✅ Ensure correct layer/mask for player HurtBox interaction (usually layer 2 hits mask 2)
	if area.collision_layer != 2 or area.collision_mask != 0:
		print("[WARNING] Area2D has incorrect collision layer/mask. Fixing now.")
		area.collision_layer = 2
		area.collision_mask = 0

	# ✅ Connect area_entered if not already connected
	if not area.is_connected("area_entered", Callable(self, "_on_attack_area_entered")):
		area.connect("area_entered", Callable(self, "_on_attack_area_entered").bind(area))

func _on_attack_area_entered(hit_area: Area2D, attack_area: Area2D):
	# hit_area: the player's hurtbox that entered
	# attack_area: the attack Area2D that emitted the signal (bound above)

	if not hit_area.is_in_group("player_hurtbox"):
		return

	var damage := 4
	var damage_type := "normal"

	if attack_area and attack_area.has_meta("damage"):
		damage = int(attack_area.get_meta("damage"))
	if attack_area and attack_area.has_meta("damage_type"):
		damage_type = str(attack_area.get_meta("damage_type"))

	var hurtbox_owner = hit_area.get_parent()
	if hurtbox_owner and hurtbox_owner.has_signal("hurt"):
		hurtbox_owner.emit_signal("hurt", damage, damage_type, self)

func setup_sword_hitbox():
	sword_hitbox.set_meta("damage", 4)
	sword_hitbox.set_meta("damage_type", "slash")
	sword_hitbox.set_meta("weapon_owner", self)
	sword_hitbox.add_to_group("attack")
	sword_hitbox.set_collision_layer(2)
	sword_hitbox.set_collision_mask(0)
	attach_damage_handler_to(sword_hitbox)

var in_finisher: bool = false  # block AI/actions during finisher
var in_stagger: bool = false   # NEW: 4s E-window gate
	
func can_accept_finisher() -> bool:
	if not duel_started or not finisher_ready or in_finisher:
		return false
	# During the stagger window we want to ALWAYS allow it
	if in_stagger:
		return true
	# Otherwise, be strict as before
	return not is_executing_attack and not is_dashing

func start_finisher(player: Node):
	if not can_accept_finisher():
		print("[FINISHER] Blocked: cannot accept finisher in current state.")
		return
	if finisher_prompt:
		finisher_prompt.visible = false
	in_stagger = false
	in_finisher = true
	is_executing_attack = true
	_interrupt_current_action()
	_freeze_trainer()
	_show_finisher_fx_pre()
	await _play_blink_strike(player)
	_clear_finisher_fx_post()
	advance_phase_via_finisher()
	_unfreeze_trainer()
	in_finisher = false
	is_executing_attack = false

func _freeze_trainer():
	self.velocity = Vector2.ZERO
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()
	animation.play("idle")
	# If your AI runs elsewhere, gate it using the flags we already set.

func _unfreeze_trainer():
	Engine.time_scale = 1.0
	cancel_attacks = false

func _show_finisher_fx_pre():
	# Quick, safe slow-mo. If you have a camera, you can tween its zoom here.
	Engine.time_scale = 0.2

func _clear_finisher_fx_post():
	Engine.time_scale = 1.0

func _play_blink_strike(player: Node) -> void:
	if not is_instance_valid(player):
		return

	# Direction from player toward trainer so dash passes through trainer
	var dir = (global_position - player.global_position).normalized()
	if dir.length() == 0:
		dir = Vector2.RIGHT

	# Entry/exit points around the trainer
	var entry = global_position - dir * 40.0
	var exit  = global_position + dir * 60.0

	# Give player brief i-frames if your player supports it
	if player.has_method("set_invincible_temporarily"):
		player.set_invincible_temporarily(0.9)

	# Snap the player to entry, then tween through the trainer
	player.global_position = entry

	# Slash VFX/animation hooks if you have them
	if animation:
		animation.play("idle")

	var tween := create_tween()
	tween.tween_property(player, "global_position", exit, 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween.finished

	# Small hit flash / freeze frame pop
	await get_tree().create_timer(0.05).timeout

func advance_phase_via_finisher():
	print("[HONOR] Finisher performed → advancing phase.")
	# Reset honor & readiness
	honor_gauge = 0.0
	finisher_ready = false
	update_honor_bar()

	# Little sell/stagger if you have it
	if animation and animation.has_animation("stagger"):
		animation.play("stagger")
		await get_tree().create_timer(0.35).timeout

	match current_phase:
		TrainerPhase.PHASE_1:
			current_phase = TrainerPhase.PHASE_2
		TrainerPhase.PHASE_2:
			current_phase = TrainerPhase.PHASE_3
		TrainerPhase.PHASE_3:
			await _end_duel_victory()
			return

	phase_attack_index = 0
	phase_attack_timer = 1.0
	print("[PHASE] Transitioned to:", current_phase)

func _end_duel_victory():
	print("[DUEL] Player victory sequence START")

	# Hard-stop AI/attacks and clear any spawned hazards.
	cancel_attacks = true
	in_stagger = false
	in_finisher = true
	is_attacking = false
	is_executing_attack = false
	if is_dashing:
		end_dash()
	self.velocity = Vector2.ZERO
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()
	_clear_spawned_attacks()

	# Make trainer non-interactive during the sequence.
	var prev_layer := collision_layer
	var prev_mask := collision_mask
	collision_layer = 0
	collision_mask = 0

	# Hide the E prompt immediately.
	if finisher_prompt:
		finisher_prompt.visible = false

	# Smoothly fade out Honor UI if present.
	if is_instance_valid(honor_bar):
		var t := create_tween()
		t.tween_property(honor_bar, "modulate:a", 0.0, 0.35)
		await t.finished
		honor_bar.visible = false
		honor_bar.modulate.a = 1.0  # reset alpha for next duel

	# Defeat / kneel / bow animation if available; otherwise idle + small pause.
	if animation:
		if animation.has_animation("defeated"):
			animation.play("defeated")
		elif animation.has_animation("kneel"):
			animation.play("kneel")
		else:
			animation.play("idle")
	await get_tree().create_timer(0.8).timeout

	# Optional: small camera or VFX beat would go here.

	# Fire a hook so the world can reward the player / show dialogue.
	# (Safe even if nobody listens.)
	if has_signal("duel_finished"):
		emit_signal("duel_finished", true)

	# Reset duel state so the trainer can be challenged again later if desired.
	duel_started = false
	duel_requested = false
	finisher_ready = false
	honor_gauge = 0.0
	update_honor_bar()

	cancel_attacks = false
	in_finisher = false
	current_phase = TrainerPhase.PHASE_1
	phase_attack_index = 0
	phase_attack_timer = 1.0

	# Restore collisions (kept off if you want the trainer to stay non-interactive).
	collision_layer = prev_layer
	collision_mask = prev_mask

	print("[DUEL] Player victory sequence END → state reset")

func _update_finisher_prompt() -> void:
	if finisher_prompt == null:
		return

	var can_show = duel_started \
		and finisher_ready \
		and target_player != null \
		and can_accept_finisher()

	finisher_prompt.visible = can_show
	if not can_show:
		return

	# World-space label: just place it a bit above the trainer.
	finisher_prompt.position = Vector2(0, -28)

func _start_stagger_window() -> void:
	print("[FINISHER] Stagger window START (4s)")
	if in_stagger or in_finisher:
		return

	in_stagger = true
	_interrupt_current_action()
	if is_dashing:
		end_dash()

	self.velocity = Vector2.ZERO
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()
	if animation and animation.has_animation("stagger"):
		animation.play("stagger")
	else:
		animation.play("idle")

	var elapsed := 0.0
	var window := 4.0
	while elapsed < window:
		# If finisher actually starts, bail early
		if in_finisher:
			print("[FINISHER] Stagger window INTERRUPTED by finisher")
			in_stagger = false
			cancel_attacks = false
			return
		await get_tree().process_frame
		elapsed += get_process_delta_time()

	# Timeout: finisher wasn’t used — drop honor to 50% and continue
	if in_stagger and not in_finisher:
		honor_gauge = honor_max * 0.5
		update_honor_bar() # recalculates finisher_ready + hides E

	in_stagger = false
	phase_attack_timer = 1.0  # tiny grace before resuming attacks
	print("[FINISHER] Stagger window EXPIRED → honor set to 50%")
	cancel_attacks = false

var cancel_attacks: bool = false
var _spawned_attack_nodes: Array = []   # track AOEs, projectiles, indicators

func _track_spawned(node: Node) -> void:
	if node:
		_spawned_attack_nodes.append(node)

func _clear_spawned_attacks() -> void:
	for n in _spawned_attack_nodes:
		if is_instance_valid(n):
			n.queue_free()
	_spawned_attack_nodes.clear()

func _interrupt_current_action() -> void:
	# Flip the “please stop” flag so long coroutines can bail.
	cancel_attacks = true
	is_attacking = false
	is_executing_attack = false

	# End movement & hitboxes
	if is_dashing:
		end_dash()
	self.velocity = Vector2.ZERO
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()

	# Kill anything already spawned
	_clear_spawned_attacks()

	# Snap anim to stagger/idle is handled by caller
