---
id: GAMEPLAY-COMBAT
title: Combat System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-10
---

# Combat System

Oathbound uses top-down action combat centered on katana exchanges, posture pressure, parries, blocks, dodges, counters, and deathblows.

## Core resources and states

- **Health:** conventional survival resource.
- **Posture:** pressure state that creates vulnerability when broken.
- **Spirit emblems:** resource for prosthetic-tool use.
- **Corruption:** run-state pressure tied to Returning Blood and Shrine choices.

## Player action families

- Quick Slash → Cross Cut → Heavy Cleave combo
- Charged thrust
- Counter Cut after successful defense
- Dash Slash
- Sustained block
- Timed parry/perfect deflect
- Directional dash with invulnerability timing
- Generic prosthetic activation
- Deathblow execution

## Response rules

Enemy attacks should communicate the intended response through silhouette and timing:

- Standard attacks: block, parry, dodge, or interrupt depending on context
- Perilous thrusts: narrow forward commitment with a specific counter opportunity
- Sweeps: broad low or circular threat requiring movement/jump-equivalent response as implemented
- Grabs/restraints: special escape, parry, or avoidance rule
- Persistent hazards: repositioning and space management
- Ranged pressure: line awareness, deflection, dodge, or target prioritization

## Posture and deathblows

Posture is not merely a second health bar. It represents control of the exchange. When an enemy's posture breaks, the enemy enters a visually distinct vulnerable state and may become deathblow-ready.

Deathblows are punctuation and reward. Their cues, animation weight, and contact points must remain clear even in crowded encounters.

## Readability hierarchy

From quietest to strongest visual priority:

1. Frequent movement and idle effects
2. Normal hit feedback
3. Standard attack trails/projectiles
4. Parry and mechanic-specific warnings
5. Posture break and deathblow opening
6. Boss phase transition, Shrine choice, or major system state change

## Implementation boundary

Exact frame data, damage values, posture formulas, invulnerability durations, and cancel rules belong in implementation documentation or code. This file owns the design intent and interaction vocabulary.
