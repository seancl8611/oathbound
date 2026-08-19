extends Node

## =============================================================================
## STANCE EFFECTS — Universal Autoload Singleton
## =============================================================================
## Hooked from hurt_box.gd (universal for all enemy types).
## =============================================================================

# ─── STORM TUNING (TEST MODE — revert values in comments after) ───
const CHAIN_BASE_JUMPS = 1
const CHAIN_BASE_RADIUS = 200.0       # real: 120.0
const CHAIN_BASE_CHANCE = 0.15        # 15% at 0 stacks
const CHAIN_CHANCE_PER_STACK = 0.10   # +10% per stack
const CHAIN_MAX_CHANCE = 0.65         # cap at 65% (5 stacks)
const CHAIN_ICD = 0.75                # anti-spam; tune 0.75–1.25            # real: 1.0

const LIGHTNING_BASE_MAX_STACKS = 5
const LIGHTNING_BASE_DURATION = 4.0

const SHOCK_BASE_CHANCE = 0.00        # base chance shock fires at 1 stack
const SHOCK_CHANCE_PER_STACK = 0.18   # +12% per stack (5 stacks → 0.10 + 0.60 = 70%)
const SHOCK_DAMAGE_PER_STACK = 6
const SHOCK_ROLL_ICD = 1.5            # gates the ROLL attempt, not just success
const SHOCK_CONSUME_ICD = 2.5         # after a successful pop, hard lockout

# ─── FROST TUNING ─────────────────────────────────────────
const CHILL_BASE_MAX_STACKS = 5
const CHILL_BASE_DURATION = 6.0
const CHILL_SLOW_PER_STACK = 0.04     # 4% per stack → 20% at 5 stacks
const CHILL_BOON_SLOW_PER_STACK = 0.07 # 7% per stack → 35% at 5 stacks

const FREEZE_BASE_DURATION = 2.8
const FREEZE_ICD = 8.0
const FREEZE_PARRY_CHANCE = 0.35
const SHATTER_POSTURE_DAMAGE = 15.0   # flat posture burst from frost_shatter_damage boon

# ─── FROST VISUAL TUNING ─────────────────────────────────
const CHILL_STACK_COLOR = Color(0.4, 0.75, 1.0, 1.0)
const CHILL_TINT_COLOR = Color(0.55, 0.65, 1.0, 1.0)   # visible blue at max stacks
const FREEZE_TINT_COLOR = Color(0.35, 0.55, 1.0, 1.0)   # deep icy blue, opaque
const SHATTER_COLOR = Color(0.7, 0.9, 1.0, 1.0)

# ─── HEX TUNING ──────────────────────────────────────────
const CURSE_BASE_MAX_STACKS = 5
const CURSE_BASE_DURATION = 6.0
const CURSE_BASE_CHANCE = 1.0           # 30% per hit to apply curse
const CURSE_DMG_REDUCE_PER_STACK = 0.04  # 4% per stack = 20% at 5 (base)
const CURSE_ENHANCED_REDUCE_PER_STACK = 0.06  # 6% per stack = 30% at 5 (hex_curse_stacks)

const DOOM_BASE_DELAY = 1.5
const DOOM_BASE_DAMAGE = 30
const DOOM_ICD = 6.0
const DOOM_PARRY_CHANCE = 0.45
const DOOM_SPREAD_RADIUS = 100.0
const DOOM_CHAIN_RADIUS = 120.0

const EXPOSE_POSTURE_PER_STACK = 1.5     # flat posture bonus per curse stack on hit

# ─── HEX VISUAL TUNING ───────────────────────────────────
const CURSE_STACK_COLOR = Color(0.6, 0.3, 0.8, 1.0)
const CURSE_TINT_COLOR = Color(0.7, 0.5, 0.85, 1.0)
const DOOM_TINT_COLOR = Color(0.55, 0.2, 0.6, 1.0)
const DOOM_DETONATION_COLOR = Color(0.8, 0.3, 1.0, 1.0)

# ─── EMBER TUNING ────────────────────────────────────────
const BURN_BASE_DURATION = 5.0
const BURN_TICK_INTERVAL = 1.0
const BURN_I1_DMG = 2
const BURN_I2_DMG = 3
const BURN_I3_DMG = 5
const BURN_I3_POSTURE_RECOVERY_MULT = 0.65   # 35% slower posture recovery

const SCORCH_BASE_RADIUS = 35.0
const SCORCH_BASE_LIFETIME = 3.0
const SCORCH_CHIP_DMG = 1
const SCORCH_CHIP_INTERVAL = 0.8
const SCORCH_ZONE_CAP = 3
const SCORCH_DASH_ICD = 1.2
const SCORCH_PARRY_ICD = 4.0
const SCORCH_KILL_ICD = 3.0
const SCORCH_TRAIL_LIFETIME = 2.0
const SCORCH_FADEOUT_TIME = 0.35
const ERUPTION_DAMAGE = 20

# ─── EMBER VISUAL TUNING ─────────────────────────────────
const BURN_TINT_COLOR = Color(1.0, 0.65, 0.3, 1.0)
const BURN_I3_TINT_COLOR = Color(1.0, 0.4, 0.15, 1.0)
const BURN_INDICATOR_COLOR = Color(1.0, 0.5, 0.15, 1.0)
const SCORCH_ZONE_COLOR = Color(1.0, 0.4, 0.1, 0.3)
const SCORCH_ZONE_EDGE_COLOR = Color(1.0, 0.5, 0.15, 0.6)
const ERUPTION_COLOR = Color(1.0, 0.3, 0.0, 1.0)

# ─── SHADOW TUNING ───────────────────────────────────────
const MARK_BASE_DURATION = 4.0
const MARK_BASE_CHANCE = 0.20         # 20% per hit
const MARK_PARRY_CHANCE = 1.0         # guaranteed with shadow_mark_parry
const MARK_APPLY_ICD = 1.25           # global cooldown between mark applications

const EXPOSE_BASE_DURATION = 5.0
const EXPOSE_POSTURE_BONUS = 0.20     # 20% bonus posture damage taken
const EXPOSE_ENHANCED_BONUS = 0.35    # with shadow_expose_posture

const SHADOW_CHARGE_DURATION = 3.0
const SHADOW_CHARGE_ENHANCED_DURATION = 4.0  # with shadow_expose_window

const AFTERIMAGE_HP_DAMAGE = 8
const AFTERIMAGE_POSTURE_DAMAGE = 5.0
const AFTERIMAGE_DELAY = 0.32         # delay before afterimage strikes
const SHADOW_DASH_CONSUME_RADIUS = 80.0

# ─── SHADOW VISUAL TUNING ───────────────────────────────
const MARK_ICON_COLOR = Color(0.45, 0.2, 0.55, 1.0)
const EXPOSE_TINT_COLOR = Color(0.7, 0.55, 0.8, 1.0)
const AFTERIMAGE_COLOR = Color(0.5, 0.25, 0.6, 0.7)
const SHADOW_CHARGE_COLOR = Color(0.55, 0.3, 0.65, 1.0)

# ─── VISUAL TUNING ────────────────────────────────────────
const CHAIN_ARC_COLOR = Color(0.3, 0.7, 1.0, 1.0)
const CHAIN_ARC_WIDTH = 3.5
const CHAIN_ARC_DURATION = 0.35
const SHOCK_POP_COLOR = Color(1.0, 1.0, 0.3, 1.0)
const SHOCK_STACK_COLOR = Color(0.3, 0.7, 1.0, 1.0)

var _active_scorch_zones: Array = []

# =============================================================================
# MAIN HOOKS
# =============================================================================

## Called from hurt_box.gd when player attack hits any enemy
func on_player_hit(target: Node, player: Node) -> void:
	if not is_instance_valid(target) or not is_instance_valid(player):
		return
	if "hp" in target and target.hp <= 0:
		return

	var acquired = _get_acquired()
	if acquired.is_empty():
		return

	# === SHADOW: Consume Shadow Charge → DEFERRED afterimage slash ===
	if _has_shadow_charge(player):
		_schedule_afterimage(target, player, acquired)

	# === FROST: Shatter check (BEFORE applying new effects) ===
	if "frost_chill_1" in acquired or "frost_freeze_1" in acquired:
		var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
		if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
			_shatter_frozen(target, player, acquired)
			return  # Shatter consumes the hit's stance effects

	# === STORM: Lightning stacks ===
	if "storm_shock_1" in acquired:
		on_lightning_hit(target, player, 1)

	# === STORM: Chain lightning proc ===
	if "storm_chain_1" in acquired:
		_try_chain_lightning(target, player, acquired)

	# === FROST: Chill stacks ===
	if "frost_chill_1" in acquired:
		_apply_chill_stacks(target, 1, acquired)

	# === HEX: Curse stacks (chance-based) ===
	if "hex_curse_1" in acquired:
		if randf() <= CURSE_BASE_CHANCE:
			_apply_curse_stacks(target, 1, acquired)

	# === HEX: Expose — bonus posture on hitting cursed enemies ===
	if "hex_expose" in acquired:
		var curse_stacks = int(target.get_meta("_stance_hex_curse_stacks", 0))
		if curse_stacks > 0:
			_add_posture(target, EXPOSE_POSTURE_PER_STACK * curse_stacks)
	
	# === EMBER: Apply/refresh Burn ===
	if "ember_burn_1" in acquired:
		_apply_burn(target, acquired)

	# === SHADOW: Expose posture bonus on hitting exposed enemies ===
	if "shadow_expose_1" in acquired:
		var expose_until = float(target.get_meta("_stance_shadow_expose_until", 0.0))
		if expose_until > 0.0 and Time.get_ticks_msec() * 0.001 < expose_until:
			var bonus = EXPOSE_ENHANCED_BONUS if "shadow_expose_posture" in acquired else EXPOSE_POSTURE_BONUS
			var base_posture = 4.0  # base bonus per hit on exposed target
			_add_posture(target, base_posture * (1.0 + bonus))

	# === SHADOW: Mark application (chance-based) ===
	if "shadow_mark_1" in acquired:
		_try_apply_mark(target, player, MARK_BASE_CHANCE, acquired)
		
func _process(delta: float) -> void:
	_manage_scorch_zones(delta)
	_check_shadow_charge_expiry()
	_process_pending_afterimage()
	
func _check_shadow_charge_expiry() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if not is_instance_valid(player):
		return
	var indicator = player.get_node_or_null("StanceShadowChargeIndicator")
	if indicator == null:
		return
	# If indicator exists but charge has expired, clean it up
	if not _has_shadow_charge(player):
		indicator.name = "StanceShadowChargeIndicator_dead"
		indicator.queue_free()

func _process_pending_afterimage() -> void:
	if not has_meta("_pending_afterimage"):
		return

	var data = get_meta("_pending_afterimage")
	var now = Time.get_ticks_msec() * 0.001
	if now < data["fire_at"]:
		return

	# Clear immediately so it only fires once
	remove_meta("_pending_afterimage")

	var target = instance_from_id(data["target_id"])
	var player = instance_from_id(data["player_id"])
	if target == null or player == null:
		return
	if not is_instance_valid(target) or not is_instance_valid(player):
		return

	_consume_shadow_charge(target, player, data["acquired"])
	
func on_enemy_death(target: Node) -> void:
	if not is_instance_valid(target):
		return

	var acquired = _get_acquired()

	# === HEX: Spread curse to nearby enemies on cursed enemy death ===
	if "hex_curse_spread" in acquired:
		var curse_stacks = int(target.get_meta("_stance_hex_curse_stacks", 0))
		if curse_stacks > 0:
			_apply_curse_pulse(target, 2, DOOM_SPREAD_RADIUS, acquired)
	
	# === EMBER: Kill scorch zone (rare) ===
	if "ember_kill_scorch" in acquired and "ember_scorch_1" in acquired:
		var player = target.get_tree().get_first_node_in_group("player")
		if is_instance_valid(player):
			var now = Time.get_ticks_msec() * 0.001
			var last_kill_scorch = float(player.get_meta("_stance_ember_kill_scorch_icd", 0.0))
			if now >= last_kill_scorch:
				player.set_meta("_stance_ember_kill_scorch_icd", now + SCORCH_KILL_ICD)
				_spawn_scorch_zone(target.global_position, acquired, false)

	# Clean up burn metadata on death
	target.set_meta("_stance_ember_burn_until", 0.0)
	target.set_meta("_stance_ember_burn_intensity", 0)
	
	# Clean up doom if active (prevent ghost detonation)
	target.set_meta("_stance_hex_doom_at", 0.0)

	# === SHADOW: Clean up mark on death ===
	target.set_meta("_stance_shadow_mark_until", 0.0)
	_remove_mark_visual(target)
	target.set_meta("_stance_shadow_expose_until", 0.0)
	_remove_expose_tint(target)
	
