extends CharacterBody2D

## =============================================================================
## PLAYER - v7.3 SEKIRO-STYLE GROUNDED COMBAT (STAGGER RECOVERY FIX)
## =============================================================================
## Base Sword Kit Design Rule
##
## The player’s sword kit should be treated as a set of core sword moves, not a rigid combo tree. Quick Slash, Cross Cut, and Heavy Cleave form the basic tap-attack chain, but their purpose is mainly timing/animation/combat variation rather than forcing a strict combo reward. Heavy Cleave is a small reward for successfully stringing taps together, with stronger damage/posture and more recovery.
##
## Hold Attack produces Thrust and should remain available after basic sword attacks when the player intentionally holds the attack input. This prevents the combo system from locking the player out of thrust and keeps the kit responsive. Thrust is balanced by windup, narrow coverage, recovery, and no follow-up chaining.
##
## Dash Slash and Counter Cut are situational sword moves that flow naturally from dash and parry states. The base kit should prioritize readable, responsive sword options over rigid combo restrictions.
## =============================================================================

# =============================================================================
# SIGNALS
# =============================================================================
signal playerdeath
signal combo_hit(hit_index: int, target: Node)
signal perfect_parry_triggered()
signal posture_broken_player()

# =============================================================================
# MOVEMENT - Tight, Responsive, Grounded Feel
# =============================================================================
const BASE_MOVE_SPEED = 120.0
const ACCEL_TIME = 0.04
const DECEL_TIME = 0.03
const STOP_THRESHOLD = 8.0

# =============================================================================
# STEP-DODGE - Quick, Committal
# =============================================================================
const DODGE_DISTANCE = 80.0
const DODGE_DURATION = 0.16
const DODGE_COOLDOWN = 0.40
const DODGE_SPEED = 500.0
const IFRAMES_START = 0.01
const IFRAMES_END = 0.11

# =============================================================================
# ATTACK SYSTEM - Snappy, Clear Phases
# =============================================================================
const MAX_COMBO_HITS = 3

const SWORD_COMBO_PROFILES = [
	{
		"id": "quick_slash",
		"anim": "attack",
		"anim_speed": 1.08,
		"duration": 0.36,
		"startup": 0.055,
		"active": 0.075,
		"recovery": 0.19,
		"queue_start": 0.36,
		"combo_start": 0.46,
		"combo_end": 0.94,
		"cancel_at": 0.80,
		"lunge_start": 0.055,
		"lunge_speed": 34.0,
		"lunge_time": 0.035,
		"damage": 9,
		"posture": 10.0,
		"knockback": 105.0,
		"hitstop": 0.060,
		"hitbox_offset": 19.0,
		"hitbox_shape": "slash_small",
		"hitbox_scale": Vector2(0.90, 0.90),
		"shake": 2.0
	},
	{
		"id": "cross_cut",
		"anim": "attack_2",
		"anim_speed": 0.90,
		"duration": 0.46,
		"startup": 0.085,
		"active": 0.105,
		"recovery": 0.24,
		"queue_start": 0.40,
		"combo_start": 0.50,
		"combo_end": 0.92,
		"cancel_at": 0.84,
		"lunge_start": 0.085,
		"lunge_speed": 46.0,
		"lunge_time": 0.055,
		"damage": 12,
		"posture": 16.0,
		"knockback": 145.0,
		"hitstop": 0.095,
		"hitbox_offset": 23.0,
		"hitbox_shape": "slash_wide",
		"hitbox_scale": Vector2(1.25, 1.08),
		"shake": 4.0
	},
	{
		"id": "heavy_cleave",
		"anim": "attack_3",
		"anim_speed": 0.70,
		"duration": 0.68,
		"startup": 0.180,
		"active": 0.135,
		"recovery": 0.37,
		"queue_start": 1.00,
		"combo_start": 1.00,
		"combo_end": 1.00,
		"cancel_at": 0.94,
		"lunge_start": 0.180,
		"lunge_speed": 24.0,
		"lunge_time": 0.085,
		"damage": 21,
		"posture": 36.0,
		"knockback": 230.0,
		"hitstop": 0.170,
		"hitbox_offset": 28.0,
		"hitbox_shape": "cleave_heavy",
		"hitbox_scale": Vector2(1.55, 1.25),
		"shake": 8.0
	}
]

const COUNTER_CUT_PROFILE = {
	"id": "counter_cut",
	"anim": "counter_cut",
	"anim_speed": 1.25,
	"duration": 0.28,
	"startup": 0.040,
	"active": 0.080,
	"recovery": 0.11,
	"queue_start": 1.00,
	"combo_start": 1.00,
	"combo_end": 1.00,
	"cancel_at": 0.80,
	"lunge_start": 0.040,
	"lunge_speed": 54.0,
	"lunge_time": 0.045,
	"damage": 10,
	"posture": 24.0,
	"knockback": 120.0,
	"hitstop": 0.105,
	"hitbox_offset": 21.0,
	"hitbox_shape": "counter_short",
	"hitbox_scale": Vector2(1.10, 1.00),
	"shake": 4.5,
	"can_combo": false,
	"restart_lockout": 0.10
}

const THRUST_PROFILE = {
	"id": "hold_thrust",
	"anim": "thrust",
	"anim_speed": 0.96,
	"duration": 0.58,
	"startup": 0.135,
	"active": 0.095,
	"recovery": 0.29,
	"queue_start": 1.00,
	"combo_start": 1.00,
	"combo_end": 1.00,
	"cancel_at": 0.90,
	"lunge_start": 0.130,
	"lunge_speed": 76.0,
	"lunge_time": 0.080,
	"damage": 14,
	"posture": 34.0,
	"knockback": 155.0,
	"hitstop": 0.130,
	"hitbox_offset": 30.0,
	"hitbox_shape": "thrust_long",
	"hitbox_scale": Vector2(1.00, 1.00),
	"shake": 5.5,
	"can_combo": false,
	"restart_lockout": 0.18
}

const DASH_SLASH_PROFILE = {
	"id": "dash_slash",
	"anim": "dash_slash",
	"anim_speed": 1.12,
	"duration": 0.40,
	"startup": 0.050,
	"active": 0.085,
	"recovery": 0.20,
	"queue_start": 0.44,
	"combo_start": 0.46,
	"combo_end": 0.96,
	"cancel_at": 0.84,
	"lunge_start": 0.020,
	"lunge_speed": 105.0,
	"lunge_time": 0.110,
	"damage": 9,
	"posture": 14.0,
	"knockback": 125.0,
	"hitstop": 0.070,
	"hitbox_offset": 28.0,
	"hitbox_shape": "dash_forward",
	"hitbox_scale": Vector2(0.95, 1.20),
	"shake": 3.0,
	"can_combo": true,
	"restart_lockout": 0.14
}

var _attack_profile: Dictionary = {}
var _attack_elapsed: float = 0.0
var _attack_hitbox_active: bool = false
var _attack_cancel_available: bool = false
var _combo_attack_queued: bool = false
var _combo_link_timer: float = 0.0
var _queued_combo_index: int = -1
var _pending_combo_input: bool = false
var _queued_attack_profile: Dictionary = {}
var _queued_attack_hold_branch: bool = false
var _pending_thrust_branch: bool = false
var _attack_branch_hold_active: bool = false
var _attack_branch_hold_timer: float = 0.0

# Prevents quick slash spam after a swing or completed combo.
var _attack_restart_lockout: float = 0.0
const COUNTER_CUT_WINDOW = 0.45
var _counter_cut_until: float = -1.0
var _counter_cut_target: Node = null

const HOLD_THRUST_THRESHOLD = 0.20
const HOLD_THRUST_MAX_HOLD = 3.0

var _attack_hold_timer: float = 0.0
var _attack_hold_ready: bool = false

# Longer post-swing window where tap can continue the basic attack chain.
const COMBO_LINK_GRACE = 1.05

const SWORD_RESTART_LOCKOUT = 0.24
const SWORD_FINAL_RESTART_LOCKOUT = 0.42

const INPUT_BUFFER_TIME = 0.15
var _buffered_action = ""
var _buffer_timer = 0.0
var _post_dodge_block_priority_until: float = 0.0
var _wants_block_takeover: bool = false
var _force_block_visual_refresh: bool = false
var _block_release_grace: float = 0.0

# =============================================================================
# PARRY SYSTEM - Sekiro-inspired timing
# =============================================================================
const PARRY_WINDOW = 0.30
const PERFECT_PARRY_WINDOW = 0.12
const PARRY_LOCKOUT = 0.10
const PARRY_SPAM_PENALTY = 0.02
const MAX_SPAM_PENALTY = 2
const BLOCK_POSTURE_MULT = 1.2
const PARRY_GRACE_WINDOW = 0.30        # Auto-parry window after successful parry
const BLOCK_STABILITY_WINDOW = 0.20    # Immunity to posture break after blocking
const BLOCK_DIMINISH_WINDOW = 0.35     # Window for diminishing posture on rapid blocks
const BLOCK_DIMINISH_MULT = 0.5        # Posture multiplier for rapid consecutive blocks
const MAX_BLOCK_POSTURE_PER_HIT = 15.0 # Cap on posture damage per single block

# =============================================================================
# FEEDBACK - Juicy, Impactful
# =============================================================================
const HITSTOP_LIGHT = 0.07
const HITSTOP_MEDIUM = 0.11
const HITSTOP_HEAVY = 0.16
const HITSTOP_PARRY = 0.28
const HITSTOP_POSTURE_BREAK = 0.35
const HITSTOP_BLOCKED = 0.06

const SHAKE_LIGHT = 3.0
const SHAKE_MEDIUM = 5.0
const SHAKE_HEAVY = 8.0
const SHAKE_PARRY = 7.0
const SHAKE_BLOCKED = 2.5

const FINISHER_RADIUS = 75.0

# =============================================================================
# POSTURE BREAK
# =============================================================================
const POSTURE_BREAK_STUN_DURATION = 2.0
const MAX_STUN_DURATION = 10.0  # SAFETY: Absolute max stun time to prevent softlocks
var _stun_started_at: float = 0.0  # Track when stun began for safety check

var _block_anim_started_at: float = -1.0

var _flash_tween: Tween = null
var _base_sprite_modulate = Color.WHITE  # Store the true base color
# =============================================================================
# STATE MACHINE
# =============================================================================
enum State {
	IDLE,
	MOVING,
	ATTACK_HOLD,
	ATTACKING,
	ATTACK_RECOVERY,
	DODGING,
	BLOCKING,
	PARRYING,
	STUNNED,
	DEATHBLOW,
	USING_PROSTHETIC,
	CHAINED
}

var _state = State.IDLE
var _state_timer = 0.0

# =============================================================================
# MOVEMENT STATE
# =============================================================================
var _move_input = Vector2.ZERO
var _facing_dir = Vector2.RIGHT
var _current_speed = 0.0
var _move_velocity = Vector2.ZERO

# =============================================================================
# DODGE STATE
# =============================================================================
var _dodge_dir = Vector2.ZERO
var _dodge_timer = 0.0
var _dodge_cooldown = 0.0
var _is_invincible = false

const DASH_SLASH_GRACE = 0.12
var _dash_slash_until: float = -1.0
var _dash_slash_consumed: bool = false

# =============================================================================
# ATTACK STATE
# =============================================================================
var _combo_index = 0
var _attack_timer = 0.0
var _lunge_timer = 0.0
var _combo_window_open = false
var _attack_hit_this_swing = false
var _attack_aim_dir = Vector2.RIGHT
var _recovery_timer = 0.0
var _attack_started_this_frame = false

# =============================================================================
# PARRY/BLOCK STATE
# =============================================================================
var _parry_active = false
var _parry_timer = 0.0
var _parry_lockout = 0.0
var _perfect_parry_available = true
var _block_held = false
var _parry_spam_count = 0
var _parry_spam_reset_timer = 0.0
var _parry_grace_until: float = 0.0    # Auto-parry window end time
var _block_stability_until: float = 0.0 # Can't posture break until this time
var _last_block_time: float = 0.0      # For detecting rapid blocks
var _consecutive_blocks: int = 0       # Count of rapid consecutive blocks
var _block_anim_completed: bool = false # Tracks if block anim finished at least once

