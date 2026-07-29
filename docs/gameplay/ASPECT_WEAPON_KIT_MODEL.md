---
id: GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
title: Blood Aspect Weapon-Kit Model
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-28
topics:
  - blood-aspects
  - weapon-kits
  - combat-foundation
  - shared-controls
  - techniques
related:
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
  - GAMEPLAY-COMBAT
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Blood Aspect Weapon-Kit Model

## Purpose

Blood Aspects create the playstyle separation of distinct melee weapons while preserving one recognizable version of Akio.

The player keeps the same controller layout, neutral movement, enemy rules, posture and deathblow language, Technique system, and prosthetic framework. The selected Aspect changes the Blood-formed katana kit assigned to the shared offensive inputs.

> **The moves create the playstyle. The player should not need to maintain a separate objective, combo state, prescribed movement loop, or Aspect-specific mastery meter to use an Aspect correctly.**

An Aspect feels different because its attacks have different timing, reach, geometry, player-directed movement, commitment, recovery, damage, posture pressure, target handling, stagger, and impact.

## Shared action model

| Shared action slot | Aspect-owned output |
|---|---|
| Basic Attack | Primary sequence, cadence, geometry, reach, movement, and recovery |
| Held Attack | Major secondary sword action or committed option |
| Dash Attack | Offensive action after the universal neutral dash |
| Parry Counter | Direct sword response after the universal parry |
| Blood Art | Tier II Blood-powered signature package finalized through fixed progression |

The Held Attack is a genuine secondary action. It does not need to be one universal thrust or only a charged Basic Attack.

## Universal movement and combat language

The following remain functionally universal across Wolf, Wraith, and Ronin:

- controller layout and input mapping,
- ordinary locomotion,
- neutral dash distance, speed, startup, invulnerability, recovery, steering, collision, and repeat availability,
- defense input,
- parry timing and success rules,
- enemy telegraphs and intended responses,
- posture-break, stagger, and deathblow rules,
- deathblow eligibility and execution behavior,
- Spirit and prosthetic controls,
- Technique slots, acquisition, reserve, replacement, and refinement rules,
- and combat interface language.

No Aspect receives a weaker or stronger neutral dash. Neutral movement is not a balance penalty.

## Player-directed attack rule

No Aspect uses corrective tracking, hidden homing, or post-input target correction.

An attack may use:

- the direction selected by the player before commitment,
- its authored arc or line,
- authored forward travel,
- and normal collision with valid targets and geometry.

Once a committed action begins, it does not curve toward a moving enemy or rotate Akio automatically. Distinct target handling should come from reach, arcs, travel, collision, and player aim.

A signature move may pass through an eligible enemy only when that behavior is explicitly authored, the attack connects, and the far-side destination is safe and valid. This is not target correction.

## Defensive-profile boundary

Block, parry, dodge, player posture, and deathblows remain available to every Aspect.

Modest defensive differences may use:

- player-posture capacity,
- posture damage received while blocking,
- posture recovery direction,
- recovery into defense after an attack,
- and Parry Counter payoff.

Parry timing, success conditions, defense input, posture-break consequences, and enemy response rules remain universal.

A defensive difference cannot be the Aspect's entire identity. No Aspect removes block or parry, gains automatic counters, becomes immune to posture break, or recovers posture freely while actively guarding.

A fixed Tier benefit may protect a specific authored action, such as Wolf's Fanged Guard blocking one frontal blockable hit during a Held Attack charge. Such benefits must use normal shared rules and must not silently rewrite universal defense.

## Aspect-owned differentiation

An Aspect may differ through:

- Basic Attack sequence length and order,
- startup, active time, and recovery,
- cadence,
- reach and hit geometry,
- attack-bound movement,
- per-hit and sustained health damage,
- enemy-posture pressure,
- ordinary-enemy stagger,
- commitment and whiff risk,
- target-transfer behavior through player aim and attack geometry,
- Held Attack purpose,
- Dash Attack purpose,
- Parry Counter purpose,
- modest defensive profile,
- fixed Tier progression,
- Blood Art,
- and Returning Blood presentation.

These properties must combine into a coherent weapon kit. One unusual rule or altered statistic is not sufficient.

## Sequence boundary

A sequence is a set of available attacks, not a required objective.

The player may stop, continue, defend, dash, change targets, use a Prosthetic, or abandon the sequence. Doing so must not feel like failing an Aspect minigame.

Do not build an Aspect around maintaining a combo state, preserving a sequence through unrelated actions, reaching a named finisher as the central goal, or repeating one prescribed loop.

