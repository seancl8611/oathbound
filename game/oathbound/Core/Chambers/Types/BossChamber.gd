extends "res://Core/Chambers/Types/BossChamberController.gd"

## Canonical regional boss-chamber rules layer.
## The imported controller still selects/hosts regional boss scenes; this layer owns
## the approved persistent payouts, Boss Reward timing, transition recovery, and gate.

const BOSS_REWARD_SERVICE = preload("res://Core/Rewards/BossRewardService.gd")

var _reward_resolution_started := false


func _on_boss_defeated() -> void:
	if _gate_unlocked or _reward_resolution_started:
		return

	# A missing debug boss should not award progression for a fight that never occurred.
	if _boss == null:
		_unlock_boss_gate()
		return

	_reward_resolution_started = true
	var area_id := _get_current_area_id()
	_grant_persistent_boss_rewards(area_id)

	# Keeper and Twin Maws receive the documented three-card current-run Boss Reward,
	# then the safe-transition recovery. Eclipse Shogun's current Binding handoff does
	# not grant additional ordinary run power because first-six campaign clears end there.
	if area_id in [1, 2]:
		var reward_service := BOSS_REWARD_SERVICE.new()
		add_child(reward_service)
		await reward_service.present_after_boss(area_id)
		reward_service.queue_free()

	_unlock_boss_gate()


func _get_current_area_id() -> int:
	if has_meta("area_id"):
		return clampi(int(get_meta("area_id")), 1, 3)
	if typeof(RunData) == TYPE_OBJECT:
		return clampi(int(RunData.current_area_id), 1, 3)
	return 1


func _grant_persistent_boss_rewards(area_id: int) -> void:
	var mist_amount := 0
	var material_key := ""
	match area_id:
		1:
			mist_amount = 10
			material_key = MetaProgress.BOSS_MATERIAL_KEEPER
		2:
			mist_amount = 15
			material_key = MetaProgress.BOSS_MATERIAL_TWIN_MAWS
		3:
			mist_amount = 25
			material_key = MetaProgress.BOSS_MATERIAL_ECLIPSE_SHOGUN

	if mist_amount > 0:
		if typeof(RunData) == TYPE_OBJECT and RunData.has_method("add_mist"):
			RunData.add_mist(mist_amount)
		else:
			MetaProgress.add_mist(mist_amount)

	if not material_key.is_empty():
		MetaProgress.add_boss_material(material_key, 1)
	if MetaProgress.has_method("record_boss_defeat"):
		MetaProgress.record_boss_defeat(area_id)
	else:
		MetaProgress.mark_boss_clear(area_id)
	if typeof(RunData) == TYPE_OBJECT and RunData.has_method("sync_persistent_resources"):
		RunData.sync_persistent_resources()

	print("[BossChamber] Persistent boss payout: +%d Mist / +1 %s material | defeats=%d" % [
		mist_amount,
		material_key,
		MetaProgress.get_boss_defeat_count(area_id) if MetaProgress.has_method("get_boss_defeat_count") else 1,
	])


func _unlock_boss_gate() -> void:
	_gate_unlocked = true
	_reward_resolution_started = false
	if exit_gate and exit_gate.has_method("unlock"):
		exit_gate.call_deferred("unlock")
