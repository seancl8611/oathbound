---
id: OVERVIEW-PRODUCTION-ROADMAP
title: Production Roadmap
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-18
---

# Production Roadmap

Oathbound production is organized by dependency order and meaningful playtest groups. Milestones summarize required production; gameplay/content/narrative/release authorities own the underlying design.

# Pre-milestone gate — Paid Style Test

Lock practical sprite scale, palette, detail density, high-angle perspective, outline treatment, ground shadow, Hushiro tone, and Godot import quality before Milestone 1.

# Milestone 1 — Combat vertical slice

Establish Akio, core combat readability, three representative Area 1 enemies, five shared combat VFX, Combat HUD, and the base Hushiro environment kit.

Akio's launch presentation already supports the silent-protagonist rule: no dialogue mouth cycles, response UI, or player-dialogue system is required.

# Milestone 2 — Complete Area 1

Complete the Hushiro roster, authored encounter pool, both minibosses, Keeper of the Gate, functional-room skins, Shrine/Corruption foundations, regional props, and boss/miniboss UI.

Production supports the approved **12-chamber Hushiro** prototype through reusable room foundations/variants rather than unique art per chamber.

The first attempt uses this same normal route with base katana combat, default Beast-Bane Whistle, normal Technique rewards/room flow, and Shrine support without Aspect Embrace/Tier presentation.

# Milestone 3 — The Strand

Produce the six recurring NPCs, Strand environment, physical interactibles, training spaces, first-return/revival presentation, permanent-progression interfaces, and completed-save/postgame route-selection support.

Permanent station scope:

- Bloodwell — 10 Akio + 8 Infrastructure,
- Forge Bench — 19 Prosthetic upgrades + 10 Relics with two mastery ranks each,
- Blood Mirror — 9 nodes total, unlocked after first Keeper.

Narrative production uses approximately 30–36 major Strand conversations, 4–6 reactive line sets per NPC, final pre-Heart states, and a concise post-ending Keeper/Scribe explanation that the Heart still pulses but can never create/spread new Beast Blood again.

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

# Milestone 5 — Complete Area 2

Produce Yomori Grove, its authored encounter pool, regional enemies/minibosses, Twin Maws, hazards, functional rooms, VFX, and integration.

Production supports the approved **10-chamber Yomori** prototype. Stalker Hound remains the sole approved evolved Hushiro lineage continuation.

# Milestone 6 — Area 3, campaign climax, Heart, and postgame suppression

Produce Kagutsuchi Court, its authored encounter pool, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Heart chamber, extraction apparatus, reusable Binding ritual, six Binding states, two-form true-final Heart, canonical ending, and repeat Heart-suppression presentation.

Production supports the approved **11-chamber Kagutsuchi** prototype.

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

Exact Shogun/Heart attacks and encounter tuning remain the dedicated encounter-design pass.

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

English is the required launch language; additional languages are optional promotion according to budget/platform needs, but text systems must be localization-ready.

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

# Current pre-production dependency

There is no remaining top-level architecture question.

The next production-design work is:

1. author the actual regional standard-encounter pools,
2. design playable miniboss/boss encounter packages,
3. design the two-form Heart encounter,
4. realize exact narrative/achievement/trial content,
5. playtest/tune numerical values and full-run pacing.

Use `docs/_meta/OPEN_QUESTIONS.md` for the active content-production sequence and `docs/overview/ENDGAME_POSTGAME_RELEASE.md` for the locked release/postgame package.
