extends "res://Core/Relics/OathboundRelicPlaytestLab.gd"

## Focused Corruption / Shrine controls layered on the current Technique, Aspect,
## Prosthetic, and Relic Playtest Lab.

var _corruption_status: Label


func _build_build_tab(tabs: TabContainer) -> void:
	super._build_build_tab(tabs)
	_build_corruption_tab(tabs)


func _build_corruption_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Corruption")

	var title := Label.new()
	title.text = "Corruption / Shrine first-playtest authority"
	vbox.add_child(title)

	var awakening_row := HBoxContainer.new()
	vbox.add_child(awakening_row)
	var awaken := Button.new()
	awaken.text = "Awaken Returning Blood"
	awaken.pressed.connect(_awaken_returning_blood)
	awakening_row.add_child(awaken)

	var corruption_row := HBoxContainer.new()
	vbox.add_child(corruption_row)
	for value: int in [0, 50, 75, 99, 100]:
		var button := Button.new()
		button.text = "Corruption %d" % value
		button.pressed.connect(_set_corruption.bind(value))
		corruption_row.add_child(button)

	var tier_row := HBoxContainer.new()
	vbox.add_child(tier_row)
	for tier: int in range(5):
		var button := Button.new()
		button.text = "Tier %d" % tier
		button.pressed.connect(_set_aspect_tier.bind(tier))
		tier_row.add_child(button)

	_corruption_status = Label.new()
	_corruption_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_corruption_status.modulate = Color(0.74, 0.72, 0.82)
	vbox.add_child(_corruption_status)

	var note := Label.new()
	note.text = "Use Corruption 100 + Tier 0-III to test Resist/Embrace. Use Corruption 100 + Tier IV to test Stabilize. Awakening is persistent campaign state."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.62, 0.64, 0.70)
	vbox.add_child(note)

	_refresh_corruption_status()
	print("[OathboundPlaytestLab] Corruption tab built")


func _awaken_returning_blood() -> void:
	var runtime := _corruption_runtime()
	if runtime != null:
		runtime.call("awaken_returning_blood")
	_refresh_corruption_status()


func _set_corruption(value: int) -> void:
	var runtime := _corruption_runtime()
	if runtime != null:
		runtime.call("set_corruption_for_playtest", value)
	_refresh_corruption_status()


func _set_aspect_tier(tier: int) -> void:
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("set_tier"):
		AspectRuntime.call("set_tier", tier)
	_refresh_corruption_status()


func _refresh_corruption_status() -> void:
	if _corruption_status == null:
		return
	var runtime := _corruption_runtime()
	if runtime == null:
		_corruption_status.text = "CorruptionRuntime unavailable."
		return
	var awakened: bool = bool(runtime.call("is_awakened"))
	var current: int = int(runtime.call("get_corruption"))
	var state: String = str(runtime.call("get_corruption_state"))
	var shrine_state: String = str(runtime.call("get_shrine_state"))
	var aspect: String = str(AspectRuntime.selected_aspect) if typeof(AspectRuntime) == TYPE_OBJECT else "none"
	var tier: int = int(AspectRuntime.tier) if typeof(AspectRuntime) == TYPE_OBJECT else 0
	_corruption_status.text = "Awakened: %s | %d / 100 (%s) | Shrine: %s | Aspect: %s Tier %d\nCurrent: %s\nNext: %s" % [
		str(awakened), current, state, shrine_state, aspect, tier,
		str(runtime.call("get_current_tier_headline")),
		str(runtime.call("get_next_tier_headline")),
	]


func _corruption_runtime() -> Node:
	return get_node_or_null("/root/CorruptionRuntime")