## Public entry: apply lightning stacks from any lightning source
func on_lightning_hit(target: Node, player: Node, stacks: int = 1) -> void:
	if not is_instance_valid(target):
		return
	var acquired = _get_acquired()
	_apply_lightning_stacks(target, stacks, acquired)
	
func on_player_parry(target: Node, player: Node) -> void:
	if not is_instance_valid(target) or not is_instance_valid(player):
		return

	var acquired = _get_acquired()

	# === STORM: Parry shock stacks ===
	if "storm_shock_parry" in acquired and "storm_shock_1" in acquired:
		on_lightning_hit(target, player, 2)

	# === FROST: Bonus chill on parry (rare) ===
	if "frost_parry_chill" in acquired and "frost_chill_1" in acquired:
		_apply_chill_stacks(target, 2, acquired)

	# === FROST: Chance to freeze on parry (common) ===
	if "frost_freeze_1" in acquired:
		var now = Time.get_ticks_msec() * 0.001
		var freeze_icd = float(target.get_meta("_stance_freeze_icd", 0.0))
		if now >= freeze_icd and randf() <= FREEZE_PARRY_CHANCE:
			_trigger_freeze(target, acquired)

	# === HEX: Parry doom — chance to doom cursed enemies on parry (rare) ===
	if "hex_parry_doom" in acquired and "hex_doom_1" in acquired:
		var curse_stacks = int(target.get_meta("_stance_hex_curse_stacks", 0))
		if curse_stacks > 0:
			if randf() <= DOOM_PARRY_CHANCE:
				_trigger_doom(target, acquired)
	
	# === EMBER: Parry scorch zone (rare) ===
	if "ember_parry_scorch" in acquired and "ember_scorch_1" in acquired:
		var now = Time.get_ticks_msec() * 0.001
		var last_parry_scorch = float(player.get_meta("_stance_ember_parry_scorch_icd", 0.0))
		if now >= last_parry_scorch:
			player.set_meta("_stance_ember_parry_scorch_icd", now + SCORCH_PARRY_ICD)
			_spawn_scorch_zone(target.global_position, acquired, false)

	# === SHADOW: Guaranteed mark on parry (uncommon) ===
	if "shadow_mark_parry" in acquired and "shadow_mark_1" in acquired:
		_try_apply_mark(target, player, MARK_PARRY_CHANCE, acquired)
	
	# === SHADOW: Consume mark on parrying a MARKED target (requires shadow_expose_1) ===
	if "shadow_expose_1" in acquired and "shadow_mark_1" in acquired:
		var mark_until = float(target.get_meta("_stance_shadow_mark_until", 0.0))
		if mark_until > 0.0 and Time.get_ticks_msec() * 0.001 < mark_until:
			_consume_mark(target, player, acquired)
			
## Called from enemy._apply_shock_attack_penalty when enemy starts attack
func on_enemy_attack_start(enemy: Node) -> void:
	if not is_instance_valid(enemy):
		return

	var stacks = int(enemy.get_meta("_stance_lightning_stacks", 0))
	if stacks <= 0:
		return

	var now = Time.get_ticks_msec() * 0.001

	# Roll ICD — gates the attempt, not just success
	var roll_until = float(enemy.get_meta("_stance_shock_roll_icd", 0.0))
	if now < roll_until:
		return
	enemy.set_meta("_stance_shock_roll_icd", now + SHOCK_ROLL_ICD)

	# Consume ICD — hard lockout after a successful pop
	var consume_until = float(enemy.get_meta("_stance_shock_consume_icd", 0.0))
	if now < consume_until:
		return

	# Ramp late: stack 1 contributes 0, stack 2 starts mattering
	var effective_stacks = max(0, stacks - 1)
	var chance := SHOCK_BASE_CHANCE + float(effective_stacks) * SHOCK_CHANCE_PER_STACK
	chance = min(chance, 1.0)

	if randf() > chance:
		return

	# Success — consume all stacks, deal burst
	_consume_shock(enemy, stacks)

## Called every frame from enemy _physics_process
func tick(target: Node, _delta: float) -> void:
	if not is_instance_valid(target):
		return

	var now = Time.get_ticks_msec() * 0.001

	# === STORM: Lightning stack expiry ===
	var lightning_until = float(target.get_meta("_stance_lightning_until", 0.0))
	if lightning_until > 0.0 and now >= lightning_until:
		var stacks = int(target.get_meta("_stance_lightning_stacks", 0))
		if stacks > 0:
			target.set_meta("_stance_lightning_stacks", 0)
			target.set_meta("_stance_lightning_until", 0.0)
			_remove_shock_visual(target)

	# === FROST: Freeze expiry + visual enforcement ===
	var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
	if frozen_until > 0.0:
		if now >= frozen_until:
			_end_freeze(target, _get_acquired())
		else:
			# Re-apply freeze tint every frame (prevents flash tweens from wiping it)
			if ("sprite" in target) and target.sprite != null:
				target.sprite.modulate = FREEZE_TINT_COLOR
			# Keep animation locked
			if "anim" in target and target.anim != null:
				target.anim.speed_scale = 0.0

	# === FROST: Chill stack expiry + slow management ===
	var frost_until = float(target.get_meta("_stance_frost_until", 0.0))
	var frost_stacks = int(target.get_meta("_stance_frost_stacks", 0))
	if frost_stacks > 0:
		if frost_until > 0.0 and now >= frost_until:
			# Stacks expired — remove chill entirely
			_remove_chill(target)
		else:
			# Stacks active — apply slow
			_apply_chill_slow(target, frost_stacks)
	else:
		# No stacks — ensure slow is cleaned up
		_restore_speed(target)
	
	# === HEX: Curse stack expiry ===
	var curse_stacks = int(target.get_meta("_stance_hex_curse_stacks", 0))
	if curse_stacks > 0:
		var curse_until = float(target.get_meta("_stance_hex_curse_until", 0.0))
		if curse_until > 0.0 and now >= curse_until:
			_remove_curse(target)

	# === HEX: Doom countdown + detonation ===
	var doom_at = float(target.get_meta("_stance_hex_doom_at", 0.0))
	if doom_at > 0.0:
		if now >= doom_at:
			_detonate_doom(target, _get_acquired())
		else:
			# Pulse the doom indicator faster as detonation approaches
			var doom_start = float(target.get_meta("_stance_hex_doom_start", now))
			var total = doom_at - doom_start
			var remaining = doom_at - now
			var progress = 1.0 - clampf(remaining / max(total, 0.01), 0.0, 1.0)
			_update_doom_pulse(target, progress)
	
	# === EMBER: Burn tick damage ===
	var burn_until = float(target.get_meta("_stance_ember_burn_until", 0.0))
	if burn_until > 0.0:
		if now >= burn_until:
			_remove_burn(target)
		else:
			_tick_burn(target, now)
			# Check if enemy is in a scorch zone (for burn boost / Intensity 3)
			var in_scorch = _is_in_scorch_zone(target)
			target.set_meta("_stance_ember_in_scorch", in_scorch)

	# === SHADOW: Mark expiry ===
	var mark_until = float(target.get_meta("_stance_shadow_mark_until", 0.0))
	if mark_until > 0.0 and now >= mark_until:
		_remove_mark(target)

	# === SHADOW: Expose expiry ===
	var expose_until = float(target.get_meta("_stance_shadow_expose_until", 0.0))
	if expose_until > 0.0 and now >= expose_until:
		_remove_expose(target)
		
# =============================================================================
# CHAIN LIGHTNING
# =============================================================================

func _try_chain_lightning(origin: Node, player: Node, acquired: Array) -> void:
	var now = Time.get_ticks_msec() * 0.001
	var last_chain = float(player.get_meta("_stance_chain_icd", 0.0))
	if now < last_chain:
		return

	# Proc chance scales with lightning stacks on the origin target
	var origin_stacks = int(origin.get_meta("_stance_lightning_stacks", 0))
	var proc_chance = CHAIN_BASE_CHANCE + float(origin_stacks) * CHAIN_CHANCE_PER_STACK
	proc_chance = min(proc_chance, CHAIN_MAX_CHANCE)

	if randf() > proc_chance:
		return

	player.set_meta("_stance_chain_icd", now + CHAIN_ICD)

	var max_jumps = CHAIN_BASE_JUMPS
	var radius = CHAIN_BASE_RADIUS
	if "storm_chain_jump" in acquired:
		max_jumps += 1
	if "storm_chain_range" in acquired:
		radius *= 1.3

	var hit_enemies: Array = [origin]
	var current_source = origin

	for _jump in max_jumps:
		var next_target = _find_nearest_enemy(current_source, hit_enemies, radius)
		if next_target == null:
			break

		hit_enemies.append(next_target)

		# Visual only: chain lightning does NOT deal HP damage
		_spawn_chain_arc(current_source, next_target)

		# Chain ALWAYS applies lightning stacks (through block) when storm_shock_1 is owned
		if "storm_shock_1" in acquired:
			on_lightning_hit(next_target, player, 1)

		current_source = next_target
		
func _find_nearest_enemy(source: Node, exclude: Array, radius: float) -> Node:
	var best_target = null
	var best_dist = radius

	# Get camera viewport rect for on-screen check
	var cam = source.get_viewport().get_camera_2d()
	var screen_rect = Rect2()
	var has_cam = false
	if cam and is_instance_valid(cam):
		var vp_size = source.get_viewport_rect().size
		var cam_pos = cam.global_position
		# Add small margin so enemies at screen edge still count
		screen_rect = Rect2(cam_pos - vp_size * 0.55, vp_size * 1.1)
		has_cam = true

	for enemy in source.get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		if enemy in exclude:
			continue
		if "hp" in enemy and enemy.hp <= 0:
			continue
		# On-screen filter
		if has_cam and not screen_rect.has_point(enemy.global_position):
			continue
		var dist = source.global_position.distance_to(enemy.global_position)
		if dist < best_dist:
			best_dist = dist
			best_target = enemy

	return best_target

func _deal_chain_damage(target: Node, damage: int, ignore_block: bool = false) -> void:
	if not is_instance_valid(target):
		return

	var actual_damage = damage
	if not ignore_block and _is_actively_guarding(target):
		actual_damage = 0
		if "combat" in target and target.combat != null and target.combat.has_method("add_posture"):
			target.combat.add_posture(2.0)

	if actual_damage > 0 and "hp" in target:
		target.hp -= actual_damage
		if target.hp < 0:
			target.hp = 0

	if DamageNumberManager and actual_damage > 0:
		DamageNumberManager.show_damage_number(
			actual_damage,
			target.global_position + Vector2(randf_range(-10, 10), -25),
			"lightning",
			target
		)

	_flash_sprite_safe(target, CHAIN_ARC_COLOR, 0.1)

	if actual_damage > 0 and target.hp <= 0 and target.has_method("death"):
		target.death()
		
func _spawn_chain_arc(from_node: Node, to_node: Node) -> void:
	if not is_instance_valid(from_node) or not is_instance_valid(to_node):
		return

	var start = from_node.global_position
	var end = to_node.global_position

	# Main bolt
	var bolt = Line2D.new()
	bolt.width = CHAIN_ARC_WIDTH
	bolt.default_color = CHAIN_ARC_COLOR
	bolt.z_index = 100

	var segments = 8
	bolt.add_point(start)
	for i in range(1, segments):
		var t = float(i) / float(segments)
		var mid = start.lerp(end, t)
		mid += Vector2(randf_range(-12, 12), randf_range(-12, 12))
		bolt.add_point(mid)
	bolt.add_point(end)

	from_node.get_tree().current_scene.add_child(bolt)

	# Glow behind bolt
	var glow = Line2D.new()
	glow.width = CHAIN_ARC_WIDTH * 3.0
	glow.default_color = Color(CHAIN_ARC_COLOR.r, CHAIN_ARC_COLOR.g, CHAIN_ARC_COLOR.b, 0.3)
	glow.z_index = 99
	for i in bolt.get_point_count():
		glow.add_point(bolt.get_point_position(i))
	from_node.get_tree().current_scene.add_child(glow)

	# Impact flash
	var flash = _create_flash_circle(end, 14.0, CHAIN_ARC_COLOR)
	from_node.get_tree().current_scene.add_child(flash)

	var tw = from_node.get_tree().create_tween()
	tw.set_parallel(true)
	tw.tween_property(bolt, "modulate:a", 0.0, CHAIN_ARC_DURATION)
	tw.tween_property(glow, "modulate:a", 0.0, CHAIN_ARC_DURATION)
	tw.tween_property(flash, "modulate:a", 0.0, CHAIN_ARC_DURATION * 0.7)
	tw.tween_property(flash, "scale", Vector2(2.0, 2.0), CHAIN_ARC_DURATION * 0.7)
	tw.chain().tween_callback(func():
		if is_instance_valid(bolt): bolt.queue_free()
		if is_instance_valid(glow): glow.queue_free()
		if is_instance_valid(flash): flash.queue_free()
	)


