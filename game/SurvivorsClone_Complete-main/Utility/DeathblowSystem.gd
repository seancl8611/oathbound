extends Node

## =============================================================================
## DEATHBLOW SYSTEM v4.2 - DYNAMIC SLASH FINISHER
## =============================================================================
## Redesigned for fast, satisfying finishers:
## - NO player position lock - player keeps full movement control
## - MULTIPLE slash patterns for visual variety
## - Gold/crimson color scheme for Sekiro-style impact
## - Instant kill with satisfying feedback
## - Works consistently across all enemy types
## =============================================================================

# =============================================================================
# SIGNALS
# =============================================================================
signal deathblow_started(target)
signal deathblow_finished(target)
signal execution_impact()

# =============================================================================
# CONFIGURATION
# =============================================================================
@export_group("Execution Timing")
@export var slash_duration: float = 0.14      # Brief slash animation time
@export var hitstop_duration: float = 0.12    # Short freeze on impact
@export var invincibility_time: float = 0.25  # Brief i-frames during finisher

@export_group("Effects")
@export var shake_intensity: float = 12.0
@export var shake_duration: float = 0.18
@export var flash_color: Color = Color(1.0, 0.85, 0.4, 0.5)  # Golden flash
@export var flash_duration: float = 0.08

# Slash colors - Sekiro-inspired gold/crimson
@export var slash_color_primary: Color = Color(1.0, 0.9, 0.5, 1.0)    # Bright gold
@export var slash_color_secondary: Color = Color(1.0, 0.7, 0.3, 0.9)  # Orange gold
@export var slash_color_accent: Color = Color(0.9, 0.2, 0.1, 0.8)     # Blood red accent

# =============================================================================
# STATE
# =============================================================================
var _is_executing: bool = false
var _current_target: Node = null
var _flash_overlay: ColorRect = null
var _canvas_layer: CanvasLayer = null
var _slash_pattern_index: int = 0

# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready() -> void:
	_setup_flash_overlay()
	print("[DeathblowSystem] v4.2 - Dynamic Slash Finisher")


func _setup_flash_overlay() -> void:
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 100
	add_child(_canvas_layer)
	
	_flash_overlay = ColorRect.new()
	_flash_overlay.name = "FlashOverlay"
	_flash_overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_flash_overlay.set_anchors_preset(Control.PRESET_FULL_RECT)
	_flash_overlay.color = Color(1, 1, 1, 0)
	_flash_overlay.visible = false
	_canvas_layer.add_child(_flash_overlay)


# =============================================================================
# PUBLIC API
# =============================================================================

func execute_deathblow(player: Node2D, target: Node2D) -> void:
	if _is_executing:
		return
	
	if not is_instance_valid(player):
		emit_signal("deathblow_finished", null)
		return
	
	if not is_instance_valid(target):
		emit_signal("deathblow_finished", null)
		return
	
	_is_executing = true
	_current_target = target
	
	emit_signal("deathblow_started", target)
	
	_set_player_invincible(player, true)
	_run_quick_slash(player, target)


func is_executing() -> bool:
	return _is_executing


func get_best_target(player: Node2D, candidates: Array, max_range: float = 80.0) -> Node:
	if not is_instance_valid(player):
		return null
	
	var best_target: Node = null
	var best_dist: float = max_range
	
	for candidate in candidates:
		if not is_instance_valid(candidate):
			continue
		
		var is_ready = false
		if candidate.has_method("is_deathblow_ready"):
			is_ready = candidate.is_deathblow_ready()
		elif candidate.get("can_be_finished"):
			is_ready = candidate.can_be_finished
		elif candidate.get("_dbroken_active"):
			is_ready = candidate._dbroken_active
		
		if not is_ready:
			continue
		
		var dist = player.global_position.distance_to(candidate.global_position)
		if dist < best_dist:
			best_dist = dist
			best_target = candidate
	
	return best_target


# =============================================================================
# QUICK SLASH EXECUTION
# =============================================================================

func _run_quick_slash(player: Node2D, target: Node2D) -> void:
	# Cycle through slash patterns for variety
	_slash_pattern_index = (_slash_pattern_index + 1) % 4
	
	# Spawn slash effect based on pattern
	_spawn_slash_effect(player, target, _slash_pattern_index)
	
	# Screen effects
	_do_screen_flash()
	_do_screen_shake()
	
	# Brief hitstop for impact
	if hitstop_duration > 0:
		get_tree().paused = true
		await get_tree().create_timer(hitstop_duration, true, false, true).timeout
		get_tree().paused = false
	
	emit_signal("execution_impact")
	
	# Kill the target
	if is_instance_valid(target):
		if target.has_method("receive_deathblow"):
			target.receive_deathblow(player)
		elif target.has_method("death"):
			target.death()
		elif target.has_method("die"):
			target.die()
	
	await get_tree().create_timer(slash_duration).timeout
	_cleanup(player)


