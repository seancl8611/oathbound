extends "res://Utility/RunData.gd"

## Safe-boundary serialization for long-run resume. This deliberately captures only
## deterministic run state that is valid between chambers; it does not serialize
## arbitrary enemies, projectiles, tweens, or mid-attack scene state.


func get_checkpoint_state() -> Dictionary:
	return {
		"current_area_id": current_area_id,
		"depth": depth,
		"gold": gold,
		"requested_run_goal": requested_run_goal,
		"run_goal": run_goal,
		"run_completion_kind": run_completion_kind,
		"technique_rerolls": technique_rerolls,
		"path_history": path_history.duplicate(),
		"acquired_upgrades": acquired_upgrades.duplicate(true),
		"hushiro_encounters_seen": hushiro_encounters_seen.duplicate(),
		"yomori_encounters_seen": yomori_encounters_seen.duplicate(),
		"kagutsuchi_encounters_seen": kagutsuchi_encounters_seen.duplicate(),
		"enemies_killed": enemies_killed,
		"parries_performed": parries_performed,
		"perfect_parries": perfect_parries,
		"damage_taken": damage_taken,
		"combat_rooms_cleared": combat_rooms_cleared,
		"blessings_received": blessings_received,
		"treasures_opened": treasures_opened,
		"items_purchased": items_purchased,
	}


func restore_checkpoint_state(state: Dictionary) -> bool:
	if state.is_empty():
		return false
	current_area_id = clampi(int(state.get("current_area_id", 1)), 1, 3)
	depth = maxi(0, int(state.get("depth", 0)))
	gold = maxi(0, int(state.get("gold", 0)))
	requested_run_goal = str(state.get("requested_run_goal", ""))
	run_goal = str(state.get("run_goal", RUN_GOAL_CAMPAIGN))
	if run_goal not in VALID_RUN_GOALS:
		run_goal = RUN_GOAL_CAMPAIGN
	run_completion_kind = str(state.get("run_completion_kind", ""))
	technique_rerolls = maxi(0, int(state.get("technique_rerolls", 0)))

	path_history.assign(_string_array(state.get("path_history", [])))
	acquired_upgrades = (state.get("acquired_upgrades", []) as Array).duplicate(true) if state.get("acquired_upgrades", []) is Array else []
	hushiro_encounters_seen.assign(_string_array(state.get("hushiro_encounters_seen", [])))
	yomori_encounters_seen.assign(_string_array(state.get("yomori_encounters_seen", [])))
	kagutsuchi_encounters_seen.assign(_string_array(state.get("kagutsuchi_encounters_seen", [])))

	enemies_killed = maxi(0, int(state.get("enemies_killed", 0)))
	parries_performed = maxi(0, int(state.get("parries_performed", 0)))
	perfect_parries = maxi(0, int(state.get("perfect_parries", 0)))
	damage_taken = maxi(0, int(state.get("damage_taken", 0)))
	combat_rooms_cleared = maxi(0, int(state.get("combat_rooms_cleared", 0)))
	blessings_received = maxi(0, int(state.get("blessings_received", 0)))
	treasures_opened = maxi(0, int(state.get("treasures_opened", 0)))
	items_purchased = maxi(0, int(state.get("items_purchased", 0)))

	CurrencyManager.set_amount(CurrencyManager.Currency.GOLD, gold)
	sync_persistent_resources()
	print("[RunData] Safe checkpoint restored - Region %d | depth=%d | goal=%s | Gold=%d | Techniques=%d" % [
		current_area_id, depth, run_goal, gold, acquired_upgrades.size(),
	])
	return true


func _string_array(value: Variant) -> Array[String]:
	var out: Array[String] = []
	if value is Array:
		for item: Variant in value:
			out.append(str(item))
	return out
