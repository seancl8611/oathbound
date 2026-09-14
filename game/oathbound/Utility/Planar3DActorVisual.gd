extends Node3D

## Reusable real-time 3D presentation for the planar Combat V2 simulation.
##
## The bound CharacterBody2D/Node2D remains authoritative for position, hitboxes,
## attack timing, Health, Pressure Director admission and all combat resolution. This
## node mirrors that state into a real Node3D representation. The generated geometry is
## intentionally production-replaceable: when a game-ready glTF/GLB is available, the
## same bridge can instance it without changing the combat simulation.

@export_enum("player", "swordsman", "hound", "enemy") var actor_role: String = "enemy"
@export var use_procedural_fallback: bool = true

const OPTIONAL_MODEL_PATHS: Dictionary = {
	"player": "res://Art3D/Characters/Akio/akio.glb",
	"swordsman": "res://Art3D/Characters/HushiroSwordsman/hushiro_swordsman.glb",
	"hound": "res://Art3D/Characters/BlightedHound/blighted_hound.glb",
}

var source_actor: Node2D = null
var _visual_root: Node3D = null
var _rig_root: Node3D = null
var _left_arm: Node3D = null
var _right_arm: Node3D = null
var _left_leg: Node3D = null
var _right_leg: Node3D = null
var _head_pivot: Node3D = null
var _sword_pivot: Node3D = null
var _hound_head: Node3D = null
var _hound_tail: Node3D = null
var _motion_phase: float = 0.0
var _last_facing_2d := Vector2(0.0, -1.0)
var _external_model_active: bool = false


func _ready() -> void:
	_rebuild_visual()


func configure(role: String, actor: Node2D) -> void:
	actor_role = role
	source_actor = actor
	if is_node_ready():
		_rebuild_visual()


func bind_source(actor: Node2D) -> void:
	source_actor = actor


func sync_from_source(delta: float) -> void:
	if source_actor == null or not is_instance_valid(source_actor):
		return

	var facing := _resolved_facing_2d()
	if facing.length_squared() > 0.001:
		_last_facing_2d = facing.normalized()
		var world_dir := Vector3(_last_facing_2d.x, 0.0, _last_facing_2d.y)
		rotation.y = atan2(-world_dir.x, -world_dir.z)

	var speed := _source_velocity().length()
	_motion_phase += delta * clampf(2.0 + speed / 32.0, 2.0, 10.0)
	if _external_model_active:
		_sync_external_animation(speed)
	elif actor_role == "hound":
		_animate_hound(speed)
	else:
		_animate_humanoid(speed)


func _rebuild_visual() -> void:
	for child: Node in get_children():
		child.queue_free()

	_visual_root = Node3D.new()
	_visual_root.name = "VisualRoot"
	add_child(_visual_root)
	_rig_root = null
	_left_arm = null
	_right_arm = null
	_left_leg = null
	_right_leg = null
	_head_pivot = null
	_sword_pivot = null
	_hound_head = null
	_hound_tail = null
	_external_model_active = false

	if _try_external_model():
		return
	if not use_procedural_fallback:
		return

	match actor_role:
		"player":
			_build_humanoid(true)
		"swordsman":
			_build_humanoid(false)
		"hound":
			_build_hound()
		_:
			_build_fallback_enemy()


func _try_external_model() -> bool:
	var model_path := str(OPTIONAL_MODEL_PATHS.get(actor_role, ""))
	if model_path.is_empty() or not ResourceLoader.exists(model_path):
		return false
	var packed := load(model_path) as PackedScene
	if packed == null:
		return false
	var model := packed.instantiate()
	if not (model is Node3D):
		model.queue_free()
		return false
	model.name = "ImportedModel"
	_visual_root.add_child(model)
	_external_model_active = true
	return true


