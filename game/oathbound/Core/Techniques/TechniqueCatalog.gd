extends RefCounted
class_name TechniqueCatalog

## Canonical runtime data for Oathbound's current 50-Technique launch roster.
## Action Techniques are associated with sword actions for triggering/readability only;
## they do NOT occupy inventory slots and do not block other Techniques on that action.

const KIND_ACTION := "action"
const KIND_SUPPORT := "support"
const KIND_CROSS := "cross"
const KIND_LEGENDARY := "legendary"
const KIND_REFINEMENT := "refinement"

const ACTION_BASIC := "basic"
const ACTION_HELD := "held"
const ACTION_DASH := "dash"
const ACTION_COUNTER := "counter"
const ACTION_DEATHBLOW := "deathblow"

const FAMILIES := ["echo", "rupture", "seal", "rift", "crimson"]

static var TECHNIQUES := {
	"echo_lingering_cut": _entry("Lingering Cut", "Qualifying Basic hits create a delayed Echo slash on the struck target.", "echo", KIND_ACTION, "common", ACTION_BASIC, ["echo_source"]),
	"echo_second_draw": _entry("Second Draw", "A landed Held Attack creates one heavier delayed Echo along the authored attack line.", "echo", KIND_ACTION, "common", ACTION_HELD, ["echo_source"]),
	"echo_passing_shadow": _entry("Passing Shadow", "A Dash Attack that connects leaves a delayed Echo slash at the contact point or attack line after Akio moves on.", "echo", KIND_ACTION, "uncommon", ACTION_DASH, ["echo_source"]),
	"echo_remembered_reversal": _entry("Remembered Reversal", "A successful Counter creates a delayed Echo slash after the original Counter resolves.", "echo", KIND_ACTION, "uncommon", ACTION_COUNTER, ["echo_source"]),
	"echo_final_memory": _entry("Final Memory", "A Deathblow produces several delayed Echo slashes around the execution location.", "echo", KIND_ACTION, "rare", ACTION_DEATHBLOW, ["echo_source"]),
	"echo_passing_memory": _support("Passing Memory", "If an Echo kills an enemy or breaks its posture, a weaker Echo slash continues toward one nearby enemy.", "echo", "uncommon", ["echo_source"]),
	"echo_pale_wake": _support("Pale Wake", "Echo slashes continue through their primary target and can damage enemies directly behind it for reduced damage.", "echo", "uncommon", ["echo_source"]),
	"echo_gathering_memory": _family_count_support("Gathering Memory", "When multiple Echoes are created against the same enemy before earlier Echoes resolve, later Echoes become larger and stronger.", "echo", "rare", 2),
	"echo_unforgotten_steel": _legendary("Unforgotten Steel", "Every normal Echo creates one additional weaker Echo after it. The additional Echo cannot create another Echo.", "echo", ["echo_source"]),

	"rupture_rupturing_edge": _entry("Rupturing Edge", "Qualifying Basic attacks add Rupture buildup at an Aspect-normalized rate.", "rupture", KIND_ACTION, "common", ACTION_BASIC, ["rupture_buildup"]),
	"rupture_mountain_breaker": _entry("Mountain Breaker", "A landed Held Attack creates a compact heavy impact with strong posture and guard pressure.", "rupture", KIND_ACTION, "common", ACTION_HELD),
	"rupture_breaching_step": _entry("Breaching Step", "Dash Attack creates a short forward posture-impact shockwave and adds modest Rupture buildup to the primary target.", "rupture", KIND_ACTION, "uncommon", ACTION_DASH, ["rupture_buildup"]),
	"rupture_breaking_reversal": _entry("Breaking Reversal", "A successful Counter applies a large amount of Rupture buildup to the attacker.", "rupture", KIND_ACTION, "uncommon", ACTION_COUNTER, ["rupture_buildup"]),
	"rupture_shattered_ground": _entry("Shattered Ground", "After the Deathblow resolves, a compact shockwave pressures nearby posture and applies partial Rupture buildup to survivors.", "rupture", KIND_ACTION, "rare", ACTION_DEATHBLOW, ["rupture_buildup"]),
	"rupture_guardbreaker": _support("Guardbreaker", "Attacking guarding enemies builds Rupture substantially faster.", "rupture", "uncommon", ["rupture_buildup"]),
	"rupture_chain_break": _support("Chain Break", "When Rupture triggers, nearby enemies receive partial Rupture buildup.", "rupture", "uncommon", ["rupture_buildup"]),
	"rupture_faultline": _support("Faultline", "After an enemy Ruptures, its meter resets with some buildup already remaining instead of returning completely to zero.", "rupture", "rare", ["rupture_buildup"]),
	"rupture_heavenbreaker": _legendary("Heavenbreaker", "When an enemy Ruptures, nearby enemies whose meters are already heavily developed immediately Rupture as well. Secondary Ruptures cannot continue the chain.", "rupture", ["rupture_buildup"]),

	"seal_sealing_cuts": _entry("Sealing Cuts", "Qualifying Basic contact applies Seal at an Aspect-normalized rate.", "seal", KIND_ACTION, "common", ACTION_BASIC, ["seal_source", "seal_repeatable"]),
	"seal_binding_draw": _entry("Binding Draw", "A landed Held Attack applies multiple Seal steps at once.", "seal", KIND_ACTION, "common", ACTION_HELD, ["seal_source", "seal_repeatable"]),
	"seal_warding_step": _entry("Warding Step", "Dash Attack applies a Seal. If the target is already Sealed, limited Seal pressure can spread to one nearby enemy.", "seal", KIND_ACTION, "uncommon", ACTION_DASH, ["seal_source", "seal_repeatable"]),
	"seal_counterseal": _entry("Counterseal", "A successful Counter applies multiple Seal steps to the struck enemy.", "seal", KIND_ACTION, "uncommon", ACTION_COUNTER, ["seal_source", "seal_repeatable"]),
	"seal_passing_seal": _entry("Passing Seal", "After a Deathblow, Seal pressure carries into one nearby surviving enemy.", "seal", KIND_ACTION, "rare", ACTION_DEATHBLOW, ["seal_source"]),
	"seal_passing_script": _support("Passing Script", "When a Sealed enemy dies, one of its Seals transfers to a nearby surviving enemy.", "seal", "uncommon", ["seal_source"]),
	"seal_shared_restraint": _support("Shared Restraint", "When an enemy becomes Bound, nearby enemies receive one Seal.", "seal", "uncommon", ["seal_repeatable"]),
	"seal_residual_knot": _support("Residual Knot", "After Bind ends, the enemy retains one Seal instead of clearing the entire pattern.", "seal", "rare", ["seal_repeatable"]),
	"seal_closed_circle": _legendary("Closed Circle", "Binding an enemy immediately applies two Seals to a limited number of nearby enemies. This effect cannot trigger itself recursively.", "seal", ["seal_repeatable"]),

	"rift_rift_edge": _entry("Rift Edge", "Qualifying Basics create a Rift; further qualifying Basics intensify the same fracture.", "rift", KIND_ACTION, "common", ACTION_BASIC, ["rift_create", "rift_intensify"]),
	"rift_deep_rift": _entry("Deep Rift", "Held Attack creates a Rift at high initial intensity or heavily intensifies an existing Rift.", "rift", KIND_ACTION, "common", ACTION_HELD, ["rift_create", "rift_intensify"]),
	"rift_shearing_step": _entry("Shearing Step", "Dash Attack creates a faster-opening Rift; against an existing Rift it intensifies and accelerates the fuse.", "rift", KIND_ACTION, "uncommon", ACTION_DASH, ["rift_create", "rift_intensify"]),
	"rift_rift_reversal": _entry("Rift Reversal", "A Counter creates a strong Rift, or heavily intensifies and forces open an existing Rift.", "rift", KIND_ACTION, "rare", ACTION_COUNTER, ["rift_create", "rift_intensify"]),
	"rift_parting_rift": _entry("Parting Rift", "After a Deathblow, a fresh Rift is placed on a nearby surviving enemy.", "rift", KIND_ACTION, "rare", ACTION_DEATHBLOW, ["rift_create"]),
	"rift_lingering_scar": _support("Lingering Scar", "After a Rift opens, that enemy retains a faint scar. The next Rift created on that enemy begins at greater intensity.", "rift", "uncommon", ["rift_create"]),
	"rift_overpressure": _support("Overpressure", "If a Rift reaches maximum intensity before its fuse ends, it immediately opens.", "rift", "uncommon", ["rift_intensify"]),
	"rift_fracture_spread": _support("Fracture Spread", "When a Rift opens, one nearby enemy receives a fresh low-intensity Rift. Rifts created this way cannot spread again.", "rift", "rare", ["rift_create"]),
	"rift_ivory_collapse": _legendary("Ivory Collapse", "A maximum-intensity Rift opens with a large blade-shaped rupture that also damages nearby enemies around the primary target.", "rift", ["rift_intensify"]),

	"crimson_open_wound": _entry("Open Wound", "Qualifying Basic Attack hits apply Vulnerable for a short duration.", "crimson", KIND_ACTION, "common", ACTION_BASIC, ["vulnerable_source"]),
	"crimson_blood_arc": _entry("Blood Arc", "Dash Attack releases a wide bounded crimson sword arc for direct Health damage to the target and nearby enemies.", "crimson", KIND_ACTION, "common", ACTION_DASH),
	"crimson_exposed_guard": _entry("Exposed Guard", "A successful Counter applies Vulnerable to the struck enemy.", "crimson", KIND_ACTION, "uncommon", ACTION_COUNTER, ["vulnerable_source"]),
	"crimson_deep_cut": _entry("Deep Cut", "A genuine Held backstab deals extremely high direct Health damage and partially bypasses defensive mitigation.", "crimson", KIND_ACTION, "rare", ACTION_HELD, ["backstab_payoff"]),
	"crimson_predators_wake": _entry("Predator's Wake", "After a Deathblow resolves, nearby surviving enemies become Vulnerable for a short duration.", "crimson", KIND_ACTION, "rare", ACTION_DEATHBLOW, ["vulnerable_source"]),
	"crimson_fresh_wound": _support("Fresh Wound", "Successfully backstabbing a Vulnerable enemy refreshes Vulnerable.", "crimson", "uncommon", ["vulnerable_source"]),
	"crimson_blood_trail": _support("Blood Trail", "Killing a Vulnerable enemy causes one nearby surviving enemy to become Vulnerable.", "crimson", "uncommon", ["vulnerable_source"]),
	"crimson_severed_line": _support("Severed Line", "A successful backstab against a Vulnerable enemy produces a short crimson cleave through the target, damaging enemies immediately behind it.", "crimson", "rare", ["vulnerable_source"]),
	"crimson_unseen": _legendary("Unseen", "After a Deathblow, Akio briefly becomes invisible to enemy awareness. Attacking ends Unseen. The first successful backstab while Unseen receives a major Health-damage bonus.", "crimson"),

	"cross_resonant_break": _cross("Resonant Break", "Echo slashes apply reduced Rupture buildup.", ["echo", "rupture"], ["echo_source"]),
	"cross_fractured_memory": _cross("Fractured Memory", "Echoes can intensify an existing Rift but cannot create a Rift themselves.", ["echo", "rift"], ["echo_source", "rift_create"]),
	"cross_shattered_scar": _cross("Shattered Scar", "Triggering Rupture heavily intensifies an existing Rift on that enemy.", ["rupture", "rift"], ["rupture_buildup", "rift_create"]),
	"cross_exposed_break": _cross("Exposed Break", "Triggering Rupture also makes that enemy Vulnerable for a short time.", ["rupture", "crimson"], ["rupture_buildup"]),
	"cross_bound_wound": _cross("Bound Wound", "When an enemy becomes Bound, it also becomes Vulnerable for the duration of Bind and briefly afterward.", ["seal", "crimson"], ["seal_repeatable"]),
}

