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
const ARM_WAIT_FRAMES := 18
const EXECUTION_SETTLE_SECONDS := 0.55

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

	var validation_scene: Node = get_tree().current_scene
	var hub: Node = HUB_SCENE.instantiate()
	add_child(hub)
	# Blood Cavern presentation correctly resolves the current live scene's UILayer.
	# This validation scene embeds HubScene instead of launching it directly, so point
	# SceneTree.current_scene at the Hub while exercising the real station UI boundary.
	get_tree().current_scene = hub
	await get_tree().process_frame
	await get_tree().process_frame

	var cavern: Node = hub.get_node_or_null("BloodCavern")
	var player: Node = get_tree().get_first_node_in_group("player")
	_expect(cavern != null, "live Hub has no Blood Cavern")
	_expect(player != null, "live Hub has no player actor")
	if cavern == null or player == null:
		_restore_progression(original_completions, original_unlocked, original_mastery, original_equipped)
		get_tree().current_scene = validation_scene
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
		get_tree().current_scene = validation_scene
		hub.queue_free()
		_finish()
		return

	var target: Node = targets[0]
	_expect(target.has_method("get_training_mode") and str(target.call("get_training_mode")) == TRIAL_EXECUTION, "target is not configured for Execution Trial mode")
	var target_label: Label = target.get_node_or_null("TrainingModeLabel") as Label
	_expect(target_label != null, "Execution Trial target has no in-world mode label")
	if target_label != null:
		_expect(target_label.text.contains("EXECUTION TRIAL"), "in-world target label lost Execution Trial identity")
		_expect(target_label.text.contains("BREAK POSTURE"), "in-world target label no longer communicates the posture objective")

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
	if combat != null and combat.has_method("get_posture"):
		_expect(float(combat.call("get_posture")) <= 0.001, "Health-only training reset left shared Posture behind")
	if break_runtime != null and break_runtime.has_method("is_break_active"):
		_expect(not bool(break_runtime.call("is_break_active")), "Health-only training reset left a Hushiro break active")
	if target_label != null:
		_expect(target_label.text.contains("EXECUTION TRIAL"), "training reset lost the active trial label")

	# Fill the canonical shared Posture meter instead of directly toggling a deathblow
	# flag. HushiroPostureBreakRuntime owns the 0.20 s readability beat and then forwards
	# the target to the current Player CombatController.
	var posture_max: float = _posture_max_for_target(combat)
	_add_shared_posture(combat, posture_max, "first break")
	await _wait_for_deathblow_arm()
	_expect_target_armed(target, break_runtime, player, "first break")

	# Reset once while the target is actually armed. This is the lifecycle seam that a
	# reusable training dummy must own: no stale shared break timer, ready marker, or
	# Player target may leak into the next attempt.
	target.call("death")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(str((cavern.call("_menu_snapshot_for_playtest") as Dictionary).get("active_trial", "")) == TRIAL_EXECUTION, "armed Health defeat completed the Execution Trial")
	if combat != null and combat.has_method("get_posture"):
		_expect(float(combat.call("get_posture")) <= 0.001, "armed training reset left shared Posture behind")
	if break_runtime != null and break_runtime.has_method("is_break_active"):
		_expect(not bool(break_runtime.call("is_break_active")), "armed training reset left Hushiro break state active")
	var player_combat: Node = player.get_node_or_null("Combat")
	if player_combat != null and player_combat.has_method("get_deathblow_target"):
		_expect(player_combat.call("get_deathblow_target") != target, "armed training reset left Akio targeting a stale execution target")

	# The same reusable target must be immediately breakable again after that reset.
	_add_shared_posture(combat, posture_max, "post-reset break")
	await _wait_for_deathblow_arm()
	_expect_target_armed(target, break_runtime, player, "post-reset break")

	# Move inside the existing FINISHER_RADIUS, then use the actual Player entrypoint.
	_move_player_into_finisher_range(player, target)
	_expect(player.has_method("_try_deathblow"), "current Player runtime has no deathblow entrypoint")
	var executed: bool = bool(player.call("_try_deathblow")) if player.has_method("_try_deathblow") else false
	_expect(executed, "current Player deathblow entrypoint rejected an armed nearby trial target")
	await _settle_execution()

	var completed: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	var result_value: Variant = completed.get("last_trial_result", {})
	var result: Dictionary = result_value as Dictionary if result_value is Dictionary else {}
	_expect(str(completed.get("active_trial", "")) == "", "real Player execution did not end the Execution Trial")
	_expect(not bool(completed.get("training_active", true)), "trial target survived successful execution")
	_expect(bool(result.get("first_clear", false)), "real Player execution was not recorded as first clear")
	_expect(str(result.get("relic_id", "")) == EXPECTED_RELIC, "first clear did not use the current challenge Relic mapping")
	_expect(MetaProgress.has_completed_blood_cavern_trial(TRIAL_EXECUTION), "real Player execution did not persist trial completion")
	_expect(RelicRuntime.is_unlocked(EXPECTED_RELIC), "real Player execution did not unlock the first-clear Relic")

	var banner: Node = hub.get_node_or_null("UILayer/BloodCavernTrialResult")
	_expect(banner != null, "successful Execution Trial did not create immediate completion feedback")
	if banner != null:
		var title: Label = banner.find_child("Title", true, false) as Label
		var detail: Label = banner.find_child("Detail", true, false) as Label
		_expect(title != null and title.text.contains("EXECUTION TRIAL COMPLETE"), "first-clear banner lost Execution Trial identity")
		_expect(detail != null and detail.text.contains(RELIC_CATALOG.get_display_name(EXPECTED_RELIC)), "first-clear banner did not name the unlocked Relic")

	# Repeat clears use the same production Posture/readability/Player execution chain.
	# Only persistence/reward semantics differ after the first clear.
	cavern.call("_start_execution_trial")
	await get_tree().process_frame
	await get_tree().process_frame
	var repeat_targets: Array[Node] = get_tree().get_nodes_in_group("blood_cavern_training_target")
	_expect(repeat_targets.size() == 1, "repeat Execution Trial did not spawn exactly one target")
	if repeat_targets.size() == 1:
		var repeat_target: Node = repeat_targets[0]
		var repeat_runtime: Node = repeat_target.get_node_or_null("HushiroPostureBreakRuntime")
		var repeat_combat: Node = repeat_target.get_node_or_null("Combat")
		var repeat_label: Label = repeat_target.get_node_or_null("TrainingModeLabel") as Label
		_expect(repeat_label != null and repeat_label.text.contains("EXECUTION TRIAL"), "repeat target lost in-world trial communication")
		_add_shared_posture(repeat_combat, _posture_max_for_target(repeat_combat), "repeat break")
		await _wait_for_deathblow_arm()
		_expect_target_armed(repeat_target, repeat_runtime, player, "repeat break")
		_move_player_into_finisher_range(player, repeat_target)
		var repeat_executed: bool = bool(player.call("_try_deathblow")) if player.has_method("_try_deathblow") else false
		_expect(repeat_executed, "repeat trial did not accept the real Player deathblow entrypoint")
		await _settle_execution()

		var repeat_snapshot: Dictionary = cavern.call("_menu_snapshot_for_playtest")
		var repeat_value: Variant = repeat_snapshot.get("last_trial_result", {})
		var repeat_result: Dictionary = repeat_value as Dictionary if repeat_value is Dictionary else {}
		_expect(not bool(repeat_result.get("first_clear", true)), "repeat clear incorrectly became another first clear")
		_expect(str(repeat_result.get("relic_id", "")) == "", "repeat clear attempted to grant a duplicate Relic")
		var repeat_banner: Node = hub.get_node_or_null("UILayer/BloodCavernTrialResult")
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
	get_tree().current_scene = validation_scene
	hub.queue_free()
	await get_tree().process_frame
	get_tree().paused = false
	_finish()


