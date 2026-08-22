extends "res://Core/Prosthetics/OathboundPlaytestLab.gd"

## Adds focused Relic controls on top of the current Technique/Aspect/Prosthetic lab.

const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

var _relic_dropdown: OptionButton
var _relic_status: Label


func _build_build_tab(tabs: TabContainer) -> void:
	super._build_build_tab(tabs)
	_build_relic_tab(tabs)


func _build_relic_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Relics")

	var title := Label.new()
	title.text = "Current 10-Relic launch roster"
	vbox.add_child(title)

	_relic_dropdown = OptionButton.new()
	for relic_id: String in RELIC_CATALOG.IDS:
		_relic_dropdown.add_item(RELIC_CATALOG.get_name(relic_id))
		_relic_dropdown.set_item_metadata(_relic_dropdown.item_count - 1, relic_id)
	_relic_dropdown.item_selected.connect(func(_index: int) -> void: _refresh_relic_status())
	vbox.add_child(_relic_dropdown)

	var row_a := HBoxContainer.new()
	vbox.add_child(row_a)

	var unlock_all := Button.new()
	unlock_all.text = "Unlock All"
	unlock_all.pressed.connect(_relic_unlock_all)
	row_a.add_child(unlock_all)

	var equip := Button.new()
	equip.text = "Equip Selected"
	equip.pressed.connect(_relic_equip_selected)
	row_a.add_child(equip)

	var unequip := Button.new()
	unequip.text = "Unequip"
	unequip.pressed.connect(_relic_unequip)
	row_a.add_child(unequip)

	var row_b := HBoxContainer.new()
	vbox.add_child(row_b)
	for rank: int in range(3):
		var button := Button.new()
		button.text = "Set %s" % _mastery_label(rank)
		button.pressed.connect(_relic_set_mastery.bind(rank))
		row_b.add_child(button)

	_relic_status = Label.new()
	_relic_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_relic_status.modulate = Color(0.72, 0.70, 0.80)
	vbox.add_child(_relic_status)

	var note := Label.new()
	note.text = "Starting Gold / max Health / max Spirit apply on a fresh run. Event Relics can be switched here for focused testing. Mastery values and thresholds are first-playtest tuning."
	note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	note.modulate = Color(0.62, 0.64, 0.70)
	vbox.add_child(note)
	_refresh_relic_status()


func _selected_relic_id() -> String:
	if _relic_dropdown == null or _relic_dropdown.item_count <= 0:
		return ""
	return str(_relic_dropdown.get_item_metadata(_relic_dropdown.selected))


func _relic_unlock_all() -> void:
	var runtime := _relic_runtime()
	if runtime != null:
		runtime.call("unlock_all_for_playtest")
	_refresh_relic_status()


func _relic_equip_selected() -> void:
	var runtime := _relic_runtime()
	var relic_id: String = _selected_relic_id()
	if runtime != null and not relic_id.is_empty():
		runtime.call("equip_for_playtest", relic_id)
		print("[PlaytestLab] Equipped Relic: %s" % relic_id)
	_refresh_relic_status()


func _relic_unequip() -> void:
	var runtime := _relic_runtime()
	if runtime != null:
		runtime.call("equip_relic", "", "forge")
	_refresh_relic_status()


func _relic_set_mastery(rank: int) -> void:
	var runtime := _relic_runtime()
	var relic_id: String = _selected_relic_id()
	if runtime != null and not relic_id.is_empty():
		if not bool(runtime.call("is_unlocked", relic_id)):
			runtime.call("discover_relic", relic_id, false)
		runtime.call("set_mastery_rank_for_playtest", relic_id, rank)
	_refresh_relic_status()


func _refresh_relic_status() -> void:
	if _relic_status == null:
		return
	var runtime := _relic_runtime()
	if runtime == null:
		_relic_status.text = "Relic runtime unavailable."
		return
	var relic_id: String = _selected_relic_id()
	var data: Dictionary = RELIC_CATALOG.get_data(relic_id)
	var rank: int = int(runtime.call("get_mastery_rank", relic_id)) if not relic_id.is_empty() else 0
	var kills: int = int(runtime.call("get_mastery_kills", relic_id)) if not relic_id.is_empty() else 0
	_relic_status.text = "Equipped: %s | Selected: %s | %s (%d kills)\n%s\nCurrent first-playtest value: %s" % [
		str(runtime.get("equipped_relic_id")) if not str(runtime.get("equipped_relic_id")).is_empty() else "none",
		str(data.get("name", relic_id)),
		_mastery_label(rank),
		kills,
		str(data.get("approved", "")),
		str(runtime.call("get_effective_value", relic_id)) if not relic_id.is_empty() else "0",
	]


func _mastery_label(rank: int) -> String:
	match rank:
		1: return "Mastery I"
		2: return "Mastery II"
		_: return "Base"


func _relic_runtime() -> Node:
	return get_node_or_null("/root/RelicRuntime")
