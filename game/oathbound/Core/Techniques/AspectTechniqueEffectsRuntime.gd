extends "res://Core/Techniques/TechniqueEffectsRuntime.gd"

## Adapts Blood Aspect attack IDs to the universal Technique action-trigger contract.
## Technique families care about Basic/Held/Dash/Counter, not the selected weapon kit's
## move name. Blood Arts and Wraith secondary passage contacts deliberately do not
## receive ordinary full Technique triggers.

func on_player_hit(target: Node, player: Node, attack_area: Area2D = null) -> void:
	if attack_area == null:
		super.on_player_hit(target, player, attack_area)
		return

	var trigger: String = str(attack_area.get_meta("action_trigger", ""))
	if trigger == "blood_art":
		return
	if typeof(AspectRuntime) == TYPE_OBJECT and AspectRuntime.has_method("is_secondary_passage_contact"):
		if AspectRuntime.is_secondary_passage_contact(attack_area, target):
			# The Wraith authority explicitly forbids unrestricted full-value Technique
			# multiplication on passage contacts. First-playtest policy is zero ordinary
			# Technique proc rather than silently over-rewarding the secondary target.
			return

	if trigger.is_empty():
		super.on_player_hit(target, player, attack_area)
		return

	var original_id: String = str(attack_area.get_meta("attack_id", ""))
	var universal_id: String = _universal_attack_id(trigger)
	if universal_id.is_empty():
		super.on_player_hit(target, player, attack_area)
		return

	attack_area.set_meta("attack_id", universal_id)
	super.on_player_hit(target, player, attack_area)
	attack_area.set_meta("attack_id", original_id)

func _universal_attack_id(trigger: String) -> String:
	match trigger:
		"basic":
			return "quick_slash"
		"held":
			return "hold_thrust"
		"dash":
			return "dash_slash"
		"counter":
			return "counter_cut"
	return ""