# =============================================================================
# POSTURE/STAGGER
# =============================================================================
var stagger = 0.0
var stagger_max = 100.0
var stagger_regen_rate = 15.0
var stagger_regen_blocked = 8.0
var _stagger_suppress_until = 0.0
var _stun_until = 0.0

var _chain_restrained: bool = false
var _chain_source: Node = null
var _chain_duration: float = 0.0
var _chain_break_action: String = "attack"
var _chain_break_presses: int = 6
var _chain_presses_done: int = 0
var _chain_until: float = 0.0
var _chain_ui: Node2D = null
var _chain_progress_bar: ColorRect = null

# =============================================================================
# HEALTH & COMBAT
# =============================================================================
var hp = 50
var maxhp = 50
var is_invincible = false
var knockback = Vector2.ZERO
var knockback_decay = 18.0

# =============================================================================
# EXPERIENCE
# =============================================================================
var experience = 0
var experience_level = 1
var collected_experience = 0
var time = 0

# FIXED: Changed type from DeathblowSystem to Node (class_name removed)
var _deathblow_system: Node = null

# =============================================================================
# REFERENCES
# =============================================================================
var combat: CombatController
var prosthetic_executor: Node = null
var selected_weapon = "sword"
var current_weapon: Node = null
var sword_damage_mult = 1.0
var sword_attack_speed_mult = 1.0
var sword_knockback_mult = 1.0
var sword_size_mult = 1.0
var run_hud: Node = null

var collected_upgrades = []
var armor = 0
var speed = 0
var heal_multiplier = 1.0
var damage_multiplier = 1.0

var _hitstop_active = false
var _hitstop_timer = 0.0
var _hitstop_offset = Vector2.ZERO

var _db_target: Node = null
var _db_until = -1.0

var _last_move_dir = Vector2.RIGHT
var enemy_close: Array = []
var _shake_tween: Tween = null

# Posture UI - Always visible
var _stagger_ui: Node2D
var _stagger_bg: ColorRect
var _stagger_fill: ColorRect
var _stagger_border: ColorRect

# =============================================================================
# NODE REFERENCES
# =============================================================================
@onready var sprite = $Sprite2D
@onready var animation = $AnimationPlayer
@onready var hurt_box = $HurtBox
@onready var sword_hitbox = get_node_or_null("%SwordHitBox")
@onready var enemy_detection_area = $EnemyDetectionArea2

@onready var healthBar = get_node_or_null("%HealthBar")
@onready var expBar = get_node_or_null("%ExperienceBar")
@onready var gui = get_node_or_null("GUILayer/GUI")

@export var shadow_clone_scene: PackedScene
@export var parry_aoe_radius = 80.0

# =============================================================================
# INITIALIZATION
# =============================================================================

func _ready():
	add_to_group("player")
	
	# FIXED: Look for DeathblowSystem as child node, not autoload
	_deathblow_system = get_node_or_null("DeathblowSystem")
	
	# Connect to deathblow finished signal if system exists
	if _deathblow_system and _deathblow_system.has_signal("deathblow_finished"):
		if not _deathblow_system.is_connected("deathblow_finished", Callable(self, "_on_deathblow_finished")):
			_deathblow_system.connect("deathblow_finished", Callable(self, "_on_deathblow_finished"))
	
	combat = get_node_or_null("Combat")
	if combat == null:
		combat = CombatController.new()
		combat.name = "Combat"
		add_child(combat)
	
	if combat.config == null:
		combat.config = CombatConfig.create_player_config()
	
	# Prosthetic executor
	prosthetic_executor = get_node_or_null("ProstheticExecutor")
	if prosthetic_executor == null:
		var ProstheticExecutorScript = load("res://Scripts/ProstheticExecutor.gd")
		if ProstheticExecutorScript:
			prosthetic_executor = ProstheticExecutorScript.new()
			prosthetic_executor.name = "ProstheticExecutor"
			add_child(prosthetic_executor)
	
	if prosthetic_executor and prosthetic_executor.has_method("setup"):
		prosthetic_executor.setup(self, combat)
		
	_connect_combat_signals()
	
	# Setup hurt box
	if hurt_box:
		if not hurt_box.is_in_group("player_hurtbox"):
			hurt_box.add_to_group("player_hurtbox")
		hurt_box.collision_layer = 2
		hurt_box.monitoring = true
		hurt_box.monitorable = true
		
		var hurt_callable = Callable(self, "_on_hurt")
		if hurt_box.has_signal("hurt"):
			if not hurt_box.is_connected("hurt", hurt_callable):
				hurt_box.connect("hurt", hurt_callable)
	
	if animation and not animation.is_connected("animation_finished", Callable(self, "_on_anim_finished")):
		animation.connect("animation_finished", Callable(self, "_on_anim_finished"))
	
	_setup_stagger_ui()
	_update_health_bar()
	
	# Run HUD (screen-space combat UI)
	var RunHUDScript = load("res://GUI/RunHUD.gd")
	if RunHUDScript:
		run_hud = RunHUDScript.new()
		add_child(run_hud)
		run_hud.setup(self)
	if selected_weapon == "sword":
		_setup_sword()
	
	visible = true
	_base_sprite_modulate = sprite.modulate if sprite else Color.WHITE
	
func _connect_combat_signals():
	if not combat:
		return
	
	# Old action-router signals must not control player actions anymore.
	# player.gd is now the authority for attack, dodge, and parry startup.
	var legacy_action_signals = [
		["attack_started", "_on_combat_attack"],
		["dodge_started", "_on_combat_dodge"],
		["parry_opened", "_on_combat_parry"]
	]
	
	for sig in legacy_action_signals:
		var sig_name = sig[0]
		var method = sig[1]
		if combat.has_signal(sig_name) and combat.is_connected(sig_name, Callable(self, method)):
			combat.disconnect(sig_name, Callable(self, method))
	
	var support_signals = [
		["deathblow_available", "_on_deathblow_available"],
		["deathblow_cleared", "_clear_deathblow"],
		["prosthetic_started", "_on_prosthetic_started"]
	]
	
	for sig in support_signals:
		var sig_name = sig[0]
		var method = sig[1]
		if combat.has_signal(sig_name) and combat.is_connected(sig_name, Callable(self, method)):
			combat.disconnect(sig_name, Callable(self, method))
	
	if combat.has_signal("deathblow_available"):
		combat.deathblow_available.connect(_on_deathblow_available)
	if combat.has_signal("deathblow_cleared"):
		combat.deathblow_cleared.connect(_clear_deathblow)
	if combat.has_signal("prosthetic_started"):
		combat.prosthetic_started.connect(_on_prosthetic_started)

func _setup_stagger_ui():
	_stagger_ui = Node2D.new()
	_stagger_ui.name = "StaggerBar"
	add_child(_stagger_ui)
	_stagger_ui.z_index = 110
	
	_stagger_bg = ColorRect.new()
	_stagger_bg.size = Vector2(60, 6)
	_stagger_bg.color = Color(0.1, 0.1, 0.1, 0.8)
	_stagger_bg.position = Vector2(-30, 0)
	_stagger_ui.add_child(_stagger_bg)
	
	_stagger_border = ColorRect.new()
	_stagger_border.size = Vector2(62, 8)
	_stagger_border.color = Color(0.3, 0.3, 0.3, 0.9)
	_stagger_border.position = Vector2(-31, -1)
	_stagger_border.z_index = -1
	_stagger_ui.add_child(_stagger_border)
	
	_stagger_fill = ColorRect.new()
	_stagger_fill.size = Vector2(0, 6)
	_stagger_fill.color = Color(0.95, 0.7, 0.1, 0.95)
	_stagger_fill.position = Vector2(-30, 0)
	_stagger_ui.add_child(_stagger_fill)
	
	_stagger_ui.position = Vector2(0, -28)
	_stagger_ui.visible = true


func _setup_sword():
	if sword_hitbox:
		sword_hitbox.base_damage = 10
		sword_hitbox.base_posture_damage = 8.0
		sword_hitbox.deactivate_hitbox()


# =============================================================================
# MAIN PHYSICS LOOP
# =============================================================================
func _physics_process(delta: float):
	var now = Time.get_ticks_msec() * 0.001
	
	_attack_started_this_frame = false
	_tick_input_buffer(delta)
	_tick_combo_link(delta)
	
	if _hitstop_active:
		_process_hitstop(delta)
		_late_block_visual_enforce()
		return
	
	if _state == State.STUNNED:
		var stun_elapsed = now - _stun_started_at
		if now >= _stun_until or stun_elapsed > MAX_STUN_DURATION:
			_recover_from_stun()
		else:
			velocity = Vector2.ZERO
			move_and_slide()
			_update_stagger_ui()
			return
	
	if _state == State.CHAINED:
		_state_chained(delta)
		velocity = Vector2.ZERO
		knockback = Vector2.ZERO
		move_and_slide()
		_update_stagger_ui()
		return
	
	_gather_input()
	_process_buffered_input()
	_process_state(delta)
	_apply_block_takeover_if_needed()
	_calculate_velocity(delta)
	move_and_slide()
	
	_tick_cooldowns(delta)
	_tick_stagger(delta)
	_update_stagger_ui()
	_update_combat_controller(delta)
	_update_prosthetic_hud()
	_late_block_visual_enforce()
	
func _gather_input():
	var x = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y = Input.get_action_strength("down") - Input.get_action_strength("up")
	_move_input = Vector2(x, y)
	if _move_input.length() > 1.0:
		_move_input = _move_input.normalized()

	if _move_input.length() > 0.1:
		_last_move_dir = _move_input.normalized()

	_block_held = Input.is_action_pressed("parry")

	if _block_held and _state != State.BLOCKING:
		_wants_block_takeover = true
	elif not _block_held:
		_wants_block_takeover = false

	if _state == State.DEATHBLOW:
		return

	if Input.is_action_just_pressed("attack"):
		_handle_attack_pressed()

	if Input.is_action_just_released("attack"):
		_handle_attack_released()

	if Input.is_action_just_pressed("dash"):
		if _can_start_dodge():
			_start_dodge()
		else:
			_buffer_input("dodge")

	if Input.is_action_just_pressed("parry"):
		if _can_start_parry():
			_start_parry(_get_effective_parry_window())
		else:
			_buffer_input("parry")

	if _block_held:
		if _can_act():
			_start_block()

	if Input.is_action_just_pressed("prosthetic"):
		if _can_act():
			if combat:
				combat.request_prosthetic()
		else:
			_buffer_input("prosthetic")
			
func _apply_block_takeover_if_needed() -> void:
	if not _wants_block_takeover:
		return
	if not Input.is_action_pressed("parry"):
		_wants_block_takeover = false
		return

	# Don’t interrupt locked actions; we only takeover the moment we become actionable.
	if _is_action_locked():
		return
	if _state == State.BLOCKING or _state == State.STUNNED or _state == State.DEATHBLOW:
		return

	# Once we can act, force BLOCKING + block animation (prevents freezing dash/walk frames).
	if _can_act():
		_start_block()

func _buffer_input(action: String):
	_buffered_action = action
	_buffer_timer = INPUT_BUFFER_TIME


func _tick_input_buffer(delta: float):
	if _buffer_timer > 0:
		_buffer_timer -= delta
		if _buffer_timer <= 0:
			_buffered_action = ""

func _process_buffered_input():
	if _buffered_action == "" or _buffer_timer <= 0:
		return
	
	if _buffered_action == "attack":
		_handle_buffered_attack()
		_buffered_action = ""
		_buffer_timer = 0.0

	elif _buffered_action == "dodge" and _can_start_dodge():
		_start_dodge()
		_buffered_action = ""
		_buffer_timer = 0.0

	elif _buffered_action == "parry" and _can_start_parry():
		if Input.is_action_pressed("parry"):
			_start_block()
		else:
			_start_parry(_get_effective_parry_window())
		_buffered_action = ""
		_buffer_timer = 0.0
	
	elif _buffered_action == "prosthetic" and _can_act():
		if combat:
			combat.request_prosthetic()
		_buffered_action = ""
		_buffer_timer = 0.0
		
