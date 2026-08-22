extends Node

## Adds Blood Aspect controls to the existing Playtest Lab Build tab without making
## the Lab itself own Aspect rules. The bridge is debug-only UI around AspectRuntime.

var _attached := false
var _status: Label = null
var _refresh := 0.0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not OS.is_debug_build():
		set_process(false)

func _process(delta: float) -> void:
	if not _attached:
		_try_attach()
		return
	_refresh += delta
	if _refresh >= 0.20:
		_refresh = 0.0
		_refresh_status()

func _try_attach() -> void:
	if typeof(PlaytestLab) != TYPE_OBJECT:
		return
	var ui = PlaytestLab.get("_ui")
	if ui == null or not is_instance_valid(ui):
		return
	var build_tab := _find_named(ui, "Build")
	if build_tab == null:
		return
	var container := _find_vbox(build_tab)
	if container == null:
		return

	var separator := HSeparator.new()
	container.add_child(separator)

	var title := Label.new()
	title.text = "Blood Aspect runtime"
	title.add_theme_font_size_override("font_size", 14)
	container.add_child(title)

	_status = Label.new()
	container.add_child(_status)

	var aspect_row := HBoxContainer.new()
	container.add_child(aspect_row)
	for aspect in ["wolf", "wraith", "ronin"]:
		var button := Button.new()
		button.text = aspect.capitalize()
		button.pressed.connect(_select_aspect.bind(aspect))
		aspect_row.add_child(button)

	var tier_row := HBoxContainer.new()
	container.add_child(tier_row)
	for tier_value in range(5):
		var button := Button.new()
		button.text = "T%d" % tier_value
		button.pressed.connect(_set_tier.bind(tier_value))
		tier_row.add_child(button)

	var blood_row := HBoxContainer.new()
	container.add_child(blood_row)
	var fill := Button.new()
	fill.text = "Fill Blood"
	fill.pressed.connect(func(): AspectRuntime.set_blood_for_playtest(100.0))
	blood_row.add_child(fill)
	var clear := Button.new()
	clear.text = "Clear Blood"
	clear.pressed.connect(func(): AspectRuntime.set_blood_for_playtest(0.0))
	blood_row.add_child(clear)
	var next_tier := Button.new()
	next_tier.text = "Next Tier"
	next_tier.pressed.connect(func(): AspectRuntime.advance_tier())
	blood_row.add_child(next_tier)

	var note := Label.new()
	note.text = "Q activates the Tier II Blood Art when Blood is Ready. Aspect selection resets Tier/Blood."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	container.add_child(note)

	_attached = true
	_refresh_status()

func _select_aspect(aspect: String) -> void:
	AspectRuntime.select_aspect(aspect)
	_refresh_status()

func _set_tier(value: int) -> void:
	AspectRuntime.set_tier(value)
	_refresh_status()

func _refresh_status() -> void:
	if _status == null or typeof(AspectRuntime) != TYPE_OBJECT:
		return
	_status.text = "%s | Tier %d | Blood %d/100 | %s" % [
		AspectRuntime.selected_aspect.capitalize(),
		AspectRuntime.tier,
		int(round(AspectRuntime.blood)),
		AspectRuntime.blood_state(),
	]

func _find_named(root: Node, wanted: String) -> Node:
	if root.name == wanted:
		return root
	for child in root.get_children():
		var found := _find_named(child, wanted)
		if found != null:
			return found
	return null

func _find_vbox(root: Node) -> VBoxContainer:
	if root is VBoxContainer:
		return root as VBoxContainer
	for child in root.get_children():
		var found := _find_vbox(child)
		if found != null:
			return found
	return null
