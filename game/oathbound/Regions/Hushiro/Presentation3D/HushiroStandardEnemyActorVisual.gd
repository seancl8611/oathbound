extends "res://Utility/Planar3DActorVisual.gd"

## Authored Hushiro blockout silhouettes for standard enemies that do not yet have final
## role-specific GLBs. These are intentionally much stronger than the shared capsule
## fallback: every launch Hushiro role gets a distinct height, mass, weapon/profile and
## corruption accent so multi-enemy encounters remain readable from the gameplay camera.
## Combat remains entirely owned by the source Node2D.

const SUPPORTED_ROLES: Array[String] = ["hollow", "archer", "bilemass", "warden"]


func _rebuild_visual() -> void:
	# Let the shared presenter create/reset VisualRoot and try a true production slot, but
	# do not allow it to fall through to the anonymous capsule fallback.
	var procedural_requested := use_procedural_fallback
	use_procedural_fallback = false
	super._rebuild_visual()
	use_procedural_fallback = procedural_requested

	if _external_model_active or _visual_root == null:
		return

	match actor_role:
		"hollow":
			_build_hollow()
		"archer":
			_build_archer()
		"bilemass":
			_build_bilemass()
		"warden":
			_build_warden()
		_:
			_build_unknown_hushiro_enemy()


func get_visual_tier() -> String:
	if _external_model_active:
		return "role_specific_glb"
	return "hushiro_authored_standard"


func get_role_visual_state_for_test() -> Dictionary:
	return {
		"role": actor_role,
		"tier": get_visual_tier(),
		"supported_role": SUPPORTED_ROLES.has(actor_role),
		"has_mesh": _visual_root != null and not _visual_root.find_children("*", "MeshInstance3D", true, false).is_empty(),
	}


func _build_hollow() -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "HollowRig"
	_visual_root.add_child(_rig_root)

	var rag := _material(Color(0.17, 0.145, 0.135, 1.0), 0.96)
	var rag_dark := _material(Color(0.065, 0.058, 0.060, 1.0), 0.98)
	var skin := _material(Color(0.30, 0.255, 0.22, 1.0), 0.95)
	var rust := _material(Color(0.28, 0.105, 0.055, 1.0), 0.78, 0.06)
	var corruption := _emissive_material(Color(0.52, 0.055, 0.028, 1.0), Color(0.72, 0.035, 0.015, 1.0), 1.8)

	# Low, forward-heavy silhouette: a shambling corrupted villager rather than a capsule.
	var torso := _add_box(_rig_root, "HollowTorso", Vector3(0.46, 0.63, 0.28), Vector3(0.0, 1.02, 0.06), rag)
	torso.rotation.x = -0.13
	_add_box(_rig_root, "TornWaist", Vector3(0.55, 0.42, 0.34), Vector3(0.0, 0.64, 0.08), rag_dark)

	_head_pivot = Node3D.new()
	_head_pivot.name = "HollowHeadPivot"
	_head_pivot.position = Vector3(0.0, 1.43, -0.16)
	_rig_root.add_child(_head_pivot)
	_add_sphere(_head_pivot, "HollowHead", 0.17, Vector3.ZERO, skin)
	_add_box(_head_pivot, "SunkenFace", Vector3(0.23, 0.12, 0.055), Vector3(0.0, -0.01, -0.16), rag_dark)
	_add_box(_head_pivot, "CorruptionEye", Vector3(0.055, 0.035, 0.025), Vector3(0.065, 0.015, -0.195), corruption)

	_left_arm = _limb_pivot(_rig_root, "LeftArmPivot", Vector3(-0.28, 1.22, -0.01))
	_right_arm = _limb_pivot(_rig_root, "RightArmPivot", Vector3(0.28, 1.20, -0.03))
	_add_box(_left_arm, "LeftArm", Vector3(0.13, 0.68, 0.14), Vector3(0.0, -0.31, -0.04), skin)
	_add_box(_right_arm, "RightArm", Vector3(0.14, 0.70, 0.15), Vector3(0.0, -0.31, -0.05), skin)
	_left_arm.rotation.z = -0.12
	_right_arm.rotation.z = 0.11

	_left_leg = _limb_pivot(_rig_root, "LeftLegPivot", Vector3(-0.13, 0.50, 0.04))
	_right_leg = _limb_pivot(_rig_root, "RightLegPivot", Vector3(0.13, 0.50, 0.04))
	_add_box(_left_leg, "LeftLeg", Vector3(0.17, 0.58, 0.19), Vector3(0.0, -0.27, 0.0), rag_dark)
	_add_box(_right_leg, "RightLeg", Vector3(0.17, 0.58, 0.19), Vector3(0.0, -0.27, 0.0), rag_dark)

	# A short broken cleaver creates a strong front-facing read from the high camera.
	_sword_pivot = Node3D.new()
	_sword_pivot.name = "BrokenCleaverPivot"
	_sword_pivot.position = Vector3(0.02, -0.57, -0.06)
	_right_arm.add_child(_sword_pivot)
	var blade := _add_box(_sword_pivot, "BrokenCleaver", Vector3(0.12, 0.055, 0.62), Vector3(0.0, 0.0, -0.27), rust)
	blade.rotation.y = -0.08
	_add_contact_shadow(_visual_root, 0.46, 0.30)


