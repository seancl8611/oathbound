extends RefCounted
class_name BloodCavernTrialLoadoutSandbox

## Runtime-only fixed-loadout sandbox for Blood Cavern trials.
##
## Trials may stage deterministic Aspect/Tier/Blood, Technique, Prosthetic, and Relic
## state without granting unlocks or writing the staged equipment into the active save
## slot. The exact pre-trial state is deep-snapshotted and restored when the sandbox
## ends. Final authored trial identities/loadouts remain data/content work.

const ASPECT_CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const TECHNIQUE_CATALOG = preload("res://Core/Techniques/TechniqueCatalog.gd")
const RELIC_CATALOG = preload("res://Core/Relics/RelicCatalog.gd")

var _active: bool = false
var _aspect_runtime: Node = null
var _run_data: Node = null
var _prosthetic_manager: Node = null
var _relic_runtime: Node = null
var _snapshot: Dictionary = {}


func is_active() -> bool:
	return _active


func begin(
		aspect_runtime: Node,
		run_data: Node,
		prosthetic_manager: Node,
		relic_runtime: Node,
		loadout: Dictionary
	) -> bool:
	if _active:
		restore()
	if not _runtime_contract_is_valid(aspect_runtime, run_data, prosthetic_manager, relic_runtime):
		return false
	var normalized := _validate_loadout(loadout, prosthetic_manager)
	if normalized.has("error"):
		push_warning("[BloodCavernTrialLoadoutSandbox] %s" % str(normalized.get("error", "Invalid trial loadout")))
		return false

	_aspect_runtime = aspect_runtime
	_run_data = run_data
	_prosthetic_manager = prosthetic_manager
	_relic_runtime = relic_runtime
	_snapshot = _capture_snapshot()

	_prosthetic_manager.call("begin_temporary_loadout_sandbox")
	_relic_runtime.call("begin_temporary_loadout_sandbox")
	_active = true
	if not _apply_loadout(normalized):
		restore()
		return false
	return true


func restore() -> void:
	if not _active:
		_clear_refs()
		return

	_restore_aspect_state()
	if _run_data != null and is_instance_valid(_run_data):
		_run_data.set("acquired_upgrades", (_snapshot.get("technique_ids", []) as Array).duplicate(true))

	if _prosthetic_manager != null and is_instance_valid(_prosthetic_manager):
		_prosthetic_manager.set("unlocked_prosthetics", (_snapshot.get("prosthetic_unlocks", {}) as Dictionary).duplicate(true))
		_prosthetic_manager.set("purchased_upgrades", (_snapshot.get("prosthetic_upgrades", {}) as Dictionary).duplicate(true))
		_prosthetic_manager.set("socketed_relics", (_snapshot.get("prosthetic_socketed_relics", {}) as Dictionary).duplicate(true))
		_prosthetic_manager.set("unlocked_relics", (_snapshot.get("prosthetic_legacy_relics", {}) as Dictionary).duplicate(true))
		_prosthetic_manager.call("set_temporary_equipped_prosthetic", str(_snapshot.get("prosthetic_id", "")))

	if _relic_runtime != null and is_instance_valid(_relic_runtime):
		_relic_runtime.set("unlocked_relics", (_snapshot.get("relic_unlocks", {}) as Dictionary).duplicate(true))
		_relic_runtime.set("mastery_kills", (_snapshot.get("relic_mastery", {}) as Dictionary).duplicate(true))
		_restore_relic_transient_state()
		_relic_runtime.call("set_temporary_equipped_relic", str(_snapshot.get("relic_id", "")))
		if _relic_runtime.has_signal("collection_changed"):
			_relic_runtime.emit_signal("collection_changed")

	# End save suppression only after every durable/runtime field is back to its exact
	# pre-trial value. The persistent files already contain the original state and do
	# not need a write during restoration.
	if _prosthetic_manager != null and is_instance_valid(_prosthetic_manager):
		_prosthetic_manager.call("end_temporary_loadout_sandbox")
	if _relic_runtime != null and is_instance_valid(_relic_runtime):
		_relic_runtime.call("end_temporary_loadout_sandbox")

	_clear_refs()


