---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-09-16
topics:
  - techniques
  - technique-catalog
  - action-triggers
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

This file owns the active working launch Technique roster, individual rarity, and Technique-specific eligibility rules.

`TECHNIQUES.md` owns system-wide rules. Blood Aspect files own Wolf, Wraith, and Ronin and are not changed merely to make a Technique fit.

## Current roster state

After reconciling the catalog with the current Combat V2 action model, the active paper-design roster contains:

- **15 Action Techniques** — three shared action triggers per family: Basic Attack, Held Attack, and Dash / Dash Attack,
- **15 same-family Supporting Techniques** — three per family,
- **5 Legendary Techniques** — one family capstone per family,
- **5 Cross-family Techniques**,
- **6 refinements** — small improvements to specific Action Techniques and not counted as separate Techniques.

This produces **40 actual Techniques**, plus 6 refinements.

Action labels are trigger classifications, not inventory slots. Oathbound has no Technique slot system and no global Technique inventory cap. Owning one Technique associated with Basic Attack never blocks another unowned Basic Attack Technique.

The roster should not be expanded merely to restore an older count. Additions or replacements should come from a concrete combat, build-variety, readability, compatibility, or playtest need.

Exact numerical values, rarity probabilities, offer weights, and reward frequency remain tuning work.

## Rarity distribution

| Rarity | Count | Role |
|---|---:|---|
| **Common** | 10 | Reliable Action build starters |
| **Uncommon** | 14 | Main body of Action and Supporting build development |
| **Rare** | 11 | Specialized, high-impact, Cross-family, or later-build effects |
| **Legendary** | 5 | One rare run-shaping capstone per family |

Refinements do not receive rarity labels.

## Global eligibility rules

- An **Action Technique** is eligible whenever that exact Technique is not already owned this run and its trigger is supported by the current kit/runtime.
- A **Supporting Technique** must have an already-owned Technique that can actually interact with its effect. Dead support offers are not allowed.
- A **Cross-family Technique** requires existing investment in both listed families and any specific mechanic stated by its entry.
- A **Legendary Technique** requires **3 native Techniques from its family**, including at least **1 Action Technique**. Native same-family Supporting Techniques count toward the three-Technique requirement. Cross-family Techniques and refinements do not.
- A **refinement** requires ownership of its exact parent Action Technique, and that parent must not already have a refinement.
- Rarity does not itself create a prerequisite. A Rare Action Technique can still be a player's first pickup from that family.

# Echo — pale silver / twin slash

## Family rule

An **Echo** is a delayed additional sword slash created by a qualifying Technique. Akio does not literally repeat the full action.

## Action Techniques

| Trigger | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Lingering Cut** | Common | Qualifying Basic hits create a delayed Echo slash on the struck target. | Exact Technique unowned |
| Held Attack | **Second Draw** | Common | A landed Held Attack creates one heavier delayed Echo along the original authored attack line. | Exact Technique unowned |
| Dash | **Passing Shadow** | Uncommon | A Dash Attack that connects leaves a delayed Echo slash at the contact point or attack line after Akio has moved on. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Passing Memory** | Uncommon | If an Echo kills an enemy or causes a major interruption, a weaker Echo slash continues toward one nearby enemy. | Own any Echo-producing Technique |
| **Pale Wake** | Uncommon | Echo slashes continue through their primary target and can damage enemies directly behind it for reduced damage. | Own any Echo-producing Technique |
| **Gathering Memory** | Rare | When multiple Echoes are created against the same enemy before earlier Echoes resolve, later Echoes become larger and stronger. | Own at least 2 native Echo Techniques |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Unforgotten Steel** | Legendary | Every normal Echo creates one additional weaker Echo after it. The additional Echo cannot create another Echo. | Own 3 native Echo Techniques, including at least 1 Action Technique and an Echo-producing source |

# Rupture — gold / cracked crest

## Family rule

Eligible Gold effects add **Rupture buildup** to a visible family-specific mark. Filling the mark immediately triggers Rupture: a compact impact burst deals direct Health damage, applies strong Poise/guard pressure to the primary target, creates an allowed strong hit reaction, and sends bounded impact to nearby enemies before the mark resets.

Rupture is a Technique-family mechanic. Its visible buildup is not a shared enemy combat-resource bar.

