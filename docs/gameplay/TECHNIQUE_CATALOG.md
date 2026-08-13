---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-08-13
topics:
  - techniques
  - technique-catalog
  - combat-slots
  - effect-families
  - rupture
  - seals
  - rift
  - vulnerable
  - backstabs
  - supporting-techniques
  - legendary-techniques
  - refinements
  - rarity
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

This file owns the current Technique roster and the design state of the five Technique families.

`TECHNIQUES.md` owns system rules. Blood Aspect files own Wolf, Wraith, and Ronin and are not changed merely to make a Technique fit.

## Current status

The five-slot Technique architecture is approved and the full **25-Technique direct matrix is approved at qualitative paper-design depth**.

Each family now has one approved direct Technique for each combat slot:

1. Basic Attack
2. Held Attack
3. Dash / Dash Attack
4. Parry / Counter
5. Deathblow

The earlier broad ~55-Technique draft is exploratory history, not the launch roster.

The active Technique-design layer is now the remaining catalog around the approved direct matrix: **same-family Supporting Techniques, Cross-family Techniques, Legendary Techniques, refinements, rare replacements, rarity assignments, and eligibility rules**.

Exact numerical values remain prototype and playtest work.

## Family presentation

The families do not require formal player-facing school names. Current working identifiers are design shorthand.

| Working identifier | Core mechanic | Direct matrix state |
|---|---|---|
| Pale silver / twin slash | Echo: delayed additional sword slashes | Approved |
| Gold / cracked crest | Rupture: buildup toward a major posture-impact proc | Approved |
| Violet / binding knot | Seal: visible control marks culminating in Bind | Approved |
| Ivory / blade circle | Rift: one delayed fracture that can be intensified before opening | Approved |
| Crimson / split blood drop | Vulnerable, backstab payoff, and direct Health damage | Approved |

Every direct Technique must remain worthwhile when it is the player's only pickup from that family. Family synergy deepens an already-functional choice rather than completing an otherwise unusable one.

# Pale silver / twin slash — Echo

## Core rule

An **Echo** is a delayed additional sword slash created by a qualifying Technique. Akio does not literally repeat the full action. The delayed slash is the shared scalable mechanic.

## Approved direct roster

| Slot | Technique | Approved qualitative effect |
|---|---|---|
| Basic Attack | **Lingering Cut** | Qualifying Basic hits create a delayed Echo slash on the struck target. |
| Held Attack | **Second Draw** | A landed Held Attack creates one heavier delayed Echo along the original authored attack line. |
| Dash | **Passing Shadow** | A Dash Attack that connects leaves a delayed Echo slash at the contact point or attack line after Akio has moved on. It does not repeat the dash or make Akio act twice. |
| Parry / Counter | **Remembered Reversal** | A successful Counter creates a delayed Echo slash based on the Counter after the original attack resolves. |
| Deathblow | **Final Memory** | A Deathblow produces several delayed Echo slashes around the execution location, threatening nearby surviving enemies. |

# Gold / cracked crest — Rupture

## Core rule

Eligible Gold effects add **Rupture buildup** to a visible enemy meter.

- Partial buildup has no separate debuff or ticking effect.
- Filling the meter immediately triggers **Rupture** and resets it.
- Rupture deals a large burst of posture damage to the target.
- Where the enemy class permits, it also creates a strong readable hit reaction.
- A compact shockwave applies smaller posture pressure to nearby enemies.
- Bosses and protected elites may resist the hard reaction while still taking the intended posture burst.

Rupture is primarily a posture-breaking family. Not every Gold Technique must add buildup; direct posture pressure, guard pressure, impact, and bounded AoE may also belong to the family.

## Approved direct roster

