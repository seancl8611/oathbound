extends Node

## Campaign-aware narrative presentation runtime.
## Content lives in OathboundPresentationCatalog; persistence uses MetaProgress flags so
## narrative state follows the same durable campaign save as Bindings and Story Complete.

signal conversation_seen(conversation_id: String)
signal lore_unlocked(record_id: String)

const Catalog = preload("res://Core/Presentation/OathboundPresentationCatalog.gd")
const SEEN_PREFIX := "narrative_seen/"
const LORE_PREFIX := "lore_unlocked/"

var _lore_sync_queued := false


func _ready() -> void:
	if typeof(MetaProgress) == TYPE_OBJECT:
		for signal_name: String in ["progression_changed", "campaign_changed"]:
			if MetaProgress.has_signal(signal_name):
				var cb := Callable(self, "_queue_lore_sync")
				if not MetaProgress.is_connected(signal_name, cb):
					MetaProgress.connect(signal_name, cb)
	if typeof(RelicRuntime) == TYPE_OBJECT and RelicRuntime.has_signal("collection_changed"):
		var relic_cb := Callable(self, "_queue_lore_sync")
		if not RelicRuntime.is_connected("collection_changed", relic_cb):
			RelicRuntime.connect("collection_changed", relic_cb)
	_queue_lore_sync()
	print("[OathboundNarrativeRuntime] v1.1 - campaign dialogue + reachable Discovery Board lore")


func get_shogun_confrontation() -> Dictionary:
	if not MetaProgress.is_returning_blood_awakened():
		return Catalog.shogun_states()[0].duplicate(true)
	var campaign_index := clampi(MetaProgress.get_heart_bindings_destroyed() + 1, 1, 7)
	for state in Catalog.shogun_states():
		if int(state.get("campaign_index", -1)) == campaign_index:
			return state.duplicate(true)
	return {}


func get_next_strand_conversation(npc_id: String) -> Dictionary:
	if not Catalog.STRAND_NPCS.has(npc_id):
		return {}
	for conversation in Catalog.strand_major_conversations():
		if str(conversation.get("npc", "")) != npc_id:
			continue
		if not _conversation_is_available(conversation):
			continue
		if is_conversation_seen(str(conversation.get("id", ""))):
			continue
		return conversation.duplicate(true)
	return {}


func get_available_strand_conversations(npc_id: String, include_seen: bool = false) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for conversation in Catalog.strand_major_conversations():
		if str(conversation.get("npc", "")) != npc_id or not _conversation_is_available(conversation):
			continue
		if not include_seen and is_conversation_seen(str(conversation.get("id", ""))):
			continue
		result.append(conversation.duplicate(true))
	return result


func get_reactive_lines(npc_id: String, event_id: String) -> Dictionary:
	for reaction in Catalog.reactive_line_sets():
		if str(reaction.get("npc", "")) == npc_id and str(reaction.get("event", "")) == event_id:
			return reaction.duplicate(true)
	return {}


func mark_conversation_seen(conversation_id: String) -> bool:
	if conversation_id.is_empty() or is_conversation_seen(conversation_id):
		return false
	MetaProgress.set_progression_flag(SEEN_PREFIX + conversation_id, true)
	conversation_seen.emit(conversation_id)
	return true


func is_conversation_seen(conversation_id: String) -> bool:
	return bool(MetaProgress.get_progression_flag(SEEN_PREFIX + conversation_id, false))


func unlock_lore(record_id: String) -> bool:
	if not has_lore_record(record_id) or is_lore_unlocked(record_id):
		return false
	MetaProgress.set_progression_flag(LORE_PREFIX + record_id, true)
	lore_unlocked.emit(record_id)
	return true


