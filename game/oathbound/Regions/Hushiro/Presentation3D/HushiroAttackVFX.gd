extends Node3D

## Presentation-only 3D attack accent for the Hushiro vertical slice.
##
## The authoritative 2D actor still owns attack startup/active/recovery timing, hitboxes,
## damage and collision. This node only mirrors that state into a short emissive sword arc.
## It is parented to the mirrored 3D actor, so local -Z remains the actor's facing direction.

const ARC_SEGMENTS := 7

var source_actor: Node2D = null
var actor_role := "enemy"
var _arc_root: Node3D = null
var _material: StandardMaterial3D = null


func _ready() -> void:
	_build_arc()
	set_process(true)


func configure(role: String, actor: Node2D) -> void:
	actor_role = role
	source_actor = actor
	if is_node_ready():
		_apply_role_style()


func is_contract_ready() -> bool:
	return _arc_root != null and _arc_root.get_child_count() == ARC_SEGMENTS and actor_role in ["player", "swordsman"]


func _process(_delta: float) -> void:
	if _arc_root == null:
		return
	if source_actor == null or not is_instance_valid(source_actor) or actor_role not in ["player", "swordsman"]:
		_arc_root.visible = false
		return

	var attacking := _source_attack_active() or _source_animation_is_attack()
	if not attacking:
		_arc_root.visible = false
		return

	var progress := _source_action_progress()
	# Keep the decorative sweep inside the middle of the authoritative action. This does
	# not imply an active damage window; it is intentionally presentation-only.
	var window_progress := clampf((progress - 0.10) / 0.68, 0.0, 1.0)
	var visible_now := progress >= 0.10 and progress <= 0.78
	_arc_root.visible = visible_now
	if not visible_now:
		return

	var sweep := lerpf(-0.62, 0.62, window_progress)
	var pulse := sin(window_progress * PI)
	_arc_root.rotation.y = sweep
	_arc_root.rotation.x = lerpf(-0.12, 0.10, window_progress)
	_arc_root.scale = Vector3.ONE * lerpf(0.86, 1.05, pulse)
	_arc_root.position.y = 0.02 + pulse * 0.08


func _build_arc() -> void:
	_arc_root = Node3D.new()
	_arc_root.name = "SwordArc"
	_arc_root.position = Vector3(0.0, 0.88, -0.24)
	_arc_root.visible = false
	add_child(_arc_root)

	_material = StandardMaterial3D.new()
	_material.albedo_color = Color(0.82, 0.18, 0.07, 0.66)
	_material.roughness = 0.32
	_material.metallic = 0.08
	_material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_material.emission_enabled = true
	_material.emission = Color(1.0, 0.14, 0.045, 1.0)
	_material.emission_energy_multiplier = 2.6

	for index: int in range(ARC_SEGMENTS):
		var t := float(index) / float(ARC_SEGMENTS - 1)
		var angle := lerpf(-0.82, 0.82, t)
		var radius := 0.88
		var segment := MeshInstance3D.new()
		segment.name = "ArcSegment%02d" % index
		var mesh := BoxMesh.new()
		mesh.size = Vector3(0.055, 0.075, 0.34)
		segment.mesh = mesh
		segment.position = Vector3(sin(angle) * radius, (1.0 - absf(t - 0.5) * 2.0) * 0.12, -cos(angle) * radius)
		segment.rotation.y = -angle
		segment.material_override = _material
		segment.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		_arc_root.add_child(segment)
	_apply_role_style()


func _apply_role_style() -> void:
	if _material == null:
		return
	if actor_role == "player":
		_material.albedo_color = Color(0.80, 0.16, 0.055, 0.70)
		_material.emission = Color(1.0, 0.12, 0.035, 1.0)
		_material.emission_energy_multiplier = 2.8
	elif actor_role == "swordsman":
		_material.albedo_color = Color(0.58, 0.20, 0.09, 0.62)
		_material.emission = Color(0.88, 0.19, 0.06, 1.0)
		_material.emission_energy_multiplier = 2.1


func _source_attack_active() -> bool:
	var profile := _property(source_actor, "_attack_profile", null)
	return profile is Dictionary and not (profile as Dictionary).is_empty()


func _source_animation_is_attack() -> bool:
	var player := _find_animation_player(source_actor)
	if player == null or not player.is_playing():
		return false
	var name := str(player.current_animation).to_lower()
	for token: String in ["attack", "slash", "cleave", "thrust", "counter"]:
		if name.contains(token):
			return true
	return false


func _source_action_progress() -> float:
	var elapsed := float(_property(source_actor, "_attack_elapsed", 0.0))
	var profile := _property(source_actor, "_attack_profile", null)
	var duration := 0.45
	if profile is Dictionary:
		duration = maxf(0.05, float((profile as Dictionary).get("duration", duration)))
	if elapsed > 0.0:
		return clampf(elapsed / duration, 0.0, 1.0)
	# Legacy enemy AnimationPlayers may not expose elapsed time. Keep any fallback purely
	# visual and deterministic; it never feeds back into attack resolution.
	return fmod(Time.get_ticks_msec() / 1000.0, duration) / duration


func _property(object: Object, property_name: String, fallback: Variant = null) -> Variant:
	if object == null:
		return fallback
	for info: Dictionary in object.get_property_list():
		if str(info.get("name", "")) == property_name:
			return object.get(property_name)
	return fallback


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