func _spawn_slash_effect(player: Node2D, target: Node2D, pattern: int) -> void:
	if not is_instance_valid(player) or not is_instance_valid(target):
		return
	
	var slash_pos = (player.global_position + target.global_position) / 2.0
	var slash_dir = (target.global_position - player.global_position).normalized()
	
	match pattern:
		0:
			_spawn_x_slash(slash_pos, slash_dir)
		1:
			_spawn_triple_slash(slash_pos, slash_dir)
		2:
			_spawn_arc_slash(slash_pos, slash_dir)
		3:
			_spawn_burst_slash(slash_pos)
	
	# Always spawn impact burst at target
	if is_instance_valid(target):
		_spawn_impact_burst(target.global_position)


func _spawn_x_slash(pos: Vector2, dir: Vector2) -> void:
	"""X-shaped cross slash"""
	var slash = Node2D.new()
	slash.global_position = pos
	slash.z_index = 100
	get_tree().current_scene.add_child(slash)
	
	# Two crossing lines
	for i in range(2):
		var line = ColorRect.new()
		line.size = Vector2(90, 8)
		line.position = Vector2(-45, -4)
		line.color = slash_color_primary if i == 0 else slash_color_secondary
		line.rotation = dir.angle() + (0.4 if i == 0 else -0.4)
		slash.add_child(line)
	
	# Center accent
	var center = ColorRect.new()
	center.size = Vector2(20, 20)
	center.position = Vector2(-10, -10)
	center.color = slash_color_accent
	slash.add_child(center)
	
	_animate_slash(slash)


func _spawn_triple_slash(pos: Vector2, dir: Vector2) -> void:
	"""Three parallel slashes"""
	var slash = Node2D.new()
	slash.global_position = pos
	slash.rotation = dir.angle()
	slash.z_index = 100
	get_tree().current_scene.add_child(slash)
	
	var offsets = [-12, 0, 12]
	var lengths = [60, 85, 60]
	var widths = [4, 7, 4]
	var colors = [slash_color_secondary, slash_color_primary, slash_color_secondary]
	
	for i in range(3):
		var line = ColorRect.new()
		line.size = Vector2(lengths[i], widths[i])
		line.position = Vector2(-lengths[i] / 2.0, offsets[i] - widths[i] / 2.0)
		line.color = colors[i]
		slash.add_child(line)
	
	_animate_slash(slash)


func _spawn_arc_slash(pos: Vector2, dir: Vector2) -> void:
	"""Curved arc slash with trail"""
	var slash = Node2D.new()
	slash.global_position = pos
	slash.rotation = dir.angle()
	slash.z_index = 100
	get_tree().current_scene.add_child(slash)
	
	# Main arc (approximated with multiple rotated segments)
	var segments = 5
	for i in range(segments):
		var t = float(i) / (segments - 1)
		var angle_offset = lerp(-0.5, 0.5, t)
		var seg_length = lerp(40.0, 70.0, 1.0 - abs(t - 0.5) * 2.0)
		var width = lerp(3.0, 8.0, 1.0 - abs(t - 0.5) * 2.0)
		
		var segment = ColorRect.new()
		segment.size = Vector2(seg_length, width)
		segment.position = Vector2(-seg_length / 2.0, -width / 2.0)
		segment.rotation = angle_offset
		segment.color = slash_color_primary.lerp(slash_color_accent, abs(t - 0.5) * 1.5)
		slash.add_child(segment)
	
	_animate_slash(slash)


func _spawn_burst_slash(pos: Vector2) -> void:
	"""Radial burst pattern"""
	var slash = Node2D.new()
	slash.global_position = pos
	slash.z_index = 100
	get_tree().current_scene.add_child(slash)
	
	# Radial lines
	var num_lines = 6
	for i in range(num_lines):
		var angle = (TAU / num_lines) * i
		var line = ColorRect.new()
		var line_length = 55.0 if i % 2 == 0 else 40.0
		var width = 6.0 if i % 2 == 0 else 4.0
		line.size = Vector2(line_length, width)
		line.position = Vector2(8, -width / 2.0)
		line.rotation = angle
		line.color = slash_color_primary if i % 2 == 0 else slash_color_secondary
		slash.add_child(line)
	
	# Center circle
	var center = ColorRect.new()
	center.size = Vector2(24, 24)
	center.position = Vector2(-12, -12)
	center.color = slash_color_accent
	slash.add_child(center)
	
	_animate_slash(slash, true)


