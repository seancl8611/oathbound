extends Area2D
class_name SwordHitBox

## =============================================================================
## SWORD HITBOX - v2.0 COMBO ATTACK SUPPORT
## =============================================================================
## Enhanced hitbox supporting:
## - Variable damage per combo hit
## - Posture damage tracking
## - Multi-hit prevention per swing
## - Attack lunge integration
## - Hitstop on hit
## =============================================================================

# =============================================================================
# CONFIGURATION
# =============================================================================
@export var base_damage = 10
@export var base_posture_damage = 8.0

## Damage multipliers per combo hit [hit1, hit2, hit3]
@export var combo_damage_mult: Array[float] = [1.0, 1.2, 1.8]

## Posture damage multipliers per combo hit
@export var combo_posture_mult: Array[float] = [1.0, 1.25, 1.5]

## Knockback force
@export var knockback_force = 150.0

## Hitstop duration on hit (seconds)
@export var hitstop_duration = 0.1

# =============================================================================
# RUNTIME STATE
# =============================================================================
var _current_combo_index = 0
var _current_attack_id: String = "quick_slash"
var _current_damage = 10
var _current_posture_damage = 8.0
var _swing_token = ""
var _hit_targets: Array = []  # Prevent multi-hit per swing
var _base_collision_scale: Vector2 = Vector2.ONE
var _base_collision_position: Vector2 = Vector2.ZERO
var _current_hitbox_shape: String = "default"

@onready var collision_shape = $CollisionShape2D


# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready():
	add_to_group("attack")
	
	# Collision setup: Layer 2, no mask.
	collision_layer = 2
	collision_mask = 0
	
	# The sword hitbox should be OFF by default.
	monitoring = false
	monitorable = false
	
	if collision_shape:
		_base_collision_scale = collision_shape.scale
		_base_collision_position = collision_shape.position
		collision_shape.disabled = true
		collision_shape.set_deferred("disabled", true)
	
	_update_meta()
	
	var player = _find_player_owner()
	set_meta("attacker", player)
	
	if not is_connected("area_entered", Callable(self, "_on_area_entered")):
		connect("area_entered", Callable(self, "_on_area_entered"))
	
	call_deferred("deactivate_hitbox")

func _find_player_owner() -> Node:
	# Walk up tree looking for player
	var node = get_parent()
	while node != null:
		if node.is_in_group("player"):
			return node
		node = node.get_parent()
	
	# Fallback: search tree
	var tree = get_tree()
	if tree:
		var player = tree.get_first_node_in_group("player")
		if player:
			return player
	
	return get_parent()


# =============================================================================
# COMBO SYSTEM INTEGRATION
# =============================================================================

func set_combo_index(index: int) -> void:
	"""Set current combo hit (0, 1, 2). Updates damage values."""
	_current_combo_index = clamp(index, 0, 2)
	_calculate_damage()
	_update_meta()

func _calculate_damage() -> void:
	"""Calculate damage based on combo index and multipliers."""
	var dmg_mult = 1.0
	var post_mult = 1.0
	
	if _current_combo_index < combo_damage_mult.size():
		dmg_mult = combo_damage_mult[_current_combo_index]
	if _current_combo_index < combo_posture_mult.size():
		post_mult = combo_posture_mult[_current_combo_index]
	
	_current_damage = int(base_damage * dmg_mult)
	_current_posture_damage = base_posture_damage * post_mult
	
	# Check for player damage multipliers
	var player = _find_player_owner()
	if player and "sword_damage_mult" in player:
		_current_damage = int(_current_damage * player.sword_damage_mult)

func _update_meta() -> void:
	set_meta("damage", _current_damage)
	set_meta("posture_damage", _current_posture_damage)
	set_meta("damage_type", _get_damage_type())
	set_meta("combo_index", _current_combo_index)
	set_meta("attack_id", _current_attack_id)
	set_meta("hitbox_shape", _current_hitbox_shape)
	set_meta("knockback_force", knockback_force)
	set_meta("hitstop", hitstop_duration)

func _get_damage_type() -> String:
	match _current_attack_id:
		"quick_slash":
			return "sword_light"
		"cross_cut":
			return "sword_medium"
		"heavy_cleave":
			return "sword_heavy"
		"counter_cut":
			return "sword_counter"
		"hold_thrust":
			return "sword_thrust"
		"dash_slash":
			return "sword_dash"
		_:
			match _current_combo_index:
				0:
					return "sword_light"
				1:
					return "sword_medium"
				2:
					return "sword_heavy"
				_:
					return "sword_light"

# =============================================================================
# ACTIVATION / DEACTIVATION
# =============================================================================
func activate_hitbox() -> void:
	"""Activate hitbox for a new swing."""
	monitoring = true
	monitorable = true
	
	if collision_shape:
		collision_shape.disabled = false
		collision_shape.set_deferred("disabled", false)
	
	_swing_token = "%d_%d" % [get_instance_id(), Time.get_ticks_msec()]
	_hit_targets.clear()
	
	var player = _find_player_owner()
	if player:
		set_meta("attacker", player)
	
	set_meta("swing_token", _swing_token)
	_update_meta()

