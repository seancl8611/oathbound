---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-21
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

Implementation-ready first-playtest contracts exist for:

- core combat,
- Blood Aspects,
- Techniques,
- Prosthetics,
- Relics,
- Corruption / Shrines,
- Blood meter / generation.

Do not reopen these packages unless implementation exposes a structural contradiction.

# Hushiro — COMPLETE FOR PLANNING

`docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md` supplies the authored first-playtest region package, including the 12-chamber route, standard encounter pool, six-enemy roster, miniboss opportunity, Keeper endpoint, and reusable Chamber requirements.

Do not create another Hushiro planning pass for final wave timing, exact enemy attack damage, active frames, minor spawn positions, final room volume, or final economy weights. Those belong to Godot playtesting unless a structural problem appears.

# Godot documentation-to-code delta audit — EXECUTED

The former delta-audit gate has materially been executed through the implementation sequence that now includes:

- the Godot 4.7.2 project baseline and canonical `game/oathbound/` root;
- Akio's current core-combat rules layer, combat telemetry, and Playtest Lab;
- the Hushiro 12-chamber route and authored multi-wave encounter flow;
- all six Hushiro standard-enemy contracts and current pressure coordination;
- Village Ogre / Collector miniboss integration and Keeper reward flow;
- canonical persistent Mist / Scroll / boss-material ownership and Bloodwell structure;
- the current 50-Technique catalog, no-slot acquisition model, eligibility, rarity/source weighting, rerolls, and reward UI;
- first-playtest Echo / Rupture / Seal / Rift / Crimson combat execution.

Do not return to a broad audit as a prerequisite for ordinary implementation. Remaining mismatches should be handled in dependency-sized implementation packages and documented when found.

# Current implementation question — complete the first current Hushiro run

**Question:** Which remaining current player-build/runtime systems prevent a complete Hushiro run from representing the approved documentation rather than imported prototype behavior?

The active implementation order is:

1. **Technique runtime stabilization** — validate the five canonical families, mixed-family interactions, all action triggers, reward acquisition, and long-run state cleanup. `TECHNIQUE_RUNTIME_IMPLEMENTATION.md` records the current boundary.
2. **Blood Aspect runtime reconciliation** — ensure Wolf / Wraith / Ronin current action kits and Tier progression drive the same shared action tags used by Techniques.
3. **Current Prosthetic runtime reconciliation** — preserve approved equipped-tool behavior while retiring superseded imported assumptions.
4. **Relic runtime reconciliation** — connect the approved run-scoped passive rules and acquisition/source behavior.
5. **Corruption / Shrine / Blood runtime reconciliation** — replace remaining prototype state with the approved Corruption choices, Blood generation/spend rules, and related HUD feedback.
6. **First complete Hushiro run validation** — play the 12-chamber route through Keeper with the current build layer active and resolve structural/runtime defects found across the package.
7. **Compatibility retirement** — remove old UpgradeDb/StanceEffects and other imported authorities only after no current caller requires them.

The goal is not to require a separate playtest after every micro-fix. Build coherent dependency-sized batches, then use longer telemetry-backed playtests to find interacting defects together. Accuracy and consistency with approved authorities still take precedence over merely increasing change volume.

# Next content packages after the Hushiro current-runtime pass

- **Strand / permanent progression:** final Bloodwell/Blood Mirror effects and prices, Prosthetic unlock sequence, Relic source assignments, Blood Cavern trials/rewards, and save/progression flags.
- **Yomori:** encounter pool/layout implementation, Embered Pilgrim, Rotwood Host, Twin Maws, and regional hazards.
- **Kagutsuchi / Shogun / Heart:** encounter pool/layout implementation, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Binding states, both Heart forms, and first-clear/repeat-suppression differences.
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