func _process_state(delta: float):
	match _state:
		State.IDLE:
			_state_idle(delta)
		State.MOVING:
			_state_moving(delta)
		State.ATTACK_HOLD:
			_state_attack_hold(delta)
		State.ATTACKING:
			_state_attacking(delta)
		State.ATTACK_RECOVERY:
			_state_attack_recovery(delta)
		State.DODGING:
			_state_dodging(delta)
		State.BLOCKING:
			_state_blocking(delta)
		State.PARRYING:
			_state_parrying(delta)
		State.STUNNED:
			_state_stunned(delta)
		State.DEATHBLOW:
			_state_deathblow(delta)
		State.CHAINED:
			_state_chained(delta)
		State.USING_PROSTHETIC:
			_state_using_prosthetic(delta)
			
func _state_deathblow(delta: float) -> void:
	# DeathblowSystem is designed to NOT hard-lock the player.
	# We keep actions locked by staying in State.DEATHBLOW, but allow normal movement.

	if _move_input.length() > 0.1:
		_facing_dir = _move_input.normalized()
		_current_speed = move_toward(_current_speed, BASE_MOVE_SPEED, BASE_MOVE_SPEED / ACCEL_TIME * delta)
		_move_velocity = _facing_dir * _current_speed

		_update_sprite_facing(_facing_dir)
		_play_anim("walk")
	else:
		_current_speed = move_toward(_current_speed, 0.0, BASE_MOVE_SPEED / DECEL_TIME * delta)
		_move_velocity = _facing_dir * _current_speed

		_play_anim("idle")

func _state_using_prosthetic(delta: float) -> void:
	_move_velocity = Vector2.ZERO
	_current_speed = 0.0

	# Umbrella visual: subtle blue tint while guarding
	if get_meta("mirror_umbrella_active", false) and sprite:
		sprite.modulate = Color(0.75, 0.85, 1.0)

	if prosthetic_executor == null or not prosthetic_executor.is_using():
		if sprite:
			sprite.modulate = _base_sprite_modulate
		_change_state(State.IDLE)
		
func _on_prosthetic_started() -> void:
	_drop_combo()
	_change_state(State.USING_PROSTHETIC)
	_move_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()
		
func _calculate_velocity(delta: float):
	var final_vel = Vector2.ZERO
	
	if knockback.length() > 1.0:
		final_vel = knockback
		knockback = knockback.move_toward(Vector2.ZERO, knockback_decay * 100.0 * delta)
	else:
		knockback = Vector2.ZERO
	
	match _state:
		State.IDLE, State.MOVING:
			final_vel += _move_velocity

		State.DODGING:
			final_vel = _dodge_dir * DODGE_SPEED

		State.ATTACKING:
			if _is_attack_lunge_active():
				var lunge_speed := float(_attack_profile.get("lunge_speed", 0.0))
				final_vel += _attack_aim_dir * lunge_speed

		State.ATTACK_RECOVERY:
			# Recovery should not create attack-lunge movement.
			# Keep this very low so recovery feels committed.
			final_vel += _move_velocity * 0.12

		State.USING_PROSTHETIC:
			pass
	
	if has_meta("puddle_slow_amount"):
		var slow_amount = get_meta("puddle_slow_amount")
		if slow_amount > 0.0:
			final_vel *= (1.0 - slow_amount)
	
	if has_meta("_mist_raven_boost_until"):
		var boost_until = float(get_meta("_mist_raven_boost_until"))
		var now_mr = Time.get_ticks_msec() * 0.001
		if now_mr < boost_until:
			var boost_amt = float(get_meta("_mist_raven_boost", 0.0))
			var boost_dur = 1.2
			var remaining = boost_until - now_mr
			var decay = remaining / boost_dur
			final_vel *= (1.0 + boost_amt * decay)
		else:
			remove_meta("_mist_raven_boost")
			remove_meta("_mist_raven_boost_until")
			
	velocity = final_vel
	
func _state_idle(delta: float):
	if _move_input.length() > 0.1:
		_change_state(State.MOVING)
		return
	
	_current_speed = move_toward(_current_speed, 0.0, BASE_MOVE_SPEED / DECEL_TIME * delta)
	if _current_speed < STOP_THRESHOLD:
		_current_speed = 0.0
	_move_velocity = _facing_dir * _current_speed
	
	_play_anim("idle")


func _state_moving(delta: float):
	if _move_input.length() < 0.1:
		_change_state(State.IDLE)
		return
	
	_facing_dir = _move_input.normalized()
	_current_speed = move_toward(_current_speed, BASE_MOVE_SPEED, BASE_MOVE_SPEED / ACCEL_TIME * delta)
	_move_velocity = _facing_dir * _current_speed
	
	_update_sprite_facing(_facing_dir)
	_play_anim("walk")

func _state_attack_hold(delta: float):
	_attack_hold_timer += delta
	
	if _attack_hold_timer >= HOLD_THRUST_THRESHOLD:
		_attack_hold_ready = true
	
	# Slight commitment while deciding tap vs hold.
	_current_speed = move_toward(_current_speed, 0.0, BASE_MOVE_SPEED / DECEL_TIME * delta)
	_move_velocity = _facing_dir * _current_speed
	
	# Keep facing toward mouse while holding.
	var aim_dir = (get_global_mouse_position() - global_position).normalized()
	if aim_dir.length() > 0.1:
		_attack_aim_dir = aim_dir
		_update_sprite_facing(_attack_aim_dir)
	
	# Hold-ready visual. Add a "thrust_charge" animation later for best polish.
	if animation:
		if _attack_hold_ready and animation.has_animation("thrust_charge"):
			if animation.current_animation != "thrust_charge":
				animation.play("thrust_charge")
		elif animation.has_animation("idle") and animation.current_animation != "idle":
			animation.play("idle")
	
	# Forced release after max hold.
	if _attack_hold_timer >= HOLD_THRUST_MAX_HOLD:
		_start_thrust()
		return
	
	# Safety fallback in case just_released was missed by input timing.
	if not Input.is_action_pressed("attack"):
		_resolve_attack_hold_release()

func _start_tap_attack_from_hold() -> void:
	var next_combo := 0
	
	# If we are still inside the extended combo-link grace,
	# a tap continues the basic visual chain.
	if _combo_link_timer > 0.0 and _combo_index < MAX_COMBO_HITS - 1:
		next_combo = _combo_index + 1
	
	_start_attack(next_combo)
	
func _state_attacking(delta: float):
	_attack_timer -= delta
	_attack_elapsed += delta

	var duration := float(_attack_profile.get("duration", 0.30))
	var startup := float(_attack_profile.get("startup", 0.06))
	var active := float(_attack_profile.get("active", 0.08))
	var active_end := startup + active

	var combo_start := float(_attack_profile.get("combo_start", 0.50))
	var combo_end := float(_attack_profile.get("combo_end", 0.90))
	var cancel_at := float(_attack_profile.get("cancel_at", 0.60))

	var progress = _attack_elapsed / max(duration, 0.001)

	_process_attack_branch_hold(delta)

	if _pending_thrust_branch and _can_queue_sword_branch():
		_queue_thrust_branch()

	if _pending_combo_input and _can_queue_next_combo_attack():
		_queue_next_combo_attack()

	if not _attack_hitbox_active and _attack_elapsed >= startup and _attack_elapsed <= active_end:
		_activate_current_attack_hitbox()

	if _attack_hitbox_active and _attack_elapsed > active_end:
		_deactivate_current_attack_hitbox()

	_combo_window_open = progress >= combo_start and progress <= combo_end

	if progress >= cancel_at:
		_attack_cancel_available = true
		if combat:
			combat.set_attack_cancel_ok(true)

	if _attack_timer <= 0:
		_end_attack()

func _state_attack_recovery(delta: float):
	_recovery_timer -= delta
	
	_process_attack_branch_hold(delta)
	
	if _pending_thrust_branch and _can_queue_sword_branch():
		_queue_thrust_hold_branch()
	
	if _pending_combo_input and _can_queue_next_combo_attack():
		_queue_next_combo_attack()
	
	if _move_input.length() > 0.1:
		_facing_dir = _move_input.normalized()
		_current_speed = move_toward(_current_speed, BASE_MOVE_SPEED * 0.35, BASE_MOVE_SPEED / ACCEL_TIME * delta)
		_move_velocity = _facing_dir * _current_speed
		_update_sprite_facing(_facing_dir)
	else:
		_current_speed = move_toward(_current_speed, 0.0, BASE_MOVE_SPEED / DECEL_TIME * delta)
		_move_velocity = _facing_dir * _current_speed
	
	if _recovery_timer <= 0:
		# Important polish fix:
		# If the player began holding attack late during recovery, do not drop the input.
		# Carry the held input into ATTACK_HOLD so Dash Slash -> Hold Thrust works without waiting.
		if _attack_branch_hold_active and Input.is_action_pressed("attack"):
			_queued_combo_index = -1
			_queued_attack_profile = {}
			_queued_attack_hold_branch = false
			_combo_attack_queued = false
			_pending_combo_input = false
			_pending_thrust_branch = false
			_clear_attack_branch_hold()
			_start_attack_hold()
			return
		
		if _queued_attack_hold_branch:
			_queued_attack_hold_branch = false
			_queued_attack_profile = {}
			_queued_combo_index = -1
			_combo_attack_queued = false
			_pending_combo_input = false
			_pending_thrust_branch = false
			_clear_attack_branch_hold()
			_start_attack_hold()
			return
		
		if not _queued_attack_profile.is_empty():
			var next_profile := _queued_attack_profile
			_queued_attack_profile = {}
			_queued_combo_index = -1
			_queued_attack_hold_branch = false
			_combo_attack_queued = false
			_pending_combo_input = false
			_pending_thrust_branch = false
			_clear_attack_branch_hold()
			_start_profile_attack(next_profile, 0)
			return
		
		if _queued_combo_index != -1 and _queued_combo_index < MAX_COMBO_HITS:
			var next_combo := _queued_combo_index
			_queued_combo_index = -1
			_queued_attack_profile = {}
			_queued_attack_hold_branch = false
			_combo_attack_queued = false
			_pending_combo_input = false
			_pending_thrust_branch = false
			_clear_attack_branch_hold()
			_start_attack(next_combo)
			return
		
		_queued_combo_index = -1
		_queued_attack_profile = {}
		_queued_attack_hold_branch = false
		_combo_attack_queued = false
		_pending_combo_input = false
		_pending_thrust_branch = false
		_clear_attack_branch_hold()
		
		# If this was the final basic hit, end the chain immediately.
		# Otherwise, preserve _combo_index while COMBO_LINK_GRACE counts down,
		# so a delayed tap can still continue the basic chain.
		if _combo_index >= MAX_COMBO_HITS - 1:
			_attack_restart_lockout = SWORD_FINAL_RESTART_LOCKOUT
			_combo_link_timer = 0.0
			_combo_index = 0
		
		if Input.is_action_pressed("parry"):
			_block_held = true
			_current_speed = 0.0
			_move_velocity = Vector2.ZERO
			_change_state(State.BLOCKING)
			if combat:
				combat.start_block()
			_request_block_visual_refresh()
			return
		
		if _move_input.length() > 0.1:
			_change_state(State.MOVING)
		else:
			_change_state(State.IDLE)
			
func _state_dodging(delta: float):
	_dodge_timer -= delta
	
	var progress = 1.0 - (_dodge_timer / DODGE_DURATION)
	
	if progress >= IFRAMES_START and progress <= IFRAMES_END:
		if not _is_invincible:
			_is_invincible = true
			set_invincibility(true)
	elif _is_invincible and progress > IFRAMES_END:
		_is_invincible = false
		set_invincibility(false)
	
	if _dodge_timer <= 0:
		_end_dodge()

func _ensure_block_anim():
	if animation == null:
		return
	if not animation.has_animation("block"):
		return

	var block_anim = animation.get_animation("block")
	if block_anim == null:
		return
	var len = block_anim.length

	var end_pos = max(0.0, len - 0.001)

	# CHECK THIS FIRST - if already completed, just hold the last frame
	if _block_anim_completed:
		animation.seek(end_pos, true)
		animation.pause()
		return

	# Only now check if we need to switch to block animation
	if animation.current_animation != "block":
		_play_block_animation()
		return

	var pos = animation.current_animation_position

	# If it's playing, catch completion and pause to hold.
	if animation.is_playing():
		if pos >= len - 0.01:
			_block_anim_completed = true
			animation.seek(end_pos, true)
			animation.pause()
		return

	# Not playing:
	# If it was paused mid-way (e.g., hitstop), resume from current position.
	if pos > 0.01 and pos < len - 0.02:
		animation.play()
		return

	# If it stopped at/near the end, treat as complete and hold.
	if pos >= len - 0.01:
		_block_anim_completed = true
		animation.seek(end_pos, true)
		animation.pause()
		