| Slot | Technique | Approved qualitative effect |
|---|---|---|
| Basic Attack | **Rupturing Edge** | Qualifying Basic attacks add Rupture buildup at an Aspect-normalized rate. |
| Held Attack | **Mountain Breaker** | A landed Held Attack creates a compact heavy impact with strong posture and guard pressure. It does not need to add Rupture buildup. |
| Dash | **Breaching Step** | Dash Attack creates a short forward posture-impact shockwave and adds modest Rupture buildup to the primary target. |
| Parry / Counter | **Breaking Reversal** | A successful Counter applies a large amount of Rupture buildup to the attacker. |
| Deathblow | **Shattered Ground** | After the Deathblow resolves, a compact shockwave pressures nearby enemy posture and applies partial Rupture buildup to survivors. |

# Violet / binding knot — Seal

## Core rule

Seal uses discrete visible marks rather than a continuous meter.

- **1 Seal:** minor movement slow.
- **2 Seals:** stronger movement restriction and suppression of qualifying movement abilities such as lunges, leaps, teleports, or retreats where applicable.
- **3 Seals:** the pattern completes and briefly **Binds** the enemy in place.

Bind is a root, not a stun. A Bound enemy may still use attacks valid from its current position. When Bind ends, Seal stacks clear.

Protected boss movement and authored encounter mechanics cannot be invalidated by Seal.

## Approved direct roster

| Slot | Technique | Approved qualitative effect |
|---|---|---|
| Basic Attack | **Sealing Cuts** | Qualifying Basic contact applies Seal at an Aspect-normalized rate. |
| Held Attack | **Binding Draw** | A landed Held Attack applies multiple Seal steps at once, rapidly advancing the pattern toward Bind. |
| Dash | **Warding Step** | Dash Attack applies a Seal. If the struck target is already Sealed, limited Seal pressure can also spread to one nearby enemy. This does not create a persistent ground zone. |
| Parry / Counter | **Counterseal** | A successful Counter applies multiple Seal steps to the struck enemy. |
| Deathblow | **Passing Seal** | After a Deathblow, Seal pressure carries into one nearby surviving enemy, giving the player a meaningful head start toward the next Bind. Exact transferred amount is tuning work. |

# Ivory / blade circle — Rift

## Core rule

Rift is one evolving visible ivory fracture on the target.

- The first qualifying application creates the Rift and starts a short fuse.
- The Rift always opens when the fuse ends, even if it is never developed further.
- Further qualifying applications before opening intensify the same Rift rather than creating exposed stacks.
- Intensification makes the mark visibly spread or worsen and increases the eventual direct Health-damage burst.
- When the Rift opens, it deals direct Health damage and disappears.

Rift is intentionally a strong-upfront, moderate-scaling family. One Rift pickup should already be useful.

## Approved direct roster

| Slot | Technique | Approved qualitative effect |
|---|---|---|
| Basic Attack | **Rift Edge** | Qualifying Basics create a Rift. Further qualifying Basics before it opens intensify the same fracture. |
| Held Attack | **Deep Rift** | Held Attack creates a Rift at high initial intensity or heavily intensifies an existing Rift. |
| Dash | **Shearing Step** | Dash Attack creates a faster-opening Rift. Against an existing Rift, it both intensifies the fracture and accelerates the remaining fuse. |
| Parry / Counter | **Rift Reversal** | A Counter creates a strong Rift if none exists. If a Rift is already present, the Counter heavily intensifies it and forces it open after the Counter resolves. |
| Deathblow | **Parting Rift** | After a Deathblow, a fresh Rift is placed on a nearby surviving enemy rather than wasting the delayed effect on the executed target. |

# Crimson / split blood drop — Vulnerable and direct Health damage

## Family identity

Crimson is the **direct Health-damage and backstab-specialist family**.

Backstabs are universal positional hits based on genuinely striking an enemy from behind. Crimson does not create artificial rear-angle windows, script enemy facing, widen the backstab arc, or slow enemies merely to manufacture a backstab.

## Vulnerable rule

**Vulnerable** is a short enemy status.

