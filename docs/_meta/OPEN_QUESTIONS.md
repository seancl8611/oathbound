---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-23
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
11. **Kagutsuchi / Shogun / Heart reconciliation — NEXT** — implement/reconcile the approved Region 3 route/layout, encounter pool, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Binding states, both Heart forms, first-clear/repeat-suppression differences, transitions, rewards, and current runtime ownership. Retire Region 3 compatibility aliases only when direct current authorities replace them and regression coverage proves the replacement.

# Current implementation question — reconcile Kagutsuchi / Shogun / Heart

**Question:** Does the current Region 3 / Kagutsuchi runtime implement the approved authored first-playtest package coherently across route/layout, standard encounters, minibosses, Eclipse Shogun, Binding/Heart sequence, first-clear vs repeat behavior, transitions, rewards, and current runtime ownership without relying on obsolete imported prototype authorities?

The next implementation package should answer that question in code rather than creating another planning pass where the approved documentation already supplies enough authority.

# Content package after Kagutsuchi

- **Authored presentation content:** exact dialogue, lore/records, achievements, tutorial/help text, ending/postgame lines, credits/legal when dependencies are known.

# Playtest workflow during content buildout

Do **not** require repeated full-route manual runs while major content packages are still being integrated.

Use the backtick Playtest Lab to isolate risky variables and regional content directly. Prefer short checks such as one enemy, one encounter, one room type, one miniboss, one boss phase, one reward path, or one transition. Automated route/contract validation remains the primary structural gate during buildout.

A complete Hushiro -> Yomori -> Kagutsuchi -> Shogun / Heart manual run is a milestone validation after the remaining region content is integrated. At that point, use the full route to evaluate cross-region state persistence, interacting systems, economy, difficulty curve, and total run duration.

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
