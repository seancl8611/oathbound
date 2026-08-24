extends CanvasLayer

## Run-result presentation for first return, failed runs, Binding returns, first Heart
## completion, Standard Expeditions, and repeat Heart Suppression clears.

const TECHNIQUE_CATALOG = preload("res://Core/Techniques/TechniqueCatalog.gd")

signal dismissed


func _ready() -> void:
	layer = 240
	process_mode = Node.PROCESS_MODE_ALWAYS


func present(result: Dictionary) -> void:
	if result.is_empty():
		queue_free()
		return
	get_tree().paused = true

	var background := ColorRect.new()
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.color = Color(0.02, 0.018, 0.022, 0.96)
	add_child(background)

	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)

	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(540, 320)
	center.add_child(panel)

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 22)
	margin.add_theme_constant_override("margin_right", 22)
	margin.add_theme_constant_override("margin_top", 18)
	margin.add_theme_constant_override("margin_bottom", 18)
	panel.add_child(margin)

	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(500, 280)
	margin.add_child(scroll)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(480, 0)
	column.add_theme_constant_override("separation", 8)
	scroll.add_child(column)

	var title := Label.new()
	title.text = _result_title(result)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	column.add_child(title)

	var subtitle := Label.new()
	subtitle.text = _result_subtitle(result)
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.modulate = Color(0.8, 0.79, 0.82)
	column.add_child(subtitle)

	_add_separator(column)
	_add_line(column, "Time", _format_time(float(result.get("clear_time_seconds", 0.0))))
	_add_line(column, "Deepest progress", "Region %d • Chamber %d" % [int(result.get("area", 1)), int(result.get("deepest_chamber_reached", result.get("depth", 0)))])

	var kind := str(result.get("completion_kind", ""))
	if kind.begins_with("binding_") or kind == "story_complete" or kind == "heart_suppression":
		_add_line(column, "Heart Bindings", "%d destroyed • %d remaining" % [int(result.get("bindings_destroyed", 0)), int(result.get("bindings_remaining", 0))])

	_add_separator(column)
	_add_section(column, "Permanent progress retained")
	_add_line(column, "Mist", "+%d" % int(result.get("mist_gained", 0)))
	_add_line(column, "Scrolls", "+%d" % int(result.get("scrolls_gained", 0)))
	var material_text := _material_delta_text(result.get("boss_materials_gained", {}))
	if not material_text.is_empty():
		_add_line(column, "Boss materials", material_text)

	_add_separator(column)
	_add_section(column, "Final build")
	_add_line(column, "Aspect", _aspect_label(str(result.get("aspect", "base_katana"))))
	_add_line(column, "Highest Tier", str(int(result.get("highest_tier", 0))))
	_add_line(column, "Prosthetic", _fallback_label(str(result.get("equipped_prosthetic", ""))))
	_add_line(column, "Relic", _fallback_label(str(result.get("equipped_relic", ""))))
	var technique_names := _technique_names(result.get("techniques", []))
	_add_line(column, "Techniques", ", ".join(technique_names) if not technique_names.is_empty() else "None")

	if kind == "standard_expedition" and typeof(RecordsRuntime) == TYPE_OBJECT:
		_add_line(column, "Best Standard", _format_time(RecordsRuntime.get_fastest_standard_seconds()))
	elif kind == "heart_suppression" and typeof(RecordsRuntime) == TYPE_OBJECT:
		_add_line(column, "Best Suppression", _format_time(RecordsRuntime.get_fastest_suppression_seconds()))

	_add_separator(column)
	var lost := Label.new()
	lost.text = "Run-only state lost: %s" % ", ".join(_string_array(result.get("run_only_lost", [])))
	lost.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	lost.modulate = Color(0.72, 0.68, 0.72)
	column.add_child(lost)

	if kind == "story_complete":
		_add_story_complete_sequence(column)

	if typeof(RecordsRuntime) == TYPE_OBJECT:
		var completion := Label.new()
		completion.text = "Overall completion: %d%%" % RecordsRuntime.get_completion_percent()
		completion.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		column.add_child(completion)

	var close := Button.new()
	close.text = "Return to The Strand"
	close.custom_minimum_size = Vector2(0, 38)
	close.pressed.connect(_dismiss)
	column.add_child(close)
	close.grab_focus()


