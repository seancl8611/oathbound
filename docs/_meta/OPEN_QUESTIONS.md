---
id: META-OPEN-QUESTIONS
title: Current Design Questions
category: meta
status: approved
authority: primary
last_reviewed: 2026-08-18
topics:
  - open-questions
  - design-priority
  - postgame
  - release-scope
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
- **Beast-Bane Whistle** as the default starting Prosthetic,
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
- approximately 45–50 minute normal successful Binding-run target,
- **Akio is a silent protagonist with zero dialogue, dialogue choices, or internal monologue**,
- the first attempt is a full normal route rather than a scripted prologue; it uses the base katana, Beast-Bane Whistle, normal Technique rewards and room flow, but no Blood Aspect/Corruption/Blood Art progression,
- the first death may occur anywhere; a mastery-level first-attempt player may reach the Heart, but cannot break a Binding before Returning Blood awakens,
- narrative campaign cadence uses seven awakened Shogun confrontation states plus one rare pre-awakening fallback,
- the six Binding clears use six visual states of one reusable ritual rather than six unique missions,
- working narrative production scope is approximately five major in-engine sequences, 30–36 major Strand conversations, 4–6 reactive line sets per Strand NPC, 20–25 substantive Lore/Records entries, and 15,000–20,000 narrative words,
- launch narrative is text-led with no full spoken-dialogue VO requirement.

Current values and exact rules live in:

- `docs/gameplay/FIRST_ATTEMPT.md`
- `docs/gameplay/RUN_STRUCTURE.md`
- `docs/gameplay/TECHNIQUES.md`
- `docs/gameplay/ITEMS_AND_REWARDS.md`
- `docs/gameplay/RELICS.md`
- `docs/gameplay/PROGRESSION.md`
- `docs/narrative/NARRATIVE_DELIVERY.md`
- regional `docs/content/area_*/ENEMIES.md` authorities.

# Scope-closure sequence

1. **Define endgame, postgame, and release scope**

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

# 1. Endgame, postgame, and release scope

Define what remains available after the first canonical Heart victory and what is required for a complete initial release.

Answer as one connected final scope package:

- how completed saves continue after Akio canonically becomes mortal,
- how the player chooses a normal Shogun-ending run versus a repeat Heart-route run in postgame,
- what repeat Heart clears award or record without creating new canon,
- what permanent progression, Relic mastery, trials, records, and collection goals remain meaningful after story completion,
- the launch achievement/completion-goal package,
- completed-save / story-complete communication,
- front-end requirements,
- settings/accessibility requirements,
- credits/legal/localization requirements,
- whether any run-modifier, challenge-heat, New Game+, or other difficulty-layer system is actually required for launch,
- and which tempting postgame features are explicitly deferred so release scope remains controlled.

The output should define a **complete shippable launch/endgame package** without adding large modifier systems, enemy-variant packages, room-variant packages, extra Aspects, or another campaign merely to manufacture postgame volume.

**Authority:** `docs/lore/STORY_OVERVIEW.md`, `docs/content/area_3/TRUE_FINAL_HEART.md`, progression/run/results authorities, and release UI/production documents.

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
- exact narrative scripts/line counts,
- frame data, VFX timing, hitboxes, or animation timings.

Those remain in their owning files until testing shows a production-scope consequence.
