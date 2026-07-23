---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-22
topics:
  - progression
  - persistence
  - bloodwell
  - blood-mirror
  - forge
  - trials
  - currencies
  - heart-bindings
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-ITEMS-REWARDS
  - META-OPEN-QUESTIONS
---

# Progression

Oathbound uses three connected progression layers:

1. run-only build progression,
2. persistent character progression,
3. persistent campaign progression.

Every system and item family must state whether it survives death and successful completion.

## Run-only progression

Temporary run state may include:

- Blood Aspect Tier,
- Corruption,
- four active Techniques,
- one reserve Technique,
- Technique refinements,
- temporary Prosthetic Techniques,
- run-scoped Relic effects,
- Gold,
- room progress,
- temporary Health or Spirit capacity,
- approved consumables,
- temporary encounter rewards.

These states reset after failed death-return or successful Heart Binding completion unless an item explicitly defines a different rule.

## Persistent character progression

The Strand supports permanent growth through:

- **Bloodwell:** broad meta progression,
- **Forge Bench:** weapon and prosthetic development,
- **Blood Mirror:** Blood Aspect unlocks, mastery, and small capped reliability upgrades,
- **Blood Cavern:** teaching, fixed-loadout trials, mastery challenges, and approved unlocks,
- **Discovery Board:** codex and recovered history,
- **Merchant and NPC services:** approved stock or service progression,
- **Mist, Scrolls, and Boss Emblems:** persistent currencies.

Permanent progression may improve options, reliability, and resilience. It must not remove the need to read combat or replace run-build decisions.

The services and ownership boundaries are approved. The remaining production decision is their minimum launch package: approximate nodes or ranks, onboarding and trial counts, unlock mapping, mastery content, and required interface states.

## Persistent campaign progression

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding before the game, leaving six intact.

Each successful Binding run:

- destroys one remaining Binding,
- permanently preserves that progress,
- exposes more of the Heart,
- updates campaign presentation,
- and moves the story toward the final Heart route.

Failed runs do not advance the count.

After the sixth Binding is destroyed, the next successful full run becomes the seventh and final story run. It continues from the Shogun into the Heart without another Binding ritual.

Destroyed Binding progress is not a currency, cannot be purchased, and cannot be lost.

## Currency ownership

| Currency | Persistence | Primary owner |
|---|---|---|
| Mist | Persistent | Broad meta progression |
| Scroll | Persistent | Forge upgrades |
| Boss Emblem | Persistent | Rare major gates or high-value nodes |
| Gold | Run-only | Shops and run economy |

Currency ownership is resolved and should not be reintroduced as an open scope question. Exact costs remain balance work.

`Mist Shards` is deprecated unless intentionally restored as a separate denomination.

## Blood Aspect persistence

- Unlocked Aspects persist.
- The selected Aspect remains available as a loadout choice.
- Every run begins at Tier 0.
- Corruption resets after the run.
- Blood Mirror mastery and small permanent upgrades persist.
- Permanent Aspect upgrades cannot replace the in-run Embrace Tier system.

## Technique persistence

- Four active slots and one reserve begin empty each run.
- Active Techniques, reserve, and refinements reset after the run.
- Discarded or overwritten Techniques are not restored during the same run.
- Permanent progression may unlock Techniques into future reward pools.
- Permanent progression does not pre-equip a run Technique or increase slot capacity in the initial scope.

The exact unlock mapping depends on the approved launch run-build catalog and the persistent progression, onboarding, and trial package.

## Prosthetic progression

- The Forge owns permanent prosthetic unlocks, baseline improvements, and long-term branches.
- The run owns temporary Prosthetic Techniques and refinements for the equipped tool.
- Permanent upgrades must not make temporary specializations irrelevant or replace sword combat.

## Trial reward boundary

Blood Cavern and Blood Mirror rewards may grant:

- Blood Aspect access,
- Technique-pool unlocks,
- small timing or recovery reliability improvements,
- modest posture reliability,
- persistent currency,
- cosmetics,
- lore reflections,
- mastery marks.

Trials may not:

- add new Blood Aspect Tiers,
- remove Embrace danger,
- permanently pre-equip a Technique,
- create permanent versions of major run-only mechanics.

The final number of basic-combat trials, Aspect trials, Technique demonstrations, mastery trials, and their unlock ownership remains part of the current progression package decision.

## Return processing

Both failed and successful runs reconstruct Akio at the Strand through Returning Blood.

A successful Binding return additionally:

1. saves destroyed-Binding progress and permanent rewards,
2. clears run-only state,
3. presents a results summary,
4. triggers relevant NPC, codex, Blood Mirror, Heart, or hub updates.

The results flow must clearly distinguish retained progress from burned-away run state.

## Persistence matrix

| Category | After death | After Binding completion |
|---|---:|---:|
| Narrative and codex progress | Persists | Persists |
| Destroyed Heart Bindings | Persists | Persists |
| Permanent upgrades | Persists | Persists |
| Unlocked Blood Aspects | Persists | Persists |
| Blood Mirror progress | Persists | Persists |
| Techniques unlocked into future pools | Persists | Persists |
| Mist, Scrolls, Boss Emblems | Persists | Persists |
| Blood Aspect Tier | Resets | Resets |
| Corruption | Resets | Resets |
| Active and reserve Techniques | Resets | Resets |
| Technique refinements | Resets | Resets |
| Run-scoped Relic effects | Resets | Resets |
| Gold | Resets | Resets |
| Room progress | Resets | Resets |
| Consumables | Item-specific | Item-specific |

## Design rules

- Persistent growth improves options and reliability, not automatic victory.
- Run growth should establish a meaningful build before Area 3.
- Blood Aspect remains more identity-defining than any single Technique.
- Techniques remain independently useful.
- Permanent Aspect upgrades stay small and capped.
- Gold never becomes a persistent Strand wallet without an explicit system change.
- Unlocks and numerical balance values are documented separately.

## Current production dependencies

1. Scope the launch run-build content catalog so the total unlockable content is known.
2. Scope the persistent progression, onboarding, and trial package around that catalog and the approved service boundaries.

Exact upgrade percentages, currency costs, timing windows, and reward values remain later implementation and balance work.