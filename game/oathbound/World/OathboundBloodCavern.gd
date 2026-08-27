extends "res://World/BloodCavern.gd"

## Release/runtime ownership layer for Blood Cavern trial loadouts.
##
## The base Cavern continues to own menus, targets, tutorial refreshers, Technique demos,
## challenge completion, and Blood Mirror routing. This layer owns the approved fixed
## trial-loadout lifetime boundary so authored trials can stage deterministic
## Aspect/Technique/Prosthetic/Relic state without leaking it into run or save state.

const TRIAL_LOADOUT_SANDBOX = preload("res://Core/Trials/BloodCavernTrialLoadoutSandbox.gd")

var _trial_loadout_sandbox: BloodCavernTrialLoadoutSandbox = null


func _start_execution_trial() -> void:
	# The first authored Basic trial intentionally has no final fixed loadout yet. It
	# still enters the same sandbox lifetime boundary future fixed trials use, proving
	# completion/cancel/Mirror/teardown cleanup without inventing content sequencing.
	super._start_execution_trial()
	if _active_trial_id != TRIAL_EXECUTION or not _has_training_target():
		return
	if not _begin_trial_loadout_for_playtest({}):
		push_error("[OathboundBloodCavern] Could not establish Execution Trial loadout sandbox")
		_stop_training_state()


func _complete_trial(trial_id: String) -> void:
	# Restore temporary build state before the permanent first-clear reward path runs.
	# Otherwise restoring the snapshot after completion could erase the Relic unlock
	# that the challenge legitimately grants.
	if _active_trial_id == trial_id:
		_restore_trial_loadout_for_playtest()
	super._complete_trial(trial_id)


func _stop_training_state() -> bool:
	var had_trial_sandbox := _restore_trial_loadout_for_playtest()
	var was_active := super._stop_training_state()
	if had_trial_sandbox and not was_active:
		training_ended.emit()
	return was_active or had_trial_sandbox


func _begin_trial_loadout_for_playtest(loadout: Dictionary) -> bool:
	_restore_trial_loadout_for_playtest()
	var sandbox := TRIAL_LOADOUT_SANDBOX.new()
	if not sandbox.begin(AspectRuntime, RunData, ProstheticManager, RelicRuntime, loadout):
		return false
	_trial_loadout_sandbox = sandbox
	return true


func _stage_fixed_trial_loadout_for_playtest(loadout: Dictionary) -> bool:
	# Reusable seam for later authored Basic/Aspect/mastery trials. A fixed loadout may
	# only be staged while a real trial target is active; previewing a trial in the menu
	# never mutates runtime equipment.
	if _active_trial_id.is_empty() or not _has_training_target():
		return false
	return _begin_trial_loadout_for_playtest(loadout)


func _restore_trial_loadout_for_playtest() -> bool:
	if _trial_loadout_sandbox == null:
		return false
	var had_sandbox := _trial_loadout_sandbox.is_active()
	_trial_loadout_sandbox.restore()
	_trial_loadout_sandbox = null
	return had_sandbox


func _menu_snapshot_for_playtest() -> Dictionary:
	var out: Dictionary = super._menu_snapshot_for_playtest()
	out["trial_loadout_sandbox_active"] = (
		_trial_loadout_sandbox != null and _trial_loadout_sandbox.is_active()
	)
	return out


func _exit_tree() -> void:
	_restore_trial_loadout_for_playtest()
	super._exit_tree()
