extends Area2D
class_name SwordHitBox

## =============================================================================
## SWORD HITBOX - OATHBOUND ATTACK EVENT BRIDGE
## =============================================================================
## Existing sword timing/shape behavior is preserved while every sword contact now
## publishes the canonical shared AttackEvent fields expected by the current docs:
## health_damage, posture_damage, block_posture_damage, stagger_level,
## proc_coefficient.
##
## Legacy metadata (damage, damage_type, combo_index, etc.) remains during the
## reconciliation so existing enemies and HurtBox code continue to function.
## =============================================================================

# =============================================================================
# CONFIGURATION
# =============================================================================
@export var base_damage = 10
@export var base_posture_damage = 8.0
@export var base_block_posture_damage = 8.0
@export var base_stagger_level: int = 0
@export var base_proc_coefficient: float = 1.0

@export var combo_damage_mult: Array[float] = [1.0, 1.2, 1.8]
@export var combo_posture_mult: Array[float] = [1.0, 1.25, 1.5]

@export var knockback_force = 150.0
@export var hitstop_duration = 0.1

# =============================================================================
# RUNTIME STATE
# =============================================================================
var _current_combo_index = 0
var _current_attack_id: String = "quick_slash"
var _current_damage = 10
var _current_posture_damage = 8.0
var _current_block_posture_damage = 8.0
var _current_stagger_level: int = 0
var _current_proc_coefficient: float = 1.0
var _swing_token = ""
var _hit_targets: Array = []
var _base_collision_scale: Vector2 = Vector2.ONE
var _base_collision_position: Vector2 = Vector2.ZERO
var _current_hitbox_shape: String = "default"
var _active_requested: bool = false

@onready var collision_shape = $CollisionShape2D


# =============================================================================
# INITIALIZATION
# =============================================================================
func _ready():
	add_to_group("attack")
	collision_layer = 2
	collision_mask = 0
	monitoring = false
	monitorable = false
	_active_requested = false

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
	var node = get_parent()
	while node != null:
		if node.is_in_group("player"):
			return node
		node = node.get_parent()

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
	_current_combo_index = clamp(index, 0, 2)
	_calculate_damage()
	_update_meta()

func _calculate_damage() -> void:
	var dmg_mult = 1.0
	var post_mult = 1.0

	if _current_combo_index < combo_damage_mult.size():
		dmg_mult = combo_damage_mult[_current_combo_index]
	if _current_combo_index < combo_posture_mult.size():
		post_mult = combo_posture_mult[_current_combo_index]

	_current_damage = int(base_damage * dmg_mult)
	_current_posture_damage = base_posture_damage * post_mult
	_current_block_posture_damage = base_block_posture_damage * post_mult
	_current_stagger_level = base_stagger_level
	_current_proc_coefficient = base_proc_coefficient

	var player = _find_player_owner()
	if player and "sword_damage_mult" in player:
		_current_damage = int(_current_damage * player.sword_damage_mult)
	_apply_playtest_power()


func _apply_playtest_power() -> void:
	# Playtest power is intentionally resolved after canonical/player build modifiers.
	# It therefore never changes authored attack profiles, saves, balance data, or
	# release builds. The PlaytestLab autoload returns 1x unless a debug-session preset
	# has been explicitly selected.
	if not OS.is_debug_build():
		return
	var lab := get_node_or_null("/root/PlaytestLab")
	if lab == null:
		return
	var health_mult := 1.0
	var posture_mult := 1.0
	if lab.has_method("get_playtest_health_damage_multiplier"):
		health_mult = clampf(float(lab.call("get_playtest_health_damage_multiplier")), 1.0, 10.0)
	if lab.has_method("get_playtest_posture_damage_multiplier"):
		posture_mult = clampf(float(lab.call("get_playtest_posture_damage_multiplier")), 1.0, 10.0)
	_current_damage = maxi(0, int(round(float(_current_damage) * health_mult)))
	_current_posture_damage = maxf(0.0, _current_posture_damage * posture_mult)
	_current_block_posture_damage = maxf(0.0, _current_block_posture_damage * posture_mult)