static var REFINEMENTS := {
	"refine_echo_lingering_cut": _refinement("Lingering Cut — Wider Memory", "The delayed Echo slash gains a slightly wider cutting area and may clip one nearby enemy.", "echo", "echo_lingering_cut"),
	"refine_echo_final_memory": _refinement("Final Memory — Lasting Echo", "Creates one additional delayed Echo slash after the Deathblow.", "echo", "echo_final_memory"),
	"refine_rupture_rupturing_edge": _refinement("Rupturing Edge — Deeper Break", "Qualifying Basic hits apply stronger Rupture buildup.", "rupture", "rupture_rupturing_edge"),
	"refine_rupture_shattered_ground": _refinement("Shattered Ground — Wider Break", "The post-Deathblow posture shockwave covers a somewhat larger area.", "rupture", "rupture_shattered_ground"),
	"refine_seal_sealing_cuts": _refinement("Sealing Cuts — Lasting Script", "Seals applied by Basic Attacks remain active longer before expiring.", "seal", "seal_sealing_cuts"),
	"refine_seal_passing_seal": _refinement("Passing Seal — Second Transfer", "The Deathblow transfer can affect one additional nearby survivor.", "seal", "seal_passing_seal"),
	"refine_rift_rift_edge": _refinement("Rift Edge — Deeper Fracture", "Further Basic applications intensify the existing Rift more strongly.", "rift", "rift_rift_edge"),
	"refine_rift_parting_rift": _refinement("Parting Rift — Deep Transfer", "The Rift transferred after a Deathblow begins at increased intensity.", "rift", "rift_parting_rift"),
	"refine_crimson_open_wound": _refinement("Open Wound — Lingering Vulnerability", "Vulnerable applied by Basic Attacks lasts longer.", "crimson", "crimson_open_wound"),
	"refine_crimson_blood_arc": _refinement("Blood Arc — Wider Arc", "The crimson Dash Attack arc becomes wider without substantially increasing forward reach.", "crimson", "crimson_blood_arc"),
}

