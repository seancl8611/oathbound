extends "res://Regions/Hushiro/Presentation3D/HushiroStandardEnemyActorVisual.gd"

## V2 standard-enemy wrapper for final role-specific GLBs. Authored Hollow/Archer/
## Bilemass/Warden silhouettes remain the fallback; production models mirror exact source
## attack progress when the authoritative 2D actor exposes it.

const EXTERNAL_ANIMATION_DRIVER = preload("res://Utility/Planar3DExternalAnimationDriver.gd")

var _production_animation_state: Dictionary = {}


func _sync_external_animation(speed: float) -> void:
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
