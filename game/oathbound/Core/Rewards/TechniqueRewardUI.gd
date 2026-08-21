extends "res://Utility/UpgradeChoiceUI.gd"

## Canonical player-facing wrapper over the imported card UI while the Technique
## presentation layer is migrated. The legacy scene remains reusable, but current
## rewards should say Technique rather than Boon.


func _ready() -> void:
	super._ready()
	if _title_label != null:
		_title_label.text = "Choose a Technique"