func _state_blocking(delta: float):
	# Debounce release so a 1-frame input drop doesn't end block and restart the anim.
	if Input.is_action_pressed("parry"):
		_block_release_grace = 0.0
		return

	_block_release_grace += delta
	if _block_release_grace >= 0.06:
		_block_held = false
		_end_block()
		
func _state_parrying(delta: float):
	_parry_timer -= delta

	if _parry_timer <= PARRY_WINDOW - PERFECT_PARRY_WINDOW:
		_perfect_parry_available = false

	if _parry_timer <= 0:
		_parry_active = false

		# Use REAL input state (not the event-driven flag)
		if Input.is_action_pressed("parry"):
			_current_speed = 0.0
			_move_velocity = Vector2.ZERO
			_change_state(State.BLOCKING)
			if combat:
				combat.start_block()
			# REMOVED: _request_block_visual_refresh() - block anim already playing from _start_parry()
		else:
			_change_state(State.IDLE)

func _state_stunned(delta: float):
	# Visual feedback during stun
	if sprite:
		var flash = abs(sin(Time.get_ticks_msec() * 0.015)) * 0.3
		sprite.offset = Vector2(randf_range(-2, 2) * flash, 0)

func _recover_from_stun():
	if sprite:
		sprite.offset = Vector2.ZERO
	
	stagger = 0.0
	_stun_until = 0.0
	_stun_started_at = 0.0
	_drop_combo()
	
	_change_state(State.IDLE)
	
	print("[Player] Recovered from stun")

func _change_state(new_state: int):
	var old = _state
	_state = new_state
	_on_state_exit(old)
	_on_state_enter(new_state, old) # NEW

func _on_state_enter(new_state: int, old: int) -> void:
	match new_state:
		State.BLOCKING:
			# If block anim already completed (e.g. during PARRYING with held block), don't restart
			if _block_anim_completed:
				return
			_block_anim_completed = false
			if animation == null or animation.current_animation != "block":
				_request_block_visual_refresh()
				
func _on_state_exit(old: int):
	match old:
		State.ATTACK_HOLD:
			_attack_hold_timer = 0.0
			_attack_hold_ready = false
			_move_velocity = Vector2.ZERO
			
		State.ATTACKING:
			_deactivate_current_attack_hitbox()
			_lunge_timer = 0.0
			_attack_cancel_available = false
			_combo_window_open = false

		State.DODGING:
			_combo_attack_queued = false
			_pending_thrust_branch = false
			_queued_attack_hold_branch = false
			_clear_attack_branch_hold()
			if _is_invincible:
				_is_invincible = false
				set_invincibility(false)
			_clear_dodge_exceptions()

		State.PARRYING:
			_combo_attack_queued = false
			_pending_thrust_branch = false
			_queued_attack_hold_branch = false
			_clear_attack_branch_hold()
			_parry_active = false

		State.ATTACK_RECOVERY:
			_recovery_timer = 0.0
			_move_velocity = Vector2.ZERO

		State.STUNNED:
			_combo_attack_queued = false
			_pending_thrust_branch = false
			_queued_attack_hold_branch = false
			_clear_attack_branch_hold()
			if sprite:
				sprite.offset = Vector2.ZERO

		State.CHAINED:
			_combo_attack_queued = false
			_pending_thrust_branch = false
			_queued_attack_hold_branch = false
			_clear_attack_branch_hold()
			if sprite:
				sprite.offset = Vector2.ZERO
			_destroy_chain_ui()

		State.USING_PROSTHETIC:
			_combo_attack_queued = false
			_pending_thrust_branch = false
			_queued_attack_hold_branch = false
			_clear_attack_branch_hold()

func _get_combo_profile(combo_idx: int) -> Dictionary:
	var idx = clamp(combo_idx, 0, SWORD_COMBO_PROFILES.size() - 1)
	return SWORD_COMBO_PROFILES[idx]

func _is_attack_lunge_active() -> bool:
	if _state != State.ATTACKING:
		return false
	
	if _attack_profile.is_empty():
		return false
	
	var lunge_start := float(_attack_profile.get("lunge_start", _attack_profile.get("startup", 0.06)))
	var lunge_time := float(_attack_profile.get("lunge_time", 0.0))
	
	if lunge_time <= 0.0:
		return false
	
	return _attack_elapsed >= lunge_start and _attack_elapsed <= lunge_start + lunge_time
	
func _get_current_attack_profile() -> Dictionary:
	return _attack_profile

func _can_start_or_continue_combo() -> bool:
	if _state in [State.IDLE, State.MOVING]:
		return _attack_restart_lockout <= 0.0
	
	if _state in [State.ATTACKING, State.ATTACK_RECOVERY]:
		return _can_queue_next_combo_attack()
	
	return false

# =============================================================================
# ATTACK INPUT RESOLVER
# =============================================================================

func _handle_attack_pressed() -> void:
	if _resolve_attack_press():
		return
	
	_buffer_input("attack")


func _handle_attack_released() -> void:
	if _state == State.ATTACK_HOLD:
		_resolve_attack_hold_release()


func _handle_buffered_attack() -> void:
	# Buffered attack should only start actions that are still contextually valid.
	# This prevents stale buffered presses from forcing the wrong move.
	if _try_deathblow():
		return
	
	if _can_start_dash_slash():
		_start_dash_slash()
		return
	
	if _can_start_counter_cut():
		_start_counter_cut()
		return
	
	if _state in [State.IDLE, State.MOVING] and _attack_restart_lockout <= 0.0:
		_begin_neutral_attack_hold()
		return


func _resolve_attack_press() -> bool:
	# Highest priority: finishers.
	if _try_deathblow():
		return true
	
	# Movement-context attack. Dash Slash wins before normal combo/counter routing.
	if _can_start_dash_slash():
		_start_dash_slash()
		return true
	
	# Parry reward.
	if _can_start_counter_cut():
		_start_counter_cut()
		return true
	
	# Current sword flow: tap queues next basic slash, hold branches into thrust.
	if _state in [State.ATTACKING, State.ATTACK_RECOVERY]:
		_begin_current_attack_branch()
		return true
	
	# Prevent fresh attack restart during lockout.
	if _attack_restart_lockout > 0.0:
		return true
	
	# Neutral attack intent: tap release = Quick Slash, hold release = Thrust.
	if _state in [State.IDLE, State.MOVING]:
		_begin_neutral_attack_hold()
		return true
	
	if _can_act():
		_begin_neutral_attack_hold()
		return true
	
	return false


func _resolve_attack_hold_release() -> void:
	if _state != State.ATTACK_HOLD:
		return
	
	if _attack_hold_timer >= HOLD_THRUST_THRESHOLD:
		_start_thrust()
	else:
		_start_tap_attack_from_hold()


func _begin_neutral_attack_hold() -> void:
	_start_attack_hold()


func _begin_current_attack_branch() -> void:
	_begin_attack_branch_hold()
	
func _request_attack_action() -> void:
	_resolve_attack_press()

func _queue_next_combo_attack() -> void:
	if _queued_combo_index != -1:
		return
	
	if not _queued_attack_profile.is_empty():
		return
	
	if _queued_attack_hold_branch:
		return
	
	if _combo_attack_queued:
		return
	
	if _combo_index >= MAX_COMBO_HITS - 1:
		return
	
	_queued_combo_index = _combo_index + 1
	_combo_attack_queued = true
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()

func _begin_attack_branch_hold() -> void:
	if not bool(_attack_profile.get("can_combo", true)):
		return
	
	if _combo_index >= MAX_COMBO_HITS - 1:
		return
	
	if _queued_combo_index != -1:
		return
	
	if not _queued_attack_profile.is_empty():
		return
	
	if _combo_attack_queued:
		return
	
	_attack_branch_hold_active = true
	_attack_branch_hold_timer = 0.0


func _clear_attack_branch_hold() -> void:
	_attack_branch_hold_active = false
	_attack_branch_hold_timer = 0.0

func _process_attack_branch_hold(delta: float) -> void:
	if not _attack_branch_hold_active:
		return
	
	_attack_branch_hold_timer += delta
	
	# Holding long enough converts this branch into a held thrust branch.
	# Important: this does NOT fire thrust yet. It queues ATTACK_HOLD after recovery.
	if Input.is_action_pressed("attack") and _attack_branch_hold_timer >= HOLD_THRUST_THRESHOLD:
		if _can_queue_sword_branch():
			_queue_thrust_hold_branch()
		else:
			_pending_thrust_branch = true
		_clear_attack_branch_hold()
		return
	
	# Releasing before the hold threshold resolves as normal tap combo continuation.
	if not Input.is_action_pressed("attack"):
		if _attack_branch_hold_timer >= HOLD_THRUST_THRESHOLD:
			if _can_queue_sword_branch():
				_queue_thrust_hold_branch()
			else:
				_pending_thrust_branch = true
		else:
			if _can_queue_next_combo_attack():
				_queue_next_combo_attack()
			elif bool(_attack_profile.get("can_combo", true)) and _combo_index < MAX_COMBO_HITS - 1 and _queued_combo_index == -1 and _queued_attack_profile.is_empty() and not _queued_attack_hold_branch and not _combo_attack_queued:
				_pending_combo_input = true
		
		_clear_attack_branch_hold()

func _can_queue_sword_branch() -> bool:
	if _queued_combo_index != -1:
		return false
	
	if not _queued_attack_profile.is_empty():
		return false
	
	if _queued_attack_hold_branch:
		return false
	
	if _combo_attack_queued:
		return false
	
	if _combo_index >= MAX_COMBO_HITS - 1:
		return false
	
	if _attack_profile.is_empty():
		return false
	
	if not bool(_attack_profile.get("can_combo", true)):
		return false
	
	var duration := float(_attack_profile.get("duration", 0.30))
	var queue_start := float(_attack_profile.get("queue_start", 0.40))
	var combo_end := float(_attack_profile.get("combo_end", 1.00))
	var progress = _attack_elapsed / max(duration, 0.001)
	
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	
	return false

func _queue_thrust_branch() -> void:
	_queue_thrust_hold_branch()


func _queue_thrust_hold_branch() -> void:
	if not _can_queue_sword_branch():
		return
	
	_queued_attack_hold_branch = true
	_queued_attack_profile = {}
	_queued_combo_index = -1
	_combo_attack_queued = true
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()
	
func _can_start_dodge() -> bool:
	if _dodge_cooldown > 0.0:
		return false

	if _state in [State.IDLE, State.MOVING]:
		return true

	if _state == State.ATTACKING and _attack_cancel_ok():
		return true

	return false

func _can_start_parry() -> bool:
	if _parry_lockout > 0.0:
		return false

	if _state in [State.IDLE, State.MOVING, State.BLOCKING]:
		return true

	if _state == State.ATTACKING and _attack_cancel_ok():
		return true

	return false

func _attack_cancel_ok() -> bool:
	if _attack_profile.is_empty():
		return false

	var duration := float(_attack_profile.get("duration", 0.30))
	var cancel_at := float(_attack_profile.get("cancel_at", 0.60))
	var progress = _attack_elapsed / max(duration, 0.001)

	return progress >= cancel_at


func _get_effective_parry_window() -> float:
	var base := PARRY_WINDOW

	if combat and combat.config:
		base = combat.config.parry_window_base

	var penalty = min(_parry_spam_count, MAX_SPAM_PENALTY) * PARRY_SPAM_PENALTY
	return max(0.08, base - penalty)

func _drop_combo() -> void:
	_combo_index = 0
	_combo_window_open = false
	_combo_attack_queued = false
	_queued_combo_index = -1
	_queued_attack_profile = {}
	_queued_attack_hold_branch = false
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()
	_combo_link_timer = 0.0
	_attack_restart_lockout = SWORD_RESTART_LOCKOUT
	_attack_hold_timer = 0.0
	_attack_hold_ready = false
	_clear_counter_cut_window()
	_clear_dash_slash_window()

