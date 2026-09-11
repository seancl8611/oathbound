---
id: OVERVIEW-V2-COMBAT-IMPLEMENTATION-BLUEPRINT
title: Oathbound Combat V2 Implementation Blueprint
category: overview
status: active
last_reviewed: 2026-09-10
topics:
  - v2
  - combat-architecture
  - enemy-response
  - poise
  - guard
  - movement
  - pressure-director
related:
  - OVERVIEW-V2-COMBAT-DIRECTION
  - GAMEPLAY-COMBAT
---

# Oathbound Combat V2 Implementation Blueprint

This document records the implementation architecture agreed after auditing the current Player, Corrupted Swordsman, shared enemy bases, AttackDirector, canonical AttackEvent path, AspectCatalog, Hushiro enemy contract, and posture-break runtime.

`docs/overview/V2_COMBAT_DIRECTION.md` remains the high-level design authority. This blueprint owns the current migration shape and package order. It is intentionally incremental: existing working combat systems stay live until a V2 package replaces their specific responsibility.

# Core finding from the controller audit

The current Player content layer is farther along than the enemy/controller layer. Aspect attacks are already authored as data profiles and flow into the canonical SwordHitBox/AttackEvent contract. The main Player weakness is movement ownership around attacks and defense, not the absence of a usable action-data foundation.

The Corrupted Swordsman and AttackDirector still carry the stronger V1 assumptions: large inherited HFSM logic, per-frame decision behavior, movement/attack/defense coupling, long guard states, unconditional hit interruption, and whole-attack single-turn ownership.

Combat V2 therefore starts with actor response and one reference enemy before rewriting working Player combos or globally changing encounter population.

# Target component model

Combat V2 should move toward composition instead of deeper enemy/player inheritance.

```text
Action Data
  -> CombatActionRunner
       -> CombatMotor2D
       -> canonical AttackEvent/contact
       -> Combat Response

Player Input -> Player Intent/Action selection -> ActionRunner
Enemy Brain  -> tactical intent/action selection -> ActionRunner
Enemy threat request -> PressureDirectorV2
```

Expected eventual actor components:

```text
Player
  PlayerMotor
  PlayerIntentBuffer / ActionArbiter
  CombatActionRunner
  existing CombatController / build-system bridges

Enemy
  EnemyMotor
  EnemyBrain
  CombatActionRunner
  EnemyCombatResponseRuntime
  BreakRuntime
```

Shared machinery should not erase authored identity. Player input and EnemyBrain choose actions differently; beasts, swordsmen, shield users, elites, and bosses receive different response profiles and action data.

# Canonical boundaries to preserve

The following existing patterns are migration assets, not rewrite targets:

- `AspectCatalog` data-driven attack profiles.
- `SwordHitBox` / HurtBox canonical AttackEvent transaction.
- existing Health/Posture mutation ownership through current combat controllers.
- `HushiroEnemyContract` attached-runtime migration pattern.
- `HushiroPostureBreakRuntime` split between posture break and Deathblow arming.
- CombatTelemetry.
- Techniques, Prosthetics, Relics, Blood Aspects, Blood Arts, Corruption, rear-hit/backstab classification, and run progression.

V2 must not create a parallel damage pipeline. One physical contact produces one canonical resolution and one Health/Posture mutation path.

# Enemy response foundation

The first shared V2 runtime is `EnemyCombatResponseRuntime` with an `EnemyCombatResponseProfile`.

The profile independently authors:

- Health conversion while guarding,
- guard posture/stagger policy,
- guard duration,
- guard cooldown and guard-break recovery,
- guard range,
- neutral poise requirement,
- committed-action poise requirement,
- and guard-break poise requirement.

The runtime owns policy/timing only. It does not choose attacks, move the enemy, mutate Health, or create a second Posture pass.

The immediate semantic split is:

- Health answers whether/how much the strike hurts.
- Posture/Stagger answers long-term break/control progress.
- Poise answers whether this strike flinches or interrupts the current action.
- Guard is an authored temporary action/state, not a universal permanent damage equation.

During migration, canonical V1 `stagger_level` is accepted as a compatibility source for incoming poise power. Future action profiles may publish explicit `poise_damage` without changing the response API.

# Reference enemy: Corrupted Swordsman

The Corrupted Swordsman is the first Combat V2 laboratory because it exercises guard, direct Health damage, posture, parry, Deathblow, attack commitment, interruption, multiple attack types, and encounter-director ownership.

The first reference slice deliberately keeps its current attack implementations and current AttackDirector. It changes only response semantics:

- DEFEND no longer means continuous guard.
- Guard opens for a short authored window and then enters cooldown.
- A guarded sword hit may still remove Health instead of automatically becoming 0 HP.
- Canonical block-Posture damage remains authored by the incoming attack profile.
- Light hits can interrupt the Swordsman when neutral.
- During a committed attack, Health damage still lands but weak poise may fail to interrupt.
- Stronger impacts can interrupt committed attacks and break an active guard.
- Parry/Posture/Deathblow remain valid tactical layers rather than mandatory ordinary-kill endpoints.

Initial reference values are playtest values, not global rules. They may change from evidence without changing the architecture.

# CombatActionRunner target

After the reference response slice feels coherent, attack execution should migrate toward one reusable action lifecycle:

```text
START -> STARTUP -> COMMITTED -> ACTIVE -> RECOVERY -> COMPLETE
```

The runner should expose phase, progress, commitment, cancel/interruption permissions, active hitbox windows, movement contribution, and steering allowance.

Player and enemies may share the runner while retaining different action-selection logic.

# Motion target

Final actor movement should eventually compose:

```text
final motion = locomotion contribution + authored action motion + external impulse
```

An action controls how much locomotion and steering survive each phase. Movement restriction belongs to the action profile rather than a global `ATTACKING` state.

This lets a fast Aspect strike preserve substantial movement while a committed heavy plants the Player intentionally. Enemy attacks can similarly track during early windup and commit before impact so lateral movement can create real whiffs.

Do not rewrite the Player motor before the reference-enemy response playtest shows what movement problems remain.

# EnemyBrain target

Enemy tactical choice should move away from high-frequency per-frame random checks. A small EnemyBrain should evaluate intents at controlled decision intervals and important events.

Typical candidate intents include approach, strafe, attack, guard, retreat, reposition, and recover. Utility uses distance, angle, Player motion/action, ally placement, cooldowns, room pressure, and current commitment.

Randomness may vary among plausible decisions but should not substitute for decision logic.

The motor executes movement; the brain does not directly own collision/locomotion details.

# PressureDirectorV2 target

The current AttackDirector preserves fairness by granting whole melee turns. Combat V2 should preserve centralized fairness but change the scarce resource from an entire attack to overlapping impact danger.

Several enemies may approach, aim, wind up, guard, and reposition simultaneously. The director should schedule damaging threat windows so high-severity impacts do not stack unreadably.

EnemyBrain chooses the desired attack. PressureDirectorV2 only admits/delays the threat window. Once an attack is committed, ordinary room coordination should not arbitrarily steal it.

The existing Prosthetic director overlay is a useful extension pattern: Smoke and future control effects should be able to influence threat admission without rewriting enemy brains.

# Implementation sequence

1. **Reference Swordsman response** — authored guard timing, partial guarded Health, canonical Posture, state-dependent poise, telemetry, regression coverage.
2. **Swordsman ActionRunner + EnemyMotor** — separate movement and action execution from the legacy HFSM while preserving current attacks initially.
3. **Swordsman EnemyBrain** — controlled decision cadence and utility intent selection; remove frame-by-frame decision RNG.
4. **PressureDirectorV2** — overlap intentions while spacing severe impact windows.
5. **Player movement/action pass where evidence requires it** — locomotion contribution, steering/commit points, dash integration, then intent-buffer improvements if still needed.
6. **Migrate Hound, Hollow, Archer, Bilemass, Warden** — use shared components with materially different authored behavior.
7. **Encounter retuning** — only after response and pressure foundations are stable.
8. **Boss framework and Aspect capability pass** — later dedicated packages.

# Validation rule

Each phase must add or update deterministic smoke coverage and CombatTelemetry before broad migration. Manual playtesting should compare the reference enemy in isolation first, then mixed packs.

For the Swordsman response slice, validation must prove at minimum:

- guard has finite authored duration and cooldown,
- guarded Health loss is exactly the configured amount,
- canonical block-Posture remains a single authored pass,
- neutral light hits interrupt,
- committed light hits can deal Health without interruption,
- stronger impacts interrupt committed actions,
- stronger impacts can collapse guard,
- no duplicate damage number or duplicate Posture transaction is introduced.

# Non-goals for the first V2 package

Do not in the same package:

- replace every enemy controller,
- rewrite Player combos,
- add stamina,
- globally reduce enemy Health,
- globally increase enemy counts,
- remove parry/block from an Aspect,
- implement PressureDirectorV2,
- redesign bosses,
- or create a second Health/Posture pipeline.

The point of the first slice is to prove the response model before larger motion/AI/encounter changes depend on it.