func _get_shape_preset(shape_id: String) -> Dictionary:
	match shape_id:
		"slash_small":
			return {
				"scale": Vector2(0.88, 0.88),
				"local_offset": Vector2(0.0, 0.0)
			}
		"slash_wide":
			return {
				"scale": Vector2(1.28, 1.05),
				"local_offset": Vector2(1.5, 0.0)
			}
		"cleave_heavy":
			return {
				"scale": Vector2(1.55, 1.22),
				"local_offset": Vector2(2.5, 0.0)
			}
		"counter_short":
			return {
				"scale": Vector2(1.05, 0.92),
				"local_offset": Vector2(0.0, 0.0)
			}
		"thrust_long":
			return {
				# Local X = forward reach.
				# Local Y = thickness.
				# This creates a spear-like stab instead of a wide slash.
				"scale": Vector2(2.45, 0.34),
				"local_offset": Vector2(12.0, 0.0)
			}
		"dash_forward":
			return {
				"scale": Vector2(0.90, 1.25),
				"local_offset": Vector2(5.0, 0.0)
			}
		_:
			return {
				"scale": Vector2.ONE,
				"local_offset": Vector2.ZERO
			}


func _apply_hitbox_shape(profile: Dictionary) -> void:
	if collision_shape == null:
		return
	
	var shape_id := str(profile.get("hitbox_shape", "default"))
	_current_hitbox_shape = shape_id
	
	var preset := _get_shape_preset(shape_id)
	var preset_scale: Vector2 = preset.get("scale", Vector2.ONE)
	var preset_offset: Vector2 = preset.get("local_offset", Vector2.ZERO)
	
	# Optional profile tuning multiplier. This lets player.gd still fine-tune
	# each move without creating a new preset every time.
	var profile_scale: Vector2 = profile.get("hitbox_scale", Vector2.ONE)
	
	collision_shape.scale = Vector2(
		_base_collision_scale.x * preset_scale.x * profile_scale.x,
		_base_collision_scale.y * preset_scale.y * profile_scale.y
	)
	
	collision_shape.position = _base_collision_position + preset_offset
	
func activate_for_profile(profile: Dictionary, combo_index: int = 0) -> void:
	_current_combo_index = clamp(combo_index, 0, 2)
	_current_attack_id = str(profile.get("id", "quick_slash"))

	_current_damage = int(profile.get("damage", base_damage))
	_current_posture_damage = float(profile.get("posture", base_posture_damage))

	knockback_force = float(profile.get("knockback", knockback_force))
	hitstop_duration = float(profile.get("hitstop", hitstop_duration))

	_apply_hitbox_shape(profile)

	var player = _find_player_owner()
	if player and "sword_damage_mult" in player:
		_current_damage = int(_current_damage * player.sword_damage_mult)
	
	activate_hitbox()
	
func activate_for_combo(combo_index: int) -> void:
	_current_attack_id = "combo_%d" % combo_index
	_current_hitbox_shape = "default"
	
	if collision_shape:
		collision_shape.scale = _base_collision_scale
		collision_shape.position = _base_collision_position
	
	set_combo_index(combo_index)
	activate_hitbox()

func deactivate_hitbox() -> void:
	"""Deactivate hitbox outside active sword frames."""
	monitoring = false
	monitorable = false
	
	if collision_shape:
		collision_shape.disabled = true
		collision_shape.set_deferred("disabled", true)
		collision_shape.scale = _base_collision_scale
		collision_shape.position = _base_collision_position

	_current_hitbox_shape = "default"
	
	_hit_targets.clear()

# =============================================================================
# HIT DETECTION
# =============================================================================

func _on_area_entered(area: Area2D) -> void:
	if area == null:
		return
	
	# Skip if disabled
	if collision_shape and collision_shape.disabled:
		return
	
	# Skip player/friendly hurtboxes
	if area.is_in_group("player_hurtbox"):
		return
	
	# Prevent multi-hit on same target in same swing
	var target_id = area.get_instance_id()
	if target_id in _hit_targets:
		return
	_hit_targets.append(target_id)
	
	# Get the entity being hit
	var hit_entity = area.get_parent() if area.get_parent() else area
	
	# Trigger hitstop on hit
	_trigger_hitstop(hit_entity)
	
	# Notify player of successful hit
	var player = _find_player_owner()
	if player and player.has_method("_on_attack_hit"):
		player._on_attack_hit(hit_entity, _current_combo_index)


func _trigger_hitstop(target: Node) -> void:
	"""Apply hitstop to both player and target."""
	var player = _find_player_owner()
	var duration = hitstop_duration
	
	# Scale hitstop by combo hit
	match _current_combo_index:
		0:
			duration = hitstop_duration
		1:
			duration = hitstop_duration * 1.2
		2:
			duration = hitstop_duration * 1.5
	
	# Apply to player
	if player and player.has_method("apply_hitstop"):
		player.apply_hitstop(duration)
	
	# Apply to target
	if target and target.has_method("hitstop_local"):
		target.hitstop_local(duration)
	elif target and target.has_method("apply_hitstop"):
		target.apply_hitstop(duration)


# =============================================================================
# EXTERNAL CONFIGURATION
# =============================================================================

func set_damage_multiplier(mult: float) -> void:
	"""Apply external damage multiplier (from upgrades, etc.)"""
	set_meta("damage_mult", mult)
	_calculate_damage()
	_update_meta()

func set_knockback_multiplier(mult: float) -> void:
	"""Apply knockback multiplier."""
	set_meta("knockback_mult", mult)

func set_size_multiplier(mult: float) -> void:
	"""Apply size multiplier to collision shape."""
	set_meta("size_mult", mult)
	if collision_shape and collision_shape.shape:
		# Scale collision shape
		collision_shape.scale = Vector2(mult, mult)


# =============================================================================
# UTILITY
# =============================================================================

func get_current_damage() -> int:
	return _current_damage

func get_current_posture_damage() -> float:
	return _current_posture_damage

func get_combo_index() -> int:
	return _current_combo_index

func is_active() -> bool:
	return collision_shape and not collision_shape.disabled
