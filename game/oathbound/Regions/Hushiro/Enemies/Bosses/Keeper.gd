extends "res://Regions/Hushiro/Enemies/Bosses/KeeperController.gd"

## Canonical Hushiro rules layer for Keeper of the Gate.
## The imported controller owns the individual attack implementations. This layer owns
## the approved two-life / two-Deathblow first-playtest contract.

const HUSHIRO_PHASE1_HEALTH := 600
const HUSHIRO_PHASE1_POSTURE := 325.0
const HUSHIRO_PHASE2_HEALTH := 700
const HUSHIRO_PHASE2_POSTURE := 375.0
const HUSHIRO_DEATHBLOW_WINDOW := 3.5
const HUSHIRO_POSTURE_RESET_RATIO := 0.50

var _hushiro_finisher_kill := false
var _hushiro_last_phase2_attack: int = -1


func _ready() -> void:
	super._ready()

	keeper_max_hp = HUSHIRO_PHASE1_HEALTH
	hp = HUSHIRO_PHASE1_HEALTH
	_max_hp = HUSHIRO_PHASE1_HEALTH
	deathblow_window_duration = HUSHIRO_DEATHBLOW_WINDOW

	if combat:
		combat.config = CombatConfig.create_boss_config()
		combat.config.posture_max = HUSHIRO_PHASE1_POSTURE
		combat.config.posture_break_duration = HUSHIRO_DEATHBLOW_WINDOW
		combat.config.posture_break_reset_ratio = HUSHIRO_POSTURE_RESET_RATIO
		combat.set_posture(0.0)

	_update_bars()
	print("[Keeper] Hushiro contract active: Phase 1 = 600/325, Phase 2 = 700/375")


func _on_hurt_box_hurt(damage: int, damage_type: String, attacker: Node = null) -> void:
	# The imported Keeper receiver still calls notify_got_hit(), whose current contract
	# intentionally does not add ordinary hit posture. Detect that no posture was
	# consumed and route exactly one add_posture() while HurtBox's canonical AttackEvent
	# transaction is still active. Canonical sword contacts therefore resolve to their
	# authored 10/16/36/etc values instead of 0, while non-canonical callers use the
	# conservative legacy damage-based fallback.
	var player_owned: bool = _hushiro_is_player_owned_source(attacker)
	var posture_before: float = combat.get_posture() if combat != null else 0.0
	super._on_hurt_box_hurt(damage, damage_type, attacker)
	if not player_owned or damage <= 0 or combat == null or _boss_phase == BossPhase.DEAD or _dbroken_active:
		return
	var posture_after: float = combat.get_posture()
	if absf(posture_after - posture_before) > 0.001:
		return
	combat.add_posture(maxf(1.0, float(damage) * 0.5))
	combat.suppress_recovery(0.6)


func _hushiro_is_player_owned_source(attacker: Node) -> bool:
	if attacker == null or not is_instance_valid(attacker):
		return false
	if attacker.is_in_group("player"):
		return true
	if attacker is Area2D and attacker.has_meta("attacker"):
		var owner_value: Variant = attacker.get_meta("attacker")
		if owner_value is Node and is_instance_valid(owner_value) and (owner_value as Node).is_in_group("player"):
			return true
	if attacker.is_in_group("attack"):
		var owner_check: Node = attacker.get_parent()
		while owner_check != null:
			if owner_check.is_in_group("player"):
				return true
			if owner_check.is_in_group("enemy"):
				return false
			owner_check = owner_check.get_parent()
	return false


func on_parried(parry_source_pos: Vector2) -> void:
	# KeeperController previously applied parry_posture_damage explicitly and then sent
	# notify_got_hit(parried=true), which added a second configured parry spike. The
	# playtest telemetry showed a single parry jumping Keeper from 0 to 60 posture.
	# Keep one authored parry posture mutation and the existing recoil/AI reaction.
	if _dbroken_active or _boss_phase == BossPhase.DEAD:
		return
	_hide_parry_indicator()

	if combat:
		combat.add_posture(parry_posture_damage)
		combat.suppress_recovery(1.0)

	_cleanup_hitbox()
	_parry_flash_tint()

	if _current_attack in [AttackType.BLADE_DANCE, AttackType.FERAL_ONSLAUGHT]:
		_combo_is_frozen = true
		_combo_parry_freeze_until = Time.get_ticks_msec() * 0.001 + parry_hitstop_duration
		return

	_combo_interrupted = true
	_attack_sequence_id += 1
	_start_parry_recoil(parry_source_pos)

	if anim:
		if anim.has_animation("parried"):
			anim.play("parried")
		elif anim.has_animation("stagger"):
			anim.play("stagger")
		else:
			anim.play("idle")

	await get_tree().create_timer(0.25).timeout
	if not is_instance_valid(self) or _boss_phase == BossPhase.DEAD or _dbroken_active:
		return

	_parry_recoil_until = 0.0
	_parry_recoil_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	_behavior_state = BehaviorState.IDLE
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	_play_anim("idle")
	_attack_cooldown = _rng.randf_range(phase1_min_cooldown * 0.8, phase1_max_cooldown * 1.2)


func is_deathblow_ready() -> bool:
	return _dbroken_active and _boss_phase != BossPhase.DEAD


