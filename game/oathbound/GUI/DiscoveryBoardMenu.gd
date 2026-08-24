extends Control

signal menu_closed
signal codex_requested

const Catalog = preload("res://Core/Presentation/OathboundPresentationCatalog.gd")

var _previous_paused := false
var _content: VBoxContainer
var _detail: RichTextLabel
var _tab := "records"


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_previous_paused = get_tree().paused
	get_tree().paused = true
	NarrativeRuntime.unlock_lore_for_campaign_state()
	_build_ui()
	_show_records()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		_close()
		get_viewport().set_input_as_handled()


func _build_ui() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_STOP
	var dim := ColorRect.new()
	dim.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dim.color = Color(0, 0, 0, 0.72)
	add_child(dim)

	var panel := PanelContainer.new()
	panel.anchor_left = 0.05
	panel.anchor_top = 0.05
	panel.anchor_right = 0.95
	panel.anchor_bottom = 0.95
	add_child(panel)

	var margin := MarginContainer.new()
	for key in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(key, 10)
	panel.add_child(margin)

	var root := VBoxContainer.new()
	root.add_theme_constant_override("separation", 6)
	margin.add_child(root)

	var title_row := HBoxContainer.new()
	root.add_child(title_row)
	var title := Label.new()
	title.text = "DISCOVERY BOARD"
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 18)
	title_row.add_child(title)
	var close := Button.new()
	close.text = "Close"
	close.pressed.connect(_close)
	title_row.add_child(close)

	var tabs := HBoxContainer.new()
	root.add_child(tabs)
	_add_tab_button(tabs, "Records", "records")
	_add_tab_button(tabs, "Help", "help")
	_add_tab_button(tabs, "Achievements", "achievements")
	var codex := Button.new()
	codex.text = "Bestiary / Equipment"
	codex.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	codex.pressed.connect(_request_codex)
	tabs.add_child(codex)

	var split := HSplitContainer.new()
	split.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(split)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(220, 0)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	split.add_child(scroll)
	_content = VBoxContainer.new()
	_content.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_content.add_theme_constant_override("separation", 2)
	scroll.add_child(_content)
	_detail = RichTextLabel.new()
	_detail.bbcode_enabled = true
	_detail.fit_content = false
	_detail.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_detail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_detail.add_theme_font_size_override("normal_font_size", 14)
	split.add_child(_detail)


func _add_tab_button(parent: HBoxContainer, label: String, tab_id: String) -> void:
	var button := Button.new()
	button.text = label
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(_select_tab.bind(tab_id))
	parent.add_child(button)


func _select_tab(tab_id: String) -> void:
	_tab = tab_id
	match _tab:
		"records": _show_records()
		"help": _show_help()
		"achievements": _show_achievements()


func _clear() -> void:
	for child in _content.get_children():
		child.queue_free()
	_detail.text = ""


func _show_records() -> void:
	_clear()
	var records := Catalog.lore_records()
	var first_unlocked := ""
	for record in records:
		var record_id := str(record.get("id", ""))
		var unlocked := NarrativeRuntime.is_lore_unlocked(record_id)
		var button := Button.new()
		button.text = str(record.get("title", "")) if unlocked else "???"
		button.disabled = not unlocked
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if unlocked:
			button.pressed.connect(_show_record.bind(record_id))
			if first_unlocked.is_empty():
				first_unlocked = record_id
		_content.add_child(button)
	if not first_unlocked.is_empty():
		_show_record(first_unlocked)
	else:
		_detail.text = "Records unlock as the Strand verifies discoveries from the island."


func _show_record(record_id: String) -> void:
	var record := NarrativeRuntime.get_lore_record(record_id)
	if record.is_empty():
		return
	_detail.text = "[font_size=20]%s[/font_size]\n[color=gray]%s[/color]\n\n%s" % [str(record.get("title", "")), str(record.get("category", "")), str(record.get("body", ""))]


func _show_help() -> void:
	_clear()
	var topics := Catalog.help_topics()
	for topic in topics:
		var topic_id := str(topic.get("id", ""))
		var button := Button.new()
		button.text = str(topic.get("title", ""))
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_show_help_topic.bind(topic_id))
		_content.add_child(button)
	if not topics.is_empty():
		_show_help_topic(str(topics[0].get("id", "")))


func _show_help_topic(topic_id: String) -> void:
	for topic in Catalog.help_topics():
		if str(topic.get("id", "")) != topic_id:
			continue
		_detail.text = "[font_size=20]%s[/font_size]\n\n%s" % [str(topic.get("title", "")), str(topic.get("body", ""))]
		return


func _show_achievements() -> void:
	_clear()
	var unlocked := AchievementRuntime.get_unlocked_count()
	var total := Catalog.achievements().size()
	_detail.text = "[font_size=18]Achievements[/font_size]\n%d / %d unlocked" % [unlocked, total]
	for achievement in Catalog.achievements():
		var achievement_id := str(achievement.get("id", ""))
		var is_unlocked := AchievementRuntime.is_unlocked(achievement_id)
		var button := Button.new()
		button.text = ("✓ " if is_unlocked else "□ ") + str(achievement.get("name", ""))
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(_show_achievement.bind(achievement_id))
		_content.add_child(button)


func _show_achievement(achievement_id: String) -> void:
	for achievement in Catalog.achievements():
		if str(achievement.get("id", "")) != achievement_id:
			continue
		var status := "UNLOCKED" if AchievementRuntime.is_unlocked(achievement_id) else "LOCKED"
		_detail.text = "[font_size=20]%s[/font_size]\n[color=gray]%s[/color]\n\n%s" % [str(achievement.get("name", "")), status, str(achievement.get("description", ""))]
		return


func _request_codex() -> void:
	get_tree().paused = _previous_paused
	codex_requested.emit()
	queue_free()


func _close() -> void:
	get_tree().paused = _previous_paused
	menu_closed.emit()
	queue_free()
