---
id: GAMEPLAY-RUN-STRUCTURE
title: Run Structure
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-13
topics:
  - runs
  - death
  - successful-return
  - ancient-source
  - strand
  - techniques
  - room-rewards
related:
  - LORE-RETURNING-BLOOD
  - LORE-STORY-OVERVIEW
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-BLOODWELL
  - UI-RUN-RESULTS
---

# Run Structure

A run begins after preparation and final confirmation at the Boat in the Strand. It ends through death, successful source-layer damage after the Shogun, or another explicitly designed return condition.

## Regional flow

The current intended progression is:

1. Hushiro Gate Village
2. Yomori Grove
3. Kagutsuchi Court
4. Eclipse Shogun
5. Temporary access to the protected ancient source

Exact branching, room counts, rerouting, and area-order flexibility remain implementation and playtest questions.

## Run start

Before departure, the player:

- completes available Strand preparation,
- confirms an unlocked Blood Aspect at the Boat after the system is unlocked,
- confirms the current prosthetic loadout when available,
- begins at Blood Aspect Tier 0,
- begins with four empty active Technique slots and one empty reserve slot,
- starts without the previous run's Corruption, Techniques, refinements, Gold, room progress, or temporary Relic effects.

## Room functions

The game uses recognizable room categories:

- Combat
- Shrine
- Rest
- Shop
- Treasure/reward
- Miniboss
- Boss approach and boss arena
- Source approach or completion chamber after the Shogun

Each function should read before interaction through environment composition, focal props, lighting, and UI treatment.

Combat routes may also display a previewed primary reward category before entry. Room function and reward category are related but separate: a standard combat encounter may pay out Gold, Mist, Scrolls, recovery, temporary run growth, or a Technique opportunity.

Detailed reward ownership and cadence belong in [Items, Currencies, and Rewards](ITEMS_AND_REWARDS.md).

## Run power curve

The intended build progression is:

- **Area 1:** acquire the first meaningful Techniques and begin defining the build.
- **Area 2:** fill the four active Technique slots, gain Aspect Tiers, and establish coherent synergy.
- **Area 3:** refine, replace, use reserve strategically, and finalize the build for the Shogun.

A successful run should create several meaningful Technique decisions without awarding a Technique after every combat room.

## Failed run

When Akio dies, Returning Blood reconstructs him at the Strand. Death is a real supernatural event, not a non-canon reset.

The failed run burns away its temporary blood-state and run-only progress. Permanent unlocks, upgrades, discoveries, Blood Mirror progress, and major currencies survive according to the progression matrix.

## Successful run

On a successful run, Akio:

1. defeats the Eclipse Shogun's current manifestation,
2. gains temporary access to the protected ancient source or its inner chamber,
3. damages or removes one persistent source layer,
4. is destroyed, sacrificed, or expelled by the source interaction,
5. reforms at the Strand through Returning Blood,
6. saves permanent rewards and persistent campaign damage,
7. clears temporary run-state,
8. receives a results summary,
9. triggers relevant NPC, codex, Blood Mirror, source-state, or hub updates.

Successful completion and death both return Akio to the Strand, but they must remain visually and narratively distinct. See [Run Results and Strand Return](../ui_ux/RUN_RESULTS.md) for presentation requirements.

The exact source-layer count, reason Akio cannot finish the source in one run, Shogun reconstruction rule, and true-final sequence remain open story-design questions.

## Run growth

A run may change through:

- Blood Aspect Tier choices,
- four active Techniques and one reserve Technique,
- Technique refinements and replacements,
- prosthetic tools, resources, and eligible Prosthetic Techniques,
- run-scoped Relics,
- consumables,
- temporary currencies and materials,
- survival and resource-cap rewards,
- boss, miniboss, treasure, shop, or discovery rewards.

## Reset boundary

The following reset after death or successful source-layer return:

- current Corruption,
- Blood Aspect Tier,
- active Techniques,
- reserve Technique,
- Technique refinements,
- Gold,
- room progress,
- temporary Relic effects,
- other explicitly run-only states.

The following persist:

- unlocked Blood Aspects,
- chosen Aspect as an available loadout selection,
- unlocked Techniques in future reward pools,
- permanent upgrades,
- Blood Mirror trial and mastery progress,
- narrative discoveries,
- codex progression,
- major permanent currencies and rewards,
- completed source-layer or equivalent campaign progress.

See [Progression](PROGRESSION.md) for system ownership and the current persistence matrix.