func receive_deathblow(attacker: Node) -> void:
	# DeathblowSystem prefers this interface. Without it, its generic fallback sees
	# Keeper.death() and can bypass the authored Phase-1 -> Phase-2 transition.
	take_deathblow(attacker)


func _apply_damage(damage: int, damage_type: String, attacker: Node) -> void:
	if _hushiro_finisher_kill:
		super._apply_damage(damage, damage_type, attacker)
		return

	# Health depletion opens a Deathblow window in either phase. It never performs the
	# Phase-1 transformation or Phase-2 kill by itself.
	if damage > 0 and hp - damage <= 0:
		var effective_damage := maxi(hp - 1, 0)
		if effective_damage > 0:
			super._apply_damage(effective_damage, damage_type, attacker)
		hp = maxi(hp, 1)
		_update_bars()
		if not _dbroken_active:
			_on_posture_broken(HUSHIRO_DEATHBLOW_WINDOW)
		return

	super._apply_damage(damage, damage_type, attacker)


func _end_deathblow_window() -> void:
	if not _dbroken_active:
		return
	super._end_deathblow_window()
	hp = maxi(hp, 1)
	if combat and combat.config:
		combat.set_posture(combat.config.posture_max * HUSHIRO_POSTURE_RESET_RATIO)
	_update_bars()


func take_deathblow(attacker: Node) -> void:
	if _boss_phase == BossPhase.DEAD or not _dbroken_active or _deathblow_in_progress:
		return

	_deathblow_in_progress = true
	if combat:
		combat.set_posture(0.0)
	_clear_deathblow_state()
	_behavior_state = BehaviorState.STAGGERED
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	_cleanup_telegraph()

	if _boss_phase == BossPhase.PHASE_1:
		_begin_hushiro_phase_two()
		return

	# The second successful Deathblow is the only killing path.
	_hushiro_finisher_kill = true
	hp = 0
	super._die()


func _begin_hushiro_phase_two() -> void:
	# The first Deathblow always transforms Keeper and establishes a completely new
	# authored life rather than carrying Phase-1 Health/Posture forward.
	_attack_sequence_id += 1
	_behavior_state = BehaviorState.TRANSITIONING
	_current_attack = AttackType.NONE
	_combat_phase = CombatPhase.NONE
	velocity = Vector2.ZERO
	_cleanup_hitbox()
	_cleanup_telegraph()

	_boss_phase = BossPhase.PHASE_2
	keeper_max_hp = HUSHIRO_PHASE2_HEALTH
	_max_hp = HUSHIRO_PHASE2_HEALTH
	hp = HUSHIRO_PHASE2_HEALTH

	if combat:
		combat.config.posture_max = HUSHIRO_PHASE2_POSTURE
		combat.config.posture_break_duration = HUSHIRO_DEATHBLOW_WINDOW
		combat.config.posture_break_reset_ratio = HUSHIRO_POSTURE_RESET_RATIO
		combat.set_posture(0.0)

	_attack_history.clear()
	_attack_last_used.clear()
	_consecutive_close_attacks = 0
	_needs_spacing_attack = false
	_hushiro_last_phase2_attack = -1
	_update_bars()

	# Prevent transition damage while the authored transformation tell plays.
	if hurt_box:
		hurt_box.set_deferred("monitoring", false)
		hurt_box.set_deferred("monitorable", false)

	if anim:
		if anim.has_animation("phase_transformation"):
			anim.play("phase_transformation")
		elif anim.has_animation("overhead_windup"):
			anim.play("overhead_windup")

	if sprite:
		var tween := create_tween()
		tween.tween_property(sprite, "modulate", Color(2.0, 2.0, 2.0), 0.2)
		tween.tween_property(sprite, "modulate", Color(1.3, 0.5, 0.4), 0.4)
		tween.tween_property(sprite, "modulate", Color(1.1, 0.9, 0.9), 0.4)

	await get_tree().create_timer(1.5).timeout
	if not is_instance_valid(self) or _boss_phase == BossPhase.DEAD:
		return

	if hurt_box:
		hurt_box.set_deferred("monitoring", true)
		hurt_box.set_deferred("monitorable", true)

	_behavior_state = BehaviorState.IDLE
	_attack_cooldown = 0.5
	_deathblow_in_progress = false
	_play_anim("idle")
	emit_signal("phase_changed", 2)
	print("[Keeper] Phase 2 active: 700 Health / 375 Posture")


func _start_attack(attack: AttackType) -> void:
	var resolved: AttackType = attack

	# Sweep and Lane Charge are high-disruption Phase-2 checks. Do not alternate or
	# repeat them back-to-back without another move restoring the duel rhythm.
	if _boss_phase == BossPhase.PHASE_2:
		var is_special := resolved in [AttackType.SAVAGE_SWEEP, AttackType.BLOODIED_LUNGE]
		var last_was_special := _hushiro_last_phase2_attack in [AttackType.SAVAGE_SWEEP, AttackType.BLOODIED_LUNGE]
		if is_special and last_was_special:
			resolved = AttackType.FERAL_ONSLAUGHT
		_hushiro_last_phase2_attack = int(resolved)

	super._start_attack(resolved)
