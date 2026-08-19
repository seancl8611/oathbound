extends Resource
class_name CombatConfig

## =============================================================================
## COMBAT CONFIG - v5.0 TRUE SEKIRO COMBAT
## =============================================================================
## Key Sekiro principles:
## - Enemies BLOCK by default, requiring posture breaks
## - Posture damage is the primary combat mechanic
## - HP damage only when posture is broken OR enemy isn't blocking
## - Recovery curves tied to HP (low HP = slow posture recovery)
## =============================================================================

# =============================================================================
# POSTURE SYSTEM
# =============================================================================
@export_group("Posture")
@export var posture_max: float = 100.0
@export var posture_recover_rate: float = 8.0         # Base recovery per second
@export var posture_recover_delay: float = 2.0        # Seconds after hit before recovery starts
@export var posture_break_duration: float = 4.0       # How long deathblow window lasts

@export_group("Posture Damage")
@export var hit_posture_gain: float = 15.0            # Posture damage from attacks (on block)
@export var parry_posture_spike: float = 45.0         # Posture damage when parried
@export var deflect_streak_bonus: float = 5.0         # Bonus per consecutive parry

## HP-based recovery multipliers (Sekiro core mechanic)
## At full HP, enemies recover posture quickly
## At low HP, recovery is nearly stopped
@export var recovery_mult_high_hp: float = 1.0        # >75% HP
@export var recovery_mult_mid_hp: float = 0.25        # 50-75% HP
@export var recovery_mult_low_hp: float = 0.05        # 25-50% HP
@export var recovery_mult_critical_hp: float = 0.01   # <25% HP

# =============================================================================
# INPUT BUFFERING
# =============================================================================
@export_group("Input Buffer")
@export var input_buffer_ms: int = 100                # Attack buffer ~6 frames
@export var dodge_buffer_ms: int = 83                 # Dodge buffer ~5 frames
@export var parry_buffer_ms: int = 0                  # NO parry buffer (precision)

# =============================================================================
# ATTACK SYSTEM
# =============================================================================
@export_group("Attack Timing")
@export var attack_cancel_at: float = 0.60            # When dodge cancel becomes available
@export var combo_window_start: float = 0.55          # When combo input opens
@export var combo_window_end: float = 0.85            # When combo input closes
@export var max_combo_hits: int = 3
@export var combo_link_window: float = 0.20           # Window after attack ends

@export_group("Attack Movement")
@export var attack_lunge_distance: float = 16.0       # Short lunge
@export var combo_lunge_multipliers = [1.0, 1.1, 1.3]
@export var attack_movement_mult: float = 0.0         # NO movement during attack

@export_group("Attack Damage")
@export var combo_damage = [10, 12, 18]               # HP damage per hit
@export var combo_posture_damage = [12.0, 14.0, 20.0] # Posture damage per hit

# =============================================================================
# STEP-DODGE
# =============================================================================
@export_group("Step-Dodge")
@export var dodge_distance: float = 85.0
@export var dodge_duration: float = 0.18
@export var dodge_cooldown: float = 0.45
@export var dodge_speed: float = 470.0

@export_group("I-Frames")
@export var iframes_start_frame: int = 1
@export var iframes_end_frame: int = 7
@export var iframes_duration: float = 0.0             # Auto-calculated

# =============================================================================
# PARRY SYSTEM
# =============================================================================
@export_group("Parry Timing")
@export var parry_window_base: float = 0.18           # ~11 frames
@export var perfect_parry_window: float = 0.05        # ~3 frames
@export var parry_window_min: float = 0.08            # Minimum after spam penalty
@export var parry_spam_penalty: float = 0.03          # Per spam press
@export var parry_spam_recovery: float = 0.5          # Time to restore window

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
@export var movement_speed: float = 220.0             # Controlled movement
@export var acceleration_time: float = 0.06
@export var deceleration_time: float = 0.04           # Fast stop, no skating


## =============================================================================
## HELPER METHODS
## =============================================================================

func get_iframes_duration() -> float:
	if iframes_duration > 0.0:
		return iframes_duration
	var frames = iframes_end_frame - iframes_start_frame
	return frames / 60.0


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


## Calculate posture recovery multiplier based on HP ratio
func get_recovery_multiplier(hp_ratio: float) -> float:
	hp_ratio = clamp(hp_ratio, 0.0, 1.0)
	
	if hp_ratio > 0.75:
		return recovery_mult_high_hp
	elif hp_ratio > 0.50:
		return recovery_mult_mid_hp
	elif hp_ratio > 0.25:
		return recovery_mult_low_hp
	else:
		return recovery_mult_critical_hp


## =============================================================================
## PRESET FACTORIES
## =============================================================================

