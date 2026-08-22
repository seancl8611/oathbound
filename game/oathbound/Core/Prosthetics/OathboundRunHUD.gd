extends "res://GUI/RunHUD.gd"

## Current Prosthetic Spirit presentation overlay.
## The imported HUD owns layout, but its ten pips originally represented a 0–10
## resource. Current Oathbound uses 0–100 Spirit, so each pip represents one tenth of
## the current maximum while the Prosthetic cost badge remains the exact Spirit cost.

func update_spirit(current: int, maximum: int) -> void:
	var old_spirit: int = _spirit
	_spirit = maxi(0, current)
	_spirit_max = maxi(1, maximum)
	var segment_count: int = maxi(1, _spirit_pips.size())

	for index: int in range(_spirit_pips.size()):
		var pip := _spirit_pips[index] as ColorRect
		var threshold: float = float(index + 1) / float(segment_count)
		var filled: bool = float(_spirit) / float(_spirit_max) >= threshold - 0.0001
		pip.color = COL_SPIRIT_FILLED if filled else COL_SPIRIT_EMPTY

	if current > old_spirit:
		_show_spirit_pop(current - old_spirit)
