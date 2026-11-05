# Kraken (working label) — Oathbound enemy AI integration plan

**Status:** Architectural proposal / documentation only (Nov 5, 2026). No Kraken runtime exists or is installed. The user used the word “Kraken”; its identity as a product, code name or tool has **not** been established, so this is only a **working name** for the Hades-inspired AI cleanup. **This document does not rename contractual Hammer milestones.**

**Git baseline:** `agent/akio-checkpoint-b-playtest` at `c756090c42831512d750f5dfbad4c928e6143d7d`; preserve existing canonical local checkout. **Initial target:** the Corrupted Swordsman in Area 1 Firing Line. No changes to Akio source art, combat input, other regions, or commissions.

## A. Authority graph — preserve current successful systems

```text
AUTHORED ENCOUNTER LAYER
HushiroEncounterCatalog -> Hushiro EncounterSpawner
                                  |
                                  v (enemy_spawned/death/room_changed)
                     Hushiro combat chamber
                                  |
            [ONE melee engagement-position authority]
                                  |
                  target position / engagement role
                                  v
PER-ENEMY CONTROLLER  SwordsmanBehavior (NEW, optional/flagged)
   - approach / hold-support / attack-ready / recover
   - consults action eligibility and guard events
   - only emits desired locomotion + attack requests
                     |                            |
                     v                            v
             EnemyMotor                   PressureDirectorV2
       accel/action/knockback               via AttackDir facade
                     |                            |
                     +------------+---------------+
                                  |
                           CombatActionRunner
                             | action phases
                             v
                    EXISTING attack coroutines
             hitboxes / guard / parry / damage / death
                                  |
                           Godot actor position
                                  |
         HushiroEnemySeparationRuntime (LAST-RESORT overlap guard)
                                  |
                   DirectionalActorPresentation
                       reads state, never drives combat
```

**Important:** Position lease does not give attack authority. Pressure reservation does not define where to stand. A collision guard does not pick tactics. This is the core anti-conflict rule.

## B. Explicit integration dependencies and change seams

| Change | Insert/modify here | Must still work | How we prevent parallel authority |
| --- | --- | --- | --- |
| Firing Line test fixture / waves | Existing `HushiroEncounterCatalog`, `Regions/Hushiro/Encounters/EncounterSpawner.gd`, `Core/Chambers/CombatChamberBase.gd` | Authored H02 wave counts/arrival; player-spotted opener; 6 normal cap; 120s anti-stall; clear gates | **No AI changes to encounter catalog initially** |
| Engagement position assignment | Add one opt-in `MeleeEngagementCoordinator` **under Hushiro chamber** or one deliberately shared equivalent; integrate with `enemy_spawned`, enemy death, room exit | CharacterBody navigation, bounds/walls, melee reach, projectile role exclusions, multiple types later | Only coordinator publishes target destination/role; actor does not invent competing orbit destinations |
| Swordsman high-level behavior | `CorruptedSwordsmanV2Brain.gd` is the existing seam: replace scored switching for opted-in actors with an explicit transition policy | Aggro/deaggro, smoke, guard counters, stuns, death, attack retries, hit reaction | ONE active decision policy. Disable old `EnemyBrain.choose_intent()` **for opted-in actors**, not globally |
| Normal slash/lunge execution | `V2Pressure._try_attack()`, `_v2_attack_choice_for_distance()`, original Legacy coroutines | ~54-unit short-attack gate; 80–125 closing attack; valid whiffs, attack target commitment | Keep existing coroutines initially; do **not** build a second attack implementation or enlarge hitboxes |
| Attack admission | `PressureDirectorV2` via `OathboundAttackDirector.request_pressure_threat()` | Spacing, concurrent windups, severity budget, cancellation release, non-migrated enemy role calls | Single dangerous-window authority; do not combine an unrelated hard single-attacker token with it |
| Reposition & body overlap | `V2Brain._v2_move_*`, `Legacy._compute_separation()`, `OathboundAttackDirector._crowd_tick()`, `HushiroEnemySeparationRuntime.gd` | Wall avoidance, anti-penetration, pressure reservation, non-Swordsman compatibility | Only coordinator decides destinations; reduce legacy separation force to fallback and skip legacy backoff on opted-in Swordsmen; physical pair correction remains narrowly guarded |
| Final velocity | `V2Motion._smooth_velocity()`, `_tick_v2_action_motion()`, `EnemyMotor.resolve_velocity()` | Running lunge advances during telegraph; hitstop, knockback, frost, collisions, Root/feet anchor | Motor is sole acceleration/composition authority; don't stack two smoothers |
| Combat phases | `CombatActionRunner` + Legacy attack state flags | Actual windup/commit/ACTIVE/recovery, parry, special interrupts and death | New controller observes runner and waits for completion/interruption; no early tactic reassignment while committed |
| Enemy visual state | `DirectionalActorPresentation.gd`, `AkioEnemyVisualProxyProfile.gd`, `HushiroIsometric2DPresentation.gd` | Shared Akio 816-frame temporary proxy, 8 views, no Run reset on turns, no player regression | Presentation has one ordered state-resolution path; runtime emits diagnostic 'fallback' reasons for absent Guard/Hurt/Death |
| Regression/observability | `EnemyBrainSmoke.gd`, `AkioCheckpointBAssetSmoke.gd`, Hushiro combat/presentation CI, `CombatTelemetry` | Existing passing tests plus path/slot and visual transition evidence | New diagnostics are read-only and lightweight, never behavior controllers |

