---
id: OVERVIEW-PRODUCTION-ROADMAP
title: Production Roadmap
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-18
---

# Production Roadmap

Oathbound production is organized by dependency order and meaningful playtest groups. Milestones summarize required production; gameplay/content/narrative authorities own the underlying design.

# Pre-milestone gate — Paid Style Test

Lock practical sprite scale, palette, detail density, high-angle perspective, outline treatment, ground shadow, Hushiro tone, and Godot import quality before Milestone 1.

# Milestone 1 — Combat vertical slice

Establish Akio, core combat readability, three representative Area 1 enemies, five shared combat VFX, Combat HUD, and the base Hushiro environment kit.

Akio's launch presentation must already support the **silent-protagonist rule**: no dialogue mouth cycles, response UI, or player-dialogue system is required.

# Milestone 2 — Complete Area 1

Complete the Hushiro roster, both minibosses, Keeper of the Gate, functional-room skins, Shrine/Corruption foundations, regional props, and boss/miniboss UI.

Production supports the approved **12-chamber Hushiro** prototype through reusable room foundations/variants rather than unique art per chamber.

The first attempt uses this same normal route rather than a bespoke tutorial environment. Hushiro must therefore support a pre-awakening state with base katana combat, default Beast-Bane Whistle, normal Technique rewards/room flow, and Shrine support without Aspect Embrace/Tier presentation.

Keeper's boss-specific persistent material needs one collectible/reward representation, but exact item naming can follow the broader item-art pass.

# Milestone 3 — The Strand

Produce the six recurring NPCs, Strand environment, physical interactibles, training spaces, first-return/revival presentation, and permanent-progression interfaces.

Permanent station scope is concrete enough for interface/content planning:

- **Bloodwell:** 10 Akio nodes + 8 Run Infrastructure nodes,
- **Forge Bench:** 19 Prosthetic upgrades + 10 Relics with two mastery ranks each,
- **Blood Mirror:** 3 nodes per Aspect / 9 total, unlocked after first Keeper.

The Bloodwell progression bands advance after first return, first Keeper, first Twin Maws, and first Shogun / first Binding clear. Exactly six Bloodwell nodes use regional boss-material gates.

Narrative production at the Strand uses six recurring NPCs with approximately **30–36 major conversations total**, approximately **4–6 short reactive line sets per NPC**, and one final pre-Heart state/conversation per NPC. Keeper and Scribe carry the largest story load.

The first Returning Blood reconstruction is one of the approved major controlled in-engine sequences and should reuse the Strand/Bloodwell environment rather than requiring a separate cinematic pipeline.

The Blood Cavern remains training/trial space. Merchant, Discovery Board, and Boat remain services rather than extra permanent upgrade trees.

# Milestone 4 — Player combat depth and run-build expression

Complete:

- Wolf / Wraith / Ronin combat-presentation packages,
- Tier / Blood states,
- eight Prosthetic families,
- Technique reward/build UI,
- Relic presentation and Base/Mastery I/Mastery II states,
- currencies, pickups, regional boss-material reward objects/icons,
- Blood Mirror presentation for the three staged reliability nodes per Aspect.

The current Technique roster is **50 actual Techniques + 10 refinements**. The current Relic roster is **10 items** with one equipped slot and two mastery ranks per Relic.

Beast-Bane Whistle is the default starting Prosthetic and therefore needs to be production-ready early enough to support the first attempt.

Technique screen composition/source weighting and the first reward/economy prototypes are approved enough for reusable UI planning; final balance values remain playtest work. A general consumable inventory/one-use item layer is not part of launch production scope.

# Milestone 5 — Complete Area 2

Produce Yomori Grove, regional enemies/minibosses, Twin Maws, regional hazards, functional rooms, VFX, and integration.

Production supports the approved **10-chamber Yomori** prototype. Stalker Hound is the explicitly authored evolved Area 2 continuation of the Blighted Hound lineage rather than the unchanged Hushiro enemy carrying forward. Twin Maws use the approved transition-recovery rules and drop one Twin-Maws-specific persistent material per victory.

The first attempt does not artificially block Yomori. A sufficiently skilled pre-awakening player may reach and complete the region through the same normal route.

# Milestone 6 — Area 3, campaign climax, and ending

Produce Kagutsuchi Court, its roster, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Heart chamber, extraction apparatus, reusable Binding ritual, six Binding states, fully exposed Heart, two-form true-final Heart, ending, and repeat-clear presentation.

Production supports the approved **11-chamber Kagutsuchi** prototype. Its five standard enemies are native Court units; no earlier-region standard enemy or evolved continuation is currently part of the launch Kagutsuchi roster. The Eclipse Shogun drops one Shogun-specific persistent material per victory.

Narrative scope for this milestone includes:

- **7 awakened Shogun confrontation dialogue states**,
- **1 rare pre-awakening Shogun fallback** for an exceptional first-attempt clear,
- the bloodline recognition/recruitment reveal at the third awakened Shogun confrontation,
- **6 escalating states of one reusable Binding ritual**,
- Binding 6 / zero-Binding final-run setup,
- approximately five total major controlled in-engine story sequences across the game, including the first-return and ending beats,
- the canonical Heart-death / curse-ending presentation.

