extends "res://Core/Release/OathboundRunResultsOverlay.gd"

const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")


func present(result: Dictionary) -> void:
	super.present(result)
	call_deferred("_apply_readability")


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
