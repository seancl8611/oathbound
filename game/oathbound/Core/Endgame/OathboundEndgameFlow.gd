extends RefCounted

## Canonical post-Shogun campaign routing authority.
##
## RUN_STRUCTURE.md, PROGRESSION.md, BOSS.md, TRUE_FINAL_HEART.md, and the approved
## postgame package define these outcomes. This service intentionally does not invent
## the true-final Heart moveset: it owns campaign routing, persistence, and the
## approved Shogun -> Heart recovery contract around that future encounter.

const OUTCOME_PRE_AWAKENED_HEART_CONTACT := "pre_awakened_heart_contact"
const OUTCOME_BINDING_COMPLETION := "binding_completion"
const OUTCOME_TRUE_FINAL_HEART := "true_final_heart"
const OUTCOME_STANDARD_EXPEDITION := "standard_expedition_complete"
const OUTCOME_HEART_SUPPRESSION := "heart_suppression"

const HEART_HEALTH_RECOVERY := 0.30
const HEART_SPIRIT_RECOVERY := 0.50
const HEART_HEALTH_FLOOR := 0.40
const HEART_SPIRIT_FLOOR := 0.60


static func determine_shogun_outcome(meta_progress: Node, run_data: Node) -> String:
	if meta_progress == null:
		return OUTCOME_BINDING_COMPLETION
	if not _bool_call(meta_progress, "is_returning_blood_awakened", true):
		return OUTCOME_PRE_AWAKENED_HEART_CONTACT
	if _bool_call(meta_progress, "is_story_complete", false):
		var goal := str(run_data.call("get_run_goal")) if run_data != null and run_data.has_method("get_run_goal") else "standard_expedition"
		if goal == "heart_suppression":
			return OUTCOME_HEART_SUPPRESSION
		return OUTCOME_STANDARD_EXPEDITION
	if _bool_call(meta_progress, "is_true_final_story_run_due", false):
		return OUTCOME_TRUE_FINAL_HEART
	return OUTCOME_BINDING_COMPLETION


static func requires_heart_entry_recovery(outcome: String) -> bool:
	return outcome in [OUTCOME_TRUE_FINAL_HEART, OUTCOME_HEART_SUPPRESSION]


static func apply_shogun_to_heart_recovery(player: Node) -> Dictionary:
	var result := {
		"health_before": 0,
		"health_after": 0,
		"health_max": 0,
		"spirit_before": 0,
		"spirit_after": 0,
		"spirit_max": 0,
	}
	if player == null or not is_instance_valid(player):
		return result

	if "maxhp" in player and "hp" in player:
		var health_max := maxi(1, int(player.get("maxhp")))
		var health_before := clampi(int(player.get("hp")), 0, health_max)
		var health_restore := roundi(float(health_max) * HEART_HEALTH_RECOVERY)
		var health_floor := ceili(float(health_max) * HEART_HEALTH_FLOOR)
		var health_after := mini(health_max, maxi(health_before + health_restore, health_floor))
		player.set("hp", health_after)
		if player.has_method("_update_health_bar"):
			player.call("_update_health_bar")
		result["health_before"] = health_before
		result["health_after"] = health_after
		result["health_max"] = health_max

	var executor: Node = null
	if "prosthetic_executor" in player:
		var executor_value: Variant = player.get("prosthetic_executor")
		if executor_value is Node and is_instance_valid(executor_value):
			executor = executor_value as Node
	if executor != null:
		var spirit_max := int(executor.call("get_max_spirit")) if executor.has_method("get_max_spirit") else int(executor.get("max_spirit"))
		var spirit_before := int(executor.call("get_spirit")) if executor.has_method("get_spirit") else int(executor.get("current_spirit"))
		spirit_max = maxi(1, spirit_max)
		spirit_before = clampi(spirit_before, 0, spirit_max)
		var spirit_restore := roundi(float(spirit_max) * HEART_SPIRIT_RECOVERY)
		var spirit_floor := ceili(float(spirit_max) * HEART_SPIRIT_FLOOR)
		var spirit_after := mini(spirit_max, maxi(spirit_before + spirit_restore, spirit_floor))
		if "current_spirit" in executor:
			executor.set("current_spirit", spirit_after)
		if executor.has_signal("spirit_changed"):
			executor.emit_signal("spirit_changed", spirit_after, spirit_max)
		var run_hud_value: Variant = player.get("run_hud") if "run_hud" in player else null
		if run_hud_value is Node and is_instance_valid(run_hud_value) and (run_hud_value as Node).has_method("update_spirit"):
			(run_hud_value as Node).call("update_spirit", spirit_after, spirit_max)
		result["spirit_before"] = spirit_before
		result["spirit_after"] = spirit_after
		result["spirit_max"] = spirit_max

	print("[EndgameFlow] Shogun -> Heart recovery health=%d/%d -> %d/%d spirit=%d/%d -> %d/%d" % [
		int(result["health_before"]), int(result["health_max"]), int(result["health_after"]), int(result["health_max"]),
		int(result["spirit_before"]), int(result["spirit_max"]), int(result["spirit_after"]), int(result["spirit_max"]),
	])
	return result


static func complete_binding(meta_progress: Node) -> bool:
	if meta_progress == null or not meta_progress.has_method("destroy_next_heart_binding"):
		return false
	return bool(meta_progress.call("destroy_next_heart_binding"))


static func complete_standard_expedition(meta_progress: Node) -> bool:
	if meta_progress == null or not meta_progress.has_method("record_standard_expedition_clear"):
		return false
	return bool(meta_progress.call("record_standard_expedition_clear"))


static func complete_heart_victory(meta_progress: Node, was_postgame_suppression: bool) -> bool:
	if meta_progress == null:
		return false
	if was_postgame_suppression:
		if meta_progress.has_method("record_heart_suppression_clear"):
			return bool(meta_progress.call("record_heart_suppression_clear"))
		return false
	if meta_progress.has_method("mark_story_complete"):
		return bool(meta_progress.call("mark_story_complete"))
	return false


static func _bool_call(target: Node, method_name: String, fallback: bool) -> bool:
	if target == null or not target.has_method(method_name):
		return fallback
	return bool(target.call(method_name))