func _build_humanoid(is_player: bool) -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "Rig"
	_visual_root.add_child(_rig_root)

	var cloth := _material(Color(0.075, 0.075, 0.085, 1.0) if is_player else Color(0.18, 0.135, 0.105, 1.0), 0.88)
	var cloth_mid := _material(Color(0.12, 0.12, 0.13, 1.0) if is_player else Color(0.25, 0.20, 0.15, 1.0), 0.82)
	var skin := _material(Color(0.31, 0.25, 0.22, 1.0) if is_player else Color(0.35, 0.30, 0.25, 1.0), 0.84)
	var accent := _material(Color(0.30, 0.045, 0.04, 1.0) if is_player else Color(0.26, 0.07, 0.045, 1.0), 0.78)
	var armor := _material(Color(0.18, 0.13, 0.09, 1.0), 0.62, 0.18)
	var metal := _material(Color(0.45, 0.46, 0.46, 1.0), 0.28, 0.72)
	var hair := _material(Color(0.025, 0.022, 0.025, 1.0), 0.94)

	# Feet-to-head height is roughly 1.95 m. Shapes are deliberately broad at gameplay
	# distance, matching the Akio concept's dark layered silhouette instead of chasing
	# facial detail that the fixed high-angle camera cannot read.
	_add_box(_rig_root, "Torso", Vector3(0.54, 0.72, 0.30), Vector3(0.0, 1.25, 0.0), cloth_mid)
	_add_box(_rig_root, "LowerRobe", Vector3(0.66, 0.62, 0.38), Vector3(0.0, 0.78, 0.03), cloth)
	_add_box(_rig_root, "Sash", Vector3(0.68, 0.13, 0.36), Vector3(0.0, 0.97, -0.01), accent)
	_add_box(_rig_root, "Cloak", Vector3(0.64, 0.80, 0.08), Vector3(0.0, 1.20, 0.19), cloth)
	_add_box(_rig_root, "Scarf", Vector3(0.54, 0.20, 0.39), Vector3(0.0, 1.59, -0.02), cloth)

	_head_pivot = Node3D.new()
	_head_pivot.name = "HeadPivot"
	_head_pivot.position = Vector3(0.0, 1.74, -0.01)
	_rig_root.add_child(_head_pivot)
	_add_sphere(_head_pivot, "Head", 0.18, Vector3.ZERO, skin)
	_add_box(_head_pivot, "HairMass", Vector3(0.36, 0.18, 0.34), Vector3(0.0, 0.11, 0.02), hair)
	_add_box(_head_pivot, "TopKnot", Vector3(0.13, 0.22, 0.13), Vector3(0.05, 0.28, 0.02), hair)

	_left_arm = _limb_pivot(_rig_root, "LeftArmPivot", Vector3(-0.37, 1.48, 0.0))
	_right_arm = _limb_pivot(_rig_root, "RightArmPivot", Vector3(0.37, 1.48, 0.0))
	_add_box(_left_arm, "LeftArm", Vector3(0.17, 0.64, 0.18), Vector3(0.0, -0.29, 0.0), cloth_mid)
	_add_box(_right_arm, "RightArm", Vector3(0.17, 0.64, 0.18), Vector3(0.0, -0.29, 0.0), cloth_mid)
	_add_box(_left_arm, "ShoulderArmor", Vector3(0.30, 0.18, 0.31), Vector3(-0.04, -0.02, 0.0), armor)
	if is_player:
		# Akio concept: asymmetrical armored shoulder/forearm and bound-hunter profile.
		_add_box(_left_arm, "ForearmArmor", Vector3(0.20, 0.27, 0.21), Vector3(0.0, -0.49, 0.0), armor)

	_left_leg = _limb_pivot(_rig_root, "LeftLegPivot", Vector3(-0.17, 0.66, 0.0))
	_right_leg = _limb_pivot(_rig_root, "RightLegPivot", Vector3(0.17, 0.66, 0.0))
	_add_box(_left_leg, "LeftLeg", Vector3(0.22, 0.72, 0.24), Vector3(0.0, -0.34, 0.0), cloth)
	_add_box(_right_leg, "RightLeg", Vector3(0.22, 0.72, 0.24), Vector3(0.0, -0.34, 0.0), cloth)
	_add_box(_left_leg, "LeftFoot", Vector3(0.24, 0.16, 0.38), Vector3(0.0, -0.73, -0.08), cloth_mid)
	_add_box(_right_leg, "RightFoot", Vector3(0.24, 0.16, 0.38), Vector3(0.0, -0.73, -0.08), cloth_mid)

	_sword_pivot = Node3D.new()
	_sword_pivot.name = "SwordPivot"
	_sword_pivot.position = Vector3(0.03, -0.58, -0.02)
	_right_arm.add_child(_sword_pivot)
	_add_box(_sword_pivot, "KatanaBlade", Vector3(0.055, 0.055, 1.08), Vector3(0.0, 0.0, -0.52), metal)
	_add_box(_sword_pivot, "KatanaGrip", Vector3(0.075, 0.075, 0.30), Vector3(0.0, 0.0, 0.16), cloth)
	_add_box(_sword_pivot, "Tsuba", Vector3(0.24, 0.045, 0.08), Vector3(0.0, 0.0, -0.02), armor)

	# Sheath provides a readable diagonal hip line in idle, echoing the concept sheet.
	var sheath := _add_box(_rig_root, "Sheath", Vector3(0.08, 0.08, 0.92), Vector3(-0.33, 0.78, 0.05), cloth)
	sheath.rotation = Vector3(0.0, -0.40, -0.22)
	_add_contact_shadow(_visual_root, 0.52, 0.34)


