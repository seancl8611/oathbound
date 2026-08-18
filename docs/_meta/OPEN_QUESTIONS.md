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

The launch architecture is already scoped. A package leaves this queue once its authorities provide a coherent first-playtest implementation contract.

After that:

- do not reopen it as smaller follow-up passes merely because values can still be tuned,
- do not repeat work already answered by shared system/family constants,
- treat hitbox polish, frame tuning, VFX synchronization, minor coefficients, and ordinary balance as implementation/playtest work,
- reopen only for a genuine missing rule, contradiction, unusable interaction, or scope problem.

# Player-build layer — COMPLETE FOR PLANNING

The launch player-build layer now has coherent first-playtest implementation contracts for:

- **Core combat:** `COMBAT_IMPLEMENTATION_BASELINE.md`
- **Blood Aspects:** `ASPECT_IMPLEMENTATION_BASELINES.md` plus the three Aspect authorities
- **Techniques:** `TECHNIQUE_CATALOG.md` + `TECHNIQUE_IMPLEMENTATION_BASELINES.md`
- **Prosthetics:** `PROSTHETICS.md`
- **Relics:** `RELICS.md` + `RELIC_IMPLEMENTATION_BASELINE.md`
- **Corruption / Shrines:** `CORRUPTION_AND_SHRINES.md`
- **Blood meter / generation:** `BLOOD_ASPECTS.md`

The final shared resource/state contract now defines:

- 100-point Corruption meter and first-playtest event gain/caps,
- exact Resist / Embrace / Stabilize transitions,
- fixed Shrine recovery that restores both Health and Spirit while skipping already-full resources,
- 100-point Tier-II Blood meter,
- normalized Wolf / Wraith / Ronin Blood generation,
- multi-target limits, exclusions, overfill, ready/spent/rebuilding behavior.

Do not create another shared player-build planning pass unless implementation exposes a structural gap. Final Corruption/Blood rates and other ordinary tuning belong to playtesting.

# Current question — Hushiro implementation-ready package

**Question:** What exact authored encounter pool, reusable gameplay spaces, and miniboss/boss combat contracts are required to build Hushiro as the first complete repeatable region?

Resolve Hushiro as one connected package:

1. **Authored standard encounters** — launch pool, exact enemy compositions, waves/spawns where used, tactical purpose, and only necessary eligibility/anti-repeat restrictions.
2. **Reusable gameplay-space inventory** — the actual Combat, Shrine, Rest, Shop, Treasure, miniboss, Keeper, and transition layouts needed to support the approved 12-chamber route without unique art per chamber.
3. **Village Ogre / Collector / Keeper contracts** — move/state lists, attack selection conditions, block/parry/perilous classes, escalation/phases, arena behavior, posture/deathblow/death rules.

Do not reopen Hushiro's approved 12-chamber route, six-enemy roster, room weighting, miniboss window, Keeper endpoint, or reward architecture unless a concrete production incompatibility appears.

**Exit condition:** Hushiro can be built as a complete repeatable region and used for serious end-to-end Godot testing without a combat/content author inventing major encounter rules.

# Implementation restart gate

Do not wait for later regions.

Return seriously to implementation when:

- the player-build layer is implementation-ready — **complete for planning**,
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
- final Corruption/Blood gain pacing,
- final route/reward/rarity weights,
- final economy/progression prices,
- final encounter-volume adjustments,
- exact run-duration validation.
