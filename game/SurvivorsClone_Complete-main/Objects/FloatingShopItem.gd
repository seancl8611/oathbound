extends Sprite2D
# FloatingShopItem.gd — floating/bobbing shop item with collect animation.

# Motion parameters (tune per item in Inspector)
@export var float_amplitude: float = 4.0           # vertical bob strength
@export var float_speed: float = 2.0               # vertical bob speed
@export var rotation_amplitude_deg: float = 4.0    # ONLY used if use_script_rotation = true
@export var secondary_float_amplitude: float = 2.0 # secondary bob strength
@export var secondary_float_speed: float = 3.3     # secondary bob speed
@export var horizontal_sway: float = 2.0           # side-to-side amount
@export var start_phase: float = 0.0               # phase offset so items aren't in sync

# Visual enhancements
@export var pulse_scale_amount: float = 0.05       # subtle scaling pulse
@export var pulse_speed: float = 1.5

# If true, this script rotates the sprite.
# If false, rotation is left alone (so your AnimationPlayer/frames can handle it).
@export var use_script_rotation: bool = false

# Optional: which animation to auto-play on the child AnimationPlayer.
# If empty, will play the first available animation (if any).
@export var auto_play_anim: StringName = &""

# Collection animation
@export var collect_duration: float = 0.35
@export var collect_height_boost: float = 10.0

var _base_position: Vector2
var _base_scale: Vector2
var _time: float = 0.0
var _collected: bool = false
var _is_player_nearby: bool = false
var _excitement_factor: float = 1.0

@onready var anim_player: AnimationPlayer = get_node_or_null("AnimationPlayer")


func _ready() -> void:
	_base_position = position
	_base_scale = scale
	_time = start_phase

	# Auto-play item animation (rotation, idle, etc.)
	if anim_player:
		if auto_play_anim != &"" and anim_player.has_animation(auto_play_anim):
			anim_player.play(auto_play_anim)
		else:
			var names := anim_player.get_animation_list()
			if names.size() > 0:
				anim_player.play(names[0])


func _process(delta: float) -> void:
	if _collected:
		return

	_time += delta * float_speed

	# Combined motion
	var primary_y := sin(_time) * float_amplitude
	var secondary_y := sin(_time * (secondary_float_speed / float_speed)) * secondary_float_amplitude
	var horizontal_x := sin(_time * 0.7) * horizontal_sway

	var total_offset := Vector2(horizontal_x, primary_y + secondary_y) * _excitement_factor
	position = _base_position + total_offset

	# Optional script-driven rotation
	if use_script_rotation:
		rotation_degrees = sin(_time * 1.1) * rotation_amplitude_deg * _excitement_factor

	# Subtle scale pulse
	var pulse := 1.0 + sin(_time * pulse_speed) * pulse_scale_amount
	scale = _base_scale * pulse


func set_player_nearby(is_nearby: bool) -> void:
	_is_player_nearby = is_nearby
	var tween := create_tween()
	if is_nearby:
		tween.tween_property(self, "_excitement_factor", 1.3, 0.3).set_trans(Tween.TRANS_ELASTIC)
	else:
		tween.tween_property(self, "_excitement_factor", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC)


func play_collect_animation(target_global_pos: Vector2) -> void:
	if _collected:
		return
	_collected = true

	# Stop ambient animation so tween takes full control.
	if anim_player:
		anim_player.stop()

	var tween := create_tween()

	# Phase 1: pop up slightly
	tween.tween_property(self, "position:y", position.y - collect_height_boost, 0.1)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", _base_scale * 1.2, 0.1)

	# Phase 2: fly toward the player
	var remaining = max(collect_duration - 0.1, 0.05)
	tween.tween_property(self, "global_position", target_global_pos, remaining)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	# Spin relative to current rotation (whether it comes from animation or not)
	tween.parallel().tween_property(self, "rotation_degrees", rotation_degrees + 360.0, remaining)

	# Shrink and fade with slight delay
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, remaining - 0.05).set_delay(0.15)
	tween.parallel().tween_property(self, "modulate:a", 0.0, remaining - 0.05).set_delay(0.15)

	_spawn_collection_particles()

	tween.tween_callback(queue_free)


func _spawn_collection_particles() -> void:
	# Placeholder hook for particles.
	pass


func set_dimmed(dimmed: bool) -> void:
	if dimmed:
		modulate = Color(0.5, 0.5, 0.5, 0.2)
	else:
		modulate = Color(1.0, 1.0, 1.0, 1.0)
