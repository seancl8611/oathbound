---
id: GAMEPLAY-COMBAT
title: Combat System
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - katana
  - posture
  - parry
  - deathblow
  - base-moveset
related:
  - CHAR-AKIO
  - GAMEPLAY-BLOOD-ASPECTS
  - UI-HUD
---

# Combat System

Oathbound uses high-angle 2D action combat centered on katana exchanges, posture pressure, parries, blocks, dodges, contextual counters, and deathblows.

## Design goal

The base sword kit should feel expressive without requiring many new buttons. One attack input supports multiple contextual outputs through combo timing, hold/release, post-parry follow-up, and dash-to-attack flow. The system should feel layered rather than overloaded.

## Core resources and states

- **Health:** conventional survival resource.
- **Posture:** pressure state that creates vulnerability when broken.
- **Spirit Emblems:** resource for prosthetic-tool use.
- **Corruption:** run-state pressure tied to Returning Blood and Shrine choices.

## Locked base sword kit

### Quick Slash — Attack 1

Fast, low-commitment opener with a short forward arc. It establishes the exchange rhythm and is the safest attack to test an opening.

### Cross Cut — Attack 2

Slightly slower diagonal/wider follow-up with better coverage against nearby or off-line targets. It connects the opener to a more committed beat.

### Heavy Cleave — Attack 3

Slower combo finisher with higher posture damage and more recovery risk. It should reward commitment only when the player has earned the opening.

### Hold Thrust

Hold the attack input, then release to thrust. The move uses a narrow forward hitbox, strong single-target posture damage, and spacing/punish utility. It is intentionally weak against side movement and crowds.

### Counter Cut

After a successful parry/deflect, pressing attack produces a quick follow-up slash. It is not automatically a deathblow and does not require the enemy's posture to be broken. It deals light-to-medium damage with strong posture pressure.

### Dash Slash

Press attack during the late dash or shortly after the dash to perform a quick re-entry slash. This allows the dash to flow into offense instead of functioning only as defense.

## Additional action families

- Sustained block
- Timed parry/perfect deflect
- Directional dash with invulnerability timing
- Generic prosthetic activation
- Deathblow execution

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

Deathblows are punctuation and reward. Their cues, animation weight, and contact points must remain clear even in crowded encounters.

## Animation requirements

Akio's base sword library requires distinct animations for:

- `quick_slash`
- `cross_cut`
- `heavy_cleave`
- `thrust_charge` / hold
- `thrust_release`
- `counter_cut`
- `dash_slash`

These are in addition to core movement, parry, block, hurt, death, deathblow, and prosthetic-use states.

## VFX requirements

- Clean, distinct sword trails for all three combo attacks
- Narrow thrust-line treatment
- Counter Cut spark/flash that follows a successful deflect
- Dash Slash motion trail
- Effects must not obscure attack direction, guard state, parry timing, or deathblow readiness

## Readability hierarchy

From quietest to strongest visual priority:

1. Frequent movement and idle effects
2. Normal hit feedback
3. Standard attack trails and projectiles
4. Parry and mechanic-specific warnings
5. Posture break and deathblow opening
6. Boss phase transition, Shrine choice, or major system state change

## Implementation boundary

Exact frame data, damage values, posture formulas, invulnerability durations, input buffers, and cancel rules belong in implementation documentation or code. This file owns the design intent, move roles, and interaction vocabulary.
