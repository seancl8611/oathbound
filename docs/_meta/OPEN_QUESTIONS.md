---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-24
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

The former broad delta-audit gate has materially been executed through the current implementation sequence. Do not return to a broad audit as a prerequisite for ordinary implementation. Remaining mismatches should be handled in dependency-sized implementation packages and documented when found.

# Active implementation order

1. **Technique runtime stabilization — IMPLEMENTED / VALIDATION-TUNING** — the five canonical families, mixed-family interactions, universal action triggers, reward acquisition, and long-run cleanup are implemented at first-playtest depth. `TECHNIQUE_RUNTIME_IMPLEMENTATION.md` records the boundary.
2. **Blood Aspect runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — Wolf / Wraith / Ronin have current Tier 0 weapon kits, Tier I-IV mechanics, shared action-trigger metadata, applied-result Blood generation, Blood Arts, and debug Tier/Blood controls. `ASPECT_RUNTIME_IMPLEMENTATION.md` records the boundary.
3. **Current Prosthetic runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — the current eight-tool roster, 100-Spirit runtime, permanent 2 / 4 / 6 Scroll upgrade contract, HUD integration surface, and focused Playtest Lab controls are implemented.
4. **Relic runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — the one-slot persistent runtime, ten approved launch effects, kill mastery, Forge management, safe Keeper/Twin swap windows, Scribe rewards, Merchant integration, immediate-persistence discovery, and 4 / 2 / 4 source partition are implemented. `RELIC_RUNTIME_IMPLEMENTATION.md` records the boundary.
5. **Corruption / Shrine integration — IMPLEMENTED / VALIDATION-TUNING** — the approved 0 / 100 Corruption state, encounter credit/caps, first-death Returning Blood awakening, support Shrine, Resist, Embrace, Tier-IV Stabilize, awakened-only HUD state, and Aspect Tier bridge are implemented. `CORRUPTION_RUNTIME_IMPLEMENTATION.md` records the boundary.
6. **First complete Hushiro run validation — EXECUTED / VALIDATED** — PR #112 passed deterministic Hushiro route validation across 256 seeds and a complete automated 12-counted-chamber traversal through the Chamber 12 Keeper endpoint. `docs/_meta/decisions/2026-08-22-hushiro-full-run-validation.md` records the evidence.
7. **Compatibility retirement — EXECUTED / VALIDATED** — PR #113 removes obsolete Hushiro prototype authorities and forwarding trees while preserving the canonical current runtime. `docs/_meta/decisions/2026-08-22-compatibility-retirement.md` records the evidence.
8. **First-attempt base-katana / no-Aspect runtime reconciliation — EXECUTED / VALIDATED** — PR #114 implements the pre-awakening base-katana/no-Aspect state and first-death handoff into pre-run Aspect selection. `docs/_meta/decisions/2026-08-22-first-attempt-runtime-reconciliation.md` records the evidence.
9. **Strand / permanent progression — EXECUTED / VALIDATED** — PR #115 implements persistent Mist/Scroll/boss-material ownership, Bloodwell, Blood Mirror, persistent Forge progression, Blood Cavern first-clear claims, staged campaign gates, and all three canonical Strand progression stations. `docs/_meta/decisions/2026-08-22-strand-permanent-progression.md` records the boundary.
10. **Yomori region reconciliation — EXECUTED / VALIDATED** — PR #116 establishes the approved 10-counted-chamber route, four-enemy encounter authority, Embered Pilgrim / Rotwood Host opportunity, genuine Treasure chamber, Twin Maws endpoint, current Region 2 SceneRegistry ownership, focused visual/runtime validation, and region-aware targeted Playtest Lab controls. `docs/_meta/decisions/2026-08-23-yomori-region-reconciliation.md` records the boundary.
11. **Kagutsuchi / Shogun / Heart reconciliation — EXECUTED / VALIDATED** — PR #117 establishes the approved 11-counted-chamber Region 3 route, five-enemy Court roster, Blood Lotus / Eternal Swordsman opportunity, Eclipse Shogun endpoint, six-Binding campaign, seventh-run Heart handoff, Story Complete/postgame flow, Shogun rewards, Heart-entry recovery, canonical runtime ownership, and deterministic full-route/endgame validation.
12. **Authored presentation content — IMPLEMENTED / VALIDATION-TUNING** — PR #117 now includes the seven awakened Shogun states plus rare pre-awakening fallback, 30 major Strand conversations, 24 reactive line sets, 24 substantive Lore / Records entries, 30 launch achievement contracts, tutorial/help copy, ending/postgame text, campaign-aware narrative persistence, player-facing Strand interactions, and Discovery Board access. A dedicated Godot presentation contract protects the silent-Akio and ending boundaries.
13. **Release presentation / saves / records / settings — NEXT** — replace the prototype title screen with Oathbound front-end flow, implement three save slots and safe metadata/resume boundaries, implement completion/record tracking and Run Results, expose the required settings/accessibility/audio/text controls, wire completed-save Standard Expedition vs Heart Suppression selection, and add Credits/legal surfaces using only verified contributor/dependency information.
14. **Final integration / playtest tuning — AFTER RELEASE SHELL** — perform full-route manual validation, numerical balance/economy tuning, final presentation-art replacement audit, readability/accessibility pass, and release QA without reopening already-closed system architecture unless testing finds a structural defect.

# Current implementation question — release presentation / saves / records / settings

**Question:** Does the current Godot project provide the approved launch-facing shell around the already implemented game: Oathbound title identity, Continue/New Game with three save slots, safe persistent slot metadata and quit/resume boundaries, Story Complete/completion/records presentation, postgame run-goal selection, Run Results, settings/accessibility/audio/text controls, and Credits/legal surfaces?

The next implementation package should answer that question in code. It should reuse the existing MetaProgress, RunData, GameFlow, progression managers, and presentation catalog rather than introducing a parallel progression model.

# Playtest workflow during content buildout

Do **not** require repeated full-route manual runs while major content packages are still being integrated.

Use the backtick Playtest Lab to isolate risky variables and regional content directly. Prefer short checks such as one enemy, one encounter, one room type, one miniboss, one boss phase, one reward path, one transition, one narrative state, or one save/settings surface. Automated route/contract validation remains the primary structural gate during buildout.

A complete Hushiro -> Yomori -> Kagutsuchi -> Shogun / Heart manual run is a milestone validation after the release-facing shell is integrated. At that point, use the full route to evaluate cross-region state persistence, interacting systems, economy, difficulty curve, total run duration, return/results flow, and completed-save behavior.

# Playtest backlog — not open design questions

Do not promote these back into the design queue unless testing reveals a structural problem:

- final damage/posture values,
- final attack/frame timing,
- final hitbox widths and VFX synchronization,
- final enemy Health/damage,
- final encounter volume/wave timing,
- final Corruption/Blood pacing,
- final route/reward/economy weights,
- exact per-region and full-run duration validation,
- final presentation-art replacement for prototype visual scaffolding.