extends "res://Utility/Planar3DPresentationBridge.gd"

## Validation-only bridge used to prove replacement failure is non-destructive.
## It supplies a valid environment so room replacement is active, then deliberately
## refuses to create actor visuals. The shared bridge must leave legacy actor bodies
## visible rather than turning gameplay actors invisible.


func _create_environment_root() -> Node3D:
	var root := Node3D.new()
	root.name = "FailSafeValidationEnvironment"
	return root


func _create_actor_visual(_actor: Node2D, _role: String) -> Node3D:
	return null