func _tick_combo_link(delta: float) -> void:
	if _combo_link_timer > 0.0:
		_combo_link_timer -= delta
		if _combo_link_timer <= 0.0:
			_combo_link_timer = 0.0
			_combo_index = 0
			_queued_combo_index = -1
			_queued_attack_profile = {}
			_queued_attack_hold_branch = false
			_combo_attack_queued = false
			_pending_combo_input = false
			_pending_thrust_branch = false
			_clear_attack_branch_hold()

func _position_sword_hitbox_for_attack() -> void:
	if not sword_hitbox:
		return

	var angle = round(rad_to_deg(_attack_aim_dir.angle()) / 45.0) * 45.0
	sword_hitbox.rotation_degrees = angle

	var offset_distance := float(_attack_profile.get("hitbox_offset", 20.0))
	var offset = Vector2(cos(deg_to_rad(angle)), sin(deg_to_rad(angle))) * offset_distance
	sword_hitbox.position = offset


func _activate_current_attack_hitbox() -> void:
	if not sword_hitbox:
		return

	_attack_hitbox_active = true

	if sword_hitbox.has_method("activate_for_profile"):
		sword_hitbox.activate_for_profile(_attack_profile, _combo_index)
	else:
		sword_hitbox.activate_for_combo(_combo_index)


func _deactivate_current_attack_hitbox() -> void:
	if not sword_hitbox:
		return

	_attack_hitbox_active = false
	sword_hitbox.deactivate_hitbox()
		
func _can_act() -> bool:
	return _state in [State.IDLE, State.MOVING]

func _is_action_locked() -> bool:
	return _state in [
		State.ATTACK_HOLD,
		State.ATTACKING,
		State.ATTACK_RECOVERY,
		State.DODGING,
		State.STUNNED,
		State.DEATHBLOW,
		State.CHAINED,
		State.USING_PROSTHETIC
	]
	
func _on_combat_attack(combo_index: int):
	if _attack_started_this_frame:
		return
	
	var can_start = false
	
	if _state in [State.IDLE, State.MOVING]:
		can_start = true
	elif _state == State.ATTACKING and _combo_window_open:
		can_start = true
	
	if not can_start:
		return
	
	_attack_started_this_frame = true
	_start_attack(combo_index)


func _on_combat_dodge():
	_start_dodge()


func _on_combat_parry(window_s: float, is_perfect: bool):
	_start_parry(window_s)

func _start_profile_attack(profile: Dictionary, combo_idx: int = 0):
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()
	
	_combo_index = clamp(combo_idx, 0, MAX_COMBO_HITS - 1)
	_attack_profile = profile

	_attack_elapsed = 0.0
	_attack_timer = float(_attack_profile.get("duration", 0.30))
	_lunge_timer = 0.0

	_combo_window_open = false
	_combo_attack_queued = false
	_queued_combo_index = -1
	_queued_attack_profile = {}
	_queued_attack_hold_branch = false
	_pending_combo_input = false
	_pending_thrust_branch = false
	_clear_attack_branch_hold()
	_attack_hitbox_active = false
	_attack_cancel_available = false
	_attack_hit_this_swing = false
	_combo_link_timer = 0.0
	
	_attack_restart_lockout = 0.0
	
	_attack_aim_dir = (get_global_mouse_position() - global_position).normalized()
	if _attack_aim_dir.length() < 0.1:
		_attack_aim_dir = _facing_dir
	
	_update_sprite_facing(_attack_aim_dir)
	
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	
	_position_sword_hitbox_for_attack()
	
	var anim_name := str(_attack_profile.get("anim", "attack"))
	var anim_speed := float(_attack_profile.get("anim_speed", 1.0))

	if animation:
		animation.speed_scale = sword_attack_speed_mult * anim_speed
		if animation.has_animation(anim_name):
			animation.play(anim_name)
		elif anim_name == "dash_slash" and animation.has_animation("dash"):
			animation.play("dash")
		elif anim_name == "thrust" and animation.has_animation("attack"):
			animation.play("attack")
		elif anim_name == "counter_cut" and animation.has_animation("attack"):
			animation.play("attack")
		else:
			animation.play("attack")
	
	print("[Player Attack] combo=", _combo_index, " id=", _attack_profile.get("id", "missing"), " dmg=", _attack_profile.get("damage", -1))
	_change_state(State.ATTACKING)
	
	if combat:
		combat.set_attack_cancel_ok(false)

func _start_attack_hold() -> void:
	# Do not drop combo here. ATTACK_HOLD is an intent resolver:
	# release quickly may continue combo, hold may branch into thrust.
	_clear_counter_cut_window()
	_clear_attack_branch_hold()
	
	_attack_hold_timer = 0.0
	_attack_hold_ready = false
	
	_attack_aim_dir = (get_global_mouse_position() - global_position).normalized()
	if _attack_aim_dir.length() < 0.1:
		_attack_aim_dir = _facing_dir
	
	_update_sprite_facing(_attack_aim_dir)
	
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()
	
	_change_state(State.ATTACK_HOLD)

func _start_thrust() -> void:
	_attack_hold_timer = 0.0
	_attack_hold_ready = false
	_start_profile_attack(THRUST_PROFILE, 0)
		
func _start_attack(combo_idx: int):
	_start_profile_attack(_get_combo_profile(combo_idx), combo_idx)

func _end_attack():
	_deactivate_current_attack_hitbox()
	
	_combo_window_open = false
	_lunge_timer = 0.0
	_attack_cancel_available = false

	if combat:
		combat.set_attack_cancel_ok(false)
	
	var recovery := float(_attack_profile.get("recovery", 0.12))
	_recovery_timer = recovery
	
	if bool(_attack_profile.get("can_combo", true)):
		_combo_link_timer = COMBO_LINK_GRACE
	else:
		_combo_link_timer = 0.0
		_attack_restart_lockout = float(_attack_profile.get("restart_lockout", SWORD_RESTART_LOCKOUT))
	
	_change_state(State.ATTACK_RECOVERY)
	
	if animation:
		animation.speed_scale = 1.0

func _on_attack_hit(target: Node, combo_idx: int):
	if _attack_hit_this_swing:
		return
	_attack_hit_this_swing = true
	
	var hitstop := float(_attack_profile.get("hitstop", HITSTOP_LIGHT))
	var shake := float(_attack_profile.get("shake", SHAKE_LIGHT))
	
	var was_blocked = false
	if target and target.has_method("is_blocking"):
		was_blocked = target.is_blocking()
	
	if was_blocked:
		hitstop = HITSTOP_BLOCKED
		shake = SHAKE_BLOCKED
		if has_method("_spawn_block_sparks"):
			_spawn_block_sparks(target.global_position if target else global_position)
	
	apply_hitstop(hitstop)
	_shake_camera(shake, 0.12)

func _spawn_block_sparks(pos: Vector2):
	var spark = Node2D.new()
	spark.global_position = pos
	get_tree().current_scene.add_child(spark)
	
	for i in range(5):
		var particle = ColorRect.new()
		particle.size = Vector2(3, 3)
		particle.position = Vector2(-1.5, -1.5)
		particle.color = Color(1.0, 0.9, 0.7, 0.9)
		spark.add_child(particle)
		
		var angle = randf() * TAU
		var dist = randf_range(10, 25)
		var end_pos = Vector2(cos(angle), sin(angle)) * dist
		
		var tw = create_tween()
		tw.set_parallel(true)
		tw.tween_property(particle, "position", end_pos, 0.12)
		tw.tween_property(particle, "modulate:a", 0.0, 0.12)
	
	get_tree().create_timer(0.15).timeout.connect(func():
		if is_instance_valid(spark):
			spark.queue_free()
	)


# =============================================================================
# DODGE SYSTEM
# =============================================================================
func _start_dodge():
	_drop_combo()
	
	_dash_slash_consumed = false
	_clear_dash_slash_window()

	if _move_input.length() > 0.1:
		_dodge_dir = _move_input.normalized()
	else:
		_dodge_dir = _facing_dir
	
	_dodge_timer = DODGE_DURATION
	_dodge_cooldown = DODGE_COOLDOWN
	_is_invincible = false
	
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	_lunge_timer = 0.0
	
	_update_sprite_facing(_dodge_dir)
	_play_anim("dash")
	_change_state(State.DODGING)
	_setup_dodge_exceptions()
	
func _end_dodge():
	if _is_invincible:
		_is_invincible = false
		set_invincibility(false)

	_clear_dodge_exceptions()

	# === EMBER: Scorch zone at dash landing point ===
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		se.on_player_dash(global_position)

	var now = Time.get_ticks_msec() * 0.001
	
	# Brief grace where attack still resolves as Dash Slash.
	if not _dash_slash_consumed:
		_dash_slash_until = now + DASH_SLASH_GRACE

	# Brief window after dodge where a held parry press should snap to block anim immediately.
	_post_dodge_block_priority_until = now + 0.25

	if Input.is_action_pressed("parry"):
		_block_held = true
		_current_speed = 0.0
		_move_velocity = Vector2.ZERO
		_change_state(State.BLOCKING)
		if combat:
			combat.start_block()
		_request_block_visual_refresh()
		return

	if _move_input.length() > 0.1:
		_change_state(State.MOVING)
	else:
		_change_state(State.IDLE)
		
func _setup_dodge_exceptions():
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e):
			add_collision_exception_with(e)


func _clear_dodge_exceptions():
	for e in get_tree().get_nodes_in_group("enemy"):
		if is_instance_valid(e):
			remove_collision_exception_with(e)

func _start_parry(window_s: float):
	_drop_combo()
	_clear_counter_cut_window()

	var penalty = min(_parry_spam_count, MAX_SPAM_PENALTY) * PARRY_SPAM_PENALTY
	var effective_window = window_s - penalty
	effective_window = max(effective_window, 0.06)

	_parry_active = true
	_parry_timer = effective_window
	_perfect_parry_available = true

	_parry_spam_count = min(_parry_spam_count + 1, MAX_SPAM_PENALTY + 1)
	_parry_spam_reset_timer = 0.6

	_current_speed = 0.0
	_move_velocity = Vector2.ZERO

	var now = Time.get_ticks_msec() * 0.001
	if now <= _post_dodge_block_priority_until and Input.is_action_pressed("parry"):
		_block_held = true
		_change_state(State.BLOCKING)
		if combat:
			combat.start_block()
		_play_block_animation()
		return

	_change_state(State.PARRYING)

	if Input.is_action_pressed("parry"):
		_play_block_animation()
	else:
		_play_anim("parry")

func _start_block():
	if _state == State.BLOCKING:
		return
	if _is_action_locked():
		return

	_wants_block_takeover = false

	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	_change_state(State.BLOCKING)

	if combat:
		combat.start_block()

	_request_block_visual_refresh() # NEW (instead of _play_block_animation())

func _play_block_animation():
	if animation == null:
		return
	if not animation.has_animation("block"):
		return

	_block_anim_completed = false
	_block_anim_started_at = Time.get_ticks_msec() * 0.001

	animation.clear_queue()
	animation.stop()
	animation.speed_scale = 1.0

	animation.play("block", 0.0, 1.0, false)
	animation.seek(0.0, true)
	animation.advance(0.001) # optional: ensures first pose evaluates immediately

func _end_block():
	if _state != State.BLOCKING:
		return
	
	if combat:
		combat.end_block()
	
	# FIX: Reset animation speed and resume if paused
	if animation:
		animation.speed_scale = 1.0
		if not animation.is_playing():
			animation.play()  # Resume from paused state
	
	if _move_input.length() > 0.1:
		_change_state(State.MOVING)
	else:
		_change_state(State.IDLE)
		
func _on_hurt_box_hurt(dmg: int, dmg_type: String, attacker: Node = null):
	_on_hurt(dmg, dmg_type, attacker)


