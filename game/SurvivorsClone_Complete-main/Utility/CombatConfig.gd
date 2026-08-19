extends Resource
class_name CombatConfig

## =============================================================================
## COMBAT CONFIG - OATHBOUND FIRST-PLAYTEST BASELINE
## =============================================================================
## Shared combat values mirror docs/gameplay/COMBAT_IMPLEMENTATION_BASELINE.md.
## Individual attacks, enemies, minibosses, bosses, Aspects, Techniques, Relics,
## and Prosthetics may author explicit values on top of this baseline.
##
## Important rules:
## - Health and Posture are independent defeat/pressure tracks.
## - Standard enemy posture recovery is NOT tied to remaining Health.
## - A posture break opens a temporary Deathblow opportunity, then resets Posture.
## - There is no universal critical-hit system in the shared combat layer.
## =============================================================================

# =============================================================================
# POSTURE SYSTEM
# =============================================================================
@export_group("Posture")
@export var posture_max: float = 100.0
@export var posture_recover_rate: float = 20.0
@export var posture_recover_delay: float = 1.5
@export var posture_break_duration: float = 2.5
@export var posture_break_reset_ratio: float = 0.50

@export_group("Posture Damage")
# Legacy-compatible defaults. AttackEvents should author posture/block pressure directly.
@export var hit_posture_gain: float = 15.0
@export var parry_posture_spike: float = 25.0
@export var deflect_streak_bonus: float = 0.0

# Deprecated compatibility fields. Oathbound's baseline does not use an HP-based
# posture-recovery curve; all values remain 1.0 so old callers stay neutral.
@export_group("Legacy Recovery Compatibility")
@export var recovery_mult_high_hp: float = 1.0
@export var recovery_mult_mid_hp: float = 1.0
@export var recovery_mult_low_hp: float = 1.0
@export var recovery_mult_critical_hp: float = 1.0

# =============================================================================
# INPUT BUFFERING
# =============================================================================
@export_group("Input Buffer")
@export var input_buffer_ms: int = 100
@export var dodge_buffer_ms: int = 100
@export var parry_buffer_ms: int = 0

# =============================================================================
# ATTACK SYSTEM
# =============================================================================
@export_group("Attack Timing")
@export var attack_cancel_at: float = 0.60
@export var combo_window_start: float = 0.55
@export var combo_window_end: float = 0.85
@export var max_combo_hits: int = 3
@export var combo_link_window: float = 0.20

@export_group("Attack Movement")
@export var attack_lunge_distance: float = 16.0
@export var combo_lunge_multipliers = [1.0, 1.1, 1.3]
@export var attack_movement_mult: float = 0.0

@export_group("Attack Damage")
@export var combo_damage = [10, 12, 18]
@export var combo_posture_damage = [12.0, 14.0, 20.0]

# =============================================================================
# STEP-DODGE
# =============================================================================
@export_group("Step-Dodge")
@export var dodge_distance: float = 96.0
@export var dodge_duration: float = 0.18
# Repeat interval is measured from the prior dash start.
@export var dodge_cooldown: float = 0.30
@export var dodge_speed: float = 533.3333

@export_group("I-Frames")
# Kept for compatibility with older callers; the canonical duration is 0.12 s.
@export var iframes_start_frame: int = 0
@export var iframes_end_frame: int = 7
@export var iframes_duration: float = 0.12

# =============================================================================
# PARRY / BLOCK
# =============================================================================
@export_group("Parry Timing")
@export var parry_window_base: float = 0.12
# Oathbound does not have a separate universal "perfect parry" rules layer.
@export var perfect_parry_window: float = 0.0
@export var parry_window_min: float = 0.12
@export var parry_spam_penalty: float = 0.0
@export var parry_spam_recovery: float = 0.0
@export var counter_window: float = 0.24

@export_group("Block")
@export var block_arc_degrees: float = 150.0

# =============================================================================
# FEEDBACK
# =============================================================================
@export_group("Hitstop")
@export var hitstop_light: float = 0.08
@export var hitstop_heavy: float = 0.18
@export var hitstop_parry: float = 0.25
@export var hitstop_posture_break: float = 0.35

@export_group("Screen Shake")
@export var shake_light: float = 2.0
@export var shake_heavy: float = 5.0
@export var shake_parry: float = 5.0
@export var shake_posture_break: float = 8.0
@export var shake_decay: float = 10.0

@export_group("Visual Feedback")
@export var hit_flash_duration: float = 0.06
@export var damage_flash_color: Color = Color(1.0, 0.3, 0.3, 0.85)
@export var parry_flash_color: Color = Color(1.0, 0.9, 0.5, 0.85)
@export var perfect_parry_flash_color: Color = Color(1.0, 1.0, 0.85, 1.0)

# =============================================================================
# DEATHBLOW
# =============================================================================
@export_group("Deathblow")
@export var can_do_finisher: bool = false

# =============================================================================
# MOVEMENT REFERENCE
# =============================================================================
@export_group("Movement Reference")
@export var movement_speed: float = 200.0
@export var acceleration_time: float = 0.06
@export var deceleration_time: float = 0.04


## =============================================================================
## HELPER METHODS
## =============================================================================

func get_iframes_duration() -> float:
	return iframes_duration


func get_combo_damage(hit_index: int) -> int:
	if hit_index < 0 or hit_index >= combo_damage.size():
		return combo_damage[0] if combo_damage.size() > 0 else 10
	return combo_damage[hit_index]


func get_combo_posture_damage(hit_index: int) -> float:
	if hit_index < 0 or hit_index >= combo_posture_damage.size():
		return combo_posture_damage[0] if combo_posture_damage.size() > 0 else 10.0
	return combo_posture_damage[hit_index]