static func create_player_config() -> CombatConfig:
	var cfg = CombatConfig.new()
	
	# Posture - Player is more resilient
	cfg.posture_max = 100.0
	cfg.posture_recover_rate = 20.0      # Fast recovery
	cfg.posture_recover_delay = 1.0
	cfg.posture_break_duration = 2.5
	cfg.hit_posture_gain = 8.0           # Takes less posture damage
	cfg.parry_posture_spike = 25.0
	cfg.deflect_streak_bonus = 4.0
	
	# Recovery curve (player doesn't have HP-based recovery penalty)
	cfg.recovery_mult_high_hp = 1.0
	cfg.recovery_mult_mid_hp = 1.0
	cfg.recovery_mult_low_hp = 0.8
	cfg.recovery_mult_critical_hp = 0.5
	
	# Input buffer
	cfg.input_buffer_ms = 100
	cfg.dodge_buffer_ms = 83
	cfg.parry_buffer_ms = 0
	
	# Attacks
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
	
	# Dodge
	cfg.dodge_distance = 85.0
	cfg.dodge_duration = 0.18
	cfg.dodge_cooldown = 0.45
	cfg.dodge_speed = 470.0
	cfg.iframes_start_frame = 1
	cfg.iframes_end_frame = 7
	
	# Parry
	cfg.parry_window_base = 0.18
	cfg.perfect_parry_window = 0.05
	cfg.parry_window_min = 0.08
	cfg.parry_spam_penalty = 0.03
	cfg.parry_spam_recovery = 0.5
	
	# Feedback
	cfg.hitstop_light = 0.08
	cfg.hitstop_heavy = 0.18
	cfg.hitstop_parry = 0.25
	cfg.hitstop_posture_break = 0.35
	cfg.shake_light = 2.0
	cfg.shake_heavy = 5.0
	cfg.shake_parry = 5.0
	cfg.shake_posture_break = 8.0
	
	# Deathblow
	cfg.can_do_finisher = true
	
	# Movement
	cfg.movement_speed = 220.0
	cfg.acceleration_time = 0.06
	cfg.deceleration_time = 0.04
	
	return cfg


static func create_enemy_config() -> CombatConfig:
	## Standard enemy - blocks by default, posture-based combat
	var cfg = CombatConfig.new()
	
	# Posture - The core Sekiro mechanic
	cfg.posture_max = 80.0               # Standard enemy posture
	cfg.posture_recover_rate = 10.0      # Moderate recovery
	cfg.posture_recover_delay = 2.0      # Delay before recovery starts
	cfg.posture_break_duration = 4.0     # Deathblow window
	cfg.hit_posture_gain = 15.0          # Posture damage from hits
	cfg.parry_posture_spike = 45.0       # Big spike when parried
	cfg.deflect_streak_bonus = 5.0
	
	# HP-based recovery (Sekiro core mechanic)
	cfg.recovery_mult_high_hp = 1.0      # Full recovery at high HP
	cfg.recovery_mult_mid_hp = 0.25      # Much slower at mid HP
	cfg.recovery_mult_low_hp = 0.05      # Nearly stopped at low HP
	cfg.recovery_mult_critical_hp = 0.01 # Basically stopped
	
	cfg.can_do_finisher = false
	
	return cfg


static func create_miniboss_config() -> CombatConfig:
	## Miniboss - tougher posture, requires more sustained pressure
	var cfg = CombatConfig.new()
	
	# Posture - Harder to break
	cfg.posture_max = 120.0              # Higher posture
	cfg.posture_recover_rate = 8.0       # Slower recovery
	cfg.posture_recover_delay = 2.5
	cfg.posture_break_duration = 4.5
	cfg.hit_posture_gain = 12.0          # Takes more to fill
	cfg.parry_posture_spike = 50.0       # But parries are still effective
	cfg.deflect_streak_bonus = 7.0
	
	# HP-based recovery
	cfg.recovery_mult_high_hp = 1.0
	cfg.recovery_mult_mid_hp = 0.20
	cfg.recovery_mult_low_hp = 0.03
	cfg.recovery_mult_critical_hp = 0.005
	
	cfg.can_do_finisher = true           # Has deathblow
	
	return cfg


static func create_boss_config() -> CombatConfig:
	## Boss - highest posture, strictest HP recovery curve
	var cfg = CombatConfig.new()
	
	# Posture - Very hard to break without whittling HP
	cfg.posture_max = 150.0
	cfg.posture_recover_rate = 6.0
	cfg.posture_recover_delay = 3.0
	cfg.posture_break_duration = 5.0
	cfg.hit_posture_gain = 10.0
	cfg.parry_posture_spike = 55.0
	cfg.deflect_streak_bonus = 8.0
	
	# HP-based recovery - must damage HP to prevent recovery
	cfg.recovery_mult_high_hp = 1.0
	cfg.recovery_mult_mid_hp = 0.15
	cfg.recovery_mult_low_hp = 0.02
	cfg.recovery_mult_critical_hp = 0.0  # No recovery at critical HP!
	
	cfg.can_do_finisher = true
	
	return cfg


static func create_fodder_config() -> CombatConfig:
	## Fodder - easy to stagger, simple combat
	var cfg = CombatConfig.new()
	
	cfg.posture_max = 40.0               # Very low posture
	cfg.posture_recover_rate = 5.0
	cfg.posture_recover_delay = 1.5
	cfg.posture_break_duration = 3.0
	cfg.hit_posture_gain = 20.0          # Breaks easily
	cfg.parry_posture_spike = 35.0
	
	# Less strict HP curve
	cfg.recovery_mult_high_hp = 1.0
	cfg.recovery_mult_mid_hp = 0.5
	cfg.recovery_mult_low_hp = 0.2
	cfg.recovery_mult_critical_hp = 0.1
	
	cfg.can_do_finisher = false          # No deathblow, just dies
	
	return cfg


static func create_aggressive_enemy_config() -> CombatConfig:
	## Aggressive enemy - less defensive but also breaks easier
	var cfg = CombatConfig.new()
	
	cfg.posture_max = 60.0               # Lower posture than standard
	cfg.posture_recover_rate = 12.0      # But recovers faster
	cfg.posture_recover_delay = 1.5
	cfg.posture_break_duration = 3.5
	cfg.hit_posture_gain = 18.0
	cfg.parry_posture_spike = 40.0
	
	cfg.recovery_mult_high_hp = 1.0
	cfg.recovery_mult_mid_hp = 0.3
	cfg.recovery_mult_low_hp = 0.08
	cfg.recovery_mult_critical_hp = 0.02
	
	cfg.can_do_finisher = false
	
	return cfg
