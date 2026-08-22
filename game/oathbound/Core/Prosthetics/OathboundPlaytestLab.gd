extends "res://Utility/PlaytestLab.gd"

## Current Playtest Lab overlay for the Prosthetic package.
## Adds a dedicated tab without modifying the imported test harness.

const CURRENT_PROSTHETICS: Array[Dictionary] = [
	{"id": "beast_whistle", "name": "Beast-Bane Whistle"},
	{"id": "thunder_rod", "name": "Thunder Rod"},
	{"id": "smoke_gourd", "name": "Smoke Gourd"},
	{"id": "fang_harpoon", "name": "Fang Harpoon"},
	{"id": "mirror_umbrella", "name": "Mirror Umbrella"},
	{"id": "flame_vent", "name": "Flame Vent"},
	{"id": "mist_raven", "name": "Mist Raven"},
	{"id": "bloodletting_gourd", "name": "Bloodletting Gourd"},
]

var _prosthetic_dropdown: OptionButton
var _prosthetic_status: Label


func _build_build_tab(tabs: TabContainer) -> void:
	super._build_build_tab(tabs)
	_build_prosthetic_tab(tabs)


func _build_prosthetic_tab(tabs: TabContainer) -> void:
	var vbox: VBoxContainer = _make_tab(tabs, "Prosthetics")

	var title := Label.new()
	title.text = "Current eight-tool first-playtest roster"
	vbox.add_child(title)

	_prosthetic_dropdown = OptionButton.new()
	for entry: Dictionary in CURRENT_PROSTHETICS:
		_prosthetic_dropdown.add_item(str(entry.get("name", "")))
		_prosthetic_dropdown.set_item_metadata(_prosthetic_dropdown.item_count - 1, str(entry.get("id", "")))
	vbox.add_child(_prosthetic_dropdown)

	var equip_row := HBoxContainer.new()
	vbox.add_child(equip_row)

	var unlock_all := Button.new()
	unlock_all.text = "Unlock All"
	unlock_all.pressed.connect(_prosthetic_unlock_all)
	equip_row.add_child(unlock_all)

	var equip := Button.new()
	equip.text = "Equip Selected"
	equip.pressed.connect(_prosthetic_equip_selected)
	equip_row.add_child(equip)

	var refill := Button.new()
	refill.text = "Refill Spirit"
	refill.pressed.connect(_prosthetic_refill_spirit)
	equip_row.add_child(refill)

	var upgrade_row := HBoxContainer.new()
	vbox.add_child(upgrade_row)

	var grant_upgrades := Button.new()
	grant_upgrades.text = "Grant Selected Upgrades"
	grant_upgrades.pressed.connect(_prosthetic_grant_upgrades)
	upgrade_row.add_child(grant_upgrades)

	var clear_upgrades := Button.new()
	clear_upgrades.text = "Clear Selected Upgrades"
	clear_upgrades.pressed.connect(_prosthetic_clear_upgrades)
	upgrade_row.add_child(clear_upgrades)

	_prosthetic_status = Label.new()
	_prosthetic_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_prosthetic_status.modulate = Color(0.72, 0.74, 0.8)
	vbox.add_child(_prosthetic_status)
	_refresh_prosthetic_status()


func _selected_prosthetic_id() -> String:
	if _prosthetic_dropdown == null or _prosthetic_dropdown.item_count <= 0:
		return ""
	return str(_prosthetic_dropdown.get_item_metadata(_prosthetic_dropdown.selected))


func _prosthetic_unlock_all() -> void:
	if ProstheticManager.has_method("unlock_all_for_playtest"):
		ProstheticManager.call("unlock_all_for_playtest")
	else:
		for entry: Dictionary in CURRENT_PROSTHETICS:
			ProstheticManager.unlock_prosthetic(str(entry.get("id", "")))
	print("[PlaytestLab] Unlocked all current Prosthetics for this test session.")
	_refresh_prosthetic_status()


func _prosthetic_equip_selected() -> void:
	var prosthetic_id: String = _selected_prosthetic_id()
	if prosthetic_id.is_empty():
		return
	if not ProstheticManager.unlocked_prosthetics.has(prosthetic_id):
		ProstheticManager.unlock_prosthetic(prosthetic_id)
	if ProstheticManager.equip_prosthetic(prosthetic_id):
		print("[PlaytestLab] Equipped Prosthetic: %s" % prosthetic_id)
	_refresh_prosthetic_status()


func _prosthetic_refill_spirit() -> void:
	var player: Node = _get_player()
	if player == null:
		return
	var executor: Variant = player.get("prosthetic_executor")
	if executor is Node and is_instance_valid(executor):
		var executor_node := executor as Node
		if executor_node.has_method("set_spirit"):
			executor_node.call("set_spirit", 100)
		elif "current_spirit" in executor_node:
			executor_node.set("current_spirit", 100)
			if executor_node.has_signal("spirit_changed"):
				executor_node.emit_signal("spirit_changed", 100, 100)
	print("[PlaytestLab] Refilled current Spirit to 100.")
	_refresh_prosthetic_status()


func _prosthetic_grant_upgrades() -> void:
	var prosthetic_id: String = _selected_prosthetic_id()
	if prosthetic_id.is_empty():
		return
	if ProstheticManager.has_method("grant_all_upgrades_for_playtest"):
		ProstheticManager.call("grant_all_upgrades_for_playtest", prosthetic_id)
	print("[PlaytestLab] Granted all current upgrades for %s." % prosthetic_id)
	_refresh_prosthetic_status()


func _prosthetic_clear_upgrades() -> void:
	var prosthetic_id: String = _selected_prosthetic_id()
	if prosthetic_id.is_empty():
		return
	if ProstheticManager.has_method("clear_upgrades_for_playtest"):
		ProstheticManager.call("clear_upgrades_for_playtest", prosthetic_id)
	print("[PlaytestLab] Cleared current upgrades for %s." % prosthetic_id)
	_refresh_prosthetic_status()


func _refresh_prosthetic_status() -> void:
	if _prosthetic_status == null:
		return
	var equipped: String = str(ProstheticManager.equipped_prosthetic_id)
	var selected: String = _selected_prosthetic_id()
	var upgrade_count: int = 0
	if not selected.is_empty():
		var purchased_value: Variant = ProstheticManager.purchased_upgrades.get(selected, {})
		if purchased_value is Dictionary:
			upgrade_count = (purchased_value as Dictionary).size()
	var spirit_text: String = "n/a"
	var player: Node = _get_player()
	if player != null:
		var executor: Variant = player.get("prosthetic_executor")
		if executor is Node and is_instance_valid(executor) and (executor as Node).has_method("get_spirit"):
			spirit_text = "%d / %d" % [
				int((executor as Node).call("get_spirit")),
				int((executor as Node).call("get_max_spirit")),
			]
	_prosthetic_status.text = "Equipped: %s | Selected upgrades: %d | Spirit: %s\nF uses the equipped Prosthetic. Close the lab before testing combat." % [equipped, upgrade_count, spirit_text]
