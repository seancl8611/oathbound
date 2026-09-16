extends RefCounted
class_name TechniqueCatalog

## Canonical runtime data for the current 40-Technique + 6-refinement launch roster.
## Action labels are trigger classifications only; Techniques do not occupy inventory slots.

const KIND_ACTION := "action"
const KIND_SUPPORT := "support"
const KIND_CROSS := "cross"
const KIND_LEGENDARY := "legendary"
const KIND_REFINEMENT := "refinement"

const ACTION_BASIC := "basic"
const ACTION_HELD := "held"
const ACTION_DASH := "dash"

const FAMILIES := ["echo", "rupture", "seal", "rift", "crimson"]

static var TECHNIQUES := {
	# Echo
	"echo_lingering_cut": _entry("Lingering Cut", "Qualifying Basic hits create a delayed Echo slash on the struck target.", "echo", KIND_ACTION, "common", ACTION_BASIC, ["echo_source"]),
	"echo_second_draw": _entry("Second Draw", "A landed Held Attack creates one heavier delayed Echo along the original authored attack line.", "echo", KIND_ACTION, "common", ACTION_HELD, ["echo_source"]),
	"echo_passing_shadow": _entry("Passing Shadow", "A Dash Attack that connects leaves a delayed Echo slash at the contact point or attack line after Akio moves on.", "echo", KIND_ACTION, "uncommon", ACTION_DASH, ["echo_source"]),
	"echo_passing_memory": _support("Passing Memory", "If an Echo kills an enemy or causes a major interruption, a weaker Echo slash continues toward one nearby enemy.", "echo", "uncommon", ["echo_source"]),
	"echo_pale_wake": _support("Pale Wake", "Echo slashes continue through their primary target and can damage enemies directly behind it for reduced damage.", "echo", "uncommon", ["echo_source"]),
	"echo_gathering_memory": _family_count_support("Gathering Memory", "When multiple Echoes are created against the same enemy before earlier Echoes resolve, later Echoes become larger and stronger.", "echo", "rare", 2),
	"echo_unforgotten_steel": _legendary("Unforgotten Steel", "Every normal Echo creates one additional weaker Echo after it. The additional Echo cannot create another Echo.", "echo", ["echo_source"]),

	# Rupture
	"rupture_rupturing_edge": _entry("Rupturing Edge", "Qualifying Basic attacks add Rupture buildup at an Aspect-normalized rate.", "rupture", KIND_ACTION, "common", ACTION_BASIC, ["rupture_buildup"]),
	"rupture_mountain_breaker": _entry("Mountain Breaker", "A landed Held Attack creates a compact heavy impact with strong Rupture buildup and guard/Poise pressure.", "rupture", KIND_ACTION, "common", ACTION_HELD, ["rupture_buildup"]),
	"rupture_breaching_step": _entry("Breaching Step", "Dash Attack creates a short forward impact wave and adds modest Rupture buildup to the primary target.", "rupture", KIND_ACTION, "uncommon", ACTION_DASH, ["rupture_buildup"]),
	"rupture_guardbreaker": _support("Guardbreaker", "Attacking guarding enemies builds Rupture substantially faster.", "rupture", "uncommon", ["rupture_buildup"]),
	"rupture_chain_break": _support("Chain Break", "When Rupture triggers, nearby enemies receive partial Rupture buildup.", "rupture", "uncommon", ["rupture_buildup"]),
	"rupture_faultline": _support("Faultline", "After an enemy Ruptures, its mark resets with some buildup remaining instead of returning completely to zero.", "rupture", "rare", ["rupture_buildup"]),
	"rupture_heavenbreaker": _legendary("Heavenbreaker", "When an enemy Ruptures, nearby enemies whose Rupture marks are already heavily developed immediately Rupture as well. Secondary Ruptures cannot continue the chain.", "rupture", ["rupture_buildup"]),

	# Seal
	"seal_sealing_cuts": _entry("Sealing Cuts", "Qualifying Basic contact applies Seal at an Aspect-normalized rate.", "seal", KIND_ACTION, "common", ACTION_BASIC, ["seal_source", "seal_repeatable"]),
	"seal_binding_draw": _entry("Binding Draw", "A landed Held Attack applies multiple Seal steps at once.", "seal", KIND_ACTION, "common", ACTION_HELD, ["seal_source", "seal_repeatable"]),
	"seal_warding_step": _entry("Warding Step", "Dash Attack applies a Seal. If the target is already Sealed, limited Seal pressure can spread to one nearby enemy.", "seal", KIND_ACTION, "uncommon", ACTION_DASH, ["seal_source", "seal_repeatable"]),
	"seal_passing_script": _support("Passing Script", "When a Sealed enemy dies, one of its Seals transfers to a nearby surviving enemy.", "seal", "uncommon", ["seal_source"]),
	"seal_shared_restraint": _support("Shared Restraint", "When an enemy becomes Bound, nearby enemies receive one Seal.", "seal", "uncommon", ["seal_repeatable"]),
	"seal_residual_knot": _support("Residual Knot", "After Bind ends, the enemy retains one Seal instead of clearing the entire pattern.", "seal", "rare", ["seal_repeatable"]),
	"seal_closed_circle": _legendary("Closed Circle", "Binding an enemy immediately applies two Seals to a limited number of nearby enemies. This effect cannot trigger itself recursively.", "seal", ["seal_repeatable"]),

	# Rift
	"rift_rift_edge": _entry("Rift Edge", "Qualifying Basics create a Rift; further qualifying Basics intensify the same fracture.", "rift", KIND_ACTION, "common", ACTION_BASIC, ["rift_create", "rift_intensify"]),
	"rift_deep_rift": _entry("Deep Rift", "Held Attack creates a Rift at high initial intensity or heavily intensifies an existing Rift.", "rift", KIND_ACTION, "common", ACTION_HELD, ["rift_create", "rift_intensify"]),
	"rift_shearing_step": _entry("Shearing Step", "Dash Attack creates a faster-opening Rift; against an existing Rift it intensifies and accelerates the fuse.", "rift", KIND_ACTION, "uncommon", ACTION_DASH, ["rift_create", "rift_intensify"]),
	"rift_lingering_scar": _support("Lingering Scar", "After a Rift opens, that enemy retains a faint scar. The next Rift created on that enemy begins at greater intensity.", "rift", "uncommon", ["rift_create"]),
	"rift_overpressure": _support("Overpressure", "If a Rift reaches maximum intensity before its fuse ends, it immediately opens.", "rift", "uncommon", ["rift_intensify"]),
	"rift_fracture_spread": _support("Fracture Spread", "When a Rift opens, one nearby enemy receives a fresh low-intensity Rift. Rifts created this way cannot spread again.", "rift", "rare", ["rift_create"]),
	"rift_ivory_collapse": _legendary("Ivory Collapse", "A maximum-intensity Rift opens with a large blade-shaped rupture that also damages nearby enemies around the primary target.", "rift", ["rift_intensify"]),

	# Crimson
	"crimson_open_wound": _entry("Open Wound", "Qualifying Basic Attack hits apply Vulnerable for a short duration.", "crimson", KIND_ACTION, "common", ACTION_BASIC, ["vulnerable_source"]),
	"crimson_deep_cut": _entry("Deep Cut", "A genuine Held backstab deals extremely high direct Health damage and partially bypasses defensive mitigation.", "crimson", KIND_ACTION, "rare", ACTION_HELD, ["backstab_payoff"]),
	"crimson_blood_arc": _entry("Blood Arc", "Dash Attack releases a wide bounded crimson sword arc for direct Health damage to the target and nearby enemies.", "crimson", KIND_ACTION, "common", ACTION_DASH),
	"crimson_fresh_wound": _support("Fresh Wound", "Successfully backstabbing a Vulnerable enemy refreshes Vulnerable.", "crimson", "uncommon", ["vulnerable_source"]),
	"crimson_blood_trail": _support("Blood Trail", "Killing a Vulnerable enemy causes one nearby surviving enemy to become Vulnerable.", "crimson", "uncommon", ["vulnerable_source"]),
	"crimson_severed_line": _support("Severed Line", "A successful backstab against a Vulnerable enemy produces a short crimson cleave through the target, damaging enemies immediately behind it.", "crimson", "rare", ["vulnerable_source"]),
	"crimson_unseen": _legendary("Unseen", "Killing a Vulnerable enemy with a genuine backstab briefly suppresses enemy awareness of Akio. Attacking ends the concealment; the first successful backstab during it gains a major Health-damage bonus.", "crimson", ["vulnerable_source"]),

	# Cross-family
	"cross_resonant_break": _cross("Resonant Break", "Echo slashes apply reduced Rupture buildup.", ["echo", "rupture"], ["echo_source", "rupture_buildup"]),
	"cross_fractured_memory": _cross("Fractured Memory", "Echoes can intensify an existing Rift but cannot create a Rift themselves.", ["echo", "rift"], ["echo_source", "rift_create"]),
	"cross_shattered_scar": _cross("Shattered Scar", "Triggering Rupture heavily intensifies an existing Rift on that enemy.", ["rupture", "rift"], ["rupture_buildup", "rift_create"]),
	"cross_exposed_break": _cross("Exposed Break", "Triggering Rupture also makes that enemy Vulnerable for a short time.", ["rupture", "crimson"], ["rupture_buildup"]),
	"cross_bound_wound": _cross("Bound Wound", "When an enemy becomes Bound, it also becomes Vulnerable for the duration of Bind and briefly afterward.", ["seal", "crimson"], ["seal_repeatable"]),
}

static var REFINEMENTS := {
	"refine_echo_lingering_cut": _refinement("Lingering Cut — Wider Memory", "The delayed Echo slash gains a slightly wider cutting area and may clip one nearby enemy.", "echo", "echo_lingering_cut"),
	"refine_rupture_rupturing_edge": _refinement("Rupturing Edge — Deeper Break", "Qualifying Basic hits apply stronger Rupture buildup.", "rupture", "rupture_rupturing_edge"),
	"refine_seal_sealing_cuts": _refinement("Sealing Cuts — Lasting Script", "Seals applied by Basic Attacks remain active longer before expiring.", "seal", "seal_sealing_cuts"),
	"refine_rift_rift_edge": _refinement("Rift Edge — Deeper Fracture", "Further Basic applications intensify the existing Rift more strongly.", "rift", "rift_rift_edge"),
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