func _runtime_contract_is_valid(
		aspect_runtime: Node,
		run_data: Node,
		prosthetic_manager: Node,
		relic_runtime: Node
	) -> bool:
	if aspect_runtime == null or not is_instance_valid(aspect_runtime):
		push_warning("[BloodCavernTrialLoadoutSandbox] AspectRuntime unavailable")
		return false
	if run_data == null or not is_instance_valid(run_data):
		push_warning("[BloodCavernTrialLoadoutSandbox] RunData unavailable")
		return false
	if prosthetic_manager == null or not is_instance_valid(prosthetic_manager):
		push_warning("[BloodCavernTrialLoadoutSandbox] ProstheticManager unavailable")
		return false
	if relic_runtime == null or not is_instance_valid(relic_runtime):
		push_warning("[BloodCavernTrialLoadoutSandbox] RelicRuntime unavailable")
		return false
	for method_name: String in [
		"begin_temporary_loadout_sandbox",
		"end_temporary_loadout_sandbox",
		"set_temporary_equipped_prosthetic",
	]:
		if not prosthetic_manager.has_method(method_name):
			push_warning("[BloodCavernTrialLoadoutSandbox] ProstheticManager missing %s" % method_name)
			return false
	for method_name: String in [
		"begin_temporary_loadout_sandbox",
		"end_temporary_loadout_sandbox",
		"set_temporary_equipped_relic",
	]:
		if not relic_runtime.has_method(method_name):
			push_warning("[BloodCavernTrialLoadoutSandbox] RelicRuntime missing %s" % method_name)
			return false
	return true


func _validate_loadout(loadout: Dictionary, prosthetic_manager: Node) -> Dictionary:
	var out := loadout.duplicate(true)
	if out.has("aspect_id"):
		var aspect_id := str(out.get("aspect_id", "")).to_lower()
		if not aspect_id.is_empty() and aspect_id not in ASPECT_CATALOG.ASPECTS:
			return {"error": "Unknown fixed Aspect: %s" % aspect_id}
		out["aspect_id"] = aspect_id
	if out.has("aspect_tier"):
		var tier := int(out.get("aspect_tier", 0))
		if tier < 0 or tier > 4:
			return {"error": "Fixed Aspect Tier must be 0-IV"}
		out["aspect_tier"] = tier
	if out.has("blood"):
		out["blood"] = clampf(float(out.get("blood", 0.0)), 0.0, 100.0)

	if out.has("technique_ids"):
		var technique_value: Variant = out.get("technique_ids")
		if not (technique_value is Array):
			return {"error": "Fixed Technique loadout must be an Array"}
		var technique_ids: Array = []
		for value: Variant in technique_value as Array:
			var technique_id := str(value)
			if TECHNIQUE_CATALOG.get_entry(technique_id).is_empty():
				return {"error": "Unknown fixed Technique: %s" % technique_id}
			if technique_id not in technique_ids:
				technique_ids.append(technique_id)
		out["technique_ids"] = technique_ids

	if out.has("prosthetic_id"):
		var prosthetic_id := str(out.get("prosthetic_id", ""))
		if not prosthetic_id.is_empty() and prosthetic_manager.call("get_prosthetic", prosthetic_id) == null:
			return {"error": "Unknown fixed Prosthetic: %s" % prosthetic_id}
		out["prosthetic_id"] = prosthetic_id

	if out.has("relic_id"):
		var relic_id := str(out.get("relic_id", ""))
		if not relic_id.is_empty() and not RELIC_CATALOG.has(relic_id):
			return {"error": "Unknown fixed Relic: %s" % relic_id}
		out["relic_id"] = relic_id
	return out


