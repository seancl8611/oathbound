---
id: GAMEPLAY-PROGRESSION
title: Progression
category: gameplay
status: approved
authority: primary
last_reviewed: 2026-08-16
topics:
  - progression
  - persistence
  - bloodwell
  - blood-mirror
  - forge
  - trials
  - currencies
  - blood-resource
  - relics
  - run-infrastructure
  - heart-bindings
related:
  - GAMEPLAY-RUN-STRUCTURE
  - GAMEPLAY-BLOOD-ASPECTS
  - GAMEPLAY-CORRUPTION-SHRINES
  - GAMEPLAY-TECHNIQUES
  - GAMEPLAY-RELICS
  - GAMEPLAY-BLOOD-CAVERN-TRIALS
  - GAMEPLAY-PROSTHETICS
  - GAMEPLAY-ITEMS-REWARDS
  - CONTENT-STRAND-INTERACTIBLES
  - META-OPEN-QUESTIONS
---

# Progression

Oathbound uses three connected progression layers:

1. run-only build progression,
2. persistent progression between runs,
3. persistent campaign progression.

Every system and item family must state whether it survives death and successful completion.

## Run-only progression

Temporary run state may include the selected Blood Aspect and current Tier, Corruption, Blood after Tier II, Blood Art state, five core slotted Techniques, slotless Supporting / Cross-family / Legendary Techniques, Technique refinements and replacement state, the currently equipped Relic benefit, Gold, room progress, temporary Health or Spirit capacity, and approved consumables or encounter rewards.

Prosthetic progression and Relic permanent progression are not part of the temporary Technique build. Relic collection, mastery, and permanent progression persist even though the equipped Relic benefit is active only while equipped during a run.

These run states reset after failed death-return or successful completion unless explicitly defined otherwise.

## Run-build investment model

The selected Aspect defines Akio's weapon foundation from Tier 0. Deeper Aspect investment is optional and competes with Technique, Relic, economy, survival, and other reward routes.

Expected viable outcomes:

- **Technique-focused:** Tier 0-I with a strong coherent Technique build.
- **Hybrid:** Tier II with a solid Technique build.
- **Aspect-focused:** Tier III with less-developed horizontal upgrades.
- **High-roll:** Tier IV plus a strong completed Technique build.

Mandatory encounters must not assume a particular Tier, Blood Art, Technique family, Legendary, Relic, or highly upgraded Prosthetic.

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

The run begins with five empty core Technique slots tied to Basic Attack, Held Attack, Dash, Parry / Counter, and Deathblow. Each slot can hold one direct Technique.

Technique progression can continue through slotless same-family Supporting Techniques, Cross-family Techniques, family Legendaries, one refinement per eligible slotted Technique, and rare same-slot replacement offers.

There is no global cap on total Technique upgrades. The practical cap comes from Technique reward opportunities, route choices, rarity, prerequisites, and run length.

The five core family mechanics—Echo, Rupture, Seal, Rift, and Crimson Vulnerable / backstab / direct Health damage—are defined at qualitative core-rule depth. The current launch Technique roster contains 50 actual Techniques plus 10 refinements and is complete for current paper-design scope.

Techniques may be permanently unlocked into future reward pools, but their active run build and power reset after each run. Techniques do not receive a separate permanent stat-upgrade tree in the current scope.

# Permanent upgrade architecture

Current launch scope uses **three permanent upgrade stations** in the Strand.

## Bloodwell — Akio + Run Infrastructure

The Bloodwell owns two broad persistent upgrade categories:

### Akio

Akio's permanent progression applies universally rather than to one particular Aspect, Technique family, Prosthetic, or Relic.

The exact Akio upgrade roster, node count, values, and layout remain later detailed design.

### Run Infrastructure

Run Infrastructure is one umbrella meta-progression system covering permanent improvements to the support and conditions surrounding future runs.

Its allowed scope may include:

- Rest-room support,
- Shrine support that does not bypass the fixed Tier path,
- reward possibilities and special reward support,
- route information or other routing support,
- regional-transition recovery or preparation,
- beneficial run-condition support,
- and other approved expedition-support improvements.