func _build_archer() -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "ArcherRig"
	_visual_root.add_child(_rig_root)

	var cloth := _material(Color(0.12, 0.105, 0.095, 1.0), 0.95)
	var cloth_mid := _material(Color(0.24, 0.16, 0.105, 1.0), 0.91)
	var hood := _material(Color(0.055, 0.050, 0.052, 1.0), 0.98)
	var wood := _material(Color(0.25, 0.12, 0.055, 1.0), 0.88)
	var steel := _material(Color(0.48, 0.45, 0.40, 1.0), 0.52, 0.18)
	var corruption := _emissive_material(Color(0.44, 0.045, 0.025, 1.0), Color(0.70, 0.035, 0.012, 1.0), 1.5)

	_add_box(_rig_root, "ArcherTorso", Vector3(0.43, 0.72, 0.27), Vector3(0.0, 1.15, 0.0), cloth_mid)
	_add_box(_rig_root, "ArcherCoat", Vector3(0.55, 0.64, 0.34), Vector3(0.0, 0.72, 0.05), cloth)
	_head_pivot = Node3D.new()
	_head_pivot.name = "ArcherHeadPivot"
	_head_pivot.position = Vector3(0.0, 1.62, -0.02)
	_rig_root.add_child(_head_pivot)
	_add_sphere(_head_pivot, "ArcherHead", 0.16, Vector3.ZERO, hood)
	_add_box(_head_pivot, "HoodPeak", Vector3(0.42, 0.12, 0.36), Vector3(0.0, 0.14, 0.02), hood)
	_add_box(_head_pivot, "CorruptMark", Vector3(0.07, 0.045, 0.025), Vector3(-0.055, 0.0, -0.17), corruption)

	_left_arm = _limb_pivot(_rig_root, "LeftArmPivot", Vector3(-0.30, 1.38, 0.0))
	_right_arm = _limb_pivot(_rig_root, "RightArmPivot", Vector3(0.30, 1.38, 0.0))
	_add_box(_left_arm, "LeftArm", Vector3(0.13, 0.62, 0.14), Vector3(0.0, -0.29, -0.02), cloth)
	_add_box(_right_arm, "RightArm", Vector3(0.13, 0.62, 0.14), Vector3(0.0, -0.29, -0.02), cloth)
	_left_arm.rotation.x = -0.34
	_right_arm.rotation.x = -0.44

	_left_leg = _limb_pivot(_rig_root, "LeftLegPivot", Vector3(-0.13, 0.48, 0.0))
	_right_leg = _limb_pivot(_rig_root, "RightLegPivot", Vector3(0.13, 0.48, 0.0))
	_add_box(_left_leg, "LeftLeg", Vector3(0.16, 0.66, 0.18), Vector3(0.0, -0.31, 0.0), cloth)
	_add_box(_right_leg, "RightLeg", Vector3(0.16, 0.66, 0.18), Vector3(0.0, -0.31, 0.0), cloth)

	# Bow is held to the actor's left/front; quiver sits high on the back. Both are large
	# enough to identify the ranged role without relying on UI.
	var bow_root := Node3D.new()
	bow_root.name = "BowRoot"
	bow_root.position = Vector3(-0.36, 1.16, -0.30)
	_rig_root.add_child(bow_root)
	var upper := _add_box(bow_root, "BowUpper", Vector3(0.055, 0.72, 0.055), Vector3(0.0, 0.31, 0.0), wood)
	var lower := _add_box(bow_root, "BowLower", Vector3(0.055, 0.72, 0.055), Vector3(0.0, -0.31, 0.0), wood)
	upper.rotation.z = -0.20
	lower.rotation.z = 0.20
	_add_box(bow_root, "BowGrip", Vector3(0.075, 0.20, 0.07), Vector3.ZERO, cloth)
	_add_box(_rig_root, "Quiver", Vector3(0.24, 0.76, 0.22), Vector3(0.32, 1.18, 0.23), wood).rotation.z = -0.20
	for index: int in range(3):
		_add_box(_rig_root, "Arrow%d" % index, Vector3(0.025, 0.78, 0.025), Vector3(0.22 + 0.07 * index, 1.52, 0.25), steel).rotation.z = -0.20
	_add_contact_shadow(_visual_root, 0.45, 0.29)


