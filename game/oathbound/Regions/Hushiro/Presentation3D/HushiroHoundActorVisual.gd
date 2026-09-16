extends "res://Utility/Planar3DActorVisual.gd"

## Hushiro-specific Blighted Hound presentation for the live planar-combat -> 3D bridge.
##
## This remains presentation-only: the existing CharacterBody2D owns movement, attack
## timing, hitboxes, damage, Poise/interruption, Pressure Director admission and death.
## A future production GLB at the canonical BlightedHound slot automatically takes
## priority; this authored silhouette is the readable vertical-slice fallback until then.

var _jaw_pivot: Node3D = null
var _front_left_leg: Node3D = null
var _front_right_leg: Node3D = null
var _rear_left_leg: Node3D = null
var _rear_right_leg: Node3D = null
var _corruption_core: Node3D = null


func get_visual_tier() -> String:
	if _external_model_active:
		return "role_specific_glb"
	return "hushiro_stylized_hound"


func _build_hound() -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "HushiroHoundRig"
	_visual_root.add_child(_rig_root)
	_rig_root.set_meta("oathbound_hushiro_stylized_hound", true)

	var hide := _material(Color(0.115, 0.055, 0.050, 1.0), 0.95)
	var hide_mid := _material(Color(0.19, 0.085, 0.065, 1.0), 0.92)
	var char := _material(Color(0.040, 0.028, 0.030, 1.0), 0.98)
	var bone := _material(Color(0.38, 0.34, 0.28, 1.0), 0.86)
	var blood := _material(Color(0.36, 0.018, 0.020, 1.0), 0.70)
	var corruption := _material(Color(0.62, 0.035, 0.025, 1.0), 0.62)
	corruption.emission_enabled = true
	corruption.emission = Color(0.72, 0.025, 0.015, 1.0)
	corruption.emission_energy_multiplier = 2.1

	# Long, low predator silhouette. Broad shoulder and haunch masses are deliberately
	# exaggerated so the Hound reads instantly from the fixed high-angle camera.
	var torso := _add_capsule(_rig_root, "Torso", 0.32, 1.30, Vector3(0.0, 0.62, 0.02), hide_mid)
	torso.rotation.x = PI * 0.5
	_add_box(_rig_root, "ShoulderMass", Vector3(0.70, 0.62, 0.58), Vector3(0.0, 0.69, -0.36), hide)
	_add_box(_rig_root, "HaunchMass", Vector3(0.66, 0.58, 0.62), Vector3(0.0, 0.64, 0.42), hide_mid)
	_add_box(_rig_root, "Underbelly", Vector3(0.43, 0.24, 1.02), Vector3(0.0, 0.43, 0.04), char)

	_hound_head = Node3D.new()
	_hound_head.name = "HeadPivot"
	_hound_head.position = Vector3(0.0, 0.73, -0.83)
	_rig_root.add_child(_hound_head)
	_add_box(_hound_head, "Skull", Vector3(0.55, 0.47, 0.54), Vector3(0.0, 0.0, 0.0), hide)
	_add_box(_hound_head, "Brow", Vector3(0.50, 0.16, 0.24), Vector3(0.0, 0.15, -0.27), char)
	_add_box(_hound_head, "UpperMuzzle", Vector3(0.34, 0.22, 0.47), Vector3(0.0, -0.05, -0.42), hide_mid)
	_add_box(_hound_head, "Nose", Vector3(0.28, 0.18, 0.16), Vector3(0.0, -0.04, -0.69), char)

	_jaw_pivot = Node3D.new()
	_jaw_pivot.name = "JawPivot"
	_jaw_pivot.position = Vector3(0.0, -0.13, -0.34)
	_hound_head.add_child(_jaw_pivot)
	_add_box(_jaw_pivot, "LowerJaw", Vector3(0.31, 0.13, 0.42), Vector3(0.0, -0.03, -0.18), char)
	_add_box(_jaw_pivot, "FangLeft", Vector3(0.045, 0.14, 0.045), Vector3(-0.10, -0.10, -0.34), bone)
	_add_box(_jaw_pivot, "FangRight", Vector3(0.045, 0.14, 0.045), Vector3(0.10, -0.10, -0.34), bone)

	var ear_l := _add_box(_hound_head, "EarLeft", Vector3(0.15, 0.39, 0.14), Vector3(-0.19, 0.34, -0.03), char)
	var ear_r := _add_box(_hound_head, "EarRight", Vector3(0.15, 0.39, 0.14), Vector3(0.19, 0.34, -0.03), char)
	ear_l.rotation = Vector3(-0.10, 0.0, -0.27)
	ear_r.rotation = Vector3(-0.10, 0.0, 0.27)

	_front_left_leg = _create_leg("FrontLeftLeg", Vector3(-0.23, 0.54, -0.43), char, hide)
	_front_right_leg = _create_leg("FrontRightLeg", Vector3(0.23, 0.54, -0.43), char, hide)
	_rear_left_leg = _create_leg("RearLeftLeg", Vector3(-0.24, 0.53, 0.45), char, hide_mid)
	_rear_right_leg = _create_leg("RearRightLeg", Vector3(0.24, 0.53, 0.45), char, hide_mid)

	_hound_tail = Node3D.new()
	_hound_tail.name = "TailPivot"
	_hound_tail.position = Vector3(0.0, 0.69, 0.76)
	_rig_root.add_child(_hound_tail)
	var tail_base := _add_box(_hound_tail, "TailBase", Vector3(0.15, 0.16, 0.58), Vector3(0.0, 0.06, 0.25), hide_mid)
	tail_base.rotation.x = -0.30
	var tail_tip := _add_box(_hound_tail, "TailTip", Vector3(0.11, 0.12, 0.52), Vector3(0.0, 0.20, 0.66), char)
	tail_tip.rotation.x = -0.62

	# Rupture corruption is carried on the silhouette rather than hidden in texture detail.
	# The ridge and exposed shoulder growths remain readable at gameplay camera distance.
	_add_box(_rig_root, "CorruptionRidge", Vector3(0.18, 0.14, 0.98), Vector3(0.0, 0.98, 0.02), blood)
	for entry: Dictionary in [
		{"p": Vector3(-0.16, 1.09, -0.30), "r": -0.28, "s": Vector3(0.10, 0.34, 0.10)},
		{"p": Vector3(0.13, 1.05, -0.06), "r": 0.20, "s": Vector3(0.09, 0.29, 0.09)},
		{"p": Vector3(-0.08, 1.02, 0.25), "r": -0.12, "s": Vector3(0.08, 0.25, 0.08)},
	]:
		var spike := _add_box(_rig_root, "CorruptionSpike", entry["s"], entry["p"], bone)
		spike.rotation.z = float(entry["r"])

	_corruption_core = _add_sphere(_hound_head, "MawCorruption", 0.105, Vector3(0.0, -0.06, -0.48), corruption)
	_add_contact_shadow(_visual_root, 0.72, 0.42)


