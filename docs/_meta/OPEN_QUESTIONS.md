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

The Prosthetic authority now includes first-playtest Spirit costs, cooldowns, timings, geometry, Health/posture effects, Shock/Burn/control behavior, boss/elite restrictions, and all 19 approved upgrade values.

Do not create new sub-passes for these packages unless implementation exposes a structural gap.

# Current question — Relic implementation baseline

**Question:** What first-playtest values make the existing **10 Relics and two mastery ranks each** directly implementable?

Use the existing roster in `docs/gameplay/RELICS.md`. For each Relic, define only what code/data still needs:

- Base effect,
- Mastery I effect,
- Mastery II effect,
- qualifying trigger,
- reset/cooldown/once-per-room behavior where applicable,
- stacking/exclusivity rule where applicable,
- mastery thresholds only if they are needed for implementation now.

Do not redesign the roster, acquisition structure, one-equipped-slot rule, or mastery architecture.

**Exit condition:** each Relic can be represented as one Base effect plus two permanent mastery improvements without a coder inventing gameplay behavior.

# Next question — Corruption / Shrine / Blood completion

**Question:** What shared numeric/state values are still missing after the combat, Aspect, Technique, Prosthetic, and Relic baselines?

Fill only unresolved implementation data for:

- Corruption thresholds and gain/loss,
- Resist / Embrace / Stabilize behavior,
- Blood generation/storage,
- Blood availability / ready / spent / rebuilding states,
- any shared Shrine/Blood rule not already owned by another authority.

Do not duplicate Aspect-specific Blood Art values already documented elsewhere.

**Player-build exit condition:** the complete launch player-build layer can be instantiated without new design decisions in code.

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

- **Strand / permanent progression:** Bloodwell/Blood Mirror effects and prices, Relic mastery thresholds if deferred, Prosthetic unlock sequence, Relic source assignments, Blood Cavern trials/rewards, save/progression flags.
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
- final route/reward/rarity weights,
- final economy/progression prices,
- final encounter-volume adjustments,
- exact run-duration validation.