The first six post-awakening clears use the reusable Binding ritual. The seventh story run continues from Shogun into the Heart with the approved partial recovery handoff.

If a mastery-level player reaches the Heart before Akio's first death, the pre-awakening Heart state must allow arrival but cannot break a Binding; Heart contact triggers the first death/Returning Blood awakening without advancing campaign Binding progress.

Akio remains silent through all Shogun/Heart/ending presentation. The Heart does not speak.

Exact Shogun and Heart attack production still requires encounter approval.

# Milestone 7 — Release presentation and cohesion

Complete front-end UI, approved narrative implementation, achievements/store art where required, missing-asset audit, cross-game readability, settings/credits, localization integration, and final production cleanup.

Narrative production boundary is now established:

- approximately **15,000–20,000 narrative words**,
- approximately **20–25 substantive Lore / Records entries** beyond normal gameplay codex text,
- text-led NPC/enemy/boss dialogue,
- **no Akio dialogue or dialogue-choice system**,
- **no full spoken-dialogue voice-acting requirement**,
- reuse gameplay environments/cameras/VFX rather than building a separate pre-rendered cinematic pipeline.

Final quotation no longer depends on narrative-delivery architecture. The remaining major scope dependency is the exact **endgame/postgame/release package**: repeat Heart access/rewards, completed-save behavior, achievements/completion goals, required front-end/settings/accessibility/credits scope, and whether any modifier/challenge system belongs at launch.

# Production rules

- Wolf, Wraith, Ronin are fixed launch Aspects.
- Akio is fully silent: no dialogue, response text, dialogue choices, or internal monologue.
- The first attempt is the normal full route, not a scripted prologue or forced early loss.
- Beast-Bane Whistle is the default starting Prosthetic.
- Technique rewards and ordinary route interactions remain active on the first attempt; Blood Aspect/Corruption/Tier/Blood/Blood-Art progression does not.
- Current 50-Technique and 10-Relic rosters remain stable unless testing exposes a concrete gap.
- Permanent progression launch scope is **10 Akio + 8 Infrastructure + 9 Blood Mirror + 20 Relic mastery milestones + 19 Prosthetic upgrades**.
- Exactly six Bloodwell nodes use regional boss-material gates; normal Prosthetic, Relic mastery, and Blood Mirror ranks do not use boss materials at launch.
- Blood Mirror unlocks after first Keeper; all permanent progression systems are structurally available after first Shogun / first Binding clear.
- No alternate-weapon / weapon-socket system or separate Relic Reliquary.
- No launch consumable inventory or one-use item reward family.
- Standard Combat rooms use deliberately authored encounter scripts selected from regional encounter pools; they are not procedurally assembled from threat budgets.
- Route opening/main/final bands do not require separate standard-encounter pools; individual encounters may receive minimum-chamber eligibility later where needed.
- Standard enemies are region-native by default; cross-region continuation requires a deliberately authored evolved regional variant rather than automatic reuse or stat scaling.
- The only approved launch standard-enemy lineage across regions is **Blighted Hounds → Stalker Hound** in Yomori.
- Reuse attack, locomotion, deathblow, HUD, VFX, environment, and camera families where mechanics/narrative modify existing content.
- Standard successful-run target remains **45–50 minutes**.
- Regional prototype baseline remains **12 Hushiro / 10 Yomori / 11 Kagutsuchi = 33 counted chambers**.
- Route branching, room/reward weights, Technique offer generation, Gold/Shop economy, survival/capacity values, boss rewards, Relic acquisition/swapping, persistent-resource payouts, permanent-progression content volume, first-attempt behavior, and narrative-delivery volume have approved prototype/paper-design models.
- Persistent economy uses **Mist, Scrolls, and three low-count regional boss materials**; no generic Boss Emblem currency.
- Full spoken-dialogue VO is not required for launch.
- Final tuned probabilities, prices, payouts, recovery values, upgrade percentages/costs, mastery thresholds, authored encounter counts/scripts, encounter timings, and exact narrative scripts remain playtest/implementation work.
- Additional Aspects, large modifier systems, enemy/room variant packages, and other deferred challenge scope are excluded unless explicitly promoted.
- Markdown remains internal source of truth; Word/PDF are exports.

# Current pre-production dependency

The remaining top-level design work is:

1. **Endgame/postgame/release scope** — repeat Heart access/rewards, completed-save behavior, completion goals/achievements, settings/front-end/credits/accessibility requirements, and any launch challenge/modifier layer.

The actual standard-encounter roster, encounter-pool sizes, enemy counts/waves, and full-run clear-time validation belong to the later encounter-authoring/playtest pass.

Use `docs/_meta/OPEN_QUESTIONS.md` for the current unresolved agenda; do not duplicate resolved prototype tables here.
