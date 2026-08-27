extends Node

const SANDBOX = preload("res://Core/Trials/BloodCavernTrialLoadoutSandbox.gd")

var _failures: Array[String] = []


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var original := _capture_runtime_state()
	var prosthetic_save_path := str(ProstheticManager.call("_save_path"))
	var relic_save_path := str(RelicRuntime.call("_relic_save_path"))
	var prosthetic_file_before := _file_snapshot(prosthetic_save_path)
	var relic_file_before := _file_snapshot(relic_save_path)

	var sandbox := SANDBOX.new()
	var fixed_loadout := {
		"aspect_id": "wraith",
		"aspect_tier": 3,
		"blood": 41.0,
		"technique_ids": ["echo_lingering_cut", "crimson_blood_arc"],
		"prosthetic_id": "mirror_umbrella",
		"relic_id": "last_oath",
	}
	_expect(
		sandbox.begin(AspectRuntime, RunData, ProstheticManager, RelicRuntime, fixed_loadout),
		"sandbox should accept a valid fixed Aspect/Technique/Prosthetic/Relic loadout"
	)
	_expect(sandbox.is_active(), "sandbox should report active after begin")
	_expect(str(AspectRuntime.selected_aspect) == "wraith", "fixed Wraith Aspect should be staged")
	_expect(int(AspectRuntime.tier) == 3, "fixed Tier III should be staged")
	_expect(is_equal_approx(float(AspectRuntime.blood), 41.0), "fixed Blood value should be staged")
	_expect(RunData.acquired_upgrades == ["echo_lingering_cut", "crimson_blood_arc"], "fixed unlimited Technique collection should be staged exactly")
	_expect(str(ProstheticManager.equipped_prosthetic_id) == "mirror_umbrella", "fixed Prosthetic should be staged without requiring a permanent unlock")
	_expect(str(RelicRuntime.equipped_relic_id) == "last_oath", "fixed Relic should be staged without requiring a permanent unlock")
	_expect(bool(ProstheticManager.call("is_temporary_loadout_sandbox_active")), "Prosthetic persistence suppression should be active")
	_expect(bool(RelicRuntime.call("is_temporary_loadout_sandbox_active")), "Relic persistence suppression should be active")

	# Force normally durable paths while the fixed loadout is active. The slot files
	# must remain byte-for-byte unchanged, and practice kills must not accrue mastery.
	var mastery_before_forced_paths: Dictionary = RelicRuntime.mastery_kills.duplicate(true)
	ProstheticManager.flush_save()
	RelicRuntime.flush_save()
	RelicRuntime.record_eligible_kill()
	_expect(RelicRuntime.mastery_kills == mastery_before_forced_paths, "practice kills must not accrue permanent Relic mastery")
	_expect(_file_snapshot(prosthetic_save_path) == prosthetic_file_before, "temporary Prosthetic loadout must not write the persistent Forge slot file")
	_expect(_file_snapshot(relic_save_path) == relic_file_before, "temporary Relic loadout must not write the persistent Relic slot file")

	# Exercise a Relic-owned transient mutation so restoration proves more than the
	# equipped id. Last Oath should become used only inside this sandbox lifetime.
	var pre_trial_last_oath_used := bool(original.get("relic_last_oath_used", false))
	var survivor_hp := int(RelicRuntime.try_last_oath(10, 10))
	_expect(survivor_hp > 0, "temporarily equipped Last Oath should execute its runtime effect")
	_expect(bool(RelicRuntime.get("_last_oath_used")), "Last Oath transient state should mutate inside the trial")

	sandbox.restore()
	_expect(not sandbox.is_active(), "sandbox should be inactive after restore")
	_expect(not bool(ProstheticManager.call("is_temporary_loadout_sandbox_active")), "Prosthetic save suppression should end after restore")
	_expect(not bool(RelicRuntime.call("is_temporary_loadout_sandbox_active")), "Relic save suppression should end after restore")
	_expect(_capture_runtime_state() == original, "all fixed-loadout runtime state should restore exactly")
	_expect(bool(RelicRuntime.get("_last_oath_used")) == pre_trial_last_oath_used, "Relic transient state should restore exactly")
	_expect(_file_snapshot(prosthetic_save_path) == prosthetic_file_before, "Prosthetic slot file must remain unchanged after restore")
	_expect(_file_snapshot(relic_save_path) == relic_file_before, "Relic slot file must remain unchanged after restore")

	# Invalid content must fail closed before any state is captured or suppression starts.
	var invalid := SANDBOX.new()
	_expect(
		not invalid.begin(AspectRuntime, RunData, ProstheticManager, RelicRuntime, {"prosthetic_id": "not_a_real_tool"}),
		"unknown fixed equipment should be rejected"
	)
	_expect(_capture_runtime_state() == original, "rejected loadouts must leave runtime state untouched")

	if _failures.is_empty():
		print("[BloodCavernTrialLoadoutSandboxSmoke] PASS - fixed Aspect/Tier/Blood | unlimited Techniques | fixed Prosthetic | fixed Relic | save suppression | mastery suppression | exact restoration")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[BloodCavernTrialLoadoutSandboxSmoke] FAIL: %s" % failure)
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


func _file_snapshot(path: String) -> Dictionary:
	var exists := FileAccess.file_exists(path)
	var bytes := PackedByteArray()
	if exists:
		var file := FileAccess.open(path, FileAccess.READ)
		if file != null:
			bytes = file.get_buffer(file.get_length())
	return {"exists": exists, "bytes": bytes}


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures.append(message)
