---
id: GAMEPLAY-COMBAT
title: Combat System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-26
topics:
  - katana
  - posture
  - parry
  - deathblow
  - base-moveset
related:
  - CHAR-AKIO
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-PROSTHETICS
  - UI-HUD
---

# Combat System

Oathbound uses high-angle 2D action combat centered on katana exchanges, posture pressure, parries, blocks, dodges, contextual counters, deathblows, and readable arena pressure.

## Design goal

The sword system should feel expressive without requiring many new buttons. One attack input supports multiple contextual outputs through repeated presses, hold/release, post-parry follow-up, and dash-to-attack flow. The system should feel layered rather than overloaded.

Bosses and larger encounters may use projectiles, ground danger, area denial, adds, movement tests, and clear attack opportunities. Combat should reward mastery without requiring one-mistake death or strict memorization as the default run experience.

## Core resources and states

- **Health:** conventional survival resource.
- **Posture:** pressure state that creates vulnerability when broken.
- **Spirit Emblems:** resource for prosthetic-tool use.
- **Corruption:** run-state pressure tied to Returning Blood and Shrine choices.

## Shared control and action framework

The control layout and contextual action slots remain recognizable across Blood Aspects. The exact sword move produced by those inputs belongs to the selected Aspect.

### Basic attack input

Repeated presses produce the selected Aspect's basic offensive sequence.

An Aspect may use:

- a one-, two-, three-, or otherwise justified finite sequence,
- different action names and animations,
- branches or contextual continuation,
- different movement, tracking, coverage, commitment, and recovery,
- or no conventional repeating combo if another readable sequence better expresses the identity.

No universal three-hit chain is required. `Quick Slash`, `Cross Cut`, and `Heavy Cleave` are no longer the names or mandatory roles of shared attacks; they may remain names within an individual Aspect where appropriate.

### Held attack input

Holding and releasing the attack input produces the selected Aspect's committed held attack. Its range, movement, geometry, target interaction, damage-versus-posture profile, and tactical purpose may differ by Aspect.

### Counterattack input

After a successful parry, pressing attack produces the selected Aspect's defense-to-offense follow-up. Parry timing and success rules remain shared even when the resulting counterattack differs.

### Dash attack input

Pressing attack during the approved late-dash window or shortly after a dash produces the selected Aspect's movement-to-offense attack. The neutral dash remains shared; the chosen offensive commitment after it may differ.

### Additional shared action families

- Sustained block
- Timed parry/perfect deflect
- Directional dash with invulnerability timing
- Generic prosthetic activation
- Deathblow execution

All current launch candidates retain meaningful access to attack, defense, movement, posture pressure, deathblows, Techniques, and the equipped prosthetic. Removing a major action family requires a later explicit roster-level decision and encounter-compatibility review.

## Universal neutral movement and dash contract

Aspect selection must not weaken Akio's dependable ability to evade attacks or navigate combat spaces.

At the launch baseline, every Aspect shares the same functional neutral:

- running and ordinary locomotion speed,
- dash travel distance,
- dash travel speed,
- startup timing,
- invulnerability window,
- neutral dash recovery,
- repeat-dash availability,
- directional support and steering rules,
- collision and hazard interaction,
- and standard access to movement, block, parry, and non-dash actions after the dash.

Exact numerical values remain implementation and playtesting work, but the functional values are common across Aspects. A slower or shorter neutral dash must not be used as an automatic Aspect weakness.

Aspects may still differ through:

- animation and Blood VFX that preserve the same functional timing,
- the attack selected after a dash,
- movement committed by that attack,
- attack tracking, geometry, damage, posture pressure, and recovery,
- the position where that attack ends,
- and the sequence or transition entered after the attack.

The neutral dash gets Akio out of danger consistently. The dash attack expresses the Aspect.

Techniques, Relics, temporary effects, Corruption, or later exceptional mechanics may modify movement only after explicit approval. Major reductions require a clear compensating solution and encounter-wide testing.

## Shared defense and posture language

All launch Aspects use the same defense input, parry timing logic, enemy telegraphs, and posture-break language.

The roster may later approve relative differences in:

- player posture capacity,
- posture recovery behavior,
- posture damage received while blocking,
- and the offensive continuation after blocking or parrying.

These differences must reinforce identity without making enemy patterns incompatible or turning one Aspect into an unrelated character. Whether any future Aspect removes sustained block entirely remains unresolved and requires explicit approval; it is not part of the current shared baseline.

## Technique relationship

Techniques may modify the timing reward, resource return, target condition, posture pressure, movement follow-up, execution payoff, or prosthetic behavior associated with approved combat actions.

They must not:

- replace the Aspect's sword foundation with unrelated spell rotations,
- create a new button for every Technique,
- obscure attack direction or enemy response rules,
- make parry, posture, movement, or deathblows broadly optional,
- depend on an exact multi-Technique combination to function,
- or require separate Wolf, Wraith, and Ronin versions of an otherwise ordinary Technique.

Each Technique remains owned by [Technique System](TECHNIQUES.md). This file owns the shared control, response, movement, and combat-action vocabulary; the selected Aspect owns the exact offensive expression.

## Response rules

Enemy attacks should communicate the intended response through silhouette, timing, and consistent visual language:

- **Standard attacks:** block, parry, dodge, or interrupt depending on context.
- **Perilous thrusts:** narrow forward commitment with a specific counter opportunity.
- **Sweeps:** broad low or circular threat requiring movement or the implemented sweep response.
- **Grabs/restraints:** special escape, parry, or avoidance rule.
- **Persistent hazards:** repositioning and space management.
- **Ranged pressure:** line awareness, deflection, dodge, or target prioritization.

## Posture and deathblows

Posture is not a second health bar. It represents control of the exchange. When an enemy's posture breaks, the enemy enters a visually distinct vulnerable state and may become deathblow-ready.

Deathblows are punctuation and reward. Their cues, animation weight, and contact points must remain clear even in crowded encounters or when Execution Techniques trigger additional effects.

## Animation requirements

Akio requires one shared defensive, movement, hurt, death, deathblow, and prosthetic-use language.

Each approved Aspect may additionally require distinct offensive animations for:

- its basic attack sequence,
- held attack,
- post-parry counterattack,
- dash attack,
- and any explicitly approved contextual transition.

Reuse is preferred where it preserves identity and readability. The previous assumption of one mandatory `quick_slash`, `cross_cut`, `heavy_cleave`, `thrust_release`, `counter_cut`, and `dash_slash` library for every Aspect is superseded.

Exact animation counts remain blocked until the three-Aspect roster and overlap audit are approved.

## VFX requirements

- Each Aspect's frequent sword trails must communicate attack direction and reach.
- Held, counter, and dash attacks require readable treatment appropriate to the selected Aspect.
- Different Blood forms must not obscure guard state, parry timing, hazards, enemy telegraphs, or deathblow readiness.
- Technique cues should reuse approved combat, Aspect, and prosthetic language before requiring bespoke effects.

## Readability hierarchy

From quietest to strongest visual priority:

1. Frequent movement and idle effects
2. Normal hit and passive Technique feedback
3. Standard attack trails and projectiles
4. Technique thresholds, parry, and mechanic-specific warnings
5. Posture break and deathblow opening
6. Boss phase transition, Shrine choice, or major system state change

## Implementation boundary

Exact frame data, damage values, posture formulas, invulnerability durations, input buffers, cancel rules, Technique values, and encounter tuning belong in implementation documentation or code. This file owns the design intent, shared controls, neutral movement contract, action slots, and interaction vocabulary.