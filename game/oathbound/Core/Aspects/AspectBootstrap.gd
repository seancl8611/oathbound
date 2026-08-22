extends Node

## Keeps the Blood Aspect Player registered with the current Oathbound GameFlow layer
## while retaining res://Player/player.tscn only as the inherited compatibility base.

const ASPECT_PLAYER_SCENE: PackedScene = preload("res://Player/aspect_player.tscn")

func _ready() -> void:
	if typeof(GameFlow) == TYPE_OBJECT and GameFlow.has_method("set_player_scene"):
		GameFlow.set_player_scene(ASPECT_PLAYER_SCENE)
	else:
		push_error("[AspectBootstrap] Canonical GameFlow player factory API is unavailable")
	print("[AspectBootstrap] GameFlow player factory -> aspect_player.tscn")
