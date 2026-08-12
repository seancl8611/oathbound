---
id: GAMEPLAY-TECHNIQUE-CATALOG
title: Technique Catalog
category: gameplay
status: draft
authority: primary
last_reviewed: 2026-08-11
topics:
  - techniques
  - technique-catalog
  - combat-slots
  - effect-families
  - rupture
  - seals
  - rift
  - burst
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

The five-slot Technique architecture is approved. All five core families now have a defined qualitative mechanic, but the final five-by-five direct Technique matrix is not yet approved.

The earlier draft of roughly 55 Techniques was useful exploration, but it is **not the current launch roster**. Cross-family Techniques and refinements were intentionally removed from the working comparison sheet after the core slotted Techniques exposed larger family-design problems.

Supporting Techniques, cross-family Techniques, Legendary details, and refinements should not be rebuilt until the direct five-by-five family matrix is coherent.

## Family presentation

The families do not need formal player-facing names. The current working UI identifiers are only shorthand for design comparison:

| Working identifier | Intended recurring mechanic | Current state |
|---|---|---|
| Pale silver / twin slash | Echoes: delayed additional slashes created by qualifying actions | Core mechanic defined; some slot concepts need rewrites |
| Gold / cracked crest | Rupture: buildup toward a large posture-breaking proc, with bounded nearby posture pressure | Core mechanic defined |
| Violet / binding knot | Seal stacks: visible marks that progressively restrict enemy movement and complete into a brief Bind | Core mechanic defined |
| Ivory / blade circle | Rift: one visible fracture mark that automatically opens for Health damage and becomes stronger when further intensified before opening | Core mechanic defined |
| Crimson / split blood drop | Burst: immediate close-range AoE blast centered on a struck target, followed by a readable per-target recharge accelerated by continued close-range pressure | Core mechanic defined |

Exact colors, symbols, names, and final UI treatment remain provisional. The important requirement is that each family has a clear scalable mechanic that can be recognized and upgraded across several combat slots.

The five families are not required to share the same buildup structure or power curve. Rift and Burst are intentionally allowed to offer stronger immediate value from a first pickup, while more setup-oriented families may gain more from deeper synergy.

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
| Parry / Counter | Remembered Reversal | Keep concept, rewrite wording. A successful Counter creates a delayed echo slash based on the Counter rather than implying Akio performs the Counter again. |
| Deathblow | Final Memory | Keep. Deathblow produces several delayed echo slashes around the executed target. |

### Current supporting notes

- **Passing Memory** remains a strong future supporting concept: an echo that kills or posture-breaks can continue as a weaker slash toward another enemy.
- **Faithful Recall** is deferred until the catalog has enough compatible effects to define what echoes are actually allowed to copy.
- **Layered Intent** is unclear and should not remain in the roster without a cleaner mechanical definition.
- **Unforgotten Steel** remains a promising future Legendary concept: a normal echo creates one additional weaker echo, with no recursive continuation.

# Gold / cracked crest — Rupture family

## Rupture rule

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

## Seal rule

Violet Techniques apply visible **Seal stacks** rather than filling a continuous meter.

The stack pattern is both the mechanic and the enemy-facing visual:

- **1 Seal:** one violet mark appears on the enemy and causes a minor movement-speed reduction.
- **2 Seals:** a second mark appears, the marks begin connecting, movement is reduced more strongly, and qualifying movement abilities such as lunges, leaps, teleports, or retreats are restricted where applicable.
- **3 Seals:** the pattern completes and the enemy becomes **Bound** for a short time.

A Bound enemy is rooted in place but can still perform attacks that are valid from its current position. The Bind is control, not a stun. When the Bind ends, the Seal stacks are cleared and must be built again.

Exact slow values, Bind duration, stack duration / expiry, and protected-enemy exceptions remain tuning work. Bosses and protected elites must not have authored encounter mechanics invalidated by Seal; exact resistance behavior will be defined during enemy-system integration.

## Visual treatment

Seal should be readable directly on the enemy without a separate buildup meter:

1. first violet mark appears,
2. second mark appears and a faint line or binding pattern connects them,
3. third mark completes the pattern,
4. the completed pattern visibly tightens or closes while the target is Bound,
5. the pattern breaks or fades when Bind ends and stacks reset.

Color cannot be the only identifier; the count and changing seal shape must remain readable.

## Current core-slot direction

| Slot | Working Technique | Current direction |
|---|---|---|
| Basic Attack | Sealing Cuts | Repeated Basic contact applies Seal stacks at an appropriate normalized rate. |
| Held Attack | Binding Draw | A landed Held Attack applies multiple Seal stacks at once rather than using a separate instant-Seal rule. |
| Dash | Warding Step | Dash Attack leaves a short-lived seal mark on the ground; an enemy crossing it gains a Seal stack. |
| Parry / Counter | Counterseal | Landing the Counter applies multiple Seal stacks to the attacker. |
| Deathblow | Passing Seal | Deathblowing an enemy transfers or distributes its remaining Seal value into nearby surviving enemies. Exact distribution remains to be designed. |

These are working slot directions, not yet the final five approved Technique implementations.

### Family boundary

Violet is primarily about **restricting enemy movement and positioning**.

It should not become another posture family. Seal does not inherently damage posture, stop posture recovery, or trigger a posture burst. Those functions belong elsewhere unless a later specific cross-family Technique intentionally connects them.

Supporting, Legendary, and refinement ideas for Violet remain deferred until the core five-slot implementation is stable.

# Ivory / blade circle — Rift effect

