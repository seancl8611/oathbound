extends Node

## Non-file regression for the save-slot runtime lifetime boundary. Persistent slot
## files are never selected, rewritten, or deleted here; the smoke stages only transient
## autoload state, invokes the production reset helper through SaveSlots, and verifies
## that no previous run can bleed into a newly selected slot.

var _failed := false


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	_stage_stale_run_state()
	SaveSlots.call("_reset_run_scoped_managers")
	_assert_neutral_run_state()

	if _failed:
		get_tree().quit(1)
		return
	print("[SlotRuntimeLifetimeSmoke] PASS - Gold/Techniques | Aspect/Blood | Corruption | route/resume | run timer isolated across slots")
	get_tree().quit(0)


func _stage_stale_run_state() -> void:
	# RunData + CurrencyManager
	RunData.reset_for_new_run(3)
	RunData.add_gold(77)
	RunData.depth = 9
	RunData.requested_run_goal = RunData.RUN_GOAL_HEART_SUPPRESSION
	RunData.run_goal = RunData.RUN_GOAL_HEART_SUPPRESSION
	RunData.technique_rerolls = 4
	RunData.path_history.append("combat:technique")
	RunData.acquired_upgrades.append("echo_lingering_cut")
	RunData.enemies_killed = 12

	# Run-preparation / combat pressure state. Direct assignment intentionally stages a
	# stale awakened-slot state without mutating MetaProgress or any save file.
	AspectRuntime.set("selected_aspect", "wolf")
	AspectRuntime.set("tier", 2)
	AspectRuntime.set("blood", 48.0)
	CorruptionRuntime.set_corruption_for_playtest(73)
	CorruptionRuntime.set("_encounter_kind", "boss")
	CorruptionRuntime.set("_encounter_token", "boss")
	var boss_checkpoints: Variant = CorruptionRuntime.get("_boss_checkpoints_awarded")
	if boss_checkpoints is Dictionary:
		(boss_checkpoints as Dictionary)["phase_1"] = true

	# Route + prepared-resume state.
	GameFlow.route.clear()
	GameFlow.route.append("combat")
	GameFlow.route.append("boss")
	GameFlow.current_index = 1
	GameFlow.current_area = 3
	GameFlow.set("_resume_checkpoint_pending", {"version": 1, "stale": true})
	GameFlow.set("_resume_in_progress", true)
	GameFlow.set("_resume_player_state", {"hp": 1})
	RouteGenerator.current_route.clear()
	RouteGenerator.current_route.append("combat")
	RouteGenerator.pending_choices.clear()
	RouteGenerator.pending_choices[0] = ["combat", "shrine"]
	RouteGenerator.current_area = 3

	# RecordsRuntime's durable values live in MetaProgress. Stage only its transient
	# active-run lifetime fields.
	RecordsRuntime.set("_run_active", true)
	RecordsRuntime.set("_run_started_msec", Time.get_ticks_msec())
	RecordsRuntime.set("_run_elapsed_before_resume", 21.5)
	RecordsRuntime.set("_run_resource_start", {"mist": 99})
	RecordsRuntime.set("_first_attempt_at_start", true)


func _assert_neutral_run_state() -> void:
	_expect(RunData.current_area_id == 1, "RunData retained previous region")
	_expect(RunData.depth == 0, "RunData retained previous depth")
	_expect(RunData.gold == 0, "RunData retained previous Gold")
	_expect(CurrencyManager.get_amount(CurrencyManager.Currency.GOLD) == 0, "CurrencyManager retained previous Gold")
	_expect(RunData.requested_run_goal.is_empty(), "RunData retained previous requested run goal")
	_expect(RunData.run_goal == RunData.RUN_GOAL_CAMPAIGN, "RunData retained previous resolved run goal")
	_expect(RunData.technique_rerolls == 0, "RunData retained pre-departure Technique rerolls")
	_expect(RunData.path_history.is_empty(), "RunData retained previous route history")
	_expect(RunData.acquired_upgrades.is_empty(), "RunData retained previous Techniques")
	_expect(RunData.enemies_killed == 0, "RunData retained previous run statistics")

	_expect(str(AspectRuntime.get("selected_aspect")).is_empty(), "AspectRuntime retained previous slot Aspect")
	_expect(int(AspectRuntime.get("tier")) == 0, "AspectRuntime retained previous slot Tier")
	_expect(is_zero_approx(float(AspectRuntime.get("blood"))), "AspectRuntime retained previous slot Blood")
	_expect(CorruptionRuntime.get_corruption() == 0, "CorruptionRuntime retained previous slot Corruption")
	_expect(str(CorruptionRuntime.get("_encounter_kind")) == "none", "CorruptionRuntime retained previous encounter kind")
	var boss_checkpoints: Variant = CorruptionRuntime.get("_boss_checkpoints_awarded")
	_expect(boss_checkpoints is Dictionary and (boss_checkpoints as Dictionary).is_empty(), "CorruptionRuntime retained boss checkpoint credits")

	_expect(GameFlow.route.is_empty(), "GameFlow retained previous route")
	_expect(GameFlow.current_index == 0 and GameFlow.current_area == 1, "GameFlow retained previous route position")
	_expect(not GameFlow.has_prepared_resume_checkpoint(), "GameFlow retained previous prepared checkpoint")
	_expect(not bool(GameFlow.get("_resume_in_progress")), "GameFlow retained resume-in-progress state")
	var resume_player: Variant = GameFlow.get("_resume_player_state")
	_expect(resume_player is Dictionary and (resume_player as Dictionary).is_empty(), "GameFlow retained pending Player restore state")
	_expect(RouteGenerator.current_route.is_empty(), "RouteGenerator retained previous route")
	_expect(RouteGenerator.pending_choices.is_empty(), "RouteGenerator retained previous choice state")
	_expect(RouteGenerator.current_area == 1, "RouteGenerator retained previous region")

	_expect(not RecordsRuntime.is_run_active(), "RecordsRuntime retained previous active-run lifetime")
	_expect(is_zero_approx(RecordsRuntime.get_current_run_elapsed_seconds()), "RecordsRuntime retained previous run timer")
	var resource_start: Variant = RecordsRuntime.get("_run_resource_start")
	_expect(resource_start is Dictionary and (resource_start as Dictionary).is_empty(), "RecordsRuntime retained previous resource baseline")
	_expect(not bool(RecordsRuntime.get("_first_attempt_at_start")), "RecordsRuntime retained previous first-attempt marker")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failed = true
	push_error("[SlotRuntimeLifetimeSmoke] FAIL - %s" % message)
