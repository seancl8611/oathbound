extends RefCounted

## Save-slot lifetime boundary for autoload state that is intentionally NOT durable.
##
## SaveSlots reloads MetaProgress / Prosthetics / Relics from the newly selected slot
## first, then calls this helper before the front end enters the Strand or RunScene.
## This prevents run-only state from a previously active slot from leaking across the
## three save slots without introducing another persistence model.

const RUN_GOAL_CAMPAIGN := "campaign"


static func reset_run_scoped_state(root: Node) -> void:
	if root == null:
		return
	_reset_run_data(root.get_node_or_null("RunData"))
	_reset_aspect(root.get_node_or_null("AspectRuntime"))
	_reset_corruption(root.get_node_or_null("CorruptionRuntime"))
	_reset_game_flow(root.get_node_or_null("GameFlow"), root.get_node_or_null("RouteGenerator"))
	_reset_records(root.get_node_or_null("RecordsRuntime"))


static func _reset_run_data(run_data: Node) -> void:
	if run_data == null:
		return
	# Reuse the canonical run reset so CurrencyManager Gold and every run statistic are
	# cleared through their existing authority, then neutralize pre-departure fields.
	run_data.set("requested_run_goal", "")
	if run_data.has_method("reset_for_new_run"):
		run_data.call("reset_for_new_run", 1)
	run_data.set("requested_run_goal", "")
	run_data.set("run_goal", RUN_GOAL_CAMPAIGN)
	run_data.set("run_completion_kind", "")
	# Starting rerolls belong to an actual departure, not to merely selecting a slot.
	run_data.set("technique_rerolls", 0)


static func _reset_aspect(aspect: Node) -> void:
	if aspect == null:
		return
	# Aspect choice is run preparation, never save-slot identity. Setting the explicit
	# no-Aspect sentinel before campaign synchronization also handles two awakened slots.
	aspect.set("selected_aspect", "")
	if aspect.has_method("synchronize_campaign_state"):
		aspect.call("synchronize_campaign_state", true)
	else:
		aspect.set("tier", 0)
		aspect.set("blood", 0.0)


static func _reset_corruption(corruption: Node) -> void:
	if corruption == null:
		return
	if corruption.has_method("set_corruption_for_playtest"):
		corruption.call("set_corruption_for_playtest", 0)
	if corruption.has_method("_reset_encounter_state"):
		corruption.call("_reset_encounter_state")
	_clear_dictionary_property(corruption, "_boss_checkpoints_awarded")
	_clear_dictionary_property(corruption, "_tracked_enemies")
	corruption.set("_enemy_scan_accum", 0.0)


static func _reset_game_flow(flow: Node, route_generator: Node) -> void:
	if flow != null:
		_clear_array_property(flow, "route")
		flow.set("current_index", 0)
		flow.set("current_area", 1)
		flow.set("player", null)
		flow.set("room_container", null)
		flow.set("_awaiting_choice", false)
		flow.set("_choice_slot", -1)
		_clear_dictionary_property(flow, "_resume_checkpoint_pending")
		flow.set("_resume_in_progress", false)
		_clear_dictionary_property(flow, "_resume_player_state")
		flow.set("_endgame_handoff_active", false)
		flow.set("_endgame_outcome", "")
		flow.set("_final_kagutsuchi_depth_recorded", false)
	if route_generator != null:
		_clear_array_property(route_generator, "current_route")
		_clear_dictionary_property(route_generator, "pending_choices")
		route_generator.set("current_area", 1)


static func _reset_records(records: Node) -> void:
	if records == null:
		return
	# Persistent record values live in MetaProgress flags and are untouched. Only the
	# in-progress run timer/resource baseline is abandoned at the slot boundary.
	records.set("_run_active", false)
	records.set("_run_started_msec", 0)
	records.set("_run_elapsed_before_resume", 0.0)
	_clear_dictionary_property(records, "_run_resource_start")
	records.set("_first_attempt_at_start", false)


static func _clear_dictionary_property(node: Node, property_name: String) -> void:
	var value: Variant = node.get(property_name)
	if value is Dictionary:
		(value as Dictionary).clear()


static func _clear_array_property(node: Node, property_name: String) -> void:
	var value: Variant = node.get(property_name)
	if value is Array:
		(value as Array).clear()