func _build_hound() -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "Rig"
	_visual_root.add_child(_rig_root)
	var hide := _material(Color(0.16, 0.075, 0.06, 1.0), 0.93)
	var dark := _material(Color(0.055, 0.035, 0.035, 1.0), 0.96)
	var blood := _material(Color(0.34, 0.025, 0.025, 1.0), 0.72)

	var body := _add_capsule(_rig_root, "Body", 0.30, 1.18, Vector3(0.0, 0.55, 0.0), hide)
	body.rotation.x = PI * 0.5
	_hound_head = Node3D.new()
	_hound_head.name = "HeadPivot"
	_hound_head.position = Vector3(0.0, 0.66, -0.62)
	_rig_root.add_child(_hound_head)
	_add_box(_hound_head, "Head", Vector3(0.48, 0.42, 0.52), Vector3.ZERO, hide)
	_add_box(_hound_head, "Muzzle", Vector3(0.31, 0.22, 0.38), Vector3(0.0, -0.05, -0.37), dark)
	var ear_l := _add_box(_hound_head, "EarL", Vector3(0.12, 0.34, 0.12), Vector3(-0.16, 0.30, -0.05), dark)
	var ear_r := _add_box(_hound_head, "EarR", Vector3(0.12, 0.34, 0.12), Vector3(0.16, 0.30, -0.05), dark)
	ear_l.rotation.z = -0.22
	ear_r.rotation.z = 0.22

	for x_sign: float in [-1.0, 1.0]:
		for z_sign: float in [-1.0, 1.0]:
			_add_box(_rig_root, "Leg", Vector3(0.13, 0.55, 0.14), Vector3(0.20 * x_sign, 0.26, 0.32 * z_sign), dark)

	_hound_tail = Node3D.new()
	_hound_tail.name = "TailPivot"
	_hound_tail.position = Vector3(0.0, 0.67, 0.57)
	_rig_root.add_child(_hound_tail)
	var tail := _add_box(_hound_tail, "Tail", Vector3(0.11, 0.11, 0.72), Vector3(0.0, 0.08, 0.31), hide)
	tail.rotation.x = -0.30
	_add_box(_rig_root, "CorruptionRidge", Vector3(0.18, 0.10, 0.72), Vector3(0.0, 0.85, 0.02), blood)
	_add_contact_shadow(_visual_root, 0.58, 0.34)


func _build_fallback_enemy() -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "Rig"
	_visual_root.add_child(_rig_root)
	var mat := _material(Color(0.24, 0.16, 0.12, 1.0), 0.88)
	_add_capsule(_rig_root, "Body", 0.32, 1.45, Vector3(0.0, 0.82, 0.0), mat)
	_add_sphere(_rig_root, "Head", 0.20, Vector3(0.0, 1.72, 0.0), mat)
	_add_contact_shadow(_visual_root, 0.44, 0.29)


func _animate_humanoid(speed: float) -> void:
	if _rig_root == null:
		return
	_reset_humanoid_pose()

	var animation := _source_animation_name()
	var attacking := _source_attack_active() or _contains_any(animation, ["attack", "slash", "cleave", "thrust", "counter"])
	var hurt := _contains_any(animation, ["hurt", "stagger", "parried"])
	var dead := _source_dead() or animation.contains("death")
	var moving := speed > 12.0 and not attacking and not dead

	if dead:
		_rig_root.rotation.z = 1.25
		_rig_root.position.y = -0.42
		return
	if hurt:
		_rig_root.rotation.x = -0.16
		_rig_root.rotation.z = sin(_motion_phase * 1.4) * 0.08
		return
	if attacking:
		var p := _source_action_progress()
		var swing := sin(clampf(p, 0.0, 1.0) * PI)
		_rig_root.rotation.y = lerpf(-0.28, 0.34, clampf(p, 0.0, 1.0))
		if _right_arm != null:
			_right_arm.rotation.x = -0.45 - 0.80 * swing
			_right_arm.rotation.y = lerpf(-0.95, 0.85, clampf(p, 0.0, 1.0))
			_right_arm.rotation.z = -0.18
		if _left_arm != null:
			_left_arm.rotation.x = -0.22 * swing
			_left_arm.rotation.y = lerpf(-0.25, 0.38, clampf(p, 0.0, 1.0))
		if _sword_pivot != null and _contains_any(str(_source_attack_id()), ["thrust", "lance", "jab"]):
			_sword_pivot.position.z = -0.30 * swing
		return

	if moving:
		var stride := sin(_motion_phase)
		_rig_root.position.y = absf(sin(_motion_phase * 2.0)) * 0.035
		if _left_leg != null:
			_left_leg.rotation.x = stride * 0.48
		if _right_leg != null:
			_right_leg.rotation.x = -stride * 0.48
		if _left_arm != null:
			_left_arm.rotation.x = -stride * 0.30
		if _right_arm != null:
			_right_arm.rotation.x = stride * 0.30
	else:
		_rig_root.position.y = sin(_motion_phase * 0.7) * 0.012
		if _head_pivot != null:
			_head_pivot.rotation.y = sin(_motion_phase * 0.31) * 0.025