## C. Staged implementation (engineering checkpoints, NOT artist commission milestones)

### Stage 0 — Baseline and observability before changing decisions

- Save a reproducible **H02_firing_line** playtest fixture: one Swordsman, two Swordsmen, two Swordsmen + Archer; fixed seed where practical. Use the existing Playtest Lab/normal launcher; no second clone or new outbound folder.
- Capture: movement intent and state change reason, world position/velocity, separation corrections and pair distances, closest valid engagement slot and distance-to-slot, pressure admitted/delayed, attack start/commit/impact/recovery, and actual presented animation/frame/direction/fallback.
- Add a cheap debug on-screen view that indicates the claimed engagement role and destination, but does not affect gameplay.
- Measure current: near-pair occupancy, route reversals, wall-stuck events, % of attack telegraphs in which position drifts, missed lunge offset, visual fallback incidents, startup atlas time and FPS.
- **Gate:** metrics and owner-visible reproduction exist. No source-code behavior changed.

### Stage 1 — One Swordsman, deterministic behavior without slots

- Keep `V2Pressure`, original attack coroutines, `CombatActionRunner`, `EnemyMotor`; replace only **tactical selection** behind an **opt-in per-Swordsman debug flag**. Legacy selection remains available for A/B and rollback.
- New authored flow: `APPROACH → HOLD/READY → WINDUP/COMMITTED/ACTIVE → RECOVERY → READY`; `HURT/GUARD/STUN/DEAD` override appropriately. The `CombatActionRunner` is still the action clock.
- When within melee distance band, hold/face Akio rather than circling constantly. Move again only if Akio leaves the band, a safe flank assignment changes, or explicit stuck/wall logic requires it. Use different entry/exit thresholds and a minimum dwell to prevent flip-flops.
- Explicit per-attack requirements: start distance, attack tell, lock/track rules, final reach, recovery and interruptibility; initially reuse existing exports and existing range-gate functions.
- **Gate:** one Swordsman has deliberate attacks, valid whiffs, stable idle/run, guard/parry/hurt/death and unchanged damage/pressure response. Existing one-enemy tests green.

### Stage 2 — Two Swordsmen, room-level engagement positions

- Add **one** room-owned coordinator with per-actor lease: `actor_id`, `role`, `target_position`, `expires_at`, `priority`, `safe`. Suggested roles: `engage` and `support/flank` (not new attack token names).
- Slots are soft world-space destinations around the current Akio position, constrained by walls and each actor's collider radius; no teleportation. Refresh a target *gradually* when Akio moves; switch roles only on expiry, vacancy, valid player reposition, interruption or emergency.
- First simple policy: closest eligible active Swordsman may close; second holds a safe angled support position at slightly greater range. It may attack when PressureDirector permits and it can actually reach, without forcing a turn-based queue.
- Do not silently add an `AttackDirector` second max-attacker policy. Only if measurements show unreadable simultaneous impacts do we explicitly revise `PressureDirectorV2` budgets.
- Disable old `AttackDirector._crowd_tick` backoff **only for opted-in Swordsmen** after tests; all other enemy types keep their previous protection. The direct transform correction in `HushiroEnemySeparationRuntime` becomes only a measured collision guard.
- **Gate:** two actors avoid sustained overlapping circles and deadlocks; pressure concurrency, attack fairness and archer exclusion remain correct.

### Stage 3 — Presentation stabilization, separate from the AI

