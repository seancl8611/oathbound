---
id: CONTENT-AREA1-IMPLEMENTATION-BASELINE
title: Hushiro Implementation Baseline
category: content
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - area-1
  - hushiro
  - implementation
  - encounters
  - rooms
  - minibosses
  - keeper
related:
  - CONTENT-AREA1-OVERVIEW
  - CONTENT-AREA1-ENEMIES
  - CONTENT-AREA1-MINIBOSSES
  - CONTENT-AREA1-BOSS
  - CONTENT-AREA1-ENVIRONMENT
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-COMBAT-IMPLEMENTATION-BASELINE
---

# Hushiro Implementation Baseline

This file owns the first-playtest implementation package for Hushiro standard encounter scripts, reusable gameplay-space inventory, and Village Ogre / Collector / Keeper combat contracts.

`RUN_STRUCTURE.md` continues to own the 12-chamber route and eligibility windows. The Area 1 enemy, miniboss, boss, and environment files continue to own qualitative identity. Values here are implementation targets and may move through Godot playtesting without reopening Hushiro's approved structure.

# Standard encounter model

Hushiro standard Combat rooms are deliberately authored multi-wave encounters. They are not assembled from a procedural threat budget.

First-playtest rules:

- standard encounters normally use **3 waves**; selected opening encounters may use 2 and selected high-pressure encounters may use 4,
- the next wave begins only after every enemy in the current wave is defeated,
- use approximately **0.9 seconds** between wave clear and the next spawn tell,
- enemies receive a clear spawn/entry tell before becoming active,
- standard Hushiro rooms normally keep **3-6 enemies active at once**,
- **6 active enemies is the normal hard cap** for the first prototype,
- a normal full encounter contains roughly **10-18 total enemies**,
- Hollow/Hound-heavy encounters may reach roughly **18-20 total enemies** because those enemies are intentionally lighter,
- Warden/Bilemass-heavy encounters use fewer total bodies because their mechanics occupy more player attention,
- the final wave should normally be the encounter's strongest or most tactically complete composition,
- an encounter may appear at most once per run,
- individual minimum-chamber restrictions below are the only first-pass encounter gating; there is no separate opening/main/pre-boss encounter pool.

The intent is Hades-like chamber substance with lower simultaneous body count because Oathbound's combat depends more heavily on precise parry, posture, perilous-response, spacing, and target-priority reads.

## First-playtest standard-enemy durability

These are encounter-calibration values rather than final enemy balance:

| Enemy | Health | Posture |
|---|---:|---:|
| Hollow | 60 | 50 |
| Blighted Hound | 65 | 60 |
| Corrupted Archer | 75 | 65 |
| Corrupted Swordsman | 100 | 100 |
| Cellar Bilemass | 80 | 70 |
| Warden | 140 | 150 |

Exact attack damage, active frames, and minor AI timing remain Godot tuning fields under the existing qualitative enemy contracts.

# Authored launch encounter pool

## H-01 — Broken Patrol

**Eligibility:** fixed Chamber 1 encounter.

- Wave 1: 1 Corrupted Swordsman + 3 Hollows
- Wave 2: 2 Corrupted Swordsmen + 4 Hollows
- Total: 10 enemies

Purpose: teach readable melee pressure, fragile crowd targets, posture, and room-clear flow without introducing ranged/support mechanics immediately.

## H-02 — Firing Line

**Eligibility:** Chamber 2+.

- Wave 1: 2 Corrupted Swordsmen + 1 Corrupted Archer
- Wave 2: 2 Swordsmen + 1 Archer + 2 Hollows
- Wave 3: 2 Swordsmen + 2 Archers + 2 Hollows
- Total: 14 enemies

Purpose: establish ranged target priority while melee defenders occupy the approach.

## H-03 — Kennel Break

**Eligibility:** Chamber 2+.

- Wave 1: 4 Blighted Hounds
- Wave 2: 3 Hounds + 1 Swordsman
- Wave 3: 4 Hounds + 1 Swordsman
- Total: 13 enemies

