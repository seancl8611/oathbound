extends Node

const ENDGAME_FLOW = preload("res://Core/Endgame/OathboundEndgameFlow.gd")
const HANDOFF_SCENE = preload("res://Core/Endgame/HeartHandoffChamber.tscn")
const HEART_SHELL_SCENE = preload("res://Core/Endgame/HeartEncounterShell.tscn")

class DummyExecutor:
	extends Node
	signal spirit_changed(current: int, maximum: int)
	var max_spirit: int = 100
	var current_spirit: int = 10
	func get_max_spirit() -> int:
		return max_spirit
	func get_spirit() -> int:
		return current_spirit

class DummyPlayer:
	extends Node
	var maxhp: int = 100
	var hp: int = 5
	var prosthetic_executor: Node = null
	var run_hud: Node = null
	func _update_health_bar() -> void:
		pass

var _failures: Array[String] = []
var _snapshot: Dictionary = {}
var _heart_defeat_signal_count := 0


func _ready() -> void:
	await get_tree().process_frame
	_snapshot_state()
	_run_campaign_contract()
	_run_recovery_contract()
	await _run_scene_contract()
	_restore_state()

	if _failures.is_empty():
		print("[EndgameCampaignContractSmoke] PASS - six Bindings | seventh Heart route | postgame goals | 30/50 recovery + 40/60 floors")
		get_tree().quit(0)
	else:
		for failure: String in _failures:
			push_error("[EndgameCampaignContractSmoke] %s" % failure)
		print("[EndgameCampaignContractSmoke] FAIL count=%d" % _failures.size())
		get_tree().quit(1)


func _snapshot_state() -> void:
	_snapshot = {
		"returning_blood_awakened": bool(MetaProgress.returning_blood_awakened),
		"heart_bindings_destroyed": int(MetaProgress.heart_bindings_destroyed),
		"story_complete": bool(MetaProgress.story_complete),
		"standard_expedition_clears": int(MetaProgress.standard_expedition_clears),
		"heart_suppression_clears": int(MetaProgress.heart_suppression_clears),
		"boss_clears": MetaProgress.boss_clears.duplicate(true),
		"boss_defeat_counts": MetaProgress.boss_defeat_counts.duplicate(true),
		"requested_run_goal": str(RunData.requested_run_goal),
		"run_goal": str(RunData.run_goal),
		"completion_kind": str(RunData.run_completion_kind),
	}


func _restore_state() -> void:
	MetaProgress.returning_blood_awakened = bool(_snapshot.get("returning_blood_awakened", false))
	MetaProgress.heart_bindings_destroyed = int(_snapshot.get("heart_bindings_destroyed", 0))
	MetaProgress.story_complete = bool(_snapshot.get("story_complete", false))
	MetaProgress.standard_expedition_clears = int(_snapshot.get("standard_expedition_clears", 0))
	MetaProgress.heart_suppression_clears = int(_snapshot.get("heart_suppression_clears", 0))
	MetaProgress.boss_clears = (_snapshot.get("boss_clears", {}) as Dictionary).duplicate(true)
	MetaProgress.boss_defeat_counts = (_snapshot.get("boss_defeat_counts", {}) as Dictionary).duplicate(true)
	RunData.requested_run_goal = str(_snapshot.get("requested_run_goal", ""))
	RunData.run_goal = str(_snapshot.get("run_goal", RunData.RUN_GOAL_CAMPAIGN))
	RunData.run_completion_kind = str(_snapshot.get("completion_kind", ""))
	# The smoke intentionally exercises persistence methods. Restore the caller's exact
	# campaign state before exiting so a local validation run is save-safe.
	if MetaProgress.has_method("_save_progress"):
		MetaProgress.call("_save_progress")


