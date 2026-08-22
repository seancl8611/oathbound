---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-20
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

This file owns the current working launch Technique roster, individual Technique rarity, and Technique-specific eligibility rules.

`TECHNIQUES.md` owns system-wide Technique rules. Blood Aspect files own Wolf, Wraith, and Ronin and are not changed merely to make a Technique fit.

## Current roster state

The current working launch roster is complete at qualitative paper-design depth:

- **25 Action Techniques** — five per family across Basic Attack, Held Attack, Dash / Dash Attack, Parry / Counter, and Deathblow,
- **15 same-family Supporting Techniques** — three per family,
- **5 Legendary Techniques** — one family capstone per family,
- **5 Cross-family Techniques**,
- **10 refinements** — small improvements to specific Action Techniques and not counted as separate Techniques.

This produces **50 actual Techniques**, plus 10 refinements.

Action labels in this catalog are **trigger classifications, not inventory slots**. Oathbound has no Technique slot system and no global Technique inventory cap. Owning one Technique associated with Basic Attack, for example, never blocks another unowned Basic Attack Technique.

The roster should not be expanded merely to hit a larger count. Additions or replacements should come from a concrete audit, prototype, balance, readability, or compatibility need.

Exact numerical values, rarity probabilities, offer weights, and reward frequency remain later tuning work.

## Rarity distribution

| Rarity | Count | Role |
|---|---:|---|
| **Common** | 10 | Reliable Action build starters |
| **Uncommon** | 18 | Main body of Action and Supporting build development |
| **Rare** | 17 | Specialized, high-impact, Cross-family, or later-build effects |
| **Legendary** | 5 | One rare run-shaping capstone per family |

Refinements do not receive Common / Uncommon / Rare / Legendary labels.

## Global eligibility rules

- An **Action Technique** is eligible whenever that exact Technique is not already owned this run. It has no family prerequisite and no action-slot exclusion.
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
| Parry / Counter | **Remembered Reversal** | Uncommon | A successful Counter creates a delayed Echo slash after the original Counter resolves. | Exact Technique unowned |
| Deathblow | **Final Memory** | Rare | A Deathblow produces several delayed Echo slashes around the execution location. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Passing Memory** | Uncommon | If an Echo kills an enemy or breaks its posture, a weaker Echo slash continues toward one nearby enemy. | Own any Echo-producing Technique |
| **Pale Wake** | Uncommon | Echo slashes continue through their primary target and can damage enemies directly behind it for reduced damage. | Own any Echo-producing Technique |
| **Gathering Memory** | Rare | When multiple Echoes are created against the same enemy before earlier Echoes resolve, later Echoes become larger and stronger. | Own at least 2 native Echo Techniques |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Unforgotten Steel** | Legendary | Every normal Echo creates one additional weaker Echo after it. The additional Echo cannot create another Echo. | Own 3 native Echo Techniques, including at least 1 Action Technique and an Echo-producing source |

# Rupture — gold / cracked crest

## Family rule

Eligible Gold effects add **Rupture buildup** to a visible enemy meter. Filling the meter immediately triggers Rupture, deals a large burst of posture damage, creates an allowed strong hit reaction, applies smaller nearby posture pressure, and resets the meter.

## Action Techniques

| Trigger | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Rupturing Edge** | Common | Qualifying Basic attacks add Rupture buildup at an Aspect-normalized rate. | Exact Technique unowned |
| Held Attack | **Mountain Breaker** | Common | A landed Held Attack creates a compact heavy impact with strong posture and guard pressure. | Exact Technique unowned |
| Dash | **Breaching Step** | Uncommon | Dash Attack creates a short forward posture-impact shockwave and adds modest Rupture buildup to the primary target. | Exact Technique unowned |
| Parry / Counter | **Breaking Reversal** | Uncommon | A successful Counter applies a large amount of Rupture buildup to the attacker. | Exact Technique unowned |
| Deathblow | **Shattered Ground** | Rare | After the Deathblow resolves, a compact shockwave pressures nearby posture and applies partial Rupture buildup to survivors. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Guardbreaker** | Uncommon | Attacking guarding enemies builds Rupture substantially faster. | Own a Technique capable of applying Rupture buildup |
| **Chain Break** | Uncommon | When Rupture triggers, nearby enemies receive partial Rupture buildup. | Own a Technique capable of triggering Rupture |
| **Faultline** | Rare | After an enemy Ruptures, its meter resets with some buildup already remaining instead of returning completely to zero. | Own a Technique capable of triggering Rupture |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Heavenbreaker** | Legendary | When an enemy Ruptures, nearby enemies whose meters are already heavily developed immediately Rupture as well. Secondary Ruptures cannot continue the chain. | Own 3 native Rupture Techniques, including at least 1 Action Technique and a Rupture-buildup source |

