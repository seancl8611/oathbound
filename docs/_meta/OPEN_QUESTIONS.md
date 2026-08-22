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
- canonical persistent Mist / Scroll / boss-material ownership and Bloodwell structure;
- the current 50-Technique catalog, no-slot acquisition model, eligibility, rarity/source weighting, rerolls, and reward UI;
- first-playtest Echo / Rupture / Seal / Rift / Crimson combat execution;
- first-playtest Wolf / Wraith / Ronin weapon kits, Tier 0-IV runtime rules, shared Blood generation, and Blood Arts;
- current Prosthetic roster, Spirit runtime, permanent upgrade contract, and test controls;
- current persistent Relic slot/mastery/effect runtime, Forge management, safe swap windows, and current Shop economy surface;
- current run-scoped Corruption authority, first-death Returning Blood awakening, Shrine support / Resist / Embrace / Stabilize flow, and Aspect Tier advancement bridge.

Do not return to a broad audit as a prerequisite for ordinary implementation. Remaining mismatches should be handled in dependency-sized implementation packages and documented when found.

# Current implementation question — reconcile the first-attempt base-katana / no-Aspect boundary

**Question:** Does the current new-run / first-attempt runtime correctly preserve the approved pre-awakening base-katana, no-Aspect state until Returning Blood awakens the Aspect layer, without leaking post-awakening combat-loadout assumptions into that opening attempt?

The active implementation order is now:

1. **Technique runtime stabilization — IMPLEMENTED / VALIDATION-TUNING** — the five canonical families, mixed-family interactions, universal action triggers, reward acquisition, and long-run cleanup are implemented at first-playtest depth. `TECHNIQUE_RUNTIME_IMPLEMENTATION.md` records the boundary; remaining work is runtime validation/tuning rather than another design pass.
2. **Blood Aspect runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — Wolf / Wraith / Ronin have current Tier 0 weapon kits, Tier I-IV mechanics, shared action-trigger metadata, applied-result Blood generation, Blood Arts, and debug Tier/Blood controls. `ASPECT_RUNTIME_IMPLEMENTATION.md` records the boundary. Natural Tier advancement is now called by the approved Corruption Shrine Embrace flow.
3. **Current Prosthetic runtime reconciliation — IMPLEMENTED / VALIDATION-TUNING** — the current eight-tool roster, 100-Spirit runtime, permanent upgrade contract, Shop/HUD integration surface, and focused Playtest Lab controls are implemented on the current stack. Remaining work is long-run interaction validation rather than reopening Prosthetic planning.
4. **Relic runtime reconciliation — IMPLEMENTED ON CURRENT STACK / VALIDATION-TUNING** — the one-slot persistent runtime, ten approved launch effects, kill mastery, Forge management, safe Keeper/Twin swap windows, Scribe four-card rewards, current Merchant economy integration, and generic immediate-persistence discovery flow are implemented. `RELIC_RUNTIME_IMPLEMENTATION.md` records the boundary. Exact 4 / 2 / 4 Relic source identity assignment remains intentionally deferred to permanent-progression/content sequencing.
5. **Corruption / Shrine integration — IMPLEMENTED / VALIDATION-TUNING** — the approved 0 / 100 Corruption state, encounter credit/caps, first-death Returning Blood awakening, support Shrine, Resist, Embrace, Tier-IV Stabilize, awakened-only HUD state, and Aspect Tier bridge are implemented. `CORRUPTION_RUNTIME_IMPLEMENTATION.md` records the runtime contract and explicit authored-boss checkpoint boundary.
6. **First complete Hushiro run validation — EXECUTED / VALIDATED** — PR #112 passed deterministic Hushiro route validation across 256 seeds and a complete automated 12-counted-chamber traversal through the Chamber 12 Keeper/boss endpoint on implementation head `093d36bb022bd946f6bd73fd6863ee9416a2305e`. `docs/_meta/decisions/2026-08-22-hushiro-full-run-validation.md` records the permanent evidence and validation boundary. Longer interactive playtesting remains appropriate for feel, pacing, balance, encounter pressure, and economy tuning, but this structural/runtime gate is closed.
7. **Compatibility retirement — EXECUTED / VALIDATED** — PR #113 removes the obsolete `UpgradeDb` / `StanceEffects` prototype authorities, dead UpgradeDb item-card surface, moved Area1 prototypes, and Hushiro-only Area1 forwarding trees while preserving the canonical current runtime. The exact implementation head `bec2ab584a18233e42d495915060d17ea5a51a06` passed the full Godot 4.7.2 project gate, including canonical RunScene ownership, Corruption, the 256-seed Hushiro contract, complete 12-chamber traversal, Shrine, Merchant, and Forge validation. `docs/_meta/decisions/2026-08-22-compatibility-retirement.md` records the permanent evidence and the one explicitly contained inert imported-Archer fallback.
8. **First-attempt base-katana / no-Aspect runtime reconciliation — NEXT** — verify and reconcile the opening-attempt combat-loadout boundary so a new run remains on the approved base-katana / no-Aspect state before Returning Blood awakening, while the existing first-death awakening cleanly hands control to the already-implemented Aspect / Corruption runtime. Keep this as a runtime-integration package: do not redesign the approved Corruption, Shrine, Aspect, Technique, or Hushiro contracts merely to make the boundary easier to implement.

The goal is not to require a separate playtest after every micro-fix. Build coherent dependency-sized batches, then use longer telemetry-backed playtests to find interacting defects together. Accuracy and consistency with approved authorities still take precedence over merely increasing change volume.

# Next content packages after the current-runtime integration pass

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