- While Vulnerable, genuine backstabs against that enemy deal substantially increased direct Health damage.
- Vulnerable does not make frontal attacks count as backstabs.
- It does not slow, stun, root, alter facing, suppress movement abilities, or change awareness.
- Reapplication may refresh the duration; exact refresh rules are tuning work.

Not every Crimson Technique applies Vulnerable. The family also supports standalone direct Health damage, bounded AoE, and dedicated backstab payoff.

## Approved direct roster

| Slot | Technique | Approved qualitative effect |
|---|---|---|
| Basic Attack | **Open Wound** | Qualifying Basic Attack hits apply Vulnerable for a short duration. Frequent or multi-hit actions use normalized application. |
| Held Attack | **Deep Cut** | A Held Attack that lands as a genuine backstab deals extremely high direct Health damage and partially bypasses defensive mitigation. It does not need to apply Vulnerable. |
| Dash | **Blood Arc** | Dash Attack releases a wide bounded crimson sword arc through the target and nearby enemies for direct Health damage. It has no Vulnerable requirement. |
| Parry / Counter | **Exposed Guard** | A successful Counter applies Vulnerable to the struck enemy. |
| Deathblow | **Predator's Wake** | After a Deathblow resolves, nearby surviving enemies become Vulnerable for a short duration. |

# Later Technique layers — active design area

The direct matrix is no longer the blocker. The following layers may now be designed and reviewed.

## Same-family Supporting Techniques

Supporting Techniques are slotless and deepen a family mechanic without replacing the approved direct slot effects.

Previous exploratory candidates may be reconsidered, but none are approved merely because they appeared in an older draft.

Examples worth revisiting include:

- Echo — **Passing Memory:** an Echo that kills or posture-breaks may continue as a weaker slash toward another enemy.
- Rupture — **Chain Break:** a Rupture may apply partial Rupture buildup to nearby enemies.
- Rupture — **Faultline:** possible boss-oriented repeated-Rupture payoff.

## Cross-family Techniques

Cross-family Techniques may connect mechanics from two already-stable families. They must not be required for either family to function.

## Legendary Techniques

Legendary Techniques should be rare, run-shaping transformations rather than simple large percentage buffs.

Current candidate directions include:

- Echo — **Unforgotten Steel:** a normal Echo creates one additional weaker Echo, with no recursive continuation.
- Rupture — **Heavenbreaker:** a Rupture may trigger sufficiently developed nearby Rupture meters under a bounded non-recursive rule.
- Crimson — **Unseen:** brief invisibility or enemy-awareness suppression that allows Akio to reposition for a backstab; exact trigger, duration, break conditions, boss behavior, and eligibility remain to be designed.

Seal and Rift Legendary directions remain open.

## Refinements

A slotted Technique may receive at most one refinement. A refinement is a small focused improvement to that specific Technique and must preserve its original behavior and reason for selection.

## Rare replacements, rarity, and eligibility

The final catalog still needs:

- rarity assignment across Techniques,
- Legendary eligibility and any prerequisites,
- rare same-slot replacement candidates,
- reward-pool eligibility rules,
- and eventual launch-count decisions for the later Technique layers.

# Validation requirements

The approved direct matrix should remain stable unless playtesting exposes a concrete problem. Later catalog design and implementation should continue checking:

- Wolf, Wraith, and Ronin compatibility,
- boss and isolated-target usefulness,
- group power and AoE limits,
- high-frequency and multi-hit normalization,
- genuine backstab access on important enemies,
- mixed-family readability,
- protected movement/control behavior,
- and whether each family retains a distinct gameplay identity.

## Deferred implementation and balance work

Do not lock exact damage, posture values, Rupture buildup amounts or decay, Seal durations or slow values, Rift fuse/intensity/damage, Vulnerable duration/refresh/backstab multiplier, Deep Cut mitigation bypass, Blood Arc width/damage, Predator's Wake radius, hit reactions, rarity probabilities, offer weights, replacement rates, or final UI/VFX timing until prototyping and roster review require them.
