extends "res://Regions/Hushiro/Presentation3D/HushiroCuratedActorVisual.gd"

## Second-pass Hushiro human presenter after the first live 3D acceptance test.
##
## The Quaternius reference mesh's authored local forward axis is opposite the bridge's
## -Z convention. The first slice therefore rotated the gameplay root correctly while the
## mesh itself looked backward. Keep the shared facing math untouched (Hound and authored
## standard enemies already use -Z) and correct only this imported humanoid tier.

const CURATED_FORWARD_CORRECTION_YAW := PI
const PLAYER_READABILITY_LIFT := Color(1.28, 1.26, 1.34, 1.0)
const ENEMY_READABILITY_LIFT := Color(1.20, 1.14, 1.08, 1.0)
const EXTERNAL_ANIMATION_DRIVER = preload("res://Utility/Planar3DExternalAnimationDriver.gd")

var _production_animation_state: Dictionary = {}


func _normalize_curated_model(model: Node3D, target_height: float) -> void:
	super._normalize_curated_model(model, target_height)
	# Correct imported local forward before _curated_base_rotation is captured by the
	# parent presenter. Source-facing, attack aim and movement direction remain unchanged.
	model.rotation.y += CURATED_FORWARD_CORRECTION_YAW


func _apply_illustrated_material_treatment(node: Node) -> void:
	super._apply_illustrated_material_treatment(node)
	_brighten_after_parent_treatment(node)


func _sync_external_animation(speed: float) -> void:
	# Final Akio/Swordsman GLBs use the same source-progress contract as other Hushiro V2
	# production actors. The curated Quaternius tier keeps its own remapped animation path.
	_production_animation_state = EXTERNAL_ANIMATION_DRIVER.sync(_visual_root, source_actor, speed)


func get_production_animation_state_for_test() -> Dictionary:
	if not _external_model_active:
		return {
			"external_model_active": false,
			"mode": "inactive",
			"clip": "",
			"source": "none",
			"progress": -1.0,
		}
	var state := _production_animation_state.duplicate(true)
	state["external_model_active"] = true
	return state


func get_curated_animation_state_for_test() -> Dictionary:
	var state := super.get_curated_animation_state_for_test()
	state["forward_correction_degrees"] = rad_to_deg(CURATED_FORWARD_CORRECTION_YAW)
	state["readability_revision"] = 2
	return state


func _brighten_after_parent_treatment(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh != null:
			var lift := PLAYER_READABILITY_LIFT if actor_role == "player" else ENEMY_READABILITY_LIFT
			for surface_index: int in range(mesh_instance.mesh.get_surface_count()):
				var active := mesh_instance.get_active_material(surface_index)
				if active is StandardMaterial3D:
					var material := active as StandardMaterial3D
					material.albedo_color = Color(
						minf(1.0, material.albedo_color.r * lift.r),
						minf(1.0, material.albedo_color.g * lift.g),
						minf(1.0, material.albedo_color.b * lift.b),
						material.albedo_color.a
					)
	for child: Node in node.get_children():
		_brighten_after_parent_treatment(child)
