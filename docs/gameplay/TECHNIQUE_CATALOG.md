---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-08-09
topics:
  - techniques
  - technique-catalog
  - combat-slots
  - effect-families
  - rupture
  - supporting-techniques
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

This file owns the working Technique roster and the current design state of the five effect families.

`TECHNIQUES.md` owns system rules. The Aspect files own Wolf, Wraith, and Ronin and must not be reopened merely to make a Technique fit.

## Current status

The five-slot Technique architecture is approved, but the roster is being rebuilt around stronger scalable family mechanics.

The earlier draft of roughly 55 Techniques was useful exploration, but it is **not the current launch roster**. Cross-family Techniques and refinements were intentionally removed from the working comparison sheet after the core slotted Techniques exposed larger family-design problems.

Supporting Techniques, cross-family Techniques, Legendary details, and refinements should not be rebuilt until the five core families are coherent.

## Family presentation

The families do not need formal player-facing names. The current working UI identifiers are only shorthand for design comparison:

| Working identifier | Intended recurring mechanic | Current state |
|---|---|---|
| Pale silver / twin slash | Echoes: delayed additional slashes created by qualifying actions | Strong direction; core concepts need a few rewrites |
| Gold / cracked crest | Rupture: buildup toward a large posture-breaking proc, with more AoE emphasis than most families | Rupture rule now has a working definition |
| Violet / binding knot | Seals: buildup and control / suppression | Promising, but seal buildup behavior must be defined before the core set is rewritten |
| Ivory / blade circle | Undecided scalable mechanic; previous precision-only trigger family is insufficient | Redesign required |
| Crimson / split blood drop | Undecided scalable mechanic; previous damage / sacrifice / recovery trigger family is insufficient | Redesign required |

Exact colors, symbols, and final UI treatment remain provisional. The important requirement is that each family has a clear scalable mechanic that can be recognized and upgraded across several combat slots.

# Pale silver / twin slash — Echo family

## Core rule

An **echo** is a delayed additional slash created by a qualifying Technique.

The echo should read practically as another sword slash appearing after the original action. The scalable mechanic is the echo itself, not the idea that Akio literally performs every action twice.

This distinction matters because supporting upgrades can later modify echoes consistently: damage, timing, count, spread, persistence, carried properties, or other bounded behavior.

## Current core-slot pass

| Slot | Working Technique | Current direction |
|---|---|---|
| Basic Attack | Lingering Cut | Keep. Basic hits create a delayed echo slash on the target. |
| Held Attack | Second Draw | Keep. A landed Held Attack creates a delayed echo along the same authored attack line. |
| Dash | Passing Shadow | Redesign. Do not simply repeat the Dash Attack or make Akio act twice; the result should create an echo in a way that scales with the family mechanic. |
| Parry / Counter | Remembered Reversal | Keep concept, rewrite wording. A successful Counter creates a delayed **echo slash** based on the Counter rather than implying Akio performs the Counter again. |
| Deathblow | Final Memory | Keep. Deathblow produces several delayed echo slashes around the executed target. |

### Current supporting notes

- **Passing Memory** remains a strong future supporting concept: an echo that kills or posture-breaks can continue as a weaker slash toward another enemy.
- **Faithful Recall** is deferred until the catalog has enough compatible effects to define what echoes are actually allowed to copy.
- **Layered Intent** is unclear and should not remain in the roster without a cleaner mechanical definition.
- **Unforgotten Steel** remains a promising future Legendary concept: a normal echo creates one additional weaker echo, with no recursive continuation.

# Gold / cracked crest — Rupture family

## Rupture rule — working draft

The previous **Fracture** terminology is removed.

Gold-family buildup is simply called **Rupture buildup**.

- Eligible effects add progress to an enemy's visible **Rupture meter**.
- Partial Rupture buildup has no separate debuff or ticking effect.
- When the meter fills, **Rupture triggers immediately**.
- Rupture then resets the target's Rupture meter to zero.
- Exact buildup amounts, decay timing, and boss-specific reaction strength remain tuning work.

### Rupture proc

When Rupture triggers:

1. the target takes a large burst of posture damage,
2. the target receives a strong readable hit reaction where its enemy class allows it,
3. a compact shockwave around the target applies smaller posture pressure to nearby enemies.

Bosses and protected elites may resist the hard reaction while still taking the intended posture burst.

Rupture is primarily a **posture-breaking buildup mechanic**, not poison, ticking damage, or a generic vulnerability debuff.

Not every Gold Technique must add Rupture buildup. A Gold Technique may instead stay within the same identity through direct posture pressure, guard breaking, impact, or bounded AoE.

