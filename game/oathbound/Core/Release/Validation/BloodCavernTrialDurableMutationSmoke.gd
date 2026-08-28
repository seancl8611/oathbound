extends Node

const SANDBOX = preload("res://Core/Trials/BloodCavernTrialLoadoutSandbox.gd")

var _failures: Array[String] = []
var _prosthetic_unlocked_signals: int = 0
var _prosthetic_equipped_signals: int = 0
var _prosthetic_upgrade_signals: int = 0
var _relic_discovered_signals: int = 0
var _relic_collection_signals: int = 0
var _relic_equipped_signals: int = 0
var _persistent_resource_signals: int = 0


func _ready() -> void:
	call_deferred("_run")


func _run() -> void:
	var original := _capture_runtime_state()
	var original_scrolls := int(MetaProgress.scrolls)
	var original_boss_clears: Dictionary = MetaProgress.boss_clears.duplicate(true)
	var prosthetic_save_path := str(ProstheticManager.call("_save_path"))
	var relic_save_path := str(RelicRuntime.call("_relic_save_path"))
	var meta_save_path := str(MetaProgress.call("_save_path"))
	var prosthetic_file_before := _file_snapshot(prosthetic_save_path)
	var relic_file_before := _file_snapshot(relic_save_path)
	var meta_file_before := _file_snapshot(meta_save_path)

	var sandbox := SANDBOX.new()
	_expect(
		sandbox.begin(
			AspectRuntime,
			RunData,
			ProstheticManager,
			RelicRuntime,
			{"prosthetic_id": "mirror_umbrella", "relic_id": "last_oath"}
		),
		"durable-mutation fixture should enter a valid temporary equipment sandbox"
	)
	_expect(sandbox.is_active(), "durable-mutation fixture should report an active sandbox")

	# Force states that would make the production durable APIs succeed if their sandbox
	# guards were missing. All direct fixture mutations are covered by the sandbox's
	# pre-trial snapshot and are restored before this smoke exits.
	ProstheticManager.unlocked_prosthetics.erase("mirror_umbrella")
	ProstheticManager.unlocked_prosthetics["beast_whistle"] = true
	if ProstheticManager.purchased_upgrades.has("beast_whistle"):
		var beast_upgrades_value: Variant = ProstheticManager.purchased_upgrades["beast_whistle"]
		if beast_upgrades_value is Dictionary:
			(beast_upgrades_value as Dictionary).erase("reinforced_resonance")
	RelicRuntime.unlocked_relics.erase("iron_prayer_bead")
	RelicRuntime.mastery_kills.erase("iron_prayer_bead")

	# Direct assignment is intentionally non-durable. It gives the fixture enough
	# Scrolls that the unguarded Forge purchase path would spend currency and save the
	# MetaProgress file, making this a real persistence-boundary test rather than an
	# insufficient-funds rejection.
	var fixture_scrolls := maxi(10, original_scrolls)
	MetaProgress.scrolls = fixture_scrolls

	_connect_mutation_signal_probes()

	_expect(
		not ProstheticManager.unlock_prosthetic("mirror_umbrella"),
		"permanent Prosthetic unlock should be rejected during a temporary trial sandbox"
	)
	_expect(
		not ProstheticManager.unlocked_prosthetics.has("mirror_umbrella"),
		"rejected permanent Prosthetic unlock must leave the locked collection untouched"
	)
	_expect(
		not ProstheticManager.equip_prosthetic("beast_whistle"),
		"permanent Prosthetic equip should be rejected during a temporary trial sandbox"
	)
	_expect(
		str(ProstheticManager.equipped_prosthetic_id) == "mirror_umbrella",
		"rejected permanent Prosthetic equip must preserve the staged trial equipment"
	)
	ProstheticManager.unequip_prosthetic()
	_expect(
		str(ProstheticManager.equipped_prosthetic_id) == "mirror_umbrella",
		"permanent Prosthetic unequip should be ignored during a temporary trial sandbox"
	)
	_expect(
		not ProstheticManager.purchase_upgrade("beast_whistle", "reinforced_resonance"),
		"Forge upgrade purchase should be rejected before it can spend permanent Scrolls"
	)
	_expect(
		int(MetaProgress.scrolls) == fixture_scrolls,
		"rejected Forge upgrade must not spend permanent Scrolls"
	)
	_expect(
		not ProstheticManager.is_upgrade_purchased("beast_whistle", "reinforced_resonance"),
		"rejected Forge upgrade must not mutate purchased-upgrade state"
	)
	_expect(
		_file_snapshot(meta_save_path) == meta_file_before,
		"rejected Forge upgrade must not write MetaProgress persistence"
	)

	_expect(
		not RelicRuntime.discover_relic("iron_prayer_bead", false),
		"permanent Relic discovery should be rejected during a temporary trial sandbox"
	)
	_expect(
		not RelicRuntime.unlocked_relics.has("iron_prayer_bead"),
		"rejected Relic discovery must leave the permanent collection untouched"
	)
	_expect(
		not RelicRuntime.equip_relic("", "forge"),
		"permanent Relic unequip/equip mutation should be rejected during a temporary trial sandbox"
	)
	_expect(
		str(RelicRuntime.equipped_relic_id) == "last_oath",
		"rejected permanent Relic equip mutation must preserve the staged trial Relic"
	)

	# Campaign progression owns several automatic Forge unlocks and reaches the manager
	# through signals rather than the guarded public unlock API. Simulate a Twin Maws
	# clear in memory and emit the real progression signal. The manager must defer that
	# synchronization until the Blood Cavern restores its exact pre-trial snapshot.
	MetaProgress.boss_clears[2] = true
	MetaProgress.progression_changed.emit()
	_expect(
		bool(ProstheticManager.get("_campaign_sync_deferred_for_sandbox")),
		"campaign-to-Forge synchronization should be marked pending while the trial sandbox owns state"
	)
	_expect(
		not ProstheticManager.unlocked_prosthetics.has("mirror_umbrella"),
		"campaign progression must not mutate snapshot-owned Prosthetic unlocks before trial restoration"
	)
	_expect(
		_prosthetic_unlocked_signals == 0,
		"deferred campaign synchronization must not emit a permanent Prosthetic unlock signal during the trial"
	)
	_expect(
		_file_snapshot(prosthetic_save_path) == prosthetic_file_before,
		"deferred campaign synchronization must not write the Forge slot file during the trial"
	)

	_expect(_prosthetic_unlocked_signals == 0, "rejected Prosthetic unlock must not emit a durable unlock signal")
	_expect(_prosthetic_equipped_signals == 0, "rejected Prosthetic equip/unequip must not emit a durable equip signal")
	_expect(_prosthetic_upgrade_signals == 0, "rejected Prosthetic upgrade must not emit a purchase signal")
	_expect(_relic_discovered_signals == 0, "rejected Relic discovery must not emit a discovery signal")
	_expect(_relic_collection_signals == 0, "rejected Relic discovery must not emit a collection-change signal")
	_expect(_relic_equipped_signals == 0, "rejected permanent Relic equip must not emit an equip signal")
	_expect(_persistent_resource_signals == 0, "rejected Forge purchase must not emit a persistent-resource signal")
	_expect(_file_snapshot(prosthetic_save_path) == prosthetic_file_before, "durable Prosthetic API rejection must leave the Forge slot file unchanged")
	_expect(_file_snapshot(relic_save_path) == relic_file_before, "durable Relic API rejection must leave the Relic slot file unchanged")

	# Restore fixture-only MetaProgress values before the sandbox releases suppression.
	# The pending campaign sync must replay against the restored canonical campaign state,
	# not the temporary fixture state used to prove deferral.
	MetaProgress.scrolls = original_scrolls
	MetaProgress.boss_clears = original_boss_clears.duplicate(true)
	_disconnect_mutation_signal_probes()
	sandbox.restore()

	_expect(
		not bool(ProstheticManager.get("_campaign_sync_deferred_for_sandbox")),
		"pending campaign-to-Forge synchronization should be consumed when sandbox restoration releases ownership"
	)
	_expect(_capture_runtime_state() == original, "durable-mutation smoke should restore exact pre-trial Prosthetic/Relic state")
	_expect(int(MetaProgress.scrolls) == original_scrolls, "fixture should restore the original Scroll balance")
	_expect(MetaProgress.boss_clears == original_boss_clears, "fixture should restore the original campaign boss-clear state")
	_expect(not bool(ProstheticManager.call("is_temporary_loadout_sandbox_active")), "Prosthetic sandbox suppression should be fully released")
	_expect(not bool(RelicRuntime.call("is_temporary_loadout_sandbox_active")), "Relic sandbox suppression should be fully released")
	_expect(_file_snapshot(prosthetic_save_path) == prosthetic_file_before, "Forge slot file should remain byte-for-byte unchanged")
	_expect(_file_snapshot(relic_save_path) == relic_file_before, "Relic slot file should remain byte-for-byte unchanged")
	_expect(_file_snapshot(meta_save_path) == meta_file_before, "MetaProgress slot file should remain byte-for-byte unchanged")

	if _failures.is_empty():
		print("[BloodCavernTrialDurableMutationSmoke] PASS - durable Prosthetic/Relic APIs blocked | Scrolls preserved | no persistence writes | no durable signals | campaign Forge sync deferred | exact restoration")
		get_tree().quit(0)
		return
	for failure: String in _failures:
		push_error("[BloodCavernTrialDurableMutationSmoke] FAIL: %s" % failure)
	get_tree().quit(1)


