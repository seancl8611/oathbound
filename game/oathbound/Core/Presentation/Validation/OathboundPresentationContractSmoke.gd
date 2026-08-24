extends Node

const Catalog = preload("res://Core/Presentation/OathboundPresentationCatalog.gd")

var failures: Array[String] = []


func _ready() -> void:
	_check_shogun_states()
	_check_strand_content()
	_check_lore()
	_check_achievements()
	_check_help_and_ending()
	_check_unique_ids()
	if failures.is_empty():
		print("[OathboundPresentationContractSmoke] PASS - Shogun Strand lore achievements help ending")
		get_tree().quit(0)
		return
	for failure in failures:
		push_error("[OathboundPresentationContractSmoke] " + failure)
	get_tree().quit(1)


func _check_shogun_states() -> void:
	var states := Catalog.shogun_states()
	_expect(states.size() == 8, "expected 7 awakened Shogun states plus 1 pre-awakening fallback")
	var awakened := 0
	var fallback := 0
	for state in states:
		if bool(state.get("pre_awakened", false)):
			fallback += 1
		else:
			awakened += 1
		_expect(str(state.get("speaker", "")) == "Eclipse Shogun", "Shogun state has wrong speaker")
		_expect(not (state.get("lines", []) as Array).is_empty(), "Shogun state has no lines")
	_expect(awakened == 7, "awakened Shogun state count must be 7")
	_expect(fallback == 1, "pre-awakening Shogun fallback count must be 1")


func _check_strand_content() -> void:
	var conversations := Catalog.strand_major_conversations()
	_expect(conversations.size() >= 30 and conversations.size() <= 36, "major Strand conversation count must be 30-36")
	for npc in Catalog.STRAND_NPCS:
		var major_count := 0
		var pre_heart_count := 0
		var reactive_count := 0
		for conversation in conversations:
			if str(conversation.get("npc", "")) == npc:
				major_count += 1
				if bool(conversation.get("pre_heart", false)):
					pre_heart_count += 1
		for reaction in Catalog.reactive_line_sets():
			if str(reaction.get("npc", "")) == npc:
				reactive_count += 1
		_expect(major_count >= 5, "%s needs at least 5 major conversations" % npc)
		_expect(pre_heart_count == 1, "%s needs exactly 1 final pre-Heart conversation" % npc)
		_expect(reactive_count >= 4 and reactive_count <= 6, "%s reactive line-set count must be 4-6" % npc)
	for conversation in conversations:
		_expect(str(conversation.get("npc", "")) != "akio", "Akio must never own dialogue")
		_expect(not _contains_forbidden_placeholder(conversation), "placeholder text in Strand conversation %s" % str(conversation.get("id", "")))


func _check_lore() -> void:
	var records := Catalog.lore_records()
	_expect(records.size() >= 20 and records.size() <= 25, "Lore / Records count must be 20-25")
	for record in records:
		_expect(not str(record.get("title", "")).is_empty(), "Lore record missing title")
		_expect(str(record.get("body", "")).length() >= 80, "Lore record too thin: %s" % str(record.get("id", "")))
		_expect(not _contains_forbidden_placeholder(record), "placeholder text in lore record %s" % str(record.get("id", "")))


func _check_achievements() -> void:
	var achievements := Catalog.achievements()
	_expect(achievements.size() == 30, "launch achievement catalog must contain exactly 30 achievements")
	for achievement in achievements:
		_expect(not str(achievement.get("name", "")).is_empty(), "achievement missing name")
		_expect(not str(achievement.get("description", "")).is_empty(), "achievement missing description")
		_expect(not str(achievement.get("trigger", "")).is_empty(), "achievement missing trigger contract")


func _check_help_and_ending() -> void:
	_expect(Catalog.help_topics().size() >= 10, "help catalog needs at least 10 player-facing topics")
	var ending_text := ""
	for beat in Catalog.ending_sequence():
		_expect(str(beat.get("speaker", "")) != "Akio", "Akio must not speak in ending")
		ending_text += str(beat.get("text", "")) + " "
	_expect(ending_text.contains(Catalog.ENDING_CORE_MESSAGE), "ending must directly communicate the locked core message")
	for beat in Catalog.postgame_explanation():
		_expect(str(beat.get("speaker", "")) in ["Keeper", "Scribe"], "postgame explanation should be owned by Keeper/Scribe")
	_expect(not ending_text.to_lower().contains("beast blood vanished"), "ending must preserve existing Beast Blood")


func _check_unique_ids() -> void:
	var seen := {}
	var groups := [
		Catalog.shogun_states(),
		Catalog.strand_major_conversations(),
		Catalog.reactive_line_sets(),
		Catalog.lore_records(),
		Catalog.achievements(),
		Catalog.help_topics(),
		Catalog.ending_sequence(),
		Catalog.postgame_explanation(),
	]
	for group in groups:
		for entry in group:
			var entry_id := str(entry.get("id", ""))
			_expect(not entry_id.is_empty(), "presentation entry missing stable id")
			_expect(not seen.has(entry_id), "duplicate presentation id: %s" % entry_id)
			seen[entry_id] = true


func _contains_forbidden_placeholder(value: Variant) -> bool:
	var text := str(value).to_lower()
	return text.contains("todo") or text.contains("tbd") or text.contains("fill later") or text.contains("???")


func _expect(condition: bool, message: String) -> void:
	if not condition:
		failures.append(message)