static func all_entries() -> Dictionary:
	var out := TECHNIQUES.duplicate(true)
	for id in REFINEMENTS:
		out[id] = REFINEMENTS[id].duplicate(true)
	return out

static func get_entry(id: String) -> Dictionary:
	if TECHNIQUES.has(id):
		return TECHNIQUES[id].duplicate(true)
	if REFINEMENTS.has(id):
		return REFINEMENTS[id].duplicate(true)
	return {}

static func _entry(display_name: String, details: String, family: String, kind: String, rarity: String, action: String = "", tags: Array = []) -> Dictionary:
	return {"displayname": display_name, "details": details, "family": family, "kind": kind, "rarity": rarity, "action": action, "tags": tags}

static func _support(display_name: String, details: String, family: String, rarity: String, requires_any_tags: Array = []) -> Dictionary:
	var entry := _entry(display_name, details, family, KIND_SUPPORT, rarity)
	entry["requires_any_tags"] = requires_any_tags
	return entry

static func _family_count_support(display_name: String, details: String, family: String, rarity: String, min_count: int) -> Dictionary:
	var entry := _entry(display_name, details, family, KIND_SUPPORT, rarity)
	entry["min_family_count"] = min_count
	return entry

static func _legendary(display_name: String, details: String, family: String, requires_any_tags: Array = []) -> Dictionary:
	var entry := _entry(display_name, details, family, KIND_LEGENDARY, "legendary")
	entry["min_family_count"] = 3
	entry["requires_action_in_family"] = true
	entry["requires_any_tags"] = requires_any_tags
	return entry

static func _cross(display_name: String, details: String, families: Array, requires_all_tags: Array = []) -> Dictionary:
	var entry := _entry(display_name, details, "cross", KIND_CROSS, "rare")
	entry["families"] = families
	entry["requires_families"] = families
	entry["requires_all_tags"] = requires_all_tags
	entry["selection_weight"] = 1.5
	return entry

static func _refinement(display_name: String, details: String, family: String, parent_id: String) -> Dictionary:
	var entry := _entry(display_name, details, family, KIND_REFINEMENT, "refinement")
	entry["parent_id"] = parent_id
	return entry
