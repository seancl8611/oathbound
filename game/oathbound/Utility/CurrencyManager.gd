extends Node

signal currency_changed(currency: int, new_amount: int)

enum Currency {
	GOLD,
	MIST_SHARDS,
	SCROLLS,
	BOSS_EMBLEM,
}

var _amounts: Array[int] = []


func _ready() -> void:
	# Initialize all currencies to 0
	_amounts.resize(Currency.size())
	for i in range(_amounts.size()):
		_amounts[i] = 0


func get_amount(currency: Currency) -> int:
	return _amounts[int(currency)]


func set_amount(currency: Currency, value: int) -> void:
	var idx := int(currency)
	value = max(value, 0)

	if _amounts[idx] == value:
		return

	_amounts[idx] = value
	currency_changed.emit(idx, value)


func add(currency: Currency, delta: int) -> void:
	if delta == 0:
		return
	set_amount(currency, get_amount(currency) + delta)


func spend(currency: Currency, delta: int) -> bool:
	if delta <= 0:
		return true

	var current := get_amount(currency)
	if current < delta:
		return false

	set_amount(currency, current - delta)
	return true