## Rift rule

Rift is a delayed direct-Health-damage effect represented by **one evolving visible fracture mark** on the target.

- A qualifying Rift Technique creates a thin ivory fracture-line across the enemy.
- The first application starts a short fuse.
- The Rift is guaranteed to **open** when that fuse ends, even if the player never applies Rift again.
- Additional qualifying Rift applications before it opens **intensify the same Rift** rather than adding separately displayed stacks.
- Intensifying a Rift makes the visible fracture spread, become more prominent, and increases the eventual direct Health-damage burst.
- When the Rift opens, the mark violently splits / flashes through the target, deals its damage, and disappears.

The player should experience one wound-like supernatural fracture becoming increasingly unstable, not a visible five-stack counter or another buildup meter.

Exact fuse duration, maximum intensity, application strength by slot, burst damage, and boss scaling remain tuning work.

## Intended power curve

Rift is deliberately a **strong-upfront, moderate-scaling** family.

One Rift Technique should already produce reliable additional damage because even a minimally intensified Rift still opens. More Rift investment improves intensity, frequency, or payoff, but the family does not need the highest late-run synergy ceiling.

## Visual treatment

Rift must work without precise sprite alignment or a literal sword-stabbing-through animation.

The readable sequence is:

1. a thin ivory fracture-line appears on the enemy,
2. further Rift applications cause the same line to spread / branch and become brighter or more unstable,
3. the developed mark briefly pulses before opening,
4. the Rift violently splits or flashes through the target,
5. the mark disappears immediately after the burst.

The effect is supernatural but should remain compact and sword-adjacent rather than becoming an unrelated spell effect.

## Core-slot design direction

The exact five Rift Techniques are still to be approved. The slot pass should determine which actions primarily **apply**, **intensify**, **accelerate**, or potentially **force open** a Rift while preserving the same shared mechanic.

High-frequency actions must use normalized Rift application so Wolf or multi-hit actions do not gain accidental dominance.

# Crimson / split blood drop — Burst effect

## Burst rule

Crimson is the close-range direct-AoE family.

A qualifying Crimson Technique can trigger **Burst** on the struck target when that target is Burst-ready.

- Burst is centered on the struck enemy.
- The primary target takes direct Health damage from the Burst, so the mechanic remains useful against bosses and isolated elites.
- Nearby enemies inside the bounded blast also take direct Health damage.
- Burst resolves immediately; the core family does not create a persistent damaging zone.
- After Burst triggers, that target enters a short recharge state before it can Burst again.
- Continued **close-range direct sword hits** against that same target accelerate Burst recovery, rewarding aggressive close-quarters combat.
- Burst damage cannot trigger additional Bursts.
- Multi-target trigger rules must prevent one swing from recursively detonating an entire pack.

Exact Burst damage, radius, base recharge, close-range recovery acceleration, and multi-target trigger limits remain tuning work.

## Intended power curve

Burst should provide **strong early value** with a single Technique: immediate direct damage, immediate AoE, and no buildup requirement before the first proc.

Additional Crimson investment should remain valuable through stronger blasts, improved radius, better recovery, stronger central-target damage, and specialized slot interactions. It can remain balanced later without needing the highest multiplicative scaling ceiling.

## Close-range identity

Crimson should reward fighting near the target rather than simply becoming a generic AoE family.

The core incentive is that staying engaged with direct close-range sword attacks helps the target become Burst-ready again sooner. This should not use broad low-Health thresholds or inconsistent "below 50% Health" bonuses as the main family rule.

## Visual / cooldown language

The player needs to read both **which target can Burst** and **when that target is recharging**.

Working presentation:

1. a compact crimson split-blood-drop marker or equivalent family cue shows that the target is Burst-ready,
2. triggering Burst makes that cue flash as a concentrated crimson impact forms on / under the target,
3. a short, heavy radial crimson blast expands and disappears immediately,
4. during recharge, the marker becomes visibly dim / separated / incomplete,
5. as recovery completes, the split form closes or brightens back into the ready state.

Exact marker placement and animation remain UI/VFX work. The ready / recharge distinction must remain understandable without relying on color alone.

## Core-slot design direction

The exact five Crimson Techniques are still to be approved. The slot pass should vary **blast strength, footprint, trigger access, and recovery interaction** while preserving the shared close-range Burst identity.

Persistent crimson ground effects may be explored later as supporting or higher-rarity upgrades, but they are not part of the base Burst rule.

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

1. Revisit the pale-silver Dash and other weak Echo concepts.
2. Revisit weak Gold and Violet core-slot concepts.
3. Design the five Rift slot Techniques around apply / intensify / accelerate / open interactions.
4. Design the five Crimson slot Techniques around direct Burst, close-range pressure, and readable recharge.
5. Rebuild and approve the full five-by-five slotted Technique matrix.
6. Audit the completed roster across Wolf, Wraith, Ronin, bosses, groups, trigger frequency, mixed-family compatibility, and AoE / control limits.
7. Then rebuild supporting Techniques, cross-family Techniques, Legendaries, and refinements.
8. Only then lock total launch count, rarity distribution, reward frequency, eligibility, and production scope.

## Deferred implementation and balance work

Do not lock exact damage, posture values, Rupture buildup amounts, meter decay timings, Seal slow values, Seal durations, protected-enemy control resistance, Rift fuse / intensity values, Burst damage / radius / cooldown, close-range Burst recovery rates, hit reactions, rarity probabilities, offer weights, replacement rates, or final UI colors / symbols until prototyping and roster review require them.
