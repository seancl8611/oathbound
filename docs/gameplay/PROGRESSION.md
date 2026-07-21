---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-20
topics:
  - progression
  - persistence
  - bloodwell
  - blood-mirror
  - forge
  - trials
  - currencies
  - techniques
  - heart-bindings
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-INTERACTIBLES
  - UI-RUN-RESULTS
---

# Progression

Oathbound uses connected run-only, persistent character, and persistent campaign progression layers. Every system and item family must explicitly state whether its state survives failed death-return and successful completion.

## Run progression

Temporary power assembled during an attempt may include:

- Blood Aspect Tier growth,
- Corruption,
- four active Techniques,
- one reserve Technique,
- Technique refinements and replacements,
- run-scoped Relic effects,
- temporary prosthetic specialization,
- Gold,
- room progress,
- temporary Health, Spirit, or capacity improvements,
- temporary consumables or materials,
- run-specific modifications and encounter rewards.

These states are burned away on failed death-return or successful Heart Binding return unless a later system explicitly reclassifies them.

## Run-build ownership

- **Blood Aspect:** central tactical identity and vertical Tier escalation.
- **Technique system:** limited horizontal build construction through four active slots, one reserve, and shallow refinements.
- **Prosthetic:** equipped tactical tool with permanent Forge development and temporary eligible Prosthetic Techniques.
- **Relic:** separate rare passive rule using its own run-scoped slot.

Permanent progression may unlock additional Techniques into future reward pools, but it does not preserve an assembled Technique loadout between runs.

## Persistent character progression

The Strand supports growth that survives return:

- **Bloodwell:** broad permanent meta progression through Way of Steel, Way of Secrets, and Way of Vows.
- **Forge Bench:** weapon, prosthetic, socket, and long-term combat-option development.
- **Blood Mirror:** Aspect unlocks, trial completion, mastery progress, and small capped permanent Aspect upgrades.
- **Blood Cavern trials:** combat teaching, repeatable mastery challenges, fixed-loadout tests, cosmetics, lore reflections, or completion marks.
- **Discovery Board:** codex knowledge, enemy information, Technique/prosthetic/Relic notes, and recovered history.
- **Merchant and NPC services:** persistent unlocks, stock access, or service progression where defined.
- **Persistent currencies:** Mist, Scrolls, and Boss Emblems.

## Persistent campaign progression

Successful runs preserve destroyed Heart Bindings.

Each successful clear:

- destroys one ancient Binding through the Returning Blood ritual,
- survives all later deaths and successful returns,
- visibly exposes more of the Heart,
- unlocks appropriate NPC, codex, environment, encounter, or world-state changes,
- moves the campaign toward the Shogun's permanent defeat and the true-final Heart confrontation,
- and remains separate from ordinary currencies and character-upgrade ranks.

The total Binding count and exact changes after each completion remain open, but the identity and persistence model are locked.

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

## Technique persistence

- Four active Technique slots and one reserve slot begin empty each run.
- Active and reserve Techniques reset after death or successful completion.
- Technique refinements reset with their base Techniques.
- Techniques discarded or overwritten during a run are not restored at return.
- Permanent systems may unlock a Technique into future reward pools or improve general access, but do not pre-equip run Techniques.
- The initial scope does not include permanent increases to active or reserve Technique capacity.

## Prosthetic progression boundary

The Forge owns permanent prosthetic unlocks, baseline improvements, and long-term branches. The run owns temporary Prosthetic Techniques and refinements for the currently equipped tool.

Permanent upgrades must not make temporary Prosthetic Techniques irrelevant or turn direct-damage tools into replacements for sword combat.

## Trial reward boundary

Blood Cavern and Blood Mirror rewards may improve reliability, grant unlocks, or record mastery. They must not create permanent versions of the major mechanics intended to arrive through in-run Aspect Tiers or Technique acquisition.

Appropriate persistent rewards include:

- Aspect access,
- Technique-pool unlocks where explicitly designed,
- capped timing or recovery comfort,
- modest posture reliability,
- persistent currency,
- cosmetics,
- lore reflections,
- challenge completion marks.

## Return processing

Both failed and successful runs reconstruct Akio at the Strand through Returning Blood. A successful return additionally:

1. saves permanent boss, destroyed-Binding, currency, discovery, and unlock rewards,
2. clears run-only state,
3. presents a results summary,
4. triggers relevant NPC, codex, Blood Mirror, Heart-state, or hub updates.

The results flow must distinguish retained rewards and campaign progress from states burned away during reformation.

## Design rules

- Persistent growth may improve options, reliability, and resilience, but must not erase the need to read combat.
- Run growth should create meaningful build identity before the final area.
- The selected Blood Aspect remains more identity-defining than any single Technique.
- Techniques are independently useful and do not depend on exact multi-Technique combinations.
- Permanent Aspect upgrades stay small, capped, and reliability-focused.
- Unlocks are documented separately from balance values.
- Every persistent interface shows costs, prerequisites, ownership, and purchased/maxed states clearly.
- Trial rewards remain deterministic enough that players understand success and failure.
- Gold cannot appear as a persistent Strand wallet unless its persistence rule is deliberately changed in the same update.
- Destroyed Heart Binding progress is not purchasable and cannot be lost.

## Current persistence matrix

| Category | Persists after death | Persists after completed run | Status |
|---|---:|---:|---|
| Narrative discoveries and codex progress | Yes | Yes | approved |
| Destroyed Heart Binding campaign progress | Yes | Yes | approved; exact count and clear-specific changes open |
| Permanent upgrades | Yes | Yes | approved |
| Unlocked Blood Aspects | Yes | Yes | approved |
| Selected Aspect as loadout option | Yes | Yes | approved |
| Blood Mirror trial/mastery progress | Yes | Yes | approved |
| Permanent Aspect upgrade ranks | Yes | Yes | approved |
| Unlocked Techniques in future reward pools | Yes | Yes | approved |
| Mist, Scrolls, Boss Emblems | Yes | Yes | approved |
| Blood Aspect Tier | No | No | approved |
| Corruption | No | No | approved |
| Active Techniques | No | No | approved |
| Reserve Technique | No | No | approved |
| Technique refinements | No | No | approved |
| Run-scoped Relic effects | No | No | approved |
| Gold | No | No | approved |
| Room progress | No | No | approved |
| Individual consumables/materials | By item family | By item family | requires item-specific definition |