Purpose: teach pack pressure while preserving the rule that only one Hound normally performs the primary committed lunge at a time.

## H-04 — Barricade Mob

**Eligibility:** Chamber 2+.

- Wave 1: 5 Hollows
- Wave 2: 1 Swordsman + 5 Hollows
- Wave 3: 2 Swordsmen + 4 Hollows
- Total: 17 enemies

Purpose: high-body-count crowd management where the player must keep the disciplined threats readable inside weak swarm pressure.

## H-05 — Crossfire Retreat

**Eligibility:** Chamber 3+.

- Wave 1: 1 Archer + 3 Hollows
- Wave 2: 2 Archers + 2 Hollows
- Wave 3: 2 Archers + 2 Swordsmen + 2 Hollows
- Total: 14 enemies

Purpose: force clean ranged closure, angle changes, and target switching.

## H-06 — Spoiled Storehouse

**Eligibility:** Chamber 4+.

- Wave 1: 1 Cellar Bilemass + 3 Hollows
- Wave 2: 1 Bilemass + 2 Swordsmen + 1 Hollow
- Wave 3: 1 Bilemass + 1 Archer + 2 Swordsmen + 2 Hollows
- Total: 14 enemies

Purpose: introduce persistent floor denial while preserving enough direct pressure that the Bilemass matters as a priority target.

## H-07 — Chain Detail

**Eligibility:** Chamber 5+.

- Wave 1: 2 Swordsmen + 2 Hollows
- Wave 2: 1 Warden + 2 Swordsmen + 1 Hollow
- Wave 3: 1 Warden + 1 Archer + 2 Swordsmen + 1 Hollow
- Total: 13 enemies

Purpose: make Warden restraint dangerous because other enemies can exploit the bind rather than because the Warden itself has a large move list.

## H-08 — Hounds in the Mud

**Eligibility:** Chamber 4+.

- Wave 1: 4 Hounds
- Wave 2: 3 Hounds + 1 Archer
- Wave 3: 4 Hounds + 1 Swordsman
- Wave 4: 4 Hounds + 1 Archer + 1 Swordsman
- Total: 19 enemies

Purpose: Hushiro's highest-tempo standard encounter; body count is high because most of the room is lightweight Hounds, while the Archer/Swordsman combinations complicate pack response.

## H-09 — Choked Courtyard

**Eligibility:** Chamber 6+.

- Wave 1: 1 Bilemass + 3 Hollows
- Wave 2: 1 Bilemass + 1 Archer + 2 Swordsmen
- Wave 3: 1 Bilemass + 1 Archer + 2 Hollows + 2 Swordsmen
- Total: 14 enemies

Purpose: sustained area denial plus ranged/melee priority management in a wider arena.

## H-10 — Last Checkpoint

**Eligibility:** Chamber 7+.

- Wave 1: 2 Swordsmen + 1 Archer
- Wave 2: 1 Warden + 2 Swordsmen + 1 Hollow
- Wave 3: 1 Bilemass + 1 Archer + 2 Swordsmen
- Wave 4: 1 Warden + 1 Archer + 2 Swordsmen + 2 Hollows
- Total: 17 enemies

Purpose: hardest normal Hushiro room, combining the region's core roles without exceeding the six-active-enemy readability cap.

# Reusable gameplay-space inventory

The 12-chamber route does not require 12 unique environments. Build a compact set of reusable gameplay footprints using the approved 32x32 working tile grid and Hushiro environment kit.

## Combat foundations

| Layout | Approx. gameplay footprint | Primary use |
|---|---|---|
| **Village Lane** | 28x16 tiles | long sightlines, Archer/Warden pressure |
| **Open Courtyard** | 24x20 tiles | Hounds, Hollows, broad mixed combat |
| **Barricade Crossing** | 28x18 tiles | split lanes, Swordsman/Archer combinations |
| **Gatehouse Interior** | 22x18 tiles | tighter disciplined melee pressure |
| **Storehouse Yard** | 24x18 tiles | Bilemass hazards and support-priority encounters |

