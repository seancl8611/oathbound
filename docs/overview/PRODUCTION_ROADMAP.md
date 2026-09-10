---
id: OVERVIEW-PRODUCTION-ROADMAP
title: Production Roadmap
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-09
---

# Production Roadmap

Oathbound production is organized by dependency order and meaningful playtest groups. Milestones summarize required production; gameplay/content/narrative/release authorities own the underlying design.

# Current phase — Final integration, playtest tuning, and production polish

The broad Godot documentation-to-code reconciliation is complete. The current build has first-playtest/runtime implementations for the launch player-build layer, all three authored regions, Strand/permanent progression, release-facing shell, narrative/presentation contracts, save slots, records/completion, settings/accessibility surfaces, and the Shogun-to-Heart handoff shell.

The current implementation phase is **final integration / playtest tuning**, not another architecture or documentation-reconciliation pass.

Current priorities are:

1. complete player-facing integration validation across the currently playable route and release shell,
2. fix only evidence-backed runtime/readability/persistence defects found by playtesting,
3. tune balance, economy, encounter feel, pacing, hitboxes, timing, and accessibility from playable evidence,
4. replace remaining prototype/debug presentation with final production art/VFX/audio where required,
5. complete release QA and legal/provenance cleanup,
6. design and author the actual two-form Heart combat encounter before treating Heart victory/postgame as a normal player kill path.

`OPEN_QUESTIONS.md` owns the current implementation question and validation boundary. Approved first-playtest values remain implementation baselines and may move when playtesting provides better evidence.

# Pre-milestone gate — Paid Style Test

Lock practical sprite scale, palette, detail density, high-angle perspective, outline treatment, ground shadow, Hushiro tone, and Godot import quality before final production-art replacement where those items are still outstanding.

This remains an art-production gate where applicable, not a blocker that requires reopening already-implemented gameplay architecture.

# Milestone 1 — Combat vertical slice

Establish Akio, core combat readability, three representative Area 1 enemies, five shared combat VFX, Combat HUD, and the base Hushiro environment kit.

Akio's launch presentation supports the silent-protagonist rule: no dialogue mouth cycles, response UI, or player-dialogue system is required.

**Current status:** gameplay/runtime foundations are implemented and have received repeated integration hardening. Remaining work is playtest-driven readability/tuning plus replacement of prototype/debug presentation with final authored production content where still needed.

# Milestone 2 — Complete Area 1

Complete the Hushiro roster, authored encounter pool, reusable gameplay-space/layout inventory, both minibosses, Keeper of the Gate, functional-room skins, Shrine/Corruption foundations, regional props, and boss/miniboss UI.

Production supports the approved **12-chamber Hushiro** route through reusable room foundations/variants rather than unique art per chamber.

The authored gameplay package is owned by `docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md`. The first attempt uses this same normal route with base katana combat, default Beast-Bane Whistle, normal Technique rewards/room flow, and Shrine support without Aspect Embrace/Tier presentation.

**Current status:** Hushiro's first-playtest runtime is implemented and deterministic full-route validation has passed. Current work is integration feel, balance/readability, and final presentation-art replacement rather than another Hushiro planning or implementation-restart pass.

# Milestone 3 — The Strand

Produce the six recurring NPCs, Strand environment, physical interactibles, training spaces, first-return/revival presentation, permanent-progression interfaces, and completed-save/postgame route-selection support.

Permanent station scope:

- Bloodwell — 10 Akio + 8 Infrastructure,
- Forge Bench — 19 Prosthetic upgrades + 10 Relics with two mastery ranks each,
- Blood Mirror — 9 nodes total, unlocked after first Keeper.

Relic Base/Mastery numerical values and the 75 / 200 mastery thresholds remain owned by `RELIC_IMPLEMENTATION_BASELINE.md` and should not be reopened absent playtest evidence.

Narrative production uses approximately 30–36 major Strand conversations, reactive line sets, final pre-Heart states, and a concise post-ending Keeper/Scribe explanation that the Heart still pulses but can never create/spread new Beast Blood again.

