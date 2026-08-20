extends Node

## =============================================================================
## PROSTHETIC EFFECTS — Universal Autoload Singleton
## =============================================================================
## Register as Autoload: Project > Project Settings > Autoload
##   Name: ProstheticEffects   Path: res://prosthetic_effects.gd
##
## USAGE (any enemy script):
##
##   In _on_hurt_box_hurt:
##       ProstheticEffects.apply(attacker, self, blocked)
##
##   In movement/attack tick:
##       if ProstheticEffects.is_confused(self): <wander and return>
##
##   In _physics_process (optional, for shock posture drain):
##       ProstheticEffects.tick(self, delta)
##
## ADDING NEW PROSTHETICS:
##   1. Set metas on the prosthetic Area2D in prosthetic_executor.gd
##   2. Read them in apply() below
##   That's it — all enemies get it automatically.
## =============================================================================


# =============================================================================
# MAIN ENTRY POINT — call from any enemy's _on_hurt_box_hurt
# =============================================================================
func apply(attacker: Node, target: Node, blocked: bool, resistance: float = 0.0) -> void:
	## attacker:    the Area2D (or Node) that hit the enemy
	## target:      the enemy node itself (self)
	## blocked:     whether the enemy blocked this hit
	## resistance:  0.0 = full effects, 0.5 = half duration/force (for bosses)
	
	if attacker == null or target == null:
		return
	if not (attacker is Area2D and attacker.has_meta("prosthetic_source")):
		return
	
	var mult = clamp(1.0 - resistance, 0.1, 1.0)
	
	# --- Extra posture damage ---
	if attacker.has_meta("posture_damage"):
		var extra = float(attacker.get_meta("posture_damage"))
		if blocked:
			extra *= 0.5
		_add_posture(target, extra)
	
	# --- Stagger (stun + cancel) ---
	if attacker.has_meta("stagger") and attacker.get_meta("stagger"):
		var dur = float(attacker.get_meta("stagger_duration")) if attacker.has_meta("stagger_duration") else 0.3
		dur *= mult
		_stun(target, dur)
		_cancel_attack(target)
		_play_anim(target, "stagger")
	
	# --- Interrupt (cancel attack, no stun) ---
	elif attacker.has_meta("interrupt") and attacker.get_meta("interrupt"):
		_cancel_attack(target)
	
	# --- Shock status ---
	if attacker.has_meta("shock_duration"):
		var s_dur = float(attacker.get_meta("shock_duration")) * mult
		var s_post = float(attacker.get_meta("shock_posture")) if attacker.has_meta("shock_posture") else 6.0
		apply_shock(target, s_dur, s_post)
	
	# --- Confusion (smoke gourd) ---
	if attacker.has_meta("confusion_duration"):
		var c_dur = float(attacker.get_meta("confusion_duration")) * mult
		apply_confusion(target, c_dur)
	
	# --- Pull toward source (fang harpoon) ---
	if attacker.has_meta("pull_force"):
		var pull_str = float(attacker.get_meta("pull_force")) * mult
		var pull_source = attacker.get_meta("attacker") if attacker.has_meta("attacker") else null
		if pull_source and is_instance_valid(pull_source) and "global_position" in pull_source:
			var pull_dir = (pull_source.global_position - target.global_position).normalized()
			_apply_displacement(target, pull_dir, pull_str, 0.18 * mult)
			_cancel_attack(target)
	
	# --- Lacerate (bleed) ---
	if attacker.has_meta("lacerate_duration"):
		var l_dur = float(attacker.get_meta("lacerate_duration")) * mult
		_apply_lacerate(target, l_dur)
	
	# --- Burn (flame vent) ---
	if attacker.has_meta("burn_duration"):
		var b_dur = float(attacker.get_meta("burn_duration")) * mult
		var b_dps = float(attacker.get_meta("burn_dps")) if attacker.has_meta("burn_dps") else 3.0
		apply_burn(target, b_dur, b_dps)
	# =========================================================================
	# ADD NEW PROSTHETIC EFFECTS HERE
	# Just read the meta and call a helper. All enemies get it for free.
	# =========================================================================


# =============================================================================
# STATUS CHECKS — call from any enemy's movement/attack tick
# =============================================================================
func is_confused(target: Node) -> bool:
	var until = float(target.get_meta("_pros_confused_until", 0.0))
	return Time.get_ticks_msec() * 0.001 < until

