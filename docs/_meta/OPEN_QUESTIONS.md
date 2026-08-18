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
- Relic progression uses **Base → Mastery I → Mastery II / Complete**, two mastery milestones per Relic,
- eight Prosthetics with 19 shallow linear Forge upgrades,
- three permanent upgrade stations: Bloodwell, Forge Bench, later-unlocked Blood Mirror,
- Bloodwell launch scope of **10 Akio nodes + 8 Run Infrastructure nodes**,
- Blood Mirror launch scope of **3 nodes per Aspect / 9 total**,
- exactly **6 regional-boss-material-gated Bloodwell nodes**, one Akio mastery node and one Infrastructure passage node per regional boss,
- permanent progression unlock cadence of first return → first Keeper → first Twin Maws → first Shogun / first Binding clear,
- all foundational permanent progression systems structurally available after the first Binding clear,
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

1. **Define narrative delivery and campaign presentation**
2. **Define endgame, postgame, and release scope**

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

# 1. Narrative delivery and campaign presentation

The story spine and lore are already approved. The next question is to define the **complete authored narrative-delivery package required for launch** without writing every line of dialogue yet.

Define as one connected campaign-presentation plan:

- how the introductory attempt begins and where the first death occurs,
- what the player sees/understands during the first Returning Blood reconstruction,
- when Akio's bloodline and Returning Blood truth are revealed,
- how much Shogun dialogue/progression changes across repeat encounters and Binding clears,
- how the six Strand NPCs update across failures, regional milestones, and Binding clears,
- what the Discovery Board/codex owns versus what must be communicated directly in play,
- how each Binding clear communicates permanent campaign progress without requiring six unique missions,
- what presentation is required for the seventh-run Heart unlock, true-final Heart, ending, and credits,
- what uses portraits, in-engine scenes, still illustrations, text boxes, voice acting, or no cinematic treatment,
- the broad writing/localization inventory needed for launch.

The goal is to establish **scene/dialogue/state counts and presentation tiers** so narrative production volume can be estimated. Detailed scripts, exact line counts, final prose, shot timing, and voice casting follow only after this package is scoped.

**Authority:** `docs/lore/STORY_OVERVIEW.md`, character/NPC authorities, `docs/gameplay/RUN_STRUCTURE.md`, Strand/Heart content authorities, and relevant UI files.

# 2. Endgame, postgame, and release scope

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
- exact boss-material quantities within the approved low-count model,
- exact Relic mastery kill thresholds,
- exact Bloodwell/Blood Mirror percentages,
- individual Prosthetic percentages,
- frame data, VFX timing, hitboxes, or animation timings.

Those remain in their owning files until testing shows a production-scope consequence.