Each foundation should provide:

- 2-3 legal player entrances/exits where route presentation requires them,
- authored enemy spawn sockets distributed around the perimeter,
- separate ranged/support spawn sockets where needed,
- enough spawn variation that repeat use does not mean identical enemy placement,
- no spawn directly on top of the player or inside an unreadable blind spot,
- prop variants that change presentation without changing the core collision footprint.

Encounter scripts own enemy composition. Layouts own legal placement. Do not procedurally invent a new composition from spawn sockets.

## Functional and special spaces

| Space | Approx. footprint | Requirement |
|---|---|---|
| **Shrine** | 18x14 tiles | central focal object, inactive/ready/used states |
| **Rest Guardhouse** | 18x14 tiles | threat-free sheltered presentation |
| **Shop** | 20x14 tiles | merchant/purchase focal zone and three-item presentation space |
| **Treasure Yard** | 22x18 tiles | premium reward framing; may reuse courtyard material language |
| **Village Ogre Arena** | 26x22 tiles | broad charge/sweep lanes with limited obstruction |
| **Collector Arena** | 30x16 tiles | elongated fog-heavy mortuary street with readable reappearance space |
| **Keeper Gate Arena** | 30x22 tiles | duel spacing plus clear Phase-2 charge/shockwave lanes |
| **Regional transition connector** | 20x12 tiles | safe non-counted Hushiro-to-Yomori handoff |

These are gameplay-space targets, not requirements for unique art sets. Decorative variants may be added without expanding the gameplay-layout inventory.

# Shared miniboss rules

Village Ogre and The Collector:

- are standalone encounters with no standard-enemy adds in the first prototype,
- use one life / one killing Deathblow,
- Health reaching zero or posture breaking creates a **3.0-second Deathblow-ready window**,
- if the player does not execute, posture returns to **50%** and Health remains at a minimum of 1 until the next valid Deathblow opening,
- use authored attack selection rather than fixed loops,
- may not choose the same major attack more than twice consecutively,
- target approximately **90-120 seconds** for a first successful kill once the player understands the fight.

# Village Ogre implementation contract

First-playtest durability:

- **650 Health**
- **350 posture**

## Move contract

| Move | Response class | First-playtest role |
|---|---|---|
| Shield Advance | Standard | frontal protected advance; block/parry/dash legal; shield denies careless frontal Health pressure during brace |
| Overhead Crush | Standard heavy | slow high-posture commitment with a large whiff punish window |
| Three-Hit Crush Combo | Standard | three parryable hits with intentionally uneven cadence |
| Spinning Sweep | Perilous sweep | cannot block/parry; evade/reposition response |

Selection rules:

- beyond roughly 170 px, prefer Shield Advance or normal approach,
- at normal melee spacing, rotate Overhead and the three-hit combo,
- Spinning Sweep requires its internal cooldown and is favored when the player remains close to the Ogre's flank/rear,
- below **50% Health**, reduce idle decision delay by roughly **15%** and increase combo/sweep selection weight; do not add a second phase or generic speed multiplier.

Arena behavior:

- shield advance must have at least one clear lane from most arena positions,
- perimeter collision must not trap the player against decorative props during the sweep,
- frontal shield coverage and unprotected side/rear must remain visually obvious.

# The Collector implementation contract

First-playtest durability:

- **525 Health**
- **300 posture**

## Move contract

| Move | Response class | First-playtest role |
|---|---|---|
| Chain Lash | Standard | mid-range pressure; block/parry/dash legal |
| Quick Slash | Standard | close-range punish against careless pursuit |
| Four-Hit Chain Combo | Standard | parryable accelerating cadence; final hit carries the largest commitment |
| Snare | Perilous grab | cannot block/parry; evade/reposition response |
| Fog Vanish → Reappear Strike | Standard re-entry | controlled reposition; silhouette/tell becomes readable roughly 0.45 s before attack |
| Ground Masses | Persistent hazard | floor denial; no block/parry interaction; reposition around it |

