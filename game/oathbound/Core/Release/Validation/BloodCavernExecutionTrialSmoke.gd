extends Node

## Dedicated deep regression for the first playable Blood Cavern challenge.
##
## This intentionally goes beyond the broad Cavern surface smoke: it fills the real
## shared Hushiro Posture meter, waits through the canonical readability beat, verifies
## Akio receives the executable target, invokes the current Player deathblow entrypoint,
## and then checks first-clear presentation/persistence plus repeat-clear isolation.

const HUB_SCENE = preload("res://World/HubScene.tscn")
const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

const TRIAL_EXECUTION := "execution_trial"
const EXPECTED_RELIC := RELIC_CATALOG.EXECUTION_BEAD

var _failed: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	if typeof(MetaProgress) != TYPE_OBJECT or typeof(RelicRuntime) != TYPE_OBJECT:
		_fail("MetaProgress and RelicRuntime must be available")
		_finish()
		return

	var original_completions: Dictionary = MetaProgress.blood_cavern_trial_completions.duplicate(true)
	var original_unlocked: Dictionary = RelicRuntime.unlocked_relics.duplicate(true)
	var original_mastery: Dictionary = RelicRuntime.mastery_kills.duplicate(true)
	var original_equipped: String = str(RelicRuntime.equipped_relic_id)
	var gold_before: int = int(RunData.gold) if typeof(RunData) == TYPE_OBJECT else 0
	var mist_before: int = int(MetaProgress.mist)
	var scrolls_before: int = int(MetaProgress.scrolls)

	# Force a deterministic first-clear fixture, then persist it because the real trial
	# completion API also writes to disk. The exact inherited state is restored below.
	MetaProgress.blood_cavern_trial_completions.erase(TRIAL_EXECUTION)
	MetaProgress.flush_save()
	RelicRuntime.unlocked_relics.erase(EXPECTED_RELIC)
	RelicRuntime.mastery_kills.erase(EXPECTED_RELIC)
	if RelicRuntime.has_method("_save_progress"):
		RelicRuntime.call("_save_progress")

	var hub: Node = HUB_SCENE.instantiate()
	add_child(hub)
	await get_tree().process_frame
	await get_tree().process_frame

	var cavern: Node = hub.get_node_or_null("BloodCavern")
	var player: Node = get_tree().get_first_node_in_group("player")
	_expect(cavern != null, "live Hub has no Blood Cavern")
	_expect(player != null, "live Hub has no player actor")
	if cavern == null or player == null:
		_restore_progression(original_completions, original_unlocked, original_mastery, original_equipped)
		hub.queue_free()
		_finish()
		return

	cavern.call("_start_execution_trial")
	await get_tree().process_frame
	await get_tree().process_frame
	var targets: Array[Node] = get_tree().get_nodes_in_group("blood_cavern_training_target")
	_expect(targets.size() == 1, "Execution Trial did not spawn exactly one training target")
	if targets.size() != 1:
		_restore_progression(original_completions, original_unlocked, original_mastery, original_equipped)
		hub.queue_free()
		_finish()
		return

	var target: Node = targets[0]
	_expect(target.has_method("get_training_mode") and str(target.call("get_training_mode")) == TRIAL_EXECUTION, "target is not configured for Execution Trial mode")
	var break_runtime: Node = target.get_node_or_null("HushiroPostureBreakRuntime")
	_expect(break_runtime != null, "Execution Trial target lost shared Hushiro posture-break runtime")
	var combat: Node = target.get_node_or_null("Combat")
	_expect(combat != null, "Execution Trial target has no shared CombatController")

	# A plain Health defeat must never satisfy the objective.
	target.call("death")
	await get_tree().process_frame
	await get_tree().process_frame
	var plain_death_snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	_expect(str(plain_death_snapshot.get("active_trial", "")) == TRIAL_EXECUTION, "Health-only target defeat completed the Execution Trial")
	_expect(not MetaProgress.has_completed_blood_cavern_trial(TRIAL_EXECUTION), "Health-only target defeat persisted trial completion")

	# Fill the canonical shared Posture meter instead of directly toggling a deathblow
	# flag. HushiroPostureBreakRuntime owns the 0.20 s readability beat and then forwards
	# the target to the current Player CombatController.
	var posture_max: float = 90.0
	if combat != null:
		var cfg_value: Variant = combat.get("config")
		if cfg_value is CombatConfig:
			posture_max = float((cfg_value as CombatConfig).posture_max)
	target.call("add_posture_damage", posture_max)
	for _frame: int in range(18):
		await get_tree().physics_frame

	_expect(target.has_method("is_deathblow_ready") and bool(target.call("is_deathblow_ready")), "canonical posture break never armed the trial target for execution")
	if break_runtime != null and break_runtime.has_method("is_deathblow_armed"):
		_expect(bool(break_runtime.call("is_deathblow_armed")), "shared Hushiro readability beat never armed its deathblow state")

	var player_combat: Node = player.get_node_or_null("Combat")
	_expect(player_combat != null, "player has no CombatController")
	if player_combat != null and player_combat.has_method("get_deathblow_target"):
		_expect(player_combat.call("get_deathblow_target") == target, "posture break did not forward the executable target to Akio")

	# Move inside the existing FINISHER_RADIUS, then use the actual Player entrypoint.
	if player is Node2D and target is Node2D:
		(player as Node2D).global_position = (target as Node2D).global_position + Vector2(-40.0, 0.0)
	_expect(player.has_method("_try_deathblow"), "current Player runtime has no deathblow entrypoint")
	var executed: bool = bool(player.call("_try_deathblow")) if player.has_method("_try_deathblow") else false
	_expect(executed, "current Player deathblow entrypoint rejected an armed nearby trial target")

	# DeathblowSystem performs a short real-time hitstop/slash sequence before calling
	# target.receive_deathblow(). This timer processes while paused so the smoke observes
	# the same production execution path without hanging in the cinematic hitstop.
	await get_tree().create_timer(0.55, true, false, true).timeout
	await get_tree().process_frame
	await get_tree().process_frame

	var completed: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	var result_value: Variant = completed.get("last_trial_result", {})
	var result: Dictionary = result_value as Dictionary if result_value is Dictionary else {}
	_expect(str(completed.get("active_trial", "")) == "", "real Player execution did not end the Execution Trial")
	_expect(not bool(completed.get("training_active", true)), "trial target survived successful execution")
	_expect(bool(result.get("first_clear", false)), "real Player execution was not recorded as first clear")
	_expect(str(result.get("relic_id", "")) == EXPECTED_RELIC, "first clear did not use the current challenge Relic mapping")
	_expect(MetaProgress.has_completed_blood_cavern_trial(TRIAL_EXECUTION), "real Player execution did not persist trial completion")
	_expect(RelicRuntime.is_unlocked(EXPECTED_RELIC), "real Player execution did not unlock the first-clear Relic")

	var banner: Node = get_node_or_null("UILayer/BloodCavernTrialResult")
	_expect(banner != null, "successful Execution Trial did not create immediate completion feedback")
	if banner != null:
		var title: Label = banner.find_child("Title", true, false) as Label
		var detail: Label = banner.find_child("Detail", true, false) as Label
		_expect(title != null and title.text.contains("EXECUTION TRIAL COMPLETE"), "first-clear banner lost Execution Trial identity")
		_expect(detail != null and detail.text.contains(RELIC_CATALOG.get_display_name(EXPECTED_RELIC)), "first-clear banner did not name the unlocked Relic")

	# Re-run through the Cavern completion boundary to prove repeat clears remain
	# practice-only. The first path above already proves the actual Player/deathblow chain.
	cavern.call("_start_execution_trial")
	await get_tree().process_frame
	await get_tree().process_frame
	var repeat_targets: Array[Node] = get_tree().get_nodes_in_group("blood_cavern_training_target")
	_expect(repeat_targets.size() == 1, "repeat Execution Trial did not spawn exactly one target")
	if repeat_targets.size() == 1:
		repeat_targets[0].call("receive_deathblow", player)
		await get_tree().process_frame
		await get_tree().process_frame
		await get_tree().process_frame
		var repeat_snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
		var repeat_value: Variant = repeat_snapshot.get("last_trial_result", {})
		var repeat_result: Dictionary = repeat_value as Dictionary if repeat_value is Dictionary else {}
		_expect(not bool(repeat_result.get("first_clear", true)), "repeat clear incorrectly became another first clear")
		_expect(str(repeat_result.get("relic_id", "")) == "", "repeat clear attempted to grant a duplicate Relic")
		var repeat_banner: Node = get_node_or_null("UILayer/BloodCavernTrialResult")
		_expect(repeat_banner != null, "repeat clear did not produce practice feedback")
		if repeat_banner != null:
			var repeat_detail: Label = repeat_banner.find_child("Detail", true, false) as Label
			_expect(repeat_detail != null and repeat_detail.text.contains("Practice clear"), "repeat-clear banner does not communicate practice-only completion")

	_expect(int(RunData.gold) == gold_before if typeof(RunData) == TYPE_OBJECT else true, "Execution Trial changed run Gold")
	_expect(int(MetaProgress.mist) == mist_before, "Execution Trial changed persistent Mist")
	_expect(int(MetaProgress.scrolls) == scrolls_before, "Execution Trial changed persistent Scrolls")

	if cavern.has_method("_clear_trial_completion_banner"):
		cavern.call("_clear_trial_completion_banner")
	_restore_progression(original_completions, original_unlocked, original_mastery, original_equipped)
	hub.queue_free()
	await get_tree().process_frame
	get_tree().paused = false
	_finish()


func _restore_progression(completions: Dictionary, unlocked: Dictionary, mastery: Dictionary, equipped: String) -> void:
	MetaProgress.blood_cavern_trial_completions = completions
	MetaProgress.flush_save()
	RelicRuntime.unlocked_relics = unlocked
	RelicRuntime.mastery_kills = mastery
	RelicRuntime.equipped_relic_id = equipped
	if RelicRuntime.has_method("_save_progress"):
		RelicRuntime.call("_save_progress")


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_fail(message)


func _fail(message: String) -> void:
	_failed = true
	push_error("[BloodCavernExecutionTrialSmoke] FAIL - %s" % message)


func _finish() -> void:
	if _failed:
		get_tree().quit(1)
		return
	print("[BloodCavernExecutionTrialSmoke] PASS - shared Hushiro posture break | real Player deathblow | first-clear Relic | repeat practice | completion feedback | no currency leakage")
	get_tree().quit(0)