func _run_campaign_contract() -> void:
	MetaProgress.returning_blood_awakened = false
	MetaProgress.heart_bindings_destroyed = 0
	MetaProgress.story_complete = false
	RunData.run_goal = RunData.RUN_GOAL_CAMPAIGN
	_expect(ENDGAME_FLOW.determine_shogun_outcome(MetaProgress, RunData) == ENDGAME_FLOW.OUTCOME_PRE_AWAKENED_HEART_CONTACT, "Pre-awakening Shogun clear must route to Heart contact, not a Binding")
	_expect(not MetaProgress.destroy_next_heart_binding(), "Pre-awakening state must not destroy a Heart Binding")

	MetaProgress.returning_blood_awakened = true
	_expect(ENDGAME_FLOW.determine_shogun_outcome(MetaProgress, RunData) == ENDGAME_FLOW.OUTCOME_BINDING_COMPLETION, "Awakened campaign must begin with Binding completion")
	_expect(not MetaProgress.mark_story_complete(), "Story Complete must be rejected before all six Bindings")

	for expected_count: int in range(1, MetaProgress.TOTAL_HEART_BINDINGS + 1):
		_expect(ENDGAME_FLOW.complete_binding(MetaProgress), "Binding %d could not be destroyed" % expected_count)
		_expect(MetaProgress.get_heart_bindings_destroyed() == expected_count, "Binding count mismatch after completion %d" % expected_count)
		_expect(MetaProgress.get_heart_bindings_remaining() == MetaProgress.TOTAL_HEART_BINDINGS - expected_count, "Remaining Binding count mismatch after %d" % expected_count)

	_expect(not ENDGAME_FLOW.complete_binding(MetaProgress), "A seventh Binding completion must be impossible")
	_expect(MetaProgress.is_true_final_story_run_due(), "Six destroyed Bindings must arm the seventh-run true-final Heart route")
	_expect(ENDGAME_FLOW.determine_shogun_outcome(MetaProgress, RunData) == ENDGAME_FLOW.OUTCOME_TRUE_FINAL_HEART, "Seventh successful campaign Shogun clear must continue to the true-final Heart")

	_expect(ENDGAME_FLOW.complete_heart_victory(MetaProgress, false), "First true-final Heart victory must set Story Complete")
	_expect(MetaProgress.is_story_complete(), "Story Complete flag missing after first Heart victory")
	_expect(MetaProgress.get_heart_bindings_destroyed() == 6, "Story Complete must preserve all six destroyed Bindings")

	RunData.run_goal = RunData.RUN_GOAL_STANDARD_EXPEDITION
	_expect(ENDGAME_FLOW.determine_shogun_outcome(MetaProgress, RunData) == ENDGAME_FLOW.OUTCOME_STANDARD_EXPEDITION, "Postgame Standard Expedition must end at Shogun")
	var standard_before := MetaProgress.standard_expedition_clears
	_expect(ENDGAME_FLOW.complete_standard_expedition(MetaProgress), "Standard Expedition clear could not be recorded")
	_expect(MetaProgress.standard_expedition_clears == standard_before + 1, "Standard Expedition clear record did not increment exactly once")

	RunData.run_goal = RunData.RUN_GOAL_HEART_SUPPRESSION
	_expect(ENDGAME_FLOW.determine_shogun_outcome(MetaProgress, RunData) == ENDGAME_FLOW.OUTCOME_HEART_SUPPRESSION, "Postgame Heart Suppression must continue past Shogun")
	var suppression_before := MetaProgress.heart_suppression_clears
	_expect(ENDGAME_FLOW.complete_heart_victory(MetaProgress, true), "Heart Suppression clear could not be recorded")
	_expect(MetaProgress.heart_suppression_clears == suppression_before + 1, "Heart Suppression clear record did not increment exactly once")

	# Run-goal API itself must reject postgame objectives before Story Complete and
	# preserve an explicit postgame selection through reset_for_new_run().
	MetaProgress.story_complete = false
	RunData.requested_run_goal = ""
	_expect(not RunData.request_run_goal(RunData.RUN_GOAL_HEART_SUPPRESSION), "Pre-story run-goal API accepted Heart Suppression")
	_expect(RunData.request_run_goal(RunData.RUN_GOAL_CAMPAIGN), "Campaign goal request was rejected")
	MetaProgress.story_complete = true
	RunData.requested_run_goal = ""
	_expect(RunData.request_run_goal(RunData.RUN_GOAL_HEART_SUPPRESSION), "Postgame Heart Suppression request was rejected")
	RunData.reset_for_new_run(1)
	_expect(RunData.get_run_goal() == RunData.RUN_GOAL_HEART_SUPPRESSION, "Requested postgame run goal did not survive RunData reset")


func _run_recovery_contract() -> void:
	var player := DummyPlayer.new()
	var executor := DummyExecutor.new()
	player.prosthetic_executor = executor
	add_child(player)
	player.add_child(executor)

	var result := ENDGAME_FLOW.apply_shogun_to_heart_recovery(player)
	_expect(player.hp == 40, "Low-health Heart handoff must enforce 40% floor; got %d" % player.hp)
	_expect(executor.current_spirit == 60, "Low-Spirit Heart handoff must restore to 60%; got %d" % executor.current_spirit)
	_expect(int(result.get("health_before", -1)) == 5 and int(result.get("health_after", -1)) == 40, "Health recovery telemetry mismatch")
	_expect(int(result.get("spirit_before", -1)) == 10 and int(result.get("spirit_after", -1)) == 60, "Spirit recovery telemetry mismatch")

	player.hp = 85
	executor.current_spirit = 70
	ENDGAME_FLOW.apply_shogun_to_heart_recovery(player)
	_expect(player.hp == 100, "30% max Health restoration must cap at max")
	_expect(executor.current_spirit == 100, "50% max Spirit restoration must cap at max")
	player.queue_free()


func _run_scene_contract() -> void:
	var handoff := HANDOFF_SCENE.instantiate()
	handoff.set_meta("endgame_outcome", ENDGAME_FLOW.OUTCOME_BINDING_COMPLETION)
	add_child(handoff)
	await get_tree().process_frame
	_expect(handoff.has_signal("handoff_completed"), "Heart handoff scene lacks completion signal")
	_expect(handoff.get_node_or_null("PlayerSpawn") != null, "Heart handoff scene lacks PlayerSpawn")
	_expect(handoff.get_node_or_null("ExitGate") != null, "Heart handoff scene lacks explicit interaction gate")
	handoff.queue_free()
	await get_tree().process_frame

	var shell := HEART_SHELL_SCENE.instantiate()
	shell.set_meta("postgame_suppression", false)
	shell.set_meta("contract_test", true)
	_heart_defeat_signal_count = 0
	shell.heart_defeated.connect(_on_contract_heart_defeated)
	add_child(shell)
	await get_tree().process_frame
	_expect(shell.is_in_group("heart_encounter_shell"), "Heart encounter shell did not identify itself")
	shell.complete_for_contract_test()
	await get_tree().process_frame
	_expect(_heart_defeat_signal_count == 1, "Heart encounter shell completion signal must emit exactly once")
	shell.complete_for_contract_test()
	await get_tree().process_frame
	_expect(_heart_defeat_signal_count == 1, "Heart encounter shell allowed duplicate completion")
	shell.queue_free()


func _on_contract_heart_defeated(_postgame: bool) -> void:
	_heart_defeat_signal_count += 1


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
