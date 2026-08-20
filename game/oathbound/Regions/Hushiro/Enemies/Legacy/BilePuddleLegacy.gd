extends Area2D

@export var lifetime: float = 3.5        # seconds the puddle stays
@export var radius: float = 56.0         # visual + hit radius
@export var tick: float = 0.25           # seconds between DoT ticks
@export var damage_per_tick: float = 0.5 # HP per tick
@export var posture_per_tick: float = 2.0
@export var slow_pct: float = 0.25       # optional; carried in pulse meta
@export var attacker: Node

var _dmg_accum: float = 0.0

# Layers: enemy attack vs player HurtBox (match your existing melee/hitboxes)
const HIT_LAYER := 2
const HIT_MASK  := 4

var _life_timer: Timer
var _tick_timer: Timer
var _shape: CollisionShape2D

func _ready() -> void:
	add_to_group("puddle_hazard")

	# Ensure a Circle shape exists, sized to 'radius'
	_shape = get_node_or_null("CollisionShape2D")
	if _shape == null:
		_shape = CollisionShape2D.new()
		_shape.name = "CollisionShape2D"
		add_child(_shape)
	if _shape.shape == null or not (_shape.shape is CircleShape2D):
		_shape.shape = CircleShape2D.new()
	(_shape.shape as CircleShape2D).radius = radius

	# Root Area2D should be visible in debug shapes and present in physics,
	# but NOT deal damage by itself (no 'attack' group on the root).
	monitoring = true
	monitorable = true
	# Put the root on a normal enemy-attack layer so you can SEE its circle.
	# (HurtBox only reacts to Areas in group "attack", which this root is not.)
	for i in range(1, 21):
		set_collision_layer_value(i, false)
		set_collision_mask_value(i, false)
	set_collision_layer_value(HIT_LAYER, true)  # layer 2 visible in debug
	set_collision_mask_value(4, true)          # can overlap the player's layer for debug

	# Timers
	_life_timer = Timer.new()
	_life_timer.one_shot = true
	_life_timer.wait_time = lifetime
	add_child(_life_timer)
	_life_timer.timeout.connect(queue_free)
	_life_timer.start()

	_tick_timer = Timer.new()
	_tick_timer.one_shot = false
	_tick_timer.wait_time = tick
	add_child(_tick_timer)
	_tick_timer.timeout.connect(_emit_tick_pulse)
	_tick_timer.start()

func _emit_tick_pulse() -> void:
	# accumulate fractional damage → emit whole points
	_dmg_accum += damage_per_tick
	var deal := int(floor(_dmg_accum))
	if deal >= 1:
		_dmg_accum -= float(deal)
	else:
		deal = 0  # still emit so slow/posture apply

	var pulse := Area2D.new()
	pulse.name = "PuddlePulse"
	pulse.global_position = global_position
	pulse.monitoring = true
	pulse.monitorable = true

	# Layer/mask so the player's HurtBox (layer 4, mask includes 2) sees it
	for i in range(1, 21):
		pulse.set_collision_layer_value(i, false)
		pulse.set_collision_mask_value(i, false)
	pulse.set_collision_layer_value(HIT_LAYER, true)  # layer 2 = enemy attack
	pulse.set_collision_mask_value(4, true)           # collide with player layer

	pulse.add_to_group("attack")

	# metadata consumed by player hurtbox
	if attacker and is_instance_valid(attacker):
		pulse.set_meta("attacker", attacker)
	pulse.set_meta("damage", deal)                 # integer-safe
	pulse.set_meta("damage_type", "puddle")        # HurtBox passes this to player
	pulse.set_meta("attack_type", "puddle")        # we’ll key off this to skip parry grace
	pulse.set_meta("projectile", true)
	pulse.set_meta("telegraphed", false)
	pulse.set_meta("parryable", false)
	pulse.set_meta("posture", posture_per_tick)
	pulse.set_meta("slow_pct", slow_pct)

	# collision shape = puddle radius
	var cs := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	cs.shape = circle
	pulse.add_child(cs)

	# Parent under the puddle to keep transforms tidy
	add_child(pulse)

	# Keep alive briefly so overlap is guaranteed & visible in debug
	get_tree().create_timer(0.12).timeout.connect(pulse.queue_free)

func _exit_tree() -> void:
	# Clean timers if needed
	if is_instance_valid(_life_timer):
		_life_timer.stop()
	if is_instance_valid(_tick_timer):
		_tick_timer.stop()
