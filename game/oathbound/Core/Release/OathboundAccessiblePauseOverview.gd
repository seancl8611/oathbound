extends "res://Core/Release/OathboundPauseOverview.gd"

const READABILITY_STYLER = preload("res://Core/Release/OathboundReadabilityStyler.gd")


func _ready() -> void:
	super._ready()
	call_deferred("_apply_readability")


func _apply_readability() -> void:
	READABILITY_STYLER.apply(self)
