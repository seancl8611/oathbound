---
id: OVERVIEW-PRODUCTION-ROADMAP
title: Production Roadmap
category: overview
status: approved
authority: primary
last_reviewed: 2026-09-16
---

# Production Roadmap

Oathbound production is organized by dependency order and meaningful playtest groups. Gameplay/content/narrative authorities own the underlying design; this file owns the current sequencing and milestone framing.

# Current phase — Combat V2 convergence and isometric 2D production proof

The current project is **not** pursuing a live-runtime 3D conversion. The accepted runtime remains authoritative planar 2D with a fixed high-angle Camera2D presentation, eight-direction actor art, feet-based Y depth, layered illustrated environments, and independent 2D combat VFX/telegraphs.

Current priorities are:

1. keep Combat V2 implementation and documentation synchronized around Health defeat, hidden Poise/interruption, room pressure, and kit-specific defense;
2. remove stale gameplay/UI/test/document references that assume superseded shared combat-resource or finisher systems;
3. validate the accepted Hushiro isometric 2D camera/composition with final-style actor scale and encounter readability;
4. complete the first **offline 3D rig → directional 2D** proof for Akio and one Corrupted Swordsman;
5. compare clean prerender and deliberate pixel/downsample treatment from the same source rig before scaling the roster;
6. continue evidence-backed combat, encounter, economy, reward, pacing, and accessibility tuning;
7. complete the true-final Heart combat package before release closure;
8. finish production art/VFX/audio, QA, localization, and legal/provenance work.

# Presentation gate — Akio + Corrupted Swordsman rig-rendered proof

Before mass actor production, prove the production pipeline on the two most useful representative sword characters.

The proof must demonstrate:

- a source character visually appropriate for Akio rather than a generic universal base,
- a source/retarget workflow capable of the required locomotion and sword actions,
- eight independent directions,
- fixed frame canvas and stable feet/contact anchor,
- readable silhouettes and anticipation at the accepted gameplay camera,
- no runtime dependency on the source 3D rig,
- practical Godot SpriteFrames/profile import,
- stable Y-depth behavior in multi-enemy scenes,
- and a controlled clean-prerender vs pixel-treatment comparison without gameplay changes.

Do not scale this pipeline across the roster until the proof is manually accepted.

# Milestone 1 — Hushiro combat vertical slice

Establish Akio, core combat readability, representative Area 1 enemies, shared combat VFX, Combat HUD, accepted isometric Camera2D framing, directional actor presentation, and the Hushiro environment composition language.

Akio remains a silent protagonist: no dialogue mouth cycles, response UI, or player-dialogue system is required.

**Current status:** gameplay/runtime foundations and the accepted camera/presentation seam exist. Remaining work is final-style actor/environment proof, Combat V2 cleanup, playtest tuning, and authored replacement art.

# Milestone 2 — Complete Area 1

Complete Hushiro's roster, authored encounter pool, reusable gameplay-space/layout inventory, both minibosses, Keeper of the Gate, functional-room skins, Shrine/Corruption foundations, regional props, and boss/miniboss UI.

Production supports the approved **12-chamber Hushiro** route through reusable room foundations/variants rather than unique art per chamber.

`docs/content/area_1/HUSHIRO_IMPLEMENTATION_BASELINE.md` owns the gameplay package. The first attempt uses this same normal route with base katana combat, default Beast-Bane Whistle, normal Technique rewards/room flow, and Shrine support without Aspect Embrace/Tier presentation.

**Current status:** first-playtest runtime and deterministic route validation exist. Current work is Combat V2 feel/readability, final isometric 2D presentation, and replacement assets.

# Milestone 3 — The Strand

Produce the six recurring NPCs, Strand environment, physical interactibles, training spaces, first-return/revival presentation, permanent-progression interfaces, and completed-save/postgame route-selection support.

Permanent station scope remains:

- Bloodwell — 10 Akio + 8 Infrastructure,
- Forge Bench — 19 Prosthetic upgrades + 10 Relics with two mastery ranks each,
- Blood Mirror — 9 nodes total, unlocked after first Keeper.

Narrative production remains text-led with silent Akio, major Strand conversations, reactive line sets, final pre-Heart states, and the post-ending explanation of the Heart's remaining remnant.

# Milestone 4 — Player combat depth and run-build expression

Complete:

- Wolf / Wraith / Ronin combat-presentation packages,
- Tier / Blood states,
- eight Prosthetic families,
- Technique reward/build UI,
- Relic presentation and mastery states,
- currencies/pickups/boss-material art,
- Blood Mirror presentation.

