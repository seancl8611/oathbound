---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-22
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
- canonical persistent Mist / Scroll / boss-material ownership and staged Strand progression;
- the current 50-Technique catalog, no-slot acquisition model, eligibility, rarity/source weighting, rerolls, and reward UI;
- first-playtest Echo / Rupture / Seal / Rift / Crimson combat execution;
- first-playtest Wolf / Wraith / Ronin weapon kits, Tier 0-IV runtime rules, shared Blood generation, and Blood Arts;
- current Prosthetic roster, Spirit runtime, persistent 2 / 4 / 6 Scroll upgrade contract, and test controls;
- current persistent Relic slot/mastery/effect runtime, Forge management, safe swap windows, and 4 / 2 / 4 source partition;
- current run-scoped Corruption authority, first-death Returning Blood awakening, Shrine support / Resist / Embrace / Stabilize flow, and Aspect Tier advancement bridge;
- explicit first-attempt base-katana / no-Aspect runtime state and first-death handoff into pre-run Aspect selection;
- current Bloodwell, Forge Bench, and Keeper-gated Blood Mirror persistent-progression stations with campaign/save state and focused CI coverage.

Do not return to a broad audit as a prerequisite for ordinary implementation. Remaining mismatches should be handled in dependency-sized implementation packages and documented when found.

# Current implementation question — reconcile Yomori

**Question:** Does the current Region 2 / Yomori runtime implement the approved authored first-playtest package coherently across its route/layout, encounter pool, Embered Pilgrim, Rotwood Host, Twin Maws, regional hazards, transitions, rewards, and current runtime ownership without relying on obsolete forwarding aliases or imported prototype authorities?

The active implementation order is now:

1. **Technique runtime stabilization — IMPLEMENTED / VALIDATION-TUNING** — the five canonical families, mixed-family interactions, universal action triggers, reward acquisition, and long-run cleanup are implemented at first-playtest depth. `TECHNIQUE_RUNTIME_IMPLEMENTATION.md` records the boundary; remaining work is runtime validation/tuning rather than another design pass.
2. **Blood Aspect runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — Wolf / Wraith / Ronin have current Tier 0 weapon kits, Tier I-IV mechanics, shared action-trigger metadata, applied-result Blood generation, Blood Arts, and debug Tier/Blood controls. `ASPECT_RUNTIME_IMPLEMENTATION.md` records the boundary. Natural Tier advancement is called by the approved Corruption Shrine Embrace flow.
3. **Current Prosthetic runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — the current eight-tool roster, 100-Spirit runtime, permanent 2 / 4 / 6 Scroll upgrade contract, HUD integration surface, and focused Playtest Lab controls are implemented. Remaining work is long-run interaction validation rather than reopening Prosthetic planning.
4. **Relic runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — the one-slot persistent runtime, ten approved launch effects, kill mastery, Forge management, safe Keeper/Twin swap windows, Scribe four-card rewards, current Merchant economy integration, immediate-persistence discovery, and 4 / 2 / 4 source partition are implemented. `RELIC_RUNTIME_IMPLEMENTATION.md` records the core runtime boundary.
5. **Corruption / Shrine integration — IMPLEMENTED / VALIDATION-TUNING** — the approved 0 / 100 Corruption state, encounter credit/caps, first-death Returning Blood awakening, support Shrine, Resist, Embrace, Tier-IV Stabilize, awakened-only HUD state, and Aspect Tier bridge are implemented. `CORRUPTION_RUNTIME_IMPLEMENTATION.md` records the runtime contract and explicit authored-boss checkpoint boundary.
6. **First complete Hushiro run validation — EXECUTED / VALIDATED** — PR #112 passed deterministic Hushiro route validation across 256 seeds and a complete automated 12-counted-chamber traversal through the Chamber 12 Keeper/boss endpoint. `docs/_meta/decisions/2026-08-22-hushiro-full-run-validation.md` records the permanent evidence and validation boundary.
7. **Compatibility retirement — EXECUTED / VALIDATED** — PR #113 removes obsolete Hushiro prototype authorities and forwarding trees while preserving the canonical current runtime. `docs/_meta/decisions/2026-08-22-compatibility-retirement.md` records the evidence and the one explicitly contained inert imported-Archer fallback.
8. **First-attempt base-katana / no-Aspect runtime reconciliation — EXECUTED / VALIDATED** — PR #114 implements a genuine pre-awakening base-katana/no-Aspect state, prevents pre-awakening Tier/Blood/Aspect leakage, preserves Beast-Bane Whistle and universal Technique triggers, and adds explicit awakened Aspect selection at The Well. `docs/_meta/decisions/2026-08-22-first-attempt-runtime-reconciliation.md` records the evidence.
9. **Strand / permanent progression — EXECUTED / VALIDATED** — PR #115 implements persistent Mist/Scroll/boss-material ownership, the 18-node Bloodwell, 9-node Keeper-gated Blood Mirror, persistent Forge Prosthetic state and 66-Scroll rank economy, the 4 / 2 / 4 Relic source partition, Blood Cavern first-clear claims, staged campaign gates, and all three canonical Strand progression stations. Exact implementation head `eed625addf7ffee606e8289e34e2a57ca7972a20` passed the full Godot 4.7.2 project gate including the dedicated Strand progression contract. `docs/_meta/decisions/2026-08-22-strand-permanent-progression.md` records the permanent boundary.
10. **Yomori region reconciliation — NEXT** — implement/reconcile the approved Region 2 route/layout, encounter pool, Embered Pilgrim, Rotwood Host, Twin Maws, regional hazards, transitions, and reward integration. Retire Yomori compatibility aliases only when current direct authorities replace them and regression coverage proves the replacement.

The goal is not to require a separate playtest after every micro-fix. Build coherent dependency-sized batches, then use longer telemetry-backed playtests to find interacting defects together. Accuracy and consistency with approved authorities still take precedence over merely increasing change volume.

# Next content packages after Yomori

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
