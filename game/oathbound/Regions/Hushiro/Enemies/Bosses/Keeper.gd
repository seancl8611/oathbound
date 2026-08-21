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