func _build_bilemass() -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "BilemassRig"
	_visual_root.add_child(_rig_root)

	var flesh := _material(Color(0.23, 0.16, 0.115, 1.0), 0.98)
	var flesh_dark := _material(Color(0.085, 0.065, 0.052, 1.0), 0.99)
	var bile := _emissive_material(Color(0.30, 0.42, 0.10, 1.0), Color(0.40, 0.68, 0.08, 1.0), 1.7)
	var blood := _material(Color(0.30, 0.025, 0.020, 1.0), 0.90)

	_add_sphere(_rig_root, "MassCore", 0.48, Vector3(0.0, 0.53, 0.02), flesh)
	_add_sphere(_rig_root, "MassShoulderL", 0.34, Vector3(-0.34, 0.70, 0.06), flesh)
	_add_sphere(_rig_root, "MassShoulderR", 0.31, Vector3(0.34, 0.66, 0.02), flesh_dark)
	_add_sphere(_rig_root, "MassBack", 0.34, Vector3(0.05, 0.78, 0.27), flesh_dark)
	_add_box(_rig_root, "Maw", Vector3(0.48, 0.20, 0.12), Vector3(0.02, 0.50, -0.43), flesh_dark)
	_add_box(_rig_root, "MawBlood", Vector3(0.34, 0.07, 0.035), Vector3(0.02, 0.47, -0.50), blood)
	_add_sphere(_rig_root, "BileSacL", 0.17, Vector3(-0.24, 0.88, -0.23), bile)
	_add_sphere(_rig_root, "BileSacR", 0.14, Vector3(0.27, 0.77, -0.28), bile)
	for sign: float in [-1.0, 1.0]:
		var limb := _add_box(_rig_root, "CrawlerLimb", Vector3(0.18, 0.18, 0.58), Vector3(0.46 * sign, 0.22, -0.02), flesh_dark)
		limb.rotation.y = 0.55 * sign
	_add_contact_shadow(_visual_root, 0.68, 0.48)