func _on_hurt(dmg: int, dmg_type: String, attacker: Node = null):
	if is_invincible:
		return
	
	var now = Time.get_ticks_msec() * 0.001
	var atk_pos = global_position
	var is_unblockable = false
	var hit_area: Area2D = null
	
	if attacker is Area2D and attacker.is_in_group("attack"):
		hit_area = attacker
		atk_pos = attacker.global_position
		is_unblockable = hit_area.has_meta("unblockable") and hit_area.get_meta("unblockable")
	elif attacker:
		if "global_position" in attacker:
			atk_pos = attacker.global_position
		is_unblockable = attacker.has_meta("unblockable") and attacker.get_meta("unblockable")
	
	if dmg_type == "grab" or dmg_type == "mass" or dmg_type == "unblockable":
		is_unblockable = true
	
	# Perilous attacks (Sekiro thrust): CAN be parried, CANNOT be blocked
	var is_perilous = (dmg_type == "perilous")
	var can_be_parried = not is_unblockable   # perilous is parryable
	var can_be_blocked = not is_unblockable and not is_perilous
	
	# ==========================================================================
	# MIRROR UMBRELLA — blocks all blockable hits, stores posture for release
	# ==========================================================================
	if get_meta("mirror_umbrella_active", false) and can_be_blocked:
		if prosthetic_executor and prosthetic_executor.has_method("on_umbrella_absorb"):
			prosthetic_executor.on_umbrella_absorb(dmg)
		apply_hitstop(0.06)
		_flash_player(Color(0.5, 0.7, 1.0), 0.08)
		return
		
	# ==========================================================================
	# IRON SHIELD CHECK - Blocks one hit completely, staggers attacker
	# ==========================================================================
	if get_meta("iron_shield_active", false) and can_be_blocked:
		set_meta("iron_shield_active", false)
		
		var attacker_body = null
		if hit_area and hit_area.get_parent() is CharacterBody2D:
			attacker_body = hit_area.get_parent()
		elif attacker is CharacterBody2D:
			attacker_body = attacker
		elif attacker and "global_position" in attacker:
			attacker_body = attacker
		
		if attacker_body and is_instance_valid(attacker_body):
			var shield_posture = 20.0 + get_meta("iron_shield_posture_bonus", 0)
			
			if attacker_body.get("combat") != null:
				attacker_body.combat.add_posture(shield_posture)
			elif attacker_body.has_method("add_posture"):
				attacker_body.add_posture(shield_posture)
			
			if get_meta("iron_shield_counter", false):
				if attacker_body.has_method("take_damage"):
					var counter_event = {
						"damage": 10,
						"posture_damage": 15.0,
						"source": self,
						"prosthetic": true,
					}
					attacker_body.take_damage(counter_event)
		
		if prosthetic_executor and prosthetic_executor.is_using():
			prosthetic_executor._finish_prosthetic()
		
		apply_hitstop(HITSTOP_PARRY)
		_shake_camera(SHAKE_PARRY, 0.08)
		_flash_player(Color(0.6, 0.8, 1.0), 0.1)
		return
	
	# ==========================================================================
	# PARRY GRACE WINDOW - Auto-parry (works on perilous too — Mikiri Counter)
	# ==========================================================================
	if now < _parry_grace_until and can_be_parried:
		_handle_grace_parry(hit_area, attacker, dmg_type, atk_pos)
		return
	
	# PARRY CHECK (active parry input — works on perilous too)
	if _parry_active and can_be_parried:
		var is_perfect = _perfect_parry_available
		_handle_parry_success(hit_area, attacker, dmg_type, atk_pos, is_perfect)
		return
	
	# BLOCK CHECK — perilous bypasses block
	if _state == State.BLOCKING and can_be_blocked:
		_handle_block(hit_area, dmg, dmg_type, attacker, atk_pos)
		return
	
	# AUTO-BLOCK — perilous bypasses this too
	if _state == State.PARRYING and can_be_blocked:
		_handle_block(hit_area, dmg, dmg_type, attacker, atk_pos)
		return
	
	# TAKE DAMAGE — apply hex curse reduction
	var curse_mult = 1.0
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		curse_mult = se.get_curse_damage_mult(attacker)
	var final_dmg = int(max(1, dmg * curse_mult))
	take_damage(final_dmg)
	
	var kb_dir = (global_position - atk_pos).normalized()
	knockback += kb_dir * 120.0
	
	if combat:
		combat.notify_got_hit({"damage": dmg, "type": dmg_type})
		
func _handle_parry_success(area: Area2D, attacker: Node, dmg_type: String, atk_pos: Vector2, is_perfect: bool):
	_parry_active = false
	_parry_spam_count = 0
	
	var hitstop = HITSTOP_PARRY
	if is_perfect:
		hitstop *= 1.2
	
	apply_hitstop(hitstop)
	_shake_camera(SHAKE_PARRY, hitstop + 0.02)
	_spawn_parry_effect(global_position, is_perfect)
	
	if is_perfect:
		_flash_player(Color(1, 1, 0.8), 0.12)
		emit_signal("perfect_parry_triggered")
	else:
		_flash_player(Color(0.9, 0.9, 1.0), 0.08)
	
	_play_anim("parry")
	
	# =========================================================================
	# FIX: DEFLECT PROJECTILES - Check ATTACKER first (that's where arrow is)
	# The 'attacker' parameter is what was passed to the hurt signal (the arrow)
	# The 'area' parameter is our HurtBox that received the collision
	# =========================================================================
	var deflected = false
	
	# Check if attacker (the arrow) is deflectable
	if attacker and is_instance_valid(attacker):
		if attacker.is_in_group("deflectable"):
			if attacker.has_method("deflect"):
				attacker.deflect(self)
				deflected = true
			elif attacker.has_method("_deflect_arrow"):
				attacker._deflect_arrow(self)
				deflected = true
	
	# If not deflected, this was a melee attack - notify attacker
	if not deflected:
		var notify_target = _resolve_attacker(area, attacker)
		if notify_target and notify_target.has_method("on_parried"):
			notify_target.on_parried(global_position)
		if notify_target and notify_target.has_method("hitstop_local"):
			notify_target.hitstop_local(hitstop)
	
	if combat:
		combat.notify_parry_result(true)
	
	# ==========================================================================
	# v7.4: START PARRY GRACE WINDOW
	# ==========================================================================
	var now = Time.get_ticks_msec() * 0.001
	var grace_duration = PARRY_GRACE_WINDOW
	if is_perfect:
		grace_duration *= 1.3
	_parry_grace_until = now + grace_duration
	
	set_invincibility(true)
	get_tree().create_timer(0.12).timeout.connect(func(): 
		if is_instance_valid(self):
			set_invincibility(false)
	)
	
	# === STANCE EFFECTS: trigger on parry ===
	var parry_target = _resolve_attacker(area, attacker)
	if is_instance_valid(parry_target):
		var se = get_node_or_null("/root/StanceEffects")
		if se:
			se.on_player_parry(parry_target, self)

	_open_counter_cut_window(parry_target)
	_parry_lockout = PARRY_LOCKOUT
	
func _handle_grace_parry(area: Area2D, attacker: Node, dmg_type: String, atk_pos: Vector2):
	"""Handle auto-parry during grace window - less flashy than active parry"""
	var hitstop = HITSTOP_PARRY * 0.6
	
	apply_hitstop(hitstop)
	_shake_camera(SHAKE_PARRY * 0.7, hitstop)
	_spawn_parry_effect(global_position, false)
	
	_flash_player(Color(0.85, 0.85, 1.0), 0.06)
	
	# =========================================================================
	# FIX: DEFLECT PROJECTILES IN GRACE WINDOW
	# =========================================================================
	var deflected = false
	
	if attacker and is_instance_valid(attacker):
		if attacker.is_in_group("deflectable"):
			if attacker.has_method("deflect"):
				attacker.deflect(self)
				deflected = true
			elif attacker.has_method("_deflect_arrow"):
				attacker._deflect_arrow(self)
				deflected = true
	
	if not deflected:
		var notify_target = _resolve_attacker(area, attacker)
		if notify_target and notify_target.has_method("on_parried"):
			notify_target.on_parried(global_position)
		if notify_target and notify_target.has_method("hitstop_local"):
			notify_target.hitstop_local(hitstop)
	
	var now = Time.get_ticks_msec() * 0.001
	_parry_grace_until = max(_parry_grace_until, now + PARRY_GRACE_WINDOW * 0.5)
	
	set_invincibility(true)
	get_tree().create_timer(0.08).timeout.connect(func(): 
		if is_instance_valid(self):
			set_invincibility(false)
	)
	
	# === STANCE EFFECTS: trigger on grace parry too ===
	var grace_target = _resolve_attacker(area, attacker)
	if is_instance_valid(grace_target):
		var se = get_node_or_null("/root/StanceEffects")
		if se:
			se.on_player_parry(grace_target, self)
func _handle_block(area: Area2D, dmg: int, dmg_type: String, attacker: Node, atk_pos: Vector2):
	var now = Time.get_ticks_msec() * 0.001
	
	# ==========================================================================
	# v7.4: DETERMINE POSTURE DAMAGE
	# ==========================================================================
	var base_posture = 12.0
	
	if area:
		if area.has_meta("stagger_on_block"):
			base_posture = float(area.get_meta("stagger_on_block"))
		elif area.has_meta("block_posture_damage"):
			base_posture = float(area.get_meta("block_posture_damage"))
	
	# Also check attacker for posture damage metadata (for arrows)
	if attacker and base_posture == 12.0:
		if attacker.has_meta("stagger_on_block"):
			base_posture = float(attacker.get_meta("stagger_on_block"))
		elif attacker.has_meta("block_posture_damage"):
			base_posture = float(attacker.get_meta("block_posture_damage"))
	
	base_posture = min(base_posture, MAX_BLOCK_POSTURE_PER_HIT)
	
	var posture_add = base_posture * BLOCK_POSTURE_MULT
	# Hex curse: reduce block posture damage from cursed enemies
	var se = get_node_or_null("/root/StanceEffects")
	if se:
		posture_add *= se.get_curse_damage_mult(attacker)
	
	# ==========================================================================
	# v7.4: DIMINISHING RETURNS ON RAPID BLOCKS
	# ==========================================================================
	if now - _last_block_time < BLOCK_DIMINISH_WINDOW:
		_consecutive_blocks += 1
		var diminish = pow(BLOCK_DIMINISH_MULT, min(_consecutive_blocks, 3))
		posture_add *= diminish
	else:
		_consecutive_blocks = 0
	
	_last_block_time = now
	
	# ==========================================================================
	# v7.4: BLOCK STABILITY
	# ==========================================================================
	var old_stagger = stagger
	stagger = clamp(stagger + posture_add, 0.0, stagger_max)
	_stagger_suppress_until = now + 0.4
	_block_stability_until = now + BLOCK_STABILITY_WINDOW
	
	apply_hitstop(HITSTOP_BLOCKED)
	_shake_camera(SHAKE_BLOCKED, HITSTOP_BLOCKED)
	_flash_player(Color(0.8, 0.8, 1.0), 0.06)
	
	var kb_dir = (global_position - atk_pos).normalized()
	knockback += kb_dir * 50.0
	
	# =========================================================================
	# FIX: DESTROY BLOCKED PROJECTILES
	# Tell the attacker (arrow) it was blocked so it can despawn
	# =========================================================================
	if attacker and is_instance_valid(attacker):
		if attacker.has_method("on_blocked"):
			attacker.on_blocked()
		elif attacker.is_in_group("enemy_projectile") or attacker.is_in_group("deflectable"):
			# Fallback: just free it if it's a projectile
			attacker.queue_free()
	
	# ==========================================================================
	# v7.4: POSTURE BREAK CHECK
	# ==========================================================================
	if stagger >= stagger_max - 0.001:
		if old_stagger < stagger_max * 0.7:
			_posture_break()
		elif now < _block_stability_until:
			stagger = stagger_max * 0.99
		else:
			_posture_break()
			
func _resolve_attacker(area: Area2D, attacker: Node) -> Node:
	if area and area.has_meta("attacker"):
		var meta = area.get_meta("attacker")
		if is_instance_valid(meta) and meta is Node:
			return meta
	
	if attacker and not (attacker is Area2D):
		return attacker
	
	if attacker and attacker.has_meta("attacker"):
		var meta = attacker.get_meta("attacker")
		if is_instance_valid(meta) and meta is Node:
			return meta
	
	return null