func _animate_slash(slash: Node2D, is_burst: bool = false) -> void:
	var tw = create_tween()
	tw.set_parallel(true)
	
	if is_burst:
		# Burst expands outward
		slash.scale = Vector2(0.3, 0.3)
		tw.tween_property(slash, "scale", Vector2(1.8, 1.8), 0.15)
	else:
		# Regular slashes scale up slightly
		tw.tween_property(slash, "scale", Vector2(1.4, 1.4), 0.12)
	
	tw.tween_property(slash, "modulate:a", 0.0, 0.14)
	tw.chain().tween_callback(func():
		if is_instance_valid(slash):
			slash.queue_free()
	)


func _spawn_impact_burst(pos: Vector2) -> void:
	var burst = Node2D.new()
	burst.global_position = pos
	burst.z_index = 101
	get_tree().current_scene.add_child(burst)
	
	# Gold/crimson particles
	for i in range(10):
		var particle = ColorRect.new()
		var p_size = randf_range(3, 6)
		particle.size = Vector2(p_size, p_size)
		particle.position = Vector2(-p_size / 2, -p_size / 2)
		# Alternate between gold and red particles
		particle.color = slash_color_primary if i % 3 != 0 else slash_color_accent
		burst.add_child(particle)
		
		var angle = (TAU / 10.0) * i + randf_range(-0.3, 0.3)
		var dist = randf_range(25, 55)
		var end_pos = Vector2(cos(angle), sin(angle)) * dist
		
		var tw = create_tween()
		tw.set_parallel(true)
		tw.tween_property(particle, "position", end_pos, 0.18)
		tw.tween_property(particle, "modulate:a", 0.0, 0.18)
	
	get_tree().create_timer(0.25).timeout.connect(func():
		if is_instance_valid(burst):
			burst.queue_free()
	)


# =============================================================================
# SCREEN EFFECTS
# =============================================================================

func _do_screen_flash() -> void:
	if not _flash_overlay:
		return
	
	_flash_overlay.visible = true
	_flash_overlay.color = flash_color
	
	var tw = create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tw.tween_property(_flash_overlay, "color:a", 0.0, flash_duration)
	tw.tween_callback(func(): 
		if is_instance_valid(_flash_overlay):
			_flash_overlay.visible = false
	)


func _do_screen_shake() -> void:
	var cam = _get_camera()
	if not cam:
		return
	
	var original_offset = cam.offset
	
	var tw = create_tween()
	tw.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	var steps = 7
	for i in range(steps):
		var decay = 1.0 - (float(i) / steps)
		var jitter_x = randf_range(-shake_intensity, shake_intensity) * decay
		var jitter_y = randf_range(-shake_intensity, shake_intensity) * decay
		tw.tween_property(cam, "offset", original_offset + Vector2(jitter_x, jitter_y), shake_duration / steps)
	
	tw.tween_property(cam, "offset", original_offset, shake_duration / steps)


# =============================================================================
# UTILITIES
# =============================================================================

func _get_camera() -> Camera2D:
	var cameras = get_tree().get_nodes_in_group("camera")
	if cameras.size() > 0 and cameras[0] is Camera2D:
		return cameras[0] as Camera2D
	
	var viewport = get_viewport()
	if viewport:
		return viewport.get_camera_2d()
	
	return null


func _set_player_invincible(player: Node, invincible: bool) -> void:
	if not is_instance_valid(player):
		return
	
	if player.has_method("set_invincibility"):
		player.set_invincibility(invincible)
	elif "is_invincible" in player:
		player.is_invincible = invincible
	
	if player.has_node("HurtBox"):
		var hurt_box = player.get_node("HurtBox")
		if hurt_box is Area2D:
			hurt_box.monitoring = not invincible
			hurt_box.monitorable = not invincible


func _cleanup(player: Node) -> void:
	_is_executing = false
	
	var finished_target = null
	if is_instance_valid(_current_target):
		finished_target = _current_target
	_current_target = null
	
	if is_instance_valid(player):
		get_tree().create_timer(invincibility_time).timeout.connect(func():
			if is_instance_valid(player):
				_set_player_invincible(player, false)
		)
	
	emit_signal("deathblow_finished", finished_target)
