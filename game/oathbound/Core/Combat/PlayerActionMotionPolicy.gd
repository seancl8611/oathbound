extends RefCounted
class_name PlayerActionMotionPolicy

## Explicit Combat V2 locomotion/steering policy for current player sword actions.
##
## The live PlayerMotor/CombatActionRunner runtime consumes these values through the
## existing `v2_*` profile override contract. Keeping the policy keyed by authored
## action id prevents movement feel from silently changing when damage/Poise tuning
## causes an attack to cross a generic "heavy" threshold.

const DEFAULT_POLICY := {
	"commit_fraction": 0.70,
	"startup_weight": 0.86,
	"committed_weight": 0.50,
	"active_weight": 0.38,
	"recovery_weight": 0.76,
	"turn_rate_deg": 900.0,
}

const POLICIES := {
	# Pre-awakening base katana: responsive openers, planted heavy finish.
	"quick_slash": _policy(0.72, 0.90, 0.58, 0.44, 0.82, 980.0),
	"cross_cut": _policy(0.70, 0.86, 0.50, 0.38, 0.78, 900.0),
	"heavy_cleave": _policy(0.60, 0.66, 0.24, 0.16, 0.56, 560.0),
	"hold_thrust": _policy(0.68, 0.78, 0.40, 0.28, 0.64, 700.0),
	"dash_slash": _policy(0.80, 0.98, 0.76, 0.62, 0.88, 1080.0),
	"counter_cut": _policy(0.74, 0.92, 0.62, 0.50, 0.82, 960.0),

	# Wolf: strongest continuous locomotion/pursuit identity.
	"wolf_fang_slash": _policy(0.76, 0.96, 0.72, 0.62, 0.88, 1120.0),
	"wolf_rending_cross": _policy(0.74, 0.94, 0.68, 0.56, 0.86, 1040.0),
	"wolf_raking_fang": _policy(0.80, 0.98, 0.80, 0.70, 0.90, 1120.0),
	"wolf_blood_cleave": _policy(0.58, 0.70, 0.30, 0.20, 0.56, 620.0),
	"wolf_predators_passage": _policy(0.78, 0.92, 0.70, 0.58, 0.62, 760.0),
	"wolf_hunting_slash": _policy(0.82, 1.00, 0.82, 0.72, 0.92, 1180.0),
	"wolf_fang_reversal": _policy(0.78, 0.96, 0.74, 0.62, 0.88, 1080.0),
	"wolf_blood_hunt": _policy(0.88, 1.00, 0.92, 0.88, 0.76, 520.0),

	# Wraith: spacing/line control; authored stationary barrage is explicit.
	"wraith_veil_cut": _policy(0.66, 0.78, 0.40, 0.30, 0.72, 760.0),
	"wraith_passing_arc": _policy(0.62, 0.72, 0.34, 0.24, 0.64, 660.0),
	"wraith_pale_lance": _policy(0.60, 0.66, 0.24, 0.16, 0.54, 520.0),
	"wraith_pale_barrage": _policy(0.50, 0.0, 0.0, 0.0, 0.0, 0.0),
	"wraith_ghostline_slash": _policy(0.78, 0.96, 0.70, 0.58, 0.84, 880.0),
	"wraith_veil_reversal": _policy(0.68, 0.82, 0.48, 0.36, 0.74, 760.0),
	"wraith_reach_corridor": _policy(0.56, 0.52, 0.12, 0.08, 0.42, 360.0),

	# Ronin: measured commitment and lower steering during committed cuts.
	"ronin_severing_cut": _policy(0.62, 0.72, 0.34, 0.24, 0.62, 620.0),
	"ronin_crushing_cross": _policy(0.58, 0.66, 0.26, 0.18, 0.56, 520.0),
	"ronin_bloodfall": _policy(0.54, 0.58, 0.16, 0.10, 0.46, 420.0),
	"ronin_stillness_draw": _policy(0.50, 0.52, 0.12, 0.08, 0.40, 340.0),
	"ronin_breaching_slash": _policy(0.72, 0.88, 0.54, 0.42, 0.72, 720.0),
	"ronin_answering_steel": _policy(0.60, 0.68, 0.30, 0.20, 0.58, 560.0),
	"ronin_reprisal_cut": _policy(0.54, 0.60, 0.18, 0.12, 0.48, 440.0),
	"ronin_falling_mountain": _policy(0.48, 0.46, 0.08, 0.04, 0.34, 300.0),
}


static func has_policy(action_id: String) -> bool:
	return POLICIES.has(action_id)


static func for_action(action_id: String) -> Dictionary:
	if POLICIES.has(action_id):
		return (POLICIES[action_id] as Dictionary).duplicate(true)
	return DEFAULT_POLICY.duplicate(true)


static func apply_to_profile(profile: Dictionary) -> Dictionary:
	var resolved: Dictionary = profile.duplicate(true)
	var action_id: String = str(resolved.get("id", ""))
	var policy: Dictionary = for_action(action_id)
	resolved["v2_commit_fraction"] = float(policy.get("commit_fraction", DEFAULT_POLICY["commit_fraction"]))
	resolved["v2_startup_locomotion_weight"] = float(policy.get("startup_weight", DEFAULT_POLICY["startup_weight"]))
	resolved["v2_committed_locomotion_weight"] = float(policy.get("committed_weight", DEFAULT_POLICY["committed_weight"]))
	resolved["v2_active_locomotion_weight"] = float(policy.get("active_weight", DEFAULT_POLICY["active_weight"]))
	resolved["v2_recovery_locomotion_weight"] = float(policy.get("recovery_weight", DEFAULT_POLICY["recovery_weight"]))
	resolved["v2_startup_turn_rate_deg"] = float(policy.get("turn_rate_deg", DEFAULT_POLICY["turn_rate_deg"]))
	return resolved


static func _policy(
		commit_fraction: float,
		startup_weight: float,
		committed_weight: float,
		active_weight: float,
		recovery_weight: float,
		turn_rate_deg: float
	) -> Dictionary:
	return {
		"commit_fraction": commit_fraction,
		"startup_weight": startup_weight,
		"committed_weight": committed_weight,
		"active_weight": active_weight,
		"recovery_weight": recovery_weight,
		"turn_rate_deg": turn_rate_deg,
	}