func take_damage(amount: int, show_feedback: bool = true):
	var actual = max(0, amount - armor)
	hp = max(0, hp - actual)
	
	if show_feedback:
		_flash_player(Color(1, 0.3, 0.3), 0.12)
		_shake_camera(SHAKE_MEDIUM, 0.12)
	
	_update_health_bar()
	
	if hp <= 0:
		_die()


func _die():
	emit_signal("playerdeath")


func _posture_break():
	var now = Time.get_ticks_msec() * 0.001
	
	stagger = 0.0
	_stun_until = now + POSTURE_BREAK_STUN_DURATION
	_stun_started_at = now  # FIXED: Track when stun began for safety timeout
	
	_parry_active = false
	_block_held = false
	
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	
	_change_state(State.STUNNED)
	
	apply_hitstop(HITSTOP_POSTURE_BREAK)
	_shake_camera(SHAKE_HEAVY, 0.20)
	
	set_invincibility(true)
	get_tree().create_timer(0.2).timeout.connect(func(): 
		if is_instance_valid(self):
			set_invincibility(false)
	)
	
	_play_anim("hurt")
	emit_signal("posture_broken_player")
	
	print("[Player] Posture broken! Stunned for ", POSTURE_BREAK_STUN_DURATION, " seconds")


# =============================================================================
# DEATHBLOW - FIXED: No longer a coroutine
# =============================================================================

func _on_deathblow_available(target: Node, duration_s: float):
	_db_target = target
	_db_until = Time.get_ticks_msec() * 0.001 + duration_s


func _clear_deathblow():
	_db_target = null
	_db_until = -1.0

func _get_deathblow_target() -> Node:
	var now = Time.get_ticks_msec() * 0.001
	
	# First check if we have a specific target from combat system
	if _db_until > 0 and now < _db_until and is_instance_valid(_db_target):
		var dist = global_position.distance_to(_db_target.global_position)
		if dist <= FINISHER_RADIUS:
			return _db_target
	
	# Otherwise find the CLOSEST deathblow-ready enemy
	var best_target: Node = null
	var best_dist: float = FINISHER_RADIUS
	
	for e in enemy_close:
		if not is_instance_valid(e):
			continue
		
		# Check if this enemy is deathblow ready
		var is_ready = false
		if e.has_method("is_deathblow_ready"):
			is_ready = e.is_deathblow_ready()
		elif e.get("can_be_finished"):
			is_ready = e.can_be_finished
		elif e.get("_dbroken_active"):
			is_ready = e._dbroken_active
		
		if not is_ready:
			continue
		
		# Check distance
		var dist = global_position.distance_to(e.global_position)
		if dist < best_dist:
			best_dist = dist
			best_target = e
	
	return best_target


# The _try_deathblow function is already correct but here it is for reference:

## Starts a deathblow - NOT a coroutine, returns immediately
func _try_deathblow() -> bool:
	var target = _get_deathblow_target()
	if target == null:
		return false
	
	var dist = (target.global_position - global_position).length()
	if dist > FINISHER_RADIUS:
		return false
	
	# Change state immediately
	_change_state(State.DEATHBLOW)
	
	# Use cinematic deathblow system if available
	if _deathblow_system and _deathblow_system.has_method("execute_deathblow"):
		# The system runs asynchronously and will call _on_deathblow_finished when done
		_deathblow_system.execute_deathblow(self, target)
		_clear_deathblow()
		return true
	
	# Fallback: Simple deathblow without cinematic system
	apply_hitstop(0.5)
	_shake_camera(SHAKE_HEAVY, 0.15)
	
	if target.has_method("receive_deathblow"):
		target.receive_deathblow(self)
	elif target.has_method("death"):
		target.death()
	
	_clear_deathblow()
	
	# Return to idle after delay
	get_tree().create_timer(0.4).timeout.connect(func():
		if is_instance_valid(self) and _state == State.DEATHBLOW:
			_change_state(State.IDLE)
	)
	
	return true
	
func _on_deathblow_finished(target) -> void:
	# target can be null or freed
	_clear_deathblow()

	if is_instance_valid(self) and _state == State.DEATHBLOW:
		_change_state(State.IDLE)

func _tick_cooldowns(delta: float):
	if _dodge_cooldown > 0:
		_dodge_cooldown -= delta
	
	if _parry_lockout > 0:
		_parry_lockout -= delta
	
	if _attack_restart_lockout > 0.0:
		_attack_restart_lockout = max(0.0, _attack_restart_lockout - delta)
	
	if _parry_spam_reset_timer > 0:
		_parry_spam_reset_timer -= delta
		if _parry_spam_reset_timer <= 0:
			_parry_spam_count = max(0, _parry_spam_count - 1)
			if _parry_spam_count > 0:
				_parry_spam_reset_timer = 0.6

func _tick_stagger(delta: float):
	var now = Time.get_ticks_msec() * 0.001
	
	if now < _stagger_suppress_until:
		return
	
	# v7.4: Don't regenerate stagger during parry grace window (keeps player engaged)
	if now < _parry_grace_until:
		return
	
	var rate = stagger_regen_rate
	if _state == State.BLOCKING:
		rate = stagger_regen_blocked
	
	stagger = max(0.0, stagger - rate * delta)
	
func _update_stagger_ui():
	if _stagger_ui == null:
		return
	
	_stagger_ui.position = Vector2(0, -28)
	_stagger_ui.visible = true
	
	var pct = clamp(stagger / max(0.001, stagger_max), 0.0, 1.0)
	_stagger_fill.size.x = 60.0 * pct
	_stagger_fill.position.x = -30
	
	var r = 0.95
	var g = 0.7 - (0.5 * pct)
	var b = 0.1
	_stagger_fill.color = Color(r, g, b, 0.95)
	
	if pct > 0.8:
		var flash = abs(sin(Time.get_ticks_msec() * 0.01)) * 0.5
		_stagger_border.color = Color(0.8 + flash * 0.2, 0.3, 0.3, 0.9)
	else:
		_stagger_border.color = Color(0.3, 0.3, 0.3, 0.9)

	if run_hud:
		run_hud.update_posture(stagger, stagger_max)
		
func _update_combat_controller(delta: float):
	if combat == null:
		return
	
	var is_attacking = _state in [State.ATTACKING, State.ATTACK_RECOVERY, State.USING_PROSTHETIC]
	var cancel_ok = false
	
	if _state == State.ATTACKING:
		cancel_ok = _attack_cancel_ok()
	
	var is_dodging = _state == State.DODGING
	var dodge_ready = _dodge_cooldown <= 0 and _state in [State.IDLE, State.MOVING]
	
	combat.update_host_state(is_attacking, cancel_ok, is_dodging, dodge_ready)
	combat.update_health_ratio(hp, maxhp)
	combat.tick(delta)

func _update_health_bar():
	if healthBar:
		healthBar.max_value = maxhp
		healthBar.value = hp
	if run_hud:
		run_hud.update_hp(hp, maxhp)

func _update_prosthetic_hud() -> void:
	if run_hud == null or prosthetic_executor == null:
		return
	
	# Cooldown ring
	if prosthetic_executor.has_method("get_cooldown_pct"):
		run_hud.update_cooldown(prosthetic_executor.get_cooldown_pct())
	
	# Prosthetic info (only refresh when equipped prosthetic changes)
	var current_id = ProstheticManager.equipped_prosthetic_id
	if current_id != run_hud._prosthetic_id:
		if prosthetic_executor.has_method("get_equipped_info"):
			var info = prosthetic_executor.get_equipped_info()
			run_hud.update_prosthetic_info(info.id, info.spirit_cost, info.sockets, info.filled)
			
# =============================================================================
# FEEDBACK SYSTEMS
# =============================================================================

func apply_hitstop(duration: float):
	if duration <= 0:
		return
	
	_hitstop_active = true
	_hitstop_timer = duration
	
	if animation:
		animation.pause()

func _process_hitstop(delta: float):
	_hitstop_timer -= delta

	_hitstop_offset = Vector2(randf_range(-1.5, 1.5), randf_range(-1.5, 1.5))
	if sprite:
		sprite.offset = _hitstop_offset

	# FIX: If we're blocking during hitstop, ensure the PAUSED pose is the block animation
	# (not the previous dash/attack last frame).
	if _state == State.BLOCKING and Input.is_action_pressed("parry"):
		if animation and animation.has_animation("block") and animation.current_animation != "block":
			animation.clear_queue()
			animation.stop()
			animation.speed_scale = 1.0
			animation.play("block", 0.0, 1.0, false)
			# FIX: These two lines were MISSING - must seek+advance BEFORE pause!
			animation.seek(0.0, true)
			animation.advance(0.001)  # Force track evaluation while still "playing"
			animation.pause()  # NOW pause, after pose is applied
			_force_block_visual_refresh = true

	if _hitstop_timer <= 0:
		_hitstop_active = false
		if sprite:
			sprite.offset = Vector2.ZERO

		var holding_block := Input.is_action_pressed("parry")

		# If we are blocking and holding block, do NOT resume the old anim.
		# Let late enforcement keep/restore block visuals.
		if _state == State.BLOCKING and holding_block:
			_force_block_visual_refresh = true
		else:
			if animation:
				animation.play()

		_block_held = holding_block

		if _state == State.BLOCKING and not _block_held:
			_end_block()
			
func _shake_camera(intensity: float, duration: float):
	var cam = get_node_or_null("Camera2D")
	if cam == null:
		return
	
	if _shake_tween and _shake_tween.is_valid():
		_shake_tween.kill()
		cam.offset = Vector2.ZERO
	
	_shake_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	var steps = 6
	for i in range(steps):
		var decay = 1.0 - (float(i) / steps)
		var jitter = Vector2(
			randf_range(-intensity, intensity) * decay,
			randf_range(-intensity, intensity) * decay
		)
		_shake_tween.tween_property(cam, "offset", jitter, duration / steps)
	
	_shake_tween.tween_property(cam, "offset", Vector2.ZERO, duration / steps)

func _flash_player(color: Color, duration: float):
	if sprite == null:
		return
	
	# Cancel any existing flash to prevent color corruption
	if _flash_tween and _flash_tween.is_valid():
		_flash_tween.kill()
	
	# Apply the flash color
	sprite.modulate = color
	
	# Create a new tween to restore the base color
	_flash_tween = create_tween()
	_flash_tween.tween_interval(duration)
	_flash_tween.tween_callback(func():
		if is_instance_valid(sprite):
			# Always restore to the known base color
			sprite.modulate = _base_sprite_modulate
	)
	
func _spawn_parry_effect(pos: Vector2, is_perfect: bool):
	var ring = Node2D.new()
	ring.global_position = pos
	get_tree().current_scene.add_child(ring)
	
	var circle = ColorRect.new()
	circle.size = Vector2(32, 32)
	circle.position = Vector2(-16, -16)
	circle.color = Color(1, 0.9, 0.5, 0.8) if is_perfect else Color(0.8, 0.8, 1, 0.6)
	ring.add_child(circle)
	
	var tw = create_tween()
	tw.set_parallel(true)
	tw.tween_property(ring, "scale", Vector2(3, 3), 0.15)
	tw.tween_property(circle, "color:a", 0.0, 0.15)
	tw.chain().tween_callback(func():
		if is_instance_valid(ring):
			ring.queue_free()
	)


# =============================================================================
# UTILITIES
# =============================================================================

func _update_sprite_facing(direction: Vector2):
	if sprite and abs(direction.x) > 0.01:
		sprite.flip_h = direction.x < 0


func _play_anim(anim_name: String):
	if animation == null:
		return
	if not animation.has_animation(anim_name):
		return
	if animation.current_animation == anim_name and animation.is_playing():
		return
	animation.play(anim_name)