func is_shocked(target: Node) -> bool:
	var until = float(target.get_meta("_pros_shocked_until", 0.0))
	return Time.get_ticks_msec() * 0.001 < until

func is_burning(target: Node) -> bool:
	var until = float(target.get_meta("_pros_burn_until", 0.0))
	return Time.get_ticks_msec() * 0.001 < until
# =============================================================================
# TICK — call from enemy _physics_process for ongoing effects (shock drain)
# =============================================================================
func tick(target: Node, delta: float) -> void:
	if not is_instance_valid(target):
		return

	var now = Time.get_ticks_msec() * 0.001

	# Shock: posture drain over time
	if is_shocked(target):
		var rate = float(target.get_meta("_pros_shock_posture_rate", 0.0))
		if rate > 0.0:
			_add_posture(target, rate * delta)

	# Shock expiry: clean up telegraph mult when shock ends
	if not is_shocked(target) and target.has_meta("_pros_shock_telegraph_mult"):
		target.remove_meta("_pros_shock_telegraph_mult")
	
	# Burn: HP damage over time + suppress posture recovery
	if is_burning(target):
		var dps = float(target.get_meta("_pros_burn_dps", 3.0))
		_deal_dot_damage(target, dps * delta)
		# Keep posture recovery suppressed while burning
		if "combat" in target and target.combat != null:
			if target.combat.has_method("suppress_recovery"):
				target.combat.suppress_recovery(0.2)
		# Visual burn tint
		if "sprite" in target and target.sprite != null:
			target.sprite.modulate = Color(1.0, 0.7, 0.4)

	# Burn expiry: clean up
	if not is_burning(target) and target.has_meta("_pros_burn_dps"):
		target.remove_meta("_pros_burn_dps")
		target.remove_meta("_pros_burn_dmg_accum")
		# Restore sprite color
		if "sprite" in target and target.sprite != null:
			target.sprite.modulate = Color.WHITE
		
	# Confusion expiry: tidy wander metas after confusion ends
	if not is_confused(target) and target.has_meta("_pros_wander_dir"):
		target.remove_meta("_pros_wander_dir")
		target.remove_meta("_pros_wander_until")
		target.remove_meta("_pros_wander_pause_until")

# =============================================================================
# APPLY HELPERS — called internally or from prosthetic_executor for smoke, etc.
# =============================================================================
func apply_confusion(target: Node, duration: float) -> void:
	if not is_instance_valid(target):
		return

	var now = Time.get_ticks_msec() * 0.001
	var current = float(target.get_meta("_pros_confused_until", 0.0))
	target.set_meta("_pros_confused_until", max(current, now + duration))
	_cancel_attack(target)

	# --- Natural confused movement parameters (per target) ---
	var rng = _pros_rng(target)

	if not target.has_meta("_pros_wander_interval_min"):
		target.set_meta("_pros_wander_interval_min", rng.randf_range(0.18, 0.35))
	if not target.has_meta("_pros_wander_interval_max"):
		target.set_meta("_pros_wander_interval_max", rng.randf_range(0.40, 0.85))
	if not target.has_meta("_pros_wander_speed_mul"):
		target.set_meta("_pros_wander_speed_mul", rng.randf_range(0.20, 0.45))
	if not target.has_meta("_pros_wander_pause_chance"):
		target.set_meta("_pros_wander_pause_chance", rng.randf_range(0.12, 0.28))
	if not target.has_meta("_pros_wander_pause_dur_min"):
		target.set_meta("_pros_wander_pause_dur_min", rng.randf_range(0.08, 0.16))
	if not target.has_meta("_pros_wander_pause_dur_max"):
		target.set_meta("_pros_wander_pause_dur_max", rng.randf_range(0.18, 0.30))

	var dir = target.get_meta("_pros_wander_dir", Vector2.ZERO)
	var until = float(target.get_meta("_pros_wander_until", 0.0))
	if dir == Vector2.ZERO or now >= until:
		dir = _rand_unit_vec2(rng)
		target.set_meta("_pros_wander_dir", dir)

		var imin = float(target.get_meta("_pros_wander_interval_min"))
		var imax = float(target.get_meta("_pros_wander_interval_max"))
		var next_dt = rng.randf_range(imin, imax) + rng.randf_range(0.00, 0.20)
		target.set_meta("_pros_wander_until", now + next_dt)

	if not target.has_meta("_pros_wander_pause_until"):
		target.set_meta("_pros_wander_pause_until", 0.0)
		
