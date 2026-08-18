---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-17
topics:
  - open-questions
  - design-priority
  - permanent-progression
  - narrative-delivery
  - postgame
---

# Current Design Questions

This file contains only unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation.

Resolved rules and prototype values belong in their authoritative files and should **not** be copied here. Playtest tuning belongs in the owning gameplay/encounter file. Small cleanup decisions should not be promoted ahead of larger dependency-setting work.

# Approved baseline

The following major architecture is already established and should not be reopened unless testing exposes a concrete problem:

- three launch Blood Aspects: Wolf, Wraith, Ronin,
- five direct Technique slots plus slotless Supporting / Cross-family / Legendary Techniques,
- 50-Technique launch roster plus 10 refinements,
- 10-Relic launch roster with one equipped slot,
- Relic acquisition split of 4 guaranteed campaign/Strand, 2 Blood Cavern/challenge, and 4 run-discovered Relics,
- Relic swapping at the Forge before a run, after Keeper, after Twin Maws, or immediately on a new discovery,
- eight Prosthetics with shallow linear Forge progression,
- three permanent upgrade stations: Bloodwell, Forge Bench, later-unlocked Blood Mirror,
- no general launch consumable inventory or one-use item reward layer,
- three-region 33-chamber prototype route: 12 Hushiro / 10 Yomori / 11 Kagutsuchi,
- standard Combat rooms use deliberately authored encounter scripts selected from a regional encounter pool,
- no mandatory opening/main/pre-boss split for standard encounter pools,
- encounter-specific minimum-chamber eligibility may be added later only where a particular authored encounter needs it,
- standard enemies are region-native by default rather than carrying forward unchanged,
- cross-region continuation uses a deliberately authored evolved regional variant rather than a simple stat-upgraded copy,
- the only approved launch cross-region standard-enemy lineage is **Blighted Hounds → Stalker Hound** in Yomori; no other Hushiro continuation and no Kagutsuchi continuation is currently approved,
- first route-generation and room/reward weighting model,
- first Technique-offer / rarity-source model,
- first Gold/Shop economy,
- first survival/recovery/capacity model,
- first persistent-resource economy using Mist, Scrolls, and three regional boss materials,
- Keeper/Twin Maws three-card current-run Boss Reward prototype,
- six player-destroyed Heart Bindings followed by the seventh story run into the true-final Heart,
- approximately 45–50 minute normal successful Binding-run target.

Current values and exact rules live in:

- `docs/gameplay/RUN_STRUCTURE.md`
- `docs/gameplay/TECHNIQUES.md`
- `docs/gameplay/ITEMS_AND_REWARDS.md`
- `docs/gameplay/RELICS.md`
- `docs/gameplay/PROGRESSION.md`
- regional `docs/content/area_*/ENEMIES.md` authorities.

# Scope-closure sequence

1. **Close permanent-progression content scope**
2. **Define narrative delivery and campaign presentation**
3. **Define endgame, postgame, and release scope**

Detailed standard-encounter authoring and final clear-time validation remain later content/playtest work after broader launch scope is established.

# Encounter authoring and pacing — later content/playtest pass

When encounter production begins:

- author the actual regional standard-encounter pools,
- give each encounter a coherent tactical theme/enemy combination,
- add encounter-specific minimum-chamber restrictions only where needed,
- determine how many authored encounters are required for sufficient run variety,
- tune individual enemy counts/waves/spawn sequencing,
- measure standard-room, miniboss, boss, reward-choice, Shop, Rest, and transition times,
- validate the complete route against the **45–50 minute** successful-run target.

This is not the current top-level design question because the game does not yet need every individual combat room authored to close launch scope.

# 1. Permanent-progression content scope

The architecture and currencies are already decided. Close the remaining **content volume and progression-cadence** questions without reopening the station model.

Define as one connected progression package:

- the number and broad roles of Bloodwell **Akio** nodes,
- the number and broad roles of **Run Infrastructure** nodes,
- the number and broad roles of Blood Mirror nodes for each Aspect,
- the intended Relic mastery rank structure,
- which small set of major upgrades use Keeper / Twin Maws / Shogun materials,
- the campaign cadence for unlocking these systems and major node bands.

The output should be a coherent launch progression map showing what permanent goals the player works toward across repeated runs and when those goals become available. Exact percentages, final Mist prices, mastery kill thresholds, and other balance values remain tuning work after the content structure is fixed.

**Authority:** `docs/gameplay/PROGRESSION.md`, Bloodwell/Blood Mirror/Forge authorities.

# 2. Narrative delivery and campaign presentation

The story spine and lore are already approved. Define the authored delivery package required for launch:

- introductory attempt / first death,
- Returning Blood and bloodline reveal timing,
- Shogun dialogue progression across repeat encounters,
- NPC / Strand dialogue updates,
- Discovery Board / codex ownership,
- Binding-clear presentation and campaign-state communication,
- portrait, cinematic, and voice-acting scope,
- ending and credits presentation,
- final writing/localization inventory.

Detailed scripts and line counts follow only after this delivery package is scoped.

# 3. Endgame, postgame, and release scope

Define what remains available after the first canonical Heart victory and what is required for a complete initial release:

- repeat Heart-route access,
- repeat-clear rewards / records / mastery value,
- launch achievements or completion goals,
- completed-save communication,
- front-end / settings / credits requirements,
- whether any modifier/challenge/New-Game-style system is actually required for launch or should remain post-launch.

Do not add large difficulty-modifier, enemy-variant, room-variant, or extra-Aspect packages merely to create postgame volume unless playable testing demonstrates a clear need.

# Balance work kept out of this tracker

Do not add separate top-level questions for final:

- damage/posture values,
- Technique rarity or replacement percentages,
- room/reward weights,
- Shop prices,
- recovery/capacity percentages,
- Mist/Scroll payout tuning,
- final Scroll/Mist costs,
- boss-material quantities above the approved low-count model,
- exact Relic mastery thresholds,
- individual Prosthetic percentages,
- frame data, VFX timing, hitboxes, or animation timings.

Those remain in their owning files until testing shows a production-scope consequence.
