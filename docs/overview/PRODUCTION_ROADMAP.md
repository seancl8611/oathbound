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

Permanent station ownership:

- **Bloodwell:** Akio + Run Infrastructure,
- **Forge Bench:** Prosthetics + Relics,
- **Blood Mirror:** Blood Aspects, initially locked.

The Blood Cavern remains training/trial space. Merchant, Discovery Board, and Boat remain services rather than extra permanent upgrade trees.

# Milestone 4 — Player combat depth and run-build expression

Complete:

- Wolf / Wraith / Ronin combat-presentation packages,
- Tier / Blood states,
- eight Prosthetic families,
- Technique reward/build UI,
- Relic presentation,
- currencies, pickups, regional boss-material reward objects/icons.

The current Technique roster is **50 actual Techniques + 10 refinements**. The current Relic roster is **10 items** with one equipped slot and no rarity tiers.

Technique screen composition/source weighting and the first reward/economy prototypes are approved enough for reusable UI planning; final balance values remain playtest work.

# Milestone 5 — Complete Area 2

Produce Yomori Grove, regional enemies/minibosses, Twin Maws, regional hazards, functional rooms, VFX, and integration.

Production supports the approved **10-chamber Yomori** prototype. Twin Maws use the approved transition-recovery rules and drop one Twin-Maws-specific persistent material per victory.

# Milestone 6 — Area 3 and endgame

Produce Kagutsuchi Court, its roster, Blood Lotus, Eternal Swordsman, Eclipse Shogun, Heart chamber, extraction apparatus, reusable Binding ritual, six Binding states, fully exposed Heart, two-form true-final Heart, ending, and repeat-clear presentation.

Production supports the approved **11-chamber Kagutsuchi** prototype. The Eclipse Shogun drops one Shogun-specific persistent material per victory.

The first six clears use the reusable Binding ritual. The seventh story run continues from Shogun into the Heart with the approved partial recovery handoff.

Exact Shogun attacks/phase production still require encounter approval.

# Milestone 7 — Release presentation and cohesion

Complete front-end UI, approved narrative delivery, achievements/store art where required, missing-asset audit, cross-game readability, settings/credits, and final production cleanup.

Final quotation depends on narrative-delivery scope, postgame access/rewards, and required release UI—not on reopening approved canon.

# Production rules

- Wolf, Wraith, Ronin are fixed launch Aspects.
- Current 50-Technique and 10-Relic rosters remain stable unless testing exposes a concrete gap.
- No alternate-weapon / weapon-socket system or separate Relic Reliquary.
- Reuse attack, locomotion, deathblow, HUD, and VFX families where mechanics modify existing actions.
- Standard successful-run target remains **45–50 minutes**.
- Regional prototype baseline remains **12 Hushiro / 10 Yomori / 11 Kagutsuchi = 33 counted chambers**.
- Route branching, room/reward weights, Technique offer generation, Gold/Shop economy, survival/capacity values, and persistent-resource payouts now have first approved prototype models.
- Persistent economy uses **Mist, Scrolls, and three low-count regional boss materials**; no generic Boss Emblem currency.
- Final tuned probabilities, prices, payouts, recovery values, upgrade costs, and encounter compositions remain playtest/implementation work.
- Additional Aspects, large modifier systems, enemy/room variant packages, and other deferred challenge scope are excluded unless explicitly promoted.
- Markdown remains internal source of truth; Word/PDF are exports.

# Current pre-production dependency

The active full-run design task is now:

1. **regional-boss current-run reward composition** for Keeper / Twin Maws,
2. **Relic acquisition allocation and limited transition-swap placement**,
3. consumables include/cut,
4. encounter composition / room-clear-time / full-run pacing validation.

After full-run integration, proceed to narrative delivery/campaign presentation, then endgame/postgame/release scope.

Use `docs/_meta/OPEN_QUESTIONS.md` for the current unresolved agenda; do not duplicate resolved prototype tables here.