**Current status:** persistent Mist/Scroll/boss-material ownership, Bloodwell, Blood Mirror, Forge progression, Blood Cavern first-clear claims, campaign gates, Strand progression stations, major Strand conversations, reactive presentation, and release-facing Strand interactions are implemented at first-playtest depth. Remaining work is tuning, final presentation polish, and any evidence-backed integration fixes.

# Milestone 4 — Player combat depth and run-build expression

Complete:

- Wolf / Wraith / Ronin combat-presentation packages,
- Tier / Blood states,
- eight Prosthetic families,
- Technique reward/build UI,
- Relic presentation and mastery states,
- currencies/pickups/boss-material art,
- Blood Mirror presentation.

Current roster remains **50 Techniques + 10 refinements**, **10 Relics**, and **8 Prosthetics / 19 upgrades** unless testing exposes a concrete gap.

**Current status:** the five Technique families, Wolf/Wraith/Ronin Aspect runtimes, current eight-tool Prosthetic roster and upgrades, Relic runtime/mastery/acquisition, Corruption/Shrines, Blood generation, HUD/integration surfaces, and permanent progression bridges are implemented at first-playtest depth. Final numerical balance and final production presentation remain playtest/art work.

# Milestone 5 — Complete Area 2

Produce Yomori Grove, its authored encounter pool and reusable gameplay-space/layout inventory, regional enemies/minibosses, Twin Maws, hazards, functional rooms, VFX, and integration.

Production supports the approved **10-chamber Yomori** route. Stalker Hound remains the sole approved evolved Hushiro lineage continuation.

Yomori content reuses the proven Hushiro encounter/layout method rather than inventing a separate documentation format.

**Current status:** Yomori's 10-counted-chamber route, four-enemy encounter authority, Embered Pilgrim / Rotwood Host opportunity, Treasure chamber, Twin Maws endpoint, current Region 2 ownership, regional Playtest Lab controls, and cross-region handoff are implemented and validated structurally. Current work is player-facing integration/readability/tuning and final presentation polish.

# Milestone 6 — Area 3, campaign climax, Heart, and postgame suppression

Produce Kagutsuchi Court, its authored encounter pool/layout inventory, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Heart chamber, extraction apparatus, reusable Binding ritual, six Binding states, two-form true-final Heart, canonical ending, and repeat Heart-suppression presentation.

Production supports the approved **11-chamber Kagutsuchi** route.

Narrative/endgame production includes:

- 7 awakened Shogun states + rare pre-awakening fallback,
- bloodline reveal at Shogun state 3,
- 6 states of one reusable Binding ritual,
- Binding 6 / final-run setup,
- first Heart victory that permanently ends **new Beast Blood creation/spread** without erasing existing Beast Blood,
- ending/credits,
- postgame Heart regrowth/suppression state,
- continued Shogun/Akio reconstruction continuity.

The first six clears use the Binding ritual. The seventh story run continues from Shogun into the Heart. Postgame Heart Suppression uses the same approved Shogun-to-Heart handoff and a shortened repeat-clear presentation.

**Current status:** Kagutsuchi's 11-counted-chamber route, five-enemy Court roster, Blood Lotus / Eternal Swordsman opportunity, Eclipse Shogun endpoint, six-Binding campaign flow, Shogun rewards/dialogue states, seventh-run Heart routing, Heart-entry recovery, ending/postgame contract surfaces, and canonical runtime ownership are implemented/validated structurally. The normal player-facing Heart encounter is still an integration shell.

The actual two-form Heart combat encounter is **not implementation-ready yet**. `docs/content/area_3/TRUE_FINAL_HEART.md` intentionally locks the encounter role, identity, two-form structure, story consequence, and postgame role while leaving exact attacks/combinations, movement, parryability, posture/stagger rules, phase transition, arena, health/damage tuning, animation, VFX/audio, and accessibility details for a dedicated encounter-design/playtest pass. Do not invent those details from implementation convenience.