## Current core-slot pass

| Slot | Working Technique | Current direction |
|---|---|---|
| Basic Attack | Rupturing Edge | Keep concept; rename from Fracturing Edge. Basic attacks apply Rupture buildup. |
| Held Attack | Mountain Breaker | Keep. A landed Held Attack creates a compact impact burst with heavy posture / guard pressure; it does not need to add Rupture buildup. |
| Dash | Breaching Step | Keep direction. Dash Attack creates a short forward impact / posture shockwave. AoE strength must be carefully bounded. |
| Parry / Counter | Breaking Reversal | Redesign. "More posture damage" alone is too plain for a core Technique. |
| Deathblow | Shattered Ground | Keep family role, but define the exact post-Deathblow AoE behavior before approval. |

### Current supporting notes

- **Deep Fracture** should be renamed if retained; the concept that guarding enemies receive Rupture buildup faster remains promising.
- **Chain Break** remains promising but should use Rupture terminology: a Rupture can apply partial Rupture buildup to nearby enemies.
- **Faultline** may work as a boss-oriented supporting effect, but repeated-Rupture scaling must be defined carefully.
- **Heavenbreaker** remains a promising Legendary direction: a Rupture can trigger other nearby enemies whose Rupture meters are already sufficiently developed.

# Violet / binding knot — Seal family

The central idea remains enemy sealing, restraint, slowing, suppression, and posture-recovery control.

The next question is the **Seal buildup model**.

Before rewriting the five core slots, decide:

- whether Seal uses discrete stacks, a continuous meter, or another visible buildup model,
- whether partial buildup already creates a minor effect,
- what exactly happens at the completed threshold,
- how completed Seal differs from simply having more partial buildup,
- how Seal behaves on bosses and protected elites,
- and how different core actions apply or interact with Seal without all becoming the same Technique.

Current concepts such as Sealing Cuts, Binding Draw, Warding Step, Counterseal, Passing Seal, Suppression, Tightening Bind, Constricting Script, and Sevenfold Seal are **design references only** until this rule is settled.

# Ivory / blade circle — Redesign required

The previous version relied on triggers such as perfect timing, uninterrupted sequences, precision dodges, and perfect parries.

Those are useful **activation conditions**, but they are not enough to define a scalable parent family.

The family needs a concrete recurring effect that can be generated, recognized, strengthened, and used across multiple combat slots. The previous core and supporting concepts are therefore deferred rather than treated as current candidates.

# Crimson / split blood drop — Redesign required

The previous version relied on recent damage, Health sacrifice, retaliation, and Health reclamation.

Those can remain useful mechanics elsewhere, but by themselves they do not create a sufficiently scalable parent-family effect.

The family needs a concrete recurring effect that can be generated and upgraded across multiple combat slots without becoming merely the healing / sacrifice category. The previous core and supporting concepts are deferred rather than treated as current candidates.

# Refinements — deferred

The previous refinement draft is intentionally not part of the active roster while the base Techniques are changing.

The locked system rule remains:

- at most one refinement per eligible slotted Technique,
- a refinement is a small buff to the existing Technique,
- it is not counted or designed as another Technique.

Refinement concepts should be recreated only after the five-by-five core matrix is stable.

# Cross-family Techniques — deferred

The previous cross-family draft is intentionally set aside.

Cross-family Techniques should be designed only after each individual family has a stable scalable mechanic. Otherwise the hybrid effects are built on mechanics that may no longer exist.

# Legendary Techniques — partially deferred

Earlier Legendary ideas may be retained as inspiration, but final Legendary design and eligibility are deferred until the core families are stable.

No Legendary prerequisite threshold is currently locked.

# Current roster-design sequence

1. Lock the Rupture family rule at qualitative gameplay depth.
2. Define the Seal buildup / completion rule.
3. Design a scalable recurring mechanic for the ivory family.
4. Design a scalable recurring mechanic for the crimson family.
5. Revisit the pale-silver Dash and other weak core-slot concepts.
6. Rebuild and approve the full five-by-five slotted Technique matrix.
7. Then rebuild supporting Techniques, cross-family Techniques, Legendaries, and refinements.
8. Audit the completed roster across Wolf, Wraith, Ronin, bosses, groups, trigger frequency, and AoE limits.
9. Only then lock total launch count, rarity distribution, reward frequency, eligibility, and production scope.

## Deferred implementation and balance work

Do not lock exact damage, posture values, Rupture buildup amounts, meter decay timings, AoE radii, hit reactions, rarity probabilities, offer weights, replacement rates, or final UI colors / symbols until prototyping and roster review require them.