func apply_shock(target: Node, duration: float, posture_per_sec: float = 6.0) -> void:
	if not is_instance_valid(target):
		return

	var now = Time.get_ticks_msec() * 0.001
	var current = float(target.get_meta("_pros_shocked_until", 0.0))
	target.set_meta("_pros_shocked_until", max(current, now + duration))
	target.set_meta("_pros_shock_posture_rate", posture_per_sec)
	target.set_meta("_pros_shock_telegraph_mult", 1.25)

	_stun(target, duration)
	_cancel_attack(target)

func get_shock_telegraph_mult(target: Node) -> float:
	if not is_shocked(target):
		return 1.0
	return float(target.get_meta("_pros_shock_telegraph_mult", 1.0))


func get_shock_attack_penalty(target: Node) -> float:
	if not is_shocked(target):
		return 0.0
	return float(target.get_meta("_pros_shock_posture_rate", 0.0))

func apply_burn(target: Node, duration: float, dps: float = 3.0) -> void:
	if not is_instance_valid(target):
		return
	var now = Time.get_ticks_msec() * 0.001
	var current = float(target.get_meta("_pros_burn_until", 0.0))
	target.set_meta("_pros_burn_until", max(current, now + duration))
	target.set_meta("_pros_burn_dps", dps)
	if not target.has_meta("_pros_burn_dmg_accum"):
		target.set_meta("_pros_burn_dmg_accum", 0.0)

func check_lifesteal(player: Node, hp_damage: int) -> void:
	# Called by enemies after confirming HP damage from player sword.
	# Heals the player if bloodletting gourd lifesteal is active.
	if hp_damage <= 0:
		return
	if not is_instance_valid(player):
		return
	if not player.has_meta("_lifesteal_until"):
		return

	var now = Time.get_ticks_msec() * 0.001
	if now >= float(player.get_meta("_lifesteal_until")):
		player.remove_meta("_lifesteal_until")
		player.remove_meta("_lifesteal_per_hit")
		player.remove_meta("_lifesteal_remaining")
		return

	var remaining = int(player.get_meta("_lifesteal_remaining", 0))
	if remaining <= 0:
		return

	var heal = min(int(player.get_meta("_lifesteal_per_hit", 2)), remaining)
	player.set_meta("_lifesteal_remaining", remaining - heal)

	if "hp" in player and "maxhp" in player:
		player.hp = min(player.maxhp, player.hp + heal)
		if player.has_method("_update_health_bar"):
			player._update_health_bar()
			
func _deal_dot_damage(target: Node, amount: float) -> void:
	# Accumulate fractional damage, apply whole HP when >= 1.0
	var accum = float(target.get_meta("_pros_burn_dmg_accum", 0.0)) + amount
	if accum >= 1.0:
		var whole = int(accum)
		accum -= whole
		if "hp" in target:
			target.hp -= whole
			# Show damage number (same pattern as bleed ticks)
			if DamageNumberManager:
				DamageNumberManager.show_damage_number(
					whole,
					target.global_position + Vector2(randf_range(-10, 10), randf_range(-30, -20)),
					"burn",
					target
				)
			if target.hp <= 0:
				target.hp = 0
				if target.has_method("death"):
					target.death()
	target.set_meta("_pros_burn_dmg_accum", accum)
	
# =============================================================================
# INTERNAL HELPERS — duck-typed to work with any enemy structure
# =============================================================================
func _add_posture(target: Node, amount: float) -> void:
	# Try CombatController first (most enemies)
	if "combat" in target and target.combat != null:
		if target.combat.has_method("add_posture"):
			target.combat.add_posture(amount)
			return
	# Try direct posture property (wild_dog)
	if "posture" in target and "max_posture" in target:
		target.posture = min(target.posture + amount, target.max_posture)
		if target.has_method("_update_posture_bar"):
			target._update_posture_bar()
		# Check for posture break
		if target.posture >= target.max_posture:
			if target.has_method("_trigger_posture_break"):
				target._trigger_posture_break()

