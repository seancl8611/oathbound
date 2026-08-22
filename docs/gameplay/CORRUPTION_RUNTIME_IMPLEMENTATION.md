---
id: GAMEPLAY-CORRUPTION-RUNTIME-IMPLEMENTATION
title: Corruption Runtime Implementation
category: gameplay
status: implementation
authority: secondary
last_reviewed: 2026-08-22
topics:
  - corruption
  - shrine
  - implementation
  - runtime
  - first-playtest
related:
  - GAMEPLAY-CORRUPTION-SHRINES
  - UI-SHRINE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-FIRST-ATTEMPT
---

# Corruption Runtime Implementation

This file records how the approved Corruption / Shrine contract is represented in the current Godot runtime. It does not replace `CORRUPTION_AND_SHRINES.md`, `SHRINE_INTERFACE.md`, or the individual Blood Aspect authorities.

# Runtime ownership

`Core/Corruption/OathboundCorruptionRuntime.gd` is the current run-scoped Corruption authority.

It owns:

- the **0 / 100** Corruption value,
- Shrine-ready state,
- per-encounter Corruption caps,
- the per-chamber successful-parry cap,
- progression-credit filtering,
- once-per-life posture-break / Deathblow credit,
- Corruption reset on death or successful run completion,
- first-death Returning Blood awakening through persistent `MetaProgress`,
- Shrine support / Resist / Embrace / Stabilize state resolution,
- telemetry for Corruption gains and Shrine resolution.

It does **not** own Blood Aspect Tier behavior. `AspectRuntime` remains the sole authority for selected Aspect, Tier 0-IV application, Blood unlock at Tier II, Blood generation, and Blood Arts. Embrace only calls the existing `AspectRuntime.advance_tier()` API.

# Approved first-playtest gain contract

| Event | Corruption |
|---|---:|
| Ordinary enemy defeated | +1 |
| Elite enemy defeated | +3 instead of +1 |
| Successful parry | +1 |
| First posture break on an enemy | +2 |
| Successful Deathblow | +3 |
| Standard combat clear | +4 |
| Miniboss clear | +10 |
| Authored regional-boss progress checkpoint | +5 |
| Regional boss defeat | +10 |

Encounter limits are:

- standard Combat: **16**,
- miniboss: **24**,
- regional boss: **30**,
- successful parries: at most **4 Corruption per chamber**.

The runtime clamps total Corruption at 100 and discards additional gain until a Shrine resolves the full state.

# Progression-credit contract

Combatants are eligible by default unless authored otherwise.

Current metadata hooks are:

- `progression_credit_eligible = false` — suppress progression credit,
- `no_progression_credit = true` — suppress progression credit,
- `corruption_no_credit = true` — Corruption-specific no-credit override,
- `progression_elite = true` or `corruption_elite = true` — treat the combatant as elite for the +3 defeat value.

`elite` and `miniboss` groups also use the elite defeat value.

The runtime marks once-per-life credits directly on the combatant so duplicate signals/polling cannot award them twice:

- `_corruption_posture_break_credit`,
- `_corruption_deathblow_credit`,
- `_corruption_defeat_credit`.

Enemy tracking uses stable instance IDs plus weak references so short-lived scene-tree nodes cannot create deferred-call lifetime errors.

# Authored boss integration

Regional bosses may call:

- `CorruptionRuntime.award_boss_checkpoint(checkpoint_id)` for a genuine authored progress checkpoint,
- `CorruptionRuntime.refresh_enemy_phase_credit(enemy, ...)` only when an authored phase represents a genuine new combat state that is allowed to refresh break / Deathblow eligibility.

The Corruption runtime does not infer story-significant boss checkpoints from arbitrary health percentages. Boss scripts remain responsible for deciding which real phase transitions deserve the approved +5 checkpoint credit.

# Shrine runtime

`Core/Corruption/OathboundShrineChamber.gd` is the current live Shrine surface. `Core/Chambers/Types/ShrineChamber.tscn` points to it instead of the imported Prayer Flame / Cinder prototype.

The current states are:

## Pre-awakening or awakened below full

- restore 20% maximum Health,
- restore 25% maximum Spirit,
- each resource resolves independently,
- Corruption does not change,
- no Technique card flow is used.

Pre-awakening presentation hides nonexistent Aspect / Tier / Corruption information.

## Full Corruption below Tier IV

**Resist**:

- keep current Tier,
- set Corruption to 75,
- restore 25% maximum Health,
- restore 35% maximum Spirit.

**Embrace**:

- advance exactly one Aspect Tier,
- set Corruption to 0,
- apply the existing Aspect Tier package immediately through `AspectRuntime`.

## Tier IV + full Corruption

**Stabilize**:

- keep Tier IV,
- set Corruption to 50,
- restore 30% maximum Health,
- restore 40% maximum Spirit,
- grant no Tier V or additional Aspect scaling.

# HUD and test controls

The current `OathboundRunHUD` adds an awakened-only Corruption display with empty / filling / near-full / full-Shrine-ready presentation. The display is hidden before Returning Blood awakens.

`OathboundCorruptionPlaytestLab.gd` adds controls to:

- awaken Returning Blood,
- set Corruption to 0 / 50 / 75 / 99 / 100,
- set Aspect Tier 0-IV,
- inspect the current Shrine state and current / next Tier headline.

Awakening is intentionally persistent because it is campaign state; Corruption and Tier remain run-scoped.

# Automated validation

`CorruptionRuntimeSmoke.tscn` verifies the state machine directly in a disposable CI user directory:

- pre-awakening hidden state,
- first-death awakening + reset,
- four-point successful-parry chamber cap,
- 100-point clamp and Shrine-ready state,
- Embrace advances exactly one Tier and empties Corruption,
- Resist keeps Tier and returns to 75,
- below-full support leaves Corruption / Tier unchanged,
- Tier-IV Stabilize keeps Tier IV and returns to 50.

The project workflow also launches the live Shrine scene and fails on GDScript or deferred-call runtime errors.

# Explicit remaining boundaries

## Complete first-attempt combat loadout

`FIRST_ATTEMPT.md` requires the first pre-awakening attempt to use the base katana with no Blood Aspect. The Corruption/Shrine package implements the correct **pre-awakening Shrine and Corruption behavior**, but complete first-attempt Player/profile reconciliation remains a separate integration package. Do not fake this by presenting the default Wolf state as a pre-awakening Aspect choice.

## Authored boss checkpoint calls

The runtime API exists, but each real regional-boss checkpoint must be wired where the boss authority defines a genuine phase/progress transition. Do not add generic health-percentage checkpoints merely to create more Corruption.

# Tuning boundary

Final gain pacing, encounter-cap tuning, and successful-run Tier distributions remain playtest variables as authorized by `CORRUPTION_AND_SHRINES.md`. Changing those first-playtest numbers after telemetry does not require reopening the Corruption/Shrine architecture unless testing exposes a structural contradiction.
