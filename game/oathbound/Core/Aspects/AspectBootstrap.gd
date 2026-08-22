extends Node

## Routes GameFlow's player factory to the inherited Blood Aspect player scene while
## retaining res://Player/player.tscn as the imported compatibility base.

const ASPECT_PLAYER_SCENE := preload("res://Player/aspect_player.tscn")

func _ready() -> void:
	if typeof(GameFlow) == TYPE_OBJECT:
		GameFlow.set("_player_packed", ASPECT_PLAYER_SCENE)
	print("[AspectBootstrap] GameFlow player factory -> aspect_player.tscn")