func _update_meta() -> void:
	# Canonical Oathbound AttackEvent fields.
	set_meta("health_damage", _current_damage)
	set_meta("posture_damage", _current_posture_damage)
	set_meta("block_posture_damage", _current_block_posture_damage)
	set_meta("stagger_level", _current_stagger_level)
	set_meta("proc_coefficient", _current_proc_coefficient)

	# Compatibility metadata used throughout the imported prototype.
	set_meta("damage", _current_damage)
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
	# Monitoring state changes are deferred because attack interruption can happen
	# from inside an Area2D body/area signal while Godot is flushing physics queries.
	# The requested flag preserves immediate gameplay semantics while the physics
	# server applies the actual state safely at the end of the frame.
	_active_requested = true
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)

	if collision_shape:
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
	var profile_scale: Vector2 = profile.get("hitbox_scale", Vector2.ONE)

	collision_shape.scale = Vector2(
		_base_collision_scale.x * preset_scale.x * profile_scale.x,
		_base_collision_scale.y * preset_scale.y * profile_scale.y
	)
	collision_shape.position = _base_collision_position + preset_offset

func activate_for_profile(profile: Dictionary, combo_index: int = 0) -> void:
	_current_combo_index = clamp(combo_index, 0, 2)
	_current_attack_id = str(profile.get("id", "quick_slash"))

	_current_damage = int(profile.get("health_damage", profile.get("damage", base_damage)))
	_current_posture_damage = float(profile.get("posture_damage", profile.get("posture", base_posture_damage)))
	_current_block_posture_damage = float(profile.get("block_posture_damage", _current_posture_damage))
	_current_stagger_level = int(profile.get("stagger_level", base_stagger_level))
	_current_proc_coefficient = float(profile.get("proc_coefficient", base_proc_coefficient))

	knockback_force = float(profile.get("knockback", knockback_force))
	hitstop_duration = float(profile.get("hitstop", hitstop_duration))

	_apply_hitbox_shape(profile)

	var player = _find_player_owner()
	if player and "sword_damage_mult" in player:
		_current_damage = int(_current_damage * player.sword_damage_mult)
	_apply_playtest_power()

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
	_active_requested = false
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

	if collision_shape:
		collision_shape.set_deferred("disabled", true)
		collision_shape.set_deferred("scale", _base_collision_scale)
		collision_shape.set_deferred("position", _base_collision_position)

	_current_hitbox_shape = "default"
	_hit_targets.clear()

# =============================================================================
# HIT DETECTION
# =============================================================================
func _on_area_entered(area: Area2D) -> void:
	if not _active_requested:
		return
	if area == null:
		return
	if collision_shape and collision_shape.disabled:
		return
	if area.is_in_group("player_hurtbox"):
		return

	var target_id = area.get_instance_id()
	if target_id in _hit_targets:
		return
	_hit_targets.append(target_id)

	var hit_entity = area.get_parent() if area.get_parent() else area
	_trigger_hitstop(hit_entity)

	var player = _find_player_owner()
	if player and player.has_method("_on_attack_hit"):
		player._on_attack_hit(hit_entity, _current_combo_index)


func _trigger_hitstop(target: Node) -> void:
	var player = _find_player_owner()
	var duration = hitstop_duration

	match _current_combo_index:
		0:
			duration = hitstop_duration
		1:
			duration = hitstop_duration * 1.2
		2:
			duration = hitstop_duration * 1.5

	if player and player.has_method("apply_hitstop"):
		player.apply_hitstop(duration)

	if target and target.has_method("hitstop_local"):
		target.hitstop_local(duration)
	elif target and target.has_method("apply_hitstop"):
		target.apply_hitstop(duration)


# =============================================================================
# EXTERNAL CONFIGURATION
# =============================================================================
func set_damage_multiplier(mult: float) -> void:
	set_meta("damage_mult", mult)
	_calculate_damage()
	_update_meta()

func set_knockback_multiplier(mult: float) -> void:
	set_meta("knockback_mult", mult)

func set_size_multiplier(mult: float) -> void:
	set_meta("size_mult", mult)
	if collision_shape and collision_shape.shape:
		collision_shape.scale = Vector2(mult, mult)


# =============================================================================
# UTILITY
# =============================================================================
func get_current_damage() -> int:
	return _current_damage

func get_current_posture_damage() -> float:
	return _current_posture_damage

func get_current_combo_index() -> int:
	return _current_combo_index

func get_combo_index() -> int:
	return _current_combo_index

func get_current_attack_event() -> Dictionary:
	return {
		"health_damage": _current_damage,
		"posture_damage": _current_posture_damage,
		"block_posture_damage": _current_block_posture_damage,
		"stagger_level": _current_stagger_level,
		"proc_coefficient": _current_proc_coefficient,
		"attack_id": _current_attack_id,
	}

func is_active() -> bool:
	return _active_requested
