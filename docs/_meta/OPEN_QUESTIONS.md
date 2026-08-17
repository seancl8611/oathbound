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
  - full-run-integration
  - narrative-delivery
  - postgame
---

# Current Design Questions

This file contains only unresolved decisions that materially affect launch scope, content volume, production planning, interfaces, or authored presentation.

Resolved rules and prototype values belong in their authoritative files and should **not** be copied here. Playtest tuning belongs in the owning gameplay/encounter file.

# Approved baseline

The following major architecture is already established and should not be reopened unless testing exposes a concrete problem:

- three launch Blood Aspects: Wolf, Wraith, Ronin,
- five direct Technique slots plus slotless Supporting / Cross-family / Legendary Techniques,
- 50-Technique launch roster plus 10 refinements,
- 10-Relic launch roster with one equipped slot,
- eight Prosthetics with shallow linear Forge progression,
- three permanent upgrade stations: Bloodwell, Forge Bench, later-unlocked Blood Mirror,
- three-region 33-chamber prototype route: 12 Hushiro / 10 Yomori / 11 Kagutsuchi,
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
- `docs/gameplay/PROGRESSION.md`

# Priority order

1. **Complete full-run integration, rewards, encounters, and pacing**
2. **Define narrative delivery and campaign presentation**
3. **Define endgame, postgame, and release scope**

# 1. Full-run integration, rewards, encounters, and pacing

## Relic acquisition and in-run swap placement

The 10-Relic roster and one-slot mastery model are approved. Keeper and Twin Maws Boss Reward Flex cards may now surface eligible Relic opportunities, and the Shop Flex slot may also do so.

Still decide:

- launch acquisition allocation across boss rewards, Treasure, trials, discoveries, NPC progression, or other approved sources,
- whether all 10 must be obtainable before story completion,
- the limited in-run moments where an equipped Relic may be replaced/swapped,
- how newly discovered Relics interact with the currently equipped Relic.

Do not create another Relic rarity/currency system to solve acquisition.

**Authority:** `docs/gameplay/RELICS.md`, `docs/gameplay/ITEMS_AND_REWARDS.md`.

## Consumables include/cut

Consumables currently have **0% ordinary primary-room reward weight** and are not required by the run architecture.

Decide whether launch includes a small contained consumable layer through Shops/Treasure or cuts consumables entirely.

Promote this only if the layer provides a distinct tactical purpose that Techniques, Relics, recovery, and Gold do not already cover.

**Authority:** `docs/gameplay/ITEMS_AND_REWARDS.md`.

## Encounter composition and pacing validation

With the 33-chamber structure established, prototype:

- regional enemy-composition rules by chamber band,
- elite / high-pressure encounter frequency,
- expected standard-room clear time,
- miniboss and boss time budgets,
- total decision/service-room overhead,
- three-region run simulation against the 45–50-minute target.

These are implementation/playtest variables unless testing reveals a new content or production-scope requirement.

**Authority:** regional encounter files + `docs/gameplay/RUN_STRUCTURE.md`.

## Permanent progression detail — later nested pass

When the Bloodwell and Blood Mirror trees are authored, assign exact Mist costs and the small number of major upgrades that require regional boss materials.

Keep the approved resource boundaries:

- Mist = broad progression,
- Scrolls = primarily Prosthetic Forge progression,
- regional boss materials = low-count secondary mastery gates on selected major upgrades,
- no generic Boss Emblem currency.

This is **not** the next top-level question unless full-run integration requires those exact nodes for testing.

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
- Scroll/Mist costs,
- boss-material quantities above the approved low-count model,
- Relic mastery thresholds,
- individual Prosthetic percentages,
- exact Bloodwell/Blood Mirror node values,
- frame data, VFX timing, hitboxes, or animation timings.

Those remain in their owning files until testing shows a production-scope consequence.