Run Infrastructure is **not** split into separate permanent Rest, Shrine, reward, or route upgrade systems at current scope.

It must not:

- grant permanent Aspect Tiers,
- unlock Blood before Tier II,
- replace Technique choices,
- upgrade a particular Prosthetic or Relic,
- or remove the need to read and execute combat.

## Forge Bench — Prosthetics + Relics

The Forge Bench owns permanent progression for both **Prosthetics and Relics**.

### Prosthetics

The eight launch Prosthetics are permanent tactical tools developed through shallow linear Forge paths.

- A Prosthetic is functionally complete when unlocked.
- Two upgrades are the default; a third is used only when the base tool already has multiple existing properties worth improving.
- Upgrades improve existing properties only and do not add a new tactical role, alternate active ability, unrelated status family, or second moveset.
- One Prosthetic is equipped at a time in the current launch structure.
- Scrolls remain the primary persistent currency for Prosthetic development.

Locked qualitative paths:

- **Beast-Bane Whistle:** stronger interrupt/stagger → larger pulse radius.
- **Thunder Rod:** stronger direct hit → longer Shock.
- **Smoke Gourd:** larger cloud → longer persistence.
- **Fang Harpoon:** greater eligible pull → stronger interruption/posture impact.
- **Mirror Umbrella:** greater pressure storage → improved Spirit efficiency → stronger posture release.
- **Flame Vent:** greater cone reach → stronger direct Health damage → longer Burn.
- **Mist Raven:** improved Spirit efficiency → modestly greater fixed short-range blink distance.
- **Bloodletting Gourd:** stronger immediate heal → longer healing-on-hit window → stronger healing-on-hit return.

Exact percentages, costs, resource values, damage, status values, and timing remain implementation/playtest work.

### Relics

Relics use persistent collection, mastery, and permanent progression while remaining a small supporting layer.

- Akio may equip one Relic at a time.
- Unlocked or discovered Relics persist in the collection.
- The equipped Relic provides its benefit during the run.
- Only the currently equipped Relic gains persistent mastery from eligible enemy kills.
- Switching during approved transition opportunities redirects later mastery progress to the newly equipped Relic.
- Earned mastery is never lost when switching or when a run ends.
- Mastery strengthens the existing Relic benefit rather than adding branching or unrelated mechanics.
- The **Forge Bench** is the Strand owner for Relic progression, collection management, and upgrade presentation.

Relics do not need to use the same progression method or currency as Prosthetics merely because they share a station. Exact mastery ranks, thresholds, Forge presentation, costs if any, and transition-swap timing remain later detailed design.

No separate Relic Reliquary is part of the approved upgrade-station scope.

## Blood Mirror — Blood Aspects

The Blood Mirror owns permanent progression for **Blood Aspects**.

The Blood Mirror begins **locked at the start of the game** and becomes available later through campaign/onboarding progression. The exact unlock event remains deferred.

Permanent Aspect progression, if included in the final detailed tree, remains small, capped, and reliability-focused. It cannot:

- grant major Tier mechanics early,
- bypass the fixed Embrace path,
- unlock Blood before Tier II,
- reproduce run-only Tier growth as uncapped permanent scaling,
- or remove a kit's inherent tradeoffs.

No duplicate Blood Art upgrade tree beneath each Aspect is approved.

## Non-upgrade persistent systems

The following may persist or unlock content but are **not separate permanent upgrade stations/trees** in current scope:

- Technique pool unlocks,
- Blood Cavern trial completion and mastery flags,
- Discovery Board / codex progress,
- Merchant stock and service state unless explicitly expanded later,
- narrative discoveries,
- destroyed Heart Bindings,
- and story/postgame state.

The Blood Cavern is a training/trial space. The Discovery Board is a knowledge archive. The Merchant is a purchasing service. The Boat is a run-start confirmation point.

## Persistent campaign progression

The Heart's prison originally contained seven Bindings. The Court destroyed the outermost Binding before the game, leaving six intact.

Each successful Binding run destroys one remaining Binding and permanently preserves that progress. Failed runs do not advance the count.