func unlock_lore_for_campaign_state() -> Array[String]:
	var ids: Array[String] = []

	# The Board becomes a useful archive after Akio's first return. These entries are
	# background knowledge the Strand can already document without exposing later twists.
	if MetaProgress.is_returning_blood_awakened():
		ids.append_array([
			"record_order_crossings",
			"record_returning_blood",
			"record_keeper_oath",
			"record_blood_aspects",
			"record_prosthetic_craft",
		])

	# Hushiro's first successful crossing gives the Scribe enough evidence to contextualize
	# the old plague, the spread of Beast Blood, and why containment became necessary.
	if MetaProgress.has_cleared_boss(1):
		ids.append_array([
			"record_hushiro",
			"record_keeper_gate",
			"record_plague_year",
			"record_beast_blood_spread",
			"record_containment",
		])
	if MetaProgress.has_cleared_boss(2):
		ids.append_array(["record_yomori", "record_twin_maws"])
	if MetaProgress.has_cleared_boss(3):
		ids.append_array(["record_kagutsuchi", "record_eclipse_shogun"])

	# Relic provenance becomes relevant once the player has actually obtained one. The
	# live Relic runtime is already slot-scoped, so this discovery follows the active save.
	if _has_any_relic():
		ids.append("record_relic_provenance")

	# Named Court threats use the same durable miniboss flags that drive the launch
	# miniboss-hunter achievement; no parallel codex progression model is introduced.
	if bool(MetaProgress.get_progression_flag("miniboss_defeated/blood_lotus", false)):
		ids.append("record_blood_lotus")
	if bool(MetaProgress.get_progression_flag("miniboss_defeated/eternal_swordsman", false)):
		ids.append("record_eternal_swordsman")

	var bindings := MetaProgress.get_heart_bindings_destroyed()
	if bindings >= 1:
		ids.append_array(["record_first_extraction", "record_seven_bindings", "record_heart_rejection"])
	if bindings >= 3:
		ids.append_array(["record_escaped_child", "record_false_mastery"])
	if bindings >= 6:
		ids.append("record_unbound_heart")
	if MetaProgress.is_story_complete():
		ids.append("record_after_heart")

	var newly_unlocked: Array[String] = []
	for record_id in ids:
		if unlock_lore(record_id):
			newly_unlocked.append(record_id)
	return newly_unlocked


func is_lore_unlocked(record_id: String) -> bool:
	return bool(MetaProgress.get_progression_flag(LORE_PREFIX + record_id, false))


func get_unlocked_lore() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for record in Catalog.lore_records():
		if is_lore_unlocked(str(record.get("id", ""))):
			result.append(record.duplicate(true))
	return result


func get_all_lore() -> Array[Dictionary]:
	return Catalog.lore_records()


func has_lore_record(record_id: String) -> bool:
	for record in Catalog.lore_records():
		if str(record.get("id", "")) == record_id:
			return true
	return false


func get_lore_record(record_id: String) -> Dictionary:
	for record in Catalog.lore_records():
		if str(record.get("id", "")) == record_id:
			return record.duplicate(true)
	return {}


func get_help_topics() -> Array[Dictionary]:
	return Catalog.help_topics()


func get_ending_sequence() -> Array[Dictionary]:
	return Catalog.ending_sequence()


func get_postgame_explanation() -> Array[Dictionary]:
	return Catalog.postgame_explanation()


func _queue_lore_sync() -> void:
	if _lore_sync_queued:
		return
	_lore_sync_queued = true
	call_deferred("_run_queued_lore_sync")


func _run_queued_lore_sync() -> void:
	_lore_sync_queued = false
	unlock_lore_for_campaign_state()


func _has_any_relic() -> bool:
	if typeof(RelicRuntime) != TYPE_OBJECT:
		return false
	var unlocked_value: Variant = RelicRuntime.get("unlocked_relics")
	return unlocked_value is Dictionary and not (unlocked_value as Dictionary).is_empty()


func _conversation_is_available(conversation: Dictionary) -> bool:
	if bool(conversation.get("requires_awakened", false)) and not MetaProgress.is_returning_blood_awakened():
		return false
	if MetaProgress.is_story_complete():
		return false
	var destroyed := MetaProgress.get_heart_bindings_destroyed()
	var min_bindings := int(conversation.get("min_bindings", 0))
	var max_bindings := int(conversation.get("max_bindings", MetaProgress.TOTAL_HEART_BINDINGS))
	return destroyed >= min_bindings and destroyed <= max_bindings
