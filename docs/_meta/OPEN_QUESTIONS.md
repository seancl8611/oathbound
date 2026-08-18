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

This file contains only the remaining decisions that materially block implementation or authored launch content.

The launch architecture is already scoped. The goal is not to solve final balance on paper; the goal is to make each system concrete enough to implement, then let Godot playtesting drive revision.

# Queue rules

A question belongs here only when leaving it unanswered would force implementation/content work to invent a meaningful design rule.

A package is **complete for planning** once its current authorities provide a coherent first-playtest implementation contract. After that:

- do not reopen it as smaller follow-up questions merely because some hitbox, timing, coefficient, radius, or balance value can still be tuned,
- do not create a second pass that repeats values already supplied by shared family/system constants,
- treat ordinary data-entry, animation synchronization, hitbox polish, and balance adjustment as implementation/playtest work,
- reopen a completed package only when implementation exposes a genuinely missing rule, contradiction, unusable interaction, or scope problem.

This rule is specifically intended to prevent completed systems from being repeatedly subdivided into near-duplicate planning passes.

# Completed implementation packages

## Core combat — COMPLETE

`docs/gameplay/COMBAT_IMPLEMENTATION_BASELINE.md` supplies the shared first-playtest combat contract: Health/Posture/Spirit, movement/dash/parry/block, posture break, enemy posture, deathblow safety, backstab, perilous responses, modifiers, and common status/proc behavior.

## Blood Aspects — COMPLETE

`docs/gameplay/ASPECT_IMPLEMENTATION_BASELINES.md` supplies first-playtest values for Wolf, Wraith, and Ronin on top of their qualitative Aspect authorities.

Do not create separate follow-up questions for individual Aspect attacks unless implementation exposes a missing behavior.

## Techniques — COMPLETE FOR PLANNING

`docs/gameplay/TECHNIQUE_CATALOG.md` owns the existing **50 Techniques + 10 refinements**. `docs/gameplay/TECHNIQUE_IMPLEMENTATION_BASELINES.md` supplies the shared first-playtest implementation constants for Echo, Rupture, Seal, Rift, Crimson, proc normalization, and the approved Cross-family interactions.

The combination is sufficient to begin implementation. Individual geometry/polish values that naturally emerge while wiring a catalog entry to an Aspect host attack are implementation/playtest data, not another open design pass.

Do not reopen the roster, family identities, slot ownership, rarity, prerequisites, or numeric family contract unless a concrete implementation/playtest problem requires it.

# Current question — Prosthetic implementation baseline

**Question:** What exact first-playtest values make the existing **8 Prosthetics and 19 approved upgrades** directly implementable?

Use the existing roster and upgrade paths in `docs/gameplay/PROSTHETICS.md`. Define only what implementation still needs:

- Spirit cost and repeat-use rule,
- startup / active / recovery timing,
- range / radius / geometry,
- Health and posture effects,
- Burn / Shock / targeting-disruption / pull / guard-storage / blink / healing behavior,
- boss/elite restrictions where required,
- exact effect of each of the 19 existing upgrades.

Do not redesign the tools or add new upgrade branches.

**Exit condition:** each Prosthetic can be represented as one base data package plus its approved linear upgrades without a coder inventing its combat behavior.

# Next questions

## Relic implementation baseline

**Question:** What first-playtest values make the existing **10 Relics and two mastery ranks each** directly implementable?

Define Base / Mastery I / Mastery II values, qualifying triggers, reset rules, and mastery thresholds only where needed. Keep the existing roster intact.

## Corruption / Shrine / Blood completion

**Question:** What remaining numeric/state values are still missing after the combat, Aspect, and Technique baselines?

Fill only unresolved implementation data for Corruption thresholds/gain, Resist/Embrace/Stabilize, Blood generation/storage, and any shared Shrine/Blood state behavior not already owned elsewhere.

**Pass 2 exit condition:** the complete player-build layer can be instantiated without new design decisions in code.

# Pass 3 — Hushiro implementation-ready package

This is the first complete regional production target.

Resolve Hushiro as one connected package:

1. **Authored standard encounters** — practical launch pool, exact compositions, waves/spawns, and only necessary eligibility restrictions.
2. **Reusable gameplay-space inventory** — Combat, Shrine, Rest, Shop, Treasure, miniboss, Keeper, and transition spaces; not unique art per chamber.
3. **Village Ogre / Collector / Keeper implementation contracts** — move/state lists, selection rules, perilous/defensive classifications, escalation, arena behavior, posture/deathblow/death rules.

**Exit condition:** Hushiro can be built as a complete repeatable region and used for serious end-to-end Godot testing.

# Implementation restart gate

Do not wait for later-region documentation before returning to Godot.

The documentation-first phase has done its job when:

- player-build Pass 2 is implementation-ready,
- Hushiro Pass 3 is implementation-ready,
- the existing Godot project is audited against current authorities.

Then implementation and documentation proceed together.

# Later implementation-content packages

- **Strand / permanent progression:** exact Bloodwell/Blood Mirror effects, prices, Relic mastery thresholds, Prosthetic unlock sequence, Relic source assignments, Blood Cavern trial roster/rewards, save/progression flags.
- **Yomori:** encounter pool/layout inventory, Embered Pilgrim, Rotwood Host, Twin Maws, regional hazards.
- **Kagutsuchi / Shogun / Heart:** encounter pool/layout inventory, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Binding states, both Heart forms, first-clear/repeat-suppression state differences.
- **Authored presentation content:** exact dialogue, lore/records, achievements, tutorial/help text, ending/postgame lines, credits/legal when dependencies are known.

# Playtest backlog — not open design questions

Do not promote these back into the design queue unless testing reveals a structural problem:

- final damage/posture values,
- final attack/frame timing,
- final hitbox widths and VFX synchronization,
- final parry/dash windows,
- final enemy Health/damage,
- final proc coefficients and status durations,
- final Prosthetic magnitudes/cooldowns,
- final route/reward/rarity weights,
- final economy and progression prices,
- final encounter-volume adjustments,
- exact 45–50 / 55–60 minute pacing validation.

Use current first-playtest values, implement them, measure them, and revise the owning authority when evidence supports a change.