## Action Techniques

| Trigger | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Rupturing Edge** | Common | Qualifying Basic attacks add Rupture buildup at an Aspect-normalized rate. | Exact Technique unowned |
| Held Attack | **Mountain Breaker** | Common | A landed Held Attack creates a compact heavy impact with strong Rupture buildup and guard/Poise pressure. | Exact Technique unowned |
| Dash | **Breaching Step** | Uncommon | Dash Attack creates a short forward impact wave and adds modest Rupture buildup to the primary target. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Guardbreaker** | Uncommon | Attacking guarding enemies builds Rupture substantially faster. | Own a Technique capable of applying Rupture buildup |
| **Chain Break** | Uncommon | When Rupture triggers, nearby enemies receive partial Rupture buildup. | Own a Technique capable of triggering Rupture |
| **Faultline** | Rare | After an enemy Ruptures, its mark resets with some buildup remaining instead of returning completely to zero. | Own a Technique capable of triggering Rupture |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Heavenbreaker** | Legendary | When an enemy Ruptures, nearby enemies whose Rupture marks are already heavily developed immediately Rupture as well. Secondary Ruptures cannot continue the chain. | Own 3 native Rupture Techniques, including at least 1 Action Technique and a Rupture-buildup source |

# Seal — violet / binding knot

## Family rule

Seal uses three visible marks. One Seal mildly restricts movement, two further restrict movement and qualifying movement abilities, and three briefly **Bind** the enemy in place without changing its normal Health defeat condition. Bind clears the marks afterward.

## Action Techniques

| Trigger | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Sealing Cuts** | Common | Qualifying Basic contact applies Seal at an Aspect-normalized rate. | Exact Technique unowned |
| Held Attack | **Binding Draw** | Common | A landed Held Attack applies multiple Seal steps at once. | Exact Technique unowned |
| Dash | **Warding Step** | Uncommon | Dash Attack applies a Seal. If the target is already Sealed, limited Seal pressure can spread to one nearby enemy. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Passing Script** | Uncommon | When a Sealed enemy dies, one of its Seals transfers to a nearby surviving enemy. | Own any Seal-applying Technique |
| **Shared Restraint** | Uncommon | When an enemy becomes Bound, nearby enemies receive one Seal. | Own a repeatable Seal source capable of eventually causing Bind |
| **Residual Knot** | Rare | After Bind ends, the enemy retains one Seal instead of clearing the entire pattern. | Own a repeatable Seal source capable of causing Bind |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Closed Circle** | Legendary | Binding an enemy immediately applies two Seals to a limited number of nearby enemies. This effect cannot trigger itself recursively. | Own 3 native Seal Techniques, including at least 1 Action Technique and a repeatable Seal source |

# Rift — ivory / blade circle

## Family rule

Rift is one evolving visible ivory fracture. The first application starts a short fuse. The Rift always opens for direct Health damage; further qualifying applications before opening intensify the same mark and increase the eventual burst.

## Action Techniques

| Trigger | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Rift Edge** | Common | Qualifying Basics create a Rift; further qualifying Basics intensify the same fracture. | Exact Technique unowned |
| Held Attack | **Deep Rift** | Common | Held Attack creates a Rift at high initial intensity or heavily intensifies an existing Rift. | Exact Technique unowned |
| Dash | **Shearing Step** | Uncommon | Dash Attack creates a faster-opening Rift; against an existing Rift it intensifies and accelerates the fuse. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Lingering Scar** | Uncommon | After a Rift opens, that enemy retains a faint scar. The next Rift created on that enemy begins at greater intensity. | Own any Rift-creating Technique |
| **Overpressure** | Uncommon | If a Rift reaches maximum intensity before its fuse ends, it immediately opens. | Own a Technique capable of intensifying Rift |
| **Fracture Spread** | Rare | When a Rift opens, one nearby enemy receives a fresh low-intensity Rift. Rifts created this way cannot spread again. | Own any Rift-creating Technique |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Ivory Collapse** | Legendary | A maximum-intensity Rift opens with a large blade-shaped rupture that also damages nearby enemies around the primary target. | Own 3 native Rift Techniques, including at least 1 Action Technique and a way to intensify Rift |

# Crimson — split blood drop

## Family rule

