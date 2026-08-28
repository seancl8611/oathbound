extends CanvasLayer

## Approved read-only Pause / Build Overview from docs/ui_ux/PAUSE_OVERVIEW.md.
## This surface reads the current authorities directly and never mutates Technique,
## Relic, Prosthetic, Aspect, or run ownership.

signal closed

const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

var _previous_paused := false
var _detail: RichTextLabel


func _ready() -> void:
	layer = 240
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_previous_paused = get_tree().paused
	get_tree().paused = true
	_build_ui()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	var root := Control.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(root)

	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0.015, 0.012, 0.018, 0.92)
	root.add_child(dim)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.04
	panel.anchor_top = 0.04
	panel.anchor_right = 0.96
	panel.anchor_bottom = 0.96
	root.add_child(panel)

	var margin := MarginContainer.new()
	for key: String in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(key, 12)
	panel.add_child(margin)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 7)
	margin.add_child(column)

	var title_row := HBoxContainer.new()
	column.add_child(title_row)
	var title := Label.new()
	title.text = "PAUSE / BUILD OVERVIEW"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 20)
	title_row.add_child(title)
	var resume := Button.new()
	resume.text = "Resume"
	resume.pressed.connect(_close)
	title_row.add_child(resume)

	var split := HSplitContainer.new()
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(split)

	var summary_scroll := ScrollContainer.new()
	summary_scroll.custom_minimum_size = Vector2(300, 0)
	summary_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	split.add_child(summary_scroll)
	var summary := RichTextLabel.new()
	summary.bbcode_enabled = true
	summary.fit_content = true
	summary.custom_minimum_size = Vector2(280, 0)
	summary.text = _build_summary_text()
	summary_scroll.add_child(summary)

	_detail = RichTextLabel.new()
	_detail.bbcode_enabled = true
	_detail.fit_content = false
	_detail.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_detail.text = _build_technique_text()
	split.add_child(_detail)

	var footer := Label.new()
	footer.text = "Read-only. Techniques remain additive run knowledge; this screen cannot respec the build. Safe run resume is saved at chamber boundaries."
	footer.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	footer.modulate = Color(0.72, 0.70, 0.76)
	column.add_child(footer)


func _build_summary_text() -> String:
	var text := "[font_size=18]Current Run[/font_size]\n"
	var aspect := "Base Katana"
	var tier := 0
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("has_active_aspect") and bool(AspectRuntime.has_active_aspect()):
		aspect = str(AspectRuntime.get("selected_aspect")).capitalize()
		tier = int(AspectRuntime.get("tier"))
	text += "Aspect: %s" % aspect
	if aspect != "Base Katana":
		text += "  •  Tier %d" % tier
	text += "\n"

	if typeof(CorruptionRuntime) == TYPE_OBJECT and CorruptionRuntime.has_method("is_awakened") and bool(CorruptionRuntime.is_awakened()):
		var corruption := int(CorruptionRuntime.get_corruption()) if CorruptionRuntime.has_method("get_corruption") else 0
		var corruption_state := str(CorruptionRuntime.get_corruption_state()) if CorruptionRuntime.has_method("get_corruption_state") else "stable"
		text += "Corruption: %d / 100  •  %s\n" % [corruption, corruption_state.capitalize()]
	else:
		text += "Corruption: Unavailable before Returning Blood\n"

	var player := get_tree().get_first_node_in_group("player")
	if player != null and is_instance_valid(player):
		var hp := int(player.get("hp")) if player.get("hp") != null else 0
		var hp_max := int(player.get("maxhp")) if player.get("maxhp") != null else 0
		var hp_start := int(player.get_meta("_oathbound_run_start_max_health", hp_max))
		text += "Health: %d / %d%s\n" % [hp, hp_max, _temporary_capacity_suffix(hp_max, hp_start)]

		var executor_value: Variant = player.get("prosthetic_executor")
		if executor_value is Node and is_instance_valid(executor_value):
			var executor := executor_value as Node
			var spirit := int(executor.call("get_spirit")) if executor.has_method("get_spirit") else int(executor.get("current_spirit"))
			var spirit_max := int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else int(executor.get("max_spirit"))
			var spirit_start := int(executor.get_meta("_oathbound_run_start_max_spirit", spirit_max))
			text += "Spirit: %d / %d%s\n" % [spirit, spirit_max, _temporary_capacity_suffix(spirit_max, spirit_start)]

	text += "\n[font_size=17]Run Resources[/font_size]\n"
	if typeof(RunData) == TYPE_OBJECT:
		text += "Gold: %d\n" % int(RunData.gold)
		text += "Technique Rerolls: %d\n" % int(RunData.technique_rerolls)
		text += "Banked Mist: %d\n" % int(RunData.mist)
		text += "Banked Scrolls: %d\n" % int(RunData.scrolls)

	text += "\n[font_size=17]Equipment[/font_size]\n"
	text += "Prosthetic: %s\n" % _prosthetic_name()
	text += "Relic: %s\n" % _relic_summary()

	text += "\n[font_size=17]Controls[/font_size]\n"
	for action: String in ["attack", "parry", "dash", "prosthetic", "interact"]:
		text += "%s: %s\n" % [action.replace("_", " ").capitalize(), _binding_label(action)]
	if typeof(SettingsManager) == TYPE_OBJECT and SettingsManager.has_method("get_block_mode"):
		text += "Block Input: %s\n" % str(SettingsManager.get_block_mode()).capitalize()
	return text


