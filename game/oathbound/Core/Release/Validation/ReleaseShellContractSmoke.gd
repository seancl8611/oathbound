extends Node

## Non-destructive contract smoke for the launch release shell. It validates structure
## and round-trips isolated in-memory run state without deleting or replacing user save
## slots. SaveSlots is only asked for its canonical paths/metadata.

const SAVE_SCRIPT = preload("res://Core/Release/OathboundSaveSlotManager.gd")
const SETTINGS_SCRIPT = preload("res://Core/Release/OathboundSettingsManager.gd")
const RUN_DATA_SCRIPT = preload("res://Core/Release/OathboundReleaseRunData.gd")
const FLOW_SCRIPT = preload("res://Core/Release/OathboundReleaseGameFlow.gd")
const TITLE_SCENE = preload("res://TitleScreen/menu.tscn")
const PAUSE_SCRIPT = preload("res://Core/Release/OathboundPauseOverview.gd")

const REQUIRED_SETTINGS: Array[String] = [
	"master_volume", "music_volume", "sfx_volume", "ambience_volume",
	"vibration_enabled", "vibration_strength", "screen_shake",
	"reduced_flashing", "reduced_intense_vfx", "ui_scale", "text_scale",
	"high_contrast", "damage_numbers", "dialogue_text_speed", "instant_text",
	"block_mode",
]
const REQUIRED_BINDINGS: Array[String] = [
	"up", "down", "left", "right", "attack", "parry", "dash", "interact",
	"prosthetic", "special", "execute_finisher",
]
const REQUIRED_FRONT_END_BUTTONS: Array[String] = [
	"Continue", "New Game", "Settings", "Credits", "Quit",
]
const REQUIRED_SETTINGS_METHODS: Array[String] = [
	"get_controller_glyph_label", "get_screen_shake_scale", "should_reduce_flashing",
	"should_reduce_intense_vfx", "is_high_contrast_enabled", "should_show_damage_numbers",
	"get_dialogue_text_speed", "uses_instant_text", "get_block_mode",
]

class CheckpointExecutor:
	extends Node
	signal spirit_changed(current: int, maximum: int)
	var current_spirit: int = 37
	var max_spirit: int = 120
	func get_spirit() -> int:
		return current_spirit
	func get_max_spirit() -> int:
		return max_spirit

class CheckpointPlayer:
	extends Node
	var hp: int = 46
	var maxhp: int = 130
	var stagger_max: float = 84.0
	var collected_upgrades: Array = []
	var prosthetic_executor: Node = null
	func _update_health_bar() -> void:
		pass

var _failed := false


func _ready() -> void:
	call_deferred("_run_contract")


func _run_contract() -> void:
	_validate_save_slot_contract()
	_validate_settings_contract()
	_validate_checkpoint_round_trip()
	_validate_records_contract()
	await _validate_front_end_contract()
	await _validate_pause_overview_contract()

	if _failed:
		get_tree().quit(1)
		return
	print("[ReleaseShellContractSmoke] PASS - 3 slots | settings/rebinding | safe checkpoint | records/completion | Oathbound front end")
	get_tree().quit(0)


func _validate_save_slot_contract() -> void:
	_expect(SAVE_SCRIPT.SLOT_COUNT == 3, "launch save-slot count must be exactly three")
	var paths: Array[String] = []
	for slot in range(1, SAVE_SCRIPT.SLOT_COUNT + 1):
		var path: String = SaveSlots.get_slot_file("meta_progress.cfg", slot)
		paths.append(path)
		_expect(path.ends_with("/slot_%d/meta_progress.cfg" % slot), "slot %d path is not isolated" % slot)
	_expect(paths.size() == 3 and paths[0] != paths[1] and paths[1] != paths[2] and paths[0] != paths[2], "save-slot paths overlap")
	for slot in range(1, 4):
		var metadata: Dictionary = SaveSlots.get_slot_metadata(slot)
		_expect(int(metadata.get("slot", 0)) == slot, "slot-card metadata reports wrong slot")
		_expect(metadata.has("playtime_seconds"), "slot-card metadata missing playtime")
		_expect(metadata.has("heart_bindings_destroyed"), "slot-card metadata missing Binding state")
		_expect(metadata.has("story_complete"), "slot-card metadata missing Story Complete")
		_expect(metadata.has("completion_percent"), "slot-card metadata missing completion percentage")
		_expect(metadata.has("has_active_run"), "slot-card metadata missing safe-run checkpoint marker")


