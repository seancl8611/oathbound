---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-26
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
11. **Kagutsuchi / Shogun / Heart handoff reconciliation — EXECUTED / VALIDATED** — PR #117 establishes the approved 11-counted-chamber Region 3 route, five-enemy Court roster, Blood Lotus / Eternal Swordsman opportunity, Eclipse Shogun endpoint, six-Binding campaign, seventh-run Heart handoff, downstream Story Complete/postgame contract flow, Shogun rewards, Heart-entry recovery, canonical runtime ownership, and deterministic full-route/endgame validation. The actual Heart combat encounter remains unauthored: the current runtime ends at a non-combat integration shell whose completion signal is driven only by explicit contract-test metadata.
12. **Authored presentation content — IMPLEMENTED / VALIDATION-TUNING** — PR #117 now includes the seven awakened Shogun states plus rare pre-awakening fallback, 30 major Strand conversations, 24 reactive line sets, 24 substantive Lore / Records entries, 30 launch achievement contracts, tutorial/help copy, ending/postgame text, campaign-aware narrative persistence, player-facing Strand interactions, and Discovery Board access. A dedicated Godot presentation contract protects the silent-Akio and ending boundaries.
13. **Release presentation / saves / records / settings — IMPLEMENTED / VALIDATION-TUNING** — PR #119 supplies the Oathbound front end, three isolated save slots, safe checkpoint/resume boundaries, pause/build overview, Run Results, postgame Boat run-goal selection, launch records/completion tracking, settings/rebinding/accessibility/audio/text controls, localization-ready presentation surfaces, Credits/legal evidence boundaries, and release validation. Completion now distinguishes the approved 10 Akio Bloodwell nodes from 8 Run Infrastructure nodes and all 24 authored Discovery Board records have reachable launch paths. Reserved unauthored challenge content remains excluded from 100% until it becomes player-accessible, as required by the Blood Cavern authority.
14. **Final integration / playtest tuning — NEXT** — structural Region 1 -> Region 2 -> Region 3 runtime handoff continuity is now automated through the production release `GameFlow`: area state stays synchronized across `GameFlow`, `RunData`, and `RouteGenerator`; Yomori and Kagutsuchi use their authored route authorities; Keeper/Twin safe Relic transition contexts remain intact; and the accumulated run build survives both handoffs. This does not replace player-facing validation. Perform the first long manual session from title/save selection through Hushiro, Yomori, Kagutsuchi, Eclipse Shogun, the Heart Approach handoff chamber, and entry into the current Heart shell. Stop the real-player route there until Heart combat is authored. Validate Run Results, Story Complete, and postgame continuity separately through the existing contract-test path, then continue numerical balance/economy tuning, final presentation-art replacement audit, readability/accessibility pass, and release QA without reopening already-closed system architecture unless testing finds a structural defect.

# Current implementation question — final integration / playtest tuning

**Question:** Does the integrated Godot build hold together across the complete currently playable player-facing route: title/save selection -> Hushiro -> Yomori -> Kagutsuchi -> Eclipse Shogun -> Heart Approach -> Heart shell boundary, including safe persistence, build state, route transitions, completion records available before that boundary, UI readability, accessibility settings, economy, difficulty curve, and total run pacing?

Automated route and contract validation remains the structural gate. PR #119 includes a dedicated release-runtime handoff smoke that executes the production Region 1 -> 2 -> 3 transition method and protects route authority, state synchronization, safe Relic boundaries, and accumulated-build continuity. Endgame validation separately proves the six-Binding / seventh-run routing contract and may drive the Heart shell's downstream completion signal only when explicit `contract_test` metadata is present; a normal gameplay Heart shell is required to reject that shortcut. Until Heart combat is actually authored, manual testing must not treat contract-driven Heart victory, Run Results, Story Complete, or completed-save postgame as a real player kill path.

The next manual playtest should therefore be a longer integration pass, not another narrow trial-and-error check. It should look for presentation, persistence, balance, readability, positioning, encounter feel, and cross-system defects from the release front end through the current Heart boundary. New architecture should be introduced only if that playtest exposes a genuine structural contradiction.

# Playtest workflow during content buildout

Do **not** require repeated full-route manual runs while major content packages are still being integrated.

Use the backtick Playtest Lab to isolate risky variables and regional content directly. Prefer short checks such as one enemy, one encounter, one room type, one miniboss, one boss phase, one reward path, one transition, one narrative state, or one save/settings surface. Automated route/contract validation remains the primary structural gate during buildout.

The release-facing shell is now integrated, and the production Region 1 -> 2 -> Region 3 state/route handoffs have a passing automated contract. A complete Hushiro -> Yomori -> Kagutsuchi -> Eclipse Shogun -> Heart Approach -> Heart shell manual run is the next milestone validation. Use that route to evaluate cross-region state persistence in actual play, interacting systems, economy, difficulty curve, total run duration, presentation, and whether the implementation feels coherent at player scale. Do not attempt to manually validate Heart victory or the resulting Run Results/postgame transition until an actual Heart combat path exists; those downstream contracts remain automated in the interim.

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
