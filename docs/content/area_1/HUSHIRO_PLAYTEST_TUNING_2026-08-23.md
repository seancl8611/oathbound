---
id: CONTENT-AREA1-PLAYTEST-TUNING-2026-08-23
title: Hushiro Playtest Combat Tuning - 2026-08-23
category: content
status: active-playtest-tuning
authority: implementation-calibration
last_reviewed: 2026-08-23
related:
  - CONTENT-AREA1-IMPLEMENTATION-BASELINE
  - GAMEPLAY-COMBAT-IMPLEMENTATION-BASELINE
---

# Hushiro playtest combat tuning - August 23, 2026

This note records the current Godot calibration changes produced by the August 23 long-run playtest. `HUSHIRO_IMPLEMENTATION_BASELINE.md` remains the structural authority for Area 1; that file explicitly treats standard-enemy durability, attack timing, and minor encounter calibration as playtest values that may move without reopening the approved region structure.

The goal of this pass is to make Hushiro feel closer to a Sekiro-style exchange: Akio should be able to create a decisive posture break or health burst after a good defensive read, while groups should create controlled turn-taking pressure rather than simultaneous collision-heavy dogpiles.

## Current standard-enemy calibration

| Enemy | Health | Posture |
|---|---:|---:|
| Hollow | 45 | 40 |
| Blighted Hound | 50 | 45 |
| Corrupted Archer | 75 | 65 |
| Corrupted Swordsman | 90 | 90 |
| Cellar Bilemass | 80 | 70 |
| Warden | 140 | 150 |

These values supersede only the first-playtest durability numbers in the Area 1 implementation baseline for the current runtime calibration.

## Posture break and Deathblow semantics

Standard Hushiro enemies use one shared posture contract:

1. Posture reaches its maximum.
2. The enemy immediately enters a real posture-broken/stagger state and its offense is cancelled.
3. The Deathblow does **not** arm on the same frame as the posture break.
4. After a short **0.20 second readability beat**, the enemy becomes Deathblow-ready for the remaining break window.
5. A dead or deletion-queued standard enemy can never remain Deathblow-ready or remain the player's forwarded execution target.
6. If the window expires without execution, the shared CombatController recovery/reset behavior remains authoritative.

Blighted Hound's imported local posture fields are compatibility plumbing only. Its shared `CombatController` meter is authoritative for sword posture, parry posture, break state, recovery, and Deathblow readiness.

## Hound pressure rules

Hounds remain Hushiro's fast pack-rusher, but their threat comes from rapid turn-taking and re-entry rather than four simultaneous bodies collapsing onto Akio.

Current tuning:

- at most **2 Hounds** are authored into the same standard encounter wave,
- only **1 Hound** may own the committed lunge role at a time,
- when a wave contains multiple Hounds, only **1** receives the active advance role at a time,
- Hound movement speed: **75**,
- lunge speed: **235**,
- lunge windup: **0.55 s**,
- bite windup: **0.38 s**,
- post-attack recovery: **1.00 s**,
- lunge cooldown: **4.00 s**,
- bite cooldown: **2.40 s**,
- general attack cooldown: **1.05 s**.

At the current 45 Posture baseline, a clean Hound parry (+35) followed by a normal sword posture hit is intentionally enough to produce a posture break. This gives Akio a clear burst/control answer to a Hound that commits.

## Hound-heavy encounters

### H-03 - Kennel Break

Eligibility remains Chamber 2+.

- Wave 1: 2 Hounds + 2 Hollows
- Wave 2: 2 Hounds + 1 Swordsman + 1 Hollow
- Wave 3: 2 Hounds + 1 Swordsman + 2 Hollows
- Total: 13 enemies

Purpose: teach Hound pressure while giving Akio readable fodder and one disciplined threat to route around. Hounds take turns entering the exchange instead of creating a four-body rush.

### H-08 - Hounds in the Mud

Eligibility remains Chamber 4+.

- Wave 1: 2 Hounds + 2 Hollows
- Wave 2: 2 Hounds + 1 Archer + 1 Hollow
- Wave 3: 2 Hounds + 1 Swordsman + 1 Hollow
- Wave 4: 2 Hounds + 1 Archer + 1 Swordsman + 1 Hollow
- Total: 17 enemies

Purpose: remain Hushiro's highest-tempo Hound room, but generate difficulty through target priority and repeated Hound turns instead of three-to-four simultaneous Hound collision bodies.

## Swordsman cadence

Corrupted Swordsman's attack tells remain deliberately readable, but its long observation/passive gaps are reduced. When it owns the melee turn it should contest Akio rather than orbit for several seconds.

Current implementation targets include:

- observation window: roughly **0.35-0.78 s**,
- forced-passive ceiling: roughly **1.85 s**,
- attack gap: roughly **0.86 s**,
- swipe cooldown: roughly **0.82-1.28 s**,
- original readable telegraph durations remain approximately **0.68-0.72 s**.

## Regression coverage

`Regions/Hushiro/Validation/HushiroCombatSemanticsSmoke.tscn` validates the current high-risk contracts:

- Hound canonical sword posture reaches the shared meter,
- Hound parry posture reaches the same shared meter,
- full posture enters stagger before Deathblow readiness,
- the 0.20-second arm delay is respected,
- dead Hounds cannot remain Deathblow-ready,
- Kennel Break and Hounds in the Mud never exceed two Hounds in one wave,
- the current Hollow/Hound/Swordsman burst durability remains explicit.
