---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-14
topics:
  - techniques
  - technique-catalog
  - combat-slots
  - effect-families
  - supporting-techniques
  - cross-family-techniques
  - legendary-techniques
  - refinements
  - rarity
  - eligibility
related:
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-COMBAT
  - GAMEPLAY-ITEMS-REWARDS
  - GAMEPLAY-PROGRESSION
  - UI-TECHNIQUE-REWARDS
  - ART-TECHNIQUE-VFX
  - META-OPEN-QUESTIONS
---

# Technique Catalog

## Purpose

This file owns the current working launch Technique roster, individual Technique rarity, and Technique-specific eligibility rules.

`TECHNIQUES.md` owns system-wide Technique rules. Blood Aspect files own Wolf, Wraith, and Ronin and are not changed merely to make a Technique fit.

## Current roster state

The current working launch roster is complete at qualitative paper-design depth:

- **25 direct slotted Techniques** — five per family across Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow,
- **15 same-family Supporting Techniques** — three per family,
- **5 Legendary Techniques** — one family capstone per family,
- **5 Cross-family Techniques**,
- **10 refinements** — small improvements to specific direct Techniques and not counted as separate Techniques.

This produces **50 actual Techniques**, plus 10 refinements.

The roster should not be expanded merely to hit a larger count. Additions or replacements should come from a concrete audit, prototype, balance, readability, or compatibility need.

Exact numerical values, rarity probabilities, offer weights, and reward frequency remain later tuning work.

## Rarity distribution

| Rarity | Count | Role |
|---|---:|---|
| **Common** | 10 | Reliable direct build starters |
| **Uncommon** | 18 | Main body of direct and supporting build development |
| **Rare** | 17 | Specialized, high-impact, cross-family, or later-build effects |
| **Legendary** | 5 | One rare run-shaping capstone per family |

Refinements do not receive Common / Uncommon / Rare / Legendary labels.

## Global eligibility rules

- A **direct slotted Technique** may appear whenever its combat slot is empty. It has no family prerequisite.
- If that slot is already filled, another direct Technique for the same slot is normally ineligible except through the rare same-slot replacement system.
- A **Supporting Technique** must have an already-owned Technique that can actually interact with its effect. Dead support offers are not allowed.
- A **Cross-family Technique** requires existing investment in both listed families and any specific mechanic stated by its entry.
- A **Legendary Technique** requires **3 native Techniques from its family**, including at least **1 slotted Technique**. Native same-family Supporting Techniques count toward the three-Technique requirement. Cross-family Techniques and refinements do not.
- A **refinement** requires ownership of its exact parent slotted Technique, and that Technique must not already have a refinement.
- Rarity does not itself create a prerequisite. A Rare direct Technique can still be a player's first pickup from that family.

# Echo — pale silver / twin slash

## Family rule

An **Echo** is a delayed additional sword slash created by a qualifying Technique. Akio does not literally repeat the full action.

## Direct Techniques

| Slot | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Lingering Cut** | Common | Qualifying Basic hits create a delayed Echo slash on the struck target. | Basic slot empty |
| Held Attack | **Second Draw** | Common | A landed Held Attack creates one heavier delayed Echo along the original authored attack line. | Held slot empty |
| Dash | **Passing Shadow** | Uncommon | A Dash Attack that connects leaves a delayed Echo slash at the contact point or attack line after Akio has moved on. | Dash slot empty |
| Parry / Counter | **Remembered Reversal** | Uncommon | A successful Counter creates a delayed Echo slash after the original Counter resolves. | Counter slot empty |
| Deathblow | **Final Memory** | Rare | A Deathblow produces several delayed Echo slashes around the execution location. | Deathblow slot empty |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Passing Memory** | Uncommon | If an Echo kills an enemy or breaks its posture, a weaker Echo slash continues toward one nearby enemy. | Own any Echo-producing Technique |
| **Pale Wake** | Uncommon | Echo slashes continue through their primary target and can damage enemies directly behind it for reduced damage. | Own any Echo-producing Technique |
| **Gathering Memory** | Rare | When multiple Echoes are created against the same enemy before earlier Echoes resolve, later Echoes become larger and stronger. | Own at least 2 Echo Techniques |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Unforgotten Steel** | Legendary | Every normal Echo creates one additional weaker Echo after it. The additional Echo cannot create another Echo. | Own 3 native Echo Techniques, including at least 1 slotted Technique |

# Rupture — gold / cracked crest

## Family rule

Eligible Gold effects add **Rupture buildup** to a visible enemy meter. Filling the meter immediately triggers Rupture, deals a large burst of posture damage, creates an allowed strong hit reaction, applies smaller nearby posture pressure, and resets the meter.

## Direct Techniques