func _create_leg(node_name: String, position_value: Vector3, lower_material: Material, upper_material: Material) -> Node3D:
	var pivot := Node3D.new()
	pivot.name = node_name
	pivot.position = position_value
	_rig_root.add_child(pivot)
	_add_box(pivot, "Upper", Vector3(0.18, 0.43, 0.20), Vector3(0.0, -0.17, 0.0), upper_material)
	_add_box(pivot, "Lower", Vector3(0.14, 0.39, 0.16), Vector3(0.0, -0.50, -0.03), lower_material)
	_add_box(pivot, "Paw", Vector3(0.18, 0.12, 0.30), Vector3(0.0, -0.72, -0.08), lower_material)
	return pivot


func _animate_hound(speed: float) -> void:
	if _rig_root == null:
		return
	_reset_stylized_hound_pose()

	var animation := _source_animation_name()
	var dead := _source_dead() or animation.contains("death")
	var hurt := _contains_any(animation, ["hurt", "stagger", "hit", "interrupted"])
	var attacking := _source_attack_active() or _contains_any(animation, ["attack", "bite", "lunge", "charge", "pounce"])

	if dead:
		_rig_root.rotation.z = 1.12
		_rig_root.rotation.x = -0.14
		_rig_root.position.y = -0.24
		if _hound_head != null:
			_hound_head.rotation.x = -0.22
		return

	if hurt:
		_rig_root.position.y = -0.08
		_rig_root.rotation.z = sin(_motion_phase * 1.8) * 0.10
		if _hound_head != null:
			_hound_head.rotation.x = -0.24
		if _hound_tail != null:
			_hound_tail.rotation.x = 0.48
		return

	if attacking:
		var progress := clampf(_source_action_progress(), 0.0, 1.0)
		var drive := sin(progress * PI)
		_rig_root.position.z = -0.22 * drive
		_rig_root.position.y = 0.08 * drive
		_rig_root.rotation.x = -0.13 * drive
		if _hound_head != null:
			_hound_head.rotation.x = -0.16 + 0.24 * drive
		if _jaw_pivot != null:
			_jaw_pivot.rotation.x = -0.72 * drive
		if _front_left_leg != null:
			_front_left_leg.rotation.x = -0.42 * drive
		if _front_right_leg != null:
			_front_right_leg.rotation.x = -0.42 * drive
		if _rear_left_leg != null:
			_rear_left_leg.rotation.x = 0.30 * drive
		if _rear_right_leg != null:
			_rear_right_leg.rotation.x = 0.30 * drive
		_pulse_corruption(1.0 + drive * 0.55)
		return

	if speed > 10.0:
		var stride := sin(_motion_phase)
		var lift := absf(sin(_motion_phase * 2.0))
		_rig_root.position.y = lift * 0.055
		_rig_root.rotation.z = stride * 0.030
		_set_leg_rotation(_front_left_leg, stride * 0.52)
		_set_leg_rotation(_rear_right_leg, stride * 0.48)
		_set_leg_rotation(_front_right_leg, -stride * 0.52)
		_set_leg_rotation(_rear_left_leg, -stride * 0.48)
		if _hound_head != null:
			_hound_head.rotation.x = -0.05 + lift * 0.06
		if _hound_tail != null:
			_hound_tail.rotation.y = sin(_motion_phase * 0.85) * 0.24
	else:
		var breath := sin(_motion_phase * 0.62)
		_rig_root.position.y = breath * 0.010
		if _hound_head != null:
			_hound_head.rotation.y = sin(_motion_phase * 0.27) * 0.035
		if _hound_tail != null:
			_hound_tail.rotation.y = sin(_motion_phase * 0.74) * 0.16

	_pulse_corruption(1.0 + sin(_motion_phase * 1.15) * 0.10)


func _reset_stylized_hound_pose() -> void:
	_rig_root.position = Vector3.ZERO
	_rig_root.rotation = Vector3.ZERO
	_rig_root.scale = Vector3.ONE
	for pivot: Node3D in [
		_hound_head,
		_hound_tail,
		_jaw_pivot,
		_front_left_leg,
		_front_right_leg,
		_rear_left_leg,
		_rear_right_leg,
	]:
		if pivot != null:
			pivot.rotation = Vector3.ZERO
	_pulse_corruption(1.0)


func _set_leg_rotation(leg: Node3D, amount: float) -> void:
	if leg != null:
		leg.rotation.x = amount


func _pulse_corruption(scale_value: float) -> void:
	if _corruption_core != null:
		_corruption_core.scale = Vector3.ONE * maxf(0.65, scale_value)