func _validate_settings_contract() -> void:
	for key: String in REQUIRED_SETTINGS:
		_expect(SETTINGS_SCRIPT.DEFAULTS.has(key), "required setting missing: %s" % key)
	for action: String in REQUIRED_BINDINGS:
		_expect(action in SETTINGS_SCRIPT.BINDABLE_ACTIONS, "required rebindable action missing: %s" % action)
	for method_name: String in REQUIRED_SETTINGS_METHODS:
		_expect(SettingsManager.has_method(method_name), "live settings API missing: %s" % method_name)
	_expect(float(SETTINGS_SCRIPT.DEFAULTS.get("ui_scale", 0.0)) > 0.0, "UI scale default invalid")
	_expect(float(SETTINGS_SCRIPT.DEFAULTS.get("text_scale", 0.0)) > 0.0, "text scale default invalid")
	_expect(str(SETTINGS_SCRIPT.DEFAULTS.get("block_mode", "")) in ["hold", "toggle"], "block-mode default invalid")
	_expect(ThemeDB.fallback_base_scale > 0.0, "ThemeDB UI fallback scale was not initialized")
	_expect(ThemeDB.fallback_font_size > 0, "ThemeDB text fallback size was not initialized")


func _validate_checkpoint_round_trip() -> void:
	var source: Node = RUN_DATA_SCRIPT.new()
	source.current_area_id = 2
	source.depth = 7
	source.gold = 133
	# Postgame run-goal selection is Boat-owned and must survive a safe quit/resume.
	source.requested_run_goal = source.RUN_GOAL_HEART_SUPPRESSION
	source.run_goal = source.RUN_GOAL_HEART_SUPPRESSION
	source.technique_rerolls = 2
	source.path_history.append("combat:technique")
	source.path_history.append("shrine")
	# Technique ownership is slotless. These are three real launch Action Techniques
	# sharing the Basic trigger, proving checkpoint serialization preserves the exact
	# collection instead of collapsing same-trigger Techniques into positional entries.
	source.acquired_upgrades.append("echo_lingering_cut")
	source.acquired_upgrades.append("rupture_rupturing_edge")
	source.acquired_upgrades.append("seal_sealing_cuts")
	source.enemies_killed = 14
	source.perfect_parries = 6
	var checkpoint: Dictionary = source.get_checkpoint_state()

	var restored: Node = RUN_DATA_SCRIPT.new()
	_expect(restored.restore_checkpoint_state(checkpoint), "safe run-state checkpoint did not restore")
	_expect(restored.current_area_id == 2, "checkpoint lost current region")
	_expect(restored.depth == 7, "checkpoint lost chamber depth")
	_expect(restored.gold == 133, "checkpoint lost Gold")
	_expect(restored.requested_run_goal == source.RUN_GOAL_HEART_SUPPRESSION, "checkpoint lost requested postgame run goal")
	_expect(restored.run_goal == source.RUN_GOAL_HEART_SUPPRESSION, "checkpoint lost resolved postgame run goal")
	_expect(restored.technique_rerolls == 2, "checkpoint lost Technique rerolls")
	_expect(restored.path_history == source.path_history, "checkpoint lost route history")
	_expect(restored.acquired_upgrades == source.acquired_upgrades, "checkpoint lost or collapsed the slotless Technique collection")
	_expect(restored.acquired_upgrades.size() == 3, "checkpoint did not preserve all same-run Techniques")
	_expect(restored.enemies_killed == 14 and restored.perfect_parries == 6, "checkpoint lost run statistics")

	var flow: Node = FLOW_SCRIPT.new()
	var valid_checkpoint := {
		"version": flow.CHECKPOINT_VERSION,
		"run_data": checkpoint,
		"gameflow": {
			"current_area": int(checkpoint.get("current_area_id", 2)),
			"current_index": 0,
			"route": ["combat", "boss"],
			"pending_choices": {},
		},
	}
	_expect(not flow.prepare_resume_checkpoint({"version": 0}), "release GameFlow accepted an obsolete checkpoint version")
	_expect(not flow.prepare_resume_checkpoint({"version": flow.CHECKPOINT_VERSION}), "release GameFlow accepted an incomplete current-version checkpoint")
	_expect(flow.prepare_resume_checkpoint(valid_checkpoint), "release GameFlow rejected a structurally valid current checkpoint")
	_expect(flow.has_prepared_resume_checkpoint(), "release GameFlow did not retain prepared checkpoint")
	_expect(not flow.prepare_resume_checkpoint({"version": flow.CHECKPOINT_VERSION}), "release GameFlow accepted a later incomplete checkpoint")
	_expect(not flow.has_prepared_resume_checkpoint(), "rejected checkpoint retained a stale previously prepared resume")

	# Player vitals are part of the safe chamber snapshot even though the broader
	# handoff harness intentionally avoids scene/player creation. Exercise the exact
	# production capture/apply helpers in memory so resume cannot silently reset them.
	var checkpoint_player := CheckpointPlayer.new()
	var checkpoint_executor := CheckpointExecutor.new()
	checkpoint_player.prosthetic_executor = checkpoint_executor
	checkpoint_player.add_child(checkpoint_executor)
	flow.player = checkpoint_player
	var player_state: Dictionary = flow.call("_capture_player_state")
	_expect(int(player_state.get("hp", -1)) == 46, "checkpoint player capture lost Health")
	_expect(int(player_state.get("maxhp", -1)) == 130, "checkpoint player capture lost max Health")
	_expect(is_equal_approx(float(player_state.get("stagger_max", -1.0)), 84.0), "checkpoint player capture lost Posture capacity")
	_expect(int(player_state.get("spirit", -1)) == 37, "checkpoint player capture lost Spirit")
	_expect(int(player_state.get("max_spirit", -1)) == 120, "checkpoint player capture lost max Spirit")

	checkpoint_player.hp = 99
	checkpoint_player.maxhp = 99
	checkpoint_player.stagger_max = 1.0
	checkpoint_executor.current_spirit = 2
	checkpoint_executor.max_spirit = 20
	flow.call("_apply_resume_player_state", player_state)
	_expect(checkpoint_player.hp == 46, "checkpoint player restore lost Health")
	_expect(checkpoint_player.maxhp == 130, "checkpoint player restore lost max Health")
	_expect(is_equal_approx(checkpoint_player.stagger_max, 84.0), "checkpoint player restore lost Posture capacity")
	_expect(checkpoint_executor.current_spirit == 37, "checkpoint player restore lost Spirit")
	_expect(checkpoint_executor.max_spirit == 120, "checkpoint player restore lost max Spirit")

	checkpoint_player.free()
	source.free()
	restored.free()
	flow.free()