func _stun(target: Node, duration: float) -> void:
	var now = Time.get_ticks_msec() * 0.001
	# enemy.gd / wild_dog / lost_shade: stunned_until
	if "stunned_until" in target:
		target.stunned_until = max(target.stunned_until, now + duration)
	# enemy.gd: AIState.STUNNED via state machine
	if "ai_state" in target and target.has_method("_switch_state"):
		if "AIState" in target:
			target._switch_state(target.AIState.STUNNED)
	# shield_enemy: _stun_end + ai_state (enum, not state machine)
	if "_stun_end" in target:
		target._stun_end = max(target._stun_end, now + duration)
		if "ai_state" in target:
			target.ai_state = 4  # AIState.STUNNED for shield_enemy
	# shield_captain: _stun_until
	if "_stun_until" in target:
		target._stun_until = max(target._stun_until, now + duration)
	# bosses (chain_collector, ashen_boss): freeze via parry recoil with zero velocity
	if "_parry_recoil_until" in target and "_parry_recoil_velocity" in target:
		# Only set if not already in a longer recoil
		if target._parry_recoil_until < now + duration:
			target._parry_recoil_velocity = Vector2.ZERO
			target._parry_recoil_until = now + duration
	# Suppress immediate re-attack after stun ends
	if "_attack_cooldown" in target:
		target._attack_cooldown = max(target._attack_cooldown, duration)
		
func _cancel_attack(target: Node) -> void:
	# enemy.gd pattern
	if target.has_method("_cancel_attack"):
		target._cancel_attack()
		return
	# Miniboss/boss pattern: sequence ID + interrupted flag + cleanup
	if "_attack_sequence_id" in target and "_combo_interrupted" in target:
		target._attack_sequence_id += 1
		target._combo_interrupted = true
		if target.has_method("_cleanup_hitbox"):
			target._cleanup_hitbox()
		if target.has_method("_cleanup_mass_hitboxes"):
			target._cleanup_mass_hitboxes()
		# Reset behavior state to idle if possible
		if "_behavior_state" in target:
			target._behavior_state = 0  # BehaviorState.IDLE
		return
	# shield_enemy pattern
	if target.has_method("_clear_hitbox"):
		target._clear_hitbox()
		if "ai_state" in target and not ("_attack_sequence_id" in target):
			target.ai_state = 0  # AIState.IDLE for shield_enemy
		return
	# wild_dog pattern
	if target.has_method("_bump_attack_gen"):
		target._bump_attack_gen()
	if target.has_method("_disarm_hitbox"):
		target._disarm_hitbox()
	if target.has_method("_hide_parry_indicator"):
		target._hide_parry_indicator()


func _apply_displacement(target: Node, direction: Vector2, force: float, stun_dur: float) -> void:
	_stun(target, stun_dur)
	# Prefer knockback property (enemy.gd, shield_enemy, wild_dog)
	if "knockback" in target:
		target.knockback = direction * force
		return
	# Fallback: parry recoil system (minibosses, boss)
	if "_parry_recoil_velocity" in target and "_parry_recoil_until" in target:
		target._parry_recoil_velocity = direction * force
		target._parry_recoil_until = Time.get_ticks_msec() * 0.001 + stun_dur
		return


func _apply_lacerate(target: Node, duration: float) -> void:
	if "is_lacerated" in target:
		target.is_lacerated = true
		# Auto-clear after duration
		if target.has_method("get_tree") and target.get_tree():
			target.get_tree().create_timer(duration).timeout.connect(func():
				if is_instance_valid(target) and "is_lacerated" in target:
					target.is_lacerated = false
			)


func _play_anim(target: Node, anim_name: String) -> void:
	if "anim" in target and target.anim != null:
		if target.anim.has_animation(anim_name):
			target.anim.play(anim_name)

func _pros_rng(target: Node) -> RandomNumberGenerator:
	if not is_instance_valid(target):
		return RandomNumberGenerator.new()

	var rng: RandomNumberGenerator = null
	if target.has_meta("_pros_rng"):
		rng = target.get_meta("_pros_rng")

	if rng == null:
		rng = RandomNumberGenerator.new()
		# Stable per-instance seed so enemies don't sync; also mixes in coarse time
		rng.seed = int(target.get_instance_id()) ^ int(Time.get_ticks_msec() * 0.001)
		target.set_meta("_pros_rng", rng)

	return rng