func _create_flash_circle(pos: Vector2, radius: float, color: Color) -> Node2D:
	var node = Node2D.new()
	node.global_position = pos
	node.z_index = 101
	var circle = Line2D.new()
	circle.width = 2.0
	circle.default_color = color
	for i in range(17):
		var angle = (float(i) / 16.0) * TAU
		circle.add_point(Vector2(cos(angle), sin(angle)) * radius)
	node.add_child(circle)
	var dot = ColorRect.new()
	dot.size = Vector2(6, 6)
	dot.position = Vector2(-3, -3)
	dot.color = Color(1, 1, 1, 0.9)
	node.add_child(dot)
	return node


# =============================================================================
# SHOCK STACKS
# =============================================================================

func _apply_lightning_stacks(target: Node, count: int, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	var max_stacks = LIGHTNING_BASE_MAX_STACKS
	if "storm_shock_stacks" in acquired:
		max_stacks = 7

	var duration = LIGHTNING_BASE_DURATION
	if "storm_shock_duration" in acquired:
		duration += 2.0

	var now = Time.get_ticks_msec() * 0.001
	var current = int(target.get_meta("_stance_lightning_stacks", 0))
	var new_stacks = min(current + count, max_stacks)

	target.set_meta("_stance_lightning_stacks", new_stacks)
	target.set_meta("_stance_lightning_until", now + duration)

	_update_shock_visual(target, new_stacks, max_stacks)

	if new_stacks != current:
		_flash_sprite_safe(target, SHOCK_STACK_COLOR, 0.08)
		
func _consume_shock(enemy: Node, stacks: int) -> void:
	if not is_instance_valid(enemy):
		return

	var now = Time.get_ticks_msec() * 0.001
	var acquired = _get_acquired()

	var damage = stacks * SHOCK_DAMAGE_PER_STACK
	enemy.set_meta("_stance_lightning_stacks", 0)
	enemy.set_meta("_stance_lightning_until", 0.0)
	enemy.set_meta("_stance_shock_consume_icd", now + SHOCK_CONSUME_ICD)

	if "hp" in enemy:
		enemy.hp -= damage
		if enemy.hp < 0:
			enemy.hp = 0

	if DamageNumberManager:
		DamageNumberManager.show_damage_number(
			damage,
			enemy.global_position + Vector2(randf_range(-8, 8), -30),
			"shock",
			enemy
		)

	if "storm_shock_posture" in acquired:
		_add_posture(enemy, float(stacks) * 2.0)

	if "storm_shock_chain" in acquired and "storm_chain_1" in acquired:
		var chain_target = _find_nearest_enemy(enemy, [enemy], CHAIN_BASE_RADIUS)
		if chain_target:
			_spawn_chain_arc(enemy, chain_target)
			# Shock-chain applies stacks only (no HP damage)
			on_lightning_hit(chain_target, get_tree().get_first_node_in_group("player"), 1)

	if "storm_shock_ring" in acquired:
		_spawn_shock_ring(enemy, stacks)

	_spawn_shock_pop_effect(enemy, stacks)
	_remove_shock_visual(enemy)

	if enemy.hp <= 0 and enemy.has_method("death"):
		enemy.death()
		
func _spawn_shock_ring(origin: Node, stacks: int) -> void:
	if not is_instance_valid(origin):
		return
	var ring_radius = 60.0
	var ring_damage = max(1, stacks * 3)
	for enemy in origin.get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or enemy == origin:
			continue
		if "hp" in enemy and enemy.hp <= 0:
			continue
		if origin.global_position.distance_to(enemy.global_position) <= ring_radius:
			_deal_chain_damage(enemy, ring_damage)
	_spawn_ring_visual(origin.global_position, ring_radius, origin.get_tree())


func _spawn_ring_visual(center: Vector2, radius: float, tree: SceneTree) -> void:
	var ring = Node2D.new()
	ring.global_position = center
	ring.z_index = 100
	tree.current_scene.add_child(ring)
	var line = Line2D.new()
	line.width = 2.5
	line.default_color = SHOCK_POP_COLOR
	for i in range(25):
		var angle = (float(i) / 24.0) * TAU
		line.add_point(Vector2(cos(angle), sin(angle)) * radius)
	ring.add_child(line)
	var tw = tree.create_tween()
	tw.set_parallel(true)
	tw.tween_property(ring, "scale", Vector2(1.3, 1.3), 0.2)
	tw.tween_property(line, "modulate:a", 0.0, 0.2)
	tw.chain().tween_callback(ring.queue_free)


# =============================================================================
# SHOCK VISUALS
# =============================================================================

func _update_shock_visual(target: Node, stacks: int, _max_stacks: int) -> void:
	if not is_instance_valid(target):
		return

	var indicator = target.get_node_or_null("StanceShockIndicator")
	if indicator == null:
		indicator = Node2D.new()
		indicator.name = "StanceShockIndicator"
		indicator.z_index = 110
		indicator.position = Vector2(0, -50)
		target.add_child(indicator)

	for child in indicator.get_children():
		child.queue_free()

	var total_width = (stacks - 1) * 10.0
	var start_x = -total_width * 0.5

	for i in stacks:
		var outline = ColorRect.new()
		outline.size = Vector2(10, 10)
		outline.color = Color(1, 1, 1, 0.8)
		outline.position = Vector2(start_x + i * 10.0 - 5, -5)
		indicator.add_child(outline)
		var dot = ColorRect.new()
		dot.size = Vector2(8, 8)
		dot.color = SHOCK_STACK_COLOR
		dot.position = Vector2(start_x + i * 10.0 - 4, -4)
		indicator.add_child(dot)
		
func _remove_shock_visual(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceShockIndicator")
	if indicator:
		# Rename before freeing so _update_shock_visual won't find the dying node
		indicator.name = "StanceShockIndicator_dead"
		indicator.queue_free()
		
func _spawn_shock_pop_effect(enemy: Node, stacks: int) -> void:
	if not is_instance_valid(enemy):
		return
	var burst = Node2D.new()
	burst.global_position = enemy.global_position
	burst.z_index = 105
	enemy.get_tree().current_scene.add_child(burst)

	var particle_count = min(stacks * 3, 15)
	for i in particle_count:
		var p = ColorRect.new()
		p.size = Vector2(4, 4)
		p.position = Vector2(-2, -2)
		p.color = SHOCK_POP_COLOR
		burst.add_child(p)
		var angle = randf() * TAU
		var dist = randf_range(15, 35)
		var end_pos = Vector2(cos(angle), sin(angle)) * dist
		var tw = burst.get_tree().create_tween()
		tw.set_parallel(true)
		tw.tween_property(p, "position", end_pos, 0.2)
		tw.tween_property(p, "modulate:a", 0.0, 0.2)

	var flash = _create_flash_circle(Vector2.ZERO, 20.0, SHOCK_POP_COLOR)
	burst.add_child(flash)
	var ftw = burst.get_tree().create_tween()
	ftw.set_parallel(true)
	ftw.tween_property(flash, "scale", Vector2(1.5, 1.5), 0.2)
	ftw.tween_property(flash, "modulate:a", 0.0, 0.2)

	# FIX: tween cleanup instead of timer+lambda
	var cleanup = burst.get_tree().create_tween()
	cleanup.tween_interval(0.3)
	cleanup.tween_callback(burst.queue_free)
	
# =============================================================================
# HELPERS
# =============================================================================

func _flash_sprite_safe(target: Node, color: Color, duration: float) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return
	# Don't flash during freeze — it fights with the freeze tint
	var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
	if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
		return
	var orig = target.sprite.modulate
	target.sprite.modulate = color
	var tw = target.get_tree().create_tween()
	tw.tween_interval(duration)
	tw.tween_property(target.sprite, "modulate", orig, 0.01)
	
func _get_acquired() -> Array:
	var rd = get_node_or_null("/root/RunData")
	if rd and "acquired_upgrades" in rd:
		return rd.acquired_upgrades
	return []


func _add_posture(target: Node, amount: float) -> void:
	if "combat" in target and target.combat != null:
		if target.combat.has_method("add_posture"):
			target.combat.add_posture(amount)
			return
	if "posture" in target and "max_posture" in target:
		target.posture = min(target.posture + amount, target.max_posture)
		if target.has_method("_update_posture_bar"):
			target._update_posture_bar()

func _is_actively_guarding(t: Node) -> bool:
	if not is_instance_valid(t):
		return false
	if not t.has_method("is_blocking") or not t.is_blocking():
		return false

	# If they're mid-attack/telegraph/swing, don't treat them as guarding for lightning AoE
	if ("telegraphing" in t and t.telegraphing) or ("swinging" in t and t.swinging) or ("is_attacking" in t and t.is_attacking):
		return false

	return true

# =============================================================================
# FROST — CHILL STACKS
# =============================================================================

func _apply_chill_stacks(target: Node, count: int, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	# Don't apply chill while frozen
	var now = Time.get_ticks_msec() * 0.001
	var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
	if frozen_until > 0.0 and now < frozen_until:
		return

	var max_stacks = CHILL_BASE_MAX_STACKS
	var duration = CHILL_BASE_DURATION
	if "frost_chill_duration" in acquired:
		duration += 2.0

	var current = int(target.get_meta("_stance_frost_stacks", 0))
	var new_stacks = min(current + count, max_stacks)

	target.set_meta("_stance_frost_stacks", new_stacks)
	target.set_meta("_stance_frost_until", now + duration)

	_update_chill_visual(target, new_stacks, max_stacks)

	# NOTE: No _flash_sprite_safe here — it fights with the progressive chill tint
	# applied every frame by _apply_chill_slow(). The indicator dots + tint are enough.

	# Check freeze threshold (uncommon: frost_chill_freeze)
	if new_stacks >= max_stacks and "frost_chill_freeze" in acquired:
		var freeze_icd = float(target.get_meta("_stance_freeze_icd", 0.0))
		if now >= freeze_icd:
			_trigger_freeze(target, acquired)

func _remove_chill(target: Node) -> void:
	if not is_instance_valid(target):
		return
	target.set_meta("_stance_frost_stacks", 0)
	target.set_meta("_stance_frost_until", 0.0)
	_restore_speed(target)
	_remove_chill_visual(target)

func _apply_chill_slow(target: Node, stacks: int) -> void:
	if not is_instance_valid(target):
		return

	var acquired = _get_acquired()
	var slow_per = CHILL_SLOW_PER_STACK
	if "frost_chill_slow" in acquired:
		slow_per = CHILL_BOON_SLOW_PER_STACK

	var slow_mult = 1.0 - (float(stacks) * slow_per)
	slow_mult = max(slow_mult, 0.55)
	target.set_meta("_stance_frost_speed_mult", slow_mult)

	# Progressive sprite tint starting from 1 stack
	if ("sprite" in target) and target.sprite != null:
		# Don't fight with freeze tint
		var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
		if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
			return

		if stacks >= 1:
			if not target.has_meta("_stance_frost_chill_tinted"):
				target.set_meta("_stance_frost_chill_tinted", true)
				target.set_meta("_stance_frost_pre_chill_modulate", target.sprite.modulate)
			# t ranges from ~0.2 at 1 stack to 1.0 at max stacks
			var t = float(stacks) / float(CHILL_BASE_MAX_STACKS)
			var tint = Color(1, 1, 1, 1).lerp(CHILL_TINT_COLOR, t * 0.85)
			target.sprite.modulate = tint
		elif target.has_meta("_stance_frost_chill_tinted"):
			target.remove_meta("_stance_frost_chill_tinted")
			if target.has_meta("_stance_frost_pre_chill_modulate"):
				target.sprite.modulate = target.get_meta("_stance_frost_pre_chill_modulate")
				target.remove_meta("_stance_frost_pre_chill_modulate")
				
func _restore_speed(target: Node) -> void:
	if not is_instance_valid(target):
		return
	if target.has_meta("_stance_frost_speed_mult"):
		target.remove_meta("_stance_frost_speed_mult")
	# Clean up chill tint
	if target.has_meta("_stance_frost_chill_tinted"):
		target.remove_meta("_stance_frost_chill_tinted")
		if target.has_meta("_stance_frost_pre_chill_modulate") and ("sprite" in target) and target.sprite != null:
			target.sprite.modulate = target.get_meta("_stance_frost_pre_chill_modulate")
			target.remove_meta("_stance_frost_pre_chill_modulate")
			
# =============================================================================
# FROST — FREEZE
# =============================================================================

func _trigger_freeze(target: Node, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	var now = Time.get_ticks_msec() * 0.001

	# ICD check
	var freeze_icd = float(target.get_meta("_stance_freeze_icd", 0.0))
	if now < freeze_icd:
		return

	var duration = FREEZE_BASE_DURATION
	if "frost_freeze_duration" in acquired:
		duration += 0.3

	# Set freeze state
	target.set_meta("_stance_frozen_until", now + duration)
	target.set_meta("_stance_freeze_icd", now + duration + FREEZE_ICD)

	# Legendary: 2 hits before shatter instead of 1
	var shatter_hits = 2 if "frost_shatter_blast" in acquired else 1
	target.set_meta("_stance_frost_shatter_hits", shatter_hits)

	# Piggyback on enemy stun system to stop movement/attacks
	if "stunned_until" in target:
		target.stunned_until = max(target.stunned_until, now + duration)

	# === INTERRUPT: cancel in-progress attacks cleanly ===
	if target.has_method("freeze_interrupt"):
		target.freeze_interrupt()

	# Clear chill stacks (freeze consumes them)
	target.set_meta("_stance_frost_stacks", 0)
	target.set_meta("_stance_frost_until", 0.0)
	_remove_chill_visual(target)

	# === FREEZE VISUALS: tint + indicator + ice effect ===
	_apply_freeze_tint(target)
	_add_freeze_indicator(target)
	_spawn_freeze_effect(target)

	print("[StanceEffects] FREEZE active on %s for %.1fs" % [target.name, duration])
	
func _shatter_frozen(target: Node, player: Node, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	var hits_left = int(target.get_meta("_stance_frost_shatter_hits", 1))
	hits_left -= 1
	target.set_meta("_stance_frost_shatter_hits", hits_left)

	if hits_left > 0:
		# Still frozen — flash but don't shatter yet
		_flash_sprite_safe(target, SHATTER_COLOR, 0.1)
		return

	# === SHATTER — unfreeze immediately ===
	_end_freeze(target, acquired)
	_spawn_shatter_effect(target)

	# Legendary: AOE chill blast (only on actual shatter)
	if "frost_shatter_blast" in acquired:
		_apply_chill_pulse(target, 2, 100.0)

	# Rare: shatter pulse emits chill to nearby enemies (only on shatter)
	if "frost_shatter_pulse" in acquired:
		_apply_chill_pulse(target, 2, 80.0)

	# Shatter damage boon: posture burst on final shatter hit only
	if "frost_shatter_damage" in acquired:
		_add_posture(target, SHATTER_POSTURE_DAMAGE)
		if DamageNumberManager:
			DamageNumberManager.show_damage_number(
				int(SHATTER_POSTURE_DAMAGE),
				target.global_position + Vector2(randf_range(-8, 8), -30),
				"posture",
				target
			)
			
func _end_freeze(target: Node, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	target.set_meta("_stance_frozen_until", 0.0)
	target.set_meta("_stance_frost_shatter_hits", 0)
	_remove_freeze_tint(target)
	_remove_freeze_indicator(target)

	# Resume animation
	if "anim" in target and target.anim != null:
		if target.has_meta("_stance_frost_saved_anim_speed"):
			target.anim.speed_scale = float(target.get_meta("_stance_frost_saved_anim_speed"))
			target.remove_meta("_stance_frost_saved_anim_speed")
		else:
			target.anim.speed_scale = 1.0

	# Release stun — brief recovery so enemy doesn't snap-attack instantly
	if "stunned_until" in target:
		var now = Time.get_ticks_msec() * 0.001
		target.stunned_until = now + 0.15
		
func _apply_chill_pulse(origin: Node, stacks: int, radius: float) -> void:
	if not is_instance_valid(origin):
		return

	var acquired = _get_acquired()
	for enemy in origin.get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or enemy == origin:
			continue
		if "hp" in enemy and enemy.hp <= 0:
			continue
		if origin.global_position.distance_to(enemy.global_position) <= radius:
			_apply_chill_stacks(enemy, stacks, acquired)

	# Pulse visual (reuse ring visual pattern from Storm)
	_spawn_ring_visual(origin.global_position, radius, origin.get_tree())


# =============================================================================
# FROST VISUALS
# =============================================================================

func _add_freeze_indicator(target: Node) -> void:
	if not is_instance_valid(target):
		return
	# Remove existing if somehow already present
	_remove_freeze_indicator(target)

	var indicator = Node2D.new()
	indicator.name = "StanceFreezeIndicator"
	indicator.z_index = 115
	indicator.position = Vector2(0, -60)
	target.add_child(indicator)

	# Ice crystal / snowflake symbol built from lines
	# Six-pointed star pattern
	var crystal_size = 8.0
	for i in 6:
		var angle = (float(i) / 6.0) * TAU
		var spoke = Line2D.new()
		spoke.width = 2.0
		spoke.default_color = Color(0.6, 0.85, 1.0, 1.0)
		spoke.add_point(Vector2.ZERO)
		spoke.add_point(Vector2(cos(angle), sin(angle)) * crystal_size)
		indicator.add_child(spoke)

		# Small branches on each spoke
		var branch_pos = Vector2(cos(angle), sin(angle)) * crystal_size * 0.55
		for side in [-1, 1]:
			var branch = Line2D.new()
			branch.width = 1.5
			branch.default_color = Color(0.7, 0.9, 1.0, 0.9)
			var branch_angle = angle + side * PI * 0.35
			branch.add_point(branch_pos)
			branch.add_point(branch_pos + Vector2(cos(branch_angle), sin(branch_angle)) * crystal_size * 0.35)
			indicator.add_child(branch)

	# Outer glow circle
	var glow = Line2D.new()
	glow.width = 1.5
	glow.default_color = Color(0.5, 0.75, 1.0, 0.4)
	for i in range(17):
		var angle = (float(i) / 16.0) * TAU
		glow.add_point(Vector2(cos(angle), sin(angle)) * (crystal_size + 3.0))
	indicator.add_child(glow)

	# Gentle bob animation — bound to indicator so it auto-dies on queue_free
	var tw = indicator.create_tween()
	tw.set_loops()
	tw.tween_property(indicator, "position:y", -63.0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(indicator, "position:y", -57.0, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	
func _remove_freeze_indicator(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceFreezeIndicator")
	if indicator:
		indicator.name = "StanceFreezeIndicator_dead"
		indicator.queue_free()
		
func _update_chill_visual(target: Node, stacks: int, _max_stacks: int) -> void:
	if not is_instance_valid(target):
		return

	var indicator = target.get_node_or_null("StanceFrostIndicator")
	if indicator == null:
		indicator = Node2D.new()
		indicator.name = "StanceFrostIndicator"
		indicator.z_index = 110
		indicator.position = Vector2(0, -55)
		target.add_child(indicator)

	for child in indicator.get_children():
		child.queue_free()

	var total_width = (stacks - 1) * 10.0
	var start_x = -total_width * 0.5

	for i in stacks:
		var outline = ColorRect.new()
		outline.size = Vector2(10, 10)
		outline.color = Color(1, 1, 1, 0.8)
		outline.position = Vector2(start_x + i * 10.0 - 5, -5)
		indicator.add_child(outline)
		var dot = ColorRect.new()
		dot.size = Vector2(8, 8)
		dot.color = CHILL_STACK_COLOR
		dot.position = Vector2(start_x + i * 10.0 - 4, -4)
		indicator.add_child(dot)


func _remove_chill_visual(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceFrostIndicator")
	if indicator:
		indicator.name = "StanceFrostIndicator_dead"
		indicator.queue_free()

func _apply_freeze_tint(target: Node) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return

	# Save and apply strong freeze tint
	if not target.has_meta("_stance_frost_pre_freeze_modulate"):
		target.set_meta("_stance_frost_pre_freeze_modulate", target.sprite.modulate)
	target.sprite.modulate = FREEZE_TINT_COLOR

	# Pause animation — this is what makes freeze LOOK frozen
	if "anim" in target and target.anim != null:
		if not target.has_meta("_stance_frost_saved_anim_speed"):
			target.set_meta("_stance_frost_saved_anim_speed", target.anim.speed_scale)
		target.anim.speed_scale = 0.0
		
func _remove_freeze_tint(target: Node) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return

	# Restore sprite color
	if target.has_meta("_stance_frost_pre_freeze_modulate"):
		target.sprite.modulate = target.get_meta("_stance_frost_pre_freeze_modulate")
		target.remove_meta("_stance_frost_pre_freeze_modulate")
	else:
		target.sprite.modulate = Color(1, 1, 1, 1)

	# Clean up chill tint tracking so it doesn't fight with freeze restore
	if target.has_meta("_stance_frost_chill_tinted"):
		target.remove_meta("_stance_frost_chill_tinted")
		target.remove_meta("_stance_frost_pre_chill_modulate")

func _spawn_freeze_effect(target: Node) -> void:
	if not is_instance_valid(target):
		return

	# Ice crystal burst on freeze start
	var burst = Node2D.new()
	burst.global_position = target.global_position
	burst.z_index = 106
	target.get_tree().current_scene.add_child(burst)

	# Ring of ice crystals that expand outward then fade
	for i in 6:
		var crystal = ColorRect.new()
		crystal.size = Vector2(6, 3)
		crystal.position = Vector2(-3, -1.5)
		crystal.color = Color(0.5, 0.75, 1.0, 0.9)
		crystal.rotation = (float(i) / 6.0) * TAU
		burst.add_child(crystal)
		var angle = (float(i) / 6.0) * TAU
		var end_pos = Vector2(cos(angle), sin(angle)) * 25.0
		var tw = burst.get_tree().create_tween()
		tw.set_parallel(true)
		tw.tween_property(crystal, "position", end_pos, 0.15)
		tw.tween_property(crystal, "modulate:a", 0.0, 0.3)

	# Central flash
	var flash = _create_flash_circle(Vector2.ZERO, 18.0, Color(0.5, 0.7, 1.0, 0.8))
	burst.add_child(flash)
	var ftw = burst.get_tree().create_tween()
	ftw.set_parallel(true)
	ftw.tween_property(flash, "scale", Vector2(1.4, 1.4), 0.2)
	ftw.tween_property(flash, "modulate:a", 0.0, 0.2)

	var cleanup = burst.get_tree().create_tween()
	cleanup.tween_interval(0.4)
	cleanup.tween_callback(burst.queue_free)
	
func _spawn_shatter_effect(enemy: Node) -> void:
	if not is_instance_valid(enemy):
		return
	var burst = Node2D.new()
	burst.global_position = enemy.global_position
	burst.z_index = 108
	enemy.get_tree().current_scene.add_child(burst)

	# === Central bright flash ===
	var flash = _create_flash_circle(Vector2.ZERO, 28.0, Color(0.85, 0.95, 1.0, 1.0))
	burst.add_child(flash)
	var ftw = burst.get_tree().create_tween()
	ftw.set_parallel(true)
	ftw.tween_property(flash, "scale", Vector2(2.2, 2.2), 0.3)
	ftw.tween_property(flash, "modulate:a", 0.0, 0.3)

	# === Ice shards — larger, more particles, varied sizes ===
	var shard_count = 14
	for i in shard_count:
		var shard = ColorRect.new()
		var shard_w = randf_range(4, 8)
		var shard_h = randf_range(2, 4)
		shard.size = Vector2(shard_w, shard_h)
		shard.position = Vector2(-shard_w * 0.5, -shard_h * 0.5)
		# Mix of white and light blue shards
		if randf() > 0.5:
			shard.color = Color(0.85, 0.95, 1.0, 1.0)
		else:
			shard.color = SHATTER_COLOR
		shard.rotation = randf() * TAU
		burst.add_child(shard)

		var angle = randf() * TAU
		var dist = randf_range(25, 60)
		var end_pos = Vector2(cos(angle), sin(angle)) * dist
		var tw = burst.get_tree().create_tween()
		tw.set_parallel(true)
		tw.tween_property(shard, "position", end_pos, randf_range(0.25, 0.4))
		tw.tween_property(shard, "rotation", shard.rotation + randf_range(-2.0, 2.0), 0.35)
		tw.tween_property(shard, "modulate:a", 0.0, randf_range(0.3, 0.45))

	# === Expanding ring (reads clearly in top-down) ===
	var ring = Line2D.new()
	ring.width = 3.0
	ring.default_color = Color(0.6, 0.85, 1.0, 0.9)
	for i in range(25):
		var angle = (float(i) / 24.0) * TAU
		ring.add_point(Vector2(cos(angle), sin(angle)) * 8.0)
	burst.add_child(ring)
	var rtw = burst.get_tree().create_tween()
	rtw.set_parallel(true)
	rtw.tween_property(ring, "scale", Vector2(5.0, 5.0), 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	rtw.tween_property(ring, "modulate:a", 0.0, 0.35)
	rtw.tween_property(ring, "width", 1.0, 0.35)

	# Safe cleanup
	var cleanup = burst.get_tree().create_tween()
	cleanup.tween_interval(0.55)
	cleanup.tween_callback(burst.queue_free)

# =============================================================================
# HEX — CURSE STACKS
# =============================================================================

func _apply_curse_stacks(target: Node, count: int, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	var max_stacks = CURSE_BASE_MAX_STACKS
	var current = int(target.get_meta("_stance_hex_curse_stacks", 0))
	var was_max = current >= max_stacks

	var new_stacks = min(current + count, max_stacks)
	target.set_meta("_stance_hex_curse_stacks", new_stacks)

	# Refresh duration
	var duration = CURSE_BASE_DURATION
	if "hex_curse_duration" in acquired:
		duration += 2.0
	target.set_meta("_stance_hex_curse_until", Time.get_ticks_msec() * 0.001 + duration)

	# Update visuals
	_update_curse_visual(target, new_stacks, max_stacks)
	_apply_curse_tint(target, new_stacks, max_stacks)

	# Doom trigger: max stacks reached (not re-triggering if already at max)
	if not was_max and new_stacks >= max_stacks and "hex_doom_1" in acquired:
		_trigger_doom(target, acquired)

	_flash_sprite_safe(target, CURSE_STACK_COLOR, 0.06)


func _remove_curse(target: Node) -> void:
	if not is_instance_valid(target):
		return

	target.set_meta("_stance_hex_curse_stacks", 0)
	target.set_meta("_stance_hex_curse_until", 0.0)
	_remove_curse_visual(target)
	_remove_curse_tint(target)


## Public: returns damage multiplier for incoming attacks FROM this enemy
## Call from player.gd — returns e.g. 0.80 for 20% reduction
func get_curse_damage_mult(attacker: Node) -> float:
	var enemy = _resolve_enemy_body(attacker)
	if enemy == null:
		return 1.0

	var stacks = int(enemy.get_meta("_stance_hex_curse_stacks", 0))
	if stacks <= 0:
		return 1.0

	var acquired = _get_acquired()
	var per_stack = CURSE_ENHANCED_REDUCE_PER_STACK if "hex_curse_stacks" in acquired else CURSE_DMG_REDUCE_PER_STACK
	return max(0.5, 1.0 - per_stack * stacks)

func _resolve_enemy_body(attacker: Node) -> Node:
	if attacker == null or not is_instance_valid(attacker):
		return null
	# If it's the enemy body directly
	if attacker.is_in_group("enemy") or attacker.is_in_group("miniboss"):
		return attacker
	# If it's an attack Area2D, check meta or parent
	if attacker is Area2D:
		if attacker.has_meta("attacker"):
			var a = attacker.get_meta("attacker")
			if is_instance_valid(a):
				return a
		var p = attacker.get_parent()
		if is_instance_valid(p) and (p.is_in_group("enemy") or p.is_in_group("miniboss")):
			return p
	return null


# =============================================================================
# HEX — DOOM
# =============================================================================

func _trigger_doom(target: Node, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	var now = Time.get_ticks_msec() * 0.001

	# ICD check
	var doom_icd = float(target.get_meta("_stance_hex_doom_icd", 0.0))
	if now < doom_icd:
		return

	# Don't re-doom if already doomed
	var existing_doom = float(target.get_meta("_stance_hex_doom_at", 0.0))
	if existing_doom > 0.0:
		return

	var delay = DOOM_BASE_DELAY
	if "hex_doom_delay" in acquired:
		delay -= 0.3
	delay = max(0.4, delay)

	target.set_meta("_stance_hex_doom_at", now + delay)
	target.set_meta("_stance_hex_doom_start", now)
	target.set_meta("_stance_hex_doom_icd", now + delay + DOOM_ICD)

	# Doom visual: deeper tint + overhead indicator
	_add_doom_indicator(target, delay)

	print("[StanceEffects] DOOM applied to %s, detonates in %.1fs" % [target.name, delay])


func _detonate_doom(target: Node, acquired: Array) -> void:
	if not is_instance_valid(target):
		return
	if "hp" in target and target.hp <= 0:
		target.set_meta("_stance_hex_doom_at", 0.0)
		_remove_doom_indicator(target)
		return

	target.set_meta("_stance_hex_doom_at", 0.0)
	target.set_meta("_stance_hex_doom_start", 0.0)
	_remove_doom_indicator(target)

	# Calculate damage
	var doom_damage = DOOM_BASE_DAMAGE
	if "hex_doom_damage" in acquired:
		doom_damage = int(doom_damage * 1.25)

	# Legendary execute: double damage if target at max curse stacks
	if "hex_doom_execute" in acquired:
		var curse_stacks = int(target.get_meta("_stance_hex_curse_stacks", 0))
		if curse_stacks >= CURSE_BASE_MAX_STACKS:
			doom_damage *= 2

	# Apply HP damage directly
	if "hp" in target:
		target.hp -= doom_damage
		if target.hp < 0:
			target.hp = 0

	# Show damage number
	if DamageNumberManager and doom_damage > 0:
		DamageNumberManager.show_damage_number(
			doom_damage,
			target.global_position + Vector2(randf_range(-8, 8), -20),
			"hex",
			target
		)

	# Visual detonation
	_spawn_doom_effect(target)
	_flash_sprite_safe(target, DOOM_DETONATION_COLOR, 0.12)

	# Rare: Doom detonation spreads curse to nearby enemies
	if "hex_doom_spread" in acquired:
		_apply_curse_pulse(target, 2, DOOM_SPREAD_RADIUS, acquired)

	# Legendary: Doom chains to nearby CURSED enemies
	if "hex_doom_chain" in acquired:
		_chain_doom(target, acquired)

	# Legendary execute: reset curse stacks instead of removing them
	if "hex_doom_execute" in acquired:
		var curse_stacks = int(target.get_meta("_stance_hex_curse_stacks", 0))
		if curse_stacks >= CURSE_BASE_MAX_STACKS:
			# Refresh duration but keep stacks
			var duration = CURSE_BASE_DURATION
			if "hex_curse_duration" in acquired:
				duration += 2.0
			target.set_meta("_stance_hex_curse_until", Time.get_ticks_msec() * 0.001 + duration)

	# Check death
	if "hp" in target and target.hp <= 0:
		if target.has_method("death"):
			target.death()

	print("[StanceEffects] DOOM detonated on %s for %d damage" % [target.name, doom_damage])


func _chain_doom(origin: Node, acquired: Array) -> void:
	if not is_instance_valid(origin):
		return
	for enemy in origin.get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or enemy == origin:
			continue
		if "hp" in enemy and enemy.hp <= 0:
			continue
		if origin.global_position.distance_to(enemy.global_position) > DOOM_CHAIN_RADIUS:
			continue
		# Only chain to CURSED enemies
		var stacks = int(enemy.get_meta("_stance_hex_curse_stacks", 0))
		if stacks <= 0:
			continue
		# Once-per-room guard
		if enemy.has_meta("_stance_hex_doom_chained"):
			continue
		enemy.set_meta("_stance_hex_doom_chained", true)
		_trigger_doom(enemy, acquired)


func _apply_curse_pulse(origin: Node, stacks: int, radius: float, acquired: Array) -> void:
	if not is_instance_valid(origin):
		return
	for enemy in origin.get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy) or enemy == origin:
			continue
		if "hp" in enemy and enemy.hp <= 0:
			continue
		if origin.global_position.distance_to(enemy.global_position) <= radius:
			_apply_curse_stacks(enemy, stacks, acquired)
	# Ring visual
	_spawn_hex_ring_visual(origin.global_position, radius, origin.get_tree())


# =============================================================================
# HEX — VISUALS
# =============================================================================

func _update_curse_visual(target: Node, stacks: int, max_stacks: int) -> void:
	if not is_instance_valid(target):
		return

	var indicator = target.get_node_or_null("StanceCurseIndicator")
	if indicator == null:
		indicator = Node2D.new()
		indicator.name = "StanceCurseIndicator"
		indicator.z_index = 100
		indicator.position = Vector2(0, -50)
		target.add_child(indicator)

	# Clear old dots
	for c in indicator.get_children():
		c.queue_free()

	# Draw stack dots (purple)
	var total_w = (stacks - 1) * 7.0
	var start_x = -total_w * 0.5
	for i in stacks:
		var dot = ColorRect.new()
		dot.size = Vector2(5, 5)
		dot.color = CURSE_STACK_COLOR
		dot.position = Vector2(start_x + i * 7.0 - 2.5, -2.5)
		indicator.add_child(dot)


func _remove_curse_visual(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceCurseIndicator")
	if indicator:
		indicator.name = "StanceCurseIndicator_dead"
		indicator.queue_free()


func _apply_curse_tint(target: Node, stacks: int, max_stacks: int) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return

	# Don't override freeze tint
	var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
	if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
		return

	if stacks >= 1:
		if not target.has_meta("_stance_hex_pre_curse_modulate"):
			target.set_meta("_stance_hex_pre_curse_modulate", target.sprite.modulate)
		var t = float(stacks) / float(max_stacks)
		var tint = Color(1, 1, 1, 1).lerp(CURSE_TINT_COLOR, t * 0.75)
		target.sprite.modulate = tint


func _remove_curse_tint(target: Node) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return
	if target.has_meta("_stance_hex_pre_curse_modulate"):
		target.sprite.modulate = target.get_meta("_stance_hex_pre_curse_modulate")
		target.remove_meta("_stance_hex_pre_curse_modulate")


func _add_doom_indicator(target: Node, delay: float) -> void:
	if not is_instance_valid(target):
		return
	_remove_doom_indicator(target)

	var indicator = Node2D.new()
	indicator.name = "StanceDoomIndicator"
	indicator.z_index = 116
	indicator.position = Vector2(0, -65)
	target.add_child(indicator)

	# Skull-like hex symbol: diamond with inner cross
	var diamond = Line2D.new()
	diamond.width = 2.0
	diamond.default_color = DOOM_DETONATION_COLOR
	var s = 7.0
	diamond.add_point(Vector2(0, -s))
	diamond.add_point(Vector2(s, 0))
	diamond.add_point(Vector2(0, s))
	diamond.add_point(Vector2(-s, 0))
	diamond.add_point(Vector2(0, -s))
	indicator.add_child(diamond)

	# Inner cross
	var cross_h = Line2D.new()
	cross_h.width = 1.5
	cross_h.default_color = DOOM_DETONATION_COLOR
	cross_h.add_point(Vector2(-4, 0))
	cross_h.add_point(Vector2(4, 0))
	indicator.add_child(cross_h)

	var cross_v = Line2D.new()
	cross_v.width = 1.5
	cross_v.default_color = DOOM_DETONATION_COLOR
	cross_v.add_point(Vector2(0, -4))
	cross_v.add_point(Vector2(0, 4))
	indicator.add_child(cross_v)

	# Pulsing glow ring
	var glow = Line2D.new()
	glow.name = "DoomGlow"
	glow.width = 1.5
	glow.default_color = Color(0.8, 0.3, 1.0, 0.5)
	for i in range(17):
		var angle = (float(i) / 16.0) * TAU
		glow.add_point(Vector2(cos(angle), sin(angle)) * (s + 3.0))
	indicator.add_child(glow)


func _update_doom_pulse(target: Node, progress: float) -> void:
	# progress: 0.0 at start → 1.0 at detonation
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceDoomIndicator")
	if indicator == null:
		return

	# Pulse speed increases as detonation approaches
	var pulse_speed = lerp(2.0, 10.0, progress * progress)
	var pulse = (sin(Time.get_ticks_msec() * 0.001 * pulse_speed) + 1.0) * 0.5
	var alpha = lerp(0.5, 1.0, pulse)
	indicator.modulate = Color(1.0, 1.0, 1.0, alpha)

	# Scale up slightly as it approaches detonation
	var s = lerp(1.0, 1.25, progress)
	indicator.scale = Vector2(s, s)

	# Also apply doom tint to sprite (deepening purple)
	if ("sprite" in target) and target.sprite != null:
		# Don't override freeze tint
		var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
		if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
			return
		var tint = CURSE_TINT_COLOR.lerp(DOOM_TINT_COLOR, progress * 0.6)
		target.sprite.modulate = tint


func _remove_doom_indicator(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceDoomIndicator")
	if indicator:
		indicator.name = "StanceDoomIndicator_dead"
		indicator.queue_free()


func _spawn_doom_effect(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var burst = Node2D.new()
	burst.global_position = target.global_position
	burst.z_index = 108
	target.get_tree().current_scene.add_child(burst)

	# Central flash
	var flash = _create_flash_circle(Vector2.ZERO, 24.0, DOOM_DETONATION_COLOR)
	burst.add_child(flash)
	var ftw = burst.get_tree().create_tween()
	ftw.set_parallel(true)
	ftw.tween_property(flash, "scale", Vector2(2.0, 2.0), 0.3)
	ftw.tween_property(flash, "modulate:a", 0.0, 0.3)

	# Dark purple particles radiating outward
	var particle_count = 10
	for i in particle_count:
		var p = ColorRect.new()
		var pw = randf_range(4, 7)
		var ph = randf_range(3, 5)
		p.size = Vector2(pw, ph)
		p.position = Vector2(-pw * 0.5, -ph * 0.5)
		if randf() > 0.4:
			p.color = DOOM_DETONATION_COLOR
		else:
			p.color = Color(0.4, 0.15, 0.5, 1.0)
		p.rotation = randf() * TAU
		burst.add_child(p)

		var angle = randf() * TAU
		var dist = randf_range(20, 50)
		var end_pos = Vector2(cos(angle), sin(angle)) * dist
		var tw = burst.get_tree().create_tween()
		tw.set_parallel(true)
		tw.tween_property(p, "position", end_pos, randf_range(0.2, 0.35))
		tw.tween_property(p, "rotation", p.rotation + randf_range(-2.0, 2.0), 0.3)
		tw.tween_property(p, "modulate:a", 0.0, randf_range(0.25, 0.4))

	# Expanding ring
	var ring = Line2D.new()
	ring.width = 3.0
	ring.default_color = Color(0.7, 0.25, 0.9, 0.9)
	for i in range(25):
		var angle = (float(i) / 24.0) * TAU
		ring.add_point(Vector2(cos(angle), sin(angle)) * 8.0)
	burst.add_child(ring)
	var rtw = burst.get_tree().create_tween()
	rtw.set_parallel(true)
	rtw.tween_property(ring, "scale", Vector2(4.5, 4.5), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	rtw.tween_property(ring, "modulate:a", 0.0, 0.3)
	rtw.tween_property(ring, "width", 1.0, 0.3)

	# Cleanup
	var cleanup = burst.get_tree().create_tween()
	cleanup.tween_interval(0.5)
	cleanup.tween_callback(burst.queue_free)


func _spawn_hex_ring_visual(center: Vector2, radius: float, tree: SceneTree) -> void:
	var ring = Node2D.new()
	ring.global_position = center
	ring.z_index = 100
	tree.current_scene.add_child(ring)
	var line = Line2D.new()
	line.width = 2.5
	line.default_color = CURSE_STACK_COLOR
	for i in range(25):
		var angle = (float(i) / 24.0) * TAU
		line.add_point(Vector2(cos(angle), sin(angle)) * radius)
	ring.add_child(line)
	var tw = tree.create_tween()
	tw.set_parallel(true)
	tw.tween_property(ring, "scale", Vector2(1.3, 1.3), 0.2)
	tw.tween_property(line, "modulate:a", 0.0, 0.2)
	tw.chain().tween_callback(ring.queue_free)

## Called from player._end_dodge() — spawns one scorch zone at dash landing point
func on_player_dash(player_pos: Vector2) -> void:
	var acquired = _get_acquired()
	var now = Time.get_ticks_msec() * 0.001

	# === EMBER: Scorch zone at dash landing ===
	if "ember_scorch_1" in acquired:
		var last_dash = float(get_meta("_stance_ember_dash_icd", 0.0))
		if now >= last_dash:
			set_meta("_stance_ember_dash_icd", now + SCORCH_DASH_ICD)
			_spawn_scorch_zone(player_pos, acquired, true)

	# === SHADOW: Dash consume — consume NEAREST marked enemy along dash path ===
	if "shadow_dash_consume" in acquired and "shadow_expose_1" in acquired and "shadow_mark_1" in acquired:
		var player = get_tree().get_first_node_in_group("player")
		if is_instance_valid(player):
			var best_enemy = null
			var best_dist = SHADOW_DASH_CONSUME_RADIUS
			for enemy in get_tree().get_nodes_in_group("enemy"):
				if not is_instance_valid(enemy):
					continue
				if "hp" in enemy and enemy.hp <= 0:
					continue
				var mark_until = float(enemy.get_meta("_stance_shadow_mark_until", 0.0))
				if mark_until <= 0.0 or now >= mark_until:
					continue
				var dist = player_pos.distance_to(enemy.global_position)
				if dist < best_dist:
					best_dist = dist
					best_enemy = enemy
			if best_enemy != null:
				_consume_mark(best_enemy, player, acquired)
					
## Called from CombatController._posture_passive_recover()
## Returns 1.0 normally, reduced when burning at Intensity 3
func get_burn_posture_recovery_mult(enemy: Node) -> float:
	if enemy == null or not is_instance_valid(enemy):
		return 1.0
	var intensity = int(enemy.get_meta("_stance_ember_burn_intensity", 0))
	if intensity < 3:
		return 1.0
	return BURN_I3_POSTURE_RECOVERY_MULT

# =============================================================================
# EMBER — BURN
# =============================================================================

func _apply_burn(target: Node, acquired: Array) -> void:
	if not is_instance_valid(target):
		return

	var now = Time.get_ticks_msec() * 0.001
	var duration = BURN_BASE_DURATION
	if "ember_burn_duration" in acquired:
		duration += 2.0

	# Determine max intensity this player can apply
	var intensity = 1
	if "ember_burn_tick" in acquired:
		intensity = 2
	# Intensity 3 is only possible via scorch amp + being in scorch
	# (handled in _tick_burn, not at application time)

	var current_intensity = int(target.get_meta("_stance_ember_burn_intensity", 0))
	# Refresh duration always; upgrade intensity if new is higher
	var final_intensity = max(current_intensity, intensity)
	# But cap at 2 on application — 3 is only from scorch amp
	final_intensity = min(final_intensity, 2)

	target.set_meta("_stance_ember_burn_until", now + duration)
	target.set_meta("_stance_ember_burn_intensity", final_intensity)

	# Init tick timer if not already burning
	if current_intensity <= 0:
		target.set_meta("_stance_ember_burn_next_tick", now + BURN_TICK_INTERVAL)

	_update_burn_visual(target, final_intensity)
	_apply_burn_tint(target, final_intensity)


func _tick_burn(target: Node, now: float) -> void:
	if not is_instance_valid(target):
		return

	var next_tick = float(target.get_meta("_stance_ember_burn_next_tick", 0.0))
	if now < next_tick:
		return

	target.set_meta("_stance_ember_burn_next_tick", now + BURN_TICK_INTERVAL)

	var acquired = _get_acquired()
	var intensity = int(target.get_meta("_stance_ember_burn_intensity", 1))

	# Scorch amp: boost to Intensity 3 while in scorch (requires both boons)
	var in_scorch = bool(target.get_meta("_stance_ember_in_scorch", false))
	if in_scorch and "ember_burn_scorch_amp" in acquired and "ember_burn_tick" in acquired:
		intensity = 3
		target.set_meta("_stance_ember_burn_intensity", 3)
		_update_burn_visual(target, 3)
		_apply_burn_tint(target, 3)
	elif not in_scorch and intensity >= 3:
		# Revert to base max intensity when leaving scorch
		var base_intensity = 2 if "ember_burn_tick" in acquired else 1
		target.set_meta("_stance_ember_burn_intensity", base_intensity)
		_update_burn_visual(target, base_intensity)
		_apply_burn_tint(target, base_intensity)

	# Calculate tick damage
	var tick_dmg = BURN_I1_DMG
	if intensity >= 3:
		tick_dmg = BURN_I3_DMG
	elif intensity >= 2:
		tick_dmg = BURN_I2_DMG

	# Apply HP damage
	if "hp" in target and tick_dmg > 0:
		target.hp -= tick_dmg
		if target.hp < 0:
			target.hp = 0

	if DamageNumberManager and tick_dmg > 0:
		DamageNumberManager.show_damage_number(
			tick_dmg,
			target.global_position + Vector2(randf_range(-8, 8), -20),
			"burn",
			target
		)

	if "hp" in target and target.hp <= 0 and target.has_method("death"):
		target.death()


func _remove_burn(target: Node) -> void:
	if not is_instance_valid(target):
		return
	target.set_meta("_stance_ember_burn_until", 0.0)
	target.set_meta("_stance_ember_burn_intensity", 0)
	target.set_meta("_stance_ember_burn_next_tick", 0.0)
	target.set_meta("_stance_ember_in_scorch", false)
	_remove_burn_visual(target)
	_remove_burn_tint(target)

# =============================================================================
# EMBER — SCORCH ZONES
# =============================================================================

func _spawn_scorch_zone(pos: Vector2, acquired: Array, is_trail: bool) -> void:
	var tree = get_tree()
	if tree == null or tree.current_scene == null:
		return

	var radius = SCORCH_BASE_RADIUS
	if "ember_scorch_size" in acquired:
		radius *= 1.25

	var lifetime = SCORCH_TRAIL_LIFETIME if is_trail else SCORCH_BASE_LIFETIME
	if not is_trail and "ember_scorch_duration" in acquired:
		lifetime += 2.0

	var now = Time.get_ticks_msec() * 0.001

	# Enforce zone cap — fade out oldest
	while _active_scorch_zones.size() >= SCORCH_ZONE_CAP:
		var oldest = _active_scorch_zones[0]
		_active_scorch_zones.remove_at(0)
		if is_instance_valid(oldest):
			_fadeout_scorch_zone(oldest)

	# Create zone node
	var zone = Node2D.new()
	zone.global_position = pos
	zone.z_index = 5  # Below characters
	zone.set_meta("_scorch_radius", radius)
	zone.set_meta("_scorch_dies_at", now + lifetime)
	zone.set_meta("_scorch_chip_next", now + SCORCH_CHIP_INTERVAL)
	zone.set_meta("_scorch_fading", false)
	tree.current_scene.add_child(zone)

	# Visual: ground circle
	_build_scorch_visual(zone, radius)

	_active_scorch_zones.append(zone)


func _manage_scorch_zones(_delta: float) -> void:
	var now = Time.get_ticks_msec() * 0.001
	var acquired = _get_acquired()
	var zones_to_remove: Array = []

	for zone in _active_scorch_zones:
		if not is_instance_valid(zone):
			zones_to_remove.append(zone)
			continue

		if bool(zone.get_meta("_scorch_fading", false)):
			continue

		var dies_at = float(zone.get_meta("_scorch_dies_at", 0.0))
		if now >= dies_at:
			# Eruption legendary: burst damage on expiry
			if "ember_scorch_eruption" in acquired:
				_eruption_at_zone(zone)
			_fadeout_scorch_zone(zone)
			zones_to_remove.append(zone)
			continue

		# Chip damage + burn application to enemies inside
		var chip_next = float(zone.get_meta("_scorch_chip_next", 0.0))
		if now >= chip_next:
			zone.set_meta("_scorch_chip_next", now + SCORCH_CHIP_INTERVAL)
			var radius = float(zone.get_meta("_scorch_radius", SCORCH_BASE_RADIUS))
			_scorch_zone_tick(zone, radius, acquired)

	for z in zones_to_remove:
		_active_scorch_zones.erase(z)


func _scorch_zone_tick(zone: Node2D, radius: float, acquired: Array) -> void:
	for enemy in zone.get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		if "hp" in enemy and enemy.hp <= 0:
			continue
		if zone.global_position.distance_to(enemy.global_position) > radius:
			continue

		# Chip damage
		if SCORCH_CHIP_DMG > 0 and "hp" in enemy:
			enemy.hp -= SCORCH_CHIP_DMG
			if enemy.hp < 0:
				enemy.hp = 0
			if DamageNumberManager:
				DamageNumberManager.show_damage_number(
					SCORCH_CHIP_DMG,
					enemy.global_position + Vector2(randf_range(-6, 6), -15),
					"burn",
					enemy
				)

		# Apply/refresh burn if ember_burn_1 owned
		if "ember_burn_1" in acquired:
			_apply_burn(enemy, acquired)

		# Death check
		if "hp" in enemy and enemy.hp <= 0 and enemy.has_method("death"):
			enemy.death()


func _is_in_scorch_zone(target: Node) -> bool:
	if not is_instance_valid(target):
		return false
	for zone in _active_scorch_zones:
		if not is_instance_valid(zone):
			continue
		if bool(zone.get_meta("_scorch_fading", false)):
			continue
		var radius = float(zone.get_meta("_scorch_radius", SCORCH_BASE_RADIUS))
		if zone.global_position.distance_to(target.global_position) <= radius:
			return true
	return false

func _build_scorch_visual(zone: Node2D, radius: float) -> void:
	# Filled ground circle (multiple rings for depth)
	for r in [0.3, 0.6, 0.85, 1.0]:
		var ring = Line2D.new()
		ring.width = 2.5 if r >= 0.85 else 1.5
		var col = SCORCH_ZONE_EDGE_COLOR if r >= 0.85 else SCORCH_ZONE_COLOR
		ring.default_color = col
		var seg = 20
		for i in range(seg + 1):
			var angle = (float(i) / float(seg)) * TAU
			ring.add_point(Vector2(cos(angle), sin(angle)) * radius * r)
		zone.add_child(ring)

	# Small ember particles (static decorative dots)
	for i in 5:
		var ember = ColorRect.new()
		ember.size = Vector2(3, 3)
		var angle = randf() * TAU
		var dist = randf_range(0.2, 0.8) * radius
		ember.position = Vector2(cos(angle), sin(angle)) * dist - Vector2(1.5, 1.5)
		ember.color = Color(1.0, 0.6, 0.2, 0.6)
		zone.add_child(ember)

	# Gentle flicker animation — store reference so we can kill it on fadeout
	var tw = zone.create_tween()
	tw.set_loops()
	tw.tween_property(zone, "modulate:a", 0.7, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(zone, "modulate:a", 1.0, 0.4).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	zone.set_meta("_scorch_flicker_tween", tw)


func _fadeout_scorch_zone(zone: Node2D) -> void:
	if not is_instance_valid(zone):
		return
	zone.set_meta("_scorch_fading", true)
	# Kill the infinite flicker tween first
	if zone.has_meta("_scorch_flicker_tween"):
		var flicker = zone.get_meta("_scorch_flicker_tween")
		if flicker is Tween and flicker.is_valid():
			flicker.kill()
		zone.remove_meta("_scorch_flicker_tween")
	# Now fade out cleanly
	zone.modulate.a = 1.0
	var tw = zone.get_tree().create_tween()
	tw.tween_property(zone, "modulate:a", 0.0, SCORCH_FADEOUT_TIME)
	tw.tween_callback(zone.queue_free)
	
func _eruption_at_zone(zone: Node2D) -> void:
	if not is_instance_valid(zone):
		return
	var radius = float(zone.get_meta("_scorch_radius", SCORCH_BASE_RADIUS))
	var pos = zone.global_position

	# Damage enemies inside
	for enemy in zone.get_tree().get_nodes_in_group("enemy"):
		if not is_instance_valid(enemy):
			continue
		if "hp" in enemy and enemy.hp <= 0:
			continue
		if pos.distance_to(enemy.global_position) > radius:
			continue

		if "hp" in enemy:
			enemy.hp -= ERUPTION_DAMAGE
			if enemy.hp < 0:
				enemy.hp = 0
		if DamageNumberManager:
			DamageNumberManager.show_damage_number(
				ERUPTION_DAMAGE,
				enemy.global_position + Vector2(randf_range(-8, 8), -25),
				"burn",
				enemy
			)
		_flash_sprite_safe(enemy, ERUPTION_COLOR, 0.12)
		if "hp" in enemy and enemy.hp <= 0 and enemy.has_method("death"):
			enemy.death()

	# Eruption visual
	_spawn_eruption_effect(pos, radius, zone.get_tree())

# =============================================================================
# EMBER — VISUALS
# =============================================================================

func _update_burn_visual(target: Node, intensity: int) -> void:
	if not is_instance_valid(target):
		return

	var indicator = target.get_node_or_null("StanceBurnIndicator")
	if indicator == null:
		indicator = Node2D.new()
		indicator.name = "StanceBurnIndicator"
		indicator.z_index = 110
		indicator.position = Vector2(0, -50)
		target.add_child(indicator)

	# Clear old
	for c in indicator.get_children():
		c.queue_free()

	# Flame icons: small upward triangles, count = intensity
	var total_w = (intensity - 1) * 10.0
	var start_x = -total_w * 0.5
	for i in intensity:
		# Triangle flame shape using Line2D
		var flame = Line2D.new()
		flame.width = 2.0
		var col = BURN_INDICATOR_COLOR if intensity < 3 else ERUPTION_COLOR
		flame.default_color = col
		var cx = start_x + i * 10.0
		flame.add_point(Vector2(cx - 3, 3))
		flame.add_point(Vector2(cx, -5))
		flame.add_point(Vector2(cx + 3, 3))
		indicator.add_child(flame)

	# Bob animation
	if indicator.get_meta("_has_bob", false) == false:
		indicator.set_meta("_has_bob", true)
		var tw = indicator.create_tween()
		tw.set_loops()
		tw.tween_property(indicator, "position:y", -53.0, 0.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
		tw.tween_property(indicator, "position:y", -47.0, 0.35).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _remove_burn_visual(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceBurnIndicator")
	if indicator:
		indicator.name = "StanceBurnIndicator_dead"
		indicator.queue_free()


func _apply_burn_tint(target: Node, intensity: int) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return

	# Don't override freeze tint
	var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
	if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
		return

	if intensity >= 1:
		if not target.has_meta("_stance_ember_pre_burn_modulate"):
			target.set_meta("_stance_ember_pre_burn_modulate", target.sprite.modulate)
		var t = float(intensity) / 3.0
		var tint_color = BURN_TINT_COLOR if intensity < 3 else BURN_I3_TINT_COLOR
		var tint = Color(1, 1, 1, 1).lerp(tint_color, t * 0.65)
		target.sprite.modulate = tint


func _remove_burn_tint(target: Node) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return
	if target.has_meta("_stance_ember_pre_burn_modulate"):
		target.sprite.modulate = target.get_meta("_stance_ember_pre_burn_modulate")
		target.remove_meta("_stance_ember_pre_burn_modulate")


func _spawn_eruption_effect(pos: Vector2, radius: float, tree: SceneTree) -> void:
	var burst = Node2D.new()
	burst.global_position = pos
	burst.z_index = 108
	tree.current_scene.add_child(burst)

	# Central flash
	var flash = _create_flash_circle(Vector2.ZERO, radius * 0.6, ERUPTION_COLOR)
	burst.add_child(flash)
	var ftw = tree.create_tween()
	ftw.set_parallel(true)
	ftw.tween_property(flash, "scale", Vector2(2.0, 2.0), 0.3)
	ftw.tween_property(flash, "modulate:a", 0.0, 0.3)

	# Fire particles
	for i in 12:
		var p = ColorRect.new()
		var pw = randf_range(4, 7)
		var ph = randf_range(3, 5)
		p.size = Vector2(pw, ph)
		p.position = Vector2(-pw * 0.5, -ph * 0.5)
		p.color = ERUPTION_COLOR if randf() > 0.4 else Color(1.0, 0.7, 0.2, 1.0)
		p.rotation = randf() * TAU
		burst.add_child(p)

		var angle = randf() * TAU
		var dist = randf_range(radius * 0.3, radius * 1.2)
		var end_pos = Vector2(cos(angle), sin(angle)) * dist
		var tw = tree.create_tween()
		tw.set_parallel(true)
		tw.tween_property(p, "position", end_pos, randf_range(0.2, 0.35))
		tw.tween_property(p, "modulate:a", 0.0, randf_range(0.25, 0.4))

	# Expanding ring
	var ring = Line2D.new()
	ring.width = 3.0
	ring.default_color = Color(1.0, 0.45, 0.1, 0.9)
	for i in range(25):
		var angle = (float(i) / 24.0) * TAU
		ring.add_point(Vector2(cos(angle), sin(angle)) * radius * 0.4)
	burst.add_child(ring)
	var rtw = tree.create_tween()
	rtw.set_parallel(true)
	rtw.tween_property(ring, "scale", Vector2(3.0, 3.0), 0.3).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	rtw.tween_property(ring, "modulate:a", 0.0, 0.3)

	var cleanup = tree.create_tween()
	cleanup.tween_interval(0.5)
	cleanup.tween_callback(burst.queue_free)

# =============================================================================
# SHADOW — MARK
# =============================================================================

func _try_apply_mark(target: Node, player: Node, chance: float, acquired: Array) -> void:
	if not is_instance_valid(target) or not is_instance_valid(player):
		return
	if randf() > chance:
		return
	var now = Time.get_ticks_msec() * 0.001

	# Already marked? Just refresh duration
	var existing_mark = float(target.get_meta("_stance_shadow_mark_until", 0.0))
	if existing_mark > 0.0 and now < existing_mark:
		var duration = MARK_BASE_DURATION
		if "shadow_mark_duration" in acquired:
			duration += 3.0
		if "shadow_mark_cap" in acquired:
			duration += 2.0
		target.set_meta("_stance_shadow_mark_until", now + duration)
		return

	# Global mark-apply ICD (stored on player)
	var icd_until = float(player.get_meta("_stance_shadow_mark_icd", 0.0))
	if now < icd_until:
		return

	# Apply mark — no cap, any number of enemies can be marked
	var duration = MARK_BASE_DURATION
	if "shadow_mark_duration" in acquired:
		duration += 3.0
	if "shadow_mark_cap" in acquired:
		duration += 2.0
	target.set_meta("_stance_shadow_mark_until", now + duration)

	var icd = MARK_APPLY_ICD
	if "shadow_mark_cap" in acquired:
		icd *= 0.6  # 40% reduced cooldown
	player.set_meta("_stance_shadow_mark_icd", now + icd)

	_update_mark_visual(target)
	_flash_sprite_safe(target, MARK_ICON_COLOR, 0.08)

	print("[StanceEffects] MARK applied to %s" % target.name)
	
func _remove_mark(target: Node) -> void:
	if not is_instance_valid(target):
		return
	target.set_meta("_stance_shadow_mark_until", 0.0)
	_remove_mark_visual(target)


# =============================================================================
# SHADOW — CONSUME / EXPOSE / SHADOW CHARGE
# =============================================================================

func _consume_mark(target: Node, player: Node, acquired: Array) -> void:
	if not is_instance_valid(target) or not is_instance_valid(player):
		return

	# Remove the mark
	_remove_mark(target)

	# Apply Expose to the consumed enemy
	var expose_dur = EXPOSE_BASE_DURATION
	target.set_meta("_stance_shadow_expose_until", Time.get_ticks_msec() * 0.001 + expose_dur)
	_apply_expose_tint(target)

	# Grant Shadow Charge to the player
	var charge_dur = SHADOW_CHARGE_DURATION
	if "shadow_expose_window" in acquired:
		charge_dur = SHADOW_CHARGE_ENHANCED_DURATION
	player.set_meta("_stance_shadow_charge_until", Time.get_ticks_msec() * 0.001 + charge_dur)

	# Visuals
	_spawn_consume_effect(target)
	_update_shadow_charge_visual(player, true)

	print("[StanceEffects] MARK consumed on %s → Expose + Shadow Charge" % target.name)


func _has_shadow_charge(player: Node) -> bool:
	if not is_instance_valid(player):
		return false
	var until = float(player.get_meta("_stance_shadow_charge_until", 0.0))
	return Time.get_ticks_msec() * 0.001 < until

func _schedule_afterimage(target: Node, player: Node, acquired: Array) -> void:
	if not is_instance_valid(target) or not is_instance_valid(player):
		return

	# Consume the charge immediately (so it can't double-fire)
	player.set_meta("_stance_shadow_charge_until", 0.0)
	_update_shadow_charge_visual(player, false)

	# Store pending afterimage as metadata on self (the autoload) — processed in _process()
	var fire_at = Time.get_ticks_msec() * 0.001 + AFTERIMAGE_DELAY
	set_meta("_pending_afterimage", {
		"target_id": target.get_instance_id(),
		"player_id": player.get_instance_id(),
		"acquired": acquired.duplicate(),
		"fire_at": fire_at
	})
	
func _consume_shadow_charge(target: Node, player: Node, acquired: Array) -> void:
	# This is called by _process_pending_afterimage — the actual afterimage strike
	if not is_instance_valid(target) or not is_instance_valid(player):
		return
	if "hp" in target and target.hp <= 0:
		return

	# Deal afterimage damage — phantom strike IGNORES block
	var hp_dmg = AFTERIMAGE_HP_DAMAGE
	var posture_dmg = AFTERIMAGE_POSTURE_DAMAGE

	if "hp" in target:
		target.hp -= hp_dmg
		if target.hp < 0:
			target.hp = 0
	_add_posture(target, posture_dmg)

	if DamageNumberManager and hp_dmg > 0:
		DamageNumberManager.show_damage_number(
			hp_dmg,
			target.global_position + Vector2(randf_range(-8, 8), -30),
			"shadow",
			target
		)

	# Afterimage visual
	_spawn_afterimage_effect(target, player)
	_flash_sprite_safe(target, AFTERIMAGE_COLOR, 0.1)

	# Legendary: afterimage can apply mark
	if "shadow_afterimage_chain" in acquired and "shadow_mark_1" in acquired:
		_try_apply_mark(target, player, 0.5, acquired)

	# Death check
	if "hp" in target and target.hp <= 0 and target.has_method("death"):
		target.death()

	print("[StanceEffects] AFTERIMAGE hit %s for %d HP + %.0f posture (ignores block)" % [target.name, hp_dmg, posture_dmg])
	
func _remove_expose(target: Node) -> void:
	if not is_instance_valid(target):
		return
	target.set_meta("_stance_shadow_expose_until", 0.0)
	_remove_expose_tint(target)


# =============================================================================
# SHADOW — VISUALS
# =============================================================================

func _update_mark_visual(target: Node) -> void:
	if not is_instance_valid(target):
		return

	# Remove existing if present
	_remove_mark_visual(target)

	var indicator = Node2D.new()
	indicator.name = "StanceShadowMarkIndicator"
	indicator.z_index = 112
	indicator.position = Vector2(0, -55)
	target.add_child(indicator)

	# Eye/diamond mark icon
	var diamond = Line2D.new()
	diamond.width = 2.0
	diamond.default_color = MARK_ICON_COLOR
	var s = 6.0
	diamond.add_point(Vector2(0, -s))
	diamond.add_point(Vector2(s * 0.7, 0))
	diamond.add_point(Vector2(0, s * 0.5))
	diamond.add_point(Vector2(-s * 0.7, 0))
	diamond.add_point(Vector2(0, -s))
	indicator.add_child(diamond)

	# Inner pupil dot
	var pupil = ColorRect.new()
	pupil.size = Vector2(4, 4)
	pupil.position = Vector2(-2, -2)
	pupil.color = Color(1.0, 1.0, 1.0, 0.9)
	indicator.add_child(pupil)

	# Subtle pulse
	var tw = indicator.create_tween()
	tw.set_loops()
	tw.tween_property(indicator, "modulate:a", 0.6, 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(indicator, "modulate:a", 1.0, 0.6).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _remove_mark_visual(target: Node) -> void:
	if not is_instance_valid(target):
		return
	var indicator = target.get_node_or_null("StanceShadowMarkIndicator")
	if indicator:
		indicator.name = "StanceShadowMarkIndicator_dead"
		indicator.queue_free()


func _apply_expose_tint(target: Node) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return

	# Don't override freeze tint
	var frozen_until = float(target.get_meta("_stance_frozen_until", 0.0))
	if frozen_until > 0.0 and Time.get_ticks_msec() * 0.001 < frozen_until:
		return

	if not target.has_meta("_stance_shadow_pre_expose_modulate"):
		target.set_meta("_stance_shadow_pre_expose_modulate", target.sprite.modulate)
	target.sprite.modulate = EXPOSE_TINT_COLOR


func _remove_expose_tint(target: Node) -> void:
	if not is_instance_valid(target):
		return
	if not ("sprite" in target) or target.sprite == null:
		return
	if target.has_meta("_stance_shadow_pre_expose_modulate"):
		target.sprite.modulate = target.get_meta("_stance_shadow_pre_expose_modulate")
		target.remove_meta("_stance_shadow_pre_expose_modulate")


func _update_shadow_charge_visual(player: Node, active: bool) -> void:
	if not is_instance_valid(player):
		return

	var indicator = player.get_node_or_null("StanceShadowChargeIndicator")
	if not active:
		if indicator:
			indicator.name = "StanceShadowChargeIndicator_dead"
			indicator.queue_free()
		return

	if indicator != null:
		return  # Already showing

	indicator = Node2D.new()
	indicator.name = "StanceShadowChargeIndicator"
	indicator.z_index = 110
	indicator.position = Vector2(0, -45)
	player.add_child(indicator)

	# Shadow charge icon: two diagonal slash lines
	var slash1 = Line2D.new()
	slash1.width = 2.5
	slash1.default_color = SHADOW_CHARGE_COLOR
	slash1.add_point(Vector2(-5, 4))
	slash1.add_point(Vector2(5, -4))
	indicator.add_child(slash1)

	var slash2 = Line2D.new()
	slash2.width = 2.5
	slash2.default_color = SHADOW_CHARGE_COLOR
	slash2.add_point(Vector2(-3, 6))
	slash2.add_point(Vector2(7, -2))
	indicator.add_child(slash2)

	# Pulsing glow
	var tw = indicator.create_tween()
	tw.set_loops()
	tw.tween_property(indicator, "modulate:a", 0.5, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tw.tween_property(indicator, "modulate:a", 1.0, 0.3).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _spawn_consume_effect(target: Node) -> void:
	if not is_instance_valid(target):
		return

	var burst = Node2D.new()
	burst.global_position = target.global_position
	burst.z_index = 107
	target.get_tree().current_scene.add_child(burst)

	# Inward implosion: particles converge then burst outward
	var particle_count = 8
	for i in particle_count:
		var p = ColorRect.new()
		p.size = Vector2(4, 4)
		p.color = MARK_ICON_COLOR
		var angle = (float(i) / float(particle_count)) * TAU
		var start_pos = Vector2(cos(angle), sin(angle)) * 30.0
		p.position = start_pos - Vector2(2, 2)
		burst.add_child(p)

		var tw = burst.get_tree().create_tween()
		tw.tween_property(p, "position", Vector2(-2, -2), 0.12)
		tw.tween_property(p, "position", Vector2(cos(angle), sin(angle)) * 15.0, 0.15)
		tw.parallel().tween_property(p, "modulate:a", 0.0, 0.15)

	# Central flash
	var flash = _create_flash_circle(Vector2.ZERO, 16.0, SHADOW_CHARGE_COLOR)
	burst.add_child(flash)
	var ftw = burst.get_tree().create_tween()
	ftw.set_parallel(true)
	ftw.tween_property(flash, "scale", Vector2(1.5, 1.5), 0.2)
	ftw.tween_property(flash, "modulate:a", 0.0, 0.2)

	var cleanup = burst.get_tree().create_tween()
	cleanup.tween_interval(0.4)
	cleanup.tween_callback(burst.queue_free)

func _spawn_afterimage_effect(target: Node, player: Node) -> void:
	if not is_instance_valid(target) or not is_instance_valid(player):
		return

	var tree = target.get_tree()
	var scene = tree.current_scene
	if scene == null:
		return

	var hit_pos = target.global_position
	var dir = (hit_pos - player.global_position).normalized()
	if dir.length() < 0.1:
		dir = Vector2.RIGHT
	var perp = Vector2(-dir.y, dir.x)

	# === ROOT NODE ===
	var root = Node2D.new()
	root.global_position = hit_pos
	root.z_index = 109
	scene.add_child(root)

	# === GHOSTLY AFTERIMAGE SILHOUETTE ===
	# Dark semi-transparent copy offset behind the slash
	var ghost = ColorRect.new()
	ghost.size = Vector2(28, 40)
	ghost.position = -dir * 18.0 + Vector2(-14, -30)
	ghost.color = Color(0.2, 0.1, 0.3, 0.55)
	root.add_child(ghost)

	var ghost_tw = tree.create_tween()
	ghost_tw.set_parallel(true)
	ghost_tw.tween_property(ghost, "position", ghost.position + dir * 30.0, 0.35).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	ghost_tw.tween_property(ghost, "modulate:a", 0.0, 0.35)

	# === MAIN SLASH ARC — wide, thick, bright ===
	var arc = Line2D.new()
	arc.width = 8.0
	arc.default_color = Color(0.65, 0.35, 0.8, 0.95)
	arc.z_index = 2
	var segments = 12
	for i in range(segments + 1):
		var t = float(i) / float(segments)
		var sweep = -1.0 + t * 2.0
		var curve_depth = (1.0 - sweep * sweep) * 14.0
		var point = perp * sweep * 38.0 + dir * curve_depth
		arc.add_point(point)
	root.add_child(arc)

	# Width taper: thick center, thin edges
	var curve = Curve.new()
	curve.add_point(Vector2(0.0, 0.15))
	curve.add_point(Vector2(0.3, 0.8))
	curve.add_point(Vector2(0.5, 1.0))
	curve.add_point(Vector2(0.7, 0.8))
	curve.add_point(Vector2(1.0, 0.15))
	arc.width_curve = curve

	# === GLOW ARC — soft wide halo behind main slash ===
	var glow = Line2D.new()
	glow.width = 22.0
	glow.default_color = Color(0.5, 0.2, 0.65, 0.25)
	glow.z_index = 1
	glow.width_curve = curve
	for i in arc.get_point_count():
		glow.add_point(arc.get_point_position(i))
	root.add_child(glow)

	# === INNER BRIGHT CORE — thin white line for sharpness ===
	var core = Line2D.new()
	core.width = 3.0
	core.default_color = Color(0.85, 0.75, 1.0, 0.9)
	core.z_index = 3
	core.width_curve = curve
	for i in arc.get_point_count():
		core.add_point(arc.get_point_position(i))
	root.add_child(core)

	# === SLASH PARTICLES — dark motes flung outward ===
	for i in 7:
		var p = ColorRect.new()
		var pw = randf_range(3, 6)
		var ph = randf_range(2, 4)
		p.size = Vector2(pw, ph)
		p.position = Vector2(-pw * 0.5, -ph * 0.5)
		p.color = Color(0.4, 0.2, 0.55, 0.8) if randf() > 0.3 else Color(0.7, 0.5, 0.9, 0.7)
		p.rotation = randf() * TAU
		root.add_child(p)

		var angle = randf() * TAU
		var dist = randf_range(18, 45)
		var end_pos = Vector2(cos(angle), sin(angle)) * dist
		var ptw = tree.create_tween()
		ptw.set_parallel(true)
		ptw.tween_property(p, "position", end_pos, randf_range(0.2, 0.35))
		ptw.tween_property(p, "rotation", p.rotation + randf_range(-2.0, 2.0), 0.3)
		ptw.tween_property(p, "modulate:a", 0.0, randf_range(0.25, 0.4))

	# === IMPACT FLASH — central burst ===
	var flash = _create_flash_circle(Vector2.ZERO, 22.0, Color(0.7, 0.45, 0.9, 0.9))
	root.add_child(flash)
	var ftw = tree.create_tween()
	ftw.set_parallel(true)
	ftw.tween_property(flash, "scale", Vector2(1.8, 1.8), 0.2)
	ftw.tween_property(flash, "modulate:a", 0.0, 0.2)

	# === ANIMATE SLASH: scale in fast then fade ===
	root.scale = Vector2(0.3, 0.3)
	var main_tw = tree.create_tween()
	main_tw.tween_property(root, "scale", Vector2(1.1, 1.1), 0.08).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	main_tw.tween_property(root, "scale", Vector2(1.0, 1.0), 0.05)
	main_tw.tween_interval(0.1)
	main_tw.tween_property(root, "modulate:a", 0.0, 0.25)
	main_tw.tween_callback(root.queue_free)
