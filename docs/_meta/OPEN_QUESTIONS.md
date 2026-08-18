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

This file contains only decisions or audits that materially block implementation or authored launch content.

A package leaves this queue once its authorities provide a coherent first-playtest implementation contract. After that, do not subdivide it into more planning passes merely because ordinary tuning remains.

# Player-build layer — COMPLETE FOR PLANNING

Implementation-ready first-playtest contracts now exist for:

- core combat,
- Blood Aspects,
- Techniques,
- Prosthetics,
- Relics,
- Corruption / Shrines,
- Blood meter / generation.

Do not reopen these packages unless implementation exposes a structural contradiction.

# Hushiro — COMPLETE FOR PLANNING

`docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md` now supplies:

- **10 authored standard encounters**,
- discrete 2-4-wave chamber scripts with the next wave beginning only after the prior wave is cleared,
- roughly **10-18 total enemies** in normal rooms, with a lightweight Hound-heavy room reaching 19,
- a normal **6-active-enemy readability cap**,
- five reusable standard Combat footprints plus the required functional/special spaces,
- first-playtest standard-enemy durability calibration,
- complete Village Ogre and Collector combat contracts,
- complete two-phase Keeper contract.

Do not create another Hushiro planning pass for final wave timing, exact enemy attack damage, active frames, minor spawn positions, or final room volume. Those belong to Godot playtesting unless a structural problem appears.

# Current question — Godot documentation-to-code delta audit

**Question:** What currently exists in the Godot project, how does it differ from the approved documentation, and what is the shortest implementation order that produces the first complete Hushiro run?

Audit the current `game/` project against the approved authorities and classify each relevant item as:

- **matches current authority**,
- **implemented from superseded design**,
- **partially implemented**,
- **missing**,
- **obsolete / remove**.

Audit in dependency order:

1. project/bootstrap/input/save foundations needed to run the current build,
2. Akio movement, dash, block/parry, posture, deathblow, Spirit, and combat-state foundations,
3. Wolf / Wraith / Ronin action-kit support and shared action tags,
4. Technique, Prosthetic, Relic, Corruption/Shrine, and Blood state/data support,
5. Hushiro six-enemy roster and shared enemy AI/combat hooks,
6. authored multi-wave encounter runner and room-clear/reward flow,
7. Hushiro reusable rooms/routing integration,
8. Village Ogre, Collector, and Keeper,
9. HUD/UI states required for the first end-to-end region test.

For each mismatch, prefer changing code to the approved authority. Do not silently revive superseded design because it already exists in the old Godot implementation.

**Exit condition:** produce one prioritized implementation backlog that identifies what can be retained, what must be refactored, what must be added, and the minimum path to a playable 12-chamber Hushiro run.

# Implementation restart gate

The player-build layer and Hushiro are now complete for planning. After the Godot delta audit, implementation should resume immediately rather than waiting for Yomori, Kagutsuchi, permanent-progression polish, final narrative, or final balance.

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
- final enemy Health/damage,
- final encounter volume/wave timing,
- final Corruption/Blood pacing,
- final route/reward/economy weights,
- exact run-duration validation.
