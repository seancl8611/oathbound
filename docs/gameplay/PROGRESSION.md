---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-05
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

## Run-build investment model

The selected Blood Aspect is Akio's central weapon foundation from Tier 0, but deeper Aspect Tier advancement is one optional run-development route rather than a mandatory checklist.

Run power may be developed through:

- Aspect Tier advancement at Shrines,
- Technique acquisition, replacement, rarity, reserve management, and refinement,
- a Relic,
- temporary Prosthetic specialization,
- economy and shop routing,
- survival and temporary capacity,
- and approved encounter rewards.

Most runs may combine these routes. The player does not choose a permanent Technique class or Aspect class at the beginning; the run's emphasis may change in response to rewards.

## Fixed Blood Aspect Tier path

The selected Aspect follows one fixed Tier path during the run. It is not a branching skill tree or package-selection system.

- Every run begins at **Tier 0**.
- Corruption controls access to Shrine decisions.
- At a full threshold, the player chooses **Resist** or **Embrace**.
- Resist keeps the current Tier, lowers Corruption, and grants approved immediate support.
- Embrace advances the selected Aspect by one fixed Tier.
- Each Tier has one headline benefit and at most one minor supporting rule.
- Every Tier is clearly net-positive and preserves the Aspect's inherent weapon-kit limitations through the upgraded action itself.
- Separate named drawback families and added penalty attributes are not required.
- Tier IV is the maximum.
- At Tier IV, a full threshold offers **Stabilize** instead of Tier V or further scaling.

The main opportunity cost occurs when routing into a Shrine instead of another previewed reward. Resist is a recovery and pacing option rather than an equal alternate power path.

Expected power routes:

- **Technique-focused:** Tier 0-I with a strong, coherent, refined Technique loadout remains capable of completing the run.
- **Hybrid:** Tier II with a solid Technique build is a common successful state.
- **Aspect-focused:** Tier III with fewer or less-developed Technique upgrades is a valid deliberate specialization.
- **High-roll:** Tier IV with an ideal completed Technique build is exceptional rather than the expected baseline.

Mandatory encounters must not assume a specific Tier or Blood Art. Tier II may be common without being required.

Wolf's fixed path is approved through the present audit:

- Tier I — Blood Tempo,
- Feral Momentum — deterministic later-sequence Health and enemy-posture growth at every Embrace,
- Tier II — Blood Hunt and Blood Fang,
- Tier III — Fanged Guard,
- Tier IV — Apex Mauling.

Ronin's fixed path is approved through the present audit:

- Tier I — Steadfast Reprisal,
- Tier II — Falling Mountain and Deep Rupture,
- Tier III — Unbroken Resolve with Measured Weight and Perfect Weight,
- Tier IV — Shattering Wake.

Wraith retains a complete working draft but its foundation and progression are under ordered revision:

- current Tier I — Pale Barrage,
- current Tier II — Wraith's Reach,
- current Tier III — Veiled Guard,
- current Tier IV — Pale Procession.

Wraith Tier 0 must be settled before its Blood Art or later Tier distribution is relocked. Wolf and Ronin may receive only focused follow-up changes during the final comparison rather than being treated as blank Tier packages.

## Technique development boundary

Technique capacity remains four active slots plus one inactive reserve. Filling the four active slots does not complete the Technique route.

Later Technique development may include:

- replacing a weaker or poorly fitting Technique,
- acquiring a rarer or more specialized Technique,
- refining an active Technique once,
- preserving an alternate Technique in reserve,
- specializing the equipped Prosthetic,
- correcting an exposed weakness,
- or pivoting around a Relic or another reward.

A successful run should commonly fill its active slots during Area 2, then use later decisions to refine and finalize the build. Exact desired four-Technique loadouts and all desired refinements should remain uncommon until late in the run, while occasional early high-roll builds are allowed.

## Blood persistence boundary

Blood is a run-only combat resource owned by the Blood Aspect system.

- Blood is unavailable before Tier II.
- Blood is not a persistent wallet, meta currency, shop currency, route resource, or campaign collectible.
- Stored Blood persists between rooms until it is spent or the run ends.
- Blood and Blood Art state reset after death or successful completion.
- Permanent progression cannot create stored Blood between runs or make Blood available before the approved in-run unlock.
- Any permanent upgrade affecting starting Blood, capacity, gain, activation, or Blood Art availability requires explicit system approval.
- Runs that do not reach Tier II remain viable without Blood or a Blood Art.