Selection rules:

- at long range, favor Chain Lash, Fog Vanish, or approach,
- at close range, favor Quick Slash, Chain Combo, or Snare,
- Ground Masses uses an internal cooldown and cannot be recast while the allowed hazard count is full,
- before 50% Health, allow **1** active Ground Mass zone; below 50%, allow **2**,
- below 50% Health, modestly reduce Fog Vanish cooldown and increase Chain Combo selection weight rather than making the boss truly invisible or globally faster.

Arena behavior:

- fog may lower contrast but cannot hide attack silhouettes or the player's location,
- reappearance points must be legal, navigable positions rather than arbitrary teleports onto Akio,
- Ground Masses cannot seal every route through the arena simultaneously.

# Keeper of the Gate implementation contract

Keeper uses two authored lives linked by the first Deathblow.

## Phase 1 — Ashen Duelist

First-playtest durability:

- **600 Health**
- **325 posture**

Moves:

| Move | Response class | Role |
|---|---|---|
| Iaijutsu Distance Close | Standard | fast disciplined gap-close; parryable |
| Four-Hit Blade Dance | Standard | learnable varied-rhythm duel string |
| Ember Overhead | Standard starter | heavy overhead that branches into one perilous follow-up |
| Perilous Thrust branch | Perilous thrust | cannot block; parry or dash response |
| Perilous Sweep branch | Perilous sweep | cannot block/parry; dash/reposition response |
| Discipline Cut | Standard | quick punish when Akio overcommits or remains in obvious range |

Selection rules:

- use Iaijutsu primarily outside ordinary sword range,
- use Blade Dance as the main sustained duel sequence,
- Ember Overhead branches after its own readable tell; thrust and sweep branches must remain visually distinct,
- Discipline Cut is a short punish tool and should not chain repeatedly into itself,
- no fixed repeating rotation.

Phase-1 Health reaching zero or posture breaking creates the first Deathblow opening. The first successful Deathblow always triggers the transformation and does not kill Keeper.

## Phase 2 — The Collapse

First-playtest durability after transformation:

- **700 Health**
- **375 posture**

Moves:

| Move | Response class | Role |
|---|---|---|
| Five-Hit Feral Onslaught | Standard | faster aggressive parryable string with readable hit rhythm |
| Savage Sweep | Perilous sweep | 360-degree evade/reposition check |
| Leaping Slam | Perilous area attack | evade impact and visible shockwave footprint |
| Bloodied Lane Charge | Perilous movement attack | strong lane tell; lateral evasion is the intended response |

Selection rules:

- Onslaught is the primary close/mid-range pressure tool,
- Sweep is favored when Akio remains very close after Keeper's recovery,
- Slam is favored from moderate distance or after separation,
- Lane Charge requires sufficient clear travel space and cannot start when geometry would make the lane read invalid,
- do not select Sweep or Charge back-to-back more than once without another move between them.

Phase-2 Health reaching zero or posture breaking creates a **3.5-second** killing Deathblow window. If missed, Keeper recovers to 50% posture and remains at minimum 1 Health until another valid opening.

The second successful Deathblow kills Keeper and proceeds to the already-approved persistent reward, current-run Boss Reward, and regional transition flow.

Target first successful kill after learning the fight: approximately **2.5-3.5 minutes**.

# Hushiro completion boundary

This package is sufficient for Hushiro implementation at first-playtest depth:

- 10 authored standard encounters,
- discrete multi-wave chamber behavior,
- five reusable standard Combat footprints,
- functional/special-room inventory,
- first-pass enemy durability calibration,
- Village Ogre and Collector contracts,
- complete two-phase Keeper contract.

Do not create a follow-up planning pass for final wave timing, enemy attack damage, exact active frames, minor spawn positioning, or final encounter volume. Tune those in Godot unless implementation exposes a structural contradiction.