# Seal — violet / binding knot

## Family rule

Seal uses three visible marks. One Seal mildly slows movement, two further restrict movement and qualifying movement abilities, and three briefly **Bind** the enemy in place without stunning it. Bind clears the marks afterward.

## Action Techniques

| Trigger | Technique | Rarity | Effect | Eligibility |
|---|---|---|---|---|
| Basic Attack | **Sealing Cuts** | Common | Qualifying Basic contact applies Seal at an Aspect-normalized rate. | Exact Technique unowned |
| Held Attack | **Binding Draw** | Common | A landed Held Attack applies multiple Seal steps at once. | Exact Technique unowned |
| Dash | **Warding Step** | Uncommon | Dash Attack applies a Seal. If the target is already Sealed, limited Seal pressure can spread to one nearby enemy. | Exact Technique unowned |
| Parry / Counter | **Counterseal** | Uncommon | A successful Counter applies multiple Seal steps to the struck enemy. | Exact Technique unowned |
| Deathblow | **Passing Seal** | Rare | After a Deathblow, Seal pressure carries into one nearby surviving enemy. | Exact Technique unowned |

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
| Parry / Counter | **Rift Reversal** | Rare | A Counter creates a strong Rift, or heavily intensifies and forces open an existing Rift. | Exact Technique unowned |
| Deathblow | **Parting Rift** | Rare | After a Deathblow, a fresh Rift is placed on a nearby surviving enemy. | Exact Technique unowned |

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
| Parry / Counter | **Exposed Guard** | Uncommon | A successful Counter applies Vulnerable to the struck enemy. | Exact Technique unowned |
| Held Attack | **Deep Cut** | Rare | A genuine Held backstab deals extremely high direct Health damage and partially bypasses defensive mitigation. | Exact Technique unowned |
| Deathblow | **Predator's Wake** | Rare | After a Deathblow resolves, nearby surviving enemies become Vulnerable for a short duration. | Exact Technique unowned |

## Supporting Techniques

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Fresh Wound** | Uncommon | Successfully backstabbing a Vulnerable enemy refreshes Vulnerable. | Own a Technique capable of applying Vulnerable |
| **Blood Trail** | Uncommon | Killing a Vulnerable enemy causes one nearby surviving enemy to become Vulnerable. | Own a Technique capable of applying Vulnerable |
| **Severed Line** | Rare | A successful backstab against a Vulnerable enemy produces a short crimson cleave through the target, damaging enemies immediately behind it. | Own a Technique capable of applying Vulnerable |

## Legendary

| Technique | Rarity | Effect | Eligibility |
|---|---|---|---|
| **Unseen** | Legendary | After a Deathblow, Akio briefly becomes invisible to enemy awareness. Attacking ends Unseen. The first successful backstab while Unseen receives a major Health-damage bonus. | Own 3 native Crimson Techniques, including at least 1 Action Technique |

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
| Echo | **Final Memory** | Creates one additional delayed Echo slash after the Deathblow. |
| Rupture | **Rupturing Edge** | Qualifying Basic hits apply stronger Rupture buildup. |
| Rupture | **Shattered Ground** | The post-Deathblow posture shockwave covers a somewhat larger area. |
| Seal | **Sealing Cuts** | Seals applied by Basic Attacks remain active longer before expiring. |
| Seal | **Passing Seal** | The Deathblow transfer can affect one additional nearby survivor. |
| Rift | **Rift Edge** | Further Basic applications intensify the existing Rift more strongly. |
| Rift | **Parting Rift** | The Rift transferred after a Deathblow begins at increased intensity. |
| Crimson | **Open Wound** | Vulnerable applied by Basic Attacks lasts longer. |
| Crimson | **Blood Arc** | The crimson Dash Attack arc becomes wider without substantially increasing forward reach. |

# No replacement system

Because Action Techniques no longer occupy exclusive action slots, the old same-slot replacement system is removed. There is no need to overwrite an owned Basic/Held/Dash/Counter/Deathblow Technique in order to acquire another Technique tied to that same action.

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

Do not yet lock exact damage, posture values, Rupture buildup or decay, Seal durations or slow values, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc width/damage, Predator's Wake radius, Legendary durations, rarity probabilities, reward frequency, offer weights, or final UI/VFX timing.
