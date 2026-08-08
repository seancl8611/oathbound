---
id: GAMEPLAY-ASPECT-IDENTITY-GUIDELINES
title: Blood Aspect Identity Guidelines
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-07
topics:
  - blood-aspects
  - aspect-roster
  - weapon-kits
  - wolf
  - wraith
  - ronin
  - encounter-design
  - techniques
related:
  - GAMEPLAY-ASPECT-WEAPON-KIT-MODEL
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-WOLF-ASPECT
  - GAMEPLAY-WRAITH-ASPECT
  - GAMEPLAY-RONIN-ASPECT
  - GAMEPLAY-COMBAT
  - GAMEPLAY-TECHNIQUES
  - META-OPEN-QUESTIONS
---

# Blood Aspect Identity Guidelines

## Evaluation principle

Blood Aspects are complete katana weapon kits that share one control and combat language.

> **Define concrete moves first. Let timing, range, geometry, movement, damage, posture, stagger, commitment, and recovery create the playstyle.**

Do not replace a weapon kit with a required combo loop, movement minigame, target-maintenance rule, or Aspect-specific mastery meter.

## Approved launch roster

| Aspect | Identity | Inherent tradeoffs |
|---|---|---|
| **Wolf** | Fast close-range pressure and pursuit | Short reach, unsafe misses, dangerous positioning after poor pursuit |
| **Wraith** | Extended spectral reach and frontal control | Fewer ordinary options, restrained movement, fixed direction, close/lateral pressure |
| **Ronin** | Slow heavy impact and defensive stability | Slow startup, severe recovery, minimal movement, slow posture recovery |

These three identities complete the launch space. A fourth or fifth Aspect is outside current scope.

## Universal layer

Wolf, Wraith, and Ronin share:

- controller layout,
- neutral locomotion and dash,
- Defense input and ordinary parry timing,
- posture-break and deathblow rules,
- enemy response language,
- Technique rules,
- Prosthetic controls,
- and core combat UI.

No Aspect uses corrective tracking, hidden homing, or post-input target correction. Committed attacks follow the player's chosen direction and their authored line, arc, movement, and collision.

## Tier 0 identity

| Property | Wolf | Wraith | Ronin |
|---|---|---|---|
| Basic sequence | Four hits | Two hits | Three hits |
| Preferred range | Close | Medium-to-long | Medium |
| Cadence | Fastest | Deliberate | Slowest |
| Per-hit Health damage | Moderate | Moderate | Highest |
| Sustained output | Highest while connected | Opening-dependent | Opening-dependent |
| Enemy posture | Repeated pressure | Selected strong spacing tools | Largest clean chunks |
| Ordinary stagger | Moderate | Selective | Strongest |
| Attack movement | Strongly forward | Restrained | Minimal |
| Guard | Balanced | Functional | Strongest |
| Main failure | Overextension | Collapsed spacing / wrong line | Missed commitment / accumulated posture |

Tier 0 must already feel complete. Higher Tiers deepen the kit rather than repair an intentionally weak foundation.

## Sequence guidance

A sequence is a set of available attacks, not an objective.

- Wolf: Fang Slash → Rending Cross → Raking Fang → Blood Cleave.
- Wraith: Veil Cut → Passing Arc.
- Ronin: Severing Cut → Crushing Cross → Bloodfall.

Every attack must remain useful when the sequence ends early.

## Defensive-profile guidance

Every Aspect retains block, parry, dodge, player posture, and deathblows.

Modest differences may use posture capacity, block-posture efficiency, posture recovery, defensive access after attacks, and Parry Counter payoff. Universal parry timing and posture-break consequences remain unchanged.

Ronin's strongest guard is balanced by the slowest posture recovery. Its repeated Tier-growth rule increases only maximum player-posture capacity; it does not increase recovery speed or block efficiency.

## Tier progression guidance

Each Aspect follows one fixed optional Tier path from Tier 0 through Tier IV.

- Every Tier is net-positive.
- A Tier may have one headline benefit and at most one minor supporting rule.
- Supporting rules should reinforce the kit rather than become generic stat inflation.
- Tier 0-I Technique-focused runs, Tier II hybrids, and Tier III-IV Aspect-focused runs must remain viable.
- Mandatory encounters must not assume a specific Tier.

Approved repeated growth:

- **Wolf — Feral Momentum:** later connected Basic positions gain modest increasing Health/posture payoff.
- **Wraith — Spectral Edge:** eligible spectral-only contact gains modest increasing posture/guard pressure.
- **Ronin — Posture capacity:** every Embrace modestly increases maximum player-posture capacity while slow recovery remains unchanged.

## Blood Art differentiation

> **Wolf moves through the battlefield → Wraith controls a chosen corridor → Ronin dominates a chosen point.**

- **Blood Hunt:** one committed pursuit line ending in Blood Fang.
- **Wraith's Reach:** immediate frontal sweep, long fixed corridor, delayed same-geometry echo.
- **Falling Mountain:** planted monumental slam with a compact impact burst and delayed fixed-point Deep Rupture.

Each Blood Art must provide practical activation value while preserving the Aspect's core risk.

## Higher-Tier differentiation

| Tier | Wolf | Wraith | Ronin |
|---|---|---|---|
| **I** | Faster successful-contact flow | Sustained Pale Lance commitment | Optional heavy retaliation after a block |
| **II** | Pursuit Blood Art | Corridor Blood Art | Point-impact Blood Art |
| **III** | Preserve selected aggression through one block | Penetrate layered ordinary formations | Preserve one costly commitment or earn clean Perfect Weight |
| **IV** | Maul qualifying major contacts | Master spectral distance and execution | Drive force through the primary target |

## Production/readability rules

- Wolf must remain visibly close-ranged and forward-committed.
- Wraith must show spectral geometry without implying teleportation, projectiles, or automatic targeting.
- Ronin must feel heavy and stable without becoming generic armored offense.
- Tier effects must not hide enemy telegraphs or make different Aspects look like color swaps.
- Exact values, frames, hitboxes, radii, proc weighting, and presentation timing remain prototype work.

## Approval status

Wolf, Wraith, and Ronin now meet the qualitative Tier 0-IV package standard. The remaining Aspect task is the final cross-roster comparison for overlap, accessibility, encounter coverage, Technique space, and production cost.