The working launch defaults are a shared Blood-meter framework, generation through meaningful katana Health damage and enemy-posture pressure plus successful Parry Counters, posture breaks, and deathblows, full-meter manual activation, and no Blood generation during a duration-based Blood Art. These are not absolute restrictions; an approved Aspect package may depart from a default when its identity clearly requires the exception.

Wolf's approved direction uses an immediate full-meter action rather than a duration state. Meaningful Wolf sword damage, enemy-posture pressure, Fang Reversal after a parry, posture breaks, and deathblows may build Blood according to the final weighting. Blood Hunt consumes the full meter, immediately provides limited Health recovery and a disruptive Blood howl, then launches one fixed player-directed pursuit ending in Blood Fang. Blood generation resumes after the immediate Art finishes resolving.

Blood Hunt does not clear player posture, grant damage reduction, create lifesteal, or apply a generic moveset buff. Ordinary light hits do not interrupt the launched pursuit but still deal full valid effects; posture-breaking, lethal, perilous, grabbing, launching, or overriding knockdown attacks interrupt normally. Exact source weighting, preparation, travel, collision, stopping priority, recovery, damage, posture, and howl values remain tuning work.

Wraith's Blood direction remains provisional until its Tier 0 revision and Blood Art comparison are complete. The current Wraith's Reach draft uses a full-meter duration state with extended authored geometry and delayed afterimages while retaining ordinary movement, dash, block, parry, attacks, deathblows, and Prosthetic access. It grants no healing, Blood refund, damage reduction, posture clearing, interruption resistance, automatic defense, or special parry reward.

Ronin's approved Blood Art is Falling Mountain. Full-meter activation clears a meaningful portion of accumulated player posture and powers a planted manually aimed slam, compact impact burst, and delayed Deep Rupture at the original point. Its brief planted channel may resist eligible ordinary-hit interruption while full incoming damage and posture remain active; posture break, lethal hits, perilous attacks, grabs, launches, and overriding knockdowns remain normal counters.

Exact Blood capacity, source weighting, gain values, activation cost, Blood Hunt values, Wraith duration or alternative Art behavior, Falling Mountain timing and impact, and anti-farming thresholds remain tuning work.

## Persistent character progression

The Strand supports permanent growth through:

- **Bloodwell:** broad meta progression,
- **Forge Bench:** weapon and prosthetic development,
- **Blood Mirror:** Aspect unlocks, mastery, and small capped reliability upgrades,
- **Blood Cavern:** teaching, fixed-loadout trials, mastery challenges, and approved unlocks,
- **Discovery Board:** codex and recovered history,
- **Merchant and NPC services:** approved stock or service progression,
- **Mist, Scrolls, and Boss Emblems:** persistent currencies.

Permanent progression may improve options, reliability, and resilience. It must not remove the need to read combat, replace run-build choices, guarantee high Aspect Tier, or pre-equip major run-only power.

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
- Permanent Aspect upgrades cannot replace the fixed in-run Embrace Tier system or make high Tier mandatory.

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
- create alternate Tier branches,
- permanently pre-equip a Technique,
- create a persistent Blood balance,
- create permanent versions of major run-only mechanics,
- or make a particular Tier required for ordinary run viability.

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
- Deep Aspect Tier investment remains optional.
- Techniques remain independently useful and can support a complete winning route.
- Permanent Aspect upgrades stay small and capped.
- Gold never becomes a persistent Strand wallet without an explicit system change.

## Current production dependencies

1. Reassess Wraith's Tier 0 weapon kit, then select its Blood Art form and redistribute its later Tiers.
2. Decide Wraith and Ronin small Tier-growth rules and audit narrow Tiers for any justified minor supporting benefit.
3. Perform Ronin's follow-up audit and the final Wolf, Wraith, and Ronin comparison for power, accessibility, production cost, inherent tradeoffs, and Technique overlap across Technique-focused, hybrid, and Aspect-focused runs.
4. Scope the launch run-build content catalog, including rarity, refinements, post-fill offers, and route competition.
5. Scope persistent progression, onboarding, and trials around those approved systems.

Exact upgrade percentages, resource values, costs, timing windows, and reward values remain implementation and balance work.