## Approved launch cadence

| Aspect | Basic sequence | Purpose |
|---|---:|---|
| Wolf | Four attacks | Longest and fastest sustained pressure pattern with player-directed pursuit and nearby target transfer |
| Wraith | Two attacks | Short extended-range pokes and quick return to movement or defense |
| Ronin | Three attacks | Slower escalating impact without making the final strike mandatory |

Each attack must remain useful when the sequence ends early.

## Movement boundary

Attack movement is valid when it belongs naturally to the sword action. Forced repositioning must not substitute for a complete weapon identity.

Avoid mandatory lateral movement, every counter changing position, every dash attack ending at a special offset, or movement-direction input selecting unrelated sword attacks.

An explicitly authored signature action may cross an eligible ordinary enemy along its original attack line. It must not automatically select, chase, or rotate toward that enemy.

Spacing should emerge from reach, geometry, player-directed travel, commitment, and recovery.

## Technique compatibility

Ordinary Techniques use universal action tags rather than Aspect-specific move names:

- Basic Attack,
- Held Attack,
- Dash Attack,
- Parry Counter,
- Block,
- Parry,
- Deathblow,
- Prosthetic,
- Health,
- Enemy Posture,
- Player Posture,
- and Movement.

A Technique applies one rule across all Aspects. Different outcomes emerge naturally from the underlying kit.

Examples:

- a Basic Attack Technique affects Wolf's four-hit sequence, Wraith's two-hit sequence, and Ronin's three-hit sequence through one rule,
- a Held Attack Technique applies to Predator's Passage, Pale Lance, and Stillness Draw,
- a Dash Attack Technique modifies Hunting Slash, Ghostline Slash, and Breaching Slash without changing the neutral dash,
- a Parry Counter Technique modifies each direct counter without changing parry timing.

Techniques should not duplicate a fixed Tier benefit or Blood Art without explicit approval.

## Approved launch roster

### Wolf — pressure and pursuit

- Fang Slash → Rending Cross → Raking Fang → Blood Cleave,
- fastest cadence and shortest reach,
- strong player-directed forward movement,
- moderate per-hit damage with high sustained output,
- Predator's Passage, Hunting Slash, and Fang Reversal,
- fixed progression through Blood Tempo, Dire Hunt, Fanged Guard, and Apex Feast,
- failure state: overextension after missed pursuit or prolonged pressure.

### Wraith — reach and control

- Veil Cut → Passing Arc,
- longest effective melee reach,
- long lines, broad arcs, restrained movement, and short commitments,
- Pale Lance, Ghostline Slash, and Veil Reversal,
- failure state: point-blank, cramped, or multi-directional pressure.

### Ronin — impact and stability

- Severing Cut → Crushing Cross → Bloodfall,
- slowest cadence and conventional medium reach,
- highest per-hit damage, posture pressure, and ordinary-enemy stagger,
- minimal movement and severe recovery,
- Stillness Draw, Breaching Slash, and Answering Steel,
- strongest guard profile balanced by slow posture recovery,
- failure state: missed heavy commitment and accumulated posture.

The roster deliberately leaves mobility, evasion, ranged utility, and broad crowd-control specialization to universal systems, Techniques, prosthetics, and encounter design.

## Professional kit test

A weapon kit is complete only when a designer can answer:

1. What happens on one and repeated Basic Attack presses?
2. What distinct purpose does Held Attack serve?
3. What attack follows the universal dash?
4. What response follows the universal parry?
5. What are the kit's range, timing, geometry, movement, damage, posture, stagger, commitment, and recovery characteristics?
6. What natural strengths and weaknesses emerge from the moves?
7. Does the kit work against groups, ranged pressure, elites, hazards, and bosses?
8. Can Techniques reinforce, broaden, compensate, and hybridize it?
9. Can the kit be explained as a weapon style rather than a behavioral instruction?

Wolf, Wraith, and Ronin meet this test at qualitative Tier 0 depth.

## Fixed progression boundary

Every selected Aspect follows one fixed Tier path from Tier 0 to Tier IV through Shrine Embrace choices. The Tier path is not a branching package selection.

Wolf's fixed Tier package is approved as a working draft for current scoping. Wraith and Ronin remain the next package-design work. After all three are drafted, compare their power, accessibility, production cost, drawback severity, and Technique overlap before final production lock.

## Future roster capacity

A fourth or fifth Aspect is outside current launch paper-design and production scope. Expansion requires playable evidence of a missing identity that cannot be addressed through Wolf, Wraith, Ronin, Techniques, prosthetics, or encounter design.