func _build_technique_text() -> String:
	var grouped: Dictionary = {
		"Basic Attack": [],
		"Held Attack": [],
		"Dash": [],
		"Parry / Counter": [],
		"Deathblow": [],
		"Supporting / Cross-family / Legendary": [],
		"Refinements": [],
	}
	var acquired: Array = []
	if typeof(UpgradeService) == TYPE_OBJECT and UpgradeService.has_method("get_acquired_technique_data"):
		acquired = UpgradeService.get_acquired_technique_data()

	for value: Variant in acquired:
		if not (value is Dictionary):
			continue
		var data: Dictionary = value as Dictionary
		var name := str(data.get("displayname", data.get("name", data.get("id", "Technique"))))
		var kind := str(data.get("kind", ""))
		if kind == "refinement":
			(grouped["Refinements"] as Array).append(name)
			continue
		if kind in ["supporting", "support", "cross", "legendary"]:
			(grouped["Supporting / Cross-family / Legendary"] as Array).append(name)
			continue
		var action := str(data.get("action", "")).to_lower()
		var group := _action_group(action)
		(grouped[group] as Array).append(name)

	var text := "[font_size=18]Owned Techniques[/font_size]\n[color=gray]Grouped by trigger, not exclusive slots.[/color]\n\n"
	var any_owned := false
	for group_name: String in grouped.keys():
		var items: Array = grouped[group_name]
		if items.is_empty():
			continue
		any_owned = true
		text += "[b]%s[/b]\n" % group_name
		for item: Variant in items:
			text += "  • %s\n" % str(item)
		text += "\n"
	if not any_owned:
		text += "No Techniques acquired yet.\n"
	return text


func _action_group(action: String) -> String:
	match action:
		"basic", "basic_attack", "attack": return "Basic Attack"
		"held", "held_attack", "hold", "thrust": return "Held Attack"
		"dash", "dash_attack": return "Dash"
		"parry", "counter", "parry_counter": return "Parry / Counter"
		"deathblow", "finisher": return "Deathblow"
	return "Supporting / Cross-family / Legendary"


func _temporary_capacity_suffix(current_max: int, run_start_max: int) -> String:
	var bonus := maxi(0, current_max - run_start_max)
	return "  (+%d temporary)" % bonus if bonus > 0 else ""


func _prosthetic_name() -> String:
	if typeof(ProstheticManager) != TYPE_OBJECT:
		return "None"
	var id := str(ProstheticManager.get("equipped_prosthetic_id"))
	if id.is_empty():
		return "None"
	if ProstheticManager.has_method("get_prosthetic"):
		var data: Variant = ProstheticManager.get_prosthetic(id)
		if data != null and data.get("display_name") != null:
			return str(data.get("display_name"))
	return id.replace("_", " ").capitalize()


func _relic_summary() -> String:
	if typeof(RelicRuntime) != TYPE_OBJECT:
		return "None"
	var id := str(RelicRuntime.get("equipped_relic_id"))
	if id.is_empty():
		return "None"
	var entry: Dictionary = RELIC_CATALOG.DATA.get(id, {})
	var name := str(entry.get("name", id.replace("_", " ").capitalize()))
	var rank := int(RelicRuntime.get_mastery_rank(id)) if RelicRuntime.has_method("get_mastery_rank") else 0
	var rank_label := "Base" if rank <= 0 else "Mastery %s" % ("I" if rank == 1 else "II")
	var effect := str(entry.get("approved", ""))
	return "%s — %s\n  %s" % [name, rank_label, effect]


func _binding_label(action: String) -> String:
	if typeof(SettingsManager) != TYPE_OBJECT or not SettingsManager.has_method("get_binding_labels"):
		return "—"
	var labels: Array[String] = SettingsManager.get_binding_labels(action)
	return " / ".join(labels) if not labels.is_empty() else "Unbound"


func _close() -> void:
	get_tree().paused = _previous_paused
	closed.emit()
	queue_free()