func _capture_snapshot() -> Dictionary:
	return {
		"aspect_id": str(_aspect_runtime.get("selected_aspect")),
		"aspect_tier": int(_aspect_runtime.get("tier")),
		"blood": float(_aspect_runtime.get("blood")),
		"blood_art_resolving": bool(_aspect_runtime.get("blood_art_resolving")),
		"technique_ids": (_run_data.get("acquired_upgrades") as Array).duplicate(true),
		"prosthetic_id": str(_prosthetic_manager.get("equipped_prosthetic_id")),
		"prosthetic_unlocks": (_prosthetic_manager.get("unlocked_prosthetics") as Dictionary).duplicate(true),
		"prosthetic_upgrades": (_prosthetic_manager.get("purchased_upgrades") as Dictionary).duplicate(true),
		"prosthetic_socketed_relics": (_prosthetic_manager.get("socketed_relics") as Dictionary).duplicate(true),
		"prosthetic_legacy_relics": (_prosthetic_manager.get("unlocked_relics") as Dictionary).duplicate(true),
		"relic_id": str(_relic_runtime.get("equipped_relic_id")),
		"relic_unlocks": (_relic_runtime.get("unlocked_relics") as Dictionary).duplicate(true),
		"relic_mastery": (_relic_runtime.get("mastery_kills") as Dictionary).duplicate(true),
		"relic_last_oath_used": bool(_relic_runtime.get("_last_oath_used")),
		"relic_merchant_discount": (_relic_runtime.get("_merchant_discount_used_by_area") as Dictionary).duplicate(true),
		"relic_scribe_uses": (_relic_runtime.get("_scribe_uses_by_area") as Dictionary).duplicate(true),
		"relic_room_health_damage": bool(_relic_runtime.get("_room_health_damage_taken")),
	}


func _apply_loadout(loadout: Dictionary) -> bool:
	if loadout.has("aspect_id") or loadout.has("aspect_tier") or loadout.has("blood"):
		var aspect_id := str(loadout.get("aspect_id", _aspect_runtime.get("selected_aspect")))
		var tier := int(loadout.get("aspect_tier", _aspect_runtime.get("tier")))
		var blood := float(loadout.get("blood", _aspect_runtime.get("blood")))
		_apply_aspect_state(aspect_id, tier, blood, false)

	if loadout.has("technique_ids"):
		_run_data.set("acquired_upgrades", (loadout.get("technique_ids", []) as Array).duplicate(true))

	if loadout.has("prosthetic_id"):
		if not bool(_prosthetic_manager.call("set_temporary_equipped_prosthetic", str(loadout.get("prosthetic_id", "")))):
			return false

	if loadout.has("relic_id"):
		if not bool(_relic_runtime.call("set_temporary_equipped_relic", str(loadout.get("relic_id", "")))):
			return false
	return true


func _restore_aspect_state() -> void:
	if _aspect_runtime == null or not is_instance_valid(_aspect_runtime):
		return
	_apply_aspect_state(
		str(_snapshot.get("aspect_id", "")),
		int(_snapshot.get("aspect_tier", 0)),
		float(_snapshot.get("blood", 0.0)),
		bool(_snapshot.get("blood_art_resolving", false))
	)


func _apply_aspect_state(aspect_id: String, tier: int, blood: float, resolving: bool) -> void:
	_aspect_runtime.set("selected_aspect", aspect_id)
	_aspect_runtime.set("tier", clampi(tier, 0, 4))
	_aspect_runtime.set("blood", 0.0 if int(_aspect_runtime.get("tier")) < 2 else clampf(blood, 0.0, 100.0))
	_aspect_runtime.set("blood_art_resolving", resolving)
	if _aspect_runtime.has_method("_clear_contact_cache"):
		_aspect_runtime.call("_clear_contact_cache")
	if _aspect_runtime.has_method("_apply_to_live_player"):
		_aspect_runtime.call("_apply_to_live_player")
	if _aspect_runtime.has_signal("aspect_changed"):
		_aspect_runtime.emit_signal("aspect_changed", aspect_id)
	if _aspect_runtime.has_signal("tier_changed"):
		_aspect_runtime.emit_signal("tier_changed", int(_aspect_runtime.get("tier")))
	if _aspect_runtime.has_method("_emit_state"):
		_aspect_runtime.call("_emit_state")


func _restore_relic_transient_state() -> void:
	_relic_runtime.set("_last_oath_used", bool(_snapshot.get("relic_last_oath_used", false)))
	_relic_runtime.set("_merchant_discount_used_by_area", (_snapshot.get("relic_merchant_discount", {}) as Dictionary).duplicate(true))
	_relic_runtime.set("_scribe_uses_by_area", (_snapshot.get("relic_scribe_uses", {}) as Dictionary).duplicate(true))
	_relic_runtime.set("_room_health_damage_taken", bool(_snapshot.get("relic_room_health_damage", false)))


func _clear_refs() -> void:
	_active = false
	_snapshot.clear()
	_aspect_runtime = null
	_run_data = null
	_prosthetic_manager = null
	_relic_runtime = null