func _rand_unit_vec2(rng: RandomNumberGenerator) -> Vector2:
	var v = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0))
	if v.length() < 0.0001:
		return Vector2.RIGHT
	return v.normalized()

func override_movement(target: Node, delta: float) -> bool:
	# Returns true if it fully handled movement and caller should `return`.
	# Uses metadata only; no enemy vars required.

	if not is_instance_valid(target):
		return false

	# Only override for confusion (smoke conceal)
	if not is_confused(target):
		return false

	# We need these from the enemy to move it.
	if not ("velocity" in target):
		return false
	if not target.has_method("move_and_slide"):
		return false

	var base_speed = 0.0
	if "movement_speed" in target:
		base_speed = float(target.movement_speed)
	elif "approach_speed" in target:
		base_speed = float(target.approach_speed)
	else:
		return false

	var knockback: Vector2 = Vector2.ZERO
	if "knockback" in target:
		knockback = target.knockback

	var now = Time.get_ticks_msec() * 0.001

	# Per-target RNG (stable, de-syncs groups)
	var rng: RandomNumberGenerator = target.get_meta("_pros_rng", null)
	if rng == null:
		rng = RandomNumberGenerator.new()
		rng.seed = int(target.get_instance_id()) ^ int(Time.get_ticks_msec())
		target.set_meta("_pros_rng", rng)

	# Lazy-init per-target naturalness params (one-time)
	if not target.has_meta("_pros_wander_interval_min"):
		target.set_meta("_pros_wander_interval_min", rng.randf_range(0.18, 0.35))
	if not target.has_meta("_pros_wander_interval_max"):
		target.set_meta("_pros_wander_interval_max", rng.randf_range(0.45, 0.95))
	if not target.has_meta("_pros_wander_speed_mul"):
		target.set_meta("_pros_wander_speed_mul", rng.randf_range(0.18, 0.48))
	if not target.has_meta("_pros_wander_pause_chance"):
		target.set_meta("_pros_wander_pause_chance", rng.randf_range(0.10, 0.30))
	if not target.has_meta("_pros_wander_pause_dur_min"):
		target.set_meta("_pros_wander_pause_dur_min", rng.randf_range(0.07, 0.16))
	if not target.has_meta("_pros_wander_pause_dur_max"):
		target.set_meta("_pros_wander_pause_dur_max", rng.randf_range(0.16, 0.34))

	# Direction selection windows (prevents flicker + lockstep)
	var dir: Vector2 = target.get_meta("_pros_wander_dir", Vector2.ZERO)
	var until = float(target.get_meta("_pros_wander_until", 0.0))

	# Optional hesitation pause windows
	var pause_until = float(target.get_meta("_pros_wander_pause_until", 0.0))

	if now >= until or dir == Vector2.ZERO:
		# Occasionally hesitate instead of moving
		if rng.randf() < float(target.get_meta("_pros_wander_pause_chance")):
			var pmin = float(target.get_meta("_pros_wander_pause_dur_min"))
			var pmax = float(target.get_meta("_pros_wander_pause_dur_max"))
			pause_until = now + rng.randf_range(pmin, pmax)
			target.set_meta("_pros_wander_pause_until", pause_until)

		# Pick a new direction
		var v = Vector2(rng.randf_range(-1.0, 1.0), rng.randf_range(-1.0, 1.0))
		if v.length() < 0.0001:
			v = Vector2.RIGHT
		dir = v.normalized()
		target.set_meta("_pros_wander_dir", dir)

		# Next change time (extra jitter to avoid crowd sync)
		var imin = float(target.get_meta("_pros_wander_interval_min"))
		var imax = float(target.get_meta("_pros_wander_interval_max"))
		var next_dt = rng.randf_range(imin, imax) + rng.randf_range(0.00, 0.25)
		until = now + next_dt
		target.set_meta("_pros_wander_until", until)

	# Apply movement
	var speed_mul = float(target.get_meta("_pros_wander_speed_mul"))
	var vmove = Vector2.ZERO

	if now < pause_until:
		vmove = knockback
	else:
		vmove = dir * base_speed * speed_mul + knockback

	target.velocity = vmove
	target.move_and_slide()

	if target.has_method("_update_sprite_facing"):
		target._update_sprite_facing()

	if "knockback" in target:
		target.knockback = target.knockback.move_toward(Vector2.ZERO, 500.0 * delta)

	return true
