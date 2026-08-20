extends Node

var gold: int = 0
var mist_shards: int = 0
var max_hp: int = 100
var hp: int = 100

func add_gold(amount: int) -> void:
	gold += max(amount, 0)
	print("Gold:", gold)

func add_shards(amount: int) -> void:
	mist_shards += max(amount, 0)
	print("Shards:", mist_shards)

func heal_percent(p: float) -> void:
	var amt: int = int(float(max_hp) * p)
	hp = clamp(hp + amt, 0, max_hp)
	print("HP:", hp, "/", max_hp)