- Add a canonical **presentation snapshot** precedence: DEAD > hitstun/stagger > committed attack/guard > actual locomotion > Idle, adjusted for intended counter/dash policy. Never infer a new combat action from last animation filename when authoritative state exists.
- For the Akio visual proxy, `attack` = Quick Slash; `move` = Run; `defend/hurt/death` explicitly marked `temporary_fallback_idle` with a reason. Visually distinct debug overlay is acceptable; do not commission fake source Actions or pretend fallback is a real hit reaction.
- Retain loop phase through eight-direction heading changes and avoid restarts from tiny velocity changes; add small facing/locomotion hysteresis **only to visuals**, not hit registration.
- Trace displayed animation name, frame, direction, runner action/phase, fallback reason on every important transition; observe memory/atlas startup separately.
- **Gate:** no unexplained Idle flashes or Run resets in close combat. If only authored fallback remains, document as expected until actual enemy art.

### Stage 4 — Mixed encounter / full wave acceptance

- Run three fixed scenarios, then the actual authored multi-wave Firing Line; preserve `burst/staggered/sequence`, opening aggro, six-body cap and anti-stall rules.
- Confirm ranged units remain outside melee leasing. Progression/treasure/room exit still work; smoke/prosthetic/Deathblow/guard/posture, enemy death/revive, player death and restart do not leak leases or pressure reservations.
- Compare before/after telemetry for overlap (<35), movement reversals, intent changes, action recovery intervals, clear time, impact spacing, hit fairness, presentation flicker, startup and FPS.
- **Gate:** CI + Windows owner playtest pass. Only after that expand to Hound/Hollow with distinct behavior profiles instead of forcing Swordsman-style spatial rules on every type.

## D. Important invariants

- No second combat engine. No ML, uncontrolled utility-tree expansion, or new third-party runtime library required.
- Preserve Hushiro room state, the existing authored enemy catalog, and live 3D-rig-to-2D export pipeline.
- Use fixed/seeded tests for reproducibility; randomness belongs in wave composition/limited attack variance rather than frame-to-frame steering.
- Preserve all working attack-range fixes, hitbox/health/posture/deathblow, attack-snapshot tracking, action-motor blending and pressure admission.
- No automatic spawn/attack frequency tuning simply because AI path becomes simpler.
- Time-of-impact coordination and *position* leasing are conceptually different; both can coexist under explicit ownership.
- If a slot cannot be reached due to wall/other enemies, return to a safe support/hold state rather than looping around Akio indefinitely.

## E. Rollback / delivery discipline

- **Documentation first:** current commit changes no gameplay.
- Each code stage gets its own small commit and a debug feature toggle. Do not simultaneously retire the legacy Swordsman and introduce coordinator/animation edits.
- Use the existing `agent/akio-checkpoint-b-playtest` branch and standard `oathbound-playtest.cmd`; no duplicate local clone or outbound folder.
- Rollback = disable the opted-in new Swordsman behavior and restore legacy tactical selection. `PressureDirectorV2`, legacy attacks and visual proxy remain available.
- Remove deprecated legacy paths only after comparison tests pass and no other enemy depends on them.
- Update `OATHBOUND_CURRENT_VS_TARGET.md` with actual status **as each stage lands**; avoid publishing a proposal as implemented.

## F. Risk register

| Risk | Countermeasure |
| --- | --- |
| New coordinator competes with legacy backoff/separation | Opt-in ownership contract; disable old *tactical* backoff for opted-in Swordsmen; preserve measured collision safety only |
| New state machine duplicates old HFSM | First substitute policy at `_v2_brain_tick()` / `_hfsm_tick()` seam, then retire dead branches after regressions |
| Range regression revives 80–105-unit stationary swings | Keep `_v2_attack_start_eligible` and the running-approach physics smoke |
| Action animation no longer matches actual hit phase | Gameplay action runner remains authoritative; new presentation telemetry identifies missing assets separately |
| Two enemies attack at once unfairly | Preserve/adapt `PressureDirectorV2` full dangerous-window budget; visual cues verified in game |
| Wave stalls or changes accidental enemy quantity | Leave Hushiro spawner/catalog alone during initial stages; test all gates independently |
| Other enemy types regress | Every behavior switch is per-Swordsman and Hushiro-only; retain compatibility API for non-migrated enemies |
| Test metrics look good but combat feels passive | Review attack cadence/contact and owner Windows playtest in addition to overlap metrics |

## G. Ready-to-implement decision list

- **Accepted direction to plan:** Hades-inspired readable committed attacks; one spatial authority; simple finite combat flow; retain attack motor + pressure director + authored waves.
- **Still requires design approval before gameplay edits:** exact slot approach, support role priorities, Hushiro-only vs globally reusable coordinator, how opportunistic counters should override support, and numeric thresholds.
- **Name resolution:** `Kraken` remains a document-only working label unless the user specifies an existing tool/architecture to integrate. The recommended solution needs no named third-party Kraken package.
