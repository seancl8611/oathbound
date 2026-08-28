extends Node

## =============================================================================
## DAMAGE NUMBER MANAGER — Fixed for RunScene structure
## =============================================================================
## Changes:
## - Adds numbers to current_scene instead of "World" (works with any scene)
## - Falls back to NORMAL for unknown damage types instead of returning null
## - Adds support for stance effect types (lightning, shock)
## - Adds support for prosthetic types (burn, prosthetic)
## - Owns each animation tween from the transient damage-number node so a scene
##   transition kills the tween before it can call back into a freed capture.
## - Honors the launch damage-number accessibility toggle before creating UI.
## - Treats floating numbers as HP-loss feedback only; zero/posture-only contacts
##   never create a damage-number node.
## =============================================================================

# Damage number scenes for each type
const NORMAL_DAMAGE_SCENE = preload("res://Utility/NormalDamageNumber.tscn")
const BLEED_DAMAGE_SCENE = preload("res://Utility/BleedDamageNumber.tscn")
const FINISHER_DAMAGE_SCENE = preload("res://Utility/FinisherDamageNumber.tscn")
const CRITICAL_DAMAGE_SCENE = preload("res://Utility/CriticalDamageNumber.tscn")

# Map damage types to scenes — unknown types fall back to NORMAL
# Add new .tscn files here when you make them, otherwise they use NORMAL
var _type_scene_map: Dictionary = {}

# Tint colors for types that reuse NORMAL scene but need distinct colors
var _type_tint_map: Dictionary = {
	"lightning": Color(0.5, 0.85, 1.0),
	"shock":     Color(1.0, 1.0, 0.3),
	"burn":      Color(1.0, 0.5, 0.2),
	"prosthetic": Color(0.7, 0.5, 1.0),
	"heavy":     Color(1.0, 0.9, 0.7),
}

# Prevent duplicate damage numbers using a cooldown
const DAMAGE_NUMBER_COOLDOWN = 0.1
var damage_display_timer: Dictionary = {}


func _ready() -> void:
	# Build scene map — add custom scenes here as you create them
	_type_scene_map = {
		"normal":   NORMAL_DAMAGE_SCENE,
		"bleed":    BLEED_DAMAGE_SCENE,
		"finisher": FINISHER_DAMAGE_SCENE,
		"critical": CRITICAL_DAMAGE_SCENE,
		# These reuse NORMAL but get tinted — override here if you make
		# dedicated scenes later:
		# "lightning": preload("res://Utility/LightningDamageNumber.tscn"),
		# "shock":     preload("res://Utility/ShockDamageNumber.tscn"),
	}


func show_damage_number(amount: int, position: Vector2, damage_type: String = "normal", target: Node = null) -> void:
	# Floating numbers communicate real HP loss only. Guard/posture feedback uses
	# posture bars, sparks, sound, and hitstop instead of a misleading "damage" value.
	if amount <= 0:
		return

	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("should_show_damage_numbers"):
		if not bool(SettingsManager.call("should_show_damage_numbers")):
			return

	# Prevent duplicate damage numbers using cooldown per target+type
	if target and is_instance_valid(target):
		var current_time = Time.get_ticks_msec() / 1000.0
		var key = str(target.get_instance_id()) + "_" + damage_type

		var will_die = false
		if "hp" in target and amount >= target.hp:
			will_die = true
		elif "health" in target and typeof(target.health) in [TYPE_INT, TYPE_FLOAT] and amount >= target.health:
			will_die = true

		if key in damage_display_timer and not will_die:
			var last_time = damage_display_timer[key]
			if current_time - last_time < DAMAGE_NUMBER_COOLDOWN:
				return

		damage_display_timer[key] = current_time
	elif target == null:
		# Allow damage numbers without a target (area effects, etc.)
		pass
	else:
		return

	# Create the damage number node
	var damage_number = _create_damage_number(damage_type)
	if not damage_number:
		return

	var label = damage_number.get_node_or_null("NumberLabel")
	if not label:
		damage_number.queue_free()
		return

	label.text = str(amount)

	# Apply tint for types that reuse NORMAL scene
	if damage_type in _type_tint_map and not damage_type in _type_scene_map:
		label.modulate = _type_tint_map[damage_type]
	elif damage_type in _type_tint_map:
		# Has both a scene AND a tint — only tint if using fallback scene
		if not _type_scene_map.has(damage_type):
			label.modulate = _type_tint_map[damage_type]

	# Position with slight randomness
	damage_number.position = position + Vector2(randf_range(-10, 10), -20)
	damage_number.visible = true

	# Add to scene tree — try current_scene first, then root
	var added = false
	var scene = get_tree().current_scene
	if scene:
		scene.add_child(damage_number)
		added = true

	if not added:
		# Last resort fallback
		get_tree().root.add_child(damage_number)

	_animate_damage_number(damage_number)


func _create_damage_number(damage_type: String) -> Control:
	# Use dedicated scene if one exists
	if _type_scene_map.has(damage_type):
		return _type_scene_map[damage_type].instantiate()

	# Fall back to NORMAL scene for any unknown type (tinted in show_damage_number)
	return NORMAL_DAMAGE_SCENE.instantiate()


func _animate_damage_number(damage_number: Control) -> void:
	if damage_number == null or not is_instance_valid(damage_number) or not damage_number.is_inside_tree():
		return

	# This tween must belong to the transient number, not this persistent autoload.
	# Scene changes free the number and therefore kill the tween before any completion
	# callback can outlive the object it targets.
	var tween := damage_number.create_tween()
	tween.set_parallel(true)
	tween.tween_property(damage_number, "position:y", damage_number.position.y - 40, 0.6)
	tween.tween_property(damage_number, "modulate:a", 0.0, 0.6)
	tween.chain().tween_callback(Callable(damage_number, "queue_free"))
