extends Node
var areas_unlocked: Array[int] = [1]
var boss_clears := {1:false, 2:false, 3:false}
var trainer_key_owned: bool = false

func unlock_area(id:int) -> void:
	if not areas_unlocked.has(id):
		areas_unlocked.append(id)

func mark_boss_clear(id:int) -> void:
	boss_clears[id] = true
