extends Node

const HUB_SCENE = preload("res://World/HubScene.tscn")

var _failures: Array[String] = []


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	call_deferred("_run")


func _run() -> void:
	var validation_scene: Node = get_tree().current_scene
	var hub: Node = HUB_SCENE.instantiate()
	get_tree().root.add_child(hub)
	get_tree().current_scene = hub
	await get_tree().process_frame
	await get_tree().process_frame

	var cavern: Node = hub.get_node_or_null("BloodCavern")
	_expect(cavern != null, "live Hub has no Blood Cavern")
	if cavern == null:
		await _finish(validation_scene, hub)
		return

	var original := _capture_runtime_state()
	cavern.call("_start_execution_trial")
	await get_tree().process_frame
	var started: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	_expect(bool(started.get("trial_loadout_sandbox_active", false)), "Execution Trial did not establish its temporary loadout lifetime")

	var fixed_loadout := {
		"aspect_id": "ronin",
		"aspect_tier": 4,
		"blood": 88.0,
		"technique_ids": ["rupture_mountain_breaker", "seal_counterseal", "crimson_deep_cut"],
		"prosthetic_id": "fang_harpoon",
		"relic_id": "spirit_tassel",
	}
	_expect(
		bool(cavern.call("_stage_fixed_trial_loadout_for_playtest", fixed_loadout)),
		"active Blood Cavern trial rejected a valid fixed loadout"
	)
	_expect(str(AspectRuntime.selected_aspect) == "ronin" and int(AspectRuntime.tier) == 4, "active trial did not stage fixed Ronin Tier IV")
	_expect(is_equal_approx(float(AspectRuntime.blood), 88.0), "active trial did not stage fixed Blood")
	_expect(RunData.acquired_upgrades == ["rupture_mountain_breaker", "seal_counterseal", "crimson_deep_cut"], "active trial did not stage exact unlimited Technique collection")
	_expect(str(ProstheticManager.equipped_prosthetic_id) == "fang_harpoon", "active trial did not stage fixed Prosthetic")
	_expect(str(RelicRuntime.equipped_relic_id) == "spirit_tassel", "active trial did not stage fixed Relic")

	cavern.call("_end_training")
	await get_tree().process_frame
	_expect(_capture_runtime_state() == original, "End Training did not restore the exact pre-trial build")
	var ended: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	_expect(not bool(ended.get("trial_loadout_sandbox_active", true)), "End Training left trial sandbox active")
	_expect(not bool(ended.get("training_active", true)), "End Training left a training target active")

	# Blood Mirror entry is another approved hard boundary. Cleanup must happen before
	# the Mirror checks its Keeper gate or opens permanent progression UI.
	cavern.call("_start_execution_trial")
	await get_tree().process_frame
	_expect(
		bool(cavern.call("_stage_fixed_trial_loadout_for_playtest", {
			"aspect_id": "wolf",
			"aspect_tier": 2,
			"blood": 64.0,
			"technique_ids": ["crimson_open_wound", "rupture_guardbreaker"],
			"prosthetic_id": "flame_vent",
			"relic_id": "execution_bead",
		})),
		"Blood Mirror cleanup fixture rejected a valid fixed loadout"
	)
	cavern.call("_open_blood_mirror")
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(_capture_runtime_state() == original, "Blood Mirror entry did not restore the exact pre-trial build")
	var mirror_cleanup: Dictionary = cavern.call("_menu_snapshot_for_playtest")
	_expect(not bool(mirror_cleanup.get("trial_loadout_sandbox_active", true)), "Blood Mirror entry left trial sandbox active")
	_expect(not bool(mirror_cleanup.get("training_active", true)), "Blood Mirror entry left a training target active")

	# Repeat with a different staged build and remove the whole Hub. _exit_tree must be
	# a final safety net even if normal End Training / Blood Mirror cleanup is skipped.
	cavern.call("_start_execution_trial")
	await get_tree().process_frame
	_expect(
		bool(cavern.call("_stage_fixed_trial_loadout_for_playtest", {
			"aspect_id": "wraith",
			"aspect_tier": 3,
			"blood": 25.0,
			"technique_ids": ["echo_second_draw"],
			"prosthetic_id": "mist_raven",
			"relic_id": "last_oath",
		})),
		"teardown fixture rejected a valid fixed loadout"
	)
	get_tree().current_scene = validation_scene
	hub.queue_free()
	await get_tree().process_frame
	await get_tree().process_frame
	_expect(_capture_runtime_state() == original, "Blood Cavern teardown did not restore the exact pre-trial build")

	if _failures.is_empty():
		print("[BloodCavernTrialLoadoutLifecycleSmoke] PASS - real Hub ownership | active fixed loadout | End Training restore | Blood Mirror restore | Cavern teardown restore")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[BloodCavernTrialLoadoutLifecycleSmoke] FAIL: %s" % failure)
	get_tree().quit(1)


func _finish(validation_scene: Node, hub: Node) -> void:
	get_tree().current_scene = validation_scene
	if hub != null and is_instance_valid(hub):
		hub.queue_free()
	await get_tree().process_frame
	for failure: String in _failures:
		push_error("[BloodCavernTrialLoadoutLifecycleSmoke] FAIL: %s" % failure)
	get_tree().quit(1)


func _capture_runtime_state() -> Dictionary:
	return {
		"aspect_id": str(AspectRuntime.selected_aspect),
		"aspect_tier": int(AspectRuntime.tier),
		"blood": float(AspectRuntime.blood),
		"blood_art_resolving": bool(AspectRuntime.blood_art_resolving),
		"technique_ids": RunData.acquired_upgrades.duplicate(true),
		"prosthetic_id": str(ProstheticManager.equipped_prosthetic_id),
		"prosthetic_unlocks": ProstheticManager.unlocked_prosthetics.duplicate(true),
		"prosthetic_upgrades": ProstheticManager.purchased_upgrades.duplicate(true),
		"prosthetic_socketed_relics": ProstheticManager.socketed_relics.duplicate(true),
		"prosthetic_legacy_relics": ProstheticManager.unlocked_relics.duplicate(true),
		"relic_id": str(RelicRuntime.equipped_relic_id),
		"relic_unlocks": RelicRuntime.unlocked_relics.duplicate(true),
		"relic_mastery": RelicRuntime.mastery_kills.duplicate(true),
		"relic_last_oath_used": bool(RelicRuntime.get("_last_oath_used")),
		"relic_merchant_discount": (RelicRuntime.get("_merchant_discount_used_by_area") as Dictionary).duplicate(true),
		"relic_scribe_uses": (RelicRuntime.get("_scribe_uses_by_area") as Dictionary).duplicate(true),
		"relic_room_health_damage": bool(RelicRuntime.get("_room_health_damage_taken")),
	}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
