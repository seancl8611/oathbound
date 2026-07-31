---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-07-31
topics:
  - progression
  - persistence
  - bloodwell
  - blood-mirror
  - forge
  - trials
  - currencies
  - blood-resource
  - heart-bindings
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-CORRUPTION-SHRINES
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

- selected Blood Aspect and current Tier,
- Corruption,
- Blood after Tier II,
- Blood Art readiness or active state,
- four active Techniques and one reserve,
- Technique refinements,
- temporary Prosthetic Techniques,
- one run-scoped Relic,
- Gold,
- room progress,
- temporary Health or Spirit capacity,
- approved consumables,
- and encounter rewards.

These states reset after failed death-return or successful Heart Binding completion unless an item explicitly defines another rule.

## Fixed Blood Aspect Tier path

The selected Aspect follows one fixed Tier path during the run. It is not a branching skill tree or package-selection system.

- Every run begins at **Tier 0**.
- Corruption controls access to Shrine decisions.
- At a full threshold, the player chooses **Resist** or **Embrace**.
- Resist keeps the current Tier, lowers Corruption, and grants approved immediate support.
- Embrace advances the selected Aspect by one fixed Tier.
- Each Tier has one headline benefit and at most one minor supporting rule.
- Each Aspect has one evolving drawback family rather than unrelated penalties accumulating at every Tier.
- Tier IV is the maximum.
- At Tier IV, a full threshold offers **Stabilize** instead of Tier V or further scaling.

The meaningful choice is whether to accept the next Tier and its danger now. The player does not choose between alternate upgrade branches when advancing.

Wolf's current fixed path is approved as a working draft:

- Tier I — Blood Tempo,
- Tier II — Dire Hunt and Blood Fang,
- Tier III — Fanged Guard,
- Tier IV — Apex Feast.

Wraith's current path is approved through Tier II as a working draft:

- Tier I — Pale Barrage,
- Tier II — movable spinning Blood Art, final name unresolved.

Wraith Tier III-IV and Ronin Tier I-IV remain the next Tier-package design work. Wolf and Wraith may be revisited after cross-roster comparison or playable testing, but their recorded Tiers are not unresolved blanks.

## Blood persistence boundary

Blood is a run-only combat resource owned by the Blood Aspect system.

- Blood is unavailable before Tier II.
- Blood is not a persistent wallet, meta currency, shop currency, route resource, or campaign collectible.
- Stored Blood persists between rooms until it is spent or the run ends.
- Blood and Blood Art state reset after death or successful completion.
- Permanent progression cannot create stored Blood between runs or make Blood available before the approved in-run unlock.
- Any permanent upgrade affecting starting Blood, capacity, gain, activation, or Blood Art availability requires explicit system approval.

The working launch defaults are a shared Blood-meter framework, generation through meaningful katana Health damage and enemy-posture pressure plus successful Parry Counters, posture breaks, and deathblows, full-meter manual activation, and no Blood generation during a duration-based Blood Art. These are not absolute restrictions; an approved Aspect package may depart from a default when its identity clearly requires the exception.

Wolf's working Blood direction follows those defaults: meaningful sword damage, posture breaks, Fang Reversal after a parry, and deathblows build Blood; Dire Hunt requires a full meter, activates manually, consumes the stored Blood, and prevents Blood generation while active.

Wraith's working Blood direction also follows those defaults: the Tier II spinning Art requires a full meter, activates manually, consumes the stored Blood, and prevents Blood generation while its fixed sequence resolves. The Art allows slow continuous steering, repeatedly interrupts ordinary enemies without knockback, does not force-stagger elites, and leaves Akio unable to defend while connected attacks deal direct Health damage. Enemy attacks cannot interrupt or stagger Akio out of the Art.

Exact Blood capacity, source weighting, gain values, activation cost, rotation count, duration, spin speed, movement speed, radius, damage, posture pressure, collision behavior, enemy-response cadence, and anti-farming thresholds remain tuning work. Wraith's Tier III-IV interactions, final Blood Art name, and Ronin's Blood Art remain unresolved.

## Persistent character progression

The Strand supports permanent growth through:

- **Bloodwell:** broad meta progression,
- **Forge Bench:** weapon and prosthetic development,
- **Blood Mirror:** Aspect unlocks, mastery, and small capped reliability upgrades,
- **Blood Cavern:** teaching, fixed-loadout trials, mastery challenges, and approved unlocks,
- **Discovery Board:** codex and recovered history,
- **Merchant and NPC services:** approved stock or service progression,
- **Mist, Scrolls, and Boss Emblems:** persistent currencies.

Permanent progression may improve options, reliability, and resilience. It must not remove the need to read combat, replace run-build choices, bypass Embrace danger, or pre-equip major run-only power.