func _reset_humanoid_pose() -> void:
	_rig_root.position = Vector3.ZERO
	_rig_root.rotation = Vector3.ZERO
	for pivot: Node3D in [_left_arm, _right_arm, _left_leg, _right_leg, _head_pivot, _sword_pivot]:
		if pivot != null:
			pivot.rotation = Vector3.ZERO
	if _sword_pivot != null:
		_sword_pivot.position = Vector3(0.03, -0.58, -0.02)


func _animate_hound(speed: float) -> void:
	if _rig_root == null:
		return
	_rig_root.position = Vector3.ZERO
	_rig_root.rotation = Vector3.ZERO
	if _hound_head != null:
		_hound_head.rotation = Vector3.ZERO
	if _hound_tail != null:
		_hound_tail.rotation = Vector3.ZERO

	var animation := _source_animation_name()
	var dead := _source_dead() or animation.contains("death")
	var attacking := _contains_any(animation, ["attack", "bite", "lunge", "charge"])
	if dead:
		_rig_root.rotation.z = 1.05
		_rig_root.position.y = -0.25
		return
	if attacking:
		var p := _source_action_progress()
		var bite := sin(clampf(p, 0.0, 1.0) * PI)
		_rig_root.rotation.x = -0.10 * bite
		if _hound_head != null:
			_hound_head.rotation.x = 0.34 * bite
		return
	if speed > 10.0:
		_rig_root.position.y = absf(sin(_motion_phase * 2.0)) * 0.045
		_rig_root.rotation.z = sin(_motion_phase) * 0.035
	if _hound_tail != null:
		_hound_tail.rotation.y = sin(_motion_phase * 1.7) * 0.55


func _sync_external_animation(speed: float) -> void:
	# Imported production/AI assets are allowed to own their AnimationPlayer clips. Map
	# the current 2D state conservatively; missing clips simply leave the imported pose.
	var player := _find_animation_player(_visual_root)
	if player == null:
		return
	var desired := ""
	var source_anim := _source_animation_name()
	var attacking := _source_attack_active() or _contains_any(source_anim, ["attack", "slash", "cleave", "thrust", "bite", "lunge"])
	if _source_dead():
		desired = _first_existing_animation(player, ["Death", "death", "Dying"])
	elif attacking:
		desired = _first_existing_animation(player, ["Sword_Attack", "SwordAttack", "Attack", "attack"])
	elif speed > 12.0:
		desired = _first_existing_animation(player, ["Jog", "Run", "Walk", "walk"])
	else:
		desired = _first_existing_animation(player, ["Idle", "idle"])
	if not desired.is_empty() and player.current_animation != desired:
		player.play(desired)


func _resolved_facing_2d() -> Vector2:
	if source_actor == null:
		return _last_facing_2d
	var animation := _source_animation_name()
	var attack_facing := _vector2_property(source_actor, "_attack_aim_dir")
	if (_source_attack_active() or _contains_any(animation, ["attack", "slash", "cleave", "thrust", "bite", "lunge", "parry", "block"])) and attack_facing.length_squared() > 0.001:
		return attack_facing
	var velocity := _source_velocity()
	if velocity.length_squared() > 4.0:
		return velocity.normalized()
	var facing := _vector2_property(source_actor, "_facing_dir")
	if facing.length_squared() > 0.001:
		return facing
	return _last_facing_2d


func _source_velocity() -> Vector2:
	if source_actor is CharacterBody2D:
		return (source_actor as CharacterBody2D).velocity
	return _vector2_property(source_actor, "velocity")