func get_combo_lunge(hit_index: int) -> float:
	var mult = 1.0
	if hit_index >= 0 and hit_index < combo_lunge_multipliers.size():
		mult = combo_lunge_multipliers[hit_index]
	return attack_lunge_distance * mult


## Deprecated compatibility helper. Health does not modify baseline Posture recovery.
func get_recovery_multiplier(_hp_ratio: float) -> float:
	return 1.0


## =============================================================================
## PRESET FACTORIES
## =============================================================================

static func create_player_config() -> CombatConfig:
	var cfg = CombatConfig.new()
	cfg.posture_max = 100.0
	cfg.posture_recover_rate = 25.0
	cfg.posture_recover_delay = 0.75
	cfg.posture_break_duration = 0.75
	cfg.posture_break_reset_ratio = 0.40
	cfg.hit_posture_gain = 8.0
	cfg.parry_posture_spike = 25.0
	cfg.deflect_streak_bonus = 0.0

	cfg.input_buffer_ms = 100
	cfg.dodge_buffer_ms = 100
	cfg.parry_buffer_ms = 0

	cfg.attack_cancel_at = 0.60
	cfg.combo_window_start = 0.55
	cfg.combo_window_end = 0.85
	cfg.max_combo_hits = 3
	cfg.combo_link_window = 0.20
	cfg.attack_lunge_distance = 16.0
	cfg.combo_lunge_multipliers = [1.0, 1.1, 1.3]
	cfg.attack_movement_mult = 0.0
	cfg.combo_damage = [10, 12, 18]
	cfg.combo_posture_damage = [12.0, 14.0, 20.0]

	cfg.dodge_distance = 96.0
	cfg.dodge_duration = 0.18
	cfg.dodge_cooldown = 0.30
	cfg.dodge_speed = 533.3333
	cfg.iframes_start_frame = 0
	cfg.iframes_end_frame = 7
	cfg.iframes_duration = 0.12

	cfg.parry_window_base = 0.12
	cfg.perfect_parry_window = 0.0
	cfg.parry_window_min = 0.12
	cfg.parry_spam_penalty = 0.0
	cfg.parry_spam_recovery = 0.0
	cfg.counter_window = 0.24
	cfg.block_arc_degrees = 150.0

	cfg.hitstop_light = 0.08
	cfg.hitstop_heavy = 0.18
	cfg.hitstop_parry = 0.25
	cfg.hitstop_posture_break = 0.35
	cfg.shake_light = 2.0
	cfg.shake_heavy = 5.0
	cfg.shake_parry = 5.0
	cfg.shake_posture_break = 8.0

	cfg.can_do_finisher = true
	cfg.movement_speed = 200.0
	cfg.acceleration_time = 0.06
	cfg.deceleration_time = 0.04
	return cfg


static func create_enemy_config() -> CombatConfig:
	## Standard enemy reference baseline: 100 Health / 100 Posture.
	var cfg = CombatConfig.new()
	cfg.posture_max = 100.0
	cfg.posture_recover_rate = 20.0
	cfg.posture_recover_delay = 1.5
	cfg.posture_break_duration = 2.5
	cfg.posture_break_reset_ratio = 0.50
	cfg.hit_posture_gain = 15.0
	cfg.parry_posture_spike = 25.0
	cfg.deflect_streak_bonus = 0.0
	cfg.can_do_finisher = false
	return cfg


static func create_miniboss_config() -> CombatConfig:
	## Actual miniboss Health/Posture are authored on the enemy contract.
	var cfg = CombatConfig.new()
	cfg.posture_max = 150.0
	cfg.posture_recover_rate = 20.0
	cfg.posture_recover_delay = 1.5
	cfg.posture_break_duration = 2.5
	cfg.posture_break_reset_ratio = 0.50
	cfg.hit_posture_gain = 12.0
	cfg.parry_posture_spike = 30.0
	cfg.deflect_streak_bonus = 0.0
	cfg.can_do_finisher = true
	return cfg


static func create_boss_config() -> CombatConfig:
	## Actual boss Health/Posture and phase checkpoints are authored per boss.
	var cfg = CombatConfig.new()
	cfg.posture_max = 175.0
	cfg.posture_recover_rate = 20.0
	cfg.posture_recover_delay = 1.5
	cfg.posture_break_duration = 2.5
	cfg.posture_break_reset_ratio = 0.50
	cfg.hit_posture_gain = 10.0
	cfg.parry_posture_spike = 30.0
	cfg.deflect_streak_bonus = 0.0
	cfg.can_do_finisher = true
	return cfg


static func create_fodder_config() -> CombatConfig:
	## Fragile reference band: 50-70 Posture.
	var cfg = CombatConfig.new()
	cfg.posture_max = 60.0
	cfg.posture_recover_rate = 20.0
	cfg.posture_recover_delay = 1.5
	cfg.posture_break_duration = 2.5
	cfg.posture_break_reset_ratio = 0.50
	cfg.hit_posture_gain = 20.0
	cfg.parry_posture_spike = 25.0
	cfg.can_do_finisher = false
	return cfg


static func create_aggressive_enemy_config() -> CombatConfig:
	## Compatibility preset for lighter aggressive enemies; no HP recovery curve.
	var cfg = CombatConfig.new()
	cfg.posture_max = 80.0
	cfg.posture_recover_rate = 20.0
	cfg.posture_recover_delay = 1.5
	cfg.posture_break_duration = 2.5
	cfg.posture_break_reset_ratio = 0.50
	cfg.hit_posture_gain = 18.0
	cfg.parry_posture_spike = 25.0
	cfg.can_do_finisher = false
	return cfg