After the sixth remaining Binding is destroyed, the next successful full run becomes the seventh and final story run, continuing from the Shogun into the Heart.

Destroyed Binding progress is not a currency and cannot be lost.

## Currency ownership

| Currency | Persistence | Primary role |
|---|---|---|
| Mist | Persistent | Broad meta progression, including Bloodwell-owned progression |
| Scroll | Persistent | Forge-focused Prosthetic development |
| Boss Emblem | Persistent | Rare major progression gates where explicitly assigned |
| Gold | Run-only | Shops and run economy |

Corruption, Blood, Relic mastery, and destroyed Heart Bindings are not currencies. `Mist Shards` remains deprecated unless intentionally restored.

Sharing a station does not automatically imply sharing a currency. Exact resource allocation for unresolved detailed nodes remains later design work.

## Persistence boundaries

### Blood Aspects

- Unlocked Aspects persist as loadout choices.
- Every run begins at Tier 0.
- Tier, Corruption, and Blood reset after the run.
- Blood Mirror permanent progression persists after the Mirror is unlocked.
- Permanent upgrades cannot replace the fixed in-run Embrace path.

### Techniques

- Five core combat slots begin empty each run.
- Slotted, Supporting, Cross-family, Legendary Techniques, refinements, and replacement state reset after the run.
- Permanent progression may unlock Techniques into future pools but does not pre-equip them or permanently increase their run power.

### Relics

- Relic collection ownership, mastery, and permanent progression persist.
- One Relic is equipped at a time.
- The equipped effect is run-active.
- Only the equipped Relic receives eligible kill progress.
- Relics do not occupy Technique or Prosthetic slots.
- The Forge Bench owns Strand-side Relic progression and management.

### Prosthetics

- Prosthetic unlocks and Forge upgrades persist.
- The Forge owns permanent individual tool improvements.
- Prosthetics do not receive a separate temporary Technique layer during runs.

### Run Infrastructure

- Purchased or unlocked Run Infrastructure improvements persist.
- They affect approved future-run support conditions without carrying current run-only build state between attempts.

## Trial reward boundary

Blood Cavern and Blood Mirror rewards may grant Aspect access, Technique-pool unlocks, small capped reliability improvements, persistent currency, cosmetics, lore reflections, mastery marks, or approved Relic unlocks where later content design assigns them.

Trials may not add alternate Aspect Tiers, permanently pre-equip a Technique, create persistent Blood, or convert major run-only mechanics into permanent baseline power.

## Return processing

Both failed and successful runs reconstruct Akio at the Strand through Returning Blood.

A successful Binding return additionally saves Binding progress and permanent rewards, clears run-only state, presents a results summary, and triggers relevant hub, codex, Blood Mirror, and Heart updates.

Relic mastery earned from eligible kills is saved regardless of whether the run ultimately succeeds or fails.

## Persistence matrix

| Category | After death | After completion |
|---|---:|---:|
| Narrative/codex progress | Persists | Persists |
| Destroyed Bindings | Persists | Persists |
| Permanent upgrades/unlocks | Persists | Persists |
| Run Infrastructure upgrades | Persists | Persists |
| Relic collection/mastery/progression | Persists | Persists |
| Persistent currencies | Persists | Persists |
| Blood Aspect Tier | Resets | Resets |
| Corruption | Resets | Resets |
| Blood and Blood Art state | Resets | Resets |
| Techniques/refinements | Resets | Resets |
| Equipped Relic benefit | Ends with run | Ends with run |
| Gold | Resets | Resets |
| Room progress | Resets | Resets |
| Consumables | Item-specific | Item-specific |

## Current design dependency

The permanent upgrade-station architecture is now scoped at the level needed for full-game planning:

- Bloodwell → Akio + Run Infrastructure,
- Forge Bench → Prosthetics + Relics,
- Blood Mirror → Blood Aspects, unlocked later.

Exact nodes, values, rank counts, costs, mastery thresholds, interface layouts, and precise unlock timing are intentionally deferred.

The next broad design task is to verify whether **every major launch system is scoped at production level**, then proceed into full-run integration, rewards, encounters, pacing, narrative delivery, and release/postgame scope as needed.