func _build_warden() -> void:
	_rig_root = Node3D.new()
	_rig_root.name = "WardenRig"
	_visual_root.add_child(_rig_root)

	var armor := _material(Color(0.15, 0.13, 0.115, 1.0), 0.66, 0.22)
	var armor_dark := _material(Color(0.055, 0.052, 0.052, 1.0), 0.78, 0.12)
	var cloth := _material(Color(0.24, 0.075, 0.055, 1.0), 0.91)
	var steel := _material(Color(0.48, 0.49, 0.47, 1.0), 0.44, 0.38)
	var corruption := _emissive_material(Color(0.48, 0.035, 0.020, 1.0), Color(0.74, 0.025, 0.012, 1.0), 1.8)

	_add_box(_rig_root, "WardenTorso", Vector3(0.76, 0.90, 0.40), Vector3(0.0, 1.35, 0.0), armor)
	_add_box(_rig_root, "WardenWaist", Vector3(0.68, 0.56, 0.38), Vector3(0.0, 0.78, 0.03), cloth)
	_add_box(_rig_root, "WardenShoulders", Vector3(1.08, 0.22, 0.48), Vector3(0.0, 1.67, 0.0), armor_dark)
	_head_pivot = Node3D.new()
	_head_pivot.name = "WardenHeadPivot"
	_head_pivot.position = Vector3(0.0, 1.93, -0.02)
	_rig_root.add_child(_head_pivot)
	_add_box(_head_pivot, "WardenMask", Vector3(0.40, 0.40, 0.32), Vector3.ZERO, armor_dark)
	_add_box(_head_pivot, "MaskFace", Vector3(0.27, 0.24, 0.055), Vector3(0.0, -0.02, -0.19), steel)
	_add_box(_head_pivot, "MaskGlow", Vector3(0.16, 0.035, 0.022), Vector3(0.0, 0.025, -0.225), corruption)

	_left_arm = _limb_pivot(_rig_root, "LeftArmPivot", Vector3(-0.48, 1.52, 0.0))
	_right_arm = _limb_pivot(_rig_root, "RightArmPivot", Vector3(0.48, 1.52, 0.0))
	_add_box(_left_arm, "LeftArm", Vector3(0.24, 0.76, 0.24), Vector3(0.0, -0.34, 0.0), armor)
	_add_box(_right_arm, "RightArm", Vector3(0.24, 0.76, 0.24), Vector3(0.0, -0.34, 0.0), armor)
	_left_leg = _limb_pivot(_rig_root, "LeftLegPivot", Vector3(-0.20, 0.60, 0.0))
	_right_leg = _limb_pivot(_rig_root, "RightLegPivot", Vector3(0.20, 0.60, 0.0))
	_add_box(_left_leg, "LeftLeg", Vector3(0.28, 0.82, 0.30), Vector3(0.0, -0.38, 0.0), armor_dark)
	_add_box(_right_leg, "RightLeg", Vector3(0.28, 0.82, 0.30), Vector3(0.0, -0.38, 0.0), armor_dark)

	_sword_pivot = Node3D.new()
	_sword_pivot.name = "PolearmPivot"
	_sword_pivot.position = Vector3(0.0, -0.64, -0.06)
	_right_arm.add_child(_sword_pivot)
	_add_box(_sword_pivot, "PolearmShaft", Vector3(0.07, 0.07, 1.65), Vector3(0.0, 0.0, -0.76), armor_dark)
	_add_box(_sword_pivot, "PolearmBlade", Vector3(0.22, 0.08, 0.52), Vector3(0.0, 0.0, -1.66), steel)
	_add_contact_shadow(_visual_root, 0.62, 0.38)


func _build_unknown_hushiro_enemy() -> void:
	# Never fall back to the anonymous shared capsule in Hushiro. Unknown roles receive a
	# deliberately obvious effigy silhouette so missing role coverage is visible without
	# making the actor itself disappear.
	_rig_root = Node3D.new()
	_rig_root.name = "UnknownHushiroRig"
	_visual_root.add_child(_rig_root)
	var cloth := _material(Color(0.18, 0.10, 0.085, 1.0), 0.97)
	var dark := _material(Color(0.045, 0.040, 0.042, 1.0), 0.99)
	_add_box(_rig_root, "EffigyBody", Vector3(0.46, 1.25, 0.30), Vector3(0.0, 0.72, 0.0), cloth)
	_add_sphere(_rig_root, "EffigyHead", 0.19, Vector3(0.0, 1.52, -0.04), dark)
	_add_box(_rig_root, "EffigyMarker", Vector3(0.62, 0.08, 0.08), Vector3(0.0, 1.84, 0.0), cloth)
	_add_contact_shadow(_visual_root, 0.45, 0.30)


func _emissive_material(color: Color, emission: Color, energy: float) -> StandardMaterial3D:
	var material := _material(color, 0.76)
	material.emission_enabled = true
	material.emission = emission
	material.emission_energy_multiplier = energy
	return material