The active Technique paper-design baseline is currently **40 Techniques + 6 refinements** after reconciling the shared trigger catalog with Combat V2. The count is not a target to pad back upward; add new Techniques only when a concrete build, compatibility, or playtest need justifies them.

**Current status:** the five Technique families, three Aspect runtimes, Prosthetic roster, Relic runtime/mastery/acquisition, Corruption/Shrines, Blood generation, HUD/integration surfaces, and permanent progression bridges exist at first-playtest depth. Continue runtime/catalog reconciliation so dead trigger assumptions cannot enter reward offers.

# Milestone 5 — Complete Area 2

Produce Yomori Grove, its authored encounter pool and reusable gameplay-space/layout inventory, regional enemies/minibosses, Twin Maws, hazards, functional rooms, VFX, and integration.

Production supports the approved **10-chamber Yomori** route. Stalker Hound remains the sole approved evolved Hushiro lineage continuation.

**Current status:** route/content structure exists. Remaining work is player-facing combat integration, tuning, isometric 2D presentation, and final asset production.

# Milestone 6 — Area 3, campaign climax, Heart, and postgame suppression

Produce Kagutsuchi Court, its authored encounter pool/layout inventory, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Heart chamber, extraction apparatus, reusable Binding ritual, six Binding states, two-form true-final Heart, canonical ending, and repeat Heart-suppression presentation.

Production supports the approved **11-chamber Kagutsuchi** route.

The first six clears use the Binding ritual. The seventh story run continues from Shogun into the Heart. Postgame Heart Suppression uses the same approved Shogun-to-Heart handoff and a shortened repeat-clear presentation.

**Current status:** route/campaign/hand-off structure exists. The actual two-form Heart combat encounter still requires dedicated encounter design, implementation, art/readability work, and real-player validation. Encounter-specific stagger/vulnerability rules may be authored there, but should not be inferred from superseded shared-combat assumptions.

# Milestone 7 — Release presentation and cohesion

Complete:

- front-end and 3 save slots,
- Story Complete/completion-percentage presentation,
- Standard Expedition vs Heart Suppression Boat selection after Story Complete,
- achievements,
- records/personal-best presentation,
- settings/accessibility package,
- localization-ready text integration,
- credits/legal notices,
- store/platform art where required,
- missing-asset/readability audit,
- final production cleanup and QA.

English is the required launch language; additional languages remain optional according to budget/platform needs, but text systems must stay localization-ready.

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

# Production rules

- Wolf, Wraith, Ronin are fixed launch Aspects.
- Akio is fully silent.
- The first attempt is the normal full route.
- Beast-Bane Whistle is the starting Prosthetic.
- Standard Combat uses authored encounter scripts selected from regional pools.
- Regional route baseline remains **12 / 10 / 11 = 33 counted chambers**.
- Normal successful Binding-run target remains approximately **45–50 minutes**; Heart/Suppression approximately **55–60 minutes**.
- Existing permanent progression/economy/reward architectures remain stable unless testing exposes a concrete problem.
- Gameplay authority remains planar 2D.
- The production camera remains fixed high-angle/isometric-style Camera2D.
- Actor production targets eight-direction 2D presentation with stable feet anchors and feet-based Y depth.
- Offline 3D rigs may render 2D sprites; live 3D actors are outside the accepted runtime direction.
- The canonical Heart victory permanently prevents creation/propagation of new Beast Blood while preserving existing bearers and regeneration.
- Postgame is canonical continued containment with Standard Expedition and Heart Suppression run goals.
- No full spoken-dialogue VO is required.
- Markdown remains internal source of truth; Word/PDF are exports.
- First-playtest values are implementation baselines, not immutable final balance law.

# Current dependency sequence

Current implementation-facing order:

1. **Combat V2 stale-reference/runtime reconciliation**,
2. **Hushiro isometric 2D actor/environment readability proof**,
3. **Akio + Corrupted Swordsman rig-rendered 2D proof and style decision**,
4. **playtest-driven combat / economy / encounter / pacing tuning**,
5. **scale approved directional actor/environment production foundations across regions**,
6. **dedicated true-final Heart encounter design, implementation, and validation**,
7. **final VFX/audio/readability/accessibility polish**,
8. **release QA, localization, legal/provenance completion, and production cleanup**.

Use `docs/overview/ISOMETRIC_2D_PRESENTATION_DIRECTION.md` for presentation authority, `docs/art_production/RIG_RENDERED_2D_PIPELINE.md` for the actor-production seam, `docs/overview/V2_COMBAT_DIRECTION.md` for combat direction, and `docs/content/area_3/TRUE_FINAL_HEART.md` for the Heart design boundary.