func _on_anim_finished(anim_name: String):
	if anim_name.begins_with("attack"):
		# Sword attack timing is controlled by SWORD_COMBO_PROFILES, not animation length.
		# Do not call _end_attack() here, or shorter animations can skip active frames.
		return

	elif anim_name == "parry":
		if _state == State.PARRYING:
			if Input.is_action_pressed("parry"):
				_current_speed = 0.0
				_move_velocity = Vector2.ZERO
				_change_state(State.BLOCKING)
				if combat:
					combat.start_block()
				_request_block_visual_refresh() # IMPORTANT
			else:
				_change_state(State.IDLE)

	elif anim_name == "dash":
		# No special-case needed; late enforcement + takeover handles it.
		pass

	elif anim_name == "hurt":
		if _state != State.STUNNED:
			_change_state(State.IDLE)

	elif anim_name == "block":
		_block_anim_completed = true
		if animation and animation.has_animation("block"):
			var len = animation.get_animation("block").length
			var end_pos = max(0.0, len - 0.001)
			animation.seek(end_pos, true)
			animation.pause()
		if animation:
			animation.speed_scale = 1.0

func set_invincibility(value: bool):
	is_invincible = value


func cleanup_enemy_list():
	enemy_close = enemy_close.filter(func(e): return is_instance_valid(e))


# =============================================================================
# ENEMY DETECTION
# =============================================================================

func _on_enemy_detection_area_body_entered(body):
	if body.is_in_group("enemy") and not enemy_close.has(body):
		enemy_close.append(body)


func _on_enemy_detection_area_body_exited(body):
	if body in enemy_close:
		enemy_close.erase(body)


func _on_enemy_detection_area2_body_entered(body):
	_on_enemy_detection_area_body_entered(body)


func _on_enemy_detection_area2_body_exited(body):
	_on_enemy_detection_area_body_exited(body)


# =============================================================================
# GRAB AREA (COLLECTIBLES)
# =============================================================================

func _on_grab_area_area_entered(area: Area2D):
	if area == null:
		return
	
	if area.is_in_group("experience"):
		if area.has_method("collect"):
			area.collect()
		elif area.has_method("queue_free"):
			var exp_value = 1
			if area.has_meta("experience_value"):
				exp_value = area.get_meta("experience_value")
			elif "experience_value" in area:
				exp_value = area.experience_value
			collected_experience += exp_value
			area.queue_free()
	
	if area.is_in_group("collectible") or area.is_in_group("pickup"):
		if area.has_method("collect"):
			area.collect(self)
		elif area.has_method("on_collected"):
			area.on_collected(self)


func _on_grab_area_area_exited(area: Area2D):
	pass


func _on_collect_area_area_entered(area: Area2D):
	_on_grab_area_area_entered(area)


func _on_collect_area_area_exited(area: Area2D):
	pass


# =============================================================================
# PUBLIC API
# =============================================================================

func get_facing_direction() -> Vector2:
	return _facing_dir

func heal(amount: int) -> void:
	if amount <= 0:
		return
	hp = min(maxhp, hp + amount)
	_update_health_bar()
	
func get_current_state() -> int:
	return _state


func is_attacking() -> bool:
	return _state == State.ATTACKING


func is_parrying() -> bool:
	return _parry_active or _state == State.PARRYING
	
func is_blocking() -> bool:
	return _state == State.BLOCKING


func is_dodging() -> bool:
	return _state == State.DODGING


func get_combo_index() -> int:
	return _combo_index


func calculate_experiencecap() -> int:
	return 100 + (experience_level - 1) * 50


func set_expbar(current: int, cap: int):
	if expBar:
		expBar.max_value = cap
		expBar.value = current

func _get_effective_move_speed() -> float:
	var base_speed = BASE_MOVE_SPEED
	# Check for puddle slow effect
	var puddle_slow = get_meta("puddle_slow_amount", 0.0)
	if puddle_slow > 0.0:
		base_speed *= (1.0 - puddle_slow)
	return base_speed

func _request_block_visual_refresh() -> void:
	_force_block_visual_refresh = true

func _late_block_visual_enforce() -> void:
	if _state != State.BLOCKING or not Input.is_action_pressed("parry"):
		_force_block_visual_refresh = false
		return

	if _force_block_visual_refresh:
		_force_block_visual_refresh = false
		_play_block_animation()
	else:
		_ensure_block_anim()

# =============================================================================
# CHAIN RESTRAINT SYSTEM
# =============================================================================

func apply_chain_restrain(source: Node, duration: float, break_action: String = "attack", break_presses: int = 6) -> void:
	# Don't chain if already chained, invincible, or in certain states
	if _chain_restrained:
		return
	if is_invincible:
		return
	if _state == State.DODGING:
		return
	if _state == State.DEATHBLOW:
		return
	
	var now = Time.get_ticks_msec() * 0.001
	
	_chain_restrained = true
	_chain_source = source
	_chain_duration = duration
	_chain_break_action = break_action
	_chain_break_presses = max(1, break_presses)
	_chain_presses_done = 0
	_chain_until = now + duration
	
	# Cancel any current action
	_parry_active = false
	_block_held = false
	_combo_window_open = false
	
	if sword_hitbox:
		sword_hitbox.deactivate_hitbox()
	
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	
	_change_state(State.CHAINED)
	
	# Visual feedback
	_flash_player(Color(0.6, 0.4, 0.8), 0.15)
	_shake_camera(SHAKE_MEDIUM, 0.1)
	
	# Create chain UI
	_create_chain_ui()
	
	print("[Player] Chained by ", source.name if source else "unknown", " for ", duration, "s - mash ", break_action, " to escape!")


func _create_chain_ui() -> void:
	# Clean up old UI if exists
	if _chain_ui and is_instance_valid(_chain_ui):
		_chain_ui.queue_free()
	
	_chain_ui = Node2D.new()
	_chain_ui.name = "ChainBreakUI"
	add_child(_chain_ui)
	_chain_ui.z_index = 120
	_chain_ui.position = Vector2(0, -45)
	
	# Background bar
	var bg = ColorRect.new()
	bg.size = Vector2(50, 8)
	bg.color = Color(0.15, 0.1, 0.2, 0.9)
	bg.position = Vector2(-25, 0)
	_chain_ui.add_child(bg)
	
	# Progress bar (fills as player mashes)
	_chain_progress_bar = ColorRect.new()
	_chain_progress_bar.size = Vector2(0, 8)
	_chain_progress_bar.color = Color(0.8, 0.5, 1.0, 1.0)
	_chain_progress_bar.position = Vector2(-25, 0)
	_chain_ui.add_child(_chain_progress_bar)
	
	# Border
	var border = ColorRect.new()
	border.size = Vector2(52, 10)
	border.color = Color(0.5, 0.3, 0.6, 0.9)
	border.position = Vector2(-26, -1)
	border.z_index = -1
	_chain_ui.add_child(border)
	
	# "MASH!" label
	var label = Label.new()
	label.text = "MASH!"
	label.add_theme_font_size_override("font_size", 10)
	label.position = Vector2(-18, -18)
	_chain_ui.add_child(label)


func _update_chain_ui() -> void:
	if _chain_ui == null or not is_instance_valid(_chain_ui):
		return
	if _chain_progress_bar == null:
		return
	
	var progress = float(_chain_presses_done) / float(_chain_break_presses)
	_chain_progress_bar.size.x = 50.0 * clamp(progress, 0.0, 1.0)
	
	# Pulse the bar color based on progress
	var pulse = abs(sin(Time.get_ticks_msec() * 0.01)) * 0.3
	_chain_progress_bar.color = Color(0.8 + pulse, 0.5, 1.0, 1.0)


func _destroy_chain_ui() -> void:
	if _chain_ui and is_instance_valid(_chain_ui):
		_chain_ui.queue_free()
		_chain_ui = null
	_chain_progress_bar = null


func _state_chained(delta: float) -> void:
	var now = Time.get_ticks_msec() * 0.001
	
	# Visual shake while chained
	if sprite:
		var shake_amt = 2.0 * (1.0 - float(_chain_presses_done) / float(_chain_break_presses))
		sprite.offset = Vector2(randf_range(-shake_amt, shake_amt), 0)
	
	# Check for mash input
	if Input.is_action_just_pressed(_chain_break_action):
		_chain_presses_done += 1
		
		# Small feedback per press
		_flash_player(Color(0.9, 0.8, 1.0), 0.05)
		
		# Check if broke free
		if _chain_presses_done >= _chain_break_presses:
			_break_chain_early()
			return
	
	# Update UI
	_update_chain_ui()
	
	# Time expired - auto break
	if now >= _chain_until:
		_end_chain_restraint()


func _break_chain_early() -> void:
	print("[Player] Broke free from chains!")
	
	# Notify the source (Warden) that chain was broken
	if is_instance_valid(_chain_source) and _chain_source.has_method("on_chain_broken"):
		_chain_source.on_chain_broken(self)
	
	# Big feedback for breaking free
	_flash_player(Color(1.0, 1.0, 0.8), 0.15)
	_shake_camera(SHAKE_LIGHT, 0.08)
	
	_end_chain_restraint()


func _end_chain_restraint() -> void:
	_chain_restrained = false
	_chain_source = null
	_chain_presses_done = 0
	_chain_until = 0.0
	
	if sprite:
		sprite.offset = Vector2.ZERO
	
	_destroy_chain_ui()
	
	_change_state(State.IDLE)


func is_chained() -> bool:
	return _chain_restrained

func _can_queue_next_combo_attack() -> bool:
	if _queued_combo_index != -1:
		return false
	
	if not _queued_attack_profile.is_empty():
		return false
	
	if _queued_attack_hold_branch:
		return false
	
	if _combo_attack_queued:
		return false
	
	if _combo_index >= MAX_COMBO_HITS - 1:
		return false
	
	if _attack_profile.is_empty():
		return false
	
	if not bool(_attack_profile.get("can_combo", true)):
		return false
	
	var duration := float(_attack_profile.get("duration", 0.30))
	var queue_start := float(_attack_profile.get("queue_start", 0.40))
	var combo_end := float(_attack_profile.get("combo_end", 1.00))
	var progress = _attack_elapsed / max(duration, 0.001)
	
	if _state == State.ATTACKING:
		return progress >= queue_start and progress <= combo_end
	
	if _state == State.ATTACK_RECOVERY:
		return _combo_link_timer > 0.0
	
	return false
	
func _open_counter_cut_window(target: Node = null) -> void:
	_counter_cut_until = Time.get_ticks_msec() * 0.001 + COUNTER_CUT_WINDOW
	_counter_cut_target = target


func _clear_counter_cut_window() -> void:
	_counter_cut_until = -1.0
	_counter_cut_target = null


func _can_start_counter_cut() -> bool:
	var now := Time.get_ticks_msec() * 0.001
	
	if now > _counter_cut_until:
		return false
	
	if _state in [State.STUNNED, State.DEATHBLOW, State.DODGING, State.CHAINED, State.USING_PROSTHETIC]:
		return false
	
	if _state in [State.ATTACKING, State.ATTACK_RECOVERY]:
		return false
	
	return true


func _start_counter_cut() -> void:
	if _state == State.BLOCKING and combat:
		combat.end_block()
	
	_parry_active = false
	_block_held = false
	_wants_block_takeover = false
	
	_clear_counter_cut_window()
	_start_profile_attack(COUNTER_CUT_PROFILE, 0)

func _clear_dash_slash_window() -> void:
	_dash_slash_until = -1.0


func _can_start_dash_slash() -> bool:
	if selected_weapon != "sword":
		return false
	
	if _dash_slash_consumed:
		return false
	
	if _state in [State.STUNNED, State.DEATHBLOW, State.CHAINED, State.USING_PROSTHETIC]:
		return false
	
	var now := Time.get_ticks_msec() * 0.001
	
	# During the dodge itself.
	if _state == State.DODGING:
		return true
	
	# Brief grace after dodge ends.
	if _state in [State.IDLE, State.MOVING] and now <= _dash_slash_until:
		return true
	
	return false


func _start_dash_slash() -> void:
	if not _can_start_dash_slash():
		return
	
	_dash_slash_consumed = true
	_clear_dash_slash_window()
	
	# Consume the dodge state immediately.
	_dodge_timer = 0.0
	
	if _is_invincible:
		_is_invincible = false
		set_invincibility(false)
	
	_clear_dodge_exceptions()
	
	_current_speed = 0.0
	_move_velocity = Vector2.ZERO
	velocity = Vector2.ZERO
	
	# Dash Slash counts as combo slot 0.
	# Follow-up tap routes into Cross Cut, then Heavy Cleave.
	_start_profile_attack(DASH_SLASH_PROFILE, 0)