func _source_animation_name() -> String:
	var player := _find_animation_player(source_actor)
	if player != null and player.is_playing():
		return str(player.current_animation).to_lower()
	return ""


func _source_attack_active() -> bool:
	var profile := _property(source_actor, "_attack_profile")
	return profile is Dictionary and not (profile as Dictionary).is_empty()


func _source_attack_id() -> String:
	var profile := _property(source_actor, "_attack_profile")
	if profile is Dictionary:
		return str((profile as Dictionary).get("id", "")).to_lower()
	return ""


func _source_action_progress() -> float:
	var elapsed := float(_property(source_actor, "_attack_elapsed", 0.0))
	var profile := _property(source_actor, "_attack_profile")
	var duration := 0.45
	if profile is Dictionary:
		duration = maxf(0.05, float((profile as Dictionary).get("duration", duration)))
	if elapsed > 0.0:
		return clampf(elapsed / duration, 0.0, 1.0)
	# Enemy legacy AnimationPlayers do not expose attack elapsed; provide a stable loop
	# only for the temporary blockout pose.
	return fmod(_motion_phase * 0.28, 1.0)


func _source_dead() -> bool:
	var hp_value := _property(source_actor, "hp", null)
	if hp_value != null and (hp_value is int or hp_value is float):
		return float(hp_value) <= 0.0
	return false


func _property(object: Object, property_name: String, fallback: Variant = null) -> Variant:
	if object == null:
		return fallback
	for info: Dictionary in object.get_property_list():
		if str(info.get("name", "")) == property_name:
			return object.get(property_name)
	return fallback


func _vector2_property(object: Object, property_name: String) -> Vector2:
	var value := _property(object, property_name, Vector2.ZERO)
	return value if value is Vector2 else Vector2.ZERO


func _contains_any(value: String, needles: Array[String]) -> bool:
	var lower := value.to_lower()
	for needle: String in needles:
		if lower.contains(needle):
			return true
	return false


func _find_animation_player(node: Node) -> AnimationPlayer:
	if node == null:
		return null
	for child: Node in node.get_children():
		if child is AnimationPlayer:
			return child as AnimationPlayer
		var nested := _find_animation_player(child)
		if nested != null:
			return nested
	return null


func _first_existing_animation(player: AnimationPlayer, candidates: Array[String]) -> String:
	for candidate: String in candidates:
		if player.has_animation(candidate):
			return candidate
	return ""


func _limb_pivot(parent: Node3D, node_name: String, position_value: Vector3) -> Node3D:
	var pivot := Node3D.new()
	pivot.name = node_name
	pivot.position = position_value
	parent.add_child(pivot)
	return pivot


func _add_box(parent: Node3D, node_name: String, size: Vector3, position_value: Vector3, material: Material) -> MeshInstance3D:
	var mesh := BoxMesh.new()
	mesh.size = size
	return _add_mesh(parent, node_name, mesh, position_value, material)


func _add_sphere(parent: Node3D, node_name: String, radius: float, position_value: Vector3, material: Material) -> MeshInstance3D:
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mesh.radial_segments = 16
	mesh.rings = 8
	return _add_mesh(parent, node_name, mesh, position_value, material)


func _add_capsule(parent: Node3D, node_name: String, radius: float, height: float, position_value: Vector3, material: Material) -> MeshInstance3D:
	var mesh := CapsuleMesh.new()
	mesh.radius = radius
	mesh.height = maxf(height, radius * 2.0)
	mesh.radial_segments = 12
	mesh.rings = 6
	return _add_mesh(parent, node_name, mesh, position_value, material)


func _add_mesh(parent: Node3D, node_name: String, mesh: PrimitiveMesh, position_value: Vector3, material: Material) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.name = node_name
	instance.mesh = mesh
	instance.position = position_value
	instance.material_override = material
	instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	parent.add_child(instance)
	return instance


func _add_contact_shadow(parent: Node3D, radius_x: float, radius_z: float) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = 1.0
	mesh.bottom_radius = 1.0
	mesh.height = 0.018
	mesh.radial_segments = 24
	var shadow_material := _material(Color(0.015, 0.012, 0.014, 0.42), 1.0)
	shadow_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	var shadow := _add_mesh(parent, "ContactShadow", mesh, Vector3(0.0, 0.015, 0.0), shadow_material)
	shadow.scale = Vector3(radius_x, 1.0, radius_z)
	shadow.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


func _material(color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.roughness = roughness
	material.metallic = metallic
	return material
