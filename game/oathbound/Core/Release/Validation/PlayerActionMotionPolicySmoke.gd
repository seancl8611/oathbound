extends Node

const ASPECT_CATALOG = preload("res://Core/Aspects/AspectCatalog.gd")
const MOTION_POLICY = preload("res://Core/Combat/PlayerActionMotionPolicy.gd")

var _failures: Array[String] = []
var _checked_ids: Array[String] = []


func _ready() -> void:
	_validate_profile_set("base_basic", ASPECT_CATALOG.get_basic_profiles(ASPECT_CATALOG.NO_ASPECT, 0))
	_validate_profile("base_held", ASPECT_CATALOG.get_held_profile(ASPECT_CATALOG.NO_ASPECT, 0))
	_validate_profile("base_dash", ASPECT_CATALOG.get_dash_profile(ASPECT_CATALOG.NO_ASPECT, 0))
	_validate_profile("base_counter", ASPECT_CATALOG.get_counter_profile(ASPECT_CATALOG.NO_ASPECT, 0))

	for aspect: String in ASPECT_CATALOG.ASPECTS:
		_validate_profile_set("%s_basic" % aspect, ASPECT_CATALOG.get_basic_profiles(aspect, 4))
		_validate_profile("%s_held" % aspect, ASPECT_CATALOG.get_held_profile(aspect, 4))
		_validate_profile("%s_dash" % aspect, ASPECT_CATALOG.get_dash_profile(aspect, 4))
		_validate_profile("%s_counter" % aspect, ASPECT_CATALOG.get_counter_profile(aspect, 4))
		_validate_profile("%s_blood_art" % aspect, ASPECT_CATALOG.get_blood_art_profile(aspect))

	_validate_profile("ronin_reprisal", ASPECT_CATALOG.get_reprisal_profile())
	_validate_profile("wraith_barrage", ASPECT_CATALOG.get_wraith_barrage_profile())

	if not _failures.is_empty():
		for failure: String in _failures:
			push_error("[PlayerActionMotionPolicySmoke] %s" % failure)
		print("[PlayerActionMotionPolicySmoke] FAIL - %d issue(s)" % _failures.size())
		get_tree().quit(1)
		return

	print("[PlayerActionMotionPolicySmoke] PASS - %d current player actions have explicit Combat V2 motion policy" % _checked_ids.size())
	get_tree().quit(0)


func _validate_profile_set(label: String, profiles: Array) -> void:
	if profiles.is_empty():
		_failures.append("%s returned no profiles" % label)
		return
	for value: Variant in profiles:
		if value is Dictionary:
			_validate_profile(label, value as Dictionary)
		else:
			_failures.append("%s contains a non-Dictionary profile" % label)


func _validate_profile(label: String, profile: Dictionary) -> void:
	if profile.is_empty():
		_failures.append("%s returned an empty profile" % label)
		return
	var action_id: String = str(profile.get("id", ""))
	if action_id.is_empty():
		_failures.append("%s profile is missing id" % label)
		return
	if action_id in _checked_ids:
		return
	_checked_ids.append(action_id)

	if not MOTION_POLICY.has_policy(action_id):
		_failures.append("%s (%s) has no explicit motion policy" % [label, action_id])
		return

	var resolved: Dictionary = MOTION_POLICY.apply_to_profile(profile)
	for key: String in [
		"v2_commit_fraction",
		"v2_startup_locomotion_weight",
		"v2_committed_locomotion_weight",
		"v2_active_locomotion_weight",
		"v2_recovery_locomotion_weight",
	]:
		if not resolved.has(key):
			_failures.append("%s (%s) missing %s after policy application" % [label, action_id, key])
			continue
		var value: float = float(resolved[key])
		if value < 0.0 or value > 1.0:
			_failures.append("%s (%s) has out-of-range %s=%s" % [label, action_id, key, str(value)])

	var turn_rate: float = float(resolved.get("v2_startup_turn_rate_deg", -1.0))
	if turn_rate < 0.0:
		_failures.append("%s (%s) has negative turn rate" % [label, action_id])
