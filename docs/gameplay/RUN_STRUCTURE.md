---
id: GAMEPLAY-RUN-STRUCTURE
title: Run Structure
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - runs
  - death
  - successful-return
  - wellspring
  - strand
related:
  - LORE-RETURNING-BLOOD
  - GAMEPLAY-PROGRESSION
  - GAMEPLAY-BLOOD-ASPECTS
  - CONTENT-STRAND-BLOODWELL
  - UI-RUN-RESULTS
---

# Run Structure

A run begins after preparation and final confirmation at the Boat in the Strand. It ends through death, successful Wellspring completion, or another explicitly designed return condition.

## Regional flow

The current intended progression is:

1. Hushiro Gate Village
2. Yomori Grove
3. Kagutsuchi Court
4. Eclipse Shogun and Wellspring completion

Exact branching, room counts, rerouting, and area-order flexibility remain implementation and playtest questions.

## Run start

Before departure, the player:

- completes available Strand preparation,
- confirms an unlocked Blood Aspect at the Boat after the system is unlocked,
- begins at Blood Aspect Tier 0,
- starts without the previous run's Corruption, temporary boons, Gold, room progress, or temporary relic effects.

## Room functions

The game uses recognizable room categories:

- Combat
- Shrine
- Rest
- Shop
- Treasure/reward
- Miniboss
- Boss approach and boss arena

Each function should read before interaction through environment composition, focal props, lighting, and UI treatment.

## Failed run

When Akio dies, Returning Blood reconstructs him at the Strand through the Bloodwell anchor. Death is a real supernatural event, not a non-canon reset.

The failed run burns away its temporary blood-state and run-only progress. Permanent unlocks, upgrades, discoveries, Blood Mirror progress, and major currencies survive according to the progression matrix.

## Successful run

On a successful run, Akio:

1. defeats the Eclipse Shogun's current manifestation,
2. completes the Rite at the Wellspring,
3. severs one layer of the Shogun's blood-oath,
4. sacrifices or loses the current body during the Wellspring process,
5. reforms near the Bloodwell at the Strand,
6. saves permanent rewards and clears temporary run-state,
7. receives a results summary,
8. triggers relevant NPC, codex, Blood Mirror, or hub-state updates.

Successful completion and death both return Akio to the Strand, but they must remain visually and narratively distinct. See [Run Results and Strand Return](../ui_ux/RUN_RESULTS.md) for presentation requirements.

## Run growth

A run may change through:

- Blood Aspect Tier choices,
- stances,
- prosthetic tools and resources,
- boons and relics,
- consumables,
- temporary currencies and materials,
- boss or discovery rewards.

## Reset boundary

The following reset after death or successful Wellspring return:

- current Corruption,
- Blood Aspect Tier,
- temporary boons,
- Gold,
- room progress,
- temporary relic effects,
- other explicitly run-only states.

The following persist:

- unlocked Blood Aspects,
- chosen Aspect as an available loadout selection,
- permanent upgrades,
- Blood Mirror trial and mastery progress,
- narrative discoveries,
- codex progression,
- major permanent currencies and rewards.

See [Progression](PROGRESSION.md) for system ownership and the current persistence matrix.
