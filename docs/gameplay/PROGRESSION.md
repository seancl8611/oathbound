---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-09
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
- Blood Art state,
- five core slotted Techniques,
- slotless supporting Techniques,
- Technique refinements and rare replacement state,
- one run-scoped Relic,
- Gold,
- room progress,
- temporary Health or Spirit capacity,
- approved consumables and encounter rewards.

Prosthetic progression is not part of the temporary Technique build.

These run states reset after failed death-return or successful completion unless explicitly defined otherwise.

## Run-build investment model

The selected Aspect defines Akio's weapon foundation from Tier 0. Deeper Aspect investment is optional and competes with Technique, Relic, economy, survival, and other reward routes.

Expected viable outcomes:

- **Technique-focused:** Tier 0-I with a strong coherent Technique build.
- **Hybrid:** Tier II with a solid Technique build.
- **Aspect-focused:** Tier III with less-developed horizontal upgrades.
- **High-roll:** Tier IV plus a strong completed Technique build.

Mandatory encounters must not assume a particular Tier, Blood Art, Technique family, or Legendary.

## Fixed Blood Aspect Tier path

- Every run begins at **Tier 0**.
- Full Corruption creates a Shrine choice between **Resist** and **Embrace**.
- Resist keeps the current Tier and provides approved stabilization support.
- Embrace advances the selected Aspect by one fixed Tier.
- Each Tier has one headline benefit and at most one minor supporting rule.
- Tier IV is the maximum; later thresholds offer **Stabilize** rather than Tier V.
- Higher Tiers remain net-positive while preserving the weapon kit's inherent risks.

### Locked Aspect paths

| Tier | Wolf | Wraith | Ronin |
|---|---|---|---|
| **I** | Blood Tempo | Pale Barrage | Steadfast Reprisal |
| **Repeated growth** | Feral Momentum | Spectral Edge | Maximum player-posture capacity |
| **II** | Blood Hunt / Blood Fang | Wraith's Reach | Falling Mountain / Deep Rupture |
| **III** | Fanged Guard | Spectral Passage | Unbroken Resolve / Measured Weight / Perfect Weight |
| **IV** | Apex Mauling | Beyond the Veil | Shattering Wake |

All three Tier 0-IV packages are locked at current qualitative paper-design depth. Exact numerical growth remains balance work.

## Blood persistence boundary

Blood is run-only and unavailable before Tier II.

- Stored Blood persists between rooms until spent or the run ends.
- Blood and Blood Art state reset after death or successful completion.
- Permanent progression cannot pre-store Blood or unlock it before Tier II.
- Blood Arts normally require a full meter, activate manually, consume the meter, and do not generate Blood while resolving.
- Generation is weighted around meaningful combat contribution.

Approved Blood Art forms remain distinct:

- **Wolf — Blood Hunt:** limited activation healing/disruption followed by one pursuit line and Blood Fang.
- **Wraith — Wraith's Reach:** frontal sweep, long fixed corridor, delayed same-geometry echo.
- **Ronin — Falling Mountain:** partial posture relief, planted slam, compact burst, delayed fixed-point Deep Rupture.

Exact capacity, gain weighting, timing, damage, interruption rules, and anti-farming thresholds remain tuning work in the owning Aspect files.

## Technique development boundary

The run begins with five empty core Technique slots tied to:

- Basic Attack,
- Held Attack,
- Dash,
- Parry / Counter,
- Deathblow.

Each slot can hold one direct Technique. Direct Techniques do not stack within the same core action.

Technique progression can continue beyond those five choices through slotless supporting Techniques, one small refinement per eligible slotted Technique, rare same-slot replacement offers, family synergy, and eligible higher-rarity or Legendary effects.

There is no global cap on total Technique upgrades. The practical cap comes from Technique reward opportunities, route choices, rarity, prerequisites, and run length.

The current design pass is focused on stabilizing the five core family mechanics before rebuilding the supporting and refinement layers.

## Persistent character progression

The Strand supports permanent growth through:

- **Bloodwell:** broad meta progression,
- **Forge Bench:** weapon and Prosthetic development,
- **Blood Mirror:** Aspect unlocks, mastery, and small capped reliability upgrades,
- **Blood Cavern:** teaching, fixed-loadout trials, mastery challenges, and approved unlocks,
- **Discovery Board:** codex and recovered history,
- **Merchant and NPC services:** approved stock or service progression,
- **Mist, Scrolls, and Boss Emblems:** persistent currencies.

Permanent progression improves options, reliability, and resilience. It must not guarantee high Aspect Tier, replace run-build choices, pre-equip major run-only power, or remove the need to read combat.

No duplicate Blood Art upgrade tree beneath each Aspect is approved.

## Persistent campaign progression

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding before the game, leaving six intact.

Each successful Binding run destroys one remaining Binding and permanently preserves that progress. Failed runs do not advance the count.

After the sixth remaining Binding is destroyed, the next successful full run becomes the seventh and final story run, continuing from the Shogun into the Heart.

Destroyed Binding progress is not a currency and cannot be lost.

## Currency ownership

| Currency | Persistence | Primary owner |
|---|---|---|
| Mist | Persistent | Broad meta progression |
| Scroll | Persistent | Forge upgrades, including Prosthetics |
| Boss Emblem | Persistent | Rare major gates or high-value nodes |
| Gold | Run-only | Shops and run economy |

Corruption, Blood, and destroyed Heart Bindings are not currencies. `Mist Shards` remains deprecated unless intentionally restored.

## Persistence boundaries

### Blood Aspects

- Unlocked Aspects persist as loadout choices.
- Every run begins at Tier 0.
- Tier and Corruption reset after the run.
- Blood is unavailable before Tier II and resets after the run.
- Blood Mirror mastery and small permanent reliability upgrades persist.
- Permanent upgrades cannot replace the fixed in-run Embrace path.

### Techniques

- Five core combat slots begin empty each run.
- Slotted Techniques, supporting Techniques, refinements, and replacement state reset after the run.
- Permanent progression may unlock Techniques into future pools but does not pre-equip them.
- Initial scope does not include permanent expansion beyond the five core combat slots.

### Prosthetics

- The Forge owns Prosthetic unlocks and permanent individual tool improvements.
- Prosthetics do not receive a separate temporary Technique layer during runs.

## Trial reward boundary

Blood Cavern and Blood Mirror rewards may grant Aspect access, Technique-pool unlocks, small capped reliability improvements, modest posture reliability, persistent currency, cosmetics, lore reflections, and mastery marks.

Trials may not add alternate Aspect Tiers, permanently pre-equip a Technique, create persistent Blood, or convert major run-only mechanics into permanent baseline power.

## Return processing

Both failed and successful runs reconstruct Akio at the Strand through Returning Blood.

A successful Binding return additionally:

1. saves Binding progress and permanent rewards,
2. clears run-only state,
3. presents a results summary,
4. triggers relevant hub, codex, Blood Mirror, and Heart updates.

## Persistence matrix

| Category | After death | After completion |
|---|---:|---:|
| Narrative/codex progress | Persists | Persists |
| Destroyed Bindings | Persists | Persists |
| Permanent upgrades/unlocks | Persists | Persists |
| Persistent currencies | Persists | Persists |
| Blood Aspect Tier | Resets | Resets |
| Corruption | Resets | Resets |
| Blood and Blood Art state | Resets | Resets |
| Techniques/refinements | Resets | Resets |
| Run Relic effects | Resets | Resets |
| Gold | Resets | Resets |
| Room progress | Resets | Resets |
| Consumables | Item-specific | Item-specific |

## Current production dependencies

1. Finish the five core Technique-family mechanics and direct slotted roster.
2. Scope remaining run-build content: Relics and consumables.
3. Scope permanent Prosthetic progression together with the broader Forge package.
4. Scope persistent progression, onboarding, and trials.
5. Lock the authored narrative-delivery package.
6. Lock postgame release scope.

Exact percentages, combat values, resource values, costs, timing windows, offer rates, replacement rates, and reward values remain implementation and balance work.
