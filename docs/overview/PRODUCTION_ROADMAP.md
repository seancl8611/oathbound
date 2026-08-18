---
id: OVERVIEW-PRODUCTION-ROADMAP
title: Production Roadmap
category: overview
status: approved
authority: primary
last_reviewed: 2026-08-17
---

# Production Roadmap

Oathbound production is organized by dependency order and meaningful playtest groups. Milestones summarize required production; gameplay/content authorities own the underlying design.

# Pre-milestone gate — Paid Style Test

Lock practical sprite scale, palette, detail density, high-angle perspective, outline treatment, ground shadow, Hushiro tone, and Godot import quality before Milestone 1.

# Milestone 1 — Combat vertical slice

Establish Akio, core combat readability, three representative Area 1 enemies, five shared combat VFX, Combat HUD, and the base Hushiro environment kit.

# Milestone 2 — Complete Area 1

Complete the Hushiro roster, both minibosses, Keeper of the Gate, functional-room skins, Shrine/Corruption foundations, regional props, and boss/miniboss UI.

Production supports the approved **12-chamber Hushiro** prototype through reusable room foundations/variants rather than unique art per chamber.

Keeper's boss-specific persistent material needs one collectible/reward representation, but exact item naming can follow the broader item-art pass.

# Milestone 3 — The Strand

Produce the six recurring NPCs, Strand environment, physical interactibles, training spaces, revival presentation, and permanent-progression interfaces.

Permanent station scope is now concrete enough for interface/content planning:

- **Bloodwell:** 10 Akio nodes + 8 Run Infrastructure nodes,
- **Forge Bench:** 19 Prosthetic upgrades + 10 Relics with two mastery ranks each,
- **Blood Mirror:** 3 nodes per Aspect / 9 total, unlocked after first Keeper.

The Bloodwell progression bands advance after first return, first Keeper, first Twin Maws, and first Shogun / first Binding clear. Exactly six Bloodwell nodes use regional boss-material gates.

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

Technique screen composition/source weighting and the first reward/economy prototypes are approved enough for reusable UI planning; final balance values remain playtest work. A general consumable inventory/one-use item layer is not part of launch production scope.

# Milestone 5 — Complete Area 2

Produce Yomori Grove, regional enemies/minibosses, Twin Maws, regional hazards, functional rooms, VFX, and integration.

Production supports the approved **10-chamber Yomori** prototype. Stalker Hound is the explicitly authored evolved Area 2 continuation of the Blighted Hound lineage rather than the unchanged Hushiro enemy carrying forward. Twin Maws use the approved transition-recovery rules and drop one Twin-Maws-specific persistent material per victory.

# Milestone 6 — Area 3 and endgame

Produce Kagutsuchi Court, its roster, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Heart chamber, extraction apparatus, reusable Binding ritual, six Binding states, fully exposed Heart, two-form true-final Heart, ending, and repeat-clear presentation.

Production supports the approved **11-chamber Kagutsuchi** prototype. Its five standard enemies are native Court units; no earlier-region standard enemy or evolved continuation is currently part of the launch Kagutsuchi roster. The Eclipse Shogun drops one Shogun-specific persistent material per victory.

The first six clears use the reusable Binding ritual. The seventh story run continues from Shogun into the Heart with the approved partial recovery handoff.

Exact Shogun attacks/phase production still require encounter approval.

# Milestone 7 — Release presentation and cohesion

Complete front-end UI, approved narrative delivery, achievements/store art where required, missing-asset audit, cross-game readability, settings/credits, and final production cleanup.

Final quotation depends primarily on narrative-delivery scope, postgame access/rewards, and required release UI—not on reopening approved gameplay/progression architecture.

# Production rules

- Wolf, Wraith, Ronin are fixed launch Aspects.
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
- Reuse attack, locomotion, deathblow, HUD, and VFX families where mechanics modify existing actions.
- Standard successful-run target remains **45–50 minutes**.
- Regional prototype baseline remains **12 Hushiro / 10 Yomori / 11 Kagutsuchi = 33 counted chambers**.
- Route branching, room/reward weights, Technique offer generation, Gold/Shop economy, survival/capacity values, boss rewards, Relic acquisition/swapping, persistent-resource payouts, and permanent-progression content volume have approved prototype/paper-design models.
- Persistent economy uses **Mist, Scrolls, and three low-count regional boss materials**; no generic Boss Emblem currency.
- Final tuned probabilities, prices, payouts, recovery values, upgrade percentages/costs, mastery thresholds, authored encounter counts/scripts, and encounter timings remain playtest/implementation work.
- Additional Aspects, large modifier systems, enemy/room variant packages, and other deferred challenge scope are excluded unless explicitly promoted.
- Markdown remains internal source of truth; Word/PDF are exports.

# Current pre-production dependency

The remaining design work should close scope in dependency order:

1. **Narrative delivery/campaign presentation** — define the authored introductory-death, Returning Blood reveal, repeat-Shogun/Binding, Strand NPC/codex, Heart unlock, ending, credits, portrait/cinematic/voice, and writing/localization production package.
2. **Endgame/postgame/release scope** — repeat Heart access/rewards, completion goals, settings/front-end/credits, and any launch challenge layer.

The actual standard-encounter roster, encounter-pool sizes, enemy counts/waves, and full-run clear-time validation belong to the later encounter-authoring/playtest pass.

Use `docs/_meta/OPEN_QUESTIONS.md` for the current unresolved agenda; do not duplicate resolved prototype tables here.
