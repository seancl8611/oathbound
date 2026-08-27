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

	# Reusing the same sandbox object must restore the first staged build before
	# replacing it, rather than nesting persistence-suppression depth or snapshotting
	# temporary state as the new baseline.
	var replacement := SANDBOX.new()
	_expect(
		replacement.begin(
			AspectRuntime,
			RunData,
			ProstheticManager,
			RelicRuntime,
			{"aspect_id": "wraith", "aspect_tier": 3, "blood": 28.0}
		),
		"replacement sandbox should accept the first staged Aspect state"
	)
	_expect(
		replacement.begin(
			AspectRuntime,
			RunData,
			ProstheticManager,
			RelicRuntime,
			{"aspect_id": "wolf", "aspect_tier": 1}
		),
		"active sandbox should support a clean replacement loadout"
	)
	_expect(str(AspectRuntime.selected_aspect) == "wolf", "replacement loadout should own the active Aspect")
	_expect(int(AspectRuntime.tier) == 1, "replacement loadout should own the active Tier")
	_expect(is_zero_approx(float(AspectRuntime.blood)), "Tier I replacement should normalize omitted Blood to zero")
	_expect(bool(ProstheticManager.call("is_temporary_loadout_sandbox_active")), "replacement should leave Prosthetic suppression at one active lifetime")
	_expect(bool(RelicRuntime.call("is_temporary_loadout_sandbox_active")), "replacement should leave Relic suppression at one active lifetime")
	replacement.restore()
	_expect(_capture_runtime_state() == original, "replacement sandbox should restore the original pre-trial build")
	_expect(not bool(ProstheticManager.call("is_temporary_loadout_sandbox_active")), "replacement restore should release Prosthetic suppression")
	_expect(not bool(RelicRuntime.call("is_temporary_loadout_sandbox_active")), "replacement restore should release Relic suppression")
	_expect(_file_snapshot(prosthetic_save_path) == prosthetic_file_before, "replacement sandbox must not change the Forge slot file")
	_expect(_file_snapshot(relic_save_path) == relic_file_before, "replacement sandbox must not change the Relic slot file")

	# Invalid authored content must fail closed before any state is captured or save
	# suppression starts. These Aspect combinations are impossible in the canonical
	# runtime and must never be silently converted into a different challenge build.
	_validate_rejected_loadout(
		{"prosthetic_id": "not_a_real_tool"},
		"unknown fixed equipment should be rejected",
		original
	)
	_validate_rejected_loadout(
		{"aspect_id": "", "aspect_tier": 3},
		"no-Aspect fixed loadout must reject a nonzero Tier",
		original
	)
	_validate_rejected_loadout(
		{"aspect_id": "wolf", "aspect_tier": 1, "blood": 10.0},
		"fixed Blood must be rejected before Tier II",
		original
	)
	_validate_rejected_loadout(
		{"aspect_id": "wraith", "aspect_tier": 3, "blood": 101.0},
		"out-of-range fixed Blood should be rejected rather than clamped",
		original
	)

	if _failures.is_empty():
		print("[BloodCavernTrialLoadoutSandboxSmoke] PASS - fixed Aspect/Tier/Blood | unlimited Techniques | fixed Prosthetic | fixed Relic | save suppression | mastery suppression | exact restoration | replacement lifecycle | Aspect invariants")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[BloodCavernTrialLoadoutSandboxSmoke] FAIL: %s" % failure)
	get_tree().quit(1)


func _validate_rejected_loadout(loadout: Dictionary, message: String, original: Dictionary) -> void:
	var invalid := SANDBOX.new()
	_expect(
		not invalid.begin(AspectRuntime, RunData, ProstheticManager, RelicRuntime, loadout),
		message
	)
	_expect(not invalid.is_active(), "%s; rejected sandbox must remain inactive" % message)
	_expect(_capture_runtime_state() == original, "%s; runtime state must remain untouched" % message)
	_expect(not bool(ProstheticManager.call("is_temporary_loadout_sandbox_active")), "%s; Prosthetic suppression must remain inactive" % message)
	_expect(not bool(RelicRuntime.call("is_temporary_loadout_sandbox_active")), "%s; Relic suppression must remain inactive" % message)


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