func _capture_runtime_state() -> Dictionary:
	return {
		"prosthetic_id": str(ProstheticManager.equipped_prosthetic_id),
		"prosthetic_unlocks": ProstheticManager.unlocked_prosthetics.duplicate(true),
		"prosthetic_upgrades": ProstheticManager.purchased_upgrades.duplicate(true),
		"prosthetic_socketed_relics": ProstheticManager.socketed_relics.duplicate(true),
		"prosthetic_legacy_relics": ProstheticManager.unlocked_relics.duplicate(true),
		"relic_id": str(RelicRuntime.equipped_relic_id),
		"relic_unlocks": RelicRuntime.unlocked_relics.duplicate(true),
		"relic_mastery": RelicRuntime.mastery_kills.duplicate(true),
	}


func _connect_mutation_signal_probes() -> void:
	var callbacks := [
		[ProstheticManager, "prosthetic_unlocked", Callable(self, "_on_prosthetic_unlocked")],
		[ProstheticManager, "prosthetic_equipped", Callable(self, "_on_prosthetic_equipped")],
		[ProstheticManager, "upgrade_purchased", Callable(self, "_on_prosthetic_upgrade")],
		[RelicRuntime, "relic_discovered", Callable(self, "_on_relic_discovered")],
		[RelicRuntime, "collection_changed", Callable(self, "_on_relic_collection_changed")],
		[RelicRuntime, "equipped_changed", Callable(self, "_on_relic_equipped")],
		[MetaProgress, "persistent_resources_changed", Callable(self, "_on_persistent_resources_changed")],
	]
	for entry: Array in callbacks:
		var owner: Object = entry[0]
		var signal_name: String = str(entry[1])
		var callback: Callable = entry[2]
		if owner.has_signal(signal_name) and not owner.is_connected(signal_name, callback):
			owner.connect(signal_name, callback)