func _validate_records_contract() -> void:
	var breakdown: Dictionary = RecordsRuntime.get_completion_breakdown()
	_expect(_total(breakdown, "story") == 1, "completion contract must include Story Complete")
	_expect(_total(breakdown, "bloodwell") == 10, "completion contract must include 10 Akio Bloodwell nodes")
	_expect(_total(breakdown, "run_infrastructure") == 8, "completion contract must include 8 Run Infrastructure nodes")
	_expect(_total(breakdown, "blood_mirror") == 9, "completion contract must include 9 Blood Mirror nodes")
	_expect(_total(breakdown, "prosthetics") == 8, "completion contract must include 8 Prosthetics")
	_expect(_total(breakdown, "prosthetic_upgrades") == 19, "completion contract must include 19 Prosthetic upgrades")
	_expect(_total(breakdown, "relics") == 9, "completion contract must include the nine currently obtainable Relics")
	_expect(_total(breakdown, "relic_mastery") == 18, "completion contract must include mastery for currently obtainable Relics")
	_expect(_total(breakdown, "techniques") == 60, "completion contract must include 50 Techniques + 10 refinements")
	_expect(_total(breakdown, "trials") == 1, "completion contract must require only the currently playable Execution Trial")
	_expect(_total(breakdown, "heart_aspects") == 3, "completion contract must include Wolf/Wraith/Ronin Heart victories")
	_expect(_total(breakdown, "discovery_records") == 24, "completion contract must include all 24 authored reachable Discovery Board records")
	_expect(RecordsRuntime.REQUIRED_DISCOVERY_RECORDS.size() == NarrativeRuntime.get_all_lore().size(), "required Discovery Board list drifted from the authored lore catalog")

	var records: Dictionary = RecordsRuntime.get_records_snapshot()
	for key: String in [
		"total_attempts", "standard_expedition_clears", "heart_suppression_clears",
		"fastest_standard_seconds", "fastest_suppression_seconds", "heart_wolf",
		"heart_wraith", "heart_ronin", "boss_defeat_counts", "miniboss_defeats",
		"deepest_first_attempt", "first_heart_victory", "completion_percent",
	]:
		_expect(records.has(key), "persistent run-record field missing: %s" % key)


