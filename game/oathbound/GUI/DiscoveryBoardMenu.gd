extends Control

signal menu_closed
signal codex_requested

const Catalog = preload("res://Core/Presentation/OathboundPresentationCatalog.gd")

const COMPLETION_LABELS: Dictionary = {
	"story": "Story Complete",
	"bloodwell": "Bloodwell",
	"blood_mirror": "Blood Mirror",
	"prosthetics": "Prosthetics",
	"prosthetic_upgrades": "Prosthetic Upgrades",
	"relics": "Relics",
	"relic_mastery": "Relic Mastery",
	"techniques": "Techniques + Refinements",
	"trials": "Required Trials",
	"discovery_records": "Discovery Records",
	"heart_aspects": "Heart Victories by Aspect",
}
const COMPLETION_ORDER: Array[String] = [
	"story",
	"bloodwell",
	"blood_mirror",
	"prosthetics",
	"prosthetic_upgrades",
	"relics",
	"relic_mastery",
	"techniques",
	"trials",
	"discovery_records",
	"heart_aspects",
]

var _previous_paused := false
var _content: VBoxContainer
var _detail: RichTextLabel
var _tab := "records"


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	_previous_paused = get_tree().paused
	get_tree().paused = true
	NarrativeRuntime.unlock_lore_for_campaign_state()
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("recalculate_completion"):
		RecordsRuntime.recalculate_completion()
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
	title.text = tr("DISCOVERY BOARD")
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.add_theme_font_size_override("font_size", 18)
	title_row.add_child(title)
	var close := Button.new()
	close.text = tr("Close")
	close.pressed.connect(_close)
	title_row.add_child(close)

	var tabs := HBoxContainer.new()
	root.add_child(tabs)
	_add_tab_button(tabs, "Records", "records")
	_add_tab_button(tabs, "Help", "help")
	_add_tab_button(tabs, "Achievements", "achievements")
	var codex := Button.new()
	codex.text = tr("Bestiary / Equipment")
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
	button.text = tr(label)
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
	if typeof(RecordsRuntime) == TYPE_OBJECT and RecordsRuntime.has_method("recalculate_completion"):
		RecordsRuntime.recalculate_completion()

	var run_records := Button.new()
	run_records.text = tr("Run Records")
	run_records.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	run_records.pressed.connect(_show_run_records)
	_content.add_child(run_records)

	var completion := Button.new()
	var percent := int(RecordsRuntime.get_completion_percent()) if typeof(RecordsRuntime) == TYPE_OBJECT else 0
	completion.text = "%s — %d%%" % [tr("100% Completion"), percent]
	completion.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	completion.pressed.connect(_show_completion)
	_content.add_child(completion)

	var divider := HSeparator.new()
	_content.add_child(divider)
	var discovery_heading := Label.new()
	discovery_heading.text = tr("Discovery Records")
	discovery_heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	discovery_heading.add_theme_font_size_override("font_size", 13)
	_content.add_child(discovery_heading)

	for record in Catalog.lore_records():
		var record_id := str(record.get("id", ""))
		var unlocked := NarrativeRuntime.is_lore_unlocked(record_id)
		var button := Button.new()
		button.text = str(record.get("title", "")) if unlocked else "???"
		button.disabled = not unlocked
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		if unlocked:
			button.pressed.connect(_show_record.bind(record_id))
		_content.add_child(button)

	_show_run_records()