No separate duplicate Blood Art upgrade tree beneath each Aspect is currently approved. Any future Blood Art meta progression must be justified as part of a broader game-wide system rather than repeating the same subsystem for Wolf, Wraith, and Ronin.

The service ownership boundaries are approved. The remaining production decision is the minimum launch package: approximate nodes or ranks, onboarding and trial counts, unlock mapping, mastery content, rewards, and required interface states.

## Persistent campaign progression

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding before the game, leaving six intact.

Each successful Binding run:

- destroys one remaining Binding,
- permanently preserves that progress,
- exposes more of the Heart,
- updates campaign presentation,
- and moves the story toward the final Heart route.

Failed runs do not advance the count.

After the sixth remaining Binding is destroyed, the next successful full run becomes the seventh and final story run. It continues from the Shogun into the Heart without another Binding ritual.

Destroyed Binding progress is not a currency, cannot be purchased, and cannot be lost.

## Currency ownership

| Currency | Persistence | Primary owner |
|---|---|---|
| Mist | Persistent | Broad meta progression |
| Scroll | Persistent | Forge upgrades |
| Boss Emblem | Persistent | Rare major gates or high-value nodes |
| Gold | Run-only | Shops and run economy |

Currency ownership is resolved. Exact costs remain balance work.

Corruption, Blood, and destroyed Heart Bindings are not currencies. `Mist Shards` is deprecated unless intentionally restored as a separate denomination.

## Blood Aspect persistence

- Unlocked Aspects persist as loadout choices.
- Every run begins at Tier 0.
- Tier and Corruption reset after the run.
- Blood is unavailable before Tier II, persists between rooms after it is unlocked, and resets after the run.
- Blood Art readiness, activation, and temporary effects reset after the run.
- Blood Mirror mastery and small permanent reliability upgrades persist.
- Permanent Aspect upgrades cannot replace the fixed in-run Embrace Tier system.

## Technique persistence

- Four active slots and one reserve begin empty each run.
- Active Techniques, reserve, and refinements reset after the run.
- Discarded or overwritten Techniques are not restored during the same run.
- Permanent progression may unlock Techniques into future reward pools.
- Permanent progression does not pre-equip a run Technique or increase slot capacity in initial scope.

The exact unlock mapping depends on the launch Technique catalog and persistent progression package.

## Prosthetic progression

- The Forge owns permanent prosthetic unlocks, baseline improvements, and long-term branches.
- The run owns temporary Prosthetic Techniques and refinements for the equipped tool.
- Permanent upgrades must not make temporary specialization irrelevant or replace sword combat.

## Trial reward boundary

Blood Cavern and Blood Mirror rewards may grant:

- Blood Aspect access,
- Technique-pool unlocks,
- small timing or recovery reliability improvements,
- modest posture reliability,
- persistent currency,
- cosmetics,
- lore reflections,
- and mastery marks.

Trials may not:

- add new Blood Aspect Tiers,
- remove Embrace danger,
- create alternate Tier branches,
- permanently pre-equip a Technique,
- create a persistent Blood balance,
- or create permanent versions of major run-only mechanics.

## Return processing

Both failed and successful runs reconstruct Akio at the Strand through Returning Blood.

A successful Binding return additionally:

1. saves destroyed-Binding progress and permanent rewards,
2. clears run-only state, including Blood and Blood Art state,
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
| Blood and Blood Art state | Resets | Resets |
| Active and reserve Techniques | Resets | Resets |
| Technique refinements | Resets | Resets |
| Run-scoped Relic effects | Resets | Resets |
| Gold | Resets | Resets |
| Room progress | Resets | Resets |
| Consumables | Item-specific | Item-specific |

## Design rules

- Persistent growth improves options and reliability, not automatic victory.
- Run growth should establish a meaningful build before Area 3.
- The Blood Aspect remains more identity-defining than any single Technique.
- Techniques remain independently useful.
- Permanent Aspect upgrades stay small and capped.
- Gold never becomes a persistent Strand wallet without an explicit system change.

## Current production dependencies

1. Define Wraith's Tier III-IV benefits, evolving drawback family, final Blood Art name, and any later interactions with Pale Barrage or the Art.
2. Define Ronin's fixed Tier I-IV benefits, drawback family, Blood Art, and any justified exceptions to the shared Blood defaults.
3. Compare Wolf, Wraith, and Ronin for power, accessibility, production cost, drawback severity, and Technique overlap.
4. Scope the launch run-build content catalog.
5. Scope persistent progression, onboarding, and trials around those approved systems.

Exact upgrade percentages, resource values, costs, timing windows, and reward values remain implementation and balance work.