func _disconnect_mutation_signal_probes() -> void:
	var callbacks := [
		[ProstheticManager, "prosthetic_unlocked", Callable(self, "_on_prosthetic_unlocked")],
		[ProstheticManager, "prosthetic_equipped", Callable(self, "_on_prosthetic_equipped")],
		[ProstheticManager, "upgrade_purchased", Callable(self, "_on_prosthetic_upgrade")],
		[RelicRuntime, "relic_discovered", Callable(self, "_on_relic_discovered")],
		[RelicRuntime, "collection_changed", Callable(self, "_on_relic_collection_changed")],
		[RelicRuntime, "equipped_changed", Callable(self, "_on_relic_equipped")],
		[MetaProgress, "persistent_resources_changed", Callable(self, "_on_persistent_resources_changed")],
	]
	for entry: Array in callbacks:
		var owner: Object = entry[0]
		var signal_name: String = str(entry[1])
		var callback: Callable = entry[2]
		if owner.has_signal(signal_name) and owner.is_connected(signal_name, callback):
			owner.disconnect(signal_name, callback)


func _on_prosthetic_unlocked(_prosthetic_id: String) -> void:
	_prosthetic_unlocked_signals += 1


func _on_prosthetic_equipped(_prosthetic_id: String) -> void:
	_prosthetic_equipped_signals += 1


func _on_prosthetic_upgrade(_prosthetic_id: String, _upgrade_id: String) -> void:
	_prosthetic_upgrade_signals += 1


func _on_relic_discovered(_relic_id: String) -> void:
	_relic_discovered_signals += 1


func _on_relic_collection_changed() -> void:
	_relic_collection_signals += 1


func _on_relic_equipped(_relic_id: String) -> void:
	_relic_equipped_signals += 1


func _on_persistent_resources_changed() -> void:
	_persistent_resource_signals += 1


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
