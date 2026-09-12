# Area 1 Player-Paced Combat Playtest — 2026-09-12

Branch: `playtest/area1-player-paced-2026-09-12`

Gameplay baseline: PR #165 merge `0cc25a0df8f09ad876262cf514e44b38110b5cd8`, built from exact feature head `7b5e9df31383e7aba54ef4798c0609033cd14fd1`. All 10 PR-triggered workflows were green on that exact feature head: Hushiro Combat Regression, Authored Presentation Content, Run Region Handoff, Post-playtest Stability, Blood Cavern Execution Trial, RunScene Runtime Lifetime, Release Shell, Hushiro Combat Semantics, Godot 4.7.2 Project Check, and Region Transition Presentation.

This branch is intentionally frozen as the first manual-playtest snapshot for the approved player-paced Area 1 combat target. Do not move it forward with later `main` changes.

## Comparison baseline

Keep the earlier frozen branch `playtest/combat-v2-phase7-2026-09-12` intact. That branch represents the Phase 7 architecture before the Area 1 player-paced durability/wave-flow package.

Use the two branches for different questions:

- `playtest/combat-v2-phase7-2026-09-12`: does free V2 locomotion + role-aware crowd backoff + `PressureDirectorV2` already remove the old duel/turn cadence?
- `playtest/area1-player-paced-2026-09-12`: does that architecture now produce the intended faster supernatural action-roguelite rhythm after Area 1 kill-time and wave-flow calibration?

## What changed in the player-paced snapshot

### Standard-enemy Health targets

The approved pre-awakening base-katana chain remains 9 -> 12 -> 21 Health damage, or 42 damage per full three-hit chain.

Current Area 1 targets:

- Hollow: 45 HP, roughly 4 clean base-katana hits.
- Blighted Hound: 50 HP, roughly 4 clean hits.
- Corrupted Archer: 60 HP, roughly 5 clean hits.
- Corrupted Swordsman: 80 HP, six clean hits if none are guarded.
- Cellar Bilemass: 80 HP, roughly 6 clean hits.
- Warden: 140 HP, roughly 10-11 clean hits.

The Player was not globally buffed to create these targets; Area 1 enemy durability was calibrated instead.

### Swordsman guard behavior

The Swordsman's guard remains authored/tactical rather than a universal per-hit RNG roll.

At full Health, especially while its own attack is cooling down, movement/offense should normally remain more attractive than guarding. After Akio creates meaningful Health/Posture pressure, guard becomes a competitive defensive punctuation.

The important manual-playtest expectation is that six fully clean base-katana hits kill the 80-HP Swordsman, while one meaningful 35%-Health guard normally removes enough damage to let it survive that same commitment.

### Wave progression

Normal clear progression is now:

`current wave cleared -> next authored wave begins immediately`

There is no intentional 0.9-second dead-air pause after a normal clear.

A 120-second Area 1 anti-stall timer may begin the next wave with survivors still active. This should be effectively invisible in ordinary successful play and exists only as escalation/fail-safe behavior.

### Arrival styles

A wave is now explicitly an authored arrival script, not a requirement that every member spawn on the same frame.

Hushiro uses three arrival styles across the existing ten standard encounters:

- Burst: enemies enter almost together.
- Staggered: the wave arrives over a short rolling sequence.
- Sequence: reinforcements arrive one after another with clearly perceptible spacing.

The existing 2-, 3-, and 4-wave encounter variety and the normal authored 3-6 population envelope remain intact. Encounter identity was not flattened into one universal template.

## Systems intentionally unchanged

This package does not replace or broadly retune:

- `PressureDirectorV2` dangerous-impact spacing;
- Posture maxima or the canonical enemy `PostureBar`;
- Deathblow behavior;
- Health/Posture/Poise separation;
- canonical `AttackEvent` damage ownership;
- Player damage values;
- Area 2/3 global spawner behavior;
- universal block RNG;
- the old Phase 7 frozen comparison branch.

All six canonical Hushiro standard families still use the shared Combat V2 seams for cadence, commitment/motion, Poise response, and pressure scheduling.

## What to test first

1. **Swordsman clean kill line** — land a clean offensive string and judge whether roughly six base-katana hits feels fast and satisfying rather than trivial.
2. **Swordsman guard interruption** — see whether occasional guard use meaningfully breaks the one-combo kill without turning every approach into a blocking duel.
3. **Archer close-down reward** — once Akio reaches an Archer, it should disappear quickly enough that closing distance feels rewarded.
4. **Warden durability** — it should clearly outlast the other standard enemies, but 10-11 clean hits should not feel like a sponge once its restraint/control tools are understood.
5. **Immediate wave chaining** — after a full clear, momentum should continue immediately into the next arrival script.
6. **Arrival variety** — compare burst, staggered, and sequence waves. They should change target-priority and room rhythm without feeling like arbitrary spawn delay.
7. **Multi-enemy V2 pressure** — enemies should overlap approach, movement, aiming, windup, and guard behavior while dangerous impact timing remains readable.
8. **Hound and Hollow packs** — fragile bodies should derive danger from numbers, mobility, and pressure rather than excessive individual durability.
9. **Posture/Deathblow readability** — confirm the PostureBar remains useful when fights are faster and more multi-target.
10. **Anti-stall invisibility** — under normal play, the 120-second escalation should never become part of the perceived standard cadence.

## Feedback to capture

For any room that feels wrong, record:

- encounter/enemy composition;
- which wave and arrival style you were seeing if identifiable;
- whether the problem was kill time, passivity, crowding, synchronization, or spawn rhythm;
- whether unfairness came from overlapping movement/windups versus actual impacts landing together;
- whether Akio felt too planted or too slippery during attacks;
- whether a guard felt useful, excessive, or invisible;
- whether Warden durability felt appropriate;
- whether Posture/Deathblow remained readable;
- whether any enemy still appeared to wait on a hidden whole-turn token.

Return the Godot `.log` and matching `combat_*.jsonl` telemetry from the same run whenever possible. Those are the preferred evidence for the next tuning package.
