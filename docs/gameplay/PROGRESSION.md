---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-11
topics:
  - progression
  - persistence
  - bloodwell
  - blood-mirror
  - forge
  - trials
  - currencies
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-INTERACTIBLES
  - UI-RUN-RESULTS
---

# Progression

Oathbound uses connected run-only and persistent progression layers. Every system and item family must explicitly state whether its state survives failed death-return and successful completion.

## Run progression

Temporary power assembled during an attempt may include:

- Blood Aspect Tier growth,
- Corruption,
- temporary boons,
- run-scoped relic effects,
- Gold,
- room progress,
- temporary consumables or materials,
- run-specific modifications and encounter rewards.

These states are burned away on failed death-return or successful Wellspring return unless a later system explicitly reclassifies them.

## Persistent progression

The Strand supports growth that survives return:

- **Bloodwell:** broad permanent meta progression through Way of Steel, Way of Secrets, and Way of Vows.
- **Forge Bench:** weapon, prosthetic, socket, and long-term combat-option development.
- **Blood Mirror:** Aspect unlocks, trial completion, mastery progress, and small capped permanent Aspect upgrades.
- **Blood Cavern trials:** combat teaching, repeatable mastery challenges, fixed-loadout tests, cosmetics, lore reflections, or completion marks.
- **Discovery Board:** codex knowledge, enemy information, relic/item notes, and recovered history.
- **Merchant and NPC services:** persistent unlocks, stock access, or service progression where defined.
- **Persistent currencies:** Mist, Scrolls, and Boss Emblems.

## Currency ownership

| Currency | Persistence | Primary ownership |
|---|---|---|
| Mist | Persistent | Base meta-progression currency; broadly usable by Bloodwell and approved hub systems |
| Scroll | Persistent | Forge-focused weapon and prosthetic upgrade currency |
| Boss Emblem | Persistent | Rare boss-derived currency for major progression gates or high-value nodes |
| Gold | Run-only | Mid-run shop economy |

`Mist Shards` is deprecated draft terminology unless a separate shard denomination is intentionally reintroduced. UI and contractor briefs should use `Mist` for the current base persistent currency.

## Blood Aspect persistence

- Unlocked Aspects persist.
- The player's selected Aspect remains available as a loadout choice.
- Blood Aspect Tier starts at Tier 0 each run and resets after death or successful completion.
- Corruption resets after the run.
- Blood Mirror trial completion and small permanent upgrades persist.
- Permanent Aspect upgrades cannot replace the run-changing Embrace Tier system.

## Trial reward boundary

Blood Cavern and Blood Mirror rewards may improve reliability, grant unlocks, or record mastery. They must not create permanent versions of the major mechanics intended to arrive through in-run Aspect Tiers.

Appropriate persistent rewards include:

- Aspect access,
- capped timing or recovery comfort,
- modest posture reliability,
- persistent currency,
- cosmetics,
- lore reflections,
- challenge completion marks.

## Return processing

Both failed and successful runs reconstruct Akio at the Strand through Returning Blood and the Bloodwell. A successful return additionally:

1. saves permanent boss, Wellspring, currency, discovery, and unlock rewards,
2. clears run-only state,
3. presents a results summary,
4. triggers relevant NPC, codex, Blood Mirror, or hub-state updates.

The results flow must distinguish retained rewards from states burned away during reformation.

## Design rules

- Persistent growth may improve options, reliability, and resilience, but must not erase the need to read combat.
- Run growth should create meaningful build identity before the final area.
- Permanent Aspect upgrades stay small, capped, and reliability-focused.
- Unlocks are documented separately from balance values.
- Every persistent interface shows costs, prerequisites, ownership, and purchased/maxed states clearly.
- Trial rewards remain deterministic enough that players understand success and failure.
- Gold cannot appear as a persistent Strand wallet unless its persistence rule is deliberately changed in the same update.

## Current persistence matrix

| Category | Persists after death | Persists after completed run | Status |
|---|---:|---:|---|
| Narrative discoveries and codex progress | Yes | Yes | approved |
| Permanent upgrades | Yes | Yes | approved |
| Unlocked Blood Aspects | Yes | Yes | approved |
| Selected Aspect as loadout option | Yes | Yes | approved |
| Blood Mirror trial/mastery progress | Yes | Yes | approved |
| Permanent Aspect upgrade ranks | Yes | Yes | approved |
| Mist, Scrolls, Boss Emblems | Yes | Yes | approved |
| Blood Aspect Tier | No | No | approved |
| Corruption | No | No | approved |
| Temporary boons | No | No | approved |
| Run-scoped relic effects | No | No | approved |
| Gold | No | No | approved |
| Room progress | No | No | approved |
| Individual consumables/materials | By item family | By item family | requires item-specific definition |