# Milestone 7 — Release presentation and cohesion

Complete:

- front-end and 3 save slots,
- Story Complete/completion-percentage presentation,
- Standard Expedition vs Heart Suppression Boat selection after Story Complete,
- approximately 30 achievements,
- records/personal-best presentation,
- settings/accessibility package,
- localization-ready text integration,
- credits/legal notices,
- store/platform art where required,
- missing-asset/readability audit,
- final production cleanup and QA.

Launch narrative remains approximately 15,000–20,000 words, text-led, with no Akio dialogue and no full spoken-dialogue VO requirement.

English is the required launch language; additional languages are optional promotion according to budget/platform needs, but text systems must remain localization-ready.

**Current status:** the release-facing front end, three isolated save slots, safe checkpoint/resume boundaries, pause/build overview, Run Results contract, postgame Boat run-goal selection, records/completion tracking, settings/rebinding/accessibility/audio/text surfaces, localization-ready presentation, authored narrative/records/achievement contracts, and Credits/legal evidence boundaries are implemented at first-playtest/release-contract depth. Remaining release work is final integration, real-player validation, production-art/readability replacement, tuning, QA, and completion of any missing legal/provenance evidence.

# Locked launch exclusions

Initial release does **not** require:

- Heat/Pact-style modifiers,
- New Game+,
- endless mode,
- daily challenges,
- postgame enemy/room variant packages,
- another Blood Aspect,
- another campaign,
- another permanent progression tree,
- another persistent currency,
- a general consumable inventory.

These may be revisited only after playable testing or post-launch player demand establishes a concrete need.

# Production rules

- Wolf, Wraith, Ronin are fixed launch Aspects.
- Akio is fully silent.
- The first attempt is the normal full route.
- Beast-Bane Whistle is the starting Prosthetic.
- Standard Combat uses authored encounter scripts selected from regional pools.
- Regional route baseline remains 12 / 10 / 11 = 33 counted chambers.
- Normal successful Binding-run target remains 45–50 minutes; Heart/Suppression target remains 55–60.
- Existing permanent progression/economy/reward architectures remain stable unless testing exposes a concrete problem.
- The canonical Heart victory permanently prevents creation/propagation of **new Beast Blood** while preserving existing bearers and regeneration.
- Postgame is canonical continued containment with Standard Expedition and Heart Suppression run goals.
- No full spoken-dialogue VO is required.
- Markdown remains internal source of truth; Word/PDF are exports.
- First-playtest values are implementation baselines, not immutable final balance law.

# Current dependency sequence

There is no remaining top-level architecture question and no remaining broad documentation-to-code audit gate.

Executed/implemented at first-playtest depth:

1. shared combat baseline and runtime reconciliation,
2. Blood Aspects,
3. Techniques,
4. Prosthetics,
5. Relics,
6. Corruption / Shrines / Blood resource-state contract,
7. Hushiro full-run runtime,
8. first-attempt base-katana/no-Aspect flow,
9. Strand/permanent progression,
10. Yomori region,
11. Kagutsuchi / Shogun / Heart-handoff shell,
12. authored presentation/narrative content,
13. release presentation / saves / records / settings,
14. structural Region 1 -> Region 2 -> Region 3 handoff continuity.

Current implementation-facing order:

1. **final player-facing integration and evidence-backed stability/readability fixes**,
2. **playtest-driven combat / economy / encounter / pacing tuning**,
3. **final presentation-art, VFX, audio, readability, and accessibility replacement/polish**,
4. **dedicated true-final Heart encounter design, then implementation and real-player validation**,
5. **release QA, legal/provenance completion, and final production cleanup**.

Use `docs/_meta/OPEN_QUESTIONS.md` for the exact current implementation question and manual-validation boundary. Use `docs/overview/ENDGAME_POSTGAME_RELEASE.md` for the locked release/postgame package and `docs/content/area_3/TRUE_FINAL_HEART.md` for the Heart design boundary.
