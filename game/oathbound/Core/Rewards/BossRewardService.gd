extends Node

const BOSS_REWARD_UI = preload("res://Core/Rewards/BossRewardUI.gd")
const TECHNIQUE_REWARD_UI = preload("res://Core/Rewards/TechniqueRewardUI.gd")

const CURRENT_STARTING_MAX_HEALTH := 100
const CURRENT_STARTING_MAX_SPIRIT := 100

const HEALTH_CAPACITY_RATIO := 0.20
const SPIRIT_CAPACITY_RATIO := 0.25
const TRANSITION_HEALTH_RECOVERY := 0.20
const TRANSITION_SPIRIT_RECOVERY := 0.35
const TRANSITION_HEALTH_FLOOR := 0.35
const TRANSITION_SPIRIT_FLOOR := 0.50


func present_after_boss(area_id: int) -> void:
	if area_id not in [1, 2]:
		return

	var capacity_type := "health" if randf() < 0.5 else "spirit"
	var choices := _build_boss_reward_choices(capacity_type)

	var ui := BOSS_REWARD_UI.new()
	get_tree().current_scene.add_child(ui)
	var picked: Dictionary = await ui.present(choices)
	ui.queue_free()

	await _apply_boss_reward(picked, area_id)
	_apply_regional_transition_recovery()


func _build_boss_reward_choices(capacity_type: String) -> Array:
	var opposite := "spirit" if capacity_type == "health" else "health"
	return [
		{
			"kind": "technique",
			"displayname": "Premium Technique",
			"details": "Open a premium three-choice Technique reward.",
		},
		_make_capacity_card(capacity_type),
		_make_flex_card(opposite),
	]


func _make_capacity_card(capacity_type: String) -> Dictionary:
	if capacity_type == "health":
		return {
			"kind": "capacity_health",
			"displayname": "Enhanced Health Capacity",
			"details": "+20% of starting max Health to maximum and current Health.",
		}
	return {
		"kind": "capacity_spirit",
		"displayname": "Enhanced Spirit Capacity",
		"details": "+25% of starting max Spirit to maximum and current Spirit.",
	}


func _make_flex_card(opposite_capacity: String) -> Dictionary:
	var roll := randf()
	if roll < 0.50:
		return {
			"kind": "technique",
			"displayname": "Second Premium Technique",
			"details": "Open another premium three-choice Technique reward.",
		}
	if roll < 0.785714:
		return _make_capacity_card(opposite_capacity)
	return {
		"kind": "rerolls",
		"displayname": "Technique Rerolls",
		"details": "+2 Technique reroll resources for this run.",
	}


func _apply_boss_reward(choice: Dictionary, area_id: int) -> void:
	match str(choice.get("kind", "")):
		"technique":
			await _present_premium_technique(area_id)
		"capacity_health":
			_apply_health_capacity()
		"capacity_spirit":
			_apply_spirit_capacity()
		"rerolls":
			RunData.add_technique_rerolls(2)


func _present_premium_technique(area_id: int) -> void:
	var ui := TECHNIQUE_REWARD_UI.new()
	ui.layer = 115
	ui.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().current_scene.add_child(ui)
	var source := UpgradeService.SOURCE_REGIONAL_BOSS
	var choices := UpgradeService.get_three_choices_for_source(source, area_id)
	ui.open_with_context(choices, source, area_id)
	var picked: Dictionary = await ui.choice_made
	UpgradeService.apply_upgrade(picked)
	ui.queue_free()


func _apply_health_capacity() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null or not ("maxhp" in player) or not ("hp" in player):
		return
	var starting_max := int(player.get_meta("run_start_max_health", CURRENT_STARTING_MAX_HEALTH))
	player.set_meta("run_start_max_health", starting_max)
	var increase := maxi(1, roundi(float(starting_max) * HEALTH_CAPACITY_RATIO))
	player.maxhp += increase
	player.hp = mini(player.maxhp, player.hp + increase)
	if player.has_method("_update_health_bar"):
		player._update_health_bar()
	print("[BossReward] Enhanced Health Capacity +%d" % increase)


func _apply_spirit_capacity() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null or not ("prosthetic_executor" in player) or player.prosthetic_executor == null:
		return
	var executor = player.prosthetic_executor
	if not ("max_spirit" in executor) or not ("current_spirit" in executor):
		return
	var starting_max := int(player.get_meta("run_start_max_spirit", CURRENT_STARTING_MAX_SPIRIT))
	player.set_meta("run_start_max_spirit", starting_max)
	var increase := maxi(1, roundi(float(starting_max) * SPIRIT_CAPACITY_RATIO))
	executor.max_spirit += increase
	executor.current_spirit = mini(executor.max_spirit, executor.current_spirit + increase)
	if executor.has_signal("spirit_changed"):
		executor.emit_signal("spirit_changed", executor.current_spirit, executor.max_spirit)
	print("[BossReward] Enhanced Spirit Capacity +%d" % increase)


func _apply_regional_transition_recovery() -> void:
	var player := get_tree().get_first_node_in_group("player")
	if player == null:
		return

	if "maxhp" in player and "hp" in player:
		var health_restore := roundi(float(player.maxhp) * TRANSITION_HEALTH_RECOVERY)
		var health_floor := ceili(float(player.maxhp) * TRANSITION_HEALTH_FLOOR)
		player.hp = mini(player.maxhp, maxi(player.hp + health_restore, health_floor))
		if player.has_method("_update_health_bar"):
			player._update_health_bar()

	if "prosthetic_executor" in player and player.prosthetic_executor != null:
		var executor = player.prosthetic_executor
		if "max_spirit" in executor and "current_spirit" in executor:
			var spirit_restore := roundi(float(executor.max_spirit) * TRANSITION_SPIRIT_RECOVERY)
			var spirit_floor := ceili(float(executor.max_spirit) * TRANSITION_SPIRIT_FLOOR)
			executor.current_spirit = mini(executor.max_spirit, maxi(executor.current_spirit + spirit_restore, spirit_floor))
			if executor.has_signal("spirit_changed"):
				executor.emit_signal("spirit_changed", executor.current_spirit, executor.max_spirit)

	print("[BossReward] Regional transition recovery applied")
