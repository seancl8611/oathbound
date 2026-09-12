# Combat V2 Phase 7 Playtest — 2026-09-12

Branch: `playtest/combat-v2-phase7-2026-09-12`

Gameplay baseline: PR #164 merge `c14b3318eff1344e638772fc8221f0a14992d77a` (8/8 triggered workflows green), with the repository checkpoint commit `ac9d2df80e4597f6db531078e2356e1645ffe573` on top. This playtest branch is intended to stay frozen so later work on `main` does not move the comparison target.

## What this playtest is trying to answer

Does standard Hushiro combat now feel like a multi-enemy action game with readable overlapping pressure rather than a queue of isolated Sekiro-style duels?

The desired feel is not uncontrolled dogpiling. Multiple enemies should be able to approach, reposition, aim, guard, or wind up at the same time, while `PressureDirectorV2` keeps dangerous impact windows readable.

## Player-side changes to notice

Akio now routes attack movement through `CombatActionRunner` + `PlayerMotor`. Attack locomotion is phase-authored rather than a universal ATTACKING movement shutdown. Fast attacks should retain more natural movement/flow; heavier actions may still deliberately plant Akio more strongly.

Current dash behavior is intentionally unchanged. Block/parry mobility has not yet been redesigned, so do not judge stationary defense as a new V2 feature.

## Enemy behavior changes to notice

All six canonical Hushiro standard families now use the shared Combat V2 seams for tactical cadence, commitment/motion, Poise response, and pressure scheduling while preserving their authored attack/contact identities.

- Corrupted Swordsman: controlled-cadence tactical decisions, finite guard behavior, authored Poise, V2 pressure admission rather than a whole-turn melee token.
- Blighted Hound: predator-style bite/lunge decisions, restored multi-Hound packs, free V2 locomotion outside room crowd backoff, heavy lunge pressure scheduled by future impact time.
- Hollow: deliberately simple fodder/swarm enemy; several can approach together, low Poise, one readable bite, room crowd backoff now respected.
- Corrupted Archer: ranged/spatial pressure; projectile arrival timing participates in pressure scheduling instead of consuming close-frontline space.
- Cellar Bilemass: delayed ground-hazard pressure; future puddle arrival is the dangerous event the director schedules.
- Warden: slow restraint/control priority target with chain pressure, authored commitment/Poise, and short guard behavior rather than permanent tank blocking.

## Room-pressure changes to notice

The old one-at-a-time combat rhythm is no longer the intended standard-room authority for migrated enemies.

`PressureDirectorV2` schedules dangerous impact windows, not whole enemy turns. That means enemy approach, aiming, windups, repositioning, and guards may overlap when the predicted dangerous impacts remain fair.

Room crowd spacing is role-aware:
- Swordsman / Hollow / Hound / Warden count as close-frontline pressure.
- Archer / Bilemass are ranged/spatial pressure and do not consume close-frontline slots just because they are physically nearby.
- Four or more true close-pressure bodies may use a four-body frontline envelope.

The legacy `advance_move` role is now compatibility-only. Migrated standard enemies no longer use it to serialize their approach. Excess close bodies are instead controlled by room crowd backoff.

Legacy damaging roles and V2 reservations are also bidirectionally protected during migration: a legacy damaging turn cannot slip into another actor's admitted V2 pressure window, and new V2 pressure cannot bypass a true active legacy damaging holder.

## Posture / Deathblow

Posture was never retired. Enemy `PostureBar` remains the canonical player-facing buildup/readiness feedback, and Posture/Deathblow continues alongside Health damage.

Health, Posture, and Poise are separate systems:
- Health = defeat progress.
- Posture = break / Deathblow opportunity.
- Poise = whether the current hit interrupts the current enemy action.

Taking Health damage therefore does not automatically cancel a committed action.

## Encounter changes to notice

Phase 7 restored authored Hound-heavy compositions, including packs of up to four Hounds in the relevant standard encounters. The standard Hushiro catalog remains bounded to 3–6 active enemies per wave in this snapshot.

No broad Health, damage, Posture, or PressureDirector spacing rebalance was made just to manufacture a difference. This playtest should tell us whether the architectural changes themselves are producing the intended new feel before numerical tuning.

## Best comparisons to make

1. Enter several normal Hushiro combat rooms rather than judging from one Swordsman duel.
2. Specifically find a Hollow-heavy room and see whether the group occupies space and pressures you instead of waiting politely one by one.
3. Find a Hound-heavy room and judge whether the pack feels active while actual lunge/bite impacts remain readable.
4. Test a mixed room with Archer or Bilemass and see whether ranged/spatial pressure layers on top of close enemies without pushing all close enemies out of the fight.
5. Test Warden mixed with lighter enemies and judge whether it reads as a control/support priority threat rather than another duelist.
6. During attacks, pay attention to whether Akio feels less artificially rooted and whether target switching/multi-enemy movement feels easier.
7. Build enemy Posture and confirm the PostureBar is visible and Deathblow timing remains understandable.

## Feedback that is most useful

For each room that feels wrong, note:
- enemy composition;
- whether the problem was too passive, too crowded, or too synchronized;
- whether the unfairness came from movement/windups or from actual hits landing together;
- whether Akio felt too planted or too slippery during attacks;
- whether an enemy ignored a clear hit because of Poise in a way that felt wrong;
- whether Posture/Deathblow readability was clear;
- any enemy that still looked like it was waiting for a hidden turn token.

If possible, return the Godot log and combat telemetry export from the same run. Those let us distinguish encounter-pressure timing from animation, movement, damage, or Posture issues.