| Slot | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Rupturing Edge** | Common | Qualifying Basic attacks add Rupture buildup at an Aspect-normalized rate. | Basic slot empty |
| Held Attack | **Mountain Breaker** | Common | A landed Held Attack creates a compact heavy impact with strong posture and guard pressure. | Held slot empty |
| Dash | **Breaching Step** | Uncommon | Dash Attack creates a short forward posture-impact shockwave and adds modest Rupture buildup to the primary target. | Dash slot empty |
| Parry / Counter | **Breaking Reversal** | Uncommon | A successful Counter applies a large amount of Rupture buildup to the attacker. | Counter slot empty |
| Deathblow | **Shattered Ground** | Rare | After the Deathblow resolves, a compact shockwave pressures nearby posture and applies partial Rupture buildup to survivors. | Deathblow slot empty |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Guardbreaker** | Uncommon | Attacking guarding enemies builds Rupture substantially faster. | Own a Technique capable of applying Rupture buildup |
| **Chain Break** | Uncommon | When Rupture triggers, nearby enemies receive partial Rupture buildup. | Own a Technique capable of triggering Rupture |
| **Faultline** | Rare | After an enemy Ruptures, its meter resets with some buildup already remaining instead of returning completely to zero. | Own a Technique capable of triggering Rupture |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Heavenbreaker** | Legendary | When an enemy Ruptures, nearby enemies whose meters are already heavily developed immediately Rupture as well. Secondary Ruptures cannot continue the chain. | Own 3 native Rupture Techniques, including at least 1 Rupture-buildup source |

# Seal — violet / binding knot

## Family rule

Seal uses three visible marks. One Seal mildly slows movement, two further restrict movement and qualifying movement abilities, and three briefly **Bind** the enemy in place without stunning it. Bind clears the stacks afterward.

## Direct Techniques

| Slot | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Sealing Cuts** | Common | Qualifying Basic contact applies Seal at an Aspect-normalized rate. | Basic slot empty |
| Held Attack | **Binding Draw** | Common | A landed Held Attack applies multiple Seal steps at once. | Held slot empty |
| Dash | **Warding Step** | Uncommon | Dash Attack applies a Seal. If the target is already Sealed, limited Seal pressure can spread to one nearby enemy. | Dash slot empty |
| Parry / Counter | **Counterseal** | Uncommon | A successful Counter applies multiple Seal steps to the struck enemy. | Counter slot empty |
| Deathblow | **Passing Seal** | Rare | After a Deathblow, Seal pressure carries into one nearby surviving enemy. | Deathblow slot empty |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Passing Script** | Uncommon | When a Sealed enemy dies, one of its Seals transfers to a nearby surviving enemy. | Own any Seal-applying Technique |
| **Shared Restraint** | Uncommon | When an enemy becomes Bound, nearby enemies receive one Seal. | Own a repeatable Seal source capable of eventually causing Bind |
| **Residual Knot** | Rare | After Bind ends, the enemy retains one Seal instead of clearing the entire pattern. | Own a repeatable Seal source capable of causing Bind |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Closed Circle** | Legendary | Binding an enemy immediately applies two Seals to a limited number of nearby enemies. This effect cannot trigger itself recursively. | Own 3 native Seal Techniques, including a repeatable Seal source |

# Rift — ivory / blade circle

## Family rule

Rift is one evolving visible ivory fracture. The first application starts a short fuse. The Rift always opens for direct Health damage; further qualifying applications before opening intensify the same mark and increase the eventual burst.

## Direct Techniques

| Slot | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Rift Edge** | Common | Qualifying Basics create a Rift; further qualifying Basics intensify the same fracture. | Basic slot empty |
| Held Attack | **Deep Rift** | Common | Held Attack creates a Rift at high initial intensity or heavily intensifies an existing Rift. | Held slot empty |
| Dash | **Shearing Step** | Uncommon | Dash Attack creates a faster-opening Rift; against an existing Rift it intensifies and accelerates the fuse. | Dash slot empty |
| Parry / Counter | **Rift Reversal** | Rare | A Counter creates a strong Rift, or heavily intensifies and forces open an existing Rift. | Counter slot empty |
| Deathblow | **Parting Rift** | Rare | After a Deathblow, a fresh Rift is placed on a nearby surviving enemy. | Deathblow slot empty |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Lingering Scar** | Uncommon | After a Rift opens, that enemy retains a faint scar. The next Rift created on that enemy begins at greater intensity. | Own any Rift-creating Technique |
| **Overpressure** | Uncommon | If a Rift reaches maximum intensity before its fuse ends, it immediately opens. | Own a Technique capable of intensifying Rift |
| **Fracture Spread** | Rare | When a Rift opens, one nearby enemy receives a fresh low-intensity Rift. Rifts created this way cannot spread again. | Own any Rift-creating Technique |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Ivory Collapse** | Legendary | A maximum-intensity Rift opens with a large blade-shaped rupture that also damages nearby enemies around the primary target. | Own 3 native Rift Techniques, including at least 1 way to intensify Rift |

# Crimson — split blood drop

## Family rule

Crimson is the direct Health-damage and backstab-specialist family. **Vulnerable** is a short enemy status that substantially increases damage from genuine backstabs. Vulnerable does not create fake backstabs or alter enemy movement, facing, or awareness.

## Direct Techniques

