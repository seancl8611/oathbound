---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-10
topics:
  - progression
  - persistence
  - bloodwell
  - blood-mirror
  - forge
  - trials
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - CONTENT-STRAND-INTERACTIBLES
  - UI-RUN-RESULTS
---

# Progression

Oathbound uses connected run-only and persistent progression layers. Every system must explicitly state whether its state survives death and successful completion.

## Run progression

Temporary power assembled during an attempt may include:

- Blood Aspect Tier growth,
- Corruption,
- temporary boons,
- temporary relic effects,
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
- **Major currencies and rewards:** resources explicitly classified as permanent, including Boss Emblems and the finalized Mist/Scroll currency families.

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
- permanent currency,
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
- Permanent Aspect upgrades must stay small, capped, and reliability-focused.
- Unlocks should be documented separately from balance values.
- Every persistent interface must show costs, prerequisites, ownership, and purchased/maxed states clearly.
- Trial rewards should remain deterministic enough that players understand why they succeeded or failed.

## Current persistence matrix

| Category | Persists after death | Persists after completed run | Status |
|---|---:|---:|---|
| Narrative discoveries and codex progress | Yes | Yes | approved |
| Permanent upgrades | Yes | Yes | approved |
| Unlocked Blood Aspects | Yes | Yes | approved |
| Selected Aspect as loadout option | Yes | Yes | approved |
| Blood Mirror trial/mastery progress | Yes | Yes | approved |
| Permanent Aspect upgrade ranks | Yes | Yes | approved |
| Blood Aspect Tier | No | No | approved |
| Corruption | No | No | approved |
| Temporary boons | No | No | approved |
| Temporary relic effects | No | No | approved |
| Gold | No | No | approved |
| Room progress | No | No | approved |
| Boss Emblems and other major permanent currencies | Yes | Yes | approved direction |
| Individual consumables/materials | By item family | By item family | requires item documentation |

## Currency naming note

The source bible uses related terms including Mist, Mist Shards, Scrolls, and Boss Emblems. Their final names, families, and exact service ownership require a focused currency pass; the persistence rule is that currencies explicitly classified as major/permanent survive the run.