func _show_run_records() -> void:
	if typeof(RecordsRuntime) != TYPE_OBJECT:
		_detail.text = tr("Run records are unavailable.")
		return
	var records: Dictionary = RecordsRuntime.get_records_snapshot()
	var boss_counts_value: Variant = records.get("boss_defeat_counts", {})
	var boss_counts: Dictionary = boss_counts_value if boss_counts_value is Dictionary else {}
	var first_depth := int(records.get("deepest_first_attempt", 0))
	var first_depth_text := str(first_depth) if first_depth > 0 else "—"
	var story_recorded := bool(records.get("first_heart_victory", false))

	_detail.text = "[font_size=20]%s[/font_size]\n[color=gray]%s[/color]\n\n" % [
		tr("Run Records"),
		tr("Persistent mastery records for this save slot."),
	]
	_detail.text += "%s: %d\n" % [tr("Total Attempts"), int(records.get("total_attempts", 0))]
	_detail.text += "%s: %d\n" % [tr("Standard Expedition Clears"), int(records.get("standard_expedition_clears", 0))]
	_detail.text += "%s: %d\n" % [tr("Heart Suppression Clears"), int(records.get("heart_suppression_clears", 0))]
	_detail.text += "%s: %s\n" % [tr("Fastest Standard Expedition"), _format_record_time(float(records.get("fastest_standard_seconds", 0.0)))]
	_detail.text += "%s: %s\n\n" % [tr("Fastest Heart Suppression"), _format_record_time(float(records.get("fastest_suppression_seconds", 0.0)))]
	_detail.text += "%s\n" % tr("Heart Victories")
	_detail.text += "  Wolf: %s\n" % _record_mark(bool(records.get("heart_wolf", false)))
	_detail.text += "  Wraith: %s\n" % _record_mark(bool(records.get("heart_wraith", false)))
	_detail.text += "  Ronin: %s\n\n" % _record_mark(bool(records.get("heart_ronin", false)))
	_detail.text += "%s\n" % tr("Regional Boss Defeats")
	_detail.text += "  Keeper: %d\n" % _boss_count(boss_counts, 1)
	_detail.text += "  Twin Maws: %d\n" % _boss_count(boss_counts, 2)
	_detail.text += "  Eclipse Shogun: %d\n" % _boss_count(boss_counts, 3)
	_detail.text += "%s: %d\n\n" % [tr("Miniboss Defeats"), int(records.get("miniboss_defeats", 0))]
	_detail.text += "%s: %s\n" % [tr("Deepest First-Attempt Chamber"), first_depth_text]
	_detail.text += "%s: %s\n" % [tr("First Canonical Heart Victory"), tr("Recorded") if story_recorded else tr("Not Yet")]
	_detail.text += "%s: %d%%" % [tr("Overall Completion"), int(records.get("completion_percent", 0))]


func _show_completion() -> void:
	if typeof(RecordsRuntime) != TYPE_OBJECT:
		_detail.text = tr("Completion records are unavailable.")
		return
	var percent := int(RecordsRuntime.recalculate_completion())
	var breakdown: Dictionary = RecordsRuntime.get_completion_breakdown()
	_detail.text = "[font_size=20]%s — %d%%[/font_size]\n[color=gray]%s[/color]\n\n" % [
		tr("100% Completion"),
		percent,
		tr("Launch completion uses authored progression, collection, trial, Discovery, and Heart-mastery goals."),
	]
	for key: String in COMPLETION_ORDER:
		var value: Variant = breakdown.get(key, {})
		if not (value is Dictionary):
			continue
		var entry: Dictionary = value as Dictionary
		var owned := maxi(0, int(entry.get("owned", 0)))
		var total := maxi(0, int(entry.get("total", 0)))
		var complete := total == 0 or owned >= total
		var label := tr(str(COMPLETION_LABELS.get(key, key.capitalize())))
		_detail.text += "%s %s: %d / %d\n" % [_record_mark(complete), label, owned, total]

	_detail.text += "\n[color=gray]%s[/color]" % tr("Currency hoarding, extreme speedrun records, no-hit clears, and repeated-clear grind are not required for 100%.")


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
	_detail.text = "[font_size=18]%s[/font_size]\n%d / %d %s" % [tr("Achievements"), unlocked, total, tr("unlocked")]
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
		var status := tr("UNLOCKED") if AchievementRuntime.is_unlocked(achievement_id) else tr("LOCKED")
		_detail.text = "[font_size=20]%s[/font_size]\n[color=gray]%s[/color]\n\n%s" % [str(achievement.get("name", "")), status, str(achievement.get("description", ""))]
		return


func _format_record_time(seconds: float) -> String:
	if seconds <= 0.0:
		return "—"
	var whole_seconds := maxi(0, int(round(seconds)))
	var hours := whole_seconds / 3600
	var minutes := (whole_seconds % 3600) / 60
	var remaining_seconds := whole_seconds % 60
	if hours > 0:
		return "%d:%02d:%02d" % [hours, minutes, remaining_seconds]
	return "%d:%02d" % [minutes, remaining_seconds]


func _boss_count(counts: Dictionary, area_id: int) -> int:
	return maxi(0, int(counts.get(area_id, counts.get(str(area_id), 0))))


func _record_mark(complete: bool) -> String:
	return "✓" if complete else "□"


func _request_codex() -> void:
	get_tree().paused = _previous_paused
	codex_requested.emit()
	queue_free()


func _close() -> void:
	get_tree().paused = _previous_paused
	menu_closed.emit()
	queue_free()