Crimson is the direct Health-damage and backstab-specialist family. **Vulnerable** is a short enemy status that substantially increases damage from genuine backstabs. Vulnerable does not create fake backstabs or alter enemy movement, facing, or awareness.

## Action Techniques

| Trigger | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Open Wound** | Common | Qualifying Basic Attack hits apply Vulnerable for a short duration. | Exact Technique unowned |
| Dash | **Blood Arc** | Common | Dash Attack releases a wide bounded crimson sword arc for direct Health damage to the target and nearby enemies. | Exact Technique unowned |
| Held Attack | **Deep Cut** | Rare | A genuine Held backstab deals extremely high direct Health damage and partially bypasses defensive mitigation. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Fresh Wound** | Uncommon | Successfully backstabbing a Vulnerable enemy refreshes Vulnerable. | Own a Technique capable of applying Vulnerable |
| **Blood Trail** | Uncommon | Killing a Vulnerable enemy causes one nearby surviving enemy to become Vulnerable. | Own a Technique capable of applying Vulnerable |
| **Severed Line** | Rare | A successful backstab against a Vulnerable enemy produces a short crimson cleave through the target, damaging enemies immediately behind it. | Own a Technique capable of applying Vulnerable |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Unseen** | Legendary | Killing a Vulnerable enemy with a genuine backstab briefly suppresses enemy awareness of Akio. Attacking ends the concealment; the first successful backstab during it gains a major Health-damage bonus. | Own 3 native Crimson Techniques, including at least 1 Action Technique and a Vulnerable source |

# Cross-family Techniques

All current Cross-family Techniques are **Rare**. They reward an already-established hybrid build rather than serving as shortcuts into a second family.

| Technique | Families | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| **Resonant Break** | Echo + Rupture | Rare | Echo slashes apply reduced Rupture buildup. | Own at least 1 Echo Technique and 1 Rupture Technique, with an Echo-producing effect |
| **Fractured Memory** | Echo + Rift | Rare | Echoes can intensify an existing Rift but cannot create a Rift themselves. | Own at least 1 Echo Technique and 1 Rift Technique, including an Echo source and Rift source |
| **Shattered Scar** | Rupture + Rift | Rare | Triggering Rupture heavily intensifies an existing Rift on that enemy. | Own a Rupture-triggering buildup source and a Rift-creating Technique |
| **Exposed Break** | Rupture + Crimson | Rare | Triggering Rupture also makes that enemy Vulnerable for a short time. | Own a Rupture-triggering buildup source and at least 1 Crimson Technique |
| **Bound Wound** | Seal + Crimson | Rare | When an enemy becomes Bound, it also becomes Vulnerable for the duration of Bind and briefly afterward. | Own a repeatable Seal source and at least 1 Crimson Technique |

# Refinements

Refinements are not separate Techniques and have no rarity. Each requires its exact parent Action Technique and may be acquired only once.

| Family | Parent Technique | Refinement effect |
|---|---|---|
| Echo | **Lingering Cut** | The delayed Echo slash gains a slightly wider cutting area and may clip one nearby enemy. |
| Rupture | **Rupturing Edge** | Qualifying Basic hits apply stronger Rupture buildup. |
| Seal | **Sealing Cuts** | Seals applied by Basic Attacks remain active longer before expiring. |
| Rift | **Rift Edge** | Further Basic applications intensify the existing Rift more strongly. |
| Crimson | **Open Wound** | Vulnerable applied by Basic Attacks lasts longer. |
| Crimson | **Blood Arc** | The crimson Dash Attack arc becomes wider without substantially increasing forward reach. |

# Validation requirements

Audit the complete active catalog for:

- compatibility with Wolf, Wraith, and Ronin,
- absence of dead or unsupported trigger requirements,
- boss and isolated-target usefulness,
- group power and AoE limits,
- high-frequency / multi-hit normalization,
- genuine backstab access and Vulnerable usefulness,
- protected movement/control behavior,
- mixed-family readability,
- prerequisite correctness and absence of dead offers,
- and whether each family retains a distinct gameplay identity.

## Deferred implementation and reward tuning

Do not yet lock exact damage, Poise values, Rupture buildup or decay, Seal durations or movement restriction, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc width/damage, Legendary durations, rarity probabilities, reward frequency, offer weights, or final UI/VFX timing without playtest evidence.