func _validate_front_end_contract() -> void:
	var front_end: Node = TITLE_SCENE.instantiate()
	add_child(front_end)
	await get_tree().process_frame
	var title_found := false
	var button_texts: Array[String] = []
	for label_node: Node in front_end.find_children("*", "Label", true, false):
		if label_node is Label and (label_node as Label).text == "OATHBOUND":
			title_found = true
	for button_node: Node in front_end.find_children("*", "Button", true, false):
		if button_node is Button:
			button_texts.append((button_node as Button).text)
	_expect(title_found, "front end does not present the OATHBOUND title")
	for label: String in REQUIRED_FRONT_END_BUTTONS:
		_expect(label in button_texts, "front end missing required action: %s" % label)
	_expect(front_end.has_method("_prepare_continue_checkpoint"), "front end lacks safe checkpoint preparation gate")
	if front_end.has_method("_prepare_continue_checkpoint"):
		_expect(
			not bool(front_end.call("_prepare_continue_checkpoint", {"version": FLOW_SCRIPT.CHECKPOINT_VERSION})),
			"front end accepted an incomplete checkpoint instead of falling back safely"
		)

	front_end.call("_build_settings_menu")
	await get_tree().process_frame
	var block_mode_button_found := false
	var rebinding_button_found := false
	for button_node: Node in front_end.find_children("*", "Button", true, false):
		if not (button_node is Button):
			continue
		var text := (button_node as Button).text
		if text.begins_with("Block Input:"):
			block_mode_button_found = true
		if text == "Controls / Rebinding":
			rebinding_button_found = true
	_expect(block_mode_button_found, "Settings UI does not expose Hold/Toggle block preference")
	_expect(rebinding_button_found, "Settings UI does not expose controls/rebinding")

	front_end.queue_free()
	await get_tree().process_frame


func _validate_pause_overview_contract() -> void:
	var overlay_value: Variant = PAUSE_SCRIPT.new()
	_expect(overlay_value is CanvasLayer, "Pause / Build Overview did not instantiate as a CanvasLayer")
	if not (overlay_value is CanvasLayer):
		return
	var overlay := overlay_value as CanvasLayer
	add_child(overlay)
	await get_tree().process_frame
	_expect(get_tree().paused, "Pause / Build Overview did not pause gameplay")
	var title_found := false
	var resume_found := false
	var technique_overview_found := false
	for label_node: Node in overlay.find_children("*", "Label", true, false):
		if label_node is Label and (label_node as Label).text == "PAUSE / BUILD OVERVIEW":
			title_found = true
	for button_node: Node in overlay.find_children("*", "Button", true, false):
		if button_node is Button and (button_node as Button).text == "Resume":
			resume_found = true
	for rich_node: Node in overlay.find_children("*", "RichTextLabel", true, false):
		if rich_node is RichTextLabel and (rich_node as RichTextLabel).text.find("Owned Techniques") != -1:
			technique_overview_found = true
	_expect(title_found, "Pause / Build Overview missing title")
	_expect(resume_found, "Pause / Build Overview missing Resume action")
	_expect(technique_overview_found, "Pause / Build Overview missing Technique grouping")
	overlay.call("_close")
	await get_tree().process_frame
	_expect(not get_tree().paused, "Pause / Build Overview did not restore gameplay pause state")


func _total(breakdown: Dictionary, key: String) -> int:
	var value: Variant = breakdown.get(key, {})
	if not (value is Dictionary):
		return -1
	return int((value as Dictionary).get("total", -1))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[ReleaseShellContractSmoke] FAIL - %s" % message)
