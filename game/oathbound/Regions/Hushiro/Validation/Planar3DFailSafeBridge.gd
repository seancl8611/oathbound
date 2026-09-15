extends "res://Utility/Planar3DPresentationBridge.gd"

## Validation-only bridge used to prove replacement failure is non-destructive.
## It supplies a valid environment and lets the smoke move through both failure and
## recovery states. The shared bridge must keep authoritative 2D actor art reversible
## even if a previously-valid replacement disappears and rebuilding later fails.

const ACTOR_VISUAL_SCRIPT = preload("res://Utility/Planar3DActorVisual.gd")

var allow_actor_visuals: bool = false


func _create_environment_root() -> Node3D:
	var root := Node3D.new()
	root.name = "FailSafeValidationEnvironment"
	return root


func _create_actor_visual(_actor: Node2D, _role: String) -> Node3D:
	if not allow_actor_visuals:
		return null
	var visual_value: Variant = ACTOR_VISUAL_SCRIPT.new()
	return visual_value as Node3D if visual_value is Node3D else null


func set_actor_visuals_allowed(active: bool) -> void:
	allow_actor_visuals = active


func drop_actor_visuals() -> void:
	for actor_id: Variant in _actor_visuals.keys():
		var visual_value: Variant = _actor_visuals.get(actor_id)
		if visual_value is Node and is_instance_valid(visual_value as Node):
			(visual_value as Node).queue_free()
	_actor_visuals.clear()
