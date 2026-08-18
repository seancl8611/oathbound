---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - open-questions
  - implementation-readiness
  - content-authoring
  - playtest-handoff
---

# Current Design Questions

This file contains only decisions that materially block implementation or authored launch content.

The launch architecture is already scoped. The goal is to make each remaining package concrete enough to implement, then let Godot playtesting drive revision.

# Queue rules

A package leaves this queue once its authorities provide a coherent first-playtest implementation contract.

After that:

- do not reopen it as smaller follow-up passes merely because values can still be tuned,
- do not repeat work already answered by shared system/family constants,
- treat hitbox polish, frame tuning, VFX synchronization, minor coefficients, and ordinary balance as implementation/playtest work,
- reopen only for a genuine missing rule, contradiction, unusable interaction, or scope problem.

# Completed player-build packages

- **Core combat — COMPLETE:** `COMBAT_IMPLEMENTATION_BASELINE.md`
- **Blood Aspects — COMPLETE:** `ASPECT_IMPLEMENTATION_BASELINES.md` plus the three Aspect authorities
- **Techniques — COMPLETE FOR PLANNING:** `TECHNIQUE_CATALOG.md` + `TECHNIQUE_IMPLEMENTATION_BASELINES.md`
- **Prosthetics — COMPLETE FOR PLANNING:** `PROSTHETICS.md`
- **Relics — COMPLETE FOR PLANNING:** `RELICS.md` + `RELIC_IMPLEMENTATION_BASELINE.md`

The Relic baseline supplies Base / Mastery I / Mastery II values for all 10 Relics, shared 75 / 200 eligible-kill mastery thresholds, and the trigger/reset rules needed for implementation.

Do not create new sub-passes for completed packages unless implementation exposes a structural gap.

# Current question — final player-build resource/state contract

This is the last shared player-build implementation question before Hushiro.

Corruption/Shrines and Blood are **related by progression dependency but remain separate mechanics**:

- Corruption fills through combat and makes a Shrine progression decision available.
- Embrace spends full Corruption to advance the selected Aspect.
- Tier II unlocks Blood.
- Blood is then a separate combat meter used to activate the selected Aspect's Blood Art.

Do not merge their meters, gains, or UI identities.

## A. Corruption pacing and Shrine resolution

**Question:** What first-playtest Corruption values and exact Shrine state transitions make Tier progression directly implementable?

Already decided and not to be reopened:

- Corruption is run-only and absent on the first attempt.
- Tier 0 is the starting Aspect state.
- Full Corruption makes Shrine progression available.
- Resist keeps the current Tier.
- Embrace advances exactly one Tier and empties Corruption.
- Tier IV is maximum; later full states use Stabilize.
- A below-full Shrine gives **20% max Health** or **25% max Spirit** support.
- Tier identities/effects are owned by the Aspect authorities.

Only define the remaining implementation gaps:

- numeric Corruption maximum/full threshold,
- exact gain values for approved combat/progression events,
- any necessary anti-farming/per-event cap,
- exact post-Resist Corruption value and full-Corruption support result,
- exact post-Stabilize Corruption value and support result,
- deterministic rule for whether below-full support resolves as Health or Spirit,
- precise reset/state transitions needed by HUD/Shrine code.

## B. Blood meter and generation

**Question:** What first-playtest Blood meter and generation rules make the already-approved Tier-II Blood Arts usable without per-Aspect code invention?

Already decided and not to be reopened:

- Blood is unavailable before Tier II.
- stored Blood persists between rooms,
- a Blood Art requires a full meter and consumes it on manual activation,
- no Blood is generated while the Blood Art is resolving,
- Blood resets at run end,
- Blood Art identity, damage/posture, geometry, and Tier behavior are already owned by the Aspect authorities and implementation baselines.

Only define the remaining implementation gaps:

- Blood meter maximum,
- exact generation from approved combat events,
- Aspect-specific weighting/normalization needed so Wolf/Wraith/Ronin fill at comparable intended pacing despite different hit profiles,
- whether overfill is discarded,
- ready → spent → rebuilding state behavior,
- any necessary anti-recursion/secondary-damage exclusions.

**Player-build exit condition:** after A and B are answered, the complete launch player-build layer can be instantiated without another shared design pass. Final gain rates and pacing remain playtest-tunable.

# Hushiro implementation-ready package

After the player-build layer, resolve Hushiro as one connected package:

1. **Authored standard encounters** — launch pool, exact compositions, waves/spawns, only necessary eligibility restrictions.
2. **Reusable gameplay-space inventory** — Combat, Shrine, Rest, Shop, Treasure, miniboss, Keeper, transition spaces.
3. **Village Ogre / Collector / Keeper contracts** — moves/states, selection rules, perilous/defensive classifications, escalation, arena behavior, posture/deathblow/death rules.

**Exit condition:** Hushiro can be built as a complete repeatable region and used for serious end-to-end Godot testing.

# Implementation restart gate

Do not wait for later regions.

Return seriously to implementation when:

- the player-build layer is implementation-ready,
- Hushiro is implementation-ready,
- the existing Godot project is audited against current authorities.

Then implementation and documentation proceed together.

# Later implementation-content packages

- **Strand / permanent progression:** Bloodwell/Blood Mirror effects and prices, Prosthetic unlock sequence, Relic source assignments, Blood Cavern trials/rewards, save/progression flags.
- **Yomori:** encounter pool/layout inventory, Embered Pilgrim, Rotwood Host, Twin Maws, regional hazards.
- **Kagutsuchi / Shogun / Heart:** encounter pool/layout inventory, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Binding states, both Heart forms, first-clear/repeat-suppression differences.
- **Authored presentation content:** exact dialogue, lore/records, achievements, tutorial/help text, ending/postgame lines, credits/legal when dependencies are known.

# Playtest backlog — not open design questions

Do not promote these back into the design queue unless testing reveals a structural problem:

- final damage/posture values,
- final attack/frame timing,
- final hitbox widths and VFX synchronization,
- final parry/dash windows,
- final enemy Health/damage,
- final proc coefficients/status durations,
- final Prosthetic magnitudes/cooldowns,
- final Relic values/mastery pacing,
- final Corruption/Blood gain pacing after a coherent baseline exists,
- final route/reward/rarity weights,
- final economy/progression prices,
- final encounter-volume adjustments,
- exact run-duration validation.