func _posture_max_for_target(combat: Node) -> float:
	if combat != null:
		var cfg_value: Variant = combat.get("config")
		if cfg_value is CombatConfig:
			return float((cfg_value as CombatConfig).posture_max)
	return 90.0


func _add_shared_posture(combat: Node, amount: float, context: String) -> void:
	_expect(combat != null and combat.has_method("add_posture"), "%s has no shared CombatController posture API" % context)
	if combat != null and combat.has_method("add_posture"):
		combat.call("add_posture", amount)


func _wait_for_deathblow_arm() -> void:
	for _frame: int in range(ARM_WAIT_FRAMES):
		await get_tree().physics_frame


func _expect_target_armed(target: Node, break_runtime: Node, player: Node, context: String) -> void:
	_expect(target.has_method("is_deathblow_ready") and bool(target.call("is_deathblow_ready")), "%s never armed the trial target for execution" % context)
	if break_runtime != null and break_runtime.has_method("is_deathblow_armed"):
		_expect(bool(break_runtime.call("is_deathblow_armed")), "%s never armed shared Hushiro deathblow state" % context)
	var player_combat: Node = player.get_node_or_null("Combat") if player != null else null
	_expect(player_combat != null, "player has no CombatController")
	if player_combat != null and player_combat.has_method("get_deathblow_target"):
		_expect(player_combat.call("get_deathblow_target") == target, "%s did not forward the executable target to Akio" % context)


func _move_player_into_finisher_range(player: Node, target: Node) -> void:
	if player is Node2D and target is Node2D:
		(player as Node2D).global_position = (target as Node2D).global_position + Vector2(-40.0, 0.0)


func _settle_execution() -> void:
	# DeathblowSystem performs a short real-time hitstop/slash sequence before calling
	# target.receive_deathblow(). Process while paused and ignore time scale so the
	# smoke observes the production execution path without hanging in cinematic hitstop.
	await get_tree().create_timer(EXECUTION_SETTLE_SECONDS, true, false, true).timeout
	await get_tree().process_frame
	await get_tree().process_frame


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
	print("[BloodCavernExecutionTrialSmoke] PASS - shared Hushiro posture break | reusable target reset | real Player deathblow | first-clear Relic | repeat practice | completion feedback | no currency leakage")
	get_tree().quit(0)
