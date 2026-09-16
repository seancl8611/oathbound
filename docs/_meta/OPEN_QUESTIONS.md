---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-09-16
---

# Current Design Questions

Only unresolved decisions that materially block current implementation or production belong here. Ordinary tuning stays in playtesting.

## Current implementation priorities

1. **Finish Combat V2 reconciliation.** Remove remaining player-facing Posture, Deathblow/execution, and universal-counter assumptions from current runtime/tests/docs while preserving hidden Poise/interruption and authored kit-specific defense.
2. **Finish PR #197 integration.** Retire obsolete live-3D validation, fix current release/integration checks, and establish merged `main` as the clean baseline.
3. **Commission and integrate Akio Proof A.** Use the single Akio commission brief, then judge the first real rig-rendered directional character at the accepted Hushiro camera.
4. **Choose final character render treatment.** Compare clean stylized prerender against deliberate downsample/pixel treatment from the same source; do not lock pixel art by assumption.
5. **Add the first representative enemy proof.** After Akio passes, produce one Corrupted Swordsman on the same source-rig -> 2D pipeline before scaling the roster.
6. **Resume meaningful combat playtesting.** Use final-style-enough directional actor animation to tune movement, attack commitment, readability, enemy pressure, encounter composition, economy, and pacing.
7. **True-final Heart combat remains separate authored work.** Do not invent its moveset merely to close integration checks.

## Decisions already closed

Do not reopen without new playtest evidence:

- authoritative planar 2D gameplay;
- fixed high-angle/isometric-style Camera2D presentation;
- eight-direction actor baseline;
- layered illustrated 2D environments;
- offline 3D rigs as character-production sources rather than live runtime actors;
- Health as normal defeat condition;
- hidden Poise/interruption for standard-enemy reaction resistance;
- no universal visible Posture bar / posture-break kill loop / Deathblow execution layer;
- kit-specific defense with Ronin Guard/Reprisal identity;
- Wolf, Wraith, Ronin as launch Aspects;
- unlimited additive Technique ownership with no Technique inventory slots;
- current active Technique paper baseline of 40 Techniques + 6 refinements;
- 12 / 10 / 11 counted regional route shape.

## Playtest tuning, not design blockers

Exact damage, startup/active/recovery timings, hitbox dimensions, hidden Poise values, guard conversion, encounter wave timing, Corruption/Blood cadence, reward weights, route pacing, final actor frame rate, and exact clean-vs-pixel treatment should be tuned from playable evidence rather than promoted back into broad architecture questions.