func _result_title(result: Dictionary) -> String:
	var kind := str(result.get("completion_kind", ""))
	if kind == "first_return":
		return "THE BLOOD RETURNS"
	if kind == "failed":
		return "RUN ENDED"
	if kind.begins_with("binding_"):
		return "HEART BINDING DESTROYED"
	if kind == "story_complete":
		return "STORY COMPLETE"
	if kind == "heart_suppression":
		return "HEART SUPPRESSED"
	if kind == "standard_expedition":
		return "EXPEDITION COMPLETE"
	if bool(result.get("successful", false)):
		return "RUN COMPLETE"
	return "RETURNED TO THE STRAND"


func _result_subtitle(result: Dictionary) -> String:
	var kind := str(result.get("completion_kind", ""))
	if kind == "first_return":
		return "Akio died on the island. Returning Blood rebuilt him at The Strand. Permanent gains remain; the run build is gone."
	if kind == "failed":
		return "The attempt ended, but permanent resources and discoveries were banked when earned."
	if kind.begins_with("binding_"):
		return "The Shogun fell and another restraint on the Heart was destroyed."
	if kind == "story_complete":
		return "The Heart's curse can no longer create or spread new Beast Blood. The completed save now enters canonical postgame."
	if kind == "heart_suppression":
		return "Dangerous Heart regrowth was suppressed. The contained remnant survives without a path to new hosts."
	if kind == "standard_expedition":
		return "The expedition ended at the Eclipse Shogun as selected before departure."
	return "The run has returned to The Strand."


func _add_story_complete_sequence(column: VBoxContainer) -> void:
	if typeof(NarrativeRuntime) != TYPE_OBJECT or not NarrativeRuntime.has_method("get_ending_sequence"):
		return
	_add_separator(column)
	_add_section(column, "Ending")
	for beat_value: Variant in NarrativeRuntime.get_ending_sequence():
		if not (beat_value is Dictionary):
			continue
		var text := str((beat_value as Dictionary).get("text", ""))
		if text.is_empty():
			continue
		var line := Label.new()
		line.text = text
		line.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		column.add_child(line)
	var postgame := Label.new()
	postgame.text = "Postgame unlocked: choose Standard Expedition or Heart Suppression at The Well before departure."
	postgame.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(postgame)


func _add_line(column: VBoxContainer, label_text: String, value_text: String) -> void:
	var row := HBoxContainer.new()
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(150, 0)
	row.add_child(label)
	var value := Label.new()
	value.text = value_text
	value.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	value.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	row.add_child(value)
	column.add_child(row)


func _add_section(column: VBoxContainer, text_value: String) -> void:
	var label := Label.new()
	label.text = text_value
	label.add_theme_font_size_override("font_size", 17)
	column.add_child(label)


func _add_separator(column: VBoxContainer) -> void:
	var separator := HSeparator.new()
	column.add_child(separator)


func _technique_names(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if not (value is Array):
		return result
	for id_value: Variant in value:
		var technique_id := str(id_value)
		var data: Dictionary = {}
		if TECHNIQUE_CATALOG.TECHNIQUES.has(technique_id):
			data = (TECHNIQUE_CATALOG.TECHNIQUES[technique_id] as Dictionary)
		elif TECHNIQUE_CATALOG.REFINEMENTS.has(technique_id):
			data = (TECHNIQUE_CATALOG.REFINEMENTS[technique_id] as Dictionary)
		result.append(str(data.get("displayname", data.get("name", technique_id))).replace("_", " "))
	return result


func _material_delta_text(value: Variant) -> String:
	if not (value is Dictionary):
		return ""
	var parts: Array[String] = []
	for key_value: Variant in (value as Dictionary).keys():
		var amount := int((value as Dictionary).get(key_value, 0))
		if amount > 0:
			parts.append("%s +%d" % [str(key_value).replace("_", " ").capitalize(), amount])
	return ", ".join(parts)


func _aspect_label(value: String) -> String:
	if value.is_empty() or value == "base_katana":
		return "Base Katana"
	return value.capitalize()


func _fallback_label(value: String) -> String:
	return "None" if value.is_empty() else value.replace("_", " ").capitalize()


func _format_time(seconds: float) -> String:
	if seconds <= 0.0:
		return "—"
	var total := maxi(0, int(round(seconds)))
	return "%02d:%02d" % [total / 60, total % 60]


func _string_array(value: Variant) -> Array[String]:
	var result: Array[String] = []
	if value is Array:
		for item: Variant in value:
			result.append(str(item))
	return result


func _dismiss() -> void:
	get_tree().paused = false
	dismissed.emit()
	queue_free()
