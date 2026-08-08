---
id: GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
title: Blood Aspect Weapon-Kit Model
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-07
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

Blood Aspects create three distinct melee weapon styles while preserving one recognizable Akio and one shared combat language.

> **The moves create the playstyle.**

## Shared action model

| Input | Aspect-owned output |
|---|---|
| Basic Attack | Sequence, cadence, geometry, reach, movement, and recovery |
| Held Attack | Major secondary or committed sword action |
| Dash Attack | Offensive follow-up after the universal neutral dash |
| Parry Counter | Direct sword response after the universal parry |
| Blood Art | Tier II Blood-powered signature package |

All three Aspects share controller layout, locomotion, neutral dash, Defense input, parry timing, posture-break rules, deathblows, enemy response language, Techniques, Prosthetics, and core HUD language.

No Aspect receives corrective tracking, hidden homing, or post-input target correction. Attacks use player-selected direction, authored geometry, authored movement, and normal collision.

## Differentiation rules

Aspect identity may differ through:

- Basic sequence length and cadence,
- startup and recovery,
- reach and hit geometry,
- attack-bound movement,
- Health damage and enemy-posture pressure,
- stagger and guard pressure,
- commitment and whiff risk,
- Held, Dash, and Parry Counter purpose,
- modest defensive profile,
- fixed Tier progression,
- Blood Art,
- and Returning Blood presentation.

A sequence is a set of available attacks, not a combo objective. The player may stop, defend, dash, redirect, use a Prosthetic, or disengage after any legal point.

## Defensive-profile boundary

Every Aspect retains block, parry, dodge, player posture, and deathblows.

Modest differences may use player-posture capacity, block-posture efficiency, posture recovery, access to defense after attacks, and Parry Counter payoff. Universal parry timing and posture-break consequences do not change.

Approved examples:

- Wolf's Fanged Guard preserves one selected commitment through a normal posture-costing frontal block.
- Ronin has the strongest baseline guard and gains modest maximum player-posture capacity at each Embrace, but retains the slowest posture recovery.
- Ronin's Unbroken Resolve preserves selected late commitments through one costly eligible hit without reducing incoming damage.

## Approved launch roster

| Aspect | Tier 0 sequence | Primary identity | Primary risk |
|---|---|---|---|
| **Wolf** | Fang Slash → Rending Cross → Raking Fang → Blood Cleave | Fast close pressure, pursuit, sustained output | Short reach and overextension |
| **Wraith** | Veil Cut → Passing Arc | Extended spectral reach and frontal control | Close/lateral collapse and wrong-line commitment |
| **Ronin** | Severing Cut → Crushing Cross → Bloodfall | Heavy impact and defensive stability | Slow startup, severe whiff recovery, accumulated posture |

Supporting actions:

| Aspect | Held | Dash Attack | Parry Counter |
|---|---|---|---|
| Wolf | Predator's Passage | Hunting Slash | Fang Reversal |
| Wraith | Pale Lance | Ghostline Slash | Veil Reversal |
| Ronin | Stillness Draw | Breaching Slash | Answering Steel |

## Fixed Tier packages

| Tier | Wolf | Wraith | Ronin |
|---|---|---|---|
| **I** | Blood Tempo | Pale Barrage | Steadfast Reprisal |
| **Growth** | Feral Momentum: later connected Basics gain increasing Health/posture payoff | Spectral Edge: eligible spectral-only contact gains increasing posture/guard pressure | Maximum player-posture capacity increases modestly at each Embrace |
| **II** | Blood Hunt / Blood Fang | Wraith's Reach | Falling Mountain / Deep Rupture |
| **III** | Fanged Guard | Spectral Passage | Unbroken Resolve / Measured Weight / Perfect Weight |
| **IV** | Apex Mauling | Beyond the Veil | Shattering Wake |

### Wolf

Wolf is the fastest and shortest-ranged kit. It uses authored forward movement and sustained contact to pressure and pursue. Later Tiers improve flow, reward connected sequence positions, add one full-meter pursuit Art, preserve selected commitments through one frontal block, and add a contact-gated mauling capstone.

### Wraith

Wraith has the longest average melee reach and the fewest Basic attacks. It uses narrow lines, broad frontal arcs, restrained movement, and spacing-sensitive posture pressure. Later Tiers add stationary Pale Lance continuation, a corridor Blood Art, formation penetration, greater spectral reach, extended clear-path deathblows, and brief post-kill movement.

### Ronin

Ronin has the slowest cadence, highest per-hit impact, strongest ordinary-enemy stagger, and strongest guard. Later Tiers add an optional block retaliation, a planted point-dominating Blood Art, costly commitment preservation versus clean-execution Perfect Weight, formation-breaking Shattering Wake, and modest maximum-posture growth at every Embrace.

## Blood Art distinction

> **Wolf moves through the battlefield → Wraith controls a chosen corridor → Ronin dominates a chosen point.**

The three Blood Arts should remain mechanically and visually distinct rather than becoming different versions of the same damage burst.

## Technique compatibility

Ordinary Techniques target universal action tags such as Basic Attack, Held Attack, Dash Attack, Parry Counter, Block, Parry, Deathblow, Prosthetic, Health, Enemy Posture, Player Posture, and Movement.

Techniques may reinforce, broaden, compensate for, or hybridize an Aspect. They should not simply duplicate a fixed Tier mechanic or Blood Art.

## Production lock boundary

All three qualitative Tier 0-IV packages are approved for the final cross-roster comparison.

Exact frame data, damage, posture, stagger, reach, movement, recovery, collision, proc weighting, Blood values, Tier-growth percentages, animation counts, and VFX timing remain implementation and playtesting work.

A fourth or fifth Aspect remains outside launch scope unless playable evidence later demonstrates a missing identity that cannot be solved through Wolf, Wraith, Ronin, Techniques, Prosthetics, or encounter design.