# Hades-inspired Corrupted Swordsman — v1 implementation / playtest

**Status:** Implemented on `agent/akio-checkpoint-b-playtest`, Godot CI verification in progress for this documentation revision. **Not yet approved by a Windows owner playtest.** This is an original GDScript implementation based on the mechanics studied in Hades I/II, not a port of third-party Lua or a new Godot plugin.

## Reference-to-Oathbound mapping

| Source concept in mirrored Lua | Original Oathbound interpretation | Where implemented |
| --- | --- | --- |
| Hades I/II `SurroundAI`: maintain distance and coordinate attackers | Room-controlled primary engager + stable standoff role for additional Swordsmen | `HushiroMeleeSurroundCoordinator.gd` |
| Hades II `MaintainSurroundDistance` and `SurroundDistanceBuffer` | A target position with movement tolerance, no per-tick orbital vector chasing | `CorruptedSwordsmanV2Brain.gd::_hades_move_to` |
| Hades I/II `MaxAttackers` | First prototype has **one primary Swordsman at a time** and rotates after an attack; existing `PressureDirectorV2` still owns dangerous-window admission | Coordinator `plan_for/attack_completed` + existing V2Pressure |
| Hades II `DoSurroundAIRetaliate` | A supporting Swordsman directly pressured by Akio can take engagement when the previous lead is distant, after a short lease | Coordinator `plan_for` |
| Attack-loop tell, commit, active and recovery | Preserve existing attack coroutines/CombatActionRunner and add a short post-attack hold before choosing next action | `V2Brain::_hades_style_tick` and `_finish_attack` |
| Explicit wave configuration | Keep Hushiro's already authored waves, spawn rules and caps; **no wave changes** | Existing `HushiroEncounterCatalog` + `EncounterSpawner` |

All tuning numbers below are **Oathbound prototype values**, not Hades configuration copied or claimed to be canonical.

## First-pass values

- Primary engagement radius: **44 world units** from Akio; supporting ring **94 units**.
- Support angle separation if too near the primary attack angle: **at least 1.20 rad**.
- Position hold tolerance: **13 units** (candidate; tune only after playtest).
- Minimum primary-engager lease: **0.8 seconds**; normal handoff occurs on completed attack after this lease.
- A directly pressured supporter can become active when within **36 units** of Akio and the current lead is farther than **68 units**, after lease expiry.
- Post-attack holding window: **0.35 seconds**, on top of the existing authored combat cooldowns.
- Existing reliable short-melee range is retained (~54); running-swing approach eligibility remains ~80–125. All damage, HP/Posture, hitbox, reaction, stun/parry, and pressure-budget rules remain unchanged.

## What is replaced versus retained

**Replaced in opted-in Swordsmen:** continuous scored `EnemyBrain.choose_intent` approach/strafe/guard/retreat selection and tactical orbiting; per-Swordsman force-separation in normal destination movement; legacy `AttackDirector._crowd_tick` backoff for these migrated Swordsmen.

**Preserved:** actual attack coroutines, `_v2_attack_start_eligible`, `V2Pressure._try_attack`, `PressureDirectorV2` impact reservations, `CombatActionRunner`, `EnemyMotor`, hitbox spawns, counter queue, room wave system, and last-resort `HushiroEnemySeparationRuntime` physical collision corrections. Other enemies remain on their established behavior.

**Important limitation:** no deep rewrite of the legacy state machine yet. The new policy runs through its existing compatible `_hfsm_tick` seam; committed attacks still retain their legacy execution. That avoids simultaneously risking health, Posture, parries, Deathblows and movement.

## Enable / rollback

On the canonical Swordsman scene, `use_hades_melee_policy = true` is the default. To compare behavior, set **`use_hades_melee_policy = false`** in the Swordsman Inspector (or the instance scene override). This restores the existing scored V2 tactical policy; the engagement coordinator ignores disabled actors automatically. No second checkout or Godot assets are required.

## Instrumentation and tests

- `swordsman_hades_state` telemetry on actual behavior-state changes: attack, approach, support, hold, ready, guard, step_out, recovery.
- `hushiro_surround_role` telemetry on actual engagement/support role changes.
- `EnemyBrainSmoke.gd` covers stable two-enemy roles, rotation after an attack, pressured-support promotion, and the original per-attack melee range and running-approach regression cases.
- Existing Godot, combat, Hushiro presentation, Akio Proof A, room lifetime and authored-content checks continue to run.
- The Akio visual-proxy limitations remain: temporary Guard, Hurt and Death map to Idle; a borrowed Quick Slash still cannot match every enemy attack's impact timing. These are **not** caused or solved by the tactical policy.

## Windows acceptance sessions — compare against Nov 5 baseline

1. Pull the latest `agent/akio-checkpoint-b-playtest` in the existing checkout and run `oathbound-playtest.cmd agent/akio-checkpoint-b-playtest`.
2. Run **one Swordsman**. Verify straight, deliberate approach; readable slash/lunge with no invalid out-of-range basic hit; clear recovery and valid dodges.
3. Run **two Swordsmen**. Verify they don't both orbit at 35-unit separation; support holds, primary attacks, and they alternate after finished attacks. If Akio chases the supporter while the primary is distant, supporter must engage instead of fleeing perpetually.
4. Run **two Swordsmen + one Archer** in `H02_firing_line` and full following waves. Verify the Archer still shoots, non-Swordsman behavior and wave timing are unchanged, with no collision piles.
5. Observe guard/counters, parry, hitstun, player death, enemy death, room exit, spawn/respawn and back-to-back fights.
6. Save telemetry and Godot log. Compare **pair distance <35**, number of direction reversals, behavior/role changes per ten seconds, active damage windows, lunge whiff offset, actual sprite animation/frame and FPS.
7. Set `use_hades_melee_policy=false` for a short direct A/B comparison if the new version feels passive or overly synchronized.

## Known v1 limitations / subsequent work

- A single primary engagement slot is deliberately conservative. It may feel too turn-based; compare against Hades-style authored overlap *only after* gameplay testing.
- World-space angular anchors can become awkward around walls and obstacles; the room bounds are clamped, but navigation around complex geometry is not yet path-planned.
- Hades-style positioning does not automatically solve animation flickering: the visual proxy still lacks Guard/Hurt/Death art, and actual displayed-frame tracing is still a separate follow-up.
- Attack selection still uses existing Swordsman moves/timing, not Hades enemy weapons or exact animation data.
- No broad AI migration to Hound/Hollow/Archer has occurred.

**Acceptance:** This stage must improve readability and decrease needless movement *without* reducing pressure to an idle queue or weakening fairness. CI alone cannot establish this; the owner's in-game comparison is the next gate.
