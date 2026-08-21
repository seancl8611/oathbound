extends Node

signal currency_changed(currency: int, new_amount: int)

## CurrencyManager remains the lightweight HUD/compatibility bridge.
## Gold is truly run-only. Mist and Scrolls are canonical persistent resources
## owned by MetaProgress. The deprecated enum names remain so imported scenes do
## not fail to parse while the remaining UI is migrated.
enum Currency {
	GOLD,
	MIST_SHARDS, # Deprecated name; mirrors canonical Mist.
	SCROLLS,
	BOSS_EMBLEM, # Deprecated/unsupported. Oathbound has boss-specific materials.
}

var _amounts: Array[int] = []


func _ready() -> void:
	_amounts.resize(Currency.size())
	for i in range(_amounts.size()):
		_amounts[i] = 0

	if MetaProgress != null and MetaProgress.has_signal("persistent_resources_changed"):
		MetaProgress.persistent_resources_changed.connect(_on_persistent_resources_changed)
	_sync_persistent_mirrors(false)


func get_amount(currency: Currency) -> int:
	match currency:
		Currency.MIST_SHARDS:
			return int(MetaProgress.mist) if MetaProgress != null else _amounts[int(currency)]
		Currency.SCROLLS:
			return int(MetaProgress.scrolls) if MetaProgress != null else _amounts[int(currency)]
		Currency.BOSS_EMBLEM:
			return 0
		_:
			return _amounts[int(currency)]


func set_amount(currency: Currency, value: int) -> void:
	var idx := int(currency)
	value = maxi(value, 0)

	if currency == Currency.BOSS_EMBLEM:
		# Generic Boss Emblems were removed from the approved resource model.
		if value > 0:
			push_warning("[CurrencyManager] Ignoring deprecated Boss Emblem value.")
		return

	# Persistent resources may be mirrored here by RunData/HUD code, but this
	# setter never changes their canonical MetaProgress balances.
	if _amounts[idx] == value:
		return
	_amounts[idx] = value
	currency_changed.emit(idx, value)


func add(currency: Currency, delta: int) -> void:
	if delta == 0:
		return

	match currency:
		Currency.MIST_SHARDS:
			if delta > 0:
				MetaProgress.add_mist(delta)
			else:
				MetaProgress.spend_mist(-delta)
			_sync_persistent_mirrors()
		Currency.SCROLLS:
			if delta > 0:
				MetaProgress.add_scrolls(delta)
			else:
				MetaProgress.spend_scrolls(-delta)
			_sync_persistent_mirrors()
		Currency.BOSS_EMBLEM:
			push_warning("[CurrencyManager] Boss Emblem is deprecated; use a boss-specific MetaProgress material.")
		_:
			set_amount(currency, get_amount(currency) + delta)


func spend(currency: Currency, delta: int) -> bool:
	if delta <= 0:
		return true

	match currency:
		Currency.MIST_SHARDS:
			var spent_mist := MetaProgress.spend_mist(delta)
			_sync_persistent_mirrors()
			return spent_mist
		Currency.SCROLLS:
			var spent_scrolls := MetaProgress.spend_scrolls(delta)
			_sync_persistent_mirrors()
			return spent_scrolls
		Currency.BOSS_EMBLEM:
			push_warning("[CurrencyManager] Cannot spend deprecated Boss Emblems.")
			return false
		_:
			var current := get_amount(currency)
			if current < delta:
				return false
			set_amount(currency, current - delta)
			return true


func _on_persistent_resources_changed() -> void:
	_sync_persistent_mirrors()


func _sync_persistent_mirrors(emit_changes: bool = true) -> void:
	if MetaProgress == null or _amounts.is_empty():
		return

	var pairs := {
		Currency.MIST_SHARDS: int(MetaProgress.mist),
		Currency.SCROLLS: int(MetaProgress.scrolls),
	}
	for currency in pairs:
		var idx := int(currency)
		var value := int(pairs[currency])
		var changed := _amounts[idx] != value
		_amounts[idx] = value
		if emit_changes and changed:
			currency_changed.emit(idx, value)