| Slot | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Open Wound** | Common | Qualifying Basic Attack hits apply Vulnerable for a short duration. | Basic slot empty |
| Dash | **Blood Arc** | Common | Dash Attack releases a wide bounded crimson sword arc for direct Health damage to the target and nearby enemies. | Dash slot empty |
| Parry / Counter | **Exposed Guard** | Uncommon | A successful Counter applies Vulnerable to the struck enemy. | Counter slot empty |
| Held Attack | **Deep Cut** | Rare | A genuine Held backstab deals extremely high direct Health damage and partially bypasses defensive mitigation. | Held slot empty |
| Deathblow | **Predator's Wake** | Rare | After a Deathblow resolves, nearby surviving enemies become Vulnerable for a short duration. | Deathblow slot empty |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Fresh Wound** | Uncommon | Successfully backstabbing a Vulnerable enemy refreshes Vulnerable. | Own a Technique capable of applying Vulnerable |
| **Blood Trail** | Uncommon | Killing a Vulnerable enemy causes one nearby surviving enemy to become Vulnerable. | Own a Technique capable of applying Vulnerable |
| **Severed Line** | Rare | A successful backstab against a Vulnerable enemy produces a short crimson cleave through the target, damaging enemies immediately behind it. | Own a Technique capable of applying Vulnerable |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Unseen** | Legendary | After a Deathblow, Akio briefly becomes invisible to enemy awareness. Attacking ends Unseen. The first successful backstab while Unseen receives a major Health-damage bonus. | Own 3 native Crimson Techniques, including at least 1 slotted Crimson Technique |

# Cross-family Techniques

All current Cross-family Techniques are **Rare**. They reward an already-established hybrid build rather than serving as shortcuts into a second family.

| Technique | Families | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| **Resonant Break** | Echo + Rupture | Rare | Echo slashes apply reduced Rupture buildup. | Own at least 1 Echo Technique and 1 Rupture Technique, with an Echo-producing effect |
| **Fractured Memory** | Echo + Rift | Rare | Echoes can intensify an existing Rift but cannot create a Rift themselves. | Own at least 1 Echo Technique and 1 Rift Technique |
| **Shattered Scar** | Rupture + Rift | Rare | Triggering Rupture heavily intensifies an existing Rift on that enemy. | Own a Rupture-triggering buildup source and a Rift-creating Technique |
| **Exposed Break** | Rupture + Crimson | Rare | Triggering Rupture also makes that enemy Vulnerable for a short time. | Own a Rupture-triggering buildup source and at least 1 Crimson Technique |
| **Bound Wound** | Seal + Crimson | Rare | When an enemy becomes Bound, it also becomes Vulnerable for the duration of Bind and briefly afterward. | Own a repeatable Seal source and at least 1 Crimson Technique |

# Refinements

Refinements are not separate Techniques and have no rarity. Each requires its exact parent Technique and an unused refinement slot on that Technique.

| Family | Parent Technique | Refinement effect |
|---|---|---|
| Echo | **Lingering Cut** | The delayed Echo slash gains a slightly wider cutting area and may clip one nearby enemy. |
| Echo | **Final Memory** | Creates one additional delayed Echo slash after the Deathblow. |
| Rupture | **Rupturing Edge** | Qualifying Basic hits apply stronger Rupture buildup. |
| Rupture | **Shattered Ground** | The post-Deathblow posture shockwave covers a somewhat larger area. |
| Seal | **Sealing Cuts** | Seals applied by Basic Attacks remain active longer before expiring. |
| Seal | **Passing Seal** | The Deathblow transfer can affect one additional nearby survivor. |
| Rift | **Rift Edge** | Further Basic applications intensify the existing Rift more strongly. |
| Rift | **Parting Rift** | The Rift transferred after a Deathblow begins at increased intensity. |
| Crimson | **Open Wound** | Vulnerable applied by Basic Attacks lasts longer. |
| Crimson | **Blood Arc** | The crimson Dash Attack arc becomes wider without substantially increasing forward reach. |

# Replacement boundary

Rare same-slot replacement remains a reward-system behavior, not a separate Technique roster. A replacement offer may make an otherwise ineligible direct Technique for the occupied slot available as an explicit overwrite. Exact replacement frequency and offer rules remain open.

# Validation requirements

The current roster should remain stable unless testing exposes a concrete issue. Audit the complete catalog for:

- compatibility with Wolf, Wraith, and Ronin,
- boss and isolated-target usefulness,
- group power and AoE limits,
- high-frequency / multi-hit normalization,
- genuine backstab access and Vulnerable usefulness,
- protected movement/control behavior,
- mixed-family readability,
- prerequisite correctness and absence of dead offers,
- and whether each family retains a distinct gameplay identity.

## Deferred implementation and reward tuning

Do not yet lock exact damage, posture values, Rupture buildup or decay, Seal durations or slow values, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc width/damage, Predator's Wake radius, Legendary durations, rarity probabilities, reward frequency, offer weights, replacement rates, or final UI/VFX timing.